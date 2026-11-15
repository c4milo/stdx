# bench-json

| Field | Value |
|---|---|
| Commit | 6e0508c |
| Runner label | ubuntu-24.04 |
| Image version | 20261111.127.1 |
| CPU model | Intel(R) Xeon(R) 6975P-C |
| Virtual CPUs | 4 |
| Kernel | 7.0.0-1014-aws |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/43674612420 |
| Date | 2026-11-15 |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1. The `TextReader.next_items` column is that helper's queued tokens a slice a call (decision 79), over many tokens a call.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | TextReader.next_items | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1385.8 ± 0.5% | 0.489 | 1.025 | 1.066 | 1.067 | 0.408 | 1.073 | 1.068 | 0.369 | 0.832 | 0.929 | 0.105 |
| qlog records, JSON text sequence | 1467503 | 1092.9 ± 2.2% | 0.806 | 1.066 | 1.067 | 1.077 | 0.394 | 1.074 | 1.081 | 0.368 | 0.920 | 1.053 | 0.127 |
| messages: 11 string members | 1025025 | 1078.6 ± 0.5% | 0.582 | 1.003 | 1.023 | 1.037 | 0.550 | 1.025 | 1.043 | 0.537 | 0.890 | 0.966 | 0.136 |
| messages: 50 nested objects | 1121600 | 1313.2 ± 0.2% | 0.807 | 1.097 | 1.098 | 1.098 | 0.399 | 1.104 | 1.098 | 0.359 | 0.946 | 0.991 | 0.117 |
| messages: a tree of 341 objects | 612600 | 664.5 ± 0.8% | 0.829 | 1.051 | 1.037 | 1.037 | 0.267 | 1.032 | 1.039 | 0.221 | 0.830 | 0.983 | 0.118 |
| string: silesia/dickens | 172528 | 6725.5 ± 0.6% | 0.029 | 0.696 | 1.087 | 1.093 | 0.207 | 1.033 | 1.109 | 0.207 | 1.000 | 1.003 | 0.029 |
| string: silesia/nci | 1075110 | 5453.6 ± 0.7% | 0.035 | 0.727 | 1.033 | 1.035 | 0.309 | 1.038 | 1.034 | 0.308 | 1.007 | 1.009 | 0.035 |
| string: silesia/reymont | 1075159 | 3556.0 ± 1.3% | 0.054 | 0.624 | 0.865 | 0.867 | 0.352 | 0.815 | 0.874 | 0.353 | 0.985 | 0.997 | 0.054 |
| string: silesia/samba | 97582 | 4007.5 ± 0.4% | 0.041 | 0.909 | 1.060 | 1.061 | 0.074 | 0.856 | 1.061 | 0.075 | 1.000 | 1.000 | 0.041 |
| string: silesia/webster | 1098490 | 4447.6 ± 1.2% | 0.042 | 0.644 | 0.976 | 0.983 | 0.219 | 0.923 | 0.990 | 0.220 | 1.007 | 1.012 | 0.042 |
| string: silesia/xml | 1090118 | 6130.1 ± 0.4% | 0.032 | 0.776 | 0.956 | 0.965 | 0.249 | 0.950 | 0.970 | 0.248 | 1.003 | 1.009 | 0.032 |
| string: canterbury/alice29.txt | 159425 | 5743.3 ± 0.4% | 0.033 | 0.761 | 1.076 | 1.127 | 0.186 | 1.021 | 1.167 | 0.185 | 1.001 | 1.005 | 0.033 |
| string: canterbury/asyoulik.txt | 132198 | 4290.1 ± 0.6% | 0.043 | 0.813 | 1.138 | 1.136 | 0.203 | 1.062 | 1.144 | 0.204 | 0.999 | 1.000 | 0.042 |
| string: canterbury/lcet10.txt | 441884 | 6648.5 ± 0.6% | 0.029 | 0.613 | 1.106 | 1.109 | 0.197 | 1.037 | 1.122 | 0.197 | 1.001 | 1.004 | 0.029 |
| string: canterbury/plrabn12.txt | 503330 | 5082.5 ± 0.2% | 0.038 | 0.804 | 0.971 | 0.983 | 0.247 | 0.804 | 0.979 | 0.247 | 1.001 | 1.002 | 0.038 |
| string: canterbury-large/E.coli | 1048578 | 32324.3 ± 0.6% | 0.056 | 1.005 | 0.744 | 1.006 | 0.508 | 1.007 | 1.005 | 0.509 | 1.054 | 1.056 | 0.007 |
| string: canterbury-large/bible.txt | 1055886 | 8556.7 ± 1.7% | 0.024 | 0.622 | 0.873 | 0.882 | 0.400 | 0.883 | 0.896 | 0.400 | 1.005 | 1.011 | 0.024 |
| string: canterbury-large/world192.txt | 1103121 | 4160.0 ± 0.4% | 0.045 | 0.695 | 0.976 | 0.982 | 0.216 | 0.926 | 0.991 | 0.216 | 0.998 | 1.000 | 0.045 |
| string: http/html-1m | 1058582 | 9150.7 ± 3.1% | 0.022 | 0.562 | 0.785 | 0.789 | 0.319 | 0.755 | 0.797 | 0.319 | 0.965 | 1.055 | 0.022 |
| string: http/json-1m | 1190272 | 3342.7 ± 0.8% | 0.052 | 0.395 | 0.441 | 0.444 | 0.147 | 0.457 | 0.445 | 0.147 | 1.005 | 1.005 | 0.052 |
| string: http/js-1m | 1144362 | 2861.7 ± 0.3% | 0.062 | 0.703 | 0.903 | 0.926 | 0.191 | 0.852 | 0.926 | 0.191 | 1.005 | 1.007 | 0.062 |
| string: http/css-1m | 1097820 | 3297.3 ± 0.5% | 0.055 | 0.780 | 0.989 | 1.029 | 0.288 | 0.959 | 1.032 | 0.288 | 1.004 | 1.010 | 0.055 |
| string: dickens as Cyrillic and CJK | 1883069 | 5850.5 ± 0.5% | 0.025 | 0.062 | 0.444 | 0.445 | 0.198 | 0.444 | 0.445 | 0.198 | 1.004 | 1.005 | 0.025 |
| string: dickens as Cyrillic and CJK, as \u escapes | 5075485 | 1199.8 ± 1.2% | 0.113 | 0.997 | 1.008 | 1.007 | 0.107 | 0.716 | 1.007 | 0.107 | 1.004 | 1.017 | 0.113 |
| hex: silesia/dickens | 524290 | 45655.4 ± 0.2% | 0.040 | 1.001 | 0.626 | 1.000 | 0.394 | 1.004 | 1.000 | 0.395 | 0.745 | 0.745 | 0.005 |
| hex: silesia/mozilla | 524290 | 46333.4 ± 0.5% | 0.040 | 1.000 | 0.621 | 0.996 | 0.390 | 1.000 | 0.997 | 0.391 | 0.735 | 0.734 | 0.005 |
| hex: silesia/mr | 524290 | 44680.5 ± 0.2% | 0.041 | 1.000 | 0.644 | 0.999 | 0.407 | 1.001 | 0.999 | 0.407 | 0.762 | 0.761 | 0.005 |
| hex: silesia/nci | 524290 | 45195.5 ± 0.3% | 0.041 | 1.003 | 0.626 | 1.002 | 0.400 | 1.004 | 1.002 | 0.401 | 0.753 | 0.753 | 0.005 |
| hex: silesia/ooffice | 524290 | 47888.7 ± 0.5% | 0.038 | 0.999 | 0.585 | 0.996 | 0.377 | 0.997 | 0.997 | 0.378 | 0.706 | 0.707 | 0.004 |
| hex: silesia/osdb | 524290 | 45425.9 ± 2.9% | 0.040 | 1.000 | 0.615 | 1.002 | 0.395 | 1.007 | 1.000 | 0.396 | 0.743 | 0.749 | 0.005 |
| hex: silesia/reymont | 524290 | 44569.9 ± 0.6% | 0.041 | 1.004 | 0.641 | 1.002 | 0.403 | 1.006 | 1.003 | 0.404 | 0.762 | 0.763 | 0.005 |
| hex: silesia/samba | 524290 | 33999.9 ± 0.1% | 0.054 | 1.001 | 0.716 | 1.002 | 0.487 | 1.003 | 1.001 | 0.488 | 1.001 | 1.000 | 0.006 |
| hex: silesia/sao | 524290 | 44615.8 ± 0.5% | 0.041 | 1.001 | 0.641 | 1.000 | 0.406 | 1.001 | 1.001 | 0.407 | 0.762 | 0.759 | 0.005 |
| hex: silesia/webster | 524290 | 45647.1 ± 2.8% | 0.040 | 0.999 | 0.627 | 0.998 | 0.392 | 1.005 | 0.998 | 0.394 | 0.745 | 0.742 | 0.005 |
| hex: silesia/x-ray | 524290 | 47893.2 ± 0.7% | 0.038 | 1.000 | 0.592 | 1.002 | 0.375 | 0.998 | 1.001 | 0.376 | 0.704 | 0.704 | 0.004 |
| hex: silesia/xml | 524290 | 44802.1 ± 1.0% | 0.041 | 0.999 | 0.627 | 0.998 | 0.403 | 1.005 | 1.001 | 0.401 | 0.753 | 0.754 | 0.005 |
| hex: canterbury/alice29.txt | 304180 | 48244.9 ± 2.2% | 0.038 | 1.000 | 0.580 | 0.996 | 0.371 | 0.998 | 0.998 | 0.372 | 0.696 | 0.697 | 0.004 |
| hex: canterbury/asyoulik.txt | 250360 | 46260.6 ± 1.2% | 0.039 | 0.999 | 0.611 | 0.995 | 0.385 | 0.997 | 0.995 | 0.386 | 0.727 | 0.727 | 0.005 |
| hex: canterbury/cp.html | 49208 | 43367.7 ± 1.1% | 0.042 | 1.000 | 0.645 | 1.001 | 0.406 | 0.999 | 1.000 | 0.410 | 0.771 | 0.770 | 0.005 |
| hex: canterbury/fields.c | 22302 | 50735.9 ± 1.7% | 0.036 | 0.998 | 0.540 | 0.998 | 0.389 | 0.999 | 0.995 | 0.395 | 0.648 | 0.646 | 0.004 |
| hex: canterbury/grammar.lsp | 7444 | 43191.5 ± 2.4% | 0.043 | 1.019 | 0.585 | 1.009 | 0.416 | 1.012 | 1.006 | 0.439 | 0.690 | 0.686 | 0.005 |
| hex: canterbury/kennedy.xls | 524290 | 46233.5 ± 1.4% | 0.039 | 1.002 | 0.612 | 0.998 | 0.386 | 0.999 | 0.997 | 0.386 | 0.729 | 0.728 | 0.005 |
| hex: canterbury/lcet10.txt | 524290 | 45709.2 ± 2.3% | 0.040 | 1.002 | 0.620 | 1.000 | 0.389 | 1.007 | 1.001 | 0.389 | 0.740 | 0.738 | 0.005 |
| hex: canterbury/plrabn12.txt | 524290 | 43579.9 ± 5.2% | 0.042 | 1.010 | 0.646 | 1.007 | 0.403 | 1.007 | 1.003 | 0.403 | 0.772 | 0.773 | 0.005 |
| hex: canterbury/ptt5 | 524290 | 44910.5 ± 1.5% | 0.041 | 0.997 | 0.632 | 1.001 | 0.401 | 1.006 | 0.997 | 0.403 | 0.751 | 0.750 | 0.005 |
| hex: canterbury/sum | 76482 | 44325.9 ± 0.6% | 0.041 | 1.003 | 0.635 | 1.004 | 0.402 | 1.003 | 1.004 | 0.403 | 0.753 | 0.753 | 0.005 |
| hex: canterbury/xargs.1 | 8456 | 44855.9 ± 1.6% | 0.041 | 1.008 | 0.573 | 0.998 | 0.410 | 0.995 | 0.994 | 0.429 | 0.676 | 0.671 | 0.005 |
| hex: canterbury-large/E.coli | 524290 | 44795.5 ± 1.5% | 0.040 | 1.006 | 0.632 | 1.001 | 0.384 | 1.007 | 1.006 | 0.384 | 0.752 | 0.752 | 0.005 |
| hex: canterbury-large/bible.txt | 524290 | 44082.4 ± 1.5% | 0.041 | 1.007 | 0.639 | 1.002 | 0.402 | 1.002 | 1.001 | 0.402 | 0.766 | 0.766 | 0.005 |
| hex: canterbury-large/world192.txt | 524290 | 45272.6 ± 4.2% | 0.040 | 1.007 | 0.617 | 1.007 | 0.396 | 1.003 | 0.999 | 0.396 | 0.746 | 0.744 | 0.005 |
| hex: http/html-1kx1024 | 2099200 | 18251.2 ± 1.3% | 0.099 | 1.001 | 0.811 | 0.995 | 0.568 | 1.001 | 0.992 | 0.626 | 0.848 | 0.824 | 0.011 |
| hex: http/html-16kx64 | 2097280 | 36089.5 ± 1.8% | 0.050 | 1.002 | 0.668 | 1.002 | 0.453 | 1.000 | 1.005 | 0.458 | 0.787 | 0.784 | 0.006 |
| hex: http/html-1m | 524290 | 47947.1 ± 1.9% | 0.038 | 0.995 | 0.587 | 0.994 | 0.375 | 0.995 | 0.994 | 0.375 | 0.704 | 0.703 | 0.004 |
| hex: http/json-1kx1024 | 2099200 | 17642.9 ± 1.2% | 0.102 | 1.004 | 0.828 | 0.999 | 0.567 | 1.004 | 0.997 | 0.624 | 0.857 | 0.837 | 0.012 |
| hex: http/json-16kx64 | 2097280 | 33619.4 ± 3.0% | 0.054 | 1.013 | 0.708 | 1.011 | 0.484 | 1.012 | 1.014 | 0.488 | 0.818 | 0.817 | 0.006 |
| hex: http/json-1m | 524290 | 44989.8 ± 1.4% | 0.040 | 0.998 | 0.633 | 0.997 | 0.377 | 1.001 | 1.003 | 0.378 | 0.748 | 0.748 | 0.005 |
| hex: http/js-1kx1024 | 2099200 | 18024.8 ± 0.9% | 0.100 | 1.009 | 0.821 | 1.002 | 0.591 | 1.008 | 0.999 | 0.650 | 0.860 | 0.840 | 0.012 |
| hex: http/js-16kx64 | 2097280 | 34561.6 ± 4.8% | 0.053 | 1.006 | 0.686 | 1.008 | 0.469 | 1.006 | 1.007 | 0.472 | 0.794 | 0.795 | 0.006 |
| hex: http/js-1m | 524290 | 45024.2 ± 1.9% | 0.040 | 1.005 | 0.631 | 1.003 | 0.397 | 1.006 | 1.004 | 0.398 | 0.749 | 0.749 | 0.005 |
| hex: http/css-1kx1024 | 2099200 | 17659.7 ± 1.6% | 0.102 | 1.010 | 0.833 | 1.002 | 0.598 | 1.009 | 1.002 | 0.658 | 0.868 | 0.844 | 0.012 |
| hex: http/css-16kx64 | 2097280 | 34812.9 ± 1.4% | 0.052 | 1.004 | 0.692 | 1.006 | 0.469 | 1.006 | 1.004 | 0.472 | 0.803 | 0.800 | 0.006 |
| hex: http/css-1m | 524290 | 46064.3 ± 0.5% | 0.040 | 1.000 | 0.619 | 1.000 | 0.390 | 1.002 | 1.001 | 0.390 | 0.732 | 0.733 | 0.005 |
| hex: shuffled/dickens-1m | 524290 | 45179.1 ± 2.3% | 0.040 | 1.004 | 0.619 | 1.001 | 0.397 | 0.994 | 0.995 | 0.397 | 0.747 | 0.747 | 0.005 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1739.3 ± 3.9% | 0.429 | 1.007 | 0.983 | 1.026 | 1.019 | 0.267 | 1.014 | 0.513 | 0.863 | 0.095 | 1.035 |
| qlog records, JSON text sequence | 1467503 | 1653.2 ± 2.3% | 0.634 | 0.970 | 0.979 | 1.011 | 0.989 | 0.235 | 0.991 | 0.439 | 0.829 | 0.107 | 1.036 |
| messages: 11 string members | 1025025 | 1326.7 ± 1.2% | 0.501 | 0.966 | 0.987 | 0.993 | 0.982 | 0.375 | 0.980 | 0.668 | 0.944 | 0.122 | 0.996 |
| messages: 50 nested objects | 1121600 | 1992.4 ± 1.1% | 0.581 | 0.978 | 0.963 | 0.990 | 0.975 | 0.242 | 0.977 | 0.436 | 0.827 | 0.092 | 1.005 |
| messages: a tree of 341 objects | 612600 | 597.8 ± 3.0% | 0.973 | 1.059 | 1.071 | 1.080 | 1.078 | 0.259 | 1.079 | 0.439 | 0.899 | 0.194 | 1.089 |
| string: silesia/dickens | 172528 | 12802.0 ± 1.0% | 0.018 | 0.543 | 0.365 | 0.541 | 0.567 | 0.121 | 0.572 | 1.007 | 1.008 | 0.018 | 1.040 |
| string: silesia/nci | 1075110 | 11264.8 ± 10.4% | 0.020 | 0.527 | 0.373 | 0.537 | 0.526 | 0.170 | 0.526 | 0.999 | 1.000 | 0.020 | 1.029 |
| string: silesia/reymont | 1075159 | 5320.0 ± 5.6% | 0.043 | 0.580 | 0.437 | 0.573 | 0.581 | 0.269 | 0.575 | 1.008 | 1.016 | 0.042 | 1.025 |
| string: silesia/samba | 97582 | 6250.3 ± 0.4% | 0.045 | 0.890 | 0.745 | 0.899 | 0.889 | 0.121 | 0.892 | 1.004 | 1.003 | 0.045 | 1.163 |
| string: silesia/webster | 1098490 | 7066.5 ± 1.6% | 0.031 | 0.569 | 0.396 | 0.545 | 0.575 | 0.155 | 0.573 | 0.989 | 1.007 | 0.031 | 0.986 |
| string: silesia/xml | 1090118 | 10716.6 ± 0.6% | 0.021 | 0.558 | 0.464 | 0.558 | 0.563 | 0.190 | 0.562 | 0.999 | 1.020 | 0.021 | 1.032 |
| string: canterbury/alice29.txt | 159425 | 12704.9 ± 1.0% | 0.017 | 0.432 | 0.355 | 0.419 | 0.450 | 0.091 | 0.474 | 0.997 | 0.999 | 0.018 | 1.044 |
| string: canterbury/asyoulik.txt | 132198 | 10558.8 ± 1.1% | 0.020 | 0.411 | 0.342 | 0.400 | 0.423 | 0.093 | 0.435 | 0.995 | 1.012 | 0.020 | 1.038 |
| string: canterbury/lcet10.txt | 441884 | 12593.1 ± 1.2% | 0.018 | 0.543 | 0.325 | 0.533 | 0.550 | 0.118 | 0.548 | 1.001 | 1.023 | 0.018 | 0.998 |
| string: canterbury/plrabn12.txt | 503330 | 8756.4 ± 1.2% | 0.025 | 0.622 | 0.497 | 0.619 | 0.620 | 0.159 | 0.621 | 1.008 | 1.028 | 0.025 | 1.010 |
| string: canterbury-large/E.coli | 1048578 | 34601.6 ± 0.9% | 0.052 | 1.005 | 1.005 | 0.743 | 1.006 | 0.474 | 1.006 | 1.010 | 1.000 | 0.007 | 1.006 |
| string: canterbury-large/bible.txt | 1055886 | 9610.2 ± 1.6% | 0.024 | 0.741 | 0.569 | 0.743 | 0.756 | 0.388 | 0.758 | 0.996 | 1.015 | 0.024 | 1.022 |
| string: canterbury-large/world192.txt | 1103121 | 6689.2 ± 0.6% | 0.033 | 0.587 | 0.424 | 0.554 | 0.590 | 0.152 | 0.592 | 0.990 | 1.006 | 0.033 | 0.974 |
| string: http/html-1m | 1058582 | 10108.9 ± 1.5% | 0.023 | 0.643 | 0.539 | 0.635 | 0.644 | 0.320 | 0.645 | 0.991 | 1.006 | 0.023 | 1.011 |
| string: http/json-1m | 1190272 | 8358.9 ± 0.6% | 0.024 | 0.185 | 0.161 | 0.185 | 0.185 | 0.073 | 0.185 | 1.000 | 1.006 | 0.024 | 1.021 |
| string: http/js-1m | 1144362 | 6574.4 ± 1.9% | 0.032 | 0.369 | 0.310 | 0.358 | 0.367 | 0.093 | 0.367 | 0.988 | 0.999 | 0.032 | 1.010 |
| string: http/css-1m | 1097820 | 9156.0 ± 0.7% | 0.023 | 0.358 | 0.289 | 0.348 | 0.359 | 0.124 | 0.359 | 0.994 | 1.006 | 0.023 | 1.006 |
| string: dickens as Cyrillic and CJK | 1883069 | 5470.4 ± 0.8% | 0.031 | 0.466 | 0.066 | 0.466 | 0.467 | 0.208 | 0.467 | 0.998 | 1.006 | 0.030 | 1.041 |
| hex: silesia/dickens | 524290 | 42334.4 ± 1.3% | 1.001 | 0.090 | 0.999 | 0.602 | 1.000 | 0.998 | 1.001 | 0.997 | 0.990 | 0.094 | 1.002 |
| hex: silesia/mozilla | 524290 | 42968.2 ± 8.1% | 1.005 | 0.089 | 1.006 | 0.595 | 1.004 | 1.005 | 0.996 | 1.006 | 1.007 | 0.092 | 0.997 |
| hex: silesia/mr | 524290 | 42745.5 ± 4.3% | 1.007 | 0.089 | 1.004 | 0.597 | 1.008 | 0.999 | 1.006 | 1.002 | 1.002 | 0.094 | 1.003 |
| hex: silesia/nci | 524290 | 43262.5 ± 1.1% | 1.007 | 0.089 | 1.002 | 0.593 | 1.005 | 1.002 | 1.006 | 1.003 | 1.003 | 0.089 | 1.005 |
| hex: silesia/ooffice | 524290 | 43227.1 ± 0.8% | 0.998 | 0.088 | 0.998 | 0.591 | 0.999 | 0.989 | 0.998 | 0.992 | 0.990 | 0.091 | 0.990 |
| hex: silesia/osdb | 524290 | 41689.6 ± 1.0% | 1.003 | 0.092 | 1.006 | 0.611 | 1.002 | 1.001 | 1.007 | 1.005 | 1.007 | 0.097 | 0.996 |
| hex: silesia/reymont | 524290 | 43604.4 ± 0.7% | 1.001 | 0.088 | 1.000 | 0.590 | 1.001 | 1.000 | 1.002 | 0.996 | 0.998 | 0.093 | 0.996 |
| hex: silesia/samba | 524290 | 43194.3 ± 1.6% | 1.006 | 0.089 | 0.999 | 0.594 | 1.005 | 0.991 | 1.004 | 0.994 | 0.987 | 0.093 | 0.991 |
| hex: silesia/sao | 524290 | 42916.9 ± 2.2% | 1.003 | 0.089 | 1.003 | 0.595 | 1.000 | 1.005 | 1.002 | 1.000 | 0.999 | 0.095 | 1.001 |
| hex: silesia/webster | 524290 | 43199.2 ± 1.3% | 1.009 | 0.089 | 1.000 | 0.593 | 1.007 | 0.998 | 1.008 | 1.004 | 0.997 | 0.092 | 1.005 |
| hex: silesia/x-ray | 524290 | 42631.5 ± 7.9% | 1.008 | 0.090 | 1.001 | 0.604 | 1.007 | 1.003 | 1.008 | 1.007 | 1.003 | 0.094 | 1.006 |
| hex: silesia/xml | 524290 | 43090.8 ± 3.9% | 1.004 | 0.088 | 0.991 | 0.593 | 1.004 | 0.996 | 1.003 | 1.000 | 0.996 | 0.092 | 0.990 |
| hex: canterbury/alice29.txt | 304180 | 41171.4 ± 1.9% | 1.003 | 0.093 | 1.008 | 0.599 | 1.004 | 1.004 | 1.008 | 1.005 | 1.002 | 0.100 | 1.004 |
| hex: canterbury/asyoulik.txt | 250360 | 42914.1 ± 1.8% | 1.006 | 0.089 | 1.001 | 0.595 | 1.010 | 1.002 | 1.005 | 1.004 | 1.003 | 0.093 | 1.001 |
| hex: canterbury/cp.html | 49208 | 41957.1 ± 2.1% | 1.005 | 0.091 | 1.007 | 0.600 | 1.006 | 1.002 | 1.007 | 1.009 | 1.003 | 0.099 | 1.007 |
| hex: canterbury/fields.c | 22302 | 42003.0 ± 0.9% | 1.000 | 0.091 | 0.999 | 0.598 | 0.998 | 0.986 | 0.999 | 1.002 | 1.007 | 0.099 | 1.005 |
| hex: canterbury/grammar.lsp | 7444 | 38989.1 ± 1.7% | 0.997 | 0.097 | 0.999 | 0.610 | 0.995 | 0.962 | 0.995 | 0.997 | 1.026 | 0.103 | 1.001 |
| hex: canterbury/kennedy.xls | 524290 | 43254.3 ± 1.0% | 1.003 | 0.088 | 0.999 | 0.591 | 0.999 | 1.000 | 1.001 | 0.997 | 0.997 | 0.091 | 1.001 |
| hex: canterbury/lcet10.txt | 524290 | 43543.3 ± 0.4% | 1.001 | 0.088 | 0.996 | 0.585 | 0.999 | 0.993 | 1.003 | 0.998 | 0.996 | 0.092 | 0.998 |
| hex: canterbury/plrabn12.txt | 524290 | 43562.2 ± 0.4% | 1.002 | 0.088 | 1.002 | 0.589 | 1.002 | 1.001 | 1.002 | 1.000 | 1.001 | 0.090 | 1.001 |
| hex: canterbury/ptt5 | 524290 | 43505.7 ± 1.5% | 1.000 | 0.088 | 0.999 | 0.588 | 1.000 | 0.997 | 0.998 | 0.997 | 1.000 | 0.091 | 0.996 |
| hex: canterbury/sum | 76482 | 42733.2 ± 1.1% | 1.002 | 0.090 | 1.003 | 0.594 | 1.005 | 0.998 | 1.002 | 1.002 | 1.003 | 0.096 | 1.002 |
| hex: canterbury/xargs.1 | 8456 | 40093.3 ± 1.0% | 0.999 | 0.095 | 0.997 | 0.599 | 0.994 | 0.948 | 0.992 | 0.991 | 1.008 | 0.101 | 0.995 |
| hex: canterbury-large/E.coli | 524290 | 41618.9 ± 0.6% | 1.002 | 0.092 | 0.997 | 0.609 | 1.001 | 0.992 | 1.004 | 1.002 | 1.002 | 0.095 | 1.004 |
| hex: canterbury-large/bible.txt | 524290 | 43564.5 ± 0.4% | 1.001 | 0.088 | 1.000 | 0.589 | 1.001 | 0.997 | 1.000 | 1.002 | 1.001 | 0.092 | 0.998 |
| hex: canterbury-large/world192.txt | 524290 | 43111.3 ± 1.5% | 1.000 | 0.089 | 1.001 | 0.595 | 0.992 | 0.986 | 0.998 | 0.995 | 0.990 | 0.093 | 0.992 |
| hex: http/html-1kx1024 | 2099200 | 20991.1 ± 0.2% | 1.002 | 0.174 | 1.004 | 0.971 | 1.003 | 1.002 | 1.004 | 1.004 | 1.006 | 0.182 | 1.005 |
| hex: http/html-16kx64 | 2097280 | 21532.6 ± 0.2% | 1.003 | 0.175 | 1.002 | 0.983 | 1.002 | 1.002 | 1.002 | 1.002 | 1.003 | 0.190 | 1.002 |
| hex: http/html-1m | 524290 | 42771.5 ± 1.4% | 1.003 | 0.089 | 1.002 | 0.596 | 1.006 | 0.998 | 1.001 | 1.006 | 1.003 | 0.096 | 1.005 |
| hex: http/json-1kx1024 | 2099200 | 20353.7 ± 0.3% | 1.003 | 0.180 | 1.004 | 0.992 | 1.004 | 1.005 | 1.004 | 1.003 | 1.006 | 0.187 | 1.004 |
| hex: http/json-16kx64 | 2097280 | 22741.6 ± 0.4% | 0.994 | 0.165 | 1.003 | 0.950 | 1.002 | 1.002 | 0.999 | 1.003 | 1.005 | 0.180 | 1.000 |
| hex: http/json-1m | 524290 | 42771.3 ± 1.3% | 1.005 | 0.090 | 0.999 | 0.600 | 1.003 | 0.997 | 1.001 | 0.998 | 0.999 | 0.094 | 1.000 |
| hex: http/js-1kx1024 | 2099200 | 20274.0 ± 0.3% | 1.003 | 0.180 | 1.004 | 0.985 | 1.004 | 1.000 | 1.004 | 1.003 | 1.006 | 0.188 | 1.005 |
| hex: http/js-16kx64 | 2097280 | 21428.2 ± 0.4% | 1.002 | 0.177 | 1.004 | 0.989 | 1.005 | 1.005 | 1.004 | 1.004 | 1.005 | 0.192 | 1.004 |
| hex: http/js-1m | 524290 | 42747.4 ± 0.3% | 1.003 | 0.090 | 0.999 | 0.602 | 1.002 | 0.998 | 1.002 | 1.000 | 0.999 | 0.094 | 0.999 |
| hex: http/css-1kx1024 | 2099200 | 21736.2 ± 0.5% | 0.998 | 0.168 | 1.002 | 0.952 | 1.002 | 0.992 | 1.002 | 1.002 | 1.005 | 0.176 | 1.004 |
| hex: http/css-16kx64 | 2097280 | 21321.3 ± 0.5% | 1.004 | 0.179 | 1.003 | 0.984 | 1.004 | 1.005 | 1.004 | 1.003 | 1.005 | 0.194 | 1.005 |
| hex: http/css-1m | 524290 | 42710.6 ± 0.3% | 1.005 | 0.090 | 1.000 | 0.605 | 1.003 | 0.999 | 1.002 | 1.000 | 0.999 | 0.094 | 1.000 |
| hex: shuffled/dickens-1m | 524290 | 41899.2 ± 0.7% | 1.007 | 0.092 | 0.988 | 0.616 | 1.006 | 0.991 | 1.005 | 0.990 | 0.985 | 0.098 | 0.987 |

## Losses

Each workload where a claim's path ran slower than the path it replaces by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding: J7 wide vectors off runs at 1.066 of all on.
- CLDR supplemental, 34 texts, decoding: J8 decoder fast path off runs at 1.067 of all on.
- CLDR supplemental, 34 texts, decoding: J12 decoder escape words off runs at 1.073 of all on.
- CLDR supplemental, 34 texts, decoding: J13 decoder escape blocks off runs at 1.068 of all on.
- qlog records, JSON text sequence, decoding: J5 UTF-8 vectors off runs at 1.066 of all on.
- qlog records, JSON text sequence, decoding: J7 wide vectors off runs at 1.067 of all on.
- qlog records, JSON text sequence, decoding: J8 decoder fast path off runs at 1.077 of all on.
- qlog records, JSON text sequence, decoding: J12 decoder escape words off runs at 1.074 of all on.
- qlog records, JSON text sequence, decoding: J13 decoder escape blocks off runs at 1.081 of all on.
- messages: 50 nested objects, decoding: J5 UTF-8 vectors off runs at 1.097 of all on.
- messages: 50 nested objects, decoding: J7 wide vectors off runs at 1.098 of all on.
- messages: 50 nested objects, decoding: J8 decoder fast path off runs at 1.098 of all on.
- messages: 50 nested objects, decoding: J12 decoder escape words off runs at 1.104 of all on.
- messages: 50 nested objects, decoding: J13 decoder escape blocks off runs at 1.098 of all on.
- messages: a tree of 341 objects, decoding: J5 UTF-8 vectors off runs at 1.051 of all on.
- string: silesia/dickens, decoding: J7 wide vectors off runs at 1.087 of all on.
- string: silesia/dickens, decoding: J8 decoder fast path off runs at 1.093 of all on.
- string: silesia/dickens, decoding: J13 decoder escape blocks off runs at 1.109 of all on.
- string: silesia/samba, decoding: J7 wide vectors off runs at 1.060 of all on.
- string: silesia/samba, decoding: J8 decoder fast path off runs at 1.061 of all on.
- string: silesia/samba, decoding: J13 decoder escape blocks off runs at 1.061 of all on.
- string: canterbury/alice29.txt, decoding: J7 wide vectors off runs at 1.076 of all on.
- string: canterbury/alice29.txt, decoding: J8 decoder fast path off runs at 1.127 of all on.
- string: canterbury/alice29.txt, decoding: J13 decoder escape blocks off runs at 1.167 of all on.
- string: canterbury/asyoulik.txt, decoding: J7 wide vectors off runs at 1.138 of all on.
- string: canterbury/asyoulik.txt, decoding: J8 decoder fast path off runs at 1.136 of all on.
- string: canterbury/asyoulik.txt, decoding: J12 decoder escape words off runs at 1.062 of all on.
- string: canterbury/asyoulik.txt, decoding: J13 decoder escape blocks off runs at 1.144 of all on.
- string: canterbury/lcet10.txt, decoding: J7 wide vectors off runs at 1.106 of all on.
- string: canterbury/lcet10.txt, decoding: J8 decoder fast path off runs at 1.109 of all on.
- string: canterbury/lcet10.txt, decoding: J13 decoder escape blocks off runs at 1.122 of all on.
- messages: a tree of 341 objects, encoding: J2 hex vectors off runs at 1.059 of all on.
- messages: a tree of 341 objects, encoding: J5 UTF-8 vectors off runs at 1.071 of all on.
- messages: a tree of 341 objects, encoding: J7 wide vectors off runs at 1.080 of all on.
- messages: a tree of 341 objects, encoding: J9 encoder fast path off runs at 1.078 of all on.
- messages: a tree of 341 objects, encoding: J14 encoder escape blocks off runs at 1.079 of all on.

## UTF-8 validation against simdutf

stdx's `is_utf8`, the check the loops apply to every string's octets, run alone over each string workload's octets at the width the host's features pick (16 lanes on aarch64, AVX2's 32 or AVX-512's 64 on x86-64, decision 39), beside simdutf 9.3.3's `validate_utf8` in the same run; on a host with AVX-512, again with AVX2 alone. Each ratio is stdx's throughput over the other's. simdutf picks its kernel at run time. Before timing, every copy of the check and simdutf judged 20000 seeded buffers and each workload, whole and changed, alike.

| Workload | Octets | stdx, MB/s | simdutf, MB/s | stdx / simdutf | stdx with AVX2 alone, MB/s | stdx / stdx with AVX2 alone |
|---|---|---|---|---|---|---|
| string: silesia/dickens | 166668 | 155117.5 ± 1.7% | 118763.5 ± 0.1% | 1.306 | 98476.5 ± 0.2% | 1.575 |
| string: silesia/nci | 1048576 | 156752.6 ± 0.3% | 119476.9 ± 0.3% | 1.312 | 98909.4 ± 0.1% | 1.585 |
| string: silesia/reymont | 1048576 | 157657.8 ± 1.3% | 119353.4 ± 0.1% | 1.321 | 98931.5 ± 0.1% | 1.594 |
| string: silesia/samba | 65546 | 153322.5 ± 1.0% | 117019.3 ± 0.3% | 1.310 | 97226.7 ± 0.3% | 1.577 |
| string: silesia/webster | 1048576 | 159422.0 ± 1.9% | 119441.5 ± 0.2% | 1.335 | 99324.0 ± 0.2% | 1.605 |
| string: silesia/xml | 1048576 | 159015.9 ± 1.5% | 119456.2 ± 0.3% | 1.331 | 98929.4 ± 0.1% | 1.607 |
| string: canterbury/alice29.txt | 152089 | 157197.5 ± 0.9% | 118624.6 ± 0.1% | 1.325 | 98341.3 ± 0.2% | 1.598 |
| string: canterbury/asyoulik.txt | 125179 | 156403.6 ± 1.9% | 118313.8 ± 0.1% | 1.322 | 98628.0 ± 0.2% | 1.586 |
| string: canterbury/lcet10.txt | 426754 | 158954.3 ± 1.6% | 119243.7 ± 0.2% | 1.333 | 99106.1 ± 0.3% | 1.604 |
| string: canterbury/plrabn12.txt | 481861 | 157674.7 ± 1.5% | 119243.2 ± 0.4% | 1.322 | 99233.1 ± 0.1% | 1.589 |
| string: canterbury-large/E.coli | 1048576 | 159644.9 ± 2.3% | 119567.0 ± 0.2% | 1.335 | 98785.6 ± 0.1% | 1.616 |
| string: canterbury-large/bible.txt | 1048576 | 140258.5 ± 1.9% | 111037.1 ± 0.2% | 1.263 | 93840.4 ± 0.3% | 1.495 |
| string: canterbury-large/world192.txt | 1048576 | 161873.7 ± 2.1% | 119719.7 ± 0.5% | 1.352 | 98880.7 ± 0.5% | 1.637 |
| string: http/html-1m | 1048576 | 141601.9 ± 1.7% | 109323.5 ± 0.3% | 1.295 | 91835.6 ± 0.5% | 1.542 |
| string: http/json-1m | 1048576 | 118066.7 ± 2.0% | 103625.0 ± 0.2% | 1.139 | 80820.2 ± 1.0% | 1.461 |
| string: http/js-1m | 1048576 | 143984.8 ± 0.9% | 112149.1 ± 0.7% | 1.284 | 93085.6 ± 0.8% | 1.547 |
| string: http/css-1m | 1048576 | 156225.7 ± 1.3% | 118913.4 ± 0.2% | 1.314 | 97888.9 ± 0.3% | 1.596 |
| string: dickens as Cyrillic and CJK | 1847045 | 23631.5 ± 0.2% | 21084.0 ± 0.6% | 1.121 | 15155.6 ± 0.2% | 1.559 |

## Losses to simdutf

None.

## UTF-8 validation by the buffer's offset from a 64-octet line

| Buffer | Octets | Offset | stdx, MB/s | simdutf, MB/s | stdx / simdutf | stdx with AVX2 alone, MB/s | stdx / stdx with AVX2 alone |
|---|---|---|---|---|---|---|---|
| string: canterbury-large/bible.txt | 1048576 | 0 | 156998.1 ± 1.8% | 119604.4 ± 5.6% | 1.313 | 99493.5 ± 0.2% | 1.578 |
| string: canterbury-large/bible.txt | 1048576 | 1 | 158847.5 ± 1.4% | 119518.2 ± 5.7% | 1.329 | 98857.0 ± 0.2% | 1.607 |
| string: canterbury-large/bible.txt | 1048576 | 8 | 157395.6 ± 10.2% | 119525.1 ± 0.1% | 1.317 | 98852.1 ± 0.1% | 1.592 |
| string: canterbury-large/bible.txt | 1048576 | 16 | 156774.2 ± 0.7% | 119532.5 ± 0.2% | 1.312 | 98796.3 ± 0.3% | 1.587 |
| string: canterbury-large/bible.txt | 1048576 | 32 | 156516.7 ± 0.2% | 119512.7 ± 0.1% | 1.310 | 98913.0 ± 0.3% | 1.582 |
| string: canterbury-large/bible.txt | 1048576 | 48 | 156516.5 ± 1.9% | 119502.3 ± 0.9% | 1.310 | 99384.4 ± 0.7% | 1.575 |
| string: dickens as Cyrillic and CJK | 1048576 | 0 | 24386.8 ± 2.3% | 21784.0 ± 0.1% | 1.119 | 15372.0 ± 0.4% | 1.586 |
| string: dickens as Cyrillic and CJK | 1048576 | 1 | 24389.6 ± 0.3% | 21773.5 ± 0.1% | 1.120 | 15380.3 ± 0.3% | 1.586 |
| string: dickens as Cyrillic and CJK | 1048576 | 8 | 24394.2 ± 0.3% | 21777.6 ± 0.5% | 1.120 | 15369.6 ± 0.1% | 1.587 |
| string: dickens as Cyrillic and CJK | 1048576 | 16 | 24385.6 ± 0.8% | 21764.1 ± 0.3% | 1.120 | 15370.0 ± 1.4% | 1.587 |
| string: dickens as Cyrillic and CJK | 1048576 | 32 | 24392.5 ± 0.2% | 21774.9 ± 0.1% | 1.120 | 15375.7 ± 0.1% | 1.586 |
| string: dickens as Cyrillic and CJK | 1048576 | 48 | 24381.6 ± 0.4% | 21777.8 ± 0.7% | 1.120 | 15387.4 ± 0.1% | 1.585 |

## Messages against serde_json's typed code

stdx's encoder a token a call through `TextWriter`'s methods, a member's name and its value in one `member_*` call, beside serde_json 1.0.154 writing the same messages from Rust types, as code of the form serde's derive generates writes them. Octets are the ones written.

| Workload | Octets | TextWriter's methods, MB/s | serde_json typed, MB/s | stdx / serde_json typed |
|---|---|---|---|---|
| messages: 11 string members | 1025025 | 1226.5 ± 3.7% | 835.7 ± 1.6% | 1.468 |
| messages: 50 nested objects | 1121600 | 1630.1 ± 1.0% | 923.3 ± 5.7% | 1.765 |
| messages: a tree of 341 objects | 612600 | 516.7 ± 3.4% | 518.4 ± 0.2% | 0.997 |

## Against the baselines

stdx with every claim on, timed beside simdjson 5.1.1, yyjson 0.13.0, Zig 0.16.0's std.json, serde_json 1.0.154 and Go's encoding/json/jsontext in the same run. Each ratio is stdx's throughput over the baseline's; below 1, the baseline is faster. stdx is built for the architecture's baseline CPU in ReleaseSafe. Each baseline is built for the same CPU, the C, C++ and Zig ones in ReleaseFast (decision 75), and simdjson picks its kernel at run time. Decoding visits every value; encoding writes each text from its tokens.

## Decoding against the baselines

Octets are the text's. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1385.8 ± 0.5% | 1457.8 ± 2.5% | 1115.3 ± 0.4% | 392.3 ± 1.5% | 675.2 ± 0.8% | 365.1 ± 1.8% | 0.951 | 1.242 | 3.532 | 2.052 | 3.796 |
| qlog records, JSON text sequence | 1467503 | 1092.9 ± 2.2% | 1183.5 ± 2.6% | 1128.2 ± 0.5% | 329.0 ± 1.1% | 770.0 ± 0.4% | 318.0 ± 3.4% | 0.923 | 0.969 | 3.322 | 1.419 | 3.437 |
| messages: 11 string members | 1025025 | 1078.6 ± 0.5% | 1934.9 ± 0.8% | 698.9 ± 3.1% | 337.7 ± 0.6% | 517.6 ± 0.2% | 303.1 ± 5.2% | 0.557 | 1.543 | 3.194 | 2.084 | 3.559 |
| messages: 50 nested objects | 1121600 | 1313.2 ± 0.2% | 1698.3 ± 0.6% | 1447.4 ± 0.4% | 424.2 ± 0.5% | 909.2 ± 3.4% | 421.3 ± 0.6% | 0.773 | 0.907 | 3.096 | 1.444 | 3.117 |
| messages: a tree of 341 objects | 612600 | 664.5 ± 0.8% | 844.4 ± 1.9% | 703.1 ± 5.6% | 182.1 ± 0.8% | 616.9 ± 0.7% | 209.4 ± 0.6% | 0.787 | 0.945 | 3.649 | 1.077 | 3.173 |
| string: silesia/dickens | 172528 | 6725.5 ± 0.6% | 3439.3 ± 2.1% | 2904.3 ± 2.2% | 317.6 ± 0.9% | 3097.4 ± 0.9% | 573.9 ± 2.4% | 1.955 | 2.316 | 21.177 | 2.171 | 11.718 |
| string: silesia/nci | 1075110 | 5453.6 ± 0.7% | 3936.0 ± 0.3% | 3058.6 ± 0.2% | 649.2 ± 0.6% | 3642.7 ± 4.1% | 556.6 ± 5.5% | 1.386 | 1.783 | 8.401 | 1.497 | 9.797 |
| string: silesia/reymont | 1075159 | 3556.0 ± 1.3% | 3432.1 ± 0.2% | 1940.4 ± 1.7% | 344.0 ± 0.7% | 2101.3 ± 0.4% | 488.7 ± 1.5% | 1.036 | 1.833 | 10.336 | 1.692 | 7.277 |
| string: silesia/samba | 97582 | 4007.5 ± 0.4% | 3785.1 ± 0.4% | 3055.9 ± 0.4% | 328.8 ± 0.7% | 1907.3 ± 1.0% | 419.1 ± 4.9% | 1.059 | 1.311 | 12.188 | 2.101 | 9.563 |
| string: silesia/webster | 1098490 | 4447.6 ± 1.2% | 2451.1 ± 0.3% | 1757.0 ± 0.6% | 310.2 ± 0.4% | 2087.6 ± 0.6% | 462.8 ± 2.5% | 1.815 | 2.531 | 14.339 | 2.130 | 9.610 |
| string: silesia/xml | 1090118 | 6130.1 ± 0.4% | 5047.3 ± 0.5% | 2459.2 ± 3.4% | 510.8 ± 0.7% | 3302.1 ± 0.4% | 536.0 ± 0.6% | 1.215 | 2.493 | 12.001 | 1.856 | 11.436 |
| string: canterbury/alice29.txt | 159425 | 5743.3 ± 0.4% | 2802.1 ± 1.2% | 2826.0 ± 1.4% | 300.0 ± 2.5% | 2789.8 ± 0.8% | 516.3 ± 3.1% | 2.050 | 2.032 | 19.142 | 2.059 | 11.124 |
| string: canterbury/asyoulik.txt | 132198 | 4290.1 ± 0.6% | 2636.4 ± 1.9% | 2806.0 ± 1.2% | 305.3 ± 0.7% | 2395.7 ± 4.1% | 452.0 ± 1.7% | 1.627 | 1.529 | 14.052 | 1.791 | 9.492 |
| string: canterbury/lcet10.txt | 441884 | 6648.5 ± 0.6% | 3280.8 ± 0.7% | 2354.6 ± 0.4% | 346.1 ± 0.4% | 2806.8 ± 0.7% | 572.3 ± 1.0% | 2.026 | 2.824 | 19.208 | 2.369 | 11.617 |
| string: canterbury/plrabn12.txt | 503330 | 5082.5 ± 0.2% | 3173.3 ± 0.8% | 1833.7 ± 2.0% | 323.2 ± 0.4% | 2804.7 ± 0.5% | 533.1 ± 1.8% | 1.602 | 2.772 | 15.725 | 1.812 | 9.534 |
| string: canterbury-large/E.coli | 1048578 | 32324.3 ± 0.6% | 13639.2 ± 0.6% | 3456.3 ± 0.3% | 1284.5 ± 0.2% | 8951.4 ± 0.2% | 909.7 ± 3.2% | 2.370 | 9.352 | 25.165 | 3.611 | 35.532 |
| string: canterbury-large/bible.txt | 1055886 | 8556.7 ± 1.7% | 5322.5 ± 0.5% | 2810.6 ± 0.3% | 357.7 ± 0.4% | 3897.2 ± 0.5% | 630.0 ± 2.8% | 1.608 | 3.044 | 23.919 | 2.196 | 13.581 |
| string: canterbury-large/world192.txt | 1103121 | 4160.0 ± 0.4% | 2322.0 ± 0.3% | 1779.6 ± 0.2% | 327.5 ± 0.6% | 2131.3 ± 0.3% | 463.7 ± 1.7% | 1.792 | 2.338 | 12.702 | 1.952 | 8.971 |
| string: http/html-1m | 1058582 | 9150.7 ± 3.1% | 4786.2 ± 1.5% | 2725.8 ± 1.6% | 427.1 ± 0.2% | 3659.6 ± 3.7% | 596.5 ± 2.5% | 1.912 | 3.357 | 21.423 | 2.500 | 15.341 |
| string: http/json-1m | 1190272 | 3342.7 ± 0.8% | 1260.3 ± 0.7% | 2092.5 ± 0.3% | 480.1 ± 0.7% | 1344.0 ± 0.8% | 437.2 ± 0.4% | 2.652 | 1.597 | 6.962 | 2.487 | 7.646 |
| string: http/js-1m | 1144362 | 2861.7 ± 0.3% | 1618.4 ± 1.2% | 1335.7 ± 0.5% | 325.8 ± 0.7% | 1424.7 ± 0.5% | 379.5 ± 1.4% | 1.768 | 2.142 | 8.785 | 2.009 | 7.540 |
| string: http/css-1m | 1097820 | 3297.3 ± 0.5% | 2912.1 ± 0.2% | 2290.7 ± 0.7% | 453.6 ± 0.3% | 2069.8 ± 0.4% | 436.6 ± 0.9% | 1.132 | 1.439 | 7.269 | 1.593 | 7.552 |
| string: dickens as Cyrillic and CJK | 1883069 | 5850.5 ± 0.5% | 3001.0 ± 2.9% | 668.6 ± 0.8% | 375.2 ± 2.4% | 513.2 ± 0.4% | 163.8 ± 2.9% | 1.950 | 8.751 | 15.595 | 11.400 | 35.728 |
| string: dickens as Cyrillic and CJK, as \u escapes | 5075485 | 1199.8 ± 1.2% | 1254.9 ± 0.4% | 1103.7 ± 1.0% | 264.7 ± 0.6% | 479.9 ± 0.5% | 229.1 ± 3.6% | 0.956 | 1.087 | 4.533 | 2.500 | 5.237 |
| hex: silesia/dickens | 524290 | 45655.4 ± 0.2% | 15041.7 ± 0.6% | 3562.1 ± 0.6% | 478.3 ± 0.7% | 8940.1 ± 0.3% | 1126.3 ± 4.0% | 3.035 | 12.817 | 95.457 | 5.107 | 40.537 |
| hex: silesia/mozilla | 524290 | 46333.4 ± 0.5% | 15054.0 ± 3.0% | 3504.5 ± 1.1% | 431.1 ± 0.5% | 8919.3 ± 5.1% | 1134.3 ± 0.5% | 3.078 | 13.221 | 107.477 | 5.195 | 40.846 |
| hex: silesia/mr | 524290 | 44680.5 ± 0.2% | 15033.7 ± 0.3% | 3501.2 ± 0.3% | 648.1 ± 0.4% | 8945.2 ± 0.7% | 1129.3 ± 1.7% | 2.972 | 12.761 | 68.942 | 4.995 | 39.566 |
| hex: silesia/nci | 524290 | 45195.5 ± 0.3% | 15066.0 ± 0.2% | 3573.6 ± 0.7% | 804.0 ± 2.6% | 8929.6 ± 0.5% | 1132.5 ± 1.5% | 3.000 | 12.647 | 56.214 | 5.061 | 39.907 |
| hex: silesia/ooffice | 524290 | 47888.7 ± 0.5% | 14961.3 ± 0.9% | 3471.6 ± 0.5% | 341.9 ± 0.8% | 8830.8 ± 1.5% | 1127.6 ± 0.4% | 3.201 | 13.794 | 140.068 | 5.423 | 42.471 |
| hex: silesia/osdb | 524290 | 45425.9 ± 2.9% | 15020.6 ± 3.5% | 3499.4 ± 0.8% | 457.6 ± 0.7% | 8876.2 ± 1.1% | 1131.6 ± 1.6% | 3.024 | 12.981 | 99.278 | 5.118 | 40.141 |
| hex: silesia/reymont | 524290 | 44569.9 ± 0.6% | 15050.4 ± 0.3% | 3571.4 ± 0.4% | 500.0 ± 0.9% | 8954.1 ± 0.8% | 1130.1 ± 1.5% | 2.961 | 12.480 | 89.138 | 4.978 | 39.438 |
| hex: silesia/samba | 524290 | 33999.9 ± 0.1% | 15026.7 ± 3.4% | 3509.1 ± 0.1% | 369.4 ± 0.1% | 8946.3 ± 0.1% | 1129.5 ± 1.2% | 2.263 | 9.689 | 92.044 | 3.800 | 30.101 |
| hex: silesia/sao | 524290 | 44615.8 ± 0.5% | 15000.7 ± 0.4% | 3501.2 ± 0.7% | 280.8 ± 0.8% | 8897.0 ± 0.7% | 1131.4 ± 1.4% | 2.974 | 12.743 | 158.862 | 5.015 | 39.435 |
| hex: silesia/webster | 524290 | 45647.1 ± 2.8% | 14955.0 ± 1.1% | 3565.0 ± 4.5% | 452.5 ± 1.3% | 8917.2 ± 1.4% | 1128.7 ± 2.2% | 3.052 | 12.804 | 100.867 | 5.119 | 40.443 |
| hex: silesia/x-ray | 524290 | 47893.2 ± 0.7% | 14904.5 ± 0.5% | 3486.7 ± 0.6% | 423.0 ± 1.2% | 8861.4 ± 0.8% | 1129.9 ± 1.2% | 3.213 | 13.736 | 113.229 | 5.405 | 42.385 |
| hex: silesia/xml | 524290 | 44802.1 ± 1.0% | 14921.0 ± 0.9% | 3536.1 ± 0.4% | 727.5 ± 2.2% | 8870.2 ± 1.4% | 1127.5 ± 1.0% | 3.003 | 12.670 | 61.587 | 5.051 | 39.737 |
| hex: canterbury/alice29.txt | 304180 | 48244.9 ± 2.2% | 14066.8 ± 0.9% | 3542.1 ± 0.6% | 480.0 ± 0.6% | 8876.8 ± 1.3% | 1131.0 ± 2.3% | 3.430 | 13.620 | 100.506 | 5.435 | 42.658 |
| hex: canterbury/asyoulik.txt | 250360 | 46260.6 ± 1.2% | 14848.1 ± 0.3% | 3474.4 ± 0.4% | 467.1 ± 0.4% | 8832.0 ± 0.4% | 1134.5 ± 0.7% | 3.116 | 13.315 | 99.043 | 5.238 | 40.777 |
| hex: canterbury/cp.html | 49208 | 43367.7 ± 1.1% | 14403.1 ± 0.5% | 3573.8 ± 1.1% | 507.9 ± 1.1% | 9230.2 ± 0.6% | 1122.4 ± 1.3% | 3.011 | 12.135 | 85.392 | 4.698 | 38.640 |
| hex: canterbury/fields.c | 22302 | 50735.9 ± 1.7% | 17373.7 ± 0.7% | 3649.6 ± 0.7% | 566.2 ± 0.7% | 9183.0 ± 0.5% | 1089.5 ± 2.6% | 2.920 | 13.902 | 89.601 | 5.525 | 46.570 |
| hex: canterbury/grammar.lsp | 7444 | 43191.5 ± 2.4% | 17174.5 ± 0.5% | 3609.9 ± 0.7% | 738.1 ± 0.9% | 8901.0 ± 6.4% | 1052.1 ± 3.0% | 2.515 | 11.965 | 58.518 | 4.852 | 41.052 |
| hex: canterbury/kennedy.xls | 524290 | 46233.5 ± 1.4% | 14956.5 ± 0.5% | 3544.0 ± 0.7% | 753.9 ± 1.9% | 8852.8 ± 0.7% | 1108.8 ± 2.4% | 3.091 | 13.045 | 61.322 | 5.222 | 41.697 |
| hex: canterbury/lcet10.txt | 524290 | 45709.2 ± 2.3% | 14990.9 ± 0.7% | 3516.8 ± 1.0% | 479.4 ± 2.7% | 8868.5 ± 1.4% | 1122.0 ± 2.2% | 3.049 | 12.997 | 95.341 | 5.154 | 40.738 |
| hex: canterbury/plrabn12.txt | 524290 | 43579.9 ± 5.2% | 14945.0 ± 0.7% | 3532.2 ± 0.7% | 462.2 ± 1.4% | 8841.0 ± 1.6% | 1108.4 ± 1.5% | 2.916 | 12.338 | 94.282 | 4.929 | 39.316 |
| hex: canterbury/ptt5 | 524290 | 44910.5 ± 1.5% | 14993.4 ± 0.4% | 3471.3 ± 0.7% | 660.5 ± 0.7% | 8839.9 ± 0.8% | 1120.5 ± 1.8% | 2.995 | 12.938 | 67.991 | 5.080 | 40.079 |
| hex: canterbury/sum | 76482 | 44325.9 ± 0.6% | 15266.1 ± 1.2% | 3560.7 ± 1.1% | 585.5 ± 0.9% | 8917.1 ± 0.9% | 1114.7 ± 2.3% | 2.904 | 12.449 | 75.701 | 4.971 | 39.765 |
| hex: canterbury/xargs.1 | 8456 | 44855.9 ± 1.6% | 17213.6 ± 0.8% | 3539.4 ± 0.8% | 720.6 ± 0.9% | 8916.1 ± 0.9% | 1078.5 ± 4.1% | 2.606 | 12.673 | 62.244 | 5.031 | 41.590 |
| hex: canterbury-large/E.coli | 524290 | 44795.5 ± 1.5% | 14937.9 ± 0.7% | 3470.3 ± 3.4% | 956.0 ± 0.3% | 8811.3 ± 2.5% | 1095.6 ± 6.8% | 2.999 | 12.908 | 46.857 | 5.084 | 40.888 |
| hex: canterbury-large/bible.txt | 524290 | 44082.4 ± 1.5% | 14929.6 ± 0.9% | 3479.4 ± 1.3% | 495.2 ± 1.8% | 8846.1 ± 1.3% | 1099.1 ± 1.2% | 2.953 | 12.669 | 89.014 | 4.983 | 40.107 |
| hex: canterbury-large/world192.txt | 524290 | 45272.6 ± 4.2% | 14964.4 ± 0.7% | 3541.4 ± 0.6% | 463.5 ± 0.7% | 8887.0 ± 1.1% | 1103.9 ± 3.4% | 3.025 | 12.784 | 97.677 | 5.094 | 41.010 |
| hex: http/html-1kx1024 | 2099200 | 18251.2 ± 1.3% | 12121.5 ± 6.3% | 3186.4 ± 0.8% | 502.5 ± 0.7% | 7552.3 ± 1.2% | 962.6 ± 2.2% | 1.506 | 5.728 | 36.322 | 2.417 | 18.961 |
| hex: http/html-16kx64 | 2097280 | 36089.5 ± 1.8% | 13926.5 ± 0.5% | 3412.8 ± 0.9% | 511.8 ± 3.8% | 8652.8 ± 9.1% | 1067.9 ± 3.2% | 2.591 | 10.575 | 70.520 | 4.171 | 33.795 |
| hex: http/html-1m | 524290 | 47947.1 ± 1.9% | 14947.0 ± 0.8% | 3470.4 ± 1.3% | 503.5 ± 0.9% | 8867.4 ± 1.3% | 1117.6 ± 0.9% | 3.208 | 13.816 | 95.222 | 5.407 | 42.902 |
| hex: http/json-1kx1024 | 2099200 | 17642.9 ± 1.2% | 12097.0 ± 10.2% | 3172.8 ± 0.9% | 668.8 ± 0.8% | 7615.0 ± 1.4% | 959.8 ± 2.9% | 1.458 | 5.561 | 26.381 | 2.317 | 18.381 |
| hex: http/json-16kx64 | 2097280 | 33619.4 ± 3.0% | 13941.0 ± 0.5% | 3390.6 ± 0.4% | 678.8 ± 0.9% | 8524.8 ± 1.0% | 1042.5 ± 4.0% | 2.412 | 9.915 | 49.529 | 3.944 | 32.250 |
| hex: http/json-1m | 524290 | 44989.8 ± 1.4% | 14945.0 ± 0.6% | 3529.5 ± 3.3% | 693.6 ± 0.7% | 8874.9 ± 0.5% | 1109.4 ± 0.8% | 3.010 | 12.747 | 64.862 | 5.069 | 40.553 |
| hex: http/js-1kx1024 | 2099200 | 18024.8 ± 0.9% | 12484.4 ± 5.7% | 3190.0 ± 0.3% | 486.3 ± 0.4% | 7609.8 ± 0.7% | 945.8 ± 2.7% | 1.444 | 5.650 | 37.068 | 2.369 | 19.058 |
| hex: http/js-16kx64 | 2097280 | 34561.6 ± 4.8% | 13894.9 ± 0.4% | 3372.1 ± 0.7% | 491.7 ± 0.7% | 8424.2 ± 0.6% | 1051.6 ± 8.0% | 2.487 | 10.249 | 70.288 | 4.103 | 32.865 |
| hex: http/js-1m | 524290 | 45024.2 ± 1.9% | 14947.9 ± 1.2% | 3509.6 ± 0.5% | 511.5 ± 0.9% | 8874.6 ± 0.8% | 1077.5 ± 2.3% | 3.012 | 12.829 | 88.019 | 5.073 | 41.785 |
| hex: http/css-1kx1024 | 2099200 | 17659.7 ± 1.6% | 12384.0 ± 0.9% | 3180.4 ± 0.7% | 567.9 ± 0.8% | 7566.2 ± 1.2% | 939.8 ± 1.7% | 1.426 | 5.553 | 31.096 | 2.334 | 18.790 |
| hex: http/css-16kx64 | 2097280 | 34812.9 ± 1.4% | 13818.2 ± 0.4% | 3377.3 ± 0.2% | 575.8 ± 0.8% | 8613.1 ± 0.8% | 1048.0 ± 1.9% | 2.519 | 10.308 | 60.456 | 4.042 | 33.220 |
| hex: http/css-1m | 524290 | 46064.3 ± 0.5% | 14952.7 ± 0.7% | 3544.6 ± 0.6% | 556.2 ± 0.7% | 8892.0 ± 0.7% | 1087.3 ± 3.4% | 3.081 | 12.996 | 82.812 | 5.180 | 42.367 |
| hex: shuffled/dickens-1m | 524290 | 45179.1 ± 2.3% | 14920.7 ± 0.6% | 3473.8 ± 1.3% | 476.3 ± 1.1% | 8846.2 ± 1.3% | 1074.9 ± 1.9% | 3.028 | 13.006 | 94.861 | 5.107 | 42.031 |

## Encoding against the baselines

Octets are the ones stdx writes. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1739.3 ± 3.9% | 1472.5 ± 1.2% | 1038.0 ± 1.2% | 463.2 ± 3.5% | 436.8 ± 3.1% | 501.4 ± 1.1% | 1.181 | 1.676 | 3.755 | 3.982 | 3.469 |
| qlog records, JSON text sequence | 1467503 | 1653.2 ± 2.3% | 1219.8 ± 1.7% | 949.8 ± 4.0% | 437.6 ± 1.0% | 537.8 ± 1.0% | 352.3 ± 0.7% | 1.355 | 1.741 | 3.778 | 3.074 | 4.693 |
| messages: 11 string members | 1025025 | 1326.7 ± 1.2% | 1105.8 ± 1.2% | 772.7 ± 1.1% | 412.4 ± 1.1% | 416.7 ± 1.3% | 434.9 ± 1.3% | 1.200 | 1.717 | 3.217 | 3.184 | 3.051 |
| messages: 50 nested objects | 1121600 | 1992.4 ± 1.1% | 1868.4 ± 1.1% | 1349.4 ± 1.0% | 593.6 ± 1.0% | 608.1 ± 1.4% | 522.2 ± 1.2% | 1.066 | 1.477 | 3.356 | 3.277 | 3.816 |
| messages: a tree of 341 objects | 612600 | 597.8 ± 3.0% | 680.1 ± 2.3% | 581.1 ± 0.3% | 336.7 ± 1.6% | 351.4 ± 0.8% | 219.1 ± 1.1% | 0.879 | 1.029 | 1.775 | 1.701 | 2.728 |
| string: silesia/dickens | 172528 | 12802.0 ± 1.0% | 3908.9 ± 1.9% | 3063.3 ± 1.0% | 332.2 ± 1.7% | 1512.5 ± 1.3% | 1174.3 ± 1.5% | 3.275 | 4.179 | 38.541 | 8.464 | 10.902 |
| string: silesia/nci | 1075110 | 11264.8 ± 10.4% | 4649.8 ± 0.5% | 3125.5 ± 0.5% | 906.9 ± 1.0% | 1595.2 ± 2.9% | 1199.6 ± 0.9% | 2.423 | 3.604 | 12.421 | 7.062 | 9.390 |
| string: silesia/reymont | 1075159 | 5320.0 ± 5.6% | 1849.6 ± 1.3% | 1893.4 ± 1.2% | 381.5 ± 1.6% | 1335.7 ± 1.7% | 1034.0 ± 1.5% | 2.876 | 2.810 | 13.945 | 3.983 | 5.145 |
| string: silesia/samba | 97582 | 6250.3 ± 0.4% | 2693.7 ± 0.8% | 4045.4 ± 0.5% | 347.2 ± 0.4% | 1268.9 ± 3.4% | 1171.4 ± 0.7% | 2.320 | 1.545 | 18.004 | 4.926 | 5.336 |
| string: silesia/webster | 1098490 | 7066.5 ± 1.6% | 1982.1 ± 0.3% | 1744.6 ± 4.6% | 350.9 ± 0.9% | 1268.6 ± 1.1% | 600.5 ± 1.2% | 3.565 | 4.050 | 20.135 | 5.570 | 11.767 |
| string: silesia/xml | 1090118 | 10716.6 ± 0.6% | 3197.4 ± 1.0% | 2525.9 ± 0.5% | 603.1 ± 4.0% | 1712.4 ± 2.6% | 965.7 ± 0.8% | 3.352 | 4.243 | 17.769 | 6.258 | 11.097 |
| string: canterbury/alice29.txt | 159425 | 12704.9 ± 1.0% | 2879.1 ± 1.7% | 2973.3 ± 0.7% | 316.3 ± 1.0% | 1352.6 ± 1.7% | 1082.2 ± 1.0% | 4.413 | 4.273 | 40.166 | 9.393 | 11.740 |
| string: canterbury/asyoulik.txt | 132198 | 10558.8 ± 1.1% | 2086.4 ± 1.4% | 3106.0 ± 0.5% | 314.6 ± 1.0% | 1236.1 ± 2.3% | 949.5 ± 1.3% | 5.061 | 3.400 | 33.564 | 8.542 | 11.120 |
| string: canterbury/lcet10.txt | 441884 | 12593.1 ± 1.2% | 3082.6 ± 0.6% | 2548.5 ± 1.2% | 365.6 ± 1.4% | 1457.4 ± 2.7% | 1183.6 ± 1.2% | 4.085 | 4.941 | 34.442 | 8.641 | 10.640 |
| string: canterbury/plrabn12.txt | 503330 | 8756.4 ± 1.2% | 2305.7 ± 0.6% | 2089.4 ± 0.7% | 346.5 ± 0.3% | 1369.8 ± 2.8% | 1106.6 ± 1.6% | 3.798 | 4.191 | 25.268 | 6.392 | 7.913 |
| string: canterbury-large/E.coli | 1048578 | 34601.6 ± 0.9% | 15735.6 ± 1.5% | 3465.8 ± 0.7% | 1692.2 ± 0.3% | 2966.4 ± 4.6% | 1410.1 ± 0.5% | 2.199 | 9.984 | 20.447 | 11.664 | 24.538 |
| string: canterbury-large/bible.txt | 1055886 | 9610.2 ± 1.6% | 4856.0 ± 0.7% | 2990.9 ± 0.3% | 404.3 ± 0.3% | 2035.8 ± 0.3% | 1477.6 ± 0.5% | 1.979 | 3.213 | 23.771 | 4.721 | 6.504 |
| string: canterbury-large/world192.txt | 1103121 | 6689.2 ± 0.6% | 1737.9 ± 2.3% | 1862.1 ± 2.0% | 348.6 ± 2.5% | 1270.4 ± 1.2% | 963.9 ± 1.2% | 3.849 | 3.592 | 19.191 | 5.265 | 6.940 |
| string: http/html-1m | 1058582 | 10108.9 ± 1.5% | 4357.5 ± 2.2% | 2874.3 ± 3.6% | 418.4 ± 1.2% | 2033.9 ± 0.8% | 846.4 ± 0.9% | 2.320 | 3.517 | 24.159 | 4.970 | 11.944 |
| string: http/json-1m | 1190272 | 8358.9 ± 0.6% | 1567.1 ± 5.9% | 1562.4 ± 0.5% | 556.9 ± 1.1% | 1016.5 ± 1.1% | 848.2 ± 0.5% | 5.334 | 5.350 | 15.009 | 8.223 | 9.855 |
| string: http/js-1m | 1144362 | 6574.4 ± 1.9% | 1120.0 ± 0.9% | 1388.7 ± 0.8% | 331.6 ± 1.8% | 1037.9 ± 1.7% | 752.5 ± 1.1% | 5.870 | 4.734 | 19.829 | 6.335 | 8.737 |
| string: http/css-1m | 1097820 | 9156.0 ± 0.7% | 1472.8 ± 0.3% | 2274.3 ± 1.3% | 506.1 ± 0.8% | 1135.9 ± 1.5% | 869.3 ± 2.0% | 6.217 | 4.026 | 18.093 | 8.061 | 10.532 |
| string: dickens as Cyrillic and CJK | 1883069 | 5470.4 ± 0.8% | 3651.6 ± 0.6% | 488.0 ± 0.3% | 246.7 ± 1.2% | 454.2 ± 0.5% | 356.1 ± 0.6% | 1.498 | 11.209 | 22.174 | 12.045 | 15.363 |
| hex: silesia/dickens | 524290 | 42334.4 ± 1.3% | 2575.9 ± 1.1% | 1501.2 ± 0.5% | 457.7 ± 2.9% | 1498.8 ± 0.7% | 1064.9 ± 0.4% | 16.435 | 28.200 | 92.496 | 28.245 | 39.753 |
| hex: silesia/mozilla | 524290 | 42968.2 ± 8.1% | 2579.6 ± 0.6% | 1496.1 ± 0.5% | 389.3 ± 2.9% | 1558.2 ± 1.4% | 1063.3 ± 0.4% | 16.657 | 28.721 | 110.385 | 27.576 | 40.410 |
| hex: silesia/mr | 524290 | 42745.5 ± 4.3% | 2572.3 ± 0.8% | 1498.5 ± 6.0% | 596.1 ± 1.1% | 1551.7 ± 0.8% | 1062.5 ± 1.9% | 16.618 | 28.525 | 71.705 | 27.548 | 40.232 |
| hex: silesia/nci | 524290 | 43262.5 ± 1.1% | 2563.7 ± 0.6% | 1496.7 ± 0.3% | 751.4 ± 0.7% | 1537.1 ± 1.1% | 1061.5 ± 0.7% | 16.875 | 28.906 | 57.578 | 28.146 | 40.754 |
| hex: silesia/ooffice | 524290 | 43227.1 ± 0.8% | 2589.0 ± 1.1% | 1507.5 ± 2.2% | 324.6 ± 1.4% | 1558.6 ± 5.9% | 1060.7 ± 1.4% | 16.697 | 28.675 | 133.185 | 27.734 | 40.754 |
| hex: silesia/osdb | 524290 | 41689.6 ± 1.0% | 2580.9 ± 0.5% | 1502.1 ± 0.7% | 427.5 ± 0.9% | 1546.1 ± 0.7% | 1060.6 ± 0.7% | 16.153 | 27.754 | 97.520 | 26.965 | 39.308 |
| hex: silesia/reymont | 524290 | 43604.4 ± 0.7% | 2595.1 ± 1.0% | 1508.7 ± 1.2% | 483.8 ± 0.9% | 1544.1 ± 1.8% | 1064.5 ± 0.6% | 16.803 | 28.901 | 90.121 | 28.240 | 40.962 |
| hex: silesia/samba | 524290 | 43194.3 ± 1.6% | 2562.0 ± 1.1% | 1501.5 ± 1.0% | 338.3 ± 1.6% | 1555.0 ± 2.1% | 1065.3 ± 1.2% | 16.859 | 28.768 | 127.694 | 27.777 | 40.547 |
| hex: silesia/sao | 524290 | 42916.9 ± 2.2% | 2587.4 ± 0.7% | 1503.7 ± 1.0% | 266.1 ± 8.9% | 1540.3 ± 2.7% | 1060.2 ± 0.5% | 16.587 | 28.541 | 161.268 | 27.862 | 40.482 |
| hex: silesia/webster | 524290 | 43199.2 ± 1.3% | 2587.6 ± 0.7% | 1499.7 ± 0.8% | 432.9 ± 0.6% | 1543.5 ± 6.3% | 1062.2 ± 6.6% | 16.695 | 28.805 | 99.780 | 27.988 | 40.670 |
| hex: silesia/x-ray | 524290 | 42631.5 ± 7.9% | 2576.9 ± 0.7% | 1505.5 ± 1.1% | 421.0 ± 0.9% | 1563.0 ± 0.7% | 1063.0 ± 1.1% | 16.544 | 28.317 | 101.265 | 27.276 | 40.106 |
| hex: silesia/xml | 524290 | 43090.8 ± 3.9% | 2584.0 ± 0.7% | 1498.0 ± 0.7% | 684.5 ± 0.2% | 1542.3 ± 0.9% | 1060.1 ± 0.4% | 16.676 | 28.765 | 62.950 | 27.939 | 40.648 |
| hex: canterbury/alice29.txt | 304180 | 41171.4 ± 1.9% | 2612.7 ± 0.4% | 1521.4 ± 0.9% | 468.1 ± 0.7% | 1547.6 ± 0.5% | 1086.4 ± 1.3% | 15.758 | 27.062 | 87.949 | 26.603 | 37.897 |
| hex: canterbury/asyoulik.txt | 250360 | 42914.1 ± 1.8% | 2601.4 ± 0.8% | 1535.1 ± 1.3% | 455.6 ± 1.3% | 1555.6 ± 1.3% | 1079.0 ± 1.2% | 16.496 | 27.955 | 94.193 | 27.588 | 39.774 |
| hex: canterbury/cp.html | 49208 | 41957.1 ± 2.1% | 2585.0 ± 0.5% | 1523.3 ± 0.6% | 477.7 ± 1.0% | 1579.3 ± 0.9% | 1087.7 ± 0.6% | 16.231 | 27.543 | 87.830 | 26.566 | 38.573 |
| hex: canterbury/fields.c | 22302 | 42003.0 ± 0.9% | 2643.6 ± 0.4% | 1531.3 ± 0.4% | 599.0 ± 0.6% | 1603.5 ± 0.9% | 1098.3 ± 0.4% | 15.889 | 27.429 | 70.119 | 26.194 | 38.243 |
| hex: canterbury/grammar.lsp | 7444 | 38989.1 ± 1.7% | 2676.4 ± 0.9% | 1530.8 ± 0.8% | 810.2 ± 0.9% | 1599.8 ± 0.5% | 1102.5 ± 0.5% | 14.567 | 25.470 | 48.120 | 24.372 | 35.364 |
| hex: canterbury/kennedy.xls | 524290 | 43254.3 ± 1.0% | 2573.9 ± 0.9% | 1501.2 ± 0.6% | 774.0 ± 0.6% | 1497.6 ± 0.7% | 1059.5 ± 0.8% | 16.805 | 28.812 | 55.885 | 28.883 | 40.824 |
| hex: canterbury/lcet10.txt | 524290 | 43543.3 ± 0.4% | 2601.8 ± 0.5% | 1502.9 ± 0.6% | 467.7 ± 0.3% | 1563.7 ± 1.6% | 1063.2 ± 0.5% | 16.736 | 28.974 | 93.107 | 27.847 | 40.955 |
| hex: canterbury/plrabn12.txt | 524290 | 43562.2 ± 0.4% | 2580.5 ± 0.5% | 1502.7 ± 0.8% | 453.6 ± 0.7% | 1566.2 ± 0.7% | 1069.4 ± 0.7% | 16.881 | 28.990 | 96.044 | 27.813 | 40.736 |
| hex: canterbury/ptt5 | 524290 | 43505.7 ± 1.5% | 2562.7 ± 0.4% | 1498.9 ± 0.7% | 592.8 ± 1.5% | 1556.4 ± 1.0% | 1064.8 ± 0.5% | 16.977 | 29.026 | 73.396 | 27.953 | 40.857 |
| hex: canterbury/sum | 76482 | 42733.2 ± 1.1% | 2589.8 ± 0.6% | 1515.4 ± 0.4% | 559.4 ± 0.8% | 1576.1 ± 5.5% | 1088.4 ± 1.0% | 16.501 | 28.200 | 76.387 | 27.113 | 39.264 |
| hex: canterbury/xargs.1 | 8456 | 40093.3 ± 1.0% | 2669.0 ± 0.8% | 1539.4 ± 0.4% | 837.7 ± 0.5% | 1604.0 ± 0.9% | 1107.4 ± 0.6% | 15.022 | 26.045 | 47.858 | 24.996 | 36.206 |
| hex: canterbury-large/E.coli | 524290 | 41618.9 ± 0.6% | 2580.4 ± 0.7% | 1499.7 ± 0.4% | 807.9 ± 2.8% | 1539.7 ± 1.0% | 1060.7 ± 1.6% | 16.129 | 27.751 | 51.516 | 27.030 | 39.238 |
| hex: canterbury-large/bible.txt | 524290 | 43564.5 ± 0.4% | 2583.3 ± 1.1% | 1503.0 ± 0.6% | 479.7 ± 0.7% | 1559.5 ± 0.8% | 1065.9 ± 0.7% | 16.864 | 28.986 | 90.815 | 27.934 | 40.871 |
| hex: canterbury-large/world192.txt | 524290 | 43111.3 ± 1.5% | 2591.0 ± 1.4% | 1504.5 ± 5.7% | 456.0 ± 4.0% | 1536.2 ± 1.3% | 1061.4 ± 1.0% | 16.639 | 28.655 | 94.536 | 28.063 | 40.619 |
| hex: http/html-1kx1024 | 2099200 | 20991.1 ± 0.2% | 2635.4 ± 10.7% | 1441.3 ± 0.5% | 498.8 ± 0.8% | 1562.1 ± 1.3% | 1070.0 ± 7.4% | 7.965 | 14.564 | 42.087 | 13.438 | 19.618 |
| hex: http/html-16kx64 | 2097280 | 21532.6 ± 0.2% | 2208.8 ± 0.8% | 1440.7 ± 0.9% | 501.3 ± 1.1% | 1434.0 ± 4.7% | 1073.1 ± 6.7% | 9.749 | 14.946 | 42.957 | 15.016 | 20.067 |
| hex: http/html-1m | 524290 | 42771.5 ± 1.4% | 2579.2 ± 0.5% | 1497.9 ± 0.4% | 487.4 ± 0.7% | 1559.0 ± 1.2% | 1061.0 ± 1.0% | 16.583 | 28.554 | 87.747 | 27.435 | 40.312 |
| hex: http/json-1kx1024 | 2099200 | 20353.7 ± 0.3% | 2653.4 ± 0.3% | 1438.8 ± 4.9% | 689.7 ± 0.9% | 1563.1 ± 0.8% | 1067.8 ± 1.2% | 7.671 | 14.146 | 29.512 | 13.021 | 19.061 |
| hex: http/json-16kx64 | 2097280 | 22741.6 ± 0.4% | 2200.1 ± 0.9% | 1437.3 ± 0.7% | 701.2 ± 0.5% | 1431.0 ± 0.6% | 1076.0 ± 0.4% | 10.337 | 15.822 | 32.431 | 15.892 | 21.135 |
| hex: http/json-1m | 524290 | 42771.3 ± 1.3% | 2578.7 ± 2.2% | 1506.8 ± 1.3% | 722.6 ± 1.2% | 1501.8 ± 1.5% | 1067.3 ± 1.1% | 16.586 | 28.385 | 59.188 | 28.481 | 40.076 |
| hex: http/js-1kx1024 | 2099200 | 20274.0 ± 0.3% | 2562.9 ± 1.3% | 1438.2 ± 0.9% | 486.5 ± 0.7% | 1530.8 ± 1.4% | 1073.4 ± 1.8% | 7.911 | 14.097 | 41.675 | 13.244 | 18.887 |
| hex: http/js-16kx64 | 2097280 | 21428.2 ± 0.4% | 2219.6 ± 0.9% | 1454.9 ± 1.3% | 494.2 ± 1.2% | 1445.4 ± 1.3% | 1086.3 ± 1.1% | 9.654 | 14.729 | 43.355 | 14.825 | 19.725 |
| hex: http/js-1m | 524290 | 42747.4 ± 0.3% | 2583.5 ± 10.5% | 1512.0 ± 0.7% | 500.8 ± 0.2% | 1466.9 ± 0.6% | 1068.7 ± 2.6% | 16.546 | 28.272 | 85.361 | 29.141 | 39.998 |
| hex: http/css-1kx1024 | 2099200 | 21736.2 ± 0.5% | 2658.7 ± 1.3% | 1454.7 ± 1.6% | 557.0 ± 0.6% | 1576.1 ± 1.6% | 1071.8 ± 1.2% | 8.176 | 14.942 | 39.026 | 13.791 | 20.279 |
| hex: http/css-16kx64 | 2097280 | 21321.3 ± 0.5% | 2226.5 ± 0.3% | 1455.7 ± 0.1% | 565.3 ± 0.1% | 1447.8 ± 0.1% | 1087.5 ± 0.2% | 9.576 | 14.647 | 37.716 | 14.727 | 19.606 |
| hex: http/css-1m | 524290 | 42710.6 ± 0.3% | 2592.3 ± 0.6% | 1505.5 ± 5.6% | 532.4 ± 0.8% | 1481.0 ± 0.9% | 1071.6 ± 0.3% | 16.476 | 28.371 | 80.218 | 28.838 | 39.857 |
| hex: shuffled/dickens-1m | 524290 | 41899.2 ± 0.7% | 2603.1 ± 0.2% | 1514.3 ± 0.1% | 464.2 ± 0.4% | 1562.0 ± 0.8% | 1073.2 ± 0.3% | 16.096 | 27.668 | 90.258 | 26.824 | 39.043 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1800.2 ± 2.6% | 1472.5 ± 1.2% | 1038.0 ± 1.2% | 463.2 ± 3.5% | 436.8 ± 3.1% | 501.4 ± 1.1% | 1.223 | 1.734 | 3.887 | 4.121 | 3.591 |
| qlog records, JSON text sequence | 1467503 | 1712.8 ± 0.5% | 1219.8 ± 1.7% | 949.8 ± 4.0% | 437.6 ± 1.0% | 537.8 ± 1.0% | 352.3 ± 0.7% | 1.404 | 1.803 | 3.914 | 3.185 | 4.862 |
| messages: 11 string members | 1025025 | 1321.6 ± 0.8% | 1105.8 ± 1.2% | 772.7 ± 1.1% | 412.4 ± 1.1% | 416.7 ± 1.3% | 434.9 ± 1.3% | 1.195 | 1.710 | 3.205 | 3.171 | 3.039 |
| messages: 50 nested objects | 1121600 | 2002.1 ± 1.0% | 1868.4 ± 1.1% | 1349.4 ± 1.0% | 593.6 ± 1.0% | 608.1 ± 1.4% | 522.2 ± 1.2% | 1.072 | 1.484 | 3.373 | 3.292 | 3.834 |
| messages: a tree of 341 objects | 612600 | 650.9 ± 1.0% | 680.1 ± 2.3% | 581.1 ± 0.3% | 336.7 ± 1.6% | 351.4 ± 0.8% | 219.1 ± 1.1% | 0.957 | 1.120 | 1.933 | 1.852 | 2.970 |
| string: silesia/dickens | 172528 | 13309.5 ± 1.3% | 3908.9 ± 1.9% | 3063.3 ± 1.0% | 332.2 ± 1.7% | 1512.5 ± 1.3% | 1174.3 ± 1.5% | 3.405 | 4.345 | 40.068 | 8.800 | 11.334 |
| string: silesia/nci | 1075110 | 11590.1 ± 0.7% | 4649.8 ± 0.5% | 3125.5 ± 0.5% | 906.9 ± 1.0% | 1595.2 ± 2.9% | 1199.6 ± 0.9% | 2.493 | 3.708 | 12.779 | 7.265 | 9.662 |
| string: silesia/reymont | 1075159 | 5451.8 ± 1.4% | 1849.6 ± 1.3% | 1893.4 ± 1.2% | 381.5 ± 1.6% | 1335.7 ± 1.7% | 1034.0 ± 1.5% | 2.948 | 2.879 | 14.291 | 4.082 | 5.273 |
| string: silesia/samba | 97582 | 7266.0 ± 1.2% | 2693.7 ± 0.8% | 4045.4 ± 0.5% | 347.2 ± 0.4% | 1268.9 ± 3.4% | 1171.4 ± 0.7% | 2.697 | 1.796 | 20.930 | 5.726 | 6.203 |
| string: silesia/webster | 1098490 | 6964.1 ± 0.3% | 1982.1 ± 0.3% | 1744.6 ± 4.6% | 350.9 ± 0.9% | 1268.6 ± 1.1% | 600.5 ± 1.2% | 3.513 | 3.992 | 19.844 | 5.490 | 11.596 |
| string: silesia/xml | 1090118 | 11057.8 ± 2.8% | 3197.4 ± 1.0% | 2525.9 ± 0.5% | 603.1 ± 4.0% | 1712.4 ± 2.6% | 965.7 ± 0.8% | 3.458 | 4.378 | 18.335 | 6.458 | 11.451 |
| string: canterbury/alice29.txt | 159425 | 13261.4 ± 0.6% | 2879.1 ± 1.7% | 2973.3 ± 0.7% | 316.3 ± 1.0% | 1352.6 ± 1.7% | 1082.2 ± 1.0% | 4.606 | 4.460 | 41.926 | 9.805 | 12.254 |
| string: canterbury/asyoulik.txt | 132198 | 10963.9 ± 1.0% | 2086.4 ± 1.4% | 3106.0 ± 0.5% | 314.6 ± 1.0% | 1236.1 ± 2.3% | 949.5 ± 1.3% | 5.255 | 3.530 | 34.852 | 8.869 | 11.547 |
| string: canterbury/lcet10.txt | 441884 | 12571.9 ± 1.4% | 3082.6 ± 0.6% | 2548.5 ± 1.2% | 365.6 ± 1.4% | 1457.4 ± 2.7% | 1183.6 ± 1.2% | 4.078 | 4.933 | 34.384 | 8.626 | 10.622 |
| string: canterbury/plrabn12.txt | 503330 | 8843.9 ± 2.8% | 2305.7 ± 0.6% | 2089.4 ± 0.7% | 346.5 ± 0.3% | 1369.8 ± 2.8% | 1106.6 ± 1.6% | 3.836 | 4.233 | 25.521 | 6.456 | 7.992 |
| string: canterbury-large/E.coli | 1048578 | 34820.4 ± 0.9% | 15735.6 ± 1.5% | 3465.8 ± 0.7% | 1692.2 ± 0.3% | 2966.4 ± 4.6% | 1410.1 ± 0.5% | 2.213 | 10.047 | 20.576 | 11.738 | 24.694 |
| string: canterbury-large/bible.txt | 1055886 | 9822.7 ± 1.2% | 4856.0 ± 0.7% | 2990.9 ± 0.3% | 404.3 ± 0.3% | 2035.8 ± 0.3% | 1477.6 ± 0.5% | 2.023 | 3.284 | 24.296 | 4.825 | 6.648 |
| string: canterbury-large/world192.txt | 1103121 | 6514.0 ± 0.8% | 1737.9 ± 2.3% | 1862.1 ± 2.0% | 348.6 ± 2.5% | 1270.4 ± 1.2% | 963.9 ± 1.2% | 3.748 | 3.498 | 18.689 | 5.127 | 6.758 |
| string: http/html-1m | 1058582 | 10223.6 ± 2.4% | 4357.5 ± 2.2% | 2874.3 ± 3.6% | 418.4 ± 1.2% | 2033.9 ± 0.8% | 846.4 ± 0.9% | 2.346 | 3.557 | 24.433 | 5.027 | 12.079 |
| string: http/json-1m | 1190272 | 8532.2 ± 0.4% | 1567.1 ± 5.9% | 1562.4 ± 0.5% | 556.9 ± 1.1% | 1016.5 ± 1.1% | 848.2 ± 0.5% | 5.445 | 5.461 | 15.320 | 8.394 | 10.059 |
| string: http/js-1m | 1144362 | 6640.4 ± 0.4% | 1120.0 ± 0.9% | 1388.7 ± 0.8% | 331.6 ± 1.8% | 1037.9 ± 1.7% | 752.5 ± 1.1% | 5.929 | 4.782 | 20.028 | 6.398 | 8.825 |
| string: http/css-1m | 1097820 | 9207.3 ± 0.9% | 1472.8 ± 0.3% | 2274.3 ± 1.3% | 506.1 ± 0.8% | 1135.9 ± 1.5% | 869.3 ± 2.0% | 6.251 | 4.048 | 18.194 | 8.106 | 10.591 |
| string: dickens as Cyrillic and CJK | 1883069 | 5694.7 ± 0.5% | 3651.6 ± 0.6% | 488.0 ± 0.3% | 246.7 ± 1.2% | 454.2 ± 0.5% | 356.1 ± 0.6% | 1.560 | 11.669 | 23.083 | 12.539 | 15.993 |
| hex: silesia/dickens | 524290 | 42407.5 ± 1.1% | 2575.9 ± 1.1% | 1501.2 ± 0.5% | 457.7 ± 2.9% | 1498.8 ± 0.7% | 1064.9 ± 0.4% | 16.463 | 28.249 | 92.656 | 28.294 | 39.822 |
| hex: silesia/mozilla | 524290 | 42820.3 ± 8.6% | 2579.6 ± 0.6% | 1496.1 ± 0.5% | 389.3 ± 2.9% | 1558.2 ± 1.4% | 1063.3 ± 0.4% | 16.600 | 28.622 | 110.005 | 27.481 | 40.271 |
| hex: silesia/mr | 524290 | 42883.0 ± 1.1% | 2572.3 ± 0.8% | 1498.5 ± 6.0% | 596.1 ± 1.1% | 1551.7 ± 0.8% | 1062.5 ± 1.9% | 16.671 | 28.617 | 71.935 | 27.637 | 40.361 |
| hex: silesia/nci | 524290 | 43497.7 ± 2.2% | 2563.7 ± 0.6% | 1496.7 ± 0.3% | 751.4 ± 0.7% | 1537.1 ± 1.1% | 1061.5 ± 0.7% | 16.967 | 29.063 | 57.891 | 28.299 | 40.976 |
| hex: silesia/ooffice | 524290 | 42777.8 ± 0.5% | 2589.0 ± 1.1% | 1507.5 ± 2.2% | 324.6 ± 1.4% | 1558.6 ± 5.9% | 1060.7 ± 1.4% | 16.523 | 28.377 | 131.801 | 27.446 | 40.331 |
| hex: silesia/osdb | 524290 | 41537.2 ± 1.9% | 2580.9 ± 0.5% | 1502.1 ± 0.7% | 427.5 ± 0.9% | 1546.1 ± 0.7% | 1060.6 ± 0.7% | 16.094 | 27.652 | 97.164 | 26.866 | 39.165 |
| hex: silesia/reymont | 524290 | 43417.0 ± 1.2% | 2595.1 ± 1.0% | 1508.7 ± 1.2% | 483.8 ± 0.9% | 1544.1 ± 1.8% | 1064.5 ± 0.6% | 16.730 | 28.777 | 89.734 | 28.118 | 40.786 |
| hex: silesia/samba | 524290 | 42799.7 ± 1.8% | 2562.0 ± 1.1% | 1501.5 ± 1.0% | 338.3 ± 1.6% | 1555.0 ± 2.1% | 1065.3 ± 1.2% | 16.705 | 28.505 | 126.528 | 27.524 | 40.176 |
| hex: silesia/sao | 524290 | 42947.6 ± 1.2% | 2587.4 ± 0.7% | 1503.7 ± 1.0% | 266.1 ± 8.9% | 1540.3 ± 2.7% | 1060.2 ± 0.5% | 16.599 | 28.562 | 161.383 | 27.882 | 40.511 |
| hex: silesia/webster | 524290 | 43396.2 ± 1.1% | 2587.6 ± 0.7% | 1499.7 ± 0.8% | 432.9 ± 0.6% | 1543.5 ± 6.3% | 1062.2 ± 6.6% | 16.771 | 28.937 | 100.235 | 28.116 | 40.855 |
| hex: silesia/x-ray | 524290 | 42885.4 ± 1.6% | 2576.9 ± 0.7% | 1505.5 ± 1.1% | 421.0 ± 0.9% | 1563.0 ± 0.7% | 1063.0 ± 1.1% | 16.642 | 28.485 | 101.868 | 27.439 | 40.345 |
| hex: silesia/xml | 524290 | 42660.4 ± 2.0% | 2584.0 ± 0.7% | 1498.0 ± 0.7% | 684.5 ± 0.2% | 1542.3 ± 0.9% | 1060.1 ± 0.4% | 16.510 | 28.478 | 62.322 | 27.660 | 40.242 |
| hex: canterbury/alice29.txt | 304180 | 41344.9 ± 1.2% | 2612.7 ± 0.4% | 1521.4 ± 0.9% | 468.1 ± 0.7% | 1547.6 ± 0.5% | 1086.4 ± 1.3% | 15.825 | 27.176 | 88.320 | 26.715 | 38.057 |
| hex: canterbury/asyoulik.txt | 250360 | 42944.2 ± 3.4% | 2601.4 ± 0.8% | 1535.1 ± 1.3% | 455.6 ± 1.3% | 1555.6 ± 1.3% | 1079.0 ± 1.2% | 16.508 | 27.974 | 94.259 | 27.607 | 39.802 |
| hex: canterbury/cp.html | 49208 | 42262.4 ± 1.3% | 2585.0 ± 0.5% | 1523.3 ± 0.6% | 477.7 ± 1.0% | 1579.3 ± 0.9% | 1087.7 ± 0.6% | 16.349 | 27.743 | 88.469 | 26.760 | 38.854 |
| hex: canterbury/fields.c | 22302 | 42200.4 ± 0.9% | 2643.6 ± 0.4% | 1531.3 ± 0.4% | 599.0 ± 0.6% | 1603.5 ± 0.9% | 1098.3 ± 0.4% | 15.963 | 27.558 | 70.449 | 26.317 | 38.422 |
| hex: canterbury/grammar.lsp | 7444 | 39023.3 ± 2.1% | 2676.4 ± 0.9% | 1530.8 ± 0.8% | 810.2 ± 0.9% | 1599.8 ± 0.5% | 1102.5 ± 0.5% | 14.580 | 25.492 | 48.162 | 24.393 | 35.395 |
| hex: canterbury/kennedy.xls | 524290 | 43316.0 ± 0.9% | 2573.9 ± 0.9% | 1501.2 ± 0.6% | 774.0 ± 0.6% | 1497.6 ± 0.7% | 1059.5 ± 0.8% | 16.829 | 28.853 | 55.965 | 28.924 | 40.883 |
| hex: canterbury/lcet10.txt | 524290 | 43436.7 ± 1.1% | 2601.8 ± 0.5% | 1502.9 ± 0.6% | 467.7 ± 0.3% | 1563.7 ± 1.6% | 1063.2 ± 0.5% | 16.695 | 28.903 | 92.879 | 27.778 | 40.855 |
| hex: canterbury/plrabn12.txt | 524290 | 43600.5 ± 0.5% | 2580.5 ± 0.5% | 1502.7 ± 0.8% | 453.6 ± 0.7% | 1566.2 ± 0.7% | 1069.4 ± 0.7% | 16.896 | 29.015 | 96.129 | 27.838 | 40.772 |
| hex: canterbury/ptt5 | 524290 | 43319.4 ± 8.2% | 2562.7 ± 0.4% | 1498.9 ± 0.7% | 592.8 ± 1.5% | 1556.4 ± 1.0% | 1064.8 ± 0.5% | 16.904 | 28.901 | 73.081 | 27.833 | 40.682 |
| hex: canterbury/sum | 76482 | 42822.4 ± 0.5% | 2589.8 ± 0.6% | 1515.4 ± 0.4% | 559.4 ± 0.8% | 1576.1 ± 5.5% | 1088.4 ± 1.0% | 16.535 | 28.259 | 76.546 | 27.169 | 39.345 |
| hex: canterbury/xargs.1 | 8456 | 39895.8 ± 1.8% | 2669.0 ± 0.8% | 1539.4 ± 0.4% | 837.7 ± 0.5% | 1604.0 ± 0.9% | 1107.4 ± 0.6% | 14.948 | 25.916 | 47.623 | 24.873 | 36.028 |
| hex: canterbury-large/E.coli | 524290 | 41769.0 ± 1.2% | 2580.4 ± 0.7% | 1499.7 ± 0.4% | 807.9 ± 2.8% | 1539.7 ± 1.0% | 1060.7 ± 1.6% | 16.187 | 27.851 | 51.702 | 27.128 | 39.380 |
| hex: canterbury-large/bible.txt | 524290 | 43481.7 ± 7.6% | 2583.3 ± 1.1% | 1503.0 ± 0.6% | 479.7 ± 0.7% | 1559.5 ± 0.8% | 1065.9 ± 0.7% | 16.832 | 28.930 | 90.643 | 27.881 | 40.793 |
| hex: canterbury-large/world192.txt | 524290 | 42766.9 ± 1.6% | 2591.0 ± 1.4% | 1504.5 ± 5.7% | 456.0 ± 4.0% | 1536.2 ± 1.3% | 1061.4 ± 1.0% | 16.506 | 28.426 | 93.781 | 27.839 | 40.294 |
| hex: http/html-1kx1024 | 2099200 | 21105.0 ± 4.0% | 2635.4 ± 10.7% | 1441.3 ± 0.5% | 498.8 ± 0.8% | 1562.1 ± 1.3% | 1070.0 ± 7.4% | 8.008 | 14.643 | 42.316 | 13.511 | 19.724 |
| hex: http/html-16kx64 | 2097280 | 21582.4 ± 0.2% | 2208.8 ± 0.8% | 1440.7 ± 0.9% | 501.3 ± 1.1% | 1434.0 ± 4.7% | 1073.1 ± 6.7% | 9.771 | 14.980 | 43.057 | 15.051 | 20.113 |
| hex: http/html-1m | 524290 | 42971.9 ± 1.4% | 2579.2 ± 0.5% | 1497.9 ± 0.4% | 487.4 ± 0.7% | 1559.0 ± 1.2% | 1061.0 ± 1.0% | 16.661 | 28.688 | 88.158 | 27.564 | 40.501 |
| hex: http/json-1kx1024 | 2099200 | 20431.7 ± 1.7% | 2653.4 ± 0.3% | 1438.8 ± 4.9% | 689.7 ± 0.9% | 1563.1 ± 0.8% | 1067.8 ± 1.2% | 7.700 | 14.200 | 29.625 | 13.071 | 19.134 |
| hex: http/json-16kx64 | 2097280 | 22738.6 ± 1.6% | 2200.1 ± 0.9% | 1437.3 ± 0.7% | 701.2 ± 0.5% | 1431.0 ± 0.6% | 1076.0 ± 0.4% | 10.335 | 15.820 | 32.427 | 15.890 | 21.132 |
| hex: http/json-1m | 524290 | 42765.8 ± 0.6% | 2578.7 ± 2.2% | 1506.8 ± 1.3% | 722.6 ± 1.2% | 1501.8 ± 1.5% | 1067.3 ± 1.1% | 16.584 | 28.382 | 59.180 | 28.477 | 40.071 |
| hex: http/js-1kx1024 | 2099200 | 20371.1 ± 0.3% | 2562.9 ± 1.3% | 1438.2 ± 0.9% | 486.5 ± 0.7% | 1530.8 ± 1.4% | 1073.4 ± 1.8% | 7.948 | 14.165 | 41.875 | 13.308 | 18.978 |
| hex: http/js-16kx64 | 2097280 | 21513.3 ± 0.2% | 2219.6 ± 0.9% | 1454.9 ± 1.3% | 494.2 ± 1.2% | 1445.4 ± 1.3% | 1086.3 ± 1.1% | 9.692 | 14.787 | 43.528 | 14.884 | 19.804 |
| hex: http/js-1m | 524290 | 42692.9 ± 0.3% | 2583.5 ± 10.5% | 1512.0 ± 0.7% | 500.8 ± 0.2% | 1466.9 ± 0.6% | 1068.7 ± 2.6% | 16.525 | 28.236 | 85.252 | 29.104 | 39.947 |
| hex: http/css-1kx1024 | 2099200 | 21813.3 ± 0.2% | 2658.7 ± 1.3% | 1454.7 ± 1.6% | 557.0 ± 0.6% | 1576.1 ± 1.6% | 1071.8 ± 1.2% | 8.205 | 14.995 | 39.164 | 13.840 | 20.351 |
| hex: http/css-16kx64 | 2097280 | 21429.4 ± 0.3% | 2226.5 ± 0.3% | 1455.7 ± 0.1% | 565.3 ± 0.1% | 1447.8 ± 0.1% | 1087.5 ± 0.2% | 9.625 | 14.721 | 37.907 | 14.802 | 19.705 |
| hex: http/css-1m | 524290 | 42715.7 ± 0.4% | 2592.3 ± 0.6% | 1505.5 ± 5.6% | 532.4 ± 0.8% | 1481.0 ± 0.9% | 1071.6 ± 0.3% | 16.478 | 28.374 | 80.228 | 28.842 | 39.862 |
| hex: shuffled/dickens-1m | 524290 | 41367.3 ± 0.6% | 2603.1 ± 0.2% | 1514.3 ± 0.1% | 464.2 ± 0.4% | 1562.0 ± 0.8% | 1073.2 ± 0.3% | 15.892 | 27.317 | 89.112 | 26.484 | 38.547 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1152.3 ± 0.9% | 1457.8 ± 2.5% | 1115.3 ± 0.4% | 392.3 ± 1.5% | 675.2 ± 0.8% | 365.1 ± 1.8% | 0.790 | 1.033 | 2.937 | 1.707 | 3.156 |
| qlog records, JSON text sequence | 1467503 | 1005.3 ± 0.8% | 1183.5 ± 2.6% | 1128.2 ± 0.5% | 329.0 ± 1.1% | 770.0 ± 0.4% | 318.0 ± 3.4% | 0.849 | 0.891 | 3.056 | 1.306 | 3.162 |
| messages: 11 string members | 1025025 | 959.5 ± 2.0% | 1934.9 ± 0.8% | 698.9 ± 3.1% | 337.7 ± 0.6% | 517.6 ± 0.2% | 303.1 ± 5.2% | 0.496 | 1.373 | 2.842 | 1.854 | 3.166 |
| messages: 50 nested objects | 1121600 | 1241.8 ± 0.2% | 1698.3 ± 0.6% | 1447.4 ± 0.4% | 424.2 ± 0.5% | 909.2 ± 3.4% | 421.3 ± 0.6% | 0.731 | 0.858 | 2.928 | 1.366 | 2.947 |
| messages: a tree of 341 objects | 612600 | 551.4 ± 0.6% | 844.4 ± 1.9% | 703.1 ± 5.6% | 182.1 ± 0.8% | 616.9 ± 0.7% | 209.4 ± 0.6% | 0.653 | 0.784 | 3.028 | 0.894 | 2.633 |
| string: silesia/dickens | 172528 | 6722.5 ± 0.4% | 3439.3 ± 2.1% | 2904.3 ± 2.2% | 317.6 ± 0.9% | 3097.4 ± 0.9% | 573.9 ± 2.4% | 1.955 | 2.315 | 21.168 | 2.170 | 11.713 |
| string: silesia/nci | 1075110 | 5493.1 ± 0.6% | 3936.0 ± 0.3% | 3058.6 ± 0.2% | 649.2 ± 0.6% | 3642.7 ± 4.1% | 556.6 ± 5.5% | 1.396 | 1.796 | 8.461 | 1.508 | 9.869 |
| string: silesia/reymont | 1075159 | 3503.4 ± 0.4% | 3432.1 ± 0.2% | 1940.4 ± 1.7% | 344.0 ± 0.7% | 2101.3 ± 0.4% | 488.7 ± 1.5% | 1.021 | 1.805 | 10.184 | 1.667 | 7.169 |
| string: silesia/samba | 97582 | 4007.9 ± 0.4% | 3785.1 ± 0.4% | 3055.9 ± 0.4% | 328.8 ± 0.7% | 1907.3 ± 1.0% | 419.1 ± 4.9% | 1.059 | 1.312 | 12.189 | 2.101 | 9.564 |
| string: silesia/webster | 1098490 | 4480.1 ± 1.1% | 2451.1 ± 0.3% | 1757.0 ± 0.6% | 310.2 ± 0.4% | 2087.6 ± 0.6% | 462.8 ± 2.5% | 1.828 | 2.550 | 14.444 | 2.146 | 9.680 |
| string: silesia/xml | 1090118 | 6150.9 ± 0.3% | 5047.3 ± 0.5% | 2459.2 ± 3.4% | 510.8 ± 0.7% | 3302.1 ± 0.4% | 536.0 ± 0.6% | 1.219 | 2.501 | 12.042 | 1.863 | 11.475 |
| string: canterbury/alice29.txt | 159425 | 5750.6 ± 0.9% | 2802.1 ± 1.2% | 2826.0 ± 1.4% | 300.0 ± 2.5% | 2789.8 ± 0.8% | 516.3 ± 3.1% | 2.052 | 2.035 | 19.166 | 2.061 | 11.138 |
| string: canterbury/asyoulik.txt | 132198 | 4287.8 ± 2.1% | 2636.4 ± 1.9% | 2806.0 ± 1.2% | 305.3 ± 0.7% | 2395.7 ± 4.1% | 452.0 ± 1.7% | 1.626 | 1.528 | 14.045 | 1.790 | 9.487 |
| string: canterbury/lcet10.txt | 441884 | 6655.4 ± 0.4% | 3280.8 ± 0.7% | 2354.6 ± 0.4% | 346.1 ± 0.4% | 2806.8 ± 0.7% | 572.3 ± 1.0% | 2.029 | 2.827 | 19.228 | 2.371 | 11.629 |
| string: canterbury/plrabn12.txt | 503330 | 5088.9 ± 0.1% | 3173.3 ± 0.8% | 1833.7 ± 2.0% | 323.2 ± 0.4% | 2804.7 ± 0.5% | 533.1 ± 1.8% | 1.604 | 2.775 | 15.745 | 1.814 | 9.546 |
| string: canterbury-large/E.coli | 1048578 | 34070.1 ± 0.2% | 13639.2 ± 0.6% | 3456.3 ± 0.3% | 1284.5 ± 0.2% | 8951.4 ± 0.2% | 909.7 ± 3.2% | 2.498 | 9.857 | 26.524 | 3.806 | 37.451 |
| string: canterbury-large/bible.txt | 1055886 | 8599.4 ± 1.0% | 5322.5 ± 0.5% | 2810.6 ± 0.3% | 357.7 ± 0.4% | 3897.2 ± 0.5% | 630.0 ± 2.8% | 1.616 | 3.060 | 24.038 | 2.207 | 13.649 |
| string: canterbury-large/world192.txt | 1103121 | 4151.7 ± 0.5% | 2322.0 ± 0.3% | 1779.6 ± 0.2% | 327.5 ± 0.6% | 2131.3 ± 0.3% | 463.7 ± 1.7% | 1.788 | 2.333 | 12.677 | 1.948 | 8.953 |
| string: http/html-1m | 1058582 | 8829.0 ± 4.0% | 4786.2 ± 1.5% | 2725.8 ± 1.6% | 427.1 ± 0.2% | 3659.6 ± 3.7% | 596.5 ± 2.5% | 1.845 | 3.239 | 20.670 | 2.413 | 14.801 |
| string: http/json-1m | 1190272 | 3358.8 ± 1.0% | 1260.3 ± 0.7% | 2092.5 ± 0.3% | 480.1 ± 0.7% | 1344.0 ± 0.8% | 437.2 ± 0.4% | 2.665 | 1.605 | 6.996 | 2.499 | 7.683 |
| string: http/js-1m | 1144362 | 2877.2 ± 0.4% | 1618.4 ± 1.2% | 1335.7 ± 0.5% | 325.8 ± 0.7% | 1424.7 ± 0.5% | 379.5 ± 1.4% | 1.778 | 2.154 | 8.833 | 2.020 | 7.581 |
| string: http/css-1m | 1097820 | 3311.9 ± 0.6% | 2912.1 ± 0.2% | 2290.7 ± 0.7% | 453.6 ± 0.3% | 2069.8 ± 0.4% | 436.6 ± 0.9% | 1.137 | 1.446 | 7.301 | 1.600 | 7.585 |
| string: dickens as Cyrillic and CJK | 1883069 | 5873.1 ± 1.5% | 3001.0 ± 2.9% | 668.6 ± 0.8% | 375.2 ± 2.4% | 513.2 ± 0.4% | 163.8 ± 2.9% | 1.957 | 8.784 | 15.655 | 11.444 | 35.866 |
| string: dickens as Cyrillic and CJK, as \u escapes | 5075485 | 1205.1 ± 1.6% | 1254.9 ± 0.4% | 1103.7 ± 1.0% | 264.7 ± 0.6% | 479.9 ± 0.5% | 229.1 ± 3.6% | 0.960 | 1.092 | 4.553 | 2.511 | 5.260 |
| hex: silesia/dickens | 524290 | 34026.3 ± 1.1% | 15041.7 ± 0.6% | 3562.1 ± 0.6% | 478.3 ± 0.7% | 8940.1 ± 0.3% | 1126.3 ± 4.0% | 2.262 | 9.552 | 71.142 | 3.806 | 30.212 |
| hex: silesia/mozilla | 524290 | 34035.0 ± 0.1% | 15054.0 ± 3.0% | 3504.5 ± 1.1% | 431.1 ± 0.5% | 8919.3 ± 5.1% | 1134.3 ± 0.5% | 2.261 | 9.712 | 78.949 | 3.816 | 30.004 |
| hex: silesia/mr | 524290 | 34028.3 ± 0.1% | 15033.7 ± 0.3% | 3501.2 ± 0.3% | 648.1 ± 0.4% | 8945.2 ± 0.7% | 1129.3 ± 1.7% | 2.263 | 9.719 | 52.506 | 3.804 | 30.133 |
| hex: silesia/nci | 524290 | 34014.3 ± 0.1% | 15066.0 ± 0.2% | 3573.6 ± 0.7% | 804.0 ± 2.6% | 8929.6 ± 0.5% | 1132.5 ± 1.5% | 2.258 | 9.518 | 42.307 | 3.809 | 30.034 |
| hex: silesia/ooffice | 524290 | 33825.3 ± 0.8% | 14961.3 ± 0.9% | 3471.6 ± 0.5% | 341.9 ± 0.8% | 8830.8 ± 1.5% | 1127.6 ± 0.4% | 2.261 | 9.743 | 98.934 | 3.830 | 29.999 |
| hex: silesia/osdb | 524290 | 33763.4 ± 2.1% | 15020.6 ± 3.5% | 3499.4 ± 0.8% | 457.6 ± 0.7% | 8876.2 ± 1.1% | 1131.6 ± 1.6% | 2.248 | 9.648 | 73.790 | 3.804 | 29.836 |
| hex: silesia/reymont | 524290 | 33981.4 ± 0.6% | 15050.4 ± 0.3% | 3571.4 ± 0.4% | 500.0 ± 0.9% | 8954.1 ± 0.8% | 1130.1 ± 1.5% | 2.258 | 9.515 | 67.961 | 3.795 | 30.069 |
| hex: silesia/samba | 524290 | 34044.8 ± 0.1% | 15026.7 ± 3.4% | 3509.1 ± 0.1% | 369.4 ± 0.1% | 8946.3 ± 0.1% | 1129.5 ± 1.2% | 2.266 | 9.702 | 92.166 | 3.805 | 30.141 |
| hex: silesia/sao | 524290 | 33998.0 ± 0.4% | 15000.7 ± 0.4% | 3501.2 ± 0.7% | 280.8 ± 0.8% | 8897.0 ± 0.7% | 1131.4 ± 1.4% | 2.266 | 9.710 | 121.055 | 3.821 | 30.050 |
| hex: silesia/webster | 524290 | 34021.8 ± 1.3% | 14955.0 ± 1.1% | 3565.0 ± 4.5% | 452.5 ± 1.3% | 8917.2 ± 1.4% | 1128.7 ± 2.2% | 2.275 | 9.543 | 75.179 | 3.815 | 30.143 |
| hex: silesia/x-ray | 524290 | 33703.6 ± 1.0% | 14904.5 ± 0.5% | 3486.7 ± 0.6% | 423.0 ± 1.2% | 8861.4 ± 0.8% | 1129.9 ± 1.2% | 2.261 | 9.666 | 79.682 | 3.803 | 29.828 |
| hex: silesia/xml | 524290 | 33725.2 ± 0.7% | 14921.0 ± 0.9% | 3536.1 ± 0.4% | 727.5 ± 2.2% | 8870.2 ± 1.4% | 1127.5 ± 1.0% | 2.260 | 9.537 | 46.360 | 3.802 | 29.912 |
| hex: canterbury/alice29.txt | 304180 | 33557.4 ± 0.6% | 14066.8 ± 0.9% | 3542.1 ± 0.6% | 480.0 ± 0.6% | 8876.8 ± 1.3% | 1131.0 ± 2.3% | 2.386 | 9.474 | 69.908 | 3.780 | 29.672 |
| hex: canterbury/asyoulik.txt | 250360 | 33637.3 ± 0.4% | 14848.1 ± 0.3% | 3474.4 ± 0.4% | 467.1 ± 0.4% | 8832.0 ± 0.4% | 1134.5 ± 0.7% | 2.265 | 9.682 | 72.016 | 3.809 | 29.650 |
| hex: canterbury/cp.html | 49208 | 33454.1 ± 0.4% | 14403.1 ± 0.5% | 3573.8 ± 1.1% | 507.9 ± 1.1% | 9230.2 ± 0.6% | 1122.4 ± 1.3% | 2.323 | 9.361 | 65.872 | 3.624 | 29.807 |
| hex: canterbury/fields.c | 22302 | 32852.9 ± 0.7% | 17373.7 ± 0.7% | 3649.6 ± 0.7% | 566.2 ± 0.7% | 9183.0 ± 0.5% | 1089.5 ± 2.6% | 1.891 | 9.002 | 58.019 | 3.578 | 30.155 |
| hex: canterbury/grammar.lsp | 7444 | 29794.8 ± 0.5% | 17174.5 ± 0.5% | 3609.9 ± 0.7% | 738.1 ± 0.9% | 8901.0 ± 6.4% | 1052.1 ± 3.0% | 1.735 | 8.254 | 40.368 | 3.347 | 28.319 |
| hex: canterbury/kennedy.xls | 524290 | 33713.9 ± 0.4% | 14956.5 ± 0.5% | 3544.0 ± 0.7% | 753.9 ± 1.9% | 8852.8 ± 0.7% | 1108.8 ± 2.4% | 2.254 | 9.513 | 44.717 | 3.808 | 30.406 |
| hex: canterbury/lcet10.txt | 524290 | 33839.8 ± 1.1% | 14990.9 ± 0.7% | 3516.8 ± 1.0% | 479.4 ± 2.7% | 8868.5 ± 1.4% | 1122.0 ± 2.2% | 2.257 | 9.622 | 70.583 | 3.816 | 30.160 |
| hex: canterbury/plrabn12.txt | 524290 | 33630.7 ± 4.5% | 14945.0 ± 0.7% | 3532.2 ± 0.7% | 462.2 ± 1.4% | 8841.0 ± 1.6% | 1108.4 ± 1.5% | 2.250 | 9.521 | 72.757 | 3.804 | 30.341 |
| hex: canterbury/ptt5 | 524290 | 33746.0 ± 0.8% | 14993.4 ± 0.4% | 3471.3 ± 0.7% | 660.5 ± 0.7% | 8839.9 ± 0.8% | 1120.5 ± 1.8% | 2.251 | 9.721 | 51.089 | 3.817 | 30.116 |
| hex: canterbury/sum | 76482 | 33358.4 ± 0.6% | 15266.1 ± 1.2% | 3560.7 ± 1.1% | 585.5 ± 0.9% | 8917.1 ± 0.9% | 1114.7 ± 2.3% | 2.185 | 9.369 | 56.971 | 3.741 | 29.926 |
| hex: canterbury/xargs.1 | 8456 | 30304.3 ± 1.0% | 17213.6 ± 0.8% | 3539.4 ± 0.8% | 720.6 ± 0.9% | 8916.1 ± 0.9% | 1078.5 ± 4.1% | 1.760 | 8.562 | 42.051 | 3.399 | 28.098 |
| hex: canterbury-large/E.coli | 524290 | 33685.8 ± 0.8% | 14937.9 ± 0.7% | 3470.3 ± 3.4% | 956.0 ± 0.3% | 8811.3 ± 2.5% | 1095.6 ± 6.8% | 2.255 | 9.707 | 35.236 | 3.823 | 30.747 |
| hex: canterbury-large/bible.txt | 524290 | 33757.6 ± 0.8% | 14929.6 ± 0.9% | 3479.4 ± 1.3% | 495.2 ± 1.8% | 8846.1 ± 1.3% | 1099.1 ± 1.2% | 2.261 | 9.702 | 68.166 | 3.816 | 30.713 |
| hex: canterbury-large/world192.txt | 524290 | 33788.9 ± 0.6% | 14964.4 ± 0.7% | 3541.4 ± 0.6% | 463.5 ± 0.7% | 8887.0 ± 1.1% | 1103.9 ± 3.4% | 2.258 | 9.541 | 72.901 | 3.802 | 30.608 |
| hex: http/html-1kx1024 | 2099200 | 15482.1 ± 0.6% | 12121.5 ± 6.3% | 3186.4 ± 0.8% | 502.5 ± 0.7% | 7552.3 ± 1.2% | 962.6 ± 2.2% | 1.277 | 4.859 | 30.811 | 2.050 | 16.084 |
| hex: http/html-16kx64 | 2097280 | 28396.8 ± 0.6% | 13926.5 ± 0.5% | 3412.8 ± 0.9% | 511.8 ± 3.8% | 8652.8 ± 9.1% | 1067.9 ± 3.2% | 2.039 | 8.321 | 55.488 | 3.282 | 26.591 |
| hex: http/html-1m | 524290 | 33733.0 ± 0.3% | 14947.0 ± 0.8% | 3470.4 ± 1.3% | 503.5 ± 0.9% | 8867.4 ± 1.3% | 1117.6 ± 0.9% | 2.257 | 9.720 | 66.993 | 3.804 | 30.183 |
| hex: http/json-1kx1024 | 2099200 | 15112.5 ± 1.1% | 12097.0 ± 10.2% | 3172.8 ± 0.9% | 668.8 ± 0.8% | 7615.0 ± 1.4% | 959.8 ± 2.9% | 1.249 | 4.763 | 22.598 | 1.985 | 15.745 |
| hex: http/json-16kx64 | 2097280 | 27514.6 ± 0.3% | 13941.0 ± 0.5% | 3390.6 ± 0.4% | 678.8 ± 0.9% | 8524.8 ± 1.0% | 1042.5 ± 4.0% | 1.974 | 8.115 | 40.536 | 3.228 | 26.394 |
| hex: http/json-1m | 524290 | 33638.4 ± 0.6% | 14945.0 ± 0.6% | 3529.5 ± 3.3% | 693.6 ± 0.7% | 8874.9 ± 0.5% | 1109.4 ± 0.8% | 2.251 | 9.531 | 48.497 | 3.790 | 30.321 |
| hex: http/js-1kx1024 | 2099200 | 15509.3 ± 0.6% | 12484.4 ± 5.7% | 3190.0 ± 0.3% | 486.3 ± 0.4% | 7609.8 ± 0.7% | 945.8 ± 2.7% | 1.242 | 4.862 | 31.895 | 2.038 | 16.398 |
| hex: http/js-16kx64 | 2097280 | 27434.0 ± 0.1% | 13894.9 ± 0.4% | 3372.1 ± 0.7% | 491.7 ± 0.7% | 8424.2 ± 0.6% | 1051.6 ± 8.0% | 1.974 | 8.136 | 55.792 | 3.257 | 26.087 |
| hex: http/js-1m | 524290 | 33713.4 ± 0.5% | 14947.9 ± 1.2% | 3509.6 ± 0.5% | 511.5 ± 0.9% | 8874.6 ± 0.8% | 1077.5 ± 2.3% | 2.255 | 9.606 | 65.908 | 3.799 | 31.288 |
| hex: http/css-1kx1024 | 2099200 | 15325.4 ± 1.4% | 12384.0 ± 0.9% | 3180.4 ± 0.7% | 567.9 ± 0.8% | 7566.2 ± 1.2% | 939.8 ± 1.7% | 1.238 | 4.819 | 26.985 | 2.026 | 16.307 |
| hex: http/css-16kx64 | 2097280 | 27947.3 ± 0.3% | 13818.2 ± 0.4% | 3377.3 ± 0.2% | 575.8 ± 0.8% | 8613.1 ± 0.8% | 1048.0 ± 1.9% | 2.023 | 8.275 | 48.533 | 3.245 | 26.669 |
| hex: http/css-1m | 524290 | 33703.2 ± 0.5% | 14952.7 ± 0.7% | 3544.6 ± 0.6% | 556.2 ± 0.7% | 8892.0 ± 0.7% | 1087.3 ± 3.4% | 2.254 | 9.508 | 60.590 | 3.790 | 30.998 |
| hex: shuffled/dickens-1m | 524290 | 33770.2 ± 1.3% | 14920.7 ± 0.6% | 3473.8 ± 1.3% | 476.3 ± 1.1% | 8846.2 ± 1.3% | 1074.9 ± 1.9% | 2.263 | 9.721 | 70.906 | 3.817 | 31.417 |

## TextReader.next_items against the baselines

stdx's decoder a slice of tokens a call through `TextReader.next_items`, as a caller that reads a text's values in a loop calls it (decision 79). Octets are the text's. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1286.8 ± 0.5% | 1457.8 ± 2.5% | 1115.3 ± 0.4% | 392.3 ± 1.5% | 675.2 ± 0.8% | 365.1 ± 1.8% | 0.883 | 1.154 | 3.280 | 1.906 | 3.525 |
| qlog records, JSON text sequence | 1467503 | 1150.3 ± 0.5% | 1183.5 ± 2.6% | 1128.2 ± 0.5% | 329.0 ± 1.1% | 770.0 ± 0.4% | 318.0 ± 3.4% | 0.972 | 1.020 | 3.496 | 1.494 | 3.618 |
| messages: 11 string members | 1025025 | 1041.5 ± 1.8% | 1934.9 ± 0.8% | 698.9 ± 3.1% | 337.7 ± 0.6% | 517.6 ± 0.2% | 303.1 ± 5.2% | 0.538 | 1.490 | 3.085 | 2.012 | 3.436 |
| messages: 50 nested objects | 1121600 | 1301.9 ± 0.3% | 1698.3 ± 0.6% | 1447.4 ± 0.4% | 424.2 ± 0.5% | 909.2 ± 3.4% | 421.3 ± 0.6% | 0.767 | 0.899 | 3.069 | 1.432 | 3.090 |
| messages: a tree of 341 objects | 612600 | 653.0 ± 0.2% | 844.4 ± 1.9% | 703.1 ± 5.6% | 182.1 ± 0.8% | 616.9 ± 0.7% | 209.4 ± 0.6% | 0.773 | 0.929 | 3.586 | 1.059 | 3.118 |
| string: silesia/dickens | 172528 | 6744.4 ± 0.2% | 3439.3 ± 2.1% | 2904.3 ± 2.2% | 317.6 ± 0.9% | 3097.4 ± 0.9% | 573.9 ± 2.4% | 1.961 | 2.322 | 21.237 | 2.177 | 11.751 |
| string: silesia/nci | 1075110 | 5500.9 ± 2.0% | 3936.0 ± 0.3% | 3058.6 ± 0.2% | 649.2 ± 0.6% | 3642.7 ± 4.1% | 556.6 ± 5.5% | 1.398 | 1.799 | 8.473 | 1.510 | 9.883 |
| string: silesia/reymont | 1075159 | 3546.7 ± 2.0% | 3432.1 ± 0.2% | 1940.4 ± 1.7% | 344.0 ± 0.7% | 2101.3 ± 0.4% | 488.7 ± 1.5% | 1.033 | 1.828 | 10.309 | 1.688 | 7.258 |
| string: silesia/samba | 97582 | 4008.0 ± 0.3% | 3785.1 ± 0.4% | 3055.9 ± 0.4% | 328.8 ± 0.7% | 1907.3 ± 1.0% | 419.1 ± 4.9% | 1.059 | 1.312 | 12.189 | 2.101 | 9.564 |
| string: silesia/webster | 1098490 | 4502.1 ± 0.6% | 2451.1 ± 0.3% | 1757.0 ± 0.6% | 310.2 ± 0.4% | 2087.6 ± 0.6% | 462.8 ± 2.5% | 1.837 | 2.562 | 14.515 | 2.157 | 9.728 |
| string: silesia/xml | 1090118 | 6182.6 ± 0.4% | 5047.3 ± 0.5% | 2459.2 ± 3.4% | 510.8 ± 0.7% | 3302.1 ± 0.4% | 536.0 ± 0.6% | 1.225 | 2.514 | 12.104 | 1.872 | 11.534 |
| string: canterbury/alice29.txt | 159425 | 5770.8 ± 0.3% | 2802.1 ± 1.2% | 2826.0 ± 1.4% | 300.0 ± 2.5% | 2789.8 ± 0.8% | 516.3 ± 3.1% | 2.059 | 2.042 | 19.234 | 2.069 | 11.177 |
| string: canterbury/asyoulik.txt | 132198 | 4291.7 ± 2.2% | 2636.4 ± 1.9% | 2806.0 ± 1.2% | 305.3 ± 0.7% | 2395.7 ± 4.1% | 452.0 ± 1.7% | 1.628 | 1.529 | 14.057 | 1.791 | 9.496 |
| string: canterbury/lcet10.txt | 441884 | 6671.9 ± 0.5% | 3280.8 ± 0.7% | 2354.6 ± 0.4% | 346.1 ± 0.4% | 2806.8 ± 0.7% | 572.3 ± 1.0% | 2.034 | 2.834 | 19.276 | 2.377 | 11.658 |
| string: canterbury/plrabn12.txt | 503330 | 5090.4 ± 0.3% | 3173.3 ± 0.8% | 1833.7 ± 2.0% | 323.2 ± 0.4% | 2804.7 ± 0.5% | 533.1 ± 1.8% | 1.604 | 2.776 | 15.750 | 1.815 | 9.548 |
| string: canterbury-large/E.coli | 1048578 | 34139.3 ± 0.1% | 13639.2 ± 0.6% | 3456.3 ± 0.3% | 1284.5 ± 0.2% | 8951.4 ± 0.2% | 909.7 ± 3.2% | 2.503 | 9.877 | 26.578 | 3.814 | 37.527 |
| string: canterbury-large/bible.txt | 1055886 | 8653.1 ± 0.6% | 5322.5 ± 0.5% | 2810.6 ± 0.3% | 357.7 ± 0.4% | 3897.2 ± 0.5% | 630.0 ± 2.8% | 1.626 | 3.079 | 24.188 | 2.220 | 13.734 |
| string: canterbury-large/world192.txt | 1103121 | 4158.4 ± 0.2% | 2322.0 ± 0.3% | 1779.6 ± 0.2% | 327.5 ± 0.6% | 2131.3 ± 0.3% | 463.7 ± 1.7% | 1.791 | 2.337 | 12.697 | 1.951 | 8.967 |
| string: http/html-1m | 1058582 | 9657.5 ± 3.4% | 4786.2 ± 1.5% | 2725.8 ± 1.6% | 427.1 ± 0.2% | 3659.6 ± 3.7% | 596.5 ± 2.5% | 2.018 | 3.543 | 22.609 | 2.639 | 16.190 |
| string: http/json-1m | 1190272 | 3358.9 ± 0.7% | 1260.3 ± 0.7% | 2092.5 ± 0.3% | 480.1 ± 0.7% | 1344.0 ± 0.8% | 437.2 ± 0.4% | 2.665 | 1.605 | 6.996 | 2.499 | 7.683 |
| string: http/js-1m | 1144362 | 2881.3 ± 0.5% | 1618.4 ± 1.2% | 1335.7 ± 0.5% | 325.8 ± 0.7% | 1424.7 ± 0.5% | 379.5 ± 1.4% | 1.780 | 2.157 | 8.845 | 2.022 | 7.592 |
| string: http/css-1m | 1097820 | 3330.1 ± 0.2% | 2912.1 ± 0.2% | 2290.7 ± 0.7% | 453.6 ± 0.3% | 2069.8 ± 0.4% | 436.6 ± 0.9% | 1.144 | 1.454 | 7.341 | 1.609 | 7.627 |
| string: dickens as Cyrillic and CJK | 1883069 | 5877.9 ± 0.3% | 3001.0 ± 2.9% | 668.6 ± 0.8% | 375.2 ± 2.4% | 513.2 ± 0.4% | 163.8 ± 2.9% | 1.959 | 8.792 | 15.668 | 11.453 | 35.895 |
| string: dickens as Cyrillic and CJK, as \u escapes | 5075485 | 1220.1 ± 0.2% | 1254.9 ± 0.4% | 1103.7 ± 1.0% | 264.7 ± 0.6% | 479.9 ± 0.5% | 229.1 ± 3.6% | 0.972 | 1.105 | 4.610 | 2.542 | 5.326 |
| hex: silesia/dickens | 524290 | 34013.1 ± 0.3% | 15041.7 ± 0.6% | 3562.1 ± 0.6% | 478.3 ± 0.7% | 8940.1 ± 0.3% | 1126.3 ± 4.0% | 2.261 | 9.549 | 71.115 | 3.805 | 30.200 |
| hex: silesia/mozilla | 524290 | 33997.7 ± 1.7% | 15054.0 ± 3.0% | 3504.5 ± 1.1% | 431.1 ± 0.5% | 8919.3 ± 5.1% | 1134.3 ± 0.5% | 2.258 | 9.701 | 78.863 | 3.812 | 29.972 |
| hex: silesia/mr | 524290 | 34006.9 ± 0.2% | 15033.7 ± 0.3% | 3501.2 ± 0.3% | 648.1 ± 0.4% | 8945.2 ± 0.7% | 1129.3 ± 1.7% | 2.262 | 9.713 | 52.473 | 3.802 | 30.114 |
| hex: silesia/nci | 524290 | 34018.0 ± 0.3% | 15066.0 ± 0.2% | 3573.6 ± 0.7% | 804.0 ± 2.6% | 8929.6 ± 0.5% | 1132.5 ± 1.5% | 2.258 | 9.519 | 42.311 | 3.810 | 30.037 |
| hex: silesia/ooffice | 524290 | 33857.5 ± 0.3% | 14961.3 ± 0.9% | 3471.6 ± 0.5% | 341.9 ± 0.8% | 8830.8 ± 1.5% | 1127.6 ± 0.4% | 2.263 | 9.753 | 99.028 | 3.834 | 30.027 |
| hex: silesia/osdb | 524290 | 34006.0 ± 0.7% | 15020.6 ± 3.5% | 3499.4 ± 0.8% | 457.6 ± 0.7% | 8876.2 ± 1.1% | 1131.6 ± 1.6% | 2.264 | 9.718 | 74.320 | 3.831 | 30.050 |
| hex: silesia/reymont | 524290 | 34015.1 ± 0.3% | 15050.4 ± 0.3% | 3571.4 ± 0.4% | 500.0 ± 0.9% | 8954.1 ± 0.8% | 1130.1 ± 1.5% | 2.260 | 9.524 | 68.029 | 3.799 | 30.099 |
| hex: silesia/samba | 524290 | 34013.7 ± 4.8% | 15026.7 ± 3.4% | 3509.1 ± 0.1% | 369.4 ± 0.1% | 8946.3 ± 0.1% | 1129.5 ± 1.2% | 2.264 | 9.693 | 92.081 | 3.802 | 30.113 |
| hex: silesia/sao | 524290 | 33860.0 ± 1.0% | 15000.7 ± 0.4% | 3501.2 ± 0.7% | 280.8 ± 0.8% | 8897.0 ± 0.7% | 1131.4 ± 1.4% | 2.257 | 9.671 | 120.564 | 3.806 | 29.928 |
| hex: silesia/webster | 524290 | 33862.0 ± 1.4% | 14955.0 ± 1.1% | 3565.0 ± 4.5% | 452.5 ± 1.3% | 8917.2 ± 1.4% | 1128.7 ± 2.2% | 2.264 | 9.498 | 74.826 | 3.797 | 30.001 |
| hex: silesia/x-ray | 524290 | 33727.5 ± 0.8% | 14904.5 ± 0.5% | 3486.7 ± 0.6% | 423.0 ± 1.2% | 8861.4 ± 0.8% | 1129.9 ± 1.2% | 2.263 | 9.673 | 79.739 | 3.806 | 29.849 |
| hex: silesia/xml | 524290 | 33771.7 ± 1.1% | 14921.0 ± 0.9% | 3536.1 ± 0.4% | 727.5 ± 2.2% | 8870.2 ± 1.4% | 1127.5 ± 1.0% | 2.263 | 9.551 | 46.424 | 3.807 | 29.954 |
| hex: canterbury/alice29.txt | 304180 | 33620.9 ± 0.4% | 14066.8 ± 0.9% | 3542.1 ± 0.6% | 480.0 ± 0.6% | 8876.8 ± 1.3% | 1131.0 ± 2.3% | 2.390 | 9.492 | 70.041 | 3.788 | 29.728 |
| hex: canterbury/asyoulik.txt | 250360 | 33636.7 ± 0.8% | 14848.1 ± 0.3% | 3474.4 ± 0.4% | 467.1 ± 0.4% | 8832.0 ± 0.4% | 1134.5 ± 0.7% | 2.265 | 9.681 | 72.015 | 3.808 | 29.649 |
| hex: canterbury/cp.html | 49208 | 33382.2 ± 0.4% | 14403.1 ± 0.5% | 3573.8 ± 1.1% | 507.9 ± 1.1% | 9230.2 ± 0.6% | 1122.4 ± 1.3% | 2.318 | 9.341 | 65.730 | 3.617 | 29.743 |
| hex: canterbury/fields.c | 22302 | 32791.8 ± 0.8% | 17373.7 ± 0.7% | 3649.6 ± 0.7% | 566.2 ± 0.7% | 9183.0 ± 0.5% | 1089.5 ± 2.6% | 1.887 | 8.985 | 57.911 | 3.571 | 30.099 |
| hex: canterbury/grammar.lsp | 7444 | 29614.3 ± 0.5% | 17174.5 ± 0.5% | 3609.9 ± 0.7% | 738.1 ± 0.9% | 8901.0 ± 6.4% | 1052.1 ± 3.0% | 1.724 | 8.204 | 40.123 | 3.327 | 28.147 |
| hex: canterbury/kennedy.xls | 524290 | 33639.4 ± 0.8% | 14956.5 ± 0.5% | 3544.0 ± 0.7% | 753.9 ± 1.9% | 8852.8 ± 0.7% | 1108.8 ± 2.4% | 2.249 | 9.492 | 44.618 | 3.800 | 30.339 |
| hex: canterbury/lcet10.txt | 524290 | 33738.4 ± 0.5% | 14990.9 ± 0.7% | 3516.8 ± 1.0% | 479.4 ± 2.7% | 8868.5 ± 1.4% | 1122.0 ± 2.2% | 2.251 | 9.594 | 70.372 | 3.804 | 30.069 |
| hex: canterbury/plrabn12.txt | 524290 | 33699.9 ± 1.0% | 14945.0 ± 0.7% | 3532.2 ± 0.7% | 462.2 ± 1.4% | 8841.0 ± 1.6% | 1108.4 ± 1.5% | 2.255 | 9.541 | 72.907 | 3.812 | 30.403 |
| hex: canterbury/ptt5 | 524290 | 33704.7 ± 0.6% | 14993.4 ± 0.4% | 3471.3 ± 0.7% | 660.5 ± 0.7% | 8839.9 ± 0.8% | 1120.5 ± 1.8% | 2.248 | 9.710 | 51.026 | 3.813 | 30.079 |
| hex: canterbury/sum | 76482 | 33393.2 ± 0.7% | 15266.1 ± 1.2% | 3560.7 ± 1.1% | 585.5 ± 0.9% | 8917.1 ± 0.9% | 1114.7 ± 2.3% | 2.187 | 9.378 | 57.030 | 3.745 | 29.957 |
| hex: canterbury/xargs.1 | 8456 | 30102.8 ± 1.0% | 17213.6 ± 0.8% | 3539.4 ± 0.8% | 720.6 ± 0.9% | 8916.1 ± 0.9% | 1078.5 ± 4.1% | 1.749 | 8.505 | 41.772 | 3.376 | 27.911 |
| hex: canterbury-large/E.coli | 524290 | 33669.2 ± 4.4% | 14937.9 ± 0.7% | 3470.3 ± 3.4% | 956.0 ± 0.3% | 8811.3 ± 2.5% | 1095.6 ± 6.8% | 2.254 | 9.702 | 35.219 | 3.821 | 30.732 |
| hex: canterbury-large/bible.txt | 524290 | 33752.4 ± 0.9% | 14929.6 ± 0.9% | 3479.4 ± 1.3% | 495.2 ± 1.8% | 8846.1 ± 1.3% | 1099.1 ± 1.2% | 2.261 | 9.701 | 68.155 | 3.816 | 30.708 |
| hex: canterbury-large/world192.txt | 524290 | 33694.0 ± 0.4% | 14964.4 ± 0.7% | 3541.4 ± 0.6% | 463.5 ± 0.7% | 8887.0 ± 1.1% | 1103.9 ± 3.4% | 2.252 | 9.514 | 72.696 | 3.791 | 30.522 |
| hex: http/html-1kx1024 | 2099200 | 15037.6 ± 1.1% | 12121.5 ± 6.3% | 3186.4 ± 0.8% | 502.5 ± 0.7% | 7552.3 ± 1.2% | 962.6 ± 2.2% | 1.241 | 4.719 | 29.927 | 1.991 | 15.622 |
| hex: http/html-16kx64 | 2097280 | 28287.6 ± 0.4% | 13926.5 ± 0.5% | 3412.8 ± 0.9% | 511.8 ± 3.8% | 8652.8 ± 9.1% | 1067.9 ± 3.2% | 2.031 | 8.289 | 55.275 | 3.269 | 26.489 |
| hex: http/html-1m | 524290 | 33712.9 ± 0.2% | 14947.0 ± 0.8% | 3470.4 ± 1.3% | 503.5 ± 0.9% | 8867.4 ± 1.3% | 1117.6 ± 0.9% | 2.255 | 9.714 | 66.953 | 3.802 | 30.165 |
| hex: http/json-1kx1024 | 2099200 | 14762.0 ± 1.4% | 12097.0 ± 10.2% | 3172.8 ± 0.9% | 668.8 ± 0.8% | 7615.0 ± 1.4% | 959.8 ± 2.9% | 1.220 | 4.653 | 22.073 | 1.939 | 15.380 |
| hex: http/json-16kx64 | 2097280 | 27455.9 ± 0.2% | 13941.0 ± 0.5% | 3390.6 ± 0.4% | 678.8 ± 0.9% | 8524.8 ± 1.0% | 1042.5 ± 4.0% | 1.969 | 8.098 | 40.449 | 3.221 | 26.337 |
| hex: http/json-1m | 524290 | 33663.9 ± 1.1% | 14945.0 ± 0.6% | 3529.5 ± 3.3% | 693.6 ± 0.7% | 8874.9 ± 0.5% | 1109.4 ± 0.8% | 2.253 | 9.538 | 48.533 | 3.793 | 30.344 |
| hex: http/js-1kx1024 | 2099200 | 15138.7 ± 0.6% | 12484.4 ± 5.7% | 3190.0 ± 0.3% | 486.3 ± 0.4% | 7609.8 ± 0.7% | 945.8 ± 2.7% | 1.213 | 4.746 | 31.132 | 1.989 | 16.007 |
| hex: http/js-16kx64 | 2097280 | 27476.3 ± 0.5% | 13894.9 ± 0.4% | 3372.1 ± 0.7% | 491.7 ± 0.7% | 8424.2 ± 0.6% | 1051.6 ± 8.0% | 1.977 | 8.148 | 55.878 | 3.262 | 26.127 |
| hex: http/js-1m | 524290 | 33730.0 ± 0.7% | 14947.9 ± 1.2% | 3509.6 ± 0.5% | 511.5 ± 0.9% | 8874.6 ± 0.8% | 1077.5 ± 2.3% | 2.257 | 9.611 | 65.940 | 3.801 | 31.303 |
| hex: http/css-1kx1024 | 2099200 | 14897.5 ± 0.5% | 12384.0 ± 0.9% | 3180.4 ± 0.7% | 567.9 ± 0.8% | 7566.2 ± 1.2% | 939.8 ± 1.7% | 1.203 | 4.684 | 26.232 | 1.969 | 15.851 |
| hex: http/css-16kx64 | 2097280 | 27858.1 ± 0.3% | 13818.2 ± 0.4% | 3377.3 ± 0.2% | 575.8 ± 0.8% | 8613.1 ± 0.8% | 1048.0 ± 1.9% | 2.016 | 8.249 | 48.379 | 3.234 | 26.583 |
| hex: http/css-1m | 524290 | 33749.5 ± 0.3% | 14952.7 ± 0.7% | 3544.6 ± 0.6% | 556.2 ± 0.7% | 8892.0 ± 0.7% | 1087.3 ± 3.4% | 2.257 | 9.521 | 60.673 | 3.795 | 31.041 |
| hex: shuffled/dickens-1m | 524290 | 33731.0 ± 1.0% | 14920.7 ± 0.6% | 3473.8 ± 1.3% | 476.3 ± 1.1% | 8846.2 ± 1.3% | 1074.9 ± 1.9% | 2.261 | 9.710 | 70.824 | 3.813 | 31.381 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1501.4 ± 0.4% | 1472.5 ± 1.2% | 1038.0 ± 1.2% | 463.2 ± 3.5% | 436.8 ± 3.1% | 501.4 ± 1.1% | 1.020 | 1.446 | 3.241 | 3.437 | 2.995 |
| qlog records, JSON text sequence | 1467503 | 1370.6 ± 0.9% | 1219.8 ± 1.7% | 949.8 ± 4.0% | 437.6 ± 1.0% | 537.8 ± 1.0% | 352.3 ± 0.7% | 1.124 | 1.443 | 3.132 | 2.549 | 3.890 |
| messages: 11 string members | 1025025 | 1252.2 ± 0.6% | 1105.8 ± 1.2% | 772.7 ± 1.1% | 412.4 ± 1.1% | 416.7 ± 1.3% | 434.9 ± 1.3% | 1.132 | 1.621 | 3.037 | 3.005 | 2.879 |
| messages: 50 nested objects | 1121600 | 1647.9 ± 1.3% | 1868.4 ± 1.1% | 1349.4 ± 1.0% | 593.6 ± 1.0% | 608.1 ± 1.4% | 522.2 ± 1.2% | 0.882 | 1.221 | 2.776 | 2.710 | 3.156 |
| messages: a tree of 341 objects | 612600 | 537.6 ± 2.7% | 680.1 ± 2.3% | 581.1 ± 0.3% | 336.7 ± 1.6% | 351.4 ± 0.8% | 219.1 ± 1.1% | 0.790 | 0.925 | 1.597 | 1.530 | 2.453 |
| string: silesia/dickens | 172528 | 12902.4 ± 1.0% | 3908.9 ± 1.9% | 3063.3 ± 1.0% | 332.2 ± 1.7% | 1512.5 ± 1.3% | 1174.3 ± 1.5% | 3.301 | 4.212 | 38.843 | 8.530 | 10.988 |
| string: silesia/nci | 1075110 | 11262.5 ± 1.2% | 4649.8 ± 0.5% | 3125.5 ± 0.5% | 906.9 ± 1.0% | 1595.2 ± 2.9% | 1199.6 ± 0.9% | 2.422 | 3.603 | 12.418 | 7.060 | 9.389 |
| string: silesia/reymont | 1075159 | 5404.0 ± 1.2% | 1849.6 ± 1.3% | 1893.4 ± 1.2% | 381.5 ± 1.6% | 1335.7 ± 1.7% | 1034.0 ± 1.5% | 2.922 | 2.854 | 14.165 | 4.046 | 5.226 |
| string: silesia/samba | 97582 | 6269.5 ± 0.8% | 2693.7 ± 0.8% | 4045.4 ± 0.5% | 347.2 ± 0.4% | 1268.9 ± 3.4% | 1171.4 ± 0.7% | 2.327 | 1.550 | 18.059 | 4.941 | 5.352 |
| string: silesia/webster | 1098490 | 7114.0 ± 0.7% | 1982.1 ± 0.3% | 1744.6 ± 4.6% | 350.9 ± 0.9% | 1268.6 ± 1.1% | 600.5 ± 1.2% | 3.589 | 4.078 | 20.271 | 5.608 | 11.846 |
| string: silesia/xml | 1090118 | 10928.9 ± 1.4% | 3197.4 ± 1.0% | 2525.9 ± 0.5% | 603.1 ± 4.0% | 1712.4 ± 2.6% | 965.7 ± 0.8% | 3.418 | 4.327 | 18.121 | 6.382 | 11.317 |
| string: canterbury/alice29.txt | 159425 | 12695.8 ± 0.5% | 2879.1 ± 1.7% | 2973.3 ± 0.7% | 316.3 ± 1.0% | 1352.6 ± 1.7% | 1082.2 ± 1.0% | 4.410 | 4.270 | 40.137 | 9.387 | 11.731 |
| string: canterbury/asyoulik.txt | 132198 | 10684.6 ± 1.1% | 2086.4 ± 1.4% | 3106.0 ± 0.5% | 314.6 ± 1.0% | 1236.1 ± 2.3% | 949.5 ± 1.3% | 5.121 | 3.440 | 33.964 | 8.643 | 11.252 |
| string: canterbury/lcet10.txt | 441884 | 12887.4 ± 0.7% | 3082.6 ± 0.6% | 2548.5 ± 1.2% | 365.6 ± 1.4% | 1457.4 ± 2.7% | 1183.6 ± 1.2% | 4.181 | 5.057 | 35.247 | 8.843 | 10.888 |
| string: canterbury/plrabn12.txt | 503330 | 8997.8 ± 1.3% | 2305.7 ± 0.6% | 2089.4 ± 0.7% | 346.5 ± 0.3% | 1369.8 ± 2.8% | 1106.6 ± 1.6% | 3.902 | 4.306 | 25.965 | 6.569 | 8.131 |
| string: canterbury-large/E.coli | 1048578 | 34596.0 ± 1.9% | 15735.6 ± 1.5% | 3465.8 ± 0.7% | 1692.2 ± 0.3% | 2966.4 ± 4.6% | 1410.1 ± 0.5% | 2.199 | 9.982 | 20.444 | 11.663 | 24.534 |
| string: canterbury-large/bible.txt | 1055886 | 9752.9 ± 1.3% | 4856.0 ± 0.7% | 2990.9 ± 0.3% | 404.3 ± 0.3% | 2035.8 ± 0.3% | 1477.6 ± 0.5% | 2.008 | 3.261 | 24.124 | 4.791 | 6.600 |
| string: canterbury-large/world192.txt | 1103121 | 6726.8 ± 1.4% | 1737.9 ± 2.3% | 1862.1 ± 2.0% | 348.6 ± 2.5% | 1270.4 ± 1.2% | 963.9 ± 1.2% | 3.871 | 3.612 | 19.299 | 5.295 | 6.979 |
| string: http/html-1m | 1058582 | 10173.7 ± 1.2% | 4357.5 ± 2.2% | 2874.3 ± 3.6% | 418.4 ± 1.2% | 2033.9 ± 0.8% | 846.4 ± 0.9% | 2.335 | 3.539 | 24.313 | 5.002 | 12.020 |
| string: http/json-1m | 1190272 | 8409.5 ± 0.9% | 1567.1 ± 5.9% | 1562.4 ± 0.5% | 556.9 ± 1.1% | 1016.5 ± 1.1% | 848.2 ± 0.5% | 5.366 | 5.382 | 15.099 | 8.273 | 9.914 |
| string: http/js-1m | 1144362 | 6564.8 ± 1.3% | 1120.0 ± 0.9% | 1388.7 ± 0.8% | 331.6 ± 1.8% | 1037.9 ± 1.7% | 752.5 ± 1.1% | 5.861 | 4.727 | 19.800 | 6.325 | 8.724 |
| string: http/css-1m | 1097820 | 9213.9 ± 0.7% | 1472.8 ± 0.3% | 2274.3 ± 1.3% | 506.1 ± 0.8% | 1135.9 ± 1.5% | 869.3 ± 2.0% | 6.256 | 4.051 | 18.207 | 8.111 | 10.599 |
| string: dickens as Cyrillic and CJK | 1883069 | 5505.3 ± 0.4% | 3651.6 ± 0.6% | 488.0 ± 0.3% | 246.7 ± 1.2% | 454.2 ± 0.5% | 356.1 ± 0.6% | 1.508 | 11.280 | 22.315 | 12.122 | 15.461 |
| hex: silesia/dickens | 524290 | 41906.7 ± 1.2% | 2575.9 ± 1.1% | 1501.2 ± 0.5% | 457.7 ± 2.9% | 1498.8 ± 0.7% | 1064.9 ± 0.4% | 16.269 | 27.915 | 91.561 | 27.960 | 39.352 |
| hex: silesia/mozilla | 524290 | 43274.4 ± 1.8% | 2579.6 ± 0.6% | 1496.1 ± 0.5% | 389.3 ± 2.9% | 1558.2 ± 1.4% | 1063.3 ± 0.4% | 16.776 | 28.926 | 111.171 | 27.772 | 40.698 |
| hex: silesia/mr | 524290 | 42819.9 ± 1.4% | 2572.3 ± 0.8% | 1498.5 ± 6.0% | 596.1 ± 1.1% | 1551.7 ± 0.8% | 1062.5 ± 1.9% | 16.647 | 28.575 | 71.830 | 27.596 | 40.302 |
| hex: silesia/nci | 524290 | 43390.5 ± 1.6% | 2563.7 ± 0.6% | 1496.7 ± 0.3% | 751.4 ± 0.7% | 1537.1 ± 1.1% | 1061.5 ± 0.7% | 16.925 | 28.991 | 57.748 | 28.229 | 40.875 |
| hex: silesia/ooffice | 524290 | 42785.5 ± 1.6% | 2589.0 ± 1.1% | 1507.5 ± 2.2% | 324.6 ± 1.4% | 1558.6 ± 5.9% | 1060.7 ± 1.4% | 16.526 | 28.382 | 131.825 | 27.450 | 40.338 |
| hex: silesia/osdb | 524290 | 41973.2 ± 3.2% | 2580.9 ± 0.5% | 1502.1 ± 0.7% | 427.5 ± 0.9% | 1546.1 ± 0.7% | 1060.6 ± 0.7% | 16.263 | 27.943 | 98.183 | 27.148 | 39.576 |
| hex: silesia/reymont | 524290 | 43509.8 ± 1.5% | 2595.1 ± 1.0% | 1508.7 ± 1.2% | 483.8 ± 0.9% | 1544.1 ± 1.8% | 1064.5 ± 0.6% | 16.766 | 28.838 | 89.926 | 28.178 | 40.874 |
| hex: silesia/samba | 524290 | 42627.1 ± 2.1% | 2562.0 ± 1.1% | 1501.5 ± 1.0% | 338.3 ± 1.6% | 1555.0 ± 2.1% | 1065.3 ± 1.2% | 16.638 | 28.390 | 126.017 | 27.412 | 40.014 |
| hex: silesia/sao | 524290 | 42867.1 ± 1.1% | 2587.4 ± 0.7% | 1503.7 ± 1.0% | 266.1 ± 8.9% | 1540.3 ± 2.7% | 1060.2 ± 0.5% | 16.568 | 28.508 | 161.080 | 27.829 | 40.435 |
| hex: silesia/webster | 524290 | 43084.5 ± 1.9% | 2587.6 ± 0.7% | 1499.7 ± 0.8% | 432.9 ± 0.6% | 1543.5 ± 6.3% | 1062.2 ± 6.6% | 16.651 | 28.729 | 99.515 | 27.914 | 40.562 |
| hex: silesia/x-ray | 524290 | 42750.7 ± 1.8% | 2576.9 ± 0.7% | 1505.5 ± 1.1% | 421.0 ± 0.9% | 1563.0 ± 0.7% | 1063.0 ± 1.1% | 16.590 | 28.396 | 101.548 | 27.352 | 40.218 |
| hex: silesia/xml | 524290 | 42923.7 ± 1.2% | 2584.0 ± 0.7% | 1498.0 ± 0.7% | 684.5 ± 0.2% | 1542.3 ± 0.9% | 1060.1 ± 0.4% | 16.612 | 28.654 | 62.706 | 27.831 | 40.490 |
| hex: canterbury/alice29.txt | 304180 | 41247.5 ± 2.7% | 2612.7 ± 0.4% | 1521.4 ± 0.9% | 468.1 ± 0.7% | 1547.6 ± 0.5% | 1086.4 ± 1.3% | 15.788 | 27.112 | 88.111 | 26.652 | 37.967 |
| hex: canterbury/asyoulik.txt | 250360 | 43051.8 ± 1.9% | 2601.4 ± 0.8% | 1535.1 ± 1.3% | 455.6 ± 1.3% | 1555.6 ± 1.3% | 1079.0 ± 1.2% | 16.549 | 28.044 | 94.495 | 27.676 | 39.901 |
| hex: canterbury/cp.html | 49208 | 42074.3 ± 1.9% | 2585.0 ± 0.5% | 1523.3 ± 0.6% | 477.7 ± 1.0% | 1579.3 ± 0.9% | 1087.7 ± 0.6% | 16.276 | 27.620 | 88.075 | 26.640 | 38.681 |
| hex: canterbury/fields.c | 22302 | 42279.6 ± 1.0% | 2643.6 ± 0.4% | 1531.3 ± 0.4% | 599.0 ± 0.6% | 1603.5 ± 0.9% | 1098.3 ± 0.4% | 15.993 | 27.610 | 70.581 | 26.367 | 38.494 |
| hex: canterbury/grammar.lsp | 7444 | 39993.0 ± 1.4% | 2676.4 ± 0.9% | 1530.8 ± 0.8% | 810.2 ± 0.9% | 1599.8 ± 0.5% | 1102.5 ± 0.5% | 14.943 | 26.126 | 49.359 | 25.000 | 36.275 |
| hex: canterbury/kennedy.xls | 524290 | 43120.5 ± 1.7% | 2573.9 ± 0.9% | 1501.2 ± 0.6% | 774.0 ± 0.6% | 1497.6 ± 0.7% | 1059.5 ± 0.8% | 16.753 | 28.723 | 55.712 | 28.794 | 40.698 |
| hex: canterbury/lcet10.txt | 524290 | 43378.4 ± 0.6% | 2601.8 ± 0.5% | 1502.9 ± 0.6% | 467.7 ± 0.3% | 1563.7 ± 1.6% | 1063.2 ± 0.5% | 16.672 | 28.864 | 92.754 | 27.741 | 40.800 |
| hex: canterbury/plrabn12.txt | 524290 | 43590.1 ± 1.1% | 2580.5 ± 0.5% | 1502.7 ± 0.8% | 453.6 ± 0.7% | 1566.2 ± 0.7% | 1069.4 ± 0.7% | 16.892 | 29.008 | 96.106 | 27.831 | 40.762 |
| hex: canterbury/ptt5 | 524290 | 43503.3 ± 1.2% | 2562.7 ± 0.4% | 1498.9 ± 0.7% | 592.8 ± 1.5% | 1556.4 ± 1.0% | 1064.8 ± 0.5% | 16.976 | 29.024 | 73.392 | 27.951 | 40.855 |
| hex: canterbury/sum | 76482 | 42865.5 ± 0.8% | 2589.8 ± 0.6% | 1515.4 ± 0.4% | 559.4 ± 0.8% | 1576.1 ± 5.5% | 1088.4 ± 1.0% | 16.552 | 28.287 | 76.623 | 27.197 | 39.385 |
| hex: canterbury/xargs.1 | 8456 | 40406.9 ± 1.0% | 2669.0 ± 0.8% | 1539.4 ± 0.4% | 837.7 ± 0.5% | 1604.0 ± 0.9% | 1107.4 ± 0.6% | 15.139 | 26.248 | 48.233 | 25.191 | 36.490 |
| hex: canterbury-large/E.coli | 524290 | 41709.9 ± 1.1% | 2580.4 ± 0.7% | 1499.7 ± 0.4% | 807.9 ± 2.8% | 1539.7 ± 1.0% | 1060.7 ± 1.6% | 16.164 | 27.812 | 51.629 | 27.089 | 39.324 |
| hex: canterbury-large/bible.txt | 524290 | 43603.5 ± 0.4% | 2583.3 ± 1.1% | 1503.0 ± 0.6% | 479.7 ± 0.7% | 1559.5 ± 0.8% | 1065.9 ± 0.7% | 16.879 | 29.011 | 90.897 | 27.960 | 40.907 |
| hex: canterbury-large/world192.txt | 524290 | 42660.6 ± 1.8% | 2591.0 ± 1.4% | 1504.5 ± 5.7% | 456.0 ± 4.0% | 1536.2 ± 1.3% | 1061.4 ± 1.0% | 16.465 | 28.355 | 93.548 | 27.770 | 40.194 |
| hex: http/html-1kx1024 | 2099200 | 21120.6 ± 0.1% | 2635.4 ± 10.7% | 1441.3 ± 0.5% | 498.8 ± 0.8% | 1562.1 ± 1.3% | 1070.0 ± 7.4% | 8.014 | 14.654 | 42.347 | 13.521 | 19.739 |
| hex: http/html-16kx64 | 2097280 | 21594.0 ± 0.2% | 2208.8 ± 0.8% | 1440.7 ± 0.9% | 501.3 ± 1.1% | 1434.0 ± 4.7% | 1073.1 ± 6.7% | 9.776 | 14.988 | 43.080 | 15.059 | 20.124 |
| hex: http/html-1m | 524290 | 42891.6 ± 1.1% | 2579.2 ± 0.5% | 1497.9 ± 0.4% | 487.4 ± 0.7% | 1559.0 ± 1.2% | 1061.0 ± 1.0% | 16.630 | 28.634 | 87.994 | 27.512 | 40.426 |
| hex: http/json-1kx1024 | 2099200 | 20478.5 ± 0.1% | 2653.4 ± 0.3% | 1438.8 ± 4.9% | 689.7 ± 0.9% | 1563.1 ± 0.8% | 1067.8 ± 1.2% | 7.718 | 14.233 | 29.693 | 13.101 | 19.178 |
| hex: http/json-16kx64 | 2097280 | 22856.6 ± 0.3% | 2200.1 ± 0.9% | 1437.3 ± 0.7% | 701.2 ± 0.5% | 1431.0 ± 0.6% | 1076.0 ± 0.4% | 10.389 | 15.902 | 32.595 | 15.972 | 21.241 |
| hex: http/json-1m | 524290 | 42746.2 ± 1.2% | 2578.7 ± 2.2% | 1506.8 ± 1.3% | 722.6 ± 1.2% | 1501.8 ± 1.5% | 1067.3 ± 1.1% | 16.576 | 28.369 | 59.153 | 28.464 | 40.052 |
| hex: http/js-1kx1024 | 2099200 | 20398.3 ± 0.2% | 2562.9 ± 1.3% | 1438.2 ± 0.9% | 486.5 ± 0.7% | 1530.8 ± 1.4% | 1073.4 ± 1.8% | 7.959 | 14.184 | 41.931 | 13.325 | 19.003 |
| hex: http/js-16kx64 | 2097280 | 21537.6 ± 0.1% | 2219.6 ± 0.9% | 1454.9 ± 1.3% | 494.2 ± 1.2% | 1445.4 ± 1.3% | 1086.3 ± 1.1% | 9.703 | 14.804 | 43.577 | 14.901 | 19.826 |
| hex: http/js-1m | 524290 | 42696.2 ± 0.9% | 2583.5 ± 10.5% | 1512.0 ± 0.7% | 500.8 ± 0.2% | 1466.9 ± 0.6% | 1068.7 ± 2.6% | 16.527 | 28.238 | 85.258 | 29.106 | 39.950 |
| hex: http/css-1kx1024 | 2099200 | 21839.4 ± 0.6% | 2658.7 ± 1.3% | 1454.7 ± 1.6% | 557.0 ± 0.6% | 1576.1 ± 1.6% | 1071.8 ± 1.2% | 8.214 | 15.013 | 39.211 | 13.857 | 20.376 |
| hex: http/css-16kx64 | 2097280 | 21429.1 ± 0.2% | 2226.5 ± 0.3% | 1455.7 ± 0.1% | 565.3 ± 0.1% | 1447.8 ± 0.1% | 1087.5 ± 0.2% | 9.625 | 14.721 | 37.907 | 14.802 | 19.705 |
| hex: http/css-1m | 524290 | 42687.7 ± 0.1% | 2592.3 ± 0.6% | 1505.5 ± 5.6% | 532.4 ± 0.8% | 1481.0 ± 0.9% | 1071.6 ± 0.3% | 16.467 | 28.355 | 80.175 | 28.823 | 39.836 |
| hex: shuffled/dickens-1m | 524290 | 41275.0 ± 0.9% | 2603.1 ± 0.2% | 1514.3 ± 0.1% | 464.2 ± 0.4% | 1562.0 ± 0.8% | 1073.2 ± 0.3% | 15.856 | 27.256 | 88.914 | 26.425 | 38.461 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- qlog records, JSON text sequence, decoding: stdx runs at 0.923 of simdjson.
- messages: 11 string members, decoding: stdx runs at 0.557 of simdjson.
- messages: 50 nested objects, decoding: stdx runs at 0.773 of simdjson.
- messages: 50 nested objects, decoding: stdx runs at 0.907 of yyjson.
- messages: a tree of 341 objects, decoding: stdx runs at 0.787 of simdjson.
- messages: a tree of 341 objects, encoding: stdx runs at 0.879 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.790 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.849 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.891 of yyjson.
- messages: 11 string members, decoding through TextReader.next: stdx runs at 0.496 of simdjson.
- messages: 50 nested objects, decoding through TextReader.next: stdx runs at 0.731 of simdjson.
- messages: 50 nested objects, decoding through TextReader.next: stdx runs at 0.858 of yyjson.
- messages: a tree of 341 objects, decoding through TextReader.next: stdx runs at 0.653 of simdjson.
- messages: a tree of 341 objects, decoding through TextReader.next: stdx runs at 0.784 of yyjson.
- messages: a tree of 341 objects, decoding through TextReader.next: stdx runs at 0.894 of serde_json.
- CLDR supplemental, 34 texts, decoding through TextReader.next_items: stdx runs at 0.883 of simdjson.
- messages: 11 string members, decoding through TextReader.next_items: stdx runs at 0.538 of simdjson.
- messages: 50 nested objects, decoding through TextReader.next_items: stdx runs at 0.767 of simdjson.
- messages: 50 nested objects, decoding through TextReader.next_items: stdx runs at 0.899 of yyjson.
- messages: a tree of 341 objects, decoding through TextReader.next_items: stdx runs at 0.773 of simdjson.
- messages: a tree of 341 objects, decoding through TextReader.next_items: stdx runs at 0.929 of yyjson.
- messages: 50 nested objects, encoding through TextWriter's methods: stdx runs at 0.882 of simdjson.
- messages: a tree of 341 objects, encoding through TextWriter's methods: stdx runs at 0.790 of simdjson.
- messages: a tree of 341 objects, encoding through TextWriter's methods: stdx runs at 0.925 of yyjson.
