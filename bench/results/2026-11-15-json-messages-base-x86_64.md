# bench-json

| Field | Value |
|---|---|
| Commit | 22f5139 |
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
| CLDR supplemental, 34 texts | 920675 | 1378.8 ± 0.6% | 0.491 | 1.024 | 1.067 | 1.069 | 0.412 | 1.073 | 1.070 | 0.371 | 0.835 | 0.951 | 0.107 |
| qlog records, JSON text sequence | 1467503 | 1093.5 ± 1.4% | 0.795 | 1.067 | 1.067 | 1.065 | 0.395 | 1.069 | 1.068 | 0.367 | 0.929 | 1.080 | 0.127 |
| string: silesia/dickens | 172528 | 6457.4 ± 1.7% | 0.030 | 0.716 | 1.134 | 1.131 | 0.203 | 1.066 | 1.147 | 0.203 | 1.005 | 1.015 | 0.030 |
| string: silesia/nci | 1075110 | 5395.6 ± 1.2% | 0.035 | 0.709 | 1.038 | 1.034 | 0.286 | 1.043 | 1.035 | 0.286 | 1.008 | 1.014 | 0.036 |
| string: silesia/reymont | 1075159 | 3506.6 ± 3.5% | 0.055 | 0.627 | 0.875 | 0.871 | 0.344 | 0.820 | 0.872 | 0.345 | 0.982 | 0.998 | 0.055 |
| string: silesia/samba | 97582 | 3974.4 ± 0.8% | 0.041 | 0.902 | 1.059 | 1.060 | 0.074 | 0.851 | 1.064 | 0.074 | 1.008 | 1.007 | 0.041 |
| string: silesia/webster | 1098490 | 4385.8 ± 0.8% | 0.043 | 0.649 | 0.976 | 0.984 | 0.211 | 0.924 | 0.991 | 0.212 | 1.001 | 1.009 | 0.042 |
| string: silesia/xml | 1090118 | 5972.6 ± 0.1% | 0.032 | 0.784 | 0.971 | 0.977 | 0.246 | 0.966 | 0.980 | 0.245 | 1.002 | 1.009 | 0.032 |
| string: canterbury/alice29.txt | 159425 | 5723.7 ± 1.3% | 0.033 | 0.754 | 1.080 | 1.127 | 0.173 | 1.018 | 1.156 | 0.172 | 1.000 | 1.004 | 0.033 |
| string: canterbury/asyoulik.txt | 132198 | 4272.6 ± 0.3% | 0.043 | 0.808 | 1.138 | 1.131 | 0.190 | 1.061 | 1.132 | 0.190 | 0.993 | 0.996 | 0.043 |
| string: canterbury/lcet10.txt | 441884 | 6634.2 ± 0.7% | 0.029 | 0.607 | 1.098 | 1.105 | 0.188 | 1.040 | 1.112 | 0.189 | 0.996 | 1.003 | 0.029 |
| string: canterbury/plrabn12.txt | 503330 | 5446.8 ± 0.5% | 0.035 | 0.772 | 0.969 | 0.973 | 0.212 | 0.870 | 0.976 | 0.213 | 1.004 | 1.004 | 0.035 |
| string: canterbury-large/E.coli | 1048578 | 30365.1 ± 0.9% | 0.059 | 1.003 | 0.766 | 1.002 | 0.525 | 1.004 | 1.004 | 0.526 | 1.118 | 1.115 | 0.007 |
| string: canterbury-large/bible.txt | 1055886 | 8474.3 ± 1.8% | 0.024 | 0.628 | 0.880 | 0.884 | 0.387 | 0.889 | 0.898 | 0.383 | 1.004 | 1.007 | 0.024 |
| string: canterbury-large/world192.txt | 1103121 | 4136.6 ± 1.1% | 0.046 | 0.692 | 0.976 | 0.984 | 0.205 | 0.929 | 0.987 | 0.205 | 1.004 | 1.012 | 0.046 |
| string: http/html-1m | 1058582 | 9069.2 ± 3.8% | 0.022 | 0.563 | 0.785 | 0.788 | 0.314 | 0.754 | 0.798 | 0.315 | 0.958 | 1.029 | 0.022 |
| string: http/json-1m | 1190272 | 3328.5 ± 1.1% | 0.052 | 0.394 | 0.442 | 0.440 | 0.142 | 0.455 | 0.439 | 0.142 | 1.005 | 1.002 | 0.052 |
| string: http/js-1m | 1144362 | 2857.1 ± 1.1% | 0.062 | 0.694 | 0.892 | 0.917 | 0.183 | 0.843 | 0.917 | 0.184 | 1.007 | 1.011 | 0.062 |
| string: http/css-1m | 1097820 | 3291.2 ± 1.1% | 0.055 | 0.771 | 0.959 | 0.992 | 0.280 | 0.961 | 0.993 | 0.280 | 1.003 | 1.007 | 0.055 |
| string: dickens as Cyrillic and CJK | 1883069 | 5834.4 ± 0.4% | 0.025 | 0.059 | 0.440 | 0.440 | 0.195 | 0.432 | 0.439 | 0.195 | 1.000 | 1.002 | 0.025 |
| string: dickens as Cyrillic and CJK, as \u escapes | 5075485 | 1194.3 ± 1.4% | 0.113 | 1.000 | 1.001 | 1.001 | 0.107 | 0.714 | 1.002 | 0.107 | 1.007 | 1.007 | 0.112 |
| hex: silesia/dickens | 524290 | 46073.2 ± 1.1% | 0.040 | 1.001 | 0.620 | 1.002 | 0.391 | 1.001 | 1.003 | 0.392 | 0.736 | 0.736 | 0.005 |
| hex: silesia/mozilla | 524290 | 45355.7 ± 1.9% | 0.040 | 0.994 | 0.630 | 0.997 | 0.392 | 1.002 | 0.996 | 0.393 | 0.743 | 0.743 | 0.005 |
| hex: silesia/mr | 524290 | 43729.4 ± 0.5% | 0.041 | 0.995 | 0.616 | 1.000 | 0.388 | 0.999 | 0.999 | 0.390 | 0.771 | 0.769 | 0.005 |
| hex: silesia/nci | 524290 | 46169.6 ± 1.5% | 0.040 | 0.997 | 0.614 | 1.001 | 0.390 | 0.996 | 1.001 | 0.390 | 0.733 | 0.732 | 0.005 |
| hex: silesia/ooffice | 524290 | 46011.9 ± 0.7% | 0.040 | 0.998 | 0.616 | 1.002 | 0.388 | 1.001 | 1.002 | 0.389 | 0.736 | 0.734 | 0.005 |
| hex: silesia/osdb | 524290 | 44466.6 ± 1.0% | 0.041 | 0.996 | 0.629 | 0.995 | 0.390 | 0.992 | 0.992 | 0.392 | 0.759 | 0.760 | 0.005 |
| hex: silesia/reymont | 524290 | 45719.9 ± 0.5% | 0.040 | 1.000 | 0.627 | 0.998 | 0.393 | 0.995 | 1.000 | 0.393 | 0.739 | 0.739 | 0.005 |
| hex: silesia/samba | 524290 | 46563.8 ± 2.4% | 0.039 | 0.997 | 0.610 | 0.998 | 0.386 | 0.996 | 0.999 | 0.385 | 0.727 | 0.727 | 0.005 |
| hex: silesia/sao | 524290 | 48273.4 ± 0.5% | 0.038 | 0.994 | 0.589 | 0.998 | 0.373 | 0.995 | 0.999 | 0.374 | 0.702 | 0.700 | 0.004 |
| hex: silesia/webster | 524290 | 46324.2 ± 0.8% | 0.039 | 0.998 | 0.607 | 1.000 | 0.387 | 0.999 | 1.000 | 0.388 | 0.730 | 0.730 | 0.005 |
| hex: silesia/x-ray | 524290 | 45830.3 ± 0.7% | 0.040 | 0.992 | 0.612 | 0.991 | 0.392 | 0.996 | 0.996 | 0.393 | 0.740 | 0.739 | 0.005 |
| hex: silesia/xml | 524290 | 45749.8 ± 0.3% | 0.040 | 0.995 | 0.626 | 0.997 | 0.395 | 0.999 | 0.998 | 0.395 | 0.739 | 0.740 | 0.005 |
| hex: canterbury/alice29.txt | 304180 | 45664.6 ± 0.3% | 0.040 | 1.000 | 0.627 | 1.000 | 0.391 | 1.000 | 1.000 | 0.391 | 0.739 | 0.741 | 0.005 |
| hex: canterbury/asyoulik.txt | 250360 | 45789.4 ± 0.3% | 0.040 | 0.998 | 0.612 | 0.999 | 0.393 | 0.999 | 0.998 | 0.393 | 0.738 | 0.738 | 0.005 |
| hex: canterbury/cp.html | 49208 | 46463.3 ± 0.4% | 0.039 | 1.002 | 0.599 | 1.002 | 0.380 | 1.003 | 1.003 | 0.383 | 0.720 | 0.720 | 0.005 |
| hex: canterbury/fields.c | 22302 | 49400.9 ± 0.6% | 0.038 | 1.026 | 0.555 | 1.010 | 0.402 | 1.004 | 1.014 | 0.409 | 0.668 | 0.668 | 0.004 |
| hex: canterbury/grammar.lsp | 7444 | 44022.8 ± 0.6% | 0.042 | 0.974 | 0.580 | 1.011 | 0.412 | 0.995 | 1.010 | 0.433 | 0.680 | 0.677 | 0.005 |
| hex: canterbury/kennedy.xls | 524290 | 46670.6 ± 1.8% | 0.039 | 0.994 | 0.611 | 0.998 | 0.386 | 0.997 | 0.998 | 0.387 | 0.728 | 0.728 | 0.005 |
| hex: canterbury/lcet10.txt | 524290 | 45695.7 ± 1.5% | 0.040 | 0.998 | 0.624 | 1.000 | 0.396 | 1.000 | 1.000 | 0.396 | 0.744 | 0.744 | 0.005 |
| hex: canterbury/plrabn12.txt | 524290 | 46833.0 ± 0.3% | 0.039 | 0.995 | 0.611 | 0.997 | 0.377 | 0.997 | 0.997 | 0.377 | 0.725 | 0.725 | 0.005 |
| hex: canterbury/ptt5 | 524290 | 46551.0 ± 0.2% | 0.039 | 0.996 | 0.606 | 0.998 | 0.386 | 0.998 | 0.998 | 0.387 | 0.729 | 0.729 | 0.005 |
| hex: canterbury/sum | 76482 | 46142.6 ± 0.6% | 0.040 | 1.002 | 0.602 | 1.001 | 0.385 | 1.003 | 1.002 | 0.388 | 0.723 | 0.723 | 0.005 |
| hex: canterbury/xargs.1 | 8456 | 44868.3 ± 1.0% | 0.041 | 0.982 | 0.576 | 1.014 | 0.414 | 0.993 | 1.011 | 0.433 | 0.677 | 0.675 | 0.005 |
| hex: canterbury-large/E.coli | 524290 | 45720.4 ± 0.1% | 0.040 | 0.999 | 0.628 | 1.000 | 0.396 | 0.999 | 1.000 | 0.396 | 0.743 | 0.744 | 0.005 |
| hex: canterbury-large/bible.txt | 524290 | 46492.7 ± 1.0% | 0.039 | 0.999 | 0.606 | 0.998 | 0.386 | 0.999 | 1.000 | 0.387 | 0.731 | 0.731 | 0.005 |
| hex: canterbury-large/world192.txt | 524290 | 46721.5 ± 0.3% | 0.039 | 0.995 | 0.615 | 0.995 | 0.387 | 0.995 | 0.995 | 0.387 | 0.727 | 0.727 | 0.005 |
| hex: http/html-1kx1024 | 2099200 | 18021.9 ± 1.9% | 0.100 | 1.045 | 0.809 | 1.009 | 0.576 | 1.016 | 1.008 | 0.638 | 0.861 | 0.843 | 0.012 |
| hex: http/html-16kx64 | 2097280 | 34867.9 ± 0.5% | 0.052 | 1.004 | 0.685 | 1.004 | 0.469 | 1.003 | 1.004 | 0.474 | 0.803 | 0.803 | 0.006 |
| hex: http/html-1m | 524290 | 45823.9 ± 0.1% | 0.040 | 0.997 | 0.626 | 0.997 | 0.391 | 0.997 | 0.998 | 0.392 | 0.742 | 0.742 | 0.005 |
| hex: http/json-1kx1024 | 2099200 | 18352.9 ± 1.9% | 0.099 | 1.047 | 0.803 | 1.004 | 0.589 | 1.010 | 1.000 | 0.652 | 0.858 | 0.838 | 0.011 |
| hex: http/json-16kx64 | 2097280 | 35129.8 ± 0.7% | 0.052 | 1.004 | 0.683 | 1.004 | 0.467 | 1.003 | 1.004 | 0.471 | 0.801 | 0.801 | 0.006 |
| hex: http/json-1m | 524290 | 46290.2 ± 0.1% | 0.040 | 0.997 | 0.618 | 0.998 | 0.391 | 0.998 | 0.998 | 0.391 | 0.735 | 0.734 | 0.005 |
| hex: http/js-1kx1024 | 2099200 | 17935.1 ± 1.9% | 0.101 | 1.060 | 0.813 | 1.003 | 0.600 | 1.013 | 1.007 | 0.664 | 0.866 | 0.848 | 0.012 |
| hex: http/js-16kx64 | 2097280 | 34288.1 ± 0.4% | 0.053 | 1.005 | 0.694 | 1.003 | 0.475 | 1.004 | 1.004 | 0.480 | 0.818 | 0.817 | 0.006 |
| hex: http/js-1m | 524290 | 46723.6 ± 0.5% | 0.039 | 0.996 | 0.613 | 0.998 | 0.387 | 0.997 | 0.998 | 0.387 | 0.728 | 0.728 | 0.005 |
| hex: http/css-1kx1024 | 2099200 | 17878.6 ± 2.7% | 0.101 | 1.065 | 0.814 | 1.002 | 0.598 | 1.012 | 0.998 | 0.661 | 0.866 | 0.848 | 0.012 |
| hex: http/css-16kx64 | 2097280 | 34327.7 ± 0.9% | 0.053 | 1.004 | 0.694 | 1.004 | 0.475 | 1.004 | 1.004 | 0.479 | 0.810 | 0.809 | 0.006 |
| hex: http/css-1m | 524290 | 45924.1 ± 0.4% | 0.040 | 0.997 | 0.610 | 0.997 | 0.393 | 0.997 | 0.997 | 0.394 | 0.740 | 0.740 | 0.005 |
| hex: shuffled/dickens-1m | 524290 | 45831.7 ± 0.2% | 0.040 | 0.995 | 0.626 | 0.996 | 0.390 | 0.996 | 0.996 | 0.390 | 0.742 | 0.742 | 0.005 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1766.0 ± 1.2% | 0.424 | 1.000 | 0.974 | 1.012 | 1.009 | 0.269 | 1.010 | 0.518 | 0.902 | 0.093 | 1.035 |
| qlog records, JSON text sequence | 1467503 | 1695.8 ± 0.6% | 0.626 | 0.948 | 0.966 | 0.994 | 0.979 | 0.230 | 0.975 | 0.441 | 0.862 | 0.104 | 1.024 |
| string: silesia/dickens | 172528 | 12133.6 ± 1.0% | 0.019 | 0.569 | 0.387 | 0.554 | 0.593 | 0.125 | 0.598 | 1.004 | 1.004 | 0.019 | 1.114 |
| string: silesia/nci | 1075110 | 10949.4 ± 0.5% | 0.021 | 0.544 | 0.376 | 0.554 | 0.544 | 0.187 | 0.544 | 1.007 | 1.005 | 0.020 | 1.071 |
| string: silesia/reymont | 1075159 | 5268.4 ± 1.2% | 0.043 | 0.579 | 0.440 | 0.577 | 0.582 | 0.271 | 0.580 | 0.998 | 1.007 | 0.043 | 1.030 |
| string: silesia/samba | 97582 | 6261.7 ± 0.4% | 0.045 | 0.896 | 0.749 | 0.909 | 0.900 | 0.118 | 0.903 | 1.000 | 1.001 | 0.045 | 1.171 |
| string: silesia/webster | 1098490 | 6615.3 ± 0.6% | 0.034 | 0.613 | 0.426 | 0.589 | 0.617 | 0.163 | 0.612 | 1.001 | 1.005 | 0.034 | 1.054 |
| string: silesia/xml | 1090118 | 9893.2 ± 0.5% | 0.023 | 0.608 | 0.505 | 0.604 | 0.610 | 0.208 | 0.611 | 1.002 | 1.008 | 0.023 | 1.149 |
| string: canterbury/alice29.txt | 159425 | 10764.3 ± 3.4% | 0.021 | 0.522 | 0.421 | 0.496 | 0.547 | 0.106 | 0.572 | 0.990 | 0.993 | 0.021 | 1.244 |
| string: canterbury/asyoulik.txt | 132198 | 10166.8 ± 3.6% | 0.021 | 0.430 | 0.357 | 0.422 | 0.445 | 0.093 | 0.452 | 0.987 | 1.034 | 0.021 | 1.133 |
| string: canterbury/lcet10.txt | 441884 | 10514.0 ± 1.0% | 0.022 | 0.654 | 0.391 | 0.645 | 0.660 | 0.137 | 0.664 | 1.001 | 1.004 | 0.021 | 1.196 |
| string: canterbury/plrabn12.txt | 503330 | 7815.0 ± 3.8% | 0.029 | 0.701 | 0.563 | 0.700 | 0.701 | 0.175 | 0.702 | 1.006 | 1.008 | 0.028 | 1.132 |
| string: canterbury-large/E.coli | 1048578 | 30874.3 ± 0.6% | 0.058 | 1.001 | 1.001 | 0.782 | 1.003 | 0.524 | 1.002 | 1.002 | 1.001 | 0.008 | 1.002 |
| string: canterbury-large/bible.txt | 1055886 | 8903.4 ± 0.4% | 0.027 | 0.806 | 0.622 | 0.804 | 0.816 | 0.411 | 0.816 | 1.002 | 1.005 | 0.026 | 1.110 |
| string: canterbury-large/world192.txt | 1103121 | 6412.1 ± 0.2% | 0.035 | 0.612 | 0.441 | 0.590 | 0.617 | 0.154 | 0.618 | 1.002 | 1.003 | 0.035 | 1.017 |
| string: http/html-1m | 1058582 | 9949.0 ± 1.0% | 0.024 | 0.657 | 0.542 | 0.653 | 0.659 | 0.319 | 0.660 | 1.000 | 1.005 | 0.024 | 1.034 |
| string: http/json-1m | 1190272 | 8444.1 ± 0.4% | 0.024 | 0.184 | 0.160 | 0.184 | 0.184 | 0.072 | 0.184 | 1.000 | 1.003 | 0.024 | 1.016 |
| string: http/js-1m | 1144362 | 6371.5 ± 2.4% | 0.033 | 0.382 | 0.323 | 0.370 | 0.382 | 0.094 | 0.382 | 1.002 | 1.009 | 0.033 | 1.048 |
| string: http/css-1m | 1097820 | 8118.5 ± 5.2% | 0.027 | 0.409 | 0.327 | 0.397 | 0.409 | 0.138 | 0.409 | 1.003 | 1.007 | 0.027 | 1.178 |
| string: dickens as Cyrillic and CJK | 1883069 | 5508.1 ± 0.3% | 0.030 | 0.460 | 0.064 | 0.459 | 0.461 | 0.206 | 0.461 | 1.001 | 1.002 | 0.030 | 1.041 |
| hex: silesia/dickens | 524290 | 43751.7 ± 0.2% | 1.002 | 0.088 | 1.002 | 0.590 | 1.001 | 1.001 | 1.002 | 1.001 | 1.001 | 0.095 | 1.002 |
| hex: silesia/mozilla | 524290 | 43676.7 ± 0.2% | 1.002 | 0.088 | 1.000 | 0.590 | 1.000 | 0.999 | 1.001 | 1.000 | 1.000 | 0.094 | 1.000 |
| hex: silesia/mr | 524290 | 43801.4 ± 0.3% | 1.001 | 0.088 | 1.000 | 0.589 | 1.000 | 0.999 | 1.000 | 1.000 | 1.000 | 0.094 | 1.000 |
| hex: silesia/nci | 524290 | 43888.7 ± 0.1% | 1.001 | 0.088 | 1.001 | 0.588 | 1.000 | 0.999 | 1.000 | 1.000 | 0.998 | 0.095 | 1.000 |
| hex: silesia/ooffice | 524290 | 43785.8 ± 0.2% | 1.001 | 0.088 | 1.001 | 0.589 | 1.001 | 0.999 | 1.000 | 1.000 | 1.000 | 0.090 | 1.001 |
| hex: silesia/osdb | 524290 | 43798.6 ± 3.7% | 1.000 | 0.088 | 1.002 | 0.589 | 1.000 | 1.000 | 1.000 | 1.000 | 0.999 | 0.093 | 1.001 |
| hex: silesia/reymont | 524290 | 43007.9 ± 7.1% | 1.020 | 0.090 | 1.020 | 0.600 | 1.019 | 1.019 | 1.019 | 1.019 | 1.019 | 0.093 | 1.019 |
| hex: silesia/samba | 524290 | 43922.9 ± 0.2% | 0.999 | 0.088 | 1.001 | 0.587 | 1.000 | 0.999 | 0.999 | 0.999 | 0.999 | 0.094 | 1.000 |
| hex: silesia/sao | 524290 | 42853.5 ± 0.2% | 1.003 | 0.090 | 1.002 | 0.600 | 1.002 | 1.001 | 1.002 | 1.002 | 1.002 | 0.095 | 1.002 |
| hex: silesia/webster | 524290 | 44172.1 ± 0.1% | 1.000 | 0.087 | 1.001 | 0.586 | 1.000 | 0.999 | 0.999 | 0.999 | 0.999 | 0.091 | 1.000 |
| hex: silesia/x-ray | 524290 | 43844.2 ± 0.3% | 1.001 | 0.088 | 1.001 | 0.590 | 1.000 | 0.999 | 1.000 | 1.000 | 1.000 | 0.093 | 1.001 |
| hex: silesia/xml | 524290 | 43818.8 ± 0.1% | 1.001 | 0.088 | 1.001 | 0.589 | 1.000 | 1.000 | 1.000 | 1.000 | 1.000 | 0.092 | 1.001 |
| hex: canterbury/alice29.txt | 304180 | 43757.3 ± 0.0% | 1.001 | 0.088 | 1.001 | 0.589 | 1.002 | 1.001 | 1.002 | 1.002 | 1.001 | 0.095 | 1.002 |
| hex: canterbury/asyoulik.txt | 250360 | 43728.5 ± 0.1% | 1.000 | 0.088 | 1.000 | 0.590 | 0.999 | 0.998 | 0.999 | 0.999 | 0.999 | 0.095 | 0.999 |
| hex: canterbury/cp.html | 49208 | 42744.4 ± 0.1% | 1.000 | 0.090 | 1.000 | 0.594 | 1.000 | 0.993 | 1.001 | 0.999 | 1.001 | 0.097 | 1.002 |
| hex: canterbury/fields.c | 22302 | 41750.7 ± 0.2% | 1.001 | 0.092 | 1.000 | 0.603 | 1.002 | 0.988 | 1.002 | 1.003 | 1.009 | 0.100 | 1.003 |
| hex: canterbury/grammar.lsp | 7444 | 39559.1 ± 7.0% | 0.992 | 0.096 | 1.004 | 0.608 | 1.014 | 0.979 | 1.013 | 1.013 | 1.033 | 0.103 | 1.015 |
| hex: canterbury/kennedy.xls | 524290 | 41980.5 ± 7.4% | 1.001 | 0.092 | 1.001 | 0.608 | 1.000 | 0.999 | 1.000 | 1.000 | 0.999 | 0.099 | 1.000 |
| hex: canterbury/lcet10.txt | 524290 | 43700.0 ± 0.2% | 1.002 | 0.088 | 1.002 | 0.589 | 1.000 | 1.001 | 1.001 | 1.001 | 1.001 | 0.094 | 1.000 |
| hex: canterbury/plrabn12.txt | 524290 | 43767.5 ± 0.1% | 1.001 | 0.088 | 1.000 | 0.589 | 1.000 | 0.999 | 1.000 | 1.000 | 1.000 | 0.092 | 1.000 |
| hex: canterbury/ptt5 | 524290 | 43750.2 ± 7.6% | 1.002 | 0.088 | 1.002 | 0.590 | 1.001 | 1.000 | 1.001 | 1.001 | 1.001 | 0.093 | 1.001 |
| hex: canterbury/sum | 76482 | 43073.3 ± 0.1% | 1.001 | 0.089 | 1.000 | 0.593 | 1.000 | 0.997 | 1.001 | 1.001 | 1.002 | 0.096 | 1.001 |
| hex: canterbury/xargs.1 | 8456 | 40411.9 ± 0.2% | 1.002 | 0.094 | 1.001 | 0.600 | 1.002 | 0.949 | 1.002 | 0.985 | 1.021 | 0.101 | 1.004 |
| hex: canterbury-large/E.coli | 524290 | 43752.7 ± 0.5% | 1.001 | 0.088 | 1.002 | 0.590 | 1.001 | 1.001 | 1.002 | 1.001 | 0.998 | 0.092 | 1.002 |
| hex: canterbury-large/bible.txt | 524290 | 43798.9 ± 0.2% | 1.001 | 0.088 | 1.001 | 0.589 | 1.000 | 0.999 | 1.001 | 0.999 | 1.000 | 0.093 | 1.001 |
| hex: canterbury-large/world192.txt | 524290 | 43864.0 ± 0.4% | 1.001 | 0.088 | 1.001 | 0.588 | 0.999 | 1.000 | 1.001 | 1.000 | 1.000 | 0.094 | 1.000 |
| hex: http/html-1kx1024 | 2099200 | 21185.7 ± 1.4% | 1.002 | 0.174 | 1.004 | 0.944 | 1.004 | 1.000 | 1.003 | 1.004 | 1.008 | 0.181 | 1.005 |
| hex: http/html-16kx64 | 2097280 | 22099.0 ± 0.8% | 1.000 | 0.172 | 1.000 | 0.972 | 1.002 | 1.001 | 1.002 | 1.002 | 1.003 | 0.187 | 1.003 |
| hex: http/html-1m | 524290 | 40420.0 ± 0.4% | 1.002 | 0.095 | 1.001 | 0.637 | 0.999 | 1.000 | 0.998 | 1.000 | 1.000 | 0.100 | 1.001 |
| hex: http/json-1kx1024 | 2099200 | 20113.1 ± 0.6% | 1.002 | 0.183 | 1.002 | 0.973 | 1.002 | 1.003 | 1.003 | 1.003 | 1.004 | 0.190 | 1.004 |
| hex: http/json-16kx64 | 2097280 | 22066.2 ± 0.6% | 1.000 | 0.172 | 1.000 | 0.962 | 1.001 | 0.999 | 1.000 | 1.001 | 1.001 | 0.187 | 1.002 |
| hex: http/json-1m | 524290 | 43797.2 ± 0.1% | 1.001 | 0.088 | 1.001 | 0.589 | 1.000 | 0.997 | 1.000 | 1.000 | 1.000 | 0.094 | 1.000 |
| hex: http/js-1kx1024 | 2099200 | 20824.1 ± 0.4% | 1.001 | 0.177 | 1.002 | 0.951 | 1.003 | 1.000 | 1.003 | 1.002 | 1.006 | 0.184 | 1.005 |
| hex: http/js-16kx64 | 2097280 | 21939.6 ± 0.5% | 1.001 | 0.173 | 1.002 | 0.977 | 1.001 | 0.998 | 1.001 | 1.001 | 1.001 | 0.188 | 1.001 |
| hex: http/js-1m | 524290 | 42933.2 ± 0.2% | 1.002 | 0.090 | 1.004 | 0.601 | 1.002 | 1.002 | 1.002 | 1.005 | 1.002 | 0.096 | 1.002 |
| hex: http/css-1kx1024 | 2099200 | 20420.8 ± 1.9% | 1.002 | 0.180 | 1.002 | 0.964 | 1.002 | 1.000 | 1.002 | 1.001 | 1.005 | 0.188 | 1.003 |
| hex: http/css-16kx64 | 2097280 | 21599.2 ± 0.4% | 1.001 | 0.176 | 1.000 | 0.976 | 1.001 | 1.001 | 1.002 | 1.000 | 1.001 | 0.191 | 1.002 |
| hex: http/css-1m | 524290 | 43804.3 ± 0.1% | 1.001 | 0.088 | 1.001 | 0.590 | 1.000 | 0.999 | 1.000 | 0.999 | 1.000 | 0.091 | 0.998 |
| hex: shuffled/dickens-1m | 524290 | 43723.1 ± 0.1% | 1.001 | 0.088 | 1.000 | 0.590 | 1.000 | 1.000 | 1.000 | 0.999 | 1.000 | 0.095 | 1.000 |

## Losses

Each workload where a claim's path ran slower than the path it replaces by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding: J7 wide vectors off runs at 1.067 of all on.
- CLDR supplemental, 34 texts, decoding: J8 decoder fast path off runs at 1.069 of all on.
- CLDR supplemental, 34 texts, decoding: J12 decoder escape words off runs at 1.073 of all on.
- CLDR supplemental, 34 texts, decoding: J13 decoder escape blocks off runs at 1.070 of all on.
- qlog records, JSON text sequence, decoding: J5 UTF-8 vectors off runs at 1.067 of all on.
- qlog records, JSON text sequence, decoding: J7 wide vectors off runs at 1.067 of all on.
- qlog records, JSON text sequence, decoding: J8 decoder fast path off runs at 1.065 of all on.
- qlog records, JSON text sequence, decoding: J12 decoder escape words off runs at 1.069 of all on.
- qlog records, JSON text sequence, decoding: J13 decoder escape blocks off runs at 1.068 of all on.
- string: silesia/dickens, decoding: J7 wide vectors off runs at 1.134 of all on.
- string: silesia/dickens, decoding: J8 decoder fast path off runs at 1.131 of all on.
- string: silesia/dickens, decoding: J12 decoder escape words off runs at 1.066 of all on.
- string: silesia/dickens, decoding: J13 decoder escape blocks off runs at 1.147 of all on.
- string: silesia/samba, decoding: J7 wide vectors off runs at 1.059 of all on.
- string: silesia/samba, decoding: J8 decoder fast path off runs at 1.060 of all on.
- string: silesia/samba, decoding: J13 decoder escape blocks off runs at 1.064 of all on.
- string: canterbury/alice29.txt, decoding: J7 wide vectors off runs at 1.080 of all on.
- string: canterbury/alice29.txt, decoding: J8 decoder fast path off runs at 1.127 of all on.
- string: canterbury/alice29.txt, decoding: J13 decoder escape blocks off runs at 1.156 of all on.
- string: canterbury/asyoulik.txt, decoding: J7 wide vectors off runs at 1.138 of all on.
- string: canterbury/asyoulik.txt, decoding: J8 decoder fast path off runs at 1.131 of all on.
- string: canterbury/asyoulik.txt, decoding: J12 decoder escape words off runs at 1.061 of all on.
- string: canterbury/asyoulik.txt, decoding: J13 decoder escape blocks off runs at 1.132 of all on.
- string: canterbury/lcet10.txt, decoding: J7 wide vectors off runs at 1.098 of all on.
- string: canterbury/lcet10.txt, decoding: J8 decoder fast path off runs at 1.105 of all on.
- string: canterbury/lcet10.txt, decoding: J13 decoder escape blocks off runs at 1.112 of all on.
- hex: http/js-1kx1024, decoding: J5 UTF-8 vectors off runs at 1.060 of all on.
- hex: http/css-1kx1024, decoding: J5 UTF-8 vectors off runs at 1.065 of all on.

## UTF-8 validation against simdutf

stdx's `is_utf8`, the check the loops apply to every string's octets, run alone over each string workload's octets at the width the host's features pick (16 lanes on aarch64, AVX2's 32 or AVX-512's 64 on x86-64, decision 39), beside simdutf 9.3.3's `validate_utf8` in the same run; on a host with AVX-512, again with AVX2 alone. Each ratio is stdx's throughput over the other's. simdutf picks its kernel at run time. Before timing, every copy of the check and simdutf judged 20000 seeded buffers and each workload, whole and changed, alike.

| Workload | Octets | stdx, MB/s | simdutf, MB/s | stdx / simdutf | stdx with AVX2 alone, MB/s | stdx / stdx with AVX2 alone |
|---|---|---|---|---|---|---|
| string: silesia/dickens | 166668 | 168788.8 ± 0.2% | 122332.5 ± 0.1% | 1.380 | 100973.5 ± 0.2% | 1.672 |
| string: silesia/nci | 1048576 | 153598.3 ± 1.2% | 116661.5 ± 0.1% | 1.317 | 97246.0 ± 0.3% | 1.579 |
| string: silesia/reymont | 1048576 | 169930.8 ± 0.2% | 123006.4 ± 0.4% | 1.381 | 101561.1 ± 0.2% | 1.673 |
| string: silesia/samba | 65546 | 163806.6 ± 0.3% | 120573.3 ± 0.1% | 1.359 | 99848.3 ± 0.1% | 1.641 |
| string: silesia/webster | 1048576 | 168967.8 ± 0.8% | 122972.7 ± 0.1% | 1.374 | 101975.2 ± 0.1% | 1.657 |
| string: silesia/xml | 1048576 | 168733.0 ± 0.2% | 123061.0 ± 0.1% | 1.371 | 101445.9 ± 0.3% | 1.663 |
| string: canterbury/alice29.txt | 152089 | 168475.9 ± 0.2% | 122128.9 ± 0.7% | 1.379 | 100782.0 ± 0.2% | 1.672 |
| string: canterbury/asyoulik.txt | 125179 | 167969.7 ± 0.2% | 121814.4 ± 0.4% | 1.379 | 101040.5 ± 4.3% | 1.662 |
| string: canterbury/lcet10.txt | 426754 | 169643.6 ± 0.2% | 122862.6 ± 0.4% | 1.381 | 101720.1 ± 5.1% | 1.668 |
| string: canterbury/plrabn12.txt | 481861 | 169505.3 ± 5.3% | 122908.2 ± 0.1% | 1.379 | 101857.7 ± 0.1% | 1.664 |
| string: canterbury-large/E.coli | 1048576 | 169152.8 ± 9.5% | 122858.8 ± 0.4% | 1.377 | 101313.9 ± 0.0% | 1.670 |
| string: canterbury-large/bible.txt | 1048576 | 169318.6 ± 8.4% | 122845.1 ± 0.1% | 1.378 | 101961.6 ± 0.7% | 1.661 |
| string: canterbury-large/world192.txt | 1048576 | 168651.0 ± 0.5% | 122743.1 ± 0.0% | 1.374 | 101131.5 ± 4.3% | 1.668 |
| string: http/html-1m | 1048576 | 148192.9 ± 0.6% | 112395.3 ± 4.6% | 1.318 | 94349.3 ± 0.8% | 1.571 |
| string: http/json-1m | 1048576 | 122230.7 ± 0.4% | 106771.9 ± 3.9% | 1.145 | 82827.6 ± 1.3% | 1.476 |
| string: http/js-1m | 1048576 | 165494.0 ± 0.2% | 121692.7 ± 5.4% | 1.360 | 99934.2 ± 0.3% | 1.656 |
| string: http/css-1m | 1048576 | 168305.7 ± 7.9% | 122461.9 ± 0.7% | 1.374 | 100669.4 ± 0.4% | 1.672 |
| string: dickens as Cyrillic and CJK | 1847045 | 23858.6 ± 0.5% | 21140.8 ± 0.4% | 1.129 | 15104.5 ± 2.7% | 1.580 |

## Losses to simdutf

None.

## UTF-8 validation by the buffer's offset from a 64-octet line

| Buffer | Octets | Offset | stdx, MB/s | simdutf, MB/s | stdx / simdutf | stdx with AVX2 alone, MB/s | stdx / stdx with AVX2 alone |
|---|---|---|---|---|---|---|---|
| string: canterbury-large/bible.txt | 1048576 | 0 | 169950.9 ± 0.1% | 123101.0 ± 0.7% | 1.381 | 102045.7 ± 0.2% | 1.665 |
| string: canterbury-large/bible.txt | 1048576 | 1 | 170203.7 ± 1.5% | 123164.5 ± 0.2% | 1.382 | 101641.9 ± 0.1% | 1.675 |
| string: canterbury-large/bible.txt | 1048576 | 8 | 169645.9 ± 0.8% | 123165.5 ± 4.9% | 1.377 | 101620.9 ± 0.2% | 1.669 |
| string: canterbury-large/bible.txt | 1048576 | 16 | 170533.0 ± 0.2% | 123052.1 ± 0.3% | 1.386 | 101601.4 ± 0.2% | 1.678 |
| string: canterbury-large/bible.txt | 1048576 | 32 | 170236.5 ± 0.3% | 123164.8 ± 0.3% | 1.382 | 101679.5 ± 0.2% | 1.674 |
| string: canterbury-large/bible.txt | 1048576 | 48 | 170373.7 ± 0.3% | 123146.6 ± 0.1% | 1.384 | 102204.3 ± 0.3% | 1.667 |
| string: dickens as Cyrillic and CJK | 1048576 | 0 | 24369.1 ± 0.2% | 21783.8 ± 0.2% | 1.119 | 15364.5 ± 0.2% | 1.586 |
| string: dickens as Cyrillic and CJK | 1048576 | 1 | 24369.2 ± 0.0% | 21765.8 ± 0.1% | 1.120 | 15361.2 ± 0.2% | 1.586 |
| string: dickens as Cyrillic and CJK | 1048576 | 8 | 24384.0 ± 0.1% | 21768.8 ± 1.8% | 1.120 | 15345.4 ± 0.3% | 1.589 |
| string: dickens as Cyrillic and CJK | 1048576 | 16 | 24372.9 ± 0.2% | 21767.8 ± 1.8% | 1.120 | 15375.1 ± 0.2% | 1.585 |
| string: dickens as Cyrillic and CJK | 1048576 | 32 | 24369.2 ± 0.1% | 21774.6 ± 0.3% | 1.119 | 15359.9 ± 0.4% | 1.587 |
| string: dickens as Cyrillic and CJK | 1048576 | 48 | 24366.0 ± 0.1% | 21780.2 ± 0.4% | 1.119 | 15386.5 ± 0.1% | 1.584 |

## Against the baselines

stdx with every claim on, timed beside simdjson 5.1.1, yyjson 0.13.0, Zig 0.16.0's std.json, serde_json 1.0.154 and Go's encoding/json/jsontext in the same run. Each ratio is stdx's throughput over the baseline's; below 1, the baseline is faster. stdx is built for the architecture's baseline CPU in ReleaseSafe. Each baseline is built for the same CPU, the C, C++ and Zig ones in ReleaseFast (decision 75), and simdjson picks its kernel at run time. Decoding visits every value; encoding writes each text from its tokens.

## Decoding against the baselines

Octets are the text's. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1378.8 ± 0.6% | 1544.3 ± 0.9% | 1115.3 ± 0.4% | 403.7 ± 2.8% | 668.6 ± 0.3% | 365.7 ± 1.5% | 0.893 | 1.236 | 3.415 | 2.062 | 3.770 |
| qlog records, JSON text sequence | 1467503 | 1093.5 ± 1.4% | 1223.4 ± 1.3% | 1137.1 ± 1.2% | 345.1 ± 2.2% | 755.3 ± 0.9% | 309.3 ± 0.7% | 0.894 | 0.962 | 3.169 | 1.448 | 3.535 |
| string: silesia/dickens | 172528 | 6457.4 ± 1.7% | 3422.9 ± 1.6% | 2854.2 ± 1.2% | 306.7 ± 0.8% | 3020.7 ± 2.6% | 567.6 ± 1.5% | 1.887 | 2.262 | 21.055 | 2.138 | 11.377 |
| string: silesia/nci | 1075110 | 5395.6 ± 1.2% | 3933.5 ± 2.1% | 3024.4 ± 1.0% | 638.6 ± 2.6% | 3618.2 ± 1.8% | 567.9 ± 3.8% | 1.372 | 1.784 | 8.449 | 1.491 | 9.501 |
| string: silesia/reymont | 1075159 | 3506.6 ± 3.5% | 3402.4 ± 1.4% | 1941.7 ± 2.6% | 321.0 ± 1.2% | 2092.3 ± 0.8% | 487.5 ± 2.6% | 1.031 | 1.806 | 10.922 | 1.676 | 7.194 |
| string: silesia/samba | 97582 | 3974.4 ± 0.8% | 3777.9 ± 0.5% | 3053.6 ± 0.8% | 333.0 ± 1.3% | 1915.3 ± 2.3% | 417.8 ± 0.7% | 1.052 | 1.302 | 11.935 | 2.075 | 9.514 |
| string: silesia/webster | 1098490 | 4385.8 ± 0.8% | 2417.3 ± 0.4% | 1736.5 ± 0.5% | 299.7 ± 2.4% | 2059.8 ± 1.7% | 464.8 ± 1.2% | 1.814 | 2.526 | 14.633 | 2.129 | 9.436 |
| string: silesia/xml | 1090118 | 5972.6 ± 0.1% | 4987.9 ± 0.5% | 2433.0 ± 0.4% | 501.8 ± 0.5% | 3303.2 ± 0.4% | 541.9 ± 1.4% | 1.197 | 2.455 | 11.903 | 1.808 | 11.022 |
| string: canterbury/alice29.txt | 159425 | 5723.7 ± 1.3% | 2768.2 ± 1.5% | 2787.6 ± 4.2% | 293.8 ± 0.5% | 2744.1 ± 0.4% | 512.6 ± 1.4% | 2.068 | 2.053 | 19.479 | 2.086 | 11.166 |
| string: canterbury/asyoulik.txt | 132198 | 4272.6 ± 0.3% | 2503.4 ± 3.3% | 2788.3 ± 1.4% | 296.4 ± 0.2% | 2365.0 ± 1.2% | 452.5 ± 7.8% | 1.707 | 1.532 | 14.416 | 1.807 | 9.443 |
| string: canterbury/lcet10.txt | 441884 | 6634.2 ± 0.7% | 3273.9 ± 0.5% | 2325.4 ± 0.8% | 338.4 ± 1.1% | 2753.7 ± 0.8% | 563.5 ± 2.3% | 2.026 | 2.853 | 19.604 | 2.409 | 11.773 |
| string: canterbury/plrabn12.txt | 503330 | 5446.8 ± 0.5% | 3118.1 ± 1.5% | 1837.0 ± 0.3% | 319.9 ± 0.6% | 2816.5 ± 0.8% | 531.8 ± 0.5% | 1.747 | 2.965 | 17.028 | 1.934 | 10.242 |
| string: canterbury-large/E.coli | 1048578 | 30365.1 ± 0.9% | 13224.8 ± 3.6% | 3411.1 ± 1.1% | 1275.4 ± 0.6% | 8888.8 ± 0.9% | 953.2 ± 2.2% | 2.296 | 8.902 | 23.809 | 3.416 | 31.856 |
| string: canterbury-large/bible.txt | 1055886 | 8474.3 ± 1.8% | 5301.6 ± 1.7% | 2815.5 ± 0.6% | 353.7 ± 0.4% | 3894.0 ± 0.8% | 637.2 ± 1.5% | 1.598 | 3.010 | 23.956 | 2.176 | 13.299 |
| string: canterbury-large/world192.txt | 1103121 | 4136.6 ± 1.1% | 2309.0 ± 1.2% | 1773.3 ± 0.7% | 326.1 ± 1.3% | 2097.0 ± 1.1% | 463.8 ± 3.5% | 1.791 | 2.333 | 12.685 | 1.973 | 8.919 |
| string: http/html-1m | 1058582 | 9069.2 ± 3.8% | 4768.3 ± 1.0% | 2730.6 ± 1.9% | 402.4 ± 0.5% | 3658.3 ± 1.2% | 602.5 ± 1.7% | 1.902 | 3.321 | 22.538 | 2.479 | 15.052 |
| string: http/json-1m | 1190272 | 3328.5 ± 1.1% | 1252.1 ± 0.9% | 2020.4 ± 1.5% | 478.3 ± 1.4% | 1336.9 ± 1.6% | 427.3 ± 1.2% | 2.658 | 1.647 | 6.960 | 2.490 | 7.789 |
| string: http/js-1m | 1144362 | 2857.1 ± 1.1% | 1606.6 ± 0.5% | 1327.9 ± 3.6% | 319.9 ± 0.9% | 1412.7 ± 3.7% | 380.3 ± 0.5% | 1.778 | 2.152 | 8.932 | 2.022 | 7.513 |
| string: http/css-1m | 1097820 | 3291.2 ± 1.1% | 2893.0 ± 0.7% | 2269.5 ± 0.9% | 441.6 ± 0.6% | 2074.4 ± 0.6% | 438.3 ± 2.0% | 1.138 | 1.450 | 7.452 | 1.587 | 7.509 |
| string: dickens as Cyrillic and CJK | 1883069 | 5834.4 ± 0.4% | 2981.4 ± 1.0% | 664.9 ± 0.9% | 370.8 ± 0.8% | 511.9 ± 0.9% | 165.3 ± 2.2% | 1.957 | 8.775 | 15.735 | 11.398 | 35.306 |
| string: dickens as Cyrillic and CJK, as \u escapes | 5075485 | 1194.3 ± 1.4% | 1239.6 ± 1.4% | 1096.2 ± 1.0% | 265.5 ± 1.3% | 476.6 ± 0.8% | 227.8 ± 3.5% | 0.964 | 1.090 | 4.499 | 2.506 | 5.243 |
| hex: silesia/dickens | 524290 | 46073.2 ± 1.1% | 15111.1 ± 0.5% | 3492.3 ± 0.7% | 479.7 ± 0.2% | 8884.9 ± 3.4% | 1131.4 ± 2.3% | 3.049 | 13.193 | 96.037 | 5.186 | 40.723 |
| hex: silesia/mozilla | 524290 | 45355.7 ± 1.9% | 15034.1 ± 0.7% | 3549.8 ± 0.9% | 427.5 ± 1.4% | 8871.1 ± 0.9% | 1128.9 ± 4.4% | 3.017 | 12.777 | 106.097 | 5.113 | 40.177 |
| hex: silesia/mr | 524290 | 43729.4 ± 0.5% | 14996.1 ± 0.3% | 3500.4 ± 1.4% | 640.4 ± 0.7% | 8874.4 ± 0.6% | 1129.0 ± 1.2% | 2.916 | 12.493 | 68.280 | 4.928 | 38.732 |
| hex: silesia/nci | 524290 | 46169.6 ± 1.5% | 15043.4 ± 0.5% | 3484.5 ± 0.5% | 794.7 ± 0.7% | 8870.3 ± 0.6% | 1132.8 ± 0.3% | 3.069 | 13.250 | 58.095 | 5.205 | 40.758 |
| hex: silesia/ooffice | 524290 | 46011.9 ± 0.7% | 15054.5 ± 2.6% | 3551.6 ± 0.8% | 342.5 ± 2.0% | 8876.9 ± 0.2% | 1131.4 ± 0.8% | 3.056 | 12.955 | 134.342 | 5.183 | 40.670 |
| hex: silesia/osdb | 524290 | 44466.6 ± 1.0% | 15039.6 ± 0.5% | 3554.7 ± 0.5% | 444.9 ± 2.3% | 8882.2 ± 1.0% | 1134.2 ± 0.7% | 2.957 | 12.509 | 99.939 | 5.006 | 39.206 |
| hex: silesia/reymont | 524290 | 45719.9 ± 0.5% | 15058.0 ± 0.6% | 3484.0 ± 0.5% | 504.1 ± 2.7% | 8876.1 ± 1.8% | 1135.0 ± 0.6% | 3.036 | 13.123 | 90.688 | 5.151 | 40.281 |
| hex: silesia/samba | 524290 | 46563.8 ± 2.4% | 15043.2 ± 2.6% | 3561.0 ± 0.4% | 366.5 ± 1.7% | 8912.4 ± 0.5% | 1138.0 ± 3.0% | 3.095 | 13.076 | 127.037 | 5.225 | 40.916 |
| hex: silesia/sao | 524290 | 48273.4 ± 0.5% | 15074.1 ± 1.1% | 3424.9 ± 0.5% | 276.2 ± 1.5% | 8851.7 ± 4.6% | 1135.8 ± 0.6% | 3.202 | 14.095 | 174.806 | 5.454 | 42.500 |
| hex: silesia/webster | 524290 | 46324.2 ± 0.8% | 15067.1 ± 0.3% | 3559.2 ± 0.2% | 449.4 ± 0.8% | 8758.3 ± 4.2% | 1136.9 ± 0.6% | 3.075 | 13.015 | 103.081 | 5.289 | 40.746 |
| hex: silesia/x-ray | 524290 | 45830.3 ± 0.7% | 15103.9 ± 1.8% | 3490.2 ± 0.5% | 421.1 ± 0.7% | 8875.7 ± 0.9% | 1138.3 ± 0.6% | 3.034 | 13.131 | 108.837 | 5.164 | 40.262 |
| hex: silesia/xml | 524290 | 45749.8 ± 0.3% | 15102.0 ± 1.7% | 3557.6 ± 0.6% | 732.4 ± 1.0% | 8915.3 ± 0.3% | 1136.7 ± 0.5% | 3.029 | 12.860 | 62.464 | 5.132 | 40.248 |
| hex: canterbury/alice29.txt | 304180 | 45664.6 ± 0.3% | 14174.9 ± 2.3% | 3562.6 ± 0.5% | 485.5 ± 0.5% | 8905.2 ± 0.3% | 1146.9 ± 0.6% | 3.222 | 12.818 | 94.054 | 5.128 | 39.814 |
| hex: canterbury/asyoulik.txt | 250360 | 45789.4 ± 0.3% | 15098.7 ± 0.3% | 3500.4 ± 0.2% | 471.3 ± 0.3% | 8898.9 ± 0.2% | 1144.3 ± 0.8% | 3.033 | 13.081 | 97.165 | 5.145 | 40.014 |
| hex: canterbury/cp.html | 49208 | 46463.3 ± 0.4% | 14462.1 ± 0.2% | 3556.3 ± 3.6% | 504.8 ± 0.7% | 9266.2 ± 0.4% | 1129.3 ± 1.0% | 3.213 | 13.065 | 92.042 | 5.014 | 41.142 |
| hex: canterbury/fields.c | 22302 | 49400.9 ± 0.6% | 17726.8 ± 0.3% | 3675.6 ± 0.3% | 564.1 ± 0.6% | 9238.0 ± 0.5% | 1105.1 ± 2.0% | 2.787 | 13.440 | 87.575 | 5.348 | 44.701 |
| hex: canterbury/grammar.lsp | 7444 | 44022.8 ± 0.6% | 17259.8 ± 0.6% | 3628.9 ± 0.1% | 761.8 ± 1.1% | 8953.9 ± 0.2% | 1077.1 ± 1.5% | 2.551 | 12.131 | 57.785 | 4.917 | 40.873 |
| hex: canterbury/kennedy.xls | 524290 | 46670.6 ± 1.8% | 15135.4 ± 0.5% | 3544.4 ± 0.4% | 753.2 ± 0.7% | 8913.5 ± 0.3% | 1125.3 ± 4.1% | 3.084 | 13.167 | 61.963 | 5.236 | 41.474 |
| hex: canterbury/lcet10.txt | 524290 | 45695.7 ± 1.5% | 15140.0 ± 0.4% | 3568.3 ± 0.2% | 487.6 ± 0.7% | 8930.3 ± 4.6% | 1136.4 ± 1.4% | 3.018 | 12.806 | 93.708 | 5.117 | 40.213 |
| hex: canterbury/plrabn12.txt | 524290 | 46833.0 ± 0.3% | 15131.6 ± 0.2% | 3570.9 ± 3.3% | 468.4 ± 0.6% | 8919.0 ± 0.3% | 1140.6 ± 0.3% | 3.095 | 13.115 | 99.982 | 5.251 | 41.062 |
| hex: canterbury/ptt5 | 524290 | 46551.0 ± 0.2% | 15130.1 ± 0.4% | 3502.4 ± 0.0% | 668.8 ± 2.3% | 8906.8 ± 0.3% | 1143.3 ± 0.6% | 3.077 | 13.291 | 69.599 | 5.226 | 40.717 |
| hex: canterbury/sum | 76482 | 46142.6 ± 0.6% | 15458.0 ± 0.4% | 3571.3 ± 0.2% | 583.8 ± 0.4% | 8941.2 ± 0.1% | 1138.8 ± 1.3% | 2.985 | 12.920 | 79.032 | 5.161 | 40.520 |
| hex: canterbury/xargs.1 | 8456 | 44868.3 ± 1.0% | 17425.1 ± 0.2% | 3575.3 ± 0.2% | 728.7 ± 2.0% | 8974.4 ± 0.3% | 1113.6 ± 1.3% | 2.575 | 12.550 | 61.571 | 5.000 | 40.293 |
| hex: canterbury-large/E.coli | 524290 | 45720.4 ± 0.1% | 15157.2 ± 0.2% | 3486.7 ± 0.1% | 964.2 ± 0.1% | 8918.1 ± 0.2% | 1121.2 ± 3.5% | 3.016 | 13.113 | 47.418 | 5.127 | 40.779 |
| hex: canterbury-large/bible.txt | 524290 | 46492.7 ± 1.0% | 15152.9 ± 0.4% | 3500.5 ± 0.2% | 502.7 ± 0.5% | 8911.3 ± 0.5% | 1097.7 ± 3.7% | 3.068 | 13.282 | 92.491 | 5.217 | 42.356 |
| hex: canterbury-large/world192.txt | 524290 | 46721.5 ± 0.3% | 15171.5 ± 0.1% | 3566.1 ± 0.2% | 470.5 ± 0.5% | 8936.7 ± 0.3% | 1130.2 ± 1.8% | 3.080 | 13.102 | 99.308 | 5.228 | 41.340 |
| hex: http/html-1kx1024 | 2099200 | 18021.9 ± 1.9% | 12632.2 ± 11.1% | 3201.7 ± 2.7% | 507.9 ± 0.3% | 7480.2 ± 2.7% | 979.5 ± 1.2% | 1.427 | 5.629 | 35.484 | 2.409 | 18.399 |
| hex: http/html-16kx64 | 2097280 | 34867.9 ± 0.5% | 13993.0 ± 0.1% | 3415.5 ± 0.1% | 514.6 ± 0.4% | 8196.9 ± 4.6% | 1086.8 ± 2.1% | 2.492 | 10.209 | 67.755 | 4.254 | 32.083 |
| hex: http/html-1m | 524290 | 45823.9 ± 0.1% | 15168.3 ± 0.2% | 3505.4 ± 3.2% | 509.6 ± 0.3% | 8920.6 ± 0.2% | 1128.4 ± 3.6% | 3.021 | 13.072 | 89.913 | 5.137 | 40.608 |
| hex: http/json-1kx1024 | 2099200 | 18352.9 ± 1.9% | 12788.7 ± 7.0% | 3207.8 ± 3.0% | 681.3 ± 0.7% | 7425.9 ± 3.7% | 974.9 ± 1.3% | 1.435 | 5.721 | 26.939 | 2.471 | 18.825 |
| hex: http/json-16kx64 | 2097280 | 35129.8 ± 0.7% | 14079.7 ± 0.3% | 3415.6 ± 0.1% | 696.7 ± 0.5% | 8589.4 ± 7.9% | 1087.6 ± 1.2% | 2.495 | 10.285 | 50.423 | 4.090 | 32.299 |
| hex: http/json-1m | 524290 | 46290.2 ± 0.1% | 15160.5 ± 0.1% | 3550.2 ± 0.1% | 715.7 ± 0.8% | 8941.0 ± 0.6% | 1102.6 ± 4.1% | 3.053 | 13.039 | 64.682 | 5.177 | 41.983 |
| hex: http/js-1kx1024 | 2099200 | 17935.1 ± 1.9% | 12550.9 ± 7.3% | 3197.4 ± 0.3% | 492.2 ± 2.8% | 7515.4 ± 2.1% | 979.0 ± 1.1% | 1.429 | 5.609 | 36.436 | 2.386 | 18.319 |
| hex: http/js-16kx64 | 2097280 | 34288.1 ± 0.4% | 14064.3 ± 2.5% | 3414.3 ± 0.3% | 498.7 ± 0.6% | 8552.9 ± 0.7% | 1089.1 ± 1.4% | 2.438 | 10.043 | 68.758 | 4.009 | 31.484 |
| hex: http/js-1m | 524290 | 46723.6 ± 0.5% | 15168.6 ± 0.2% | 3572.8 ± 0.4% | 516.0 ± 0.7% | 8928.8 ± 0.3% | 1136.8 ± 1.2% | 3.080 | 13.078 | 90.553 | 5.233 | 41.100 |
| hex: http/css-1kx1024 | 2099200 | 17878.6 ± 2.7% | 12586.3 ± 1.1% | 3201.9 ± 0.2% | 570.1 ± 0.7% | 7516.1 ± 2.2% | 988.7 ± 3.0% | 1.420 | 5.584 | 31.359 | 2.379 | 18.082 |
| hex: http/css-16kx64 | 2097280 | 34327.7 ± 0.9% | 13943.0 ± 0.2% | 3402.3 ± 2.8% | 582.4 ± 0.5% | 8570.9 ± 0.5% | 1092.2 ± 3.0% | 2.462 | 10.090 | 58.938 | 4.005 | 31.429 |
| hex: http/css-1m | 524290 | 45924.1 ± 0.4% | 15167.1 ± 0.3% | 3560.1 ± 0.1% | 562.3 ± 0.7% | 8946.5 ± 0.2% | 1136.6 ± 1.0% | 3.028 | 12.900 | 81.676 | 5.133 | 40.404 |
| hex: shuffled/dickens-1m | 524290 | 45831.7 ± 0.2% | 15160.9 ± 0.5% | 3486.1 ± 0.1% | 480.8 ± 0.4% | 8935.6 ± 0.4% | 1142.3 ± 0.2% | 3.023 | 13.147 | 95.326 | 5.129 | 40.123 |

## Encoding against the baselines

Octets are the ones stdx writes. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1766.0 ± 1.2% | 1485.9 ± 0.1% | 1037.2 ± 3.4% | 481.2 ± 0.3% | 470.7 ± 1.6% | 505.5 ± 0.2% | 1.188 | 1.703 | 3.670 | 3.752 | 3.494 |
| qlog records, JSON text sequence | 1467503 | 1695.8 ± 0.6% | 1265.4 ± 1.4% | 968.3 ± 0.7% | 457.5 ± 0.6% | 575.4 ± 0.6% | 353.7 ± 0.3% | 1.340 | 1.751 | 3.707 | 2.947 | 4.794 |
| string: silesia/dickens | 172528 | 12133.6 ± 1.0% | 4024.7 ± 1.2% | 3069.1 ± 1.9% | 357.7 ± 2.6% | 1722.9 ± 1.4% | 1197.5 ± 0.3% | 3.015 | 3.954 | 33.923 | 7.043 | 10.132 |
| string: silesia/nci | 1075110 | 10949.4 ± 0.5% | 4708.4 ± 0.4% | 3126.0 ± 0.1% | 859.3 ± 0.7% | 1913.8 ± 0.5% | 1294.7 ± 1.4% | 2.326 | 3.503 | 12.743 | 5.721 | 8.457 |
| string: silesia/reymont | 1075159 | 5268.4 ± 1.2% | 1865.2 ± 0.9% | 1893.2 ± 0.8% | 396.0 ± 0.4% | 1450.1 ± 0.6% | 1053.5 ± 0.3% | 2.825 | 2.783 | 13.304 | 3.633 | 5.001 |
| string: silesia/samba | 97582 | 6261.7 ± 0.4% | 2728.6 ± 0.4% | 4067.5 ± 0.3% | 379.9 ± 0.3% | 1330.6 ± 0.6% | 1182.2 ± 1.8% | 2.295 | 1.539 | 16.482 | 4.706 | 5.297 |
| string: silesia/webster | 1098490 | 6615.3 ± 0.6% | 1990.6 ± 0.7% | 1751.9 ± 1.3% | 388.9 ± 0.9% | 1408.5 ± 1.5% | 602.3 ± 0.7% | 3.323 | 3.776 | 17.010 | 4.697 | 10.983 |
| string: silesia/xml | 1090118 | 9893.2 ± 0.5% | 3223.9 ± 1.2% | 2521.0 ± 4.1% | 629.8 ± 0.2% | 1950.0 ± 0.7% | 967.2 ± 4.2% | 3.069 | 3.924 | 15.709 | 5.073 | 10.229 |
| string: canterbury/alice29.txt | 159425 | 10764.3 ± 3.4% | 2913.7 ± 1.3% | 3112.6 ± 3.0% | 344.6 ± 0.7% | 1549.4 ± 1.2% | 1095.0 ± 0.7% | 3.694 | 3.458 | 31.235 | 6.947 | 9.830 |
| string: canterbury/asyoulik.txt | 132198 | 10166.8 ± 3.6% | 2115.9 ± 1.4% | 3127.6 ± 0.6% | 350.4 ± 0.4% | 1359.9 ± 1.9% | 964.8 ± 1.1% | 4.805 | 3.251 | 29.016 | 7.476 | 10.538 |
| string: canterbury/lcet10.txt | 441884 | 10514.0 ± 1.0% | 3102.3 ± 0.8% | 2593.1 ± 0.7% | 387.7 ± 0.4% | 1660.4 ± 1.7% | 1209.1 ± 1.0% | 3.389 | 4.055 | 27.118 | 6.332 | 8.696 |
| string: canterbury/plrabn12.txt | 503330 | 7815.0 ± 3.8% | 2315.4 ± 0.4% | 2102.4 ± 0.6% | 363.0 ± 2.0% | 1622.9 ± 1.6% | 1122.4 ± 0.9% | 3.375 | 3.717 | 21.530 | 4.815 | 6.963 |
| string: canterbury-large/E.coli | 1048578 | 30874.3 ± 0.6% | 16206.3 ± 0.3% | 3485.3 ± 0.3% | 1698.4 ± 0.3% | 3171.3 ± 0.2% | 1427.0 ± 0.1% | 1.905 | 8.858 | 18.178 | 9.736 | 21.635 |
| string: canterbury-large/bible.txt | 1055886 | 8903.4 ± 0.4% | 4880.8 ± 0.8% | 3012.3 ± 0.5% | 422.0 ± 0.4% | 2229.2 ± 0.2% | 1492.8 ± 4.1% | 1.824 | 2.956 | 21.098 | 3.994 | 5.964 |
| string: canterbury-large/world192.txt | 1103121 | 6412.1 ± 0.2% | 1744.0 ± 2.2% | 1903.9 ± 2.5% | 391.2 ± 0.2% | 1409.9 ± 1.0% | 982.1 ± 1.0% | 3.677 | 3.368 | 16.389 | 4.548 | 6.529 |
| string: http/html-1m | 1058582 | 9949.0 ± 1.0% | 4435.6 ± 0.5% | 2881.8 ± 0.6% | 465.6 ± 0.3% | 2174.7 ± 3.6% | 856.1 ± 0.8% | 2.243 | 3.452 | 21.369 | 4.575 | 11.621 |
| string: http/json-1m | 1190272 | 8444.1 ± 0.4% | 1593.5 ± 0.4% | 1575.6 ± 0.3% | 542.2 ± 0.5% | 1163.6 ± 3.4% | 852.3 ± 1.2% | 5.299 | 5.359 | 15.574 | 7.257 | 9.907 |
| string: http/js-1m | 1144362 | 6371.5 ± 2.4% | 1128.2 ± 0.1% | 1391.5 ± 2.5% | 363.4 ± 0.3% | 1124.8 ± 0.8% | 754.1 ± 0.6% | 5.648 | 4.579 | 17.532 | 5.665 | 8.449 |
| string: http/css-1m | 1097820 | 8118.5 ± 5.2% | 1495.9 ± 0.5% | 2308.6 ± 0.1% | 548.8 ± 0.3% | 1275.9 ± 0.7% | 886.5 ± 1.1% | 5.427 | 3.517 | 14.794 | 6.363 | 9.158 |
| string: dickens as Cyrillic and CJK | 1883069 | 5508.1 ± 0.3% | 3729.8 ± 2.9% | 486.1 ± 0.3% | 252.9 ± 0.5% | 467.0 ± 0.2% | 358.6 ± 0.3% | 1.477 | 11.332 | 21.780 | 11.795 | 15.360 |
| hex: silesia/dickens | 524290 | 43751.7 ± 0.2% | 2612.7 ± 0.1% | 1456.5 ± 4.2% | 470.8 ± 3.1% | 1581.9 ± 0.1% | 1064.1 ± 0.2% | 16.746 | 30.040 | 92.938 | 27.658 | 41.116 |
| hex: silesia/mozilla | 524290 | 43676.7 ± 0.2% | 2606.5 ± 5.7% | 1443.1 ± 4.3% | 419.2 ± 0.5% | 1577.6 ± 0.2% | 1068.5 ± 0.1% | 16.757 | 30.266 | 104.198 | 27.686 | 40.875 |
| hex: silesia/mr | 524290 | 43801.4 ± 0.3% | 2582.9 ± 0.5% | 1505.2 ± 0.3% | 610.8 ± 0.5% | 1575.1 ± 0.1% | 1068.8 ± 0.2% | 16.959 | 29.100 | 71.714 | 27.809 | 40.982 |
| hex: silesia/nci | 524290 | 43888.7 ± 0.1% | 2584.5 ± 0.2% | 1503.4 ± 0.4% | 753.0 ± 0.2% | 1559.5 ± 0.1% | 1069.3 ± 0.1% | 16.982 | 29.192 | 58.283 | 28.142 | 41.045 |
| hex: silesia/ooffice | 524290 | 43785.8 ± 0.2% | 2608.7 ± 0.1% | 1511.1 ± 0.2% | 347.4 ± 0.3% | 1583.5 ± 0.2% | 1069.3 ± 0.2% | 16.784 | 28.975 | 126.024 | 27.652 | 40.949 |
| hex: silesia/osdb | 524290 | 43798.6 ± 3.7% | 2610.8 ± 0.5% | 1510.6 ± 0.4% | 456.5 ± 0.5% | 1575.5 ± 0.3% | 1068.9 ± 0.4% | 16.776 | 28.994 | 95.945 | 27.800 | 40.975 |
| hex: silesia/reymont | 524290 | 43007.9 ± 7.1% | 2607.5 ± 0.2% | 1510.4 ± 0.1% | 499.2 ± 0.5% | 1579.8 ± 0.4% | 1069.2 ± 0.2% | 16.494 | 28.475 | 86.148 | 27.223 | 40.223 |
| hex: silesia/samba | 524290 | 43922.9 ± 0.2% | 2618.5 ± 0.3% | 1511.4 ± 0.2% | 367.4 ± 0.6% | 1572.9 ± 0.1% | 1071.2 ± 0.1% | 16.774 | 29.060 | 119.543 | 27.924 | 41.002 |
| hex: silesia/sao | 524290 | 42853.5 ± 0.2% | 2610.9 ± 0.1% | 1513.2 ± 0.1% | 283.9 ± 0.5% | 1579.8 ± 0.2% | 1069.4 ± 0.1% | 16.413 | 28.320 | 150.935 | 27.126 | 40.072 |
| hex: silesia/webster | 524290 | 44172.1 ± 0.1% | 2620.4 ± 0.1% | 1513.0 ± 0.1% | 454.7 ± 0.4% | 1572.9 ± 0.1% | 1060.4 ± 5.2% | 16.857 | 29.196 | 97.145 | 28.083 | 41.658 |
| hex: silesia/x-ray | 524290 | 43844.2 ± 0.3% | 2603.8 ± 0.3% | 1511.3 ± 0.2% | 432.8 ± 3.1% | 1580.1 ± 5.3% | 1067.6 ± 0.2% | 16.838 | 29.011 | 101.307 | 27.747 | 41.067 |
| hex: silesia/xml | 524290 | 43818.8 ± 0.1% | 2618.1 ± 0.7% | 1511.3 ± 0.3% | 734.5 ± 0.5% | 1571.9 ± 0.2% | 1069.1 ± 0.3% | 16.737 | 28.994 | 59.656 | 27.876 | 40.987 |
| hex: canterbury/alice29.txt | 304180 | 43757.3 ± 0.0% | 2638.0 ± 0.2% | 1529.3 ± 0.0% | 480.5 ± 2.7% | 1598.7 ± 0.1% | 1083.9 ± 0.2% | 16.587 | 28.613 | 91.067 | 27.371 | 40.371 |
| hex: canterbury/asyoulik.txt | 250360 | 43728.5 ± 0.1% | 2639.8 ± 0.0% | 1545.6 ± 0.0% | 470.3 ± 0.2% | 1599.4 ± 0.1% | 1081.9 ± 0.3% | 16.565 | 28.292 | 92.979 | 27.340 | 40.419 |
| hex: canterbury/cp.html | 49208 | 42744.4 ± 0.1% | 2618.3 ± 5.5% | 1530.3 ± 0.2% | 517.4 ± 0.4% | 1598.8 ± 0.3% | 1093.7 ± 0.1% | 16.325 | 27.931 | 82.616 | 26.735 | 39.081 |
| hex: canterbury/fields.c | 22302 | 41750.7 ± 0.2% | 2674.4 ± 6.4% | 1538.3 ± 0.5% | 631.0 ± 0.4% | 1615.3 ± 7.4% | 1099.3 ± 0.1% | 15.611 | 27.141 | 66.171 | 25.847 | 37.979 |
| hex: canterbury/grammar.lsp | 7444 | 39559.1 ± 7.0% | 2706.0 ± 0.4% | 1543.8 ± 0.4% | 804.6 ± 0.5% | 1617.8 ± 1.6% | 1111.5 ± 3.8% | 14.619 | 25.624 | 49.167 | 24.452 | 35.591 |
| hex: canterbury/kennedy.xls | 524290 | 41980.5 ± 7.4% | 2599.4 ± 0.3% | 1506.7 ± 4.7% | 740.6 ± 0.3% | 1535.0 ± 0.1% | 1071.4 ± 0.2% | 16.150 | 27.863 | 56.685 | 27.349 | 39.182 |
| hex: canterbury/lcet10.txt | 524290 | 43700.0 ± 0.2% | 2588.0 ± 0.5% | 1508.6 ± 0.3% | 477.3 ± 0.2% | 1563.2 ± 0.2% | 1069.1 ± 0.2% | 16.885 | 28.967 | 91.555 | 27.956 | 40.877 |
| hex: canterbury/plrabn12.txt | 524290 | 43767.5 ± 0.1% | 2608.8 ± 0.1% | 1509.6 ± 0.1% | 463.5 ± 0.1% | 1581.7 ± 0.2% | 1069.3 ± 0.4% | 16.777 | 28.993 | 94.423 | 27.671 | 40.932 |
| hex: canterbury/ptt5 | 524290 | 43750.2 ± 7.6% | 2581.3 ± 0.3% | 1504.4 ± 0.3% | 615.2 ± 0.5% | 1562.9 ± 0.2% | 1070.3 ± 0.2% | 16.949 | 29.082 | 71.121 | 27.992 | 40.877 |
| hex: canterbury/sum | 76482 | 43073.3 ± 0.1% | 2610.6 ± 7.2% | 1523.3 ± 0.3% | 594.3 ± 0.6% | 1590.8 ± 0.2% | 1092.3 ± 0.1% | 16.499 | 28.276 | 72.476 | 27.077 | 39.435 |
| hex: canterbury/xargs.1 | 8456 | 40411.9 ± 0.2% | 2705.3 ± 0.2% | 1547.1 ± 4.5% | 831.8 ± 0.4% | 1617.5 ± 0.6% | 1115.2 ± 0.6% | 14.938 | 26.121 | 48.583 | 24.984 | 36.238 |
| hex: canterbury-large/E.coli | 524290 | 43752.7 ± 0.5% | 2597.0 ± 0.1% | 1509.3 ± 0.1% | 808.1 ± 0.1% | 1536.8 ± 0.5% | 1070.1 ± 0.4% | 16.847 | 28.989 | 54.143 | 28.470 | 40.885 |
| hex: canterbury-large/bible.txt | 524290 | 43798.9 ± 0.2% | 2617.9 ± 8.9% | 1512.2 ± 0.2% | 491.3 ± 0.6% | 1569.1 ± 0.1% | 1069.0 ± 0.2% | 16.731 | 28.964 | 89.157 | 27.913 | 40.972 |
| hex: canterbury-large/world192.txt | 524290 | 43864.0 ± 0.4% | 2617.2 ± 0.3% | 1511.2 ± 0.2% | 465.7 ± 0.4% | 1541.1 ± 0.2% | 1072.1 ± 0.1% | 16.760 | 29.025 | 94.196 | 28.463 | 40.913 |
| hex: http/html-1kx1024 | 2099200 | 21185.7 ± 1.4% | 2434.1 ± 0.5% | 1459.4 ± 3.5% | 514.8 ± 0.1% | 1526.1 ± 5.5% | 1079.8 ± 1.1% | 8.704 | 14.517 | 41.151 | 13.882 | 19.621 |
| hex: http/html-16kx64 | 2097280 | 22099.0 ± 0.8% | 2388.5 ± 0.2% | 1449.5 ± 0.9% | 483.7 ± 0.4% | 1242.3 ± 0.5% | 1084.7 ± 0.1% | 9.252 | 15.246 | 45.691 | 17.788 | 20.373 |
| hex: http/html-1m | 524290 | 40420.0 ± 0.4% | 2612.3 ± 0.3% | 1505.6 ± 0.6% | 508.2 ± 0.4% | 1581.8 ± 0.2% | 1070.6 ± 0.2% | 15.473 | 26.847 | 79.529 | 25.553 | 37.755 |
| hex: http/json-1kx1024 | 2099200 | 20113.1 ± 0.6% | 2451.7 ± 0.9% | 1458.1 ± 0.3% | 689.5 ± 0.3% | 1528.7 ± 0.3% | 1078.8 ± 0.3% | 8.204 | 13.794 | 29.169 | 13.157 | 18.644 |
| hex: http/json-16kx64 | 2097280 | 22066.2 ± 0.6% | 2381.9 ± 0.2% | 1449.2 ± 0.2% | 699.3 ± 0.4% | 1499.2 ± 0.2% | 1084.1 ± 0.2% | 9.264 | 15.226 | 31.556 | 14.719 | 20.355 |
| hex: http/json-1m | 524290 | 43797.2 ± 0.1% | 2603.6 ± 0.1% | 1508.4 ± 5.0% | 720.7 ± 4.6% | 1554.1 ± 0.1% | 1067.5 ± 0.1% | 16.822 | 29.035 | 60.772 | 28.181 | 41.029 |
| hex: http/js-1kx1024 | 2099200 | 20824.1 ± 0.4% | 2433.2 ± 0.8% | 1467.0 ± 0.6% | 500.1 ± 0.3% | 1527.2 ± 0.4% | 1080.9 ± 0.1% | 8.558 | 14.195 | 41.640 | 13.636 | 19.266 |
| hex: http/js-16kx64 | 2097280 | 21939.6 ± 0.5% | 2385.8 ± 0.1% | 1448.8 ± 0.1% | 501.9 ± 0.3% | 1500.1 ± 0.2% | 1084.7 ± 0.3% | 9.196 | 15.143 | 43.709 | 14.625 | 20.226 |
| hex: http/js-1m | 524290 | 42933.2 ± 0.2% | 2601.7 ± 0.2% | 1504.9 ± 0.3% | 514.7 ± 0.4% | 1557.1 ± 0.1% | 1067.5 ± 0.2% | 16.502 | 28.529 | 83.409 | 27.573 | 40.220 |
| hex: http/css-1kx1024 | 2099200 | 20420.8 ± 1.9% | 2456.1 ± 0.6% | 1469.4 ± 0.5% | 578.2 ± 0.2% | 1534.7 ± 0.8% | 1078.9 ± 3.7% | 8.314 | 13.897 | 35.317 | 13.306 | 18.928 |
| hex: http/css-16kx64 | 2097280 | 21599.2 ± 0.4% | 2392.1 ± 0.3% | 1450.3 ± 0.1% | 585.3 ± 0.5% | 1502.6 ± 0.1% | 1083.1 ± 5.6% | 9.030 | 14.893 | 36.905 | 14.375 | 19.941 |
| hex: http/css-1m | 524290 | 43804.3 ± 0.1% | 2617.7 ± 0.5% | 1510.0 ± 0.1% | 562.9 ± 0.8% | 1582.6 ± 3.0% | 1068.9 ± 5.8% | 16.734 | 29.009 | 77.825 | 27.679 | 40.982 |
| hex: shuffled/dickens-1m | 524290 | 43723.1 ± 0.1% | 2616.5 ± 0.1% | 1511.7 ± 0.1% | 468.3 ± 0.2% | 1535.7 ± 0.3% | 1070.3 ± 6.2% | 16.710 | 28.923 | 93.366 | 28.470 | 40.851 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1827.5 ± 0.9% | 1485.9 ± 0.1% | 1037.2 ± 3.4% | 481.2 ± 0.3% | 470.7 ± 1.6% | 505.5 ± 0.2% | 1.230 | 1.762 | 3.798 | 3.883 | 3.615 |
| qlog records, JSON text sequence | 1467503 | 1735.9 ± 0.6% | 1265.4 ± 1.4% | 968.3 ± 0.7% | 457.5 ± 0.6% | 575.4 ± 0.6% | 353.7 ± 0.3% | 1.372 | 1.793 | 3.794 | 3.017 | 4.907 |
| string: silesia/dickens | 172528 | 13511.3 ± 0.8% | 4024.7 ± 1.2% | 3069.1 ± 1.9% | 357.7 ± 2.6% | 1722.9 ± 1.4% | 1197.5 ± 0.3% | 3.357 | 4.402 | 37.775 | 7.842 | 11.283 |
| string: silesia/nci | 1075110 | 11724.9 ± 0.5% | 4708.4 ± 0.4% | 3126.0 ± 0.1% | 859.3 ± 0.7% | 1913.8 ± 0.5% | 1294.7 ± 1.4% | 2.490 | 3.751 | 13.645 | 6.127 | 9.056 |
| string: silesia/reymont | 1075159 | 5426.1 ± 1.7% | 1865.2 ± 0.9% | 1893.2 ± 0.8% | 396.0 ± 0.4% | 1450.1 ± 0.6% | 1053.5 ± 0.3% | 2.909 | 2.866 | 13.703 | 3.742 | 5.150 |
| string: silesia/samba | 97582 | 7329.8 ± 1.0% | 2728.6 ± 0.4% | 4067.5 ± 0.3% | 379.9 ± 0.3% | 1330.6 ± 0.6% | 1182.2 ± 1.8% | 2.686 | 1.802 | 19.293 | 5.509 | 6.200 |
| string: silesia/webster | 1098490 | 6975.0 ± 2.6% | 1990.6 ± 0.7% | 1751.9 ± 1.3% | 388.9 ± 0.9% | 1408.5 ± 1.5% | 602.3 ± 0.7% | 3.504 | 3.981 | 17.934 | 4.952 | 11.581 |
| string: silesia/xml | 1090118 | 11368.5 ± 2.9% | 3223.9 ± 1.2% | 2521.0 ± 4.1% | 629.8 ± 0.2% | 1950.0 ± 0.7% | 967.2 ± 4.2% | 3.526 | 4.510 | 18.052 | 5.830 | 11.754 |
| string: canterbury/alice29.txt | 159425 | 13386.2 ± 0.5% | 2913.7 ± 1.3% | 3112.6 ± 3.0% | 344.6 ± 0.7% | 1549.4 ± 1.2% | 1095.0 ± 0.7% | 4.594 | 4.301 | 38.842 | 8.639 | 12.224 |
| string: canterbury/asyoulik.txt | 132198 | 11520.6 ± 0.8% | 2115.9 ± 1.4% | 3127.6 ± 0.6% | 350.4 ± 0.4% | 1359.9 ± 1.9% | 964.8 ± 1.1% | 5.445 | 3.684 | 32.880 | 8.472 | 11.941 |
| string: canterbury/lcet10.txt | 441884 | 12579.8 ± 1.7% | 3102.3 ± 0.8% | 2593.1 ± 0.7% | 387.7 ± 0.4% | 1660.4 ± 1.7% | 1209.1 ± 1.0% | 4.055 | 4.851 | 32.446 | 7.577 | 10.404 |
| string: canterbury/plrabn12.txt | 503330 | 8844.9 ± 1.7% | 2315.4 ± 0.4% | 2102.4 ± 0.6% | 363.0 ± 2.0% | 1622.9 ± 1.6% | 1122.4 ± 0.9% | 3.820 | 4.207 | 24.367 | 5.450 | 7.881 |
| string: canterbury-large/E.coli | 1048578 | 30930.3 ± 0.2% | 16206.3 ± 0.3% | 3485.3 ± 0.3% | 1698.4 ± 0.3% | 3171.3 ± 0.2% | 1427.0 ± 0.1% | 1.909 | 8.875 | 18.211 | 9.753 | 21.675 |
| string: canterbury-large/bible.txt | 1055886 | 9879.7 ± 0.6% | 4880.8 ± 0.8% | 3012.3 ± 0.5% | 422.0 ± 0.4% | 2229.2 ± 0.2% | 1492.8 ± 4.1% | 2.024 | 3.280 | 23.411 | 4.432 | 6.618 |
| string: canterbury-large/world192.txt | 1103121 | 6520.2 ± 0.9% | 1744.0 ± 2.2% | 1903.9 ± 2.5% | 391.2 ± 0.2% | 1409.9 ± 1.0% | 982.1 ± 1.0% | 3.739 | 3.425 | 16.666 | 4.625 | 6.639 |
| string: http/html-1m | 1058582 | 10286.2 ± 0.7% | 4435.6 ± 0.5% | 2881.8 ± 0.6% | 465.6 ± 0.3% | 2174.7 ± 3.6% | 856.1 ± 0.8% | 2.319 | 3.569 | 22.093 | 4.730 | 12.015 |
| string: http/json-1m | 1190272 | 8577.0 ± 0.5% | 1593.5 ± 0.4% | 1575.6 ± 0.3% | 542.2 ± 0.5% | 1163.6 ± 3.4% | 852.3 ± 1.2% | 5.382 | 5.444 | 15.820 | 7.371 | 10.063 |
| string: http/js-1m | 1144362 | 6675.2 ± 0.9% | 1128.2 ± 0.1% | 1391.5 ± 2.5% | 363.4 ± 0.3% | 1124.8 ± 0.8% | 754.1 ± 0.6% | 5.917 | 4.797 | 18.368 | 5.935 | 8.852 |
| string: http/css-1m | 1097820 | 9561.2 ± 0.6% | 1495.9 ± 0.5% | 2308.6 ± 0.1% | 548.8 ± 0.3% | 1275.9 ± 0.7% | 886.5 ± 1.1% | 6.391 | 4.142 | 17.423 | 7.493 | 10.785 |
| string: dickens as Cyrillic and CJK | 1883069 | 5736.1 ± 1.0% | 3729.8 ± 2.9% | 486.1 ± 0.3% | 252.9 ± 0.5% | 467.0 ± 0.2% | 358.6 ± 0.3% | 1.538 | 11.801 | 22.681 | 12.283 | 15.995 |
| hex: silesia/dickens | 524290 | 43821.1 ± 0.3% | 2612.7 ± 0.1% | 1456.5 ± 4.2% | 470.8 ± 3.1% | 1581.9 ± 0.1% | 1064.1 ± 0.2% | 16.772 | 30.088 | 93.085 | 27.702 | 41.181 |
| hex: silesia/mozilla | 524290 | 43685.8 ± 0.2% | 2606.5 ± 5.7% | 1443.1 ± 4.3% | 419.2 ± 0.5% | 1577.6 ± 0.2% | 1068.5 ± 0.1% | 16.760 | 30.272 | 104.220 | 27.692 | 40.883 |
| hex: silesia/mr | 524290 | 43811.3 ± 0.2% | 2582.9 ± 0.5% | 1505.2 ± 0.3% | 610.8 ± 0.5% | 1575.1 ± 0.1% | 1068.8 ± 0.2% | 16.962 | 29.106 | 71.731 | 27.815 | 40.992 |
| hex: silesia/nci | 524290 | 43880.6 ± 0.3% | 2584.5 ± 0.2% | 1503.4 ± 0.4% | 753.0 ± 0.2% | 1559.5 ± 0.1% | 1069.3 ± 0.1% | 16.979 | 29.187 | 58.272 | 28.137 | 41.037 |
| hex: silesia/ooffice | 524290 | 43810.2 ± 0.2% | 2608.7 ± 0.1% | 1511.1 ± 0.2% | 347.4 ± 0.3% | 1583.5 ± 0.2% | 1069.3 ± 0.2% | 16.794 | 28.991 | 126.094 | 27.667 | 40.972 |
| hex: silesia/osdb | 524290 | 43842.7 ± 0.8% | 2610.8 ± 0.5% | 1510.6 ± 0.4% | 456.5 ± 0.5% | 1575.5 ± 0.3% | 1068.9 ± 0.4% | 16.793 | 29.024 | 96.041 | 27.828 | 41.016 |
| hex: silesia/reymont | 524290 | 43832.3 ± 0.2% | 2607.5 ± 0.2% | 1510.4 ± 0.1% | 499.2 ± 0.5% | 1579.8 ± 0.4% | 1069.2 ± 0.2% | 16.810 | 29.021 | 87.799 | 27.745 | 40.994 |
| hex: silesia/samba | 524290 | 43924.2 ± 0.1% | 2618.5 ± 0.3% | 1511.4 ± 0.2% | 367.4 ± 0.6% | 1572.9 ± 0.1% | 1071.2 ± 0.1% | 16.774 | 29.061 | 119.546 | 27.925 | 41.003 |
| hex: silesia/sao | 524290 | 42925.3 ± 0.4% | 2610.9 ± 0.1% | 1513.2 ± 0.1% | 283.9 ± 0.5% | 1579.8 ± 0.2% | 1069.4 ± 0.1% | 16.441 | 28.367 | 151.188 | 27.172 | 40.140 |
| hex: silesia/webster | 524290 | 44154.0 ± 0.3% | 2620.4 ± 0.1% | 1513.0 ± 0.1% | 454.7 ± 0.4% | 1572.9 ± 0.1% | 1060.4 ± 5.2% | 16.850 | 29.184 | 97.105 | 28.071 | 41.641 |
| hex: silesia/x-ray | 524290 | 43871.0 ± 0.1% | 2603.8 ± 0.3% | 1511.3 ± 0.2% | 432.8 ± 3.1% | 1580.1 ± 5.3% | 1067.6 ± 0.2% | 16.849 | 29.029 | 101.369 | 27.764 | 41.092 |
| hex: silesia/xml | 524290 | 43849.0 ± 0.1% | 2618.1 ± 0.7% | 1511.3 ± 0.3% | 734.5 ± 0.5% | 1571.9 ± 0.2% | 1069.1 ± 0.3% | 16.749 | 29.014 | 59.697 | 27.895 | 41.016 |
| hex: canterbury/alice29.txt | 304180 | 43846.0 ± 0.2% | 2638.0 ± 0.2% | 1529.3 ± 0.0% | 480.5 ± 2.7% | 1598.7 ± 0.1% | 1083.9 ± 0.2% | 16.621 | 28.671 | 91.252 | 27.426 | 40.453 |
| hex: canterbury/asyoulik.txt | 250360 | 43700.8 ± 0.0% | 2639.8 ± 0.0% | 1545.6 ± 0.0% | 470.3 ± 0.2% | 1599.4 ± 0.1% | 1081.9 ± 0.3% | 16.554 | 28.274 | 92.920 | 27.323 | 40.394 |
| hex: canterbury/cp.html | 49208 | 42842.7 ± 0.2% | 2618.3 ± 5.5% | 1530.3 ± 0.2% | 517.4 ± 0.4% | 1598.8 ± 0.3% | 1093.7 ± 0.1% | 16.363 | 27.996 | 82.806 | 26.796 | 39.171 |
| hex: canterbury/fields.c | 22302 | 41878.8 ± 0.2% | 2674.4 ± 6.4% | 1538.3 ± 0.5% | 631.0 ± 0.4% | 1615.3 ± 7.4% | 1099.3 ± 0.1% | 15.659 | 27.224 | 66.374 | 25.926 | 38.095 |
| hex: canterbury/grammar.lsp | 7444 | 40143.2 ± 0.3% | 2706.0 ± 0.4% | 1543.8 ± 0.4% | 804.6 ± 0.5% | 1617.8 ± 1.6% | 1111.5 ± 3.8% | 14.835 | 26.003 | 49.893 | 24.813 | 36.117 |
| hex: canterbury/kennedy.xls | 524290 | 41992.2 ± 7.5% | 2599.4 ± 0.3% | 1506.7 ± 4.7% | 740.6 ± 0.3% | 1535.0 ± 0.1% | 1071.4 ± 0.2% | 16.155 | 27.871 | 56.701 | 27.357 | 39.193 |
| hex: canterbury/lcet10.txt | 524290 | 43719.9 ± 3.4% | 2588.0 ± 0.5% | 1508.6 ± 0.3% | 477.3 ± 0.2% | 1563.2 ± 0.2% | 1069.1 ± 0.2% | 16.893 | 28.980 | 91.597 | 27.968 | 40.896 |
| hex: canterbury/plrabn12.txt | 524290 | 43776.1 ± 0.3% | 2608.8 ± 0.1% | 1509.6 ± 0.1% | 463.5 ± 0.1% | 1581.7 ± 0.2% | 1069.3 ± 0.4% | 16.780 | 28.999 | 94.442 | 27.676 | 40.940 |
| hex: canterbury/ptt5 | 524290 | 43806.7 ± 0.1% | 2581.3 ± 0.3% | 1504.4 ± 0.3% | 615.2 ± 0.5% | 1562.9 ± 0.2% | 1070.3 ± 0.2% | 16.971 | 29.119 | 71.213 | 28.029 | 40.930 |
| hex: canterbury/sum | 76482 | 43111.8 ± 0.1% | 2610.6 ± 7.2% | 1523.3 ± 0.3% | 594.3 ± 0.6% | 1590.8 ± 0.2% | 1092.3 ± 0.1% | 16.514 | 28.301 | 72.540 | 27.101 | 39.470 |
| hex: canterbury/xargs.1 | 8456 | 40579.7 ± 0.3% | 2705.3 ± 0.2% | 1547.1 ± 4.5% | 831.8 ± 0.4% | 1617.5 ± 0.6% | 1115.2 ± 0.6% | 15.000 | 26.230 | 48.784 | 25.088 | 36.389 |
| hex: canterbury-large/E.coli | 524290 | 43833.5 ± 0.1% | 2597.0 ± 0.1% | 1509.3 ± 0.1% | 808.1 ± 0.1% | 1536.8 ± 0.5% | 1070.1 ± 0.4% | 16.878 | 29.043 | 54.243 | 28.523 | 40.960 |
| hex: canterbury-large/bible.txt | 524290 | 43827.2 ± 0.1% | 2617.9 ± 8.9% | 1512.2 ± 0.2% | 491.3 ± 0.6% | 1569.1 ± 0.1% | 1069.0 ± 0.2% | 16.742 | 28.983 | 89.215 | 27.931 | 40.998 |
| hex: canterbury-large/world192.txt | 524290 | 43883.8 ± 0.1% | 2617.2 ± 0.3% | 1511.2 ± 0.2% | 465.7 ± 0.4% | 1541.1 ± 0.2% | 1072.1 ± 0.1% | 16.767 | 29.039 | 94.238 | 28.476 | 40.932 |
| hex: http/html-1kx1024 | 2099200 | 21292.7 ± 0.3% | 2434.1 ± 0.5% | 1459.4 ± 3.5% | 514.8 ± 0.1% | 1526.1 ± 5.5% | 1079.8 ± 1.1% | 8.748 | 14.590 | 41.359 | 13.952 | 19.720 |
| hex: http/html-16kx64 | 2097280 | 22156.7 ± 0.4% | 2388.5 ± 0.2% | 1449.5 ± 0.9% | 483.7 ± 0.4% | 1242.3 ± 0.5% | 1084.7 ± 0.1% | 9.276 | 15.286 | 45.810 | 17.835 | 20.426 |
| hex: http/html-1m | 524290 | 40456.9 ± 1.0% | 2612.3 ± 0.3% | 1505.6 ± 0.6% | 508.2 ± 0.4% | 1581.8 ± 0.2% | 1070.6 ± 0.2% | 15.487 | 26.872 | 79.602 | 25.577 | 37.790 |
| hex: http/json-1kx1024 | 2099200 | 20202.3 ± 0.2% | 2451.7 ± 0.9% | 1458.1 ± 0.3% | 689.5 ± 0.3% | 1528.7 ± 0.3% | 1078.8 ± 0.3% | 8.240 | 13.856 | 29.299 | 13.215 | 18.726 |
| hex: http/json-16kx64 | 2097280 | 22104.0 ± 0.3% | 2381.9 ± 0.2% | 1449.2 ± 0.2% | 699.3 ± 0.4% | 1499.2 ± 0.2% | 1084.1 ± 0.2% | 9.280 | 15.252 | 31.610 | 14.744 | 20.390 |
| hex: http/json-1m | 524290 | 43802.2 ± 0.1% | 2603.6 ± 0.1% | 1508.4 ± 5.0% | 720.7 ± 4.6% | 1554.1 ± 0.1% | 1067.5 ± 0.1% | 16.824 | 29.038 | 60.779 | 28.185 | 41.034 |
| hex: http/js-1kx1024 | 2099200 | 20928.7 ± 0.2% | 2433.2 ± 0.8% | 1467.0 ± 0.6% | 500.1 ± 0.3% | 1527.2 ± 0.4% | 1080.9 ± 0.1% | 8.601 | 14.266 | 41.849 | 13.704 | 19.362 |
| hex: http/js-16kx64 | 2097280 | 21961.9 ± 0.3% | 2385.8 ± 0.1% | 1448.8 ± 0.1% | 501.9 ± 0.3% | 1500.1 ± 0.2% | 1084.7 ± 0.3% | 9.205 | 15.158 | 43.754 | 14.640 | 20.247 |
| hex: http/js-1m | 524290 | 43019.5 ± 0.3% | 2601.7 ± 0.2% | 1504.9 ± 0.3% | 514.7 ± 0.4% | 1557.1 ± 0.1% | 1067.5 ± 0.2% | 16.535 | 28.586 | 83.577 | 27.628 | 40.301 |
| hex: http/css-1kx1024 | 2099200 | 20489.1 ± 0.3% | 2456.1 ± 0.6% | 1469.4 ± 0.5% | 578.2 ± 0.2% | 1534.7 ± 0.8% | 1078.9 ± 3.7% | 8.342 | 13.943 | 35.435 | 13.351 | 18.991 |
| hex: http/css-16kx64 | 2097280 | 21636.6 ± 0.3% | 2392.1 ± 0.3% | 1450.3 ± 0.1% | 585.3 ± 0.5% | 1502.6 ± 0.1% | 1083.1 ± 5.6% | 9.045 | 14.919 | 36.969 | 14.400 | 19.976 |
| hex: http/css-1m | 524290 | 43725.7 ± 0.2% | 2617.7 ± 0.5% | 1510.0 ± 0.1% | 562.9 ± 0.8% | 1582.6 ± 3.0% | 1068.9 ± 5.8% | 16.704 | 28.957 | 77.685 | 27.630 | 40.908 |
| hex: shuffled/dickens-1m | 524290 | 43734.8 ± 0.1% | 2616.5 ± 0.1% | 1511.7 ± 0.1% | 468.3 ± 0.2% | 1535.7 ± 0.3% | 1070.3 ± 6.2% | 16.715 | 28.930 | 93.391 | 28.478 | 40.862 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1151.8 ± 0.4% | 1544.3 ± 0.9% | 1115.3 ± 0.4% | 403.7 ± 2.8% | 668.6 ± 0.3% | 365.7 ± 1.5% | 0.746 | 1.033 | 2.853 | 1.723 | 3.149 |
| qlog records, JSON text sequence | 1467503 | 1016.2 ± 1.9% | 1223.4 ± 1.3% | 1137.1 ± 1.2% | 345.1 ± 2.2% | 755.3 ± 0.9% | 309.3 ± 0.7% | 0.831 | 0.894 | 2.945 | 1.345 | 3.285 |
| string: silesia/dickens | 172528 | 6490.7 ± 1.9% | 3422.9 ± 1.6% | 2854.2 ± 1.2% | 306.7 ± 0.8% | 3020.7 ± 2.6% | 567.6 ± 1.5% | 1.896 | 2.274 | 21.164 | 2.149 | 11.436 |
| string: silesia/nci | 1075110 | 5438.0 ± 1.2% | 3933.5 ± 2.1% | 3024.4 ± 1.0% | 638.6 ± 2.6% | 3618.2 ± 1.8% | 567.9 ± 3.8% | 1.383 | 1.798 | 8.516 | 1.503 | 9.576 |
| string: silesia/reymont | 1075159 | 3442.3 ± 2.0% | 3402.4 ± 1.4% | 1941.7 ± 2.6% | 321.0 ± 1.2% | 2092.3 ± 0.8% | 487.5 ± 2.6% | 1.012 | 1.773 | 10.722 | 1.645 | 7.062 |
| string: silesia/samba | 97582 | 4007.6 ± 0.9% | 3777.9 ± 0.5% | 3053.6 ± 0.8% | 333.0 ± 1.3% | 1915.3 ± 2.3% | 417.8 ± 0.7% | 1.061 | 1.312 | 12.035 | 2.092 | 9.593 |
| string: silesia/webster | 1098490 | 4390.8 ± 0.6% | 2417.3 ± 0.4% | 1736.5 ± 0.5% | 299.7 ± 2.4% | 2059.8 ± 1.7% | 464.8 ± 1.2% | 1.816 | 2.528 | 14.650 | 2.132 | 9.446 |
| string: silesia/xml | 1090118 | 5986.5 ± 0.4% | 4987.9 ± 0.5% | 2433.0 ± 0.4% | 501.8 ± 0.5% | 3303.2 ± 0.4% | 541.9 ± 1.4% | 1.200 | 2.461 | 11.930 | 1.812 | 11.047 |
| string: canterbury/alice29.txt | 159425 | 5724.9 ± 1.0% | 2768.2 ± 1.5% | 2787.6 ± 4.2% | 293.8 ± 0.5% | 2744.1 ± 0.4% | 512.6 ± 1.4% | 2.068 | 2.054 | 19.483 | 2.086 | 11.168 |
| string: canterbury/asyoulik.txt | 132198 | 4240.8 ± 1.1% | 2503.4 ± 3.3% | 2788.3 ± 1.4% | 296.4 ± 0.2% | 2365.0 ± 1.2% | 452.5 ± 7.8% | 1.694 | 1.521 | 14.309 | 1.793 | 9.372 |
| string: canterbury/lcet10.txt | 441884 | 6609.5 ± 1.0% | 3273.9 ± 0.5% | 2325.4 ± 0.8% | 338.4 ± 1.1% | 2753.7 ± 0.8% | 563.5 ± 2.3% | 2.019 | 2.842 | 19.531 | 2.400 | 11.730 |
| string: canterbury/plrabn12.txt | 503330 | 5471.0 ± 0.7% | 3118.1 ± 1.5% | 1837.0 ± 0.3% | 319.9 ± 0.6% | 2816.5 ± 0.8% | 531.8 ± 0.5% | 1.755 | 2.978 | 17.104 | 1.942 | 10.288 |
| string: canterbury-large/E.coli | 1048578 | 33953.6 ± 1.1% | 13224.8 ± 3.6% | 3411.1 ± 1.1% | 1275.4 ± 0.6% | 8888.8 ± 0.9% | 953.2 ± 2.2% | 2.567 | 9.954 | 26.622 | 3.820 | 35.621 |
| string: canterbury-large/bible.txt | 1055886 | 8507.8 ± 1.2% | 5301.6 ± 1.7% | 2815.5 ± 0.6% | 353.7 ± 0.4% | 3894.0 ± 0.8% | 637.2 ± 1.5% | 1.605 | 3.022 | 24.051 | 2.185 | 13.351 |
| string: canterbury-large/world192.txt | 1103121 | 4151.4 ± 0.5% | 2309.0 ± 1.2% | 1773.3 ± 0.7% | 326.1 ± 1.3% | 2097.0 ± 1.1% | 463.8 ± 3.5% | 1.798 | 2.341 | 12.730 | 1.980 | 8.951 |
| string: http/html-1m | 1058582 | 8684.8 ± 6.1% | 4768.3 ± 1.0% | 2730.6 ± 1.9% | 402.4 ± 0.5% | 3658.3 ± 1.2% | 602.5 ± 1.7% | 1.821 | 3.181 | 21.583 | 2.374 | 14.414 |
| string: http/json-1m | 1190272 | 3344.7 ± 1.0% | 1252.1 ± 0.9% | 2020.4 ± 1.5% | 478.3 ± 1.4% | 1336.9 ± 1.6% | 427.3 ± 1.2% | 2.671 | 1.655 | 6.993 | 2.502 | 7.827 |
| string: http/js-1m | 1144362 | 2877.7 ± 0.9% | 1606.6 ± 0.5% | 1327.9 ± 3.6% | 319.9 ± 0.9% | 1412.7 ± 3.7% | 380.3 ± 0.5% | 1.791 | 2.167 | 8.996 | 2.037 | 7.567 |
| string: http/css-1m | 1097820 | 3300.9 ± 0.8% | 2893.0 ± 0.7% | 2269.5 ± 0.9% | 441.6 ± 0.6% | 2074.4 ± 0.6% | 438.3 ± 2.0% | 1.141 | 1.454 | 7.474 | 1.591 | 7.531 |
| string: dickens as Cyrillic and CJK | 1883069 | 5835.2 ± 0.8% | 2981.4 ± 1.0% | 664.9 ± 0.9% | 370.8 ± 0.8% | 511.9 ± 0.9% | 165.3 ± 2.2% | 1.957 | 8.777 | 15.737 | 11.400 | 35.311 |
| string: dickens as Cyrillic and CJK, as \u escapes | 5075485 | 1203.0 ± 0.6% | 1239.6 ± 1.4% | 1096.2 ± 1.0% | 265.5 ± 1.3% | 476.6 ± 0.8% | 227.8 ± 3.5% | 0.971 | 1.097 | 4.531 | 2.524 | 5.281 |
| hex: silesia/dickens | 524290 | 33914.8 ± 0.4% | 15111.1 ± 0.5% | 3492.3 ± 0.7% | 479.7 ± 0.2% | 8884.9 ± 3.4% | 1131.4 ± 2.3% | 2.244 | 9.711 | 70.693 | 3.817 | 29.977 |
| hex: silesia/mozilla | 524290 | 33689.3 ± 3.7% | 15034.1 ± 0.7% | 3549.8 ± 0.9% | 427.5 ± 1.4% | 8871.1 ± 0.9% | 1128.9 ± 4.4% | 2.241 | 9.490 | 78.807 | 3.798 | 29.843 |
| hex: silesia/mr | 524290 | 33723.0 ± 0.6% | 14996.1 ± 0.3% | 3500.4 ± 1.4% | 640.4 ± 0.7% | 8874.4 ± 0.6% | 1129.0 ± 1.2% | 2.249 | 9.634 | 52.656 | 3.800 | 29.869 |
| hex: silesia/nci | 524290 | 33842.7 ± 0.7% | 15043.4 ± 0.5% | 3484.5 ± 0.5% | 794.7 ± 0.7% | 8870.3 ± 0.6% | 1132.8 ± 0.3% | 2.250 | 9.712 | 42.584 | 3.815 | 29.876 |
| hex: silesia/ooffice | 524290 | 33882.7 ± 0.6% | 15054.5 ± 2.6% | 3551.6 ± 0.8% | 342.5 ± 2.0% | 8876.9 ± 0.2% | 1131.4 ± 0.8% | 2.251 | 9.540 | 98.928 | 3.817 | 29.949 |
| hex: silesia/osdb | 524290 | 33746.1 ± 0.8% | 15039.6 ± 0.5% | 3554.7 ± 0.5% | 444.9 ± 2.3% | 8882.2 ± 1.0% | 1134.2 ± 0.7% | 2.244 | 9.493 | 75.844 | 3.799 | 29.753 |
| hex: silesia/reymont | 524290 | 33766.9 ± 0.6% | 15058.0 ± 0.6% | 3484.0 ± 0.5% | 504.1 ± 2.7% | 8876.1 ± 1.8% | 1135.0 ± 0.6% | 2.242 | 9.692 | 66.978 | 3.804 | 29.750 |
| hex: silesia/samba | 524290 | 33848.0 ± 0.4% | 15043.2 ± 2.6% | 3561.0 ± 0.4% | 366.5 ± 1.7% | 8912.4 ± 0.5% | 1138.0 ± 3.0% | 2.250 | 9.505 | 92.346 | 3.798 | 29.743 |
| hex: silesia/sao | 524290 | 33869.1 ± 0.5% | 15074.1 ± 1.1% | 3424.9 ± 0.5% | 276.2 ± 1.5% | 8851.7 ± 4.6% | 1135.8 ± 0.6% | 2.247 | 9.889 | 122.646 | 3.826 | 29.819 |
| hex: silesia/webster | 524290 | 33807.0 ± 0.4% | 15067.1 ± 0.3% | 3559.2 ± 0.2% | 449.4 ± 0.8% | 8758.3 ± 4.2% | 1136.9 ± 0.6% | 2.244 | 9.499 | 75.228 | 3.860 | 29.736 |
| hex: silesia/x-ray | 524290 | 33934.2 ± 0.5% | 15103.9 ± 1.8% | 3490.2 ± 0.5% | 421.1 ± 0.7% | 8875.7 ± 0.9% | 1138.3 ± 0.6% | 2.247 | 9.723 | 80.586 | 3.823 | 29.811 |
| hex: silesia/xml | 524290 | 33824.2 ± 0.4% | 15102.0 ± 1.7% | 3557.6 ± 0.6% | 732.4 ± 1.0% | 8915.3 ± 0.3% | 1136.7 ± 0.5% | 2.240 | 9.508 | 46.182 | 3.794 | 29.756 |
| hex: canterbury/alice29.txt | 304180 | 33751.6 ± 0.6% | 14174.9 ± 2.3% | 3562.6 ± 0.5% | 485.5 ± 0.5% | 8905.2 ± 0.3% | 1146.9 ± 0.6% | 2.381 | 9.474 | 69.517 | 3.790 | 29.428 |
| hex: canterbury/asyoulik.txt | 250360 | 33813.5 ± 0.4% | 15098.7 ± 0.3% | 3500.4 ± 0.2% | 471.3 ± 0.3% | 8898.9 ± 0.2% | 1144.3 ± 0.8% | 2.239 | 9.660 | 71.752 | 3.800 | 29.548 |
| hex: canterbury/cp.html | 49208 | 33440.4 ± 0.1% | 14462.1 ± 0.2% | 3556.3 ± 3.6% | 504.8 ± 0.7% | 9266.2 ± 0.4% | 1129.3 ± 1.0% | 2.312 | 9.403 | 66.244 | 3.609 | 29.611 |
| hex: canterbury/fields.c | 22302 | 33008.5 ± 0.4% | 17726.8 ± 0.3% | 3675.6 ± 0.3% | 564.1 ± 0.6% | 9238.0 ± 0.5% | 1105.1 ± 2.0% | 1.862 | 8.980 | 58.515 | 3.573 | 29.868 |
| hex: canterbury/grammar.lsp | 7444 | 29918.1 ± 0.2% | 17259.8 ± 0.6% | 3628.9 ± 0.1% | 761.8 ± 1.1% | 8953.9 ± 0.2% | 1077.1 ± 1.5% | 1.733 | 8.244 | 39.271 | 3.341 | 27.777 |
| hex: canterbury/kennedy.xls | 524290 | 33974.6 ± 0.1% | 15135.4 ± 0.5% | 3544.4 ± 0.4% | 753.2 ± 0.7% | 8913.5 ± 0.3% | 1125.3 ± 4.1% | 2.245 | 9.585 | 45.107 | 3.812 | 30.191 |
| hex: canterbury/lcet10.txt | 524290 | 33983.4 ± 0.3% | 15140.0 ± 0.4% | 3568.3 ± 0.2% | 487.6 ± 0.7% | 8930.3 ± 4.6% | 1136.4 ± 1.4% | 2.245 | 9.524 | 69.690 | 3.805 | 29.906 |
| hex: canterbury/plrabn12.txt | 524290 | 33953.8 ± 0.3% | 15131.6 ± 0.2% | 3570.9 ± 3.3% | 468.4 ± 0.6% | 8919.0 ± 0.3% | 1140.6 ± 0.3% | 2.244 | 9.508 | 72.487 | 3.807 | 29.770 |
| hex: canterbury/ptt5 | 524290 | 33942.9 ± 0.2% | 15130.1 ± 0.4% | 3502.4 ± 0.0% | 668.8 ± 2.3% | 8906.8 ± 0.3% | 1143.3 ± 0.6% | 2.243 | 9.691 | 50.748 | 3.811 | 29.689 |
| hex: canterbury/sum | 76482 | 33377.2 ± 0.1% | 15458.0 ± 0.4% | 3571.3 ± 0.2% | 583.8 ± 0.4% | 8941.2 ± 0.1% | 1138.8 ± 1.3% | 2.159 | 9.346 | 57.168 | 3.733 | 29.310 |
| hex: canterbury/xargs.1 | 8456 | 30366.3 ± 0.3% | 17425.1 ± 0.2% | 3575.3 ± 0.2% | 728.7 ± 2.0% | 8974.4 ± 0.3% | 1113.6 ± 1.3% | 1.743 | 8.493 | 41.671 | 3.384 | 27.270 |
| hex: canterbury-large/E.coli | 524290 | 33989.4 ± 0.2% | 15157.2 ± 0.2% | 3486.7 ± 0.1% | 964.2 ± 0.1% | 8918.1 ± 0.2% | 1121.2 ± 3.5% | 2.242 | 9.748 | 35.252 | 3.811 | 30.316 |
| hex: canterbury-large/bible.txt | 524290 | 33981.8 ± 0.1% | 15152.9 ± 0.4% | 3500.5 ± 0.2% | 502.7 ± 0.5% | 8911.3 ± 0.5% | 1097.7 ± 3.7% | 2.243 | 9.708 | 67.602 | 3.813 | 30.958 |
| hex: canterbury-large/world192.txt | 524290 | 33988.0 ± 0.2% | 15171.5 ± 0.1% | 3566.1 ± 0.2% | 470.5 ± 0.5% | 8936.7 ± 0.3% | 1130.2 ± 1.8% | 2.240 | 9.531 | 72.243 | 3.803 | 30.074 |
| hex: http/html-1kx1024 | 2099200 | 15518.7 ± 0.4% | 12632.2 ± 11.1% | 3201.7 ± 2.7% | 507.9 ± 0.3% | 7480.2 ± 2.7% | 979.5 ± 1.2% | 1.228 | 4.847 | 30.555 | 2.075 | 15.843 |
| hex: http/html-16kx64 | 2097280 | 28010.4 ± 0.2% | 13993.0 ± 0.1% | 3415.5 ± 0.1% | 514.6 ± 0.4% | 8196.9 ± 4.6% | 1086.8 ± 2.1% | 2.002 | 8.201 | 54.430 | 3.417 | 25.773 |
| hex: http/html-1m | 524290 | 34002.5 ± 0.2% | 15168.3 ± 0.2% | 3505.4 ± 3.2% | 509.6 ± 0.3% | 8920.6 ± 0.2% | 1128.4 ± 3.6% | 2.242 | 9.700 | 66.718 | 3.812 | 30.133 |
| hex: http/json-1kx1024 | 2099200 | 15749.5 ± 0.8% | 12788.7 ± 7.0% | 3207.8 ± 3.0% | 681.3 ± 0.7% | 7425.9 ± 3.7% | 974.9 ± 1.3% | 1.232 | 4.910 | 23.118 | 2.121 | 16.155 |
| hex: http/json-16kx64 | 2097280 | 28136.6 ± 0.3% | 14079.7 ± 0.3% | 3415.6 ± 0.1% | 696.7 ± 0.5% | 8589.4 ± 7.9% | 1087.6 ± 1.2% | 1.998 | 8.238 | 40.385 | 3.276 | 25.870 |
| hex: http/json-1m | 524290 | 34006.5 ± 0.2% | 15160.5 ± 0.1% | 3550.2 ± 0.1% | 715.7 ± 0.8% | 8941.0 ± 0.6% | 1102.6 ± 4.1% | 2.243 | 9.579 | 47.518 | 3.803 | 30.842 |
| hex: http/js-1kx1024 | 2099200 | 15532.3 ± 0.5% | 12550.9 ± 7.3% | 3197.4 ± 0.3% | 492.2 ± 2.8% | 7515.4 ± 2.1% | 979.0 ± 1.1% | 1.238 | 4.858 | 31.554 | 2.067 | 15.865 |
| hex: http/js-16kx64 | 2097280 | 28039.7 ± 0.1% | 14064.3 ± 2.5% | 3414.3 ± 0.3% | 498.7 ± 0.6% | 8552.9 ± 0.7% | 1089.1 ± 1.4% | 1.994 | 8.213 | 56.228 | 3.278 | 25.747 |
| hex: http/js-1m | 524290 | 34006.0 ± 0.7% | 15168.6 ± 0.2% | 3572.8 ± 0.4% | 516.0 ± 0.7% | 8928.8 ± 0.3% | 1136.8 ± 1.2% | 2.242 | 9.518 | 65.906 | 3.809 | 29.913 |
| hex: http/css-1kx1024 | 2099200 | 15491.6 ± 0.7% | 12586.3 ± 1.1% | 3201.9 ± 0.2% | 570.1 ± 0.7% | 7516.1 ± 2.2% | 988.7 ± 3.0% | 1.231 | 4.838 | 27.172 | 2.061 | 15.668 |
| hex: http/css-16kx64 | 2097280 | 27798.9 ± 0.6% | 13943.0 ± 0.2% | 3402.3 ± 2.8% | 582.4 ± 0.5% | 8570.9 ± 0.5% | 1092.2 ± 3.0% | 1.994 | 8.171 | 47.729 | 3.243 | 25.452 |
| hex: http/css-1m | 524290 | 33989.5 ± 0.1% | 15167.1 ± 0.3% | 3560.1 ± 0.1% | 562.3 ± 0.7% | 8946.5 ± 0.2% | 1136.6 ± 1.0% | 2.241 | 9.547 | 60.450 | 3.799 | 29.904 |
| hex: shuffled/dickens-1m | 524290 | 33999.4 ± 0.2% | 15160.9 ± 0.5% | 3486.1 ± 0.1% | 480.8 ± 0.4% | 8935.6 ± 0.4% | 1142.3 ± 0.2% | 2.243 | 9.753 | 70.716 | 3.805 | 29.765 |

## TextReader.next_items against the baselines

stdx's decoder a slice of tokens a call through `TextReader.next_items`, as a caller that reads a text's values in a loop calls it (decision 79). Octets are the text's. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1311.9 ± 0.2% | 1544.3 ± 0.9% | 1115.3 ± 0.4% | 403.7 ± 2.8% | 668.6 ± 0.3% | 365.7 ± 1.5% | 0.850 | 1.176 | 3.250 | 1.962 | 3.587 |
| qlog records, JSON text sequence | 1467503 | 1180.9 ± 1.0% | 1223.4 ± 1.3% | 1137.1 ± 1.2% | 345.1 ± 2.2% | 755.3 ± 0.9% | 309.3 ± 0.7% | 0.965 | 1.038 | 3.422 | 1.563 | 3.818 |
| string: silesia/dickens | 172528 | 6551.6 ± 2.1% | 3422.9 ± 1.6% | 2854.2 ± 1.2% | 306.7 ± 0.8% | 3020.7 ± 2.6% | 567.6 ± 1.5% | 1.914 | 2.295 | 21.363 | 2.169 | 11.543 |
| string: silesia/nci | 1075110 | 5473.7 ± 0.9% | 3933.5 ± 2.1% | 3024.4 ± 1.0% | 638.6 ± 2.6% | 3618.2 ± 1.8% | 567.9 ± 3.8% | 1.392 | 1.810 | 8.572 | 1.513 | 9.638 |
| string: silesia/reymont | 1075159 | 3501.1 ± 3.1% | 3402.4 ± 1.4% | 1941.7 ± 2.6% | 321.0 ± 1.2% | 2092.3 ± 0.8% | 487.5 ± 2.6% | 1.029 | 1.803 | 10.905 | 1.673 | 7.182 |
| string: silesia/samba | 97582 | 4002.5 ± 4.7% | 3777.9 ± 0.5% | 3053.6 ± 0.8% | 333.0 ± 1.3% | 1915.3 ± 2.3% | 417.8 ± 0.7% | 1.059 | 1.311 | 12.019 | 2.090 | 9.581 |
| string: silesia/webster | 1098490 | 4426.3 ± 1.0% | 2417.3 ± 0.4% | 1736.5 ± 0.5% | 299.7 ± 2.4% | 2059.8 ± 1.7% | 464.8 ± 1.2% | 1.831 | 2.549 | 14.769 | 2.149 | 9.523 |
| string: silesia/xml | 1090118 | 6025.0 ± 0.6% | 4987.9 ± 0.5% | 2433.0 ± 0.4% | 501.8 ± 0.5% | 3303.2 ± 0.4% | 541.9 ± 1.4% | 1.208 | 2.476 | 12.007 | 1.824 | 11.118 |
| string: canterbury/alice29.txt | 159425 | 5746.9 ± 1.2% | 2768.2 ± 1.5% | 2787.6 ± 4.2% | 293.8 ± 0.5% | 2744.1 ± 0.4% | 512.6 ± 1.4% | 2.076 | 2.062 | 19.558 | 2.094 | 11.211 |
| string: canterbury/asyoulik.txt | 132198 | 4257.1 ± 1.3% | 2503.4 ± 3.3% | 2788.3 ± 1.4% | 296.4 ± 0.2% | 2365.0 ± 1.2% | 452.5 ± 7.8% | 1.701 | 1.527 | 14.363 | 1.800 | 9.408 |
| string: canterbury/lcet10.txt | 441884 | 6655.7 ± 0.6% | 3273.9 ± 0.5% | 2325.4 ± 0.8% | 338.4 ± 1.1% | 2753.7 ± 0.8% | 563.5 ± 2.3% | 2.033 | 2.862 | 19.668 | 2.417 | 11.811 |
| string: canterbury/plrabn12.txt | 503330 | 5468.3 ± 0.7% | 3118.1 ± 1.5% | 1837.0 ± 0.3% | 319.9 ± 0.6% | 2816.5 ± 0.8% | 531.8 ± 0.5% | 1.754 | 2.977 | 17.095 | 1.941 | 10.283 |
| string: canterbury-large/E.coli | 1048578 | 33869.9 ± 0.9% | 13224.8 ± 3.6% | 3411.1 ± 1.1% | 1275.4 ± 0.6% | 8888.8 ± 0.9% | 953.2 ± 2.2% | 2.561 | 9.929 | 26.557 | 3.810 | 35.533 |
| string: canterbury-large/bible.txt | 1055886 | 8536.8 ± 1.9% | 5301.6 ± 1.7% | 2815.5 ± 0.6% | 353.7 ± 0.4% | 3894.0 ± 0.8% | 637.2 ± 1.5% | 1.610 | 3.032 | 24.132 | 2.192 | 13.397 |
| string: canterbury-large/world192.txt | 1103121 | 4185.8 ± 0.8% | 2309.0 ± 1.2% | 1773.3 ± 0.7% | 326.1 ± 1.3% | 2097.0 ± 1.1% | 463.8 ± 3.5% | 1.813 | 2.360 | 12.836 | 1.996 | 9.025 |
| string: http/html-1m | 1058582 | 9334.1 ± 3.4% | 4768.3 ± 1.0% | 2730.6 ± 1.9% | 402.4 ± 0.5% | 3658.3 ± 1.2% | 602.5 ± 1.7% | 1.958 | 3.418 | 23.197 | 2.551 | 15.492 |
| string: http/json-1m | 1190272 | 3335.6 ± 1.9% | 1252.1 ± 0.9% | 2020.4 ± 1.5% | 478.3 ± 1.4% | 1336.9 ± 1.6% | 427.3 ± 1.2% | 2.664 | 1.651 | 6.975 | 2.495 | 7.806 |
| string: http/js-1m | 1144362 | 2888.3 ± 0.5% | 1606.6 ± 0.5% | 1327.9 ± 3.6% | 319.9 ± 0.9% | 1412.7 ± 3.7% | 380.3 ± 0.5% | 1.798 | 2.175 | 9.029 | 2.045 | 7.595 |
| string: http/css-1m | 1097820 | 3315.2 ± 0.2% | 2893.0 ± 0.7% | 2269.5 ± 0.9% | 441.6 ± 0.6% | 2074.4 ± 0.6% | 438.3 ± 2.0% | 1.146 | 1.461 | 7.506 | 1.598 | 7.564 |
| string: dickens as Cyrillic and CJK | 1883069 | 5847.6 ± 0.4% | 2981.4 ± 1.0% | 664.9 ± 0.9% | 370.8 ± 0.8% | 511.9 ± 0.9% | 165.3 ± 2.2% | 1.961 | 8.795 | 15.770 | 11.424 | 35.386 |
| string: dickens as Cyrillic and CJK, as \u escapes | 5075485 | 1202.4 ± 8.1% | 1239.6 ± 1.4% | 1096.2 ± 1.0% | 265.5 ± 1.3% | 476.6 ± 0.8% | 227.8 ± 3.5% | 0.970 | 1.097 | 4.529 | 2.523 | 5.279 |
| hex: silesia/dickens | 524290 | 33893.7 ± 0.4% | 15111.1 ± 0.5% | 3492.3 ± 0.7% | 479.7 ± 0.2% | 8884.9 ± 3.4% | 1131.4 ± 2.3% | 2.243 | 9.705 | 70.650 | 3.815 | 29.958 |
| hex: silesia/mozilla | 524290 | 33697.8 ± 1.4% | 15034.1 ± 0.7% | 3549.8 ± 0.9% | 427.5 ± 1.4% | 8871.1 ± 0.9% | 1128.9 ± 4.4% | 2.241 | 9.493 | 78.827 | 3.799 | 29.850 |
| hex: silesia/mr | 524290 | 33635.6 ± 0.5% | 14996.1 ± 0.3% | 3500.4 ± 1.4% | 640.4 ± 0.7% | 8874.4 ± 0.6% | 1129.0 ± 1.2% | 2.243 | 9.609 | 52.519 | 3.790 | 29.792 |
| hex: silesia/nci | 524290 | 33774.7 ± 0.3% | 15043.4 ± 0.5% | 3484.5 ± 0.5% | 794.7 ± 0.7% | 8870.3 ± 0.6% | 1132.8 ± 0.3% | 2.245 | 9.693 | 42.499 | 3.808 | 29.816 |
| hex: silesia/ooffice | 524290 | 33790.0 ± 0.7% | 15054.5 ± 2.6% | 3551.6 ± 0.8% | 342.5 ± 2.0% | 8876.9 ± 0.2% | 1131.4 ± 0.8% | 2.245 | 9.514 | 98.657 | 3.806 | 29.867 |
| hex: silesia/osdb | 524290 | 33789.4 ± 0.8% | 15039.6 ± 0.5% | 3554.7 ± 0.5% | 444.9 ± 2.3% | 8882.2 ± 1.0% | 1134.2 ± 0.7% | 2.247 | 9.505 | 75.942 | 3.804 | 29.792 |
| hex: silesia/reymont | 524290 | 33806.0 ± 4.3% | 15058.0 ± 0.6% | 3484.0 ± 0.5% | 504.1 ± 2.7% | 8876.1 ± 1.8% | 1135.0 ± 0.6% | 2.245 | 9.703 | 67.056 | 3.809 | 29.784 |
| hex: silesia/samba | 524290 | 33842.8 ± 0.3% | 15043.2 ± 2.6% | 3561.0 ± 0.4% | 366.5 ± 1.7% | 8912.4 ± 0.5% | 1138.0 ± 3.0% | 2.250 | 9.504 | 92.331 | 3.797 | 29.738 |
| hex: silesia/sao | 524290 | 33803.4 ± 4.0% | 15074.1 ± 1.1% | 3424.9 ± 0.5% | 276.2 ± 1.5% | 8851.7 ± 4.6% | 1135.8 ± 0.6% | 2.242 | 9.870 | 122.408 | 3.819 | 29.761 |
| hex: silesia/webster | 524290 | 33814.6 ± 0.5% | 15067.1 ± 0.3% | 3559.2 ± 0.2% | 449.4 ± 0.8% | 8758.3 ± 4.2% | 1136.9 ± 0.6% | 2.244 | 9.501 | 75.245 | 3.861 | 29.743 |
| hex: silesia/x-ray | 524290 | 33865.4 ± 1.0% | 15103.9 ± 1.8% | 3490.2 ± 0.5% | 421.1 ± 0.7% | 8875.7 ± 0.9% | 1138.3 ± 0.6% | 2.242 | 9.703 | 80.423 | 3.816 | 29.751 |
| hex: silesia/xml | 524290 | 33839.7 ± 0.9% | 15102.0 ± 1.7% | 3557.6 ± 0.6% | 732.4 ± 1.0% | 8915.3 ± 0.3% | 1136.7 ± 0.5% | 2.241 | 9.512 | 46.203 | 3.796 | 29.770 |
| hex: canterbury/alice29.txt | 304180 | 33814.8 ± 0.5% | 14174.9 ± 2.3% | 3562.6 ± 0.5% | 485.5 ± 0.5% | 8905.2 ± 0.3% | 1146.9 ± 0.6% | 2.386 | 9.492 | 69.647 | 3.797 | 29.483 |
| hex: canterbury/asyoulik.txt | 250360 | 33794.3 ± 0.4% | 15098.7 ± 0.3% | 3500.4 ± 0.2% | 471.3 ± 0.3% | 8898.9 ± 0.2% | 1144.3 ± 0.8% | 2.238 | 9.654 | 71.711 | 3.798 | 29.532 |
| hex: canterbury/cp.html | 49208 | 33461.7 ± 0.3% | 14462.1 ± 0.2% | 3556.3 ± 3.6% | 504.8 ± 0.7% | 9266.2 ± 0.4% | 1129.3 ± 1.0% | 2.314 | 9.409 | 66.286 | 3.611 | 29.630 |
| hex: canterbury/fields.c | 22302 | 32987.0 ± 0.4% | 17726.8 ± 0.3% | 3675.6 ± 0.3% | 564.1 ± 0.6% | 9238.0 ± 0.5% | 1105.1 ± 2.0% | 1.861 | 8.975 | 58.477 | 3.571 | 29.849 |
| hex: canterbury/grammar.lsp | 7444 | 29821.5 ± 0.4% | 17259.8 ± 0.6% | 3628.9 ± 0.1% | 761.8 ± 1.1% | 8953.9 ± 0.2% | 1077.1 ± 1.5% | 1.728 | 8.218 | 39.144 | 3.331 | 27.688 |
| hex: canterbury/kennedy.xls | 524290 | 33964.2 ± 0.3% | 15135.4 ± 0.5% | 3544.4 ± 0.4% | 753.2 ± 0.7% | 8913.5 ± 0.3% | 1125.3 ± 4.1% | 2.244 | 9.583 | 45.093 | 3.810 | 30.182 |
| hex: canterbury/lcet10.txt | 524290 | 33992.3 ± 0.2% | 15140.0 ± 0.4% | 3568.3 ± 0.2% | 487.6 ± 0.7% | 8930.3 ± 4.6% | 1136.4 ± 1.4% | 2.245 | 9.526 | 69.708 | 3.806 | 29.913 |
| hex: canterbury/plrabn12.txt | 524290 | 33936.4 ± 0.3% | 15131.6 ± 0.2% | 3570.9 ± 3.3% | 468.4 ± 0.6% | 8919.0 ± 0.3% | 1140.6 ± 0.3% | 2.243 | 9.503 | 72.450 | 3.805 | 29.754 |
| hex: canterbury/ptt5 | 524290 | 33924.1 ± 0.2% | 15130.1 ± 0.4% | 3502.4 ± 0.0% | 668.8 ± 2.3% | 8906.8 ± 0.3% | 1143.3 ± 0.6% | 2.242 | 9.686 | 50.720 | 3.809 | 29.673 |
| hex: canterbury/sum | 76482 | 33348.1 ± 0.2% | 15458.0 ± 0.4% | 3571.3 ± 0.2% | 583.8 ± 0.4% | 8941.2 ± 0.1% | 1138.8 ± 1.3% | 2.157 | 9.338 | 57.118 | 3.730 | 29.284 |
| hex: canterbury/xargs.1 | 8456 | 30295.5 ± 0.2% | 17425.1 ± 0.2% | 3575.3 ± 0.2% | 728.7 ± 2.0% | 8974.4 ± 0.3% | 1113.6 ± 1.3% | 1.739 | 8.474 | 41.573 | 3.376 | 27.206 |
| hex: canterbury-large/E.coli | 524290 | 33993.3 ± 0.1% | 15157.2 ± 0.2% | 3486.7 ± 0.1% | 964.2 ± 0.1% | 8918.1 ± 0.2% | 1121.2 ± 3.5% | 2.243 | 9.749 | 35.256 | 3.812 | 30.320 |
| hex: canterbury-large/bible.txt | 524290 | 33978.1 ± 0.1% | 15152.9 ± 0.4% | 3500.5 ± 0.2% | 502.7 ± 0.5% | 8911.3 ± 0.5% | 1097.7 ± 3.7% | 2.242 | 9.707 | 67.595 | 3.813 | 30.955 |
| hex: canterbury-large/world192.txt | 524290 | 33970.9 ± 0.1% | 15171.5 ± 0.1% | 3566.1 ± 0.2% | 470.5 ± 0.5% | 8936.7 ± 0.3% | 1130.2 ± 1.8% | 2.239 | 9.526 | 72.206 | 3.801 | 30.058 |
| hex: http/html-1kx1024 | 2099200 | 15199.2 ± 0.2% | 12632.2 ± 11.1% | 3201.7 ± 2.7% | 507.9 ± 0.3% | 7480.2 ± 2.7% | 979.5 ± 1.2% | 1.203 | 4.747 | 29.926 | 2.032 | 15.517 |
| hex: http/html-16kx64 | 2097280 | 27993.9 ± 0.7% | 13993.0 ± 0.1% | 3415.5 ± 0.1% | 514.6 ± 0.4% | 8196.9 ± 4.6% | 1086.8 ± 2.1% | 2.001 | 8.196 | 54.398 | 3.415 | 25.758 |
| hex: http/html-1m | 524290 | 33989.7 ± 0.1% | 15168.3 ± 0.2% | 3505.4 ± 3.2% | 509.6 ± 0.3% | 8920.6 ± 0.2% | 1128.4 ± 3.6% | 2.241 | 9.696 | 66.693 | 3.810 | 30.121 |
| hex: http/json-1kx1024 | 2099200 | 15383.6 ± 0.4% | 12788.7 ± 7.0% | 3207.8 ± 3.0% | 681.3 ± 0.7% | 7425.9 ± 3.7% | 974.9 ± 1.3% | 1.203 | 4.796 | 22.581 | 2.072 | 15.780 |
| hex: http/json-16kx64 | 2097280 | 28134.6 ± 0.2% | 14079.7 ± 0.3% | 3415.6 ± 0.1% | 696.7 ± 0.5% | 8589.4 ± 7.9% | 1087.6 ± 1.2% | 1.998 | 8.237 | 40.382 | 3.276 | 25.868 |
| hex: http/json-1m | 524290 | 33987.0 ± 0.1% | 15160.5 ± 0.1% | 3550.2 ± 0.1% | 715.7 ± 0.8% | 8941.0 ± 0.6% | 1102.6 ± 4.1% | 2.242 | 9.573 | 47.491 | 3.801 | 30.824 |
| hex: http/js-1kx1024 | 2099200 | 15201.6 ± 0.2% | 12550.9 ± 7.3% | 3197.4 ± 0.3% | 492.2 ± 2.8% | 7515.4 ± 2.1% | 979.0 ± 1.1% | 1.211 | 4.754 | 30.882 | 2.023 | 15.527 |
| hex: http/js-16kx64 | 2097280 | 28017.0 ± 0.1% | 14064.3 ± 2.5% | 3414.3 ± 0.3% | 498.7 ± 0.6% | 8552.9 ± 0.7% | 1089.1 ± 1.4% | 1.992 | 8.206 | 56.182 | 3.276 | 25.726 |
| hex: http/js-1m | 524290 | 33995.0 ± 0.0% | 15168.6 ± 0.2% | 3572.8 ± 0.4% | 516.0 ± 0.7% | 8928.8 ± 0.3% | 1136.8 ± 1.2% | 2.241 | 9.515 | 65.884 | 3.807 | 29.903 |
| hex: http/css-1kx1024 | 2099200 | 15156.0 ± 0.5% | 12586.3 ± 1.1% | 3201.9 ± 0.2% | 570.1 ± 0.7% | 7516.1 ± 2.2% | 988.7 ± 3.0% | 1.204 | 4.733 | 26.584 | 2.016 | 15.329 |
| hex: http/css-16kx64 | 2097280 | 27782.0 ± 1.0% | 13943.0 ± 0.2% | 3402.3 ± 2.8% | 582.4 ± 0.5% | 8570.9 ± 0.5% | 1092.2 ± 3.0% | 1.993 | 8.166 | 47.700 | 3.241 | 25.436 |
| hex: http/css-1m | 524290 | 33995.1 ± 0.2% | 15167.1 ± 0.3% | 3560.1 ± 0.1% | 562.3 ± 0.7% | 8946.5 ± 0.2% | 1136.6 ± 1.0% | 2.241 | 9.549 | 60.460 | 3.800 | 29.909 |
| hex: shuffled/dickens-1m | 524290 | 34004.0 ± 0.1% | 15160.9 ± 0.5% | 3486.1 ± 0.1% | 480.8 ± 0.4% | 8935.6 ± 0.4% | 1142.3 ± 0.2% | 2.243 | 9.754 | 70.725 | 3.805 | 29.769 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1592.1 ± 0.3% | 1485.9 ± 0.1% | 1037.2 ± 3.4% | 481.2 ± 0.3% | 470.7 ± 1.6% | 505.5 ± 0.2% | 1.071 | 1.535 | 3.308 | 3.382 | 3.150 |
| qlog records, JSON text sequence | 1467503 | 1461.3 ± 0.3% | 1265.4 ± 1.4% | 968.3 ± 0.7% | 457.5 ± 0.6% | 575.4 ± 0.6% | 353.7 ± 0.3% | 1.155 | 1.509 | 3.194 | 2.539 | 4.131 |
| string: silesia/dickens | 172528 | 12184.1 ± 0.3% | 4024.7 ± 1.2% | 3069.1 ± 1.9% | 357.7 ± 2.6% | 1722.9 ± 1.4% | 1197.5 ± 0.3% | 3.027 | 3.970 | 34.064 | 7.072 | 10.174 |
| string: silesia/nci | 1075110 | 11006.0 ± 2.6% | 4708.4 ± 0.4% | 3126.0 ± 0.1% | 859.3 ± 0.7% | 1913.8 ± 0.5% | 1294.7 ± 1.4% | 2.338 | 3.521 | 12.809 | 5.751 | 8.501 |
| string: silesia/reymont | 1075159 | 5303.1 ± 0.5% | 1865.2 ± 0.9% | 1893.2 ± 0.8% | 396.0 ± 0.4% | 1450.1 ± 0.6% | 1053.5 ± 0.3% | 2.843 | 2.801 | 13.392 | 3.657 | 5.034 |
| string: silesia/samba | 97582 | 6269.1 ± 4.1% | 2728.6 ± 0.4% | 4067.5 ± 0.3% | 379.9 ± 0.3% | 1330.6 ± 0.6% | 1182.2 ± 1.8% | 2.298 | 1.541 | 16.501 | 4.712 | 5.303 |
| string: silesia/webster | 1098490 | 6650.7 ± 1.1% | 1990.6 ± 0.7% | 1751.9 ± 1.3% | 388.9 ± 0.9% | 1408.5 ± 1.5% | 602.3 ± 0.7% | 3.341 | 3.796 | 17.101 | 4.722 | 11.042 |
| string: silesia/xml | 1090118 | 9976.6 ± 0.5% | 3223.9 ± 1.2% | 2521.0 ± 4.1% | 629.8 ± 0.2% | 1950.0 ± 0.7% | 967.2 ± 4.2% | 3.095 | 3.957 | 15.842 | 5.116 | 10.315 |
| string: canterbury/alice29.txt | 159425 | 10688.9 ± 0.8% | 2913.7 ± 1.3% | 3112.6 ± 3.0% | 344.6 ± 0.7% | 1549.4 ± 1.2% | 1095.0 ± 0.7% | 3.669 | 3.434 | 31.016 | 6.899 | 9.761 |
| string: canterbury/asyoulik.txt | 132198 | 10508.2 ± 1.9% | 2115.9 ± 1.4% | 3127.6 ± 0.6% | 350.4 ± 0.4% | 1359.9 ± 1.9% | 964.8 ± 1.1% | 4.966 | 3.360 | 29.990 | 7.727 | 10.892 |
| string: canterbury/lcet10.txt | 441884 | 10560.5 ± 1.0% | 3102.3 ± 0.8% | 2593.1 ± 0.7% | 387.7 ± 0.4% | 1660.4 ± 1.7% | 1209.1 ± 1.0% | 3.404 | 4.073 | 27.238 | 6.360 | 8.734 |
| string: canterbury/plrabn12.txt | 503330 | 7877.0 ± 1.2% | 2315.4 ± 0.4% | 2102.4 ± 0.6% | 363.0 ± 2.0% | 1622.9 ± 1.6% | 1122.4 ± 0.9% | 3.402 | 3.747 | 21.700 | 4.854 | 7.018 |
| string: canterbury-large/E.coli | 1048578 | 30906.5 ± 3.9% | 16206.3 ± 0.3% | 3485.3 ± 0.3% | 1698.4 ± 0.3% | 3171.3 ± 0.2% | 1427.0 ± 0.1% | 1.907 | 8.868 | 18.197 | 9.746 | 21.658 |
| string: canterbury-large/bible.txt | 1055886 | 8949.9 ± 0.6% | 4880.8 ± 0.8% | 3012.3 ± 0.5% | 422.0 ± 0.4% | 2229.2 ± 0.2% | 1492.8 ± 4.1% | 1.834 | 2.971 | 21.208 | 4.015 | 5.995 |
| string: canterbury-large/world192.txt | 1103121 | 6431.9 ± 0.3% | 1744.0 ± 2.2% | 1903.9 ± 2.5% | 391.2 ± 0.2% | 1409.9 ± 1.0% | 982.1 ± 1.0% | 3.688 | 3.378 | 16.440 | 4.562 | 6.549 |
| string: http/html-1m | 1058582 | 10000.6 ± 2.1% | 4435.6 ± 0.5% | 2881.8 ± 0.6% | 465.6 ± 0.3% | 2174.7 ± 3.6% | 856.1 ± 0.8% | 2.255 | 3.470 | 21.480 | 4.599 | 11.681 |
| string: http/json-1m | 1190272 | 8466.5 ± 0.2% | 1593.5 ± 0.4% | 1575.6 ± 0.3% | 542.2 ± 0.5% | 1163.6 ± 3.4% | 852.3 ± 1.2% | 5.313 | 5.374 | 15.616 | 7.276 | 9.933 |
| string: http/js-1m | 1144362 | 6426.1 ± 0.9% | 1128.2 ± 0.1% | 1391.5 ± 2.5% | 363.4 ± 0.3% | 1124.8 ± 0.8% | 754.1 ± 0.6% | 5.696 | 4.618 | 17.682 | 5.713 | 8.522 |
| string: http/css-1m | 1097820 | 8176.7 ± 0.6% | 1495.9 ± 0.5% | 2308.6 ± 0.1% | 548.8 ± 0.3% | 1275.9 ± 0.7% | 886.5 ± 1.1% | 5.466 | 3.542 | 14.900 | 6.408 | 9.224 |
| string: dickens as Cyrillic and CJK | 1883069 | 5516.6 ± 1.6% | 3729.8 ± 2.9% | 486.1 ± 0.3% | 252.9 ± 0.5% | 467.0 ± 0.2% | 358.6 ± 0.3% | 1.479 | 11.350 | 21.813 | 11.813 | 15.383 |
| hex: silesia/dickens | 524290 | 43808.2 ± 0.2% | 2612.7 ± 0.1% | 1456.5 ± 4.2% | 470.8 ± 3.1% | 1581.9 ± 0.1% | 1064.1 ± 0.2% | 16.768 | 30.079 | 93.058 | 27.694 | 41.169 |
| hex: silesia/mozilla | 524290 | 43676.3 ± 0.1% | 2606.5 ± 5.7% | 1443.1 ± 4.3% | 419.2 ± 0.5% | 1577.6 ± 0.2% | 1068.5 ± 0.1% | 16.757 | 30.266 | 104.197 | 27.686 | 40.874 |
| hex: silesia/mr | 524290 | 43784.5 ± 0.1% | 2582.9 ± 0.5% | 1505.2 ± 0.3% | 610.8 ± 0.5% | 1575.1 ± 0.1% | 1068.8 ± 0.2% | 16.952 | 29.088 | 71.687 | 27.798 | 40.967 |
| hex: silesia/nci | 524290 | 43798.0 ± 0.2% | 2584.5 ± 0.2% | 1503.4 ± 0.4% | 753.0 ± 0.2% | 1559.5 ± 0.1% | 1069.3 ± 0.1% | 16.947 | 29.132 | 58.162 | 28.084 | 40.960 |
| hex: silesia/ooffice | 524290 | 43803.5 ± 0.1% | 2608.7 ± 0.1% | 1511.1 ± 0.2% | 347.4 ± 0.3% | 1583.5 ± 0.2% | 1069.3 ± 0.2% | 16.791 | 28.987 | 126.075 | 27.663 | 40.966 |
| hex: silesia/osdb | 524290 | 43771.5 ± 0.1% | 2610.8 ± 0.5% | 1510.6 ± 0.4% | 456.5 ± 0.5% | 1575.5 ± 0.3% | 1068.9 ± 0.4% | 16.766 | 28.976 | 95.885 | 27.783 | 40.949 |
| hex: silesia/reymont | 524290 | 43833.5 ± 0.2% | 2607.5 ± 0.2% | 1510.4 ± 0.1% | 499.2 ± 0.5% | 1579.8 ± 0.4% | 1069.2 ± 0.2% | 16.811 | 29.022 | 87.801 | 27.746 | 40.995 |
| hex: silesia/samba | 524290 | 43889.8 ± 0.2% | 2618.5 ± 0.3% | 1511.4 ± 0.2% | 367.4 ± 0.6% | 1572.9 ± 0.1% | 1071.2 ± 0.1% | 16.761 | 29.038 | 119.453 | 27.903 | 40.971 |
| hex: silesia/sao | 524290 | 42935.6 ± 0.3% | 2610.9 ± 0.1% | 1513.2 ± 0.1% | 283.9 ± 0.5% | 1579.8 ± 0.2% | 1069.4 ± 0.1% | 16.444 | 28.374 | 151.224 | 27.178 | 40.149 |
| hex: silesia/webster | 524290 | 44125.8 ± 0.0% | 2620.4 ± 0.1% | 1513.0 ± 0.1% | 454.7 ± 0.4% | 1572.9 ± 0.1% | 1060.4 ± 5.2% | 16.840 | 29.165 | 97.043 | 28.053 | 41.614 |
| hex: silesia/x-ray | 524290 | 43850.5 ± 0.2% | 2603.8 ± 0.3% | 1511.3 ± 0.2% | 432.8 ± 3.1% | 1580.1 ± 5.3% | 1067.6 ± 0.2% | 16.841 | 29.015 | 101.321 | 27.751 | 41.073 |
| hex: silesia/xml | 524290 | 43820.6 ± 0.1% | 2618.1 ± 0.7% | 1511.3 ± 0.3% | 734.5 ± 0.5% | 1571.9 ± 0.2% | 1069.1 ± 0.3% | 16.738 | 28.995 | 59.658 | 27.877 | 40.989 |
| hex: canterbury/alice29.txt | 304180 | 43783.8 ± 0.1% | 2638.0 ± 0.2% | 1529.3 ± 0.0% | 480.5 ± 2.7% | 1598.7 ± 0.1% | 1083.9 ± 0.2% | 16.597 | 28.630 | 91.123 | 27.387 | 40.395 |
| hex: canterbury/asyoulik.txt | 250360 | 43705.8 ± 0.1% | 2639.8 ± 0.0% | 1545.6 ± 0.0% | 470.3 ± 0.2% | 1599.4 ± 0.1% | 1081.9 ± 0.3% | 16.556 | 28.277 | 92.931 | 27.326 | 40.398 |
| hex: canterbury/cp.html | 49208 | 42807.6 ± 0.1% | 2618.3 ± 5.5% | 1530.3 ± 0.2% | 517.4 ± 0.4% | 1598.8 ± 0.3% | 1093.7 ± 0.1% | 16.350 | 27.973 | 82.738 | 26.774 | 39.139 |
| hex: canterbury/fields.c | 22302 | 42140.9 ± 0.1% | 2674.4 ± 6.4% | 1538.3 ± 0.5% | 631.0 ± 0.4% | 1615.3 ± 7.4% | 1099.3 ± 0.1% | 15.757 | 27.394 | 66.790 | 26.088 | 38.334 |
| hex: canterbury/grammar.lsp | 7444 | 40855.7 ± 0.3% | 2706.0 ± 0.4% | 1543.8 ± 0.4% | 804.6 ± 0.5% | 1617.8 ± 1.6% | 1111.5 ± 3.8% | 15.098 | 26.464 | 50.779 | 25.253 | 36.758 |
| hex: canterbury/kennedy.xls | 524290 | 41954.6 ± 0.2% | 2599.4 ± 0.3% | 1506.7 ± 4.7% | 740.6 ± 0.3% | 1535.0 ± 0.1% | 1071.4 ± 0.2% | 16.140 | 27.846 | 56.650 | 27.332 | 39.158 |
| hex: canterbury/lcet10.txt | 524290 | 43737.0 ± 0.1% | 2588.0 ± 0.5% | 1508.6 ± 0.3% | 477.3 ± 0.2% | 1563.2 ± 0.2% | 1069.1 ± 0.2% | 16.900 | 28.991 | 91.633 | 27.979 | 40.912 |
| hex: canterbury/plrabn12.txt | 524290 | 43755.4 ± 0.2% | 2608.8 ± 0.1% | 1509.6 ± 0.1% | 463.5 ± 0.1% | 1581.7 ± 0.2% | 1069.3 ± 0.4% | 16.772 | 28.985 | 94.397 | 27.663 | 40.921 |
| hex: canterbury/ptt5 | 524290 | 43781.1 ± 0.1% | 2581.3 ± 0.3% | 1504.4 ± 0.3% | 615.2 ± 0.5% | 1562.9 ± 0.2% | 1070.3 ± 0.2% | 16.961 | 29.102 | 71.171 | 28.012 | 40.906 |
| hex: canterbury/sum | 76482 | 43152.5 ± 0.4% | 2610.6 ± 7.2% | 1523.3 ± 0.3% | 594.3 ± 0.6% | 1590.8 ± 0.2% | 1092.3 ± 0.1% | 16.530 | 28.328 | 72.609 | 27.127 | 39.507 |
| hex: canterbury/xargs.1 | 8456 | 41253.5 ± 0.2% | 2705.3 ± 0.2% | 1547.1 ± 4.5% | 831.8 ± 0.4% | 1617.5 ± 0.6% | 1115.2 ± 0.6% | 15.249 | 26.665 | 49.594 | 25.504 | 36.993 |
| hex: canterbury-large/E.coli | 524290 | 43684.3 ± 0.6% | 2597.0 ± 0.1% | 1509.3 ± 0.1% | 808.1 ± 0.1% | 1536.8 ± 0.5% | 1070.1 ± 0.4% | 16.821 | 28.944 | 54.058 | 28.426 | 40.821 |
| hex: canterbury-large/bible.txt | 524290 | 43815.6 ± 0.2% | 2617.9 ± 8.9% | 1512.2 ± 0.2% | 491.3 ± 0.6% | 1569.1 ± 0.1% | 1069.0 ± 0.2% | 16.737 | 28.975 | 89.191 | 27.923 | 40.987 |
| hex: canterbury-large/world192.txt | 524290 | 43844.1 ± 2.5% | 2617.2 ± 0.3% | 1511.2 ± 0.2% | 465.7 ± 0.4% | 1541.1 ± 0.2% | 1072.1 ± 0.1% | 16.752 | 29.012 | 94.153 | 28.450 | 40.894 |
| hex: http/html-1kx1024 | 2099200 | 21357.5 ± 0.2% | 2434.1 ± 0.5% | 1459.4 ± 3.5% | 514.8 ± 0.1% | 1526.1 ± 5.5% | 1079.8 ± 1.1% | 8.774 | 14.635 | 41.485 | 13.995 | 19.780 |
| hex: http/html-16kx64 | 2097280 | 22168.1 ± 0.2% | 2388.5 ± 0.2% | 1449.5 ± 0.9% | 483.7 ± 0.4% | 1242.3 ± 0.5% | 1084.7 ± 0.1% | 9.281 | 15.294 | 45.834 | 17.844 | 20.437 |
| hex: http/html-1m | 524290 | 40411.6 ± 0.2% | 2612.3 ± 0.3% | 1505.6 ± 0.6% | 508.2 ± 0.4% | 1581.8 ± 0.2% | 1070.6 ± 0.2% | 15.470 | 26.841 | 79.513 | 25.548 | 37.747 |
| hex: http/json-1kx1024 | 2099200 | 20202.1 ± 0.2% | 2451.7 ± 0.9% | 1458.1 ± 0.3% | 689.5 ± 0.3% | 1528.7 ± 0.3% | 1078.8 ± 0.3% | 8.240 | 13.855 | 29.298 | 13.215 | 18.726 |
| hex: http/json-16kx64 | 2097280 | 22090.6 ± 0.1% | 2381.9 ± 0.2% | 1449.2 ± 0.2% | 699.3 ± 0.4% | 1499.2 ± 0.2% | 1084.1 ± 0.2% | 9.274 | 15.243 | 31.591 | 14.735 | 20.377 |
| hex: http/json-1m | 524290 | 43784.1 ± 0.1% | 2603.6 ± 0.1% | 1508.4 ± 5.0% | 720.7 ± 4.6% | 1554.1 ± 0.1% | 1067.5 ± 0.1% | 16.817 | 29.026 | 60.754 | 28.173 | 41.017 |
| hex: http/js-1kx1024 | 2099200 | 20955.7 ± 0.2% | 2433.2 ± 0.8% | 1467.0 ± 0.6% | 500.1 ± 0.3% | 1527.2 ± 0.4% | 1080.9 ± 0.1% | 8.612 | 14.285 | 41.903 | 13.722 | 19.387 |
| hex: http/js-16kx64 | 2097280 | 21965.3 ± 0.5% | 2385.8 ± 0.1% | 1448.8 ± 0.1% | 501.9 ± 0.3% | 1500.1 ± 0.2% | 1084.7 ± 0.3% | 9.207 | 15.161 | 43.761 | 14.643 | 20.250 |
| hex: http/js-1m | 524290 | 43023.3 ± 0.2% | 2601.7 ± 0.2% | 1504.9 ± 0.3% | 514.7 ± 0.4% | 1557.1 ± 0.1% | 1067.5 ± 0.2% | 16.536 | 28.589 | 83.584 | 27.631 | 40.305 |
| hex: http/css-1kx1024 | 2099200 | 20530.8 ± 0.4% | 2456.1 ± 0.6% | 1469.4 ± 0.5% | 578.2 ± 0.2% | 1534.7 ± 0.8% | 1078.9 ± 3.7% | 8.359 | 13.972 | 35.507 | 13.378 | 19.030 |
| hex: http/css-16kx64 | 2097280 | 21629.8 ± 0.9% | 2392.1 ± 0.3% | 1450.3 ± 0.1% | 585.3 ± 0.5% | 1502.6 ± 0.1% | 1083.1 ± 5.6% | 9.042 | 14.914 | 36.958 | 14.395 | 19.969 |
| hex: http/css-1m | 524290 | 43810.4 ± 0.2% | 2617.7 ± 0.5% | 1510.0 ± 0.1% | 562.9 ± 0.8% | 1582.6 ± 3.0% | 1068.9 ± 5.8% | 16.736 | 29.013 | 77.836 | 27.683 | 40.988 |
| hex: shuffled/dickens-1m | 524290 | 43701.3 ± 0.1% | 2616.5 ± 0.1% | 1511.7 ± 0.1% | 468.3 ± 0.2% | 1535.7 ± 0.3% | 1070.3 ± 6.2% | 16.702 | 28.908 | 93.319 | 28.456 | 40.830 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding: stdx runs at 0.893 of simdjson.
- qlog records, JSON text sequence, decoding: stdx runs at 0.894 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.746 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.831 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.894 of yyjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next_items: stdx runs at 0.850 of simdjson.
