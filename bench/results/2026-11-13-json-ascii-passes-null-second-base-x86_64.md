# bench-json

| Field | Value |
|---|---|
| Commit | f607235 |
| Runner label | ubuntu-24.04 |
| Image version | 20261111.370.1 |
| CPU model | AMD EPYC 7763 64-Core Processor |
| Virtual CPUs | 4 |
| Kernel | 7.0.0-1017-azure |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/43464730913 |
| Date | 2026-11-13 |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1. The `TextReader.next_items` column is that helper's queued tokens a slice a call (decision 79), over many tokens a call.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | TextReader.next_items | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1011.6 ± 6.9% | 0.464 | 1.013 | 1.033 | 1.070 | 0.416 | 1.062 | 1.085 | 0.369 | 0.818 | 0.969 | 0.096 |
| qlog records, JSON text sequence | 1467503 | 707.0 ± 9.5% | 0.727 | 0.974 | 1.074 | 1.031 | 0.411 | 1.059 | 0.967 | 0.365 | 0.932 | 1.123 | 0.126 |
| string: silesia/dickens | 172528 | 5488.4 ± 0.9% | 0.025 | 0.649 | 1.023 | 1.039 | 0.175 | 0.997 | 1.037 | 0.176 | 0.998 | 0.997 | 0.025 |
| string: silesia/nci | 1075110 | 5264.7 ± 0.4% | 0.026 | 0.677 | 1.001 | 1.001 | 0.228 | 0.974 | 1.003 | 0.228 | 1.003 | 1.005 | 0.026 |
| string: silesia/reymont | 1075159 | 2776.3 ± 0.8% | 0.050 | 0.671 | 0.974 | 0.975 | 0.341 | 0.970 | 0.979 | 0.344 | 1.006 | 1.002 | 0.050 |
| string: silesia/samba | 97582 | 3359.5 ± 0.5% | 0.036 | 0.887 | 1.017 | 1.020 | 0.065 | 0.833 | 1.018 | 0.066 | 0.998 | 1.001 | 0.036 |
| string: silesia/webster | 1098490 | 3634.2 ± 7.4% | 0.037 | 0.668 | 1.032 | 1.051 | 0.195 | 1.021 | 1.052 | 0.195 | 1.008 | 1.011 | 0.037 |
| string: silesia/xml | 1090118 | 5136.1 ± 1.3% | 0.027 | 0.827 | 1.000 | 1.000 | 0.215 | 0.984 | 1.003 | 0.213 | 0.991 | 0.988 | 0.027 |
| string: canterbury/alice29.txt | 159425 | 4382.6 ± 3.0% | 0.031 | 0.767 | 1.044 | 1.107 | 0.166 | 1.062 | 1.109 | 0.167 | 1.014 | 1.001 | 0.031 |
| string: canterbury/asyoulik.txt | 132198 | 3922.0 ± 4.4% | 0.034 | 0.783 | 1.016 | 1.085 | 0.156 | 0.990 | 1.088 | 0.157 | 0.984 | 0.969 | 0.034 |
| string: canterbury/lcet10.txt | 441884 | 5686.3 ± 1.1% | 0.024 | 0.574 | 1.042 | 1.056 | 0.163 | 1.014 | 1.055 | 0.163 | 0.965 | 1.000 | 0.024 |
| string: canterbury/plrabn12.txt | 503330 | 4409.0 ± 0.5% | 0.031 | 0.776 | 1.039 | 1.085 | 0.188 | 1.017 | 1.087 | 0.188 | 1.002 | 1.003 | 0.031 |
| string: canterbury-large/E.coli | 1048578 | 37559.1 ± 2.4% | 0.038 | 1.030 | 0.593 | 1.034 | 0.481 | 1.035 | 1.031 | 0.475 | 0.896 | 0.894 | 0.004 |
| string: canterbury-large/bible.txt | 1055886 | 6610.6 ± 1.4% | 0.022 | 0.684 | 0.906 | 0.902 | 0.399 | 0.985 | 0.902 | 0.404 | 1.002 | 1.003 | 0.022 |
| string: canterbury-large/world192.txt | 1103121 | 3459.7 ± 1.1% | 0.039 | 0.690 | 1.024 | 1.052 | 0.185 | 1.007 | 1.052 | 0.185 | 1.002 | 0.999 | 0.039 |
| string: http/html-1m | 1058582 | 6233.0 ± 0.4% | 0.023 | 0.672 | 0.947 | 0.947 | 0.364 | 0.984 | 0.948 | 0.365 | 0.997 | 1.001 | 0.023 |
| string: http/json-1m | 1190272 | 3340.8 ± 0.2% | 0.038 | 0.380 | 0.432 | 0.433 | 0.093 | 0.389 | 0.432 | 0.094 | 1.003 | 1.003 | 0.038 |
| string: http/js-1m | 1144362 | 2257.2 ± 1.5% | 0.057 | 0.768 | 1.024 | 1.076 | 0.174 | 1.013 | 1.079 | 0.175 | 1.002 | 1.005 | 0.057 |
| string: http/css-1m | 1097820 | 2989.1 ± 3.6% | 0.045 | 0.733 | 1.008 | 1.062 | 0.219 | 0.999 | 1.029 | 0.220 | 1.009 | 1.011 | 0.045 |
| string: dickens as Cyrillic and CJK | 1883069 | 5198.7 ± 0.6% | 0.021 | 0.058 | 0.497 | 0.496 | 0.181 | 0.496 | 0.497 | 0.181 | 1.003 | 1.004 | 0.021 |
| string: dickens as Cyrillic and CJK, as \u escapes | 5075485 | 1055.4 ± 1.4% | 0.094 | 0.978 | 0.980 | 0.979 | 0.089 | 0.710 | 0.979 | 0.090 | 1.004 | 1.006 | 0.094 |
| hex: silesia/dickens | 524290 | 37303.0 ± 1.5% | 0.040 | 1.026 | 0.594 | 1.029 | 0.486 | 1.032 | 1.033 | 0.483 | 0.904 | 0.903 | 0.004 |
| hex: silesia/mozilla | 524290 | 36103.8 ± 1.6% | 0.042 | 1.019 | 0.614 | 1.022 | 0.484 | 1.023 | 1.021 | 0.481 | 0.926 | 0.930 | 0.004 |
| hex: silesia/mr | 524290 | 37227.3 ± 0.6% | 0.040 | 1.030 | 0.597 | 1.035 | 0.484 | 1.037 | 1.033 | 0.477 | 0.895 | 0.895 | 0.004 |
| hex: silesia/nci | 524290 | 37483.2 ± 2.0% | 0.039 | 1.020 | 0.589 | 1.025 | 0.479 | 1.033 | 1.030 | 0.475 | 0.891 | 0.892 | 0.004 |
| hex: silesia/ooffice | 524290 | 31002.2 ± 1.4% | 0.047 | 1.017 | 0.677 | 1.015 | 0.545 | 1.024 | 1.021 | 0.544 | 1.072 | 1.070 | 0.005 |
| hex: silesia/osdb | 524290 | 37550.8 ± 1.5% | 0.039 | 1.022 | 0.591 | 1.020 | 0.480 | 1.025 | 1.021 | 0.480 | 0.890 | 0.889 | 0.004 |
| hex: silesia/reymont | 524290 | 37057.1 ± 2.2% | 0.039 | 1.013 | 0.598 | 1.024 | 0.480 | 1.027 | 1.029 | 0.481 | 0.902 | 0.905 | 0.004 |
| hex: silesia/samba | 524290 | 37388.8 ± 1.4% | 0.040 | 1.020 | 0.597 | 1.040 | 0.477 | 1.033 | 1.025 | 0.474 | 0.901 | 0.900 | 0.004 |
| hex: silesia/sao | 524290 | 37495.0 ± 1.1% | 0.039 | 1.031 | 0.590 | 1.030 | 0.484 | 1.041 | 1.039 | 0.480 | 0.891 | 0.892 | 0.004 |
| hex: silesia/webster | 524290 | 37386.1 ± 1.6% | 0.039 | 1.031 | 0.597 | 1.026 | 0.481 | 1.037 | 1.043 | 0.477 | 0.891 | 0.892 | 0.004 |
| hex: silesia/x-ray | 524290 | 37093.5 ± 5.0% | 0.039 | 1.032 | 0.598 | 1.036 | 0.481 | 1.039 | 1.042 | 0.480 | 0.894 | 0.902 | 0.004 |
| hex: silesia/xml | 524290 | 37347.4 ± 7.1% | 0.039 | 1.027 | 0.589 | 1.032 | 0.478 | 1.032 | 1.027 | 0.475 | 0.893 | 0.891 | 0.004 |
| hex: canterbury/alice29.txt | 304180 | 33344.2 ± 1.2% | 0.043 | 1.005 | 0.647 | 1.010 | 0.524 | 1.016 | 1.009 | 0.520 | 1.014 | 1.013 | 0.004 |
| hex: canterbury/asyoulik.txt | 250360 | 36877.3 ± 1.7% | 0.039 | 1.025 | 0.608 | 1.026 | 0.483 | 1.032 | 1.029 | 0.484 | 0.915 | 0.917 | 0.004 |
| hex: canterbury/cp.html | 49208 | 40073.5 ± 0.6% | 0.036 | 0.999 | 0.549 | 1.003 | 0.455 | 1.005 | 1.000 | 0.460 | 0.816 | 0.820 | 0.004 |
| hex: canterbury/fields.c | 22302 | 37564.9 ± 1.9% | 0.038 | 1.008 | 0.568 | 1.012 | 0.464 | 1.004 | 1.014 | 0.476 | 0.843 | 0.845 | 0.004 |
| hex: canterbury/grammar.lsp | 7444 | 36217.1 ± 0.4% | 0.039 | 1.022 | 0.539 | 1.029 | 0.413 | 1.025 | 1.027 | 0.444 | 0.759 | 0.764 | 0.004 |
| hex: canterbury/kennedy.xls | 524290 | 36975.3 ± 2.8% | 0.039 | 1.028 | 0.604 | 1.035 | 0.483 | 1.040 | 1.041 | 0.481 | 0.910 | 0.911 | 0.004 |
| hex: canterbury/lcet10.txt | 524290 | 37419.9 ± 4.0% | 0.039 | 1.031 | 0.593 | 1.032 | 0.482 | 1.041 | 1.034 | 0.478 | 0.891 | 0.894 | 0.004 |
| hex: canterbury/plrabn12.txt | 524290 | 35973.9 ± 3.8% | 0.040 | 1.022 | 0.611 | 1.027 | 0.489 | 1.029 | 1.026 | 0.490 | 0.935 | 0.933 | 0.004 |
| hex: canterbury/ptt5 | 524290 | 37605.7 ± 2.1% | 0.039 | 1.022 | 0.594 | 1.026 | 0.481 | 1.028 | 1.024 | 0.479 | 0.889 | 0.890 | 0.004 |
| hex: canterbury/sum | 76482 | 39526.9 ± 0.7% | 0.036 | 1.003 | 0.565 | 1.007 | 0.467 | 1.004 | 1.005 | 0.469 | 0.841 | 0.841 | 0.004 |
| hex: canterbury/xargs.1 | 8456 | 37520.2 ± 9.9% | 0.039 | 1.034 | 0.530 | 1.031 | 0.422 | 1.006 | 1.023 | 0.450 | 0.749 | 0.752 | 0.004 |
| hex: canterbury-large/E.coli | 524290 | 37049.9 ± 2.6% | 0.040 | 1.034 | 0.595 | 1.027 | 0.486 | 1.042 | 1.039 | 0.485 | 0.908 | 0.909 | 0.004 |
| hex: canterbury-large/bible.txt | 524290 | 36209.7 ± 2.4% | 0.041 | 1.027 | 0.613 | 1.029 | 0.491 | 1.036 | 1.034 | 0.490 | 0.923 | 0.925 | 0.004 |
| hex: canterbury-large/world192.txt | 524290 | 37265.1 ± 3.4% | 0.039 | 1.017 | 0.595 | 1.032 | 0.479 | 1.027 | 1.025 | 0.481 | 0.905 | 0.898 | 0.004 |
| hex: http/html-1kx1024 | 2099200 | 16639.3 ± 2.9% | 0.084 | 1.039 | 0.809 | 1.051 | 0.597 | 1.045 | 1.052 | 0.690 | 1.008 | 1.024 | 0.009 |
| hex: http/html-16kx64 | 2097280 | 34417.0 ± 2.6% | 0.043 | 1.025 | 0.606 | 1.033 | 0.501 | 1.035 | 1.036 | 0.498 | 0.892 | 0.898 | 0.004 |
| hex: http/html-1m | 524290 | 37673.2 ± 0.6% | 0.040 | 1.026 | 0.591 | 1.026 | 0.480 | 1.036 | 1.035 | 0.478 | 0.892 | 0.890 | 0.004 |
| hex: http/json-1kx1024 | 2099200 | 16708.8 ± 2.3% | 0.086 | 1.030 | 0.806 | 1.045 | 0.594 | 1.036 | 1.047 | 0.687 | 1.008 | 1.023 | 0.009 |
| hex: http/json-16kx64 | 2097280 | 34700.6 ± 1.6% | 0.044 | 1.005 | 0.599 | 1.013 | 0.497 | 1.012 | 1.014 | 0.494 | 0.883 | 0.884 | 0.004 |
| hex: http/json-1m | 524290 | 37251.4 ± 3.8% | 0.039 | 1.027 | 0.596 | 1.028 | 0.482 | 1.030 | 1.036 | 0.479 | 0.896 | 0.895 | 0.004 |
| hex: http/js-1kx1024 | 2099200 | 16352.6 ± 5.0% | 0.084 | 1.056 | 0.825 | 1.077 | 0.610 | 1.072 | 1.078 | 0.703 | 1.028 | 1.039 | 0.009 |
| hex: http/js-16kx64 | 2097280 | 34559.7 ± 2.2% | 0.041 | 1.018 | 0.606 | 1.027 | 0.502 | 1.029 | 1.027 | 0.504 | 0.888 | 0.889 | 0.004 |
| hex: http/js-1m | 524290 | 37277.3 ± 2.5% | 0.040 | 1.040 | 0.595 | 1.037 | 0.479 | 1.044 | 1.043 | 0.475 | 0.903 | 0.900 | 0.004 |
| hex: http/css-1kx1024 | 2099200 | 16486.5 ± 1.1% | 0.085 | 1.048 | 0.813 | 1.056 | 0.584 | 1.050 | 1.068 | 0.649 | 1.008 | 1.036 | 0.009 |
| hex: http/css-16kx64 | 2097280 | 34505.0 ± 2.1% | 0.042 | 1.015 | 0.608 | 1.023 | 0.504 | 1.026 | 1.032 | 0.503 | 0.888 | 0.890 | 0.004 |
| hex: http/css-1m | 524290 | 36230.1 ± 1.6% | 0.040 | 1.032 | 0.613 | 1.035 | 0.486 | 1.039 | 1.042 | 0.487 | 0.926 | 0.924 | 0.004 |
| hex: shuffled/dickens-1m | 524290 | 37335.4 ± 4.2% | 0.039 | 1.026 | 0.594 | 1.035 | 0.476 | 1.040 | 1.034 | 0.479 | 0.893 | 0.896 | 0.004 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1302.4 ± 3.3% | 0.443 | 0.970 | 0.982 | 0.998 | 1.005 | 0.233 | 0.988 | 0.446 | 0.853 | 0.086 | 1.016 |
| qlog records, JSON text sequence | 1467503 | 1096.6 ± 5.3% | 0.727 | 0.948 | 0.988 | 0.983 | 0.994 | 0.240 | 0.992 | 0.436 | 0.849 | 0.109 | 1.013 |
| string: silesia/dickens | 172528 | 8433.4 ± 0.3% | 0.018 | 0.632 | 0.445 | 0.645 | 0.633 | 0.127 | 0.633 | 1.001 | 1.002 | 0.018 | 1.041 |
| string: silesia/nci | 1075110 | 8067.4 ± 0.8% | 0.019 | 0.638 | 0.432 | 0.637 | 0.640 | 0.178 | 0.639 | 1.000 | 1.004 | 0.019 | 1.025 |
| string: silesia/reymont | 1075159 | 3809.1 ± 0.6% | 0.041 | 0.680 | 0.516 | 0.671 | 0.681 | 0.281 | 0.677 | 1.002 | 1.003 | 0.041 | 1.001 |
| string: silesia/samba | 97582 | 4561.7 ± 0.6% | 0.043 | 0.948 | 0.806 | 0.945 | 0.945 | 0.107 | 0.948 | 0.998 | 0.996 | 0.043 | 1.113 |
| string: silesia/webster | 1098490 | 5044.1 ± 4.8% | 0.030 | 0.703 | 0.498 | 0.708 | 0.705 | 0.156 | 0.707 | 1.000 | 0.997 | 0.030 | 1.001 |
| string: silesia/xml | 1090118 | 7812.4 ± 1.9% | 0.020 | 0.642 | 0.571 | 0.649 | 0.643 | 0.200 | 0.641 | 1.001 | 1.018 | 0.020 | 1.061 |
| string: canterbury/alice29.txt | 159425 | 9014.5 ± 0.5% | 0.017 | 0.561 | 0.414 | 0.560 | 0.566 | 0.090 | 0.570 | 1.003 | 1.004 | 0.017 | 1.035 |
| string: canterbury/asyoulik.txt | 132198 | 7563.7 ± 0.4% | 0.020 | 0.536 | 0.412 | 0.531 | 0.537 | 0.091 | 0.541 | 1.004 | 1.006 | 0.020 | 1.038 |
| string: canterbury/lcet10.txt | 441884 | 8421.4 ± 1.1% | 0.018 | 0.629 | 0.409 | 0.648 | 0.635 | 0.124 | 0.637 | 1.003 | 1.009 | 0.018 | 1.036 |
| string: canterbury/plrabn12.txt | 503330 | 5985.0 ± 0.9% | 0.026 | 0.777 | 0.592 | 0.771 | 0.778 | 0.157 | 0.776 | 0.999 | 1.001 | 0.026 | 1.042 |
| string: canterbury-large/E.coli | 1048578 | 37710.6 ± 4.9% | 0.040 | 1.009 | 1.025 | 0.589 | 1.021 | 0.476 | 1.024 | 1.009 | 1.022 | 0.004 | 1.025 |
| string: canterbury-large/bible.txt | 1055886 | 6943.9 ± 0.5% | 0.023 | 0.804 | 0.666 | 0.831 | 0.805 | 0.416 | 0.804 | 1.002 | 1.003 | 0.023 | 1.046 |
| string: canterbury-large/world192.txt | 1103121 | 4931.2 ± 4.6% | 0.031 | 0.675 | 0.514 | 0.670 | 0.668 | 0.143 | 0.669 | 1.024 | 0.978 | 0.031 | 0.961 |
| string: http/html-1m | 1058582 | 8427.6 ± 0.8% | 0.019 | 0.626 | 0.517 | 0.657 | 0.628 | 0.293 | 0.625 | 0.998 | 1.010 | 0.019 | 1.022 |
| string: http/json-1m | 1190272 | 6349.0 ± 6.2% | 0.023 | 0.225 | 0.196 | 0.228 | 0.225 | 0.064 | 0.225 | 1.001 | 1.002 | 0.023 | 1.021 |
| string: http/js-1m | 1144362 | 5012.5 ± 1.5% | 0.029 | 0.448 | 0.360 | 0.440 | 0.448 | 0.086 | 0.449 | 1.000 | 1.005 | 0.029 | 0.996 |
| string: http/css-1m | 1097820 | 6442.5 ± 3.5% | 0.023 | 0.513 | 0.368 | 0.541 | 0.516 | 0.121 | 0.518 | 1.002 | 1.005 | 0.023 | 1.049 |
| string: dickens as Cyrillic and CJK | 1883069 | 5370.0 ± 0.4% | 0.024 | 0.464 | 0.057 | 0.466 | 0.464 | 0.170 | 0.464 | 0.996 | 1.000 | 0.024 | 0.974 |
| hex: silesia/dickens | 524290 | 31379.7 ± 1.5% | 1.008 | 0.081 | 1.007 | 0.596 | 1.009 | 1.007 | 1.008 | 1.007 | 1.011 | 0.076 | 1.012 |
| hex: silesia/mozilla | 524290 | 35280.7 ± 1.1% | 1.003 | 0.072 | 1.003 | 0.570 | 1.004 | 1.002 | 0.998 | 1.000 | 1.001 | 0.069 | 1.003 |
| hex: silesia/mr | 524290 | 33096.6 ± 1.5% | 1.008 | 0.076 | 1.009 | 0.602 | 1.010 | 1.008 | 1.009 | 1.007 | 1.010 | 0.071 | 1.011 |
| hex: silesia/nci | 524290 | 32701.7 ± 2.4% | 1.010 | 0.077 | 1.003 | 0.606 | 0.992 | 1.006 | 1.008 | 1.006 | 1.007 | 0.071 | 1.002 |
| hex: silesia/ooffice | 524290 | 33262.8 ± 1.7% | 1.012 | 0.076 | 1.010 | 0.603 | 0.995 | 1.004 | 1.002 | 1.006 | 1.008 | 0.069 | 1.011 |
| hex: silesia/osdb | 524290 | 35021.2 ± 0.7% | 1.006 | 0.072 | 1.007 | 0.572 | 1.007 | 1.010 | 1.010 | 1.010 | 1.015 | 0.067 | 1.013 |
| hex: silesia/reymont | 524290 | 34497.7 ± 3.1% | 1.012 | 0.073 | 1.011 | 0.581 | 1.013 | 1.011 | 1.013 | 1.013 | 1.017 | 0.070 | 1.013 |
| hex: silesia/samba | 524290 | 33438.7 ± 2.3% | 1.013 | 0.075 | 1.015 | 0.598 | 1.014 | 1.019 | 1.017 | 1.009 | 1.023 | 0.070 | 1.009 |
| hex: silesia/sao | 524290 | 34097.7 ± 1.8% | 0.999 | 0.073 | 1.005 | 0.578 | 1.006 | 1.001 | 1.014 | 1.005 | 1.011 | 0.069 | 1.007 |
| hex: silesia/webster | 524290 | 36709.8 ± 2.6% | 1.012 | 0.069 | 1.013 | 0.549 | 1.015 | 1.013 | 1.009 | 1.015 | 1.015 | 0.065 | 1.017 |
| hex: silesia/x-ray | 524290 | 33496.6 ± 2.1% | 1.007 | 0.075 | 1.012 | 0.594 | 1.008 | 1.001 | 1.000 | 1.005 | 1.011 | 0.069 | 0.994 |
| hex: silesia/xml | 524290 | 33168.5 ± 4.2% | 1.012 | 0.076 | 1.009 | 0.600 | 0.998 | 1.003 | 1.006 | 1.010 | 1.001 | 0.070 | 1.007 |
| hex: canterbury/alice29.txt | 304180 | 33022.4 ± 1.3% | 1.017 | 0.077 | 1.019 | 0.599 | 1.017 | 1.015 | 1.020 | 1.016 | 1.013 | 0.069 | 1.013 |
| hex: canterbury/asyoulik.txt | 250360 | 31863.8 ± 0.9% | 1.009 | 0.080 | 1.006 | 0.613 | 1.008 | 0.999 | 1.009 | 1.007 | 1.009 | 0.074 | 1.008 |
| hex: canterbury/cp.html | 49208 | 31841.8 ± 1.9% | 1.005 | 0.080 | 1.004 | 0.592 | 1.004 | 0.995 | 1.004 | 1.005 | 1.009 | 0.075 | 1.005 |
| hex: canterbury/fields.c | 22302 | 32285.2 ± 0.7% | 1.003 | 0.078 | 1.000 | 0.584 | 0.999 | 0.984 | 1.002 | 1.006 | 1.016 | 0.072 | 1.006 |
| hex: canterbury/grammar.lsp | 7444 | 33247.0 ± 14.4% | 0.992 | 0.075 | 0.977 | 0.559 | 0.987 | 0.947 | 0.992 | 0.999 | 1.028 | 0.067 | 1.006 |
| hex: canterbury/kennedy.xls | 524290 | 31375.2 ± 3.4% | 1.008 | 0.081 | 1.003 | 0.602 | 1.005 | 0.999 | 1.006 | 1.008 | 1.009 | 0.072 | 1.003 |
| hex: canterbury/lcet10.txt | 524290 | 34392.6 ± 4.4% | 1.003 | 0.073 | 1.006 | 0.581 | 1.011 | 1.004 | 1.013 | 1.013 | 1.014 | 0.067 | 1.009 |
| hex: canterbury/plrabn12.txt | 524290 | 32954.8 ± 1.9% | 1.011 | 0.076 | 1.013 | 0.604 | 1.012 | 1.006 | 1.008 | 1.016 | 1.015 | 0.070 | 1.012 |
| hex: canterbury/ptt5 | 524290 | 33181.5 ± 2.6% | 1.014 | 0.076 | 1.011 | 0.607 | 1.015 | 1.007 | 1.004 | 1.011 | 1.020 | 0.069 | 1.008 |
| hex: canterbury/sum | 76482 | 34684.5 ± 3.6% | 1.006 | 0.073 | 1.011 | 0.574 | 1.012 | 1.009 | 1.014 | 1.014 | 1.013 | 0.066 | 1.009 |
| hex: canterbury/xargs.1 | 8456 | 34532.6 ± 0.3% | 0.996 | 0.073 | 1.000 | 0.545 | 0.998 | 0.956 | 0.994 | 1.009 | 1.022 | 0.066 | 1.010 |
| hex: canterbury-large/E.coli | 524290 | 30438.5 ± 0.4% | 1.006 | 0.083 | 1.004 | 0.629 | 1.008 | 1.007 | 1.005 | 0.995 | 1.000 | 0.077 | 1.002 |
| hex: canterbury-large/bible.txt | 524290 | 35570.9 ± 0.3% | 1.008 | 0.071 | 1.009 | 0.564 | 1.008 | 1.008 | 1.011 | 1.010 | 1.011 | 0.068 | 1.007 |
| hex: canterbury-large/world192.txt | 524290 | 34963.7 ± 12.2% | 1.014 | 0.072 | 1.013 | 0.573 | 1.013 | 1.012 | 1.015 | 1.012 | 1.022 | 0.068 | 1.019 |
| hex: http/html-1kx1024 | 2099200 | 23731.6 ± 3.0% | 1.003 | 0.103 | 0.994 | 0.682 | 1.000 | 0.894 | 0.999 | 1.006 | 1.070 | 0.095 | 1.035 |
| hex: http/html-16kx64 | 2097280 | 29701.5 ± 2.3% | 1.013 | 0.085 | 1.015 | 0.651 | 1.013 | 1.003 | 1.018 | 1.017 | 1.028 | 0.079 | 1.020 |
| hex: http/html-1m | 524290 | 29177.4 ± 1.9% | 1.009 | 0.087 | 0.996 | 0.666 | 1.009 | 1.006 | 1.009 | 1.006 | 1.005 | 0.079 | 1.001 |
| hex: http/json-1kx1024 | 2099200 | 23642.4 ± 2.2% | 0.998 | 0.104 | 0.996 | 0.682 | 1.002 | 0.873 | 0.986 | 0.995 | 1.047 | 0.093 | 1.009 |
| hex: http/json-16kx64 | 2097280 | 29711.0 ± 2.0% | 1.018 | 0.085 | 1.022 | 0.648 | 1.025 | 1.010 | 1.013 | 1.019 | 1.024 | 0.077 | 1.017 |
| hex: http/json-1m | 524290 | 31615.4 ± 1.1% | 1.007 | 0.080 | 1.012 | 0.634 | 1.004 | 1.007 | 1.011 | 1.001 | 1.012 | 0.074 | 1.009 |
| hex: http/js-1kx1024 | 2099200 | 23780.5 ± 0.2% | 0.998 | 0.103 | 0.975 | 0.676 | 0.993 | 0.891 | 0.996 | 1.006 | 1.068 | 0.098 | 1.029 |
| hex: http/js-16kx64 | 2097280 | 30024.2 ± 12.4% | 1.010 | 0.084 | 1.009 | 0.642 | 1.013 | 0.996 | 1.014 | 1.015 | 1.021 | 0.081 | 1.016 |
| hex: http/js-1m | 524290 | 30427.7 ± 0.5% | 1.009 | 0.083 | 1.006 | 0.646 | 1.004 | 1.005 | 1.005 | 1.000 | 1.006 | 0.076 | 0.995 |
| hex: http/css-1kx1024 | 2099200 | 23079.7 ± 1.6% | 1.008 | 0.105 | 0.998 | 0.695 | 1.015 | 0.904 | 1.015 | 1.024 | 1.067 | 0.093 | 1.032 |
| hex: http/css-16kx64 | 2097280 | 29597.1 ± 13.5% | 1.014 | 0.084 | 1.020 | 0.651 | 1.016 | 1.001 | 1.026 | 1.026 | 1.039 | 0.078 | 1.020 |
| hex: http/css-1m | 524290 | 31436.7 ± 2.1% | 1.009 | 0.080 | 1.007 | 0.633 | 1.007 | 1.005 | 1.006 | 1.009 | 1.008 | 0.073 | 1.009 |
| hex: shuffled/dickens-1m | 524290 | 34697.7 ± 3.8% | 1.013 | 0.073 | 1.014 | 0.584 | 1.015 | 1.013 | 1.017 | 1.015 | 1.023 | 0.069 | 1.018 |

## Losses

Each workload where a claim's path ran slower than the path it replaces by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding: J13 decoder escape blocks off runs at 1.085 of all on.
- string: canterbury/alice29.txt, decoding: J8 decoder fast path off runs at 1.107 of all on.
- string: canterbury/alice29.txt, decoding: J12 decoder escape words off runs at 1.062 of all on.
- string: canterbury/alice29.txt, decoding: J13 decoder escape blocks off runs at 1.109 of all on.
- string: canterbury/asyoulik.txt, decoding: J8 decoder fast path off runs at 1.085 of all on.
- string: canterbury/asyoulik.txt, decoding: J13 decoder escape blocks off runs at 1.088 of all on.
- string: canterbury/lcet10.txt, decoding: J8 decoder fast path off runs at 1.056 of all on.
- string: canterbury/lcet10.txt, decoding: J13 decoder escape blocks off runs at 1.055 of all on.
- string: canterbury/plrabn12.txt, decoding: J8 decoder fast path off runs at 1.085 of all on.
- string: canterbury/plrabn12.txt, decoding: J13 decoder escape blocks off runs at 1.087 of all on.
- string: canterbury-large/world192.txt, decoding: J8 decoder fast path off runs at 1.052 of all on.
- string: canterbury-large/world192.txt, decoding: J13 decoder escape blocks off runs at 1.052 of all on.
- string: http/js-1m, decoding: J8 decoder fast path off runs at 1.076 of all on.
- string: http/js-1m, decoding: J13 decoder escape blocks off runs at 1.079 of all on.
- hex: http/html-1kx1024, decoding: J8 decoder fast path off runs at 1.051 of all on.
- hex: http/html-1kx1024, decoding: J13 decoder escape blocks off runs at 1.052 of all on.
- hex: http/js-1kx1024, decoding: J5 UTF-8 vectors off runs at 1.056 of all on.
- hex: http/js-1kx1024, decoding: J8 decoder fast path off runs at 1.077 of all on.
- hex: http/js-1kx1024, decoding: J12 decoder escape words off runs at 1.072 of all on.
- hex: http/js-1kx1024, decoding: J13 decoder escape blocks off runs at 1.078 of all on.
- hex: http/css-1kx1024, decoding: J8 decoder fast path off runs at 1.056 of all on.
- hex: http/css-1kx1024, decoding: J13 decoder escape blocks off runs at 1.068 of all on.

## UTF-8 validation against simdutf

stdx's `is_utf8`, the check the loops apply to every string's octets, run alone over each string workload's octets at the width the host's features pick (16 lanes on aarch64, AVX2's 32 or AVX-512's 64 on x86-64, decision 39), beside simdutf 9.3.3's `validate_utf8` in the same run; on a host with AVX-512, again with AVX2 alone. Each ratio is stdx's throughput over the other's. simdutf picks its kernel at run time. Before timing, every copy of the check and simdutf judged 20000 seeded buffers and each workload, whole and changed, alike.

| Workload | Octets | stdx, MB/s | simdutf, MB/s | stdx / simdutf | stdx with AVX2 alone, MB/s | stdx / stdx with AVX2 alone |
|---|---|---|---|---|---|---|
| string: silesia/dickens | 166668 | 100456.7 ± 3.3% | 91493.9 ± 0.3% | 1.098 | — | — |
| string: silesia/nci | 1048576 | 72780.0 ± 15.3% | 71788.3 ± 1.5% | 1.014 | — | — |
| string: silesia/reymont | 1048576 | 73361.1 ± 0.4% | 71980.9 ± 1.0% | 1.019 | — | — |
| string: silesia/samba | 65546 | 98432.8 ± 0.4% | 90149.7 ± 0.4% | 1.092 | — | — |
| string: silesia/webster | 1048576 | 73045.3 ± 6.7% | 76429.2 ± 1.7% | 0.956 | — | — |
| string: silesia/xml | 1048576 | 72742.5 ± 0.1% | 71806.7 ± 1.8% | 1.013 | — | — |
| string: canterbury/alice29.txt | 152089 | 99367.0 ± 1.4% | 91570.6 ± 0.6% | 1.085 | — | — |
| string: canterbury/asyoulik.txt | 125179 | 99219.0 ± 0.7% | 91597.2 ± 0.9% | 1.083 | — | — |
| string: canterbury/lcet10.txt | 426754 | 82871.3 ± 13.2% | 82387.5 ± 1.0% | 1.006 | — | — |
| string: canterbury/plrabn12.txt | 481861 | 83416.9 ± 1.0% | 79557.4 ± 0.6% | 1.049 | — | — |
| string: canterbury-large/E.coli | 1048576 | 71579.9 ± 1.0% | 70831.5 ± 1.3% | 1.011 | — | — |
| string: canterbury-large/bible.txt | 1048576 | 72048.8 ± 2.2% | 72035.0 ± 0.8% | 1.000 | — | — |
| string: canterbury-large/world192.txt | 1048576 | 73107.1 ± 0.8% | 72218.7 ± 1.1% | 1.012 | — | — |
| string: http/html-1m | 1048576 | 66913.2 ± 1.1% | 67658.5 ± 1.3% | 0.989 | — | — |
| string: http/json-1m | 1048576 | 60457.8 ± 0.9% | 65240.3 ± 3.5% | 0.927 | — | — |
| string: http/js-1m | 1048576 | 72262.0 ± 0.5% | 71291.8 ± 0.7% | 1.014 | — | — |
| string: http/css-1m | 1048576 | 73144.2 ± 0.6% | 71965.3 ± 0.7% | 1.016 | — | — |
| string: dickens as Cyrillic and CJK | 1847045 | 14621.9 ± 0.2% | 15309.6 ± 1.7% | 0.955 | — | — |

## Losses to simdutf

- string: http/json-1m: stdx runs at 0.927 of simdutf.

## UTF-8 validation by the buffer's offset from a 64-octet line

| Buffer | Octets | Offset | stdx, MB/s | simdutf, MB/s | stdx / simdutf | stdx with AVX2 alone, MB/s | stdx / stdx with AVX2 alone |
|---|---|---|---|---|---|---|---|
| string: canterbury-large/bible.txt | 1048576 | 0 | 72760.9 ± 3.1% | 77015.9 ± 0.5% | 0.945 | — | — |
| string: canterbury-large/bible.txt | 1048576 | 1 | 73177.0 ± 0.8% | 72467.1 ± 0.7% | 1.010 | — | — |
| string: canterbury-large/bible.txt | 1048576 | 8 | 73083.8 ± 1.3% | 72037.3 ± 0.4% | 1.015 | — | — |
| string: canterbury-large/bible.txt | 1048576 | 16 | 73402.6 ± 0.4% | 72025.7 ± 2.1% | 1.019 | — | — |
| string: canterbury-large/bible.txt | 1048576 | 32 | 73295.5 ± 1.4% | 76431.8 ± 17.6% | 0.959 | — | — |
| string: canterbury-large/bible.txt | 1048576 | 48 | 73630.4 ± 0.6% | 72711.7 ± 0.9% | 1.013 | — | — |
| string: dickens as Cyrillic and CJK | 1048576 | 0 | 14598.6 ± 0.3% | 15270.5 ± 0.2% | 0.956 | — | — |
| string: dickens as Cyrillic and CJK | 1048576 | 1 | 14576.6 ± 0.2% | 15272.7 ± 7.2% | 0.954 | — | — |
| string: dickens as Cyrillic and CJK | 1048576 | 8 | 14565.0 ± 1.2% | 15278.3 ± 9.6% | 0.953 | — | — |
| string: dickens as Cyrillic and CJK | 1048576 | 16 | 14566.3 ± 0.9% | 15277.8 ± 0.3% | 0.953 | — | — |
| string: dickens as Cyrillic and CJK | 1048576 | 32 | 14568.3 ± 0.7% | 15275.1 ± 0.6% | 0.954 | — | — |
| string: dickens as Cyrillic and CJK | 1048576 | 48 | 14587.5 ± 0.5% | 15266.2 ± 2.0% | 0.956 | — | — |

## Against the baselines

stdx with every claim on, timed beside simdjson 5.1.1, yyjson 0.13.0, Zig 0.16.0's std.json, serde_json 1.0.154 and Go's encoding/json/jsontext in the same run. Each ratio is stdx's throughput over the baseline's; below 1, the baseline is faster. stdx is built for the architecture's baseline CPU in ReleaseSafe. Each baseline is built for the same CPU, the C, C++ and Zig ones in ReleaseFast (decision 75), and simdjson picks its kernel at run time. Decoding visits every value; encoding writes each text from its tokens.

## Decoding against the baselines

Octets are the text's. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1011.6 ± 6.9% | 987.1 ± 2.7% | 930.5 ± 2.2% | 286.9 ± 1.0% | 528.0 ± 1.0% | 246.6 ± 4.7% | 1.025 | 1.087 | 3.525 | 1.916 | 4.103 |
| qlog records, JSON text sequence | 1467503 | 707.0 ± 9.5% | 797.6 ± 0.5% | 670.3 ± 32.2% | 211.8 ± 2.7% | 431.6 ± 14.9% | 202.5 ± 4.5% | 0.887 | 1.055 | 3.338 | 1.638 | 3.492 |
| string: silesia/dickens | 172528 | 5488.4 ± 0.9% | 2891.8 ± 0.8% | 2018.4 ± 1.4% | 302.3 ± 8.3% | 2173.7 ± 0.6% | 436.4 ± 9.7% | 1.898 | 2.719 | 18.153 | 2.525 | 12.578 |
| string: silesia/nci | 1075110 | 5264.7 ± 0.4% | 3478.9 ± 0.4% | 2792.8 ± 1.2% | 502.4 ± 1.4% | 2412.6 ± 1.0% | 517.9 ± 1.1% | 1.513 | 1.885 | 10.480 | 2.182 | 10.167 |
| string: silesia/reymont | 1075159 | 2776.3 ± 0.8% | 2182.4 ± 0.5% | 1763.2 ± 2.6% | 318.5 ± 0.4% | 1630.7 ± 1.4% | 466.6 ± 2.6% | 1.272 | 1.575 | 8.716 | 1.703 | 5.950 |
| string: silesia/samba | 97582 | 3359.5 ± 0.5% | 2837.2 ± 10.3% | 1695.5 ± 9.5% | 262.1 ± 0.8% | 1280.6 ± 0.5% | 339.2 ± 2.5% | 1.184 | 1.981 | 12.815 | 2.623 | 9.904 |
| string: silesia/webster | 1098490 | 3634.2 ± 7.4% | 2024.5 ± 1.0% | 1606.3 ± 1.9% | 305.6 ± 1.1% | 1665.8 ± 1.0% | 421.0 ± 2.2% | 1.795 | 2.262 | 11.893 | 2.182 | 8.632 |
| string: silesia/xml | 1090118 | 5136.1 ± 1.3% | 3671.8 ± 0.6% | 2091.0 ± 2.7% | 403.5 ± 0.6% | 2338.9 ± 15.4% | 497.7 ± 5.2% | 1.399 | 2.456 | 12.730 | 2.196 | 10.320 |
| string: canterbury/alice29.txt | 159425 | 4382.6 ± 3.0% | 2347.1 ± 1.8% | 1790.3 ± 2.0% | 282.6 ± 2.7% | 1890.0 ± 1.5% | 416.1 ± 16.0% | 1.867 | 2.448 | 15.508 | 2.319 | 10.531 |
| string: canterbury/asyoulik.txt | 132198 | 3922.0 ± 4.4% | 2107.5 ± 0.3% | 1445.2 ± 3.4% | 272.1 ± 1.9% | 1586.9 ± 2.7% | 369.6 ± 8.5% | 1.861 | 2.714 | 14.415 | 2.472 | 10.612 |
| string: canterbury/lcet10.txt | 441884 | 5686.3 ± 1.1% | 2795.1 ± 0.3% | 1953.3 ± 2.6% | 324.5 ± 0.8% | 2126.9 ± 1.6% | 457.3 ± 4.5% | 2.034 | 2.911 | 17.525 | 2.673 | 12.434 |
| string: canterbury/plrabn12.txt | 503330 | 4409.0 ± 0.5% | 2696.0 ± 0.6% | 1647.1 ± 1.5% | 296.9 ± 1.0% | 2000.9 ± 1.2% | 430.6 ± 2.5% | 1.635 | 2.677 | 14.851 | 2.203 | 10.239 |
| string: canterbury-large/E.coli | 1048578 | 37559.1 ± 2.4% | 7751.7 ± 1.1% | 3487.8 ± 0.5% | 800.3 ± 0.3% | 5485.0 ± 0.6% | 767.7 ± 3.2% | 4.845 | 10.769 | 46.931 | 6.848 | 48.925 |
| string: canterbury-large/bible.txt | 1055886 | 6610.6 ± 1.4% | 3894.5 ± 0.4% | 2508.2 ± 1.8% | 350.9 ± 1.2% | 2972.8 ± 0.4% | 583.6 ± 3.4% | 1.697 | 2.636 | 18.837 | 2.224 | 11.327 |
| string: canterbury-large/world192.txt | 1103121 | 3459.7 ± 1.1% | 1977.9 ± 0.4% | 1609.7 ± 9.9% | 296.0 ± 6.4% | 1686.0 ± 0.8% | 424.6 ± 1.6% | 1.749 | 2.149 | 11.687 | 2.052 | 8.149 |
| string: http/html-1m | 1058582 | 6233.0 ± 0.4% | 3401.1 ± 0.9% | 2340.4 ± 7.4% | 407.7 ± 0.2% | 2731.8 ± 2.3% | 420.2 ± 1.0% | 1.833 | 2.663 | 15.289 | 2.282 | 14.835 |
| string: http/json-1m | 1190272 | 3340.8 ± 0.2% | 1195.3 ± 1.1% | 1394.9 ± 6.1% | 354.5 ± 1.8% | 819.0 ± 1.0% | 291.0 ± 1.9% | 2.795 | 2.395 | 9.423 | 4.079 | 11.480 |
| string: http/js-1m | 1144362 | 2257.2 ± 1.5% | 1321.0 ± 0.4% | 1148.1 ± 4.2% | 278.4 ± 4.0% | 1160.1 ± 0.8% | 289.1 ± 1.4% | 1.709 | 1.966 | 8.109 | 1.946 | 7.807 |
| string: http/css-1m | 1097820 | 2989.1 ± 3.6% | 2497.6 ± 1.2% | 1525.2 ± 1.6% | 372.2 ± 0.4% | 1494.9 ± 0.6% | 320.5 ± 2.3% | 1.197 | 1.960 | 8.031 | 2.000 | 9.327 |
| string: dickens as Cyrillic and CJK | 1883069 | 5198.7 ± 0.6% | 3203.2 ± 1.1% | 640.1 ± 0.9% | 256.7 ± 6.9% | 499.7 ± 3.1% | 139.4 ± 3.3% | 1.623 | 8.122 | 20.254 | 10.404 | 37.299 |
| string: dickens as Cyrillic and CJK, as \u escapes | 5075485 | 1055.4 ± 1.4% | 1068.4 ± 0.9% | 796.5 ± 1.1% | 161.2 ± 7.2% | 384.3 ± 0.7% | 198.5 ± 3.2% | 0.988 | 1.325 | 6.546 | 2.746 | 5.318 |
| hex: silesia/dickens | 524290 | 37303.0 ± 1.5% | 7726.9 ± 0.4% | 3478.4 ± 1.0% | 467.7 ± 1.8% | 5506.8 ± 0.3% | 758.5 ± 4.0% | 4.828 | 10.724 | 79.764 | 6.774 | 49.181 |
| hex: silesia/mozilla | 524290 | 36103.8 ± 1.6% | 7737.7 ± 0.8% | 3496.3 ± 0.8% | 408.9 ± 2.1% | 5486.1 ± 1.5% | 762.4 ± 2.4% | 4.666 | 10.326 | 88.289 | 6.581 | 47.357 |
| hex: silesia/mr | 524290 | 37227.3 ± 0.6% | 7742.1 ± 0.4% | 3504.8 ± 0.6% | 580.9 ± 0.3% | 5489.2 ± 0.7% | 761.4 ± 3.5% | 4.808 | 10.622 | 64.086 | 6.782 | 48.891 |
| hex: silesia/nci | 524290 | 37483.2 ± 2.0% | 7750.9 ± 1.2% | 3481.4 ± 1.0% | 644.7 ± 0.2% | 5468.3 ± 0.6% | 768.6 ± 1.4% | 4.836 | 10.767 | 58.142 | 6.855 | 48.771 |
| hex: silesia/ooffice | 524290 | 31002.2 ± 1.4% | 7734.8 ± 0.5% | 3488.2 ± 1.1% | 355.6 ± 0.7% | 5466.3 ± 6.4% | 771.0 ± 0.8% | 4.008 | 8.888 | 87.186 | 5.671 | 40.210 |
| hex: silesia/osdb | 524290 | 37550.8 ± 1.5% | 7745.1 ± 0.5% | 3493.4 ± 1.7% | 453.7 ± 1.7% | 5479.8 ± 0.3% | 764.7 ± 3.1% | 4.848 | 10.749 | 82.774 | 6.853 | 49.108 |
| hex: silesia/reymont | 524290 | 37057.1 ± 2.2% | 7749.0 ± 0.3% | 3467.9 ± 0.2% | 473.6 ± 4.6% | 5482.2 ± 0.7% | 771.6 ± 1.9% | 4.782 | 10.686 | 78.238 | 6.760 | 48.028 |
| hex: silesia/samba | 524290 | 37388.8 ± 1.4% | 7758.3 ± 14.4% | 3498.7 ± 1.7% | 353.9 ± 6.4% | 5503.3 ± 0.4% | 765.5 ± 2.1% | 4.819 | 10.687 | 105.642 | 6.794 | 48.842 |
| hex: silesia/sao | 524290 | 37495.0 ± 1.1% | 7776.6 ± 0.4% | 3475.3 ± 0.7% | 284.3 ± 1.6% | 5478.7 ± 20.2% | 759.2 ± 1.4% | 4.822 | 10.789 | 131.872 | 6.844 | 49.388 |
| hex: silesia/webster | 524290 | 37386.1 ± 1.6% | 7777.4 ± 0.4% | 3495.9 ± 0.8% | 431.2 ± 1.8% | 5452.8 ± 0.7% | 765.7 ± 1.7% | 4.807 | 10.694 | 86.705 | 6.856 | 48.828 |
| hex: silesia/x-ray | 524290 | 37093.5 ± 5.0% | 7766.0 ± 0.2% | 3474.9 ± 0.4% | 422.1 ± 0.9% | 5455.6 ± 1.6% | 767.7 ± 1.6% | 4.776 | 10.675 | 87.876 | 6.799 | 48.316 |
| hex: silesia/xml | 524290 | 37347.4 ± 7.1% | 7740.0 ± 1.9% | 3482.6 ± 0.9% | 602.3 ± 1.6% | 5499.7 ± 0.8% | 766.2 ± 1.1% | 4.825 | 10.724 | 62.008 | 6.791 | 48.745 |
| hex: canterbury/alice29.txt | 304180 | 33344.2 ± 1.2% | 7742.8 ± 0.8% | 3482.0 ± 1.3% | 455.1 ± 1.7% | 5407.5 ± 1.0% | 763.4 ± 1.7% | 4.306 | 9.576 | 73.273 | 6.166 | 43.676 |
| hex: canterbury/asyoulik.txt | 250360 | 36877.3 ± 1.7% | 7781.2 ± 1.5% | 3485.1 ± 1.4% | 441.2 ± 6.2% | 5412.2 ± 1.0% | 775.8 ± 1.1% | 4.739 | 10.581 | 83.588 | 6.814 | 47.535 |
| hex: canterbury/cp.html | 49208 | 40073.5 ± 0.6% | 7771.3 ± 0.4% | 3506.1 ± 1.2% | 461.5 ± 2.8% | 5429.9 ± 1.9% | 760.2 ± 4.4% | 5.157 | 11.430 | 86.828 | 7.380 | 52.715 |
| hex: canterbury/fields.c | 22302 | 37564.9 ± 1.9% | 7696.0 ± 0.5% | 3522.2 ± 1.2% | 484.0 ± 5.3% | 5386.4 ± 1.9% | 740.1 ± 6.1% | 4.881 | 10.665 | 77.616 | 6.974 | 50.754 |
| hex: canterbury/grammar.lsp | 7444 | 36217.1 ± 0.4% | 7483.3 ± 2.0% | 3569.2 ± 0.5% | 537.4 ± 2.5% | 5317.6 ± 0.6% | 723.4 ± 6.7% | 4.840 | 10.147 | 67.399 | 6.811 | 50.062 |
| hex: canterbury/kennedy.xls | 524290 | 36975.3 ± 2.8% | 7737.3 ± 0.8% | 3507.2 ± 0.7% | 684.6 ± 1.1% | 5487.4 ± 0.3% | 760.0 ± 5.6% | 4.779 | 10.543 | 54.013 | 6.738 | 48.650 |
| hex: canterbury/lcet10.txt | 524290 | 37419.9 ± 4.0% | 7763.8 ± 0.3% | 3485.8 ± 1.8% | 455.9 ± 11.0% | 5470.3 ± 0.3% | 760.4 ± 2.8% | 4.820 | 10.735 | 82.081 | 6.841 | 49.212 |
| hex: canterbury/plrabn12.txt | 524290 | 35973.9 ± 3.8% | 7741.5 ± 0.5% | 3502.1 ± 1.9% | 457.4 ± 3.8% | 5476.1 ± 0.9% | 770.9 ± 4.2% | 4.647 | 10.272 | 78.653 | 6.569 | 46.666 |
| hex: canterbury/ptt5 | 524290 | 37605.7 ± 2.1% | 7750.6 ± 1.0% | 3486.3 ± 0.9% | 564.5 ± 13.5% | 5481.6 ± 0.6% | 776.8 ± 4.1% | 4.852 | 10.787 | 66.618 | 6.860 | 48.412 |
| hex: canterbury/sum | 76482 | 39526.9 ± 0.7% | 7788.1 ± 0.3% | 3516.6 ± 0.8% | 527.7 ± 0.4% | 5465.6 ± 1.8% | 769.3 ± 9.1% | 5.075 | 11.240 | 74.903 | 7.232 | 51.383 |
| hex: canterbury/xargs.1 | 8456 | 37520.2 ± 9.9% | 7518.6 ± 0.2% | 3558.4 ± 0.2% | 526.0 ± 3.7% | 5343.2 ± 1.0% | 755.6 ± 2.1% | 4.990 | 10.544 | 71.332 | 7.022 | 49.658 |
| hex: canterbury-large/E.coli | 524290 | 37049.9 ± 2.6% | 7697.3 ± 8.5% | 3483.4 ± 0.7% | 710.5 ± 0.4% | 5467.7 ± 4.7% | 754.0 ± 10.9% | 4.813 | 10.636 | 52.145 | 6.776 | 49.136 |
| hex: canterbury-large/bible.txt | 524290 | 36209.7 ± 2.4% | 7707.0 ± 0.5% | 3480.8 ± 0.8% | 486.3 ± 4.2% | 5478.9 ± 1.2% | 770.4 ± 5.1% | 4.698 | 10.403 | 74.453 | 6.609 | 47.003 |
| hex: canterbury-large/world192.txt | 524290 | 37265.1 ± 3.4% | 7734.1 ± 0.5% | 3497.7 ± 0.8% | 445.3 ± 2.5% | 5485.9 ± 0.6% | 762.1 ± 3.3% | 4.818 | 10.654 | 83.690 | 6.793 | 48.900 |
| hex: http/html-1kx1024 | 2099200 | 16639.3 ± 2.9% | 6625.5 ± 3.7% | 3212.3 ± 6.6% | 479.3 ± 1.4% | 4673.0 ± 2.9% | 650.5 ± 5.3% | 2.511 | 5.180 | 34.714 | 3.561 | 25.581 |
| hex: http/html-16kx64 | 2097280 | 34417.0 ± 2.6% | 7649.2 ± 0.5% | 3452.6 ± 0.5% | 494.2 ± 0.4% | 5405.9 ± 0.7% | 745.4 ± 3.7% | 4.499 | 9.968 | 69.647 | 6.367 | 46.172 |
| hex: http/html-1m | 524290 | 37673.2 ± 0.6% | 7716.4 ± 0.5% | 3489.5 ± 0.4% | 492.7 ± 0.9% | 5485.5 ± 7.2% | 748.7 ± 4.3% | 4.882 | 10.796 | 76.461 | 6.868 | 50.318 |
| hex: http/json-1kx1024 | 2099200 | 16708.8 ± 2.3% | 6628.6 ± 0.7% | 3217.5 ± 1.1% | 617.3 ± 1.3% | 4710.6 ± 1.2% | 671.9 ± 3.6% | 2.521 | 5.193 | 27.068 | 3.547 | 24.870 |
| hex: http/json-16kx64 | 2097280 | 34700.6 ± 1.6% | 7646.9 ± 2.1% | 3450.7 ± 2.2% | 631.1 ± 15.8% | 5421.2 ± 1.1% | 752.4 ± 5.1% | 4.538 | 10.056 | 54.983 | 6.401 | 46.118 |
| hex: http/json-1m | 524290 | 37251.4 ± 3.8% | 7707.5 ± 1.1% | 3488.8 ± 0.4% | 642.3 ± 0.3% | 5469.0 ± 0.5% | 761.6 ± 4.4% | 4.833 | 10.677 | 57.998 | 6.811 | 48.909 |
| hex: http/js-1kx1024 | 2099200 | 16352.6 ± 5.0% | 6612.2 ± 0.8% | 3184.4 ± 1.6% | 460.3 ± 4.5% | 4592.0 ± 2.8% | 620.5 ± 5.7% | 2.473 | 5.135 | 35.522 | 3.561 | 26.353 |
| hex: http/js-16kx64 | 2097280 | 34559.7 ± 2.2% | 7608.4 ± 0.9% | 3430.8 ± 1.1% | 463.1 ± 9.9% | 5398.0 ± 0.7% | 714.9 ± 5.6% | 4.542 | 10.073 | 74.621 | 6.402 | 48.339 |
| hex: http/js-1m | 524290 | 37277.3 ± 2.5% | 7717.4 ± 0.6% | 3485.2 ± 0.9% | 490.8 ± 2.4% | 5468.0 ± 0.5% | 769.4 ± 8.1% | 4.830 | 10.696 | 75.954 | 6.817 | 48.453 |
| hex: http/css-1kx1024 | 2099200 | 16486.5 ± 1.1% | 6626.9 ± 0.4% | 3191.8 ± 1.5% | 521.5 ± 3.3% | 4582.5 ± 11.2% | 626.3 ± 4.0% | 2.488 | 5.165 | 31.613 | 3.598 | 26.325 |
| hex: http/css-16kx64 | 2097280 | 34505.0 ± 2.1% | 7637.7 ± 1.2% | 3435.2 ± 8.3% | 548.3 ± 0.8% | 5400.0 ± 0.8% | 715.1 ± 5.9% | 4.518 | 10.044 | 62.930 | 6.390 | 48.251 |
| hex: http/css-1m | 524290 | 36230.1 ± 1.6% | 7772.1 ± 0.5% | 3486.0 ± 0.7% | 532.6 ± 0.3% | 5450.1 ± 0.8% | 767.3 ± 5.3% | 4.662 | 10.393 | 68.022 | 6.648 | 47.219 |
| hex: shuffled/dickens-1m | 524290 | 37335.4 ± 4.2% | 7776.2 ± 1.3% | 3477.1 ± 0.6% | 456.5 ± 3.1% | 5467.7 ± 1.6% | 758.0 ± 5.4% | 4.801 | 10.737 | 81.784 | 6.828 | 49.254 |

## Encoding against the baselines

Octets are the ones stdx writes. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1302.4 ± 3.3% | 1096.9 ± 21.9% | 799.9 ± 7.2% | 318.5 ± 1.4% | 354.7 ± 7.9% | 298.7 ± 3.5% | 1.187 | 1.628 | 4.090 | 3.672 | 4.361 |
| qlog records, JSON text sequence | 1467503 | 1096.6 ± 5.3% | 827.6 ± 4.4% | 662.0 ± 2.6% | 299.3 ± 1.5% | 371.2 ± 1.1% | 216.6 ± 2.2% | 1.325 | 1.656 | 3.664 | 2.954 | 5.062 |
| string: silesia/dickens | 172528 | 8433.4 ± 0.3% | 2924.0 ± 6.1% | 2014.2 ± 1.1% | 353.4 ± 1.5% | 1388.9 ± 1.0% | 560.0 ± 0.2% | 2.884 | 4.187 | 23.865 | 6.072 | 15.061 |
| string: silesia/nci | 1075110 | 8067.4 ± 0.8% | 3147.7 ± 6.0% | 2757.2 ± 1.2% | 772.4 ± 0.5% | 1533.1 ± 0.3% | 558.6 ± 1.5% | 2.563 | 2.926 | 10.444 | 5.262 | 14.442 |
| string: silesia/reymont | 1075159 | 3809.1 ± 0.6% | 1639.7 ± 0.4% | 1711.2 ± 1.6% | 356.8 ± 1.5% | 1237.6 ± 0.7% | 547.0 ± 2.3% | 2.323 | 2.226 | 10.677 | 3.078 | 6.964 |
| string: silesia/samba | 97582 | 4561.7 ± 0.6% | 1960.5 ± 2.0% | 2165.2 ± 6.4% | 284.5 ± 2.8% | 976.4 ± 1.6% | 620.9 ± 1.6% | 2.327 | 2.107 | 16.032 | 4.672 | 7.347 |
| string: silesia/webster | 1098490 | 5044.1 ± 4.8% | 1622.2 ± 0.7% | 1519.8 ± 8.7% | 350.7 ± 1.3% | 1181.9 ± 4.3% | 450.9 ± 1.7% | 3.109 | 3.319 | 14.383 | 4.268 | 11.186 |
| string: silesia/xml | 1090118 | 7812.4 ± 1.9% | 2671.1 ± 0.9% | 2167.9 ± 2.0% | 535.2 ± 1.0% | 1552.7 ± 0.9% | 556.7 ± 0.9% | 2.925 | 3.604 | 14.597 | 5.031 | 14.032 |
| string: canterbury/alice29.txt | 159425 | 9014.5 ± 0.5% | 2428.7 ± 4.4% | 1787.8 ± 3.4% | 337.3 ± 2.0% | 1265.6 ± 0.5% | 557.8 ± 0.6% | 3.712 | 5.042 | 26.725 | 7.123 | 16.161 |
| string: canterbury/asyoulik.txt | 132198 | 7563.7 ± 0.4% | 2164.5 ± 1.2% | 1534.8 ± 0.6% | 339.8 ± 1.2% | 1110.5 ± 2.2% | 540.6 ± 1.1% | 3.495 | 4.928 | 22.257 | 6.811 | 13.991 |
| string: canterbury/lcet10.txt | 441884 | 8421.4 ± 1.1% | 2457.6 ± 2.2% | 1972.9 ± 0.4% | 386.4 ± 0.3% | 1365.8 ± 6.9% | 553.5 ± 0.6% | 3.427 | 4.268 | 21.792 | 6.166 | 15.215 |
| string: canterbury/plrabn12.txt | 503330 | 5985.0 ± 0.9% | 1821.2 ± 2.0% | 1662.5 ± 0.2% | 361.7 ± 0.8% | 1278.3 ± 1.5% | 552.7 ± 0.8% | 3.286 | 3.600 | 16.548 | 4.682 | 10.829 |
| string: canterbury-large/E.coli | 1048578 | 37710.6 ± 4.9% | 10902.5 ± 17.3% | 3382.8 ± 1.4% | 1417.1 ± 0.8% | 2509.3 ± 0.9% | 574.2 ± 1.7% | 3.459 | 11.148 | 26.610 | 15.028 | 65.673 |
| string: canterbury-large/bible.txt | 1055886 | 6943.9 ± 0.5% | 3963.6 ± 1.0% | 2645.8 ± 0.3% | 432.3 ± 1.7% | 1845.9 ± 1.7% | 568.9 ± 2.3% | 1.752 | 2.624 | 16.062 | 3.762 | 12.205 |
| string: canterbury-large/world192.txt | 1103121 | 4931.2 ± 4.6% | 1437.5 ± 1.9% | 1559.6 ± 3.4% | 366.8 ± 0.7% | 1158.1 ± 6.8% | 539.1 ± 1.9% | 3.430 | 3.162 | 13.442 | 4.258 | 9.148 |
| string: http/html-1m | 1058582 | 8427.6 ± 0.8% | 3868.0 ± 1.2% | 2473.1 ± 0.6% | 388.6 ± 0.8% | 1797.3 ± 0.4% | 518.8 ± 0.4% | 2.179 | 3.408 | 21.687 | 4.689 | 16.246 |
| string: http/json-1m | 1190272 | 6349.0 ± 6.2% | 1226.0 ± 0.4% | 1263.5 ± 0.5% | 373.1 ± 1.4% | 888.4 ± 1.2% | 501.2 ± 2.2% | 5.179 | 5.025 | 17.016 | 7.147 | 12.667 |
| string: http/js-1m | 1144362 | 5012.5 ± 1.5% | 986.0 ± 1.0% | 1074.8 ± 1.2% | 278.6 ± 0.6% | 931.3 ± 1.6% | 474.6 ± 1.6% | 5.084 | 4.664 | 17.988 | 5.382 | 10.562 |
| string: http/css-1m | 1097820 | 6442.5 ± 3.5% | 1291.3 ± 0.6% | 1592.1 ± 0.4% | 399.7 ± 31.3% | 1041.4 ± 0.5% | 532.5 ± 1.1% | 4.989 | 4.046 | 16.117 | 6.187 | 12.100 |
| string: dickens as Cyrillic and CJK | 1883069 | 5370.0 ± 0.4% | 3024.0 ± 0.5% | 343.2 ± 0.6% | 264.4 ± 1.1% | 435.2 ± 1.4% | 290.2 ± 0.9% | 1.776 | 15.646 | 20.311 | 12.339 | 18.503 |
| hex: silesia/dickens | 524290 | 31379.7 ± 1.5% | 1572.3 ± 7.1% | 1088.6 ± 0.4% | 410.8 ± 4.7% | 997.4 ± 2.5% | 425.6 ± 1.6% | 19.958 | 28.825 | 76.384 | 31.462 | 73.730 |
| hex: silesia/mozilla | 524290 | 35280.7 ± 1.1% | 1579.7 ± 0.2% | 1090.2 ± 0.8% | 365.9 ± 2.5% | 1026.5 ± 1.4% | 429.1 ± 1.2% | 22.334 | 32.361 | 96.413 | 34.369 | 82.216 |
| hex: silesia/mr | 524290 | 33096.6 ± 1.5% | 1575.6 ± 2.0% | 1092.4 ± 0.7% | 506.3 ± 2.0% | 1009.2 ± 1.2% | 427.7 ± 1.3% | 21.006 | 30.297 | 65.374 | 32.796 | 77.378 |
| hex: silesia/nci | 524290 | 32701.7 ± 2.4% | 1556.7 ± 1.5% | 1080.9 ± 1.4% | 554.5 ± 2.2% | 991.9 ± 1.3% | 424.6 ± 1.2% | 21.007 | 30.253 | 58.976 | 32.968 | 77.010 |
| hex: silesia/ooffice | 524290 | 33262.8 ± 1.7% | 1563.1 ± 1.8% | 1088.8 ± 2.3% | 316.3 ± 1.1% | 994.1 ± 8.2% | 423.7 ± 3.3% | 21.280 | 30.549 | 105.152 | 33.461 | 78.513 |
| hex: silesia/osdb | 524290 | 35021.2 ± 0.7% | 1574.2 ± 1.2% | 1089.7 ± 0.8% | 408.4 ± 3.6% | 1006.7 ± 2.6% | 425.8 ± 0.6% | 22.246 | 32.138 | 85.755 | 34.789 | 82.249 |
| hex: silesia/reymont | 524290 | 34497.7 ± 3.1% | 1579.5 ± 0.5% | 1093.0 ± 1.0% | 430.7 ± 1.8% | 1016.0 ± 1.7% | 424.5 ± 2.0% | 21.841 | 31.562 | 80.095 | 33.954 | 81.263 |
| hex: silesia/samba | 524290 | 33438.7 ± 2.3% | 1561.3 ± 2.1% | 1090.6 ± 2.1% | 324.8 ± 3.7% | 996.8 ± 2.5% | 422.9 ± 2.8% | 21.417 | 30.660 | 102.961 | 33.546 | 79.061 |
| hex: silesia/sao | 524290 | 34097.7 ± 1.8% | 1549.8 ± 1.6% | 1088.1 ± 1.3% | 256.7 ± 1.6% | 1001.4 ± 2.0% | 423.1 ± 1.7% | 22.002 | 31.337 | 132.853 | 34.049 | 80.594 |
| hex: silesia/webster | 524290 | 36709.8 ± 2.6% | 1569.2 ± 3.5% | 1092.5 ± 1.5% | 380.7 ± 2.0% | 999.8 ± 2.3% | 423.1 ± 2.6% | 23.394 | 33.602 | 96.424 | 36.718 | 86.774 |
| hex: silesia/x-ray | 524290 | 33496.6 ± 2.1% | 1576.4 ± 1.2% | 1091.0 ± 0.6% | 383.4 ± 3.2% | 1001.5 ± 4.0% | 423.7 ± 1.3% | 21.249 | 30.701 | 87.370 | 33.448 | 79.056 |
| hex: silesia/xml | 524290 | 33168.5 ± 4.2% | 1572.2 ± 1.3% | 1092.6 ± 1.1% | 576.9 ± 2.6% | 995.1 ± 1.0% | 421.9 ± 0.8% | 21.097 | 30.356 | 57.499 | 33.331 | 78.626 |
| hex: canterbury/alice29.txt | 304180 | 33022.4 ± 1.3% | 1587.9 ± 0.5% | 1094.8 ± 0.9% | 416.1 ± 1.7% | 1019.6 ± 2.4% | 426.8 ± 1.8% | 20.796 | 30.162 | 79.370 | 32.389 | 77.378 |
| hex: canterbury/asyoulik.txt | 250360 | 31863.8 ± 0.9% | 1583.1 ± 0.7% | 1100.9 ± 0.2% | 417.1 ± 1.4% | 1042.6 ± 1.8% | 429.4 ± 2.9% | 20.128 | 28.943 | 76.398 | 30.561 | 74.212 |
| hex: canterbury/cp.html | 49208 | 31841.8 ± 1.9% | 1607.0 ± 0.2% | 1107.0 ± 0.4% | 440.9 ± 3.0% | 1049.2 ± 1.9% | 437.0 ± 1.8% | 19.815 | 28.764 | 72.216 | 30.349 | 72.868 |
| hex: canterbury/fields.c | 22302 | 32285.2 ± 0.7% | 1588.1 ± 0.8% | 1099.4 ± 0.5% | 533.9 ± 2.2% | 1029.5 ± 3.6% | 429.3 ± 1.9% | 20.329 | 29.366 | 60.472 | 31.361 | 75.207 |
| hex: canterbury/grammar.lsp | 7444 | 33247.0 ± 14.4% | 1621.7 ± 1.9% | 1115.0 ± 2.8% | 570.1 ± 3.5% | 1032.3 ± 4.6% | 432.7 ± 3.3% | 20.501 | 29.817 | 58.322 | 32.205 | 76.839 |
| hex: canterbury/kennedy.xls | 524290 | 31375.2 ± 3.4% | 1560.8 ± 0.7% | 1088.4 ± 0.9% | 575.8 ± 1.7% | 982.5 ± 1.3% | 419.1 ± 2.0% | 20.102 | 28.827 | 54.488 | 31.935 | 74.867 |
| hex: canterbury/lcet10.txt | 524290 | 34392.6 ± 4.4% | 1563.3 ± 3.4% | 1084.8 ± 1.9% | 403.9 ± 1.7% | 998.6 ± 1.0% | 420.1 ± 2.2% | 21.999 | 31.704 | 85.144 | 34.442 | 81.868 |
| hex: canterbury/plrabn12.txt | 524290 | 32954.8 ± 1.9% | 1557.6 ± 1.1% | 1082.2 ± 6.1% | 401.0 ± 1.0% | 991.8 ± 2.8% | 418.9 ± 2.1% | 21.157 | 30.451 | 82.189 | 33.226 | 78.674 |
| hex: canterbury/ptt5 | 524290 | 33181.5 ± 2.6% | 1572.3 ± 1.9% | 1089.8 ± 7.4% | 486.4 ± 3.6% | 992.3 ± 1.6% | 420.7 ± 3.1% | 21.104 | 30.447 | 68.214 | 33.438 | 78.879 |
| hex: canterbury/sum | 76482 | 34684.5 ± 3.6% | 1589.2 ± 2.5% | 1086.6 ± 2.7% | 482.9 ± 2.4% | 1020.8 ± 1.5% | 430.9 ± 3.6% | 21.824 | 31.919 | 71.828 | 33.976 | 80.497 |
| hex: canterbury/xargs.1 | 8456 | 34532.6 ± 0.3% | 1627.8 ± 0.9% | 1111.2 ± 1.7% | 610.4 ± 4.6% | 1038.3 ± 2.2% | 435.1 ± 1.5% | 21.214 | 31.076 | 56.577 | 33.258 | 79.365 |
| hex: canterbury-large/E.coli | 524290 | 30438.5 ± 0.4% | 1563.1 ± 1.1% | 1087.7 ± 0.8% | 597.2 ± 3.7% | 1015.2 ± 5.5% | 425.3 ± 2.1% | 19.473 | 27.985 | 50.973 | 29.981 | 71.563 |
| hex: canterbury-large/bible.txt | 524290 | 35570.9 ± 0.3% | 1578.1 ± 1.2% | 1094.6 ± 0.3% | 434.4 ± 2.3% | 1025.7 ± 2.7% | 431.9 ± 2.9% | 22.541 | 32.497 | 81.876 | 34.680 | 82.361 |
| hex: canterbury-large/world192.txt | 524290 | 34963.7 ± 12.2% | 1576.0 ± 4.0% | 1092.0 ± 0.5% | 412.1 ± 0.7% | 1012.1 ± 0.4% | 426.2 ± 1.8% | 22.185 | 32.019 | 84.852 | 34.546 | 82.030 |
| hex: http/html-1kx1024 | 2099200 | 23731.6 ± 3.0% | 1609.4 ± 0.6% | 1087.0 ± 0.6% | 439.1 ± 3.1% | 1031.8 ± 2.5% | 429.4 ± 1.5% | 14.745 | 21.833 | 54.049 | 23.000 | 55.261 |
| hex: http/html-16kx64 | 2097280 | 29701.5 ± 2.3% | 1594.1 ± 0.7% | 1099.4 ± 0.3% | 436.9 ± 2.8% | 1027.6 ± 4.2% | 432.3 ± 1.9% | 18.632 | 27.016 | 67.978 | 28.905 | 68.706 |
| hex: http/html-1m | 524290 | 29177.4 ± 1.9% | 1559.5 ± 6.6% | 1090.1 ± 0.4% | 435.5 ± 1.4% | 996.0 ± 1.0% | 424.6 ± 1.7% | 18.709 | 26.766 | 66.992 | 29.294 | 68.719 |
| hex: http/json-1kx1024 | 2099200 | 23642.4 ± 2.2% | 1609.4 ± 1.3% | 1089.2 ± 0.1% | 550.0 ± 2.6% | 1024.9 ± 1.6% | 428.7 ± 0.8% | 14.691 | 21.706 | 42.989 | 23.068 | 55.155 |
| hex: http/json-16kx64 | 2097280 | 29711.0 ± 2.0% | 1574.3 ± 2.7% | 1098.4 ± 0.9% | 527.1 ± 3.2% | 961.9 ± 1.9% | 428.0 ± 1.2% | 18.872 | 27.048 | 56.362 | 30.886 | 69.424 |
| hex: http/json-1m | 524290 | 31615.4 ± 1.1% | 1563.1 ± 0.5% | 1087.3 ± 0.9% | 582.3 ± 2.4% | 996.3 ± 3.8% | 421.6 ± 7.7% | 20.226 | 29.078 | 54.295 | 31.732 | 74.995 |
| hex: http/js-1kx1024 | 2099200 | 23780.5 ± 0.2% | 1610.7 ± 0.4% | 1089.9 ± 0.2% | 433.7 ± 10.1% | 1051.1 ± 2.0% | 437.2 ± 1.1% | 14.764 | 21.818 | 54.834 | 22.625 | 54.398 |
| hex: http/js-16kx64 | 2097280 | 30024.2 ± 12.4% | 1597.8 ± 1.6% | 1100.7 ± 1.4% | 413.6 ± 2.8% | 974.5 ± 2.2% | 434.4 ± 2.8% | 18.791 | 27.278 | 72.587 | 30.808 | 69.113 |
| hex: http/js-1m | 524290 | 30427.7 ± 0.5% | 1569.4 ± 1.8% | 1084.2 ± 1.4% | 418.2 ± 2.9% | 986.3 ± 2.8% | 423.6 ± 1.6% | 19.388 | 28.066 | 72.761 | 30.849 | 71.825 |
| hex: http/css-1kx1024 | 2099200 | 23079.7 ± 1.6% | 1586.0 ± 5.6% | 1076.6 ± 0.5% | 476.1 ± 3.8% | 1010.5 ± 4.2% | 423.0 ± 2.8% | 14.552 | 21.437 | 48.480 | 22.841 | 54.566 |
| hex: http/css-16kx64 | 2097280 | 29597.1 ± 13.5% | 1579.4 ± 2.7% | 1095.7 ± 2.1% | 483.0 ± 5.0% | 1018.3 ± 4.5% | 425.9 ± 2.7% | 18.740 | 27.013 | 61.274 | 29.064 | 69.501 |
| hex: http/css-1m | 524290 | 31436.7 ± 2.1% | 1570.3 ± 0.8% | 1087.9 ± 1.2% | 436.7 ± 1.2% | 972.3 ± 3.8% | 424.5 ± 1.2% | 20.020 | 28.898 | 71.990 | 32.333 | 74.056 |
| hex: shuffled/dickens-1m | 524290 | 34697.7 ± 3.8% | 1575.7 ± 1.9% | 1091.3 ± 0.6% | 422.2 ± 3.9% | 1010.1 ± 10.3% | 426.5 ± 2.9% | 22.020 | 31.795 | 82.190 | 34.352 | 81.350 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1323.8 ± 2.2% | 1096.9 ± 21.9% | 799.9 ± 7.2% | 318.5 ± 1.4% | 354.7 ± 7.9% | 298.7 ± 3.5% | 1.207 | 1.655 | 4.157 | 3.732 | 4.432 |
| qlog records, JSON text sequence | 1467503 | 1110.5 ± 3.0% | 827.6 ± 4.4% | 662.0 ± 2.6% | 299.3 ± 1.5% | 371.2 ± 1.1% | 216.6 ± 2.2% | 1.342 | 1.678 | 3.710 | 2.991 | 5.126 |
| string: silesia/dickens | 172528 | 8778.5 ± 0.5% | 2924.0 ± 6.1% | 2014.2 ± 1.1% | 353.4 ± 1.5% | 1388.9 ± 1.0% | 560.0 ± 0.2% | 3.002 | 4.358 | 24.841 | 6.321 | 15.677 |
| string: silesia/nci | 1075110 | 8271.2 ± 1.1% | 3147.7 ± 6.0% | 2757.2 ± 1.2% | 772.4 ± 0.5% | 1533.1 ± 0.3% | 558.6 ± 1.5% | 2.628 | 3.000 | 10.708 | 5.395 | 14.806 |
| string: silesia/reymont | 1075159 | 3812.4 ± 0.8% | 1639.7 ± 0.4% | 1711.2 ± 1.6% | 356.8 ± 1.5% | 1237.6 ± 0.7% | 547.0 ± 2.3% | 2.325 | 2.228 | 10.686 | 3.080 | 6.970 |
| string: silesia/samba | 97582 | 5076.9 ± 0.2% | 1960.5 ± 2.0% | 2165.2 ± 6.4% | 284.5 ± 2.8% | 976.4 ± 1.6% | 620.9 ± 1.6% | 2.590 | 2.345 | 17.843 | 5.200 | 8.177 |
| string: silesia/webster | 1098490 | 5051.5 ± 6.7% | 1622.2 ± 0.7% | 1519.8 ± 8.7% | 350.7 ± 1.3% | 1181.9 ± 4.3% | 450.9 ± 1.7% | 3.114 | 3.324 | 14.404 | 4.274 | 11.203 |
| string: silesia/xml | 1090118 | 8288.8 ± 1.8% | 2671.1 ± 0.9% | 2167.9 ± 2.0% | 535.2 ± 1.0% | 1552.7 ± 0.9% | 556.7 ± 0.9% | 3.103 | 3.823 | 15.487 | 5.338 | 14.888 |
| string: canterbury/alice29.txt | 159425 | 9332.0 ± 0.4% | 2428.7 ± 4.4% | 1787.8 ± 3.4% | 337.3 ± 2.0% | 1265.6 ± 0.5% | 557.8 ± 0.6% | 3.842 | 5.220 | 27.667 | 7.374 | 16.730 |
| string: canterbury/asyoulik.txt | 132198 | 7849.6 ± 1.7% | 2164.5 ± 1.2% | 1534.8 ± 0.6% | 339.8 ± 1.2% | 1110.5 ± 2.2% | 540.6 ± 1.1% | 3.627 | 5.114 | 23.098 | 7.068 | 14.520 |
| string: canterbury/lcet10.txt | 441884 | 8728.2 ± 0.5% | 2457.6 ± 2.2% | 1972.9 ± 0.4% | 386.4 ± 0.3% | 1365.8 ± 6.9% | 553.5 ± 0.6% | 3.552 | 4.424 | 22.586 | 6.390 | 15.770 |
| string: canterbury/plrabn12.txt | 503330 | 6235.4 ± 0.6% | 1821.2 ± 2.0% | 1662.5 ± 0.2% | 361.7 ± 0.8% | 1278.3 ± 1.5% | 552.7 ± 0.8% | 3.424 | 3.751 | 17.240 | 4.878 | 11.282 |
| string: canterbury-large/E.coli | 1048578 | 38656.3 ± 0.9% | 10902.5 ± 17.3% | 3382.8 ± 1.4% | 1417.1 ± 0.8% | 2509.3 ± 0.9% | 574.2 ± 1.7% | 3.546 | 11.427 | 27.278 | 15.405 | 67.320 |
| string: canterbury-large/bible.txt | 1055886 | 7262.2 ± 0.4% | 3963.6 ± 1.0% | 2645.8 ± 0.3% | 432.3 ± 1.7% | 1845.9 ± 1.7% | 568.9 ± 2.3% | 1.832 | 2.745 | 16.799 | 3.934 | 12.764 |
| string: canterbury-large/world192.txt | 1103121 | 4739.0 ± 2.1% | 1437.5 ± 1.9% | 1559.6 ± 3.4% | 366.8 ± 0.7% | 1158.1 ± 6.8% | 539.1 ± 1.9% | 3.297 | 3.039 | 12.918 | 4.092 | 8.791 |
| string: http/html-1m | 1058582 | 8610.5 ± 0.4% | 3868.0 ± 1.2% | 2473.1 ± 0.6% | 388.6 ± 0.8% | 1797.3 ± 0.4% | 518.8 ± 0.4% | 2.226 | 3.482 | 22.158 | 4.791 | 16.599 |
| string: http/json-1m | 1190272 | 6482.9 ± 0.5% | 1226.0 ± 0.4% | 1263.5 ± 0.5% | 373.1 ± 1.4% | 888.4 ± 1.2% | 501.2 ± 2.2% | 5.288 | 5.131 | 17.375 | 7.297 | 12.935 |
| string: http/js-1m | 1144362 | 4992.0 ± 0.6% | 986.0 ± 1.0% | 1074.8 ± 1.2% | 278.6 ± 0.6% | 931.3 ± 1.6% | 474.6 ± 1.6% | 5.063 | 4.645 | 17.915 | 5.360 | 10.519 |
| string: http/css-1m | 1097820 | 6760.3 ± 1.1% | 1291.3 ± 0.6% | 1592.1 ± 0.4% | 399.7 ± 31.3% | 1041.4 ± 0.5% | 532.5 ± 1.1% | 5.235 | 4.246 | 16.911 | 6.492 | 12.696 |
| string: dickens as Cyrillic and CJK | 1883069 | 5232.7 ± 4.3% | 3024.0 ± 0.5% | 343.2 ± 0.6% | 264.4 ± 1.1% | 435.2 ± 1.4% | 290.2 ± 0.9% | 1.730 | 15.246 | 19.792 | 12.023 | 18.030 |
| hex: silesia/dickens | 524290 | 31741.5 ± 0.5% | 1572.3 ± 7.1% | 1088.6 ± 0.4% | 410.8 ± 4.7% | 997.4 ± 2.5% | 425.6 ± 1.6% | 20.188 | 29.158 | 77.264 | 31.824 | 74.580 |
| hex: silesia/mozilla | 524290 | 35375.2 ± 1.0% | 1579.7 ± 0.2% | 1090.2 ± 0.8% | 365.9 ± 2.5% | 1026.5 ± 1.4% | 429.1 ± 1.2% | 22.393 | 32.448 | 96.671 | 34.461 | 82.436 |
| hex: silesia/mr | 524290 | 33448.8 ± 0.3% | 1575.6 ± 2.0% | 1092.4 ± 0.7% | 506.3 ± 2.0% | 1009.2 ± 1.2% | 427.7 ± 1.3% | 21.230 | 30.619 | 66.070 | 33.144 | 78.201 |
| hex: silesia/nci | 524290 | 32776.5 ± 1.6% | 1556.7 ± 1.5% | 1080.9 ± 1.4% | 554.5 ± 2.2% | 991.9 ± 1.3% | 424.6 ± 1.2% | 21.055 | 30.323 | 59.111 | 33.043 | 77.186 |
| hex: silesia/ooffice | 524290 | 33620.4 ± 1.7% | 1563.1 ± 1.8% | 1088.8 ± 2.3% | 316.3 ± 1.1% | 994.1 ± 8.2% | 423.7 ± 3.3% | 21.509 | 30.877 | 106.282 | 33.821 | 79.357 |
| hex: silesia/osdb | 524290 | 35464.3 ± 0.5% | 1574.2 ± 1.2% | 1089.7 ± 0.8% | 408.4 ± 3.6% | 1006.7 ± 2.6% | 425.8 ± 0.6% | 22.528 | 32.545 | 86.841 | 35.229 | 83.289 |
| hex: silesia/reymont | 524290 | 34949.2 ± 0.8% | 1579.5 ± 0.5% | 1093.0 ± 1.0% | 430.7 ± 1.8% | 1016.0 ± 1.7% | 424.5 ± 2.0% | 22.127 | 31.976 | 81.143 | 34.398 | 82.327 |
| hex: silesia/samba | 524290 | 33730.7 ± 2.0% | 1561.3 ± 2.1% | 1090.6 ± 2.1% | 324.8 ± 3.7% | 996.8 ± 2.5% | 422.9 ± 2.8% | 21.604 | 30.928 | 103.860 | 33.839 | 79.751 |
| hex: silesia/sao | 524290 | 34324.0 ± 2.8% | 1549.8 ± 1.6% | 1088.1 ± 1.3% | 256.7 ± 1.6% | 1001.4 ± 2.0% | 423.1 ± 1.7% | 22.148 | 31.545 | 133.734 | 34.275 | 81.129 |
| hex: silesia/webster | 524290 | 37336.0 ± 1.5% | 1569.2 ± 3.5% | 1092.5 ± 1.5% | 380.7 ± 2.0% | 999.8 ± 2.3% | 423.1 ± 2.6% | 23.793 | 34.175 | 98.068 | 37.345 | 88.254 |
| hex: silesia/x-ray | 524290 | 33299.3 ± 6.8% | 1576.4 ± 1.2% | 1091.0 ± 0.6% | 383.4 ± 3.2% | 1001.5 ± 4.0% | 423.7 ± 1.3% | 21.124 | 30.521 | 86.855 | 33.251 | 78.590 |
| hex: silesia/xml | 524290 | 33406.2 ± 3.9% | 1572.2 ± 1.3% | 1092.6 ± 1.1% | 576.9 ± 2.6% | 995.1 ± 1.0% | 421.9 ± 0.8% | 21.249 | 30.574 | 57.911 | 33.570 | 79.189 |
| hex: canterbury/alice29.txt | 304180 | 33467.1 ± 1.8% | 1587.9 ± 0.5% | 1094.8 ± 0.9% | 416.1 ± 1.7% | 1019.6 ± 2.4% | 426.8 ± 1.8% | 21.076 | 30.568 | 80.439 | 32.825 | 78.420 |
| hex: canterbury/asyoulik.txt | 250360 | 32108.8 ± 1.3% | 1583.1 ± 0.7% | 1100.9 ± 0.2% | 417.1 ± 1.4% | 1042.6 ± 1.8% | 429.4 ± 2.9% | 20.283 | 29.165 | 76.985 | 30.796 | 74.783 |
| hex: canterbury/cp.html | 49208 | 32001.7 ± 0.3% | 1607.0 ± 0.2% | 1107.0 ± 0.4% | 440.9 ± 3.0% | 1049.2 ± 1.9% | 437.0 ± 1.8% | 19.914 | 28.908 | 72.579 | 30.501 | 73.234 |
| hex: canterbury/fields.c | 22302 | 32468.2 ± 0.3% | 1588.1 ± 0.8% | 1099.4 ± 0.5% | 533.9 ± 2.2% | 1029.5 ± 3.6% | 429.3 ± 1.9% | 20.445 | 29.533 | 60.815 | 31.539 | 75.633 |
| hex: canterbury/grammar.lsp | 7444 | 33443.6 ± 0.8% | 1621.7 ± 1.9% | 1115.0 ± 2.8% | 570.1 ± 3.5% | 1032.3 ± 4.6% | 432.7 ± 3.3% | 20.623 | 29.993 | 58.667 | 32.396 | 77.293 |
| hex: canterbury/kennedy.xls | 524290 | 31468.9 ± 1.6% | 1560.8 ± 0.7% | 1088.4 ± 0.9% | 575.8 ± 1.7% | 982.5 ± 1.3% | 419.1 ± 2.0% | 20.162 | 28.913 | 54.651 | 32.030 | 75.091 |
| hex: canterbury/lcet10.txt | 524290 | 34702.3 ± 1.5% | 1563.3 ± 3.4% | 1084.8 ± 1.9% | 403.9 ± 1.7% | 998.6 ± 1.0% | 420.1 ± 2.2% | 22.197 | 31.989 | 85.911 | 34.753 | 82.606 |
| hex: canterbury/plrabn12.txt | 524290 | 33337.8 ± 1.8% | 1557.6 ± 1.1% | 1082.2 ± 6.1% | 401.0 ± 1.0% | 991.8 ± 2.8% | 418.9 ± 2.1% | 21.403 | 30.805 | 83.144 | 33.612 | 79.588 |
| hex: canterbury/ptt5 | 524290 | 33455.5 ± 4.7% | 1572.3 ± 1.9% | 1089.8 ± 7.4% | 486.4 ± 3.6% | 992.3 ± 1.6% | 420.7 ± 3.1% | 21.279 | 30.699 | 68.778 | 33.714 | 79.530 |
| hex: canterbury/sum | 76482 | 34990.0 ± 2.6% | 1589.2 ± 2.5% | 1086.6 ± 2.7% | 482.9 ± 2.4% | 1020.8 ± 1.5% | 430.9 ± 3.6% | 22.017 | 32.200 | 72.461 | 34.276 | 81.206 |
| hex: canterbury/xargs.1 | 8456 | 34880.7 ± 3.2% | 1627.8 ± 0.9% | 1111.2 ± 1.7% | 610.4 ± 4.6% | 1038.3 ± 2.2% | 435.1 ± 1.5% | 21.428 | 31.389 | 57.148 | 33.593 | 80.165 |
| hex: canterbury-large/E.coli | 524290 | 30498.5 ± 0.8% | 1563.1 ± 1.1% | 1087.7 ± 0.8% | 597.2 ± 3.7% | 1015.2 ± 5.5% | 425.3 ± 2.1% | 19.512 | 28.041 | 51.073 | 30.040 | 71.704 |
| hex: canterbury-large/bible.txt | 524290 | 35815.9 ± 0.9% | 1578.1 ± 1.2% | 1094.6 ± 0.3% | 434.4 ± 2.3% | 1025.7 ± 2.7% | 431.9 ± 2.9% | 22.696 | 32.721 | 82.440 | 34.919 | 82.928 |
| hex: canterbury-large/world192.txt | 524290 | 35622.1 ± 0.4% | 1576.0 ± 4.0% | 1092.0 ± 0.5% | 412.1 ± 0.7% | 1012.1 ± 0.4% | 426.2 ± 1.8% | 22.603 | 32.622 | 86.450 | 35.196 | 83.575 |
| hex: http/html-1kx1024 | 2099200 | 24573.2 ± 0.8% | 1609.4 ± 0.6% | 1087.0 ± 0.6% | 439.1 ± 3.1% | 1031.8 ± 2.5% | 429.4 ± 1.5% | 15.268 | 22.607 | 55.966 | 23.816 | 57.221 |
| hex: http/html-16kx64 | 2097280 | 30295.4 ± 0.3% | 1594.1 ± 0.7% | 1099.4 ± 0.3% | 436.9 ± 2.8% | 1027.6 ± 4.2% | 432.3 ± 1.9% | 19.005 | 27.557 | 69.337 | 29.483 | 70.080 |
| hex: http/html-1m | 524290 | 29217.5 ± 9.4% | 1559.5 ± 6.6% | 1090.1 ± 0.4% | 435.5 ± 1.4% | 996.0 ± 1.0% | 424.6 ± 1.7% | 18.735 | 26.803 | 67.084 | 29.334 | 68.813 |
| hex: http/json-1kx1024 | 2099200 | 23848.6 ± 7.2% | 1609.4 ± 1.3% | 1089.2 ± 0.1% | 550.0 ± 2.6% | 1024.9 ± 1.6% | 428.7 ± 0.8% | 14.819 | 21.895 | 43.363 | 23.269 | 55.636 |
| hex: http/json-16kx64 | 2097280 | 30224.2 ± 1.6% | 1574.3 ± 2.7% | 1098.4 ± 0.9% | 527.1 ± 3.2% | 961.9 ± 1.9% | 428.0 ± 1.2% | 19.198 | 27.515 | 57.336 | 31.420 | 70.624 |
| hex: http/json-1m | 524290 | 31910.6 ± 0.5% | 1563.1 ± 0.5% | 1087.3 ± 0.9% | 582.3 ± 2.4% | 996.3 ± 3.8% | 421.6 ± 7.7% | 20.415 | 29.350 | 54.802 | 32.029 | 75.695 |
| hex: http/js-1kx1024 | 2099200 | 24470.9 ± 0.8% | 1610.7 ± 0.4% | 1089.9 ± 0.2% | 433.7 ± 10.1% | 1051.1 ± 2.0% | 437.2 ± 1.1% | 15.193 | 22.451 | 56.427 | 23.282 | 55.977 |
| hex: http/js-16kx64 | 2097280 | 30503.7 ± 0.4% | 1597.8 ± 1.6% | 1100.7 ± 1.4% | 413.6 ± 2.8% | 974.5 ± 2.2% | 434.4 ± 2.8% | 19.091 | 27.714 | 73.747 | 31.301 | 70.217 |
| hex: http/js-1m | 524290 | 30270.3 ± 2.3% | 1569.4 ± 1.8% | 1084.2 ± 1.4% | 418.2 ± 2.9% | 986.3 ± 2.8% | 423.6 ± 1.6% | 19.288 | 27.920 | 72.385 | 30.689 | 71.454 |
| hex: http/css-1kx1024 | 2099200 | 23826.9 ± 2.1% | 1586.0 ± 5.6% | 1076.6 ± 0.5% | 476.1 ± 3.8% | 1010.5 ± 4.2% | 423.0 ± 2.8% | 15.023 | 22.131 | 50.050 | 23.580 | 56.333 |
| hex: http/css-16kx64 | 2097280 | 30198.8 ± 2.7% | 1579.4 ± 2.7% | 1095.7 ± 2.1% | 483.0 ± 5.0% | 1018.3 ± 4.5% | 425.9 ± 2.7% | 19.121 | 27.562 | 62.520 | 29.655 | 70.914 |
| hex: http/css-1m | 524290 | 31724.3 ± 3.1% | 1570.3 ± 0.8% | 1087.9 ± 1.2% | 436.7 ± 1.2% | 972.3 ± 3.8% | 424.5 ± 1.2% | 20.203 | 29.162 | 72.648 | 32.628 | 74.734 |
| hex: shuffled/dickens-1m | 524290 | 35320.0 ± 0.7% | 1575.7 ± 1.9% | 1091.3 ± 0.6% | 422.2 ± 3.9% | 1010.1 ± 10.3% | 426.5 ± 2.9% | 22.415 | 32.365 | 83.664 | 34.968 | 82.809 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 827.0 ± 5.3% | 987.1 ± 2.7% | 930.5 ± 2.2% | 286.9 ± 1.0% | 528.0 ± 1.0% | 246.6 ± 4.7% | 0.838 | 0.889 | 2.882 | 1.566 | 3.354 |
| qlog records, JSON text sequence | 1467503 | 659.1 ± 26.6% | 797.6 ± 0.5% | 670.3 ± 32.2% | 211.8 ± 2.7% | 431.6 ± 14.9% | 202.5 ± 4.5% | 0.826 | 0.983 | 3.112 | 1.527 | 3.256 |
| string: silesia/dickens | 172528 | 5478.4 ± 2.5% | 2891.8 ± 0.8% | 2018.4 ± 1.4% | 302.3 ± 8.3% | 2173.7 ± 0.6% | 436.4 ± 9.7% | 1.894 | 2.714 | 18.120 | 2.520 | 12.555 |
| string: silesia/nci | 1075110 | 5282.4 ± 0.5% | 3478.9 ± 0.4% | 2792.8 ± 1.2% | 502.4 ± 1.4% | 2412.6 ± 1.0% | 517.9 ± 1.1% | 1.518 | 1.891 | 10.515 | 2.189 | 10.201 |
| string: silesia/reymont | 1075159 | 2791.8 ± 3.9% | 2182.4 ± 0.5% | 1763.2 ± 2.6% | 318.5 ± 0.4% | 1630.7 ± 1.4% | 466.6 ± 2.6% | 1.279 | 1.583 | 8.765 | 1.712 | 5.984 |
| string: silesia/samba | 97582 | 3353.0 ± 0.9% | 2837.2 ± 10.3% | 1695.5 ± 9.5% | 262.1 ± 0.8% | 1280.6 ± 0.5% | 339.2 ± 2.5% | 1.182 | 1.978 | 12.791 | 2.618 | 9.885 |
| string: silesia/webster | 1098490 | 3665.0 ± 1.6% | 2024.5 ± 1.0% | 1606.3 ± 1.9% | 305.6 ± 1.1% | 1665.8 ± 1.0% | 421.0 ± 2.2% | 1.810 | 2.282 | 11.994 | 2.200 | 8.705 |
| string: silesia/xml | 1090118 | 5091.5 ± 1.9% | 3671.8 ± 0.6% | 2091.0 ± 2.7% | 403.5 ± 0.6% | 2338.9 ± 15.4% | 497.7 ± 5.2% | 1.387 | 2.435 | 12.620 | 2.177 | 10.231 |
| string: canterbury/alice29.txt | 159425 | 4444.7 ± 2.1% | 2347.1 ± 1.8% | 1790.3 ± 2.0% | 282.6 ± 2.7% | 1890.0 ± 1.5% | 416.1 ± 16.0% | 1.894 | 2.483 | 15.728 | 2.352 | 10.681 |
| string: canterbury/asyoulik.txt | 132198 | 3860.7 ± 3.9% | 2107.5 ± 0.3% | 1445.2 ± 3.4% | 272.1 ± 1.9% | 1586.9 ± 2.7% | 369.6 ± 8.5% | 1.832 | 2.671 | 14.189 | 2.433 | 10.446 |
| string: canterbury/lcet10.txt | 441884 | 5489.8 ± 1.3% | 2795.1 ± 0.3% | 1953.3 ± 2.6% | 324.5 ± 0.8% | 2126.9 ± 1.6% | 457.3 ± 4.5% | 1.964 | 2.810 | 16.919 | 2.581 | 12.004 |
| string: canterbury/plrabn12.txt | 503330 | 4417.1 ± 2.7% | 2696.0 ± 0.6% | 1647.1 ± 1.5% | 296.9 ± 1.0% | 2000.9 ± 1.2% | 430.6 ± 2.5% | 1.638 | 2.682 | 14.879 | 2.208 | 10.258 |
| string: canterbury-large/E.coli | 1048578 | 33638.6 ± 0.4% | 7751.7 ± 1.1% | 3487.8 ± 0.5% | 800.3 ± 0.3% | 5485.0 ± 0.6% | 767.7 ± 3.2% | 4.340 | 9.645 | 42.032 | 6.133 | 43.818 |
| string: canterbury-large/bible.txt | 1055886 | 6625.9 ± 1.1% | 3894.5 ± 0.4% | 2508.2 ± 1.8% | 350.9 ± 1.2% | 2972.8 ± 0.4% | 583.6 ± 3.4% | 1.701 | 2.642 | 18.880 | 2.229 | 11.353 |
| string: canterbury-large/world192.txt | 1103121 | 3468.1 ± 0.5% | 1977.9 ± 0.4% | 1609.7 ± 9.9% | 296.0 ± 6.4% | 1686.0 ± 0.8% | 424.6 ± 1.6% | 1.753 | 2.154 | 11.716 | 2.057 | 8.169 |
| string: http/html-1m | 1058582 | 6215.8 ± 1.5% | 3401.1 ± 0.9% | 2340.4 ± 7.4% | 407.7 ± 0.2% | 2731.8 ± 2.3% | 420.2 ± 1.0% | 1.828 | 2.656 | 15.246 | 2.275 | 14.794 |
| string: http/json-1m | 1190272 | 3350.7 ± 0.5% | 1195.3 ± 1.1% | 1394.9 ± 6.1% | 354.5 ± 1.8% | 819.0 ± 1.0% | 291.0 ± 1.9% | 2.803 | 2.402 | 9.451 | 4.091 | 11.514 |
| string: http/js-1m | 1144362 | 2262.6 ± 5.7% | 1321.0 ± 0.4% | 1148.1 ± 4.2% | 278.4 ± 4.0% | 1160.1 ± 0.8% | 289.1 ± 1.4% | 1.713 | 1.971 | 8.128 | 1.950 | 7.825 |
| string: http/css-1m | 1097820 | 3016.9 ± 7.6% | 2497.6 ± 1.2% | 1525.2 ± 1.6% | 372.2 ± 0.4% | 1494.9 ± 0.6% | 320.5 ± 2.3% | 1.208 | 1.978 | 8.106 | 2.018 | 9.414 |
| string: dickens as Cyrillic and CJK | 1883069 | 5212.6 ± 2.2% | 3203.2 ± 1.1% | 640.1 ± 0.9% | 256.7 ± 6.9% | 499.7 ± 3.1% | 139.4 ± 3.3% | 1.627 | 8.144 | 20.308 | 10.432 | 37.399 |
| string: dickens as Cyrillic and CJK, as \u escapes | 5075485 | 1059.4 ± 3.9% | 1068.4 ± 0.9% | 796.5 ± 1.1% | 161.2 ± 7.2% | 384.3 ± 0.7% | 198.5 ± 3.2% | 0.992 | 1.330 | 6.571 | 2.757 | 5.338 |
| hex: silesia/dickens | 524290 | 33737.3 ± 3.3% | 7726.9 ± 0.4% | 3478.4 ± 1.0% | 467.7 ± 1.8% | 5506.8 ± 0.3% | 758.5 ± 4.0% | 4.366 | 9.699 | 72.139 | 6.126 | 44.480 |
| hex: silesia/mozilla | 524290 | 33446.7 ± 0.3% | 7737.7 ± 0.8% | 3496.3 ± 0.8% | 408.9 ± 2.1% | 5486.1 ± 1.5% | 762.4 ± 2.4% | 4.323 | 9.566 | 81.791 | 6.097 | 43.872 |
| hex: silesia/mr | 524290 | 33317.4 ± 0.4% | 7742.1 ± 0.4% | 3504.8 ± 0.6% | 580.9 ± 0.3% | 5489.2 ± 0.7% | 761.4 ± 3.5% | 4.303 | 9.506 | 57.356 | 6.070 | 43.756 |
| hex: silesia/nci | 524290 | 33402.2 ± 11.1% | 7750.9 ± 1.2% | 3481.4 ± 1.0% | 644.7 ± 0.2% | 5468.3 ± 0.6% | 768.6 ± 1.4% | 4.309 | 9.594 | 51.812 | 6.108 | 43.461 |
| hex: silesia/ooffice | 524290 | 33249.5 ± 0.9% | 7734.8 ± 0.5% | 3488.2 ± 1.1% | 355.6 ± 0.7% | 5466.3 ± 6.4% | 771.0 ± 0.8% | 4.299 | 9.532 | 93.506 | 6.083 | 43.124 |
| hex: silesia/osdb | 524290 | 33408.1 ± 0.2% | 7745.1 ± 0.5% | 3493.4 ± 1.7% | 453.7 ± 1.7% | 5479.8 ± 0.3% | 764.7 ± 3.1% | 4.313 | 9.563 | 73.642 | 6.097 | 43.690 |
| hex: silesia/reymont | 524290 | 33433.9 ± 0.3% | 7749.0 ± 0.3% | 3467.9 ± 0.2% | 473.6 ± 4.6% | 5482.2 ± 0.7% | 771.6 ± 1.9% | 4.315 | 9.641 | 70.589 | 6.099 | 43.332 |
| hex: silesia/samba | 524290 | 33682.9 ± 1.0% | 7758.3 ± 14.4% | 3498.7 ± 1.7% | 353.9 ± 6.4% | 5503.3 ± 0.4% | 765.5 ± 2.1% | 4.342 | 9.627 | 95.171 | 6.121 | 44.001 |
| hex: silesia/sao | 524290 | 33391.6 ± 0.4% | 7776.6 ± 0.4% | 3475.3 ± 0.7% | 284.3 ± 1.6% | 5478.7 ± 20.2% | 759.2 ± 1.4% | 4.294 | 9.608 | 117.441 | 6.095 | 43.983 |
| hex: silesia/webster | 524290 | 33317.8 ± 0.6% | 7777.4 ± 0.4% | 3495.9 ± 0.8% | 431.2 ± 1.8% | 5452.8 ± 0.7% | 765.7 ± 1.7% | 4.284 | 9.530 | 77.270 | 6.110 | 43.515 |
| hex: silesia/x-ray | 524290 | 33172.0 ± 12.9% | 7766.0 ± 0.2% | 3474.9 ± 0.4% | 422.1 ± 0.9% | 5455.6 ± 1.6% | 767.7 ± 1.6% | 4.271 | 9.546 | 78.586 | 6.080 | 43.208 |
| hex: silesia/xml | 524290 | 33337.8 ± 2.2% | 7740.0 ± 1.9% | 3482.6 ± 0.9% | 602.3 ± 1.6% | 5499.7 ± 0.8% | 766.2 ± 1.1% | 4.307 | 9.573 | 55.351 | 6.062 | 43.512 |
| hex: canterbury/alice29.txt | 304180 | 33795.5 ± 4.0% | 7742.8 ± 0.8% | 3482.0 ± 1.3% | 455.1 ± 1.7% | 5407.5 ± 1.0% | 763.4 ± 1.7% | 4.365 | 9.706 | 74.265 | 6.250 | 44.267 |
| hex: canterbury/asyoulik.txt | 250360 | 33738.0 ± 3.4% | 7781.2 ± 1.5% | 3485.1 ± 1.4% | 441.2 ± 6.2% | 5412.2 ± 1.0% | 775.8 ± 1.1% | 4.336 | 9.681 | 76.473 | 6.234 | 43.488 |
| hex: canterbury/cp.html | 49208 | 32698.2 ± 4.4% | 7771.3 ± 0.4% | 3506.1 ± 1.2% | 461.5 ± 2.8% | 5429.9 ± 1.9% | 760.2 ± 4.4% | 4.208 | 9.326 | 70.847 | 6.022 | 43.013 |
| hex: canterbury/fields.c | 22302 | 31655.7 ± 0.2% | 7696.0 ± 0.5% | 3522.2 ± 1.2% | 484.0 ± 5.3% | 5386.4 ± 1.9% | 740.1 ± 6.1% | 4.113 | 8.987 | 65.407 | 5.877 | 42.770 |
| hex: canterbury/grammar.lsp | 7444 | 27497.2 ± 0.3% | 7483.3 ± 2.0% | 3569.2 ± 0.5% | 537.4 ± 2.5% | 5317.6 ± 0.6% | 723.4 ± 6.7% | 3.675 | 7.704 | 51.172 | 5.171 | 38.009 |
| hex: canterbury/kennedy.xls | 524290 | 33643.2 ± 0.8% | 7737.3 ± 0.8% | 3507.2 ± 0.7% | 684.6 ± 1.1% | 5487.4 ± 0.3% | 760.0 ± 5.6% | 4.348 | 9.593 | 49.146 | 6.131 | 44.266 |
| hex: canterbury/lcet10.txt | 524290 | 33337.7 ± 1.0% | 7763.8 ± 0.3% | 3485.8 ± 1.8% | 455.9 ± 11.0% | 5470.3 ± 0.3% | 760.4 ± 2.8% | 4.294 | 9.564 | 73.127 | 6.094 | 43.843 |
| hex: canterbury/plrabn12.txt | 524290 | 33623.0 ± 0.4% | 7741.5 ± 0.5% | 3502.1 ± 1.9% | 457.4 ± 3.8% | 5476.1 ± 0.9% | 770.9 ± 4.2% | 4.343 | 9.601 | 73.513 | 6.140 | 43.617 |
| hex: canterbury/ptt5 | 524290 | 33429.1 ± 0.4% | 7750.6 ± 1.0% | 3486.3 ± 0.9% | 564.5 ± 13.5% | 5481.6 ± 0.6% | 776.8 ± 4.1% | 4.313 | 9.589 | 59.219 | 6.098 | 43.036 |
| hex: canterbury/sum | 76482 | 33234.8 ± 0.3% | 7788.1 ± 0.3% | 3516.6 ± 0.8% | 527.7 ± 0.4% | 5465.6 ± 1.8% | 769.3 ± 9.1% | 4.267 | 9.451 | 62.979 | 6.081 | 43.203 |
| hex: canterbury/xargs.1 | 8456 | 28096.8 ± 0.5% | 7518.6 ± 0.2% | 3558.4 ± 0.2% | 526.0 ± 3.7% | 5343.2 ± 1.0% | 755.6 ± 2.1% | 3.737 | 7.896 | 53.417 | 5.258 | 37.186 |
| hex: canterbury-large/E.coli | 524290 | 33648.0 ± 0.6% | 7697.3 ± 8.5% | 3483.4 ± 0.7% | 710.5 ± 0.4% | 5467.7 ± 4.7% | 754.0 ± 10.9% | 4.371 | 9.660 | 47.357 | 6.154 | 44.624 |
| hex: canterbury-large/bible.txt | 524290 | 33419.7 ± 0.4% | 7707.0 ± 0.5% | 3480.8 ± 0.8% | 486.3 ± 4.2% | 5478.9 ± 1.2% | 770.4 ± 5.1% | 4.336 | 9.601 | 68.717 | 6.100 | 43.382 |
| hex: canterbury-large/world192.txt | 524290 | 33733.1 ± 0.7% | 7734.1 ± 0.5% | 3497.7 ± 0.8% | 445.3 ± 2.5% | 5485.9 ± 0.6% | 762.1 ± 3.3% | 4.362 | 9.644 | 75.758 | 6.149 | 44.265 |
| hex: http/html-1kx1024 | 2099200 | 16780.1 ± 1.0% | 6625.5 ± 3.7% | 3212.3 ± 6.6% | 479.3 ± 1.4% | 4673.0 ± 2.9% | 650.5 ± 5.3% | 2.533 | 5.224 | 35.008 | 3.591 | 25.797 |
| hex: http/html-16kx64 | 2097280 | 30711.1 ± 0.4% | 7649.2 ± 0.5% | 3452.6 ± 0.5% | 494.2 ± 0.4% | 5405.9 ± 0.7% | 745.4 ± 3.7% | 4.015 | 8.895 | 62.148 | 5.681 | 41.201 |
| hex: http/html-1m | 524290 | 33594.1 ± 1.5% | 7716.4 ± 0.5% | 3489.5 ± 0.4% | 492.7 ± 0.9% | 5485.5 ± 7.2% | 748.7 ± 4.3% | 4.354 | 9.627 | 68.182 | 6.124 | 44.870 |
| hex: http/json-1kx1024 | 2099200 | 16847.5 ± 1.8% | 6628.6 ± 0.7% | 3217.5 ± 1.1% | 617.3 ± 1.3% | 4710.6 ± 1.2% | 671.9 ± 3.6% | 2.542 | 5.236 | 27.293 | 3.577 | 25.076 |
| hex: http/json-16kx64 | 2097280 | 30638.3 ± 1.2% | 7646.9 ± 2.1% | 3450.7 ± 2.2% | 631.1 ± 15.8% | 5421.2 ± 1.1% | 752.4 ± 5.1% | 4.007 | 8.879 | 48.547 | 5.652 | 40.719 |
| hex: http/json-1m | 524290 | 33374.6 ± 0.7% | 7707.5 ± 1.1% | 3488.8 ± 0.4% | 642.3 ± 0.3% | 5469.0 ± 0.5% | 761.6 ± 4.4% | 4.330 | 9.566 | 51.962 | 6.102 | 43.819 |
| hex: http/js-1kx1024 | 2099200 | 16804.8 ± 1.4% | 6612.2 ± 0.8% | 3184.4 ± 1.6% | 460.3 ± 4.5% | 4592.0 ± 2.8% | 620.5 ± 5.7% | 2.542 | 5.277 | 36.505 | 3.660 | 27.082 |
| hex: http/js-16kx64 | 2097280 | 30684.7 ± 0.8% | 7608.4 ± 0.9% | 3430.8 ± 1.1% | 463.1 ± 9.9% | 5398.0 ± 0.7% | 714.9 ± 5.6% | 4.033 | 8.944 | 66.254 | 5.684 | 42.919 |
| hex: http/js-1m | 524290 | 33667.9 ± 0.5% | 7717.4 ± 0.6% | 3485.2 ± 0.9% | 490.8 ± 2.4% | 5468.0 ± 0.5% | 769.4 ± 8.1% | 4.363 | 9.660 | 68.600 | 6.157 | 43.761 |
| hex: http/css-1kx1024 | 2099200 | 16614.5 ± 13.1% | 6626.9 ± 0.4% | 3191.8 ± 1.5% | 521.5 ± 3.3% | 4582.5 ± 11.2% | 626.3 ± 4.0% | 2.507 | 5.205 | 31.859 | 3.626 | 26.529 |
| hex: http/css-16kx64 | 2097280 | 30624.3 ± 3.3% | 7637.7 ± 1.2% | 3435.2 ± 8.3% | 548.3 ± 0.8% | 5400.0 ± 0.8% | 715.1 ± 5.9% | 4.010 | 8.915 | 55.853 | 5.671 | 42.824 |
| hex: http/css-1m | 524290 | 33560.8 ± 1.8% | 7772.1 ± 0.5% | 3486.0 ± 0.7% | 532.6 ± 0.3% | 5450.1 ± 0.8% | 767.3 ± 5.3% | 4.318 | 9.627 | 63.010 | 6.158 | 43.740 |
| hex: shuffled/dickens-1m | 524290 | 33348.4 ± 0.5% | 7776.2 ± 1.3% | 3477.1 ± 0.6% | 456.5 ± 3.1% | 5467.7 ± 1.6% | 758.0 ± 5.4% | 4.289 | 9.591 | 73.050 | 6.099 | 43.994 |

## TextReader.next_items against the baselines

stdx's decoder a slice of tokens a call through `TextReader.next_items`, as a caller that reads a text's values in a loop calls it (decision 79). Octets are the text's. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 979.9 ± 3.0% | 987.1 ± 2.7% | 930.5 ± 2.2% | 286.9 ± 1.0% | 528.0 ± 1.0% | 246.6 ± 4.7% | 0.993 | 1.053 | 3.415 | 1.856 | 3.974 |
| qlog records, JSON text sequence | 1467503 | 793.8 ± 35.8% | 797.6 ± 0.5% | 670.3 ± 32.2% | 211.8 ± 2.7% | 431.6 ± 14.9% | 202.5 ± 4.5% | 0.995 | 1.184 | 3.748 | 1.839 | 3.921 |
| string: silesia/dickens | 172528 | 5471.7 ± 5.3% | 2891.8 ± 0.8% | 2018.4 ± 1.4% | 302.3 ± 8.3% | 2173.7 ± 0.6% | 436.4 ± 9.7% | 1.892 | 2.711 | 18.098 | 2.517 | 12.539 |
| string: silesia/nci | 1075110 | 5292.0 ± 3.4% | 3478.9 ± 0.4% | 2792.8 ± 1.2% | 502.4 ± 1.4% | 2412.6 ± 1.0% | 517.9 ± 1.1% | 1.521 | 1.895 | 10.534 | 2.193 | 10.219 |
| string: silesia/reymont | 1075159 | 2783.2 ± 0.8% | 2182.4 ± 0.5% | 1763.2 ± 2.6% | 318.5 ± 0.4% | 1630.7 ± 1.4% | 466.6 ± 2.6% | 1.275 | 1.579 | 8.738 | 1.707 | 5.965 |
| string: silesia/samba | 97582 | 3362.7 ± 0.3% | 2837.2 ± 10.3% | 1695.5 ± 9.5% | 262.1 ± 0.8% | 1280.6 ± 0.5% | 339.2 ± 2.5% | 1.185 | 1.983 | 12.828 | 2.626 | 9.913 |
| string: silesia/webster | 1098490 | 3673.9 ± 0.5% | 2024.5 ± 1.0% | 1606.3 ± 1.9% | 305.6 ± 1.1% | 1665.8 ± 1.0% | 421.0 ± 2.2% | 1.815 | 2.287 | 12.023 | 2.205 | 8.727 |
| string: silesia/xml | 1090118 | 5073.6 ± 0.4% | 3671.8 ± 0.6% | 2091.0 ± 2.7% | 403.5 ± 0.6% | 2338.9 ± 15.4% | 497.7 ± 5.2% | 1.382 | 2.426 | 12.575 | 2.169 | 10.195 |
| string: canterbury/alice29.txt | 159425 | 4388.3 ± 3.2% | 2347.1 ± 1.8% | 1790.3 ± 2.0% | 282.6 ± 2.7% | 1890.0 ± 1.5% | 416.1 ± 16.0% | 1.870 | 2.451 | 15.529 | 2.322 | 10.545 |
| string: canterbury/asyoulik.txt | 132198 | 3801.6 ± 1.5% | 2107.5 ± 0.3% | 1445.2 ± 3.4% | 272.1 ± 1.9% | 1586.9 ± 2.7% | 369.6 ± 8.5% | 1.804 | 2.630 | 13.972 | 2.396 | 10.286 |
| string: canterbury/lcet10.txt | 441884 | 5686.4 ± 0.6% | 2795.1 ± 0.3% | 1953.3 ± 2.6% | 324.5 ± 0.8% | 2126.9 ± 1.6% | 457.3 ± 4.5% | 2.034 | 2.911 | 17.525 | 2.673 | 12.434 |
| string: canterbury/plrabn12.txt | 503330 | 4420.1 ± 0.2% | 2696.0 ± 0.6% | 1647.1 ± 1.5% | 296.9 ± 1.0% | 2000.9 ± 1.2% | 430.6 ± 2.5% | 1.640 | 2.684 | 14.889 | 2.209 | 10.265 |
| string: canterbury-large/E.coli | 1048578 | 33559.8 ± 7.5% | 7751.7 ± 1.1% | 3487.8 ± 0.5% | 800.3 ± 0.3% | 5485.0 ± 0.6% | 767.7 ± 3.2% | 4.329 | 9.622 | 41.934 | 6.118 | 43.715 |
| string: canterbury-large/bible.txt | 1055886 | 6632.6 ± 2.3% | 3894.5 ± 0.4% | 2508.2 ± 1.8% | 350.9 ± 1.2% | 2972.8 ± 0.4% | 583.6 ± 3.4% | 1.703 | 2.644 | 18.899 | 2.231 | 11.365 |
| string: canterbury-large/world192.txt | 1103121 | 3457.8 ± 0.6% | 1977.9 ± 0.4% | 1609.7 ± 9.9% | 296.0 ± 6.4% | 1686.0 ± 0.8% | 424.6 ± 1.6% | 1.748 | 2.148 | 11.681 | 2.051 | 8.145 |
| string: http/html-1m | 1058582 | 6239.7 ± 0.4% | 3401.1 ± 0.9% | 2340.4 ± 7.4% | 407.7 ± 0.2% | 2731.8 ± 2.3% | 420.2 ± 1.0% | 1.835 | 2.666 | 15.305 | 2.284 | 14.851 |
| string: http/json-1m | 1190272 | 3351.4 ± 0.5% | 1195.3 ± 1.1% | 1394.9 ± 6.1% | 354.5 ± 1.8% | 819.0 ± 1.0% | 291.0 ± 1.9% | 2.804 | 2.403 | 9.453 | 4.092 | 11.516 |
| string: http/js-1m | 1144362 | 2268.3 ± 1.2% | 1321.0 ± 0.4% | 1148.1 ± 4.2% | 278.4 ± 4.0% | 1160.1 ± 0.8% | 289.1 ± 1.4% | 1.717 | 1.976 | 8.149 | 1.955 | 7.845 |
| string: http/css-1m | 1097820 | 3021.6 ± 4.6% | 2497.6 ± 1.2% | 1525.2 ± 1.6% | 372.2 ± 0.4% | 1494.9 ± 0.6% | 320.5 ± 2.3% | 1.210 | 1.981 | 8.119 | 2.021 | 9.429 |
| string: dickens as Cyrillic and CJK | 1883069 | 5219.3 ± 0.6% | 3203.2 ± 1.1% | 640.1 ± 0.9% | 256.7 ± 6.9% | 499.7 ± 3.1% | 139.4 ± 3.3% | 1.629 | 8.154 | 20.334 | 10.445 | 37.447 |
| string: dickens as Cyrillic and CJK, as \u escapes | 5075485 | 1061.5 ± 0.7% | 1068.4 ± 0.9% | 796.5 ± 1.1% | 161.2 ± 7.2% | 384.3 ± 0.7% | 198.5 ± 3.2% | 0.993 | 1.333 | 6.584 | 2.762 | 5.349 |
| hex: silesia/dickens | 524290 | 33687.2 ± 0.3% | 7726.9 ± 0.4% | 3478.4 ± 1.0% | 467.7 ± 1.8% | 5506.8 ± 0.3% | 758.5 ± 4.0% | 4.360 | 9.685 | 72.032 | 6.117 | 44.414 |
| hex: silesia/mozilla | 524290 | 33571.6 ± 0.4% | 7737.7 ± 0.8% | 3496.3 ± 0.8% | 408.9 ± 2.1% | 5486.1 ± 1.5% | 762.4 ± 2.4% | 4.339 | 9.602 | 82.097 | 6.119 | 44.036 |
| hex: silesia/mr | 524290 | 33322.8 ± 0.3% | 7742.1 ± 0.4% | 3504.8 ± 0.6% | 580.9 ± 0.3% | 5489.2 ± 0.7% | 761.4 ± 3.5% | 4.304 | 9.508 | 57.365 | 6.071 | 43.763 |
| hex: silesia/nci | 524290 | 33452.4 ± 2.2% | 7750.9 ± 1.2% | 3481.4 ± 1.0% | 644.7 ± 0.2% | 5468.3 ± 0.6% | 768.6 ± 1.4% | 4.316 | 9.609 | 51.890 | 6.118 | 43.526 |
| hex: silesia/ooffice | 524290 | 33175.7 ± 0.4% | 7734.8 ± 0.5% | 3488.2 ± 1.1% | 355.6 ± 0.7% | 5466.3 ± 6.4% | 771.0 ± 0.8% | 4.289 | 9.511 | 93.299 | 6.069 | 43.029 |
| hex: silesia/osdb | 524290 | 33382.7 ± 0.3% | 7745.1 ± 0.5% | 3493.4 ± 1.7% | 453.7 ± 1.7% | 5479.8 ± 0.3% | 764.7 ± 3.1% | 4.310 | 9.556 | 73.586 | 6.092 | 43.657 |
| hex: silesia/reymont | 524290 | 33528.6 ± 0.2% | 7749.0 ± 0.3% | 3467.9 ± 0.2% | 473.6 ± 4.6% | 5482.2 ± 0.7% | 771.6 ± 1.9% | 4.327 | 9.668 | 70.789 | 6.116 | 43.455 |
| hex: silesia/samba | 524290 | 33665.9 ± 0.4% | 7758.3 ± 14.4% | 3498.7 ± 1.7% | 353.9 ± 6.4% | 5503.3 ± 0.4% | 765.5 ± 2.1% | 4.339 | 9.622 | 95.123 | 6.117 | 43.978 |
| hex: silesia/sao | 524290 | 33449.4 ± 0.4% | 7776.6 ± 0.4% | 3475.3 ± 0.7% | 284.3 ± 1.6% | 5478.7 ± 20.2% | 759.2 ± 1.4% | 4.301 | 9.625 | 117.644 | 6.105 | 44.059 |
| hex: silesia/webster | 524290 | 33353.0 ± 0.6% | 7777.4 ± 0.4% | 3495.9 ± 0.8% | 431.2 ± 1.8% | 5452.8 ± 0.7% | 765.7 ± 1.7% | 4.288 | 9.541 | 77.351 | 6.117 | 43.561 |
| hex: silesia/x-ray | 524290 | 33472.3 ± 1.7% | 7766.0 ± 0.2% | 3474.9 ± 0.4% | 422.1 ± 0.9% | 5455.6 ± 1.6% | 767.7 ± 1.6% | 4.310 | 9.633 | 79.297 | 6.135 | 43.599 |
| hex: silesia/xml | 524290 | 33277.1 ± 7.8% | 7740.0 ± 1.9% | 3482.6 ± 0.9% | 602.3 ± 1.6% | 5499.7 ± 0.8% | 766.2 ± 1.1% | 4.299 | 9.555 | 55.250 | 6.051 | 43.433 |
| hex: canterbury/alice29.txt | 304180 | 33790.3 ± 0.5% | 7742.8 ± 0.8% | 3482.0 ± 1.3% | 455.1 ± 1.7% | 5407.5 ± 1.0% | 763.4 ± 1.7% | 4.364 | 9.704 | 74.254 | 6.249 | 44.260 |
| hex: canterbury/asyoulik.txt | 250360 | 33812.8 ± 0.2% | 7781.2 ± 1.5% | 3485.1 ± 1.4% | 441.2 ± 6.2% | 5412.2 ± 1.0% | 775.8 ± 1.1% | 4.345 | 9.702 | 76.642 | 6.248 | 43.584 |
| hex: canterbury/cp.html | 49208 | 32849.5 ± 0.3% | 7771.3 ± 0.4% | 3506.1 ± 1.2% | 461.5 ± 2.8% | 5429.9 ± 1.9% | 760.2 ± 4.4% | 4.227 | 9.369 | 71.175 | 6.050 | 43.212 |
| hex: canterbury/fields.c | 22302 | 31723.6 ± 15.5% | 7696.0 ± 0.5% | 3522.2 ± 1.2% | 484.0 ± 5.3% | 5386.4 ± 1.9% | 740.1 ± 6.1% | 4.122 | 9.007 | 65.547 | 5.890 | 42.862 |
| hex: canterbury/grammar.lsp | 7444 | 27664.0 ± 0.4% | 7483.3 ± 2.0% | 3569.2 ± 0.5% | 537.4 ± 2.5% | 5317.6 ± 0.6% | 723.4 ± 6.7% | 3.697 | 7.751 | 51.482 | 5.202 | 38.239 |
| hex: canterbury/kennedy.xls | 524290 | 33668.3 ± 0.8% | 7737.3 ± 0.8% | 3507.2 ± 0.7% | 684.6 ± 1.1% | 5487.4 ± 0.3% | 760.0 ± 5.6% | 4.351 | 9.600 | 49.182 | 6.136 | 44.299 |
| hex: canterbury/lcet10.txt | 524290 | 33455.7 ± 0.3% | 7763.8 ± 0.3% | 3485.8 ± 1.8% | 455.9 ± 11.0% | 5470.3 ± 0.3% | 760.4 ± 2.8% | 4.309 | 9.598 | 73.386 | 6.116 | 43.999 |
| hex: canterbury/plrabn12.txt | 524290 | 33547.7 ± 0.4% | 7741.5 ± 0.5% | 3502.1 ± 1.9% | 457.4 ± 3.8% | 5476.1 ± 0.9% | 770.9 ± 4.2% | 4.334 | 9.579 | 73.348 | 6.126 | 43.519 |
| hex: canterbury/ptt5 | 524290 | 33480.3 ± 0.6% | 7750.6 ± 1.0% | 3486.3 ± 0.9% | 564.5 ± 13.5% | 5481.6 ± 0.6% | 776.8 ± 4.1% | 4.320 | 9.603 | 59.310 | 6.108 | 43.101 |
| hex: canterbury/sum | 76482 | 33231.4 ± 0.7% | 7788.1 ± 0.3% | 3516.6 ± 0.8% | 527.7 ± 0.4% | 5465.6 ± 1.8% | 769.3 ± 9.1% | 4.267 | 9.450 | 62.973 | 6.080 | 43.199 |
| hex: canterbury/xargs.1 | 8456 | 28227.6 ± 6.2% | 7518.6 ± 0.2% | 3558.4 ± 0.2% | 526.0 ± 3.7% | 5343.2 ± 1.0% | 755.6 ± 2.1% | 3.754 | 7.933 | 53.666 | 5.283 | 37.359 |
| hex: canterbury-large/E.coli | 524290 | 33672.2 ± 1.3% | 7697.3 ± 8.5% | 3483.4 ± 0.7% | 710.5 ± 0.4% | 5467.7 ± 4.7% | 754.0 ± 10.9% | 4.375 | 9.667 | 47.391 | 6.158 | 44.657 |
| hex: canterbury-large/bible.txt | 524290 | 33500.9 ± 9.5% | 7707.0 ± 0.5% | 3480.8 ± 0.8% | 486.3 ± 4.2% | 5478.9 ± 1.2% | 770.4 ± 5.1% | 4.347 | 9.624 | 68.883 | 6.115 | 43.487 |
| hex: canterbury-large/world192.txt | 524290 | 33462.9 ± 2.0% | 7734.1 ± 0.5% | 3497.7 ± 0.8% | 445.3 ± 2.5% | 5485.9 ± 0.6% | 762.1 ± 3.3% | 4.327 | 9.567 | 75.151 | 6.100 | 43.910 |
| hex: http/html-1kx1024 | 2099200 | 17039.4 ± 1.7% | 6625.5 ± 3.7% | 3212.3 ± 6.6% | 479.3 ± 1.4% | 4673.0 ± 2.9% | 650.5 ± 5.3% | 2.572 | 5.304 | 35.549 | 3.646 | 26.196 |
| hex: http/html-16kx64 | 2097280 | 30898.8 ± 0.9% | 7649.2 ± 0.5% | 3452.6 ± 0.5% | 494.2 ± 0.4% | 5405.9 ± 0.7% | 745.4 ± 3.7% | 4.039 | 8.949 | 62.528 | 5.716 | 41.453 |
| hex: http/html-1m | 524290 | 33520.4 ± 0.9% | 7716.4 ± 0.5% | 3489.5 ± 0.4% | 492.7 ± 0.9% | 5485.5 ± 7.2% | 748.7 ± 4.3% | 4.344 | 9.606 | 68.032 | 6.111 | 44.772 |
| hex: http/json-1kx1024 | 2099200 | 17096.4 ± 0.9% | 6628.6 ± 0.7% | 3217.5 ± 1.1% | 617.3 ± 1.3% | 4710.6 ± 1.2% | 671.9 ± 3.6% | 2.579 | 5.314 | 27.696 | 3.629 | 25.447 |
| hex: http/json-16kx64 | 2097280 | 30658.7 ± 0.6% | 7646.9 ± 2.1% | 3450.7 ± 2.2% | 631.1 ± 15.8% | 5421.2 ± 1.1% | 752.4 ± 5.1% | 4.009 | 8.885 | 48.579 | 5.655 | 40.746 |
| hex: http/json-1m | 524290 | 33353.8 ± 0.5% | 7707.5 ± 1.1% | 3488.8 ± 0.4% | 642.3 ± 0.3% | 5469.0 ± 0.5% | 761.6 ± 4.4% | 4.327 | 9.560 | 51.930 | 6.099 | 43.792 |
| hex: http/js-1kx1024 | 2099200 | 16994.6 ± 1.7% | 6612.2 ± 0.8% | 3184.4 ± 1.6% | 460.3 ± 4.5% | 4592.0 ± 2.8% | 620.5 ± 5.7% | 2.570 | 5.337 | 36.917 | 3.701 | 27.388 |
| hex: http/js-16kx64 | 2097280 | 30711.0 ± 0.7% | 7608.4 ± 0.9% | 3430.8 ± 1.1% | 463.1 ± 9.9% | 5398.0 ± 0.7% | 714.9 ± 5.6% | 4.036 | 8.952 | 66.311 | 5.689 | 42.956 |
| hex: http/js-1m | 524290 | 33539.9 ± 0.4% | 7717.4 ± 0.6% | 3485.2 ± 0.9% | 490.8 ± 2.4% | 5468.0 ± 0.5% | 769.4 ± 8.1% | 4.346 | 9.624 | 68.339 | 6.134 | 43.595 |
| hex: http/css-1kx1024 | 2099200 | 17079.1 ± 2.0% | 6626.9 ± 0.4% | 3191.8 ± 1.5% | 521.5 ± 3.3% | 4582.5 ± 11.2% | 626.3 ± 4.0% | 2.577 | 5.351 | 32.750 | 3.727 | 27.271 |
| hex: http/css-16kx64 | 2097280 | 30716.5 ± 0.8% | 7637.7 ± 1.2% | 3435.2 ± 8.3% | 548.3 ± 0.8% | 5400.0 ± 0.8% | 715.1 ± 5.9% | 4.022 | 8.942 | 56.021 | 5.688 | 42.953 |
| hex: http/css-1m | 524290 | 33471.8 ± 2.3% | 7772.1 ± 0.5% | 3486.0 ± 0.7% | 532.6 ± 0.3% | 5450.1 ± 0.8% | 767.3 ± 5.3% | 4.307 | 9.602 | 62.843 | 6.142 | 43.624 |
| hex: shuffled/dickens-1m | 524290 | 33445.0 ± 14.5% | 7776.2 ± 1.3% | 3477.1 ± 0.6% | 456.5 ± 3.1% | 5467.7 ± 1.6% | 758.0 ± 5.4% | 4.301 | 9.619 | 73.262 | 6.117 | 44.122 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1111.0 ± 4.2% | 1096.9 ± 21.9% | 799.9 ± 7.2% | 318.5 ± 1.4% | 354.7 ± 7.9% | 298.7 ± 3.5% | 1.013 | 1.389 | 3.489 | 3.132 | 3.720 |
| qlog records, JSON text sequence | 1467503 | 931.0 ± 2.3% | 827.6 ± 4.4% | 662.0 ± 2.6% | 299.3 ± 1.5% | 371.2 ± 1.1% | 216.6 ± 2.2% | 1.125 | 1.406 | 3.110 | 2.508 | 4.298 |
| string: silesia/dickens | 172528 | 8452.2 ± 0.3% | 2924.0 ± 6.1% | 2014.2 ± 1.1% | 353.4 ± 1.5% | 1388.9 ± 1.0% | 560.0 ± 0.2% | 2.891 | 4.196 | 23.918 | 6.086 | 15.094 |
| string: silesia/nci | 1075110 | 8099.4 ± 1.5% | 3147.7 ± 6.0% | 2757.2 ± 1.2% | 772.4 ± 0.5% | 1533.1 ± 0.3% | 558.6 ± 1.5% | 2.573 | 2.938 | 10.486 | 5.283 | 14.499 |
| string: silesia/reymont | 1075159 | 3819.3 ± 0.5% | 1639.7 ± 0.4% | 1711.2 ± 1.6% | 356.8 ± 1.5% | 1237.6 ± 0.7% | 547.0 ± 2.3% | 2.329 | 2.232 | 10.706 | 3.086 | 6.983 |
| string: silesia/samba | 97582 | 4544.4 ± 1.1% | 1960.5 ± 2.0% | 2165.2 ± 6.4% | 284.5 ± 2.8% | 976.4 ± 1.6% | 620.9 ± 1.6% | 2.318 | 2.099 | 15.971 | 4.654 | 7.320 |
| string: silesia/webster | 1098490 | 5026.7 ± 2.0% | 1622.2 ± 0.7% | 1519.8 ± 8.7% | 350.7 ± 1.3% | 1181.9 ± 4.3% | 450.9 ± 1.7% | 3.099 | 3.307 | 14.333 | 4.253 | 11.148 |
| string: silesia/xml | 1090118 | 7956.6 ± 0.5% | 2671.1 ± 0.9% | 2167.9 ± 2.0% | 535.2 ± 1.0% | 1552.7 ± 0.9% | 556.7 ± 0.9% | 2.979 | 3.670 | 14.867 | 5.124 | 14.291 |
| string: canterbury/alice29.txt | 159425 | 9054.9 ± 1.1% | 2428.7 ± 4.4% | 1787.8 ± 3.4% | 337.3 ± 2.0% | 1265.6 ± 0.5% | 557.8 ± 0.6% | 3.728 | 5.065 | 26.845 | 7.155 | 16.233 |
| string: canterbury/asyoulik.txt | 132198 | 7612.6 ± 0.7% | 2164.5 ± 1.2% | 1534.8 ± 0.6% | 339.8 ± 1.2% | 1110.5 ± 2.2% | 540.6 ± 1.1% | 3.517 | 4.960 | 22.401 | 6.855 | 14.082 |
| string: canterbury/lcet10.txt | 441884 | 8495.8 ± 1.9% | 2457.6 ± 2.2% | 1972.9 ± 0.4% | 386.4 ± 0.3% | 1365.8 ± 6.9% | 553.5 ± 0.6% | 3.457 | 4.306 | 21.985 | 6.220 | 15.350 |
| string: canterbury/plrabn12.txt | 503330 | 5993.6 ± 0.5% | 1821.2 ± 2.0% | 1662.5 ± 0.2% | 361.7 ± 0.8% | 1278.3 ± 1.5% | 552.7 ± 0.8% | 3.291 | 3.605 | 16.572 | 4.689 | 10.845 |
| string: canterbury-large/E.coli | 1048578 | 38554.5 ± 0.7% | 10902.5 ± 17.3% | 3382.8 ± 1.4% | 1417.1 ± 0.8% | 2509.3 ± 0.9% | 574.2 ± 1.7% | 3.536 | 11.397 | 27.206 | 15.365 | 67.143 |
| string: canterbury-large/bible.txt | 1055886 | 6964.2 ± 0.4% | 3963.6 ± 1.0% | 2645.8 ± 0.3% | 432.3 ± 1.7% | 1845.9 ± 1.7% | 568.9 ± 2.3% | 1.757 | 2.632 | 16.109 | 3.773 | 12.241 |
| string: canterbury-large/world192.txt | 1103121 | 4823.0 ± 6.4% | 1437.5 ± 1.9% | 1559.6 ± 3.4% | 366.8 ± 0.7% | 1158.1 ± 6.8% | 539.1 ± 1.9% | 3.355 | 3.092 | 13.147 | 4.164 | 8.947 |
| string: http/html-1m | 1058582 | 8511.2 ± 0.9% | 3868.0 ± 1.2% | 2473.1 ± 0.6% | 388.6 ± 0.8% | 1797.3 ± 0.4% | 518.8 ± 0.4% | 2.200 | 3.442 | 21.903 | 4.736 | 16.407 |
| string: http/json-1m | 1190272 | 6359.9 ± 0.3% | 1226.0 ± 0.4% | 1263.5 ± 0.5% | 373.1 ± 1.4% | 888.4 ± 1.2% | 501.2 ± 2.2% | 5.188 | 5.034 | 17.046 | 7.159 | 12.689 |
| string: http/js-1m | 1144362 | 5039.0 ± 1.7% | 986.0 ± 1.0% | 1074.8 ± 1.2% | 278.6 ± 0.6% | 931.3 ± 1.6% | 474.6 ± 1.6% | 5.111 | 4.689 | 18.084 | 5.411 | 10.618 |
| string: http/css-1m | 1097820 | 6472.4 ± 0.7% | 1291.3 ± 0.6% | 1592.1 ± 0.4% | 399.7 ± 31.3% | 1041.4 ± 0.5% | 532.5 ± 1.1% | 5.012 | 4.065 | 16.191 | 6.215 | 12.156 |
| string: dickens as Cyrillic and CJK | 1883069 | 5368.8 ± 1.3% | 3024.0 ± 0.5% | 343.2 ± 0.6% | 264.4 ± 1.1% | 435.2 ± 1.4% | 290.2 ± 0.9% | 1.775 | 15.643 | 20.307 | 12.336 | 18.499 |
| hex: silesia/dickens | 524290 | 31723.1 ± 1.1% | 1572.3 ± 7.1% | 1088.6 ± 0.4% | 410.8 ± 4.7% | 997.4 ± 2.5% | 425.6 ± 1.6% | 20.176 | 29.141 | 77.220 | 31.806 | 74.537 |
| hex: silesia/mozilla | 524290 | 35307.3 ± 3.4% | 1579.7 ± 0.2% | 1090.2 ± 0.8% | 365.9 ± 2.5% | 1026.5 ± 1.4% | 429.1 ± 1.2% | 22.350 | 32.385 | 96.486 | 34.395 | 82.278 |
| hex: silesia/mr | 524290 | 33424.9 ± 1.4% | 1575.6 ± 2.0% | 1092.4 ± 0.7% | 506.3 ± 2.0% | 1009.2 ± 1.2% | 427.7 ± 1.3% | 21.215 | 30.597 | 66.023 | 33.121 | 78.146 |
| hex: silesia/nci | 524290 | 32928.9 ± 2.3% | 1556.7 ± 1.5% | 1080.9 ± 1.4% | 554.5 ± 2.2% | 991.9 ± 1.3% | 424.6 ± 1.2% | 21.153 | 30.464 | 59.386 | 33.197 | 77.545 |
| hex: silesia/ooffice | 524290 | 33531.4 ± 4.4% | 1563.1 ± 1.8% | 1088.8 ± 2.3% | 316.3 ± 1.1% | 994.1 ± 8.2% | 423.7 ± 3.3% | 21.452 | 30.795 | 106.001 | 33.731 | 79.147 |
| hex: silesia/osdb | 524290 | 35552.1 ± 0.9% | 1574.2 ± 1.2% | 1089.7 ± 0.8% | 408.4 ± 3.6% | 1006.7 ± 2.6% | 425.8 ± 0.6% | 22.584 | 32.625 | 87.055 | 35.316 | 83.495 |
| hex: silesia/reymont | 524290 | 35100.0 ± 1.0% | 1579.5 ± 0.5% | 1093.0 ± 1.0% | 430.7 ± 1.8% | 1016.0 ± 1.7% | 424.5 ± 2.0% | 22.223 | 32.113 | 81.493 | 34.546 | 82.682 |
| hex: silesia/samba | 524290 | 34191.8 ± 2.9% | 1561.3 ± 2.1% | 1090.6 ± 2.1% | 324.8 ± 3.7% | 996.8 ± 2.5% | 422.9 ± 2.8% | 21.899 | 31.351 | 105.280 | 34.301 | 80.841 |
| hex: silesia/sao | 524290 | 34478.1 ± 6.4% | 1549.8 ± 1.6% | 1088.1 ± 1.3% | 256.7 ± 1.6% | 1001.4 ± 2.0% | 423.1 ± 1.7% | 22.247 | 31.687 | 134.335 | 34.429 | 81.493 |
| hex: silesia/webster | 524290 | 37257.3 ± 1.3% | 1569.2 ± 3.5% | 1092.5 ± 1.5% | 380.7 ± 2.0% | 999.8 ± 2.3% | 423.1 ± 2.6% | 23.743 | 34.103 | 97.862 | 37.266 | 88.068 |
| hex: silesia/x-ray | 524290 | 33871.4 ± 0.8% | 1576.4 ± 1.2% | 1091.0 ± 0.6% | 383.4 ± 3.2% | 1001.5 ± 4.0% | 423.7 ± 1.3% | 21.487 | 31.045 | 88.347 | 33.822 | 79.941 |
| hex: silesia/xml | 524290 | 33217.7 ± 1.9% | 1572.2 ± 1.3% | 1092.6 ± 1.1% | 576.9 ± 2.6% | 995.1 ± 1.0% | 421.9 ± 0.8% | 21.129 | 30.401 | 57.584 | 33.380 | 78.742 |
| hex: canterbury/alice29.txt | 304180 | 33461.6 ± 4.7% | 1587.9 ± 0.5% | 1094.8 ± 0.9% | 416.1 ± 1.7% | 1019.6 ± 2.4% | 426.8 ± 1.8% | 21.072 | 30.563 | 80.425 | 32.819 | 78.407 |
| hex: canterbury/asyoulik.txt | 250360 | 32153.4 ± 4.4% | 1583.1 ± 0.7% | 1100.9 ± 0.2% | 417.1 ± 1.4% | 1042.6 ± 1.8% | 429.4 ± 2.9% | 20.311 | 29.206 | 77.092 | 30.839 | 74.887 |
| hex: canterbury/cp.html | 49208 | 32115.0 ± 0.2% | 1607.0 ± 0.2% | 1107.0 ± 0.4% | 440.9 ± 3.0% | 1049.2 ± 1.9% | 437.0 ± 1.8% | 19.985 | 29.011 | 72.836 | 30.609 | 73.493 |
| hex: canterbury/fields.c | 22302 | 32785.8 ± 0.8% | 1588.1 ± 0.8% | 1099.4 ± 0.5% | 533.9 ± 2.2% | 1029.5 ± 3.6% | 429.3 ± 1.9% | 20.645 | 29.821 | 61.410 | 31.847 | 76.373 |
| hex: canterbury/grammar.lsp | 7444 | 34187.4 ± 1.7% | 1621.7 ± 1.9% | 1115.0 ± 2.8% | 570.1 ± 3.5% | 1032.3 ± 4.6% | 432.7 ± 3.3% | 21.081 | 30.660 | 59.972 | 33.116 | 79.012 |
| hex: canterbury/kennedy.xls | 524290 | 31664.9 ± 1.5% | 1560.8 ± 0.7% | 1088.4 ± 0.9% | 575.8 ± 1.7% | 982.5 ± 1.3% | 419.1 ± 2.0% | 20.287 | 29.094 | 54.991 | 32.230 | 75.558 |
| hex: canterbury/lcet10.txt | 524290 | 34857.5 ± 2.7% | 1563.3 ± 3.4% | 1084.8 ± 1.9% | 403.9 ± 1.7% | 998.6 ± 1.0% | 420.1 ± 2.2% | 22.297 | 32.132 | 86.295 | 34.908 | 82.975 |
| hex: canterbury/plrabn12.txt | 524290 | 33446.5 ± 1.8% | 1557.6 ± 1.1% | 1082.2 ± 6.1% | 401.0 ± 1.0% | 991.8 ± 2.8% | 418.9 ± 2.1% | 21.473 | 30.905 | 83.415 | 33.722 | 79.848 |
| hex: canterbury/ptt5 | 524290 | 33829.7 ± 3.1% | 1572.3 ± 1.9% | 1089.8 ± 7.4% | 486.4 ± 3.6% | 992.3 ± 1.6% | 420.7 ± 3.1% | 21.517 | 31.042 | 69.547 | 34.091 | 80.420 |
| hex: canterbury/sum | 76482 | 35148.2 ± 2.3% | 1589.2 ± 2.5% | 1086.6 ± 2.7% | 482.9 ± 2.4% | 1020.8 ± 1.5% | 430.9 ± 3.6% | 22.116 | 32.346 | 72.789 | 34.431 | 81.574 |
| hex: canterbury/xargs.1 | 8456 | 35300.9 ± 0.7% | 1627.8 ± 0.9% | 1111.2 ± 1.7% | 610.4 ± 4.6% | 1038.3 ± 2.2% | 435.1 ± 1.5% | 21.686 | 31.767 | 57.836 | 33.998 | 81.131 |
| hex: canterbury-large/E.coli | 524290 | 30443.5 ± 1.9% | 1563.1 ± 1.1% | 1087.7 ± 0.8% | 597.2 ± 3.7% | 1015.2 ± 5.5% | 425.3 ± 2.1% | 19.477 | 27.990 | 50.981 | 29.986 | 71.575 |
| hex: canterbury-large/bible.txt | 524290 | 35975.7 ± 0.6% | 1578.1 ± 1.2% | 1094.6 ± 0.3% | 434.4 ± 2.3% | 1025.7 ± 2.7% | 431.9 ± 2.9% | 22.797 | 32.867 | 82.808 | 35.075 | 83.298 |
| hex: canterbury-large/world192.txt | 524290 | 35726.0 ± 0.4% | 1576.0 ± 4.0% | 1092.0 ± 0.5% | 412.1 ± 0.7% | 1012.1 ± 0.4% | 426.2 ± 1.8% | 22.669 | 32.717 | 86.702 | 35.299 | 83.819 |
| hex: http/html-1kx1024 | 2099200 | 25396.3 ± 1.8% | 1609.4 ± 0.6% | 1087.0 ± 0.6% | 439.1 ± 3.1% | 1031.8 ± 2.5% | 429.4 ± 1.5% | 15.780 | 23.364 | 57.841 | 24.614 | 59.137 |
| hex: http/html-16kx64 | 2097280 | 30530.3 ± 0.6% | 1594.1 ± 0.7% | 1099.4 ± 0.3% | 436.9 ± 2.8% | 1027.6 ± 4.2% | 432.3 ± 1.9% | 19.152 | 27.770 | 69.874 | 29.711 | 70.624 |
| hex: http/html-1m | 524290 | 29319.1 ± 1.1% | 1559.5 ± 6.6% | 1090.1 ± 0.4% | 435.5 ± 1.4% | 996.0 ± 1.0% | 424.6 ± 1.7% | 18.800 | 26.896 | 67.317 | 29.436 | 69.052 |
| hex: http/json-1kx1024 | 2099200 | 24760.0 ± 4.4% | 1609.4 ± 1.3% | 1089.2 ± 0.1% | 550.0 ± 2.6% | 1024.9 ± 1.6% | 428.7 ± 0.8% | 15.385 | 22.732 | 45.021 | 24.159 | 57.762 |
| hex: http/json-16kx64 | 2097280 | 30413.7 ± 10.8% | 1574.3 ± 2.7% | 1098.4 ± 0.9% | 527.1 ± 3.2% | 961.9 ± 1.9% | 428.0 ± 1.2% | 19.318 | 27.688 | 57.695 | 31.617 | 71.066 |
| hex: http/json-1m | 524290 | 32001.1 ± 1.0% | 1563.1 ± 0.5% | 1087.3 ± 0.9% | 582.3 ± 2.4% | 996.3 ± 3.8% | 421.6 ± 7.7% | 20.473 | 29.433 | 54.958 | 32.120 | 75.910 |
| hex: http/js-1kx1024 | 2099200 | 25386.5 ± 0.5% | 1610.7 ± 0.4% | 1089.9 ± 0.2% | 433.7 ± 10.1% | 1051.1 ± 2.0% | 437.2 ± 1.1% | 15.761 | 23.291 | 58.538 | 24.153 | 58.071 |
| hex: http/js-16kx64 | 2097280 | 30653.0 ± 0.5% | 1597.8 ± 1.6% | 1100.7 ± 1.4% | 413.6 ± 2.8% | 974.5 ± 2.2% | 434.4 ± 2.8% | 19.184 | 27.849 | 74.108 | 31.454 | 70.561 |
| hex: http/js-1m | 524290 | 30615.2 ± 2.1% | 1569.4 ± 1.8% | 1084.2 ± 1.4% | 418.2 ± 2.9% | 986.3 ± 2.8% | 423.6 ± 1.6% | 19.508 | 28.239 | 73.210 | 31.039 | 72.268 |
| hex: http/css-1kx1024 | 2099200 | 24615.3 ± 3.6% | 1586.0 ± 5.6% | 1076.6 ± 0.5% | 476.1 ± 3.8% | 1010.5 ± 4.2% | 423.0 ± 2.8% | 15.520 | 22.864 | 51.706 | 24.361 | 58.197 |
| hex: http/css-16kx64 | 2097280 | 30746.2 ± 2.2% | 1579.4 ± 2.7% | 1095.7 ± 2.1% | 483.0 ± 5.0% | 1018.3 ± 4.5% | 425.9 ± 2.7% | 19.467 | 28.061 | 63.653 | 30.192 | 72.199 |
| hex: http/css-1m | 524290 | 31703.6 ± 0.9% | 1570.3 ± 0.8% | 1087.9 ± 1.2% | 436.7 ± 1.2% | 972.3 ± 3.8% | 424.5 ± 1.2% | 20.190 | 29.143 | 72.601 | 32.607 | 74.685 |
| hex: shuffled/dickens-1m | 524290 | 35480.3 ± 0.6% | 1575.7 ± 1.9% | 1091.3 ± 0.6% | 422.2 ± 3.9% | 1010.1 ± 10.3% | 426.5 ± 2.9% | 22.517 | 32.512 | 84.043 | 35.127 | 83.185 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- qlog records, JSON text sequence, decoding: stdx runs at 0.887 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.838 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.889 of yyjson.
