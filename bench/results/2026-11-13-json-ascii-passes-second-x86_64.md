# bench-json

| Field | Value |
|---|---|
| Commit | 4dbe46c |
| Runner label | ubuntu-24.04 |
| Image version | 20261111.370.1 |
| CPU model | AMD EPYC 7763 64-Core Processor |
| Virtual CPUs | 4 |
| Kernel | 7.0.0-1017-azure |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/43464704827 |
| Date | 2026-11-13 |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1. The `TextReader.next_items` column is that helper's queued tokens a slice a call (decision 79), over many tokens a call.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | TextReader.next_items | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1014.1 ± 1.0% | 0.471 | 1.012 | 1.056 | 1.040 | 0.416 | 1.060 | 1.062 | 0.369 | 0.825 | 0.947 | 0.097 |
| qlog records, JSON text sequence | 1467503 | 842.8 ± 1.2% | 0.725 | 1.011 | 1.023 | 1.009 | 0.393 | 1.034 | 1.000 | 0.346 | 0.907 | 1.032 | 0.110 |
| string: silesia/dickens | 172528 | 5762.7 ± 4.1% | 0.024 | 0.621 | 0.976 | 0.988 | 0.150 | 0.955 | 0.987 | 0.154 | 0.995 | 0.961 | 0.024 |
| string: silesia/nci | 1075110 | 4546.1 ± 0.2% | 0.030 | 0.781 | 1.155 | 1.161 | 0.251 | 1.127 | 1.159 | 0.251 | 1.002 | 1.001 | 0.030 |
| string: silesia/reymont | 1075159 | 3703.0 ± 0.5% | 0.038 | 0.509 | 0.732 | 0.733 | 0.244 | 0.726 | 0.732 | 0.245 | 1.001 | 1.001 | 0.037 |
| string: silesia/samba | 97582 | 3279.5 ± 0.7% | 0.037 | 0.905 | 1.040 | 1.040 | 0.067 | 0.852 | 1.040 | 0.067 | 0.999 | 1.001 | 0.037 |
| string: silesia/webster | 1098490 | 3712.0 ± 0.3% | 0.037 | 0.657 | 1.011 | 1.036 | 0.183 | 1.001 | 1.038 | 0.183 | 1.004 | 1.004 | 0.036 |
| string: silesia/xml | 1090118 | 5179.5 ± 1.1% | 0.027 | 0.833 | 0.965 | 0.972 | 0.215 | 0.963 | 0.970 | 0.215 | 1.007 | 1.002 | 0.027 |
| string: canterbury/alice29.txt | 159425 | 4985.6 ± 1.3% | 0.027 | 0.672 | 0.911 | 0.981 | 0.145 | 0.943 | 0.978 | 0.146 | 1.004 | 1.007 | 0.027 |
| string: canterbury/asyoulik.txt | 132198 | 3352.1 ± 0.5% | 0.039 | 0.889 | 1.191 | 1.260 | 0.183 | 1.164 | 1.257 | 0.185 | 1.004 | 1.003 | 0.040 |
| string: canterbury/lcet10.txt | 441884 | 5560.3 ± 0.7% | 0.025 | 0.583 | 1.071 | 1.086 | 0.157 | 1.039 | 1.086 | 0.157 | 1.001 | 1.000 | 0.025 |
| string: canterbury/plrabn12.txt | 503330 | 4957.3 ± 1.0% | 0.028 | 0.689 | 0.925 | 0.963 | 0.168 | 0.906 | 0.965 | 0.168 | 1.000 | 1.000 | 0.028 |
| string: canterbury-large/E.coli | 1048578 | 29195.8 ± 2.6% | 0.052 | 1.008 | 0.758 | 1.013 | 0.533 | 1.011 | 1.013 | 0.534 | 1.145 | 1.148 | 0.005 |
| string: canterbury-large/bible.txt | 1055886 | 9511.6 ± 0.6% | 0.015 | 0.478 | 0.629 | 0.626 | 0.259 | 0.685 | 0.627 | 0.259 | 0.999 | 1.002 | 0.015 |
| string: canterbury-large/world192.txt | 1103121 | 3617.2 ± 0.8% | 0.037 | 0.664 | 0.974 | 1.002 | 0.168 | 0.963 | 1.005 | 0.168 | 1.002 | 1.001 | 0.037 |
| string: http/html-1m | 1058582 | 7857.0 ± 1.8% | 0.018 | 0.534 | 0.748 | 0.750 | 0.277 | 0.775 | 0.750 | 0.277 | 0.997 | 1.002 | 0.018 |
| string: http/json-1m | 1190272 | 3139.4 ± 0.3% | 0.040 | 0.403 | 0.460 | 0.461 | 0.099 | 0.416 | 0.461 | 0.099 | 1.000 | 1.000 | 0.041 |
| string: http/js-1m | 1144362 | 2671.8 ± 4.9% | 0.048 | 0.649 | 0.864 | 0.911 | 0.146 | 0.854 | 0.911 | 0.146 | 1.003 | 1.002 | 0.048 |
| string: http/css-1m | 1097820 | 2683.7 ± 0.8% | 0.050 | 0.816 | 1.115 | 1.208 | 0.244 | 1.121 | 1.156 | 0.245 | 1.005 | 1.001 | 0.050 |
| string: dickens as Cyrillic and CJK | 1883069 | 5184.8 ± 0.2% | 0.021 | 0.059 | 0.497 | 0.497 | 0.182 | 0.495 | 0.497 | 0.182 | 0.987 | 0.987 | 0.021 |
| string: dickens as Cyrillic and CJK, as \u escapes | 5075485 | 1060.1 ± 0.8% | 0.093 | 0.974 | 0.975 | 0.976 | 0.089 | 0.708 | 0.975 | 0.089 | 1.002 | 1.002 | 0.093 |
| hex: silesia/dickens | 524290 | 29350.9 ± 1.5% | 0.051 | 1.009 | 0.749 | 1.009 | 0.550 | 1.001 | 1.009 | 0.547 | 1.130 | 1.131 | 0.005 |
| hex: silesia/mozilla | 524290 | 29514.3 ± 1.5% | 0.051 | 1.004 | 0.751 | 0.999 | 0.556 | 1.007 | 1.008 | 0.553 | 1.136 | 1.133 | 0.005 |
| hex: silesia/mr | 524290 | 30859.4 ± 1.0% | 0.049 | 1.001 | 0.713 | 1.005 | 0.527 | 1.003 | 1.006 | 0.526 | 1.090 | 1.090 | 0.005 |
| hex: silesia/nci | 524290 | 29492.7 ± 2.2% | 0.051 | 0.997 | 0.740 | 1.005 | 0.550 | 1.006 | 1.006 | 0.547 | 1.134 | 1.132 | 0.005 |
| hex: silesia/ooffice | 524290 | 30075.1 ± 1.2% | 0.050 | 0.997 | 0.732 | 1.010 | 0.538 | 1.011 | 1.010 | 0.537 | 1.119 | 1.115 | 0.005 |
| hex: silesia/osdb | 524290 | 28115.9 ± 1.0% | 0.053 | 0.992 | 0.764 | 0.999 | 0.569 | 0.998 | 0.997 | 0.565 | 1.183 | 1.189 | 0.005 |
| hex: silesia/reymont | 524290 | 30072.8 ± 1.0% | 0.050 | 1.010 | 0.730 | 1.008 | 0.539 | 1.010 | 1.010 | 0.536 | 1.106 | 1.106 | 0.005 |
| hex: silesia/samba | 524290 | 29801.6 ± 2.5% | 0.051 | 0.987 | 0.737 | 0.993 | 0.541 | 0.990 | 0.987 | 0.536 | 1.124 | 1.126 | 0.005 |
| hex: silesia/sao | 524290 | 29453.2 ± 0.6% | 0.051 | 0.992 | 0.739 | 1.005 | 0.544 | 0.998 | 1.001 | 0.540 | 1.131 | 1.128 | 0.005 |
| hex: silesia/webster | 524290 | 29764.4 ± 1.7% | 0.050 | 1.005 | 0.742 | 1.007 | 0.541 | 1.008 | 0.991 | 0.538 | 1.119 | 1.121 | 0.005 |
| hex: silesia/x-ray | 524290 | 28968.9 ± 1.4% | 0.052 | 1.006 | 0.765 | 1.022 | 0.555 | 1.005 | 1.007 | 0.550 | 1.152 | 1.153 | 0.005 |
| hex: silesia/xml | 524290 | 29466.4 ± 1.9% | 0.051 | 1.004 | 0.750 | 1.022 | 0.552 | 1.005 | 1.014 | 0.548 | 1.127 | 1.132 | 0.005 |
| hex: canterbury/alice29.txt | 304180 | 35450.4 ± 1.9% | 0.043 | 1.017 | 0.616 | 1.014 | 0.503 | 1.015 | 1.019 | 0.502 | 0.954 | 0.953 | 0.004 |
| hex: canterbury/asyoulik.txt | 250360 | 38084.0 ± 1.2% | 0.040 | 1.007 | 0.589 | 1.011 | 0.475 | 1.012 | 1.015 | 0.476 | 0.885 | 0.880 | 0.004 |
| hex: canterbury/cp.html | 49208 | 39040.6 ± 2.3% | 0.040 | 1.001 | 0.564 | 1.001 | 0.463 | 1.001 | 1.000 | 0.469 | 0.837 | 0.839 | 0.004 |
| hex: canterbury/fields.c | 22302 | 37501.7 ± 0.9% | 0.041 | 1.007 | 0.563 | 1.011 | 0.466 | 1.012 | 1.008 | 0.478 | 0.843 | 0.845 | 0.004 |
| hex: canterbury/grammar.lsp | 7444 | 37218.6 ± 2.5% | 0.041 | 1.004 | 0.524 | 1.007 | 0.414 | 1.004 | 1.005 | 0.445 | 0.739 | 0.737 | 0.004 |
| hex: canterbury/kennedy.xls | 524290 | 30260.6 ± 2.1% | 0.050 | 1.012 | 0.732 | 1.014 | 0.541 | 1.015 | 1.014 | 0.539 | 1.107 | 1.109 | 0.005 |
| hex: canterbury/lcet10.txt | 524290 | 29139.0 ± 1.1% | 0.052 | 1.021 | 0.749 | 1.009 | 0.555 | 1.012 | 1.010 | 0.551 | 1.142 | 1.141 | 0.005 |
| hex: canterbury/plrabn12.txt | 524290 | 29987.6 ± 0.6% | 0.050 | 1.004 | 0.738 | 1.009 | 0.539 | 0.987 | 1.006 | 0.538 | 1.121 | 1.116 | 0.005 |
| hex: canterbury/ptt5 | 524290 | 29578.5 ± 0.6% | 0.051 | 1.005 | 0.748 | 1.009 | 0.544 | 1.006 | 1.006 | 0.542 | 1.124 | 1.125 | 0.005 |
| hex: canterbury/sum | 76482 | 40383.7 ± 6.6% | 0.038 | 1.002 | 0.553 | 1.003 | 0.456 | 1.005 | 1.003 | 0.460 | 0.824 | 0.824 | 0.004 |
| hex: canterbury/xargs.1 | 8456 | 38673.0 ± 0.3% | 0.040 | 0.976 | 0.514 | 1.002 | 0.411 | 0.994 | 1.004 | 0.437 | 0.727 | 0.730 | 0.004 |
| hex: canterbury-large/E.coli | 524290 | 29340.1 ± 1.5% | 0.051 | 1.013 | 0.744 | 1.019 | 0.552 | 1.002 | 1.015 | 0.549 | 1.132 | 1.130 | 0.005 |
| hex: canterbury-large/bible.txt | 524290 | 29510.8 ± 0.9% | 0.051 | 1.005 | 0.745 | 1.010 | 0.540 | 1.001 | 1.010 | 0.536 | 1.126 | 1.122 | 0.005 |
| hex: canterbury-large/world192.txt | 524290 | 30747.5 ± 2.0% | 0.049 | 1.010 | 0.716 | 1.017 | 0.536 | 0.999 | 1.013 | 0.534 | 1.081 | 1.082 | 0.005 |
| hex: http/html-1kx1024 | 2099200 | 16490.6 ± 1.0% | 0.090 | 1.005 | 0.799 | 1.010 | 0.587 | 1.013 | 1.007 | 0.690 | 0.996 | 1.011 | 0.009 |
| hex: http/html-16kx64 | 2097280 | 34675.2 ± 1.9% | 0.044 | 1.004 | 0.598 | 1.006 | 0.491 | 1.006 | 1.006 | 0.501 | 0.883 | 0.875 | 0.004 |
| hex: http/html-1m | 524290 | 29138.0 ± 1.6% | 0.052 | 1.005 | 0.757 | 1.009 | 0.554 | 1.008 | 1.011 | 0.554 | 1.142 | 1.145 | 0.005 |
| hex: http/json-1kx1024 | 2099200 | 16769.7 ± 2.2% | 0.089 | 1.004 | 0.793 | 1.013 | 0.590 | 1.008 | 1.016 | 0.689 | 0.989 | 1.000 | 0.009 |
| hex: http/json-16kx64 | 2097280 | 35229.4 ± 2.1% | 0.044 | 1.000 | 0.595 | 1.011 | 0.491 | 0.994 | 1.001 | 0.495 | 0.865 | 0.865 | 0.004 |
| hex: http/json-1m | 524290 | 30332.9 ± 4.2% | 0.050 | 1.012 | 0.728 | 1.017 | 0.537 | 1.014 | 1.015 | 0.535 | 1.099 | 1.101 | 0.005 |
| hex: http/js-1kx1024 | 2099200 | 16692.9 ± 5.0% | 0.089 | 1.002 | 0.793 | 1.016 | 0.592 | 1.013 | 1.018 | 0.694 | 0.985 | 1.005 | 0.009 |
| hex: http/js-16kx64 | 2097280 | 35349.2 ± 19.7% | 0.044 | 1.000 | 0.591 | 1.015 | 0.491 | 1.001 | 1.008 | 0.495 | 0.866 | 0.871 | 0.004 |
| hex: http/js-1m | 524290 | 29416.4 ± 1.0% | 0.051 | 1.009 | 0.750 | 1.013 | 0.547 | 1.005 | 1.012 | 0.543 | 1.141 | 1.137 | 0.005 |
| hex: http/css-1kx1024 | 2099200 | 16906.4 ± 3.4% | 0.088 | 0.993 | 0.778 | 0.998 | 0.567 | 0.997 | 0.998 | 0.660 | 0.972 | 0.991 | 0.009 |
| hex: http/css-16kx64 | 2097280 | 34162.6 ± 1.2% | 0.045 | 1.003 | 0.602 | 1.004 | 0.501 | 1.007 | 1.005 | 0.511 | 0.895 | 0.892 | 0.004 |
| hex: http/css-1m | 524290 | 29442.6 ± 1.3% | 0.051 | 1.019 | 0.753 | 1.019 | 0.549 | 1.006 | 1.007 | 0.543 | 1.127 | 1.127 | 0.005 |
| hex: shuffled/dickens-1m | 524290 | 30924.8 ± 4.1% | 0.048 | 1.025 | 0.710 | 1.000 | 0.516 | 0.994 | 1.002 | 0.515 | 1.076 | 1.076 | 0.005 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1337.5 ± 6.8% | 0.441 | 0.968 | 0.971 | 0.986 | 0.986 | 0.232 | 0.985 | 0.441 | 0.843 | 0.085 | 1.008 |
| qlog records, JSON text sequence | 1467503 | 1159.9 ± 7.8% | 0.703 | 0.946 | 0.978 | 0.975 | 0.973 | 0.224 | 0.970 | 0.412 | 0.840 | 0.104 | 0.998 |
| string: silesia/dickens | 172528 | 9209.2 ± 0.6% | 0.017 | 0.578 | 0.411 | 0.591 | 0.578 | 0.117 | 0.577 | 1.001 | 1.006 | 0.017 | 1.039 |
| string: silesia/nci | 1075110 | 8686.4 ± 0.4% | 0.018 | 0.593 | 0.400 | 0.590 | 0.594 | 0.166 | 0.592 | 1.000 | 1.003 | 0.018 | 1.019 |
| string: silesia/reymont | 1075159 | 3846.6 ± 15.7% | 0.040 | 0.673 | 0.513 | 0.665 | 0.675 | 0.282 | 0.675 | 0.999 | 1.003 | 0.040 | 1.005 |
| string: silesia/samba | 97582 | 4584.8 ± 0.6% | 0.043 | 0.942 | 0.790 | 0.947 | 0.945 | 0.102 | 0.945 | 1.002 | 1.004 | 0.043 | 1.024 |
| string: silesia/webster | 1098490 | 5072.8 ± 0.8% | 0.030 | 0.700 | 0.495 | 0.704 | 0.701 | 0.156 | 0.701 | 1.001 | 1.004 | 0.030 | 1.001 |
| string: silesia/xml | 1090118 | 7929.7 ± 0.8% | 0.018 | 0.632 | 0.559 | 0.637 | 0.633 | 0.198 | 0.633 | 1.007 | 1.031 | 0.020 | 1.047 |
| string: canterbury/alice29.txt | 159425 | 9960.0 ± 0.9% | 0.015 | 0.469 | 0.380 | 0.508 | 0.501 | 0.081 | 0.474 | 0.999 | 1.006 | 0.015 | 1.038 |
| string: canterbury/asyoulik.txt | 132198 | 8161.5 ± 1.1% | 0.018 | 0.497 | 0.381 | 0.495 | 0.502 | 0.085 | 0.503 | 1.008 | 1.015 | 0.018 | 1.050 |
| string: canterbury/lcet10.txt | 441884 | 9034.1 ± 1.0% | 0.017 | 0.597 | 0.380 | 0.605 | 0.597 | 0.116 | 0.598 | 1.007 | 1.013 | 0.017 | 1.032 |
| string: canterbury/plrabn12.txt | 503330 | 6117.0 ± 1.5% | 0.025 | 0.757 | 0.577 | 0.750 | 0.758 | 0.154 | 0.757 | 1.000 | 1.003 | 0.025 | 1.053 |
| string: canterbury-large/E.coli | 1048578 | 29097.2 ± 1.2% | 0.051 | 1.013 | 1.000 | 0.767 | 1.001 | 0.533 | 1.004 | 0.990 | 1.002 | 0.006 | 1.003 |
| string: canterbury-large/bible.txt | 1055886 | 6993.9 ± 0.4% | 0.023 | 0.797 | 0.660 | 0.827 | 0.799 | 0.412 | 0.799 | 1.002 | 1.002 | 0.023 | 1.054 |
| string: canterbury-large/world192.txt | 1103121 | 5148.9 ± 3.9% | 0.030 | 0.658 | 0.488 | 0.640 | 0.668 | 0.138 | 0.648 | 1.006 | 0.974 | 0.030 | 0.940 |
| string: http/html-1m | 1058582 | 8569.7 ± 0.3% | 0.018 | 0.613 | 0.508 | 0.648 | 0.614 | 0.288 | 0.615 | 1.002 | 1.012 | 0.018 | 1.026 |
| string: http/json-1m | 1190272 | 6600.0 ± 0.7% | 0.022 | 0.217 | 0.189 | 0.220 | 0.217 | 0.062 | 0.217 | 1.002 | 1.002 | 0.022 | 1.026 |
| string: http/js-1m | 1144362 | 5105.5 ± 1.1% | 0.029 | 0.441 | 0.354 | 0.441 | 0.441 | 0.085 | 0.441 | 0.998 | 1.007 | 0.029 | 0.994 |
| string: http/css-1m | 1097820 | 6853.6 ± 0.6% | 0.022 | 0.504 | 0.346 | 0.499 | 0.507 | 0.115 | 0.508 | 1.002 | 1.004 | 0.022 | 1.045 |
| string: dickens as Cyrillic and CJK | 1883069 | 5349.9 ± 44.0% | 0.024 | 0.467 | 0.058 | 0.469 | 0.467 | 0.172 | 0.466 | 0.994 | 0.995 | 0.023 | 1.021 |
| hex: silesia/dickens | 524290 | 31353.6 ± 1.8% | 1.001 | 0.081 | 1.009 | 0.595 | 1.008 | 1.006 | 1.007 | 1.002 | 1.004 | 0.081 | 1.009 |
| hex: silesia/mozilla | 524290 | 34959.5 ± 0.6% | 1.012 | 0.073 | 1.016 | 0.579 | 1.016 | 1.013 | 1.013 | 1.012 | 1.016 | 0.073 | 1.017 |
| hex: silesia/mr | 524290 | 32964.1 ± 1.2% | 1.009 | 0.077 | 1.009 | 0.608 | 1.006 | 1.007 | 1.007 | 1.004 | 1.005 | 0.077 | 1.008 |
| hex: silesia/nci | 524290 | 32892.1 ± 14.9% | 1.006 | 0.077 | 1.009 | 0.612 | 1.009 | 1.008 | 1.011 | 1.006 | 1.007 | 0.077 | 1.009 |
| hex: silesia/ooffice | 524290 | 33248.5 ± 0.7% | 1.005 | 0.076 | 1.007 | 0.607 | 1.005 | 1.004 | 1.004 | 1.004 | 1.005 | 0.077 | 1.006 |
| hex: silesia/osdb | 524290 | 34708.5 ± 0.9% | 1.006 | 0.073 | 1.002 | 0.579 | 1.004 | 1.016 | 1.004 | 1.002 | 1.011 | 0.073 | 1.011 |
| hex: silesia/reymont | 524290 | 33909.0 ± 0.5% | 1.011 | 0.075 | 1.010 | 0.588 | 1.008 | 1.010 | 1.008 | 1.004 | 1.010 | 0.075 | 1.007 |
| hex: silesia/samba | 524290 | 33979.1 ± 0.4% | 1.006 | 0.075 | 1.008 | 0.593 | 1.003 | 1.006 | 1.006 | 1.001 | 1.008 | 0.075 | 1.011 |
| hex: silesia/sao | 524290 | 34340.2 ± 1.8% | 1.004 | 0.074 | 1.007 | 0.589 | 1.007 | 1.004 | 1.006 | 1.000 | 1.009 | 0.074 | 1.006 |
| hex: silesia/webster | 524290 | 36241.0 ± 14.6% | 1.008 | 0.070 | 1.010 | 0.556 | 1.010 | 1.008 | 1.008 | 1.003 | 1.009 | 0.070 | 1.012 |
| hex: silesia/x-ray | 524290 | 33438.4 ± 0.4% | 1.008 | 0.076 | 1.008 | 0.597 | 1.007 | 1.006 | 1.006 | 1.006 | 1.007 | 0.076 | 1.010 |
| hex: silesia/xml | 524290 | 33024.9 ± 1.1% | 1.005 | 0.077 | 1.003 | 0.608 | 1.006 | 1.010 | 1.003 | 1.004 | 1.006 | 0.077 | 1.010 |
| hex: canterbury/alice29.txt | 304180 | 33312.2 ± 0.6% | 1.003 | 0.076 | 1.006 | 0.602 | 1.004 | 1.000 | 1.002 | 1.005 | 1.003 | 0.076 | 1.002 |
| hex: canterbury/asyoulik.txt | 250360 | 31685.9 ± 0.3% | 1.004 | 0.080 | 1.010 | 0.614 | 1.008 | 1.008 | 1.010 | 1.002 | 1.010 | 0.080 | 1.010 |
| hex: canterbury/cp.html | 49208 | 32013.1 ± 2.6% | 1.000 | 0.079 | 1.001 | 0.590 | 0.998 | 0.991 | 0.997 | 1.003 | 1.000 | 0.080 | 0.995 |
| hex: canterbury/fields.c | 22302 | 32405.4 ± 0.6% | 1.003 | 0.078 | 0.998 | 0.582 | 0.998 | 0.976 | 0.997 | 1.002 | 1.009 | 0.078 | 1.008 |
| hex: canterbury/grammar.lsp | 7444 | 32985.4 ± 0.4% | 1.000 | 0.076 | 0.982 | 0.562 | 0.996 | 0.950 | 0.997 | 1.005 | 1.038 | 0.076 | 1.008 |
| hex: canterbury/kennedy.xls | 524290 | 31435.7 ± 0.3% | 1.010 | 0.081 | 1.011 | 0.603 | 1.011 | 1.009 | 1.011 | 1.008 | 1.009 | 0.081 | 1.013 |
| hex: canterbury/lcet10.txt | 524290 | 34156.0 ± 0.4% | 1.009 | 0.074 | 1.010 | 0.588 | 1.010 | 1.012 | 1.011 | 1.011 | 1.014 | 0.075 | 1.013 |
| hex: canterbury/plrabn12.txt | 524290 | 33338.7 ± 0.4% | 1.008 | 0.076 | 1.007 | 0.599 | 1.007 | 1.004 | 1.007 | 1.003 | 1.007 | 0.076 | 1.009 |
| hex: canterbury/ptt5 | 524290 | 33095.1 ± 0.3% | 1.007 | 0.077 | 1.006 | 0.608 | 1.004 | 1.009 | 1.004 | 1.003 | 1.005 | 0.077 | 1.005 |
| hex: canterbury/sum | 76482 | 35665.3 ± 9.0% | 0.998 | 0.071 | 0.997 | 0.566 | 0.998 | 0.992 | 0.996 | 0.994 | 0.999 | 0.071 | 0.992 |
| hex: canterbury/xargs.1 | 8456 | 34506.4 ± 0.8% | 0.999 | 0.073 | 1.000 | 0.547 | 1.000 | 0.960 | 0.999 | 1.005 | 1.032 | 0.073 | 1.011 |
| hex: canterbury-large/E.coli | 524290 | 30402.9 ± 9.5% | 1.008 | 0.083 | 1.008 | 0.628 | 1.007 | 1.008 | 1.009 | 1.004 | 1.013 | 0.083 | 1.015 |
| hex: canterbury-large/bible.txt | 524290 | 35385.2 ± 0.7% | 1.002 | 0.072 | 1.003 | 0.566 | 1.003 | 1.002 | 1.003 | 1.000 | 1.008 | 0.072 | 1.005 |
| hex: canterbury-large/world192.txt | 524290 | 34612.7 ± 7.1% | 1.010 | 0.073 | 1.011 | 0.581 | 1.009 | 1.011 | 1.008 | 1.008 | 1.010 | 0.074 | 1.013 |
| hex: http/html-1kx1024 | 2099200 | 23060.2 ± 0.9% | 1.007 | 0.106 | 1.013 | 0.699 | 1.016 | 0.890 | 1.000 | 1.006 | 1.072 | 0.103 | 1.040 |
| hex: http/html-16kx64 | 2097280 | 29896.8 ± 0.8% | 1.006 | 0.084 | 1.004 | 0.648 | 1.007 | 0.992 | 1.008 | 1.004 | 1.012 | 0.085 | 1.009 |
| hex: http/html-1m | 524290 | 29080.9 ± 0.3% | 1.007 | 0.087 | 1.007 | 0.672 | 1.006 | 1.005 | 1.007 | 1.005 | 1.006 | 0.087 | 1.005 |
| hex: http/json-1kx1024 | 2099200 | 23720.0 ± 2.5% | 1.003 | 0.103 | 0.981 | 0.679 | 0.988 | 0.886 | 0.987 | 0.995 | 1.061 | 0.100 | 1.031 |
| hex: http/json-16kx64 | 2097280 | 29862.0 ± 2.1% | 1.006 | 0.084 | 1.007 | 0.645 | 1.006 | 0.992 | 1.008 | 1.001 | 1.011 | 0.085 | 1.007 |
| hex: http/json-1m | 524290 | 31908.4 ± 0.8% | 1.002 | 0.079 | 1.001 | 0.623 | 1.003 | 0.951 | 1.002 | 1.000 | 1.001 | 0.080 | 1.001 |
| hex: http/js-1kx1024 | 2099200 | 23717.9 ± 2.9% | 0.993 | 0.103 | 0.986 | 0.681 | 0.993 | 0.883 | 0.994 | 0.998 | 1.063 | 0.100 | 1.032 |
| hex: http/js-16kx64 | 2097280 | 29868.9 ± 1.5% | 1.007 | 0.084 | 1.003 | 0.642 | 1.003 | 0.991 | 1.002 | 1.002 | 1.011 | 0.085 | 1.009 |
| hex: http/js-1m | 524290 | 30306.3 ± 0.6% | 1.005 | 0.083 | 1.006 | 0.654 | 1.008 | 1.011 | 1.009 | 1.007 | 1.013 | 0.084 | 1.008 |
| hex: http/css-1kx1024 | 2099200 | 23111.6 ± 0.6% | 1.000 | 0.106 | 1.006 | 0.697 | 1.009 | 0.900 | 0.995 | 1.003 | 1.062 | 0.103 | 1.032 |
| hex: http/css-16kx64 | 2097280 | 29786.2 ± 1.2% | 1.009 | 0.084 | 1.006 | 0.644 | 1.007 | 0.994 | 1.009 | 1.004 | 1.015 | 0.085 | 1.009 |
| hex: http/css-1m | 524290 | 31320.0 ± 0.6% | 1.008 | 0.080 | 1.006 | 0.634 | 1.005 | 1.010 | 1.004 | 1.007 | 1.005 | 0.081 | 1.004 |
| hex: shuffled/dickens-1m | 524290 | 34154.1 ± 1.3% | 1.009 | 0.074 | 1.016 | 0.590 | 1.017 | 1.016 | 1.017 | 1.012 | 1.019 | 0.074 | 1.018 |

## Losses

Each workload where a claim's path ran slower than the path it replaces by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding: J7 wide vectors off runs at 1.056 of all on.
- CLDR supplemental, 34 texts, decoding: J12 decoder escape words off runs at 1.060 of all on.
- CLDR supplemental, 34 texts, decoding: J13 decoder escape blocks off runs at 1.062 of all on.
- string: silesia/nci, decoding: J7 wide vectors off runs at 1.155 of all on.
- string: silesia/nci, decoding: J8 decoder fast path off runs at 1.161 of all on.
- string: silesia/nci, decoding: J12 decoder escape words off runs at 1.127 of all on.
- string: silesia/nci, decoding: J13 decoder escape blocks off runs at 1.159 of all on.
- string: canterbury/asyoulik.txt, decoding: J7 wide vectors off runs at 1.191 of all on.
- string: canterbury/asyoulik.txt, decoding: J8 decoder fast path off runs at 1.260 of all on.
- string: canterbury/asyoulik.txt, decoding: J12 decoder escape words off runs at 1.164 of all on.
- string: canterbury/asyoulik.txt, decoding: J13 decoder escape blocks off runs at 1.257 of all on.
- string: canterbury/lcet10.txt, decoding: J7 wide vectors off runs at 1.071 of all on.
- string: canterbury/lcet10.txt, decoding: J8 decoder fast path off runs at 1.086 of all on.
- string: canterbury/lcet10.txt, decoding: J13 decoder escape blocks off runs at 1.086 of all on.
- string: http/css-1m, decoding: J7 wide vectors off runs at 1.115 of all on.
- string: http/css-1m, decoding: J8 decoder fast path off runs at 1.208 of all on.
- string: http/css-1m, decoding: J12 decoder escape words off runs at 1.121 of all on.
- string: http/css-1m, decoding: J13 decoder escape blocks off runs at 1.156 of all on.

## UTF-8 validation against simdutf

stdx's `is_utf8`, the check the loops apply to every string's octets, run alone over each string workload's octets at the width the host's features pick (16 lanes on aarch64, AVX2's 32 or AVX-512's 64 on x86-64, decision 39), beside simdutf 9.3.3's `validate_utf8` in the same run; on a host with AVX-512, again with AVX2 alone. Each ratio is stdx's throughput over the other's. simdutf picks its kernel at run time. Before timing, every copy of the check and simdutf judged 20000 seeded buffers and each workload, whole and changed, alike.

| Workload | Octets | stdx, MB/s | simdutf, MB/s | stdx / simdutf | stdx with AVX2 alone, MB/s | stdx / stdx with AVX2 alone |
|---|---|---|---|---|---|---|
| string: silesia/dickens | 166668 | 100274.7 ± 1.0% | 91277.3 ± 0.4% | 1.099 | — | — |
| string: silesia/nci | 1048576 | 60679.7 ± 1.6% | 61149.3 ± 0.3% | 0.992 | — | — |
| string: silesia/reymont | 1048576 | 60124.5 ± 0.5% | 60267.8 ± 0.5% | 0.998 | — | — |
| string: silesia/samba | 65546 | 98027.5 ± 2.3% | 89883.0 ± 2.2% | 1.091 | — | — |
| string: silesia/webster | 1048576 | 59392.6 ± 1.8% | 59549.7 ± 1.0% | 0.997 | — | — |
| string: silesia/xml | 1048576 | 60854.1 ± 2.0% | 60501.6 ± 0.7% | 1.006 | — | — |
| string: canterbury/alice29.txt | 152089 | 100402.9 ± 1.9% | 90749.5 ± 0.8% | 1.106 | — | — |
| string: canterbury/asyoulik.txt | 125179 | 100011.4 ± 3.0% | 91798.7 ± 0.7% | 1.089 | — | — |
| string: canterbury/lcet10.txt | 426754 | 89021.3 ± 1.3% | 83861.8 ± 1.1% | 1.062 | — | — |
| string: canterbury/plrabn12.txt | 481861 | 86519.7 ± 1.5% | 83646.4 ± 0.5% | 1.034 | — | — |
| string: canterbury-large/E.coli | 1048576 | 60244.9 ± 1.1% | 60456.8 ± 0.9% | 0.996 | — | — |
| string: canterbury-large/bible.txt | 1048576 | 59235.8 ± 0.8% | 59513.2 ± 1.0% | 0.995 | — | — |
| string: canterbury-large/world192.txt | 1048576 | 59308.0 ± 1.2% | 59700.7 ± 0.6% | 0.993 | — | — |
| string: http/html-1m | 1048576 | 58638.8 ± 0.5% | 58647.0 ± 0.3% | 1.000 | — | — |
| string: http/json-1m | 1048576 | 51651.8 ± 1.8% | 55356.4 ± 0.2% | 0.933 | — | — |
| string: http/js-1m | 1048576 | 60375.6 ± 0.4% | 61649.9 ± 0.7% | 0.979 | — | — |
| string: http/css-1m | 1048576 | 60191.5 ± 1.7% | 59880.7 ± 2.5% | 1.005 | — | — |
| string: dickens as Cyrillic and CJK | 1847045 | 14614.8 ± 0.4% | 15323.8 ± 0.2% | 0.954 | — | — |

## Losses to simdutf

- string: http/json-1m: stdx runs at 0.933 of simdutf.

## UTF-8 validation by the buffer's offset from a 64-octet line

| Buffer | Octets | Offset | stdx, MB/s | simdutf, MB/s | stdx / simdutf | stdx with AVX2 alone, MB/s | stdx / stdx with AVX2 alone |
|---|---|---|---|---|---|---|---|
| string: canterbury-large/bible.txt | 1048576 | 0 | 58798.7 ± 1.2% | 59103.1 ± 0.4% | 0.995 | — | — |
| string: canterbury-large/bible.txt | 1048576 | 1 | 58738.0 ± 0.5% | 58865.9 ± 0.3% | 0.998 | — | — |
| string: canterbury-large/bible.txt | 1048576 | 8 | 58605.1 ± 0.5% | 58967.1 ± 2.0% | 0.994 | — | — |
| string: canterbury-large/bible.txt | 1048576 | 16 | 58693.7 ± 0.5% | 58923.6 ± 0.8% | 0.996 | — | — |
| string: canterbury-large/bible.txt | 1048576 | 32 | 58589.6 ± 0.5% | 59108.2 ± 0.6% | 0.991 | — | — |
| string: canterbury-large/bible.txt | 1048576 | 48 | 58723.3 ± 1.2% | 58979.4 ± 0.7% | 0.996 | — | — |
| string: dickens as Cyrillic and CJK | 1048576 | 0 | 14511.7 ± 1.0% | 15257.2 ± 7.4% | 0.951 | — | — |
| string: dickens as Cyrillic and CJK | 1048576 | 1 | 14535.3 ± 0.5% | 15280.9 ± 0.2% | 0.951 | — | — |
| string: dickens as Cyrillic and CJK | 1048576 | 8 | 14539.8 ± 0.2% | 15270.0 ± 1.2% | 0.952 | — | — |
| string: dickens as Cyrillic and CJK | 1048576 | 16 | 14541.1 ± 0.3% | 15262.1 ± 0.6% | 0.953 | — | — |
| string: dickens as Cyrillic and CJK | 1048576 | 32 | 14550.1 ± 0.4% | 15263.8 ± 0.2% | 0.953 | — | — |
| string: dickens as Cyrillic and CJK | 1048576 | 48 | 14547.0 ± 0.1% | 15243.4 ± 0.3% | 0.954 | — | — |

## Against the baselines

stdx with every claim on, timed beside simdjson 5.1.1, yyjson 0.13.0, Zig 0.16.0's std.json, serde_json 1.0.154 and Go's encoding/json/jsontext in the same run. Each ratio is stdx's throughput over the baseline's; below 1, the baseline is faster. stdx is built for the architecture's baseline CPU in ReleaseSafe. Each baseline is built for the same CPU, the C, C++ and Zig ones in ReleaseFast (decision 75), and simdjson picks its kernel at run time. Decoding visits every value; encoding writes each text from its tokens.

## Decoding against the baselines

Octets are the text's. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1014.1 ± 1.0% | 1009.2 ± 2.7% | 967.0 ± 1.3% | 288.0 ± 0.6% | 531.1 ± 0.7% | 259.0 ± 3.0% | 1.005 | 1.049 | 3.521 | 1.910 | 3.916 |
| qlog records, JSON text sequence | 1467503 | 842.8 ± 1.2% | 813.0 ± 0.3% | 798.6 ± 7.2% | 239.9 ± 10.0% | 577.4 ± 0.5% | 244.9 ± 2.8% | 1.037 | 1.055 | 3.512 | 1.460 | 3.442 |
| string: silesia/dickens | 172528 | 5762.7 ± 4.1% | 2884.3 ± 1.5% | 2059.9 ± 0.5% | 302.3 ± 8.6% | 2182.4 ± 0.6% | 493.9 ± 2.6% | 1.998 | 2.798 | 19.060 | 2.640 | 11.668 |
| string: silesia/nci | 1075110 | 4546.1 ± 0.2% | 3459.4 ± 0.5% | 2824.2 ± 2.4% | 501.9 ± 0.8% | 2328.9 ± 0.6% | 525.9 ± 2.3% | 1.314 | 1.610 | 9.057 | 1.952 | 8.644 |
| string: silesia/reymont | 1075159 | 3703.0 ± 0.5% | 2191.3 ± 0.2% | 1755.6 ± 2.7% | 318.0 ± 0.8% | 1640.3 ± 1.9% | 475.8 ± 0.6% | 1.690 | 2.109 | 11.645 | 2.257 | 7.782 |
| string: silesia/samba | 97582 | 3279.5 ± 0.7% | 2878.6 ± 0.4% | 1572.2 ± 1.8% | 261.4 ± 0.9% | 1281.2 ± 2.9% | 354.7 ± 1.4% | 1.139 | 2.086 | 12.546 | 2.560 | 9.247 |
| string: silesia/webster | 1098490 | 3712.0 ± 0.3% | 2028.1 ± 0.3% | 1627.7 ± 2.8% | 307.3 ± 12.6% | 1655.0 ± 1.0% | 440.7 ± 1.5% | 1.830 | 2.281 | 12.078 | 2.243 | 8.424 |
| string: silesia/xml | 1090118 | 5179.5 ± 1.1% | 3702.8 ± 0.5% | 2145.2 ± 1.0% | 409.8 ± 0.6% | 2368.5 ± 0.5% | 512.1 ± 19.3% | 1.399 | 2.414 | 12.640 | 2.187 | 10.114 |
| string: canterbury/alice29.txt | 159425 | 4985.6 ± 1.3% | 2414.9 ± 2.6% | 1821.8 ± 0.4% | 287.2 ± 1.3% | 1951.6 ± 3.0% | 444.8 ± 14.9% | 2.065 | 2.737 | 17.358 | 2.555 | 11.207 |
| string: canterbury/asyoulik.txt | 132198 | 3352.1 ± 0.5% | 2106.8 ± 0.7% | 1494.1 ± 1.7% | 273.9 ± 0.9% | 1609.9 ± 1.7% | 402.7 ± 2.6% | 1.591 | 2.244 | 12.239 | 2.082 | 8.324 |
| string: canterbury/lcet10.txt | 441884 | 5560.3 ± 0.7% | 2783.0 ± 0.7% | 1969.8 ± 2.3% | 322.3 ± 5.8% | 2141.3 ± 4.3% | 487.2 ± 0.9% | 1.998 | 2.823 | 17.254 | 2.597 | 11.413 |
| string: canterbury/plrabn12.txt | 503330 | 4957.3 ± 1.0% | 2691.2 ± 0.3% | 1677.7 ± 0.7% | 297.8 ± 0.9% | 2011.9 ± 0.3% | 460.9 ± 1.0% | 1.842 | 2.955 | 16.649 | 2.464 | 10.756 |
| string: canterbury-large/E.coli | 1048578 | 29195.8 ± 2.6% | 7664.3 ± 1.2% | 3432.0 ± 1.6% | 800.2 ± 0.2% | 5525.2 ± 0.1% | 806.9 ± 0.6% | 3.809 | 8.507 | 36.487 | 5.284 | 36.185 |
| string: canterbury-large/bible.txt | 1055886 | 9511.6 ± 0.6% | 3903.6 ± 0.2% | 2546.4 ± 2.0% | 351.2 ± 4.7% | 2974.2 ± 0.3% | 604.2 ± 1.3% | 2.437 | 3.735 | 27.084 | 3.198 | 15.741 |
| string: canterbury-large/world192.txt | 1103121 | 3617.2 ± 0.8% | 1974.1 ± 0.5% | 1612.9 ± 3.3% | 295.0 ± 1.5% | 1688.3 ± 1.0% | 435.0 ± 1.2% | 1.832 | 2.243 | 12.263 | 2.143 | 8.316 |
| string: http/html-1m | 1058582 | 7857.0 ± 1.8% | 3392.0 ± 0.2% | 2367.0 ± 1.8% | 407.1 ± 1.0% | 2728.6 ± 0.3% | 428.9 ± 1.3% | 2.316 | 3.319 | 19.298 | 2.879 | 18.318 |
| string: http/json-1m | 1190272 | 3139.4 ± 0.3% | 1199.6 ± 0.2% | 1421.7 ± 5.8% | 352.9 ± 1.7% | 838.6 ± 1.2% | 295.8 ± 0.9% | 2.617 | 2.208 | 8.895 | 3.744 | 10.614 |
| string: http/js-1m | 1144362 | 2671.8 ± 4.9% | 1322.0 ± 0.6% | 1165.0 ± 3.0% | 279.8 ± 1.0% | 1156.1 ± 1.2% | 296.9 ± 1.3% | 2.021 | 2.293 | 9.548 | 2.311 | 8.998 |
| string: http/css-1m | 1097820 | 2683.7 ± 0.8% | 2499.0 ± 0.8% | 1532.2 ± 0.5% | 372.7 ± 0.4% | 1527.5 ± 2.3% | 337.8 ± 0.4% | 1.074 | 1.752 | 7.201 | 1.757 | 7.944 |
| string: dickens as Cyrillic and CJK | 1883069 | 5184.8 ± 0.2% | 3160.1 ± 0.4% | 651.8 ± 0.3% | 251.8 ± 5.9% | 497.6 ± 0.6% | 137.9 ± 1.7% | 1.641 | 7.955 | 20.593 | 10.421 | 37.601 |
| string: dickens as Cyrillic and CJK, as \u escapes | 5075485 | 1060.1 ± 0.8% | 1076.9 ± 0.5% | 819.1 ± 1.2% | 162.0 ± 0.3% | 383.5 ± 5.3% | 200.6 ± 4.5% | 0.984 | 1.294 | 6.544 | 2.764 | 5.284 |
| hex: silesia/dickens | 524290 | 29350.9 ± 1.5% | 7613.1 ± 0.6% | 3424.7 ± 1.2% | 469.4 ± 7.6% | 5513.9 ± 0.7% | 798.5 ± 1.7% | 3.855 | 8.570 | 62.535 | 5.323 | 36.759 |
| hex: silesia/mozilla | 524290 | 29514.3 ± 1.5% | 7651.7 ± 0.8% | 3448.8 ± 1.3% | 408.9 ± 2.5% | 5518.4 ± 0.3% | 820.3 ± 2.7% | 3.857 | 8.558 | 72.177 | 5.348 | 35.979 |
| hex: silesia/mr | 524290 | 30859.4 ± 1.0% | 7623.2 ± 1.4% | 3436.2 ± 1.1% | 581.3 ± 0.3% | 5509.2 ± 17.0% | 826.1 ± 1.5% | 4.048 | 8.981 | 53.088 | 5.601 | 37.354 |
| hex: silesia/nci | 524290 | 29492.7 ± 2.2% | 7622.6 ± 1.1% | 3450.6 ± 0.3% | 644.6 ± 0.2% | 5509.0 ± 0.6% | 815.0 ± 0.7% | 3.869 | 8.547 | 45.757 | 5.354 | 36.186 |
| hex: silesia/ooffice | 524290 | 30075.1 ± 1.2% | 7621.8 ± 1.2% | 3446.5 ± 6.8% | 356.5 ± 0.2% | 5526.7 ± 0.3% | 812.3 ± 8.3% | 3.946 | 8.726 | 84.352 | 5.442 | 37.023 |
| hex: silesia/osdb | 524290 | 28115.9 ± 1.0% | 7633.0 ± 0.3% | 3456.4 ± 0.3% | 453.1 ± 0.7% | 5504.7 ± 1.7% | 807.3 ± 2.1% | 3.683 | 8.134 | 62.055 | 5.108 | 34.827 |
| hex: silesia/reymont | 524290 | 30072.8 ± 1.0% | 7604.1 ± 0.5% | 3414.1 ± 3.9% | 486.7 ± 0.5% | 5533.9 ± 0.3% | 813.7 ± 1.9% | 3.955 | 8.808 | 61.788 | 5.434 | 36.957 |
| hex: silesia/samba | 524290 | 29801.6 ± 2.5% | 7643.0 ± 0.5% | 3441.5 ± 0.4% | 363.0 ± 0.2% | 5523.7 ± 1.2% | 814.8 ± 1.3% | 3.899 | 8.659 | 82.102 | 5.395 | 36.577 |
| hex: silesia/sao | 524290 | 29453.2 ± 0.6% | 7618.0 ± 0.8% | 3425.5 ± 0.4% | 289.3 ± 0.2% | 5504.6 ± 1.3% | 807.8 ± 1.4% | 3.866 | 8.598 | 101.818 | 5.351 | 36.463 |
| hex: silesia/webster | 524290 | 29764.4 ± 1.7% | 7601.2 ± 0.4% | 3434.2 ± 0.7% | 435.6 ± 1.0% | 5527.4 ± 5.5% | 801.8 ± 2.3% | 3.916 | 8.667 | 68.333 | 5.385 | 37.121 |
| hex: silesia/x-ray | 524290 | 28968.9 ± 1.4% | 7614.0 ± 2.6% | 3424.1 ± 4.8% | 435.8 ± 0.6% | 5506.4 ± 0.5% | 809.5 ± 1.3% | 3.805 | 8.460 | 66.480 | 5.261 | 35.785 |
| hex: silesia/xml | 524290 | 29466.4 ± 1.9% | 7642.6 ± 0.6% | 3435.1 ± 0.3% | 603.4 ± 0.4% | 5526.1 ± 0.5% | 813.0 ± 1.8% | 3.856 | 8.578 | 48.830 | 5.332 | 36.243 |
| hex: canterbury/alice29.txt | 304180 | 35450.4 ± 1.9% | 7658.6 ± 2.3% | 3556.7 ± 0.6% | 470.5 ± 0.8% | 5515.8 ± 3.3% | 808.0 ± 0.9% | 4.629 | 9.967 | 75.339 | 6.427 | 43.875 |
| hex: canterbury/asyoulik.txt | 250360 | 38084.0 ± 1.2% | 7723.8 ± 3.1% | 3552.8 ± 0.4% | 461.6 ± 0.4% | 5523.2 ± 1.1% | 808.4 ± 1.6% | 4.931 | 10.719 | 82.506 | 6.895 | 47.112 |
| hex: canterbury/cp.html | 49208 | 39040.6 ± 2.3% | 7783.8 ± 0.1% | 3607.2 ± 1.3% | 462.7 ± 0.3% | 5485.9 ± 0.6% | 800.6 ± 1.1% | 5.016 | 10.823 | 84.374 | 7.117 | 48.766 |
| hex: canterbury/fields.c | 22302 | 37501.7 ± 0.9% | 7700.9 ± 0.2% | 3609.5 ± 0.2% | 487.7 ± 0.3% | 5460.6 ± 0.7% | 793.6 ± 3.8% | 4.870 | 10.390 | 76.888 | 6.868 | 47.252 |
| hex: canterbury/grammar.lsp | 7444 | 37218.6 ± 2.5% | 7489.9 ± 0.6% | 3557.0 ± 2.4% | 538.1 ± 0.3% | 5378.5 ± 6.6% | 761.8 ± 4.0% | 4.969 | 10.463 | 69.171 | 6.920 | 48.856 |
| hex: canterbury/kennedy.xls | 524290 | 30260.6 ± 2.1% | 7627.7 ± 0.5% | 3434.3 ± 0.4% | 685.3 ± 0.5% | 5513.4 ± 0.5% | 815.9 ± 6.4% | 3.967 | 8.811 | 44.156 | 5.489 | 37.089 |
| hex: canterbury/lcet10.txt | 524290 | 29139.0 ± 1.1% | 7636.5 ± 0.7% | 3457.1 ± 0.4% | 473.3 ± 0.3% | 5530.0 ± 0.9% | 816.0 ± 2.7% | 3.816 | 8.429 | 61.566 | 5.269 | 35.709 |
| hex: canterbury/plrabn12.txt | 524290 | 29987.6 ± 0.6% | 7640.6 ± 1.0% | 3451.3 ± 0.9% | 460.1 ± 8.0% | 5518.4 ± 0.1% | 821.1 ± 0.5% | 3.925 | 8.689 | 65.175 | 5.434 | 36.521 |
| hex: canterbury/ptt5 | 524290 | 29578.5 ± 0.6% | 7628.6 ± 0.8% | 3467.5 ± 0.3% | 558.2 ± 11.7% | 5529.9 ± 0.2% | 819.4 ± 1.3% | 3.877 | 8.530 | 52.992 | 5.349 | 36.097 |
| hex: canterbury/sum | 76482 | 40383.7 ± 6.6% | 7806.9 ± 0.2% | 3624.5 ± 0.4% | 528.5 ± 10.2% | 5503.8 ± 0.2% | 823.9 ± 2.5% | 5.173 | 11.142 | 76.406 | 7.337 | 49.014 |
| hex: canterbury/xargs.1 | 8456 | 38673.0 ± 0.3% | 7523.1 ± 0.1% | 3550.6 ± 0.6% | 525.9 ± 1.9% | 5353.3 ± 1.4% | 796.4 ± 4.6% | 5.141 | 10.892 | 73.537 | 7.224 | 48.560 |
| hex: canterbury-large/E.coli | 524290 | 29340.1 ± 1.5% | 7616.5 ± 0.5% | 3445.3 ± 0.4% | 710.1 ± 9.3% | 5506.4 ± 0.6% | 814.5 ± 5.7% | 3.852 | 8.516 | 41.320 | 5.328 | 36.020 |
| hex: canterbury-large/bible.txt | 524290 | 29510.8 ± 0.9% | 7646.5 ± 0.6% | 3436.9 ± 0.7% | 488.2 ± 1.4% | 5503.2 ± 5.4% | 817.6 ± 1.9% | 3.859 | 8.586 | 60.453 | 5.362 | 36.094 |
| hex: canterbury-large/world192.txt | 524290 | 30747.5 ± 2.0% | 7641.5 ± 0.9% | 3444.3 ± 0.7% | 454.6 ± 0.9% | 5520.6 ± 0.3% | 818.9 ± 3.1% | 4.024 | 8.927 | 67.641 | 5.570 | 37.549 |
| hex: http/html-1kx1024 | 2099200 | 16490.6 ± 1.0% | 6612.4 ± 0.5% | 3232.5 ± 0.6% | 487.1 ± 0.5% | 4703.9 ± 0.6% | 720.8 ± 2.8% | 2.494 | 5.101 | 33.858 | 3.506 | 22.878 |
| hex: http/html-16kx64 | 2097280 | 34675.2 ± 1.9% | 7660.9 ± 0.4% | 3501.9 ± 0.3% | 495.6 ± 0.3% | 5419.6 ± 0.5% | 803.1 ± 1.8% | 4.526 | 9.902 | 69.971 | 6.398 | 43.176 |
| hex: http/html-1m | 524290 | 29138.0 ± 1.6% | 7626.3 ± 0.5% | 3450.2 ± 0.5% | 492.9 ± 0.2% | 5520.7 ± 0.7% | 816.2 ± 2.3% | 3.821 | 8.445 | 59.119 | 5.278 | 35.701 |
| hex: http/json-1kx1024 | 2099200 | 16769.7 ± 2.2% | 6594.2 ± 0.4% | 3232.7 ± 1.9% | 618.0 ± 12.4% | 4704.4 ± 3.5% | 727.1 ± 3.5% | 2.543 | 5.188 | 27.135 | 3.565 | 23.063 |
| hex: http/json-16kx64 | 2097280 | 35229.4 ± 2.1% | 7638.6 ± 7.1% | 3479.3 ± 1.0% | 632.0 ± 1.9% | 5418.7 ± 16.6% | 795.6 ± 4.4% | 4.612 | 10.125 | 55.739 | 6.501 | 44.281 |
| hex: http/json-1m | 524290 | 30332.9 ± 4.2% | 7565.7 ± 1.3% | 3439.2 ± 7.3% | 642.9 ± 0.4% | 5533.8 ± 0.3% | 801.5 ± 3.7% | 4.009 | 8.820 | 47.183 | 5.481 | 37.847 |
| hex: http/js-1kx1024 | 2099200 | 16692.9 ± 5.0% | 6590.5 ± 4.2% | 3223.5 ± 0.1% | 472.5 ± 0.6% | 4719.1 ± 0.8% | 710.0 ± 3.7% | 2.533 | 5.179 | 35.327 | 3.537 | 23.512 |
| hex: http/js-16kx64 | 2097280 | 35349.2 ± 19.7% | 7664.0 ± 4.4% | 3475.8 ± 29.1% | 478.6 ± 25.3% | 5429.7 ± 62.3% | 793.1 ± 13.2% | 4.612 | 10.170 | 73.866 | 6.510 | 44.570 |
| hex: http/js-1m | 524290 | 29416.4 ± 1.0% | 7641.1 ± 0.4% | 3439.1 ± 0.2% | 494.4 ± 0.5% | 5544.1 ± 0.3% | 813.7 ± 6.0% | 3.850 | 8.554 | 59.495 | 5.306 | 36.152 |
| hex: http/css-1kx1024 | 2099200 | 16906.4 ± 3.4% | 6588.2 ± 0.2% | 3223.5 ± 1.1% | 538.4 ± 0.5% | 4712.9 ± 1.0% | 711.9 ± 5.4% | 2.566 | 5.245 | 31.401 | 3.587 | 23.747 |
| hex: http/css-16kx64 | 2097280 | 34162.6 ± 1.2% | 7651.9 ± 0.3% | 3496.4 ± 1.3% | 548.5 ± 0.3% | 5429.7 ± 1.0% | 792.6 ± 7.2% | 4.465 | 9.771 | 62.280 | 6.292 | 43.102 |
| hex: http/css-1m | 524290 | 29442.6 ± 1.3% | 7642.3 ± 0.8% | 3430.6 ± 0.7% | 532.3 ± 0.4% | 5515.4 ± 0.1% | 776.8 ± 8.3% | 3.853 | 8.582 | 55.307 | 5.338 | 37.904 |
| hex: shuffled/dickens-1m | 524290 | 30924.8 ± 4.1% | 7646.4 ± 2.1% | 3437.4 ± 3.2% | 470.7 ± 1.0% | 5535.6 ± 0.3% | 802.0 ± 2.1% | 4.044 | 8.996 | 65.703 | 5.587 | 38.559 |

## Encoding against the baselines

Octets are the ones stdx writes. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1337.5 ± 6.8% | 1128.7 ± 1.3% | 893.5 ± 2.0% | 328.7 ± 1.1% | 366.9 ± 3.3% | 310.6 ± 3.0% | 1.185 | 1.497 | 4.069 | 3.646 | 4.307 |
| qlog records, JSON text sequence | 1467503 | 1159.9 ± 7.8% | 857.4 ± 1.2% | 726.3 ± 0.9% | 318.2 ± 1.7% | 390.4 ± 0.7% | 226.2 ± 3.1% | 1.353 | 1.597 | 3.645 | 2.971 | 5.128 |
| string: silesia/dickens | 172528 | 9209.2 ± 0.6% | 2946.7 ± 1.7% | 2019.3 ± 0.3% | 357.3 ± 0.3% | 1409.3 ± 2.3% | 559.9 ± 3.9% | 3.125 | 4.561 | 25.773 | 6.535 | 16.448 |
| string: silesia/nci | 1075110 | 8686.4 ± 0.4% | 3162.6 ± 23.3% | 2776.3 ± 23.8% | 775.4 ± 11.8% | 1538.5 ± 0.5% | 562.3 ± 7.7% | 2.747 | 3.129 | 11.203 | 5.646 | 15.449 |
| string: silesia/reymont | 1075159 | 3846.6 ± 15.7% | 1653.8 ± 0.4% | 1721.3 ± 0.3% | 360.3 ± 0.6% | 1253.3 ± 0.5% | 548.4 ± 2.2% | 2.326 | 2.235 | 10.677 | 3.069 | 7.014 |
| string: silesia/samba | 97582 | 4584.8 ± 0.6% | 1980.0 ± 0.6% | 2151.4 ± 0.3% | 299.3 ± 0.4% | 1039.7 ± 0.3% | 620.4 ± 1.5% | 2.316 | 2.131 | 15.319 | 4.410 | 7.390 |
| string: silesia/webster | 1098490 | 5072.8 ± 0.8% | 1628.7 ± 1.5% | 1512.4 ± 0.8% | 353.7 ± 0.5% | 1196.9 ± 1.4% | 454.1 ± 0.9% | 3.115 | 3.354 | 14.343 | 4.238 | 11.171 |
| string: silesia/xml | 1090118 | 7929.7 ± 0.8% | 2664.5 ± 0.9% | 2170.2 ± 0.9% | 547.9 ± 0.5% | 1583.3 ± 0.4% | 562.2 ± 0.4% | 2.976 | 3.654 | 14.474 | 5.008 | 14.104 |
| string: canterbury/alice29.txt | 159425 | 9960.0 ± 0.9% | 2466.1 ± 1.7% | 1797.6 ± 0.3% | 335.7 ± 0.5% | 1261.7 ± 0.6% | 557.4 ± 1.6% | 4.039 | 5.541 | 29.665 | 7.894 | 17.869 |
| string: canterbury/asyoulik.txt | 132198 | 8161.5 ± 1.1% | 2205.1 ± 1.4% | 1539.9 ± 0.8% | 343.7 ± 5.0% | 1115.5 ± 10.7% | 543.9 ± 1.2% | 3.701 | 5.300 | 23.744 | 7.316 | 15.006 |
| string: canterbury/lcet10.txt | 441884 | 9034.1 ± 1.0% | 2474.9 ± 0.5% | 1963.8 ± 0.2% | 389.8 ± 1.3% | 1384.7 ± 3.9% | 551.4 ± 0.8% | 3.650 | 4.600 | 23.177 | 6.524 | 16.383 |
| string: canterbury/plrabn12.txt | 503330 | 6117.0 ± 1.5% | 1831.0 ± 5.8% | 1661.3 ± 0.4% | 363.0 ± 0.6% | 1295.3 ± 0.1% | 558.4 ± 0.8% | 3.341 | 3.682 | 16.849 | 4.722 | 10.955 |
| string: canterbury-large/E.coli | 1048578 | 29097.2 ± 1.2% | 10291.4 ± 0.9% | 3381.9 ± 0.2% | 1402.4 ± 0.5% | 2504.0 ± 1.3% | 575.8 ± 0.8% | 2.827 | 8.604 | 20.747 | 11.620 | 50.534 |
| string: canterbury-large/bible.txt | 1055886 | 6993.9 ± 0.4% | 3920.5 ± 1.9% | 2658.8 ± 0.5% | 433.6 ± 0.1% | 1873.4 ± 0.5% | 566.2 ± 1.0% | 1.784 | 2.631 | 16.129 | 3.733 | 12.352 |
| string: canterbury-large/world192.txt | 1103121 | 5148.9 ± 3.9% | 1440.6 ± 0.7% | 1547.3 ± 2.8% | 368.0 ± 0.8% | 1171.5 ± 17.4% | 539.2 ± 0.8% | 3.574 | 3.328 | 13.993 | 4.395 | 9.548 |
| string: http/html-1m | 1058582 | 8569.7 ± 0.3% | 3829.9 ± 10.9% | 2471.5 ± 1.4% | 397.5 ± 11.1% | 1811.4 ± 3.3% | 522.2 ± 0.5% | 2.238 | 3.467 | 21.559 | 4.731 | 16.412 |
| string: http/json-1m | 1190272 | 6600.0 ± 0.7% | 1226.6 ± 0.4% | 1268.3 ± 0.6% | 373.5 ± 0.7% | 891.1 ± 0.9% | 508.0 ± 1.7% | 5.381 | 5.204 | 17.670 | 7.407 | 12.991 |
| string: http/js-1m | 1144362 | 5105.5 ± 1.1% | 993.4 ± 0.2% | 1088.2 ± 0.5% | 282.3 ± 0.7% | 924.9 ± 0.9% | 479.9 ± 1.7% | 5.139 | 4.692 | 18.082 | 5.520 | 10.638 |
| string: http/css-1m | 1097820 | 6853.6 ± 0.6% | 1287.6 ± 0.6% | 1600.0 ± 0.5% | 402.4 ± 29.3% | 1047.5 ± 15.5% | 536.0 ± 1.2% | 5.323 | 4.283 | 17.032 | 6.543 | 12.786 |
| string: dickens as Cyrillic and CJK | 1883069 | 5349.9 ± 44.0% | 3044.5 ± 0.3% | 342.6 ± 5.2% | 268.8 ± 9.8% | 463.9 ± 4.4% | 293.0 ± 17.6% | 1.757 | 15.616 | 19.904 | 11.533 | 18.257 |
| hex: silesia/dickens | 524290 | 31353.6 ± 1.8% | 1549.6 ± 0.6% | 1085.4 ± 0.5% | 421.2 ± 4.4% | 1055.0 ± 0.8% | 451.0 ± 0.6% | 20.233 | 28.886 | 74.431 | 29.719 | 69.527 |
| hex: silesia/mozilla | 524290 | 34959.5 ± 0.6% | 1546.6 ± 1.3% | 1084.1 ± 0.4% | 369.6 ± 6.0% | 1053.9 ± 0.5% | 451.4 ± 0.7% | 22.604 | 32.249 | 94.580 | 33.172 | 77.455 |
| hex: silesia/mr | 524290 | 32964.1 ± 1.2% | 1545.2 ± 0.4% | 1083.7 ± 0.3% | 511.8 ± 0.3% | 1056.7 ± 12.5% | 450.6 ± 1.0% | 21.333 | 30.418 | 64.408 | 31.197 | 73.148 |
| hex: silesia/nci | 524290 | 32892.1 ± 14.9% | 1542.7 ± 0.9% | 1084.6 ± 1.5% | 558.0 ± 0.6% | 1054.3 ± 0.3% | 450.7 ± 0.4% | 21.321 | 30.326 | 58.941 | 31.198 | 72.979 |
| hex: silesia/ooffice | 524290 | 33248.5 ± 0.7% | 1544.7 ± 0.5% | 1082.1 ± 0.2% | 328.3 ± 1.5% | 1059.6 ± 0.5% | 448.8 ± 2.1% | 21.524 | 30.725 | 101.285 | 31.379 | 74.089 |
| hex: silesia/osdb | 524290 | 34708.5 ± 0.9% | 1547.0 ± 7.4% | 1084.5 ± 0.5% | 414.7 ± 1.3% | 1056.4 ± 0.6% | 451.0 ± 0.9% | 22.436 | 32.004 | 83.705 | 32.856 | 76.965 |
| hex: silesia/reymont | 524290 | 33909.0 ± 0.5% | 1548.8 ± 0.4% | 1085.1 ± 12.3% | 438.0 ± 0.3% | 1057.8 ± 1.7% | 450.6 ± 0.5% | 21.894 | 31.251 | 77.418 | 32.055 | 75.249 |
| hex: silesia/samba | 524290 | 33979.1 ± 0.4% | 1548.9 ± 1.0% | 1084.7 ± 0.5% | 333.3 ± 0.1% | 1058.0 ± 0.3% | 450.0 ± 1.0% | 21.938 | 31.327 | 101.962 | 32.116 | 75.512 |
| hex: silesia/sao | 524290 | 34340.2 ± 1.8% | 1545.1 ± 0.7% | 1083.7 ± 0.6% | 266.6 ± 7.2% | 1058.9 ± 0.3% | 450.6 ± 0.2% | 22.225 | 31.688 | 128.808 | 32.429 | 76.206 |
| hex: silesia/webster | 524290 | 36241.0 ± 14.6% | 1544.3 ± 0.9% | 1085.4 ± 1.3% | 389.4 ± 0.6% | 1056.3 ± 0.6% | 449.4 ± 0.8% | 23.468 | 33.389 | 93.065 | 34.308 | 80.638 |
| hex: silesia/x-ray | 524290 | 33438.4 ± 0.4% | 1550.1 ± 1.0% | 1087.5 ± 1.6% | 393.9 ± 0.2% | 1059.4 ± 0.7% | 450.6 ± 0.8% | 21.572 | 30.749 | 84.883 | 31.564 | 74.211 |
| hex: silesia/xml | 524290 | 33024.9 ± 1.1% | 1545.3 ± 0.6% | 1082.4 ± 9.6% | 586.7 ± 0.5% | 1056.9 ± 2.3% | 450.1 ± 1.2% | 21.371 | 30.510 | 56.285 | 31.247 | 73.370 |
| hex: canterbury/alice29.txt | 304180 | 33312.2 ± 0.6% | 1579.0 ± 0.9% | 1094.7 ± 0.3% | 430.3 ± 0.2% | 1072.3 ± 1.0% | 452.6 ± 0.3% | 21.097 | 30.432 | 77.411 | 31.065 | 73.609 |
| hex: canterbury/asyoulik.txt | 250360 | 31685.9 ± 0.3% | 1588.6 ± 1.9% | 1101.8 ± 0.7% | 426.5 ± 0.2% | 1079.8 ± 0.6% | 454.4 ± 0.3% | 19.945 | 28.758 | 74.287 | 29.343 | 69.725 |
| hex: canterbury/cp.html | 49208 | 32013.1 ± 2.6% | 1621.1 ± 1.6% | 1112.5 ± 0.4% | 457.8 ± 0.2% | 1077.9 ± 0.4% | 456.3 ± 0.3% | 19.748 | 28.776 | 69.927 | 29.699 | 70.160 |
| hex: canterbury/fields.c | 22302 | 32405.4 ± 0.6% | 1600.7 ± 0.5% | 1101.8 ± 0.2% | 547.6 ± 0.7% | 1067.1 ± 1.3% | 453.6 ± 1.2% | 20.244 | 29.411 | 59.174 | 30.369 | 71.441 |
| hex: canterbury/grammar.lsp | 7444 | 32985.4 ± 0.4% | 1634.9 ± 9.2% | 1115.2 ± 2.5% | 584.2 ± 0.6% | 1086.2 ± 1.0% | 460.8 ± 0.8% | 20.176 | 29.577 | 56.464 | 30.369 | 71.590 |
| hex: canterbury/kennedy.xls | 524290 | 31435.7 ± 0.3% | 1547.4 ± 0.4% | 1084.6 ± 1.6% | 595.4 ± 0.2% | 1054.7 ± 0.4% | 451.4 ± 0.3% | 20.315 | 28.982 | 52.796 | 29.807 | 69.645 |
| hex: canterbury/lcet10.txt | 524290 | 34156.0 ± 0.4% | 1545.2 ± 0.9% | 1084.8 ± 0.6% | 422.5 ± 0.2% | 1056.6 ± 0.8% | 450.2 ± 0.5% | 22.104 | 31.485 | 80.838 | 32.328 | 75.876 |
| hex: canterbury/plrabn12.txt | 524290 | 33338.7 ± 0.4% | 1551.4 ± 0.6% | 1085.3 ± 0.3% | 421.8 ± 0.2% | 1058.1 ± 0.4% | 449.1 ± 1.4% | 21.489 | 30.719 | 79.035 | 31.507 | 74.232 |
| hex: canterbury/ptt5 | 524290 | 33095.1 ± 0.3% | 1543.5 ± 0.7% | 1085.9 ± 12.7% | 503.5 ± 0.3% | 1054.5 ± 0.7% | 451.6 ± 0.4% | 21.441 | 30.477 | 65.733 | 31.386 | 73.292 |
| hex: canterbury/sum | 76482 | 35665.3 ± 9.0% | 1617.1 ± 17.2% | 1105.5 ± 0.2% | 509.3 ± 0.9% | 1074.5 ± 0.3% | 458.5 ± 0.2% | 22.055 | 32.262 | 70.023 | 33.192 | 77.785 |
| hex: canterbury/xargs.1 | 8456 | 34506.4 ± 0.8% | 1631.7 ± 0.8% | 1112.7 ± 0.1% | 618.4 ± 0.3% | 1090.9 ± 0.7% | 460.9 ± 0.8% | 21.147 | 31.012 | 55.803 | 31.632 | 74.860 |
| hex: canterbury-large/E.coli | 524290 | 30402.9 ± 9.5% | 1547.4 ± 0.4% | 1085.8 ± 0.3% | 607.8 ± 0.1% | 1052.0 ± 0.3% | 452.1 ± 3.6% | 19.648 | 28.001 | 50.023 | 28.900 | 67.241 |
| hex: canterbury-large/bible.txt | 524290 | 35385.2 ± 0.7% | 1552.1 ± 9.9% | 1086.2 ± 0.1% | 436.0 ± 0.2% | 1056.6 ± 12.5% | 450.1 ± 1.6% | 22.798 | 32.578 | 81.151 | 33.489 | 78.612 |
| hex: canterbury-large/world192.txt | 524290 | 34612.7 ± 7.1% | 1549.7 ± 1.1% | 1084.9 ± 1.6% | 422.8 ± 0.7% | 1058.9 ± 0.6% | 450.6 ± 0.6% | 22.336 | 31.905 | 81.861 | 32.688 | 76.823 |
| hex: http/html-1kx1024 | 2099200 | 23060.2 ± 0.9% | 1606.3 ± 0.6% | 1087.5 ± 1.1% | 448.3 ± 0.5% | 1066.5 ± 0.9% | 451.3 ± 0.9% | 14.356 | 21.205 | 51.435 | 21.621 | 51.101 |
| hex: http/html-16kx64 | 2097280 | 29896.8 ± 0.8% | 1608.2 ± 1.0% | 1103.8 ± 0.3% | 444.1 ± 0.3% | 1026.2 ± 0.7% | 456.0 ± 0.2% | 18.591 | 27.084 | 67.312 | 29.132 | 65.562 |
| hex: http/html-1m | 524290 | 29080.9 ± 0.3% | 1551.4 ± 0.5% | 1084.4 ± 1.6% | 446.6 ± 0.4% | 1055.6 ± 11.1% | 450.3 ± 0.3% | 18.744 | 26.818 | 65.120 | 27.549 | 64.587 |
| hex: http/json-1kx1024 | 2099200 | 23720.0 ± 2.5% | 1611.1 ± 0.3% | 1090.4 ± 2.1% | 564.1 ± 0.3% | 1071.3 ± 1.1% | 451.2 ± 0.9% | 14.723 | 21.753 | 42.049 | 22.141 | 52.568 |
| hex: http/json-16kx64 | 2097280 | 29862.0 ± 2.1% | 1606.1 ± 1.0% | 1103.1 ± 0.1% | 566.9 ± 7.1% | 1051.4 ± 0.6% | 455.8 ± 0.3% | 18.593 | 27.070 | 52.672 | 28.403 | 65.521 |
| hex: http/json-1m | 524290 | 31908.4 ± 0.8% | 1550.8 ± 0.6% | 1085.3 ± 0.2% | 587.7 ± 0.4% | 1051.4 ± 0.6% | 450.1 ± 0.3% | 20.576 | 29.400 | 54.294 | 30.348 | 70.893 |
| hex: http/js-1kx1024 | 2099200 | 23717.9 ± 2.9% | 1609.8 ± 0.7% | 1090.2 ± 0.6% | 437.3 ± 0.8% | 1075.2 ± 0.6% | 451.5 ± 9.4% | 14.734 | 21.756 | 54.237 | 22.059 | 52.534 |
| hex: http/js-16kx64 | 2097280 | 29868.9 ± 1.5% | 1610.7 ± 10.7% | 1105.1 ± 0.2% | 428.0 ± 0.2% | 1003.7 ± 0.7% | 456.5 ± 1.9% | 18.544 | 27.028 | 69.782 | 29.758 | 65.434 |
| hex: http/js-1m | 524290 | 30306.3 ± 0.6% | 1553.0 ± 0.5% | 1087.0 ± 0.4% | 434.7 ± 8.5% | 1051.9 ± 2.5% | 450.6 ± 0.5% | 19.515 | 27.881 | 69.723 | 28.810 | 67.257 |
| hex: http/css-1kx1024 | 2099200 | 23111.6 ± 0.6% | 1607.6 ± 0.6% | 1088.4 ± 0.7% | 496.2 ± 0.6% | 1068.7 ± 0.7% | 450.9 ± 1.6% | 14.377 | 21.235 | 46.578 | 21.625 | 51.252 |
| hex: http/css-16kx64 | 2097280 | 29786.2 ± 1.2% | 1609.3 ± 0.6% | 1104.0 ± 3.6% | 498.7 ± 7.7% | 1057.6 ± 0.3% | 453.9 ± 0.3% | 18.509 | 26.980 | 59.726 | 28.165 | 65.617 |
| hex: http/css-1m | 524290 | 31320.0 ± 0.6% | 1547.7 ± 3.3% | 1085.1 ± 0.1% | 448.6 ± 0.4% | 1035.0 ± 6.7% | 450.2 ± 0.4% | 20.237 | 28.864 | 69.814 | 30.262 | 69.563 |
| hex: shuffled/dickens-1m | 524290 | 34154.1 ± 1.3% | 1549.7 ± 1.5% | 1086.8 ± 1.0% | 430.9 ± 0.3% | 1051.1 ± 0.2% | 449.8 ± 0.7% | 22.039 | 31.428 | 79.268 | 32.494 | 75.930 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1347.7 ± 1.1% | 1128.7 ± 1.3% | 893.5 ± 2.0% | 328.7 ± 1.1% | 366.9 ± 3.3% | 310.6 ± 3.0% | 1.194 | 1.508 | 4.100 | 3.674 | 4.339 |
| qlog records, JSON text sequence | 1467503 | 1158.1 ± 0.4% | 857.4 ± 1.2% | 726.3 ± 0.9% | 318.2 ± 1.7% | 390.4 ± 0.7% | 226.2 ± 3.1% | 1.351 | 1.594 | 3.640 | 2.967 | 5.120 |
| string: silesia/dickens | 172528 | 9568.0 ± 1.4% | 2946.7 ± 1.7% | 2019.3 ± 0.3% | 357.3 ± 0.3% | 1409.3 ± 2.3% | 559.9 ± 3.9% | 3.247 | 4.738 | 26.778 | 6.789 | 17.089 |
| string: silesia/nci | 1075110 | 8850.7 ± 11.3% | 3162.6 ± 23.3% | 2776.3 ± 23.8% | 775.4 ± 11.8% | 1538.5 ± 0.5% | 562.3 ± 7.7% | 2.799 | 3.188 | 11.415 | 5.753 | 15.741 |
| string: silesia/reymont | 1075159 | 3867.4 ± 0.3% | 1653.8 ± 0.4% | 1721.3 ± 0.3% | 360.3 ± 0.6% | 1253.3 ± 0.5% | 548.4 ± 2.2% | 2.338 | 2.247 | 10.735 | 3.086 | 7.052 |
| string: silesia/samba | 97582 | 4693.4 ± 0.8% | 1980.0 ± 0.6% | 2151.4 ± 0.3% | 299.3 ± 0.4% | 1039.7 ± 0.3% | 620.4 ± 1.5% | 2.370 | 2.182 | 15.681 | 4.514 | 7.566 |
| string: silesia/webster | 1098490 | 5077.8 ± 0.3% | 1628.7 ± 1.5% | 1512.4 ± 0.8% | 353.7 ± 0.5% | 1196.9 ± 1.4% | 454.1 ± 0.9% | 3.118 | 3.357 | 14.357 | 4.243 | 11.182 |
| string: silesia/xml | 1090118 | 8300.0 ± 1.6% | 2664.5 ± 0.9% | 2170.2 ± 0.9% | 547.9 ± 0.5% | 1583.3 ± 0.4% | 562.2 ± 0.4% | 3.115 | 3.824 | 15.150 | 5.242 | 14.762 |
| string: canterbury/alice29.txt | 159425 | 10340.8 ± 1.0% | 2466.1 ± 1.7% | 1797.6 ± 0.3% | 335.7 ± 0.5% | 1261.7 ± 0.6% | 557.4 ± 1.6% | 4.193 | 5.753 | 30.799 | 8.196 | 18.552 |
| string: canterbury/asyoulik.txt | 132198 | 8567.7 ± 3.0% | 2205.1 ± 1.4% | 1539.9 ± 0.8% | 343.7 ± 5.0% | 1115.5 ± 10.7% | 543.9 ± 1.2% | 3.885 | 5.564 | 24.926 | 7.680 | 15.753 |
| string: canterbury/lcet10.txt | 441884 | 9326.9 ± 3.9% | 2474.9 ± 0.5% | 1963.8 ± 0.2% | 389.8 ± 1.3% | 1384.7 ± 3.9% | 551.4 ± 0.8% | 3.769 | 4.749 | 23.928 | 6.736 | 16.914 |
| string: canterbury/plrabn12.txt | 503330 | 6442.5 ± 0.3% | 1831.0 ± 5.8% | 1661.3 ± 0.4% | 363.0 ± 0.6% | 1295.3 ± 0.1% | 558.4 ± 0.8% | 3.519 | 3.878 | 17.746 | 4.974 | 11.538 |
| string: canterbury-large/E.coli | 1048578 | 29186.5 ± 1.3% | 10291.4 ± 0.9% | 3381.9 ± 0.2% | 1402.4 ± 0.5% | 2504.0 ± 1.3% | 575.8 ± 0.8% | 2.836 | 8.630 | 20.811 | 11.656 | 50.689 |
| string: canterbury-large/bible.txt | 1055886 | 7372.2 ± 0.8% | 3920.5 ± 1.9% | 2658.8 ± 0.5% | 433.6 ± 0.1% | 1873.4 ± 0.5% | 566.2 ± 1.0% | 1.880 | 2.773 | 17.001 | 3.935 | 13.021 |
| string: canterbury-large/world192.txt | 1103121 | 4841.8 ± 4.1% | 1440.6 ± 0.7% | 1547.3 ± 2.8% | 368.0 ± 0.8% | 1171.5 ± 17.4% | 539.2 ± 0.8% | 3.361 | 3.129 | 13.158 | 4.133 | 8.979 |
| string: http/html-1m | 1058582 | 8789.6 ± 0.6% | 3829.9 ± 10.9% | 2471.5 ± 1.4% | 397.5 ± 11.1% | 1811.4 ± 3.3% | 522.2 ± 0.5% | 2.295 | 3.556 | 22.112 | 4.852 | 16.833 |
| string: http/json-1m | 1190272 | 6770.7 ± 0.2% | 1226.6 ± 0.4% | 1268.3 ± 0.6% | 373.5 ± 0.7% | 891.1 ± 0.9% | 508.0 ± 1.7% | 5.520 | 5.338 | 18.127 | 7.598 | 13.327 |
| string: http/js-1m | 1144362 | 5074.1 ± 1.5% | 993.4 ± 0.2% | 1088.2 ± 0.5% | 282.3 ± 0.7% | 924.9 ± 0.9% | 479.9 ± 1.7% | 5.108 | 4.663 | 17.971 | 5.486 | 10.573 |
| string: http/css-1m | 1097820 | 7165.2 ± 0.4% | 1287.6 ± 0.6% | 1600.0 ± 0.5% | 402.4 ± 29.3% | 1047.5 ± 15.5% | 536.0 ± 1.2% | 5.565 | 4.478 | 17.806 | 6.840 | 13.367 |
| string: dickens as Cyrillic and CJK | 1883069 | 5459.6 ± 0.7% | 3044.5 ± 0.3% | 342.6 ± 5.2% | 268.8 ± 9.8% | 463.9 ± 4.4% | 293.0 ± 17.6% | 1.793 | 15.936 | 20.313 | 11.770 | 18.632 |
| hex: silesia/dickens | 524290 | 31622.6 ± 0.7% | 1549.6 ± 0.6% | 1085.4 ± 0.5% | 421.2 ± 4.4% | 1055.0 ± 0.8% | 451.0 ± 0.6% | 20.407 | 29.133 | 75.070 | 29.974 | 70.124 |
| hex: silesia/mozilla | 524290 | 35562.2 ± 0.6% | 1546.6 ± 1.3% | 1084.1 ± 0.4% | 369.6 ± 6.0% | 1053.9 ± 0.5% | 451.4 ± 0.7% | 22.993 | 32.805 | 96.211 | 33.744 | 78.791 |
| hex: silesia/mr | 524290 | 33242.9 ± 0.3% | 1545.2 ± 0.4% | 1083.7 ± 0.3% | 511.8 ± 0.3% | 1056.7 ± 12.5% | 450.6 ± 1.0% | 21.514 | 30.675 | 64.953 | 31.461 | 73.767 |
| hex: silesia/nci | 524290 | 33197.1 ± 0.4% | 1542.7 ± 0.9% | 1084.6 ± 1.5% | 558.0 ± 0.6% | 1054.3 ± 0.3% | 450.7 ± 0.4% | 21.519 | 30.608 | 59.488 | 31.487 | 73.656 |
| hex: silesia/ooffice | 524290 | 33444.8 ± 0.5% | 1544.7 ± 0.5% | 1082.1 ± 0.2% | 328.3 ± 1.5% | 1059.6 ± 0.5% | 448.8 ± 2.1% | 21.651 | 30.907 | 101.883 | 31.564 | 74.526 |
| hex: silesia/osdb | 524290 | 35085.3 ± 0.3% | 1547.0 ± 7.4% | 1084.5 ± 0.5% | 414.7 ± 1.3% | 1056.4 ± 0.6% | 451.0 ± 0.9% | 22.680 | 32.351 | 84.613 | 33.212 | 77.800 |
| hex: silesia/reymont | 524290 | 34135.1 ± 3.0% | 1548.8 ± 0.4% | 1085.1 ± 12.3% | 438.0 ± 0.3% | 1057.8 ± 1.7% | 450.6 ± 0.5% | 22.040 | 31.459 | 77.934 | 32.269 | 75.751 |
| hex: silesia/samba | 524290 | 34343.3 ± 0.4% | 1548.9 ± 1.0% | 1084.7 ± 0.5% | 333.3 ± 0.1% | 1058.0 ± 0.3% | 450.0 ± 1.0% | 22.173 | 31.663 | 103.055 | 32.461 | 76.322 |
| hex: silesia/sao | 524290 | 34556.9 ± 1.0% | 1545.1 ± 0.7% | 1083.7 ± 0.6% | 266.6 ± 7.2% | 1058.9 ± 0.3% | 450.6 ± 0.2% | 22.365 | 31.888 | 129.621 | 32.633 | 76.687 |
| hex: silesia/webster | 524290 | 36679.1 ± 2.5% | 1544.3 ± 0.9% | 1085.4 ± 1.3% | 389.4 ± 0.6% | 1056.3 ± 0.6% | 449.4 ± 0.8% | 23.752 | 33.793 | 94.190 | 34.723 | 81.612 |
| hex: silesia/x-ray | 524290 | 33769.6 ± 0.6% | 1550.1 ± 1.0% | 1087.5 ± 1.6% | 393.9 ± 0.2% | 1059.4 ± 0.7% | 450.6 ± 0.8% | 21.786 | 31.053 | 85.724 | 31.876 | 74.946 |
| hex: silesia/xml | 524290 | 33350.6 ± 0.3% | 1545.3 ± 0.6% | 1082.4 ± 9.6% | 586.7 ± 0.5% | 1056.9 ± 2.3% | 450.1 ± 1.2% | 21.581 | 30.811 | 56.840 | 31.556 | 74.093 |
| hex: canterbury/alice29.txt | 304180 | 33378.4 ± 2.6% | 1579.0 ± 0.9% | 1094.7 ± 0.3% | 430.3 ± 0.2% | 1072.3 ± 1.0% | 452.6 ± 0.3% | 21.139 | 30.492 | 77.565 | 31.127 | 73.756 |
| hex: canterbury/asyoulik.txt | 250360 | 32006.4 ± 0.5% | 1588.6 ± 1.9% | 1101.8 ± 0.7% | 426.5 ± 0.2% | 1079.8 ± 0.6% | 454.4 ± 0.3% | 20.147 | 29.049 | 75.039 | 29.640 | 70.430 |
| hex: canterbury/cp.html | 49208 | 31843.4 ± 0.6% | 1621.1 ± 1.6% | 1112.5 ± 0.4% | 457.8 ± 0.2% | 1077.9 ± 0.4% | 456.3 ± 0.3% | 19.643 | 28.624 | 69.556 | 29.542 | 69.788 |
| hex: canterbury/fields.c | 22302 | 32676.0 ± 0.4% | 1600.7 ± 0.5% | 1101.8 ± 0.2% | 547.6 ± 0.7% | 1067.1 ± 1.3% | 453.6 ± 1.2% | 20.413 | 29.657 | 59.668 | 30.622 | 72.038 |
| hex: canterbury/grammar.lsp | 7444 | 33244.9 ± 13.8% | 1634.9 ± 9.2% | 1115.2 ± 2.5% | 584.2 ± 0.6% | 1086.2 ± 1.0% | 460.8 ± 0.8% | 20.334 | 29.810 | 56.908 | 30.608 | 72.153 |
| hex: canterbury/kennedy.xls | 524290 | 31844.4 ± 0.3% | 1547.4 ± 0.4% | 1084.6 ± 1.6% | 595.4 ± 0.2% | 1054.7 ± 0.4% | 451.4 ± 0.3% | 20.579 | 29.359 | 53.483 | 30.194 | 70.550 |
| hex: canterbury/lcet10.txt | 524290 | 34605.3 ± 0.7% | 1545.2 ± 0.9% | 1084.8 ± 0.6% | 422.5 ± 0.2% | 1056.6 ± 0.8% | 450.2 ± 0.5% | 22.395 | 31.899 | 81.902 | 32.753 | 76.874 |
| hex: canterbury/plrabn12.txt | 524290 | 33643.6 ± 0.4% | 1551.4 ± 0.6% | 1085.3 ± 0.3% | 421.8 ± 0.2% | 1058.1 ± 0.4% | 449.1 ± 1.4% | 21.686 | 31.000 | 79.758 | 31.795 | 74.911 |
| hex: canterbury/ptt5 | 524290 | 33272.3 ± 0.4% | 1543.5 ± 0.7% | 1085.9 ± 12.7% | 503.5 ± 0.3% | 1054.5 ± 0.7% | 451.6 ± 0.4% | 21.556 | 30.640 | 66.085 | 31.554 | 73.684 |
| hex: canterbury/sum | 76482 | 35369.6 ± 0.2% | 1617.1 ± 17.2% | 1105.5 ± 0.2% | 509.3 ± 0.9% | 1074.5 ± 0.3% | 458.5 ± 0.2% | 21.872 | 31.994 | 69.442 | 32.916 | 77.140 |
| hex: canterbury/xargs.1 | 8456 | 34897.9 ± 1.5% | 1631.7 ± 0.8% | 1112.7 ± 0.1% | 618.4 ± 0.3% | 1090.9 ± 0.7% | 460.9 ± 0.8% | 21.387 | 31.364 | 56.436 | 31.991 | 75.709 |
| hex: canterbury-large/E.coli | 524290 | 30851.1 ± 1.0% | 1547.4 ± 0.4% | 1085.8 ± 0.3% | 607.8 ± 0.1% | 1052.0 ± 0.3% | 452.1 ± 3.6% | 19.938 | 28.414 | 50.760 | 29.326 | 68.232 |
| hex: canterbury-large/bible.txt | 524290 | 35553.0 ± 0.6% | 1552.1 ± 9.9% | 1086.2 ± 0.1% | 436.0 ± 0.2% | 1056.6 ± 12.5% | 450.1 ± 1.6% | 22.906 | 32.732 | 81.536 | 33.648 | 78.985 |
| hex: canterbury-large/world192.txt | 524290 | 35070.3 ± 0.4% | 1549.7 ± 1.1% | 1084.9 ± 1.6% | 422.8 ± 0.7% | 1058.9 ± 0.6% | 450.6 ± 0.6% | 22.631 | 32.327 | 82.944 | 33.120 | 77.838 |
| hex: http/html-1kx1024 | 2099200 | 23992.6 ± 0.5% | 1606.3 ± 0.6% | 1087.5 ± 1.1% | 448.3 ± 0.5% | 1066.5 ± 0.9% | 451.3 ± 0.9% | 14.937 | 22.063 | 53.514 | 22.496 | 53.168 |
| hex: http/html-16kx64 | 2097280 | 30166.0 ± 0.5% | 1608.2 ± 1.0% | 1103.8 ± 0.3% | 444.1 ± 0.3% | 1026.2 ± 0.7% | 456.0 ± 0.2% | 18.758 | 27.328 | 67.918 | 29.395 | 66.152 |
| hex: http/html-1m | 524290 | 29231.7 ± 1.3% | 1551.4 ± 0.5% | 1084.4 ± 1.6% | 446.6 ± 0.4% | 1055.6 ± 11.1% | 450.3 ± 0.3% | 18.842 | 26.957 | 65.458 | 27.692 | 64.922 |
| hex: http/json-1kx1024 | 2099200 | 24454.5 ± 1.6% | 1611.1 ± 0.3% | 1090.4 ± 2.1% | 564.1 ± 0.3% | 1071.3 ± 1.1% | 451.2 ± 0.9% | 15.178 | 22.426 | 43.351 | 22.827 | 54.196 |
| hex: http/json-16kx64 | 2097280 | 30077.2 ± 0.4% | 1606.1 ± 1.0% | 1103.1 ± 0.1% | 566.9 ± 7.1% | 1051.4 ± 0.6% | 455.8 ± 0.3% | 18.727 | 27.265 | 53.051 | 28.608 | 65.993 |
| hex: http/json-1m | 524290 | 31942.8 ± 0.2% | 1550.8 ± 0.6% | 1085.3 ± 0.2% | 587.7 ± 0.4% | 1051.4 ± 0.6% | 450.1 ± 0.3% | 20.598 | 29.432 | 54.352 | 30.381 | 70.970 |
| hex: http/js-1kx1024 | 2099200 | 24469.1 ± 0.3% | 1609.8 ± 0.7% | 1090.2 ± 0.6% | 437.3 ± 0.8% | 1075.2 ± 0.6% | 451.5 ± 9.4% | 15.201 | 22.445 | 55.955 | 22.758 | 54.198 |
| hex: http/js-16kx64 | 2097280 | 30136.9 ± 0.6% | 1610.7 ± 10.7% | 1105.1 ± 0.2% | 428.0 ± 0.2% | 1003.7 ± 0.7% | 456.5 ± 1.9% | 18.710 | 27.270 | 70.408 | 30.025 | 66.021 |
| hex: http/js-1m | 524290 | 30539.7 ± 2.1% | 1553.0 ± 0.5% | 1087.0 ± 0.4% | 434.7 ± 8.5% | 1051.9 ± 2.5% | 450.6 ± 0.5% | 19.665 | 28.096 | 70.260 | 29.032 | 67.775 |
| hex: http/css-1kx1024 | 2099200 | 23857.1 ± 0.6% | 1607.6 ± 0.6% | 1088.4 ± 0.7% | 496.2 ± 0.6% | 1068.7 ± 0.7% | 450.9 ± 1.6% | 14.841 | 21.920 | 48.080 | 22.323 | 52.905 |
| hex: http/css-16kx64 | 2097280 | 30048.6 ± 0.6% | 1609.3 ± 0.6% | 1104.0 ± 3.6% | 498.7 ± 7.7% | 1057.6 ± 0.3% | 453.9 ± 0.3% | 18.672 | 27.217 | 60.252 | 28.413 | 66.195 |
| hex: http/css-1m | 524290 | 31443.9 ± 0.3% | 1547.7 ± 3.3% | 1085.1 ± 0.1% | 448.6 ± 0.4% | 1035.0 ± 6.7% | 450.2 ± 0.4% | 20.317 | 28.979 | 70.090 | 30.382 | 69.838 |
| hex: shuffled/dickens-1m | 524290 | 34769.8 ± 1.9% | 1549.7 ± 1.5% | 1086.8 ± 1.0% | 430.9 ± 0.3% | 1051.1 ± 0.2% | 449.8 ± 0.7% | 22.436 | 31.994 | 80.697 | 33.080 | 77.299 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 836.5 ± 0.8% | 1009.2 ± 2.7% | 967.0 ± 1.3% | 288.0 ± 0.6% | 531.1 ± 0.7% | 259.0 ± 3.0% | 0.829 | 0.865 | 2.904 | 1.575 | 3.230 |
| qlog records, JSON text sequence | 1467503 | 764.7 ± 12.0% | 813.0 ± 0.3% | 798.6 ± 7.2% | 239.9 ± 10.0% | 577.4 ± 0.5% | 244.9 ± 2.8% | 0.941 | 0.958 | 3.187 | 1.325 | 3.123 |
| string: silesia/dickens | 172528 | 5732.9 ± 4.6% | 2884.3 ± 1.5% | 2059.9 ± 0.5% | 302.3 ± 8.6% | 2182.4 ± 0.6% | 493.9 ± 2.6% | 1.988 | 2.783 | 18.961 | 2.627 | 11.608 |
| string: silesia/nci | 1075110 | 4554.4 ± 0.1% | 3459.4 ± 0.5% | 2824.2 ± 2.4% | 501.9 ± 0.8% | 2328.9 ± 0.6% | 525.9 ± 2.3% | 1.317 | 1.613 | 9.074 | 1.956 | 8.659 |
| string: silesia/reymont | 1075159 | 3706.2 ± 0.3% | 2191.3 ± 0.2% | 1755.6 ± 2.7% | 318.0 ± 0.8% | 1640.3 ± 1.9% | 475.8 ± 0.6% | 1.691 | 2.111 | 11.655 | 2.259 | 7.789 |
| string: silesia/samba | 97582 | 3275.6 ± 0.6% | 2878.6 ± 0.4% | 1572.2 ± 1.8% | 261.4 ± 0.9% | 1281.2 ± 2.9% | 354.7 ± 1.4% | 1.138 | 2.083 | 12.531 | 2.557 | 9.236 |
| string: silesia/webster | 1098490 | 3726.8 ± 0.3% | 2028.1 ± 0.3% | 1627.7 ± 2.8% | 307.3 ± 12.6% | 1655.0 ± 1.0% | 440.7 ± 1.5% | 1.838 | 2.290 | 12.126 | 2.252 | 8.457 |
| string: silesia/xml | 1090118 | 5214.7 ± 1.0% | 3702.8 ± 0.5% | 2145.2 ± 1.0% | 409.8 ± 0.6% | 2368.5 ± 0.5% | 512.1 ± 19.3% | 1.408 | 2.431 | 12.726 | 2.202 | 10.183 |
| string: canterbury/alice29.txt | 159425 | 5004.6 ± 0.4% | 2414.9 ± 2.6% | 1821.8 ± 0.4% | 287.2 ± 1.3% | 1951.6 ± 3.0% | 444.8 ± 14.9% | 2.072 | 2.747 | 17.424 | 2.564 | 11.250 |
| string: canterbury/asyoulik.txt | 132198 | 3365.1 ± 0.3% | 2106.8 ± 0.7% | 1494.1 ± 1.7% | 273.9 ± 0.9% | 1609.9 ± 1.7% | 402.7 ± 2.6% | 1.597 | 2.252 | 12.286 | 2.090 | 8.356 |
| string: canterbury/lcet10.txt | 441884 | 5564.2 ± 0.3% | 2783.0 ± 0.7% | 1969.8 ± 2.3% | 322.3 ± 5.8% | 2141.3 ± 4.3% | 487.2 ± 0.9% | 1.999 | 2.825 | 17.266 | 2.598 | 11.421 |
| string: canterbury/plrabn12.txt | 503330 | 4958.6 ± 0.2% | 2691.2 ± 0.3% | 1677.7 ± 0.7% | 297.8 ± 0.9% | 2011.9 ± 0.3% | 460.9 ± 1.0% | 1.843 | 2.956 | 16.653 | 2.465 | 10.758 |
| string: canterbury-large/E.coli | 1048578 | 33420.6 ± 3.1% | 7664.3 ± 1.2% | 3432.0 ± 1.6% | 800.2 ± 0.2% | 5525.2 ± 0.1% | 806.9 ± 0.6% | 4.361 | 9.738 | 41.767 | 6.049 | 41.421 |
| string: canterbury-large/bible.txt | 1055886 | 9505.3 ± 0.5% | 3903.6 ± 0.2% | 2546.4 ± 2.0% | 351.2 ± 4.7% | 2974.2 ± 0.3% | 604.2 ± 1.3% | 2.435 | 3.733 | 27.066 | 3.196 | 15.731 |
| string: canterbury-large/world192.txt | 1103121 | 3623.2 ± 0.2% | 1974.1 ± 0.5% | 1612.9 ± 3.3% | 295.0 ± 1.5% | 1688.3 ± 1.0% | 435.0 ± 1.2% | 1.835 | 2.246 | 12.283 | 2.146 | 8.330 |
| string: http/html-1m | 1058582 | 7836.7 ± 1.7% | 3392.0 ± 0.2% | 2367.0 ± 1.8% | 407.1 ± 1.0% | 2728.6 ± 0.3% | 428.9 ± 1.3% | 2.310 | 3.311 | 19.248 | 2.872 | 18.271 |
| string: http/json-1m | 1190272 | 3140.9 ± 0.5% | 1199.6 ± 0.2% | 1421.7 ± 5.8% | 352.9 ± 1.7% | 838.6 ± 1.2% | 295.8 ± 0.9% | 2.618 | 2.209 | 8.899 | 3.745 | 10.619 |
| string: http/js-1m | 1144362 | 2680.9 ± 0.7% | 1322.0 ± 0.6% | 1165.0 ± 3.0% | 279.8 ± 1.0% | 1156.1 ± 1.2% | 296.9 ± 1.3% | 2.028 | 2.301 | 9.581 | 2.319 | 9.029 |
| string: http/css-1m | 1097820 | 2695.9 ± 0.5% | 2499.0 ± 0.8% | 1532.2 ± 0.5% | 372.7 ± 0.4% | 1527.5 ± 2.3% | 337.8 ± 0.4% | 1.079 | 1.760 | 7.234 | 1.765 | 7.981 |
| string: dickens as Cyrillic and CJK | 1883069 | 5119.5 ± 1.0% | 3160.1 ± 0.4% | 651.8 ± 0.3% | 251.8 ± 5.9% | 497.6 ± 0.6% | 137.9 ± 1.7% | 1.620 | 7.855 | 20.334 | 10.289 | 37.128 |
| string: dickens as Cyrillic and CJK, as \u escapes | 5075485 | 1062.3 ± 0.4% | 1076.9 ± 0.5% | 819.1 ± 1.2% | 162.0 ± 0.3% | 383.5 ± 5.3% | 200.6 ± 4.5% | 0.986 | 1.297 | 6.558 | 2.770 | 5.295 |
| hex: silesia/dickens | 524290 | 33169.6 ± 0.7% | 7613.1 ± 0.6% | 3424.7 ± 1.2% | 469.4 ± 7.6% | 5513.9 ± 0.7% | 798.5 ± 1.7% | 4.357 | 9.685 | 70.671 | 6.016 | 41.542 |
| hex: silesia/mozilla | 524290 | 33535.9 ± 0.4% | 7651.7 ± 0.8% | 3448.8 ± 1.3% | 408.9 ± 2.5% | 5518.4 ± 0.3% | 820.3 ± 2.7% | 4.383 | 9.724 | 82.012 | 6.077 | 40.881 |
| hex: silesia/mr | 524290 | 33647.7 ± 2.2% | 7623.2 ± 1.4% | 3436.2 ± 1.1% | 581.3 ± 0.3% | 5509.2 ± 17.0% | 826.1 ± 1.5% | 4.414 | 9.792 | 57.885 | 6.108 | 40.729 |
| hex: silesia/nci | 524290 | 33440.7 ± 1.3% | 7622.6 ± 1.1% | 3450.6 ± 0.3% | 644.6 ± 0.2% | 5509.0 ± 0.6% | 815.0 ± 0.7% | 4.387 | 9.691 | 51.882 | 6.070 | 41.031 |
| hex: silesia/ooffice | 524290 | 33642.3 ± 0.2% | 7621.8 ± 1.2% | 3446.5 ± 6.8% | 356.5 ± 0.2% | 5526.7 ± 0.3% | 812.3 ± 8.3% | 4.414 | 9.761 | 94.357 | 6.087 | 41.415 |
| hex: silesia/osdb | 524290 | 33265.5 ± 2.5% | 7633.0 ± 0.3% | 3456.4 ± 0.3% | 453.1 ± 0.7% | 5504.7 ± 1.7% | 807.3 ± 2.1% | 4.358 | 9.624 | 73.421 | 6.043 | 41.206 |
| hex: silesia/reymont | 524290 | 33251.5 ± 0.1% | 7604.1 ± 0.5% | 3414.1 ± 3.9% | 486.7 ± 0.5% | 5533.9 ± 0.3% | 813.7 ± 1.9% | 4.373 | 9.739 | 68.319 | 6.009 | 40.864 |
| hex: silesia/samba | 524290 | 33499.7 ± 2.7% | 7643.0 ± 0.5% | 3441.5 ± 0.4% | 363.0 ± 0.2% | 5523.7 ± 1.2% | 814.8 ± 1.3% | 4.383 | 9.734 | 92.290 | 6.065 | 41.116 |
| hex: silesia/sao | 524290 | 33300.5 ± 1.0% | 7618.0 ± 0.8% | 3425.5 ± 0.4% | 289.3 ± 0.2% | 5504.6 ± 1.3% | 807.8 ± 1.4% | 4.371 | 9.721 | 115.117 | 6.050 | 41.225 |
| hex: silesia/webster | 524290 | 33311.0 ± 1.8% | 7601.2 ± 0.4% | 3434.2 ± 0.7% | 435.6 ± 1.0% | 5527.4 ± 5.5% | 801.8 ± 2.3% | 4.382 | 9.700 | 76.476 | 6.027 | 41.544 |
| hex: silesia/x-ray | 524290 | 33377.2 ± 0.9% | 7614.0 ± 2.6% | 3424.1 ± 4.8% | 435.8 ± 0.6% | 5506.4 ± 0.5% | 809.5 ± 1.3% | 4.384 | 9.748 | 76.596 | 6.062 | 41.231 |
| hex: silesia/xml | 524290 | 33211.2 ± 12.9% | 7642.6 ± 0.6% | 3435.1 ± 0.3% | 603.4 ± 0.4% | 5526.1 ± 0.5% | 813.0 ± 1.8% | 4.346 | 9.668 | 55.036 | 6.010 | 40.849 |
| hex: canterbury/alice29.txt | 304180 | 33813.0 ± 1.4% | 7658.6 ± 2.3% | 3556.7 ± 0.6% | 470.5 ± 0.8% | 5515.8 ± 3.3% | 808.0 ± 0.9% | 4.415 | 9.507 | 71.859 | 6.130 | 41.848 |
| hex: canterbury/asyoulik.txt | 250360 | 33712.6 ± 0.3% | 7723.8 ± 3.1% | 3552.8 ± 0.4% | 461.6 ± 0.4% | 5523.2 ± 1.1% | 808.4 ± 1.6% | 4.365 | 9.489 | 73.035 | 6.104 | 41.705 |
| hex: canterbury/cp.html | 49208 | 32694.5 ± 0.9% | 7783.8 ± 0.1% | 3607.2 ± 1.3% | 462.7 ± 0.3% | 5485.9 ± 0.6% | 800.6 ± 1.1% | 4.200 | 9.064 | 70.659 | 5.960 | 40.839 |
| hex: canterbury/fields.c | 22302 | 31617.1 ± 2.1% | 7700.9 ± 0.2% | 3609.5 ± 0.2% | 487.7 ± 0.3% | 5460.6 ± 0.7% | 793.6 ± 3.8% | 4.106 | 8.759 | 64.823 | 5.790 | 39.838 |
| hex: canterbury/grammar.lsp | 7444 | 27506.4 ± 10.3% | 7489.9 ± 0.6% | 3557.0 ± 2.4% | 538.1 ± 0.3% | 5378.5 ± 6.6% | 761.8 ± 4.0% | 3.672 | 7.733 | 51.121 | 5.114 | 36.107 |
| hex: canterbury/kennedy.xls | 524290 | 33496.5 ± 11.6% | 7627.7 ± 0.5% | 3434.3 ± 0.4% | 685.3 ± 0.5% | 5513.4 ± 0.5% | 815.9 ± 6.4% | 4.391 | 9.754 | 48.877 | 6.075 | 41.055 |
| hex: canterbury/lcet10.txt | 524290 | 33273.0 ± 0.5% | 7636.5 ± 0.7% | 3457.1 ± 0.4% | 473.3 ± 0.3% | 5530.0 ± 0.9% | 816.0 ± 2.7% | 4.357 | 9.624 | 70.301 | 6.017 | 40.775 |
| hex: canterbury/plrabn12.txt | 524290 | 33626.0 ± 0.4% | 7640.6 ± 1.0% | 3451.3 ± 0.9% | 460.1 ± 8.0% | 5518.4 ± 0.1% | 821.1 ± 0.5% | 4.401 | 9.743 | 73.083 | 6.093 | 40.952 |
| hex: canterbury/ptt5 | 524290 | 33250.1 ± 0.3% | 7628.6 ± 0.8% | 3467.5 ± 0.3% | 558.2 ± 11.7% | 5529.9 ± 0.2% | 819.4 ± 1.3% | 4.359 | 9.589 | 59.570 | 6.013 | 40.578 |
| hex: canterbury/sum | 76482 | 33258.6 ± 0.8% | 7806.9 ± 0.2% | 3624.5 ± 0.4% | 528.5 ± 10.2% | 5503.8 ± 0.2% | 823.9 ± 2.5% | 4.260 | 9.176 | 62.925 | 6.043 | 40.366 |
| hex: canterbury/xargs.1 | 8456 | 28131.7 ± 0.5% | 7523.1 ± 0.1% | 3550.6 ± 0.6% | 525.9 ± 1.9% | 5353.3 ± 1.4% | 796.4 ± 4.6% | 3.739 | 7.923 | 53.493 | 5.255 | 35.324 |
| hex: canterbury-large/E.coli | 524290 | 33207.1 ± 0.7% | 7616.5 ± 0.5% | 3445.3 ± 0.4% | 710.1 ± 9.3% | 5506.4 ± 0.6% | 814.5 ± 5.7% | 4.360 | 9.638 | 46.766 | 6.031 | 40.767 |
| hex: canterbury-large/bible.txt | 524290 | 33220.9 ± 1.4% | 7646.5 ± 0.6% | 3436.9 ± 0.7% | 488.2 ± 1.4% | 5503.2 ± 5.4% | 817.6 ± 1.9% | 4.345 | 9.666 | 68.053 | 6.037 | 40.631 |
| hex: canterbury-large/world192.txt | 524290 | 33246.1 ± 8.1% | 7641.5 ± 0.9% | 3444.3 ± 0.7% | 454.6 ± 0.9% | 5520.6 ± 0.3% | 818.9 ± 3.1% | 4.351 | 9.652 | 73.138 | 6.022 | 40.600 |
| hex: http/html-1kx1024 | 2099200 | 16418.5 ± 0.9% | 6612.4 ± 0.5% | 3232.5 ± 0.6% | 487.1 ± 0.5% | 4703.9 ± 0.6% | 720.8 ± 2.8% | 2.483 | 5.079 | 33.709 | 3.490 | 22.778 |
| hex: http/html-16kx64 | 2097280 | 30604.7 ± 3.0% | 7660.9 ± 0.4% | 3501.9 ± 0.3% | 495.6 ± 0.3% | 5419.6 ± 0.5% | 803.1 ± 1.8% | 3.995 | 8.739 | 61.757 | 5.647 | 38.108 |
| hex: http/html-1m | 524290 | 33277.9 ± 0.7% | 7626.3 ± 0.5% | 3450.2 ± 0.5% | 492.9 ± 0.2% | 5520.7 ± 0.7% | 816.2 ± 2.3% | 4.364 | 9.645 | 67.519 | 6.028 | 40.773 |
| hex: http/json-1kx1024 | 2099200 | 16585.3 ± 11.3% | 6594.2 ± 0.4% | 3232.7 ± 1.9% | 618.0 ± 12.4% | 4704.4 ± 3.5% | 727.1 ± 3.5% | 2.515 | 5.131 | 26.837 | 3.526 | 22.810 |
| hex: http/json-16kx64 | 2097280 | 30483.9 ± 0.3% | 7638.6 ± 7.1% | 3479.3 ± 1.0% | 632.0 ± 1.9% | 5418.7 ± 16.6% | 795.6 ± 4.4% | 3.991 | 8.761 | 48.231 | 5.626 | 38.316 |
| hex: http/json-1m | 524290 | 33330.7 ± 10.6% | 7565.7 ± 1.3% | 3439.2 ± 7.3% | 642.9 ± 0.4% | 5533.8 ± 0.3% | 801.5 ± 3.7% | 4.405 | 9.691 | 51.845 | 6.023 | 41.588 |
| hex: http/js-1kx1024 | 2099200 | 16438.0 ± 0.7% | 6590.5 ± 4.2% | 3223.5 ± 0.1% | 472.5 ± 0.6% | 4719.1 ± 0.8% | 710.0 ± 3.7% | 2.494 | 5.099 | 34.788 | 3.483 | 23.153 |
| hex: http/js-16kx64 | 2097280 | 30622.0 ± 16.6% | 7664.0 ± 4.4% | 3475.8 ± 29.1% | 478.6 ± 25.3% | 5429.7 ± 62.3% | 793.1 ± 13.2% | 3.996 | 8.810 | 63.988 | 5.640 | 38.610 |
| hex: http/js-1m | 524290 | 33556.7 ± 0.3% | 7641.1 ± 0.4% | 3439.1 ± 0.2% | 494.4 ± 0.5% | 5544.1 ± 0.3% | 813.7 ± 6.0% | 4.392 | 9.757 | 67.869 | 6.053 | 41.241 |
| hex: http/css-1kx1024 | 2099200 | 16432.0 ± 1.7% | 6588.2 ± 0.2% | 3223.5 ± 1.1% | 538.4 ± 0.5% | 4712.9 ± 1.0% | 711.9 ± 5.4% | 2.494 | 5.098 | 30.520 | 3.487 | 23.081 |
| hex: http/css-16kx64 | 2097280 | 30586.3 ± 0.5% | 7651.9 ± 0.3% | 3496.4 ± 1.3% | 548.5 ± 0.3% | 5429.7 ± 1.0% | 792.6 ± 7.2% | 3.997 | 8.748 | 55.760 | 5.633 | 38.590 |
| hex: http/css-1m | 524290 | 33178.7 ± 0.5% | 7642.3 ± 0.8% | 3430.6 ± 0.7% | 532.3 ± 0.4% | 5515.4 ± 0.1% | 776.8 ± 8.3% | 4.341 | 9.671 | 62.325 | 6.016 | 42.713 |
| hex: shuffled/dickens-1m | 524290 | 33287.0 ± 3.1% | 7646.4 ± 2.1% | 3437.4 ± 3.2% | 470.7 ± 1.0% | 5535.6 ± 0.3% | 802.0 ± 2.1% | 4.353 | 9.684 | 70.722 | 6.013 | 41.505 |

## TextReader.next_items against the baselines

stdx's decoder a slice of tokens a call through `TextReader.next_items`, as a caller that reads a text's values in a loop calls it (decision 79). Octets are the text's. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 960.5 ± 2.8% | 1009.2 ± 2.7% | 967.0 ± 1.3% | 288.0 ± 0.6% | 531.1 ± 0.7% | 259.0 ± 3.0% | 0.952 | 0.993 | 3.335 | 1.809 | 3.709 |
| qlog records, JSON text sequence | 1467503 | 869.8 ± 1.1% | 813.0 ± 0.3% | 798.6 ± 7.2% | 239.9 ± 10.0% | 577.4 ± 0.5% | 244.9 ± 2.8% | 1.070 | 1.089 | 3.625 | 1.506 | 3.552 |
| string: silesia/dickens | 172528 | 5535.4 ± 5.2% | 2884.3 ± 1.5% | 2059.9 ± 0.5% | 302.3 ± 8.6% | 2182.4 ± 0.6% | 493.9 ± 2.6% | 1.919 | 2.687 | 18.308 | 2.536 | 11.208 |
| string: silesia/nci | 1075110 | 4552.1 ± 0.2% | 3459.4 ± 0.5% | 2824.2 ± 2.4% | 501.9 ± 0.8% | 2328.9 ± 0.6% | 525.9 ± 2.3% | 1.316 | 1.612 | 9.069 | 1.955 | 8.655 |
| string: silesia/reymont | 1075159 | 3706.2 ± 1.3% | 2191.3 ± 0.2% | 1755.6 ± 2.7% | 318.0 ± 0.8% | 1640.3 ± 1.9% | 475.8 ± 0.6% | 1.691 | 2.111 | 11.655 | 2.259 | 7.789 |
| string: silesia/samba | 97582 | 3283.0 ± 0.5% | 2878.6 ± 0.4% | 1572.2 ± 1.8% | 261.4 ± 0.9% | 1281.2 ± 2.9% | 354.7 ± 1.4% | 1.140 | 2.088 | 12.560 | 2.562 | 9.256 |
| string: silesia/webster | 1098490 | 3727.1 ± 2.2% | 2028.1 ± 0.3% | 1627.7 ± 2.8% | 307.3 ± 12.6% | 1655.0 ± 1.0% | 440.7 ± 1.5% | 1.838 | 2.290 | 12.127 | 2.252 | 8.458 |
| string: silesia/xml | 1090118 | 5187.9 ± 4.1% | 3702.8 ± 0.5% | 2145.2 ± 1.0% | 409.8 ± 0.6% | 2368.5 ± 0.5% | 512.1 ± 19.3% | 1.401 | 2.418 | 12.661 | 2.190 | 10.131 |
| string: canterbury/alice29.txt | 159425 | 5022.0 ± 0.5% | 2414.9 ± 2.6% | 1821.8 ± 0.4% | 287.2 ± 1.3% | 1951.6 ± 3.0% | 444.8 ± 14.9% | 2.080 | 2.757 | 17.484 | 2.573 | 11.289 |
| string: canterbury/asyoulik.txt | 132198 | 3363.6 ± 1.2% | 2106.8 ± 0.7% | 1494.1 ± 1.7% | 273.9 ± 0.9% | 1609.9 ± 1.7% | 402.7 ± 2.6% | 1.597 | 2.251 | 12.281 | 2.089 | 8.352 |
| string: canterbury/lcet10.txt | 441884 | 5560.5 ± 0.2% | 2783.0 ± 0.7% | 1969.8 ± 2.3% | 322.3 ± 5.8% | 2141.3 ± 4.3% | 487.2 ± 0.9% | 1.998 | 2.823 | 17.254 | 2.597 | 11.413 |
| string: canterbury/plrabn12.txt | 503330 | 4958.9 ± 1.1% | 2691.2 ± 0.3% | 1677.7 ± 0.7% | 297.8 ± 0.9% | 2011.9 ± 0.3% | 460.9 ± 1.0% | 1.843 | 2.956 | 16.654 | 2.465 | 10.759 |
| string: canterbury-large/E.coli | 1048578 | 33510.2 ± 0.4% | 7664.3 ± 1.2% | 3432.0 ± 1.6% | 800.2 ± 0.2% | 5525.2 ± 0.1% | 806.9 ± 0.6% | 4.372 | 9.764 | 41.878 | 6.065 | 41.532 |
| string: canterbury-large/bible.txt | 1055886 | 9532.7 ± 2.1% | 3903.6 ± 0.2% | 2546.4 ± 2.0% | 351.2 ± 4.7% | 2974.2 ± 0.3% | 604.2 ± 1.3% | 2.442 | 3.744 | 27.144 | 3.205 | 15.776 |
| string: canterbury-large/world192.txt | 1103121 | 3619.1 ± 0.4% | 1974.1 ± 0.5% | 1612.9 ± 3.3% | 295.0 ± 1.5% | 1688.3 ± 1.0% | 435.0 ± 1.2% | 1.833 | 2.244 | 12.269 | 2.144 | 8.321 |
| string: http/html-1m | 1058582 | 7871.4 ± 2.1% | 3392.0 ± 0.2% | 2367.0 ± 1.8% | 407.1 ± 1.0% | 2728.6 ± 0.3% | 428.9 ± 1.3% | 2.321 | 3.325 | 19.333 | 2.885 | 18.352 |
| string: http/json-1m | 1190272 | 3139.3 ± 0.3% | 1199.6 ± 0.2% | 1421.7 ± 5.8% | 352.9 ± 1.7% | 838.6 ± 1.2% | 295.8 ± 0.9% | 2.617 | 2.208 | 8.895 | 3.744 | 10.614 |
| string: http/js-1m | 1144362 | 2678.3 ± 0.4% | 1322.0 ± 0.6% | 1165.0 ± 3.0% | 279.8 ± 1.0% | 1156.1 ± 1.2% | 296.9 ± 1.3% | 2.026 | 2.299 | 9.571 | 2.317 | 9.020 |
| string: http/css-1m | 1097820 | 2687.1 ± 0.2% | 2499.0 ± 0.8% | 1532.2 ± 0.5% | 372.7 ± 0.4% | 1527.5 ± 2.3% | 337.8 ± 0.4% | 1.075 | 1.754 | 7.210 | 1.759 | 7.954 |
| string: dickens as Cyrillic and CJK | 1883069 | 5118.0 ± 0.5% | 3160.1 ± 0.4% | 651.8 ± 0.3% | 251.8 ± 5.9% | 497.6 ± 0.6% | 137.9 ± 1.7% | 1.620 | 7.852 | 20.328 | 10.286 | 37.117 |
| string: dickens as Cyrillic and CJK, as \u escapes | 5075485 | 1062.0 ± 9.7% | 1076.9 ± 0.5% | 819.1 ± 1.2% | 162.0 ± 0.3% | 383.5 ± 5.3% | 200.6 ± 4.5% | 0.986 | 1.296 | 6.556 | 2.769 | 5.293 |
| hex: silesia/dickens | 524290 | 33197.2 ± 0.2% | 7613.1 ± 0.6% | 3424.7 ± 1.2% | 469.4 ± 7.6% | 5513.9 ± 0.7% | 798.5 ± 1.7% | 4.361 | 9.693 | 70.730 | 6.021 | 41.576 |
| hex: silesia/mozilla | 524290 | 33435.0 ± 0.3% | 7651.7 ± 0.8% | 3448.8 ± 1.3% | 408.9 ± 2.5% | 5518.4 ± 0.3% | 820.3 ± 2.7% | 4.370 | 9.695 | 81.765 | 6.059 | 40.758 |
| hex: silesia/mr | 524290 | 33642.2 ± 0.4% | 7623.2 ± 1.4% | 3436.2 ± 1.1% | 581.3 ± 0.3% | 5509.2 ± 17.0% | 826.1 ± 1.5% | 4.413 | 9.791 | 57.876 | 6.107 | 40.723 |
| hex: silesia/nci | 524290 | 33394.1 ± 0.9% | 7622.6 ± 1.1% | 3450.6 ± 0.3% | 644.6 ± 0.2% | 5509.0 ± 0.6% | 815.0 ± 0.7% | 4.381 | 9.678 | 51.810 | 6.062 | 40.973 |
| hex: silesia/ooffice | 524290 | 33545.4 ± 0.4% | 7621.8 ± 1.2% | 3446.5 ± 6.8% | 356.5 ± 0.2% | 5526.7 ± 0.3% | 812.3 ± 8.3% | 4.401 | 9.733 | 94.085 | 6.070 | 41.295 |
| hex: silesia/osdb | 524290 | 33422.4 ± 0.6% | 7633.0 ± 0.3% | 3456.4 ± 0.3% | 453.1 ± 0.7% | 5504.7 ± 1.7% | 807.3 ± 2.1% | 4.379 | 9.670 | 73.767 | 6.072 | 41.400 |
| hex: silesia/reymont | 524290 | 33263.0 ± 0.4% | 7604.1 ± 0.5% | 3414.1 ± 3.9% | 486.7 ± 0.5% | 5533.9 ± 0.3% | 813.7 ± 1.9% | 4.374 | 9.743 | 68.342 | 6.011 | 40.878 |
| hex: silesia/samba | 524290 | 33561.0 ± 0.2% | 7643.0 ± 0.5% | 3441.5 ± 0.4% | 363.0 ± 0.2% | 5523.7 ± 1.2% | 814.8 ± 1.3% | 4.391 | 9.752 | 92.459 | 6.076 | 41.191 |
| hex: silesia/sao | 524290 | 33229.1 ± 0.6% | 7618.0 ± 0.8% | 3425.5 ± 0.4% | 289.3 ± 0.2% | 5504.6 ± 1.3% | 807.8 ± 1.4% | 4.362 | 9.701 | 114.870 | 6.037 | 41.137 |
| hex: silesia/webster | 524290 | 33351.7 ± 2.0% | 7601.2 ± 0.4% | 3434.2 ± 0.7% | 435.6 ± 1.0% | 5527.4 ± 5.5% | 801.8 ± 2.3% | 4.388 | 9.712 | 76.569 | 6.034 | 41.595 |
| hex: silesia/x-ray | 524290 | 33399.0 ± 0.4% | 7614.0 ± 2.6% | 3424.1 ± 4.8% | 435.8 ± 0.6% | 5506.4 ± 0.5% | 809.5 ± 1.3% | 4.387 | 9.754 | 76.646 | 6.066 | 41.258 |
| hex: silesia/xml | 524290 | 33362.3 ± 0.3% | 7642.6 ± 0.6% | 3435.1 ± 0.3% | 603.4 ± 0.4% | 5526.1 ± 0.5% | 813.0 ± 1.8% | 4.365 | 9.712 | 55.286 | 6.037 | 41.035 |
| hex: canterbury/alice29.txt | 304180 | 33801.9 ± 0.1% | 7658.6 ± 2.3% | 3556.7 ± 0.6% | 470.5 ± 0.8% | 5515.8 ± 3.3% | 808.0 ± 0.9% | 4.414 | 9.504 | 71.835 | 6.128 | 41.834 |
| hex: canterbury/asyoulik.txt | 250360 | 33530.7 ± 0.6% | 7723.8 ± 3.1% | 3552.8 ± 0.4% | 461.6 ± 0.4% | 5523.2 ± 1.1% | 808.4 ± 1.6% | 4.341 | 9.438 | 72.641 | 6.071 | 41.480 |
| hex: canterbury/cp.html | 49208 | 32767.2 ± 0.1% | 7783.8 ± 0.1% | 3607.2 ± 1.3% | 462.7 ± 0.3% | 5485.9 ± 0.6% | 800.6 ± 1.1% | 4.210 | 9.084 | 70.816 | 5.973 | 40.930 |
| hex: canterbury/fields.c | 22302 | 31688.4 ± 0.3% | 7700.9 ± 0.2% | 3609.5 ± 0.2% | 487.7 ± 0.3% | 5460.6 ± 0.7% | 793.6 ± 3.8% | 4.115 | 8.779 | 64.969 | 5.803 | 39.927 |
| hex: canterbury/grammar.lsp | 7444 | 27424.4 ± 0.4% | 7489.9 ± 0.6% | 3557.0 ± 2.4% | 538.1 ± 0.3% | 5378.5 ± 6.6% | 761.8 ± 4.0% | 3.662 | 7.710 | 50.968 | 5.099 | 35.999 |
| hex: canterbury/kennedy.xls | 524290 | 33561.3 ± 0.4% | 7627.7 ± 0.5% | 3434.3 ± 0.4% | 685.3 ± 0.5% | 5513.4 ± 0.5% | 815.9 ± 6.4% | 4.400 | 9.772 | 48.972 | 6.087 | 41.135 |
| hex: canterbury/lcet10.txt | 524290 | 33253.8 ± 0.7% | 7636.5 ± 0.7% | 3457.1 ± 0.4% | 473.3 ± 0.3% | 5530.0 ± 0.9% | 816.0 ± 2.7% | 4.355 | 9.619 | 70.260 | 6.013 | 40.751 |
| hex: canterbury/plrabn12.txt | 524290 | 33459.2 ± 0.4% | 7640.6 ± 1.0% | 3451.3 ± 0.9% | 460.1 ± 8.0% | 5518.4 ± 0.1% | 821.1 ± 0.5% | 4.379 | 9.695 | 72.721 | 6.063 | 40.748 |
| hex: canterbury/ptt5 | 524290 | 33285.0 ± 2.3% | 7628.6 ± 0.8% | 3467.5 ± 0.3% | 558.2 ± 11.7% | 5529.9 ± 0.2% | 819.4 ± 1.3% | 4.363 | 9.599 | 59.632 | 6.019 | 40.620 |
| hex: canterbury/sum | 76482 | 33268.0 ± 0.8% | 7806.9 ± 0.2% | 3624.5 ± 0.4% | 528.5 ± 10.2% | 5503.8 ± 0.2% | 823.9 ± 2.5% | 4.261 | 9.179 | 62.943 | 6.045 | 40.377 |
| hex: canterbury/xargs.1 | 8456 | 28245.1 ± 0.3% | 7523.1 ± 0.1% | 3550.6 ± 0.6% | 525.9 ± 1.9% | 5353.3 ± 1.4% | 796.4 ± 4.6% | 3.754 | 7.955 | 53.708 | 5.276 | 35.466 |
| hex: canterbury-large/E.coli | 524290 | 33153.5 ± 0.3% | 7616.5 ± 0.5% | 3445.3 ± 0.4% | 710.1 ± 9.3% | 5506.4 ± 0.6% | 814.5 ± 5.7% | 4.353 | 9.623 | 46.690 | 6.021 | 40.702 |
| hex: canterbury-large/bible.txt | 524290 | 33122.5 ± 0.7% | 7646.5 ± 0.6% | 3436.9 ± 0.7% | 488.2 ± 1.4% | 5503.2 ± 5.4% | 817.6 ± 1.9% | 4.332 | 9.637 | 67.852 | 6.019 | 40.511 |
| hex: canterbury-large/world192.txt | 524290 | 33253.6 ± 0.8% | 7641.5 ± 0.9% | 3444.3 ± 0.7% | 454.6 ± 0.9% | 5520.6 ± 0.3% | 818.9 ± 3.1% | 4.352 | 9.655 | 73.154 | 6.024 | 40.610 |
| hex: http/html-1kx1024 | 2099200 | 16668.1 ± 1.4% | 6612.4 ± 0.5% | 3232.5 ± 0.6% | 487.1 ± 0.5% | 4703.9 ± 0.6% | 720.8 ± 2.8% | 2.521 | 5.156 | 34.222 | 3.543 | 23.125 |
| hex: http/html-16kx64 | 2097280 | 30357.2 ± 1.6% | 7660.9 ± 0.4% | 3501.9 ± 0.3% | 495.6 ± 0.3% | 5419.6 ± 0.5% | 803.1 ± 1.8% | 3.963 | 8.669 | 61.258 | 5.601 | 37.800 |
| hex: http/html-1m | 524290 | 33370.3 ± 6.7% | 7626.3 ± 0.5% | 3450.2 ± 0.5% | 492.9 ± 0.2% | 5520.7 ± 0.7% | 816.2 ± 2.3% | 4.376 | 9.672 | 67.706 | 6.045 | 40.887 |
| hex: http/json-1kx1024 | 2099200 | 16761.9 ± 0.7% | 6594.2 ± 0.4% | 3232.7 ± 1.9% | 618.0 ± 12.4% | 4704.4 ± 3.5% | 727.1 ± 3.5% | 2.542 | 5.185 | 27.123 | 3.563 | 23.052 |
| hex: http/json-16kx64 | 2097280 | 30481.6 ± 1.0% | 7638.6 ± 7.1% | 3479.3 ± 1.0% | 632.0 ± 1.9% | 5418.7 ± 16.6% | 795.6 ± 4.4% | 3.990 | 8.761 | 48.227 | 5.625 | 38.313 |
| hex: http/json-1m | 524290 | 33409.3 ± 1.0% | 7565.7 ± 1.3% | 3439.2 ± 7.3% | 642.9 ± 0.4% | 5533.8 ± 0.3% | 801.5 ± 3.7% | 4.416 | 9.714 | 51.968 | 6.037 | 41.686 |
| hex: http/js-1kx1024 | 2099200 | 16772.4 ± 0.7% | 6590.5 ± 4.2% | 3223.5 ± 0.1% | 472.5 ± 0.6% | 4719.1 ± 0.8% | 710.0 ± 3.7% | 2.545 | 5.203 | 35.496 | 3.554 | 23.624 |
| hex: http/js-16kx64 | 2097280 | 30801.2 ± 3.1% | 7664.0 ± 4.4% | 3475.8 ± 29.1% | 478.6 ± 25.3% | 5429.7 ± 62.3% | 793.1 ± 13.2% | 4.019 | 8.862 | 64.363 | 5.673 | 38.836 |
| hex: http/js-1m | 524290 | 33447.2 ± 0.7% | 7641.1 ± 0.4% | 3439.1 ± 0.2% | 494.4 ± 0.5% | 5544.1 ± 0.3% | 813.7 ± 6.0% | 4.377 | 9.726 | 67.647 | 6.033 | 41.106 |
| hex: http/css-1kx1024 | 2099200 | 16754.7 ± 0.6% | 6588.2 ± 0.2% | 3223.5 ± 1.1% | 538.4 ± 0.5% | 4712.9 ± 1.0% | 711.9 ± 5.4% | 2.543 | 5.198 | 31.119 | 3.555 | 23.534 |
| hex: http/css-16kx64 | 2097280 | 30480.0 ± 0.3% | 7651.9 ± 0.3% | 3496.4 ± 1.3% | 548.5 ± 0.3% | 5429.7 ± 1.0% | 792.6 ± 7.2% | 3.983 | 8.717 | 55.566 | 5.614 | 38.455 |
| hex: http/css-1m | 524290 | 33169.0 ± 12.8% | 7642.3 ± 0.8% | 3430.6 ± 0.7% | 532.3 ± 0.4% | 5515.4 ± 0.1% | 776.8 ± 8.3% | 4.340 | 9.669 | 62.307 | 6.014 | 42.701 |
| hex: shuffled/dickens-1m | 524290 | 33274.7 ± 3.6% | 7646.4 ± 2.1% | 3437.4 ± 3.2% | 470.7 ± 1.0% | 5535.6 ± 0.3% | 802.0 ± 2.1% | 4.352 | 9.680 | 70.696 | 6.011 | 41.489 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1127.4 ± 0.8% | 1128.7 ± 1.3% | 893.5 ± 2.0% | 328.7 ± 1.1% | 366.9 ± 3.3% | 310.6 ± 3.0% | 0.999 | 1.262 | 3.430 | 3.073 | 3.630 |
| qlog records, JSON text sequence | 1467503 | 974.5 ± 0.9% | 857.4 ± 1.2% | 726.3 ± 0.9% | 318.2 ± 1.7% | 390.4 ± 0.7% | 226.2 ± 3.1% | 1.137 | 1.342 | 3.063 | 2.496 | 4.308 |
| string: silesia/dickens | 172528 | 9261.8 ± 1.0% | 2946.7 ± 1.7% | 2019.3 ± 0.3% | 357.3 ± 0.3% | 1409.3 ± 2.3% | 559.9 ± 3.9% | 3.143 | 4.587 | 25.920 | 6.572 | 16.542 |
| string: silesia/nci | 1075110 | 8710.0 ± 9.2% | 3162.6 ± 23.3% | 2776.3 ± 23.8% | 775.4 ± 11.8% | 1538.5 ± 0.5% | 562.3 ± 7.7% | 2.754 | 3.137 | 11.234 | 5.661 | 15.491 |
| string: silesia/reymont | 1075159 | 3857.3 ± 1.2% | 1653.8 ± 0.4% | 1721.3 ± 0.3% | 360.3 ± 0.6% | 1253.3 ± 0.5% | 548.4 ± 2.2% | 2.332 | 2.241 | 10.707 | 3.078 | 7.034 |
| string: silesia/samba | 97582 | 4603.1 ± 2.4% | 1980.0 ± 0.6% | 2151.4 ± 0.3% | 299.3 ± 0.4% | 1039.7 ± 0.3% | 620.4 ± 1.5% | 2.325 | 2.140 | 15.380 | 4.427 | 7.420 |
| string: silesia/webster | 1098490 | 5093.5 ± 2.6% | 1628.7 ± 1.5% | 1512.4 ± 0.8% | 353.7 ± 0.5% | 1196.9 ± 1.4% | 454.1 ± 0.9% | 3.127 | 3.368 | 14.401 | 4.256 | 11.217 |
| string: silesia/xml | 1090118 | 8174.7 ± 1.4% | 2664.5 ± 0.9% | 2170.2 ± 0.9% | 547.9 ± 0.5% | 1583.3 ± 0.4% | 562.2 ± 0.4% | 3.068 | 3.767 | 14.921 | 5.163 | 14.540 |
| string: canterbury/alice29.txt | 159425 | 10017.9 ± 12.6% | 2466.1 ± 1.7% | 1797.6 ± 0.3% | 335.7 ± 0.5% | 1261.7 ± 0.6% | 557.4 ± 1.6% | 4.062 | 5.573 | 29.837 | 7.940 | 17.973 |
| string: canterbury/asyoulik.txt | 132198 | 8285.6 ± 0.8% | 2205.1 ± 1.4% | 1539.9 ± 0.8% | 343.7 ± 5.0% | 1115.5 ± 10.7% | 543.9 ± 1.2% | 3.757 | 5.381 | 24.105 | 7.427 | 15.235 |
| string: canterbury/lcet10.txt | 441884 | 9153.6 ± 2.6% | 2474.9 ± 0.5% | 1963.8 ± 0.2% | 389.8 ± 1.3% | 1384.7 ± 3.9% | 551.4 ± 0.8% | 3.699 | 4.661 | 23.484 | 6.610 | 16.600 |
| string: canterbury/plrabn12.txt | 503330 | 6133.1 ± 0.4% | 1831.0 ± 5.8% | 1661.3 ± 0.4% | 363.0 ± 0.6% | 1295.3 ± 0.1% | 558.4 ± 0.8% | 3.350 | 3.692 | 16.893 | 4.735 | 10.984 |
| string: canterbury-large/E.coli | 1048578 | 29162.3 ± 2.1% | 10291.4 ± 0.9% | 3381.9 ± 0.2% | 1402.4 ± 0.5% | 2504.0 ± 1.3% | 575.8 ± 0.8% | 2.834 | 8.623 | 20.794 | 11.646 | 50.647 |
| string: canterbury-large/bible.txt | 1055886 | 7009.0 ± 1.1% | 3920.5 ± 1.9% | 2658.8 ± 0.5% | 433.6 ± 0.1% | 1873.4 ± 0.5% | 566.2 ± 1.0% | 1.788 | 2.636 | 16.163 | 3.741 | 12.379 |
| string: canterbury-large/world192.txt | 1103121 | 5017.2 ± 6.3% | 1440.6 ± 0.7% | 1547.3 ± 2.8% | 368.0 ± 0.8% | 1171.5 ± 17.4% | 539.2 ± 0.8% | 3.483 | 3.243 | 13.635 | 4.283 | 9.304 |
| string: http/html-1m | 1058582 | 8674.3 ± 1.1% | 3829.9 ± 10.9% | 2471.5 ± 1.4% | 397.5 ± 11.1% | 1811.4 ± 3.3% | 522.2 ± 0.5% | 2.265 | 3.510 | 21.822 | 4.789 | 16.612 |
| string: http/json-1m | 1190272 | 6614.7 ± 0.3% | 1226.6 ± 0.4% | 1268.3 ± 0.6% | 373.5 ± 0.7% | 891.1 ± 0.9% | 508.0 ± 1.7% | 5.393 | 5.215 | 17.709 | 7.423 | 13.020 |
| string: http/js-1m | 1144362 | 5139.2 ± 2.0% | 993.4 ± 0.2% | 1088.2 ± 0.5% | 282.3 ± 0.7% | 924.9 ± 0.9% | 479.9 ± 1.7% | 5.173 | 4.723 | 18.202 | 5.557 | 10.709 |
| string: http/css-1m | 1097820 | 6881.0 ± 9.6% | 1287.6 ± 0.6% | 1600.0 ± 0.5% | 402.4 ± 29.3% | 1047.5 ± 15.5% | 536.0 ± 1.2% | 5.344 | 4.301 | 17.100 | 6.569 | 12.837 |
| string: dickens as Cyrillic and CJK | 1883069 | 5323.9 ± 1.5% | 3044.5 ± 0.3% | 342.6 ± 5.2% | 268.8 ± 9.8% | 463.9 ± 4.4% | 293.0 ± 17.6% | 1.749 | 15.540 | 19.808 | 11.477 | 18.169 |
| hex: silesia/dickens | 524290 | 31491.7 ± 1.0% | 1549.6 ± 0.6% | 1085.4 ± 0.5% | 421.2 ± 4.4% | 1055.0 ± 0.8% | 451.0 ± 0.6% | 20.322 | 29.013 | 74.759 | 29.850 | 69.833 |
| hex: silesia/mozilla | 524290 | 35514.0 ± 1.9% | 1546.6 ± 1.3% | 1084.1 ± 0.4% | 369.6 ± 6.0% | 1053.9 ± 0.5% | 451.4 ± 0.7% | 22.962 | 32.760 | 96.081 | 33.698 | 78.684 |
| hex: silesia/mr | 524290 | 33143.0 ± 0.9% | 1545.2 ± 0.4% | 1083.7 ± 0.3% | 511.8 ± 0.3% | 1056.7 ± 12.5% | 450.6 ± 1.0% | 21.449 | 30.583 | 64.757 | 31.366 | 73.545 |
| hex: silesia/nci | 524290 | 33133.1 ± 0.5% | 1542.7 ± 0.9% | 1084.6 ± 1.5% | 558.0 ± 0.6% | 1054.3 ± 0.3% | 450.7 ± 0.4% | 21.477 | 30.549 | 59.373 | 31.426 | 73.514 |
| hex: silesia/ooffice | 524290 | 33421.9 ± 0.6% | 1544.7 ± 0.5% | 1082.1 ± 0.2% | 328.3 ± 1.5% | 1059.6 ± 0.5% | 448.8 ± 2.1% | 21.636 | 30.885 | 101.813 | 31.542 | 74.475 |
| hex: silesia/osdb | 524290 | 35082.3 ± 0.2% | 1547.0 ± 7.4% | 1084.5 ± 0.5% | 414.7 ± 1.3% | 1056.4 ± 0.6% | 451.0 ± 0.9% | 22.678 | 32.348 | 84.606 | 33.210 | 77.794 |
| hex: silesia/reymont | 524290 | 34250.1 ± 1.4% | 1548.8 ± 0.4% | 1085.1 ± 12.3% | 438.0 ± 0.3% | 1057.8 ± 1.7% | 450.6 ± 0.5% | 22.114 | 31.565 | 78.196 | 32.377 | 76.006 |
| hex: silesia/samba | 524290 | 34246.0 ± 1.1% | 1548.9 ± 1.0% | 1084.7 ± 0.5% | 333.3 ± 0.1% | 1058.0 ± 0.3% | 450.0 ± 1.0% | 22.111 | 31.573 | 102.763 | 32.369 | 76.106 |
| hex: silesia/sao | 524290 | 34661.1 ± 1.7% | 1545.1 ± 0.7% | 1083.7 ± 0.6% | 266.6 ± 7.2% | 1058.9 ± 0.3% | 450.6 ± 0.2% | 22.433 | 31.985 | 130.011 | 32.732 | 76.919 |
| hex: silesia/webster | 524290 | 36559.6 ± 0.4% | 1544.3 ± 0.9% | 1085.4 ± 1.3% | 389.4 ± 0.6% | 1056.3 ± 0.6% | 449.4 ± 0.8% | 23.675 | 33.683 | 93.883 | 34.609 | 81.346 |
| hex: silesia/x-ray | 524290 | 33661.1 ± 0.7% | 1550.1 ± 1.0% | 1087.5 ± 1.6% | 393.9 ± 0.2% | 1059.4 ± 0.7% | 450.6 ± 0.8% | 21.716 | 30.954 | 85.448 | 31.774 | 74.706 |
| hex: silesia/xml | 524290 | 33211.2 ± 0.5% | 1545.3 ± 0.6% | 1082.4 ± 9.6% | 586.7 ± 0.5% | 1056.9 ± 2.3% | 450.1 ± 1.2% | 21.491 | 30.682 | 56.602 | 31.424 | 73.784 |
| hex: canterbury/alice29.txt | 304180 | 33397.1 ± 0.2% | 1579.0 ± 0.9% | 1094.7 ± 0.3% | 430.3 ± 0.2% | 1072.3 ± 1.0% | 452.6 ± 0.3% | 21.151 | 30.509 | 77.608 | 31.144 | 73.797 |
| hex: canterbury/asyoulik.txt | 250360 | 31993.9 ± 0.1% | 1588.6 ± 1.9% | 1101.8 ± 0.7% | 426.5 ± 0.2% | 1079.8 ± 0.6% | 454.4 ± 0.3% | 20.139 | 29.038 | 75.010 | 29.628 | 70.403 |
| hex: canterbury/cp.html | 49208 | 32000.5 ± 0.3% | 1621.1 ± 1.6% | 1112.5 ± 0.4% | 457.8 ± 0.2% | 1077.9 ± 0.4% | 456.3 ± 0.3% | 19.740 | 28.765 | 69.899 | 29.688 | 70.132 |
| hex: canterbury/fields.c | 22302 | 32704.3 ± 0.1% | 1600.7 ± 0.5% | 1101.8 ± 0.2% | 547.6 ± 0.7% | 1067.1 ± 1.3% | 453.6 ± 1.2% | 20.431 | 29.683 | 59.719 | 30.649 | 72.100 |
| hex: canterbury/grammar.lsp | 7444 | 34241.5 ± 0.7% | 1634.9 ± 9.2% | 1115.2 ± 2.5% | 584.2 ± 0.6% | 1086.2 ± 1.0% | 460.8 ± 0.8% | 20.944 | 30.704 | 58.614 | 31.525 | 74.316 |
| hex: canterbury/kennedy.xls | 524290 | 31703.3 ± 1.1% | 1547.4 ± 0.4% | 1084.6 ± 1.6% | 595.4 ± 0.2% | 1054.7 ± 0.4% | 451.4 ± 0.3% | 20.488 | 29.229 | 53.246 | 30.060 | 70.238 |
| hex: canterbury/lcet10.txt | 524290 | 34642.5 ± 1.2% | 1545.2 ± 0.9% | 1084.8 ± 0.6% | 422.5 ± 0.2% | 1056.6 ± 0.8% | 450.2 ± 0.5% | 22.419 | 31.933 | 81.990 | 32.788 | 76.957 |
| hex: canterbury/plrabn12.txt | 524290 | 33559.3 ± 0.5% | 1551.4 ± 0.6% | 1085.3 ± 0.3% | 421.8 ± 0.2% | 1058.1 ± 0.4% | 449.1 ± 1.4% | 21.631 | 30.923 | 79.558 | 31.715 | 74.724 |
| hex: canterbury/ptt5 | 524290 | 33253.6 ± 0.4% | 1543.5 ± 0.7% | 1085.9 ± 12.7% | 503.5 ± 0.3% | 1054.5 ± 0.7% | 451.6 ± 0.4% | 21.544 | 30.623 | 66.047 | 31.536 | 73.643 |
| hex: canterbury/sum | 76482 | 35635.4 ± 0.2% | 1617.1 ± 17.2% | 1105.5 ± 0.2% | 509.3 ± 0.9% | 1074.5 ± 0.3% | 458.5 ± 0.2% | 22.037 | 32.235 | 69.964 | 33.164 | 77.720 |
| hex: canterbury/xargs.1 | 8456 | 35605.6 ± 0.4% | 1631.7 ± 0.8% | 1112.7 ± 0.1% | 618.4 ± 0.3% | 1090.9 ± 0.7% | 460.9 ± 0.8% | 21.821 | 32.000 | 57.581 | 32.639 | 77.245 |
| hex: canterbury-large/E.coli | 524290 | 30788.2 ± 0.9% | 1547.4 ± 0.4% | 1085.8 ± 0.3% | 607.8 ± 0.1% | 1052.0 ± 0.3% | 452.1 ± 3.6% | 19.897 | 28.356 | 50.657 | 29.266 | 68.093 |
| hex: canterbury-large/bible.txt | 524290 | 35657.6 ± 0.6% | 1552.1 ± 9.9% | 1086.2 ± 0.1% | 436.0 ± 0.2% | 1056.6 ± 12.5% | 450.1 ± 1.6% | 22.974 | 32.828 | 81.776 | 33.747 | 79.217 |
| hex: canterbury-large/world192.txt | 524290 | 34963.7 ± 2.0% | 1549.7 ± 1.1% | 1084.9 ± 1.6% | 422.8 ± 0.7% | 1058.9 ± 0.6% | 450.6 ± 0.6% | 22.562 | 32.229 | 82.691 | 33.019 | 77.602 |
| hex: http/html-1kx1024 | 2099200 | 24717.0 ± 0.4% | 1606.3 ± 0.6% | 1087.5 ± 1.1% | 448.3 ± 0.5% | 1066.5 ± 0.9% | 451.3 ± 0.9% | 15.388 | 22.729 | 55.130 | 23.175 | 54.773 |
| hex: http/html-16kx64 | 2097280 | 30269.5 ± 0.3% | 1608.2 ± 1.0% | 1103.8 ± 0.3% | 444.1 ± 0.3% | 1026.2 ± 0.7% | 456.0 ± 0.2% | 18.822 | 27.422 | 68.151 | 29.495 | 66.379 |
| hex: http/html-1m | 524290 | 29249.8 ± 0.5% | 1551.4 ± 0.5% | 1084.4 ± 1.6% | 446.6 ± 0.4% | 1055.6 ± 11.1% | 450.3 ± 0.3% | 18.853 | 26.974 | 65.498 | 27.709 | 64.962 |
| hex: http/json-1kx1024 | 2099200 | 25172.0 ± 5.9% | 1611.1 ± 0.3% | 1090.4 ± 2.1% | 564.1 ± 0.3% | 1071.3 ± 1.1% | 451.2 ± 0.9% | 15.624 | 23.084 | 44.623 | 23.496 | 55.786 |
| hex: http/json-16kx64 | 2097280 | 30182.5 ± 0.5% | 1606.1 ± 1.0% | 1103.1 ± 0.1% | 566.9 ± 7.1% | 1051.4 ± 0.6% | 455.8 ± 0.3% | 18.793 | 27.361 | 53.237 | 28.708 | 66.224 |
| hex: http/json-1m | 524290 | 31950.4 ± 0.5% | 1550.8 ± 0.6% | 1085.3 ± 0.2% | 587.7 ± 0.4% | 1051.4 ± 0.6% | 450.1 ± 0.3% | 20.603 | 29.439 | 54.365 | 30.388 | 70.987 |
| hex: http/js-1kx1024 | 2099200 | 25219.9 ± 9.2% | 1609.8 ± 0.7% | 1090.2 ± 0.6% | 437.3 ± 0.8% | 1075.2 ± 0.6% | 451.5 ± 9.4% | 15.667 | 23.134 | 57.671 | 23.456 | 55.861 |
| hex: http/js-16kx64 | 2097280 | 30186.3 ± 0.5% | 1610.7 ± 10.7% | 1105.1 ± 0.2% | 428.0 ± 0.2% | 1003.7 ± 0.7% | 456.5 ± 1.9% | 18.741 | 27.315 | 70.523 | 30.074 | 66.129 |
| hex: http/js-1m | 524290 | 30693.1 ± 0.2% | 1553.0 ± 0.5% | 1087.0 ± 0.4% | 434.7 ± 8.5% | 1051.9 ± 2.5% | 450.6 ± 0.5% | 19.764 | 28.237 | 70.613 | 29.178 | 68.115 |
| hex: http/css-1kx1024 | 2099200 | 24555.8 ± 1.0% | 1607.6 ± 0.6% | 1088.4 ± 0.7% | 496.2 ± 0.6% | 1068.7 ± 0.7% | 450.9 ± 1.6% | 15.275 | 22.562 | 49.488 | 22.977 | 54.455 |
| hex: http/css-16kx64 | 2097280 | 30244.0 ± 0.5% | 1609.3 ± 0.6% | 1104.0 ± 3.6% | 498.7 ± 7.7% | 1057.6 ± 0.3% | 453.9 ± 0.3% | 18.793 | 27.394 | 60.644 | 28.598 | 66.626 |
| hex: http/css-1m | 524290 | 31482.6 ± 0.5% | 1547.7 ± 3.3% | 1085.1 ± 0.1% | 448.6 ± 0.4% | 1035.0 ± 6.7% | 450.2 ± 0.4% | 20.342 | 29.014 | 70.176 | 30.419 | 69.924 |
| hex: shuffled/dickens-1m | 524290 | 34796.7 ± 4.0% | 1549.7 ± 1.5% | 1086.8 ± 1.0% | 430.9 ± 0.3% | 1051.1 ± 0.2% | 449.8 ± 0.7% | 22.453 | 32.019 | 80.759 | 33.106 | 77.359 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.829 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.865 of yyjson.
