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
| Run URL | https://github.com/c4milo/stdx/actions/runs/43625761107 |
| Date | 2026-11-14 |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1. The `TextReader.next_items` column is that helper's queued tokens a slice a call (decision 79), over many tokens a call.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | TextReader.next_items | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1128.6 ± 0.4% | 0.523 | 0.965 | 0.996 | 0.996 | 0.460 | 1.001 | 1.004 | 0.388 | 0.830 | 0.899 | 0.100 |
| qlog records, JSON text sequence | 1467503 | 841.2 ± 1.2% | 0.826 | 1.013 | 1.007 | 1.009 | 0.450 | 1.004 | 1.034 | 0.404 | 0.927 | 0.998 | 0.125 |
| string: silesia/dickens | 172528 | 5048.2 ± 0.3% | 0.033 | 0.782 | 1.003 | 1.004 | 0.196 | 1.017 | 1.006 | 0.196 | 1.003 | 1.003 | 0.032 |
| string: silesia/nci | 1075110 | 4291.0 ± 0.7% | 0.039 | 0.805 | 1.002 | 1.002 | 0.280 | 1.006 | 0.998 | 0.280 | 1.001 | 1.004 | 0.038 |
| string: silesia/reymont | 1075159 | 2930.4 ± 1.5% | 0.057 | 0.818 | 1.001 | 1.011 | 0.359 | 1.009 | 1.009 | 0.359 | 1.009 | 1.012 | 0.056 |
| string: silesia/samba | 97582 | 3490.8 ± 0.3% | 0.040 | 0.862 | 1.004 | 1.006 | 0.069 | 0.780 | 1.011 | 0.073 | 1.003 | 1.006 | 0.039 |
| string: silesia/webster | 1098490 | 3648.3 ± 0.6% | 0.044 | 0.846 | 1.004 | 1.005 | 0.204 | 1.017 | 1.013 | 0.204 | 1.008 | 1.007 | 0.044 |
| string: silesia/xml | 1090118 | 4788.2 ± 0.5% | 0.035 | 0.805 | 1.004 | 1.007 | 0.222 | 0.979 | 1.005 | 0.224 | 1.005 | 1.007 | 0.034 |
| string: canterbury/alice29.txt | 159425 | 4305.9 ± 0.7% | 0.038 | 0.752 | 1.005 | 1.009 | 0.172 | 1.032 | 1.021 | 0.172 | 1.013 | 1.016 | 0.037 |
| string: canterbury/asyoulik.txt | 132198 | 3449.3 ± 1.1% | 0.046 | 0.750 | 1.007 | 1.010 | 0.177 | 1.008 | 0.973 | 0.176 | 1.015 | 1.016 | 0.045 |
| string: canterbury/lcet10.txt | 441884 | 5106.6 ± 0.6% | 0.032 | 0.815 | 1.002 | 1.005 | 0.196 | 1.018 | 1.008 | 0.196 | 1.004 | 1.005 | 0.032 |
| string: canterbury/plrabn12.txt | 503330 | 4089.7 ± 0.6% | 0.040 | 0.830 | 1.005 | 1.006 | 0.201 | 1.018 | 1.006 | 0.200 | 1.007 | 1.007 | 0.040 |
| string: canterbury-large/E.coli | 1048578 | 19160.7 ± 0.4% | 0.077 | 1.011 | 1.010 | 1.008 | 0.481 | 1.010 | 1.008 | 0.481 | 0.621 | 0.622 | 0.009 |
| string: canterbury-large/bible.txt | 1055886 | 6693.9 ± 1.3% | 0.026 | 0.798 | 0.999 | 1.004 | 0.432 | 1.031 | 1.040 | 0.432 | 1.037 | 1.038 | 0.025 |
| string: canterbury-large/world192.txt | 1103121 | 3381.3 ± 0.8% | 0.048 | 0.846 | 1.002 | 1.002 | 0.198 | 1.012 | 1.008 | 0.198 | 1.004 | 1.003 | 0.047 |
| string: http/html-1m | 1058582 | 6058.8 ± 1.6% | 0.028 | 0.783 | 0.998 | 1.037 | 0.389 | 1.046 | 1.054 | 0.389 | 1.027 | 1.029 | 0.028 |
| string: http/json-1m | 1190272 | 2548.1 ± 0.2% | 0.056 | 0.952 | 1.001 | 1.002 | 0.111 | 1.005 | 0.471 | 0.111 | 1.003 | 1.006 | 0.055 |
| string: http/js-1m | 1144362 | 2293.0 ± 0.7% | 0.066 | 0.886 | 1.001 | 1.001 | 0.174 | 1.049 | 1.039 | 0.174 | 0.998 | 0.999 | 0.065 |
| string: http/css-1m | 1097820 | 2634.7 ± 0.5% | 0.061 | 0.778 | 1.007 | 1.009 | 0.241 | 1.008 | 1.016 | 0.240 | 1.008 | 1.011 | 0.060 |
| string: dickens as Cyrillic and CJK | 1883069 | 3067.2 ± 0.4% | 0.044 | 0.125 | 1.005 | 1.005 | 0.337 | 1.002 | 1.007 | 0.337 | 1.007 | 1.007 | 0.044 |
| string: dickens as Cyrillic and CJK, as \u escapes | 5075485 | 1328.5 ± 1.5% | 0.082 | 1.003 | 1.001 | 1.002 | 0.077 | 0.638 | 1.006 | 0.081 | 1.001 | 1.002 | 0.081 |
| hex: silesia/dickens | 524290 | 18704.0 ± 1.9% | 0.079 | 0.983 | 0.978 | 0.975 | 0.507 | 0.976 | 0.980 | 0.505 | 0.642 | 0.642 | 0.009 |
| hex: silesia/mozilla | 524290 | 18509.2 ± 2.4% | 0.080 | 0.997 | 0.980 | 0.977 | 0.510 | 0.990 | 0.990 | 0.510 | 0.647 | 0.647 | 0.009 |
| hex: silesia/mr | 524290 | 18306.5 ± 1.5% | 0.081 | 1.019 | 1.002 | 1.004 | 0.515 | 1.005 | 1.002 | 0.515 | 0.653 | 0.653 | 0.010 |
| hex: silesia/nci | 524290 | 18431.9 ± 2.1% | 0.080 | 1.003 | 0.987 | 0.988 | 0.508 | 0.998 | 0.998 | 0.509 | 0.650 | 0.651 | 0.009 |
| hex: silesia/ooffice | 524290 | 18480.5 ± 0.7% | 0.080 | 0.999 | 0.993 | 0.997 | 0.519 | 1.004 | 0.997 | 0.520 | 0.649 | 0.649 | 0.009 |
| hex: silesia/osdb | 524290 | 17997.8 ± 0.6% | 0.083 | 1.027 | 1.014 | 1.013 | 0.529 | 1.008 | 1.016 | 0.527 | 0.666 | 0.666 | 0.010 |
| hex: silesia/reymont | 524290 | 18611.8 ± 1.6% | 0.080 | 1.007 | 1.000 | 0.999 | 0.526 | 1.000 | 0.994 | 0.527 | 0.646 | 0.646 | 0.009 |
| hex: silesia/samba | 524290 | 17954.3 ± 0.8% | 0.083 | 0.999 | 0.995 | 0.994 | 0.526 | 1.005 | 1.002 | 0.524 | 0.666 | 0.667 | 0.010 |
| hex: silesia/sao | 524290 | 18498.7 ± 0.6% | 0.081 | 1.006 | 1.001 | 0.998 | 0.527 | 0.995 | 1.004 | 0.527 | 0.649 | 0.650 | 0.009 |
| hex: silesia/webster | 524290 | 18418.9 ± 0.6% | 0.081 | 0.999 | 1.004 | 1.003 | 0.516 | 0.994 | 1.006 | 0.515 | 0.652 | 0.652 | 0.010 |
| hex: silesia/x-ray | 524290 | 18537.8 ± 1.4% | 0.080 | 1.010 | 0.993 | 0.993 | 0.530 | 0.991 | 0.996 | 0.526 | 0.647 | 0.647 | 0.009 |
| hex: silesia/xml | 524290 | 18537.0 ± 2.1% | 0.080 | 1.012 | 0.992 | 0.992 | 0.508 | 0.994 | 0.994 | 0.510 | 0.643 | 0.645 | 0.009 |
| hex: canterbury/alice29.txt | 304180 | 19145.6 ± 0.3% | 0.078 | 1.000 | 0.996 | 0.997 | 0.519 | 1.000 | 1.000 | 0.519 | 0.627 | 0.627 | 0.009 |
| hex: canterbury/asyoulik.txt | 250360 | 19550.1 ± 0.1% | 0.077 | 1.002 | 1.002 | 1.002 | 0.513 | 1.002 | 1.002 | 0.514 | 0.614 | 0.614 | 0.009 |
| hex: canterbury/cp.html | 49208 | 19307.6 ± 0.1% | 0.081 | 1.001 | 1.000 | 1.000 | 0.542 | 1.001 | 1.001 | 0.542 | 0.617 | 0.617 | 0.009 |
| hex: canterbury/fields.c | 22302 | 18832.5 ± 0.6% | 0.085 | 1.007 | 1.008 | 1.008 | 0.537 | 1.007 | 1.007 | 0.542 | 0.625 | 0.626 | 0.009 |
| hex: canterbury/grammar.lsp | 7444 | 17470.1 ± 1.1% | 0.088 | 1.008 | 1.008 | 1.008 | 0.529 | 1.007 | 1.008 | 0.547 | 0.644 | 0.647 | 0.010 |
| hex: canterbury/kennedy.xls | 524290 | 17797.8 ± 0.9% | 0.083 | 1.016 | 1.005 | 1.004 | 0.532 | 1.010 | 1.012 | 0.530 | 0.670 | 0.674 | 0.010 |
| hex: canterbury/lcet10.txt | 524290 | 18483.5 ± 0.6% | 0.080 | 1.014 | 1.007 | 1.003 | 0.520 | 0.998 | 0.998 | 0.521 | 0.650 | 0.649 | 0.009 |
| hex: canterbury/plrabn12.txt | 524290 | 18153.3 ± 1.2% | 0.082 | 1.010 | 0.996 | 0.997 | 0.521 | 0.999 | 0.999 | 0.522 | 0.659 | 0.658 | 0.010 |
| hex: canterbury/ptt5 | 524290 | 18195.6 ± 0.6% | 0.082 | 1.005 | 1.002 | 1.001 | 0.522 | 0.998 | 0.994 | 0.525 | 0.659 | 0.659 | 0.010 |
| hex: canterbury/sum | 76482 | 19298.2 ± 0.4% | 0.078 | 1.002 | 1.002 | 1.002 | 0.517 | 1.002 | 1.001 | 0.519 | 0.617 | 0.616 | 0.009 |
| hex: canterbury/xargs.1 | 8456 | 17837.2 ± 0.7% | 0.088 | 1.001 | 1.002 | 1.002 | 0.525 | 1.000 | 1.001 | 0.541 | 0.636 | 0.636 | 0.010 |
| hex: canterbury-large/E.coli | 524290 | 18257.8 ± 1.9% | 0.082 | 1.010 | 1.005 | 1.005 | 0.531 | 1.005 | 1.004 | 0.531 | 0.654 | 0.657 | 0.010 |
| hex: canterbury-large/bible.txt | 524290 | 18677.6 ± 0.7% | 0.080 | 1.002 | 0.997 | 0.992 | 0.511 | 0.994 | 1.004 | 0.506 | 0.644 | 0.643 | 0.009 |
| hex: canterbury-large/world192.txt | 524290 | 17786.0 ± 1.0% | 0.084 | 1.013 | 1.006 | 1.007 | 0.546 | 1.006 | 1.003 | 0.547 | 0.675 | 0.676 | 0.010 |
| hex: http/html-1kx1024 | 2099200 | 10430.1 ± 12.3% | 0.137 | 1.139 | 1.132 | 1.133 | 0.633 | 1.131 | 0.957 | 0.694 | 0.843 | 0.852 | 0.016 |
| hex: http/html-16kx64 | 2097280 | 17855.4 ± 0.4% | 0.084 | 1.019 | 1.018 | 1.019 | 0.574 | 1.019 | 0.983 | 0.578 | 0.659 | 0.659 | 0.010 |
| hex: http/html-1m | 524290 | 18217.0 ± 1.5% | 0.082 | 1.014 | 1.005 | 1.005 | 0.524 | 1.007 | 0.998 | 0.526 | 0.659 | 0.659 | 0.010 |
| hex: http/json-1kx1024 | 2099200 | 9463.9 ± 14.8% | 0.151 | 1.267 | 1.258 | 1.259 | 0.694 | 1.268 | 0.958 | 0.763 | 0.928 | 0.931 | 0.018 |
| hex: http/json-16kx64 | 2097280 | 17949.8 ± 0.8% | 0.083 | 1.016 | 1.010 | 1.011 | 0.570 | 1.012 | 0.976 | 0.575 | 0.656 | 0.655 | 0.010 |
| hex: http/json-1m | 524290 | 18118.8 ± 2.2% | 0.082 | 1.015 | 1.009 | 1.005 | 0.534 | 1.012 | 1.003 | 0.536 | 0.663 | 0.663 | 0.010 |
| hex: http/js-1kx1024 | 2099200 | 9429.7 ± 16.7% | 0.152 | 1.258 | 1.254 | 1.253 | 0.696 | 1.249 | 0.959 | 0.764 | 0.931 | 0.936 | 0.018 |
| hex: http/js-16kx64 | 2097280 | 17796.1 ± 1.1% | 0.084 | 1.024 | 1.017 | 1.019 | 0.577 | 1.020 | 0.983 | 0.581 | 0.661 | 0.661 | 0.010 |
| hex: http/js-1m | 524290 | 18638.2 ± 0.9% | 0.080 | 1.002 | 0.999 | 0.997 | 0.514 | 0.993 | 0.998 | 0.512 | 0.644 | 0.644 | 0.009 |
| hex: http/css-1kx1024 | 2099200 | 9404.9 ± 16.0% | 0.152 | 1.277 | 1.266 | 1.270 | 0.701 | 1.276 | 0.959 | 0.771 | 0.936 | 0.943 | 0.018 |
| hex: http/css-16kx64 | 2097280 | 17905.6 ± 0.6% | 0.082 | 1.015 | 1.011 | 1.011 | 0.572 | 1.012 | 0.978 | 0.577 | 0.657 | 0.657 | 0.010 |
| hex: http/css-1m | 524290 | 18623.8 ± 1.3% | 0.080 | 1.004 | 0.992 | 0.993 | 0.523 | 0.994 | 0.989 | 0.520 | 0.646 | 0.646 | 0.009 |
| hex: shuffled/dickens-1m | 524290 | 17939.3 ± 0.5% | 0.083 | 1.000 | 0.999 | 1.002 | 0.528 | 0.993 | 0.995 | 0.530 | 0.668 | 0.669 | 0.010 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1483.1 ± 0.3% | 0.443 | 1.001 | 0.969 | 1.007 | 1.009 | 0.267 | 1.001 | 0.547 | 0.916 | 0.089 | 1.027 |
| qlog records, JSON text sequence | 1467503 | 1280.9 ± 0.8% | 0.685 | 0.970 | 1.003 | 1.005 | 1.006 | 0.262 | 0.996 | 0.498 | 0.823 | 0.105 | 1.011 |
| string: silesia/dickens | 172528 | 6891.3 ± 0.3% | 0.025 | 1.001 | 1.002 | 1.002 | 1.002 | 0.167 | 0.717 | 1.004 | 1.005 | 0.025 | 1.035 |
| string: silesia/nci | 1075110 | 7317.8 ± 0.3% | 0.023 | 1.000 | 1.000 | 1.000 | 1.002 | 0.212 | 0.565 | 1.000 | 1.000 | 0.024 | 1.009 |
| string: silesia/reymont | 1075159 | 3334.1 ± 1.4% | 0.052 | 1.004 | 1.002 | 1.007 | 1.012 | 0.390 | 0.877 | 1.002 | 1.008 | 0.052 | 1.048 |
| string: silesia/samba | 97582 | 4185.4 ± 0.9% | 0.053 | 1.003 | 1.003 | 1.005 | 1.005 | 0.125 | 0.943 | 1.007 | 1.007 | 0.054 | 1.092 |
| string: silesia/webster | 1098490 | 4049.2 ± 0.4% | 0.042 | 1.013 | 1.009 | 1.009 | 1.008 | 0.213 | 0.888 | 1.000 | 1.006 | 0.043 | 1.008 |
| string: silesia/xml | 1090118 | 6119.1 ± 0.8% | 0.029 | 1.002 | 0.998 | 1.006 | 1.004 | 0.254 | 0.775 | 0.998 | 1.003 | 0.029 | 1.019 |
| string: canterbury/alice29.txt | 159425 | 6412.1 ± 1.0% | 0.027 | 1.010 | 1.012 | 1.013 | 1.013 | 0.133 | 0.655 | 1.005 | 1.008 | 0.027 | 1.065 |
| string: canterbury/asyoulik.txt | 132198 | 5591.9 ± 1.0% | 0.030 | 1.023 | 1.028 | 1.029 | 1.033 | 0.130 | 0.597 | 1.004 | 1.013 | 0.030 | 1.051 |
| string: canterbury/lcet10.txt | 441884 | 6229.7 ± 0.4% | 0.028 | 1.006 | 1.008 | 1.007 | 1.008 | 0.186 | 0.802 | 1.001 | 1.005 | 0.028 | 1.000 |
| string: canterbury/plrabn12.txt | 503330 | 5719.9 ± 0.3% | 0.030 | 1.000 | 1.002 | 0.999 | 1.000 | 0.169 | 0.697 | 1.000 | 1.002 | 0.030 | 1.007 |
| string: canterbury-large/E.coli | 1048578 | 19113.9 ± 1.5% | 0.078 | 1.004 | 1.004 | 1.005 | 1.004 | 0.483 | 1.006 | 1.004 | 1.005 | 0.009 | 1.006 |
| string: canterbury-large/bible.txt | 1055886 | 6788.2 ± 0.5% | 0.026 | 1.000 | 1.000 | 1.001 | 1.002 | 0.495 | 0.970 | 1.001 | 1.003 | 0.026 | 1.001 |
| string: canterbury-large/world192.txt | 1103121 | 4018.0 ± 0.7% | 0.043 | 1.017 | 1.018 | 1.018 | 1.018 | 0.194 | 0.832 | 1.001 | 1.010 | 0.043 | 1.004 |
| string: http/html-1m | 1058582 | 6749.8 ± 0.2% | 0.026 | 1.006 | 0.924 | 1.003 | 1.007 | 0.404 | 0.886 | 1.002 | 1.007 | 0.026 | 1.009 |
| string: http/json-1m | 1190272 | 3157.5 ± 0.3% | 0.051 | 1.001 | 0.968 | 1.003 | 1.003 | 0.133 | 0.371 | 1.000 | 1.004 | 0.051 | 1.042 |
| string: http/js-1m | 1144362 | 2749.4 ± 0.7% | 0.061 | 1.006 | 1.013 | 1.004 | 1.012 | 0.166 | 0.842 | 1.008 | 1.011 | 0.061 | 1.022 |
| string: http/css-1m | 1097820 | 3982.7 ± 0.5% | 0.042 | 1.007 | 1.006 | 1.008 | 1.009 | 0.209 | 0.645 | 0.998 | 1.006 | 0.043 | 1.011 |
| string: dickens as Cyrillic and CJK | 1883069 | 3070.3 ± 0.6% | 0.048 | 1.001 | 0.124 | 1.002 | 1.003 | 0.321 | 1.004 | 1.001 | 1.001 | 0.048 | 1.002 |
| hex: silesia/dickens | 524290 | 15631.4 ± 0.6% | 1.002 | 0.178 | 1.001 | 1.001 | 1.000 | 1.002 | 1.002 | 1.001 | 1.000 | 0.178 | 1.003 |
| hex: silesia/mozilla | 524290 | 15678.1 ± 0.1% | 1.001 | 0.178 | 0.999 | 1.001 | 1.000 | 0.998 | 0.999 | 0.999 | 1.000 | 0.178 | 1.000 |
| hex: silesia/mr | 524290 | 15658.1 ± 0.1% | 0.998 | 0.178 | 1.000 | 1.001 | 1.001 | 0.999 | 1.000 | 0.998 | 0.999 | 0.178 | 1.000 |
| hex: silesia/nci | 524290 | 15672.4 ± 0.2% | 1.001 | 0.178 | 0.998 | 1.001 | 1.001 | 1.000 | 1.001 | 0.999 | 0.998 | 0.177 | 0.999 |
| hex: silesia/ooffice | 524290 | 15631.3 ± 0.2% | 0.999 | 0.178 | 1.001 | 1.000 | 0.999 | 0.996 | 0.994 | 0.996 | 0.995 | 0.178 | 0.995 |
| hex: silesia/osdb | 524290 | 15603.9 ± 0.3% | 1.001 | 0.178 | 1.001 | 1.001 | 1.001 | 1.001 | 1.001 | 1.002 | 1.002 | 0.178 | 0.999 |
| hex: silesia/reymont | 524290 | 15690.3 ± 0.3% | 0.999 | 0.178 | 1.000 | 1.001 | 1.001 | 1.000 | 1.000 | 1.001 | 1.001 | 0.178 | 1.001 |
| hex: silesia/samba | 524290 | 15664.1 ± 0.3% | 1.001 | 0.177 | 0.998 | 1.000 | 0.999 | 1.000 | 0.999 | 1.000 | 0.999 | 0.177 | 0.999 |
| hex: silesia/sao | 524290 | 15651.7 ± 0.1% | 1.000 | 0.177 | 0.998 | 0.998 | 0.997 | 0.995 | 0.996 | 0.995 | 0.995 | 0.177 | 0.996 |
| hex: silesia/webster | 524290 | 15619.7 ± 0.3% | 1.003 | 0.178 | 1.002 | 1.000 | 1.000 | 0.997 | 0.996 | 1.002 | 1.000 | 0.178 | 0.995 |
| hex: silesia/x-ray | 524290 | 15641.4 ± 0.2% | 1.001 | 0.178 | 1.000 | 1.001 | 1.001 | 1.000 | 1.001 | 1.000 | 1.000 | 0.178 | 0.997 |
| hex: silesia/xml | 524290 | 15626.8 ± 0.4% | 1.000 | 0.178 | 0.999 | 0.999 | 0.999 | 1.000 | 1.000 | 0.997 | 0.995 | 0.178 | 0.999 |
| hex: canterbury/alice29.txt | 304180 | 15688.1 ± 0.1% | 1.001 | 0.178 | 1.000 | 1.000 | 1.001 | 1.000 | 1.001 | 1.001 | 1.001 | 0.177 | 1.001 |
| hex: canterbury/asyoulik.txt | 250360 | 15706.4 ± 0.0% | 1.001 | 0.178 | 1.001 | 1.001 | 1.001 | 1.000 | 1.001 | 1.001 | 1.001 | 0.177 | 1.001 |
| hex: canterbury/cp.html | 49208 | 15614.8 ± 0.1% | 1.001 | 0.179 | 1.001 | 1.001 | 1.001 | 0.998 | 1.001 | 1.002 | 1.004 | 0.179 | 1.001 |
| hex: canterbury/fields.c | 22302 | 15435.0 ± 0.1% | 1.002 | 0.181 | 1.000 | 1.000 | 1.000 | 0.995 | 1.000 | 1.002 | 1.006 | 0.180 | 1.001 |
| hex: canterbury/grammar.lsp | 7444 | 14935.2 ± 0.1% | 1.004 | 0.185 | 1.000 | 1.000 | 1.000 | 0.983 | 1.001 | 1.004 | 1.015 | 0.184 | 1.004 |
| hex: canterbury/kennedy.xls | 524290 | 15655.1 ± 0.2% | 1.001 | 0.178 | 1.000 | 1.000 | 1.000 | 1.000 | 1.000 | 1.001 | 1.000 | 0.178 | 1.001 |
| hex: canterbury/lcet10.txt | 524290 | 15649.4 ± 0.2% | 1.002 | 0.177 | 1.000 | 1.000 | 0.999 | 0.999 | 0.998 | 1.000 | 0.999 | 0.177 | 0.999 |
| hex: canterbury/plrabn12.txt | 524290 | 15677.5 ± 0.2% | 1.001 | 0.177 | 1.001 | 1.000 | 1.000 | 1.000 | 1.000 | 1.001 | 0.999 | 0.177 | 1.000 |
| hex: canterbury/ptt5 | 524290 | 15631.5 ± 0.2% | 1.000 | 0.179 | 0.999 | 0.996 | 0.997 | 0.995 | 0.995 | 0.995 | 0.995 | 0.179 | 0.995 |
| hex: canterbury/sum | 76482 | 15641.5 ± 0.1% | 1.001 | 0.179 | 1.000 | 1.000 | 1.000 | 0.999 | 1.000 | 1.001 | 1.002 | 0.178 | 1.001 |
| hex: canterbury/xargs.1 | 8456 | 14988.1 ± 0.1% | 1.003 | 0.185 | 1.000 | 1.000 | 1.000 | 0.986 | 1.000 | 1.005 | 1.014 | 0.184 | 1.003 |
| hex: canterbury-large/E.coli | 524290 | 15663.2 ± 0.2% | 1.001 | 0.177 | 1.001 | 1.001 | 1.001 | 1.000 | 1.001 | 1.001 | 1.001 | 0.178 | 1.001 |
| hex: canterbury-large/bible.txt | 524290 | 15650.3 ± 0.2% | 1.001 | 0.178 | 0.999 | 1.001 | 0.999 | 1.000 | 1.000 | 0.996 | 1.000 | 0.177 | 0.999 |
| hex: canterbury-large/world192.txt | 524290 | 15645.0 ± 0.3% | 1.000 | 0.178 | 1.000 | 0.998 | 1.000 | 0.994 | 0.998 | 0.998 | 0.997 | 0.178 | 0.999 |
| hex: http/html-1kx1024 | 2099200 | 13688.0 ± 0.4% | 1.010 | 0.196 | 1.001 | 1.002 | 1.001 | 0.936 | 0.997 | 1.008 | 1.036 | 0.187 | 1.012 |
| hex: http/html-16kx64 | 2097280 | 15257.1 ± 0.8% | 0.998 | 0.181 | 0.996 | 1.001 | 1.000 | 0.987 | 0.998 | 1.000 | 1.009 | 0.179 | 0.997 |
| hex: http/html-1m | 524290 | 15684.4 ± 0.1% | 1.000 | 0.177 | 1.000 | 1.000 | 1.000 | 1.000 | 1.001 | 0.999 | 1.000 | 0.177 | 0.999 |
| hex: http/json-1kx1024 | 2099200 | 13615.2 ± 0.5% | 1.010 | 0.197 | 1.005 | 1.001 | 1.001 | 0.944 | 0.999 | 1.013 | 1.040 | 0.188 | 1.012 |
| hex: http/json-16kx64 | 2097280 | 15189.8 ± 0.4% | 1.002 | 0.182 | 1.003 | 1.001 | 1.001 | 0.995 | 1.004 | 1.008 | 1.014 | 0.181 | 1.006 |
| hex: http/json-1m | 524290 | 15611.4 ± 0.1% | 1.000 | 0.178 | 1.000 | 0.998 | 0.999 | 0.995 | 0.998 | 0.999 | 0.999 | 0.178 | 0.999 |
| hex: http/js-1kx1024 | 2099200 | 13730.4 ± 0.4% | 1.007 | 0.195 | 0.999 | 1.000 | 1.003 | 0.935 | 0.992 | 1.003 | 1.032 | 0.187 | 1.010 |
| hex: http/js-16kx64 | 2097280 | 15242.4 ± 0.3% | 0.997 | 0.181 | 0.998 | 1.000 | 1.001 | 0.993 | 1.002 | 1.007 | 1.013 | 0.180 | 1.000 |
| hex: http/js-1m | 524290 | 15658.1 ± 0.3% | 1.002 | 0.177 | 1.001 | 1.002 | 1.002 | 1.002 | 1.002 | 1.001 | 1.001 | 0.177 | 1.001 |
| hex: http/css-1kx1024 | 2099200 | 13678.7 ± 0.5% | 1.010 | 0.196 | 1.003 | 1.002 | 1.002 | 0.935 | 0.996 | 1.010 | 1.033 | 0.187 | 1.012 |
| hex: http/css-16kx64 | 2097280 | 15259.4 ± 0.5% | 0.998 | 0.181 | 0.997 | 0.999 | 1.003 | 0.991 | 0.997 | 1.000 | 1.009 | 0.180 | 0.998 |
| hex: http/css-1m | 524290 | 15636.2 ± 0.2% | 1.001 | 0.177 | 1.003 | 1.001 | 1.001 | 1.001 | 1.003 | 1.001 | 1.001 | 0.177 | 1.002 |
| hex: shuffled/dickens-1m | 524290 | 15631.5 ± 0.5% | 1.001 | 0.178 | 1.002 | 1.003 | 1.003 | 0.999 | 1.004 | 1.003 | 1.004 | 0.177 | 1.004 |

## Losses

Each workload where a claim's path ran slower than the path it replaces by more than the noise floor of decision 20.

- string: http/html-1m, decoding: J13 decoder escape blocks off runs at 1.054 of all on.
- hex: http/html-1kx1024, decoding: J5 UTF-8 vectors off runs at 1.139 of all on.
- hex: http/html-1kx1024, decoding: J7 wide vectors off runs at 1.132 of all on.
- hex: http/html-1kx1024, decoding: J8 decoder fast path off runs at 1.133 of all on.
- hex: http/html-1kx1024, decoding: J12 decoder escape words off runs at 1.131 of all on.
- hex: http/json-1kx1024, decoding: J5 UTF-8 vectors off runs at 1.267 of all on.
- hex: http/json-1kx1024, decoding: J7 wide vectors off runs at 1.258 of all on.
- hex: http/json-1kx1024, decoding: J8 decoder fast path off runs at 1.259 of all on.
- hex: http/json-1kx1024, decoding: J12 decoder escape words off runs at 1.268 of all on.
- hex: http/js-1kx1024, decoding: J5 UTF-8 vectors off runs at 1.258 of all on.
- hex: http/js-1kx1024, decoding: J7 wide vectors off runs at 1.254 of all on.
- hex: http/js-1kx1024, decoding: J8 decoder fast path off runs at 1.253 of all on.
- hex: http/js-1kx1024, decoding: J12 decoder escape words off runs at 1.249 of all on.
- hex: http/css-1kx1024, decoding: J5 UTF-8 vectors off runs at 1.277 of all on.
- hex: http/css-1kx1024, decoding: J7 wide vectors off runs at 1.266 of all on.
- hex: http/css-1kx1024, decoding: J8 decoder fast path off runs at 1.270 of all on.
- hex: http/css-1kx1024, decoding: J12 decoder escape words off runs at 1.276 of all on.

## UTF-8 validation against simdutf

stdx's `is_utf8`, the check the loops apply to every string's octets, run alone over each string workload's octets at the width the host's features pick (16 lanes on aarch64, AVX2's 32 or AVX-512's 64 on x86-64, decision 39), beside simdutf 9.3.3's `validate_utf8` in the same run; on a host with AVX-512, again with AVX2 alone. Each ratio is stdx's throughput over the other's. simdutf picks its kernel at run time. Before timing, every copy of the check and simdutf judged 20000 seeded buffers and each workload, whole and changed, alike.

| Workload | Octets | stdx, MB/s | simdutf, MB/s | stdx / simdutf | stdx with AVX2 alone, MB/s | stdx / stdx with AVX2 alone |
|---|---|---|---|---|---|---|
| string: silesia/dickens | 166668 | 43383.7 ± 0.1% | 47427.3 ± 0.1% | 0.915 | — | — |
| string: silesia/nci | 1048576 | 34464.9 ± 3.9% | 37021.3 ± 4.8% | 0.931 | — | — |
| string: silesia/reymont | 1048576 | 35906.1 ± 2.2% | 38714.8 ± 4.1% | 0.927 | — | — |
| string: silesia/samba | 65546 | 43617.9 ± 0.0% | 48519.3 ± 0.1% | 0.899 | — | — |
| string: silesia/webster | 1048576 | 36718.0 ± 2.4% | 40593.9 ± 2.4% | 0.905 | — | — |
| string: silesia/xml | 1048576 | 30957.1 ± 1.7% | 32230.3 ± 2.0% | 0.960 | — | — |
| string: canterbury/alice29.txt | 152089 | 35918.3 ± 0.1% | 36557.5 ± 0.1% | 0.983 | — | — |
| string: canterbury/asyoulik.txt | 125179 | 43384.0 ± 0.1% | 47679.8 ± 0.1% | 0.910 | — | — |
| string: canterbury/lcet10.txt | 426754 | 36021.6 ± 0.3% | 36667.1 ± 0.1% | 0.982 | — | — |
| string: canterbury/plrabn12.txt | 481861 | 43574.2 ± 0.0% | 47621.2 ± 0.1% | 0.915 | — | — |
| string: canterbury-large/E.coli | 1048576 | 35080.9 ± 1.7% | 37348.8 ± 3.4% | 0.939 | — | — |
| string: canterbury-large/bible.txt | 1048576 | 30637.6 ± 2.1% | 31879.2 ± 2.1% | 0.961 | — | — |
| string: canterbury-large/world192.txt | 1048576 | 31154.7 ± 2.3% | 32193.2 ± 4.7% | 0.968 | — | — |
| string: http/html-1m | 1048576 | 33807.1 ± 7.1% | 36501.5 ± 6.3% | 0.926 | — | — |
| string: http/json-1m | 1048576 | 29646.6 ± 5.5% | 31506.2 ± 3.7% | 0.941 | — | — |
| string: http/js-1m | 1048576 | 34789.3 ± 3.8% | 37437.8 ± 2.3% | 0.929 | — | — |
| string: http/css-1m | 1048576 | 33751.4 ± 3.0% | 36389.5 ± 2.7% | 0.928 | — | — |
| string: dickens as Cyrillic and CJK | 1847045 | 5767.8 ± 0.5% | 5652.3 ± 0.1% | 1.020 | — | — |

## Losses to simdutf

- string: silesia/dickens: stdx runs at 0.915 of simdutf.
- string: silesia/nci: stdx runs at 0.931 of simdutf.
- string: silesia/reymont: stdx runs at 0.927 of simdutf.
- string: silesia/samba: stdx runs at 0.899 of simdutf.
- string: silesia/webster: stdx runs at 0.905 of simdutf.
- string: canterbury/asyoulik.txt: stdx runs at 0.910 of simdutf.
- string: canterbury/plrabn12.txt: stdx runs at 0.915 of simdutf.
- string: canterbury-large/E.coli: stdx runs at 0.939 of simdutf.
- string: http/html-1m: stdx runs at 0.926 of simdutf.
- string: http/json-1m: stdx runs at 0.941 of simdutf.
- string: http/js-1m: stdx runs at 0.929 of simdutf.
- string: http/css-1m: stdx runs at 0.928 of simdutf.

## UTF-8 validation by the buffer's offset from a 64-octet line

| Buffer | Octets | Offset | stdx, MB/s | simdutf, MB/s | stdx / simdutf | stdx with AVX2 alone, MB/s | stdx / stdx with AVX2 alone |
|---|---|---|---|---|---|---|---|
| string: canterbury-large/bible.txt | 1048576 | 0 | 37964.3 ± 3.9% | 41469.4 ± 1.4% | 0.915 | — | — |
| string: canterbury-large/bible.txt | 1048576 | 1 | 32917.2 ± 2.0% | 33768.5 ± 1.0% | 0.975 | — | — |
| string: canterbury-large/bible.txt | 1048576 | 8 | 36523.7 ± 1.9% | 39368.1 ± 0.9% | 0.928 | — | — |
| string: canterbury-large/bible.txt | 1048576 | 16 | 37889.4 ± 2.0% | 41219.7 ± 1.0% | 0.919 | — | — |
| string: canterbury-large/bible.txt | 1048576 | 32 | 37542.6 ± 1.7% | 41179.1 ± 1.1% | 0.912 | — | — |
| string: canterbury-large/bible.txt | 1048576 | 48 | 37729.0 ± 2.5% | 41243.5 ± 2.0% | 0.915 | — | — |
| string: dickens as Cyrillic and CJK | 1048576 | 0 | 5765.4 ± 0.1% | 5645.8 ± 0.1% | 1.021 | — | — |
| string: dickens as Cyrillic and CJK | 1048576 | 1 | 5757.3 ± 0.5% | 5647.5 ± 0.2% | 1.019 | — | — |
| string: dickens as Cyrillic and CJK | 1048576 | 8 | 5766.5 ± 0.2% | 5651.3 ± 0.2% | 1.020 | — | — |
| string: dickens as Cyrillic and CJK | 1048576 | 16 | 5763.1 ± 0.1% | 5647.0 ± 0.1% | 1.021 | — | — |
| string: dickens as Cyrillic and CJK | 1048576 | 32 | 5767.7 ± 0.2% | 5650.3 ± 0.1% | 1.021 | — | — |
| string: dickens as Cyrillic and CJK | 1048576 | 48 | 5765.6 ± 0.1% | 5651.0 ± 0.6% | 1.020 | — | — |

## Against the baselines

stdx with every claim on, timed beside simdjson 5.1.1, yyjson 0.13.0, Zig 0.16.0's std.json, serde_json 1.0.154 and Go's encoding/json/jsontext in the same run. Each ratio is stdx's throughput over the baseline's; below 1, the baseline is faster. stdx is built for the architecture's baseline CPU in ReleaseSafe. Each baseline is built for the same CPU, the C, C++ and Zig ones in ReleaseFast (decision 75), and simdjson picks its kernel at run time. Decoding visits every value; encoding writes each text from its tokens.

## Decoding against the baselines

Octets are the text's. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1128.6 ± 0.4% | 929.4 ± 0.8% | 1022.4 ± 0.3% | 300.6 ± 1.1% | 667.0 ± 0.2% | 310.3 ± 1.5% | 1.214 | 1.104 | 3.754 | 1.692 | 3.637 |
| qlog records, JSON text sequence | 1467503 | 841.2 ± 1.2% | 817.2 ± 0.0% | 790.9 ± 0.4% | 244.2 ± 0.5% | 698.1 ± 1.0% | 250.7 ± 0.5% | 1.029 | 1.064 | 3.445 | 1.205 | 3.356 |
| string: silesia/dickens | 172528 | 5048.2 ± 0.3% | 1879.8 ± 0.3% | 2650.2 ± 0.3% | 362.6 ± 1.0% | 2846.8 ± 0.5% | 552.6 ± 2.4% | 2.685 | 1.905 | 13.921 | 1.773 | 9.135 |
| string: silesia/nci | 1075110 | 4291.0 ± 0.7% | 2239.7 ± 0.5% | 2994.4 ± 0.6% | 541.3 ± 1.1% | 3016.1 ± 0.6% | 591.7 ± 3.1% | 1.916 | 1.433 | 7.928 | 1.423 | 7.252 |
| string: silesia/reymont | 1075159 | 2930.4 ± 1.5% | 1813.7 ± 2.0% | 2062.0 ± 0.2% | 375.6 ± 0.4% | 2141.5 ± 0.5% | 535.8 ± 1.1% | 1.616 | 1.421 | 7.802 | 1.368 | 5.469 |
| string: silesia/samba | 97582 | 3490.8 ± 0.3% | 2025.4 ± 0.2% | 2617.6 ± 0.6% | 328.4 ± 0.2% | 1499.5 ± 0.8% | 425.5 ± 1.3% | 1.724 | 1.334 | 10.631 | 2.328 | 8.204 |
| string: silesia/webster | 1098490 | 3648.3 ± 0.6% | 1517.1 ± 0.4% | 2012.7 ± 0.3% | 359.2 ± 0.3% | 2191.9 ± 0.3% | 499.4 ± 2.2% | 2.405 | 1.813 | 10.156 | 1.664 | 7.306 |
| string: silesia/xml | 1090118 | 4788.2 ± 0.5% | 2362.0 ± 0.1% | 2528.3 ± 0.4% | 451.9 ± 0.7% | 2862.2 ± 0.3% | 565.8 ± 0.7% | 2.027 | 1.894 | 10.596 | 1.673 | 8.463 |
| string: canterbury/alice29.txt | 159425 | 4305.9 ± 0.7% | 1601.2 ± 0.2% | 2459.4 ± 0.7% | 342.2 ± 0.4% | 2500.4 ± 0.3% | 503.5 ± 0.9% | 2.689 | 1.751 | 12.582 | 1.722 | 8.552 |
| string: canterbury/asyoulik.txt | 132198 | 3449.3 ± 1.1% | 1457.8 ± 0.3% | 2245.4 ± 0.8% | 334.6 ± 0.7% | 2075.7 ± 0.5% | 459.0 ± 1.7% | 2.366 | 1.536 | 10.309 | 1.662 | 7.515 |
| string: canterbury/lcet10.txt | 441884 | 5106.6 ± 0.6% | 1850.5 ± 0.3% | 2337.4 ± 1.2% | 390.0 ± 0.4% | 2829.6 ± 0.4% | 534.2 ± 3.1% | 2.760 | 2.185 | 13.093 | 1.805 | 9.559 |
| string: canterbury/plrabn12.txt | 503330 | 4089.7 ± 0.6% | 1735.2 ± 0.3% | 2059.7 ± 0.3% | 359.3 ± 0.3% | 2491.8 ± 0.2% | 496.1 ± 0.8% | 2.357 | 1.986 | 11.382 | 1.641 | 8.244 |
| string: canterbury-large/E.coli | 1048578 | 19160.7 ± 0.4% | 3604.5 ± 0.5% | 3250.2 ± 0.4% | 929.2 ± 0.9% | 5986.7 ± 1.2% | 745.7 ± 0.6% | 5.316 | 5.895 | 20.620 | 3.201 | 25.695 |
| string: canterbury-large/bible.txt | 1055886 | 6693.9 ± 1.3% | 2937.9 ± 0.7% | 2828.5 ± 0.8% | 421.8 ± 2.3% | 3759.7 ± 2.7% | 612.7 ± 2.7% | 2.278 | 2.367 | 15.871 | 1.780 | 10.925 |
| string: canterbury-large/world192.txt | 1103121 | 3381.3 ± 0.8% | 1482.6 ± 0.2% | 2011.6 ± 0.3% | 352.5 ± 0.4% | 2118.5 ± 0.5% | 501.4 ± 1.1% | 2.281 | 1.681 | 9.592 | 1.596 | 6.744 |
| string: http/html-1m | 1058582 | 6058.8 ± 1.6% | 2736.4 ± 0.8% | 2708.0 ± 0.4% | 442.0 ± 0.7% | 3475.9 ± 0.7% | 599.3 ± 1.1% | 2.214 | 2.237 | 13.707 | 1.743 | 10.109 |
| string: http/json-1m | 1190272 | 2548.1 ± 0.2% | 878.5 ± 0.3% | 2253.1 ± 0.2% | 390.1 ± 0.6% | 1063.4 ± 0.5% | 443.5 ± 0.4% | 2.901 | 1.131 | 6.532 | 2.396 | 5.745 |
| string: http/js-1m | 1144362 | 2293.0 ± 0.7% | 1028.0 ± 0.4% | 1639.2 ± 0.4% | 319.8 ± 0.7% | 1524.3 ± 0.4% | 419.6 ± 0.7% | 2.230 | 1.399 | 7.169 | 1.504 | 5.465 |
| string: http/css-1m | 1097820 | 2634.7 ± 0.5% | 1678.2 ± 0.3% | 2230.0 ± 0.8% | 404.7 ± 1.4% | 1951.1 ± 0.5% | 489.8 ± 0.8% | 1.570 | 1.181 | 6.511 | 1.350 | 5.379 |
| string: dickens as Cyrillic and CJK | 1883069 | 3067.2 ± 0.4% | 1684.1 ± 0.2% | 895.6 ± 0.5% | 351.6 ± 0.2% | 669.2 ± 0.7% | 157.2 ± 2.8% | 1.821 | 3.425 | 8.725 | 4.583 | 19.506 |
| string: dickens as Cyrillic and CJK, as \u escapes | 5075485 | 1328.5 ± 1.5% | 980.7 ± 0.2% | 1217.2 ± 0.4% | 216.1 ± 0.1% | 471.2 ± 0.5% | 251.5 ± 4.3% | 1.355 | 1.091 | 6.148 | 2.820 | 5.281 |
| hex: silesia/dickens | 524290 | 18704.0 ± 1.9% | 3610.5 ± 0.3% | 3287.2 ± 0.4% | 515.1 ± 2.1% | 6123.2 ± 0.7% | 780.9 ± 3.9% | 5.180 | 5.690 | 36.315 | 3.055 | 23.951 |
| hex: silesia/mozilla | 524290 | 18509.2 ± 2.4% | 3617.7 ± 0.2% | 3282.1 ± 0.1% | 453.0 ± 1.0% | 6108.6 ± 2.7% | 781.3 ± 0.5% | 5.116 | 5.640 | 40.855 | 3.030 | 23.691 |
| hex: silesia/mr | 524290 | 18306.5 ± 1.5% | 3612.9 ± 0.2% | 3279.5 ± 0.6% | 571.9 ± 4.4% | 6054.8 ± 0.7% | 784.3 ± 0.7% | 5.067 | 5.582 | 32.009 | 3.023 | 23.342 |
| hex: silesia/nci | 524290 | 18431.9 ± 2.1% | 3615.2 ± 0.3% | 3290.6 ± 0.2% | 625.8 ± 3.9% | 6070.2 ± 2.1% | 782.2 ± 0.4% | 5.098 | 5.601 | 29.455 | 3.036 | 23.563 |
| hex: silesia/ooffice | 524290 | 18480.5 ± 0.7% | 3613.9 ± 0.1% | 3295.1 ± 0.3% | 403.3 ± 1.8% | 6094.8 ± 0.5% | 781.7 ± 0.6% | 5.114 | 5.608 | 45.826 | 3.032 | 23.641 |
| hex: silesia/osdb | 524290 | 17997.8 ± 0.6% | 3614.3 ± 0.2% | 3285.8 ± 0.5% | 495.5 ± 3.8% | 6103.8 ± 1.8% | 783.2 ± 0.9% | 4.980 | 5.477 | 36.324 | 2.949 | 22.979 |
| hex: silesia/reymont | 524290 | 18611.8 ± 1.6% | 3611.5 ± 0.2% | 3301.7 ± 0.3% | 522.5 ± 2.8% | 6125.9 ± 1.1% | 782.6 ± 0.5% | 5.154 | 5.637 | 35.617 | 3.038 | 23.781 |
| hex: silesia/samba | 524290 | 17954.3 ± 0.8% | 3614.8 ± 0.1% | 3295.1 ± 0.2% | 410.8 ± 1.4% | 6019.9 ± 0.6% | 784.2 ± 0.6% | 4.967 | 5.449 | 43.706 | 2.982 | 22.894 |
| hex: silesia/sao | 524290 | 18498.7 ± 0.6% | 3614.6 ± 0.3% | 3292.0 ± 0.2% | 343.4 ± 1.5% | 6109.8 ± 2.8% | 781.8 ± 0.4% | 5.118 | 5.619 | 53.871 | 3.028 | 23.663 |
| hex: silesia/webster | 524290 | 18418.9 ± 0.6% | 3616.0 ± 0.3% | 3300.5 ± 0.4% | 464.5 ± 2.2% | 6122.3 ± 1.2% | 782.1 ± 0.9% | 5.094 | 5.581 | 39.650 | 3.008 | 23.549 |
| hex: silesia/x-ray | 524290 | 18537.8 ± 1.4% | 3612.7 ± 0.4% | 3293.7 ± 0.3% | 477.6 ± 1.4% | 6121.9 ± 1.9% | 782.1 ± 0.2% | 5.131 | 5.628 | 38.817 | 3.028 | 23.702 |
| hex: silesia/xml | 524290 | 18537.0 ± 2.1% | 3610.1 ± 0.3% | 3285.7 ± 0.2% | 516.7 ± 1.7% | 6047.9 ± 0.9% | 783.3 ± 0.6% | 5.135 | 5.642 | 35.877 | 3.065 | 23.664 |
| hex: canterbury/alice29.txt | 304180 | 19145.6 ± 0.3% | 3635.6 ± 0.1% | 3345.8 ± 0.3% | 514.9 ± 3.9% | 6145.5 ± 0.9% | 783.0 ± 0.5% | 5.266 | 5.722 | 37.182 | 3.115 | 24.450 |
| hex: canterbury/asyoulik.txt | 250360 | 19550.1 ± 0.1% | 3635.1 ± 0.3% | 3378.3 ± 0.1% | 516.7 ± 0.8% | 6133.6 ± 1.2% | 779.8 ± 0.4% | 5.378 | 5.787 | 37.833 | 3.187 | 25.072 |
| hex: canterbury/cp.html | 49208 | 19307.6 ± 0.1% | 3640.2 ± 0.0% | 3277.7 ± 0.1% | 482.1 ± 1.6% | 6284.3 ± 0.5% | 767.5 ± 1.1% | 5.304 | 5.891 | 40.052 | 3.072 | 25.156 |
| hex: canterbury/fields.c | 22302 | 18832.5 ± 0.6% | 3629.0 ± 0.1% | 3350.8 ± 0.0% | 511.6 ± 0.2% | 6253.3 ± 1.0% | 754.8 ± 1.3% | 5.190 | 5.620 | 36.812 | 3.012 | 24.950 |
| hex: canterbury/grammar.lsp | 7444 | 17470.1 ± 1.1% | 3601.6 ± 0.0% | 3352.7 ± 0.4% | 541.4 ± 2.1% | 6162.6 ± 0.5% | 732.5 ± 1.1% | 4.851 | 5.211 | 32.271 | 2.835 | 23.849 |
| hex: canterbury/kennedy.xls | 524290 | 17797.8 ± 0.9% | 3612.5 ± 0.1% | 3292.2 ± 0.4% | 656.8 ± 7.9% | 6091.5 ± 0.7% | 764.2 ± 5.1% | 4.927 | 5.406 | 27.097 | 2.922 | 23.288 |
| hex: canterbury/lcet10.txt | 524290 | 18483.5 ± 0.6% | 3612.1 ± 0.1% | 3289.6 ± 0.4% | 523.0 ± 3.7% | 6161.4 ± 1.1% | 775.9 ± 1.5% | 5.117 | 5.619 | 35.341 | 3.000 | 23.822 |
| hex: canterbury/plrabn12.txt | 524290 | 18153.3 ± 1.2% | 3613.0 ± 0.2% | 3288.8 ± 0.3% | 516.4 ± 0.4% | 6027.2 ± 0.8% | 777.3 ± 1.5% | 5.024 | 5.520 | 35.157 | 3.012 | 23.354 |
| hex: canterbury/ptt5 | 524290 | 18195.6 ± 0.6% | 3611.0 ± 0.2% | 3290.3 ± 0.3% | 559.2 ± 2.9% | 6057.3 ± 1.6% | 777.3 ± 0.5% | 5.039 | 5.530 | 32.539 | 3.004 | 23.408 |
| hex: canterbury/sum | 76482 | 19298.2 ± 0.4% | 3633.7 ± 0.0% | 3356.1 ± 0.1% | 511.2 ± 2.4% | 6173.2 ± 0.3% | 775.2 ± 1.3% | 5.311 | 5.750 | 37.748 | 3.126 | 24.894 |
| hex: canterbury/xargs.1 | 8456 | 17837.2 ± 0.7% | 3602.6 ± 0.0% | 3371.8 ± 0.1% | 495.8 ± 2.1% | 6143.2 ± 0.5% | 756.2 ± 0.8% | 4.951 | 5.290 | 35.980 | 2.904 | 23.588 |
| hex: canterbury-large/E.coli | 524290 | 18257.8 ± 1.9% | 3616.4 ± 0.2% | 3295.3 ± 0.2% | 689.3 ± 0.4% | 6117.6 ± 0.5% | 768.1 ± 1.8% | 5.049 | 5.541 | 26.487 | 2.984 | 23.772 |
| hex: canterbury-large/bible.txt | 524290 | 18677.6 ± 0.7% | 3616.3 ± 0.1% | 3289.7 ± 0.3% | 515.9 ± 2.3% | 6146.2 ± 0.7% | 770.7 ± 0.7% | 5.165 | 5.678 | 36.202 | 3.039 | 24.235 |
| hex: canterbury-large/world192.txt | 524290 | 17786.0 ± 1.0% | 3614.8 ± 0.2% | 3293.2 ± 0.2% | 497.5 ± 3.0% | 6121.6 ± 0.7% | 772.9 ± 0.9% | 4.920 | 5.401 | 35.752 | 2.905 | 23.013 |
| hex: http/html-1kx1024 | 2099200 | 10430.1 ± 12.3% | 3462.9 ± 0.3% | 2858.2 ± 0.4% | 475.2 ± 0.3% | 5144.3 ± 0.8% | 648.8 ± 2.3% | 3.012 | 3.649 | 21.949 | 2.027 | 16.076 |
| hex: http/html-16kx64 | 2097280 | 17855.4 ± 0.4% | 3610.1 ± 0.1% | 3265.3 ± 0.4% | 477.6 ± 1.6% | 6016.9 ± 0.4% | 756.3 ± 1.6% | 4.946 | 5.468 | 37.386 | 2.968 | 23.610 |
| hex: http/html-1m | 524290 | 18217.0 ± 1.5% | 3617.7 ± 0.2% | 3284.7 ± 0.2% | 494.5 ± 1.2% | 6112.2 ± 0.8% | 761.4 ± 1.0% | 5.035 | 5.546 | 36.838 | 2.980 | 23.925 |
| hex: http/json-1kx1024 | 2099200 | 9463.9 ± 14.8% | 3464.1 ± 0.3% | 2854.0 ± 0.4% | 576.1 ± 0.5% | 5140.3 ± 1.0% | 649.5 ± 1.2% | 2.732 | 3.316 | 16.428 | 1.841 | 14.571 |
| hex: http/json-16kx64 | 2097280 | 17949.8 ± 0.8% | 3610.2 ± 0.5% | 3277.6 ± 5.2% | 572.4 ± 0.6% | 6009.8 ± 1.6% | 757.4 ± 0.9% | 4.972 | 5.476 | 31.361 | 2.987 | 23.700 |
| hex: http/json-1m | 524290 | 18118.8 ± 2.2% | 3614.4 ± 0.2% | 3288.4 ± 0.5% | 587.8 ± 2.7% | 6151.6 ± 2.1% | 771.5 ± 2.3% | 5.013 | 5.510 | 30.827 | 2.945 | 23.486 |
| hex: http/js-1kx1024 | 2099200 | 9429.7 ± 16.7% | 3460.4 ± 0.2% | 2859.4 ± 0.3% | 481.9 ± 0.5% | 5120.9 ± 2.0% | 635.0 ± 3.7% | 2.725 | 3.298 | 19.567 | 1.841 | 14.850 |
| hex: http/js-16kx64 | 2097280 | 17796.1 ± 1.1% | 3608.6 ± 0.2% | 3265.0 ± 0.3% | 481.0 ± 0.7% | 6018.5 ± 0.3% | 758.0 ± 2.6% | 4.932 | 5.451 | 36.998 | 2.957 | 23.478 |
| hex: http/js-1m | 524290 | 18638.2 ± 0.9% | 3614.0 ± 0.2% | 3289.3 ± 0.2% | 505.5 ± 1.0% | 6134.7 ± 2.1% | 781.0 ± 2.6% | 5.157 | 5.666 | 36.869 | 3.038 | 23.864 |
| hex: http/css-1kx1024 | 2099200 | 9404.9 ± 16.0% | 3462.3 ± 0.2% | 2842.9 ± 0.7% | 488.7 ± 1.2% | 5095.7 ± 1.1% | 651.8 ± 1.7% | 2.716 | 3.308 | 19.244 | 1.846 | 14.429 |
| hex: http/css-16kx64 | 2097280 | 17905.6 ± 0.6% | 3608.6 ± 0.2% | 3259.6 ± 0.3% | 494.6 ± 1.0% | 6011.2 ± 0.2% | 759.3 ± 1.0% | 4.962 | 5.493 | 36.204 | 2.979 | 23.583 |
| hex: http/css-1m | 524290 | 18623.8 ± 1.3% | 3610.1 ± 0.2% | 3304.3 ± 0.3% | 500.9 ± 1.8% | 6113.9 ± 1.2% | 761.5 ± 2.7% | 5.159 | 5.636 | 37.178 | 3.046 | 24.455 |
| hex: shuffled/dickens-1m | 524290 | 17939.3 ± 0.5% | 3613.6 ± 0.2% | 3294.6 ± 0.3% | 512.9 ± 1.1% | 6042.2 ± 0.7% | 766.3 ± 1.1% | 4.964 | 5.445 | 34.974 | 2.969 | 23.411 |

## Encoding against the baselines

Octets are the ones stdx writes. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1483.1 ± 0.3% | 1253.3 ± 0.4% | 1040.7 ± 0.6% | 408.8 ± 0.2% | 448.2 ± 0.6% | 416.9 ± 0.4% | 1.183 | 1.425 | 3.628 | 3.309 | 3.557 |
| qlog records, JSON text sequence | 1467503 | 1280.9 ± 0.8% | 1065.7 ± 0.1% | 786.2 ± 0.5% | 376.8 ± 1.0% | 468.9 ± 0.6% | 279.0 ± 0.5% | 1.202 | 1.629 | 3.399 | 2.732 | 4.590 |
| string: silesia/dickens | 172528 | 6891.3 ± 0.3% | 2813.8 ± 0.2% | 2934.7 ± 0.9% | 432.2 ± 0.5% | 1595.3 ± 0.2% | 1012.0 ± 0.1% | 2.449 | 2.348 | 15.944 | 4.320 | 6.809 |
| string: silesia/nci | 1075110 | 7317.8 ± 0.3% | 3397.2 ± 1.2% | 3097.6 ± 0.6% | 810.5 ± 1.5% | 1858.7 ± 0.3% | 1109.4 ± 0.5% | 2.154 | 2.362 | 9.029 | 3.937 | 6.596 |
| string: silesia/reymont | 1075159 | 3334.1 ± 1.4% | 1968.5 ± 1.2% | 2065.6 ± 0.9% | 450.0 ± 1.2% | 1510.6 ± 0.2% | 952.5 ± 0.6% | 1.694 | 1.614 | 7.408 | 2.207 | 3.500 |
| string: silesia/samba | 97582 | 4185.4 ± 0.9% | 2117.3 ± 0.5% | 3450.5 ± 0.5% | 355.3 ± 0.8% | 1434.0 ± 0.6% | 1054.1 ± 0.4% | 1.977 | 1.213 | 11.779 | 2.919 | 3.971 |
| string: silesia/webster | 1098490 | 4049.2 ± 0.4% | 1882.0 ± 0.4% | 2058.6 ± 0.4% | 441.9 ± 0.6% | 1394.1 ± 0.3% | 646.9 ± 0.2% | 2.152 | 1.967 | 9.163 | 2.904 | 6.259 |
| string: silesia/xml | 1090118 | 6119.1 ± 0.8% | 2857.2 ± 0.5% | 2646.0 ± 0.7% | 612.1 ± 0.8% | 1756.9 ± 0.4% | 922.8 ± 0.3% | 2.142 | 2.313 | 9.998 | 3.483 | 6.631 |
| string: canterbury/alice29.txt | 159425 | 6412.1 ± 1.0% | 2194.2 ± 0.8% | 2763.0 ± 0.8% | 407.6 ± 0.9% | 1480.3 ± 0.3% | 955.8 ± 0.2% | 2.922 | 2.321 | 15.730 | 4.332 | 6.708 |
| string: canterbury/asyoulik.txt | 132198 | 5591.9 ± 1.0% | 1716.0 ± 0.5% | 2376.5 ± 1.0% | 402.2 ± 0.4% | 1347.3 ± 0.4% | 885.2 ± 0.2% | 3.259 | 2.353 | 13.903 | 4.150 | 6.317 |
| string: canterbury/lcet10.txt | 441884 | 6229.7 ± 0.4% | 2566.7 ± 0.1% | 2487.4 ± 1.2% | 467.3 ± 1.3% | 1539.3 ± 0.6% | 982.6 ± 0.7% | 2.427 | 2.505 | 13.330 | 4.047 | 6.340 |
| string: canterbury/plrabn12.txt | 503330 | 5719.9 ± 0.3% | 2057.0 ± 0.3% | 2074.3 ± 0.5% | 422.8 ± 0.9% | 1430.1 ± 0.2% | 930.8 ± 0.3% | 2.781 | 2.758 | 13.528 | 4.000 | 6.145 |
| string: canterbury-large/E.coli | 1048578 | 19113.9 ± 1.5% | 9709.1 ± 1.2% | 3782.0 ± 0.2% | 1475.1 ± 0.1% | 2352.6 ± 0.5% | 1194.1 ± 0.3% | 1.969 | 5.054 | 12.958 | 8.124 | 16.007 |
| string: canterbury-large/bible.txt | 1055886 | 6788.2 ± 0.5% | 4125.3 ± 0.9% | 3053.8 ± 0.8% | 504.5 ± 0.8% | 1968.0 ± 0.5% | 1119.3 ± 0.5% | 1.645 | 2.223 | 13.454 | 3.449 | 6.065 |
| string: canterbury-large/world192.txt | 1103121 | 4018.0 ± 0.7% | 1656.7 ± 0.6% | 2000.8 ± 0.4% | 448.7 ± 0.7% | 1360.2 ± 0.4% | 909.4 ± 0.3% | 2.425 | 2.008 | 8.955 | 2.954 | 4.418 |
| string: http/html-1m | 1058582 | 6749.8 ± 0.2% | 3968.1 ± 0.4% | 3035.8 ± 0.4% | 501.7 ± 1.1% | 1914.3 ± 0.4% | 804.8 ± 1.0% | 1.701 | 2.223 | 13.454 | 3.526 | 8.387 |
| string: http/json-1m | 1190272 | 3157.5 ± 0.3% | 1351.2 ± 0.4% | 1555.7 ± 0.4% | 443.3 ± 0.8% | 961.7 ± 0.1% | 765.8 ± 0.6% | 2.337 | 2.030 | 7.122 | 3.283 | 4.123 |
| string: http/js-1m | 1144362 | 2749.4 ± 0.7% | 1179.2 ± 0.2% | 1627.7 ± 0.3% | 368.5 ± 0.1% | 1094.0 ± 0.2% | 758.6 ± 0.2% | 2.332 | 1.689 | 7.461 | 2.513 | 3.624 |
| string: http/css-1m | 1097820 | 3982.7 ± 0.5% | 1485.1 ± 0.2% | 2146.9 ± 0.2% | 494.6 ± 0.6% | 1370.0 ± 0.4% | 896.5 ± 0.4% | 2.682 | 1.855 | 8.053 | 2.907 | 4.442 |
| string: dickens as Cyrillic and CJK | 1883069 | 3070.3 ± 0.6% | 2347.5 ± 0.6% | 522.4 ± 0.4% | 307.1 ± 1.2% | 563.2 ± 0.6% | 336.3 ± 0.2% | 1.308 | 5.877 | 9.998 | 5.451 | 9.130 |
| hex: silesia/dickens | 524290 | 15631.4 ± 0.6% | 1466.6 ± 0.2% | 1082.6 ± 0.3% | 501.7 ± 1.2% | 988.3 ± 1.0% | 732.0 ± 0.6% | 10.658 | 14.439 | 31.156 | 15.816 | 21.353 |
| hex: silesia/mozilla | 524290 | 15678.1 ± 0.1% | 1470.8 ± 0.4% | 1087.5 ± 0.4% | 442.4 ± 0.4% | 988.9 ± 0.3% | 735.3 ± 0.4% | 10.659 | 14.417 | 35.438 | 15.855 | 21.322 |
| hex: silesia/mr | 524290 | 15658.1 ± 0.1% | 1485.0 ± 0.2% | 1094.1 ± 0.4% | 556.4 ± 2.0% | 993.2 ± 0.4% | 734.7 ± 0.5% | 10.544 | 14.312 | 28.140 | 15.765 | 21.312 |
| hex: silesia/nci | 524290 | 15672.4 ± 0.2% | 1470.7 ± 0.5% | 1087.7 ± 0.4% | 631.6 ± 3.0% | 987.6 ± 0.2% | 734.4 ± 0.3% | 10.657 | 14.409 | 24.816 | 15.870 | 21.342 |
| hex: silesia/ooffice | 524290 | 15631.3 ± 0.2% | 1467.7 ± 0.3% | 1083.9 ± 0.2% | 389.9 ± 0.5% | 992.0 ± 0.7% | 735.6 ± 0.7% | 10.650 | 14.421 | 40.094 | 15.757 | 21.250 |
| hex: silesia/osdb | 524290 | 15603.9 ± 0.3% | 1468.3 ± 0.3% | 1085.8 ± 0.2% | 479.3 ± 3.0% | 989.5 ± 0.6% | 735.2 ± 0.6% | 10.627 | 14.371 | 32.559 | 15.770 | 21.225 |
| hex: silesia/reymont | 524290 | 15690.3 ± 0.3% | 1463.3 ± 0.6% | 1083.7 ± 0.4% | 513.4 ± 0.7% | 988.9 ± 0.2% | 735.4 ± 0.4% | 10.723 | 14.479 | 30.565 | 15.867 | 21.336 |
| hex: silesia/samba | 524290 | 15664.1 ± 0.3% | 1466.8 ± 0.3% | 1083.4 ± 0.3% | 402.2 ± 0.7% | 988.3 ± 0.4% | 734.5 ± 0.7% | 10.679 | 14.459 | 38.945 | 15.849 | 21.325 |
| hex: silesia/sao | 524290 | 15651.7 ± 0.1% | 1467.1 ± 0.2% | 1083.8 ± 0.2% | 333.1 ± 0.4% | 988.6 ± 0.4% | 735.5 ± 0.2% | 10.668 | 14.441 | 46.988 | 15.832 | 21.281 |
| hex: silesia/webster | 524290 | 15619.7 ± 0.3% | 1462.5 ± 0.6% | 1082.3 ± 0.3% | 476.7 ± 0.8% | 988.3 ± 0.2% | 733.7 ± 0.6% | 10.680 | 14.431 | 32.766 | 15.805 | 21.290 |
| hex: silesia/x-ray | 524290 | 15641.4 ± 0.2% | 1477.5 ± 0.4% | 1092.5 ± 0.3% | 447.6 ± 1.0% | 995.5 ± 0.3% | 734.0 ± 0.6% | 10.587 | 14.317 | 34.941 | 15.712 | 21.310 |
| hex: silesia/xml | 524290 | 15626.8 ± 0.4% | 1465.8 ± 0.2% | 1083.8 ± 0.3% | 617.4 ± 0.7% | 987.3 ± 0.3% | 735.3 ± 0.3% | 10.661 | 14.418 | 25.309 | 15.828 | 21.253 |
| hex: canterbury/alice29.txt | 304180 | 15688.1 ± 0.1% | 1476.6 ± 0.6% | 1087.2 ± 0.4% | 499.3 ± 2.0% | 990.2 ± 0.3% | 737.1 ± 0.3% | 10.625 | 14.430 | 31.423 | 15.844 | 21.285 |
| hex: canterbury/asyoulik.txt | 250360 | 15706.4 ± 0.0% | 1479.9 ± 0.5% | 1095.6 ± 0.2% | 499.5 ± 1.5% | 995.9 ± 0.5% | 740.1 ± 0.3% | 10.613 | 14.336 | 31.444 | 15.771 | 21.222 |
| hex: canterbury/cp.html | 49208 | 15614.8 ± 0.1% | 1471.7 ± 0.2% | 1096.6 ± 0.2% | 524.2 ± 1.3% | 1000.1 ± 0.3% | 743.4 ± 0.2% | 10.610 | 14.239 | 29.785 | 15.613 | 21.004 |
| hex: canterbury/fields.c | 22302 | 15435.0 ± 0.1% | 1399.8 ± 0.6% | 1066.0 ± 0.3% | 633.7 ± 1.5% | 990.8 ± 0.1% | 737.1 ± 0.1% | 11.027 | 14.479 | 24.356 | 15.579 | 20.940 |
| hex: canterbury/grammar.lsp | 7444 | 14935.2 ± 0.1% | 1487.7 ± 0.6% | 1092.1 ± 0.4% | 661.0 ± 2.1% | 998.0 ± 0.3% | 726.1 ± 0.1% | 10.039 | 13.676 | 22.595 | 14.965 | 20.568 |
| hex: canterbury/kennedy.xls | 524290 | 15655.1 ± 0.2% | 1475.3 ± 0.3% | 1089.9 ± 0.4% | 653.2 ± 4.1% | 989.1 ± 0.1% | 734.9 ± 0.5% | 10.611 | 14.364 | 23.966 | 15.828 | 21.302 |
| hex: canterbury/lcet10.txt | 524290 | 15649.4 ± 0.2% | 1462.4 ± 0.5% | 1085.1 ± 0.4% | 504.8 ± 1.4% | 989.6 ± 0.4% | 735.7 ± 0.3% | 10.701 | 14.422 | 31.002 | 15.814 | 21.272 |
| hex: canterbury/plrabn12.txt | 524290 | 15677.5 ± 0.2% | 1467.2 ± 0.4% | 1083.7 ± 0.3% | 495.1 ± 1.3% | 989.1 ± 0.4% | 734.9 ± 0.2% | 10.685 | 14.466 | 31.668 | 15.851 | 21.333 |
| hex: canterbury/ptt5 | 524290 | 15631.5 ± 0.2% | 1477.6 ± 0.2% | 1092.7 ± 0.4% | 555.1 ± 0.9% | 992.2 ± 0.3% | 734.7 ± 0.7% | 10.579 | 14.305 | 28.159 | 15.755 | 21.277 |
| hex: canterbury/sum | 76482 | 15641.5 ± 0.1% | 1495.0 ± 0.2% | 1103.7 ± 0.1% | 594.9 ± 2.3% | 998.2 ± 0.1% | 744.7 ± 0.1% | 10.462 | 14.172 | 26.294 | 15.669 | 21.003 |
| hex: canterbury/xargs.1 | 8456 | 14988.1 ± 0.1% | 1429.1 ± 0.4% | 1093.7 ± 0.0% | 649.0 ± 3.4% | 1003.1 ± 0.2% | 729.0 ± 0.1% | 10.488 | 13.703 | 23.093 | 14.942 | 20.561 |
| hex: canterbury-large/E.coli | 524290 | 15663.2 ± 0.2% | 1474.0 ± 0.3% | 1089.1 ± 0.4% | 672.9 ± 0.2% | 990.4 ± 0.6% | 734.4 ± 0.4% | 10.627 | 14.382 | 23.278 | 15.815 | 21.328 |
| hex: canterbury-large/bible.txt | 524290 | 15650.3 ± 0.2% | 1465.1 ± 0.5% | 1087.3 ± 0.5% | 512.6 ± 0.5% | 989.2 ± 0.8% | 733.9 ± 1.1% | 10.682 | 14.394 | 30.531 | 15.822 | 21.324 |
| hex: canterbury-large/world192.txt | 524290 | 15645.0 ± 0.3% | 1468.3 ± 0.7% | 1083.8 ± 0.8% | 504.6 ± 0.8% | 988.5 ± 0.4% | 734.9 ± 0.5% | 10.655 | 14.435 | 31.003 | 15.826 | 21.289 |
| hex: http/html-1kx1024 | 2099200 | 13688.0 ± 0.4% | 1454.0 ± 0.2% | 1061.2 ± 0.2% | 502.3 ± 0.1% | 983.2 ± 0.5% | 693.1 ± 0.1% | 9.414 | 12.899 | 27.249 | 13.922 | 19.749 |
| hex: http/html-16kx64 | 2097280 | 15257.1 ± 0.8% | 1443.9 ± 0.1% | 1073.0 ± 0.1% | 506.6 ± 0.2% | 994.2 ± 0.1% | 735.3 ± 0.2% | 10.567 | 14.219 | 30.118 | 15.347 | 20.749 |
| hex: http/html-1m | 524290 | 15684.4 ± 0.1% | 1467.9 ± 0.2% | 1086.4 ± 0.3% | 500.9 ± 0.3% | 992.2 ± 0.4% | 735.3 ± 0.6% | 10.685 | 14.437 | 31.311 | 15.808 | 21.329 |
| hex: http/json-1kx1024 | 2099200 | 13615.2 ± 0.5% | 1462.6 ± 0.1% | 1066.3 ± 0.2% | 609.2 ± 0.2% | 986.7 ± 0.2% | 693.1 ± 0.1% | 9.309 | 12.768 | 22.349 | 13.799 | 19.643 |
| hex: http/json-16kx64 | 2097280 | 15189.8 ± 0.4% | 1445.1 ± 0.2% | 1074.0 ± 0.2% | 616.0 ± 0.8% | 994.2 ± 0.6% | 734.6 ± 0.1% | 10.511 | 14.143 | 24.660 | 15.278 | 20.678 |
| hex: http/json-1m | 524290 | 15611.4 ± 0.1% | 1470.5 ± 0.3% | 1088.8 ± 0.3% | 635.2 ± 2.2% | 989.7 ± 0.6% | 735.6 ± 0.4% | 10.616 | 14.338 | 24.577 | 15.775 | 21.221 |
| hex: http/js-1kx1024 | 2099200 | 13730.4 ± 0.4% | 1455.2 ± 0.1% | 1062.3 ± 0.4% | 497.9 ± 0.2% | 981.7 ± 0.4% | 692.6 ± 0.1% | 9.436 | 12.925 | 27.575 | 13.986 | 19.825 |
| hex: http/js-16kx64 | 2097280 | 15242.4 ± 0.3% | 1444.3 ± 0.2% | 1074.6 ± 0.1% | 504.5 ± 0.3% | 997.5 ± 0.3% | 734.9 ± 0.3% | 10.554 | 14.184 | 30.212 | 15.281 | 20.741 |
| hex: http/js-1m | 524290 | 15658.1 ± 0.3% | 1466.5 ± 0.3% | 1087.6 ± 0.1% | 511.6 ± 0.3% | 984.9 ± 0.3% | 733.0 ± 0.7% | 10.677 | 14.397 | 30.604 | 15.898 | 21.362 |
| hex: http/css-1kx1024 | 2099200 | 13678.7 ± 0.5% | 1455.1 ± 0.1% | 1061.8 ± 0.1% | 532.2 ± 0.3% | 984.0 ± 0.1% | 692.8 ± 0.1% | 9.401 | 12.883 | 25.703 | 13.902 | 19.744 |
| hex: http/css-16kx64 | 2097280 | 15259.4 ± 0.5% | 1445.0 ± 0.2% | 1073.9 ± 0.2% | 540.7 ± 0.4% | 998.9 ± 0.4% | 735.8 ± 0.2% | 10.560 | 14.209 | 28.220 | 15.277 | 20.737 |
| hex: http/css-1m | 524290 | 15636.2 ± 0.2% | 1460.8 ± 0.6% | 1086.0 ± 0.3% | 526.1 ± 0.2% | 990.1 ± 0.2% | 735.1 ± 0.5% | 10.704 | 14.398 | 29.722 | 15.793 | 21.271 |
| hex: shuffled/dickens-1m | 524290 | 15631.5 ± 0.5% | 1464.1 ± 0.2% | 1085.9 ± 0.3% | 501.9 ± 0.6% | 989.9 ± 0.5% | 734.9 ± 0.5% | 10.677 | 14.395 | 31.144 | 15.791 | 21.269 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1522.6 ± 0.6% | 1253.3 ± 0.4% | 1040.7 ± 0.6% | 408.8 ± 0.2% | 448.2 ± 0.6% | 416.9 ± 0.4% | 1.215 | 1.463 | 3.725 | 3.397 | 3.652 |
| qlog records, JSON text sequence | 1467503 | 1295.1 ± 0.3% | 1065.7 ± 0.1% | 786.2 ± 0.5% | 376.8 ± 1.0% | 468.9 ± 0.6% | 279.0 ± 0.5% | 1.215 | 1.647 | 3.437 | 2.762 | 4.641 |
| string: silesia/dickens | 172528 | 7130.9 ± 0.6% | 2813.8 ± 0.2% | 2934.7 ± 0.9% | 432.2 ± 0.5% | 1595.3 ± 0.2% | 1012.0 ± 0.1% | 2.534 | 2.430 | 16.499 | 4.470 | 7.046 |
| string: silesia/nci | 1075110 | 7385.4 ± 6.8% | 3397.2 ± 1.2% | 3097.6 ± 0.6% | 810.5 ± 1.5% | 1858.7 ± 0.3% | 1109.4 ± 0.5% | 2.174 | 2.384 | 9.112 | 3.973 | 6.657 |
| string: silesia/reymont | 1075159 | 3492.5 ± 0.5% | 1968.5 ± 1.2% | 2065.6 ± 0.9% | 450.0 ± 1.2% | 1510.6 ± 0.2% | 952.5 ± 0.6% | 1.774 | 1.691 | 7.760 | 2.312 | 3.667 |
| string: silesia/samba | 97582 | 4568.4 ± 1.8% | 2117.3 ± 0.5% | 3450.5 ± 0.5% | 355.3 ± 0.8% | 1434.0 ± 0.6% | 1054.1 ± 0.4% | 2.158 | 1.324 | 12.857 | 3.186 | 4.334 |
| string: silesia/webster | 1098490 | 4082.2 ± 0.5% | 1882.0 ± 0.4% | 2058.6 ± 0.4% | 441.9 ± 0.6% | 1394.1 ± 0.3% | 646.9 ± 0.2% | 2.169 | 1.983 | 9.238 | 2.928 | 6.310 |
| string: silesia/xml | 1090118 | 6238.4 ± 0.6% | 2857.2 ± 0.5% | 2646.0 ± 0.7% | 612.1 ± 0.8% | 1756.9 ± 0.4% | 922.8 ± 0.3% | 2.183 | 2.358 | 10.192 | 3.551 | 6.760 |
| string: canterbury/alice29.txt | 159425 | 6826.2 ± 0.5% | 2194.2 ± 0.8% | 2763.0 ± 0.8% | 407.6 ± 0.9% | 1480.3 ± 0.3% | 955.8 ± 0.2% | 3.111 | 2.471 | 16.746 | 4.611 | 7.142 |
| string: canterbury/asyoulik.txt | 132198 | 5877.9 ± 4.3% | 1716.0 ± 0.5% | 2376.5 ± 1.0% | 402.2 ± 0.4% | 1347.3 ± 0.4% | 885.2 ± 0.2% | 3.425 | 2.473 | 14.615 | 4.363 | 6.640 |
| string: canterbury/lcet10.txt | 441884 | 6228.0 ± 0.5% | 2566.7 ± 0.1% | 2487.4 ± 1.2% | 467.3 ± 1.3% | 1539.3 ± 0.6% | 982.6 ± 0.7% | 2.426 | 2.504 | 13.326 | 4.046 | 6.338 |
| string: canterbury/plrabn12.txt | 503330 | 5760.7 ± 0.2% | 2057.0 ± 0.3% | 2074.3 ± 0.5% | 422.8 ± 0.9% | 1430.1 ± 0.2% | 930.8 ± 0.3% | 2.801 | 2.777 | 13.625 | 4.028 | 6.189 |
| string: canterbury-large/E.coli | 1048578 | 19227.1 ± 0.4% | 9709.1 ± 1.2% | 3782.0 ± 0.2% | 1475.1 ± 0.1% | 2352.6 ± 0.5% | 1194.1 ± 0.3% | 1.980 | 5.084 | 13.035 | 8.173 | 16.102 |
| string: canterbury-large/bible.txt | 1055886 | 6798.0 ± 0.3% | 4125.3 ± 0.9% | 3053.8 ± 0.8% | 504.5 ± 0.8% | 1968.0 ± 0.5% | 1119.3 ± 0.5% | 1.648 | 2.226 | 13.474 | 3.454 | 6.073 |
| string: canterbury-large/world192.txt | 1103121 | 4035.7 ± 0.9% | 1656.7 ± 0.6% | 2000.8 ± 0.4% | 448.7 ± 0.7% | 1360.2 ± 0.4% | 909.4 ± 0.3% | 2.436 | 2.017 | 8.995 | 2.967 | 4.438 |
| string: http/html-1m | 1058582 | 6809.0 ± 0.4% | 3968.1 ± 0.4% | 3035.8 ± 0.4% | 501.7 ± 1.1% | 1914.3 ± 0.4% | 804.8 ± 1.0% | 1.716 | 2.243 | 13.572 | 3.557 | 8.460 |
| string: http/json-1m | 1190272 | 3290.2 ± 0.2% | 1351.2 ± 0.4% | 1555.7 ± 0.4% | 443.3 ± 0.8% | 961.7 ± 0.1% | 765.8 ± 0.6% | 2.435 | 2.115 | 7.421 | 3.421 | 4.296 |
| string: http/js-1m | 1144362 | 2809.6 ± 0.5% | 1179.2 ± 0.2% | 1627.7 ± 0.3% | 368.5 ± 0.1% | 1094.0 ± 0.2% | 758.6 ± 0.2% | 2.383 | 1.726 | 7.625 | 2.568 | 3.703 |
| string: http/css-1m | 1097820 | 4025.1 ± 0.6% | 1485.1 ± 0.2% | 2146.9 ± 0.2% | 494.6 ± 0.6% | 1370.0 ± 0.4% | 896.5 ± 0.4% | 2.710 | 1.875 | 8.139 | 2.938 | 4.490 |
| string: dickens as Cyrillic and CJK | 1883069 | 3075.4 ± 0.3% | 2347.5 ± 0.6% | 522.4 ± 0.4% | 307.1 ± 1.2% | 563.2 ± 0.6% | 336.3 ± 0.2% | 1.310 | 5.887 | 10.015 | 5.460 | 9.145 |
| hex: silesia/dickens | 524290 | 15685.2 ± 0.3% | 1466.6 ± 0.2% | 1082.6 ± 0.3% | 501.7 ± 1.2% | 988.3 ± 1.0% | 732.0 ± 0.6% | 10.695 | 14.488 | 31.264 | 15.870 | 21.427 |
| hex: silesia/mozilla | 524290 | 15674.0 ± 0.4% | 1470.8 ± 0.4% | 1087.5 ± 0.4% | 442.4 ± 0.4% | 988.9 ± 0.3% | 735.3 ± 0.4% | 10.656 | 14.413 | 35.429 | 15.851 | 21.317 |
| hex: silesia/mr | 524290 | 15651.5 ± 0.1% | 1485.0 ± 0.2% | 1094.1 ± 0.4% | 556.4 ± 2.0% | 993.2 ± 0.4% | 734.7 ± 0.5% | 10.540 | 14.306 | 28.128 | 15.758 | 21.302 |
| hex: silesia/nci | 524290 | 15649.0 ± 0.7% | 1470.7 ± 0.5% | 1087.7 ± 0.4% | 631.6 ± 3.0% | 987.6 ± 0.2% | 734.4 ± 0.3% | 10.641 | 14.387 | 24.779 | 15.846 | 21.310 |
| hex: silesia/ooffice | 524290 | 15552.2 ± 0.0% | 1467.7 ± 0.3% | 1083.9 ± 0.2% | 389.9 ± 0.5% | 992.0 ± 0.7% | 735.6 ± 0.7% | 10.596 | 14.348 | 39.891 | 15.678 | 21.142 |
| hex: silesia/osdb | 524290 | 15593.6 ± 0.5% | 1468.3 ± 0.3% | 1085.8 ± 0.2% | 479.3 ± 3.0% | 989.5 ± 0.6% | 735.2 ± 0.6% | 10.620 | 14.361 | 32.537 | 15.759 | 21.211 |
| hex: silesia/reymont | 524290 | 15704.7 ± 0.1% | 1463.3 ± 0.6% | 1083.7 ± 0.4% | 513.4 ± 0.7% | 988.9 ± 0.2% | 735.4 ± 0.4% | 10.733 | 14.492 | 30.593 | 15.881 | 21.356 |
| hex: silesia/samba | 524290 | 15644.7 ± 0.3% | 1466.8 ± 0.3% | 1083.4 ± 0.3% | 402.2 ± 0.7% | 988.3 ± 0.4% | 734.5 ± 0.7% | 10.666 | 14.441 | 38.897 | 15.829 | 21.299 |
| hex: silesia/sao | 524290 | 15582.4 ± 0.8% | 1467.1 ± 0.2% | 1083.8 ± 0.2% | 333.1 ± 0.4% | 988.6 ± 0.4% | 735.5 ± 0.2% | 10.621 | 14.377 | 46.780 | 15.762 | 21.186 |
| hex: silesia/webster | 524290 | 15545.7 ± 0.9% | 1462.5 ± 0.6% | 1082.3 ± 0.3% | 476.7 ± 0.8% | 988.3 ± 0.2% | 733.7 ± 0.6% | 10.630 | 14.363 | 32.611 | 15.730 | 21.189 |
| hex: silesia/x-ray | 524290 | 15595.5 ± 0.1% | 1477.5 ± 0.4% | 1092.5 ± 0.3% | 447.6 ± 1.0% | 995.5 ± 0.3% | 734.0 ± 0.6% | 10.555 | 14.275 | 34.839 | 15.666 | 21.248 |
| hex: silesia/xml | 524290 | 15612.8 ± 0.6% | 1465.8 ± 0.2% | 1083.8 ± 0.3% | 617.4 ± 0.7% | 987.3 ± 0.3% | 735.3 ± 0.3% | 10.651 | 14.405 | 25.286 | 15.814 | 21.234 |
| hex: canterbury/alice29.txt | 304180 | 15700.0 ± 0.0% | 1476.6 ± 0.6% | 1087.2 ± 0.4% | 499.3 ± 2.0% | 990.2 ± 0.3% | 737.1 ± 0.3% | 10.633 | 14.441 | 31.446 | 15.856 | 21.301 |
| hex: canterbury/asyoulik.txt | 250360 | 15723.5 ± 0.0% | 1479.9 ± 0.5% | 1095.6 ± 0.2% | 499.5 ± 1.5% | 995.9 ± 0.5% | 740.1 ± 0.3% | 10.625 | 14.352 | 31.478 | 15.789 | 21.245 |
| hex: canterbury/cp.html | 49208 | 15635.0 ± 0.1% | 1471.7 ± 0.2% | 1096.6 ± 0.2% | 524.2 ± 1.3% | 1000.1 ± 0.3% | 743.4 ± 0.2% | 10.624 | 14.257 | 29.824 | 15.633 | 21.031 |
| hex: canterbury/fields.c | 22302 | 15457.2 ± 0.0% | 1399.8 ± 0.6% | 1066.0 ± 0.3% | 633.7 ± 1.5% | 990.8 ± 0.1% | 737.1 ± 0.1% | 11.042 | 14.500 | 24.391 | 15.601 | 20.970 |
| hex: canterbury/grammar.lsp | 7444 | 14994.0 ± 0.0% | 1487.7 ± 0.6% | 1092.1 ± 0.4% | 661.0 ± 2.1% | 998.0 ± 0.3% | 726.1 ± 0.1% | 10.079 | 13.730 | 22.684 | 15.024 | 20.649 |
| hex: canterbury/kennedy.xls | 524290 | 15667.5 ± 0.1% | 1475.3 ± 0.3% | 1089.9 ± 0.4% | 653.2 ± 4.1% | 989.1 ± 0.1% | 734.9 ± 0.5% | 10.620 | 14.376 | 23.985 | 15.841 | 21.319 |
| hex: canterbury/lcet10.txt | 524290 | 15634.2 ± 0.1% | 1462.4 ± 0.5% | 1085.1 ± 0.4% | 504.8 ± 1.4% | 989.6 ± 0.4% | 735.7 ± 0.3% | 10.691 | 14.408 | 30.972 | 15.799 | 21.251 |
| hex: canterbury/plrabn12.txt | 524290 | 15678.0 ± 0.2% | 1467.2 ± 0.4% | 1083.7 ± 0.3% | 495.1 ± 1.3% | 989.1 ± 0.4% | 734.9 ± 0.2% | 10.685 | 14.467 | 31.669 | 15.851 | 21.334 |
| hex: canterbury/ptt5 | 524290 | 15557.9 ± 0.6% | 1477.6 ± 0.2% | 1092.7 ± 0.4% | 555.1 ± 0.9% | 992.2 ± 0.3% | 734.7 ± 0.7% | 10.529 | 14.237 | 28.026 | 15.681 | 21.177 |
| hex: canterbury/sum | 76482 | 15653.0 ± 0.0% | 1495.0 ± 0.2% | 1103.7 ± 0.1% | 594.9 ± 2.3% | 998.2 ± 0.1% | 744.7 ± 0.1% | 10.470 | 14.183 | 26.313 | 15.681 | 21.019 |
| hex: canterbury/xargs.1 | 8456 | 15037.4 ± 0.1% | 1429.1 ± 0.4% | 1093.7 ± 0.0% | 649.0 ± 3.4% | 1003.1 ± 0.2% | 729.0 ± 0.1% | 10.522 | 13.749 | 23.169 | 14.991 | 20.629 |
| hex: canterbury-large/E.coli | 524290 | 15674.5 ± 0.1% | 1474.0 ± 0.3% | 1089.1 ± 0.4% | 672.9 ± 0.2% | 990.4 ± 0.6% | 734.4 ± 0.4% | 10.634 | 14.392 | 23.294 | 15.827 | 21.344 |
| hex: canterbury-large/bible.txt | 524290 | 15642.0 ± 0.4% | 1465.1 ± 0.5% | 1087.3 ± 0.5% | 512.6 ± 0.5% | 989.2 ± 0.8% | 733.9 ± 1.1% | 10.677 | 14.386 | 30.515 | 15.813 | 21.313 |
| hex: canterbury-large/world192.txt | 524290 | 15624.5 ± 0.1% | 1468.3 ± 0.7% | 1083.8 ± 0.8% | 504.6 ± 0.8% | 988.5 ± 0.4% | 734.9 ± 0.5% | 10.642 | 14.416 | 30.962 | 15.806 | 21.261 |
| hex: http/html-1kx1024 | 2099200 | 13855.7 ± 0.3% | 1454.0 ± 0.2% | 1061.2 ± 0.2% | 502.3 ± 0.1% | 983.2 ± 0.5% | 693.1 ± 0.1% | 9.529 | 13.057 | 27.583 | 14.092 | 19.991 |
| hex: http/html-16kx64 | 2097280 | 15212.4 ± 0.6% | 1443.9 ± 0.1% | 1073.0 ± 0.1% | 506.6 ± 0.2% | 994.2 ± 0.1% | 735.3 ± 0.2% | 10.536 | 14.177 | 30.030 | 15.302 | 20.688 |
| hex: http/html-1m | 524290 | 15666.7 ± 0.3% | 1467.9 ± 0.2% | 1086.4 ± 0.3% | 500.9 ± 0.3% | 992.2 ± 0.4% | 735.3 ± 0.6% | 10.673 | 14.420 | 31.275 | 15.790 | 21.305 |
| hex: http/json-1kx1024 | 2099200 | 13779.0 ± 0.7% | 1462.6 ± 0.1% | 1066.3 ± 0.2% | 609.2 ± 0.2% | 986.7 ± 0.2% | 693.1 ± 0.1% | 9.421 | 12.922 | 22.618 | 13.965 | 19.879 |
| hex: http/json-16kx64 | 2097280 | 15287.8 ± 0.5% | 1445.1 ± 0.2% | 1074.0 ± 0.2% | 616.0 ± 0.8% | 994.2 ± 0.6% | 734.6 ± 0.1% | 10.579 | 14.234 | 24.819 | 15.377 | 20.812 |
| hex: http/json-1m | 524290 | 15599.3 ± 0.2% | 1470.5 ± 0.3% | 1088.8 ± 0.3% | 635.2 ± 2.2% | 989.7 ± 0.6% | 735.6 ± 0.4% | 10.608 | 14.327 | 24.558 | 15.762 | 21.205 |
| hex: http/js-1kx1024 | 2099200 | 13862.2 ± 0.2% | 1455.2 ± 0.1% | 1062.3 ± 0.4% | 497.9 ± 0.2% | 981.7 ± 0.4% | 692.6 ± 0.1% | 9.526 | 13.049 | 27.840 | 14.120 | 20.015 |
| hex: http/js-16kx64 | 2097280 | 15237.2 ± 0.4% | 1444.3 ± 0.2% | 1074.6 ± 0.1% | 504.5 ± 0.3% | 997.5 ± 0.3% | 734.9 ± 0.3% | 10.550 | 14.179 | 30.202 | 15.276 | 20.734 |
| hex: http/js-1m | 524290 | 15673.7 ± 0.2% | 1466.5 ± 0.3% | 1087.6 ± 0.1% | 511.6 ± 0.3% | 984.9 ± 0.3% | 733.0 ± 0.7% | 10.688 | 14.412 | 30.635 | 15.914 | 21.384 |
| hex: http/css-1kx1024 | 2099200 | 13838.1 ± 0.4% | 1455.1 ± 0.1% | 1061.8 ± 0.1% | 532.2 ± 0.3% | 984.0 ± 0.1% | 692.8 ± 0.1% | 9.510 | 13.033 | 26.003 | 14.064 | 19.975 |
| hex: http/css-16kx64 | 2097280 | 15229.6 ± 0.4% | 1445.0 ± 0.2% | 1073.9 ± 0.2% | 540.7 ± 0.4% | 998.9 ± 0.4% | 735.8 ± 0.2% | 10.539 | 14.182 | 28.165 | 15.247 | 20.697 |
| hex: http/css-1m | 524290 | 15670.1 ± 0.3% | 1460.8 ± 0.6% | 1086.0 ± 0.3% | 526.1 ± 0.2% | 990.1 ± 0.2% | 735.1 ± 0.5% | 10.727 | 14.429 | 29.787 | 15.828 | 21.317 |
| hex: shuffled/dickens-1m | 524290 | 15688.8 ± 0.2% | 1464.1 ± 0.2% | 1085.9 ± 0.3% | 501.9 ± 0.6% | 989.9 ± 0.5% | 734.9 ± 0.5% | 10.716 | 14.447 | 31.258 | 15.849 | 21.347 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 936.7 ± 0.2% | 929.4 ± 0.8% | 1022.4 ± 0.3% | 300.6 ± 1.1% | 667.0 ± 0.2% | 310.3 ± 1.5% | 1.008 | 0.916 | 3.116 | 1.404 | 3.018 |
| qlog records, JSON text sequence | 1467503 | 779.6 ± 0.8% | 817.2 ± 0.0% | 790.9 ± 0.4% | 244.2 ± 0.5% | 698.1 ± 1.0% | 250.7 ± 0.5% | 0.954 | 0.986 | 3.193 | 1.117 | 3.110 |
| string: silesia/dickens | 172528 | 5062.8 ± 0.2% | 1879.8 ± 0.3% | 2650.2 ± 0.3% | 362.6 ± 1.0% | 2846.8 ± 0.5% | 552.6 ± 2.4% | 2.693 | 1.910 | 13.961 | 1.778 | 9.162 |
| string: silesia/nci | 1075110 | 4295.1 ± 0.5% | 2239.7 ± 0.5% | 2994.4 ± 0.6% | 541.3 ± 1.1% | 3016.1 ± 0.6% | 591.7 ± 3.1% | 1.918 | 1.434 | 7.935 | 1.424 | 7.259 |
| string: silesia/reymont | 1075159 | 2955.5 ± 0.7% | 1813.7 ± 2.0% | 2062.0 ± 0.2% | 375.6 ± 0.4% | 2141.5 ± 0.5% | 535.8 ± 1.1% | 1.630 | 1.433 | 7.869 | 1.380 | 5.516 |
| string: silesia/samba | 97582 | 3502.8 ± 0.3% | 2025.4 ± 0.2% | 2617.6 ± 0.6% | 328.4 ± 0.2% | 1499.5 ± 0.8% | 425.5 ± 1.3% | 1.729 | 1.338 | 10.668 | 2.336 | 8.232 |
| string: silesia/webster | 1098490 | 3679.1 ± 0.5% | 1517.1 ± 0.4% | 2012.7 ± 0.3% | 359.2 ± 0.3% | 2191.9 ± 0.3% | 499.4 ± 2.2% | 2.425 | 1.828 | 10.242 | 1.678 | 7.368 |
| string: silesia/xml | 1090118 | 4813.2 ± 0.3% | 2362.0 ± 0.1% | 2528.3 ± 0.4% | 451.9 ± 0.7% | 2862.2 ± 0.3% | 565.8 ± 0.7% | 2.038 | 1.904 | 10.651 | 1.682 | 8.507 |
| string: canterbury/alice29.txt | 159425 | 4360.9 ± 0.7% | 1601.2 ± 0.2% | 2459.4 ± 0.7% | 342.2 ± 0.4% | 2500.4 ± 0.3% | 503.5 ± 0.9% | 2.724 | 1.773 | 12.743 | 1.744 | 8.661 |
| string: canterbury/asyoulik.txt | 132198 | 3500.0 ± 0.9% | 1457.8 ± 0.3% | 2245.4 ± 0.8% | 334.6 ± 0.7% | 2075.7 ± 0.5% | 459.0 ± 1.7% | 2.401 | 1.559 | 10.461 | 1.686 | 7.625 |
| string: canterbury/lcet10.txt | 441884 | 5126.3 ± 0.3% | 1850.5 ± 0.3% | 2337.4 ± 1.2% | 390.0 ± 0.4% | 2829.6 ± 0.4% | 534.2 ± 3.1% | 2.770 | 2.193 | 13.143 | 1.812 | 9.596 |
| string: canterbury/plrabn12.txt | 503330 | 4120.3 ± 0.3% | 1735.2 ± 0.3% | 2059.7 ± 0.3% | 359.3 ± 0.3% | 2491.8 ± 0.2% | 496.1 ± 0.8% | 2.375 | 2.000 | 11.467 | 1.654 | 8.306 |
| string: canterbury-large/E.coli | 1048578 | 11900.1 ± 0.2% | 3604.5 ± 0.5% | 3250.2 ± 0.4% | 929.2 ± 0.9% | 5986.7 ± 1.2% | 745.7 ± 0.6% | 3.301 | 3.661 | 12.806 | 1.988 | 15.958 |
| string: canterbury-large/bible.txt | 1055886 | 6943.2 ± 2.0% | 2937.9 ± 0.7% | 2828.5 ± 0.8% | 421.8 ± 2.3% | 3759.7 ± 2.7% | 612.7 ± 2.7% | 2.363 | 2.455 | 16.462 | 1.847 | 11.332 |
| string: canterbury-large/world192.txt | 1103121 | 3394.1 ± 0.4% | 1482.6 ± 0.2% | 2011.6 ± 0.3% | 352.5 ± 0.4% | 2118.5 ± 0.5% | 501.4 ± 1.1% | 2.289 | 1.687 | 9.628 | 1.602 | 6.770 |
| string: http/html-1m | 1058582 | 6221.2 ± 1.4% | 2736.4 ± 0.8% | 2708.0 ± 0.4% | 442.0 ± 0.7% | 3475.9 ± 0.7% | 599.3 ± 1.1% | 2.273 | 2.297 | 14.075 | 1.790 | 10.380 |
| string: http/json-1m | 1190272 | 2556.4 ± 0.4% | 878.5 ± 0.3% | 2253.1 ± 0.2% | 390.1 ± 0.6% | 1063.4 ± 0.5% | 443.5 ± 0.4% | 2.910 | 1.135 | 6.553 | 2.404 | 5.764 |
| string: http/js-1m | 1144362 | 2287.3 ± 0.2% | 1028.0 ± 0.4% | 1639.2 ± 0.4% | 319.8 ± 0.7% | 1524.3 ± 0.4% | 419.6 ± 0.7% | 2.225 | 1.395 | 7.151 | 1.501 | 5.451 |
| string: http/css-1m | 1097820 | 2656.3 ± 0.3% | 1678.2 ± 0.3% | 2230.0 ± 0.8% | 404.7 ± 1.4% | 1951.1 ± 0.5% | 489.8 ± 0.8% | 1.583 | 1.191 | 6.564 | 1.361 | 5.423 |
| string: dickens as Cyrillic and CJK | 1883069 | 3089.5 ± 0.3% | 1684.1 ± 0.2% | 895.6 ± 0.5% | 351.6 ± 0.2% | 669.2 ± 0.7% | 157.2 ± 2.8% | 1.835 | 3.450 | 8.788 | 4.617 | 19.648 |
| string: dickens as Cyrillic and CJK, as \u escapes | 5075485 | 1329.7 ± 0.2% | 980.7 ± 0.2% | 1217.2 ± 0.4% | 216.1 ± 0.1% | 471.2 ± 0.5% | 251.5 ± 4.3% | 1.356 | 1.092 | 6.154 | 2.822 | 5.286 |
| hex: silesia/dickens | 524290 | 12011.4 ± 0.1% | 3610.5 ± 0.3% | 3287.2 ± 0.4% | 515.1 ± 2.1% | 6123.2 ± 0.7% | 780.9 ± 3.9% | 3.327 | 3.654 | 23.321 | 1.962 | 15.381 |
| hex: silesia/mozilla | 524290 | 11984.2 ± 0.1% | 3617.7 ± 0.2% | 3282.1 ± 0.1% | 453.0 ± 1.0% | 6108.6 ± 2.7% | 781.3 ± 0.5% | 3.313 | 3.651 | 26.453 | 1.962 | 15.339 |
| hex: silesia/mr | 524290 | 11953.8 ± 0.2% | 3612.9 ± 0.2% | 3279.5 ± 0.6% | 571.9 ± 4.4% | 6054.8 ± 0.7% | 784.3 ± 0.7% | 3.309 | 3.645 | 20.901 | 1.974 | 15.242 |
| hex: silesia/nci | 524290 | 11983.9 ± 0.3% | 3615.2 ± 0.3% | 3290.6 ± 0.2% | 625.8 ± 3.9% | 6070.2 ± 2.1% | 782.2 ± 0.4% | 3.315 | 3.642 | 19.151 | 1.974 | 15.320 |
| hex: silesia/ooffice | 524290 | 12003.0 ± 0.1% | 3613.9 ± 0.1% | 3295.1 ± 0.3% | 403.3 ± 1.8% | 6094.8 ± 0.5% | 781.7 ± 0.6% | 3.321 | 3.643 | 29.764 | 1.969 | 15.355 |
| hex: silesia/osdb | 524290 | 11988.3 ± 0.1% | 3614.3 ± 0.2% | 3285.8 ± 0.5% | 495.5 ± 3.8% | 6103.8 ± 1.8% | 783.2 ± 0.9% | 3.317 | 3.648 | 24.195 | 1.964 | 15.306 |
| hex: silesia/reymont | 524290 | 12022.5 ± 0.1% | 3611.5 ± 0.2% | 3301.7 ± 0.3% | 522.5 ± 2.8% | 6125.9 ± 1.1% | 782.6 ± 0.5% | 3.329 | 3.641 | 23.007 | 1.963 | 15.361 |
| hex: silesia/samba | 524290 | 11966.2 ± 0.3% | 3614.8 ± 0.1% | 3295.1 ± 0.2% | 410.8 ± 1.4% | 6019.9 ± 0.6% | 784.2 ± 0.6% | 3.310 | 3.631 | 29.129 | 1.988 | 15.258 |
| hex: silesia/sao | 524290 | 12014.3 ± 0.1% | 3614.6 ± 0.3% | 3292.0 ± 0.2% | 343.4 ± 1.5% | 6109.8 ± 2.8% | 781.8 ± 0.4% | 3.324 | 3.650 | 34.987 | 1.966 | 15.368 |
| hex: silesia/webster | 524290 | 12007.8 ± 0.1% | 3616.0 ± 0.3% | 3300.5 ± 0.4% | 464.5 ± 2.2% | 6122.3 ± 1.2% | 782.1 ± 0.9% | 3.321 | 3.638 | 25.849 | 1.961 | 15.352 |
| hex: silesia/x-ray | 524290 | 12000.1 ± 0.1% | 3612.7 ± 0.4% | 3293.7 ± 0.3% | 477.6 ± 1.4% | 6121.9 ± 1.9% | 782.1 ± 0.2% | 3.322 | 3.643 | 25.128 | 1.960 | 15.343 |
| hex: silesia/xml | 524290 | 11924.1 ± 0.3% | 3610.1 ± 0.3% | 3285.7 ± 0.2% | 516.7 ± 1.7% | 6047.9 ± 0.9% | 783.3 ± 0.6% | 3.303 | 3.629 | 23.078 | 1.972 | 15.222 |
| hex: canterbury/alice29.txt | 304180 | 12011.8 ± 0.1% | 3635.6 ± 0.1% | 3345.8 ± 0.3% | 514.9 ± 3.9% | 6145.5 ± 0.9% | 783.0 ± 0.5% | 3.304 | 3.590 | 23.328 | 1.955 | 15.340 |
| hex: canterbury/asyoulik.txt | 250360 | 12005.3 ± 0.1% | 3635.1 ± 0.3% | 3378.3 ± 0.1% | 516.7 ± 0.8% | 6133.6 ± 1.2% | 779.8 ± 0.4% | 3.303 | 3.554 | 23.233 | 1.957 | 15.396 |
| hex: canterbury/cp.html | 49208 | 11904.1 ± 0.0% | 3640.2 ± 0.0% | 3277.7 ± 0.1% | 482.1 ± 1.6% | 6284.3 ± 0.5% | 767.5 ± 1.1% | 3.270 | 3.632 | 24.694 | 1.894 | 15.510 |
| hex: canterbury/fields.c | 22302 | 11775.9 ± 0.5% | 3629.0 ± 0.1% | 3350.8 ± 0.0% | 511.6 ± 0.2% | 6253.3 ± 1.0% | 754.8 ± 1.3% | 3.245 | 3.514 | 23.019 | 1.883 | 15.601 |
| hex: canterbury/grammar.lsp | 7444 | 11256.5 ± 0.1% | 3601.6 ± 0.0% | 3352.7 ± 0.4% | 541.4 ± 2.1% | 6162.6 ± 0.5% | 732.5 ± 1.1% | 3.125 | 3.357 | 20.793 | 1.827 | 15.367 |
| hex: canterbury/kennedy.xls | 524290 | 11921.8 ± 0.3% | 3612.5 ± 0.1% | 3292.2 ± 0.4% | 656.8 ± 7.9% | 6091.5 ± 0.7% | 764.2 ± 5.1% | 3.300 | 3.621 | 18.151 | 1.957 | 15.600 |
| hex: canterbury/lcet10.txt | 524290 | 12011.1 ± 0.1% | 3612.1 ± 0.1% | 3289.6 ± 0.4% | 523.0 ± 3.7% | 6161.4 ± 1.1% | 775.9 ± 1.5% | 3.325 | 3.651 | 22.965 | 1.949 | 15.480 |
| hex: canterbury/plrabn12.txt | 524290 | 11958.5 ± 0.1% | 3613.0 ± 0.2% | 3288.8 ± 0.3% | 516.4 ± 0.4% | 6027.2 ± 0.8% | 777.3 ± 1.5% | 3.310 | 3.636 | 23.159 | 1.984 | 15.384 |
| hex: canterbury/ptt5 | 524290 | 11993.9 ± 0.1% | 3611.0 ± 0.2% | 3290.3 ± 0.3% | 559.2 ± 2.9% | 6057.3 ± 1.6% | 777.3 ± 0.5% | 3.321 | 3.645 | 21.449 | 1.980 | 15.430 |
| hex: canterbury/sum | 76482 | 11904.2 ± 0.1% | 3633.7 ± 0.0% | 3356.1 ± 0.1% | 511.2 ± 2.4% | 6173.2 ± 0.3% | 775.2 ± 1.3% | 3.276 | 3.547 | 23.285 | 1.928 | 15.356 |
| hex: canterbury/xargs.1 | 8456 | 11348.0 ± 0.1% | 3602.6 ± 0.0% | 3371.8 ± 0.1% | 495.8 ± 2.1% | 6143.2 ± 0.5% | 756.2 ± 0.8% | 3.150 | 3.366 | 22.890 | 1.847 | 15.006 |
| hex: canterbury-large/E.coli | 524290 | 11932.7 ± 0.1% | 3616.4 ± 0.2% | 3295.3 ± 0.2% | 689.3 ± 0.4% | 6117.6 ± 0.5% | 768.1 ± 1.8% | 3.300 | 3.621 | 17.311 | 1.951 | 15.536 |
| hex: canterbury-large/bible.txt | 524290 | 12019.8 ± 0.3% | 3616.3 ± 0.1% | 3289.7 ± 0.3% | 515.9 ± 2.3% | 6146.2 ± 0.7% | 770.7 ± 0.7% | 3.324 | 3.654 | 23.297 | 1.956 | 15.596 |
| hex: canterbury-large/world192.txt | 524290 | 12001.4 ± 0.1% | 3614.8 ± 0.2% | 3293.2 ± 0.2% | 497.5 ± 3.0% | 6121.6 ± 0.7% | 772.9 ± 0.9% | 3.320 | 3.644 | 24.124 | 1.960 | 15.529 |
| hex: http/html-1kx1024 | 2099200 | 8795.0 ± 3.6% | 3462.9 ± 0.3% | 2858.2 ± 0.4% | 475.2 ± 0.3% | 5144.3 ± 0.8% | 648.8 ± 2.3% | 2.540 | 3.077 | 18.508 | 1.710 | 13.556 |
| hex: http/html-16kx64 | 2097280 | 11762.2 ± 0.3% | 3610.1 ± 0.1% | 3265.3 ± 0.4% | 477.6 ± 1.6% | 6016.9 ± 0.4% | 756.3 ± 1.6% | 3.258 | 3.602 | 24.628 | 1.955 | 15.553 |
| hex: http/html-1m | 524290 | 12001.0 ± 0.1% | 3617.7 ± 0.2% | 3284.7 ± 0.2% | 494.5 ± 1.2% | 6112.2 ± 0.8% | 761.4 ± 1.0% | 3.317 | 3.654 | 24.268 | 1.963 | 15.761 |
| hex: http/json-1kx1024 | 2099200 | 8785.3 ± 3.6% | 3464.1 ± 0.3% | 2854.0 ± 0.4% | 576.1 ± 0.5% | 5140.3 ± 1.0% | 649.5 ± 1.2% | 2.536 | 3.078 | 15.250 | 1.709 | 13.527 |
| hex: http/json-16kx64 | 2097280 | 11776.1 ± 0.3% | 3610.2 ± 0.5% | 3277.6 ± 5.2% | 572.4 ± 0.6% | 6009.8 ± 1.6% | 757.4 ± 0.9% | 3.262 | 3.593 | 20.575 | 1.959 | 15.549 |
| hex: http/json-1m | 524290 | 12011.7 ± 0.0% | 3614.4 ± 0.2% | 3288.4 ± 0.5% | 587.8 ± 2.7% | 6151.6 ± 2.1% | 771.5 ± 2.3% | 3.323 | 3.653 | 20.437 | 1.953 | 15.570 |
| hex: http/js-1kx1024 | 2099200 | 8775.8 ± 4.0% | 3460.4 ± 0.2% | 2859.4 ± 0.3% | 481.9 ± 0.5% | 5120.9 ± 2.0% | 635.0 ± 3.7% | 2.536 | 3.069 | 18.210 | 1.714 | 13.820 |
| hex: http/js-16kx64 | 2097280 | 11769.7 ± 0.3% | 3608.6 ± 0.2% | 3265.0 ± 0.3% | 481.0 ± 0.7% | 6018.5 ± 0.3% | 758.0 ± 2.6% | 3.262 | 3.605 | 24.469 | 1.956 | 15.528 |
| hex: http/js-1m | 524290 | 11995.4 ± 0.1% | 3614.0 ± 0.2% | 3289.3 ± 0.2% | 505.5 ± 1.0% | 6134.7 ± 2.1% | 781.0 ± 2.6% | 3.319 | 3.647 | 23.728 | 1.955 | 15.359 |
| hex: http/css-1kx1024 | 2099200 | 8804.0 ± 3.5% | 3462.3 ± 0.2% | 2842.9 ± 0.7% | 488.7 ± 1.2% | 5095.7 ± 1.1% | 651.8 ± 1.7% | 2.543 | 3.097 | 18.014 | 1.728 | 13.507 |
| hex: http/css-16kx64 | 2097280 | 11762.8 ± 0.4% | 3608.6 ± 0.2% | 3259.6 ± 0.3% | 494.6 ± 1.0% | 6011.2 ± 0.2% | 759.3 ± 1.0% | 3.260 | 3.609 | 23.784 | 1.957 | 15.492 |
| hex: http/css-1m | 524290 | 12026.6 ± 0.2% | 3610.1 ± 0.2% | 3304.3 ± 0.3% | 500.9 ± 1.8% | 6113.9 ± 1.2% | 761.5 ± 2.7% | 3.331 | 3.640 | 24.008 | 1.967 | 15.792 |
| hex: shuffled/dickens-1m | 524290 | 11992.1 ± 0.0% | 3613.6 ± 0.2% | 3294.6 ± 0.3% | 512.9 ± 1.1% | 6042.2 ± 0.7% | 766.3 ± 1.1% | 3.319 | 3.640 | 23.380 | 1.985 | 15.650 |

## TextReader.next_items against the baselines

stdx's decoder a slice of tokens a call through `TextReader.next_items`, as a caller that reads a text's values in a loop calls it (decision 79). Octets are the text's. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1014.5 ± 0.1% | 929.4 ± 0.8% | 1022.4 ± 0.3% | 300.6 ± 1.1% | 667.0 ± 0.2% | 310.3 ± 1.5% | 1.092 | 0.992 | 3.375 | 1.521 | 3.269 |
| qlog records, JSON text sequence | 1467503 | 839.8 ± 0.5% | 817.2 ± 0.0% | 790.9 ± 0.4% | 244.2 ± 0.5% | 698.1 ± 1.0% | 250.7 ± 0.5% | 1.028 | 1.062 | 3.440 | 1.203 | 3.351 |
| string: silesia/dickens | 172528 | 5062.6 ± 0.2% | 1879.8 ± 0.3% | 2650.2 ± 0.3% | 362.6 ± 1.0% | 2846.8 ± 0.5% | 552.6 ± 2.4% | 2.693 | 1.910 | 13.961 | 1.778 | 9.161 |
| string: silesia/nci | 1075110 | 4306.6 ± 0.5% | 2239.7 ± 0.5% | 2994.4 ± 0.6% | 541.3 ± 1.1% | 3016.1 ± 0.6% | 591.7 ± 3.1% | 1.923 | 1.438 | 7.957 | 1.428 | 7.278 |
| string: silesia/reymont | 1075159 | 2966.8 ± 1.2% | 1813.7 ± 2.0% | 2062.0 ± 0.2% | 375.6 ± 0.4% | 2141.5 ± 0.5% | 535.8 ± 1.1% | 1.636 | 1.439 | 7.899 | 1.385 | 5.537 |
| string: silesia/samba | 97582 | 3512.9 ± 0.4% | 2025.4 ± 0.2% | 2617.6 ± 0.6% | 328.4 ± 0.2% | 1499.5 ± 0.8% | 425.5 ± 1.3% | 1.734 | 1.342 | 10.699 | 2.343 | 8.256 |
| string: silesia/webster | 1098490 | 3674.9 ± 0.5% | 1517.1 ± 0.4% | 2012.7 ± 0.3% | 359.2 ± 0.3% | 2191.9 ± 0.3% | 499.4 ± 2.2% | 2.422 | 1.826 | 10.230 | 1.677 | 7.359 |
| string: silesia/xml | 1090118 | 4820.3 ± 0.3% | 2362.0 ± 0.1% | 2528.3 ± 0.4% | 451.9 ± 0.7% | 2862.2 ± 0.3% | 565.8 ± 0.7% | 2.041 | 1.907 | 10.667 | 1.684 | 8.520 |
| string: canterbury/alice29.txt | 159425 | 4375.6 ± 0.5% | 1601.2 ± 0.2% | 2459.4 ± 0.7% | 342.2 ± 0.4% | 2500.4 ± 0.3% | 503.5 ± 0.9% | 2.733 | 1.779 | 12.786 | 1.750 | 8.691 |
| string: canterbury/asyoulik.txt | 132198 | 3503.8 ± 0.7% | 1457.8 ± 0.3% | 2245.4 ± 0.8% | 334.6 ± 0.7% | 2075.7 ± 0.5% | 459.0 ± 1.7% | 2.404 | 1.560 | 10.472 | 1.688 | 7.633 |
| string: canterbury/lcet10.txt | 441884 | 5131.8 ± 0.5% | 1850.5 ± 0.3% | 2337.4 ± 1.2% | 390.0 ± 0.4% | 2829.6 ± 0.4% | 534.2 ± 3.1% | 2.773 | 2.196 | 13.157 | 1.814 | 9.606 |
| string: canterbury/plrabn12.txt | 503330 | 4119.3 ± 0.2% | 1735.2 ± 0.3% | 2059.7 ± 0.3% | 359.3 ± 0.3% | 2491.8 ± 0.2% | 496.1 ± 0.8% | 2.374 | 2.000 | 11.464 | 1.653 | 8.304 |
| string: canterbury-large/E.coli | 1048578 | 11915.4 ± 0.5% | 3604.5 ± 0.5% | 3250.2 ± 0.4% | 929.2 ± 0.9% | 5986.7 ± 1.2% | 745.7 ± 0.6% | 3.306 | 3.666 | 12.823 | 1.990 | 15.979 |
| string: canterbury-large/bible.txt | 1055886 | 6948.8 ± 2.3% | 2937.9 ± 0.7% | 2828.5 ± 0.8% | 421.8 ± 2.3% | 3759.7 ± 2.7% | 612.7 ± 2.7% | 2.365 | 2.457 | 16.476 | 1.848 | 11.341 |
| string: canterbury-large/world192.txt | 1103121 | 3392.7 ± 0.1% | 1482.6 ± 0.2% | 2011.6 ± 0.3% | 352.5 ± 0.4% | 2118.5 ± 0.5% | 501.4 ± 1.1% | 2.288 | 1.687 | 9.625 | 1.601 | 6.767 |
| string: http/html-1m | 1058582 | 6235.1 ± 1.6% | 2736.4 ± 0.8% | 2708.0 ± 0.4% | 442.0 ± 0.7% | 3475.9 ± 0.7% | 599.3 ± 1.1% | 2.279 | 2.303 | 14.106 | 1.794 | 10.403 |
| string: http/json-1m | 1190272 | 2562.2 ± 0.4% | 878.5 ± 0.3% | 2253.1 ± 0.2% | 390.1 ± 0.6% | 1063.4 ± 0.5% | 443.5 ± 0.4% | 2.917 | 1.137 | 6.568 | 2.409 | 5.777 |
| string: http/js-1m | 1144362 | 2290.4 ± 0.8% | 1028.0 ± 0.4% | 1639.2 ± 0.4% | 319.8 ± 0.7% | 1524.3 ± 0.4% | 419.6 ± 0.7% | 2.228 | 1.397 | 7.161 | 1.503 | 5.459 |
| string: http/css-1m | 1097820 | 2662.9 ± 0.4% | 1678.2 ± 0.3% | 2230.0 ± 0.8% | 404.7 ± 1.4% | 1951.1 ± 0.5% | 489.8 ± 0.8% | 1.587 | 1.194 | 6.580 | 1.365 | 5.437 |
| string: dickens as Cyrillic and CJK | 1883069 | 3089.6 ± 0.5% | 1684.1 ± 0.2% | 895.6 ± 0.5% | 351.6 ± 0.2% | 669.2 ± 0.7% | 157.2 ± 2.8% | 1.835 | 3.450 | 8.788 | 4.617 | 19.649 |
| string: dickens as Cyrillic and CJK, as \u escapes | 5075485 | 1330.6 ± 0.3% | 980.7 ± 0.2% | 1217.2 ± 0.4% | 216.1 ± 0.1% | 471.2 ± 0.5% | 251.5 ± 4.3% | 1.357 | 1.093 | 6.158 | 2.824 | 5.290 |
| hex: silesia/dickens | 524290 | 12010.4 ± 0.1% | 3610.5 ± 0.3% | 3287.2 ± 0.4% | 515.1 ± 2.1% | 6123.2 ± 0.7% | 780.9 ± 3.9% | 3.326 | 3.654 | 23.319 | 1.961 | 15.380 |
| hex: silesia/mozilla | 524290 | 11977.1 ± 0.0% | 3617.7 ± 0.2% | 3282.1 ± 0.1% | 453.0 ± 1.0% | 6108.6 ± 2.7% | 781.3 ± 0.5% | 3.311 | 3.649 | 26.437 | 1.961 | 15.330 |
| hex: silesia/mr | 524290 | 11959.2 ± 0.2% | 3612.9 ± 0.2% | 3279.5 ± 0.6% | 571.9 ± 4.4% | 6054.8 ± 0.7% | 784.3 ± 0.7% | 3.310 | 3.647 | 20.911 | 1.975 | 15.249 |
| hex: silesia/nci | 524290 | 11991.0 ± 0.2% | 3615.2 ± 0.3% | 3290.6 ± 0.2% | 625.8 ± 3.9% | 6070.2 ± 2.1% | 782.2 ± 0.4% | 3.317 | 3.644 | 19.162 | 1.975 | 15.329 |
| hex: silesia/ooffice | 524290 | 11998.3 ± 0.1% | 3613.9 ± 0.1% | 3295.1 ± 0.3% | 403.3 ± 1.8% | 6094.8 ± 0.5% | 781.7 ± 0.6% | 3.320 | 3.641 | 29.752 | 1.969 | 15.349 |
| hex: silesia/osdb | 524290 | 11992.7 ± 0.1% | 3614.3 ± 0.2% | 3285.8 ± 0.5% | 495.5 ± 3.8% | 6103.8 ± 1.8% | 783.2 ± 0.9% | 3.318 | 3.650 | 24.204 | 1.965 | 15.312 |
| hex: silesia/reymont | 524290 | 12021.6 ± 0.1% | 3611.5 ± 0.2% | 3301.7 ± 0.3% | 522.5 ± 2.8% | 6125.9 ± 1.1% | 782.6 ± 0.5% | 3.329 | 3.641 | 23.006 | 1.962 | 15.360 |
| hex: silesia/samba | 524290 | 11971.1 ± 0.1% | 3614.8 ± 0.1% | 3295.1 ± 0.2% | 410.8 ± 1.4% | 6019.9 ± 0.6% | 784.2 ± 0.6% | 3.312 | 3.633 | 29.141 | 1.989 | 15.265 |
| hex: silesia/sao | 524290 | 12017.0 ± 0.1% | 3614.6 ± 0.3% | 3292.0 ± 0.2% | 343.4 ± 1.5% | 6109.8 ± 2.8% | 781.8 ± 0.4% | 3.325 | 3.650 | 34.995 | 1.967 | 15.372 |
| hex: silesia/webster | 524290 | 12011.0 ± 0.1% | 3616.0 ± 0.3% | 3300.5 ± 0.4% | 464.5 ± 2.2% | 6122.3 ± 1.2% | 782.1 ± 0.9% | 3.322 | 3.639 | 25.856 | 1.962 | 15.357 |
| hex: silesia/x-ray | 524290 | 11997.4 ± 0.1% | 3612.7 ± 0.4% | 3293.7 ± 0.3% | 477.6 ± 1.4% | 6121.9 ± 1.9% | 782.1 ± 0.2% | 3.321 | 3.643 | 25.122 | 1.960 | 15.340 |
| hex: silesia/xml | 524290 | 11954.2 ± 0.4% | 3610.1 ± 0.3% | 3285.7 ± 0.2% | 516.7 ± 1.7% | 6047.9 ± 0.9% | 783.3 ± 0.6% | 3.311 | 3.638 | 23.136 | 1.977 | 15.261 |
| hex: canterbury/alice29.txt | 304180 | 12011.4 ± 0.1% | 3635.6 ± 0.1% | 3345.8 ± 0.3% | 514.9 ± 3.9% | 6145.5 ± 0.9% | 783.0 ± 0.5% | 3.304 | 3.590 | 23.327 | 1.954 | 15.339 |
| hex: canterbury/asyoulik.txt | 250360 | 12004.8 ± 0.3% | 3635.1 ± 0.3% | 3378.3 ± 0.1% | 516.7 ± 0.8% | 6133.6 ± 1.2% | 779.8 ± 0.4% | 3.302 | 3.554 | 23.232 | 1.957 | 15.396 |
| hex: canterbury/cp.html | 49208 | 11906.3 ± 0.0% | 3640.2 ± 0.0% | 3277.7 ± 0.1% | 482.1 ± 1.6% | 6284.3 ± 0.5% | 767.5 ± 1.1% | 3.271 | 3.632 | 24.698 | 1.895 | 15.513 |
| hex: canterbury/fields.c | 22302 | 11784.6 ± 0.0% | 3629.0 ± 0.1% | 3350.8 ± 0.0% | 511.6 ± 0.2% | 6253.3 ± 1.0% | 754.8 ± 1.3% | 3.247 | 3.517 | 23.036 | 1.885 | 15.613 |
| hex: canterbury/grammar.lsp | 7444 | 11308.2 ± 0.2% | 3601.6 ± 0.0% | 3352.7 ± 0.4% | 541.4 ± 2.1% | 6162.6 ± 0.5% | 732.5 ± 1.1% | 3.140 | 3.373 | 20.889 | 1.835 | 15.437 |
| hex: canterbury/kennedy.xls | 524290 | 11995.6 ± 0.2% | 3612.5 ± 0.1% | 3292.2 ± 0.4% | 656.8 ± 7.9% | 6091.5 ± 0.7% | 764.2 ± 5.1% | 3.321 | 3.644 | 18.263 | 1.969 | 15.696 |
| hex: canterbury/lcet10.txt | 524290 | 12004.9 ± 0.1% | 3612.1 ± 0.1% | 3289.6 ± 0.4% | 523.0 ± 3.7% | 6161.4 ± 1.1% | 775.9 ± 1.5% | 3.324 | 3.649 | 22.954 | 1.948 | 15.472 |
| hex: canterbury/plrabn12.txt | 524290 | 11944.3 ± 0.1% | 3613.0 ± 0.2% | 3288.8 ± 0.3% | 516.4 ± 0.4% | 6027.2 ± 0.8% | 777.3 ± 1.5% | 3.306 | 3.632 | 23.132 | 1.982 | 15.366 |
| hex: canterbury/ptt5 | 524290 | 11993.3 ± 0.1% | 3611.0 ± 0.2% | 3290.3 ± 0.3% | 559.2 ± 2.9% | 6057.3 ± 1.6% | 777.3 ± 0.5% | 3.321 | 3.645 | 21.448 | 1.980 | 15.429 |
| hex: canterbury/sum | 76482 | 11884.5 ± 0.2% | 3633.7 ± 0.0% | 3356.1 ± 0.1% | 511.2 ± 2.4% | 6173.2 ± 0.3% | 775.2 ± 1.3% | 3.271 | 3.541 | 23.247 | 1.925 | 15.330 |
| hex: canterbury/xargs.1 | 8456 | 11352.2 ± 0.0% | 3602.6 ± 0.0% | 3371.8 ± 0.1% | 495.8 ± 2.1% | 6143.2 ± 0.5% | 756.2 ± 0.8% | 3.151 | 3.367 | 22.899 | 1.848 | 15.012 |
| hex: canterbury-large/E.coli | 524290 | 12000.8 ± 0.1% | 3616.4 ± 0.2% | 3295.3 ± 0.2% | 689.3 ± 0.4% | 6117.6 ± 0.5% | 768.1 ± 1.8% | 3.318 | 3.642 | 17.410 | 1.962 | 15.625 |
| hex: canterbury-large/bible.txt | 524290 | 12018.4 ± 0.1% | 3616.3 ± 0.1% | 3289.7 ± 0.3% | 515.9 ± 2.3% | 6146.2 ± 0.7% | 770.7 ± 0.7% | 3.323 | 3.653 | 23.295 | 1.955 | 15.594 |
| hex: canterbury-large/world192.txt | 524290 | 12015.8 ± 0.1% | 3614.8 ± 0.2% | 3293.2 ± 0.2% | 497.5 ± 3.0% | 6121.6 ± 0.7% | 772.9 ± 0.9% | 3.324 | 3.649 | 24.153 | 1.963 | 15.547 |
| hex: http/html-1kx1024 | 2099200 | 8882.2 ± 3.2% | 3462.9 ± 0.3% | 2858.2 ± 0.4% | 475.2 ± 0.3% | 5144.3 ± 0.8% | 648.8 ± 2.3% | 2.565 | 3.108 | 18.691 | 1.727 | 13.690 |
| hex: http/html-16kx64 | 2097280 | 11769.9 ± 0.1% | 3610.1 ± 0.1% | 3265.3 ± 0.4% | 477.6 ± 1.6% | 6016.9 ± 0.4% | 756.3 ± 1.6% | 3.260 | 3.604 | 24.644 | 1.956 | 15.563 |
| hex: http/html-1m | 524290 | 11999.4 ± 0.1% | 3617.7 ± 0.2% | 3284.7 ± 0.2% | 494.5 ± 1.2% | 6112.2 ± 0.8% | 761.4 ± 1.0% | 3.317 | 3.653 | 24.265 | 1.963 | 15.759 |
| hex: http/json-1kx1024 | 2099200 | 8812.2 ± 3.8% | 3464.1 ± 0.3% | 2854.0 ± 0.4% | 576.1 ± 0.5% | 5140.3 ± 1.0% | 649.5 ± 1.2% | 2.544 | 3.088 | 15.297 | 1.714 | 13.568 |
| hex: http/json-16kx64 | 2097280 | 11762.0 ± 0.2% | 3610.2 ± 0.5% | 3277.6 ± 5.2% | 572.4 ± 0.6% | 6009.8 ± 1.6% | 757.4 ± 0.9% | 3.258 | 3.589 | 20.550 | 1.957 | 15.530 |
| hex: http/json-1m | 524290 | 12013.0 ± 0.1% | 3614.4 ± 0.2% | 3288.4 ± 0.5% | 587.8 ± 2.7% | 6151.6 ± 2.1% | 771.5 ± 2.3% | 3.324 | 3.653 | 20.439 | 1.953 | 15.571 |
| hex: http/js-1kx1024 | 2099200 | 8829.0 ± 4.2% | 3460.4 ± 0.2% | 2859.4 ± 0.3% | 481.9 ± 0.5% | 5120.9 ± 2.0% | 635.0 ± 3.7% | 2.551 | 3.088 | 18.320 | 1.724 | 13.904 |
| hex: http/js-16kx64 | 2097280 | 11770.0 ± 0.1% | 3608.6 ± 0.2% | 3265.0 ± 0.3% | 481.0 ± 0.7% | 6018.5 ± 0.3% | 758.0 ± 2.6% | 3.262 | 3.605 | 24.470 | 1.956 | 15.528 |
| hex: http/js-1m | 524290 | 11998.6 ± 0.1% | 3614.0 ± 0.2% | 3289.3 ± 0.2% | 505.5 ± 1.0% | 6134.7 ± 2.1% | 781.0 ± 2.6% | 3.320 | 3.648 | 23.735 | 1.956 | 15.363 |
| hex: http/css-1kx1024 | 2099200 | 8869.1 ± 3.9% | 3462.3 ± 0.2% | 2842.9 ± 0.7% | 488.7 ± 1.2% | 5095.7 ± 1.1% | 651.8 ± 1.7% | 2.562 | 3.120 | 18.148 | 1.740 | 13.607 |
| hex: http/css-16kx64 | 2097280 | 11771.5 ± 0.2% | 3608.6 ± 0.2% | 3259.6 ± 0.3% | 494.6 ± 1.0% | 6011.2 ± 0.2% | 759.3 ± 1.0% | 3.262 | 3.611 | 23.801 | 1.958 | 15.504 |
| hex: http/css-1m | 524290 | 12022.3 ± 0.0% | 3610.1 ± 0.2% | 3304.3 ± 0.3% | 500.9 ± 1.8% | 6113.9 ± 1.2% | 761.5 ± 2.7% | 3.330 | 3.638 | 24.000 | 1.966 | 15.787 |
| hex: shuffled/dickens-1m | 524290 | 11992.7 ± 0.1% | 3613.6 ± 0.2% | 3294.6 ± 0.3% | 512.9 ± 1.1% | 6042.2 ± 0.7% | 766.3 ± 1.1% | 3.319 | 3.640 | 23.381 | 1.985 | 15.650 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1358.8 ± 0.3% | 1253.3 ± 0.4% | 1040.7 ± 0.6% | 408.8 ± 0.2% | 448.2 ± 0.6% | 416.9 ± 0.4% | 1.084 | 1.306 | 3.324 | 3.032 | 3.259 |
| qlog records, JSON text sequence | 1467503 | 1053.9 ± 0.1% | 1065.7 ± 0.1% | 786.2 ± 0.5% | 376.8 ± 1.0% | 468.9 ± 0.6% | 279.0 ± 0.5% | 0.989 | 1.340 | 2.797 | 2.248 | 3.777 |
| string: silesia/dickens | 172528 | 6924.0 ± 0.4% | 2813.8 ± 0.2% | 2934.7 ± 0.9% | 432.2 ± 0.5% | 1595.3 ± 0.2% | 1012.0 ± 0.1% | 2.461 | 2.359 | 16.020 | 4.340 | 6.842 |
| string: silesia/nci | 1075110 | 7319.6 ± 0.4% | 3397.2 ± 1.2% | 3097.6 ± 0.6% | 810.5 ± 1.5% | 1858.7 ± 0.3% | 1109.4 ± 0.5% | 2.155 | 2.363 | 9.031 | 3.938 | 6.598 |
| string: silesia/reymont | 1075159 | 3361.0 ± 1.9% | 1968.5 ± 1.2% | 2065.6 ± 0.9% | 450.0 ± 1.2% | 1510.6 ± 0.2% | 952.5 ± 0.6% | 1.707 | 1.627 | 7.468 | 2.225 | 3.529 |
| string: silesia/samba | 97582 | 4214.9 ± 0.5% | 2117.3 ± 0.5% | 3450.5 ± 0.5% | 355.3 ± 0.8% | 1434.0 ± 0.6% | 1054.1 ± 0.4% | 1.991 | 1.222 | 11.862 | 2.939 | 3.999 |
| string: silesia/webster | 1098490 | 4072.1 ± 0.6% | 1882.0 ± 0.4% | 2058.6 ± 0.4% | 441.9 ± 0.6% | 1394.1 ± 0.3% | 646.9 ± 0.2% | 2.164 | 1.978 | 9.215 | 2.921 | 6.295 |
| string: silesia/xml | 1090118 | 6139.1 ± 0.4% | 2857.2 ± 0.5% | 2646.0 ± 0.7% | 612.1 ± 0.8% | 1756.9 ± 0.4% | 922.8 ± 0.3% | 2.149 | 2.320 | 10.030 | 3.494 | 6.653 |
| string: canterbury/alice29.txt | 159425 | 6463.7 ± 0.5% | 2194.2 ± 0.8% | 2763.0 ± 0.8% | 407.6 ± 0.9% | 1480.3 ± 0.3% | 955.8 ± 0.2% | 2.946 | 2.339 | 15.857 | 4.367 | 6.762 |
| string: canterbury/asyoulik.txt | 132198 | 5665.6 ± 1.3% | 1716.0 ± 0.5% | 2376.5 ± 1.0% | 402.2 ± 0.4% | 1347.3 ± 0.4% | 885.2 ± 0.2% | 3.302 | 2.384 | 14.087 | 4.205 | 6.400 |
| string: canterbury/lcet10.txt | 441884 | 6259.8 ± 0.3% | 2566.7 ± 0.1% | 2487.4 ± 1.2% | 467.3 ± 1.3% | 1539.3 ± 0.6% | 982.6 ± 0.7% | 2.439 | 2.517 | 13.394 | 4.067 | 6.370 |
| string: canterbury/plrabn12.txt | 503330 | 5728.9 ± 0.7% | 2057.0 ± 0.3% | 2074.3 ± 0.5% | 422.8 ± 0.9% | 1430.1 ± 0.2% | 930.8 ± 0.3% | 2.785 | 2.762 | 13.549 | 4.006 | 6.155 |
| string: canterbury-large/E.coli | 1048578 | 19217.4 ± 0.4% | 9709.1 ± 1.2% | 3782.0 ± 0.2% | 1475.1 ± 0.1% | 2352.6 ± 0.5% | 1194.1 ± 0.3% | 1.979 | 5.081 | 13.028 | 8.168 | 16.094 |
| string: canterbury-large/bible.txt | 1055886 | 6805.4 ± 0.2% | 4125.3 ± 0.9% | 3053.8 ± 0.8% | 504.5 ± 0.8% | 1968.0 ± 0.5% | 1119.3 ± 0.5% | 1.650 | 2.229 | 13.488 | 3.458 | 6.080 |
| string: canterbury-large/world192.txt | 1103121 | 4058.5 ± 0.4% | 1656.7 ± 0.6% | 2000.8 ± 0.4% | 448.7 ± 0.7% | 1360.2 ± 0.4% | 909.4 ± 0.3% | 2.450 | 2.028 | 9.046 | 2.984 | 4.463 |
| string: http/html-1m | 1058582 | 6796.3 ± 0.2% | 3968.1 ± 0.4% | 3035.8 ± 0.4% | 501.7 ± 1.1% | 1914.3 ± 0.4% | 804.8 ± 1.0% | 1.713 | 2.239 | 13.547 | 3.550 | 8.444 |
| string: http/json-1m | 1190272 | 3169.7 ± 0.3% | 1351.2 ± 0.4% | 1555.7 ± 0.4% | 443.3 ± 0.8% | 961.7 ± 0.1% | 765.8 ± 0.6% | 2.346 | 2.037 | 7.150 | 3.296 | 4.139 |
| string: http/js-1m | 1144362 | 2779.8 ± 0.6% | 1179.2 ± 0.2% | 1627.7 ± 0.3% | 368.5 ± 0.1% | 1094.0 ± 0.2% | 758.6 ± 0.2% | 2.357 | 1.708 | 7.544 | 2.541 | 3.664 |
| string: http/css-1m | 1097820 | 4005.6 ± 0.6% | 1485.1 ± 0.2% | 2146.9 ± 0.2% | 494.6 ± 0.6% | 1370.0 ± 0.4% | 896.5 ± 0.4% | 2.697 | 1.866 | 8.099 | 2.924 | 4.468 |
| string: dickens as Cyrillic and CJK | 1883069 | 3072.4 ± 0.2% | 2347.5 ± 0.6% | 522.4 ± 0.4% | 307.1 ± 1.2% | 563.2 ± 0.6% | 336.3 ± 0.2% | 1.309 | 5.881 | 10.005 | 5.455 | 9.136 |
| hex: silesia/dickens | 524290 | 15628.2 ± 0.7% | 1466.6 ± 0.2% | 1082.6 ± 0.3% | 501.7 ± 1.2% | 988.3 ± 1.0% | 732.0 ± 0.6% | 10.656 | 14.436 | 31.150 | 15.812 | 21.349 |
| hex: silesia/mozilla | 524290 | 15672.0 ± 0.4% | 1470.8 ± 0.4% | 1087.5 ± 0.4% | 442.4 ± 0.4% | 988.9 ± 0.3% | 735.3 ± 0.4% | 10.655 | 14.411 | 35.424 | 15.849 | 21.314 |
| hex: silesia/mr | 524290 | 15644.4 ± 0.4% | 1485.0 ± 0.2% | 1094.1 ± 0.4% | 556.4 ± 2.0% | 993.2 ± 0.4% | 734.7 ± 0.5% | 10.535 | 14.299 | 28.116 | 15.751 | 21.293 |
| hex: silesia/nci | 524290 | 15646.3 ± 0.7% | 1470.7 ± 0.5% | 1087.7 ± 0.4% | 631.6 ± 3.0% | 987.6 ± 0.2% | 734.4 ± 0.3% | 10.639 | 14.385 | 24.774 | 15.843 | 21.306 |
| hex: silesia/ooffice | 524290 | 15556.6 ± 0.3% | 1467.7 ± 0.3% | 1083.9 ± 0.2% | 389.9 ± 0.5% | 992.0 ± 0.7% | 735.6 ± 0.7% | 10.599 | 14.352 | 39.902 | 15.682 | 21.148 |
| hex: silesia/osdb | 524290 | 15627.8 ± 0.8% | 1468.3 ± 0.3% | 1085.8 ± 0.2% | 479.3 ± 3.0% | 989.5 ± 0.6% | 735.2 ± 0.6% | 10.644 | 14.393 | 32.609 | 15.794 | 21.257 |
| hex: silesia/reymont | 524290 | 15705.6 ± 0.1% | 1463.3 ± 0.6% | 1083.7 ± 0.4% | 513.4 ± 0.7% | 988.9 ± 0.2% | 735.4 ± 0.4% | 10.733 | 14.493 | 30.594 | 15.882 | 21.357 |
| hex: silesia/samba | 524290 | 15648.5 ± 0.3% | 1466.8 ± 0.3% | 1083.4 ± 0.3% | 402.2 ± 0.7% | 988.3 ± 0.4% | 734.5 ± 0.7% | 10.669 | 14.444 | 38.906 | 15.833 | 21.304 |
| hex: silesia/sao | 524290 | 15565.9 ± 0.9% | 1467.1 ± 0.2% | 1083.8 ± 0.2% | 333.1 ± 0.4% | 988.6 ± 0.4% | 735.5 ± 0.2% | 10.610 | 14.362 | 46.730 | 15.745 | 21.164 |
| hex: silesia/webster | 524290 | 15624.2 ± 0.5% | 1462.5 ± 0.6% | 1082.3 ± 0.3% | 476.7 ± 0.8% | 988.3 ± 0.2% | 733.7 ± 0.6% | 10.683 | 14.436 | 32.775 | 15.809 | 21.296 |
| hex: silesia/x-ray | 524290 | 15637.2 ± 0.5% | 1477.5 ± 0.4% | 1092.5 ± 0.3% | 447.6 ± 1.0% | 995.5 ± 0.3% | 734.0 ± 0.6% | 10.584 | 14.313 | 34.932 | 15.708 | 21.304 |
| hex: silesia/xml | 524290 | 15543.3 ± 0.3% | 1465.8 ± 0.2% | 1083.8 ± 0.3% | 617.4 ± 0.7% | 987.3 ± 0.3% | 735.3 ± 0.3% | 10.604 | 14.341 | 25.173 | 15.743 | 21.140 |
| hex: canterbury/alice29.txt | 304180 | 15706.0 ± 0.0% | 1476.6 ± 0.6% | 1087.2 ± 0.4% | 499.3 ± 2.0% | 990.2 ± 0.3% | 737.1 ± 0.3% | 10.637 | 14.446 | 31.458 | 15.862 | 21.309 |
| hex: canterbury/asyoulik.txt | 250360 | 15722.3 ± 0.0% | 1479.9 ± 0.5% | 1095.6 ± 0.2% | 499.5 ± 1.5% | 995.9 ± 0.5% | 740.1 ± 0.3% | 10.624 | 14.351 | 31.476 | 15.787 | 21.243 |
| hex: canterbury/cp.html | 49208 | 15670.0 ± 0.0% | 1471.7 ± 0.2% | 1096.6 ± 0.2% | 524.2 ± 1.3% | 1000.1 ± 0.3% | 743.4 ± 0.2% | 10.648 | 14.289 | 29.890 | 15.668 | 21.078 |
| hex: canterbury/fields.c | 22302 | 15521.6 ± 0.0% | 1399.8 ± 0.6% | 1066.0 ± 0.3% | 633.7 ± 1.5% | 990.8 ± 0.1% | 737.1 ± 0.1% | 11.088 | 14.560 | 24.493 | 15.666 | 21.058 |
| hex: canterbury/grammar.lsp | 7444 | 15155.0 ± 0.0% | 1487.7 ± 0.6% | 1092.1 ± 0.4% | 661.0 ± 2.1% | 998.0 ± 0.3% | 726.1 ± 0.1% | 10.187 | 13.878 | 22.928 | 15.186 | 20.871 |
| hex: canterbury/kennedy.xls | 524290 | 15662.1 ± 0.1% | 1475.3 ± 0.3% | 1089.9 ± 0.4% | 653.2 ± 4.1% | 989.1 ± 0.1% | 734.9 ± 0.5% | 10.616 | 14.371 | 23.977 | 15.835 | 21.311 |
| hex: canterbury/lcet10.txt | 524290 | 15633.2 ± 0.3% | 1462.4 ± 0.5% | 1085.1 ± 0.4% | 504.8 ± 1.4% | 989.6 ± 0.4% | 735.7 ± 0.3% | 10.690 | 14.407 | 30.970 | 15.798 | 21.250 |
| hex: canterbury/plrabn12.txt | 524290 | 15654.2 ± 0.4% | 1467.2 ± 0.4% | 1083.7 ± 0.3% | 495.1 ± 1.3% | 989.1 ± 0.4% | 734.9 ± 0.2% | 10.669 | 14.445 | 31.621 | 15.827 | 21.302 |
| hex: canterbury/ptt5 | 524290 | 15559.2 ± 0.4% | 1477.6 ± 0.2% | 1092.7 ± 0.4% | 555.1 ± 0.9% | 992.2 ± 0.3% | 734.7 ± 0.7% | 10.530 | 14.239 | 28.028 | 15.682 | 21.179 |
| hex: canterbury/sum | 76482 | 15678.2 ± 0.1% | 1495.0 ± 0.2% | 1103.7 ± 0.1% | 594.9 ± 2.3% | 998.2 ± 0.1% | 744.7 ± 0.1% | 10.487 | 14.205 | 26.355 | 15.706 | 21.053 |
| hex: canterbury/xargs.1 | 8456 | 15203.8 ± 0.1% | 1429.1 ± 0.4% | 1093.7 ± 0.0% | 649.0 ± 3.4% | 1003.1 ± 0.2% | 729.0 ± 0.1% | 10.639 | 13.901 | 23.426 | 15.157 | 20.857 |
| hex: canterbury-large/E.coli | 524290 | 15680.7 ± 0.2% | 1474.0 ± 0.3% | 1089.1 ± 0.4% | 672.9 ± 0.2% | 990.4 ± 0.6% | 734.4 ± 0.4% | 10.638 | 14.398 | 23.304 | 15.833 | 21.352 |
| hex: canterbury-large/bible.txt | 524290 | 15646.2 ± 0.2% | 1465.1 ± 0.5% | 1087.3 ± 0.5% | 512.6 ± 0.5% | 989.2 ± 0.8% | 733.9 ± 1.1% | 10.680 | 14.390 | 30.524 | 15.818 | 21.319 |
| hex: canterbury-large/world192.txt | 524290 | 15604.6 ± 0.4% | 1468.3 ± 0.7% | 1083.8 ± 0.8% | 504.6 ± 0.8% | 988.5 ± 0.4% | 734.9 ± 0.5% | 10.628 | 14.398 | 30.923 | 15.785 | 21.234 |
| hex: http/html-1kx1024 | 2099200 | 14176.0 ± 0.5% | 1454.0 ± 0.2% | 1061.2 ± 0.2% | 502.3 ± 0.1% | 983.2 ± 0.5% | 693.1 ± 0.1% | 9.749 | 13.359 | 28.221 | 14.418 | 20.453 |
| hex: http/html-16kx64 | 2097280 | 15387.5 ± 0.2% | 1443.9 ± 0.1% | 1073.0 ± 0.1% | 506.6 ± 0.2% | 994.2 ± 0.1% | 735.3 ± 0.2% | 10.657 | 14.341 | 30.375 | 15.478 | 20.926 |
| hex: http/html-1m | 524290 | 15682.0 ± 0.1% | 1467.9 ± 0.2% | 1086.4 ± 0.3% | 500.9 ± 0.3% | 992.2 ± 0.4% | 735.3 ± 0.6% | 10.683 | 14.434 | 31.306 | 15.805 | 21.326 |
| hex: http/json-1kx1024 | 2099200 | 14156.2 ± 1.6% | 1462.6 ± 0.1% | 1066.3 ± 0.2% | 609.2 ± 0.2% | 986.7 ± 0.2% | 693.1 ± 0.1% | 9.679 | 13.276 | 23.237 | 14.347 | 20.423 |
| hex: http/json-16kx64 | 2097280 | 15409.6 ± 0.3% | 1445.1 ± 0.2% | 1074.0 ± 0.2% | 616.0 ± 0.8% | 994.2 ± 0.6% | 734.6 ± 0.1% | 10.663 | 14.347 | 25.016 | 15.499 | 20.977 |
| hex: http/json-1m | 524290 | 15593.1 ± 0.4% | 1470.5 ± 0.3% | 1088.8 ± 0.3% | 635.2 ± 2.2% | 989.7 ± 0.6% | 735.6 ± 0.4% | 10.604 | 14.321 | 24.548 | 15.756 | 21.196 |
| hex: http/js-1kx1024 | 2099200 | 14176.2 ± 0.4% | 1455.2 ± 0.1% | 1062.3 ± 0.4% | 497.9 ± 0.2% | 981.7 ± 0.4% | 692.6 ± 0.1% | 9.742 | 13.345 | 28.470 | 14.440 | 20.469 |
| hex: http/js-16kx64 | 2097280 | 15434.8 ± 0.5% | 1444.3 ± 0.2% | 1074.6 ± 0.1% | 504.5 ± 0.3% | 997.5 ± 0.3% | 734.9 ± 0.3% | 10.687 | 14.363 | 30.594 | 15.474 | 21.003 |
| hex: http/js-1m | 524290 | 15678.7 ± 0.3% | 1466.5 ± 0.3% | 1087.6 ± 0.1% | 511.6 ± 0.3% | 984.9 ± 0.3% | 733.0 ± 0.7% | 10.692 | 14.416 | 30.645 | 15.919 | 21.390 |
| hex: http/css-1kx1024 | 2099200 | 14133.7 ± 0.5% | 1455.1 ± 0.1% | 1061.8 ± 0.1% | 532.2 ± 0.3% | 984.0 ± 0.1% | 692.8 ± 0.1% | 9.713 | 13.311 | 26.558 | 14.364 | 20.401 |
| hex: http/css-16kx64 | 2097280 | 15398.2 ± 0.7% | 1445.0 ± 0.2% | 1073.9 ± 0.2% | 540.7 ± 0.4% | 998.9 ± 0.4% | 735.8 ± 0.2% | 10.656 | 14.338 | 28.477 | 15.415 | 20.926 |
| hex: http/css-1m | 524290 | 15649.9 ± 0.7% | 1460.8 ± 0.6% | 1086.0 ± 0.3% | 526.1 ± 0.2% | 990.1 ± 0.2% | 735.1 ± 0.5% | 10.713 | 14.410 | 29.748 | 15.807 | 21.289 |
| hex: shuffled/dickens-1m | 524290 | 15695.8 ± 0.1% | 1464.1 ± 0.2% | 1085.9 ± 0.3% | 501.9 ± 0.6% | 989.9 ± 0.5% | 734.9 ± 0.5% | 10.720 | 14.454 | 31.272 | 15.856 | 21.356 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.916 of yyjson.
