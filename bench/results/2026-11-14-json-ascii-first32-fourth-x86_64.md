# bench-json

| Field | Value |
|---|---|
| Commit | ba2323e |
| Runner label | ubuntu-24.04 |
| Image version | 20261111.127.1 |
| CPU model | Intel(R) Xeon(R) 6975P-C |
| Virtual CPUs | 4 |
| Kernel | 7.0.0-1014-aws |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/43616680590 |
| Date | 2026-11-14 |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1. The `TextReader.next_items` column is that helper's queued tokens a slice a call (decision 79), over many tokens a call.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | TextReader.next_items | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1367.2 ± 0.7% | 0.493 | 1.023 | 1.070 | 1.073 | 0.412 | 1.072 | 1.071 | 0.370 | 0.833 | 0.947 | 0.106 |
| qlog records, JSON text sequence | 1467503 | 1089.6 ± 0.7% | 0.796 | 1.063 | 1.069 | 1.069 | 0.395 | 1.068 | 1.071 | 0.366 | 0.931 | 1.084 | 0.126 |
| string: silesia/dickens | 172528 | 6677.5 ± 0.6% | 0.029 | 0.700 | 1.030 | 1.089 | 0.190 | 1.033 | 1.113 | 0.191 | 0.983 | 0.990 | 0.029 |
| string: silesia/nci | 1075110 | 5440.2 ± 0.4% | 0.035 | 0.710 | 1.035 | 1.034 | 0.283 | 1.041 | 1.035 | 0.283 | 1.006 | 1.009 | 0.035 |
| string: silesia/reymont | 1075159 | 3522.4 ± 2.5% | 0.055 | 0.627 | 0.866 | 0.871 | 0.339 | 0.813 | 0.873 | 0.338 | 0.983 | 0.991 | 0.054 |
| string: silesia/samba | 97582 | 3983.1 ± 0.9% | 0.041 | 0.904 | 1.053 | 1.057 | 0.074 | 0.853 | 1.057 | 0.074 | 0.996 | 0.999 | 0.041 |
| string: silesia/webster | 1098490 | 4377.5 ± 0.9% | 0.042 | 0.651 | 0.979 | 0.990 | 0.206 | 0.925 | 1.001 | 0.205 | 1.006 | 1.007 | 0.042 |
| string: silesia/xml | 1090118 | 6029.7 ± 0.6% | 0.032 | 0.777 | 0.942 | 0.963 | 0.242 | 0.959 | 0.968 | 0.241 | 1.007 | 1.012 | 0.032 |
| string: canterbury/alice29.txt | 159425 | 5733.0 ± 1.1% | 0.033 | 0.757 | 1.082 | 1.117 | 0.172 | 1.023 | 1.159 | 0.173 | 1.003 | 1.010 | 0.033 |
| string: canterbury/asyoulik.txt | 132198 | 4264.5 ± 0.9% | 0.043 | 0.808 | 1.130 | 1.127 | 0.184 | 1.045 | 1.132 | 0.185 | 0.999 | 1.005 | 0.042 |
| string: canterbury/lcet10.txt | 441884 | 6643.7 ± 1.0% | 0.029 | 0.608 | 1.084 | 1.101 | 0.183 | 1.037 | 1.113 | 0.184 | 0.998 | 1.001 | 0.029 |
| string: canterbury/plrabn12.txt | 503330 | 5433.8 ± 1.6% | 0.035 | 0.774 | 0.963 | 0.975 | 0.211 | 0.868 | 0.975 | 0.211 | 1.002 | 1.000 | 0.035 |
| string: canterbury-large/E.coli | 1048578 | 29270.3 ± 0.6% | 0.061 | 1.003 | 0.780 | 1.004 | 0.524 | 1.007 | 1.003 | 0.524 | 1.005 | 1.005 | 0.007 |
| string: canterbury-large/bible.txt | 1055886 | 8428.1 ± 1.8% | 0.024 | 0.628 | 0.882 | 0.885 | 0.388 | 0.894 | 0.909 | 0.384 | 0.999 | 1.010 | 0.024 |
| string: canterbury-large/world192.txt | 1103121 | 4139.4 ± 1.8% | 0.045 | 0.694 | 0.964 | 0.976 | 0.198 | 0.932 | 0.990 | 0.199 | 1.002 | 1.009 | 0.045 |
| string: http/html-1m | 1058582 | 8962.1 ± 5.8% | 0.022 | 0.570 | 0.791 | 0.797 | 0.314 | 0.760 | 0.808 | 0.314 | 0.985 | 1.068 | 0.022 |
| string: http/json-1m | 1190272 | 3327.3 ± 0.9% | 0.052 | 0.396 | 0.441 | 0.445 | 0.139 | 0.459 | 0.445 | 0.139 | 1.004 | 1.004 | 0.052 |
| string: http/js-1m | 1144362 | 2858.1 ± 0.6% | 0.061 | 0.700 | 0.893 | 0.926 | 0.178 | 0.848 | 0.926 | 0.178 | 1.002 | 1.006 | 0.061 |
| string: http/css-1m | 1097820 | 3275.9 ± 1.4% | 0.055 | 0.770 | 0.949 | 1.004 | 0.275 | 0.992 | 0.999 | 0.274 | 1.005 | 1.008 | 0.055 |
| string: dickens as Cyrillic and CJK | 1883069 | 5789.2 ± 9.4% | 0.025 | 0.062 | 0.441 | 0.441 | 0.195 | 0.434 | 0.441 | 0.194 | 0.999 | 1.005 | 0.025 |
| string: dickens as Cyrillic and CJK, as \u escapes | 5075485 | 1192.5 ± 8.8% | 0.113 | 1.002 | 1.004 | 1.005 | 0.107 | 0.719 | 1.004 | 0.107 | 1.008 | 1.014 | 0.113 |
| hex: silesia/dickens | 524290 | 42581.2 ± 1.4% | 0.043 | 0.999 | 0.627 | 0.997 | 0.415 | 0.998 | 0.999 | 0.416 | 0.794 | 0.792 | 0.005 |
| hex: silesia/mozilla | 524290 | 45101.9 ± 1.0% | 0.040 | 0.997 | 0.632 | 1.002 | 0.395 | 1.002 | 1.002 | 0.396 | 0.748 | 0.748 | 0.005 |
| hex: silesia/mr | 524290 | 44694.9 ± 0.7% | 0.041 | 0.998 | 0.603 | 0.998 | 0.382 | 0.997 | 0.996 | 0.385 | 0.757 | 0.758 | 0.005 |
| hex: silesia/nci | 524290 | 45991.3 ± 2.3% | 0.040 | 1.002 | 0.618 | 1.000 | 0.391 | 0.999 | 1.000 | 0.391 | 0.734 | 0.733 | 0.005 |
| hex: silesia/ooffice | 524290 | 46262.1 ± 0.7% | 0.040 | 1.002 | 0.617 | 1.000 | 0.387 | 1.001 | 1.001 | 0.388 | 0.731 | 0.732 | 0.005 |
| hex: silesia/osdb | 524290 | 41192.0 ± 0.8% | 0.044 | 1.006 | 0.664 | 1.000 | 0.413 | 0.998 | 1.001 | 0.417 | 0.818 | 0.822 | 0.005 |
| hex: silesia/reymont | 524290 | 45506.5 ± 1.5% | 0.040 | 0.995 | 0.629 | 0.995 | 0.395 | 0.999 | 0.995 | 0.396 | 0.741 | 0.743 | 0.005 |
| hex: silesia/samba | 524290 | 45632.6 ± 3.4% | 0.040 | 1.003 | 0.621 | 1.011 | 0.393 | 1.008 | 1.010 | 0.394 | 0.741 | 0.739 | 0.005 |
| hex: silesia/sao | 524290 | 47308.5 ± 0.8% | 0.038 | 0.995 | 0.599 | 0.997 | 0.380 | 1.000 | 0.999 | 0.380 | 0.711 | 0.713 | 0.004 |
| hex: silesia/webster | 524290 | 45692.4 ± 1.3% | 0.040 | 0.997 | 0.613 | 1.003 | 0.392 | 1.008 | 1.000 | 0.392 | 0.738 | 0.737 | 0.005 |
| hex: silesia/x-ray | 524290 | 45213.2 ± 2.0% | 0.040 | 0.998 | 0.618 | 1.001 | 0.396 | 1.000 | 0.994 | 0.397 | 0.744 | 0.745 | 0.005 |
| hex: silesia/xml | 524290 | 45428.8 ± 0.9% | 0.040 | 0.997 | 0.628 | 1.000 | 0.397 | 1.000 | 1.001 | 0.396 | 0.742 | 0.743 | 0.005 |
| hex: canterbury/alice29.txt | 304180 | 45160.4 ± 1.1% | 0.040 | 0.989 | 0.631 | 0.997 | 0.394 | 0.995 | 0.992 | 0.395 | 0.745 | 0.745 | 0.005 |
| hex: canterbury/asyoulik.txt | 250360 | 45457.1 ± 0.8% | 0.040 | 0.998 | 0.615 | 1.000 | 0.395 | 1.001 | 0.998 | 0.395 | 0.741 | 0.742 | 0.005 |
| hex: canterbury/cp.html | 49208 | 46174.0 ± 0.8% | 0.040 | 1.001 | 0.601 | 1.001 | 0.382 | 1.002 | 0.998 | 0.384 | 0.719 | 0.720 | 0.005 |
| hex: canterbury/fields.c | 22302 | 49523.3 ± 1.5% | 0.037 | 1.023 | 0.547 | 1.003 | 0.399 | 0.991 | 1.001 | 0.406 | 0.661 | 0.661 | 0.004 |
| hex: canterbury/grammar.lsp | 7444 | 44151.3 ± 3.4% | 0.042 | 0.974 | 0.573 | 0.998 | 0.408 | 0.975 | 1.001 | 0.428 | 0.672 | 0.671 | 0.005 |
| hex: canterbury/kennedy.xls | 524290 | 46109.9 ± 0.8% | 0.040 | 0.998 | 0.613 | 0.997 | 0.389 | 0.998 | 0.999 | 0.391 | 0.735 | 0.734 | 0.005 |
| hex: canterbury/lcet10.txt | 524290 | 45299.0 ± 0.5% | 0.040 | 1.001 | 0.625 | 1.001 | 0.398 | 1.002 | 1.004 | 0.398 | 0.747 | 0.747 | 0.005 |
| hex: canterbury/plrabn12.txt | 524290 | 46385.8 ± 0.6% | 0.039 | 0.993 | 0.615 | 0.997 | 0.378 | 0.997 | 0.994 | 0.379 | 0.730 | 0.729 | 0.005 |
| hex: canterbury/ptt5 | 524290 | 44829.4 ± 0.4% | 0.041 | 1.002 | 0.624 | 1.004 | 0.398 | 1.009 | 1.008 | 0.398 | 0.755 | 0.753 | 0.005 |
| hex: canterbury/sum | 76482 | 45428.6 ± 1.8% | 0.040 | 0.996 | 0.606 | 1.005 | 0.388 | 1.006 | 1.009 | 0.391 | 0.731 | 0.729 | 0.005 |
| hex: canterbury/xargs.1 | 8456 | 44380.4 ± 5.0% | 0.041 | 0.986 | 0.578 | 1.021 | 0.416 | 0.983 | 1.018 | 0.435 | 0.681 | 0.676 | 0.005 |
| hex: canterbury-large/E.coli | 524290 | 44932.5 ± 1.3% | 0.040 | 1.001 | 0.633 | 1.004 | 0.399 | 1.003 | 1.000 | 0.399 | 0.749 | 0.749 | 0.005 |
| hex: canterbury-large/bible.txt | 524290 | 45753.2 ± 0.6% | 0.040 | 0.999 | 0.611 | 1.002 | 0.389 | 1.002 | 1.001 | 0.391 | 0.736 | 0.738 | 0.005 |
| hex: canterbury-large/world192.txt | 524290 | 34821.6 ± 1.1% | 0.052 | 1.001 | 0.749 | 1.001 | 0.485 | 1.006 | 1.005 | 0.485 | 0.970 | 0.972 | 0.006 |
| hex: http/html-1kx1024 | 2099200 | 17849.7 ± 2.2% | 0.101 | 0.992 | 0.799 | 0.990 | 0.571 | 0.992 | 0.988 | 0.630 | 0.852 | 0.832 | 0.012 |
| hex: http/html-16kx64 | 2097280 | 34573.0 ± 0.9% | 0.052 | 1.006 | 0.689 | 1.010 | 0.472 | 1.005 | 1.003 | 0.476 | 0.800 | 0.796 | 0.006 |
| hex: http/html-1m | 524290 | 45149.2 ± 1.4% | 0.040 | 0.994 | 0.630 | 0.992 | 0.394 | 0.995 | 0.994 | 0.396 | 0.745 | 0.746 | 0.005 |
| hex: http/json-1kx1024 | 2099200 | 17813.6 ± 2.5% | 0.102 | 1.013 | 0.815 | 1.005 | 0.593 | 1.011 | 1.003 | 0.653 | 0.864 | 0.845 | 0.012 |
| hex: http/json-16kx64 | 2097280 | 34013.4 ± 0.8% | 0.054 | 1.005 | 0.702 | 1.007 | 0.479 | 1.007 | 1.005 | 0.481 | 0.814 | 0.813 | 0.006 |
| hex: http/json-1m | 524290 | 44733.8 ± 0.5% | 0.041 | 1.000 | 0.629 | 1.000 | 0.401 | 1.002 | 1.001 | 0.403 | 0.756 | 0.756 | 0.005 |
| hex: http/js-1kx1024 | 2099200 | 17491.7 ± 1.3% | 0.104 | 1.000 | 0.809 | 1.003 | 0.603 | 1.003 | 1.002 | 0.662 | 0.872 | 0.848 | 0.012 |
| hex: http/js-16kx64 | 2097280 | 33400.5 ± 4.3% | 0.055 | 1.000 | 0.713 | 1.004 | 0.487 | 1.000 | 1.001 | 0.490 | 0.826 | 0.823 | 0.006 |
| hex: http/js-1m | 524290 | 47617.7 ± 0.4% | 0.039 | 0.997 | 0.598 | 0.999 | 0.381 | 1.001 | 0.997 | 0.381 | 0.714 | 0.714 | 0.004 |
| hex: http/css-1kx1024 | 2099200 | 17654.5 ± 0.8% | 0.102 | 1.006 | 0.813 | 1.005 | 0.588 | 1.009 | 1.011 | 0.643 | 0.867 | 0.846 | 0.012 |
| hex: http/css-16kx64 | 2097280 | 35107.9 ± 4.6% | 0.052 | 1.008 | 0.686 | 1.011 | 0.466 | 1.009 | 1.010 | 0.469 | 0.803 | 0.804 | 0.006 |
| hex: http/css-1m | 524290 | 45007.8 ± 2.0% | 0.041 | 1.001 | 0.625 | 1.000 | 0.399 | 1.003 | 0.999 | 0.400 | 0.756 | 0.756 | 0.005 |
| hex: shuffled/dickens-1m | 524290 | 46230.6 ± 0.2% | 0.040 | 0.995 | 0.621 | 0.998 | 0.391 | 0.999 | 0.997 | 0.392 | 0.736 | 0.736 | 0.005 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1762.1 ± 0.9% | 0.421 | 0.992 | 0.968 | 1.004 | 1.003 | 0.267 | 1.001 | 0.506 | 0.894 | 0.093 | 1.019 |
| qlog records, JSON text sequence | 1467503 | 1646.5 ± 2.2% | 0.646 | 0.973 | 0.995 | 1.016 | 1.001 | 0.235 | 0.996 | 0.440 | 0.881 | 0.107 | 1.045 |
| string: silesia/dickens | 172528 | 13488.2 ± 1.0% | 0.017 | 0.512 | 0.349 | 0.521 | 0.541 | 0.112 | 0.549 | 1.002 | 1.003 | 0.017 | 1.042 |
| string: silesia/nci | 1075110 | 11645.0 ± 1.0% | 0.019 | 0.507 | 0.349 | 0.522 | 0.508 | 0.175 | 0.505 | 1.001 | 1.005 | 0.019 | 1.031 |
| string: silesia/reymont | 1075159 | 5363.0 ± 1.9% | 0.042 | 0.571 | 0.432 | 0.565 | 0.568 | 0.265 | 0.566 | 1.008 | 1.016 | 0.042 | 1.030 |
| string: silesia/samba | 97582 | 6630.1 ± 1.1% | 0.042 | 0.845 | 0.703 | 0.857 | 0.848 | 0.111 | 0.849 | 1.002 | 1.002 | 0.042 | 1.056 |
| string: silesia/webster | 1098490 | 7105.9 ± 1.0% | 0.031 | 0.567 | 0.393 | 0.543 | 0.574 | 0.150 | 0.573 | 0.995 | 1.010 | 0.031 | 0.988 |
| string: silesia/xml | 1090118 | 11125.9 ± 0.5% | 0.021 | 0.542 | 0.448 | 0.540 | 0.543 | 0.196 | 0.546 | 0.998 | 1.019 | 0.021 | 1.034 |
| string: canterbury/alice29.txt | 159425 | 13261.5 ± 1.0% | 0.017 | 0.411 | 0.341 | 0.406 | 0.433 | 0.086 | 0.449 | 1.000 | 1.004 | 0.017 | 1.049 |
| string: canterbury/asyoulik.txt | 132198 | 11629.8 ± 1.7% | 0.018 | 0.372 | 0.312 | 0.364 | 0.383 | 0.081 | 0.391 | 0.999 | 1.019 | 0.018 | 1.049 |
| string: canterbury/lcet10.txt | 441884 | 12885.2 ± 0.9% | 0.017 | 0.534 | 0.318 | 0.515 | 0.539 | 0.111 | 0.541 | 0.992 | 1.021 | 0.017 | 0.991 |
| string: canterbury/plrabn12.txt | 503330 | 8751.9 ± 1.9% | 0.025 | 0.595 | 0.492 | 0.595 | 0.598 | 0.154 | 0.598 | 0.997 | 1.024 | 0.025 | 1.010 |
| string: canterbury-large/E.coli | 1048578 | 31456.2 ± 1.4% | 0.057 | 1.002 | 0.997 | 0.780 | 0.998 | 0.505 | 1.001 | 1.002 | 1.001 | 0.008 | 1.001 |
| string: canterbury-large/bible.txt | 1055886 | 9686.0 ± 1.3% | 0.024 | 0.728 | 0.566 | 0.717 | 0.740 | 0.380 | 0.743 | 0.995 | 1.009 | 0.024 | 1.023 |
| string: canterbury-large/world192.txt | 1103121 | 6680.3 ± 1.5% | 0.033 | 0.585 | 0.418 | 0.551 | 0.588 | 0.147 | 0.588 | 0.989 | 1.007 | 0.033 | 0.975 |
| string: http/html-1m | 1058582 | 10143.4 ± 2.4% | 0.023 | 0.637 | 0.526 | 0.633 | 0.642 | 0.306 | 0.642 | 1.001 | 1.014 | 0.023 | 0.996 |
| string: http/json-1m | 1190272 | 8692.2 ± 0.4% | 0.023 | 0.178 | 0.155 | 0.178 | 0.179 | 0.070 | 0.178 | 1.001 | 1.005 | 0.023 | 0.935 |
| string: http/js-1m | 1144362 | 6631.1 ± 0.4% | 0.031 | 0.364 | 0.309 | 0.357 | 0.364 | 0.089 | 0.364 | 0.987 | 1.000 | 0.031 | 1.000 |
| string: http/css-1m | 1097820 | 9410.7 ± 6.5% | 0.023 | 0.349 | 0.281 | 0.332 | 0.349 | 0.119 | 0.348 | 1.001 | 1.008 | 0.023 | 1.018 |
| string: dickens as Cyrillic and CJK | 1883069 | 5594.1 ± 0.8% | 0.030 | 0.450 | 0.065 | 0.448 | 0.452 | 0.201 | 0.453 | 1.000 | 1.004 | 0.030 | 1.004 |
| hex: silesia/dickens | 524290 | 42142.0 ± 0.6% | 1.006 | 0.091 | 0.997 | 0.605 | 1.003 | 1.002 | 0.996 | 0.996 | 0.998 | 0.096 | 0.997 |
| hex: silesia/mozilla | 524290 | 43164.7 ± 1.0% | 1.000 | 0.088 | 0.992 | 0.592 | 0.996 | 0.993 | 0.997 | 0.990 | 0.990 | 0.094 | 0.996 |
| hex: silesia/mr | 524290 | 43052.1 ± 0.6% | 1.001 | 0.089 | 0.996 | 0.592 | 1.000 | 0.999 | 0.997 | 0.994 | 0.996 | 0.094 | 0.995 |
| hex: silesia/nci | 524290 | 43409.1 ± 2.7% | 1.006 | 0.088 | 1.002 | 0.591 | 1.003 | 1.002 | 1.000 | 1.001 | 1.001 | 0.094 | 1.002 |
| hex: silesia/ooffice | 524290 | 43227.0 ± 1.5% | 0.997 | 0.088 | 1.002 | 0.592 | 1.002 | 1.001 | 1.002 | 0.993 | 0.997 | 0.094 | 1.004 |
| hex: silesia/osdb | 524290 | 41694.0 ± 0.9% | 1.003 | 0.092 | 0.996 | 0.610 | 1.002 | 1.001 | 1.003 | 1.001 | 1.001 | 0.098 | 0.997 |
| hex: silesia/reymont | 524290 | 43137.4 ± 1.0% | 0.998 | 0.089 | 0.992 | 0.592 | 0.992 | 0.994 | 0.991 | 0.990 | 0.997 | 0.093 | 0.993 |
| hex: silesia/samba | 524290 | 43293.6 ± 1.6% | 1.001 | 0.088 | 0.999 | 0.591 | 1.001 | 0.995 | 1.002 | 0.997 | 0.993 | 0.094 | 0.997 |
| hex: silesia/sao | 524290 | 42918.3 ± 1.4% | 1.001 | 0.089 | 1.003 | 0.597 | 1.003 | 0.998 | 1.001 | 0.996 | 0.999 | 0.093 | 1.000 |
| hex: silesia/webster | 524290 | 43431.4 ± 0.3% | 1.003 | 0.088 | 0.989 | 0.589 | 0.997 | 0.991 | 0.997 | 0.993 | 0.981 | 0.093 | 0.986 |
| hex: silesia/x-ray | 524290 | 43140.7 ± 1.0% | 1.004 | 0.088 | 0.999 | 0.594 | 0.999 | 0.994 | 0.992 | 0.995 | 0.994 | 0.094 | 1.000 |
| hex: silesia/xml | 524290 | 43272.3 ± 3.4% | 1.004 | 0.088 | 0.991 | 0.590 | 0.998 | 0.995 | 0.998 | 0.990 | 0.986 | 0.093 | 0.992 |
| hex: canterbury/alice29.txt | 304180 | 41056.0 ± 1.7% | 1.006 | 0.093 | 1.010 | 0.601 | 1.005 | 1.009 | 1.007 | 1.009 | 1.000 | 0.099 | 1.009 |
| hex: canterbury/asyoulik.txt | 250360 | 42664.8 ± 1.8% | 1.003 | 0.090 | 1.000 | 0.597 | 1.008 | 1.001 | 1.008 | 0.996 | 0.994 | 0.094 | 1.008 |
| hex: canterbury/cp.html | 49208 | 41888.5 ± 1.2% | 1.000 | 0.091 | 1.002 | 0.601 | 1.006 | 1.003 | 1.004 | 1.007 | 0.999 | 0.099 | 1.008 |
| hex: canterbury/fields.c | 22302 | 41325.3 ± 0.9% | 1.002 | 0.092 | 1.000 | 0.605 | 1.005 | 0.996 | 1.007 | 1.014 | 1.010 | 0.099 | 1.006 |
| hex: canterbury/grammar.lsp | 7444 | 38759.8 ± 1.2% | 0.996 | 0.097 | 1.000 | 0.613 | 1.005 | 0.973 | 1.007 | 1.010 | 1.043 | 0.104 | 1.010 |
| hex: canterbury/kennedy.xls | 524290 | 43075.6 ± 1.1% | 0.999 | 0.089 | 0.999 | 0.594 | 1.003 | 1.000 | 1.005 | 1.003 | 1.004 | 0.093 | 1.003 |
| hex: canterbury/lcet10.txt | 524290 | 43230.6 ± 0.8% | 1.002 | 0.088 | 0.988 | 0.592 | 1.003 | 0.997 | 1.003 | 0.997 | 0.992 | 0.095 | 0.988 |
| hex: canterbury/plrabn12.txt | 524290 | 42960.6 ± 1.0% | 1.001 | 0.089 | 0.995 | 0.595 | 0.998 | 0.998 | 1.004 | 0.998 | 0.994 | 0.094 | 1.001 |
| hex: canterbury/ptt5 | 524290 | 42908.0 ± 1.2% | 1.003 | 0.089 | 1.000 | 0.596 | 1.001 | 0.998 | 1.001 | 1.002 | 0.998 | 0.094 | 0.998 |
| hex: canterbury/sum | 76482 | 42132.7 ± 1.1% | 0.999 | 0.091 | 1.005 | 0.600 | 1.008 | 0.997 | 1.005 | 1.001 | 1.000 | 0.097 | 1.002 |
| hex: canterbury/xargs.1 | 8456 | 39889.9 ± 2.2% | 1.003 | 0.095 | 0.987 | 0.601 | 1.001 | 0.950 | 1.004 | 0.992 | 1.018 | 0.102 | 1.001 |
| hex: canterbury-large/E.coli | 524290 | 42644.3 ± 0.3% | 1.005 | 0.090 | 0.999 | 0.600 | 1.001 | 0.995 | 1.003 | 0.996 | 0.996 | 0.096 | 0.999 |
| hex: canterbury-large/bible.txt | 524290 | 43478.5 ± 0.4% | 1.001 | 0.089 | 0.982 | 0.593 | 0.999 | 0.987 | 0.998 | 0.984 | 0.976 | 0.095 | 0.985 |
| hex: canterbury-large/world192.txt | 524290 | 42776.5 ± 0.5% | 1.004 | 0.090 | 0.999 | 0.602 | 1.001 | 0.998 | 1.003 | 0.999 | 0.998 | 0.096 | 0.999 |
| hex: http/html-1kx1024 | 2099200 | 21315.9 ± 0.2% | 1.002 | 0.172 | 1.001 | 0.933 | 1.006 | 0.997 | 1.004 | 1.003 | 1.010 | 0.180 | 1.006 |
| hex: http/html-16kx64 | 2097280 | 21326.6 ± 0.4% | 1.005 | 0.177 | 1.004 | 0.983 | 1.005 | 1.004 | 1.004 | 1.003 | 1.005 | 0.193 | 1.005 |
| hex: http/html-1m | 524290 | 40008.2 ± 1.8% | 1.001 | 0.096 | 0.993 | 0.642 | 1.004 | 0.998 | 1.005 | 0.996 | 0.992 | 0.100 | 0.995 |
| hex: http/json-1kx1024 | 2099200 | 20593.7 ± 0.4% | 1.004 | 0.178 | 1.004 | 0.956 | 1.004 | 1.002 | 1.004 | 1.005 | 1.008 | 0.185 | 1.005 |
| hex: http/json-16kx64 | 2097280 | 21651.1 ± 2.9% | 1.003 | 0.175 | 1.000 | 0.970 | 1.002 | 0.999 | 1.002 | 1.001 | 0.998 | 0.189 | 1.001 |
| hex: http/json-1m | 524290 | 42830.8 ± 0.4% | 1.005 | 0.090 | 0.998 | 0.600 | 0.998 | 0.998 | 0.999 | 0.998 | 1.000 | 0.096 | 0.998 |
| hex: http/js-1kx1024 | 2099200 | 22085.8 ± 0.4% | 0.999 | 0.167 | 0.997 | 0.910 | 1.001 | 0.992 | 1.000 | 1.001 | 1.010 | 0.173 | 1.002 |
| hex: http/js-16kx64 | 2097280 | 22841.3 ± 0.5% | 1.001 | 0.166 | 0.998 | 0.945 | 1.001 | 1.001 | 0.999 | 1.002 | 1.001 | 0.180 | 0.999 |
| hex: http/js-1m | 524290 | 42349.6 ± 0.6% | 1.004 | 0.090 | 0.995 | 0.607 | 0.998 | 0.995 | 0.995 | 0.992 | 0.991 | 0.096 | 0.994 |
| hex: http/css-1kx1024 | 2099200 | 20182.5 ± 0.4% | 1.004 | 0.181 | 1.004 | 0.968 | 1.004 | 1.005 | 1.004 | 1.003 | 1.006 | 0.190 | 1.005 |
| hex: http/css-16kx64 | 2097280 | 22042.9 ± 0.6% | 1.003 | 0.173 | 1.004 | 0.965 | 1.002 | 1.002 | 1.004 | 1.004 | 1.004 | 0.188 | 1.004 |
| hex: http/css-1m | 524290 | 42857.7 ± 0.5% | 1.004 | 0.090 | 0.998 | 0.601 | 0.999 | 0.996 | 1.000 | 0.997 | 0.996 | 0.096 | 0.997 |
| hex: shuffled/dickens-1m | 524290 | 42867.2 ± 0.4% | 1.001 | 0.090 | 0.996 | 0.602 | 0.998 | 0.996 | 0.999 | 0.996 | 0.996 | 0.094 | 0.996 |

## Losses

Each workload where a claim's path ran slower than the path it replaces by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding: J7 wide vectors off runs at 1.070 of all on.
- CLDR supplemental, 34 texts, decoding: J8 decoder fast path off runs at 1.073 of all on.
- CLDR supplemental, 34 texts, decoding: J12 decoder escape words off runs at 1.072 of all on.
- CLDR supplemental, 34 texts, decoding: J13 decoder escape blocks off runs at 1.071 of all on.
- qlog records, JSON text sequence, decoding: J5 UTF-8 vectors off runs at 1.063 of all on.
- qlog records, JSON text sequence, decoding: J7 wide vectors off runs at 1.069 of all on.
- qlog records, JSON text sequence, decoding: J8 decoder fast path off runs at 1.069 of all on.
- qlog records, JSON text sequence, decoding: J12 decoder escape words off runs at 1.068 of all on.
- qlog records, JSON text sequence, decoding: J13 decoder escape blocks off runs at 1.071 of all on.
- string: silesia/dickens, decoding: J8 decoder fast path off runs at 1.089 of all on.
- string: silesia/dickens, decoding: J13 decoder escape blocks off runs at 1.113 of all on.
- string: silesia/samba, decoding: J7 wide vectors off runs at 1.053 of all on.
- string: silesia/samba, decoding: J8 decoder fast path off runs at 1.057 of all on.
- string: silesia/samba, decoding: J13 decoder escape blocks off runs at 1.057 of all on.
- string: canterbury/alice29.txt, decoding: J7 wide vectors off runs at 1.082 of all on.
- string: canterbury/alice29.txt, decoding: J8 decoder fast path off runs at 1.117 of all on.
- string: canterbury/alice29.txt, decoding: J13 decoder escape blocks off runs at 1.159 of all on.
- string: canterbury/asyoulik.txt, decoding: J7 wide vectors off runs at 1.130 of all on.
- string: canterbury/asyoulik.txt, decoding: J8 decoder fast path off runs at 1.127 of all on.
- string: canterbury/asyoulik.txt, decoding: J13 decoder escape blocks off runs at 1.132 of all on.
- string: canterbury/lcet10.txt, decoding: J7 wide vectors off runs at 1.084 of all on.
- string: canterbury/lcet10.txt, decoding: J8 decoder fast path off runs at 1.101 of all on.
- string: canterbury/lcet10.txt, decoding: J13 decoder escape blocks off runs at 1.113 of all on.

## UTF-8 validation against simdutf

stdx's `is_utf8`, the check the loops apply to every string's octets, run alone over each string workload's octets at the width the host's features pick (16 lanes on aarch64, AVX2's 32 or AVX-512's 64 on x86-64, decision 39), beside simdutf 9.3.3's `validate_utf8` in the same run; on a host with AVX-512, again with AVX2 alone. Each ratio is stdx's throughput over the other's. simdutf picks its kernel at run time. Before timing, every copy of the check and simdutf judged 20000 seeded buffers and each workload, whole and changed, alike.

| Workload | Octets | stdx, MB/s | simdutf, MB/s | stdx / simdutf | stdx with AVX2 alone, MB/s | stdx / stdx with AVX2 alone |
|---|---|---|---|---|---|---|
| string: silesia/dickens | 166668 | 160211.3 ± 1.1% | 118763.0 ± 0.2% | 1.349 | 98475.6 ± 0.2% | 1.627 |
| string: silesia/nci | 1048576 | 158950.3 ± 8.3% | 119512.2 ± 0.3% | 1.330 | 99368.7 ± 0.2% | 1.600 |
| string: silesia/reymont | 1048576 | 160344.8 ± 1.9% | 119476.6 ± 0.5% | 1.342 | 99303.1 ± 0.6% | 1.615 |
| string: silesia/samba | 65546 | 153672.0 ± 2.2% | 116940.1 ± 4.8% | 1.314 | 97253.5 ± 0.2% | 1.580 |
| string: silesia/webster | 1048576 | 158453.5 ± 11.3% | 119425.5 ± 0.5% | 1.327 | 99941.3 ± 6.6% | 1.585 |
| string: silesia/xml | 1048576 | 157381.8 ± 1.2% | 119452.3 ± 0.2% | 1.318 | 99410.6 ± 3.9% | 1.583 |
| string: canterbury/alice29.txt | 152089 | 157778.5 ± 2.3% | 118602.7 ± 0.2% | 1.330 | 98279.0 ± 0.5% | 1.605 |
| string: canterbury/asyoulik.txt | 125179 | 157284.5 ± 1.5% | 118348.0 ± 0.3% | 1.329 | 98658.1 ± 4.4% | 1.594 |
| string: canterbury/lcet10.txt | 426754 | 158937.2 ± 2.6% | 119012.5 ± 2.0% | 1.335 | 99377.1 ± 3.6% | 1.599 |
| string: canterbury/plrabn12.txt | 481861 | 160248.0 ± 1.8% | 119436.6 ± 0.2% | 1.342 | 99491.4 ± 0.4% | 1.611 |
| string: canterbury-large/E.coli | 1048576 | 158785.3 ± 0.9% | 119608.5 ± 0.2% | 1.328 | 99208.5 ± 0.1% | 1.601 |
| string: canterbury-large/bible.txt | 1048576 | 160152.2 ± 1.6% | 119578.9 ± 0.2% | 1.339 | 99952.2 ± 0.3% | 1.602 |
| string: canterbury-large/world192.txt | 1048576 | 157778.9 ± 1.5% | 119438.8 ± 0.2% | 1.321 | 99179.3 ± 0.2% | 1.591 |
| string: http/html-1m | 1048576 | 142496.7 ± 0.6% | 109361.5 ± 0.5% | 1.303 | 92015.9 ± 8.4% | 1.549 |
| string: http/json-1m | 1048576 | 117798.9 ± 2.9% | 103702.7 ± 3.5% | 1.136 | 80850.7 ± 0.7% | 1.457 |
| string: http/js-1m | 1048576 | 157775.0 ± 8.7% | 118492.7 ± 0.9% | 1.332 | 97958.8 ± 0.5% | 1.611 |
| string: http/css-1m | 1048576 | 162614.5 ± 2.2% | 119109.3 ± 1.0% | 1.365 | 98272.2 ± 0.9% | 1.655 |
| string: dickens as Cyrillic and CJK | 1847045 | 23713.5 ± 0.9% | 20974.9 ± 0.9% | 1.131 | 15022.1 ± 0.8% | 1.579 |

## Losses to simdutf

None.

## UTF-8 validation by the buffer's offset from a 64-octet line

| Buffer | Octets | Offset | stdx, MB/s | simdutf, MB/s | stdx / simdutf | stdx with AVX2 alone, MB/s | stdx / stdx with AVX2 alone |
|---|---|---|---|---|---|---|---|
| string: canterbury-large/bible.txt | 1048576 | 0 | 165138.6 ± 0.6% | 120496.5 ± 0.3% | 1.370 | 103424.9 ± 2.3% | 1.597 |
| string: canterbury-large/bible.txt | 1048576 | 1 | 161548.6 ± 2.9% | 119733.3 ± 0.6% | 1.349 | 99368.8 ± 1.5% | 1.626 |
| string: canterbury-large/bible.txt | 1048576 | 8 | 158938.7 ± 3.5% | 119456.6 ± 0.6% | 1.331 | 99410.2 ± 0.1% | 1.599 |
| string: canterbury-large/bible.txt | 1048576 | 16 | 159052.0 ± 2.4% | 119586.1 ± 0.3% | 1.330 | 99330.1 ± 0.1% | 1.601 |
| string: canterbury-large/bible.txt | 1048576 | 32 | 157844.1 ± 2.3% | 119610.4 ± 0.2% | 1.320 | 103589.9 ± 0.8% | 1.524 |
| string: canterbury-large/bible.txt | 1048576 | 48 | 157260.4 ± 0.5% | 119552.2 ± 0.2% | 1.315 | 99856.3 ± 0.3% | 1.575 |
| string: dickens as Cyrillic and CJK | 1048576 | 0 | 24395.0 ± 0.1% | 21795.2 ± 0.1% | 1.119 | 15389.0 ± 0.4% | 1.585 |
| string: dickens as Cyrillic and CJK | 1048576 | 1 | 24399.8 ± 0.3% | 21783.4 ± 0.1% | 1.120 | 15377.0 ± 0.4% | 1.587 |
| string: dickens as Cyrillic and CJK | 1048576 | 8 | 24384.8 ± 0.4% | 21779.5 ± 0.2% | 1.120 | 15347.0 ± 0.3% | 1.589 |
| string: dickens as Cyrillic and CJK | 1048576 | 16 | 24391.0 ± 0.3% | 21783.1 ± 0.6% | 1.120 | 15365.1 ± 1.7% | 1.587 |
| string: dickens as Cyrillic and CJK | 1048576 | 32 | 24396.9 ± 0.1% | 21783.3 ± 0.6% | 1.120 | 15384.8 ± 0.3% | 1.586 |
| string: dickens as Cyrillic and CJK | 1048576 | 48 | 24394.7 ± 0.3% | 21771.2 ± 0.8% | 1.121 | 15389.1 ± 0.1% | 1.585 |

## Against the baselines

stdx with every claim on, timed beside simdjson 5.1.1, yyjson 0.13.0, Zig 0.16.0's std.json, serde_json 1.0.154 and Go's encoding/json/jsontext in the same run. Each ratio is stdx's throughput over the baseline's; below 1, the baseline is faster. stdx is built for the architecture's baseline CPU in ReleaseSafe. Each baseline is built for the same CPU, the C, C++ and Zig ones in ReleaseFast (decision 75), and simdjson picks its kernel at run time. Decoding visits every value; encoding writes each text from its tokens.

## Decoding against the baselines

Octets are the text's. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1367.2 ± 0.7% | 1469.9 ± 35.2% | 1102.1 ± 1.1% | 401.2 ± 1.3% | 619.4 ± 3.3% | 362.6 ± 2.0% | 0.930 | 1.241 | 3.408 | 2.207 | 3.770 |
| qlog records, JSON text sequence | 1467503 | 1089.6 ± 0.7% | 1206.0 ± 0.9% | 1082.9 ± 0.9% | 342.6 ± 0.8% | 673.9 ± 1.0% | 314.5 ± 0.9% | 0.903 | 1.006 | 3.180 | 1.617 | 3.464 |
| string: silesia/dickens | 172528 | 6677.5 ± 0.6% | 3331.4 ± 5.9% | 2851.9 ± 0.7% | 306.1 ± 0.9% | 3405.9 ± 1.6% | 567.5 ± 1.5% | 2.004 | 2.341 | 21.817 | 1.961 | 11.765 |
| string: silesia/nci | 1075110 | 5440.2 ± 0.4% | 3922.8 ± 3.6% | 3042.5 ± 2.8% | 641.6 ± 0.5% | 3716.6 ± 0.5% | 561.0 ± 1.4% | 1.387 | 1.788 | 8.480 | 1.464 | 9.697 |
| string: silesia/reymont | 1075159 | 3522.4 ± 2.5% | 3408.0 ± 0.6% | 1929.7 ± 1.0% | 325.3 ± 1.7% | 2096.4 ± 1.8% | 479.5 ± 3.7% | 1.034 | 1.825 | 10.828 | 1.680 | 7.346 |
| string: silesia/samba | 97582 | 3983.1 ± 0.9% | 3763.0 ± 1.3% | 3043.2 ± 1.0% | 332.6 ± 1.0% | 1999.4 ± 2.0% | 415.2 ± 3.2% | 1.058 | 1.309 | 11.974 | 1.992 | 9.593 |
| string: silesia/webster | 1098490 | 4377.5 ± 0.9% | 2429.2 ± 0.8% | 1760.9 ± 0.7% | 299.6 ± 1.0% | 2163.0 ± 1.1% | 445.1 ± 2.2% | 1.802 | 2.486 | 14.613 | 2.024 | 9.834 |
| string: silesia/xml | 1090118 | 6029.7 ± 0.6% | 5031.4 ± 0.6% | 2440.3 ± 3.0% | 501.9 ± 0.6% | 3400.4 ± 0.5% | 519.1 ± 2.5% | 1.198 | 2.471 | 12.014 | 1.773 | 11.615 |
| string: canterbury/alice29.txt | 159425 | 5733.0 ± 1.1% | 2778.6 ± 0.6% | 2846.1 ± 1.4% | 294.8 ± 0.3% | 3181.5 ± 2.6% | 509.3 ± 1.0% | 2.063 | 2.014 | 19.448 | 1.802 | 11.257 |
| string: canterbury/asyoulik.txt | 132198 | 4264.5 ± 0.9% | 2609.4 ± 3.3% | 2789.8 ± 0.5% | 296.7 ± 0.4% | 2516.2 ± 0.5% | 449.1 ± 1.4% | 1.634 | 1.529 | 14.376 | 1.695 | 9.496 |
| string: canterbury/lcet10.txt | 441884 | 6643.7 ± 1.0% | 3250.5 ± 1.1% | 2299.3 ± 1.2% | 337.3 ± 0.6% | 3033.4 ± 1.2% | 554.2 ± 0.8% | 2.044 | 2.889 | 19.699 | 2.190 | 11.988 |
| string: canterbury/plrabn12.txt | 503330 | 5433.8 ± 1.6% | 3144.7 ± 0.8% | 1856.2 ± 1.3% | 318.7 ± 0.5% | 2940.5 ± 0.7% | 522.0 ± 1.4% | 1.728 | 2.927 | 17.048 | 1.848 | 10.409 |
| string: canterbury-large/E.coli | 1048578 | 29270.3 ± 0.6% | 13140.3 ± 6.0% | 3418.1 ± 2.0% | 1269.3 ± 2.0% | 8080.2 ± 0.8% | 914.9 ± 4.5% | 2.228 | 8.563 | 23.060 | 3.622 | 31.994 |
| string: canterbury-large/bible.txt | 1055886 | 8428.1 ± 1.8% | 5231.2 ± 1.7% | 2779.1 ± 0.4% | 350.7 ± 1.0% | 3886.1 ± 0.7% | 618.0 ± 3.5% | 1.611 | 3.033 | 24.035 | 2.169 | 13.637 |
| string: canterbury-large/world192.txt | 1103121 | 4139.4 ± 1.8% | 2303.8 ± 0.5% | 1794.6 ± 0.3% | 324.1 ± 1.1% | 2237.0 ± 3.7% | 464.0 ± 1.5% | 1.797 | 2.307 | 12.771 | 1.850 | 8.922 |
| string: http/html-1m | 1058582 | 8962.1 ± 5.8% | 4767.5 ± 1.8% | 2724.7 ± 1.0% | 400.3 ± 1.0% | 3666.3 ± 0.9% | 593.1 ± 2.6% | 1.880 | 3.289 | 22.386 | 2.444 | 15.110 |
| string: http/json-1m | 1190272 | 3327.3 ± 0.9% | 1254.9 ± 0.9% | 2246.8 ± 1.0% | 479.3 ± 0.9% | 1381.2 ± 0.3% | 438.8 ± 0.8% | 2.651 | 1.481 | 6.941 | 2.409 | 7.582 |
| string: http/js-1m | 1144362 | 2858.1 ± 0.6% | 1612.6 ± 0.7% | 1381.6 ± 0.5% | 319.9 ± 3.4% | 1458.8 ± 2.3% | 379.2 ± 0.7% | 1.772 | 2.069 | 8.935 | 1.959 | 7.538 |
| string: http/css-1m | 1097820 | 3275.9 ± 1.4% | 2870.4 ± 1.6% | 2281.7 ± 2.4% | 439.4 ± 2.5% | 2144.5 ± 0.7% | 432.2 ± 2.3% | 1.141 | 1.436 | 7.455 | 1.528 | 7.580 |
| string: dickens as Cyrillic and CJK | 1883069 | 5789.2 ± 9.4% | 2942.3 ± 2.3% | 672.0 ± 0.4% | 369.0 ± 1.1% | 515.7 ± 0.5% | 162.7 ± 4.8% | 1.968 | 8.615 | 15.690 | 11.225 | 35.576 |
| string: dickens as Cyrillic and CJK, as \u escapes | 5075485 | 1192.5 ± 8.8% | 1236.2 ± 0.5% | 1110.7 ± 1.0% | 265.4 ± 4.3% | 482.7 ± 1.1% | 225.9 ± 4.5% | 0.965 | 1.074 | 4.493 | 2.471 | 5.278 |
| hex: silesia/dickens | 524290 | 42581.2 ± 1.4% | 14962.1 ± 0.5% | 3485.1 ± 0.6% | 477.2 ± 0.7% | 8855.8 ± 0.8% | 1127.2 ± 2.6% | 2.846 | 12.218 | 89.236 | 4.808 | 37.777 |
| hex: silesia/mozilla | 524290 | 45101.9 ± 1.0% | 14991.0 ± 0.8% | 3548.7 ± 0.9% | 426.3 ± 1.1% | 8877.6 ± 0.5% | 1126.8 ± 1.1% | 3.009 | 12.710 | 105.800 | 5.080 | 40.025 |
| hex: silesia/mr | 524290 | 44694.9 ± 0.7% | 15002.4 ± 0.8% | 3550.8 ± 1.2% | 643.1 ± 0.6% | 8884.3 ± 0.4% | 1133.3 ± 0.9% | 2.979 | 12.587 | 69.504 | 5.031 | 39.437 |
| hex: silesia/nci | 524290 | 45991.3 ± 2.3% | 14995.2 ± 1.3% | 3479.5 ± 3.0% | 796.2 ± 0.9% | 8880.7 ± 0.8% | 1136.0 ± 0.5% | 3.067 | 13.218 | 57.763 | 5.179 | 40.484 |
| hex: silesia/ooffice | 524290 | 46262.1 ± 0.7% | 15059.0 ± 1.0% | 3561.1 ± 0.7% | 343.3 ± 0.4% | 8936.0 ± 5.0% | 1137.8 ± 0.5% | 3.072 | 12.991 | 134.738 | 5.177 | 40.659 |
| hex: silesia/osdb | 524290 | 41192.0 ± 0.8% | 14972.6 ± 1.1% | 3544.7 ± 0.7% | 444.2 ± 1.7% | 8890.6 ± 0.6% | 1132.4 ± 0.6% | 2.751 | 11.621 | 92.726 | 4.633 | 36.376 |
| hex: silesia/reymont | 524290 | 45506.5 ± 1.5% | 15049.9 ± 0.8% | 3479.8 ± 1.1% | 504.5 ± 1.4% | 8873.2 ± 0.8% | 1137.5 ± 1.7% | 3.024 | 13.077 | 90.204 | 5.129 | 40.005 |
| hex: silesia/samba | 524290 | 45632.6 ± 3.4% | 14979.6 ± 0.9% | 3530.4 ± 1.9% | 364.6 ± 1.4% | 8892.2 ± 0.8% | 1135.5 ± 0.9% | 3.046 | 12.926 | 125.156 | 5.132 | 40.187 |
| hex: silesia/sao | 524290 | 47308.5 ± 0.8% | 14963.1 ± 1.0% | 3443.3 ± 1.3% | 274.9 ± 1.4% | 8864.5 ± 0.5% | 1129.3 ± 0.8% | 3.162 | 13.739 | 172.112 | 5.337 | 41.893 |
| hex: silesia/webster | 524290 | 45692.4 ± 1.3% | 14979.5 ± 0.6% | 3548.5 ± 0.8% | 447.4 ± 1.0% | 8857.0 ± 0.3% | 1130.1 ± 0.5% | 3.050 | 12.877 | 102.127 | 5.159 | 40.433 |
| hex: silesia/x-ray | 524290 | 45213.2 ± 2.0% | 14945.1 ± 0.6% | 3478.5 ± 0.7% | 421.0 ± 1.5% | 8859.9 ± 0.6% | 1134.5 ± 0.8% | 3.025 | 12.998 | 107.385 | 5.103 | 39.853 |
| hex: silesia/xml | 524290 | 45428.8 ± 0.9% | 14981.3 ± 0.4% | 3540.7 ± 0.6% | 729.0 ± 1.3% | 8877.5 ± 0.5% | 1133.4 ± 0.6% | 3.032 | 12.830 | 62.313 | 5.117 | 40.081 |
| hex: canterbury/alice29.txt | 304180 | 45160.4 ± 1.1% | 14087.2 ± 0.8% | 3554.2 ± 0.6% | 483.1 ± 0.3% | 8875.1 ± 0.3% | 1143.4 ± 0.7% | 3.206 | 12.706 | 93.488 | 5.088 | 39.496 |
| hex: canterbury/asyoulik.txt | 250360 | 45457.1 ± 0.8% | 14945.2 ± 0.8% | 3479.9 ± 0.9% | 470.5 ± 0.4% | 8884.3 ± 0.7% | 1140.0 ± 1.3% | 3.042 | 13.063 | 96.613 | 5.117 | 39.874 |
| hex: canterbury/cp.html | 49208 | 46174.0 ± 0.8% | 14354.1 ± 0.6% | 3541.4 ± 0.9% | 504.4 ± 0.8% | 9218.6 ± 0.5% | 1117.4 ± 2.1% | 3.217 | 13.038 | 91.551 | 5.009 | 41.324 |
| hex: canterbury/fields.c | 22302 | 49523.3 ± 1.5% | 17448.7 ± 0.8% | 3640.5 ± 1.0% | 566.0 ± 1.1% | 9200.5 ± 0.7% | 1099.7 ± 1.0% | 2.838 | 13.604 | 87.491 | 5.383 | 45.035 |
| hex: canterbury/grammar.lsp | 7444 | 44151.3 ± 3.4% | 17126.6 ± 0.6% | 3597.6 ± 0.2% | 761.1 ± 0.8% | 8921.5 ± 0.5% | 1061.9 ± 2.3% | 2.578 | 12.273 | 58.010 | 4.949 | 41.579 |
| hex: canterbury/kennedy.xls | 524290 | 46109.9 ± 0.8% | 15047.1 ± 0.6% | 3523.6 ± 0.3% | 748.8 ± 2.1% | 8897.5 ± 1.1% | 1110.7 ± 4.6% | 3.064 | 13.086 | 61.579 | 5.182 | 41.514 |
| hex: canterbury/lcet10.txt | 524290 | 45299.0 ± 0.5% | 14987.2 ± 0.6% | 3553.8 ± 0.5% | 485.6 ± 0.7% | 8888.7 ± 0.3% | 1130.2 ± 1.7% | 3.023 | 12.747 | 93.282 | 5.096 | 40.081 |
| hex: canterbury/plrabn12.txt | 524290 | 46385.8 ± 0.6% | 15031.0 ± 1.0% | 3551.8 ± 0.4% | 465.8 ± 0.3% | 8886.7 ± 0.5% | 1134.2 ± 0.5% | 3.086 | 13.060 | 99.573 | 5.220 | 40.898 |
| hex: canterbury/ptt5 | 524290 | 44829.4 ± 0.4% | 15010.2 ± 0.7% | 3474.2 ± 3.4% | 665.4 ± 0.7% | 8861.7 ± 0.6% | 1134.2 ± 0.8% | 2.987 | 12.904 | 67.368 | 5.059 | 39.523 |
| hex: canterbury/sum | 76482 | 45428.6 ± 1.8% | 15352.6 ± 1.0% | 3541.3 ± 2.4% | 578.2 ± 1.2% | 8886.3 ± 0.5% | 1120.7 ± 1.4% | 2.959 | 12.828 | 78.566 | 5.112 | 40.536 |
| hex: canterbury/xargs.1 | 8456 | 44380.4 ± 5.0% | 17283.1 ± 0.3% | 3547.9 ± 0.7% | 730.6 ± 5.8% | 8935.4 ± 0.5% | 1097.6 ± 1.9% | 2.568 | 12.509 | 60.748 | 4.967 | 40.435 |
| hex: canterbury-large/E.coli | 524290 | 44932.5 ± 1.3% | 14972.3 ± 3.0% | 3471.9 ± 0.2% | 956.2 ± 0.7% | 8872.7 ± 0.5% | 1118.6 ± 7.0% | 3.001 | 12.942 | 46.990 | 5.064 | 40.170 |
| hex: canterbury-large/bible.txt | 524290 | 45753.2 ± 0.6% | 14922.1 ± 1.9% | 3460.8 ± 0.7% | 497.8 ± 2.2% | 8884.9 ± 0.5% | 1101.4 ± 4.0% | 3.066 | 13.221 | 91.910 | 5.150 | 41.541 |
| hex: canterbury-large/world192.txt | 524290 | 34821.6 ± 1.1% | 15023.7 ± 1.0% | 3543.5 ± 0.9% | 468.6 ± 0.7% | 8889.4 ± 0.3% | 1122.5 ± 3.3% | 2.318 | 9.827 | 74.309 | 3.917 | 31.021 |
| hex: http/html-1kx1024 | 2099200 | 17849.7 ± 2.2% | 12267.6 ± 0.8% | 3154.5 ± 0.8% | 504.3 ± 1.0% | 7471.6 ± 3.7% | 967.2 ± 2.8% | 1.455 | 5.658 | 35.397 | 2.389 | 18.454 |
| hex: http/html-16kx64 | 2097280 | 34573.0 ± 0.9% | 13785.5 ± 1.2% | 3387.6 ± 1.0% | 510.7 ± 3.3% | 8578.5 ± 1.1% | 1075.0 ± 0.7% | 2.508 | 10.206 | 67.692 | 4.030 | 32.161 |
| hex: http/html-1m | 524290 | 45149.2 ± 1.4% | 14947.1 ± 0.6% | 3473.4 ± 3.2% | 505.3 ± 0.8% | 8871.7 ± 0.7% | 1119.3 ± 3.2% | 3.021 | 12.998 | 89.355 | 5.089 | 40.337 |
| hex: http/json-1kx1024 | 2099200 | 17813.6 ± 2.5% | 12515.8 ± 1.8% | 3157.5 ± 1.0% | 683.2 ± 1.2% | 7545.7 ± 3.8% | 976.4 ± 2.0% | 1.423 | 5.642 | 26.075 | 2.361 | 18.244 |
| hex: http/json-16kx64 | 2097280 | 34013.4 ± 0.8% | 13911.5 ± 1.2% | 3406.8 ± 0.8% | 696.7 ± 0.5% | 8575.5 ± 1.3% | 1068.3 ± 4.1% | 2.445 | 9.984 | 48.822 | 3.966 | 31.840 |
| hex: http/json-1m | 524290 | 44733.8 ± 0.5% | 14994.5 ± 1.3% | 3521.5 ± 2.3% | 711.7 ± 2.5% | 8958.2 ± 1.4% | 1111.9 ± 3.2% | 2.983 | 12.703 | 62.857 | 4.994 | 40.230 |
| hex: http/js-1kx1024 | 2099200 | 17491.7 ± 1.3% | 12473.0 ± 2.9% | 3158.7 ± 3.7% | 491.9 ± 0.6% | 7629.0 ± 3.2% | 956.3 ± 1.9% | 1.402 | 5.538 | 35.558 | 2.293 | 18.291 |
| hex: http/js-16kx64 | 2097280 | 33400.5 ± 4.3% | 14012.4 ± 1.0% | 3411.6 ± 1.1% | 497.8 ± 1.0% | 8609.9 ± 0.9% | 1066.2 ± 4.4% | 2.384 | 9.790 | 67.093 | 3.879 | 31.326 |
| hex: http/js-1m | 524290 | 47617.7 ± 0.4% | 15079.8 ± 1.2% | 3563.6 ± 0.9% | 512.2 ± 2.9% | 8949.6 ± 0.6% | 1104.7 ± 1.9% | 3.158 | 13.362 | 92.964 | 5.321 | 43.106 |
| hex: http/css-1kx1024 | 2099200 | 17654.5 ± 0.8% | 12239.1 ± 0.7% | 3154.1 ± 0.4% | 565.3 ± 1.1% | 7470.3 ± 4.8% | 973.5 ± 2.2% | 1.442 | 5.597 | 31.228 | 2.363 | 18.135 |
| hex: http/css-16kx64 | 2097280 | 35107.9 ± 4.6% | 13837.8 ± 0.8% | 3397.4 ± 0.5% | 578.2 ± 0.9% | 8621.5 ± 1.0% | 1064.5 ± 3.3% | 2.537 | 10.334 | 60.717 | 4.072 | 32.980 |
| hex: http/css-1m | 524290 | 45007.8 ± 2.0% | 15115.1 ± 0.4% | 3561.2 ± 1.0% | 562.3 ± 0.6% | 8960.9 ± 0.2% | 1120.3 ± 3.2% | 2.978 | 12.639 | 80.046 | 5.023 | 40.176 |
| hex: shuffled/dickens-1m | 524290 | 46230.6 ± 0.2% | 15115.7 ± 0.9% | 3507.2 ± 0.2% | 481.2 ± 0.3% | 8938.9 ± 0.7% | 1112.4 ± 3.2% | 3.058 | 13.181 | 96.083 | 5.172 | 41.559 |

## Encoding against the baselines

Octets are the ones stdx writes. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1762.1 ± 0.9% | 1465.8 ± 1.1% | 1019.8 ± 1.2% | 475.1 ± 0.7% | 430.3 ± 2.7% | 500.1 ± 1.0% | 1.202 | 1.728 | 3.709 | 4.095 | 3.524 |
| qlog records, JSON text sequence | 1467503 | 1646.5 ± 2.2% | 1256.8 ± 3.3% | 950.4 ± 0.9% | 450.5 ± 1.0% | 537.9 ± 0.8% | 353.6 ± 0.4% | 1.310 | 1.732 | 3.654 | 3.061 | 4.657 |
| string: silesia/dickens | 172528 | 13488.2 ± 1.0% | 3942.1 ± 1.2% | 3102.3 ± 4.6% | 359.4 ± 1.4% | 1511.5 ± 0.9% | 1181.5 ± 0.8% | 3.422 | 4.348 | 37.526 | 8.924 | 11.416 |
| string: silesia/nci | 1075110 | 11645.0 ± 1.0% | 4670.7 ± 1.3% | 3137.6 ± 0.9% | 858.2 ± 1.7% | 1544.2 ± 2.2% | 1196.3 ± 1.8% | 2.493 | 3.711 | 13.569 | 7.541 | 9.735 |
| string: silesia/reymont | 1075159 | 5363.0 ± 1.9% | 1839.2 ± 0.5% | 1937.1 ± 0.6% | 393.8 ± 1.2% | 1299.2 ± 1.1% | 1042.0 ± 1.7% | 2.916 | 2.769 | 13.620 | 4.128 | 5.147 |
| string: silesia/samba | 97582 | 6630.1 ± 1.1% | 2693.9 ± 0.8% | 4014.5 ± 0.3% | 376.8 ± 0.4% | 1244.1 ± 0.8% | 1170.1 ± 1.2% | 2.461 | 1.652 | 17.595 | 5.329 | 5.666 |
| string: silesia/webster | 1098490 | 7105.9 ± 1.0% | 1962.9 ± 1.1% | 1809.3 ± 1.3% | 381.4 ± 0.6% | 1240.0 ± 1.8% | 599.2 ± 1.2% | 3.620 | 3.927 | 18.633 | 5.731 | 11.859 |
| string: silesia/xml | 1090118 | 11125.9 ± 0.5% | 3196.9 ± 1.5% | 2545.7 ± 0.7% | 626.2 ± 0.7% | 1685.7 ± 1.2% | 960.6 ± 0.4% | 3.480 | 4.370 | 17.767 | 6.600 | 11.582 |
| string: canterbury/alice29.txt | 159425 | 13261.5 ± 1.0% | 2861.5 ± 1.2% | 3042.0 ± 0.8% | 342.4 ± 0.8% | 1338.3 ± 0.9% | 1086.2 ± 3.8% | 4.634 | 4.359 | 38.732 | 9.909 | 12.209 |
| string: canterbury/asyoulik.txt | 132198 | 11629.8 ± 1.7% | 2078.2 ± 2.7% | 3121.2 ± 1.0% | 350.1 ± 1.0% | 1212.3 ± 3.7% | 953.4 ± 0.9% | 5.596 | 3.726 | 33.221 | 9.593 | 12.198 |
| string: canterbury/lcet10.txt | 441884 | 12885.2 ± 0.9% | 3074.1 ± 0.9% | 2696.9 ± 1.5% | 384.8 ± 3.0% | 1451.6 ± 1.1% | 1190.6 ± 1.6% | 4.191 | 4.778 | 33.482 | 8.877 | 10.823 |
| string: canterbury/plrabn12.txt | 503330 | 8751.9 ± 1.9% | 2312.0 ± 0.5% | 2124.0 ± 1.1% | 363.4 ± 0.5% | 1346.6 ± 3.1% | 1124.2 ± 1.7% | 3.785 | 4.120 | 24.080 | 6.499 | 7.785 |
| string: canterbury-large/E.coli | 1048578 | 31456.2 ± 1.4% | 16007.5 ± 0.9% | 3468.6 ± 0.5% | 1686.5 ± 0.7% | 3106.2 ± 0.9% | 1405.0 ± 0.8% | 1.965 | 9.069 | 18.652 | 10.127 | 22.389 |
| string: canterbury-large/bible.txt | 1055886 | 9686.0 ± 1.3% | 4867.6 ± 0.6% | 3015.3 ± 0.5% | 419.8 ± 0.3% | 2033.6 ± 0.3% | 1486.8 ± 0.6% | 1.990 | 3.212 | 23.075 | 4.763 | 6.514 |
| string: canterbury-large/world192.txt | 1103121 | 6680.3 ± 1.5% | 1726.4 ± 0.5% | 1920.2 ± 3.1% | 388.2 ± 0.2% | 1245.4 ± 3.4% | 962.8 ± 0.4% | 3.870 | 3.479 | 17.209 | 5.364 | 6.938 |
| string: http/html-1m | 1058582 | 10143.4 ± 2.4% | 4364.9 ± 3.4% | 2901.0 ± 0.8% | 458.3 ± 0.7% | 2024.3 ± 1.3% | 844.4 ± 1.9% | 2.324 | 3.497 | 22.131 | 5.011 | 12.012 |
| string: http/json-1m | 1190272 | 8692.2 ± 0.4% | 1576.4 ± 2.5% | 1719.0 ± 0.5% | 536.5 ± 0.8% | 1019.2 ± 0.5% | 843.4 ± 1.6% | 5.514 | 5.056 | 16.202 | 8.528 | 10.306 |
| string: http/js-1m | 1144362 | 6631.1 ± 0.4% | 1117.0 ± 0.7% | 1452.8 ± 0.6% | 360.5 ± 0.6% | 1015.6 ± 3.5% | 757.6 ± 0.5% | 5.936 | 4.564 | 18.392 | 6.529 | 8.753 |
| string: http/css-1m | 1097820 | 9410.7 ± 6.5% | 1484.8 ± 1.2% | 2311.7 ± 0.5% | 543.1 ± 1.1% | 1130.6 ± 1.0% | 877.0 ± 0.5% | 6.338 | 4.071 | 17.327 | 8.323 | 10.731 |
| string: dickens as Cyrillic and CJK | 1883069 | 5594.1 ± 0.8% | 3712.9 ± 1.3% | 478.0 ± 3.2% | 250.7 ± 1.2% | 456.2 ± 0.8% | 354.3 ± 2.6% | 1.507 | 11.703 | 22.316 | 12.262 | 15.788 |
| hex: silesia/dickens | 524290 | 42142.0 ± 0.6% | 2578.8 ± 0.9% | 1503.8 ± 0.8% | 467.0 ± 0.6% | 1546.9 ± 1.4% | 1063.0 ± 0.4% | 16.342 | 28.024 | 90.243 | 27.243 | 39.644 |
| hex: silesia/mozilla | 524290 | 43164.7 ± 1.0% | 2571.7 ± 0.8% | 1501.2 ± 0.7% | 411.9 ± 0.9% | 1499.2 ± 1.5% | 1063.8 ± 1.2% | 16.785 | 28.754 | 104.788 | 28.792 | 40.577 |
| hex: silesia/mr | 524290 | 43052.1 ± 0.6% | 2572.8 ± 1.2% | 1497.9 ± 1.0% | 607.1 ± 0.8% | 1534.5 ± 0.5% | 1060.2 ± 0.5% | 16.733 | 28.741 | 70.916 | 28.056 | 40.607 |
| hex: silesia/nci | 524290 | 43409.1 ± 2.7% | 2562.2 ± 0.9% | 1499.7 ± 0.4% | 745.9 ± 0.9% | 1492.2 ± 1.0% | 1064.9 ± 0.4% | 16.942 | 28.945 | 58.198 | 29.090 | 40.763 |
| hex: silesia/ooffice | 524290 | 43227.0 ± 1.5% | 2568.7 ± 1.9% | 1503.1 ± 0.3% | 340.9 ± 0.6% | 1534.6 ± 1.2% | 1061.6 ± 0.6% | 16.829 | 28.759 | 126.812 | 28.168 | 40.721 |
| hex: silesia/osdb | 524290 | 41694.0 ± 0.9% | 2563.4 ± 1.6% | 1502.4 ± 0.7% | 448.9 ± 0.7% | 1490.6 ± 1.6% | 1064.0 ± 1.5% | 16.265 | 27.752 | 92.878 | 27.970 | 39.185 |
| hex: silesia/reymont | 524290 | 43137.4 ± 1.0% | 2567.4 ± 1.2% | 1502.0 ± 0.5% | 491.9 ± 0.7% | 1541.2 ± 5.2% | 1062.3 ± 0.7% | 16.802 | 28.720 | 87.701 | 27.990 | 40.608 |
| hex: silesia/samba | 524290 | 43293.6 ± 1.6% | 2576.9 ± 1.2% | 1502.1 ± 0.5% | 360.8 ± 0.6% | 1506.1 ± 0.9% | 1061.9 ± 0.6% | 16.800 | 28.822 | 119.984 | 28.746 | 40.769 |
| hex: silesia/sao | 524290 | 42918.3 ± 1.4% | 2583.5 ± 1.0% | 1505.3 ± 0.5% | 278.5 ± 0.5% | 1549.5 ± 0.9% | 1063.1 ± 1.0% | 16.612 | 28.511 | 154.096 | 27.698 | 40.370 |
| hex: silesia/webster | 524290 | 43431.4 ± 0.3% | 2579.2 ± 0.8% | 1504.2 ± 1.2% | 443.7 ± 0.9% | 1503.3 ± 5.2% | 1064.4 ± 1.1% | 16.839 | 28.874 | 97.894 | 28.890 | 40.803 |
| hex: silesia/x-ray | 524290 | 43140.7 ± 1.0% | 2581.8 ± 1.0% | 1504.3 ± 0.8% | 426.2 ± 1.1% | 1541.1 ± 3.0% | 1057.8 ± 0.4% | 16.710 | 28.679 | 101.215 | 27.993 | 40.784 |
| hex: silesia/xml | 524290 | 43272.3 ± 3.4% | 2579.5 ± 0.5% | 1504.8 ± 0.7% | 712.7 ± 0.9% | 1491.4 ± 1.7% | 1063.2 ± 6.1% | 16.775 | 28.757 | 60.716 | 29.015 | 40.701 |
| hex: canterbury/alice29.txt | 304180 | 41056.0 ± 1.7% | 2593.9 ± 1.0% | 1524.1 ± 0.4% | 475.4 ± 0.7% | 1523.6 ± 1.2% | 1078.2 ± 1.2% | 15.828 | 26.937 | 86.361 | 26.947 | 38.079 |
| hex: canterbury/asyoulik.txt | 250360 | 42664.8 ± 1.8% | 2580.0 ± 4.8% | 1536.4 ± 1.0% | 463.5 ± 0.9% | 1538.4 ± 1.0% | 1077.2 ± 1.5% | 16.537 | 27.769 | 92.043 | 27.734 | 39.606 |
| hex: canterbury/cp.html | 49208 | 41888.5 ± 1.2% | 2567.9 ± 0.5% | 1520.8 ± 0.3% | 501.9 ± 1.7% | 1569.4 ± 0.9% | 1085.2 ± 0.8% | 16.312 | 27.544 | 83.457 | 26.691 | 38.601 |
| hex: canterbury/fields.c | 22302 | 41325.3 ± 0.9% | 2633.9 ± 0.5% | 1529.0 ± 0.7% | 621.5 ± 1.7% | 1590.9 ± 0.6% | 1091.4 ± 0.3% | 15.690 | 27.028 | 66.497 | 25.977 | 37.865 |
| hex: canterbury/grammar.lsp | 7444 | 38759.8 ± 1.2% | 2683.5 ± 5.6% | 1539.6 ± 0.7% | 798.0 ± 5.3% | 1601.2 ± 4.9% | 1099.3 ± 0.4% | 14.444 | 25.175 | 48.572 | 24.206 | 35.259 |
| hex: canterbury/kennedy.xls | 524290 | 43075.6 ± 1.1% | 2553.4 ± 5.1% | 1496.0 ± 6.2% | 736.1 ± 4.5% | 1493.5 ± 5.0% | 1059.0 ± 1.8% | 16.870 | 28.793 | 58.522 | 28.843 | 40.674 |
| hex: canterbury/lcet10.txt | 524290 | 43230.6 ± 0.8% | 2562.4 ± 1.3% | 1503.7 ± 0.7% | 470.9 ± 1.6% | 1507.4 ± 5.2% | 1065.9 ± 8.3% | 16.871 | 28.750 | 91.808 | 28.678 | 40.559 |
| hex: canterbury/plrabn12.txt | 524290 | 42960.6 ± 1.0% | 2566.1 ± 7.2% | 1506.0 ± 4.7% | 457.7 ± 3.1% | 1517.4 ± 2.9% | 1064.6 ± 2.4% | 16.741 | 28.526 | 93.859 | 28.311 | 40.355 |
| hex: canterbury/ptt5 | 524290 | 42908.0 ± 1.2% | 2546.4 ± 0.4% | 1494.7 ± 5.2% | 602.6 ± 3.6% | 1493.2 ± 4.6% | 1059.4 ± 7.7% | 16.850 | 28.707 | 71.206 | 28.735 | 40.502 |
| hex: canterbury/sum | 76482 | 42132.7 ± 1.1% | 2572.4 ± 1.0% | 1517.5 ± 0.9% | 588.2 ± 1.5% | 1563.6 ± 1.2% | 1081.8 ± 3.7% | 16.379 | 27.764 | 71.634 | 26.945 | 38.949 |
| hex: canterbury/xargs.1 | 8456 | 39889.9 ± 2.2% | 2676.0 ± 0.5% | 1536.9 ± 4.6% | 824.2 ± 0.5% | 1599.1 ± 5.3% | 1105.0 ± 0.5% | 14.907 | 25.954 | 48.400 | 24.945 | 36.099 |
| hex: canterbury-large/E.coli | 524290 | 42644.3 ± 0.3% | 2572.0 ± 0.6% | 1509.5 ± 5.2% | 808.6 ± 0.9% | 1518.3 ± 1.0% | 1066.3 ± 0.4% | 16.580 | 28.251 | 52.739 | 28.087 | 39.992 |
| hex: canterbury-large/bible.txt | 524290 | 43478.5 ± 0.4% | 2590.4 ± 1.0% | 1516.5 ± 1.0% | 491.6 ± 4.1% | 1556.7 ± 1.7% | 1067.1 ± 1.1% | 16.785 | 28.671 | 88.438 | 27.931 | 40.744 |
| hex: canterbury-large/world192.txt | 524290 | 42776.5 ± 0.5% | 2590.8 ± 0.2% | 1515.4 ± 0.3% | 462.1 ± 1.7% | 1530.0 ± 1.9% | 1070.2 ± 5.2% | 16.511 | 28.228 | 92.577 | 27.958 | 39.970 |
| hex: http/html-1kx1024 | 2099200 | 21315.9 ± 0.2% | 2453.5 ± 2.2% | 1456.2 ± 1.1% | 506.8 ± 1.5% | 1462.7 ± 1.5% | 1067.8 ± 0.9% | 8.688 | 14.638 | 42.059 | 14.573 | 19.962 |
| hex: http/html-16kx64 | 2097280 | 21326.6 ± 0.4% | 2394.1 ± 1.3% | 1450.7 ± 0.9% | 513.9 ± 1.3% | 1449.2 ± 1.2% | 1079.1 ± 1.2% | 8.908 | 14.701 | 41.503 | 14.716 | 19.764 |
| hex: http/html-1m | 524290 | 40008.2 ± 1.8% | 2577.8 ± 2.0% | 1518.2 ± 4.8% | 496.6 ± 3.3% | 1496.8 ± 1.5% | 1073.4 ± 0.7% | 15.520 | 26.352 | 80.563 | 26.729 | 37.273 |
| hex: http/json-1kx1024 | 2099200 | 20593.7 ± 0.4% | 2446.5 ± 8.9% | 1452.3 ± 1.8% | 685.2 ± 1.3% | 1467.4 ± 0.5% | 1069.6 ± 1.6% | 8.418 | 14.180 | 30.057 | 14.034 | 19.254 |
| hex: http/json-16kx64 | 2097280 | 21651.1 ± 2.9% | 2377.5 ± 1.5% | 1449.8 ± 0.6% | 694.4 ± 0.6% | 1449.7 ± 2.0% | 1081.2 ± 1.1% | 9.107 | 14.934 | 31.180 | 14.935 | 20.026 |
| hex: http/json-1m | 524290 | 42830.8 ± 0.4% | 2569.8 ± 0.5% | 1507.8 ± 0.8% | 720.2 ± 0.5% | 1549.3 ± 0.9% | 1072.4 ± 0.4% | 16.667 | 28.406 | 59.474 | 27.645 | 39.939 |
| hex: http/js-1kx1024 | 2099200 | 22085.8 ± 0.4% | 2471.6 ± 0.9% | 1463.5 ± 0.9% | 496.9 ± 0.6% | 1487.0 ± 1.2% | 1079.4 ± 0.7% | 8.936 | 15.091 | 44.449 | 14.852 | 20.461 |
| hex: http/js-16kx64 | 2097280 | 22841.3 ± 0.5% | 2391.7 ± 1.1% | 1453.1 ± 0.6% | 500.8 ± 0.4% | 1456.6 ± 0.9% | 1087.4 ± 0.4% | 9.550 | 15.719 | 45.607 | 15.681 | 21.006 |
| hex: http/js-1m | 524290 | 42349.6 ± 0.6% | 2569.9 ± 0.7% | 1511.9 ± 0.6% | 513.1 ± 0.9% | 1552.3 ± 1.4% | 1062.4 ± 1.1% | 16.479 | 28.011 | 82.530 | 27.282 | 39.861 |
| hex: http/css-1kx1024 | 2099200 | 20182.5 ± 0.4% | 2460.0 ± 0.6% | 1465.9 ± 1.7% | 568.6 ± 0.8% | 1472.2 ± 0.6% | 1075.9 ± 1.2% | 8.204 | 13.768 | 35.494 | 13.710 | 18.759 |
| hex: http/css-16kx64 | 2097280 | 22042.9 ± 0.6% | 2388.9 ± 1.4% | 1457.4 ± 0.3% | 543.8 ± 1.2% | 1264.9 ± 0.4% | 1087.3 ± 0.4% | 9.227 | 15.125 | 40.532 | 17.427 | 20.273 |
| hex: http/css-1m | 524290 | 42857.7 ± 0.5% | 2571.8 ± 0.6% | 1521.3 ± 0.4% | 555.6 ± 0.8% | 1565.0 ± 1.7% | 1069.6 ± 0.8% | 16.664 | 28.172 | 77.132 | 27.385 | 40.068 |
| hex: shuffled/dickens-1m | 524290 | 42867.2 ± 0.4% | 2574.6 ± 0.6% | 1509.8 ± 0.6% | 471.6 ± 0.5% | 1552.9 ± 0.9% | 1071.9 ± 0.3% | 16.650 | 28.392 | 90.893 | 27.605 | 39.992 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1796.0 ± 0.8% | 1465.8 ± 1.1% | 1019.8 ± 1.2% | 475.1 ± 0.7% | 430.3 ± 2.7% | 500.1 ± 1.0% | 1.225 | 1.761 | 3.780 | 4.174 | 3.591 |
| qlog records, JSON text sequence | 1467503 | 1720.4 ± 0.5% | 1256.8 ± 3.3% | 950.4 ± 0.9% | 450.5 ± 1.0% | 537.9 ± 0.8% | 353.6 ± 0.4% | 1.369 | 1.810 | 3.818 | 3.199 | 4.866 |
| string: silesia/dickens | 172528 | 14057.1 ± 0.7% | 3942.1 ± 1.2% | 3102.3 ± 4.6% | 359.4 ± 1.4% | 1511.5 ± 0.9% | 1181.5 ± 0.8% | 3.566 | 4.531 | 39.109 | 9.300 | 11.897 |
| string: silesia/nci | 1075110 | 12011.7 ± 1.1% | 4670.7 ± 1.3% | 3137.6 ± 0.9% | 858.2 ± 1.7% | 1544.2 ± 2.2% | 1196.3 ± 1.8% | 2.572 | 3.828 | 13.996 | 7.779 | 10.041 |
| string: silesia/reymont | 1075159 | 5521.6 ± 1.8% | 1839.2 ± 0.5% | 1937.1 ± 0.6% | 393.8 ± 1.2% | 1299.2 ± 1.1% | 1042.0 ± 1.7% | 3.002 | 2.850 | 14.023 | 4.250 | 5.299 |
| string: silesia/samba | 97582 | 7000.9 ± 0.5% | 2693.9 ± 0.8% | 4014.5 ± 0.3% | 376.8 ± 0.4% | 1244.1 ± 0.8% | 1170.1 ± 1.2% | 2.599 | 1.744 | 18.580 | 5.627 | 5.983 |
| string: silesia/webster | 1098490 | 7018.8 ± 0.5% | 1962.9 ± 1.1% | 1809.3 ± 1.3% | 381.4 ± 0.6% | 1240.0 ± 1.8% | 599.2 ± 1.2% | 3.576 | 3.879 | 18.405 | 5.661 | 11.714 |
| string: silesia/xml | 1090118 | 11505.1 ± 0.5% | 3196.9 ± 1.5% | 2545.7 ± 0.7% | 626.2 ± 0.7% | 1685.7 ± 1.2% | 960.6 ± 0.4% | 3.599 | 4.519 | 18.373 | 6.825 | 11.976 |
| string: canterbury/alice29.txt | 159425 | 13915.1 ± 1.0% | 2861.5 ± 1.2% | 3042.0 ± 0.8% | 342.4 ± 0.8% | 1338.3 ± 0.9% | 1086.2 ± 3.8% | 4.863 | 4.574 | 40.641 | 10.397 | 12.811 |
| string: canterbury/asyoulik.txt | 132198 | 12199.4 ± 1.1% | 2078.2 ± 2.7% | 3121.2 ± 1.0% | 350.1 ± 1.0% | 1212.3 ± 3.7% | 953.4 ± 0.9% | 5.870 | 3.909 | 34.849 | 10.063 | 12.796 |
| string: canterbury/lcet10.txt | 441884 | 12770.2 ± 1.3% | 3074.1 ± 0.9% | 2696.9 ± 1.5% | 384.8 ± 3.0% | 1451.6 ± 1.1% | 1190.6 ± 1.6% | 4.154 | 4.735 | 33.183 | 8.798 | 10.726 |
| string: canterbury/plrabn12.txt | 503330 | 8842.1 ± 3.7% | 2312.0 ± 0.5% | 2124.0 ± 1.1% | 363.4 ± 0.5% | 1346.6 ± 3.1% | 1124.2 ± 1.7% | 3.824 | 4.163 | 24.329 | 6.566 | 7.865 |
| string: canterbury-large/E.coli | 1048578 | 31479.7 ± 1.1% | 16007.5 ± 0.9% | 3468.6 ± 0.5% | 1686.5 ± 0.7% | 3106.2 ± 0.9% | 1405.0 ± 0.8% | 1.967 | 9.076 | 18.666 | 10.134 | 22.406 |
| string: canterbury-large/bible.txt | 1055886 | 9910.6 ± 0.5% | 4867.6 ± 0.6% | 3015.3 ± 0.5% | 419.8 ± 0.3% | 2033.6 ± 0.3% | 1486.8 ± 0.6% | 2.036 | 3.287 | 23.610 | 4.873 | 6.666 |
| string: canterbury-large/world192.txt | 1103121 | 6510.5 ± 0.7% | 1726.4 ± 0.5% | 1920.2 ± 3.1% | 388.2 ± 0.2% | 1245.4 ± 3.4% | 962.8 ± 0.4% | 3.771 | 3.391 | 16.772 | 5.228 | 6.762 |
| string: http/html-1m | 1058582 | 10101.3 ± 0.4% | 4364.9 ± 3.4% | 2901.0 ± 0.8% | 458.3 ± 0.7% | 2024.3 ± 1.3% | 844.4 ± 1.9% | 2.314 | 3.482 | 22.039 | 4.990 | 11.962 |
| string: http/json-1m | 1190272 | 8126.3 ± 0.7% | 1576.4 ± 2.5% | 1719.0 ± 0.5% | 536.5 ± 0.8% | 1019.2 ± 0.5% | 843.4 ± 1.6% | 5.155 | 4.727 | 15.147 | 7.973 | 9.635 |
| string: http/js-1m | 1144362 | 6628.7 ± 2.9% | 1117.0 ± 0.7% | 1452.8 ± 0.6% | 360.5 ± 0.6% | 1015.6 ± 3.5% | 757.6 ± 0.5% | 5.934 | 4.563 | 18.386 | 6.527 | 8.750 |
| string: http/css-1m | 1097820 | 9576.2 ± 3.5% | 1484.8 ± 1.2% | 2311.7 ± 0.5% | 543.1 ± 1.1% | 1130.6 ± 1.0% | 877.0 ± 0.5% | 6.450 | 4.142 | 17.632 | 8.470 | 10.920 |
| string: dickens as Cyrillic and CJK | 1883069 | 5615.7 ± 0.5% | 3712.9 ± 1.3% | 478.0 ± 3.2% | 250.7 ± 1.2% | 456.2 ± 0.8% | 354.3 ± 2.6% | 1.512 | 11.748 | 22.402 | 12.309 | 15.849 |
| hex: silesia/dickens | 524290 | 42010.7 ± 1.7% | 2578.8 ± 0.9% | 1503.8 ± 0.8% | 467.0 ± 0.6% | 1546.9 ± 1.4% | 1063.0 ± 0.4% | 16.291 | 27.937 | 89.961 | 27.158 | 39.521 |
| hex: silesia/mozilla | 524290 | 42989.5 ± 1.3% | 2571.7 ± 0.8% | 1501.2 ± 0.7% | 411.9 ± 0.9% | 1499.2 ± 1.5% | 1063.8 ± 1.2% | 16.717 | 28.637 | 104.363 | 28.675 | 40.412 |
| hex: silesia/mr | 524290 | 42850.9 ± 0.6% | 2572.8 ± 1.2% | 1497.9 ± 1.0% | 607.1 ± 0.8% | 1534.5 ± 0.5% | 1060.2 ± 0.5% | 16.655 | 28.607 | 70.584 | 27.924 | 40.417 |
| hex: silesia/nci | 524290 | 43502.5 ± 1.7% | 2562.2 ± 0.9% | 1499.7 ± 0.4% | 745.9 ± 0.9% | 1492.2 ± 1.0% | 1064.9 ± 0.4% | 16.979 | 29.007 | 58.323 | 29.153 | 40.850 |
| hex: silesia/ooffice | 524290 | 43386.8 ± 1.0% | 2568.7 ± 1.9% | 1503.1 ± 0.3% | 340.9 ± 0.6% | 1534.6 ± 1.2% | 1061.6 ± 0.6% | 16.891 | 28.866 | 127.281 | 28.272 | 40.871 |
| hex: silesia/osdb | 524290 | 41579.0 ± 1.8% | 2563.4 ± 1.6% | 1502.4 ± 0.7% | 448.9 ± 0.7% | 1490.6 ± 1.6% | 1064.0 ± 1.5% | 16.221 | 27.676 | 92.622 | 27.893 | 39.077 |
| hex: silesia/reymont | 524290 | 42844.8 ± 4.7% | 2567.4 ± 1.2% | 1502.0 ± 0.5% | 491.9 ± 0.7% | 1541.2 ± 5.2% | 1062.3 ± 0.7% | 16.688 | 28.525 | 87.106 | 27.800 | 40.333 |
| hex: silesia/samba | 524290 | 43146.6 ± 0.5% | 2576.9 ± 1.2% | 1502.1 ± 0.5% | 360.8 ± 0.6% | 1506.1 ± 0.9% | 1061.9 ± 0.6% | 16.743 | 28.724 | 119.576 | 28.648 | 40.631 |
| hex: silesia/sao | 524290 | 42914.4 ± 1.4% | 2583.5 ± 1.0% | 1505.3 ± 0.5% | 278.5 ± 0.5% | 1549.5 ± 0.9% | 1063.1 ± 1.0% | 16.611 | 28.508 | 154.082 | 27.696 | 40.367 |
| hex: silesia/webster | 524290 | 42836.8 ± 1.8% | 2579.2 ± 0.8% | 1504.2 ± 1.2% | 443.7 ± 0.9% | 1503.3 ± 5.2% | 1064.4 ± 1.1% | 16.608 | 28.478 | 96.554 | 28.494 | 40.245 |
| hex: silesia/x-ray | 524290 | 43139.2 ± 0.8% | 2581.8 ± 1.0% | 1504.3 ± 0.8% | 426.2 ± 1.1% | 1541.1 ± 3.0% | 1057.8 ± 0.4% | 16.709 | 28.678 | 101.211 | 27.992 | 40.782 |
| hex: silesia/xml | 524290 | 42926.5 ± 1.2% | 2579.5 ± 0.5% | 1504.8 ± 0.7% | 712.7 ± 0.9% | 1491.4 ± 1.7% | 1063.2 ± 6.1% | 16.641 | 28.527 | 60.231 | 28.783 | 40.376 |
| hex: canterbury/alice29.txt | 304180 | 41423.5 ± 1.2% | 2593.9 ± 1.0% | 1524.1 ± 0.4% | 475.4 ± 0.7% | 1523.6 ± 1.2% | 1078.2 ± 1.2% | 15.969 | 27.179 | 87.134 | 27.188 | 38.420 |
| hex: canterbury/asyoulik.txt | 250360 | 43010.5 ± 1.9% | 2580.0 ± 4.8% | 1536.4 ± 1.0% | 463.5 ± 0.9% | 1538.4 ± 1.0% | 1077.2 ± 1.5% | 16.671 | 27.994 | 92.789 | 27.959 | 39.927 |
| hex: canterbury/cp.html | 49208 | 42226.9 ± 0.6% | 2567.9 ± 0.5% | 1520.8 ± 0.3% | 501.9 ± 1.7% | 1569.4 ± 0.9% | 1085.2 ± 0.8% | 16.444 | 27.766 | 84.131 | 26.906 | 38.913 |
| hex: canterbury/fields.c | 22302 | 41554.6 ± 0.8% | 2633.9 ± 0.5% | 1529.0 ± 0.7% | 621.5 ± 1.7% | 1590.9 ± 0.6% | 1091.4 ± 0.3% | 15.777 | 27.178 | 66.866 | 26.121 | 38.075 |
| hex: canterbury/grammar.lsp | 7444 | 39155.2 ± 1.9% | 2683.5 ± 5.6% | 1539.6 ± 0.7% | 798.0 ± 5.3% | 1601.2 ± 4.9% | 1099.3 ± 0.4% | 14.591 | 25.432 | 49.068 | 24.453 | 35.619 |
| hex: canterbury/kennedy.xls | 524290 | 43186.0 ± 1.3% | 2553.4 ± 5.1% | 1496.0 ± 6.2% | 736.1 ± 4.5% | 1493.5 ± 5.0% | 1059.0 ± 1.8% | 16.913 | 28.867 | 58.672 | 28.917 | 40.779 |
| hex: canterbury/lcet10.txt | 524290 | 42698.5 ± 0.6% | 2562.4 ± 1.3% | 1503.7 ± 0.7% | 470.9 ± 1.6% | 1507.4 ± 5.2% | 1065.9 ± 8.3% | 16.663 | 28.396 | 90.678 | 28.325 | 40.060 |
| hex: canterbury/plrabn12.txt | 524290 | 43000.2 ± 0.8% | 2566.1 ± 7.2% | 1506.0 ± 4.7% | 457.7 ± 3.1% | 1517.4 ± 2.9% | 1064.6 ± 2.4% | 16.757 | 28.553 | 93.945 | 28.338 | 40.392 |
| hex: canterbury/ptt5 | 524290 | 42813.2 ± 1.2% | 2546.4 ± 0.4% | 1494.7 ± 5.2% | 602.6 ± 3.6% | 1493.2 ± 4.6% | 1059.4 ± 7.7% | 16.813 | 28.643 | 71.048 | 28.672 | 40.412 |
| hex: canterbury/sum | 76482 | 42227.3 ± 1.3% | 2572.4 ± 1.0% | 1517.5 ± 0.9% | 588.2 ± 1.5% | 1563.6 ± 1.2% | 1081.8 ± 3.7% | 16.416 | 27.826 | 71.795 | 27.006 | 39.036 |
| hex: canterbury/xargs.1 | 8456 | 39934.3 ± 4.4% | 2676.0 ± 0.5% | 1536.9 ± 4.6% | 824.2 ± 0.5% | 1599.1 ± 5.3% | 1105.0 ± 0.5% | 14.923 | 25.983 | 48.454 | 24.972 | 36.139 |
| hex: canterbury-large/E.coli | 524290 | 42622.1 ± 0.6% | 2572.0 ± 0.6% | 1509.5 ± 5.2% | 808.6 ± 0.9% | 1518.3 ± 1.0% | 1066.3 ± 0.4% | 16.572 | 28.236 | 52.711 | 28.073 | 39.971 |
| hex: canterbury-large/bible.txt | 524290 | 42826.2 ± 0.7% | 2590.4 ± 1.0% | 1516.5 ± 1.0% | 491.6 ± 4.1% | 1556.7 ± 1.7% | 1067.1 ± 1.1% | 16.533 | 28.241 | 87.112 | 27.512 | 40.132 |
| hex: canterbury-large/world192.txt | 524290 | 42725.7 ± 0.5% | 2590.8 ± 0.2% | 1515.4 ± 0.3% | 462.1 ± 1.7% | 1530.0 ± 1.9% | 1070.2 ± 5.2% | 16.492 | 28.195 | 92.467 | 27.925 | 39.923 |
| hex: http/html-1kx1024 | 2099200 | 21439.2 ± 4.1% | 2453.5 ± 2.2% | 1456.2 ± 1.1% | 506.8 ± 1.5% | 1462.7 ± 1.5% | 1067.8 ± 0.9% | 8.738 | 14.723 | 42.302 | 14.657 | 20.077 |
| hex: http/html-16kx64 | 2097280 | 21431.6 ± 0.6% | 2394.1 ± 1.3% | 1450.7 ± 0.9% | 513.9 ± 1.3% | 1449.2 ± 1.2% | 1079.1 ± 1.2% | 8.952 | 14.773 | 41.707 | 14.789 | 19.861 |
| hex: http/html-1m | 524290 | 39800.7 ± 0.7% | 2577.8 ± 2.0% | 1518.2 ± 4.8% | 496.6 ± 3.3% | 1496.8 ± 1.5% | 1073.4 ± 0.7% | 15.440 | 26.216 | 80.145 | 26.590 | 37.080 |
| hex: http/json-1kx1024 | 2099200 | 20697.9 ± 0.5% | 2446.5 ± 8.9% | 1452.3 ± 1.8% | 685.2 ± 1.3% | 1467.4 ± 0.5% | 1069.6 ± 1.6% | 8.460 | 14.252 | 30.209 | 14.105 | 19.352 |
| hex: http/json-16kx64 | 2097280 | 21679.2 ± 3.4% | 2377.5 ± 1.5% | 1449.8 ± 0.6% | 694.4 ± 0.6% | 1449.7 ± 2.0% | 1081.2 ± 1.1% | 9.119 | 14.954 | 31.220 | 14.954 | 20.051 |
| hex: http/json-1m | 524290 | 42742.1 ± 6.1% | 2569.8 ± 0.5% | 1507.8 ± 0.8% | 720.2 ± 0.5% | 1549.3 ± 0.9% | 1072.4 ± 0.4% | 16.632 | 28.347 | 59.351 | 27.587 | 39.857 |
| hex: http/js-1kx1024 | 2099200 | 22140.9 ± 4.9% | 2471.6 ± 0.9% | 1463.5 ± 0.9% | 496.9 ± 0.6% | 1487.0 ± 1.2% | 1079.4 ± 0.7% | 8.958 | 15.129 | 44.560 | 14.889 | 20.512 |
| hex: http/js-16kx64 | 2097280 | 22829.3 ± 2.1% | 2391.7 ± 1.1% | 1453.1 ± 0.6% | 500.8 ± 0.4% | 1456.6 ± 0.9% | 1087.4 ± 0.4% | 9.545 | 15.711 | 45.583 | 15.673 | 20.995 |
| hex: http/js-1m | 524290 | 42105.9 ± 0.5% | 2569.9 ± 0.7% | 1511.9 ± 0.6% | 513.1 ± 0.9% | 1552.3 ± 1.4% | 1062.4 ± 1.1% | 16.384 | 27.850 | 82.055 | 27.125 | 39.631 |
| hex: http/css-1kx1024 | 2099200 | 20280.7 ± 0.2% | 2460.0 ± 0.6% | 1465.9 ± 1.7% | 568.6 ± 0.8% | 1472.2 ± 0.6% | 1075.9 ± 1.2% | 8.244 | 13.835 | 35.667 | 13.776 | 18.850 |
| hex: http/css-16kx64 | 2097280 | 22131.9 ± 0.5% | 2388.9 ± 1.4% | 1457.4 ± 0.3% | 543.8 ± 1.2% | 1264.9 ± 0.4% | 1087.3 ± 0.4% | 9.264 | 15.186 | 40.695 | 17.497 | 20.355 |
| hex: http/css-1m | 524290 | 42739.2 ± 0.6% | 2571.8 ± 0.6% | 1521.3 ± 0.4% | 555.6 ± 0.8% | 1565.0 ± 1.7% | 1069.6 ± 0.8% | 16.618 | 28.094 | 76.918 | 27.309 | 39.958 |
| hex: shuffled/dickens-1m | 524290 | 42711.7 ± 6.2% | 2574.6 ± 0.6% | 1509.8 ± 0.6% | 471.6 ± 0.5% | 1552.9 ± 0.9% | 1071.9 ± 0.3% | 16.590 | 28.289 | 90.564 | 27.504 | 39.847 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1139.0 ± 2.3% | 1469.9 ± 35.2% | 1102.1 ± 1.1% | 401.2 ± 1.3% | 619.4 ± 3.3% | 362.6 ± 2.0% | 0.775 | 1.034 | 2.839 | 1.839 | 3.141 |
| qlog records, JSON text sequence | 1467503 | 1014.1 ± 2.1% | 1206.0 ± 0.9% | 1082.9 ± 0.9% | 342.6 ± 0.8% | 673.9 ± 1.0% | 314.5 ± 0.9% | 0.841 | 0.936 | 2.960 | 1.505 | 3.224 |
| string: silesia/dickens | 172528 | 6563.0 ± 1.9% | 3331.4 ± 5.9% | 2851.9 ± 0.7% | 306.1 ± 0.9% | 3405.9 ± 1.6% | 567.5 ± 1.5% | 1.970 | 2.301 | 21.443 | 1.927 | 11.564 |
| string: silesia/nci | 1075110 | 5471.2 ± 0.7% | 3922.8 ± 3.6% | 3042.5 ± 2.8% | 641.6 ± 0.5% | 3716.6 ± 0.5% | 561.0 ± 1.4% | 1.395 | 1.798 | 8.528 | 1.472 | 9.753 |
| string: silesia/reymont | 1075159 | 3461.4 ± 1.6% | 3408.0 ± 0.6% | 1929.7 ± 1.0% | 325.3 ± 1.7% | 2096.4 ± 1.8% | 479.5 ± 3.7% | 1.016 | 1.794 | 10.641 | 1.651 | 7.218 |
| string: silesia/samba | 97582 | 3968.3 ± 0.6% | 3763.0 ± 1.3% | 3043.2 ± 1.0% | 332.6 ± 1.0% | 1999.4 ± 2.0% | 415.2 ± 3.2% | 1.055 | 1.304 | 11.930 | 1.985 | 9.557 |
| string: silesia/webster | 1098490 | 4402.6 ± 0.7% | 2429.2 ± 0.8% | 1760.9 ± 0.7% | 299.6 ± 1.0% | 2163.0 ± 1.1% | 445.1 ± 2.2% | 1.812 | 2.500 | 14.698 | 2.035 | 9.890 |
| string: silesia/xml | 1090118 | 6074.1 ± 0.4% | 5031.4 ± 0.6% | 2440.3 ± 3.0% | 501.9 ± 0.6% | 3400.4 ± 0.5% | 519.1 ± 2.5% | 1.207 | 2.489 | 12.103 | 1.786 | 11.700 |
| string: canterbury/alice29.txt | 159425 | 5747.8 ± 0.8% | 2778.6 ± 0.6% | 2846.1 ± 1.4% | 294.8 ± 0.3% | 3181.5 ± 2.6% | 509.3 ± 1.0% | 2.069 | 2.020 | 19.499 | 1.807 | 11.286 |
| string: canterbury/asyoulik.txt | 132198 | 4260.0 ± 1.1% | 2609.4 ± 3.3% | 2789.8 ± 0.5% | 296.7 ± 0.4% | 2516.2 ± 0.5% | 449.1 ± 1.4% | 1.633 | 1.527 | 14.360 | 1.693 | 9.486 |
| string: canterbury/lcet10.txt | 441884 | 6629.5 ± 1.1% | 3250.5 ± 1.1% | 2299.3 ± 1.2% | 337.3 ± 0.6% | 3033.4 ± 1.2% | 554.2 ± 0.8% | 2.040 | 2.883 | 19.657 | 2.186 | 11.963 |
| string: canterbury/plrabn12.txt | 503330 | 5444.0 ± 1.2% | 3144.7 ± 0.8% | 1856.2 ± 1.3% | 318.7 ± 0.5% | 2940.5 ± 0.7% | 522.0 ± 1.4% | 1.731 | 2.933 | 17.079 | 1.851 | 10.429 |
| string: canterbury-large/E.coli | 1048578 | 29428.3 ± 10.3% | 13140.3 ± 6.0% | 3418.1 ± 2.0% | 1269.3 ± 2.0% | 8080.2 ± 0.8% | 914.9 ± 4.5% | 2.240 | 8.610 | 23.184 | 3.642 | 32.167 |
| string: canterbury-large/bible.txt | 1055886 | 8417.3 ± 1.1% | 5231.2 ± 1.7% | 2779.1 ± 0.4% | 350.7 ± 1.0% | 3886.1 ± 0.7% | 618.0 ± 3.5% | 1.609 | 3.029 | 24.004 | 2.166 | 13.620 |
| string: canterbury-large/world192.txt | 1103121 | 4148.1 ± 1.5% | 2303.8 ± 0.5% | 1794.6 ± 0.3% | 324.1 ± 1.1% | 2237.0 ± 3.7% | 464.0 ± 1.5% | 1.801 | 2.311 | 12.798 | 1.854 | 8.941 |
| string: http/html-1m | 1058582 | 8828.0 ± 6.5% | 4767.5 ± 1.8% | 2724.7 ± 1.0% | 400.3 ± 1.0% | 3666.3 ± 0.9% | 593.1 ± 2.6% | 1.852 | 3.240 | 22.051 | 2.408 | 14.884 |
| string: http/json-1m | 1190272 | 3339.4 ± 1.1% | 1254.9 ± 0.9% | 2246.8 ± 1.0% | 479.3 ± 0.9% | 1381.2 ± 0.3% | 438.8 ± 0.8% | 2.661 | 1.486 | 6.967 | 2.418 | 7.610 |
| string: http/js-1m | 1144362 | 2864.4 ± 0.7% | 1612.6 ± 0.7% | 1381.6 ± 0.5% | 319.9 ± 3.4% | 1458.8 ± 2.3% | 379.2 ± 0.7% | 1.776 | 2.073 | 8.955 | 1.964 | 7.555 |
| string: http/css-1m | 1097820 | 3293.0 ± 3.5% | 2870.4 ± 1.6% | 2281.7 ± 2.4% | 439.4 ± 2.5% | 2144.5 ± 0.7% | 432.2 ± 2.3% | 1.147 | 1.443 | 7.494 | 1.536 | 7.620 |
| string: dickens as Cyrillic and CJK | 1883069 | 5782.5 ± 2.5% | 2942.3 ± 2.3% | 672.0 ± 0.4% | 369.0 ± 1.1% | 515.7 ± 0.5% | 162.7 ± 4.8% | 1.965 | 8.605 | 15.672 | 11.212 | 35.535 |
| string: dickens as Cyrillic and CJK, as \u escapes | 5075485 | 1201.6 ± 0.7% | 1236.2 ± 0.5% | 1110.7 ± 1.0% | 265.4 ± 4.3% | 482.7 ± 1.1% | 225.9 ± 4.5% | 0.972 | 1.082 | 4.527 | 2.490 | 5.318 |
| hex: silesia/dickens | 524290 | 33820.1 ± 0.5% | 14962.1 ± 0.5% | 3485.1 ± 0.6% | 477.2 ± 0.7% | 8855.8 ± 0.8% | 1127.2 ± 2.6% | 2.260 | 9.704 | 70.876 | 3.819 | 30.004 |
| hex: silesia/mozilla | 524290 | 33722.2 ± 0.7% | 14991.0 ± 0.8% | 3548.7 ± 0.9% | 426.3 ± 1.1% | 8877.6 ± 0.5% | 1126.8 ± 1.1% | 2.249 | 9.503 | 79.105 | 3.799 | 29.926 |
| hex: silesia/mr | 524290 | 33845.2 ± 0.3% | 15002.4 ± 0.8% | 3550.8 ± 1.2% | 643.1 ± 0.6% | 8884.3 ± 0.4% | 1133.3 ± 0.9% | 2.256 | 9.532 | 52.632 | 3.810 | 29.864 |
| hex: silesia/nci | 524290 | 33736.2 ± 3.8% | 14995.2 ± 1.3% | 3479.5 ± 3.0% | 796.2 ± 0.9% | 8880.7 ± 0.8% | 1136.0 ± 0.5% | 2.250 | 9.696 | 42.371 | 3.799 | 29.696 |
| hex: silesia/ooffice | 524290 | 33822.9 ± 1.2% | 15059.0 ± 1.0% | 3561.1 ± 0.7% | 343.3 ± 0.4% | 8936.0 ± 5.0% | 1137.8 ± 0.5% | 2.246 | 9.498 | 98.509 | 3.785 | 29.727 |
| hex: silesia/osdb | 524290 | 33709.5 ± 1.0% | 14972.6 ± 1.1% | 3544.7 ± 0.7% | 444.2 ± 1.7% | 8890.6 ± 0.6% | 1132.4 ± 0.6% | 2.251 | 9.510 | 75.883 | 3.792 | 29.768 |
| hex: silesia/reymont | 524290 | 33722.9 ± 0.8% | 15049.9 ± 0.8% | 3479.8 ± 1.1% | 504.5 ± 1.4% | 8873.2 ± 0.8% | 1137.5 ± 1.7% | 2.241 | 9.691 | 66.846 | 3.801 | 29.646 |
| hex: silesia/samba | 524290 | 33797.1 ± 1.1% | 14979.6 ± 0.9% | 3530.4 ± 1.9% | 364.6 ± 1.4% | 8892.2 ± 0.8% | 1135.5 ± 0.9% | 2.256 | 9.573 | 92.695 | 3.801 | 29.764 |
| hex: silesia/sao | 524290 | 33643.7 ± 2.8% | 14963.1 ± 1.0% | 3443.3 ± 1.3% | 274.9 ± 1.4% | 8864.5 ± 0.5% | 1129.3 ± 0.8% | 2.248 | 9.771 | 122.399 | 3.795 | 29.793 |
| hex: silesia/webster | 524290 | 33710.4 ± 4.0% | 14979.5 ± 0.6% | 3548.5 ± 0.8% | 447.4 ± 1.0% | 8857.0 ± 0.3% | 1130.1 ± 0.5% | 2.250 | 9.500 | 75.346 | 3.806 | 29.830 |
| hex: silesia/x-ray | 524290 | 33655.0 ± 0.5% | 14945.1 ± 0.6% | 3478.5 ± 0.7% | 421.0 ± 1.5% | 8859.9 ± 0.6% | 1134.5 ± 0.8% | 2.252 | 9.675 | 79.933 | 3.799 | 29.665 |
| hex: silesia/xml | 524290 | 33686.0 ± 0.5% | 14981.3 ± 0.4% | 3540.7 ± 0.6% | 729.0 ± 1.3% | 8877.5 ± 0.5% | 1133.4 ± 0.6% | 2.249 | 9.514 | 46.206 | 3.795 | 29.721 |
| hex: canterbury/alice29.txt | 304180 | 33655.0 ± 0.6% | 14087.2 ± 0.8% | 3554.2 ± 0.6% | 483.1 ± 0.3% | 8875.1 ± 0.3% | 1143.4 ± 0.7% | 2.389 | 9.469 | 69.671 | 3.792 | 29.434 |
| hex: canterbury/asyoulik.txt | 250360 | 33689.2 ± 0.5% | 14945.2 ± 0.8% | 3479.9 ± 0.9% | 470.5 ± 0.4% | 8884.3 ± 0.7% | 1140.0 ± 1.3% | 2.254 | 9.681 | 71.602 | 3.792 | 29.552 |
| hex: canterbury/cp.html | 49208 | 33220.7 ± 0.7% | 14354.1 ± 0.6% | 3541.4 ± 0.9% | 504.4 ± 0.8% | 9218.6 ± 0.5% | 1117.4 ± 2.1% | 2.314 | 9.381 | 65.868 | 3.604 | 29.732 |
| hex: canterbury/fields.c | 22302 | 32747.7 ± 0.8% | 17448.7 ± 0.8% | 3640.5 ± 1.0% | 566.0 ± 1.1% | 9200.5 ± 0.7% | 1099.7 ± 1.0% | 1.877 | 8.995 | 57.854 | 3.559 | 29.780 |
| hex: canterbury/grammar.lsp | 7444 | 29684.7 ± 0.6% | 17126.6 ± 0.6% | 3597.6 ± 0.2% | 761.1 ± 0.8% | 8921.5 ± 0.5% | 1061.9 ± 2.3% | 1.733 | 8.251 | 39.003 | 3.327 | 27.956 |
| hex: canterbury/kennedy.xls | 524290 | 33892.8 ± 0.4% | 15047.1 ± 0.6% | 3523.6 ± 0.3% | 748.8 ± 2.1% | 8897.5 ± 1.1% | 1110.7 ± 4.6% | 2.252 | 9.619 | 45.263 | 3.809 | 30.514 |
| hex: canterbury/lcet10.txt | 524290 | 33857.7 ± 0.2% | 14987.2 ± 0.6% | 3553.8 ± 0.5% | 485.6 ± 0.7% | 8888.7 ± 0.3% | 1130.2 ± 1.7% | 2.259 | 9.527 | 69.721 | 3.809 | 29.958 |
| hex: canterbury/plrabn12.txt | 524290 | 33841.1 ± 0.8% | 15031.0 ± 1.0% | 3551.8 ± 0.4% | 465.8 ± 0.3% | 8886.7 ± 0.5% | 1134.2 ± 0.5% | 2.251 | 9.528 | 72.645 | 3.808 | 29.837 |
| hex: canterbury/ptt5 | 524290 | 33852.3 ± 0.9% | 15010.2 ± 0.7% | 3474.2 ± 3.4% | 665.4 ± 0.7% | 8861.7 ± 0.6% | 1134.2 ± 0.8% | 2.255 | 9.744 | 50.872 | 3.820 | 29.846 |
| hex: canterbury/sum | 76482 | 33188.5 ± 1.0% | 15352.6 ± 1.0% | 3541.3 ± 2.4% | 578.2 ± 1.2% | 8886.3 ± 0.5% | 1120.7 ± 1.4% | 2.162 | 9.372 | 57.397 | 3.735 | 29.614 |
| hex: canterbury/xargs.1 | 8456 | 30204.7 ± 0.5% | 17283.1 ± 0.3% | 3547.9 ± 0.7% | 730.6 ± 5.8% | 8935.4 ± 0.5% | 1097.6 ± 1.9% | 1.748 | 8.513 | 41.344 | 3.380 | 27.520 |
| hex: canterbury-large/E.coli | 524290 | 33642.9 ± 1.0% | 14972.3 ± 3.0% | 3471.9 ± 0.2% | 956.2 ± 0.7% | 8872.7 ± 0.5% | 1118.6 ± 7.0% | 2.247 | 9.690 | 35.183 | 3.792 | 30.077 |
| hex: canterbury-large/bible.txt | 524290 | 33659.6 ± 0.3% | 14922.1 ± 1.9% | 3460.8 ± 0.7% | 497.8 ± 2.2% | 8884.9 ± 0.5% | 1101.4 ± 4.0% | 2.256 | 9.726 | 67.616 | 3.788 | 30.561 |
| hex: canterbury-large/world192.txt | 524290 | 33789.8 ± 0.5% | 15023.7 ± 1.0% | 3543.5 ± 0.9% | 468.6 ± 0.7% | 8889.4 ± 0.3% | 1122.5 ± 3.3% | 2.249 | 9.536 | 72.107 | 3.801 | 30.102 |
| hex: http/html-1kx1024 | 2099200 | 15213.6 ± 1.0% | 12267.6 ± 0.8% | 3154.5 ± 0.8% | 504.3 ± 1.0% | 7471.6 ± 3.7% | 967.2 ± 2.8% | 1.240 | 4.823 | 30.169 | 2.036 | 15.729 |
| hex: http/html-16kx64 | 2097280 | 27646.8 ± 1.1% | 13785.5 ± 1.2% | 3387.6 ± 1.0% | 510.7 ± 3.3% | 8578.5 ± 1.1% | 1075.0 ± 0.7% | 2.005 | 8.161 | 54.131 | 3.223 | 25.718 |
| hex: http/html-1m | 524290 | 33648.9 ± 4.1% | 14947.1 ± 0.6% | 3473.4 ± 3.2% | 505.3 ± 0.8% | 8871.7 ± 0.7% | 1119.3 ± 3.2% | 2.251 | 9.688 | 66.595 | 3.793 | 30.062 |
| hex: http/json-1kx1024 | 2099200 | 15396.1 ± 1.6% | 12515.8 ± 1.8% | 3157.5 ± 1.0% | 683.2 ± 1.2% | 7545.7 ± 3.8% | 976.4 ± 2.0% | 1.230 | 4.876 | 22.536 | 2.040 | 15.768 |
| hex: http/json-16kx64 | 2097280 | 27683.9 ± 2.9% | 13911.5 ± 1.2% | 3406.8 ± 0.8% | 696.7 ± 0.5% | 8575.5 ± 1.3% | 1068.3 ± 4.1% | 1.990 | 8.126 | 39.737 | 3.228 | 25.915 |
| hex: http/json-1m | 524290 | 33814.6 ± 1.5% | 14994.5 ± 1.3% | 3521.5 ± 2.3% | 711.7 ± 2.5% | 8958.2 ± 1.4% | 1111.9 ± 3.2% | 2.255 | 9.602 | 47.514 | 3.775 | 30.410 |
| hex: http/js-1kx1024 | 2099200 | 15256.3 ± 0.9% | 12473.0 ± 2.9% | 3158.7 ± 3.7% | 491.9 ± 0.6% | 7629.0 ± 3.2% | 956.3 ± 1.9% | 1.223 | 4.830 | 31.014 | 2.000 | 15.954 |
| hex: http/js-16kx64 | 2097280 | 27582.1 ± 1.0% | 14012.4 ± 1.0% | 3411.6 ± 1.1% | 497.8 ± 1.0% | 8609.9 ± 0.9% | 1066.2 ± 4.4% | 1.968 | 8.085 | 55.405 | 3.204 | 25.869 |
| hex: http/js-1m | 524290 | 34022.8 ± 1.0% | 15079.8 ± 1.2% | 3563.6 ± 0.9% | 512.2 ± 2.9% | 8949.6 ± 0.6% | 1104.7 ± 1.9% | 2.256 | 9.547 | 66.422 | 3.802 | 30.799 |
| hex: http/css-1kx1024 | 2099200 | 15302.8 ± 2.2% | 12239.1 ± 0.7% | 3154.1 ± 0.4% | 565.3 ± 1.1% | 7470.3 ± 4.8% | 973.5 ± 2.2% | 1.250 | 4.852 | 27.069 | 2.048 | 15.719 |
| hex: http/css-16kx64 | 2097280 | 28208.9 ± 1.4% | 13837.8 ± 0.8% | 3397.4 ± 0.5% | 578.2 ± 0.9% | 8621.5 ± 1.0% | 1064.5 ± 3.3% | 2.039 | 8.303 | 48.786 | 3.272 | 26.499 |
| hex: http/css-1m | 524290 | 34031.7 ± 0.9% | 15115.1 ± 0.4% | 3561.2 ± 1.0% | 562.3 ± 0.6% | 8960.9 ± 0.2% | 1120.3 ± 3.2% | 2.252 | 9.556 | 60.525 | 3.798 | 30.378 |
| hex: shuffled/dickens-1m | 524290 | 34037.7 ± 0.3% | 15115.7 ± 0.9% | 3507.2 ± 0.2% | 481.2 ± 0.3% | 8938.9 ± 0.7% | 1112.4 ± 3.2% | 2.252 | 9.705 | 70.742 | 3.808 | 30.598 |

## TextReader.next_items against the baselines

stdx's decoder a slice of tokens a call through `TextReader.next_items`, as a caller that reads a text's values in a loop calls it (decision 79). Octets are the text's. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1294.8 ± 39.7% | 1469.9 ± 35.2% | 1102.1 ± 1.1% | 401.2 ± 1.3% | 619.4 ± 3.3% | 362.6 ± 2.0% | 0.881 | 1.175 | 3.228 | 2.090 | 3.571 |
| qlog records, JSON text sequence | 1467503 | 1181.3 ± 0.4% | 1206.0 ± 0.9% | 1082.9 ± 0.9% | 342.6 ± 0.8% | 673.9 ± 1.0% | 314.5 ± 0.9% | 0.980 | 1.091 | 3.448 | 1.753 | 3.756 |
| string: silesia/dickens | 172528 | 6607.8 ± 1.4% | 3331.4 ± 5.9% | 2851.9 ± 0.7% | 306.1 ± 0.9% | 3405.9 ± 1.6% | 567.5 ± 1.5% | 1.983 | 2.317 | 21.589 | 1.940 | 11.643 |
| string: silesia/nci | 1075110 | 5488.7 ± 0.6% | 3922.8 ± 3.6% | 3042.5 ± 2.8% | 641.6 ± 0.5% | 3716.6 ± 0.5% | 561.0 ± 1.4% | 1.399 | 1.804 | 8.555 | 1.477 | 9.784 |
| string: silesia/reymont | 1075159 | 3489.4 ± 4.1% | 3408.0 ± 0.6% | 1929.7 ± 1.0% | 325.3 ± 1.7% | 2096.4 ± 1.8% | 479.5 ± 3.7% | 1.024 | 1.808 | 10.727 | 1.664 | 7.277 |
| string: silesia/samba | 97582 | 3978.9 ± 0.6% | 3763.0 ± 1.3% | 3043.2 ± 1.0% | 332.6 ± 1.0% | 1999.4 ± 2.0% | 415.2 ± 3.2% | 1.057 | 1.307 | 11.962 | 1.990 | 9.583 |
| string: silesia/webster | 1098490 | 4409.7 ± 1.1% | 2429.2 ± 0.8% | 1760.9 ± 0.7% | 299.6 ± 1.0% | 2163.0 ± 1.1% | 445.1 ± 2.2% | 1.815 | 2.504 | 14.721 | 2.039 | 9.906 |
| string: silesia/xml | 1090118 | 6104.8 ± 0.9% | 5031.4 ± 0.6% | 2440.3 ± 3.0% | 501.9 ± 0.6% | 3400.4 ± 0.5% | 519.1 ± 2.5% | 1.213 | 2.502 | 12.164 | 1.795 | 11.759 |
| string: canterbury/alice29.txt | 159425 | 5792.5 ± 0.8% | 2778.6 ± 0.6% | 2846.1 ± 1.4% | 294.8 ± 0.3% | 3181.5 ± 2.6% | 509.3 ± 1.0% | 2.085 | 2.035 | 19.650 | 1.821 | 11.373 |
| string: canterbury/asyoulik.txt | 132198 | 4285.5 ± 0.7% | 2609.4 ± 3.3% | 2789.8 ± 0.5% | 296.7 ± 0.4% | 2516.2 ± 0.5% | 449.1 ± 1.4% | 1.642 | 1.536 | 14.446 | 1.703 | 9.543 |
| string: canterbury/lcet10.txt | 441884 | 6651.2 ± 1.5% | 3250.5 ± 1.1% | 2299.3 ± 1.2% | 337.3 ± 0.6% | 3033.4 ± 1.2% | 554.2 ± 0.8% | 2.046 | 2.893 | 19.721 | 2.193 | 12.002 |
| string: canterbury/plrabn12.txt | 503330 | 5435.4 ± 0.5% | 3144.7 ± 0.8% | 1856.2 ± 1.3% | 318.7 ± 0.5% | 2940.5 ± 0.7% | 522.0 ± 1.4% | 1.728 | 2.928 | 17.052 | 1.848 | 10.412 |
| string: canterbury-large/E.coli | 1048578 | 29427.3 ± 8.6% | 13140.3 ± 6.0% | 3418.1 ± 2.0% | 1269.3 ± 2.0% | 8080.2 ± 0.8% | 914.9 ± 4.5% | 2.239 | 8.609 | 23.183 | 3.642 | 32.166 |
| string: canterbury-large/bible.txt | 1055886 | 8510.0 ± 1.1% | 5231.2 ± 1.7% | 2779.1 ± 0.4% | 350.7 ± 1.0% | 3886.1 ± 0.7% | 618.0 ± 3.5% | 1.627 | 3.062 | 24.269 | 2.190 | 13.770 |
| string: canterbury-large/world192.txt | 1103121 | 4178.1 ± 0.7% | 2303.8 ± 0.5% | 1794.6 ± 0.3% | 324.1 ± 1.1% | 2237.0 ± 3.7% | 464.0 ± 1.5% | 1.814 | 2.328 | 12.890 | 1.868 | 9.005 |
| string: http/html-1m | 1058582 | 9575.5 ± 1.4% | 4767.5 ± 1.8% | 2724.7 ± 1.0% | 400.3 ± 1.0% | 3666.3 ± 0.9% | 593.1 ± 2.6% | 2.008 | 3.514 | 23.918 | 2.612 | 16.144 |
| string: http/json-1m | 1190272 | 3339.9 ± 0.8% | 1254.9 ± 0.9% | 2246.8 ± 1.0% | 479.3 ± 0.9% | 1381.2 ± 0.3% | 438.8 ± 0.8% | 2.662 | 1.486 | 6.968 | 2.418 | 7.611 |
| string: http/js-1m | 1144362 | 2876.7 ± 0.5% | 1612.6 ± 0.7% | 1381.6 ± 0.5% | 319.9 ± 3.4% | 1458.8 ± 2.3% | 379.2 ± 0.7% | 1.784 | 2.082 | 8.993 | 1.972 | 7.587 |
| string: http/css-1m | 1097820 | 3303.5 ± 2.5% | 2870.4 ± 1.6% | 2281.7 ± 2.4% | 439.4 ± 2.5% | 2144.5 ± 0.7% | 432.2 ± 2.3% | 1.151 | 1.448 | 7.518 | 1.540 | 7.644 |
| string: dickens as Cyrillic and CJK | 1883069 | 5818.5 ± 1.3% | 2942.3 ± 2.3% | 672.0 ± 0.4% | 369.0 ± 1.1% | 515.7 ± 0.5% | 162.7 ± 4.8% | 1.978 | 8.659 | 15.770 | 11.282 | 35.756 |
| string: dickens as Cyrillic and CJK, as \u escapes | 5075485 | 1209.1 ± 0.8% | 1236.2 ± 0.5% | 1110.7 ± 1.0% | 265.4 ± 4.3% | 482.7 ± 1.1% | 225.9 ± 4.5% | 0.978 | 1.089 | 4.555 | 2.505 | 5.351 |
| hex: silesia/dickens | 524290 | 33736.8 ± 1.4% | 14962.1 ± 0.5% | 3485.1 ± 0.6% | 477.2 ± 0.7% | 8855.8 ± 0.8% | 1127.2 ± 2.6% | 2.255 | 9.680 | 70.701 | 3.810 | 29.930 |
| hex: silesia/mozilla | 524290 | 33750.6 ± 0.6% | 14991.0 ± 0.8% | 3548.7 ± 0.9% | 426.3 ± 1.1% | 8877.6 ± 0.5% | 1126.8 ± 1.1% | 2.251 | 9.511 | 79.172 | 3.802 | 29.951 |
| hex: silesia/mr | 524290 | 33870.1 ± 0.7% | 15002.4 ± 0.8% | 3550.8 ± 1.2% | 643.1 ± 0.6% | 8884.3 ± 0.4% | 1133.3 ± 0.9% | 2.258 | 9.539 | 52.671 | 3.812 | 29.886 |
| hex: silesia/nci | 524290 | 33691.7 ± 0.8% | 14995.2 ± 1.3% | 3479.5 ± 3.0% | 796.2 ± 0.9% | 8880.7 ± 0.8% | 1136.0 ± 0.5% | 2.247 | 9.683 | 42.316 | 3.794 | 29.657 |
| hex: silesia/ooffice | 524290 | 33874.6 ± 0.4% | 15059.0 ± 1.0% | 3561.1 ± 0.7% | 343.3 ± 0.4% | 8936.0 ± 5.0% | 1137.8 ± 0.5% | 2.249 | 9.512 | 98.659 | 3.791 | 29.772 |
| hex: silesia/osdb | 524290 | 33851.4 ± 0.9% | 14972.6 ± 1.1% | 3544.7 ± 0.7% | 444.2 ± 1.7% | 8890.6 ± 0.6% | 1132.4 ± 0.6% | 2.261 | 9.550 | 76.202 | 3.808 | 29.894 |
| hex: silesia/reymont | 524290 | 33802.6 ± 1.0% | 15049.9 ± 0.8% | 3479.8 ± 1.1% | 504.5 ± 1.4% | 8873.2 ± 0.8% | 1137.5 ± 1.7% | 2.246 | 9.714 | 67.004 | 3.810 | 29.716 |
| hex: silesia/samba | 524290 | 33720.8 ± 0.8% | 14979.6 ± 0.9% | 3530.4 ± 1.9% | 364.6 ± 1.4% | 8892.2 ± 0.8% | 1135.5 ± 0.9% | 2.251 | 9.552 | 92.486 | 3.792 | 29.696 |
| hex: silesia/sao | 524290 | 33739.9 ± 1.1% | 14963.1 ± 1.0% | 3443.3 ± 1.3% | 274.9 ± 1.4% | 8864.5 ± 0.5% | 1129.3 ± 0.8% | 2.255 | 9.799 | 122.748 | 3.806 | 29.878 |
| hex: silesia/webster | 524290 | 33698.0 ± 1.2% | 14979.5 ± 0.6% | 3548.5 ± 0.8% | 447.4 ± 1.0% | 8857.0 ± 0.3% | 1130.1 ± 0.5% | 2.250 | 9.496 | 75.318 | 3.805 | 29.819 |
| hex: silesia/x-ray | 524290 | 33671.5 ± 0.6% | 14945.1 ± 0.6% | 3478.5 ± 0.7% | 421.0 ± 1.5% | 8859.9 ± 0.6% | 1134.5 ± 0.8% | 2.253 | 9.680 | 79.972 | 3.800 | 29.680 |
| hex: silesia/xml | 524290 | 33759.5 ± 0.9% | 14981.3 ± 0.4% | 3540.7 ± 0.6% | 729.0 ± 1.3% | 8877.5 ± 0.5% | 1133.4 ± 0.6% | 2.253 | 9.535 | 46.307 | 3.803 | 29.785 |
| hex: canterbury/alice29.txt | 304180 | 33642.4 ± 0.5% | 14087.2 ± 0.8% | 3554.2 ± 0.6% | 483.1 ± 0.3% | 8875.1 ± 0.3% | 1143.4 ± 0.7% | 2.388 | 9.465 | 69.644 | 3.791 | 29.423 |
| hex: canterbury/asyoulik.txt | 250360 | 33707.9 ± 0.6% | 14945.2 ± 0.8% | 3479.9 ± 0.9% | 470.5 ± 0.4% | 8884.3 ± 0.7% | 1140.0 ± 1.3% | 2.255 | 9.686 | 71.642 | 3.794 | 29.568 |
| hex: canterbury/cp.html | 49208 | 33258.7 ± 0.5% | 14354.1 ± 0.6% | 3541.4 ± 0.9% | 504.4 ± 0.8% | 9218.6 ± 0.5% | 1117.4 ± 2.1% | 2.317 | 9.391 | 65.943 | 3.608 | 29.766 |
| hex: canterbury/fields.c | 22302 | 32748.5 ± 0.6% | 17448.7 ± 0.8% | 3640.5 ± 1.0% | 566.0 ± 1.1% | 9200.5 ± 0.7% | 1099.7 ± 1.0% | 1.877 | 8.996 | 57.856 | 3.559 | 29.780 |
| hex: canterbury/grammar.lsp | 7444 | 29607.8 ± 0.3% | 17126.6 ± 0.6% | 3597.6 ± 0.2% | 761.1 ± 0.8% | 8921.5 ± 0.5% | 1061.9 ± 2.3% | 1.729 | 8.230 | 38.902 | 3.319 | 27.883 |
| hex: canterbury/kennedy.xls | 524290 | 33857.5 ± 0.7% | 15047.1 ± 0.6% | 3523.6 ± 0.3% | 748.8 ± 2.1% | 8897.5 ± 1.1% | 1110.7 ± 4.6% | 2.250 | 9.609 | 45.216 | 3.805 | 30.483 |
| hex: canterbury/lcet10.txt | 524290 | 33817.2 ± 0.5% | 14987.2 ± 0.6% | 3553.8 ± 0.5% | 485.6 ± 0.7% | 8888.7 ± 0.3% | 1130.2 ± 1.7% | 2.256 | 9.516 | 69.638 | 3.805 | 29.922 |
| hex: canterbury/plrabn12.txt | 524290 | 33811.9 ± 0.9% | 15031.0 ± 1.0% | 3551.8 ± 0.4% | 465.8 ± 0.3% | 8886.7 ± 0.5% | 1134.2 ± 0.5% | 2.249 | 9.520 | 72.582 | 3.805 | 29.812 |
| hex: canterbury/ptt5 | 524290 | 33756.1 ± 1.1% | 15010.2 ± 0.7% | 3474.2 ± 3.4% | 665.4 ± 0.7% | 8861.7 ± 0.6% | 1134.2 ± 0.8% | 2.249 | 9.716 | 50.728 | 3.809 | 29.761 |
| hex: canterbury/sum | 76482 | 33105.7 ± 0.5% | 15352.6 ± 1.0% | 3541.3 ± 2.4% | 578.2 ± 1.2% | 8886.3 ± 0.5% | 1120.7 ± 1.4% | 2.156 | 9.348 | 57.254 | 3.725 | 29.540 |
| hex: canterbury/xargs.1 | 8456 | 30022.9 ± 0.3% | 17283.1 ± 0.3% | 3547.9 ± 0.7% | 730.6 ± 5.8% | 8935.4 ± 0.5% | 1097.6 ± 1.9% | 1.737 | 8.462 | 41.095 | 3.360 | 27.354 |
| hex: canterbury-large/E.coli | 524290 | 33659.0 ± 0.6% | 14972.3 ± 3.0% | 3471.9 ± 0.2% | 956.2 ± 0.7% | 8872.7 ± 0.5% | 1118.6 ± 7.0% | 2.248 | 9.695 | 35.200 | 3.794 | 30.092 |
| hex: canterbury-large/bible.txt | 524290 | 33751.9 ± 0.5% | 14922.1 ± 1.9% | 3460.8 ± 0.7% | 497.8 ± 2.2% | 8884.9 ± 0.5% | 1101.4 ± 4.0% | 2.262 | 9.753 | 67.802 | 3.799 | 30.644 |
| hex: canterbury-large/world192.txt | 524290 | 33845.1 ± 0.7% | 15023.7 ± 1.0% | 3543.5 ± 0.9% | 468.6 ± 0.7% | 8889.4 ± 0.3% | 1122.5 ± 3.3% | 2.253 | 9.551 | 72.225 | 3.807 | 30.151 |
| hex: http/html-1kx1024 | 2099200 | 14853.2 ± 0.6% | 12267.6 ± 0.8% | 3154.5 ± 0.8% | 504.3 ± 1.0% | 7471.6 ± 3.7% | 967.2 ± 2.8% | 1.211 | 4.709 | 29.454 | 1.988 | 15.356 |
| hex: http/html-16kx64 | 2097280 | 27530.6 ± 1.0% | 13785.5 ± 1.2% | 3387.6 ± 1.0% | 510.7 ± 3.3% | 8578.5 ± 1.1% | 1075.0 ± 0.7% | 1.997 | 8.127 | 53.904 | 3.209 | 25.610 |
| hex: http/html-1m | 524290 | 33662.8 ± 0.5% | 14947.1 ± 0.6% | 3473.4 ± 3.2% | 505.3 ± 0.8% | 8871.7 ± 0.7% | 1119.3 ± 3.2% | 2.252 | 9.692 | 66.622 | 3.794 | 30.075 |
| hex: http/json-1kx1024 | 2099200 | 15053.5 ± 1.6% | 12515.8 ± 1.8% | 3157.5 ± 1.0% | 683.2 ± 1.2% | 7545.7 ± 3.8% | 976.4 ± 2.0% | 1.203 | 4.768 | 22.035 | 1.995 | 15.417 |
| hex: http/json-16kx64 | 2097280 | 27668.1 ± 1.0% | 13911.5 ± 1.2% | 3406.8 ± 0.8% | 696.7 ± 0.5% | 8575.5 ± 1.3% | 1068.3 ± 4.1% | 1.989 | 8.121 | 39.714 | 3.226 | 25.900 |
| hex: http/json-1m | 524290 | 33807.7 ± 0.7% | 14994.5 ± 1.3% | 3521.5 ± 2.3% | 711.7 ± 2.5% | 8958.2 ± 1.4% | 1111.9 ± 3.2% | 2.255 | 9.600 | 47.504 | 3.774 | 30.404 |
| hex: http/js-1kx1024 | 2099200 | 14839.4 ± 1.6% | 12473.0 ± 2.9% | 3158.7 ± 3.7% | 491.9 ± 0.6% | 7629.0 ± 3.2% | 956.3 ± 1.9% | 1.190 | 4.698 | 30.166 | 1.945 | 15.518 |
| hex: http/js-16kx64 | 2097280 | 27504.3 ± 4.6% | 14012.4 ± 1.0% | 3411.6 ± 1.1% | 497.8 ± 1.0% | 8609.9 ± 0.9% | 1066.2 ± 4.4% | 1.963 | 8.062 | 55.249 | 3.195 | 25.796 |
| hex: http/js-1m | 524290 | 34016.0 ± 1.0% | 15079.8 ± 1.2% | 3563.6 ± 0.9% | 512.2 ± 2.9% | 8949.6 ± 0.6% | 1104.7 ± 1.9% | 2.256 | 9.545 | 66.409 | 3.801 | 30.793 |
| hex: http/css-1kx1024 | 2099200 | 14931.6 ± 1.8% | 12239.1 ± 0.7% | 3154.1 ± 0.4% | 565.3 ± 1.1% | 7470.3 ± 4.8% | 973.5 ± 2.2% | 1.220 | 4.734 | 26.412 | 1.999 | 15.338 |
| hex: http/css-16kx64 | 2097280 | 28225.2 ± 1.2% | 13837.8 ± 0.8% | 3397.4 ± 0.5% | 578.2 ± 0.9% | 8621.5 ± 1.0% | 1064.5 ± 3.3% | 2.040 | 8.308 | 48.814 | 3.274 | 26.514 |
| hex: http/css-1m | 524290 | 34040.8 ± 0.9% | 15115.1 ± 0.4% | 3561.2 ± 1.0% | 562.3 ± 0.6% | 8960.9 ± 0.2% | 1120.3 ± 3.2% | 2.252 | 9.559 | 60.541 | 3.799 | 30.386 |
| hex: shuffled/dickens-1m | 524290 | 34006.5 ± 1.0% | 15115.7 ± 0.9% | 3507.2 ± 0.2% | 481.2 ± 0.3% | 8938.9 ± 0.7% | 1112.4 ± 3.2% | 2.250 | 9.696 | 70.677 | 3.804 | 30.570 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1575.6 ± 0.5% | 1465.8 ± 1.1% | 1019.8 ± 1.2% | 475.1 ± 0.7% | 430.3 ± 2.7% | 500.1 ± 1.0% | 1.075 | 1.545 | 3.316 | 3.662 | 3.151 |
| qlog records, JSON text sequence | 1467503 | 1451.1 ± 1.4% | 1256.8 ± 3.3% | 950.4 ± 0.9% | 450.5 ± 1.0% | 537.9 ± 0.8% | 353.6 ± 0.4% | 1.155 | 1.527 | 3.221 | 2.698 | 4.104 |
| string: silesia/dickens | 172528 | 13526.1 ± 1.2% | 3942.1 ± 1.2% | 3102.3 ± 4.6% | 359.4 ± 1.4% | 1511.5 ± 0.9% | 1181.5 ± 0.8% | 3.431 | 4.360 | 37.631 | 8.949 | 11.448 |
| string: silesia/nci | 1075110 | 11703.1 ± 1.2% | 4670.7 ± 1.3% | 3137.6 ± 0.9% | 858.2 ± 1.7% | 1544.2 ± 2.2% | 1196.3 ± 1.8% | 2.506 | 3.730 | 13.637 | 7.579 | 9.783 |
| string: silesia/reymont | 1075159 | 5446.2 ± 2.0% | 1839.2 ± 0.5% | 1937.1 ± 0.6% | 393.8 ± 1.2% | 1299.2 ± 1.1% | 1042.0 ± 1.7% | 2.961 | 2.812 | 13.831 | 4.192 | 5.227 |
| string: silesia/samba | 97582 | 6642.2 ± 0.4% | 2693.9 ± 0.8% | 4014.5 ± 0.3% | 376.8 ± 0.4% | 1244.1 ± 0.8% | 1170.1 ± 1.2% | 2.466 | 1.655 | 17.628 | 5.339 | 5.677 |
| string: silesia/webster | 1098490 | 7176.8 ± 0.9% | 1962.9 ± 1.1% | 1809.3 ± 1.3% | 381.4 ± 0.6% | 1240.0 ± 1.8% | 599.2 ± 1.2% | 3.656 | 3.967 | 18.819 | 5.788 | 11.977 |
| string: silesia/xml | 1090118 | 11338.0 ± 0.3% | 3196.9 ± 1.5% | 2545.7 ± 0.7% | 626.2 ± 0.7% | 1685.7 ± 1.2% | 960.6 ± 0.4% | 3.547 | 4.454 | 18.106 | 6.726 | 11.802 |
| string: canterbury/alice29.txt | 159425 | 13308.4 ± 2.8% | 2861.5 ± 1.2% | 3042.0 ± 0.8% | 342.4 ± 0.8% | 1338.3 ± 0.9% | 1086.2 ± 3.8% | 4.651 | 4.375 | 38.869 | 9.944 | 12.252 |
| string: canterbury/asyoulik.txt | 132198 | 11852.2 ± 1.4% | 2078.2 ± 2.7% | 3121.2 ± 1.0% | 350.1 ± 1.0% | 1212.3 ± 3.7% | 953.4 ± 0.9% | 5.703 | 3.797 | 33.857 | 9.777 | 12.432 |
| string: canterbury/lcet10.txt | 441884 | 13162.2 ± 1.7% | 3074.1 ± 0.9% | 2696.9 ± 1.5% | 384.8 ± 3.0% | 1451.6 ± 1.1% | 1190.6 ± 1.6% | 4.282 | 4.880 | 34.202 | 9.068 | 11.055 |
| string: canterbury/plrabn12.txt | 503330 | 8964.4 ± 1.4% | 2312.0 ± 0.5% | 2124.0 ± 1.1% | 363.4 ± 0.5% | 1346.6 ± 3.1% | 1124.2 ± 1.7% | 3.877 | 4.220 | 24.665 | 6.657 | 7.974 |
| string: canterbury-large/E.coli | 1048578 | 31480.3 ± 0.5% | 16007.5 ± 0.9% | 3468.6 ± 0.5% | 1686.5 ± 0.7% | 3106.2 ± 0.9% | 1405.0 ± 0.8% | 1.967 | 9.076 | 18.666 | 10.135 | 22.406 |
| string: canterbury-large/bible.txt | 1055886 | 9776.3 ± 0.6% | 4867.6 ± 0.6% | 3015.3 ± 0.5% | 419.8 ± 0.3% | 2033.6 ± 0.3% | 1486.8 ± 0.6% | 2.008 | 3.242 | 23.290 | 4.807 | 6.575 |
| string: canterbury-large/world192.txt | 1103121 | 6729.9 ± 1.0% | 1726.4 ± 0.5% | 1920.2 ± 3.1% | 388.2 ± 0.2% | 1245.4 ± 3.4% | 962.8 ± 0.4% | 3.898 | 3.505 | 17.337 | 5.404 | 6.990 |
| string: http/html-1m | 1058582 | 10288.1 ± 0.8% | 4364.9 ± 3.4% | 2901.0 ± 0.8% | 458.3 ± 0.7% | 2024.3 ± 1.3% | 844.4 ± 1.9% | 2.357 | 3.546 | 22.447 | 5.082 | 12.184 |
| string: http/json-1m | 1190272 | 8734.7 ± 0.7% | 1576.4 ± 2.5% | 1719.0 ± 0.5% | 536.5 ± 0.8% | 1019.2 ± 0.5% | 843.4 ± 1.6% | 5.541 | 5.081 | 16.281 | 8.570 | 10.357 |
| string: http/js-1m | 1144362 | 6631.6 ± 0.3% | 1117.0 ± 0.7% | 1452.8 ± 0.6% | 360.5 ± 0.6% | 1015.6 ± 3.5% | 757.6 ± 0.5% | 5.937 | 4.565 | 18.394 | 6.529 | 8.754 |
| string: http/css-1m | 1097820 | 9481.7 ± 0.7% | 1484.8 ± 1.2% | 2311.7 ± 0.5% | 543.1 ± 1.1% | 1130.6 ± 1.0% | 877.0 ± 0.5% | 6.386 | 4.102 | 17.458 | 8.386 | 10.812 |
| string: dickens as Cyrillic and CJK | 1883069 | 5616.0 ± 0.9% | 3712.9 ± 1.3% | 478.0 ± 3.2% | 250.7 ± 1.2% | 456.2 ± 0.8% | 354.3 ± 2.6% | 1.513 | 11.749 | 22.404 | 12.310 | 15.849 |
| hex: silesia/dickens | 524290 | 42050.3 ± 1.4% | 2578.8 ± 0.9% | 1503.8 ± 0.8% | 467.0 ± 0.6% | 1546.9 ± 1.4% | 1063.0 ± 0.4% | 16.306 | 27.963 | 90.046 | 27.183 | 39.558 |
| hex: silesia/mozilla | 524290 | 42721.3 ± 1.7% | 2571.7 ± 0.8% | 1501.2 ± 0.7% | 411.9 ± 0.9% | 1499.2 ± 1.5% | 1063.8 ± 1.2% | 16.612 | 28.459 | 103.711 | 28.496 | 40.160 |
| hex: silesia/mr | 524290 | 42876.6 ± 1.3% | 2572.8 ± 1.2% | 1497.9 ± 1.0% | 607.1 ± 0.8% | 1534.5 ± 0.5% | 1060.2 ± 0.5% | 16.665 | 28.624 | 70.627 | 27.941 | 40.441 |
| hex: silesia/nci | 524290 | 43454.8 ± 2.7% | 2562.2 ± 0.9% | 1499.7 ± 0.4% | 745.9 ± 0.9% | 1492.2 ± 1.0% | 1064.9 ± 0.4% | 16.960 | 28.975 | 58.259 | 29.121 | 40.806 |
| hex: silesia/ooffice | 524290 | 43107.5 ± 1.6% | 2568.7 ± 1.9% | 1503.1 ± 0.3% | 340.9 ± 0.6% | 1534.6 ± 1.2% | 1061.6 ± 0.6% | 16.782 | 28.680 | 126.462 | 28.090 | 40.608 |
| hex: silesia/osdb | 524290 | 41727.5 ± 2.3% | 2563.4 ± 1.6% | 1502.4 ± 0.7% | 448.9 ± 0.7% | 1490.6 ± 1.6% | 1064.0 ± 1.5% | 16.278 | 27.775 | 92.953 | 27.993 | 39.216 |
| hex: silesia/reymont | 524290 | 43020.7 ± 1.1% | 2567.4 ± 1.2% | 1502.0 ± 0.5% | 491.9 ± 0.7% | 1541.2 ± 5.2% | 1062.3 ± 0.7% | 16.757 | 28.642 | 87.464 | 27.914 | 40.499 |
| hex: silesia/samba | 524290 | 43009.1 ± 0.7% | 2576.9 ± 1.2% | 1502.1 ± 0.5% | 360.8 ± 0.6% | 1506.1 ± 0.9% | 1061.9 ± 0.6% | 16.690 | 28.633 | 119.195 | 28.557 | 40.501 |
| hex: silesia/sao | 524290 | 42869.2 ± 0.9% | 2583.5 ± 1.0% | 1505.3 ± 0.5% | 278.5 ± 0.5% | 1549.5 ± 0.9% | 1063.1 ± 1.0% | 16.593 | 28.478 | 153.920 | 27.667 | 40.324 |
| hex: silesia/webster | 524290 | 42620.2 ± 3.9% | 2579.2 ± 0.8% | 1504.2 ± 1.2% | 443.7 ± 0.9% | 1503.3 ± 5.2% | 1064.4 ± 1.1% | 16.524 | 28.334 | 96.066 | 28.350 | 40.041 |
| hex: silesia/x-ray | 524290 | 42869.2 ± 2.4% | 2581.8 ± 1.0% | 1504.3 ± 0.8% | 426.2 ± 1.1% | 1541.1 ± 3.0% | 1057.8 ± 0.4% | 16.604 | 28.498 | 100.578 | 27.817 | 40.527 |
| hex: silesia/xml | 524290 | 42654.3 ± 2.2% | 2579.5 ± 0.5% | 1504.8 ± 0.7% | 712.7 ± 0.9% | 1491.4 ± 1.7% | 1063.2 ± 6.1% | 16.536 | 28.346 | 59.849 | 28.600 | 40.120 |
| hex: canterbury/alice29.txt | 304180 | 41044.0 ± 2.1% | 2593.9 ± 1.0% | 1524.1 ± 0.4% | 475.4 ± 0.7% | 1523.6 ± 1.2% | 1078.2 ± 1.2% | 15.823 | 26.930 | 86.336 | 26.939 | 38.068 |
| hex: canterbury/asyoulik.txt | 250360 | 42417.5 ± 1.5% | 2580.0 ± 4.8% | 1536.4 ± 1.0% | 463.5 ± 0.9% | 1538.4 ± 1.0% | 1077.2 ± 1.5% | 16.441 | 27.608 | 91.510 | 27.573 | 39.376 |
| hex: canterbury/cp.html | 49208 | 41864.3 ± 0.8% | 2567.9 ± 0.5% | 1520.8 ± 0.3% | 501.9 ± 1.7% | 1569.4 ± 0.9% | 1085.2 ± 0.8% | 16.303 | 27.528 | 83.409 | 26.675 | 38.579 |
| hex: canterbury/fields.c | 22302 | 41749.5 ± 1.8% | 2633.9 ± 0.5% | 1529.0 ± 0.7% | 621.5 ± 1.7% | 1590.9 ± 0.6% | 1091.4 ± 0.3% | 15.851 | 27.305 | 67.180 | 26.243 | 38.254 |
| hex: canterbury/grammar.lsp | 7444 | 40410.4 ± 0.8% | 2683.5 ± 5.6% | 1539.6 ± 0.7% | 798.0 ± 5.3% | 1601.2 ± 4.9% | 1099.3 ± 0.4% | 15.059 | 26.247 | 50.641 | 25.237 | 36.761 |
| hex: canterbury/kennedy.xls | 524290 | 43242.7 ± 1.4% | 2553.4 ± 5.1% | 1496.0 ± 6.2% | 736.1 ± 4.5% | 1493.5 ± 5.0% | 1059.0 ± 1.8% | 16.936 | 28.905 | 58.749 | 28.955 | 40.832 |
| hex: canterbury/lcet10.txt | 524290 | 42885.7 ± 1.6% | 2562.4 ± 1.3% | 1503.7 ± 0.7% | 470.9 ± 1.6% | 1507.4 ± 5.2% | 1065.9 ± 8.3% | 16.736 | 28.521 | 91.076 | 28.449 | 40.236 |
| hex: canterbury/plrabn12.txt | 524290 | 42703.3 ± 1.2% | 2566.1 ± 7.2% | 1506.0 ± 4.7% | 457.7 ± 3.1% | 1517.4 ± 2.9% | 1064.6 ± 2.4% | 16.641 | 28.355 | 93.297 | 28.142 | 40.113 |
| hex: canterbury/ptt5 | 524290 | 42830.5 ± 1.5% | 2546.4 ± 0.4% | 1494.7 ± 5.2% | 602.6 ± 3.6% | 1493.2 ± 4.6% | 1059.4 ± 7.7% | 16.820 | 28.655 | 71.077 | 28.683 | 40.428 |
| hex: canterbury/sum | 76482 | 42130.7 ± 5.8% | 2572.4 ± 1.0% | 1517.5 ± 0.9% | 588.2 ± 1.5% | 1563.6 ± 1.2% | 1081.8 ± 3.7% | 16.378 | 27.762 | 71.631 | 26.944 | 38.947 |
| hex: canterbury/xargs.1 | 8456 | 40615.4 ± 3.8% | 2676.0 ± 0.5% | 1536.9 ± 4.6% | 824.2 ± 0.5% | 1599.1 ± 5.3% | 1105.0 ± 0.5% | 15.178 | 26.426 | 49.280 | 25.398 | 36.755 |
| hex: canterbury-large/E.coli | 524290 | 42452.9 ± 0.6% | 2572.0 ± 0.6% | 1509.5 ± 5.2% | 808.6 ± 0.9% | 1518.3 ± 1.0% | 1066.3 ± 0.4% | 16.506 | 28.124 | 52.502 | 27.961 | 39.813 |
| hex: canterbury-large/bible.txt | 524290 | 42434.2 ± 0.7% | 2590.4 ± 1.0% | 1516.5 ± 1.0% | 491.6 ± 4.1% | 1556.7 ± 1.7% | 1067.1 ± 1.1% | 16.382 | 27.982 | 86.314 | 27.260 | 39.765 |
| hex: canterbury-large/world192.txt | 524290 | 42682.2 ± 6.1% | 2590.8 ± 0.2% | 1515.4 ± 0.3% | 462.1 ± 1.7% | 1530.0 ± 1.9% | 1070.2 ± 5.2% | 16.475 | 28.166 | 92.373 | 27.897 | 39.882 |
| hex: http/html-1kx1024 | 2099200 | 21526.6 ± 0.6% | 2453.5 ± 2.2% | 1456.2 ± 1.1% | 506.8 ± 1.5% | 1462.7 ± 1.5% | 1067.8 ± 0.9% | 8.774 | 14.783 | 42.475 | 14.717 | 20.159 |
| hex: http/html-16kx64 | 2097280 | 21430.0 ± 0.4% | 2394.1 ± 1.3% | 1450.7 ± 0.9% | 513.9 ± 1.3% | 1449.2 ± 1.2% | 1079.1 ± 1.2% | 8.951 | 14.772 | 41.704 | 14.788 | 19.860 |
| hex: http/html-1m | 524290 | 39681.8 ± 4.8% | 2577.8 ± 2.0% | 1518.2 ± 4.8% | 496.6 ± 3.3% | 1496.8 ± 1.5% | 1073.4 ± 0.7% | 15.394 | 26.137 | 79.906 | 26.511 | 36.969 |
| hex: http/json-1kx1024 | 2099200 | 20751.0 ± 0.3% | 2446.5 ± 8.9% | 1452.3 ± 1.8% | 685.2 ± 1.3% | 1467.4 ± 0.5% | 1069.6 ± 1.6% | 8.482 | 14.289 | 30.286 | 14.141 | 19.402 |
| hex: http/json-16kx64 | 2097280 | 21601.6 ± 2.1% | 2377.5 ± 1.5% | 1449.8 ± 0.6% | 694.4 ± 0.6% | 1449.7 ± 2.0% | 1081.2 ± 1.1% | 9.086 | 14.900 | 31.108 | 14.901 | 19.980 |
| hex: http/json-1m | 524290 | 42810.8 ± 0.4% | 2569.8 ± 0.5% | 1507.8 ± 0.8% | 720.2 ± 0.5% | 1549.3 ± 0.9% | 1072.4 ± 0.4% | 16.659 | 28.392 | 59.446 | 27.632 | 39.921 |
| hex: http/js-1kx1024 | 2099200 | 22308.2 ± 0.5% | 2471.6 ± 0.9% | 1463.5 ± 0.9% | 496.9 ± 0.6% | 1487.0 ± 1.2% | 1079.4 ± 0.7% | 9.026 | 15.243 | 44.897 | 15.002 | 20.667 |
| hex: http/js-16kx64 | 2097280 | 22875.3 ± 0.8% | 2391.7 ± 1.1% | 1453.1 ± 0.6% | 500.8 ± 0.4% | 1456.6 ± 0.9% | 1087.4 ± 0.4% | 9.565 | 15.742 | 45.675 | 15.704 | 21.037 |
| hex: http/js-1m | 524290 | 41976.7 ± 1.8% | 2569.9 ± 0.7% | 1511.9 ± 0.6% | 513.1 ± 0.9% | 1552.3 ± 1.4% | 1062.4 ± 1.1% | 16.334 | 27.764 | 81.803 | 27.041 | 39.510 |
| hex: http/css-1kx1024 | 2099200 | 20310.1 ± 0.3% | 2460.0 ± 0.6% | 1465.9 ± 1.7% | 568.6 ± 0.8% | 1472.2 ± 0.6% | 1075.9 ± 1.2% | 8.256 | 13.855 | 35.718 | 13.796 | 18.877 |
| hex: http/css-16kx64 | 2097280 | 22133.5 ± 0.3% | 2388.9 ± 1.4% | 1457.4 ± 0.3% | 543.8 ± 1.2% | 1264.9 ± 0.4% | 1087.3 ± 0.4% | 9.265 | 15.187 | 40.698 | 17.499 | 20.357 |
| hex: http/css-1m | 524290 | 42704.3 ± 0.2% | 2571.8 ± 0.6% | 1521.3 ± 0.4% | 555.6 ± 0.8% | 1565.0 ± 1.7% | 1069.6 ± 0.8% | 16.605 | 28.071 | 76.856 | 27.287 | 39.925 |
| hex: shuffled/dickens-1m | 524290 | 42690.2 ± 0.3% | 2574.6 ± 0.6% | 1509.8 ± 0.6% | 471.6 ± 0.5% | 1552.9 ± 0.9% | 1071.9 ± 0.3% | 16.581 | 28.274 | 90.518 | 27.491 | 39.827 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- qlog records, JSON text sequence, decoding: stdx runs at 0.903 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.841 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.936 of yyjson.
