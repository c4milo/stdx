# bench-json

| Field | Value |
|---|---|
| Commit | 4dbe46c |
| Runner label | ubuntu-24.04 |
| Image version | 20261111.127.1 |
| CPU model | Intel(R) Xeon(R) 6975P-C |
| Virtual CPUs | 4 |
| Kernel | 7.0.0-1014-aws |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/43464690664 |
| Date | 2026-11-13 |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1. The `TextReader.next_items` column is that helper's queued tokens a slice a call (decision 79), over many tokens a call.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | TextReader.next_items | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1376.6 ± 0.3% | 0.487 | 1.018 | 1.062 | 1.063 | 0.407 | 1.065 | 1.066 | 0.369 | 0.835 | 0.943 | 0.106 |
| qlog records, JSON text sequence | 1467503 | 1090.0 ± 0.8% | 0.795 | 1.067 | 1.067 | 1.077 | 0.390 | 1.069 | 1.079 | 0.365 | 0.932 | 1.083 | 0.126 |
| string: silesia/dickens | 172528 | 6013.4 ± 0.3% | 0.032 | 0.771 | 1.201 | 1.180 | 0.210 | 1.150 | 1.196 | 0.211 | 0.996 | 1.002 | 0.032 |
| string: silesia/nci | 1075110 | 4732.6 ± 0.5% | 0.040 | 0.809 | 1.183 | 1.180 | 0.323 | 1.191 | 1.182 | 0.322 | 0.998 | 1.004 | 0.040 |
| string: silesia/reymont | 1075159 | 4026.0 ± 1.6% | 0.048 | 0.547 | 0.754 | 0.762 | 0.297 | 0.712 | 0.764 | 0.296 | 1.003 | 1.012 | 0.048 |
| string: silesia/samba | 97582 | 4050.5 ± 1.1% | 0.040 | 0.887 | 1.042 | 1.042 | 0.073 | 0.843 | 1.045 | 0.073 | 0.999 | 0.999 | 0.040 |
| string: silesia/webster | 1098490 | 4141.2 ± 1.2% | 0.045 | 0.691 | 1.034 | 1.046 | 0.217 | 0.983 | 1.054 | 0.217 | 0.997 | 1.006 | 0.045 |
| string: silesia/xml | 1090118 | 5924.6 ± 0.6% | 0.033 | 0.793 | 0.984 | 0.985 | 0.246 | 0.972 | 0.990 | 0.246 | 1.005 | 1.005 | 0.033 |
| string: canterbury/alice29.txt | 159425 | 5945.0 ± 1.4% | 0.032 | 0.719 | 1.040 | 1.068 | 0.165 | 0.982 | 1.108 | 0.164 | 0.992 | 1.024 | 0.032 |
| string: canterbury/asyoulik.txt | 132198 | 4229.4 ± 1.2% | 0.043 | 0.818 | 1.137 | 1.138 | 0.191 | 1.056 | 1.151 | 0.191 | 1.000 | 1.010 | 0.043 |
| string: canterbury/lcet10.txt | 441884 | 5983.5 ± 1.1% | 0.032 | 0.673 | 1.221 | 1.213 | 0.203 | 1.150 | 1.224 | 0.203 | 1.000 | 1.003 | 0.032 |
| string: canterbury/plrabn12.txt | 503330 | 5908.2 ± 0.9% | 0.032 | 0.709 | 0.892 | 0.896 | 0.194 | 0.799 | 0.898 | 0.194 | 1.003 | 1.004 | 0.032 |
| string: canterbury-large/E.coli | 1048578 | 33030.0 ± 0.7% | 0.054 | 1.005 | 0.752 | 1.005 | 0.495 | 1.005 | 1.006 | 0.494 | 1.026 | 1.021 | 0.006 |
| string: canterbury-large/bible.txt | 1055886 | 9082.9 ± 3.0% | 0.022 | 0.582 | 0.820 | 0.823 | 0.360 | 0.830 | 0.839 | 0.360 | 0.993 | 1.003 | 0.022 |
| string: canterbury-large/world192.txt | 1103121 | 3992.3 ± 0.7% | 0.047 | 0.716 | 1.007 | 1.009 | 0.206 | 0.958 | 1.024 | 0.206 | 1.002 | 1.007 | 0.047 |
| string: http/html-1m | 1058582 | 7755.0 ± 2.1% | 0.026 | 0.658 | 0.917 | 0.919 | 0.363 | 0.876 | 0.930 | 0.362 | 0.991 | 1.008 | 0.026 |
| string: http/json-1m | 1190272 | 3174.0 ± 0.7% | 0.054 | 0.412 | 0.461 | 0.465 | 0.145 | 0.478 | 0.465 | 0.144 | 1.002 | 1.001 | 0.054 |
| string: http/js-1m | 1144362 | 2985.1 ± 1.0% | 0.059 | 0.670 | 0.867 | 0.880 | 0.171 | 0.812 | 0.882 | 0.171 | 1.004 | 1.004 | 0.059 |
| string: http/css-1m | 1097820 | 3040.8 ± 1.1% | 0.059 | 0.836 | 1.091 | 1.085 | 0.299 | 1.065 | 1.089 | 0.298 | 1.004 | 1.007 | 0.059 |
| string: dickens as Cyrillic and CJK | 1883069 | 5796.7 ± 0.9% | 0.025 | 0.062 | 0.442 | 0.440 | 0.194 | 0.434 | 0.441 | 0.194 | 1.007 | 1.010 | 0.025 |
| string: dickens as Cyrillic and CJK, as \u escapes | 5075485 | 1193.7 ± 0.8% | 0.112 | 1.001 | 1.002 | 1.006 | 0.107 | 0.716 | 1.006 | 0.107 | 1.005 | 1.013 | 0.113 |
| hex: silesia/dickens | 524290 | 46097.1 ± 2.3% | 0.040 | 1.003 | 0.616 | 1.001 | 0.391 | 0.999 | 1.001 | 0.391 | 0.735 | 0.732 | 0.005 |
| hex: silesia/mozilla | 524290 | 46221.3 ± 0.8% | 0.039 | 1.000 | 0.617 | 0.999 | 0.389 | 0.999 | 1.000 | 0.388 | 0.729 | 0.729 | 0.005 |
| hex: silesia/mr | 524290 | 45182.7 ± 1.3% | 0.040 | 1.003 | 0.617 | 1.005 | 0.396 | 0.998 | 1.006 | 0.398 | 0.747 | 0.749 | 0.005 |
| hex: silesia/nci | 524290 | 46308.7 ± 1.7% | 0.039 | 1.009 | 0.614 | 1.008 | 0.387 | 1.003 | 1.003 | 0.387 | 0.730 | 0.729 | 0.005 |
| hex: silesia/ooffice | 524290 | 47587.2 ± 0.6% | 0.038 | 1.002 | 0.597 | 1.003 | 0.377 | 0.993 | 1.000 | 0.379 | 0.713 | 0.711 | 0.004 |
| hex: silesia/osdb | 524290 | 46100.9 ± 1.8% | 0.040 | 0.999 | 0.607 | 1.001 | 0.391 | 1.000 | 1.000 | 0.391 | 0.734 | 0.733 | 0.005 |
| hex: silesia/reymont | 524290 | 43985.7 ± 4.1% | 0.041 | 0.999 | 0.647 | 1.002 | 0.398 | 1.008 | 1.007 | 0.401 | 0.770 | 0.771 | 0.005 |
| hex: silesia/samba | 524290 | 45164.6 ± 1.3% | 0.040 | 1.006 | 0.629 | 1.001 | 0.400 | 0.998 | 1.005 | 0.398 | 0.748 | 0.747 | 0.005 |
| hex: silesia/sao | 524290 | 46136.1 ± 1.8% | 0.040 | 1.005 | 0.617 | 1.007 | 0.389 | 1.006 | 1.005 | 0.387 | 0.734 | 0.732 | 0.005 |
| hex: silesia/webster | 524290 | 43805.6 ± 0.4% | 0.042 | 1.005 | 0.639 | 1.004 | 0.397 | 1.007 | 1.007 | 0.397 | 0.775 | 0.773 | 0.005 |
| hex: silesia/x-ray | 524290 | 45429.4 ± 1.3% | 0.040 | 1.008 | 0.620 | 1.006 | 0.396 | 1.002 | 1.005 | 0.397 | 0.744 | 0.746 | 0.005 |
| hex: silesia/xml | 524290 | 45677.4 ± 1.8% | 0.040 | 1.003 | 0.629 | 1.003 | 0.393 | 1.003 | 1.014 | 0.394 | 0.742 | 0.741 | 0.005 |
| hex: canterbury/alice29.txt | 304180 | 46575.7 ± 1.3% | 0.039 | 0.999 | 0.611 | 0.998 | 0.384 | 0.997 | 0.998 | 0.387 | 0.724 | 0.726 | 0.005 |
| hex: canterbury/asyoulik.txt | 250360 | 47369.2 ± 0.7% | 0.039 | 0.999 | 0.587 | 0.999 | 0.379 | 0.998 | 0.993 | 0.379 | 0.712 | 0.713 | 0.004 |
| hex: canterbury/cp.html | 49208 | 44463.3 ± 2.3% | 0.041 | 1.000 | 0.623 | 1.003 | 0.396 | 0.998 | 1.003 | 0.399 | 0.751 | 0.750 | 0.005 |
| hex: canterbury/fields.c | 22302 | 49114.9 ± 1.2% | 0.038 | 1.023 | 0.556 | 0.996 | 0.392 | 0.991 | 1.006 | 0.400 | 0.668 | 0.669 | 0.004 |
| hex: canterbury/grammar.lsp | 7444 | 43808.4 ± 3.0% | 0.042 | 0.971 | 0.579 | 1.000 | 0.418 | 0.994 | 1.004 | 0.440 | 0.681 | 0.677 | 0.005 |
| hex: canterbury/kennedy.xls | 524290 | 47702.2 ± 0.2% | 0.038 | 1.004 | 0.598 | 0.999 | 0.377 | 1.004 | 1.002 | 0.377 | 0.710 | 0.710 | 0.004 |
| hex: canterbury/lcet10.txt | 524290 | 45950.1 ± 1.0% | 0.040 | 0.998 | 0.615 | 1.001 | 0.389 | 0.998 | 1.000 | 0.388 | 0.735 | 0.733 | 0.005 |
| hex: canterbury/plrabn12.txt | 524290 | 48207.2 ± 0.6% | 0.038 | 1.001 | 0.588 | 1.001 | 0.371 | 1.000 | 1.000 | 0.372 | 0.700 | 0.699 | 0.004 |
| hex: canterbury/ptt5 | 524290 | 45738.4 ± 0.9% | 0.040 | 1.000 | 0.612 | 0.999 | 0.391 | 0.997 | 0.997 | 0.392 | 0.736 | 0.737 | 0.005 |
| hex: canterbury/sum | 76482 | 44691.4 ± 1.3% | 0.041 | 1.001 | 0.620 | 0.997 | 0.394 | 0.997 | 0.998 | 0.396 | 0.743 | 0.744 | 0.005 |
| hex: canterbury/xargs.1 | 8456 | 44714.7 ± 3.0% | 0.041 | 0.967 | 0.572 | 1.009 | 0.413 | 0.981 | 1.001 | 0.430 | 0.676 | 0.675 | 0.005 |
| hex: canterbury-large/E.coli | 524290 | 45980.1 ± 2.0% | 0.040 | 1.001 | 0.619 | 0.997 | 0.391 | 0.995 | 1.003 | 0.391 | 0.734 | 0.733 | 0.005 |
| hex: canterbury-large/bible.txt | 524290 | 47943.6 ± 0.5% | 0.038 | 1.003 | 0.583 | 1.003 | 0.374 | 1.001 | 1.003 | 0.375 | 0.703 | 0.703 | 0.004 |
| hex: canterbury-large/world192.txt | 524290 | 44939.9 ± 1.6% | 0.041 | 0.999 | 0.640 | 1.004 | 0.402 | 0.999 | 0.999 | 0.403 | 0.754 | 0.755 | 0.005 |
| hex: http/html-1kx1024 | 2099200 | 17672.7 ± 0.5% | 0.102 | 1.032 | 0.814 | 0.998 | 0.605 | 1.006 | 0.998 | 0.665 | 0.865 | 0.845 | 0.012 |
| hex: http/html-16kx64 | 2097280 | 33341.6 ± 4.8% | 0.055 | 1.007 | 0.712 | 1.007 | 0.485 | 1.008 | 1.008 | 0.489 | 0.826 | 0.827 | 0.006 |
| hex: http/html-1m | 524290 | 46799.2 ± 1.4% | 0.039 | 0.999 | 0.609 | 1.000 | 0.382 | 1.000 | 1.002 | 0.385 | 0.724 | 0.724 | 0.004 |
| hex: http/json-1kx1024 | 2099200 | 17442.5 ± 2.0% | 0.103 | 1.035 | 0.815 | 0.997 | 0.592 | 1.005 | 1.002 | 0.653 | 0.868 | 0.843 | 0.012 |
| hex: http/json-16kx64 | 2097280 | 34266.7 ± 1.7% | 0.053 | 1.002 | 0.693 | 1.002 | 0.474 | 1.002 | 1.002 | 0.478 | 0.806 | 0.805 | 0.006 |
| hex: http/json-1m | 524290 | 45308.7 ± 2.7% | 0.040 | 1.001 | 0.626 | 1.000 | 0.394 | 0.996 | 0.999 | 0.395 | 0.744 | 0.745 | 0.005 |
| hex: http/js-1kx1024 | 2099200 | 17684.6 ± 3.2% | 0.102 | 1.044 | 0.815 | 1.004 | 0.590 | 1.010 | 1.006 | 0.649 | 0.869 | 0.849 | 0.012 |
| hex: http/js-16kx64 | 2097280 | 34896.3 ± 0.8% | 0.052 | 1.006 | 0.685 | 1.003 | 0.468 | 1.003 | 0.999 | 0.473 | 0.796 | 0.796 | 0.006 |
| hex: http/js-1m | 524290 | 45593.2 ± 7.3% | 0.040 | 1.007 | 0.618 | 1.002 | 0.392 | 1.002 | 0.998 | 0.393 | 0.742 | 0.741 | 0.005 |
| hex: http/css-1kx1024 | 2099200 | 17545.3 ± 1.6% | 0.103 | 1.052 | 0.819 | 1.002 | 0.610 | 1.005 | 1.000 | 0.672 | 0.865 | 0.845 | 0.012 |
| hex: http/css-16kx64 | 2097280 | 33864.3 ± 1.2% | 0.054 | 0.999 | 0.688 | 1.003 | 0.473 | 1.001 | 1.007 | 0.478 | 0.808 | 0.806 | 0.006 |
| hex: http/css-1m | 524290 | 45504.6 ± 1.8% | 0.040 | 1.000 | 0.612 | 0.995 | 0.395 | 0.996 | 0.996 | 0.396 | 0.744 | 0.744 | 0.005 |
| hex: shuffled/dickens-1m | 524290 | 45109.7 ± 0.9% | 0.040 | 0.994 | 0.632 | 0.997 | 0.395 | 0.998 | 0.996 | 0.395 | 0.750 | 0.749 | 0.005 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1761.3 ± 1.9% | 0.421 | 0.996 | 0.965 | 1.004 | 1.006 | 0.267 | 1.005 | 0.519 | 0.901 | 0.093 | 1.021 |
| qlog records, JSON text sequence | 1467503 | 1652.5 ± 2.4% | 0.639 | 0.964 | 0.983 | 1.007 | 0.989 | 0.235 | 0.982 | 0.449 | 0.877 | 0.106 | 1.039 |
| string: silesia/dickens | 172528 | 12607.9 ± 1.4% | 0.018 | 0.548 | 0.371 | 0.549 | 0.571 | 0.119 | 0.574 | 0.997 | 0.995 | 0.018 | 1.103 |
| string: silesia/nci | 1075110 | 11426.1 ± 0.7% | 0.020 | 0.518 | 0.355 | 0.528 | 0.517 | 0.165 | 0.518 | 1.001 | 1.004 | 0.020 | 1.068 |
| string: silesia/reymont | 1075159 | 5334.7 ± 1.5% | 0.043 | 0.577 | 0.433 | 0.511 | 0.581 | 0.268 | 0.575 | 1.003 | 1.007 | 0.042 | 1.033 |
| string: silesia/samba | 97582 | 6533.6 ± 1.5% | 0.043 | 0.852 | 0.715 | 0.862 | 0.855 | 0.113 | 0.856 | 1.005 | 1.006 | 0.043 | 1.127 |
| string: silesia/webster | 1098490 | 6687.6 ± 1.5% | 0.033 | 0.608 | 0.417 | 0.575 | 0.609 | 0.159 | 0.608 | 1.003 | 1.006 | 0.033 | 1.057 |
| string: silesia/xml | 1090118 | 10092.7 ± 1.2% | 0.023 | 0.594 | 0.493 | 0.589 | 0.599 | 0.202 | 0.600 | 0.998 | 1.009 | 0.023 | 1.134 |
| string: canterbury/alice29.txt | 159425 | 11077.4 ± 3.0% | 0.020 | 0.497 | 0.408 | 0.481 | 0.525 | 0.102 | 0.542 | 0.991 | 0.995 | 0.020 | 1.262 |
| string: canterbury/asyoulik.txt | 132198 | 10654.2 ± 5.5% | 0.020 | 0.402 | 0.341 | 0.402 | 0.417 | 0.088 | 0.427 | 0.998 | 1.041 | 0.020 | 1.149 |
| string: canterbury/lcet10.txt | 441884 | 10831.9 ± 0.3% | 0.021 | 0.633 | 0.378 | 0.620 | 0.636 | 0.133 | 0.638 | 1.004 | 1.006 | 0.021 | 1.217 |
| string: canterbury/plrabn12.txt | 503330 | 8254.4 ± 4.9% | 0.027 | 0.660 | 0.531 | 0.663 | 0.663 | 0.165 | 0.663 | 1.019 | 1.036 | 0.027 | 1.146 |
| string: canterbury-large/E.coli | 1048578 | 31103.9 ± 0.4% | 0.058 | 1.000 | 0.999 | 0.760 | 1.000 | 0.516 | 1.002 | 1.000 | 1.004 | 0.008 | 1.003 |
| string: canterbury-large/bible.txt | 1055886 | 8946.7 ± 0.5% | 0.026 | 0.800 | 0.613 | 0.751 | 0.808 | 0.409 | 0.812 | 0.998 | 1.002 | 0.026 | 1.110 |
| string: canterbury-large/world192.txt | 1103121 | 6457.6 ± 0.7% | 0.034 | 0.606 | 0.435 | 0.572 | 0.607 | 0.151 | 0.610 | 0.999 | 1.003 | 0.034 | 1.017 |
| string: http/html-1m | 1058582 | 9958.7 ± 0.9% | 0.023 | 0.650 | 0.547 | 0.614 | 0.653 | 0.315 | 0.652 | 1.002 | 1.009 | 0.024 | 1.016 |
| string: http/json-1m | 1190272 | 8478.5 ± 0.9% | 0.024 | 0.182 | 0.159 | 0.182 | 0.183 | 0.072 | 0.183 | 0.996 | 1.001 | 0.024 | 1.017 |
| string: http/js-1m | 1144362 | 6436.3 ± 3.6% | 0.033 | 0.376 | 0.316 | 0.362 | 0.375 | 0.092 | 0.375 | 0.997 | 1.008 | 0.033 | 1.046 |
| string: http/css-1m | 1097820 | 8305.1 ± 0.9% | 0.026 | 0.394 | 0.317 | 0.378 | 0.394 | 0.135 | 0.393 | 1.001 | 1.005 | 0.026 | 1.149 |
| string: dickens as Cyrillic and CJK | 1883069 | 5562.9 ± 0.7% | 0.030 | 0.453 | 0.065 | 0.453 | 0.455 | 0.203 | 0.455 | 1.001 | 1.004 | 0.030 | 1.012 |
| hex: silesia/dickens | 524290 | 43588.8 ± 0.7% | 1.001 | 0.088 | 1.001 | 0.589 | 1.001 | 0.999 | 1.000 | 1.001 | 1.002 | 0.091 | 1.001 |
| hex: silesia/mozilla | 524290 | 43271.1 ± 1.5% | 0.973 | 0.089 | 1.001 | 0.592 | 1.004 | 1.001 | 0.940 | 1.002 | 1.000 | 0.092 | 1.001 |
| hex: silesia/mr | 524290 | 43642.3 ± 0.6% | 0.999 | 0.088 | 1.001 | 0.589 | 1.002 | 1.001 | 1.001 | 1.003 | 1.002 | 0.088 | 1.003 |
| hex: silesia/nci | 524290 | 43336.0 ± 3.1% | 1.003 | 0.089 | 1.003 | 0.593 | 1.010 | 1.007 | 1.008 | 1.004 | 1.002 | 0.094 | 1.004 |
| hex: silesia/ooffice | 524290 | 42645.3 ± 1.8% | 1.004 | 0.090 | 1.006 | 0.600 | 1.005 | 1.005 | 1.001 | 1.004 | 1.001 | 0.095 | 1.003 |
| hex: silesia/osdb | 524290 | 43711.5 ± 2.0% | 1.002 | 0.088 | 1.001 | 0.588 | 0.997 | 0.996 | 0.998 | 0.998 | 0.997 | 0.091 | 0.991 |
| hex: silesia/reymont | 524290 | 43081.3 ± 0.9% | 1.001 | 0.089 | 0.995 | 0.595 | 1.000 | 0.995 | 0.996 | 0.995 | 1.003 | 0.093 | 0.995 |
| hex: silesia/samba | 524290 | 43396.3 ± 0.4% | 0.998 | 0.088 | 1.002 | 0.590 | 1.001 | 0.999 | 0.999 | 0.997 | 0.996 | 0.093 | 0.999 |
| hex: silesia/sao | 524290 | 42509.9 ± 0.6% | 1.002 | 0.090 | 1.004 | 0.601 | 1.003 | 1.003 | 1.002 | 0.999 | 1.001 | 0.096 | 1.002 |
| hex: silesia/webster | 524290 | 43893.3 ± 0.8% | 1.000 | 0.088 | 0.997 | 0.587 | 0.999 | 0.998 | 1.001 | 1.000 | 0.997 | 0.094 | 0.999 |
| hex: silesia/x-ray | 524290 | 43289.6 ± 1.9% | 1.002 | 0.089 | 0.995 | 0.591 | 1.002 | 1.001 | 0.998 | 1.000 | 1.000 | 0.094 | 1.001 |
| hex: silesia/xml | 524290 | 43388.7 ± 0.6% | 0.999 | 0.088 | 0.989 | 0.591 | 0.999 | 0.989 | 0.998 | 0.995 | 1.001 | 0.093 | 0.993 |
| hex: canterbury/alice29.txt | 304180 | 43179.0 ± 1.3% | 1.002 | 0.089 | 1.003 | 0.592 | 1.006 | 1.001 | 1.000 | 1.005 | 1.002 | 0.094 | 1.002 |
| hex: canterbury/asyoulik.txt | 250360 | 43170.7 ± 1.0% | 0.999 | 0.089 | 0.993 | 0.592 | 0.994 | 0.987 | 0.993 | 0.997 | 0.995 | 0.094 | 0.994 |
| hex: canterbury/cp.html | 49208 | 41496.6 ± 0.8% | 1.003 | 0.092 | 1.007 | 0.605 | 1.007 | 1.007 | 1.005 | 1.014 | 1.005 | 0.100 | 1.009 |
| hex: canterbury/fields.c | 22302 | 41227.7 ± 2.0% | 0.995 | 0.092 | 1.001 | 0.605 | 1.003 | 0.988 | 1.003 | 1.003 | 1.005 | 0.100 | 1.001 |
| hex: canterbury/grammar.lsp | 7444 | 39141.8 ± 2.3% | 0.993 | 0.096 | 1.005 | 0.608 | 1.011 | 0.975 | 1.004 | 1.006 | 1.028 | 0.103 | 1.006 |
| hex: canterbury/kennedy.xls | 524290 | 41713.2 ± 0.5% | 0.998 | 0.092 | 1.000 | 0.606 | 1.001 | 0.998 | 1.001 | 0.998 | 1.001 | 0.095 | 0.998 |
| hex: canterbury/lcet10.txt | 524290 | 43535.2 ± 0.5% | 1.001 | 0.088 | 0.998 | 0.589 | 1.001 | 0.996 | 0.999 | 0.998 | 0.998 | 0.091 | 0.997 |
| hex: canterbury/plrabn12.txt | 524290 | 43365.5 ± 0.7% | 1.000 | 0.088 | 0.998 | 0.590 | 1.001 | 0.998 | 0.999 | 1.000 | 0.998 | 0.091 | 0.997 |
| hex: canterbury/ptt5 | 524290 | 43369.7 ± 0.9% | 0.999 | 0.088 | 1.002 | 0.592 | 1.001 | 1.001 | 1.004 | 1.004 | 1.000 | 0.090 | 1.005 |
| hex: canterbury/sum | 76482 | 42340.0 ± 0.8% | 1.001 | 0.090 | 1.006 | 0.597 | 1.007 | 1.001 | 1.009 | 1.005 | 1.004 | 0.098 | 1.006 |
| hex: canterbury/xargs.1 | 8456 | 39839.1 ± 4.6% | 1.004 | 0.095 | 1.002 | 0.602 | 1.000 | 0.953 | 0.999 | 0.989 | 1.020 | 0.102 | 1.002 |
| hex: canterbury-large/E.coli | 524290 | 43576.9 ± 0.7% | 1.001 | 0.088 | 1.001 | 0.589 | 1.002 | 0.999 | 1.002 | 1.001 | 1.000 | 0.092 | 1.000 |
| hex: canterbury-large/bible.txt | 524290 | 43505.2 ± 1.3% | 1.001 | 0.088 | 0.996 | 0.589 | 0.997 | 0.990 | 0.997 | 0.995 | 0.995 | 0.093 | 0.993 |
| hex: canterbury-large/world192.txt | 524290 | 38954.5 ± 2.4% | 1.002 | 0.098 | 1.002 | 0.622 | 1.001 | 0.998 | 0.999 | 1.000 | 1.000 | 0.105 | 1.002 |
| hex: http/html-1kx1024 | 2099200 | 20283.5 ± 0.3% | 1.005 | 0.181 | 1.002 | 0.953 | 1.004 | 1.005 | 1.003 | 1.003 | 1.009 | 0.188 | 1.006 |
| hex: http/html-16kx64 | 2097280 | 22032.5 ± 0.5% | 1.002 | 0.171 | 1.003 | 0.966 | 1.002 | 1.003 | 1.003 | 1.004 | 1.006 | 0.186 | 1.003 |
| hex: http/html-1m | 524290 | 40142.6 ± 0.5% | 1.001 | 0.095 | 1.002 | 0.637 | 1.003 | 1.001 | 1.005 | 1.002 | 1.004 | 0.098 | 1.003 |
| hex: http/json-1kx1024 | 2099200 | 20680.1 ± 0.7% | 1.006 | 0.177 | 1.005 | 0.937 | 1.004 | 1.003 | 1.005 | 1.006 | 1.011 | 0.185 | 1.006 |
| hex: http/json-16kx64 | 2097280 | 21476.8 ± 0.4% | 1.002 | 0.177 | 1.000 | 0.971 | 1.001 | 1.002 | 1.004 | 0.999 | 1.003 | 0.191 | 1.003 |
| hex: http/json-1m | 524290 | 43425.4 ± 1.4% | 1.002 | 0.088 | 1.000 | 0.591 | 1.001 | 0.997 | 0.997 | 0.987 | 0.994 | 0.094 | 0.990 |
| hex: http/js-1kx1024 | 2099200 | 20311.6 ± 0.4% | 1.005 | 0.180 | 1.001 | 0.957 | 1.003 | 1.004 | 1.002 | 1.004 | 1.009 | 0.187 | 1.004 |
| hex: http/js-16kx64 | 2097280 | 21792.7 ± 0.5% | 1.002 | 0.173 | 1.003 | 0.972 | 0.999 | 1.000 | 1.002 | 1.002 | 1.001 | 0.188 | 1.001 |
| hex: http/js-1m | 524290 | 42533.7 ± 0.8% | 1.003 | 0.090 | 1.005 | 0.603 | 1.001 | 0.998 | 1.005 | 1.003 | 1.003 | 0.095 | 1.005 |
| hex: http/css-1kx1024 | 2099200 | 20100.0 ± 0.7% | 1.004 | 0.183 | 1.003 | 0.961 | 1.003 | 1.005 | 1.002 | 1.003 | 1.007 | 0.190 | 1.005 |
| hex: http/css-16kx64 | 2097280 | 22264.3 ± 0.4% | 1.004 | 0.170 | 1.002 | 0.960 | 1.003 | 1.002 | 1.003 | 1.004 | 1.005 | 0.184 | 1.004 |
| hex: http/css-1m | 524290 | 43410.1 ± 0.8% | 1.002 | 0.088 | 1.000 | 0.590 | 0.998 | 0.990 | 0.997 | 0.993 | 0.993 | 0.093 | 0.996 |
| hex: shuffled/dickens-1m | 524290 | 43377.5 ± 0.7% | 1.003 | 0.088 | 1.003 | 0.590 | 1.002 | 0.993 | 1.001 | 1.001 | 1.001 | 0.092 | 1.001 |

## Losses

Each workload where a claim's path ran slower than the path it replaces by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding: J7 wide vectors off runs at 1.062 of all on.
- CLDR supplemental, 34 texts, decoding: J8 decoder fast path off runs at 1.063 of all on.
- CLDR supplemental, 34 texts, decoding: J12 decoder escape words off runs at 1.065 of all on.
- CLDR supplemental, 34 texts, decoding: J13 decoder escape blocks off runs at 1.066 of all on.
- qlog records, JSON text sequence, decoding: J5 UTF-8 vectors off runs at 1.067 of all on.
- qlog records, JSON text sequence, decoding: J7 wide vectors off runs at 1.067 of all on.
- qlog records, JSON text sequence, decoding: J8 decoder fast path off runs at 1.077 of all on.
- qlog records, JSON text sequence, decoding: J12 decoder escape words off runs at 1.069 of all on.
- qlog records, JSON text sequence, decoding: J13 decoder escape blocks off runs at 1.079 of all on.
- string: silesia/dickens, decoding: J7 wide vectors off runs at 1.201 of all on.
- string: silesia/dickens, decoding: J8 decoder fast path off runs at 1.180 of all on.
- string: silesia/dickens, decoding: J12 decoder escape words off runs at 1.150 of all on.
- string: silesia/dickens, decoding: J13 decoder escape blocks off runs at 1.196 of all on.
- string: silesia/nci, decoding: J7 wide vectors off runs at 1.183 of all on.
- string: silesia/nci, decoding: J8 decoder fast path off runs at 1.180 of all on.
- string: silesia/nci, decoding: J12 decoder escape words off runs at 1.191 of all on.
- string: silesia/nci, decoding: J13 decoder escape blocks off runs at 1.182 of all on.
- string: silesia/webster, decoding: J13 decoder escape blocks off runs at 1.054 of all on.
- string: canterbury/alice29.txt, decoding: J8 decoder fast path off runs at 1.068 of all on.
- string: canterbury/alice29.txt, decoding: J13 decoder escape blocks off runs at 1.108 of all on.
- string: canterbury/asyoulik.txt, decoding: J7 wide vectors off runs at 1.137 of all on.
- string: canterbury/asyoulik.txt, decoding: J8 decoder fast path off runs at 1.138 of all on.
- string: canterbury/asyoulik.txt, decoding: J12 decoder escape words off runs at 1.056 of all on.
- string: canterbury/asyoulik.txt, decoding: J13 decoder escape blocks off runs at 1.151 of all on.
- string: canterbury/lcet10.txt, decoding: J7 wide vectors off runs at 1.221 of all on.
- string: canterbury/lcet10.txt, decoding: J8 decoder fast path off runs at 1.213 of all on.
- string: canterbury/lcet10.txt, decoding: J12 decoder escape words off runs at 1.150 of all on.
- string: canterbury/lcet10.txt, decoding: J13 decoder escape blocks off runs at 1.224 of all on.
- string: http/css-1m, decoding: J7 wide vectors off runs at 1.091 of all on.
- string: http/css-1m, decoding: J8 decoder fast path off runs at 1.085 of all on.
- string: http/css-1m, decoding: J12 decoder escape words off runs at 1.065 of all on.
- string: http/css-1m, decoding: J13 decoder escape blocks off runs at 1.089 of all on.
- hex: http/css-1kx1024, decoding: J5 UTF-8 vectors off runs at 1.052 of all on.

## UTF-8 validation against simdutf

stdx's `is_utf8`, the check the loops apply to every string's octets, run alone over each string workload's octets at the width the host's features pick (16 lanes on aarch64, AVX2's 32 or AVX-512's 64 on x86-64, decision 39), beside simdutf 9.3.3's `validate_utf8` in the same run; on a host with AVX-512, again with AVX2 alone. Each ratio is stdx's throughput over the other's. simdutf picks its kernel at run time. Before timing, every copy of the check and simdutf judged 20000 seeded buffers and each workload, whole and changed, alike.

| Workload | Octets | stdx, MB/s | simdutf, MB/s | stdx / simdutf | stdx with AVX2 alone, MB/s | stdx / stdx with AVX2 alone |
|---|---|---|---|---|---|---|
| string: silesia/dickens | 166668 | 166352.3 ± 0.7% | 121361.1 ± 1.6% | 1.371 | 100000.1 ± 1.2% | 1.664 |
| string: silesia/nci | 1048576 | 168382.2 ± 0.9% | 122459.9 ± 0.9% | 1.375 | 101203.8 ± 1.4% | 1.664 |
| string: silesia/reymont | 1048576 | 166578.5 ± 1.1% | 121798.2 ± 1.5% | 1.368 | 100794.7 ± 0.6% | 1.653 |
| string: silesia/samba | 65546 | 161901.5 ± 1.3% | 118516.3 ± 4.6% | 1.366 | 98465.1 ± 1.6% | 1.644 |
| string: silesia/webster | 1048576 | 164684.2 ± 2.0% | 120804.9 ± 1.5% | 1.363 | 100472.4 ± 1.0% | 1.639 |
| string: silesia/xml | 1048576 | 161732.4 ± 1.9% | 119884.9 ± 1.5% | 1.349 | 99867.2 ± 1.2% | 1.619 |
| string: canterbury/alice29.txt | 152089 | 165169.5 ± 1.3% | 121034.0 ± 1.3% | 1.365 | 99639.4 ± 0.8% | 1.658 |
| string: canterbury/asyoulik.txt | 125179 | 163871.5 ± 1.6% | 120256.4 ± 2.0% | 1.363 | 99888.7 ± 1.4% | 1.641 |
| string: canterbury/lcet10.txt | 426754 | 164083.8 ± 0.5% | 119612.5 ± 1.4% | 1.372 | 99552.5 ± 0.8% | 1.648 |
| string: canterbury/plrabn12.txt | 481861 | 165805.4 ± 0.9% | 121189.0 ± 0.9% | 1.368 | 100440.0 ± 0.8% | 1.651 |
| string: canterbury-large/E.coli | 1048576 | 166409.7 ± 0.5% | 121613.4 ± 0.6% | 1.368 | 100469.0 ± 1.2% | 1.656 |
| string: canterbury-large/bible.txt | 1048576 | 168017.9 ± 2.0% | 121997.0 ± 1.6% | 1.377 | 101903.4 ± 1.2% | 1.649 |
| string: canterbury-large/world192.txt | 1048576 | 165499.2 ± 2.5% | 122181.8 ± 2.2% | 1.355 | 100565.3 ± 2.3% | 1.646 |
| string: http/html-1m | 1048576 | 143755.6 ± 1.2% | 110662.9 ± 1.5% | 1.299 | 92682.5 ± 1.1% | 1.551 |
| string: http/json-1m | 1048576 | 118772.0 ± 2.2% | 105040.3 ± 1.6% | 1.131 | 80975.6 ± 1.4% | 1.467 |
| string: http/js-1m | 1048576 | 161796.1 ± 2.2% | 119799.8 ± 1.2% | 1.351 | 98637.6 ± 0.6% | 1.640 |
| string: http/css-1m | 1048576 | 164525.8 ± 2.2% | 120746.0 ± 0.5% | 1.363 | 99149.8 ± 1.0% | 1.659 |
| string: dickens as Cyrillic and CJK | 1847045 | 23431.4 ± 1.1% | 20493.0 ± 0.6% | 1.143 | 14878.4 ± 0.5% | 1.575 |

## Losses to simdutf

None.

## UTF-8 validation by the buffer's offset from a 64-octet line

| Buffer | Octets | Offset | stdx, MB/s | simdutf, MB/s | stdx / simdutf | stdx with AVX2 alone, MB/s | stdx / stdx with AVX2 alone |
|---|---|---|---|---|---|---|---|
| string: canterbury-large/bible.txt | 1048576 | 0 | 165181.3 ± 1.0% | 120153.7 ± 1.2% | 1.375 | 99957.7 ± 1.3% | 1.653 |
| string: canterbury-large/bible.txt | 1048576 | 1 | 165132.3 ± 1.5% | 120702.5 ± 1.0% | 1.368 | 100530.8 ± 0.3% | 1.643 |
| string: canterbury-large/bible.txt | 1048576 | 8 | 164947.5 ± 1.6% | 120624.9 ± 0.8% | 1.367 | 100196.2 ± 0.7% | 1.646 |
| string: canterbury-large/bible.txt | 1048576 | 16 | 166009.5 ± 2.6% | 120585.9 ± 0.8% | 1.377 | 99694.9 ± 1.1% | 1.665 |
| string: canterbury-large/bible.txt | 1048576 | 32 | 167250.4 ± 1.9% | 121482.3 ± 0.7% | 1.377 | 100620.6 ± 5.7% | 1.662 |
| string: canterbury-large/bible.txt | 1048576 | 48 | 167477.5 ± 0.3% | 121835.6 ± 1.1% | 1.375 | 101603.2 ± 0.6% | 1.648 |
| string: dickens as Cyrillic and CJK | 1048576 | 0 | 24204.2 ± 0.7% | 21606.9 ± 0.8% | 1.120 | 15259.9 ± 0.6% | 1.586 |
| string: dickens as Cyrillic and CJK | 1048576 | 1 | 24160.3 ± 0.5% | 21605.1 ± 0.3% | 1.118 | 15229.5 ± 0.2% | 1.586 |
| string: dickens as Cyrillic and CJK | 1048576 | 8 | 24243.5 ± 0.8% | 21626.2 ± 0.5% | 1.121 | 15217.2 ± 0.7% | 1.593 |
| string: dickens as Cyrillic and CJK | 1048576 | 16 | 24215.6 ± 0.8% | 21587.4 ± 0.7% | 1.122 | 15234.2 ± 0.8% | 1.590 |
| string: dickens as Cyrillic and CJK | 1048576 | 32 | 24219.0 ± 0.5% | 21628.3 ± 0.3% | 1.120 | 15264.0 ± 0.6% | 1.587 |
| string: dickens as Cyrillic and CJK | 1048576 | 48 | 24161.8 ± 0.6% | 21596.5 ± 0.5% | 1.119 | 15299.8 ± 0.4% | 1.579 |

## Against the baselines

stdx with every claim on, timed beside simdjson 5.1.1, yyjson 0.13.0, Zig 0.16.0's std.json, serde_json 1.0.154 and Go's encoding/json/jsontext in the same run. Each ratio is stdx's throughput over the baseline's; below 1, the baseline is faster. stdx is built for the architecture's baseline CPU in ReleaseSafe. Each baseline is built for the same CPU, the C, C++ and Zig ones in ReleaseFast (decision 75), and simdjson picks its kernel at run time. Decoding visits every value; encoding writes each text from its tokens.

## Decoding against the baselines

Octets are the text's. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1376.6 ± 0.3% | 1475.9 ± 1.3% | 1079.0 ± 1.1% | 398.4 ± 1.5% | 665.6 ± 0.8% | 363.9 ± 1.4% | 0.933 | 1.276 | 3.456 | 2.068 | 3.783 |
| qlog records, JSON text sequence | 1467503 | 1090.0 ± 0.8% | 1232.8 ± 1.2% | 1127.5 ± 0.5% | 342.9 ± 0.9% | 743.2 ± 1.0% | 316.1 ± 0.7% | 0.884 | 0.967 | 3.179 | 1.467 | 3.448 |
| string: silesia/dickens | 172528 | 6013.4 ± 0.3% | 3396.2 ± 1.2% | 2807.6 ± 1.1% | 304.9 ± 0.6% | 3012.3 ± 1.5% | 566.7 ± 1.4% | 1.771 | 2.142 | 19.723 | 1.996 | 10.611 |
| string: silesia/nci | 1075110 | 4732.6 ± 0.5% | 3873.7 ± 0.3% | 3007.0 ± 0.7% | 636.1 ± 1.2% | 3609.0 ± 1.3% | 563.0 ± 1.0% | 1.222 | 1.574 | 7.441 | 1.311 | 8.407 |
| string: silesia/reymont | 1075159 | 4026.0 ± 1.6% | 3395.1 ± 0.6% | 1945.0 ± 1.4% | 322.1 ± 3.8% | 2098.5 ± 1.3% | 488.5 ± 3.4% | 1.186 | 2.070 | 12.500 | 1.919 | 8.242 |
| string: silesia/samba | 97582 | 4050.5 ± 1.1% | 3783.9 ± 0.5% | 3033.4 ± 0.7% | 330.2 ± 0.9% | 1910.0 ± 1.9% | 415.0 ± 4.1% | 1.070 | 1.335 | 12.267 | 2.121 | 9.760 |
| string: silesia/webster | 1098490 | 4141.2 ± 1.2% | 2432.6 ± 0.5% | 1729.9 ± 0.8% | 300.5 ± 0.6% | 2042.3 ± 0.6% | 462.2 ± 1.3% | 1.702 | 2.394 | 13.779 | 2.028 | 8.961 |
| string: silesia/xml | 1090118 | 5924.6 ± 0.6% | 5053.5 ± 0.5% | 2433.4 ± 1.8% | 502.1 ± 1.2% | 3278.6 ± 0.8% | 536.4 ± 1.0% | 1.172 | 2.435 | 11.801 | 1.807 | 11.044 |
| string: canterbury/alice29.txt | 159425 | 5945.0 ± 1.4% | 2774.4 ± 0.2% | 2789.4 ± 1.4% | 293.2 ± 0.6% | 2718.3 ± 2.6% | 514.5 ± 2.1% | 2.143 | 2.131 | 20.275 | 2.187 | 11.555 |
| string: canterbury/asyoulik.txt | 132198 | 4229.4 ± 1.2% | 2521.7 ± 4.6% | 2781.0 ± 1.3% | 295.6 ± 0.5% | 2371.6 ± 0.7% | 450.4 ± 2.4% | 1.677 | 1.521 | 14.307 | 1.783 | 9.391 |
| string: canterbury/lcet10.txt | 441884 | 5983.5 ± 1.1% | 3262.1 ± 1.3% | 2282.0 ± 1.8% | 337.5 ± 1.8% | 2743.9 ± 0.6% | 566.7 ± 4.0% | 1.834 | 2.622 | 17.727 | 2.181 | 10.559 |
| string: canterbury/plrabn12.txt | 503330 | 5908.2 ± 0.9% | 3126.5 ± 3.0% | 1822.4 ± 1.5% | 318.4 ± 0.8% | 2814.9 ± 1.3% | 530.2 ± 1.2% | 1.890 | 3.242 | 18.553 | 2.099 | 11.143 |
| string: canterbury-large/E.coli | 1048578 | 33030.0 ± 0.7% | 13038.3 ± 0.4% | 3411.9 ± 0.2% | 1273.2 ± 0.9% | 8847.4 ± 0.9% | 958.5 ± 2.4% | 2.533 | 9.681 | 25.943 | 3.733 | 34.458 |
| string: canterbury-large/bible.txt | 1055886 | 9082.9 ± 3.0% | 5219.7 ± 0.7% | 2765.8 ± 0.5% | 350.0 ± 0.8% | 3853.1 ± 0.7% | 624.9 ± 1.3% | 1.740 | 3.284 | 25.948 | 2.357 | 14.535 |
| string: canterbury-large/world192.txt | 1103121 | 3992.3 ± 0.7% | 2306.7 ± 1.0% | 1755.0 ± 0.9% | 325.3 ± 0.7% | 2082.0 ± 1.0% | 463.0 ± 2.4% | 1.731 | 2.275 | 12.274 | 1.918 | 8.623 |
| string: http/html-1m | 1058582 | 7755.0 ± 2.1% | 4692.1 ± 0.9% | 2678.9 ± 0.5% | 400.3 ± 0.5% | 3601.0 ± 0.6% | 591.1 ± 1.1% | 1.653 | 2.895 | 19.374 | 2.154 | 13.120 |
| string: http/json-1m | 1190272 | 3174.0 ± 0.7% | 1249.1 ± 2.0% | 2076.5 ± 1.0% | 477.7 ± 1.3% | 1331.3 ± 4.8% | 430.3 ± 3.4% | 2.541 | 1.529 | 6.645 | 2.384 | 7.377 |
| string: http/js-1m | 1144362 | 2985.1 ± 1.0% | 1613.0 ± 0.3% | 1324.9 ± 0.5% | 321.9 ± 0.2% | 1424.4 ± 0.6% | 378.5 ± 0.9% | 1.851 | 2.253 | 9.273 | 2.096 | 7.887 |
| string: http/css-1m | 1097820 | 3040.8 ± 1.1% | 2874.4 ± 1.0% | 2266.1 ± 1.0% | 438.7 ± 0.5% | 2061.0 ± 1.1% | 432.1 ± 8.0% | 1.058 | 1.342 | 6.931 | 1.475 | 7.037 |
| string: dickens as Cyrillic and CJK | 1883069 | 5796.7 ± 0.9% | 3337.5 ± 1.9% | 659.8 ± 0.9% | 369.8 ± 1.1% | 510.5 ± 0.8% | 164.7 ± 3.4% | 1.737 | 8.786 | 15.674 | 11.354 | 35.204 |
| string: dickens as Cyrillic and CJK, as \u escapes | 5075485 | 1193.7 ± 0.8% | 1236.2 ± 2.0% | 1100.8 ± 1.2% | 266.7 ± 0.8% | 477.0 ± 0.9% | 227.9 ± 3.3% | 0.966 | 1.084 | 4.476 | 2.502 | 5.237 |
| hex: silesia/dickens | 524290 | 46097.1 ± 2.3% | 14986.3 ± 0.5% | 3480.3 ± 0.4% | 477.1 ± 2.6% | 8853.3 ± 0.7% | 1126.7 ± 2.1% | 3.076 | 13.245 | 96.623 | 5.207 | 40.913 |
| hex: silesia/mozilla | 524290 | 46221.3 ± 0.8% | 14958.0 ± 0.5% | 3546.0 ± 0.4% | 425.4 ± 0.7% | 8852.2 ± 0.4% | 1127.3 ± 1.0% | 3.090 | 13.035 | 108.649 | 5.221 | 41.003 |
| hex: silesia/mr | 524290 | 45182.7 ± 1.3% | 14948.6 ± 1.1% | 3549.1 ± 3.4% | 643.6 ± 0.8% | 8874.8 ± 0.9% | 1123.2 ± 5.6% | 3.023 | 12.731 | 70.203 | 5.091 | 40.228 |
| hex: silesia/nci | 524290 | 46308.7 ± 1.7% | 15030.0 ± 0.9% | 3490.3 ± 0.6% | 794.3 ± 1.5% | 8872.7 ± 0.9% | 1128.5 ± 1.5% | 3.081 | 13.268 | 58.299 | 5.219 | 41.035 |
| hex: silesia/ooffice | 524290 | 47587.2 ± 0.6% | 15062.5 ± 0.7% | 3556.0 ± 0.7% | 342.9 ± 1.4% | 8906.6 ± 1.2% | 1129.1 ± 1.8% | 3.159 | 13.382 | 138.767 | 5.343 | 42.145 |
| hex: silesia/osdb | 524290 | 46100.9 ± 1.8% | 15006.0 ± 0.7% | 3548.5 ± 1.1% | 444.5 ± 2.1% | 8908.2 ± 0.8% | 1129.0 ± 1.1% | 3.072 | 12.992 | 103.716 | 5.175 | 40.834 |
| hex: silesia/reymont | 524290 | 43985.7 ± 4.1% | 14978.9 ± 0.7% | 3477.4 ± 0.6% | 502.1 ± 1.7% | 8851.0 ± 0.7% | 1124.2 ± 1.2% | 2.937 | 12.649 | 87.599 | 4.970 | 39.125 |
| hex: silesia/samba | 524290 | 45164.6 ± 1.3% | 15011.7 ± 0.6% | 3536.9 ± 0.6% | 365.4 ± 0.9% | 8863.7 ± 4.7% | 1130.9 ± 1.8% | 3.009 | 12.770 | 123.617 | 5.095 | 39.938 |
| hex: silesia/sao | 524290 | 46136.1 ± 1.8% | 14949.0 ± 1.0% | 3441.7 ± 0.8% | 274.5 ± 1.7% | 8847.3 ± 0.6% | 1127.7 ± 1.4% | 3.086 | 13.405 | 168.060 | 5.215 | 40.913 |
| hex: silesia/webster | 524290 | 43805.6 ± 0.4% | 15101.6 ± 0.7% | 3554.7 ± 0.7% | 450.8 ± 0.7% | 8882.6 ± 0.4% | 1134.8 ± 0.7% | 2.901 | 12.323 | 97.167 | 4.932 | 38.603 |
| hex: silesia/x-ray | 524290 | 45429.4 ± 1.3% | 15078.4 ± 0.5% | 3485.3 ± 0.6% | 422.8 ± 1.5% | 8872.5 ± 0.7% | 1135.8 ± 0.8% | 3.013 | 13.035 | 107.446 | 5.120 | 39.998 |
| hex: silesia/xml | 524290 | 45677.4 ± 1.8% | 15067.3 ± 0.9% | 3563.1 ± 0.8% | 733.6 ± 1.3% | 8867.8 ± 5.2% | 1124.3 ± 2.0% | 3.032 | 12.819 | 62.266 | 5.151 | 40.626 |
| hex: canterbury/alice29.txt | 304180 | 46575.7 ± 1.3% | 14066.1 ± 1.4% | 3539.4 ± 2.9% | 482.5 ± 0.9% | 8907.8 ± 0.6% | 1137.2 ± 0.8% | 3.311 | 13.159 | 96.522 | 5.229 | 40.958 |
| hex: canterbury/asyoulik.txt | 250360 | 47369.2 ± 0.7% | 15049.4 ± 0.7% | 3492.7 ± 0.4% | 470.9 ± 0.2% | 8885.2 ± 0.6% | 1140.7 ± 1.7% | 3.148 | 13.562 | 100.596 | 5.331 | 41.527 |
| hex: canterbury/cp.html | 49208 | 44463.3 ± 2.3% | 14372.6 ± 0.8% | 3548.4 ± 0.6% | 500.8 ± 3.0% | 9232.5 ± 0.4% | 1123.8 ± 1.7% | 3.094 | 12.531 | 88.777 | 4.816 | 39.565 |
| hex: canterbury/fields.c | 22302 | 49114.9 ± 1.2% | 17518.3 ± 1.3% | 3647.0 ± 0.8% | 560.7 ± 1.2% | 9194.0 ± 0.3% | 1090.0 ± 2.0% | 2.804 | 13.467 | 87.603 | 5.342 | 45.061 |
| hex: canterbury/grammar.lsp | 7444 | 43808.4 ± 3.0% | 17146.2 ± 0.8% | 3612.0 ± 1.2% | 764.6 ± 3.6% | 8909.0 ± 4.0% | 1056.3 ± 2.3% | 2.555 | 12.129 | 57.292 | 4.917 | 41.474 |
| hex: canterbury/kennedy.xls | 524290 | 47702.2 ± 0.2% | 15081.8 ± 1.7% | 3524.3 ± 1.1% | 752.3 ± 1.5% | 8866.8 ± 5.4% | 1111.1 ± 6.4% | 3.163 | 13.535 | 63.407 | 5.380 | 42.934 |
| hex: canterbury/lcet10.txt | 524290 | 45950.1 ± 1.0% | 14956.0 ± 0.8% | 3526.4 ± 0.7% | 482.5 ± 1.0% | 8841.9 ± 0.6% | 1111.7 ± 1.6% | 3.072 | 13.030 | 95.224 | 5.197 | 41.334 |
| hex: canterbury/plrabn12.txt | 524290 | 48207.2 ± 0.6% | 14946.3 ± 3.2% | 3546.2 ± 0.7% | 464.8 ± 0.9% | 8831.4 ± 5.0% | 1116.0 ± 2.0% | 3.225 | 13.594 | 103.719 | 5.459 | 43.197 |
| hex: canterbury/ptt5 | 524290 | 45738.4 ± 0.9% | 14940.9 ± 0.4% | 3450.8 ± 0.5% | 661.6 ± 0.7% | 8837.0 ± 0.9% | 1112.3 ± 1.4% | 3.061 | 13.255 | 69.131 | 5.176 | 41.120 |
| hex: canterbury/sum | 76482 | 44691.4 ± 1.3% | 15365.0 ± 1.1% | 3550.7 ± 2.0% | 580.3 ± 0.9% | 8903.3 ± 0.6% | 1115.1 ± 1.9% | 2.909 | 12.586 | 77.010 | 5.020 | 40.079 |
| hex: canterbury/xargs.1 | 8456 | 44714.7 ± 3.0% | 17334.2 ± 0.7% | 3543.8 ± 1.1% | 732.8 ± 1.6% | 8906.5 ± 1.2% | 1094.9 ± 1.6% | 2.580 | 12.618 | 61.017 | 5.020 | 40.839 |
| hex: canterbury-large/E.coli | 524290 | 45980.1 ± 2.0% | 14980.4 ± 1.1% | 3467.3 ± 0.4% | 955.3 ± 0.8% | 8847.4 ± 0.7% | 1114.4 ± 5.9% | 3.069 | 13.261 | 48.132 | 5.197 | 41.259 |
| hex: canterbury-large/bible.txt | 524290 | 47943.6 ± 0.5% | 14922.0 ± 1.1% | 3471.2 ± 0.7% | 499.2 ± 0.7% | 8850.3 ± 5.2% | 1109.3 ± 1.4% | 3.213 | 13.812 | 96.047 | 5.417 | 43.218 |
| hex: canterbury-large/world192.txt | 524290 | 44939.9 ± 1.6% | 15048.2 ± 1.7% | 3560.4 ± 1.1% | 469.5 ± 0.5% | 8939.8 ± 0.9% | 1107.1 ± 3.0% | 2.986 | 12.622 | 95.717 | 5.027 | 40.591 |
| hex: http/html-1kx1024 | 2099200 | 17672.7 ± 0.5% | 12550.1 ± 3.9% | 3170.4 ± 1.0% | 507.6 ± 1.4% | 7596.0 ± 1.3% | 946.9 ± 2.4% | 1.408 | 5.574 | 34.819 | 2.327 | 18.664 |
| hex: http/html-16kx64 | 2097280 | 33341.6 ± 4.8% | 13938.5 ± 1.0% | 3393.4 ± 1.0% | 512.0 ± 3.3% | 8426.2 ± 1.4% | 1054.5 ± 3.4% | 2.392 | 9.825 | 65.125 | 3.957 | 31.619 |
| hex: http/html-1m | 524290 | 46799.2 ± 1.4% | 14981.3 ± 3.8% | 3477.7 ± 0.8% | 504.7 ± 1.0% | 8844.5 ± 3.0% | 1092.3 ± 3.9% | 3.124 | 13.457 | 92.734 | 5.291 | 42.846 |
| hex: http/json-1kx1024 | 2099200 | 17442.5 ± 2.0% | 12528.1 ± 10.2% | 3149.7 ± 1.7% | 679.8 ± 0.8% | 7548.7 ± 2.5% | 946.7 ± 2.9% | 1.392 | 5.538 | 25.660 | 2.311 | 18.424 |
| hex: http/json-16kx64 | 2097280 | 34266.7 ± 1.7% | 13915.0 ± 0.7% | 3390.7 ± 0.6% | 694.6 ± 0.9% | 8591.2 ± 0.8% | 1079.3 ± 1.6% | 2.463 | 10.106 | 49.330 | 3.989 | 31.748 |
| hex: http/json-1m | 524290 | 45308.7 ± 2.7% | 13089.0 ± 1.9% | 3521.0 ± 0.3% | 709.4 ± 1.0% | 8860.8 ± 0.9% | 1099.4 ± 3.8% | 3.462 | 12.868 | 63.872 | 5.113 | 41.213 |
| hex: http/js-1kx1024 | 2099200 | 17684.6 ± 3.2% | 12175.8 ± 1.3% | 3146.7 ± 0.2% | 487.9 ± 0.7% | 7564.8 ± 1.6% | 961.5 ± 3.5% | 1.452 | 5.620 | 36.247 | 2.338 | 18.393 |
| hex: http/js-16kx64 | 2097280 | 34896.3 ± 0.8% | 13717.1 ± 0.7% | 3396.6 ± 0.7% | 495.4 ± 1.1% | 8619.0 ± 0.4% | 1075.9 ± 4.2% | 2.544 | 10.274 | 70.439 | 4.049 | 32.435 |
| hex: http/js-1m | 524290 | 45593.2 ± 7.3% | 14300.4 ± 1.2% | 3555.1 ± 0.7% | 513.1 ± 2.6% | 8884.9 ± 0.9% | 1106.3 ± 4.0% | 3.188 | 12.825 | 88.853 | 5.132 | 41.211 |
| hex: http/css-1kx1024 | 2099200 | 17545.3 ± 1.6% | 12559.1 ± 1.0% | 3149.9 ± 1.1% | 568.1 ± 1.1% | 7545.8 ± 3.4% | 975.2 ± 2.4% | 1.397 | 5.570 | 30.884 | 2.325 | 17.992 |
| hex: http/css-16kx64 | 2097280 | 33864.3 ± 1.2% | 13827.3 ± 1.6% | 3378.8 ± 0.8% | 579.3 ± 1.2% | 7927.4 ± 2.5% | 1064.9 ± 3.2% | 2.449 | 10.023 | 58.458 | 4.272 | 31.801 |
| hex: http/css-1m | 524290 | 45504.6 ± 1.8% | 14997.8 ± 1.2% | 3537.4 ± 1.0% | 556.8 ± 0.9% | 8883.4 ± 0.7% | 1123.4 ± 2.9% | 3.034 | 12.864 | 81.723 | 5.122 | 40.508 |
| hex: shuffled/dickens-1m | 524290 | 45109.7 ± 0.9% | 14998.2 ± 0.7% | 3471.5 ± 0.7% | 477.2 ± 0.7% | 8857.9 ± 0.6% | 1123.9 ± 0.8% | 3.008 | 12.994 | 94.531 | 5.093 | 40.135 |

## Encoding against the baselines

Octets are the ones stdx writes. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1761.3 ± 1.9% | 1473.4 ± 1.0% | 1025.2 ± 1.0% | 478.4 ± 0.7% | 467.6 ± 3.3% | 501.5 ± 0.7% | 1.195 | 1.718 | 3.682 | 3.767 | 3.512 |
| qlog records, JSON text sequence | 1467503 | 1652.5 ± 2.4% | 1243.2 ± 4.1% | 945.3 ± 2.5% | 452.7 ± 0.9% | 569.0 ± 0.8% | 352.6 ± 1.0% | 1.329 | 1.748 | 3.650 | 2.904 | 4.686 |
| string: silesia/dickens | 172528 | 12607.9 ± 1.4% | 3916.3 ± 1.5% | 3052.8 ± 0.9% | 357.5 ± 1.4% | 1701.0 ± 0.7% | 1179.7 ± 0.4% | 3.219 | 4.130 | 35.270 | 7.412 | 10.688 |
| string: silesia/nci | 1075110 | 11426.1 ± 0.7% | 4640.1 ± 1.5% | 3098.4 ± 3.5% | 855.8 ± 4.7% | 1904.1 ± 3.6% | 1189.0 ± 5.1% | 2.462 | 3.688 | 13.351 | 6.001 | 9.610 |
| string: silesia/reymont | 1075159 | 5334.7 ± 1.5% | 1849.8 ± 1.5% | 1877.9 ± 1.1% | 391.1 ± 0.9% | 1440.7 ± 0.5% | 1038.8 ± 0.7% | 2.884 | 2.841 | 13.639 | 3.703 | 5.135 |
| string: silesia/samba | 97582 | 6533.6 ± 1.5% | 2705.8 ± 1.2% | 4072.8 ± 0.5% | 381.5 ± 0.7% | 1321.0 ± 0.9% | 1160.0 ± 1.5% | 2.415 | 1.604 | 17.126 | 4.946 | 5.632 |
| string: silesia/webster | 1098490 | 6687.6 ± 1.5% | 1962.7 ± 0.4% | 1747.7 ± 1.7% | 385.6 ± 0.4% | 1407.8 ± 0.7% | 602.2 ± 0.8% | 3.407 | 3.826 | 17.342 | 4.750 | 11.105 |
| string: silesia/xml | 1090118 | 10092.7 ± 1.2% | 3207.6 ± 2.2% | 2513.8 ± 1.0% | 628.0 ± 1.0% | 1941.1 ± 0.9% | 977.5 ± 0.3% | 3.146 | 4.015 | 16.070 | 5.199 | 10.325 |
| string: canterbury/alice29.txt | 159425 | 11077.4 ± 3.0% | 2844.9 ± 2.0% | 3027.7 ± 1.2% | 341.6 ± 0.7% | 1531.7 ± 1.4% | 1092.1 ± 4.7% | 3.894 | 3.659 | 32.426 | 7.232 | 10.143 |
| string: canterbury/asyoulik.txt | 132198 | 10654.2 ± 5.5% | 2105.7 ± 3.2% | 3104.6 ± 1.5% | 351.0 ± 1.1% | 1364.8 ± 1.7% | 951.8 ± 1.3% | 5.060 | 3.432 | 30.350 | 7.806 | 11.194 |
| string: canterbury/lcet10.txt | 441884 | 10831.9 ± 0.3% | 3031.2 ± 0.9% | 2564.1 ± 1.1% | 385.6 ± 1.2% | 1656.7 ± 1.3% | 1195.7 ± 0.9% | 3.573 | 4.224 | 28.092 | 6.538 | 9.059 |
| string: canterbury/plrabn12.txt | 503330 | 8254.4 ± 4.9% | 2302.7 ± 0.7% | 2092.2 ± 0.7% | 364.4 ± 0.7% | 1625.8 ± 0.3% | 1117.2 ± 1.9% | 3.585 | 3.945 | 22.652 | 5.077 | 7.388 |
| string: canterbury-large/E.coli | 1048578 | 31103.9 ± 0.4% | 16582.6 ± 0.7% | 3485.7 ± 0.9% | 1696.9 ± 0.6% | 3162.2 ± 0.8% | 1415.6 ± 1.1% | 1.876 | 8.923 | 18.330 | 9.836 | 21.973 |
| string: canterbury-large/bible.txt | 1055886 | 8946.7 ± 0.5% | 4914.2 ± 0.8% | 3000.8 ± 1.3% | 420.7 ± 0.9% | 2224.8 ± 0.7% | 1486.1 ± 0.7% | 1.821 | 2.981 | 21.267 | 4.021 | 6.020 |
| string: canterbury-large/world192.txt | 1103121 | 6457.6 ± 0.7% | 1734.5 ± 1.1% | 1883.5 ± 1.4% | 389.1 ± 0.9% | 1400.5 ± 0.9% | 960.7 ± 1.3% | 3.723 | 3.429 | 16.597 | 4.611 | 6.722 |
| string: http/html-1m | 1058582 | 9958.7 ± 0.9% | 4390.5 ± 1.5% | 2865.8 ± 0.5% | 457.4 ± 0.7% | 2160.4 ± 3.9% | 849.8 ± 1.2% | 2.268 | 3.475 | 21.774 | 4.610 | 11.718 |
| string: http/json-1m | 1190272 | 8478.5 ± 0.9% | 1579.8 ± 2.6% | 1576.8 ± 2.2% | 540.0 ± 1.5% | 1157.4 ± 3.2% | 845.4 ± 1.6% | 5.367 | 5.377 | 15.702 | 7.326 | 10.029 |
| string: http/js-1m | 1144362 | 6436.3 ± 3.6% | 1116.2 ± 1.1% | 1373.9 ± 1.0% | 361.8 ± 0.8% | 1124.9 ± 1.6% | 756.5 ± 0.6% | 5.766 | 4.685 | 17.790 | 5.722 | 8.508 |
| string: http/css-1m | 1097820 | 8305.1 ± 0.9% | 1477.7 ± 2.9% | 2287.5 ± 1.3% | 545.5 ± 0.8% | 1260.9 ± 0.4% | 878.1 ± 1.2% | 5.620 | 3.631 | 15.225 | 6.587 | 9.458 |
| string: dickens as Cyrillic and CJK | 1883069 | 5562.9 ± 0.7% | 3683.9 ± 1.4% | 488.7 ± 0.6% | 251.6 ± 0.9% | 466.3 ± 3.9% | 356.8 ± 0.6% | 1.510 | 11.383 | 22.107 | 11.930 | 15.591 |
| hex: silesia/dickens | 524290 | 43588.8 ± 0.7% | 2601.6 ± 0.5% | 1508.1 ± 0.4% | 468.7 ± 0.7% | 1571.4 ± 0.7% | 1061.6 ± 0.4% | 16.755 | 28.903 | 93.005 | 27.739 | 41.060 |
| hex: silesia/mozilla | 524290 | 43271.1 ± 1.5% | 2589.2 ± 2.7% | 1504.2 ± 1.1% | 412.7 ± 0.7% | 1562.5 ± 0.8% | 1062.4 ± 2.1% | 16.712 | 28.767 | 104.839 | 27.693 | 40.730 |
| hex: silesia/mr | 524290 | 43642.3 ± 0.6% | 2593.3 ± 0.6% | 1505.4 ± 0.3% | 605.5 ± 0.4% | 1549.9 ± 0.5% | 1067.0 ± 0.5% | 16.829 | 28.991 | 72.073 | 28.158 | 40.901 |
| hex: silesia/nci | 524290 | 43336.0 ± 3.1% | 2576.1 ± 1.1% | 1498.4 ± 0.5% | 750.9 ± 0.5% | 1560.8 ± 0.7% | 1064.2 ± 0.7% | 16.822 | 28.921 | 57.709 | 27.765 | 40.721 |
| hex: silesia/ooffice | 524290 | 42645.3 ± 1.8% | 2594.7 ± 0.6% | 1504.8 ± 0.8% | 341.5 ± 0.6% | 1558.0 ± 0.8% | 1068.9 ± 1.0% | 16.436 | 28.340 | 124.880 | 27.372 | 39.896 |
| hex: silesia/osdb | 524290 | 43711.5 ± 2.0% | 2590.5 ± 0.9% | 1508.0 ± 0.4% | 450.5 ± 0.2% | 1571.5 ± 0.9% | 1063.6 ± 0.6% | 16.874 | 28.986 | 97.024 | 27.816 | 41.097 |
| hex: silesia/reymont | 524290 | 43081.3 ± 0.9% | 2576.2 ± 1.1% | 1496.3 ± 3.6% | 485.2 ± 1.0% | 1549.0 ± 0.3% | 1060.4 ± 1.1% | 16.723 | 28.791 | 88.796 | 27.812 | 40.626 |
| hex: silesia/samba | 524290 | 43396.3 ± 0.4% | 2593.9 ± 1.1% | 1499.2 ± 0.5% | 361.4 ± 0.4% | 1572.1 ± 0.3% | 1062.1 ± 0.8% | 16.730 | 28.947 | 120.093 | 27.604 | 40.860 |
| hex: silesia/sao | 524290 | 42509.9 ± 0.6% | 2602.2 ± 0.8% | 1505.7 ± 0.9% | 277.4 ± 1.2% | 1558.4 ± 0.7% | 1066.3 ± 0.4% | 16.336 | 28.233 | 153.253 | 27.278 | 39.867 |
| hex: silesia/webster | 524290 | 43893.3 ± 0.8% | 2605.9 ± 0.6% | 1510.3 ± 0.4% | 436.7 ± 0.8% | 1577.2 ± 0.6% | 1070.2 ± 0.6% | 16.844 | 29.063 | 100.506 | 27.831 | 41.015 |
| hex: silesia/x-ray | 524290 | 43289.6 ± 1.9% | 2600.4 ± 0.6% | 1508.1 ± 0.4% | 425.5 ± 0.8% | 1552.5 ± 1.1% | 1066.0 ± 0.7% | 16.647 | 28.705 | 101.733 | 27.884 | 40.608 |
| hex: silesia/xml | 524290 | 43388.7 ± 0.6% | 2585.4 ± 0.8% | 1502.7 ± 1.2% | 711.0 ± 1.7% | 1566.1 ± 0.8% | 1066.0 ± 0.8% | 16.782 | 28.875 | 61.023 | 27.704 | 40.701 |
| hex: canterbury/alice29.txt | 304180 | 43179.0 ± 1.3% | 2611.4 ± 0.7% | 1513.1 ± 1.1% | 474.0 ± 0.4% | 1586.2 ± 0.4% | 1081.1 ± 0.7% | 16.535 | 28.537 | 91.096 | 27.222 | 39.939 |
| hex: canterbury/asyoulik.txt | 250360 | 43170.7 ± 1.0% | 2605.9 ± 0.6% | 1529.7 ± 0.8% | 459.8 ± 0.7% | 1580.9 ± 0.3% | 1080.2 ± 0.7% | 16.567 | 28.221 | 93.882 | 27.307 | 39.966 |
| hex: canterbury/cp.html | 49208 | 41496.6 ± 0.8% | 2582.2 ± 6.3% | 1515.4 ± 1.2% | 484.1 ± 1.1% | 1585.0 ± 1.0% | 1085.9 ± 1.4% | 16.071 | 27.383 | 85.722 | 26.181 | 38.213 |
| hex: canterbury/fields.c | 22302 | 41227.7 ± 2.0% | 2649.3 ± 7.2% | 1520.8 ± 3.4% | 609.3 ± 0.6% | 1601.5 ± 0.9% | 1093.0 ± 0.6% | 15.561 | 27.108 | 67.667 | 25.744 | 37.720 |
| hex: canterbury/grammar.lsp | 7444 | 39141.8 ± 2.3% | 2671.6 ± 1.4% | 1530.6 ± 0.7% | 794.8 ± 0.6% | 1598.3 ± 0.4% | 1099.7 ± 0.7% | 14.651 | 25.573 | 49.246 | 24.489 | 35.593 |
| hex: canterbury/kennedy.xls | 524290 | 41713.2 ± 0.5% | 2587.7 ± 0.5% | 1499.3 ± 0.3% | 743.7 ± 0.9% | 1544.3 ± 0.4% | 1062.8 ± 0.7% | 16.120 | 27.822 | 56.089 | 27.012 | 39.249 |
| hex: canterbury/lcet10.txt | 524290 | 43535.2 ± 0.5% | 2586.7 ± 2.0% | 1500.7 ± 0.4% | 472.5 ± 0.8% | 1556.8 ± 0.2% | 1059.0 ± 0.4% | 16.830 | 29.010 | 92.145 | 27.965 | 41.108 |
| hex: canterbury/plrabn12.txt | 524290 | 43365.5 ± 0.7% | 2584.6 ± 0.5% | 1502.7 ± 0.4% | 456.8 ± 0.7% | 1550.8 ± 0.6% | 1062.6 ± 0.8% | 16.778 | 28.858 | 94.923 | 27.964 | 40.812 |
| hex: canterbury/ptt5 | 524290 | 43369.7 ± 0.9% | 2569.4 ± 9.5% | 1494.5 ± 0.6% | 607.6 ± 0.9% | 1554.7 ± 0.3% | 1058.3 ± 0.6% | 16.879 | 29.019 | 71.378 | 27.897 | 40.979 |
| hex: canterbury/sum | 76482 | 42340.0 ± 0.8% | 2571.8 ± 0.6% | 1509.3 ± 0.9% | 582.8 ± 0.4% | 1572.8 ± 0.4% | 1084.1 ± 0.4% | 16.463 | 28.053 | 72.644 | 26.919 | 39.056 |
| hex: canterbury/xargs.1 | 8456 | 39839.1 ± 4.6% | 2674.1 ± 0.6% | 1531.9 ± 0.4% | 823.1 ± 2.8% | 1602.9 ± 2.2% | 1103.7 ± 2.9% | 14.898 | 26.006 | 48.403 | 24.854 | 36.097 |
| hex: canterbury-large/E.coli | 524290 | 43576.9 ± 0.7% | 2594.7 ± 0.4% | 1506.0 ± 0.8% | 808.7 ± 1.2% | 1551.1 ± 0.3% | 1065.7 ± 5.2% | 16.795 | 28.935 | 53.883 | 28.094 | 40.891 |
| hex: canterbury-large/bible.txt | 524290 | 43505.2 ± 1.3% | 2577.8 ± 1.0% | 1498.6 ± 1.0% | 485.5 ± 1.0% | 1562.9 ± 0.7% | 1062.1 ± 1.1% | 16.877 | 29.030 | 89.612 | 27.836 | 40.962 |
| hex: canterbury-large/world192.txt | 524290 | 38954.5 ± 2.4% | 2584.8 ± 8.1% | 1502.2 ± 1.0% | 461.4 ± 0.9% | 1555.4 ± 6.0% | 1070.4 ± 0.7% | 15.071 | 25.932 | 84.433 | 25.045 | 36.392 |
| hex: http/html-1kx1024 | 2099200 | 20283.5 ± 0.3% | 2391.5 ± 0.5% | 1415.5 ± 0.4% | 498.5 ± 0.8% | 1485.5 ± 1.4% | 1069.2 ± 5.3% | 8.481 | 14.329 | 40.686 | 13.654 | 18.970 |
| hex: http/html-16kx64 | 2097280 | 22032.5 ± 0.5% | 2375.3 ± 1.7% | 1448.2 ± 0.8% | 506.6 ± 1.2% | 1503.3 ± 1.1% | 1080.3 ± 1.2% | 9.276 | 15.214 | 43.487 | 14.656 | 20.394 |
| hex: http/html-1m | 524290 | 40142.6 ± 0.5% | 2590.6 ± 0.8% | 1504.2 ± 0.6% | 494.1 ± 4.1% | 1574.8 ± 0.8% | 1067.9 ± 0.6% | 15.496 | 26.687 | 81.241 | 25.491 | 37.591 |
| hex: http/json-1kx1024 | 2099200 | 20680.1 ± 0.7% | 2372.6 ± 3.6% | 1407.8 ± 1.1% | 682.2 ± 1.2% | 1478.5 ± 1.6% | 1069.9 ± 0.9% | 8.716 | 14.689 | 30.316 | 13.987 | 19.329 |
| hex: http/json-16kx64 | 2097280 | 21476.8 ± 0.4% | 2369.5 ± 1.1% | 1442.3 ± 0.4% | 690.5 ± 0.6% | 1500.6 ± 0.5% | 1079.4 ± 0.5% | 9.064 | 14.891 | 31.101 | 14.312 | 19.898 |
| hex: http/json-1m | 524290 | 43425.4 ± 1.4% | 2569.2 ± 0.5% | 1496.3 ± 0.9% | 720.6 ± 0.9% | 1567.5 ± 0.6% | 1060.5 ± 0.3% | 16.902 | 29.022 | 60.263 | 27.704 | 40.950 |
| hex: http/js-1kx1024 | 2099200 | 20311.6 ± 0.4% | 2394.2 ± 1.4% | 1410.6 ± 0.9% | 487.4 ± 0.9% | 1491.2 ± 0.9% | 1070.1 ± 1.0% | 8.484 | 14.399 | 41.673 | 13.621 | 18.981 |
| hex: http/js-16kx64 | 2097280 | 21792.7 ± 0.5% | 2373.7 ± 0.2% | 1445.1 ± 0.4% | 493.0 ± 0.4% | 1500.0 ± 0.4% | 1075.6 ± 6.0% | 9.181 | 15.080 | 44.203 | 14.528 | 20.261 |
| hex: http/js-1m | 524290 | 42533.7 ± 0.8% | 2592.2 ± 0.8% | 1498.7 ± 0.6% | 503.3 ± 0.9% | 1529.9 ± 0.5% | 1057.8 ± 1.1% | 16.408 | 28.380 | 84.513 | 27.801 | 40.210 |
| hex: http/css-1kx1024 | 2099200 | 20100.0 ± 0.7% | 2395.6 ± 1.1% | 1421.4 ± 0.5% | 560.5 ± 0.8% | 1488.1 ± 0.4% | 1073.2 ± 0.5% | 8.390 | 14.141 | 35.859 | 13.507 | 18.730 |
| hex: http/css-16kx64 | 2097280 | 22264.3 ± 0.4% | 2376.9 ± 1.0% | 1443.0 ± 0.7% | 533.2 ± 0.8% | 1298.3 ± 0.4% | 1079.5 ± 0.4% | 9.367 | 15.429 | 41.755 | 17.148 | 20.624 |
| hex: http/css-1m | 524290 | 43410.1 ± 0.8% | 2580.3 ± 1.2% | 1499.9 ± 0.9% | 542.8 ± 0.6% | 1564.3 ± 6.3% | 1061.1 ± 0.9% | 16.824 | 28.943 | 79.980 | 27.750 | 40.912 |
| hex: shuffled/dickens-1m | 524290 | 43377.5 ± 0.7% | 2586.4 ± 0.7% | 1500.9 ± 0.7% | 463.8 ± 0.5% | 1527.9 ± 2.6% | 1060.9 ± 6.3% | 16.772 | 28.900 | 93.525 | 28.391 | 40.889 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1798.0 ± 0.5% | 1473.4 ± 1.0% | 1025.2 ± 1.0% | 478.4 ± 0.7% | 467.6 ± 3.3% | 501.5 ± 0.7% | 1.220 | 1.754 | 3.759 | 3.845 | 3.585 |
| qlog records, JSON text sequence | 1467503 | 1717.7 ± 1.0% | 1243.2 ± 4.1% | 945.3 ± 2.5% | 452.7 ± 0.9% | 569.0 ± 0.8% | 352.6 ± 1.0% | 1.382 | 1.817 | 3.794 | 3.019 | 4.871 |
| string: silesia/dickens | 172528 | 13903.8 ± 1.0% | 3916.3 ± 1.5% | 3052.8 ± 0.9% | 357.5 ± 1.4% | 1701.0 ± 0.7% | 1179.7 ± 0.4% | 3.550 | 4.554 | 38.895 | 8.174 | 11.786 |
| string: silesia/nci | 1075110 | 12208.7 ± 1.5% | 4640.1 ± 1.5% | 3098.4 ± 3.5% | 855.8 ± 4.7% | 1904.1 ± 3.6% | 1189.0 ± 5.1% | 2.631 | 3.940 | 14.266 | 6.412 | 10.268 |
| string: silesia/reymont | 1075159 | 5511.6 ± 1.6% | 1849.8 ± 1.5% | 1877.9 ± 1.1% | 391.1 ± 0.9% | 1440.7 ± 0.5% | 1038.8 ± 0.7% | 2.979 | 2.935 | 14.091 | 3.826 | 5.306 |
| string: silesia/samba | 97582 | 7364.5 ± 1.0% | 2705.8 ± 1.2% | 4072.8 ± 0.5% | 381.5 ± 0.7% | 1321.0 ± 0.9% | 1160.0 ± 1.5% | 2.722 | 1.808 | 19.303 | 5.575 | 6.349 |
| string: silesia/webster | 1098490 | 7068.4 ± 0.8% | 1962.7 ± 0.4% | 1747.7 ± 1.7% | 385.6 ± 0.4% | 1407.8 ± 0.7% | 602.2 ± 0.8% | 3.601 | 4.044 | 18.329 | 5.021 | 11.738 |
| string: silesia/xml | 1090118 | 11440.8 ± 0.5% | 3207.6 ± 2.2% | 2513.8 ± 1.0% | 628.0 ± 1.0% | 1941.1 ± 0.9% | 977.5 ± 0.3% | 3.567 | 4.551 | 18.217 | 5.894 | 11.704 |
| string: canterbury/alice29.txt | 159425 | 13983.0 ± 0.4% | 2844.9 ± 2.0% | 3027.7 ± 1.2% | 341.6 ± 0.7% | 1531.7 ± 1.4% | 1092.1 ± 4.7% | 4.915 | 4.618 | 40.932 | 9.129 | 12.803 |
| string: canterbury/asyoulik.txt | 132198 | 12243.2 ± 0.9% | 2105.7 ± 3.2% | 3104.6 ± 1.5% | 351.0 ± 1.1% | 1364.8 ± 1.7% | 951.8 ± 1.3% | 5.814 | 3.944 | 34.876 | 8.971 | 12.864 |
| string: canterbury/lcet10.txt | 441884 | 13185.5 ± 1.0% | 3031.2 ± 0.9% | 2564.1 ± 1.1% | 385.6 ± 1.2% | 1656.7 ± 1.3% | 1195.7 ± 0.9% | 4.350 | 5.142 | 34.196 | 7.959 | 11.027 |
| string: canterbury/plrabn12.txt | 503330 | 9457.5 ± 2.7% | 2302.7 ± 0.7% | 2092.2 ± 0.7% | 364.4 ± 0.7% | 1625.8 ± 0.3% | 1117.2 ± 1.9% | 4.107 | 4.520 | 25.954 | 5.817 | 8.465 |
| string: canterbury-large/E.coli | 1048578 | 31198.3 ± 0.4% | 16582.6 ± 0.7% | 3485.7 ± 0.9% | 1696.9 ± 0.6% | 3162.2 ± 0.8% | 1415.6 ± 1.1% | 1.881 | 8.950 | 18.386 | 9.866 | 22.040 |
| string: canterbury-large/bible.txt | 1055886 | 9929.9 ± 0.6% | 4914.2 ± 0.8% | 3000.8 ± 1.3% | 420.7 ± 0.9% | 2224.8 ± 0.7% | 1486.1 ± 0.7% | 2.021 | 3.309 | 23.604 | 4.463 | 6.682 |
| string: canterbury-large/world192.txt | 1103121 | 6566.7 ± 0.6% | 1734.5 ± 1.1% | 1883.5 ± 1.4% | 389.1 ± 0.9% | 1400.5 ± 0.9% | 960.7 ± 1.3% | 3.786 | 3.487 | 16.877 | 4.689 | 6.835 |
| string: http/html-1m | 1058582 | 10113.1 ± 1.1% | 4390.5 ± 1.5% | 2865.8 ± 0.5% | 457.4 ± 0.7% | 2160.4 ± 3.9% | 849.8 ± 1.2% | 2.303 | 3.529 | 22.112 | 4.681 | 11.900 |
| string: http/json-1m | 1190272 | 8625.2 ± 0.9% | 1579.8 ± 2.6% | 1576.8 ± 2.2% | 540.0 ± 1.5% | 1157.4 ± 3.2% | 845.4 ± 1.6% | 5.460 | 5.470 | 15.974 | 7.453 | 10.203 |
| string: http/js-1m | 1144362 | 6730.5 ± 0.4% | 1116.2 ± 1.1% | 1373.9 ± 1.0% | 361.8 ± 0.8% | 1124.9 ± 1.6% | 756.5 ± 0.6% | 6.030 | 4.899 | 18.604 | 5.983 | 8.897 |
| string: http/css-1m | 1097820 | 9545.5 ± 1.0% | 1477.7 ± 2.9% | 2287.5 ± 1.3% | 545.5 ± 0.8% | 1260.9 ± 0.4% | 878.1 ± 1.2% | 6.460 | 4.173 | 17.499 | 7.570 | 10.870 |
| string: dickens as Cyrillic and CJK | 1883069 | 5630.8 ± 1.2% | 3683.9 ± 1.4% | 488.7 ± 0.6% | 251.6 ± 0.9% | 466.3 ± 3.9% | 356.8 ± 0.6% | 1.528 | 11.522 | 22.377 | 12.076 | 15.781 |
| hex: silesia/dickens | 524290 | 43650.8 ± 5.3% | 2601.6 ± 0.5% | 1508.1 ± 0.4% | 468.7 ± 0.7% | 1571.4 ± 0.7% | 1061.6 ± 0.4% | 16.779 | 28.945 | 93.137 | 27.779 | 41.119 |
| hex: silesia/mozilla | 524290 | 43324.5 ± 0.7% | 2589.2 ± 2.7% | 1504.2 ± 1.1% | 412.7 ± 0.7% | 1562.5 ± 0.8% | 1062.4 ± 2.1% | 16.733 | 28.802 | 104.969 | 27.728 | 40.780 |
| hex: silesia/mr | 524290 | 43754.8 ± 0.3% | 2593.3 ± 0.6% | 1505.4 ± 0.3% | 605.5 ± 0.4% | 1549.9 ± 0.5% | 1067.0 ± 0.5% | 16.872 | 29.066 | 72.259 | 28.230 | 41.006 |
| hex: silesia/nci | 524290 | 43505.3 ± 2.3% | 2576.1 ± 1.1% | 1498.4 ± 0.5% | 750.9 ± 0.5% | 1560.8 ± 0.7% | 1064.2 ± 0.7% | 16.888 | 29.034 | 57.935 | 27.873 | 40.880 |
| hex: silesia/ooffice | 524290 | 42768.3 ± 2.1% | 2594.7 ± 0.6% | 1504.8 ± 0.8% | 341.5 ± 0.6% | 1558.0 ± 0.8% | 1068.9 ± 1.0% | 16.483 | 28.422 | 125.240 | 27.451 | 40.011 |
| hex: silesia/osdb | 524290 | 43332.0 ± 2.1% | 2590.5 ± 0.9% | 1508.0 ± 0.4% | 450.5 ± 0.2% | 1571.5 ± 0.9% | 1063.6 ± 0.6% | 16.728 | 28.735 | 96.182 | 27.574 | 40.741 |
| hex: silesia/reymont | 524290 | 42869.0 ± 2.3% | 2576.2 ± 1.1% | 1496.3 ± 3.6% | 485.2 ± 1.0% | 1549.0 ± 0.3% | 1060.4 ± 1.1% | 16.640 | 28.649 | 88.358 | 27.675 | 40.426 |
| hex: silesia/samba | 524290 | 43364.6 ± 1.6% | 2593.9 ± 1.1% | 1499.2 ± 0.5% | 361.4 ± 0.4% | 1572.1 ± 0.3% | 1062.1 ± 0.8% | 16.718 | 28.926 | 120.005 | 27.584 | 40.830 |
| hex: silesia/sao | 524290 | 42615.1 ± 1.1% | 2602.2 ± 0.8% | 1505.7 ± 0.9% | 277.4 ± 1.2% | 1558.4 ± 0.7% | 1066.3 ± 0.4% | 16.376 | 28.303 | 153.632 | 27.345 | 39.965 |
| hex: silesia/webster | 524290 | 43831.4 ± 0.6% | 2605.9 ± 0.6% | 1510.3 ± 0.4% | 436.7 ± 0.8% | 1577.2 ± 0.6% | 1070.2 ± 0.6% | 16.820 | 29.022 | 100.364 | 27.791 | 40.958 |
| hex: silesia/x-ray | 524290 | 43348.1 ± 1.7% | 2600.4 ± 0.6% | 1508.1 ± 0.4% | 425.5 ± 0.8% | 1552.5 ± 1.1% | 1066.0 ± 0.7% | 16.670 | 28.744 | 101.870 | 27.922 | 40.663 |
| hex: silesia/xml | 524290 | 43080.1 ± 3.7% | 2585.4 ± 0.8% | 1502.7 ± 1.2% | 711.0 ± 1.7% | 1566.1 ± 0.8% | 1066.0 ± 0.8% | 16.663 | 28.669 | 60.589 | 27.507 | 40.412 |
| hex: canterbury/alice29.txt | 304180 | 43268.1 ± 1.0% | 2611.4 ± 0.7% | 1513.1 ± 1.1% | 474.0 ± 0.4% | 1586.2 ± 0.4% | 1081.1 ± 0.7% | 16.569 | 28.596 | 91.284 | 27.278 | 40.022 |
| hex: canterbury/asyoulik.txt | 250360 | 42891.1 ± 2.0% | 2605.9 ± 0.6% | 1529.7 ± 0.8% | 459.8 ± 0.7% | 1580.9 ± 0.3% | 1080.2 ± 0.7% | 16.459 | 28.038 | 93.274 | 27.130 | 39.707 |
| hex: canterbury/cp.html | 49208 | 41867.0 ± 1.4% | 2582.2 ± 6.3% | 1515.4 ± 1.2% | 484.1 ± 1.1% | 1585.0 ± 1.0% | 1085.9 ± 1.4% | 16.214 | 27.627 | 86.487 | 26.414 | 38.554 |
| hex: canterbury/fields.c | 22302 | 41282.0 ± 0.9% | 2649.3 ± 7.2% | 1520.8 ± 3.4% | 609.3 ± 0.6% | 1601.5 ± 0.9% | 1093.0 ± 0.6% | 15.582 | 27.144 | 67.756 | 25.778 | 37.770 |
| hex: canterbury/grammar.lsp | 7444 | 39361.1 ± 1.0% | 2671.6 ± 1.4% | 1530.6 ± 0.7% | 794.8 ± 0.6% | 1598.3 ± 0.4% | 1099.7 ± 0.7% | 14.733 | 25.716 | 49.522 | 24.626 | 35.792 |
| hex: canterbury/kennedy.xls | 524290 | 41647.5 ± 7.1% | 2587.7 ± 0.5% | 1499.3 ± 0.3% | 743.7 ± 0.9% | 1544.3 ± 0.4% | 1062.8 ± 0.7% | 16.094 | 27.778 | 56.001 | 26.969 | 39.187 |
| hex: canterbury/lcet10.txt | 524290 | 43399.5 ± 0.6% | 2586.7 ± 2.0% | 1500.7 ± 0.4% | 472.5 ± 0.8% | 1556.8 ± 0.2% | 1059.0 ± 0.4% | 16.778 | 28.920 | 91.858 | 27.877 | 40.980 |
| hex: canterbury/plrabn12.txt | 524290 | 43250.6 ± 0.9% | 2584.6 ± 0.5% | 1502.7 ± 0.4% | 456.8 ± 0.7% | 1550.8 ± 0.6% | 1062.6 ± 0.8% | 16.734 | 28.781 | 94.672 | 27.890 | 40.704 |
| hex: canterbury/ptt5 | 524290 | 43578.4 ± 1.2% | 2569.4 ± 9.5% | 1494.5 ± 0.6% | 607.6 ± 0.9% | 1554.7 ± 0.3% | 1058.3 ± 0.6% | 16.960 | 29.158 | 71.721 | 28.031 | 41.177 |
| hex: canterbury/sum | 76482 | 42588.5 ± 1.4% | 2571.8 ± 0.6% | 1509.3 ± 0.9% | 582.8 ± 0.4% | 1572.8 ± 0.4% | 1084.1 ± 0.4% | 16.560 | 28.218 | 73.070 | 27.077 | 39.285 |
| hex: canterbury/xargs.1 | 8456 | 39908.6 ± 1.0% | 2674.1 ± 0.6% | 1531.9 ± 0.4% | 823.1 ± 2.8% | 1602.9 ± 2.2% | 1103.7 ± 2.9% | 14.924 | 26.051 | 48.487 | 24.897 | 36.160 |
| hex: canterbury-large/E.coli | 524290 | 43572.0 ± 0.5% | 2594.7 ± 0.4% | 1506.0 ± 0.8% | 808.7 ± 1.2% | 1551.1 ± 0.3% | 1065.7 ± 5.2% | 16.793 | 28.931 | 53.877 | 28.091 | 40.887 |
| hex: canterbury-large/bible.txt | 524290 | 43221.7 ± 2.8% | 2577.8 ± 1.0% | 1498.6 ± 1.0% | 485.5 ± 1.0% | 1562.9 ± 0.7% | 1062.1 ± 1.1% | 16.767 | 28.841 | 89.029 | 27.655 | 40.696 |
| hex: canterbury-large/world192.txt | 524290 | 39014.7 ± 1.8% | 2584.8 ± 8.1% | 1502.2 ± 1.0% | 461.4 ± 0.9% | 1555.4 ± 6.0% | 1070.4 ± 0.7% | 15.094 | 25.972 | 84.564 | 25.084 | 36.448 |
| hex: http/html-1kx1024 | 2099200 | 20412.6 ± 0.6% | 2391.5 ± 0.5% | 1415.5 ± 0.4% | 498.5 ± 0.8% | 1485.5 ± 1.4% | 1069.2 ± 5.3% | 8.535 | 14.421 | 40.945 | 13.741 | 19.091 |
| hex: http/html-16kx64 | 2097280 | 22096.0 ± 0.4% | 2375.3 ± 1.7% | 1448.2 ± 0.8% | 506.6 ± 1.2% | 1503.3 ± 1.1% | 1080.3 ± 1.2% | 9.303 | 15.257 | 43.612 | 14.698 | 20.453 |
| hex: http/html-1m | 524290 | 40254.0 ± 0.8% | 2590.6 ± 0.8% | 1504.2 ± 0.6% | 494.1 ± 4.1% | 1574.8 ± 0.8% | 1067.9 ± 0.6% | 15.539 | 26.761 | 81.467 | 25.561 | 37.695 |
| hex: http/json-1kx1024 | 2099200 | 20803.3 ± 0.5% | 2372.6 ± 3.6% | 1407.8 ± 1.1% | 682.2 ± 1.2% | 1478.5 ± 1.6% | 1069.9 ± 0.9% | 8.768 | 14.777 | 30.496 | 14.071 | 19.444 |
| hex: http/json-16kx64 | 2097280 | 21535.7 ± 0.3% | 2369.5 ± 1.1% | 1442.3 ± 0.4% | 690.5 ± 0.6% | 1500.6 ± 0.5% | 1079.4 ± 0.5% | 9.089 | 14.932 | 31.187 | 14.351 | 19.952 |
| hex: http/json-1m | 524290 | 43000.5 ± 1.6% | 2569.2 ± 0.5% | 1496.3 ± 0.9% | 720.6 ± 0.9% | 1567.5 ± 0.6% | 1060.5 ± 0.3% | 16.737 | 28.739 | 59.673 | 27.433 | 40.549 |
| hex: http/js-1kx1024 | 2099200 | 20396.9 ± 0.2% | 2394.2 ± 1.4% | 1410.6 ± 0.9% | 487.4 ± 0.9% | 1491.2 ± 0.9% | 1070.1 ± 1.0% | 8.519 | 14.460 | 41.848 | 13.678 | 19.061 |
| hex: http/js-16kx64 | 2097280 | 21812.7 ± 0.4% | 2373.7 ± 0.2% | 1445.1 ± 0.4% | 493.0 ± 0.4% | 1500.0 ± 0.4% | 1075.6 ± 6.0% | 9.190 | 15.094 | 44.243 | 14.542 | 20.280 |
| hex: http/js-1m | 524290 | 42726.0 ± 1.1% | 2592.2 ± 0.8% | 1498.7 ± 0.6% | 503.3 ± 0.9% | 1529.9 ± 0.5% | 1057.8 ± 1.1% | 16.483 | 28.509 | 84.895 | 27.927 | 40.392 |
| hex: http/css-1kx1024 | 2099200 | 20197.4 ± 0.3% | 2395.6 ± 1.1% | 1421.4 ± 0.5% | 560.5 ± 0.8% | 1488.1 ± 0.4% | 1073.2 ± 0.5% | 8.431 | 14.210 | 36.032 | 13.572 | 18.821 |
| hex: http/css-16kx64 | 2097280 | 22362.5 ± 0.3% | 2376.9 ± 1.0% | 1443.0 ± 0.7% | 533.2 ± 0.8% | 1298.3 ± 0.4% | 1079.5 ± 0.4% | 9.408 | 15.497 | 41.939 | 17.224 | 20.715 |
| hex: http/css-1m | 524290 | 43255.7 ± 1.0% | 2580.3 ± 1.2% | 1499.9 ± 0.9% | 542.8 ± 0.6% | 1564.3 ± 6.3% | 1061.1 ± 0.9% | 16.764 | 28.840 | 79.695 | 27.652 | 40.767 |
| hex: shuffled/dickens-1m | 524290 | 43402.2 ± 1.4% | 2586.4 ± 0.7% | 1500.9 ± 0.7% | 463.8 ± 0.5% | 1527.9 ± 2.6% | 1060.9 ± 6.3% | 16.781 | 28.917 | 93.578 | 28.407 | 40.912 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1148.8 ± 0.8% | 1475.9 ± 1.3% | 1079.0 ± 1.1% | 398.4 ± 1.5% | 665.6 ± 0.8% | 363.9 ± 1.4% | 0.778 | 1.065 | 2.884 | 1.726 | 3.157 |
| qlog records, JSON text sequence | 1467503 | 1016.4 ± 1.0% | 1232.8 ± 1.2% | 1127.5 ± 0.5% | 342.9 ± 0.9% | 743.2 ± 1.0% | 316.1 ± 0.7% | 0.824 | 0.901 | 2.964 | 1.367 | 3.215 |
| string: silesia/dickens | 172528 | 5987.6 ± 1.1% | 3396.2 ± 1.2% | 2807.6 ± 1.1% | 304.9 ± 0.6% | 3012.3 ± 1.5% | 566.7 ± 1.4% | 1.763 | 2.133 | 19.638 | 1.988 | 10.566 |
| string: silesia/nci | 1075110 | 4721.4 ± 1.0% | 3873.7 ± 0.3% | 3007.0 ± 0.7% | 636.1 ± 1.2% | 3609.0 ± 1.3% | 563.0 ± 1.0% | 1.219 | 1.570 | 7.423 | 1.308 | 8.387 |
| string: silesia/reymont | 1075159 | 4039.2 ± 1.4% | 3395.1 ± 0.6% | 1945.0 ± 1.4% | 322.1 ± 3.8% | 2098.5 ± 1.3% | 488.5 ± 3.4% | 1.190 | 2.077 | 12.541 | 1.925 | 8.269 |
| string: silesia/samba | 97582 | 4044.7 ± 0.4% | 3783.9 ± 0.5% | 3033.4 ± 0.7% | 330.2 ± 0.9% | 1910.0 ± 1.9% | 415.0 ± 4.1% | 1.069 | 1.333 | 12.249 | 2.118 | 9.747 |
| string: silesia/webster | 1098490 | 4130.5 ± 0.5% | 2432.6 ± 0.5% | 1729.9 ± 0.8% | 300.5 ± 0.6% | 2042.3 ± 0.6% | 462.2 ± 1.3% | 1.698 | 2.388 | 13.743 | 2.022 | 8.938 |
| string: silesia/xml | 1090118 | 5951.7 ± 0.6% | 5053.5 ± 0.5% | 2433.4 ± 1.8% | 502.1 ± 1.2% | 3278.6 ± 0.8% | 536.4 ± 1.0% | 1.178 | 2.446 | 11.854 | 1.815 | 11.095 |
| string: canterbury/alice29.txt | 159425 | 5896.5 ± 2.4% | 2774.4 ± 0.2% | 2789.4 ± 1.4% | 293.2 ± 0.6% | 2718.3 ± 2.6% | 514.5 ± 2.1% | 2.125 | 2.114 | 20.109 | 2.169 | 11.460 |
| string: canterbury/asyoulik.txt | 132198 | 4229.6 ± 1.0% | 2521.7 ± 4.6% | 2781.0 ± 1.3% | 295.6 ± 0.5% | 2371.6 ± 0.7% | 450.4 ± 2.4% | 1.677 | 1.521 | 14.307 | 1.783 | 9.392 |
| string: canterbury/lcet10.txt | 441884 | 5986.4 ± 1.1% | 3262.1 ± 1.3% | 2282.0 ± 1.8% | 337.5 ± 1.8% | 2743.9 ± 0.6% | 566.7 ± 4.0% | 1.835 | 2.623 | 17.735 | 2.182 | 10.564 |
| string: canterbury/plrabn12.txt | 503330 | 5923.0 ± 1.6% | 3126.5 ± 3.0% | 1822.4 ± 1.5% | 318.4 ± 0.8% | 2814.9 ± 1.3% | 530.2 ± 1.2% | 1.894 | 3.250 | 18.600 | 2.104 | 11.170 |
| string: canterbury-large/E.coli | 1048578 | 33890.4 ± 0.6% | 13038.3 ± 0.4% | 3411.9 ± 0.2% | 1273.2 ± 0.9% | 8847.4 ± 0.9% | 958.5 ± 2.4% | 2.599 | 9.933 | 26.619 | 3.831 | 35.356 |
| string: canterbury-large/bible.txt | 1055886 | 9015.7 ± 1.7% | 5219.7 ± 0.7% | 2765.8 ± 0.5% | 350.0 ± 0.8% | 3853.1 ± 0.7% | 624.9 ± 1.3% | 1.727 | 3.260 | 25.756 | 2.340 | 14.427 |
| string: canterbury-large/world192.txt | 1103121 | 4002.0 ± 1.3% | 2306.7 ± 1.0% | 1755.0 ± 0.9% | 325.3 ± 0.7% | 2082.0 ± 1.0% | 463.0 ± 2.4% | 1.735 | 2.280 | 12.304 | 1.922 | 8.644 |
| string: http/html-1m | 1058582 | 7682.1 ± 2.1% | 4692.1 ± 0.9% | 2678.9 ± 0.5% | 400.3 ± 0.5% | 3601.0 ± 0.6% | 591.1 ± 1.1% | 1.637 | 2.868 | 19.192 | 2.133 | 12.997 |
| string: http/json-1m | 1190272 | 3179.7 ± 1.9% | 1249.1 ± 2.0% | 2076.5 ± 1.0% | 477.7 ± 1.3% | 1331.3 ± 4.8% | 430.3 ± 3.4% | 2.546 | 1.531 | 6.657 | 2.389 | 7.390 |
| string: http/js-1m | 1144362 | 2997.1 ± 0.9% | 1613.0 ± 0.3% | 1324.9 ± 0.5% | 321.9 ± 0.2% | 1424.4 ± 0.6% | 378.5 ± 0.9% | 1.858 | 2.262 | 9.310 | 2.104 | 7.918 |
| string: http/css-1m | 1097820 | 3051.9 ± 0.4% | 2874.4 ± 1.0% | 2266.1 ± 1.0% | 438.7 ± 0.5% | 2061.0 ± 1.1% | 432.1 ± 8.0% | 1.062 | 1.347 | 6.957 | 1.481 | 7.063 |
| string: dickens as Cyrillic and CJK | 1883069 | 5835.1 ± 0.8% | 3337.5 ± 1.9% | 659.8 ± 0.9% | 369.8 ± 1.1% | 510.5 ± 0.8% | 164.7 ± 3.4% | 1.748 | 8.844 | 15.778 | 11.429 | 35.437 |
| string: dickens as Cyrillic and CJK, as \u escapes | 5075485 | 1199.7 ± 0.7% | 1236.2 ± 2.0% | 1100.8 ± 1.2% | 266.7 ± 0.8% | 477.0 ± 0.9% | 227.9 ± 3.3% | 0.971 | 1.090 | 4.499 | 2.515 | 5.264 |
| hex: silesia/dickens | 524290 | 33881.9 ± 0.3% | 14986.3 ± 0.5% | 3480.3 ± 0.4% | 477.1 ± 2.6% | 8853.3 ± 0.7% | 1126.7 ± 2.1% | 2.261 | 9.735 | 71.019 | 3.827 | 30.072 |
| hex: silesia/mozilla | 524290 | 33672.8 ± 0.3% | 14958.0 ± 0.5% | 3546.0 ± 0.4% | 425.4 ± 0.7% | 8852.2 ± 0.4% | 1127.3 ± 1.0% | 2.251 | 9.496 | 79.152 | 3.804 | 29.871 |
| hex: silesia/mr | 524290 | 33739.5 ± 4.2% | 14948.6 ± 1.1% | 3549.1 ± 3.4% | 643.6 ± 0.8% | 8874.8 ± 0.9% | 1123.2 ± 5.6% | 2.257 | 9.507 | 52.423 | 3.802 | 30.040 |
| hex: silesia/nci | 524290 | 33802.5 ± 0.9% | 15030.0 ± 0.9% | 3490.3 ± 0.6% | 794.3 ± 1.5% | 8872.7 ± 0.9% | 1128.5 ± 1.5% | 2.249 | 9.685 | 42.555 | 3.810 | 29.953 |
| hex: silesia/ooffice | 524290 | 33907.6 ± 0.6% | 15062.5 ± 0.7% | 3556.0 ± 0.7% | 342.9 ± 1.4% | 8906.6 ± 1.2% | 1129.1 ± 1.8% | 2.251 | 9.535 | 98.876 | 3.807 | 30.030 |
| hex: silesia/osdb | 524290 | 33849.8 ± 0.5% | 15006.0 ± 0.7% | 3548.5 ± 1.1% | 444.5 ± 2.1% | 8908.2 ± 0.8% | 1129.0 ± 1.1% | 2.256 | 9.539 | 76.154 | 3.800 | 29.983 |
| hex: silesia/reymont | 524290 | 33867.1 ± 0.7% | 14978.9 ± 0.7% | 3477.4 ± 0.6% | 502.1 ± 1.7% | 8851.0 ± 0.7% | 1124.2 ± 1.2% | 2.261 | 9.739 | 67.448 | 3.826 | 30.124 |
| hex: silesia/samba | 524290 | 33794.6 ± 0.8% | 15011.7 ± 0.6% | 3536.9 ± 0.6% | 365.4 ± 0.9% | 8863.7 ± 4.7% | 1130.9 ± 1.8% | 2.251 | 9.555 | 92.496 | 3.813 | 29.884 |
| hex: silesia/sao | 524290 | 33854.0 ± 0.7% | 14949.0 ± 1.0% | 3441.7 ± 0.8% | 274.5 ± 1.7% | 8847.3 ± 0.6% | 1127.7 ± 1.4% | 2.265 | 9.836 | 123.320 | 3.826 | 30.021 |
| hex: silesia/webster | 524290 | 33937.5 ± 0.7% | 15101.6 ± 0.7% | 3554.7 ± 0.7% | 450.8 ± 0.7% | 8882.6 ± 0.4% | 1134.8 ± 0.7% | 2.247 | 9.547 | 75.278 | 3.821 | 29.907 |
| hex: silesia/x-ray | 524290 | 33783.6 ± 0.9% | 15078.4 ± 0.5% | 3485.3 ± 0.6% | 422.8 ± 1.5% | 8872.5 ± 0.7% | 1135.8 ± 0.8% | 2.241 | 9.693 | 79.902 | 3.808 | 29.744 |
| hex: silesia/xml | 524290 | 33891.5 ± 1.0% | 15067.3 ± 0.9% | 3563.1 ± 0.8% | 733.6 ± 1.3% | 8867.8 ± 5.2% | 1124.3 ± 2.0% | 2.249 | 9.512 | 46.200 | 3.822 | 30.144 |
| hex: canterbury/alice29.txt | 304180 | 33709.7 ± 1.2% | 14066.1 ± 1.4% | 3539.4 ± 2.9% | 482.5 ± 0.9% | 8907.8 ± 0.6% | 1137.2 ± 0.8% | 2.397 | 9.524 | 69.859 | 3.784 | 29.644 |
| hex: canterbury/asyoulik.txt | 250360 | 33739.9 ± 0.3% | 15049.4 ± 0.7% | 3492.7 ± 0.4% | 470.9 ± 0.2% | 8885.2 ± 0.6% | 1140.7 ± 1.7% | 2.242 | 9.660 | 71.652 | 3.797 | 29.579 |
| hex: canterbury/cp.html | 49208 | 33384.3 ± 0.8% | 14372.6 ± 0.8% | 3548.4 ± 0.6% | 500.8 ± 3.0% | 9232.5 ± 0.4% | 1123.8 ± 1.7% | 2.323 | 9.408 | 66.656 | 3.616 | 29.707 |
| hex: canterbury/fields.c | 22302 | 32826.4 ± 1.0% | 17518.3 ± 1.3% | 3647.0 ± 0.8% | 560.7 ± 1.2% | 9194.0 ± 0.3% | 1090.0 ± 2.0% | 1.874 | 9.001 | 58.550 | 3.570 | 30.117 |
| hex: canterbury/grammar.lsp | 7444 | 29812.0 ± 0.5% | 17146.2 ± 0.8% | 3612.0 ± 1.2% | 764.6 ± 3.6% | 8909.0 ± 4.0% | 1056.3 ± 2.3% | 1.739 | 8.254 | 38.988 | 3.346 | 28.223 |
| hex: canterbury/kennedy.xls | 524290 | 33870.3 ± 3.9% | 15081.8 ± 1.7% | 3524.3 ± 1.1% | 752.3 ± 1.5% | 8866.8 ± 5.4% | 1111.1 ± 6.4% | 2.246 | 9.610 | 45.022 | 3.820 | 30.485 |
| hex: canterbury/lcet10.txt | 524290 | 33763.4 ± 0.5% | 14956.0 ± 0.8% | 3526.4 ± 0.7% | 482.5 ± 1.0% | 8841.9 ± 0.6% | 1111.7 ± 1.6% | 2.258 | 9.574 | 69.969 | 3.819 | 30.371 |
| hex: canterbury/plrabn12.txt | 524290 | 33735.6 ± 0.5% | 14946.3 ± 3.2% | 3546.2 ± 0.7% | 464.8 ± 0.9% | 8831.4 ± 5.0% | 1116.0 ± 2.0% | 2.257 | 9.513 | 72.583 | 3.820 | 30.230 |
| hex: canterbury/ptt5 | 524290 | 33641.4 ± 4.1% | 14940.9 ± 0.4% | 3450.8 ± 0.5% | 661.6 ± 0.7% | 8837.0 ± 0.9% | 1112.3 ± 1.4% | 2.252 | 9.749 | 50.847 | 3.807 | 30.244 |
| hex: canterbury/sum | 76482 | 33222.6 ± 0.4% | 15365.0 ± 1.1% | 3550.7 ± 2.0% | 580.3 ± 0.9% | 8903.3 ± 0.6% | 1115.1 ± 1.9% | 2.162 | 9.357 | 57.248 | 3.732 | 29.794 |
| hex: canterbury/xargs.1 | 8456 | 30208.3 ± 0.3% | 17334.2 ± 0.7% | 3543.8 ± 1.1% | 732.8 ± 1.6% | 8906.5 ± 1.2% | 1094.9 ± 1.6% | 1.743 | 8.524 | 41.222 | 3.392 | 27.590 |
| hex: canterbury-large/E.coli | 524290 | 33739.4 ± 1.1% | 14980.4 ± 1.1% | 3467.3 ± 0.4% | 955.3 ± 0.8% | 8847.4 ± 0.7% | 1114.4 ± 5.9% | 2.252 | 9.731 | 35.318 | 3.813 | 30.275 |
| hex: canterbury-large/bible.txt | 524290 | 33697.5 ± 2.1% | 14922.0 ± 1.1% | 3471.2 ± 0.7% | 499.2 ± 0.7% | 8850.3 ± 5.2% | 1109.3 ± 1.4% | 2.258 | 9.708 | 67.508 | 3.808 | 30.376 |
| hex: canterbury-large/world192.txt | 524290 | 33898.5 ± 1.1% | 15048.2 ± 1.7% | 3560.4 ± 1.1% | 469.5 ± 0.5% | 8939.8 ± 0.9% | 1107.1 ± 3.0% | 2.253 | 9.521 | 72.200 | 3.792 | 30.618 |
| hex: http/html-1kx1024 | 2099200 | 15282.1 ± 0.7% | 12550.1 ± 3.9% | 3170.4 ± 1.0% | 507.6 ± 1.4% | 7596.0 ± 1.3% | 946.9 ± 2.4% | 1.218 | 4.820 | 30.109 | 2.012 | 16.139 |
| hex: http/html-16kx64 | 2097280 | 27550.6 ± 0.5% | 13938.5 ± 1.0% | 3393.4 ± 1.0% | 512.0 ± 3.3% | 8426.2 ± 1.4% | 1054.5 ± 3.4% | 1.977 | 8.119 | 53.813 | 3.270 | 26.127 |
| hex: http/html-1m | 524290 | 33876.9 ± 0.7% | 14981.3 ± 3.8% | 3477.7 ± 0.8% | 504.7 ± 1.0% | 8844.5 ± 3.0% | 1092.3 ± 3.9% | 2.261 | 9.741 | 67.128 | 3.830 | 31.015 |
| hex: http/json-1kx1024 | 2099200 | 15141.7 ± 0.6% | 12528.1 ± 10.2% | 3149.7 ± 1.7% | 679.8 ± 0.8% | 7548.7 ± 2.5% | 946.7 ± 2.9% | 1.209 | 4.807 | 22.275 | 2.006 | 15.993 |
| hex: http/json-16kx64 | 2097280 | 27609.1 ± 0.6% | 13915.0 ± 0.7% | 3390.7 ± 0.6% | 694.6 ± 0.9% | 8591.2 ± 0.8% | 1079.3 ± 1.6% | 1.984 | 8.143 | 39.746 | 3.214 | 25.580 |
| hex: http/json-1m | 524290 | 33711.7 ± 4.6% | 13089.0 ± 1.9% | 3521.0 ± 0.3% | 709.4 ± 1.0% | 8860.8 ± 0.9% | 1099.4 ± 3.8% | 2.576 | 9.575 | 47.524 | 3.805 | 30.665 |
| hex: http/js-1kx1024 | 2099200 | 15370.1 ± 0.6% | 12175.8 ± 1.3% | 3146.7 ± 0.2% | 487.9 ± 0.7% | 7564.8 ± 1.6% | 961.5 ± 3.5% | 1.262 | 4.885 | 31.503 | 2.032 | 15.985 |
| hex: http/js-16kx64 | 2097280 | 27785.7 ± 0.7% | 13717.1 ± 0.7% | 3396.6 ± 0.7% | 495.4 ± 1.1% | 8619.0 ± 0.4% | 1075.9 ± 4.2% | 2.026 | 8.180 | 56.086 | 3.224 | 25.826 |
| hex: http/js-1m | 524290 | 33822.5 ± 0.4% | 14300.4 ± 1.2% | 3555.1 ± 0.7% | 513.1 ± 2.6% | 8884.9 ± 0.9% | 1106.3 ± 4.0% | 2.365 | 9.514 | 65.914 | 3.807 | 30.572 |
| hex: http/css-1kx1024 | 2099200 | 15176.8 ± 1.4% | 12559.1 ± 1.0% | 3149.9 ± 1.1% | 568.1 ± 1.1% | 7545.8 ± 3.4% | 975.2 ± 2.4% | 1.208 | 4.818 | 26.715 | 2.011 | 15.563 |
| hex: http/css-16kx64 | 2097280 | 27366.2 ± 1.0% | 13827.3 ± 1.6% | 3378.8 ± 0.8% | 579.3 ± 1.2% | 7927.4 ± 2.5% | 1064.9 ± 3.2% | 1.979 | 8.099 | 47.241 | 3.452 | 25.699 |
| hex: http/css-1m | 524290 | 33874.8 ± 0.8% | 14997.8 ± 1.2% | 3537.4 ± 1.0% | 556.8 ± 0.9% | 8883.4 ± 0.7% | 1123.4 ± 2.9% | 2.259 | 9.576 | 60.836 | 3.813 | 30.155 |
| hex: shuffled/dickens-1m | 524290 | 33829.9 ± 0.6% | 14998.2 ± 0.7% | 3471.5 ± 0.7% | 477.2 ± 0.7% | 8857.9 ± 0.6% | 1123.9 ± 0.8% | 2.256 | 9.745 | 70.893 | 3.819 | 30.099 |

## TextReader.next_items against the baselines

stdx's decoder a slice of tokens a call through `TextReader.next_items`, as a caller that reads a text's values in a loop calls it (decision 79). Octets are the text's. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1298.7 ± 0.9% | 1475.9 ± 1.3% | 1079.0 ± 1.1% | 398.4 ± 1.5% | 665.6 ± 0.8% | 363.9 ± 1.4% | 0.880 | 1.204 | 3.260 | 1.951 | 3.569 |
| qlog records, JSON text sequence | 1467503 | 1180.6 ± 0.7% | 1232.8 ± 1.2% | 1127.5 ± 0.5% | 342.9 ± 0.9% | 743.2 ± 1.0% | 316.1 ± 0.7% | 0.958 | 1.047 | 3.443 | 1.588 | 3.734 |
| string: silesia/dickens | 172528 | 6024.0 ± 0.9% | 3396.2 ± 1.2% | 2807.6 ± 1.1% | 304.9 ± 0.6% | 3012.3 ± 1.5% | 566.7 ± 1.4% | 1.774 | 2.146 | 19.758 | 2.000 | 10.630 |
| string: silesia/nci | 1075110 | 4752.1 ± 0.8% | 3873.7 ± 0.3% | 3007.0 ± 0.7% | 636.1 ± 1.2% | 3609.0 ± 1.3% | 563.0 ± 1.0% | 1.227 | 1.580 | 7.471 | 1.317 | 8.441 |
| string: silesia/reymont | 1075159 | 4073.7 ± 1.1% | 3395.1 ± 0.6% | 1945.0 ± 1.4% | 322.1 ± 3.8% | 2098.5 ± 1.3% | 488.5 ± 3.4% | 1.200 | 2.094 | 12.648 | 1.941 | 8.340 |
| string: silesia/samba | 97582 | 4047.7 ± 0.7% | 3783.9 ± 0.5% | 3033.4 ± 0.7% | 330.2 ± 0.9% | 1910.0 ± 1.9% | 415.0 ± 4.1% | 1.070 | 1.334 | 12.258 | 2.119 | 9.754 |
| string: silesia/webster | 1098490 | 4165.6 ± 1.2% | 2432.6 ± 0.5% | 1729.9 ± 0.8% | 300.5 ± 0.6% | 2042.3 ± 0.6% | 462.2 ± 1.3% | 1.712 | 2.408 | 13.860 | 2.040 | 9.013 |
| string: silesia/xml | 1090118 | 5952.3 ± 0.9% | 5053.5 ± 0.5% | 2433.4 ± 1.8% | 502.1 ± 1.2% | 3278.6 ± 0.8% | 536.4 ± 1.0% | 1.178 | 2.446 | 11.856 | 1.815 | 11.096 |
| string: canterbury/alice29.txt | 159425 | 6090.1 ± 1.6% | 2774.4 ± 0.2% | 2789.4 ± 1.4% | 293.2 ± 0.6% | 2718.3 ± 2.6% | 514.5 ± 2.1% | 2.195 | 2.183 | 20.770 | 2.240 | 11.837 |
| string: canterbury/asyoulik.txt | 132198 | 4271.8 ± 1.0% | 2521.7 ± 4.6% | 2781.0 ± 1.3% | 295.6 ± 0.5% | 2371.6 ± 0.7% | 450.4 ± 2.4% | 1.694 | 1.536 | 14.450 | 1.801 | 9.485 |
| string: canterbury/lcet10.txt | 441884 | 6003.7 ± 0.7% | 3262.1 ± 1.3% | 2282.0 ± 1.8% | 337.5 ± 1.8% | 2743.9 ± 0.6% | 566.7 ± 4.0% | 1.840 | 2.631 | 17.787 | 2.188 | 10.595 |
| string: canterbury/plrabn12.txt | 503330 | 5931.8 ± 1.0% | 3126.5 ± 3.0% | 1822.4 ± 1.5% | 318.4 ± 0.8% | 2814.9 ± 1.3% | 530.2 ± 1.2% | 1.897 | 3.255 | 18.627 | 2.107 | 11.187 |
| string: canterbury-large/E.coli | 1048578 | 33735.8 ± 1.5% | 13038.3 ± 0.4% | 3411.9 ± 0.2% | 1273.2 ± 0.9% | 8847.4 ± 0.9% | 958.5 ± 2.4% | 2.587 | 9.888 | 26.497 | 3.813 | 35.195 |
| string: canterbury-large/bible.txt | 1055886 | 9109.1 ± 3.2% | 5219.7 ± 0.7% | 2765.8 ± 0.5% | 350.0 ± 0.8% | 3853.1 ± 0.7% | 624.9 ± 1.3% | 1.745 | 3.294 | 26.023 | 2.364 | 14.577 |
| string: canterbury-large/world192.txt | 1103121 | 4020.9 ± 1.2% | 2306.7 ± 1.0% | 1755.0 ± 0.9% | 325.3 ± 0.7% | 2082.0 ± 1.0% | 463.0 ± 2.4% | 1.743 | 2.291 | 12.362 | 1.931 | 8.685 |
| string: http/html-1m | 1058582 | 7818.6 ± 1.2% | 4692.1 ± 0.9% | 2678.9 ± 0.5% | 400.3 ± 0.5% | 3601.0 ± 0.6% | 591.1 ± 1.1% | 1.666 | 2.919 | 19.533 | 2.171 | 13.228 |
| string: http/json-1m | 1190272 | 3177.0 ± 0.3% | 1249.1 ± 2.0% | 2076.5 ± 1.0% | 477.7 ± 1.3% | 1331.3 ± 4.8% | 430.3 ± 3.4% | 2.543 | 1.530 | 6.651 | 2.386 | 7.384 |
| string: http/js-1m | 1144362 | 2998.4 ± 0.5% | 1613.0 ± 0.3% | 1324.9 ± 0.5% | 321.9 ± 0.2% | 1424.4 ± 0.6% | 378.5 ± 0.9% | 1.859 | 2.263 | 9.314 | 2.105 | 7.922 |
| string: http/css-1m | 1097820 | 3061.0 ± 0.7% | 2874.4 ± 1.0% | 2266.1 ± 1.0% | 438.7 ± 0.5% | 2061.0 ± 1.1% | 432.1 ± 8.0% | 1.065 | 1.351 | 6.977 | 1.485 | 7.084 |
| string: dickens as Cyrillic and CJK | 1883069 | 5851.8 ± 1.1% | 3337.5 ± 1.9% | 659.8 ± 0.9% | 369.8 ± 1.1% | 510.5 ± 0.8% | 164.7 ± 3.4% | 1.753 | 8.870 | 15.823 | 11.462 | 35.539 |
| string: dickens as Cyrillic and CJK, as \u escapes | 5075485 | 1209.3 ± 1.3% | 1236.2 ± 2.0% | 1100.8 ± 1.2% | 266.7 ± 0.8% | 477.0 ± 0.9% | 227.9 ± 3.3% | 0.978 | 1.099 | 4.535 | 2.535 | 5.306 |
| hex: silesia/dickens | 524290 | 33729.9 ± 4.2% | 14986.3 ± 0.5% | 3480.3 ± 0.4% | 477.1 ± 2.6% | 8853.3 ± 0.7% | 1126.7 ± 2.1% | 2.251 | 9.692 | 70.700 | 3.810 | 29.937 |
| hex: silesia/mozilla | 524290 | 33698.0 ± 0.6% | 14958.0 ± 0.5% | 3546.0 ± 0.4% | 425.4 ± 0.7% | 8852.2 ± 0.4% | 1127.3 ± 1.0% | 2.253 | 9.503 | 79.212 | 3.807 | 29.893 |
| hex: silesia/mr | 524290 | 33833.4 ± 0.7% | 14948.6 ± 1.1% | 3549.1 ± 3.4% | 643.6 ± 0.8% | 8874.8 ± 0.9% | 1123.2 ± 5.6% | 2.263 | 9.533 | 52.569 | 3.812 | 30.123 |
| hex: silesia/nci | 524290 | 33758.4 ± 0.8% | 15030.0 ± 0.9% | 3490.3 ± 0.6% | 794.3 ± 1.5% | 8872.7 ± 0.9% | 1128.5 ± 1.5% | 2.246 | 9.672 | 42.499 | 3.805 | 29.914 |
| hex: silesia/ooffice | 524290 | 33839.5 ± 4.4% | 15062.5 ± 0.7% | 3556.0 ± 0.7% | 342.9 ± 1.4% | 8906.6 ± 1.2% | 1129.1 ± 1.8% | 2.247 | 9.516 | 98.678 | 3.799 | 29.969 |
| hex: silesia/osdb | 524290 | 33781.2 ± 0.4% | 15006.0 ± 0.7% | 3548.5 ± 1.1% | 444.5 ± 2.1% | 8908.2 ± 0.8% | 1129.0 ± 1.1% | 2.251 | 9.520 | 76.000 | 3.792 | 29.922 |
| hex: silesia/reymont | 524290 | 33894.2 ± 0.4% | 14978.9 ± 0.7% | 3477.4 ± 0.6% | 502.1 ± 1.7% | 8851.0 ± 0.7% | 1124.2 ± 1.2% | 2.263 | 9.747 | 67.502 | 3.829 | 30.149 |
| hex: silesia/samba | 524290 | 33744.9 ± 0.3% | 15011.7 ± 0.6% | 3536.9 ± 0.6% | 365.4 ± 0.9% | 8863.7 ± 4.7% | 1130.9 ± 1.8% | 2.248 | 9.541 | 92.361 | 3.807 | 29.840 |
| hex: silesia/sao | 524290 | 33764.3 ± 4.0% | 14949.0 ± 1.0% | 3441.7 ± 0.8% | 274.5 ± 1.7% | 8847.3 ± 0.6% | 1127.7 ± 1.4% | 2.259 | 9.810 | 122.993 | 3.816 | 29.942 |
| hex: silesia/webster | 524290 | 33844.1 ± 3.8% | 15101.6 ± 0.7% | 3554.7 ± 0.7% | 450.8 ± 0.7% | 8882.6 ± 0.4% | 1134.8 ± 0.7% | 2.241 | 9.521 | 75.071 | 3.810 | 29.825 |
| hex: silesia/x-ray | 524290 | 33889.6 ± 0.8% | 15078.4 ± 0.5% | 3485.3 ± 0.6% | 422.8 ± 1.5% | 8872.5 ± 0.7% | 1135.8 ± 0.8% | 2.248 | 9.724 | 80.153 | 3.820 | 29.838 |
| hex: silesia/xml | 524290 | 33828.4 ± 0.6% | 15067.3 ± 0.9% | 3563.1 ± 0.8% | 733.6 ± 1.3% | 8867.8 ± 5.2% | 1124.3 ± 2.0% | 2.245 | 9.494 | 46.114 | 3.815 | 30.087 |
| hex: canterbury/alice29.txt | 304180 | 33792.8 ± 0.7% | 14066.1 ± 1.4% | 3539.4 ± 2.9% | 482.5 ± 0.9% | 8907.8 ± 0.6% | 1137.2 ± 0.8% | 2.402 | 9.547 | 70.031 | 3.794 | 29.717 |
| hex: canterbury/asyoulik.txt | 250360 | 33766.9 ± 0.5% | 15049.4 ± 0.7% | 3492.7 ± 0.4% | 470.9 ± 0.2% | 8885.2 ± 0.6% | 1140.7 ± 1.7% | 2.244 | 9.668 | 71.710 | 3.800 | 29.602 |
| hex: canterbury/cp.html | 49208 | 33345.1 ± 0.4% | 14372.6 ± 0.8% | 3548.4 ± 0.6% | 500.8 ± 3.0% | 9232.5 ± 0.4% | 1123.8 ± 1.7% | 2.320 | 9.397 | 66.578 | 3.612 | 29.672 |
| hex: canterbury/fields.c | 22302 | 32847.7 ± 0.4% | 17518.3 ± 1.3% | 3647.0 ± 0.8% | 560.7 ± 1.2% | 9194.0 ± 0.3% | 1090.0 ± 2.0% | 1.875 | 9.007 | 58.588 | 3.573 | 30.136 |
| hex: canterbury/grammar.lsp | 7444 | 29666.2 ± 0.8% | 17146.2 ± 0.8% | 3612.0 ± 1.2% | 764.6 ± 3.6% | 8909.0 ± 4.0% | 1056.3 ± 2.3% | 1.730 | 8.213 | 38.797 | 3.330 | 28.085 |
| hex: canterbury/kennedy.xls | 524290 | 33874.1 ± 1.3% | 15081.8 ± 1.7% | 3524.3 ± 1.1% | 752.3 ± 1.5% | 8866.8 ± 5.4% | 1111.1 ± 6.4% | 2.246 | 9.611 | 45.027 | 3.820 | 30.488 |
| hex: canterbury/lcet10.txt | 524290 | 33672.3 ± 4.3% | 14956.0 ± 0.8% | 3526.4 ± 0.7% | 482.5 ± 1.0% | 8841.9 ± 0.6% | 1111.7 ± 1.6% | 2.251 | 9.549 | 69.780 | 3.808 | 30.289 |
| hex: canterbury/plrabn12.txt | 524290 | 33719.4 ± 0.2% | 14946.3 ± 3.2% | 3546.2 ± 0.7% | 464.8 ± 0.9% | 8831.4 ± 5.0% | 1116.0 ± 2.0% | 2.256 | 9.509 | 72.548 | 3.818 | 30.215 |
| hex: canterbury/ptt5 | 524290 | 33689.6 ± 0.4% | 14940.9 ± 0.4% | 3450.8 ± 0.5% | 661.6 ± 0.7% | 8837.0 ± 0.9% | 1112.3 ± 1.4% | 2.255 | 9.763 | 50.920 | 3.812 | 30.288 |
| hex: canterbury/sum | 76482 | 33264.8 ± 1.0% | 15365.0 ± 1.1% | 3550.7 ± 2.0% | 580.3 ± 0.9% | 8903.3 ± 0.6% | 1115.1 ± 1.9% | 2.165 | 9.368 | 57.320 | 3.736 | 29.832 |
| hex: canterbury/xargs.1 | 8456 | 30161.7 ± 0.6% | 17334.2 ± 0.7% | 3543.8 ± 1.1% | 732.8 ± 1.6% | 8906.5 ± 1.2% | 1094.9 ± 1.6% | 1.740 | 8.511 | 41.158 | 3.386 | 27.547 |
| hex: canterbury-large/E.coli | 524290 | 33705.3 ± 0.9% | 14980.4 ± 1.1% | 3467.3 ± 0.4% | 955.3 ± 0.8% | 8847.4 ± 0.7% | 1114.4 ± 5.9% | 2.250 | 9.721 | 35.283 | 3.810 | 30.245 |
| hex: canterbury-large/bible.txt | 524290 | 33722.2 ± 4.2% | 14922.0 ± 1.1% | 3471.2 ± 0.7% | 499.2 ± 0.7% | 8850.3 ± 5.2% | 1109.3 ± 1.4% | 2.260 | 9.715 | 67.557 | 3.810 | 30.399 |
| hex: canterbury-large/world192.txt | 524290 | 33930.5 ± 1.1% | 15048.2 ± 1.7% | 3560.4 ± 1.1% | 469.5 ± 0.5% | 8939.8 ± 0.9% | 1107.1 ± 3.0% | 2.255 | 9.530 | 72.268 | 3.795 | 30.647 |
| hex: http/html-1kx1024 | 2099200 | 14935.3 ± 0.7% | 12550.1 ± 3.9% | 3170.4 ± 1.0% | 507.6 ± 1.4% | 7596.0 ± 1.3% | 946.9 ± 2.4% | 1.190 | 4.711 | 29.426 | 1.966 | 15.773 |
| hex: http/html-16kx64 | 2097280 | 27578.6 ± 0.7% | 13938.5 ± 1.0% | 3393.4 ± 1.0% | 512.0 ± 3.3% | 8426.2 ± 1.4% | 1054.5 ± 3.4% | 1.979 | 8.127 | 53.868 | 3.273 | 26.154 |
| hex: http/html-1m | 524290 | 33882.0 ± 0.5% | 14981.3 ± 3.8% | 3477.7 ± 0.8% | 504.7 ± 1.0% | 8844.5 ± 3.0% | 1092.3 ± 3.9% | 2.262 | 9.743 | 67.138 | 3.831 | 31.020 |
| hex: http/json-1kx1024 | 2099200 | 14706.4 ± 1.1% | 12528.1 ± 10.2% | 3149.7 ± 1.7% | 679.8 ± 0.8% | 7548.7 ± 2.5% | 946.7 ± 2.9% | 1.174 | 4.669 | 21.635 | 1.948 | 15.534 |
| hex: http/json-16kx64 | 2097280 | 27598.5 ± 0.5% | 13915.0 ± 0.7% | 3390.7 ± 0.6% | 694.6 ± 0.9% | 8591.2 ± 0.8% | 1079.3 ± 1.6% | 1.983 | 8.139 | 39.731 | 3.212 | 25.570 |
| hex: http/json-1m | 524290 | 33766.7 ± 0.7% | 13089.0 ± 1.9% | 3521.0 ± 0.3% | 709.4 ± 1.0% | 8860.8 ± 0.9% | 1099.4 ± 3.8% | 2.580 | 9.590 | 47.601 | 3.811 | 30.715 |
| hex: http/js-1kx1024 | 2099200 | 15007.4 ± 0.6% | 12175.8 ± 1.3% | 3146.7 ± 0.2% | 487.9 ± 0.7% | 7564.8 ± 1.6% | 961.5 ± 3.5% | 1.233 | 4.769 | 30.760 | 1.984 | 15.608 |
| hex: http/js-16kx64 | 2097280 | 27788.8 ± 0.7% | 13717.1 ± 0.7% | 3396.6 ± 0.7% | 495.4 ± 1.1% | 8619.0 ± 0.4% | 1075.9 ± 4.2% | 2.026 | 8.181 | 56.092 | 3.224 | 25.829 |
| hex: http/js-1m | 524290 | 33767.6 ± 0.7% | 14300.4 ± 1.2% | 3555.1 ± 0.7% | 513.1 ± 2.6% | 8884.9 ± 0.9% | 1106.3 ± 4.0% | 2.361 | 9.498 | 65.807 | 3.801 | 30.522 |
| hex: http/css-1kx1024 | 2099200 | 14825.7 ± 0.9% | 12559.1 ± 1.0% | 3149.9 ± 1.1% | 568.1 ± 1.1% | 7545.8 ± 3.4% | 975.2 ± 2.4% | 1.180 | 4.707 | 26.097 | 1.965 | 15.203 |
| hex: http/css-16kx64 | 2097280 | 27305.6 ± 0.9% | 13827.3 ± 1.6% | 3378.8 ± 0.8% | 579.3 ± 1.2% | 7927.4 ± 2.5% | 1064.9 ± 3.2% | 1.975 | 8.081 | 47.136 | 3.444 | 25.642 |
| hex: http/css-1m | 524290 | 33842.2 ± 1.1% | 14997.8 ± 1.2% | 3537.4 ± 1.0% | 556.8 ± 0.9% | 8883.4 ± 0.7% | 1123.4 ± 2.9% | 2.256 | 9.567 | 60.778 | 3.810 | 30.126 |
| hex: shuffled/dickens-1m | 524290 | 33798.6 ± 1.2% | 14998.2 ± 0.7% | 3471.5 ± 0.7% | 477.2 ± 0.7% | 8857.9 ± 0.6% | 1123.9 ± 0.8% | 2.254 | 9.736 | 70.828 | 3.816 | 30.071 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1586.7 ± 0.8% | 1473.4 ± 1.0% | 1025.2 ± 1.0% | 478.4 ± 0.7% | 467.6 ± 3.3% | 501.5 ± 0.7% | 1.077 | 1.548 | 3.317 | 3.394 | 3.164 |
| qlog records, JSON text sequence | 1467503 | 1449.5 ± 0.6% | 1243.2 ± 4.1% | 945.3 ± 2.5% | 452.7 ± 0.9% | 569.0 ± 0.8% | 352.6 ± 1.0% | 1.166 | 1.533 | 3.202 | 2.547 | 4.111 |
| string: silesia/dickens | 172528 | 12544.9 ± 0.6% | 3916.3 ± 1.5% | 3052.8 ± 0.9% | 357.5 ± 1.4% | 1701.0 ± 0.7% | 1179.7 ± 0.4% | 3.203 | 4.109 | 35.094 | 7.375 | 10.634 |
| string: silesia/nci | 1075110 | 11471.4 ± 1.2% | 4640.1 ± 1.5% | 3098.4 ± 3.5% | 855.8 ± 4.7% | 1904.1 ± 3.6% | 1189.0 ± 5.1% | 2.472 | 3.702 | 13.404 | 6.025 | 9.648 |
| string: silesia/reymont | 1075159 | 5371.7 ± 0.8% | 1849.8 ± 1.5% | 1877.9 ± 1.1% | 391.1 ± 0.9% | 1440.7 ± 0.5% | 1038.8 ± 0.7% | 2.904 | 2.861 | 13.733 | 3.728 | 5.171 |
| string: silesia/samba | 97582 | 6573.8 ± 0.7% | 2705.8 ± 1.2% | 4072.8 ± 0.5% | 381.5 ± 0.7% | 1321.0 ± 0.9% | 1160.0 ± 1.5% | 2.429 | 1.614 | 17.231 | 4.976 | 5.667 |
| string: silesia/webster | 1098490 | 6729.9 ± 0.6% | 1962.7 ± 0.4% | 1747.7 ± 1.7% | 385.6 ± 0.4% | 1407.8 ± 0.7% | 602.2 ± 0.8% | 3.429 | 3.851 | 17.451 | 4.781 | 11.176 |
| string: silesia/xml | 1090118 | 10183.6 ± 0.5% | 3207.6 ± 2.2% | 2513.8 ± 1.0% | 628.0 ± 1.0% | 1941.1 ± 0.9% | 977.5 ± 0.3% | 3.175 | 4.051 | 16.215 | 5.246 | 10.418 |
| string: canterbury/alice29.txt | 159425 | 11023.2 ± 0.6% | 2844.9 ± 2.0% | 3027.7 ± 1.2% | 341.6 ± 0.7% | 1531.7 ± 1.4% | 1092.1 ± 4.7% | 3.875 | 3.641 | 32.268 | 7.197 | 10.093 |
| string: canterbury/asyoulik.txt | 132198 | 11092.9 ± 2.2% | 2105.7 ± 3.2% | 3104.6 ± 1.5% | 351.0 ± 1.1% | 1364.8 ± 1.7% | 951.8 ± 1.3% | 5.268 | 3.573 | 31.600 | 8.128 | 11.655 |
| string: canterbury/lcet10.txt | 441884 | 10892.8 ± 0.7% | 3031.2 ± 0.9% | 2564.1 ± 1.1% | 385.6 ± 1.2% | 1656.7 ± 1.3% | 1195.7 ± 0.9% | 3.594 | 4.248 | 28.250 | 6.575 | 9.110 |
| string: canterbury/plrabn12.txt | 503330 | 8552.0 ± 4.9% | 2302.7 ± 0.7% | 2092.2 ± 0.7% | 364.4 ± 0.7% | 1625.8 ± 0.3% | 1117.2 ± 1.9% | 3.714 | 4.088 | 23.469 | 5.260 | 7.655 |
| string: canterbury-large/E.coli | 1048578 | 31215.0 ± 0.9% | 16582.6 ± 0.7% | 3485.7 ± 0.9% | 1696.9 ± 0.6% | 3162.2 ± 0.8% | 1415.6 ± 1.1% | 1.882 | 8.955 | 18.396 | 9.871 | 22.051 |
| string: canterbury-large/bible.txt | 1055886 | 8968.2 ± 0.2% | 4914.2 ± 0.8% | 3000.8 ± 1.3% | 420.7 ± 0.9% | 2224.8 ± 0.7% | 1486.1 ± 0.7% | 1.825 | 2.989 | 21.318 | 4.031 | 6.035 |
| string: canterbury-large/world192.txt | 1103121 | 6478.8 ± 0.2% | 1734.5 ± 1.1% | 1883.5 ± 1.4% | 389.1 ± 0.9% | 1400.5 ± 0.9% | 960.7 ± 1.3% | 3.735 | 3.440 | 16.651 | 4.626 | 6.744 |
| string: http/html-1m | 1058582 | 10045.7 ± 1.2% | 4390.5 ± 1.5% | 2865.8 ± 0.5% | 457.4 ± 0.7% | 2160.4 ± 3.9% | 849.8 ± 1.2% | 2.288 | 3.505 | 21.965 | 4.650 | 11.821 |
| string: http/json-1m | 1190272 | 8487.1 ± 4.8% | 1579.8 ± 2.6% | 1576.8 ± 2.2% | 540.0 ± 1.5% | 1157.4 ± 3.2% | 845.4 ± 1.6% | 5.372 | 5.383 | 15.718 | 7.333 | 10.039 |
| string: http/js-1m | 1144362 | 6487.9 ± 0.7% | 1116.2 ± 1.1% | 1373.9 ± 1.0% | 361.8 ± 0.8% | 1124.9 ± 1.6% | 756.5 ± 0.6% | 5.813 | 4.722 | 17.933 | 5.768 | 8.576 |
| string: http/css-1m | 1097820 | 8347.3 ± 0.5% | 1477.7 ± 2.9% | 2287.5 ± 1.3% | 545.5 ± 0.8% | 1260.9 ± 0.4% | 878.1 ± 1.2% | 5.649 | 3.649 | 15.302 | 6.620 | 9.506 |
| string: dickens as Cyrillic and CJK | 1883069 | 5587.5 ± 0.4% | 3683.9 ± 1.4% | 488.7 ± 0.6% | 251.6 ± 0.9% | 466.3 ± 3.9% | 356.8 ± 0.6% | 1.517 | 11.434 | 22.204 | 11.983 | 15.660 |
| hex: silesia/dickens | 524290 | 43654.5 ± 0.8% | 2601.6 ± 0.5% | 1508.1 ± 0.4% | 468.7 ± 0.7% | 1571.4 ± 0.7% | 1061.6 ± 0.4% | 16.780 | 28.947 | 93.145 | 27.781 | 41.122 |
| hex: silesia/mozilla | 524290 | 43278.7 ± 0.7% | 2589.2 ± 2.7% | 1504.2 ± 1.1% | 412.7 ± 0.7% | 1562.5 ± 0.8% | 1062.4 ± 2.1% | 16.715 | 28.772 | 104.858 | 27.698 | 40.737 |
| hex: silesia/mr | 524290 | 43717.6 ± 0.5% | 2593.3 ± 0.6% | 1505.4 ± 0.3% | 605.5 ± 0.4% | 1549.9 ± 0.5% | 1067.0 ± 0.5% | 16.858 | 29.041 | 72.198 | 28.206 | 40.971 |
| hex: silesia/nci | 524290 | 43433.6 ± 2.2% | 2576.1 ± 1.1% | 1498.4 ± 0.5% | 750.9 ± 0.5% | 1560.8 ± 0.7% | 1064.2 ± 0.7% | 16.860 | 28.986 | 57.839 | 27.828 | 40.813 |
| hex: silesia/ooffice | 524290 | 42698.1 ± 2.2% | 2594.7 ± 0.6% | 1504.8 ± 0.8% | 341.5 ± 0.6% | 1558.0 ± 0.8% | 1068.9 ± 1.0% | 16.456 | 28.375 | 125.035 | 27.406 | 39.945 |
| hex: silesia/osdb | 524290 | 43594.5 ± 1.5% | 2590.5 ± 0.9% | 1508.0 ± 0.4% | 450.5 ± 0.2% | 1571.5 ± 0.9% | 1063.6 ± 0.6% | 16.829 | 28.909 | 96.765 | 27.741 | 40.987 |
| hex: silesia/reymont | 524290 | 43199.8 ± 1.4% | 2576.2 ± 1.1% | 1496.3 ± 3.6% | 485.2 ± 1.0% | 1549.0 ± 0.3% | 1060.4 ± 1.1% | 16.769 | 28.870 | 89.040 | 27.888 | 40.738 |
| hex: silesia/samba | 524290 | 43237.0 ± 1.4% | 2593.9 ± 1.1% | 1499.2 ± 0.5% | 361.4 ± 0.4% | 1572.1 ± 0.3% | 1062.1 ± 0.8% | 16.669 | 28.841 | 119.652 | 27.503 | 40.710 |
| hex: silesia/sao | 524290 | 42552.6 ± 1.5% | 2602.2 ± 0.8% | 1505.7 ± 0.9% | 277.4 ± 1.2% | 1558.4 ± 0.7% | 1066.3 ± 0.4% | 16.352 | 28.261 | 153.407 | 27.305 | 39.907 |
| hex: silesia/webster | 524290 | 43755.8 ± 0.5% | 2605.9 ± 0.6% | 1510.3 ± 0.4% | 436.7 ± 0.8% | 1577.2 ± 0.6% | 1070.2 ± 0.6% | 16.791 | 28.972 | 100.191 | 27.743 | 40.887 |
| hex: silesia/x-ray | 524290 | 43296.9 ± 2.2% | 2600.4 ± 0.6% | 1508.1 ± 0.4% | 425.5 ± 0.8% | 1552.5 ± 1.1% | 1066.0 ± 0.7% | 16.650 | 28.710 | 101.750 | 27.889 | 40.615 |
| hex: silesia/xml | 524290 | 43437.4 ± 2.9% | 2585.4 ± 0.8% | 1502.7 ± 1.2% | 711.0 ± 1.7% | 1566.1 ± 0.8% | 1066.0 ± 0.8% | 16.801 | 28.907 | 61.091 | 27.735 | 40.747 |
| hex: canterbury/alice29.txt | 304180 | 43284.3 ± 2.2% | 2611.4 ± 0.7% | 1513.1 ± 1.1% | 474.0 ± 0.4% | 1586.2 ± 0.4% | 1081.1 ± 0.7% | 16.575 | 28.607 | 91.319 | 27.288 | 40.037 |
| hex: canterbury/asyoulik.txt | 250360 | 42974.9 ± 1.1% | 2605.9 ± 0.6% | 1529.7 ± 0.8% | 459.8 ± 0.7% | 1580.9 ± 0.3% | 1080.2 ± 0.7% | 16.491 | 28.093 | 93.457 | 27.183 | 39.785 |
| hex: canterbury/cp.html | 49208 | 41698.7 ± 1.3% | 2582.2 ± 6.3% | 1515.4 ± 1.2% | 484.1 ± 1.1% | 1585.0 ± 1.0% | 1085.9 ± 1.4% | 16.149 | 27.516 | 86.140 | 26.308 | 38.399 |
| hex: canterbury/fields.c | 22302 | 41420.1 ± 2.3% | 2649.3 ± 7.2% | 1520.8 ± 3.4% | 609.3 ± 0.6% | 1601.5 ± 0.9% | 1093.0 ± 0.6% | 15.634 | 27.235 | 67.983 | 25.864 | 37.896 |
| hex: canterbury/grammar.lsp | 7444 | 40218.8 ± 0.5% | 2671.6 ± 1.4% | 1530.6 ± 0.7% | 794.8 ± 0.6% | 1598.3 ± 0.4% | 1099.7 ± 0.7% | 15.054 | 26.276 | 50.601 | 25.163 | 36.572 |
| hex: canterbury/kennedy.xls | 524290 | 41754.3 ± 0.8% | 2587.7 ± 0.5% | 1499.3 ± 0.3% | 743.7 ± 0.9% | 1544.3 ± 0.4% | 1062.8 ± 0.7% | 16.135 | 27.849 | 56.144 | 27.038 | 39.287 |
| hex: canterbury/lcet10.txt | 524290 | 43428.0 ± 0.9% | 2586.7 ± 2.0% | 1500.7 ± 0.4% | 472.5 ± 0.8% | 1556.8 ± 0.2% | 1059.0 ± 0.4% | 16.789 | 28.939 | 91.918 | 27.896 | 41.007 |
| hex: canterbury/plrabn12.txt | 524290 | 43257.5 ± 1.2% | 2584.6 ± 0.5% | 1502.7 ± 0.4% | 456.8 ± 0.7% | 1550.8 ± 0.6% | 1062.6 ± 0.8% | 16.736 | 28.786 | 94.687 | 27.894 | 40.711 |
| hex: canterbury/ptt5 | 524290 | 43367.5 ± 1.2% | 2569.4 ± 9.5% | 1494.5 ± 0.6% | 607.6 ± 0.9% | 1554.7 ± 0.3% | 1058.3 ± 0.6% | 16.878 | 29.017 | 71.374 | 27.895 | 40.977 |
| hex: canterbury/sum | 76482 | 42489.9 ± 1.9% | 2571.8 ± 0.6% | 1509.3 ± 0.9% | 582.8 ± 0.4% | 1572.8 ± 0.4% | 1084.1 ± 0.4% | 16.521 | 28.153 | 72.901 | 27.015 | 39.195 |
| hex: canterbury/xargs.1 | 8456 | 40626.0 ± 3.9% | 2674.1 ± 0.6% | 1531.9 ± 0.4% | 823.1 ± 2.8% | 1602.9 ± 2.2% | 1103.7 ± 2.9% | 15.192 | 26.520 | 49.359 | 25.345 | 36.810 |
| hex: canterbury-large/E.coli | 524290 | 43572.5 ± 0.4% | 2594.7 ± 0.4% | 1506.0 ± 0.8% | 808.7 ± 1.2% | 1551.1 ± 0.3% | 1065.7 ± 5.2% | 16.793 | 28.932 | 53.878 | 28.091 | 40.887 |
| hex: canterbury-large/bible.txt | 524290 | 43274.8 ± 3.0% | 2577.8 ± 1.0% | 1498.6 ± 1.0% | 485.5 ± 1.0% | 1562.9 ± 0.7% | 1062.1 ± 1.1% | 16.788 | 28.877 | 89.138 | 27.689 | 40.746 |
| hex: canterbury-large/world192.txt | 524290 | 38950.6 ± 1.4% | 2584.8 ± 8.1% | 1502.2 ± 1.0% | 461.4 ± 0.9% | 1555.4 ± 6.0% | 1070.4 ± 0.7% | 15.069 | 25.930 | 84.425 | 25.042 | 36.389 |
| hex: http/html-1kx1024 | 2099200 | 20471.2 ± 0.4% | 2391.5 ± 0.5% | 1415.5 ± 0.4% | 498.5 ± 0.8% | 1485.5 ± 1.4% | 1069.2 ± 5.3% | 8.560 | 14.462 | 41.063 | 13.780 | 19.146 |
| hex: http/html-16kx64 | 2097280 | 22156.8 ± 0.3% | 2375.3 ± 1.7% | 1448.2 ± 0.8% | 506.6 ± 1.2% | 1503.3 ± 1.1% | 1080.3 ± 1.2% | 9.328 | 15.299 | 43.732 | 14.739 | 20.509 |
| hex: http/html-1m | 524290 | 40321.9 ± 1.2% | 2590.6 ± 0.8% | 1504.2 ± 0.6% | 494.1 ± 4.1% | 1574.8 ± 0.8% | 1067.9 ± 0.6% | 15.565 | 26.807 | 81.604 | 25.604 | 37.759 |
| hex: http/json-1kx1024 | 2099200 | 20904.4 ± 0.5% | 2372.6 ± 3.6% | 1407.8 ± 1.1% | 682.2 ± 1.2% | 1478.5 ± 1.6% | 1069.9 ± 0.9% | 8.811 | 14.849 | 30.645 | 14.139 | 19.539 |
| hex: http/json-16kx64 | 2097280 | 21545.2 ± 2.9% | 2369.5 ± 1.1% | 1442.3 ± 0.4% | 690.5 ± 0.6% | 1500.6 ± 0.5% | 1079.4 ± 0.5% | 9.093 | 14.939 | 31.200 | 14.357 | 19.961 |
| hex: http/json-1m | 524290 | 43167.4 ± 2.1% | 2569.2 ± 0.5% | 1496.3 ± 0.9% | 720.6 ± 0.9% | 1567.5 ± 0.6% | 1060.5 ± 0.3% | 16.802 | 28.850 | 59.905 | 27.539 | 40.706 |
| hex: http/js-1kx1024 | 2099200 | 20490.1 ± 0.4% | 2394.2 ± 1.4% | 1410.6 ± 0.9% | 487.4 ± 0.9% | 1491.2 ± 0.9% | 1070.1 ± 1.0% | 8.558 | 14.526 | 42.039 | 13.741 | 19.148 |
| hex: http/js-16kx64 | 2097280 | 21819.3 ± 0.4% | 2373.7 ± 0.2% | 1445.1 ± 0.4% | 493.0 ± 0.4% | 1500.0 ± 0.4% | 1075.6 ± 6.0% | 9.192 | 15.098 | 44.257 | 14.546 | 20.286 |
| hex: http/js-1m | 524290 | 42641.3 ± 1.1% | 2592.2 ± 0.8% | 1498.7 ± 0.6% | 503.3 ± 0.9% | 1529.9 ± 0.5% | 1057.8 ± 1.1% | 16.450 | 28.452 | 84.727 | 27.871 | 40.312 |
| hex: http/css-1kx1024 | 2099200 | 20246.8 ± 0.3% | 2395.6 ± 1.1% | 1421.4 ± 0.5% | 560.5 ± 0.8% | 1488.1 ± 0.4% | 1073.2 ± 0.5% | 8.452 | 14.244 | 36.121 | 13.606 | 18.867 |
| hex: http/css-16kx64 | 2097280 | 22385.5 ± 0.4% | 2376.9 ± 1.0% | 1443.0 ± 0.7% | 533.2 ± 0.8% | 1298.3 ± 0.4% | 1079.5 ± 0.4% | 9.418 | 15.513 | 41.982 | 17.242 | 20.737 |
| hex: http/css-1m | 524290 | 43087.7 ± 1.4% | 2580.3 ± 1.2% | 1499.9 ± 0.9% | 542.8 ± 0.6% | 1564.3 ± 6.3% | 1061.1 ± 0.9% | 16.699 | 28.728 | 79.386 | 27.544 | 40.608 |
| hex: shuffled/dickens-1m | 524290 | 43428.1 ± 1.5% | 2586.4 ± 0.7% | 1500.9 ± 0.7% | 463.8 ± 0.5% | 1527.9 ± 2.6% | 1060.9 ± 6.3% | 16.791 | 28.934 | 93.634 | 28.424 | 40.937 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding: stdx runs at 0.933 of simdjson.
- qlog records, JSON text sequence, decoding: stdx runs at 0.884 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.778 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.824 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.901 of yyjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next_items: stdx runs at 0.880 of simdjson.
