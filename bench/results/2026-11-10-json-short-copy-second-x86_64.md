# bench-json

| Field | Value |
|---|---|
| Commit | aaab086 |
| Runner label | ubuntu-24.04 |
| Image version | 20261101.360.1 |
| CPU model | AMD EPYC 7763 64-Core Processor |
| Virtual CPUs | 4 |
| Kernel | 7.0.0-1017-azure |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/42916663927 |
| Date | 2026-11-10 |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1040.5 ± 3.3% | 0.463 | 1.010 | 1.055 | 0.961 | 0.391 | 1.041 | 0.999 | 0.358 | 0.705 | 0.095 |
| qlog records, JSON text sequence | 1467503 | 858.6 ± 1.1% | 0.726 | 0.990 | 0.989 | 0.977 | 0.360 | 0.987 | 0.976 | 0.344 | 0.640 | 0.107 |
| string: silesia/dickens | 172528 | 5429.9 ± 0.9% | 0.025 | 0.662 | 1.031 | 1.052 | 0.178 | 1.015 | 1.052 | 0.179 | 0.179 | 0.025 |
| string: silesia/nci | 1075110 | 5292.3 ± 0.7% | 0.026 | 0.681 | 1.001 | 0.998 | 0.224 | 0.974 | 0.999 | 0.227 | 0.224 | 0.026 |
| string: silesia/reymont | 1075159 | 2776.9 ± 0.8% | 0.050 | 0.687 | 0.950 | 0.974 | 0.334 | 0.968 | 0.972 | 0.334 | 0.328 | 0.050 |
| string: silesia/samba | 97582 | 3348.8 ± 1.8% | 0.036 | 0.874 | 1.011 | 1.018 | 0.065 | 0.832 | 1.018 | 0.065 | 0.065 | 0.036 |
| string: silesia/webster | 1098490 | 3676.4 ± 0.8% | 0.037 | 0.669 | 1.023 | 1.048 | 0.192 | 1.015 | 1.046 | 0.192 | 0.192 | 0.037 |
| string: silesia/xml | 1090118 | 5132.5 ± 2.6% | 0.027 | 0.854 | 1.000 | 1.001 | 0.215 | 0.987 | 1.003 | 0.214 | 0.215 | 0.027 |
| string: canterbury/alice29.txt | 159425 | 4511.6 ± 1.0% | 0.030 | 0.730 | 1.016 | 1.083 | 0.158 | 1.044 | 1.083 | 0.158 | 0.159 | 0.030 |
| string: canterbury/asyoulik.txt | 132198 | 3813.8 ± 1.9% | 0.035 | 0.782 | 1.065 | 1.117 | 0.160 | 1.021 | 1.116 | 0.157 | 0.157 | 0.035 |
| string: canterbury/lcet10.txt | 441884 | 5703.9 ± 0.4% | 0.024 | 0.577 | 1.042 | 1.059 | 0.164 | 1.022 | 1.059 | 0.164 | 0.161 | 0.024 |
| string: canterbury/plrabn12.txt | 503330 | 4427.1 ± 7.9% | 0.031 | 0.771 | 1.042 | 1.080 | 0.182 | 1.015 | 1.084 | 0.184 | 0.178 | 0.031 |
| string: canterbury-large/E.coli | 1048578 | 29453.9 ± 2.9% | 0.051 | 1.014 | 0.757 | 1.011 | 0.537 | 1.016 | 1.016 | 0.535 | 0.538 | 0.005 |
| string: canterbury-large/bible.txt | 1055886 | 6655.8 ± 0.7% | 0.022 | 0.689 | 0.899 | 0.897 | 0.397 | 0.976 | 0.897 | 0.396 | 0.395 | 0.022 |
| string: canterbury-large/world192.txt | 1103121 | 3481.6 ± 1.3% | 0.039 | 0.694 | 1.023 | 1.045 | 0.182 | 1.002 | 1.046 | 0.183 | 0.182 | 0.039 |
| string: http/html-1m | 1058582 | 6243.4 ± 1.6% | 0.023 | 0.682 | 0.948 | 0.950 | 0.362 | 0.983 | 0.952 | 0.362 | 0.360 | 0.023 |
| string: http/json-1m | 1190272 | 3361.3 ± 0.1% | 0.037 | 0.376 | 0.430 | 0.430 | 0.091 | 0.388 | 0.430 | 0.091 | 0.091 | 0.038 |
| string: http/js-1m | 1144362 | 2229.9 ± 0.6% | 0.057 | 0.782 | 1.038 | 1.077 | 0.172 | 1.027 | 1.076 | 0.172 | 0.172 | 0.057 |
| string: http/css-1m | 1097820 | 3009.1 ± 0.4% | 0.044 | 0.741 | 0.995 | 1.084 | 0.212 | 1.045 | 1.097 | 0.212 | 0.211 | 0.044 |
| string: dickens as Cyrillic and CJK | 1883069 | 5213.5 ± 1.4% | 0.020 | 0.057 | 0.496 | 0.495 | 0.181 | 0.493 | 0.496 | 0.181 | 0.181 | 0.020 |
| string: dickens as Cyrillic and CJK, as \u escapes | 5075485 | 1061.7 ± 5.3% | 0.093 | 0.968 | 0.974 | 0.974 | 0.089 | 0.706 | 0.975 | 0.089 | 0.089 | 0.093 |
| hex: silesia/dickens | 524290 | 29387.6 ± 4.2% | 0.051 | 1.008 | 0.757 | 1.013 | 0.556 | 1.024 | 1.023 | 0.555 | 0.557 | 0.005 |
| hex: silesia/mozilla | 524290 | 29294.0 ± 4.2% | 0.051 | 0.995 | 0.752 | 1.003 | 0.553 | 1.000 | 0.988 | 0.547 | 0.551 | 0.005 |
| hex: silesia/mr | 524290 | 31217.8 ± 0.5% | 0.048 | 1.001 | 0.713 | 1.003 | 0.523 | 1.005 | 1.008 | 0.519 | 0.524 | 0.005 |
| hex: silesia/nci | 524290 | 30767.6 ± 1.9% | 0.049 | 1.002 | 0.718 | 1.004 | 0.536 | 1.008 | 1.005 | 0.533 | 0.537 | 0.005 |
| hex: silesia/ooffice | 524290 | 29419.1 ± 1.1% | 0.051 | 1.008 | 0.755 | 1.013 | 0.551 | 1.011 | 1.016 | 0.549 | 0.552 | 0.005 |
| hex: silesia/osdb | 524290 | 29768.6 ± 1.7% | 0.051 | 1.008 | 0.747 | 1.007 | 0.543 | 1.006 | 1.010 | 0.541 | 0.544 | 0.005 |
| hex: silesia/reymont | 524290 | 29938.4 ± 1.4% | 0.051 | 1.008 | 0.738 | 1.011 | 0.547 | 1.012 | 1.011 | 0.544 | 0.548 | 0.005 |
| hex: silesia/samba | 524290 | 30031.2 ± 0.4% | 0.050 | 1.007 | 0.739 | 1.009 | 0.542 | 1.011 | 1.013 | 0.537 | 0.540 | 0.005 |
| hex: silesia/sao | 524290 | 31048.1 ± 0.7% | 0.049 | 1.005 | 0.710 | 1.000 | 0.527 | 1.008 | 1.009 | 0.523 | 0.525 | 0.005 |
| hex: silesia/webster | 524290 | 29544.2 ± 1.0% | 0.051 | 1.012 | 0.754 | 1.012 | 0.541 | 1.011 | 1.016 | 0.539 | 0.543 | 0.005 |
| hex: silesia/x-ray | 524290 | 31401.7 ± 1.1% | 0.048 | 1.008 | 0.709 | 1.008 | 0.523 | 1.011 | 1.013 | 0.522 | 0.527 | 0.005 |
| hex: silesia/xml | 524290 | 29971.2 ± 1.6% | 0.051 | 1.009 | 0.740 | 1.006 | 0.544 | 1.013 | 1.009 | 0.540 | 0.544 | 0.005 |
| hex: canterbury/alice29.txt | 304180 | 38048.9 ± 0.5% | 0.040 | 0.989 | 0.577 | 1.007 | 0.469 | 0.991 | 1.009 | 0.470 | 0.470 | 0.004 |
| hex: canterbury/asyoulik.txt | 250360 | 35302.1 ± 0.7% | 0.043 | 0.995 | 0.484 | 1.001 | 0.473 | 0.996 | 1.004 | 0.471 | 0.474 | 0.004 |
| hex: canterbury/cp.html | 49208 | 38888.0 ± 1.4% | 0.040 | 1.006 | 0.560 | 1.010 | 0.467 | 1.012 | 1.010 | 0.471 | 0.473 | 0.004 |
| hex: canterbury/fields.c | 22302 | 35186.2 ± 1.3% | 0.044 | 1.018 | 0.606 | 1.028 | 0.491 | 1.026 | 1.036 | 0.501 | 0.506 | 0.004 |
| hex: canterbury/grammar.lsp | 7444 | 34368.2 ± 1.5% | 0.045 | 1.051 | 0.566 | 1.086 | 0.461 | 1.088 | 1.084 | 0.487 | 0.498 | 0.004 |
| hex: canterbury/kennedy.xls | 524290 | 29978.1 ± 28.1% | 0.051 | 1.007 | 0.726 | 1.022 | 0.544 | 1.018 | 1.022 | 0.541 | 0.545 | 0.005 |
| hex: canterbury/lcet10.txt | 524290 | 29780.2 ± 0.7% | 0.051 | 1.004 | 0.742 | 1.005 | 0.546 | 1.009 | 1.010 | 0.543 | 0.547 | 0.005 |
| hex: canterbury/plrabn12.txt | 524290 | 29784.1 ± 0.6% | 0.051 | 1.006 | 0.744 | 1.006 | 0.544 | 1.011 | 1.008 | 0.542 | 0.547 | 0.005 |
| hex: canterbury/ptt5 | 524290 | 30219.5 ± 0.1% | 0.050 | 1.006 | 0.732 | 1.002 | 0.541 | 1.008 | 1.009 | 0.537 | 0.541 | 0.005 |
| hex: canterbury/sum | 76482 | 41506.3 ± 9.6% | 0.037 | 1.013 | 0.536 | 1.015 | 0.432 | 1.013 | 1.014 | 0.434 | 0.436 | 0.004 |
| hex: canterbury/xargs.1 | 8456 | 36383.3 ± 0.2% | 0.042 | 1.009 | 0.545 | 1.060 | 0.444 | 1.046 | 1.060 | 0.465 | 0.472 | 0.004 |
| hex: canterbury-large/E.coli | 524290 | 29966.6 ± 1.6% | 0.050 | 1.009 | 0.729 | 1.006 | 0.541 | 1.011 | 1.013 | 0.539 | 0.543 | 0.005 |
| hex: canterbury-large/bible.txt | 524290 | 29306.5 ± 1.7% | 0.052 | 1.003 | 0.756 | 1.014 | 0.553 | 1.011 | 1.014 | 0.549 | 0.553 | 0.005 |
| hex: canterbury-large/world192.txt | 524290 | 30021.8 ± 0.5% | 0.050 | 1.012 | 0.740 | 1.007 | 0.544 | 1.016 | 1.016 | 0.538 | 0.542 | 0.005 |
| hex: http/html-1kx1024 | 2099200 | 16540.9 ± 1.4% | 0.090 | 1.019 | 0.795 | 1.050 | 0.611 | 1.049 | 1.048 | 0.704 | 0.733 | 0.009 |
| hex: http/html-16kx64 | 2097280 | 35825.6 ± 0.3% | 0.043 | 0.992 | 0.578 | 1.005 | 0.486 | 1.004 | 1.009 | 0.491 | 0.496 | 0.004 |
| hex: http/html-1m | 524290 | 29552.5 ± 4.9% | 0.051 | 1.021 | 0.750 | 1.019 | 0.544 | 1.018 | 1.018 | 0.542 | 0.545 | 0.005 |
| hex: http/json-1kx1024 | 2099200 | 16601.5 ± 2.1% | 0.090 | 1.024 | 0.798 | 1.046 | 0.609 | 1.056 | 1.049 | 0.703 | 0.730 | 0.009 |
| hex: http/json-16kx64 | 2097280 | 35021.6 ± 1.2% | 0.044 | 1.011 | 0.588 | 1.011 | 0.492 | 1.013 | 1.012 | 0.500 | 0.503 | 0.004 |
| hex: http/json-1m | 524290 | 30021.3 ± 0.5% | 0.050 | 1.007 | 0.741 | 1.005 | 0.547 | 1.010 | 1.012 | 0.543 | 0.551 | 0.005 |
| hex: http/js-1kx1024 | 2099200 | 16445.8 ± 1.2% | 0.090 | 1.026 | 0.795 | 1.047 | 0.582 | 1.061 | 1.049 | 0.682 | 0.710 | 0.009 |
| hex: http/js-16kx64 | 2097280 | 34464.3 ± 1.2% | 0.044 | 1.014 | 0.596 | 1.013 | 0.497 | 1.017 | 1.008 | 0.503 | 0.504 | 0.004 |
| hex: http/js-1m | 524290 | 29723.5 ± 1.0% | 0.051 | 1.011 | 0.747 | 1.008 | 0.545 | 1.012 | 1.013 | 0.539 | 0.543 | 0.005 |
| hex: http/css-1kx1024 | 2099200 | 16564.1 ± 3.3% | 0.090 | 1.018 | 0.797 | 1.053 | 0.610 | 1.045 | 1.051 | 0.705 | 0.730 | 0.009 |
| hex: http/css-16kx64 | 2097280 | 35552.9 ± 0.8% | 0.043 | 0.999 | 0.589 | 1.006 | 0.487 | 1.002 | 1.009 | 0.493 | 0.497 | 0.004 |
| hex: http/css-1m | 524290 | 29874.0 ± 1.1% | 0.051 | 1.009 | 0.743 | 1.008 | 0.544 | 1.012 | 1.013 | 0.540 | 0.543 | 0.005 |
| hex: shuffled/dickens-1m | 524290 | 30082.3 ± 0.8% | 0.050 | 1.004 | 0.736 | 1.002 | 0.548 | 1.008 | 1.007 | 0.545 | 0.551 | 0.005 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1351.7 ± 0.7% | 0.437 | 0.954 | 0.963 | 0.972 | 0.948 | 0.225 | 0.950 | 0.439 | 0.458 | 0.084 | 0.989 |
| qlog records, JSON text sequence | 1467503 | 1164.4 ± 0.3% | 0.698 | 0.953 | 0.978 | 0.983 | 0.970 | 0.218 | 0.972 | 0.414 | 0.460 | 0.103 | 0.998 |
| string: silesia/dickens | 172528 | 9058.4 ± 0.4% | 0.017 | 0.586 | 0.422 | 0.596 | 0.584 | 0.119 | 0.586 | 1.001 | 1.001 | 0.017 | 1.050 |
| string: silesia/nci | 1075110 | 8740.1 ± 0.3% | 0.018 | 0.590 | 0.404 | 0.587 | 0.590 | 0.163 | 0.591 | 1.003 | 1.000 | 0.018 | 1.020 |
| string: silesia/reymont | 1075159 | 3834.0 ± 2.5% | 0.040 | 0.676 | 0.513 | 0.667 | 0.676 | 0.279 | 0.676 | 1.002 | 1.002 | 0.040 | 1.005 |
| string: silesia/samba | 97582 | 4596.1 ± 0.3% | 0.043 | 0.940 | 0.793 | 0.944 | 0.940 | 0.111 | 0.939 | 1.001 | 1.003 | 0.043 | 1.119 |
| string: silesia/webster | 1098490 | 5066.7 ± 1.1% | 0.030 | 0.700 | 0.496 | 0.706 | 0.700 | 0.154 | 0.701 | 1.002 | 1.001 | 0.030 | 1.005 |
| string: silesia/xml | 1090118 | 8049.3 ± 7.2% | 0.020 | 0.623 | 0.556 | 0.628 | 0.621 | 0.193 | 0.623 | 0.998 | 1.001 | 0.020 | 1.054 |
| string: canterbury/alice29.txt | 159425 | 9682.8 ± 1.2% | 0.016 | 0.502 | 0.366 | 0.523 | 0.513 | 0.083 | 0.525 | 1.000 | 1.003 | 0.016 | 1.034 |
| string: canterbury/asyoulik.txt | 132198 | 8048.9 ± 1.9% | 0.019 | 0.505 | 0.385 | 0.499 | 0.508 | 0.085 | 0.493 | 1.002 | 1.006 | 0.019 | 1.042 |
| string: canterbury/lcet10.txt | 441884 | 8998.3 ± 0.4% | 0.017 | 0.595 | 0.387 | 0.608 | 0.599 | 0.115 | 0.599 | 1.003 | 1.016 | 0.017 | 1.033 |
| string: canterbury/plrabn12.txt | 503330 | 6113.7 ± 2.0% | 0.025 | 0.763 | 0.585 | 0.751 | 0.762 | 0.154 | 0.761 | 1.001 | 1.003 | 0.025 | 1.054 |
| string: canterbury-large/E.coli | 1048578 | 28852.1 ± 4.1% | 0.052 | 1.000 | 1.004 | 0.772 | 1.006 | 0.539 | 1.007 | 1.002 | 1.016 | 0.006 | 1.018 |
| string: canterbury-large/bible.txt | 1055886 | 6944.4 ± 0.3% | 0.023 | 0.803 | 0.664 | 0.829 | 0.803 | 0.410 | 0.804 | 1.000 | 1.000 | 0.023 | 1.049 |
| string: canterbury-large/world192.txt | 1103121 | 5045.3 ± 6.4% | 0.030 | 0.652 | 0.505 | 0.654 | 0.652 | 0.139 | 0.651 | 0.977 | 0.958 | 0.030 | 0.946 |
| string: http/html-1m | 1058582 | 8522.1 ± 0.7% | 0.018 | 0.616 | 0.513 | 0.651 | 0.617 | 0.286 | 0.617 | 1.003 | 1.012 | 0.018 | 1.016 |
| string: http/json-1m | 1190272 | 6776.3 ± 0.5% | 0.021 | 0.211 | 0.184 | 0.214 | 0.211 | 0.060 | 0.211 | 1.002 | 1.000 | 0.021 | 1.019 |
| string: http/js-1m | 1144362 | 5091.1 ± 2.8% | 0.029 | 0.442 | 0.352 | 0.428 | 0.443 | 0.084 | 0.443 | 1.002 | 1.008 | 0.029 | 0.999 |
| string: http/css-1m | 1097820 | 6911.6 ± 2.7% | 0.022 | 0.500 | 0.337 | 0.504 | 0.503 | 0.111 | 0.504 | 0.996 | 1.005 | 0.022 | 1.061 |
| string: dickens as Cyrillic and CJK | 1883069 | 5377.8 ± 0.3% | 0.023 | 0.464 | 0.056 | 0.466 | 0.462 | 0.176 | 0.464 | 1.002 | 1.000 | 0.023 | 0.976 |
| hex: silesia/dickens | 524290 | 31770.9 ± 0.4% | 1.010 | 0.067 | 1.009 | 0.588 | 1.010 | 1.007 | 1.013 | 1.006 | 1.011 | 0.080 | 1.011 |
| hex: silesia/mozilla | 524290 | 34705.1 ± 8.5% | 1.008 | 0.061 | 1.010 | 0.579 | 1.010 | 1.006 | 1.009 | 1.003 | 1.009 | 0.073 | 1.011 |
| hex: silesia/mr | 524290 | 33445.5 ± 13.8% | 1.009 | 0.064 | 1.009 | 0.599 | 1.011 | 1.009 | 1.011 | 1.005 | 1.009 | 0.076 | 1.011 |
| hex: silesia/nci | 524290 | 33399.6 ± 0.4% | 1.000 | 0.064 | 1.000 | 0.604 | 1.003 | 1.000 | 1.004 | 0.991 | 1.002 | 0.076 | 1.004 |
| hex: silesia/ooffice | 524290 | 33241.1 ± 0.7% | 1.007 | 0.064 | 1.009 | 0.600 | 1.004 | 1.001 | 1.007 | 1.003 | 1.006 | 0.076 | 1.009 |
| hex: silesia/osdb | 524290 | 34749.9 ± 1.3% | 1.013 | 0.061 | 1.015 | 0.577 | 1.015 | 1.012 | 1.015 | 1.008 | 1.013 | 0.073 | 1.008 |
| hex: silesia/reymont | 524290 | 34417.6 ± 2.1% | 1.008 | 0.062 | 1.012 | 0.581 | 1.009 | 1.010 | 1.011 | 1.006 | 1.006 | 0.074 | 1.011 |
| hex: silesia/samba | 524290 | 34280.1 ± 2.2% | 1.013 | 0.062 | 1.012 | 0.587 | 1.016 | 1.011 | 1.015 | 1.008 | 1.013 | 0.074 | 1.009 |
| hex: silesia/sao | 524290 | 33481.7 ± 10.1% | 1.009 | 0.064 | 1.012 | 0.586 | 1.008 | 1.006 | 1.011 | 1.008 | 1.008 | 0.076 | 1.007 |
| hex: silesia/webster | 524290 | 36258.7 ± 0.7% | 1.010 | 0.059 | 1.009 | 0.556 | 1.008 | 1.008 | 1.009 | 1.010 | 1.009 | 0.070 | 1.015 |
| hex: silesia/x-ray | 524290 | 33264.1 ± 1.7% | 1.005 | 0.064 | 1.007 | 0.602 | 1.009 | 1.005 | 1.009 | 1.009 | 1.013 | 0.077 | 1.017 |
| hex: silesia/xml | 524290 | 32923.1 ± 0.7% | 1.004 | 0.065 | 1.003 | 0.608 | 1.003 | 1.002 | 1.002 | 0.998 | 1.000 | 0.077 | 1.002 |
| hex: canterbury/alice29.txt | 304180 | 33262.7 ± 0.8% | 1.002 | 0.064 | 0.997 | 0.609 | 0.996 | 0.992 | 1.003 | 1.000 | 1.005 | 0.077 | 1.003 |
| hex: canterbury/asyoulik.txt | 250360 | 32262.0 ± 2.1% | 1.002 | 0.066 | 1.003 | 0.606 | 1.004 | 1.002 | 1.003 | 1.000 | 1.006 | 0.079 | 1.003 |
| hex: canterbury/cp.html | 49208 | 30871.5 ± 0.4% | 0.997 | 0.069 | 0.999 | 0.619 | 1.000 | 0.994 | 1.000 | 1.001 | 0.996 | 0.082 | 1.002 |
| hex: canterbury/fields.c | 22302 | 31380.6 ± 0.2% | 1.001 | 0.068 | 0.997 | 0.588 | 1.000 | 0.985 | 1.002 | 0.997 | 0.987 | 0.081 | 1.001 |
| hex: canterbury/grammar.lsp | 7444 | 32367.6 ± 0.4% | 0.999 | 0.065 | 0.993 | 0.574 | 1.001 | 0.957 | 1.000 | 1.005 | 1.001 | 0.077 | 1.003 |
| hex: canterbury/kennedy.xls | 524290 | 31597.3 ± 1.6% | 1.005 | 0.067 | 1.005 | 0.602 | 1.007 | 1.003 | 1.006 | 1.004 | 1.003 | 0.081 | 1.007 |
| hex: canterbury/lcet10.txt | 524290 | 34079.3 ± 0.3% | 1.011 | 0.063 | 1.010 | 0.592 | 1.005 | 1.007 | 1.008 | 1.007 | 1.004 | 0.075 | 1.012 |
| hex: canterbury/plrabn12.txt | 524290 | 33178.7 ± 14.9% | 1.007 | 0.064 | 1.007 | 0.602 | 1.006 | 1.009 | 1.012 | 1.001 | 1.003 | 0.077 | 1.005 |
| hex: canterbury/ptt5 | 524290 | 33125.0 ± 0.6% | 1.008 | 0.064 | 1.012 | 0.607 | 1.012 | 1.006 | 1.012 | 1.008 | 1.012 | 0.077 | 1.014 |
| hex: canterbury/sum | 76482 | 35204.2 ± 0.5% | 1.003 | 0.060 | 1.003 | 0.571 | 1.005 | 1.001 | 1.008 | 1.012 | 1.008 | 0.072 | 1.008 |
| hex: canterbury/xargs.1 | 8456 | 34615.6 ± 0.2% | 0.988 | 0.061 | 0.997 | 0.545 | 0.993 | 0.955 | 0.995 | 1.005 | 0.994 | 0.072 | 1.003 |
| hex: canterbury-large/E.coli | 524290 | 30626.8 ± 2.2% | 1.007 | 0.069 | 1.008 | 0.624 | 1.006 | 0.998 | 1.006 | 1.002 | 1.008 | 0.083 | 1.008 |
| hex: canterbury-large/bible.txt | 524290 | 35330.6 ± 1.2% | 1.005 | 0.060 | 1.005 | 0.568 | 1.005 | 1.003 | 1.006 | 1.001 | 1.005 | 0.072 | 1.007 |
| hex: canterbury-large/world192.txt | 524290 | 34748.0 ± 6.4% | 1.005 | 0.061 | 1.010 | 0.575 | 1.009 | 1.006 | 1.009 | 0.998 | 1.010 | 0.073 | 1.011 |
| hex: http/html-1kx1024 | 2099200 | 23613.3 ± 0.4% | 1.000 | 0.088 | 0.982 | 0.688 | 0.996 | 0.891 | 0.995 | 1.008 | 0.963 | 0.101 | 1.036 |
| hex: http/html-16kx64 | 2097280 | 29357.2 ± 1.7% | 1.018 | 0.072 | 1.018 | 0.660 | 1.022 | 1.009 | 1.022 | 1.016 | 1.018 | 0.086 | 1.023 |
| hex: http/html-1m | 524290 | 29051.3 ± 1.2% | 1.011 | 0.073 | 1.010 | 0.669 | 1.011 | 1.004 | 1.011 | 1.011 | 1.013 | 0.087 | 1.012 |
| hex: http/json-1kx1024 | 2099200 | 23464.9 ± 12.5% | 1.005 | 0.088 | 0.995 | 0.688 | 0.994 | 0.896 | 0.995 | 1.008 | 0.961 | 0.101 | 1.041 |
| hex: http/json-16kx64 | 2097280 | 29668.1 ± 2.4% | 1.009 | 0.072 | 1.011 | 0.648 | 1.018 | 0.992 | 1.016 | 1.014 | 1.010 | 0.085 | 1.028 |
| hex: http/json-1m | 524290 | 31637.0 ± 0.8% | 1.003 | 0.067 | 1.002 | 0.630 | 1.008 | 1.002 | 1.004 | 1.002 | 1.004 | 0.080 | 1.003 |
| hex: http/js-1kx1024 | 2099200 | 23681.1 ± 0.9% | 1.000 | 0.087 | 0.991 | 0.683 | 0.992 | 0.893 | 0.993 | 1.002 | 0.960 | 0.100 | 1.033 |
| hex: http/js-16kx64 | 2097280 | 29703.4 ± 0.9% | 1.007 | 0.071 | 1.011 | 0.648 | 1.009 | 0.993 | 1.009 | 1.016 | 1.010 | 0.085 | 1.023 |
| hex: http/js-1m | 524290 | 30386.9 ± 0.7% | 1.007 | 0.070 | 1.004 | 0.647 | 1.005 | 1.004 | 1.006 | 1.014 | 1.012 | 0.084 | 1.011 |
| hex: http/css-1kx1024 | 2099200 | 23361.4 ± 1.0% | 1.010 | 0.089 | 0.990 | 0.690 | 0.995 | 0.900 | 0.994 | 1.014 | 0.952 | 0.102 | 1.040 |
| hex: http/css-16kx64 | 2097280 | 29274.9 ± 16.8% | 1.022 | 0.073 | 1.020 | 0.659 | 1.019 | 1.006 | 1.023 | 1.018 | 1.021 | 0.086 | 1.033 |
| hex: http/css-1m | 524290 | 31258.3 ± 13.8% | 1.007 | 0.068 | 1.008 | 0.636 | 1.008 | 1.006 | 1.008 | 1.006 | 1.008 | 0.081 | 1.016 |
| hex: shuffled/dickens-1m | 524290 | 34215.0 ± 15.5% | 1.016 | 0.062 | 1.017 | 0.588 | 1.014 | 1.011 | 1.014 | 1.009 | 1.016 | 0.074 | 1.016 |

## Losses

Each workload where a claim's path ran slower than the path it replaces by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding: J7 wide vectors off runs at 1.055 of all on.
- string: silesia/dickens, decoding: J13 decoder escape blocks off runs at 1.052 of all on.
- string: canterbury/alice29.txt, decoding: J13 decoder escape blocks off runs at 1.083 of all on.
- string: canterbury/asyoulik.txt, decoding: J8 decoder fast path off runs at 1.117 of all on.
- string: canterbury/asyoulik.txt, decoding: J13 decoder escape blocks off runs at 1.116 of all on.
- string: canterbury/lcet10.txt, decoding: J8 decoder fast path off runs at 1.059 of all on.
- string: canterbury/plrabn12.txt, decoding: J8 decoder fast path off runs at 1.080 of all on.
- string: canterbury/plrabn12.txt, decoding: J13 decoder escape blocks off runs at 1.084 of all on.
- string: http/js-1m, decoding: J8 decoder fast path off runs at 1.077 of all on.
- string: http/js-1m, decoding: J13 decoder escape blocks off runs at 1.076 of all on.
- string: http/css-1m, decoding: J8 decoder fast path off runs at 1.084 of all on.
- string: http/css-1m, decoding: J13 decoder escape blocks off runs at 1.097 of all on.
- hex: canterbury/grammar.lsp, decoding: J8 decoder fast path off runs at 1.086 of all on.
- hex: canterbury/grammar.lsp, decoding: J12 decoder escape words off runs at 1.088 of all on.
- hex: canterbury/grammar.lsp, decoding: J13 decoder escape blocks off runs at 1.084 of all on.
- hex: canterbury/xargs.1, decoding: J8 decoder fast path off runs at 1.060 of all on.
- hex: canterbury/xargs.1, decoding: J13 decoder escape blocks off runs at 1.060 of all on.
- hex: http/json-1kx1024, decoding: J12 decoder escape words off runs at 1.056 of all on.
- hex: http/js-1kx1024, decoding: J12 decoder escape words off runs at 1.061 of all on.
- hex: http/css-1kx1024, decoding: J8 decoder fast path off runs at 1.053 of all on.
- hex: http/css-1kx1024, decoding: J13 decoder escape blocks off runs at 1.051 of all on.

## UTF-8 validation against simdutf

stdx's `is_utf8`, the check the loops apply to every string's octets, run alone over each string workload's octets at the width the host's features pick (16 lanes on aarch64, AVX2's 32 or AVX-512's 64 on x86-64, decision 39), beside simdutf 9.3.3's `validate_utf8` in the same run; on a host with AVX-512, again with AVX2 alone. Each ratio is stdx's throughput over the other's. simdutf picks its kernel at run time. Before timing, every copy of the check and simdutf judged 20000 seeded buffers and each workload, whole and changed, alike.

| Workload | Octets | stdx, MB/s | simdutf, MB/s | stdx / simdutf | stdx with AVX2 alone, MB/s | stdx / stdx with AVX2 alone |
|---|---|---|---|---|---|---|
| string: silesia/dickens | 166668 | 99325.9 ± 0.3% | 91572.2 ± 0.3% | 1.085 | — | — |
| string: silesia/nci | 1048576 | 58649.7 ± 2.8% | 59823.4 ± 2.5% | 0.980 | — | — |
| string: silesia/reymont | 1048576 | 58321.7 ± 2.1% | 58821.8 ± 12.4% | 0.991 | — | — |
| string: silesia/samba | 65546 | 98358.0 ± 0.2% | 90636.8 ± 38.2% | 1.085 | — | — |
| string: silesia/webster | 1048576 | 59603.7 ± 14.9% | 60404.6 ± 2.8% | 0.987 | — | — |
| string: silesia/xml | 1048576 | 61782.9 ± 1.3% | 61518.9 ± 1.4% | 1.004 | — | — |
| string: canterbury/alice29.txt | 152089 | 100232.7 ± 1.1% | 91733.1 ± 0.6% | 1.093 | — | — |
| string: canterbury/asyoulik.txt | 125179 | 96495.7 ± 39.1% | 87238.0 ± 2.3% | 1.106 | — | — |
| string: canterbury/lcet10.txt | 426754 | 85440.2 ± 1.5% | 81849.5 ± 1.0% | 1.044 | — | — |
| string: canterbury/plrabn12.txt | 481861 | 80652.8 ± 2.8% | 78266.4 ± 0.9% | 1.030 | — | — |
| string: canterbury-large/E.coli | 1048576 | 60530.4 ± 1.0% | 60563.4 ± 1.3% | 0.999 | — | — |
| string: canterbury-large/bible.txt | 1048576 | 59422.5 ± 1.6% | 59563.7 ± 13.5% | 0.998 | — | — |
| string: canterbury-large/world192.txt | 1048576 | 58818.5 ± 2.2% | 58893.5 ± 2.5% | 0.999 | — | — |
| string: http/html-1m | 1048576 | 57743.7 ± 0.9% | 58894.9 ± 1.1% | 0.980 | — | — |
| string: http/json-1m | 1048576 | 52457.1 ± 1.2% | 56087.2 ± 1.3% | 0.935 | — | — |
| string: http/js-1m | 1048576 | 59909.7 ± 0.9% | 60380.5 ± 1.3% | 0.992 | — | — |
| string: http/css-1m | 1048576 | 59119.7 ± 2.2% | 59760.6 ± 2.9% | 0.989 | — | — |
| string: dickens as Cyrillic and CJK | 1847045 | 14633.3 ± 1.1% | 15333.7 ± 0.4% | 0.954 | — | — |

## Losses to simdutf

- string: http/json-1m: stdx runs at 0.935 of simdutf.

## UTF-8 validation by the buffer's offset from a 64-octet line

| Buffer | Octets | Offset | stdx, MB/s | simdutf, MB/s | stdx / simdutf | stdx with AVX2 alone, MB/s | stdx / stdx with AVX2 alone |
|---|---|---|---|---|---|---|---|
| string: canterbury-large/bible.txt | 1048576 | 0 | 58850.1 ± 1.6% | 58992.9 ± 2.0% | 0.998 | — | — |
| string: canterbury-large/bible.txt | 1048576 | 1 | 58978.6 ± 1.5% | 59242.5 ± 2.1% | 0.996 | — | — |
| string: canterbury-large/bible.txt | 1048576 | 8 | 59074.1 ± 1.7% | 59387.3 ± 3.1% | 0.995 | — | — |
| string: canterbury-large/bible.txt | 1048576 | 16 | 58901.5 ± 2.4% | 58499.0 ± 2.5% | 1.007 | — | — |
| string: canterbury-large/bible.txt | 1048576 | 32 | 59227.6 ± 1.8% | 59599.1 ± 1.5% | 0.994 | — | — |
| string: canterbury-large/bible.txt | 1048576 | 48 | 59039.5 ± 2.5% | 58875.7 ± 1.8% | 1.003 | — | — |
| string: dickens as Cyrillic and CJK | 1048576 | 0 | 14607.9 ± 3.1% | 15286.2 ± 2.3% | 0.956 | — | — |
| string: dickens as Cyrillic and CJK | 1048576 | 1 | 14607.2 ± 0.9% | 15359.7 ± 0.3% | 0.951 | — | — |
| string: dickens as Cyrillic and CJK | 1048576 | 8 | 14624.5 ± 0.3% | 15348.5 ± 0.2% | 0.953 | — | — |
| string: dickens as Cyrillic and CJK | 1048576 | 16 | 14619.0 ± 0.3% | 15366.4 ± 1.0% | 0.951 | — | — |
| string: dickens as Cyrillic and CJK | 1048576 | 32 | 14645.6 ± 0.8% | 15329.0 ± 0.2% | 0.955 | — | — |
| string: dickens as Cyrillic and CJK | 1048576 | 48 | 14613.8 ± 0.5% | 15347.0 ± 0.3% | 0.952 | — | — |

## Against the baselines

stdx with every claim on, timed beside simdjson 5.1.1, yyjson 0.13.0, Zig 0.16.0's std.json, serde_json 1.0.154 and Go's encoding/json/jsontext in the same run. Each ratio is stdx's throughput over the baseline's; below 1, the baseline is faster. stdx is built for the architecture's baseline CPU in ReleaseSafe; the baselines for this host in ReleaseFast, and simdjson picks its kernel at run time. Decoding visits every value; encoding writes each text from its tokens.

## Decoding against the baselines

Octets are the text's. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1040.5 ± 3.3% | 1016.0 ± 0.9% | 953.9 ± 24.2% | 259.2 ± 1.1% | 527.9 ± 0.7% | 250.5 ± 5.1% | 1.024 | 1.091 | 4.014 | 1.971 | 4.154 |
| qlog records, JSON text sequence | 1467503 | 858.6 ± 1.1% | 807.5 ± 0.3% | 810.7 ± 1.4% | 221.6 ± 1.6% | 588.4 ± 0.3% | 244.8 ± 1.0% | 1.063 | 1.059 | 3.875 | 1.459 | 3.507 |
| string: silesia/dickens | 172528 | 5429.9 ± 0.9% | 2950.0 ± 2.4% | 2063.9 ± 0.4% | 285.8 ± 1.3% | 2189.7 ± 1.8% | 491.6 ± 2.2% | 1.841 | 2.631 | 18.998 | 2.480 | 11.045 |
| string: silesia/nci | 1075110 | 5292.3 ± 0.7% | 3555.3 ± 0.4% | 2815.0 ± 5.7% | 426.9 ± 0.5% | 2428.4 ± 1.2% | 524.2 ± 3.8% | 1.489 | 1.880 | 12.396 | 2.179 | 10.096 |
| string: silesia/reymont | 1075159 | 2776.9 ± 0.8% | 2198.3 ± 2.7% | 1805.4 ± 5.4% | 295.3 ± 1.0% | 1650.1 ± 1.2% | 472.8 ± 15.2% | 1.263 | 1.538 | 9.404 | 1.683 | 5.873 |
| string: silesia/samba | 97582 | 3348.8 ± 1.8% | 2902.2 ± 0.6% | 1692.4 ± 2.9% | 239.0 ± 4.0% | 1280.1 ± 1.2% | 355.8 ± 1.8% | 1.154 | 1.979 | 14.012 | 2.616 | 9.411 |
| string: silesia/webster | 1098490 | 3676.4 ± 0.8% | 2054.2 ± 2.3% | 1669.9 ± 3.0% | 284.7 ± 12.3% | 1663.9 ± 0.7% | 443.2 ± 1.4% | 1.790 | 2.202 | 12.915 | 2.209 | 8.294 |
| string: silesia/xml | 1090118 | 5132.5 ± 2.6% | 3795.0 ± 1.4% | 2161.3 ± 6.5% | 374.4 ± 6.1% | 2376.5 ± 9.1% | 508.6 ± 4.8% | 1.352 | 2.375 | 13.708 | 2.160 | 10.092 |
| string: canterbury/alice29.txt | 159425 | 4511.6 ± 1.0% | 2458.3 ± 4.0% | 1909.4 ± 3.6% | 268.3 ± 2.8% | 1969.4 ± 3.2% | 432.8 ± 7.5% | 1.835 | 2.363 | 16.816 | 2.291 | 10.424 |
| string: canterbury/asyoulik.txt | 132198 | 3813.8 ± 1.9% | 2145.5 ± 0.8% | 1481.6 ± 1.7% | 259.3 ± 0.9% | 1594.2 ± 2.7% | 405.0 ± 3.1% | 1.778 | 2.574 | 14.706 | 2.392 | 9.417 |
| string: canterbury/lcet10.txt | 441884 | 5703.9 ± 0.4% | 2842.2 ± 0.8% | 2033.2 ± 2.1% | 309.2 ± 13.2% | 2137.5 ± 0.6% | 491.7 ± 5.9% | 2.007 | 2.805 | 18.448 | 2.668 | 11.599 |
| string: canterbury/plrabn12.txt | 503330 | 4427.1 ± 7.9% | 2731.2 ± 2.3% | 1713.9 ± 1.9% | 282.3 ± 0.2% | 2018.8 ± 0.3% | 465.2 ± 1.3% | 1.621 | 2.583 | 15.681 | 2.193 | 9.517 |
| string: canterbury-large/E.coli | 1048578 | 29453.9 ± 2.9% | 7732.9 ± 0.4% | 3442.0 ± 6.4% | 799.3 ± 0.3% | 5513.0 ± 0.7% | 799.3 ± 1.2% | 3.809 | 8.557 | 36.848 | 5.343 | 36.851 |
| string: canterbury-large/bible.txt | 1055886 | 6655.8 ± 0.7% | 3936.6 ± 0.5% | 2580.0 ± 1.0% | 329.0 ± 14.0% | 2992.9 ± 5.5% | 601.6 ± 0.8% | 1.691 | 2.580 | 20.233 | 2.224 | 11.064 |
| string: canterbury-large/world192.txt | 1103121 | 3481.6 ± 1.3% | 2010.3 ± 1.1% | 1668.4 ± 0.6% | 277.9 ± 2.3% | 1698.4 ± 4.0% | 433.2 ± 0.6% | 1.732 | 2.087 | 12.527 | 2.050 | 8.036 |
| string: http/html-1m | 1058582 | 6243.4 ± 1.6% | 3413.3 ± 0.6% | 2404.6 ± 3.7% | 370.8 ± 0.9% | 2724.1 ± 4.1% | 427.8 ± 0.6% | 1.829 | 2.596 | 16.837 | 2.292 | 14.593 |
| string: http/json-1m | 1190272 | 3361.3 ± 0.1% | 1258.8 ± 0.2% | 1534.0 ± 8.7% | 311.5 ± 0.3% | 823.5 ± 6.4% | 293.6 ± 2.2% | 2.670 | 2.191 | 10.792 | 4.082 | 11.447 |
| string: http/js-1m | 1144362 | 2229.9 ± 0.6% | 1349.7 ± 0.6% | 1170.7 ± 1.4% | 256.9 ± 1.1% | 1163.7 ± 7.4% | 295.1 ± 0.8% | 1.652 | 1.905 | 8.679 | 1.916 | 7.556 |
| string: http/css-1m | 1097820 | 3009.1 ± 0.4% | 2568.6 ± 1.3% | 1545.8 ± 3.2% | 337.4 ± 5.8% | 1514.6 ± 0.7% | 334.3 ± 1.3% | 1.171 | 1.947 | 8.920 | 1.987 | 9.001 |
| string: dickens as Cyrillic and CJK | 1883069 | 5213.5 ± 1.4% | 3239.9 ± 2.1% | 656.7 ± 3.7% | 244.2 ± 17.3% | 502.5 ± 14.1% | 142.4 ± 29.8% | 1.609 | 7.939 | 21.351 | 10.375 | 36.599 |
| string: dickens as Cyrillic and CJK, as \u escapes | 5075485 | 1061.7 ± 5.3% | 1081.1 ± 0.8% | 833.4 ± 10.9% | 147.7 ± 1.9% | 382.7 ± 3.5% | 200.8 ± 4.8% | 0.982 | 1.274 | 7.186 | 2.774 | 5.286 |
| hex: silesia/dickens | 524290 | 29387.6 ± 4.2% | 7735.0 ± 1.3% | 3457.8 ± 0.9% | 423.0 ± 3.6% | 5524.9 ± 0.3% | 817.0 ± 7.1% | 3.799 | 8.499 | 69.475 | 5.319 | 35.971 |
| hex: silesia/mozilla | 524290 | 29294.0 ± 4.2% | 7720.2 ± 0.4% | 3451.8 ± 4.7% | 369.3 ± 0.3% | 5508.7 ± 0.4% | 816.8 ± 5.5% | 3.794 | 8.487 | 79.314 | 5.318 | 35.863 |
| hex: silesia/mr | 524290 | 31217.8 ± 0.5% | 7761.3 ± 0.6% | 3477.8 ± 7.5% | 516.0 ± 1.9% | 5516.0 ± 1.3% | 822.4 ± 0.7% | 4.022 | 8.976 | 60.504 | 5.660 | 37.957 |
| hex: silesia/nci | 524290 | 30767.6 ± 1.9% | 7756.0 ± 0.3% | 3465.0 ± 0.7% | 578.1 ± 0.3% | 5516.6 ± 0.6% | 823.3 ± 1.0% | 3.967 | 8.879 | 53.218 | 5.577 | 37.372 |
| hex: silesia/ooffice | 524290 | 29419.1 ± 1.1% | 7720.4 ± 7.3% | 3467.6 ± 0.2% | 320.1 ± 0.5% | 5497.8 ± 4.4% | 824.5 ± 0.3% | 3.811 | 8.484 | 91.910 | 5.351 | 35.682 |
| hex: silesia/osdb | 524290 | 29768.6 ± 1.7% | 7714.9 ± 0.7% | 3461.1 ± 0.6% | 407.1 ± 0.2% | 5507.3 ± 1.1% | 823.0 ± 0.5% | 3.859 | 8.601 | 73.129 | 5.405 | 36.170 |
| hex: silesia/reymont | 524290 | 29938.4 ± 1.4% | 7747.2 ± 0.4% | 3467.7 ± 0.3% | 435.4 ± 0.2% | 5529.8 ± 0.4% | 823.9 ± 1.3% | 3.864 | 8.633 | 68.756 | 5.414 | 36.336 |
| hex: silesia/samba | 524290 | 30031.2 ± 0.4% | 7732.9 ± 0.5% | 3459.7 ± 0.5% | 325.3 ± 1.5% | 5517.2 ± 1.1% | 826.8 ± 5.0% | 3.884 | 8.680 | 92.329 | 5.443 | 36.324 |
| hex: silesia/sao | 524290 | 31048.1 ± 0.7% | 7731.7 ± 0.9% | 3454.1 ± 0.4% | 263.2 ± 0.2% | 5513.8 ± 0.9% | 825.3 ± 7.8% | 4.016 | 8.989 | 117.985 | 5.631 | 37.618 |
| hex: silesia/webster | 524290 | 29544.2 ± 1.0% | 7709.9 ± 0.6% | 3458.5 ± 5.0% | 385.4 ± 0.3% | 5539.7 ± 6.6% | 828.7 ± 5.1% | 3.832 | 8.542 | 76.652 | 5.333 | 35.649 |
| hex: silesia/x-ray | 524290 | 31401.7 ± 1.1% | 7761.0 ± 7.1% | 3473.3 ± 0.2% | 386.0 ± 6.4% | 5534.7 ± 0.9% | 826.6 ± 0.8% | 4.046 | 9.041 | 81.362 | 5.674 | 37.987 |
| hex: silesia/xml | 524290 | 29971.2 ± 1.6% | 7733.3 ± 0.2% | 3459.1 ± 0.6% | 508.4 ± 0.2% | 5522.0 ± 15.8% | 827.0 ± 0.6% | 3.876 | 8.665 | 58.951 | 5.428 | 36.242 |
| hex: canterbury/alice29.txt | 304180 | 38048.9 ± 0.5% | 7793.0 ± 0.9% | 3573.2 ± 0.7% | 424.4 ± 0.2% | 5524.2 ± 0.3% | 832.7 ± 1.0% | 4.882 | 10.648 | 89.662 | 6.888 | 45.691 |
| hex: canterbury/asyoulik.txt | 250360 | 35302.1 ± 0.7% | 7795.5 ± 0.9% | 3569.1 ± 6.5% | 414.8 ± 0.1% | 5505.7 ± 5.7% | 832.5 ± 1.0% | 4.529 | 9.891 | 85.102 | 6.412 | 42.403 |
| hex: canterbury/cp.html | 49208 | 38888.0 ± 1.4% | 7788.1 ± 1.8% | 3604.5 ± 0.3% | 403.8 ± 0.2% | 5481.0 ± 0.2% | 812.7 ± 2.5% | 4.993 | 10.789 | 96.304 | 7.095 | 47.850 |
| hex: canterbury/fields.c | 22302 | 35186.2 ± 1.3% | 7695.1 ± 4.7% | 3593.6 ± 0.6% | 429.2 ± 0.4% | 5473.8 ± 0.3% | 800.4 ± 2.0% | 4.573 | 9.791 | 81.988 | 6.428 | 43.962 |
| hex: canterbury/grammar.lsp | 7444 | 34368.2 ± 1.5% | 7504.8 ± 0.7% | 3562.0 ± 0.2% | 482.6 ± 0.7% | 5365.7 ± 0.6% | 777.4 ± 2.9% | 4.579 | 9.649 | 71.216 | 6.405 | 44.207 |
| hex: canterbury/kennedy.xls | 524290 | 29978.1 ± 28.1% | 7772.2 ± 0.6% | 3459.4 ± 6.9% | 600.0 ± 0.4% | 5494.5 ± 16.3% | 800.6 ± 4.0% | 3.857 | 8.666 | 49.960 | 5.456 | 37.443 |
| hex: canterbury/lcet10.txt | 524290 | 29780.2 ± 0.7% | 7775.5 ± 0.3% | 3469.7 ± 6.8% | 426.7 ± 0.4% | 5518.3 ± 7.8% | 828.6 ± 1.2% | 3.830 | 8.583 | 69.792 | 5.397 | 35.940 |
| hex: canterbury/plrabn12.txt | 524290 | 29784.1 ± 0.6% | 7750.6 ± 0.5% | 3457.4 ± 0.7% | 414.1 ± 0.4% | 5529.1 ± 0.3% | 830.4 ± 1.3% | 3.843 | 8.615 | 71.921 | 5.387 | 35.866 |
| hex: canterbury/ptt5 | 524290 | 30219.5 ± 0.1% | 7764.8 ± 0.1% | 3466.2 ± 1.0% | 513.1 ± 0.2% | 5518.8 ± 1.2% | 823.7 ± 0.3% | 3.892 | 8.718 | 58.900 | 5.476 | 36.686 |
| hex: canterbury/sum | 76482 | 41506.3 ± 9.6% | 7821.9 ± 0.3% | 3618.2 ± 1.1% | 464.2 ± 5.9% | 5493.9 ± 13.3% | 823.9 ± 2.2% | 5.306 | 11.472 | 89.417 | 7.555 | 50.381 |
| hex: canterbury/xargs.1 | 8456 | 36383.3 ± 0.2% | 7540.1 ± 6.7% | 3551.1 ± 0.3% | 448.3 ± 6.4% | 5368.0 ± 0.3% | 805.6 ± 1.5% | 4.825 | 10.246 | 81.156 | 6.778 | 45.162 |
| hex: canterbury-large/E.coli | 524290 | 29966.6 ± 1.6% | 7715.0 ± 0.3% | 3464.0 ± 0.2% | 709.8 ± 0.6% | 5527.8 ± 0.5% | 820.3 ± 5.8% | 3.884 | 8.651 | 42.219 | 5.421 | 36.533 |
| hex: canterbury-large/bible.txt | 524290 | 29306.5 ± 1.7% | 7714.3 ± 0.5% | 3458.9 ± 1.4% | 438.6 ± 0.2% | 5523.0 ± 0.6% | 820.4 ± 3.7% | 3.799 | 8.473 | 66.812 | 5.306 | 35.723 |
| hex: canterbury-large/world192.txt | 524290 | 30021.8 ± 0.5% | 7720.8 ± 0.4% | 3463.5 ± 6.9% | 409.2 ± 0.5% | 5533.9 ± 16.0% | 801.6 ± 3.9% | 3.888 | 8.668 | 73.370 | 5.425 | 37.451 |
| hex: http/html-1kx1024 | 2099200 | 16540.9 ± 1.4% | 6622.9 ± 0.4% | 3277.2 ± 8.4% | 425.1 ± 12.3% | 4728.7 ± 0.6% | 735.9 ± 2.0% | 2.498 | 5.047 | 38.912 | 3.498 | 22.477 |
| hex: http/html-16kx64 | 2097280 | 35825.6 ± 0.3% | 7656.2 ± 0.6% | 3510.2 ± 4.5% | 431.1 ± 0.2% | 5424.0 ± 0.2% | 805.2 ± 2.6% | 4.679 | 10.206 | 83.109 | 6.605 | 44.492 |
| hex: http/html-1m | 524290 | 29552.5 ± 4.9% | 7759.1 ± 0.7% | 3467.3 ± 0.8% | 428.6 ± 0.1% | 5538.2 ± 0.5% | 803.9 ± 2.6% | 3.809 | 8.523 | 68.954 | 5.336 | 36.761 |
| hex: http/json-1kx1024 | 2099200 | 16601.5 ± 2.1% | 6623.5 ± 0.9% | 3270.9 ± 0.4% | 518.3 ± 1.4% | 4728.5 ± 0.4% | 725.8 ± 1.4% | 2.506 | 5.075 | 32.028 | 3.511 | 22.875 |
| hex: http/json-16kx64 | 2097280 | 35021.6 ± 1.2% | 7690.3 ± 0.2% | 3502.6 ± 0.2% | 544.1 ± 0.4% | 5430.2 ± 0.3% | 798.4 ± 2.3% | 4.554 | 9.999 | 64.366 | 6.449 | 43.866 |
| hex: http/json-1m | 524290 | 30021.3 ± 0.5% | 7785.1 ± 0.3% | 3474.3 ± 0.5% | 534.9 ± 0.6% | 5530.4 ± 0.5% | 796.7 ± 8.7% | 3.856 | 8.641 | 56.130 | 5.428 | 37.684 |
| hex: http/js-1kx1024 | 2099200 | 16445.8 ± 1.2% | 6632.4 ± 0.9% | 3260.8 ± 0.5% | 418.9 ± 0.9% | 4723.7 ± 0.6% | 740.1 ± 9.4% | 2.480 | 5.043 | 39.262 | 3.482 | 22.222 |
| hex: http/js-16kx64 | 2097280 | 34464.3 ± 1.2% | 7667.4 ± 0.3% | 3469.6 ± 7.2% | 424.8 ± 12.9% | 5426.1 ± 0.4% | 801.5 ± 2.6% | 4.495 | 9.933 | 81.133 | 6.352 | 43.002 |
| hex: http/js-1m | 524290 | 29723.5 ± 1.0% | 7746.6 ± 0.5% | 3463.0 ± 1.1% | 436.8 ± 0.2% | 5521.4 ± 0.4% | 797.8 ± 4.6% | 3.837 | 8.583 | 68.047 | 5.383 | 37.258 |
| hex: http/css-1kx1024 | 2099200 | 16564.1 ± 3.3% | 6628.4 ± 0.5% | 3270.7 ± 0.4% | 459.0 ± 0.4% | 4714.2 ± 13.5% | 737.3 ± 1.4% | 2.499 | 5.064 | 36.083 | 3.514 | 22.465 |
| hex: http/css-16kx64 | 2097280 | 35552.9 ± 0.8% | 7691.5 ± 0.4% | 3527.9 ± 0.8% | 467.8 ± 1.2% | 5431.9 ± 4.3% | 799.8 ± 1.9% | 4.622 | 10.078 | 75.995 | 6.545 | 44.452 |
| hex: http/css-1m | 524290 | 29874.0 ± 1.1% | 7748.8 ± 0.4% | 3463.9 ± 1.4% | 455.1 ± 0.4% | 5490.3 ± 7.0% | 803.5 ± 4.6% | 3.855 | 8.624 | 65.641 | 5.441 | 37.180 |
| hex: shuffled/dickens-1m | 524290 | 30082.3 ± 0.8% | 7732.0 ± 0.5% | 3457.4 ± 0.9% | 424.2 ± 0.4% | 5522.6 ± 7.8% | 826.4 ± 0.7% | 3.891 | 8.701 | 70.915 | 5.447 | 36.400 |

## Encoding against the baselines

Octets are the ones stdx writes. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1351.7 ± 0.7% | 1084.1 ± 14.8% | 869.2 ± 0.8% | 331.9 ± 1.5% | 365.1 ± 0.6% | 308.0 ± 2.0% | 1.247 | 1.555 | 4.073 | 3.702 | 4.388 |
| qlog records, JSON text sequence | 1467503 | 1164.4 ± 0.3% | 863.9 ± 0.2% | 704.9 ± 0.5% | 323.5 ± 0.4% | 393.7 ± 3.3% | 232.4 ± 1.2% | 1.348 | 1.652 | 3.600 | 2.958 | 5.011 |
| string: silesia/dickens | 172528 | 9058.4 ± 0.4% | 3148.7 ± 0.4% | 2050.8 ± 0.1% | 363.4 ± 0.3% | 1420.2 ± 0.5% | 562.4 ± 0.5% | 2.877 | 4.417 | 24.925 | 6.378 | 16.108 |
| string: silesia/nci | 1075110 | 8740.1 ± 0.3% | 3181.5 ± 0.1% | 2830.8 ± 1.4% | 774.6 ± 0.8% | 1540.6 ± 0.4% | 563.4 ± 0.9% | 2.747 | 3.088 | 11.283 | 5.673 | 15.513 |
| string: silesia/reymont | 1075159 | 3834.0 ± 2.5% | 1598.6 ± 1.1% | 1731.7 ± 6.9% | 373.1 ± 0.4% | 1251.9 ± 0.6% | 549.3 ± 0.6% | 2.398 | 2.214 | 10.276 | 3.063 | 6.980 |
| string: silesia/samba | 97582 | 4596.1 ± 0.3% | 2020.2 ± 1.1% | 2192.4 ± 0.3% | 301.7 ± 2.0% | 1002.3 ± 0.8% | 616.9 ± 0.2% | 2.275 | 2.096 | 15.235 | 4.585 | 7.450 |
| string: silesia/webster | 1098490 | 5066.7 ± 1.1% | 1638.2 ± 0.5% | 1531.3 ± 0.3% | 364.9 ± 1.3% | 1200.0 ± 2.4% | 455.2 ± 1.1% | 3.093 | 3.309 | 13.884 | 4.222 | 11.130 |
| string: silesia/xml | 1090118 | 8049.3 ± 7.2% | 2737.6 ± 3.7% | 2172.6 ± 0.1% | 532.4 ± 0.7% | 1577.4 ± 1.0% | 561.9 ± 0.6% | 2.940 | 3.705 | 15.119 | 5.103 | 14.326 |
| string: canterbury/alice29.txt | 159425 | 9682.8 ± 1.2% | 2655.9 ± 1.0% | 1797.3 ± 1.9% | 341.8 ± 1.7% | 1266.4 ± 0.8% | 558.3 ± 4.8% | 3.646 | 5.387 | 28.332 | 7.646 | 17.343 |
| string: canterbury/asyoulik.txt | 132198 | 8048.9 ± 1.9% | 2273.5 ± 9.4% | 1530.4 ± 7.4% | 351.4 ± 0.6% | 1118.8 ± 1.3% | 543.3 ± 1.1% | 3.540 | 5.259 | 22.905 | 7.194 | 14.814 |
| string: canterbury/lcet10.txt | 441884 | 8998.3 ± 0.4% | 2520.3 ± 0.5% | 1993.0 ± 0.1% | 397.6 ± 1.3% | 1388.3 ± 0.8% | 556.6 ± 1.1% | 3.570 | 4.515 | 22.632 | 6.482 | 16.166 |
| string: canterbury/plrabn12.txt | 503330 | 6113.7 ± 2.0% | 1812.5 ± 0.2% | 1680.6 ± 0.4% | 371.7 ± 1.2% | 1291.4 ± 3.8% | 559.4 ± 7.4% | 3.373 | 3.638 | 16.450 | 4.734 | 10.928 |
| string: canterbury-large/E.coli | 1048578 | 28852.1 ± 4.1% | 18037.6 ± 14.2% | 3384.6 ± 0.3% | 1410.6 ± 0.9% | 2504.6 ± 0.8% | 576.1 ± 0.6% | 1.600 | 8.525 | 20.453 | 11.519 | 50.083 |
| string: canterbury-large/bible.txt | 1055886 | 6944.4 ± 0.3% | 3940.4 ± 1.5% | 2662.6 ± 0.2% | 441.8 ± 0.5% | 1870.5 ± 0.9% | 567.9 ± 0.6% | 1.762 | 2.608 | 15.717 | 3.713 | 12.228 |
| string: canterbury-large/world192.txt | 1103121 | 5045.3 ± 6.4% | 1430.0 ± 0.9% | 1617.5 ± 0.6% | 365.1 ± 1.1% | 1174.3 ± 0.5% | 540.2 ± 0.6% | 3.528 | 3.119 | 13.818 | 4.296 | 9.340 |
| string: http/html-1m | 1058582 | 8522.1 ± 0.7% | 3848.0 ± 1.1% | 2485.9 ± 12.9% | 434.5 ± 3.5% | 1806.8 ± 1.6% | 521.2 ± 12.2% | 2.215 | 3.428 | 19.613 | 4.717 | 16.349 |
| string: http/json-1m | 1190272 | 6776.3 ± 0.5% | 1215.7 ± 0.2% | 1317.8 ± 21.4% | 410.0 ± 1.5% | 893.1 ± 28.3% | 508.2 ± 0.6% | 5.574 | 5.142 | 16.529 | 7.587 | 13.335 |
| string: http/js-1m | 1144362 | 5091.1 ± 2.8% | 991.0 ± 0.2% | 1063.9 ± 0.3% | 309.2 ± 0.8% | 938.0 ± 2.6% | 474.5 ± 2.3% | 5.137 | 4.785 | 16.466 | 5.427 | 10.730 |
| string: http/css-1m | 1097820 | 6911.6 ± 2.7% | 1252.2 ± 0.6% | 1619.8 ± 0.8% | 440.4 ± 8.7% | 1046.6 ± 0.7% | 527.5 ± 15.5% | 5.519 | 4.267 | 15.694 | 6.604 | 13.102 |
| string: dickens as Cyrillic and CJK | 1883069 | 5377.8 ± 0.3% | 3125.7 ± 0.9% | 307.9 ± 1.8% | 275.5 ± 0.3% | 449.8 ± 2.2% | 292.0 ± 0.4% | 1.720 | 17.463 | 19.520 | 11.956 | 18.419 |
| hex: silesia/dickens | 524290 | 31770.9 ± 0.4% | 1541.1 ± 0.5% | 1083.8 ± 0.6% | 422.9 ± 1.6% | 1023.0 ± 13.1% | 447.2 ± 1.0% | 20.616 | 29.316 | 75.122 | 31.057 | 71.042 |
| hex: silesia/mozilla | 524290 | 34705.1 ± 8.5% | 1545.6 ± 0.7% | 1084.2 ± 0.4% | 370.6 ± 1.1% | 1040.8 ± 10.5% | 449.0 ± 5.3% | 22.454 | 32.009 | 93.636 | 33.344 | 77.302 |
| hex: silesia/mr | 524290 | 33445.5 ± 13.8% | 1541.4 ± 6.1% | 1083.8 ± 0.4% | 509.9 ± 0.4% | 1046.5 ± 1.3% | 448.6 ± 0.5% | 21.699 | 30.859 | 65.596 | 31.958 | 74.556 |
| hex: silesia/nci | 524290 | 33399.6 ± 0.4% | 1538.3 ± 0.9% | 1082.6 ± 0.4% | 580.1 ± 0.3% | 1046.6 ± 0.9% | 448.0 ± 0.5% | 21.712 | 30.850 | 57.580 | 31.913 | 74.546 |
| hex: silesia/ooffice | 524290 | 33241.1 ± 0.7% | 1541.8 ± 1.1% | 1082.9 ± 2.2% | 328.4 ± 9.6% | 1047.9 ± 0.3% | 447.6 ± 0.6% | 21.560 | 30.697 | 101.215 | 31.720 | 74.269 |
| hex: silesia/osdb | 524290 | 34749.9 ± 1.3% | 1546.2 ± 0.5% | 1084.8 ± 0.9% | 416.2 ± 0.2% | 1048.8 ± 0.7% | 447.0 ± 1.1% | 22.474 | 32.032 | 83.483 | 33.132 | 77.747 |
| hex: silesia/reymont | 524290 | 34417.6 ± 2.1% | 1540.3 ± 0.9% | 1083.3 ± 6.4% | 445.4 ± 0.1% | 1048.9 ± 0.4% | 446.6 ± 0.6% | 22.345 | 31.770 | 77.268 | 32.813 | 77.069 |
| hex: silesia/samba | 524290 | 34280.1 ± 2.2% | 1537.2 ± 8.2% | 1084.8 ± 0.7% | 333.3 ± 1.6% | 1048.6 ± 1.0% | 448.3 ± 0.4% | 22.301 | 31.601 | 102.849 | 32.691 | 76.461 |
| hex: silesia/sao | 524290 | 33481.7 ± 10.1% | 1540.8 ± 8.2% | 1084.1 ± 0.5% | 267.9 ± 0.4% | 1048.5 ± 0.4% | 445.3 ± 0.6% | 21.730 | 30.885 | 124.993 | 31.932 | 75.197 |
| hex: silesia/webster | 524290 | 36258.7 ± 0.7% | 1545.6 ± 2.1% | 1084.8 ± 0.4% | 407.5 ± 0.7% | 1048.1 ± 0.9% | 446.5 ± 1.0% | 23.459 | 33.425 | 88.989 | 34.595 | 81.215 |
| hex: silesia/x-ray | 524290 | 33264.1 ± 1.7% | 1537.4 ± 0.8% | 1084.0 ± 0.5% | 398.8 ± 0.1% | 1053.0 ± 2.7% | 447.4 ± 0.5% | 21.637 | 30.687 | 83.407 | 31.588 | 74.356 |
| hex: silesia/xml | 524290 | 32923.1 ± 0.7% | 1549.0 ± 0.5% | 1083.2 ± 1.5% | 579.7 ± 7.5% | 1047.2 ± 1.1% | 446.6 ± 0.6% | 21.255 | 30.395 | 56.789 | 31.438 | 73.721 |
| hex: canterbury/alice29.txt | 304180 | 33262.7 ± 0.8% | 1578.9 ± 1.5% | 1091.5 ± 0.6% | 429.5 ± 0.2% | 1070.4 ± 0.1% | 450.8 ± 1.1% | 21.067 | 30.474 | 77.453 | 31.075 | 73.785 |
| hex: canterbury/asyoulik.txt | 250360 | 32262.0 ± 2.1% | 1596.4 ± 0.4% | 1097.4 ± 0.4% | 423.7 ± 3.3% | 1069.5 ± 17.7% | 452.4 ± 4.4% | 20.210 | 29.399 | 76.146 | 30.167 | 71.315 |
| hex: canterbury/cp.html | 49208 | 30871.5 ± 0.4% | 1620.7 ± 0.4% | 1106.6 ± 0.5% | 462.6 ± 1.1% | 1072.5 ± 2.4% | 446.5 ± 3.8% | 19.048 | 27.896 | 66.734 | 28.784 | 69.147 |
| hex: canterbury/fields.c | 22302 | 31380.6 ± 0.2% | 1597.6 ± 0.1% | 1100.2 ± 0.1% | 541.9 ± 0.7% | 1070.5 ± 10.9% | 454.9 ± 0.4% | 19.642 | 28.522 | 57.906 | 29.315 | 68.983 |
| hex: canterbury/grammar.lsp | 7444 | 32367.6 ± 0.4% | 1632.9 ± 0.6% | 1112.7 ± 0.3% | 564.1 ± 0.1% | 1082.8 ± 0.8% | 460.9 ± 0.7% | 19.822 | 29.088 | 57.383 | 29.892 | 70.221 |
| hex: canterbury/kennedy.xls | 524290 | 31597.3 ± 1.6% | 1538.9 ± 0.7% | 1083.4 ± 0.7% | 589.8 ± 0.2% | 1035.2 ± 8.2% | 447.5 ± 0.6% | 20.532 | 29.166 | 53.569 | 30.522 | 70.607 |
| hex: canterbury/lcet10.txt | 524290 | 34079.3 ± 0.3% | 1545.7 ± 1.1% | 1083.3 ± 0.6% | 428.9 ± 1.4% | 1048.8 ± 0.4% | 447.8 ± 1.1% | 22.048 | 31.459 | 79.466 | 32.493 | 76.102 |
| hex: canterbury/plrabn12.txt | 524290 | 33178.7 ± 14.9% | 1542.3 ± 0.3% | 1081.8 ± 0.9% | 419.2 ± 2.5% | 1047.4 ± 0.8% | 447.0 ± 1.2% | 21.513 | 30.670 | 79.142 | 31.677 | 74.221 |
| hex: canterbury/ptt5 | 524290 | 33125.0 ± 0.6% | 1540.7 ± 0.5% | 1084.3 ± 12.7% | 498.4 ± 0.7% | 1044.1 ± 0.6% | 448.7 ± 7.1% | 21.500 | 30.549 | 66.464 | 31.727 | 73.828 |
| hex: canterbury/sum | 76482 | 35204.2 ± 0.5% | 1618.1 ± 0.2% | 1103.3 ± 8.5% | 520.9 ± 0.7% | 1071.7 ± 2.1% | 458.8 ± 0.3% | 21.757 | 31.909 | 67.581 | 32.849 | 76.736 |
| hex: canterbury/xargs.1 | 8456 | 34615.6 ± 0.2% | 1625.2 ± 0.6% | 1111.0 ± 1.0% | 597.3 ± 0.3% | 1083.0 ± 1.3% | 460.7 ± 0.6% | 21.299 | 31.158 | 57.953 | 31.963 | 75.129 |
| hex: canterbury-large/E.coli | 524290 | 30626.8 ± 2.2% | 1531.7 ± 1.9% | 1081.6 ± 1.1% | 597.8 ± 0.9% | 1023.3 ± 0.3% | 449.4 ± 0.6% | 19.996 | 28.315 | 51.235 | 29.930 | 68.151 |
| hex: canterbury-large/bible.txt | 524290 | 35330.6 ± 1.2% | 1540.5 ± 1.0% | 1083.9 ± 1.5% | 441.4 ± 0.7% | 1050.1 ± 0.4% | 447.2 ± 1.2% | 22.934 | 32.596 | 80.044 | 33.644 | 79.006 |
| hex: canterbury-large/world192.txt | 524290 | 34748.0 ± 6.4% | 1542.5 ± 0.6% | 1083.4 ± 0.8% | 420.6 ± 1.0% | 1047.2 ± 0.4% | 447.4 ± 0.8% | 22.527 | 32.072 | 82.615 | 33.182 | 77.658 |
| hex: http/html-1kx1024 | 2099200 | 23613.3 ± 0.4% | 1604.5 ± 0.5% | 1087.5 ± 0.3% | 457.8 ± 0.3% | 1069.3 ± 0.4% | 452.5 ± 1.2% | 14.717 | 21.713 | 51.574 | 22.082 | 52.183 |
| hex: http/html-16kx64 | 2097280 | 29357.2 ± 1.7% | 1610.3 ± 0.2% | 1103.2 ± 0.2% | 462.5 ± 0.1% | 1066.5 ± 0.7% | 457.0 ± 0.4% | 18.231 | 26.610 | 63.476 | 27.526 | 64.234 |
| hex: http/html-1m | 524290 | 29051.3 ± 1.2% | 1544.4 ± 0.4% | 1086.6 ± 1.1% | 444.8 ± 4.8% | 1031.8 ± 0.5% | 447.3 ± 1.0% | 18.811 | 26.737 | 65.316 | 28.157 | 64.951 |
| hex: http/json-1kx1024 | 2099200 | 23464.9 ± 12.5% | 1604.3 ± 36.4% | 1087.0 ± 0.7% | 564.8 ± 0.5% | 1061.6 ± 16.3% | 452.2 ± 1.5% | 14.626 | 21.586 | 41.548 | 22.103 | 51.886 |
| hex: http/json-16kx64 | 2097280 | 29668.1 ± 2.4% | 1610.7 ± 0.2% | 1105.1 ± 0.3% | 573.4 ± 0.2% | 1039.3 ± 1.0% | 456.5 ± 0.4% | 18.420 | 26.846 | 51.741 | 28.545 | 64.995 |
| hex: http/json-1m | 524290 | 31637.0 ± 0.8% | 1537.3 ± 1.0% | 1084.2 ± 1.2% | 587.5 ± 0.9% | 1034.0 ± 0.3% | 450.2 ± 1.3% | 20.580 | 29.179 | 53.850 | 30.595 | 70.279 |
| hex: http/js-1kx1024 | 2099200 | 23681.1 ± 0.9% | 1602.6 ± 1.3% | 1088.8 ± 0.1% | 445.4 ± 0.1% | 1065.4 ± 0.8% | 450.5 ± 9.4% | 14.776 | 21.749 | 53.167 | 22.228 | 52.562 |
| hex: http/js-16kx64 | 2097280 | 29703.4 ± 0.9% | 1610.7 ± 0.4% | 1102.4 ± 0.2% | 436.4 ± 0.2% | 971.9 ± 13.3% | 456.6 ± 5.4% | 18.442 | 26.944 | 68.069 | 30.561 | 65.049 |
| hex: http/js-1m | 524290 | 30386.9 ± 0.7% | 1553.6 ± 0.5% | 1088.9 ± 0.8% | 449.7 ± 0.2% | 1029.1 ± 12.6% | 450.7 ± 1.1% | 19.559 | 27.905 | 67.577 | 29.529 | 67.417 |
| hex: http/css-1kx1024 | 2099200 | 23361.4 ± 1.0% | 1601.3 ± 0.3% | 1087.7 ± 0.4% | 500.2 ± 0.8% | 1072.5 ± 1.9% | 452.5 ± 0.7% | 14.589 | 21.478 | 46.709 | 21.782 | 51.633 |
| hex: http/css-16kx64 | 2097280 | 29274.9 ± 16.8% | 1606.1 ± 0.5% | 1104.2 ± 0.7% | 506.5 ± 0.3% | 1069.2 ± 0.3% | 456.9 ± 0.4% | 18.227 | 26.512 | 57.797 | 27.381 | 64.075 |
| hex: http/css-1m | 524290 | 31258.3 ± 13.8% | 1536.1 ± 1.1% | 1083.0 ± 0.5% | 482.4 ± 6.5% | 1027.6 ± 0.5% | 449.2 ± 1.5% | 20.349 | 28.863 | 64.802 | 30.420 | 69.588 |
| hex: shuffled/dickens-1m | 524290 | 34215.0 ± 15.5% | 1544.1 ± 1.0% | 1085.4 ± 0.5% | 429.0 ± 0.3% | 1042.7 ± 13.0% | 448.2 ± 4.2% | 22.158 | 31.524 | 79.750 | 32.813 | 76.331 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1336.4 ± 0.4% | 1084.1 ± 14.8% | 869.2 ± 0.8% | 331.9 ± 1.5% | 365.1 ± 0.6% | 308.0 ± 2.0% | 1.233 | 1.538 | 4.027 | 3.660 | 4.339 |
| qlog records, JSON text sequence | 1467503 | 1162.1 ± 0.4% | 863.9 ± 0.2% | 704.9 ± 0.5% | 323.5 ± 0.4% | 393.7 ± 3.3% | 232.4 ± 1.2% | 1.345 | 1.649 | 3.592 | 2.952 | 5.001 |
| string: silesia/dickens | 172528 | 9511.7 ± 1.1% | 3148.7 ± 0.4% | 2050.8 ± 0.1% | 363.4 ± 0.3% | 1420.2 ± 0.5% | 562.4 ± 0.5% | 3.021 | 4.638 | 26.173 | 6.697 | 16.914 |
| string: silesia/nci | 1075110 | 8916.5 ± 2.4% | 3181.5 ± 0.1% | 2830.8 ± 1.4% | 774.6 ± 0.8% | 1540.6 ± 0.4% | 563.4 ± 0.9% | 2.803 | 3.150 | 11.511 | 5.788 | 15.826 |
| string: silesia/reymont | 1075159 | 3853.5 ± 0.8% | 1598.6 ± 1.1% | 1731.7 ± 6.9% | 373.1 ± 0.4% | 1251.9 ± 0.6% | 549.3 ± 0.6% | 2.411 | 2.225 | 10.328 | 3.078 | 7.015 |
| string: silesia/samba | 97582 | 5141.8 ± 0.2% | 2020.2 ± 1.1% | 2192.4 ± 0.3% | 301.7 ± 2.0% | 1002.3 ± 0.8% | 616.9 ± 0.2% | 2.545 | 2.345 | 17.044 | 5.130 | 8.335 |
| string: silesia/webster | 1098490 | 5091.4 ± 2.2% | 1638.2 ± 0.5% | 1531.3 ± 0.3% | 364.9 ± 1.3% | 1200.0 ± 2.4% | 455.2 ± 1.1% | 3.108 | 3.325 | 13.952 | 4.243 | 11.184 |
| string: silesia/xml | 1090118 | 8487.5 ± 0.7% | 2737.6 ± 3.7% | 2172.6 ± 0.1% | 532.4 ± 0.7% | 1577.4 ± 1.0% | 561.9 ± 0.6% | 3.100 | 3.907 | 15.942 | 5.381 | 15.106 |
| string: canterbury/alice29.txt | 159425 | 10011.5 ± 0.6% | 2655.9 ± 1.0% | 1797.3 ± 1.9% | 341.8 ± 1.7% | 1266.4 ± 0.8% | 558.3 ± 4.8% | 3.770 | 5.570 | 29.293 | 7.906 | 17.931 |
| string: canterbury/asyoulik.txt | 132198 | 8385.0 ± 0.9% | 2273.5 ± 9.4% | 1530.4 ± 7.4% | 351.4 ± 0.6% | 1118.8 ± 1.3% | 543.3 ± 1.1% | 3.688 | 5.479 | 23.862 | 7.495 | 15.432 |
| string: canterbury/lcet10.txt | 441884 | 9294.3 ± 0.9% | 2520.3 ± 0.5% | 1993.0 ± 0.1% | 397.6 ± 1.3% | 1388.3 ± 0.8% | 556.6 ± 1.1% | 3.688 | 4.664 | 23.376 | 6.695 | 16.698 |
| string: canterbury/plrabn12.txt | 503330 | 6443.2 ± 0.8% | 1812.5 ± 0.2% | 1680.6 ± 0.4% | 371.7 ± 1.2% | 1291.4 ± 3.8% | 559.4 ± 7.4% | 3.555 | 3.834 | 17.337 | 4.989 | 11.518 |
| string: canterbury-large/E.coli | 1048578 | 29367.3 ± 2.4% | 18037.6 ± 14.2% | 3384.6 ± 0.3% | 1410.6 ± 0.9% | 2504.6 ± 0.8% | 576.1 ± 0.6% | 1.628 | 8.677 | 20.819 | 11.725 | 50.978 |
| string: canterbury-large/bible.txt | 1055886 | 7286.0 ± 0.4% | 3940.4 ± 1.5% | 2662.6 ± 0.2% | 441.8 ± 0.5% | 1870.5 ± 0.9% | 567.9 ± 0.6% | 1.849 | 2.736 | 16.490 | 3.895 | 12.830 |
| string: canterbury-large/world192.txt | 1103121 | 4773.0 ± 2.8% | 1430.0 ± 0.9% | 1617.5 ± 0.6% | 365.1 ± 1.1% | 1174.3 ± 0.5% | 540.2 ± 0.6% | 3.338 | 2.951 | 13.073 | 4.064 | 8.836 |
| string: http/html-1m | 1058582 | 8654.5 ± 0.9% | 3848.0 ± 1.1% | 2485.9 ± 12.9% | 434.5 ± 3.5% | 1806.8 ± 1.6% | 521.2 ± 12.2% | 2.249 | 3.481 | 19.918 | 4.790 | 16.603 |
| string: http/json-1m | 1190272 | 6907.9 ± 0.8% | 1215.7 ± 0.2% | 1317.8 ± 21.4% | 410.0 ± 1.5% | 893.1 ± 28.3% | 508.2 ± 0.6% | 5.682 | 5.242 | 16.850 | 7.735 | 13.594 |
| string: http/js-1m | 1144362 | 5087.8 ± 4.1% | 991.0 ± 0.2% | 1063.9 ± 0.3% | 309.2 ± 0.8% | 938.0 ± 2.6% | 474.5 ± 2.3% | 5.134 | 4.782 | 16.455 | 5.424 | 10.723 |
| string: http/css-1m | 1097820 | 7336.0 ± 2.0% | 1252.2 ± 0.6% | 1619.8 ± 0.8% | 440.4 ± 8.7% | 1046.6 ± 0.7% | 527.5 ± 15.5% | 5.858 | 4.529 | 16.658 | 7.009 | 13.907 |
| string: dickens as Cyrillic and CJK | 1883069 | 5248.0 ± 3.2% | 3125.7 ± 0.9% | 307.9 ± 1.8% | 275.5 ± 0.3% | 449.8 ± 2.2% | 292.0 ± 0.4% | 1.679 | 17.042 | 19.049 | 11.667 | 17.975 |
| hex: silesia/dickens | 524290 | 32123.5 ± 0.6% | 1541.1 ± 0.5% | 1083.8 ± 0.6% | 422.9 ± 1.6% | 1023.0 ± 13.1% | 447.2 ± 1.0% | 20.845 | 29.641 | 75.956 | 31.402 | 71.830 |
| hex: silesia/mozilla | 524290 | 35070.8 ± 0.3% | 1545.6 ± 0.7% | 1084.2 ± 0.4% | 370.6 ± 1.1% | 1040.8 ± 10.5% | 449.0 ± 5.3% | 22.691 | 32.347 | 94.622 | 33.696 | 78.116 |
| hex: silesia/mr | 524290 | 33811.5 ± 0.8% | 1541.4 ± 6.1% | 1083.8 ± 0.4% | 509.9 ± 0.4% | 1046.5 ± 1.3% | 448.6 ± 0.5% | 21.936 | 31.197 | 66.314 | 32.308 | 75.372 |
| hex: silesia/nci | 524290 | 33535.0 ± 0.7% | 1538.3 ± 0.9% | 1082.6 ± 0.4% | 580.1 ± 0.3% | 1046.6 ± 0.9% | 448.0 ± 0.5% | 21.800 | 30.975 | 57.814 | 32.043 | 74.848 |
| hex: silesia/ooffice | 524290 | 33529.2 ± 1.8% | 1541.8 ± 1.1% | 1082.9 ± 2.2% | 328.4 ± 9.6% | 1047.9 ± 0.3% | 447.6 ± 0.6% | 21.746 | 30.963 | 102.092 | 31.995 | 74.913 |
| hex: silesia/osdb | 524290 | 35044.3 ± 0.4% | 1546.2 ± 0.5% | 1084.8 ± 0.9% | 416.2 ± 0.2% | 1048.8 ± 0.7% | 447.0 ± 1.1% | 22.665 | 32.304 | 84.191 | 33.413 | 78.406 |
| hex: silesia/reymont | 524290 | 34802.8 ± 0.5% | 1540.3 ± 0.9% | 1083.3 ± 6.4% | 445.4 ± 0.1% | 1048.9 ± 0.4% | 446.6 ± 0.6% | 22.595 | 32.126 | 78.133 | 33.180 | 77.931 |
| hex: silesia/samba | 524290 | 34591.9 ± 2.6% | 1537.2 ± 8.2% | 1084.8 ± 0.7% | 333.3 ± 1.6% | 1048.6 ± 1.0% | 448.3 ± 0.4% | 22.504 | 31.888 | 103.785 | 32.989 | 77.156 |
| hex: silesia/sao | 524290 | 33725.2 ± 16.2% | 1540.8 ± 8.2% | 1084.1 ± 0.5% | 267.9 ± 0.4% | 1048.5 ± 0.4% | 445.3 ± 0.6% | 21.889 | 31.109 | 125.902 | 32.164 | 75.744 |
| hex: silesia/webster | 524290 | 36814.6 ± 1.3% | 1545.6 ± 2.1% | 1084.8 ± 0.4% | 407.5 ± 0.7% | 1048.1 ± 0.9% | 446.5 ± 1.0% | 23.819 | 33.937 | 90.353 | 35.125 | 82.460 |
| hex: silesia/x-ray | 524290 | 33845.3 ± 0.5% | 1537.4 ± 0.8% | 1084.0 ± 0.5% | 398.8 ± 0.1% | 1053.0 ± 2.7% | 447.4 ± 0.5% | 22.015 | 31.223 | 84.864 | 32.140 | 75.655 |
| hex: silesia/xml | 524290 | 32996.1 ± 0.8% | 1549.0 ± 0.5% | 1083.2 ± 1.5% | 579.7 ± 7.5% | 1047.2 ± 1.1% | 446.6 ± 0.6% | 21.302 | 30.463 | 56.915 | 31.508 | 73.885 |
| hex: canterbury/alice29.txt | 304180 | 33367.9 ± 1.0% | 1578.9 ± 1.5% | 1091.5 ± 0.6% | 429.5 ± 0.2% | 1070.4 ± 0.1% | 450.8 ± 1.1% | 21.133 | 30.570 | 77.698 | 31.173 | 74.018 |
| hex: canterbury/asyoulik.txt | 250360 | 32368.6 ± 0.4% | 1596.4 ± 0.4% | 1097.4 ± 0.4% | 423.7 ± 3.3% | 1069.5 ± 17.7% | 452.4 ± 4.4% | 20.276 | 29.496 | 76.397 | 30.266 | 71.550 |
| hex: canterbury/cp.html | 49208 | 30937.3 ± 0.2% | 1620.7 ± 0.4% | 1106.6 ± 0.5% | 462.6 ± 1.1% | 1072.5 ± 2.4% | 446.5 ± 3.8% | 19.089 | 27.956 | 66.876 | 28.845 | 69.295 |
| hex: canterbury/fields.c | 22302 | 31420.1 ± 4.2% | 1597.6 ± 0.1% | 1100.2 ± 0.1% | 541.9 ± 0.7% | 1070.5 ± 10.9% | 454.9 ± 0.4% | 19.667 | 28.558 | 57.979 | 29.352 | 69.070 |
| hex: canterbury/grammar.lsp | 7444 | 32459.3 ± 0.2% | 1632.9 ± 0.6% | 1112.7 ± 0.3% | 564.1 ± 0.1% | 1082.8 ± 0.8% | 460.9 ± 0.7% | 19.878 | 29.170 | 57.546 | 29.977 | 70.420 |
| hex: canterbury/kennedy.xls | 524290 | 31825.1 ± 1.0% | 1538.9 ± 0.7% | 1083.4 ± 0.7% | 589.8 ± 0.2% | 1035.2 ± 8.2% | 447.5 ± 0.6% | 20.680 | 29.376 | 53.955 | 30.742 | 71.116 |
| hex: canterbury/lcet10.txt | 524290 | 34503.4 ± 1.4% | 1545.7 ± 1.1% | 1083.3 ± 0.6% | 428.9 ± 1.4% | 1048.8 ± 0.4% | 447.8 ± 1.1% | 22.322 | 31.850 | 80.455 | 32.897 | 77.049 |
| hex: canterbury/plrabn12.txt | 524290 | 33360.3 ± 1.8% | 1542.3 ± 0.3% | 1081.8 ± 0.9% | 419.2 ± 2.5% | 1047.4 ± 0.8% | 447.0 ± 1.2% | 21.631 | 30.838 | 79.575 | 31.851 | 74.627 |
| hex: canterbury/ptt5 | 524290 | 33592.0 ± 0.4% | 1540.7 ± 0.5% | 1084.3 ± 12.7% | 498.4 ± 0.7% | 1044.1 ± 0.6% | 448.7 ± 7.1% | 21.803 | 30.980 | 67.401 | 32.175 | 74.869 |
| hex: canterbury/sum | 76482 | 35502.3 ± 0.4% | 1618.1 ± 0.2% | 1103.3 ± 8.5% | 520.9 ± 0.7% | 1071.7 ± 2.1% | 458.8 ± 0.3% | 21.941 | 32.179 | 68.153 | 33.127 | 77.386 |
| hex: canterbury/xargs.1 | 8456 | 34707.6 ± 0.6% | 1625.2 ± 0.6% | 1111.0 ± 1.0% | 597.3 ± 0.3% | 1083.0 ± 1.3% | 460.7 ± 0.6% | 21.356 | 31.241 | 58.108 | 32.048 | 75.329 |
| hex: canterbury-large/E.coli | 524290 | 30863.1 ± 0.4% | 1531.7 ± 1.9% | 1081.6 ± 1.1% | 597.8 ± 0.9% | 1023.3 ± 0.3% | 449.4 ± 0.6% | 20.150 | 28.534 | 51.630 | 30.161 | 68.677 |
| hex: canterbury-large/bible.txt | 524290 | 35566.0 ± 0.6% | 1540.5 ± 1.0% | 1083.9 ± 1.5% | 441.4 ± 0.7% | 1050.1 ± 0.4% | 447.2 ± 1.2% | 23.087 | 32.813 | 80.577 | 33.868 | 79.532 |
| hex: canterbury-large/world192.txt | 524290 | 35137.9 ± 1.5% | 1542.5 ± 0.6% | 1083.4 ± 0.8% | 420.6 ± 1.0% | 1047.2 ± 0.4% | 447.4 ± 0.8% | 22.780 | 32.432 | 83.542 | 33.555 | 78.530 |
| hex: http/html-1kx1024 | 2099200 | 24465.5 ± 4.6% | 1604.5 ± 0.5% | 1087.5 ± 0.3% | 457.8 ± 0.3% | 1069.3 ± 0.4% | 452.5 ± 1.2% | 15.248 | 22.496 | 53.436 | 22.879 | 54.066 |
| hex: http/html-16kx64 | 2097280 | 30019.8 ± 0.5% | 1610.3 ± 0.2% | 1103.2 ± 0.2% | 462.5 ± 0.1% | 1066.5 ± 0.7% | 457.0 ± 0.4% | 18.643 | 27.211 | 64.909 | 28.148 | 65.684 |
| hex: http/html-1m | 524290 | 29405.6 ± 0.6% | 1544.4 ± 0.4% | 1086.6 ± 1.1% | 444.8 ± 4.8% | 1031.8 ± 0.5% | 447.3 ± 1.0% | 19.041 | 27.063 | 66.112 | 28.500 | 65.743 |
| hex: http/json-1kx1024 | 2099200 | 24436.4 ± 1.2% | 1604.3 ± 36.4% | 1087.0 ± 0.7% | 564.8 ± 0.5% | 1061.6 ± 16.3% | 452.2 ± 1.5% | 15.231 | 22.480 | 43.268 | 23.018 | 54.034 |
| hex: http/json-16kx64 | 2097280 | 30506.5 ± 0.4% | 1610.7 ± 0.2% | 1105.1 ± 0.3% | 573.4 ± 0.2% | 1039.3 ± 1.0% | 456.5 ± 0.4% | 18.940 | 27.605 | 53.203 | 29.352 | 66.832 |
| hex: http/json-1m | 524290 | 31738.3 ± 0.3% | 1537.3 ± 1.0% | 1084.2 ± 1.2% | 587.5 ± 0.9% | 1034.0 ± 0.3% | 450.2 ± 1.3% | 20.646 | 29.273 | 54.022 | 30.693 | 70.504 |
| hex: http/js-1kx1024 | 2099200 | 24457.3 ± 1.2% | 1602.6 ± 1.3% | 1088.8 ± 0.1% | 445.4 ± 0.1% | 1065.4 ± 0.8% | 450.5 ± 9.4% | 15.261 | 22.462 | 54.910 | 22.956 | 54.285 |
| hex: http/js-16kx64 | 2097280 | 30386.4 ± 0.9% | 1610.7 ± 0.4% | 1102.4 ± 0.2% | 436.4 ± 0.2% | 971.9 ± 13.3% | 456.6 ± 5.4% | 18.866 | 27.563 | 69.634 | 31.263 | 66.545 |
| hex: http/js-1m | 524290 | 30713.8 ± 6.5% | 1553.6 ± 0.5% | 1088.9 ± 0.8% | 449.7 ± 0.2% | 1029.1 ± 12.6% | 450.7 ± 1.1% | 19.769 | 28.205 | 68.304 | 29.847 | 68.142 |
| hex: http/css-1kx1024 | 2099200 | 24300.7 ± 0.5% | 1601.3 ± 0.3% | 1087.7 ± 0.4% | 500.2 ± 0.8% | 1072.5 ± 1.9% | 452.5 ± 0.7% | 15.176 | 22.341 | 48.587 | 22.658 | 53.709 |
| hex: http/css-16kx64 | 2097280 | 30246.7 ± 0.1% | 1606.1 ± 0.5% | 1104.2 ± 0.7% | 506.5 ± 0.3% | 1069.2 ± 0.3% | 456.9 ± 0.4% | 18.832 | 27.392 | 59.715 | 28.290 | 66.202 |
| hex: http/css-1m | 524290 | 31747.6 ± 0.8% | 1536.1 ± 1.1% | 1083.0 ± 0.5% | 482.4 ± 6.5% | 1027.6 ± 0.5% | 449.2 ± 1.5% | 20.668 | 29.315 | 65.817 | 30.896 | 70.678 |
| hex: shuffled/dickens-1m | 524290 | 34771.0 ± 0.6% | 1544.1 ± 1.0% | 1085.4 ± 0.5% | 429.0 ± 0.3% | 1042.7 ± 13.0% | 448.2 ± 4.2% | 22.518 | 32.036 | 81.046 | 33.346 | 77.571 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 734.0 ± 2.0% | 1016.0 ± 0.9% | 953.9 ± 24.2% | 259.2 ± 1.1% | 527.9 ± 0.7% | 250.5 ± 5.1% | 0.722 | 0.769 | 2.831 | 1.391 | 2.930 |
| qlog records, JSON text sequence | 1467503 | 549.6 ± 0.9% | 807.5 ± 0.3% | 810.7 ± 1.4% | 221.6 ± 1.6% | 588.4 ± 0.3% | 244.8 ± 1.0% | 0.681 | 0.678 | 2.480 | 0.934 | 2.245 |
| string: silesia/dickens | 172528 | 969.4 ± 2.7% | 2950.0 ± 2.4% | 2063.9 ± 0.4% | 285.8 ± 1.3% | 2189.7 ± 1.8% | 491.6 ± 2.2% | 0.329 | 0.470 | 3.392 | 0.443 | 1.972 |
| string: silesia/nci | 1075110 | 1183.2 ± 2.0% | 3555.3 ± 0.4% | 2815.0 ± 5.7% | 426.9 ± 0.5% | 2428.4 ± 1.2% | 524.2 ± 3.8% | 0.333 | 0.420 | 2.771 | 0.487 | 2.257 |
| string: silesia/reymont | 1075159 | 910.6 ± 6.5% | 2198.3 ± 2.7% | 1805.4 ± 5.4% | 295.3 ± 1.0% | 1650.1 ± 1.2% | 472.8 ± 15.2% | 0.414 | 0.504 | 3.084 | 0.552 | 1.926 |
| string: silesia/samba | 97582 | 219.2 ± 0.5% | 2902.2 ± 0.6% | 1692.4 ± 2.9% | 239.0 ± 4.0% | 1280.1 ± 1.2% | 355.8 ± 1.8% | 0.076 | 0.130 | 0.917 | 0.171 | 0.616 |
| string: silesia/webster | 1098490 | 706.6 ± 0.4% | 2054.2 ± 2.3% | 1669.9 ± 3.0% | 284.7 ± 12.3% | 1663.9 ± 0.7% | 443.2 ± 1.4% | 0.344 | 0.423 | 2.482 | 0.425 | 1.594 |
| string: silesia/xml | 1090118 | 1102.2 ± 0.6% | 3795.0 ± 1.4% | 2161.3 ± 6.5% | 374.4 ± 6.1% | 2376.5 ± 9.1% | 508.6 ± 4.8% | 0.290 | 0.510 | 2.944 | 0.464 | 2.167 |
| string: canterbury/alice29.txt | 159425 | 715.6 ± 0.2% | 2458.3 ± 4.0% | 1909.4 ± 3.6% | 268.3 ± 2.8% | 1969.4 ± 3.2% | 432.8 ± 7.5% | 0.291 | 0.375 | 2.667 | 0.363 | 1.653 |
| string: canterbury/asyoulik.txt | 132198 | 597.3 ± 0.4% | 2145.5 ± 0.8% | 1481.6 ± 1.7% | 259.3 ± 0.9% | 1594.2 ± 2.7% | 405.0 ± 3.1% | 0.278 | 0.403 | 2.303 | 0.375 | 1.475 |
| string: canterbury/lcet10.txt | 441884 | 916.3 ± 4.2% | 2842.2 ± 0.8% | 2033.2 ± 2.1% | 309.2 ± 13.2% | 2137.5 ± 0.6% | 491.7 ± 5.9% | 0.322 | 0.451 | 2.964 | 0.429 | 1.863 |
| string: canterbury/plrabn12.txt | 503330 | 787.6 ± 3.2% | 2731.2 ± 2.3% | 1713.9 ± 1.9% | 282.3 ± 0.2% | 2018.8 ± 0.3% | 465.2 ± 1.3% | 0.288 | 0.460 | 2.790 | 0.390 | 1.693 |
| string: canterbury-large/E.coli | 1048578 | 15860.0 ± 3.1% | 7732.9 ± 0.4% | 3442.0 ± 6.4% | 799.3 ± 0.3% | 5513.0 ± 0.7% | 799.3 ± 1.2% | 2.051 | 4.608 | 19.841 | 2.877 | 19.843 |
| string: canterbury-large/bible.txt | 1055886 | 2628.4 ± 1.7% | 3936.6 ± 0.5% | 2580.0 ± 1.0% | 329.0 ± 14.0% | 2992.9 ± 5.5% | 601.6 ± 0.8% | 0.668 | 1.019 | 7.990 | 0.878 | 4.369 |
| string: canterbury-large/world192.txt | 1103121 | 632.3 ± 1.9% | 2010.3 ± 1.1% | 1668.4 ± 0.6% | 277.9 ± 2.3% | 1698.4 ± 4.0% | 433.2 ± 0.6% | 0.315 | 0.379 | 2.275 | 0.372 | 1.459 |
| string: http/html-1m | 1058582 | 2248.8 ± 0.4% | 3413.3 ± 0.6% | 2404.6 ± 3.7% | 370.8 ± 0.9% | 2724.1 ± 4.1% | 427.8 ± 0.6% | 0.659 | 0.935 | 6.065 | 0.826 | 5.256 |
| string: http/json-1m | 1190272 | 306.0 ± 0.7% | 1258.8 ± 0.2% | 1534.0 ± 8.7% | 311.5 ± 0.3% | 823.5 ± 6.4% | 293.6 ± 2.2% | 0.243 | 0.200 | 0.983 | 0.372 | 1.042 |
| string: http/js-1m | 1144362 | 384.1 ± 0.8% | 1349.7 ± 0.6% | 1170.7 ± 1.4% | 256.9 ± 1.1% | 1163.7 ± 7.4% | 295.1 ± 0.8% | 0.285 | 0.328 | 1.495 | 0.330 | 1.302 |
| string: http/css-1m | 1097820 | 633.7 ± 2.4% | 2568.6 ± 1.3% | 1545.8 ± 3.2% | 337.4 ± 5.8% | 1514.6 ± 0.7% | 334.3 ± 1.3% | 0.247 | 0.410 | 1.878 | 0.418 | 1.896 |
| string: dickens as Cyrillic and CJK | 1883069 | 945.3 ± 0.5% | 3239.9 ± 2.1% | 656.7 ± 3.7% | 244.2 ± 17.3% | 502.5 ± 14.1% | 142.4 ± 29.8% | 0.292 | 1.439 | 3.871 | 1.881 | 6.636 |
| string: dickens as Cyrillic and CJK, as \u escapes | 5075485 | 94.4 ± 0.4% | 1081.1 ± 0.8% | 833.4 ± 10.9% | 147.7 ± 1.9% | 382.7 ± 3.5% | 200.8 ± 4.8% | 0.087 | 0.113 | 0.639 | 0.247 | 0.470 |
| hex: silesia/dickens | 524290 | 16370.3 ± 0.9% | 7735.0 ± 1.3% | 3457.8 ± 0.9% | 423.0 ± 3.6% | 5524.9 ± 0.3% | 817.0 ± 7.1% | 2.116 | 4.734 | 38.701 | 2.963 | 20.037 |
| hex: silesia/mozilla | 524290 | 16149.2 ± 0.8% | 7720.2 ± 0.4% | 3451.8 ± 4.7% | 369.3 ± 0.3% | 5508.7 ± 0.4% | 816.8 ± 5.5% | 2.092 | 4.678 | 43.725 | 2.932 | 19.771 |
| hex: silesia/mr | 524290 | 16357.8 ± 0.8% | 7761.3 ± 0.6% | 3477.8 ± 7.5% | 516.0 ± 1.9% | 5516.0 ± 1.3% | 822.4 ± 0.7% | 2.108 | 4.704 | 31.704 | 2.966 | 19.889 |
| hex: silesia/nci | 524290 | 16531.8 ± 0.8% | 7756.0 ± 0.3% | 3465.0 ± 0.7% | 578.1 ± 0.3% | 5516.6 ± 0.6% | 823.3 ± 1.0% | 2.131 | 4.771 | 28.594 | 2.997 | 20.080 |
| hex: silesia/ooffice | 524290 | 16248.5 ± 0.5% | 7720.4 ± 7.3% | 3467.6 ± 0.2% | 320.1 ± 0.5% | 5497.8 ± 4.4% | 824.5 ± 0.3% | 2.105 | 4.686 | 50.763 | 2.955 | 19.708 |
| hex: silesia/osdb | 524290 | 16204.7 ± 0.4% | 7714.9 ± 0.7% | 3461.1 ± 0.6% | 407.1 ± 0.2% | 5507.3 ± 1.1% | 823.0 ± 0.5% | 2.100 | 4.682 | 39.808 | 2.942 | 19.689 |
| hex: silesia/reymont | 524290 | 16396.3 ± 0.8% | 7747.2 ± 0.4% | 3467.7 ± 0.3% | 435.4 ± 0.2% | 5529.8 ± 0.4% | 823.9 ± 1.3% | 2.116 | 4.728 | 37.656 | 2.965 | 19.900 |
| hex: silesia/samba | 524290 | 16230.7 ± 0.2% | 7732.9 ± 0.5% | 3459.7 ± 0.5% | 325.3 ± 1.5% | 5517.2 ± 1.1% | 826.8 ± 5.0% | 2.099 | 4.691 | 49.900 | 2.942 | 19.632 |
| hex: silesia/sao | 524290 | 16301.2 ± 0.5% | 7731.7 ± 0.9% | 3454.1 ± 0.4% | 263.2 ± 0.2% | 5513.8 ± 0.9% | 825.3 ± 7.8% | 2.108 | 4.719 | 61.946 | 2.956 | 19.751 |
| hex: silesia/webster | 524290 | 16043.3 ± 0.5% | 7709.9 ± 0.6% | 3458.5 ± 5.0% | 385.4 ± 0.3% | 5539.7 ± 6.6% | 828.7 ± 5.1% | 2.081 | 4.639 | 41.624 | 2.896 | 19.359 |
| hex: silesia/x-ray | 524290 | 16542.0 ± 0.6% | 7761.0 ± 7.1% | 3473.3 ± 0.2% | 386.0 ± 6.4% | 5534.7 ± 0.9% | 826.6 ± 0.8% | 2.131 | 4.763 | 42.860 | 2.989 | 20.011 |
| hex: silesia/xml | 524290 | 16317.5 ± 0.3% | 7733.3 ± 0.2% | 3459.1 ± 0.6% | 508.4 ± 0.2% | 5522.0 ± 15.8% | 827.0 ± 0.6% | 2.110 | 4.717 | 32.095 | 2.955 | 19.732 |
| hex: canterbury/alice29.txt | 304180 | 17897.6 ± 0.5% | 7793.0 ± 0.9% | 3573.2 ± 0.7% | 424.4 ± 0.2% | 5524.2 ± 0.3% | 832.7 ± 1.0% | 2.297 | 5.009 | 42.176 | 3.240 | 21.492 |
| hex: canterbury/asyoulik.txt | 250360 | 16729.2 ± 0.2% | 7795.5 ± 0.9% | 3569.1 ± 6.5% | 414.8 ± 0.1% | 5505.7 ± 5.7% | 832.5 ± 1.0% | 2.146 | 4.687 | 40.329 | 3.039 | 20.094 |
| hex: canterbury/cp.html | 49208 | 18377.6 ± 0.3% | 7788.1 ± 1.8% | 3604.5 ± 0.3% | 403.8 ± 0.2% | 5481.0 ± 0.2% | 812.7 ± 2.5% | 2.360 | 5.099 | 45.511 | 3.353 | 22.613 |
| hex: canterbury/fields.c | 22302 | 17789.5 ± 0.7% | 7695.1 ± 4.7% | 3593.6 ± 0.6% | 429.2 ± 0.4% | 5473.8 ± 0.3% | 800.4 ± 2.0% | 2.312 | 4.950 | 41.452 | 3.250 | 22.226 |
| hex: canterbury/grammar.lsp | 7444 | 17099.0 ± 9.0% | 7504.8 ± 0.7% | 3562.0 ± 0.2% | 482.6 ± 0.7% | 5365.7 ± 0.6% | 777.4 ± 2.9% | 2.278 | 4.800 | 35.432 | 3.187 | 21.994 |
| hex: canterbury/kennedy.xls | 524290 | 16328.7 ± 0.6% | 7772.2 ± 0.6% | 3459.4 ± 6.9% | 600.0 ± 0.4% | 5494.5 ± 16.3% | 800.6 ± 4.0% | 2.101 | 4.720 | 27.213 | 2.972 | 20.395 |
| hex: canterbury/lcet10.txt | 524290 | 16282.6 ± 7.4% | 7775.5 ± 0.3% | 3469.7 ± 6.8% | 426.7 ± 0.4% | 5518.3 ± 7.8% | 828.6 ± 1.2% | 2.094 | 4.693 | 38.159 | 2.951 | 19.651 |
| hex: canterbury/plrabn12.txt | 524290 | 16295.8 ± 0.5% | 7750.6 ± 0.5% | 3457.4 ± 0.7% | 414.1 ± 0.4% | 5529.1 ± 0.3% | 830.4 ± 1.3% | 2.103 | 4.713 | 39.350 | 2.947 | 19.623 |
| hex: canterbury/ptt5 | 524290 | 16345.0 ± 0.3% | 7764.8 ± 0.1% | 3466.2 ± 1.0% | 513.1 ± 0.2% | 5518.8 ± 1.2% | 823.7 ± 0.3% | 2.105 | 4.715 | 31.858 | 2.962 | 19.843 |
| hex: canterbury/sum | 76482 | 18094.5 ± 0.4% | 7821.9 ± 0.3% | 3618.2 ± 1.1% | 464.2 ± 5.9% | 5493.9 ± 13.3% | 823.9 ± 2.2% | 2.313 | 5.001 | 38.981 | 3.294 | 21.963 |
| hex: canterbury/xargs.1 | 8456 | 17184.3 ± 0.4% | 7540.1 ± 6.7% | 3551.1 ± 0.3% | 448.3 ± 6.4% | 5368.0 ± 0.3% | 805.6 ± 1.5% | 2.279 | 4.839 | 38.331 | 3.201 | 21.331 |
| hex: canterbury-large/E.coli | 524290 | 16270.4 ± 0.9% | 7715.0 ± 0.3% | 3464.0 ± 0.2% | 709.8 ± 0.6% | 5527.8 ± 0.5% | 820.3 ± 5.8% | 2.109 | 4.697 | 22.923 | 2.943 | 19.835 |
| hex: canterbury-large/bible.txt | 524290 | 16205.9 ± 1.6% | 7714.3 ± 0.5% | 3458.9 ± 1.4% | 438.6 ± 0.2% | 5523.0 ± 0.6% | 820.4 ± 3.7% | 2.101 | 4.685 | 36.945 | 2.934 | 19.754 |
| hex: canterbury-large/world192.txt | 524290 | 16259.8 ± 0.8% | 7720.8 ± 0.4% | 3463.5 ± 6.9% | 409.2 ± 0.5% | 5533.9 ± 16.0% | 801.6 ± 3.9% | 2.106 | 4.695 | 39.737 | 2.938 | 20.284 |
| hex: http/html-1kx1024 | 2099200 | 12131.3 ± 0.2% | 6622.9 ± 0.4% | 3277.2 ± 8.4% | 425.1 ± 12.3% | 4728.7 ± 0.6% | 735.9 ± 2.0% | 1.832 | 3.702 | 28.538 | 2.565 | 16.485 |
| hex: http/html-16kx64 | 2097280 | 17760.7 ± 0.6% | 7656.2 ± 0.6% | 3510.2 ± 4.5% | 431.1 ± 0.2% | 5424.0 ± 0.2% | 805.2 ± 2.6% | 2.320 | 5.060 | 41.202 | 3.274 | 22.057 |
| hex: http/html-1m | 524290 | 16112.7 ± 0.8% | 7759.1 ± 0.7% | 3467.3 ± 0.8% | 428.6 ± 0.1% | 5538.2 ± 0.5% | 803.9 ± 2.6% | 2.077 | 4.647 | 37.595 | 2.909 | 20.043 |
| hex: http/json-1kx1024 | 2099200 | 12112.5 ± 1.2% | 6623.5 ± 0.9% | 3270.9 ± 0.4% | 518.3 ± 1.4% | 4728.5 ± 0.4% | 725.8 ± 1.4% | 1.829 | 3.703 | 23.368 | 2.562 | 16.690 |
| hex: http/json-16kx64 | 2097280 | 17623.1 ± 4.1% | 7690.3 ± 0.2% | 3502.6 ± 0.2% | 544.1 ± 0.4% | 5430.2 ± 0.3% | 798.4 ± 2.3% | 2.292 | 5.031 | 32.389 | 3.245 | 22.074 |
| hex: http/json-1m | 524290 | 16533.0 ± 0.5% | 7785.1 ± 0.3% | 3474.3 ± 0.5% | 534.9 ± 0.6% | 5530.4 ± 0.5% | 796.7 ± 8.7% | 2.124 | 4.759 | 30.911 | 2.989 | 20.753 |
| hex: http/js-1kx1024 | 2099200 | 11682.2 ± 0.5% | 6632.4 ± 0.9% | 3260.8 ± 0.5% | 418.9 ± 0.9% | 4723.7 ± 0.6% | 740.1 ± 9.4% | 1.761 | 3.583 | 27.889 | 2.473 | 15.785 |
| hex: http/js-16kx64 | 2097280 | 17383.2 ± 0.5% | 7667.4 ± 0.3% | 3469.6 ± 7.2% | 424.8 ± 12.9% | 5426.1 ± 0.4% | 801.5 ± 2.6% | 2.267 | 5.010 | 40.922 | 3.204 | 21.690 |
| hex: http/js-1m | 524290 | 16129.2 ± 0.7% | 7746.6 ± 0.5% | 3463.0 ± 1.1% | 436.8 ± 0.2% | 5521.4 ± 0.4% | 797.8 ± 4.6% | 2.082 | 4.658 | 36.925 | 2.921 | 20.218 |
| hex: http/css-1kx1024 | 2099200 | 12093.5 ± 0.5% | 6628.4 ± 0.5% | 3270.7 ± 0.4% | 459.0 ± 0.4% | 4714.2 ± 13.5% | 737.3 ± 1.4% | 1.824 | 3.697 | 26.345 | 2.565 | 16.402 |
| hex: http/css-16kx64 | 2097280 | 17680.8 ± 1.0% | 7691.5 ± 0.4% | 3527.9 ± 0.8% | 467.8 ± 1.2% | 5431.9 ± 4.3% | 799.8 ± 1.9% | 2.299 | 5.012 | 37.793 | 3.255 | 22.106 |
| hex: http/css-1m | 524290 | 16234.2 ± 0.8% | 7748.8 ± 0.4% | 3463.9 ± 1.4% | 455.1 ± 0.4% | 5490.3 ± 7.0% | 803.5 ± 4.6% | 2.095 | 4.687 | 35.671 | 2.957 | 20.204 |
| hex: shuffled/dickens-1m | 524290 | 16571.9 ± 0.8% | 7732.0 ± 0.5% | 3457.4 ± 0.9% | 424.2 ± 0.4% | 5522.6 ± 7.8% | 826.4 ± 0.7% | 2.143 | 4.793 | 39.066 | 3.001 | 20.052 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 619.1 ± 0.6% | 1084.1 ± 14.8% | 869.2 ± 0.8% | 331.9 ± 1.5% | 365.1 ± 0.6% | 308.0 ± 2.0% | 0.571 | 0.712 | 1.865 | 1.696 | 2.010 |
| qlog records, JSON text sequence | 1467503 | 535.6 ± 0.2% | 863.9 ± 0.2% | 704.9 ± 0.5% | 323.5 ± 0.4% | 393.7 ± 3.3% | 232.4 ± 1.2% | 0.620 | 0.760 | 1.656 | 1.361 | 2.305 |
| string: silesia/dickens | 172528 | 9070.0 ± 2.5% | 3148.7 ± 0.4% | 2050.8 ± 0.1% | 363.4 ± 0.3% | 1420.2 ± 0.5% | 562.4 ± 0.5% | 2.881 | 4.423 | 24.957 | 6.386 | 16.128 |
| string: silesia/nci | 1075110 | 8738.4 ± 0.4% | 3181.5 ± 0.1% | 2830.8 ± 1.4% | 774.6 ± 0.8% | 1540.6 ± 0.4% | 563.4 ± 0.9% | 2.747 | 3.087 | 11.281 | 5.672 | 15.509 |
| string: silesia/reymont | 1075159 | 3842.6 ± 3.1% | 1598.6 ± 1.1% | 1731.7 ± 6.9% | 373.1 ± 0.4% | 1251.9 ± 0.6% | 549.3 ± 0.6% | 2.404 | 2.219 | 10.299 | 3.069 | 6.995 |
| string: silesia/samba | 97582 | 4608.0 ± 1.1% | 2020.2 ± 1.1% | 2192.4 ± 0.3% | 301.7 ± 2.0% | 1002.3 ± 0.8% | 616.9 ± 0.2% | 2.281 | 2.102 | 15.274 | 4.597 | 7.470 |
| string: silesia/webster | 1098490 | 5071.8 ± 0.8% | 1638.2 ± 0.5% | 1531.3 ± 0.3% | 364.9 ± 1.3% | 1200.0 ± 2.4% | 455.2 ± 1.1% | 3.096 | 3.312 | 13.898 | 4.227 | 11.141 |
| string: silesia/xml | 1090118 | 8058.6 ± 0.5% | 2737.6 ± 3.7% | 2172.6 ± 0.1% | 532.4 ± 0.7% | 1577.4 ± 1.0% | 561.9 ± 0.6% | 2.944 | 3.709 | 15.137 | 5.109 | 14.343 |
| string: canterbury/alice29.txt | 159425 | 9713.3 ± 0.4% | 2655.9 ± 1.0% | 1797.3 ± 1.9% | 341.8 ± 1.7% | 1266.4 ± 0.8% | 558.3 ± 4.8% | 3.657 | 5.404 | 28.421 | 7.670 | 17.397 |
| string: canterbury/asyoulik.txt | 132198 | 8101.2 ± 1.4% | 2273.5 ± 9.4% | 1530.4 ± 7.4% | 351.4 ± 0.6% | 1118.8 ± 1.3% | 543.3 ± 1.1% | 3.563 | 5.294 | 23.054 | 7.241 | 14.910 |
| string: canterbury/lcet10.txt | 441884 | 9145.0 ± 0.8% | 2520.3 ± 0.5% | 1993.0 ± 0.1% | 397.6 ± 1.3% | 1388.3 ± 0.8% | 556.6 ± 1.1% | 3.628 | 4.589 | 23.001 | 6.587 | 16.430 |
| string: canterbury/plrabn12.txt | 503330 | 6129.1 ± 2.0% | 1812.5 ± 0.2% | 1680.6 ± 0.4% | 371.7 ± 1.2% | 1291.4 ± 3.8% | 559.4 ± 7.4% | 3.382 | 3.647 | 16.491 | 4.746 | 10.956 |
| string: canterbury-large/E.coli | 1048578 | 29300.1 ± 2.7% | 18037.6 ± 14.2% | 3384.6 ± 0.3% | 1410.6 ± 0.9% | 2504.6 ± 0.8% | 576.1 ± 0.6% | 1.624 | 8.657 | 20.771 | 11.698 | 50.861 |
| string: canterbury-large/bible.txt | 1055886 | 6945.6 ± 0.9% | 3940.4 ± 1.5% | 2662.6 ± 0.2% | 441.8 ± 0.5% | 1870.5 ± 0.9% | 567.9 ± 0.6% | 1.763 | 2.609 | 15.719 | 3.713 | 12.230 |
| string: canterbury-large/world192.txt | 1103121 | 4834.4 ± 5.2% | 1430.0 ± 0.9% | 1617.5 ± 0.6% | 365.1 ± 1.1% | 1174.3 ± 0.5% | 540.2 ± 0.6% | 3.381 | 2.989 | 13.241 | 4.117 | 8.949 |
| string: http/html-1m | 1058582 | 8625.9 ± 0.6% | 3848.0 ± 1.1% | 2485.9 ± 12.9% | 434.5 ± 3.5% | 1806.8 ± 1.6% | 521.2 ± 12.2% | 2.242 | 3.470 | 19.852 | 4.774 | 16.549 |
| string: http/json-1m | 1190272 | 6776.8 ± 0.5% | 1215.7 ± 0.2% | 1317.8 ± 21.4% | 410.0 ± 1.5% | 893.1 ± 28.3% | 508.2 ± 0.6% | 5.575 | 5.143 | 16.531 | 7.588 | 13.336 |
| string: http/js-1m | 1144362 | 5129.9 ± 1.7% | 991.0 ± 0.2% | 1063.9 ± 0.3% | 309.2 ± 0.8% | 938.0 ± 2.6% | 474.5 ± 2.3% | 5.177 | 4.822 | 16.591 | 5.469 | 10.811 |
| string: http/css-1m | 1097820 | 6946.1 ± 0.7% | 1252.2 ± 0.6% | 1619.8 ± 0.8% | 440.4 ± 8.7% | 1046.6 ± 0.7% | 527.5 ± 15.5% | 5.547 | 4.288 | 15.773 | 6.637 | 13.168 |
| string: dickens as Cyrillic and CJK | 1883069 | 5379.9 ± 0.4% | 3125.7 ± 0.9% | 307.9 ± 1.8% | 275.5 ± 0.3% | 449.8 ± 2.2% | 292.0 ± 0.4% | 1.721 | 17.470 | 19.528 | 11.961 | 18.426 |
| hex: silesia/dickens | 524290 | 32104.5 ± 7.3% | 1541.1 ± 0.5% | 1083.8 ± 0.6% | 422.9 ± 1.6% | 1023.0 ± 13.1% | 447.2 ± 1.0% | 20.833 | 29.623 | 75.911 | 31.383 | 71.788 |
| hex: silesia/mozilla | 524290 | 35028.6 ± 1.1% | 1545.6 ± 0.7% | 1084.2 ± 0.4% | 370.6 ± 1.1% | 1040.8 ± 10.5% | 449.0 ± 5.3% | 22.663 | 32.308 | 94.509 | 33.655 | 78.022 |
| hex: silesia/mr | 524290 | 33758.5 ± 0.5% | 1541.4 ± 6.1% | 1083.8 ± 0.4% | 509.9 ± 0.4% | 1046.5 ± 1.3% | 448.6 ± 0.5% | 21.902 | 31.148 | 66.210 | 32.257 | 75.254 |
| hex: silesia/nci | 524290 | 33457.0 ± 0.4% | 1538.3 ± 0.9% | 1082.6 ± 0.4% | 580.1 ± 0.3% | 1046.6 ± 0.9% | 448.0 ± 0.5% | 21.750 | 30.903 | 57.679 | 31.968 | 74.674 |
| hex: silesia/ooffice | 524290 | 33426.9 ± 0.5% | 1541.8 ± 1.1% | 1082.9 ± 2.2% | 328.4 ± 9.6% | 1047.9 ± 0.3% | 447.6 ± 0.6% | 21.680 | 30.869 | 101.781 | 31.897 | 74.684 |
| hex: silesia/osdb | 524290 | 35184.3 ± 1.8% | 1546.2 ± 0.5% | 1084.8 ± 0.9% | 416.2 ± 0.2% | 1048.8 ± 0.7% | 447.0 ± 1.1% | 22.755 | 32.433 | 84.527 | 33.547 | 78.719 |
| hex: silesia/reymont | 524290 | 34640.6 ± 4.1% | 1540.3 ± 0.9% | 1083.3 ± 6.4% | 445.4 ± 0.1% | 1048.9 ± 0.4% | 446.6 ± 0.6% | 22.490 | 31.976 | 77.769 | 33.025 | 77.568 |
| hex: silesia/samba | 524290 | 34720.1 ± 4.3% | 1537.2 ± 8.2% | 1084.8 ± 0.7% | 333.3 ± 1.6% | 1048.6 ± 1.0% | 448.3 ± 0.4% | 22.587 | 32.007 | 104.169 | 33.111 | 77.442 |
| hex: silesia/sao | 524290 | 33748.8 ± 0.5% | 1540.8 ± 8.2% | 1084.1 ± 0.5% | 267.9 ± 0.4% | 1048.5 ± 0.4% | 445.3 ± 0.6% | 21.904 | 31.131 | 125.990 | 32.187 | 75.797 |
| hex: silesia/webster | 524290 | 36594.6 ± 13.3% | 1545.6 ± 2.1% | 1084.8 ± 0.4% | 407.5 ± 0.7% | 1048.1 ± 0.9% | 446.5 ± 1.0% | 23.677 | 33.734 | 89.813 | 34.915 | 81.967 |
| hex: silesia/x-ray | 524290 | 33688.9 ± 0.6% | 1537.4 ± 0.8% | 1084.0 ± 0.5% | 398.8 ± 0.1% | 1053.0 ± 2.7% | 447.4 ± 0.5% | 21.913 | 31.079 | 84.472 | 31.992 | 75.305 |
| hex: silesia/xml | 524290 | 32928.1 ± 2.7% | 1549.0 ± 0.5% | 1083.2 ± 1.5% | 579.7 ± 7.5% | 1047.2 ± 1.1% | 446.6 ± 0.6% | 21.258 | 30.400 | 56.798 | 31.443 | 73.732 |
| hex: canterbury/alice29.txt | 304180 | 33430.4 ± 1.2% | 1578.9 ± 1.5% | 1091.5 ± 0.6% | 429.5 ± 0.2% | 1070.4 ± 0.1% | 450.8 ± 1.1% | 21.173 | 30.627 | 77.844 | 31.231 | 74.156 |
| hex: canterbury/asyoulik.txt | 250360 | 32448.8 ± 0.3% | 1596.4 ± 0.4% | 1097.4 ± 0.4% | 423.7 ± 3.3% | 1069.5 ± 17.7% | 452.4 ± 4.4% | 20.327 | 29.569 | 76.587 | 30.341 | 71.728 |
| hex: canterbury/cp.html | 49208 | 30740.5 ± 0.2% | 1620.7 ± 0.4% | 1106.6 ± 0.5% | 462.6 ± 1.1% | 1072.5 ± 2.4% | 446.5 ± 3.8% | 18.967 | 27.778 | 66.450 | 28.662 | 68.854 |
| hex: canterbury/fields.c | 22302 | 30970.9 ± 0.4% | 1597.6 ± 0.1% | 1100.2 ± 0.1% | 541.9 ± 0.7% | 1070.5 ± 10.9% | 454.9 ± 0.4% | 19.386 | 28.150 | 57.150 | 28.932 | 68.082 |
| hex: canterbury/grammar.lsp | 7444 | 32383.9 ± 0.3% | 1632.9 ± 0.6% | 1112.7 ± 0.3% | 564.1 ± 0.1% | 1082.8 ± 0.8% | 460.9 ± 0.7% | 19.832 | 29.103 | 57.412 | 29.907 | 70.257 |
| hex: canterbury/kennedy.xls | 524290 | 31679.0 ± 0.5% | 1538.9 ± 0.7% | 1083.4 ± 0.7% | 589.8 ± 0.2% | 1035.2 ± 8.2% | 447.5 ± 0.6% | 20.585 | 29.241 | 53.707 | 30.600 | 70.790 |
| hex: canterbury/lcet10.txt | 524290 | 34226.6 ± 2.3% | 1545.7 ± 1.1% | 1083.3 ± 0.6% | 428.9 ± 1.4% | 1048.8 ± 0.4% | 447.8 ± 1.1% | 22.143 | 31.595 | 79.810 | 32.633 | 76.431 |
| hex: canterbury/plrabn12.txt | 524290 | 33275.7 ± 10.3% | 1542.3 ± 0.3% | 1081.8 ± 0.9% | 419.2 ± 2.5% | 1047.4 ± 0.8% | 447.0 ± 1.2% | 21.576 | 30.760 | 79.373 | 31.770 | 74.438 |
| hex: canterbury/ptt5 | 524290 | 33522.9 ± 0.7% | 1540.7 ± 0.5% | 1084.3 ± 12.7% | 498.4 ± 0.7% | 1044.1 ± 0.6% | 448.7 ± 7.1% | 21.758 | 30.916 | 67.263 | 32.108 | 74.715 |
| hex: canterbury/sum | 76482 | 35473.0 ± 2.9% | 1618.1 ± 0.2% | 1103.3 ± 8.5% | 520.9 ± 0.7% | 1071.7 ± 2.1% | 458.8 ± 0.3% | 21.923 | 32.153 | 68.097 | 33.100 | 77.322 |
| hex: canterbury/xargs.1 | 8456 | 34416.9 ± 0.2% | 1625.2 ± 0.6% | 1111.0 ± 1.0% | 597.3 ± 0.3% | 1083.0 ± 1.3% | 460.7 ± 0.6% | 21.177 | 30.980 | 57.621 | 31.779 | 74.698 |
| hex: canterbury-large/E.coli | 524290 | 30878.8 ± 7.5% | 1531.7 ± 1.9% | 1081.6 ± 1.1% | 597.8 ± 0.9% | 1023.3 ± 0.3% | 449.4 ± 0.6% | 20.160 | 28.548 | 51.657 | 30.177 | 68.712 |
| hex: canterbury-large/bible.txt | 524290 | 35504.0 ± 0.8% | 1540.5 ± 1.0% | 1083.9 ± 1.5% | 441.4 ± 0.7% | 1050.1 ± 0.4% | 447.2 ± 1.2% | 23.047 | 32.755 | 80.436 | 33.809 | 79.393 |
| hex: canterbury-large/world192.txt | 524290 | 35092.0 ± 1.0% | 1542.5 ± 0.6% | 1083.4 ± 0.8% | 420.6 ± 1.0% | 1047.2 ± 0.4% | 447.4 ± 0.8% | 22.750 | 32.389 | 83.433 | 33.511 | 78.427 |
| hex: http/html-1kx1024 | 2099200 | 22741.9 ± 0.2% | 1604.5 ± 0.5% | 1087.5 ± 0.3% | 457.8 ± 0.3% | 1069.3 ± 0.4% | 452.5 ± 1.2% | 14.174 | 20.912 | 49.671 | 21.267 | 50.257 |
| hex: http/html-16kx64 | 2097280 | 29876.0 ± 0.6% | 1610.3 ± 0.2% | 1103.2 ± 0.2% | 462.5 ± 0.1% | 1066.5 ± 0.7% | 457.0 ± 0.4% | 18.553 | 27.080 | 64.598 | 28.013 | 65.369 |
| hex: http/html-1m | 524290 | 29432.3 ± 0.4% | 1544.4 ± 0.4% | 1086.6 ± 1.1% | 444.8 ± 4.8% | 1031.8 ± 0.5% | 447.3 ± 1.0% | 19.058 | 27.088 | 66.172 | 28.526 | 65.803 |
| hex: http/json-1kx1024 | 2099200 | 22559.3 ± 1.3% | 1604.3 ± 36.4% | 1087.0 ± 0.7% | 564.8 ± 0.5% | 1061.6 ± 16.3% | 452.2 ± 1.5% | 14.061 | 20.753 | 39.944 | 21.250 | 49.883 |
| hex: http/json-16kx64 | 2097280 | 29951.9 ± 1.5% | 1610.7 ± 0.2% | 1105.1 ± 0.3% | 573.4 ± 0.2% | 1039.3 ± 1.0% | 456.5 ± 0.4% | 18.596 | 27.103 | 52.236 | 28.818 | 65.617 |
| hex: http/json-1m | 524290 | 31778.1 ± 1.2% | 1537.3 ± 1.0% | 1084.2 ± 1.2% | 587.5 ± 0.9% | 1034.0 ± 0.3% | 450.2 ± 1.3% | 20.672 | 29.310 | 54.090 | 30.732 | 70.592 |
| hex: http/js-1kx1024 | 2099200 | 22740.0 ± 3.3% | 1602.6 ± 1.3% | 1088.8 ± 0.1% | 445.4 ± 0.1% | 1065.4 ± 0.8% | 450.5 ± 9.4% | 14.189 | 20.885 | 51.054 | 21.344 | 50.473 |
| hex: http/js-16kx64 | 2097280 | 29991.8 ± 0.6% | 1610.7 ± 0.4% | 1102.4 ± 0.2% | 436.4 ± 0.2% | 971.9 ± 13.3% | 456.6 ± 5.4% | 18.621 | 27.205 | 68.730 | 30.857 | 65.681 |
| hex: http/js-1m | 524290 | 30746.0 ± 0.8% | 1553.6 ± 0.5% | 1088.9 ± 0.8% | 449.7 ± 0.2% | 1029.1 ± 12.6% | 450.7 ± 1.1% | 19.790 | 28.235 | 68.375 | 29.878 | 68.214 |
| hex: http/css-1kx1024 | 2099200 | 22229.5 ± 5.4% | 1601.3 ± 0.3% | 1087.7 ± 0.4% | 500.2 ± 0.8% | 1072.5 ± 1.9% | 452.5 ± 0.7% | 13.882 | 20.437 | 44.445 | 20.727 | 49.131 |
| hex: http/css-16kx64 | 2097280 | 29901.7 ± 0.9% | 1606.1 ± 0.5% | 1104.2 ± 0.7% | 506.5 ± 0.3% | 1069.2 ± 0.3% | 456.9 ± 0.4% | 18.617 | 27.079 | 59.034 | 27.967 | 65.447 |
| hex: http/css-1m | 524290 | 31498.4 ± 10.7% | 1536.1 ± 1.1% | 1083.0 ± 0.5% | 482.4 ± 6.5% | 1027.6 ± 0.5% | 449.2 ± 1.5% | 20.506 | 29.085 | 65.300 | 30.654 | 70.123 |
| hex: shuffled/dickens-1m | 524290 | 34763.2 ± 0.4% | 1544.1 ± 1.0% | 1085.4 ± 0.5% | 429.0 ± 0.3% | 1042.7 ± 13.0% | 448.2 ± 4.2% | 22.513 | 32.029 | 81.028 | 33.339 | 77.554 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.722 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.681 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.678 of yyjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.934 of serde_json.
- string: silesia/dickens, decoding through TextReader.next: stdx runs at 0.329 of simdjson.
- string: silesia/dickens, decoding through TextReader.next: stdx runs at 0.470 of yyjson.
- string: silesia/dickens, decoding through TextReader.next: stdx runs at 0.443 of serde_json.
- string: silesia/nci, decoding through TextReader.next: stdx runs at 0.333 of simdjson.
- string: silesia/nci, decoding through TextReader.next: stdx runs at 0.420 of yyjson.
- string: silesia/nci, decoding through TextReader.next: stdx runs at 0.487 of serde_json.
- string: silesia/reymont, decoding through TextReader.next: stdx runs at 0.414 of simdjson.
- string: silesia/reymont, decoding through TextReader.next: stdx runs at 0.504 of yyjson.
- string: silesia/reymont, decoding through TextReader.next: stdx runs at 0.552 of serde_json.
- string: silesia/samba, decoding through TextReader.next: stdx runs at 0.076 of simdjson.
- string: silesia/samba, decoding through TextReader.next: stdx runs at 0.130 of yyjson.
- string: silesia/samba, decoding through TextReader.next: stdx runs at 0.917 of std.json.
- string: silesia/samba, decoding through TextReader.next: stdx runs at 0.171 of serde_json.
- string: silesia/samba, decoding through TextReader.next: stdx runs at 0.616 of Go jsontext.
- string: silesia/webster, decoding through TextReader.next: stdx runs at 0.344 of simdjson.
- string: silesia/webster, decoding through TextReader.next: stdx runs at 0.423 of yyjson.
- string: silesia/webster, decoding through TextReader.next: stdx runs at 0.425 of serde_json.
- string: silesia/xml, decoding through TextReader.next: stdx runs at 0.290 of simdjson.
- string: silesia/xml, decoding through TextReader.next: stdx runs at 0.510 of yyjson.
- string: silesia/xml, decoding through TextReader.next: stdx runs at 0.464 of serde_json.
- string: canterbury/alice29.txt, decoding through TextReader.next: stdx runs at 0.291 of simdjson.
- string: canterbury/alice29.txt, decoding through TextReader.next: stdx runs at 0.375 of yyjson.
- string: canterbury/alice29.txt, decoding through TextReader.next: stdx runs at 0.363 of serde_json.
- string: canterbury/asyoulik.txt, decoding through TextReader.next: stdx runs at 0.278 of simdjson.
- string: canterbury/asyoulik.txt, decoding through TextReader.next: stdx runs at 0.403 of yyjson.
- string: canterbury/asyoulik.txt, decoding through TextReader.next: stdx runs at 0.375 of serde_json.
- string: canterbury/lcet10.txt, decoding through TextReader.next: stdx runs at 0.322 of simdjson.
- string: canterbury/lcet10.txt, decoding through TextReader.next: stdx runs at 0.451 of yyjson.
- string: canterbury/lcet10.txt, decoding through TextReader.next: stdx runs at 0.429 of serde_json.
- string: canterbury/plrabn12.txt, decoding through TextReader.next: stdx runs at 0.288 of simdjson.
- string: canterbury/plrabn12.txt, decoding through TextReader.next: stdx runs at 0.460 of yyjson.
- string: canterbury/plrabn12.txt, decoding through TextReader.next: stdx runs at 0.390 of serde_json.
- string: canterbury-large/bible.txt, decoding through TextReader.next: stdx runs at 0.668 of simdjson.
- string: canterbury-large/bible.txt, decoding through TextReader.next: stdx runs at 0.878 of serde_json.
- string: canterbury-large/world192.txt, decoding through TextReader.next: stdx runs at 0.315 of simdjson.
- string: canterbury-large/world192.txt, decoding through TextReader.next: stdx runs at 0.379 of yyjson.
- string: canterbury-large/world192.txt, decoding through TextReader.next: stdx runs at 0.372 of serde_json.
- string: http/html-1m, decoding through TextReader.next: stdx runs at 0.659 of simdjson.
- string: http/html-1m, decoding through TextReader.next: stdx runs at 0.935 of yyjson.
- string: http/html-1m, decoding through TextReader.next: stdx runs at 0.826 of serde_json.
- string: http/json-1m, decoding through TextReader.next: stdx runs at 0.243 of simdjson.
- string: http/json-1m, decoding through TextReader.next: stdx runs at 0.200 of yyjson.
- string: http/json-1m, decoding through TextReader.next: stdx runs at 0.372 of serde_json.
- string: http/js-1m, decoding through TextReader.next: stdx runs at 0.285 of simdjson.
- string: http/js-1m, decoding through TextReader.next: stdx runs at 0.328 of yyjson.
- string: http/js-1m, decoding through TextReader.next: stdx runs at 0.330 of serde_json.
- string: http/css-1m, decoding through TextReader.next: stdx runs at 0.247 of simdjson.
- string: http/css-1m, decoding through TextReader.next: stdx runs at 0.410 of yyjson.
- string: http/css-1m, decoding through TextReader.next: stdx runs at 0.418 of serde_json.
- string: dickens as Cyrillic and CJK, decoding through TextReader.next: stdx runs at 0.292 of simdjson.
- string: dickens as Cyrillic and CJK, as \u escapes, decoding through TextReader.next: stdx runs at 0.087 of simdjson.
- string: dickens as Cyrillic and CJK, as \u escapes, decoding through TextReader.next: stdx runs at 0.113 of yyjson.
- string: dickens as Cyrillic and CJK, as \u escapes, decoding through TextReader.next: stdx runs at 0.639 of std.json.
- string: dickens as Cyrillic and CJK, as \u escapes, decoding through TextReader.next: stdx runs at 0.247 of serde_json.
- string: dickens as Cyrillic and CJK, as \u escapes, decoding through TextReader.next: stdx runs at 0.470 of Go jsontext.
- CLDR supplemental, 34 texts, encoding through TextWriter's methods: stdx runs at 0.571 of simdjson.
- CLDR supplemental, 34 texts, encoding through TextWriter's methods: stdx runs at 0.712 of yyjson.
- qlog records, JSON text sequence, encoding through TextWriter's methods: stdx runs at 0.620 of simdjson.
- qlog records, JSON text sequence, encoding through TextWriter's methods: stdx runs at 0.760 of yyjson.
