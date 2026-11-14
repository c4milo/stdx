# bench-json

| Field | Value |
|---|---|
| Commit | eb9746f |
| Runner label | ubuntu-24.04 |
| Image version | 20261111.370.1 |
| CPU model | INTEL(R) XEON(R) PLATINUM 8573C |
| Virtual CPUs | 4 |
| Kernel | 7.0.0-1017-azure |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/43483803369 |
| Date | 2026-11-13 |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1. The `TextReader.next_items` column is that helper's queued tokens a slice a call (decision 79), over many tokens a call.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | TextReader.next_items | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1058.0 ± 1.4% | 0.490 | 1.030 | 1.075 | 1.080 | 0.411 | 1.082 | 1.079 | 0.372 | 0.843 | 0.959 | 0.106 |
| qlog records, JSON text sequence | 1467503 | 808.4 ± 1.0% | 0.840 | 1.054 | 1.067 | 1.074 | 0.418 | 1.070 | 1.068 | 0.386 | 0.940 | 1.071 | 0.132 |
| string: silesia/dickens | 172528 | 5423.5 ± 0.5% | 0.028 | 0.658 | 1.053 | 1.054 | 0.180 | 1.008 | 1.068 | 0.179 | 0.994 | 1.000 | 0.028 |
| string: silesia/nci | 1075110 | 4030.7 ± 0.4% | 0.037 | 0.752 | 1.121 | 1.135 | 0.293 | 1.116 | 1.133 | 0.293 | 1.002 | 1.003 | 0.037 |
| string: silesia/reymont | 1075159 | 3206.0 ± 3.4% | 0.047 | 0.546 | 0.729 | 0.727 | 0.286 | 0.707 | 0.743 | 0.286 | 0.968 | 0.975 | 0.047 |
| string: silesia/samba | 97582 | 3075.2 ± 0.8% | 0.042 | 0.898 | 1.068 | 1.072 | 0.075 | 0.829 | 1.074 | 0.075 | 1.001 | 0.999 | 0.042 |
| string: silesia/webster | 1098490 | 3471.8 ± 1.7% | 0.042 | 0.648 | 0.978 | 0.984 | 0.202 | 0.923 | 0.982 | 0.202 | 1.000 | 1.003 | 0.042 |
| string: silesia/xml | 1090118 | 4933.4 ± 0.7% | 0.031 | 0.766 | 0.927 | 0.939 | 0.232 | 0.926 | 0.942 | 0.232 | 0.996 | 1.000 | 0.031 |
| string: canterbury/alice29.txt | 159425 | 4521.9 ± 2.3% | 0.033 | 0.738 | 1.065 | 1.133 | 0.170 | 1.057 | 1.167 | 0.169 | 1.008 | 1.014 | 0.033 |
| string: canterbury/asyoulik.txt | 132198 | 3405.7 ± 1.6% | 0.042 | 0.837 | 1.140 | 1.157 | 0.179 | 1.116 | 1.178 | 0.180 | 1.004 | 1.016 | 0.042 |
| string: canterbury/lcet10.txt | 441884 | 5242.1 ± 1.0% | 0.029 | 0.590 | 1.103 | 1.082 | 0.181 | 1.040 | 1.106 | 0.181 | 1.009 | 1.006 | 0.029 |
| string: canterbury/plrabn12.txt | 503330 | 4313.1 ± 0.6% | 0.035 | 0.763 | 0.992 | 0.996 | 0.206 | 0.893 | 1.009 | 0.207 | 1.003 | 1.004 | 0.035 |
| string: canterbury-large/E.coli | 1048578 | 21814.6 ± 0.7% | 0.063 | 1.003 | 0.871 | 1.003 | 0.524 | 1.004 | 1.003 | 0.525 | 1.155 | 1.156 | 0.007 |
| string: canterbury-large/bible.txt | 1055886 | 6920.8 ± 2.8% | 0.023 | 0.599 | 0.840 | 0.838 | 0.357 | 0.862 | 0.836 | 0.355 | 0.984 | 0.993 | 0.023 |
| string: canterbury-large/world192.txt | 1103121 | 3403.3 ± 1.5% | 0.043 | 0.651 | 0.925 | 0.927 | 0.189 | 0.886 | 0.922 | 0.189 | 0.993 | 0.998 | 0.043 |
| string: http/html-1m | 1058582 | 7349.2 ± 1.8% | 0.021 | 0.545 | 0.764 | 0.761 | 0.302 | 0.737 | 0.764 | 0.303 | 0.983 | 1.015 | 0.021 |
| string: http/json-1m | 1190272 | 2835.2 ± 0.5% | 0.047 | 0.359 | 0.424 | 0.424 | 0.121 | 0.437 | 0.424 | 0.121 | 1.003 | 1.005 | 0.047 |
| string: http/js-1m | 1144362 | 2362.6 ± 0.2% | 0.058 | 0.646 | 0.827 | 0.839 | 0.169 | 0.790 | 0.839 | 0.168 | 1.006 | 1.006 | 0.058 |
| string: http/css-1m | 1097820 | 2588.3 ± 0.8% | 0.055 | 0.765 | 0.975 | 0.977 | 0.266 | 0.988 | 0.979 | 0.265 | 1.001 | 1.008 | 0.055 |
| string: dickens as Cyrillic and CJK | 1883069 | 4597.0 ± 0.5% | 0.025 | 0.061 | 0.447 | 0.446 | 0.192 | 0.442 | 0.448 | 0.192 | 0.999 | 1.000 | 0.025 |
| string: dickens as Cyrillic and CJK, as \u escapes | 5075485 | 917.2 ± 1.2% | 0.116 | 0.986 | 0.989 | 0.991 | 0.110 | 0.722 | 0.990 | 0.110 | 1.001 | 0.999 | 0.116 |
| hex: silesia/dickens | 524290 | 31151.0 ± 0.4% | 0.045 | 1.002 | 0.693 | 1.002 | 0.438 | 1.002 | 1.003 | 0.438 | 0.806 | 0.806 | 0.005 |
| hex: silesia/mozilla | 524290 | 31701.9 ± 0.7% | 0.044 | 1.004 | 0.690 | 1.003 | 0.429 | 1.002 | 1.003 | 0.429 | 0.793 | 0.792 | 0.005 |
| hex: silesia/mr | 524290 | 31727.5 ± 0.3% | 0.044 | 1.002 | 0.673 | 1.002 | 0.429 | 1.002 | 1.003 | 0.430 | 0.792 | 0.792 | 0.005 |
| hex: silesia/nci | 524290 | 31258.3 ± 0.7% | 0.045 | 1.002 | 0.693 | 1.001 | 0.434 | 1.001 | 1.001 | 0.434 | 0.801 | 0.804 | 0.005 |
| hex: silesia/ooffice | 524290 | 32457.6 ± 1.4% | 0.043 | 1.001 | 0.667 | 0.999 | 0.419 | 1.001 | 1.002 | 0.420 | 0.773 | 0.774 | 0.005 |
| hex: silesia/osdb | 524290 | 32469.1 ± 0.2% | 0.043 | 1.002 | 0.657 | 1.002 | 0.420 | 1.002 | 1.001 | 0.421 | 0.774 | 0.775 | 0.005 |
| hex: silesia/reymont | 524290 | 30703.6 ± 0.5% | 0.046 | 1.000 | 0.704 | 1.001 | 0.438 | 1.001 | 1.002 | 0.438 | 0.818 | 0.819 | 0.005 |
| hex: silesia/samba | 524290 | 32417.0 ± 1.1% | 0.043 | 1.003 | 0.671 | 1.003 | 0.420 | 1.004 | 1.003 | 0.420 | 0.774 | 0.775 | 0.005 |
| hex: silesia/sao | 524290 | 32352.9 ± 0.7% | 0.043 | 1.001 | 0.668 | 1.001 | 0.417 | 1.000 | 1.000 | 0.417 | 0.776 | 0.776 | 0.005 |
| hex: silesia/webster | 524290 | 30704.1 ± 0.2% | 0.046 | 1.001 | 0.690 | 1.001 | 0.437 | 1.001 | 1.003 | 0.436 | 0.818 | 0.819 | 0.005 |
| hex: silesia/x-ray | 524290 | 31718.3 ± 1.1% | 0.044 | 1.001 | 0.674 | 1.002 | 0.430 | 1.003 | 1.001 | 0.430 | 0.792 | 0.793 | 0.005 |
| hex: silesia/xml | 524290 | 30370.0 ± 1.8% | 0.046 | 1.001 | 0.715 | 1.000 | 0.445 | 1.001 | 1.002 | 0.445 | 0.830 | 0.828 | 0.005 |
| hex: canterbury/alice29.txt | 304180 | 31660.9 ± 0.5% | 0.044 | 1.002 | 0.690 | 1.001 | 0.430 | 1.002 | 1.001 | 0.431 | 0.792 | 0.791 | 0.005 |
| hex: canterbury/asyoulik.txt | 250360 | 31631.0 ± 0.4% | 0.044 | 1.000 | 0.672 | 1.002 | 0.429 | 1.001 | 1.002 | 0.430 | 0.789 | 0.791 | 0.005 |
| hex: canterbury/cp.html | 49208 | 31003.5 ± 0.5% | 0.045 | 1.005 | 0.686 | 1.001 | 0.426 | 1.000 | 1.001 | 0.429 | 0.825 | 0.826 | 0.005 |
| hex: canterbury/fields.c | 22302 | 34189.2 ± 0.5% | 0.041 | 1.003 | 0.615 | 1.000 | 0.415 | 0.997 | 1.000 | 0.425 | 0.750 | 0.748 | 0.005 |
| hex: canterbury/grammar.lsp | 7444 | 31878.4 ± 0.7% | 0.045 | 1.010 | 0.626 | 1.012 | 0.445 | 1.012 | 1.010 | 0.469 | 0.724 | 0.720 | 0.005 |
| hex: canterbury/kennedy.xls | 524290 | 32441.8 ± 1.3% | 0.043 | 1.002 | 0.667 | 0.999 | 0.420 | 1.003 | 1.001 | 0.420 | 0.774 | 0.775 | 0.005 |
| hex: canterbury/lcet10.txt | 524290 | 31596.3 ± 1.6% | 0.045 | 1.000 | 0.686 | 1.001 | 0.432 | 1.000 | 1.001 | 0.432 | 0.797 | 0.795 | 0.005 |
| hex: canterbury/plrabn12.txt | 524290 | 32526.4 ± 0.6% | 0.043 | 1.000 | 0.666 | 1.000 | 0.419 | 1.000 | 1.001 | 0.419 | 0.772 | 0.773 | 0.005 |
| hex: canterbury/ptt5 | 524290 | 32439.4 ± 3.4% | 0.043 | 1.003 | 0.656 | 1.002 | 0.421 | 1.002 | 1.002 | 0.421 | 0.774 | 0.774 | 0.005 |
| hex: canterbury/sum | 76482 | 30831.3 ± 0.6% | 0.045 | 1.000 | 0.684 | 1.002 | 0.432 | 0.999 | 1.001 | 0.433 | 0.797 | 0.798 | 0.005 |
| hex: canterbury/xargs.1 | 8456 | 32716.4 ± 0.9% | 0.043 | 1.002 | 0.605 | 1.003 | 0.438 | 1.006 | 1.001 | 0.459 | 0.718 | 0.714 | 0.005 |
| hex: canterbury-large/E.coli | 524290 | 31468.6 ± 0.9% | 0.045 | 1.007 | 0.686 | 1.006 | 0.432 | 1.006 | 1.007 | 0.432 | 0.799 | 0.799 | 0.005 |
| hex: canterbury-large/bible.txt | 524290 | 32483.2 ± 1.0% | 0.043 | 1.002 | 0.655 | 1.002 | 0.420 | 1.001 | 1.002 | 0.421 | 0.774 | 0.774 | 0.005 |
| hex: canterbury-large/world192.txt | 524290 | 27255.4 ± 1.0% | 0.051 | 1.004 | 0.723 | 1.003 | 0.470 | 1.003 | 1.003 | 0.470 | 0.923 | 0.922 | 0.006 |
| hex: http/html-1kx1024 | 2099200 | 15485.4 ± 1.4% | 0.090 | 1.002 | 0.818 | 1.000 | 0.585 | 1.007 | 0.999 | 0.651 | 0.904 | 0.890 | 0.010 |
| hex: http/html-16kx64 | 2097280 | 25997.6 ± 0.6% | 0.054 | 1.002 | 0.746 | 1.002 | 0.500 | 1.004 | 1.004 | 0.505 | 0.868 | 0.867 | 0.006 |
| hex: http/html-1m | 524290 | 31724.2 ± 0.3% | 0.044 | 1.002 | 0.689 | 1.002 | 0.429 | 1.002 | 1.002 | 0.429 | 0.793 | 0.792 | 0.005 |
| hex: http/json-1kx1024 | 2099200 | 15248.4 ± 3.1% | 0.091 | 1.005 | 0.826 | 1.004 | 0.572 | 1.006 | 0.999 | 0.635 | 0.905 | 0.894 | 0.011 |
| hex: http/json-16kx64 | 2097280 | 26050.3 ± 1.3% | 0.053 | 1.005 | 0.738 | 1.007 | 0.501 | 1.005 | 1.006 | 0.505 | 0.868 | 0.866 | 0.006 |
| hex: http/json-1m | 524290 | 31119.3 ± 0.5% | 0.045 | 1.002 | 0.698 | 1.003 | 0.437 | 1.002 | 1.003 | 0.438 | 0.808 | 0.808 | 0.005 |
| hex: http/js-1kx1024 | 2099200 | 15437.0 ± 0.6% | 0.090 | 1.007 | 0.821 | 1.005 | 0.568 | 1.007 | 1.008 | 0.633 | 0.907 | 0.900 | 0.010 |
| hex: http/js-16kx64 | 2097280 | 25313.8 ± 0.7% | 0.055 | 0.999 | 0.750 | 1.000 | 0.509 | 1.001 | 1.002 | 0.514 | 0.879 | 0.877 | 0.006 |
| hex: http/js-1m | 524290 | 29316.7 ± 0.2% | 0.048 | 1.002 | 0.680 | 1.002 | 0.444 | 1.001 | 1.001 | 0.444 | 0.857 | 0.856 | 0.006 |
| hex: http/css-1kx1024 | 2099200 | 15252.2 ± 0.7% | 0.091 | 0.986 | 0.822 | 1.002 | 0.590 | 1.004 | 1.003 | 0.655 | 0.909 | 0.894 | 0.011 |
| hex: http/css-16kx64 | 2097280 | 25025.3 ± 1.0% | 0.056 | 1.003 | 0.757 | 1.003 | 0.512 | 1.004 | 1.004 | 0.516 | 0.882 | 0.881 | 0.006 |
| hex: http/css-1m | 524290 | 31727.3 ± 0.2% | 0.044 | 1.001 | 0.670 | 1.002 | 0.430 | 1.001 | 1.000 | 0.431 | 0.791 | 0.792 | 0.005 |
| hex: shuffled/dickens-1m | 524290 | 31584.2 ± 2.1% | 0.044 | 1.002 | 0.693 | 1.002 | 0.420 | 1.001 | 1.002 | 0.420 | 0.796 | 0.796 | 0.005 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1392.4 ± 1.6% | 0.387 | 0.973 | 0.964 | 0.997 | 1.000 | 0.257 | 1.001 | 0.446 | 0.879 | 0.099 | 1.016 |
| qlog records, JSON text sequence | 1467503 | 1134.9 ± 1.3% | 0.699 | 0.957 | 0.993 | 1.015 | 0.991 | 0.259 | 0.988 | 0.450 | 0.894 | 0.134 | 1.051 |
| string: silesia/dickens | 172528 | 11124.7 ± 2.6% | 0.015 | 0.488 | 0.324 | 0.478 | 0.495 | 0.103 | 0.502 | 0.993 | 1.014 | 0.015 | 1.039 |
| string: silesia/nci | 1075110 | 8996.3 ± 1.0% | 0.019 | 0.514 | 0.354 | 0.508 | 0.517 | 0.162 | 0.516 | 0.992 | 0.997 | 0.019 | 1.045 |
| string: silesia/reymont | 1075159 | 4104.4 ± 2.2% | 0.041 | 0.559 | 0.436 | 0.511 | 0.559 | 0.266 | 0.557 | 1.004 | 1.012 | 0.042 | 1.044 |
| string: silesia/samba | 97582 | 4682.8 ± 0.7% | 0.046 | 0.899 | 0.740 | 0.906 | 0.899 | 0.121 | 0.902 | 0.999 | 1.003 | 0.046 | 1.106 |
| string: silesia/webster | 1098490 | 5186.1 ± 0.8% | 0.032 | 0.591 | 0.441 | 0.572 | 0.595 | 0.159 | 0.594 | 1.005 | 1.006 | 0.032 | 1.055 |
| string: silesia/xml | 1090118 | 7812.3 ± 0.9% | 0.022 | 0.584 | 0.487 | 0.582 | 0.582 | 0.214 | 0.584 | 1.002 | 1.007 | 0.022 | 1.152 |
| string: canterbury/alice29.txt | 159425 | 9817.1 ± 5.7% | 0.017 | 0.467 | 0.361 | 0.426 | 0.484 | 0.089 | 0.502 | 1.000 | 1.029 | 0.017 | 1.102 |
| string: canterbury/asyoulik.txt | 132198 | 8331.3 ± 10.3% | 0.019 | 0.416 | 0.335 | 0.404 | 0.429 | 0.086 | 0.442 | 0.954 | 1.051 | 0.019 | 1.103 |
| string: canterbury/lcet10.txt | 441884 | 8636.8 ± 2.9% | 0.020 | 0.608 | 0.363 | 0.583 | 0.613 | 0.127 | 0.610 | 1.000 | 1.028 | 0.020 | 1.206 |
| string: canterbury/plrabn12.txt | 503330 | 6397.4 ± 2.2% | 0.027 | 0.649 | 0.531 | 0.657 | 0.647 | 0.164 | 0.649 | 0.996 | 1.005 | 0.026 | 1.158 |
| string: canterbury-large/E.coli | 1048578 | 21997.8 ± 1.3% | 0.063 | 1.001 | 0.999 | 0.842 | 0.976 | 0.524 | 1.003 | 0.999 | 1.003 | 0.008 | 1.002 |
| string: canterbury-large/bible.txt | 1055886 | 7117.7 ± 0.9% | 0.025 | 0.734 | 0.593 | 0.729 | 0.750 | 0.389 | 0.744 | 1.002 | 1.001 | 0.025 | 1.097 |
| string: canterbury-large/world192.txt | 1103121 | 4932.7 ± 0.7% | 0.034 | 0.596 | 0.466 | 0.578 | 0.595 | 0.153 | 0.597 | 1.002 | 1.004 | 0.034 | 1.045 |
| string: http/html-1m | 1058582 | 7626.4 ± 0.4% | 0.023 | 0.641 | 0.550 | 0.602 | 0.642 | 0.322 | 0.645 | 1.001 | 1.002 | 0.023 | 1.018 |
| string: http/json-1m | 1190272 | 7077.4 ± 0.4% | 0.023 | 0.179 | 0.149 | 0.180 | 0.179 | 0.065 | 0.179 | 1.002 | 1.003 | 0.023 | 0.984 |
| string: http/js-1m | 1144362 | 4980.6 ± 0.7% | 0.032 | 0.361 | 0.310 | 0.349 | 0.360 | 0.091 | 0.360 | 1.000 | 1.007 | 0.032 | 1.056 |
| string: http/css-1m | 1097820 | 6666.4 ± 0.5% | 0.024 | 0.372 | 0.306 | 0.359 | 0.371 | 0.127 | 0.371 | 0.996 | 1.002 | 0.024 | 1.264 |
| string: dickens as Cyrillic and CJK | 1883069 | 4274.9 ± 2.4% | 0.030 | 0.462 | 0.066 | 0.460 | 0.461 | 0.203 | 0.464 | 1.005 | 1.009 | 0.030 | 1.021 |
| hex: silesia/dickens | 524290 | 27519.0 ± 0.1% | 1.001 | 0.099 | 1.001 | 0.685 | 1.002 | 1.000 | 1.003 | 1.002 | 1.002 | 0.107 | 1.002 |
| hex: silesia/mozilla | 524290 | 27385.4 ± 1.8% | 1.000 | 0.100 | 1.002 | 0.653 | 1.003 | 0.999 | 1.003 | 1.003 | 1.002 | 0.108 | 1.004 |
| hex: silesia/mr | 524290 | 27528.1 ± 4.0% | 1.002 | 0.099 | 1.002 | 0.665 | 1.003 | 1.000 | 1.002 | 1.001 | 1.002 | 0.107 | 1.001 |
| hex: silesia/nci | 524290 | 31453.8 ± 2.3% | 1.002 | 0.087 | 1.001 | 0.599 | 0.999 | 1.002 | 1.001 | 1.002 | 1.001 | 0.094 | 1.003 |
| hex: silesia/ooffice | 524290 | 27994.4 ± 0.5% | 1.002 | 0.098 | 1.002 | 0.654 | 1.003 | 1.002 | 1.002 | 1.002 | 1.003 | 0.106 | 1.003 |
| hex: silesia/osdb | 524290 | 27808.9 ± 1.6% | 1.001 | 0.098 | 1.001 | 0.677 | 1.001 | 1.001 | 1.002 | 1.002 | 1.001 | 0.106 | 1.002 |
| hex: silesia/reymont | 524290 | 27921.0 ± 4.0% | 1.002 | 0.098 | 1.002 | 0.660 | 1.002 | 1.001 | 1.002 | 1.002 | 1.001 | 0.100 | 1.002 |
| hex: silesia/samba | 524290 | 31530.0 ± 0.2% | 1.001 | 0.087 | 1.002 | 0.578 | 1.000 | 1.001 | 1.000 | 1.001 | 1.003 | 0.092 | 1.002 |
| hex: silesia/sao | 524290 | 27924.1 ± 0.4% | 1.002 | 0.098 | 1.001 | 0.674 | 1.002 | 1.000 | 1.001 | 0.999 | 1.003 | 0.106 | 1.001 |
| hex: silesia/webster | 524290 | 29163.5 ± 0.4% | 1.002 | 0.094 | 1.002 | 0.648 | 1.003 | 1.001 | 1.002 | 1.002 | 1.003 | 0.099 | 1.003 |
| hex: silesia/x-ray | 524290 | 27522.0 ± 0.5% | 1.003 | 0.099 | 1.001 | 0.685 | 1.002 | 1.002 | 1.002 | 1.001 | 1.002 | 0.107 | 1.002 |
| hex: silesia/xml | 524290 | 31482.4 ± 0.5% | 1.002 | 0.087 | 1.001 | 0.594 | 1.003 | 1.000 | 1.001 | 1.001 | 1.003 | 0.094 | 1.004 |
| hex: canterbury/alice29.txt | 304180 | 27856.8 ± 0.2% | 1.001 | 0.098 | 1.000 | 0.676 | 1.001 | 0.998 | 1.002 | 1.001 | 1.002 | 0.104 | 1.000 |
| hex: canterbury/asyoulik.txt | 250360 | 27585.3 ± 0.2% | 1.002 | 0.099 | 1.001 | 0.682 | 1.001 | 1.000 | 1.003 | 1.002 | 1.000 | 0.106 | 1.001 |
| hex: canterbury/cp.html | 49208 | 26905.6 ± 0.2% | 1.002 | 0.102 | 1.000 | 0.673 | 1.002 | 0.997 | 1.001 | 1.004 | 1.009 | 0.109 | 1.003 |
| hex: canterbury/fields.c | 22302 | 30991.6 ± 0.6% | 1.000 | 0.088 | 1.000 | 0.566 | 1.002 | 0.987 | 1.001 | 1.000 | 1.007 | 0.087 | 1.002 |
| hex: canterbury/grammar.lsp | 7444 | 29534.9 ± 1.0% | 1.004 | 0.092 | 1.003 | 0.550 | 1.006 | 0.973 | 1.004 | 1.005 | 1.025 | 0.098 | 1.006 |
| hex: canterbury/kennedy.xls | 524290 | 27830.6 ± 0.4% | 1.002 | 0.098 | 1.002 | 0.671 | 1.002 | 1.001 | 1.002 | 1.001 | 1.002 | 0.106 | 1.002 |
| hex: canterbury/lcet10.txt | 524290 | 31591.3 ± 0.3% | 1.000 | 0.087 | 1.000 | 0.599 | 0.997 | 1.000 | 0.999 | 1.002 | 0.998 | 0.092 | 1.001 |
| hex: canterbury/plrabn12.txt | 524290 | 27558.7 ± 0.3% | 1.001 | 0.099 | 1.002 | 0.686 | 1.002 | 1.000 | 1.002 | 1.001 | 1.000 | 0.104 | 1.001 |
| hex: canterbury/ptt5 | 524290 | 27625.8 ± 2.4% | 1.002 | 0.099 | 1.000 | 0.681 | 1.002 | 1.000 | 1.001 | 1.001 | 1.002 | 0.106 | 1.001 |
| hex: canterbury/sum | 76482 | 27278.9 ± 0.4% | 1.001 | 0.100 | 1.000 | 0.672 | 1.000 | 0.997 | 1.002 | 1.003 | 1.004 | 0.099 | 1.002 |
| hex: canterbury/xargs.1 | 8456 | 29209.8 ± 0.6% | 1.000 | 0.093 | 1.000 | 0.564 | 0.999 | 0.956 | 1.001 | 1.001 | 1.020 | 0.094 | 1.003 |
| hex: canterbury-large/E.coli | 524290 | 27212.8 ± 0.5% | 1.002 | 0.101 | 1.001 | 0.688 | 1.003 | 0.999 | 1.003 | 1.003 | 1.003 | 0.105 | 1.002 |
| hex: canterbury-large/bible.txt | 524290 | 31399.5 ± 1.0% | 1.002 | 0.087 | 1.001 | 0.601 | 1.001 | 1.000 | 0.999 | 1.000 | 1.002 | 0.094 | 1.001 |
| hex: canterbury-large/world192.txt | 524290 | 27968.1 ± 0.8% | 1.002 | 0.098 | 1.001 | 0.668 | 1.001 | 1.000 | 1.001 | 0.999 | 1.002 | 0.106 | 1.001 |
| hex: http/html-1kx1024 | 2099200 | 17537.9 ± 1.0% | 1.007 | 0.150 | 1.007 | 0.889 | 0.979 | 0.971 | 1.007 | 1.003 | 1.016 | 0.153 | 1.011 |
| hex: http/html-16kx64 | 2097280 | 18746.1 ± 1.2% | 1.006 | 0.145 | 1.003 | 0.920 | 1.003 | 0.995 | 1.005 | 1.007 | 1.008 | 0.154 | 1.005 |
| hex: http/html-1m | 524290 | 27125.4 ± 0.5% | 1.002 | 0.101 | 0.998 | 0.673 | 1.002 | 1.001 | 1.001 | 1.002 | 1.002 | 0.106 | 1.003 |
| hex: http/json-1kx1024 | 2099200 | 17474.7 ± 3.5% | 1.004 | 0.150 | 1.006 | 0.887 | 1.005 | 0.964 | 1.005 | 1.007 | 1.005 | 0.156 | 1.008 |
| hex: http/json-16kx64 | 2097280 | 18441.7 ± 0.7% | 1.003 | 0.147 | 1.006 | 0.938 | 1.004 | 0.992 | 1.005 | 1.002 | 1.004 | 0.157 | 1.006 |
| hex: http/json-1m | 524290 | 27890.8 ± 0.4% | 1.001 | 0.098 | 1.001 | 0.673 | 1.001 | 1.001 | 1.001 | 0.999 | 1.001 | 0.105 | 1.003 |
| hex: http/js-1kx1024 | 2099200 | 17728.0 ± 0.6% | 1.006 | 0.148 | 1.003 | 0.878 | 1.003 | 0.972 | 1.003 | 1.008 | 1.014 | 0.152 | 1.004 |
| hex: http/js-16kx64 | 2097280 | 18680.0 ± 0.4% | 1.002 | 0.145 | 1.002 | 0.916 | 1.003 | 0.993 | 1.002 | 1.004 | 1.005 | 0.154 | 1.003 |
| hex: http/js-1m | 524290 | 27960.9 ± 0.3% | 1.002 | 0.098 | 1.002 | 0.645 | 1.001 | 1.000 | 1.003 | 1.002 | 1.000 | 0.103 | 1.003 |
| hex: http/css-1kx1024 | 2099200 | 17815.8 ± 0.2% | 1.006 | 0.148 | 1.003 | 0.870 | 1.003 | 0.959 | 1.003 | 1.010 | 1.011 | 0.152 | 1.006 |
| hex: http/css-16kx64 | 2097280 | 18238.0 ± 0.6% | 1.004 | 0.148 | 1.005 | 0.944 | 1.006 | 0.997 | 1.005 | 1.004 | 1.006 | 0.158 | 1.005 |
| hex: http/css-1m | 524290 | 27910.9 ± 0.4% | 1.001 | 0.098 | 1.003 | 0.677 | 1.000 | 1.001 | 1.002 | 1.002 | 1.003 | 0.106 | 1.001 |
| hex: shuffled/dickens-1m | 524290 | 27918.0 ± 4.0% | 1.002 | 0.098 | 1.002 | 0.657 | 1.001 | 1.000 | 1.002 | 1.002 | 1.002 | 0.102 | 1.001 |

## Losses

Each workload where a claim's path ran slower than the path it replaces by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding: J7 wide vectors off runs at 1.075 of all on.
- CLDR supplemental, 34 texts, decoding: J8 decoder fast path off runs at 1.080 of all on.
- CLDR supplemental, 34 texts, decoding: J12 decoder escape words off runs at 1.082 of all on.
- CLDR supplemental, 34 texts, decoding: J13 decoder escape blocks off runs at 1.079 of all on.
- qlog records, JSON text sequence, decoding: J5 UTF-8 vectors off runs at 1.054 of all on.
- qlog records, JSON text sequence, decoding: J7 wide vectors off runs at 1.067 of all on.
- qlog records, JSON text sequence, decoding: J8 decoder fast path off runs at 1.074 of all on.
- qlog records, JSON text sequence, decoding: J12 decoder escape words off runs at 1.070 of all on.
- qlog records, JSON text sequence, decoding: J13 decoder escape blocks off runs at 1.068 of all on.
- string: silesia/dickens, decoding: J7 wide vectors off runs at 1.053 of all on.
- string: silesia/dickens, decoding: J8 decoder fast path off runs at 1.054 of all on.
- string: silesia/dickens, decoding: J13 decoder escape blocks off runs at 1.068 of all on.
- string: silesia/nci, decoding: J7 wide vectors off runs at 1.121 of all on.
- string: silesia/nci, decoding: J8 decoder fast path off runs at 1.135 of all on.
- string: silesia/nci, decoding: J12 decoder escape words off runs at 1.116 of all on.
- string: silesia/nci, decoding: J13 decoder escape blocks off runs at 1.133 of all on.
- string: silesia/samba, decoding: J7 wide vectors off runs at 1.068 of all on.
- string: silesia/samba, decoding: J8 decoder fast path off runs at 1.072 of all on.
- string: silesia/samba, decoding: J13 decoder escape blocks off runs at 1.074 of all on.
- string: canterbury/alice29.txt, decoding: J8 decoder fast path off runs at 1.133 of all on.
- string: canterbury/alice29.txt, decoding: J12 decoder escape words off runs at 1.057 of all on.
- string: canterbury/alice29.txt, decoding: J13 decoder escape blocks off runs at 1.167 of all on.
- string: canterbury/asyoulik.txt, decoding: J7 wide vectors off runs at 1.140 of all on.
- string: canterbury/asyoulik.txt, decoding: J8 decoder fast path off runs at 1.157 of all on.
- string: canterbury/asyoulik.txt, decoding: J12 decoder escape words off runs at 1.116 of all on.
- string: canterbury/asyoulik.txt, decoding: J13 decoder escape blocks off runs at 1.178 of all on.
- string: canterbury/lcet10.txt, decoding: J7 wide vectors off runs at 1.103 of all on.
- string: canterbury/lcet10.txt, decoding: J8 decoder fast path off runs at 1.082 of all on.
- string: canterbury/lcet10.txt, decoding: J13 decoder escape blocks off runs at 1.106 of all on.

## UTF-8 validation against simdutf

stdx's `is_utf8`, the check the loops apply to every string's octets, run alone over each string workload's octets at the width the host's features pick (16 lanes on aarch64, AVX2's 32 or AVX-512's 64 on x86-64, decision 39), beside simdutf 9.3.3's `validate_utf8` in the same run; on a host with AVX-512, again with AVX2 alone. Each ratio is stdx's throughput over the other's. simdutf picks its kernel at run time. Before timing, every copy of the check and simdutf judged 20000 seeded buffers and each workload, whole and changed, alike.

| Workload | Octets | stdx, MB/s | simdutf, MB/s | stdx / simdutf | stdx with AVX2 alone, MB/s | stdx / stdx with AVX2 alone |
|---|---|---|---|---|---|---|
| string: silesia/dickens | 166668 | 129058.8 ± 0.3% | 85608.9 ± 1.5% | 1.508 | 70712.7 ± 2.2% | 1.825 |
| string: silesia/nci | 1048576 | 129293.9 ± 1.4% | 86092.1 ± 2.1% | 1.502 | 70854.7 ± 6.2% | 1.825 |
| string: silesia/reymont | 1048576 | 129572.3 ± 0.2% | 86102.7 ± 1.8% | 1.505 | 70824.9 ± 2.0% | 1.829 |
| string: silesia/samba | 65546 | 125413.5 ± 0.3% | 85520.4 ± 8.1% | 1.466 | 69710.6 ± 0.4% | 1.799 |
| string: silesia/webster | 1048576 | 129637.0 ± 0.4% | 86101.4 ± 0.3% | 1.506 | 81183.1 ± 16.1% | 1.597 |
| string: silesia/xml | 1048576 | 129543.4 ± 0.9% | 86015.9 ± 4.1% | 1.506 | 70893.8 ± 0.2% | 1.827 |
| string: canterbury/alice29.txt | 152089 | 129247.4 ± 0.7% | 85711.0 ± 0.4% | 1.508 | 70681.5 ± 0.2% | 1.829 |
| string: canterbury/asyoulik.txt | 125179 | 128520.9 ± 0.4% | 85651.3 ± 0.3% | 1.501 | 70663.3 ± 0.2% | 1.819 |
| string: canterbury/lcet10.txt | 426754 | 129857.4 ± 0.9% | 86030.5 ± 2.2% | 1.509 | 70794.6 ± 2.8% | 1.834 |
| string: canterbury/plrabn12.txt | 481861 | 129889.4 ± 2.3% | 86075.9 ± 0.6% | 1.509 | 70642.8 ± 0.3% | 1.839 |
| string: canterbury-large/E.coli | 1048576 | 129399.2 ± 0.8% | 86007.7 ± 0.5% | 1.505 | 70541.1 ± 1.3% | 1.834 |
| string: canterbury-large/bible.txt | 1048576 | 129459.4 ± 0.4% | 86348.2 ± 0.4% | 1.499 | 71293.3 ± 0.2% | 1.816 |
| string: canterbury-large/world192.txt | 1048576 | 129541.4 ± 0.4% | 86123.5 ± 1.8% | 1.504 | 70712.7 ± 0.2% | 1.832 |
| string: http/html-1m | 1048576 | 114854.8 ± 0.4% | 81199.9 ± 0.8% | 1.414 | 65296.1 ± 0.3% | 1.759 |
| string: http/json-1m | 1048576 | 92591.5 ± 1.4% | 75509.2 ± 0.3% | 1.226 | 55893.4 ± 0.3% | 1.657 |
| string: http/js-1m | 1048576 | 127119.9 ± 0.3% | 85422.9 ± 0.4% | 1.488 | 69453.5 ± 0.4% | 1.830 |
| string: http/css-1m | 1048576 | 128727.9 ± 0.5% | 85848.6 ± 1.1% | 1.499 | 69877.0 ± 0.3% | 1.842 |
| string: dickens as Cyrillic and CJK | 1847045 | 18572.7 ± 0.3% | 16467.3 ± 6.1% | 1.128 | 11783.9 ± 0.1% | 1.576 |

## Losses to simdutf

None.

## UTF-8 validation by the buffer's offset from a 64-octet line

| Buffer | Octets | Offset | stdx, MB/s | simdutf, MB/s | stdx / simdutf | stdx with AVX2 alone, MB/s | stdx / stdx with AVX2 alone |
|---|---|---|---|---|---|---|---|
| string: canterbury-large/bible.txt | 1048576 | 0 | 129787.8 ± 0.5% | 86204.7 ± 0.1% | 1.506 | 70673.3 ± 0.1% | 1.836 |
| string: canterbury-large/bible.txt | 1048576 | 1 | 129592.0 ± 0.7% | 86064.9 ± 0.5% | 1.506 | 70904.9 ± 0.1% | 1.828 |
| string: canterbury-large/bible.txt | 1048576 | 8 | 129272.9 ± 0.5% | 86211.1 ± 0.3% | 1.499 | 70832.4 ± 2.2% | 1.825 |
| string: canterbury-large/bible.txt | 1048576 | 16 | 129469.0 ± 2.1% | 86146.2 ± 2.7% | 1.503 | 70961.7 ± 0.3% | 1.824 |
| string: canterbury-large/bible.txt | 1048576 | 32 | 129445.2 ± 1.0% | 86227.1 ± 0.3% | 1.501 | 71033.7 ± 0.1% | 1.822 |
| string: canterbury-large/bible.txt | 1048576 | 48 | 129659.2 ± 0.4% | 86128.0 ± 0.3% | 1.505 | 71235.6 ± 0.6% | 1.820 |
| string: dickens as Cyrillic and CJK | 1048576 | 0 | 18720.3 ± 1.1% | 16846.1 ± 0.3% | 1.111 | 11873.0 ± 0.3% | 1.577 |
| string: dickens as Cyrillic and CJK | 1048576 | 1 | 18687.4 ± 16.5% | 16802.1 ± 0.8% | 1.112 | 11880.0 ± 0.2% | 1.573 |
| string: dickens as Cyrillic and CJK | 1048576 | 8 | 18707.8 ± 0.3% | 16820.1 ± 0.4% | 1.112 | 11870.2 ± 0.2% | 1.576 |
| string: dickens as Cyrillic and CJK | 1048576 | 16 | 18729.9 ± 0.1% | 16795.2 ± 1.1% | 1.115 | 11878.0 ± 0.1% | 1.577 |
| string: dickens as Cyrillic and CJK | 1048576 | 32 | 18736.1 ± 0.2% | 16717.7 ± 1.6% | 1.121 | 11874.3 ± 5.4% | 1.578 |
| string: dickens as Cyrillic and CJK | 1048576 | 48 | 18722.3 ± 1.2% | 16830.6 ± 0.3% | 1.112 | 11877.1 ± 0.2% | 1.576 |

## Against the baselines

stdx with every claim on, timed beside simdjson 5.1.1, yyjson 0.13.0, Zig 0.16.0's std.json, serde_json 1.0.154 and Go's encoding/json/jsontext in the same run. Each ratio is stdx's throughput over the baseline's; below 1, the baseline is faster. stdx is built for the architecture's baseline CPU in ReleaseSafe. Each baseline is built for the same CPU, the C, C++ and Zig ones in ReleaseFast (decision 75), and simdjson picks its kernel at run time. Decoding visits every value; encoding writes each text from its tokens.

## Decoding against the baselines

Octets are the text's. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1058.0 ± 1.4% | 1171.5 ± 3.3% | 828.8 ± 0.5% | 295.6 ± 0.8% | 472.9 ± 2.5% | 275.1 ± 2.3% | 0.903 | 1.276 | 3.579 | 2.237 | 3.845 |
| qlog records, JSON text sequence | 1467503 | 808.4 ± 1.0% | 974.2 ± 0.5% | 837.6 ± 0.5% | 256.9 ± 1.2% | 531.8 ± 1.1% | 243.4 ± 1.4% | 0.830 | 0.965 | 3.147 | 1.520 | 3.321 |
| string: silesia/dickens | 172528 | 5423.5 ± 0.5% | 2549.6 ± 1.5% | 2358.7 ± 2.6% | 230.3 ± 1.2% | 2551.3 ± 1.5% | 462.3 ± 2.5% | 2.127 | 2.299 | 23.554 | 2.126 | 11.732 |
| string: silesia/nci | 1075110 | 4030.7 ± 0.4% | 3049.2 ± 0.1% | 2370.9 ± 0.3% | 521.3 ± 0.5% | 2845.6 ± 0.9% | 510.8 ± 0.9% | 1.322 | 1.700 | 7.731 | 1.416 | 7.891 |
| string: silesia/reymont | 1075159 | 3206.0 ± 3.4% | 2651.5 ± 0.3% | 1485.3 ± 1.1% | 236.0 ± 6.5% | 1620.6 ± 1.7% | 424.7 ± 1.0% | 1.209 | 2.158 | 13.584 | 1.978 | 7.549 |
| string: silesia/samba | 97582 | 3075.2 ± 0.8% | 2809.4 ± 0.7% | 2202.8 ± 1.8% | 248.9 ± 1.0% | 1538.6 ± 1.4% | 328.2 ± 0.7% | 1.095 | 1.396 | 12.357 | 1.999 | 9.370 |
| string: silesia/webster | 1098490 | 3471.8 ± 1.7% | 1885.0 ± 0.6% | 1379.9 ± 0.7% | 229.2 ± 0.9% | 1663.7 ± 0.5% | 388.8 ± 3.3% | 1.842 | 2.516 | 15.144 | 2.087 | 8.929 |
| string: silesia/xml | 1090118 | 4933.4 ± 0.7% | 3929.1 ± 0.4% | 1911.7 ± 0.2% | 374.8 ± 0.9% | 2592.4 ± 0.4% | 467.2 ± 1.0% | 1.256 | 2.581 | 13.162 | 1.903 | 10.560 |
| string: canterbury/alice29.txt | 159425 | 4521.9 ± 2.3% | 2183.0 ± 0.7% | 2336.0 ± 2.2% | 222.9 ± 0.6% | 2372.3 ± 1.0% | 404.9 ± 4.5% | 2.071 | 1.936 | 20.284 | 1.906 | 11.169 |
| string: canterbury/asyoulik.txt | 132198 | 3405.7 ± 1.6% | 1811.7 ± 6.5% | 2175.3 ± 0.7% | 222.4 ± 0.9% | 1884.7 ± 2.3% | 364.4 ± 2.4% | 1.880 | 1.566 | 15.315 | 1.807 | 9.345 |
| string: canterbury/lcet10.txt | 441884 | 5242.1 ± 1.0% | 2422.0 ± 0.9% | 1776.6 ± 2.2% | 254.0 ± 3.8% | 2325.5 ± 0.7% | 445.2 ± 2.4% | 2.164 | 2.951 | 20.637 | 2.254 | 11.775 |
| string: canterbury/plrabn12.txt | 503330 | 4313.1 ± 0.6% | 2422.4 ± 0.6% | 1453.8 ± 2.7% | 236.8 ± 1.4% | 2191.6 ± 0.3% | 404.1 ± 1.2% | 1.780 | 2.967 | 18.210 | 1.968 | 10.673 |
| string: canterbury-large/E.coli | 1048578 | 21814.6 ± 0.7% | 10046.6 ± 0.3% | 2658.3 ± 0.9% | 848.0 ± 0.4% | 6465.1 ± 1.3% | 833.8 ± 2.6% | 2.171 | 8.206 | 25.726 | 3.374 | 26.162 |
| string: canterbury-large/bible.txt | 1055886 | 6920.8 ± 2.8% | 4164.7 ± 2.0% | 2257.1 ± 1.0% | 252.4 ± 2.3% | 3090.1 ± 0.8% | 536.3 ± 0.5% | 1.662 | 3.066 | 27.417 | 2.240 | 12.904 |
| string: canterbury-large/world192.txt | 1103121 | 3403.3 ± 1.5% | 1757.6 ± 0.7% | 1435.6 ± 0.6% | 240.1 ± 1.4% | 1727.5 ± 0.5% | 390.5 ± 1.3% | 1.936 | 2.371 | 14.173 | 1.970 | 8.716 |
| string: http/html-1m | 1058582 | 7349.2 ± 1.8% | 3665.6 ± 0.4% | 2160.7 ± 1.3% | 296.1 ± 1.1% | 2913.8 ± 0.8% | 513.7 ± 0.6% | 2.005 | 3.401 | 24.821 | 2.522 | 14.307 |
| string: http/json-1m | 1190272 | 2835.2 ± 0.5% | 972.7 ± 0.9% | 1697.9 ± 0.2% | 359.6 ± 1.2% | 1067.4 ± 1.5% | 343.1 ± 1.4% | 2.915 | 1.670 | 7.885 | 2.656 | 8.262 |
| string: http/js-1m | 1144362 | 2362.6 ± 0.2% | 1244.6 ± 0.9% | 1059.8 ± 0.3% | 234.0 ± 0.1% | 1112.6 ± 0.5% | 308.5 ± 3.4% | 1.898 | 2.229 | 10.098 | 2.123 | 7.657 |
| string: http/css-1m | 1097820 | 2588.3 ± 0.8% | 2249.1 ± 0.3% | 1558.6 ± 3.5% | 322.5 ± 1.0% | 1646.7 ± 0.4% | 376.0 ± 1.0% | 1.151 | 1.661 | 8.026 | 1.572 | 6.884 |
| string: dickens as Cyrillic and CJK | 1883069 | 4597.0 ± 0.5% | 2851.4 ± 0.2% | 516.3 ± 0.5% | 285.5 ± 0.3% | 393.1 ± 0.7% | 126.6 ± 2.4% | 1.612 | 8.905 | 16.102 | 11.695 | 36.312 |
| string: dickens as Cyrillic and CJK, as \u escapes | 5075485 | 917.2 ± 1.2% | 956.1 ± 0.6% | 851.5 ± 0.6% | 203.7 ± 0.5% | 365.7 ± 0.4% | 171.8 ± 3.5% | 0.959 | 1.077 | 4.503 | 2.508 | 5.338 |
| hex: silesia/dickens | 524290 | 31151.0 ± 0.4% | 11515.6 ± 2.9% | 2694.9 ± 0.4% | 370.5 ± 0.5% | 6439.8 ± 2.5% | 865.0 ± 1.8% | 2.705 | 11.559 | 84.079 | 4.837 | 36.015 |
| hex: silesia/mozilla | 524290 | 31701.9 ± 0.7% | 11594.1 ± 1.9% | 2773.0 ± 0.8% | 315.9 ± 3.8% | 6457.1 ± 0.5% | 863.7 ± 1.0% | 2.734 | 11.432 | 100.345 | 4.910 | 36.707 |
| hex: silesia/mr | 524290 | 31727.5 ± 0.3% | 11615.0 ± 3.8% | 2774.9 ± 0.5% | 479.2 ± 1.8% | 6469.7 ± 4.3% | 867.1 ± 3.2% | 2.732 | 11.434 | 66.211 | 4.904 | 36.590 |
| hex: silesia/nci | 524290 | 31258.3 ± 0.7% | 11515.8 ± 2.1% | 2696.4 ± 2.8% | 594.1 ± 1.9% | 6457.1 ± 0.4% | 856.5 ± 5.0% | 2.714 | 11.592 | 52.611 | 4.841 | 36.496 |
| hex: silesia/ooffice | 524290 | 32457.6 ± 1.4% | 11616.2 ± 0.4% | 2769.1 ± 5.8% | 261.4 ± 1.3% | 6466.9 ± 0.2% | 862.0 ± 1.7% | 2.794 | 11.721 | 124.158 | 5.019 | 37.655 |
| hex: silesia/osdb | 524290 | 32469.1 ± 0.2% | 11621.0 ± 0.8% | 2770.2 ± 0.6% | 355.1 ± 1.2% | 6458.1 ± 0.9% | 859.1 ± 1.3% | 2.794 | 11.721 | 91.446 | 5.028 | 37.793 |
| hex: silesia/reymont | 524290 | 30703.6 ± 0.5% | 11595.8 ± 0.3% | 2699.8 ± 0.6% | 391.1 ± 1.0% | 6459.8 ± 1.1% | 867.8 ± 3.2% | 2.648 | 11.373 | 78.502 | 4.753 | 35.379 |
| hex: silesia/samba | 524290 | 32417.0 ± 1.1% | 11631.4 ± 0.5% | 2768.6 ± 0.3% | 280.9 ± 0.9% | 6459.2 ± 2.8% | 852.3 ± 5.1% | 2.787 | 11.709 | 115.413 | 5.019 | 38.033 |
| hex: silesia/sao | 524290 | 32352.9 ± 0.7% | 11603.7 ± 2.1% | 2689.8 ± 0.2% | 211.2 ± 1.8% | 6455.8 ± 0.4% | 863.0 ± 1.0% | 2.788 | 12.028 | 153.191 | 5.011 | 37.489 |
| hex: silesia/webster | 524290 | 30704.1 ± 0.2% | 11636.0 ± 0.3% | 2769.1 ± 0.5% | 346.4 ± 0.4% | 6455.5 ± 0.3% | 864.8 ± 1.0% | 2.639 | 11.088 | 88.640 | 4.756 | 35.506 |
| hex: silesia/x-ray | 524290 | 31718.3 ± 1.1% | 11636.3 ± 1.1% | 2699.1 ± 0.9% | 325.9 ± 9.0% | 6449.8 ± 0.9% | 865.4 ± 1.7% | 2.726 | 11.751 | 97.335 | 4.918 | 36.652 |
| hex: silesia/xml | 524290 | 30370.0 ± 1.8% | 11602.1 ± 0.9% | 2771.1 ± 1.7% | 577.8 ± 4.0% | 6444.8 ± 1.0% | 863.9 ± 3.4% | 2.618 | 10.959 | 52.561 | 4.712 | 35.154 |
| hex: canterbury/alice29.txt | 304180 | 31660.9 ± 0.5% | 11589.8 ± 0.2% | 2772.8 ± 0.4% | 373.0 ± 1.2% | 6459.0 ± 0.3% | 866.0 ± 3.2% | 2.732 | 11.419 | 84.891 | 4.902 | 36.558 |
| hex: canterbury/asyoulik.txt | 250360 | 31631.0 ± 0.4% | 11701.3 ± 0.4% | 2699.9 ± 0.1% | 366.0 ± 0.6% | 6452.1 ± 0.2% | 864.4 ± 3.2% | 2.703 | 11.716 | 86.434 | 4.902 | 36.594 |
| hex: canterbury/cp.html | 49208 | 31003.5 ± 0.5% | 11792.6 ± 0.6% | 2769.3 ± 0.2% | 388.2 ± 1.5% | 6661.7 ± 0.5% | 836.6 ± 1.2% | 2.629 | 11.195 | 79.863 | 4.654 | 37.060 |
| hex: canterbury/fields.c | 22302 | 34189.2 ± 0.5% | 13011.9 ± 0.4% | 2833.8 ± 0.3% | 476.7 ± 1.1% | 6673.4 ± 0.3% | 814.3 ± 3.0% | 2.628 | 12.065 | 71.722 | 5.123 | 41.984 |
| hex: canterbury/grammar.lsp | 7444 | 31878.4 ± 0.7% | 13798.4 ± 0.6% | 2806.3 ± 0.4% | 605.3 ± 7.9% | 6471.3 ± 0.6% | 778.3 ± 3.1% | 2.310 | 11.360 | 52.665 | 4.926 | 40.957 |
| hex: canterbury/kennedy.xls | 524290 | 32441.8 ± 1.3% | 11656.4 ± 1.5% | 2764.2 ± 0.3% | 595.4 ± 0.6% | 6461.6 ± 0.8% | 830.4 ± 7.1% | 2.783 | 11.736 | 54.485 | 5.021 | 39.067 |
| hex: canterbury/lcet10.txt | 524290 | 31596.3 ± 1.6% | 11619.6 ± 0.8% | 2774.5 ± 5.7% | 373.9 ± 1.3% | 6459.0 ± 0.7% | 837.7 ± 6.1% | 2.719 | 11.388 | 84.503 | 4.892 | 37.720 |
| hex: canterbury/plrabn12.txt | 524290 | 32526.4 ± 0.6% | 11629.4 ± 0.7% | 2772.4 ± 0.4% | 362.9 ± 0.6% | 6452.0 ± 0.6% | 846.8 ± 2.8% | 2.797 | 11.732 | 89.619 | 5.041 | 38.411 |
| hex: canterbury/ptt5 | 524290 | 32439.4 ± 3.4% | 11605.6 ± 1.3% | 2701.7 ± 0.7% | 479.5 ± 1.2% | 6449.8 ± 0.2% | 854.2 ± 2.1% | 2.795 | 12.007 | 67.656 | 5.030 | 37.976 |
| hex: canterbury/sum | 76482 | 30831.3 ± 0.6% | 11528.2 ± 2.9% | 2776.7 ± 0.2% | 427.3 ± 6.0% | 6432.9 ± 0.4% | 846.3 ± 2.0% | 2.674 | 11.103 | 72.155 | 4.793 | 36.431 |
| hex: canterbury/xargs.1 | 8456 | 32716.4 ± 0.9% | 13791.4 ± 2.2% | 2757.2 ± 0.3% | 580.6 ± 5.7% | 6492.8 ± 0.2% | 817.5 ± 3.9% | 2.372 | 11.866 | 56.347 | 5.039 | 40.021 |
| hex: canterbury-large/E.coli | 524290 | 31468.6 ± 0.9% | 11606.3 ± 1.9% | 2699.8 ± 1.7% | 594.4 ± 1.8% | 6463.1 ± 0.4% | 843.2 ± 5.3% | 2.711 | 11.656 | 52.942 | 4.869 | 37.322 |
| hex: canterbury-large/bible.txt | 524290 | 32483.2 ± 1.0% | 11649.5 ± 0.5% | 2699.3 ± 0.6% | 388.9 ± 2.4% | 6461.0 ± 2.1% | 869.7 ± 2.7% | 2.788 | 12.034 | 83.519 | 5.028 | 37.351 |
| hex: canterbury-large/world192.txt | 524290 | 27255.4 ± 1.0% | 11619.7 ± 1.4% | 2770.9 ± 0.2% | 368.2 ± 1.0% | 6492.9 ± 4.6% | 867.5 ± 5.7% | 2.346 | 9.836 | 74.019 | 4.198 | 31.417 |
| hex: http/html-1kx1024 | 2099200 | 15485.4 ± 1.4% | 10310.2 ± 5.3% | 2557.3 ± 1.3% | 385.5 ± 1.4% | 5074.1 ± 2.4% | 698.4 ± 1.2% | 1.502 | 6.055 | 40.169 | 3.052 | 22.172 |
| hex: http/html-16kx64 | 2097280 | 25997.6 ± 0.6% | 11709.6 ± 0.2% | 2638.6 ± 0.5% | 395.3 ± 2.7% | 6269.2 ± 4.7% | 792.1 ± 2.9% | 2.220 | 9.853 | 65.774 | 4.147 | 32.821 |
| hex: http/html-1m | 524290 | 31724.2 ± 0.3% | 11596.7 ± 3.0% | 2698.6 ± 0.2% | 389.4 ± 0.6% | 6449.5 ± 3.7% | 849.2 ± 3.8% | 2.736 | 11.756 | 81.479 | 4.919 | 37.358 |
| hex: http/json-1kx1024 | 2099200 | 15248.4 ± 3.1% | 10124.3 ± 2.9% | 2557.3 ± 0.5% | 561.9 ± 1.2% | 5084.2 ± 5.4% | 707.0 ± 2.1% | 1.506 | 5.963 | 27.136 | 2.999 | 21.567 |
| hex: http/json-16kx64 | 2097280 | 26050.3 ± 1.3% | 11658.0 ± 1.4% | 2642.1 ± 0.2% | 579.8 ± 1.8% | 6227.7 ± 4.1% | 802.3 ± 3.0% | 2.235 | 9.860 | 44.932 | 4.183 | 32.468 |
| hex: http/json-1m | 524290 | 31119.3 ± 0.5% | 11604.8 ± 2.6% | 2751.5 ± 0.2% | 614.2 ± 1.4% | 6463.7 ± 0.4% | 840.3 ± 1.3% | 2.682 | 11.310 | 50.666 | 4.814 | 37.034 |
| hex: http/js-1kx1024 | 2099200 | 15437.0 ± 0.6% | 9825.7 ± 2.8% | 2555.2 ± 0.4% | 378.9 ± 1.0% | 5108.5 ± 6.1% | 696.7 ± 4.5% | 1.571 | 6.041 | 40.737 | 3.022 | 22.159 |
| hex: http/js-16kx64 | 2097280 | 25313.8 ± 0.7% | 11582.0 ± 0.6% | 2633.3 ± 0.8% | 384.7 ± 0.5% | 6117.4 ± 3.6% | 807.3 ± 4.8% | 2.186 | 9.613 | 65.808 | 4.138 | 31.356 |
| hex: http/js-1m | 524290 | 29316.7 ± 0.2% | 11569.3 ± 1.5% | 2770.0 ± 1.9% | 400.2 ± 1.2% | 6457.0 ± 4.2% | 847.5 ± 3.0% | 2.534 | 10.584 | 73.247 | 4.540 | 34.592 |
| hex: http/css-1kx1024 | 2099200 | 15252.2 ± 0.7% | 9977.3 ± 2.6% | 2551.8 ± 0.5% | 436.5 ± 3.0% | 5092.7 ± 4.5% | 694.4 ± 4.2% | 1.529 | 5.977 | 34.939 | 2.995 | 21.964 |
| hex: http/css-16kx64 | 2097280 | 25025.3 ± 1.0% | 11603.3 ± 0.4% | 2634.6 ± 1.4% | 448.3 ± 0.4% | 6123.1 ± 2.1% | 784.5 ± 3.7% | 2.157 | 9.499 | 55.819 | 4.087 | 31.898 |
| hex: http/css-1m | 524290 | 31727.3 ± 0.2% | 11559.0 ± 2.8% | 2744.3 ± 0.5% | 429.9 ± 0.6% | 6470.0 ± 0.6% | 820.9 ± 3.5% | 2.745 | 11.561 | 73.801 | 4.904 | 38.648 |
| hex: shuffled/dickens-1m | 524290 | 31584.2 ± 2.1% | 11574.3 ± 2.1% | 2700.0 ± 0.1% | 371.6 ± 0.6% | 6453.5 ± 0.8% | 843.0 ± 3.6% | 2.729 | 11.698 | 84.999 | 4.894 | 37.467 |

## Encoding against the baselines

Octets are the ones stdx writes. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1392.4 ± 1.6% | 1148.6 ± 0.4% | 781.3 ± 1.2% | 358.8 ± 0.6% | 324.2 ± 0.7% | 378.6 ± 0.7% | 1.212 | 1.782 | 3.881 | 4.295 | 3.678 |
| qlog records, JSON text sequence | 1467503 | 1134.9 ± 1.3% | 982.0 ± 1.2% | 719.7 ± 1.1% | 337.4 ± 0.5% | 362.6 ± 2.0% | 264.0 ± 3.9% | 1.156 | 1.577 | 3.364 | 3.130 | 4.298 |
| string: silesia/dickens | 172528 | 11124.7 ± 2.6% | 2874.0 ± 5.5% | 2471.3 ± 0.9% | 272.3 ± 2.8% | 1194.6 ± 5.7% | 910.0 ± 8.3% | 3.871 | 4.502 | 40.860 | 9.312 | 12.225 |
| string: silesia/nci | 1075110 | 8996.3 ± 1.0% | 3535.1 ± 0.8% | 2385.4 ± 0.2% | 706.6 ± 0.4% | 1259.4 ± 4.8% | 975.9 ± 0.6% | 2.545 | 3.771 | 12.732 | 7.143 | 9.218 |
| string: silesia/reymont | 1075159 | 4104.4 ± 2.2% | 1435.2 ± 1.3% | 1512.9 ± 1.0% | 296.0 ± 0.3% | 991.4 ± 4.1% | 855.6 ± 0.8% | 2.860 | 2.713 | 13.865 | 4.140 | 4.797 |
| string: silesia/samba | 97582 | 4682.8 ± 0.7% | 2082.1 ± 2.1% | 2956.6 ± 2.0% | 288.6 ± 0.7% | 983.7 ± 1.4% | 944.6 ± 2.2% | 2.249 | 1.584 | 16.224 | 4.760 | 4.958 |
| string: silesia/webster | 1098490 | 5186.1 ± 0.8% | 1504.3 ± 1.4% | 1415.8 ± 1.0% | 293.7 ± 0.7% | 917.8 ± 2.5% | 466.2 ± 0.6% | 3.447 | 3.663 | 17.658 | 5.650 | 11.124 |
| string: silesia/xml | 1090118 | 7812.3 ± 0.9% | 2394.8 ± 1.3% | 2002.0 ± 2.3% | 481.4 ± 0.2% | 1246.1 ± 8.9% | 757.0 ± 0.7% | 3.262 | 3.902 | 16.227 | 6.270 | 10.321 |
| string: canterbury/alice29.txt | 159425 | 9817.1 ± 5.7% | 2190.6 ± 4.9% | 2337.0 ± 0.8% | 261.2 ± 1.7% | 1021.5 ± 5.1% | 835.4 ± 3.5% | 4.481 | 4.201 | 37.579 | 9.611 | 11.751 |
| string: canterbury/asyoulik.txt | 132198 | 8331.3 ± 10.3% | 1627.9 ± 2.3% | 2385.6 ± 0.3% | 266.4 ± 0.6% | 881.5 ± 4.3% | 742.3 ± 1.3% | 5.118 | 3.492 | 31.279 | 9.451 | 11.224 |
| string: canterbury/lcet10.txt | 441884 | 8636.8 ± 2.9% | 2269.4 ± 5.6% | 2075.5 ± 1.6% | 294.5 ± 0.7% | 1093.7 ± 3.3% | 909.5 ± 1.0% | 3.806 | 4.161 | 29.329 | 7.897 | 9.496 |
| string: canterbury/plrabn12.txt | 503330 | 6397.4 ± 2.2% | 1706.2 ± 1.5% | 1639.0 ± 1.7% | 276.7 ± 0.7% | 953.6 ± 1.6% | 794.2 ± 2.5% | 3.750 | 3.903 | 23.124 | 6.709 | 8.055 |
| string: canterbury-large/E.coli | 1048578 | 21997.8 ± 1.3% | 10902.2 ± 0.2% | 2784.5 ± 0.3% | 1315.7 ± 0.6% | 1430.9 ± 11.5% | 1086.4 ± 2.4% | 2.018 | 7.900 | 16.720 | 15.373 | 20.248 |
| string: canterbury-large/bible.txt | 1055886 | 7117.7 ± 0.9% | 3667.6 ± 1.3% | 2405.4 ± 0.7% | 320.4 ± 1.7% | 1469.2 ± 6.5% | 1099.5 ± 1.6% | 1.941 | 2.959 | 22.218 | 4.845 | 6.474 |
| string: canterbury-large/world192.txt | 1103121 | 4932.7 ± 0.7% | 1320.3 ± 2.8% | 1484.4 ± 5.1% | 293.3 ± 1.2% | 919.6 ± 1.2% | 773.8 ± 0.5% | 3.736 | 3.323 | 16.821 | 5.364 | 6.375 |
| string: http/html-1m | 1058582 | 7626.4 ± 0.4% | 3360.1 ± 0.9% | 2339.3 ± 0.7% | 329.1 ± 2.2% | 1378.6 ± 3.2% | 653.6 ± 1.8% | 2.270 | 3.260 | 23.173 | 5.532 | 11.668 |
| string: http/json-1m | 1190272 | 7077.4 ± 0.4% | 1184.5 ± 1.7% | 1262.6 ± 4.0% | 394.4 ± 4.1% | 779.6 ± 1.2% | 660.8 ± 1.8% | 5.975 | 5.606 | 17.945 | 9.078 | 10.710 |
| string: http/js-1m | 1144362 | 4980.6 ± 0.7% | 860.2 ± 1.0% | 1096.0 ± 0.5% | 260.8 ± 1.9% | 761.0 ± 2.9% | 600.4 ± 1.2% | 5.790 | 4.544 | 19.094 | 6.545 | 8.296 |
| string: http/css-1m | 1097820 | 6666.4 ± 0.5% | 1112.6 ± 0.8% | 1620.1 ± 3.7% | 371.1 ± 1.7% | 908.5 ± 1.0% | 756.8 ± 0.9% | 5.992 | 4.115 | 17.965 | 7.338 | 8.809 |
| string: dickens as Cyrillic and CJK | 1883069 | 4274.9 ± 2.4% | 2862.2 ± 0.8% | 360.3 ± 1.0% | 192.1 ± 0.6% | 343.9 ± 4.1% | 277.3 ± 0.2% | 1.494 | 11.866 | 22.255 | 12.429 | 15.416 |
| hex: silesia/dickens | 524290 | 27519.0 ± 0.1% | 1887.4 ± 2.7% | 1179.7 ± 0.5% | 350.6 ± 0.7% | 911.6 ± 2.5% | 821.1 ± 1.9% | 14.581 | 23.327 | 78.499 | 30.187 | 33.516 |
| hex: silesia/mozilla | 524290 | 27385.4 ± 1.8% | 1935.5 ± 2.6% | 1179.5 ± 8.0% | 310.3 ± 5.3% | 913.4 ± 5.0% | 819.9 ± 1.9% | 14.149 | 23.217 | 88.245 | 29.980 | 33.402 |
| hex: silesia/mr | 524290 | 27528.1 ± 4.0% | 1821.2 ± 2.9% | 1176.3 ± 1.7% | 453.4 ± 0.4% | 914.8 ± 2.3% | 821.3 ± 1.6% | 15.115 | 23.403 | 60.712 | 30.094 | 33.518 |
| hex: silesia/nci | 524290 | 31453.8 ± 2.3% | 1910.5 ± 5.7% | 1175.0 ± 0.9% | 596.3 ± 0.3% | 895.4 ± 4.3% | 820.1 ± 0.8% | 16.464 | 26.770 | 52.748 | 35.129 | 38.353 |
| hex: silesia/ooffice | 524290 | 27994.4 ± 0.5% | 1929.4 ± 2.2% | 1180.7 ± 0.3% | 257.1 ± 0.8% | 907.5 ± 2.2% | 820.6 ± 1.1% | 14.509 | 23.710 | 108.877 | 30.849 | 34.114 |
| hex: silesia/osdb | 524290 | 27808.9 ± 1.6% | 1914.6 ± 1.2% | 1178.4 ± 1.1% | 343.4 ± 1.0% | 922.4 ± 4.1% | 820.8 ± 1.3% | 14.525 | 23.599 | 80.971 | 30.148 | 33.879 |
| hex: silesia/reymont | 524290 | 27921.0 ± 4.0% | 1914.7 ± 1.7% | 1179.3 ± 1.5% | 371.8 ± 0.5% | 915.0 ± 3.2% | 823.6 ± 1.1% | 14.583 | 23.676 | 75.093 | 30.514 | 33.903 |
| hex: silesia/samba | 524290 | 31530.0 ± 0.2% | 1921.4 ± 5.7% | 1179.8 ± 1.0% | 273.9 ± 0.7% | 902.9 ± 2.8% | 817.1 ± 1.8% | 16.410 | 26.724 | 115.113 | 34.921 | 38.588 |
| hex: silesia/sao | 524290 | 27924.1 ± 0.4% | 1860.9 ± 6.5% | 1180.3 ± 6.1% | 210.5 ± 0.4% | 902.9 ± 1.5% | 810.9 ± 3.5% | 15.005 | 23.659 | 132.644 | 30.929 | 34.438 |
| hex: silesia/webster | 524290 | 29163.5 ± 0.4% | 1894.6 ± 2.1% | 1179.4 ± 0.8% | 326.2 ± 2.1% | 921.5 ± 2.0% | 820.6 ± 1.6% | 15.393 | 24.727 | 89.405 | 31.647 | 35.540 |
| hex: silesia/x-ray | 524290 | 27522.0 ± 0.5% | 1864.5 ± 6.4% | 1178.9 ± 2.1% | 320.7 ± 1.3% | 925.2 ± 3.7% | 822.0 ± 4.4% | 14.761 | 23.345 | 85.831 | 29.746 | 33.482 |
| hex: silesia/xml | 524290 | 31482.4 ± 0.5% | 1942.9 ± 4.0% | 1180.9 ± 0.6% | 534.7 ± 0.9% | 897.6 ± 1.3% | 816.5 ± 3.2% | 16.204 | 26.660 | 58.882 | 35.074 | 38.557 |
| hex: canterbury/alice29.txt | 304180 | 27856.8 ± 0.2% | 1903.4 ± 8.2% | 1195.7 ± 0.7% | 355.8 ± 4.4% | 939.1 ± 2.2% | 833.7 ± 0.9% | 14.636 | 23.297 | 78.304 | 29.664 | 33.412 |
| hex: canterbury/asyoulik.txt | 250360 | 27585.3 ± 0.2% | 1982.3 ± 9.2% | 1210.3 ± 0.3% | 345.9 ± 0.5% | 909.1 ± 3.4% | 830.1 ± 2.9% | 13.916 | 22.792 | 79.760 | 30.345 | 33.230 |
| hex: canterbury/cp.html | 49208 | 26905.6 ± 0.2% | 1836.4 ± 8.8% | 1197.1 ± 2.1% | 357.5 ± 0.3% | 1050.4 ± 12.3% | 829.2 ± 1.8% | 14.652 | 22.476 | 75.267 | 25.616 | 32.446 |
| hex: canterbury/fields.c | 22302 | 30991.6 ± 0.6% | 1924.3 ± 9.0% | 1199.2 ± 0.6% | 548.3 ± 1.3% | 1006.9 ± 6.7% | 835.4 ± 1.2% | 16.106 | 25.844 | 56.518 | 30.780 | 37.099 |
| hex: canterbury/grammar.lsp | 7444 | 29534.9 ± 1.0% | 1881.8 ± 5.5% | 1209.4 ± 0.4% | 621.7 ± 7.1% | 959.5 ± 11.9% | 837.3 ± 1.8% | 15.695 | 24.422 | 47.507 | 30.783 | 35.273 |
| hex: canterbury/kennedy.xls | 524290 | 27830.6 ± 0.4% | 1826.0 ± 1.7% | 1177.7 ± 0.7% | 588.7 ± 0.5% | 896.3 ± 1.9% | 823.0 ± 3.0% | 15.241 | 23.632 | 47.271 | 31.052 | 33.815 |
| hex: canterbury/lcet10.txt | 524290 | 31591.3 ± 0.3% | 1894.4 ± 2.5% | 1182.8 ± 0.2% | 355.7 ± 2.4% | 883.6 ± 2.4% | 817.9 ± 0.4% | 16.676 | 26.709 | 88.808 | 35.753 | 38.626 |
| hex: canterbury/plrabn12.txt | 524290 | 27558.7 ± 0.3% | 1935.6 ± 4.2% | 1177.6 ± 0.8% | 344.4 ± 0.6% | 912.0 ± 2.0% | 816.0 ± 5.4% | 14.237 | 23.403 | 80.018 | 30.219 | 33.771 |
| hex: canterbury/ptt5 | 524290 | 27625.8 ± 2.4% | 1894.1 ± 4.9% | 1176.5 ± 0.4% | 456.8 ± 0.3% | 900.9 ± 4.6% | 818.2 ± 2.2% | 14.585 | 23.481 | 60.471 | 30.665 | 33.765 |
| hex: canterbury/sum | 76482 | 27278.9 ± 0.4% | 1900.3 ± 5.0% | 1182.9 ± 1.3% | 436.8 ± 0.4% | 1011.0 ± 5.8% | 837.6 ± 1.7% | 14.355 | 23.060 | 62.454 | 26.982 | 32.569 |
| hex: canterbury/xargs.1 | 8456 | 29209.8 ± 0.6% | 1891.4 ± 9.9% | 1208.8 ± 6.6% | 624.5 ± 0.7% | 917.9 ± 16.4% | 843.7 ± 0.7% | 15.443 | 24.165 | 46.773 | 31.823 | 34.623 |
| hex: canterbury-large/E.coli | 524290 | 27212.8 ± 0.5% | 1878.0 ± 5.0% | 1179.0 ± 0.7% | 608.0 ± 1.4% | 917.2 ± 3.1% | 817.6 ± 2.0% | 14.490 | 23.082 | 44.761 | 29.671 | 33.282 |
| hex: canterbury-large/bible.txt | 524290 | 31399.5 ± 1.0% | 1841.6 ± 5.5% | 1183.3 ± 0.7% | 367.1 ± 0.3% | 888.5 ± 5.6% | 816.4 ± 2.5% | 17.050 | 26.535 | 85.523 | 35.342 | 38.461 |
| hex: canterbury-large/world192.txt | 524290 | 27968.1 ± 0.8% | 1909.0 ± 2.5% | 1181.7 ± 0.4% | 347.8 ± 0.7% | 907.6 ± 1.4% | 823.6 ± 4.7% | 14.650 | 23.669 | 80.412 | 30.816 | 33.960 |
| hex: http/html-1kx1024 | 2099200 | 17537.9 ± 1.0% | 1833.6 ± 0.2% | 1112.9 ± 0.2% | 374.1 ± 0.4% | 876.1 ± 2.4% | 801.5 ± 2.5% | 9.565 | 15.759 | 46.883 | 20.018 | 21.882 |
| hex: http/html-16kx64 | 2097280 | 18746.1 ± 1.2% | 1794.6 ± 2.7% | 1131.0 ± 0.3% | 373.1 ± 0.2% | 922.8 ± 4.4% | 825.3 ± 2.6% | 10.446 | 16.574 | 50.250 | 20.315 | 22.714 |
| hex: http/html-1m | 524290 | 27125.4 ± 0.5% | 1833.1 ± 7.2% | 1178.8 ± 0.8% | 359.8 ± 0.8% | 894.2 ± 2.7% | 820.1 ± 0.6% | 14.798 | 23.011 | 75.387 | 30.334 | 33.074 |
| hex: http/json-1kx1024 | 2099200 | 17474.7 ± 3.5% | 1831.2 ± 0.4% | 1111.5 ± 2.2% | 539.3 ± 0.5% | 887.3 ± 2.7% | 804.2 ± 1.3% | 9.543 | 15.722 | 32.405 | 19.695 | 21.729 |
| hex: http/json-16kx64 | 2097280 | 18441.7 ± 0.7% | 1817.7 ± 1.1% | 1128.2 ± 0.1% | 546.9 ± 0.5% | 930.9 ± 8.9% | 826.4 ± 0.9% | 10.145 | 16.346 | 33.719 | 19.810 | 22.316 |
| hex: http/json-1m | 524290 | 27890.8 ± 0.4% | 1935.1 ± 0.5% | 1181.4 ± 2.8% | 581.8 ± 0.9% | 905.8 ± 1.7% | 820.1 ± 1.3% | 14.413 | 23.609 | 47.942 | 30.792 | 34.011 |
| hex: http/js-1kx1024 | 2099200 | 17728.0 ± 0.6% | 1833.2 ± 0.5% | 1112.2 ± 0.3% | 369.1 ± 0.6% | 869.8 ± 3.2% | 807.1 ± 5.7% | 9.670 | 15.939 | 48.031 | 20.382 | 21.965 |
| hex: http/js-16kx64 | 2097280 | 18680.0 ± 0.4% | 1795.2 ± 1.1% | 1132.8 ± 0.1% | 371.1 ± 2.1% | 957.8 ± 13.3% | 822.8 ± 11.8% | 10.405 | 16.491 | 50.342 | 19.503 | 22.702 |
| hex: http/js-1m | 524290 | 27960.9 ± 0.3% | 1897.1 ± 2.6% | 1173.5 ± 0.6% | 380.4 ± 3.6% | 893.0 ± 4.4% | 822.9 ± 1.2% | 14.739 | 23.826 | 73.506 | 31.312 | 33.979 |
| hex: http/css-1kx1024 | 2099200 | 17815.8 ± 0.2% | 1833.3 ± 0.2% | 1112.0 ± 0.8% | 413.3 ± 0.6% | 874.8 ± 4.0% | 808.3 ± 2.8% | 9.718 | 16.021 | 43.107 | 20.365 | 22.042 |
| hex: http/css-16kx64 | 2097280 | 18238.0 ± 0.6% | 1795.5 ± 8.4% | 1132.9 ± 1.5% | 418.7 ± 4.1% | 938.6 ± 8.5% | 829.4 ± 1.6% | 10.158 | 16.098 | 43.557 | 19.431 | 21.990 |
| hex: http/css-1m | 524290 | 27910.9 ± 0.4% | 1917.1 ± 1.2% | 1181.3 ± 3.4% | 402.3 ± 0.7% | 901.4 ± 5.7% | 818.3 ± 1.3% | 14.559 | 23.627 | 69.374 | 30.965 | 34.110 |
| hex: shuffled/dickens-1m | 524290 | 27918.0 ± 4.0% | 1901.3 ± 3.4% | 1181.4 ± 0.4% | 351.3 ± 0.8% | 914.8 ± 4.7% | 819.6 ± 1.1% | 14.684 | 23.632 | 79.461 | 30.517 | 34.065 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1415.0 ± 0.3% | 1148.6 ± 0.4% | 781.3 ± 1.2% | 358.8 ± 0.6% | 324.2 ± 0.7% | 378.6 ± 0.7% | 1.232 | 1.811 | 3.944 | 4.365 | 3.738 |
| qlog records, JSON text sequence | 1467503 | 1192.9 ± 0.9% | 982.0 ± 1.2% | 719.7 ± 1.1% | 337.4 ± 0.5% | 362.6 ± 2.0% | 264.0 ± 3.9% | 1.215 | 1.658 | 3.536 | 3.290 | 4.518 |
| string: silesia/dickens | 172528 | 11561.0 ± 2.9% | 2874.0 ± 5.5% | 2471.3 ± 0.9% | 272.3 ± 2.8% | 1194.6 ± 5.7% | 910.0 ± 8.3% | 4.023 | 4.678 | 42.463 | 9.678 | 12.704 |
| string: silesia/nci | 1075110 | 9401.8 ± 0.8% | 3535.1 ± 0.8% | 2385.4 ± 0.2% | 706.6 ± 0.4% | 1259.4 ± 4.8% | 975.9 ± 0.6% | 2.660 | 3.941 | 13.306 | 7.465 | 9.634 |
| string: silesia/reymont | 1075159 | 4286.9 ± 1.9% | 1435.2 ± 1.3% | 1512.9 ± 1.0% | 296.0 ± 0.3% | 991.4 ± 4.1% | 855.6 ± 0.8% | 2.987 | 2.834 | 14.482 | 4.324 | 5.011 |
| string: silesia/samba | 97582 | 5181.4 ± 1.5% | 2082.1 ± 2.1% | 2956.6 ± 2.0% | 288.6 ± 0.7% | 983.7 ± 1.4% | 944.6 ± 2.2% | 2.489 | 1.753 | 17.951 | 5.267 | 5.486 |
| string: silesia/webster | 1098490 | 5470.9 ± 1.3% | 1504.3 ± 1.4% | 1415.8 ± 1.0% | 293.7 ± 0.7% | 917.8 ± 2.5% | 466.2 ± 0.6% | 3.637 | 3.864 | 18.628 | 5.961 | 11.735 |
| string: silesia/xml | 1090118 | 8997.5 ± 1.5% | 2394.8 ± 1.3% | 2002.0 ± 2.3% | 481.4 ± 0.2% | 1246.1 ± 8.9% | 757.0 ± 0.7% | 3.757 | 4.494 | 18.689 | 7.221 | 11.886 |
| string: canterbury/alice29.txt | 159425 | 10816.3 ± 2.2% | 2190.6 ± 4.9% | 2337.0 ± 0.8% | 261.2 ± 1.7% | 1021.5 ± 5.1% | 835.4 ± 3.5% | 4.938 | 4.628 | 41.404 | 10.589 | 12.947 |
| string: canterbury/asyoulik.txt | 132198 | 9189.1 ± 1.1% | 1627.9 ± 2.3% | 2385.6 ± 0.3% | 266.4 ± 0.6% | 881.5 ± 4.3% | 742.3 ± 1.3% | 5.645 | 3.852 | 34.500 | 10.424 | 12.380 |
| string: canterbury/lcet10.txt | 441884 | 10420.0 ± 4.3% | 2269.4 ± 5.6% | 2075.5 ± 1.6% | 294.5 ± 0.7% | 1093.7 ± 3.3% | 909.5 ± 1.0% | 4.592 | 5.021 | 35.384 | 9.527 | 11.457 |
| string: canterbury/plrabn12.txt | 503330 | 7407.6 ± 5.2% | 1706.2 ± 1.5% | 1639.0 ± 1.7% | 276.7 ± 0.7% | 953.6 ± 1.6% | 794.2 ± 2.5% | 4.342 | 4.520 | 26.776 | 7.768 | 9.327 |
| string: canterbury-large/E.coli | 1048578 | 22034.3 ± 0.1% | 10902.2 ± 0.2% | 2784.5 ± 0.3% | 1315.7 ± 0.6% | 1430.9 ± 11.5% | 1086.4 ± 2.4% | 2.021 | 7.913 | 16.748 | 15.399 | 20.282 |
| string: canterbury-large/bible.txt | 1055886 | 7809.8 ± 1.5% | 3667.6 ± 1.3% | 2405.4 ± 0.7% | 320.4 ± 1.7% | 1469.2 ± 6.5% | 1099.5 ± 1.6% | 2.129 | 3.247 | 24.379 | 5.316 | 7.103 |
| string: canterbury-large/world192.txt | 1103121 | 5156.8 ± 1.9% | 1320.3 ± 2.8% | 1484.4 ± 5.1% | 293.3 ± 1.2% | 919.6 ± 1.2% | 773.8 ± 0.5% | 3.906 | 3.474 | 17.585 | 5.608 | 6.665 |
| string: http/html-1m | 1058582 | 7762.5 ± 1.2% | 3360.1 ± 0.9% | 2339.3 ± 0.7% | 329.1 ± 2.2% | 1378.6 ± 3.2% | 653.6 ± 1.8% | 2.310 | 3.318 | 23.586 | 5.631 | 11.876 |
| string: http/json-1m | 1190272 | 6966.0 ± 1.2% | 1184.5 ± 1.7% | 1262.6 ± 4.0% | 394.4 ± 4.1% | 779.6 ± 1.2% | 660.8 ± 1.8% | 5.881 | 5.517 | 17.663 | 8.935 | 10.542 |
| string: http/js-1m | 1144362 | 5257.4 ± 1.3% | 860.2 ± 1.0% | 1096.0 ± 0.5% | 260.8 ± 1.9% | 761.0 ± 2.9% | 600.4 ± 1.2% | 6.112 | 4.797 | 20.156 | 6.908 | 8.757 |
| string: http/css-1m | 1097820 | 8425.8 ± 0.9% | 1112.6 ± 0.8% | 1620.1 ± 3.7% | 371.1 ± 1.7% | 908.5 ± 1.0% | 756.8 ± 0.9% | 7.573 | 5.201 | 22.706 | 9.274 | 11.133 |
| string: dickens as Cyrillic and CJK | 1883069 | 4364.3 ± 1.5% | 2862.2 ± 0.8% | 360.3 ± 1.0% | 192.1 ± 0.6% | 343.9 ± 4.1% | 277.3 ± 0.2% | 1.525 | 12.114 | 22.720 | 12.689 | 15.738 |
| hex: silesia/dickens | 524290 | 27584.7 ± 0.2% | 1887.4 ± 2.7% | 1179.7 ± 0.5% | 350.6 ± 0.7% | 911.6 ± 2.5% | 821.1 ± 1.9% | 14.615 | 23.383 | 78.686 | 30.259 | 33.596 |
| hex: silesia/mozilla | 524290 | 27503.0 ± 0.6% | 1935.5 ± 2.6% | 1179.5 ± 8.0% | 310.3 ± 5.3% | 913.4 ± 5.0% | 819.9 ± 1.9% | 14.210 | 23.317 | 88.624 | 30.109 | 33.546 |
| hex: silesia/mr | 524290 | 27544.1 ± 1.5% | 1821.2 ± 2.9% | 1176.3 ± 1.7% | 453.4 ± 0.4% | 914.8 ± 2.3% | 821.3 ± 1.6% | 15.124 | 23.417 | 60.747 | 30.111 | 33.537 |
| hex: silesia/nci | 524290 | 31541.5 ± 0.2% | 1910.5 ± 5.7% | 1175.0 ± 0.9% | 596.3 ± 0.3% | 895.4 ± 4.3% | 820.1 ± 0.8% | 16.510 | 26.845 | 52.894 | 35.227 | 38.460 |
| hex: silesia/ooffice | 524290 | 28070.4 ± 0.3% | 1929.4 ± 2.2% | 1180.7 ± 0.3% | 257.1 ± 0.8% | 907.5 ± 2.2% | 820.6 ± 1.1% | 14.548 | 23.774 | 109.172 | 30.933 | 34.207 |
| hex: silesia/osdb | 524290 | 27875.1 ± 0.4% | 1914.6 ± 1.2% | 1178.4 ± 1.1% | 343.4 ± 1.0% | 922.4 ± 4.1% | 820.8 ± 1.3% | 14.559 | 23.655 | 81.163 | 30.220 | 33.960 |
| hex: silesia/reymont | 524290 | 27976.1 ± 0.3% | 1914.7 ± 1.7% | 1179.3 ± 1.5% | 371.8 ± 0.5% | 915.0 ± 3.2% | 823.6 ± 1.1% | 14.612 | 23.723 | 75.242 | 30.574 | 33.970 |
| hex: silesia/samba | 524290 | 31601.7 ± 0.5% | 1921.4 ± 5.7% | 1179.8 ± 1.0% | 273.9 ± 0.7% | 902.9 ± 2.8% | 817.1 ± 1.8% | 16.447 | 26.785 | 115.375 | 35.000 | 38.676 |
| hex: silesia/sao | 524290 | 27955.8 ± 1.1% | 1860.9 ± 6.5% | 1180.3 ± 6.1% | 210.5 ± 0.4% | 902.9 ± 1.5% | 810.9 ± 3.5% | 15.022 | 23.686 | 132.794 | 30.964 | 34.477 |
| hex: silesia/webster | 524290 | 29249.7 ± 0.3% | 1894.6 ± 2.1% | 1179.4 ± 0.8% | 326.2 ± 2.1% | 921.5 ± 2.0% | 820.6 ± 1.6% | 15.439 | 24.800 | 89.669 | 31.741 | 35.645 |
| hex: silesia/x-ray | 524290 | 27572.7 ± 0.3% | 1864.5 ± 6.4% | 1178.9 ± 2.1% | 320.7 ± 1.3% | 925.2 ± 3.7% | 822.0 ± 4.4% | 14.788 | 23.388 | 85.989 | 29.800 | 33.543 |
| hex: silesia/xml | 524290 | 31621.4 ± 1.5% | 1942.9 ± 4.0% | 1180.9 ± 0.6% | 534.7 ± 0.9% | 897.6 ± 1.3% | 816.5 ± 3.2% | 16.276 | 26.778 | 59.142 | 35.229 | 38.727 |
| hex: canterbury/alice29.txt | 304180 | 27860.9 ± 1.8% | 1903.4 ± 8.2% | 1195.7 ± 0.7% | 355.8 ± 4.4% | 939.1 ± 2.2% | 833.7 ± 0.9% | 14.638 | 23.300 | 78.315 | 29.668 | 33.417 |
| hex: canterbury/asyoulik.txt | 250360 | 27621.5 ± 0.5% | 1982.3 ± 9.2% | 1210.3 ± 0.3% | 345.9 ± 0.5% | 909.1 ± 3.4% | 830.1 ± 2.9% | 13.934 | 22.821 | 79.865 | 30.384 | 33.274 |
| hex: canterbury/cp.html | 49208 | 26973.2 ± 0.2% | 1836.4 ± 8.8% | 1197.1 ± 2.1% | 357.5 ± 0.3% | 1050.4 ± 12.3% | 829.2 ± 1.8% | 14.688 | 22.532 | 75.456 | 25.680 | 32.528 |
| hex: canterbury/fields.c | 22302 | 31049.1 ± 1.8% | 1924.3 ± 9.0% | 1199.2 ± 0.6% | 548.3 ± 1.3% | 1006.9 ± 6.7% | 835.4 ± 1.2% | 16.135 | 25.892 | 56.623 | 30.838 | 37.168 |
| hex: canterbury/grammar.lsp | 7444 | 29722.0 ± 2.3% | 1881.8 ± 5.5% | 1209.4 ± 0.4% | 621.7 ± 7.1% | 959.5 ± 11.9% | 837.3 ± 1.8% | 15.795 | 24.576 | 47.808 | 30.978 | 35.497 |
| hex: canterbury/kennedy.xls | 524290 | 27898.4 ± 0.2% | 1826.0 ± 1.7% | 1177.7 ± 0.7% | 588.7 ± 0.5% | 896.3 ± 1.9% | 823.0 ± 3.0% | 15.279 | 23.689 | 47.386 | 31.128 | 33.897 |
| hex: canterbury/lcet10.txt | 524290 | 31627.3 ± 0.7% | 1894.4 ± 2.5% | 1182.8 ± 0.2% | 355.7 ± 2.4% | 883.6 ± 2.4% | 817.9 ± 0.4% | 16.695 | 26.739 | 88.910 | 35.794 | 38.670 |
| hex: canterbury/plrabn12.txt | 524290 | 27591.5 ± 4.1% | 1935.6 ± 4.2% | 1177.6 ± 0.8% | 344.4 ± 0.6% | 912.0 ± 2.0% | 816.0 ± 5.4% | 14.254 | 23.431 | 80.114 | 30.255 | 33.812 |
| hex: canterbury/ptt5 | 524290 | 27666.3 ± 0.3% | 1894.1 ± 4.9% | 1176.5 ± 0.4% | 456.8 ± 0.3% | 900.9 ± 4.6% | 818.2 ± 2.2% | 14.607 | 23.516 | 60.560 | 30.710 | 33.815 |
| hex: canterbury/sum | 76482 | 27326.7 ± 0.2% | 1900.3 ± 5.0% | 1182.9 ± 1.3% | 436.8 ± 0.4% | 1011.0 ± 5.8% | 837.6 ± 1.7% | 14.380 | 23.101 | 62.564 | 27.029 | 32.626 |
| hex: canterbury/xargs.1 | 8456 | 29310.4 ± 0.2% | 1891.4 ± 9.9% | 1208.8 ± 6.6% | 624.5 ± 0.7% | 917.9 ± 16.4% | 843.7 ± 0.7% | 15.497 | 24.248 | 46.934 | 31.933 | 34.742 |
| hex: canterbury-large/E.coli | 524290 | 27270.8 ± 0.4% | 1878.0 ± 5.0% | 1179.0 ± 0.7% | 608.0 ± 1.4% | 917.2 ± 3.1% | 817.6 ± 2.0% | 14.521 | 23.131 | 44.857 | 29.734 | 33.353 |
| hex: canterbury-large/bible.txt | 524290 | 31438.6 ± 0.3% | 1841.6 ± 5.5% | 1183.3 ± 0.7% | 367.1 ± 0.3% | 888.5 ± 5.6% | 816.4 ± 2.5% | 17.071 | 26.568 | 85.629 | 35.386 | 38.509 |
| hex: canterbury-large/world192.txt | 524290 | 27997.8 ± 0.3% | 1909.0 ± 2.5% | 1181.7 ± 0.4% | 347.8 ± 0.7% | 907.6 ± 1.4% | 823.6 ± 4.7% | 14.666 | 23.694 | 80.497 | 30.848 | 33.996 |
| hex: http/html-1kx1024 | 2099200 | 17726.4 ± 0.6% | 1833.6 ± 0.2% | 1112.9 ± 0.2% | 374.1 ± 0.4% | 876.1 ± 2.4% | 801.5 ± 2.5% | 9.668 | 15.928 | 47.387 | 20.234 | 22.117 |
| hex: http/html-16kx64 | 2097280 | 18835.5 ± 0.5% | 1794.6 ± 2.7% | 1131.0 ± 0.3% | 373.1 ± 0.2% | 922.8 ± 4.4% | 825.3 ± 2.6% | 10.496 | 16.653 | 50.490 | 20.412 | 22.822 |
| hex: http/html-1m | 524290 | 27196.2 ± 0.3% | 1833.1 ± 7.2% | 1178.8 ± 0.8% | 359.8 ± 0.8% | 894.2 ± 2.7% | 820.1 ± 0.6% | 14.836 | 23.071 | 75.583 | 30.413 | 33.160 |
| hex: http/json-1kx1024 | 2099200 | 17622.6 ± 0.2% | 1831.2 ± 0.4% | 1111.5 ± 2.2% | 539.3 ± 0.5% | 887.3 ± 2.7% | 804.2 ± 1.3% | 9.624 | 15.855 | 32.680 | 19.862 | 21.913 |
| hex: http/json-16kx64 | 2097280 | 18551.7 ± 0.2% | 1817.7 ± 1.1% | 1128.2 ± 0.1% | 546.9 ± 0.5% | 930.9 ± 8.9% | 826.4 ± 0.9% | 10.206 | 16.444 | 33.920 | 19.928 | 22.449 |
| hex: http/json-1m | 524290 | 27970.3 ± 1.4% | 1935.1 ± 0.5% | 1181.4 ± 2.8% | 581.8 ± 0.9% | 905.8 ± 1.7% | 820.1 ± 1.3% | 14.454 | 23.676 | 48.079 | 30.879 | 34.108 |
| hex: http/js-1kx1024 | 2099200 | 17792.5 ± 1.0% | 1833.2 ± 0.5% | 1112.2 ± 0.3% | 369.1 ± 0.6% | 869.8 ± 3.2% | 807.1 ± 5.7% | 9.706 | 15.997 | 48.205 | 20.456 | 22.045 |
| hex: http/js-16kx64 | 2097280 | 18726.9 ± 0.2% | 1795.2 ± 1.1% | 1132.8 ± 0.1% | 371.1 ± 2.1% | 957.8 ± 13.3% | 822.8 ± 11.8% | 10.431 | 16.532 | 50.469 | 19.552 | 22.759 |
| hex: http/js-1m | 524290 | 28038.5 ± 0.8% | 1897.1 ± 2.6% | 1173.5 ± 0.6% | 380.4 ± 3.6% | 893.0 ± 4.4% | 822.9 ± 1.2% | 14.779 | 23.892 | 73.710 | 31.399 | 34.073 |
| hex: http/css-1kx1024 | 2099200 | 17929.2 ± 0.4% | 1833.3 ± 0.2% | 1112.0 ± 0.8% | 413.3 ± 0.6% | 874.8 ± 4.0% | 808.3 ± 2.8% | 9.780 | 16.123 | 43.382 | 20.495 | 22.183 |
| hex: http/css-16kx64 | 2097280 | 18330.9 ± 1.2% | 1795.5 ± 8.4% | 1132.9 ± 1.5% | 418.7 ± 4.1% | 938.6 ± 8.5% | 829.4 ± 1.6% | 10.209 | 16.180 | 43.778 | 19.530 | 22.101 |
| hex: http/css-1m | 524290 | 27951.9 ± 3.3% | 1917.1 ± 1.2% | 1181.3 ± 3.4% | 402.3 ± 0.7% | 901.4 ± 5.7% | 818.3 ± 1.3% | 14.581 | 23.662 | 69.476 | 31.011 | 34.160 |
| hex: shuffled/dickens-1m | 524290 | 27947.6 ± 3.3% | 1901.3 ± 3.4% | 1181.4 ± 0.4% | 351.3 ± 0.8% | 914.8 ± 4.7% | 819.6 ± 1.1% | 14.699 | 23.657 | 79.545 | 30.549 | 34.101 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 892.0 ± 0.6% | 1171.5 ± 3.3% | 828.8 ± 0.5% | 295.6 ± 0.8% | 472.9 ± 2.5% | 275.1 ± 2.3% | 0.761 | 1.076 | 3.018 | 1.886 | 3.242 |
| qlog records, JSON text sequence | 1467503 | 759.8 ± 0.9% | 974.2 ± 0.5% | 837.6 ± 0.5% | 256.9 ± 1.2% | 531.8 ± 1.1% | 243.4 ± 1.4% | 0.780 | 0.907 | 2.958 | 1.429 | 3.121 |
| string: silesia/dickens | 172528 | 5388.4 ± 1.8% | 2549.6 ± 1.5% | 2358.7 ± 2.6% | 230.3 ± 1.2% | 2551.3 ± 1.5% | 462.3 ± 2.5% | 2.113 | 2.284 | 23.401 | 2.112 | 11.656 |
| string: silesia/nci | 1075110 | 4038.3 ± 0.2% | 3049.2 ± 0.1% | 2370.9 ± 0.3% | 521.3 ± 0.5% | 2845.6 ± 0.9% | 510.8 ± 0.9% | 1.324 | 1.703 | 7.746 | 1.419 | 7.906 |
| string: silesia/reymont | 1075159 | 3101.8 ± 3.9% | 2651.5 ± 0.3% | 1485.3 ± 1.1% | 236.0 ± 6.5% | 1620.6 ± 1.7% | 424.7 ± 1.0% | 1.170 | 2.088 | 13.142 | 1.914 | 7.304 |
| string: silesia/samba | 97582 | 3077.5 ± 3.5% | 2809.4 ± 0.7% | 2202.8 ± 1.8% | 248.9 ± 1.0% | 1538.6 ± 1.4% | 328.2 ± 0.7% | 1.095 | 1.397 | 12.367 | 2.000 | 9.377 |
| string: silesia/webster | 1098490 | 3472.0 ± 2.3% | 1885.0 ± 0.6% | 1379.9 ± 0.7% | 229.2 ± 0.9% | 1663.7 ± 0.5% | 388.8 ± 3.3% | 1.842 | 2.516 | 15.145 | 2.087 | 8.929 |
| string: silesia/xml | 1090118 | 4914.0 ± 0.8% | 3929.1 ± 0.4% | 1911.7 ± 0.2% | 374.8 ± 0.9% | 2592.4 ± 0.4% | 467.2 ± 1.0% | 1.251 | 2.570 | 13.110 | 1.896 | 10.519 |
| string: canterbury/alice29.txt | 159425 | 4556.6 ± 1.2% | 2183.0 ± 0.7% | 2336.0 ± 2.2% | 222.9 ± 0.6% | 2372.3 ± 1.0% | 404.9 ± 4.5% | 2.087 | 1.951 | 20.440 | 1.921 | 11.255 |
| string: canterbury/asyoulik.txt | 132198 | 3417.7 ± 2.3% | 1811.7 ± 6.5% | 2175.3 ± 0.7% | 222.4 ± 0.9% | 1884.7 ± 2.3% | 364.4 ± 2.4% | 1.886 | 1.571 | 15.370 | 1.813 | 9.378 |
| string: canterbury/lcet10.txt | 441884 | 5287.8 ± 1.1% | 2422.0 ± 0.9% | 1776.6 ± 2.2% | 254.0 ± 3.8% | 2325.5 ± 0.7% | 445.2 ± 2.4% | 2.183 | 2.976 | 20.817 | 2.274 | 11.877 |
| string: canterbury/plrabn12.txt | 503330 | 4326.2 ± 0.2% | 2422.4 ± 0.6% | 1453.8 ± 2.7% | 236.8 ± 1.4% | 2191.6 ± 0.3% | 404.1 ± 1.2% | 1.786 | 2.976 | 18.265 | 1.974 | 10.705 |
| string: canterbury-large/E.coli | 1048578 | 25205.8 ± 0.3% | 10046.6 ± 0.3% | 2658.3 ± 0.9% | 848.0 ± 0.4% | 6465.1 ± 1.3% | 833.8 ± 2.6% | 2.509 | 9.482 | 29.725 | 3.899 | 30.230 |
| string: canterbury-large/bible.txt | 1055886 | 6810.0 ± 0.9% | 4164.7 ± 2.0% | 2257.1 ± 1.0% | 252.4 ± 2.3% | 3090.1 ± 0.8% | 536.3 ± 0.5% | 1.635 | 3.017 | 26.978 | 2.204 | 12.697 |
| string: canterbury-large/world192.txt | 1103121 | 3380.2 ± 1.1% | 1757.6 ± 0.7% | 1435.6 ± 0.6% | 240.1 ± 1.4% | 1727.5 ± 0.5% | 390.5 ± 1.3% | 1.923 | 2.355 | 14.077 | 1.957 | 8.657 |
| string: http/html-1m | 1058582 | 7220.8 ± 11.5% | 3665.6 ± 0.4% | 2160.7 ± 1.3% | 296.1 ± 1.1% | 2913.8 ± 0.8% | 513.7 ± 0.6% | 1.970 | 3.342 | 24.387 | 2.478 | 14.057 |
| string: http/json-1m | 1190272 | 2843.9 ± 0.7% | 972.7 ± 0.9% | 1697.9 ± 0.2% | 359.6 ± 1.2% | 1067.4 ± 1.5% | 343.1 ± 1.4% | 2.924 | 1.675 | 7.909 | 2.664 | 8.288 |
| string: http/js-1m | 1144362 | 2377.3 ± 0.6% | 1244.6 ± 0.9% | 1059.8 ± 0.3% | 234.0 ± 0.1% | 1112.6 ± 0.5% | 308.5 ± 3.4% | 1.910 | 2.243 | 10.161 | 2.137 | 7.705 |
| string: http/css-1m | 1097820 | 2590.8 ± 0.3% | 2249.1 ± 0.3% | 1558.6 ± 3.5% | 322.5 ± 1.0% | 1646.7 ± 0.4% | 376.0 ± 1.0% | 1.152 | 1.662 | 8.034 | 1.573 | 6.890 |
| string: dickens as Cyrillic and CJK | 1883069 | 4590.5 ± 0.5% | 2851.4 ± 0.2% | 516.3 ± 0.5% | 285.5 ± 0.3% | 393.1 ± 0.7% | 126.6 ± 2.4% | 1.610 | 8.892 | 16.080 | 11.678 | 36.261 |
| string: dickens as Cyrillic and CJK, as \u escapes | 5075485 | 918.1 ± 1.9% | 956.1 ± 0.6% | 851.5 ± 0.6% | 203.7 ± 0.5% | 365.7 ± 0.4% | 171.8 ± 3.5% | 0.960 | 1.078 | 4.507 | 2.511 | 5.343 |
| hex: silesia/dickens | 524290 | 25117.0 ± 0.1% | 11515.6 ± 2.9% | 2694.9 ± 0.4% | 370.5 ± 0.5% | 6439.8 ± 2.5% | 865.0 ± 1.8% | 2.181 | 9.320 | 67.792 | 3.900 | 29.039 |
| hex: silesia/mozilla | 524290 | 25128.5 ± 0.3% | 11594.1 ± 1.9% | 2773.0 ± 0.8% | 315.9 ± 3.8% | 6457.1 ± 0.5% | 863.7 ± 1.0% | 2.167 | 9.062 | 79.539 | 3.892 | 29.096 |
| hex: silesia/mr | 524290 | 25115.9 ± 0.6% | 11615.0 ± 3.8% | 2774.9 ± 0.5% | 479.2 ± 1.8% | 6469.7 ± 4.3% | 867.1 ± 3.2% | 2.162 | 9.051 | 52.413 | 3.882 | 28.965 |
| hex: silesia/nci | 524290 | 25049.4 ± 3.2% | 11515.8 ± 2.1% | 2696.4 ± 2.8% | 594.1 ± 1.9% | 6457.1 ± 0.4% | 856.5 ± 5.0% | 2.175 | 9.290 | 42.161 | 3.879 | 29.247 |
| hex: silesia/ooffice | 524290 | 25104.4 ± 0.5% | 11616.2 ± 0.4% | 2769.1 ± 5.8% | 261.4 ± 1.3% | 6466.9 ± 0.2% | 862.0 ± 1.7% | 2.161 | 9.066 | 96.030 | 3.882 | 29.124 |
| hex: silesia/osdb | 524290 | 25128.2 ± 0.8% | 11621.0 ± 0.8% | 2770.2 ± 0.6% | 355.1 ± 1.2% | 6458.1 ± 0.9% | 859.1 ± 1.3% | 2.162 | 9.071 | 70.772 | 3.891 | 29.249 |
| hex: silesia/reymont | 524290 | 25111.1 ± 0.1% | 11595.8 ± 0.3% | 2699.8 ± 0.6% | 391.1 ± 1.0% | 6459.8 ± 1.1% | 867.8 ± 3.2% | 2.166 | 9.301 | 64.204 | 3.887 | 28.935 |
| hex: silesia/samba | 524290 | 25102.6 ± 0.4% | 11631.4 ± 0.5% | 2768.6 ± 0.3% | 280.9 ± 0.9% | 6459.2 ± 2.8% | 852.3 ± 5.1% | 2.158 | 9.067 | 89.372 | 3.886 | 29.452 |
| hex: silesia/sao | 524290 | 25111.2 ± 0.3% | 11603.7 ± 2.1% | 2689.8 ± 0.2% | 211.2 ± 1.8% | 6455.8 ± 0.4% | 863.0 ± 1.0% | 2.164 | 9.336 | 118.902 | 3.890 | 29.098 |
| hex: silesia/webster | 524290 | 25102.4 ± 0.7% | 11636.0 ± 0.3% | 2769.1 ± 0.5% | 346.4 ± 0.4% | 6455.5 ± 0.3% | 864.8 ± 1.0% | 2.157 | 9.065 | 72.468 | 3.889 | 29.028 |
| hex: silesia/x-ray | 524290 | 25136.3 ± 0.8% | 11636.3 ± 1.1% | 2699.1 ± 0.9% | 325.9 ± 9.0% | 6449.8 ± 0.9% | 865.4 ± 1.7% | 2.160 | 9.313 | 77.137 | 3.897 | 29.047 |
| hex: silesia/xml | 524290 | 25192.4 ± 0.3% | 11602.1 ± 0.9% | 2771.1 ± 1.7% | 577.8 ± 4.0% | 6444.8 ± 1.0% | 863.9 ± 3.4% | 2.171 | 9.091 | 43.601 | 3.909 | 29.161 |
| hex: canterbury/alice29.txt | 304180 | 25060.3 ± 1.2% | 11589.8 ± 0.2% | 2772.8 ± 0.4% | 373.0 ± 1.2% | 6459.0 ± 0.3% | 866.0 ± 3.2% | 2.162 | 9.038 | 67.193 | 3.880 | 28.936 |
| hex: canterbury/asyoulik.txt | 250360 | 24962.7 ± 0.7% | 11701.3 ± 0.4% | 2699.9 ± 0.1% | 366.0 ± 0.6% | 6452.1 ± 0.2% | 864.4 ± 3.2% | 2.133 | 9.246 | 68.212 | 3.869 | 28.879 |
| hex: canterbury/cp.html | 49208 | 25585.3 ± 0.3% | 11792.6 ± 0.6% | 2769.3 ± 0.2% | 388.2 ± 1.5% | 6661.7 ± 0.5% | 836.6 ± 1.2% | 2.170 | 9.239 | 65.906 | 3.841 | 30.584 |
| hex: canterbury/fields.c | 22302 | 25627.1 ± 0.6% | 13011.9 ± 0.4% | 2833.8 ± 0.3% | 476.7 ± 1.1% | 6673.4 ± 0.3% | 814.3 ± 3.0% | 1.970 | 9.043 | 53.761 | 3.840 | 31.470 |
| hex: canterbury/grammar.lsp | 7444 | 23082.0 ± 2.7% | 13798.4 ± 0.6% | 2806.3 ± 0.4% | 605.3 ± 7.9% | 6471.3 ± 0.6% | 778.3 ± 3.1% | 1.673 | 8.225 | 38.133 | 3.567 | 29.655 |
| hex: canterbury/kennedy.xls | 524290 | 25120.5 ± 0.5% | 11656.4 ± 1.5% | 2764.2 ± 0.3% | 595.4 ± 0.6% | 6461.6 ± 0.8% | 830.4 ± 7.1% | 2.155 | 9.088 | 42.189 | 3.888 | 30.251 |
| hex: canterbury/lcet10.txt | 524290 | 25169.3 ± 2.4% | 11619.6 ± 0.8% | 2774.5 ± 5.7% | 373.9 ± 1.3% | 6459.0 ± 0.7% | 837.7 ± 6.1% | 2.166 | 9.072 | 67.314 | 3.897 | 30.047 |
| hex: canterbury/plrabn12.txt | 524290 | 25108.2 ± 1.2% | 11629.4 ± 0.7% | 2772.4 ± 0.4% | 362.9 ± 0.6% | 6452.0 ± 0.6% | 846.8 ± 2.8% | 2.159 | 9.057 | 69.180 | 3.892 | 29.651 |
| hex: canterbury/ptt5 | 524290 | 25115.8 ± 0.5% | 11605.6 ± 1.3% | 2701.7 ± 0.7% | 479.5 ± 1.2% | 6449.8 ± 0.2% | 854.2 ± 2.1% | 2.164 | 9.296 | 52.382 | 3.894 | 29.402 |
| hex: canterbury/sum | 76482 | 24560.6 ± 0.3% | 11528.2 ± 2.9% | 2776.7 ± 0.2% | 427.3 ± 6.0% | 6432.9 ± 0.4% | 846.3 ± 2.0% | 2.130 | 8.845 | 57.479 | 3.818 | 29.021 |
| hex: canterbury/xargs.1 | 8456 | 23502.1 ± 0.4% | 13791.4 ± 2.2% | 2757.2 ± 0.3% | 580.6 ± 5.7% | 6492.8 ± 0.2% | 817.5 ± 3.9% | 1.704 | 8.524 | 40.477 | 3.620 | 28.749 |
| hex: canterbury-large/E.coli | 524290 | 25133.6 ± 0.5% | 11606.3 ± 1.9% | 2699.8 ± 1.7% | 594.4 ± 1.8% | 6463.1 ± 0.4% | 843.2 ± 5.3% | 2.166 | 9.310 | 42.284 | 3.889 | 29.809 |
| hex: canterbury-large/bible.txt | 524290 | 25142.0 ± 1.2% | 11649.5 ± 0.5% | 2699.3 ± 0.6% | 388.9 ± 2.4% | 6461.0 ± 2.1% | 869.7 ± 2.7% | 2.158 | 9.314 | 64.644 | 3.891 | 28.909 |
| hex: canterbury-large/world192.txt | 524290 | 25148.0 ± 0.4% | 11619.7 ± 1.4% | 2770.9 ± 0.2% | 368.2 ± 1.0% | 6492.9 ± 4.6% | 867.5 ± 5.7% | 2.164 | 9.076 | 68.296 | 3.873 | 28.988 |
| hex: http/html-1kx1024 | 2099200 | 14002.7 ± 1.7% | 10310.2 ± 5.3% | 2557.3 ± 1.3% | 385.5 ± 1.4% | 5074.1 ± 2.4% | 698.4 ± 1.2% | 1.358 | 5.476 | 36.323 | 2.760 | 20.049 |
| hex: http/html-16kx64 | 2097280 | 22557.8 ± 0.3% | 11709.6 ± 0.2% | 2638.6 ± 0.5% | 395.3 ± 2.7% | 6269.2 ± 4.7% | 792.1 ± 2.9% | 1.926 | 8.549 | 57.071 | 3.598 | 28.479 |
| hex: http/html-1m | 524290 | 25145.2 ± 0.5% | 11596.7 ± 3.0% | 2698.6 ± 0.2% | 389.4 ± 0.6% | 6449.5 ± 3.7% | 849.2 ± 3.8% | 2.168 | 9.318 | 64.582 | 3.899 | 29.611 |
| hex: http/json-1kx1024 | 2099200 | 13795.3 ± 2.1% | 10124.3 ± 2.9% | 2557.3 ± 0.5% | 561.9 ± 1.2% | 5084.2 ± 5.4% | 707.0 ± 2.1% | 1.363 | 5.394 | 24.550 | 2.713 | 19.512 |
| hex: http/json-16kx64 | 2097280 | 22620.7 ± 0.3% | 11658.0 ± 1.4% | 2642.1 ± 0.2% | 579.8 ± 1.8% | 6227.7 ± 4.1% | 802.3 ± 3.0% | 1.940 | 8.562 | 39.017 | 3.632 | 28.193 |
| hex: http/json-1m | 524290 | 25131.7 ± 0.3% | 11604.8 ± 2.6% | 2751.5 ± 0.2% | 614.2 ± 1.4% | 6463.7 ± 0.4% | 840.3 ± 1.3% | 2.166 | 9.134 | 40.918 | 3.888 | 29.909 |
| hex: http/js-1kx1024 | 2099200 | 14006.3 ± 0.3% | 9825.7 ± 2.8% | 2555.2 ± 0.4% | 378.9 ± 1.0% | 5108.5 ± 6.1% | 696.7 ± 4.5% | 1.425 | 5.481 | 36.962 | 2.742 | 20.105 |
| hex: http/js-16kx64 | 2097280 | 22242.5 ± 0.1% | 11582.0 ± 0.6% | 2633.3 ± 0.8% | 384.7 ± 0.5% | 6117.4 ± 3.6% | 807.3 ± 4.8% | 1.920 | 8.447 | 57.823 | 3.636 | 27.552 |
| hex: http/js-1m | 524290 | 25119.2 ± 0.5% | 11569.3 ± 1.5% | 2770.0 ± 1.9% | 400.2 ± 1.2% | 6457.0 ± 4.2% | 847.5 ± 3.0% | 2.171 | 9.068 | 62.760 | 3.890 | 29.639 |
| hex: http/css-1kx1024 | 2099200 | 13860.4 ± 0.6% | 9977.3 ± 2.6% | 2551.8 ± 0.5% | 436.5 ± 3.0% | 5092.7 ± 4.5% | 694.4 ± 4.2% | 1.389 | 5.432 | 31.751 | 2.722 | 19.960 |
| hex: http/css-16kx64 | 2097280 | 22077.1 ± 6.7% | 11603.3 ± 0.4% | 2634.6 ± 1.4% | 448.3 ± 0.4% | 6123.1 ± 2.1% | 784.5 ± 3.7% | 1.903 | 8.380 | 49.243 | 3.606 | 28.140 |
| hex: http/css-1m | 524290 | 25094.5 ± 1.2% | 11559.0 ± 2.8% | 2744.3 ± 0.5% | 429.9 ± 0.6% | 6470.0 ± 0.6% | 820.9 ± 3.5% | 2.171 | 9.144 | 58.372 | 3.879 | 30.568 |
| hex: shuffled/dickens-1m | 524290 | 25147.1 ± 0.4% | 11574.3 ± 2.1% | 2700.0 ± 0.1% | 371.6 ± 0.6% | 6453.5 ± 0.8% | 843.0 ± 3.6% | 2.173 | 9.314 | 67.675 | 3.897 | 29.831 |

## TextReader.next_items against the baselines

stdx's decoder a slice of tokens a call through `TextReader.next_items`, as a caller that reads a text's values in a loop calls it (decision 79). Octets are the text's. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1014.7 ± 0.5% | 1171.5 ± 3.3% | 828.8 ± 0.5% | 295.6 ± 0.8% | 472.9 ± 2.5% | 275.1 ± 2.3% | 0.866 | 1.224 | 3.432 | 2.146 | 3.688 |
| qlog records, JSON text sequence | 1467503 | 865.4 ± 0.7% | 974.2 ± 0.5% | 837.6 ± 0.5% | 256.9 ± 1.2% | 531.8 ± 1.1% | 243.4 ± 1.4% | 0.888 | 1.033 | 3.369 | 1.627 | 3.555 |
| string: silesia/dickens | 172528 | 5421.1 ± 1.3% | 2549.6 ± 1.5% | 2358.7 ± 2.6% | 230.3 ± 1.2% | 2551.3 ± 1.5% | 462.3 ± 2.5% | 2.126 | 2.298 | 23.543 | 2.125 | 11.727 |
| string: silesia/nci | 1075110 | 4044.2 ± 0.4% | 3049.2 ± 0.1% | 2370.9 ± 0.3% | 521.3 ± 0.5% | 2845.6 ± 0.9% | 510.8 ± 0.9% | 1.326 | 1.706 | 7.757 | 1.421 | 7.917 |
| string: silesia/reymont | 1075159 | 3127.1 ± 3.6% | 2651.5 ± 0.3% | 1485.3 ± 1.1% | 236.0 ± 6.5% | 1620.6 ± 1.7% | 424.7 ± 1.0% | 1.179 | 2.105 | 13.249 | 1.930 | 7.364 |
| string: silesia/samba | 97582 | 3071.2 ± 0.7% | 2809.4 ± 0.7% | 2202.8 ± 1.8% | 248.9 ± 1.0% | 1538.6 ± 1.4% | 328.2 ± 0.7% | 1.093 | 1.394 | 12.341 | 1.996 | 9.358 |
| string: silesia/webster | 1098490 | 3480.5 ± 1.0% | 1885.0 ± 0.6% | 1379.9 ± 0.7% | 229.2 ± 0.9% | 1663.7 ± 0.5% | 388.8 ± 3.3% | 1.846 | 2.522 | 15.182 | 2.092 | 8.951 |
| string: silesia/xml | 1090118 | 4933.3 ± 0.6% | 3929.1 ± 0.4% | 1911.7 ± 0.2% | 374.8 ± 0.9% | 2592.4 ± 0.4% | 467.2 ± 1.0% | 1.256 | 2.581 | 13.162 | 1.903 | 10.560 |
| string: canterbury/alice29.txt | 159425 | 4584.6 ± 1.1% | 2183.0 ± 0.7% | 2336.0 ± 2.2% | 222.9 ± 0.6% | 2372.3 ± 1.0% | 404.9 ± 4.5% | 2.100 | 1.963 | 20.565 | 1.933 | 11.324 |
| string: canterbury/asyoulik.txt | 132198 | 3459.1 ± 1.8% | 1811.7 ± 6.5% | 2175.3 ± 0.7% | 222.4 ± 0.9% | 1884.7 ± 2.3% | 364.4 ± 2.4% | 1.909 | 1.590 | 15.555 | 1.835 | 9.492 |
| string: canterbury/lcet10.txt | 441884 | 5271.3 ± 1.0% | 2422.0 ± 0.9% | 1776.6 ± 2.2% | 254.0 ± 3.8% | 2325.5 ± 0.7% | 445.2 ± 2.4% | 2.176 | 2.967 | 20.752 | 2.267 | 11.840 |
| string: canterbury/plrabn12.txt | 503330 | 4331.0 ± 0.2% | 2422.4 ± 0.6% | 1453.8 ± 2.7% | 236.8 ± 1.4% | 2191.6 ± 0.3% | 404.1 ± 1.2% | 1.788 | 2.979 | 18.286 | 1.976 | 10.717 |
| string: canterbury-large/E.coli | 1048578 | 25221.9 ± 2.3% | 10046.6 ± 0.3% | 2658.3 ± 0.9% | 848.0 ± 0.4% | 6465.1 ± 1.3% | 833.8 ± 2.6% | 2.510 | 9.488 | 29.744 | 3.901 | 30.249 |
| string: canterbury-large/bible.txt | 1055886 | 6869.2 ± 0.8% | 4164.7 ± 2.0% | 2257.1 ± 1.0% | 252.4 ± 2.3% | 3090.1 ± 0.8% | 536.3 ± 0.5% | 1.649 | 3.043 | 27.213 | 2.223 | 12.808 |
| string: canterbury-large/world192.txt | 1103121 | 3397.2 ± 2.3% | 1757.6 ± 0.7% | 1435.6 ± 0.6% | 240.1 ± 1.4% | 1727.5 ± 0.5% | 390.5 ± 1.3% | 1.933 | 2.366 | 14.148 | 1.967 | 8.701 |
| string: http/html-1m | 1058582 | 7459.1 ± 1.3% | 3665.6 ± 0.4% | 2160.7 ± 1.3% | 296.1 ± 1.1% | 2913.8 ± 0.8% | 513.7 ± 0.6% | 2.035 | 3.452 | 25.192 | 2.560 | 14.521 |
| string: http/json-1m | 1190272 | 2850.1 ± 0.4% | 972.7 ± 0.9% | 1697.9 ± 0.2% | 359.6 ± 1.2% | 1067.4 ± 1.5% | 343.1 ± 1.4% | 2.930 | 1.679 | 7.927 | 2.670 | 8.306 |
| string: http/js-1m | 1144362 | 2376.6 ± 1.0% | 1244.6 ± 0.9% | 1059.8 ± 0.3% | 234.0 ± 0.1% | 1112.6 ± 0.5% | 308.5 ± 3.4% | 1.909 | 2.242 | 10.158 | 2.136 | 7.703 |
| string: http/css-1m | 1097820 | 2607.9 ± 0.4% | 2249.1 ± 0.3% | 1558.6 ± 3.5% | 322.5 ± 1.0% | 1646.7 ± 0.4% | 376.0 ± 1.0% | 1.160 | 1.673 | 8.087 | 1.584 | 6.936 |
| string: dickens as Cyrillic and CJK | 1883069 | 4595.8 ± 0.2% | 2851.4 ± 0.2% | 516.3 ± 0.5% | 285.5 ± 0.3% | 393.1 ± 0.7% | 126.6 ± 2.4% | 1.612 | 8.902 | 16.098 | 11.692 | 36.302 |
| string: dickens as Cyrillic and CJK, as \u escapes | 5075485 | 916.5 ± 1.2% | 956.1 ± 0.6% | 851.5 ± 0.6% | 203.7 ± 0.5% | 365.7 ± 0.4% | 171.8 ± 3.5% | 0.959 | 1.076 | 4.499 | 2.506 | 5.334 |
| hex: silesia/dickens | 524290 | 25108.7 ± 0.4% | 11515.6 ± 2.9% | 2694.9 ± 0.4% | 370.5 ± 0.5% | 6439.8 ± 2.5% | 865.0 ± 1.8% | 2.180 | 9.317 | 67.770 | 3.899 | 29.029 |
| hex: silesia/mozilla | 524290 | 25094.0 ± 0.4% | 11594.1 ± 1.9% | 2773.0 ± 0.8% | 315.9 ± 3.8% | 6457.1 ± 0.5% | 863.7 ± 1.0% | 2.164 | 9.049 | 79.429 | 3.886 | 29.056 |
| hex: silesia/mr | 524290 | 25114.7 ± 1.2% | 11615.0 ± 3.8% | 2774.9 ± 0.5% | 479.2 ± 1.8% | 6469.7 ± 4.3% | 867.1 ± 3.2% | 2.162 | 9.051 | 52.411 | 3.882 | 28.963 |
| hex: silesia/nci | 524290 | 25126.8 ± 0.2% | 11515.8 ± 2.1% | 2696.4 ± 2.8% | 594.1 ± 1.9% | 6457.1 ± 0.4% | 856.5 ± 5.0% | 2.182 | 9.319 | 42.291 | 3.891 | 29.337 |
| hex: silesia/ooffice | 524290 | 25113.7 ± 0.2% | 11616.2 ± 0.4% | 2769.1 ± 5.8% | 261.4 ± 1.3% | 6466.9 ± 0.2% | 862.0 ± 1.7% | 2.162 | 9.069 | 96.066 | 3.883 | 29.135 |
| hex: silesia/osdb | 524290 | 25159.1 ± 0.6% | 11621.0 ± 0.8% | 2770.2 ± 0.6% | 355.1 ± 1.2% | 6458.1 ± 0.9% | 859.1 ± 1.3% | 2.165 | 9.082 | 70.859 | 3.896 | 29.285 |
| hex: silesia/reymont | 524290 | 25133.0 ± 0.7% | 11595.8 ± 0.3% | 2699.8 ± 0.6% | 391.1 ± 1.0% | 6459.8 ± 1.1% | 867.8 ± 3.2% | 2.167 | 9.309 | 64.260 | 3.891 | 28.960 |
| hex: silesia/samba | 524290 | 25118.5 ± 0.3% | 11631.4 ± 0.5% | 2768.6 ± 0.3% | 280.9 ± 0.9% | 6459.2 ± 2.8% | 852.3 ± 5.1% | 2.160 | 9.073 | 89.428 | 3.889 | 29.470 |
| hex: silesia/sao | 524290 | 25091.5 ± 0.6% | 11603.7 ± 2.1% | 2689.8 ± 0.2% | 211.2 ± 1.8% | 6455.8 ± 0.4% | 863.0 ± 1.0% | 2.162 | 9.328 | 118.809 | 3.887 | 29.075 |
| hex: silesia/webster | 524290 | 25139.7 ± 1.6% | 11636.0 ± 0.3% | 2769.1 ± 0.5% | 346.4 ± 0.4% | 6455.5 ± 0.3% | 864.8 ± 1.0% | 2.161 | 9.079 | 72.576 | 3.894 | 29.071 |
| hex: silesia/x-ray | 524290 | 25166.7 ± 0.9% | 11636.3 ± 1.1% | 2699.1 ± 0.9% | 325.9 ± 9.0% | 6449.8 ± 0.9% | 865.4 ± 1.7% | 2.163 | 9.324 | 77.230 | 3.902 | 29.082 |
| hex: silesia/xml | 524290 | 25133.7 ± 0.3% | 11602.1 ± 0.9% | 2771.1 ± 1.7% | 577.8 ± 4.0% | 6444.8 ± 1.0% | 863.9 ± 3.4% | 2.166 | 9.070 | 43.499 | 3.900 | 29.093 |
| hex: canterbury/alice29.txt | 304180 | 25040.2 ± 4.2% | 11589.8 ± 0.2% | 2772.8 ± 0.4% | 373.0 ± 1.2% | 6459.0 ± 0.3% | 866.0 ± 3.2% | 2.161 | 9.031 | 67.139 | 3.877 | 28.913 |
| hex: canterbury/asyoulik.txt | 250360 | 25020.1 ± 0.3% | 11701.3 ± 0.4% | 2699.9 ± 0.1% | 366.0 ± 0.6% | 6452.1 ± 0.2% | 864.4 ± 3.2% | 2.138 | 9.267 | 68.369 | 3.878 | 28.946 |
| hex: canterbury/cp.html | 49208 | 25593.7 ± 0.7% | 11792.6 ± 0.6% | 2769.3 ± 0.2% | 388.2 ± 1.5% | 6661.7 ± 0.5% | 836.6 ± 1.2% | 2.170 | 9.242 | 65.928 | 3.842 | 30.594 |
| hex: canterbury/fields.c | 22302 | 25572.0 ± 0.3% | 13011.9 ± 0.4% | 2833.8 ± 0.3% | 476.7 ± 1.1% | 6673.4 ± 0.3% | 814.3 ± 3.0% | 1.965 | 9.024 | 53.645 | 3.832 | 31.402 |
| hex: canterbury/grammar.lsp | 7444 | 22949.1 ± 0.4% | 13798.4 ± 0.6% | 2806.3 ± 0.4% | 605.3 ± 7.9% | 6471.3 ± 0.6% | 778.3 ± 3.1% | 1.663 | 8.178 | 37.913 | 3.546 | 29.485 |
| hex: canterbury/kennedy.xls | 524290 | 25142.8 ± 0.4% | 11656.4 ± 1.5% | 2764.2 ± 0.3% | 595.4 ± 0.6% | 6461.6 ± 0.8% | 830.4 ± 7.1% | 2.157 | 9.096 | 42.227 | 3.891 | 30.278 |
| hex: canterbury/lcet10.txt | 524290 | 25110.5 ± 0.9% | 11619.6 ± 0.8% | 2774.5 ± 5.7% | 373.9 ± 1.3% | 6459.0 ± 0.7% | 837.7 ± 6.1% | 2.161 | 9.051 | 67.157 | 3.888 | 29.977 |
| hex: canterbury/plrabn12.txt | 524290 | 25150.4 ± 0.5% | 11629.4 ± 0.7% | 2772.4 ± 0.4% | 362.9 ± 0.6% | 6452.0 ± 0.6% | 846.8 ± 2.8% | 2.163 | 9.072 | 69.296 | 3.898 | 29.700 |
| hex: canterbury/ptt5 | 524290 | 25096.5 ± 0.8% | 11605.6 ± 1.3% | 2701.7 ± 0.7% | 479.5 ± 1.2% | 6449.8 ± 0.2% | 854.2 ± 2.1% | 2.162 | 9.289 | 52.342 | 3.891 | 29.380 |
| hex: canterbury/sum | 76482 | 24592.2 ± 0.8% | 11528.2 ± 2.9% | 2776.7 ± 0.2% | 427.3 ± 6.0% | 6432.9 ± 0.4% | 846.3 ± 2.0% | 2.133 | 8.857 | 57.553 | 3.823 | 29.059 |
| hex: canterbury/xargs.1 | 8456 | 23360.0 ± 0.4% | 13791.4 ± 2.2% | 2757.2 ± 0.3% | 580.6 ± 5.7% | 6492.8 ± 0.2% | 817.5 ± 3.9% | 1.694 | 8.472 | 40.233 | 3.598 | 28.576 |
| hex: canterbury-large/E.coli | 524290 | 25143.2 ± 1.1% | 11606.3 ± 1.9% | 2699.8 ± 1.7% | 594.4 ± 1.8% | 6463.1 ± 0.4% | 843.2 ± 5.3% | 2.166 | 9.313 | 42.300 | 3.890 | 29.820 |
| hex: canterbury-large/bible.txt | 524290 | 25142.9 ± 0.2% | 11649.5 ± 0.5% | 2699.3 ± 0.6% | 388.9 ± 2.4% | 6461.0 ± 2.1% | 869.7 ± 2.7% | 2.158 | 9.315 | 64.646 | 3.891 | 28.910 |
| hex: canterbury-large/world192.txt | 524290 | 25137.3 ± 0.3% | 11619.7 ± 1.4% | 2770.9 ± 0.2% | 368.2 ± 1.0% | 6492.9 ± 4.6% | 867.5 ± 5.7% | 2.163 | 9.072 | 68.266 | 3.871 | 28.976 |
| hex: http/html-1kx1024 | 2099200 | 13777.5 ± 0.2% | 10310.2 ± 5.3% | 2557.3 ± 1.3% | 385.5 ± 1.4% | 5074.1 ± 2.4% | 698.4 ± 1.2% | 1.336 | 5.388 | 35.738 | 2.715 | 19.726 |
| hex: http/html-16kx64 | 2097280 | 22548.6 ± 0.3% | 11709.6 ± 0.2% | 2638.6 ± 0.5% | 395.3 ± 2.7% | 6269.2 ± 4.7% | 792.1 ± 2.9% | 1.926 | 8.546 | 57.048 | 3.597 | 28.467 |
| hex: http/html-1m | 524290 | 25134.3 ± 0.2% | 11596.7 ± 3.0% | 2698.6 ± 0.2% | 389.4 ± 0.6% | 6449.5 ± 3.7% | 849.2 ± 3.8% | 2.167 | 9.314 | 64.554 | 3.897 | 29.598 |
| hex: http/json-1kx1024 | 2099200 | 13626.2 ± 0.6% | 10124.3 ± 2.9% | 2557.3 ± 0.5% | 561.9 ± 1.2% | 5084.2 ± 5.4% | 707.0 ± 2.1% | 1.346 | 5.328 | 24.249 | 2.680 | 19.273 |
| hex: http/json-16kx64 | 2097280 | 22557.6 ± 0.4% | 11658.0 ± 1.4% | 2642.1 ± 0.2% | 579.8 ± 1.8% | 6227.7 ± 4.1% | 802.3 ± 3.0% | 1.935 | 8.538 | 38.908 | 3.622 | 28.114 |
| hex: http/json-1m | 524290 | 25138.4 ± 1.1% | 11604.8 ± 2.6% | 2751.5 ± 0.2% | 614.2 ± 1.4% | 6463.7 ± 0.4% | 840.3 ± 1.3% | 2.166 | 9.136 | 40.929 | 3.889 | 29.917 |
| hex: http/js-1kx1024 | 2099200 | 13889.2 ± 0.6% | 9825.7 ± 2.8% | 2555.2 ± 0.4% | 378.9 ± 1.0% | 5108.5 ± 6.1% | 696.7 ± 4.5% | 1.414 | 5.436 | 36.653 | 2.719 | 19.937 |
| hex: http/js-16kx64 | 2097280 | 22192.5 ± 0.3% | 11582.0 ± 0.6% | 2633.3 ± 0.8% | 384.7 ± 0.5% | 6117.4 ± 3.6% | 807.3 ± 4.8% | 1.916 | 8.428 | 57.693 | 3.628 | 27.490 |
| hex: http/js-1m | 524290 | 25109.6 ± 0.7% | 11569.3 ± 1.5% | 2770.0 ± 1.9% | 400.2 ± 1.2% | 6457.0 ± 4.2% | 847.5 ± 3.0% | 2.170 | 9.065 | 62.736 | 3.889 | 29.628 |
| hex: http/css-1kx1024 | 2099200 | 13639.3 ± 0.4% | 9977.3 ± 2.6% | 2551.8 ± 0.5% | 436.5 ± 3.0% | 5092.7 ± 4.5% | 694.4 ± 4.2% | 1.367 | 5.345 | 31.245 | 2.678 | 19.642 |
| hex: http/css-16kx64 | 2097280 | 22050.3 ± 0.4% | 11603.3 ± 0.4% | 2634.6 ± 1.4% | 448.3 ± 0.4% | 6123.1 ± 2.1% | 784.5 ± 3.7% | 1.900 | 8.369 | 49.183 | 3.601 | 28.106 |
| hex: http/css-1m | 524290 | 25135.3 ± 0.4% | 11559.0 ± 2.8% | 2744.3 ± 0.5% | 429.9 ± 0.6% | 6470.0 ± 0.6% | 820.9 ± 3.5% | 2.175 | 9.159 | 58.467 | 3.885 | 30.618 |
| hex: shuffled/dickens-1m | 524290 | 25131.7 ± 1.3% | 11574.3 ± 2.1% | 2700.0 ± 0.1% | 371.6 ± 0.6% | 6453.5 ± 0.8% | 843.0 ± 3.6% | 2.171 | 9.308 | 67.634 | 3.894 | 29.813 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1223.4 ± 2.0% | 1148.6 ± 0.4% | 781.3 ± 1.2% | 358.8 ± 0.6% | 324.2 ± 0.7% | 378.6 ± 0.7% | 1.065 | 1.566 | 3.410 | 3.773 | 3.232 |
| qlog records, JSON text sequence | 1467503 | 1014.2 ± 3.5% | 982.0 ± 1.2% | 719.7 ± 1.1% | 337.4 ± 0.5% | 362.6 ± 2.0% | 264.0 ± 3.9% | 1.033 | 1.409 | 3.006 | 2.797 | 3.841 |
| string: silesia/dickens | 172528 | 11276.7 ± 2.8% | 2874.0 ± 5.5% | 2471.3 ± 0.9% | 272.3 ± 2.8% | 1194.6 ± 5.7% | 910.0 ± 8.3% | 3.924 | 4.563 | 41.419 | 9.440 | 12.392 |
| string: silesia/nci | 1075110 | 8966.0 ± 0.4% | 3535.1 ± 0.8% | 2385.4 ± 0.2% | 706.6 ± 0.4% | 1259.4 ± 4.8% | 975.9 ± 0.6% | 2.536 | 3.759 | 12.689 | 7.119 | 9.187 |
| string: silesia/reymont | 1075159 | 4151.9 ± 1.0% | 1435.2 ± 1.3% | 1512.9 ± 1.0% | 296.0 ± 0.3% | 991.4 ± 4.1% | 855.6 ± 0.8% | 2.893 | 2.744 | 14.026 | 4.188 | 4.853 |
| string: silesia/samba | 97582 | 4695.6 ± 0.3% | 2082.1 ± 2.1% | 2956.6 ± 2.0% | 288.6 ± 0.7% | 983.7 ± 1.4% | 944.6 ± 2.2% | 2.255 | 1.588 | 16.268 | 4.773 | 4.971 |
| string: silesia/webster | 1098490 | 5215.1 ± 0.7% | 1504.3 ± 1.4% | 1415.8 ± 1.0% | 293.7 ± 0.7% | 917.8 ± 2.5% | 466.2 ± 0.6% | 3.467 | 3.684 | 17.757 | 5.682 | 11.186 |
| string: silesia/xml | 1090118 | 7869.7 ± 1.2% | 2394.8 ± 1.3% | 2002.0 ± 2.3% | 481.4 ± 0.2% | 1246.1 ± 8.9% | 757.0 ± 0.7% | 3.286 | 3.931 | 16.346 | 6.316 | 10.396 |
| string: canterbury/alice29.txt | 159425 | 10102.0 ± 5.3% | 2190.6 ± 4.9% | 2337.0 ± 0.8% | 261.2 ± 1.7% | 1021.5 ± 5.1% | 835.4 ± 3.5% | 4.611 | 4.323 | 38.670 | 9.890 | 12.092 |
| string: canterbury/asyoulik.txt | 132198 | 8754.8 ± 1.8% | 1627.9 ± 2.3% | 2385.6 ± 0.3% | 266.4 ± 0.6% | 881.5 ± 4.3% | 742.3 ± 1.3% | 5.378 | 3.670 | 32.869 | 9.931 | 11.795 |
| string: canterbury/lcet10.txt | 441884 | 8880.2 ± 2.9% | 2269.4 ± 5.6% | 2075.5 ± 1.6% | 294.5 ± 0.7% | 1093.7 ± 3.3% | 909.5 ± 1.0% | 3.913 | 4.279 | 30.155 | 8.119 | 9.764 |
| string: canterbury/plrabn12.txt | 503330 | 6426.5 ± 2.3% | 1706.2 ± 1.5% | 1639.0 ± 1.7% | 276.7 ± 0.7% | 953.6 ± 1.6% | 794.2 ± 2.5% | 3.767 | 3.921 | 23.229 | 6.739 | 8.091 |
| string: canterbury-large/E.coli | 1048578 | 22062.3 ± 0.6% | 10902.2 ± 0.2% | 2784.5 ± 0.3% | 1315.7 ± 0.6% | 1430.9 ± 11.5% | 1086.4 ± 2.4% | 2.024 | 7.923 | 16.769 | 15.418 | 20.308 |
| string: canterbury-large/bible.txt | 1055886 | 7122.9 ± 1.0% | 3667.6 ± 1.3% | 2405.4 ± 0.7% | 320.4 ± 1.7% | 1469.2 ± 6.5% | 1099.5 ± 1.6% | 1.942 | 2.961 | 22.234 | 4.848 | 6.478 |
| string: canterbury-large/world192.txt | 1103121 | 4952.1 ± 1.2% | 1320.3 ± 2.8% | 1484.4 ± 5.1% | 293.3 ± 1.2% | 919.6 ± 1.2% | 773.8 ± 0.5% | 3.751 | 3.336 | 16.887 | 5.385 | 6.400 |
| string: http/html-1m | 1058582 | 7642.7 ± 0.4% | 3360.1 ± 0.9% | 2339.3 ± 0.7% | 329.1 ± 2.2% | 1378.6 ± 3.2% | 653.6 ± 1.8% | 2.275 | 3.267 | 23.222 | 5.544 | 11.693 |
| string: http/json-1m | 1190272 | 7099.0 ± 0.7% | 1184.5 ± 1.7% | 1262.6 ± 4.0% | 394.4 ± 4.1% | 779.6 ± 1.2% | 660.8 ± 1.8% | 5.993 | 5.623 | 18.000 | 9.106 | 10.743 |
| string: http/js-1m | 1144362 | 5014.6 ± 0.5% | 860.2 ± 1.0% | 1096.0 ± 0.5% | 260.8 ± 1.9% | 761.0 ± 2.9% | 600.4 ± 1.2% | 5.830 | 4.575 | 19.225 | 6.589 | 8.353 |
| string: http/css-1m | 1097820 | 6682.4 ± 0.6% | 1112.6 ± 0.8% | 1620.1 ± 3.7% | 371.1 ± 1.7% | 908.5 ± 1.0% | 756.8 ± 0.9% | 6.006 | 4.125 | 18.008 | 7.355 | 8.830 |
| string: dickens as Cyrillic and CJK | 1883069 | 4312.2 ± 1.0% | 2862.2 ± 0.8% | 360.3 ± 1.0% | 192.1 ± 0.6% | 343.9 ± 4.1% | 277.3 ± 0.2% | 1.507 | 11.969 | 22.449 | 12.538 | 15.550 |
| hex: silesia/dickens | 524290 | 27569.1 ± 0.7% | 1887.4 ± 2.7% | 1179.7 ± 0.5% | 350.6 ± 0.7% | 911.6 ± 2.5% | 821.1 ± 1.9% | 14.607 | 23.370 | 78.641 | 30.242 | 33.577 |
| hex: silesia/mozilla | 524290 | 27445.0 ± 3.0% | 1935.5 ± 2.6% | 1179.5 ± 8.0% | 310.3 ± 5.3% | 913.4 ± 5.0% | 819.9 ± 1.9% | 14.180 | 23.268 | 88.437 | 30.046 | 33.475 |
| hex: silesia/mr | 524290 | 27573.6 ± 0.7% | 1821.2 ± 2.9% | 1176.3 ± 1.7% | 453.4 ± 0.4% | 914.8 ± 2.3% | 821.3 ± 1.6% | 15.140 | 23.442 | 60.812 | 30.143 | 33.573 |
| hex: silesia/nci | 524290 | 31487.0 ± 1.7% | 1910.5 ± 5.7% | 1175.0 ± 0.9% | 596.3 ± 0.3% | 895.4 ± 4.3% | 820.1 ± 0.8% | 16.481 | 26.798 | 52.803 | 35.166 | 38.394 |
| hex: silesia/ooffice | 524290 | 28084.4 ± 0.4% | 1929.4 ± 2.2% | 1180.7 ± 0.3% | 257.1 ± 0.8% | 907.5 ± 2.2% | 820.6 ± 1.1% | 14.556 | 23.786 | 109.227 | 30.948 | 34.224 |
| hex: silesia/osdb | 524290 | 27844.8 ± 0.5% | 1914.6 ± 1.2% | 1178.4 ± 1.1% | 343.4 ± 1.0% | 922.4 ± 4.1% | 820.8 ± 1.3% | 14.544 | 23.629 | 81.075 | 30.187 | 33.923 |
| hex: silesia/reymont | 524290 | 27936.5 ± 1.0% | 1914.7 ± 1.7% | 1179.3 ± 1.5% | 371.8 ± 0.5% | 915.0 ± 3.2% | 823.6 ± 1.1% | 14.591 | 23.689 | 75.135 | 30.531 | 33.922 |
| hex: silesia/samba | 524290 | 31620.2 ± 0.5% | 1921.4 ± 5.7% | 1179.8 ± 1.0% | 273.9 ± 0.7% | 902.9 ± 2.8% | 817.1 ± 1.8% | 16.457 | 26.801 | 115.442 | 35.021 | 38.698 |
| hex: silesia/sao | 524290 | 27994.1 ± 0.2% | 1860.9 ± 6.5% | 1180.3 ± 6.1% | 210.5 ± 0.4% | 902.9 ± 1.5% | 810.9 ± 3.5% | 15.043 | 23.719 | 132.977 | 31.006 | 34.524 |
| hex: silesia/webster | 524290 | 29243.3 ± 1.2% | 1894.6 ± 2.1% | 1179.4 ± 0.8% | 326.2 ± 2.1% | 921.5 ± 2.0% | 820.6 ± 1.6% | 15.435 | 24.794 | 89.650 | 31.734 | 35.638 |
| hex: silesia/x-ray | 524290 | 27564.2 ± 0.1% | 1864.5 ± 6.4% | 1178.9 ± 2.1% | 320.7 ± 1.3% | 925.2 ± 3.7% | 822.0 ± 4.4% | 14.784 | 23.381 | 85.962 | 29.791 | 33.533 |
| hex: silesia/xml | 524290 | 31562.4 ± 0.7% | 1942.9 ± 4.0% | 1180.9 ± 0.6% | 534.7 ± 0.9% | 897.6 ± 1.3% | 816.5 ± 3.2% | 16.245 | 26.728 | 59.032 | 35.163 | 38.655 |
| hex: canterbury/alice29.txt | 304180 | 27904.7 ± 0.1% | 1903.4 ± 8.2% | 1195.7 ± 0.7% | 355.8 ± 4.4% | 939.1 ± 2.2% | 833.7 ± 0.9% | 14.661 | 23.337 | 78.438 | 29.715 | 33.469 |
| hex: canterbury/asyoulik.txt | 250360 | 27572.8 ± 0.4% | 1982.3 ± 9.2% | 1210.3 ± 0.3% | 345.9 ± 0.5% | 909.1 ± 3.4% | 830.1 ± 2.9% | 13.910 | 22.781 | 79.724 | 30.331 | 33.215 |
| hex: canterbury/cp.html | 49208 | 27145.5 ± 0.3% | 1836.4 ± 8.8% | 1197.1 ± 2.1% | 357.5 ± 0.3% | 1050.4 ± 12.3% | 829.2 ± 1.8% | 14.782 | 22.676 | 75.938 | 25.844 | 32.736 |
| hex: canterbury/fields.c | 22302 | 31213.7 ± 4.8% | 1924.3 ± 9.0% | 1199.2 ± 0.6% | 548.3 ± 1.3% | 1006.9 ± 6.7% | 835.4 ± 1.2% | 16.221 | 26.030 | 56.923 | 31.001 | 37.365 |
| hex: canterbury/grammar.lsp | 7444 | 30269.0 ± 0.4% | 1881.8 ± 5.5% | 1209.4 ± 0.4% | 621.7 ± 7.1% | 959.5 ± 11.9% | 837.3 ± 1.8% | 16.085 | 25.029 | 48.688 | 31.548 | 36.150 |
| hex: canterbury/kennedy.xls | 524290 | 27878.8 ± 0.2% | 1826.0 ± 1.7% | 1177.7 ± 0.7% | 588.7 ± 0.5% | 896.3 ± 1.9% | 823.0 ± 3.0% | 15.268 | 23.673 | 47.353 | 31.106 | 33.874 |
| hex: canterbury/lcet10.txt | 524290 | 31534.5 ± 0.7% | 1894.4 ± 2.5% | 1182.8 ± 0.2% | 355.7 ± 2.4% | 883.6 ± 2.4% | 817.9 ± 0.4% | 16.646 | 26.661 | 88.649 | 35.689 | 38.556 |
| hex: canterbury/plrabn12.txt | 524290 | 27571.4 ± 0.5% | 1935.6 ± 4.2% | 1177.6 ± 0.8% | 344.4 ± 0.6% | 912.0 ± 2.0% | 816.0 ± 5.4% | 14.244 | 23.414 | 80.055 | 30.233 | 33.787 |
| hex: canterbury/ptt5 | 524290 | 27685.1 ± 0.1% | 1894.1 ± 4.9% | 1176.5 ± 0.4% | 456.8 ± 0.3% | 900.9 ± 4.6% | 818.2 ± 2.2% | 14.616 | 23.532 | 60.601 | 30.731 | 33.838 |
| hex: canterbury/sum | 76482 | 27380.3 ± 0.7% | 1900.3 ± 5.0% | 1182.9 ± 1.3% | 436.8 ± 0.4% | 1011.0 ± 5.8% | 837.6 ± 1.7% | 14.409 | 23.146 | 62.687 | 27.082 | 32.690 |
| hex: canterbury/xargs.1 | 8456 | 29794.9 ± 0.5% | 1891.4 ± 9.9% | 1208.8 ± 6.6% | 624.5 ± 0.7% | 917.9 ± 16.4% | 843.7 ± 0.7% | 15.753 | 24.649 | 47.710 | 32.460 | 35.316 |
| hex: canterbury-large/E.coli | 524290 | 27303.6 ± 0.5% | 1878.0 ± 5.0% | 1179.0 ± 0.7% | 608.0 ± 1.4% | 917.2 ± 3.1% | 817.6 ± 2.0% | 14.539 | 23.159 | 44.911 | 29.770 | 33.394 |
| hex: canterbury-large/bible.txt | 524290 | 31466.7 ± 0.6% | 1841.6 ± 5.5% | 1183.3 ± 0.7% | 367.1 ± 0.3% | 888.5 ± 5.6% | 816.4 ± 2.5% | 17.086 | 26.592 | 85.706 | 35.417 | 38.543 |
| hex: canterbury-large/world192.txt | 524290 | 28014.4 ± 0.3% | 1909.0 ± 2.5% | 1181.7 ± 0.4% | 347.8 ± 0.7% | 907.6 ± 1.4% | 823.6 ± 4.7% | 14.675 | 23.708 | 80.545 | 30.867 | 34.017 |
| hex: http/html-1kx1024 | 2099200 | 17819.6 ± 0.5% | 1833.6 ± 0.2% | 1112.9 ± 0.2% | 374.1 ± 0.4% | 876.1 ± 2.4% | 801.5 ± 2.5% | 9.719 | 16.012 | 47.636 | 20.340 | 22.233 |
| hex: http/html-16kx64 | 2097280 | 18895.1 ± 1.5% | 1794.6 ± 2.7% | 1131.0 ± 0.3% | 373.1 ± 0.2% | 922.8 ± 4.4% | 825.3 ± 2.6% | 10.529 | 16.706 | 50.650 | 20.477 | 22.895 |
| hex: http/html-1m | 524290 | 27187.9 ± 0.3% | 1833.1 ± 7.2% | 1178.8 ± 0.8% | 359.8 ± 0.8% | 894.2 ± 2.7% | 820.1 ± 0.6% | 14.832 | 23.064 | 75.560 | 30.404 | 33.150 |
| hex: http/json-1kx1024 | 2099200 | 17568.9 ± 0.6% | 1831.2 ± 0.4% | 1111.5 ± 2.2% | 539.3 ± 0.5% | 887.3 ± 2.7% | 804.2 ± 1.3% | 9.594 | 15.806 | 32.580 | 19.801 | 21.846 |
| hex: http/json-16kx64 | 2097280 | 18516.5 ± 0.7% | 1817.7 ± 1.1% | 1128.2 ± 0.1% | 546.9 ± 0.5% | 930.9 ± 8.9% | 826.4 ± 0.9% | 10.187 | 16.413 | 33.855 | 19.890 | 22.407 |
| hex: http/json-1m | 524290 | 27910.0 ± 3.8% | 1935.1 ± 0.5% | 1181.4 ± 2.8% | 581.8 ± 0.9% | 905.8 ± 1.7% | 820.1 ± 1.3% | 14.423 | 23.625 | 47.975 | 30.813 | 34.034 |
| hex: http/js-1kx1024 | 2099200 | 17971.0 ± 1.6% | 1833.2 ± 0.5% | 1112.2 ± 0.3% | 369.1 ± 0.6% | 869.8 ± 3.2% | 807.1 ± 5.7% | 9.803 | 16.158 | 48.689 | 20.661 | 22.266 |
| hex: http/js-16kx64 | 2097280 | 18777.0 ± 0.4% | 1795.2 ± 1.1% | 1132.8 ± 0.1% | 371.1 ± 2.1% | 957.8 ± 13.3% | 822.8 ± 11.8% | 10.459 | 16.576 | 50.604 | 19.604 | 22.820 |
| hex: http/js-1m | 524290 | 27958.5 ± 1.0% | 1897.1 ± 2.6% | 1173.5 ± 0.6% | 380.4 ± 3.6% | 893.0 ± 4.4% | 822.9 ± 1.2% | 14.737 | 23.824 | 73.500 | 31.310 | 33.976 |
| hex: http/css-1kx1024 | 2099200 | 18002.9 ± 0.3% | 1833.3 ± 0.2% | 1112.0 ± 0.8% | 413.3 ± 0.6% | 874.8 ± 4.0% | 808.3 ± 2.8% | 9.820 | 16.190 | 43.560 | 20.579 | 22.274 |
| hex: http/css-16kx64 | 2097280 | 18356.4 ± 0.2% | 1795.5 ± 8.4% | 1132.9 ± 1.5% | 418.7 ± 4.1% | 938.6 ± 8.5% | 829.4 ± 1.6% | 10.224 | 16.203 | 43.839 | 19.558 | 22.132 |
| hex: http/css-1m | 524290 | 27984.3 ± 5.4% | 1917.1 ± 1.2% | 1181.3 ± 3.4% | 402.3 ± 0.7% | 901.4 ± 5.7% | 818.3 ± 1.3% | 14.597 | 23.689 | 69.557 | 31.046 | 34.199 |
| hex: shuffled/dickens-1m | 524290 | 27966.4 ± 0.4% | 1901.3 ± 3.4% | 1181.4 ± 0.4% | 351.3 ± 0.8% | 914.8 ± 4.7% | 819.6 ± 1.1% | 14.709 | 23.673 | 79.599 | 30.569 | 34.124 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding: stdx runs at 0.903 of simdjson.
- qlog records, JSON text sequence, decoding: stdx runs at 0.830 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.761 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.780 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.907 of yyjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next_items: stdx runs at 0.866 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next_items: stdx runs at 0.888 of simdjson.
