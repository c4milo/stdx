# bench-json

| Field | Value |
|---|---|
| Commit | d843c6f |
| Runner label | ubuntu-24.04 |
| Image version | 20261111.127.1 |
| CPU model | Intel(R) Xeon(R) 6975P-C |
| Virtual CPUs | 4 |
| Kernel | 7.0.0-1014-aws |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/43654495501 |
| Date | 2026-11-14 |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1. The `TextReader.next_items` column is that helper's queued tokens a slice a call (decision 79), over many tokens a call.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | TextReader.next_items | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1379.4 ± 0.9% | 0.492 | 1.026 | 1.071 | 1.072 | 0.412 | 1.076 | 1.071 | 0.373 | 0.836 | 0.931 | 0.107 |
| qlog records, JSON text sequence | 1467503 | 1099.6 ± 0.3% | 0.793 | 1.054 | 1.063 | 1.059 | 0.384 | 1.062 | 1.059 | 0.366 | 0.927 | 1.041 | 0.125 |
| messages: 11 string members | 1025025 | 1058.7 ± 1.8% | 0.588 | 1.003 | 1.015 | 1.024 | 0.547 | 1.014 | 1.025 | 0.547 | 0.891 | 0.964 | 0.138 |
| messages: 50 nested objects | 1121600 | 1346.7 ± 0.1% | 0.805 | 1.088 | 1.086 | 1.088 | 0.397 | 1.095 | 1.089 | 0.351 | 0.924 | 0.967 | 0.114 |
| string: silesia/dickens | 172528 | 6723.3 ± 0.1% | 0.029 | 0.703 | 1.098 | 1.095 | 0.208 | 1.023 | 1.106 | 0.208 | 1.001 | 1.000 | 0.029 |
| string: silesia/nci | 1075110 | 5395.3 ± 0.5% | 0.036 | 0.711 | 1.031 | 1.033 | 0.306 | 1.037 | 1.032 | 0.306 | 1.005 | 1.007 | 0.036 |
| string: silesia/reymont | 1075159 | 3536.3 ± 2.9% | 0.055 | 0.627 | 0.869 | 0.868 | 0.355 | 0.817 | 0.874 | 0.355 | 0.985 | 0.992 | 0.055 |
| string: silesia/samba | 97582 | 3999.4 ± 1.3% | 0.041 | 0.900 | 1.063 | 1.064 | 0.075 | 0.858 | 1.064 | 0.075 | 1.006 | 1.005 | 0.041 |
| string: silesia/webster | 1098490 | 4387.4 ± 0.8% | 0.043 | 0.648 | 0.983 | 0.987 | 0.228 | 0.926 | 0.997 | 0.229 | 1.002 | 1.010 | 0.043 |
| string: silesia/xml | 1090118 | 6039.1 ± 0.2% | 0.032 | 0.775 | 0.965 | 0.967 | 0.252 | 0.959 | 0.972 | 0.252 | 1.005 | 1.009 | 0.032 |
| string: canterbury/alice29.txt | 159425 | 5781.7 ± 1.8% | 0.033 | 0.755 | 1.082 | 1.143 | 0.186 | 1.020 | 1.166 | 0.187 | 0.999 | 1.008 | 0.033 |
| string: canterbury/asyoulik.txt | 132198 | 4319.6 ± 0.6% | 0.042 | 0.805 | 1.129 | 1.120 | 0.201 | 1.042 | 1.128 | 0.202 | 0.998 | 1.005 | 0.042 |
| string: canterbury/lcet10.txt | 441884 | 6677.8 ± 0.7% | 0.029 | 0.607 | 1.099 | 1.111 | 0.201 | 1.036 | 1.119 | 0.201 | 1.003 | 1.004 | 0.029 |
| string: canterbury/plrabn12.txt | 503330 | 5501.5 ± 0.1% | 0.035 | 0.774 | 0.967 | 0.974 | 0.229 | 0.861 | 0.974 | 0.230 | 1.002 | 1.002 | 0.035 |
| string: canterbury-large/E.coli | 1048578 | 30374.9 ± 3.8% | 0.059 | 1.012 | 0.788 | 1.010 | 0.519 | 1.012 | 1.011 | 0.520 | 1.122 | 1.125 | 0.007 |
| string: canterbury-large/bible.txt | 1055886 | 8495.8 ± 0.5% | 0.024 | 0.630 | 0.878 | 0.886 | 0.401 | 0.888 | 0.900 | 0.401 | 1.002 | 1.011 | 0.024 |
| string: canterbury-large/world192.txt | 1103121 | 4130.4 ± 0.5% | 0.046 | 0.698 | 0.975 | 0.980 | 0.218 | 0.927 | 0.987 | 0.218 | 0.999 | 1.004 | 0.046 |
| string: http/html-1m | 1058582 | 9005.9 ± 4.9% | 0.022 | 0.571 | 0.788 | 0.792 | 0.322 | 0.753 | 0.800 | 0.322 | 0.949 | 1.042 | 0.022 |
| string: http/json-1m | 1190272 | 3264.6 ± 0.8% | 0.053 | 0.402 | 0.450 | 0.454 | 0.152 | 0.465 | 0.455 | 0.152 | 0.996 | 0.997 | 0.054 |
| string: http/js-1m | 1144362 | 2850.6 ± 0.5% | 0.062 | 0.702 | 0.915 | 0.918 | 0.195 | 0.847 | 0.922 | 0.195 | 1.008 | 1.009 | 0.063 |
| string: http/css-1m | 1097820 | 3290.8 ± 0.7% | 0.056 | 0.768 | 0.982 | 0.984 | 0.292 | 0.953 | 0.986 | 0.292 | 1.003 | 1.005 | 0.055 |
| string: dickens as Cyrillic and CJK | 1883069 | 5824.4 ± 0.3% | 0.026 | 0.064 | 0.451 | 0.451 | 0.200 | 0.451 | 0.452 | 0.200 | 0.997 | 1.002 | 0.025 |
| string: dickens as Cyrillic and CJK, as \u escapes | 5075485 | 1204.5 ± 1.2% | 0.112 | 1.000 | 0.998 | 1.000 | 0.106 | 0.714 | 1.000 | 0.106 | 1.008 | 1.007 | 0.112 |
| hex: silesia/dickens | 524290 | 45596.2 ± 0.1% | 0.040 | 1.002 | 0.629 | 1.002 | 0.397 | 0.998 | 1.001 | 0.397 | 0.747 | 0.747 | 0.005 |
| hex: silesia/mozilla | 524290 | 46700.9 ± 0.6% | 0.039 | 0.999 | 0.613 | 0.999 | 0.366 | 0.994 | 0.998 | 0.367 | 0.730 | 0.729 | 0.005 |
| hex: silesia/mr | 524290 | 45833.8 ± 0.3% | 0.040 | 1.003 | 0.621 | 1.003 | 0.392 | 1.000 | 1.003 | 0.393 | 0.743 | 0.743 | 0.005 |
| hex: silesia/nci | 524290 | 45700.3 ± 0.1% | 0.040 | 1.001 | 0.625 | 1.001 | 0.397 | 0.997 | 1.001 | 0.397 | 0.745 | 0.745 | 0.005 |
| hex: silesia/ooffice | 524290 | 46626.1 ± 1.8% | 0.039 | 1.002 | 0.614 | 1.001 | 0.374 | 0.996 | 1.001 | 0.375 | 0.731 | 0.730 | 0.005 |
| hex: silesia/osdb | 524290 | 46033.7 ± 0.6% | 0.040 | 1.003 | 0.622 | 1.002 | 0.392 | 1.000 | 1.001 | 0.393 | 0.740 | 0.739 | 0.005 |
| hex: silesia/reymont | 524290 | 46576.6 ± 0.1% | 0.039 | 1.000 | 0.615 | 0.999 | 0.390 | 0.996 | 0.999 | 0.390 | 0.731 | 0.731 | 0.005 |
| hex: silesia/samba | 524290 | 46677.6 ± 0.7% | 0.039 | 1.005 | 0.602 | 1.003 | 0.387 | 0.998 | 1.004 | 0.387 | 0.730 | 0.729 | 0.005 |
| hex: silesia/sao | 524290 | 44467.5 ± 0.4% | 0.041 | 1.003 | 0.623 | 1.001 | 0.392 | 0.997 | 1.002 | 0.392 | 0.766 | 0.766 | 0.005 |
| hex: silesia/webster | 524290 | 45956.1 ± 0.1% | 0.040 | 1.001 | 0.628 | 1.000 | 0.394 | 0.997 | 1.000 | 0.394 | 0.741 | 0.741 | 0.005 |
| hex: silesia/x-ray | 524290 | 45757.2 ± 0.2% | 0.040 | 1.000 | 0.629 | 1.001 | 0.392 | 0.996 | 1.000 | 0.392 | 0.744 | 0.744 | 0.005 |
| hex: silesia/xml | 524290 | 47459.6 ± 0.5% | 0.039 | 1.002 | 0.603 | 1.000 | 0.383 | 0.991 | 1.001 | 0.383 | 0.718 | 0.718 | 0.005 |
| hex: canterbury/alice29.txt | 304180 | 46393.4 ± 0.3% | 0.040 | 0.999 | 0.616 | 0.999 | 0.390 | 0.997 | 1.001 | 0.391 | 0.734 | 0.733 | 0.005 |
| hex: canterbury/asyoulik.txt | 250360 | 45758.0 ± 0.1% | 0.040 | 0.999 | 0.628 | 0.998 | 0.396 | 0.995 | 0.998 | 0.395 | 0.742 | 0.743 | 0.005 |
| hex: canterbury/cp.html | 49208 | 44566.9 ± 2.5% | 0.041 | 1.001 | 0.628 | 1.000 | 0.391 | 1.001 | 1.000 | 0.394 | 0.753 | 0.753 | 0.005 |
| hex: canterbury/fields.c | 22302 | 52428.4 ± 0.3% | 0.036 | 0.995 | 0.529 | 0.999 | 0.381 | 0.995 | 1.000 | 0.389 | 0.632 | 0.632 | 0.004 |
| hex: canterbury/grammar.lsp | 7444 | 45314.6 ± 0.4% | 0.041 | 1.004 | 0.564 | 1.009 | 0.400 | 0.993 | 1.009 | 0.422 | 0.660 | 0.661 | 0.005 |
| hex: canterbury/kennedy.xls | 524290 | 44676.3 ± 0.3% | 0.041 | 1.000 | 0.609 | 0.998 | 0.402 | 0.998 | 0.998 | 0.403 | 0.762 | 0.762 | 0.005 |
| hex: canterbury/lcet10.txt | 524290 | 48877.9 ± 0.4% | 0.038 | 0.998 | 0.576 | 0.997 | 0.371 | 0.992 | 0.998 | 0.371 | 0.697 | 0.697 | 0.004 |
| hex: canterbury/plrabn12.txt | 524290 | 46023.9 ± 0.2% | 0.040 | 1.000 | 0.616 | 1.000 | 0.394 | 0.995 | 1.000 | 0.394 | 0.740 | 0.740 | 0.005 |
| hex: canterbury/ptt5 | 524290 | 45800.1 ± 0.3% | 0.040 | 1.000 | 0.630 | 1.001 | 0.397 | 0.996 | 1.000 | 0.397 | 0.744 | 0.744 | 0.005 |
| hex: canterbury/sum | 76482 | 46550.8 ± 0.2% | 0.040 | 1.001 | 0.609 | 1.001 | 0.384 | 1.003 | 1.003 | 0.385 | 0.719 | 0.719 | 0.005 |
| hex: canterbury/xargs.1 | 8456 | 46744.4 ± 0.7% | 0.040 | 0.999 | 0.555 | 1.004 | 0.398 | 0.998 | 1.002 | 0.416 | 0.651 | 0.651 | 0.005 |
| hex: canterbury-large/E.coli | 524290 | 47494.5 ± 2.4% | 0.039 | 1.005 | 0.596 | 1.003 | 0.381 | 0.994 | 1.003 | 0.382 | 0.717 | 0.717 | 0.004 |
| hex: canterbury-large/bible.txt | 524290 | 45985.4 ± 0.1% | 0.040 | 1.001 | 0.627 | 1.001 | 0.394 | 0.997 | 1.001 | 0.395 | 0.740 | 0.741 | 0.005 |
| hex: canterbury-large/world192.txt | 524290 | 45696.6 ± 0.2% | 0.040 | 1.002 | 0.627 | 1.001 | 0.395 | 0.997 | 1.000 | 0.396 | 0.746 | 0.746 | 0.005 |
| hex: http/html-1kx1024 | 2099200 | 16718.2 ± 2.7% | 0.108 | 1.021 | 0.844 | 1.001 | 0.592 | 1.008 | 1.002 | 0.651 | 0.873 | 0.852 | 0.013 |
| hex: http/html-16kx64 | 2097280 | 33212.8 ± 0.1% | 0.055 | 1.006 | 0.700 | 1.005 | 0.481 | 1.005 | 1.005 | 0.485 | 0.811 | 0.813 | 0.006 |
| hex: http/html-1m | 524290 | 46446.4 ± 0.5% | 0.040 | 1.002 | 0.616 | 1.002 | 0.391 | 0.998 | 1.001 | 0.392 | 0.733 | 0.733 | 0.005 |
| hex: http/json-1kx1024 | 2099200 | 16455.6 ± 3.0% | 0.110 | 1.023 | 0.856 | 1.007 | 0.617 | 1.012 | 1.007 | 0.678 | 0.885 | 0.864 | 0.013 |
| hex: http/json-16kx64 | 2097280 | 34493.3 ± 0.6% | 0.053 | 1.007 | 0.685 | 1.007 | 0.466 | 1.007 | 1.007 | 0.470 | 0.795 | 0.795 | 0.006 |
| hex: http/json-1m | 524290 | 49040.5 ± 0.4% | 0.038 | 1.000 | 0.586 | 0.999 | 0.370 | 0.992 | 0.999 | 0.370 | 0.695 | 0.695 | 0.004 |
| hex: http/js-1kx1024 | 2099200 | 17001.4 ± 3.8% | 0.107 | 1.020 | 0.839 | 1.003 | 0.606 | 1.007 | 1.002 | 0.666 | 0.872 | 0.851 | 0.012 |
| hex: http/js-16kx64 | 2097280 | 34061.0 ± 0.4% | 0.054 | 1.005 | 0.686 | 1.006 | 0.470 | 1.003 | 1.004 | 0.474 | 0.807 | 0.807 | 0.006 |
| hex: http/js-1m | 524290 | 47083.4 ± 0.3% | 0.039 | 1.002 | 0.608 | 1.000 | 0.385 | 0.996 | 1.002 | 0.385 | 0.724 | 0.723 | 0.005 |
| hex: http/css-1kx1024 | 2099200 | 16724.4 ± 3.9% | 0.108 | 1.027 | 0.851 | 1.010 | 0.596 | 1.015 | 1.010 | 0.656 | 0.880 | 0.861 | 0.013 |
| hex: http/css-16kx64 | 2097280 | 34700.3 ± 0.3% | 0.053 | 1.006 | 0.687 | 1.006 | 0.468 | 1.006 | 1.005 | 0.473 | 0.801 | 0.801 | 0.006 |
| hex: http/css-1m | 524290 | 45672.7 ± 0.2% | 0.040 | 1.003 | 0.631 | 1.003 | 0.395 | 0.998 | 1.002 | 0.396 | 0.746 | 0.745 | 0.005 |
| hex: shuffled/dickens-1m | 524290 | 44935.3 ± 0.8% | 0.041 | 1.004 | 0.635 | 1.004 | 0.393 | 1.002 | 1.003 | 0.394 | 0.758 | 0.758 | 0.005 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1741.8 ± 0.2% | 0.426 | 1.000 | 0.966 | 1.001 | 1.006 | 0.275 | 1.010 | 0.517 | 0.904 | 0.095 | 1.027 |
| qlog records, JSON text sequence | 1467503 | 1693.0 ± 0.3% | 0.617 | 0.950 | 0.958 | 0.990 | 0.966 | 0.231 | 0.965 | 0.433 | 0.848 | 0.105 | 1.011 |
| messages: 11 string members | 1025025 | 1311.0 ± 0.4% | 0.502 | 0.961 | 0.976 | 0.987 | 0.974 | 0.386 | 0.975 | 0.669 | 0.949 | 0.124 | 0.994 |
| messages: 50 nested objects | 1121600 | 1971.6 ± 0.2% | 0.589 | 0.972 | 0.962 | 0.984 | 0.966 | 0.247 | 0.966 | 0.436 | 0.852 | 0.093 | 0.999 |
| string: silesia/dickens | 172528 | 13169.3 ± 0.7% | 0.017 | 0.520 | 0.358 | 0.507 | 0.544 | 0.119 | 0.547 | 0.998 | 1.005 | 0.017 | 1.027 |
| string: silesia/nci | 1075110 | 11096.7 ± 0.3% | 0.020 | 0.534 | 0.381 | 0.543 | 0.532 | 0.188 | 0.534 | 1.001 | 1.002 | 0.020 | 1.043 |
| string: silesia/reymont | 1075159 | 5374.8 ± 1.2% | 0.042 | 0.574 | 0.432 | 0.566 | 0.576 | 0.267 | 0.572 | 0.996 | 1.011 | 0.042 | 1.012 |
| string: silesia/samba | 97582 | 6357.1 ± 0.4% | 0.045 | 0.884 | 0.736 | 0.889 | 0.892 | 0.122 | 0.895 | 1.001 | 1.002 | 0.045 | 1.166 |
| string: silesia/webster | 1098490 | 6866.7 ± 0.6% | 0.033 | 0.589 | 0.412 | 0.563 | 0.593 | 0.159 | 0.591 | 0.993 | 1.004 | 0.033 | 1.016 |
| string: silesia/xml | 1090118 | 10342.0 ± 1.2% | 0.022 | 0.580 | 0.482 | 0.577 | 0.584 | 0.215 | 0.586 | 0.999 | 1.016 | 0.022 | 1.077 |
| string: canterbury/alice29.txt | 159425 | 12700.4 ± 4.0% | 0.018 | 0.440 | 0.362 | 0.422 | 0.463 | 0.093 | 0.477 | 1.000 | 1.004 | 0.018 | 1.059 |
| string: canterbury/asyoulik.txt | 132198 | 10609.2 ± 2.4% | 0.020 | 0.406 | 0.344 | 0.403 | 0.428 | 0.094 | 0.432 | 0.980 | 1.011 | 0.020 | 1.089 |
| string: canterbury/lcet10.txt | 441884 | 12033.7 ± 1.1% | 0.019 | 0.579 | 0.344 | 0.565 | 0.583 | 0.124 | 0.586 | 0.999 | 1.020 | 0.019 | 1.050 |
| string: canterbury/plrabn12.txt | 503330 | 8291.6 ± 0.5% | 0.027 | 0.662 | 0.531 | 0.663 | 0.663 | 0.171 | 0.664 | 1.005 | 1.015 | 0.027 | 1.091 |
| string: canterbury-large/E.coli | 1048578 | 33318.3 ± 0.3% | 0.054 | 1.002 | 1.000 | 0.733 | 1.001 | 0.491 | 1.001 | 1.001 | 1.002 | 0.007 | 1.001 |
| string: canterbury-large/bible.txt | 1055886 | 9236.5 ± 0.2% | 0.026 | 0.775 | 0.595 | 0.774 | 0.786 | 0.411 | 0.790 | 0.995 | 1.004 | 0.026 | 1.052 |
| string: canterbury-large/world192.txt | 1103121 | 6588.6 ± 1.2% | 0.034 | 0.594 | 0.423 | 0.564 | 0.597 | 0.154 | 0.599 | 0.991 | 1.002 | 0.034 | 0.984 |
| string: http/html-1m | 1058582 | 10103.4 ± 0.8% | 0.023 | 0.643 | 0.534 | 0.638 | 0.646 | 0.313 | 0.647 | 1.001 | 1.015 | 0.023 | 1.010 |
| string: http/json-1m | 1190272 | 8252.7 ± 0.3% | 0.025 | 0.187 | 0.164 | 0.188 | 0.187 | 0.075 | 0.188 | 1.001 | 1.003 | 0.025 | 1.025 |
| string: http/js-1m | 1144362 | 6478.2 ± 1.1% | 0.033 | 0.374 | 0.315 | 0.364 | 0.374 | 0.095 | 0.374 | 1.000 | 1.009 | 0.033 | 1.021 |
| string: http/css-1m | 1097820 | 8990.2 ± 0.4% | 0.024 | 0.361 | 0.295 | 0.349 | 0.363 | 0.128 | 0.363 | 1.006 | 1.009 | 0.024 | 1.049 |
| string: dickens as Cyrillic and CJK | 1883069 | 5437.7 ± 1.6% | 0.031 | 0.470 | 0.070 | 0.468 | 0.470 | 0.211 | 0.470 | 1.000 | 1.001 | 0.031 | 1.054 |
| hex: silesia/dickens | 524290 | 43601.9 ± 2.7% | 1.007 | 0.089 | 1.006 | 0.593 | 1.006 | 1.005 | 1.007 | 1.007 | 1.006 | 0.095 | 1.006 |
| hex: silesia/mozilla | 524290 | 42634.7 ± 5.8% | 1.032 | 0.091 | 1.031 | 0.606 | 1.031 | 1.030 | 1.031 | 1.031 | 1.031 | 0.096 | 1.032 |
| hex: silesia/mr | 524290 | 43721.5 ± 7.3% | 1.003 | 0.088 | 1.002 | 0.591 | 1.002 | 1.001 | 1.002 | 1.002 | 1.002 | 0.095 | 1.002 |
| hex: silesia/nci | 524290 | 43903.2 ± 0.1% | 1.002 | 0.088 | 1.000 | 0.588 | 1.000 | 0.999 | 1.001 | 0.999 | 1.000 | 0.091 | 1.000 |
| hex: silesia/ooffice | 524290 | 43617.0 ± 0.2% | 1.001 | 0.088 | 1.001 | 0.592 | 1.001 | 1.000 | 1.001 | 1.001 | 1.001 | 0.091 | 1.001 |
| hex: silesia/osdb | 524290 | 43792.9 ± 0.2% | 1.002 | 0.088 | 1.001 | 0.589 | 1.002 | 0.999 | 1.001 | 1.001 | 1.001 | 0.092 | 1.001 |
| hex: silesia/reymont | 524290 | 43904.3 ± 0.2% | 1.000 | 0.088 | 0.999 | 0.589 | 0.999 | 0.997 | 0.999 | 0.999 | 0.999 | 0.090 | 0.999 |
| hex: silesia/samba | 524290 | 43830.1 ± 0.1% | 1.001 | 0.088 | 1.001 | 0.590 | 1.000 | 1.000 | 1.001 | 1.001 | 1.000 | 0.093 | 1.001 |
| hex: silesia/sao | 524290 | 43870.6 ± 0.1% | 1.001 | 0.088 | 0.999 | 0.587 | 1.001 | 1.000 | 1.000 | 1.000 | 1.000 | 0.094 | 1.000 |
| hex: silesia/webster | 524290 | 44190.5 ± 0.3% | 1.001 | 0.087 | 1.000 | 0.585 | 1.000 | 0.999 | 0.999 | 1.000 | 1.000 | 0.092 | 1.000 |
| hex: silesia/x-ray | 524290 | 43882.7 ± 0.2% | 1.001 | 0.088 | 1.000 | 0.589 | 1.001 | 0.999 | 1.001 | 1.000 | 1.000 | 0.086 | 1.001 |
| hex: silesia/xml | 524290 | 43546.4 ± 0.1% | 0.967 | 0.089 | 1.000 | 0.594 | 1.000 | 0.999 | 0.968 | 1.000 | 1.000 | 0.091 | 1.001 |
| hex: canterbury/alice29.txt | 304180 | 43778.4 ± 0.1% | 1.001 | 0.088 | 1.002 | 0.589 | 1.002 | 1.000 | 1.002 | 1.002 | 1.001 | 0.095 | 1.003 |
| hex: canterbury/asyoulik.txt | 250360 | 43210.3 ± 0.1% | 1.001 | 0.089 | 1.000 | 0.597 | 1.000 | 0.999 | 1.000 | 1.000 | 1.001 | 0.094 | 1.000 |
| hex: canterbury/cp.html | 49208 | 42839.6 ± 0.1% | 1.000 | 0.090 | 1.002 | 0.593 | 1.001 | 0.994 | 1.001 | 1.000 | 0.999 | 0.098 | 1.003 |
| hex: canterbury/fields.c | 22302 | 42315.6 ± 5.4% | 1.000 | 0.091 | 1.000 | 0.597 | 1.001 | 0.988 | 1.000 | 1.002 | 1.008 | 0.098 | 1.002 |
| hex: canterbury/grammar.lsp | 7444 | 39430.4 ± 0.5% | 0.992 | 0.097 | 1.015 | 0.609 | 1.015 | 0.987 | 1.017 | 1.017 | 1.033 | 0.104 | 1.021 |
| hex: canterbury/kennedy.xls | 524290 | 43838.1 ± 0.0% | 1.001 | 0.088 | 1.000 | 0.589 | 1.001 | 1.000 | 1.001 | 1.000 | 1.000 | 0.093 | 1.000 |
| hex: canterbury/lcet10.txt | 524290 | 43702.9 ± 0.1% | 1.002 | 0.088 | 1.000 | 0.589 | 1.001 | 1.000 | 1.001 | 1.000 | 1.001 | 0.093 | 1.001 |
| hex: canterbury/plrabn12.txt | 524290 | 42751.3 ± 0.4% | 1.001 | 0.090 | 1.002 | 0.602 | 1.002 | 1.001 | 1.002 | 1.001 | 1.001 | 0.093 | 1.002 |
| hex: canterbury/ptt5 | 524290 | 43920.5 ± 0.1% | 1.001 | 0.088 | 1.000 | 0.588 | 1.000 | 0.999 | 1.000 | 1.000 | 1.000 | 0.089 | 1.000 |
| hex: canterbury/sum | 76482 | 42953.6 ± 0.1% | 1.001 | 0.090 | 1.000 | 0.593 | 1.001 | 0.998 | 1.000 | 1.002 | 1.005 | 0.097 | 1.002 |
| hex: canterbury/xargs.1 | 8456 | 40435.6 ± 1.6% | 1.002 | 0.094 | 1.001 | 0.600 | 1.001 | 0.950 | 1.001 | 0.989 | 1.022 | 0.101 | 1.004 |
| hex: canterbury-large/E.coli | 524290 | 43899.5 ± 0.1% | 1.001 | 0.084 | 1.000 | 0.589 | 1.000 | 0.999 | 1.000 | 1.000 | 1.000 | 0.094 | 1.000 |
| hex: canterbury-large/bible.txt | 524290 | 43905.1 ± 0.1% | 1.001 | 0.088 | 1.000 | 0.588 | 1.000 | 0.999 | 1.000 | 1.000 | 1.000 | 0.093 | 1.000 |
| hex: canterbury-large/world192.txt | 524290 | 43907.8 ± 0.3% | 1.001 | 0.088 | 1.001 | 0.589 | 1.001 | 0.999 | 1.000 | 1.001 | 1.000 | 0.092 | 0.999 |
| hex: http/html-1kx1024 | 2099200 | 21199.1 ± 0.3% | 1.001 | 0.173 | 1.001 | 0.948 | 1.001 | 0.994 | 1.000 | 1.002 | 1.005 | 0.181 | 1.002 |
| hex: http/html-16kx64 | 2097280 | 22526.6 ± 0.1% | 1.001 | 0.168 | 1.002 | 0.949 | 1.002 | 1.003 | 1.001 | 1.003 | 1.003 | 0.183 | 0.999 |
| hex: http/html-1m | 524290 | 43862.1 ± 0.1% | 1.001 | 0.088 | 1.000 | 0.590 | 1.001 | 1.000 | 1.000 | 1.000 | 1.001 | 0.093 | 0.992 |
| hex: http/json-1kx1024 | 2099200 | 20470.3 ± 0.5% | 0.999 | 0.179 | 1.000 | 0.967 | 1.001 | 1.003 | 1.001 | 0.999 | 1.005 | 0.187 | 1.002 |
| hex: http/json-16kx64 | 2097280 | 21358.4 ± 0.3% | 1.001 | 0.178 | 1.003 | 0.977 | 1.002 | 1.000 | 1.002 | 1.002 | 1.002 | 0.192 | 1.002 |
| hex: http/json-1m | 524290 | 43533.2 ± 0.1% | 1.001 | 0.089 | 1.000 | 0.594 | 1.001 | 0.999 | 1.001 | 1.000 | 1.000 | 0.089 | 0.996 |
| hex: http/js-1kx1024 | 2099200 | 20875.6 ± 0.2% | 1.000 | 0.176 | 1.001 | 0.961 | 1.002 | 0.996 | 1.001 | 1.001 | 1.004 | 0.183 | 1.003 |
| hex: http/js-16kx64 | 2097280 | 21608.0 ± 0.4% | 1.001 | 0.175 | 1.000 | 0.977 | 1.001 | 1.001 | 1.001 | 0.999 | 1.002 | 0.190 | 1.002 |
| hex: http/js-1m | 524290 | 43864.6 ± 0.1% | 1.001 | 0.088 | 1.000 | 0.590 | 1.000 | 1.000 | 1.000 | 1.000 | 1.000 | 0.093 | 1.000 |
| hex: http/css-1kx1024 | 2099200 | 21440.8 ± 0.6% | 1.001 | 0.171 | 1.001 | 0.941 | 1.001 | 0.992 | 1.001 | 1.001 | 1.007 | 0.179 | 1.003 |
| hex: http/css-16kx64 | 2097280 | 21217.7 ± 0.1% | 1.000 | 0.179 | 1.002 | 0.989 | 1.002 | 1.001 | 1.002 | 1.002 | 1.002 | 0.193 | 1.003 |
| hex: http/css-1m | 524290 | 43776.2 ± 0.1% | 1.001 | 0.088 | 1.000 | 0.591 | 1.001 | 0.999 | 1.000 | 1.000 | 0.999 | 0.092 | 1.001 |
| hex: shuffled/dickens-1m | 524290 | 43952.8 ± 0.1% | 1.001 | 0.088 | 1.000 | 0.589 | 1.000 | 1.000 | 1.000 | 0.965 | 1.000 | 0.090 | 1.000 |

## Losses

Each workload where a claim's path ran slower than the path it replaces by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding: J7 wide vectors off runs at 1.071 of all on.
- CLDR supplemental, 34 texts, decoding: J8 decoder fast path off runs at 1.072 of all on.
- CLDR supplemental, 34 texts, decoding: J12 decoder escape words off runs at 1.076 of all on.
- CLDR supplemental, 34 texts, decoding: J13 decoder escape blocks off runs at 1.071 of all on.
- qlog records, JSON text sequence, decoding: J5 UTF-8 vectors off runs at 1.054 of all on.
- qlog records, JSON text sequence, decoding: J7 wide vectors off runs at 1.063 of all on.
- qlog records, JSON text sequence, decoding: J8 decoder fast path off runs at 1.059 of all on.
- qlog records, JSON text sequence, decoding: J12 decoder escape words off runs at 1.062 of all on.
- qlog records, JSON text sequence, decoding: J13 decoder escape blocks off runs at 1.059 of all on.
- messages: 50 nested objects, decoding: J5 UTF-8 vectors off runs at 1.088 of all on.
- messages: 50 nested objects, decoding: J7 wide vectors off runs at 1.086 of all on.
- messages: 50 nested objects, decoding: J8 decoder fast path off runs at 1.088 of all on.
- messages: 50 nested objects, decoding: J12 decoder escape words off runs at 1.095 of all on.
- messages: 50 nested objects, decoding: J13 decoder escape blocks off runs at 1.089 of all on.
- string: silesia/dickens, decoding: J7 wide vectors off runs at 1.098 of all on.
- string: silesia/dickens, decoding: J8 decoder fast path off runs at 1.095 of all on.
- string: silesia/dickens, decoding: J13 decoder escape blocks off runs at 1.106 of all on.
- string: silesia/samba, decoding: J7 wide vectors off runs at 1.063 of all on.
- string: silesia/samba, decoding: J8 decoder fast path off runs at 1.064 of all on.
- string: silesia/samba, decoding: J13 decoder escape blocks off runs at 1.064 of all on.
- string: canterbury/alice29.txt, decoding: J7 wide vectors off runs at 1.082 of all on.
- string: canterbury/alice29.txt, decoding: J8 decoder fast path off runs at 1.143 of all on.
- string: canterbury/alice29.txt, decoding: J13 decoder escape blocks off runs at 1.166 of all on.
- string: canterbury/asyoulik.txt, decoding: J7 wide vectors off runs at 1.129 of all on.
- string: canterbury/asyoulik.txt, decoding: J8 decoder fast path off runs at 1.120 of all on.
- string: canterbury/asyoulik.txt, decoding: J13 decoder escape blocks off runs at 1.128 of all on.
- string: canterbury/lcet10.txt, decoding: J7 wide vectors off runs at 1.099 of all on.
- string: canterbury/lcet10.txt, decoding: J8 decoder fast path off runs at 1.111 of all on.
- string: canterbury/lcet10.txt, decoding: J13 decoder escape blocks off runs at 1.119 of all on.

## UTF-8 validation against simdutf

stdx's `is_utf8`, the check the loops apply to every string's octets, run alone over each string workload's octets at the width the host's features pick (16 lanes on aarch64, AVX2's 32 or AVX-512's 64 on x86-64, decision 39), beside simdutf 9.3.3's `validate_utf8` in the same run; on a host with AVX-512, again with AVX2 alone. Each ratio is stdx's throughput over the other's. simdutf picks its kernel at run time. Before timing, every copy of the check and simdutf judged 20000 seeded buffers and each workload, whole and changed, alike.

| Workload | Octets | stdx, MB/s | simdutf, MB/s | stdx / simdutf | stdx with AVX2 alone, MB/s | stdx / stdx with AVX2 alone |
|---|---|---|---|---|---|---|
| string: silesia/dickens | 166668 | 169540.2 ± 0.3% | 122508.8 ± 3.7% | 1.384 | 101156.8 ± 0.0% | 1.676 |
| string: silesia/nci | 1048576 | 170300.7 ± 0.7% | 123307.6 ± 0.1% | 1.381 | 102042.5 ± 0.1% | 1.669 |
| string: silesia/reymont | 1048576 | 170754.2 ± 0.2% | 123372.7 ± 5.0% | 1.384 | 101746.8 ± 0.1% | 1.678 |
| string: silesia/samba | 65546 | 164440.5 ± 0.2% | 120883.1 ± 0.2% | 1.360 | 99910.7 ± 0.2% | 1.646 |
| string: silesia/webster | 1048576 | 169408.2 ± 0.3% | 123407.2 ± 0.1% | 1.373 | 102099.1 ± 0.3% | 1.659 |
| string: silesia/xml | 1048576 | 168726.9 ± 0.3% | 123373.3 ± 0.4% | 1.368 | 101733.7 ± 0.2% | 1.659 |
| string: canterbury/alice29.txt | 152089 | 168849.1 ± 0.2% | 122374.6 ± 4.2% | 1.380 | 100981.4 ± 0.1% | 1.672 |
| string: canterbury/asyoulik.txt | 125179 | 168465.8 ± 0.2% | 122197.4 ± 5.1% | 1.379 | 101315.6 ± 0.1% | 1.663 |
| string: canterbury/lcet10.txt | 426754 | 170445.8 ± 0.6% | 123230.5 ± 0.1% | 1.383 | 101932.2 ± 0.0% | 1.672 |
| string: canterbury/plrabn12.txt | 481861 | 170542.8 ± 0.1% | 123167.5 ± 0.1% | 1.385 | 102026.8 ± 0.3% | 1.672 |
| string: canterbury-large/E.coli | 1048576 | 169939.2 ± 7.9% | 123291.7 ± 0.1% | 1.378 | 101563.0 ± 0.1% | 1.673 |
| string: canterbury-large/bible.txt | 1048576 | 170292.9 ± 0.5% | 123055.3 ± 0.2% | 1.384 | 102130.9 ± 0.0% | 1.667 |
| string: canterbury-large/world192.txt | 1048576 | 170020.4 ± 7.4% | 123382.6 ± 1.2% | 1.378 | 101562.4 ± 0.1% | 1.674 |
| string: http/html-1m | 1048576 | 149134.4 ± 0.2% | 112830.7 ± 0.7% | 1.322 | 94581.9 ± 0.5% | 1.577 |
| string: http/json-1m | 1048576 | 123386.0 ± 0.8% | 107020.3 ± 4.1% | 1.153 | 83304.2 ± 0.4% | 1.481 |
| string: http/js-1m | 1048576 | 166433.1 ± 0.2% | 122036.0 ± 5.3% | 1.364 | 99891.8 ± 0.6% | 1.666 |
| string: http/css-1m | 1048576 | 169166.9 ± 0.4% | 122804.4 ± 5.3% | 1.378 | 100723.4 ± 0.4% | 1.680 |
| string: dickens as Cyrillic and CJK | 1847045 | 23386.4 ± 1.7% | 20355.2 ± 0.4% | 1.149 | 14696.9 ± 0.2% | 1.591 |

## Losses to simdutf

None.

## UTF-8 validation by the buffer's offset from a 64-octet line

| Buffer | Octets | Offset | stdx, MB/s | simdutf, MB/s | stdx / simdutf | stdx with AVX2 alone, MB/s | stdx / stdx with AVX2 alone |
|---|---|---|---|---|---|---|---|
| string: canterbury-large/bible.txt | 1048576 | 0 | 169715.4 ± 0.3% | 123448.5 ± 4.7% | 1.375 | 102258.6 ± 0.1% | 1.660 |
| string: canterbury-large/bible.txt | 1048576 | 1 | 170750.6 ± 0.3% | 123404.5 ± 0.1% | 1.384 | 101802.7 ± 0.3% | 1.677 |
| string: canterbury-large/bible.txt | 1048576 | 8 | 170356.2 ± 0.1% | 123410.2 ± 0.1% | 1.380 | 101755.4 ± 0.1% | 1.674 |
| string: canterbury-large/bible.txt | 1048576 | 16 | 170977.1 ± 7.8% | 123253.1 ± 0.3% | 1.387 | 101808.2 ± 0.1% | 1.679 |
| string: canterbury-large/bible.txt | 1048576 | 32 | 170938.3 ± 0.3% | 123393.4 ± 0.3% | 1.385 | 101869.1 ± 0.0% | 1.678 |
| string: canterbury-large/bible.txt | 1048576 | 48 | 170883.8 ± 0.2% | 123386.3 ± 0.4% | 1.385 | 102382.9 ± 0.0% | 1.669 |
| string: dickens as Cyrillic and CJK | 1048576 | 0 | 24429.1 ± 0.1% | 21828.5 ± 0.0% | 1.119 | 15394.8 ± 0.1% | 1.587 |
| string: dickens as Cyrillic and CJK | 1048576 | 1 | 24429.7 ± 0.3% | 21811.7 ± 0.1% | 1.120 | 15365.1 ± 1.4% | 1.590 |
| string: dickens as Cyrillic and CJK | 1048576 | 8 | 24423.4 ± 0.2% | 21806.0 ± 0.1% | 1.120 | 15387.1 ± 0.2% | 1.587 |
| string: dickens as Cyrillic and CJK | 1048576 | 16 | 24424.5 ± 0.3% | 21806.7 ± 0.5% | 1.120 | 15376.6 ± 1.7% | 1.588 |
| string: dickens as Cyrillic and CJK | 1048576 | 32 | 24424.6 ± 0.1% | 21796.7 ± 0.1% | 1.121 | 15366.9 ± 0.2% | 1.589 |
| string: dickens as Cyrillic and CJK | 1048576 | 48 | 24413.6 ± 0.1% | 21793.9 ± 0.6% | 1.120 | 15401.9 ± 0.2% | 1.585 |

## Messages against serde_json's typed code

stdx's encoder a token a call through `TextWriter`'s methods, a member's name and its value in one `member_*` call, beside serde_json 1.0.154 writing the same messages from Rust types, as code of the form serde's derive generates writes them. Octets are the ones written.

| Workload | Octets | TextWriter's methods, MB/s | serde_json typed, MB/s | stdx / serde_json typed |
|---|---|---|---|---|
| messages: 11 string members | 1025025 | 1238.3 ± 3.9% | 779.1 ± 0.7% | 1.589 |
| messages: 50 nested objects | 1121600 | 1679.0 ± 0.3% | 983.3 ± 0.7% | 1.708 |

## Against the baselines

stdx with every claim on, timed beside simdjson 5.1.1, yyjson 0.13.0, Zig 0.16.0's std.json, serde_json 1.0.154 and Go's encoding/json/jsontext in the same run. Each ratio is stdx's throughput over the baseline's; below 1, the baseline is faster. stdx is built for the architecture's baseline CPU in ReleaseSafe. Each baseline is built for the same CPU, the C, C++ and Zig ones in ReleaseFast (decision 75), and simdjson picks its kernel at run time. Decoding visits every value; encoding writes each text from its tokens.

## Decoding against the baselines

Octets are the text's. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1379.4 ± 0.9% | 1548.8 ± 8.8% | 1112.6 ± 12.6% | 394.9 ± 0.6% | 659.2 ± 0.4% | 369.2 ± 1.9% | 0.891 | 1.240 | 3.493 | 2.092 | 3.737 |
| qlog records, JSON text sequence | 1467503 | 1099.6 ± 0.3% | 1242.9 ± 1.1% | 1106.1 ± 0.8% | 333.5 ± 1.0% | 734.9 ± 1.4% | 318.5 ± 0.7% | 0.885 | 0.994 | 3.297 | 1.496 | 3.453 |
| messages: 11 string members | 1025025 | 1058.7 ± 1.8% | 2049.7 ± 4.4% | 780.2 ± 0.4% | 336.6 ± 0.9% | 497.8 ± 0.4% | 305.9 ± 0.3% | 0.517 | 1.357 | 3.145 | 2.127 | 3.461 |
| messages: 50 nested objects | 1121600 | 1346.7 ± 0.1% | 1755.6 ± 2.5% | 1449.9 ± 0.9% | 433.5 ± 1.1% | 909.0 ± 0.4% | 424.2 ± 0.9% | 0.767 | 0.929 | 3.107 | 1.482 | 3.175 |
| string: silesia/dickens | 172528 | 6723.3 ± 0.1% | 3468.2 ± 2.7% | 2827.9 ± 1.4% | 319.2 ± 0.3% | 3376.0 ± 1.3% | 567.6 ± 2.7% | 1.939 | 2.377 | 21.065 | 1.992 | 11.846 |
| string: silesia/nci | 1075110 | 5395.3 ± 0.5% | 3898.3 ± 0.4% | 2995.7 ± 0.2% | 652.6 ± 0.6% | 3671.9 ± 0.5% | 578.1 ± 2.2% | 1.384 | 1.801 | 8.268 | 1.469 | 9.333 |
| string: silesia/reymont | 1075159 | 3536.3 ± 2.9% | 3420.4 ± 0.2% | 2010.9 ± 2.7% | 342.6 ± 0.2% | 2091.3 ± 0.7% | 493.4 ± 1.1% | 1.034 | 1.759 | 10.321 | 1.691 | 7.168 |
| string: silesia/samba | 97582 | 3999.4 ± 1.3% | 3821.9 ± 0.4% | 3133.1 ± 0.2% | 329.2 ± 3.1% | 2059.9 ± 0.4% | 417.7 ± 1.6% | 1.046 | 1.276 | 12.151 | 1.942 | 9.575 |
| string: silesia/webster | 1098490 | 4387.4 ± 0.8% | 2438.0 ± 0.3% | 1741.4 ± 0.3% | 310.8 ± 1.4% | 2111.0 ± 0.6% | 452.2 ± 3.0% | 1.800 | 2.519 | 14.117 | 2.078 | 9.702 |
| string: silesia/xml | 1090118 | 6039.1 ± 0.2% | 5015.6 ± 0.1% | 2506.5 ± 0.2% | 511.2 ± 0.3% | 3372.2 ± 0.2% | 532.0 ± 1.6% | 1.204 | 2.409 | 11.813 | 1.791 | 11.351 |
| string: canterbury/alice29.txt | 159425 | 5781.7 ± 1.8% | 2785.7 ± 1.5% | 2875.8 ± 1.5% | 301.7 ± 0.2% | 3047.5 ± 4.0% | 518.6 ± 0.5% | 2.075 | 2.010 | 19.162 | 1.897 | 11.148 |
| string: canterbury/asyoulik.txt | 132198 | 4319.6 ± 0.6% | 2640.8 ± 0.6% | 2697.1 ± 1.1% | 306.3 ± 0.3% | 2465.0 ± 0.7% | 457.3 ± 2.5% | 1.636 | 1.602 | 14.104 | 1.752 | 9.445 |
| string: canterbury/lcet10.txt | 441884 | 6677.8 ± 0.7% | 3303.4 ± 0.2% | 2376.1 ± 0.7% | 348.2 ± 0.4% | 3036.8 ± 0.9% | 569.1 ± 1.0% | 2.022 | 2.810 | 19.178 | 2.199 | 11.733 |
| string: canterbury/plrabn12.txt | 503330 | 5501.5 ± 0.1% | 3182.8 ± 0.2% | 1862.9 ± 0.4% | 323.8 ± 0.2% | 2874.3 ± 0.3% | 532.8 ± 1.4% | 1.728 | 2.953 | 16.988 | 1.914 | 10.326 |
| string: canterbury-large/E.coli | 1048578 | 30374.9 ± 3.8% | 13326.6 ± 0.2% | 3376.7 ± 0.5% | 1285.5 ± 0.1% | 8974.6 ± 0.2% | 931.2 ± 3.4% | 2.279 | 8.995 | 23.628 | 3.385 | 32.618 |
| string: canterbury-large/bible.txt | 1055886 | 8495.8 ± 0.5% | 5293.5 ± 1.1% | 2799.7 ± 0.3% | 360.1 ± 0.6% | 3872.5 ± 0.4% | 622.2 ± 4.3% | 1.605 | 3.035 | 23.595 | 2.194 | 13.655 |
| string: canterbury-large/world192.txt | 1103121 | 4130.4 ± 0.5% | 2305.6 ± 0.2% | 1803.7 ± 0.2% | 329.2 ± 1.8% | 2186.3 ± 2.4% | 466.8 ± 1.5% | 1.791 | 2.290 | 12.546 | 1.889 | 8.848 |
| string: http/html-1m | 1058582 | 9005.9 ± 4.9% | 4778.9 ± 1.4% | 2720.8 ± 1.5% | 428.8 ± 1.1% | 3568.2 ± 0.5% | 594.7 ± 2.0% | 1.885 | 3.310 | 21.004 | 2.524 | 15.144 |
| string: http/json-1m | 1190272 | 3264.6 ± 0.8% | 1255.9 ± 0.4% | 2120.1 ± 0.1% | 472.9 ± 0.6% | 1362.0 ± 1.1% | 435.2 ± 0.8% | 2.599 | 1.540 | 6.904 | 2.397 | 7.501 |
| string: http/js-1m | 1144362 | 2850.6 ± 0.5% | 1609.6 ± 0.1% | 1331.1 ± 0.3% | 330.3 ± 3.0% | 1413.9 ± 0.6% | 380.9 ± 0.3% | 1.771 | 2.142 | 8.630 | 2.016 | 7.484 |
| string: http/css-1m | 1097820 | 3290.8 ± 0.7% | 2886.0 ± 0.7% | 2283.9 ± 1.0% | 458.3 ± 0.4% | 2114.6 ± 2.9% | 442.3 ± 1.3% | 1.140 | 1.441 | 7.181 | 1.556 | 7.440 |
| string: dickens as Cyrillic and CJK | 1883069 | 5824.4 ± 0.3% | 2892.8 ± 2.9% | 688.2 ± 0.2% | 380.5 ± 1.8% | 497.4 ± 0.2% | 166.5 ± 2.6% | 2.013 | 8.463 | 15.306 | 11.711 | 34.987 |
| string: dickens as Cyrillic and CJK, as \u escapes | 5075485 | 1204.5 ± 1.2% | 1247.7 ± 1.6% | 1113.2 ± 0.7% | 264.4 ± 1.1% | 470.8 ± 0.1% | 230.1 ± 6.2% | 0.965 | 1.082 | 4.556 | 2.558 | 5.235 |
| hex: silesia/dickens | 524290 | 45596.2 ± 0.1% | 15210.1 ± 0.1% | 3576.8 ± 0.1% | 481.5 ± 0.3% | 8992.2 ± 0.1% | 1137.4 ± 1.6% | 2.998 | 12.748 | 94.690 | 5.071 | 40.088 |
| hex: silesia/mozilla | 524290 | 46700.9 ± 0.6% | 15218.3 ± 2.7% | 3507.9 ± 0.2% | 431.1 ± 0.3% | 8969.7 ± 0.4% | 1140.0 ± 1.2% | 3.069 | 13.313 | 108.319 | 5.207 | 40.967 |
| hex: silesia/mr | 524290 | 45833.8 ± 0.3% | 15210.2 ± 0.0% | 3508.9 ± 0.2% | 651.0 ± 0.2% | 8973.9 ± 0.2% | 1139.9 ± 0.1% | 3.013 | 13.062 | 70.404 | 5.107 | 40.210 |
| hex: silesia/nci | 524290 | 45700.3 ± 0.1% | 15212.0 ± 2.9% | 3577.9 ± 0.2% | 764.0 ± 0.4% | 8988.7 ± 0.3% | 1139.4 ± 0.7% | 3.004 | 12.773 | 59.813 | 5.084 | 40.108 |
| hex: silesia/ooffice | 524290 | 46626.1 ± 1.8% | 15202.0 ± 0.2% | 3510.7 ± 1.4% | 345.0 ± 0.3% | 8984.4 ± 0.1% | 1139.2 ± 0.8% | 3.067 | 13.281 | 135.157 | 5.190 | 40.930 |
| hex: silesia/osdb | 524290 | 46033.7 ± 0.6% | 15214.7 ± 0.1% | 3508.8 ± 0.2% | 457.2 ± 1.2% | 8981.8 ± 0.2% | 1137.6 ± 0.6% | 3.026 | 13.119 | 100.691 | 5.125 | 40.464 |
| hex: silesia/reymont | 524290 | 46576.6 ± 0.1% | 15213.4 ± 0.3% | 3558.2 ± 3.3% | 496.6 ± 0.5% | 8992.2 ± 2.2% | 1138.8 ± 3.2% | 3.062 | 13.090 | 93.787 | 5.180 | 40.900 |
| hex: silesia/samba | 524290 | 46677.6 ± 0.7% | 15209.4 ± 0.2% | 3510.6 ± 0.2% | 366.6 ± 0.2% | 8973.7 ± 4.8% | 1138.6 ± 0.4% | 3.069 | 13.296 | 127.310 | 5.202 | 40.996 |
| hex: silesia/sao | 524290 | 44467.5 ± 0.4% | 15213.0 ± 0.1% | 3511.7 ± 0.2% | 280.9 ± 0.2% | 8974.2 ± 0.2% | 1140.5 ± 0.1% | 2.923 | 12.663 | 158.286 | 4.955 | 38.991 |
| hex: silesia/webster | 524290 | 45956.1 ± 0.1% | 15214.2 ± 0.0% | 3575.0 ± 2.0% | 453.7 ± 1.1% | 8989.3 ± 0.4% | 1145.6 ± 3.5% | 3.021 | 12.855 | 101.298 | 5.112 | 40.116 |
| hex: silesia/x-ray | 524290 | 45757.2 ± 0.2% | 15192.8 ± 2.3% | 3508.4 ± 0.1% | 427.5 ± 1.4% | 8976.7 ± 0.2% | 1142.2 ± 0.8% | 3.012 | 13.042 | 107.033 | 5.097 | 40.060 |
| hex: silesia/xml | 524290 | 47459.6 ± 0.5% | 15220.0 ± 0.0% | 3575.3 ± 3.2% | 709.4 ± 1.0% | 8988.4 ± 0.1% | 1141.2 ± 3.6% | 3.118 | 13.274 | 66.898 | 5.280 | 41.586 |
| hex: canterbury/alice29.txt | 304180 | 46393.4 ± 0.3% | 14295.1 ± 0.1% | 3581.8 ± 0.4% | 486.3 ± 0.2% | 8993.8 ± 4.0% | 1150.2 ± 0.4% | 3.245 | 12.953 | 95.395 | 5.158 | 40.334 |
| hex: canterbury/asyoulik.txt | 250360 | 45758.0 ± 0.1% | 15172.2 ± 0.1% | 3507.9 ± 0.3% | 471.7 ± 0.6% | 8973.1 ± 0.3% | 1147.2 ± 0.7% | 3.016 | 13.044 | 97.017 | 5.099 | 39.885 |
| hex: canterbury/cp.html | 49208 | 44566.9 ± 2.5% | 14490.0 ± 2.8% | 3578.5 ± 0.2% | 500.3 ± 0.7% | 9349.6 ± 0.1% | 1137.0 ± 1.0% | 3.076 | 12.454 | 89.075 | 4.767 | 39.198 |
| hex: canterbury/fields.c | 22302 | 52428.4 ± 0.3% | 17741.0 ± 0.1% | 3685.2 ± 0.3% | 528.1 ± 0.4% | 9334.2 ± 0.4% | 1101.9 ± 1.5% | 2.955 | 14.227 | 99.283 | 5.617 | 47.579 |
| hex: canterbury/grammar.lsp | 7444 | 45314.6 ± 0.4% | 17330.3 ± 0.2% | 3636.2 ± 0.4% | 701.5 ± 1.9% | 9078.4 ± 0.1% | 1078.9 ± 1.3% | 2.615 | 12.462 | 64.598 | 4.991 | 42.001 |
| hex: canterbury/kennedy.xls | 524290 | 44676.3 ± 0.3% | 15189.2 ± 0.1% | 3581.6 ± 0.2% | 758.6 ± 0.3% | 8990.8 ± 0.1% | 1126.5 ± 3.6% | 2.941 | 12.474 | 58.893 | 4.969 | 39.658 |
| hex: canterbury/lcet10.txt | 524290 | 48877.9 ± 0.4% | 15187.3 ± 0.2% | 3579.3 ± 0.3% | 486.8 ± 0.2% | 8993.2 ± 0.3% | 1135.8 ± 2.2% | 3.218 | 13.656 | 100.417 | 5.435 | 43.033 |
| hex: canterbury/plrabn12.txt | 524290 | 46023.9 ± 0.2% | 15193.7 ± 0.1% | 3575.8 ± 0.2% | 469.3 ± 0.4% | 8990.2 ± 0.2% | 1139.5 ± 0.2% | 3.029 | 12.871 | 98.062 | 5.119 | 40.391 |
| hex: canterbury/ptt5 | 524290 | 45800.1 ± 0.3% | 15192.8 ± 0.1% | 3509.7 ± 0.1% | 666.9 ± 0.3% | 8977.4 ± 0.3% | 1139.6 ± 0.3% | 3.015 | 13.050 | 68.676 | 5.102 | 40.190 |
| hex: canterbury/sum | 76482 | 46550.8 ± 0.2% | 15518.6 ± 0.2% | 3580.5 ± 0.2% | 576.3 ± 0.3% | 8955.2 ± 0.1% | 1135.4 ± 1.1% | 3.000 | 13.001 | 80.778 | 5.198 | 40.999 |
| hex: canterbury/xargs.1 | 8456 | 46744.4 ± 0.7% | 17465.5 ± 0.2% | 3584.5 ± 0.2% | 685.1 ± 2.6% | 9065.3 ± 0.1% | 1113.6 ± 1.7% | 2.676 | 13.041 | 68.230 | 5.156 | 41.977 |
| hex: canterbury-large/E.coli | 524290 | 47494.5 ± 2.4% | 15212.7 ± 0.1% | 3498.4 ± 0.1% | 966.9 ± 0.4% | 8978.6 ± 4.9% | 1134.5 ± 5.4% | 3.122 | 13.576 | 49.118 | 5.290 | 41.864 |
| hex: canterbury-large/bible.txt | 524290 | 45985.4 ± 0.1% | 15208.4 ± 0.1% | 3506.7 ± 0.2% | 504.3 ± 0.3% | 8966.9 ± 0.3% | 1132.6 ± 1.8% | 3.024 | 13.113 | 91.183 | 5.128 | 40.602 |
| hex: canterbury-large/world192.txt | 524290 | 45696.6 ± 0.2% | 15206.8 ± 1.6% | 3577.9 ± 0.8% | 465.4 ± 0.4% | 8991.7 ± 0.2% | 1140.8 ± 1.2% | 3.005 | 12.772 | 98.179 | 5.082 | 40.058 |
| hex: http/html-1kx1024 | 2099200 | 16718.2 ± 2.7% | 11769.9 ± 0.9% | 3130.2 ± 2.2% | 497.0 ± 0.5% | 7711.3 ± 5.4% | 985.7 ± 0.4% | 1.420 | 5.341 | 33.636 | 2.168 | 16.961 |
| hex: http/html-16kx64 | 2097280 | 33212.8 ± 0.1% | 13879.7 ± 0.3% | 3400.2 ± 0.1% | 502.6 ± 3.2% | 8409.8 ± 0.8% | 1086.4 ± 2.2% | 2.393 | 9.768 | 66.085 | 3.949 | 30.571 |
| hex: http/html-1m | 524290 | 46446.4 ± 0.5% | 15200.6 ± 0.1% | 3512.7 ± 0.3% | 503.5 ± 0.6% | 8977.6 ± 0.2% | 1112.9 ± 5.1% | 3.056 | 13.222 | 92.253 | 5.174 | 41.736 |
| hex: http/json-1kx1024 | 2099200 | 16455.6 ± 3.0% | 12103.7 ± 0.2% | 3129.2 ± 0.1% | 660.4 ± 2.9% | 7683.6 ± 0.8% | 974.2 ± 1.8% | 1.360 | 5.259 | 24.919 | 2.142 | 16.892 |
| hex: http/json-16kx64 | 2097280 | 34493.3 ± 0.6% | 13775.7 ± 0.1% | 3397.7 ± 0.2% | 672.7 ± 0.6% | 8448.9 ± 0.8% | 1083.6 ± 1.8% | 2.504 | 10.152 | 51.276 | 4.083 | 31.832 |
| hex: http/json-1m | 524290 | 49040.5 ± 0.4% | 15214.5 ± 0.1% | 3580.6 ± 0.1% | 702.1 ± 0.8% | 8986.6 ± 0.3% | 1152.2 ± 2.3% | 3.223 | 13.696 | 69.852 | 5.457 | 42.563 |
| hex: http/js-1kx1024 | 2099200 | 17001.4 ± 3.8% | 12196.8 ± 0.7% | 3141.7 ± 0.0% | 478.8 ± 0.3% | 7674.1 ± 0.8% | 991.1 ± 1.1% | 1.394 | 5.412 | 35.506 | 2.215 | 17.154 |
| hex: http/js-16kx64 | 2097280 | 34061.0 ± 0.4% | 13869.5 ± 0.2% | 3394.5 ± 0.3% | 483.7 ± 0.2% | 8247.2 ± 0.2% | 1100.3 ± 2.1% | 2.456 | 10.034 | 70.412 | 4.130 | 30.957 |
| hex: http/js-1m | 524290 | 47083.4 ± 0.3% | 15198.3 ± 0.3% | 3570.3 ± 0.4% | 500.2 ± 0.4% | 8989.1 ± 0.2% | 1148.1 ± 1.8% | 3.098 | 13.187 | 94.133 | 5.238 | 41.011 |
| hex: http/css-1kx1024 | 2099200 | 16724.4 ± 3.9% | 12618.2 ± 3.1% | 3138.2 ± 0.0% | 555.5 ± 0.6% | 7691.4 ± 0.7% | 986.4 ± 0.7% | 1.325 | 5.329 | 30.110 | 2.174 | 16.955 |
| hex: http/css-16kx64 | 2097280 | 34700.3 ± 0.3% | 13962.7 ± 0.3% | 3395.1 ± 0.0% | 566.6 ± 0.3% | 8698.1 ± 1.1% | 1095.9 ± 2.3% | 2.485 | 10.221 | 61.243 | 3.989 | 31.664 |
| hex: http/css-1m | 524290 | 45672.7 ± 0.2% | 15210.1 ± 2.0% | 3583.2 ± 0.1% | 545.9 ± 0.4% | 8986.4 ± 0.2% | 1126.6 ± 2.9% | 3.003 | 12.746 | 83.661 | 5.082 | 40.542 |
| hex: shuffled/dickens-1m | 524290 | 44935.3 ± 0.8% | 15214.8 ± 0.1% | 3504.6 ± 0.1% | 480.4 ± 0.4% | 8971.3 ± 0.2% | 1134.2 ± 3.4% | 2.953 | 12.822 | 93.541 | 5.009 | 39.618 |

## Encoding against the baselines

Octets are the ones stdx writes. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1741.8 ± 0.2% | 1476.9 ± 0.5% | 1011.2 ± 0.2% | 463.3 ± 0.7% | 451.1 ± 0.6% | 502.3 ± 0.6% | 1.179 | 1.722 | 3.760 | 3.861 | 3.468 |
| qlog records, JSON text sequence | 1467503 | 1693.0 ± 0.3% | 1242.1 ± 2.5% | 894.8 ± 0.6% | 430.6 ± 0.4% | 536.0 ± 0.9% | 353.7 ± 1.4% | 1.363 | 1.892 | 3.932 | 3.158 | 4.786 |
| messages: 11 string members | 1025025 | 1311.0 ± 0.4% | 1097.8 ± 0.7% | 742.3 ± 0.8% | 410.1 ± 0.4% | 425.4 ± 0.2% | 432.9 ± 0.5% | 1.194 | 1.766 | 3.197 | 3.082 | 3.028 |
| messages: 50 nested objects | 1121600 | 1971.6 ± 0.2% | 1862.0 ± 0.3% | 1308.2 ± 1.3% | 591.5 ± 1.3% | 617.4 ± 1.2% | 508.2 ± 0.9% | 1.059 | 1.507 | 3.333 | 3.193 | 3.880 |
| string: silesia/dickens | 172528 | 13169.3 ± 0.7% | 3959.3 ± 2.1% | 3134.8 ± 1.7% | 335.7 ± 1.0% | 1730.2 ± 1.3% | 1188.3 ± 3.2% | 3.326 | 4.201 | 39.228 | 7.611 | 11.083 |
| string: silesia/nci | 1075110 | 11096.7 ± 0.3% | 4757.8 ± 0.4% | 3140.5 ± 3.1% | 909.5 ± 0.7% | 1916.9 ± 1.4% | 1195.1 ± 2.1% | 2.332 | 3.533 | 12.201 | 5.789 | 9.285 |
| string: silesia/reymont | 1075159 | 5374.8 ± 1.2% | 1869.0 ± 1.1% | 2009.4 ± 1.5% | 379.4 ± 0.8% | 1435.1 ± 1.1% | 1039.8 ± 2.7% | 2.876 | 2.675 | 14.166 | 3.745 | 5.169 |
| string: silesia/samba | 97582 | 6357.1 ± 0.4% | 2717.0 ± 0.1% | 4108.0 ± 3.1% | 350.4 ± 1.0% | 1341.4 ± 0.3% | 1179.5 ± 5.3% | 2.340 | 1.548 | 18.143 | 4.739 | 5.389 |
| string: silesia/webster | 1098490 | 6866.7 ± 0.6% | 1996.2 ± 0.4% | 1876.4 ± 0.4% | 351.6 ± 0.6% | 1410.5 ± 1.3% | 602.6 ± 0.3% | 3.440 | 3.659 | 19.530 | 4.868 | 11.395 |
| string: silesia/xml | 1090118 | 10342.0 ± 1.2% | 3194.0 ± 0.4% | 2651.3 ± 0.4% | 608.7 ± 3.2% | 1962.0 ± 0.2% | 962.3 ± 0.5% | 3.238 | 3.901 | 16.989 | 5.271 | 10.748 |
| string: canterbury/alice29.txt | 159425 | 12700.4 ± 4.0% | 2919.6 ± 1.8% | 3160.3 ± 5.6% | 320.4 ± 0.8% | 1558.4 ± 1.7% | 1097.2 ± 0.4% | 4.350 | 4.019 | 39.641 | 8.149 | 11.576 |
| string: canterbury/asyoulik.txt | 132198 | 10609.2 ± 2.4% | 2127.6 ± 0.7% | 3151.5 ± 3.6% | 320.2 ± 0.7% | 1387.0 ± 1.5% | 967.0 ± 3.3% | 4.986 | 3.366 | 33.136 | 7.649 | 10.972 |
| string: canterbury/lcet10.txt | 441884 | 12033.7 ± 1.1% | 3120.5 ± 2.6% | 2661.1 ± 0.4% | 369.6 ± 2.9% | 1687.2 ± 1.1% | 1193.5 ± 2.8% | 3.856 | 4.522 | 32.557 | 7.132 | 10.082 |
| string: canterbury/plrabn12.txt | 503330 | 8291.6 ± 0.5% | 2340.9 ± 0.2% | 2181.2 ± 1.1% | 348.7 ± 1.4% | 1643.8 ± 1.6% | 1126.9 ± 4.0% | 3.542 | 3.801 | 23.779 | 5.044 | 7.358 |
| string: canterbury-large/E.coli | 1048578 | 33318.3 ± 0.3% | 15900.9 ± 0.3% | 3486.8 ± 0.1% | 1691.3 ± 2.0% | 3153.4 ± 0.2% | 1403.6 ± 0.3% | 2.095 | 9.555 | 19.700 | 10.566 | 23.738 |
| string: canterbury-large/bible.txt | 1055886 | 9236.5 ± 0.2% | 4880.1 ± 0.7% | 3049.9 ± 0.3% | 407.0 ± 0.7% | 2145.2 ± 0.2% | 1484.1 ± 0.6% | 1.893 | 3.028 | 22.697 | 4.306 | 6.224 |
| string: canterbury-large/world192.txt | 1103121 | 6588.6 ± 1.2% | 1742.1 ± 0.4% | 2011.8 ± 0.8% | 349.4 ± 0.6% | 1394.9 ± 0.3% | 960.0 ± 0.8% | 3.782 | 3.275 | 18.854 | 4.723 | 6.863 |
| string: http/html-1m | 1058582 | 10103.4 ± 0.8% | 4375.3 ± 1.6% | 2935.0 ± 0.3% | 421.9 ± 0.2% | 2172.9 ± 0.9% | 848.1 ± 2.6% | 2.309 | 3.442 | 23.948 | 4.650 | 11.912 |
| string: http/json-1m | 1190272 | 8252.7 ± 0.3% | 1591.7 ± 0.3% | 1972.5 ± 0.8% | 558.4 ± 0.3% | 1191.8 ± 1.0% | 845.2 ± 0.8% | 5.185 | 4.184 | 14.778 | 6.925 | 9.764 |
| string: http/js-1m | 1144362 | 6478.2 ± 1.1% | 1124.8 ± 0.1% | 1532.5 ± 0.2% | 333.2 ± 0.2% | 1122.2 ± 0.9% | 758.1 ± 2.6% | 5.760 | 4.227 | 19.444 | 5.773 | 8.545 |
| string: http/css-1m | 1097820 | 8990.2 ± 0.4% | 1487.7 ± 2.1% | 2375.0 ± 5.5% | 511.7 ± 0.3% | 1273.7 ± 0.2% | 879.2 ± 2.6% | 6.043 | 3.785 | 17.571 | 7.058 | 10.226 |
| string: dickens as Cyrillic and CJK | 1883069 | 5437.7 ± 1.6% | 3633.2 ± 3.0% | 504.7 ± 0.7% | 247.8 ± 1.2% | 453.4 ± 11.0% | 358.4 ± 0.4% | 1.497 | 10.773 | 21.944 | 11.993 | 15.173 |
| hex: silesia/dickens | 524290 | 43601.9 ± 2.7% | 2600.8 ± 0.2% | 1516.4 ± 0.1% | 461.4 ± 0.2% | 1535.2 ± 0.3% | 1068.7 ± 0.1% | 16.765 | 28.754 | 94.492 | 28.401 | 40.798 |
| hex: silesia/mozilla | 524290 | 42634.7 ± 5.8% | 2577.4 ± 0.1% | 1511.4 ± 0.3% | 388.0 ± 1.5% | 1564.9 ± 0.1% | 1071.0 ± 0.1% | 16.542 | 28.208 | 109.893 | 27.244 | 39.810 |
| hex: silesia/mr | 524290 | 43721.5 ± 7.3% | 2586.3 ± 0.5% | 1510.4 ± 0.2% | 595.1 ± 0.0% | 1533.6 ± 0.0% | 1067.6 ± 0.2% | 16.905 | 28.946 | 73.466 | 28.510 | 40.955 |
| hex: silesia/nci | 524290 | 43903.2 ± 0.1% | 2568.4 ± 0.1% | 1509.3 ± 0.2% | 756.3 ± 0.9% | 1559.3 ± 0.4% | 1069.1 ± 0.5% | 17.094 | 29.088 | 58.046 | 28.156 | 41.067 |
| hex: silesia/ooffice | 524290 | 43617.0 ± 0.2% | 2605.3 ± 0.1% | 1516.2 ± 0.2% | 321.2 ± 3.8% | 1538.9 ± 0.1% | 1067.7 ± 0.2% | 16.742 | 28.767 | 135.781 | 28.342 | 40.852 |
| hex: silesia/osdb | 524290 | 43792.9 ± 0.2% | 2598.0 ± 0.1% | 1446.9 ± 4.7% | 430.3 ± 2.7% | 1568.0 ± 0.1% | 1066.4 ± 0.1% | 16.856 | 30.267 | 101.769 | 27.929 | 41.068 |
| hex: silesia/reymont | 524290 | 43904.3 ± 0.2% | 2593.6 ± 0.3% | 1476.5 ± 4.5% | 482.2 ± 1.5% | 1535.1 ± 0.2% | 1064.8 ± 0.2% | 16.928 | 29.735 | 91.052 | 28.601 | 41.234 |
| hex: silesia/samba | 524290 | 43830.1 ± 0.1% | 2597.2 ± 9.0% | 1513.4 ± 0.5% | 338.3 ± 1.5% | 1569.1 ± 0.1% | 1067.8 ± 0.3% | 16.876 | 28.962 | 129.561 | 27.933 | 41.045 |
| hex: silesia/sao | 524290 | 43870.6 ± 0.1% | 2591.2 ± 0.1% | 1514.2 ± 0.1% | 270.9 ± 10.7% | 1555.1 ± 0.0% | 1071.0 ± 0.1% | 16.931 | 28.973 | 161.954 | 28.211 | 40.961 |
| hex: silesia/webster | 524290 | 44190.5 ± 0.3% | 2600.4 ± 0.1% | 1515.4 ± 0.0% | 436.6 ± 0.2% | 1573.2 ± 0.2% | 1068.1 ± 0.4% | 16.993 | 29.161 | 101.226 | 28.090 | 41.371 |
| hex: silesia/x-ray | 524290 | 43882.7 ± 0.2% | 2598.0 ± 0.1% | 1512.4 ± 0.1% | 423.0 ± 0.2% | 1556.5 ± 0.1% | 1070.7 ± 0.4% | 16.891 | 29.015 | 103.731 | 28.194 | 40.986 |
| hex: silesia/xml | 524290 | 43546.4 ± 0.1% | 2595.8 ± 0.4% | 1513.7 ± 0.3% | 691.1 ± 0.4% | 1573.4 ± 0.1% | 1068.5 ± 0.1% | 16.775 | 28.768 | 63.013 | 27.677 | 40.755 |
| hex: canterbury/alice29.txt | 304180 | 43778.4 ± 0.1% | 2621.4 ± 0.2% | 1537.3 ± 0.2% | 470.7 ± 0.2% | 1593.4 ± 0.1% | 1093.1 ± 0.2% | 16.700 | 28.478 | 93.003 | 27.476 | 40.049 |
| hex: canterbury/asyoulik.txt | 250360 | 43210.3 ± 0.1% | 2623.0 ± 0.1% | 1551.4 ± 2.1% | 459.6 ± 1.9% | 1592.5 ± 0.1% | 1092.0 ± 0.1% | 16.474 | 27.853 | 94.009 | 27.134 | 39.571 |
| hex: canterbury/cp.html | 49208 | 42839.6 ± 0.1% | 2603.6 ± 0.1% | 1539.9 ± 4.9% | 482.9 ± 0.5% | 1593.7 ± 0.0% | 1097.4 ± 0.0% | 16.454 | 27.820 | 88.717 | 26.880 | 39.038 |
| hex: canterbury/fields.c | 22302 | 42315.6 ± 5.4% | 2651.0 ± 0.3% | 1556.3 ± 0.1% | 603.6 ± 0.5% | 1607.7 ± 0.1% | 1104.5 ± 0.1% | 15.962 | 27.189 | 70.102 | 26.321 | 38.310 |
| hex: canterbury/grammar.lsp | 7444 | 39430.4 ± 0.5% | 2677.6 ± 0.4% | 1569.2 ± 0.1% | 818.9 ± 0.3% | 1609.4 ± 0.1% | 1113.1 ± 0.4% | 14.726 | 25.128 | 48.150 | 24.500 | 35.425 |
| hex: canterbury/kennedy.xls | 524290 | 43838.1 ± 0.0% | 2573.4 ± 0.1% | 1509.0 ± 0.1% | 789.6 ± 0.2% | 1570.7 ± 0.1% | 1067.5 ± 0.3% | 17.035 | 29.052 | 55.521 | 27.910 | 41.068 |
| hex: canterbury/lcet10.txt | 524290 | 43702.9 ± 0.1% | 2597.0 ± 0.1% | 1513.2 ± 0.2% | 471.6 ± 0.1% | 1580.2 ± 0.1% | 1069.4 ± 0.2% | 16.828 | 28.881 | 92.660 | 27.657 | 40.868 |
| hex: canterbury/plrabn12.txt | 524290 | 42751.3 ± 0.4% | 2588.1 ± 0.3% | 1512.5 ± 0.3% | 455.8 ± 0.3% | 1573.2 ± 0.1% | 1071.6 ± 0.4% | 16.518 | 28.266 | 93.801 | 27.174 | 39.895 |
| hex: canterbury/ptt5 | 524290 | 43920.5 ± 0.1% | 2573.7 ± 8.6% | 1508.6 ± 0.1% | 597.7 ± 0.7% | 1573.6 ± 0.1% | 1069.6 ± 0.2% | 17.065 | 29.114 | 73.478 | 27.911 | 41.063 |
| hex: canterbury/sum | 76482 | 42953.6 ± 0.1% | 2597.5 ± 0.2% | 1530.8 ± 0.3% | 563.5 ± 3.3% | 1586.4 ± 0.2% | 1095.5 ± 0.1% | 16.536 | 28.060 | 76.231 | 27.076 | 39.209 |
| hex: canterbury/xargs.1 | 8456 | 40435.6 ± 1.6% | 2676.2 ± 0.5% | 1571.5 ± 0.1% | 842.5 ± 0.1% | 1607.6 ± 0.3% | 1116.1 ± 0.6% | 15.109 | 25.730 | 47.993 | 25.153 | 36.228 |
| hex: canterbury-large/E.coli | 524290 | 43899.5 ± 0.1% | 2575.9 ± 1.1% | 1507.7 ± 0.1% | 816.8 ± 0.0% | 1567.6 ± 0.1% | 1069.2 ± 0.1% | 17.043 | 29.117 | 53.743 | 28.004 | 41.060 |
| hex: canterbury-large/bible.txt | 524290 | 43905.1 ± 0.1% | 2599.0 ± 0.3% | 1514.5 ± 0.1% | 484.1 ± 0.1% | 1575.0 ± 0.1% | 1068.6 ± 5.4% | 16.893 | 28.990 | 90.694 | 27.876 | 41.087 |
| hex: canterbury-large/world192.txt | 524290 | 43907.8 ± 0.3% | 2586.0 ± 0.1% | 1513.3 ± 0.1% | 460.0 ± 0.1% | 1569.2 ± 0.1% | 1013.5 ± 5.0% | 16.979 | 29.014 | 95.461 | 27.981 | 43.324 |
| hex: http/html-1kx1024 | 2099200 | 21199.1 ± 0.3% | 2333.1 ± 0.6% | 1484.9 ± 0.3% | 502.7 ± 0.2% | 1494.2 ± 0.8% | 1083.2 ± 0.1% | 9.086 | 14.277 | 42.173 | 14.188 | 19.570 |
| hex: http/html-16kx64 | 2097280 | 22526.6 ± 0.1% | 2243.3 ± 0.2% | 1466.5 ± 0.1% | 506.4 ± 0.2% | 1450.0 ± 0.1% | 1092.0 ± 0.1% | 10.042 | 15.360 | 44.483 | 15.536 | 20.628 |
| hex: http/html-1m | 524290 | 43862.1 ± 0.1% | 2592.3 ± 0.0% | 1516.4 ± 0.1% | 492.9 ± 0.1% | 1574.6 ± 0.0% | 1066.6 ± 0.3% | 16.920 | 28.925 | 88.989 | 27.856 | 41.125 |
| hex: http/json-1kx1024 | 2099200 | 20470.3 ± 0.5% | 2326.4 ± 1.0% | 1479.2 ± 0.5% | 699.1 ± 0.3% | 1491.3 ± 0.8% | 1082.6 ± 0.2% | 8.799 | 13.839 | 29.280 | 13.726 | 18.909 |
| hex: http/json-16kx64 | 2097280 | 21358.4 ± 0.3% | 2236.8 ± 0.2% | 1463.4 ± 0.3% | 708.9 ± 0.2% | 1445.5 ± 4.6% | 1090.3 ± 0.2% | 9.549 | 14.595 | 30.128 | 14.775 | 19.590 |
| hex: http/json-1m | 524290 | 43533.2 ± 0.1% | 2590.5 ± 0.1% | 1509.1 ± 0.1% | 738.8 ± 0.1% | 1575.5 ± 0.2% | 1067.4 ± 0.2% | 16.805 | 28.847 | 58.921 | 27.631 | 40.786 |
| hex: http/js-1kx1024 | 2099200 | 20875.6 ± 0.2% | 2346.2 ± 1.7% | 1481.7 ± 1.0% | 492.7 ± 3.5% | 1490.2 ± 4.9% | 1082.3 ± 0.5% | 8.897 | 14.089 | 42.373 | 14.008 | 19.289 |
| hex: http/js-16kx64 | 2097280 | 21608.0 ± 0.4% | 2236.9 ± 0.2% | 1464.3 ± 0.1% | 494.5 ± 0.2% | 1450.9 ± 0.1% | 1090.9 ± 0.4% | 9.660 | 14.756 | 43.696 | 14.893 | 19.807 |
| hex: http/js-1m | 524290 | 43864.6 ± 0.1% | 2602.6 ± 0.1% | 1514.4 ± 0.4% | 509.6 ± 0.1% | 1578.6 ± 0.0% | 1067.9 ± 0.2% | 16.854 | 28.965 | 86.077 | 27.788 | 41.075 |
| hex: http/css-1kx1024 | 2099200 | 21440.8 ± 0.6% | 2344.5 ± 1.3% | 1486.9 ± 0.2% | 559.3 ± 0.3% | 1494.2 ± 1.6% | 1081.5 ± 1.7% | 9.145 | 14.420 | 38.332 | 14.349 | 19.825 |
| hex: http/css-16kx64 | 2097280 | 21217.7 ± 0.1% | 2240.6 ± 0.1% | 1466.3 ± 0.2% | 566.7 ± 0.2% | 1450.6 ± 0.1% | 1091.1 ± 0.2% | 9.470 | 14.470 | 37.442 | 14.627 | 19.446 |
| hex: http/css-1m | 524290 | 43776.2 ± 0.1% | 2601.1 ± 0.1% | 1514.1 ± 0.3% | 540.2 ± 0.4% | 1578.4 ± 0.4% | 1068.5 ± 0.1% | 16.830 | 28.912 | 81.033 | 27.734 | 40.968 |
| hex: shuffled/dickens-1m | 524290 | 43952.8 ± 0.1% | 2590.2 ± 0.5% | 1516.4 ± 0.1% | 465.8 ± 0.1% | 1580.3 ± 0.1% | 1067.4 ± 0.1% | 16.969 | 28.985 | 94.351 | 27.813 | 41.176 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1789.1 ± 0.1% | 1476.9 ± 0.5% | 1011.2 ± 0.2% | 463.3 ± 0.7% | 451.1 ± 0.6% | 502.3 ± 0.6% | 1.211 | 1.769 | 3.862 | 3.966 | 3.562 |
| qlog records, JSON text sequence | 1467503 | 1711.7 ± 0.5% | 1242.1 ± 2.5% | 894.8 ± 0.6% | 430.6 ± 0.4% | 536.0 ± 0.9% | 353.7 ± 1.4% | 1.378 | 1.913 | 3.975 | 3.193 | 4.839 |
| messages: 11 string members | 1025025 | 1302.8 ± 0.2% | 1097.8 ± 0.7% | 742.3 ± 0.8% | 410.1 ± 0.4% | 425.4 ± 0.2% | 432.9 ± 0.5% | 1.187 | 1.755 | 3.177 | 3.062 | 3.009 |
| messages: 50 nested objects | 1121600 | 1969.3 ± 0.3% | 1862.0 ± 0.3% | 1308.2 ± 1.3% | 591.5 ± 1.3% | 617.4 ± 1.2% | 508.2 ± 0.9% | 1.058 | 1.505 | 3.329 | 3.189 | 3.875 |
| string: silesia/dickens | 172528 | 13526.7 ± 0.5% | 3959.3 ± 2.1% | 3134.8 ± 1.7% | 335.7 ± 1.0% | 1730.2 ± 1.3% | 1188.3 ± 3.2% | 3.416 | 4.315 | 40.292 | 7.818 | 11.383 |
| string: silesia/nci | 1075110 | 11572.9 ± 0.7% | 4757.8 ± 0.4% | 3140.5 ± 3.1% | 909.5 ± 0.7% | 1916.9 ± 1.4% | 1195.1 ± 2.1% | 2.432 | 3.685 | 12.724 | 6.037 | 9.684 |
| string: silesia/reymont | 1075159 | 5437.8 ± 0.8% | 1869.0 ± 1.1% | 2009.4 ± 1.5% | 379.4 ± 0.8% | 1435.1 ± 1.1% | 1039.8 ± 2.7% | 2.909 | 2.706 | 14.332 | 3.789 | 5.230 |
| string: silesia/samba | 97582 | 7413.0 ± 0.8% | 2717.0 ± 0.1% | 4108.0 ± 3.1% | 350.4 ± 1.0% | 1341.4 ± 0.3% | 1179.5 ± 5.3% | 2.728 | 1.805 | 21.157 | 5.526 | 6.285 |
| string: silesia/webster | 1098490 | 6975.8 ± 1.0% | 1996.2 ± 0.4% | 1876.4 ± 0.4% | 351.6 ± 0.6% | 1410.5 ± 1.3% | 602.6 ± 0.3% | 3.495 | 3.718 | 19.840 | 4.946 | 11.576 |
| string: silesia/xml | 1090118 | 11138.2 ± 2.1% | 3194.0 ± 0.4% | 2651.3 ± 0.4% | 608.7 ± 3.2% | 1962.0 ± 0.2% | 962.3 ± 0.5% | 3.487 | 4.201 | 18.297 | 5.677 | 11.575 |
| string: canterbury/alice29.txt | 159425 | 13443.5 ± 0.6% | 2919.6 ± 1.8% | 3160.3 ± 5.6% | 320.4 ± 0.8% | 1558.4 ± 1.7% | 1097.2 ± 0.4% | 4.604 | 4.254 | 41.960 | 8.626 | 12.253 |
| string: canterbury/asyoulik.txt | 132198 | 11550.1 ± 1.3% | 2127.6 ± 0.7% | 3151.5 ± 3.6% | 320.2 ± 0.7% | 1387.0 ± 1.5% | 967.0 ± 3.3% | 5.429 | 3.665 | 36.075 | 8.328 | 11.945 |
| string: canterbury/lcet10.txt | 441884 | 12631.7 ± 2.6% | 3120.5 ± 2.6% | 2661.1 ± 0.4% | 369.6 ± 2.9% | 1687.2 ± 1.1% | 1193.5 ± 2.8% | 4.048 | 4.747 | 34.175 | 7.487 | 10.583 |
| string: canterbury/plrabn12.txt | 503330 | 9050.1 ± 2.4% | 2340.9 ± 0.2% | 2181.2 ± 1.1% | 348.7 ± 1.4% | 1643.8 ± 1.6% | 1126.9 ± 4.0% | 3.866 | 4.149 | 25.955 | 5.506 | 8.031 |
| string: canterbury-large/E.coli | 1048578 | 33362.5 ± 0.2% | 15900.9 ± 0.3% | 3486.8 ± 0.1% | 1691.3 ± 2.0% | 3153.4 ± 0.2% | 1403.6 ± 0.3% | 2.098 | 9.568 | 19.726 | 10.580 | 23.770 |
| string: canterbury-large/bible.txt | 1055886 | 9717.9 ± 0.5% | 4880.1 ± 0.7% | 3049.9 ± 0.3% | 407.0 ± 0.7% | 2145.2 ± 0.2% | 1484.1 ± 0.6% | 1.991 | 3.186 | 23.880 | 4.530 | 6.548 |
| string: canterbury-large/world192.txt | 1103121 | 6481.6 ± 0.7% | 1742.1 ± 0.4% | 2011.8 ± 0.8% | 349.4 ± 0.6% | 1394.9 ± 0.3% | 960.0 ± 0.8% | 3.720 | 3.222 | 18.548 | 4.647 | 6.752 |
| string: http/html-1m | 1058582 | 10209.0 ± 0.8% | 4375.3 ± 1.6% | 2935.0 ± 0.3% | 421.9 ± 0.2% | 2172.9 ± 0.9% | 848.1 ± 2.6% | 2.333 | 3.478 | 24.199 | 4.698 | 12.037 |
| string: http/json-1m | 1190272 | 8456.3 ± 0.4% | 1591.7 ± 0.3% | 1972.5 ± 0.8% | 558.4 ± 0.3% | 1191.8 ± 1.0% | 845.2 ± 0.8% | 5.313 | 4.287 | 15.143 | 7.095 | 10.005 |
| string: http/js-1m | 1144362 | 6612.4 ± 1.1% | 1124.8 ± 0.1% | 1532.5 ± 0.2% | 333.2 ± 0.2% | 1122.2 ± 0.9% | 758.1 ± 2.6% | 5.879 | 4.315 | 19.847 | 5.892 | 8.722 |
| string: http/css-1m | 1097820 | 9433.8 ± 0.9% | 1487.7 ± 2.1% | 2375.0 ± 5.5% | 511.7 ± 0.3% | 1273.7 ± 0.2% | 879.2 ± 2.6% | 6.341 | 3.972 | 18.438 | 7.406 | 10.730 |
| string: dickens as Cyrillic and CJK | 1883069 | 5729.4 ± 0.8% | 3633.2 ± 3.0% | 504.7 ± 0.7% | 247.8 ± 1.2% | 453.4 ± 11.0% | 358.4 ± 0.4% | 1.577 | 11.351 | 23.120 | 12.637 | 15.987 |
| hex: silesia/dickens | 524290 | 43883.8 ± 0.0% | 2600.8 ± 0.2% | 1516.4 ± 0.1% | 461.4 ± 0.2% | 1535.2 ± 0.3% | 1068.7 ± 0.1% | 16.873 | 28.940 | 95.102 | 28.585 | 41.062 |
| hex: silesia/mozilla | 524290 | 43984.5 ± 0.0% | 2577.4 ± 0.1% | 1511.4 ± 0.3% | 388.0 ± 1.5% | 1564.9 ± 0.1% | 1071.0 ± 0.1% | 17.065 | 29.101 | 113.372 | 28.106 | 41.070 |
| hex: silesia/mr | 524290 | 43829.3 ± 0.0% | 2586.3 ± 0.5% | 1510.4 ± 0.2% | 595.1 ± 0.0% | 1533.6 ± 0.0% | 1067.6 ± 0.2% | 16.947 | 29.018 | 73.648 | 28.580 | 41.056 |
| hex: silesia/nci | 524290 | 43921.7 ± 0.1% | 2568.4 ± 0.1% | 1509.3 ± 0.2% | 756.3 ± 0.9% | 1559.3 ± 0.4% | 1069.1 ± 0.5% | 17.101 | 29.100 | 58.071 | 28.168 | 41.084 |
| hex: silesia/ooffice | 524290 | 43645.5 ± 0.4% | 2605.3 ± 0.1% | 1516.2 ± 0.2% | 321.2 ± 3.8% | 1538.9 ± 0.1% | 1067.7 ± 0.2% | 16.753 | 28.785 | 135.870 | 28.361 | 40.878 |
| hex: silesia/osdb | 524290 | 43853.2 ± 0.1% | 2598.0 ± 0.1% | 1446.9 ± 4.7% | 430.3 ± 2.7% | 1568.0 ± 0.1% | 1066.4 ± 0.1% | 16.880 | 30.309 | 101.909 | 27.968 | 41.124 |
| hex: silesia/reymont | 524290 | 43865.1 ± 0.0% | 2593.6 ± 0.3% | 1476.5 ± 4.5% | 482.2 ± 1.5% | 1535.1 ± 0.2% | 1064.8 ± 0.2% | 16.913 | 29.708 | 90.970 | 28.575 | 41.197 |
| hex: silesia/samba | 524290 | 43870.8 ± 0.1% | 2597.2 ± 9.0% | 1513.4 ± 0.5% | 338.3 ± 1.5% | 1569.1 ± 0.1% | 1067.8 ± 0.3% | 16.892 | 28.989 | 129.681 | 27.959 | 41.083 |
| hex: silesia/sao | 524290 | 43886.6 ± 0.1% | 2591.2 ± 0.1% | 1514.2 ± 0.1% | 270.9 ± 10.7% | 1555.1 ± 0.0% | 1071.0 ± 0.1% | 16.937 | 28.984 | 162.013 | 28.221 | 40.976 |
| hex: silesia/webster | 524290 | 44203.9 ± 0.2% | 2600.4 ± 0.1% | 1515.4 ± 0.0% | 436.6 ± 0.2% | 1573.2 ± 0.2% | 1068.1 ± 0.4% | 16.999 | 29.170 | 101.257 | 28.099 | 41.384 |
| hex: silesia/x-ray | 524290 | 43906.4 ± 3.7% | 2598.0 ± 0.1% | 1512.4 ± 0.1% | 423.0 ± 0.2% | 1556.5 ± 0.1% | 1070.7 ± 0.4% | 16.900 | 29.031 | 103.787 | 28.209 | 41.008 |
| hex: silesia/xml | 524290 | 43571.4 ± 0.7% | 2595.8 ± 0.4% | 1513.7 ± 0.3% | 691.1 ± 0.4% | 1573.4 ± 0.1% | 1068.5 ± 0.1% | 16.785 | 28.785 | 63.049 | 27.693 | 40.779 |
| hex: canterbury/alice29.txt | 304180 | 43894.0 ± 0.0% | 2621.4 ± 0.2% | 1537.3 ± 0.2% | 470.7 ± 0.2% | 1593.4 ± 0.1% | 1093.1 ± 0.2% | 16.744 | 28.553 | 93.248 | 27.548 | 40.155 |
| hex: canterbury/asyoulik.txt | 250360 | 43211.3 ± 0.2% | 2623.0 ± 0.1% | 1551.4 ± 2.1% | 459.6 ± 1.9% | 1592.5 ± 0.1% | 1092.0 ± 0.1% | 16.474 | 27.854 | 94.011 | 27.134 | 39.572 |
| hex: canterbury/cp.html | 49208 | 42952.1 ± 0.0% | 2603.6 ± 0.1% | 1539.9 ± 4.9% | 482.9 ± 0.5% | 1593.7 ± 0.0% | 1097.4 ± 0.0% | 16.497 | 27.893 | 88.950 | 26.951 | 39.141 |
| hex: canterbury/fields.c | 22302 | 42382.8 ± 1.0% | 2651.0 ± 0.3% | 1556.3 ± 0.1% | 603.6 ± 0.5% | 1607.7 ± 0.1% | 1104.5 ± 0.1% | 15.987 | 27.233 | 70.213 | 26.363 | 38.371 |
| hex: canterbury/grammar.lsp | 7444 | 40240.5 ± 0.0% | 2677.6 ± 0.4% | 1569.2 ± 0.1% | 818.9 ± 0.3% | 1609.4 ± 0.1% | 1113.1 ± 0.4% | 15.029 | 25.644 | 49.140 | 25.003 | 36.153 |
| hex: canterbury/kennedy.xls | 524290 | 43829.6 ± 0.1% | 2573.4 ± 0.1% | 1509.0 ± 0.1% | 789.6 ± 0.2% | 1570.7 ± 0.1% | 1067.5 ± 0.3% | 17.032 | 29.046 | 55.510 | 27.905 | 41.060 |
| hex: canterbury/lcet10.txt | 524290 | 43761.2 ± 0.2% | 2597.0 ± 0.1% | 1513.2 ± 0.2% | 471.6 ± 0.1% | 1580.2 ± 0.1% | 1069.4 ± 0.2% | 16.851 | 28.920 | 92.784 | 27.694 | 40.922 |
| hex: canterbury/plrabn12.txt | 524290 | 42829.7 ± 0.2% | 2588.1 ± 0.3% | 1512.5 ± 0.3% | 455.8 ± 0.3% | 1573.2 ± 0.1% | 1071.6 ± 0.4% | 16.548 | 28.318 | 93.973 | 27.224 | 39.968 |
| hex: canterbury/ptt5 | 524290 | 43926.5 ± 0.2% | 2573.7 ± 8.6% | 1508.6 ± 0.1% | 597.7 ± 0.7% | 1573.6 ± 0.1% | 1069.6 ± 0.2% | 17.067 | 29.118 | 73.488 | 27.915 | 41.069 |
| hex: canterbury/sum | 76482 | 43045.6 ± 0.4% | 2597.5 ± 0.2% | 1530.8 ± 0.3% | 563.5 ± 3.3% | 1586.4 ± 0.2% | 1095.5 ± 0.1% | 16.572 | 28.120 | 76.394 | 27.134 | 39.293 |
| hex: canterbury/xargs.1 | 8456 | 40583.4 ± 0.3% | 2676.2 ± 0.5% | 1571.5 ± 0.1% | 842.5 ± 0.1% | 1607.6 ± 0.3% | 1116.1 ± 0.6% | 15.165 | 25.824 | 48.168 | 25.245 | 36.360 |
| hex: canterbury-large/E.coli | 524290 | 43881.2 ± 6.2% | 2575.9 ± 1.1% | 1507.7 ± 0.1% | 816.8 ± 0.0% | 1567.6 ± 0.1% | 1069.2 ± 0.1% | 17.036 | 29.105 | 53.720 | 27.992 | 41.043 |
| hex: canterbury-large/bible.txt | 524290 | 43910.4 ± 0.1% | 2599.0 ± 0.3% | 1514.5 ± 0.1% | 484.1 ± 0.1% | 1575.0 ± 0.1% | 1068.6 ± 5.4% | 16.895 | 28.993 | 90.705 | 27.879 | 41.092 |
| hex: canterbury-large/world192.txt | 524290 | 43853.5 ± 1.4% | 2586.0 ± 0.1% | 1513.3 ± 0.1% | 460.0 ± 0.1% | 1569.2 ± 0.1% | 1013.5 ± 5.0% | 16.958 | 28.978 | 95.343 | 27.946 | 43.270 |
| hex: http/html-1kx1024 | 2099200 | 21238.4 ± 1.7% | 2333.1 ± 0.6% | 1484.9 ± 0.3% | 502.7 ± 0.2% | 1494.2 ± 0.8% | 1083.2 ± 0.1% | 9.103 | 14.303 | 42.251 | 14.214 | 19.606 |
| hex: http/html-16kx64 | 2097280 | 22497.2 ± 1.5% | 2243.3 ± 0.2% | 1466.5 ± 0.1% | 506.4 ± 0.2% | 1450.0 ± 0.1% | 1092.0 ± 0.1% | 10.028 | 15.340 | 44.425 | 15.515 | 20.601 |
| hex: http/html-1m | 524290 | 43510.6 ± 7.7% | 2592.3 ± 0.0% | 1516.4 ± 0.1% | 492.9 ± 0.1% | 1574.6 ± 0.0% | 1066.6 ± 0.3% | 16.785 | 28.693 | 88.276 | 27.633 | 40.795 |
| hex: http/json-1kx1024 | 2099200 | 20518.9 ± 0.7% | 2326.4 ± 1.0% | 1479.2 ± 0.5% | 699.1 ± 0.3% | 1491.3 ± 0.8% | 1082.6 ± 0.2% | 8.820 | 13.871 | 29.349 | 13.759 | 18.954 |
| hex: http/json-16kx64 | 2097280 | 21395.2 ± 0.3% | 2236.8 ± 0.2% | 1463.4 ± 0.3% | 708.9 ± 0.2% | 1445.5 ± 4.6% | 1090.3 ± 0.2% | 9.565 | 14.620 | 30.180 | 14.801 | 19.624 |
| hex: http/json-1m | 524290 | 43373.4 ± 3.5% | 2590.5 ± 0.1% | 1509.1 ± 0.1% | 738.8 ± 0.1% | 1575.5 ± 0.2% | 1067.4 ± 0.2% | 16.743 | 28.741 | 58.705 | 27.530 | 40.636 |
| hex: http/js-1kx1024 | 2099200 | 20928.0 ± 0.3% | 2346.2 ± 1.7% | 1481.7 ± 1.0% | 492.7 ± 3.5% | 1490.2 ± 4.9% | 1082.3 ± 0.5% | 8.920 | 14.124 | 42.479 | 14.043 | 19.337 |
| hex: http/js-16kx64 | 2097280 | 21651.6 ± 0.3% | 2236.9 ± 0.2% | 1464.3 ± 0.1% | 494.5 ± 0.2% | 1450.9 ± 0.1% | 1090.9 ± 0.4% | 9.679 | 14.786 | 43.784 | 14.923 | 19.847 |
| hex: http/js-1m | 524290 | 43855.6 ± 0.3% | 2602.6 ± 0.1% | 1514.4 ± 0.4% | 509.6 ± 0.1% | 1578.6 ± 0.0% | 1067.9 ± 0.2% | 16.850 | 28.960 | 86.059 | 27.782 | 41.066 |
| hex: http/css-1kx1024 | 2099200 | 21497.0 ± 0.8% | 2344.5 ± 1.3% | 1486.9 ± 0.2% | 559.3 ± 0.3% | 1494.2 ± 1.6% | 1081.5 ± 1.7% | 9.169 | 14.457 | 38.433 | 14.387 | 19.877 |
| hex: http/css-16kx64 | 2097280 | 21283.3 ± 0.2% | 2240.6 ± 0.1% | 1466.3 ± 0.2% | 566.7 ± 0.2% | 1450.6 ± 0.1% | 1091.1 ± 0.2% | 9.499 | 14.515 | 37.558 | 14.672 | 19.506 |
| hex: http/css-1m | 524290 | 43800.6 ± 0.1% | 2601.1 ± 0.1% | 1514.1 ± 0.3% | 540.2 ± 0.4% | 1578.4 ± 0.4% | 1068.5 ± 0.1% | 16.839 | 28.928 | 81.078 | 27.749 | 40.991 |
| hex: shuffled/dickens-1m | 524290 | 43954.8 ± 0.1% | 2590.2 ± 0.5% | 1516.4 ± 0.1% | 465.8 ± 0.1% | 1580.3 ± 0.1% | 1067.4 ± 0.1% | 16.970 | 28.987 | 94.355 | 27.814 | 41.178 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1152.6 ± 0.4% | 1548.8 ± 8.8% | 1112.6 ± 12.6% | 394.9 ± 0.6% | 659.2 ± 0.4% | 369.2 ± 1.9% | 0.744 | 1.036 | 2.919 | 1.748 | 3.122 |
| qlog records, JSON text sequence | 1467503 | 1019.0 ± 1.1% | 1242.9 ± 1.1% | 1106.1 ± 0.8% | 333.5 ± 1.0% | 734.9 ± 1.4% | 318.5 ± 0.7% | 0.820 | 0.921 | 3.055 | 1.387 | 3.200 |
| messages: 11 string members | 1025025 | 943.7 ± 0.3% | 2049.7 ± 4.4% | 780.2 ± 0.4% | 336.6 ± 0.9% | 497.8 ± 0.4% | 305.9 ± 0.3% | 0.460 | 1.210 | 2.803 | 1.896 | 3.085 |
| messages: 50 nested objects | 1121600 | 1243.7 ± 0.5% | 1755.6 ± 2.5% | 1449.9 ± 0.9% | 433.5 ± 1.1% | 909.0 ± 0.4% | 424.2 ± 0.9% | 0.708 | 0.858 | 2.869 | 1.368 | 2.932 |
| string: silesia/dickens | 172528 | 6727.9 ± 0.5% | 3468.2 ± 2.7% | 2827.9 ± 1.4% | 319.2 ± 0.3% | 3376.0 ± 1.3% | 567.6 ± 2.7% | 1.940 | 2.379 | 21.080 | 1.993 | 11.854 |
| string: silesia/nci | 1075110 | 5422.4 ± 0.6% | 3898.3 ± 0.4% | 2995.7 ± 0.2% | 652.6 ± 0.6% | 3671.9 ± 0.5% | 578.1 ± 2.2% | 1.391 | 1.810 | 8.309 | 1.477 | 9.380 |
| string: silesia/reymont | 1075159 | 3481.8 ± 0.8% | 3420.4 ± 0.2% | 2010.9 ± 2.7% | 342.6 ± 0.2% | 2091.3 ± 0.7% | 493.4 ± 1.1% | 1.018 | 1.731 | 10.162 | 1.665 | 7.057 |
| string: silesia/samba | 97582 | 4021.8 ± 0.8% | 3821.9 ± 0.4% | 3133.1 ± 0.2% | 329.2 ± 3.1% | 2059.9 ± 0.4% | 417.7 ± 1.6% | 1.052 | 1.284 | 12.219 | 1.952 | 9.628 |
| string: silesia/webster | 1098490 | 4397.5 ± 0.6% | 2438.0 ± 0.3% | 1741.4 ± 0.3% | 310.8 ± 1.4% | 2111.0 ± 0.6% | 452.2 ± 3.0% | 1.804 | 2.525 | 14.150 | 2.083 | 9.725 |
| string: silesia/xml | 1090118 | 6068.5 ± 0.2% | 5015.6 ± 0.1% | 2506.5 ± 0.2% | 511.2 ± 0.3% | 3372.2 ± 0.2% | 532.0 ± 1.6% | 1.210 | 2.421 | 11.870 | 1.800 | 11.407 |
| string: canterbury/alice29.txt | 159425 | 5777.3 ± 0.5% | 2785.7 ± 1.5% | 2875.8 ± 1.5% | 301.7 ± 0.2% | 3047.5 ± 4.0% | 518.6 ± 0.5% | 2.074 | 2.009 | 19.148 | 1.896 | 11.139 |
| string: canterbury/asyoulik.txt | 132198 | 4312.5 ± 0.7% | 2640.8 ± 0.6% | 2697.1 ± 1.1% | 306.3 ± 0.3% | 2465.0 ± 0.7% | 457.3 ± 2.5% | 1.633 | 1.599 | 14.081 | 1.749 | 9.429 |
| string: canterbury/lcet10.txt | 441884 | 6700.5 ± 0.6% | 3303.4 ± 0.2% | 2376.1 ± 0.7% | 348.2 ± 0.4% | 3036.8 ± 0.9% | 569.1 ± 1.0% | 2.028 | 2.820 | 19.243 | 2.206 | 11.773 |
| string: canterbury/plrabn12.txt | 503330 | 5510.3 ± 0.1% | 3182.8 ± 0.2% | 1862.9 ± 0.4% | 323.8 ± 0.2% | 2874.3 ± 0.3% | 532.8 ± 1.4% | 1.731 | 2.958 | 17.015 | 1.917 | 10.343 |
| string: canterbury-large/E.coli | 1048578 | 34083.7 ± 0.1% | 13326.6 ± 0.2% | 3376.7 ± 0.5% | 1285.5 ± 0.1% | 8974.6 ± 0.2% | 931.2 ± 3.4% | 2.558 | 10.094 | 26.513 | 3.798 | 36.601 |
| string: canterbury-large/bible.txt | 1055886 | 8514.2 ± 2.4% | 5293.5 ± 1.1% | 2799.7 ± 0.3% | 360.1 ± 0.6% | 3872.5 ± 0.4% | 622.2 ± 4.3% | 1.608 | 3.041 | 23.646 | 2.199 | 13.685 |
| string: canterbury-large/world192.txt | 1103121 | 4124.4 ± 0.7% | 2305.6 ± 0.2% | 1803.7 ± 0.2% | 329.2 ± 1.8% | 2186.3 ± 2.4% | 466.8 ± 1.5% | 1.789 | 2.287 | 12.528 | 1.886 | 8.835 |
| string: http/html-1m | 1058582 | 8542.2 ± 8.1% | 4778.9 ± 1.4% | 2720.8 ± 1.5% | 428.8 ± 1.1% | 3568.2 ± 0.5% | 594.7 ± 2.0% | 1.788 | 3.140 | 19.922 | 2.394 | 14.364 |
| string: http/json-1m | 1190272 | 3250.9 ± 1.9% | 1255.9 ± 0.4% | 2120.1 ± 0.1% | 472.9 ± 0.6% | 1362.0 ± 1.1% | 435.2 ± 0.8% | 2.589 | 1.533 | 6.875 | 2.387 | 7.470 |
| string: http/js-1m | 1144362 | 2874.5 ± 1.3% | 1609.6 ± 0.1% | 1331.1 ± 0.3% | 330.3 ± 3.0% | 1413.9 ± 0.6% | 380.9 ± 0.3% | 1.786 | 2.160 | 8.703 | 2.033 | 7.547 |
| string: http/css-1m | 1097820 | 3299.9 ± 0.1% | 2886.0 ± 0.7% | 2283.9 ± 1.0% | 458.3 ± 0.4% | 2114.6 ± 2.9% | 442.3 ± 1.3% | 1.143 | 1.445 | 7.201 | 1.560 | 7.461 |
| string: dickens as Cyrillic and CJK | 1883069 | 5805.7 ± 1.8% | 2892.8 ± 2.9% | 688.2 ± 0.2% | 380.5 ± 1.8% | 497.4 ± 0.2% | 166.5 ± 2.6% | 2.007 | 8.436 | 15.257 | 11.673 | 34.874 |
| string: dickens as Cyrillic and CJK, as \u escapes | 5075485 | 1214.6 ± 0.3% | 1247.7 ± 1.6% | 1113.2 ± 0.7% | 264.4 ± 1.1% | 470.8 ± 0.1% | 230.1 ± 6.2% | 0.974 | 1.091 | 4.594 | 2.580 | 5.279 |
| hex: silesia/dickens | 524290 | 34064.8 ± 3.6% | 15210.1 ± 0.1% | 3576.8 ± 0.1% | 481.5 ± 0.3% | 8992.2 ± 0.1% | 1137.4 ± 1.6% | 2.240 | 9.524 | 70.743 | 3.788 | 29.950 |
| hex: silesia/mozilla | 524290 | 34075.4 ± 0.1% | 15218.3 ± 2.7% | 3507.9 ± 0.2% | 431.1 ± 0.3% | 8969.7 ± 0.4% | 1140.0 ± 1.2% | 2.239 | 9.714 | 79.035 | 3.799 | 29.891 |
| hex: silesia/mr | 524290 | 34075.6 ± 0.1% | 15210.2 ± 0.0% | 3508.9 ± 0.2% | 651.0 ± 0.2% | 8973.9 ± 0.2% | 1139.9 ± 0.1% | 2.240 | 9.711 | 52.343 | 3.797 | 29.894 |
| hex: silesia/nci | 524290 | 34042.3 ± 0.3% | 15212.0 ± 2.9% | 3577.9 ± 0.2% | 764.0 ± 0.4% | 8988.7 ± 0.3% | 1139.4 ± 0.7% | 2.238 | 9.515 | 44.555 | 3.787 | 29.877 |
| hex: silesia/ooffice | 524290 | 34076.6 ± 0.2% | 15202.0 ± 0.2% | 3510.7 ± 1.4% | 345.0 ± 0.3% | 8984.4 ± 0.1% | 1139.2 ± 0.8% | 2.242 | 9.706 | 98.779 | 3.793 | 29.913 |
| hex: silesia/osdb | 524290 | 34079.1 ± 3.9% | 15214.7 ± 0.1% | 3508.8 ± 0.2% | 457.2 ± 1.2% | 8981.8 ± 0.2% | 1137.6 ± 0.6% | 2.240 | 9.712 | 74.542 | 3.794 | 29.956 |
| hex: silesia/reymont | 524290 | 34055.6 ± 4.1% | 15213.4 ± 0.3% | 3558.2 ± 3.3% | 496.6 ± 0.5% | 8992.2 ± 2.2% | 1138.8 ± 3.2% | 2.239 | 9.571 | 68.574 | 3.787 | 29.905 |
| hex: silesia/samba | 524290 | 34056.5 ± 1.0% | 15209.4 ± 0.2% | 3510.6 ± 0.2% | 366.6 ± 0.2% | 8973.7 ± 4.8% | 1138.6 ± 0.4% | 2.239 | 9.701 | 92.887 | 3.795 | 29.911 |
| hex: silesia/sao | 524290 | 34051.5 ± 0.1% | 15213.0 ± 0.1% | 3511.7 ± 0.2% | 280.9 ± 0.2% | 8974.2 ± 0.2% | 1140.5 ± 0.1% | 2.238 | 9.697 | 121.209 | 3.794 | 29.858 |
| hex: silesia/webster | 524290 | 34055.7 ± 0.1% | 15214.2 ± 0.0% | 3575.0 ± 2.0% | 453.7 ± 1.1% | 8989.3 ± 0.4% | 1145.6 ± 3.5% | 2.238 | 9.526 | 75.067 | 3.788 | 29.728 |
| hex: silesia/x-ray | 524290 | 34051.8 ± 0.1% | 15192.8 ± 2.3% | 3508.4 ± 0.1% | 427.5 ± 1.4% | 8976.7 ± 0.2% | 1142.2 ± 0.8% | 2.241 | 9.706 | 79.652 | 3.793 | 29.812 |
| hex: silesia/xml | 524290 | 34082.1 ± 3.6% | 15220.0 ± 0.0% | 3575.3 ± 3.2% | 709.4 ± 1.0% | 8988.4 ± 0.1% | 1141.2 ± 3.6% | 2.239 | 9.533 | 48.042 | 3.792 | 29.864 |
| hex: canterbury/alice29.txt | 304180 | 34049.1 ± 0.3% | 14295.1 ± 0.1% | 3581.8 ± 0.4% | 486.3 ± 0.2% | 8993.8 ± 4.0% | 1150.2 ± 0.4% | 2.382 | 9.506 | 70.013 | 3.786 | 29.602 |
| hex: canterbury/asyoulik.txt | 250360 | 33966.3 ± 0.4% | 15172.2 ± 0.1% | 3507.9 ± 0.3% | 471.7 ± 0.6% | 8973.1 ± 0.3% | 1147.2 ± 0.7% | 2.239 | 9.683 | 72.016 | 3.785 | 29.607 |
| hex: canterbury/cp.html | 49208 | 33574.5 ± 0.1% | 14490.0 ± 2.8% | 3578.5 ± 0.2% | 500.3 ± 0.7% | 9349.6 ± 0.1% | 1137.0 ± 1.0% | 2.317 | 9.382 | 67.104 | 3.591 | 29.530 |
| hex: canterbury/fields.c | 22302 | 33136.4 ± 0.1% | 17741.0 ± 0.1% | 3685.2 ± 0.3% | 528.1 ± 0.4% | 9334.2 ± 0.4% | 1101.9 ± 1.5% | 1.868 | 8.992 | 62.750 | 3.550 | 30.071 |
| hex: canterbury/grammar.lsp | 7444 | 29927.6 ± 0.3% | 17330.3 ± 0.2% | 3636.2 ± 0.4% | 701.5 ± 1.9% | 9078.4 ± 0.1% | 1078.9 ± 1.3% | 1.727 | 8.230 | 42.663 | 3.297 | 27.739 |
| hex: canterbury/kennedy.xls | 524290 | 34056.4 ± 0.1% | 15189.2 ± 0.1% | 3581.6 ± 0.2% | 758.6 ± 0.3% | 8990.8 ± 0.1% | 1126.5 ± 3.6% | 2.242 | 9.509 | 44.894 | 3.788 | 30.231 |
| hex: canterbury/lcet10.txt | 524290 | 34052.7 ± 0.3% | 15187.3 ± 0.2% | 3579.3 ± 0.3% | 486.8 ± 0.2% | 8993.2 ± 0.3% | 1135.8 ± 2.2% | 2.242 | 9.514 | 69.959 | 3.786 | 29.981 |
| hex: canterbury/plrabn12.txt | 524290 | 34067.9 ± 0.1% | 15193.7 ± 0.1% | 3575.8 ± 0.2% | 469.3 ± 0.4% | 8990.2 ± 0.2% | 1139.5 ± 0.2% | 2.242 | 9.527 | 72.587 | 3.789 | 29.898 |
| hex: canterbury/ptt5 | 524290 | 34055.7 ± 0.1% | 15192.8 ± 0.1% | 3509.7 ± 0.1% | 666.9 ± 0.3% | 8977.4 ± 0.3% | 1139.6 ± 0.3% | 2.242 | 9.703 | 51.065 | 3.793 | 29.884 |
| hex: canterbury/sum | 76482 | 33473.7 ± 0.2% | 15518.6 ± 0.2% | 3580.5 ± 0.2% | 576.3 ± 0.3% | 8955.2 ± 0.1% | 1135.4 ± 1.1% | 2.157 | 9.349 | 58.086 | 3.738 | 29.481 |
| hex: canterbury/xargs.1 | 8456 | 30424.2 ± 0.2% | 17465.5 ± 0.2% | 3584.5 ± 0.2% | 685.1 ± 2.6% | 9065.3 ± 0.1% | 1113.6 ± 1.7% | 1.742 | 8.488 | 44.409 | 3.356 | 27.322 |
| hex: canterbury-large/E.coli | 524290 | 34053.7 ± 0.2% | 15212.7 ± 0.1% | 3498.4 ± 0.1% | 966.9 ± 0.4% | 8978.6 ± 4.9% | 1134.5 ± 5.4% | 2.238 | 9.734 | 35.218 | 3.793 | 30.017 |
| hex: canterbury-large/bible.txt | 524290 | 34037.0 ± 0.5% | 15208.4 ± 0.1% | 3506.7 ± 0.2% | 504.3 ± 0.3% | 8966.9 ± 0.3% | 1132.6 ± 1.8% | 2.238 | 9.706 | 67.491 | 3.796 | 30.052 |
| hex: canterbury-large/world192.txt | 524290 | 34069.4 ± 3.9% | 15206.8 ± 1.6% | 3577.9 ± 0.8% | 465.4 ± 0.4% | 8991.7 ± 0.2% | 1140.8 ± 1.2% | 2.240 | 9.522 | 73.198 | 3.789 | 29.866 |
| hex: http/html-1kx1024 | 2099200 | 14595.0 ± 2.7% | 11769.9 ± 0.9% | 3130.2 ± 2.2% | 497.0 ± 0.5% | 7711.3 ± 5.4% | 985.7 ± 0.4% | 1.240 | 4.663 | 29.364 | 1.893 | 14.807 |
| hex: http/html-16kx64 | 2097280 | 26940.4 ± 2.4% | 13879.7 ± 0.3% | 3400.2 ± 0.1% | 502.6 ± 3.2% | 8409.8 ± 0.8% | 1086.4 ± 2.2% | 1.941 | 7.923 | 53.604 | 3.203 | 24.798 |
| hex: http/html-1m | 524290 | 34050.6 ± 3.1% | 15200.6 ± 0.1% | 3512.7 ± 0.3% | 503.5 ± 0.6% | 8977.6 ± 0.2% | 1112.9 ± 5.1% | 2.240 | 9.693 | 67.632 | 3.793 | 30.597 |
| hex: http/json-1kx1024 | 2099200 | 14555.2 ± 1.2% | 12103.7 ± 0.2% | 3129.2 ± 0.1% | 660.4 ± 2.9% | 7683.6 ± 0.8% | 974.2 ± 1.8% | 1.203 | 4.651 | 22.041 | 1.894 | 14.941 |
| hex: http/json-16kx64 | 2097280 | 27425.1 ± 0.5% | 13775.7 ± 0.1% | 3397.7 ± 0.2% | 672.7 ± 0.6% | 8448.9 ± 0.8% | 1083.6 ± 1.8% | 1.991 | 8.072 | 40.769 | 3.246 | 25.309 |
| hex: http/json-1m | 524290 | 34066.6 ± 0.1% | 15214.5 ± 0.1% | 3580.6 ± 0.1% | 702.1 ± 0.8% | 8986.6 ± 0.3% | 1152.2 ± 2.3% | 2.239 | 9.514 | 48.524 | 3.791 | 29.567 |
| hex: http/js-1kx1024 | 2099200 | 14825.8 ± 1.3% | 12196.8 ± 0.7% | 3141.7 ± 0.0% | 478.8 ± 0.3% | 7674.1 ± 0.8% | 991.1 ± 1.1% | 1.216 | 4.719 | 30.962 | 1.932 | 14.959 |
| hex: http/js-16kx64 | 2097280 | 27473.6 ± 0.2% | 13869.5 ± 0.2% | 3394.5 ± 0.3% | 483.7 ± 0.2% | 8247.2 ± 0.2% | 1100.3 ± 2.1% | 1.981 | 8.094 | 56.794 | 3.331 | 24.970 |
| hex: http/js-1m | 524290 | 34079.8 ± 0.6% | 15198.3 ± 0.3% | 3570.3 ± 0.4% | 500.2 ± 0.4% | 8989.1 ± 0.2% | 1148.1 ± 1.8% | 2.242 | 9.545 | 68.135 | 3.791 | 29.684 |
| hex: http/css-1kx1024 | 2099200 | 14720.8 ± 1.1% | 12618.2 ± 3.1% | 3138.2 ± 0.0% | 555.5 ± 0.6% | 7691.4 ± 0.7% | 986.4 ± 0.7% | 1.167 | 4.691 | 26.503 | 1.914 | 14.923 |
| hex: http/css-16kx64 | 2097280 | 27811.0 ± 0.7% | 13962.7 ± 0.3% | 3395.1 ± 0.0% | 566.6 ± 0.3% | 8698.1 ± 1.1% | 1095.9 ± 2.3% | 1.992 | 8.191 | 49.084 | 3.197 | 25.378 |
| hex: http/css-1m | 524290 | 34075.1 ± 0.0% | 15210.1 ± 2.0% | 3583.2 ± 0.1% | 545.9 ± 0.4% | 8986.4 ± 0.2% | 1126.6 ± 2.9% | 2.240 | 9.510 | 62.417 | 3.792 | 30.247 |
| hex: shuffled/dickens-1m | 524290 | 34073.9 ± 0.1% | 15214.8 ± 0.1% | 3504.6 ± 0.1% | 480.4 ± 0.4% | 8971.3 ± 0.2% | 1134.2 ± 3.4% | 2.240 | 9.723 | 70.931 | 3.798 | 30.042 |

## TextReader.next_items against the baselines

stdx's decoder a slice of tokens a call through `TextReader.next_items`, as a caller that reads a text's values in a loop calls it (decision 79). Octets are the text's. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1283.9 ± 0.4% | 1548.8 ± 8.8% | 1112.6 ± 12.6% | 394.9 ± 0.6% | 659.2 ± 0.4% | 369.2 ± 1.9% | 0.829 | 1.154 | 3.251 | 1.948 | 3.478 |
| qlog records, JSON text sequence | 1467503 | 1144.7 ± 1.9% | 1242.9 ± 1.1% | 1106.1 ± 0.8% | 333.5 ± 1.0% | 734.9 ± 1.4% | 318.5 ± 0.7% | 0.921 | 1.035 | 3.432 | 1.558 | 3.594 |
| messages: 11 string members | 1025025 | 1020.9 ± 0.3% | 2049.7 ± 4.4% | 780.2 ± 0.4% | 336.6 ± 0.9% | 497.8 ± 0.4% | 305.9 ± 0.3% | 0.498 | 1.309 | 3.033 | 2.051 | 3.337 |
| messages: 50 nested objects | 1121600 | 1302.6 ± 0.3% | 1755.6 ± 2.5% | 1449.9 ± 0.9% | 433.5 ± 1.1% | 909.0 ± 0.4% | 424.2 ± 0.9% | 0.742 | 0.898 | 3.005 | 1.433 | 3.071 |
| string: silesia/dickens | 172528 | 6720.4 ± 0.2% | 3468.2 ± 2.7% | 2827.9 ± 1.4% | 319.2 ± 0.3% | 3376.0 ± 1.3% | 567.6 ± 2.7% | 1.938 | 2.376 | 21.056 | 1.991 | 11.841 |
| string: silesia/nci | 1075110 | 5435.1 ± 0.3% | 3898.3 ± 0.4% | 2995.7 ± 0.2% | 652.6 ± 0.6% | 3671.9 ± 0.5% | 578.1 ± 2.2% | 1.394 | 1.814 | 8.329 | 1.480 | 9.402 |
| string: silesia/reymont | 1075159 | 3507.8 ± 6.2% | 3420.4 ± 0.2% | 2010.9 ± 2.7% | 342.6 ± 0.2% | 2091.3 ± 0.7% | 493.4 ± 1.1% | 1.026 | 1.744 | 10.237 | 1.677 | 7.110 |
| string: silesia/samba | 97582 | 4019.1 ± 0.3% | 3821.9 ± 0.4% | 3133.1 ± 0.2% | 329.2 ± 3.1% | 2059.9 ± 0.4% | 417.7 ± 1.6% | 1.052 | 1.283 | 12.211 | 1.951 | 9.622 |
| string: silesia/webster | 1098490 | 4430.1 ± 0.5% | 2438.0 ± 0.3% | 1741.4 ± 0.3% | 310.8 ± 1.4% | 2111.0 ± 0.6% | 452.2 ± 3.0% | 1.817 | 2.544 | 14.255 | 2.099 | 9.797 |
| string: silesia/xml | 1090118 | 6093.5 ± 0.4% | 5015.6 ± 0.1% | 2506.5 ± 0.2% | 511.2 ± 0.3% | 3372.2 ± 0.2% | 532.0 ± 1.6% | 1.215 | 2.431 | 11.919 | 1.807 | 11.454 |
| string: canterbury/alice29.txt | 159425 | 5825.9 ± 1.2% | 2785.7 ± 1.5% | 2875.8 ± 1.5% | 301.7 ± 0.2% | 3047.5 ± 4.0% | 518.6 ± 0.5% | 2.091 | 2.026 | 19.309 | 1.912 | 11.233 |
| string: canterbury/asyoulik.txt | 132198 | 4339.9 ± 0.6% | 2640.8 ± 0.6% | 2697.1 ± 1.1% | 306.3 ± 0.3% | 2465.0 ± 0.7% | 457.3 ± 2.5% | 1.643 | 1.609 | 14.170 | 1.761 | 9.489 |
| string: canterbury/lcet10.txt | 441884 | 6706.1 ± 0.9% | 3303.4 ± 0.2% | 2376.1 ± 0.7% | 348.2 ± 0.4% | 3036.8 ± 0.9% | 569.1 ± 1.0% | 2.030 | 2.822 | 19.259 | 2.208 | 11.783 |
| string: canterbury/plrabn12.txt | 503330 | 5511.4 ± 0.9% | 3182.8 ± 0.2% | 1862.9 ± 0.4% | 323.8 ± 0.2% | 2874.3 ± 0.3% | 532.8 ± 1.4% | 1.732 | 2.958 | 17.019 | 1.918 | 10.345 |
| string: canterbury-large/E.coli | 1048578 | 34175.6 ± 0.3% | 13326.6 ± 0.2% | 3376.7 ± 0.5% | 1285.5 ± 0.1% | 8974.6 ± 0.2% | 931.2 ± 3.4% | 2.564 | 10.121 | 26.585 | 3.808 | 36.700 |
| string: canterbury-large/bible.txt | 1055886 | 8592.4 ± 0.8% | 5293.5 ± 1.1% | 2799.7 ± 0.3% | 360.1 ± 0.6% | 3872.5 ± 0.4% | 622.2 ± 4.3% | 1.623 | 3.069 | 23.863 | 2.219 | 13.810 |
| string: canterbury-large/world192.txt | 1103121 | 4148.6 ± 0.5% | 2305.6 ± 0.2% | 1803.7 ± 0.2% | 329.2 ± 1.8% | 2186.3 ± 2.4% | 466.8 ± 1.5% | 1.799 | 2.300 | 12.601 | 1.898 | 8.887 |
| string: http/html-1m | 1058582 | 9383.5 ± 3.3% | 4778.9 ± 1.4% | 2720.8 ± 1.5% | 428.8 ± 1.1% | 3568.2 ± 0.5% | 594.7 ± 2.0% | 1.964 | 3.449 | 21.885 | 2.630 | 15.779 |
| string: http/json-1m | 1190272 | 3254.6 ± 1.8% | 1255.9 ± 0.4% | 2120.1 ± 0.1% | 472.9 ± 0.6% | 1362.0 ± 1.1% | 435.2 ± 0.8% | 2.591 | 1.535 | 6.883 | 2.390 | 7.478 |
| string: http/js-1m | 1144362 | 2875.5 ± 0.3% | 1609.6 ± 0.1% | 1331.1 ± 0.3% | 330.3 ± 3.0% | 1413.9 ± 0.6% | 380.9 ± 0.3% | 1.786 | 2.160 | 8.706 | 2.034 | 7.550 |
| string: http/css-1m | 1097820 | 3307.6 ± 0.6% | 2886.0 ± 0.7% | 2283.9 ± 1.0% | 458.3 ± 0.4% | 2114.6 ± 2.9% | 442.3 ± 1.3% | 1.146 | 1.448 | 7.218 | 1.564 | 7.478 |
| string: dickens as Cyrillic and CJK | 1883069 | 5835.2 ± 0.2% | 2892.8 ± 2.9% | 688.2 ± 0.2% | 380.5 ± 1.8% | 497.4 ± 0.2% | 166.5 ± 2.6% | 2.017 | 8.478 | 15.335 | 11.732 | 35.052 |
| string: dickens as Cyrillic and CJK, as \u escapes | 5075485 | 1213.3 ± 3.5% | 1247.7 ± 1.6% | 1113.2 ± 0.7% | 264.4 ± 1.1% | 470.8 ± 0.1% | 230.1 ± 6.2% | 0.972 | 1.090 | 4.589 | 2.577 | 5.273 |
| hex: silesia/dickens | 524290 | 34042.2 ± 0.1% | 15210.1 ± 0.1% | 3576.8 ± 0.1% | 481.5 ± 0.3% | 8992.2 ± 0.1% | 1137.4 ± 1.6% | 2.238 | 9.517 | 70.696 | 3.786 | 29.930 |
| hex: silesia/mozilla | 524290 | 34060.1 ± 0.1% | 15218.3 ± 2.7% | 3507.9 ± 0.2% | 431.1 ± 0.3% | 8969.7 ± 0.4% | 1140.0 ± 1.2% | 2.238 | 9.709 | 78.999 | 3.797 | 29.878 |
| hex: silesia/mr | 524290 | 34032.0 ± 0.2% | 15210.2 ± 0.0% | 3508.9 ± 0.2% | 651.0 ± 0.2% | 8973.9 ± 0.2% | 1139.9 ± 0.1% | 2.237 | 9.699 | 52.276 | 3.792 | 29.856 |
| hex: silesia/nci | 524290 | 34060.3 ± 0.1% | 15212.0 ± 2.9% | 3577.9 ± 0.2% | 764.0 ± 0.4% | 8988.7 ± 0.3% | 1139.4 ± 0.7% | 2.239 | 9.520 | 44.579 | 3.789 | 29.893 |
| hex: silesia/ooffice | 524290 | 34046.3 ± 0.0% | 15202.0 ± 0.2% | 3510.7 ± 1.4% | 345.0 ± 0.3% | 8984.4 ± 0.1% | 1139.2 ± 0.8% | 2.240 | 9.698 | 98.691 | 3.789 | 29.887 |
| hex: silesia/osdb | 524290 | 34029.1 ± 0.7% | 15214.7 ± 0.1% | 3508.8 ± 0.2% | 457.2 ± 1.2% | 8981.8 ± 0.2% | 1137.6 ± 0.6% | 2.237 | 9.698 | 74.433 | 3.789 | 29.912 |
| hex: silesia/reymont | 524290 | 34051.6 ± 0.1% | 15213.4 ± 0.3% | 3558.2 ± 3.3% | 496.6 ± 0.5% | 8992.2 ± 2.2% | 1138.8 ± 3.2% | 2.238 | 9.570 | 68.566 | 3.787 | 29.902 |
| hex: silesia/samba | 524290 | 34045.4 ± 0.1% | 15209.4 ± 0.2% | 3510.6 ± 0.2% | 366.6 ± 0.2% | 8973.7 ± 4.8% | 1138.6 ± 0.4% | 2.238 | 9.698 | 92.856 | 3.794 | 29.901 |
| hex: silesia/sao | 524290 | 34073.7 ± 0.1% | 15213.0 ± 0.1% | 3511.7 ± 0.2% | 280.9 ± 0.2% | 8974.2 ± 0.2% | 1140.5 ± 0.1% | 2.240 | 9.703 | 121.288 | 3.797 | 29.877 |
| hex: silesia/webster | 524290 | 34058.1 ± 3.3% | 15214.2 ± 0.0% | 3575.0 ± 2.0% | 453.7 ± 1.1% | 8989.3 ± 0.4% | 1145.6 ± 3.5% | 2.239 | 9.527 | 75.072 | 3.789 | 29.730 |
| hex: silesia/x-ray | 524290 | 34061.9 ± 0.0% | 15192.8 ± 2.3% | 3508.4 ± 0.1% | 427.5 ± 1.4% | 8976.7 ± 0.2% | 1142.2 ± 0.8% | 2.242 | 9.709 | 79.676 | 3.794 | 29.821 |
| hex: silesia/xml | 524290 | 34058.0 ± 0.1% | 15220.0 ± 0.0% | 3575.3 ± 3.2% | 709.4 ± 1.0% | 8988.4 ± 0.1% | 1141.2 ± 3.6% | 2.238 | 9.526 | 48.008 | 3.789 | 29.843 |
| hex: canterbury/alice29.txt | 304180 | 34019.3 ± 0.1% | 14295.1 ± 0.1% | 3581.8 ± 0.4% | 486.3 ± 0.2% | 8993.8 ± 4.0% | 1150.2 ± 0.4% | 2.380 | 9.498 | 69.951 | 3.783 | 29.576 |
| hex: canterbury/asyoulik.txt | 250360 | 33987.6 ± 4.4% | 15172.2 ± 0.1% | 3507.9 ± 0.3% | 471.7 ± 0.6% | 8973.1 ± 0.3% | 1147.2 ± 0.7% | 2.240 | 9.689 | 72.061 | 3.788 | 29.626 |
| hex: canterbury/cp.html | 49208 | 33555.1 ± 0.1% | 14490.0 ± 2.8% | 3578.5 ± 0.2% | 500.3 ± 0.7% | 9349.6 ± 0.1% | 1137.0 ± 1.0% | 2.316 | 9.377 | 67.066 | 3.589 | 29.513 |
| hex: canterbury/fields.c | 22302 | 33146.9 ± 0.1% | 17741.0 ± 0.1% | 3685.2 ± 0.3% | 528.1 ± 0.4% | 9334.2 ± 0.4% | 1101.9 ± 1.5% | 1.868 | 8.995 | 62.770 | 3.551 | 30.081 |
| hex: canterbury/grammar.lsp | 7444 | 29966.2 ± 0.2% | 17330.3 ± 0.2% | 3636.2 ± 0.4% | 701.5 ± 1.9% | 9078.4 ± 0.1% | 1078.9 ± 1.3% | 1.729 | 8.241 | 42.718 | 3.301 | 27.775 |
| hex: canterbury/kennedy.xls | 524290 | 34063.4 ± 0.2% | 15189.2 ± 0.1% | 3581.6 ± 0.2% | 758.6 ± 0.3% | 8990.8 ± 0.1% | 1126.5 ± 3.6% | 2.243 | 9.511 | 44.903 | 3.789 | 30.238 |
| hex: canterbury/lcet10.txt | 524290 | 34065.8 ± 0.1% | 15187.3 ± 0.2% | 3579.3 ± 0.3% | 486.8 ± 0.2% | 8993.2 ± 0.3% | 1135.8 ± 2.2% | 2.243 | 9.517 | 69.986 | 3.788 | 29.992 |
| hex: canterbury/plrabn12.txt | 524290 | 34060.9 ± 0.1% | 15193.7 ± 0.1% | 3575.8 ± 0.2% | 469.3 ± 0.4% | 8990.2 ± 0.2% | 1139.5 ± 0.2% | 2.242 | 9.525 | 72.572 | 3.789 | 29.892 |
| hex: canterbury/ptt5 | 524290 | 34064.6 ± 0.2% | 15192.8 ± 0.1% | 3509.7 ± 0.1% | 666.9 ± 0.3% | 8977.4 ± 0.3% | 1139.6 ± 0.3% | 2.242 | 9.706 | 51.079 | 3.794 | 29.892 |
| hex: canterbury/sum | 76482 | 33473.0 ± 0.2% | 15518.6 ± 0.2% | 3580.5 ± 0.2% | 576.3 ± 0.3% | 8955.2 ± 0.1% | 1135.4 ± 1.1% | 2.157 | 9.349 | 58.084 | 3.738 | 29.481 |
| hex: canterbury/xargs.1 | 8456 | 30452.5 ± 0.2% | 17465.5 ± 0.2% | 3584.5 ± 0.2% | 685.1 ± 2.6% | 9065.3 ± 0.1% | 1113.6 ± 1.7% | 1.744 | 8.496 | 44.450 | 3.359 | 27.347 |
| hex: canterbury-large/E.coli | 524290 | 34062.9 ± 0.4% | 15212.7 ± 0.1% | 3498.4 ± 0.1% | 966.9 ± 0.4% | 8978.6 ± 4.9% | 1134.5 ± 5.4% | 2.239 | 9.737 | 35.227 | 3.794 | 30.025 |
| hex: canterbury-large/bible.txt | 524290 | 34056.4 ± 3.5% | 15208.4 ± 0.1% | 3506.7 ± 0.2% | 504.3 ± 0.3% | 8966.9 ± 0.3% | 1132.6 ± 1.8% | 2.239 | 9.712 | 67.529 | 3.798 | 30.069 |
| hex: canterbury-large/world192.txt | 524290 | 34072.0 ± 0.1% | 15206.8 ± 1.6% | 3577.9 ± 0.8% | 465.4 ± 0.4% | 8991.7 ± 0.2% | 1140.8 ± 1.2% | 2.241 | 9.523 | 73.204 | 3.789 | 29.868 |
| hex: http/html-1kx1024 | 2099200 | 14248.4 ± 0.4% | 11769.9 ± 0.9% | 3130.2 ± 2.2% | 497.0 ± 0.5% | 7711.3 ± 5.4% | 985.7 ± 0.4% | 1.211 | 4.552 | 28.667 | 1.848 | 14.455 |
| hex: http/html-16kx64 | 2097280 | 26997.5 ± 0.2% | 13879.7 ± 0.3% | 3400.2 ± 0.1% | 502.6 ± 3.2% | 8409.8 ± 0.8% | 1086.4 ± 2.2% | 1.945 | 7.940 | 53.718 | 3.210 | 24.850 |
| hex: http/html-1m | 524290 | 34050.9 ± 0.2% | 15200.6 ± 0.1% | 3512.7 ± 0.3% | 503.5 ± 0.6% | 8977.6 ± 0.2% | 1112.9 ± 5.1% | 2.240 | 9.694 | 67.633 | 3.793 | 30.598 |
| hex: http/json-1kx1024 | 2099200 | 14218.0 ± 0.2% | 12103.7 ± 0.2% | 3129.2 ± 0.1% | 660.4 ± 2.9% | 7683.6 ± 0.8% | 974.2 ± 1.8% | 1.175 | 4.544 | 21.531 | 1.850 | 14.595 |
| hex: http/json-16kx64 | 2097280 | 27415.7 ± 0.1% | 13775.7 ± 0.1% | 3397.7 ± 0.2% | 672.7 ± 0.6% | 8448.9 ± 0.8% | 1083.6 ± 1.8% | 1.990 | 8.069 | 40.755 | 3.245 | 25.301 |
| hex: http/json-1m | 524290 | 34066.4 ± 0.1% | 15214.5 ± 0.1% | 3580.6 ± 0.1% | 702.1 ± 0.8% | 8986.6 ± 0.3% | 1152.2 ± 2.3% | 2.239 | 9.514 | 48.523 | 3.791 | 29.567 |
| hex: http/js-1kx1024 | 2099200 | 14463.7 ± 0.2% | 12196.8 ± 0.7% | 3141.7 ± 0.0% | 478.8 ± 0.3% | 7674.1 ± 0.8% | 991.1 ± 1.1% | 1.186 | 4.604 | 30.206 | 1.885 | 14.593 |
| hex: http/js-16kx64 | 2097280 | 27471.8 ± 0.3% | 13869.5 ± 0.2% | 3394.5 ± 0.3% | 483.7 ± 0.2% | 8247.2 ± 0.2% | 1100.3 ± 2.1% | 1.981 | 8.093 | 56.790 | 3.331 | 24.969 |
| hex: http/js-1m | 524290 | 34059.4 ± 0.1% | 15198.3 ± 0.3% | 3570.3 ± 0.4% | 500.2 ± 0.4% | 8989.1 ± 0.2% | 1148.1 ± 1.8% | 2.241 | 9.540 | 68.094 | 3.789 | 29.667 |
| hex: http/css-1kx1024 | 2099200 | 14402.0 ± 0.2% | 12618.2 ± 3.1% | 3138.2 ± 0.0% | 555.5 ± 0.6% | 7691.4 ± 0.7% | 986.4 ± 0.7% | 1.141 | 4.589 | 25.928 | 1.872 | 14.600 |
| hex: http/css-16kx64 | 2097280 | 27808.3 ± 0.3% | 13962.7 ± 0.3% | 3395.1 ± 0.0% | 566.6 ± 0.3% | 8698.1 ± 1.1% | 1095.9 ± 2.3% | 1.992 | 8.191 | 49.079 | 3.197 | 25.375 |
| hex: http/css-1m | 524290 | 34043.7 ± 0.1% | 15210.1 ± 2.0% | 3583.2 ± 0.1% | 545.9 ± 0.4% | 8986.4 ± 0.2% | 1126.6 ± 2.9% | 2.238 | 9.501 | 62.360 | 3.788 | 30.219 |
| hex: shuffled/dickens-1m | 524290 | 34045.3 ± 4.0% | 15214.8 ± 0.1% | 3504.6 ± 0.1% | 480.4 ± 0.4% | 8971.3 ± 0.2% | 1134.2 ± 3.4% | 2.238 | 9.714 | 70.872 | 3.795 | 30.017 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1574.4 ± 0.1% | 1476.9 ± 0.5% | 1011.2 ± 0.2% | 463.3 ± 0.7% | 451.1 ± 0.6% | 502.3 ± 0.6% | 1.066 | 1.557 | 3.398 | 3.490 | 3.135 |
| qlog records, JSON text sequence | 1467503 | 1434.9 ± 0.2% | 1242.1 ± 2.5% | 894.8 ± 0.6% | 430.6 ± 0.4% | 536.0 ± 0.9% | 353.7 ± 1.4% | 1.155 | 1.604 | 3.332 | 2.677 | 4.056 |
| messages: 11 string members | 1025025 | 1244.3 ± 0.2% | 1097.8 ± 0.7% | 742.3 ± 0.8% | 410.1 ± 0.4% | 425.4 ± 0.2% | 432.9 ± 0.5% | 1.133 | 1.676 | 3.034 | 2.925 | 2.874 |
| messages: 50 nested objects | 1121600 | 1680.5 ± 0.2% | 1862.0 ± 0.3% | 1308.2 ± 1.3% | 591.5 ± 1.3% | 617.4 ± 1.2% | 508.2 ± 0.9% | 0.903 | 1.285 | 2.841 | 2.722 | 3.307 |
| string: silesia/dickens | 172528 | 13236.7 ± 0.8% | 3959.3 ± 2.1% | 3134.8 ± 1.7% | 335.7 ± 1.0% | 1730.2 ± 1.3% | 1188.3 ± 3.2% | 3.343 | 4.222 | 39.429 | 7.650 | 11.139 |
| string: silesia/nci | 1075110 | 11122.4 ± 0.2% | 4757.8 ± 0.4% | 3140.5 ± 3.1% | 909.5 ± 0.7% | 1916.9 ± 1.4% | 1195.1 ± 2.1% | 2.338 | 3.542 | 12.229 | 5.802 | 9.307 |
| string: silesia/reymont | 1075159 | 5433.0 ± 1.0% | 1869.0 ± 1.1% | 2009.4 ± 1.5% | 379.4 ± 0.8% | 1435.1 ± 1.1% | 1039.8 ± 2.7% | 2.907 | 2.704 | 14.319 | 3.786 | 5.225 |
| string: silesia/samba | 97582 | 6371.1 ± 0.1% | 2717.0 ± 0.1% | 4108.0 ± 3.1% | 350.4 ± 1.0% | 1341.4 ± 0.3% | 1179.5 ± 5.3% | 2.345 | 1.551 | 18.184 | 4.750 | 5.401 |
| string: silesia/webster | 1098490 | 6891.9 ± 0.2% | 1996.2 ± 0.4% | 1876.4 ± 0.4% | 351.6 ± 0.6% | 1410.5 ± 1.3% | 602.6 ± 0.3% | 3.453 | 3.673 | 19.601 | 4.886 | 11.437 |
| string: silesia/xml | 1090118 | 10506.1 ± 0.6% | 3194.0 ± 0.4% | 2651.3 ± 0.4% | 608.7 ± 3.2% | 1962.0 ± 0.2% | 962.3 ± 0.5% | 3.289 | 3.963 | 17.258 | 5.355 | 10.918 |
| string: canterbury/alice29.txt | 159425 | 12756.7 ± 1.3% | 2919.6 ± 1.8% | 3160.3 ± 5.6% | 320.4 ± 0.8% | 1558.4 ± 1.7% | 1097.2 ± 0.4% | 4.369 | 4.037 | 39.817 | 8.186 | 11.627 |
| string: canterbury/asyoulik.txt | 132198 | 10726.0 ± 1.5% | 2127.6 ± 0.7% | 3151.5 ± 3.6% | 320.2 ± 0.7% | 1387.0 ± 1.5% | 967.0 ± 3.3% | 5.041 | 3.403 | 33.501 | 7.733 | 11.092 |
| string: canterbury/lcet10.txt | 441884 | 12273.9 ± 1.0% | 3120.5 ± 2.6% | 2661.1 ± 0.4% | 369.6 ± 2.9% | 1687.2 ± 1.1% | 1193.5 ± 2.8% | 3.933 | 4.612 | 33.207 | 7.275 | 10.284 |
| string: canterbury/plrabn12.txt | 503330 | 8418.0 ± 1.5% | 2340.9 ± 0.2% | 2181.2 ± 1.1% | 348.7 ± 1.4% | 1643.8 ± 1.6% | 1126.9 ± 4.0% | 3.596 | 3.859 | 24.142 | 5.121 | 7.470 |
| string: canterbury-large/E.coli | 1048578 | 33372.0 ± 0.3% | 15900.9 ± 0.3% | 3486.8 ± 0.1% | 1691.3 ± 2.0% | 3153.4 ± 0.2% | 1403.6 ± 0.3% | 2.099 | 9.571 | 19.732 | 10.583 | 23.776 |
| string: canterbury-large/bible.txt | 1055886 | 9275.6 ± 0.6% | 4880.1 ± 0.7% | 3049.9 ± 0.3% | 407.0 ± 0.7% | 2145.2 ± 0.2% | 1484.1 ± 0.6% | 1.901 | 3.041 | 22.793 | 4.324 | 6.250 |
| string: canterbury-large/world192.txt | 1103121 | 6600.8 ± 0.8% | 1742.1 ± 0.4% | 2011.8 ± 0.8% | 349.4 ± 0.6% | 1394.9 ± 0.3% | 960.0 ± 0.8% | 3.789 | 3.281 | 18.889 | 4.732 | 6.876 |
| string: http/html-1m | 1058582 | 10258.2 ± 0.2% | 4375.3 ± 1.6% | 2935.0 ± 0.3% | 421.9 ± 0.2% | 2172.9 ± 0.9% | 848.1 ± 2.6% | 2.345 | 3.495 | 24.315 | 4.721 | 12.095 |
| string: http/json-1m | 1190272 | 8278.2 ± 3.9% | 1591.7 ± 0.3% | 1972.5 ± 0.8% | 558.4 ± 0.3% | 1191.8 ± 1.0% | 845.2 ± 0.8% | 5.201 | 4.197 | 14.824 | 6.946 | 9.795 |
| string: http/js-1m | 1144362 | 6533.7 ± 0.3% | 1124.8 ± 0.1% | 1532.5 ± 0.2% | 333.2 ± 0.2% | 1122.2 ± 0.9% | 758.1 ± 2.6% | 5.809 | 4.263 | 19.611 | 5.822 | 8.618 |
| string: http/css-1m | 1097820 | 9071.3 ± 1.0% | 1487.7 ± 2.1% | 2375.0 ± 5.5% | 511.7 ± 0.3% | 1273.7 ± 0.2% | 879.2 ± 2.6% | 6.097 | 3.819 | 17.729 | 7.122 | 10.318 |
| string: dickens as Cyrillic and CJK | 1883069 | 5444.0 ± 1.3% | 3633.2 ± 3.0% | 504.7 ± 0.7% | 247.8 ± 1.2% | 453.4 ± 11.0% | 358.4 ± 0.4% | 1.498 | 10.786 | 21.969 | 12.007 | 15.190 |
| hex: silesia/dickens | 524290 | 43874.0 ± 0.0% | 2600.8 ± 0.2% | 1516.4 ± 0.1% | 461.4 ± 0.2% | 1535.2 ± 0.3% | 1068.7 ± 0.1% | 16.870 | 28.934 | 95.081 | 28.579 | 41.053 |
| hex: silesia/mozilla | 524290 | 43964.9 ± 0.0% | 2577.4 ± 0.1% | 1511.4 ± 0.3% | 388.0 ± 1.5% | 1564.9 ± 0.1% | 1071.0 ± 0.1% | 17.058 | 29.088 | 113.322 | 28.094 | 41.052 |
| hex: silesia/mr | 524290 | 43806.5 ± 0.1% | 2586.3 ± 0.5% | 1510.4 ± 0.2% | 595.1 ± 0.0% | 1533.6 ± 0.0% | 1067.6 ± 0.2% | 16.938 | 29.003 | 73.609 | 28.565 | 41.034 |
| hex: silesia/nci | 524290 | 43899.2 ± 0.2% | 2568.4 ± 0.1% | 1509.3 ± 0.2% | 756.3 ± 0.9% | 1559.3 ± 0.4% | 1069.1 ± 0.5% | 17.092 | 29.085 | 58.041 | 28.153 | 41.063 |
| hex: silesia/ooffice | 524290 | 43660.6 ± 0.1% | 2605.3 ± 0.1% | 1516.2 ± 0.2% | 321.2 ± 3.8% | 1538.9 ± 0.1% | 1067.7 ± 0.2% | 16.758 | 28.795 | 135.917 | 28.371 | 40.893 |
| hex: silesia/osdb | 524290 | 43837.2 ± 0.1% | 2598.0 ± 0.1% | 1446.9 ± 4.7% | 430.3 ± 2.7% | 1568.0 ± 0.1% | 1066.4 ± 0.1% | 16.873 | 30.298 | 101.872 | 27.957 | 41.109 |
| hex: silesia/reymont | 524290 | 43843.8 ± 0.1% | 2593.6 ± 0.3% | 1476.5 ± 4.5% | 482.2 ± 1.5% | 1535.1 ± 0.2% | 1064.8 ± 0.2% | 16.905 | 29.694 | 90.926 | 28.562 | 41.177 |
| hex: silesia/samba | 524290 | 43829.8 ± 0.1% | 2597.2 ± 9.0% | 1513.4 ± 0.5% | 338.3 ± 1.5% | 1569.1 ± 0.1% | 1067.8 ± 0.3% | 16.876 | 28.961 | 129.560 | 27.933 | 41.045 |
| hex: silesia/sao | 524290 | 43860.1 ± 6.6% | 2591.2 ± 0.1% | 1514.2 ± 0.1% | 270.9 ± 10.7% | 1555.1 ± 0.0% | 1071.0 ± 0.1% | 16.927 | 28.966 | 161.916 | 28.204 | 40.951 |
| hex: silesia/webster | 524290 | 44197.0 ± 0.1% | 2600.4 ± 0.1% | 1515.4 ± 0.0% | 436.6 ± 0.2% | 1573.2 ± 0.2% | 1068.1 ± 0.4% | 16.996 | 29.166 | 101.241 | 28.094 | 41.377 |
| hex: silesia/x-ray | 524290 | 43902.9 ± 0.1% | 2598.0 ± 0.1% | 1512.4 ± 0.1% | 423.0 ± 0.2% | 1556.5 ± 0.1% | 1070.7 ± 0.4% | 16.899 | 29.029 | 103.778 | 28.207 | 41.005 |
| hex: silesia/xml | 524290 | 43551.1 ± 0.1% | 2595.8 ± 0.4% | 1513.7 ± 0.3% | 691.1 ± 0.4% | 1573.4 ± 0.1% | 1068.5 ± 0.1% | 16.777 | 28.771 | 63.019 | 27.680 | 40.760 |
| hex: canterbury/alice29.txt | 304180 | 43835.4 ± 0.1% | 2621.4 ± 0.2% | 1537.3 ± 0.2% | 470.7 ± 0.2% | 1593.4 ± 0.1% | 1093.1 ± 0.2% | 16.722 | 28.515 | 93.124 | 27.511 | 40.101 |
| hex: canterbury/asyoulik.txt | 250360 | 43256.5 ± 0.1% | 2623.0 ± 0.1% | 1551.4 ± 2.1% | 459.6 ± 1.9% | 1592.5 ± 0.1% | 1092.0 ± 0.1% | 16.491 | 27.883 | 94.110 | 27.163 | 39.613 |
| hex: canterbury/cp.html | 49208 | 42784.9 ± 0.3% | 2603.6 ± 0.1% | 1539.9 ± 4.9% | 482.9 ± 0.5% | 1593.7 ± 0.0% | 1097.4 ± 0.0% | 16.433 | 27.784 | 88.603 | 26.846 | 38.988 |
| hex: canterbury/fields.c | 22302 | 42671.6 ± 1.1% | 2651.0 ± 0.3% | 1556.3 ± 0.1% | 603.6 ± 0.5% | 1607.7 ± 0.1% | 1104.5 ± 0.1% | 16.096 | 27.418 | 70.692 | 26.542 | 38.633 |
| hex: canterbury/grammar.lsp | 7444 | 40734.3 ± 0.3% | 2677.6 ± 0.4% | 1569.2 ± 0.1% | 818.9 ± 0.3% | 1609.4 ± 0.1% | 1113.1 ± 0.4% | 15.213 | 25.959 | 49.743 | 25.310 | 36.597 |
| hex: canterbury/kennedy.xls | 524290 | 43828.4 ± 3.0% | 2573.4 ± 0.1% | 1509.0 ± 0.1% | 789.6 ± 0.2% | 1570.7 ± 0.1% | 1067.5 ± 0.3% | 17.031 | 29.045 | 55.509 | 27.904 | 41.059 |
| hex: canterbury/lcet10.txt | 524290 | 43752.0 ± 0.2% | 2597.0 ± 0.1% | 1513.2 ± 0.2% | 471.6 ± 0.1% | 1580.2 ± 0.1% | 1069.4 ± 0.2% | 16.847 | 28.914 | 92.764 | 27.688 | 40.914 |
| hex: canterbury/plrabn12.txt | 524290 | 42815.0 ± 1.1% | 2588.1 ± 0.3% | 1512.5 ± 0.3% | 455.8 ± 0.3% | 1573.2 ± 0.1% | 1071.6 ± 0.4% | 16.543 | 28.308 | 93.941 | 27.215 | 39.954 |
| hex: canterbury/ptt5 | 524290 | 43921.4 ± 0.0% | 2573.7 ± 8.6% | 1508.6 ± 0.1% | 597.7 ± 0.7% | 1573.6 ± 0.1% | 1069.6 ± 0.2% | 17.065 | 29.115 | 73.479 | 27.912 | 41.064 |
| hex: canterbury/sum | 76482 | 43149.6 ± 0.0% | 2597.5 ± 0.2% | 1530.8 ± 0.3% | 563.5 ± 3.3% | 1586.4 ± 0.2% | 1095.5 ± 0.1% | 16.612 | 28.188 | 76.579 | 27.200 | 39.388 |
| hex: canterbury/xargs.1 | 8456 | 41326.5 ± 0.2% | 2676.2 ± 0.5% | 1571.5 ± 0.1% | 842.5 ± 0.1% | 1607.6 ± 0.3% | 1116.1 ± 0.6% | 15.442 | 26.297 | 49.050 | 25.708 | 37.026 |
| hex: canterbury-large/E.coli | 524290 | 43898.3 ± 0.1% | 2575.9 ± 1.1% | 1507.7 ± 0.1% | 816.8 ± 0.0% | 1567.6 ± 0.1% | 1069.2 ± 0.1% | 17.042 | 29.116 | 53.741 | 28.003 | 41.059 |
| hex: canterbury-large/bible.txt | 524290 | 43915.6 ± 0.2% | 2599.0 ± 0.3% | 1514.5 ± 0.1% | 484.1 ± 0.1% | 1575.0 ± 0.1% | 1068.6 ± 5.4% | 16.897 | 28.997 | 90.715 | 27.883 | 41.097 |
| hex: canterbury-large/world192.txt | 524290 | 43916.2 ± 0.1% | 2586.0 ± 0.1% | 1513.3 ± 0.1% | 460.0 ± 0.1% | 1569.2 ± 0.1% | 1013.5 ± 5.0% | 16.982 | 29.020 | 95.480 | 27.986 | 43.332 |
| hex: http/html-1kx1024 | 2099200 | 21305.9 ± 0.2% | 2333.1 ± 0.6% | 1484.9 ± 0.3% | 502.7 ± 0.2% | 1494.2 ± 0.8% | 1083.2 ± 0.1% | 9.132 | 14.349 | 42.385 | 14.259 | 19.669 |
| hex: http/html-16kx64 | 2097280 | 22590.1 ± 0.0% | 2243.3 ± 0.2% | 1466.5 ± 0.1% | 506.4 ± 0.2% | 1450.0 ± 0.1% | 1092.0 ± 0.1% | 10.070 | 15.404 | 44.609 | 15.580 | 20.687 |
| hex: http/html-1m | 524290 | 43912.2 ± 0.1% | 2592.3 ± 0.0% | 1516.4 ± 0.1% | 492.9 ± 0.1% | 1574.6 ± 0.0% | 1066.6 ± 0.3% | 16.939 | 28.958 | 89.091 | 27.888 | 41.172 |
| hex: http/json-1kx1024 | 2099200 | 20572.6 ± 1.1% | 2326.4 ± 1.0% | 1479.2 ± 0.5% | 699.1 ± 0.3% | 1491.3 ± 0.8% | 1082.6 ± 0.2% | 8.843 | 13.908 | 29.426 | 13.795 | 19.004 |
| hex: http/json-16kx64 | 2097280 | 21396.3 ± 0.4% | 2236.8 ± 0.2% | 1463.4 ± 0.3% | 708.9 ± 0.2% | 1445.5 ± 4.6% | 1090.3 ± 0.2% | 9.566 | 14.621 | 30.182 | 14.802 | 19.625 |
| hex: http/json-1m | 524290 | 43540.5 ± 0.0% | 2590.5 ± 0.1% | 1509.1 ± 0.1% | 738.8 ± 0.1% | 1575.5 ± 0.2% | 1067.4 ± 0.2% | 16.808 | 28.852 | 58.931 | 27.636 | 40.793 |
| hex: http/js-1kx1024 | 2099200 | 20958.8 ± 3.1% | 2346.2 ± 1.7% | 1481.7 ± 1.0% | 492.7 ± 3.5% | 1490.2 ± 4.9% | 1082.3 ± 0.5% | 8.933 | 14.145 | 42.542 | 14.064 | 19.366 |
| hex: http/js-16kx64 | 2097280 | 21657.7 ± 0.2% | 2236.9 ± 0.2% | 1464.3 ± 0.1% | 494.5 ± 0.2% | 1450.9 ± 0.1% | 1090.9 ± 0.4% | 9.682 | 14.790 | 43.797 | 14.927 | 19.853 |
| hex: http/js-1m | 524290 | 43867.0 ± 0.3% | 2602.6 ± 0.1% | 1514.4 ± 0.4% | 509.6 ± 0.1% | 1578.6 ± 0.0% | 1067.9 ± 0.2% | 16.855 | 28.967 | 86.082 | 27.789 | 41.077 |
| hex: http/css-1kx1024 | 2099200 | 21592.5 ± 0.2% | 2344.5 ± 1.3% | 1486.9 ± 0.2% | 559.3 ± 0.3% | 1494.2 ± 1.6% | 1081.5 ± 1.7% | 9.210 | 14.522 | 38.604 | 14.451 | 19.965 |
| hex: http/css-16kx64 | 2097280 | 21257.8 ± 0.5% | 2240.6 ± 0.1% | 1466.3 ± 0.2% | 566.7 ± 0.2% | 1450.6 ± 0.1% | 1091.1 ± 0.2% | 9.488 | 14.497 | 37.513 | 14.655 | 19.483 |
| hex: http/css-1m | 524290 | 43740.6 ± 0.3% | 2601.1 ± 0.1% | 1514.1 ± 0.3% | 540.2 ± 0.4% | 1578.4 ± 0.4% | 1068.5 ± 0.1% | 16.816 | 28.889 | 80.967 | 27.711 | 40.935 |
| hex: shuffled/dickens-1m | 524290 | 43967.5 ± 0.0% | 2590.2 ± 0.5% | 1516.4 ± 0.1% | 465.8 ± 0.1% | 1580.3 ± 0.1% | 1067.4 ± 0.1% | 16.974 | 28.995 | 94.382 | 27.822 | 41.190 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding: stdx runs at 0.891 of simdjson.
- qlog records, JSON text sequence, decoding: stdx runs at 0.885 of simdjson.
- messages: 11 string members, decoding: stdx runs at 0.517 of simdjson.
- messages: 50 nested objects, decoding: stdx runs at 0.767 of simdjson.
- messages: 50 nested objects, decoding: stdx runs at 0.929 of yyjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.744 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.820 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.921 of yyjson.
- messages: 11 string members, decoding through TextReader.next: stdx runs at 0.460 of simdjson.
- messages: 50 nested objects, decoding through TextReader.next: stdx runs at 0.708 of simdjson.
- messages: 50 nested objects, decoding through TextReader.next: stdx runs at 0.858 of yyjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next_items: stdx runs at 0.829 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next_items: stdx runs at 0.921 of simdjson.
- messages: 11 string members, decoding through TextReader.next_items: stdx runs at 0.498 of simdjson.
- messages: 50 nested objects, decoding through TextReader.next_items: stdx runs at 0.742 of simdjson.
- messages: 50 nested objects, decoding through TextReader.next_items: stdx runs at 0.898 of yyjson.
- messages: 50 nested objects, encoding through TextWriter's methods: stdx runs at 0.903 of simdjson.
