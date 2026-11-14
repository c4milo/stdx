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
| Run URL | https://github.com/c4milo/stdx/actions/runs/43483791171 |
| Date | 2026-11-13 |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1. The `TextReader.next_items` column is that helper's queued tokens a slice a call (decision 79), over many tokens a call.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | TextReader.next_items | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1060.5 ± 1.8% | 0.491 | 1.030 | 1.077 | 1.082 | 0.411 | 1.080 | 1.081 | 0.373 | 0.846 | 0.961 | 0.107 |
| qlog records, JSON text sequence | 1467503 | 810.4 ± 1.4% | 0.851 | 1.068 | 1.077 | 1.078 | 0.420 | 1.073 | 1.078 | 0.388 | 0.946 | 1.080 | 0.133 |
| string: silesia/dickens | 172528 | 5401.8 ± 1.3% | 0.028 | 0.661 | 1.056 | 1.053 | 0.182 | 1.016 | 1.074 | 0.182 | 0.998 | 1.005 | 0.028 |
| string: silesia/nci | 1075110 | 4022.2 ± 0.8% | 0.037 | 0.756 | 1.128 | 1.141 | 0.296 | 1.124 | 1.138 | 0.295 | 0.994 | 1.003 | 0.037 |
| string: silesia/reymont | 1075159 | 3190.8 ± 2.4% | 0.048 | 0.551 | 0.735 | 0.735 | 0.288 | 0.718 | 0.745 | 0.288 | 0.966 | 0.980 | 0.048 |
| string: silesia/samba | 97582 | 3074.7 ± 0.6% | 0.042 | 0.904 | 1.072 | 1.081 | 0.076 | 0.831 | 1.078 | 0.076 | 0.998 | 1.005 | 0.042 |
| string: silesia/webster | 1098490 | 3489.2 ± 0.9% | 0.042 | 0.648 | 0.976 | 0.979 | 0.201 | 0.922 | 0.983 | 0.201 | 0.981 | 1.001 | 0.042 |
| string: silesia/xml | 1090118 | 4930.5 ± 0.8% | 0.031 | 0.768 | 0.937 | 0.947 | 0.234 | 0.934 | 0.948 | 0.235 | 0.991 | 1.004 | 0.031 |
| string: canterbury/alice29.txt | 159425 | 4544.4 ± 1.5% | 0.033 | 0.759 | 1.128 | 1.080 | 0.169 | 1.055 | 1.169 | 0.170 | 0.995 | 1.012 | 0.033 |
| string: canterbury/asyoulik.txt | 132198 | 3434.6 ± 1.4% | 0.041 | 0.821 | 1.144 | 1.150 | 0.179 | 1.135 | 1.169 | 0.179 | 0.986 | 1.001 | 0.042 |
| string: canterbury/lcet10.txt | 441884 | 5304.6 ± 1.5% | 0.029 | 0.585 | 1.082 | 1.074 | 0.177 | 1.025 | 1.095 | 0.179 | 0.984 | 0.997 | 0.029 |
| string: canterbury/plrabn12.txt | 503330 | 4330.5 ± 1.6% | 0.035 | 0.764 | 0.996 | 1.001 | 0.206 | 0.891 | 1.008 | 0.207 | 0.988 | 1.003 | 0.035 |
| string: canterbury-large/E.coli | 1048578 | 22783.0 ± 1.4% | 0.061 | 0.993 | 0.848 | 1.000 | 0.521 | 1.000 | 1.000 | 0.522 | 1.113 | 1.111 | 0.007 |
| string: canterbury-large/bible.txt | 1055886 | 6930.8 ± 3.4% | 0.023 | 0.602 | 0.841 | 0.837 | 0.357 | 0.868 | 0.828 | 0.358 | 0.985 | 0.997 | 0.023 |
| string: canterbury-large/world192.txt | 1103121 | 3403.2 ± 2.3% | 0.043 | 0.667 | 0.930 | 0.935 | 0.189 | 0.891 | 0.929 | 0.188 | 0.994 | 1.012 | 0.043 |
| string: http/html-1m | 1058582 | 7358.5 ± 1.0% | 0.021 | 0.548 | 0.766 | 0.768 | 0.304 | 0.741 | 0.771 | 0.304 | 0.939 | 1.017 | 0.022 |
| string: http/json-1m | 1190272 | 2841.4 ± 0.8% | 0.047 | 0.360 | 0.424 | 0.423 | 0.122 | 0.438 | 0.425 | 0.122 | 1.003 | 1.007 | 0.047 |
| string: http/js-1m | 1144362 | 2382.5 ± 0.8% | 0.058 | 0.644 | 0.823 | 0.835 | 0.168 | 0.788 | 0.836 | 0.167 | 1.000 | 1.003 | 0.058 |
| string: http/css-1m | 1097820 | 2591.7 ± 1.1% | 0.055 | 0.767 | 0.978 | 0.982 | 0.267 | 0.988 | 0.981 | 0.266 | 0.998 | 1.011 | 0.055 |
| string: dickens as Cyrillic and CJK | 1883069 | 4610.3 ± 0.9% | 0.025 | 0.061 | 0.449 | 0.445 | 0.192 | 0.445 | 0.448 | 0.192 | 0.999 | 1.005 | 0.024 |
| string: dickens as Cyrillic and CJK, as \u escapes | 5075485 | 919.2 ± 1.0% | 0.116 | 0.990 | 0.991 | 0.989 | 0.110 | 0.722 | 0.991 | 0.110 | 1.004 | 1.000 | 0.116 |
| hex: silesia/dickens | 524290 | 31440.3 ± 1.4% | 0.045 | 1.003 | 0.691 | 0.999 | 0.436 | 1.003 | 0.999 | 0.437 | 0.807 | 0.806 | 0.005 |
| hex: silesia/mozilla | 524290 | 31895.0 ± 0.9% | 0.044 | 1.005 | 0.689 | 1.003 | 0.429 | 1.002 | 1.002 | 0.430 | 0.791 | 0.793 | 0.005 |
| hex: silesia/mr | 524290 | 31774.5 ± 1.2% | 0.044 | 1.004 | 0.674 | 1.003 | 0.433 | 1.004 | 1.007 | 0.433 | 0.792 | 0.797 | 0.005 |
| hex: silesia/nci | 524290 | 31368.3 ± 0.9% | 0.045 | 1.006 | 0.692 | 1.006 | 0.436 | 1.005 | 1.007 | 0.436 | 0.809 | 0.807 | 0.005 |
| hex: silesia/ooffice | 524290 | 32533.0 ± 0.5% | 0.043 | 1.002 | 0.670 | 1.004 | 0.422 | 1.005 | 1.003 | 0.422 | 0.778 | 0.774 | 0.005 |
| hex: silesia/osdb | 524290 | 32498.7 ± 1.1% | 0.043 | 1.003 | 0.656 | 1.006 | 0.421 | 1.003 | 1.006 | 0.423 | 0.779 | 0.775 | 0.005 |
| hex: silesia/reymont | 524290 | 30821.4 ± 0.8% | 0.046 | 1.002 | 0.705 | 1.002 | 0.438 | 0.999 | 1.001 | 0.436 | 0.818 | 0.820 | 0.005 |
| hex: silesia/samba | 524290 | 32714.8 ± 0.7% | 0.043 | 0.998 | 0.666 | 1.001 | 0.418 | 1.005 | 1.004 | 0.418 | 0.769 | 0.774 | 0.005 |
| hex: silesia/sao | 524290 | 32618.1 ± 2.5% | 0.043 | 1.002 | 0.665 | 1.001 | 0.417 | 0.999 | 1.002 | 0.416 | 0.775 | 0.775 | 0.005 |
| hex: silesia/webster | 524290 | 30821.6 ± 2.3% | 0.046 | 1.002 | 0.690 | 1.001 | 0.437 | 1.001 | 1.003 | 0.437 | 0.820 | 0.822 | 0.005 |
| hex: silesia/x-ray | 524290 | 32020.6 ± 1.2% | 0.044 | 1.002 | 0.669 | 0.999 | 0.427 | 0.999 | 1.003 | 0.427 | 0.789 | 0.793 | 0.005 |
| hex: silesia/xml | 524290 | 30733.0 ± 1.1% | 0.046 | 1.002 | 0.716 | 1.001 | 0.445 | 1.001 | 1.004 | 0.445 | 0.821 | 0.818 | 0.005 |
| hex: canterbury/alice29.txt | 304180 | 31813.7 ± 4.9% | 0.044 | 0.998 | 0.689 | 1.005 | 0.430 | 1.001 | 0.999 | 0.430 | 0.792 | 0.790 | 0.005 |
| hex: canterbury/asyoulik.txt | 250360 | 31745.8 ± 4.2% | 0.044 | 1.000 | 0.669 | 1.004 | 0.428 | 1.002 | 1.001 | 0.428 | 0.789 | 0.795 | 0.005 |
| hex: canterbury/cp.html | 49208 | 31207.5 ± 1.6% | 0.045 | 1.000 | 0.684 | 0.999 | 0.426 | 1.003 | 1.002 | 0.428 | 0.823 | 0.827 | 0.005 |
| hex: canterbury/fields.c | 22302 | 35650.5 ± 0.8% | 0.040 | 1.005 | 0.597 | 1.002 | 0.407 | 0.997 | 0.999 | 0.416 | 0.720 | 0.720 | 0.005 |
| hex: canterbury/grammar.lsp | 7444 | 32051.7 ± 3.2% | 0.045 | 1.010 | 0.625 | 1.009 | 0.443 | 1.004 | 1.009 | 0.470 | 0.722 | 0.720 | 0.005 |
| hex: canterbury/kennedy.xls | 524290 | 32779.9 ± 1.8% | 0.043 | 0.997 | 0.663 | 1.001 | 0.416 | 0.996 | 0.996 | 0.419 | 0.774 | 0.770 | 0.005 |
| hex: canterbury/lcet10.txt | 524290 | 31714.3 ± 0.7% | 0.045 | 1.006 | 0.685 | 1.003 | 0.433 | 1.002 | 1.006 | 0.432 | 0.793 | 0.797 | 0.005 |
| hex: canterbury/plrabn12.txt | 524290 | 32502.3 ± 1.6% | 0.043 | 1.004 | 0.668 | 1.005 | 0.421 | 1.005 | 1.001 | 0.423 | 0.776 | 0.776 | 0.005 |
| hex: canterbury/ptt5 | 524290 | 32495.2 ± 2.2% | 0.043 | 1.003 | 0.660 | 1.001 | 0.422 | 1.004 | 1.004 | 0.424 | 0.781 | 0.778 | 0.005 |
| hex: canterbury/sum | 76482 | 30958.4 ± 1.0% | 0.045 | 1.007 | 0.685 | 1.004 | 0.433 | 1.004 | 1.005 | 0.436 | 0.795 | 0.797 | 0.005 |
| hex: canterbury/xargs.1 | 8456 | 32799.0 ± 0.7% | 0.044 | 1.007 | 0.610 | 1.014 | 0.440 | 1.012 | 1.009 | 0.460 | 0.720 | 0.716 | 0.005 |
| hex: canterbury-large/E.coli | 524290 | 32237.7 ± 2.1% | 0.044 | 0.997 | 0.675 | 0.992 | 0.426 | 0.989 | 0.992 | 0.425 | 0.784 | 0.789 | 0.005 |
| hex: canterbury-large/bible.txt | 524290 | 32746.6 ± 1.7% | 0.043 | 1.001 | 0.651 | 0.999 | 0.419 | 0.994 | 1.001 | 0.420 | 0.771 | 0.772 | 0.005 |
| hex: canterbury-large/world192.txt | 524290 | 31923.8 ± 1.4% | 0.044 | 1.002 | 0.688 | 0.999 | 0.430 | 1.000 | 0.998 | 0.430 | 0.791 | 0.795 | 0.005 |
| hex: http/html-1kx1024 | 2099200 | 15673.7 ± 1.4% | 0.090 | 1.008 | 0.824 | 1.004 | 0.583 | 1.009 | 1.002 | 0.652 | 0.908 | 0.894 | 0.010 |
| hex: http/html-16kx64 | 2097280 | 25654.0 ± 0.8% | 0.054 | 1.004 | 0.751 | 0.998 | 0.509 | 1.007 | 1.005 | 0.513 | 0.885 | 0.886 | 0.006 |
| hex: http/html-1m | 524290 | 31938.0 ± 1.6% | 0.044 | 0.998 | 0.688 | 1.004 | 0.429 | 1.005 | 1.002 | 0.428 | 0.793 | 0.792 | 0.005 |
| hex: http/json-1kx1024 | 2099200 | 15692.9 ± 1.0% | 0.089 | 1.002 | 0.823 | 1.001 | 0.568 | 1.003 | 0.999 | 0.632 | 0.902 | 0.892 | 0.010 |
| hex: http/json-16kx64 | 2097280 | 25861.1 ± 2.7% | 0.054 | 0.998 | 0.748 | 1.003 | 0.509 | 1.001 | 0.997 | 0.514 | 0.877 | 0.878 | 0.006 |
| hex: http/json-1m | 524290 | 31366.0 ± 0.7% | 0.045 | 1.001 | 0.696 | 0.999 | 0.436 | 1.006 | 1.002 | 0.436 | 0.808 | 0.804 | 0.005 |
| hex: http/js-1kx1024 | 2099200 | 15480.9 ± 1.5% | 0.091 | 1.006 | 0.835 | 1.008 | 0.573 | 1.009 | 1.010 | 0.639 | 0.913 | 0.898 | 0.010 |
| hex: http/js-16kx64 | 2097280 | 25694.3 ± 1.0% | 0.055 | 1.004 | 0.744 | 1.004 | 0.507 | 1.002 | 1.000 | 0.512 | 0.879 | 0.878 | 0.006 |
| hex: http/js-1m | 524290 | 32711.6 ± 1.5% | 0.043 | 0.995 | 0.668 | 0.996 | 0.416 | 0.999 | 1.002 | 0.416 | 0.772 | 0.775 | 0.005 |
| hex: http/css-1kx1024 | 2099200 | 15730.9 ± 0.4% | 0.089 | 1.004 | 0.825 | 1.011 | 0.587 | 1.006 | 1.004 | 0.656 | 0.905 | 0.893 | 0.010 |
| hex: http/css-16kx64 | 2097280 | 25684.3 ± 2.6% | 0.055 | 1.004 | 0.742 | 1.005 | 0.505 | 1.003 | 1.003 | 0.509 | 0.880 | 0.880 | 0.006 |
| hex: http/css-1m | 524290 | 31819.2 ± 1.1% | 0.044 | 1.006 | 0.669 | 1.008 | 0.430 | 1.007 | 1.003 | 0.430 | 0.796 | 0.795 | 0.005 |
| hex: shuffled/dickens-1m | 524290 | 31786.2 ± 1.5% | 0.044 | 1.004 | 0.692 | 0.998 | 0.420 | 1.004 | 1.000 | 0.420 | 0.794 | 0.795 | 0.005 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1416.5 ± 2.0% | 0.407 | 0.963 | 0.954 | 0.987 | 0.990 | 0.262 | 0.990 | 0.480 | 0.876 | 0.097 | 1.009 |
| qlog records, JSON text sequence | 1467503 | 1150.2 ± 1.1% | 0.695 | 0.955 | 0.991 | 1.016 | 0.990 | 0.269 | 0.990 | 0.479 | 0.905 | 0.134 | 1.051 |
| string: silesia/dickens | 172528 | 11074.3 ± 2.8% | 0.016 | 0.486 | 0.324 | 0.482 | 0.505 | 0.105 | 0.505 | 1.001 | 1.032 | 0.016 | 1.039 |
| string: silesia/nci | 1075110 | 8977.2 ± 1.2% | 0.019 | 0.520 | 0.358 | 0.512 | 0.520 | 0.175 | 0.521 | 1.003 | 1.005 | 0.019 | 1.053 |
| string: silesia/reymont | 1075159 | 4138.3 ± 1.4% | 0.041 | 0.553 | 0.431 | 0.510 | 0.555 | 0.265 | 0.552 | 1.002 | 1.010 | 0.041 | 1.039 |
| string: silesia/samba | 97582 | 4714.6 ± 1.0% | 0.046 | 0.887 | 0.729 | 0.907 | 0.893 | 0.121 | 0.902 | 0.998 | 0.997 | 0.046 | 1.104 |
| string: silesia/webster | 1098490 | 5240.7 ± 0.9% | 0.032 | 0.591 | 0.439 | 0.568 | 0.590 | 0.158 | 0.588 | 1.001 | 0.997 | 0.032 | 1.041 |
| string: silesia/xml | 1090118 | 7945.0 ± 1.2% | 0.022 | 0.579 | 0.481 | 0.576 | 0.577 | 0.213 | 0.580 | 1.005 | 1.012 | 0.022 | 1.158 |
| string: canterbury/alice29.txt | 159425 | 10347.9 ± 2.6% | 0.016 | 0.449 | 0.341 | 0.413 | 0.459 | 0.085 | 0.476 | 0.960 | 1.021 | 0.016 | 1.057 |
| string: canterbury/asyoulik.txt | 132198 | 8853.9 ± 4.0% | 0.018 | 0.396 | 0.316 | 0.388 | 0.408 | 0.082 | 0.413 | 0.989 | 1.028 | 0.018 | 1.084 |
| string: canterbury/lcet10.txt | 441884 | 8651.6 ± 2.0% | 0.020 | 0.617 | 0.369 | 0.586 | 0.617 | 0.128 | 0.619 | 1.005 | 1.032 | 0.020 | 1.207 |
| string: canterbury/plrabn12.txt | 503330 | 6345.7 ± 2.0% | 0.027 | 0.657 | 0.539 | 0.661 | 0.658 | 0.165 | 0.656 | 1.013 | 1.019 | 0.027 | 1.126 |
| string: canterbury-large/E.coli | 1048578 | 24761.4 ± 0.8% | 0.056 | 1.005 | 0.998 | 0.801 | 0.996 | 0.493 | 1.002 | 0.998 | 1.006 | 0.007 | 1.000 |
| string: canterbury-large/bible.txt | 1055886 | 7089.4 ± 1.1% | 0.025 | 0.743 | 0.598 | 0.738 | 0.755 | 0.395 | 0.749 | 1.009 | 1.006 | 0.025 | 1.109 |
| string: canterbury-large/world192.txt | 1103121 | 4962.1 ± 2.0% | 0.034 | 0.595 | 0.467 | 0.576 | 0.594 | 0.152 | 0.595 | 0.999 | 0.998 | 0.034 | 1.049 |
| string: http/html-1m | 1058582 | 7672.8 ± 1.7% | 0.023 | 0.641 | 0.549 | 0.598 | 0.641 | 0.322 | 0.645 | 1.002 | 1.003 | 0.023 | 1.013 |
| string: http/json-1m | 1190272 | 7091.5 ± 0.6% | 0.023 | 0.179 | 0.149 | 0.180 | 0.179 | 0.066 | 0.179 | 1.003 | 1.006 | 0.023 | 0.987 |
| string: http/js-1m | 1144362 | 5021.5 ± 0.7% | 0.032 | 0.360 | 0.309 | 0.347 | 0.360 | 0.091 | 0.360 | 1.000 | 1.005 | 0.032 | 1.054 |
| string: http/css-1m | 1097820 | 6739.7 ± 0.7% | 0.024 | 0.368 | 0.305 | 0.358 | 0.368 | 0.128 | 0.369 | 0.998 | 1.000 | 0.024 | 1.265 |
| string: dickens as Cyrillic and CJK | 1883069 | 4328.7 ± 1.3% | 0.030 | 0.461 | 0.065 | 0.460 | 0.463 | 0.203 | 0.464 | 0.995 | 0.997 | 0.030 | 1.017 |
| hex: silesia/dickens | 524290 | 27655.9 ± 1.8% | 1.002 | 0.099 | 0.998 | 0.686 | 1.001 | 1.003 | 1.000 | 1.000 | 0.998 | 0.106 | 1.000 |
| hex: silesia/mozilla | 524290 | 27431.8 ± 1.0% | 1.005 | 0.100 | 1.007 | 0.693 | 1.004 | 1.004 | 1.004 | 1.005 | 1.006 | 0.106 | 1.002 |
| hex: silesia/mr | 524290 | 27650.3 ± 4.7% | 1.005 | 0.099 | 1.002 | 0.649 | 1.006 | 1.000 | 1.000 | 1.000 | 1.005 | 0.107 | 1.000 |
| hex: silesia/nci | 524290 | 31550.8 ± 0.9% | 1.007 | 0.087 | 1.006 | 0.567 | 1.014 | 1.004 | 1.006 | 1.010 | 1.005 | 0.094 | 1.009 |
| hex: silesia/ooffice | 524290 | 28114.4 ± 2.4% | 1.007 | 0.098 | 1.001 | 0.665 | 1.007 | 1.002 | 1.003 | 1.007 | 1.004 | 0.104 | 1.005 |
| hex: silesia/osdb | 524290 | 28003.0 ± 0.9% | 1.003 | 0.098 | 1.002 | 0.668 | 1.000 | 1.004 | 1.000 | 1.000 | 1.002 | 0.106 | 1.003 |
| hex: silesia/reymont | 524290 | 28194.2 ± 4.8% | 0.997 | 0.098 | 0.995 | 0.649 | 0.996 | 1.002 | 0.998 | 0.998 | 0.992 | 0.106 | 0.995 |
| hex: silesia/samba | 524290 | 31623.6 ± 1.3% | 1.004 | 0.087 | 1.003 | 0.598 | 1.004 | 1.004 | 1.006 | 1.001 | 1.001 | 0.093 | 1.005 |
| hex: silesia/sao | 524290 | 28229.5 ± 0.8% | 0.997 | 0.097 | 0.996 | 0.666 | 1.001 | 0.996 | 0.994 | 0.996 | 1.003 | 0.103 | 1.003 |
| hex: silesia/webster | 524290 | 29297.0 ± 1.4% | 1.001 | 0.094 | 1.001 | 0.604 | 0.999 | 1.000 | 1.003 | 1.002 | 1.000 | 0.100 | 0.999 |
| hex: silesia/x-ray | 524290 | 27661.5 ± 1.0% | 1.004 | 0.099 | 1.005 | 0.683 | 1.006 | 0.998 | 1.000 | 1.000 | 1.003 | 0.107 | 0.999 |
| hex: silesia/xml | 524290 | 31555.5 ± 2.1% | 1.005 | 0.087 | 1.004 | 0.596 | 1.009 | 1.002 | 1.005 | 1.015 | 1.003 | 0.092 | 1.007 |
| hex: canterbury/alice29.txt | 304180 | 27984.7 ± 1.4% | 1.004 | 0.098 | 1.002 | 0.674 | 1.000 | 1.004 | 1.006 | 1.000 | 1.005 | 0.103 | 1.002 |
| hex: canterbury/asyoulik.txt | 250360 | 27831.4 ± 1.3% | 0.995 | 0.099 | 0.995 | 0.676 | 1.000 | 0.994 | 1.002 | 1.000 | 0.996 | 0.107 | 0.996 |
| hex: canterbury/cp.html | 49208 | 26936.7 ± 0.4% | 1.005 | 0.102 | 1.003 | 0.673 | 1.005 | 1.002 | 1.006 | 1.007 | 1.010 | 0.106 | 1.011 |
| hex: canterbury/fields.c | 22302 | 31310.2 ± 1.0% | 0.997 | 0.087 | 0.994 | 0.566 | 0.993 | 0.982 | 0.998 | 0.997 | 1.002 | 0.088 | 0.995 |
| hex: canterbury/grammar.lsp | 7444 | 26283.0 ± 1.7% | 1.001 | 0.103 | 0.997 | 0.590 | 1.002 | 0.976 | 1.003 | 1.006 | 1.021 | 0.109 | 1.003 |
| hex: canterbury/kennedy.xls | 524290 | 27857.9 ± 4.9% | 1.010 | 0.099 | 1.005 | 0.678 | 1.006 | 1.006 | 1.009 | 1.009 | 1.009 | 0.103 | 1.005 |
| hex: canterbury/lcet10.txt | 524290 | 31730.2 ± 2.1% | 1.003 | 0.087 | 1.005 | 0.599 | 0.997 | 1.000 | 0.998 | 1.000 | 1.003 | 0.094 | 0.999 |
| hex: canterbury/plrabn12.txt | 524290 | 27648.2 ± 1.5% | 1.002 | 0.099 | 1.001 | 0.682 | 1.003 | 1.006 | 1.010 | 1.001 | 1.007 | 0.107 | 1.011 |
| hex: canterbury/ptt5 | 524290 | 27807.3 ± 1.4% | 1.003 | 0.099 | 1.001 | 0.675 | 1.002 | 1.002 | 0.998 | 0.997 | 1.005 | 0.107 | 1.004 |
| hex: canterbury/sum | 76482 | 27307.7 ± 0.8% | 1.007 | 0.100 | 1.006 | 0.675 | 1.007 | 0.997 | 1.005 | 1.011 | 1.017 | 0.102 | 1.008 |
| hex: canterbury/xargs.1 | 8456 | 29265.9 ± 3.6% | 1.010 | 0.093 | 1.004 | 0.563 | 1.002 | 0.959 | 1.001 | 1.004 | 1.024 | 0.096 | 1.006 |
| hex: canterbury-large/E.coli | 524290 | 27647.4 ± 1.9% | 1.003 | 0.099 | 0.999 | 0.685 | 0.997 | 0.999 | 0.997 | 1.001 | 1.005 | 0.107 | 0.998 |
| hex: canterbury-large/bible.txt | 524290 | 31931.2 ± 1.8% | 0.999 | 0.086 | 0.999 | 0.595 | 0.996 | 0.995 | 0.991 | 0.990 | 0.989 | 0.092 | 0.993 |
| hex: canterbury-large/world192.txt | 524290 | 28103.3 ± 1.7% | 1.004 | 0.098 | 1.002 | 0.661 | 1.002 | 1.002 | 1.004 | 1.008 | 1.002 | 0.105 | 1.002 |
| hex: http/html-1kx1024 | 2099200 | 18148.3 ± 2.6% | 1.001 | 0.146 | 1.003 | 0.869 | 1.007 | 0.964 | 1.006 | 1.010 | 1.017 | 0.152 | 1.009 |
| hex: http/html-16kx64 | 2097280 | 18545.1 ± 1.2% | 1.004 | 0.147 | 1.008 | 0.934 | 1.005 | 0.995 | 1.006 | 1.003 | 1.008 | 0.157 | 1.006 |
| hex: http/html-1m | 524290 | 27228.0 ± 0.6% | 1.003 | 0.101 | 0.999 | 0.695 | 0.999 | 0.999 | 1.001 | 1.002 | 1.004 | 0.109 | 1.003 |
| hex: http/json-1kx1024 | 2099200 | 18062.1 ± 0.6% | 1.002 | 0.147 | 0.998 | 0.869 | 0.997 | 0.965 | 1.000 | 1.000 | 1.013 | 0.150 | 1.005 |
| hex: http/json-16kx64 | 2097280 | 19233.2 ± 0.6% | 1.006 | 0.142 | 1.003 | 0.898 | 1.004 | 0.996 | 1.006 | 1.000 | 1.009 | 0.142 | 1.004 |
| hex: http/json-1m | 524290 | 28030.6 ± 0.9% | 1.004 | 0.098 | 1.001 | 0.663 | 1.001 | 0.999 | 0.999 | 0.998 | 0.999 | 0.103 | 1.003 |
| hex: http/js-1kx1024 | 2099200 | 17837.0 ± 0.8% | 1.009 | 0.148 | 1.005 | 0.884 | 1.003 | 0.976 | 1.005 | 1.004 | 1.020 | 0.155 | 1.009 |
| hex: http/js-16kx64 | 2097280 | 19235.1 ± 0.5% | 1.009 | 0.142 | 1.008 | 0.899 | 1.010 | 1.001 | 1.010 | 1.009 | 1.007 | 0.152 | 1.007 |
| hex: http/js-1m | 524290 | 28066.1 ± 0.9% | 1.001 | 0.098 | 1.004 | 0.675 | 1.000 | 0.997 | 1.000 | 1.002 | 1.000 | 0.105 | 1.000 |
| hex: http/css-1kx1024 | 2099200 | 17714.2 ± 1.8% | 1.006 | 0.149 | 1.005 | 0.883 | 1.003 | 0.973 | 1.003 | 1.005 | 1.011 | 0.154 | 1.011 |
| hex: http/css-16kx64 | 2097280 | 19117.6 ± 1.0% | 1.006 | 0.142 | 1.007 | 0.896 | 1.004 | 1.001 | 1.005 | 1.003 | 1.005 | 0.144 | 1.006 |
| hex: http/css-1m | 524290 | 27932.7 ± 0.3% | 1.002 | 0.098 | 1.001 | 0.662 | 0.999 | 1.000 | 1.001 | 0.998 | 1.000 | 0.105 | 1.002 |
| hex: shuffled/dickens-1m | 524290 | 27826.6 ± 2.1% | 1.002 | 0.098 | 1.003 | 0.668 | 1.002 | 1.002 | 1.002 | 1.003 | 1.002 | 0.102 | 1.003 |

## Losses

Each workload where a claim's path ran slower than the path it replaces by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding: J7 wide vectors off runs at 1.077 of all on.
- CLDR supplemental, 34 texts, decoding: J8 decoder fast path off runs at 1.082 of all on.
- CLDR supplemental, 34 texts, decoding: J12 decoder escape words off runs at 1.080 of all on.
- CLDR supplemental, 34 texts, decoding: J13 decoder escape blocks off runs at 1.081 of all on.
- qlog records, JSON text sequence, decoding: J5 UTF-8 vectors off runs at 1.068 of all on.
- qlog records, JSON text sequence, decoding: J7 wide vectors off runs at 1.077 of all on.
- qlog records, JSON text sequence, decoding: J8 decoder fast path off runs at 1.078 of all on.
- qlog records, JSON text sequence, decoding: J12 decoder escape words off runs at 1.073 of all on.
- qlog records, JSON text sequence, decoding: J13 decoder escape blocks off runs at 1.078 of all on.
- string: silesia/dickens, decoding: J7 wide vectors off runs at 1.056 of all on.
- string: silesia/dickens, decoding: J8 decoder fast path off runs at 1.053 of all on.
- string: silesia/dickens, decoding: J13 decoder escape blocks off runs at 1.074 of all on.
- string: silesia/nci, decoding: J7 wide vectors off runs at 1.128 of all on.
- string: silesia/nci, decoding: J8 decoder fast path off runs at 1.141 of all on.
- string: silesia/nci, decoding: J12 decoder escape words off runs at 1.124 of all on.
- string: silesia/nci, decoding: J13 decoder escape blocks off runs at 1.138 of all on.
- string: silesia/samba, decoding: J7 wide vectors off runs at 1.072 of all on.
- string: silesia/samba, decoding: J8 decoder fast path off runs at 1.081 of all on.
- string: silesia/samba, decoding: J13 decoder escape blocks off runs at 1.078 of all on.
- string: canterbury/alice29.txt, decoding: J7 wide vectors off runs at 1.128 of all on.
- string: canterbury/alice29.txt, decoding: J8 decoder fast path off runs at 1.080 of all on.
- string: canterbury/alice29.txt, decoding: J12 decoder escape words off runs at 1.055 of all on.
- string: canterbury/alice29.txt, decoding: J13 decoder escape blocks off runs at 1.169 of all on.
- string: canterbury/asyoulik.txt, decoding: J7 wide vectors off runs at 1.144 of all on.
- string: canterbury/asyoulik.txt, decoding: J8 decoder fast path off runs at 1.150 of all on.
- string: canterbury/asyoulik.txt, decoding: J12 decoder escape words off runs at 1.135 of all on.
- string: canterbury/asyoulik.txt, decoding: J13 decoder escape blocks off runs at 1.169 of all on.
- string: canterbury/lcet10.txt, decoding: J7 wide vectors off runs at 1.082 of all on.
- string: canterbury/lcet10.txt, decoding: J8 decoder fast path off runs at 1.074 of all on.
- string: canterbury/lcet10.txt, decoding: J13 decoder escape blocks off runs at 1.095 of all on.

## UTF-8 validation against simdutf

stdx's `is_utf8`, the check the loops apply to every string's octets, run alone over each string workload's octets at the width the host's features pick (16 lanes on aarch64, AVX2's 32 or AVX-512's 64 on x86-64, decision 39), beside simdutf 9.3.3's `validate_utf8` in the same run; on a host with AVX-512, again with AVX2 alone. Each ratio is stdx's throughput over the other's. simdutf picks its kernel at run time. Before timing, every copy of the check and simdutf judged 20000 seeded buffers and each workload, whole and changed, alike.

| Workload | Octets | stdx, MB/s | simdutf, MB/s | stdx / simdutf | stdx with AVX2 alone, MB/s | stdx / stdx with AVX2 alone |
|---|---|---|---|---|---|---|
| string: silesia/dickens | 166668 | 129274.1 ± 0.1% | 85843.3 ± 0.5% | 1.506 | 70638.7 ± 0.6% | 1.830 |
| string: silesia/nci | 1048576 | 129430.3 ± 0.4% | 86181.0 ± 0.2% | 1.502 | 70896.2 ± 0.3% | 1.826 |
| string: silesia/reymont | 1048576 | 116709.0 ± 0.3% | 83333.8 ± 0.5% | 1.400 | 69032.4 ± 1.0% | 1.691 |
| string: silesia/samba | 65546 | 125512.8 ± 0.3% | 85355.0 ± 0.3% | 1.470 | 69716.9 ± 0.3% | 1.800 |
| string: silesia/webster | 1048576 | 129604.3 ± 0.4% | 86171.6 ± 1.2% | 1.504 | 70558.5 ± 0.4% | 1.837 |
| string: silesia/xml | 1048576 | 129430.0 ± 3.5% | 86159.7 ± 1.4% | 1.502 | 70778.7 ± 0.4% | 1.829 |
| string: canterbury/alice29.txt | 152089 | 129777.6 ± 0.3% | 85744.7 ± 0.3% | 1.514 | 70530.4 ± 0.2% | 1.840 |
| string: canterbury/asyoulik.txt | 125179 | 128677.0 ± 0.5% | 85695.7 ± 0.5% | 1.502 | 70713.6 ± 0.7% | 1.820 |
| string: canterbury/lcet10.txt | 426754 | 129927.4 ± 0.2% | 86057.5 ± 0.6% | 1.510 | 70900.8 ± 0.3% | 1.833 |
| string: canterbury/plrabn12.txt | 481861 | 129890.5 ± 0.4% | 86071.7 ± 0.4% | 1.509 | 70680.2 ± 0.5% | 1.838 |
| string: canterbury-large/E.coli | 1048576 | 129274.3 ± 0.4% | 86203.9 ± 1.2% | 1.500 | 70698.0 ± 0.2% | 1.829 |
| string: canterbury-large/bible.txt | 1048576 | 129674.4 ± 0.8% | 86142.2 ± 1.0% | 1.505 | 71197.9 ± 0.7% | 1.821 |
| string: canterbury-large/world192.txt | 1048576 | 129649.5 ± 0.9% | 86179.7 ± 0.7% | 1.504 | 70721.2 ± 0.3% | 1.833 |
| string: http/html-1m | 1048576 | 114492.8 ± 1.5% | 80801.9 ± 0.6% | 1.417 | 65128.1 ± 0.4% | 1.758 |
| string: http/json-1m | 1048576 | 92628.1 ± 0.4% | 75574.0 ± 0.8% | 1.226 | 55925.2 ± 0.9% | 1.656 |
| string: http/js-1m | 1048576 | 127331.9 ± 0.9% | 85267.2 ± 0.4% | 1.493 | 69422.0 ± 0.3% | 1.834 |
| string: http/css-1m | 1048576 | 128874.1 ± 0.6% | 86086.0 ± 0.8% | 1.497 | 69807.9 ± 0.3% | 1.846 |
| string: dickens as Cyrillic and CJK | 1847045 | 18596.1 ± 0.4% | 16556.3 ± 0.9% | 1.123 | 11791.6 ± 0.3% | 1.577 |

## Losses to simdutf

None.

## UTF-8 validation by the buffer's offset from a 64-octet line

| Buffer | Octets | Offset | stdx, MB/s | simdutf, MB/s | stdx / simdutf | stdx with AVX2 alone, MB/s | stdx / stdx with AVX2 alone |
|---|---|---|---|---|---|---|---|
| string: canterbury-large/bible.txt | 1048576 | 0 | 129879.6 ± 0.4% | 85954.7 ± 0.6% | 1.511 | 70564.0 ± 4.1% | 1.841 |
| string: canterbury-large/bible.txt | 1048576 | 1 | 129660.4 ± 0.1% | 86078.3 ± 0.4% | 1.506 | 70997.2 ± 5.9% | 1.826 |
| string: canterbury-large/bible.txt | 1048576 | 8 | 129550.1 ± 0.4% | 86083.1 ± 4.2% | 1.505 | 70799.4 ± 2.2% | 1.830 |
| string: canterbury-large/bible.txt | 1048576 | 16 | 129589.3 ± 3.1% | 86093.5 ± 0.2% | 1.505 | 70921.0 ± 0.1% | 1.827 |
| string: canterbury-large/bible.txt | 1048576 | 32 | 129650.0 ± 0.3% | 86191.5 ± 0.5% | 1.504 | 71006.9 ± 20.2% | 1.826 |
| string: canterbury-large/bible.txt | 1048576 | 48 | 129650.2 ± 2.3% | 86151.2 ± 7.6% | 1.505 | 71246.3 ± 0.2% | 1.820 |
| string: dickens as Cyrillic and CJK | 1048576 | 0 | 18712.5 ± 0.3% | 16850.0 ± 0.5% | 1.111 | 11863.9 ± 0.3% | 1.577 |
| string: dickens as Cyrillic and CJK | 1048576 | 1 | 18732.1 ± 0.2% | 16810.8 ± 1.3% | 1.114 | 11878.5 ± 0.2% | 1.577 |
| string: dickens as Cyrillic and CJK | 1048576 | 8 | 18722.5 ± 1.0% | 16818.3 ± 0.8% | 1.113 | 11872.7 ± 0.3% | 1.577 |
| string: dickens as Cyrillic and CJK | 1048576 | 16 | 18733.5 ± 0.5% | 16819.8 ± 1.2% | 1.114 | 11874.8 ± 0.4% | 1.578 |
| string: dickens as Cyrillic and CJK | 1048576 | 32 | 18727.2 ± 0.2% | 16786.6 ± 1.1% | 1.116 | 11885.9 ± 0.1% | 1.576 |
| string: dickens as Cyrillic and CJK | 1048576 | 48 | 18731.1 ± 0.5% | 16831.1 ± 0.8% | 1.113 | 11884.5 ± 1.5% | 1.576 |

## Against the baselines

stdx with every claim on, timed beside simdjson 5.1.1, yyjson 0.13.0, Zig 0.16.0's std.json, serde_json 1.0.154 and Go's encoding/json/jsontext in the same run. Each ratio is stdx's throughput over the baseline's; below 1, the baseline is faster. stdx is built for the architecture's baseline CPU in ReleaseSafe. Each baseline is built for the same CPU, the C, C++ and Zig ones in ReleaseFast (decision 75), and simdjson picks its kernel at run time. Decoding visits every value; encoding writes each text from its tokens.

## Decoding against the baselines

Octets are the text's. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1060.5 ± 1.8% | 1188.6 ± 1.9% | 832.7 ± 1.7% | 296.6 ± 0.7% | 473.0 ± 1.0% | 278.7 ± 2.7% | 0.892 | 1.274 | 3.575 | 2.242 | 3.805 |
| qlog records, JSON text sequence | 1467503 | 810.4 ± 1.4% | 937.2 ± 0.4% | 841.7 ± 0.8% | 258.6 ± 0.8% | 535.1 ± 1.1% | 238.4 ± 1.2% | 0.865 | 0.963 | 3.133 | 1.514 | 3.400 |
| string: silesia/dickens | 172528 | 5401.8 ± 1.3% | 2557.7 ± 1.9% | 2348.4 ± 4.3% | 231.8 ± 0.8% | 2615.8 ± 2.4% | 464.5 ± 1.3% | 2.112 | 2.300 | 23.302 | 2.065 | 11.629 |
| string: silesia/nci | 1075110 | 4022.2 ± 0.8% | 3081.0 ± 1.3% | 2372.9 ± 0.6% | 526.6 ± 0.8% | 2859.8 ± 0.9% | 505.0 ± 2.0% | 1.305 | 1.695 | 7.637 | 1.406 | 7.964 |
| string: silesia/reymont | 1075159 | 3190.8 ± 2.4% | 2656.4 ± 0.7% | 1489.7 ± 2.3% | 239.0 ± 3.1% | 1628.6 ± 2.7% | 421.8 ± 1.4% | 1.201 | 2.142 | 13.349 | 1.959 | 7.564 |
| string: silesia/samba | 97582 | 3074.7 ± 0.6% | 2794.2 ± 0.5% | 2211.9 ± 4.3% | 249.5 ± 1.4% | 1535.9 ± 1.3% | 330.3 ± 1.7% | 1.100 | 1.390 | 12.326 | 2.002 | 9.309 |
| string: silesia/webster | 1098490 | 3489.2 ± 0.9% | 1882.0 ± 0.7% | 1383.0 ± 0.9% | 231.9 ± 0.9% | 1674.1 ± 0.7% | 386.2 ± 1.2% | 1.854 | 2.523 | 15.043 | 2.084 | 9.036 |
| string: silesia/xml | 1090118 | 4930.5 ± 0.8% | 3950.5 ± 0.9% | 1917.6 ± 1.0% | 377.1 ± 0.7% | 2600.6 ± 0.4% | 463.0 ± 1.5% | 1.248 | 2.571 | 13.073 | 1.896 | 10.649 |
| string: canterbury/alice29.txt | 159425 | 4544.4 ± 1.5% | 2188.6 ± 0.9% | 2335.6 ± 2.0% | 223.0 ± 0.8% | 2380.9 ± 1.6% | 414.3 ± 4.5% | 2.076 | 1.946 | 20.377 | 1.909 | 10.969 |
| string: canterbury/asyoulik.txt | 132198 | 3434.6 ± 1.4% | 1749.6 ± 7.5% | 2187.3 ± 5.2% | 223.6 ± 0.7% | 1883.7 ± 2.0% | 364.9 ± 4.1% | 1.963 | 1.570 | 15.360 | 1.823 | 9.411 |
| string: canterbury/lcet10.txt | 441884 | 5304.6 ± 1.5% | 2454.3 ± 2.4% | 1783.7 ± 0.5% | 258.2 ± 1.1% | 2343.1 ± 5.3% | 446.6 ± 1.4% | 2.161 | 2.974 | 20.542 | 2.264 | 11.878 |
| string: canterbury/plrabn12.txt | 503330 | 4330.5 ± 1.6% | 2417.7 ± 0.9% | 1459.8 ± 0.7% | 238.6 ± 1.2% | 2213.0 ± 0.8% | 407.1 ± 0.9% | 1.791 | 2.967 | 18.152 | 1.957 | 10.636 |
| string: canterbury-large/E.coli | 1048578 | 22783.0 ± 1.4% | 10322.4 ± 1.9% | 2678.4 ± 1.6% | 854.6 ± 0.4% | 6476.1 ± 2.1% | 830.7 ± 1.3% | 2.207 | 8.506 | 26.661 | 3.518 | 27.425 |
| string: canterbury-large/bible.txt | 1055886 | 6930.8 ± 3.4% | 4198.0 ± 1.5% | 2260.8 ± 1.2% | 251.1 ± 3.0% | 3102.1 ± 3.2% | 529.1 ± 1.7% | 1.651 | 3.066 | 27.599 | 2.234 | 13.100 |
| string: canterbury-large/world192.txt | 1103121 | 3403.2 ± 2.3% | 1768.4 ± 0.9% | 1436.1 ± 2.2% | 242.0 ± 0.7% | 1724.8 ± 1.2% | 389.3 ± 0.4% | 1.925 | 2.370 | 14.066 | 1.973 | 8.742 |
| string: http/html-1m | 1058582 | 7358.5 ± 1.0% | 3689.9 ± 1.3% | 2185.0 ± 0.6% | 296.7 ± 1.9% | 2927.2 ± 2.9% | 515.1 ± 2.2% | 1.994 | 3.368 | 24.800 | 2.514 | 14.285 |
| string: http/json-1m | 1190272 | 2841.4 ± 0.8% | 973.7 ± 1.5% | 1710.8 ± 0.8% | 362.1 ± 0.9% | 1073.9 ± 0.9% | 343.8 ± 2.0% | 2.918 | 1.661 | 7.848 | 2.646 | 8.264 |
| string: http/js-1m | 1144362 | 2382.5 ± 0.8% | 1248.6 ± 0.7% | 1064.3 ± 0.7% | 235.0 ± 0.9% | 1116.2 ± 0.6% | 308.5 ± 4.1% | 1.908 | 2.239 | 10.136 | 2.134 | 7.722 |
| string: http/css-1m | 1097820 | 2591.7 ± 1.1% | 2257.1 ± 0.4% | 1573.2 ± 1.2% | 324.7 ± 1.7% | 1652.6 ± 2.3% | 377.5 ± 0.7% | 1.148 | 1.647 | 7.981 | 1.568 | 6.865 |
| string: dickens as Cyrillic and CJK | 1883069 | 4610.3 ± 0.9% | 2811.2 ± 0.6% | 518.9 ± 1.2% | 286.5 ± 1.0% | 395.5 ± 1.3% | 127.6 ± 2.6% | 1.640 | 8.884 | 16.092 | 11.657 | 36.134 |
| string: dickens as Cyrillic and CJK, as \u escapes | 5075485 | 919.2 ± 1.0% | 957.0 ± 0.6% | 857.2 ± 0.8% | 204.0 ± 1.6% | 366.0 ± 1.6% | 172.2 ± 3.4% | 0.961 | 1.072 | 4.505 | 2.511 | 5.338 |
| hex: silesia/dickens | 524290 | 31440.3 ± 1.4% | 11633.6 ± 1.3% | 2710.4 ± 0.7% | 370.2 ± 1.7% | 6488.7 ± 0.7% | 856.6 ± 5.0% | 2.703 | 11.600 | 84.925 | 4.845 | 36.706 |
| hex: silesia/mozilla | 524290 | 31895.0 ± 0.9% | 11664.6 ± 2.6% | 2776.7 ± 0.5% | 320.8 ± 7.4% | 6494.5 ± 5.3% | 859.1 ± 1.6% | 2.734 | 11.486 | 99.430 | 4.911 | 37.127 |
| hex: silesia/mr | 524290 | 31774.5 ± 1.2% | 11726.5 ± 1.6% | 2777.8 ± 0.7% | 478.5 ± 2.6% | 6501.4 ± 7.0% | 854.1 ± 0.6% | 2.710 | 11.439 | 66.405 | 4.887 | 37.204 |
| hex: silesia/nci | 524290 | 31368.3 ± 0.9% | 11613.0 ± 2.0% | 2713.2 ± 1.0% | 598.1 ± 2.1% | 6464.0 ± 1.8% | 858.4 ± 1.5% | 2.701 | 11.561 | 52.448 | 4.853 | 36.544 |
| hex: silesia/ooffice | 524290 | 32533.0 ± 0.5% | 11702.7 ± 3.1% | 2777.5 ± 0.7% | 261.5 ± 4.9% | 6506.6 ± 0.6% | 853.8 ± 0.8% | 2.780 | 11.713 | 124.391 | 5.000 | 38.105 |
| hex: silesia/osdb | 524290 | 32498.7 ± 1.1% | 11664.7 ± 2.2% | 2775.5 ± 0.8% | 356.2 ± 5.0% | 6483.7 ± 1.1% | 860.9 ± 3.6% | 2.786 | 11.709 | 91.244 | 5.012 | 37.749 |
| hex: silesia/reymont | 524290 | 30821.4 ± 0.8% | 11665.8 ± 0.7% | 2704.4 ± 2.3% | 393.1 ± 1.5% | 6479.2 ± 1.2% | 858.3 ± 5.3% | 2.642 | 11.397 | 78.396 | 4.757 | 35.908 |
| hex: silesia/samba | 524290 | 32714.8 ± 0.7% | 11637.3 ± 2.1% | 2779.5 ± 0.5% | 282.1 ± 0.5% | 6478.6 ± 0.7% | 861.1 ± 1.2% | 2.811 | 11.770 | 115.956 | 5.050 | 37.994 |
| hex: silesia/sao | 524290 | 32618.1 ± 2.5% | 11659.3 ± 2.8% | 2671.4 ± 0.7% | 209.5 ± 2.7% | 6482.1 ± 2.4% | 857.5 ± 1.7% | 2.798 | 12.210 | 155.684 | 5.032 | 38.039 |
| hex: silesia/webster | 524290 | 30821.6 ± 2.3% | 11647.4 ± 9.6% | 2776.5 ± 0.7% | 346.4 ± 1.9% | 6496.2 ± 2.6% | 850.8 ± 2.4% | 2.646 | 11.101 | 88.984 | 4.745 | 36.227 |
| hex: silesia/x-ray | 524290 | 32020.6 ± 1.2% | 11697.6 ± 2.6% | 2709.8 ± 0.8% | 331.2 ± 3.8% | 6456.2 ± 0.4% | 854.8 ± 4.7% | 2.737 | 11.817 | 96.692 | 4.960 | 37.461 |
| hex: silesia/xml | 524290 | 30733.0 ± 1.1% | 11643.1 ± 3.2% | 2774.5 ± 3.3% | 584.1 ± 0.8% | 6480.2 ± 0.6% | 855.0 ± 1.5% | 2.640 | 11.077 | 52.615 | 4.743 | 35.945 |
| hex: canterbury/alice29.txt | 304180 | 31813.7 ± 4.9% | 11637.4 ± 1.1% | 2790.4 ± 0.8% | 372.4 ± 1.4% | 6468.5 ± 7.0% | 869.2 ± 4.3% | 2.734 | 11.401 | 85.425 | 4.918 | 36.601 |
| hex: canterbury/asyoulik.txt | 250360 | 31745.8 ± 4.2% | 11696.2 ± 0.8% | 2707.2 ± 6.4% | 366.6 ± 0.5% | 6463.4 ± 5.8% | 864.3 ± 1.5% | 2.714 | 11.726 | 86.600 | 4.912 | 36.732 |
| hex: canterbury/cp.html | 49208 | 31207.5 ± 1.6% | 11843.4 ± 0.7% | 2780.3 ± 1.3% | 390.0 ± 1.2% | 6691.9 ± 4.9% | 832.1 ± 3.1% | 2.635 | 11.224 | 80.015 | 4.663 | 37.504 |
| hex: canterbury/fields.c | 22302 | 35650.5 ± 0.8% | 13067.2 ± 1.2% | 2835.2 ± 0.9% | 472.9 ± 1.2% | 6680.1 ± 1.0% | 810.3 ± 2.3% | 2.728 | 12.574 | 75.393 | 5.337 | 43.994 |
| hex: canterbury/grammar.lsp | 7444 | 32051.7 ± 3.2% | 13802.8 ± 0.4% | 2825.2 ± 0.7% | 606.8 ± 4.2% | 6491.9 ± 0.7% | 784.4 ± 2.6% | 2.322 | 11.345 | 52.824 | 4.937 | 40.859 |
| hex: canterbury/kennedy.xls | 524290 | 32779.9 ± 1.8% | 11699.0 ± 0.9% | 2776.1 ± 1.0% | 599.7 ± 2.8% | 6473.2 ± 5.0% | 840.1 ± 3.0% | 2.802 | 11.808 | 54.658 | 5.064 | 39.019 |
| hex: canterbury/lcet10.txt | 524290 | 31714.3 ± 0.7% | 11685.2 ± 2.5% | 2773.5 ± 4.0% | 373.8 ± 1.0% | 6499.2 ± 0.8% | 838.4 ± 2.8% | 2.714 | 11.435 | 84.834 | 4.880 | 37.827 |
| hex: canterbury/plrabn12.txt | 524290 | 32502.3 ± 1.6% | 11585.0 ± 2.3% | 2777.7 ± 2.1% | 363.5 ± 2.0% | 6472.8 ± 1.1% | 845.5 ± 1.6% | 2.806 | 11.701 | 89.404 | 5.021 | 38.439 |
| hex: canterbury/ptt5 | 524290 | 32495.2 ± 2.2% | 11663.3 ± 1.7% | 2707.2 ± 0.6% | 482.6 ± 2.7% | 6461.3 ± 2.4% | 847.0 ± 0.9% | 2.786 | 12.003 | 67.338 | 5.029 | 38.366 |
| hex: canterbury/sum | 76482 | 30958.4 ± 1.0% | 11571.0 ± 0.4% | 2787.3 ± 0.6% | 430.3 ± 9.7% | 6468.3 ± 0.6% | 830.4 ± 3.2% | 2.676 | 11.107 | 71.943 | 4.786 | 37.282 |
| hex: canterbury/xargs.1 | 8456 | 32799.0 ± 0.7% | 13846.9 ± 0.8% | 2769.7 ± 0.7% | 595.0 ± 7.8% | 6526.3 ± 1.0% | 810.0 ± 1.5% | 2.369 | 11.842 | 55.128 | 5.026 | 40.491 |
| hex: canterbury-large/E.coli | 524290 | 32237.7 ± 2.1% | 11669.2 ± 2.0% | 2695.4 ± 0.4% | 600.6 ± 0.9% | 6482.4 ± 3.5% | 849.6 ± 5.7% | 2.763 | 11.960 | 53.674 | 4.973 | 37.947 |
| hex: canterbury-large/bible.txt | 524290 | 32746.6 ± 1.7% | 11675.2 ± 2.2% | 2709.2 ± 1.5% | 391.2 ± 0.7% | 6483.0 ± 0.4% | 854.5 ± 3.7% | 2.805 | 12.087 | 83.702 | 5.051 | 38.321 |
| hex: canterbury-large/world192.txt | 524290 | 31923.8 ± 1.4% | 11670.3 ± 1.9% | 2786.8 ± 0.8% | 368.9 ± 0.8% | 6486.2 ± 1.1% | 855.1 ± 2.1% | 2.735 | 11.455 | 86.534 | 4.922 | 37.335 |
| hex: http/html-1kx1024 | 2099200 | 15673.7 ± 1.4% | 10397.4 ± 1.3% | 2571.2 ± 2.0% | 386.9 ± 1.5% | 5095.7 ± 4.1% | 709.8 ± 3.1% | 1.507 | 6.096 | 40.513 | 3.076 | 22.081 |
| hex: http/html-16kx64 | 2097280 | 25654.0 ± 0.8% | 11708.2 ± 0.8% | 2649.9 ± 1.3% | 394.7 ± 0.9% | 6605.1 ± 0.9% | 788.5 ± 2.0% | 2.191 | 9.681 | 64.992 | 3.884 | 32.536 |
| hex: http/html-1m | 524290 | 31938.0 ± 1.6% | 11666.6 ± 1.3% | 2705.6 ± 0.1% | 391.4 ± 0.9% | 6489.8 ± 3.1% | 840.5 ± 4.1% | 2.738 | 11.804 | 81.607 | 4.921 | 37.998 |
| hex: http/json-1kx1024 | 2099200 | 15692.9 ± 1.0% | 10215.2 ± 0.8% | 2570.4 ± 5.1% | 565.6 ± 1.5% | 5193.4 ± 2.0% | 708.8 ± 2.3% | 1.536 | 6.105 | 27.744 | 3.022 | 22.141 |
| hex: http/json-16kx64 | 2097280 | 25861.1 ± 2.7% | 11718.0 ± 0.9% | 2661.0 ± 1.4% | 584.1 ± 1.9% | 6581.3 ± 0.4% | 804.2 ± 5.7% | 2.207 | 9.718 | 44.272 | 3.929 | 32.158 |
| hex: http/json-1m | 524290 | 31366.0 ± 0.7% | 11618.0 ± 1.9% | 2760.2 ± 0.8% | 616.6 ± 0.5% | 6441.2 ± 6.8% | 844.8 ± 2.8% | 2.700 | 11.364 | 50.870 | 4.870 | 37.130 |
| hex: http/js-1kx1024 | 2099200 | 15480.9 ± 1.5% | 10236.7 ± 0.8% | 2562.9 ± 0.7% | 380.5 ± 0.7% | 5148.1 ± 4.0% | 710.7 ± 2.1% | 1.512 | 6.040 | 40.682 | 3.007 | 21.781 |
| hex: http/js-16kx64 | 2097280 | 25694.3 ± 1.0% | 11665.5 ± 0.6% | 2649.8 ± 1.0% | 385.1 ± 1.3% | 6559.0 ± 0.6% | 788.8 ± 7.1% | 2.203 | 9.697 | 66.715 | 3.917 | 32.575 |
| hex: http/js-1m | 524290 | 32711.6 ± 1.5% | 11649.3 ± 0.7% | 2780.2 ± 1.3% | 400.7 ± 1.2% | 6505.8 ± 0.4% | 843.0 ± 3.4% | 2.808 | 11.766 | 81.642 | 5.028 | 38.803 |
| hex: http/css-1kx1024 | 2099200 | 15730.9 ± 0.4% | 10242.9 ± 0.4% | 2565.8 ± 0.8% | 440.6 ± 0.9% | 5181.3 ± 2.9% | 695.9 ± 1.1% | 1.536 | 6.131 | 35.707 | 3.036 | 22.606 |
| hex: http/css-16kx64 | 2097280 | 25684.3 ± 2.6% | 11684.0 ± 0.6% | 2650.5 ± 0.9% | 449.8 ± 1.0% | 6548.3 ± 1.5% | 798.0 ± 1.7% | 2.198 | 9.690 | 57.100 | 3.922 | 32.186 |
| hex: http/css-1m | 524290 | 31819.2 ± 1.1% | 11471.7 ± 3.9% | 2778.9 ± 0.4% | 430.8 ± 2.9% | 6450.3 ± 5.4% | 824.5 ± 2.3% | 2.774 | 11.450 | 73.862 | 4.933 | 38.594 |
| hex: shuffled/dickens-1m | 524290 | 31786.2 ± 1.5% | 11701.5 ± 3.2% | 2706.9 ± 0.5% | 373.2 ± 0.7% | 6492.3 ± 0.7% | 845.0 ± 6.1% | 2.716 | 11.743 | 85.167 | 4.896 | 37.615 |

## Encoding against the baselines

Octets are the ones stdx writes. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1416.5 ± 2.0% | 1151.8 ± 0.4% | 783.7 ± 1.0% | 362.3 ± 1.0% | 324.3 ± 3.1% | 387.0 ± 4.9% | 1.230 | 1.807 | 3.910 | 4.368 | 3.661 |
| qlog records, JSON text sequence | 1467503 | 1150.2 ± 1.1% | 991.2 ± 1.1% | 725.4 ± 1.8% | 340.9 ± 1.7% | 366.3 ± 1.5% | 266.5 ± 1.1% | 1.160 | 1.586 | 3.374 | 3.140 | 4.316 |
| string: silesia/dickens | 172528 | 11074.3 ± 2.8% | 2901.4 ± 3.8% | 2498.2 ± 2.0% | 273.7 ± 0.6% | 1174.6 ± 9.5% | 919.8 ± 2.0% | 3.817 | 4.433 | 40.461 | 9.428 | 12.040 |
| string: silesia/nci | 1075110 | 8977.2 ± 1.2% | 3528.5 ± 1.3% | 2389.5 ± 0.8% | 711.3 ± 0.8% | 1288.1 ± 4.8% | 990.9 ± 2.3% | 2.544 | 3.757 | 12.620 | 6.970 | 9.060 |
| string: silesia/reymont | 1075159 | 4138.3 ± 1.4% | 1441.8 ± 3.2% | 1514.3 ± 2.8% | 297.7 ± 0.7% | 995.4 ± 7.3% | 868.8 ± 0.8% | 2.870 | 2.733 | 13.899 | 4.158 | 4.763 |
| string: silesia/samba | 97582 | 4714.6 ± 1.0% | 2102.7 ± 7.3% | 2971.9 ± 0.4% | 289.6 ± 0.5% | 994.3 ± 3.3% | 955.1 ± 0.8% | 2.242 | 1.586 | 16.277 | 4.742 | 4.936 |
| string: silesia/webster | 1098490 | 5240.7 ± 0.9% | 1504.2 ± 1.0% | 1415.5 ± 1.3% | 294.9 ± 0.8% | 930.1 ± 2.0% | 468.9 ± 0.8% | 3.484 | 3.702 | 17.771 | 5.634 | 11.176 |
| string: silesia/xml | 1090118 | 7945.0 ± 1.2% | 2399.9 ± 2.6% | 2003.9 ± 0.9% | 483.2 ± 4.3% | 1220.8 ± 6.8% | 763.3 ± 3.4% | 3.311 | 3.965 | 16.443 | 6.508 | 10.409 |
| string: canterbury/alice29.txt | 159425 | 10347.9 ± 2.6% | 2226.3 ± 4.4% | 2358.3 ± 2.4% | 261.9 ± 0.5% | 1044.1 ± 2.9% | 833.1 ± 2.2% | 4.648 | 4.388 | 39.509 | 9.911 | 12.421 |
| string: canterbury/asyoulik.txt | 132198 | 8853.9 ± 4.0% | 1668.2 ± 3.5% | 2388.6 ± 0.8% | 267.4 ± 0.9% | 883.0 ± 2.9% | 739.9 ± 1.8% | 5.307 | 3.707 | 33.108 | 10.027 | 11.966 |
| string: canterbury/lcet10.txt | 441884 | 8651.6 ± 2.0% | 2297.9 ± 3.1% | 2076.1 ± 1.5% | 296.3 ± 0.5% | 1107.3 ± 3.3% | 909.1 ± 2.7% | 3.765 | 4.167 | 29.198 | 7.814 | 9.516 |
| string: canterbury/plrabn12.txt | 503330 | 6345.7 ± 2.0% | 1713.6 ± 2.9% | 1637.7 ± 1.1% | 277.2 ± 2.3% | 958.0 ± 3.1% | 804.3 ± 1.8% | 3.703 | 3.875 | 22.895 | 6.624 | 7.890 |
| string: canterbury-large/E.coli | 1048578 | 24761.4 ± 0.8% | 11211.6 ± 0.8% | 2787.3 ± 0.8% | 1328.0 ± 0.5% | 1553.6 ± 17.0% | 1097.7 ± 0.5% | 2.209 | 8.884 | 18.646 | 15.938 | 22.557 |
| string: canterbury-large/bible.txt | 1055886 | 7089.4 ± 1.1% | 3703.3 ± 1.9% | 2407.0 ± 1.6% | 321.6 ± 1.3% | 1463.8 ± 6.2% | 1116.5 ± 2.0% | 1.914 | 2.945 | 22.044 | 4.843 | 6.350 |
| string: canterbury-large/world192.txt | 1103121 | 4962.1 ± 2.0% | 1325.8 ± 0.6% | 1496.7 ± 1.3% | 294.4 ± 0.8% | 934.9 ± 2.0% | 784.1 ± 1.7% | 3.743 | 3.315 | 16.853 | 5.308 | 6.329 |
| string: http/html-1m | 1058582 | 7672.8 ± 1.7% | 3379.8 ± 0.8% | 2354.9 ± 0.4% | 329.8 ± 2.3% | 1392.8 ± 2.9% | 664.1 ± 1.8% | 2.270 | 3.258 | 23.266 | 5.509 | 11.554 |
| string: http/json-1m | 1190272 | 7091.5 ± 0.6% | 1183.1 ± 2.2% | 1267.4 ± 0.9% | 398.2 ± 7.2% | 783.9 ± 1.4% | 672.2 ± 0.9% | 5.994 | 5.595 | 17.810 | 9.046 | 10.550 |
| string: http/js-1m | 1144362 | 5021.5 ± 0.7% | 865.0 ± 0.8% | 1103.9 ± 0.6% | 261.6 ± 2.1% | 776.1 ± 5.6% | 607.6 ± 1.3% | 5.805 | 4.549 | 19.196 | 6.470 | 8.264 |
| string: http/css-1m | 1097820 | 6739.7 ± 0.7% | 1115.1 ± 0.5% | 1629.3 ± 1.8% | 369.0 ± 1.7% | 919.3 ± 3.6% | 764.3 ± 0.9% | 6.044 | 4.136 | 18.266 | 7.331 | 8.818 |
| string: dickens as Cyrillic and CJK | 1883069 | 4328.7 ± 1.3% | 2866.7 ± 1.8% | 362.3 ± 0.8% | 193.3 ± 1.3% | 340.7 ± 1.8% | 279.1 ± 1.6% | 1.510 | 11.948 | 22.393 | 12.706 | 15.509 |
| hex: silesia/dickens | 524290 | 27655.9 ± 1.8% | 1941.3 ± 1.2% | 1194.7 ± 1.0% | 350.5 ± 0.6% | 904.7 ± 1.3% | 827.2 ± 4.0% | 14.246 | 23.149 | 78.903 | 30.569 | 33.435 |
| hex: silesia/mozilla | 524290 | 27431.8 ± 1.0% | 1823.5 ± 6.3% | 1186.3 ± 4.8% | 310.6 ± 2.0% | 912.2 ± 3.1% | 826.7 ± 2.0% | 15.043 | 23.124 | 88.322 | 30.073 | 33.182 |
| hex: silesia/mr | 524290 | 27650.3 ± 4.7% | 1941.6 ± 1.9% | 1186.5 ± 0.9% | 454.9 ± 0.5% | 911.9 ± 1.3% | 827.9 ± 0.9% | 14.241 | 23.305 | 60.783 | 30.321 | 33.398 |
| hex: silesia/nci | 524290 | 31550.8 ± 0.9% | 1890.0 ± 3.7% | 1188.3 ± 1.0% | 598.6 ± 1.3% | 918.9 ± 2.3% | 829.9 ± 0.8% | 16.693 | 26.550 | 52.708 | 34.337 | 38.020 |
| hex: silesia/ooffice | 524290 | 28114.4 ± 2.4% | 1909.6 ± 3.2% | 1190.5 ± 0.5% | 258.4 ± 0.5% | 918.7 ± 2.6% | 830.5 ± 2.2% | 14.722 | 23.615 | 108.818 | 30.602 | 33.850 |
| hex: silesia/osdb | 524290 | 28003.0 ± 0.9% | 1950.9 ± 2.7% | 1190.4 ± 0.9% | 344.0 ± 0.9% | 927.0 ± 4.1% | 828.6 ± 1.9% | 14.354 | 23.523 | 81.404 | 30.208 | 33.794 |
| hex: silesia/reymont | 524290 | 28194.2 ± 4.8% | 1955.7 ± 3.8% | 1190.5 ± 0.8% | 373.6 ± 1.3% | 948.3 ± 7.1% | 830.2 ± 1.2% | 14.417 | 23.682 | 75.472 | 29.731 | 33.962 |
| hex: silesia/samba | 524290 | 31623.6 ± 1.3% | 1897.0 ± 4.3% | 1190.4 ± 1.9% | 275.2 ± 0.6% | 939.5 ± 4.5% | 816.9 ± 3.7% | 16.670 | 26.566 | 114.923 | 33.658 | 38.710 |
| hex: silesia/sao | 524290 | 28229.5 ± 0.8% | 1933.8 ± 8.5% | 1192.9 ± 0.7% | 211.9 ± 0.6% | 914.6 ± 7.5% | 829.6 ± 2.4% | 14.598 | 23.665 | 133.240 | 30.866 | 34.030 |
| hex: silesia/webster | 524290 | 29297.0 ± 1.4% | 1857.8 ± 6.9% | 1189.7 ± 9.0% | 327.3 ± 0.7% | 919.5 ± 3.5% | 829.9 ± 2.0% | 15.770 | 24.626 | 89.511 | 31.863 | 35.303 |
| hex: silesia/x-ray | 524290 | 27661.5 ± 1.0% | 1928.7 ± 4.2% | 1191.1 ± 0.8% | 323.1 ± 0.9% | 917.9 ± 3.0% | 830.1 ± 1.7% | 14.342 | 23.224 | 85.625 | 30.135 | 33.324 |
| hex: silesia/xml | 524290 | 31555.5 ± 2.1% | 1906.3 ± 3.0% | 1195.4 ± 0.7% | 535.2 ± 0.9% | 952.0 ± 2.6% | 831.7 ± 3.7% | 16.553 | 26.398 | 58.960 | 33.148 | 37.939 |
| hex: canterbury/alice29.txt | 304180 | 27984.7 ± 1.4% | 1919.8 ± 6.1% | 1201.4 ± 1.0% | 357.4 ± 1.1% | 948.0 ± 3.4% | 840.8 ± 1.0% | 14.577 | 23.294 | 78.293 | 29.520 | 33.282 |
| hex: canterbury/asyoulik.txt | 250360 | 27831.4 ± 1.3% | 1832.2 ± 8.6% | 1217.7 ± 1.1% | 347.6 ± 0.6% | 954.7 ± 7.8% | 841.9 ± 1.3% | 15.190 | 22.855 | 80.071 | 29.152 | 33.056 |
| hex: canterbury/cp.html | 49208 | 26936.7 ± 0.4% | 1812.6 ± 2.7% | 1201.9 ± 0.6% | 357.3 ± 0.9% | 1006.4 ± 5.0% | 837.0 ± 5.7% | 14.861 | 22.413 | 75.392 | 26.766 | 32.181 |
| hex: canterbury/fields.c | 22302 | 31310.2 ± 1.0% | 1935.0 ± 4.1% | 1198.8 ± 0.7% | 551.3 ± 1.1% | 1000.2 ± 13.6% | 826.7 ± 1.9% | 16.181 | 26.118 | 56.794 | 31.305 | 37.872 |
| hex: canterbury/grammar.lsp | 7444 | 26283.0 ± 1.7% | 1866.9 ± 16.2% | 1211.9 ± 1.3% | 624.8 ± 0.9% | 938.0 ± 9.6% | 843.1 ± 5.8% | 14.078 | 21.688 | 42.065 | 28.019 | 31.175 |
| hex: canterbury/kennedy.xls | 524290 | 27857.9 ± 4.9% | 1889.2 ± 5.9% | 1186.9 ± 1.0% | 593.0 ± 0.7% | 890.4 ± 2.7% | 826.2 ± 0.9% | 14.746 | 23.470 | 46.978 | 31.288 | 33.719 |
| hex: canterbury/lcet10.txt | 524290 | 31730.2 ± 2.1% | 1913.1 ± 5.3% | 1186.9 ± 0.8% | 357.2 ± 0.8% | 915.3 ± 4.8% | 834.1 ± 1.1% | 16.586 | 26.734 | 88.838 | 34.668 | 38.043 |
| hex: canterbury/plrabn12.txt | 524290 | 27648.2 ± 1.5% | 1909.4 ± 5.2% | 1187.6 ± 7.3% | 345.2 ± 0.9% | 916.9 ± 3.9% | 834.6 ± 1.5% | 14.480 | 23.282 | 80.082 | 30.155 | 33.127 |
| hex: canterbury/ptt5 | 524290 | 27807.3 ± 1.4% | 1920.6 ± 10.3% | 1188.7 ± 2.0% | 459.9 ± 0.4% | 909.3 ± 4.0% | 831.6 ± 3.2% | 14.478 | 23.392 | 60.463 | 30.582 | 33.437 |
| hex: canterbury/sum | 76482 | 27307.7 ± 0.8% | 1853.5 ± 5.7% | 1185.8 ± 0.6% | 437.6 ± 2.8% | 1013.5 ± 5.1% | 836.4 ± 2.0% | 14.733 | 23.030 | 62.408 | 26.945 | 32.650 |
| hex: canterbury/xargs.1 | 8456 | 29265.9 ± 3.6% | 1942.3 ± 8.8% | 1214.0 ± 8.2% | 629.9 ± 4.7% | 1000.5 ± 13.0% | 843.1 ± 2.2% | 15.068 | 24.108 | 46.461 | 29.253 | 34.711 |
| hex: canterbury-large/E.coli | 524290 | 27647.4 ± 1.9% | 1942.0 ± 3.8% | 1185.7 ± 0.7% | 607.9 ± 0.5% | 904.0 ± 2.0% | 825.7 ± 2.1% | 14.237 | 23.317 | 45.482 | 30.582 | 33.483 |
| hex: canterbury-large/bible.txt | 524290 | 31931.2 ± 1.8% | 1844.1 ± 6.4% | 1197.3 ± 1.7% | 367.9 ± 0.4% | 899.4 ± 1.4% | 832.9 ± 1.6% | 17.315 | 26.668 | 86.794 | 35.504 | 38.339 |
| hex: canterbury-large/world192.txt | 524290 | 28103.3 ± 1.7% | 1903.6 ± 4.3% | 1191.1 ± 1.2% | 347.8 ± 1.0% | 915.2 ± 4.3% | 824.0 ± 1.1% | 14.763 | 23.594 | 80.797 | 30.706 | 34.106 |
| hex: http/html-1kx1024 | 2099200 | 18148.3 ± 2.6% | 1847.4 ± 0.4% | 1114.4 ± 0.3% | 375.0 ± 0.4% | 884.8 ± 4.9% | 807.7 ± 2.1% | 9.823 | 16.285 | 48.397 | 20.512 | 22.470 |
| hex: http/html-16kx64 | 2097280 | 18545.1 ± 1.2% | 1820.0 ± 1.0% | 1134.1 ± 0.7% | 375.1 ± 0.7% | 910.5 ± 15.0% | 828.9 ± 2.4% | 10.189 | 16.352 | 49.445 | 20.369 | 22.374 |
| hex: http/html-1m | 524290 | 27228.0 ± 0.6% | 1952.6 ± 4.4% | 1193.6 ± 1.4% | 362.0 ± 3.0% | 898.7 ± 6.7% | 828.8 ± 2.3% | 13.944 | 22.812 | 75.207 | 30.295 | 32.854 |
| hex: http/json-1kx1024 | 2099200 | 18062.1 ± 0.6% | 1841.0 ± 0.9% | 1111.2 ± 0.8% | 542.9 ± 1.4% | 882.2 ± 4.4% | 809.9 ± 1.8% | 9.811 | 16.255 | 33.270 | 20.474 | 22.301 |
| hex: http/json-16kx64 | 2097280 | 19233.2 ± 0.6% | 1802.5 ± 2.6% | 1132.9 ± 1.0% | 549.2 ± 0.4% | 929.7 ± 7.3% | 833.2 ± 1.5% | 10.670 | 16.977 | 35.024 | 20.687 | 23.083 |
| hex: http/json-1m | 524290 | 28030.6 ± 0.9% | 1920.1 ± 0.7% | 1187.8 ± 2.2% | 574.2 ± 1.9% | 875.3 ± 2.5% | 827.2 ± 2.2% | 14.598 | 23.599 | 48.816 | 32.024 | 33.886 |
| hex: http/js-1kx1024 | 2099200 | 17837.0 ± 0.8% | 1838.8 ± 1.2% | 1115.2 ± 0.5% | 372.1 ± 0.4% | 896.5 ± 3.4% | 807.9 ± 2.7% | 9.700 | 15.995 | 47.940 | 19.896 | 22.077 |
| hex: http/js-16kx64 | 2097280 | 19235.1 ± 0.5% | 1812.1 ± 2.4% | 1132.6 ± 1.1% | 372.0 ± 4.3% | 916.8 ± 8.3% | 827.3 ± 5.7% | 10.615 | 16.983 | 51.701 | 20.980 | 23.252 |
| hex: http/js-1m | 524290 | 28066.1 ± 0.9% | 1955.2 ± 6.3% | 1186.9 ± 0.8% | 374.8 ± 0.9% | 891.6 ± 4.9% | 827.4 ± 5.7% | 14.355 | 23.647 | 74.888 | 31.480 | 33.920 |
| hex: http/css-1kx1024 | 2099200 | 17714.2 ± 1.8% | 1837.8 ± 0.6% | 1114.4 ± 0.7% | 418.7 ± 0.8% | 877.8 ± 4.2% | 818.1 ± 2.6% | 9.639 | 15.896 | 42.312 | 20.181 | 21.652 |
| hex: http/css-16kx64 | 2097280 | 19117.6 ± 1.0% | 1798.6 ± 1.0% | 1133.8 ± 0.6% | 419.7 ± 0.7% | 946.1 ± 5.7% | 827.9 ± 6.4% | 10.629 | 16.862 | 45.546 | 20.206 | 23.092 |
| hex: http/css-1m | 524290 | 27932.7 ± 0.3% | 1863.0 ± 5.8% | 1184.9 ± 0.6% | 402.3 ± 0.2% | 920.1 ± 6.2% | 825.6 ± 1.3% | 14.993 | 23.574 | 69.437 | 30.360 | 33.832 |
| hex: shuffled/dickens-1m | 524290 | 27826.6 ± 2.1% | 1937.8 ± 3.6% | 1188.9 ± 0.2% | 351.1 ± 0.5% | 924.4 ± 1.7% | 826.5 ± 0.9% | 14.360 | 23.405 | 79.246 | 30.101 | 33.667 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1428.7 ± 0.8% | 1151.8 ± 0.4% | 783.7 ± 1.0% | 362.3 ± 1.0% | 324.3 ± 3.1% | 387.0 ± 4.9% | 1.240 | 1.823 | 3.943 | 4.405 | 3.692 |
| qlog records, JSON text sequence | 1467503 | 1208.6 ± 2.5% | 991.2 ± 1.1% | 725.4 ± 1.8% | 340.9 ± 1.7% | 366.3 ± 1.5% | 266.5 ± 1.1% | 1.219 | 1.666 | 3.545 | 3.299 | 4.535 |
| string: silesia/dickens | 172528 | 11508.7 ± 3.0% | 2901.4 ± 3.8% | 2498.2 ± 2.0% | 273.7 ± 0.6% | 1174.6 ± 9.5% | 919.8 ± 2.0% | 3.967 | 4.607 | 42.048 | 9.798 | 12.513 |
| string: silesia/nci | 1075110 | 9454.2 ± 2.0% | 3528.5 ± 1.3% | 2389.5 ± 0.8% | 711.3 ± 0.8% | 1288.1 ± 4.8% | 990.9 ± 2.3% | 2.679 | 3.957 | 13.291 | 7.340 | 9.541 |
| string: silesia/reymont | 1075159 | 4300.0 ± 1.6% | 1441.8 ± 3.2% | 1514.3 ± 2.8% | 297.7 ± 0.7% | 995.4 ± 7.3% | 868.8 ± 0.8% | 2.982 | 2.840 | 14.442 | 4.320 | 4.949 |
| string: silesia/samba | 97582 | 5205.2 ± 1.5% | 2102.7 ± 7.3% | 2971.9 ± 0.4% | 289.6 ± 0.5% | 994.3 ± 3.3% | 955.1 ± 0.8% | 2.475 | 1.751 | 17.971 | 5.235 | 5.450 |
| string: silesia/webster | 1098490 | 5458.2 ± 5.2% | 1504.2 ± 1.0% | 1415.5 ± 1.3% | 294.9 ± 0.8% | 930.1 ± 2.0% | 468.9 ± 0.8% | 3.629 | 3.856 | 18.508 | 5.868 | 11.639 |
| string: silesia/xml | 1090118 | 9198.1 ± 1.4% | 2399.9 ± 2.6% | 2003.9 ± 0.9% | 483.2 ± 4.3% | 1220.8 ± 6.8% | 763.3 ± 3.4% | 3.833 | 4.590 | 19.037 | 7.534 | 12.051 |
| string: canterbury/alice29.txt | 159425 | 10935.8 ± 1.4% | 2226.3 ± 4.4% | 2358.3 ± 2.4% | 261.9 ± 0.5% | 1044.1 ± 2.9% | 833.1 ± 2.2% | 4.912 | 4.637 | 41.753 | 10.474 | 13.127 |
| string: canterbury/asyoulik.txt | 132198 | 9593.7 ± 0.9% | 1668.2 ± 3.5% | 2388.6 ± 0.8% | 267.4 ± 0.9% | 883.0 ± 2.9% | 739.9 ± 1.8% | 5.751 | 4.017 | 35.875 | 10.865 | 12.966 |
| string: canterbury/lcet10.txt | 441884 | 10445.9 ± 2.2% | 2297.9 ± 3.1% | 2076.1 ± 1.5% | 296.3 ± 0.5% | 1107.3 ± 3.3% | 909.1 ± 2.7% | 4.546 | 5.032 | 35.254 | 9.434 | 11.490 |
| string: canterbury/plrabn12.txt | 503330 | 7145.0 ± 5.2% | 1713.6 ± 2.9% | 1637.7 ± 1.1% | 277.2 ± 2.3% | 958.0 ± 3.1% | 804.3 ± 1.8% | 4.170 | 4.363 | 25.779 | 7.459 | 8.883 |
| string: canterbury-large/E.coli | 1048578 | 24768.9 ± 0.6% | 11211.6 ± 0.8% | 2787.3 ± 0.8% | 1328.0 ± 0.5% | 1553.6 ± 17.0% | 1097.7 ± 0.5% | 2.209 | 8.886 | 18.652 | 15.943 | 22.564 |
| string: canterbury-large/bible.txt | 1055886 | 7860.5 ± 5.5% | 3703.3 ± 1.9% | 2407.0 ± 1.6% | 321.6 ± 1.3% | 1463.8 ± 6.2% | 1116.5 ± 2.0% | 2.123 | 3.266 | 24.442 | 5.370 | 7.040 |
| string: canterbury-large/world192.txt | 1103121 | 5203.3 ± 5.7% | 1325.8 ± 0.6% | 1496.7 ± 1.3% | 294.4 ± 0.8% | 934.9 ± 2.0% | 784.1 ± 1.7% | 3.925 | 3.476 | 17.672 | 5.566 | 6.636 |
| string: http/html-1m | 1058582 | 7772.5 ± 2.8% | 3379.8 ± 0.8% | 2354.9 ± 0.4% | 329.8 ± 2.3% | 1392.8 ± 2.9% | 664.1 ± 1.8% | 2.300 | 3.301 | 23.569 | 5.580 | 11.704 |
| string: http/json-1m | 1190272 | 6999.9 ± 1.2% | 1183.1 ± 2.2% | 1267.4 ± 0.9% | 398.2 ± 7.2% | 783.9 ± 1.4% | 672.2 ± 0.9% | 5.917 | 5.523 | 17.580 | 8.930 | 10.414 |
| string: http/js-1m | 1144362 | 5294.4 ± 0.9% | 865.0 ± 0.8% | 1103.9 ± 0.6% | 261.6 ± 2.1% | 776.1 ± 5.6% | 607.6 ± 1.3% | 6.121 | 4.796 | 20.239 | 6.821 | 8.713 |
| string: http/css-1m | 1097820 | 8527.5 ± 0.8% | 1115.1 ± 0.5% | 1629.3 ± 1.8% | 369.0 ± 1.7% | 919.3 ± 3.6% | 764.3 ± 0.9% | 7.647 | 5.234 | 23.111 | 9.276 | 11.157 |
| string: dickens as Cyrillic and CJK | 1883069 | 4400.7 ± 2.0% | 2866.7 ± 1.8% | 362.3 ± 0.8% | 193.3 ± 1.3% | 340.7 ± 1.8% | 279.1 ± 1.6% | 1.535 | 12.146 | 22.765 | 12.917 | 15.767 |
| hex: silesia/dickens | 524290 | 27662.9 ± 3.8% | 1941.3 ± 1.2% | 1194.7 ± 1.0% | 350.5 ± 0.6% | 904.7 ± 1.3% | 827.2 ± 4.0% | 14.249 | 23.155 | 78.923 | 30.576 | 33.444 |
| hex: silesia/mozilla | 524290 | 27485.7 ± 1.6% | 1823.5 ± 6.3% | 1186.3 ± 4.8% | 310.6 ± 2.0% | 912.2 ± 3.1% | 826.7 ± 2.0% | 15.073 | 23.169 | 88.495 | 30.132 | 33.247 |
| hex: silesia/mr | 524290 | 27642.5 ± 4.6% | 1941.6 ± 1.9% | 1186.5 ± 0.9% | 454.9 ± 0.5% | 911.9 ± 1.3% | 827.9 ± 0.9% | 14.237 | 23.298 | 60.765 | 30.313 | 33.388 |
| hex: silesia/nci | 524290 | 31821.5 ± 1.2% | 1890.0 ± 3.7% | 1188.3 ± 1.0% | 598.6 ± 1.3% | 918.9 ± 2.3% | 829.9 ± 0.8% | 16.836 | 26.778 | 53.160 | 34.632 | 38.346 |
| hex: silesia/ooffice | 524290 | 28255.4 ± 1.8% | 1909.6 ± 3.2% | 1190.5 ± 0.5% | 258.4 ± 0.5% | 918.7 ± 2.6% | 830.5 ± 2.2% | 14.796 | 23.734 | 109.364 | 30.755 | 34.020 |
| hex: silesia/osdb | 524290 | 28089.5 ± 1.3% | 1950.9 ± 2.7% | 1190.4 ± 0.9% | 344.0 ± 0.9% | 927.0 ± 4.1% | 828.6 ± 1.9% | 14.398 | 23.596 | 81.656 | 30.301 | 33.899 |
| hex: silesia/reymont | 524290 | 28064.7 ± 1.3% | 1955.7 ± 3.8% | 1190.5 ± 0.8% | 373.6 ± 1.3% | 948.3 ± 7.1% | 830.2 ± 1.2% | 14.350 | 23.574 | 75.125 | 29.594 | 33.806 |
| hex: silesia/samba | 524290 | 31792.7 ± 0.8% | 1897.0 ± 4.3% | 1190.4 ± 1.9% | 275.2 ± 0.6% | 939.5 ± 4.5% | 816.9 ± 3.7% | 16.759 | 26.708 | 115.538 | 33.838 | 38.917 |
| hex: silesia/sao | 524290 | 28309.6 ± 0.8% | 1933.8 ± 8.5% | 1192.9 ± 0.7% | 211.9 ± 0.6% | 914.6 ± 7.5% | 829.6 ± 2.4% | 14.639 | 23.732 | 133.618 | 30.954 | 34.126 |
| hex: silesia/webster | 524290 | 29253.2 ± 1.8% | 1857.8 ± 6.9% | 1189.7 ± 9.0% | 327.3 ± 0.7% | 919.5 ± 3.5% | 829.9 ± 2.0% | 15.746 | 24.589 | 89.378 | 31.815 | 35.250 |
| hex: silesia/x-ray | 524290 | 27625.0 ± 1.5% | 1928.7 ± 4.2% | 1191.1 ± 0.8% | 323.1 ± 0.9% | 917.9 ± 3.0% | 830.1 ± 1.7% | 14.323 | 23.193 | 85.512 | 30.095 | 33.280 |
| hex: silesia/xml | 524290 | 31789.6 ± 1.6% | 1906.3 ± 3.0% | 1195.4 ± 0.7% | 535.2 ± 0.9% | 952.0 ± 2.6% | 831.7 ± 3.7% | 16.676 | 26.594 | 59.397 | 33.394 | 38.221 |
| hex: canterbury/alice29.txt | 304180 | 28052.3 ± 1.2% | 1919.8 ± 6.1% | 1201.4 ± 1.0% | 357.4 ± 1.1% | 948.0 ± 3.4% | 840.8 ± 1.0% | 14.612 | 23.350 | 78.482 | 29.591 | 33.362 |
| hex: canterbury/asyoulik.txt | 250360 | 27733.9 ± 1.6% | 1832.2 ± 8.6% | 1217.7 ± 1.1% | 347.6 ± 0.6% | 954.7 ± 7.8% | 841.9 ± 1.3% | 15.137 | 22.775 | 79.790 | 29.050 | 32.940 |
| hex: canterbury/cp.html | 49208 | 27224.5 ± 0.3% | 1812.6 ± 2.7% | 1201.9 ± 0.6% | 357.3 ± 0.9% | 1006.4 ± 5.0% | 837.0 ± 5.7% | 15.020 | 22.652 | 76.198 | 27.052 | 32.525 |
| hex: canterbury/fields.c | 22302 | 31153.3 ± 0.3% | 1935.0 ± 4.1% | 1198.8 ± 0.7% | 551.3 ± 1.1% | 1000.2 ± 13.6% | 826.7 ± 1.9% | 16.100 | 25.987 | 56.509 | 31.148 | 37.682 |
| hex: canterbury/grammar.lsp | 7444 | 26367.5 ± 3.9% | 1866.9 ± 16.2% | 1211.9 ± 1.3% | 624.8 ± 0.9% | 938.0 ± 9.6% | 843.1 ± 5.8% | 14.124 | 21.758 | 42.200 | 28.109 | 31.275 |
| hex: canterbury/kennedy.xls | 524290 | 27997.0 ± 0.8% | 1889.2 ± 5.9% | 1186.9 ± 1.0% | 593.0 ± 0.7% | 890.4 ± 2.7% | 826.2 ± 0.9% | 14.819 | 23.588 | 47.212 | 31.445 | 33.888 |
| hex: canterbury/lcet10.txt | 524290 | 31707.3 ± 1.7% | 1913.1 ± 5.3% | 1186.9 ± 0.8% | 357.2 ± 0.8% | 915.3 ± 4.8% | 834.1 ± 1.1% | 16.574 | 26.715 | 88.773 | 34.643 | 38.016 |
| hex: canterbury/plrabn12.txt | 524290 | 27943.6 ± 0.5% | 1909.4 ± 5.2% | 1187.6 ± 7.3% | 345.2 ± 0.9% | 916.9 ± 3.9% | 834.6 ± 1.5% | 14.635 | 23.530 | 80.937 | 30.477 | 33.481 |
| hex: canterbury/ptt5 | 524290 | 27914.0 ± 1.2% | 1920.6 ± 10.3% | 1188.7 ± 2.0% | 459.9 ± 0.4% | 909.3 ± 4.0% | 831.6 ± 3.2% | 14.534 | 23.482 | 60.695 | 30.699 | 33.566 |
| hex: canterbury/sum | 76482 | 27533.1 ± 0.4% | 1853.5 ± 5.7% | 1185.8 ± 0.6% | 437.6 ± 2.8% | 1013.5 ± 5.1% | 836.4 ± 2.0% | 14.855 | 23.220 | 62.923 | 27.167 | 32.920 |
| hex: canterbury/xargs.1 | 8456 | 29448.0 ± 2.2% | 1942.3 ± 8.8% | 1214.0 ± 8.2% | 629.9 ± 4.7% | 1000.5 ± 13.0% | 843.1 ± 2.2% | 15.162 | 24.258 | 46.750 | 29.435 | 34.927 |
| hex: canterbury-large/E.coli | 524290 | 27593.8 ± 2.5% | 1942.0 ± 3.8% | 1185.7 ± 0.7% | 607.9 ± 0.5% | 904.0 ± 2.0% | 825.7 ± 2.1% | 14.209 | 23.272 | 45.394 | 30.523 | 33.418 |
| hex: canterbury-large/bible.txt | 524290 | 31720.2 ± 1.2% | 1844.1 ± 6.4% | 1197.3 ± 1.7% | 367.9 ± 0.4% | 899.4 ± 1.4% | 832.9 ± 1.6% | 17.201 | 26.492 | 86.221 | 35.269 | 38.086 |
| hex: canterbury-large/world192.txt | 524290 | 28168.4 ± 0.8% | 1903.6 ± 4.3% | 1191.1 ± 1.2% | 347.8 ± 1.0% | 915.2 ± 4.3% | 824.0 ± 1.1% | 14.797 | 23.649 | 80.984 | 30.777 | 34.185 |
| hex: http/html-1kx1024 | 2099200 | 18306.3 ± 1.7% | 1847.4 ± 0.4% | 1114.4 ± 0.3% | 375.0 ± 0.4% | 884.8 ± 4.9% | 807.7 ± 2.1% | 9.909 | 16.427 | 48.818 | 20.691 | 22.666 |
| hex: http/html-16kx64 | 2097280 | 18657.6 ± 0.9% | 1820.0 ± 1.0% | 1134.1 ± 0.7% | 375.1 ± 0.7% | 910.5 ± 15.0% | 828.9 ± 2.4% | 10.251 | 16.451 | 49.745 | 20.492 | 22.510 |
| hex: http/html-1m | 524290 | 27314.1 ± 0.7% | 1952.6 ± 4.4% | 1193.6 ± 1.4% | 362.0 ± 3.0% | 898.7 ± 6.7% | 828.8 ± 2.3% | 13.988 | 22.884 | 75.445 | 30.391 | 32.958 |
| hex: http/json-1kx1024 | 2099200 | 18150.8 ± 0.3% | 1841.0 ± 0.9% | 1111.2 ± 0.8% | 542.9 ± 1.4% | 882.2 ± 4.4% | 809.9 ± 1.8% | 9.859 | 16.334 | 33.433 | 20.574 | 22.410 |
| hex: http/json-16kx64 | 2097280 | 19310.1 ± 0.5% | 1802.5 ± 2.6% | 1132.9 ± 1.0% | 549.2 ± 0.4% | 929.7 ± 7.3% | 833.2 ± 1.5% | 10.713 | 17.045 | 35.164 | 20.770 | 23.175 |
| hex: http/json-1m | 524290 | 28122.4 ± 1.9% | 1920.1 ± 0.7% | 1187.8 ± 2.2% | 574.2 ± 1.9% | 875.3 ± 2.5% | 827.2 ± 2.2% | 14.646 | 23.677 | 48.976 | 32.129 | 33.997 |
| hex: http/js-1kx1024 | 2099200 | 17999.7 ± 1.0% | 1838.8 ± 1.2% | 1115.2 ± 0.5% | 372.1 ± 0.4% | 896.5 ± 3.4% | 807.9 ± 2.7% | 9.789 | 16.141 | 48.378 | 20.078 | 22.279 |
| hex: http/js-16kx64 | 2097280 | 19363.3 ± 3.0% | 1812.1 ± 2.4% | 1132.6 ± 1.1% | 372.0 ± 4.3% | 916.8 ± 8.3% | 827.3 ± 5.7% | 10.685 | 17.096 | 52.045 | 21.119 | 23.407 |
| hex: http/js-1m | 524290 | 28063.6 ± 0.6% | 1955.2 ± 6.3% | 1186.9 ± 0.8% | 374.8 ± 0.9% | 891.6 ± 4.9% | 827.4 ± 5.7% | 14.353 | 23.645 | 74.881 | 31.477 | 33.917 |
| hex: http/css-1kx1024 | 2099200 | 17909.1 ± 0.5% | 1837.8 ± 0.6% | 1114.4 ± 0.7% | 418.7 ± 0.8% | 877.8 ± 4.2% | 818.1 ± 2.6% | 9.745 | 16.071 | 42.777 | 20.403 | 21.890 |
| hex: http/css-16kx64 | 2097280 | 19233.2 ± 0.3% | 1798.6 ± 1.0% | 1133.8 ± 0.6% | 419.7 ± 0.7% | 946.1 ± 5.7% | 827.9 ± 6.4% | 10.694 | 16.964 | 45.821 | 20.328 | 23.232 |
| hex: http/css-1m | 524290 | 27985.3 ± 1.3% | 1863.0 ± 5.8% | 1184.9 ± 0.6% | 402.3 ± 0.2% | 920.1 ± 6.2% | 825.6 ± 1.3% | 15.021 | 23.619 | 69.567 | 30.417 | 33.895 |
| hex: shuffled/dickens-1m | 524290 | 27908.7 ± 0.7% | 1937.8 ± 3.6% | 1188.9 ± 0.2% | 351.1 ± 0.5% | 924.4 ± 1.7% | 826.5 ± 0.9% | 14.402 | 23.474 | 79.480 | 30.190 | 33.767 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 897.3 ± 1.3% | 1188.6 ± 1.9% | 832.7 ± 1.7% | 296.6 ± 0.7% | 473.0 ± 1.0% | 278.7 ± 2.7% | 0.755 | 1.078 | 3.025 | 1.897 | 3.219 |
| qlog records, JSON text sequence | 1467503 | 766.6 ± 1.8% | 937.2 ± 0.4% | 841.7 ± 0.8% | 258.6 ± 0.8% | 535.1 ± 1.1% | 238.4 ± 1.2% | 0.818 | 0.911 | 2.964 | 1.433 | 3.216 |
| string: silesia/dickens | 172528 | 5393.2 ± 0.8% | 2557.7 ± 1.9% | 2348.4 ± 4.3% | 231.8 ± 0.8% | 2615.8 ± 2.4% | 464.5 ± 1.3% | 2.109 | 2.296 | 23.264 | 2.062 | 11.611 |
| string: silesia/nci | 1075110 | 3996.5 ± 0.7% | 3081.0 ± 1.3% | 2372.9 ± 0.6% | 526.6 ± 0.8% | 2859.8 ± 0.9% | 505.0 ± 2.0% | 1.297 | 1.684 | 7.589 | 1.397 | 7.913 |
| string: silesia/reymont | 1075159 | 3082.5 ± 5.5% | 2656.4 ± 0.7% | 1489.7 ± 2.3% | 239.0 ± 3.1% | 1628.6 ± 2.7% | 421.8 ± 1.4% | 1.160 | 2.069 | 12.896 | 1.893 | 7.307 |
| string: silesia/samba | 97582 | 3068.9 ± 0.9% | 2794.2 ± 0.5% | 2211.9 ± 4.3% | 249.5 ± 1.4% | 1535.9 ± 1.3% | 330.3 ± 1.7% | 1.098 | 1.387 | 12.302 | 1.998 | 9.292 |
| string: silesia/webster | 1098490 | 3422.8 ± 2.5% | 1882.0 ± 0.7% | 1383.0 ± 0.9% | 231.9 ± 0.9% | 1674.1 ± 0.7% | 386.2 ± 1.2% | 1.819 | 2.475 | 14.757 | 2.045 | 8.864 |
| string: silesia/xml | 1090118 | 4888.5 ± 0.9% | 3950.5 ± 0.9% | 1917.6 ± 1.0% | 377.1 ± 0.7% | 2600.6 ± 0.4% | 463.0 ± 1.5% | 1.237 | 2.549 | 12.962 | 1.880 | 10.558 |
| string: canterbury/alice29.txt | 159425 | 4523.8 ± 2.0% | 2188.6 ± 0.9% | 2335.6 ± 2.0% | 223.0 ± 0.8% | 2380.9 ± 1.6% | 414.3 ± 4.5% | 2.067 | 1.937 | 20.285 | 1.900 | 10.919 |
| string: canterbury/asyoulik.txt | 132198 | 3384.9 ± 2.5% | 1749.6 ± 7.5% | 2187.3 ± 5.2% | 223.6 ± 0.7% | 1883.7 ± 2.0% | 364.9 ± 4.1% | 1.935 | 1.547 | 15.137 | 1.797 | 9.275 |
| string: canterbury/lcet10.txt | 441884 | 5221.8 ± 1.0% | 2454.3 ± 2.4% | 1783.7 ± 0.5% | 258.2 ± 1.1% | 2343.1 ± 5.3% | 446.6 ± 1.4% | 2.128 | 2.928 | 20.222 | 2.229 | 11.693 |
| string: canterbury/plrabn12.txt | 503330 | 4280.5 ± 1.9% | 2417.7 ± 0.9% | 1459.8 ± 0.7% | 238.6 ± 1.2% | 2213.0 ± 0.8% | 407.1 ± 0.9% | 1.770 | 2.932 | 17.943 | 1.934 | 10.514 |
| string: canterbury-large/E.coli | 1048578 | 25352.8 ± 1.0% | 10322.4 ± 1.9% | 2678.4 ± 1.6% | 854.6 ± 0.4% | 6476.1 ± 2.1% | 830.7 ± 1.3% | 2.456 | 9.466 | 29.668 | 3.915 | 30.519 |
| string: canterbury-large/bible.txt | 1055886 | 6830.2 ± 1.0% | 4198.0 ± 1.5% | 2260.8 ± 1.2% | 251.1 ± 3.0% | 3102.1 ± 3.2% | 529.1 ± 1.7% | 1.627 | 3.021 | 27.199 | 2.202 | 12.910 |
| string: canterbury-large/world192.txt | 1103121 | 3383.1 ± 1.5% | 1768.4 ± 0.9% | 1436.1 ± 2.2% | 242.0 ± 0.7% | 1724.8 ± 1.2% | 389.3 ± 0.4% | 1.913 | 2.356 | 13.982 | 1.961 | 8.691 |
| string: http/html-1m | 1058582 | 6906.0 ± 12.1% | 3689.9 ± 1.3% | 2185.0 ± 0.6% | 296.7 ± 1.9% | 2927.2 ± 2.9% | 515.1 ± 2.2% | 1.872 | 3.161 | 23.275 | 2.359 | 13.407 |
| string: http/json-1m | 1190272 | 2850.6 ± 1.5% | 973.7 ± 1.5% | 1710.8 ± 0.8% | 362.1 ± 0.9% | 1073.9 ± 0.9% | 343.8 ± 2.0% | 2.927 | 1.666 | 7.873 | 2.654 | 8.291 |
| string: http/js-1m | 1144362 | 2383.2 ± 1.1% | 1248.6 ± 0.7% | 1064.3 ± 0.7% | 235.0 ± 0.9% | 1116.2 ± 0.6% | 308.5 ± 4.1% | 1.909 | 2.239 | 10.139 | 2.135 | 7.724 |
| string: http/css-1m | 1097820 | 2585.6 ± 0.9% | 2257.1 ± 0.4% | 1573.2 ± 1.2% | 324.7 ± 1.7% | 1652.6 ± 2.3% | 377.5 ± 0.7% | 1.146 | 1.643 | 7.962 | 1.565 | 6.849 |
| string: dickens as Cyrillic and CJK | 1883069 | 4606.9 ± 2.3% | 2811.2 ± 0.6% | 518.9 ± 1.2% | 286.5 ± 1.0% | 395.5 ± 1.3% | 127.6 ± 2.6% | 1.639 | 8.877 | 16.080 | 11.649 | 36.107 |
| string: dickens as Cyrillic and CJK, as \u escapes | 5075485 | 922.6 ± 4.5% | 957.0 ± 0.6% | 857.2 ± 0.8% | 204.0 ± 1.6% | 366.0 ± 1.6% | 172.2 ± 3.4% | 0.964 | 1.076 | 4.522 | 2.521 | 5.358 |
| hex: silesia/dickens | 524290 | 25372.2 ± 1.5% | 11633.6 ± 1.3% | 2710.4 ± 0.7% | 370.2 ± 1.7% | 6488.7 ± 0.7% | 856.6 ± 5.0% | 2.181 | 9.361 | 68.534 | 3.910 | 29.621 |
| hex: silesia/mozilla | 524290 | 25240.8 ± 3.2% | 11664.6 ± 2.6% | 2776.7 ± 0.5% | 320.8 ± 7.4% | 6494.5 ± 5.3% | 859.1 ± 1.6% | 2.164 | 9.090 | 78.686 | 3.887 | 29.381 |
| hex: silesia/mr | 524290 | 25179.2 ± 2.2% | 11726.5 ± 1.6% | 2777.8 ± 0.7% | 478.5 ± 2.6% | 6501.4 ± 7.0% | 854.1 ± 0.6% | 2.147 | 9.064 | 52.621 | 3.873 | 29.481 |
| hex: silesia/nci | 524290 | 25374.8 ± 0.8% | 11613.0 ± 2.0% | 2713.2 ± 1.0% | 598.1 ± 2.1% | 6464.0 ± 1.8% | 858.4 ± 1.5% | 2.185 | 9.352 | 42.427 | 3.926 | 29.561 |
| hex: silesia/ooffice | 524290 | 25316.4 ± 1.0% | 11702.7 ± 3.1% | 2777.5 ± 0.7% | 261.5 ± 4.9% | 6506.6 ± 0.6% | 853.8 ± 0.8% | 2.163 | 9.115 | 96.798 | 3.891 | 29.653 |
| hex: silesia/osdb | 524290 | 25318.9 ± 1.0% | 11664.7 ± 2.2% | 2775.5 ± 0.8% | 356.2 ± 5.0% | 6483.7 ± 1.1% | 860.9 ± 3.6% | 2.171 | 9.122 | 71.086 | 3.905 | 29.409 |
| hex: silesia/reymont | 524290 | 25226.5 ± 1.4% | 11665.8 ± 0.7% | 2704.4 ± 2.3% | 393.1 ± 1.5% | 6479.2 ± 1.2% | 858.3 ± 5.3% | 2.162 | 9.328 | 64.165 | 3.893 | 29.390 |
| hex: silesia/samba | 524290 | 25153.9 ± 2.3% | 11637.3 ± 2.1% | 2779.5 ± 0.5% | 282.1 ± 0.5% | 6478.6 ± 0.7% | 861.1 ± 1.2% | 2.161 | 9.050 | 89.157 | 3.883 | 29.213 |
| hex: silesia/sao | 524290 | 25272.0 ± 1.0% | 11659.3 ± 2.8% | 2671.4 ± 0.7% | 209.5 ± 2.7% | 6482.1 ± 2.4% | 857.5 ± 1.7% | 2.168 | 9.460 | 120.622 | 3.899 | 29.472 |
| hex: silesia/webster | 524290 | 25287.1 ± 1.6% | 11647.4 ± 9.6% | 2776.5 ± 0.7% | 346.4 ± 1.9% | 6496.2 ± 2.6% | 850.8 ± 2.4% | 2.171 | 9.107 | 73.006 | 3.893 | 29.722 |
| hex: silesia/x-ray | 524290 | 25255.7 ± 1.0% | 11697.6 ± 2.6% | 2709.8 ± 0.8% | 331.2 ± 3.8% | 6456.2 ± 0.4% | 854.8 ± 4.7% | 2.159 | 9.320 | 76.264 | 3.912 | 29.547 |
| hex: silesia/xml | 524290 | 25225.8 ± 0.8% | 11643.1 ± 3.2% | 2774.5 ± 3.3% | 584.1 ± 0.8% | 6480.2 ± 0.6% | 855.0 ± 1.5% | 2.167 | 9.092 | 43.187 | 3.893 | 29.504 |
| hex: canterbury/alice29.txt | 304180 | 25194.8 ± 1.0% | 11637.4 ± 1.1% | 2790.4 ± 0.8% | 372.4 ± 1.4% | 6468.5 ± 7.0% | 869.2 ± 4.3% | 2.165 | 9.029 | 67.652 | 3.895 | 28.986 |
| hex: canterbury/asyoulik.txt | 250360 | 25048.5 ± 0.4% | 11696.2 ± 0.8% | 2707.2 ± 6.4% | 366.6 ± 0.5% | 6463.4 ± 5.8% | 864.3 ± 1.5% | 2.142 | 9.252 | 68.331 | 3.875 | 28.983 |
| hex: canterbury/cp.html | 49208 | 25698.0 ± 0.9% | 11843.4 ± 0.7% | 2780.3 ± 1.3% | 390.0 ± 1.2% | 6691.9 ± 4.9% | 832.1 ± 3.1% | 2.170 | 9.243 | 65.889 | 3.840 | 30.883 |
| hex: canterbury/fields.c | 22302 | 25681.9 ± 0.9% | 13067.2 ± 1.2% | 2835.2 ± 0.9% | 472.9 ± 1.2% | 6680.1 ± 1.0% | 810.3 ± 2.3% | 1.965 | 9.058 | 54.312 | 3.845 | 31.693 |
| hex: canterbury/grammar.lsp | 7444 | 23153.4 ± 0.8% | 13802.8 ± 0.4% | 2825.2 ± 0.7% | 606.8 ± 4.2% | 6491.9 ± 0.7% | 784.4 ± 2.6% | 1.677 | 8.195 | 38.159 | 3.567 | 29.516 |
| hex: canterbury/kennedy.xls | 524290 | 25381.8 ± 1.1% | 11699.0 ± 0.9% | 2776.1 ± 1.0% | 599.7 ± 2.8% | 6473.2 ± 5.0% | 840.1 ± 3.0% | 2.170 | 9.143 | 42.322 | 3.921 | 30.213 |
| hex: canterbury/lcet10.txt | 524290 | 25163.9 ± 0.7% | 11685.2 ± 2.5% | 2773.5 ± 4.0% | 373.8 ± 1.0% | 6499.2 ± 0.8% | 838.4 ± 2.8% | 2.153 | 9.073 | 67.312 | 3.872 | 30.014 |
| hex: canterbury/plrabn12.txt | 524290 | 25212.6 ± 0.8% | 11585.0 ± 2.3% | 2777.7 ± 2.1% | 363.5 ± 2.0% | 6472.8 ± 1.1% | 845.5 ± 1.6% | 2.176 | 9.077 | 69.352 | 3.895 | 29.818 |
| hex: canterbury/ptt5 | 524290 | 25383.1 ± 1.0% | 11663.3 ± 1.7% | 2707.2 ± 0.6% | 482.6 ± 2.7% | 6461.3 ± 2.4% | 847.0 ± 0.9% | 2.176 | 9.376 | 52.600 | 3.928 | 29.969 |
| hex: canterbury/sum | 76482 | 24602.9 ± 1.7% | 11571.0 ± 0.4% | 2787.3 ± 0.6% | 430.3 ± 9.7% | 6468.3 ± 0.6% | 830.4 ± 3.2% | 2.126 | 8.827 | 57.174 | 3.804 | 29.628 |
| hex: canterbury/xargs.1 | 8456 | 23610.6 ± 0.6% | 13846.9 ± 0.8% | 2769.7 ± 0.7% | 595.0 ± 7.8% | 6526.3 ± 1.0% | 810.0 ± 1.5% | 1.705 | 8.525 | 39.685 | 3.618 | 29.148 |
| hex: canterbury-large/E.coli | 524290 | 25286.2 ± 1.5% | 11669.2 ± 2.0% | 2695.4 ± 0.4% | 600.6 ± 0.9% | 6482.4 ± 3.5% | 849.6 ± 5.7% | 2.167 | 9.381 | 42.100 | 3.901 | 29.764 |
| hex: canterbury-large/bible.txt | 524290 | 25238.8 ± 1.6% | 11675.2 ± 2.2% | 2709.2 ± 1.5% | 391.2 ± 0.7% | 6483.0 ± 0.4% | 854.5 ± 3.7% | 2.162 | 9.316 | 64.512 | 3.893 | 29.535 |
| hex: canterbury-large/world192.txt | 524290 | 25252.6 ± 0.8% | 11670.3 ± 1.9% | 2786.8 ± 0.8% | 368.9 ± 0.8% | 6486.2 ± 1.1% | 855.1 ± 2.1% | 2.164 | 9.061 | 68.451 | 3.893 | 29.533 |
| hex: http/html-1kx1024 | 2099200 | 14230.4 ± 3.3% | 10397.4 ± 1.3% | 2571.2 ± 2.0% | 386.9 ± 1.5% | 5095.7 ± 4.1% | 709.8 ± 3.1% | 1.369 | 5.535 | 36.782 | 2.793 | 20.047 |
| hex: http/html-16kx64 | 2097280 | 22715.0 ± 2.7% | 11708.2 ± 0.8% | 2649.9 ± 1.3% | 394.7 ± 0.9% | 6605.1 ± 0.9% | 788.5 ± 2.0% | 1.940 | 8.572 | 57.546 | 3.439 | 28.808 |
| hex: http/html-1m | 524290 | 25317.6 ± 1.5% | 11666.6 ± 1.3% | 2705.6 ± 0.1% | 391.4 ± 0.9% | 6489.8 ± 3.1% | 840.5 ± 4.1% | 2.170 | 9.357 | 64.691 | 3.901 | 30.122 |
| hex: http/json-1kx1024 | 2099200 | 14157.0 ± 1.4% | 10215.2 ± 0.8% | 2570.4 ± 5.1% | 565.6 ± 1.5% | 5193.4 ± 2.0% | 708.8 ± 2.3% | 1.386 | 5.508 | 25.028 | 2.726 | 19.974 |
| hex: http/json-16kx64 | 2097280 | 22690.9 ± 0.8% | 11718.0 ± 0.9% | 2661.0 ± 1.4% | 584.1 ± 1.9% | 6581.3 ± 0.4% | 804.2 ± 5.7% | 1.936 | 8.527 | 38.845 | 3.448 | 28.216 |
| hex: http/json-1m | 524290 | 25349.8 ± 1.2% | 11618.0 ± 1.9% | 2760.2 ± 0.8% | 616.6 ± 0.5% | 6441.2 ± 6.8% | 844.8 ± 2.8% | 2.182 | 9.184 | 41.113 | 3.936 | 30.008 |
| hex: http/js-1kx1024 | 2099200 | 14134.1 ± 0.8% | 10236.7 ± 0.8% | 2562.9 ± 0.7% | 380.5 ± 0.7% | 5148.1 ± 4.0% | 710.7 ± 2.1% | 1.381 | 5.515 | 37.143 | 2.745 | 19.886 |
| hex: http/js-16kx64 | 2097280 | 22581.3 ± 1.3% | 11665.5 ± 0.6% | 2649.8 ± 1.0% | 385.1 ± 1.3% | 6559.0 ± 0.6% | 788.8 ± 7.1% | 1.936 | 8.522 | 58.632 | 3.443 | 28.629 |
| hex: http/js-1m | 524290 | 25250.1 ± 1.8% | 11649.3 ± 0.7% | 2780.2 ± 1.3% | 400.7 ± 1.2% | 6505.8 ± 0.4% | 843.0 ± 3.4% | 2.168 | 9.082 | 63.019 | 3.881 | 29.952 |
| hex: http/css-1kx1024 | 2099200 | 14229.4 ± 0.7% | 10242.9 ± 0.4% | 2565.8 ± 0.8% | 440.6 ± 0.9% | 5181.3 ± 2.9% | 695.9 ± 1.1% | 1.389 | 5.546 | 32.299 | 2.746 | 20.449 |
| hex: http/css-16kx64 | 2097280 | 22594.8 ± 0.2% | 11684.0 ± 0.6% | 2650.5 ± 0.9% | 449.8 ± 1.0% | 6548.3 ± 1.5% | 798.0 ± 1.7% | 1.934 | 8.525 | 50.232 | 3.450 | 28.314 |
| hex: http/css-1m | 524290 | 25339.8 ± 0.8% | 11471.7 ± 3.9% | 2778.9 ± 0.4% | 430.8 ± 2.9% | 6450.3 ± 5.4% | 824.5 ± 2.3% | 2.209 | 9.119 | 58.821 | 3.928 | 30.735 |
| hex: shuffled/dickens-1m | 524290 | 25229.4 ± 1.6% | 11701.5 ± 3.2% | 2706.9 ± 0.5% | 373.2 ± 0.7% | 6492.3 ± 0.7% | 845.0 ± 6.1% | 2.156 | 9.320 | 67.599 | 3.886 | 29.856 |

## TextReader.next_items against the baselines

stdx's decoder a slice of tokens a call through `TextReader.next_items`, as a caller that reads a text's values in a loop calls it (decision 79). Octets are the text's. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1019.0 ± 4.2% | 1188.6 ± 1.9% | 832.7 ± 1.7% | 296.6 ± 0.7% | 473.0 ± 1.0% | 278.7 ± 2.7% | 0.857 | 1.224 | 3.435 | 2.154 | 3.656 |
| qlog records, JSON text sequence | 1467503 | 875.1 ± 0.6% | 937.2 ± 0.4% | 841.7 ± 0.8% | 258.6 ± 0.8% | 535.1 ± 1.1% | 238.4 ± 1.2% | 0.934 | 1.040 | 3.383 | 1.635 | 3.671 |
| string: silesia/dickens | 172528 | 5428.0 ± 1.0% | 2557.7 ± 1.9% | 2348.4 ± 4.3% | 231.8 ± 0.8% | 2615.8 ± 2.4% | 464.5 ± 1.3% | 2.122 | 2.311 | 23.415 | 2.075 | 11.685 |
| string: silesia/nci | 1075110 | 4033.0 ± 0.4% | 3081.0 ± 1.3% | 2372.9 ± 0.6% | 526.6 ± 0.8% | 2859.8 ± 0.9% | 505.0 ± 2.0% | 1.309 | 1.700 | 7.658 | 1.410 | 7.985 |
| string: silesia/reymont | 1075159 | 3127.4 ± 5.4% | 2656.4 ± 0.7% | 1489.7 ± 2.3% | 239.0 ± 3.1% | 1628.6 ± 2.7% | 421.8 ± 1.4% | 1.177 | 2.099 | 13.084 | 1.920 | 7.414 |
| string: silesia/samba | 97582 | 3091.1 ± 1.0% | 2794.2 ± 0.5% | 2211.9 ± 4.3% | 249.5 ± 1.4% | 1535.9 ± 1.3% | 330.3 ± 1.7% | 1.106 | 1.398 | 12.392 | 2.013 | 9.359 |
| string: silesia/webster | 1098490 | 3493.6 ± 1.5% | 1882.0 ± 0.7% | 1383.0 ± 0.9% | 231.9 ± 0.9% | 1674.1 ± 0.7% | 386.2 ± 1.2% | 1.856 | 2.526 | 15.062 | 2.087 | 9.047 |
| string: silesia/xml | 1090118 | 4949.7 ± 0.8% | 3950.5 ± 0.9% | 1917.6 ± 1.0% | 377.1 ± 0.7% | 2600.6 ± 0.4% | 463.0 ± 1.5% | 1.253 | 2.581 | 13.124 | 1.903 | 10.691 |
| string: canterbury/alice29.txt | 159425 | 4600.9 ± 1.5% | 2188.6 ± 0.9% | 2335.6 ± 2.0% | 223.0 ± 0.8% | 2380.9 ± 1.6% | 414.3 ± 4.5% | 2.102 | 1.970 | 20.631 | 1.932 | 11.105 |
| string: canterbury/asyoulik.txt | 132198 | 3438.9 ± 1.1% | 1749.6 ± 7.5% | 2187.3 ± 5.2% | 223.6 ± 0.7% | 1883.7 ± 2.0% | 364.9 ± 4.1% | 1.966 | 1.572 | 15.379 | 1.826 | 9.423 |
| string: canterbury/lcet10.txt | 441884 | 5288.0 ± 0.8% | 2454.3 ± 2.4% | 1783.7 ± 0.5% | 258.2 ± 1.1% | 2343.1 ± 5.3% | 446.6 ± 1.4% | 2.155 | 2.965 | 20.478 | 2.257 | 11.841 |
| string: canterbury/plrabn12.txt | 503330 | 4344.5 ± 0.8% | 2417.7 ± 0.9% | 1459.8 ± 0.7% | 238.6 ± 1.2% | 2213.0 ± 0.8% | 407.1 ± 0.9% | 1.797 | 2.976 | 18.211 | 1.963 | 10.671 |
| string: canterbury-large/E.coli | 1048578 | 25306.4 ± 0.6% | 10322.4 ± 1.9% | 2678.4 ± 1.6% | 854.6 ± 0.4% | 6476.1 ± 2.1% | 830.7 ± 1.3% | 2.452 | 9.448 | 29.614 | 3.908 | 30.463 |
| string: canterbury-large/bible.txt | 1055886 | 6907.6 ± 1.5% | 4198.0 ± 1.5% | 2260.8 ± 1.2% | 251.1 ± 3.0% | 3102.1 ± 3.2% | 529.1 ± 1.7% | 1.645 | 3.055 | 27.507 | 2.227 | 13.056 |
| string: canterbury-large/world192.txt | 1103121 | 3442.8 ± 2.1% | 1768.4 ± 0.9% | 1436.1 ± 2.2% | 242.0 ± 0.7% | 1724.8 ± 1.2% | 389.3 ± 0.4% | 1.947 | 2.397 | 14.229 | 1.996 | 8.844 |
| string: http/html-1m | 1058582 | 7483.7 ± 3.8% | 3689.9 ± 1.3% | 2185.0 ± 0.6% | 296.7 ± 1.9% | 2927.2 ± 2.9% | 515.1 ± 2.2% | 2.028 | 3.425 | 25.222 | 2.557 | 14.528 |
| string: http/json-1m | 1190272 | 2860.6 ± 0.9% | 973.7 ± 1.5% | 1710.8 ± 0.8% | 362.1 ± 0.9% | 1073.9 ± 0.9% | 343.8 ± 2.0% | 2.938 | 1.672 | 7.901 | 2.664 | 8.320 |
| string: http/js-1m | 1144362 | 2389.5 ± 0.8% | 1248.6 ± 0.7% | 1064.3 ± 0.7% | 235.0 ± 0.9% | 1116.2 ± 0.6% | 308.5 ± 4.1% | 1.914 | 2.245 | 10.166 | 2.141 | 7.745 |
| string: http/css-1m | 1097820 | 2619.1 ± 1.0% | 2257.1 ± 0.4% | 1573.2 ± 1.2% | 324.7 ± 1.7% | 1652.6 ± 2.3% | 377.5 ± 0.7% | 1.160 | 1.665 | 8.065 | 1.585 | 6.937 |
| string: dickens as Cyrillic and CJK | 1883069 | 4634.3 ± 1.1% | 2811.2 ± 0.6% | 518.9 ± 1.2% | 286.5 ± 1.0% | 395.5 ± 1.3% | 127.6 ± 2.6% | 1.649 | 8.930 | 16.176 | 11.718 | 36.322 |
| string: dickens as Cyrillic and CJK, as \u escapes | 5075485 | 919.5 ± 2.5% | 957.0 ± 0.6% | 857.2 ± 0.8% | 204.0 ± 1.6% | 366.0 ± 1.6% | 172.2 ± 3.4% | 0.961 | 1.073 | 4.506 | 2.512 | 5.340 |
| hex: silesia/dickens | 524290 | 25341.8 ± 1.8% | 11633.6 ± 1.3% | 2710.4 ± 0.7% | 370.2 ± 1.7% | 6488.7 ± 0.7% | 856.6 ± 5.0% | 2.178 | 9.350 | 68.452 | 3.906 | 29.586 |
| hex: silesia/mozilla | 524290 | 25304.0 ± 0.6% | 11664.6 ± 2.6% | 2776.7 ± 0.5% | 320.8 ± 7.4% | 6494.5 ± 5.3% | 859.1 ± 1.6% | 2.169 | 9.113 | 78.883 | 3.896 | 29.455 |
| hex: silesia/mr | 524290 | 25336.7 ± 1.5% | 11726.5 ± 1.6% | 2777.8 ± 0.7% | 478.5 ± 2.6% | 6501.4 ± 7.0% | 854.1 ± 0.6% | 2.161 | 9.121 | 52.951 | 3.897 | 29.666 |
| hex: silesia/nci | 524290 | 25318.0 ± 1.5% | 11613.0 ± 2.0% | 2713.2 ± 1.0% | 598.1 ± 2.1% | 6464.0 ± 1.8% | 858.4 ± 1.5% | 2.180 | 9.331 | 42.332 | 3.917 | 29.495 |
| hex: silesia/ooffice | 524290 | 25179.3 ± 1.1% | 11702.7 ± 3.1% | 2777.5 ± 0.7% | 261.5 ± 4.9% | 6506.6 ± 0.6% | 853.8 ± 0.8% | 2.152 | 9.065 | 96.274 | 3.870 | 29.492 |
| hex: silesia/osdb | 524290 | 25176.9 ± 0.3% | 11664.7 ± 2.2% | 2775.5 ± 0.8% | 356.2 ± 5.0% | 6483.7 ± 1.1% | 860.9 ± 3.6% | 2.158 | 9.071 | 70.687 | 3.883 | 29.244 |
| hex: silesia/reymont | 524290 | 25287.5 ± 1.4% | 11665.8 ± 0.7% | 2704.4 ± 2.3% | 393.1 ± 1.5% | 6479.2 ± 1.2% | 858.3 ± 5.3% | 2.168 | 9.350 | 64.320 | 3.903 | 29.461 |
| hex: silesia/samba | 524290 | 25337.3 ± 0.8% | 11637.3 ± 2.1% | 2779.5 ± 0.5% | 282.1 ± 0.5% | 6478.6 ± 0.7% | 861.1 ± 1.2% | 2.177 | 9.116 | 89.807 | 3.911 | 29.426 |
| hex: silesia/sao | 524290 | 25294.6 ± 2.9% | 11659.3 ± 2.8% | 2671.4 ± 0.7% | 209.5 ± 2.7% | 6482.1 ± 2.4% | 857.5 ± 1.7% | 2.169 | 9.469 | 120.730 | 3.902 | 29.498 |
| hex: silesia/webster | 524290 | 25324.7 ± 0.5% | 11647.4 ± 9.6% | 2776.5 ± 0.7% | 346.4 ± 1.9% | 6496.2 ± 2.6% | 850.8 ± 2.4% | 2.174 | 9.121 | 73.114 | 3.898 | 29.766 |
| hex: silesia/x-ray | 524290 | 25405.2 ± 0.5% | 11697.6 ± 2.6% | 2709.8 ± 0.8% | 331.2 ± 3.8% | 6456.2 ± 0.4% | 854.8 ± 4.7% | 2.172 | 9.375 | 76.715 | 3.935 | 29.722 |
| hex: silesia/xml | 524290 | 25135.0 ± 1.3% | 11643.1 ± 3.2% | 2774.5 ± 3.3% | 584.1 ± 0.8% | 6480.2 ± 0.6% | 855.0 ± 1.5% | 2.159 | 9.059 | 43.032 | 3.879 | 29.397 |
| hex: canterbury/alice29.txt | 304180 | 25141.7 ± 2.1% | 11637.4 ± 1.1% | 2790.4 ± 0.8% | 372.4 ± 1.4% | 6468.5 ± 7.0% | 869.2 ± 4.3% | 2.160 | 9.010 | 67.509 | 3.887 | 28.925 |
| hex: canterbury/asyoulik.txt | 250360 | 25228.5 ± 0.5% | 11696.2 ± 0.8% | 2707.2 ± 6.4% | 366.6 ± 0.5% | 6463.4 ± 5.8% | 864.3 ± 1.5% | 2.157 | 9.319 | 68.822 | 3.903 | 29.191 |
| hex: canterbury/cp.html | 49208 | 25793.0 ± 0.8% | 11843.4 ± 0.7% | 2780.3 ± 1.3% | 390.0 ± 1.2% | 6691.9 ± 4.9% | 832.1 ± 3.1% | 2.178 | 9.277 | 66.132 | 3.854 | 30.997 |
| hex: canterbury/fields.c | 22302 | 25662.7 ± 0.6% | 13067.2 ± 1.2% | 2835.2 ± 0.9% | 472.9 ± 1.2% | 6680.1 ± 1.0% | 810.3 ± 2.3% | 1.964 | 9.052 | 54.271 | 3.842 | 31.669 |
| hex: canterbury/grammar.lsp | 7444 | 23088.8 ± 1.5% | 13802.8 ± 0.4% | 2825.2 ± 0.7% | 606.8 ± 4.2% | 6491.9 ± 0.7% | 784.4 ± 2.6% | 1.673 | 8.173 | 38.052 | 3.557 | 29.433 |
| hex: canterbury/kennedy.xls | 524290 | 25231.2 ± 1.3% | 11699.0 ± 0.9% | 2776.1 ± 1.0% | 599.7 ± 2.8% | 6473.2 ± 5.0% | 840.1 ± 3.0% | 2.157 | 9.089 | 42.071 | 3.898 | 30.034 |
| hex: canterbury/lcet10.txt | 524290 | 25291.6 ± 1.5% | 11685.2 ± 2.5% | 2773.5 ± 4.0% | 373.8 ± 1.0% | 6499.2 ± 0.8% | 838.4 ± 2.8% | 2.164 | 9.119 | 67.654 | 3.892 | 30.166 |
| hex: canterbury/plrabn12.txt | 524290 | 25213.0 ± 2.9% | 11585.0 ± 2.3% | 2777.7 ± 2.1% | 363.5 ± 2.0% | 6472.8 ± 1.1% | 845.5 ± 1.6% | 2.176 | 9.077 | 69.353 | 3.895 | 29.818 |
| hex: canterbury/ptt5 | 524290 | 25275.6 ± 0.7% | 11663.3 ± 1.7% | 2707.2 ± 0.6% | 482.6 ± 2.7% | 6461.3 ± 2.4% | 847.0 ± 0.9% | 2.167 | 9.336 | 52.377 | 3.912 | 29.842 |
| hex: canterbury/sum | 76482 | 24679.7 ± 0.8% | 11571.0 ± 0.4% | 2787.3 ± 0.6% | 430.3 ± 9.7% | 6468.3 ± 0.6% | 830.4 ± 3.2% | 2.133 | 8.854 | 57.353 | 3.815 | 29.721 |
| hex: canterbury/xargs.1 | 8456 | 23497.1 ± 0.6% | 13846.9 ± 0.8% | 2769.7 ± 0.7% | 595.0 ± 7.8% | 6526.3 ± 1.0% | 810.0 ± 1.5% | 1.697 | 8.484 | 39.494 | 3.600 | 29.008 |
| hex: canterbury-large/E.coli | 524290 | 25437.4 ± 1.7% | 11669.2 ± 2.0% | 2695.4 ± 0.4% | 600.6 ± 0.9% | 6482.4 ± 3.5% | 849.6 ± 5.7% | 2.180 | 9.437 | 42.352 | 3.924 | 29.942 |
| hex: canterbury-large/bible.txt | 524290 | 25266.1 ± 1.7% | 11675.2 ± 2.2% | 2709.2 ± 1.5% | 391.2 ± 0.7% | 6483.0 ± 0.4% | 854.5 ± 3.7% | 2.164 | 9.326 | 64.581 | 3.897 | 29.567 |
| hex: canterbury-large/world192.txt | 524290 | 25380.9 ± 1.2% | 11670.3 ± 1.9% | 2786.8 ± 0.8% | 368.9 ± 0.8% | 6486.2 ± 1.1% | 855.1 ± 2.1% | 2.175 | 9.108 | 68.799 | 3.913 | 29.683 |
| hex: http/html-1kx1024 | 2099200 | 14009.4 ± 1.9% | 10397.4 ± 1.3% | 2571.2 ± 2.0% | 386.9 ± 1.5% | 5095.7 ± 4.1% | 709.8 ± 3.1% | 1.347 | 5.449 | 36.211 | 2.749 | 19.736 |
| hex: http/html-16kx64 | 2097280 | 22733.1 ± 1.1% | 11708.2 ± 0.8% | 2649.9 ± 1.3% | 394.7 ± 0.9% | 6605.1 ± 0.9% | 788.5 ± 2.0% | 1.942 | 8.579 | 57.592 | 3.442 | 28.831 |
| hex: http/html-1m | 524290 | 25288.4 ± 0.8% | 11666.6 ± 1.3% | 2705.6 ± 0.1% | 391.4 ± 0.9% | 6489.8 ± 3.1% | 840.5 ± 4.1% | 2.168 | 9.347 | 64.616 | 3.897 | 30.087 |
| hex: http/json-1kx1024 | 2099200 | 13994.2 ± 0.6% | 10215.2 ± 0.8% | 2570.4 ± 5.1% | 565.6 ± 1.5% | 5193.4 ± 2.0% | 708.8 ± 2.3% | 1.370 | 5.444 | 24.740 | 2.695 | 19.744 |
| hex: http/json-16kx64 | 2097280 | 22698.9 ± 0.5% | 11718.0 ± 0.9% | 2661.0 ± 1.4% | 584.1 ± 1.9% | 6581.3 ± 0.4% | 804.2 ± 5.7% | 1.937 | 8.530 | 38.858 | 3.449 | 28.226 |
| hex: http/json-1m | 524290 | 25233.6 ± 1.1% | 11618.0 ± 1.9% | 2760.2 ± 0.8% | 616.6 ± 0.5% | 6441.2 ± 6.8% | 844.8 ± 2.8% | 2.172 | 9.142 | 40.925 | 3.918 | 29.871 |
| hex: http/js-1kx1024 | 2099200 | 13898.4 ± 0.4% | 10236.7 ± 0.8% | 2562.9 ± 0.7% | 380.5 ± 0.7% | 5148.1 ± 4.0% | 710.7 ± 2.1% | 1.358 | 5.423 | 36.523 | 2.700 | 19.555 |
| hex: http/js-16kx64 | 2097280 | 22555.9 ± 1.1% | 11665.5 ± 0.6% | 2649.8 ± 1.0% | 385.1 ± 1.3% | 6559.0 ± 0.6% | 788.8 ± 7.1% | 1.934 | 8.512 | 58.566 | 3.439 | 28.597 |
| hex: http/js-1m | 524290 | 25366.5 ± 1.1% | 11649.3 ± 0.7% | 2780.2 ± 1.3% | 400.7 ± 1.2% | 6505.8 ± 0.4% | 843.0 ± 3.4% | 2.178 | 9.124 | 63.310 | 3.899 | 30.090 |
| hex: http/css-1kx1024 | 2099200 | 14051.0 ± 0.8% | 10242.9 ± 0.4% | 2565.8 ± 0.8% | 440.6 ± 0.9% | 5181.3 ± 2.9% | 695.9 ± 1.1% | 1.372 | 5.476 | 31.894 | 2.712 | 20.192 |
| hex: http/css-16kx64 | 2097280 | 22589.4 ± 0.5% | 11684.0 ± 0.6% | 2650.5 ± 0.9% | 449.8 ± 1.0% | 6548.3 ± 1.5% | 798.0 ± 1.7% | 1.933 | 8.523 | 50.220 | 3.450 | 28.307 |
| hex: http/css-1m | 524290 | 25294.8 ± 1.0% | 11471.7 ± 3.9% | 2778.9 ± 0.4% | 430.8 ± 2.9% | 6450.3 ± 5.4% | 824.5 ± 2.3% | 2.205 | 9.102 | 58.717 | 3.921 | 30.681 |
| hex: shuffled/dickens-1m | 524290 | 25254.3 ± 0.8% | 11701.5 ± 3.2% | 2706.9 ± 0.5% | 373.2 ± 0.7% | 6492.3 ± 0.7% | 845.0 ± 6.1% | 2.158 | 9.330 | 67.666 | 3.890 | 29.886 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1240.8 ± 1.9% | 1151.8 ± 0.4% | 783.7 ± 1.0% | 362.3 ± 1.0% | 324.3 ± 3.1% | 387.0 ± 4.9% | 1.077 | 1.583 | 3.425 | 3.826 | 3.207 |
| qlog records, JSON text sequence | 1467503 | 1040.8 ± 0.7% | 991.2 ± 1.1% | 725.4 ± 1.8% | 340.9 ± 1.7% | 366.3 ± 1.5% | 266.5 ± 1.1% | 1.050 | 1.435 | 3.053 | 2.841 | 3.905 |
| string: silesia/dickens | 172528 | 11434.0 ± 1.4% | 2901.4 ± 3.8% | 2498.2 ± 2.0% | 273.7 ± 0.6% | 1174.6 ± 9.5% | 919.8 ± 2.0% | 3.941 | 4.577 | 41.775 | 9.734 | 12.431 |
| string: silesia/nci | 1075110 | 9025.1 ± 1.2% | 3528.5 ± 1.3% | 2389.5 ± 0.8% | 711.3 ± 0.8% | 1288.1 ± 4.8% | 990.9 ± 2.3% | 2.558 | 3.777 | 12.688 | 7.007 | 9.108 |
| string: silesia/reymont | 1075159 | 4181.8 ± 0.7% | 1441.8 ± 3.2% | 1514.3 ± 2.8% | 297.7 ± 0.7% | 995.4 ± 7.3% | 868.8 ± 0.8% | 2.900 | 2.761 | 14.045 | 4.201 | 4.813 |
| string: silesia/samba | 97582 | 4698.2 ± 3.9% | 2102.7 ± 7.3% | 2971.9 ± 0.4% | 289.6 ± 0.5% | 994.3 ± 3.3% | 955.1 ± 0.8% | 2.234 | 1.581 | 16.221 | 4.725 | 4.919 |
| string: silesia/webster | 1098490 | 5224.5 ± 5.8% | 1504.2 ± 1.0% | 1415.5 ± 1.3% | 294.9 ± 0.8% | 930.1 ± 2.0% | 468.9 ± 0.8% | 3.473 | 3.691 | 17.716 | 5.617 | 11.141 |
| string: silesia/xml | 1090118 | 8038.5 ± 0.6% | 2399.9 ± 2.6% | 2003.9 ± 0.9% | 483.2 ± 4.3% | 1220.8 ± 6.8% | 763.3 ± 3.4% | 3.350 | 4.011 | 16.637 | 6.584 | 10.532 |
| string: canterbury/alice29.txt | 159425 | 10560.2 ± 4.6% | 2226.3 ± 4.4% | 2358.3 ± 2.4% | 261.9 ± 0.5% | 1044.1 ± 2.9% | 833.1 ± 2.2% | 4.743 | 4.478 | 40.319 | 10.114 | 12.676 |
| string: canterbury/asyoulik.txt | 132198 | 9104.3 ± 0.9% | 1668.2 ± 3.5% | 2388.6 ± 0.8% | 267.4 ± 0.9% | 883.0 ± 2.9% | 739.9 ± 1.8% | 5.458 | 3.812 | 34.045 | 10.311 | 12.305 |
| string: canterbury/lcet10.txt | 441884 | 8931.1 ± 2.8% | 2297.9 ± 3.1% | 2076.1 ± 1.5% | 296.3 ± 0.5% | 1107.3 ± 3.3% | 909.1 ± 2.7% | 3.887 | 4.302 | 30.141 | 8.066 | 9.824 |
| string: canterbury/plrabn12.txt | 503330 | 6467.5 ± 1.8% | 1713.6 ± 2.9% | 1637.7 ± 1.1% | 277.2 ± 2.3% | 958.0 ± 3.1% | 804.3 ± 1.8% | 3.774 | 3.949 | 23.335 | 6.751 | 8.041 |
| string: canterbury-large/E.coli | 1048578 | 24897.9 ± 1.5% | 11211.6 ± 0.8% | 2787.3 ± 0.8% | 1328.0 ± 0.5% | 1553.6 ± 17.0% | 1097.7 ± 0.5% | 2.221 | 8.933 | 18.749 | 16.026 | 22.681 |
| string: canterbury-large/bible.txt | 1055886 | 7134.0 ± 2.0% | 3703.3 ± 1.9% | 2407.0 ± 1.6% | 321.6 ± 1.3% | 1463.8 ± 6.2% | 1116.5 ± 2.0% | 1.926 | 2.964 | 22.183 | 4.874 | 6.390 |
| string: canterbury-large/world192.txt | 1103121 | 4954.3 ± 1.6% | 1325.8 ± 0.6% | 1496.7 ± 1.3% | 294.4 ± 0.8% | 934.9 ± 2.0% | 784.1 ± 1.7% | 3.737 | 3.310 | 16.826 | 5.299 | 6.319 |
| string: http/html-1m | 1058582 | 7697.3 ± 1.3% | 3379.8 ± 0.8% | 2354.9 ± 0.4% | 329.8 ± 2.3% | 1392.8 ± 2.9% | 664.1 ± 1.8% | 2.277 | 3.269 | 23.340 | 5.526 | 11.591 |
| string: http/json-1m | 1190272 | 7131.3 ± 0.5% | 1183.1 ± 2.2% | 1267.4 ± 0.9% | 398.2 ± 7.2% | 783.9 ± 1.4% | 672.2 ± 0.9% | 6.028 | 5.627 | 17.910 | 9.097 | 10.610 |
| string: http/js-1m | 1144362 | 5047.9 ± 1.8% | 865.0 ± 0.8% | 1103.9 ± 0.6% | 261.6 ± 2.1% | 776.1 ± 5.6% | 607.6 ± 1.3% | 5.836 | 4.573 | 19.297 | 6.504 | 8.308 |
| string: http/css-1m | 1097820 | 6737.2 ± 0.6% | 1115.1 ± 0.5% | 1629.3 ± 1.8% | 369.0 ± 1.7% | 919.3 ± 3.6% | 764.3 ± 0.9% | 6.042 | 4.135 | 18.260 | 7.329 | 8.815 |
| string: dickens as Cyrillic and CJK | 1883069 | 4314.6 ± 1.3% | 2866.7 ± 1.8% | 362.3 ± 0.8% | 193.3 ± 1.3% | 340.7 ± 1.8% | 279.1 ± 1.6% | 1.505 | 11.909 | 22.320 | 12.664 | 15.458 |
| hex: silesia/dickens | 524290 | 27606.2 ± 0.7% | 1941.3 ± 1.2% | 1194.7 ± 1.0% | 350.5 ± 0.6% | 904.7 ± 1.3% | 827.2 ± 4.0% | 14.220 | 23.107 | 78.762 | 30.514 | 33.375 |
| hex: silesia/mozilla | 524290 | 27606.4 ± 0.9% | 1823.5 ± 6.3% | 1186.3 ± 4.8% | 310.6 ± 2.0% | 912.2 ± 3.1% | 826.7 ± 2.0% | 15.139 | 23.271 | 88.884 | 30.264 | 33.393 |
| hex: silesia/mr | 524290 | 27793.6 ± 1.6% | 1941.6 ± 1.9% | 1186.5 ± 0.9% | 454.9 ± 0.5% | 911.9 ± 1.3% | 827.9 ± 0.9% | 14.315 | 23.426 | 61.098 | 30.479 | 33.571 |
| hex: silesia/nci | 524290 | 31712.2 ± 1.4% | 1890.0 ± 3.7% | 1188.3 ± 1.0% | 598.6 ± 1.3% | 918.9 ± 2.3% | 829.9 ± 0.8% | 16.779 | 26.686 | 52.977 | 34.513 | 38.214 |
| hex: silesia/ooffice | 524290 | 28235.7 ± 0.2% | 1909.6 ± 3.2% | 1190.5 ± 0.5% | 258.4 ± 0.5% | 918.7 ± 2.6% | 830.5 ± 2.2% | 14.786 | 23.717 | 109.288 | 30.734 | 33.996 |
| hex: silesia/osdb | 524290 | 28065.6 ± 2.7% | 1950.9 ± 2.7% | 1190.4 ± 0.9% | 344.0 ± 0.9% | 927.0 ± 4.1% | 828.6 ± 1.9% | 14.386 | 23.576 | 81.586 | 30.275 | 33.870 |
| hex: silesia/reymont | 524290 | 27981.9 ± 1.1% | 1955.7 ± 3.8% | 1190.5 ± 0.8% | 373.6 ± 1.3% | 948.3 ± 7.1% | 830.2 ± 1.2% | 14.308 | 23.504 | 74.903 | 29.507 | 33.706 |
| hex: silesia/samba | 524290 | 31667.4 ± 2.0% | 1897.0 ± 4.3% | 1190.4 ± 1.9% | 275.2 ± 0.6% | 939.5 ± 4.5% | 816.9 ± 3.7% | 16.693 | 26.603 | 115.082 | 33.705 | 38.764 |
| hex: silesia/sao | 524290 | 28306.7 ± 1.1% | 1933.8 ± 8.5% | 1192.9 ± 0.7% | 211.9 ± 0.6% | 914.6 ± 7.5% | 829.6 ± 2.4% | 14.638 | 23.730 | 133.604 | 30.951 | 34.123 |
| hex: silesia/webster | 524290 | 29305.4 ± 1.2% | 1857.8 ± 6.9% | 1189.7 ± 9.0% | 327.3 ± 0.7% | 919.5 ± 3.5% | 829.9 ± 2.0% | 15.774 | 24.633 | 89.537 | 31.872 | 35.313 |
| hex: silesia/x-ray | 524290 | 27731.4 ± 1.4% | 1928.7 ± 4.2% | 1191.1 ± 0.8% | 323.1 ± 0.9% | 917.9 ± 3.0% | 830.1 ± 1.7% | 14.378 | 23.283 | 85.841 | 30.211 | 33.408 |
| hex: silesia/xml | 524290 | 31640.1 ± 2.3% | 1906.3 ± 3.0% | 1195.4 ± 0.7% | 535.2 ± 0.9% | 952.0 ± 2.6% | 831.7 ± 3.7% | 16.598 | 26.469 | 59.118 | 33.237 | 38.041 |
| hex: canterbury/alice29.txt | 304180 | 28115.9 ± 1.7% | 1919.8 ± 6.1% | 1201.4 ± 1.0% | 357.4 ± 1.1% | 948.0 ± 3.4% | 840.8 ± 1.0% | 14.645 | 23.403 | 78.660 | 29.659 | 33.438 |
| hex: canterbury/asyoulik.txt | 250360 | 27728.7 ± 1.3% | 1832.2 ± 8.6% | 1217.7 ± 1.1% | 347.6 ± 0.6% | 954.7 ± 7.8% | 841.9 ± 1.3% | 15.134 | 22.771 | 79.775 | 29.045 | 32.934 |
| hex: canterbury/cp.html | 49208 | 27205.5 ± 0.9% | 1812.6 ± 2.7% | 1201.9 ± 0.6% | 357.3 ± 0.9% | 1006.4 ± 5.0% | 837.0 ± 5.7% | 15.009 | 22.636 | 76.144 | 27.033 | 32.502 |
| hex: canterbury/fields.c | 22302 | 31379.0 ± 1.9% | 1935.0 ± 4.1% | 1198.8 ± 0.7% | 551.3 ± 1.1% | 1000.2 ± 13.6% | 826.7 ± 1.9% | 16.217 | 26.175 | 56.918 | 31.373 | 37.955 |
| hex: canterbury/grammar.lsp | 7444 | 26828.4 ± 0.8% | 1866.9 ± 16.2% | 1211.9 ± 1.3% | 624.8 ± 0.9% | 938.0 ± 9.6% | 843.1 ± 5.8% | 14.371 | 22.138 | 42.937 | 28.600 | 31.822 |
| hex: canterbury/kennedy.xls | 524290 | 28100.1 ± 1.1% | 1889.2 ± 5.9% | 1186.9 ± 1.0% | 593.0 ± 0.7% | 890.4 ± 2.7% | 826.2 ± 0.9% | 14.874 | 23.674 | 47.386 | 31.560 | 34.012 |
| hex: canterbury/lcet10.txt | 524290 | 31838.6 ± 1.6% | 1913.1 ± 5.3% | 1186.9 ± 0.8% | 357.2 ± 0.8% | 915.3 ± 4.8% | 834.1 ± 1.1% | 16.642 | 26.826 | 89.141 | 34.786 | 38.173 |
| hex: canterbury/plrabn12.txt | 524290 | 27854.6 ± 1.0% | 1909.4 ± 5.2% | 1187.6 ± 7.3% | 345.2 ± 0.9% | 916.9 ± 3.9% | 834.6 ± 1.5% | 14.589 | 23.455 | 80.680 | 30.380 | 33.374 |
| hex: canterbury/ptt5 | 524290 | 27941.3 ± 1.3% | 1920.6 ± 10.3% | 1188.7 ± 2.0% | 459.9 ± 0.4% | 909.3 ± 4.0% | 831.6 ± 3.2% | 14.548 | 23.505 | 60.755 | 30.729 | 33.598 |
| hex: canterbury/sum | 76482 | 27775.7 ± 1.0% | 1853.5 ± 5.7% | 1185.8 ± 0.6% | 437.6 ± 2.8% | 1013.5 ± 5.1% | 836.4 ± 2.0% | 14.986 | 23.424 | 63.478 | 27.407 | 33.210 |
| hex: canterbury/xargs.1 | 8456 | 29970.2 ± 0.7% | 1942.3 ± 8.8% | 1214.0 ± 8.2% | 629.9 ± 4.7% | 1000.5 ± 13.0% | 843.1 ± 2.2% | 15.430 | 24.688 | 47.579 | 29.956 | 35.547 |
| hex: canterbury-large/E.coli | 524290 | 27787.8 ± 1.8% | 1942.0 ± 3.8% | 1185.7 ± 0.7% | 607.9 ± 0.5% | 904.0 ± 2.0% | 825.7 ± 2.1% | 14.309 | 23.435 | 45.713 | 30.738 | 33.653 |
| hex: canterbury-large/bible.txt | 524290 | 31578.8 ± 0.4% | 1844.1 ± 6.4% | 1197.3 ± 1.7% | 367.9 ± 0.4% | 899.4 ± 1.4% | 832.9 ± 1.6% | 17.124 | 26.374 | 85.836 | 35.112 | 37.916 |
| hex: canterbury-large/world192.txt | 524290 | 28154.9 ± 0.7% | 1903.6 ± 4.3% | 1191.1 ± 1.2% | 347.8 ± 1.0% | 915.2 ± 4.3% | 824.0 ± 1.1% | 14.790 | 23.637 | 80.945 | 30.763 | 34.169 |
| hex: http/html-1kx1024 | 2099200 | 18457.4 ± 1.3% | 1847.4 ± 0.4% | 1114.4 ± 0.3% | 375.0 ± 0.4% | 884.8 ± 4.9% | 807.7 ± 2.1% | 9.991 | 16.562 | 49.221 | 20.861 | 22.853 |
| hex: http/html-16kx64 | 2097280 | 18698.8 ± 0.6% | 1820.0 ± 1.0% | 1134.1 ± 0.7% | 375.1 ± 0.7% | 910.5 ± 15.0% | 828.9 ± 2.4% | 10.274 | 16.487 | 49.855 | 20.538 | 22.560 |
| hex: http/html-1m | 524290 | 27348.1 ± 1.2% | 1952.6 ± 4.4% | 1193.6 ± 1.4% | 362.0 ± 3.0% | 898.7 ± 6.7% | 828.8 ± 2.3% | 14.006 | 22.912 | 75.539 | 30.429 | 32.999 |
| hex: http/json-1kx1024 | 2099200 | 18305.7 ± 0.9% | 1841.0 ± 0.9% | 1111.2 ± 0.8% | 542.9 ± 1.4% | 882.2 ± 4.4% | 809.9 ± 1.8% | 9.943 | 16.474 | 33.718 | 20.750 | 22.601 |
| hex: http/json-16kx64 | 2097280 | 19398.1 ± 0.5% | 1802.5 ± 2.6% | 1132.9 ± 1.0% | 549.2 ± 0.4% | 929.7 ± 7.3% | 833.2 ± 1.5% | 10.761 | 17.123 | 35.324 | 20.864 | 23.281 |
| hex: http/json-1m | 524290 | 28011.6 ± 0.7% | 1920.1 ± 0.7% | 1187.8 ± 2.2% | 574.2 ± 1.9% | 875.3 ± 2.5% | 827.2 ± 2.2% | 14.588 | 23.583 | 48.783 | 32.002 | 33.863 |
| hex: http/js-1kx1024 | 2099200 | 18197.8 ± 1.4% | 1838.8 ± 1.2% | 1115.2 ± 0.5% | 372.1 ± 0.4% | 896.5 ± 3.4% | 807.9 ± 2.7% | 9.896 | 16.318 | 48.910 | 20.299 | 22.524 |
| hex: http/js-16kx64 | 2097280 | 19378.8 ± 1.5% | 1812.1 ± 2.4% | 1132.6 ± 1.1% | 372.0 ± 4.3% | 916.8 ± 8.3% | 827.3 ± 5.7% | 10.694 | 17.110 | 52.087 | 21.136 | 23.425 |
| hex: http/js-1m | 524290 | 28069.1 ± 2.3% | 1955.2 ± 6.3% | 1186.9 ± 0.8% | 374.8 ± 0.9% | 891.6 ± 4.9% | 827.4 ± 5.7% | 14.356 | 23.650 | 74.896 | 31.483 | 33.924 |
| hex: http/css-1kx1024 | 2099200 | 17907.5 ± 1.7% | 1837.8 ± 0.6% | 1114.4 ± 0.7% | 418.7 ± 0.8% | 877.8 ± 4.2% | 818.1 ± 2.6% | 9.744 | 16.069 | 42.773 | 20.401 | 21.888 |
| hex: http/css-16kx64 | 2097280 | 19217.5 ± 0.7% | 1798.6 ± 1.0% | 1133.8 ± 0.6% | 419.7 ± 0.7% | 946.1 ± 5.7% | 827.9 ± 6.4% | 10.685 | 16.950 | 45.784 | 20.312 | 23.213 |
| hex: http/css-1m | 524290 | 27943.9 ± 1.2% | 1863.0 ± 5.8% | 1184.9 ± 0.6% | 402.3 ± 0.2% | 920.1 ± 6.2% | 825.6 ± 1.3% | 14.999 | 23.584 | 69.465 | 30.372 | 33.845 |
| hex: shuffled/dickens-1m | 524290 | 27895.2 ± 0.3% | 1937.8 ± 3.6% | 1188.9 ± 0.2% | 351.1 ± 0.5% | 924.4 ± 1.7% | 826.5 ± 0.9% | 14.395 | 23.463 | 79.442 | 30.175 | 33.750 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding: stdx runs at 0.892 of simdjson.
- qlog records, JSON text sequence, decoding: stdx runs at 0.865 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.755 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.818 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.911 of yyjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next_items: stdx runs at 0.857 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next_items: stdx runs at 0.934 of simdjson.
