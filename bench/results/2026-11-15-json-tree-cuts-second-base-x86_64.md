# bench-json

| Field | Value |
|---|---|
| Commit | 936cf02 |
| Runner label | ubuntu-24.04 |
| Image version | 20261111.127.1 |
| CPU model | Intel(R) Xeon(R) 6975P-C |
| Virtual CPUs | 4 |
| Kernel | 7.0.0-1014-aws |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/43668089875 |
| Date | 2026-11-15 |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1. The `TextReader.next_items` column is that helper's queued tokens a slice a call (decision 79), over many tokens a call.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | TextReader.next_items | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1385.1 ± 33.4% | 0.490 | 1.026 | 1.062 | 1.069 | 0.411 | 1.072 | 1.069 | 0.371 | 0.831 | 0.928 | 0.106 |
| qlog records, JSON text sequence | 1467503 | 1114.9 ± 0.7% | 0.740 | 1.051 | 1.053 | 1.056 | 0.384 | 1.054 | 1.057 | 0.362 | 0.901 | 1.034 | 0.124 |
| messages: 11 string members | 1025025 | 1078.0 ± 0.2% | 0.581 | 1.002 | 1.027 | 1.024 | 0.542 | 1.016 | 1.021 | 0.539 | 0.887 | 0.957 | 0.137 |
| messages: 50 nested objects | 1121600 | 1346.5 ± 0.1% | 0.805 | 1.088 | 1.088 | 1.089 | 0.398 | 1.097 | 1.088 | 0.352 | 0.922 | 0.969 | 0.114 |
| messages: a tree of 341 objects | 612600 | 671.5 ± 1.5% | 0.810 | 1.047 | 1.028 | 1.031 | 0.265 | 1.023 | 1.032 | 0.219 | 0.824 | 0.976 | 0.117 |
| string: silesia/dickens | 172528 | 6743.1 ± 0.3% | 0.029 | 0.697 | 1.083 | 1.082 | 0.207 | 1.036 | 1.100 | 0.207 | 1.001 | 1.001 | 0.029 |
| string: silesia/nci | 1075110 | 5435.8 ± 0.3% | 0.036 | 0.729 | 1.033 | 1.033 | 0.308 | 1.037 | 1.033 | 0.307 | 1.003 | 1.006 | 0.035 |
| string: silesia/reymont | 1075159 | 3551.4 ± 3.3% | 0.055 | 0.621 | 0.877 | 0.868 | 0.355 | 0.818 | 0.874 | 0.355 | 0.978 | 0.985 | 0.055 |
| string: silesia/samba | 97582 | 3989.9 ± 1.0% | 0.041 | 0.909 | 1.065 | 1.066 | 0.075 | 0.859 | 1.066 | 0.075 | 1.003 | 1.003 | 0.041 |
| string: silesia/webster | 1098490 | 4399.6 ± 0.5% | 0.043 | 0.649 | 0.979 | 0.993 | 0.229 | 0.933 | 1.002 | 0.229 | 1.002 | 1.007 | 0.043 |
| string: silesia/xml | 1090118 | 6091.1 ± 0.5% | 0.032 | 0.785 | 0.959 | 0.970 | 0.252 | 0.958 | 0.973 | 0.252 | 1.002 | 1.006 | 0.032 |
| string: canterbury/alice29.txt | 159425 | 5827.1 ± 1.0% | 0.033 | 0.747 | 1.083 | 1.114 | 0.184 | 1.010 | 1.146 | 0.185 | 1.000 | 1.009 | 0.032 |
| string: canterbury/asyoulik.txt | 132198 | 4324.1 ± 0.9% | 0.042 | 0.794 | 1.132 | 1.126 | 0.201 | 1.059 | 1.137 | 0.201 | 1.000 | 1.006 | 0.042 |
| string: canterbury/lcet10.txt | 441884 | 6660.0 ± 0.8% | 0.029 | 0.610 | 1.107 | 1.112 | 0.202 | 1.035 | 1.124 | 0.202 | 1.003 | 1.006 | 0.029 |
| string: canterbury/plrabn12.txt | 503330 | 5498.0 ± 0.2% | 0.035 | 0.768 | 0.969 | 0.975 | 0.230 | 0.866 | 0.974 | 0.229 | 1.002 | 1.003 | 0.035 |
| string: canterbury-large/E.coli | 1048578 | 29020.4 ± 0.2% | 0.062 | 1.001 | 0.790 | 1.002 | 0.531 | 1.002 | 1.002 | 0.532 | 1.173 | 1.177 | 0.007 |
| string: canterbury-large/bible.txt | 1055886 | 8612.5 ± 2.4% | 0.024 | 0.618 | 0.873 | 0.876 | 0.399 | 0.880 | 0.892 | 0.399 | 1.002 | 1.005 | 0.024 |
| string: canterbury-large/world192.txt | 1103121 | 4169.0 ± 1.1% | 0.045 | 0.694 | 0.972 | 0.982 | 0.217 | 0.933 | 0.993 | 0.219 | 1.001 | 1.006 | 0.045 |
| string: http/html-1m | 1058582 | 9095.3 ± 2.6% | 0.022 | 0.569 | 0.790 | 0.793 | 0.324 | 0.756 | 0.802 | 0.324 | 0.969 | 1.065 | 0.022 |
| string: http/json-1m | 1190272 | 3324.9 ± 0.3% | 0.052 | 0.397 | 0.443 | 0.447 | 0.150 | 0.461 | 0.448 | 0.150 | 1.003 | 1.002 | 0.053 |
| string: http/js-1m | 1144362 | 2848.2 ± 0.6% | 0.063 | 0.706 | 0.904 | 0.934 | 0.196 | 0.854 | 0.935 | 0.196 | 1.005 | 1.007 | 0.063 |
| string: http/css-1m | 1097820 | 3316.8 ± 0.3% | 0.055 | 0.780 | 0.958 | 1.028 | 0.291 | 0.970 | 1.031 | 0.291 | 1.003 | 1.006 | 0.055 |
| string: dickens as Cyrillic and CJK | 1883069 | 5851.0 ± 0.5% | 0.025 | 0.064 | 0.448 | 0.447 | 0.200 | 0.445 | 0.448 | 0.200 | 1.002 | 1.004 | 0.025 |
| string: dickens as Cyrillic and CJK, as \u escapes | 5075485 | 1208.5 ± 0.7% | 0.112 | 1.002 | 1.003 | 1.002 | 0.106 | 0.714 | 1.001 | 0.106 | 1.010 | 1.010 | 0.112 |
| hex: silesia/dickens | 524290 | 46222.1 ± 0.1% | 0.040 | 0.998 | 0.620 | 0.997 | 0.393 | 0.999 | 0.997 | 0.393 | 0.737 | 0.737 | 0.005 |
| hex: silesia/mozilla | 524290 | 36838.4 ± 0.1% | 0.050 | 1.000 | 0.659 | 1.000 | 0.459 | 1.000 | 1.000 | 0.460 | 0.924 | 0.925 | 0.006 |
| hex: silesia/mr | 524290 | 45189.9 ± 0.3% | 0.041 | 0.997 | 0.636 | 0.997 | 0.393 | 0.998 | 0.997 | 0.394 | 0.753 | 0.754 | 0.005 |
| hex: silesia/nci | 524290 | 46067.0 ± 0.4% | 0.040 | 0.997 | 0.614 | 0.996 | 0.394 | 0.998 | 0.996 | 0.393 | 0.739 | 0.740 | 0.005 |
| hex: silesia/ooffice | 524290 | 46853.0 ± 0.4% | 0.039 | 0.996 | 0.603 | 0.995 | 0.377 | 0.999 | 0.994 | 0.378 | 0.727 | 0.727 | 0.005 |
| hex: silesia/osdb | 524290 | 45464.3 ± 0.2% | 0.040 | 1.001 | 0.619 | 1.000 | 0.394 | 1.000 | 1.001 | 0.395 | 0.749 | 0.749 | 0.005 |
| hex: silesia/reymont | 524290 | 46187.4 ± 0.3% | 0.040 | 0.997 | 0.624 | 0.996 | 0.392 | 0.998 | 0.996 | 0.393 | 0.738 | 0.738 | 0.005 |
| hex: silesia/samba | 524290 | 33944.5 ± 0.1% | 0.054 | 1.002 | 0.706 | 1.003 | 0.483 | 1.002 | 1.002 | 0.483 | 1.004 | 1.003 | 0.006 |
| hex: silesia/sao | 524290 | 47998.2 ± 0.2% | 0.038 | 0.992 | 0.596 | 0.991 | 0.379 | 0.994 | 0.991 | 0.379 | 0.710 | 0.709 | 0.004 |
| hex: silesia/webster | 524290 | 46254.1 ± 0.1% | 0.040 | 0.998 | 0.620 | 0.997 | 0.393 | 0.998 | 0.998 | 0.393 | 0.737 | 0.737 | 0.005 |
| hex: silesia/x-ray | 524290 | 46989.5 ± 0.2% | 0.039 | 0.994 | 0.607 | 0.993 | 0.364 | 0.997 | 0.994 | 0.365 | 0.726 | 0.725 | 0.005 |
| hex: silesia/xml | 524290 | 47079.3 ± 0.0% | 0.039 | 0.994 | 0.601 | 0.993 | 0.385 | 0.996 | 0.995 | 0.385 | 0.723 | 0.724 | 0.005 |
| hex: canterbury/alice29.txt | 304180 | 46570.8 ± 0.2% | 0.040 | 0.998 | 0.606 | 0.998 | 0.388 | 0.998 | 0.998 | 0.389 | 0.728 | 0.729 | 0.005 |
| hex: canterbury/asyoulik.txt | 250360 | 46182.4 ± 0.2% | 0.040 | 0.998 | 0.621 | 0.998 | 0.392 | 0.999 | 0.998 | 0.392 | 0.737 | 0.736 | 0.005 |
| hex: canterbury/cp.html | 49208 | 45169.4 ± 0.2% | 0.041 | 1.001 | 0.623 | 0.995 | 0.390 | 0.994 | 0.995 | 0.393 | 0.742 | 0.741 | 0.005 |
| hex: canterbury/fields.c | 22302 | 50265.6 ± 0.3% | 0.037 | 1.027 | 0.553 | 1.018 | 0.399 | 1.007 | 1.017 | 0.406 | 0.660 | 0.659 | 0.004 |
| hex: canterbury/grammar.lsp | 7444 | 44236.7 ± 0.5% | 0.042 | 0.983 | 0.577 | 1.010 | 0.412 | 0.997 | 1.008 | 0.435 | 0.679 | 0.678 | 0.005 |
| hex: canterbury/kennedy.xls | 524290 | 46497.3 ± 0.3% | 0.040 | 0.998 | 0.617 | 0.997 | 0.391 | 0.999 | 0.997 | 0.392 | 0.733 | 0.732 | 0.005 |
| hex: canterbury/lcet10.txt | 524290 | 49302.1 ± 0.2% | 0.037 | 0.993 | 0.582 | 0.991 | 0.368 | 0.995 | 0.992 | 0.369 | 0.692 | 0.691 | 0.004 |
| hex: canterbury/plrabn12.txt | 524290 | 46192.6 ± 0.3% | 0.040 | 0.996 | 0.620 | 0.994 | 0.393 | 0.997 | 0.995 | 0.393 | 0.737 | 0.737 | 0.005 |
| hex: canterbury/ptt5 | 524290 | 46763.8 ± 0.3% | 0.039 | 0.996 | 0.612 | 0.997 | 0.387 | 0.998 | 0.997 | 0.387 | 0.729 | 0.728 | 0.005 |
| hex: canterbury/sum | 76482 | 47674.2 ± 0.4% | 0.039 | 1.001 | 0.592 | 1.002 | 0.375 | 1.002 | 1.002 | 0.377 | 0.702 | 0.702 | 0.004 |
| hex: canterbury/xargs.1 | 8456 | 45285.7 ± 0.5% | 0.041 | 0.979 | 0.574 | 1.009 | 0.411 | 0.976 | 1.008 | 0.431 | 0.674 | 0.673 | 0.005 |
| hex: canterbury-large/E.coli | 524290 | 47936.2 ± 0.5% | 0.038 | 0.994 | 0.597 | 0.992 | 0.379 | 0.995 | 0.991 | 0.380 | 0.711 | 0.710 | 0.004 |
| hex: canterbury-large/bible.txt | 524290 | 46777.4 ± 0.2% | 0.039 | 0.996 | 0.612 | 0.996 | 0.389 | 0.998 | 0.996 | 0.389 | 0.729 | 0.728 | 0.005 |
| hex: canterbury-large/world192.txt | 524290 | 44900.8 ± 0.6% | 0.041 | 0.995 | 0.616 | 0.996 | 0.400 | 0.998 | 0.995 | 0.401 | 0.759 | 0.759 | 0.005 |
| hex: http/html-1kx1024 | 2099200 | 18152.3 ± 1.0% | 0.100 | 1.042 | 0.822 | 0.997 | 0.583 | 1.010 | 0.997 | 0.642 | 0.854 | 0.831 | 0.012 |
| hex: http/html-16kx64 | 2097280 | 33739.1 ± 0.4% | 0.054 | 1.003 | 0.699 | 1.003 | 0.480 | 1.003 | 1.003 | 0.484 | 0.809 | 0.809 | 0.006 |
| hex: http/html-1m | 524290 | 46809.8 ± 0.4% | 0.039 | 0.995 | 0.606 | 0.993 | 0.388 | 0.995 | 0.993 | 0.388 | 0.728 | 0.728 | 0.005 |
| hex: http/json-1kx1024 | 2099200 | 18164.4 ± 2.3% | 0.101 | 1.047 | 0.826 | 0.994 | 0.584 | 1.006 | 0.994 | 0.645 | 0.856 | 0.834 | 0.012 |
| hex: http/json-16kx64 | 2097280 | 35820.8 ± 0.4% | 0.051 | 1.002 | 0.674 | 1.003 | 0.460 | 1.002 | 1.002 | 0.464 | 0.791 | 0.791 | 0.006 |
| hex: http/json-1m | 524290 | 47962.8 ± 0.1% | 0.038 | 0.993 | 0.601 | 0.991 | 0.379 | 0.993 | 0.989 | 0.379 | 0.711 | 0.710 | 0.004 |
| hex: http/js-1kx1024 | 2099200 | 18088.3 ± 2.7% | 0.100 | 1.054 | 0.825 | 0.996 | 0.571 | 1.005 | 0.998 | 0.631 | 0.858 | 0.838 | 0.012 |
| hex: http/js-16kx64 | 2097280 | 34931.8 ± 0.7% | 0.053 | 1.003 | 0.688 | 1.002 | 0.470 | 1.002 | 1.002 | 0.475 | 0.804 | 0.803 | 0.006 |
| hex: http/js-1m | 524290 | 46201.6 ± 1.9% | 0.040 | 0.996 | 0.624 | 0.995 | 0.393 | 0.997 | 0.995 | 0.394 | 0.737 | 0.737 | 0.005 |
| hex: http/css-1kx1024 | 2099200 | 18058.3 ± 3.5% | 0.101 | 1.055 | 0.829 | 0.994 | 0.589 | 1.004 | 0.992 | 0.650 | 0.863 | 0.842 | 0.012 |
| hex: http/css-16kx64 | 2097280 | 35881.9 ± 0.2% | 0.051 | 1.000 | 0.673 | 1.004 | 0.460 | 1.005 | 1.003 | 0.464 | 0.792 | 0.792 | 0.006 |
| hex: http/css-1m | 524290 | 46672.3 ± 0.6% | 0.039 | 0.998 | 0.616 | 0.998 | 0.389 | 0.999 | 0.998 | 0.389 | 0.730 | 0.730 | 0.005 |
| hex: shuffled/dickens-1m | 524290 | 46007.6 ± 2.1% | 0.040 | 0.995 | 0.614 | 0.994 | 0.393 | 0.996 | 0.994 | 0.393 | 0.740 | 0.740 | 0.005 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1764.8 ± 0.6% | 0.423 | 0.999 | 0.972 | 1.011 | 1.008 | 0.270 | 1.009 | 0.514 | 0.902 | 0.094 | 1.027 |
| qlog records, JSON text sequence | 1467503 | 1699.4 ± 0.6% | 0.630 | 0.956 | 0.963 | 0.995 | 0.975 | 0.232 | 0.974 | 0.428 | 0.855 | 0.105 | 1.021 |
| messages: 11 string members | 1025025 | 1338.3 ± 0.5% | 0.501 | 0.962 | 0.982 | 0.989 | 0.979 | 0.380 | 0.979 | 0.669 | 0.950 | 0.122 | 0.998 |
| messages: 50 nested objects | 1121600 | 2013.2 ± 5.7% | 0.582 | 0.977 | 0.969 | 0.989 | 0.968 | 0.244 | 0.970 | 0.431 | 0.854 | 0.092 | 1.005 |
| messages: a tree of 341 objects | 612600 | 603.5 ± 2.8% | 0.970 | 1.050 | 1.069 | 1.071 | 1.072 | 0.263 | 1.071 | 0.444 | 0.830 | 0.193 | 1.079 |
| string: silesia/dickens | 172528 | 13077.3 ± 0.8% | 0.018 | 0.539 | 0.360 | 0.529 | 0.562 | 0.121 | 0.568 | 1.003 | 0.999 | 0.018 | 1.030 |
| string: silesia/nci | 1075110 | 11307.7 ± 0.4% | 0.020 | 0.527 | 0.362 | 0.537 | 0.527 | 0.186 | 0.527 | 1.004 | 1.005 | 0.020 | 1.039 |
| string: silesia/reymont | 1075159 | 5302.1 ± 2.5% | 0.043 | 0.582 | 0.440 | 0.574 | 0.585 | 0.273 | 0.579 | 1.010 | 1.018 | 0.043 | 1.030 |
| string: silesia/samba | 97582 | 6357.4 ± 0.4% | 0.045 | 0.888 | 0.741 | 0.898 | 0.893 | 0.122 | 0.895 | 0.999 | 1.001 | 0.045 | 1.157 |
| string: silesia/webster | 1098490 | 7112.1 ± 0.7% | 0.032 | 0.574 | 0.398 | 0.550 | 0.579 | 0.157 | 0.578 | 0.988 | 1.011 | 0.032 | 0.989 |
| string: silesia/xml | 1090118 | 10711.6 ± 0.5% | 0.022 | 0.564 | 0.468 | 0.560 | 0.567 | 0.209 | 0.568 | 1.000 | 1.014 | 0.022 | 1.026 |
| string: canterbury/alice29.txt | 159425 | 12764.1 ± 1.4% | 0.018 | 0.427 | 0.356 | 0.422 | 0.450 | 0.093 | 0.470 | 1.001 | 1.006 | 0.018 | 1.050 |
| string: canterbury/asyoulik.txt | 132198 | 11108.7 ± 2.1% | 0.019 | 0.392 | 0.328 | 0.382 | 0.406 | 0.089 | 0.417 | 0.996 | 1.011 | 0.019 | 1.037 |
| string: canterbury/lcet10.txt | 441884 | 12738.6 ± 2.0% | 0.018 | 0.546 | 0.326 | 0.532 | 0.548 | 0.118 | 0.551 | 1.000 | 1.022 | 0.018 | 1.005 |
| string: canterbury/plrabn12.txt | 503330 | 8874.2 ± 0.5% | 0.025 | 0.619 | 0.497 | 0.620 | 0.621 | 0.160 | 0.621 | 0.992 | 1.018 | 0.025 | 1.020 |
| string: canterbury-large/E.coli | 1048578 | 31868.4 ± 1.0% | 0.057 | 1.002 | 1.002 | 0.775 | 1.003 | 0.502 | 1.003 | 1.002 | 1.001 | 0.008 | 1.003 |
| string: canterbury-large/bible.txt | 1055886 | 9710.3 ± 0.5% | 0.024 | 0.740 | 0.567 | 0.743 | 0.749 | 0.393 | 0.753 | 0.991 | 1.007 | 0.024 | 1.019 |
| string: canterbury-large/world192.txt | 1103121 | 6712.7 ± 1.6% | 0.033 | 0.588 | 0.425 | 0.556 | 0.590 | 0.153 | 0.592 | 0.986 | 1.001 | 0.033 | 0.970 |
| string: http/html-1m | 1058582 | 10235.3 ± 0.4% | 0.023 | 0.639 | 0.535 | 0.633 | 0.643 | 0.314 | 0.643 | 0.992 | 1.008 | 0.023 | 1.010 |
| string: http/json-1m | 1190272 | 8427.7 ± 0.3% | 0.024 | 0.185 | 0.161 | 0.185 | 0.185 | 0.073 | 0.185 | 1.002 | 1.001 | 0.024 | 1.016 |
| string: http/js-1m | 1144362 | 6597.2 ± 1.4% | 0.032 | 0.370 | 0.313 | 0.361 | 0.370 | 0.094 | 0.370 | 0.989 | 0.999 | 0.032 | 1.011 |
| string: http/css-1m | 1097820 | 9242.7 ± 0.4% | 0.023 | 0.353 | 0.287 | 0.339 | 0.352 | 0.125 | 0.353 | 1.002 | 1.008 | 0.023 | 0.988 |
| string: dickens as Cyrillic and CJK | 1883069 | 5519.2 ± 0.3% | 0.030 | 0.466 | 0.069 | 0.464 | 0.467 | 0.209 | 0.467 | 1.001 | 1.001 | 0.031 | 1.037 |
| hex: silesia/dickens | 524290 | 42655.7 ± 0.6% | 1.003 | 0.091 | 1.001 | 0.603 | 1.003 | 1.001 | 1.002 | 1.002 | 1.001 | 0.094 | 1.002 |
| hex: silesia/mozilla | 524290 | 43862.4 ± 0.1% | 1.001 | 0.088 | 1.001 | 0.589 | 1.001 | 1.000 | 0.971 | 1.000 | 1.000 | 0.092 | 1.000 |
| hex: silesia/mr | 524290 | 43865.4 ± 0.0% | 0.970 | 0.088 | 1.001 | 0.589 | 1.002 | 1.000 | 0.968 | 1.001 | 1.001 | 0.094 | 1.002 |
| hex: silesia/nci | 524290 | 43862.2 ± 3.0% | 1.001 | 0.088 | 1.000 | 0.588 | 1.001 | 0.999 | 1.001 | 1.000 | 1.000 | 0.094 | 1.001 |
| hex: silesia/ooffice | 524290 | 43851.4 ± 0.1% | 1.001 | 0.088 | 1.000 | 0.589 | 1.001 | 0.999 | 1.001 | 1.000 | 1.000 | 0.092 | 1.001 |
| hex: silesia/osdb | 524290 | 42257.4 ± 0.2% | 1.002 | 0.091 | 1.001 | 0.609 | 1.002 | 1.000 | 1.002 | 1.001 | 1.001 | 0.093 | 1.001 |
| hex: silesia/reymont | 524290 | 42548.4 ± 4.0% | 0.994 | 0.091 | 1.032 | 0.607 | 1.032 | 1.031 | 1.032 | 1.032 | 1.031 | 0.096 | 1.031 |
| hex: silesia/samba | 524290 | 43912.1 ± 0.3% | 1.001 | 0.088 | 1.000 | 0.589 | 1.001 | 1.000 | 1.001 | 1.001 | 1.000 | 0.092 | 1.000 |
| hex: silesia/sao | 524290 | 43889.6 ± 0.1% | 1.001 | 0.088 | 1.001 | 0.589 | 1.001 | 0.999 | 1.001 | 1.001 | 1.000 | 0.092 | 1.001 |
| hex: silesia/webster | 524290 | 44182.4 ± 0.0% | 1.002 | 0.087 | 1.000 | 0.586 | 1.001 | 0.999 | 1.002 | 1.000 | 1.000 | 0.093 | 1.001 |
| hex: silesia/x-ray | 524290 | 43918.9 ± 0.1% | 1.001 | 0.088 | 1.000 | 0.588 | 1.000 | 0.999 | 1.001 | 1.000 | 1.000 | 0.095 | 1.000 |
| hex: silesia/xml | 524290 | 43846.5 ± 0.2% | 1.001 | 0.088 | 1.000 | 0.589 | 1.001 | 0.999 | 1.001 | 1.000 | 0.999 | 0.094 | 1.000 |
| hex: canterbury/alice29.txt | 304180 | 41969.9 ± 6.5% | 0.998 | 0.092 | 0.998 | 0.595 | 0.999 | 0.998 | 0.999 | 0.999 | 0.997 | 0.098 | 0.999 |
| hex: canterbury/asyoulik.txt | 250360 | 43772.2 ± 8.1% | 1.000 | 0.088 | 1.001 | 0.589 | 1.002 | 0.999 | 0.972 | 1.000 | 1.000 | 0.092 | 1.001 |
| hex: canterbury/cp.html | 49208 | 42790.1 ± 0.1% | 1.000 | 0.090 | 1.000 | 0.592 | 1.001 | 0.995 | 1.001 | 1.001 | 1.000 | 0.098 | 1.002 |
| hex: canterbury/fields.c | 22302 | 42280.8 ± 0.1% | 0.999 | 0.091 | 1.000 | 0.597 | 1.001 | 0.989 | 1.002 | 1.003 | 1.009 | 0.098 | 1.003 |
| hex: canterbury/grammar.lsp | 7444 | 39463.7 ± 0.5% | 0.987 | 0.096 | 1.000 | 0.609 | 0.999 | 0.968 | 1.000 | 1.003 | 1.034 | 0.103 | 1.004 |
| hex: canterbury/kennedy.xls | 524290 | 43842.2 ± 0.6% | 1.001 | 0.088 | 1.000 | 0.589 | 1.001 | 1.000 | 1.001 | 1.001 | 1.001 | 0.094 | 1.000 |
| hex: canterbury/lcet10.txt | 524290 | 43813.9 ± 0.1% | 1.001 | 0.088 | 1.001 | 0.589 | 1.001 | 0.998 | 1.001 | 1.000 | 1.001 | 0.092 | 1.001 |
| hex: canterbury/plrabn12.txt | 524290 | 43885.1 ± 0.2% | 1.001 | 0.088 | 1.000 | 0.589 | 1.001 | 0.999 | 1.001 | 1.001 | 1.001 | 0.092 | 1.001 |
| hex: canterbury/ptt5 | 524290 | 43901.5 ± 0.2% | 1.001 | 0.088 | 1.001 | 0.589 | 1.001 | 1.000 | 1.001 | 1.001 | 1.000 | 0.094 | 1.001 |
| hex: canterbury/sum | 76482 | 43166.2 ± 0.1% | 1.000 | 0.089 | 1.000 | 0.593 | 1.002 | 0.995 | 1.002 | 1.000 | 1.001 | 0.096 | 1.001 |
| hex: canterbury/xargs.1 | 8456 | 40321.3 ± 0.1% | 1.001 | 0.095 | 1.000 | 0.600 | 1.000 | 0.949 | 1.000 | 0.990 | 1.022 | 0.102 | 1.004 |
| hex: canterbury-large/E.coli | 524290 | 42025.0 ± 0.1% | 1.001 | 0.092 | 1.002 | 0.608 | 1.002 | 1.001 | 1.002 | 1.002 | 1.001 | 0.097 | 1.001 |
| hex: canterbury-large/bible.txt | 524290 | 43923.7 ± 0.2% | 1.001 | 0.088 | 1.001 | 0.588 | 0.969 | 1.000 | 1.001 | 1.001 | 1.001 | 0.093 | 1.001 |
| hex: canterbury-large/world192.txt | 524290 | 43592.6 ± 0.1% | 1.002 | 0.089 | 1.001 | 0.592 | 1.002 | 1.000 | 1.002 | 1.000 | 1.001 | 0.095 | 1.001 |
| hex: http/html-1kx1024 | 2099200 | 21094.1 ± 0.2% | 1.001 | 0.175 | 1.001 | 0.971 | 1.001 | 0.997 | 1.001 | 1.001 | 1.004 | 0.183 | 1.002 |
| hex: http/html-16kx64 | 2097280 | 22740.1 ± 0.3% | 1.001 | 0.168 | 1.001 | 0.956 | 0.984 | 1.000 | 1.001 | 1.001 | 1.001 | 0.181 | 1.001 |
| hex: http/html-1m | 524290 | 43891.6 ± 0.1% | 1.001 | 0.088 | 1.000 | 0.590 | 1.000 | 0.999 | 1.001 | 1.001 | 1.000 | 0.094 | 1.000 |
| hex: http/json-1kx1024 | 2099200 | 21824.2 ± 0.5% | 1.001 | 0.169 | 1.000 | 0.953 | 1.000 | 0.993 | 1.000 | 0.998 | 1.006 | 0.176 | 1.001 |
| hex: http/json-16kx64 | 2097280 | 22524.4 ± 0.5% | 1.001 | 0.169 | 1.002 | 0.947 | 1.002 | 1.000 | 1.002 | 1.001 | 1.002 | 0.183 | 1.002 |
| hex: http/json-1m | 524290 | 43701.4 ± 0.1% | 1.001 | 0.087 | 1.001 | 0.591 | 1.001 | 0.999 | 1.000 | 1.000 | 1.000 | 0.093 | 1.001 |
| hex: http/js-1kx1024 | 2099200 | 20395.2 ± 0.0% | 1.000 | 0.181 | 0.999 | 0.984 | 1.000 | 0.999 | 1.000 | 1.000 | 1.004 | 0.189 | 1.001 |
| hex: http/js-16kx64 | 2097280 | 22374.0 ± 0.4% | 1.001 | 0.170 | 1.002 | 0.963 | 1.001 | 1.000 | 1.001 | 1.003 | 1.003 | 0.185 | 1.003 |
| hex: http/js-1m | 524290 | 43854.6 ± 4.0% | 0.966 | 0.088 | 1.001 | 0.589 | 1.001 | 1.000 | 1.001 | 1.001 | 0.999 | 0.092 | 1.001 |
| hex: http/css-1kx1024 | 2099200 | 22405.8 ± 0.2% | 1.000 | 0.165 | 1.000 | 0.943 | 1.000 | 0.990 | 1.000 | 1.000 | 1.007 | 0.172 | 1.003 |
| hex: http/css-16kx64 | 2097280 | 22010.6 ± 0.3% | 1.001 | 0.173 | 1.002 | 0.975 | 1.002 | 1.003 | 1.002 | 1.002 | 1.003 | 0.187 | 1.002 |
| hex: http/css-1m | 524290 | 43582.6 ± 7.6% | 1.006 | 0.089 | 1.007 | 0.594 | 1.007 | 1.006 | 1.007 | 1.007 | 1.007 | 0.092 | 1.007 |
| hex: shuffled/dickens-1m | 524290 | 42660.5 ± 0.4% | 1.001 | 0.091 | 1.001 | 0.607 | 1.001 | 1.000 | 1.002 | 1.001 | 1.001 | 0.097 | 1.001 |

## Losses

Each workload where a claim's path ran slower than the path it replaces by more than the noise floor of decision 20.

- qlog records, JSON text sequence, decoding: J5 UTF-8 vectors off runs at 1.051 of all on.
- qlog records, JSON text sequence, decoding: J7 wide vectors off runs at 1.053 of all on.
- qlog records, JSON text sequence, decoding: J8 decoder fast path off runs at 1.056 of all on.
- qlog records, JSON text sequence, decoding: J12 decoder escape words off runs at 1.054 of all on.
- qlog records, JSON text sequence, decoding: J13 decoder escape blocks off runs at 1.057 of all on.
- messages: 50 nested objects, decoding: J5 UTF-8 vectors off runs at 1.088 of all on.
- messages: 50 nested objects, decoding: J7 wide vectors off runs at 1.088 of all on.
- messages: 50 nested objects, decoding: J8 decoder fast path off runs at 1.089 of all on.
- messages: 50 nested objects, decoding: J12 decoder escape words off runs at 1.097 of all on.
- messages: 50 nested objects, decoding: J13 decoder escape blocks off runs at 1.088 of all on.
- string: silesia/dickens, decoding: J7 wide vectors off runs at 1.083 of all on.
- string: silesia/dickens, decoding: J8 decoder fast path off runs at 1.082 of all on.
- string: silesia/dickens, decoding: J13 decoder escape blocks off runs at 1.100 of all on.
- string: silesia/samba, decoding: J7 wide vectors off runs at 1.065 of all on.
- string: silesia/samba, decoding: J8 decoder fast path off runs at 1.066 of all on.
- string: silesia/samba, decoding: J13 decoder escape blocks off runs at 1.066 of all on.
- string: canterbury/alice29.txt, decoding: J7 wide vectors off runs at 1.083 of all on.
- string: canterbury/alice29.txt, decoding: J8 decoder fast path off runs at 1.114 of all on.
- string: canterbury/alice29.txt, decoding: J13 decoder escape blocks off runs at 1.146 of all on.
- string: canterbury/asyoulik.txt, decoding: J7 wide vectors off runs at 1.132 of all on.
- string: canterbury/asyoulik.txt, decoding: J8 decoder fast path off runs at 1.126 of all on.
- string: canterbury/asyoulik.txt, decoding: J12 decoder escape words off runs at 1.059 of all on.
- string: canterbury/asyoulik.txt, decoding: J13 decoder escape blocks off runs at 1.137 of all on.
- string: canterbury/lcet10.txt, decoding: J7 wide vectors off runs at 1.107 of all on.
- string: canterbury/lcet10.txt, decoding: J8 decoder fast path off runs at 1.112 of all on.
- string: canterbury/lcet10.txt, decoding: J13 decoder escape blocks off runs at 1.124 of all on.
- hex: http/js-1kx1024, decoding: J5 UTF-8 vectors off runs at 1.054 of all on.
- hex: http/css-1kx1024, decoding: J5 UTF-8 vectors off runs at 1.055 of all on.
- messages: a tree of 341 objects, encoding: J2 hex vectors off runs at 1.050 of all on.
- messages: a tree of 341 objects, encoding: J5 UTF-8 vectors off runs at 1.069 of all on.
- messages: a tree of 341 objects, encoding: J7 wide vectors off runs at 1.071 of all on.
- messages: a tree of 341 objects, encoding: J9 encoder fast path off runs at 1.072 of all on.
- messages: a tree of 341 objects, encoding: J14 encoder escape blocks off runs at 1.071 of all on.

## UTF-8 validation against simdutf

stdx's `is_utf8`, the check the loops apply to every string's octets, run alone over each string workload's octets at the width the host's features pick (16 lanes on aarch64, AVX2's 32 or AVX-512's 64 on x86-64, decision 39), beside simdutf 9.3.3's `validate_utf8` in the same run; on a host with AVX-512, again with AVX2 alone. Each ratio is stdx's throughput over the other's. simdutf picks its kernel at run time. Before timing, every copy of the check and simdutf judged 20000 seeded buffers and each workload, whole and changed, alike.

| Workload | Octets | stdx, MB/s | simdutf, MB/s | stdx / simdutf | stdx with AVX2 alone, MB/s | stdx / stdx with AVX2 alone |
|---|---|---|---|---|---|---|
| string: silesia/dickens | 166668 | 169706.9 ± 0.3% | 122523.3 ± 0.0% | 1.385 | 101222.0 ± 0.2% | 1.677 |
| string: silesia/nci | 1048576 | 165001.2 ± 0.4% | 123334.0 ± 0.1% | 1.338 | 100849.0 ± 0.1% | 1.636 |
| string: silesia/reymont | 1048576 | 170434.0 ± 0.3% | 123267.9 ± 0.1% | 1.383 | 101689.7 ± 0.2% | 1.676 |
| string: silesia/samba | 65546 | 164618.0 ± 0.1% | 120822.8 ± 0.0% | 1.362 | 99978.1 ± 0.2% | 1.647 |
| string: silesia/webster | 1048576 | 169640.0 ± 0.1% | 123324.2 ± 0.2% | 1.376 | 102152.7 ± 0.2% | 1.661 |
| string: silesia/xml | 1048576 | 169399.2 ± 0.5% | 123257.8 ± 0.6% | 1.374 | 101710.8 ± 0.1% | 1.665 |
| string: canterbury/alice29.txt | 152089 | 168935.4 ± 0.1% | 122380.2 ± 0.1% | 1.380 | 101005.8 ± 0.1% | 1.673 |
| string: canterbury/asyoulik.txt | 125179 | 168540.4 ± 0.2% | 122158.0 ± 0.1% | 1.380 | 101317.7 ± 0.2% | 1.663 |
| string: canterbury/lcet10.txt | 426754 | 170496.8 ± 0.2% | 123226.4 ± 0.1% | 1.384 | 101954.6 ± 0.1% | 1.672 |
| string: canterbury/plrabn12.txt | 481861 | 170565.5 ± 0.1% | 123150.7 ± 0.1% | 1.385 | 102026.7 ± 0.2% | 1.672 |
| string: canterbury-large/E.coli | 1048576 | 170186.5 ± 0.3% | 123241.9 ± 0.1% | 1.381 | 101589.0 ± 0.1% | 1.675 |
| string: canterbury-large/bible.txt | 1048576 | 170495.0 ± 0.3% | 123194.1 ± 0.2% | 1.384 | 102245.4 ± 0.0% | 1.668 |
| string: canterbury-large/world192.txt | 1048576 | 169821.7 ± 0.5% | 123067.4 ± 0.0% | 1.380 | 101399.6 ± 3.9% | 1.675 |
| string: http/html-1m | 1048576 | 148823.3 ± 0.4% | 112766.7 ± 0.3% | 1.320 | 94265.5 ± 4.3% | 1.579 |
| string: http/json-1m | 1048576 | 122349.4 ± 0.3% | 106981.1 ± 0.2% | 1.144 | 82857.9 ± 0.4% | 1.477 |
| string: http/js-1m | 1048576 | 166562.6 ± 0.7% | 122160.2 ± 0.0% | 1.363 | 100440.8 ± 0.6% | 1.658 |
| string: http/css-1m | 1048576 | 169002.2 ± 0.3% | 122729.5 ± 0.1% | 1.377 | 100777.1 ± 4.3% | 1.677 |
| string: dickens as Cyrillic and CJK | 1847045 | 23824.8 ± 2.3% | 20999.6 ± 0.9% | 1.135 | 15032.1 ± 0.2% | 1.585 |

## Losses to simdutf

None.

## UTF-8 validation by the buffer's offset from a 64-octet line

| Buffer | Octets | Offset | stdx, MB/s | simdutf, MB/s | stdx / simdutf | stdx with AVX2 alone, MB/s | stdx / stdx with AVX2 alone |
|---|---|---|---|---|---|---|---|
| string: canterbury-large/bible.txt | 1048576 | 0 | 169535.4 ± 7.9% | 123401.5 ± 0.2% | 1.374 | 102472.0 ± 0.1% | 1.654 |
| string: canterbury-large/bible.txt | 1048576 | 1 | 169913.5 ± 0.3% | 123395.9 ± 0.1% | 1.377 | 101637.7 ± 0.1% | 1.672 |
| string: canterbury-large/bible.txt | 1048576 | 8 | 169490.8 ± 0.1% | 123399.1 ± 0.1% | 1.374 | 101640.2 ± 0.1% | 1.668 |
| string: canterbury-large/bible.txt | 1048576 | 16 | 170177.7 ± 0.2% | 123300.5 ± 0.2% | 1.380 | 101536.4 ± 3.5% | 1.676 |
| string: canterbury-large/bible.txt | 1048576 | 32 | 170127.0 ± 0.1% | 123325.6 ± 0.2% | 1.379 | 101683.1 ± 3.6% | 1.673 |
| string: canterbury-large/bible.txt | 1048576 | 48 | 170027.8 ± 0.1% | 123344.8 ± 0.2% | 1.378 | 102227.4 ± 3.7% | 1.663 |
| string: dickens as Cyrillic and CJK | 1048576 | 0 | 24398.7 ± 0.5% | 21807.6 ± 0.2% | 1.119 | 15408.9 ± 1.4% | 1.583 |
| string: dickens as Cyrillic and CJK | 1048576 | 1 | 24415.7 ± 0.4% | 21793.2 ± 0.2% | 1.120 | 15403.5 ± 1.3% | 1.585 |
| string: dickens as Cyrillic and CJK | 1048576 | 8 | 24416.0 ± 0.2% | 21795.8 ± 0.3% | 1.120 | 15387.2 ± 1.2% | 1.587 |
| string: dickens as Cyrillic and CJK | 1048576 | 16 | 24412.0 ± 0.4% | 21800.8 ± 1.7% | 1.120 | 15414.3 ± 0.2% | 1.584 |
| string: dickens as Cyrillic and CJK | 1048576 | 32 | 24415.1 ± 0.1% | 21794.3 ± 2.0% | 1.120 | 15417.0 ± 0.1% | 1.584 |
| string: dickens as Cyrillic and CJK | 1048576 | 48 | 24413.3 ± 0.2% | 21792.1 ± 1.8% | 1.120 | 15412.7 ± 0.1% | 1.584 |

## Messages against serde_json's typed code

stdx's encoder a token a call through `TextWriter`'s methods, a member's name and its value in one `member_*` call, beside serde_json 1.0.154 writing the same messages from Rust types, as code of the form serde's derive generates writes them. Octets are the ones written.

| Workload | Octets | TextWriter's methods, MB/s | serde_json typed, MB/s | stdx / serde_json typed |
|---|---|---|---|---|
| messages: 11 string members | 1025025 | 1274.8 ± 0.3% | 817.4 ± 0.2% | 1.560 |
| messages: 50 nested objects | 1121600 | 1721.0 ± 0.3% | 891.7 ± 0.5% | 1.930 |
| messages: a tree of 341 objects | 612600 | 500.6 ± 0.1% | 512.3 ± 0.8% | 0.977 |

## Against the baselines

stdx with every claim on, timed beside simdjson 5.1.1, yyjson 0.13.0, Zig 0.16.0's std.json, serde_json 1.0.154 and Go's encoding/json/jsontext in the same run. Each ratio is stdx's throughput over the baseline's; below 1, the baseline is faster. stdx is built for the architecture's baseline CPU in ReleaseSafe. Each baseline is built for the same CPU, the C, C++ and Zig ones in ReleaseFast (decision 75), and simdjson picks its kernel at run time. Decoding visits every value; encoding writes each text from its tokens.

## Decoding against the baselines

Octets are the text's. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1385.1 ± 33.4% | 1534.2 ± 1.6% | 1122.4 ± 0.2% | 390.9 ± 0.7% | 675.3 ± 24.8% | 367.2 ± 65.3% | 0.903 | 1.234 | 3.543 | 2.051 | 3.772 |
| qlog records, JSON text sequence | 1467503 | 1114.9 ± 0.7% | 1254.7 ± 1.3% | 1139.8 ± 1.0% | 330.7 ± 1.4% | 757.2 ± 0.8% | 320.4 ± 0.6% | 0.889 | 0.978 | 3.371 | 1.472 | 3.479 |
| messages: 11 string members | 1025025 | 1078.0 ± 0.2% | 2022.9 ± 0.9% | 721.6 ± 2.7% | 338.6 ± 0.7% | 511.4 ± 2.3% | 302.4 ± 3.0% | 0.533 | 1.494 | 3.184 | 2.108 | 3.565 |
| messages: 50 nested objects | 1121600 | 1346.5 ± 0.1% | 1758.4 ± 0.7% | 1462.0 ± 0.2% | 431.8 ± 0.8% | 907.8 ± 0.8% | 422.0 ± 3.0% | 0.766 | 0.921 | 3.118 | 1.483 | 3.191 |
| messages: a tree of 341 objects | 612600 | 671.5 ± 1.5% | 855.8 ± 1.2% | 703.5 ± 0.8% | 182.5 ± 0.5% | 613.9 ± 0.5% | 209.9 ± 0.7% | 0.785 | 0.954 | 3.679 | 1.094 | 3.198 |
| string: silesia/dickens | 172528 | 6743.1 ± 0.3% | 3426.8 ± 3.0% | 2846.4 ± 0.7% | 318.2 ± 0.4% | 3121.2 ± 1.3% | 573.0 ± 3.1% | 1.968 | 2.369 | 21.188 | 2.160 | 11.767 |
| string: silesia/nci | 1075110 | 5435.8 ± 0.3% | 3938.4 ± 0.2% | 3051.4 ± 0.3% | 649.8 ± 0.4% | 3650.8 ± 0.4% | 579.0 ± 1.4% | 1.380 | 1.781 | 8.366 | 1.489 | 9.388 |
| string: silesia/reymont | 1075159 | 3551.4 ± 3.3% | 3438.5 ± 0.3% | 1963.1 ± 2.4% | 343.5 ± 0.2% | 2105.6 ± 2.8% | 499.1 ± 3.2% | 1.033 | 1.809 | 10.340 | 1.687 | 7.115 |
| string: silesia/samba | 97582 | 3989.9 ± 1.0% | 3796.8 ± 0.5% | 3056.2 ± 5.0% | 327.0 ± 0.6% | 1973.9 ± 1.1% | 421.5 ± 4.1% | 1.051 | 1.306 | 12.202 | 2.021 | 9.466 |
| string: silesia/webster | 1098490 | 4399.6 ± 0.5% | 2453.6 ± 2.3% | 1742.7 ± 0.4% | 310.0 ± 0.5% | 2073.0 ± 0.6% | 471.6 ± 1.6% | 1.793 | 2.525 | 14.193 | 2.122 | 9.329 |
| string: silesia/xml | 1090118 | 6091.1 ± 0.5% | 5086.2 ± 0.2% | 2466.0 ± 0.3% | 510.4 ± 0.8% | 3346.4 ± 0.2% | 551.4 ± 1.6% | 1.198 | 2.470 | 11.935 | 1.820 | 11.046 |
| string: canterbury/alice29.txt | 159425 | 5827.1 ± 1.0% | 2794.3 ± 1.1% | 2814.3 ± 2.1% | 300.7 ± 0.2% | 2787.9 ± 0.9% | 522.6 ± 0.9% | 2.085 | 2.071 | 19.377 | 2.090 | 11.150 |
| string: canterbury/asyoulik.txt | 132198 | 4324.1 ± 0.9% | 2565.9 ± 6.5% | 2787.6 ± 1.3% | 305.4 ± 2.9% | 2421.5 ± 1.0% | 459.1 ± 1.3% | 1.685 | 1.551 | 14.157 | 1.786 | 9.418 |
| string: canterbury/lcet10.txt | 441884 | 6660.0 ± 0.8% | 3287.2 ± 0.5% | 2303.1 ± 1.4% | 346.9 ± 2.0% | 2804.3 ± 0.4% | 573.9 ± 0.4% | 2.026 | 2.892 | 19.197 | 2.375 | 11.604 |
| string: canterbury/plrabn12.txt | 503330 | 5498.0 ± 0.2% | 3174.5 ± 0.7% | 1846.7 ± 0.6% | 323.7 ± 0.2% | 2846.4 ± 2.4% | 533.9 ± 1.1% | 1.732 | 2.977 | 16.987 | 1.932 | 10.297 |
| string: canterbury-large/E.coli | 1048578 | 29020.4 ± 0.2% | 13699.7 ± 0.1% | 3450.3 ± 0.1% | 1287.7 ± 0.2% | 8949.5 ± 0.2% | 975.7 ± 0.7% | 2.118 | 8.411 | 22.537 | 3.243 | 29.743 |
| string: canterbury-large/bible.txt | 1055886 | 8612.5 ± 2.4% | 5294.5 ± 0.3% | 2831.6 ± 0.1% | 358.3 ± 0.4% | 3907.2 ± 0.3% | 641.3 ± 1.9% | 1.627 | 3.042 | 24.037 | 2.204 | 13.429 |
| string: canterbury-large/world192.txt | 1103121 | 4169.0 ± 1.1% | 2321.3 ± 0.3% | 1770.0 ± 0.4% | 328.4 ± 0.3% | 2129.5 ± 0.6% | 468.9 ± 1.9% | 1.796 | 2.355 | 12.693 | 1.958 | 8.891 |
| string: http/html-1m | 1058582 | 9095.3 ± 2.6% | 4745.7 ± 3.0% | 2739.8 ± 3.5% | 427.6 ± 0.2% | 3666.7 ± 0.3% | 609.7 ± 1.8% | 1.917 | 3.320 | 21.269 | 2.481 | 14.917 |
| string: http/json-1m | 1190272 | 3324.9 ± 0.3% | 1260.7 ± 0.7% | 2107.8 ± 0.1% | 477.5 ± 0.6% | 1345.0 ± 0.3% | 442.0 ± 3.0% | 2.637 | 1.577 | 6.964 | 2.472 | 7.522 |
| string: http/js-1m | 1144362 | 2848.2 ± 0.6% | 1618.1 ± 0.9% | 1335.3 ± 0.9% | 326.9 ± 0.3% | 1431.0 ± 0.4% | 383.2 ± 2.0% | 1.760 | 2.133 | 8.714 | 1.990 | 7.432 |
| string: http/css-1m | 1097820 | 3316.8 ± 0.3% | 2899.1 ± 0.3% | 2291.0 ± 4.5% | 453.9 ± 0.2% | 2075.7 ± 0.5% | 446.1 ± 1.3% | 1.144 | 1.448 | 7.307 | 1.598 | 7.434 |
| string: dickens as Cyrillic and CJK | 1883069 | 5851.0 ± 0.5% | 2925.6 ± 3.6% | 665.0 ± 0.5% | 380.3 ± 0.3% | 515.0 ± 0.4% | 165.0 ± 3.8% | 2.000 | 8.798 | 15.385 | 11.362 | 35.467 |
| string: dickens as Cyrillic and CJK, as \u escapes | 5075485 | 1208.5 ± 0.7% | 1250.2 ± 1.5% | 1108.3 ± 0.7% | 264.2 ± 0.5% | 481.3 ± 0.5% | 232.0 ± 4.8% | 0.967 | 1.090 | 4.575 | 2.511 | 5.210 |
| hex: silesia/dickens | 524290 | 46222.1 ± 0.1% | 15127.6 ± 0.2% | 3567.9 ± 0.8% | 478.4 ± 2.3% | 8963.6 ± 0.2% | 1146.4 ± 2.2% | 3.055 | 12.955 | 96.621 | 5.157 | 40.321 |
| hex: silesia/mozilla | 524290 | 36838.4 ± 0.1% | 15129.3 ± 0.2% | 3506.6 ± 0.3% | 432.4 ± 0.2% | 8945.4 ± 0.3% | 1144.2 ± 0.3% | 2.435 | 10.505 | 85.201 | 4.118 | 32.196 |
| hex: silesia/mr | 524290 | 45189.9 ± 0.3% | 15123.8 ± 0.1% | 3511.0 ± 3.4% | 648.1 ± 0.1% | 8948.1 ± 0.2% | 1146.0 ± 0.2% | 2.988 | 12.871 | 69.727 | 5.050 | 39.433 |
| hex: silesia/nci | 524290 | 46067.0 ± 0.4% | 15129.8 ± 1.3% | 3576.1 ± 0.1% | 805.4 ± 3.6% | 8958.6 ± 0.2% | 1146.6 ± 0.2% | 3.045 | 12.882 | 57.201 | 5.142 | 40.179 |
| hex: silesia/ooffice | 524290 | 46853.0 ± 0.4% | 15128.8 ± 0.2% | 3509.0 ± 0.1% | 347.0 ± 0.6% | 8946.8 ± 0.2% | 1147.5 ± 0.3% | 3.097 | 13.352 | 135.021 | 5.237 | 40.832 |
| hex: silesia/osdb | 524290 | 45464.3 ± 0.2% | 15125.5 ± 0.1% | 3511.4 ± 0.5% | 457.8 ± 0.7% | 8946.9 ± 0.6% | 1147.0 ± 1.1% | 3.006 | 12.948 | 99.311 | 5.082 | 39.636 |
| hex: silesia/reymont | 524290 | 46187.4 ± 0.3% | 15128.6 ± 0.9% | 3579.0 ± 0.1% | 500.1 ± 2.0% | 8957.2 ± 0.6% | 1147.1 ± 0.2% | 3.053 | 12.905 | 92.348 | 5.156 | 40.265 |
| hex: silesia/samba | 524290 | 33944.5 ± 0.1% | 15118.6 ± 0.2% | 3510.1 ± 0.1% | 369.6 ± 2.5% | 8946.9 ± 0.3% | 1146.6 ± 0.2% | 2.245 | 9.671 | 91.842 | 3.794 | 29.604 |
| hex: silesia/sao | 524290 | 47998.2 ± 0.2% | 15104.2 ± 2.6% | 3508.7 ± 0.2% | 280.7 ± 0.5% | 8949.7 ± 0.5% | 1147.3 ± 3.7% | 3.178 | 13.680 | 170.973 | 5.363 | 41.836 |
| hex: silesia/webster | 524290 | 46254.1 ± 0.1% | 15117.2 ± 0.1% | 3573.3 ± 0.1% | 454.8 ± 0.3% | 8968.7 ± 0.2% | 1146.6 ± 0.2% | 3.060 | 12.944 | 101.712 | 5.157 | 40.340 |
| hex: silesia/x-ray | 524290 | 46989.5 ± 0.2% | 15134.0 ± 0.1% | 3494.4 ± 0.1% | 427.5 ± 0.3% | 8954.2 ± 0.6% | 1143.0 ± 1.0% | 3.105 | 13.447 | 109.929 | 5.248 | 41.110 |
| hex: silesia/xml | 524290 | 47079.3 ± 0.0% | 15127.3 ± 0.2% | 3575.9 ± 3.2% | 728.4 ± 0.3% | 8947.3 ± 0.1% | 1143.5 ± 0.6% | 3.112 | 13.166 | 64.637 | 5.262 | 41.170 |
| hex: canterbury/alice29.txt | 304180 | 46570.8 ± 0.2% | 14184.0 ± 0.1% | 3577.6 ± 0.1% | 484.3 ± 0.6% | 8964.5 ± 0.5% | 1155.6 ± 0.3% | 3.283 | 13.017 | 96.156 | 5.195 | 40.298 |
| hex: canterbury/asyoulik.txt | 250360 | 46182.4 ± 0.2% | 15006.5 ± 1.1% | 3513.1 ± 0.2% | 470.8 ± 0.5% | 8941.2 ± 0.3% | 1152.8 ± 4.5% | 3.077 | 13.146 | 98.088 | 5.165 | 40.061 |
| hex: canterbury/cp.html | 49208 | 45169.4 ± 0.2% | 14503.0 ± 0.1% | 3581.2 ± 4.3% | 512.1 ± 0.7% | 9292.5 ± 0.1% | 1137.1 ± 3.5% | 3.114 | 12.613 | 88.201 | 4.861 | 39.724 |
| hex: canterbury/fields.c | 22302 | 50265.6 ± 0.3% | 17752.9 ± 0.4% | 3684.9 ± 0.4% | 570.7 ± 0.8% | 9281.4 ± 0.5% | 1101.9 ± 1.6% | 2.831 | 13.641 | 88.081 | 5.416 | 45.617 |
| hex: canterbury/grammar.lsp | 7444 | 44236.7 ± 0.5% | 17316.3 ± 1.6% | 3639.5 ± 2.3% | 744.7 ± 0.9% | 8981.6 ± 0.1% | 1079.5 ± 1.7% | 2.555 | 12.155 | 59.401 | 4.925 | 40.977 |
| hex: canterbury/kennedy.xls | 524290 | 46497.3 ± 0.3% | 15132.7 ± 0.1% | 3579.7 ± 0.3% | 759.0 ± 0.9% | 8942.5 ± 0.9% | 1130.8 ± 5.0% | 3.073 | 12.989 | 61.260 | 5.200 | 41.118 |
| hex: canterbury/lcet10.txt | 524290 | 49302.1 ± 0.2% | 15123.2 ± 0.3% | 3557.1 ± 0.1% | 484.0 ± 0.1% | 8941.4 ± 0.3% | 1143.8 ± 1.3% | 3.260 | 13.860 | 101.858 | 5.514 | 43.105 |
| hex: canterbury/plrabn12.txt | 524290 | 46192.6 ± 0.3% | 15133.9 ± 0.1% | 3564.6 ± 0.4% | 466.6 ± 0.3% | 8950.0 ± 0.7% | 1144.4 ± 0.7% | 3.052 | 12.959 | 99.009 | 5.161 | 40.364 |
| hex: canterbury/ptt5 | 524290 | 46763.8 ± 0.3% | 15125.6 ± 0.1% | 3510.8 ± 0.1% | 667.0 ± 0.2% | 8930.4 ± 0.1% | 1146.9 ± 1.4% | 3.092 | 13.320 | 70.106 | 5.236 | 40.775 |
| hex: canterbury/sum | 76482 | 47674.2 ± 0.4% | 15502.2 ± 0.1% | 3579.8 ± 0.2% | 587.5 ± 0.4% | 8959.1 ± 0.2% | 1124.2 ± 4.1% | 3.075 | 13.318 | 81.143 | 5.321 | 42.406 |
| hex: canterbury/xargs.1 | 8456 | 45285.7 ± 0.5% | 17471.0 ± 0.2% | 3577.7 ± 0.1% | 729.2 ± 1.4% | 9014.1 ± 0.2% | 1116.4 ± 1.5% | 2.592 | 12.658 | 62.100 | 5.024 | 40.562 |
| hex: canterbury-large/E.coli | 524290 | 47936.2 ± 0.5% | 14444.5 ± 0.2% | 3514.2 ± 0.1% | 966.6 ± 0.1% | 8950.7 ± 0.2% | 1131.9 ± 8.2% | 3.319 | 13.641 | 49.595 | 5.356 | 42.351 |
| hex: canterbury-large/bible.txt | 524290 | 46777.4 ± 0.2% | 14431.8 ± 0.1% | 3515.0 ± 0.1% | 500.9 ± 0.4% | 8946.0 ± 0.3% | 1162.7 ± 1.0% | 3.241 | 13.308 | 93.381 | 5.229 | 40.232 |
| hex: canterbury-large/world192.txt | 524290 | 44900.8 ± 0.6% | 14441.4 ± 0.0% | 3584.8 ± 0.1% | 468.9 ± 0.5% | 8964.0 ± 0.2% | 1162.6 ± 4.2% | 3.109 | 12.525 | 95.763 | 5.009 | 38.620 |
| hex: http/html-1kx1024 | 2099200 | 18152.3 ± 1.0% | 12211.9 ± 0.2% | 3230.9 ± 0.2% | 507.0 ± 0.3% | 7405.5 ± 0.6% | 1006.7 ± 1.9% | 1.486 | 5.618 | 35.805 | 2.451 | 18.031 |
| hex: http/html-16kx64 | 2097280 | 33739.1 ± 0.4% | 14075.2 ± 0.3% | 3427.5 ± 0.1% | 514.5 ± 0.4% | 8464.9 ± 1.1% | 1105.9 ± 2.7% | 2.397 | 9.844 | 65.574 | 3.986 | 30.510 |
| hex: http/html-1m | 524290 | 46809.8 ± 0.4% | 15121.1 ± 0.4% | 3509.1 ± 0.3% | 509.0 ± 0.6% | 8942.5 ± 0.2% | 1159.7 ± 2.9% | 3.096 | 13.340 | 91.964 | 5.235 | 40.363 |
| hex: http/json-1kx1024 | 2099200 | 18164.4 ± 2.3% | 12265.8 ± 12.5% | 3226.8 ± 2.8% | 672.1 ± 2.4% | 7401.5 ± 2.1% | 1018.0 ± 1.0% | 1.481 | 5.629 | 27.027 | 2.454 | 17.844 |
| hex: http/json-16kx64 | 2097280 | 35820.8 ± 0.4% | 14047.5 ± 0.2% | 3432.1 ± 0.2% | 687.6 ± 0.8% | 8592.0 ± 1.1% | 1120.0 ± 1.9% | 2.550 | 10.437 | 52.099 | 4.169 | 31.984 |
| hex: http/json-1m | 524290 | 47962.8 ± 0.1% | 15147.3 ± 0.0% | 3584.9 ± 0.1% | 701.4 ± 0.6% | 8960.0 ± 0.1% | 1158.7 ± 1.0% | 3.166 | 13.379 | 68.377 | 5.353 | 41.395 |
| hex: http/js-1kx1024 | 2099200 | 18088.3 ± 2.7% | 12143.4 ± 5.8% | 3225.2 ± 0.4% | 489.5 ± 0.6% | 7451.9 ± 0.9% | 1019.3 ± 0.7% | 1.490 | 5.608 | 36.955 | 2.427 | 17.745 |
| hex: http/js-16kx64 | 2097280 | 34931.8 ± 0.7% | 14023.0 ± 0.2% | 3422.9 ± 0.0% | 496.7 ± 0.5% | 8754.3 ± 0.4% | 1117.3 ± 0.6% | 2.491 | 10.205 | 70.321 | 3.990 | 31.264 |
| hex: http/js-1m | 524290 | 46201.6 ± 1.9% | 15149.3 ± 0.2% | 3558.7 ± 0.2% | 515.1 ± 0.4% | 8961.6 ± 0.4% | 1158.5 ± 1.7% | 3.050 | 12.983 | 89.702 | 5.156 | 39.880 |
| hex: http/css-1kx1024 | 2099200 | 18058.3 ± 3.5% | 12012.1 ± 0.3% | 3228.1 ± 0.3% | 572.1 ± 4.0% | 7410.0 ± 0.6% | 1013.6 ± 1.4% | 1.503 | 5.594 | 31.564 | 2.437 | 17.815 |
| hex: http/css-16kx64 | 2097280 | 35881.9 ± 0.2% | 14045.1 ± 0.3% | 3432.5 ± 3.2% | 583.3 ± 0.8% | 8652.6 ± 1.0% | 1102.4 ± 2.4% | 2.555 | 10.454 | 61.518 | 4.147 | 32.550 |
| hex: http/css-1m | 524290 | 46672.3 ± 0.6% | 15113.2 ± 2.6% | 3578.0 ± 0.1% | 561.8 ± 0.6% | 8946.7 ± 5.2% | 1114.6 ± 3.0% | 3.088 | 13.044 | 83.078 | 5.217 | 41.873 |
| hex: shuffled/dickens-1m | 524290 | 46007.6 ± 2.1% | 15122.7 ± 0.2% | 3504.1 ± 0.4% | 478.4 ± 0.6% | 8948.2 ± 0.1% | 1104.1 ± 4.0% | 3.042 | 13.130 | 96.176 | 5.142 | 41.668 |

## Encoding against the baselines

Octets are the ones stdx writes. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1764.8 ± 0.6% | 1483.2 ± 0.3% | 1033.5 ± 0.2% | 465.0 ± 0.4% | 441.4 ± 1.0% | 505.8 ± 0.6% | 1.190 | 1.708 | 3.795 | 3.998 | 3.489 |
| qlog records, JSON text sequence | 1467503 | 1699.4 ± 0.6% | 1242.5 ± 1.6% | 953.6 ± 3.2% | 429.1 ± 4.3% | 539.7 ± 0.7% | 355.2 ± 0.6% | 1.368 | 1.782 | 3.961 | 3.149 | 4.784 |
| messages: 11 string members | 1025025 | 1338.3 ± 0.5% | 1117.1 ± 3.7% | 779.0 ± 0.3% | 413.0 ± 1.3% | 421.4 ± 0.7% | 436.5 ± 0.3% | 1.198 | 1.718 | 3.241 | 3.176 | 3.066 |
| messages: 50 nested objects | 1121600 | 2013.2 ± 5.7% | 1893.5 ± 1.1% | 1356.0 ± 0.5% | 596.0 ± 0.8% | 612.7 ± 1.0% | 511.8 ± 0.8% | 1.063 | 1.485 | 3.378 | 3.286 | 3.934 |
| messages: a tree of 341 objects | 612600 | 603.5 ± 2.8% | 689.5 ± 1.5% | 582.4 ± 0.5% | 334.5 ± 0.7% | 356.2 ± 0.8% | 223.1 ± 1.6% | 0.875 | 1.036 | 1.804 | 1.694 | 2.705 |
| string: silesia/dickens | 172528 | 13077.3 ± 0.8% | 3958.9 ± 1.3% | 3100.7 ± 2.2% | 335.1 ± 0.8% | 1535.2 ± 2.2% | 1189.6 ± 0.6% | 3.303 | 4.218 | 39.028 | 8.518 | 10.993 |
| string: silesia/nci | 1075110 | 11307.7 ± 0.4% | 4757.6 ± 0.8% | 3136.0 ± 0.4% | 915.6 ± 0.6% | 1597.4 ± 0.9% | 1210.3 ± 1.8% | 2.377 | 3.606 | 12.349 | 7.079 | 9.343 |
| string: silesia/reymont | 1075159 | 5302.1 ± 2.5% | 1880.2 ± 0.9% | 1896.8 ± 0.2% | 379.0 ± 0.8% | 1307.8 ± 1.0% | 1050.7 ± 1.1% | 2.820 | 2.795 | 13.988 | 4.054 | 5.046 |
| string: silesia/samba | 97582 | 6357.4 ± 0.4% | 2722.1 ± 0.3% | 4085.1 ± 0.2% | 350.6 ± 0.4% | 1277.0 ± 1.1% | 1180.6 ± 0.4% | 2.335 | 1.556 | 18.131 | 4.978 | 5.385 |
| string: silesia/webster | 1098490 | 7112.1 ± 0.7% | 1996.8 ± 0.4% | 1774.8 ± 0.9% | 353.9 ± 0.8% | 1274.0 ± 1.9% | 613.3 ± 0.5% | 3.562 | 4.007 | 20.094 | 5.582 | 11.597 |
| string: silesia/xml | 1090118 | 10711.6 ± 0.5% | 3224.8 ± 0.5% | 2533.5 ± 0.2% | 608.7 ± 0.8% | 1725.8 ± 0.5% | 987.4 ± 3.8% | 3.322 | 4.228 | 17.597 | 6.207 | 10.848 |
| string: canterbury/alice29.txt | 159425 | 12764.1 ± 1.4% | 2898.0 ± 1.2% | 3032.1 ± 5.4% | 320.0 ± 1.0% | 1372.0 ± 1.2% | 1100.2 ± 0.7% | 4.404 | 4.210 | 39.884 | 9.303 | 11.602 |
| string: canterbury/asyoulik.txt | 132198 | 11108.7 ± 2.1% | 2119.2 ± 0.4% | 3133.2 ± 0.7% | 317.9 ± 0.7% | 1246.2 ± 1.0% | 961.6 ± 4.0% | 5.242 | 3.546 | 34.947 | 8.914 | 11.552 |
| string: canterbury/lcet10.txt | 441884 | 12738.6 ± 2.0% | 3100.8 ± 0.9% | 2599.4 ± 0.6% | 370.3 ± 1.0% | 1489.1 ± 1.4% | 1201.9 ± 0.5% | 4.108 | 4.901 | 34.399 | 8.555 | 10.598 |
| string: canterbury/plrabn12.txt | 503330 | 8874.2 ± 0.5% | 2326.6 ± 0.3% | 2107.9 ± 1.8% | 351.1 ± 1.1% | 1373.3 ± 2.5% | 1126.5 ± 1.2% | 3.814 | 4.210 | 25.279 | 6.462 | 7.878 |
| string: canterbury-large/E.coli | 1048578 | 31868.4 ± 1.0% | 16417.2 ± 1.2% | 3504.0 ± 0.1% | 1702.9 ± 0.2% | 3162.8 ± 0.4% | 1425.6 ± 0.2% | 1.941 | 9.095 | 18.714 | 10.076 | 22.354 |
| string: canterbury-large/bible.txt | 1055886 | 9710.3 ± 0.5% | 4943.3 ± 0.3% | 3021.3 ± 0.2% | 408.3 ± 0.8% | 2033.8 ± 0.2% | 1503.0 ± 0.2% | 1.964 | 3.214 | 23.780 | 4.775 | 6.461 |
| string: canterbury-large/world192.txt | 1103121 | 6712.7 ± 1.6% | 1750.1 ± 0.1% | 1890.4 ± 1.3% | 349.7 ± 0.7% | 1278.7 ± 0.8% | 973.9 ± 0.6% | 3.836 | 3.551 | 19.194 | 5.249 | 6.892 |
| string: http/html-1m | 1058582 | 10235.3 ± 0.4% | 4351.7 ± 0.5% | 2895.9 ± 1.1% | 423.1 ± 0.4% | 2026.9 ± 0.4% | 858.5 ± 0.4% | 2.352 | 3.534 | 24.189 | 5.050 | 11.923 |
| string: http/json-1m | 1190272 | 8427.7 ± 0.3% | 1605.9 ± 0.5% | 1590.3 ± 0.1% | 561.1 ± 0.4% | 1023.9 ± 0.7% | 849.9 ± 0.8% | 5.248 | 5.300 | 15.020 | 8.231 | 9.916 |
| string: http/js-1m | 1144362 | 6597.2 ± 1.4% | 1136.0 ± 0.3% | 1393.3 ± 0.2% | 333.3 ± 0.4% | 1039.3 ± 1.5% | 765.8 ± 0.7% | 5.807 | 4.735 | 19.792 | 6.348 | 8.615 |
| string: http/css-1m | 1097820 | 9242.7 ± 0.4% | 1497.0 ± 1.4% | 2308.8 ± 1.6% | 511.8 ± 0.1% | 1135.1 ± 0.7% | 887.4 ± 4.1% | 6.174 | 4.003 | 18.058 | 8.143 | 10.416 |
| string: dickens as Cyrillic and CJK | 1883069 | 5519.2 ± 0.3% | 3660.2 ± 0.4% | 491.6 ± 0.2% | 247.8 ± 0.5% | 458.5 ± 0.7% | 359.9 ± 0.4% | 1.508 | 11.227 | 22.271 | 12.039 | 15.337 |
| hex: silesia/dickens | 524290 | 42655.7 ± 0.6% | 2615.8 ± 8.9% | 1512.8 ± 0.1% | 462.4 ± 0.1% | 1522.7 ± 0.5% | 1075.8 ± 0.3% | 16.307 | 28.197 | 92.245 | 28.014 | 39.652 |
| hex: silesia/mozilla | 524290 | 43862.4 ± 0.1% | 2604.5 ± 0.2% | 1511.0 ± 0.1% | 385.0 ± 1.5% | 1514.6 ± 0.4% | 1074.9 ± 0.1% | 16.841 | 29.029 | 113.914 | 28.959 | 40.805 |
| hex: silesia/mr | 524290 | 43865.4 ± 0.0% | 2601.8 ± 0.1% | 1511.4 ± 0.1% | 595.7 ± 0.2% | 1512.6 ± 0.6% | 1075.1 ± 0.1% | 16.859 | 29.023 | 73.639 | 29.001 | 40.800 |
| hex: silesia/nci | 524290 | 43862.2 ± 3.0% | 2592.5 ± 0.1% | 1508.8 ± 0.1% | 749.7 ± 0.1% | 1506.7 ± 1.1% | 1075.9 ± 0.2% | 16.919 | 29.071 | 58.506 | 29.111 | 40.769 |
| hex: silesia/ooffice | 524290 | 43851.4 ± 0.1% | 2620.3 ± 0.2% | 1518.9 ± 1.1% | 314.8 ± 4.1% | 1516.2 ± 0.9% | 1076.1 ± 0.4% | 16.735 | 28.870 | 139.282 | 28.921 | 40.749 |
| hex: silesia/osdb | 524290 | 42257.4 ± 0.2% | 2608.7 ± 0.6% | 1513.5 ± 0.3% | 431.8 ± 0.2% | 1571.3 ± 0.4% | 1074.9 ± 0.2% | 16.198 | 27.920 | 97.863 | 26.893 | 39.313 |
| hex: silesia/reymont | 524290 | 42548.4 ± 4.0% | 2608.6 ± 0.1% | 1516.7 ± 0.1% | 482.9 ± 0.2% | 1521.3 ± 0.5% | 1075.0 ± 0.2% | 16.311 | 28.053 | 88.110 | 27.968 | 39.579 |
| hex: silesia/samba | 524290 | 43912.1 ± 0.3% | 2606.1 ± 0.2% | 1513.5 ± 0.2% | 339.6 ± 1.2% | 1571.2 ± 1.3% | 1072.0 ± 5.9% | 16.849 | 29.014 | 129.310 | 27.948 | 40.961 |
| hex: silesia/sao | 524290 | 43889.6 ± 0.1% | 2621.2 ± 0.1% | 1516.9 ± 0.3% | 272.1 ± 5.7% | 1524.1 ± 5.1% | 1074.5 ± 5.9% | 16.744 | 28.934 | 161.297 | 28.796 | 40.848 |
| hex: silesia/webster | 524290 | 44182.4 ± 0.0% | 2612.5 ± 0.6% | 1515.6 ± 0.1% | 437.5 ± 3.5% | 1565.1 ± 4.9% | 1072.8 ± 0.4% | 16.912 | 29.152 | 100.989 | 28.229 | 41.185 |
| hex: silesia/x-ray | 524290 | 43918.9 ± 0.1% | 2617.1 ± 0.3% | 1516.8 ± 4.4% | 420.1 ± 3.1% | 1525.4 ± 0.4% | 1075.9 ± 0.1% | 16.782 | 28.955 | 104.545 | 28.791 | 40.821 |
| hex: silesia/xml | 524290 | 43846.5 ± 0.2% | 2614.3 ± 0.2% | 1514.0 ± 4.4% | 693.6 ± 0.2% | 1571.8 ± 0.2% | 1074.5 ± 0.1% | 16.772 | 28.961 | 63.211 | 27.895 | 40.808 |
| hex: canterbury/alice29.txt | 304180 | 41969.9 ± 6.5% | 2625.4 ± 0.2% | 1529.5 ± 0.2% | 470.7 ± 0.1% | 1562.8 ± 0.3% | 1091.3 ± 0.1% | 15.986 | 27.440 | 89.171 | 26.855 | 38.460 |
| hex: canterbury/asyoulik.txt | 250360 | 43772.2 ± 8.1% | 2630.6 ± 0.1% | 1545.4 ± 0.1% | 459.3 ± 0.2% | 1566.5 ± 0.5% | 1092.9 ± 0.2% | 16.640 | 28.324 | 95.310 | 27.942 | 40.052 |
| hex: canterbury/cp.html | 49208 | 42790.1 ± 0.1% | 2598.7 ± 0.4% | 1530.2 ± 6.0% | 482.5 ± 0.5% | 1594.9 ± 0.1% | 1096.7 ± 0.3% | 16.466 | 27.963 | 88.687 | 26.830 | 39.017 |
| hex: canterbury/fields.c | 22302 | 42280.8 ± 0.1% | 2654.4 ± 0.4% | 1538.7 ± 7.0% | 604.9 ± 0.6% | 1612.9 ± 0.1% | 1103.7 ± 0.1% | 15.928 | 27.478 | 69.900 | 26.214 | 38.309 |
| hex: canterbury/grammar.lsp | 7444 | 39463.7 ± 0.5% | 2715.2 ± 0.3% | 1546.7 ± 0.1% | 816.8 ± 0.5% | 1617.5 ± 0.1% | 1112.8 ± 0.4% | 14.534 | 25.514 | 48.314 | 24.398 | 35.462 |
| hex: canterbury/kennedy.xls | 524290 | 43842.2 ± 0.6% | 2605.5 ± 0.1% | 1513.8 ± 0.0% | 793.1 ± 0.2% | 1563.9 ± 6.1% | 1070.1 ± 0.4% | 16.827 | 28.962 | 55.279 | 28.034 | 40.971 |
| hex: canterbury/lcet10.txt | 524290 | 43813.9 ± 0.1% | 2608.9 ± 0.5% | 1514.6 ± 0.3% | 469.2 ± 1.3% | 1566.4 ± 3.9% | 1072.6 ± 0.2% | 16.794 | 28.928 | 93.376 | 27.971 | 40.847 |
| hex: canterbury/plrabn12.txt | 524290 | 43885.1 ± 0.2% | 2614.2 ± 0.1% | 1515.4 ± 4.0% | 456.5 ± 1.9% | 1567.7 ± 2.7% | 1069.7 ± 0.6% | 16.787 | 28.960 | 96.142 | 27.993 | 41.024 |
| hex: canterbury/ptt5 | 524290 | 43901.5 ± 0.2% | 2596.7 ± 0.3% | 1510.1 ± 3.9% | 596.3 ± 4.4% | 1556.0 ± 1.4% | 1072.7 ± 0.0% | 16.906 | 29.072 | 73.619 | 28.215 | 40.927 |
| hex: canterbury/sum | 76482 | 43166.2 ± 0.1% | 2614.6 ± 0.1% | 1525.7 ± 0.1% | 564.1 ± 0.5% | 1586.5 ± 0.1% | 1093.4 ± 4.9% | 16.510 | 28.292 | 76.527 | 27.208 | 39.478 |
| hex: canterbury/xargs.1 | 8456 | 40321.3 ± 0.1% | 2696.2 ± 7.2% | 1548.3 ± 0.3% | 843.0 ± 0.3% | 1617.0 ± 0.5% | 1115.1 ± 0.5% | 14.955 | 26.042 | 47.828 | 24.936 | 36.159 |
| hex: canterbury-large/E.coli | 524290 | 42025.0 ± 0.1% | 2606.0 ± 0.3% | 1513.5 ± 0.2% | 820.1 ± 0.1% | 1571.9 ± 0.3% | 1073.1 ± 0.2% | 16.126 | 27.767 | 51.245 | 26.735 | 39.161 |
| hex: canterbury-large/bible.txt | 524290 | 43923.7 ± 0.2% | 2614.3 ± 7.8% | 1516.8 ± 4.6% | 483.8 ± 0.2% | 1555.7 ± 1.6% | 1073.4 ± 0.4% | 16.802 | 28.959 | 90.780 | 28.234 | 40.918 |
| hex: canterbury-large/world192.txt | 524290 | 43592.6 ± 0.1% | 2612.9 ± 0.1% | 1516.5 ± 0.3% | 461.7 ± 0.4% | 1570.2 ± 1.1% | 1072.6 ± 0.1% | 16.684 | 28.746 | 94.419 | 27.762 | 40.644 |
| hex: http/html-1kx1024 | 2099200 | 21094.1 ± 0.2% | 2377.9 ± 1.2% | 1464.8 ± 3.9% | 502.9 ± 0.1% | 1507.4 ± 0.9% | 1083.2 ± 0.1% | 8.871 | 14.400 | 41.946 | 13.993 | 19.474 |
| hex: http/html-16kx64 | 2097280 | 22740.1 ± 0.3% | 2139.4 ± 5.6% | 1457.1 ± 0.3% | 506.6 ± 0.2% | 1458.2 ± 0.2% | 1090.7 ± 0.2% | 10.629 | 15.606 | 44.884 | 15.595 | 20.850 |
| hex: http/html-1m | 524290 | 43891.6 ± 0.1% | 2612.0 ± 0.4% | 1516.9 ± 0.2% | 488.8 ± 0.1% | 1533.7 ± 0.9% | 1070.4 ± 0.2% | 16.804 | 28.935 | 89.793 | 28.618 | 41.007 |
| hex: http/json-1kx1024 | 2099200 | 21824.2 ± 0.5% | 2341.2 ± 0.6% | 1459.6 ± 0.6% | 699.6 ± 0.2% | 1500.1 ± 0.8% | 1083.4 ± 0.1% | 9.322 | 14.952 | 31.194 | 14.549 | 20.144 |
| hex: http/json-16kx64 | 2097280 | 22524.4 ± 0.5% | 2224.1 ± 0.1% | 1451.2 ± 0.1% | 708.9 ± 0.2% | 1452.8 ± 0.1% | 1086.5 ± 0.4% | 10.128 | 15.521 | 31.773 | 15.504 | 20.732 |
| hex: http/json-1m | 524290 | 43701.4 ± 0.1% | 2605.9 ± 0.4% | 1513.0 ± 0.1% | 738.8 ± 0.7% | 1570.0 ± 0.4% | 1075.1 ± 0.2% | 16.770 | 28.884 | 59.153 | 27.836 | 40.650 |
| hex: http/js-1kx1024 | 2099200 | 20395.2 ± 0.0% | 2343.6 ± 0.9% | 1460.7 ± 0.4% | 492.7 ± 0.3% | 1503.9 ± 0.8% | 1084.0 ± 0.3% | 8.702 | 13.962 | 41.396 | 13.561 | 18.814 |
| hex: http/js-16kx64 | 2097280 | 22374.0 ± 0.4% | 2236.3 ± 0.3% | 1457.2 ± 0.1% | 494.7 ± 0.2% | 1456.2 ± 0.1% | 1091.2 ± 0.2% | 10.005 | 15.354 | 45.231 | 15.364 | 20.505 |
| hex: http/js-1m | 524290 | 43854.6 ± 4.0% | 2607.3 ± 0.2% | 1517.1 ± 0.2% | 509.7 ± 0.1% | 1568.4 ± 0.7% | 1070.5 ± 0.1% | 16.820 | 28.908 | 86.044 | 27.961 | 40.968 |
| hex: http/css-1kx1024 | 2099200 | 22405.8 ± 0.2% | 2389.8 ± 2.7% | 1466.6 ± 0.5% | 559.5 ± 0.3% | 1521.0 ± 0.9% | 1082.9 ± 1.9% | 9.376 | 15.277 | 40.049 | 14.731 | 20.690 |
| hex: http/css-16kx64 | 2097280 | 22010.6 ± 0.3% | 2238.0 ± 0.3% | 1457.6 ± 0.0% | 566.7 ± 0.1% | 1458.8 ± 0.1% | 1090.8 ± 0.0% | 9.835 | 15.101 | 38.837 | 15.088 | 20.179 |
| hex: http/css-1m | 524290 | 43582.6 ± 7.6% | 2615.5 ± 0.2% | 1515.0 ± 0.2% | 535.4 ± 0.4% | 1519.9 ± 0.7% | 1074.7 ± 3.2% | 16.663 | 28.768 | 81.407 | 28.675 | 40.552 |
| hex: shuffled/dickens-1m | 524290 | 42660.5 ± 0.4% | 2605.4 ± 0.3% | 1515.6 ± 0.1% | 464.8 ± 0.1% | 1569.7 ± 0.6% | 1075.9 ± 0.3% | 16.374 | 28.148 | 91.786 | 27.177 | 39.650 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1811.6 ± 0.2% | 1483.2 ± 0.3% | 1033.5 ± 0.2% | 465.0 ± 0.4% | 441.4 ± 1.0% | 505.8 ± 0.6% | 1.221 | 1.753 | 3.896 | 4.104 | 3.581 |
| qlog records, JSON text sequence | 1467503 | 1735.2 ± 0.4% | 1242.5 ± 1.6% | 953.6 ± 3.2% | 429.1 ± 4.3% | 539.7 ± 0.7% | 355.2 ± 0.6% | 1.397 | 1.820 | 4.044 | 3.215 | 4.885 |
| messages: 11 string members | 1025025 | 1335.7 ± 0.1% | 1117.1 ± 3.7% | 779.0 ± 0.3% | 413.0 ± 1.3% | 421.4 ± 0.7% | 436.5 ± 0.3% | 1.196 | 1.715 | 3.234 | 3.170 | 3.060 |
| messages: 50 nested objects | 1121600 | 2023.2 ± 0.5% | 1893.5 ± 1.1% | 1356.0 ± 0.5% | 596.0 ± 0.8% | 612.7 ± 1.0% | 511.8 ± 0.8% | 1.069 | 1.492 | 3.395 | 3.302 | 3.953 |
| messages: a tree of 341 objects | 612600 | 651.4 ± 0.6% | 689.5 ± 1.5% | 582.4 ± 0.5% | 334.5 ± 0.7% | 356.2 ± 0.8% | 223.1 ± 1.6% | 0.945 | 1.118 | 1.947 | 1.828 | 2.920 |
| string: silesia/dickens | 172528 | 13469.0 ± 0.5% | 3958.9 ± 1.3% | 3100.7 ± 2.2% | 335.1 ± 0.8% | 1535.2 ± 2.2% | 1189.6 ± 0.6% | 3.402 | 4.344 | 40.197 | 8.774 | 11.323 |
| string: silesia/nci | 1075110 | 11753.6 ± 0.6% | 4757.6 ± 0.8% | 3136.0 ± 0.4% | 915.6 ± 0.6% | 1597.4 ± 0.9% | 1210.3 ± 1.8% | 2.471 | 3.748 | 12.836 | 7.358 | 9.711 |
| string: silesia/reymont | 1075159 | 5462.2 ± 30.0% | 1880.2 ± 0.9% | 1896.8 ± 0.2% | 379.0 ± 0.8% | 1307.8 ± 1.0% | 1050.7 ± 1.1% | 2.905 | 2.880 | 14.410 | 4.177 | 5.199 |
| string: silesia/samba | 97582 | 7356.8 ± 0.5% | 2722.1 ± 0.3% | 4085.1 ± 0.2% | 350.6 ± 0.4% | 1277.0 ± 1.1% | 1180.6 ± 0.4% | 2.703 | 1.801 | 20.982 | 5.761 | 6.231 |
| string: silesia/webster | 1098490 | 7031.6 ± 0.7% | 1996.8 ± 0.4% | 1774.8 ± 0.9% | 353.9 ± 0.8% | 1274.0 ± 1.9% | 613.3 ± 0.5% | 3.521 | 3.962 | 19.866 | 5.519 | 11.465 |
| string: silesia/xml | 1090118 | 10992.7 ± 0.4% | 3224.8 ± 0.5% | 2533.5 ± 0.2% | 608.7 ± 0.8% | 1725.8 ± 0.5% | 987.4 ± 3.8% | 3.409 | 4.339 | 18.059 | 6.369 | 11.133 |
| string: canterbury/alice29.txt | 159425 | 13398.9 ± 0.9% | 2898.0 ± 1.2% | 3032.1 ± 5.4% | 320.0 ± 1.0% | 1372.0 ± 1.2% | 1100.2 ± 0.7% | 4.623 | 4.419 | 41.868 | 9.766 | 12.179 |
| string: canterbury/asyoulik.txt | 132198 | 11523.5 ± 1.7% | 2119.2 ± 0.4% | 3133.2 ± 0.7% | 317.9 ± 0.7% | 1246.2 ± 1.0% | 961.6 ± 4.0% | 5.438 | 3.678 | 36.252 | 9.247 | 11.984 |
| string: canterbury/lcet10.txt | 441884 | 12796.9 ± 1.3% | 3100.8 ± 0.9% | 2599.4 ± 0.6% | 370.3 ± 1.0% | 1489.1 ± 1.4% | 1201.9 ± 0.5% | 4.127 | 4.923 | 34.556 | 8.594 | 10.647 |
| string: canterbury/plrabn12.txt | 503330 | 9056.1 ± 3.1% | 2326.6 ± 0.3% | 2107.9 ± 1.8% | 351.1 ± 1.1% | 1373.3 ± 2.5% | 1126.5 ± 1.2% | 3.892 | 4.296 | 25.797 | 6.595 | 8.039 |
| string: canterbury-large/E.coli | 1048578 | 31963.9 ± 0.1% | 16417.2 ± 1.2% | 3504.0 ± 0.1% | 1702.9 ± 0.2% | 3162.8 ± 0.4% | 1425.6 ± 0.2% | 1.947 | 9.122 | 18.771 | 10.106 | 22.421 |
| string: canterbury-large/bible.txt | 1055886 | 9895.5 ± 0.4% | 4943.3 ± 0.3% | 3021.3 ± 0.2% | 408.3 ± 0.8% | 2033.8 ± 0.2% | 1503.0 ± 0.2% | 2.002 | 3.275 | 24.233 | 4.866 | 6.584 |
| string: canterbury-large/world192.txt | 1103121 | 6509.7 ± 0.2% | 1750.1 ± 0.1% | 1890.4 ± 1.3% | 349.7 ± 0.7% | 1278.7 ± 0.8% | 973.9 ± 0.6% | 3.720 | 3.443 | 18.614 | 5.091 | 6.684 |
| string: http/html-1m | 1058582 | 10335.8 ± 3.6% | 4351.7 ± 0.5% | 2895.9 ± 1.1% | 423.1 ± 0.4% | 2026.9 ± 0.4% | 858.5 ± 0.4% | 2.375 | 3.569 | 24.426 | 5.099 | 12.040 |
| string: http/json-1m | 1190272 | 8564.5 ± 0.7% | 1605.9 ± 0.5% | 1590.3 ± 0.1% | 561.1 ± 0.4% | 1023.9 ± 0.7% | 849.9 ± 0.8% | 5.333 | 5.386 | 15.264 | 8.365 | 10.077 |
| string: http/js-1m | 1144362 | 6668.7 ± 3.1% | 1136.0 ± 0.3% | 1393.3 ± 0.2% | 333.3 ± 0.4% | 1039.3 ± 1.5% | 765.8 ± 0.7% | 5.870 | 4.786 | 20.006 | 6.417 | 8.708 |
| string: http/css-1m | 1097820 | 9132.5 ± 0.4% | 1497.0 ± 1.4% | 2308.8 ± 1.6% | 511.8 ± 0.1% | 1135.1 ± 0.7% | 887.4 ± 4.1% | 6.101 | 3.956 | 17.843 | 8.045 | 10.292 |
| string: dickens as Cyrillic and CJK | 1883069 | 5722.7 ± 1.9% | 3660.2 ± 0.4% | 491.6 ± 0.2% | 247.8 ± 0.5% | 458.5 ± 0.7% | 359.9 ± 0.4% | 1.564 | 11.641 | 23.092 | 12.483 | 15.903 |
| hex: silesia/dickens | 524290 | 42730.1 ± 0.2% | 2615.8 ± 8.9% | 1512.8 ± 0.1% | 462.4 ± 0.1% | 1522.7 ± 0.5% | 1075.8 ± 0.3% | 16.335 | 28.247 | 92.406 | 28.062 | 39.721 |
| hex: silesia/mozilla | 524290 | 43878.5 ± 0.7% | 2604.5 ± 0.2% | 1511.0 ± 0.1% | 385.0 ± 1.5% | 1514.6 ± 0.4% | 1074.9 ± 0.1% | 16.847 | 29.040 | 113.955 | 28.970 | 40.820 |
| hex: silesia/mr | 524290 | 43933.1 ± 0.0% | 2601.8 ± 0.1% | 1511.4 ± 0.1% | 595.7 ± 0.2% | 1512.6 ± 0.6% | 1075.1 ± 0.1% | 16.885 | 29.068 | 73.753 | 29.045 | 40.863 |
| hex: silesia/nci | 524290 | 43888.7 ± 0.1% | 2592.5 ± 0.1% | 1508.8 ± 0.1% | 749.7 ± 0.1% | 1506.7 ± 1.1% | 1075.9 ± 0.2% | 16.929 | 29.089 | 58.541 | 29.129 | 40.794 |
| hex: silesia/ooffice | 524290 | 43877.6 ± 0.1% | 2620.3 ± 0.2% | 1518.9 ± 1.1% | 314.8 ± 4.1% | 1516.2 ± 0.9% | 1076.1 ± 0.4% | 16.745 | 28.887 | 139.365 | 28.939 | 40.773 |
| hex: silesia/osdb | 524290 | 42316.6 ± 1.1% | 2608.7 ± 0.6% | 1513.5 ± 0.3% | 431.8 ± 0.2% | 1571.3 ± 0.4% | 1074.9 ± 0.2% | 16.221 | 27.959 | 98.000 | 26.930 | 39.368 |
| hex: silesia/reymont | 524290 | 43882.8 ± 0.3% | 2608.6 ± 0.1% | 1516.7 ± 0.1% | 482.9 ± 0.2% | 1521.3 ± 0.5% | 1075.0 ± 0.2% | 16.823 | 28.933 | 90.874 | 28.845 | 40.821 |
| hex: silesia/samba | 524290 | 43926.6 ± 0.1% | 2606.1 ± 0.2% | 1513.5 ± 0.2% | 339.6 ± 1.2% | 1571.2 ± 1.3% | 1072.0 ± 5.9% | 16.855 | 29.023 | 129.353 | 27.957 | 40.975 |
| hex: silesia/sao | 524290 | 43912.3 ± 0.4% | 2621.2 ± 0.1% | 1516.9 ± 0.3% | 272.1 ± 5.7% | 1524.1 ± 5.1% | 1074.5 ± 5.9% | 16.753 | 28.948 | 161.381 | 28.811 | 40.869 |
| hex: silesia/webster | 524290 | 44209.7 ± 0.1% | 2612.5 ± 0.6% | 1515.6 ± 0.1% | 437.5 ± 3.5% | 1565.1 ± 4.9% | 1072.8 ± 0.4% | 16.922 | 29.170 | 101.051 | 28.247 | 41.210 |
| hex: silesia/x-ray | 524290 | 43935.7 ± 0.0% | 2617.1 ± 0.3% | 1516.8 ± 4.4% | 420.1 ± 3.1% | 1525.4 ± 0.4% | 1075.9 ± 0.1% | 16.788 | 28.966 | 104.585 | 28.802 | 40.837 |
| hex: silesia/xml | 524290 | 43862.9 ± 0.2% | 2614.3 ± 0.2% | 1514.0 ± 4.4% | 693.6 ± 0.2% | 1571.8 ± 0.2% | 1074.5 ± 0.1% | 16.778 | 28.972 | 63.235 | 27.905 | 40.823 |
| hex: canterbury/alice29.txt | 304180 | 41924.8 ± 0.2% | 2625.4 ± 0.2% | 1529.5 ± 0.2% | 470.7 ± 0.1% | 1562.8 ± 0.3% | 1091.3 ± 0.1% | 15.969 | 27.410 | 89.075 | 26.826 | 38.418 |
| hex: canterbury/asyoulik.txt | 250360 | 43805.2 ± 0.0% | 2630.6 ± 0.1% | 1545.4 ± 0.1% | 459.3 ± 0.2% | 1566.5 ± 0.5% | 1092.9 ± 0.2% | 16.652 | 28.346 | 95.382 | 27.963 | 40.082 |
| hex: canterbury/cp.html | 49208 | 42888.5 ± 0.1% | 2598.7 ± 0.4% | 1530.2 ± 6.0% | 482.5 ± 0.5% | 1594.9 ± 0.1% | 1096.7 ± 0.3% | 16.504 | 28.028 | 88.891 | 26.891 | 39.106 |
| hex: canterbury/fields.c | 22302 | 42392.6 ± 0.1% | 2654.4 ± 0.4% | 1538.7 ± 7.0% | 604.9 ± 0.6% | 1612.9 ± 0.1% | 1103.7 ± 0.1% | 15.970 | 27.551 | 70.085 | 26.283 | 38.411 |
| hex: canterbury/grammar.lsp | 7444 | 39604.6 ± 0.2% | 2715.2 ± 0.3% | 1546.7 ± 0.1% | 816.8 ± 0.5% | 1617.5 ± 0.1% | 1112.8 ± 0.4% | 14.586 | 25.605 | 48.487 | 24.485 | 35.589 |
| hex: canterbury/kennedy.xls | 524290 | 43862.2 ± 0.1% | 2605.5 ± 0.1% | 1513.8 ± 0.0% | 793.1 ± 0.2% | 1563.9 ± 6.1% | 1070.1 ± 0.4% | 16.834 | 28.976 | 55.304 | 28.046 | 40.990 |
| hex: canterbury/lcet10.txt | 524290 | 43850.3 ± 0.1% | 2608.9 ± 0.5% | 1514.6 ± 0.3% | 469.2 ± 1.3% | 1566.4 ± 3.9% | 1072.6 ± 0.2% | 16.808 | 28.952 | 93.454 | 27.995 | 40.881 |
| hex: canterbury/plrabn12.txt | 524290 | 43917.0 ± 0.0% | 2614.2 ± 0.1% | 1515.4 ± 4.0% | 456.5 ± 1.9% | 1567.7 ± 2.7% | 1069.7 ± 0.6% | 16.800 | 28.981 | 96.212 | 28.014 | 41.054 |
| hex: canterbury/ptt5 | 524290 | 43940.6 ± 0.0% | 2596.7 ± 0.3% | 1510.1 ± 3.9% | 596.3 ± 4.4% | 1556.0 ± 1.4% | 1072.7 ± 0.0% | 16.921 | 29.098 | 73.685 | 28.240 | 40.964 |
| hex: canterbury/sum | 76482 | 43204.1 ± 0.1% | 2614.6 ± 0.1% | 1525.7 ± 0.1% | 564.1 ± 0.5% | 1586.5 ± 0.1% | 1093.4 ± 4.9% | 16.524 | 28.317 | 76.594 | 27.232 | 39.513 |
| hex: canterbury/xargs.1 | 8456 | 40489.4 ± 0.3% | 2696.2 ± 7.2% | 1548.3 ± 0.3% | 843.0 ± 0.3% | 1617.0 ± 0.5% | 1115.1 ± 0.5% | 15.017 | 26.150 | 48.028 | 25.040 | 36.310 |
| hex: canterbury-large/E.coli | 524290 | 42088.0 ± 0.2% | 2606.0 ± 0.3% | 1513.5 ± 0.2% | 820.1 ± 0.1% | 1571.9 ± 0.3% | 1073.1 ± 0.2% | 16.151 | 27.809 | 51.322 | 26.776 | 39.219 |
| hex: canterbury-large/bible.txt | 524290 | 43958.4 ± 0.1% | 2614.3 ± 7.8% | 1516.8 ± 4.6% | 483.8 ± 0.2% | 1555.7 ± 1.6% | 1073.4 ± 0.4% | 16.815 | 28.982 | 90.852 | 28.257 | 40.951 |
| hex: canterbury-large/world192.txt | 524290 | 43643.0 ± 0.0% | 2612.9 ± 0.1% | 1516.5 ± 0.3% | 461.7 ± 0.4% | 1570.2 ± 1.1% | 1072.6 ± 0.1% | 16.703 | 28.779 | 94.528 | 27.794 | 40.691 |
| hex: http/html-1kx1024 | 2099200 | 21140.0 ± 0.1% | 2377.9 ± 1.2% | 1464.8 ± 3.9% | 502.9 ± 0.1% | 1507.4 ± 0.9% | 1083.2 ± 0.1% | 8.890 | 14.432 | 42.037 | 14.024 | 19.516 |
| hex: http/html-16kx64 | 2097280 | 22763.5 ± 0.1% | 2139.4 ± 5.6% | 1457.1 ± 0.3% | 506.6 ± 0.2% | 1458.2 ± 0.2% | 1090.7 ± 0.2% | 10.640 | 15.622 | 44.930 | 15.611 | 20.871 |
| hex: http/html-1m | 524290 | 43908.1 ± 0.0% | 2612.0 ± 0.4% | 1516.9 ± 0.2% | 488.8 ± 0.1% | 1533.7 ± 0.9% | 1070.4 ± 0.2% | 16.810 | 28.946 | 89.826 | 28.629 | 41.022 |
| hex: http/json-1kx1024 | 2099200 | 21855.3 ± 0.2% | 2341.2 ± 0.6% | 1459.6 ± 0.6% | 699.6 ± 0.2% | 1500.1 ± 0.8% | 1083.4 ± 0.1% | 9.335 | 14.973 | 31.239 | 14.569 | 20.173 |
| hex: http/json-16kx64 | 2097280 | 22576.2 ± 2.3% | 2224.1 ± 0.1% | 1451.2 ± 0.1% | 708.9 ± 0.2% | 1452.8 ± 0.1% | 1086.5 ± 0.4% | 10.151 | 15.556 | 31.846 | 15.540 | 20.780 |
| hex: http/json-1m | 524290 | 43727.8 ± 7.4% | 2605.9 ± 0.4% | 1513.0 ± 0.1% | 738.8 ± 0.7% | 1570.0 ± 0.4% | 1075.1 ± 0.2% | 16.781 | 28.902 | 59.188 | 27.852 | 40.675 |
| hex: http/js-1kx1024 | 2099200 | 20416.2 ± 0.3% | 2343.6 ± 0.9% | 1460.7 ± 0.4% | 492.7 ± 0.3% | 1503.9 ± 0.8% | 1084.0 ± 0.3% | 8.711 | 13.977 | 41.438 | 13.575 | 18.833 |
| hex: http/js-16kx64 | 2097280 | 22438.1 ± 0.0% | 2236.3 ± 0.3% | 1457.2 ± 0.1% | 494.7 ± 0.2% | 1456.2 ± 0.1% | 1091.2 ± 0.2% | 10.034 | 15.398 | 45.361 | 15.408 | 20.563 |
| hex: http/js-1m | 524290 | 43910.8 ± 0.1% | 2607.3 ± 0.2% | 1517.1 ± 0.2% | 509.7 ± 0.1% | 1568.4 ± 0.7% | 1070.5 ± 0.1% | 16.841 | 28.945 | 86.154 | 27.996 | 41.020 |
| hex: http/css-1kx1024 | 2099200 | 22461.8 ± 0.1% | 2389.8 ± 2.7% | 1466.6 ± 0.5% | 559.5 ± 0.3% | 1521.0 ± 0.9% | 1082.9 ± 1.9% | 9.399 | 15.315 | 40.150 | 14.768 | 20.742 |
| hex: http/css-16kx64 | 2097280 | 22056.3 ± 0.2% | 2238.0 ± 0.3% | 1457.6 ± 0.0% | 566.7 ± 0.1% | 1458.8 ± 0.1% | 1090.8 ± 0.0% | 9.855 | 15.132 | 38.918 | 15.119 | 20.221 |
| hex: http/css-1m | 524290 | 43879.4 ± 0.1% | 2615.5 ± 0.2% | 1515.0 ± 0.2% | 535.4 ± 0.4% | 1519.9 ± 0.7% | 1074.7 ± 3.2% | 16.776 | 28.964 | 81.961 | 28.870 | 40.828 |
| hex: shuffled/dickens-1m | 524290 | 42693.0 ± 0.1% | 2605.4 ± 0.3% | 1515.6 ± 0.1% | 464.8 ± 0.1% | 1569.7 ± 0.6% | 1075.9 ± 0.3% | 16.387 | 28.170 | 91.856 | 27.198 | 39.680 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1150.9 ± 0.5% | 1534.2 ± 1.6% | 1122.4 ± 0.2% | 390.9 ± 0.7% | 675.3 ± 24.8% | 367.2 ± 65.3% | 0.750 | 1.025 | 2.944 | 1.704 | 3.134 |
| qlog records, JSON text sequence | 1467503 | 1005.0 ± 0.5% | 1254.7 ± 1.3% | 1139.8 ± 1.0% | 330.7 ± 1.4% | 757.2 ± 0.8% | 320.4 ± 0.6% | 0.801 | 0.882 | 3.039 | 1.327 | 3.136 |
| messages: 11 string members | 1025025 | 956.0 ± 0.4% | 2022.9 ± 0.9% | 721.6 ± 2.7% | 338.6 ± 0.7% | 511.4 ± 2.3% | 302.4 ± 3.0% | 0.473 | 1.325 | 2.824 | 1.869 | 3.161 |
| messages: 50 nested objects | 1121600 | 1241.4 ± 0.4% | 1758.4 ± 0.7% | 1462.0 ± 0.2% | 431.8 ± 0.8% | 907.8 ± 0.8% | 422.0 ± 3.0% | 0.706 | 0.849 | 2.875 | 1.367 | 2.941 |
| messages: a tree of 341 objects | 612600 | 553.0 ± 0.5% | 855.8 ± 1.2% | 703.5 ± 0.8% | 182.5 ± 0.5% | 613.9 ± 0.5% | 209.9 ± 0.7% | 0.646 | 0.786 | 3.029 | 0.901 | 2.634 |
| string: silesia/dickens | 172528 | 6746.5 ± 0.2% | 3426.8 ± 3.0% | 2846.4 ± 0.7% | 318.2 ± 0.4% | 3121.2 ± 1.3% | 573.0 ± 3.1% | 1.969 | 2.370 | 21.199 | 2.162 | 11.773 |
| string: silesia/nci | 1075110 | 5449.4 ± 0.7% | 3938.4 ± 0.2% | 3051.4 ± 0.3% | 649.8 ± 0.4% | 3650.8 ± 0.4% | 579.0 ± 1.4% | 1.384 | 1.786 | 8.387 | 1.493 | 9.412 |
| string: silesia/reymont | 1075159 | 3472.4 ± 0.8% | 3438.5 ± 0.3% | 1963.1 ± 2.4% | 343.5 ± 0.2% | 2105.6 ± 2.8% | 499.1 ± 3.2% | 1.010 | 1.769 | 10.110 | 1.649 | 6.957 |
| string: silesia/samba | 97582 | 4001.4 ± 0.6% | 3796.8 ± 0.5% | 3056.2 ± 5.0% | 327.0 ± 0.6% | 1973.9 ± 1.1% | 421.5 ± 4.1% | 1.054 | 1.309 | 12.237 | 2.027 | 9.493 |
| string: silesia/webster | 1098490 | 4407.0 ± 1.1% | 2453.6 ± 2.3% | 1742.7 ± 0.4% | 310.0 ± 0.5% | 2073.0 ± 0.6% | 471.6 ± 1.6% | 1.796 | 2.529 | 14.217 | 2.126 | 9.344 |
| string: silesia/xml | 1090118 | 6100.8 ± 1.2% | 5086.2 ± 0.2% | 2466.0 ± 0.3% | 510.4 ± 0.8% | 3346.4 ± 0.2% | 551.4 ± 1.6% | 1.199 | 2.474 | 11.953 | 1.823 | 11.063 |
| string: canterbury/alice29.txt | 159425 | 5827.4 ± 0.7% | 2794.3 ± 1.1% | 2814.3 ± 2.1% | 300.7 ± 0.2% | 2787.9 ± 0.9% | 522.6 ± 0.9% | 2.085 | 2.071 | 19.378 | 2.090 | 11.150 |
| string: canterbury/asyoulik.txt | 132198 | 4322.7 ± 0.5% | 2565.9 ± 6.5% | 2787.6 ± 1.3% | 305.4 ± 2.9% | 2421.5 ± 1.0% | 459.1 ± 1.3% | 1.685 | 1.551 | 14.152 | 1.785 | 9.415 |
| string: canterbury/lcet10.txt | 441884 | 6680.0 ± 1.3% | 3287.2 ± 0.5% | 2303.1 ± 1.4% | 346.9 ± 2.0% | 2804.3 ± 0.4% | 573.9 ± 0.4% | 2.032 | 2.900 | 19.255 | 2.382 | 11.639 |
| string: canterbury/plrabn12.txt | 503330 | 5509.4 ± 0.1% | 3174.5 ± 0.7% | 1846.7 ± 0.6% | 323.7 ± 0.2% | 2846.4 ± 2.4% | 533.9 ± 1.1% | 1.736 | 2.983 | 17.022 | 1.936 | 10.319 |
| string: canterbury-large/E.coli | 1048578 | 34055.2 ± 0.1% | 13699.7 ± 0.1% | 3450.3 ± 0.1% | 1287.7 ± 0.2% | 8949.5 ± 0.2% | 975.7 ± 0.7% | 2.486 | 9.870 | 26.447 | 3.805 | 34.904 |
| string: canterbury-large/bible.txt | 1055886 | 8631.1 ± 0.6% | 5294.5 ± 0.3% | 2831.6 ± 0.1% | 358.3 ± 0.4% | 3907.2 ± 0.3% | 641.3 ± 1.9% | 1.630 | 3.048 | 24.088 | 2.209 | 13.458 |
| string: canterbury-large/world192.txt | 1103121 | 4172.7 ± 0.9% | 2321.3 ± 0.3% | 1770.0 ± 0.4% | 328.4 ± 0.3% | 2129.5 ± 0.6% | 468.9 ± 1.9% | 1.798 | 2.357 | 12.704 | 1.960 | 8.899 |
| string: http/html-1m | 1058582 | 8813.1 ± 2.5% | 4745.7 ± 3.0% | 2739.8 ± 3.5% | 427.6 ± 0.2% | 3666.7 ± 0.3% | 609.7 ± 1.8% | 1.857 | 3.217 | 20.609 | 2.404 | 14.454 |
| string: http/json-1m | 1190272 | 3335.0 ± 0.4% | 1260.7 ± 0.7% | 2107.8 ± 0.1% | 477.5 ± 0.6% | 1345.0 ± 0.3% | 442.0 ± 3.0% | 2.645 | 1.582 | 6.985 | 2.480 | 7.545 |
| string: http/js-1m | 1144362 | 2863.2 ± 0.3% | 1618.1 ± 0.9% | 1335.3 ± 0.9% | 326.9 ± 0.3% | 1431.0 ± 0.4% | 383.2 ± 2.0% | 1.769 | 2.144 | 8.760 | 2.001 | 7.471 |
| string: http/css-1m | 1097820 | 3327.1 ± 0.5% | 2899.1 ± 0.3% | 2291.0 ± 4.5% | 453.9 ± 0.2% | 2075.7 ± 0.5% | 446.1 ± 1.3% | 1.148 | 1.452 | 7.330 | 1.603 | 7.458 |
| string: dickens as Cyrillic and CJK | 1883069 | 5859.8 ± 0.6% | 2925.6 ± 3.6% | 665.0 ± 0.5% | 380.3 ± 0.3% | 515.0 ± 0.4% | 165.0 ± 3.8% | 2.003 | 8.811 | 15.408 | 11.379 | 35.521 |
| string: dickens as Cyrillic and CJK, as \u escapes | 5075485 | 1220.4 ± 0.3% | 1250.2 ± 1.5% | 1108.3 ± 0.7% | 264.2 ± 0.5% | 481.3 ± 0.5% | 232.0 ± 4.8% | 0.976 | 1.101 | 4.620 | 2.536 | 5.261 |
| hex: silesia/dickens | 524290 | 34055.1 ± 0.1% | 15127.6 ± 0.2% | 3567.9 ± 0.8% | 478.4 ± 2.3% | 8963.6 ± 0.2% | 1146.4 ± 2.2% | 2.251 | 9.545 | 71.187 | 3.799 | 29.707 |
| hex: silesia/mozilla | 524290 | 34040.1 ± 0.3% | 15129.3 ± 0.2% | 3506.6 ± 0.3% | 432.4 ± 0.2% | 8945.4 ± 0.3% | 1144.2 ± 0.3% | 2.250 | 9.707 | 78.729 | 3.805 | 29.750 |
| hex: silesia/mr | 524290 | 34029.9 ± 4.7% | 15123.8 ± 0.1% | 3511.0 ± 3.4% | 648.1 ± 0.1% | 8948.1 ± 0.2% | 1146.0 ± 0.2% | 2.250 | 9.692 | 52.507 | 3.803 | 29.695 |
| hex: silesia/nci | 524290 | 34050.6 ± 0.4% | 15129.8 ± 1.3% | 3576.1 ± 0.1% | 805.4 ± 3.6% | 8958.6 ± 0.2% | 1146.6 ± 0.2% | 2.251 | 9.522 | 42.280 | 3.801 | 29.698 |
| hex: silesia/ooffice | 524290 | 34069.0 ± 0.1% | 15128.8 ± 0.2% | 3509.0 ± 0.1% | 347.0 ± 0.6% | 8946.8 ± 0.2% | 1147.5 ± 0.3% | 2.252 | 9.709 | 98.180 | 3.808 | 29.691 |
| hex: silesia/osdb | 524290 | 34067.9 ± 0.3% | 15125.5 ± 0.1% | 3511.4 ± 0.5% | 457.8 ± 0.7% | 8946.9 ± 0.6% | 1147.0 ± 1.1% | 2.252 | 9.702 | 74.417 | 3.808 | 29.701 |
| hex: silesia/reymont | 524290 | 34078.0 ± 0.1% | 15128.6 ± 0.9% | 3579.0 ± 0.1% | 500.1 ± 2.0% | 8957.2 ± 0.6% | 1147.1 ± 0.2% | 2.253 | 9.522 | 68.136 | 3.805 | 29.708 |
| hex: silesia/samba | 524290 | 34077.8 ± 0.1% | 15118.6 ± 0.2% | 3510.1 ± 0.1% | 369.6 ± 2.5% | 8946.9 ± 0.3% | 1146.6 ± 0.2% | 2.254 | 9.709 | 92.203 | 3.809 | 29.721 |
| hex: silesia/sao | 524290 | 34095.5 ± 0.2% | 15104.2 ± 2.6% | 3508.7 ± 0.2% | 280.7 ± 0.5% | 8949.7 ± 0.5% | 1147.3 ± 3.7% | 2.257 | 9.717 | 121.450 | 3.810 | 29.718 |
| hex: silesia/webster | 524290 | 34091.2 ± 0.1% | 15117.2 ± 0.1% | 3573.3 ± 0.1% | 454.8 ± 0.3% | 8968.7 ± 0.2% | 1146.6 ± 0.2% | 2.255 | 9.541 | 74.966 | 3.801 | 29.732 |
| hex: silesia/x-ray | 524290 | 34101.4 ± 0.1% | 15134.0 ± 0.1% | 3494.4 ± 0.1% | 427.5 ± 0.3% | 8954.2 ± 0.6% | 1143.0 ± 1.0% | 2.253 | 9.759 | 79.778 | 3.808 | 29.835 |
| hex: silesia/xml | 524290 | 34046.2 ± 4.5% | 15127.3 ± 0.2% | 3575.9 ± 3.2% | 728.4 ± 0.3% | 8947.3 ± 0.1% | 1143.5 ± 0.6% | 2.251 | 9.521 | 46.743 | 3.805 | 29.773 |
| hex: canterbury/alice29.txt | 304180 | 33924.5 ± 0.2% | 14184.0 ± 0.1% | 3577.6 ± 0.1% | 484.3 ± 0.6% | 8964.5 ± 0.5% | 1155.6 ± 0.3% | 2.392 | 9.483 | 70.045 | 3.784 | 29.355 |
| hex: canterbury/asyoulik.txt | 250360 | 34020.1 ± 0.2% | 15006.5 ± 1.1% | 3513.1 ± 0.2% | 470.8 ± 0.5% | 8941.2 ± 0.3% | 1152.8 ± 4.5% | 2.267 | 9.684 | 72.256 | 3.805 | 29.511 |
| hex: canterbury/cp.html | 49208 | 33510.2 ± 0.1% | 14503.0 ± 0.1% | 3581.2 ± 4.3% | 512.1 ± 0.7% | 9292.5 ± 0.1% | 1137.1 ± 3.5% | 2.311 | 9.357 | 65.434 | 3.606 | 29.470 |
| hex: canterbury/fields.c | 22302 | 33170.8 ± 0.9% | 17752.9 ± 0.4% | 3684.9 ± 0.4% | 570.7 ± 0.8% | 9281.4 ± 0.5% | 1101.9 ± 1.6% | 1.868 | 9.002 | 58.126 | 3.574 | 30.103 |
| hex: canterbury/grammar.lsp | 7444 | 30036.7 ± 0.1% | 17316.3 ± 1.6% | 3639.5 ± 2.3% | 744.7 ± 0.9% | 8981.6 ± 0.1% | 1079.5 ± 1.7% | 1.735 | 8.253 | 40.333 | 3.344 | 27.824 |
| hex: canterbury/kennedy.xls | 524290 | 34094.2 ± 0.0% | 15132.7 ± 0.1% | 3579.7 ± 0.3% | 759.0 ± 0.9% | 8942.5 ± 0.9% | 1130.8 ± 5.0% | 2.253 | 9.524 | 44.919 | 3.813 | 30.150 |
| hex: canterbury/lcet10.txt | 524290 | 34104.0 ± 0.1% | 15123.2 ± 0.3% | 3557.1 ± 0.1% | 484.0 ± 0.1% | 8941.4 ± 0.3% | 1143.8 ± 1.3% | 2.255 | 9.588 | 70.459 | 3.814 | 29.817 |
| hex: canterbury/plrabn12.txt | 524290 | 34046.9 ± 1.3% | 15133.9 ± 0.1% | 3564.6 ± 0.4% | 466.6 ± 0.3% | 8950.0 ± 0.7% | 1144.4 ± 0.7% | 2.250 | 9.551 | 72.976 | 3.804 | 29.751 |
| hex: canterbury/ptt5 | 524290 | 34081.8 ± 0.1% | 15125.6 ± 0.1% | 3510.8 ± 0.1% | 667.0 ± 0.2% | 8930.4 ± 0.1% | 1146.9 ± 1.4% | 2.253 | 9.708 | 51.094 | 3.816 | 29.717 |
| hex: canterbury/sum | 76482 | 33470.5 ± 0.1% | 15502.2 ± 0.1% | 3579.8 ± 0.2% | 587.5 ± 0.4% | 8959.1 ± 0.2% | 1124.2 ± 4.1% | 2.159 | 9.350 | 56.968 | 3.736 | 29.772 |
| hex: canterbury/xargs.1 | 8456 | 30525.8 ± 0.1% | 17471.0 ± 0.2% | 3577.7 ± 0.1% | 729.2 ± 1.4% | 9014.1 ± 0.2% | 1116.4 ± 1.5% | 1.747 | 8.532 | 41.860 | 3.386 | 27.342 |
| hex: canterbury-large/E.coli | 524290 | 34091.7 ± 0.1% | 14444.5 ± 0.2% | 3514.2 ± 0.1% | 966.6 ± 0.1% | 8950.7 ± 0.2% | 1131.9 ± 8.2% | 2.360 | 9.701 | 35.271 | 3.809 | 30.120 |
| hex: canterbury-large/bible.txt | 524290 | 34089.5 ± 0.1% | 14431.8 ± 0.1% | 3515.0 ± 0.1% | 500.9 ± 0.4% | 8946.0 ± 0.3% | 1162.7 ± 1.0% | 2.362 | 9.698 | 68.052 | 3.811 | 29.319 |
| hex: canterbury-large/world192.txt | 524290 | 34057.5 ± 0.1% | 14441.4 ± 0.0% | 3584.8 ± 0.1% | 468.9 ± 0.5% | 8964.0 ± 0.2% | 1162.6 ± 4.2% | 2.358 | 9.501 | 72.637 | 3.799 | 29.294 |
| hex: http/html-1kx1024 | 2099200 | 15506.8 ± 0.5% | 12211.9 ± 0.2% | 3230.9 ± 0.2% | 507.0 ± 0.3% | 7405.5 ± 0.6% | 1006.7 ± 1.9% | 1.270 | 4.800 | 30.587 | 2.094 | 15.403 |
| hex: http/html-16kx64 | 2097280 | 27307.4 ± 0.2% | 14075.2 ± 0.3% | 3427.5 ± 0.1% | 514.5 ± 0.4% | 8464.9 ± 1.1% | 1105.9 ± 2.7% | 1.940 | 7.967 | 53.074 | 3.226 | 24.693 |
| hex: http/html-1m | 524290 | 34068.9 ± 0.1% | 15121.1 ± 0.4% | 3509.1 ± 0.3% | 509.0 ± 0.6% | 8942.5 ± 0.2% | 1159.7 ± 2.9% | 2.253 | 9.709 | 66.933 | 3.810 | 29.376 |
| hex: http/json-1kx1024 | 2099200 | 15553.3 ± 0.5% | 12265.8 ± 12.5% | 3226.8 ± 2.8% | 672.1 ± 2.4% | 7401.5 ± 2.1% | 1018.0 ± 1.0% | 1.268 | 4.820 | 23.141 | 2.101 | 15.279 |
| hex: http/json-16kx64 | 2097280 | 28339.6 ± 0.1% | 14047.5 ± 0.2% | 3432.1 ± 0.2% | 687.6 ± 0.8% | 8592.0 ± 1.1% | 1120.0 ± 1.9% | 2.017 | 8.257 | 41.218 | 3.298 | 25.304 |
| hex: http/json-1m | 524290 | 34094.4 ± 0.2% | 15147.3 ± 0.0% | 3584.9 ± 0.1% | 701.4 ± 0.6% | 8960.0 ± 0.1% | 1158.7 ± 1.0% | 2.251 | 9.511 | 48.606 | 3.805 | 29.426 |
| hex: http/js-1kx1024 | 2099200 | 15513.4 ± 4.1% | 12143.4 ± 5.8% | 3225.2 ± 0.4% | 489.5 ± 0.6% | 7451.9 ± 0.9% | 1019.3 ± 0.7% | 1.278 | 4.810 | 31.695 | 2.082 | 15.219 |
| hex: http/js-16kx64 | 2097280 | 28071.5 ± 0.1% | 14023.0 ± 0.2% | 3422.9 ± 0.0% | 496.7 ± 0.5% | 8754.3 ± 0.4% | 1117.3 ± 0.6% | 2.002 | 8.201 | 56.511 | 3.207 | 25.124 |
| hex: http/js-1m | 524290 | 34030.6 ± 0.4% | 15149.3 ± 0.2% | 3558.7 ± 0.2% | 515.1 ± 0.4% | 8961.6 ± 0.4% | 1158.5 ± 1.7% | 2.246 | 9.563 | 66.072 | 3.797 | 29.374 |
| hex: http/css-1kx1024 | 2099200 | 15588.5 ± 0.2% | 12012.1 ± 0.3% | 3228.1 ± 0.3% | 572.1 ± 4.0% | 7410.0 ± 0.6% | 1013.6 ± 1.4% | 1.298 | 4.829 | 27.247 | 2.104 | 15.379 |
| hex: http/css-16kx64 | 2097280 | 28402.1 ± 0.0% | 14045.1 ± 0.3% | 3432.5 ± 3.2% | 583.3 ± 0.8% | 8652.6 ± 1.0% | 1102.4 ± 2.4% | 2.022 | 8.275 | 48.694 | 3.282 | 25.764 |
| hex: http/css-1m | 524290 | 34066.3 ± 0.2% | 15113.2 ± 2.6% | 3578.0 ± 0.1% | 561.8 ± 0.6% | 8946.7 ± 5.2% | 1114.6 ± 3.0% | 2.254 | 9.521 | 60.639 | 3.808 | 30.563 |
| hex: shuffled/dickens-1m | 524290 | 34055.8 ± 0.1% | 15122.7 ± 0.2% | 3504.1 ± 0.4% | 478.4 ± 0.6% | 8948.2 ± 0.1% | 1104.1 ± 4.0% | 2.252 | 9.719 | 71.192 | 3.806 | 30.844 |

## TextReader.next_items against the baselines

stdx's decoder a slice of tokens a call through `TextReader.next_items`, as a caller that reads a text's values in a loop calls it (decision 79). Octets are the text's. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1285.6 ± 0.3% | 1534.2 ± 1.6% | 1122.4 ± 0.2% | 390.9 ± 0.7% | 675.3 ± 24.8% | 367.2 ± 65.3% | 0.838 | 1.145 | 3.289 | 1.904 | 3.501 |
| qlog records, JSON text sequence | 1467503 | 1153.0 ± 0.1% | 1254.7 ± 1.3% | 1139.8 ± 1.0% | 330.7 ± 1.4% | 757.2 ± 0.8% | 320.4 ± 0.6% | 0.919 | 1.012 | 3.487 | 1.523 | 3.598 |
| messages: 11 string members | 1025025 | 1031.4 ± 0.4% | 2022.9 ± 0.9% | 721.6 ± 2.7% | 338.6 ± 0.7% | 511.4 ± 2.3% | 302.4 ± 3.0% | 0.510 | 1.429 | 3.046 | 2.017 | 3.411 |
| messages: 50 nested objects | 1121600 | 1304.8 ± 0.1% | 1758.4 ± 0.7% | 1462.0 ± 0.2% | 431.8 ± 0.8% | 907.8 ± 0.8% | 422.0 ± 3.0% | 0.742 | 0.892 | 3.021 | 1.437 | 3.092 |
| messages: a tree of 341 objects | 612600 | 655.1 ± 0.3% | 855.8 ± 1.2% | 703.5 ± 0.8% | 182.5 ± 0.5% | 613.9 ± 0.5% | 209.9 ± 0.7% | 0.766 | 0.931 | 3.589 | 1.067 | 3.120 |
| string: silesia/dickens | 172528 | 6748.5 ± 0.3% | 3426.8 ± 3.0% | 2846.4 ± 0.7% | 318.2 ± 0.4% | 3121.2 ± 1.3% | 573.0 ± 3.1% | 1.969 | 2.371 | 21.205 | 2.162 | 11.777 |
| string: silesia/nci | 1075110 | 5467.4 ± 0.3% | 3938.4 ± 0.2% | 3051.4 ± 0.3% | 649.8 ± 0.4% | 3650.8 ± 0.4% | 579.0 ± 1.4% | 1.388 | 1.792 | 8.414 | 1.498 | 9.443 |
| string: silesia/reymont | 1075159 | 3499.6 ± 1.2% | 3438.5 ± 0.3% | 1963.1 ± 2.4% | 343.5 ± 0.2% | 2105.6 ± 2.8% | 499.1 ± 3.2% | 1.018 | 1.783 | 10.189 | 1.662 | 7.012 |
| string: silesia/samba | 97582 | 4003.3 ± 4.1% | 3796.8 ± 0.5% | 3056.2 ± 5.0% | 327.0 ± 0.6% | 1973.9 ± 1.1% | 421.5 ± 4.1% | 1.054 | 1.310 | 12.243 | 2.028 | 9.498 |
| string: silesia/webster | 1098490 | 4430.1 ± 1.9% | 2453.6 ± 2.3% | 1742.7 ± 0.4% | 310.0 ± 0.5% | 2073.0 ± 0.6% | 471.6 ± 1.6% | 1.806 | 2.542 | 14.291 | 2.137 | 9.393 |
| string: silesia/xml | 1090118 | 6126.0 ± 1.6% | 5086.2 ± 0.2% | 2466.0 ± 0.3% | 510.4 ± 0.8% | 3346.4 ± 0.2% | 551.4 ± 1.6% | 1.204 | 2.484 | 12.003 | 1.831 | 11.109 |
| string: canterbury/alice29.txt | 159425 | 5880.5 ± 1.1% | 2794.3 ± 1.1% | 2814.3 ± 2.1% | 300.7 ± 0.2% | 2787.9 ± 0.9% | 522.6 ± 0.9% | 2.105 | 2.089 | 19.554 | 2.109 | 11.252 |
| string: canterbury/asyoulik.txt | 132198 | 4352.2 ± 0.6% | 2565.9 ± 6.5% | 2787.6 ± 1.3% | 305.4 ± 2.9% | 2421.5 ± 1.0% | 459.1 ± 1.3% | 1.696 | 1.561 | 14.249 | 1.797 | 9.479 |
| string: canterbury/lcet10.txt | 441884 | 6697.8 ± 0.9% | 3287.2 ± 0.5% | 2303.1 ± 1.4% | 346.9 ± 2.0% | 2804.3 ± 0.4% | 573.9 ± 0.4% | 2.038 | 2.908 | 19.306 | 2.388 | 11.670 |
| string: canterbury/plrabn12.txt | 503330 | 5512.2 ± 0.1% | 3174.5 ± 0.7% | 1846.7 ± 0.6% | 323.7 ± 0.2% | 2846.4 ± 2.4% | 533.9 ± 1.1% | 1.736 | 2.985 | 17.031 | 1.937 | 10.324 |
| string: canterbury-large/E.coli | 1048578 | 34147.2 ± 5.0% | 13699.7 ± 0.1% | 3450.3 ± 0.1% | 1287.7 ± 0.2% | 8949.5 ± 0.2% | 975.7 ± 0.7% | 2.493 | 9.897 | 26.519 | 3.816 | 34.998 |
| string: canterbury-large/bible.txt | 1055886 | 8655.0 ± 0.9% | 5294.5 ± 0.3% | 2831.6 ± 0.1% | 358.3 ± 0.4% | 3907.2 ± 0.3% | 641.3 ± 1.9% | 1.635 | 3.057 | 24.155 | 2.215 | 13.495 |
| string: canterbury-large/world192.txt | 1103121 | 4192.4 ± 1.1% | 2321.3 ± 0.3% | 1770.0 ± 0.4% | 328.4 ± 0.3% | 2129.5 ± 0.6% | 468.9 ± 1.9% | 1.806 | 2.369 | 12.764 | 1.969 | 8.941 |
| string: http/html-1m | 1058582 | 9686.0 ± 2.0% | 4745.7 ± 3.0% | 2739.8 ± 3.5% | 427.6 ± 0.2% | 3666.7 ± 0.3% | 609.7 ± 1.8% | 2.041 | 3.535 | 22.650 | 2.642 | 15.886 |
| string: http/json-1m | 1190272 | 3333.0 ± 0.6% | 1260.7 ± 0.7% | 2107.8 ± 0.1% | 477.5 ± 0.6% | 1345.0 ± 0.3% | 442.0 ± 3.0% | 2.644 | 1.581 | 6.981 | 2.478 | 7.541 |
| string: http/js-1m | 1144362 | 2868.1 ± 0.1% | 1618.1 ± 0.9% | 1335.3 ± 0.9% | 326.9 ± 0.3% | 1431.0 ± 0.4% | 383.2 ± 2.0% | 1.772 | 2.148 | 8.775 | 2.004 | 7.484 |
| string: http/css-1m | 1097820 | 3338.3 ± 1.0% | 2899.1 ± 0.3% | 2291.0 ± 4.5% | 453.9 ± 0.2% | 2075.7 ± 0.5% | 446.1 ± 1.3% | 1.152 | 1.457 | 7.355 | 1.608 | 7.483 |
| string: dickens as Cyrillic and CJK | 1883069 | 5872.3 ± 1.6% | 2925.6 ± 3.6% | 665.0 ± 0.5% | 380.3 ± 0.3% | 515.0 ± 0.4% | 165.0 ± 3.8% | 2.007 | 8.830 | 15.441 | 11.403 | 35.596 |
| string: dickens as Cyrillic and CJK, as \u escapes | 5075485 | 1221.2 ± 0.5% | 1250.2 ± 1.5% | 1108.3 ± 0.7% | 264.2 ± 0.5% | 481.3 ± 0.5% | 232.0 ± 4.8% | 0.977 | 1.102 | 4.623 | 2.537 | 5.264 |
| hex: silesia/dickens | 524290 | 34055.6 ± 0.1% | 15127.6 ± 0.2% | 3567.9 ± 0.8% | 478.4 ± 2.3% | 8963.6 ± 0.2% | 1146.4 ± 2.2% | 2.251 | 9.545 | 71.188 | 3.799 | 29.708 |
| hex: silesia/mozilla | 524290 | 34061.9 ± 0.1% | 15129.3 ± 0.2% | 3506.6 ± 0.3% | 432.4 ± 0.2% | 8945.4 ± 0.3% | 1144.2 ± 0.3% | 2.251 | 9.714 | 78.780 | 3.808 | 29.769 |
| hex: silesia/mr | 524290 | 34078.4 ± 0.1% | 15123.8 ± 0.1% | 3511.0 ± 3.4% | 648.1 ± 0.1% | 8948.1 ± 0.2% | 1146.0 ± 0.2% | 2.253 | 9.706 | 52.582 | 3.808 | 29.737 |
| hex: silesia/nci | 524290 | 34066.8 ± 1.9% | 15129.8 ± 1.3% | 3576.1 ± 0.1% | 805.4 ± 3.6% | 8958.6 ± 0.2% | 1146.6 ± 0.2% | 2.252 | 9.526 | 42.300 | 3.803 | 29.712 |
| hex: silesia/ooffice | 524290 | 34065.3 ± 0.0% | 15128.8 ± 0.2% | 3509.0 ± 0.1% | 347.0 ± 0.6% | 8946.8 ± 0.2% | 1147.5 ± 0.3% | 2.252 | 9.708 | 98.169 | 3.808 | 29.688 |
| hex: silesia/osdb | 524290 | 34062.4 ± 0.1% | 15125.5 ± 0.1% | 3511.4 ± 0.5% | 457.8 ± 0.7% | 8946.9 ± 0.6% | 1147.0 ± 1.1% | 2.252 | 9.700 | 74.405 | 3.807 | 29.696 |
| hex: silesia/reymont | 524290 | 34064.2 ± 0.0% | 15128.6 ± 0.9% | 3579.0 ± 0.1% | 500.1 ± 2.0% | 8957.2 ± 0.6% | 1147.1 ± 0.2% | 2.252 | 9.518 | 68.108 | 3.803 | 29.696 |
| hex: silesia/samba | 524290 | 34061.1 ± 0.1% | 15118.6 ± 0.2% | 3510.1 ± 0.1% | 369.6 ± 2.5% | 8946.9 ± 0.3% | 1146.6 ± 0.2% | 2.253 | 9.704 | 92.158 | 3.807 | 29.706 |
| hex: silesia/sao | 524290 | 34053.2 ± 0.1% | 15104.2 ± 2.6% | 3508.7 ± 0.2% | 280.7 ± 0.5% | 8949.7 ± 0.5% | 1147.3 ± 3.7% | 2.255 | 9.705 | 121.300 | 3.805 | 29.682 |
| hex: silesia/webster | 524290 | 34075.7 ± 0.1% | 15117.2 ± 0.1% | 3573.3 ± 0.1% | 454.8 ± 0.3% | 8968.7 ± 0.2% | 1146.6 ± 0.2% | 2.254 | 9.536 | 74.932 | 3.799 | 29.718 |
| hex: silesia/x-ray | 524290 | 34067.1 ± 0.3% | 15134.0 ± 0.1% | 3494.4 ± 0.1% | 427.5 ± 0.3% | 8954.2 ± 0.6% | 1143.0 ± 1.0% | 2.251 | 9.749 | 79.698 | 3.805 | 29.805 |
| hex: silesia/xml | 524290 | 34063.7 ± 0.2% | 15127.3 ± 0.2% | 3575.9 ± 3.2% | 728.4 ± 0.3% | 8947.3 ± 0.1% | 1143.5 ± 0.6% | 2.252 | 9.526 | 46.767 | 3.807 | 29.788 |
| hex: canterbury/alice29.txt | 304180 | 33971.6 ± 0.4% | 14184.0 ± 0.1% | 3577.6 ± 0.1% | 484.3 ± 0.6% | 8964.5 ± 0.5% | 1155.6 ± 0.3% | 2.395 | 9.496 | 70.142 | 3.790 | 29.396 |
| hex: canterbury/asyoulik.txt | 250360 | 34001.2 ± 2.8% | 15006.5 ± 1.1% | 3513.1 ± 0.2% | 470.8 ± 0.5% | 8941.2 ± 0.3% | 1152.8 ± 4.5% | 2.266 | 9.679 | 72.216 | 3.803 | 29.494 |
| hex: canterbury/cp.html | 49208 | 33491.0 ± 0.1% | 14503.0 ± 0.1% | 3581.2 ± 4.3% | 512.1 ± 0.7% | 9292.5 ± 0.1% | 1137.1 ± 3.5% | 2.309 | 9.352 | 65.397 | 3.604 | 29.453 |
| hex: canterbury/fields.c | 22302 | 33148.1 ± 0.2% | 17752.9 ± 0.4% | 3684.9 ± 0.4% | 570.7 ± 0.8% | 9281.4 ± 0.5% | 1101.9 ± 1.6% | 1.867 | 8.996 | 58.086 | 3.571 | 30.082 |
| hex: canterbury/grammar.lsp | 7444 | 29977.3 ± 0.1% | 17316.3 ± 1.6% | 3639.5 ± 2.3% | 744.7 ± 0.9% | 8981.6 ± 0.1% | 1079.5 ± 1.7% | 1.731 | 8.237 | 40.253 | 3.338 | 27.769 |
| hex: canterbury/kennedy.xls | 524290 | 34033.5 ± 0.3% | 15132.7 ± 0.1% | 3579.7 ± 0.3% | 759.0 ± 0.9% | 8942.5 ± 0.9% | 1130.8 ± 5.0% | 2.249 | 9.507 | 44.839 | 3.806 | 30.096 |
| hex: canterbury/lcet10.txt | 524290 | 34057.3 ± 0.2% | 15123.2 ± 0.3% | 3557.1 ± 0.1% | 484.0 ± 0.1% | 8941.4 ± 0.3% | 1143.8 ± 1.3% | 2.252 | 9.574 | 70.362 | 3.809 | 29.776 |
| hex: canterbury/plrabn12.txt | 524290 | 34059.8 ± 0.1% | 15133.9 ± 0.1% | 3564.6 ± 0.4% | 466.6 ± 0.3% | 8950.0 ± 0.7% | 1144.4 ± 0.7% | 2.251 | 9.555 | 73.003 | 3.806 | 29.762 |
| hex: canterbury/ptt5 | 524290 | 34067.0 ± 0.1% | 15125.6 ± 0.1% | 3510.8 ± 0.1% | 667.0 ± 0.2% | 8930.4 ± 0.1% | 1146.9 ± 1.4% | 2.252 | 9.703 | 51.071 | 3.815 | 29.704 |
| hex: canterbury/sum | 76482 | 33478.8 ± 0.2% | 15502.2 ± 0.1% | 3579.8 ± 0.2% | 587.5 ± 0.4% | 8959.1 ± 0.2% | 1124.2 ± 4.1% | 2.160 | 9.352 | 56.982 | 3.737 | 29.779 |
| hex: canterbury/xargs.1 | 8456 | 30465.9 ± 0.1% | 17471.0 ± 0.2% | 3577.7 ± 0.1% | 729.2 ± 1.4% | 9014.1 ± 0.2% | 1116.4 ± 1.5% | 1.744 | 8.516 | 41.777 | 3.380 | 27.288 |
| hex: canterbury-large/E.coli | 524290 | 34055.8 ± 0.1% | 14444.5 ± 0.2% | 3514.2 ± 0.1% | 966.6 ± 0.1% | 8950.7 ± 0.2% | 1131.9 ± 8.2% | 2.358 | 9.691 | 35.234 | 3.805 | 30.088 |
| hex: canterbury-large/bible.txt | 524290 | 34062.8 ± 0.2% | 14431.8 ± 0.1% | 3515.0 ± 0.1% | 500.9 ± 0.4% | 8946.0 ± 0.3% | 1162.7 ± 1.0% | 2.360 | 9.691 | 67.999 | 3.808 | 29.296 |
| hex: canterbury-large/world192.txt | 524290 | 34074.6 ± 0.1% | 14441.4 ± 0.0% | 3584.8 ± 0.1% | 468.9 ± 0.5% | 8964.0 ± 0.2% | 1162.6 ± 4.2% | 2.360 | 9.505 | 72.673 | 3.801 | 29.308 |
| hex: http/html-1kx1024 | 2099200 | 15092.2 ± 0.3% | 12211.9 ± 0.2% | 3230.9 ± 0.2% | 507.0 ± 0.3% | 7405.5 ± 0.6% | 1006.7 ± 1.9% | 1.236 | 4.671 | 29.769 | 2.038 | 14.991 |
| hex: http/html-16kx64 | 2097280 | 27278.3 ± 3.5% | 14075.2 ± 0.3% | 3427.5 ± 0.1% | 514.5 ± 0.4% | 8464.9 ± 1.1% | 1105.9 ± 2.7% | 1.938 | 7.959 | 53.017 | 3.223 | 24.667 |
| hex: http/html-1m | 524290 | 34066.3 ± 3.1% | 15121.1 ± 0.4% | 3509.1 ± 0.3% | 509.0 ± 0.6% | 8942.5 ± 0.2% | 1159.7 ± 2.9% | 2.253 | 9.708 | 66.927 | 3.809 | 29.374 |
| hex: http/json-1kx1024 | 2099200 | 15149.9 ± 0.1% | 12265.8 ± 12.5% | 3226.8 ± 2.8% | 672.1 ± 2.4% | 7401.5 ± 2.1% | 1018.0 ± 1.0% | 1.235 | 4.695 | 22.541 | 2.047 | 14.883 |
| hex: http/json-16kx64 | 2097280 | 28335.5 ± 0.4% | 14047.5 ± 0.2% | 3432.1 ± 0.2% | 687.6 ± 0.8% | 8592.0 ± 1.1% | 1120.0 ± 1.9% | 2.017 | 8.256 | 41.212 | 3.298 | 25.300 |
| hex: http/json-1m | 524290 | 34064.7 ± 0.2% | 15147.3 ± 0.0% | 3584.9 ± 0.1% | 701.4 ± 0.6% | 8960.0 ± 0.1% | 1158.7 ± 1.0% | 2.249 | 9.502 | 48.563 | 3.802 | 29.400 |
| hex: http/js-1kx1024 | 2099200 | 15153.0 ± 4.6% | 12143.4 ± 5.8% | 3225.2 ± 0.4% | 489.5 ± 0.6% | 7451.9 ± 0.9% | 1019.3 ± 0.7% | 1.248 | 4.698 | 30.959 | 2.033 | 14.865 |
| hex: http/js-16kx64 | 2097280 | 28056.0 ± 2.8% | 14023.0 ± 0.2% | 3422.9 ± 0.0% | 496.7 ± 0.5% | 8754.3 ± 0.4% | 1117.3 ± 0.6% | 2.001 | 8.197 | 56.480 | 3.205 | 25.110 |
| hex: http/js-1m | 524290 | 34067.6 ± 0.3% | 15149.3 ± 0.2% | 3558.7 ± 0.2% | 515.1 ± 0.4% | 8961.6 ± 0.4% | 1158.5 ± 1.7% | 2.249 | 9.573 | 66.144 | 3.802 | 29.406 |
| hex: http/css-1kx1024 | 2099200 | 15209.3 ± 0.5% | 12012.1 ± 0.3% | 3228.1 ± 0.3% | 572.1 ± 4.0% | 7410.0 ± 0.6% | 1013.6 ± 1.4% | 1.266 | 4.711 | 26.584 | 2.053 | 15.004 |
| hex: http/css-16kx64 | 2097280 | 28416.8 ± 0.2% | 14045.1 ± 0.3% | 3432.5 ± 3.2% | 583.3 ± 0.8% | 8652.6 ± 1.0% | 1102.4 ± 2.4% | 2.023 | 8.279 | 48.720 | 3.284 | 25.778 |
| hex: http/css-1m | 524290 | 34052.5 ± 0.1% | 15113.2 ± 2.6% | 3578.0 ± 0.1% | 561.8 ± 0.6% | 8946.7 ± 5.2% | 1114.6 ± 3.0% | 2.253 | 9.517 | 60.615 | 3.806 | 30.551 |
| hex: shuffled/dickens-1m | 524290 | 34034.0 ± 0.2% | 15122.7 ± 0.2% | 3504.1 ± 0.4% | 478.4 ± 0.6% | 8948.2 ± 0.1% | 1104.1 ± 4.0% | 2.251 | 9.713 | 71.146 | 3.803 | 30.824 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1591.6 ± 0.4% | 1483.2 ± 0.3% | 1033.5 ± 0.2% | 465.0 ± 0.4% | 441.4 ± 1.0% | 505.8 ± 0.6% | 1.073 | 1.540 | 3.423 | 3.606 | 3.146 |
| qlog records, JSON text sequence | 1467503 | 1453.7 ± 0.1% | 1242.5 ± 1.6% | 953.6 ± 3.2% | 429.1 ± 4.3% | 539.7 ± 0.7% | 355.2 ± 0.6% | 1.170 | 1.524 | 3.388 | 2.693 | 4.092 |
| messages: 11 string members | 1025025 | 1270.9 ± 0.4% | 1117.1 ± 3.7% | 779.0 ± 0.3% | 413.0 ± 1.3% | 421.4 ± 0.7% | 436.5 ± 0.3% | 1.138 | 1.632 | 3.077 | 3.016 | 2.911 |
| messages: 50 nested objects | 1121600 | 1720.0 ± 0.4% | 1893.5 ± 1.1% | 1356.0 ± 0.5% | 596.0 ± 0.8% | 612.7 ± 1.0% | 511.8 ± 0.8% | 0.908 | 1.268 | 2.886 | 2.807 | 3.361 |
| messages: a tree of 341 objects | 612600 | 500.7 ± 0.2% | 689.5 ± 1.5% | 582.4 ± 0.5% | 334.5 ± 0.7% | 356.2 ± 0.8% | 223.1 ± 1.6% | 0.726 | 0.860 | 1.497 | 1.406 | 2.244 |
| string: silesia/dickens | 172528 | 13062.4 ± 0.5% | 3958.9 ± 1.3% | 3100.7 ± 2.2% | 335.1 ± 0.8% | 1535.2 ± 2.2% | 1189.6 ± 0.6% | 3.300 | 4.213 | 38.983 | 8.509 | 10.981 |
| string: silesia/nci | 1075110 | 11363.8 ± 0.3% | 4757.6 ± 0.8% | 3136.0 ± 0.4% | 915.6 ± 0.6% | 1597.4 ± 0.9% | 1210.3 ± 1.8% | 2.389 | 3.624 | 12.411 | 7.114 | 9.389 |
| string: silesia/reymont | 1075159 | 5398.3 ± 0.9% | 1880.2 ± 0.9% | 1896.8 ± 0.2% | 379.0 ± 0.8% | 1307.8 ± 1.0% | 1050.7 ± 1.1% | 2.871 | 2.846 | 14.242 | 4.128 | 5.138 |
| string: silesia/samba | 97582 | 6363.7 ± 0.4% | 2722.1 ± 0.3% | 4085.1 ± 0.2% | 350.6 ± 0.4% | 1277.0 ± 1.1% | 1180.6 ± 0.4% | 2.338 | 1.558 | 18.149 | 4.983 | 5.390 |
| string: silesia/webster | 1098490 | 7192.7 ± 0.5% | 1996.8 ± 0.4% | 1774.8 ± 0.9% | 353.9 ± 0.8% | 1274.0 ± 1.9% | 613.3 ± 0.5% | 3.602 | 4.053 | 20.322 | 5.646 | 11.728 |
| string: silesia/xml | 1090118 | 10866.7 ± 0.5% | 3224.8 ± 0.5% | 2533.5 ± 0.2% | 608.7 ± 0.8% | 1725.8 ± 0.5% | 987.4 ± 3.8% | 3.370 | 4.289 | 17.852 | 6.296 | 11.006 |
| string: canterbury/alice29.txt | 159425 | 12839.1 ± 0.4% | 2898.0 ± 1.2% | 3032.1 ± 5.4% | 320.0 ± 1.0% | 1372.0 ± 1.2% | 1100.2 ± 0.7% | 4.430 | 4.234 | 40.119 | 9.358 | 11.670 |
| string: canterbury/asyoulik.txt | 132198 | 11235.4 ± 6.0% | 2119.2 ± 0.4% | 3133.2 ± 0.7% | 317.9 ± 0.7% | 1246.2 ± 1.0% | 961.6 ± 4.0% | 5.302 | 3.586 | 35.346 | 9.015 | 11.684 |
| string: canterbury/lcet10.txt | 441884 | 13014.3 ± 1.0% | 3100.8 ± 0.9% | 2599.4 ± 0.6% | 370.3 ± 1.0% | 1489.1 ± 1.4% | 1201.9 ± 0.5% | 4.197 | 5.007 | 35.143 | 8.740 | 10.828 |
| string: canterbury/plrabn12.txt | 503330 | 9038.3 ± 0.8% | 2326.6 ± 0.3% | 2107.9 ± 1.8% | 351.1 ± 1.1% | 1373.3 ± 2.5% | 1126.5 ± 1.2% | 3.885 | 4.288 | 25.746 | 6.582 | 8.023 |
| string: canterbury-large/E.coli | 1048578 | 31909.9 ± 0.1% | 16417.2 ± 1.2% | 3504.0 ± 0.1% | 1702.9 ± 0.2% | 3162.8 ± 0.4% | 1425.6 ± 0.2% | 1.944 | 9.107 | 18.739 | 10.089 | 22.384 |
| string: canterbury-large/bible.txt | 1055886 | 9774.2 ± 0.4% | 4943.3 ± 0.3% | 3021.3 ± 0.2% | 408.3 ± 0.8% | 2033.8 ± 0.2% | 1503.0 ± 0.2% | 1.977 | 3.235 | 23.936 | 4.806 | 6.503 |
| string: canterbury-large/world192.txt | 1103121 | 6722.1 ± 0.7% | 1750.1 ± 0.1% | 1890.4 ± 1.3% | 349.7 ± 0.7% | 1278.7 ± 0.8% | 973.9 ± 0.6% | 3.841 | 3.556 | 19.221 | 5.257 | 6.902 |
| string: http/html-1m | 1058582 | 10316.0 ± 0.6% | 4351.7 ± 0.5% | 2895.9 ± 1.1% | 423.1 ± 0.4% | 2026.9 ± 0.4% | 858.5 ± 0.4% | 2.371 | 3.562 | 24.380 | 5.090 | 12.017 |
| string: http/json-1m | 1190272 | 8437.7 ± 0.4% | 1605.9 ± 0.5% | 1590.3 ± 0.1% | 561.1 ± 0.4% | 1023.9 ± 0.7% | 849.9 ± 0.8% | 5.254 | 5.306 | 15.038 | 8.241 | 9.928 |
| string: http/js-1m | 1144362 | 6588.9 ± 1.0% | 1136.0 ± 0.3% | 1393.3 ± 0.2% | 333.3 ± 0.4% | 1039.3 ± 1.5% | 765.8 ± 0.7% | 5.800 | 4.729 | 19.767 | 6.340 | 8.604 |
| string: http/css-1m | 1097820 | 9317.0 ± 0.5% | 1497.0 ± 1.4% | 2308.8 ± 1.6% | 511.8 ± 0.1% | 1135.1 ± 0.7% | 887.4 ± 4.1% | 6.224 | 4.035 | 18.203 | 8.208 | 10.500 |
| string: dickens as Cyrillic and CJK | 1883069 | 5526.1 ± 0.3% | 3660.2 ± 0.4% | 491.6 ± 0.2% | 247.8 ± 0.5% | 458.5 ± 0.7% | 359.9 ± 0.4% | 1.510 | 11.241 | 22.298 | 12.054 | 15.356 |
| hex: silesia/dickens | 524290 | 42715.3 ± 0.7% | 2615.8 ± 8.9% | 1512.8 ± 0.1% | 462.4 ± 0.1% | 1522.7 ± 0.5% | 1075.8 ± 0.3% | 16.329 | 28.237 | 92.374 | 28.053 | 39.707 |
| hex: silesia/mozilla | 524290 | 43872.8 ± 0.0% | 2604.5 ± 0.2% | 1511.0 ± 0.1% | 385.0 ± 1.5% | 1514.6 ± 0.4% | 1074.9 ± 0.1% | 16.845 | 29.036 | 113.941 | 28.966 | 40.814 |
| hex: silesia/mr | 524290 | 43905.3 ± 0.1% | 2601.8 ± 0.1% | 1511.4 ± 0.1% | 595.7 ± 0.2% | 1512.6 ± 0.6% | 1075.1 ± 0.1% | 16.875 | 29.050 | 73.706 | 29.027 | 40.837 |
| hex: silesia/nci | 524290 | 43861.9 ± 0.0% | 2592.5 ± 0.1% | 1508.8 ± 0.1% | 749.7 ± 0.1% | 1506.7 ± 1.1% | 1075.9 ± 0.2% | 16.918 | 29.071 | 58.505 | 29.111 | 40.769 |
| hex: silesia/ooffice | 524290 | 43848.9 ± 0.1% | 2620.3 ± 0.2% | 1518.9 ± 1.1% | 314.8 ± 4.1% | 1516.2 ± 0.9% | 1076.1 ± 0.4% | 16.734 | 28.868 | 139.273 | 28.920 | 40.747 |
| hex: silesia/osdb | 524290 | 42294.1 ± 0.2% | 2608.7 ± 0.6% | 1513.5 ± 0.3% | 431.8 ± 0.2% | 1571.3 ± 0.4% | 1074.9 ± 0.2% | 16.213 | 27.944 | 97.948 | 26.916 | 39.347 |
| hex: silesia/reymont | 524290 | 43881.2 ± 0.1% | 2608.6 ± 0.1% | 1516.7 ± 0.1% | 482.9 ± 0.2% | 1521.3 ± 0.5% | 1075.0 ± 0.2% | 16.822 | 28.932 | 90.870 | 28.844 | 40.819 |
| hex: silesia/samba | 524290 | 43932.0 ± 0.2% | 2606.1 ± 0.2% | 1513.5 ± 0.2% | 339.6 ± 1.2% | 1571.2 ± 1.3% | 1072.0 ± 5.9% | 16.857 | 29.027 | 129.368 | 27.961 | 40.980 |
| hex: silesia/sao | 524290 | 43903.9 ± 0.1% | 2621.2 ± 0.1% | 1516.9 ± 0.3% | 272.1 ± 5.7% | 1524.1 ± 5.1% | 1074.5 ± 5.9% | 16.750 | 28.943 | 161.350 | 28.806 | 40.861 |
| hex: silesia/webster | 524290 | 44193.7 ± 0.0% | 2612.5 ± 0.6% | 1515.6 ± 0.1% | 437.5 ± 3.5% | 1565.1 ± 4.9% | 1072.8 ± 0.4% | 16.916 | 29.160 | 101.014 | 28.236 | 41.196 |
| hex: silesia/x-ray | 524290 | 43922.2 ± 0.2% | 2617.1 ± 0.3% | 1516.8 ± 4.4% | 420.1 ± 3.1% | 1525.4 ± 0.4% | 1075.9 ± 0.1% | 16.783 | 28.957 | 104.553 | 28.793 | 40.824 |
| hex: silesia/xml | 524290 | 43818.4 ± 0.1% | 2614.3 ± 0.2% | 1514.0 ± 4.4% | 693.6 ± 0.2% | 1571.8 ± 0.2% | 1074.5 ± 0.1% | 16.761 | 28.942 | 63.171 | 27.877 | 40.782 |
| hex: canterbury/alice29.txt | 304180 | 41842.0 ± 5.9% | 2625.4 ± 0.2% | 1529.5 ± 0.2% | 470.7 ± 0.1% | 1562.8 ± 0.3% | 1091.3 ± 0.1% | 15.937 | 27.356 | 88.899 | 26.773 | 38.342 |
| hex: canterbury/asyoulik.txt | 250360 | 43787.0 ± 1.0% | 2630.6 ± 0.1% | 1545.4 ± 0.1% | 459.3 ± 0.2% | 1566.5 ± 0.5% | 1092.9 ± 0.2% | 16.645 | 28.334 | 95.342 | 27.952 | 40.066 |
| hex: canterbury/cp.html | 49208 | 42808.7 ± 0.1% | 2598.7 ± 0.4% | 1530.2 ± 6.0% | 482.5 ± 0.5% | 1594.9 ± 0.1% | 1096.7 ± 0.3% | 16.473 | 27.975 | 88.726 | 26.841 | 39.034 |
| hex: canterbury/fields.c | 22302 | 42674.7 ± 5.2% | 2654.4 ± 0.4% | 1538.7 ± 7.0% | 604.9 ± 0.6% | 1612.9 ± 0.1% | 1103.7 ± 0.1% | 16.077 | 27.734 | 70.551 | 26.458 | 38.666 |
| hex: canterbury/grammar.lsp | 7444 | 40811.1 ± 0.3% | 2715.2 ± 0.3% | 1546.7 ± 0.1% | 816.8 ± 0.5% | 1617.5 ± 0.1% | 1112.8 ± 0.4% | 15.031 | 26.385 | 49.964 | 25.231 | 36.673 |
| hex: canterbury/kennedy.xls | 524290 | 43870.2 ± 0.1% | 2605.5 ± 0.1% | 1513.8 ± 0.0% | 793.1 ± 0.2% | 1563.9 ± 6.1% | 1070.1 ± 0.4% | 16.837 | 28.981 | 55.314 | 28.051 | 40.997 |
| hex: canterbury/lcet10.txt | 524290 | 43836.4 ± 0.0% | 2608.9 ± 0.5% | 1514.6 ± 0.3% | 469.2 ± 1.3% | 1566.4 ± 3.9% | 1072.6 ± 0.2% | 16.803 | 28.943 | 93.425 | 27.986 | 40.868 |
| hex: canterbury/plrabn12.txt | 524290 | 43909.4 ± 0.3% | 2614.2 ± 0.1% | 1515.4 ± 4.0% | 456.5 ± 1.9% | 1567.7 ± 2.7% | 1069.7 ± 0.6% | 16.797 | 28.976 | 96.196 | 28.009 | 41.047 |
| hex: canterbury/ptt5 | 524290 | 43897.8 ± 0.3% | 2596.7 ± 0.3% | 1510.1 ± 3.9% | 596.3 ± 4.4% | 1556.0 ± 1.4% | 1072.7 ± 0.0% | 16.905 | 29.070 | 73.613 | 28.213 | 40.924 |
| hex: canterbury/sum | 76482 | 43190.1 ± 0.1% | 2614.6 ± 0.1% | 1525.7 ± 0.1% | 564.1 ± 0.5% | 1586.5 ± 0.1% | 1093.4 ± 4.9% | 16.519 | 28.308 | 76.569 | 27.223 | 39.500 |
| hex: canterbury/xargs.1 | 8456 | 41205.4 ± 0.1% | 2696.2 ± 7.2% | 1548.3 ± 0.3% | 843.0 ± 0.3% | 1617.0 ± 0.5% | 1115.1 ± 0.5% | 15.283 | 26.613 | 48.877 | 25.483 | 36.952 |
| hex: canterbury-large/E.coli | 524290 | 42078.6 ± 0.1% | 2606.0 ± 0.3% | 1513.5 ± 0.2% | 820.1 ± 0.1% | 1571.9 ± 0.3% | 1073.1 ± 0.2% | 16.147 | 27.802 | 51.311 | 26.770 | 39.211 |
| hex: canterbury-large/bible.txt | 524290 | 43954.8 ± 0.1% | 2614.3 ± 7.8% | 1516.8 ± 4.6% | 483.8 ± 0.2% | 1555.7 ± 1.6% | 1073.4 ± 0.4% | 16.813 | 28.979 | 90.844 | 28.254 | 40.947 |
| hex: canterbury-large/world192.txt | 524290 | 43627.4 ± 0.2% | 2612.9 ± 0.1% | 1516.5 ± 0.3% | 461.7 ± 0.4% | 1570.2 ± 1.1% | 1072.6 ± 0.1% | 16.697 | 28.769 | 94.494 | 27.784 | 40.676 |
| hex: http/html-1kx1024 | 2099200 | 21183.7 ± 0.2% | 2377.9 ± 1.2% | 1464.8 ± 3.9% | 502.9 ± 0.1% | 1507.4 ± 0.9% | 1083.2 ± 0.1% | 8.908 | 14.462 | 42.124 | 14.053 | 19.557 |
| hex: http/html-16kx64 | 2097280 | 22759.3 ± 0.1% | 2139.4 ± 5.6% | 1457.1 ± 0.3% | 506.6 ± 0.2% | 1458.2 ± 0.2% | 1090.7 ± 0.2% | 10.638 | 15.619 | 44.922 | 15.608 | 20.868 |
| hex: http/html-1m | 524290 | 43900.1 ± 0.0% | 2612.0 ± 0.4% | 1516.9 ± 0.2% | 488.8 ± 0.1% | 1533.7 ± 0.9% | 1070.4 ± 0.2% | 16.807 | 28.941 | 89.810 | 28.623 | 41.015 |
| hex: http/json-1kx1024 | 2099200 | 21947.6 ± 0.8% | 2341.2 ± 0.6% | 1459.6 ± 0.6% | 699.6 ± 0.2% | 1500.1 ± 0.8% | 1083.4 ± 0.1% | 9.375 | 15.036 | 31.370 | 14.631 | 20.258 |
| hex: http/json-16kx64 | 2097280 | 22571.5 ± 0.3% | 2224.1 ± 0.1% | 1451.2 ± 0.1% | 708.9 ± 0.2% | 1452.8 ± 0.1% | 1086.5 ± 0.4% | 10.149 | 15.553 | 31.839 | 15.536 | 20.775 |
| hex: http/json-1m | 524290 | 43716.4 ± 0.1% | 2605.9 ± 0.4% | 1513.0 ± 0.1% | 738.8 ± 0.7% | 1570.0 ± 0.4% | 1075.1 ± 0.2% | 16.776 | 28.894 | 59.173 | 27.845 | 40.664 |
| hex: http/js-1kx1024 | 2099200 | 20466.7 ± 0.4% | 2343.6 ± 0.9% | 1460.7 ± 0.4% | 492.7 ± 0.3% | 1503.9 ± 0.8% | 1084.0 ± 0.3% | 8.733 | 14.011 | 41.541 | 13.609 | 18.880 |
| hex: http/js-16kx64 | 2097280 | 22432.6 ± 0.1% | 2236.3 ± 0.3% | 1457.2 ± 0.1% | 494.7 ± 0.2% | 1456.2 ± 0.1% | 1091.2 ± 0.2% | 10.031 | 15.394 | 45.350 | 15.405 | 20.558 |
| hex: http/js-1m | 524290 | 43792.8 ± 0.3% | 2607.3 ± 0.2% | 1517.1 ± 0.2% | 509.7 ± 0.1% | 1568.4 ± 0.7% | 1070.5 ± 0.1% | 16.796 | 28.867 | 85.922 | 27.921 | 40.910 |
| hex: http/css-1kx1024 | 2099200 | 22564.6 ± 0.1% | 2389.8 ± 2.7% | 1466.6 ± 0.5% | 559.5 ± 0.3% | 1521.0 ± 0.9% | 1082.9 ± 1.9% | 9.442 | 15.385 | 40.333 | 14.835 | 20.837 |
| hex: http/css-16kx64 | 2097280 | 22065.8 ± 0.0% | 2238.0 ± 0.3% | 1457.6 ± 0.0% | 566.7 ± 0.1% | 1458.8 ± 0.1% | 1090.8 ± 0.0% | 9.859 | 15.139 | 38.934 | 15.126 | 20.230 |
| hex: http/css-1m | 524290 | 43867.0 ± 0.3% | 2615.5 ± 0.2% | 1515.0 ± 0.2% | 535.4 ± 0.4% | 1519.9 ± 0.7% | 1074.7 ± 3.2% | 16.772 | 28.955 | 81.938 | 28.862 | 40.816 |
| hex: shuffled/dickens-1m | 524290 | 42694.9 ± 0.9% | 2605.4 ± 0.3% | 1515.6 ± 0.1% | 464.8 ± 0.1% | 1569.7 ± 0.6% | 1075.9 ± 0.3% | 16.387 | 28.171 | 91.860 | 27.199 | 39.682 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- qlog records, JSON text sequence, decoding: stdx runs at 0.889 of simdjson.
- messages: 11 string members, decoding: stdx runs at 0.533 of simdjson.
- messages: 50 nested objects, decoding: stdx runs at 0.766 of simdjson.
- messages: 50 nested objects, decoding: stdx runs at 0.921 of yyjson.
- messages: a tree of 341 objects, decoding: stdx runs at 0.785 of simdjson.
- messages: a tree of 341 objects, encoding: stdx runs at 0.875 of simdjson.
- messages: a tree of 341 objects, encoding with J11's loop unchecked: stdx runs at 0.945 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.750 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.801 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.882 of yyjson.
- messages: 11 string members, decoding through TextReader.next: stdx runs at 0.473 of simdjson.
- messages: 50 nested objects, decoding through TextReader.next: stdx runs at 0.706 of simdjson.
- messages: 50 nested objects, decoding through TextReader.next: stdx runs at 0.849 of yyjson.
- messages: a tree of 341 objects, decoding through TextReader.next: stdx runs at 0.646 of simdjson.
- messages: a tree of 341 objects, decoding through TextReader.next: stdx runs at 0.786 of yyjson.
- messages: a tree of 341 objects, decoding through TextReader.next: stdx runs at 0.901 of serde_json.
- CLDR supplemental, 34 texts, decoding through TextReader.next_items: stdx runs at 0.838 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next_items: stdx runs at 0.919 of simdjson.
- messages: 11 string members, decoding through TextReader.next_items: stdx runs at 0.510 of simdjson.
- messages: 50 nested objects, decoding through TextReader.next_items: stdx runs at 0.742 of simdjson.
- messages: 50 nested objects, decoding through TextReader.next_items: stdx runs at 0.892 of yyjson.
- messages: a tree of 341 objects, decoding through TextReader.next_items: stdx runs at 0.766 of simdjson.
- messages: a tree of 341 objects, decoding through TextReader.next_items: stdx runs at 0.931 of yyjson.
- messages: 50 nested objects, encoding through TextWriter's methods: stdx runs at 0.908 of simdjson.
- messages: a tree of 341 objects, encoding through TextWriter's methods: stdx runs at 0.726 of simdjson.
- messages: a tree of 341 objects, encoding through TextWriter's methods: stdx runs at 0.860 of yyjson.
