# bench-json

| Field | Value |
|---|---|
| Commit | e59f48c |
| Runner label | ubuntu-24.04 |
| Image version | 20261111.127.1 |
| CPU model | Intel(R) Xeon(R) 6975P-C |
| Virtual CPUs | 4 |
| Kernel | 7.0.0-1014-aws |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/43674617437 |
| Date | 2026-11-15 |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1. The `TextReader.next_items` column is that helper's queued tokens a slice a call (decision 79), over many tokens a call.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | TextReader.next_items | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1378.7 ± 0.9% | 0.489 | 1.025 | 1.066 | 1.070 | 0.411 | 1.073 | 1.070 | 0.371 | 0.834 | 0.930 | 0.106 |
| qlog records, JSON text sequence | 1467503 | 1096.7 ± 0.6% | 0.795 | 1.058 | 1.065 | 1.065 | 0.395 | 1.060 | 1.064 | 0.366 | 0.906 | 1.043 | 0.126 |
| messages: 11 string members | 1025025 | 1063.1 ± 0.7% | 0.587 | 1.003 | 1.022 | 1.024 | 0.548 | 1.015 | 1.025 | 0.544 | 0.889 | 0.960 | 0.138 |
| messages: 50 nested objects | 1121600 | 1341.1 ± 0.1% | 0.806 | 1.086 | 1.087 | 1.088 | 0.395 | 1.097 | 1.089 | 0.352 | 0.923 | 0.970 | 0.114 |
| messages: a tree of 341 objects | 612600 | 669.3 ± 0.2% | 0.815 | 1.047 | 1.027 | 1.030 | 0.264 | 1.024 | 1.028 | 0.219 | 0.818 | 0.975 | 0.117 |
| string: silesia/dickens | 172528 | 6717.7 ± 0.6% | 0.029 | 0.698 | 1.085 | 1.083 | 0.207 | 1.038 | 1.099 | 0.207 | 1.000 | 1.002 | 0.029 |
| string: silesia/nci | 1075110 | 5342.4 ± 0.7% | 0.036 | 0.733 | 1.039 | 1.040 | 0.310 | 1.042 | 1.038 | 0.310 | 1.011 | 1.011 | 0.036 |
| string: silesia/reymont | 1075159 | 3496.5 ± 1.2% | 0.055 | 0.623 | 0.881 | 0.868 | 0.357 | 0.818 | 0.875 | 0.356 | 0.985 | 0.991 | 0.055 |
| string: silesia/samba | 97582 | 3974.3 ± 0.8% | 0.041 | 0.912 | 1.065 | 1.067 | 0.075 | 0.861 | 1.066 | 0.075 | 1.004 | 1.007 | 0.041 |
| string: silesia/webster | 1098490 | 4368.0 ± 1.4% | 0.043 | 0.649 | 0.982 | 0.990 | 0.229 | 0.932 | 1.000 | 0.229 | 1.001 | 1.007 | 0.043 |
| string: silesia/xml | 1090118 | 6056.1 ± 0.4% | 0.032 | 0.782 | 0.954 | 0.967 | 0.253 | 0.952 | 0.970 | 0.253 | 1.003 | 1.008 | 0.032 |
| string: canterbury/alice29.txt | 159425 | 5792.9 ± 0.6% | 0.033 | 0.749 | 1.086 | 1.117 | 0.185 | 1.015 | 1.154 | 0.184 | 1.005 | 1.015 | 0.033 |
| string: canterbury/asyoulik.txt | 132198 | 4296.5 ± 1.1% | 0.043 | 0.798 | 1.137 | 1.136 | 0.202 | 1.063 | 1.145 | 0.202 | 1.003 | 1.010 | 0.043 |
| string: canterbury/lcet10.txt | 441884 | 6638.2 ± 1.2% | 0.029 | 0.609 | 1.104 | 1.113 | 0.202 | 1.038 | 1.125 | 0.202 | 1.006 | 1.008 | 0.029 |
| string: canterbury/plrabn12.txt | 503330 | 5482.0 ± 0.4% | 0.035 | 0.769 | 0.970 | 0.976 | 0.228 | 0.864 | 0.978 | 0.228 | 1.003 | 1.004 | 0.035 |
| string: canterbury-large/E.coli | 1048578 | 32374.0 ± 0.7% | 0.056 | 1.004 | 0.747 | 1.004 | 0.510 | 1.005 | 1.005 | 0.510 | 1.050 | 1.054 | 0.007 |
| string: canterbury-large/bible.txt | 1055886 | 8543.5 ± 0.8% | 0.024 | 0.621 | 0.872 | 0.879 | 0.403 | 0.886 | 0.893 | 0.400 | 1.007 | 1.012 | 0.024 |
| string: canterbury-large/world192.txt | 1103121 | 4096.6 ± 0.4% | 0.046 | 0.696 | 0.978 | 0.985 | 0.220 | 0.932 | 0.996 | 0.220 | 1.003 | 1.006 | 0.046 |
| string: http/html-1m | 1058582 | 9042.7 ± 5.2% | 0.022 | 0.567 | 0.787 | 0.790 | 0.324 | 0.752 | 0.799 | 0.324 | 0.962 | 1.035 | 0.022 |
| string: http/json-1m | 1190272 | 3289.7 ± 0.6% | 0.053 | 0.398 | 0.445 | 0.448 | 0.150 | 0.461 | 0.449 | 0.151 | 1.002 | 1.004 | 0.053 |
| string: http/js-1m | 1144362 | 2815.5 ± 0.8% | 0.063 | 0.704 | 0.905 | 0.932 | 0.196 | 0.855 | 0.934 | 0.197 | 1.006 | 1.007 | 0.063 |
| string: http/css-1m | 1097820 | 3267.8 ± 0.4% | 0.056 | 0.773 | 0.949 | 1.033 | 0.292 | 0.959 | 1.034 | 0.292 | 1.004 | 1.009 | 0.056 |
| string: dickens as Cyrillic and CJK | 1883069 | 5787.4 ± 0.8% | 0.025 | 0.064 | 0.447 | 0.447 | 0.199 | 0.445 | 0.448 | 0.200 | 1.003 | 1.003 | 0.025 |
| string: dickens as Cyrillic and CJK, as \u escapes | 5075485 | 1202.0 ± 1.2% | 0.112 | 0.999 | 0.999 | 1.000 | 0.106 | 0.713 | 1.000 | 0.106 | 1.010 | 1.010 | 0.112 |
| hex: silesia/dickens | 524290 | 47160.1 ± 0.4% | 0.039 | 0.992 | 0.608 | 0.992 | 0.382 | 0.995 | 0.992 | 0.382 | 0.720 | 0.719 | 0.005 |
| hex: silesia/mozilla | 524290 | 47463.6 ± 0.2% | 0.039 | 0.991 | 0.604 | 0.992 | 0.380 | 0.995 | 0.992 | 0.381 | 0.716 | 0.716 | 0.004 |
| hex: silesia/mr | 524290 | 45733.7 ± 1.2% | 0.040 | 0.993 | 0.627 | 0.997 | 0.395 | 0.995 | 0.998 | 0.394 | 0.736 | 0.742 | 0.005 |
| hex: silesia/nci | 524290 | 46360.2 ± 0.9% | 0.040 | 0.996 | 0.609 | 0.997 | 0.390 | 1.000 | 0.996 | 0.390 | 0.730 | 0.732 | 0.005 |
| hex: silesia/ooffice | 524290 | 49037.7 ± 0.2% | 0.037 | 0.991 | 0.574 | 0.992 | 0.369 | 0.994 | 0.992 | 0.369 | 0.692 | 0.693 | 0.004 |
| hex: silesia/osdb | 524290 | 46342.8 ± 1.1% | 0.039 | 0.999 | 0.603 | 0.998 | 0.388 | 0.999 | 0.995 | 0.389 | 0.729 | 0.729 | 0.005 |
| hex: silesia/reymont | 524290 | 45688.1 ± 0.9% | 0.040 | 0.994 | 0.624 | 0.996 | 0.391 | 0.998 | 0.990 | 0.392 | 0.742 | 0.742 | 0.005 |
| hex: silesia/samba | 524290 | 45723.7 ± 0.4% | 0.040 | 0.999 | 0.624 | 1.000 | 0.395 | 1.001 | 1.000 | 0.396 | 0.743 | 0.742 | 0.005 |
| hex: silesia/sao | 524290 | 45775.7 ± 0.3% | 0.040 | 0.996 | 0.623 | 0.996 | 0.394 | 0.998 | 0.995 | 0.395 | 0.742 | 0.741 | 0.005 |
| hex: silesia/webster | 524290 | 46900.3 ± 0.9% | 0.039 | 0.997 | 0.610 | 0.994 | 0.381 | 0.998 | 0.994 | 0.380 | 0.721 | 0.718 | 0.005 |
| hex: silesia/x-ray | 524290 | 48990.0 ± 0.9% | 0.037 | 0.992 | 0.582 | 0.992 | 0.369 | 0.994 | 0.991 | 0.368 | 0.692 | 0.693 | 0.004 |
| hex: silesia/xml | 524290 | 45596.4 ± 2.1% | 0.040 | 0.999 | 0.618 | 0.997 | 0.395 | 1.001 | 0.995 | 0.396 | 0.743 | 0.743 | 0.005 |
| hex: canterbury/alice29.txt | 304180 | 48664.9 ± 0.8% | 0.038 | 0.994 | 0.575 | 0.990 | 0.370 | 0.998 | 0.998 | 0.371 | 0.693 | 0.692 | 0.004 |
| hex: canterbury/asyoulik.txt | 250360 | 46167.8 ± 0.8% | 0.039 | 0.994 | 0.612 | 0.993 | 0.387 | 1.000 | 0.991 | 0.387 | 0.728 | 0.728 | 0.005 |
| hex: canterbury/cp.html | 49208 | 44196.4 ± 1.2% | 0.041 | 0.998 | 0.630 | 1.001 | 0.398 | 0.999 | 1.000 | 0.402 | 0.756 | 0.756 | 0.005 |
| hex: canterbury/fields.c | 22302 | 49477.1 ± 0.9% | 0.037 | 1.040 | 0.554 | 1.015 | 0.399 | 1.006 | 1.015 | 0.405 | 0.665 | 0.665 | 0.004 |
| hex: canterbury/grammar.lsp | 7444 | 43608.4 ± 1.4% | 0.042 | 0.983 | 0.580 | 1.007 | 0.413 | 0.996 | 1.008 | 0.434 | 0.684 | 0.683 | 0.005 |
| hex: canterbury/kennedy.xls | 524290 | 46858.7 ± 0.4% | 0.039 | 0.994 | 0.607 | 0.994 | 0.383 | 0.993 | 0.994 | 0.385 | 0.723 | 0.722 | 0.005 |
| hex: canterbury/lcet10.txt | 524290 | 46347.7 ± 0.9% | 0.039 | 0.996 | 0.616 | 0.997 | 0.387 | 1.000 | 0.998 | 0.388 | 0.733 | 0.732 | 0.005 |
| hex: canterbury/plrabn12.txt | 524290 | 45505.4 ± 0.7% | 0.040 | 0.994 | 0.621 | 0.995 | 0.388 | 0.995 | 0.995 | 0.389 | 0.748 | 0.745 | 0.005 |
| hex: canterbury/ptt5 | 524290 | 45640.7 ± 0.6% | 0.040 | 0.999 | 0.626 | 1.000 | 0.397 | 1.000 | 0.999 | 0.398 | 0.744 | 0.744 | 0.005 |
| hex: canterbury/sum | 76482 | 44849.6 ± 0.6% | 0.041 | 1.003 | 0.626 | 1.002 | 0.397 | 1.003 | 1.002 | 0.399 | 0.744 | 0.743 | 0.005 |
| hex: canterbury/xargs.1 | 8456 | 44761.6 ± 0.8% | 0.041 | 0.985 | 0.577 | 1.014 | 0.413 | 0.986 | 1.009 | 0.433 | 0.679 | 0.677 | 0.005 |
| hex: canterbury-large/E.coli | 524290 | 45822.1 ± 2.3% | 0.040 | 0.995 | 0.623 | 0.993 | 0.380 | 0.998 | 0.994 | 0.381 | 0.741 | 0.740 | 0.005 |
| hex: canterbury-large/bible.txt | 524290 | 44921.4 ± 1.7% | 0.040 | 0.997 | 0.631 | 0.995 | 0.394 | 1.004 | 1.000 | 0.394 | 0.752 | 0.755 | 0.005 |
| hex: canterbury-large/world192.txt | 524290 | 46070.7 ± 1.0% | 0.040 | 0.998 | 0.608 | 0.998 | 0.392 | 0.998 | 0.999 | 0.391 | 0.736 | 0.737 | 0.005 |
| hex: http/html-1kx1024 | 2099200 | 17761.9 ± 0.2% | 0.101 | 1.034 | 0.818 | 0.986 | 0.573 | 1.004 | 0.991 | 0.632 | 0.855 | 0.834 | 0.012 |
| hex: http/html-16kx64 | 2097280 | 34493.1 ± 0.2% | 0.053 | 1.001 | 0.692 | 1.003 | 0.469 | 1.003 | 1.004 | 0.474 | 0.802 | 0.802 | 0.006 |
| hex: http/html-1m | 524290 | 48640.7 ± 1.4% | 0.038 | 0.997 | 0.580 | 0.994 | 0.370 | 0.999 | 0.996 | 0.371 | 0.696 | 0.697 | 0.004 |
| hex: http/json-1kx1024 | 2099200 | 18431.8 ± 1.3% | 0.098 | 1.045 | 0.819 | 0.998 | 0.568 | 1.006 | 1.000 | 0.626 | 0.854 | 0.836 | 0.011 |
| hex: http/json-16kx64 | 2097280 | 34739.2 ± 0.9% | 0.052 | 1.002 | 0.688 | 1.002 | 0.469 | 1.002 | 1.002 | 0.474 | 0.806 | 0.805 | 0.006 |
| hex: http/json-1m | 524290 | 45916.5 ± 0.2% | 0.040 | 0.995 | 0.626 | 0.995 | 0.373 | 0.997 | 0.996 | 0.373 | 0.740 | 0.740 | 0.005 |
| hex: http/js-1kx1024 | 2099200 | 18045.2 ± 0.7% | 0.100 | 1.054 | 0.827 | 0.993 | 0.591 | 1.004 | 0.989 | 0.650 | 0.862 | 0.840 | 0.012 |
| hex: http/js-16kx64 | 2097280 | 34353.3 ± 0.8% | 0.053 | 1.002 | 0.694 | 1.003 | 0.473 | 1.004 | 1.001 | 0.477 | 0.803 | 0.803 | 0.006 |
| hex: http/js-1m | 524290 | 46022.4 ± 0.6% | 0.040 | 0.995 | 0.624 | 0.993 | 0.393 | 0.997 | 0.994 | 0.393 | 0.738 | 0.738 | 0.005 |
| hex: http/css-1kx1024 | 2099200 | 17643.7 ± 1.1% | 0.102 | 1.062 | 0.833 | 0.998 | 0.597 | 1.005 | 0.997 | 0.658 | 0.865 | 0.844 | 0.012 |
| hex: http/css-16kx64 | 2097280 | 34621.6 ± 0.1% | 0.053 | 1.003 | 0.688 | 1.002 | 0.468 | 1.000 | 1.002 | 0.472 | 0.796 | 0.797 | 0.006 |
| hex: http/css-1m | 524290 | 46380.1 ± 0.3% | 0.040 | 0.998 | 0.617 | 0.998 | 0.390 | 1.000 | 0.999 | 0.391 | 0.732 | 0.732 | 0.005 |
| hex: shuffled/dickens-1m | 524290 | 45358.1 ± 0.6% | 0.040 | 0.995 | 0.615 | 0.994 | 0.394 | 0.999 | 0.996 | 0.395 | 0.745 | 0.745 | 0.005 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1733.4 ± 4.2% | 0.426 | 1.008 | 0.979 | 1.017 | 1.012 | 0.273 | 1.012 | 0.516 | 0.908 | 0.096 | 1.034 |
| qlog records, JSON text sequence | 1467503 | 1645.1 ± 2.7% | 0.643 | 0.977 | 0.988 | 1.015 | 0.997 | 0.236 | 0.994 | 0.443 | 0.872 | 0.107 | 1.040 |
| messages: 11 string members | 1025025 | 1321.2 ± 0.3% | 0.502 | 0.963 | 0.983 | 0.989 | 0.977 | 0.378 | 0.978 | 0.670 | 0.952 | 0.123 | 1.000 |
| messages: 50 nested objects | 1121600 | 1987.5 ± 1.2% | 0.584 | 0.982 | 0.966 | 0.992 | 0.973 | 0.245 | 0.973 | 0.432 | 0.858 | 0.092 | 1.009 |
| messages: a tree of 341 objects | 612600 | 593.7 ± 3.2% | 0.978 | 1.059 | 1.075 | 1.081 | 1.081 | 0.263 | 1.082 | 0.447 | 0.835 | 0.195 | 1.087 |
| string: silesia/dickens | 172528 | 13030.8 ± 1.5% | 0.017 | 0.546 | 0.361 | 0.528 | 0.563 | 0.120 | 0.565 | 1.000 | 1.003 | 0.017 | 1.030 |
| string: silesia/nci | 1075110 | 11177.7 ± 0.6% | 0.020 | 0.527 | 0.378 | 0.535 | 0.526 | 0.186 | 0.526 | 1.000 | 1.000 | 0.020 | 1.030 |
| string: silesia/reymont | 1075159 | 5252.6 ± 2.2% | 0.043 | 0.584 | 0.440 | 0.576 | 0.588 | 0.273 | 0.579 | 1.015 | 1.016 | 0.043 | 1.033 |
| string: silesia/samba | 97582 | 6326.8 ± 0.6% | 0.045 | 0.888 | 0.735 | 0.892 | 0.886 | 0.122 | 0.889 | 0.999 | 1.000 | 0.045 | 1.155 |
| string: silesia/webster | 1098490 | 7015.2 ± 1.2% | 0.032 | 0.573 | 0.401 | 0.550 | 0.577 | 0.157 | 0.575 | 0.993 | 1.009 | 0.032 | 0.987 |
| string: silesia/xml | 1090118 | 10758.9 ± 0.6% | 0.021 | 0.555 | 0.461 | 0.549 | 0.557 | 0.206 | 0.558 | 1.004 | 1.017 | 0.021 | 1.031 |
| string: canterbury/alice29.txt | 159425 | 12728.9 ± 1.0% | 0.018 | 0.436 | 0.358 | 0.422 | 0.452 | 0.092 | 0.471 | 0.999 | 1.004 | 0.018 | 1.048 |
| string: canterbury/asyoulik.txt | 132198 | 10934.5 ± 3.1% | 0.020 | 0.392 | 0.330 | 0.389 | 0.414 | 0.090 | 0.421 | 1.002 | 1.015 | 0.020 | 1.046 |
| string: canterbury/lcet10.txt | 441884 | 12660.5 ± 1.1% | 0.018 | 0.543 | 0.324 | 0.533 | 0.546 | 0.118 | 0.548 | 0.986 | 1.004 | 0.018 | 0.992 |
| string: canterbury/plrabn12.txt | 503330 | 8790.0 ± 1.1% | 0.025 | 0.620 | 0.497 | 0.619 | 0.622 | 0.160 | 0.622 | 1.000 | 1.025 | 0.025 | 1.023 |
| string: canterbury-large/E.coli | 1048578 | 34149.5 ± 2.2% | 0.052 | 1.004 | 1.001 | 0.731 | 1.006 | 0.481 | 1.004 | 1.004 | 1.002 | 0.007 | 1.005 |
| string: canterbury-large/bible.txt | 1055886 | 9575.3 ± 1.0% | 0.025 | 0.742 | 0.569 | 0.741 | 0.755 | 0.393 | 0.754 | 0.991 | 1.007 | 0.025 | 1.017 |
| string: canterbury-large/world192.txt | 1103121 | 6630.7 ± 1.0% | 0.033 | 0.585 | 0.420 | 0.554 | 0.588 | 0.152 | 0.590 | 0.987 | 1.003 | 0.033 | 0.967 |
| string: http/html-1m | 1058582 | 10059.4 ± 1.8% | 0.023 | 0.639 | 0.535 | 0.636 | 0.644 | 0.311 | 0.644 | 0.991 | 1.007 | 0.023 | 1.008 |
| string: http/json-1m | 1190272 | 8321.7 ± 0.8% | 0.024 | 0.185 | 0.161 | 0.184 | 0.185 | 0.074 | 0.185 | 1.001 | 1.001 | 0.024 | 1.016 |
| string: http/js-1m | 1144362 | 6536.3 ± 1.8% | 0.032 | 0.367 | 0.311 | 0.358 | 0.368 | 0.094 | 0.368 | 0.983 | 0.998 | 0.032 | 1.014 |
| string: http/css-1m | 1097820 | 9299.1 ± 0.8% | 0.023 | 0.347 | 0.281 | 0.337 | 0.348 | 0.123 | 0.349 | 1.000 | 1.007 | 0.023 | 0.993 |
| string: dickens as Cyrillic and CJK | 1883069 | 5467.3 ± 0.3% | 0.031 | 0.466 | 0.069 | 0.464 | 0.466 | 0.209 | 0.467 | 1.002 | 1.001 | 0.031 | 1.036 |
| hex: silesia/dickens | 524290 | 42601.6 ± 1.1% | 1.000 | 0.090 | 1.000 | 0.601 | 1.001 | 0.997 | 1.000 | 0.999 | 1.001 | 0.096 | 1.001 |
| hex: silesia/mozilla | 524290 | 43723.4 ± 0.2% | 1.002 | 0.088 | 1.001 | 0.589 | 1.001 | 1.000 | 1.000 | 1.000 | 1.000 | 0.093 | 0.999 |
| hex: silesia/mr | 524290 | 43638.2 ± 0.6% | 0.999 | 0.088 | 1.001 | 0.590 | 1.003 | 1.002 | 0.999 | 1.001 | 1.000 | 0.094 | 1.002 |
| hex: silesia/nci | 524290 | 43276.0 ± 5.3% | 1.005 | 0.089 | 1.003 | 0.593 | 1.007 | 1.002 | 1.006 | 1.005 | 1.006 | 0.093 | 1.004 |
| hex: silesia/ooffice | 524290 | 42868.0 ± 8.1% | 1.008 | 0.089 | 1.008 | 0.595 | 1.009 | 1.008 | 0.999 | 1.010 | 1.010 | 0.093 | 1.014 |
| hex: silesia/osdb | 524290 | 41815.6 ± 0.5% | 1.001 | 0.092 | 1.002 | 0.610 | 1.004 | 1.002 | 1.005 | 1.001 | 1.003 | 0.098 | 1.000 |
| hex: silesia/reymont | 524290 | 43545.0 ± 0.5% | 1.001 | 0.088 | 0.998 | 0.588 | 0.999 | 0.999 | 1.000 | 0.997 | 0.999 | 0.094 | 1.000 |
| hex: silesia/samba | 524290 | 43638.6 ± 0.4% | 1.001 | 0.088 | 1.001 | 0.588 | 1.002 | 1.000 | 0.998 | 1.001 | 0.999 | 0.091 | 1.001 |
| hex: silesia/sao | 524290 | 43613.1 ± 1.1% | 1.002 | 0.088 | 0.989 | 0.586 | 1.000 | 0.998 | 0.998 | 0.996 | 0.994 | 0.092 | 1.001 |
| hex: silesia/webster | 524290 | 43984.0 ± 0.4% | 1.002 | 0.087 | 0.996 | 0.585 | 1.001 | 0.998 | 1.003 | 0.992 | 0.999 | 0.091 | 1.000 |
| hex: silesia/x-ray | 524290 | 43787.7 ± 0.1% | 1.000 | 0.088 | 1.000 | 0.589 | 1.001 | 1.000 | 1.000 | 1.001 | 1.000 | 0.093 | 1.001 |
| hex: silesia/xml | 524290 | 43809.0 ± 0.1% | 1.001 | 0.088 | 1.001 | 0.588 | 1.002 | 1.000 | 1.000 | 1.001 | 1.000 | 0.093 | 1.001 |
| hex: canterbury/alice29.txt | 304180 | 41537.1 ± 1.0% | 0.999 | 0.092 | 1.002 | 0.597 | 1.000 | 0.998 | 0.996 | 0.997 | 0.994 | 0.099 | 1.001 |
| hex: canterbury/asyoulik.txt | 250360 | 43399.0 ± 0.5% | 1.002 | 0.088 | 1.000 | 0.589 | 1.000 | 0.999 | 1.006 | 1.001 | 1.003 | 0.094 | 1.002 |
| hex: canterbury/cp.html | 49208 | 42589.3 ± 4.5% | 1.001 | 0.090 | 1.000 | 0.592 | 0.999 | 0.996 | 1.002 | 1.003 | 1.001 | 0.098 | 1.004 |
| hex: canterbury/fields.c | 22302 | 41984.3 ± 1.0% | 0.996 | 0.091 | 1.002 | 0.598 | 1.002 | 0.988 | 1.003 | 1.004 | 1.011 | 0.098 | 1.001 |
| hex: canterbury/grammar.lsp | 7444 | 39194.1 ± 1.4% | 0.990 | 0.097 | 1.000 | 0.611 | 1.001 | 0.969 | 1.000 | 1.003 | 1.034 | 0.103 | 1.007 |
| hex: canterbury/kennedy.xls | 524290 | 43711.1 ± 6.9% | 1.000 | 0.088 | 1.000 | 0.589 | 1.001 | 0.999 | 1.002 | 0.999 | 1.001 | 0.092 | 1.000 |
| hex: canterbury/lcet10.txt | 524290 | 43707.1 ± 0.2% | 1.002 | 0.088 | 1.001 | 0.589 | 1.000 | 0.999 | 1.001 | 1.001 | 1.001 | 0.091 | 1.001 |
| hex: canterbury/plrabn12.txt | 524290 | 43592.5 ± 0.2% | 1.002 | 0.088 | 1.002 | 0.590 | 1.001 | 0.999 | 1.002 | 1.001 | 1.001 | 0.093 | 1.001 |
| hex: canterbury/ptt5 | 524290 | 43640.7 ± 0.3% | 1.003 | 0.088 | 1.002 | 0.590 | 1.001 | 1.002 | 1.003 | 1.002 | 1.002 | 0.094 | 1.001 |
| hex: canterbury/sum | 76482 | 42974.1 ± 0.3% | 1.002 | 0.089 | 1.002 | 0.593 | 1.002 | 0.997 | 1.003 | 0.999 | 1.001 | 0.097 | 1.002 |
| hex: canterbury/xargs.1 | 8456 | 40207.1 ± 0.4% | 0.999 | 0.094 | 1.001 | 0.600 | 1.000 | 0.951 | 1.001 | 0.989 | 1.020 | 0.100 | 1.004 |
| hex: canterbury-large/E.coli | 524290 | 41777.0 ± 0.1% | 1.002 | 0.092 | 1.005 | 0.610 | 1.002 | 1.001 | 1.003 | 1.001 | 1.002 | 0.098 | 1.002 |
| hex: canterbury-large/bible.txt | 524290 | 43698.7 ± 0.3% | 1.001 | 0.088 | 1.001 | 0.589 | 1.001 | 0.999 | 1.002 | 0.999 | 1.001 | 0.093 | 1.001 |
| hex: canterbury-large/world192.txt | 524290 | 43397.8 ± 0.3% | 1.003 | 0.089 | 1.001 | 0.593 | 1.002 | 1.001 | 1.003 | 1.001 | 1.002 | 0.094 | 1.002 |
| hex: http/html-1kx1024 | 2099200 | 20784.8 ± 0.5% | 1.004 | 0.176 | 1.004 | 0.973 | 1.004 | 1.001 | 1.005 | 1.003 | 1.009 | 0.183 | 1.006 |
| hex: http/html-16kx64 | 2097280 | 21189.8 ± 0.5% | 1.001 | 0.179 | 1.004 | 0.988 | 1.003 | 1.003 | 1.004 | 1.003 | 1.004 | 0.193 | 1.004 |
| hex: http/html-1m | 524290 | 43779.6 ± 0.3% | 1.001 | 0.088 | 1.001 | 0.590 | 1.000 | 0.999 | 1.001 | 1.000 | 1.000 | 0.092 | 1.001 |
| hex: http/json-1kx1024 | 2099200 | 19851.2 ± 1.1% | 1.003 | 0.185 | 1.003 | 0.997 | 1.003 | 1.006 | 1.004 | 1.004 | 1.008 | 0.192 | 1.004 |
| hex: http/json-16kx64 | 2097280 | 20918.1 ± 0.8% | 1.005 | 0.180 | 1.005 | 0.990 | 1.005 | 1.006 | 1.004 | 1.005 | 1.006 | 0.195 | 1.006 |
| hex: http/json-1m | 524290 | 43625.4 ± 0.3% | 1.002 | 0.088 | 1.001 | 0.591 | 1.002 | 1.001 | 1.002 | 1.001 | 1.000 | 0.094 | 1.000 |
| hex: http/js-1kx1024 | 2099200 | 20181.7 ± 0.2% | 1.004 | 0.181 | 1.003 | 0.986 | 1.005 | 1.003 | 1.004 | 1.004 | 1.008 | 0.189 | 1.006 |
| hex: http/js-16kx64 | 2097280 | 20934.3 ± 0.8% | 1.003 | 0.180 | 1.004 | 0.991 | 1.004 | 1.003 | 1.003 | 1.003 | 1.003 | 0.195 | 1.003 |
| hex: http/js-1m | 524290 | 43598.1 ± 2.0% | 1.004 | 0.088 | 1.002 | 0.589 | 1.004 | 1.001 | 1.004 | 1.002 | 1.001 | 0.093 | 1.002 |
| hex: http/css-1kx1024 | 2099200 | 19901.4 ± 0.4% | 1.002 | 0.184 | 1.002 | 0.994 | 1.003 | 1.006 | 1.003 | 1.003 | 1.007 | 0.191 | 1.004 |
| hex: http/css-16kx64 | 2097280 | 20889.4 ± 0.5% | 1.004 | 0.181 | 1.005 | 0.992 | 1.004 | 1.004 | 1.005 | 1.004 | 1.005 | 0.196 | 1.005 |
| hex: http/css-1m | 524290 | 43723.4 ± 0.4% | 1.002 | 0.088 | 1.001 | 0.590 | 1.001 | 1.000 | 1.000 | 1.002 | 1.001 | 0.093 | 1.001 |
| hex: shuffled/dickens-1m | 524290 | 42509.2 ± 1.5% | 1.003 | 0.091 | 1.002 | 0.607 | 1.002 | 1.001 | 1.002 | 1.001 | 1.000 | 0.097 | 1.002 |

## Losses

Each workload where a claim's path ran slower than the path it replaces by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding: J7 wide vectors off runs at 1.066 of all on.
- CLDR supplemental, 34 texts, decoding: J8 decoder fast path off runs at 1.070 of all on.
- CLDR supplemental, 34 texts, decoding: J12 decoder escape words off runs at 1.073 of all on.
- CLDR supplemental, 34 texts, decoding: J13 decoder escape blocks off runs at 1.070 of all on.
- qlog records, JSON text sequence, decoding: J5 UTF-8 vectors off runs at 1.058 of all on.
- qlog records, JSON text sequence, decoding: J7 wide vectors off runs at 1.065 of all on.
- qlog records, JSON text sequence, decoding: J8 decoder fast path off runs at 1.065 of all on.
- qlog records, JSON text sequence, decoding: J12 decoder escape words off runs at 1.060 of all on.
- qlog records, JSON text sequence, decoding: J13 decoder escape blocks off runs at 1.064 of all on.
- messages: 50 nested objects, decoding: J5 UTF-8 vectors off runs at 1.086 of all on.
- messages: 50 nested objects, decoding: J7 wide vectors off runs at 1.087 of all on.
- messages: 50 nested objects, decoding: J8 decoder fast path off runs at 1.088 of all on.
- messages: 50 nested objects, decoding: J12 decoder escape words off runs at 1.097 of all on.
- messages: 50 nested objects, decoding: J13 decoder escape blocks off runs at 1.089 of all on.
- string: silesia/dickens, decoding: J7 wide vectors off runs at 1.085 of all on.
- string: silesia/dickens, decoding: J8 decoder fast path off runs at 1.083 of all on.
- string: silesia/dickens, decoding: J13 decoder escape blocks off runs at 1.099 of all on.
- string: silesia/samba, decoding: J7 wide vectors off runs at 1.065 of all on.
- string: silesia/samba, decoding: J8 decoder fast path off runs at 1.067 of all on.
- string: silesia/samba, decoding: J13 decoder escape blocks off runs at 1.066 of all on.
- string: canterbury/alice29.txt, decoding: J7 wide vectors off runs at 1.086 of all on.
- string: canterbury/alice29.txt, decoding: J8 decoder fast path off runs at 1.117 of all on.
- string: canterbury/alice29.txt, decoding: J13 decoder escape blocks off runs at 1.154 of all on.
- string: canterbury/asyoulik.txt, decoding: J7 wide vectors off runs at 1.137 of all on.
- string: canterbury/asyoulik.txt, decoding: J8 decoder fast path off runs at 1.136 of all on.
- string: canterbury/asyoulik.txt, decoding: J12 decoder escape words off runs at 1.063 of all on.
- string: canterbury/asyoulik.txt, decoding: J13 decoder escape blocks off runs at 1.145 of all on.
- string: canterbury/lcet10.txt, decoding: J7 wide vectors off runs at 1.104 of all on.
- string: canterbury/lcet10.txt, decoding: J8 decoder fast path off runs at 1.113 of all on.
- string: canterbury/lcet10.txt, decoding: J13 decoder escape blocks off runs at 1.125 of all on.
- hex: http/js-1kx1024, decoding: J5 UTF-8 vectors off runs at 1.054 of all on.
- hex: http/css-1kx1024, decoding: J5 UTF-8 vectors off runs at 1.062 of all on.
- messages: a tree of 341 objects, encoding: J2 hex vectors off runs at 1.059 of all on.
- messages: a tree of 341 objects, encoding: J5 UTF-8 vectors off runs at 1.075 of all on.
- messages: a tree of 341 objects, encoding: J7 wide vectors off runs at 1.081 of all on.
- messages: a tree of 341 objects, encoding: J9 encoder fast path off runs at 1.081 of all on.
- messages: a tree of 341 objects, encoding: J14 encoder escape blocks off runs at 1.082 of all on.

## UTF-8 validation against simdutf

stdx's `is_utf8`, the check the loops apply to every string's octets, run alone over each string workload's octets at the width the host's features pick (16 lanes on aarch64, AVX2's 32 or AVX-512's 64 on x86-64, decision 39), beside simdutf 9.3.3's `validate_utf8` in the same run; on a host with AVX-512, again with AVX2 alone. Each ratio is stdx's throughput over the other's. simdutf picks its kernel at run time. Before timing, every copy of the check and simdutf judged 20000 seeded buffers and each workload, whole and changed, alike.

| Workload | Octets | stdx, MB/s | simdutf, MB/s | stdx / simdutf | stdx with AVX2 alone, MB/s | stdx / stdx with AVX2 alone |
|---|---|---|---|---|---|---|
| string: silesia/dickens | 166668 | 165435.5 ± 0.6% | 120572.2 ± 0.6% | 1.372 | 99837.4 ± 0.7% | 1.657 |
| string: silesia/nci | 1048576 | 167515.4 ± 1.4% | 121961.7 ± 1.0% | 1.374 | 100625.8 ± 1.0% | 1.665 |
| string: silesia/reymont | 1048576 | 166610.7 ± 1.3% | 121249.0 ± 1.0% | 1.374 | 100365.9 ± 1.0% | 1.660 |
| string: silesia/samba | 65546 | 161050.2 ± 1.3% | 118596.6 ± 5.6% | 1.358 | 98446.1 ± 0.7% | 1.636 |
| string: silesia/webster | 1048576 | 162930.8 ± 8.9% | 120503.6 ± 1.4% | 1.352 | 100634.9 ± 0.8% | 1.619 |
| string: silesia/xml | 1048576 | 165314.5 ± 9.5% | 121470.9 ± 1.6% | 1.361 | 100494.7 ± 1.0% | 1.645 |
| string: canterbury/alice29.txt | 152089 | 165982.8 ± 0.9% | 121410.1 ± 5.1% | 1.367 | 100314.6 ± 0.5% | 1.655 |
| string: canterbury/asyoulik.txt | 125179 | 165914.4 ± 0.4% | 121503.1 ± 0.6% | 1.366 | 100569.8 ± 0.6% | 1.650 |
| string: canterbury/lcet10.txt | 426754 | 167924.0 ± 0.3% | 122043.9 ± 0.6% | 1.376 | 101199.9 ± 0.4% | 1.659 |
| string: canterbury/plrabn12.txt | 481861 | 168330.3 ± 0.2% | 122678.1 ± 0.2% | 1.372 | 101299.6 ± 0.5% | 1.662 |
| string: canterbury-large/E.coli | 1048576 | 167494.1 ± 1.0% | 122421.8 ± 0.5% | 1.368 | 100857.2 ± 0.8% | 1.661 |
| string: canterbury-large/bible.txt | 1048576 | 168407.3 ± 0.4% | 122604.8 ± 0.5% | 1.374 | 101645.8 ± 0.4% | 1.657 |
| string: canterbury-large/world192.txt | 1048576 | 167036.7 ± 0.9% | 121924.8 ± 0.7% | 1.370 | 100743.7 ± 4.2% | 1.658 |
| string: http/html-1m | 1048576 | 147122.9 ± 7.6% | 112238.9 ± 0.5% | 1.311 | 93951.0 ± 0.5% | 1.566 |
| string: http/json-1m | 1048576 | 121464.7 ± 0.4% | 106283.3 ± 1.0% | 1.143 | 82481.9 ± 0.7% | 1.473 |
| string: http/js-1m | 1048576 | 164322.8 ± 0.7% | 121237.3 ± 0.9% | 1.355 | 99420.9 ± 5.2% | 1.653 |
| string: http/css-1m | 1048576 | 167312.7 ± 1.2% | 122075.1 ± 0.6% | 1.371 | 100221.8 ± 0.5% | 1.669 |
| string: dickens as Cyrillic and CJK | 1847045 | 23465.2 ± 0.2% | 20850.4 ± 0.9% | 1.125 | 14862.0 ± 0.5% | 1.579 |

## Losses to simdutf

None.

## UTF-8 validation by the buffer's offset from a 64-octet line

| Buffer | Octets | Offset | stdx, MB/s | simdutf, MB/s | stdx / simdutf | stdx with AVX2 alone, MB/s | stdx / stdx with AVX2 alone |
|---|---|---|---|---|---|---|---|
| string: canterbury-large/bible.txt | 1048576 | 0 | 168103.6 ± 1.3% | 122916.7 ± 0.2% | 1.368 | 101945.3 ± 0.4% | 1.649 |
| string: canterbury-large/bible.txt | 1048576 | 1 | 168069.9 ± 0.4% | 122910.6 ± 0.3% | 1.367 | 101239.9 ± 0.8% | 1.660 |
| string: canterbury-large/bible.txt | 1048576 | 8 | 167527.0 ± 0.6% | 122874.2 ± 0.3% | 1.363 | 101130.4 ± 0.3% | 1.657 |
| string: canterbury-large/bible.txt | 1048576 | 16 | 168209.6 ± 0.3% | 122825.4 ± 0.5% | 1.370 | 101046.3 ± 4.2% | 1.665 |
| string: canterbury-large/bible.txt | 1048576 | 32 | 168206.1 ± 0.4% | 122821.9 ± 0.1% | 1.370 | 101238.6 ± 4.1% | 1.661 |
| string: canterbury-large/bible.txt | 1048576 | 48 | 167794.6 ± 0.9% | 122576.6 ± 0.2% | 1.369 | 101726.8 ± 4.5% | 1.649 |
| string: dickens as Cyrillic and CJK | 1048576 | 0 | 24335.6 ± 2.2% | 21737.1 ± 0.3% | 1.120 | 15349.0 ± 0.3% | 1.585 |
| string: dickens as Cyrillic and CJK | 1048576 | 1 | 24331.9 ± 0.5% | 21738.5 ± 0.7% | 1.119 | 15319.3 ± 1.5% | 1.588 |
| string: dickens as Cyrillic and CJK | 1048576 | 8 | 24360.5 ± 0.4% | 21707.4 ± 0.2% | 1.122 | 15306.9 ± 1.8% | 1.591 |
| string: dickens as Cyrillic and CJK | 1048576 | 16 | 24300.1 ± 0.3% | 21684.5 ± 0.7% | 1.121 | 15302.4 ± 1.8% | 1.588 |
| string: dickens as Cyrillic and CJK | 1048576 | 32 | 24271.9 ± 0.3% | 21670.9 ± 0.4% | 1.120 | 15298.1 ± 0.5% | 1.587 |
| string: dickens as Cyrillic and CJK | 1048576 | 48 | 24297.6 ± 0.3% | 21667.6 ± 2.3% | 1.121 | 15320.6 ± 1.4% | 1.586 |

## Messages against serde_json's typed code

stdx's encoder a token a call through `TextWriter`'s methods, a member's name and its value in one `member_*` call, beside serde_json 1.0.154 writing the same messages from Rust types, as code of the form serde's derive generates writes them. Octets are the ones written.

| Workload | Octets | TextWriter's methods, MB/s | serde_json typed, MB/s | stdx / serde_json typed |
|---|---|---|---|---|
| messages: 11 string members | 1025025 | 1225.1 ± 3.3% | 803.9 ± 0.4% | 1.524 |
| messages: 50 nested objects | 1121600 | 1679.2 ± 1.3% | 876.9 ± 0.2% | 1.915 |
| messages: a tree of 341 objects | 612600 | 483.2 ± 2.2% | 502.2 ± 1.7% | 0.962 |

## Against the baselines

stdx with every claim on, timed beside simdjson 5.1.1, yyjson 0.13.0, Zig 0.16.0's std.json, serde_json 1.0.154 and Go's encoding/json/jsontext in the same run. Each ratio is stdx's throughput over the baseline's; below 1, the baseline is faster. stdx is built for the architecture's baseline CPU in ReleaseSafe. Each baseline is built for the same CPU, the C, C++ and Zig ones in ReleaseFast (decision 75), and simdjson picks its kernel at run time. Decoding visits every value; encoding writes each text from its tokens.

## Decoding against the baselines

Octets are the text's. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1378.7 ± 0.9% | 1507.2 ± 1.6% | 1116.5 ± 2.1% | 390.1 ± 2.7% | 672.2 ± 0.4% | 363.9 ± 1.8% | 0.915 | 1.235 | 3.534 | 2.051 | 3.788 |
| qlog records, JSON text sequence | 1467503 | 1096.7 ± 0.6% | 1246.8 ± 0.8% | 1122.7 ± 0.7% | 330.4 ± 0.7% | 753.4 ± 0.9% | 309.2 ± 0.9% | 0.880 | 0.977 | 3.319 | 1.456 | 3.547 |
| messages: 11 string members | 1025025 | 1063.1 ± 0.7% | 2039.6 ± 1.3% | 728.2 ± 2.3% | 336.5 ± 1.9% | 508.3 ± 1.2% | 288.8 ± 3.1% | 0.521 | 1.460 | 3.159 | 2.091 | 3.681 |
| messages: 50 nested objects | 1121600 | 1341.1 ± 0.1% | 1733.6 ± 1.8% | 1457.3 ± 0.3% | 432.5 ± 0.8% | 905.3 ± 19.8% | 419.6 ± 3.8% | 0.774 | 0.920 | 3.101 | 1.481 | 3.196 |
| messages: a tree of 341 objects | 612600 | 669.3 ± 0.2% | 854.8 ± 1.2% | 694.3 ± 1.6% | 182.5 ± 0.9% | 613.1 ± 0.5% | 208.9 ± 0.6% | 0.783 | 0.964 | 3.667 | 1.092 | 3.204 |
| string: silesia/dickens | 172528 | 6717.7 ± 0.6% | 3464.0 ± 6.0% | 2815.4 ± 1.1% | 317.2 ± 2.7% | 3093.2 ± 2.0% | 571.8 ± 1.5% | 1.939 | 2.386 | 21.181 | 2.172 | 11.749 |
| string: silesia/nci | 1075110 | 5342.4 ± 0.7% | 3922.8 ± 0.4% | 2996.8 ± 0.3% | 642.8 ± 0.7% | 3610.9 ± 0.9% | 541.0 ± 4.1% | 1.362 | 1.783 | 8.311 | 1.480 | 9.875 |
| string: silesia/reymont | 1075159 | 3496.5 ± 1.2% | 3409.0 ± 0.4% | 1934.7 ± 2.4% | 341.5 ± 0.5% | 2093.9 ± 1.3% | 491.6 ± 3.9% | 1.026 | 1.807 | 10.237 | 1.670 | 7.113 |
| string: silesia/samba | 97582 | 3974.3 ± 0.8% | 3793.5 ± 0.4% | 3048.1 ± 0.2% | 326.8 ± 1.0% | 1945.9 ± 1.4% | 419.4 ± 0.9% | 1.048 | 1.304 | 12.163 | 2.042 | 9.477 |
| string: silesia/webster | 1098490 | 4368.0 ± 1.4% | 2433.2 ± 0.2% | 1726.1 ± 0.3% | 308.7 ± 0.3% | 2051.6 ± 0.5% | 454.1 ± 1.5% | 1.795 | 2.531 | 14.152 | 2.129 | 9.619 |
| string: silesia/xml | 1090118 | 6056.1 ± 0.4% | 5035.9 ± 0.4% | 2442.1 ± 0.4% | 509.7 ± 0.5% | 3325.2 ± 0.3% | 546.1 ± 2.6% | 1.203 | 2.480 | 11.882 | 1.821 | 11.090 |
| string: canterbury/alice29.txt | 159425 | 5792.9 ± 0.6% | 2798.5 ± 0.9% | 2791.0 ± 1.1% | 299.7 ± 0.4% | 2757.6 ± 2.8% | 520.2 ± 1.2% | 2.070 | 2.076 | 19.326 | 2.101 | 11.136 |
| string: canterbury/asyoulik.txt | 132198 | 4296.5 ± 1.1% | 2626.0 ± 11.0% | 2781.1 ± 2.3% | 305.6 ± 0.3% | 2425.1 ± 1.2% | 452.5 ± 1.9% | 1.636 | 1.545 | 14.057 | 1.772 | 9.496 |
| string: canterbury/lcet10.txt | 441884 | 6638.2 ± 1.2% | 3289.1 ± 0.3% | 2312.4 ± 1.2% | 345.6 ± 0.3% | 2797.5 ± 0.8% | 569.3 ± 0.3% | 2.018 | 2.871 | 19.206 | 2.373 | 11.661 |
| string: canterbury/plrabn12.txt | 503330 | 5482.0 ± 0.4% | 3172.9 ± 0.6% | 1842.0 ± 0.6% | 323.4 ± 0.4% | 2838.9 ± 0.3% | 528.0 ± 0.4% | 1.728 | 2.976 | 16.951 | 1.931 | 10.382 |
| string: canterbury-large/E.coli | 1048578 | 32374.0 ± 0.7% | 12920.7 ± 0.1% | 3428.9 ± 0.2% | 1283.6 ± 0.4% | 8928.9 ± 0.4% | 920.7 ± 2.4% | 2.506 | 9.442 | 25.221 | 3.626 | 35.162 |
| string: canterbury-large/bible.txt | 1055886 | 8543.5 ± 0.8% | 5228.2 ± 0.4% | 2806.3 ± 0.3% | 356.8 ± 0.4% | 3878.7 ± 0.3% | 610.0 ± 2.3% | 1.634 | 3.044 | 23.947 | 2.203 | 14.006 |
| string: canterbury-large/world192.txt | 1103121 | 4096.6 ± 0.4% | 2305.0 ± 0.3% | 1761.9 ± 0.3% | 327.2 ± 0.2% | 2098.5 ± 0.4% | 451.1 ± 3.6% | 1.777 | 2.325 | 12.519 | 1.952 | 9.080 |
| string: http/html-1m | 1058582 | 9042.7 ± 5.2% | 4711.5 ± 1.3% | 2686.0 ± 0.2% | 425.8 ± 0.2% | 3650.7 ± 0.8% | 587.9 ± 2.0% | 1.919 | 3.367 | 21.236 | 2.477 | 15.380 |
| string: http/json-1m | 1190272 | 3289.7 ± 0.6% | 1250.2 ± 0.3% | 2083.0 ± 0.3% | 473.7 ± 0.7% | 1334.1 ± 0.9% | 425.2 ± 0.5% | 2.631 | 1.579 | 6.945 | 2.466 | 7.737 |
| string: http/js-1m | 1144362 | 2815.5 ± 0.8% | 1600.8 ± 0.6% | 1316.4 ± 0.2% | 324.0 ± 0.3% | 1418.0 ± 0.8% | 377.6 ± 4.3% | 1.759 | 2.139 | 8.691 | 1.986 | 7.457 |
| string: http/css-1m | 1097820 | 3267.8 ± 0.4% | 2877.0 ± 0.5% | 2264.2 ± 0.4% | 451.2 ± 0.6% | 2061.0 ± 0.3% | 437.7 ± 1.5% | 1.136 | 1.443 | 7.242 | 1.586 | 7.466 |
| string: dickens as Cyrillic and CJK | 1883069 | 5787.4 ± 0.8% | 3031.9 ± 2.4% | 657.0 ± 0.5% | 377.8 ± 0.3% | 509.5 ± 0.6% | 162.6 ± 4.2% | 1.909 | 8.809 | 15.317 | 11.359 | 35.596 |
| string: dickens as Cyrillic and CJK, as \u escapes | 5075485 | 1202.0 ± 1.2% | 1236.4 ± 1.5% | 1102.6 ± 2.5% | 264.3 ± 0.5% | 478.9 ± 0.6% | 230.8 ± 3.8% | 0.972 | 1.090 | 4.548 | 2.510 | 5.207 |
| hex: silesia/dickens | 524290 | 47160.1 ± 0.4% | 15145.0 ± 0.3% | 3555.2 ± 0.5% | 476.3 ± 1.4% | 8938.0 ± 0.2% | 1135.3 ± 2.5% | 3.114 | 13.265 | 99.013 | 5.276 | 41.539 |
| hex: silesia/mozilla | 524290 | 47463.6 ± 0.2% | 15148.6 ± 0.1% | 3489.6 ± 0.4% | 430.8 ± 0.4% | 8913.2 ± 0.6% | 1134.8 ± 0.8% | 3.133 | 13.601 | 110.170 | 5.325 | 41.827 |
| hex: silesia/mr | 524290 | 45733.7 ± 1.2% | 15088.8 ± 1.2% | 3489.8 ± 3.8% | 642.5 ± 0.6% | 8888.9 ± 0.7% | 1132.9 ± 0.8% | 3.031 | 13.105 | 71.181 | 5.145 | 40.369 |
| hex: silesia/nci | 524290 | 46360.2 ± 0.9% | 15124.3 ± 0.8% | 3559.0 ± 0.2% | 807.0 ± 2.9% | 8923.5 ± 0.4% | 1135.9 ± 0.4% | 3.065 | 13.026 | 57.445 | 5.195 | 40.813 |
| hex: silesia/ooffice | 524290 | 49037.7 ± 0.2% | 15129.0 ± 0.4% | 3501.7 ± 0.1% | 346.0 ± 0.5% | 8917.6 ± 0.2% | 1138.3 ± 0.2% | 3.241 | 14.004 | 141.742 | 5.499 | 43.081 |
| hex: silesia/osdb | 524290 | 46342.8 ± 1.1% | 14985.8 ± 1.0% | 3467.1 ± 0.7% | 453.8 ± 1.7% | 8855.0 ± 0.6% | 1117.6 ± 1.1% | 3.092 | 13.367 | 102.123 | 5.233 | 41.468 |
| hex: silesia/reymont | 524290 | 45688.1 ± 0.9% | 15072.0 ± 0.5% | 3555.0 ± 0.7% | 498.0 ± 0.7% | 8892.8 ± 0.6% | 1131.7 ± 0.8% | 3.031 | 12.852 | 91.745 | 5.138 | 40.373 |
| hex: silesia/samba | 524290 | 45723.7 ± 0.4% | 15112.7 ± 0.5% | 3492.3 ± 0.4% | 368.0 ± 0.5% | 8908.1 ± 0.3% | 1134.6 ± 1.0% | 3.026 | 13.093 | 124.266 | 5.133 | 40.300 |
| hex: silesia/sao | 524290 | 45775.7 ± 0.3% | 15116.7 ± 1.1% | 3491.6 ± 0.2% | 280.2 ± 1.1% | 8916.7 ± 1.1% | 1136.3 ± 0.9% | 3.028 | 13.110 | 163.391 | 5.134 | 40.286 |
| hex: silesia/webster | 524290 | 46900.3 ± 0.9% | 15069.4 ± 1.2% | 3546.7 ± 0.8% | 449.5 ± 0.9% | 8882.5 ± 0.9% | 1123.5 ± 1.0% | 3.112 | 13.224 | 104.337 | 5.280 | 41.743 |
| hex: silesia/x-ray | 524290 | 48990.0 ± 0.9% | 15021.8 ± 0.7% | 3490.9 ± 3.4% | 425.1 ± 0.6% | 8894.9 ± 0.5% | 1130.3 ± 0.5% | 3.261 | 14.034 | 115.241 | 5.508 | 43.341 |
| hex: silesia/xml | 524290 | 45596.4 ± 2.1% | 15090.3 ± 1.5% | 3557.4 ± 1.5% | 722.9 ± 3.0% | 8901.5 ± 0.5% | 1130.3 ± 1.3% | 3.022 | 12.817 | 63.078 | 5.122 | 40.341 |
| hex: canterbury/alice29.txt | 304180 | 48664.9 ± 0.8% | 14123.6 ± 1.4% | 3553.2 ± 0.6% | 480.5 ± 1.2% | 8909.0 ± 0.7% | 1133.1 ± 3.5% | 3.446 | 13.696 | 101.274 | 5.462 | 42.950 |
| hex: canterbury/asyoulik.txt | 250360 | 46167.8 ± 0.8% | 14866.6 ± 0.6% | 3472.3 ± 0.5% | 466.4 ± 0.6% | 8843.8 ± 0.5% | 1131.6 ± 4.2% | 3.105 | 13.296 | 98.987 | 5.220 | 40.799 |
| hex: canterbury/cp.html | 49208 | 44196.4 ± 1.2% | 14432.0 ± 0.6% | 3564.6 ± 0.4% | 508.0 ± 0.8% | 9220.9 ± 0.7% | 1121.3 ± 1.3% | 3.062 | 12.399 | 86.995 | 4.793 | 39.416 |
| hex: canterbury/fields.c | 22302 | 49477.1 ± 0.9% | 17458.6 ± 1.1% | 3652.6 ± 0.7% | 565.6 ± 0.6% | 9222.1 ± 0.6% | 1100.9 ± 1.8% | 2.834 | 13.546 | 87.482 | 5.365 | 44.942 |
| hex: canterbury/grammar.lsp | 7444 | 43608.4 ± 1.4% | 17237.5 ± 0.5% | 3613.6 ± 0.6% | 738.9 ± 0.3% | 8933.4 ± 0.3% | 1053.8 ± 2.9% | 2.530 | 12.068 | 59.021 | 4.881 | 41.382 |
| hex: canterbury/kennedy.xls | 524290 | 46858.7 ± 0.4% | 15012.3 ± 0.4% | 3552.7 ± 0.3% | 759.1 ± 1.6% | 8892.2 ± 0.6% | 1118.8 ± 6.0% | 3.121 | 13.190 | 61.733 | 5.270 | 41.883 |
| hex: canterbury/lcet10.txt | 524290 | 46347.7 ± 0.9% | 15064.9 ± 1.0% | 3546.6 ± 1.1% | 481.0 ± 2.7% | 8913.0 ± 0.4% | 1131.6 ± 0.7% | 3.077 | 13.068 | 96.356 | 5.200 | 40.956 |
| hex: canterbury/plrabn12.txt | 524290 | 45505.4 ± 0.7% | 15085.3 ± 0.9% | 3552.0 ± 0.2% | 464.6 ± 1.9% | 8927.2 ± 0.4% | 1130.7 ± 0.4% | 3.017 | 12.811 | 97.936 | 5.097 | 40.245 |
| hex: canterbury/ptt5 | 524290 | 45640.7 ± 0.6% | 15084.0 ± 0.4% | 3496.9 ± 0.2% | 665.1 ± 0.5% | 8897.5 ± 0.8% | 1134.8 ± 1.1% | 3.026 | 13.052 | 68.626 | 5.130 | 40.219 |
| hex: canterbury/sum | 76482 | 44849.6 ± 0.6% | 15448.5 ± 0.7% | 3564.4 ± 0.4% | 584.5 ± 0.2% | 8916.3 ± 5.2% | 1127.9 ± 3.2% | 2.903 | 12.582 | 76.726 | 5.030 | 39.765 |
| hex: canterbury/xargs.1 | 8456 | 44761.6 ± 0.8% | 17383.3 ± 0.3% | 3559.4 ± 0.4% | 718.2 ± 2.1% | 8988.2 ± 1.3% | 1100.5 ± 3.0% | 2.575 | 12.575 | 62.325 | 4.980 | 40.674 |
| hex: canterbury-large/E.coli | 524290 | 45822.1 ± 2.3% | 15081.9 ± 2.9% | 3495.0 ± 0.4% | 963.0 ± 0.3% | 8899.1 ± 0.4% | 1125.7 ± 7.1% | 3.038 | 13.111 | 47.585 | 5.149 | 40.706 |
| hex: canterbury-large/bible.txt | 524290 | 44921.4 ± 1.7% | 15003.8 ± 0.6% | 3487.4 ± 0.8% | 496.9 ± 1.1% | 8875.5 ± 0.4% | 1071.5 ± 0.7% | 2.994 | 12.881 | 90.397 | 5.061 | 41.926 |
| hex: canterbury-large/world192.txt | 524290 | 46070.7 ± 1.0% | 15085.1 ± 2.9% | 3570.1 ± 0.1% | 467.2 ± 0.7% | 8926.0 ± 0.5% | 1128.3 ± 4.8% | 3.054 | 12.905 | 98.602 | 5.161 | 40.833 |
| hex: http/html-1kx1024 | 2099200 | 17761.9 ± 0.2% | 12498.0 ± 3.0% | 3166.4 ± 1.0% | 505.9 ± 0.5% | 7346.6 ± 7.1% | 978.1 ± 2.4% | 1.421 | 5.610 | 35.108 | 2.418 | 18.159 |
| hex: http/html-16kx64 | 2097280 | 34493.1 ± 0.2% | 14111.2 ± 2.2% | 3387.0 ± 0.8% | 512.4 ± 0.8% | 8664.7 ± 0.8% | 1080.5 ± 1.2% | 2.444 | 10.184 | 67.321 | 3.981 | 31.924 |
| hex: http/html-1m | 524290 | 48640.7 ± 1.4% | 15051.7 ± 0.5% | 3481.6 ± 0.6% | 505.1 ± 0.6% | 8889.6 ± 0.7% | 1125.3 ± 3.6% | 3.232 | 13.971 | 96.296 | 5.472 | 43.225 |
| hex: http/json-1kx1024 | 2099200 | 18431.8 ± 1.3% | 12245.8 ± 5.6% | 3177.8 ± 1.5% | 671.5 ± 1.2% | 7448.4 ± 1.5% | 982.2 ± 1.1% | 1.505 | 5.800 | 27.450 | 2.475 | 18.766 |
| hex: http/json-16kx64 | 2097280 | 34739.2 ± 0.9% | 13902.4 ± 0.4% | 3390.2 ± 0.3% | 679.6 ± 0.8% | 8565.2 ± 1.0% | 1073.5 ± 3.3% | 2.499 | 10.247 | 51.120 | 4.056 | 32.360 |
| hex: http/json-1m | 524290 | 45916.5 ± 0.2% | 15077.1 ± 0.8% | 3566.8 ± 0.4% | 699.7 ± 0.9% | 8914.7 ± 0.7% | 1110.1 ± 4.0% | 3.045 | 12.873 | 65.625 | 5.151 | 41.364 |
| hex: http/js-1kx1024 | 2099200 | 18045.2 ± 0.7% | 12205.5 ± 0.4% | 3175.3 ± 0.5% | 488.8 ± 0.4% | 7384.2 ± 2.2% | 980.3 ± 1.6% | 1.478 | 5.683 | 36.917 | 2.444 | 18.407 |
| hex: http/js-16kx64 | 2097280 | 34353.3 ± 0.8% | 14060.4 ± 0.3% | 3389.3 ± 0.4% | 494.3 ± 0.3% | 8625.8 ± 1.8% | 1081.2 ± 3.3% | 2.443 | 10.136 | 69.503 | 3.983 | 31.772 |
| hex: http/js-1m | 524290 | 46022.4 ± 0.6% | 15097.1 ± 0.6% | 3541.7 ± 0.4% | 513.2 ± 0.3% | 8916.6 ± 0.2% | 1104.9 ± 5.4% | 3.048 | 12.994 | 89.670 | 5.161 | 41.654 |
| hex: http/css-1kx1024 | 2099200 | 17643.7 ± 1.1% | 12109.8 ± 5.1% | 3165.8 ± 1.7% | 568.2 ± 0.7% | 7454.0 ± 2.6% | 984.5 ± 0.8% | 1.457 | 5.573 | 31.050 | 2.367 | 17.922 |
| hex: http/css-16kx64 | 2097280 | 34621.6 ± 0.1% | 13876.3 ± 0.4% | 3394.8 ± 0.4% | 580.6 ± 1.2% | 8481.3 ± 1.1% | 1075.5 ± 2.5% | 2.495 | 10.198 | 59.629 | 4.082 | 32.191 |
| hex: http/css-1m | 524290 | 46380.1 ± 0.3% | 15086.7 ± 1.1% | 3560.0 ± 0.6% | 558.7 ± 1.1% | 8918.5 ± 1.1% | 1109.4 ± 4.8% | 3.074 | 13.028 | 83.014 | 5.200 | 41.808 |
| hex: shuffled/dickens-1m | 524290 | 45358.1 ± 0.6% | 15007.1 ± 0.6% | 3479.1 ± 0.6% | 473.6 ± 0.8% | 8840.8 ± 0.9% | 1114.1 ± 2.2% | 3.022 | 13.037 | 95.780 | 5.131 | 40.713 |

## Encoding against the baselines

Octets are the ones stdx writes. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1733.4 ± 4.2% | 1476.4 ± 0.6% | 1025.6 ± 0.6% | 461.5 ± 1.1% | 441.4 ± 1.5% | 497.2 ± 4.0% | 1.174 | 1.690 | 3.756 | 3.927 | 3.487 |
| qlog records, JSON text sequence | 1467503 | 1645.1 ± 2.7% | 1215.3 ± 5.6% | 941.8 ± 2.1% | 422.5 ± 5.7% | 532.3 ± 0.8% | 350.9 ± 1.2% | 1.354 | 1.747 | 3.894 | 3.091 | 4.689 |
| messages: 11 string members | 1025025 | 1321.2 ± 0.3% | 1103.9 ± 0.4% | 765.4 ± 2.0% | 409.6 ± 2.7% | 415.6 ± 0.6% | 433.0 ± 1.0% | 1.197 | 1.726 | 3.225 | 3.179 | 3.051 |
| messages: 50 nested objects | 1121600 | 1987.5 ± 1.2% | 1875.1 ± 0.6% | 1341.9 ± 0.4% | 590.5 ± 0.7% | 608.2 ± 6.0% | 506.9 ± 0.9% | 1.060 | 1.481 | 3.366 | 3.268 | 3.921 |
| messages: a tree of 341 objects | 612600 | 593.7 ± 3.2% | 675.8 ± 1.4% | 578.8 ± 4.3% | 333.0 ± 4.2% | 352.5 ± 1.8% | 219.3 ± 0.9% | 0.879 | 1.026 | 1.783 | 1.684 | 2.707 |
| string: silesia/dickens | 172528 | 13030.8 ± 1.5% | 3958.4 ± 0.7% | 3060.8 ± 1.9% | 333.4 ± 1.0% | 1526.4 ± 0.9% | 1184.0 ± 0.9% | 3.292 | 4.257 | 39.082 | 8.537 | 11.006 |
| string: silesia/nci | 1075110 | 11177.7 ± 0.6% | 4709.3 ± 0.9% | 3090.7 ± 1.5% | 902.5 ± 0.6% | 1581.9 ± 0.9% | 1191.8 ± 1.0% | 2.374 | 3.617 | 12.385 | 7.066 | 9.379 |
| string: silesia/reymont | 1075159 | 5252.6 ± 2.2% | 1863.3 ± 0.7% | 1884.1 ± 0.5% | 378.3 ± 1.8% | 1292.8 ± 1.6% | 1043.4 ± 1.0% | 2.819 | 2.788 | 13.886 | 4.063 | 5.034 |
| string: silesia/samba | 97582 | 6326.8 ± 0.6% | 2697.1 ± 0.9% | 4055.3 ± 1.1% | 349.0 ± 1.1% | 1263.3 ± 1.4% | 1182.4 ± 1.7% | 2.346 | 1.560 | 18.129 | 5.008 | 5.351 |
| string: silesia/webster | 1098490 | 7015.2 ± 1.2% | 1968.6 ± 0.3% | 1751.6 ± 0.9% | 351.3 ± 1.2% | 1253.3 ± 1.2% | 607.2 ± 0.6% | 3.564 | 4.005 | 19.967 | 5.597 | 11.553 |
| string: silesia/xml | 1090118 | 10758.9 ± 0.6% | 3196.6 ± 1.6% | 2495.2 ± 1.2% | 603.8 ± 1.3% | 1717.8 ± 1.2% | 978.1 ± 1.1% | 3.366 | 4.312 | 17.818 | 6.263 | 10.999 |
| string: canterbury/alice29.txt | 159425 | 12728.9 ± 1.0% | 2903.1 ± 1.3% | 3028.6 ± 1.5% | 316.7 ± 1.0% | 1357.4 ± 1.4% | 1092.6 ± 0.8% | 4.385 | 4.203 | 40.194 | 9.377 | 11.650 |
| string: canterbury/asyoulik.txt | 132198 | 10934.5 ± 3.1% | 2102.0 ± 3.6% | 3120.4 ± 3.9% | 315.9 ± 1.0% | 1232.4 ± 2.8% | 954.8 ± 1.0% | 5.202 | 3.504 | 34.617 | 8.873 | 11.452 |
| string: canterbury/lcet10.txt | 441884 | 12660.5 ± 1.1% | 3047.9 ± 1.0% | 2564.3 ± 0.5% | 366.3 ± 1.0% | 1469.8 ± 2.0% | 1193.3 ± 0.6% | 4.154 | 4.937 | 34.564 | 8.614 | 10.610 |
| string: canterbury/plrabn12.txt | 503330 | 8790.0 ± 1.1% | 2312.1 ± 1.0% | 2096.0 ± 0.8% | 346.5 ± 1.7% | 1371.9 ± 3.5% | 1109.8 ± 1.3% | 3.802 | 4.194 | 25.369 | 6.407 | 7.921 |
| string: canterbury-large/E.coli | 1048578 | 34149.5 ± 2.2% | 16014.1 ± 2.0% | 3460.9 ± 2.8% | 1687.3 ± 0.8% | 3115.3 ± 2.9% | 1409.8 ± 0.8% | 2.132 | 9.867 | 20.239 | 10.962 | 24.224 |
| string: canterbury-large/bible.txt | 1055886 | 9575.3 ± 1.0% | 4876.2 ± 0.8% | 2994.5 ± 3.9% | 405.5 ± 1.8% | 2013.1 ± 4.9% | 1485.5 ± 0.5% | 1.964 | 3.198 | 23.615 | 4.757 | 6.446 |
| string: canterbury-large/world192.txt | 1103121 | 6630.7 ± 1.0% | 1721.5 ± 1.4% | 1867.6 ± 1.4% | 345.6 ± 0.4% | 1266.6 ± 1.8% | 962.7 ± 4.6% | 3.852 | 3.550 | 19.183 | 5.235 | 6.887 |
| string: http/html-1m | 1058582 | 10059.4 ± 1.8% | 4301.6 ± 1.4% | 2853.7 ± 0.6% | 418.8 ± 2.6% | 1988.1 ± 0.6% | 849.7 ± 0.9% | 2.339 | 3.525 | 24.018 | 5.060 | 11.839 |
| string: http/json-1m | 1190272 | 8321.7 ± 0.8% | 1583.1 ± 0.7% | 1569.7 ± 0.7% | 554.0 ± 0.8% | 1015.9 ± 0.5% | 842.7 ± 0.9% | 5.257 | 5.301 | 15.020 | 8.191 | 9.875 |
| string: http/js-1m | 1144362 | 6536.3 ± 1.8% | 1114.2 ± 3.7% | 1373.4 ± 0.7% | 329.1 ± 0.5% | 1028.4 ± 0.9% | 753.9 ± 0.4% | 5.866 | 4.759 | 19.859 | 6.356 | 8.669 |
| string: http/css-1m | 1097820 | 9299.1 ± 0.8% | 1478.0 ± 1.3% | 2264.5 ± 1.0% | 506.9 ± 1.1% | 1126.3 ± 1.9% | 877.9 ± 0.5% | 6.292 | 4.106 | 18.345 | 8.256 | 10.592 |
| string: dickens as Cyrillic and CJK | 1883069 | 5467.3 ± 0.3% | 3626.6 ± 0.7% | 489.2 ± 0.3% | 246.1 ± 0.8% | 456.1 ± 0.6% | 356.9 ± 0.2% | 1.508 | 11.175 | 22.218 | 11.988 | 15.320 |
| hex: silesia/dickens | 524290 | 42601.6 ± 1.1% | 2605.8 ± 0.2% | 1501.5 ± 0.3% | 464.2 ± 0.3% | 1572.2 ± 0.2% | 1063.0 ± 0.7% | 16.349 | 28.373 | 91.771 | 27.097 | 40.078 |
| hex: silesia/mozilla | 524290 | 43723.4 ± 0.2% | 2599.1 ± 0.3% | 1503.5 ± 0.8% | 392.5 ± 1.2% | 1570.8 ± 0.4% | 1063.8 ± 0.2% | 16.823 | 29.081 | 111.395 | 27.835 | 41.101 |
| hex: silesia/mr | 524290 | 43638.2 ± 0.6% | 2582.2 ± 0.7% | 1498.6 ± 0.4% | 598.2 ± 0.9% | 1565.4 ± 0.8% | 1066.7 ± 1.0% | 16.899 | 29.119 | 72.946 | 27.877 | 40.908 |
| hex: silesia/nci | 524290 | 43276.0 ± 5.3% | 2585.4 ± 0.9% | 1499.3 ± 0.4% | 755.4 ± 0.3% | 1563.0 ± 0.7% | 1063.2 ± 0.5% | 16.738 | 28.864 | 57.288 | 27.687 | 40.704 |
| hex: silesia/ooffice | 524290 | 42868.0 ± 8.1% | 2589.3 ± 0.6% | 1497.1 ± 0.5% | 319.9 ± 1.9% | 1560.1 ± 1.0% | 1055.7 ± 1.0% | 16.556 | 28.634 | 133.984 | 27.478 | 40.605 |
| hex: silesia/osdb | 524290 | 41815.6 ± 0.5% | 2595.2 ± 0.3% | 1496.2 ± 0.9% | 429.5 ± 0.4% | 1561.1 ± 1.3% | 1057.6 ± 5.8% | 16.113 | 27.948 | 97.353 | 26.786 | 39.537 |
| hex: silesia/reymont | 524290 | 43545.0 ± 0.5% | 2598.2 ± 9.2% | 1501.4 ± 0.7% | 483.9 ± 0.9% | 1566.6 ± 1.0% | 1061.9 ± 0.6% | 16.759 | 29.003 | 89.991 | 27.795 | 41.007 |
| hex: silesia/samba | 524290 | 43638.6 ± 0.4% | 2584.5 ± 5.5% | 1498.7 ± 0.6% | 336.7 ± 1.7% | 1568.4 ± 0.5% | 1060.1 ± 0.5% | 16.885 | 29.118 | 129.620 | 27.824 | 41.164 |
| hex: silesia/sao | 524290 | 43613.1 ± 1.1% | 2600.3 ± 0.8% | 1505.0 ± 1.1% | 269.9 ± 1.3% | 1549.8 ± 0.8% | 1060.1 ± 0.6% | 16.772 | 28.979 | 161.565 | 28.142 | 41.142 |
| hex: silesia/webster | 524290 | 43984.0 ± 0.4% | 2606.1 ± 0.5% | 1505.9 ± 0.5% | 436.6 ± 1.0% | 1568.4 ± 0.4% | 1064.7 ± 0.6% | 16.877 | 29.209 | 100.751 | 28.043 | 41.310 |
| hex: silesia/x-ray | 524290 | 43787.7 ± 0.1% | 2618.3 ± 0.1% | 1509.3 ± 0.1% | 421.4 ± 0.4% | 1518.9 ± 0.8% | 1067.7 ± 0.1% | 16.724 | 29.011 | 103.909 | 28.829 | 41.011 |
| hex: silesia/xml | 524290 | 43809.0 ± 0.1% | 2606.1 ± 0.1% | 1506.1 ± 0.6% | 686.9 ± 0.5% | 1555.7 ± 0.4% | 1063.5 ± 0.1% | 16.810 | 29.087 | 63.779 | 28.161 | 41.191 |
| hex: canterbury/alice29.txt | 304180 | 41537.1 ± 1.0% | 2609.0 ± 6.2% | 1518.8 ± 2.9% | 467.7 ± 1.3% | 1533.1 ± 9.8% | 1080.7 ± 1.1% | 15.920 | 27.349 | 88.807 | 27.094 | 38.434 |
| hex: canterbury/asyoulik.txt | 250360 | 43399.0 ± 0.5% | 2616.9 ± 0.6% | 1535.3 ± 0.6% | 457.0 ± 0.6% | 1564.3 ± 1.3% | 1021.9 ± 6.7% | 16.584 | 28.267 | 94.967 | 27.743 | 42.469 |
| hex: canterbury/cp.html | 49208 | 42589.3 ± 4.5% | 2605.9 ± 0.7% | 1526.2 ± 0.4% | 482.9 ± 0.6% | 1588.6 ± 0.5% | 1093.0 ± 0.3% | 16.343 | 27.906 | 88.193 | 26.809 | 38.967 |
| hex: canterbury/fields.c | 22302 | 41984.3 ± 1.0% | 2642.3 ± 0.7% | 1532.4 ± 0.7% | 601.5 ± 0.7% | 1602.6 ± 1.0% | 1096.3 ± 0.8% | 15.889 | 27.398 | 69.797 | 26.197 | 38.296 |
| hex: canterbury/grammar.lsp | 7444 | 39194.1 ± 1.4% | 2697.2 ± 0.5% | 1539.3 ± 0.4% | 813.7 ± 0.4% | 1611.0 ± 6.3% | 1105.4 ± 0.7% | 14.532 | 25.462 | 48.167 | 24.329 | 35.459 |
| hex: canterbury/kennedy.xls | 524290 | 43711.1 ± 6.9% | 2575.3 ± 0.2% | 1498.4 ± 0.1% | 785.1 ± 0.2% | 1556.4 ± 0.5% | 1066.4 ± 1.5% | 16.973 | 29.172 | 55.675 | 28.085 | 40.991 |
| hex: canterbury/lcet10.txt | 524290 | 43707.1 ± 0.2% | 2603.5 ± 0.3% | 1498.9 ± 0.6% | 470.2 ± 0.4% | 1564.1 ± 5.6% | 1066.4 ± 0.1% | 16.788 | 29.160 | 92.958 | 27.945 | 40.985 |
| hex: canterbury/plrabn12.txt | 524290 | 43592.5 ± 0.2% | 2603.7 ± 0.4% | 1502.2 ± 4.8% | 453.5 ± 3.5% | 1569.4 ± 0.6% | 1065.0 ± 0.2% | 16.742 | 29.019 | 96.122 | 27.777 | 40.931 |
| hex: canterbury/ptt5 | 524290 | 43640.7 ± 0.3% | 2570.1 ± 9.1% | 1500.4 ± 0.3% | 592.2 ± 0.6% | 1544.2 ± 1.4% | 1063.8 ± 0.4% | 16.980 | 29.086 | 73.689 | 28.261 | 41.023 |
| hex: canterbury/sum | 76482 | 42974.1 ± 0.3% | 2594.0 ± 0.4% | 1514.3 ± 8.4% | 560.8 ± 0.5% | 1576.9 ± 0.2% | 1090.3 ± 0.2% | 16.567 | 28.378 | 76.635 | 27.253 | 39.413 |
| hex: canterbury/xargs.1 | 8456 | 40207.1 ± 0.4% | 2694.9 ± 0.3% | 1543.2 ± 0.2% | 839.9 ± 0.4% | 1606.5 ± 0.4% | 1110.7 ± 0.3% | 14.920 | 26.054 | 47.869 | 25.027 | 36.201 |
| hex: canterbury-large/E.coli | 524290 | 41777.0 ± 0.1% | 2602.1 ± 0.1% | 1501.8 ± 0.2% | 817.4 ± 2.4% | 1560.5 ± 2.1% | 1067.0 ± 0.2% | 16.055 | 27.817 | 51.111 | 26.772 | 39.154 |
| hex: canterbury-large/bible.txt | 524290 | 43698.7 ± 0.3% | 2600.3 ± 0.5% | 1508.0 ± 0.3% | 481.5 ± 0.3% | 1569.2 ± 0.4% | 1064.8 ± 0.9% | 16.806 | 28.979 | 90.758 | 27.847 | 41.040 |
| hex: canterbury-large/world192.txt | 524290 | 43397.8 ± 0.3% | 2604.9 ± 0.6% | 1503.8 ± 0.3% | 446.1 ± 0.4% | 1384.9 ± 0.8% | 1065.9 ± 0.2% | 16.660 | 28.859 | 97.276 | 31.335 | 40.714 |
| hex: http/html-1kx1024 | 2099200 | 20784.8 ± 0.5% | 2376.1 ± 8.0% | 1459.6 ± 0.4% | 500.5 ± 0.5% | 1500.0 ± 1.0% | 1079.6 ± 0.3% | 8.748 | 14.240 | 41.527 | 13.857 | 19.252 |
| hex: http/html-16kx64 | 2097280 | 21189.8 ± 0.5% | 2248.1 ± 0.6% | 1453.2 ± 0.1% | 504.6 ± 4.6% | 1455.0 ± 0.2% | 1086.7 ± 0.6% | 9.426 | 14.581 | 41.990 | 14.563 | 19.500 |
| hex: http/html-1m | 524290 | 43779.6 ± 0.3% | 2614.3 ± 0.2% | 1506.9 ± 0.3% | 492.7 ± 4.2% | 1569.5 ± 5.6% | 1067.3 ± 0.2% | 16.746 | 29.053 | 88.855 | 27.894 | 41.018 |
| hex: http/json-1kx1024 | 2099200 | 19851.2 ± 1.1% | 2352.0 ± 1.3% | 1459.3 ± 0.7% | 696.1 ± 0.4% | 1507.8 ± 6.4% | 1077.2 ± 0.5% | 8.440 | 13.603 | 28.516 | 13.166 | 18.429 |
| hex: http/json-16kx64 | 2097280 | 20918.1 ± 0.8% | 2234.4 ± 6.0% | 1447.2 ± 0.5% | 705.5 ± 0.3% | 1449.2 ± 0.4% | 1082.8 ± 6.4% | 9.362 | 14.454 | 29.648 | 14.434 | 19.318 |
| hex: http/json-1m | 524290 | 43625.4 ± 0.3% | 2594.5 ± 1.2% | 1501.7 ± 0.4% | 737.0 ± 0.7% | 1561.3 ± 6.3% | 1065.5 ± 0.1% | 16.815 | 29.051 | 59.192 | 27.943 | 40.945 |
| hex: http/js-1kx1024 | 2099200 | 20181.7 ± 0.2% | 2372.4 ± 1.3% | 1453.7 ± 1.5% | 489.2 ± 1.6% | 1499.3 ± 1.4% | 1074.1 ± 7.1% | 8.507 | 13.883 | 41.255 | 13.461 | 18.789 |
| hex: http/js-16kx64 | 2097280 | 20934.3 ± 0.8% | 2242.0 ± 0.4% | 1449.4 ± 0.3% | 492.8 ± 0.2% | 1454.1 ± 0.3% | 1084.6 ± 0.3% | 9.337 | 14.444 | 42.480 | 14.397 | 19.301 |
| hex: http/js-1m | 524290 | 43598.1 ± 2.0% | 2610.6 ± 0.6% | 1504.2 ± 0.8% | 508.7 ± 0.3% | 1570.3 ± 0.6% | 1065.2 ± 0.4% | 16.700 | 28.984 | 85.698 | 27.764 | 40.929 |
| hex: http/css-1kx1024 | 2099200 | 19901.4 ± 0.4% | 2398.5 ± 2.7% | 1461.9 ± 4.7% | 556.5 ± 0.7% | 1507.8 ± 1.3% | 1075.3 ± 0.6% | 8.297 | 13.614 | 35.760 | 13.199 | 18.507 |
| hex: http/css-16kx64 | 2097280 | 20889.4 ± 0.5% | 2246.5 ± 0.3% | 1453.9 ± 0.3% | 564.6 ± 0.5% | 1455.7 ± 0.1% | 1086.5 ± 0.5% | 9.299 | 14.368 | 37.000 | 14.350 | 19.226 |
| hex: http/css-1m | 524290 | 43723.4 ± 0.4% | 2608.9 ± 0.6% | 1429.2 ± 5.2% | 539.4 ± 4.5% | 1569.5 ± 0.5% | 1065.9 ± 0.4% | 16.760 | 30.593 | 81.060 | 27.859 | 41.020 |
| hex: shuffled/dickens-1m | 524290 | 42509.2 ± 1.5% | 2605.0 ± 0.8% | 1504.5 ± 0.8% | 464.4 ± 1.0% | 1570.1 ± 0.9% | 1061.0 ± 0.8% | 16.318 | 28.255 | 91.526 | 27.075 | 40.065 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1792.1 ± 0.4% | 1476.4 ± 0.6% | 1025.6 ± 0.6% | 461.5 ± 1.1% | 441.4 ± 1.5% | 497.2 ± 4.0% | 1.214 | 1.747 | 3.883 | 4.060 | 3.605 |
| qlog records, JSON text sequence | 1467503 | 1710.2 ± 0.9% | 1215.3 ± 5.6% | 941.8 ± 2.1% | 422.5 ± 5.7% | 532.3 ± 0.8% | 350.9 ± 1.2% | 1.407 | 1.816 | 4.047 | 3.213 | 4.874 |
| messages: 11 string members | 1025025 | 1320.9 ± 0.4% | 1103.9 ± 0.4% | 765.4 ± 2.0% | 409.6 ± 2.7% | 415.6 ± 0.6% | 433.0 ± 1.0% | 1.197 | 1.726 | 3.225 | 3.178 | 3.050 |
| messages: 50 nested objects | 1121600 | 2006.2 ± 0.2% | 1875.1 ± 0.6% | 1341.9 ± 0.4% | 590.5 ± 0.7% | 608.2 ± 6.0% | 506.9 ± 0.9% | 1.070 | 1.495 | 3.397 | 3.299 | 3.958 |
| messages: a tree of 341 objects | 612600 | 645.6 ± 1.0% | 675.8 ± 1.4% | 578.8 ± 4.3% | 333.0 ± 4.2% | 352.5 ± 1.8% | 219.3 ± 0.9% | 0.955 | 1.115 | 1.939 | 1.831 | 2.944 |
| string: silesia/dickens | 172528 | 13426.7 ± 0.4% | 3958.4 ± 0.7% | 3060.8 ± 1.9% | 333.4 ± 1.0% | 1526.4 ± 0.9% | 1184.0 ± 0.9% | 3.392 | 4.387 | 40.270 | 8.796 | 11.340 |
| string: silesia/nci | 1075110 | 11514.2 ± 9.1% | 4709.3 ± 0.9% | 3090.7 ± 1.5% | 902.5 ± 0.6% | 1581.9 ± 0.9% | 1191.8 ± 1.0% | 2.445 | 3.725 | 12.757 | 7.279 | 9.661 |
| string: silesia/reymont | 1075159 | 5428.3 ± 1.6% | 1863.3 ± 0.7% | 1884.1 ± 0.5% | 378.3 ± 1.8% | 1292.8 ± 1.6% | 1043.4 ± 1.0% | 2.913 | 2.881 | 14.350 | 4.199 | 5.203 |
| string: silesia/samba | 97582 | 7306.2 ± 0.9% | 2697.1 ± 0.9% | 4055.3 ± 1.1% | 349.0 ± 1.1% | 1263.3 ± 1.4% | 1182.4 ± 1.7% | 2.709 | 1.802 | 20.935 | 5.783 | 6.179 |
| string: silesia/webster | 1098490 | 6921.2 ± 1.0% | 1968.6 ± 0.3% | 1751.6 ± 0.9% | 351.3 ± 1.2% | 1253.3 ± 1.2% | 607.2 ± 0.6% | 3.516 | 3.951 | 19.699 | 5.522 | 11.398 |
| string: silesia/xml | 1090118 | 11092.8 ± 7.6% | 3196.6 ± 1.6% | 2495.2 ± 1.2% | 603.8 ± 1.3% | 1717.8 ± 1.2% | 978.1 ± 1.1% | 3.470 | 4.446 | 18.371 | 6.458 | 11.341 |
| string: canterbury/alice29.txt | 159425 | 13334.8 ± 0.9% | 2903.1 ± 1.3% | 3028.6 ± 1.5% | 316.7 ± 1.0% | 1357.4 ± 1.4% | 1092.6 ± 0.8% | 4.593 | 4.403 | 42.107 | 9.823 | 12.205 |
| string: canterbury/asyoulik.txt | 132198 | 11440.9 ± 0.6% | 2102.0 ± 3.6% | 3120.4 ± 3.9% | 315.9 ± 1.0% | 1232.4 ± 2.8% | 954.8 ± 1.0% | 5.443 | 3.666 | 36.220 | 9.283 | 11.982 |
| string: canterbury/lcet10.txt | 441884 | 12565.5 ± 1.0% | 3047.9 ± 1.0% | 2564.3 ± 0.5% | 366.3 ± 1.0% | 1469.8 ± 2.0% | 1193.3 ± 0.6% | 4.123 | 4.900 | 34.305 | 8.549 | 10.530 |
| string: canterbury/plrabn12.txt | 503330 | 8991.6 ± 5.9% | 2312.1 ± 1.0% | 2096.0 ± 0.8% | 346.5 ± 1.7% | 1371.9 ± 3.5% | 1109.8 ± 1.3% | 3.889 | 4.290 | 25.951 | 6.554 | 8.102 |
| string: canterbury-large/E.coli | 1048578 | 34323.4 ± 0.3% | 16014.1 ± 2.0% | 3460.9 ± 2.8% | 1687.3 ± 0.8% | 3115.3 ± 2.9% | 1409.8 ± 0.8% | 2.143 | 9.917 | 20.342 | 11.018 | 24.347 |
| string: canterbury-large/bible.txt | 1055886 | 9738.8 ± 0.5% | 4876.2 ± 0.8% | 2994.5 ± 3.9% | 405.5 ± 1.8% | 2013.1 ± 4.9% | 1485.5 ± 0.5% | 1.997 | 3.252 | 24.018 | 4.838 | 6.556 |
| string: canterbury-large/world192.txt | 1103121 | 6408.6 ± 3.7% | 1721.5 ± 1.4% | 1867.6 ± 1.4% | 345.6 ± 0.4% | 1266.6 ± 1.8% | 962.7 ± 4.6% | 3.723 | 3.431 | 18.541 | 5.060 | 6.657 |
| string: http/html-1m | 1058582 | 10139.2 ± 0.6% | 4301.6 ± 1.4% | 2853.7 ± 0.6% | 418.8 ± 2.6% | 1988.1 ± 0.6% | 849.7 ± 0.9% | 2.357 | 3.553 | 24.209 | 5.100 | 11.932 |
| string: http/json-1m | 1190272 | 8452.9 ± 0.7% | 1583.1 ± 0.7% | 1569.7 ± 0.7% | 554.0 ± 0.8% | 1015.9 ± 0.5% | 842.7 ± 0.9% | 5.340 | 5.385 | 15.257 | 8.320 | 10.030 |
| string: http/js-1m | 1144362 | 6624.9 ± 1.1% | 1114.2 ± 3.7% | 1373.4 ± 0.7% | 329.1 ± 0.5% | 1028.4 ± 0.9% | 753.9 ± 0.4% | 5.946 | 4.824 | 20.129 | 6.442 | 8.787 |
| string: http/css-1m | 1097820 | 9234.1 ± 0.5% | 1478.0 ± 1.3% | 2264.5 ± 1.0% | 506.9 ± 1.1% | 1126.3 ± 1.9% | 877.9 ± 0.5% | 6.248 | 4.078 | 18.217 | 8.198 | 10.518 |
| string: dickens as Cyrillic and CJK | 1883069 | 5662.9 ± 0.9% | 3626.6 ± 0.7% | 489.2 ± 0.3% | 246.1 ± 0.8% | 456.1 ± 0.6% | 356.9 ± 0.2% | 1.561 | 11.575 | 23.013 | 12.417 | 15.868 |
| hex: silesia/dickens | 524290 | 42631.1 ± 0.8% | 2605.8 ± 0.2% | 1501.5 ± 0.3% | 464.2 ± 0.3% | 1572.2 ± 0.2% | 1063.0 ± 0.7% | 16.360 | 28.393 | 91.835 | 27.116 | 40.106 |
| hex: silesia/mozilla | 524290 | 43699.5 ± 2.1% | 2599.1 ± 0.3% | 1503.5 ± 0.8% | 392.5 ± 1.2% | 1570.8 ± 0.4% | 1063.8 ± 0.2% | 16.813 | 29.065 | 111.334 | 27.820 | 41.078 |
| hex: silesia/mr | 524290 | 43723.4 ± 0.4% | 2582.2 ± 0.7% | 1498.6 ± 0.4% | 598.2 ± 0.9% | 1565.4 ± 0.8% | 1066.7 ± 1.0% | 16.932 | 29.176 | 73.089 | 27.932 | 40.988 |
| hex: silesia/nci | 524290 | 43462.8 ± 0.4% | 2585.4 ± 0.9% | 1499.3 ± 0.4% | 755.4 ± 0.3% | 1563.0 ± 0.7% | 1063.2 ± 0.5% | 16.811 | 28.989 | 57.535 | 27.807 | 40.880 |
| hex: silesia/ooffice | 524290 | 43479.6 ± 2.3% | 2589.3 ± 0.6% | 1497.1 ± 0.5% | 319.9 ± 1.9% | 1560.1 ± 1.0% | 1055.7 ± 1.0% | 16.792 | 29.043 | 135.896 | 27.870 | 41.185 |
| hex: silesia/osdb | 524290 | 41809.5 ± 1.6% | 2595.2 ± 0.3% | 1496.2 ± 0.9% | 429.5 ± 0.4% | 1561.1 ± 1.3% | 1057.6 ± 5.8% | 16.110 | 27.944 | 97.339 | 26.782 | 39.531 |
| hex: silesia/reymont | 524290 | 43557.7 ± 0.5% | 2598.2 ± 9.2% | 1501.4 ± 0.7% | 483.9 ± 0.9% | 1566.6 ± 1.0% | 1061.9 ± 0.6% | 16.764 | 29.011 | 90.017 | 27.803 | 41.019 |
| hex: silesia/samba | 524290 | 43694.5 ± 0.8% | 2584.5 ± 5.5% | 1498.7 ± 0.6% | 336.7 ± 1.7% | 1568.4 ± 0.5% | 1060.1 ± 0.5% | 16.906 | 29.155 | 129.786 | 27.860 | 41.217 |
| hex: silesia/sao | 524290 | 43639.3 ± 1.1% | 2600.3 ± 0.8% | 1505.0 ± 1.1% | 269.9 ± 1.3% | 1549.8 ± 0.8% | 1060.1 ± 0.6% | 16.782 | 28.996 | 161.662 | 28.159 | 41.167 |
| hex: silesia/webster | 524290 | 43972.2 ± 0.3% | 2606.1 ± 0.5% | 1505.9 ± 0.5% | 436.6 ± 1.0% | 1568.4 ± 0.4% | 1064.7 ± 0.6% | 16.873 | 29.201 | 100.724 | 28.036 | 41.299 |
| hex: silesia/x-ray | 524290 | 43815.2 ± 0.3% | 2618.3 ± 0.1% | 1509.3 ± 0.1% | 421.4 ± 0.4% | 1518.9 ± 0.8% | 1067.7 ± 0.1% | 16.734 | 29.030 | 103.975 | 28.847 | 41.037 |
| hex: silesia/xml | 524290 | 43834.8 ± 0.2% | 2606.1 ± 0.1% | 1506.1 ± 0.6% | 686.9 ± 0.5% | 1555.7 ± 0.4% | 1063.5 ± 0.1% | 16.820 | 29.104 | 63.817 | 28.177 | 41.216 |
| hex: canterbury/alice29.txt | 304180 | 41566.7 ± 0.7% | 2609.0 ± 6.2% | 1518.8 ± 2.9% | 467.7 ± 1.3% | 1533.1 ± 9.8% | 1080.7 ± 1.1% | 15.932 | 27.368 | 88.870 | 27.113 | 38.461 |
| hex: canterbury/asyoulik.txt | 250360 | 43486.5 ± 0.6% | 2616.9 ± 0.6% | 1535.3 ± 0.6% | 457.0 ± 0.6% | 1564.3 ± 1.3% | 1021.9 ± 6.7% | 16.618 | 28.324 | 95.159 | 27.799 | 42.554 |
| hex: canterbury/cp.html | 49208 | 42757.8 ± 0.5% | 2605.9 ± 0.7% | 1526.2 ± 0.4% | 482.9 ± 0.6% | 1588.6 ± 0.5% | 1093.0 ± 0.3% | 16.408 | 28.016 | 88.542 | 26.915 | 39.121 |
| hex: canterbury/fields.c | 22302 | 42037.5 ± 0.3% | 2642.3 ± 0.7% | 1532.4 ± 0.7% | 601.5 ± 0.7% | 1602.6 ± 1.0% | 1096.3 ± 0.8% | 15.909 | 27.433 | 69.885 | 26.230 | 38.345 |
| hex: canterbury/grammar.lsp | 7444 | 39465.2 ± 0.9% | 2697.2 ± 0.5% | 1539.3 ± 0.4% | 813.7 ± 0.4% | 1611.0 ± 6.3% | 1105.4 ± 0.7% | 14.632 | 25.638 | 48.500 | 24.497 | 35.704 |
| hex: canterbury/kennedy.xls | 524290 | 43708.6 ± 0.3% | 2575.3 ± 0.2% | 1498.4 ± 0.1% | 785.1 ± 0.2% | 1556.4 ± 0.5% | 1066.4 ± 1.5% | 16.972 | 29.171 | 55.672 | 28.084 | 40.989 |
| hex: canterbury/lcet10.txt | 524290 | 43757.8 ± 0.5% | 2603.5 ± 0.3% | 1498.9 ± 0.6% | 470.2 ± 0.4% | 1564.1 ± 5.6% | 1066.4 ± 0.1% | 16.807 | 29.194 | 93.066 | 27.977 | 41.032 |
| hex: canterbury/plrabn12.txt | 524290 | 43630.4 ± 0.3% | 2603.7 ± 0.4% | 1502.2 ± 4.8% | 453.5 ± 3.5% | 1569.4 ± 0.6% | 1065.0 ± 0.2% | 16.757 | 29.044 | 96.205 | 27.801 | 40.966 |
| hex: canterbury/ptt5 | 524290 | 43684.8 ± 0.5% | 2570.1 ± 9.1% | 1500.4 ± 0.3% | 592.2 ± 0.6% | 1544.2 ± 1.4% | 1063.8 ± 0.4% | 16.997 | 29.115 | 73.764 | 28.290 | 41.064 |
| hex: canterbury/sum | 76482 | 43076.5 ± 0.3% | 2594.0 ± 0.4% | 1514.3 ± 8.4% | 560.8 ± 0.5% | 1576.9 ± 0.2% | 1090.3 ± 0.2% | 16.607 | 28.446 | 76.817 | 27.318 | 39.507 |
| hex: canterbury/xargs.1 | 8456 | 40370.9 ± 0.1% | 2694.9 ± 0.3% | 1543.2 ± 0.2% | 839.9 ± 0.4% | 1606.5 ± 0.4% | 1110.7 ± 0.3% | 14.980 | 26.160 | 48.064 | 25.129 | 36.348 |
| hex: canterbury-large/E.coli | 524290 | 41859.1 ± 0.8% | 2602.1 ± 0.1% | 1501.8 ± 0.2% | 817.4 ± 2.4% | 1560.5 ± 2.1% | 1067.0 ± 0.2% | 16.087 | 27.872 | 51.211 | 26.824 | 39.231 |
| hex: canterbury-large/bible.txt | 524290 | 43738.5 ± 0.4% | 2600.3 ± 0.5% | 1508.0 ± 0.3% | 481.5 ± 0.3% | 1569.2 ± 0.4% | 1064.8 ± 0.9% | 16.821 | 29.005 | 90.841 | 27.873 | 41.077 |
| hex: canterbury-large/world192.txt | 524290 | 43492.4 ± 0.5% | 2604.9 ± 0.6% | 1503.8 ± 0.3% | 446.1 ± 0.4% | 1384.9 ± 0.8% | 1065.9 ± 0.2% | 16.696 | 28.922 | 97.488 | 31.404 | 40.803 |
| hex: http/html-1kx1024 | 2099200 | 20906.1 ± 0.3% | 2376.1 ± 8.0% | 1459.6 ± 0.4% | 500.5 ± 0.5% | 1500.0 ± 1.0% | 1079.6 ± 0.3% | 8.799 | 14.323 | 41.770 | 13.938 | 19.364 |
| hex: http/html-16kx64 | 2097280 | 21264.3 ± 0.7% | 2248.1 ± 0.6% | 1453.2 ± 0.1% | 504.6 ± 4.6% | 1455.0 ± 0.2% | 1086.7 ± 0.6% | 9.459 | 14.632 | 42.138 | 14.615 | 19.568 |
| hex: http/html-1m | 524290 | 43805.9 ± 0.1% | 2614.3 ± 0.2% | 1506.9 ± 0.3% | 492.7 ± 4.2% | 1569.5 ± 5.6% | 1067.3 ± 0.2% | 16.756 | 29.071 | 88.908 | 27.910 | 41.043 |
| hex: http/json-1kx1024 | 2099200 | 19933.8 ± 0.4% | 2352.0 ± 1.3% | 1459.3 ± 0.7% | 696.1 ± 0.4% | 1507.8 ± 6.4% | 1077.2 ± 0.5% | 8.475 | 13.660 | 28.635 | 13.221 | 18.506 |
| hex: http/json-16kx64 | 2097280 | 21048.3 ± 0.2% | 2234.4 ± 6.0% | 1447.2 ± 0.5% | 705.5 ± 0.3% | 1449.2 ± 0.4% | 1082.8 ± 6.4% | 9.420 | 14.544 | 29.832 | 14.524 | 19.438 |
| hex: http/json-1m | 524290 | 43624.7 ± 0.3% | 2594.5 ± 1.2% | 1501.7 ± 0.4% | 737.0 ± 0.7% | 1561.3 ± 6.3% | 1065.5 ± 0.1% | 16.815 | 29.051 | 59.191 | 27.942 | 40.944 |
| hex: http/js-1kx1024 | 2099200 | 20304.6 ± 0.2% | 2372.4 ± 1.3% | 1453.7 ± 1.5% | 489.2 ± 1.6% | 1499.3 ± 1.4% | 1074.1 ± 7.1% | 8.559 | 13.967 | 41.506 | 13.543 | 18.903 |
| hex: http/js-16kx64 | 2097280 | 21006.3 ± 0.4% | 2242.0 ± 0.4% | 1449.4 ± 0.3% | 492.8 ± 0.2% | 1454.1 ± 0.3% | 1084.6 ± 0.3% | 9.369 | 14.493 | 42.626 | 14.447 | 19.368 |
| hex: http/js-1m | 524290 | 43691.5 ± 8.7% | 2610.6 ± 0.6% | 1504.2 ± 0.8% | 508.7 ± 0.3% | 1570.3 ± 0.6% | 1065.2 ± 0.4% | 16.736 | 29.046 | 85.881 | 27.824 | 41.016 |
| hex: http/css-1kx1024 | 2099200 | 19985.2 ± 0.4% | 2398.5 ± 2.7% | 1461.9 ± 4.7% | 556.5 ± 0.7% | 1507.8 ± 1.3% | 1075.3 ± 0.6% | 8.332 | 13.671 | 35.911 | 13.254 | 18.585 |
| hex: http/css-16kx64 | 2097280 | 20990.4 ± 0.2% | 2246.5 ± 0.3% | 1453.9 ± 0.3% | 564.6 ± 0.5% | 1455.7 ± 0.1% | 1086.5 ± 0.5% | 9.343 | 14.438 | 37.179 | 14.419 | 19.319 |
| hex: http/css-1m | 524290 | 43779.5 ± 0.2% | 2608.9 ± 0.6% | 1429.2 ± 5.2% | 539.4 ± 4.5% | 1569.5 ± 0.5% | 1065.9 ± 0.4% | 16.781 | 30.632 | 81.164 | 27.894 | 41.072 |
| hex: shuffled/dickens-1m | 524290 | 42575.2 ± 1.2% | 2605.0 ± 0.8% | 1504.5 ± 0.8% | 464.4 ± 1.0% | 1570.1 ± 0.9% | 1061.0 ± 0.8% | 16.344 | 28.299 | 91.669 | 27.117 | 40.127 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1149.4 ± 0.4% | 1507.2 ± 1.6% | 1116.5 ± 2.1% | 390.1 ± 2.7% | 672.2 ± 0.4% | 363.9 ± 1.8% | 0.763 | 1.029 | 2.947 | 1.710 | 3.158 |
| qlog records, JSON text sequence | 1467503 | 993.8 ± 0.7% | 1246.8 ± 0.8% | 1122.7 ± 0.7% | 330.4 ± 0.7% | 753.4 ± 0.9% | 309.2 ± 0.9% | 0.797 | 0.885 | 3.008 | 1.319 | 3.214 |
| messages: 11 string members | 1025025 | 945.5 ± 0.3% | 2039.6 ± 1.3% | 728.2 ± 2.3% | 336.5 ± 1.9% | 508.3 ± 1.2% | 288.8 ± 3.1% | 0.464 | 1.298 | 2.809 | 1.860 | 3.274 |
| messages: 50 nested objects | 1121600 | 1237.8 ± 3.6% | 1733.6 ± 1.8% | 1457.3 ± 0.3% | 432.5 ± 0.8% | 905.3 ± 19.8% | 419.6 ± 3.8% | 0.714 | 0.849 | 2.862 | 1.367 | 2.950 |
| messages: a tree of 341 objects | 612600 | 547.4 ± 2.2% | 854.8 ± 1.2% | 694.3 ± 1.6% | 182.5 ± 0.9% | 613.1 ± 0.5% | 208.9 ± 0.6% | 0.640 | 0.788 | 2.999 | 0.893 | 2.620 |
| string: silesia/dickens | 172528 | 6721.0 ± 0.5% | 3464.0 ± 6.0% | 2815.4 ± 1.1% | 317.2 ± 2.7% | 3093.2 ± 2.0% | 571.8 ± 1.5% | 1.940 | 2.387 | 21.192 | 2.173 | 11.755 |
| string: silesia/nci | 1075110 | 5401.5 ± 0.4% | 3922.8 ± 0.4% | 2996.8 ± 0.3% | 642.8 ± 0.7% | 3610.9 ± 0.9% | 541.0 ± 4.1% | 1.377 | 1.802 | 8.403 | 1.496 | 9.984 |
| string: silesia/reymont | 1075159 | 3443.6 ± 1.4% | 3409.0 ± 0.4% | 1934.7 ± 2.4% | 341.5 ± 0.5% | 2093.9 ± 1.3% | 491.6 ± 3.9% | 1.010 | 1.780 | 10.082 | 1.645 | 7.006 |
| string: silesia/samba | 97582 | 3989.2 ± 0.3% | 3793.5 ± 0.4% | 3048.1 ± 0.2% | 326.8 ± 1.0% | 1945.9 ± 1.4% | 419.4 ± 0.9% | 1.052 | 1.309 | 12.208 | 2.050 | 9.512 |
| string: silesia/webster | 1098490 | 4370.4 ± 1.0% | 2433.2 ± 0.2% | 1726.1 ± 0.3% | 308.7 ± 0.3% | 2051.6 ± 0.5% | 454.1 ± 1.5% | 1.796 | 2.532 | 14.159 | 2.130 | 9.625 |
| string: silesia/xml | 1090118 | 6073.8 ± 0.5% | 5035.9 ± 0.4% | 2442.1 ± 0.4% | 509.7 ± 0.5% | 3325.2 ± 0.3% | 546.1 ± 2.6% | 1.206 | 2.487 | 11.917 | 1.827 | 11.122 |
| string: canterbury/alice29.txt | 159425 | 5821.1 ± 0.8% | 2798.5 ± 0.9% | 2791.0 ± 1.1% | 299.7 ± 0.4% | 2757.6 ± 2.8% | 520.2 ± 1.2% | 2.080 | 2.086 | 19.420 | 2.111 | 11.191 |
| string: canterbury/asyoulik.txt | 132198 | 4310.8 ± 0.4% | 2626.0 ± 11.0% | 2781.1 ± 2.3% | 305.6 ± 0.3% | 2425.1 ± 1.2% | 452.5 ± 1.9% | 1.642 | 1.550 | 14.104 | 1.778 | 9.527 |
| string: canterbury/lcet10.txt | 441884 | 6680.3 ± 0.8% | 3289.1 ± 0.3% | 2312.4 ± 1.2% | 345.6 ± 0.3% | 2797.5 ± 0.8% | 569.3 ± 0.3% | 2.031 | 2.889 | 19.328 | 2.388 | 11.735 |
| string: canterbury/plrabn12.txt | 503330 | 5497.1 ± 0.1% | 3172.9 ± 0.6% | 1842.0 ± 0.6% | 323.4 ± 0.4% | 2838.9 ± 0.3% | 528.0 ± 0.4% | 1.732 | 2.984 | 16.997 | 1.936 | 10.410 |
| string: canterbury-large/E.coli | 1048578 | 34000.4 ± 0.2% | 12920.7 ± 0.1% | 3428.9 ± 0.2% | 1283.6 ± 0.4% | 8928.9 ± 0.4% | 920.7 ± 2.4% | 2.631 | 9.916 | 26.488 | 3.808 | 36.928 |
| string: canterbury-large/bible.txt | 1055886 | 8599.1 ± 1.0% | 5228.2 ± 0.4% | 2806.3 ± 0.3% | 356.8 ± 0.4% | 3878.7 ± 0.3% | 610.0 ± 2.3% | 1.645 | 3.064 | 24.102 | 2.217 | 14.098 |
| string: canterbury-large/world192.txt | 1103121 | 4109.9 ± 0.7% | 2305.0 ± 0.3% | 1761.9 ± 0.3% | 327.2 ± 0.2% | 2098.5 ± 0.4% | 451.1 ± 3.6% | 1.783 | 2.333 | 12.560 | 1.959 | 9.110 |
| string: http/html-1m | 1058582 | 8696.3 ± 2.2% | 4711.5 ± 1.3% | 2686.0 ± 0.2% | 425.8 ± 0.2% | 3650.7 ± 0.8% | 587.9 ± 2.0% | 1.846 | 3.238 | 20.423 | 2.382 | 14.791 |
| string: http/json-1m | 1190272 | 3296.2 ± 2.5% | 1250.2 ± 0.3% | 2083.0 ± 0.3% | 473.7 ± 0.7% | 1334.1 ± 0.9% | 425.2 ± 0.5% | 2.637 | 1.582 | 6.958 | 2.471 | 7.752 |
| string: http/js-1m | 1144362 | 2831.3 ± 0.2% | 1600.8 ± 0.6% | 1316.4 ± 0.2% | 324.0 ± 0.3% | 1418.0 ± 0.8% | 377.6 ± 4.3% | 1.769 | 2.151 | 8.740 | 1.997 | 7.499 |
| string: http/css-1m | 1097820 | 3282.0 ± 0.4% | 2877.0 ± 0.5% | 2264.2 ± 0.4% | 451.2 ± 0.6% | 2061.0 ± 0.3% | 437.7 ± 1.5% | 1.141 | 1.450 | 7.274 | 1.592 | 7.499 |
| string: dickens as Cyrillic and CJK | 1883069 | 5807.4 ± 0.5% | 3031.9 ± 2.4% | 657.0 ± 0.5% | 377.8 ± 0.3% | 509.5 ± 0.6% | 162.6 ± 4.2% | 1.915 | 8.840 | 15.370 | 11.398 | 35.719 |
| string: dickens as Cyrillic and CJK, as \u escapes | 5075485 | 1213.8 ± 0.3% | 1236.4 ± 1.5% | 1102.6 ± 2.5% | 264.3 ± 0.5% | 478.9 ± 0.6% | 230.8 ± 3.8% | 0.982 | 1.101 | 4.593 | 2.535 | 5.259 |
| hex: silesia/dickens | 524290 | 33964.9 ± 0.3% | 15145.0 ± 0.3% | 3555.2 ± 0.5% | 476.3 ± 1.4% | 8938.0 ± 0.2% | 1135.3 ± 2.5% | 2.243 | 9.554 | 71.310 | 3.800 | 29.916 |
| hex: silesia/mozilla | 524290 | 33977.1 ± 0.3% | 15148.6 ± 0.1% | 3489.6 ± 0.4% | 430.8 ± 0.4% | 8913.2 ± 0.6% | 1134.8 ± 0.8% | 2.243 | 9.737 | 78.866 | 3.812 | 29.942 |
| hex: silesia/mr | 524290 | 33652.4 ± 4.5% | 15088.8 ± 1.2% | 3489.8 ± 3.8% | 642.5 ± 0.6% | 8888.9 ± 0.7% | 1132.9 ± 0.8% | 2.230 | 9.643 | 52.377 | 3.786 | 29.705 |
| hex: silesia/nci | 524290 | 33825.9 ± 0.3% | 15124.3 ± 0.8% | 3559.0 ± 0.2% | 807.0 ± 2.9% | 8923.5 ± 0.4% | 1135.9 ± 0.4% | 2.237 | 9.504 | 41.914 | 3.791 | 29.779 |
| hex: silesia/ooffice | 524290 | 33937.2 ± 0.3% | 15129.0 ± 0.4% | 3501.7 ± 0.1% | 346.0 ± 0.5% | 8917.6 ± 0.2% | 1138.3 ± 0.2% | 2.243 | 9.692 | 98.095 | 3.806 | 29.815 |
| hex: silesia/osdb | 524290 | 33790.1 ± 0.5% | 14985.8 ± 1.0% | 3467.1 ± 0.7% | 453.8 ± 1.7% | 8855.0 ± 0.6% | 1117.6 ± 1.1% | 2.255 | 9.746 | 74.461 | 3.816 | 30.236 |
| hex: silesia/reymont | 524290 | 33915.2 ± 0.7% | 15072.0 ± 0.5% | 3555.0 ± 0.7% | 498.0 ± 0.7% | 8892.8 ± 0.6% | 1131.7 ± 0.8% | 2.250 | 9.540 | 68.104 | 3.814 | 29.969 |
| hex: silesia/samba | 524290 | 33963.3 ± 0.2% | 15112.7 ± 0.5% | 3492.3 ± 0.4% | 368.0 ± 0.5% | 8908.1 ± 0.3% | 1134.6 ± 1.0% | 2.247 | 9.725 | 92.304 | 3.813 | 29.935 |
| hex: silesia/sao | 524290 | 33959.1 ± 0.4% | 15116.7 ± 1.1% | 3491.6 ± 0.2% | 280.2 ± 1.1% | 8916.7 ± 1.1% | 1136.3 ± 0.9% | 2.246 | 9.726 | 121.213 | 3.808 | 29.887 |
| hex: silesia/webster | 524290 | 33815.5 ± 1.0% | 15069.4 ± 1.2% | 3546.7 ± 0.8% | 449.5 ± 0.9% | 8882.5 ± 0.9% | 1123.5 ± 1.0% | 2.244 | 9.534 | 75.228 | 3.807 | 30.097 |
| hex: silesia/x-ray | 524290 | 33884.4 ± 0.4% | 15021.8 ± 0.7% | 3490.9 ± 3.4% | 425.1 ± 0.6% | 8894.9 ± 0.5% | 1130.3 ± 0.5% | 2.256 | 9.707 | 79.707 | 3.809 | 29.977 |
| hex: silesia/xml | 524290 | 33858.4 ± 1.1% | 15090.3 ± 1.5% | 3557.4 ± 1.5% | 722.9 ± 3.0% | 8901.5 ± 0.5% | 1130.3 ± 1.3% | 2.244 | 9.518 | 46.840 | 3.804 | 29.956 |
| hex: canterbury/alice29.txt | 304180 | 33731.3 ± 1.0% | 14123.6 ± 1.4% | 3553.2 ± 0.6% | 480.5 ± 1.2% | 8909.0 ± 0.7% | 1133.1 ± 3.5% | 2.388 | 9.493 | 70.197 | 3.786 | 29.770 |
| hex: canterbury/asyoulik.txt | 250360 | 33594.4 ± 0.5% | 14866.6 ± 0.6% | 3472.3 ± 0.5% | 466.4 ± 0.6% | 8843.8 ± 0.5% | 1131.6 ± 4.2% | 2.260 | 9.675 | 72.029 | 3.799 | 29.688 |
| hex: canterbury/cp.html | 49208 | 33406.6 ± 0.3% | 14432.0 ± 0.6% | 3564.6 ± 0.4% | 508.0 ± 0.8% | 9220.9 ± 0.7% | 1121.3 ± 1.3% | 2.315 | 9.372 | 65.757 | 3.623 | 29.793 |
| hex: canterbury/fields.c | 22302 | 32882.2 ± 3.3% | 17458.6 ± 1.1% | 3652.6 ± 0.7% | 565.6 ± 0.6% | 9222.1 ± 0.6% | 1100.9 ± 1.8% | 1.883 | 9.002 | 58.140 | 3.566 | 29.868 |
| hex: canterbury/grammar.lsp | 7444 | 29811.0 ± 0.3% | 17237.5 ± 0.5% | 3613.6 ± 0.6% | 738.9 ± 0.3% | 8933.4 ± 0.3% | 1053.8 ± 2.9% | 1.729 | 8.250 | 40.347 | 3.337 | 28.289 |
| hex: canterbury/kennedy.xls | 524290 | 33863.1 ± 0.4% | 15012.3 ± 0.4% | 3552.7 ± 0.3% | 759.1 ± 1.6% | 8892.2 ± 0.6% | 1118.8 ± 6.0% | 2.256 | 9.532 | 44.612 | 3.808 | 30.267 |
| hex: canterbury/lcet10.txt | 524290 | 33958.2 ± 0.6% | 15064.9 ± 1.0% | 3546.6 ± 1.1% | 481.0 ± 2.7% | 8913.0 ± 0.4% | 1131.6 ± 0.7% | 2.254 | 9.575 | 70.598 | 3.810 | 30.008 |
| hex: canterbury/plrabn12.txt | 524290 | 34015.6 ± 0.2% | 15085.3 ± 0.9% | 3552.0 ± 0.2% | 464.6 ± 1.9% | 8927.2 ± 0.4% | 1130.7 ± 0.4% | 2.255 | 9.577 | 73.208 | 3.810 | 30.083 |
| hex: canterbury/ptt5 | 524290 | 33942.2 ± 4.7% | 15084.0 ± 0.4% | 3496.9 ± 0.2% | 665.1 ± 0.5% | 8897.5 ± 0.8% | 1134.8 ± 1.1% | 2.250 | 9.706 | 51.036 | 3.815 | 29.910 |
| hex: canterbury/sum | 76482 | 33379.5 ± 0.4% | 15448.5 ± 0.7% | 3564.4 ± 0.4% | 584.5 ± 0.2% | 8916.3 ± 5.2% | 1127.9 ± 3.2% | 2.161 | 9.365 | 57.104 | 3.744 | 29.595 |
| hex: canterbury/xargs.1 | 8456 | 30378.3 ± 0.5% | 17383.3 ± 0.3% | 3559.4 ± 0.4% | 718.2 ± 2.1% | 8988.2 ± 1.3% | 1100.5 ± 3.0% | 1.748 | 8.535 | 42.298 | 3.380 | 27.604 |
| hex: canterbury-large/E.coli | 524290 | 33961.1 ± 0.4% | 15081.9 ± 2.9% | 3495.0 ± 0.4% | 963.0 ± 0.3% | 8899.1 ± 0.4% | 1125.7 ± 7.1% | 2.252 | 9.717 | 35.267 | 3.816 | 30.169 |
| hex: canterbury-large/bible.txt | 524290 | 33797.5 ± 4.6% | 15003.8 ± 0.6% | 3487.4 ± 0.8% | 496.9 ± 1.1% | 8875.5 ± 0.4% | 1071.5 ± 0.7% | 2.253 | 9.691 | 68.012 | 3.808 | 31.544 |
| hex: canterbury-large/world192.txt | 524290 | 33921.2 ± 0.1% | 15085.1 ± 2.9% | 3570.1 ± 0.1% | 467.2 ± 0.7% | 8926.0 ± 0.5% | 1128.3 ± 4.8% | 2.249 | 9.501 | 72.599 | 3.800 | 30.064 |
| hex: http/html-1kx1024 | 2099200 | 15193.7 ± 1.0% | 12498.0 ± 3.0% | 3166.4 ± 1.0% | 505.9 ± 0.5% | 7346.6 ± 7.1% | 978.1 ± 2.4% | 1.216 | 4.798 | 30.032 | 2.068 | 15.533 |
| hex: http/html-16kx64 | 2097280 | 27650.5 ± 0.5% | 14111.2 ± 2.2% | 3387.0 ± 0.8% | 512.4 ± 0.8% | 8664.7 ± 0.8% | 1080.5 ± 1.2% | 1.959 | 8.164 | 53.966 | 3.191 | 25.591 |
| hex: http/html-1m | 524290 | 33841.8 ± 0.4% | 15051.7 ± 0.5% | 3481.6 ± 0.6% | 505.1 ± 0.6% | 8889.6 ± 0.7% | 1125.3 ± 3.6% | 2.248 | 9.720 | 66.998 | 3.807 | 30.074 |
| hex: http/json-1kx1024 | 2099200 | 15738.8 ± 1.7% | 12245.8 ± 5.6% | 3177.8 ± 1.5% | 671.5 ± 1.2% | 7448.4 ± 1.5% | 982.2 ± 1.1% | 1.285 | 4.953 | 23.440 | 2.113 | 16.024 |
| hex: http/json-16kx64 | 2097280 | 28004.0 ± 0.5% | 13902.4 ± 0.4% | 3390.2 ± 0.3% | 679.6 ± 0.8% | 8565.2 ± 1.0% | 1073.5 ± 3.3% | 2.014 | 8.260 | 41.209 | 3.270 | 26.086 |
| hex: http/json-1m | 524290 | 33999.4 ± 0.3% | 15077.1 ± 0.8% | 3566.8 ± 0.4% | 699.7 ± 0.9% | 8914.7 ± 0.7% | 1110.1 ± 4.0% | 2.255 | 9.532 | 48.593 | 3.814 | 30.628 |
| hex: http/js-1kx1024 | 2099200 | 15558.7 ± 1.1% | 12205.5 ± 0.4% | 3175.3 ± 0.5% | 488.8 ± 0.4% | 7384.2 ± 2.2% | 980.3 ± 1.6% | 1.275 | 4.900 | 31.830 | 2.107 | 15.871 |
| hex: http/js-16kx64 | 2097280 | 27602.8 ± 0.2% | 14060.4 ± 0.3% | 3389.3 ± 0.4% | 494.3 ± 0.3% | 8625.8 ± 1.8% | 1081.2 ± 3.3% | 1.963 | 8.144 | 55.845 | 3.200 | 25.529 |
| hex: http/js-1m | 524290 | 33944.2 ± 0.3% | 15097.1 ± 0.6% | 3541.7 ± 0.4% | 513.2 ± 0.3% | 8916.6 ± 0.2% | 1104.9 ± 5.4% | 2.248 | 9.584 | 66.137 | 3.807 | 30.722 |
| hex: http/css-1kx1024 | 2099200 | 15255.0 ± 1.0% | 12109.8 ± 5.1% | 3165.8 ± 1.7% | 568.2 ± 0.7% | 7454.0 ± 2.6% | 984.5 ± 0.8% | 1.260 | 4.819 | 26.846 | 2.047 | 15.495 |
| hex: http/css-16kx64 | 2097280 | 27545.6 ± 4.4% | 13876.3 ± 0.4% | 3394.8 ± 0.4% | 580.6 ± 1.2% | 8481.3 ± 1.1% | 1075.5 ± 2.5% | 1.985 | 8.114 | 47.442 | 3.248 | 25.611 |
| hex: http/css-1m | 524290 | 33938.3 ± 4.6% | 15086.7 ± 1.1% | 3560.0 ± 0.6% | 558.7 ± 1.1% | 8918.5 ± 1.1% | 1109.4 ± 4.8% | 2.250 | 9.533 | 60.745 | 3.805 | 30.593 |
| hex: shuffled/dickens-1m | 524290 | 33777.0 ± 0.7% | 15007.1 ± 0.6% | 3479.1 ± 0.6% | 473.6 ± 0.8% | 8840.8 ± 0.9% | 1114.1 ± 2.2% | 2.251 | 9.709 | 71.325 | 3.821 | 30.318 |

## TextReader.next_items against the baselines

stdx's decoder a slice of tokens a call through `TextReader.next_items`, as a caller that reads a text's values in a loop calls it (decision 79). Octets are the text's. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1282.6 ± 0.2% | 1507.2 ± 1.6% | 1116.5 ± 2.1% | 390.1 ± 2.7% | 672.2 ± 0.4% | 363.9 ± 1.8% | 0.851 | 1.149 | 3.288 | 1.908 | 3.524 |
| qlog records, JSON text sequence | 1467503 | 1143.7 ± 0.3% | 1246.8 ± 0.8% | 1122.7 ± 0.7% | 330.4 ± 0.7% | 753.4 ± 0.9% | 309.2 ± 0.9% | 0.917 | 1.019 | 3.461 | 1.518 | 3.699 |
| messages: 11 string members | 1025025 | 1020.8 ± 0.6% | 2039.6 ± 1.3% | 728.2 ± 2.3% | 336.5 ± 1.9% | 508.3 ± 1.2% | 288.8 ± 3.1% | 0.501 | 1.402 | 3.033 | 2.008 | 3.535 |
| messages: 50 nested objects | 1121600 | 1300.3 ± 0.1% | 1733.6 ± 1.8% | 1457.3 ± 0.3% | 432.5 ± 0.8% | 905.3 ± 19.8% | 419.6 ± 3.8% | 0.750 | 0.892 | 3.006 | 1.436 | 3.099 |
| messages: a tree of 341 objects | 612600 | 652.6 ± 0.3% | 854.8 ± 1.2% | 694.3 ± 1.6% | 182.5 ± 0.9% | 613.1 ± 0.5% | 208.9 ± 0.6% | 0.763 | 0.940 | 3.576 | 1.065 | 3.124 |
| string: silesia/dickens | 172528 | 6731.1 ± 0.8% | 3464.0 ± 6.0% | 2815.4 ± 1.1% | 317.2 ± 2.7% | 3093.2 ± 2.0% | 571.8 ± 1.5% | 1.943 | 2.391 | 21.224 | 2.176 | 11.772 |
| string: silesia/nci | 1075110 | 5403.2 ± 0.2% | 3922.8 ± 0.4% | 2996.8 ± 0.3% | 642.8 ± 0.7% | 3610.9 ± 0.9% | 541.0 ± 4.1% | 1.377 | 1.803 | 8.406 | 1.496 | 9.987 |
| string: silesia/reymont | 1075159 | 3464.6 ± 3.0% | 3409.0 ± 0.4% | 1934.7 ± 2.4% | 341.5 ± 0.5% | 2093.9 ± 1.3% | 491.6 ± 3.9% | 1.016 | 1.791 | 10.144 | 1.655 | 7.048 |
| string: silesia/samba | 97582 | 4001.2 ± 0.7% | 3793.5 ± 0.4% | 3048.1 ± 0.2% | 326.8 ± 1.0% | 1945.9 ± 1.4% | 419.4 ± 0.9% | 1.055 | 1.313 | 12.245 | 2.056 | 9.541 |
| string: silesia/webster | 1098490 | 4399.7 ± 0.4% | 2433.2 ± 0.2% | 1726.1 ± 0.3% | 308.7 ± 0.3% | 2051.6 ± 0.5% | 454.1 ± 1.5% | 1.808 | 2.549 | 14.254 | 2.145 | 9.689 |
| string: silesia/xml | 1090118 | 6107.0 ± 0.3% | 5035.9 ± 0.4% | 2442.1 ± 0.4% | 509.7 ± 0.5% | 3325.2 ± 0.3% | 546.1 ± 2.6% | 1.213 | 2.501 | 11.982 | 1.837 | 11.183 |
| string: canterbury/alice29.txt | 159425 | 5879.4 ± 0.7% | 2798.5 ± 0.9% | 2791.0 ± 1.1% | 299.7 ± 0.4% | 2757.6 ± 2.8% | 520.2 ± 1.2% | 2.101 | 2.107 | 19.615 | 2.132 | 11.303 |
| string: canterbury/asyoulik.txt | 132198 | 4339.3 ± 0.5% | 2626.0 ± 11.0% | 2781.1 ± 2.3% | 305.6 ± 0.3% | 2425.1 ± 1.2% | 452.5 ± 1.9% | 1.652 | 1.560 | 14.197 | 1.789 | 9.590 |
| string: canterbury/lcet10.txt | 441884 | 6688.5 ± 1.1% | 3289.1 ± 0.3% | 2312.4 ± 1.2% | 345.6 ± 0.3% | 2797.5 ± 0.8% | 569.3 ± 0.3% | 2.034 | 2.892 | 19.352 | 2.391 | 11.749 |
| string: canterbury/plrabn12.txt | 503330 | 5503.8 ± 0.1% | 3172.9 ± 0.6% | 1842.0 ± 0.6% | 323.4 ± 0.4% | 2838.9 ± 0.3% | 528.0 ± 0.4% | 1.735 | 2.988 | 17.018 | 1.939 | 10.423 |
| string: canterbury-large/E.coli | 1048578 | 34116.9 ± 0.1% | 12920.7 ± 0.1% | 3428.9 ± 0.2% | 1283.6 ± 0.4% | 8928.9 ± 0.4% | 920.7 ± 2.4% | 2.640 | 9.950 | 26.579 | 3.821 | 37.055 |
| string: canterbury-large/bible.txt | 1055886 | 8647.5 ± 0.4% | 5228.2 ± 0.4% | 2806.3 ± 0.3% | 356.8 ± 0.4% | 3878.7 ± 0.3% | 610.0 ± 2.3% | 1.654 | 3.081 | 24.238 | 2.229 | 14.177 |
| string: canterbury-large/world192.txt | 1103121 | 4122.5 ± 0.4% | 2305.0 ± 0.3% | 1761.9 ± 0.3% | 327.2 ± 0.2% | 2098.5 ± 0.4% | 451.1 ± 3.6% | 1.789 | 2.340 | 12.598 | 1.965 | 9.138 |
| string: http/html-1m | 1058582 | 9360.0 ± 1.7% | 4711.5 ± 1.3% | 2686.0 ± 0.2% | 425.8 ± 0.2% | 3650.7 ± 0.8% | 587.9 ± 2.0% | 1.987 | 3.485 | 21.981 | 2.564 | 15.920 |
| string: http/json-1m | 1190272 | 3303.7 ± 0.9% | 1250.2 ± 0.3% | 2083.0 ± 0.3% | 473.7 ± 0.7% | 1334.1 ± 0.9% | 425.2 ± 0.5% | 2.643 | 1.586 | 6.974 | 2.476 | 7.769 |
| string: http/js-1m | 1144362 | 2836.2 ± 1.6% | 1600.8 ± 0.6% | 1316.4 ± 0.2% | 324.0 ± 0.3% | 1418.0 ± 0.8% | 377.6 ± 4.3% | 1.772 | 2.155 | 8.755 | 2.000 | 7.512 |
| string: http/css-1m | 1097820 | 3298.4 ± 0.3% | 2877.0 ± 0.5% | 2264.2 ± 0.4% | 451.2 ± 0.6% | 2061.0 ± 0.3% | 437.7 ± 1.5% | 1.146 | 1.457 | 7.310 | 1.600 | 7.536 |
| string: dickens as Cyrillic and CJK | 1883069 | 5807.4 ± 0.9% | 3031.9 ± 2.4% | 657.0 ± 0.5% | 377.8 ± 0.3% | 509.5 ± 0.6% | 162.6 ± 4.2% | 1.915 | 8.840 | 15.370 | 11.398 | 35.719 |
| string: dickens as Cyrillic and CJK, as \u escapes | 5075485 | 1213.7 ± 0.4% | 1236.4 ± 1.5% | 1102.6 ± 2.5% | 264.3 ± 0.5% | 478.9 ± 0.6% | 230.8 ± 3.8% | 0.982 | 1.101 | 4.592 | 2.535 | 5.258 |
| hex: silesia/dickens | 524290 | 33890.6 ± 4.5% | 15145.0 ± 0.3% | 3555.2 ± 0.5% | 476.3 ± 1.4% | 8938.0 ± 0.2% | 1135.3 ± 2.5% | 2.238 | 9.533 | 71.154 | 3.792 | 29.851 |
| hex: silesia/mozilla | 524290 | 33970.2 ± 1.2% | 15148.6 ± 0.1% | 3489.6 ± 0.4% | 430.8 ± 0.4% | 8913.2 ± 0.6% | 1134.8 ± 0.8% | 2.242 | 9.735 | 78.850 | 3.811 | 29.936 |
| hex: silesia/mr | 524290 | 33920.9 ± 0.9% | 15088.8 ± 1.2% | 3489.8 ± 3.8% | 642.5 ± 0.6% | 8888.9 ± 0.7% | 1132.9 ± 0.8% | 2.248 | 9.720 | 52.795 | 3.816 | 29.942 |
| hex: silesia/nci | 524290 | 33932.3 ± 0.6% | 15124.3 ± 0.8% | 3559.0 ± 0.2% | 807.0 ± 2.9% | 8923.5 ± 0.4% | 1135.9 ± 0.4% | 2.244 | 9.534 | 42.046 | 3.803 | 29.872 |
| hex: silesia/ooffice | 524290 | 33977.9 ± 0.2% | 15129.0 ± 0.4% | 3501.7 ± 0.1% | 346.0 ± 0.5% | 8917.6 ± 0.2% | 1138.3 ± 0.2% | 2.246 | 9.703 | 98.212 | 3.810 | 29.850 |
| hex: silesia/osdb | 524290 | 33786.4 ± 0.5% | 14985.8 ± 1.0% | 3467.1 ± 0.7% | 453.8 ± 1.7% | 8855.0 ± 0.6% | 1117.6 ± 1.1% | 2.255 | 9.745 | 74.453 | 3.816 | 30.233 |
| hex: silesia/reymont | 524290 | 33897.2 ± 0.6% | 15072.0 ± 0.5% | 3555.0 ± 0.7% | 498.0 ± 0.7% | 8892.8 ± 0.6% | 1131.7 ± 0.8% | 2.249 | 9.535 | 68.068 | 3.812 | 29.953 |
| hex: silesia/samba | 524290 | 33935.4 ± 0.7% | 15112.7 ± 0.5% | 3492.3 ± 0.4% | 368.0 ± 0.5% | 8908.1 ± 0.3% | 1134.6 ± 1.0% | 2.245 | 9.717 | 92.228 | 3.809 | 29.910 |
| hex: silesia/sao | 524290 | 33933.1 ± 1.4% | 15116.7 ± 1.1% | 3491.6 ± 0.2% | 280.2 ± 1.1% | 8916.7 ± 1.1% | 1136.3 ± 0.9% | 2.245 | 9.719 | 121.120 | 3.806 | 29.864 |
| hex: silesia/webster | 524290 | 33684.6 ± 0.9% | 15069.4 ± 1.2% | 3546.7 ± 0.8% | 449.5 ± 0.9% | 8882.5 ± 0.9% | 1123.5 ± 1.0% | 2.235 | 9.498 | 74.936 | 3.792 | 29.981 |
| hex: silesia/x-ray | 524290 | 33934.2 ± 0.5% | 15021.8 ± 0.7% | 3490.9 ± 3.4% | 425.1 ± 0.6% | 8894.9 ± 0.5% | 1130.3 ± 0.5% | 2.259 | 9.721 | 79.825 | 3.815 | 30.021 |
| hex: silesia/xml | 524290 | 33876.1 ± 3.9% | 15090.3 ± 1.5% | 3557.4 ± 1.5% | 722.9 ± 3.0% | 8901.5 ± 0.5% | 1130.3 ± 1.3% | 2.245 | 9.523 | 46.864 | 3.806 | 29.971 |
| hex: canterbury/alice29.txt | 304180 | 33666.8 ± 1.2% | 14123.6 ± 1.4% | 3553.2 ± 0.6% | 480.5 ± 1.2% | 8909.0 ± 0.7% | 1133.1 ± 3.5% | 2.384 | 9.475 | 70.062 | 3.779 | 29.713 |
| hex: canterbury/asyoulik.txt | 250360 | 33617.9 ± 1.1% | 14866.6 ± 0.6% | 3472.3 ± 0.5% | 466.4 ± 0.6% | 8843.8 ± 0.5% | 1131.6 ± 4.2% | 2.261 | 9.682 | 72.079 | 3.801 | 29.709 |
| hex: canterbury/cp.html | 49208 | 33418.2 ± 0.2% | 14432.0 ± 0.6% | 3564.6 ± 0.4% | 508.0 ± 0.8% | 9220.9 ± 0.7% | 1121.3 ± 1.3% | 2.316 | 9.375 | 65.780 | 3.624 | 29.804 |
| hex: canterbury/fields.c | 22302 | 32905.9 ± 0.6% | 17458.6 ± 1.1% | 3652.6 ± 0.7% | 565.6 ± 0.6% | 9222.1 ± 0.6% | 1100.9 ± 1.8% | 1.885 | 9.009 | 58.182 | 3.568 | 29.890 |
| hex: canterbury/grammar.lsp | 7444 | 29779.9 ± 0.3% | 17237.5 ± 0.5% | 3613.6 ± 0.6% | 738.9 ± 0.3% | 8933.4 ± 0.3% | 1053.8 ± 2.9% | 1.728 | 8.241 | 40.305 | 3.334 | 28.259 |
| hex: canterbury/kennedy.xls | 524290 | 33842.9 ± 0.4% | 15012.3 ± 0.4% | 3552.7 ± 0.3% | 759.1 ± 1.6% | 8892.2 ± 0.6% | 1118.8 ± 6.0% | 2.254 | 9.526 | 44.585 | 3.806 | 30.249 |
| hex: canterbury/lcet10.txt | 524290 | 33909.7 ± 0.9% | 15064.9 ± 1.0% | 3546.6 ± 1.1% | 481.0 ± 2.7% | 8913.0 ± 0.4% | 1131.6 ± 0.7% | 2.251 | 9.561 | 70.497 | 3.805 | 29.965 |
| hex: canterbury/plrabn12.txt | 524290 | 33906.6 ± 4.5% | 15085.3 ± 0.9% | 3552.0 ± 0.2% | 464.6 ± 1.9% | 8927.2 ± 0.4% | 1130.7 ± 0.4% | 2.248 | 9.546 | 72.973 | 3.798 | 29.987 |
| hex: canterbury/ptt5 | 524290 | 33963.2 ± 0.4% | 15084.0 ± 0.4% | 3496.9 ± 0.2% | 665.1 ± 0.5% | 8897.5 ± 0.8% | 1134.8 ± 1.1% | 2.252 | 9.712 | 51.067 | 3.817 | 29.929 |
| hex: canterbury/sum | 76482 | 33309.9 ± 0.4% | 15448.5 ± 0.7% | 3564.4 ± 0.4% | 584.5 ± 0.2% | 8916.3 ± 5.2% | 1127.9 ± 3.2% | 2.156 | 9.345 | 56.985 | 3.736 | 29.533 |
| hex: canterbury/xargs.1 | 8456 | 30317.8 ± 0.3% | 17383.3 ± 0.3% | 3559.4 ± 0.4% | 718.2 ± 2.1% | 8988.2 ± 1.3% | 1100.5 ± 3.0% | 1.744 | 8.518 | 42.214 | 3.373 | 27.549 |
| hex: canterbury-large/E.coli | 524290 | 33925.8 ± 0.4% | 15081.9 ± 2.9% | 3495.0 ± 0.4% | 963.0 ± 0.3% | 8899.1 ± 0.4% | 1125.7 ± 7.1% | 2.249 | 9.707 | 35.231 | 3.812 | 30.138 |
| hex: canterbury-large/bible.txt | 524290 | 33895.3 ± 0.5% | 15003.8 ± 0.6% | 3487.4 ± 0.8% | 496.9 ± 1.1% | 8875.5 ± 0.4% | 1071.5 ± 0.7% | 2.259 | 9.719 | 68.208 | 3.819 | 31.635 |
| hex: canterbury-large/world192.txt | 524290 | 33937.2 ± 0.2% | 15085.1 ± 2.9% | 3570.1 ± 0.1% | 467.2 ± 0.7% | 8926.0 ± 0.5% | 1128.3 ± 4.8% | 2.250 | 9.506 | 72.634 | 3.802 | 30.079 |
| hex: http/html-1kx1024 | 2099200 | 14816.8 ± 0.2% | 12498.0 ± 3.0% | 3166.4 ± 1.0% | 505.9 ± 0.5% | 7346.6 ± 7.1% | 978.1 ± 2.4% | 1.186 | 4.679 | 29.287 | 2.017 | 15.148 |
| hex: http/html-16kx64 | 2097280 | 27653.8 ± 1.1% | 14111.2 ± 2.2% | 3387.0 ± 0.8% | 512.4 ± 0.8% | 8664.7 ± 0.8% | 1080.5 ± 1.2% | 1.960 | 8.165 | 53.972 | 3.192 | 25.594 |
| hex: http/html-1m | 524290 | 33924.3 ± 0.8% | 15051.7 ± 0.5% | 3481.6 ± 0.6% | 505.1 ± 0.6% | 8889.6 ± 0.7% | 1125.3 ± 3.6% | 2.254 | 9.744 | 67.162 | 3.816 | 30.147 |
| hex: http/json-1kx1024 | 2099200 | 15411.7 ± 0.7% | 12245.8 ± 5.6% | 3177.8 ± 1.5% | 671.5 ± 1.2% | 7448.4 ± 1.5% | 982.2 ± 1.1% | 1.259 | 4.850 | 22.953 | 2.069 | 15.691 |
| hex: http/json-16kx64 | 2097280 | 27962.0 ± 0.4% | 13902.4 ± 0.4% | 3390.2 ± 0.3% | 679.6 ± 0.8% | 8565.2 ± 1.0% | 1073.5 ± 3.3% | 2.011 | 8.248 | 41.147 | 3.265 | 26.047 |
| hex: http/json-1m | 524290 | 33968.2 ± 0.3% | 15077.1 ± 0.8% | 3566.8 ± 0.4% | 699.7 ± 0.9% | 8914.7 ± 0.7% | 1110.1 ± 4.0% | 2.253 | 9.524 | 48.548 | 3.810 | 30.600 |
| hex: http/js-1kx1024 | 2099200 | 15162.0 ± 0.2% | 12205.5 ± 0.4% | 3175.3 ± 0.5% | 488.8 ± 0.4% | 7384.2 ± 2.2% | 980.3 ± 1.6% | 1.242 | 4.775 | 31.018 | 2.053 | 15.466 |
| hex: http/js-16kx64 | 2097280 | 27573.3 ± 0.1% | 14060.4 ± 0.3% | 3389.3 ± 0.4% | 494.3 ± 0.3% | 8625.8 ± 1.8% | 1081.2 ± 3.3% | 1.961 | 8.135 | 55.786 | 3.197 | 25.501 |
| hex: http/js-1m | 524290 | 33966.8 ± 0.1% | 15097.1 ± 0.6% | 3541.7 ± 0.4% | 513.2 ± 0.3% | 8916.6 ± 0.2% | 1104.9 ± 5.4% | 2.250 | 9.590 | 66.181 | 3.809 | 30.742 |
| hex: http/css-1kx1024 | 2099200 | 14893.6 ± 0.7% | 12109.8 ± 5.1% | 3165.8 ± 1.7% | 568.2 ± 0.7% | 7454.0 ± 2.6% | 984.5 ± 0.8% | 1.230 | 4.704 | 26.210 | 1.998 | 15.128 |
| hex: http/css-16kx64 | 2097280 | 27585.5 ± 0.4% | 13876.3 ± 0.4% | 3394.8 ± 0.4% | 580.6 ± 1.2% | 8481.3 ± 1.1% | 1075.5 ± 2.5% | 1.988 | 8.126 | 47.510 | 3.252 | 25.649 |
| hex: http/css-1m | 524290 | 33967.3 ± 1.0% | 15086.7 ± 1.1% | 3560.0 ± 0.6% | 558.7 ± 1.1% | 8918.5 ± 1.1% | 1109.4 ± 4.8% | 2.251 | 9.541 | 60.797 | 3.809 | 30.619 |
| hex: shuffled/dickens-1m | 524290 | 33774.8 ± 0.3% | 15007.1 ± 0.6% | 3479.1 ± 0.6% | 473.6 ± 0.8% | 8840.8 ± 0.9% | 1114.1 ± 2.2% | 2.251 | 9.708 | 71.320 | 3.820 | 30.316 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1573.9 ± 3.1% | 1476.4 ± 0.6% | 1025.6 ± 0.6% | 461.5 ± 1.1% | 441.4 ± 1.5% | 497.2 ± 4.0% | 1.066 | 1.535 | 3.410 | 3.566 | 3.166 |
| qlog records, JSON text sequence | 1467503 | 1434.9 ± 0.6% | 1215.3 ± 5.6% | 941.8 ± 2.1% | 422.5 ± 5.7% | 532.3 ± 0.8% | 350.9 ± 1.2% | 1.181 | 1.524 | 3.396 | 2.696 | 4.090 |
| messages: 11 string members | 1025025 | 1258.1 ± 0.6% | 1103.9 ± 0.4% | 765.4 ± 2.0% | 409.6 ± 2.7% | 415.6 ± 0.6% | 433.0 ± 1.0% | 1.140 | 1.644 | 3.071 | 3.027 | 2.905 |
| messages: 50 nested objects | 1121600 | 1704.3 ± 0.5% | 1875.1 ± 0.6% | 1341.9 ± 0.4% | 590.5 ± 0.7% | 608.2 ± 6.0% | 506.9 ± 0.9% | 0.909 | 1.270 | 2.886 | 2.802 | 3.362 |
| messages: a tree of 341 objects | 612600 | 496.0 ± 0.2% | 675.8 ± 1.4% | 578.8 ± 4.3% | 333.0 ± 4.2% | 352.5 ± 1.8% | 219.3 ± 0.9% | 0.734 | 0.857 | 1.490 | 1.407 | 2.262 |
| string: silesia/dickens | 172528 | 13064.8 ± 0.5% | 3958.4 ± 0.7% | 3060.8 ± 1.9% | 333.4 ± 1.0% | 1526.4 ± 0.9% | 1184.0 ± 0.9% | 3.301 | 4.268 | 39.184 | 8.559 | 11.035 |
| string: silesia/nci | 1075110 | 11179.6 ± 0.7% | 4709.3 ± 0.9% | 3090.7 ± 1.5% | 902.5 ± 0.6% | 1581.9 ± 0.9% | 1191.8 ± 1.0% | 2.374 | 3.617 | 12.387 | 7.067 | 9.381 |
| string: silesia/reymont | 1075159 | 5336.1 ± 1.3% | 1863.3 ± 0.7% | 1884.1 ± 0.5% | 378.3 ± 1.8% | 1292.8 ± 1.6% | 1043.4 ± 1.0% | 2.864 | 2.832 | 14.106 | 4.128 | 5.114 |
| string: silesia/samba | 97582 | 6329.0 ± 1.1% | 2697.1 ± 0.9% | 4055.3 ± 1.1% | 349.0 ± 1.1% | 1263.3 ± 1.4% | 1182.4 ± 1.7% | 2.347 | 1.561 | 18.135 | 5.010 | 5.353 |
| string: silesia/webster | 1098490 | 7080.4 ± 0.8% | 1968.6 ± 0.3% | 1751.6 ± 0.9% | 351.3 ± 1.2% | 1253.3 ± 1.2% | 607.2 ± 0.6% | 3.597 | 4.042 | 20.152 | 5.649 | 11.660 |
| string: silesia/xml | 1090118 | 10944.1 ± 1.1% | 3196.6 ± 1.6% | 2495.2 ± 1.2% | 603.8 ± 1.3% | 1717.8 ± 1.2% | 978.1 ± 1.1% | 3.424 | 4.386 | 18.125 | 6.371 | 11.189 |
| string: canterbury/alice29.txt | 159425 | 12777.0 ± 0.7% | 2903.1 ± 1.3% | 3028.6 ± 1.5% | 316.7 ± 1.0% | 1357.4 ± 1.4% | 1092.6 ± 0.8% | 4.401 | 4.219 | 40.346 | 9.412 | 11.694 |
| string: canterbury/asyoulik.txt | 132198 | 11093.3 ± 0.7% | 2102.0 ± 3.6% | 3120.4 ± 3.9% | 315.9 ± 1.0% | 1232.4 ± 2.8% | 954.8 ± 1.0% | 5.278 | 3.555 | 35.120 | 9.001 | 11.618 |
| string: canterbury/lcet10.txt | 441884 | 12705.8 ± 0.7% | 3047.9 ± 1.0% | 2564.3 ± 0.5% | 366.3 ± 1.0% | 1469.8 ± 2.0% | 1193.3 ± 0.6% | 4.169 | 4.955 | 34.688 | 8.645 | 10.648 |
| string: canterbury/plrabn12.txt | 503330 | 9009.9 ± 1.8% | 2312.1 ± 1.0% | 2096.0 ± 0.8% | 346.5 ± 1.7% | 1371.9 ± 3.5% | 1109.8 ± 1.3% | 3.897 | 4.299 | 26.004 | 6.567 | 8.119 |
| string: canterbury-large/E.coli | 1048578 | 34221.4 ± 0.5% | 16014.1 ± 2.0% | 3460.9 ± 2.8% | 1687.3 ± 0.8% | 3115.3 ± 2.9% | 1409.8 ± 0.8% | 2.137 | 9.888 | 20.281 | 10.985 | 24.275 |
| string: canterbury-large/bible.txt | 1055886 | 9644.2 ± 0.9% | 4876.2 ± 0.8% | 2994.5 ± 3.9% | 405.5 ± 1.8% | 2013.1 ± 4.9% | 1485.5 ± 0.5% | 1.978 | 3.221 | 23.785 | 4.791 | 6.492 |
| string: canterbury-large/world192.txt | 1103121 | 6653.7 ± 0.8% | 1721.5 ± 1.4% | 1867.6 ± 1.4% | 345.6 ± 0.4% | 1266.6 ± 1.8% | 962.7 ± 4.6% | 3.865 | 3.563 | 19.250 | 5.253 | 6.911 |
| string: http/html-1m | 1058582 | 10133.3 ± 1.4% | 4301.6 ± 1.4% | 2853.7 ± 0.6% | 418.8 ± 2.6% | 1988.1 ± 0.6% | 849.7 ± 0.9% | 2.356 | 3.551 | 24.195 | 5.097 | 11.925 |
| string: http/json-1m | 1190272 | 8333.5 ± 0.9% | 1583.1 ± 0.7% | 1569.7 ± 0.7% | 554.0 ± 0.8% | 1015.9 ± 0.5% | 842.7 ± 0.9% | 5.264 | 5.309 | 15.041 | 8.203 | 9.889 |
| string: http/js-1m | 1144362 | 6526.4 ± 1.2% | 1114.2 ± 3.7% | 1373.4 ± 0.7% | 329.1 ± 0.5% | 1028.4 ± 0.9% | 753.9 ± 0.4% | 5.857 | 4.752 | 19.829 | 6.346 | 8.656 |
| string: http/css-1m | 1097820 | 9361.8 ± 7.7% | 1478.0 ± 1.3% | 2264.5 ± 1.0% | 506.9 ± 1.1% | 1126.3 ± 1.9% | 877.9 ± 0.5% | 6.334 | 4.134 | 18.469 | 8.312 | 10.663 |
| string: dickens as Cyrillic and CJK | 1883069 | 5472.2 ± 0.9% | 3626.6 ± 0.7% | 489.2 ± 0.3% | 246.1 ± 0.8% | 456.1 ± 0.6% | 356.9 ± 0.2% | 1.509 | 11.185 | 22.238 | 11.999 | 15.334 |
| hex: silesia/dickens | 524290 | 42628.4 ± 1.0% | 2605.8 ± 0.2% | 1501.5 ± 0.3% | 464.2 ± 0.3% | 1572.2 ± 0.2% | 1063.0 ± 0.7% | 16.359 | 28.391 | 91.829 | 27.114 | 40.103 |
| hex: silesia/mozilla | 524290 | 43731.8 ± 0.2% | 2599.1 ± 0.3% | 1503.5 ± 0.8% | 392.5 ± 1.2% | 1570.8 ± 0.4% | 1063.8 ± 0.2% | 16.826 | 29.087 | 111.416 | 27.840 | 41.109 |
| hex: silesia/mr | 524290 | 43629.0 ± 0.4% | 2582.2 ± 0.7% | 1498.6 ± 0.4% | 598.2 ± 0.9% | 1565.4 ± 0.8% | 1066.7 ± 1.0% | 16.896 | 29.112 | 72.931 | 27.871 | 40.900 |
| hex: silesia/nci | 524290 | 43544.3 ± 0.5% | 2585.4 ± 0.9% | 1499.3 ± 0.4% | 755.4 ± 0.3% | 1563.0 ± 0.7% | 1063.2 ± 0.5% | 16.842 | 29.043 | 57.643 | 27.859 | 40.957 |
| hex: silesia/ooffice | 524290 | 43294.8 ± 0.6% | 2589.3 ± 0.6% | 1497.1 ± 0.5% | 319.9 ± 1.9% | 1560.1 ± 1.0% | 1055.7 ± 1.0% | 16.720 | 28.919 | 135.319 | 27.752 | 41.010 |
| hex: silesia/osdb | 524290 | 41939.8 ± 0.9% | 2595.2 ± 0.3% | 1496.2 ± 0.9% | 429.5 ± 0.4% | 1561.1 ± 1.3% | 1057.6 ± 5.8% | 16.160 | 28.031 | 97.642 | 26.865 | 39.655 |
| hex: silesia/reymont | 524290 | 43496.4 ± 0.8% | 2598.2 ± 9.2% | 1501.4 ± 0.7% | 483.9 ± 0.9% | 1566.6 ± 1.0% | 1061.9 ± 0.6% | 16.741 | 28.971 | 89.891 | 27.764 | 40.961 |
| hex: silesia/samba | 524290 | 43581.0 ± 0.4% | 2584.5 ± 5.5% | 1498.7 ± 0.6% | 336.7 ± 1.7% | 1568.4 ± 0.5% | 1060.1 ± 0.5% | 16.862 | 29.079 | 129.449 | 27.788 | 41.110 |
| hex: silesia/sao | 524290 | 43372.0 ± 1.0% | 2600.3 ± 0.8% | 1505.0 ± 1.1% | 269.9 ± 1.3% | 1549.8 ± 0.8% | 1060.1 ± 0.6% | 16.680 | 28.818 | 160.672 | 27.986 | 40.915 |
| hex: silesia/webster | 524290 | 43960.2 ± 1.0% | 2606.1 ± 0.5% | 1505.9 ± 0.5% | 436.6 ± 1.0% | 1568.4 ± 0.4% | 1064.7 ± 0.6% | 16.868 | 29.193 | 100.696 | 28.028 | 41.288 |
| hex: silesia/x-ray | 524290 | 43777.6 ± 0.2% | 2618.3 ± 0.1% | 1509.3 ± 0.1% | 421.4 ± 0.4% | 1518.9 ± 0.8% | 1067.7 ± 0.1% | 16.720 | 29.005 | 103.885 | 28.822 | 41.002 |
| hex: silesia/xml | 524290 | 43812.5 ± 0.1% | 2606.1 ± 0.1% | 1506.1 ± 0.6% | 686.9 ± 0.5% | 1555.7 ± 0.4% | 1063.5 ± 0.1% | 16.812 | 29.089 | 63.784 | 28.163 | 41.195 |
| hex: canterbury/alice29.txt | 304180 | 41307.7 ± 1.2% | 2609.0 ± 6.2% | 1518.8 ± 2.9% | 467.7 ± 1.3% | 1533.1 ± 9.8% | 1080.7 ± 1.1% | 15.832 | 27.198 | 88.317 | 26.944 | 38.222 |
| hex: canterbury/asyoulik.txt | 250360 | 43521.1 ± 0.8% | 2616.9 ± 0.6% | 1535.3 ± 0.6% | 457.0 ± 0.6% | 1564.3 ± 1.3% | 1021.9 ± 6.7% | 16.631 | 28.346 | 95.234 | 27.821 | 42.588 |
| hex: canterbury/cp.html | 49208 | 42648.4 ± 0.1% | 2605.9 ± 0.7% | 1526.2 ± 0.4% | 482.9 ± 0.6% | 1588.6 ± 0.5% | 1093.0 ± 0.3% | 16.366 | 27.945 | 88.315 | 26.846 | 39.021 |
| hex: canterbury/fields.c | 22302 | 42466.7 ± 1.3% | 2642.3 ± 0.7% | 1532.4 ± 0.7% | 601.5 ± 0.7% | 1602.6 ± 1.0% | 1096.3 ± 0.8% | 16.072 | 27.713 | 70.599 | 26.498 | 38.736 |
| hex: canterbury/grammar.lsp | 7444 | 40520.9 ± 0.4% | 2697.2 ± 0.5% | 1539.3 ± 0.4% | 813.7 ± 0.4% | 1611.0 ± 6.3% | 1105.4 ± 0.7% | 15.023 | 26.324 | 49.798 | 25.152 | 36.659 |
| hex: canterbury/kennedy.xls | 524290 | 43763.6 ± 0.3% | 2575.3 ± 0.2% | 1498.4 ± 0.1% | 785.1 ± 0.2% | 1556.4 ± 0.5% | 1066.4 ± 1.5% | 16.993 | 29.208 | 55.742 | 28.119 | 41.040 |
| hex: canterbury/lcet10.txt | 524290 | 43762.6 ± 0.4% | 2603.5 ± 0.3% | 1498.9 ± 0.6% | 470.2 ± 0.4% | 1564.1 ± 5.6% | 1066.4 ± 0.1% | 16.809 | 29.197 | 93.076 | 27.980 | 41.037 |
| hex: canterbury/plrabn12.txt | 524290 | 43633.0 ± 0.3% | 2603.7 ± 0.4% | 1502.2 ± 4.8% | 453.5 ± 3.5% | 1569.4 ± 0.6% | 1065.0 ± 0.2% | 16.758 | 29.046 | 96.211 | 27.803 | 40.969 |
| hex: canterbury/ptt5 | 524290 | 43717.4 ± 0.3% | 2570.1 ± 9.1% | 1500.4 ± 0.3% | 592.2 ± 0.6% | 1544.2 ± 1.4% | 1063.8 ± 0.4% | 17.010 | 29.137 | 73.819 | 28.311 | 41.095 |
| hex: canterbury/sum | 76482 | 43030.0 ± 0.2% | 2594.0 ± 0.4% | 1514.3 ± 8.4% | 560.8 ± 0.5% | 1576.9 ± 0.2% | 1090.3 ± 0.2% | 16.589 | 28.415 | 76.735 | 27.288 | 39.464 |
| hex: canterbury/xargs.1 | 8456 | 41029.8 ± 0.4% | 2694.9 ± 0.3% | 1543.2 ± 0.2% | 839.9 ± 0.4% | 1606.5 ± 0.4% | 1110.7 ± 0.3% | 15.225 | 26.587 | 48.848 | 25.539 | 36.941 |
| hex: canterbury-large/E.coli | 524290 | 41855.2 ± 0.9% | 2602.1 ± 0.1% | 1501.8 ± 0.2% | 817.4 ± 2.4% | 1560.5 ± 2.1% | 1067.0 ± 0.2% | 16.085 | 27.869 | 51.206 | 26.822 | 39.227 |
| hex: canterbury-large/bible.txt | 524290 | 43730.5 ± 0.4% | 2600.3 ± 0.5% | 1508.0 ± 0.3% | 481.5 ± 0.3% | 1569.2 ± 0.4% | 1064.8 ± 0.9% | 16.818 | 29.000 | 90.824 | 27.868 | 41.070 |
| hex: canterbury-large/world192.txt | 524290 | 43475.8 ± 0.4% | 2604.9 ± 0.6% | 1503.8 ± 0.3% | 446.1 ± 0.4% | 1384.9 ± 0.8% | 1065.9 ± 0.2% | 16.690 | 28.911 | 97.451 | 31.392 | 40.787 |
| hex: http/html-1kx1024 | 2099200 | 20981.8 ± 0.2% | 2376.1 ± 8.0% | 1459.6 ± 0.4% | 500.5 ± 0.5% | 1500.0 ± 1.0% | 1079.6 ± 0.3% | 8.830 | 14.375 | 41.921 | 13.988 | 19.434 |
| hex: http/html-16kx64 | 2097280 | 21271.0 ± 0.2% | 2248.1 ± 0.6% | 1453.2 ± 0.1% | 504.6 ± 4.6% | 1455.0 ± 0.2% | 1086.7 ± 0.6% | 9.462 | 14.637 | 42.151 | 14.619 | 19.574 |
| hex: http/html-1m | 524290 | 43788.5 ± 0.3% | 2614.3 ± 0.2% | 1506.9 ± 0.3% | 492.7 ± 4.2% | 1569.5 ± 5.6% | 1067.3 ± 0.2% | 16.750 | 29.059 | 88.873 | 27.899 | 41.027 |
| hex: http/json-1kx1024 | 2099200 | 20009.3 ± 0.4% | 2352.0 ± 1.3% | 1459.3 ± 0.7% | 696.1 ± 0.4% | 1507.8 ± 6.4% | 1077.2 ± 0.5% | 8.507 | 13.712 | 28.743 | 13.271 | 18.576 |
| hex: http/json-16kx64 | 2097280 | 21047.4 ± 0.6% | 2234.4 ± 6.0% | 1447.2 ± 0.5% | 705.5 ± 0.3% | 1449.2 ± 0.4% | 1082.8 ± 6.4% | 9.420 | 14.544 | 29.831 | 14.524 | 19.438 |
| hex: http/json-1m | 524290 | 43608.8 ± 0.5% | 2594.5 ± 1.2% | 1501.7 ± 0.4% | 737.0 ± 0.7% | 1561.3 ± 6.3% | 1065.5 ± 0.1% | 16.808 | 29.040 | 59.169 | 27.932 | 40.929 |
| hex: http/js-1kx1024 | 2099200 | 20333.4 ± 0.2% | 2372.4 ± 1.3% | 1453.7 ± 1.5% | 489.2 ± 1.6% | 1499.3 ± 1.4% | 1074.1 ± 7.1% | 8.571 | 13.987 | 41.565 | 13.562 | 18.930 |
| hex: http/js-16kx64 | 2097280 | 20997.1 ± 0.5% | 2242.0 ± 0.4% | 1449.4 ± 0.3% | 492.8 ± 0.2% | 1454.1 ± 0.3% | 1084.6 ± 0.3% | 9.365 | 14.487 | 42.608 | 14.440 | 19.359 |
| hex: http/js-1m | 524290 | 43630.9 ± 0.4% | 2610.6 ± 0.6% | 1504.2 ± 0.8% | 508.7 ± 0.3% | 1570.3 ± 0.6% | 1065.2 ± 0.4% | 16.713 | 29.006 | 85.762 | 27.785 | 40.959 |
| hex: http/css-1kx1024 | 2099200 | 20043.6 ± 0.2% | 2398.5 ± 2.7% | 1461.9 ± 4.7% | 556.5 ± 0.7% | 1507.8 ± 1.3% | 1075.3 ± 0.6% | 8.357 | 13.711 | 36.016 | 13.293 | 18.640 |
| hex: http/css-16kx64 | 2097280 | 20993.0 ± 0.2% | 2246.5 ± 0.3% | 1453.9 ± 0.3% | 564.6 ± 0.5% | 1455.7 ± 0.1% | 1086.5 ± 0.5% | 9.345 | 14.439 | 37.183 | 14.421 | 19.321 |
| hex: http/css-1m | 524290 | 43754.5 ± 0.1% | 2608.9 ± 0.6% | 1429.2 ± 5.2% | 539.4 ± 4.5% | 1569.5 ± 0.5% | 1065.9 ± 0.4% | 16.771 | 30.614 | 81.117 | 27.878 | 41.049 |
| hex: shuffled/dickens-1m | 524290 | 42529.9 ± 0.4% | 2605.0 ± 0.8% | 1504.5 ± 0.8% | 464.4 ± 1.0% | 1570.1 ± 0.9% | 1061.0 ± 0.8% | 16.326 | 28.269 | 91.571 | 27.088 | 40.084 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding: stdx runs at 0.915 of simdjson.
- qlog records, JSON text sequence, decoding: stdx runs at 0.880 of simdjson.
- messages: 11 string members, decoding: stdx runs at 0.521 of simdjson.
- messages: 50 nested objects, decoding: stdx runs at 0.774 of simdjson.
- messages: 50 nested objects, decoding: stdx runs at 0.920 of yyjson.
- messages: a tree of 341 objects, decoding: stdx runs at 0.783 of simdjson.
- messages: a tree of 341 objects, encoding: stdx runs at 0.879 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.763 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.797 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.885 of yyjson.
- messages: 11 string members, decoding through TextReader.next: stdx runs at 0.464 of simdjson.
- messages: 50 nested objects, decoding through TextReader.next: stdx runs at 0.714 of simdjson.
- messages: 50 nested objects, decoding through TextReader.next: stdx runs at 0.849 of yyjson.
- messages: a tree of 341 objects, decoding through TextReader.next: stdx runs at 0.640 of simdjson.
- messages: a tree of 341 objects, decoding through TextReader.next: stdx runs at 0.788 of yyjson.
- messages: a tree of 341 objects, decoding through TextReader.next: stdx runs at 0.893 of serde_json.
- CLDR supplemental, 34 texts, decoding through TextReader.next_items: stdx runs at 0.851 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next_items: stdx runs at 0.917 of simdjson.
- messages: 11 string members, decoding through TextReader.next_items: stdx runs at 0.501 of simdjson.
- messages: 50 nested objects, decoding through TextReader.next_items: stdx runs at 0.750 of simdjson.
- messages: 50 nested objects, decoding through TextReader.next_items: stdx runs at 0.892 of yyjson.
- messages: a tree of 341 objects, decoding through TextReader.next_items: stdx runs at 0.763 of simdjson.
- messages: a tree of 341 objects, decoding through TextReader.next_items: stdx runs at 0.940 of yyjson.
- messages: 50 nested objects, encoding through TextWriter's methods: stdx runs at 0.909 of simdjson.
- messages: a tree of 341 objects, encoding through TextWriter's methods: stdx runs at 0.734 of simdjson.
- messages: a tree of 341 objects, encoding through TextWriter's methods: stdx runs at 0.857 of yyjson.
