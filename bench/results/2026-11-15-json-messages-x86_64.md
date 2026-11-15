# bench-json

| Field | Value |
|---|---|
| Commit | cffc4ff |
| Runner label | ubuntu-24.04 |
| Image version | 20261111.127.1 |
| CPU model | Intel(R) Xeon(R) 6975P-C |
| Virtual CPUs | 4 |
| Kernel | 7.0.0-1014-aws |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/43657147834 |
| Date | 2026-11-15 |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1. The `TextReader.next_items` column is that helper's queued tokens a slice a call (decision 79), over many tokens a call.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | TextReader.next_items | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1380.9 ± 0.4% | 0.489 | 1.020 | 1.066 | 1.067 | 0.411 | 1.071 | 1.067 | 0.371 | 0.833 | 0.929 | 0.106 |
| qlog records, JSON text sequence | 1467503 | 1100.6 ± 0.9% | 0.792 | 1.062 | 1.061 | 1.068 | 0.384 | 1.067 | 1.067 | 0.366 | 0.930 | 1.045 | 0.124 |
| messages: 11 string members | 1025025 | 1076.0 ± 0.6% | 0.578 | 0.999 | 1.020 | 1.022 | 0.548 | 1.019 | 1.022 | 0.536 | 0.918 | 0.967 | 0.136 |
| messages: 50 nested objects | 1121600 | 1344.4 ± 0.3% | 0.805 | 1.089 | 1.086 | 1.090 | 0.396 | 1.097 | 1.089 | 0.351 | 0.921 | 0.968 | 0.114 |
| string: silesia/dickens | 172528 | 6713.5 ± 0.1% | 0.029 | 0.701 | 1.095 | 1.097 | 0.208 | 1.027 | 1.110 | 0.208 | 0.999 | 1.000 | 0.029 |
| string: silesia/nci | 1075110 | 5445.5 ± 0.3% | 0.035 | 0.710 | 1.031 | 1.032 | 0.304 | 1.038 | 1.031 | 0.303 | 1.005 | 1.005 | 0.035 |
| string: silesia/reymont | 1075159 | 3528.4 ± 2.5% | 0.055 | 0.630 | 0.866 | 0.867 | 0.356 | 0.817 | 0.876 | 0.356 | 0.989 | 1.007 | 0.055 |
| string: silesia/samba | 97582 | 3969.2 ± 3.5% | 0.041 | 0.906 | 1.068 | 1.068 | 0.075 | 0.860 | 1.069 | 0.075 | 1.003 | 1.011 | 0.041 |
| string: silesia/webster | 1098490 | 4440.8 ± 1.6% | 0.043 | 0.645 | 0.977 | 0.979 | 0.226 | 0.923 | 0.987 | 0.227 | 1.000 | 1.006 | 0.042 |
| string: silesia/xml | 1090118 | 6104.0 ± 0.3% | 0.032 | 0.776 | 0.966 | 0.969 | 0.250 | 0.957 | 0.972 | 0.251 | 1.004 | 1.008 | 0.032 |
| string: canterbury/alice29.txt | 159425 | 5789.7 ± 1.0% | 0.033 | 0.750 | 1.075 | 1.125 | 0.186 | 1.015 | 1.160 | 0.186 | 0.997 | 1.008 | 0.033 |
| string: canterbury/asyoulik.txt | 132198 | 4295.6 ± 0.7% | 0.042 | 0.805 | 1.130 | 1.122 | 0.202 | 1.042 | 1.134 | 0.203 | 1.002 | 1.002 | 0.042 |
| string: canterbury/lcet10.txt | 441884 | 6694.6 ± 1.0% | 0.029 | 0.601 | 1.097 | 1.104 | 0.199 | 1.036 | 1.112 | 0.199 | 1.002 | 1.003 | 0.029 |
| string: canterbury/plrabn12.txt | 503330 | 5464.4 ± 0.3% | 0.035 | 0.772 | 0.970 | 0.977 | 0.230 | 0.862 | 0.977 | 0.230 | 1.001 | 1.001 | 0.035 |
| string: canterbury-large/E.coli | 1048578 | 32174.3 ± 0.1% | 0.056 | 1.004 | 0.767 | 1.003 | 0.504 | 1.004 | 1.004 | 0.504 | 1.056 | 1.061 | 0.007 |
| string: canterbury-large/bible.txt | 1055886 | 8551.4 ± 1.5% | 0.024 | 0.630 | 0.879 | 0.884 | 0.399 | 0.890 | 0.898 | 0.400 | 1.008 | 1.014 | 0.024 |
| string: canterbury-large/world192.txt | 1103121 | 4173.8 ± 0.4% | 0.045 | 0.694 | 0.969 | 0.977 | 0.217 | 0.923 | 0.983 | 0.218 | 1.002 | 1.005 | 0.045 |
| string: http/html-1m | 1058582 | 9205.4 ± 5.3% | 0.022 | 0.564 | 0.781 | 0.781 | 0.320 | 0.747 | 0.790 | 0.319 | 0.967 | 1.047 | 0.022 |
| string: http/json-1m | 1190272 | 3337.7 ± 0.9% | 0.052 | 0.393 | 0.440 | 0.444 | 0.149 | 0.457 | 0.444 | 0.149 | 0.999 | 1.002 | 0.052 |
| string: http/js-1m | 1144362 | 2871.1 ± 0.8% | 0.062 | 0.698 | 0.910 | 0.918 | 0.194 | 0.844 | 0.918 | 0.194 | 1.005 | 1.007 | 0.062 |
| string: http/css-1m | 1097820 | 3299.7 ± 0.5% | 0.055 | 0.774 | 1.005 | 1.008 | 0.290 | 0.963 | 1.010 | 0.291 | 1.003 | 1.009 | 0.055 |
| string: dickens as Cyrillic and CJK | 1883069 | 5830.4 ± 0.4% | 0.025 | 0.063 | 0.453 | 0.453 | 0.200 | 0.452 | 0.453 | 0.200 | 1.000 | 1.003 | 0.025 |
| string: dickens as Cyrillic and CJK, as \u escapes | 5075485 | 1199.6 ± 4.3% | 0.113 | 1.002 | 1.003 | 1.006 | 0.106 | 0.716 | 1.003 | 0.106 | 1.008 | 1.010 | 0.113 |
| hex: silesia/dickens | 524290 | 45716.8 ± 2.4% | 0.040 | 1.001 | 0.628 | 1.001 | 0.397 | 0.998 | 1.000 | 0.397 | 0.742 | 0.743 | 0.005 |
| hex: silesia/mozilla | 524290 | 46250.4 ± 1.7% | 0.039 | 0.999 | 0.615 | 1.001 | 0.369 | 0.999 | 0.998 | 0.368 | 0.729 | 0.733 | 0.005 |
| hex: silesia/mr | 524290 | 45455.2 ± 0.3% | 0.040 | 1.004 | 0.620 | 1.004 | 0.392 | 1.003 | 1.003 | 0.392 | 0.747 | 0.748 | 0.005 |
| hex: silesia/nci | 524290 | 45585.0 ± 0.2% | 0.040 | 1.001 | 0.625 | 1.000 | 0.397 | 0.997 | 1.000 | 0.398 | 0.746 | 0.745 | 0.005 |
| hex: silesia/ooffice | 524290 | 46424.2 ± 2.5% | 0.039 | 1.002 | 0.615 | 1.002 | 0.375 | 0.999 | 1.001 | 0.376 | 0.732 | 0.731 | 0.005 |
| hex: silesia/osdb | 524290 | 46065.6 ± 0.2% | 0.040 | 1.003 | 0.621 | 1.005 | 0.392 | 0.999 | 1.005 | 0.392 | 0.737 | 0.738 | 0.005 |
| hex: silesia/reymont | 524290 | 46394.6 ± 2.0% | 0.040 | 1.001 | 0.616 | 1.000 | 0.391 | 0.999 | 1.000 | 0.391 | 0.732 | 0.732 | 0.005 |
| hex: silesia/samba | 524290 | 46538.4 ± 0.4% | 0.039 | 1.004 | 0.604 | 1.002 | 0.385 | 1.001 | 1.004 | 0.386 | 0.729 | 0.730 | 0.005 |
| hex: silesia/sao | 524290 | 43978.0 ± 0.2% | 0.042 | 1.007 | 0.628 | 1.006 | 0.394 | 1.003 | 1.006 | 0.394 | 0.772 | 0.772 | 0.005 |
| hex: silesia/webster | 524290 | 45782.7 ± 0.2% | 0.040 | 1.000 | 0.628 | 0.999 | 0.395 | 0.996 | 1.001 | 0.395 | 0.742 | 0.742 | 0.005 |
| hex: silesia/x-ray | 524290 | 45558.4 ± 2.2% | 0.040 | 1.000 | 0.628 | 1.001 | 0.393 | 0.997 | 1.000 | 0.393 | 0.745 | 0.746 | 0.005 |
| hex: silesia/xml | 524290 | 47224.1 ± 0.2% | 0.039 | 1.001 | 0.603 | 0.999 | 0.383 | 0.992 | 0.999 | 0.383 | 0.719 | 0.718 | 0.004 |
| hex: canterbury/alice29.txt | 304180 | 46236.6 ± 0.2% | 0.040 | 1.000 | 0.615 | 1.001 | 0.390 | 0.997 | 1.002 | 0.390 | 0.732 | 0.732 | 0.005 |
| hex: canterbury/asyoulik.txt | 250360 | 45377.0 ± 0.7% | 0.040 | 1.002 | 0.630 | 1.001 | 0.398 | 0.997 | 1.002 | 0.397 | 0.745 | 0.745 | 0.005 |
| hex: canterbury/cp.html | 49208 | 44777.5 ± 1.3% | 0.041 | 0.999 | 0.621 | 1.002 | 0.394 | 0.999 | 0.997 | 0.395 | 0.742 | 0.742 | 0.005 |
| hex: canterbury/fields.c | 22302 | 50566.9 ± 1.1% | 0.037 | 1.009 | 0.540 | 1.014 | 0.391 | 1.001 | 1.006 | 0.399 | 0.649 | 0.650 | 0.004 |
| hex: canterbury/grammar.lsp | 7444 | 44310.0 ± 1.6% | 0.042 | 1.011 | 0.573 | 1.019 | 0.406 | 0.998 | 1.015 | 0.428 | 0.670 | 0.670 | 0.005 |
| hex: canterbury/kennedy.xls | 524290 | 45053.1 ± 1.7% | 0.040 | 1.004 | 0.621 | 1.006 | 0.399 | 1.002 | 1.006 | 0.399 | 0.751 | 0.751 | 0.005 |
| hex: canterbury/lcet10.txt | 524290 | 47668.8 ± 2.3% | 0.038 | 1.005 | 0.587 | 0.999 | 0.377 | 0.996 | 0.999 | 0.380 | 0.711 | 0.710 | 0.004 |
| hex: canterbury/plrabn12.txt | 524290 | 45099.7 ± 0.5% | 0.040 | 0.995 | 0.622 | 0.996 | 0.398 | 0.994 | 0.999 | 0.397 | 0.749 | 0.750 | 0.005 |
| hex: canterbury/ptt5 | 524290 | 44878.0 ± 1.6% | 0.041 | 1.003 | 0.636 | 1.002 | 0.398 | 0.999 | 1.001 | 0.399 | 0.753 | 0.754 | 0.005 |
| hex: canterbury/sum | 76482 | 45757.0 ± 1.3% | 0.040 | 1.006 | 0.615 | 1.007 | 0.388 | 1.008 | 1.010 | 0.390 | 0.725 | 0.726 | 0.005 |
| hex: canterbury/xargs.1 | 8456 | 46281.8 ± 0.6% | 0.040 | 1.002 | 0.556 | 1.002 | 0.396 | 1.000 | 1.006 | 0.415 | 0.654 | 0.655 | 0.005 |
| hex: canterbury-large/E.coli | 524290 | 47413.2 ± 0.3% | 0.039 | 1.004 | 0.596 | 1.002 | 0.382 | 0.994 | 1.003 | 0.382 | 0.717 | 0.716 | 0.004 |
| hex: canterbury-large/bible.txt | 524290 | 45763.1 ± 0.3% | 0.040 | 1.000 | 0.628 | 1.001 | 0.394 | 0.998 | 1.001 | 0.394 | 0.742 | 0.742 | 0.005 |
| hex: canterbury-large/world192.txt | 524290 | 45691.5 ± 0.6% | 0.040 | 1.002 | 0.626 | 1.001 | 0.395 | 0.998 | 1.002 | 0.395 | 0.744 | 0.744 | 0.005 |
| hex: http/html-1kx1024 | 2099200 | 18148.9 ± 0.9% | 0.100 | 1.022 | 0.825 | 0.999 | 0.581 | 1.008 | 1.000 | 0.634 | 0.855 | 0.839 | 0.012 |
| hex: http/html-16kx64 | 2097280 | 34966.2 ± 0.5% | 0.052 | 1.002 | 0.688 | 1.003 | 0.471 | 1.004 | 1.004 | 0.477 | 0.806 | 0.806 | 0.006 |
| hex: http/html-1m | 524290 | 46376.8 ± 0.8% | 0.040 | 1.001 | 0.615 | 0.999 | 0.391 | 0.997 | 1.000 | 0.391 | 0.733 | 0.733 | 0.005 |
| hex: http/json-1kx1024 | 2099200 | 18216.2 ± 2.1% | 0.099 | 1.022 | 0.827 | 1.003 | 0.591 | 1.010 | 1.002 | 0.652 | 0.856 | 0.838 | 0.012 |
| hex: http/json-16kx64 | 2097280 | 36001.3 ± 0.7% | 0.051 | 1.006 | 0.676 | 1.004 | 0.457 | 1.002 | 1.005 | 0.463 | 0.786 | 0.786 | 0.006 |
| hex: http/json-1m | 524290 | 48826.7 ± 3.4% | 0.038 | 1.001 | 0.586 | 0.999 | 0.370 | 0.994 | 1.000 | 0.370 | 0.695 | 0.696 | 0.004 |
| hex: http/js-1kx1024 | 2099200 | 18179.1 ± 1.1% | 0.100 | 1.024 | 0.821 | 1.002 | 0.582 | 1.008 | 0.995 | 0.648 | 0.848 | 0.824 | 0.012 |
| hex: http/js-16kx64 | 2097280 | 35157.7 ± 0.2% | 0.052 | 1.003 | 0.680 | 1.004 | 0.465 | 1.003 | 1.005 | 0.469 | 0.795 | 0.796 | 0.006 |
| hex: http/js-1m | 524290 | 46651.9 ± 0.8% | 0.039 | 1.005 | 0.612 | 1.002 | 0.385 | 1.000 | 1.003 | 0.385 | 0.728 | 0.728 | 0.005 |
| hex: http/css-1kx1024 | 2099200 | 18298.7 ± 0.9% | 0.099 | 1.017 | 0.823 | 1.000 | 0.573 | 1.006 | 0.997 | 0.631 | 0.847 | 0.830 | 0.012 |
| hex: http/css-16kx64 | 2097280 | 34425.7 ± 0.3% | 0.053 | 1.004 | 0.692 | 1.005 | 0.473 | 1.005 | 1.004 | 0.478 | 0.806 | 0.806 | 0.006 |
| hex: http/css-1m | 524290 | 45555.0 ± 0.3% | 0.040 | 1.005 | 0.631 | 1.002 | 0.396 | 0.999 | 1.001 | 0.396 | 0.746 | 0.746 | 0.005 |
| hex: shuffled/dickens-1m | 524290 | 44730.6 ± 0.3% | 0.041 | 1.003 | 0.636 | 1.003 | 0.396 | 1.000 | 1.003 | 0.396 | 0.759 | 0.760 | 0.005 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1769.3 ± 0.8% | 0.421 | 0.996 | 0.969 | 1.005 | 1.004 | 0.271 | 1.006 | 0.516 | 0.900 | 0.094 | 1.026 |
| qlog records, JSON text sequence | 1467503 | 1653.8 ± 2.5% | 0.634 | 0.972 | 0.982 | 1.010 | 0.987 | 0.230 | 0.988 | 0.456 | 0.857 | 0.107 | 1.038 |
| messages: 11 string members | 1025025 | 1344.7 ± 2.3% | 0.498 | 0.965 | 0.979 | 0.988 | 0.975 | 0.375 | 0.976 | 0.669 | 0.941 | 0.121 | 0.997 |
| messages: 50 nested objects | 1121600 | 2011.2 ± 0.6% | 0.579 | 0.980 | 0.968 | 0.991 | 0.972 | 0.242 | 0.973 | 0.462 | 0.855 | 0.091 | 1.006 |
| string: silesia/dickens | 172528 | 13146.6 ± 0.6% | 0.017 | 0.524 | 0.359 | 0.519 | 0.542 | 0.119 | 0.547 | 0.997 | 0.998 | 0.017 | 1.025 |
| string: silesia/nci | 1075110 | 11305.9 ± 0.5% | 0.020 | 0.527 | 0.360 | 0.536 | 0.526 | 0.185 | 0.527 | 1.002 | 1.006 | 0.020 | 1.042 |
| string: silesia/reymont | 1075159 | 5331.6 ± 0.9% | 0.043 | 0.579 | 0.434 | 0.570 | 0.580 | 0.268 | 0.574 | 1.004 | 1.015 | 0.043 | 1.024 |
| string: silesia/samba | 97582 | 6323.7 ± 0.3% | 0.045 | 0.891 | 0.743 | 0.893 | 0.892 | 0.122 | 0.894 | 1.002 | 1.003 | 0.045 | 1.166 |
| string: silesia/webster | 1098490 | 6893.8 ± 0.4% | 0.032 | 0.587 | 0.409 | 0.563 | 0.592 | 0.159 | 0.590 | 0.992 | 1.008 | 0.032 | 1.014 |
| string: silesia/xml | 1090118 | 10346.9 ± 0.8% | 0.022 | 0.582 | 0.484 | 0.580 | 0.586 | 0.215 | 0.586 | 1.000 | 1.012 | 0.022 | 1.074 |
| string: canterbury/alice29.txt | 159425 | 12716.1 ± 1.7% | 0.018 | 0.436 | 0.359 | 0.420 | 0.457 | 0.092 | 0.477 | 0.999 | 1.000 | 0.018 | 1.056 |
| string: canterbury/asyoulik.txt | 132198 | 10360.9 ± 2.5% | 0.021 | 0.411 | 0.352 | 0.412 | 0.437 | 0.096 | 0.447 | 0.992 | 1.018 | 0.021 | 1.088 |
| string: canterbury/lcet10.txt | 441884 | 12036.3 ± 0.9% | 0.019 | 0.578 | 0.343 | 0.564 | 0.582 | 0.124 | 0.585 | 0.996 | 1.015 | 0.019 | 1.051 |
| string: canterbury/plrabn12.txt | 503330 | 8199.4 ± 1.8% | 0.027 | 0.665 | 0.536 | 0.665 | 0.667 | 0.172 | 0.666 | 1.003 | 1.015 | 0.027 | 1.093 |
| string: canterbury-large/E.coli | 1048578 | 31275.3 ± 1.0% | 0.058 | 1.004 | 1.004 | 0.792 | 1.007 | 0.516 | 1.007 | 1.006 | 1.010 | 0.008 | 1.002 |
| string: canterbury-large/bible.txt | 1055886 | 9320.6 ± 0.6% | 0.025 | 0.765 | 0.588 | 0.769 | 0.779 | 0.405 | 0.787 | 0.998 | 1.000 | 0.025 | 1.056 |
| string: canterbury-large/world192.txt | 1103121 | 6593.4 ± 1.4% | 0.034 | 0.592 | 0.427 | 0.563 | 0.597 | 0.154 | 0.598 | 0.988 | 1.001 | 0.034 | 0.987 |
| string: http/html-1m | 1058582 | 10093.7 ± 0.7% | 0.023 | 0.640 | 0.531 | 0.634 | 0.644 | 0.314 | 0.645 | 1.000 | 1.014 | 0.023 | 1.009 |
| string: http/json-1m | 1190272 | 8584.0 ± 0.7% | 0.024 | 0.180 | 0.157 | 0.180 | 0.180 | 0.071 | 0.180 | 1.003 | 1.008 | 0.024 | 1.025 |
| string: http/js-1m | 1144362 | 6509.8 ± 0.4% | 0.033 | 0.372 | 0.314 | 0.362 | 0.372 | 0.094 | 0.373 | 0.999 | 1.008 | 0.033 | 1.016 |
| string: http/css-1m | 1097820 | 9059.8 ± 0.9% | 0.024 | 0.363 | 0.293 | 0.354 | 0.364 | 0.127 | 0.364 | 1.007 | 1.011 | 0.024 | 1.051 |
| string: dickens as Cyrillic and CJK | 1883069 | 5496.4 ± 0.5% | 0.030 | 0.467 | 0.069 | 0.465 | 0.467 | 0.210 | 0.467 | 1.000 | 1.002 | 0.031 | 1.047 |
| hex: silesia/dickens | 524290 | 43511.1 ± 0.8% | 1.003 | 0.088 | 1.002 | 0.591 | 1.001 | 0.928 | 0.999 | 1.000 | 1.000 | 0.095 | 0.998 |
| hex: silesia/mozilla | 524290 | 43634.6 ± 0.8% | 1.002 | 0.088 | 1.003 | 0.590 | 1.002 | 0.949 | 1.002 | 1.002 | 1.001 | 0.093 | 1.003 |
| hex: silesia/mr | 524290 | 43607.8 ± 0.2% | 1.002 | 0.088 | 1.001 | 0.590 | 1.002 | 1.001 | 1.002 | 1.002 | 1.001 | 0.094 | 1.002 |
| hex: silesia/nci | 524290 | 43751.9 ± 0.3% | 1.001 | 0.088 | 0.998 | 0.589 | 0.990 | 0.999 | 1.000 | 0.999 | 0.998 | 0.093 | 0.999 |
| hex: silesia/ooffice | 524290 | 43359.7 ± 1.9% | 1.004 | 0.089 | 1.003 | 0.593 | 1.003 | 1.003 | 1.004 | 1.004 | 1.002 | 0.095 | 1.005 |
| hex: silesia/osdb | 524290 | 43811.2 ± 0.1% | 1.002 | 0.088 | 1.000 | 0.588 | 1.000 | 0.999 | 1.001 | 1.001 | 0.998 | 0.094 | 1.000 |
| hex: silesia/reymont | 524290 | 43613.1 ± 0.1% | 1.001 | 0.088 | 1.000 | 0.590 | 1.001 | 0.999 | 1.001 | 0.999 | 1.000 | 0.093 | 1.001 |
| hex: silesia/samba | 524290 | 43632.2 ± 0.2% | 0.968 | 0.088 | 1.000 | 0.590 | 1.001 | 1.000 | 0.969 | 1.000 | 1.000 | 0.092 | 1.000 |
| hex: silesia/sao | 524290 | 43749.4 ± 0.1% | 1.001 | 0.088 | 1.000 | 0.589 | 1.001 | 0.999 | 1.000 | 1.000 | 1.001 | 0.094 | 0.999 |
| hex: silesia/webster | 524290 | 44031.9 ± 0.0% | 0.972 | 0.088 | 1.000 | 0.586 | 1.000 | 0.998 | 0.997 | 1.000 | 0.999 | 0.093 | 1.000 |
| hex: silesia/x-ray | 524290 | 43756.7 ± 0.1% | 1.002 | 0.088 | 1.001 | 0.589 | 1.000 | 0.999 | 1.001 | 1.001 | 0.999 | 0.091 | 1.000 |
| hex: silesia/xml | 524290 | 43442.7 ± 0.2% | 1.001 | 0.089 | 0.999 | 0.593 | 1.000 | 0.999 | 1.000 | 1.000 | 1.000 | 0.093 | 1.000 |
| hex: canterbury/alice29.txt | 304180 | 43656.9 ± 0.1% | 1.001 | 0.088 | 1.002 | 0.589 | 1.002 | 1.001 | 1.002 | 1.002 | 1.001 | 0.092 | 1.002 |
| hex: canterbury/asyoulik.txt | 250360 | 43093.3 ± 0.1% | 1.002 | 0.089 | 1.001 | 0.591 | 1.000 | 0.999 | 1.000 | 1.001 | 0.999 | 0.095 | 1.001 |
| hex: canterbury/cp.html | 49208 | 42412.8 ± 0.4% | 1.007 | 0.091 | 1.003 | 0.595 | 1.002 | 0.997 | 1.002 | 1.007 | 1.006 | 0.098 | 1.001 |
| hex: canterbury/fields.c | 22302 | 42233.8 ± 0.2% | 0.999 | 0.091 | 0.999 | 0.597 | 0.999 | 0.987 | 1.000 | 1.002 | 1.009 | 0.098 | 1.001 |
| hex: canterbury/grammar.lsp | 7444 | 39033.7 ± 0.3% | 0.997 | 0.097 | 1.004 | 0.615 | 1.004 | 0.980 | 1.003 | 1.025 | 1.029 | 0.103 | 1.007 |
| hex: canterbury/kennedy.xls | 524290 | 43665.4 ± 0.3% | 1.002 | 0.088 | 0.999 | 0.589 | 1.001 | 1.000 | 1.001 | 0.999 | 1.000 | 0.093 | 1.000 |
| hex: canterbury/lcet10.txt | 524290 | 43705.2 ± 0.3% | 1.001 | 0.088 | 0.998 | 0.589 | 1.000 | 1.000 | 0.999 | 1.001 | 1.000 | 0.091 | 1.000 |
| hex: canterbury/plrabn12.txt | 524290 | 42728.2 ± 7.8% | 1.002 | 0.090 | 1.002 | 0.602 | 1.002 | 1.001 | 1.003 | 1.002 | 1.002 | 0.094 | 1.003 |
| hex: canterbury/ptt5 | 524290 | 43819.4 ± 0.3% | 1.001 | 0.088 | 1.001 | 0.589 | 1.000 | 0.999 | 1.000 | 1.000 | 1.000 | 0.094 | 1.001 |
| hex: canterbury/sum | 76482 | 42731.4 ± 0.4% | 1.005 | 0.090 | 1.000 | 0.593 | 1.000 | 0.997 | 1.000 | 1.005 | 1.007 | 0.096 | 1.001 |
| hex: canterbury/xargs.1 | 8456 | 39701.5 ± 0.5% | 1.018 | 0.096 | 1.001 | 0.610 | 1.002 | 0.960 | 1.001 | 1.006 | 1.024 | 0.103 | 1.005 |
| hex: canterbury-large/E.coli | 524290 | 43786.0 ± 0.2% | 1.000 | 0.088 | 1.000 | 0.589 | 1.001 | 0.999 | 0.999 | 1.000 | 1.001 | 0.095 | 0.999 |
| hex: canterbury-large/bible.txt | 524290 | 43768.3 ± 4.0% | 1.002 | 0.088 | 1.001 | 0.589 | 1.001 | 0.998 | 1.000 | 1.001 | 1.001 | 0.093 | 1.002 |
| hex: canterbury-large/world192.txt | 524290 | 43668.1 ± 0.1% | 1.002 | 0.088 | 1.000 | 0.590 | 1.000 | 0.999 | 1.000 | 1.001 | 0.999 | 0.094 | 1.000 |
| hex: http/html-1kx1024 | 2099200 | 20998.1 ± 1.0% | 1.006 | 0.175 | 1.004 | 0.935 | 1.004 | 0.992 | 1.004 | 1.008 | 1.008 | 0.183 | 1.005 |
| hex: http/html-16kx64 | 2097280 | 21767.4 ± 0.3% | 1.000 | 0.174 | 1.003 | 0.977 | 1.002 | 1.002 | 1.002 | 1.001 | 1.002 | 0.189 | 1.002 |
| hex: http/html-1m | 524290 | 43759.5 ± 0.1% | 1.000 | 0.088 | 1.000 | 0.590 | 1.000 | 1.000 | 0.999 | 1.001 | 1.001 | 0.094 | 1.001 |
| hex: http/json-1kx1024 | 2099200 | 20842.0 ± 0.7% | 1.007 | 0.177 | 1.003 | 0.937 | 1.003 | 0.993 | 1.003 | 1.007 | 1.006 | 0.184 | 1.004 |
| hex: http/json-16kx64 | 2097280 | 21727.7 ± 0.6% | 1.001 | 0.175 | 1.002 | 0.975 | 1.003 | 1.001 | 0.996 | 0.999 | 0.997 | 0.189 | 1.001 |
| hex: http/json-1m | 524290 | 43416.0 ± 0.3% | 1.002 | 0.089 | 1.000 | 0.595 | 1.000 | 0.999 | 1.000 | 1.000 | 1.001 | 0.092 | 1.001 |
| hex: http/js-1kx1024 | 2099200 | 20596.5 ± 3.8% | 1.006 | 0.179 | 1.004 | 0.944 | 1.002 | 0.996 | 1.004 | 1.006 | 1.008 | 0.186 | 1.004 |
| hex: http/js-16kx64 | 2097280 | 21531.1 ± 0.3% | 1.001 | 0.176 | 1.001 | 0.981 | 1.001 | 0.999 | 1.002 | 1.001 | 1.002 | 0.191 | 1.001 |
| hex: http/js-1m | 524290 | 43662.7 ± 0.2% | 1.003 | 0.088 | 1.001 | 0.591 | 1.002 | 1.001 | 1.002 | 1.002 | 1.001 | 0.094 | 1.001 |
| hex: http/css-1kx1024 | 2099200 | 20517.2 ± 0.8% | 1.003 | 0.179 | 1.003 | 0.946 | 1.002 | 0.992 | 1.003 | 1.003 | 1.006 | 0.187 | 1.003 |
| hex: http/css-16kx64 | 2097280 | 22112.3 ± 0.8% | 1.001 | 0.172 | 1.001 | 0.968 | 1.002 | 1.000 | 1.003 | 1.000 | 1.002 | 0.187 | 1.001 |
| hex: http/css-1m | 524290 | 43665.6 ± 0.2% | 1.001 | 0.088 | 1.000 | 0.591 | 1.000 | 0.999 | 1.000 | 1.001 | 1.000 | 0.091 | 1.000 |
| hex: shuffled/dickens-1m | 524290 | 43853.7 ± 0.1% | 1.001 | 0.088 | 1.000 | 0.589 | 1.000 | 0.999 | 1.000 | 1.000 | 1.000 | 0.092 | 1.000 |

## Losses

Each workload where a claim's path ran slower than the path it replaces by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding: J7 wide vectors off runs at 1.066 of all on.
- CLDR supplemental, 34 texts, decoding: J8 decoder fast path off runs at 1.067 of all on.
- CLDR supplemental, 34 texts, decoding: J12 decoder escape words off runs at 1.071 of all on.
- CLDR supplemental, 34 texts, decoding: J13 decoder escape blocks off runs at 1.067 of all on.
- qlog records, JSON text sequence, decoding: J5 UTF-8 vectors off runs at 1.062 of all on.
- qlog records, JSON text sequence, decoding: J7 wide vectors off runs at 1.061 of all on.
- qlog records, JSON text sequence, decoding: J8 decoder fast path off runs at 1.068 of all on.
- qlog records, JSON text sequence, decoding: J12 decoder escape words off runs at 1.067 of all on.
- qlog records, JSON text sequence, decoding: J13 decoder escape blocks off runs at 1.067 of all on.
- messages: 50 nested objects, decoding: J5 UTF-8 vectors off runs at 1.089 of all on.
- messages: 50 nested objects, decoding: J7 wide vectors off runs at 1.086 of all on.
- messages: 50 nested objects, decoding: J8 decoder fast path off runs at 1.090 of all on.
- messages: 50 nested objects, decoding: J12 decoder escape words off runs at 1.097 of all on.
- messages: 50 nested objects, decoding: J13 decoder escape blocks off runs at 1.089 of all on.
- string: silesia/dickens, decoding: J7 wide vectors off runs at 1.095 of all on.
- string: silesia/dickens, decoding: J8 decoder fast path off runs at 1.097 of all on.
- string: silesia/dickens, decoding: J13 decoder escape blocks off runs at 1.110 of all on.
- string: silesia/samba, decoding: J7 wide vectors off runs at 1.068 of all on.
- string: silesia/samba, decoding: J8 decoder fast path off runs at 1.068 of all on.
- string: silesia/samba, decoding: J13 decoder escape blocks off runs at 1.069 of all on.
- string: canterbury/alice29.txt, decoding: J7 wide vectors off runs at 1.075 of all on.
- string: canterbury/alice29.txt, decoding: J8 decoder fast path off runs at 1.125 of all on.
- string: canterbury/alice29.txt, decoding: J13 decoder escape blocks off runs at 1.160 of all on.
- string: canterbury/asyoulik.txt, decoding: J7 wide vectors off runs at 1.130 of all on.
- string: canterbury/asyoulik.txt, decoding: J8 decoder fast path off runs at 1.122 of all on.
- string: canterbury/asyoulik.txt, decoding: J13 decoder escape blocks off runs at 1.134 of all on.
- string: canterbury/lcet10.txt, decoding: J7 wide vectors off runs at 1.097 of all on.
- string: canterbury/lcet10.txt, decoding: J8 decoder fast path off runs at 1.104 of all on.
- string: canterbury/lcet10.txt, decoding: J13 decoder escape blocks off runs at 1.112 of all on.

## UTF-8 validation against simdutf

stdx's `is_utf8`, the check the loops apply to every string's octets, run alone over each string workload's octets at the width the host's features pick (16 lanes on aarch64, AVX2's 32 or AVX-512's 64 on x86-64, decision 39), beside simdutf 9.3.3's `validate_utf8` in the same run; on a host with AVX-512, again with AVX2 alone. Each ratio is stdx's throughput over the other's. simdutf picks its kernel at run time. Before timing, every copy of the check and simdutf judged 20000 seeded buffers and each workload, whole and changed, alike.

| Workload | Octets | stdx, MB/s | simdutf, MB/s | stdx / simdutf | stdx with AVX2 alone, MB/s | stdx / stdx with AVX2 alone |
|---|---|---|---|---|---|---|
| string: silesia/dickens | 166668 | 168859.8 ± 0.3% | 122295.1 ± 0.3% | 1.381 | 100975.4 ± 0.1% | 1.672 |
| string: silesia/nci | 1048576 | 169853.0 ± 0.2% | 123057.2 ± 0.1% | 1.380 | 101561.1 ± 0.2% | 1.672 |
| string: silesia/reymont | 1048576 | 169946.5 ± 0.3% | 123010.3 ± 0.1% | 1.382 | 101545.1 ± 0.2% | 1.674 |
| string: silesia/samba | 65546 | 163875.5 ± 0.3% | 120540.9 ± 0.1% | 1.360 | 99667.9 ± 0.1% | 1.644 |
| string: silesia/webster | 1048576 | 168583.3 ± 0.8% | 123029.3 ± 0.1% | 1.370 | 102039.7 ± 0.1% | 1.652 |
| string: silesia/xml | 1048576 | 168541.8 ± 0.4% | 122828.8 ± 0.3% | 1.372 | 101419.3 ± 0.0% | 1.662 |
| string: canterbury/alice29.txt | 152089 | 168328.6 ± 0.2% | 122107.5 ± 0.3% | 1.379 | 100761.3 ± 0.1% | 1.671 |
| string: canterbury/asyoulik.txt | 125179 | 167921.0 ± 0.1% | 121876.0 ± 0.1% | 1.378 | 101121.0 ± 0.2% | 1.661 |
| string: canterbury/lcet10.txt | 426754 | 169916.1 ± 0.2% | 122894.7 ± 0.4% | 1.383 | 101708.4 ± 0.1% | 1.671 |
| string: canterbury/plrabn12.txt | 481861 | 169788.1 ± 0.9% | 122968.9 ± 0.1% | 1.381 | 101849.7 ± 0.1% | 1.667 |
| string: canterbury-large/E.coli | 1048576 | 169809.2 ± 0.3% | 123004.4 ± 0.2% | 1.381 | 101425.3 ± 0.2% | 1.674 |
| string: canterbury-large/bible.txt | 1048576 | 169895.0 ± 0.3% | 122889.2 ± 0.2% | 1.383 | 102380.7 ± 0.3% | 1.659 |
| string: canterbury-large/world192.txt | 1048576 | 166545.8 ± 0.3% | 121575.6 ± 0.5% | 1.370 | 100622.1 ± 0.1% | 1.655 |
| string: http/html-1m | 1048576 | 148505.5 ± 0.3% | 112476.2 ± 0.3% | 1.320 | 94263.3 ± 0.4% | 1.575 |
| string: http/json-1m | 1048576 | 122178.9 ± 0.6% | 106869.8 ± 0.1% | 1.143 | 82935.6 ± 1.0% | 1.473 |
| string: http/js-1m | 1048576 | 165774.6 ± 0.4% | 121710.8 ± 0.3% | 1.362 | 99235.0 ± 0.1% | 1.671 |
| string: http/css-1m | 1048576 | 168615.1 ± 0.3% | 122537.4 ± 0.1% | 1.376 | 100477.8 ± 0.1% | 1.678 |
| string: dickens as Cyrillic and CJK | 1847045 | 23704.1 ± 0.2% | 20736.1 ± 0.4% | 1.143 | 14861.9 ± 0.1% | 1.595 |

## Losses to simdutf

None.

## UTF-8 validation by the buffer's offset from a 64-octet line

| Buffer | Octets | Offset | stdx, MB/s | simdutf, MB/s | stdx / simdutf | stdx with AVX2 alone, MB/s | stdx / stdx with AVX2 alone |
|---|---|---|---|---|---|---|---|
| string: canterbury-large/bible.txt | 1048576 | 0 | 168468.1 ± 2.0% | 122628.3 ± 0.1% | 1.374 | 101667.9 ± 0.3% | 1.657 |
| string: canterbury-large/bible.txt | 1048576 | 1 | 169947.7 ± 0.2% | 122492.8 ± 0.1% | 1.387 | 101167.5 ± 0.2% | 1.680 |
| string: canterbury-large/bible.txt | 1048576 | 8 | 169275.3 ± 0.5% | 122534.1 ± 0.4% | 1.381 | 101125.9 ± 0.1% | 1.674 |
| string: canterbury-large/bible.txt | 1048576 | 16 | 169555.6 ± 0.2% | 122507.6 ± 0.4% | 1.384 | 101155.9 ± 0.2% | 1.676 |
| string: canterbury-large/bible.txt | 1048576 | 32 | 169614.9 ± 0.3% | 122518.1 ± 0.3% | 1.384 | 101165.9 ± 0.2% | 1.677 |
| string: canterbury-large/bible.txt | 1048576 | 48 | 169570.6 ± 0.7% | 122494.5 ± 0.3% | 1.384 | 101728.1 ± 0.2% | 1.667 |
| string: dickens as Cyrillic and CJK | 1048576 | 0 | 24366.6 ± 0.1% | 21767.3 ± 0.6% | 1.119 | 15382.9 ± 0.2% | 1.584 |
| string: dickens as Cyrillic and CJK | 1048576 | 1 | 24388.8 ± 0.1% | 21757.1 ± 0.3% | 1.121 | 15362.1 ± 0.1% | 1.588 |
| string: dickens as Cyrillic and CJK | 1048576 | 8 | 24368.8 ± 0.2% | 21768.3 ± 0.4% | 1.119 | 15345.0 ± 0.1% | 1.588 |
| string: dickens as Cyrillic and CJK | 1048576 | 16 | 24362.9 ± 0.1% | 21770.8 ± 0.6% | 1.119 | 15365.2 ± 0.3% | 1.586 |
| string: dickens as Cyrillic and CJK | 1048576 | 32 | 24424.9 ± 0.3% | 21768.4 ± 0.1% | 1.122 | 15381.1 ± 0.2% | 1.588 |
| string: dickens as Cyrillic and CJK | 1048576 | 48 | 24365.5 ± 0.1% | 21757.4 ± 0.2% | 1.120 | 15379.6 ± 0.2% | 1.584 |

## Messages against serde_json's typed code

stdx's encoder a token a call through `TextWriter`'s methods, a member's name and its value in one `member_*` call, beside serde_json 1.0.154 writing the same messages from Rust types, as code of the form serde's derive generates writes them. Octets are the ones written.

| Workload | Octets | TextWriter's methods, MB/s | serde_json typed, MB/s | stdx / serde_json typed |
|---|---|---|---|---|
| messages: 11 string members | 1025025 | 1265.5 ± 2.2% | 782.6 ± 0.7% | 1.617 |
| messages: 50 nested objects | 1121600 | 1718.4 ± 0.3% | 989.8 ± 0.8% | 1.736 |

## Against the baselines

stdx with every claim on, timed beside simdjson 5.1.1, yyjson 0.13.0, Zig 0.16.0's std.json, serde_json 1.0.154 and Go's encoding/json/jsontext in the same run. Each ratio is stdx's throughput over the baseline's; below 1, the baseline is faster. stdx is built for the architecture's baseline CPU in ReleaseSafe. Each baseline is built for the same CPU, the C, C++ and Zig ones in ReleaseFast (decision 75), and simdjson picks its kernel at run time. Decoding visits every value; encoding writes each text from its tokens.

## Decoding against the baselines

Octets are the text's. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1380.9 ± 0.4% | 1520.4 ± 1.0% | 1110.2 ± 0.3% | 392.8 ± 0.5% | 657.1 ± 0.2% | 367.4 ± 2.1% | 0.908 | 1.244 | 3.515 | 2.101 | 3.759 |
| qlog records, JSON text sequence | 1467503 | 1100.6 ± 0.9% | 1253.7 ± 1.2% | 1115.2 ± 0.3% | 332.1 ± 1.3% | 738.7 ± 0.3% | 319.1 ± 1.2% | 0.878 | 0.987 | 3.314 | 1.490 | 3.449 |
| messages: 11 string members | 1025025 | 1076.0 ± 0.6% | 2044.1 ± 0.8% | 767.7 ± 0.6% | 338.1 ± 0.6% | 500.3 ± 0.5% | 306.1 ± 1.8% | 0.526 | 1.402 | 3.183 | 2.151 | 3.515 |
| messages: 50 nested objects | 1121600 | 1344.4 ± 0.3% | 1746.3 ± 1.6% | 1449.2 ± 0.7% | 430.7 ± 0.8% | 907.9 ± 0.4% | 423.1 ± 0.2% | 0.770 | 0.928 | 3.122 | 1.481 | 3.177 |
| string: silesia/dickens | 172528 | 6713.5 ± 0.1% | 3429.7 ± 4.0% | 2823.2 ± 1.9% | 317.6 ± 0.8% | 3382.6 ± 0.8% | 573.9 ± 1.7% | 1.957 | 2.378 | 21.139 | 1.985 | 11.699 |
| string: silesia/nci | 1075110 | 5445.5 ± 0.3% | 3933.0 ± 0.3% | 2988.8 ± 2.6% | 654.1 ± 1.0% | 3678.5 ± 3.6% | 582.3 ± 1.2% | 1.385 | 1.822 | 8.326 | 1.480 | 9.352 |
| string: silesia/reymont | 1075159 | 3528.4 ± 2.5% | 3424.5 ± 1.6% | 2019.9 ± 0.4% | 341.9 ± 1.9% | 2096.5 ± 0.5% | 495.6 ± 2.6% | 1.030 | 1.747 | 10.321 | 1.683 | 7.120 |
| string: silesia/samba | 97582 | 3969.2 ± 3.5% | 3808.8 ± 0.2% | 3124.3 ± 0.3% | 328.3 ± 1.0% | 2059.3 ± 0.2% | 422.4 ± 1.4% | 1.042 | 1.270 | 12.089 | 1.927 | 9.398 |
| string: silesia/webster | 1098490 | 4440.8 ± 1.6% | 2446.3 ± 0.3% | 1751.4 ± 0.2% | 310.1 ± 0.4% | 2122.3 ± 0.2% | 469.6 ± 0.7% | 1.815 | 2.536 | 14.319 | 2.092 | 9.457 |
| string: silesia/xml | 1090118 | 6104.0 ± 0.3% | 5043.1 ± 0.3% | 2508.7 ± 0.8% | 511.1 ± 0.6% | 3328.8 ± 0.3% | 543.8 ± 1.6% | 1.210 | 2.433 | 11.943 | 1.834 | 11.225 |
| string: canterbury/alice29.txt | 159425 | 5789.7 ± 1.0% | 2794.1 ± 0.8% | 2860.1 ± 0.9% | 301.1 ± 0.3% | 3031.2 ± 1.5% | 518.5 ± 0.3% | 2.072 | 2.024 | 19.229 | 1.910 | 11.166 |
| string: canterbury/asyoulik.txt | 132198 | 4295.6 ± 0.7% | 2627.2 ± 4.0% | 2690.1 ± 0.6% | 305.6 ± 0.3% | 2438.3 ± 1.3% | 455.0 ± 2.0% | 1.635 | 1.597 | 14.055 | 1.762 | 9.441 |
| string: canterbury/lcet10.txt | 441884 | 6694.6 ± 1.0% | 3295.9 ± 0.3% | 2366.8 ± 0.5% | 347.5 ± 0.4% | 3016.4 ± 0.7% | 571.4 ± 0.6% | 2.031 | 2.828 | 19.264 | 2.219 | 11.715 |
| string: canterbury/plrabn12.txt | 503330 | 5464.4 ± 0.3% | 3174.4 ± 0.1% | 1861.9 ± 0.2% | 323.2 ± 0.3% | 2877.4 ± 0.4% | 534.4 ± 0.6% | 1.721 | 2.935 | 16.909 | 1.899 | 10.225 |
| string: canterbury-large/E.coli | 1048578 | 32174.3 ± 0.1% | 12993.5 ± 0.2% | 3399.2 ± 0.3% | 1285.3 ± 0.1% | 8948.1 ± 0.1% | 979.3 ± 2.1% | 2.476 | 9.465 | 25.032 | 3.596 | 32.855 |
| string: canterbury-large/bible.txt | 1055886 | 8551.4 ± 1.5% | 5243.9 ± 0.5% | 2825.9 ± 0.1% | 359.2 ± 0.7% | 3894.4 ± 0.5% | 633.9 ± 3.7% | 1.631 | 3.026 | 23.808 | 2.196 | 13.490 |
| string: canterbury-large/world192.txt | 1103121 | 4173.8 ± 0.4% | 2311.4 ± 0.2% | 1815.5 ± 0.3% | 328.9 ± 0.3% | 2197.6 ± 0.3% | 470.4 ± 2.4% | 1.806 | 2.299 | 12.692 | 1.899 | 8.872 |
| string: http/html-1m | 1058582 | 9205.4 ± 5.3% | 4761.0 ± 0.8% | 2739.2 ± 1.0% | 429.4 ± 0.4% | 3602.7 ± 1.3% | 599.6 ± 2.4% | 1.934 | 3.361 | 21.439 | 2.555 | 15.352 |
| string: http/json-1m | 1190272 | 3337.7 ± 0.9% | 1256.9 ± 0.4% | 2127.8 ± 0.3% | 470.3 ± 0.8% | 1369.1 ± 0.6% | 437.3 ± 3.2% | 2.655 | 1.569 | 7.097 | 2.438 | 7.633 |
| string: http/js-1m | 1144362 | 2871.1 ± 0.8% | 1610.9 ± 0.1% | 1336.5 ± 0.2% | 329.2 ± 0.5% | 1416.9 ± 0.3% | 378.9 ± 0.8% | 1.782 | 2.148 | 8.722 | 2.026 | 7.578 |
| string: http/css-1m | 1097820 | 3299.7 ± 0.5% | 2885.3 ± 1.3% | 2304.5 ± 0.4% | 458.8 ± 2.9% | 2117.0 ± 0.3% | 438.5 ± 1.7% | 1.144 | 1.432 | 7.192 | 1.559 | 7.525 |
| string: dickens as Cyrillic and CJK | 1883069 | 5830.4 ± 0.4% | 3143.6 ± 1.2% | 687.0 ± 0.6% | 371.7 ± 2.7% | 497.1 ± 0.6% | 166.0 ± 3.1% | 1.855 | 8.486 | 15.687 | 11.728 | 35.130 |
| string: dickens as Cyrillic and CJK, as \u escapes | 5075485 | 1199.6 ± 4.3% | 1243.8 ± 0.7% | 1104.0 ± 1.0% | 264.0 ± 0.9% | 469.4 ± 0.2% | 230.9 ± 3.9% | 0.964 | 1.087 | 4.544 | 2.555 | 5.196 |
| hex: silesia/dickens | 524290 | 45716.8 ± 2.4% | 15110.1 ± 0.3% | 3567.3 ± 0.4% | 478.1 ± 1.6% | 8953.8 ± 0.5% | 1138.0 ± 1.6% | 3.026 | 12.816 | 95.623 | 5.106 | 40.172 |
| hex: silesia/mozilla | 524290 | 46250.4 ± 1.7% | 15065.3 ± 1.0% | 3487.4 ± 1.0% | 428.5 ± 0.5% | 8907.6 ± 0.8% | 1137.5 ± 0.8% | 3.070 | 13.262 | 107.937 | 5.192 | 40.661 |
| hex: silesia/mr | 524290 | 45455.2 ± 0.3% | 15145.0 ± 0.1% | 3496.4 ± 0.3% | 649.4 ± 0.2% | 8945.8 ± 0.2% | 1136.4 ± 0.8% | 3.001 | 13.001 | 69.996 | 5.081 | 39.999 |
| hex: silesia/nci | 524290 | 45585.0 ± 0.2% | 15138.8 ± 0.4% | 3566.5 ± 0.4% | 762.1 ± 0.2% | 8966.2 ± 0.6% | 1138.8 ± 0.4% | 3.011 | 12.781 | 59.812 | 5.084 | 40.031 |
| hex: silesia/ooffice | 524290 | 46424.2 ± 2.5% | 15145.4 ± 0.3% | 3494.1 ± 1.4% | 343.0 ± 0.3% | 8943.0 ± 0.3% | 1136.7 ± 1.0% | 3.065 | 13.287 | 135.340 | 5.191 | 40.841 |
| hex: silesia/osdb | 524290 | 46065.6 ± 0.2% | 15146.0 ± 0.3% | 3501.1 ± 0.2% | 456.0 ± 0.8% | 8954.9 ± 4.9% | 1139.5 ± 0.6% | 3.041 | 13.158 | 101.031 | 5.144 | 40.427 |
| hex: silesia/reymont | 524290 | 46394.6 ± 2.0% | 15104.8 ± 3.0% | 3540.8 ± 0.1% | 494.8 ± 0.2% | 8962.9 ± 0.6% | 1139.0 ± 1.1% | 3.072 | 13.103 | 93.762 | 5.176 | 40.733 |
| hex: silesia/samba | 524290 | 46538.4 ± 0.4% | 15076.6 ± 1.5% | 3495.0 ± 0.4% | 364.2 ± 2.3% | 8949.4 ± 0.7% | 1142.3 ± 0.4% | 3.087 | 13.316 | 127.773 | 5.200 | 40.740 |
| hex: silesia/sao | 524290 | 43978.0 ± 0.2% | 15137.9 ± 0.4% | 3499.0 ± 3.1% | 279.5 ± 0.5% | 8952.5 ± 0.2% | 1140.9 ± 3.6% | 2.905 | 12.569 | 157.327 | 4.912 | 38.547 |
| hex: silesia/webster | 524290 | 45782.7 ± 0.2% | 15126.9 ± 3.1% | 3567.1 ± 0.2% | 451.8 ± 0.5% | 8969.7 ± 0.2% | 1140.7 ± 0.7% | 3.027 | 12.835 | 101.334 | 5.104 | 40.136 |
| hex: silesia/x-ray | 524290 | 45558.4 ± 2.2% | 15138.4 ± 1.0% | 3503.8 ± 2.1% | 425.9 ± 0.2% | 8951.5 ± 0.2% | 1138.3 ± 0.1% | 3.009 | 13.003 | 106.978 | 5.089 | 40.023 |
| hex: silesia/xml | 524290 | 47224.1 ± 0.2% | 15128.0 ± 0.6% | 3562.3 ± 0.2% | 707.9 ± 3.6% | 8966.4 ± 0.6% | 1139.3 ± 0.4% | 3.122 | 13.257 | 66.713 | 5.267 | 41.449 |
| hex: canterbury/alice29.txt | 304180 | 46236.6 ± 0.2% | 14227.7 ± 0.3% | 3564.8 ± 2.7% | 484.3 ± 0.3% | 8943.7 ± 0.3% | 1142.6 ± 1.2% | 3.250 | 12.970 | 95.468 | 5.170 | 40.465 |
| hex: canterbury/asyoulik.txt | 250360 | 45377.0 ± 0.7% | 15046.1 ± 2.5% | 3493.9 ± 0.5% | 470.0 ± 0.8% | 8932.5 ± 0.3% | 1143.2 ± 0.4% | 3.016 | 12.988 | 96.540 | 5.080 | 39.693 |
| hex: canterbury/cp.html | 49208 | 44777.5 ± 1.3% | 14318.9 ± 0.4% | 3554.4 ± 0.8% | 495.4 ± 1.5% | 9260.2 ± 3.8% | 1119.6 ± 1.1% | 3.127 | 12.598 | 90.387 | 4.835 | 39.994 |
| hex: canterbury/fields.c | 22302 | 50566.9 ± 1.1% | 17483.8 ± 4.6% | 3653.1 ± 0.8% | 523.6 ± 0.8% | 9235.9 ± 0.3% | 1090.2 ± 2.0% | 2.892 | 13.842 | 96.582 | 5.475 | 46.385 |
| hex: canterbury/grammar.lsp | 7444 | 44310.0 ± 1.6% | 17207.3 ± 0.4% | 3615.1 ± 0.4% | 695.9 ± 1.0% | 8984.7 ± 0.9% | 1046.5 ± 1.5% | 2.575 | 12.257 | 63.672 | 4.932 | 42.342 |
| hex: canterbury/kennedy.xls | 524290 | 45053.1 ± 1.7% | 15047.9 ± 0.4% | 3547.7 ± 0.8% | 751.7 ± 0.3% | 8930.2 ± 0.5% | 1096.7 ± 3.2% | 2.994 | 12.699 | 59.933 | 5.045 | 41.082 |
| hex: canterbury/lcet10.txt | 524290 | 47668.8 ± 2.3% | 15078.8 ± 1.2% | 3570.1 ± 1.1% | 483.7 ± 1.3% | 8911.3 ± 1.3% | 1087.1 ± 2.1% | 3.161 | 13.352 | 98.544 | 5.349 | 43.849 |
| hex: canterbury/plrabn12.txt | 524290 | 45099.7 ± 0.5% | 15033.1 ± 1.0% | 3546.2 ± 0.9% | 466.0 ± 0.8% | 8918.2 ± 0.5% | 1096.6 ± 1.3% | 3.000 | 12.718 | 96.788 | 5.057 | 41.126 |
| hex: canterbury/ptt5 | 524290 | 44878.0 ± 1.6% | 15037.9 ± 0.8% | 3471.7 ± 1.1% | 660.4 ± 0.6% | 8910.3 ± 0.4% | 1093.2 ± 1.7% | 2.984 | 12.927 | 67.956 | 5.037 | 41.052 |
| hex: canterbury/sum | 76482 | 45757.0 ± 1.3% | 15385.8 ± 1.0% | 3554.5 ± 0.7% | 571.1 ± 0.8% | 8883.7 ± 0.7% | 1105.1 ± 2.1% | 2.974 | 12.873 | 80.118 | 5.151 | 41.407 |
| hex: canterbury/xargs.1 | 8456 | 46281.8 ± 0.6% | 17410.9 ± 0.4% | 3567.7 ± 0.4% | 683.4 ± 3.3% | 9020.5 ± 0.5% | 1079.9 ± 2.1% | 2.658 | 12.972 | 67.722 | 5.131 | 42.856 |
| hex: canterbury-large/E.coli | 524290 | 47413.2 ± 0.3% | 15162.5 ± 0.1% | 3500.8 ± 0.4% | 963.7 ± 0.1% | 8957.4 ± 0.1% | 1104.4 ± 1.6% | 3.127 | 13.544 | 49.202 | 5.293 | 42.931 |
| hex: canterbury-large/bible.txt | 524290 | 45763.1 ± 0.3% | 15161.3 ± 0.3% | 3501.5 ± 0.1% | 503.4 ± 0.5% | 8956.6 ± 0.0% | 1109.3 ± 1.6% | 3.018 | 13.069 | 90.901 | 5.109 | 41.254 |
| hex: canterbury-large/world192.txt | 524290 | 45691.5 ± 0.6% | 15133.1 ± 2.8% | 3567.9 ± 0.3% | 463.7 ± 0.4% | 8974.5 ± 0.1% | 1112.0 ± 1.8% | 3.019 | 12.806 | 98.536 | 5.091 | 41.089 |
| hex: http/html-1kx1024 | 2099200 | 18148.9 ± 0.9% | 12093.3 ± 0.8% | 3197.3 ± 0.1% | 496.3 ± 0.3% | 7795.2 ± 1.6% | 978.3 ± 1.6% | 1.501 | 5.676 | 36.569 | 2.328 | 18.552 |
| hex: http/html-16kx64 | 2097280 | 34966.2 ± 0.5% | 13912.6 ± 0.2% | 3414.0 ± 0.4% | 501.8 ± 0.7% | 8701.6 ± 0.9% | 1077.8 ± 2.5% | 2.513 | 10.242 | 69.677 | 4.018 | 32.441 |
| hex: http/html-1m | 524290 | 46376.8 ± 0.8% | 15148.5 ± 0.3% | 3505.8 ± 0.5% | 502.3 ± 0.3% | 8957.0 ± 0.0% | 1131.7 ± 4.6% | 3.061 | 13.229 | 92.320 | 5.178 | 40.980 |
| hex: http/json-1kx1024 | 2099200 | 18216.2 ± 2.1% | 12435.1 ± 12.0% | 3196.5 ± 0.7% | 657.3 ± 1.0% | 7612.7 ± 2.2% | 966.0 ± 2.2% | 1.465 | 5.699 | 27.715 | 2.393 | 18.858 |
| hex: http/json-16kx64 | 2097280 | 36001.3 ± 0.7% | 14017.9 ± 1.0% | 3403.6 ± 1.6% | 669.0 ± 0.6% | 8638.6 ± 1.5% | 1077.5 ± 2.1% | 2.568 | 10.577 | 53.814 | 4.167 | 33.412 |
| hex: http/json-1m | 524290 | 48826.7 ± 3.4% | 15141.3 ± 0.8% | 3564.0 ± 0.3% | 699.4 ± 0.5% | 8957.7 ± 0.2% | 1135.1 ± 0.8% | 3.225 | 13.700 | 69.817 | 5.451 | 43.014 |
| hex: http/js-1kx1024 | 2099200 | 18179.1 ± 1.1% | 12366.0 ± 4.9% | 3174.5 ± 1.5% | 477.0 ± 0.4% | 7756.5 ± 2.4% | 971.3 ± 1.7% | 1.470 | 5.727 | 38.111 | 2.344 | 18.716 |
| hex: http/js-16kx64 | 2097280 | 35157.7 ± 0.2% | 14076.8 ± 0.3% | 3407.9 ± 0.5% | 482.7 ± 0.3% | 8591.6 ± 0.7% | 1076.8 ± 4.3% | 2.498 | 10.316 | 72.843 | 4.092 | 32.650 |
| hex: http/js-1m | 524290 | 46651.9 ± 0.8% | 15150.5 ± 0.2% | 3556.4 ± 0.4% | 498.1 ± 0.4% | 8970.6 ± 0.1% | 1135.3 ± 4.0% | 3.079 | 13.118 | 93.662 | 5.201 | 41.091 |
| hex: http/css-1kx1024 | 2099200 | 18298.7 ± 0.9% | 12356.2 ± 0.7% | 3194.7 ± 0.2% | 554.5 ± 0.7% | 7725.9 ± 2.5% | 976.3 ± 1.1% | 1.481 | 5.728 | 32.998 | 2.368 | 18.742 |
| hex: http/css-16kx64 | 2097280 | 34425.7 ± 0.3% | 14002.6 ± 0.4% | 3405.4 ± 1.5% | 561.8 ± 4.7% | 8349.3 ± 1.5% | 1085.0 ± 2.2% | 2.459 | 10.109 | 61.283 | 4.123 | 31.729 |
| hex: http/css-1m | 524290 | 45555.0 ± 0.3% | 15158.7 ± 0.1% | 3570.8 ± 0.5% | 545.5 ± 0.4% | 8969.9 ± 0.2% | 1117.8 ± 6.2% | 3.005 | 12.758 | 83.518 | 5.079 | 40.753 |
| hex: shuffled/dickens-1m | 524290 | 44730.6 ± 0.3% | 15165.2 ± 0.2% | 3494.3 ± 0.2% | 479.2 ± 1.0% | 8952.4 ± 0.2% | 1132.9 ± 2.1% | 2.950 | 12.801 | 93.342 | 4.997 | 39.482 |

## Encoding against the baselines

Octets are the ones stdx writes. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1769.3 ± 0.8% | 1479.9 ± 1.4% | 1024.6 ± 2.9% | 460.8 ± 3.1% | 436.1 ± 1.4% | 502.1 ± 0.8% | 1.195 | 1.727 | 3.840 | 4.057 | 3.523 |
| qlog records, JSON text sequence | 1467503 | 1653.8 ± 2.5% | 1224.7 ± 2.6% | 943.8 ± 0.4% | 422.0 ± 0.4% | 529.3 ± 3.8% | 354.7 ± 1.3% | 1.350 | 1.752 | 3.919 | 3.125 | 4.662 |
| messages: 11 string members | 1025025 | 1344.7 ± 2.3% | 1104.0 ± 0.6% | 750.1 ± 0.5% | 380.5 ± 0.9% | 417.8 ± 0.4% | 434.5 ± 0.6% | 1.218 | 1.793 | 3.534 | 3.219 | 3.095 |
| messages: 50 nested objects | 1121600 | 2011.2 ± 0.6% | 1894.4 ± 1.0% | 1336.2 ± 1.6% | 598.3 ± 1.0% | 615.7 ± 1.1% | 514.3 ± 0.6% | 1.062 | 1.505 | 3.362 | 3.267 | 3.911 |
| string: silesia/dickens | 172528 | 13146.6 ± 0.6% | 3964.5 ± 1.2% | 3101.7 ± 1.6% | 334.1 ± 1.3% | 1717.0 ± 1.9% | 1186.2 ± 1.3% | 3.316 | 4.238 | 39.348 | 7.657 | 11.083 |
| string: silesia/nci | 1075110 | 11305.9 ± 0.5% | 4748.4 ± 0.4% | 3143.4 ± 0.4% | 909.6 ± 0.8% | 1924.0 ± 4.3% | 1208.3 ± 0.5% | 2.381 | 3.597 | 12.429 | 5.876 | 9.357 |
| string: silesia/reymont | 1075159 | 5331.6 ± 0.9% | 1868.4 ± 1.2% | 2006.2 ± 0.5% | 380.0 ± 1.2% | 1431.0 ± 0.3% | 1045.2 ± 0.4% | 2.854 | 2.658 | 14.032 | 3.726 | 5.101 |
| string: silesia/samba | 97582 | 6323.7 ± 0.3% | 2721.7 ± 0.3% | 4096.3 ± 0.2% | 349.6 ± 0.6% | 1335.6 ± 0.4% | 1169.2 ± 2.7% | 2.323 | 1.544 | 18.087 | 4.735 | 5.409 |
| string: silesia/webster | 1098490 | 6893.8 ± 0.4% | 1988.6 ± 0.6% | 1871.8 ± 3.0% | 349.6 ± 0.3% | 1399.0 ± 1.2% | 601.7 ± 1.6% | 3.467 | 3.683 | 19.720 | 4.928 | 11.458 |
| string: silesia/xml | 1090118 | 10346.9 ± 0.8% | 3186.9 ± 2.3% | 2633.2 ± 0.9% | 604.2 ± 1.3% | 1957.0 ± 1.1% | 955.4 ± 1.2% | 3.247 | 3.929 | 17.124 | 5.287 | 10.830 |
| string: canterbury/alice29.txt | 159425 | 12716.1 ± 1.7% | 2909.9 ± 1.4% | 3164.3 ± 0.8% | 318.1 ± 0.5% | 1555.3 ± 1.3% | 1094.8 ± 0.8% | 4.370 | 4.019 | 39.972 | 8.176 | 11.615 |
| string: canterbury/asyoulik.txt | 132198 | 10360.9 ± 2.5% | 2118.3 ± 1.7% | 3145.8 ± 0.6% | 318.4 ± 0.7% | 1374.7 ± 1.9% | 961.1 ± 0.8% | 4.891 | 3.294 | 32.536 | 7.537 | 10.781 |
| string: canterbury/lcet10.txt | 441884 | 12036.3 ± 0.9% | 3101.7 ± 0.5% | 2654.9 ± 0.6% | 369.0 ± 3.2% | 1677.3 ± 1.4% | 1200.2 ± 0.7% | 3.881 | 4.534 | 32.619 | 7.176 | 10.029 |
| string: canterbury/plrabn12.txt | 503330 | 8199.4 ± 1.8% | 2327.6 ± 0.7% | 2173.6 ± 1.4% | 349.0 ± 1.4% | 1648.2 ± 1.4% | 1121.6 ± 2.4% | 3.523 | 3.772 | 23.493 | 4.975 | 7.311 |
| string: canterbury-large/E.coli | 1048578 | 31275.3 ± 1.0% | 16204.5 ± 2.2% | 3466.7 ± 0.8% | 1700.3 ± 0.5% | 3161.3 ± 0.9% | 1419.5 ± 0.8% | 1.930 | 9.022 | 18.394 | 9.893 | 22.032 |
| string: canterbury-large/bible.txt | 1055886 | 9320.6 ± 0.6% | 4896.0 ± 1.9% | 3034.1 ± 0.9% | 404.6 ± 1.2% | 2147.2 ± 0.7% | 1489.4 ± 0.6% | 1.904 | 3.072 | 23.036 | 4.341 | 6.258 |
| string: canterbury-large/world192.txt | 1103121 | 6593.4 ± 1.4% | 1743.0 ± 1.2% | 2004.2 ± 0.9% | 347.9 ± 0.8% | 1379.2 ± 0.7% | 959.3 ± 1.0% | 3.783 | 3.290 | 18.950 | 4.781 | 6.873 |
| string: http/html-1m | 1058582 | 10093.7 ± 0.7% | 4396.8 ± 0.9% | 2919.6 ± 0.4% | 418.6 ± 2.7% | 2165.1 ± 0.5% | 846.4 ± 1.5% | 2.296 | 3.457 | 24.111 | 4.662 | 11.925 |
| string: http/json-1m | 1190272 | 8584.0 ± 0.7% | 1587.7 ± 0.3% | 1966.8 ± 0.5% | 556.4 ± 0.7% | 1186.8 ± 1.2% | 845.3 ± 1.8% | 5.407 | 4.365 | 15.429 | 7.233 | 10.156 |
| string: http/js-1m | 1144362 | 6509.8 ± 0.4% | 1122.3 ± 0.3% | 1529.9 ± 0.7% | 331.1 ± 0.5% | 1110.6 ± 1.2% | 757.0 ± 2.5% | 5.800 | 4.255 | 19.661 | 5.861 | 8.600 |
| string: http/css-1m | 1097820 | 9059.8 ± 0.9% | 1488.0 ± 0.2% | 2366.9 ± 0.8% | 508.2 ± 0.6% | 1274.4 ± 0.8% | 882.7 ± 3.0% | 6.089 | 3.828 | 17.826 | 7.109 | 10.263 |
| string: dickens as Cyrillic and CJK | 1883069 | 5496.4 ± 0.5% | 3651.8 ± 0.5% | 502.1 ± 0.4% | 247.1 ± 0.3% | 453.0 ± 0.3% | 357.4 ± 0.5% | 1.505 | 10.947 | 22.246 | 12.133 | 15.380 |
| hex: silesia/dickens | 524290 | 43511.1 ± 0.8% | 2580.5 ± 0.5% | 1507.9 ± 0.3% | 460.5 ± 0.7% | 1473.7 ± 5.8% | 1064.2 ± 0.4% | 16.861 | 28.855 | 94.479 | 29.525 | 40.887 |
| hex: silesia/mozilla | 524290 | 43634.6 ± 0.8% | 2581.9 ± 0.4% | 1509.5 ± 0.6% | 385.0 ± 1.5% | 1561.3 ± 3.9% | 1067.8 ± 0.3% | 16.900 | 28.906 | 113.327 | 27.947 | 40.864 |
| hex: silesia/mr | 524290 | 43607.8 ± 0.2% | 2573.0 ± 0.7% | 1504.9 ± 5.2% | 594.9 ± 2.3% | 1548.3 ± 0.4% | 1067.3 ± 0.4% | 16.948 | 28.977 | 73.306 | 28.166 | 40.859 |
| hex: silesia/nci | 524290 | 43751.9 ± 0.3% | 2380.7 ± 8.7% | 1508.6 ± 0.2% | 755.7 ± 0.3% | 1556.4 ± 0.3% | 1065.7 ± 0.3% | 18.378 | 29.002 | 57.893 | 28.112 | 41.054 |
| hex: silesia/ooffice | 524290 | 43359.7 ± 1.9% | 2594.9 ± 0.2% | 1516.7 ± 0.3% | 322.4 ± 1.4% | 1552.0 ± 0.2% | 1067.5 ± 0.7% | 16.710 | 28.589 | 134.492 | 27.939 | 40.616 |
| hex: silesia/osdb | 524290 | 43811.2 ± 0.1% | 2597.7 ± 0.1% | 1516.8 ± 0.2% | 429.7 ± 0.8% | 1568.4 ± 0.3% | 1067.7 ± 1.0% | 16.866 | 28.884 | 101.946 | 27.934 | 41.034 |
| hex: silesia/reymont | 524290 | 43613.1 ± 0.1% | 2594.0 ± 0.2% | 1512.8 ± 0.3% | 485.4 ± 0.2% | 1570.4 ± 0.1% | 1069.6 ± 0.2% | 16.813 | 28.829 | 89.848 | 27.772 | 40.776 |
| hex: silesia/samba | 524290 | 43632.2 ± 0.2% | 2598.2 ± 0.2% | 1516.8 ± 0.1% | 337.9 ± 0.5% | 1570.5 ± 0.1% | 1068.7 ± 0.1% | 16.793 | 28.767 | 129.138 | 27.783 | 40.827 |
| hex: silesia/sao | 524290 | 43749.4 ± 0.1% | 2594.3 ± 0.2% | 1516.7 ± 0.4% | 268.9 ± 2.8% | 1574.9 ± 0.2% | 1070.2 ± 0.5% | 16.864 | 28.846 | 162.691 | 27.778 | 40.880 |
| hex: silesia/webster | 524290 | 44031.9 ± 0.0% | 2597.5 ± 0.1% | 1516.2 ± 0.1% | 435.8 ± 0.2% | 1565.0 ± 0.3% | 1068.3 ± 0.1% | 16.952 | 29.040 | 101.029 | 28.136 | 41.216 |
| hex: silesia/x-ray | 524290 | 43756.7 ± 0.1% | 2596.9 ± 1.0% | 1516.0 ± 0.9% | 423.7 ± 0.4% | 1572.3 ± 0.1% | 1069.3 ± 5.7% | 16.850 | 28.864 | 103.261 | 27.830 | 40.922 |
| hex: silesia/xml | 524290 | 43442.7 ± 0.2% | 2595.3 ± 0.3% | 1516.7 ± 0.2% | 690.9 ± 0.7% | 1570.2 ± 0.1% | 1066.9 ± 0.0% | 16.739 | 28.643 | 62.878 | 27.666 | 40.718 |
| hex: canterbury/alice29.txt | 304180 | 43656.9 ± 0.1% | 2611.9 ± 0.4% | 1534.2 ± 0.4% | 469.6 ± 2.6% | 1589.1 ± 9.6% | 1089.9 ± 0.2% | 16.715 | 28.455 | 92.970 | 27.473 | 40.057 |
| hex: canterbury/asyoulik.txt | 250360 | 43093.3 ± 0.1% | 2615.1 ± 0.2% | 1547.3 ± 0.1% | 458.4 ± 0.2% | 1589.8 ± 0.0% | 1088.9 ± 0.3% | 16.479 | 27.851 | 94.016 | 27.106 | 39.575 |
| hex: canterbury/cp.html | 49208 | 42412.8 ± 0.4% | 2595.8 ± 0.3% | 1538.3 ± 0.3% | 481.3 ± 1.4% | 1589.7 ± 0.2% | 1094.0 ± 0.8% | 16.339 | 27.572 | 88.119 | 26.680 | 38.768 |
| hex: canterbury/fields.c | 22302 | 42233.8 ± 0.2% | 2644.2 ± 7.1% | 1551.4 ± 0.2% | 599.8 ± 0.3% | 1603.9 ± 8.4% | 1101.5 ± 0.2% | 15.972 | 27.223 | 70.413 | 26.331 | 38.344 |
| hex: canterbury/grammar.lsp | 7444 | 39033.7 ± 0.3% | 2672.5 ± 0.2% | 1563.8 ± 0.2% | 815.0 ± 0.3% | 1603.1 ± 0.2% | 1109.7 ± 0.3% | 14.606 | 24.961 | 47.896 | 24.349 | 35.176 |
| hex: canterbury/kennedy.xls | 524290 | 43665.4 ± 0.3% | 2579.1 ± 0.5% | 1510.3 ± 0.9% | 788.9 ± 0.5% | 1565.7 ± 0.2% | 1066.6 ± 0.8% | 16.931 | 28.912 | 55.348 | 27.888 | 40.940 |
| hex: canterbury/lcet10.txt | 524290 | 43705.2 ± 0.3% | 2592.9 ± 0.2% | 1514.8 ± 0.4% | 469.1 ± 0.2% | 1565.8 ± 0.5% | 1067.5 ± 0.9% | 16.856 | 28.851 | 93.169 | 27.912 | 40.943 |
| hex: canterbury/plrabn12.txt | 524290 | 42728.2 ± 7.8% | 2597.7 ± 0.3% | 1514.5 ± 5.1% | 455.1 ± 0.1% | 1575.6 ± 0.5% | 1069.2 ± 0.4% | 16.448 | 28.212 | 93.890 | 27.119 | 39.962 |
| hex: canterbury/ptt5 | 524290 | 43819.4 ± 0.3% | 2409.7 ± 9.0% | 1509.1 ± 1.3% | 596.0 ± 1.2% | 1558.8 ± 0.2% | 1069.0 ± 0.6% | 18.185 | 29.037 | 73.517 | 28.111 | 40.990 |
| hex: canterbury/sum | 76482 | 42731.4 ± 0.4% | 2591.2 ± 0.1% | 1527.8 ± 0.3% | 560.9 ± 3.6% | 1581.4 ± 0.3% | 1090.3 ± 0.8% | 16.491 | 27.970 | 76.186 | 27.022 | 39.193 |
| hex: canterbury/xargs.1 | 8456 | 39701.5 ± 0.5% | 2673.8 ± 0.4% | 1566.6 ± 0.4% | 840.2 ± 0.3% | 1605.5 ± 2.2% | 1114.8 ± 3.8% | 14.848 | 25.342 | 47.252 | 24.728 | 35.614 |
| hex: canterbury-large/E.coli | 524290 | 43786.0 ± 0.2% | 2585.8 ± 0.2% | 1509.2 ± 0.2% | 816.5 ± 0.1% | 1566.1 ± 0.1% | 1069.4 ± 0.2% | 16.933 | 29.013 | 53.628 | 27.959 | 40.946 |
| hex: canterbury-large/bible.txt | 524290 | 43768.3 ± 4.0% | 2596.8 ± 0.2% | 1514.3 ± 0.2% | 483.3 ± 0.3% | 1570.6 ± 0.4% | 1068.2 ± 1.9% | 16.855 | 28.904 | 90.561 | 27.867 | 40.972 |
| hex: canterbury-large/world192.txt | 524290 | 43668.1 ± 0.1% | 2590.4 ± 0.6% | 1513.5 ± 0.3% | 459.7 ± 0.2% | 1567.1 ± 5.8% | 1068.2 ± 0.2% | 16.858 | 28.852 | 94.985 | 27.865 | 40.879 |
| hex: http/html-1kx1024 | 2099200 | 20998.1 ± 1.0% | 2320.5 ± 1.8% | 1470.9 ± 0.5% | 501.3 ± 4.3% | 1486.2 ± 1.1% | 1079.5 ± 0.1% | 9.049 | 14.276 | 41.885 | 14.129 | 19.451 |
| hex: http/html-16kx64 | 2097280 | 21767.4 ± 0.3% | 2232.5 ± 0.1% | 1461.8 ± 0.1% | 505.0 ± 0.2% | 1448.0 ± 0.0% | 1088.7 ± 0.3% | 9.750 | 14.891 | 43.106 | 15.033 | 19.993 |
| hex: http/html-1m | 524290 | 43759.5 ± 0.1% | 2594.1 ± 0.2% | 1515.5 ± 0.2% | 492.2 ± 0.4% | 1572.6 ± 0.2% | 1066.6 ± 0.2% | 16.869 | 28.874 | 88.912 | 27.827 | 41.025 |
| hex: http/json-1kx1024 | 2099200 | 20842.0 ± 0.7% | 2318.4 ± 1.4% | 1473.2 ± 0.3% | 697.5 ± 0.1% | 1484.5 ± 0.3% | 1079.9 ± 0.2% | 8.990 | 14.148 | 29.880 | 14.039 | 19.299 |
| hex: http/json-16kx64 | 2097280 | 21727.7 ± 0.6% | 2227.1 ± 0.2% | 1459.4 ± 0.1% | 706.7 ± 0.2% | 1445.1 ± 0.1% | 1087.7 ± 0.2% | 9.756 | 14.888 | 30.747 | 15.035 | 19.976 |
| hex: http/json-1m | 524290 | 43416.0 ± 0.3% | 2586.9 ± 0.5% | 1510.5 ± 0.3% | 727.4 ± 0.5% | 1528.8 ± 6.1% | 1068.6 ± 0.9% | 16.783 | 28.743 | 59.690 | 28.399 | 40.630 |
| hex: http/js-1kx1024 | 2099200 | 20596.5 ± 3.8% | 2326.5 ± 1.5% | 1474.6 ± 0.4% | 491.0 ± 0.7% | 1489.2 ± 1.4% | 1079.9 ± 0.4% | 8.853 | 13.967 | 41.951 | 13.830 | 19.072 |
| hex: http/js-16kx64 | 2097280 | 21531.1 ± 0.3% | 2228.7 ± 0.4% | 1461.3 ± 0.1% | 493.1 ± 0.1% | 1447.6 ± 5.0% | 1085.5 ± 0.3% | 9.661 | 14.734 | 43.667 | 14.874 | 19.835 |
| hex: http/js-1m | 524290 | 43662.7 ± 0.2% | 2580.3 ± 0.1% | 1517.6 ± 5.6% | 505.4 ± 2.2% | 1566.1 ± 6.1% | 1068.8 ± 0.2% | 16.922 | 28.771 | 86.395 | 27.879 | 40.854 |
| hex: http/css-1kx1024 | 2099200 | 20517.2 ± 0.8% | 2301.6 ± 1.9% | 1476.2 ± 2.9% | 558.0 ± 3.2% | 1483.3 ± 1.1% | 1080.3 ± 0.2% | 8.914 | 13.899 | 36.771 | 13.832 | 18.992 |
| hex: http/css-16kx64 | 2097280 | 22112.3 ± 0.8% | 2231.0 ± 1.0% | 1461.5 ± 0.1% | 565.0 ± 0.1% | 1448.3 ± 0.1% | 1086.8 ± 0.4% | 9.912 | 15.130 | 39.137 | 15.268 | 20.347 |
| hex: http/css-1m | 524290 | 43665.6 ± 0.2% | 2596.1 ± 0.2% | 1515.8 ± 0.1% | 534.7 ± 0.2% | 1531.3 ± 0.1% | 1069.5 ± 0.2% | 16.820 | 28.807 | 81.667 | 28.515 | 40.830 |
| hex: shuffled/dickens-1m | 524290 | 43853.7 ± 0.1% | 2590.6 ± 0.2% | 1510.4 ± 0.1% | 463.3 ± 0.2% | 1564.4 ± 0.1% | 1069.3 ± 0.2% | 16.928 | 29.035 | 94.646 | 28.032 | 41.013 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1814.8 ± 4.4% | 1479.9 ± 1.4% | 1024.6 ± 2.9% | 460.8 ± 3.1% | 436.1 ± 1.4% | 502.1 ± 0.8% | 1.226 | 1.771 | 3.939 | 4.161 | 3.614 |
| qlog records, JSON text sequence | 1467503 | 1716.7 ± 0.3% | 1224.7 ± 2.6% | 943.8 ± 0.4% | 422.0 ± 0.4% | 529.3 ± 3.8% | 354.7 ± 1.3% | 1.402 | 1.819 | 4.068 | 3.244 | 4.840 |
| messages: 11 string members | 1025025 | 1340.2 ± 0.4% | 1104.0 ± 0.6% | 750.1 ± 0.5% | 380.5 ± 0.9% | 417.8 ± 0.4% | 434.5 ± 0.6% | 1.214 | 1.787 | 3.523 | 3.208 | 3.084 |
| messages: 50 nested objects | 1121600 | 2023.6 ± 0.4% | 1894.4 ± 1.0% | 1336.2 ± 1.6% | 598.3 ± 1.0% | 615.7 ± 1.1% | 514.3 ± 0.6% | 1.068 | 1.514 | 3.382 | 3.287 | 3.935 |
| string: silesia/dickens | 172528 | 13472.8 ± 1.4% | 3964.5 ± 1.2% | 3101.7 ± 1.6% | 334.1 ± 1.3% | 1717.0 ± 1.9% | 1186.2 ± 1.3% | 3.398 | 4.344 | 40.324 | 7.847 | 11.358 |
| string: silesia/nci | 1075110 | 11782.6 ± 0.3% | 4748.4 ± 0.4% | 3143.4 ± 0.4% | 909.6 ± 0.8% | 1924.0 ± 4.3% | 1208.3 ± 0.5% | 2.481 | 3.748 | 12.953 | 6.124 | 9.751 |
| string: silesia/reymont | 1075159 | 5458.7 ± 1.1% | 1868.4 ± 1.2% | 2006.2 ± 0.5% | 380.0 ± 1.2% | 1431.0 ± 0.3% | 1045.2 ± 0.4% | 2.922 | 2.721 | 14.366 | 3.815 | 5.223 |
| string: silesia/samba | 97582 | 7374.4 ± 0.9% | 2721.7 ± 0.3% | 4096.3 ± 0.2% | 349.6 ± 0.6% | 1335.6 ± 0.4% | 1169.2 ± 2.7% | 2.710 | 1.800 | 21.092 | 5.521 | 6.307 |
| string: silesia/webster | 1098490 | 6989.0 ± 0.6% | 1988.6 ± 0.6% | 1871.8 ± 3.0% | 349.6 ± 0.3% | 1399.0 ± 1.2% | 601.7 ± 1.6% | 3.515 | 3.734 | 19.992 | 4.996 | 11.616 |
| string: silesia/xml | 1090118 | 11110.9 ± 2.9% | 3186.9 ± 2.3% | 2633.2 ± 0.9% | 604.2 ± 1.3% | 1957.0 ± 1.1% | 955.4 ± 1.2% | 3.486 | 4.220 | 18.388 | 5.678 | 11.630 |
| string: canterbury/alice29.txt | 159425 | 13425.1 ± 0.5% | 2909.9 ± 1.4% | 3164.3 ± 0.8% | 318.1 ± 0.5% | 1555.3 ± 1.3% | 1094.8 ± 0.8% | 4.614 | 4.243 | 42.201 | 8.632 | 12.262 |
| string: canterbury/asyoulik.txt | 132198 | 11271.4 ± 0.8% | 2118.3 ± 1.7% | 3145.8 ± 0.6% | 318.4 ± 0.7% | 1374.7 ± 1.9% | 961.1 ± 0.8% | 5.321 | 3.583 | 35.395 | 8.199 | 11.728 |
| string: canterbury/lcet10.txt | 441884 | 12653.9 ± 0.8% | 3101.7 ± 0.5% | 2654.9 ± 0.6% | 369.0 ± 3.2% | 1677.3 ± 1.4% | 1200.2 ± 0.7% | 4.080 | 4.766 | 34.293 | 7.544 | 10.543 |
| string: canterbury/plrabn12.txt | 503330 | 8962.1 ± 4.9% | 2327.6 ± 0.7% | 2173.6 ± 1.4% | 349.0 ± 1.4% | 1648.2 ± 1.4% | 1121.6 ± 2.4% | 3.850 | 4.123 | 25.679 | 5.437 | 7.991 |
| string: canterbury-large/E.coli | 1048578 | 31330.1 ± 0.9% | 16204.5 ± 2.2% | 3466.7 ± 0.8% | 1700.3 ± 0.5% | 3161.3 ± 0.9% | 1419.5 ± 0.8% | 1.933 | 9.038 | 18.426 | 9.911 | 22.071 |
| string: canterbury-large/bible.txt | 1055886 | 9842.9 ± 1.1% | 4896.0 ± 1.9% | 3034.1 ± 0.9% | 404.6 ± 1.2% | 2147.2 ± 0.7% | 1489.4 ± 0.6% | 2.010 | 3.244 | 24.327 | 4.584 | 6.609 |
| string: canterbury-large/world192.txt | 1103121 | 6509.7 ± 1.1% | 1743.0 ± 1.2% | 2004.2 ± 0.9% | 347.9 ± 0.8% | 1379.2 ± 0.7% | 959.3 ± 1.0% | 3.735 | 3.248 | 18.709 | 4.720 | 6.786 |
| string: http/html-1m | 1058582 | 10184.0 ± 1.0% | 4396.8 ± 0.9% | 2919.6 ± 0.4% | 418.6 ± 2.7% | 2165.1 ± 0.5% | 846.4 ± 1.5% | 2.316 | 3.488 | 24.327 | 4.704 | 12.032 |
| string: http/json-1m | 1190272 | 8794.8 ± 0.7% | 1587.7 ± 0.3% | 1966.8 ± 0.5% | 556.4 ± 0.7% | 1186.8 ± 1.2% | 845.3 ± 1.8% | 5.539 | 4.472 | 15.808 | 7.410 | 10.405 |
| string: http/js-1m | 1144362 | 6614.1 ± 1.1% | 1122.3 ± 0.3% | 1529.9 ± 0.7% | 331.1 ± 0.5% | 1110.6 ± 1.2% | 757.0 ± 2.5% | 5.893 | 4.323 | 19.976 | 5.955 | 8.738 |
| string: http/css-1m | 1097820 | 9523.7 ± 0.6% | 1488.0 ± 0.2% | 2366.9 ± 0.8% | 508.2 ± 0.6% | 1274.4 ± 0.8% | 882.7 ± 3.0% | 6.400 | 4.024 | 18.739 | 7.473 | 10.789 |
| string: dickens as Cyrillic and CJK | 1883069 | 5756.3 ± 0.4% | 3651.8 ± 0.5% | 502.1 ± 0.4% | 247.1 ± 0.3% | 453.0 ± 0.3% | 357.4 ± 0.5% | 1.576 | 11.464 | 23.298 | 12.706 | 16.107 |
| hex: silesia/dickens | 524290 | 43424.2 ± 0.7% | 2580.5 ± 0.5% | 1507.9 ± 0.3% | 460.5 ± 0.7% | 1473.7 ± 5.8% | 1064.2 ± 0.4% | 16.828 | 28.797 | 94.290 | 29.466 | 40.805 |
| hex: silesia/mozilla | 524290 | 43749.7 ± 0.3% | 2581.9 ± 0.4% | 1509.5 ± 0.6% | 385.0 ± 1.5% | 1561.3 ± 3.9% | 1067.8 ± 0.3% | 16.945 | 28.982 | 113.626 | 28.021 | 40.972 |
| hex: silesia/mr | 524290 | 43702.0 ± 0.3% | 2573.0 ± 0.7% | 1504.9 ± 5.2% | 594.9 ± 2.3% | 1548.3 ± 0.4% | 1067.3 ± 0.4% | 16.985 | 29.040 | 73.465 | 28.226 | 40.947 |
| hex: silesia/nci | 524290 | 43710.4 ± 0.2% | 2380.7 ± 8.7% | 1508.6 ± 0.2% | 755.7 ± 0.3% | 1556.4 ± 0.3% | 1065.7 ± 0.3% | 18.361 | 28.975 | 57.838 | 28.085 | 41.015 |
| hex: silesia/ooffice | 524290 | 43557.1 ± 0.3% | 2594.9 ± 0.2% | 1516.7 ± 0.3% | 322.4 ± 1.4% | 1552.0 ± 0.2% | 1067.5 ± 0.7% | 16.786 | 28.719 | 135.104 | 28.066 | 40.801 |
| hex: silesia/osdb | 524290 | 43819.1 ± 0.5% | 2597.7 ± 0.1% | 1516.8 ± 0.2% | 429.7 ± 0.8% | 1568.4 ± 0.3% | 1067.7 ± 1.0% | 16.869 | 28.890 | 101.965 | 27.939 | 41.042 |
| hex: silesia/reymont | 524290 | 43645.1 ± 0.1% | 2594.0 ± 0.2% | 1512.8 ± 0.3% | 485.4 ± 0.2% | 1570.4 ± 0.1% | 1069.6 ± 0.2% | 16.826 | 28.850 | 89.914 | 27.792 | 40.806 |
| hex: silesia/samba | 524290 | 43612.6 ± 4.8% | 2598.2 ± 0.2% | 1516.8 ± 0.1% | 337.9 ± 0.5% | 1570.5 ± 0.1% | 1068.7 ± 0.1% | 16.786 | 28.754 | 129.080 | 27.771 | 40.809 |
| hex: silesia/sao | 524290 | 43724.4 ± 3.6% | 2594.3 ± 0.2% | 1516.7 ± 0.4% | 268.9 ± 2.8% | 1574.9 ± 0.2% | 1070.2 ± 0.5% | 16.854 | 28.829 | 162.598 | 27.763 | 40.856 |
| hex: silesia/webster | 524290 | 44016.2 ± 0.1% | 2597.5 ± 0.1% | 1516.2 ± 0.1% | 435.8 ± 0.2% | 1565.0 ± 0.3% | 1068.3 ± 0.1% | 16.946 | 29.030 | 100.993 | 28.126 | 41.202 |
| hex: silesia/x-ray | 524290 | 43777.9 ± 0.1% | 2596.9 ± 1.0% | 1516.0 ± 0.9% | 423.7 ± 0.4% | 1572.3 ± 0.1% | 1069.3 ± 5.7% | 16.858 | 28.878 | 103.311 | 27.844 | 40.941 |
| hex: silesia/xml | 524290 | 43434.2 ± 0.3% | 2595.3 ± 0.3% | 1516.7 ± 0.2% | 690.9 ± 0.7% | 1570.2 ± 0.1% | 1066.9 ± 0.0% | 16.736 | 28.637 | 62.866 | 27.661 | 40.710 |
| hex: canterbury/alice29.txt | 304180 | 43757.4 ± 0.0% | 2611.9 ± 0.4% | 1534.2 ± 0.4% | 469.6 ± 2.6% | 1589.1 ± 9.6% | 1089.9 ± 0.2% | 16.753 | 28.521 | 93.183 | 27.536 | 40.149 |
| hex: canterbury/asyoulik.txt | 250360 | 43124.3 ± 0.2% | 2615.1 ± 0.2% | 1547.3 ± 0.1% | 458.4 ± 0.2% | 1589.8 ± 0.0% | 1088.9 ± 0.3% | 16.490 | 27.871 | 94.084 | 27.126 | 39.603 |
| hex: canterbury/cp.html | 49208 | 42445.8 ± 0.2% | 2595.8 ± 0.3% | 1538.3 ± 0.3% | 481.3 ± 1.4% | 1589.7 ± 0.2% | 1094.0 ± 0.8% | 16.352 | 27.593 | 88.187 | 26.701 | 38.798 |
| hex: canterbury/fields.c | 22302 | 42297.0 ± 4.6% | 2644.2 ± 7.1% | 1551.4 ± 0.2% | 599.8 ± 0.3% | 1603.9 ± 8.4% | 1101.5 ± 0.2% | 15.996 | 27.263 | 70.518 | 26.371 | 38.401 |
| hex: canterbury/grammar.lsp | 7444 | 39316.8 ± 2.9% | 2672.5 ± 0.2% | 1563.8 ± 0.2% | 815.0 ± 0.3% | 1603.1 ± 0.2% | 1109.7 ± 0.3% | 14.711 | 25.142 | 48.243 | 24.526 | 35.432 |
| hex: canterbury/kennedy.xls | 524290 | 43672.7 ± 0.4% | 2579.1 ± 0.5% | 1510.3 ± 0.9% | 788.9 ± 0.5% | 1565.7 ± 0.2% | 1066.6 ± 0.8% | 16.933 | 28.917 | 55.357 | 27.893 | 40.947 |
| hex: canterbury/lcet10.txt | 524290 | 43712.5 ± 0.1% | 2592.9 ± 0.2% | 1514.8 ± 0.4% | 469.1 ± 0.2% | 1565.8 ± 0.5% | 1067.5 ± 0.9% | 16.859 | 28.856 | 93.185 | 27.917 | 40.950 |
| hex: canterbury/plrabn12.txt | 524290 | 42835.9 ± 0.3% | 2597.7 ± 0.3% | 1514.5 ± 5.1% | 455.1 ± 0.1% | 1575.6 ± 0.5% | 1069.2 ± 0.4% | 16.490 | 28.283 | 94.127 | 27.187 | 40.063 |
| hex: canterbury/ptt5 | 524290 | 43844.6 ± 0.1% | 2409.7 ± 9.0% | 1509.1 ± 1.3% | 596.0 ± 1.2% | 1558.8 ± 0.2% | 1069.0 ± 0.6% | 18.195 | 29.053 | 73.559 | 28.127 | 41.014 |
| hex: canterbury/sum | 76482 | 42768.6 ± 6.6% | 2591.2 ± 0.1% | 1527.8 ± 0.3% | 560.9 ± 3.6% | 1581.4 ± 0.3% | 1090.3 ± 0.8% | 16.506 | 27.994 | 76.252 | 27.045 | 39.227 |
| hex: canterbury/xargs.1 | 8456 | 39895.1 ± 0.8% | 2673.8 ± 0.4% | 1566.6 ± 0.4% | 840.2 ± 0.3% | 1605.5 ± 2.2% | 1114.8 ± 3.8% | 14.921 | 25.465 | 47.482 | 24.849 | 35.787 |
| hex: canterbury-large/E.coli | 524290 | 43729.2 ± 0.4% | 2585.8 ± 0.2% | 1509.2 ± 0.2% | 816.5 ± 0.1% | 1566.1 ± 0.1% | 1069.4 ± 0.2% | 16.911 | 28.976 | 53.559 | 27.923 | 40.893 |
| hex: canterbury-large/bible.txt | 524290 | 43836.8 ± 0.1% | 2596.8 ± 0.2% | 1514.3 ± 0.2% | 483.3 ± 0.3% | 1570.6 ± 0.4% | 1068.2 ± 1.9% | 16.881 | 28.949 | 90.702 | 27.911 | 41.036 |
| hex: canterbury-large/world192.txt | 524290 | 43681.3 ± 0.1% | 2590.4 ± 0.6% | 1513.5 ± 0.3% | 459.7 ± 0.2% | 1567.1 ± 5.8% | 1068.2 ± 0.2% | 16.863 | 28.860 | 95.013 | 27.873 | 40.891 |
| hex: http/html-1kx1024 | 2099200 | 21113.3 ± 4.0% | 2320.5 ± 1.8% | 1470.9 ± 0.5% | 501.3 ± 4.3% | 1486.2 ± 1.1% | 1079.5 ± 0.1% | 9.098 | 14.354 | 42.114 | 14.206 | 19.558 |
| hex: http/html-16kx64 | 2097280 | 21814.5 ± 2.6% | 2232.5 ± 0.1% | 1461.8 ± 0.1% | 505.0 ± 0.2% | 1448.0 ± 0.0% | 1088.7 ± 0.3% | 9.771 | 14.923 | 43.199 | 15.066 | 20.037 |
| hex: http/html-1m | 524290 | 43791.0 ± 0.2% | 2594.1 ± 0.2% | 1515.5 ± 0.2% | 492.2 ± 0.4% | 1572.6 ± 0.2% | 1066.6 ± 0.2% | 16.881 | 28.895 | 88.976 | 27.847 | 41.055 |
| hex: http/json-1kx1024 | 2099200 | 20923.8 ± 0.4% | 2318.4 ± 1.4% | 1473.2 ± 0.3% | 697.5 ± 0.1% | 1484.5 ± 0.3% | 1079.9 ± 0.2% | 9.025 | 14.203 | 29.998 | 14.095 | 19.375 |
| hex: http/json-16kx64 | 2097280 | 21750.4 ± 0.9% | 2227.1 ± 0.2% | 1459.4 ± 0.1% | 706.7 ± 0.2% | 1445.1 ± 0.1% | 1087.7 ± 0.2% | 9.766 | 14.904 | 30.779 | 15.051 | 19.997 |
| hex: http/json-1m | 524290 | 43443.4 ± 0.1% | 2586.9 ± 0.5% | 1510.5 ± 0.3% | 727.4 ± 0.5% | 1528.8 ± 6.1% | 1068.6 ± 0.9% | 16.794 | 28.762 | 59.728 | 28.417 | 40.656 |
| hex: http/js-1kx1024 | 2099200 | 20679.0 ± 0.2% | 2326.5 ± 1.5% | 1474.6 ± 0.4% | 491.0 ± 0.7% | 1489.2 ± 1.4% | 1079.9 ± 0.4% | 8.888 | 14.023 | 42.119 | 13.886 | 19.149 |
| hex: http/js-16kx64 | 2097280 | 21548.7 ± 0.2% | 2228.7 ± 0.4% | 1461.3 ± 0.1% | 493.1 ± 0.1% | 1447.6 ± 5.0% | 1085.5 ± 0.3% | 9.669 | 14.746 | 43.703 | 14.886 | 19.851 |
| hex: http/js-1m | 524290 | 43719.2 ± 0.1% | 2580.3 ± 0.1% | 1517.6 ± 5.6% | 505.4 ± 2.2% | 1566.1 ± 6.1% | 1068.8 ± 0.2% | 16.943 | 28.808 | 86.507 | 27.915 | 40.906 |
| hex: http/css-1kx1024 | 2099200 | 20577.2 ± 0.3% | 2301.6 ± 1.9% | 1476.2 ± 2.9% | 558.0 ± 3.2% | 1483.3 ± 1.1% | 1080.3 ± 0.2% | 8.940 | 13.939 | 36.878 | 13.873 | 19.047 |
| hex: http/css-16kx64 | 2097280 | 22128.9 ± 0.3% | 2231.0 ± 1.0% | 1461.5 ± 0.1% | 565.0 ± 0.1% | 1448.3 ± 0.1% | 1086.8 ± 0.4% | 9.919 | 15.141 | 39.166 | 15.279 | 20.362 |
| hex: http/css-1m | 524290 | 43679.2 ± 8.6% | 2596.1 ± 0.2% | 1515.8 ± 0.1% | 534.7 ± 0.2% | 1531.3 ± 0.1% | 1069.5 ± 0.2% | 16.825 | 28.816 | 81.693 | 28.524 | 40.843 |
| hex: shuffled/dickens-1m | 524290 | 43862.7 ± 0.1% | 2590.6 ± 0.2% | 1510.4 ± 0.1% | 463.3 ± 0.2% | 1564.4 ± 0.1% | 1069.3 ± 0.2% | 16.932 | 29.041 | 94.666 | 28.037 | 41.022 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1150.2 ± 0.2% | 1520.4 ± 1.0% | 1110.2 ± 0.3% | 392.8 ± 0.5% | 657.1 ± 0.2% | 367.4 ± 2.1% | 0.757 | 1.036 | 2.928 | 1.750 | 3.131 |
| qlog records, JSON text sequence | 1467503 | 1023.5 ± 0.2% | 1253.7 ± 1.2% | 1115.2 ± 0.3% | 332.1 ± 1.3% | 738.7 ± 0.3% | 319.1 ± 1.2% | 0.816 | 0.918 | 3.082 | 1.385 | 3.208 |
| messages: 11 string members | 1025025 | 987.3 ± 0.6% | 2044.1 ± 0.8% | 767.7 ± 0.6% | 338.1 ± 0.6% | 500.3 ± 0.5% | 306.1 ± 1.8% | 0.483 | 1.286 | 2.920 | 1.974 | 3.226 |
| messages: 50 nested objects | 1121600 | 1238.4 ± 1.2% | 1746.3 ± 1.6% | 1449.2 ± 0.7% | 430.7 ± 0.8% | 907.9 ± 0.4% | 423.1 ± 0.2% | 0.709 | 0.855 | 2.876 | 1.364 | 2.927 |
| string: silesia/dickens | 172528 | 6707.4 ± 0.3% | 3429.7 ± 4.0% | 2823.2 ± 1.9% | 317.6 ± 0.8% | 3382.6 ± 0.8% | 573.9 ± 1.7% | 1.956 | 2.376 | 21.120 | 1.983 | 11.688 |
| string: silesia/nci | 1075110 | 5470.1 ± 0.3% | 3933.0 ± 0.3% | 2988.8 ± 2.6% | 654.1 ± 1.0% | 3678.5 ± 3.6% | 582.3 ± 1.2% | 1.391 | 1.830 | 8.363 | 1.487 | 9.394 |
| string: silesia/reymont | 1075159 | 3489.4 ± 2.3% | 3424.5 ± 1.6% | 2019.9 ± 0.4% | 341.9 ± 1.9% | 2096.5 ± 0.5% | 495.6 ± 2.6% | 1.019 | 1.727 | 10.207 | 1.664 | 7.041 |
| string: silesia/samba | 97582 | 3980.7 ± 1.0% | 3808.8 ± 0.2% | 3124.3 ± 0.3% | 328.3 ± 1.0% | 2059.3 ± 0.2% | 422.4 ± 1.4% | 1.045 | 1.274 | 12.124 | 1.933 | 9.425 |
| string: silesia/webster | 1098490 | 4442.4 ± 1.1% | 2446.3 ± 0.3% | 1751.4 ± 0.2% | 310.1 ± 0.4% | 2122.3 ± 0.2% | 469.6 ± 0.7% | 1.816 | 2.536 | 14.324 | 2.093 | 9.461 |
| string: silesia/xml | 1090118 | 6129.6 ± 0.3% | 5043.1 ± 0.3% | 2508.7 ± 0.8% | 511.1 ± 0.6% | 3328.8 ± 0.3% | 543.8 ± 1.6% | 1.215 | 2.443 | 11.993 | 1.841 | 11.272 |
| string: canterbury/alice29.txt | 159425 | 5771.4 ± 0.8% | 2794.1 ± 0.8% | 2860.1 ± 0.9% | 301.1 ± 0.3% | 3031.2 ± 1.5% | 518.5 ± 0.3% | 2.066 | 2.018 | 19.168 | 1.904 | 11.131 |
| string: canterbury/asyoulik.txt | 132198 | 4303.0 ± 0.4% | 2627.2 ± 4.0% | 2690.1 ± 0.6% | 305.6 ± 0.3% | 2438.3 ± 1.3% | 455.0 ± 2.0% | 1.638 | 1.600 | 14.079 | 1.765 | 9.458 |
| string: canterbury/lcet10.txt | 441884 | 6705.6 ± 0.5% | 3295.9 ± 0.3% | 2366.8 ± 0.5% | 347.5 ± 0.4% | 3016.4 ± 0.7% | 571.4 ± 0.6% | 2.035 | 2.833 | 19.296 | 2.223 | 11.735 |
| string: canterbury/plrabn12.txt | 503330 | 5471.5 ± 0.0% | 3174.4 ± 0.1% | 1861.9 ± 0.2% | 323.2 ± 0.3% | 2877.4 ± 0.4% | 534.4 ± 0.6% | 1.724 | 2.939 | 16.931 | 1.902 | 10.238 |
| string: canterbury-large/E.coli | 1048578 | 33979.9 ± 0.2% | 12993.5 ± 0.2% | 3399.2 ± 0.3% | 1285.3 ± 0.1% | 8948.1 ± 0.1% | 979.3 ± 2.1% | 2.615 | 9.996 | 26.437 | 3.797 | 34.699 |
| string: canterbury-large/bible.txt | 1055886 | 8617.8 ± 0.5% | 5243.9 ± 0.5% | 2825.9 ± 0.1% | 359.2 ± 0.7% | 3894.4 ± 0.5% | 633.9 ± 3.7% | 1.643 | 3.050 | 23.993 | 2.213 | 13.595 |
| string: canterbury-large/world192.txt | 1103121 | 4181.8 ± 1.0% | 2311.4 ± 0.2% | 1815.5 ± 0.3% | 328.9 ± 0.3% | 2197.6 ± 0.3% | 470.4 ± 2.4% | 1.809 | 2.303 | 12.716 | 1.903 | 8.889 |
| string: http/html-1m | 1058582 | 8901.5 ± 7.9% | 4761.0 ± 0.8% | 2739.2 ± 1.0% | 429.4 ± 0.4% | 3602.7 ± 1.3% | 599.6 ± 2.4% | 1.870 | 3.250 | 20.731 | 2.471 | 14.845 |
| string: http/json-1m | 1190272 | 3334.9 ± 0.7% | 1256.9 ± 0.4% | 2127.8 ± 0.3% | 470.3 ± 0.8% | 1369.1 ± 0.6% | 437.3 ± 3.2% | 2.653 | 1.567 | 7.091 | 2.436 | 7.627 |
| string: http/js-1m | 1144362 | 2884.1 ± 0.4% | 1610.9 ± 0.1% | 1336.5 ± 0.2% | 329.2 ± 0.5% | 1416.9 ± 0.3% | 378.9 ± 0.8% | 1.790 | 2.158 | 8.761 | 2.036 | 7.612 |
| string: http/css-1m | 1097820 | 3308.4 ± 0.7% | 2885.3 ± 1.3% | 2304.5 ± 0.4% | 458.8 ± 2.9% | 2117.0 ± 0.3% | 438.5 ± 1.7% | 1.147 | 1.436 | 7.211 | 1.563 | 7.545 |
| string: dickens as Cyrillic and CJK | 1883069 | 5832.5 ± 0.5% | 3143.6 ± 1.2% | 687.0 ± 0.6% | 371.7 ± 2.7% | 497.1 ± 0.6% | 166.0 ± 3.1% | 1.855 | 8.490 | 15.692 | 11.733 | 35.142 |
| string: dickens as Cyrillic and CJK, as \u escapes | 5075485 | 1208.8 ± 0.6% | 1243.8 ± 0.7% | 1104.0 ± 1.0% | 264.0 ± 0.9% | 469.4 ± 0.2% | 230.9 ± 3.9% | 0.972 | 1.095 | 4.579 | 2.575 | 5.236 |
| hex: silesia/dickens | 524290 | 33907.2 ± 0.6% | 15110.1 ± 0.3% | 3567.3 ± 0.4% | 478.1 ± 1.6% | 8953.8 ± 0.5% | 1138.0 ± 1.6% | 2.244 | 9.505 | 70.922 | 3.787 | 29.794 |
| hex: silesia/mozilla | 524290 | 33739.6 ± 2.8% | 15065.3 ± 1.0% | 3487.4 ± 1.0% | 428.5 ± 0.5% | 8907.6 ± 0.8% | 1137.5 ± 0.8% | 2.240 | 9.675 | 78.740 | 3.788 | 29.662 |
| hex: silesia/mr | 524290 | 33969.9 ± 0.2% | 15145.0 ± 0.1% | 3496.4 ± 0.3% | 649.4 ± 0.2% | 8945.8 ± 0.2% | 1136.4 ± 0.8% | 2.243 | 9.716 | 52.310 | 3.797 | 29.892 |
| hex: silesia/nci | 524290 | 33990.8 ± 0.3% | 15138.8 ± 0.4% | 3566.5 ± 0.4% | 762.1 ± 0.2% | 8966.2 ± 0.6% | 1138.8 ± 0.4% | 2.245 | 9.531 | 44.599 | 3.791 | 29.849 |
| hex: silesia/ooffice | 524290 | 33997.3 ± 0.1% | 15145.4 ± 0.3% | 3494.1 ± 1.4% | 343.0 ± 0.3% | 8943.0 ± 0.3% | 1136.7 ± 1.0% | 2.245 | 9.730 | 99.112 | 3.802 | 29.909 |
| hex: silesia/osdb | 524290 | 33958.9 ± 0.3% | 15146.0 ± 0.3% | 3501.1 ± 0.2% | 456.0 ± 0.8% | 8954.9 ± 4.9% | 1139.5 ± 0.6% | 2.242 | 9.700 | 74.478 | 3.792 | 29.802 |
| hex: silesia/reymont | 524290 | 33956.8 ± 0.2% | 15104.8 ± 3.0% | 3540.8 ± 0.1% | 494.8 ± 0.2% | 8962.9 ± 0.6% | 1139.0 ± 1.1% | 2.248 | 9.590 | 68.626 | 3.789 | 29.813 |
| hex: silesia/samba | 524290 | 33925.2 ± 0.2% | 15076.6 ± 1.5% | 3495.0 ± 0.4% | 364.2 ± 2.3% | 8949.4 ± 0.7% | 1142.3 ± 0.4% | 2.250 | 9.707 | 93.143 | 3.791 | 29.698 |
| hex: silesia/sao | 524290 | 33947.8 ± 0.5% | 15137.9 ± 0.4% | 3499.0 ± 3.1% | 279.5 ± 0.5% | 8952.5 ± 0.2% | 1140.9 ± 3.6% | 2.243 | 9.702 | 121.445 | 3.792 | 29.755 |
| hex: silesia/webster | 524290 | 33972.4 ± 0.4% | 15126.9 ± 3.1% | 3567.1 ± 0.2% | 451.8 ± 0.5% | 8969.7 ± 0.2% | 1140.7 ± 0.7% | 2.246 | 9.524 | 75.194 | 3.787 | 29.782 |
| hex: silesia/x-ray | 524290 | 33957.1 ± 4.3% | 15138.4 ± 1.0% | 3503.8 ± 2.1% | 425.9 ± 0.2% | 8951.5 ± 0.2% | 1138.3 ± 0.1% | 2.243 | 9.692 | 79.737 | 3.793 | 29.831 |
| hex: silesia/xml | 524290 | 33972.2 ± 0.3% | 15128.0 ± 0.6% | 3562.3 ± 0.2% | 707.9 ± 3.6% | 8966.4 ± 0.6% | 1139.3 ± 0.4% | 2.246 | 9.537 | 47.992 | 3.789 | 29.817 |
| hex: canterbury/alice29.txt | 304180 | 33845.4 ± 0.4% | 14227.7 ± 0.3% | 3564.8 ± 2.7% | 484.3 ± 0.3% | 8943.7 ± 0.3% | 1142.6 ± 1.2% | 2.379 | 9.494 | 69.883 | 3.784 | 29.620 |
| hex: canterbury/asyoulik.txt | 250360 | 33787.1 ± 0.4% | 15046.1 ± 2.5% | 3493.9 ± 0.5% | 470.0 ± 0.8% | 8932.5 ± 0.3% | 1143.2 ± 0.4% | 2.246 | 9.670 | 71.882 | 3.782 | 29.555 |
| hex: canterbury/cp.html | 49208 | 33228.7 ± 6.3% | 14318.9 ± 0.4% | 3554.4 ± 0.8% | 495.4 ± 1.5% | 9260.2 ± 3.8% | 1119.6 ± 1.1% | 2.321 | 9.349 | 67.075 | 3.588 | 29.679 |
| hex: canterbury/fields.c | 22302 | 32811.4 ± 0.7% | 17483.8 ± 4.6% | 3653.1 ± 0.8% | 523.6 ± 0.8% | 9235.9 ± 0.3% | 1090.2 ± 2.0% | 1.877 | 8.982 | 62.669 | 3.553 | 30.098 |
| hex: canterbury/grammar.lsp | 7444 | 29678.0 ± 4.6% | 17207.3 ± 0.4% | 3615.1 ± 0.4% | 695.9 ± 1.0% | 8984.7 ± 0.9% | 1046.5 ± 1.5% | 1.725 | 8.209 | 42.647 | 3.303 | 28.360 |
| hex: canterbury/kennedy.xls | 524290 | 33815.6 ± 1.0% | 15047.9 ± 0.4% | 3547.7 ± 0.8% | 751.7 ± 0.3% | 8930.2 ± 0.5% | 1096.7 ± 3.2% | 2.247 | 9.532 | 44.984 | 3.787 | 30.835 |
| hex: canterbury/lcet10.txt | 524290 | 33872.6 ± 1.3% | 15078.8 ± 1.2% | 3570.1 ± 1.1% | 483.7 ± 1.3% | 8911.3 ± 1.3% | 1087.1 ± 2.1% | 2.246 | 9.488 | 70.024 | 3.801 | 31.158 |
| hex: canterbury/plrabn12.txt | 524290 | 33794.1 ± 0.5% | 15033.1 ± 1.0% | 3546.2 ± 0.9% | 466.0 ± 0.8% | 8918.2 ± 0.5% | 1096.6 ± 1.3% | 2.248 | 9.530 | 72.526 | 3.789 | 30.817 |
| hex: canterbury/ptt5 | 524290 | 33773.9 ± 5.0% | 15037.9 ± 0.8% | 3471.7 ± 1.1% | 660.4 ± 0.6% | 8910.3 ± 0.4% | 1093.2 ± 1.7% | 2.246 | 9.728 | 51.142 | 3.790 | 30.895 |
| hex: canterbury/sum | 76482 | 33196.3 ± 0.7% | 15385.8 ± 1.0% | 3554.5 ± 0.7% | 571.1 ± 0.8% | 8883.7 ± 0.7% | 1105.1 ± 2.1% | 2.158 | 9.339 | 58.125 | 3.737 | 30.041 |
| hex: canterbury/xargs.1 | 8456 | 30246.7 ± 0.5% | 17410.9 ± 0.4% | 3567.7 ± 0.4% | 683.4 ± 3.3% | 9020.5 ± 0.5% | 1079.9 ± 2.1% | 1.737 | 8.478 | 44.259 | 3.353 | 28.008 |
| hex: canterbury-large/E.coli | 524290 | 33976.2 ± 0.3% | 15162.5 ± 0.1% | 3500.8 ± 0.4% | 963.7 ± 0.1% | 8957.4 ± 0.1% | 1104.4 ± 1.6% | 2.241 | 9.705 | 35.258 | 3.793 | 30.765 |
| hex: canterbury-large/bible.txt | 524290 | 33960.1 ± 0.3% | 15161.3 ± 0.3% | 3501.5 ± 0.1% | 503.4 ± 0.5% | 8956.6 ± 0.0% | 1109.3 ± 1.6% | 2.240 | 9.699 | 67.456 | 3.792 | 30.614 |
| hex: canterbury-large/world192.txt | 524290 | 33989.7 ± 0.2% | 15133.1 ± 2.8% | 3567.9 ± 0.3% | 463.7 ± 0.4% | 8974.5 ± 0.1% | 1112.0 ± 1.8% | 2.246 | 9.527 | 73.301 | 3.787 | 30.566 |
| hex: http/html-1kx1024 | 2099200 | 15516.3 ± 1.0% | 12093.3 ± 0.8% | 3197.3 ± 0.1% | 496.3 ± 0.3% | 7795.2 ± 1.6% | 978.3 ± 1.6% | 1.283 | 4.853 | 31.265 | 1.990 | 15.861 |
| hex: http/html-16kx64 | 2097280 | 28190.1 ± 0.4% | 13912.6 ± 0.2% | 3414.0 ± 0.4% | 501.8 ± 0.7% | 8701.6 ± 0.9% | 1077.8 ± 2.5% | 2.026 | 8.257 | 56.174 | 3.240 | 26.154 |
| hex: http/html-1m | 524290 | 34005.1 ± 0.1% | 15148.5 ± 0.3% | 3505.8 ± 0.5% | 502.3 ± 0.3% | 8957.0 ± 0.0% | 1131.7 ± 4.6% | 2.245 | 9.700 | 67.692 | 3.796 | 30.048 |
| hex: http/json-1kx1024 | 2099200 | 15600.1 ± 0.8% | 12435.1 ± 12.0% | 3196.5 ± 0.7% | 657.3 ± 1.0% | 7612.7 ± 2.2% | 966.0 ± 2.2% | 1.255 | 4.880 | 23.735 | 2.049 | 16.150 |
| hex: http/json-16kx64 | 2097280 | 28298.3 ± 0.5% | 14017.9 ± 1.0% | 3403.6 ± 1.6% | 669.0 ± 0.6% | 8638.6 ± 1.5% | 1077.5 ± 2.1% | 2.019 | 8.314 | 42.300 | 3.276 | 26.263 |
| hex: http/json-1m | 524290 | 33914.4 ± 0.9% | 15141.3 ± 0.8% | 3564.0 ± 0.3% | 699.4 ± 0.5% | 8957.7 ± 0.2% | 1135.1 ± 0.8% | 2.240 | 9.516 | 48.494 | 3.786 | 29.877 |
| hex: http/js-1kx1024 | 2099200 | 15416.8 ± 1.8% | 12366.0 ± 4.9% | 3174.5 ± 1.5% | 477.0 ± 0.4% | 7756.5 ± 2.4% | 971.3 ± 1.7% | 1.247 | 4.856 | 32.320 | 1.988 | 15.872 |
| hex: http/js-16kx64 | 2097280 | 27966.2 ± 0.4% | 14076.8 ± 0.3% | 3407.9 ± 0.5% | 482.7 ± 0.3% | 8591.6 ± 0.7% | 1076.8 ± 4.3% | 1.987 | 8.206 | 57.943 | 3.255 | 25.972 |
| hex: http/js-1m | 524290 | 33962.7 ± 0.2% | 15150.5 ± 0.2% | 3556.4 ± 0.4% | 498.1 ± 0.4% | 8970.6 ± 0.1% | 1135.3 ± 4.0% | 2.242 | 9.550 | 68.186 | 3.786 | 29.915 |
| hex: http/css-1kx1024 | 2099200 | 15495.6 ± 0.5% | 12356.2 ± 0.7% | 3194.7 ± 0.2% | 554.5 ± 0.7% | 7725.9 ± 2.5% | 976.3 ± 1.1% | 1.254 | 4.850 | 27.943 | 2.006 | 15.871 |
| hex: http/css-16kx64 | 2097280 | 27745.6 ± 0.2% | 14002.6 ± 0.4% | 3405.4 ± 1.5% | 561.8 ± 4.7% | 8349.3 ± 1.5% | 1085.0 ± 2.2% | 1.981 | 8.147 | 49.391 | 3.323 | 25.572 |
| hex: http/css-1m | 524290 | 33998.1 ± 4.4% | 15158.7 ± 0.1% | 3570.8 ± 0.5% | 545.5 ± 0.4% | 8969.9 ± 0.2% | 1117.8 ± 6.2% | 2.243 | 9.521 | 62.330 | 3.790 | 30.414 |
| hex: shuffled/dickens-1m | 524290 | 33959.9 ± 0.3% | 15165.2 ± 0.2% | 3494.3 ± 0.2% | 479.2 ± 1.0% | 8952.4 ± 0.2% | 1132.9 ± 2.1% | 2.239 | 9.719 | 70.866 | 3.793 | 29.975 |

## TextReader.next_items against the baselines

stdx's decoder a slice of tokens a call through `TextReader.next_items`, as a caller that reads a text's values in a loop calls it (decision 79). Octets are the text's. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1283.4 ± 0.2% | 1520.4 ± 1.0% | 1110.2 ± 0.3% | 392.8 ± 0.5% | 657.1 ± 0.2% | 367.4 ± 2.1% | 0.844 | 1.156 | 3.267 | 1.953 | 3.493 |
| qlog records, JSON text sequence | 1467503 | 1150.2 ± 0.2% | 1253.7 ± 1.2% | 1115.2 ± 0.3% | 332.1 ± 1.3% | 738.7 ± 0.3% | 319.1 ± 1.2% | 0.917 | 1.031 | 3.463 | 1.557 | 3.605 |
| messages: 11 string members | 1025025 | 1040.2 ± 0.7% | 2044.1 ± 0.8% | 767.7 ± 0.6% | 338.1 ± 0.6% | 500.3 ± 0.5% | 306.1 ± 1.8% | 0.509 | 1.355 | 3.077 | 2.079 | 3.398 |
| messages: 50 nested objects | 1121600 | 1301.0 ± 1.0% | 1746.3 ± 1.6% | 1449.2 ± 0.7% | 430.7 ± 0.8% | 907.9 ± 0.4% | 423.1 ± 0.2% | 0.745 | 0.898 | 3.021 | 1.433 | 3.075 |
| string: silesia/dickens | 172528 | 6714.1 ± 0.2% | 3429.7 ± 4.0% | 2823.2 ± 1.9% | 317.6 ± 0.8% | 3382.6 ± 0.8% | 573.9 ± 1.7% | 1.958 | 2.378 | 21.141 | 1.985 | 11.700 |
| string: silesia/nci | 1075110 | 5474.7 ± 0.3% | 3933.0 ± 0.3% | 2988.8 ± 2.6% | 654.1 ± 1.0% | 3678.5 ± 3.6% | 582.3 ± 1.2% | 1.392 | 1.832 | 8.370 | 1.488 | 9.402 |
| string: silesia/reymont | 1075159 | 3553.5 ± 2.7% | 3424.5 ± 1.6% | 2019.9 ± 0.4% | 341.9 ± 1.9% | 2096.5 ± 0.5% | 495.6 ± 2.6% | 1.038 | 1.759 | 10.395 | 1.695 | 7.171 |
| string: silesia/samba | 97582 | 4014.2 ± 1.3% | 3808.8 ± 0.2% | 3124.3 ± 0.3% | 328.3 ± 1.0% | 2059.3 ± 0.2% | 422.4 ± 1.4% | 1.054 | 1.285 | 12.226 | 1.949 | 9.504 |
| string: silesia/webster | 1098490 | 4468.2 ± 0.3% | 2446.3 ± 0.3% | 1751.4 ± 0.2% | 310.1 ± 0.4% | 2122.3 ± 0.2% | 469.6 ± 0.7% | 1.827 | 2.551 | 14.407 | 2.105 | 9.516 |
| string: silesia/xml | 1090118 | 6151.8 ± 0.3% | 5043.1 ± 0.3% | 2508.7 ± 0.8% | 511.1 ± 0.6% | 3328.8 ± 0.3% | 543.8 ± 1.6% | 1.220 | 2.452 | 12.037 | 1.848 | 11.313 |
| string: canterbury/alice29.txt | 159425 | 5835.9 ± 1.3% | 2794.1 ± 0.8% | 2860.1 ± 0.9% | 301.1 ± 0.3% | 3031.2 ± 1.5% | 518.5 ± 0.3% | 2.089 | 2.040 | 19.382 | 1.925 | 11.255 |
| string: canterbury/asyoulik.txt | 132198 | 4305.2 ± 0.7% | 2627.2 ± 4.0% | 2690.1 ± 0.6% | 305.6 ± 0.3% | 2438.3 ± 1.3% | 455.0 ± 2.0% | 1.639 | 1.600 | 14.087 | 1.766 | 9.463 |
| string: canterbury/lcet10.txt | 441884 | 6715.9 ± 0.9% | 3295.9 ± 0.3% | 2366.8 ± 0.5% | 347.5 ± 0.4% | 3016.4 ± 0.7% | 571.4 ± 0.6% | 2.038 | 2.838 | 19.326 | 2.226 | 11.753 |
| string: canterbury/plrabn12.txt | 503330 | 5470.4 ± 0.2% | 3174.4 ± 0.1% | 1861.9 ± 0.2% | 323.2 ± 0.3% | 2877.4 ± 0.4% | 534.4 ± 0.6% | 1.723 | 2.938 | 16.927 | 1.901 | 10.236 |
| string: canterbury-large/E.coli | 1048578 | 34124.3 ± 0.2% | 12993.5 ± 0.2% | 3399.2 ± 0.3% | 1285.3 ± 0.1% | 8948.1 ± 0.1% | 979.3 ± 2.1% | 2.626 | 10.039 | 26.549 | 3.814 | 34.846 |
| string: canterbury-large/bible.txt | 1055886 | 8674.9 ± 0.4% | 5243.9 ± 0.5% | 2825.9 ± 0.1% | 359.2 ± 0.7% | 3894.4 ± 0.5% | 633.9 ± 3.7% | 1.654 | 3.070 | 24.152 | 2.228 | 13.685 |
| string: canterbury-large/world192.txt | 1103121 | 4195.9 ± 0.7% | 2311.4 ± 0.2% | 1815.5 ± 0.3% | 328.9 ± 0.3% | 2197.6 ± 0.3% | 470.4 ± 2.4% | 1.815 | 2.311 | 12.759 | 1.909 | 8.919 |
| string: http/html-1m | 1058582 | 9638.0 ± 3.0% | 4761.0 ± 0.8% | 2739.2 ± 1.0% | 429.4 ± 0.4% | 3602.7 ± 1.3% | 599.6 ± 2.4% | 2.024 | 3.519 | 22.447 | 2.675 | 16.073 |
| string: http/json-1m | 1190272 | 3343.0 ± 1.6% | 1256.9 ± 0.4% | 2127.8 ± 0.3% | 470.3 ± 0.8% | 1369.1 ± 0.6% | 437.3 ± 3.2% | 2.660 | 1.571 | 7.108 | 2.442 | 7.645 |
| string: http/js-1m | 1144362 | 2891.3 ± 0.1% | 1610.9 ± 0.1% | 1336.5 ± 0.2% | 329.2 ± 0.5% | 1416.9 ± 0.3% | 378.9 ± 0.8% | 1.795 | 2.163 | 8.783 | 2.041 | 7.631 |
| string: http/css-1m | 1097820 | 3327.9 ± 0.2% | 2885.3 ± 1.3% | 2304.5 ± 0.4% | 458.8 ± 2.9% | 2117.0 ± 0.3% | 438.5 ± 1.7% | 1.153 | 1.444 | 7.254 | 1.572 | 7.589 |
| string: dickens as Cyrillic and CJK | 1883069 | 5845.3 ± 0.5% | 3143.6 ± 1.2% | 687.0 ± 0.6% | 371.7 ± 2.7% | 497.1 ± 0.6% | 166.0 ± 3.1% | 1.859 | 8.508 | 15.727 | 11.758 | 35.220 |
| string: dickens as Cyrillic and CJK, as \u escapes | 5075485 | 1211.4 ± 3.8% | 1243.8 ± 0.7% | 1104.0 ± 1.0% | 264.0 ± 0.9% | 469.4 ± 0.2% | 230.9 ± 3.9% | 0.974 | 1.097 | 4.589 | 2.581 | 5.247 |
| hex: silesia/dickens | 524290 | 33984.8 ± 4.4% | 15110.1 ± 0.3% | 3567.3 ± 0.4% | 478.1 ± 1.6% | 8953.8 ± 0.5% | 1138.0 ± 1.6% | 2.249 | 9.527 | 71.084 | 3.796 | 29.863 |
| hex: silesia/mozilla | 524290 | 33880.1 ± 0.6% | 15065.3 ± 1.0% | 3487.4 ± 1.0% | 428.5 ± 0.5% | 8907.6 ± 0.8% | 1137.5 ± 0.8% | 2.249 | 9.715 | 79.068 | 3.803 | 29.785 |
| hex: silesia/mr | 524290 | 33992.3 ± 0.1% | 15145.0 ± 0.1% | 3496.4 ± 0.3% | 649.4 ± 0.2% | 8945.8 ± 0.2% | 1136.4 ± 0.8% | 2.244 | 9.722 | 52.344 | 3.800 | 29.912 |
| hex: silesia/nci | 524290 | 33979.5 ± 0.2% | 15138.8 ± 0.4% | 3566.5 ± 0.4% | 762.1 ± 0.2% | 8966.2 ± 0.6% | 1138.8 ± 0.4% | 2.245 | 9.527 | 44.585 | 3.790 | 29.839 |
| hex: silesia/ooffice | 524290 | 33944.5 ± 0.6% | 15145.4 ± 0.3% | 3494.1 ± 1.4% | 343.0 ± 0.3% | 8943.0 ± 0.3% | 1136.7 ± 1.0% | 2.241 | 9.715 | 98.958 | 3.796 | 29.862 |
| hex: silesia/osdb | 524290 | 34012.2 ± 0.2% | 15146.0 ± 0.3% | 3501.1 ± 0.2% | 456.0 ± 0.8% | 8954.9 ± 4.9% | 1139.5 ± 0.6% | 2.246 | 9.715 | 74.595 | 3.798 | 29.849 |
| hex: silesia/reymont | 524290 | 33977.2 ± 0.3% | 15104.8 ± 3.0% | 3540.8 ± 0.1% | 494.8 ± 0.2% | 8962.9 ± 0.6% | 1139.0 ± 1.1% | 2.249 | 9.596 | 68.667 | 3.791 | 29.831 |
| hex: silesia/samba | 524290 | 33961.8 ± 2.4% | 15076.6 ± 1.5% | 3495.0 ± 0.4% | 364.2 ± 2.3% | 8949.4 ± 0.7% | 1142.3 ± 0.4% | 2.253 | 9.717 | 93.243 | 3.795 | 29.730 |
| hex: silesia/sao | 524290 | 33967.1 ± 0.1% | 15137.9 ± 0.4% | 3499.0 ± 3.1% | 279.5 ± 0.5% | 8952.5 ± 0.2% | 1140.9 ± 3.6% | 2.244 | 9.708 | 121.514 | 3.794 | 29.772 |
| hex: silesia/webster | 524290 | 33981.2 ± 0.3% | 15126.9 ± 3.1% | 3567.1 ± 0.2% | 451.8 ± 0.5% | 8969.7 ± 0.2% | 1140.7 ± 0.7% | 2.246 | 9.526 | 75.213 | 3.788 | 29.790 |
| hex: silesia/x-ray | 524290 | 33972.1 ± 0.1% | 15138.4 ± 1.0% | 3503.8 ± 2.1% | 425.9 ± 0.2% | 8951.5 ± 0.2% | 1138.3 ± 0.1% | 2.244 | 9.696 | 79.772 | 3.795 | 29.844 |
| hex: silesia/xml | 524290 | 33898.3 ± 0.4% | 15128.0 ± 0.6% | 3562.3 ± 0.2% | 707.9 ± 3.6% | 8966.4 ± 0.6% | 1139.3 ± 0.4% | 2.241 | 9.516 | 47.887 | 3.781 | 29.753 |
| hex: canterbury/alice29.txt | 304180 | 33825.2 ± 0.2% | 14227.7 ± 0.3% | 3564.8 ± 2.7% | 484.3 ± 0.3% | 8943.7 ± 0.3% | 1142.6 ± 1.2% | 2.377 | 9.489 | 69.841 | 3.782 | 29.603 |
| hex: canterbury/asyoulik.txt | 250360 | 33806.6 ± 0.3% | 15046.1 ± 2.5% | 3493.9 ± 0.5% | 470.0 ± 0.8% | 8932.5 ± 0.3% | 1143.2 ± 0.4% | 2.247 | 9.676 | 71.924 | 3.785 | 29.572 |
| hex: canterbury/cp.html | 49208 | 33221.2 ± 0.7% | 14318.9 ± 0.4% | 3554.4 ± 0.8% | 495.4 ± 1.5% | 9260.2 ± 3.8% | 1119.6 ± 1.1% | 2.320 | 9.346 | 67.060 | 3.588 | 29.673 |
| hex: canterbury/fields.c | 22302 | 32864.2 ± 0.7% | 17483.8 ± 4.6% | 3653.1 ± 0.8% | 523.6 ± 0.8% | 9235.9 ± 0.3% | 1090.2 ± 2.0% | 1.880 | 8.996 | 62.770 | 3.558 | 30.146 |
| hex: canterbury/grammar.lsp | 7444 | 29690.6 ± 0.7% | 17207.3 ± 0.4% | 3615.1 ± 0.4% | 695.9 ± 1.0% | 8984.7 ± 0.9% | 1046.5 ± 1.5% | 1.725 | 8.213 | 42.665 | 3.305 | 28.372 |
| hex: canterbury/kennedy.xls | 524290 | 33855.6 ± 0.5% | 15047.9 ± 0.4% | 3547.7 ± 0.8% | 751.7 ± 0.3% | 8930.2 ± 0.5% | 1096.7 ± 3.2% | 2.250 | 9.543 | 45.037 | 3.791 | 30.871 |
| hex: canterbury/lcet10.txt | 524290 | 33846.4 ± 1.1% | 15078.8 ± 1.2% | 3570.1 ± 1.1% | 483.7 ± 1.3% | 8911.3 ± 1.3% | 1087.1 ± 2.1% | 2.245 | 9.481 | 69.970 | 3.798 | 31.134 |
| hex: canterbury/plrabn12.txt | 524290 | 33826.6 ± 0.7% | 15033.1 ± 1.0% | 3546.2 ± 0.9% | 466.0 ± 0.8% | 8918.2 ± 0.5% | 1096.6 ± 1.3% | 2.250 | 9.539 | 72.595 | 3.793 | 30.847 |
| hex: canterbury/ptt5 | 524290 | 33830.4 ± 0.6% | 15037.9 ± 0.8% | 3471.7 ± 1.1% | 660.4 ± 0.6% | 8910.3 ± 0.4% | 1093.2 ± 1.7% | 2.250 | 9.745 | 51.227 | 3.797 | 30.947 |
| hex: canterbury/sum | 76482 | 33231.3 ± 0.4% | 15385.8 ± 1.0% | 3554.5 ± 0.7% | 571.1 ± 0.8% | 8883.7 ± 0.7% | 1105.1 ± 2.1% | 2.160 | 9.349 | 58.186 | 3.741 | 30.072 |
| hex: canterbury/xargs.1 | 8456 | 30327.8 ± 0.7% | 17410.9 ± 0.4% | 3567.7 ± 0.4% | 683.4 ± 3.3% | 9020.5 ± 0.5% | 1079.9 ± 2.1% | 1.742 | 8.501 | 44.377 | 3.362 | 28.083 |
| hex: canterbury-large/E.coli | 524290 | 33971.2 ± 4.5% | 15162.5 ± 0.1% | 3500.8 ± 0.4% | 963.7 ± 0.1% | 8957.4 ± 0.1% | 1104.4 ± 1.6% | 2.240 | 9.704 | 35.253 | 3.793 | 30.760 |
| hex: canterbury-large/bible.txt | 524290 | 33966.7 ± 4.4% | 15161.3 ± 0.3% | 3501.5 ± 0.1% | 503.4 ± 0.5% | 8956.6 ± 0.0% | 1109.3 ± 1.6% | 2.240 | 9.700 | 67.469 | 3.792 | 30.620 |
| hex: canterbury-large/world192.txt | 524290 | 33978.7 ± 0.2% | 15133.1 ± 2.8% | 3567.9 ± 0.3% | 463.7 ± 0.4% | 8974.5 ± 0.1% | 1112.0 ± 1.8% | 2.245 | 9.524 | 73.277 | 3.786 | 30.556 |
| hex: http/html-1kx1024 | 2099200 | 15228.8 ± 1.0% | 12093.3 ± 0.8% | 3197.3 ± 0.1% | 496.3 ± 0.3% | 7795.2 ± 1.6% | 978.3 ± 1.6% | 1.259 | 4.763 | 30.685 | 1.954 | 15.567 |
| hex: http/html-16kx64 | 2097280 | 28199.2 ± 0.1% | 13912.6 ± 0.2% | 3414.0 ± 0.4% | 501.8 ± 0.7% | 8701.6 ± 0.9% | 1077.8 ± 2.5% | 2.027 | 8.260 | 56.192 | 3.241 | 26.163 |
| hex: http/html-1m | 524290 | 34006.8 ± 0.2% | 15148.5 ± 0.3% | 3505.8 ± 0.5% | 502.3 ± 0.3% | 8957.0 ± 0.0% | 1131.7 ± 4.6% | 2.245 | 9.700 | 67.696 | 3.797 | 30.050 |
| hex: http/json-1kx1024 | 2099200 | 15273.6 ± 0.8% | 12435.1 ± 12.0% | 3196.5 ± 0.7% | 657.3 ± 1.0% | 7612.7 ± 2.2% | 966.0 ± 2.2% | 1.228 | 4.778 | 23.238 | 2.006 | 15.812 |
| hex: http/json-16kx64 | 2097280 | 28314.9 ± 0.6% | 14017.9 ± 1.0% | 3403.6 ± 1.6% | 669.0 ± 0.6% | 8638.6 ± 1.5% | 1077.5 ± 2.1% | 2.020 | 8.319 | 42.324 | 3.278 | 26.279 |
| hex: http/json-1m | 524290 | 33980.7 ± 3.8% | 15141.3 ± 0.8% | 3564.0 ± 0.3% | 699.4 ± 0.5% | 8957.7 ± 0.2% | 1135.1 ± 0.8% | 2.244 | 9.534 | 48.589 | 3.793 | 29.935 |
| hex: http/js-1kx1024 | 2099200 | 14979.4 ± 2.3% | 12366.0 ± 4.9% | 3174.5 ± 1.5% | 477.0 ± 0.4% | 7756.5 ± 2.4% | 971.3 ± 1.7% | 1.211 | 4.719 | 31.403 | 1.931 | 15.421 |
| hex: http/js-16kx64 | 2097280 | 27981.2 ± 0.5% | 14076.8 ± 0.3% | 3407.9 ± 0.5% | 482.7 ± 0.3% | 8591.6 ± 0.7% | 1076.8 ± 4.3% | 1.988 | 8.211 | 57.974 | 3.257 | 25.986 |
| hex: http/js-1m | 524290 | 33959.0 ± 0.6% | 15150.5 ± 0.2% | 3556.4 ± 0.4% | 498.1 ± 0.4% | 8970.6 ± 0.1% | 1135.3 ± 4.0% | 2.241 | 9.549 | 68.179 | 3.786 | 29.911 |
| hex: http/css-1kx1024 | 2099200 | 15189.9 ± 0.4% | 12356.2 ± 0.7% | 3194.7 ± 0.2% | 554.5 ± 0.7% | 7725.9 ± 2.5% | 976.3 ± 1.1% | 1.229 | 4.755 | 27.392 | 1.966 | 15.558 |
| hex: http/css-16kx64 | 2097280 | 27734.0 ± 0.3% | 14002.6 ± 0.4% | 3405.4 ± 1.5% | 561.8 ± 4.7% | 8349.3 ± 1.5% | 1085.0 ± 2.2% | 1.981 | 8.144 | 49.371 | 3.322 | 25.561 |
| hex: http/css-1m | 524290 | 34002.3 ± 0.2% | 15158.7 ± 0.1% | 3570.8 ± 0.5% | 545.5 ± 0.4% | 8969.9 ± 0.2% | 1117.8 ± 6.2% | 2.243 | 9.522 | 62.338 | 3.791 | 30.418 |
| hex: shuffled/dickens-1m | 524290 | 33995.8 ± 0.2% | 15165.2 ± 0.2% | 3494.3 ± 0.2% | 479.2 ± 1.0% | 8952.4 ± 0.2% | 1132.9 ± 2.1% | 2.242 | 9.729 | 70.941 | 3.797 | 30.007 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1592.3 ± 0.4% | 1479.9 ± 1.4% | 1024.6 ± 2.9% | 460.8 ± 3.1% | 436.1 ± 1.4% | 502.1 ± 0.8% | 1.076 | 1.554 | 3.456 | 3.651 | 3.171 |
| qlog records, JSON text sequence | 1467503 | 1418.0 ± 0.2% | 1224.7 ± 2.6% | 943.8 ± 0.4% | 422.0 ± 0.4% | 529.3 ± 3.8% | 354.7 ± 1.3% | 1.158 | 1.502 | 3.360 | 2.679 | 3.998 |
| messages: 11 string members | 1025025 | 1265.2 ± 0.3% | 1104.0 ± 0.6% | 750.1 ± 0.5% | 380.5 ± 0.9% | 417.8 ± 0.4% | 434.5 ± 0.6% | 1.146 | 1.687 | 3.325 | 3.028 | 2.912 |
| messages: 50 nested objects | 1121600 | 1719.3 ± 0.1% | 1894.4 ± 1.0% | 1336.2 ± 1.6% | 598.3 ± 1.0% | 615.7 ± 1.1% | 514.3 ± 0.6% | 0.908 | 1.287 | 2.874 | 2.792 | 3.343 |
| string: silesia/dickens | 172528 | 13123.5 ± 0.9% | 3964.5 ± 1.2% | 3101.7 ± 1.6% | 334.1 ± 1.3% | 1717.0 ± 1.9% | 1186.2 ± 1.3% | 3.310 | 4.231 | 39.278 | 7.643 | 11.063 |
| string: silesia/nci | 1075110 | 11375.4 ± 0.1% | 4748.4 ± 0.4% | 3143.4 ± 0.4% | 909.6 ± 0.8% | 1924.0 ± 4.3% | 1208.3 ± 0.5% | 2.396 | 3.619 | 12.505 | 5.912 | 9.414 |
| string: silesia/reymont | 1075159 | 5410.5 ± 0.8% | 1868.4 ± 1.2% | 2006.2 ± 0.5% | 380.0 ± 1.2% | 1431.0 ± 0.3% | 1045.2 ± 0.4% | 2.896 | 2.697 | 14.239 | 3.781 | 5.177 |
| string: silesia/samba | 97582 | 6345.7 ± 0.3% | 2721.7 ± 0.3% | 4096.3 ± 0.2% | 349.6 ± 0.6% | 1335.6 ± 0.4% | 1169.2 ± 2.7% | 2.332 | 1.549 | 18.150 | 4.751 | 5.427 |
| string: silesia/webster | 1098490 | 6950.0 ± 1.2% | 1988.6 ± 0.6% | 1871.8 ± 3.0% | 349.6 ± 0.3% | 1399.0 ± 1.2% | 601.7 ± 1.6% | 3.495 | 3.713 | 19.880 | 4.968 | 11.551 |
| string: silesia/xml | 1090118 | 10475.0 ± 1.1% | 3186.9 ± 2.3% | 2633.2 ± 0.9% | 604.2 ± 1.3% | 1957.0 ± 1.1% | 955.4 ± 1.2% | 3.287 | 3.978 | 17.336 | 5.353 | 10.964 |
| string: canterbury/alice29.txt | 159425 | 12719.7 ± 0.2% | 2909.9 ± 1.4% | 3164.3 ± 0.8% | 318.1 ± 0.5% | 1555.3 ± 1.3% | 1094.8 ± 0.8% | 4.371 | 4.020 | 39.984 | 8.178 | 11.618 |
| string: canterbury/asyoulik.txt | 132198 | 10543.0 ± 1.2% | 2118.3 ± 1.7% | 3145.8 ± 0.6% | 318.4 ± 0.7% | 1374.7 ± 1.9% | 961.1 ± 0.8% | 4.977 | 3.351 | 33.108 | 7.669 | 10.970 |
| string: canterbury/lcet10.txt | 441884 | 12216.2 ± 0.7% | 3101.7 ± 0.5% | 2654.9 ± 0.6% | 369.0 ± 3.2% | 1677.3 ± 1.4% | 1200.2 ± 0.7% | 3.939 | 4.601 | 33.107 | 7.283 | 10.179 |
| string: canterbury/plrabn12.txt | 503330 | 8319.0 ± 2.3% | 2327.6 ± 0.7% | 2173.6 ± 1.4% | 349.0 ± 1.4% | 1648.2 ± 1.4% | 1121.6 ± 2.4% | 3.574 | 3.827 | 23.836 | 5.047 | 7.417 |
| string: canterbury-large/E.coli | 1048578 | 31591.8 ± 0.8% | 16204.5 ± 2.2% | 3466.7 ± 0.8% | 1700.3 ± 0.5% | 3161.3 ± 0.9% | 1419.5 ± 0.8% | 1.950 | 9.113 | 18.580 | 9.993 | 22.255 |
| string: canterbury-large/bible.txt | 1055886 | 9321.1 ± 0.7% | 4896.0 ± 1.9% | 3034.1 ± 0.9% | 404.6 ± 1.2% | 2147.2 ± 0.7% | 1489.4 ± 0.6% | 1.904 | 3.072 | 23.037 | 4.341 | 6.258 |
| string: canterbury-large/world192.txt | 1103121 | 6599.6 ± 1.1% | 1743.0 ± 1.2% | 2004.2 ± 0.9% | 347.9 ± 0.8% | 1379.2 ± 0.7% | 959.3 ± 1.0% | 3.786 | 3.293 | 18.968 | 4.785 | 6.880 |
| string: http/html-1m | 1058582 | 10234.2 ± 0.9% | 4396.8 ± 0.9% | 2919.6 ± 0.4% | 418.6 ± 2.7% | 2165.1 ± 0.5% | 846.4 ± 1.5% | 2.328 | 3.505 | 24.447 | 4.727 | 12.091 |
| string: http/json-1m | 1190272 | 8654.2 ± 0.8% | 1587.7 ± 0.3% | 1966.8 ± 0.5% | 556.4 ± 0.7% | 1186.8 ± 1.2% | 845.3 ± 1.8% | 5.451 | 4.400 | 15.555 | 7.292 | 10.239 |
| string: http/js-1m | 1144362 | 6563.0 ± 0.9% | 1122.3 ± 0.3% | 1529.9 ± 0.7% | 331.1 ± 0.5% | 1110.6 ± 1.2% | 757.0 ± 2.5% | 5.848 | 4.290 | 19.822 | 5.909 | 8.670 |
| string: http/css-1m | 1097820 | 9160.0 ± 0.3% | 1488.0 ± 0.2% | 2366.9 ± 0.8% | 508.2 ± 0.6% | 1274.4 ± 0.8% | 882.7 ± 3.0% | 6.156 | 3.870 | 18.023 | 7.188 | 10.377 |
| string: dickens as Cyrillic and CJK | 1883069 | 5506.2 ± 0.6% | 3651.8 ± 0.5% | 502.1 ± 0.4% | 247.1 ± 0.3% | 453.0 ± 0.3% | 357.4 ± 0.5% | 1.508 | 10.966 | 22.285 | 12.154 | 15.407 |
| hex: silesia/dickens | 524290 | 43490.3 ± 0.7% | 2580.5 ± 0.5% | 1507.9 ± 0.3% | 460.5 ± 0.7% | 1473.7 ± 5.8% | 1064.2 ± 0.4% | 16.853 | 28.841 | 94.434 | 29.511 | 40.867 |
| hex: silesia/mozilla | 524290 | 43658.3 ± 0.3% | 2581.9 ± 0.4% | 1509.5 ± 0.6% | 385.0 ± 1.5% | 1561.3 ± 3.9% | 1067.8 ± 0.3% | 16.910 | 28.922 | 113.388 | 27.963 | 40.887 |
| hex: silesia/mr | 524290 | 43646.3 ± 0.1% | 2573.0 ± 0.7% | 1504.9 ± 5.2% | 594.9 ± 2.3% | 1548.3 ± 0.4% | 1067.3 ± 0.4% | 16.963 | 29.003 | 73.371 | 28.190 | 40.895 |
| hex: silesia/nci | 524290 | 43681.5 ± 0.3% | 2380.7 ± 8.7% | 1508.6 ± 0.2% | 755.7 ± 0.3% | 1556.4 ± 0.3% | 1065.7 ± 0.3% | 18.349 | 28.955 | 57.800 | 28.067 | 40.988 |
| hex: silesia/ooffice | 524290 | 43463.3 ± 0.4% | 2594.9 ± 0.2% | 1516.7 ± 0.3% | 322.4 ± 1.4% | 1552.0 ± 0.2% | 1067.5 ± 0.7% | 16.750 | 28.657 | 134.813 | 28.005 | 40.714 |
| hex: silesia/osdb | 524290 | 43744.4 ± 3.9% | 2597.7 ± 0.1% | 1516.8 ± 0.2% | 429.7 ± 0.8% | 1568.4 ± 0.3% | 1067.7 ± 1.0% | 16.840 | 28.840 | 101.791 | 27.891 | 40.972 |
| hex: silesia/reymont | 524290 | 43604.2 ± 0.4% | 2594.0 ± 0.2% | 1512.8 ± 0.3% | 485.4 ± 0.2% | 1570.4 ± 0.1% | 1069.6 ± 0.2% | 16.810 | 28.823 | 89.830 | 27.766 | 40.768 |
| hex: silesia/samba | 524290 | 43635.1 ± 0.2% | 2598.2 ± 0.2% | 1516.8 ± 0.1% | 337.9 ± 0.5% | 1570.5 ± 0.1% | 1068.7 ± 0.1% | 16.794 | 28.769 | 129.146 | 27.785 | 40.830 |
| hex: silesia/sao | 524290 | 43777.5 ± 0.1% | 2594.3 ± 0.2% | 1516.7 ± 0.4% | 268.9 ± 2.8% | 1574.9 ± 0.2% | 1070.2 ± 0.5% | 16.874 | 28.864 | 162.795 | 27.796 | 40.906 |
| hex: silesia/webster | 524290 | 43968.6 ± 0.1% | 2597.5 ± 0.1% | 1516.2 ± 0.1% | 435.8 ± 0.2% | 1565.0 ± 0.3% | 1068.3 ± 0.1% | 16.927 | 28.998 | 100.884 | 28.095 | 41.157 |
| hex: silesia/x-ray | 524290 | 43732.3 ± 0.1% | 2596.9 ± 1.0% | 1516.0 ± 0.9% | 423.7 ± 0.4% | 1572.3 ± 0.1% | 1069.3 ± 5.7% | 16.840 | 28.848 | 103.204 | 27.815 | 40.899 |
| hex: silesia/xml | 524290 | 43444.4 ± 0.2% | 2595.3 ± 0.3% | 1516.7 ± 0.2% | 690.9 ± 0.7% | 1570.2 ± 0.1% | 1066.9 ± 0.0% | 16.740 | 28.644 | 62.881 | 27.668 | 40.719 |
| hex: canterbury/alice29.txt | 304180 | 43714.2 ± 0.4% | 2611.9 ± 0.4% | 1534.2 ± 0.4% | 469.6 ± 2.6% | 1589.1 ± 9.6% | 1089.9 ± 0.2% | 16.736 | 28.493 | 93.092 | 27.509 | 40.109 |
| hex: canterbury/asyoulik.txt | 250360 | 43058.1 ± 7.7% | 2615.1 ± 0.2% | 1547.3 ± 0.1% | 458.4 ± 0.2% | 1589.8 ± 0.0% | 1088.9 ± 0.3% | 16.465 | 27.828 | 93.939 | 27.084 | 39.543 |
| hex: canterbury/cp.html | 49208 | 42657.5 ± 0.2% | 2595.8 ± 0.3% | 1538.3 ± 0.3% | 481.3 ± 1.4% | 1589.7 ± 0.2% | 1094.0 ± 0.8% | 16.433 | 27.731 | 88.627 | 26.834 | 38.992 |
| hex: canterbury/fields.c | 22302 | 42614.8 ± 0.2% | 2644.2 ± 7.1% | 1551.4 ± 0.2% | 599.8 ± 0.3% | 1603.9 ± 8.4% | 1101.5 ± 0.2% | 16.116 | 27.468 | 71.048 | 26.569 | 38.689 |
| hex: canterbury/grammar.lsp | 7444 | 40170.3 ± 0.2% | 2672.5 ± 0.2% | 1563.8 ± 0.2% | 815.0 ± 0.3% | 1603.1 ± 0.2% | 1109.7 ± 0.3% | 15.031 | 25.688 | 49.290 | 25.058 | 36.201 |
| hex: canterbury/kennedy.xls | 524290 | 43645.4 ± 0.5% | 2579.1 ± 0.5% | 1510.3 ± 0.9% | 788.9 ± 0.5% | 1565.7 ± 0.2% | 1066.6 ± 0.8% | 16.923 | 28.899 | 55.322 | 27.875 | 40.921 |
| hex: canterbury/lcet10.txt | 524290 | 43686.5 ± 0.1% | 2592.9 ± 0.2% | 1514.8 ± 0.4% | 469.1 ± 0.2% | 1565.8 ± 0.5% | 1067.5 ± 0.9% | 16.849 | 28.839 | 93.129 | 27.900 | 40.926 |
| hex: canterbury/plrabn12.txt | 524290 | 42828.0 ± 0.1% | 2597.7 ± 0.3% | 1514.5 ± 5.1% | 455.1 ± 0.1% | 1575.6 ± 0.5% | 1069.2 ± 0.4% | 16.487 | 28.278 | 94.109 | 27.182 | 40.055 |
| hex: canterbury/ptt5 | 524290 | 43831.2 ± 0.1% | 2409.7 ± 9.0% | 1509.1 ± 1.3% | 596.0 ± 1.2% | 1558.8 ± 0.2% | 1069.0 ± 0.6% | 18.190 | 29.044 | 73.537 | 28.118 | 41.001 |
| hex: canterbury/sum | 76482 | 43013.9 ± 0.2% | 2591.2 ± 0.1% | 1527.8 ± 0.3% | 560.9 ± 3.6% | 1581.4 ± 0.3% | 1090.3 ± 0.8% | 16.600 | 28.155 | 76.690 | 27.200 | 39.452 |
| hex: canterbury/xargs.1 | 8456 | 40640.5 ± 2.0% | 2673.8 ± 0.4% | 1566.6 ± 0.4% | 840.2 ± 0.3% | 1605.5 ± 2.2% | 1114.8 ± 3.8% | 15.199 | 25.941 | 48.370 | 25.313 | 36.456 |
| hex: canterbury-large/E.coli | 524290 | 43816.9 ± 0.1% | 2585.8 ± 0.2% | 1509.2 ± 0.2% | 816.5 ± 0.1% | 1566.1 ± 0.1% | 1069.4 ± 0.2% | 16.945 | 29.034 | 53.666 | 27.979 | 40.975 |
| hex: canterbury-large/bible.txt | 524290 | 43812.3 ± 0.2% | 2596.8 ± 0.2% | 1514.3 ± 0.2% | 483.3 ± 0.3% | 1570.6 ± 0.4% | 1068.2 ± 1.9% | 16.872 | 28.933 | 90.652 | 27.895 | 41.013 |
| hex: canterbury-large/world192.txt | 524290 | 43642.5 ± 0.2% | 2590.4 ± 0.6% | 1513.5 ± 0.3% | 459.7 ± 0.2% | 1567.1 ± 5.8% | 1068.2 ± 0.2% | 16.848 | 28.835 | 94.929 | 27.848 | 40.855 |
| hex: http/html-1kx1024 | 2099200 | 21167.6 ± 0.3% | 2320.5 ± 1.8% | 1470.9 ± 0.5% | 501.3 ± 4.3% | 1486.2 ± 1.1% | 1079.5 ± 0.1% | 9.122 | 14.391 | 42.223 | 14.243 | 19.608 |
| hex: http/html-16kx64 | 2097280 | 21809.4 ± 0.4% | 2232.5 ± 0.1% | 1461.8 ± 0.1% | 505.0 ± 0.2% | 1448.0 ± 0.0% | 1088.7 ± 0.3% | 9.769 | 14.919 | 43.189 | 15.062 | 20.032 |
| hex: http/html-1m | 524290 | 43790.6 ± 0.2% | 2594.1 ± 0.2% | 1515.5 ± 0.2% | 492.2 ± 0.4% | 1572.6 ± 0.2% | 1066.6 ± 0.2% | 16.881 | 28.895 | 88.975 | 27.847 | 41.055 |
| hex: http/json-1kx1024 | 2099200 | 20968.6 ± 0.2% | 2318.4 ± 1.4% | 1473.2 ± 0.3% | 697.5 ± 0.1% | 1484.5 ± 0.3% | 1079.9 ± 0.2% | 9.044 | 14.234 | 30.062 | 14.125 | 19.417 |
| hex: http/json-16kx64 | 2097280 | 21668.2 ± 0.8% | 2227.1 ± 0.2% | 1459.4 ± 0.1% | 706.7 ± 0.2% | 1445.1 ± 0.1% | 1087.7 ± 0.2% | 9.729 | 14.847 | 30.663 | 14.994 | 19.922 |
| hex: http/json-1m | 524290 | 43441.8 ± 0.1% | 2586.9 ± 0.5% | 1510.5 ± 0.3% | 727.4 ± 0.5% | 1528.8 ± 6.1% | 1068.6 ± 0.9% | 16.793 | 28.761 | 59.726 | 28.416 | 40.654 |
| hex: http/js-1kx1024 | 2099200 | 20756.0 ± 0.3% | 2326.5 ± 1.5% | 1474.6 ± 0.4% | 491.0 ± 0.7% | 1489.2 ± 1.4% | 1079.9 ± 0.4% | 8.922 | 14.076 | 42.276 | 13.938 | 19.220 |
| hex: http/js-16kx64 | 2097280 | 21584.8 ± 0.3% | 2228.7 ± 0.4% | 1461.3 ± 0.1% | 493.1 ± 0.1% | 1447.6 ± 5.0% | 1085.5 ± 0.3% | 9.685 | 14.771 | 43.776 | 14.911 | 19.884 |
| hex: http/js-1m | 524290 | 43719.8 ± 0.4% | 2580.3 ± 0.1% | 1517.6 ± 5.6% | 505.4 ± 2.2% | 1566.1 ± 6.1% | 1068.8 ± 0.2% | 16.944 | 28.809 | 86.508 | 27.915 | 40.907 |
| hex: http/css-1kx1024 | 2099200 | 20637.9 ± 0.2% | 2301.6 ± 1.9% | 1476.2 ± 2.9% | 558.0 ± 3.2% | 1483.3 ± 1.1% | 1080.3 ± 0.2% | 8.967 | 13.981 | 36.987 | 13.914 | 19.103 |
| hex: http/css-16kx64 | 2097280 | 22153.0 ± 0.3% | 2231.0 ± 1.0% | 1461.5 ± 0.1% | 565.0 ± 0.1% | 1448.3 ± 0.1% | 1086.8 ± 0.4% | 9.930 | 15.157 | 39.209 | 15.296 | 20.384 |
| hex: http/css-1m | 524290 | 43684.3 ± 0.0% | 2596.1 ± 0.2% | 1515.8 ± 0.1% | 534.7 ± 0.2% | 1531.3 ± 0.1% | 1069.5 ± 0.2% | 16.827 | 28.820 | 81.702 | 28.527 | 40.847 |
| hex: shuffled/dickens-1m | 524290 | 43861.7 ± 7.9% | 2590.6 ± 0.2% | 1510.4 ± 0.1% | 463.3 ± 0.2% | 1564.4 ± 0.1% | 1069.3 ± 0.2% | 16.931 | 29.041 | 94.664 | 28.037 | 41.021 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding: stdx runs at 0.908 of simdjson.
- qlog records, JSON text sequence, decoding: stdx runs at 0.878 of simdjson.
- messages: 11 string members, decoding: stdx runs at 0.526 of simdjson.
- messages: 50 nested objects, decoding: stdx runs at 0.770 of simdjson.
- messages: 50 nested objects, decoding: stdx runs at 0.928 of yyjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.757 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.816 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.918 of yyjson.
- messages: 11 string members, decoding through TextReader.next: stdx runs at 0.483 of simdjson.
- messages: 50 nested objects, decoding through TextReader.next: stdx runs at 0.709 of simdjson.
- messages: 50 nested objects, decoding through TextReader.next: stdx runs at 0.855 of yyjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next_items: stdx runs at 0.844 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next_items: stdx runs at 0.917 of simdjson.
- messages: 11 string members, decoding through TextReader.next_items: stdx runs at 0.509 of simdjson.
- messages: 50 nested objects, decoding through TextReader.next_items: stdx runs at 0.745 of simdjson.
- messages: 50 nested objects, decoding through TextReader.next_items: stdx runs at 0.898 of yyjson.
- messages: 50 nested objects, encoding through TextWriter's methods: stdx runs at 0.908 of simdjson.
