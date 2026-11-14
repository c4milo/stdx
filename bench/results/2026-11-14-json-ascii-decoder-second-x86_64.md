# bench-json

| Field | Value |
|---|---|
| Commit | 862cb69 |
| Runner label | ubuntu-24.04 |
| Image version | 20261111.127.1 |
| CPU model | Intel(R) Xeon(R) 6975P-C |
| Virtual CPUs | 4 |
| Kernel | 7.0.0-1014-aws |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/43625753773 |
| Date | 2026-11-14 |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1. The `TextReader.next_items` column is that helper's queued tokens a slice a call (decision 79), over many tokens a call.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | TextReader.next_items | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1380.0 ± 0.2% | 0.490 | 1.026 | 1.063 | 1.067 | 0.409 | 1.071 | 1.069 | 0.369 | 0.829 | 0.945 | 0.105 |
| qlog records, JSON text sequence | 1467503 | 1089.5 ± 0.5% | 0.801 | 1.071 | 1.074 | 1.074 | 0.395 | 1.073 | 1.073 | 0.370 | 0.935 | 1.084 | 0.126 |
| string: silesia/dickens | 172528 | 6623.9 ± 3.3% | 0.029 | 0.705 | 1.117 | 1.115 | 0.199 | 1.047 | 1.127 | 0.199 | 0.985 | 0.988 | 0.029 |
| string: silesia/nci | 1075110 | 5401.4 ± 0.7% | 0.036 | 0.712 | 1.038 | 1.037 | 0.287 | 1.042 | 1.037 | 0.288 | 1.007 | 1.010 | 0.036 |
| string: silesia/reymont | 1075159 | 3542.4 ± 0.6% | 0.055 | 0.624 | 0.873 | 0.867 | 0.343 | 0.818 | 0.868 | 0.343 | 0.991 | 0.998 | 0.055 |
| string: silesia/samba | 97582 | 4005.9 ± 1.2% | 0.041 | 0.899 | 1.059 | 1.062 | 0.074 | 0.849 | 1.058 | 0.074 | 0.995 | 1.006 | 0.041 |
| string: silesia/webster | 1098490 | 4394.3 ± 1.5% | 0.043 | 0.649 | 0.979 | 0.986 | 0.211 | 0.928 | 0.994 | 0.212 | 1.005 | 1.009 | 0.043 |
| string: silesia/xml | 1090118 | 6034.6 ± 0.6% | 0.032 | 0.776 | 0.953 | 0.959 | 0.243 | 0.951 | 0.965 | 0.244 | 1.004 | 1.011 | 0.032 |
| string: canterbury/alice29.txt | 159425 | 5738.4 ± 0.9% | 0.033 | 0.749 | 1.084 | 1.122 | 0.173 | 1.016 | 1.161 | 0.172 | 1.000 | 1.003 | 0.033 |
| string: canterbury/asyoulik.txt | 132198 | 4273.2 ± 0.7% | 0.042 | 0.810 | 1.135 | 1.127 | 0.189 | 1.063 | 1.139 | 0.189 | 0.998 | 1.006 | 0.042 |
| string: canterbury/lcet10.txt | 441884 | 6648.4 ± 0.6% | 0.029 | 0.607 | 1.096 | 1.106 | 0.189 | 1.038 | 1.116 | 0.189 | 0.998 | 1.004 | 0.029 |
| string: canterbury/plrabn12.txt | 503330 | 5442.2 ± 0.5% | 0.035 | 0.769 | 0.971 | 0.977 | 0.212 | 0.870 | 0.975 | 0.213 | 1.000 | 1.001 | 0.035 |
| string: canterbury-large/E.coli | 1048578 | 30205.8 ± 0.7% | 0.059 | 1.004 | 0.771 | 1.006 | 0.528 | 1.003 | 1.006 | 0.528 | 1.123 | 1.124 | 0.007 |
| string: canterbury-large/bible.txt | 1055886 | 8447.2 ± 2.0% | 0.024 | 0.628 | 0.882 | 0.885 | 0.387 | 0.894 | 0.903 | 0.386 | 1.012 | 1.017 | 0.024 |
| string: canterbury-large/world192.txt | 1103121 | 4131.1 ± 0.7% | 0.046 | 0.691 | 0.974 | 0.981 | 0.204 | 0.930 | 0.989 | 0.204 | 1.000 | 1.008 | 0.046 |
| string: http/html-1m | 1058582 | 9113.6 ± 1.7% | 0.022 | 0.557 | 0.779 | 0.782 | 0.311 | 0.748 | 0.788 | 0.311 | 0.963 | 1.045 | 0.022 |
| string: http/json-1m | 1190272 | 3313.8 ± 1.3% | 0.053 | 0.394 | 0.441 | 0.441 | 0.143 | 0.456 | 0.442 | 0.142 | 0.999 | 0.999 | 0.053 |
| string: http/js-1m | 1144362 | 2857.8 ± 1.5% | 0.062 | 0.696 | 0.893 | 0.919 | 0.184 | 0.845 | 0.920 | 0.184 | 1.011 | 1.011 | 0.062 |
| string: http/css-1m | 1097820 | 3278.4 ± 0.5% | 0.055 | 0.767 | 0.945 | 0.981 | 0.279 | 0.964 | 0.981 | 0.280 | 1.007 | 1.009 | 0.055 |
| string: dickens as Cyrillic and CJK | 1883069 | 5748.6 ± 0.9% | 0.026 | 0.059 | 0.445 | 0.445 | 0.198 | 0.438 | 0.445 | 0.198 | 1.006 | 1.008 | 0.026 |
| string: dickens as Cyrillic and CJK, as \u escapes | 5075485 | 1189.4 ± 0.4% | 0.113 | 1.006 | 1.007 | 1.004 | 0.107 | 0.720 | 1.010 | 0.107 | 1.011 | 1.016 | 0.113 |
| hex: silesia/dickens | 524290 | 45182.5 ± 2.2% | 0.041 | 1.000 | 0.630 | 1.006 | 0.398 | 1.009 | 1.002 | 0.401 | 0.748 | 0.749 | 0.005 |
| hex: silesia/mozilla | 524290 | 45370.1 ± 1.4% | 0.040 | 1.000 | 0.630 | 1.000 | 0.393 | 0.995 | 0.997 | 0.394 | 0.745 | 0.746 | 0.005 |
| hex: silesia/mr | 524290 | 44198.9 ± 1.3% | 0.041 | 0.997 | 0.611 | 0.996 | 0.389 | 0.993 | 0.995 | 0.387 | 0.765 | 0.765 | 0.005 |
| hex: silesia/nci | 524290 | 45248.5 ± 2.0% | 0.041 | 0.999 | 0.631 | 1.001 | 0.401 | 0.999 | 1.001 | 0.401 | 0.752 | 0.752 | 0.005 |
| hex: silesia/ooffice | 524290 | 45393.2 ± 2.6% | 0.040 | 0.999 | 0.630 | 0.998 | 0.394 | 0.996 | 0.999 | 0.396 | 0.748 | 0.750 | 0.005 |
| hex: silesia/osdb | 524290 | 42854.1 ± 1.7% | 0.042 | 0.998 | 0.644 | 1.000 | 0.403 | 1.003 | 1.001 | 0.403 | 0.787 | 0.789 | 0.005 |
| hex: silesia/reymont | 524290 | 45250.0 ± 1.2% | 0.040 | 1.003 | 0.630 | 1.002 | 0.396 | 1.001 | 1.004 | 0.398 | 0.746 | 0.746 | 0.005 |
| hex: silesia/samba | 524290 | 46313.3 ± 1.5% | 0.039 | 1.001 | 0.615 | 1.004 | 0.387 | 0.999 | 0.999 | 0.387 | 0.730 | 0.729 | 0.005 |
| hex: silesia/sao | 524290 | 48124.1 ± 3.0% | 0.038 | 0.998 | 0.592 | 1.002 | 0.373 | 0.999 | 1.002 | 0.374 | 0.704 | 0.701 | 0.004 |
| hex: silesia/webster | 524290 | 46437.3 ± 1.1% | 0.039 | 1.000 | 0.607 | 1.000 | 0.388 | 1.000 | 1.000 | 0.390 | 0.731 | 0.731 | 0.005 |
| hex: silesia/x-ray | 524290 | 46006.4 ± 0.2% | 0.040 | 0.996 | 0.613 | 0.996 | 0.393 | 0.998 | 0.998 | 0.393 | 0.738 | 0.739 | 0.005 |
| hex: silesia/xml | 524290 | 45882.3 ± 1.9% | 0.040 | 0.997 | 0.625 | 0.997 | 0.394 | 0.997 | 0.998 | 0.395 | 0.739 | 0.740 | 0.005 |
| hex: canterbury/alice29.txt | 304180 | 45801.6 ± 0.4% | 0.040 | 0.999 | 0.626 | 1.001 | 0.393 | 1.000 | 1.000 | 0.393 | 0.740 | 0.738 | 0.005 |
| hex: canterbury/asyoulik.txt | 250360 | 45917.9 ± 0.2% | 0.040 | 0.998 | 0.611 | 0.997 | 0.392 | 0.997 | 0.997 | 0.392 | 0.738 | 0.739 | 0.005 |
| hex: canterbury/cp.html | 49208 | 46270.1 ± 1.0% | 0.040 | 0.998 | 0.600 | 1.001 | 0.381 | 1.000 | 1.004 | 0.385 | 0.722 | 0.721 | 0.005 |
| hex: canterbury/fields.c | 22302 | 49716.8 ± 1.9% | 0.037 | 1.038 | 0.552 | 1.010 | 0.398 | 0.994 | 1.008 | 0.407 | 0.659 | 0.660 | 0.004 |
| hex: canterbury/grammar.lsp | 7444 | 42950.5 ± 1.6% | 0.043 | 0.985 | 0.591 | 1.018 | 0.420 | 1.004 | 1.027 | 0.441 | 0.693 | 0.692 | 0.005 |
| hex: canterbury/kennedy.xls | 524290 | 45845.1 ± 2.1% | 0.040 | 1.004 | 0.619 | 1.005 | 0.390 | 1.004 | 0.999 | 0.392 | 0.738 | 0.737 | 0.005 |
| hex: canterbury/lcet10.txt | 524290 | 45069.5 ± 1.1% | 0.040 | 0.995 | 0.630 | 0.994 | 0.399 | 0.997 | 0.997 | 0.399 | 0.748 | 0.749 | 0.005 |
| hex: canterbury/plrabn12.txt | 524290 | 46613.7 ± 2.1% | 0.039 | 0.996 | 0.612 | 0.995 | 0.377 | 0.997 | 0.998 | 0.377 | 0.725 | 0.727 | 0.005 |
| hex: canterbury/ptt5 | 524290 | 46344.1 ± 0.3% | 0.039 | 1.001 | 0.607 | 1.000 | 0.388 | 1.000 | 0.999 | 0.389 | 0.732 | 0.732 | 0.005 |
| hex: canterbury/sum | 76482 | 45756.8 ± 0.6% | 0.040 | 1.006 | 0.606 | 1.002 | 0.387 | 1.002 | 0.999 | 0.390 | 0.727 | 0.728 | 0.005 |
| hex: canterbury/xargs.1 | 8456 | 44702.5 ± 1.2% | 0.041 | 0.982 | 0.578 | 1.016 | 0.415 | 0.986 | 1.011 | 0.434 | 0.678 | 0.676 | 0.005 |
| hex: canterbury-large/E.coli | 524290 | 44917.1 ± 1.5% | 0.041 | 1.005 | 0.633 | 1.005 | 0.400 | 1.001 | 1.010 | 0.400 | 0.752 | 0.751 | 0.005 |
| hex: canterbury-large/bible.txt | 524290 | 45635.9 ± 2.3% | 0.040 | 1.004 | 0.613 | 1.007 | 0.390 | 1.003 | 1.003 | 0.392 | 0.741 | 0.740 | 0.005 |
| hex: canterbury-large/world192.txt | 524290 | 45612.1 ± 3.4% | 0.040 | 0.996 | 0.629 | 0.997 | 0.396 | 0.997 | 0.996 | 0.395 | 0.742 | 0.745 | 0.005 |
| hex: http/html-1kx1024 | 2099200 | 17472.7 ± 1.8% | 0.103 | 1.032 | 0.813 | 1.001 | 0.589 | 1.007 | 1.002 | 0.648 | 0.866 | 0.846 | 0.012 |
| hex: http/html-16kx64 | 2097280 | 33791.1 ± 1.0% | 0.054 | 1.007 | 0.702 | 1.006 | 0.481 | 1.007 | 1.006 | 0.485 | 0.817 | 0.815 | 0.006 |
| hex: http/html-1m | 524290 | 45004.2 ± 1.6% | 0.040 | 0.998 | 0.636 | 1.002 | 0.398 | 1.003 | 0.999 | 0.397 | 0.749 | 0.750 | 0.005 |
| hex: http/json-1kx1024 | 2099200 | 17324.1 ± 0.5% | 0.104 | 1.041 | 0.814 | 1.005 | 0.612 | 1.009 | 1.006 | 0.671 | 0.867 | 0.847 | 0.012 |
| hex: http/json-16kx64 | 2097280 | 34277.6 ± 1.4% | 0.053 | 1.007 | 0.689 | 1.008 | 0.472 | 1.009 | 1.005 | 0.476 | 0.807 | 0.806 | 0.006 |
| hex: http/json-1m | 524290 | 46028.6 ± 1.8% | 0.040 | 1.000 | 0.620 | 1.001 | 0.392 | 0.999 | 1.000 | 0.393 | 0.738 | 0.738 | 0.005 |
| hex: http/js-1kx1024 | 2099200 | 17194.5 ± 0.9% | 0.105 | 1.047 | 0.816 | 1.002 | 0.613 | 1.005 | 0.999 | 0.673 | 0.874 | 0.854 | 0.012 |
| hex: http/js-16kx64 | 2097280 | 33260.8 ± 1.3% | 0.055 | 1.002 | 0.705 | 1.002 | 0.483 | 1.005 | 1.004 | 0.487 | 0.820 | 0.818 | 0.006 |
| hex: http/js-1m | 524290 | 47990.6 ± 1.0% | 0.038 | 1.000 | 0.593 | 1.003 | 0.376 | 1.004 | 1.002 | 0.376 | 0.706 | 0.704 | 0.004 |
| hex: http/css-1kx1024 | 2099200 | 17229.1 ± 1.6% | 0.104 | 1.056 | 0.823 | 1.012 | 0.603 | 1.006 | 1.009 | 0.660 | 0.876 | 0.852 | 0.012 |
| hex: http/css-16kx64 | 2097280 | 33508.8 ± 0.4% | 0.054 | 1.004 | 0.700 | 1.003 | 0.478 | 1.003 | 1.003 | 0.483 | 0.814 | 0.818 | 0.006 |
| hex: http/css-1m | 524290 | 45694.4 ± 3.7% | 0.040 | 0.999 | 0.610 | 0.998 | 0.390 | 0.999 | 0.994 | 0.391 | 0.743 | 0.738 | 0.005 |
| hex: shuffled/dickens-1m | 524290 | 47113.6 ± 2.5% | 0.039 | 0.995 | 0.606 | 0.996 | 0.380 | 0.992 | 0.998 | 0.382 | 0.716 | 0.716 | 0.004 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1736.2 ± 1.0% | 0.428 | 1.003 | 0.971 | 1.012 | 1.015 | 0.271 | 1.015 | 0.523 | 0.906 | 0.094 | 1.039 |
| qlog records, JSON text sequence | 1467503 | 1649.3 ± 3.0% | 0.639 | 0.959 | 0.983 | 1.008 | 0.987 | 0.236 | 0.989 | 0.450 | 0.874 | 0.106 | 1.040 |
| string: silesia/dickens | 172528 | 12047.8 ± 5.5% | 0.019 | 0.571 | 0.390 | 0.575 | 0.596 | 0.125 | 0.602 | 1.009 | 1.012 | 0.019 | 1.115 |
| string: silesia/nci | 1075110 | 10720.8 ± 0.9% | 0.021 | 0.552 | 0.395 | 0.563 | 0.552 | 0.190 | 0.549 | 1.001 | 1.006 | 0.021 | 1.071 |
| string: silesia/reymont | 1075159 | 5272.2 ± 1.9% | 0.043 | 0.582 | 0.439 | 0.576 | 0.585 | 0.271 | 0.580 | 1.000 | 1.005 | 0.043 | 1.032 |
| string: silesia/samba | 97582 | 6261.4 ± 1.1% | 0.045 | 0.901 | 0.745 | 0.905 | 0.902 | 0.117 | 0.900 | 0.999 | 1.004 | 0.040 | 1.166 |
| string: silesia/webster | 1098490 | 6589.4 ± 1.4% | 0.034 | 0.614 | 0.423 | 0.585 | 0.616 | 0.163 | 0.610 | 0.998 | 1.008 | 0.034 | 1.056 |
| string: silesia/xml | 1090118 | 9721.4 ± 1.1% | 0.024 | 0.616 | 0.510 | 0.613 | 0.620 | 0.219 | 0.619 | 1.004 | 1.012 | 0.023 | 1.158 |
| string: canterbury/alice29.txt | 159425 | 10758.2 ± 4.4% | 0.021 | 0.507 | 0.418 | 0.497 | 0.549 | 0.105 | 0.567 | 0.982 | 0.986 | 0.021 | 1.229 |
| string: canterbury/asyoulik.txt | 132198 | 10037.3 ± 1.9% | 0.021 | 0.430 | 0.360 | 0.425 | 0.446 | 0.093 | 0.456 | 1.007 | 1.032 | 0.021 | 1.142 |
| string: canterbury/lcet10.txt | 441884 | 10547.0 ± 1.2% | 0.021 | 0.650 | 0.389 | 0.643 | 0.654 | 0.136 | 0.657 | 1.001 | 1.007 | 0.021 | 1.198 |
| string: canterbury/plrabn12.txt | 503330 | 7985.7 ± 3.4% | 0.028 | 0.681 | 0.549 | 0.680 | 0.683 | 0.170 | 0.683 | 0.985 | 0.989 | 0.028 | 1.117 |
| string: canterbury-large/E.coli | 1048578 | 31285.0 ± 0.5% | 0.057 | 1.002 | 1.001 | 0.784 | 1.003 | 0.507 | 1.002 | 1.000 | 1.004 | 0.008 | 1.004 |
| string: canterbury-large/bible.txt | 1055886 | 8838.9 ± 0.5% | 0.027 | 0.808 | 0.620 | 0.807 | 0.811 | 0.414 | 0.817 | 0.998 | 1.002 | 0.027 | 1.106 |
| string: canterbury-large/world192.txt | 1103121 | 6355.9 ± 3.7% | 0.035 | 0.612 | 0.440 | 0.579 | 0.615 | 0.154 | 0.613 | 0.995 | 1.001 | 0.035 | 1.010 |
| string: http/html-1m | 1058582 | 9798.0 ± 3.4% | 0.024 | 0.654 | 0.542 | 0.654 | 0.660 | 0.317 | 0.660 | 1.000 | 1.008 | 0.024 | 1.034 |
| string: http/json-1m | 1190272 | 8435.3 ± 0.3% | 0.024 | 0.182 | 0.159 | 0.182 | 0.183 | 0.072 | 0.183 | 1.000 | 1.001 | 0.024 | 1.016 |
| string: http/js-1m | 1144362 | 6360.4 ± 0.6% | 0.033 | 0.379 | 0.323 | 0.369 | 0.380 | 0.093 | 0.380 | 0.994 | 1.000 | 0.033 | 1.042 |
| string: http/css-1m | 1097820 | 7925.3 ± 0.6% | 0.027 | 0.413 | 0.329 | 0.395 | 0.412 | 0.140 | 0.411 | 1.005 | 1.001 | 0.027 | 1.168 |
| string: dickens as Cyrillic and CJK | 1883069 | 5443.2 ± 1.4% | 0.030 | 0.463 | 0.064 | 0.460 | 0.462 | 0.206 | 0.462 | 1.000 | 1.005 | 0.030 | 1.045 |
| hex: silesia/dickens | 524290 | 42272.8 ± 0.5% | 0.998 | 0.091 | 0.999 | 0.605 | 0.984 | 0.990 | 0.984 | 0.987 | 0.988 | 0.095 | 0.990 |
| hex: silesia/mozilla | 524290 | 42883.4 ± 0.9% | 1.001 | 0.089 | 0.998 | 0.596 | 0.998 | 0.995 | 0.998 | 0.994 | 0.995 | 0.095 | 0.995 |
| hex: silesia/mr | 524290 | 42938.9 ± 4.2% | 1.004 | 0.089 | 1.004 | 0.596 | 0.994 | 0.997 | 0.996 | 0.996 | 0.996 | 0.095 | 0.996 |
| hex: silesia/nci | 524290 | 43604.9 ± 0.7% | 1.001 | 0.088 | 0.998 | 0.586 | 0.997 | 0.997 | 0.998 | 0.997 | 0.997 | 0.091 | 0.999 |
| hex: silesia/ooffice | 524290 | 42840.7 ± 1.8% | 1.001 | 0.089 | 1.004 | 0.595 | 1.000 | 0.998 | 1.001 | 0.999 | 0.998 | 0.093 | 0.998 |
| hex: silesia/osdb | 524290 | 41981.0 ± 1.1% | 0.999 | 0.091 | 0.991 | 0.606 | 0.985 | 0.989 | 0.999 | 0.995 | 0.997 | 0.095 | 0.998 |
| hex: silesia/reymont | 524290 | 43579.5 ± 0.4% | 1.000 | 0.088 | 1.002 | 0.589 | 1.000 | 0.998 | 0.999 | 0.997 | 0.996 | 0.092 | 0.999 |
| hex: silesia/samba | 524290 | 43397.8 ± 0.7% | 1.003 | 0.088 | 1.006 | 0.590 | 0.995 | 1.003 | 1.001 | 0.994 | 0.998 | 0.089 | 0.998 |
| hex: silesia/sao | 524290 | 43187.8 ± 2.2% | 1.001 | 0.089 | 1.001 | 0.591 | 0.997 | 1.000 | 0.998 | 0.999 | 1.000 | 0.093 | 0.999 |
| hex: silesia/webster | 524290 | 43714.8 ± 0.2% | 1.003 | 0.088 | 1.003 | 0.587 | 0.999 | 1.000 | 0.996 | 0.999 | 1.000 | 0.089 | 1.000 |
| hex: silesia/x-ray | 524290 | 43333.6 ± 0.8% | 1.001 | 0.088 | 1.002 | 0.569 | 0.997 | 0.991 | 0.997 | 0.998 | 0.996 | 0.091 | 1.002 |
| hex: silesia/xml | 524290 | 43451.5 ± 0.7% | 0.999 | 0.088 | 1.002 | 0.588 | 0.999 | 0.998 | 0.999 | 0.999 | 0.996 | 0.092 | 1.000 |
| hex: canterbury/alice29.txt | 304180 | 41328.1 ± 1.4% | 1.006 | 0.093 | 1.004 | 0.599 | 1.005 | 1.003 | 1.008 | 1.003 | 0.995 | 0.098 | 1.006 |
| hex: canterbury/asyoulik.txt | 250360 | 42919.3 ± 2.0% | 1.004 | 0.089 | 1.007 | 0.593 | 1.006 | 1.000 | 1.006 | 1.001 | 1.004 | 0.094 | 1.008 |
| hex: canterbury/cp.html | 49208 | 42223.8 ± 1.2% | 1.003 | 0.090 | 0.999 | 0.597 | 1.007 | 1.003 | 1.006 | 1.006 | 1.002 | 0.098 | 1.009 |
| hex: canterbury/fields.c | 22302 | 41292.5 ± 2.2% | 1.009 | 0.092 | 1.008 | 0.607 | 1.006 | 0.995 | 1.004 | 1.015 | 1.013 | 0.100 | 1.010 |
| hex: canterbury/grammar.lsp | 7444 | 38522.3 ± 1.3% | 0.996 | 0.097 | 0.999 | 0.618 | 1.003 | 0.973 | 1.000 | 1.012 | 1.039 | 0.105 | 1.011 |
| hex: canterbury/kennedy.xls | 524290 | 42792.6 ± 3.5% | 1.006 | 0.089 | 1.001 | 0.595 | 0.996 | 0.998 | 1.000 | 0.996 | 0.993 | 0.095 | 1.001 |
| hex: canterbury/lcet10.txt | 524290 | 43453.6 ± 0.4% | 1.001 | 0.089 | 1.000 | 0.594 | 0.981 | 0.985 | 0.981 | 0.985 | 0.976 | 0.095 | 0.982 |
| hex: canterbury/plrabn12.txt | 524290 | 43091.4 ± 0.9% | 1.003 | 0.089 | 1.008 | 0.595 | 1.000 | 1.001 | 1.002 | 0.993 | 0.997 | 0.095 | 1.002 |
| hex: canterbury/ptt5 | 524290 | 42796.4 ± 1.0% | 1.002 | 0.089 | 1.003 | 0.595 | 0.995 | 0.998 | 1.005 | 1.001 | 0.997 | 0.095 | 1.003 |
| hex: canterbury/sum | 76482 | 42228.5 ± 6.6% | 1.003 | 0.090 | 1.005 | 0.597 | 1.002 | 0.999 | 1.004 | 1.002 | 0.999 | 0.097 | 0.999 |
| hex: canterbury/xargs.1 | 8456 | 39429.9 ± 4.5% | 1.002 | 0.096 | 1.008 | 0.608 | 1.008 | 0.959 | 1.011 | 0.993 | 1.030 | 0.102 | 1.012 |
| hex: canterbury-large/E.coli | 524290 | 43252.0 ± 1.1% | 1.001 | 0.088 | 1.003 | 0.591 | 0.999 | 0.998 | 0.999 | 0.993 | 0.998 | 0.093 | 0.995 |
| hex: canterbury-large/bible.txt | 524290 | 43466.1 ± 0.3% | 1.000 | 0.088 | 1.000 | 0.588 | 0.996 | 0.998 | 0.996 | 1.000 | 0.996 | 0.094 | 0.998 |
| hex: canterbury-large/world192.txt | 524290 | 43483.5 ± 0.3% | 1.001 | 0.088 | 1.001 | 0.590 | 0.994 | 0.996 | 1.000 | 0.999 | 0.999 | 0.092 | 0.987 |
| hex: http/html-1kx1024 | 2099200 | 20462.3 ± 0.6% | 1.001 | 0.178 | 1.005 | 0.943 | 1.004 | 1.002 | 1.004 | 1.005 | 1.008 | 0.186 | 1.006 |
| hex: http/html-16kx64 | 2097280 | 21489.5 ± 0.8% | 1.001 | 0.175 | 0.996 | 0.976 | 1.000 | 0.999 | 1.000 | 1.001 | 1.002 | 0.191 | 1.002 |
| hex: http/html-1m | 524290 | 40183.1 ± 0.8% | 1.001 | 0.095 | 1.002 | 0.636 | 1.000 | 1.000 | 0.996 | 1.000 | 0.998 | 0.101 | 0.998 |
| hex: http/json-1kx1024 | 2099200 | 20574.2 ± 0.4% | 1.002 | 0.178 | 0.999 | 0.938 | 1.000 | 0.998 | 1.003 | 1.003 | 1.007 | 0.185 | 1.000 |
| hex: http/json-16kx64 | 2097280 | 22467.6 ± 0.4% | 1.001 | 0.168 | 1.002 | 0.952 | 1.002 | 1.000 | 1.001 | 1.001 | 1.003 | 0.182 | 1.003 |
| hex: http/json-1m | 524290 | 42937.3 ± 0.6% | 1.002 | 0.089 | 1.003 | 0.598 | 0.996 | 0.995 | 0.995 | 0.995 | 0.995 | 0.093 | 0.995 |
| hex: http/js-1kx1024 | 2099200 | 20308.6 ± 0.6% | 1.005 | 0.180 | 1.005 | 0.952 | 1.004 | 1.004 | 1.004 | 1.006 | 1.008 | 0.187 | 1.007 |
| hex: http/js-16kx64 | 2097280 | 21992.3 ± 0.4% | 1.002 | 0.171 | 1.004 | 0.970 | 1.002 | 1.002 | 1.002 | 1.003 | 1.005 | 0.187 | 1.003 |
| hex: http/js-1m | 524290 | 42445.7 ± 0.5% | 1.004 | 0.091 | 0.999 | 0.607 | 0.985 | 0.991 | 0.986 | 0.989 | 0.984 | 0.091 | 0.986 |
| hex: http/css-1kx1024 | 2099200 | 20770.7 ± 0.8% | 1.004 | 0.177 | 1.003 | 0.941 | 1.005 | 1.001 | 1.003 | 1.004 | 1.006 | 0.185 | 1.006 |
| hex: http/css-16kx64 | 2097280 | 22053.5 ± 0.1% | 1.003 | 0.172 | 1.003 | 0.959 | 1.003 | 1.003 | 1.003 | 1.004 | 1.003 | 0.187 | 1.004 |
| hex: http/css-1m | 524290 | 42878.4 ± 0.6% | 1.000 | 0.090 | 1.001 | 0.602 | 0.997 | 0.996 | 0.996 | 0.998 | 0.996 | 0.093 | 0.997 |
| hex: shuffled/dickens-1m | 524290 | 42784.7 ± 4.7% | 1.006 | 0.089 | 1.007 | 0.599 | 0.998 | 0.998 | 0.998 | 0.998 | 0.997 | 0.094 | 1.001 |

## Losses

Each workload where a claim's path ran slower than the path it replaces by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding: J7 wide vectors off runs at 1.063 of all on.
- CLDR supplemental, 34 texts, decoding: J8 decoder fast path off runs at 1.067 of all on.
- CLDR supplemental, 34 texts, decoding: J12 decoder escape words off runs at 1.071 of all on.
- CLDR supplemental, 34 texts, decoding: J13 decoder escape blocks off runs at 1.069 of all on.
- qlog records, JSON text sequence, decoding: J5 UTF-8 vectors off runs at 1.071 of all on.
- qlog records, JSON text sequence, decoding: J7 wide vectors off runs at 1.074 of all on.
- qlog records, JSON text sequence, decoding: J8 decoder fast path off runs at 1.074 of all on.
- qlog records, JSON text sequence, decoding: J12 decoder escape words off runs at 1.073 of all on.
- qlog records, JSON text sequence, decoding: J13 decoder escape blocks off runs at 1.073 of all on.
- string: silesia/dickens, decoding: J7 wide vectors off runs at 1.117 of all on.
- string: silesia/dickens, decoding: J8 decoder fast path off runs at 1.115 of all on.
- string: silesia/dickens, decoding: J13 decoder escape blocks off runs at 1.127 of all on.
- string: silesia/samba, decoding: J7 wide vectors off runs at 1.059 of all on.
- string: silesia/samba, decoding: J8 decoder fast path off runs at 1.062 of all on.
- string: silesia/samba, decoding: J13 decoder escape blocks off runs at 1.058 of all on.
- string: canterbury/alice29.txt, decoding: J7 wide vectors off runs at 1.084 of all on.
- string: canterbury/alice29.txt, decoding: J8 decoder fast path off runs at 1.122 of all on.
- string: canterbury/alice29.txt, decoding: J13 decoder escape blocks off runs at 1.161 of all on.
- string: canterbury/asyoulik.txt, decoding: J7 wide vectors off runs at 1.135 of all on.
- string: canterbury/asyoulik.txt, decoding: J8 decoder fast path off runs at 1.127 of all on.
- string: canterbury/asyoulik.txt, decoding: J12 decoder escape words off runs at 1.063 of all on.
- string: canterbury/asyoulik.txt, decoding: J13 decoder escape blocks off runs at 1.139 of all on.
- string: canterbury/lcet10.txt, decoding: J7 wide vectors off runs at 1.096 of all on.
- string: canterbury/lcet10.txt, decoding: J8 decoder fast path off runs at 1.106 of all on.
- string: canterbury/lcet10.txt, decoding: J13 decoder escape blocks off runs at 1.116 of all on.
- hex: http/css-1kx1024, decoding: J5 UTF-8 vectors off runs at 1.056 of all on.

## UTF-8 validation against simdutf

stdx's `is_utf8`, the check the loops apply to every string's octets, run alone over each string workload's octets at the width the host's features pick (16 lanes on aarch64, AVX2's 32 or AVX-512's 64 on x86-64, decision 39), beside simdutf 9.3.3's `validate_utf8` in the same run; on a host with AVX-512, again with AVX2 alone. Each ratio is stdx's throughput over the other's. simdutf picks its kernel at run time. Before timing, every copy of the check and simdutf judged 20000 seeded buffers and each workload, whole and changed, alike.

| Workload | Octets | stdx, MB/s | simdutf, MB/s | stdx / simdutf | stdx with AVX2 alone, MB/s | stdx / stdx with AVX2 alone |
|---|---|---|---|---|---|---|
| string: silesia/dickens | 166668 | 164552.4 ± 2.4% | 118796.2 ± 1.5% | 1.385 | 99491.1 ± 1.3% | 1.654 |
| string: silesia/nci | 1048576 | 165956.0 ± 1.7% | 119922.6 ± 6.4% | 1.384 | 99342.4 ± 1.6% | 1.671 |
| string: silesia/reymont | 1048576 | 167449.3 ± 1.1% | 121366.0 ± 6.6% | 1.380 | 100188.2 ± 0.5% | 1.671 |
| string: silesia/samba | 65546 | 158549.4 ± 2.5% | 117944.3 ± 1.6% | 1.344 | 97815.6 ± 0.8% | 1.621 |
| string: silesia/webster | 1048576 | 141062.7 ± 2.4% | 112223.2 ± 1.8% | 1.257 | 94192.7 ± 3.9% | 1.498 |
| string: silesia/xml | 1048576 | 160318.5 ± 1.5% | 119545.4 ± 0.4% | 1.341 | 98855.3 ± 0.2% | 1.622 |
| string: canterbury/alice29.txt | 152089 | 160639.3 ± 2.2% | 118759.5 ± 1.2% | 1.353 | 98298.1 ± 0.7% | 1.634 |
| string: canterbury/asyoulik.txt | 125179 | 163231.5 ± 1.0% | 119298.1 ± 2.3% | 1.368 | 98593.7 ± 1.1% | 1.656 |
| string: canterbury/lcet10.txt | 426754 | 163397.8 ± 1.3% | 119345.4 ± 0.2% | 1.369 | 99284.0 ± 0.2% | 1.646 |
| string: canterbury/plrabn12.txt | 481861 | 158514.8 ± 1.9% | 119273.0 ± 0.5% | 1.329 | 99318.4 ± 0.2% | 1.596 |
| string: canterbury-large/E.coli | 1048576 | 158874.9 ± 1.4% | 119568.7 ± 0.2% | 1.329 | 98852.4 ± 0.1% | 1.607 |
| string: canterbury-large/bible.txt | 1048576 | 159194.4 ± 6.2% | 119294.7 ± 0.3% | 1.334 | 99490.8 ± 2.8% | 1.600 |
| string: canterbury-large/world192.txt | 1048576 | 160522.5 ± 1.1% | 119522.4 ± 0.1% | 1.343 | 98759.8 ± 3.9% | 1.625 |
| string: http/html-1m | 1048576 | 142807.8 ± 1.3% | 109251.5 ± 5.2% | 1.307 | 91899.9 ± 4.8% | 1.554 |
| string: http/json-1m | 1048576 | 117285.7 ± 1.7% | 103745.3 ± 1.0% | 1.131 | 80652.6 ± 0.9% | 1.454 |
| string: http/js-1m | 1048576 | 156243.2 ± 3.6% | 118505.6 ± 0.5% | 1.318 | 97632.4 ± 0.6% | 1.600 |
| string: http/css-1m | 1048576 | 160223.9 ± 1.8% | 118983.5 ± 0.2% | 1.347 | 98214.4 ± 0.5% | 1.631 |
| string: dickens as Cyrillic and CJK | 1847045 | 23699.8 ± 0.3% | 20714.6 ± 0.9% | 1.144 | 14980.6 ± 0.9% | 1.582 |

## Losses to simdutf

None.

## UTF-8 validation by the buffer's offset from a 64-octet line

| Buffer | Octets | Offset | stdx, MB/s | simdutf, MB/s | stdx / simdutf | stdx with AVX2 alone, MB/s | stdx / stdx with AVX2 alone |
|---|---|---|---|---|---|---|---|
| string: canterbury-large/bible.txt | 1048576 | 0 | 162344.7 ± 1.5% | 119683.8 ± 5.2% | 1.356 | 102238.7 ± 6.2% | 1.588 |
| string: canterbury-large/bible.txt | 1048576 | 1 | 160606.9 ± 12.6% | 119679.8 ± 0.6% | 1.342 | 99204.2 ± 0.7% | 1.619 |
| string: canterbury-large/bible.txt | 1048576 | 8 | 163364.0 ± 9.9% | 119663.8 ± 0.9% | 1.365 | 99131.8 ± 1.0% | 1.648 |
| string: canterbury-large/bible.txt | 1048576 | 16 | 163427.7 ± 1.7% | 119980.3 ± 0.6% | 1.362 | 99197.1 ± 4.3% | 1.648 |
| string: canterbury-large/bible.txt | 1048576 | 32 | 162776.2 ± 3.5% | 119731.8 ± 0.5% | 1.360 | 99121.8 ± 0.3% | 1.642 |
| string: canterbury-large/bible.txt | 1048576 | 48 | 161099.2 ± 3.0% | 119642.8 ± 0.5% | 1.347 | 99632.4 ± 0.6% | 1.617 |
| string: dickens as Cyrillic and CJK | 1048576 | 0 | 24396.3 ± 0.2% | 21786.7 ± 0.3% | 1.120 | 15379.6 ± 0.1% | 1.586 |
| string: dickens as Cyrillic and CJK | 1048576 | 1 | 24313.1 ± 0.9% | 21682.5 ± 1.6% | 1.121 | 15264.2 ± 2.5% | 1.593 |
| string: dickens as Cyrillic and CJK | 1048576 | 8 | 24393.5 ± 0.8% | 21766.2 ± 1.7% | 1.121 | 15326.4 ± 0.4% | 1.592 |
| string: dickens as Cyrillic and CJK | 1048576 | 16 | 24369.5 ± 0.6% | 21774.5 ± 0.8% | 1.119 | 15324.3 ± 0.8% | 1.590 |
| string: dickens as Cyrillic and CJK | 1048576 | 32 | 24357.5 ± 0.5% | 21777.9 ± 0.2% | 1.118 | 15364.5 ± 0.4% | 1.585 |
| string: dickens as Cyrillic and CJK | 1048576 | 48 | 24386.3 ± 0.1% | 21786.5 ± 0.2% | 1.119 | 15394.1 ± 0.2% | 1.584 |

## Against the baselines

stdx with every claim on, timed beside simdjson 5.1.1, yyjson 0.13.0, Zig 0.16.0's std.json, serde_json 1.0.154 and Go's encoding/json/jsontext in the same run. Each ratio is stdx's throughput over the baseline's; below 1, the baseline is faster. stdx is built for the architecture's baseline CPU in ReleaseSafe. Each baseline is built for the same CPU, the C, C++ and Zig ones in ReleaseFast (decision 75), and simdjson picks its kernel at run time. Decoding visits every value; encoding writes each text from its tokens.

## Decoding against the baselines

Octets are the text's. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1380.0 ± 0.2% | 1490.6 ± 2.2% | 1076.8 ± 1.0% | 401.7 ± 0.8% | 664.7 ± 0.4% | 364.7 ± 1.5% | 0.926 | 1.282 | 3.435 | 2.076 | 3.784 |
| qlog records, JSON text sequence | 1467503 | 1089.5 ± 0.5% | 1237.2 ± 0.4% | 1129.4 ± 0.7% | 345.5 ± 1.5% | 754.8 ± 0.6% | 319.2 ± 0.5% | 0.881 | 0.965 | 3.154 | 1.443 | 3.413 |
| string: silesia/dickens | 172528 | 6623.9 ± 3.3% | 3466.6 ± 0.6% | 2868.9 ± 1.5% | 309.0 ± 0.4% | 3024.7 ± 3.5% | 572.7 ± 2.4% | 1.911 | 2.309 | 21.440 | 2.190 | 11.566 |
| string: silesia/nci | 1075110 | 5401.4 ± 0.7% | 3925.4 ± 0.9% | 3033.6 ± 0.5% | 642.4 ± 0.5% | 3635.8 ± 0.3% | 560.3 ± 3.0% | 1.376 | 1.781 | 8.408 | 1.486 | 9.641 |
| string: silesia/reymont | 1075159 | 3542.4 ± 0.6% | 3417.8 ± 0.3% | 1952.1 ± 0.5% | 326.8 ± 3.8% | 2104.4 ± 0.3% | 477.7 ± 2.2% | 1.036 | 1.815 | 10.839 | 1.683 | 7.415 |
| string: silesia/samba | 97582 | 4005.9 ± 1.2% | 3798.0 ± 3.7% | 3070.2 ± 0.5% | 333.6 ± 1.3% | 1907.3 ± 0.7% | 417.0 ± 0.7% | 1.055 | 1.305 | 12.007 | 2.100 | 9.607 |
| string: silesia/webster | 1098490 | 4394.3 ± 1.5% | 2423.5 ± 0.2% | 1731.8 ± 2.6% | 300.5 ± 0.5% | 2048.1 ± 1.6% | 457.3 ± 1.4% | 1.813 | 2.537 | 14.623 | 2.146 | 9.609 |
| string: silesia/xml | 1090118 | 6034.6 ± 0.6% | 4985.5 ± 3.3% | 2427.9 ± 3.7% | 501.4 ± 2.9% | 3297.1 ± 3.7% | 537.9 ± 4.9% | 1.210 | 2.486 | 12.035 | 1.830 | 11.218 |
| string: canterbury/alice29.txt | 159425 | 5738.4 ± 0.9% | 2761.1 ± 1.3% | 2777.9 ± 1.2% | 294.1 ± 0.9% | 2742.2 ± 0.5% | 515.3 ± 3.4% | 2.078 | 2.066 | 19.512 | 2.093 | 11.135 |
| string: canterbury/asyoulik.txt | 132198 | 4273.2 ± 0.7% | 2580.7 ± 5.5% | 2785.3 ± 1.1% | 296.5 ± 0.5% | 2373.8 ± 2.1% | 450.8 ± 2.3% | 1.656 | 1.534 | 14.413 | 1.800 | 9.479 |
| string: canterbury/lcet10.txt | 441884 | 6648.4 ± 0.6% | 3282.0 ± 1.2% | 2329.3 ± 0.9% | 338.5 ± 2.0% | 2763.3 ± 0.7% | 566.5 ± 1.0% | 2.026 | 2.854 | 19.641 | 2.406 | 11.735 |
| string: canterbury/plrabn12.txt | 503330 | 5442.2 ± 0.5% | 3120.2 ± 1.3% | 1825.0 ± 0.7% | 319.3 ± 0.4% | 2799.2 ± 0.4% | 530.0 ± 0.8% | 1.744 | 2.982 | 17.045 | 1.944 | 10.268 |
| string: canterbury-large/E.coli | 1048578 | 30205.8 ± 0.7% | 12893.1 ± 0.7% | 3379.7 ± 0.6% | 1277.5 ± 0.4% | 8885.8 ± 0.6% | 914.4 ± 5.6% | 2.343 | 8.937 | 23.645 | 3.399 | 33.033 |
| string: canterbury-large/bible.txt | 1055886 | 8447.2 ± 2.0% | 5220.8 ± 1.1% | 2775.7 ± 0.7% | 350.9 ± 0.5% | 3833.7 ± 0.9% | 623.8 ± 2.6% | 1.618 | 3.043 | 24.076 | 2.203 | 13.541 |
| string: canterbury-large/world192.txt | 1103121 | 4131.1 ± 0.7% | 2300.4 ± 0.4% | 1758.0 ± 0.7% | 327.7 ± 1.4% | 2099.8 ± 0.7% | 462.2 ± 4.3% | 1.796 | 2.350 | 12.606 | 1.967 | 8.937 |
| string: http/html-1m | 1058582 | 9113.6 ± 1.7% | 4702.2 ± 1.3% | 2668.1 ± 0.6% | 400.6 ± 0.9% | 3596.9 ± 0.8% | 587.9 ± 1.4% | 1.938 | 3.416 | 22.748 | 2.534 | 15.502 |
| string: http/json-1m | 1190272 | 3313.8 ± 1.3% | 1250.9 ± 0.7% | 2027.2 ± 0.4% | 476.8 ± 0.5% | 1337.3 ± 0.5% | 435.3 ± 0.7% | 2.649 | 1.635 | 6.950 | 2.478 | 7.612 |
| string: http/js-1m | 1144362 | 2857.8 ± 1.5% | 1600.7 ± 0.3% | 1327.4 ± 1.0% | 320.8 ± 0.8% | 1415.7 ± 1.2% | 376.8 ± 2.1% | 1.785 | 2.153 | 8.907 | 2.019 | 7.584 |
| string: http/css-1m | 1097820 | 3278.4 ± 0.5% | 2864.7 ± 3.1% | 2255.3 ± 0.4% | 439.9 ± 2.7% | 2065.0 ± 0.6% | 433.6 ± 1.2% | 1.144 | 1.454 | 7.453 | 1.588 | 7.561 |
| string: dickens as Cyrillic and CJK | 1883069 | 5748.6 ± 0.9% | 2991.8 ± 2.3% | 659.5 ± 0.6% | 369.8 ± 1.0% | 510.8 ± 0.6% | 162.8 ± 2.4% | 1.921 | 8.717 | 15.545 | 11.253 | 35.320 |
| string: dickens as Cyrillic and CJK, as \u escapes | 5075485 | 1189.4 ± 0.4% | 1236.2 ± 1.1% | 1091.3 ± 1.3% | 265.7 ± 1.3% | 477.2 ± 1.4% | 224.9 ± 1.7% | 0.962 | 1.090 | 4.476 | 2.492 | 5.289 |
| hex: silesia/dickens | 524290 | 45182.5 ± 2.2% | 15035.4 ± 0.7% | 3482.3 ± 1.4% | 480.0 ± 0.9% | 8896.4 ± 1.3% | 1125.1 ± 3.0% | 3.005 | 12.975 | 94.136 | 5.079 | 40.160 |
| hex: silesia/mozilla | 524290 | 45370.1 ± 1.4% | 15021.5 ± 0.9% | 3551.8 ± 0.7% | 428.2 ± 0.5% | 8884.7 ± 0.8% | 1120.8 ± 1.5% | 3.020 | 12.774 | 105.946 | 5.107 | 40.479 |
| hex: silesia/mr | 524290 | 44198.9 ± 1.3% | 15021.1 ± 0.8% | 3549.6 ± 1.8% | 642.5 ± 3.1% | 8888.4 ± 1.2% | 1127.0 ± 0.5% | 2.942 | 12.452 | 68.789 | 4.973 | 39.219 |
| hex: silesia/nci | 524290 | 45248.5 ± 2.0% | 15115.4 ± 1.0% | 3500.9 ± 4.1% | 797.1 ± 1.8% | 8928.5 ± 1.2% | 1126.3 ± 1.7% | 2.994 | 12.925 | 56.769 | 5.068 | 40.174 |
| hex: silesia/ooffice | 524290 | 45393.2 ± 2.6% | 15100.9 ± 0.9% | 3565.0 ± 1.1% | 344.8 ± 1.9% | 8939.3 ± 5.3% | 1127.7 ± 1.2% | 3.006 | 12.733 | 131.655 | 5.078 | 40.253 |
| hex: silesia/osdb | 524290 | 42854.1 ± 1.7% | 14987.9 ± 0.7% | 3547.3 ± 1.0% | 448.3 ± 0.6% | 8857.1 ± 0.6% | 1119.7 ± 0.8% | 2.859 | 12.081 | 95.597 | 4.838 | 38.272 |
| hex: silesia/reymont | 524290 | 45250.0 ± 1.2% | 15015.8 ± 0.4% | 3474.6 ± 0.9% | 502.4 ± 0.7% | 8863.2 ± 0.9% | 1118.5 ± 1.4% | 3.013 | 13.023 | 90.073 | 5.105 | 40.457 |
| hex: silesia/samba | 524290 | 46313.3 ± 1.5% | 15014.5 ± 0.5% | 3544.2 ± 0.5% | 363.6 ± 1.4% | 8897.2 ± 0.7% | 1120.5 ± 1.6% | 3.085 | 13.067 | 127.378 | 5.205 | 41.331 |
| hex: silesia/sao | 524290 | 48124.1 ± 3.0% | 15068.0 ± 0.6% | 3443.2 ± 0.8% | 275.2 ± 2.2% | 8844.6 ± 0.6% | 1127.4 ± 1.2% | 3.194 | 13.977 | 174.886 | 5.441 | 42.685 |
| hex: silesia/webster | 524290 | 46437.3 ± 1.1% | 15121.6 ± 2.7% | 3561.6 ± 0.7% | 452.0 ± 0.4% | 8921.4 ± 0.2% | 1138.5 ± 0.4% | 3.071 | 13.038 | 102.734 | 5.205 | 40.787 |
| hex: silesia/x-ray | 524290 | 46006.4 ± 0.2% | 15144.0 ± 0.3% | 3499.5 ± 1.3% | 424.1 ± 0.5% | 8913.5 ± 0.9% | 1134.9 ± 0.6% | 3.038 | 13.147 | 108.481 | 5.161 | 40.537 |
| hex: silesia/xml | 524290 | 45882.3 ± 1.9% | 15146.3 ± 0.7% | 3569.1 ± 0.6% | 732.3 ± 1.5% | 8911.2 ± 0.3% | 1131.3 ± 1.5% | 3.029 | 12.855 | 62.658 | 5.149 | 40.557 |
| hex: canterbury/alice29.txt | 304180 | 45801.6 ± 0.4% | 14164.8 ± 0.9% | 3567.4 ± 0.3% | 486.3 ± 0.7% | 8914.9 ± 0.4% | 1148.4 ± 0.3% | 3.233 | 12.839 | 94.192 | 5.138 | 39.882 |
| hex: canterbury/asyoulik.txt | 250360 | 45917.9 ± 0.2% | 15117.5 ± 0.1% | 3503.0 ± 0.2% | 473.5 ± 0.5% | 8913.1 ± 0.1% | 1145.8 ± 0.7% | 3.037 | 13.108 | 96.975 | 5.152 | 40.074 |
| hex: canterbury/cp.html | 49208 | 46270.1 ± 1.0% | 14389.8 ± 0.8% | 3551.1 ± 0.8% | 502.3 ± 1.3% | 9216.4 ± 0.6% | 1119.7 ± 2.6% | 3.215 | 13.030 | 92.120 | 5.020 | 41.323 |
| hex: canterbury/fields.c | 22302 | 49716.8 ± 1.9% | 17430.2 ± 2.4% | 3647.1 ± 0.6% | 561.7 ± 0.9% | 9206.7 ± 0.6% | 1100.7 ± 0.3% | 2.852 | 13.632 | 88.505 | 5.400 | 45.167 |
| hex: canterbury/grammar.lsp | 7444 | 42950.5 ± 1.6% | 17138.1 ± 4.4% | 3610.0 ± 1.8% | 762.0 ± 1.1% | 8925.3 ± 0.6% | 1056.3 ± 2.1% | 2.506 | 11.898 | 56.365 | 4.812 | 40.663 |
| hex: canterbury/kennedy.xls | 524290 | 45845.1 ± 2.1% | 14996.9 ± 0.8% | 3515.3 ± 0.5% | 749.4 ± 1.4% | 8854.9 ± 0.4% | 1101.3 ± 5.5% | 3.057 | 13.041 | 61.175 | 5.177 | 41.627 |
| hex: canterbury/lcet10.txt | 524290 | 45069.5 ± 1.1% | 15021.1 ± 1.1% | 3537.6 ± 1.6% | 484.6 ± 2.1% | 8840.4 ± 3.4% | 1119.8 ± 3.4% | 3.000 | 12.740 | 92.996 | 5.098 | 40.246 |
| hex: canterbury/plrabn12.txt | 524290 | 46613.7 ± 2.1% | 15069.7 ± 0.7% | 3563.8 ± 0.4% | 467.5 ± 1.1% | 8886.2 ± 0.8% | 1116.4 ± 2.3% | 3.093 | 13.080 | 99.706 | 5.246 | 41.754 |
| hex: canterbury/ptt5 | 524290 | 46344.1 ± 0.3% | 15089.5 ± 0.8% | 3492.0 ± 0.8% | 665.8 ± 0.9% | 8886.5 ± 0.6% | 1122.5 ± 2.4% | 3.071 | 13.271 | 69.611 | 5.215 | 41.285 |
| hex: canterbury/sum | 76482 | 45756.8 ± 0.6% | 15419.0 ± 0.4% | 3561.8 ± 0.3% | 585.2 ± 0.6% | 8905.4 ± 0.4% | 1123.4 ± 1.1% | 2.968 | 12.847 | 78.197 | 5.138 | 40.731 |
| hex: canterbury/xargs.1 | 8456 | 44702.5 ± 1.2% | 17389.4 ± 0.8% | 3560.5 ± 0.7% | 736.8 ± 2.6% | 8940.7 ± 0.7% | 1104.3 ± 1.6% | 2.571 | 12.555 | 60.675 | 5.000 | 40.482 |
| hex: canterbury-large/E.coli | 524290 | 44917.1 ± 1.5% | 15025.3 ± 3.4% | 3468.6 ± 0.3% | 954.1 ± 2.9% | 8853.0 ± 0.7% | 1117.5 ± 3.4% | 2.989 | 12.949 | 47.077 | 5.074 | 40.193 |
| hex: canterbury-large/bible.txt | 524290 | 45635.9 ± 2.3% | 15055.8 ± 0.8% | 3480.0 ± 1.6% | 500.4 ± 0.8% | 8857.2 ± 1.1% | 1116.6 ± 1.9% | 3.031 | 13.114 | 91.207 | 5.152 | 40.871 |
| hex: canterbury-large/world192.txt | 524290 | 45612.1 ± 3.4% | 14999.7 ± 3.3% | 3570.1 ± 0.9% | 469.7 ± 1.1% | 8919.2 ± 1.3% | 1123.0 ± 1.6% | 3.041 | 12.776 | 97.112 | 5.114 | 40.618 |
| hex: http/html-1kx1024 | 2099200 | 17472.7 ± 1.8% | 12459.3 ± 3.1% | 3157.1 ± 0.5% | 508.4 ± 0.4% | 7388.7 ± 1.3% | 951.0 ± 3.2% | 1.402 | 5.534 | 34.369 | 2.365 | 18.372 |
| hex: http/html-16kx64 | 2097280 | 33791.1 ± 1.0% | 13864.7 ± 1.1% | 3399.1 ± 2.9% | 516.5 ± 1.0% | 8494.7 ± 1.1% | 1072.2 ± 3.4% | 2.437 | 9.941 | 65.429 | 3.978 | 31.515 |
| hex: http/html-1m | 524290 | 45004.2 ± 1.6% | 15000.9 ± 0.7% | 3474.5 ± 0.9% | 504.8 ± 1.5% | 8862.2 ± 1.4% | 1114.4 ± 1.7% | 3.000 | 12.953 | 89.153 | 5.078 | 40.384 |
| hex: http/json-1kx1024 | 2099200 | 17324.1 ± 0.5% | 12356.4 ± 0.4% | 3136.1 ± 1.0% | 679.6 ± 1.3% | 7450.0 ± 0.8% | 966.1 ± 1.4% | 1.402 | 5.524 | 25.491 | 2.325 | 17.932 |
| hex: http/json-16kx64 | 2097280 | 34277.6 ± 1.4% | 13992.3 ± 0.5% | 3386.7 ± 0.5% | 694.9 ± 0.8% | 8472.3 ± 0.4% | 1067.1 ± 4.2% | 2.450 | 10.121 | 49.329 | 4.046 | 32.122 |
| hex: http/json-1m | 524290 | 46028.6 ± 1.8% | 15114.5 ± 0.6% | 3535.9 ± 0.8% | 714.1 ± 0.4% | 8920.7 ± 0.3% | 1117.2 ± 1.6% | 3.045 | 13.018 | 64.457 | 5.160 | 41.199 |
| hex: http/js-1kx1024 | 2099200 | 17194.5 ± 0.9% | 12232.3 ± 5.4% | 3151.3 ± 0.4% | 492.1 ± 0.2% | 7482.6 ± 1.6% | 952.7 ± 2.7% | 1.406 | 5.456 | 34.942 | 2.298 | 18.047 |
| hex: http/js-16kx64 | 2097280 | 33260.8 ± 1.3% | 13978.1 ± 0.5% | 3385.0 ± 1.0% | 499.3 ± 0.8% | 8313.2 ± 1.7% | 1066.1 ± 5.8% | 2.379 | 9.826 | 66.619 | 4.001 | 31.199 |
| hex: http/js-1m | 524290 | 47990.6 ± 1.0% | 14989.8 ± 1.2% | 3559.4 ± 1.0% | 516.6 ± 1.3% | 8857.2 ± 0.9% | 1106.0 ± 2.4% | 3.202 | 13.483 | 92.890 | 5.418 | 43.390 |
| hex: http/css-1kx1024 | 2099200 | 17229.1 ± 1.6% | 12197.6 ± 12.1% | 3134.7 ± 1.0% | 565.3 ± 0.9% | 7412.7 ± 1.6% | 958.4 ± 2.7% | 1.413 | 5.496 | 30.476 | 2.324 | 17.977 |
| hex: http/css-16kx64 | 2097280 | 33508.8 ± 0.4% | 13753.0 ± 0.9% | 3362.3 ± 0.7% | 577.6 ± 2.8% | 8462.6 ± 1.1% | 1057.0 ± 4.9% | 2.436 | 9.966 | 58.010 | 3.960 | 31.701 |
| hex: http/css-1m | 524290 | 45694.4 ± 3.7% | 15020.6 ± 0.9% | 3531.2 ± 1.0% | 558.6 ± 1.2% | 8871.9 ± 4.2% | 1109.4 ± 4.2% | 3.042 | 12.940 | 81.801 | 5.150 | 41.188 |
| hex: shuffled/dickens-1m | 524290 | 47113.6 ± 2.5% | 15067.8 ± 0.5% | 3477.7 ± 1.0% | 478.7 ± 2.1% | 8867.4 ± 0.8% | 1126.5 ± 1.6% | 3.127 | 13.547 | 98.415 | 5.313 | 41.823 |

## Encoding against the baselines

Octets are the ones stdx writes. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1736.2 ± 1.0% | 1467.4 ± 0.5% | 1021.0 ± 0.6% | 478.7 ± 0.5% | 469.9 ± 2.6% | 500.3 ± 5.1% | 1.183 | 1.700 | 3.627 | 3.695 | 3.471 |
| qlog records, JSON text sequence | 1467503 | 1649.3 ± 3.0% | 1234.6 ± 1.2% | 944.8 ± 1.0% | 455.3 ± 0.7% | 572.1 ± 0.7% | 350.1 ± 1.2% | 1.336 | 1.746 | 3.622 | 2.883 | 4.711 |
| string: silesia/dickens | 172528 | 12047.8 ± 5.5% | 3966.9 ± 1.2% | 3072.6 ± 1.1% | 357.3 ± 1.1% | 1719.4 ± 1.5% | 1190.1 ± 2.3% | 3.037 | 3.921 | 33.715 | 7.007 | 10.123 |
| string: silesia/nci | 1075110 | 10720.8 ± 0.9% | 4544.6 ± 1.2% | 3112.5 ± 1.2% | 854.8 ± 1.1% | 1912.3 ± 1.2% | 1285.2 ± 1.3% | 2.359 | 3.444 | 12.542 | 5.606 | 8.341 |
| string: silesia/reymont | 1075159 | 5272.2 ± 1.9% | 1829.4 ± 0.7% | 1892.6 ± 0.9% | 395.7 ± 1.1% | 1443.4 ± 0.5% | 1049.2 ± 1.0% | 2.882 | 2.786 | 13.323 | 3.653 | 5.025 |
| string: silesia/samba | 97582 | 6261.4 ± 1.1% | 2713.6 ± 0.9% | 4065.8 ± 1.3% | 376.8 ± 1.4% | 1326.4 ± 1.5% | 1179.3 ± 3.5% | 2.307 | 1.540 | 16.615 | 4.721 | 5.309 |
| string: silesia/webster | 1098490 | 6589.4 ± 1.4% | 1944.9 ± 1.2% | 1734.6 ± 1.6% | 387.8 ± 1.1% | 1396.9 ± 1.4% | 597.6 ± 3.2% | 3.388 | 3.799 | 16.994 | 4.717 | 11.027 |
| string: silesia/xml | 1090118 | 9721.4 ± 1.1% | 3152.6 ± 2.1% | 2505.4 ± 1.1% | 623.3 ± 1.4% | 1932.8 ± 1.0% | 960.6 ± 4.6% | 3.084 | 3.880 | 15.598 | 5.030 | 10.120 |
| string: canterbury/alice29.txt | 159425 | 10758.2 ± 4.4% | 2891.9 ± 1.2% | 3030.0 ± 2.4% | 341.5 ± 1.3% | 1532.5 ± 2.0% | 1087.7 ± 1.0% | 3.720 | 3.551 | 31.498 | 7.020 | 9.891 |
| string: canterbury/asyoulik.txt | 132198 | 10037.3 ± 1.9% | 2120.4 ± 1.0% | 3102.3 ± 0.9% | 348.0 ± 0.8% | 1364.9 ± 1.0% | 943.9 ± 2.7% | 4.734 | 3.235 | 28.847 | 7.354 | 10.633 |
| string: canterbury/lcet10.txt | 441884 | 10547.0 ± 1.2% | 3069.6 ± 0.3% | 2586.3 ± 3.3% | 385.8 ± 1.5% | 1656.1 ± 1.4% | 1199.7 ± 0.9% | 3.436 | 4.078 | 27.340 | 6.369 | 8.792 |
| string: canterbury/plrabn12.txt | 503330 | 7985.7 ± 3.4% | 2302.5 ± 1.0% | 2085.8 ± 0.8% | 363.2 ± 0.8% | 1614.0 ± 1.6% | 1118.8 ± 1.7% | 3.468 | 3.829 | 21.987 | 4.948 | 7.138 |
| string: canterbury-large/E.coli | 1048578 | 31285.0 ± 0.5% | 15490.8 ± 1.4% | 3458.5 ± 0.2% | 1688.0 ± 0.2% | 3130.5 ± 4.6% | 1406.6 ± 0.7% | 2.020 | 9.046 | 18.533 | 9.994 | 22.242 |
| string: canterbury-large/bible.txt | 1055886 | 8838.9 ± 0.5% | 4751.3 ± 1.3% | 2983.8 ± 2.4% | 419.1 ± 0.5% | 2209.3 ± 3.2% | 1477.2 ± 0.4% | 1.860 | 2.962 | 21.090 | 4.001 | 5.984 |
| string: canterbury-large/world192.txt | 1103121 | 6355.9 ± 3.7% | 1711.0 ± 0.8% | 1871.7 ± 3.9% | 388.7 ± 2.2% | 1395.6 ± 1.9% | 964.2 ± 1.4% | 3.715 | 3.396 | 16.351 | 4.554 | 6.592 |
| string: http/html-1m | 1058582 | 9798.0 ± 3.4% | 4346.9 ± 4.5% | 2863.1 ± 0.8% | 461.3 ± 0.4% | 2151.7 ± 0.7% | 845.7 ± 0.9% | 2.254 | 3.422 | 21.239 | 4.554 | 11.585 |
| string: http/json-1m | 1190272 | 8435.3 ± 0.3% | 1575.0 ± 5.2% | 1562.0 ± 0.2% | 538.3 ± 0.6% | 1155.6 ± 0.6% | 850.8 ± 1.4% | 5.356 | 5.400 | 15.670 | 7.300 | 9.915 |
| string: http/js-1m | 1144362 | 6360.4 ± 0.6% | 1116.4 ± 0.8% | 1385.8 ± 0.6% | 359.9 ± 0.6% | 1127.7 ± 3.3% | 754.3 ± 0.8% | 5.697 | 4.590 | 17.675 | 5.640 | 8.432 |
| string: http/css-1m | 1097820 | 7925.3 ± 0.6% | 1483.6 ± 0.5% | 2296.5 ± 0.6% | 546.3 ± 0.5% | 1268.5 ± 1.0% | 881.7 ± 1.1% | 5.342 | 3.451 | 14.508 | 6.248 | 8.989 |
| string: dickens as Cyrillic and CJK | 1883069 | 5443.2 ± 1.4% | 3676.0 ± 1.2% | 482.2 ± 1.1% | 250.8 ± 0.8% | 462.8 ± 0.6% | 354.6 ± 0.4% | 1.481 | 11.288 | 21.706 | 11.761 | 15.351 |
| hex: silesia/dickens | 524290 | 42272.8 ± 0.5% | 2569.8 ± 0.7% | 1507.2 ± 1.2% | 471.1 ± 0.7% | 1564.9 ± 5.0% | 1053.2 ± 0.8% | 16.450 | 28.047 | 89.736 | 27.014 | 40.139 |
| hex: silesia/mozilla | 524290 | 42883.4 ± 0.9% | 2569.4 ± 0.6% | 1492.6 ± 4.4% | 418.6 ± 1.3% | 1563.1 ± 1.0% | 1063.1 ± 1.1% | 16.690 | 28.730 | 102.449 | 27.436 | 40.338 |
| hex: silesia/mr | 524290 | 42938.9 ± 4.2% | 2564.2 ± 0.7% | 1499.1 ± 0.6% | 603.4 ± 2.1% | 1540.9 ± 1.1% | 1056.2 ± 3.1% | 16.745 | 28.643 | 71.163 | 27.865 | 40.652 |
| hex: silesia/nci | 524290 | 43604.9 ± 0.7% | 2561.7 ± 0.7% | 1495.3 ± 0.5% | 753.1 ± 0.3% | 1567.6 ± 0.5% | 1059.4 ± 0.2% | 17.022 | 29.160 | 57.900 | 27.816 | 41.159 |
| hex: silesia/ooffice | 524290 | 42840.7 ± 1.8% | 2578.8 ± 0.8% | 1493.3 ± 0.6% | 342.7 ± 1.0% | 1543.5 ± 1.0% | 1054.1 ± 0.7% | 16.612 | 28.688 | 125.016 | 27.755 | 40.642 |
| hex: silesia/osdb | 524290 | 41981.0 ± 1.1% | 2583.6 ± 1.1% | 1499.8 ± 1.0% | 453.5 ± 1.1% | 1569.2 ± 0.3% | 1054.2 ± 0.6% | 16.249 | 27.991 | 92.563 | 26.753 | 39.822 |
| hex: silesia/reymont | 524290 | 43579.5 ± 0.4% | 2593.2 ± 0.6% | 1498.8 ± 0.9% | 489.8 ± 3.6% | 1545.7 ± 5.0% | 1060.8 ± 0.7% | 16.805 | 29.076 | 88.969 | 28.194 | 41.080 |
| hex: silesia/samba | 524290 | 43397.8 ± 0.7% | 2571.2 ± 9.5% | 1497.2 ± 0.9% | 365.3 ± 3.5% | 1574.1 ± 0.7% | 1052.9 ± 0.9% | 16.879 | 28.985 | 118.807 | 27.571 | 41.217 |
| hex: silesia/sao | 524290 | 43187.8 ± 2.2% | 2592.3 ± 0.9% | 1495.9 ± 0.8% | 280.6 ± 0.9% | 1546.7 ± 0.3% | 1054.9 ± 1.6% | 16.660 | 28.872 | 153.896 | 27.923 | 40.942 |
| hex: silesia/webster | 524290 | 43714.8 ± 0.2% | 2576.5 ± 8.8% | 1499.0 ± 0.5% | 449.6 ± 0.5% | 1550.2 ± 0.6% | 1052.4 ± 0.7% | 16.967 | 29.162 | 97.220 | 28.199 | 41.537 |
| hex: silesia/x-ray | 524290 | 43333.6 ± 0.8% | 2579.7 ± 1.1% | 1497.4 ± 0.7% | 426.6 ± 2.5% | 1551.1 ± 3.2% | 1053.6 ± 1.0% | 16.798 | 28.938 | 101.568 | 27.937 | 41.128 |
| hex: silesia/xml | 524290 | 43451.5 ± 0.7% | 2567.3 ± 1.2% | 1498.3 ± 3.8% | 725.6 ± 1.4% | 1554.3 ± 0.5% | 1056.5 ± 1.0% | 16.925 | 29.000 | 59.880 | 27.956 | 41.129 |
| hex: canterbury/alice29.txt | 304180 | 41328.1 ± 1.4% | 2603.3 ± 7.2% | 1518.2 ± 0.5% | 477.0 ± 0.8% | 1581.6 ± 0.8% | 1077.4 ± 0.7% | 15.875 | 27.222 | 86.644 | 26.131 | 38.361 |
| hex: canterbury/asyoulik.txt | 250360 | 42919.3 ± 2.0% | 2609.7 ± 0.5% | 1526.3 ± 0.5% | 465.8 ± 0.4% | 1582.8 ± 0.4% | 1080.8 ± 1.1% | 16.446 | 28.120 | 92.134 | 27.116 | 39.710 |
| hex: canterbury/cp.html | 49208 | 42223.8 ± 1.2% | 2583.7 ± 0.9% | 1516.9 ± 0.4% | 512.3 ± 0.6% | 1585.3 ± 0.2% | 1083.2 ± 0.5% | 16.342 | 27.836 | 82.419 | 26.634 | 38.979 |
| hex: canterbury/fields.c | 22302 | 41292.5 ± 2.2% | 2649.1 ± 1.0% | 1526.9 ± 0.6% | 628.8 ± 1.1% | 1595.5 ± 4.3% | 1089.1 ± 1.1% | 15.587 | 27.043 | 65.673 | 25.881 | 37.913 |
| hex: canterbury/grammar.lsp | 7444 | 38522.3 ± 1.3% | 2678.5 ± 0.6% | 1527.9 ± 1.2% | 799.7 ± 0.6% | 1603.3 ± 0.8% | 1101.2 ± 0.7% | 14.382 | 25.212 | 48.173 | 24.027 | 34.984 |
| hex: canterbury/kennedy.xls | 524290 | 42792.6 ± 3.5% | 2569.5 ± 0.7% | 1498.0 ± 0.9% | 747.6 ± 1.2% | 1564.8 ± 6.1% | 1058.7 ± 1.2% | 16.654 | 28.566 | 57.241 | 27.347 | 40.418 |
| hex: canterbury/lcet10.txt | 524290 | 43453.6 ± 0.4% | 2593.6 ± 0.4% | 1511.1 ± 1.3% | 479.6 ± 1.2% | 1579.6 ± 0.8% | 1065.2 ± 0.8% | 16.754 | 28.756 | 90.600 | 27.509 | 40.794 |
| hex: canterbury/plrabn12.txt | 524290 | 43091.4 ± 0.9% | 2589.5 ± 0.7% | 1500.3 ± 0.5% | 461.8 ± 0.8% | 1571.3 ± 0.8% | 1056.8 ± 5.2% | 16.641 | 28.722 | 93.319 | 27.424 | 40.775 |
| hex: canterbury/ptt5 | 524290 | 42796.4 ± 1.0% | 2558.1 ± 0.6% | 1491.8 ± 0.7% | 609.0 ± 0.9% | 1542.9 ± 0.8% | 1051.0 ± 0.7% | 16.730 | 28.687 | 70.269 | 27.738 | 40.721 |
| hex: canterbury/sum | 76482 | 42228.5 ± 6.6% | 2573.0 ± 0.3% | 1507.2 ± 0.5% | 588.7 ± 0.8% | 1572.6 ± 1.3% | 1077.6 ± 2.4% | 16.412 | 28.017 | 71.730 | 26.853 | 39.189 |
| hex: canterbury/xargs.1 | 8456 | 39429.9 ± 4.5% | 2674.2 ± 1.0% | 1531.0 ± 0.7% | 823.6 ± 1.4% | 1599.8 ± 0.4% | 1101.7 ± 0.5% | 14.744 | 25.754 | 47.873 | 24.646 | 35.791 |
| hex: canterbury-large/E.coli | 524290 | 43252.0 ± 1.1% | 2561.2 ± 0.6% | 1492.9 ± 0.4% | 810.2 ± 0.3% | 1561.5 ± 0.3% | 1054.5 ± 0.7% | 16.887 | 28.972 | 53.384 | 27.700 | 41.016 |
| hex: canterbury-large/bible.txt | 524290 | 43466.1 ± 0.3% | 2577.1 ± 0.8% | 1499.1 ± 0.3% | 486.1 ± 0.3% | 1553.1 ± 0.6% | 1052.7 ± 0.5% | 16.866 | 28.994 | 89.413 | 27.987 | 41.291 |
| hex: canterbury-large/world192.txt | 524290 | 43483.5 ± 0.3% | 2588.0 ± 0.5% | 1498.5 ± 0.3% | 464.2 ± 0.5% | 1568.9 ± 0.5% | 1059.1 ± 0.4% | 16.802 | 29.018 | 93.668 | 27.716 | 41.059 |
| hex: http/html-1kx1024 | 2099200 | 20462.3 ± 0.6% | 2456.8 ± 0.9% | 1454.7 ± 0.9% | 511.5 ± 1.2% | 1522.4 ± 0.7% | 1069.4 ± 0.7% | 8.329 | 14.066 | 40.003 | 13.440 | 19.134 |
| hex: http/html-16kx64 | 2097280 | 21489.5 ± 0.8% | 2379.1 ± 5.2% | 1445.2 ± 1.6% | 516.0 ± 0.3% | 1493.7 ± 1.0% | 1074.2 ± 5.1% | 9.033 | 14.870 | 41.643 | 14.386 | 20.005 |
| hex: http/html-1m | 524290 | 40183.1 ± 0.8% | 2591.9 ± 1.0% | 1504.0 ± 0.6% | 505.6 ± 0.9% | 1567.5 ± 0.6% | 1059.3 ± 0.6% | 15.504 | 26.718 | 79.472 | 25.635 | 37.935 |
| hex: http/json-1kx1024 | 2099200 | 20574.2 ± 0.4% | 2441.0 ± 1.1% | 1451.8 ± 5.1% | 687.1 ± 0.9% | 1528.3 ± 0.9% | 1071.8 ± 0.4% | 8.429 | 14.171 | 29.945 | 13.462 | 19.196 |
| hex: http/json-16kx64 | 2097280 | 22467.6 ± 0.4% | 2378.8 ± 0.6% | 1442.6 ± 1.0% | 698.1 ± 0.8% | 1498.6 ± 0.9% | 1080.4 ± 1.7% | 9.445 | 15.575 | 32.182 | 14.993 | 20.795 |
| hex: http/json-1m | 524290 | 42937.3 ± 0.6% | 2559.5 ± 1.0% | 1502.7 ± 0.8% | 722.7 ± 1.0% | 1567.3 ± 1.3% | 1056.9 ± 1.3% | 16.776 | 28.573 | 59.410 | 27.395 | 40.624 |
| hex: http/js-1kx1024 | 2099200 | 20308.6 ± 0.6% | 2447.7 ± 1.7% | 1458.0 ± 0.9% | 496.6 ± 1.1% | 1529.8 ± 1.4% | 1070.2 ± 1.2% | 8.297 | 13.929 | 40.899 | 13.275 | 18.977 |
| hex: http/js-16kx64 | 2097280 | 21992.3 ± 0.4% | 2382.4 ± 7.7% | 1446.3 ± 5.1% | 502.7 ± 1.2% | 1505.2 ± 1.0% | 1081.2 ± 0.8% | 9.231 | 15.206 | 43.747 | 14.611 | 20.341 |
| hex: http/js-1m | 524290 | 42445.7 ± 0.5% | 2593.8 ± 0.4% | 1506.5 ± 0.1% | 516.0 ± 0.6% | 1564.2 ± 0.5% | 1065.4 ± 0.7% | 16.364 | 28.176 | 82.256 | 27.135 | 39.839 |
| hex: http/css-1kx1024 | 2099200 | 20770.7 ± 0.8% | 2465.0 ± 1.0% | 1473.6 ± 0.3% | 578.1 ± 1.0% | 1541.2 ± 1.0% | 1077.5 ± 0.6% | 8.426 | 14.095 | 35.931 | 13.477 | 19.276 |
| hex: http/css-16kx64 | 2097280 | 22053.5 ± 0.1% | 2382.1 ± 8.1% | 1449.6 ± 0.6% | 586.4 ± 0.3% | 1506.8 ± 0.6% | 1087.0 ± 0.4% | 9.258 | 15.213 | 37.609 | 14.636 | 20.288 |
| hex: http/css-1m | 524290 | 42878.4 ± 0.6% | 2593.7 ± 0.6% | 1507.5 ± 5.7% | 558.6 ± 0.9% | 1536.2 ± 0.7% | 1054.9 ± 0.8% | 16.532 | 28.444 | 76.754 | 27.912 | 40.648 |
| hex: shuffled/dickens-1m | 524290 | 42784.7 ± 4.7% | 2590.3 ± 0.9% | 1500.6 ± 1.2% | 470.7 ± 2.2% | 1569.7 ± 1.0% | 1056.5 ± 2.6% | 16.517 | 28.513 | 90.888 | 27.256 | 40.497 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1803.1 ± 0.2% | 1467.4 ± 0.5% | 1021.0 ± 0.6% | 478.7 ± 0.5% | 469.9 ± 2.6% | 500.3 ± 5.1% | 1.229 | 1.766 | 3.767 | 3.837 | 3.604 |
| qlog records, JSON text sequence | 1467503 | 1715.6 ± 0.4% | 1234.6 ± 1.2% | 944.8 ± 1.0% | 455.3 ± 0.7% | 572.1 ± 0.7% | 350.1 ± 1.2% | 1.390 | 1.816 | 3.768 | 2.999 | 4.900 |
| string: silesia/dickens | 172528 | 13435.3 ± 3.7% | 3966.9 ± 1.2% | 3072.6 ± 1.1% | 357.3 ± 1.1% | 1719.4 ± 1.5% | 1190.1 ± 2.3% | 3.387 | 4.373 | 37.597 | 7.814 | 11.289 |
| string: silesia/nci | 1075110 | 11483.5 ± 0.5% | 4544.6 ± 1.2% | 3112.5 ± 1.2% | 854.8 ± 1.1% | 1912.3 ± 1.2% | 1285.2 ± 1.3% | 2.527 | 3.689 | 13.435 | 6.005 | 8.935 |
| string: silesia/reymont | 1075159 | 5442.3 ± 0.9% | 1829.4 ± 0.7% | 1892.6 ± 0.9% | 395.7 ± 1.1% | 1443.4 ± 0.5% | 1049.2 ± 1.0% | 2.975 | 2.876 | 13.753 | 3.770 | 5.187 |
| string: silesia/samba | 97582 | 7301.7 ± 0.7% | 2713.6 ± 0.9% | 4065.8 ± 1.3% | 376.8 ± 1.4% | 1326.4 ± 1.5% | 1179.3 ± 3.5% | 2.691 | 1.796 | 19.376 | 5.505 | 6.191 |
| string: silesia/webster | 1098490 | 6960.4 ± 1.2% | 1944.9 ± 1.2% | 1734.6 ± 1.6% | 387.8 ± 1.1% | 1396.9 ± 1.4% | 597.6 ± 3.2% | 3.579 | 4.013 | 17.950 | 4.983 | 11.648 |
| string: silesia/xml | 1090118 | 11257.3 ± 8.4% | 3152.6 ± 2.1% | 2505.4 ± 1.1% | 623.3 ± 1.4% | 1932.8 ± 1.0% | 960.6 ± 4.6% | 3.571 | 4.493 | 18.062 | 5.824 | 11.719 |
| string: canterbury/alice29.txt | 159425 | 13221.2 ± 0.3% | 2891.9 ± 1.2% | 3030.0 ± 2.4% | 341.5 ± 1.3% | 1532.5 ± 2.0% | 1087.7 ± 1.0% | 4.572 | 4.363 | 38.710 | 8.627 | 12.155 |
| string: canterbury/asyoulik.txt | 132198 | 11465.6 ± 0.6% | 2120.4 ± 1.0% | 3102.3 ± 0.9% | 348.0 ± 0.8% | 1364.9 ± 1.0% | 943.9 ± 2.7% | 5.407 | 3.696 | 32.952 | 8.400 | 12.146 |
| string: canterbury/lcet10.txt | 441884 | 12634.0 ± 0.7% | 3069.6 ± 0.3% | 2586.3 ± 3.3% | 385.8 ± 1.5% | 1656.1 ± 1.4% | 1199.7 ± 0.9% | 4.116 | 4.885 | 32.751 | 7.629 | 10.531 |
| string: canterbury/plrabn12.txt | 503330 | 8919.6 ± 2.0% | 2302.5 ± 1.0% | 2085.8 ± 0.8% | 363.2 ± 0.8% | 1614.0 ± 1.6% | 1118.8 ± 1.7% | 3.874 | 4.276 | 24.559 | 5.526 | 7.972 |
| string: canterbury-large/E.coli | 1048578 | 31416.2 ± 0.8% | 15490.8 ± 1.4% | 3458.5 ± 0.2% | 1688.0 ± 0.2% | 3130.5 ± 4.6% | 1406.6 ± 0.7% | 2.028 | 9.084 | 18.611 | 10.036 | 22.335 |
| string: canterbury-large/bible.txt | 1055886 | 9778.8 ± 0.5% | 4751.3 ± 1.3% | 2983.8 ± 2.4% | 419.1 ± 0.5% | 2209.3 ± 3.2% | 1477.2 ± 0.4% | 2.058 | 3.277 | 23.333 | 4.426 | 6.620 |
| string: canterbury-large/world192.txt | 1103121 | 6419.7 ± 1.1% | 1711.0 ± 0.8% | 1871.7 ± 3.9% | 388.7 ± 2.2% | 1395.6 ± 1.9% | 964.2 ± 1.4% | 3.752 | 3.430 | 16.515 | 4.600 | 6.658 |
| string: http/html-1m | 1058582 | 10127.7 ± 3.6% | 4346.9 ± 4.5% | 2863.1 ± 0.8% | 461.3 ± 0.4% | 2151.7 ± 0.7% | 845.7 ± 0.9% | 2.330 | 3.537 | 21.953 | 4.707 | 11.975 |
| string: http/json-1m | 1190272 | 8569.1 ± 0.7% | 1575.0 ± 5.2% | 1562.0 ± 0.2% | 538.3 ± 0.6% | 1155.6 ± 0.6% | 850.8 ± 1.4% | 5.441 | 5.486 | 15.918 | 7.415 | 10.072 |
| string: http/js-1m | 1144362 | 6624.6 ± 2.2% | 1116.4 ± 0.8% | 1385.8 ± 0.6% | 359.9 ± 0.6% | 1127.7 ± 3.3% | 754.3 ± 0.8% | 5.934 | 4.781 | 18.409 | 5.875 | 8.782 |
| string: http/css-1m | 1097820 | 9253.7 ± 1.2% | 1483.6 ± 0.5% | 2296.5 ± 0.6% | 546.3 ± 0.5% | 1268.5 ± 1.0% | 881.7 ± 1.1% | 6.237 | 4.030 | 16.940 | 7.295 | 10.496 |
| string: dickens as Cyrillic and CJK | 1883069 | 5689.8 ± 0.8% | 3676.0 ± 1.2% | 482.2 ± 1.1% | 250.8 ± 0.8% | 462.8 ± 0.6% | 354.6 ± 0.4% | 1.548 | 11.799 | 22.689 | 12.293 | 16.046 |
| hex: silesia/dickens | 524290 | 41865.7 ± 2.4% | 2569.8 ± 0.7% | 1507.2 ± 1.2% | 471.1 ± 0.7% | 1564.9 ± 5.0% | 1053.2 ± 0.8% | 16.292 | 27.777 | 88.872 | 26.754 | 39.752 |
| hex: silesia/mozilla | 524290 | 42660.5 ± 2.4% | 2569.4 ± 0.6% | 1492.6 ± 4.4% | 418.6 ± 1.3% | 1563.1 ± 1.0% | 1063.1 ± 1.1% | 16.603 | 28.581 | 101.917 | 27.293 | 40.129 |
| hex: silesia/mr | 524290 | 42772.0 ± 1.2% | 2564.2 ± 0.7% | 1499.1 ± 0.6% | 603.4 ± 2.1% | 1540.9 ± 1.1% | 1056.2 ± 3.1% | 16.680 | 28.532 | 70.886 | 27.757 | 40.494 |
| hex: silesia/nci | 524290 | 43548.4 ± 0.7% | 2561.7 ± 0.7% | 1495.3 ± 0.5% | 753.1 ± 0.3% | 1567.6 ± 0.5% | 1059.4 ± 0.2% | 17.000 | 29.123 | 57.825 | 27.780 | 41.106 |
| hex: silesia/ooffice | 524290 | 42740.1 ± 1.0% | 2578.8 ± 0.8% | 1493.3 ± 0.6% | 342.7 ± 1.0% | 1543.5 ± 1.0% | 1054.1 ± 0.7% | 16.573 | 28.621 | 124.722 | 27.690 | 40.547 |
| hex: silesia/osdb | 524290 | 41902.0 ± 1.6% | 2583.6 ± 1.1% | 1499.8 ± 1.0% | 453.5 ± 1.1% | 1569.2 ± 0.3% | 1054.2 ± 0.6% | 16.218 | 27.938 | 92.388 | 26.703 | 39.747 |
| hex: silesia/reymont | 524290 | 43531.1 ± 0.9% | 2593.2 ± 0.6% | 1498.8 ± 0.9% | 489.8 ± 3.6% | 1545.7 ± 5.0% | 1060.8 ± 0.7% | 16.787 | 29.044 | 88.870 | 28.163 | 41.035 |
| hex: silesia/samba | 524290 | 43295.9 ± 1.9% | 2571.2 ± 9.5% | 1497.2 ± 0.9% | 365.3 ± 3.5% | 1574.1 ± 0.7% | 1052.9 ± 0.9% | 16.839 | 28.917 | 118.528 | 27.506 | 41.120 |
| hex: silesia/sao | 524290 | 43164.6 ± 1.5% | 2592.3 ± 0.9% | 1495.9 ± 0.8% | 280.6 ± 0.9% | 1546.7 ± 0.3% | 1054.9 ± 1.6% | 16.651 | 28.856 | 153.814 | 27.908 | 40.920 |
| hex: silesia/webster | 524290 | 43719.5 ± 1.0% | 2576.5 ± 8.8% | 1499.0 ± 0.5% | 449.6 ± 0.5% | 1550.2 ± 0.6% | 1052.4 ± 0.7% | 16.968 | 29.165 | 97.231 | 28.202 | 41.541 |
| hex: silesia/x-ray | 524290 | 43411.4 ± 1.6% | 2579.7 ± 1.1% | 1497.4 ± 0.7% | 426.6 ± 2.5% | 1551.1 ± 3.2% | 1053.6 ± 1.0% | 16.828 | 28.990 | 101.750 | 27.987 | 41.201 |
| hex: silesia/xml | 524290 | 43453.4 ± 0.5% | 2567.3 ± 1.2% | 1498.3 ± 3.8% | 725.6 ± 1.4% | 1554.3 ± 0.5% | 1056.5 ± 1.0% | 16.926 | 29.001 | 59.883 | 27.957 | 41.131 |
| hex: canterbury/alice29.txt | 304180 | 41569.8 ± 1.1% | 2603.3 ± 7.2% | 1518.2 ± 0.5% | 477.0 ± 0.8% | 1581.6 ± 0.8% | 1077.4 ± 0.7% | 15.968 | 27.381 | 87.151 | 26.284 | 38.585 |
| hex: canterbury/asyoulik.txt | 250360 | 43241.9 ± 0.8% | 2609.7 ± 0.5% | 1526.3 ± 0.5% | 465.8 ± 0.4% | 1582.8 ± 0.4% | 1080.8 ± 1.1% | 16.569 | 28.331 | 92.826 | 27.320 | 40.008 |
| hex: canterbury/cp.html | 49208 | 42597.8 ± 1.7% | 2583.7 ± 0.9% | 1516.9 ± 0.4% | 512.3 ± 0.6% | 1585.3 ± 0.2% | 1083.2 ± 0.5% | 16.487 | 28.082 | 83.149 | 26.870 | 39.324 |
| hex: canterbury/fields.c | 22302 | 41704.1 ± 1.3% | 2649.1 ± 1.0% | 1526.9 ± 0.6% | 628.8 ± 1.1% | 1595.5 ± 4.3% | 1089.1 ± 1.1% | 15.743 | 27.313 | 66.328 | 26.139 | 38.291 |
| hex: canterbury/grammar.lsp | 7444 | 38937.6 ± 2.1% | 2678.5 ± 0.6% | 1527.9 ± 1.2% | 799.7 ± 0.6% | 1603.3 ± 0.8% | 1101.2 ± 0.7% | 14.537 | 25.484 | 48.693 | 24.286 | 35.361 |
| hex: canterbury/kennedy.xls | 524290 | 42850.7 ± 2.7% | 2569.5 ± 0.7% | 1498.0 ± 0.9% | 747.6 ± 1.2% | 1564.8 ± 6.1% | 1058.7 ± 1.2% | 16.677 | 28.605 | 57.318 | 27.384 | 40.473 |
| hex: canterbury/lcet10.txt | 524290 | 42674.3 ± 0.4% | 2593.6 ± 0.4% | 1511.1 ± 1.3% | 479.6 ± 1.2% | 1579.6 ± 0.8% | 1065.2 ± 0.8% | 16.454 | 28.240 | 88.975 | 27.015 | 40.062 |
| hex: canterbury/plrabn12.txt | 524290 | 43186.1 ± 1.6% | 2589.5 ± 0.7% | 1500.3 ± 0.5% | 461.8 ± 0.8% | 1571.3 ± 0.8% | 1056.8 ± 5.2% | 16.677 | 28.785 | 93.524 | 27.485 | 40.865 |
| hex: canterbury/ptt5 | 524290 | 42909.9 ± 1.5% | 2558.1 ± 0.6% | 1491.8 ± 0.7% | 609.0 ± 0.9% | 1542.9 ± 0.8% | 1051.0 ± 0.7% | 16.774 | 28.763 | 70.455 | 27.812 | 40.829 |
| hex: canterbury/sum | 76482 | 42190.7 ± 0.8% | 2573.0 ± 0.3% | 1507.2 ± 0.5% | 588.7 ± 0.8% | 1572.6 ± 1.3% | 1077.6 ± 2.4% | 16.398 | 27.992 | 71.666 | 26.829 | 39.154 |
| hex: canterbury/xargs.1 | 8456 | 39921.8 ± 1.5% | 2674.2 ± 1.0% | 1531.0 ± 0.7% | 823.6 ± 1.4% | 1599.8 ± 0.4% | 1101.7 ± 0.5% | 14.928 | 26.075 | 48.470 | 24.954 | 36.237 |
| hex: canterbury-large/E.coli | 524290 | 43031.0 ± 1.3% | 2561.2 ± 0.6% | 1492.9 ± 0.4% | 810.2 ± 0.3% | 1561.5 ± 0.3% | 1054.5 ± 0.7% | 16.801 | 28.824 | 53.111 | 27.558 | 40.806 |
| hex: canterbury-large/bible.txt | 524290 | 43382.7 ± 0.4% | 2577.1 ± 0.8% | 1499.1 ± 0.3% | 486.1 ± 0.3% | 1553.1 ± 0.6% | 1052.7 ± 0.5% | 16.834 | 28.939 | 89.242 | 27.933 | 41.211 |
| hex: canterbury-large/world192.txt | 524290 | 42929.7 ± 4.1% | 2588.0 ± 0.5% | 1498.5 ± 0.3% | 464.2 ± 0.5% | 1568.9 ± 0.5% | 1059.1 ± 0.4% | 16.588 | 28.649 | 92.475 | 27.363 | 40.536 |
| hex: http/html-1kx1024 | 2099200 | 20585.8 ± 0.2% | 2456.8 ± 0.9% | 1454.7 ± 0.9% | 511.5 ± 1.2% | 1522.4 ± 0.7% | 1069.4 ± 0.7% | 8.379 | 14.151 | 40.244 | 13.522 | 19.250 |
| hex: http/html-16kx64 | 2097280 | 21530.3 ± 0.6% | 2379.1 ± 5.2% | 1445.2 ± 1.6% | 516.0 ± 0.3% | 1493.7 ± 1.0% | 1074.2 ± 5.1% | 9.050 | 14.898 | 41.722 | 14.414 | 20.043 |
| hex: http/html-1m | 524290 | 40091.7 ± 1.7% | 2591.9 ± 1.0% | 1504.0 ± 0.6% | 505.6 ± 0.9% | 1567.5 ± 0.6% | 1059.3 ± 0.6% | 15.468 | 26.657 | 79.291 | 25.577 | 37.849 |
| hex: http/json-1kx1024 | 2099200 | 20578.3 ± 2.8% | 2441.0 ± 1.1% | 1451.8 ± 5.1% | 687.1 ± 0.9% | 1528.3 ± 0.9% | 1071.8 ± 0.4% | 8.430 | 14.174 | 29.950 | 13.465 | 19.200 |
| hex: http/json-16kx64 | 2097280 | 22526.6 ± 0.6% | 2378.8 ± 0.6% | 1442.6 ± 1.0% | 698.1 ± 0.8% | 1498.6 ± 0.9% | 1080.4 ± 1.7% | 9.470 | 15.616 | 32.267 | 15.032 | 20.850 |
| hex: http/json-1m | 524290 | 42742.8 ± 0.4% | 2559.5 ± 1.0% | 1502.7 ± 0.8% | 722.7 ± 1.0% | 1567.3 ± 1.3% | 1056.9 ± 1.3% | 16.700 | 28.444 | 59.141 | 27.271 | 40.440 |
| hex: http/js-1kx1024 | 2099200 | 20447.4 ± 1.0% | 2447.7 ± 1.7% | 1458.0 ± 0.9% | 496.6 ± 1.1% | 1529.8 ± 1.4% | 1070.2 ± 1.2% | 8.354 | 14.024 | 41.179 | 13.366 | 19.107 |
| hex: http/js-16kx64 | 2097280 | 22047.8 ± 0.1% | 2382.4 ± 7.7% | 1446.3 ± 5.1% | 502.7 ± 1.2% | 1505.2 ± 1.0% | 1081.2 ± 0.8% | 9.255 | 15.244 | 43.857 | 14.648 | 20.392 |
| hex: http/js-1m | 524290 | 41858.6 ± 0.4% | 2593.8 ± 0.4% | 1506.5 ± 0.1% | 516.0 ± 0.6% | 1564.2 ± 0.5% | 1065.4 ± 0.7% | 16.138 | 27.786 | 81.118 | 26.760 | 39.288 |
| hex: http/css-1kx1024 | 2099200 | 20898.2 ± 0.5% | 2465.0 ± 1.0% | 1473.6 ± 0.3% | 578.1 ± 1.0% | 1541.2 ± 1.0% | 1077.5 ± 0.6% | 8.478 | 14.181 | 36.152 | 13.559 | 19.395 |
| hex: http/css-16kx64 | 2097280 | 22149.8 ± 0.3% | 2382.1 ± 8.1% | 1449.6 ± 0.6% | 586.4 ± 0.3% | 1506.8 ± 0.6% | 1087.0 ± 0.4% | 9.298 | 15.280 | 37.773 | 14.700 | 20.377 |
| hex: http/css-1m | 524290 | 42752.5 ± 0.7% | 2593.7 ± 0.6% | 1507.5 ± 5.7% | 558.6 ± 0.9% | 1536.2 ± 0.7% | 1054.9 ± 0.8% | 16.483 | 28.360 | 76.528 | 27.830 | 40.529 |
| hex: shuffled/dickens-1m | 524290 | 42840.1 ± 1.1% | 2590.3 ± 0.9% | 1500.6 ± 1.2% | 470.7 ± 2.2% | 1569.7 ± 1.0% | 1056.5 ± 2.6% | 16.539 | 28.550 | 91.006 | 27.292 | 40.550 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1144.6 ± 0.8% | 1490.6 ± 2.2% | 1076.8 ± 1.0% | 401.7 ± 0.8% | 664.7 ± 0.4% | 364.7 ± 1.5% | 0.768 | 1.063 | 2.849 | 1.722 | 3.138 |
| qlog records, JSON text sequence | 1467503 | 1018.4 ± 0.4% | 1237.2 ± 0.4% | 1129.4 ± 0.7% | 345.5 ± 1.5% | 754.8 ± 0.6% | 319.2 ± 0.5% | 0.823 | 0.902 | 2.948 | 1.349 | 3.190 |
| string: silesia/dickens | 172528 | 6525.5 ± 5.0% | 3466.6 ± 0.6% | 2868.9 ± 1.5% | 309.0 ± 0.4% | 3024.7 ± 3.5% | 572.7 ± 2.4% | 1.882 | 2.275 | 21.121 | 2.157 | 11.394 |
| string: silesia/nci | 1075110 | 5439.8 ± 0.7% | 3925.4 ± 0.9% | 3033.6 ± 0.5% | 642.4 ± 0.5% | 3635.8 ± 0.3% | 560.3 ± 3.0% | 1.386 | 1.793 | 8.468 | 1.496 | 9.709 |
| string: silesia/reymont | 1075159 | 3508.9 ± 2.3% | 3417.8 ± 0.3% | 1952.1 ± 0.5% | 326.8 ± 3.8% | 2104.4 ± 0.3% | 477.7 ± 2.2% | 1.027 | 1.797 | 10.737 | 1.667 | 7.345 |
| string: silesia/samba | 97582 | 3986.8 ± 1.4% | 3798.0 ± 3.7% | 3070.2 ± 0.5% | 333.6 ± 1.3% | 1907.3 ± 0.7% | 417.0 ± 0.7% | 1.050 | 1.299 | 11.949 | 2.090 | 9.562 |
| string: silesia/webster | 1098490 | 4418.1 ± 0.6% | 2423.5 ± 0.2% | 1731.8 ± 2.6% | 300.5 ± 0.5% | 2048.1 ± 1.6% | 457.3 ± 1.4% | 1.823 | 2.551 | 14.702 | 2.157 | 9.661 |
| string: silesia/xml | 1090118 | 6059.7 ± 0.5% | 4985.5 ± 3.3% | 2427.9 ± 3.7% | 501.4 ± 2.9% | 3297.1 ± 3.7% | 537.9 ± 4.9% | 1.215 | 2.496 | 12.085 | 1.838 | 11.265 |
| string: canterbury/alice29.txt | 159425 | 5738.3 ± 0.5% | 2761.1 ± 1.3% | 2777.9 ± 1.2% | 294.1 ± 0.9% | 2742.2 ± 0.5% | 515.3 ± 3.4% | 2.078 | 2.066 | 19.512 | 2.093 | 11.135 |
| string: canterbury/asyoulik.txt | 132198 | 4263.5 ± 1.6% | 2580.7 ± 5.5% | 2785.3 ± 1.1% | 296.5 ± 0.5% | 2373.8 ± 2.1% | 450.8 ± 2.3% | 1.652 | 1.531 | 14.380 | 1.796 | 9.458 |
| string: canterbury/lcet10.txt | 441884 | 6633.7 ± 0.6% | 3282.0 ± 1.2% | 2329.3 ± 0.9% | 338.5 ± 2.0% | 2763.3 ± 0.7% | 566.5 ± 1.0% | 2.021 | 2.848 | 19.597 | 2.401 | 11.709 |
| string: canterbury/plrabn12.txt | 503330 | 5439.6 ± 0.6% | 3120.2 ± 1.3% | 1825.0 ± 0.7% | 319.3 ± 0.4% | 2799.2 ± 0.4% | 530.0 ± 0.8% | 1.743 | 2.981 | 17.037 | 1.943 | 10.263 |
| string: canterbury-large/E.coli | 1048578 | 33919.0 ± 0.3% | 12893.1 ± 0.7% | 3379.7 ± 0.6% | 1277.5 ± 0.4% | 8885.8 ± 0.6% | 914.4 ± 5.6% | 2.631 | 10.036 | 26.552 | 3.817 | 37.093 |
| string: canterbury-large/bible.txt | 1055886 | 8547.1 ± 0.4% | 5220.8 ± 1.1% | 2775.7 ± 0.7% | 350.9 ± 0.5% | 3833.7 ± 0.9% | 623.8 ± 2.6% | 1.637 | 3.079 | 24.361 | 2.229 | 13.701 |
| string: canterbury-large/world192.txt | 1103121 | 4132.3 ± 1.0% | 2300.4 ± 0.4% | 1758.0 ± 0.7% | 327.7 ± 1.4% | 2099.8 ± 0.7% | 462.2 ± 4.3% | 1.796 | 2.351 | 12.609 | 1.968 | 8.940 |
| string: http/html-1m | 1058582 | 8776.0 ± 4.0% | 4702.2 ± 1.3% | 2668.1 ± 0.6% | 400.6 ± 0.9% | 3596.9 ± 0.8% | 587.9 ± 1.4% | 1.866 | 3.289 | 21.906 | 2.440 | 14.928 |
| string: http/json-1m | 1190272 | 3309.4 ± 0.9% | 1250.9 ± 0.7% | 2027.2 ± 0.4% | 476.8 ± 0.5% | 1337.3 ± 0.5% | 435.3 ± 0.7% | 2.646 | 1.633 | 6.940 | 2.475 | 7.602 |
| string: http/js-1m | 1144362 | 2888.2 ± 0.8% | 1600.7 ± 0.3% | 1327.4 ± 1.0% | 320.8 ± 0.8% | 1415.7 ± 1.2% | 376.8 ± 2.1% | 1.804 | 2.176 | 9.002 | 2.040 | 7.665 |
| string: http/css-1m | 1097820 | 3300.4 ± 1.4% | 2864.7 ± 3.1% | 2255.3 ± 0.4% | 439.9 ± 2.7% | 2065.0 ± 0.6% | 433.6 ± 1.2% | 1.152 | 1.463 | 7.503 | 1.598 | 7.611 |
| string: dickens as Cyrillic and CJK | 1883069 | 5784.3 ± 0.5% | 2991.8 ± 2.3% | 659.5 ± 0.6% | 369.8 ± 1.0% | 510.8 ± 0.6% | 162.8 ± 2.4% | 1.933 | 8.771 | 15.641 | 11.323 | 35.539 |
| string: dickens as Cyrillic and CJK, as \u escapes | 5075485 | 1202.2 ± 0.9% | 1236.2 ± 1.1% | 1091.3 ± 1.3% | 265.7 ± 1.3% | 477.2 ± 1.4% | 224.9 ± 1.7% | 0.972 | 1.102 | 4.524 | 2.519 | 5.346 |
| hex: silesia/dickens | 524290 | 33817.5 ± 0.9% | 15035.4 ± 0.7% | 3482.3 ± 1.4% | 480.0 ± 0.9% | 8896.4 ± 1.3% | 1125.1 ± 3.0% | 2.249 | 9.711 | 70.457 | 3.801 | 30.058 |
| hex: silesia/mozilla | 524290 | 33778.8 ± 0.7% | 15021.5 ± 0.9% | 3551.8 ± 0.7% | 428.2 ± 0.5% | 8884.7 ± 0.8% | 1120.8 ± 1.5% | 2.249 | 9.510 | 78.878 | 3.802 | 30.137 |
| hex: silesia/mr | 524290 | 33832.8 ± 0.4% | 15021.1 ± 0.8% | 3549.6 ± 1.8% | 642.5 ± 3.1% | 8888.4 ± 1.2% | 1127.0 ± 0.5% | 2.252 | 9.531 | 52.656 | 3.806 | 30.021 |
| hex: silesia/nci | 524290 | 34009.6 ± 0.2% | 15115.4 ± 1.0% | 3500.9 ± 4.1% | 797.1 ± 1.8% | 8928.5 ± 1.2% | 1126.3 ± 1.7% | 2.250 | 9.714 | 42.669 | 3.809 | 30.196 |
| hex: silesia/ooffice | 524290 | 33968.6 ± 1.2% | 15100.9 ± 0.9% | 3565.0 ± 1.1% | 344.8 ± 1.9% | 8939.3 ± 5.3% | 1127.7 ± 1.2% | 2.249 | 9.528 | 98.520 | 3.800 | 30.122 |
| hex: silesia/osdb | 524290 | 33740.8 ± 1.3% | 14987.9 ± 0.7% | 3547.3 ± 1.0% | 448.3 ± 0.6% | 8857.1 ± 0.6% | 1119.7 ± 0.8% | 2.251 | 9.512 | 75.267 | 3.809 | 30.133 |
| hex: silesia/reymont | 524290 | 33733.9 ± 1.1% | 15015.8 ± 0.4% | 3474.6 ± 0.9% | 502.4 ± 0.7% | 8863.2 ± 0.9% | 1118.5 ± 1.4% | 2.247 | 9.709 | 67.150 | 3.806 | 30.161 |
| hex: silesia/samba | 524290 | 33805.0 ± 0.4% | 15014.5 ± 0.5% | 3544.2 ± 0.5% | 363.6 ± 1.4% | 8897.2 ± 0.7% | 1120.5 ± 1.6% | 2.251 | 9.538 | 92.976 | 3.799 | 30.169 |
| hex: silesia/sao | 524290 | 33881.4 ± 0.2% | 15068.0 ± 0.6% | 3443.2 ± 0.8% | 275.2 ± 2.2% | 8844.6 ± 0.6% | 1127.4 ± 1.2% | 2.249 | 9.840 | 123.127 | 3.831 | 30.052 |
| hex: silesia/webster | 524290 | 33953.9 ± 0.6% | 15121.6 ± 2.7% | 3561.6 ± 0.7% | 452.0 ± 0.4% | 8921.4 ± 0.2% | 1138.5 ± 0.4% | 2.245 | 9.533 | 75.117 | 3.806 | 29.822 |
| hex: silesia/x-ray | 524290 | 33973.8 ± 0.1% | 15144.0 ± 0.3% | 3499.5 ± 1.3% | 424.1 ± 0.5% | 8913.5 ± 0.9% | 1134.9 ± 0.6% | 2.243 | 9.708 | 80.108 | 3.812 | 29.935 |
| hex: silesia/xml | 524290 | 33929.6 ± 4.0% | 15146.3 ± 0.7% | 3569.1 ± 0.6% | 732.3 ± 1.5% | 8911.2 ± 0.3% | 1131.3 ± 1.5% | 2.240 | 9.506 | 46.335 | 3.808 | 29.992 |
| hex: canterbury/alice29.txt | 304180 | 33913.4 ± 0.9% | 14164.8 ± 0.9% | 3567.4 ± 0.3% | 486.3 ± 0.7% | 8914.9 ± 0.4% | 1148.4 ± 0.3% | 2.394 | 9.506 | 69.743 | 3.804 | 29.530 |
| hex: canterbury/asyoulik.txt | 250360 | 33909.6 ± 0.2% | 15117.5 ± 0.1% | 3503.0 ± 0.2% | 473.5 ± 0.5% | 8913.1 ± 0.1% | 1145.8 ± 0.7% | 2.243 | 9.680 | 71.614 | 3.804 | 29.594 |
| hex: canterbury/cp.html | 49208 | 33388.3 ± 0.9% | 14389.8 ± 0.8% | 3551.1 ± 0.8% | 502.3 ± 1.3% | 9216.4 ± 0.6% | 1119.7 ± 2.6% | 2.320 | 9.402 | 66.473 | 3.623 | 29.818 |
| hex: canterbury/fields.c | 22302 | 32759.2 ± 0.8% | 17430.2 ± 2.4% | 3647.1 ± 0.6% | 561.7 ± 0.9% | 9206.7 ± 0.6% | 1100.7 ± 0.3% | 1.879 | 8.982 | 58.317 | 3.558 | 29.761 |
| hex: canterbury/grammar.lsp | 7444 | 29760.5 ± 0.7% | 17138.1 ± 4.4% | 3610.0 ± 1.8% | 762.0 ± 1.1% | 8925.3 ± 0.6% | 1056.3 ± 2.1% | 1.737 | 8.244 | 39.055 | 3.334 | 28.175 |
| hex: canterbury/kennedy.xls | 524290 | 33828.0 ± 0.4% | 14996.9 ± 0.8% | 3515.3 ± 0.5% | 749.4 ± 1.4% | 8854.9 ± 0.4% | 1101.3 ± 5.5% | 2.256 | 9.623 | 45.139 | 3.820 | 30.716 |
| hex: canterbury/lcet10.txt | 524290 | 33734.3 ± 1.1% | 15021.1 ± 1.1% | 3537.6 ± 1.6% | 484.6 ± 2.1% | 8840.4 ± 3.4% | 1119.8 ± 3.4% | 2.246 | 9.536 | 69.607 | 3.816 | 30.124 |
| hex: canterbury/plrabn12.txt | 524290 | 33808.6 ± 0.6% | 15069.7 ± 0.7% | 3563.8 ± 0.4% | 467.5 ± 1.1% | 8886.2 ± 0.8% | 1116.4 ± 2.3% | 2.243 | 9.487 | 72.316 | 3.805 | 30.284 |
| hex: canterbury/ptt5 | 524290 | 33910.0 ± 0.3% | 15089.5 ± 0.8% | 3492.0 ± 0.8% | 665.8 ± 0.9% | 8886.5 ± 0.6% | 1122.5 ± 2.4% | 2.247 | 9.711 | 50.934 | 3.816 | 30.208 |
| hex: canterbury/sum | 76482 | 33271.7 ± 0.5% | 15419.0 ± 0.4% | 3561.8 ± 0.3% | 585.2 ± 0.6% | 8905.4 ± 0.4% | 1123.4 ± 1.1% | 2.158 | 9.341 | 56.860 | 3.736 | 29.617 |
| hex: canterbury/xargs.1 | 8456 | 30311.9 ± 0.8% | 17389.4 ± 0.8% | 3560.5 ± 0.7% | 736.8 ± 2.6% | 8940.7 ± 0.7% | 1104.3 ± 1.6% | 1.743 | 8.513 | 41.142 | 3.390 | 27.450 |
| hex: canterbury-large/E.coli | 524290 | 33779.3 ± 0.3% | 15025.3 ± 3.4% | 3468.6 ± 0.3% | 954.1 ± 2.9% | 8853.0 ± 0.7% | 1117.5 ± 3.4% | 2.248 | 9.738 | 35.404 | 3.816 | 30.226 |
| hex: canterbury-large/bible.txt | 524290 | 33815.0 ± 1.1% | 15055.8 ± 0.8% | 3480.0 ± 1.6% | 500.4 ± 0.8% | 8857.2 ± 1.1% | 1116.6 ± 1.9% | 2.246 | 9.717 | 67.582 | 3.818 | 30.284 |
| hex: canterbury-large/world192.txt | 524290 | 33845.7 ± 1.1% | 14999.7 ± 3.3% | 3570.1 ± 0.9% | 469.7 ± 1.1% | 8919.2 ± 1.3% | 1123.0 ± 1.6% | 2.256 | 9.480 | 72.060 | 3.795 | 30.140 |
| hex: http/html-1kx1024 | 2099200 | 15130.5 ± 0.7% | 12459.3 ± 3.1% | 3157.1 ± 0.5% | 508.4 ± 0.4% | 7388.7 ± 1.3% | 951.0 ± 3.2% | 1.214 | 4.793 | 29.762 | 2.048 | 15.909 |
| hex: http/html-16kx64 | 2097280 | 27616.5 ± 0.8% | 13864.7 ± 1.1% | 3399.1 ± 2.9% | 516.5 ± 1.0% | 8494.7 ± 1.1% | 1072.2 ± 3.4% | 1.992 | 8.125 | 53.473 | 3.251 | 25.756 |
| hex: http/html-1m | 524290 | 33723.4 ± 1.1% | 15000.9 ± 0.7% | 3474.5 ± 0.9% | 504.8 ± 1.5% | 8862.2 ± 1.4% | 1114.4 ± 1.7% | 2.248 | 9.706 | 66.806 | 3.805 | 30.261 |
| hex: http/json-1kx1024 | 2099200 | 15021.5 ± 0.4% | 12356.4 ± 0.4% | 3136.1 ± 1.0% | 679.6 ± 1.3% | 7450.0 ± 0.8% | 966.1 ± 1.4% | 1.216 | 4.790 | 22.103 | 2.016 | 15.549 |
| hex: http/json-16kx64 | 2097280 | 27665.0 ± 1.8% | 13992.3 ± 0.5% | 3386.7 ± 0.5% | 694.9 ± 0.8% | 8472.3 ± 0.4% | 1067.1 ± 4.2% | 1.977 | 8.169 | 39.813 | 3.265 | 25.925 |
| hex: http/json-1m | 524290 | 33961.2 ± 0.6% | 15114.5 ± 0.6% | 3535.9 ± 0.8% | 714.1 ± 0.4% | 8920.7 ± 0.3% | 1117.2 ± 1.6% | 2.247 | 9.605 | 47.558 | 3.807 | 30.398 |
| hex: http/js-1kx1024 | 2099200 | 15020.8 ± 0.8% | 12232.3 ± 5.4% | 3151.3 ± 0.4% | 492.1 ± 0.2% | 7482.6 ± 1.6% | 952.7 ± 2.7% | 1.228 | 4.766 | 30.525 | 2.007 | 15.766 |
| hex: http/js-16kx64 | 2097280 | 27264.5 ± 1.2% | 13978.1 ± 0.5% | 3385.0 ± 1.0% | 499.3 ± 0.8% | 8313.2 ± 1.7% | 1066.1 ± 5.8% | 1.951 | 8.054 | 54.609 | 3.280 | 25.574 |
| hex: http/js-1m | 524290 | 33858.6 ± 1.1% | 14989.8 ± 1.2% | 3559.4 ± 1.0% | 516.6 ± 1.3% | 8857.2 ± 0.9% | 1106.0 ± 2.4% | 2.259 | 9.512 | 65.537 | 3.823 | 30.613 |
| hex: http/css-1kx1024 | 2099200 | 15089.5 ± 1.2% | 12197.6 ± 12.1% | 3134.7 ± 1.0% | 565.3 ± 0.9% | 7412.7 ± 1.6% | 958.4 ± 2.7% | 1.237 | 4.814 | 26.691 | 2.036 | 15.744 |
| hex: http/css-16kx64 | 2097280 | 27277.3 ± 0.9% | 13753.0 ± 0.9% | 3362.3 ± 0.7% | 577.6 ± 2.8% | 8462.6 ± 1.1% | 1057.0 ± 4.9% | 1.983 | 8.113 | 47.222 | 3.223 | 25.805 |
| hex: http/css-1m | 524290 | 33948.3 ± 1.0% | 15020.6 ± 0.9% | 3531.2 ± 1.0% | 558.6 ± 1.2% | 8871.9 ± 4.2% | 1109.4 ± 4.2% | 2.260 | 9.614 | 60.774 | 3.827 | 30.600 |
| hex: shuffled/dickens-1m | 524290 | 33710.4 ± 0.7% | 15067.8 ± 0.5% | 3477.7 ± 1.0% | 478.7 ± 2.1% | 8867.4 ± 0.8% | 1126.5 ± 1.6% | 2.237 | 9.693 | 70.417 | 3.802 | 29.925 |

## TextReader.next_items against the baselines

stdx's decoder a slice of tokens a call through `TextReader.next_items`, as a caller that reads a text's values in a loop calls it (decision 79). Octets are the text's. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1304.1 ± 1.1% | 1490.6 ± 2.2% | 1076.8 ± 1.0% | 401.7 ± 0.8% | 664.7 ± 0.4% | 364.7 ± 1.5% | 0.875 | 1.211 | 3.246 | 1.962 | 3.576 |
| qlog records, JSON text sequence | 1467503 | 1181.0 ± 1.2% | 1237.2 ± 0.4% | 1129.4 ± 0.7% | 345.5 ± 1.5% | 754.8 ± 0.6% | 319.2 ± 0.5% | 0.955 | 1.046 | 3.419 | 1.565 | 3.699 |
| string: silesia/dickens | 172528 | 6546.9 ± 3.2% | 3466.6 ± 0.6% | 2868.9 ± 1.5% | 309.0 ± 0.4% | 3024.7 ± 3.5% | 572.7 ± 2.4% | 1.889 | 2.282 | 21.190 | 2.164 | 11.432 |
| string: silesia/nci | 1075110 | 5457.0 ± 0.3% | 3925.4 ± 0.9% | 3033.6 ± 0.5% | 642.4 ± 0.5% | 3635.8 ± 0.3% | 560.3 ± 3.0% | 1.390 | 1.799 | 8.495 | 1.501 | 9.740 |
| string: silesia/reymont | 1075159 | 3534.3 ± 2.5% | 3417.8 ± 0.3% | 1952.1 ± 0.5% | 326.8 ± 3.8% | 2104.4 ± 0.3% | 477.7 ± 2.2% | 1.034 | 1.810 | 10.814 | 1.679 | 7.398 |
| string: silesia/samba | 97582 | 4030.5 ± 1.1% | 3798.0 ± 3.7% | 3070.2 ± 0.5% | 333.6 ± 1.3% | 1907.3 ± 0.7% | 417.0 ± 0.7% | 1.061 | 1.313 | 12.080 | 2.113 | 9.667 |
| string: silesia/webster | 1098490 | 4433.3 ± 0.6% | 2423.5 ± 0.2% | 1731.8 ± 2.6% | 300.5 ± 0.5% | 2048.1 ± 1.6% | 457.3 ± 1.4% | 1.829 | 2.560 | 14.752 | 2.165 | 9.694 |
| string: silesia/xml | 1090118 | 6100.1 ± 0.8% | 4985.5 ± 3.3% | 2427.9 ± 3.7% | 501.4 ± 2.9% | 3297.1 ± 3.7% | 537.9 ± 4.9% | 1.224 | 2.513 | 12.165 | 1.850 | 11.340 |
| string: canterbury/alice29.txt | 159425 | 5755.0 ± 1.1% | 2761.1 ± 1.3% | 2777.9 ± 1.2% | 294.1 ± 0.9% | 2742.2 ± 0.5% | 515.3 ± 3.4% | 2.084 | 2.072 | 19.569 | 2.099 | 11.167 |
| string: canterbury/asyoulik.txt | 132198 | 4299.2 ± 1.2% | 2580.7 ± 5.5% | 2785.3 ± 1.1% | 296.5 ± 0.5% | 2373.8 ± 2.1% | 450.8 ± 2.3% | 1.666 | 1.544 | 14.501 | 1.811 | 9.537 |
| string: canterbury/lcet10.txt | 441884 | 6677.3 ± 1.0% | 3282.0 ± 1.2% | 2329.3 ± 0.9% | 338.5 ± 2.0% | 2763.3 ± 0.7% | 566.5 ± 1.0% | 2.034 | 2.867 | 19.726 | 2.416 | 11.786 |
| string: canterbury/plrabn12.txt | 503330 | 5445.7 ± 0.6% | 3120.2 ± 1.3% | 1825.0 ± 0.7% | 319.3 ± 0.4% | 2799.2 ± 0.4% | 530.0 ± 0.8% | 1.745 | 2.984 | 17.056 | 1.945 | 10.274 |
| string: canterbury-large/E.coli | 1048578 | 33940.6 ± 0.2% | 12893.1 ± 0.7% | 3379.7 ± 0.6% | 1277.5 ± 0.4% | 8885.8 ± 0.6% | 914.4 ± 5.6% | 2.632 | 10.042 | 26.568 | 3.820 | 37.117 |
| string: canterbury-large/bible.txt | 1055886 | 8587.3 ± 0.7% | 5220.8 ± 1.1% | 2775.7 ± 0.7% | 350.9 ± 0.5% | 3833.7 ± 0.9% | 623.8 ± 2.6% | 1.645 | 3.094 | 24.476 | 2.240 | 13.765 |
| string: canterbury-large/world192.txt | 1103121 | 4165.4 ± 1.3% | 2300.4 ± 0.4% | 1758.0 ± 0.7% | 327.7 ± 1.4% | 2099.8 ± 0.7% | 462.2 ± 4.3% | 1.811 | 2.369 | 12.710 | 1.984 | 9.011 |
| string: http/html-1m | 1058582 | 9526.9 ± 1.4% | 4702.2 ± 1.3% | 2668.1 ± 0.6% | 400.6 ± 0.9% | 3596.9 ± 0.8% | 587.9 ± 1.4% | 2.026 | 3.571 | 23.780 | 2.649 | 16.205 |
| string: http/json-1m | 1190272 | 3310.8 ± 0.7% | 1250.9 ± 0.7% | 2027.2 ± 0.4% | 476.8 ± 0.5% | 1337.3 ± 0.5% | 435.3 ± 0.7% | 2.647 | 1.633 | 6.943 | 2.476 | 7.605 |
| string: http/js-1m | 1144362 | 2889.6 ± 0.5% | 1600.7 ± 0.3% | 1327.4 ± 1.0% | 320.8 ± 0.8% | 1415.7 ± 1.2% | 376.8 ± 2.1% | 1.805 | 2.177 | 9.006 | 2.041 | 7.668 |
| string: http/css-1m | 1097820 | 3307.5 ± 0.6% | 2864.7 ± 3.1% | 2255.3 ± 0.4% | 439.9 ± 2.7% | 2065.0 ± 0.6% | 433.6 ± 1.2% | 1.155 | 1.467 | 7.520 | 1.602 | 7.628 |
| string: dickens as Cyrillic and CJK | 1883069 | 5792.0 ± 0.6% | 2991.8 ± 2.3% | 659.5 ± 0.6% | 369.8 ± 1.0% | 510.8 ± 0.6% | 162.8 ± 2.4% | 1.936 | 8.782 | 15.662 | 11.338 | 35.587 |
| string: dickens as Cyrillic and CJK, as \u escapes | 5075485 | 1209.0 ± 0.7% | 1236.2 ± 1.1% | 1091.3 ± 1.3% | 265.7 ± 1.3% | 477.2 ± 1.4% | 224.9 ± 1.7% | 0.978 | 1.108 | 4.550 | 2.533 | 5.376 |
| hex: silesia/dickens | 524290 | 33826.2 ± 1.0% | 15035.4 ± 0.7% | 3482.3 ± 1.4% | 480.0 ± 0.9% | 8896.4 ± 1.3% | 1125.1 ± 3.0% | 2.250 | 9.714 | 70.475 | 3.802 | 30.066 |
| hex: silesia/mozilla | 524290 | 33858.4 ± 0.9% | 15021.5 ± 0.9% | 3551.8 ± 0.7% | 428.2 ± 0.5% | 8884.7 ± 0.8% | 1120.8 ± 1.5% | 2.254 | 9.533 | 79.064 | 3.811 | 30.208 |
| hex: silesia/mr | 524290 | 33797.2 ± 0.9% | 15021.1 ± 0.8% | 3549.6 ± 1.8% | 642.5 ± 3.1% | 8888.4 ± 1.2% | 1127.0 ± 0.5% | 2.250 | 9.521 | 52.600 | 3.802 | 29.989 |
| hex: silesia/nci | 524290 | 34032.2 ± 4.1% | 15115.4 ± 1.0% | 3500.9 ± 4.1% | 797.1 ± 1.8% | 8928.5 ± 1.2% | 1126.3 ± 1.7% | 2.251 | 9.721 | 42.697 | 3.812 | 30.216 |
| hex: silesia/ooffice | 524290 | 34040.1 ± 0.9% | 15100.9 ± 0.9% | 3565.0 ± 1.1% | 344.8 ± 1.9% | 8939.3 ± 5.3% | 1127.7 ± 1.2% | 2.254 | 9.548 | 98.727 | 3.808 | 30.186 |
| hex: silesia/osdb | 524290 | 33821.6 ± 0.5% | 14987.9 ± 0.7% | 3547.3 ± 1.0% | 448.3 ± 0.6% | 8857.1 ± 0.6% | 1119.7 ± 0.8% | 2.257 | 9.535 | 75.448 | 3.819 | 30.205 |
| hex: silesia/reymont | 524290 | 33748.5 ± 0.4% | 15015.8 ± 0.4% | 3474.6 ± 0.9% | 502.4 ± 0.7% | 8863.2 ± 0.9% | 1118.5 ± 1.4% | 2.248 | 9.713 | 67.179 | 3.808 | 30.174 |
| hex: silesia/samba | 524290 | 33760.0 ± 0.5% | 15014.5 ± 0.5% | 3544.2 ± 0.5% | 363.6 ± 1.4% | 8897.2 ± 0.7% | 1120.5 ± 1.6% | 2.248 | 9.525 | 92.852 | 3.794 | 30.128 |
| hex: silesia/sao | 524290 | 33750.7 ± 0.5% | 15068.0 ± 0.6% | 3443.2 ± 0.8% | 275.2 ± 2.2% | 8844.6 ± 0.6% | 1127.4 ± 1.2% | 2.240 | 9.802 | 122.652 | 3.816 | 29.936 |
| hex: silesia/webster | 524290 | 33962.9 ± 0.3% | 15121.6 ± 2.7% | 3561.6 ± 0.7% | 452.0 ± 0.4% | 8921.4 ± 0.2% | 1138.5 ± 0.4% | 2.246 | 9.536 | 75.137 | 3.807 | 29.830 |
| hex: silesia/x-ray | 524290 | 33979.6 ± 0.3% | 15144.0 ± 0.3% | 3499.5 ± 1.3% | 424.1 ± 0.5% | 8913.5 ± 0.9% | 1134.9 ± 0.6% | 2.244 | 9.710 | 80.122 | 3.812 | 29.940 |
| hex: silesia/xml | 524290 | 33939.8 ± 0.3% | 15146.3 ± 0.7% | 3569.1 ± 0.6% | 732.3 ± 1.5% | 8911.2 ± 0.3% | 1131.3 ± 1.5% | 2.241 | 9.509 | 46.349 | 3.809 | 30.001 |
| hex: canterbury/alice29.txt | 304180 | 33798.0 ± 0.4% | 14164.8 ± 0.9% | 3567.4 ± 0.3% | 486.3 ± 0.7% | 8914.9 ± 0.4% | 1148.4 ± 0.3% | 2.386 | 9.474 | 69.506 | 3.791 | 29.430 |
| hex: canterbury/asyoulik.txt | 250360 | 33911.4 ± 0.1% | 15117.5 ± 0.1% | 3503.0 ± 0.2% | 473.5 ± 0.5% | 8913.1 ± 0.1% | 1145.8 ± 0.7% | 2.243 | 9.681 | 71.618 | 3.805 | 29.595 |
| hex: canterbury/cp.html | 49208 | 33357.6 ± 0.5% | 14389.8 ± 0.8% | 3551.1 ± 0.8% | 502.3 ± 1.3% | 9216.4 ± 0.6% | 1119.7 ± 2.6% | 2.318 | 9.394 | 66.412 | 3.619 | 29.791 |
| hex: canterbury/fields.c | 22302 | 32799.8 ± 0.8% | 17430.2 ± 2.4% | 3647.1 ± 0.6% | 561.7 ± 0.9% | 9206.7 ± 0.6% | 1100.7 ± 0.3% | 1.882 | 8.994 | 58.390 | 3.563 | 29.798 |
| hex: canterbury/grammar.lsp | 7444 | 29723.6 ± 0.7% | 17138.1 ± 4.4% | 3610.0 ± 1.8% | 762.0 ± 1.1% | 8925.3 ± 0.6% | 1056.3 ± 2.1% | 1.734 | 8.234 | 39.007 | 3.330 | 28.140 |
| hex: canterbury/kennedy.xls | 524290 | 33775.3 ± 0.5% | 14996.9 ± 0.8% | 3515.3 ± 0.5% | 749.4 ± 1.4% | 8854.9 ± 0.4% | 1101.3 ± 5.5% | 2.252 | 9.608 | 45.069 | 3.814 | 30.668 |
| hex: canterbury/lcet10.txt | 524290 | 33773.2 ± 0.8% | 15021.1 ± 1.1% | 3537.6 ± 1.6% | 484.6 ± 2.1% | 8840.4 ± 3.4% | 1119.8 ± 3.4% | 2.248 | 9.547 | 69.687 | 3.820 | 30.159 |
| hex: canterbury/plrabn12.txt | 524290 | 33872.2 ± 4.7% | 15069.7 ± 0.7% | 3563.8 ± 0.4% | 467.5 ± 1.1% | 8886.2 ± 0.8% | 1116.4 ± 2.3% | 2.248 | 9.504 | 72.452 | 3.812 | 30.341 |
| hex: canterbury/ptt5 | 524290 | 33910.7 ± 0.4% | 15089.5 ± 0.8% | 3492.0 ± 0.8% | 665.8 ± 0.9% | 8886.5 ± 0.6% | 1122.5 ± 2.4% | 2.247 | 9.711 | 50.935 | 3.816 | 30.209 |
| hex: canterbury/sum | 76482 | 33288.5 ± 0.3% | 15419.0 ± 0.4% | 3561.8 ± 0.3% | 585.2 ± 0.6% | 8905.4 ± 0.4% | 1123.4 ± 1.1% | 2.159 | 9.346 | 56.889 | 3.738 | 29.632 |
| hex: canterbury/xargs.1 | 8456 | 30219.1 ± 0.6% | 17389.4 ± 0.8% | 3560.5 ± 0.7% | 736.8 ± 2.6% | 8940.7 ± 0.7% | 1104.3 ± 1.6% | 1.738 | 8.487 | 41.016 | 3.380 | 27.366 |
| hex: canterbury-large/E.coli | 524290 | 33734.8 ± 0.6% | 15025.3 ± 3.4% | 3468.6 ± 0.3% | 954.1 ± 2.9% | 8853.0 ± 0.7% | 1117.5 ± 3.4% | 2.245 | 9.726 | 35.357 | 3.811 | 30.187 |
| hex: canterbury-large/bible.txt | 524290 | 33749.2 ± 1.5% | 15055.8 ± 0.8% | 3480.0 ± 1.6% | 500.4 ± 0.8% | 8857.2 ± 1.1% | 1116.6 ± 1.9% | 2.242 | 9.698 | 67.451 | 3.810 | 30.225 |
| hex: canterbury-large/world192.txt | 524290 | 33973.9 ± 1.1% | 14999.7 ± 3.3% | 3570.1 ± 0.9% | 469.7 ± 1.1% | 8919.2 ± 1.3% | 1123.0 ± 1.6% | 2.265 | 9.516 | 72.333 | 3.809 | 30.254 |
| hex: http/html-1kx1024 | 2099200 | 14775.8 ± 0.5% | 12459.3 ± 3.1% | 3157.1 ± 0.5% | 508.4 ± 0.4% | 7388.7 ± 1.3% | 951.0 ± 3.2% | 1.186 | 4.680 | 29.064 | 2.000 | 15.536 |
| hex: http/html-16kx64 | 2097280 | 27555.3 ± 0.3% | 13864.7 ± 1.1% | 3399.1 ± 2.9% | 516.5 ± 1.0% | 8494.7 ± 1.1% | 1072.2 ± 3.4% | 1.987 | 8.107 | 53.354 | 3.244 | 25.699 |
| hex: http/html-1m | 524290 | 33762.0 ± 1.2% | 15000.9 ± 0.7% | 3474.5 ± 0.9% | 504.8 ± 1.5% | 8862.2 ± 1.4% | 1114.4 ± 1.7% | 2.251 | 9.717 | 66.882 | 3.810 | 30.296 |
| hex: http/json-1kx1024 | 2099200 | 14668.5 ± 0.4% | 12356.4 ± 0.4% | 3136.1 ± 1.0% | 679.6 ± 1.3% | 7450.0 ± 0.8% | 966.1 ± 1.4% | 1.187 | 4.677 | 21.584 | 1.969 | 15.184 |
| hex: http/json-16kx64 | 2097280 | 27643.8 ± 0.2% | 13992.3 ± 0.5% | 3386.7 ± 0.5% | 694.9 ± 0.8% | 8472.3 ± 0.4% | 1067.1 ± 4.2% | 1.976 | 8.162 | 39.782 | 3.263 | 25.905 |
| hex: http/json-1m | 524290 | 33953.9 ± 1.2% | 15114.5 ± 0.6% | 3535.9 ± 0.8% | 714.1 ± 0.4% | 8920.7 ± 0.3% | 1117.2 ± 1.6% | 2.246 | 9.603 | 47.548 | 3.806 | 30.391 |
| hex: http/js-1kx1024 | 2099200 | 14692.3 ± 0.9% | 12232.3 ± 5.4% | 3151.3 ± 0.4% | 492.1 ± 0.2% | 7482.6 ± 1.6% | 952.7 ± 2.7% | 1.201 | 4.662 | 29.857 | 1.964 | 15.421 |
| hex: http/js-16kx64 | 2097280 | 27213.7 ± 0.7% | 13978.1 ± 0.5% | 3385.0 ± 1.0% | 499.3 ± 0.8% | 8313.2 ± 1.7% | 1066.1 ± 5.8% | 1.947 | 8.039 | 54.507 | 3.274 | 25.527 |
| hex: http/js-1m | 524290 | 33791.7 ± 1.1% | 14989.8 ± 1.2% | 3559.4 ± 1.0% | 516.6 ± 1.3% | 8857.2 ± 0.9% | 1106.0 ± 2.4% | 2.254 | 9.494 | 65.407 | 3.815 | 30.552 |
| hex: http/css-1kx1024 | 2099200 | 14682.8 ± 0.4% | 12197.6 ± 12.1% | 3134.7 ± 1.0% | 565.3 ± 0.9% | 7412.7 ± 1.6% | 958.4 ± 2.7% | 1.204 | 4.684 | 25.972 | 1.981 | 15.320 |
| hex: http/css-16kx64 | 2097280 | 27416.3 ± 0.8% | 13753.0 ± 0.9% | 3362.3 ± 0.7% | 577.6 ± 2.8% | 8462.6 ± 1.1% | 1057.0 ± 4.9% | 1.993 | 8.154 | 47.462 | 3.240 | 25.937 |
| hex: http/css-1m | 524290 | 33716.2 ± 1.3% | 15020.6 ± 0.9% | 3531.2 ± 1.0% | 558.6 ± 1.2% | 8871.9 ± 4.2% | 1109.4 ± 4.2% | 2.245 | 9.548 | 60.358 | 3.800 | 30.391 |
| hex: shuffled/dickens-1m | 524290 | 33739.7 ± 0.6% | 15067.8 ± 0.5% | 3477.7 ± 1.0% | 478.7 ± 2.1% | 8867.4 ± 0.8% | 1126.5 ± 1.6% | 2.239 | 9.702 | 70.478 | 3.805 | 29.951 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1573.5 ± 0.5% | 1467.4 ± 0.5% | 1021.0 ± 0.6% | 478.7 ± 0.5% | 469.9 ± 2.6% | 500.3 ± 5.1% | 1.072 | 1.541 | 3.287 | 3.349 | 3.145 |
| qlog records, JSON text sequence | 1467503 | 1442.2 ± 6.8% | 1234.6 ± 1.2% | 944.8 ± 1.0% | 455.3 ± 0.7% | 572.1 ± 0.7% | 350.1 ± 1.2% | 1.168 | 1.526 | 3.167 | 2.521 | 4.120 |
| string: silesia/dickens | 172528 | 12188.2 ± 0.9% | 3966.9 ± 1.2% | 3072.6 ± 1.1% | 357.3 ± 1.1% | 1719.4 ± 1.5% | 1190.1 ± 2.3% | 3.073 | 3.967 | 34.108 | 7.089 | 10.241 |
| string: silesia/nci | 1075110 | 10790.3 ± 1.3% | 4544.6 ± 1.2% | 3112.5 ± 1.2% | 854.8 ± 1.1% | 1912.3 ± 1.2% | 1285.2 ± 1.3% | 2.374 | 3.467 | 12.624 | 5.643 | 8.396 |
| string: silesia/reymont | 1075159 | 5300.6 ± 1.0% | 1829.4 ± 0.7% | 1892.6 ± 0.9% | 395.7 ± 1.1% | 1443.4 ± 0.5% | 1049.2 ± 1.0% | 2.897 | 2.801 | 13.395 | 3.672 | 5.052 |
| string: silesia/samba | 97582 | 6286.9 ± 1.3% | 2713.6 ± 0.9% | 4065.8 ± 1.3% | 376.8 ± 1.4% | 1326.4 ± 1.5% | 1179.3 ± 3.5% | 2.317 | 1.546 | 16.683 | 4.740 | 5.331 |
| string: silesia/webster | 1098490 | 6640.8 ± 1.2% | 1944.9 ± 1.2% | 1734.6 ± 1.6% | 387.8 ± 1.1% | 1396.9 ± 1.4% | 597.6 ± 3.2% | 3.415 | 3.828 | 17.126 | 4.754 | 11.113 |
| string: silesia/xml | 1090118 | 9838.5 ± 0.7% | 3152.6 ± 2.1% | 2505.4 ± 1.1% | 623.3 ± 1.4% | 1932.8 ± 1.0% | 960.6 ± 4.6% | 3.121 | 3.927 | 15.786 | 5.090 | 10.242 |
| string: canterbury/alice29.txt | 159425 | 10606.7 ± 1.1% | 2891.9 ± 1.2% | 3030.0 ± 2.4% | 341.5 ± 1.3% | 1532.5 ± 2.0% | 1087.7 ± 1.0% | 3.668 | 3.501 | 31.055 | 6.921 | 9.751 |
| string: canterbury/asyoulik.txt | 132198 | 10355.1 ± 4.6% | 2120.4 ± 1.0% | 3102.3 ± 0.9% | 348.0 ± 0.8% | 1364.9 ± 1.0% | 943.9 ± 2.7% | 4.884 | 3.338 | 29.760 | 7.586 | 10.970 |
| string: canterbury/lcet10.txt | 441884 | 10625.5 ± 1.6% | 3069.6 ± 0.3% | 2586.3 ± 3.3% | 385.8 ± 1.5% | 1656.1 ± 1.4% | 1199.7 ± 0.9% | 3.461 | 4.108 | 27.544 | 6.416 | 8.857 |
| string: canterbury/plrabn12.txt | 503330 | 7895.7 ± 1.1% | 2302.5 ± 1.0% | 2085.8 ± 0.8% | 363.2 ± 0.8% | 1614.0 ± 1.6% | 1118.8 ± 1.7% | 3.429 | 3.785 | 21.739 | 4.892 | 7.057 |
| string: canterbury-large/E.coli | 1048578 | 31418.4 ± 0.3% | 15490.8 ± 1.4% | 3458.5 ± 0.2% | 1688.0 ± 0.2% | 3130.5 ± 4.6% | 1406.6 ± 0.7% | 2.028 | 9.084 | 18.612 | 10.036 | 22.337 |
| string: canterbury-large/bible.txt | 1055886 | 8853.7 ± 2.1% | 4751.3 ± 1.3% | 2983.8 ± 2.4% | 419.1 ± 0.5% | 2209.3 ± 3.2% | 1477.2 ± 0.4% | 1.863 | 2.967 | 21.125 | 4.008 | 5.994 |
| string: canterbury-large/world192.txt | 1103121 | 6363.0 ± 3.3% | 1711.0 ± 0.8% | 1871.7 ± 3.9% | 388.7 ± 2.2% | 1395.6 ± 1.9% | 964.2 ± 1.4% | 3.719 | 3.400 | 16.369 | 4.559 | 6.599 |
| string: http/html-1m | 1058582 | 9880.3 ± 1.2% | 4346.9 ± 4.5% | 2863.1 ± 0.8% | 461.3 ± 0.4% | 2151.7 ± 0.7% | 845.7 ± 0.9% | 2.273 | 3.451 | 21.417 | 4.592 | 11.683 |
| string: http/json-1m | 1190272 | 8447.3 ± 0.4% | 1575.0 ± 5.2% | 1562.0 ± 0.2% | 538.3 ± 0.6% | 1155.6 ± 0.6% | 850.8 ± 1.4% | 5.363 | 5.408 | 15.692 | 7.310 | 9.929 |
| string: http/js-1m | 1144362 | 6362.2 ± 0.9% | 1116.4 ± 0.8% | 1385.8 ± 0.6% | 359.9 ± 0.6% | 1127.7 ± 3.3% | 754.3 ± 0.8% | 5.699 | 4.591 | 17.680 | 5.642 | 8.434 |
| string: http/css-1m | 1097820 | 7936.1 ± 0.7% | 1483.6 ± 0.5% | 2296.5 ± 0.6% | 546.3 ± 0.5% | 1268.5 ± 1.0% | 881.7 ± 1.1% | 5.349 | 3.456 | 14.528 | 6.256 | 9.001 |
| string: dickens as Cyrillic and CJK | 1883069 | 5471.5 ± 2.2% | 3676.0 ± 1.2% | 482.2 ± 1.1% | 250.8 ± 0.8% | 462.8 ± 0.6% | 354.6 ± 0.4% | 1.488 | 11.346 | 21.819 | 11.822 | 15.431 |
| hex: silesia/dickens | 524290 | 41774.0 ± 2.3% | 2569.8 ± 0.7% | 1507.2 ± 1.2% | 471.1 ± 0.7% | 1564.9 ± 5.0% | 1053.2 ± 0.8% | 16.256 | 27.716 | 88.677 | 26.695 | 39.665 |
| hex: silesia/mozilla | 524290 | 42670.6 ± 2.0% | 2569.4 ± 0.6% | 1492.6 ± 4.4% | 418.6 ± 1.3% | 1563.1 ± 1.0% | 1063.1 ± 1.1% | 16.607 | 28.588 | 101.941 | 27.299 | 40.138 |
| hex: silesia/mr | 524290 | 42763.5 ± 6.5% | 2564.2 ± 0.7% | 1499.1 ± 0.6% | 603.4 ± 2.1% | 1540.9 ± 1.1% | 1056.2 ± 3.1% | 16.677 | 28.526 | 70.872 | 27.752 | 40.486 |
| hex: silesia/nci | 524290 | 43487.9 ± 6.4% | 2561.7 ± 0.7% | 1495.3 ± 0.5% | 753.1 ± 0.3% | 1567.6 ± 0.5% | 1059.4 ± 0.2% | 16.976 | 29.082 | 57.744 | 27.742 | 41.049 |
| hex: silesia/ooffice | 524290 | 42754.5 ± 0.9% | 2578.8 ± 0.8% | 1493.3 ± 0.6% | 342.7 ± 1.0% | 1543.5 ± 1.0% | 1054.1 ± 0.7% | 16.579 | 28.630 | 124.764 | 27.700 | 40.560 |
| hex: silesia/osdb | 524290 | 41852.1 ± 2.6% | 2583.6 ± 1.1% | 1499.8 ± 1.0% | 453.5 ± 1.1% | 1569.2 ± 0.3% | 1054.2 ± 0.6% | 16.199 | 27.905 | 92.278 | 26.671 | 39.699 |
| hex: silesia/reymont | 524290 | 43383.5 ± 1.8% | 2593.2 ± 0.6% | 1498.8 ± 0.9% | 489.8 ± 3.6% | 1545.7 ± 5.0% | 1060.8 ± 0.7% | 16.730 | 28.945 | 88.569 | 28.067 | 40.896 |
| hex: silesia/samba | 524290 | 43301.9 ± 2.1% | 2571.2 ± 9.5% | 1497.2 ± 0.9% | 365.3 ± 3.5% | 1574.1 ± 0.7% | 1052.9 ± 0.9% | 16.841 | 28.921 | 118.545 | 27.510 | 41.125 |
| hex: silesia/sao | 524290 | 43173.8 ± 0.7% | 2592.3 ± 0.9% | 1495.9 ± 0.8% | 280.6 ± 0.9% | 1546.7 ± 0.3% | 1054.9 ± 1.6% | 16.655 | 28.862 | 153.847 | 27.914 | 40.929 |
| hex: silesia/webster | 524290 | 43703.6 ± 2.1% | 2576.5 ± 8.8% | 1499.0 ± 0.5% | 449.6 ± 0.5% | 1550.2 ± 0.6% | 1052.4 ± 0.7% | 16.962 | 29.154 | 97.195 | 28.192 | 41.526 |
| hex: silesia/x-ray | 524290 | 43150.4 ± 8.3% | 2579.7 ± 1.1% | 1497.4 ± 0.7% | 426.6 ± 2.5% | 1551.1 ± 3.2% | 1053.6 ± 1.0% | 16.727 | 28.816 | 101.138 | 27.819 | 40.954 |
| hex: silesia/xml | 524290 | 43286.0 ± 0.8% | 2567.3 ± 1.2% | 1498.3 ± 3.8% | 725.6 ± 1.4% | 1554.3 ± 0.5% | 1056.5 ± 1.0% | 16.861 | 28.890 | 59.652 | 27.850 | 40.972 |
| hex: canterbury/alice29.txt | 304180 | 41110.1 ± 3.5% | 2603.3 ± 7.2% | 1518.2 ± 0.5% | 477.0 ± 0.8% | 1581.6 ± 0.8% | 1077.4 ± 0.7% | 15.791 | 27.078 | 86.187 | 25.993 | 38.158 |
| hex: canterbury/asyoulik.txt | 250360 | 43080.9 ± 1.6% | 2609.7 ± 0.5% | 1526.3 ± 0.5% | 465.8 ± 0.4% | 1582.8 ± 0.4% | 1080.8 ± 1.1% | 16.508 | 28.225 | 92.481 | 27.218 | 39.859 |
| hex: canterbury/cp.html | 49208 | 42325.2 ± 1.2% | 2583.7 ± 0.9% | 1516.9 ± 0.4% | 512.3 ± 0.6% | 1585.3 ± 0.2% | 1083.2 ± 0.5% | 16.381 | 27.902 | 82.617 | 26.698 | 39.073 |
| hex: canterbury/fields.c | 22302 | 41833.5 ± 1.5% | 2649.1 ± 1.0% | 1526.9 ± 0.6% | 628.8 ± 1.1% | 1595.5 ± 4.3% | 1089.1 ± 1.1% | 15.791 | 27.397 | 66.534 | 26.220 | 38.410 |
| hex: canterbury/grammar.lsp | 7444 | 40011.3 ± 1.8% | 2678.5 ± 0.6% | 1527.9 ± 1.2% | 799.7 ± 0.6% | 1603.3 ± 0.8% | 1101.2 ± 0.7% | 14.938 | 26.187 | 50.035 | 24.956 | 36.336 |
| hex: canterbury/kennedy.xls | 524290 | 42507.6 ± 1.9% | 2569.5 ± 0.7% | 1498.0 ± 0.9% | 747.6 ± 1.2% | 1564.8 ± 6.1% | 1058.7 ± 1.2% | 16.543 | 28.376 | 56.859 | 27.165 | 40.149 |
| hex: canterbury/lcet10.txt | 524290 | 42401.7 ± 0.7% | 2593.6 ± 0.4% | 1511.1 ± 1.3% | 479.6 ± 1.2% | 1579.6 ± 0.8% | 1065.2 ± 0.8% | 16.349 | 28.060 | 88.407 | 26.843 | 39.806 |
| hex: canterbury/plrabn12.txt | 524290 | 42964.8 ± 1.5% | 2589.5 ± 0.7% | 1500.3 ± 0.5% | 461.8 ± 0.8% | 1571.3 ± 0.8% | 1056.8 ± 5.2% | 16.592 | 28.638 | 93.045 | 27.344 | 40.656 |
| hex: canterbury/ptt5 | 524290 | 42673.2 ± 1.4% | 2558.1 ± 0.6% | 1491.8 ± 0.7% | 609.0 ± 0.9% | 1542.9 ± 0.8% | 1051.0 ± 0.7% | 16.682 | 28.604 | 70.067 | 27.658 | 40.604 |
| hex: canterbury/sum | 76482 | 42193.9 ± 5.9% | 2573.0 ± 0.3% | 1507.2 ± 0.5% | 588.7 ± 0.8% | 1572.6 ± 1.3% | 1077.6 ± 2.4% | 16.399 | 27.995 | 71.672 | 26.831 | 39.157 |
| hex: canterbury/xargs.1 | 8456 | 40620.1 ± 3.9% | 2674.2 ± 1.0% | 1531.0 ± 0.7% | 823.6 ± 1.4% | 1599.8 ± 0.4% | 1101.7 ± 0.5% | 15.189 | 26.531 | 49.318 | 25.390 | 36.871 |
| hex: canterbury-large/E.coli | 524290 | 43183.3 ± 1.4% | 2561.2 ± 0.6% | 1492.9 ± 0.4% | 810.2 ± 0.3% | 1561.5 ± 0.3% | 1054.5 ± 0.7% | 16.860 | 28.926 | 53.299 | 27.656 | 40.951 |
| hex: canterbury-large/bible.txt | 524290 | 43303.5 ± 0.8% | 2577.1 ± 0.8% | 1499.1 ± 0.3% | 486.1 ± 0.3% | 1553.1 ± 0.6% | 1052.7 ± 0.5% | 16.803 | 28.886 | 89.079 | 27.882 | 41.136 |
| hex: canterbury-large/world192.txt | 524290 | 43430.8 ± 1.3% | 2588.0 ± 0.5% | 1498.5 ± 0.3% | 464.2 ± 0.5% | 1568.9 ± 0.5% | 1059.1 ± 0.4% | 16.782 | 28.983 | 93.554 | 27.682 | 41.009 |
| hex: http/html-1kx1024 | 2099200 | 20615.8 ± 0.5% | 2456.8 ± 0.9% | 1454.7 ± 0.9% | 511.5 ± 1.2% | 1522.4 ± 0.7% | 1069.4 ± 0.7% | 8.391 | 14.172 | 40.303 | 13.541 | 19.278 |
| hex: http/html-16kx64 | 2097280 | 21541.4 ± 0.7% | 2379.1 ± 5.2% | 1445.2 ± 1.6% | 516.0 ± 0.3% | 1493.7 ± 1.0% | 1074.2 ± 5.1% | 9.055 | 14.906 | 41.743 | 14.421 | 20.053 |
| hex: http/html-1m | 524290 | 40120.5 ± 5.4% | 2591.9 ± 1.0% | 1504.0 ± 0.6% | 505.6 ± 0.9% | 1567.5 ± 0.6% | 1059.3 ± 0.6% | 15.479 | 26.676 | 79.348 | 25.595 | 37.876 |
| hex: http/json-1kx1024 | 2099200 | 20710.2 ± 0.4% | 2441.0 ± 1.1% | 1451.8 ± 5.1% | 687.1 ± 0.9% | 1528.3 ± 0.9% | 1071.8 ± 0.4% | 8.484 | 14.265 | 30.143 | 13.551 | 19.323 |
| hex: http/json-16kx64 | 2097280 | 22529.3 ± 0.4% | 2378.8 ± 0.6% | 1442.6 ± 1.0% | 698.1 ± 0.8% | 1498.6 ± 0.9% | 1080.4 ± 1.7% | 9.471 | 15.617 | 32.271 | 15.034 | 20.852 |
| hex: http/json-1m | 524290 | 42734.4 ± 7.2% | 2559.5 ± 1.0% | 1502.7 ± 0.8% | 722.7 ± 1.0% | 1567.3 ± 1.3% | 1056.9 ± 1.3% | 16.696 | 28.438 | 59.129 | 27.266 | 40.432 |
| hex: http/js-1kx1024 | 2099200 | 20478.4 ± 0.3% | 2447.7 ± 1.7% | 1458.0 ± 0.9% | 496.6 ± 1.1% | 1529.8 ± 1.4% | 1070.2 ± 1.2% | 8.366 | 14.046 | 41.241 | 13.386 | 19.136 |
| hex: http/js-16kx64 | 2097280 | 22096.5 ± 0.2% | 2382.4 ± 7.7% | 1446.3 ± 5.1% | 502.7 ± 1.2% | 1505.2 ± 1.0% | 1081.2 ± 0.8% | 9.275 | 15.278 | 43.954 | 14.680 | 20.437 |
| hex: http/js-1m | 524290 | 41773.6 ± 1.4% | 2593.8 ± 0.4% | 1506.5 ± 0.1% | 516.0 ± 0.6% | 1564.2 ± 0.5% | 1065.4 ± 0.7% | 16.105 | 27.730 | 80.953 | 26.705 | 39.208 |
| hex: http/css-1kx1024 | 2099200 | 20892.4 ± 0.3% | 2465.0 ± 1.0% | 1473.6 ± 0.3% | 578.1 ± 1.0% | 1541.2 ± 1.0% | 1077.5 ± 0.6% | 8.476 | 14.177 | 36.142 | 13.556 | 19.389 |
| hex: http/css-16kx64 | 2097280 | 22110.3 ± 1.9% | 2382.1 ± 8.1% | 1449.6 ± 0.6% | 586.4 ± 0.3% | 1506.8 ± 0.6% | 1087.0 ± 0.4% | 9.282 | 15.253 | 37.706 | 14.673 | 20.341 |
| hex: http/css-1m | 524290 | 42685.6 ± 0.1% | 2593.7 ± 0.6% | 1507.5 ± 5.7% | 558.6 ± 0.9% | 1536.2 ± 0.7% | 1054.9 ± 0.8% | 16.458 | 28.316 | 76.409 | 27.787 | 40.465 |
| hex: shuffled/dickens-1m | 524290 | 42668.3 ± 8.3% | 2590.3 ± 0.9% | 1500.6 ± 1.2% | 470.7 ± 2.2% | 1569.7 ± 1.0% | 1056.5 ± 2.6% | 16.472 | 28.435 | 90.641 | 27.182 | 40.387 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding: stdx runs at 0.926 of simdjson.
- qlog records, JSON text sequence, decoding: stdx runs at 0.881 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.768 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.823 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.902 of yyjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next_items: stdx runs at 0.875 of simdjson.
