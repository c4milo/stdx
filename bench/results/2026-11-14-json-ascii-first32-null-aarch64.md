# bench-json

| Field | Value |
|---|---|
| Commit | 45fb15d |
| Runner label | ubuntu-24.04-arm |
| Image version | 20261111.182.1 |
| CPU model | Neoverse-N2 |
| Virtual CPUs | 4 |
| Kernel | 7.0.0-1017-azure |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/43616695085 |
| Date | 2026-11-14 |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1. The `TextReader.next_items` column is that helper's queued tokens a slice a call (decision 79), over many tokens a call.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | TextReader.next_items | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1131.0 ± 0.3% | 0.522 | 0.962 | 0.993 | 0.995 | 0.456 | 0.999 | 1.003 | 0.382 | 0.829 | 0.896 | 0.101 |
| qlog records, JSON text sequence | 1467503 | 843.7 ± 1.1% | 0.823 | 1.005 | 1.001 | 0.998 | 0.448 | 1.000 | 1.029 | 0.398 | 0.921 | 0.994 | 0.126 |
| string: silesia/dickens | 172528 | 5052.4 ± 0.5% | 0.033 | 0.782 | 1.001 | 1.003 | 0.197 | 1.016 | 1.005 | 0.196 | 1.001 | 1.001 | 0.032 |
| string: silesia/nci | 1075110 | 4294.8 ± 0.5% | 0.039 | 0.802 | 1.002 | 1.002 | 0.277 | 1.004 | 0.998 | 0.280 | 1.002 | 1.003 | 0.038 |
| string: silesia/reymont | 1075159 | 2932.8 ± 1.8% | 0.057 | 0.818 | 0.998 | 1.006 | 0.359 | 1.003 | 1.005 | 0.360 | 1.011 | 1.013 | 0.056 |
| string: silesia/samba | 97582 | 3487.5 ± 0.7% | 0.041 | 0.864 | 1.006 | 1.007 | 0.069 | 0.780 | 1.013 | 0.067 | 1.004 | 1.007 | 0.041 |
| string: silesia/webster | 1098490 | 3646.8 ± 1.0% | 0.044 | 0.848 | 1.005 | 1.007 | 0.204 | 1.017 | 1.014 | 0.203 | 1.006 | 1.006 | 0.044 |
| string: silesia/xml | 1090118 | 4768.7 ± 0.7% | 0.035 | 0.806 | 1.007 | 1.010 | 0.221 | 0.982 | 1.007 | 0.219 | 1.008 | 1.009 | 0.034 |
| string: canterbury/alice29.txt | 159425 | 4311.3 ± 1.5% | 0.038 | 0.750 | 1.001 | 1.006 | 0.172 | 1.027 | 1.017 | 0.171 | 1.007 | 1.009 | 0.037 |
| string: canterbury/asyoulik.txt | 132198 | 3459.4 ± 0.5% | 0.046 | 0.747 | 1.006 | 1.011 | 0.175 | 1.008 | 0.973 | 0.175 | 1.015 | 1.016 | 0.045 |
| string: canterbury/lcet10.txt | 441884 | 5074.1 ± 0.2% | 0.033 | 0.820 | 1.007 | 1.009 | 0.197 | 1.020 | 1.015 | 0.197 | 1.005 | 1.005 | 0.032 |
| string: canterbury/plrabn12.txt | 503330 | 4125.8 ± 0.7% | 0.039 | 0.822 | 1.005 | 1.006 | 0.197 | 1.006 | 0.998 | 0.198 | 1.005 | 1.005 | 0.039 |
| string: canterbury-large/E.coli | 1048578 | 19020.4 ± 0.7% | 0.077 | 1.006 | 0.999 | 1.001 | 0.480 | 1.009 | 1.005 | 0.481 | 0.626 | 0.626 | 0.009 |
| string: canterbury-large/bible.txt | 1055886 | 6677.5 ± 1.6% | 0.026 | 0.802 | 1.005 | 1.011 | 0.432 | 1.031 | 1.040 | 0.432 | 1.030 | 1.033 | 0.025 |
| string: canterbury-large/world192.txt | 1103121 | 3391.9 ± 0.1% | 0.048 | 0.842 | 1.001 | 1.000 | 0.198 | 1.012 | 1.003 | 0.197 | 1.002 | 1.001 | 0.047 |
| string: http/html-1m | 1058582 | 6049.8 ± 0.9% | 0.028 | 0.783 | 0.998 | 1.007 | 0.389 | 1.042 | 1.053 | 0.389 | 1.031 | 1.037 | 0.028 |
| string: http/json-1m | 1190272 | 2552.7 ± 0.4% | 0.055 | 0.946 | 1.001 | 1.002 | 0.109 | 1.000 | 0.470 | 0.110 | 1.000 | 1.000 | 0.055 |
| string: http/js-1m | 1144362 | 2281.0 ± 0.6% | 0.066 | 0.890 | 1.000 | 1.001 | 0.175 | 1.054 | 1.044 | 0.175 | 0.999 | 0.999 | 0.066 |
| string: http/css-1m | 1097820 | 2632.9 ± 0.2% | 0.061 | 0.778 | 1.006 | 1.008 | 0.238 | 1.011 | 1.014 | 0.240 | 1.007 | 1.008 | 0.060 |
| string: dickens as Cyrillic and CJK | 1883069 | 3058.0 ± 0.8% | 0.044 | 0.125 | 1.005 | 1.007 | 0.337 | 1.002 | 1.010 | 0.338 | 1.004 | 1.005 | 0.044 |
| string: dickens as Cyrillic and CJK, as \u escapes | 5075485 | 1328.4 ± 1.4% | 0.085 | 1.004 | 1.001 | 1.001 | 0.078 | 0.637 | 1.005 | 0.074 | 1.002 | 1.002 | 0.085 |
| hex: silesia/dickens | 524290 | 18231.4 ± 2.3% | 0.082 | 1.009 | 0.999 | 0.994 | 0.537 | 1.005 | 1.001 | 0.539 | 0.659 | 0.659 | 0.010 |
| hex: silesia/mozilla | 524290 | 18174.4 ± 1.1% | 0.082 | 1.003 | 1.001 | 0.987 | 0.528 | 0.993 | 0.985 | 0.530 | 0.661 | 0.661 | 0.010 |
| hex: silesia/mr | 524290 | 17836.0 ± 1.3% | 0.083 | 1.010 | 1.002 | 1.004 | 0.534 | 1.005 | 1.003 | 0.534 | 0.673 | 0.673 | 0.010 |
| hex: silesia/nci | 524290 | 18230.9 ± 2.4% | 0.081 | 1.011 | 0.999 | 0.987 | 0.525 | 0.998 | 0.985 | 0.525 | 0.657 | 0.658 | 0.009 |
| hex: silesia/ooffice | 524290 | 18588.6 ± 1.1% | 0.080 | 1.000 | 0.991 | 0.982 | 0.519 | 0.986 | 0.986 | 0.519 | 0.643 | 0.641 | 0.009 |
| hex: silesia/osdb | 524290 | 17972.4 ± 0.8% | 0.082 | 1.000 | 1.002 | 1.002 | 0.517 | 0.998 | 1.001 | 0.520 | 0.665 | 0.664 | 0.010 |
| hex: silesia/reymont | 524290 | 18157.8 ± 5.7% | 0.082 | 1.006 | 0.997 | 0.998 | 0.520 | 0.995 | 0.993 | 0.519 | 0.656 | 0.661 | 0.010 |
| hex: silesia/samba | 524290 | 17784.7 ± 0.5% | 0.083 | 1.002 | 0.994 | 0.994 | 0.533 | 0.998 | 1.000 | 0.532 | 0.675 | 0.675 | 0.010 |
| hex: silesia/sao | 524290 | 18164.2 ± 0.6% | 0.082 | 1.008 | 1.004 | 1.000 | 0.538 | 1.003 | 1.003 | 0.538 | 0.662 | 0.660 | 0.010 |
| hex: silesia/webster | 524290 | 18450.4 ± 0.4% | 0.080 | 1.006 | 0.997 | 0.986 | 0.520 | 0.996 | 0.991 | 0.520 | 0.650 | 0.651 | 0.009 |
| hex: silesia/x-ray | 524290 | 18030.3 ± 1.7% | 0.082 | 1.006 | 1.000 | 1.001 | 0.524 | 0.997 | 0.996 | 0.524 | 0.665 | 0.664 | 0.010 |
| hex: silesia/xml | 524290 | 18414.3 ± 1.0% | 0.081 | 1.001 | 0.984 | 0.980 | 0.512 | 0.995 | 0.991 | 0.515 | 0.651 | 0.651 | 0.009 |
| hex: canterbury/alice29.txt | 304180 | 18918.7 ± 0.5% | 0.079 | 1.006 | 0.999 | 0.999 | 0.517 | 0.991 | 0.998 | 0.520 | 0.635 | 0.635 | 0.009 |
| hex: canterbury/asyoulik.txt | 250360 | 19501.6 ± 0.2% | 0.077 | 1.003 | 1.003 | 1.002 | 0.513 | 1.002 | 1.002 | 0.514 | 0.615 | 0.616 | 0.009 |
| hex: canterbury/cp.html | 49208 | 19290.7 ± 0.5% | 0.081 | 1.002 | 1.002 | 1.001 | 0.540 | 1.001 | 1.002 | 0.541 | 0.618 | 0.618 | 0.009 |
| hex: canterbury/fields.c | 22302 | 18866.2 ± 0.2% | 0.085 | 1.005 | 1.006 | 1.006 | 0.535 | 1.005 | 1.006 | 0.540 | 0.625 | 0.625 | 0.009 |
| hex: canterbury/grammar.lsp | 7444 | 17477.7 ± 1.5% | 0.089 | 1.007 | 1.008 | 1.008 | 0.527 | 1.007 | 1.007 | 0.545 | 0.644 | 0.648 | 0.010 |
| hex: canterbury/kennedy.xls | 524290 | 18283.2 ± 1.9% | 0.081 | 1.001 | 0.988 | 0.987 | 0.516 | 0.987 | 0.988 | 0.516 | 0.655 | 0.655 | 0.009 |
| hex: canterbury/lcet10.txt | 524290 | 17928.9 ± 1.5% | 0.083 | 1.014 | 1.010 | 1.012 | 0.535 | 1.016 | 1.016 | 0.539 | 0.670 | 0.669 | 0.010 |
| hex: canterbury/plrabn12.txt | 524290 | 17981.3 ± 0.7% | 0.082 | 1.003 | 0.997 | 0.996 | 0.522 | 1.003 | 0.995 | 0.525 | 0.667 | 0.667 | 0.010 |
| hex: canterbury/ptt5 | 524290 | 17914.3 ± 0.5% | 0.083 | 1.003 | 0.998 | 1.000 | 0.545 | 1.009 | 1.005 | 0.545 | 0.670 | 0.670 | 0.010 |
| hex: canterbury/sum | 76482 | 19297.9 ± 0.5% | 0.078 | 1.002 | 1.002 | 1.002 | 0.518 | 1.002 | 1.002 | 0.520 | 0.617 | 0.617 | 0.009 |
| hex: canterbury/xargs.1 | 8456 | 17834.5 ± 0.8% | 0.087 | 1.002 | 1.002 | 1.003 | 0.526 | 1.001 | 1.001 | 0.542 | 0.637 | 0.637 | 0.010 |
| hex: canterbury-large/E.coli | 524290 | 18086.9 ± 1.1% | 0.082 | 1.006 | 1.001 | 1.000 | 0.530 | 1.002 | 1.002 | 0.532 | 0.664 | 0.664 | 0.010 |
| hex: canterbury-large/bible.txt | 524290 | 18226.9 ± 1.1% | 0.081 | 1.005 | 1.005 | 1.002 | 0.516 | 1.006 | 0.995 | 0.516 | 0.657 | 0.659 | 0.009 |
| hex: canterbury-large/world192.txt | 524290 | 17696.9 ± 0.7% | 0.084 | 1.009 | 1.009 | 1.009 | 0.548 | 1.007 | 1.010 | 0.549 | 0.677 | 0.677 | 0.010 |
| hex: http/html-1kx1024 | 2099200 | 8860.3 ± 13.5% | 0.158 | 1.304 | 1.291 | 1.292 | 0.733 | 1.308 | 0.984 | 0.804 | 0.977 | 0.982 | 0.019 |
| hex: http/html-16kx64 | 2097280 | 17612.1 ± 1.4% | 0.085 | 1.020 | 1.017 | 1.018 | 0.580 | 1.018 | 0.980 | 0.585 | 0.667 | 0.667 | 0.010 |
| hex: http/html-1m | 524290 | 18132.3 ± 1.6% | 0.082 | 1.005 | 0.998 | 0.998 | 0.525 | 0.997 | 1.001 | 0.526 | 0.662 | 0.661 | 0.010 |
| hex: http/json-1kx1024 | 2099200 | 8881.7 ± 17.8% | 0.161 | 1.309 | 1.290 | 1.291 | 0.728 | 1.301 | 0.979 | 0.803 | 0.972 | 0.981 | 0.019 |
| hex: http/json-16kx64 | 2097280 | 17669.2 ± 2.2% | 0.085 | 1.019 | 1.016 | 1.015 | 0.579 | 1.016 | 0.977 | 0.586 | 0.665 | 0.665 | 0.010 |
| hex: http/json-1m | 524290 | 18474.6 ± 1.7% | 0.081 | 1.012 | 0.996 | 0.993 | 0.523 | 1.010 | 1.008 | 0.524 | 0.649 | 0.649 | 0.009 |
| hex: http/js-1kx1024 | 2099200 | 8867.4 ± 17.2% | 0.161 | 1.306 | 1.306 | 1.304 | 0.735 | 1.319 | 0.988 | 0.806 | 0.972 | 0.985 | 0.019 |
| hex: http/js-16kx64 | 2097280 | 17516.7 ± 0.9% | 0.086 | 1.025 | 1.023 | 1.023 | 0.582 | 1.025 | 0.987 | 0.589 | 0.671 | 0.671 | 0.010 |
| hex: http/js-1m | 524290 | 17913.1 ± 1.6% | 0.083 | 1.010 | 1.002 | 1.000 | 0.536 | 1.009 | 1.001 | 0.536 | 0.669 | 0.669 | 0.010 |
| hex: http/css-1kx1024 | 2099200 | 8979.6 ± 15.1% | 0.159 | 1.301 | 1.288 | 1.285 | 0.723 | 1.289 | 0.984 | 0.791 | 0.962 | 0.967 | 0.019 |
| hex: http/css-16kx64 | 2097280 | 17550.5 ± 0.7% | 0.085 | 1.029 | 1.024 | 1.024 | 0.581 | 1.025 | 0.986 | 0.582 | 0.669 | 0.669 | 0.010 |
| hex: http/css-1m | 524290 | 18237.2 ± 0.6% | 0.081 | 1.021 | 1.003 | 1.004 | 0.523 | 1.006 | 1.000 | 0.521 | 0.659 | 0.659 | 0.010 |
| hex: shuffled/dickens-1m | 524290 | 17571.5 ± 0.4% | 0.084 | 1.004 | 1.011 | 1.011 | 0.535 | 1.001 | 0.999 | 0.531 | 0.682 | 0.683 | 0.010 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1478.2 ± 0.6% | 0.446 | 1.002 | 0.970 | 1.004 | 1.009 | 0.268 | 1.000 | 0.550 | 0.916 | 0.089 | 1.030 |
| qlog records, JSON text sequence | 1467503 | 1269.9 ± 1.8% | 0.690 | 0.978 | 1.011 | 1.012 | 1.013 | 0.265 | 1.003 | 0.503 | 0.829 | 0.105 | 1.018 |
| string: silesia/dickens | 172528 | 6848.3 ± 0.3% | 0.025 | 1.002 | 1.006 | 1.002 | 1.001 | 0.166 | 0.721 | 1.004 | 1.004 | 0.025 | 1.040 |
| string: silesia/nci | 1075110 | 7305.5 ± 0.5% | 0.024 | 1.000 | 1.000 | 1.000 | 1.001 | 0.210 | 0.565 | 1.002 | 1.002 | 0.024 | 1.011 |
| string: silesia/reymont | 1075159 | 3304.2 ± 1.3% | 0.053 | 1.004 | 1.004 | 1.007 | 1.007 | 0.392 | 0.881 | 1.009 | 1.011 | 0.052 | 1.059 |
| string: silesia/samba | 97582 | 4194.8 ± 1.0% | 0.053 | 1.000 | 1.001 | 1.003 | 1.006 | 0.124 | 0.942 | 1.003 | 1.004 | 0.053 | 1.092 |
| string: silesia/webster | 1098490 | 4050.4 ± 0.5% | 0.042 | 1.008 | 1.006 | 1.008 | 1.009 | 0.211 | 0.889 | 0.999 | 1.006 | 0.043 | 1.008 |
| string: silesia/xml | 1090118 | 6119.1 ± 0.6% | 0.029 | 1.005 | 0.998 | 1.006 | 1.004 | 0.252 | 0.773 | 1.001 | 1.005 | 0.029 | 1.018 |
| string: canterbury/alice29.txt | 159425 | 6413.1 ± 1.0% | 0.027 | 1.011 | 1.013 | 1.013 | 1.015 | 0.131 | 0.653 | 1.003 | 1.006 | 0.027 | 1.055 |
| string: canterbury/asyoulik.txt | 132198 | 5593.2 ± 1.2% | 0.030 | 1.027 | 1.033 | 1.033 | 1.034 | 0.128 | 0.597 | 1.000 | 1.011 | 0.030 | 1.052 |
| string: canterbury/lcet10.txt | 441884 | 6230.7 ± 0.6% | 0.028 | 1.008 | 1.008 | 1.008 | 1.008 | 0.184 | 0.802 | 1.004 | 1.003 | 0.028 | 1.001 |
| string: canterbury/plrabn12.txt | 503330 | 5708.1 ± 0.6% | 0.031 | 1.002 | 1.002 | 1.003 | 1.003 | 0.167 | 0.697 | 1.003 | 1.003 | 0.030 | 1.007 |
| string: canterbury-large/E.coli | 1048578 | 19078.3 ± 1.0% | 0.078 | 1.004 | 1.001 | 1.004 | 1.002 | 0.481 | 1.001 | 1.002 | 1.007 | 0.009 | 1.003 |
| string: canterbury-large/bible.txt | 1055886 | 6788.0 ± 0.5% | 0.026 | 1.001 | 0.999 | 1.001 | 1.000 | 0.495 | 0.974 | 1.002 | 1.002 | 0.026 | 0.999 |
| string: canterbury-large/world192.txt | 1103121 | 4008.8 ± 1.1% | 0.043 | 1.014 | 1.015 | 1.018 | 1.019 | 0.192 | 0.832 | 1.004 | 1.011 | 0.042 | 1.004 |
| string: http/html-1m | 1058582 | 6742.7 ± 0.5% | 0.026 | 1.006 | 0.922 | 1.002 | 1.005 | 0.402 | 0.888 | 0.999 | 1.001 | 0.026 | 1.011 |
| string: http/json-1m | 1190272 | 3159.6 ± 0.5% | 0.051 | 1.001 | 0.968 | 1.002 | 1.001 | 0.132 | 0.371 | 1.001 | 1.003 | 0.050 | 1.043 |
| string: http/js-1m | 1144362 | 2759.5 ± 0.5% | 0.061 | 1.001 | 1.008 | 1.000 | 1.006 | 0.164 | 0.838 | 1.003 | 1.005 | 0.060 | 1.015 |
| string: http/css-1m | 1097820 | 3986.5 ± 1.0% | 0.043 | 1.004 | 1.005 | 1.008 | 1.008 | 0.206 | 0.644 | 0.999 | 1.003 | 0.042 | 1.009 |
| string: dickens as Cyrillic and CJK | 1883069 | 3062.6 ± 0.4% | 0.048 | 1.002 | 0.124 | 1.001 | 1.003 | 0.320 | 1.002 | 1.000 | 1.004 | 0.048 | 1.003 |
| hex: silesia/dickens | 524290 | 15594.2 ± 0.1% | 1.002 | 0.178 | 1.002 | 1.000 | 1.000 | 1.001 | 1.002 | 1.000 | 1.000 | 0.178 | 1.001 |
| hex: silesia/mozilla | 524290 | 15586.3 ± 0.2% | 1.002 | 0.179 | 1.002 | 1.000 | 1.002 | 1.002 | 1.003 | 1.003 | 1.004 | 0.178 | 1.003 |
| hex: silesia/mr | 524290 | 15649.2 ± 0.2% | 1.001 | 0.178 | 1.000 | 1.001 | 1.001 | 0.999 | 1.000 | 1.000 | 1.000 | 0.178 | 1.000 |
| hex: silesia/nci | 524290 | 15634.1 ± 0.4% | 1.002 | 0.178 | 1.001 | 1.002 | 1.001 | 1.000 | 1.002 | 1.001 | 1.002 | 0.178 | 1.002 |
| hex: silesia/ooffice | 524290 | 15584.6 ± 0.1% | 1.003 | 0.179 | 1.002 | 1.000 | 1.001 | 1.002 | 1.003 | 1.000 | 0.999 | 0.178 | 1.001 |
| hex: silesia/osdb | 524290 | 15635.0 ± 0.2% | 1.001 | 0.178 | 0.998 | 0.998 | 0.998 | 0.998 | 0.999 | 0.994 | 0.995 | 0.178 | 0.998 |
| hex: silesia/reymont | 524290 | 15632.1 ± 0.5% | 1.000 | 0.177 | 0.999 | 1.002 | 1.001 | 0.999 | 1.001 | 0.999 | 0.999 | 0.177 | 1.002 |
| hex: silesia/samba | 524290 | 15604.5 ± 0.2% | 1.002 | 0.178 | 1.002 | 1.000 | 1.001 | 1.001 | 1.000 | 1.003 | 1.004 | 0.178 | 1.000 |
| hex: silesia/sao | 524290 | 15609.2 ± 0.2% | 1.001 | 0.178 | 1.000 | 1.000 | 1.000 | 0.999 | 1.001 | 1.001 | 1.000 | 0.178 | 1.000 |
| hex: silesia/webster | 524290 | 15632.7 ± 0.1% | 1.001 | 0.178 | 1.001 | 1.001 | 1.001 | 1.001 | 1.000 | 1.002 | 1.002 | 0.177 | 0.999 |
| hex: silesia/x-ray | 524290 | 15616.1 ± 0.5% | 1.000 | 0.178 | 0.999 | 0.999 | 0.999 | 0.994 | 0.995 | 0.994 | 0.994 | 0.178 | 0.992 |
| hex: silesia/xml | 524290 | 15618.2 ± 0.2% | 1.002 | 0.178 | 1.000 | 1.001 | 0.999 | 0.998 | 1.000 | 1.001 | 0.999 | 0.178 | 1.000 |
| hex: canterbury/alice29.txt | 304180 | 15684.2 ± 0.1% | 1.001 | 0.178 | 1.001 | 1.001 | 1.001 | 1.001 | 1.001 | 1.001 | 1.001 | 0.178 | 1.001 |
| hex: canterbury/asyoulik.txt | 250360 | 15702.2 ± 0.1% | 1.001 | 0.178 | 1.001 | 1.001 | 1.001 | 0.991 | 1.001 | 1.001 | 1.001 | 0.177 | 1.001 |
| hex: canterbury/cp.html | 49208 | 15621.1 ± 0.1% | 1.001 | 0.179 | 1.000 | 1.000 | 1.000 | 0.998 | 1.001 | 1.001 | 1.003 | 0.178 | 1.001 |
| hex: canterbury/fields.c | 22302 | 15442.5 ± 0.1% | 1.002 | 0.181 | 1.000 | 1.000 | 1.000 | 0.994 | 1.000 | 1.001 | 1.005 | 0.180 | 1.001 |
| hex: canterbury/grammar.lsp | 7444 | 14931.1 ± 0.2% | 1.003 | 0.186 | 1.001 | 1.001 | 1.001 | 0.983 | 1.001 | 1.004 | 1.015 | 0.184 | 1.003 |
| hex: canterbury/kennedy.xls | 524290 | 15610.2 ± 0.3% | 1.002 | 0.178 | 1.000 | 1.000 | 1.000 | 1.000 | 1.000 | 0.999 | 1.001 | 0.179 | 0.999 |
| hex: canterbury/lcet10.txt | 524290 | 15623.3 ± 0.1% | 0.999 | 0.178 | 1.000 | 0.998 | 0.999 | 0.997 | 0.998 | 0.998 | 0.998 | 0.178 | 0.996 |
| hex: canterbury/plrabn12.txt | 524290 | 15634.8 ± 0.3% | 0.998 | 0.177 | 1.000 | 1.000 | 1.000 | 1.000 | 1.000 | 1.001 | 0.999 | 0.177 | 1.000 |
| hex: canterbury/ptt5 | 524290 | 15627.2 ± 0.4% | 1.001 | 0.178 | 0.999 | 1.000 | 0.999 | 1.000 | 1.000 | 1.000 | 0.999 | 0.178 | 1.001 |
| hex: canterbury/sum | 76482 | 15644.1 ± 0.0% | 1.001 | 0.179 | 1.000 | 1.000 | 1.000 | 0.998 | 1.001 | 1.001 | 1.002 | 0.178 | 1.001 |
| hex: canterbury/xargs.1 | 8456 | 15009.3 ± 0.1% | 1.001 | 0.185 | 1.000 | 1.000 | 1.000 | 0.985 | 1.000 | 1.002 | 1.013 | 0.183 | 1.002 |
| hex: canterbury-large/E.coli | 524290 | 15593.8 ± 0.3% | 0.999 | 0.179 | 1.000 | 1.001 | 1.001 | 0.999 | 0.999 | 1.000 | 1.001 | 0.179 | 0.999 |
| hex: canterbury-large/bible.txt | 524290 | 15618.6 ± 0.3% | 1.002 | 0.178 | 0.999 | 0.999 | 0.996 | 0.995 | 1.000 | 0.998 | 0.997 | 0.177 | 0.997 |
| hex: canterbury-large/world192.txt | 524290 | 15641.4 ± 0.4% | 1.001 | 0.178 | 1.001 | 1.001 | 1.001 | 1.000 | 1.000 | 1.000 | 1.002 | 0.177 | 1.000 |
| hex: http/html-1kx1024 | 2099200 | 13632.6 ± 0.5% | 1.002 | 0.196 | 0.996 | 1.005 | 1.003 | 0.941 | 1.002 | 1.005 | 1.037 | 0.188 | 1.010 |
| hex: http/html-16kx64 | 2097280 | 15271.5 ± 0.3% | 1.000 | 0.180 | 0.996 | 0.998 | 0.997 | 0.994 | 0.998 | 1.004 | 1.002 | 0.179 | 1.003 |
| hex: http/html-1m | 524290 | 15552.2 ± 0.3% | 1.001 | 0.178 | 1.002 | 1.001 | 1.003 | 1.001 | 1.001 | 1.001 | 1.004 | 0.178 | 1.002 |
| hex: http/json-1kx1024 | 2099200 | 13713.7 ± 0.4% | 0.998 | 0.195 | 1.001 | 1.003 | 1.001 | 0.933 | 0.996 | 1.001 | 1.030 | 0.187 | 1.012 |
| hex: http/json-16kx64 | 2097280 | 15245.7 ± 0.3% | 1.002 | 0.181 | 1.000 | 1.000 | 1.000 | 0.989 | 0.996 | 1.003 | 1.006 | 0.180 | 1.003 |
| hex: http/json-1m | 524290 | 15656.8 ± 0.3% | 0.999 | 0.177 | 1.000 | 1.000 | 0.998 | 0.998 | 1.001 | 0.995 | 0.993 | 0.178 | 0.999 |
| hex: http/js-1kx1024 | 2099200 | 13734.7 ± 0.4% | 1.003 | 0.195 | 0.992 | 1.000 | 1.002 | 0.938 | 0.996 | 1.002 | 1.029 | 0.187 | 1.012 |
| hex: http/js-16kx64 | 2097280 | 15190.2 ± 0.3% | 1.003 | 0.181 | 1.001 | 1.003 | 1.004 | 0.991 | 0.999 | 1.006 | 1.012 | 0.181 | 1.006 |
| hex: http/js-1m | 524290 | 15680.9 ± 0.3% | 1.000 | 0.177 | 1.001 | 1.001 | 1.000 | 1.000 | 1.001 | 1.000 | 0.998 | 0.177 | 1.001 |
| hex: http/css-1kx1024 | 2099200 | 13635.5 ± 0.5% | 1.008 | 0.196 | 1.000 | 1.001 | 1.001 | 0.939 | 1.002 | 1.008 | 1.035 | 0.188 | 1.012 |
| hex: http/css-16kx64 | 2097280 | 15280.1 ± 1.0% | 0.998 | 0.180 | 0.995 | 1.000 | 0.999 | 0.985 | 0.993 | 0.999 | 1.002 | 0.180 | 1.000 |
| hex: http/css-1m | 524290 | 15550.3 ± 0.4% | 1.002 | 0.178 | 1.006 | 1.004 | 1.001 | 1.004 | 1.004 | 1.004 | 1.005 | 0.178 | 1.003 |
| hex: shuffled/dickens-1m | 524290 | 15661.9 ± 0.3% | 1.002 | 0.178 | 1.001 | 1.001 | 1.000 | 0.999 | 1.000 | 0.997 | 0.998 | 0.177 | 1.001 |

## Losses

Each workload where a claim's path ran slower than the path it replaces by more than the noise floor of decision 20.

- string: http/html-1m, decoding: J13 decoder escape blocks off runs at 1.053 of all on.
- string: http/js-1m, decoding: J12 decoder escape words off runs at 1.054 of all on.
- hex: http/html-1kx1024, decoding: J5 UTF-8 vectors off runs at 1.304 of all on.
- hex: http/html-1kx1024, decoding: J7 wide vectors off runs at 1.291 of all on.
- hex: http/html-1kx1024, decoding: J8 decoder fast path off runs at 1.292 of all on.
- hex: http/html-1kx1024, decoding: J12 decoder escape words off runs at 1.308 of all on.
- hex: http/json-1kx1024, decoding: J5 UTF-8 vectors off runs at 1.309 of all on.
- hex: http/json-1kx1024, decoding: J7 wide vectors off runs at 1.290 of all on.
- hex: http/json-1kx1024, decoding: J8 decoder fast path off runs at 1.291 of all on.
- hex: http/json-1kx1024, decoding: J12 decoder escape words off runs at 1.301 of all on.
- hex: http/js-1kx1024, decoding: J5 UTF-8 vectors off runs at 1.306 of all on.
- hex: http/js-1kx1024, decoding: J7 wide vectors off runs at 1.306 of all on.
- hex: http/js-1kx1024, decoding: J8 decoder fast path off runs at 1.304 of all on.
- hex: http/js-1kx1024, decoding: J12 decoder escape words off runs at 1.319 of all on.
- hex: http/css-1kx1024, decoding: J5 UTF-8 vectors off runs at 1.301 of all on.
- hex: http/css-1kx1024, decoding: J7 wide vectors off runs at 1.288 of all on.
- hex: http/css-1kx1024, decoding: J8 decoder fast path off runs at 1.285 of all on.
- hex: http/css-1kx1024, decoding: J12 decoder escape words off runs at 1.289 of all on.

## UTF-8 validation against simdutf

stdx's `is_utf8`, the check the loops apply to every string's octets, run alone over each string workload's octets at the width the host's features pick (16 lanes on aarch64, AVX2's 32 or AVX-512's 64 on x86-64, decision 39), beside simdutf 9.3.3's `validate_utf8` in the same run; on a host with AVX-512, again with AVX2 alone. Each ratio is stdx's throughput over the other's. simdutf picks its kernel at run time. Before timing, every copy of the check and simdutf judged 20000 seeded buffers and each workload, whole and changed, alike.

| Workload | Octets | stdx, MB/s | simdutf, MB/s | stdx / simdutf | stdx with AVX2 alone, MB/s | stdx / stdx with AVX2 alone |
|---|---|---|---|---|---|---|
| string: silesia/dickens | 166668 | 43338.0 ± 0.0% | 47399.7 ± 0.1% | 0.914 | — | — |
| string: silesia/nci | 1048576 | 33553.4 ± 4.0% | 35954.1 ± 3.8% | 0.933 | — | — |
| string: silesia/reymont | 1048576 | 34113.4 ± 2.6% | 36387.5 ± 3.1% | 0.938 | — | — |
| string: silesia/samba | 65546 | 43561.7 ± 0.0% | 48520.2 ± 0.0% | 0.898 | — | — |
| string: silesia/webster | 1048576 | 35736.7 ± 2.7% | 38283.0 ± 3.3% | 0.933 | — | — |
| string: silesia/xml | 1048576 | 30381.7 ± 3.9% | 31611.5 ± 3.2% | 0.961 | — | — |
| string: canterbury/alice29.txt | 152089 | 35901.0 ± 0.1% | 36547.1 ± 0.1% | 0.982 | — | — |
| string: canterbury/asyoulik.txt | 125179 | 43364.2 ± 0.1% | 47680.9 ± 0.1% | 0.909 | — | — |
| string: canterbury/lcet10.txt | 426754 | 36064.9 ± 0.1% | 36519.3 ± 0.3% | 0.988 | — | — |
| string: canterbury/plrabn12.txt | 481861 | 40590.4 ± 1.3% | 44012.4 ± 0.6% | 0.922 | — | — |
| string: canterbury-large/E.coli | 1048576 | 33427.1 ± 2.6% | 35569.3 ± 1.0% | 0.940 | — | — |
| string: canterbury-large/bible.txt | 1048576 | 30541.7 ± 3.3% | 32135.5 ± 3.6% | 0.950 | — | — |
| string: canterbury-large/world192.txt | 1048576 | 30078.7 ± 25.2% | 31077.5 ± 32.0% | 0.968 | — | — |
| string: http/html-1m | 1048576 | 32890.0 ± 9.1% | 35179.2 ± 8.1% | 0.935 | — | — |
| string: http/json-1m | 1048576 | 28804.2 ± 1.1% | 30575.9 ± 1.9% | 0.942 | — | — |
| string: http/js-1m | 1048576 | 33558.6 ± 4.9% | 35674.7 ± 1.6% | 0.941 | — | — |
| string: http/css-1m | 1048576 | 31878.5 ± 4.9% | 34285.2 ± 2.6% | 0.930 | — | — |
| string: dickens as Cyrillic and CJK | 1847045 | 5766.2 ± 0.3% | 5649.3 ± 0.2% | 1.021 | — | — |

## Losses to simdutf

- string: silesia/dickens: stdx runs at 0.914 of simdutf.
- string: silesia/nci: stdx runs at 0.933 of simdutf.
- string: silesia/reymont: stdx runs at 0.938 of simdutf.
- string: silesia/samba: stdx runs at 0.898 of simdutf.
- string: silesia/webster: stdx runs at 0.933 of simdutf.
- string: canterbury/asyoulik.txt: stdx runs at 0.909 of simdutf.
- string: canterbury/plrabn12.txt: stdx runs at 0.922 of simdutf.
- string: canterbury-large/E.coli: stdx runs at 0.940 of simdutf.
- string: http/json-1m: stdx runs at 0.942 of simdutf.
- string: http/js-1m: stdx runs at 0.941 of simdutf.
- string: http/css-1m: stdx runs at 0.930 of simdutf.

## UTF-8 validation by the buffer's offset from a 64-octet line

| Buffer | Octets | Offset | stdx, MB/s | simdutf, MB/s | stdx / simdutf | stdx with AVX2 alone, MB/s | stdx / stdx with AVX2 alone |
|---|---|---|---|---|---|---|---|
| string: canterbury-large/bible.txt | 1048576 | 0 | 34684.5 ± 3.3% | 37550.7 ± 1.6% | 0.924 | — | — |
| string: canterbury-large/bible.txt | 1048576 | 1 | 30666.5 ± 0.5% | 31901.6 ± 1.9% | 0.961 | — | — |
| string: canterbury-large/bible.txt | 1048576 | 8 | 33679.4 ± 1.5% | 36404.9 ± 2.7% | 0.925 | — | — |
| string: canterbury-large/bible.txt | 1048576 | 16 | 34107.4 ± 2.0% | 37021.3 ± 1.8% | 0.921 | — | — |
| string: canterbury-large/bible.txt | 1048576 | 32 | 34350.9 ± 2.2% | 36945.6 ± 3.5% | 0.930 | — | — |
| string: canterbury-large/bible.txt | 1048576 | 48 | 33915.8 ± 1.9% | 36288.8 ± 0.9% | 0.935 | — | — |
| string: dickens as Cyrillic and CJK | 1048576 | 0 | 5746.7 ± 0.3% | 5635.7 ± 0.2% | 1.020 | — | — |
| string: dickens as Cyrillic and CJK | 1048576 | 1 | 5747.4 ± 0.2% | 5643.3 ± 0.1% | 1.018 | — | — |
| string: dickens as Cyrillic and CJK | 1048576 | 8 | 5754.8 ± 0.2% | 5643.5 ± 0.2% | 1.020 | — | — |
| string: dickens as Cyrillic and CJK | 1048576 | 16 | 5740.7 ± 0.4% | 5632.0 ± 0.2% | 1.019 | — | — |
| string: dickens as Cyrillic and CJK | 1048576 | 32 | 5756.1 ± 0.3% | 5637.0 ± 0.2% | 1.021 | — | — |
| string: dickens as Cyrillic and CJK | 1048576 | 48 | 5753.6 ± 0.2% | 5644.0 ± 0.3% | 1.019 | — | — |

## Against the baselines

stdx with every claim on, timed beside simdjson 5.1.1, yyjson 0.13.0, Zig 0.16.0's std.json, serde_json 1.0.154 and Go's encoding/json/jsontext in the same run. Each ratio is stdx's throughput over the baseline's; below 1, the baseline is faster. stdx is built for the architecture's baseline CPU in ReleaseSafe. Each baseline is built for the same CPU, the C, C++ and Zig ones in ReleaseFast (decision 75), and simdjson picks its kernel at run time. Decoding visits every value; encoding writes each text from its tokens.

## Decoding against the baselines

Octets are the text's. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1131.0 ± 0.3% | 925.3 ± 0.6% | 1015.3 ± 0.3% | 301.8 ± 0.5% | 665.6 ± 0.1% | 310.7 ± 1.8% | 1.222 | 1.114 | 3.748 | 1.699 | 3.641 |
| qlog records, JSON text sequence | 1467503 | 843.7 ± 1.1% | 814.8 ± 0.2% | 783.5 ± 1.7% | 243.9 ± 0.7% | 692.4 ± 0.5% | 249.0 ± 0.9% | 1.035 | 1.077 | 3.459 | 1.219 | 3.388 |
| string: silesia/dickens | 172528 | 5052.4 ± 0.5% | 1876.6 ± 0.1% | 2636.2 ± 0.6% | 361.0 ± 1.1% | 2865.1 ± 0.3% | 546.7 ± 2.4% | 2.692 | 1.917 | 13.997 | 1.763 | 9.242 |
| string: silesia/nci | 1075110 | 4294.8 ± 0.5% | 2233.2 ± 2.0% | 2981.9 ± 3.3% | 542.6 ± 0.9% | 2953.5 ± 1.8% | 599.9 ± 1.2% | 1.923 | 1.440 | 7.916 | 1.454 | 7.160 |
| string: silesia/reymont | 1075159 | 2932.8 ± 1.8% | 1818.4 ± 1.7% | 2063.7 ± 0.5% | 375.4 ± 0.7% | 2135.9 ± 0.6% | 535.1 ± 1.4% | 1.613 | 1.421 | 7.812 | 1.373 | 5.481 |
| string: silesia/samba | 97582 | 3487.5 ± 0.7% | 2025.7 ± 0.4% | 2613.7 ± 0.6% | 324.4 ± 0.2% | 1508.1 ± 0.5% | 426.9 ± 1.3% | 1.722 | 1.334 | 10.752 | 2.312 | 8.169 |
| string: silesia/webster | 1098490 | 3646.8 ± 1.0% | 1518.6 ± 0.3% | 2012.0 ± 1.1% | 359.1 ± 0.2% | 2158.5 ± 1.6% | 500.7 ± 2.6% | 2.401 | 1.813 | 10.154 | 1.690 | 7.283 |
| string: silesia/xml | 1090118 | 4768.7 ± 0.7% | 2354.8 ± 1.0% | 2520.7 ± 0.7% | 450.5 ± 0.9% | 2789.0 ± 1.2% | 564.2 ± 0.9% | 2.025 | 1.892 | 10.584 | 1.710 | 8.452 |
| string: canterbury/alice29.txt | 159425 | 4311.3 ± 1.5% | 1600.4 ± 0.2% | 2459.1 ± 0.9% | 342.1 ± 0.6% | 2505.8 ± 1.3% | 501.6 ± 1.2% | 2.694 | 1.753 | 12.604 | 1.721 | 8.596 |
| string: canterbury/asyoulik.txt | 132198 | 3459.4 ± 0.5% | 1458.0 ± 0.3% | 2246.5 ± 0.8% | 335.6 ± 0.5% | 2091.3 ± 0.3% | 457.5 ± 1.7% | 2.373 | 1.540 | 10.309 | 1.654 | 7.562 |
| string: canterbury/lcet10.txt | 441884 | 5074.1 ± 0.2% | 1852.9 ± 0.3% | 2334.3 ± 1.0% | 390.3 ± 0.5% | 2850.8 ± 1.0% | 531.1 ± 1.6% | 2.738 | 2.174 | 13.001 | 1.780 | 9.554 |
| string: canterbury/plrabn12.txt | 503330 | 4125.8 ± 0.7% | 1736.6 ± 0.2% | 2056.4 ± 0.7% | 360.4 ± 0.3% | 2483.2 ± 0.7% | 496.5 ± 1.8% | 2.376 | 2.006 | 11.447 | 1.662 | 8.310 |
| string: canterbury-large/E.coli | 1048578 | 19020.4 ± 0.7% | 3604.7 ± 0.6% | 3244.9 ± 0.4% | 927.0 ± 0.7% | 5957.0 ± 0.6% | 769.1 ± 0.8% | 5.277 | 5.862 | 20.517 | 3.193 | 24.732 |
| string: canterbury-large/bible.txt | 1055886 | 6677.5 ± 1.6% | 2939.3 ± 1.0% | 2830.4 ± 1.0% | 422.3 ± 2.9% | 3740.2 ± 1.1% | 618.9 ± 1.6% | 2.272 | 2.359 | 15.811 | 1.785 | 10.789 |
| string: canterbury-large/world192.txt | 1103121 | 3391.9 ± 0.1% | 1480.2 ± 0.3% | 2004.4 ± 0.3% | 352.8 ± 0.4% | 2112.4 ± 1.4% | 500.9 ± 0.8% | 2.292 | 1.692 | 9.615 | 1.606 | 6.771 |
| string: http/html-1m | 1058582 | 6049.8 ± 0.9% | 2737.6 ± 0.6% | 2684.6 ± 0.7% | 440.6 ± 0.6% | 3464.1 ± 0.8% | 595.1 ± 1.8% | 2.210 | 2.253 | 13.732 | 1.746 | 10.166 |
| string: http/json-1m | 1190272 | 2552.7 ± 0.4% | 877.1 ± 0.2% | 2248.3 ± 0.5% | 389.2 ± 0.3% | 1033.1 ± 0.7% | 442.7 ± 0.5% | 2.910 | 1.135 | 6.560 | 2.471 | 5.767 |
| string: http/js-1m | 1144362 | 2281.0 ± 0.6% | 1027.5 ± 0.3% | 1633.7 ± 0.4% | 320.7 ± 0.6% | 1509.4 ± 2.0% | 419.0 ± 0.3% | 2.220 | 1.396 | 7.113 | 1.511 | 5.444 |
| string: http/css-1m | 1097820 | 2632.9 ± 0.2% | 1675.6 ± 0.5% | 2221.1 ± 0.6% | 406.6 ± 1.0% | 1913.6 ± 0.8% | 489.3 ± 0.6% | 1.571 | 1.185 | 6.475 | 1.376 | 5.381 |
| string: dickens as Cyrillic and CJK | 1883069 | 3058.0 ± 0.8% | 1684.9 ± 0.4% | 893.1 ± 0.3% | 351.2 ± 0.2% | 666.2 ± 0.4% | 158.8 ± 1.8% | 1.815 | 3.424 | 8.707 | 4.590 | 19.258 |
| string: dickens as Cyrillic and CJK, as \u escapes | 5075485 | 1328.4 ± 1.4% | 980.5 ± 0.2% | 1208.4 ± 0.7% | 214.0 ± 0.4% | 471.2 ± 0.2% | 257.1 ± 3.3% | 1.355 | 1.099 | 6.208 | 2.819 | 5.168 |
| hex: silesia/dickens | 524290 | 18231.4 ± 2.3% | 3620.9 ± 0.1% | 3292.5 ± 0.7% | 503.2 ± 0.2% | 6109.8 ± 1.4% | 781.4 ± 2.4% | 5.035 | 5.537 | 36.231 | 2.984 | 23.333 |
| hex: silesia/mozilla | 524290 | 18174.4 ± 1.1% | 3620.8 ± 0.2% | 3291.6 ± 0.4% | 446.5 ± 1.7% | 6122.5 ± 1.3% | 781.7 ± 0.9% | 5.019 | 5.521 | 40.700 | 2.968 | 23.251 |
| hex: silesia/mr | 524290 | 17836.0 ± 1.3% | 3617.3 ± 0.3% | 3288.4 ± 0.4% | 572.4 ± 0.6% | 6145.7 ± 1.6% | 781.2 ± 0.5% | 4.931 | 5.424 | 31.161 | 2.902 | 22.832 |
| hex: silesia/nci | 524290 | 18230.9 ± 2.4% | 3618.7 ± 0.2% | 3281.5 ± 0.7% | 618.9 ± 1.6% | 6093.2 ± 1.8% | 781.2 ± 0.3% | 5.038 | 5.556 | 29.458 | 2.992 | 23.338 |
| hex: silesia/ooffice | 524290 | 18588.6 ± 1.1% | 3618.7 ± 0.1% | 3287.2 ± 0.3% | 399.2 ± 0.8% | 6084.6 ± 1.5% | 781.5 ± 0.3% | 5.137 | 5.655 | 46.565 | 3.055 | 23.787 |
| hex: silesia/osdb | 524290 | 17972.4 ± 0.8% | 3618.2 ± 0.3% | 3281.5 ± 0.6% | 475.3 ± 1.5% | 5995.7 ± 0.9% | 780.2 ± 0.8% | 4.967 | 5.477 | 37.817 | 2.998 | 23.037 |
| hex: silesia/reymont | 524290 | 18157.8 ± 5.7% | 3616.1 ± 0.2% | 3281.2 ± 0.8% | 507.7 ± 1.1% | 6103.5 ± 1.3% | 781.5 ± 1.7% | 5.021 | 5.534 | 35.765 | 2.975 | 23.233 |
| hex: silesia/samba | 524290 | 17784.7 ± 0.5% | 3619.8 ± 0.2% | 3287.9 ± 0.3% | 405.0 ± 1.0% | 6110.9 ± 1.4% | 781.3 ± 0.4% | 4.913 | 5.409 | 43.914 | 2.910 | 22.764 |
| hex: silesia/sao | 524290 | 18164.2 ± 0.6% | 3620.0 ± 0.6% | 3293.0 ± 0.5% | 345.1 ± 0.9% | 6099.0 ± 1.5% | 781.3 ± 0.6% | 5.018 | 5.516 | 52.628 | 2.978 | 23.249 |
| hex: silesia/webster | 524290 | 18450.4 ± 0.4% | 3614.1 ± 0.5% | 3280.7 ± 1.6% | 470.5 ± 0.2% | 6159.2 ± 1.0% | 782.3 ± 0.4% | 5.105 | 5.624 | 39.214 | 2.996 | 23.584 |
| hex: silesia/x-ray | 524290 | 18030.3 ± 1.7% | 3619.9 ± 0.2% | 3287.8 ± 0.3% | 476.3 ± 0.5% | 6054.9 ± 2.0% | 782.5 ± 0.5% | 4.981 | 5.484 | 37.852 | 2.978 | 23.041 |
| hex: silesia/xml | 524290 | 18414.3 ± 1.0% | 3620.6 ± 0.2% | 3274.3 ± 0.1% | 514.1 ± 0.7% | 6034.4 ± 0.5% | 780.2 ± 0.2% | 5.086 | 5.624 | 35.819 | 3.052 | 23.601 |
| hex: canterbury/alice29.txt | 304180 | 18918.7 ± 0.5% | 3632.2 ± 0.1% | 3368.7 ± 0.1% | 503.9 ± 2.5% | 6110.3 ± 1.0% | 781.3 ± 3.2% | 5.209 | 5.616 | 37.541 | 3.096 | 24.216 |
| hex: canterbury/asyoulik.txt | 250360 | 19501.6 ± 0.2% | 3642.5 ± 0.1% | 3358.0 ± 0.2% | 493.0 ± 1.2% | 6072.9 ± 1.3% | 778.4 ± 0.4% | 5.354 | 5.807 | 39.553 | 3.211 | 25.054 |
| hex: canterbury/cp.html | 49208 | 19290.7 ± 0.5% | 3639.8 ± 0.1% | 3277.2 ± 0.4% | 467.1 ± 1.9% | 6274.1 ± 1.0% | 765.9 ± 0.8% | 5.300 | 5.886 | 41.302 | 3.075 | 25.188 |
| hex: canterbury/fields.c | 22302 | 18866.2 ± 0.2% | 3626.5 ± 0.1% | 3394.7 ± 0.3% | 492.8 ± 3.8% | 6255.0 ± 0.4% | 758.5 ± 1.8% | 5.202 | 5.558 | 38.282 | 3.016 | 24.873 |
| hex: canterbury/grammar.lsp | 7444 | 17477.7 ± 1.5% | 3600.8 ± 0.1% | 3346.6 ± 0.4% | 542.7 ± 2.9% | 6184.9 ± 0.7% | 727.6 ± 1.9% | 4.854 | 5.223 | 32.206 | 2.826 | 24.019 |
| hex: canterbury/kennedy.xls | 524290 | 18283.2 ± 1.9% | 3605.7 ± 0.6% | 3287.5 ± 0.8% | 654.3 ± 9.0% | 6034.7 ± 1.9% | 754.9 ± 5.4% | 5.071 | 5.561 | 27.944 | 3.030 | 24.220 |
| hex: canterbury/lcet10.txt | 524290 | 17928.9 ± 1.5% | 3610.7 ± 1.3% | 3289.3 ± 0.3% | 511.9 ± 1.5% | 6048.4 ± 1.1% | 762.3 ± 1.0% | 4.966 | 5.451 | 35.023 | 2.964 | 23.521 |
| hex: canterbury/plrabn12.txt | 524290 | 17981.3 ± 0.7% | 3608.9 ± 0.3% | 3287.6 ± 0.2% | 517.2 ± 2.8% | 6082.9 ± 0.8% | 761.7 ± 0.8% | 4.983 | 5.469 | 34.766 | 2.956 | 23.608 |
| hex: canterbury/ptt5 | 524290 | 17914.3 ± 0.5% | 3612.3 ± 0.4% | 3275.6 ± 0.3% | 559.5 ± 1.2% | 6129.9 ± 1.7% | 760.6 ± 0.7% | 4.959 | 5.469 | 32.016 | 2.922 | 23.554 |
| hex: canterbury/sum | 76482 | 19297.9 ± 0.5% | 3632.9 ± 0.2% | 3354.3 ± 0.4% | 503.5 ± 1.7% | 6164.2 ± 0.5% | 769.9 ± 0.9% | 5.312 | 5.753 | 38.331 | 3.131 | 25.066 |
| hex: canterbury/xargs.1 | 8456 | 17834.5 ± 0.8% | 3602.4 ± 0.0% | 3356.9 ± 0.2% | 498.7 ± 2.6% | 6150.2 ± 0.4% | 751.6 ± 0.9% | 4.951 | 5.313 | 35.762 | 2.900 | 23.729 |
| hex: canterbury-large/E.coli | 524290 | 18086.9 ± 1.1% | 3606.3 ± 0.1% | 3284.6 ± 0.1% | 689.3 ± 0.0% | 6065.5 ± 0.9% | 759.7 ± 4.0% | 5.015 | 5.507 | 26.240 | 2.982 | 23.808 |
| hex: canterbury-large/bible.txt | 524290 | 18226.9 ± 1.1% | 3607.1 ± 0.2% | 3281.2 ± 0.3% | 515.2 ± 1.4% | 6123.1 ± 2.1% | 758.3 ± 1.4% | 5.053 | 5.555 | 35.382 | 2.977 | 24.037 |
| hex: canterbury-large/world192.txt | 524290 | 17696.9 ± 0.7% | 3607.8 ± 0.3% | 3286.0 ± 0.4% | 494.5 ± 0.8% | 6069.4 ± 0.7% | 755.8 ± 1.6% | 4.905 | 5.386 | 35.787 | 2.916 | 23.414 |
| hex: http/html-1kx1024 | 2099200 | 8860.3 ± 13.5% | 3455.7 ± 0.3% | 2831.0 ± 0.5% | 473.8 ± 1.0% | 5033.3 ± 1.8% | 640.5 ± 3.0% | 2.564 | 3.130 | 18.702 | 1.760 | 13.833 |
| hex: http/html-16kx64 | 2097280 | 17612.1 ± 1.4% | 3607.9 ± 0.4% | 3254.8 ± 0.4% | 465.7 ± 1.5% | 6044.0 ± 0.6% | 752.2 ± 1.7% | 4.882 | 5.411 | 37.818 | 2.914 | 23.415 |
| hex: http/html-1m | 524290 | 18132.3 ± 1.6% | 3611.9 ± 0.6% | 3281.3 ± 0.7% | 503.0 ± 2.1% | 6134.8 ± 0.7% | 763.5 ± 3.2% | 5.020 | 5.526 | 36.046 | 2.956 | 23.750 |
| hex: http/json-1kx1024 | 2099200 | 8881.7 ± 17.8% | 3455.5 ± 0.3% | 2829.9 ± 0.3% | 564.8 ± 3.0% | 5046.9 ± 1.4% | 638.1 ± 4.8% | 2.570 | 3.139 | 15.725 | 1.760 | 13.919 |
| hex: http/json-16kx64 | 2097280 | 17669.2 ± 2.2% | 3606.2 ± 0.2% | 3253.3 ± 0.2% | 573.3 ± 0.8% | 6030.5 ± 0.3% | 751.0 ± 3.6% | 4.900 | 5.431 | 30.821 | 2.930 | 23.528 |
| hex: http/json-1m | 524290 | 18474.6 ± 1.7% | 3612.5 ± 0.3% | 3292.5 ± 0.2% | 592.4 ± 0.9% | 6083.7 ± 1.3% | 761.6 ± 2.9% | 5.114 | 5.611 | 31.186 | 3.037 | 24.258 |
| hex: http/js-1kx1024 | 2099200 | 8867.4 ± 17.2% | 3461.4 ± 0.3% | 2831.0 ± 0.7% | 480.0 ± 0.3% | 5032.7 ± 1.0% | 635.2 ± 2.3% | 2.562 | 3.132 | 18.473 | 1.762 | 13.960 |
| hex: http/js-16kx64 | 2097280 | 17516.7 ± 0.9% | 3611.0 ± 0.1% | 3257.2 ± 0.3% | 478.4 ± 0.8% | 6016.3 ± 0.9% | 749.9 ± 2.5% | 4.851 | 5.378 | 36.613 | 2.912 | 23.358 |
| hex: http/js-1m | 524290 | 17913.1 ± 1.6% | 3610.6 ± 0.2% | 3289.7 ± 0.2% | 503.9 ± 1.2% | 6029.9 ± 1.6% | 761.9 ± 2.2% | 4.961 | 5.445 | 35.548 | 2.971 | 23.510 |
| hex: http/css-1kx1024 | 2099200 | 8979.6 ± 15.1% | 3459.9 ± 0.2% | 2825.7 ± 0.4% | 487.8 ± 1.0% | 5042.6 ± 0.5% | 636.1 ± 3.0% | 2.595 | 3.178 | 18.408 | 1.781 | 14.117 |
| hex: http/css-16kx64 | 2097280 | 17550.5 ± 0.7% | 3610.9 ± 0.2% | 3266.6 ± 0.2% | 492.0 ± 0.7% | 6012.9 ± 0.7% | 749.2 ± 3.7% | 4.860 | 5.373 | 35.675 | 2.919 | 23.426 |
| hex: http/css-1m | 524290 | 18237.2 ± 0.6% | 3603.5 ± 0.3% | 3280.3 ± 0.5% | 495.2 ± 0.9% | 6118.2 ± 1.4% | 763.0 ± 2.7% | 5.061 | 5.560 | 36.830 | 2.981 | 23.902 |
| hex: shuffled/dickens-1m | 524290 | 17571.5 ± 0.4% | 3603.9 ± 0.4% | 3284.0 ± 0.7% | 511.8 ± 0.5% | 6104.9 ± 0.5% | 763.6 ± 0.2% | 4.876 | 5.351 | 34.336 | 2.878 | 23.011 |

## Encoding against the baselines

Octets are the ones stdx writes. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1478.2 ± 0.6% | 1249.2 ± 0.4% | 1037.7 ± 0.8% | 408.6 ± 0.3% | 447.8 ± 0.2% | 415.3 ± 0.8% | 1.183 | 1.425 | 3.618 | 3.301 | 3.560 |
| qlog records, JSON text sequence | 1467503 | 1269.9 ± 1.8% | 1066.0 ± 0.3% | 781.3 ± 0.7% | 378.0 ± 0.7% | 479.1 ± 0.9% | 278.0 ± 0.9% | 1.191 | 1.625 | 3.359 | 2.650 | 4.568 |
| string: silesia/dickens | 172528 | 6848.3 ± 0.3% | 2802.7 ± 0.7% | 2927.9 ± 0.7% | 429.9 ± 0.6% | 1593.8 ± 0.3% | 1008.3 ± 0.4% | 2.443 | 2.339 | 15.930 | 4.297 | 6.792 |
| string: silesia/nci | 1075110 | 7305.5 ± 0.5% | 3407.9 ± 0.8% | 3097.3 ± 0.7% | 791.6 ± 9.3% | 1863.5 ± 0.3% | 1107.7 ± 0.6% | 2.144 | 2.359 | 9.229 | 3.920 | 6.595 |
| string: silesia/reymont | 1075159 | 3304.2 ± 1.3% | 1964.8 ± 0.5% | 2061.5 ± 0.4% | 448.3 ± 0.7% | 1507.7 ± 1.1% | 949.1 ± 0.1% | 1.682 | 1.603 | 7.370 | 2.192 | 3.481 |
| string: silesia/samba | 97582 | 4194.8 ± 1.0% | 2111.6 ± 0.8% | 3452.6 ± 0.3% | 355.5 ± 0.7% | 1486.2 ± 0.2% | 1052.9 ± 0.4% | 1.987 | 1.215 | 11.800 | 2.822 | 3.984 |
| string: silesia/webster | 1098490 | 4050.4 ± 0.5% | 1867.1 ± 0.6% | 2056.8 ± 0.4% | 442.4 ± 0.9% | 1400.4 ± 0.2% | 645.9 ± 0.4% | 2.169 | 1.969 | 9.156 | 2.892 | 6.271 |
| string: silesia/xml | 1090118 | 6119.1 ± 0.6% | 2857.0 ± 1.0% | 2646.6 ± 0.3% | 610.0 ± 0.6% | 1754.2 ± 0.3% | 920.7 ± 0.7% | 2.142 | 2.312 | 10.031 | 3.488 | 6.646 |
| string: canterbury/alice29.txt | 159425 | 6413.1 ± 1.0% | 2198.1 ± 0.3% | 2750.1 ± 0.8% | 408.6 ± 0.4% | 1471.3 ± 0.1% | 955.3 ± 0.6% | 2.918 | 2.332 | 15.697 | 4.359 | 6.714 |
| string: canterbury/asyoulik.txt | 132198 | 5593.2 ± 1.2% | 1711.4 ± 0.3% | 2371.9 ± 1.2% | 402.8 ± 0.3% | 1333.7 ± 0.4% | 885.0 ± 0.3% | 3.268 | 2.358 | 13.886 | 4.194 | 6.320 |
| string: canterbury/lcet10.txt | 441884 | 6230.7 ± 0.6% | 2562.7 ± 0.4% | 2479.9 ± 2.7% | 468.6 ± 0.7% | 1554.2 ± 0.4% | 982.5 ± 0.5% | 2.431 | 2.512 | 13.297 | 4.009 | 6.341 |
| string: canterbury/plrabn12.txt | 503330 | 5708.1 ± 0.6% | 2058.4 ± 0.3% | 2074.1 ± 0.5% | 423.2 ± 0.7% | 1391.5 ± 0.2% | 929.5 ± 0.9% | 2.773 | 2.752 | 13.487 | 4.102 | 6.141 |
| string: canterbury-large/E.coli | 1048578 | 19078.3 ± 1.0% | 9734.5 ± 1.1% | 3784.6 ± 0.7% | 1472.1 ± 0.9% | 2360.2 ± 0.2% | 1193.5 ± 0.5% | 1.960 | 5.041 | 12.960 | 8.083 | 15.986 |
| string: canterbury-large/bible.txt | 1055886 | 6788.0 ± 0.5% | 4128.2 ± 1.2% | 3024.8 ± 1.7% | 500.8 ± 0.9% | 1991.1 ± 0.5% | 1122.4 ± 0.3% | 1.644 | 2.244 | 13.555 | 3.409 | 6.048 |
| string: canterbury-large/world192.txt | 1103121 | 4008.8 ± 1.1% | 1648.4 ± 0.9% | 1998.9 ± 0.7% | 449.4 ± 0.6% | 1373.6 ± 0.3% | 908.2 ± 0.9% | 2.432 | 2.006 | 8.920 | 2.919 | 4.414 |
| string: http/html-1m | 1058582 | 6742.7 ± 0.5% | 3938.9 ± 0.5% | 3034.7 ± 0.4% | 499.7 ± 0.8% | 1927.7 ± 0.6% | 803.9 ± 0.6% | 1.712 | 2.222 | 13.493 | 3.498 | 8.388 |
| string: http/json-1m | 1190272 | 3159.6 ± 0.5% | 1354.0 ± 0.3% | 1551.4 ± 0.5% | 442.6 ± 0.4% | 1072.0 ± 0.2% | 765.4 ± 1.1% | 2.334 | 2.037 | 7.139 | 2.948 | 4.128 |
| string: http/js-1m | 1144362 | 2759.5 ± 0.5% | 1176.7 ± 0.5% | 1629.1 ± 0.8% | 368.3 ± 0.5% | 1111.3 ± 0.2% | 758.4 ± 0.1% | 2.345 | 1.694 | 7.493 | 2.483 | 3.638 |
| string: http/css-1m | 1097820 | 3986.5 ± 1.0% | 1490.2 ± 0.6% | 2151.9 ± 0.5% | 494.5 ± 0.1% | 1381.3 ± 0.3% | 892.6 ± 0.7% | 2.675 | 1.853 | 8.061 | 2.886 | 4.466 |
| string: dickens as Cyrillic and CJK | 1883069 | 3062.6 ± 0.4% | 2343.9 ± 0.7% | 521.4 ± 0.7% | 307.2 ± 0.3% | 562.1 ± 1.0% | 336.1 ± 0.4% | 1.307 | 5.874 | 9.969 | 5.448 | 9.112 |
| hex: silesia/dickens | 524290 | 15594.2 ± 0.1% | 1457.3 ± 0.5% | 1083.5 ± 0.4% | 499.2 ± 0.5% | 987.8 ± 0.4% | 732.4 ± 0.2% | 10.700 | 14.393 | 31.239 | 15.787 | 21.292 |
| hex: silesia/mozilla | 524290 | 15586.3 ± 0.2% | 1467.0 ± 0.5% | 1085.9 ± 0.3% | 440.8 ± 0.3% | 988.7 ± 0.5% | 733.5 ± 1.0% | 10.625 | 14.353 | 35.361 | 15.765 | 21.248 |
| hex: silesia/mr | 524290 | 15649.2 ± 0.2% | 1476.5 ± 0.2% | 1092.8 ± 0.5% | 546.5 ± 1.9% | 996.0 ± 0.4% | 732.9 ± 0.3% | 10.599 | 14.320 | 28.637 | 15.713 | 21.352 |
| hex: silesia/nci | 524290 | 15634.1 ± 0.4% | 1468.0 ± 0.4% | 1086.2 ± 0.5% | 630.5 ± 2.9% | 988.5 ± 0.4% | 732.7 ± 0.5% | 10.650 | 14.394 | 24.797 | 15.816 | 21.337 |
| hex: silesia/ooffice | 524290 | 15584.6 ± 0.1% | 1458.4 ± 0.2% | 1083.1 ± 0.9% | 388.9 ± 0.3% | 990.1 ± 0.8% | 733.3 ± 0.5% | 10.686 | 14.389 | 40.073 | 15.741 | 21.252 |
| hex: silesia/osdb | 524290 | 15635.0 ± 0.2% | 1466.2 ± 0.3% | 1084.8 ± 0.6% | 471.2 ± 3.1% | 988.2 ± 0.3% | 731.8 ± 0.6% | 10.664 | 14.413 | 33.182 | 15.822 | 21.366 |
| hex: silesia/reymont | 524290 | 15632.1 ± 0.5% | 1459.4 ± 0.5% | 1085.5 ± 0.5% | 514.2 ± 0.7% | 986.2 ± 0.7% | 732.9 ± 0.6% | 10.711 | 14.401 | 30.399 | 15.852 | 21.329 |
| hex: silesia/samba | 524290 | 15604.5 ± 0.2% | 1460.3 ± 0.3% | 1081.8 ± 0.4% | 402.6 ± 0.6% | 987.2 ± 0.4% | 731.6 ± 0.3% | 10.686 | 14.424 | 38.759 | 15.808 | 21.330 |
| hex: silesia/sao | 524290 | 15609.2 ± 0.2% | 1460.2 ± 0.4% | 1083.9 ± 0.4% | 331.9 ± 0.5% | 990.6 ± 0.2% | 732.9 ± 0.4% | 10.690 | 14.401 | 47.026 | 15.758 | 21.299 |
| hex: silesia/webster | 524290 | 15632.7 ± 0.1% | 1458.7 ± 0.6% | 1082.2 ± 0.4% | 474.3 ± 0.6% | 985.9 ± 0.4% | 732.9 ± 0.3% | 10.717 | 14.445 | 32.956 | 15.857 | 21.329 |
| hex: silesia/x-ray | 524290 | 15616.1 ± 0.5% | 1469.7 ± 0.1% | 1088.3 ± 0.5% | 446.9 ± 1.1% | 995.4 ± 0.4% | 732.4 ± 0.7% | 10.625 | 14.348 | 34.944 | 15.689 | 21.321 |
| hex: silesia/xml | 524290 | 15618.2 ± 0.2% | 1463.0 ± 0.3% | 1084.2 ± 0.3% | 612.4 ± 0.7% | 986.3 ± 0.6% | 733.9 ± 0.8% | 10.675 | 14.405 | 25.504 | 15.835 | 21.282 |
| hex: canterbury/alice29.txt | 304180 | 15684.2 ± 0.1% | 1470.6 ± 0.6% | 1092.2 ± 0.4% | 503.3 ± 1.1% | 992.7 ± 0.8% | 731.1 ± 0.5% | 10.665 | 14.361 | 31.161 | 15.799 | 21.454 |
| hex: canterbury/asyoulik.txt | 250360 | 15702.2 ± 0.1% | 1469.1 ± 0.5% | 1093.0 ± 0.3% | 500.7 ± 1.7% | 995.1 ± 0.3% | 737.2 ± 0.5% | 10.688 | 14.367 | 31.360 | 15.780 | 21.300 |
| hex: canterbury/cp.html | 49208 | 15621.1 ± 0.1% | 1471.4 ± 0.3% | 1096.7 ± 0.5% | 531.5 ± 2.4% | 1008.0 ± 0.0% | 743.0 ± 0.2% | 10.616 | 14.244 | 29.391 | 15.497 | 21.024 |
| hex: canterbury/fields.c | 22302 | 15442.5 ± 0.1% | 1398.4 ± 0.9% | 1067.4 ± 0.8% | 633.8 ± 7.4% | 982.1 ± 0.2% | 736.8 ± 0.5% | 11.043 | 14.467 | 24.365 | 15.725 | 20.959 |
| hex: canterbury/grammar.lsp | 7444 | 14931.1 ± 0.2% | 1507.8 ± 0.2% | 1095.2 ± 0.5% | 671.4 ± 5.0% | 998.4 ± 0.2% | 726.4 ± 0.1% | 9.903 | 13.633 | 22.240 | 14.956 | 20.556 |
| hex: canterbury/kennedy.xls | 524290 | 15610.2 ± 0.3% | 1461.0 ± 0.4% | 1085.9 ± 0.6% | 653.4 ± 0.8% | 988.5 ± 0.6% | 730.9 ± 0.3% | 10.685 | 14.376 | 23.890 | 15.792 | 21.359 |
| hex: canterbury/lcet10.txt | 524290 | 15623.3 ± 0.1% | 1459.5 ± 0.2% | 1083.4 ± 0.3% | 498.7 ± 2.0% | 991.5 ± 1.0% | 732.3 ± 0.5% | 10.705 | 14.421 | 31.327 | 15.757 | 21.334 |
| hex: canterbury/plrabn12.txt | 524290 | 15634.8 ± 0.3% | 1451.6 ± 0.3% | 1080.5 ± 0.3% | 491.1 ± 0.4% | 983.1 ± 0.5% | 731.8 ± 0.4% | 10.771 | 14.470 | 31.834 | 15.903 | 21.365 |
| hex: canterbury/ptt5 | 524290 | 15627.2 ± 0.4% | 1476.0 ± 0.5% | 1091.4 ± 0.4% | 556.9 ± 1.0% | 992.6 ± 0.7% | 732.8 ± 0.3% | 10.587 | 14.319 | 28.062 | 15.744 | 21.327 |
| hex: canterbury/sum | 76482 | 15644.1 ± 0.0% | 1493.5 ± 0.1% | 1105.3 ± 0.2% | 594.9 ± 1.3% | 998.3 ± 0.0% | 744.4 ± 0.1% | 10.475 | 14.154 | 26.295 | 15.671 | 21.017 |
| hex: canterbury/xargs.1 | 8456 | 15009.3 ± 0.1% | 1493.2 ± 0.2% | 1095.8 ± 0.4% | 654.1 ± 2.5% | 997.9 ± 0.6% | 728.6 ± 0.2% | 10.052 | 13.698 | 22.946 | 15.041 | 20.601 |
| hex: canterbury-large/E.coli | 524290 | 15593.8 ± 0.3% | 1471.8 ± 0.4% | 1089.6 ± 0.8% | 671.8 ± 0.3% | 993.2 ± 0.5% | 730.6 ± 0.7% | 10.595 | 14.312 | 23.212 | 15.701 | 21.344 |
| hex: canterbury-large/bible.txt | 524290 | 15618.6 ± 0.3% | 1461.3 ± 0.4% | 1082.1 ± 0.5% | 513.6 ± 1.0% | 986.4 ± 0.2% | 731.4 ± 0.9% | 10.688 | 14.433 | 30.413 | 15.833 | 21.353 |
| hex: canterbury-large/world192.txt | 524290 | 15641.4 ± 0.4% | 1465.6 ± 0.6% | 1083.2 ± 0.5% | 502.7 ± 0.7% | 991.1 ± 0.3% | 731.4 ± 0.6% | 10.673 | 14.440 | 31.117 | 15.782 | 21.384 |
| hex: http/html-1kx1024 | 2099200 | 13632.6 ± 0.5% | 1454.9 ± 0.2% | 1061.7 ± 0.2% | 501.2 ± 0.2% | 983.6 ± 0.2% | 692.6 ± 0.1% | 9.370 | 12.841 | 27.201 | 13.861 | 19.683 |
| hex: http/html-16kx64 | 2097280 | 15271.5 ± 0.3% | 1441.3 ± 0.2% | 1072.9 ± 0.7% | 506.2 ± 0.2% | 994.7 ± 0.2% | 734.6 ± 0.2% | 10.595 | 14.234 | 30.171 | 15.352 | 20.788 |
| hex: http/html-1m | 524290 | 15552.2 ± 0.3% | 1463.9 ± 0.3% | 1084.7 ± 0.3% | 498.6 ± 0.6% | 989.7 ± 0.4% | 732.8 ± 0.7% | 10.624 | 14.338 | 31.189 | 15.714 | 21.222 |
| hex: http/json-1kx1024 | 2099200 | 13713.7 ± 0.4% | 1463.0 ± 0.1% | 1065.9 ± 0.6% | 608.9 ± 0.7% | 985.7 ± 0.1% | 692.8 ± 0.1% | 9.374 | 12.866 | 22.521 | 13.912 | 19.793 |
| hex: http/json-16kx64 | 2097280 | 15245.7 ± 0.3% | 1446.7 ± 0.3% | 1074.8 ± 0.1% | 615.6 ± 0.6% | 995.9 ± 0.4% | 734.8 ± 0.1% | 10.539 | 14.184 | 24.764 | 15.309 | 20.749 |
| hex: http/json-1m | 524290 | 15656.8 ± 0.3% | 1468.0 ± 0.2% | 1086.2 ± 0.3% | 628.3 ± 1.3% | 990.0 ± 0.5% | 732.6 ± 0.7% | 10.665 | 14.414 | 24.921 | 15.815 | 21.373 |
| hex: http/js-1kx1024 | 2099200 | 13734.7 ± 0.4% | 1453.5 ± 0.2% | 1063.1 ± 0.3% | 499.1 ± 0.2% | 982.9 ± 0.3% | 692.8 ± 0.2% | 9.450 | 12.920 | 27.517 | 13.974 | 19.825 |
| hex: http/js-16kx64 | 2097280 | 15190.2 ± 0.3% | 1444.3 ± 0.2% | 1073.9 ± 0.5% | 504.7 ± 0.1% | 994.1 ± 0.1% | 734.7 ± 0.1% | 10.518 | 14.145 | 30.099 | 15.281 | 20.675 |
| hex: http/js-1m | 524290 | 15680.9 ± 0.3% | 1458.3 ± 0.4% | 1084.1 ± 0.5% | 510.3 ± 0.4% | 990.1 ± 0.3% | 732.0 ± 0.7% | 10.753 | 14.465 | 30.726 | 15.838 | 21.422 |
| hex: http/css-1kx1024 | 2099200 | 13635.5 ± 0.5% | 1453.9 ± 0.1% | 1062.2 ± 0.1% | 530.6 ± 0.5% | 983.1 ± 0.1% | 692.7 ± 0.1% | 9.379 | 12.837 | 25.697 | 13.870 | 19.684 |
| hex: http/css-16kx64 | 2097280 | 15280.1 ± 1.0% | 1444.6 ± 0.5% | 1074.6 ± 0.7% | 538.8 ± 0.3% | 998.5 ± 0.4% | 734.9 ± 0.2% | 10.577 | 14.219 | 28.359 | 15.303 | 20.792 |
| hex: http/css-1m | 524290 | 15550.3 ± 0.4% | 1458.9 ± 0.3% | 1083.3 ± 0.5% | 524.6 ± 0.6% | 988.0 ± 0.4% | 731.1 ± 0.5% | 10.659 | 14.355 | 29.644 | 15.739 | 21.271 |
| hex: shuffled/dickens-1m | 524290 | 15661.9 ± 0.3% | 1455.9 ± 0.6% | 1083.0 ± 0.2% | 499.9 ± 1.0% | 986.7 ± 0.6% | 731.7 ± 0.3% | 10.758 | 14.462 | 31.330 | 15.874 | 21.405 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1521.9 ± 0.5% | 1249.2 ± 0.4% | 1037.7 ± 0.8% | 408.6 ± 0.3% | 447.8 ± 0.2% | 415.3 ± 0.8% | 1.218 | 1.467 | 3.725 | 3.399 | 3.665 |
| qlog records, JSON text sequence | 1467503 | 1293.4 ± 0.4% | 1066.0 ± 0.3% | 781.3 ± 0.7% | 378.0 ± 0.7% | 479.1 ± 0.9% | 278.0 ± 0.9% | 1.213 | 1.655 | 3.421 | 2.699 | 4.653 |
| string: silesia/dickens | 172528 | 7119.2 ± 0.1% | 2802.7 ± 0.7% | 2927.9 ± 0.7% | 429.9 ± 0.6% | 1593.8 ± 0.3% | 1008.3 ± 0.4% | 2.540 | 2.431 | 16.561 | 4.467 | 7.060 |
| string: silesia/nci | 1075110 | 7386.6 ± 0.9% | 3407.9 ± 0.8% | 3097.3 ± 0.7% | 791.6 ± 9.3% | 1863.5 ± 0.3% | 1107.7 ± 0.6% | 2.168 | 2.385 | 9.331 | 3.964 | 6.668 |
| string: silesia/reymont | 1075159 | 3500.7 ± 1.2% | 1964.8 ± 0.5% | 2061.5 ± 0.4% | 448.3 ± 0.7% | 1507.7 ± 1.1% | 949.1 ± 0.1% | 1.782 | 1.698 | 7.808 | 2.322 | 3.688 |
| string: silesia/samba | 97582 | 4579.5 ± 1.0% | 2111.6 ± 0.8% | 3452.6 ± 0.3% | 355.5 ± 0.7% | 1486.2 ± 0.2% | 1052.9 ± 0.4% | 2.169 | 1.326 | 12.883 | 3.081 | 4.349 |
| string: silesia/webster | 1098490 | 4084.1 ± 0.7% | 1867.1 ± 0.6% | 2056.8 ± 0.4% | 442.4 ± 0.9% | 1400.4 ± 0.2% | 645.9 ± 0.4% | 2.187 | 1.986 | 9.233 | 2.916 | 6.323 |
| string: silesia/xml | 1090118 | 6230.8 ± 0.1% | 2857.0 ± 1.0% | 2646.6 ± 0.3% | 610.0 ± 0.6% | 1754.2 ± 0.3% | 920.7 ± 0.7% | 2.181 | 2.354 | 10.214 | 3.552 | 6.767 |
| string: canterbury/alice29.txt | 159425 | 6768.7 ± 3.2% | 2198.1 ± 0.3% | 2750.1 ± 0.8% | 408.6 ± 0.4% | 1471.3 ± 0.1% | 955.3 ± 0.6% | 3.079 | 2.461 | 16.567 | 4.601 | 7.086 |
| string: canterbury/asyoulik.txt | 132198 | 5885.4 ± 5.7% | 1711.4 ± 0.3% | 2371.9 ± 1.2% | 402.8 ± 0.3% | 1333.7 ± 0.4% | 885.0 ± 0.3% | 3.439 | 2.481 | 14.611 | 4.413 | 6.650 |
| string: canterbury/lcet10.txt | 441884 | 6235.2 ± 0.3% | 2562.7 ± 0.4% | 2479.9 ± 2.7% | 468.6 ± 0.7% | 1554.2 ± 0.4% | 982.5 ± 0.5% | 2.433 | 2.514 | 13.306 | 4.012 | 6.346 |
| string: canterbury/plrabn12.txt | 503330 | 5748.8 ± 0.3% | 2058.4 ± 0.3% | 2074.1 ± 0.5% | 423.2 ± 0.7% | 1391.5 ± 0.2% | 929.5 ± 0.9% | 2.793 | 2.772 | 13.584 | 4.131 | 6.185 |
| string: canterbury-large/E.coli | 1048578 | 19133.3 ± 3.8% | 9734.5 ± 1.1% | 3784.6 ± 0.7% | 1472.1 ± 0.9% | 2360.2 ± 0.2% | 1193.5 ± 0.5% | 1.966 | 5.056 | 12.997 | 8.106 | 16.032 |
| string: canterbury-large/bible.txt | 1055886 | 6778.5 ± 0.4% | 4128.2 ± 1.2% | 3024.8 ± 1.7% | 500.8 ± 0.9% | 1991.1 ± 0.5% | 1122.4 ± 0.3% | 1.642 | 2.241 | 13.536 | 3.404 | 6.040 |
| string: canterbury-large/world192.txt | 1103121 | 4025.2 ± 1.1% | 1648.4 ± 0.9% | 1998.9 ± 0.7% | 449.4 ± 0.6% | 1373.6 ± 0.3% | 908.2 ± 0.9% | 2.442 | 2.014 | 8.956 | 2.930 | 4.432 |
| string: http/html-1m | 1058582 | 6813.6 ± 0.5% | 3938.9 ± 0.5% | 3034.7 ± 0.4% | 499.7 ± 0.8% | 1927.7 ± 0.6% | 803.9 ± 0.6% | 1.730 | 2.245 | 13.634 | 3.535 | 8.476 |
| string: http/json-1m | 1190272 | 3294.0 ± 0.4% | 1354.0 ± 0.3% | 1551.4 ± 0.5% | 442.6 ± 0.4% | 1072.0 ± 0.2% | 765.4 ± 1.1% | 2.433 | 2.123 | 7.443 | 3.073 | 4.304 |
| string: http/js-1m | 1144362 | 2800.8 ± 0.8% | 1176.7 ± 0.5% | 1629.1 ± 0.8% | 368.3 ± 0.5% | 1111.3 ± 0.2% | 758.4 ± 0.1% | 2.380 | 1.719 | 7.605 | 2.520 | 3.693 |
| string: http/css-1m | 1097820 | 4024.2 ± 0.9% | 1490.2 ± 0.6% | 2151.9 ± 0.5% | 494.5 ± 0.1% | 1381.3 ± 0.3% | 892.6 ± 0.7% | 2.701 | 1.870 | 8.137 | 2.913 | 4.509 |
| string: dickens as Cyrillic and CJK | 1883069 | 3071.5 ± 0.5% | 2343.9 ± 0.7% | 521.4 ± 0.7% | 307.2 ± 0.3% | 562.1 ± 1.0% | 336.1 ± 0.4% | 1.310 | 5.891 | 9.999 | 5.464 | 9.139 |
| hex: silesia/dickens | 524290 | 15611.6 ± 0.3% | 1457.3 ± 0.5% | 1083.5 ± 0.4% | 499.2 ± 0.5% | 987.8 ± 0.4% | 732.4 ± 0.2% | 10.712 | 14.409 | 31.273 | 15.805 | 21.315 |
| hex: silesia/mozilla | 524290 | 15627.6 ± 0.2% | 1467.0 ± 0.5% | 1085.9 ± 0.3% | 440.8 ± 0.3% | 988.7 ± 0.5% | 733.5 ± 1.0% | 10.653 | 14.392 | 35.454 | 15.807 | 21.304 |
| hex: silesia/mr | 524290 | 15654.6 ± 0.4% | 1476.5 ± 0.2% | 1092.8 ± 0.5% | 546.5 ± 1.9% | 996.0 ± 0.4% | 732.9 ± 0.3% | 10.603 | 14.325 | 28.647 | 15.718 | 21.360 |
| hex: silesia/nci | 524290 | 15664.8 ± 0.4% | 1468.0 ± 0.4% | 1086.2 ± 0.5% | 630.5 ± 2.9% | 988.5 ± 0.4% | 732.7 ± 0.5% | 10.671 | 14.422 | 24.845 | 15.847 | 21.379 |
| hex: silesia/ooffice | 524290 | 15604.8 ± 1.1% | 1458.4 ± 0.2% | 1083.1 ± 0.9% | 388.9 ± 0.3% | 990.1 ± 0.8% | 733.3 ± 0.5% | 10.700 | 14.408 | 40.125 | 15.761 | 21.280 |
| hex: silesia/osdb | 524290 | 15596.1 ± 0.8% | 1466.2 ± 0.3% | 1084.8 ± 0.6% | 471.2 ± 3.1% | 988.2 ± 0.3% | 731.8 ± 0.6% | 10.637 | 14.377 | 33.100 | 15.783 | 21.312 |
| hex: silesia/reymont | 524290 | 15666.2 ± 0.3% | 1459.4 ± 0.5% | 1085.5 ± 0.5% | 514.2 ± 0.7% | 986.2 ± 0.7% | 732.9 ± 0.6% | 10.734 | 14.432 | 30.465 | 15.886 | 21.375 |
| hex: silesia/samba | 524290 | 15610.2 ± 0.2% | 1460.3 ± 0.3% | 1081.8 ± 0.4% | 402.6 ± 0.6% | 987.2 ± 0.4% | 731.6 ± 0.3% | 10.690 | 14.430 | 38.773 | 15.813 | 21.337 |
| hex: silesia/sao | 524290 | 15602.1 ± 0.2% | 1460.2 ± 0.4% | 1083.9 ± 0.4% | 331.9 ± 0.5% | 990.6 ± 0.2% | 732.9 ± 0.4% | 10.685 | 14.395 | 47.004 | 15.751 | 21.289 |
| hex: silesia/webster | 524290 | 15614.7 ± 0.7% | 1458.7 ± 0.6% | 1082.2 ± 0.4% | 474.3 ± 0.6% | 985.9 ± 0.4% | 732.9 ± 0.3% | 10.704 | 14.428 | 32.918 | 15.838 | 21.304 |
| hex: silesia/x-ray | 524290 | 15497.6 ± 0.2% | 1469.7 ± 0.1% | 1088.3 ± 0.5% | 446.9 ± 1.1% | 995.4 ± 0.4% | 732.4 ± 0.7% | 10.545 | 14.240 | 34.679 | 15.569 | 21.159 |
| hex: silesia/xml | 524290 | 15618.0 ± 0.7% | 1463.0 ± 0.3% | 1084.2 ± 0.3% | 612.4 ± 0.7% | 986.3 ± 0.6% | 733.9 ± 0.8% | 10.675 | 14.405 | 25.503 | 15.835 | 21.281 |
| hex: canterbury/alice29.txt | 304180 | 15700.7 ± 0.1% | 1470.6 ± 0.6% | 1092.2 ± 0.4% | 503.3 ± 1.1% | 992.7 ± 0.8% | 731.1 ± 0.5% | 10.676 | 14.376 | 31.194 | 15.816 | 21.476 |
| hex: canterbury/asyoulik.txt | 250360 | 15714.1 ± 0.1% | 1469.1 ± 0.5% | 1093.0 ± 0.3% | 500.7 ± 1.7% | 995.1 ± 0.3% | 737.2 ± 0.5% | 10.696 | 14.377 | 31.384 | 15.792 | 21.316 |
| hex: canterbury/cp.html | 49208 | 15638.4 ± 0.0% | 1471.4 ± 0.3% | 1096.7 ± 0.5% | 531.5 ± 2.4% | 1008.0 ± 0.0% | 743.0 ± 0.2% | 10.628 | 14.260 | 29.423 | 15.514 | 21.047 |
| hex: canterbury/fields.c | 22302 | 15455.4 ± 0.0% | 1398.4 ± 0.9% | 1067.4 ± 0.8% | 633.8 ± 7.4% | 982.1 ± 0.2% | 736.8 ± 0.5% | 11.053 | 14.479 | 24.386 | 15.738 | 20.977 |
| hex: canterbury/grammar.lsp | 7444 | 14980.8 ± 0.0% | 1507.8 ± 0.2% | 1095.2 ± 0.5% | 671.4 ± 5.0% | 998.4 ± 0.2% | 726.4 ± 0.1% | 9.936 | 13.679 | 22.314 | 15.006 | 20.624 |
| hex: canterbury/kennedy.xls | 524290 | 15598.9 ± 0.5% | 1461.0 ± 0.4% | 1085.9 ± 0.6% | 653.4 ± 0.8% | 988.5 ± 0.6% | 730.9 ± 0.3% | 10.677 | 14.365 | 23.872 | 15.781 | 21.343 |
| hex: canterbury/lcet10.txt | 524290 | 15554.8 ± 0.5% | 1459.5 ± 0.2% | 1083.4 ± 0.3% | 498.7 ± 2.0% | 991.5 ± 1.0% | 732.3 ± 0.5% | 10.658 | 14.358 | 31.190 | 15.688 | 21.241 |
| hex: canterbury/plrabn12.txt | 524290 | 15633.4 ± 0.3% | 1451.6 ± 0.3% | 1080.5 ± 0.3% | 491.1 ± 0.4% | 983.1 ± 0.5% | 731.8 ± 0.4% | 10.770 | 14.469 | 31.832 | 15.902 | 21.363 |
| hex: canterbury/ptt5 | 524290 | 15637.6 ± 0.3% | 1476.0 ± 0.5% | 1091.4 ± 0.4% | 556.9 ± 1.0% | 992.6 ± 0.7% | 732.8 ± 0.3% | 10.594 | 14.328 | 28.081 | 15.754 | 21.341 |
| hex: canterbury/sum | 76482 | 15657.5 ± 0.1% | 1493.5 ± 0.1% | 1105.3 ± 0.2% | 594.9 ± 1.3% | 998.3 ± 0.0% | 744.4 ± 0.1% | 10.484 | 14.166 | 26.318 | 15.684 | 21.035 |
| hex: canterbury/xargs.1 | 8456 | 15040.9 ± 0.0% | 1493.2 ± 0.2% | 1095.8 ± 0.4% | 654.1 ± 2.5% | 997.9 ± 0.6% | 728.6 ± 0.2% | 10.073 | 13.726 | 22.995 | 15.073 | 20.644 |
| hex: canterbury-large/E.coli | 524290 | 15582.6 ± 0.4% | 1471.8 ± 0.4% | 1089.6 ± 0.8% | 671.8 ± 0.3% | 993.2 ± 0.5% | 730.6 ± 0.7% | 10.587 | 14.302 | 23.195 | 15.690 | 21.329 |
| hex: canterbury-large/bible.txt | 524290 | 15573.4 ± 0.6% | 1461.3 ± 0.4% | 1082.1 ± 0.5% | 513.6 ± 1.0% | 986.4 ± 0.2% | 731.4 ± 0.9% | 10.657 | 14.392 | 30.325 | 15.787 | 21.291 |
| hex: canterbury-large/world192.txt | 524290 | 15646.3 ± 0.1% | 1465.6 ± 0.6% | 1083.2 ± 0.5% | 502.7 ± 0.7% | 991.1 ± 0.3% | 731.4 ± 0.6% | 10.676 | 14.445 | 31.127 | 15.786 | 21.391 |
| hex: http/html-1kx1024 | 2099200 | 13772.8 ± 0.3% | 1454.9 ± 0.2% | 1061.7 ± 0.2% | 501.2 ± 0.2% | 983.6 ± 0.2% | 692.6 ± 0.1% | 9.467 | 12.973 | 27.480 | 14.003 | 19.886 |
| hex: http/html-16kx64 | 2097280 | 15313.6 ± 0.6% | 1441.3 ± 0.2% | 1072.9 ± 0.7% | 506.2 ± 0.2% | 994.7 ± 0.2% | 734.6 ± 0.2% | 10.625 | 14.274 | 30.254 | 15.395 | 20.845 |
| hex: http/html-1m | 524290 | 15580.5 ± 0.3% | 1463.9 ± 0.3% | 1084.7 ± 0.3% | 498.6 ± 0.6% | 989.7 ± 0.4% | 732.8 ± 0.7% | 10.644 | 14.364 | 31.246 | 15.743 | 21.261 |
| hex: http/json-1kx1024 | 2099200 | 13878.9 ± 0.5% | 1463.0 ± 0.1% | 1065.9 ± 0.6% | 608.9 ± 0.7% | 985.7 ± 0.1% | 692.8 ± 0.1% | 9.487 | 13.021 | 22.792 | 14.080 | 20.032 |
| hex: http/json-16kx64 | 2097280 | 15288.2 ± 0.7% | 1446.7 ± 0.3% | 1074.8 ± 0.1% | 615.6 ± 0.6% | 995.9 ± 0.4% | 734.8 ± 0.1% | 10.568 | 14.224 | 24.833 | 15.351 | 20.807 |
| hex: http/json-1m | 524290 | 15633.9 ± 0.9% | 1468.0 ± 0.2% | 1086.2 ± 0.3% | 628.3 ± 1.3% | 990.0 ± 0.5% | 732.6 ± 0.7% | 10.650 | 14.393 | 24.884 | 15.792 | 21.342 |
| hex: http/js-1kx1024 | 2099200 | 13895.9 ± 0.4% | 1453.5 ± 0.2% | 1063.1 ± 0.3% | 499.1 ± 0.2% | 982.9 ± 0.3% | 692.8 ± 0.2% | 9.561 | 13.071 | 27.840 | 14.138 | 20.058 |
| hex: http/js-16kx64 | 2097280 | 15282.5 ± 0.5% | 1444.3 ± 0.2% | 1073.9 ± 0.5% | 504.7 ± 0.1% | 994.1 ± 0.1% | 734.7 ± 0.1% | 10.581 | 14.231 | 30.282 | 15.374 | 20.801 |
| hex: http/js-1m | 524290 | 15698.2 ± 0.2% | 1458.3 ± 0.4% | 1084.1 ± 0.5% | 510.3 ± 0.4% | 990.1 ± 0.3% | 732.0 ± 0.7% | 10.764 | 14.480 | 30.760 | 15.856 | 21.446 |
| hex: http/css-1kx1024 | 2099200 | 13803.5 ± 3.9% | 1453.9 ± 0.1% | 1062.2 ± 0.1% | 530.6 ± 0.5% | 983.1 ± 0.1% | 692.7 ± 0.1% | 9.494 | 12.995 | 26.014 | 14.041 | 19.927 |
| hex: http/css-16kx64 | 2097280 | 15286.1 ± 0.7% | 1444.6 ± 0.5% | 1074.6 ± 0.7% | 538.8 ± 0.3% | 998.5 ± 0.4% | 734.9 ± 0.2% | 10.581 | 14.225 | 28.370 | 15.309 | 20.800 |
| hex: http/css-1m | 524290 | 15600.0 ± 0.5% | 1458.9 ± 0.3% | 1083.3 ± 0.5% | 524.6 ± 0.6% | 988.0 ± 0.4% | 731.1 ± 0.5% | 10.693 | 14.401 | 29.739 | 15.790 | 21.339 |
| hex: shuffled/dickens-1m | 524290 | 15682.4 ± 0.2% | 1455.9 ± 0.6% | 1083.0 ± 0.2% | 499.9 ± 1.0% | 986.7 ± 0.6% | 731.7 ± 0.3% | 10.772 | 14.481 | 31.371 | 15.895 | 21.433 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 938.0 ± 0.4% | 925.3 ± 0.6% | 1015.3 ± 0.3% | 301.8 ± 0.5% | 665.6 ± 0.1% | 310.7 ± 1.8% | 1.014 | 0.924 | 3.108 | 1.409 | 3.019 |
| qlog records, JSON text sequence | 1467503 | 777.3 ± 0.9% | 814.8 ± 0.2% | 783.5 ± 1.7% | 243.9 ± 0.7% | 692.4 ± 0.5% | 249.0 ± 0.9% | 0.954 | 0.992 | 3.187 | 1.123 | 3.122 |
| string: silesia/dickens | 172528 | 5058.4 ± 0.3% | 1876.6 ± 0.1% | 2636.2 ± 0.6% | 361.0 ± 1.1% | 2865.1 ± 0.3% | 546.7 ± 2.4% | 2.696 | 1.919 | 14.013 | 1.766 | 9.253 |
| string: silesia/nci | 1075110 | 4303.8 ± 0.6% | 2233.2 ± 2.0% | 2981.9 ± 3.3% | 542.6 ± 0.9% | 2953.5 ± 1.8% | 599.9 ± 1.2% | 1.927 | 1.443 | 7.932 | 1.457 | 7.174 |
| string: silesia/reymont | 1075159 | 2964.1 ± 2.9% | 1818.4 ± 1.7% | 2063.7 ± 0.5% | 375.4 ± 0.7% | 2135.9 ± 0.6% | 535.1 ± 1.4% | 1.630 | 1.436 | 7.895 | 1.388 | 5.539 |
| string: silesia/samba | 97582 | 3502.5 ± 0.2% | 2025.7 ± 0.4% | 2613.7 ± 0.6% | 324.4 ± 0.2% | 1508.1 ± 0.5% | 426.9 ± 1.3% | 1.729 | 1.340 | 10.798 | 2.322 | 8.204 |
| string: silesia/webster | 1098490 | 3668.9 ± 0.5% | 1518.6 ± 0.3% | 2012.0 ± 1.1% | 359.1 ± 0.2% | 2158.5 ± 1.6% | 500.7 ± 2.6% | 2.416 | 1.823 | 10.216 | 1.700 | 7.327 |
| string: silesia/xml | 1090118 | 4805.6 ± 1.8% | 2354.8 ± 1.0% | 2520.7 ± 0.7% | 450.5 ± 0.9% | 2789.0 ± 1.2% | 564.2 ± 0.9% | 2.041 | 1.906 | 10.666 | 1.723 | 8.517 |
| string: canterbury/alice29.txt | 159425 | 4343.0 ± 1.1% | 1600.4 ± 0.2% | 2459.1 ± 0.9% | 342.1 ± 0.6% | 2505.8 ± 1.3% | 501.6 ± 1.2% | 2.714 | 1.766 | 12.697 | 1.733 | 8.659 |
| string: canterbury/asyoulik.txt | 132198 | 3510.6 ± 1.2% | 1458.0 ± 0.3% | 2246.5 ± 0.8% | 335.6 ± 0.5% | 2091.3 ± 0.3% | 457.5 ± 1.7% | 2.408 | 1.563 | 10.462 | 1.679 | 7.674 |
| string: canterbury/lcet10.txt | 441884 | 5098.8 ± 0.6% | 1852.9 ± 0.3% | 2334.3 ± 1.0% | 390.3 ± 0.5% | 2850.8 ± 1.0% | 531.1 ± 1.6% | 2.752 | 2.184 | 13.064 | 1.789 | 9.601 |
| string: canterbury/plrabn12.txt | 503330 | 4144.4 ± 0.4% | 1736.6 ± 0.2% | 2056.4 ± 0.7% | 360.4 ± 0.3% | 2483.2 ± 0.7% | 496.5 ± 1.8% | 2.386 | 2.015 | 11.498 | 1.669 | 8.347 |
| string: canterbury-large/E.coli | 1048578 | 11903.9 ± 0.3% | 3604.7 ± 0.6% | 3244.9 ± 0.4% | 927.0 ± 0.7% | 5957.0 ± 0.6% | 769.1 ± 0.8% | 3.302 | 3.668 | 12.841 | 1.998 | 15.478 |
| string: canterbury-large/bible.txt | 1055886 | 6875.4 ± 2.0% | 2939.3 ± 1.0% | 2830.4 ± 1.0% | 422.3 ± 2.9% | 3740.2 ± 1.1% | 618.9 ± 1.6% | 2.339 | 2.429 | 16.280 | 1.838 | 11.109 |
| string: canterbury-large/world192.txt | 1103121 | 3400.2 ± 0.3% | 1480.2 ± 0.3% | 2004.4 ± 0.3% | 352.8 ± 0.4% | 2112.4 ± 1.4% | 500.9 ± 0.8% | 2.297 | 1.696 | 9.638 | 1.610 | 6.788 |
| string: http/html-1m | 1058582 | 6237.9 ± 3.3% | 2737.6 ± 0.6% | 2684.6 ± 0.7% | 440.6 ± 0.6% | 3464.1 ± 0.8% | 595.1 ± 1.8% | 2.279 | 2.324 | 14.159 | 1.801 | 10.482 |
| string: http/json-1m | 1190272 | 2553.0 ± 0.5% | 877.1 ± 0.2% | 2248.3 ± 0.5% | 389.2 ± 0.3% | 1033.1 ± 0.7% | 442.7 ± 0.5% | 2.911 | 1.136 | 6.560 | 2.471 | 5.767 |
| string: http/js-1m | 1144362 | 2278.0 ± 0.5% | 1027.5 ± 0.3% | 1633.7 ± 0.4% | 320.7 ± 0.6% | 1509.4 ± 2.0% | 419.0 ± 0.3% | 2.217 | 1.394 | 7.104 | 1.509 | 5.437 |
| string: http/css-1m | 1097820 | 2651.3 ± 0.7% | 1675.6 ± 0.5% | 2221.1 ± 0.6% | 406.6 ± 1.0% | 1913.6 ± 0.8% | 489.3 ± 0.6% | 1.582 | 1.194 | 6.520 | 1.386 | 5.419 |
| string: dickens as Cyrillic and CJK | 1883069 | 3071.7 ± 0.3% | 1684.9 ± 0.4% | 893.1 ± 0.3% | 351.2 ± 0.2% | 666.2 ± 0.4% | 158.8 ± 1.8% | 1.823 | 3.439 | 8.746 | 4.611 | 19.344 |
| string: dickens as Cyrillic and CJK, as \u escapes | 5075485 | 1330.7 ± 0.2% | 980.5 ± 0.2% | 1208.4 ± 0.7% | 214.0 ± 0.4% | 471.2 ± 0.2% | 257.1 ± 3.3% | 1.357 | 1.101 | 6.218 | 2.824 | 5.177 |
| hex: silesia/dickens | 524290 | 12015.2 ± 0.0% | 3620.9 ± 0.1% | 3292.5 ± 0.7% | 503.2 ± 0.2% | 6109.8 ± 1.4% | 781.4 ± 2.4% | 3.318 | 3.649 | 23.878 | 1.967 | 15.377 |
| hex: silesia/mozilla | 524290 | 12011.0 ± 0.1% | 3620.8 ± 0.2% | 3291.6 ± 0.4% | 446.5 ± 1.7% | 6122.5 ± 1.3% | 781.7 ± 0.9% | 3.317 | 3.649 | 26.897 | 1.962 | 15.366 |
| hex: silesia/mr | 524290 | 12000.6 ± 0.4% | 3617.3 ± 0.3% | 3288.4 ± 0.4% | 572.4 ± 0.6% | 6145.7 ± 1.6% | 781.2 ± 0.5% | 3.318 | 3.649 | 20.966 | 1.953 | 15.362 |
| hex: silesia/nci | 524290 | 11983.9 ± 0.1% | 3618.7 ± 0.2% | 3281.5 ± 0.7% | 618.9 ± 1.6% | 6093.2 ± 1.8% | 781.2 ± 0.3% | 3.312 | 3.652 | 19.364 | 1.967 | 15.341 |
| hex: silesia/ooffice | 524290 | 11957.4 ± 0.1% | 3618.7 ± 0.1% | 3287.2 ± 0.3% | 399.2 ± 0.8% | 6084.6 ± 1.5% | 781.5 ± 0.3% | 3.304 | 3.638 | 29.954 | 1.965 | 15.301 |
| hex: silesia/osdb | 524290 | 11954.4 ± 0.2% | 3618.2 ± 0.3% | 3281.5 ± 0.6% | 475.3 ± 1.5% | 5995.7 ± 0.9% | 780.2 ± 0.8% | 3.304 | 3.643 | 25.154 | 1.994 | 15.323 |
| hex: silesia/reymont | 524290 | 11915.4 ± 0.3% | 3616.1 ± 0.2% | 3281.2 ± 0.8% | 507.7 ± 1.1% | 6103.5 ± 1.3% | 781.5 ± 1.7% | 3.295 | 3.631 | 23.469 | 1.952 | 15.246 |
| hex: silesia/samba | 524290 | 12001.3 ± 0.2% | 3619.8 ± 0.2% | 3287.9 ± 0.3% | 405.0 ± 1.0% | 6110.9 ± 1.4% | 781.3 ± 0.4% | 3.315 | 3.650 | 29.633 | 1.964 | 15.361 |
| hex: silesia/sao | 524290 | 12017.2 ± 0.1% | 3620.0 ± 0.6% | 3293.0 ± 0.5% | 345.1 ± 0.9% | 6099.0 ± 1.5% | 781.3 ± 0.6% | 3.320 | 3.649 | 34.818 | 1.970 | 15.381 |
| hex: silesia/webster | 524290 | 11994.9 ± 0.3% | 3614.1 ± 0.5% | 3280.7 ± 1.6% | 470.5 ± 0.2% | 6159.2 ± 1.0% | 782.3 ± 0.4% | 3.319 | 3.656 | 25.493 | 1.947 | 15.332 |
| hex: silesia/x-ray | 524290 | 11986.3 ± 0.1% | 3619.9 ± 0.2% | 3287.8 ± 0.3% | 476.3 ± 0.5% | 6054.9 ± 2.0% | 782.5 ± 0.5% | 3.311 | 3.646 | 25.164 | 1.980 | 15.318 |
| hex: silesia/xml | 524290 | 11986.9 ± 0.2% | 3620.6 ± 0.2% | 3274.3 ± 0.1% | 514.1 ± 0.7% | 6034.4 ± 0.5% | 780.2 ± 0.2% | 3.311 | 3.661 | 23.317 | 1.986 | 15.363 |
| hex: canterbury/alice29.txt | 304180 | 12011.8 ± 0.1% | 3632.2 ± 0.1% | 3368.7 ± 0.1% | 503.9 ± 2.5% | 6110.3 ± 1.0% | 781.3 ± 3.2% | 3.307 | 3.566 | 23.836 | 1.966 | 15.375 |
| hex: canterbury/asyoulik.txt | 250360 | 11999.6 ± 0.1% | 3642.5 ± 0.1% | 3358.0 ± 0.2% | 493.0 ± 1.2% | 6072.9 ± 1.3% | 778.4 ± 0.4% | 3.294 | 3.573 | 24.338 | 1.976 | 15.416 |
| hex: canterbury/cp.html | 49208 | 11925.6 ± 0.0% | 3639.8 ± 0.1% | 3277.2 ± 0.4% | 467.1 ± 1.9% | 6274.1 ± 1.0% | 765.9 ± 0.8% | 3.276 | 3.639 | 25.533 | 1.901 | 15.572 |
| hex: canterbury/fields.c | 22302 | 11782.0 ± 0.0% | 3626.5 ± 0.1% | 3394.7 ± 0.3% | 492.8 ± 3.8% | 6255.0 ± 0.4% | 758.5 ± 1.8% | 3.249 | 3.471 | 23.907 | 1.884 | 15.533 |
| hex: canterbury/grammar.lsp | 7444 | 11249.1 ± 0.2% | 3600.8 ± 0.1% | 3346.6 ± 0.4% | 542.7 ± 2.9% | 6184.9 ± 0.7% | 727.6 ± 1.9% | 3.124 | 3.361 | 20.728 | 1.819 | 15.460 |
| hex: canterbury/kennedy.xls | 524290 | 11974.7 ± 0.1% | 3605.7 ± 0.6% | 3287.5 ± 0.8% | 654.3 ± 9.0% | 6034.7 ± 1.9% | 754.9 ± 5.4% | 3.321 | 3.643 | 18.302 | 1.984 | 15.863 |
| hex: canterbury/lcet10.txt | 524290 | 12006.6 ± 0.2% | 3610.7 ± 1.3% | 3289.3 ± 0.3% | 511.9 ± 1.5% | 6048.4 ± 1.1% | 762.3 ± 1.0% | 3.325 | 3.650 | 23.454 | 1.985 | 15.751 |
| hex: canterbury/plrabn12.txt | 524290 | 11985.3 ± 0.1% | 3608.9 ± 0.3% | 3287.6 ± 0.2% | 517.2 ± 2.8% | 6082.9 ± 0.8% | 761.7 ± 0.8% | 3.321 | 3.646 | 23.173 | 1.970 | 15.736 |
| hex: canterbury/ptt5 | 524290 | 12003.0 ± 0.1% | 3612.3 ± 0.4% | 3275.6 ± 0.3% | 559.5 ± 1.2% | 6129.9 ± 1.7% | 760.6 ± 0.7% | 3.323 | 3.664 | 21.451 | 1.958 | 15.782 |
| hex: canterbury/sum | 76482 | 11910.6 ± 0.1% | 3632.9 ± 0.2% | 3354.3 ± 0.4% | 503.5 ± 1.7% | 6164.2 ± 0.5% | 769.9 ± 0.9% | 3.279 | 3.551 | 23.658 | 1.932 | 15.471 |
| hex: canterbury/xargs.1 | 8456 | 11353.1 ± 0.0% | 3602.4 ± 0.0% | 3356.9 ± 0.2% | 498.7 ± 2.6% | 6150.2 ± 0.4% | 751.6 ± 0.9% | 3.152 | 3.382 | 22.766 | 1.846 | 15.105 |
| hex: canterbury-large/E.coli | 524290 | 12015.8 ± 0.1% | 3606.3 ± 0.1% | 3284.6 ± 0.1% | 689.3 ± 0.0% | 6065.5 ± 0.9% | 759.7 ± 4.0% | 3.332 | 3.658 | 17.432 | 1.981 | 15.817 |
| hex: canterbury-large/bible.txt | 524290 | 11981.1 ± 0.6% | 3607.1 ± 0.2% | 3281.2 ± 0.3% | 515.2 ± 1.4% | 6123.1 ± 2.1% | 758.3 ± 1.4% | 3.322 | 3.651 | 23.258 | 1.957 | 15.801 |
| hex: canterbury-large/world192.txt | 524290 | 11974.9 ± 0.2% | 3607.8 ± 0.3% | 3286.0 ± 0.4% | 494.5 ± 0.8% | 6069.4 ± 0.7% | 755.8 ± 1.6% | 3.319 | 3.644 | 24.216 | 1.973 | 15.843 |
| hex: http/html-1kx1024 | 2099200 | 8659.0 ± 2.6% | 3455.7 ± 0.3% | 2831.0 ± 0.5% | 473.8 ± 1.0% | 5033.3 ± 1.8% | 640.5 ± 3.0% | 2.506 | 3.059 | 18.277 | 1.720 | 13.519 |
| hex: http/html-16kx64 | 2097280 | 11750.9 ± 0.1% | 3607.9 ± 0.4% | 3254.8 ± 0.4% | 465.7 ± 1.5% | 6044.0 ± 0.6% | 752.2 ± 1.7% | 3.257 | 3.610 | 25.233 | 1.944 | 15.622 |
| hex: http/html-1m | 524290 | 12008.4 ± 0.1% | 3611.9 ± 0.6% | 3281.3 ± 0.7% | 503.0 ± 2.1% | 6134.8 ± 0.7% | 763.5 ± 3.2% | 3.325 | 3.660 | 23.872 | 1.957 | 15.729 |
| hex: http/json-1kx1024 | 2099200 | 8629.8 ± 4.2% | 3455.5 ± 0.3% | 2829.9 ± 0.3% | 564.8 ± 3.0% | 5046.9 ± 1.4% | 638.1 ± 4.8% | 2.497 | 3.050 | 15.279 | 1.710 | 13.524 |
| hex: http/json-16kx64 | 2097280 | 11756.2 ± 0.2% | 3606.2 ± 0.2% | 3253.3 ± 0.2% | 573.3 ± 0.8% | 6030.5 ± 0.3% | 751.0 ± 3.6% | 3.260 | 3.614 | 20.507 | 1.949 | 15.655 |
| hex: http/json-1m | 524290 | 11991.9 ± 0.2% | 3612.5 ± 0.3% | 3292.5 ± 0.2% | 592.4 ± 0.9% | 6083.7 ± 1.3% | 761.6 ± 2.9% | 3.320 | 3.642 | 20.243 | 1.971 | 15.746 |
| hex: http/js-1kx1024 | 2099200 | 8619.4 ± 4.8% | 3461.4 ± 0.3% | 2831.0 ± 0.7% | 480.0 ± 0.3% | 5032.7 ± 1.0% | 635.2 ± 2.3% | 2.490 | 3.045 | 17.956 | 1.713 | 13.570 |
| hex: http/js-16kx64 | 2097280 | 11750.3 ± 0.1% | 3611.0 ± 0.1% | 3257.2 ± 0.3% | 478.4 ± 0.8% | 6016.3 ± 0.9% | 749.9 ± 2.5% | 3.254 | 3.607 | 24.560 | 1.953 | 15.669 |
| hex: http/js-1m | 524290 | 11978.6 ± 0.1% | 3610.6 ± 0.2% | 3289.7 ± 0.2% | 503.9 ± 1.2% | 6029.9 ± 1.6% | 761.9 ± 2.2% | 3.318 | 3.641 | 23.771 | 1.987 | 15.722 |
| hex: http/css-1kx1024 | 2099200 | 8638.3 ± 3.3% | 3459.9 ± 0.2% | 2825.7 ± 0.4% | 487.8 ± 1.0% | 5042.6 ± 0.5% | 636.1 ± 3.0% | 2.497 | 3.057 | 17.708 | 1.713 | 13.581 |
| hex: http/css-16kx64 | 2097280 | 11742.7 ± 0.6% | 3610.9 ± 0.2% | 3266.6 ± 0.2% | 492.0 ± 0.7% | 6012.9 ± 0.7% | 749.2 ± 3.7% | 3.252 | 3.595 | 23.869 | 1.953 | 15.674 |
| hex: http/css-1m | 524290 | 12012.5 ± 0.0% | 3603.5 ± 0.3% | 3280.3 ± 0.5% | 495.2 ± 0.9% | 6118.2 ± 1.4% | 763.0 ± 2.7% | 3.334 | 3.662 | 24.260 | 1.963 | 15.744 |
| hex: shuffled/dickens-1m | 524290 | 11982.6 ± 0.1% | 3603.9 ± 0.4% | 3284.0 ± 0.7% | 511.8 ± 0.5% | 6104.9 ± 0.5% | 763.6 ± 0.2% | 3.325 | 3.649 | 23.415 | 1.963 | 15.692 |

## TextReader.next_items against the baselines

stdx's decoder a slice of tokens a call through `TextReader.next_items`, as a caller that reads a text's values in a loop calls it (decision 79). Octets are the text's. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1013.1 ± 0.2% | 925.3 ± 0.6% | 1015.3 ± 0.3% | 301.8 ± 0.5% | 665.6 ± 0.1% | 310.7 ± 1.8% | 1.095 | 0.998 | 3.357 | 1.522 | 3.261 |
| qlog records, JSON text sequence | 1467503 | 838.4 ± 1.5% | 814.8 ± 0.2% | 783.5 ± 1.7% | 243.9 ± 0.7% | 692.4 ± 0.5% | 249.0 ± 0.9% | 1.029 | 1.070 | 3.438 | 1.211 | 3.367 |
| string: silesia/dickens | 172528 | 5059.1 ± 0.4% | 1876.6 ± 0.1% | 2636.2 ± 0.6% | 361.0 ± 1.1% | 2865.1 ± 0.3% | 546.7 ± 2.4% | 2.696 | 1.919 | 14.015 | 1.766 | 9.255 |
| string: silesia/nci | 1075110 | 4308.3 ± 2.3% | 2233.2 ± 2.0% | 2981.9 ± 3.3% | 542.6 ± 0.9% | 2953.5 ± 1.8% | 599.9 ± 1.2% | 1.929 | 1.445 | 7.940 | 1.459 | 7.182 |
| string: silesia/reymont | 1075159 | 2972.1 ± 2.9% | 1818.4 ± 1.7% | 2063.7 ± 0.5% | 375.4 ± 0.7% | 2135.9 ± 0.6% | 535.1 ± 1.4% | 1.635 | 1.440 | 7.916 | 1.391 | 5.554 |
| string: silesia/samba | 97582 | 3513.3 ± 0.2% | 2025.7 ± 0.4% | 2613.7 ± 0.6% | 324.4 ± 0.2% | 1508.1 ± 0.5% | 426.9 ± 1.3% | 1.734 | 1.344 | 10.831 | 2.330 | 8.229 |
| string: silesia/webster | 1098490 | 3669.6 ± 0.2% | 1518.6 ± 0.3% | 2012.0 ± 1.1% | 359.1 ± 0.2% | 2158.5 ± 1.6% | 500.7 ± 2.6% | 2.416 | 1.824 | 10.218 | 1.700 | 7.329 |
| string: silesia/xml | 1090118 | 4812.0 ± 1.1% | 2354.8 ± 1.0% | 2520.7 ± 0.7% | 450.5 ± 0.9% | 2789.0 ± 1.2% | 564.2 ± 0.9% | 2.044 | 1.909 | 10.680 | 1.725 | 8.529 |
| string: canterbury/alice29.txt | 159425 | 4352.0 ± 1.1% | 1600.4 ± 0.2% | 2459.1 ± 0.9% | 342.1 ± 0.6% | 2505.8 ± 1.3% | 501.6 ± 1.2% | 2.719 | 1.770 | 12.723 | 1.737 | 8.677 |
| string: canterbury/asyoulik.txt | 132198 | 3514.3 ± 1.0% | 1458.0 ± 0.3% | 2246.5 ± 0.8% | 335.6 ± 0.5% | 2091.3 ± 0.3% | 457.5 ± 1.7% | 2.410 | 1.564 | 10.473 | 1.680 | 7.682 |
| string: canterbury/lcet10.txt | 441884 | 5099.2 ± 0.8% | 1852.9 ± 0.3% | 2334.3 ± 1.0% | 390.3 ± 0.5% | 2850.8 ± 1.0% | 531.1 ± 1.6% | 2.752 | 2.185 | 13.065 | 1.789 | 9.602 |
| string: canterbury/plrabn12.txt | 503330 | 4146.5 ± 0.6% | 1736.6 ± 0.2% | 2056.4 ± 0.7% | 360.4 ± 0.3% | 2483.2 ± 0.7% | 496.5 ± 1.8% | 2.388 | 2.016 | 11.504 | 1.670 | 8.351 |
| string: canterbury-large/E.coli | 1048578 | 11900.6 ± 0.5% | 3604.7 ± 0.6% | 3244.9 ± 0.4% | 927.0 ± 0.7% | 5957.0 ± 0.6% | 769.1 ± 0.8% | 3.301 | 3.667 | 12.837 | 1.998 | 15.474 |
| string: canterbury-large/bible.txt | 1055886 | 6899.8 ± 2.1% | 2939.3 ± 1.0% | 2830.4 ± 1.0% | 422.3 ± 2.9% | 3740.2 ± 1.1% | 618.9 ± 1.6% | 2.347 | 2.438 | 16.338 | 1.845 | 11.149 |
| string: canterbury-large/world192.txt | 1103121 | 3396.6 ± 0.7% | 1480.2 ± 0.3% | 2004.4 ± 0.3% | 352.8 ± 0.4% | 2112.4 ± 1.4% | 500.9 ± 0.8% | 2.295 | 1.695 | 9.628 | 1.608 | 6.780 |
| string: http/html-1m | 1058582 | 6274.0 ± 3.8% | 2737.6 ± 0.6% | 2684.6 ± 0.7% | 440.6 ± 0.6% | 3464.1 ± 0.8% | 595.1 ± 1.8% | 2.292 | 2.337 | 14.241 | 1.811 | 10.542 |
| string: http/json-1m | 1190272 | 2551.6 ± 0.7% | 877.1 ± 0.2% | 2248.3 ± 0.5% | 389.2 ± 0.3% | 1033.1 ± 0.7% | 442.7 ± 0.5% | 2.909 | 1.135 | 6.557 | 2.470 | 5.764 |
| string: http/js-1m | 1144362 | 2277.7 ± 0.7% | 1027.5 ± 0.3% | 1633.7 ± 0.4% | 320.7 ± 0.6% | 1509.4 ± 2.0% | 419.0 ± 0.3% | 2.217 | 1.394 | 7.103 | 1.509 | 5.436 |
| string: http/css-1m | 1097820 | 2653.0 ± 0.5% | 1675.6 ± 0.5% | 2221.1 ± 0.6% | 406.6 ± 1.0% | 1913.6 ± 0.8% | 489.3 ± 0.6% | 1.583 | 1.194 | 6.525 | 1.386 | 5.422 |
| string: dickens as Cyrillic and CJK | 1883069 | 3072.0 ± 0.6% | 1684.9 ± 0.4% | 893.1 ± 0.3% | 351.2 ± 0.2% | 666.2 ± 0.4% | 158.8 ± 1.8% | 1.823 | 3.440 | 8.747 | 4.611 | 19.346 |
| string: dickens as Cyrillic and CJK, as \u escapes | 5075485 | 1331.1 ± 0.2% | 980.5 ± 0.2% | 1208.4 ± 0.7% | 214.0 ± 0.4% | 471.2 ± 0.2% | 257.1 ± 3.3% | 1.358 | 1.102 | 6.220 | 2.825 | 5.178 |
| hex: silesia/dickens | 524290 | 12010.4 ± 0.1% | 3620.9 ± 0.1% | 3292.5 ± 0.7% | 503.2 ± 0.2% | 6109.8 ± 1.4% | 781.4 ± 2.4% | 3.317 | 3.648 | 23.868 | 1.966 | 15.371 |
| hex: silesia/mozilla | 524290 | 12017.2 ± 0.1% | 3620.8 ± 0.2% | 3291.6 ± 0.4% | 446.5 ± 1.7% | 6122.5 ± 1.3% | 781.7 ± 0.9% | 3.319 | 3.651 | 26.911 | 1.963 | 15.374 |
| hex: silesia/mr | 524290 | 12004.0 ± 0.1% | 3617.3 ± 0.3% | 3288.4 ± 0.4% | 572.4 ± 0.6% | 6145.7 ± 1.6% | 781.2 ± 0.5% | 3.319 | 3.650 | 20.972 | 1.953 | 15.366 |
| hex: silesia/nci | 524290 | 11987.2 ± 0.1% | 3618.7 ± 0.2% | 3281.5 ± 0.7% | 618.9 ± 1.6% | 6093.2 ± 1.8% | 781.2 ± 0.3% | 3.313 | 3.653 | 19.370 | 1.967 | 15.345 |
| hex: silesia/ooffice | 524290 | 11913.7 ± 0.3% | 3618.7 ± 0.1% | 3287.2 ± 0.3% | 399.2 ± 0.8% | 6084.6 ± 1.5% | 781.5 ± 0.3% | 3.292 | 3.624 | 29.844 | 1.958 | 15.245 |
| hex: silesia/osdb | 524290 | 11935.2 ± 0.1% | 3618.2 ± 0.3% | 3281.5 ± 0.6% | 475.3 ± 1.5% | 5995.7 ± 0.9% | 780.2 ± 0.8% | 3.299 | 3.637 | 25.113 | 1.991 | 15.298 |
| hex: silesia/reymont | 524290 | 11997.4 ± 0.4% | 3616.1 ± 0.2% | 3281.2 ± 0.8% | 507.7 ± 1.1% | 6103.5 ± 1.3% | 781.5 ± 1.7% | 3.318 | 3.656 | 23.631 | 1.966 | 15.351 |
| hex: silesia/samba | 524290 | 12006.8 ± 0.1% | 3619.8 ± 0.2% | 3287.9 ± 0.3% | 405.0 ± 1.0% | 6110.9 ± 1.4% | 781.3 ± 0.4% | 3.317 | 3.652 | 29.647 | 1.965 | 15.368 |
| hex: silesia/sao | 524290 | 11997.2 ± 0.1% | 3620.0 ± 0.6% | 3293.0 ± 0.5% | 345.1 ± 0.9% | 6099.0 ± 1.5% | 781.3 ± 0.6% | 3.314 | 3.643 | 34.760 | 1.967 | 15.355 |
| hex: silesia/webster | 524290 | 12007.1 ± 0.1% | 3614.1 ± 0.5% | 3280.7 ± 1.6% | 470.5 ± 0.2% | 6159.2 ± 1.0% | 782.3 ± 0.4% | 3.322 | 3.660 | 25.519 | 1.949 | 15.348 |
| hex: silesia/x-ray | 524290 | 11968.3 ± 0.1% | 3619.9 ± 0.2% | 3287.8 ± 0.3% | 476.3 ± 0.5% | 6054.9 ± 2.0% | 782.5 ± 0.5% | 3.306 | 3.640 | 25.126 | 1.977 | 15.295 |
| hex: silesia/xml | 524290 | 11984.7 ± 0.2% | 3620.6 ± 0.2% | 3274.3 ± 0.1% | 514.1 ± 0.7% | 6034.4 ± 0.5% | 780.2 ± 0.2% | 3.310 | 3.660 | 23.313 | 1.986 | 15.361 |
| hex: canterbury/alice29.txt | 304180 | 12011.2 ± 0.3% | 3632.2 ± 0.1% | 3368.7 ± 0.1% | 503.9 ± 2.5% | 6110.3 ± 1.0% | 781.3 ± 3.2% | 3.307 | 3.566 | 23.834 | 1.966 | 15.374 |
| hex: canterbury/asyoulik.txt | 250360 | 12004.3 ± 0.1% | 3642.5 ± 0.1% | 3358.0 ± 0.2% | 493.0 ± 1.2% | 6072.9 ± 1.3% | 778.4 ± 0.4% | 3.296 | 3.575 | 24.347 | 1.977 | 15.422 |
| hex: canterbury/cp.html | 49208 | 11926.7 ± 0.0% | 3639.8 ± 0.1% | 3277.2 ± 0.4% | 467.1 ± 1.9% | 6274.1 ± 1.0% | 765.9 ± 0.8% | 3.277 | 3.639 | 25.536 | 1.901 | 15.573 |
| hex: canterbury/fields.c | 22302 | 11786.0 ± 0.0% | 3626.5 ± 0.1% | 3394.7 ± 0.3% | 492.8 ± 3.8% | 6255.0 ± 0.4% | 758.5 ± 1.8% | 3.250 | 3.472 | 23.916 | 1.884 | 15.539 |
| hex: canterbury/grammar.lsp | 7444 | 11333.9 ± 0.0% | 3600.8 ± 0.1% | 3346.6 ± 0.4% | 542.7 ± 2.9% | 6184.9 ± 0.7% | 727.6 ± 1.9% | 3.148 | 3.387 | 20.885 | 1.832 | 15.576 |
| hex: canterbury/kennedy.xls | 524290 | 11977.8 ± 0.1% | 3605.7 ± 0.6% | 3287.5 ± 0.8% | 654.3 ± 9.0% | 6034.7 ± 1.9% | 754.9 ± 5.4% | 3.322 | 3.643 | 18.307 | 1.985 | 15.867 |
| hex: canterbury/lcet10.txt | 524290 | 12003.3 ± 0.2% | 3610.7 ± 1.3% | 3289.3 ± 0.3% | 511.9 ± 1.5% | 6048.4 ± 1.1% | 762.3 ± 1.0% | 3.324 | 3.649 | 23.448 | 1.985 | 15.747 |
| hex: canterbury/plrabn12.txt | 524290 | 11985.2 ± 0.2% | 3608.9 ± 0.3% | 3287.6 ± 0.2% | 517.2 ± 2.8% | 6082.9 ± 0.8% | 761.7 ± 0.8% | 3.321 | 3.646 | 23.173 | 1.970 | 15.736 |
| hex: canterbury/ptt5 | 524290 | 12010.6 ± 0.1% | 3612.3 ± 0.4% | 3275.6 ± 0.3% | 559.5 ± 1.2% | 6129.9 ± 1.7% | 760.6 ± 0.7% | 3.325 | 3.667 | 21.465 | 1.959 | 15.792 |
| hex: canterbury/sum | 76482 | 11910.4 ± 0.1% | 3632.9 ± 0.2% | 3354.3 ± 0.4% | 503.5 ± 1.7% | 6164.2 ± 0.5% | 769.9 ± 0.9% | 3.278 | 3.551 | 23.657 | 1.932 | 15.470 |
| hex: canterbury/xargs.1 | 8456 | 11358.4 ± 0.0% | 3602.4 ± 0.0% | 3356.9 ± 0.2% | 498.7 ± 2.6% | 6150.2 ± 0.4% | 751.6 ± 0.9% | 3.153 | 3.384 | 22.776 | 1.847 | 15.112 |
| hex: canterbury-large/E.coli | 524290 | 12018.7 ± 0.1% | 3606.3 ± 0.1% | 3284.6 ± 0.1% | 689.3 ± 0.0% | 6065.5 ± 0.9% | 759.7 ± 4.0% | 3.333 | 3.659 | 17.437 | 1.981 | 15.821 |
| hex: canterbury-large/bible.txt | 524290 | 12002.6 ± 0.3% | 3607.1 ± 0.2% | 3281.2 ± 0.3% | 515.2 ± 1.4% | 6123.1 ± 2.1% | 758.3 ± 1.4% | 3.327 | 3.658 | 23.299 | 1.960 | 15.829 |
| hex: canterbury-large/world192.txt | 524290 | 11972.3 ± 0.0% | 3607.8 ± 0.3% | 3286.0 ± 0.4% | 494.5 ± 0.8% | 6069.4 ± 0.7% | 755.8 ± 1.6% | 3.318 | 3.643 | 24.210 | 1.973 | 15.840 |
| hex: http/html-1kx1024 | 2099200 | 8700.4 ± 2.9% | 3455.7 ± 0.3% | 2831.0 ± 0.5% | 473.8 ± 1.0% | 5033.3 ± 1.8% | 640.5 ± 3.0% | 2.518 | 3.073 | 18.364 | 1.729 | 13.584 |
| hex: http/html-16kx64 | 2097280 | 11750.4 ± 0.2% | 3607.9 ± 0.4% | 3254.8 ± 0.4% | 465.7 ± 1.5% | 6044.0 ± 0.6% | 752.2 ± 1.7% | 3.257 | 3.610 | 25.231 | 1.944 | 15.622 |
| hex: http/html-1m | 524290 | 11988.3 ± 0.2% | 3611.9 ± 0.6% | 3281.3 ± 0.7% | 503.0 ± 2.1% | 6134.8 ± 0.7% | 763.5 ± 3.2% | 3.319 | 3.654 | 23.832 | 1.954 | 15.702 |
| hex: http/json-1kx1024 | 2099200 | 8714.6 ± 4.2% | 3455.5 ± 0.3% | 2829.9 ± 0.3% | 564.8 ± 3.0% | 5046.9 ± 1.4% | 638.1 ± 4.8% | 2.522 | 3.079 | 15.429 | 1.727 | 13.657 |
| hex: http/json-16kx64 | 2097280 | 11749.0 ± 0.3% | 3606.2 ± 0.2% | 3253.3 ± 0.2% | 573.3 ± 0.8% | 6030.5 ± 0.3% | 751.0 ± 3.6% | 3.258 | 3.611 | 20.494 | 1.948 | 15.645 |
| hex: http/json-1m | 524290 | 11998.4 ± 0.1% | 3612.5 ± 0.3% | 3292.5 ± 0.2% | 592.4 ± 0.9% | 6083.7 ± 1.3% | 761.6 ± 2.9% | 3.321 | 3.644 | 20.254 | 1.972 | 15.755 |
| hex: http/js-1kx1024 | 2099200 | 8731.9 ± 4.8% | 3461.4 ± 0.3% | 2831.0 ± 0.7% | 480.0 ± 0.3% | 5032.7 ± 1.0% | 635.2 ± 2.3% | 2.523 | 3.084 | 18.190 | 1.735 | 13.747 |
| hex: http/js-16kx64 | 2097280 | 11756.6 ± 0.2% | 3611.0 ± 0.1% | 3257.2 ± 0.3% | 478.4 ± 0.8% | 6016.3 ± 0.9% | 749.9 ± 2.5% | 3.256 | 3.609 | 24.574 | 1.954 | 15.677 |
| hex: http/js-1m | 524290 | 11979.5 ± 0.1% | 3610.6 ± 0.2% | 3289.7 ± 0.2% | 503.9 ± 1.2% | 6029.9 ± 1.6% | 761.9 ± 2.2% | 3.318 | 3.641 | 23.773 | 1.987 | 15.723 |
| hex: http/css-1kx1024 | 2099200 | 8679.3 ± 3.3% | 3459.9 ± 0.2% | 2825.7 ± 0.4% | 487.8 ± 1.0% | 5042.6 ± 0.5% | 636.1 ± 3.0% | 2.508 | 3.072 | 17.792 | 1.721 | 13.645 |
| hex: http/css-16kx64 | 2097280 | 11745.1 ± 0.5% | 3610.9 ± 0.2% | 3266.6 ± 0.2% | 492.0 ± 0.7% | 6012.9 ± 0.7% | 749.2 ± 3.7% | 3.253 | 3.596 | 23.874 | 1.953 | 15.677 |
| hex: http/css-1m | 524290 | 12017.3 ± 0.0% | 3603.5 ± 0.3% | 3280.3 ± 0.5% | 495.2 ± 0.9% | 6118.2 ± 1.4% | 763.0 ± 2.7% | 3.335 | 3.664 | 24.269 | 1.964 | 15.750 |
| hex: shuffled/dickens-1m | 524290 | 11994.6 ± 0.1% | 3603.9 ± 0.4% | 3284.0 ± 0.7% | 511.8 ± 0.5% | 6104.9 ± 0.5% | 763.6 ± 0.2% | 3.328 | 3.652 | 23.438 | 1.965 | 15.707 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1354.8 ± 0.2% | 1249.2 ± 0.4% | 1037.7 ± 0.8% | 408.6 ± 0.3% | 447.8 ± 0.2% | 415.3 ± 0.8% | 1.085 | 1.306 | 3.316 | 3.026 | 3.262 |
| qlog records, JSON text sequence | 1467503 | 1052.8 ± 0.4% | 1066.0 ± 0.3% | 781.3 ± 0.7% | 378.0 ± 0.7% | 479.1 ± 0.9% | 278.0 ± 0.9% | 0.988 | 1.348 | 2.785 | 2.197 | 3.787 |
| string: silesia/dickens | 172528 | 6878.4 ± 0.3% | 2802.7 ± 0.7% | 2927.9 ± 0.7% | 429.9 ± 0.6% | 1593.8 ± 0.3% | 1008.3 ± 0.4% | 2.454 | 2.349 | 16.000 | 4.316 | 6.821 |
| string: silesia/nci | 1075110 | 7322.2 ± 0.6% | 3407.9 ± 0.8% | 3097.3 ± 0.7% | 791.6 ± 9.3% | 1863.5 ± 0.3% | 1107.7 ± 0.6% | 2.149 | 2.364 | 9.250 | 3.929 | 6.610 |
| string: silesia/reymont | 1075159 | 3339.5 ± 1.5% | 1964.8 ± 0.5% | 2061.5 ± 0.4% | 448.3 ± 0.7% | 1507.7 ± 1.1% | 949.1 ± 0.1% | 1.700 | 1.620 | 7.449 | 2.215 | 3.518 |
| string: silesia/samba | 97582 | 4211.7 ± 0.6% | 2111.6 ± 0.8% | 3452.6 ± 0.3% | 355.5 ± 0.7% | 1486.2 ± 0.2% | 1052.9 ± 0.4% | 1.995 | 1.220 | 11.848 | 2.834 | 4.000 |
| string: silesia/webster | 1098490 | 4076.0 ± 1.4% | 1867.1 ± 0.6% | 2056.8 ± 0.4% | 442.4 ± 0.9% | 1400.4 ± 0.2% | 645.9 ± 0.4% | 2.183 | 1.982 | 9.214 | 2.911 | 6.311 |
| string: silesia/xml | 1090118 | 6146.8 ± 0.5% | 2857.0 ± 1.0% | 2646.6 ± 0.3% | 610.0 ± 0.6% | 1754.2 ± 0.3% | 920.7 ± 0.7% | 2.152 | 2.322 | 10.077 | 3.504 | 6.676 |
| string: canterbury/alice29.txt | 159425 | 6448.9 ± 0.9% | 2198.1 ± 0.3% | 2750.1 ± 0.8% | 408.6 ± 0.4% | 1471.3 ± 0.1% | 955.3 ± 0.6% | 2.934 | 2.345 | 15.785 | 4.383 | 6.751 |
| string: canterbury/asyoulik.txt | 132198 | 5653.6 ± 0.9% | 1711.4 ± 0.3% | 2371.9 ± 1.2% | 402.8 ± 0.3% | 1333.7 ± 0.4% | 885.0 ± 0.3% | 3.303 | 2.384 | 14.036 | 4.239 | 6.388 |
| string: canterbury/lcet10.txt | 441884 | 6251.4 ± 0.4% | 2562.7 ± 0.4% | 2479.9 ± 2.7% | 468.6 ± 0.7% | 1554.2 ± 0.4% | 982.5 ± 0.5% | 2.439 | 2.521 | 13.341 | 4.022 | 6.362 |
| string: canterbury/plrabn12.txt | 503330 | 5724.9 ± 0.4% | 2058.4 ± 0.3% | 2074.1 ± 0.5% | 423.2 ± 0.7% | 1391.5 ± 0.2% | 929.5 ± 0.9% | 2.781 | 2.760 | 13.527 | 4.114 | 6.159 |
| string: canterbury-large/E.coli | 1048578 | 19211.6 ± 1.2% | 9734.5 ± 1.1% | 3784.6 ± 0.7% | 1472.1 ± 0.9% | 2360.2 ± 0.2% | 1193.5 ± 0.5% | 1.974 | 5.076 | 13.051 | 8.140 | 16.097 |
| string: canterbury-large/bible.txt | 1055886 | 6802.5 ± 0.5% | 4128.2 ± 1.2% | 3024.8 ± 1.7% | 500.8 ± 0.9% | 1991.1 ± 0.5% | 1122.4 ± 0.3% | 1.648 | 2.249 | 13.584 | 3.416 | 6.061 |
| string: canterbury-large/world192.txt | 1103121 | 4054.3 ± 0.5% | 1648.4 ± 0.9% | 1998.9 ± 0.7% | 449.4 ± 0.6% | 1373.6 ± 0.3% | 908.2 ± 0.9% | 2.460 | 2.028 | 9.021 | 2.952 | 4.464 |
| string: http/html-1m | 1058582 | 6750.5 ± 0.5% | 3938.9 ± 0.5% | 3034.7 ± 0.4% | 499.7 ± 0.8% | 1927.7 ± 0.6% | 803.9 ± 0.6% | 1.714 | 2.224 | 13.508 | 3.502 | 8.398 |
| string: http/json-1m | 1190272 | 3168.0 ± 0.1% | 1354.0 ± 0.3% | 1551.4 ± 0.5% | 442.6 ± 0.4% | 1072.0 ± 0.2% | 765.4 ± 1.1% | 2.340 | 2.042 | 7.158 | 2.955 | 4.139 |
| string: http/js-1m | 1144362 | 2773.4 ± 0.4% | 1176.7 ± 0.5% | 1629.1 ± 0.8% | 368.3 ± 0.5% | 1111.3 ± 0.2% | 758.4 ± 0.1% | 2.357 | 1.702 | 7.530 | 2.496 | 3.657 |
| string: http/css-1m | 1097820 | 3998.3 ± 0.6% | 1490.2 ± 0.6% | 2151.9 ± 0.5% | 494.5 ± 0.1% | 1381.3 ± 0.3% | 892.6 ± 0.7% | 2.683 | 1.858 | 8.085 | 2.895 | 4.480 |
| string: dickens as Cyrillic and CJK | 1883069 | 3073.8 ± 0.6% | 2343.9 ± 0.7% | 521.4 ± 0.7% | 307.2 ± 0.3% | 562.1 ± 1.0% | 336.1 ± 0.4% | 1.311 | 5.895 | 10.006 | 5.468 | 9.145 |
| hex: silesia/dickens | 524290 | 15594.4 ± 1.1% | 1457.3 ± 0.5% | 1083.5 ± 0.4% | 499.2 ± 0.5% | 987.8 ± 0.4% | 732.4 ± 0.2% | 10.701 | 14.393 | 31.239 | 15.788 | 21.292 |
| hex: silesia/mozilla | 524290 | 15650.6 ± 0.3% | 1467.0 ± 0.5% | 1085.9 ± 0.3% | 440.8 ± 0.3% | 988.7 ± 0.5% | 733.5 ± 1.0% | 10.669 | 14.413 | 35.507 | 15.830 | 21.335 |
| hex: silesia/mr | 524290 | 15655.5 ± 0.1% | 1476.5 ± 0.2% | 1092.8 ± 0.5% | 546.5 ± 1.9% | 996.0 ± 0.4% | 732.9 ± 0.3% | 10.603 | 14.326 | 28.649 | 15.719 | 21.361 |
| hex: silesia/nci | 524290 | 15667.6 ± 0.2% | 1468.0 ± 0.4% | 1086.2 ± 0.5% | 630.5 ± 2.9% | 988.5 ± 0.4% | 732.7 ± 0.5% | 10.673 | 14.425 | 24.849 | 15.850 | 21.382 |
| hex: silesia/ooffice | 524290 | 15565.5 ± 1.3% | 1458.4 ± 0.2% | 1083.1 ± 0.9% | 388.9 ± 0.3% | 990.1 ± 0.8% | 733.3 ± 0.5% | 10.673 | 14.371 | 40.024 | 15.721 | 21.226 |
| hex: silesia/osdb | 524290 | 15564.5 ± 0.9% | 1466.2 ± 0.3% | 1084.8 ± 0.6% | 471.2 ± 3.1% | 988.2 ± 0.3% | 731.8 ± 0.6% | 10.616 | 14.348 | 33.033 | 15.751 | 21.269 |
| hex: silesia/reymont | 524290 | 15611.6 ± 0.4% | 1459.4 ± 0.5% | 1085.5 ± 0.5% | 514.2 ± 0.7% | 986.2 ± 0.7% | 732.9 ± 0.6% | 10.697 | 14.382 | 30.359 | 15.831 | 21.301 |
| hex: silesia/samba | 524290 | 15662.6 ± 0.2% | 1460.3 ± 0.3% | 1081.8 ± 0.4% | 402.6 ± 0.6% | 987.2 ± 0.4% | 731.6 ± 0.3% | 10.726 | 14.478 | 38.903 | 15.866 | 21.409 |
| hex: silesia/sao | 524290 | 15609.4 ± 0.3% | 1460.2 ± 0.4% | 1083.9 ± 0.4% | 331.9 ± 0.5% | 990.6 ± 0.2% | 732.9 ± 0.4% | 10.690 | 14.402 | 47.026 | 15.758 | 21.299 |
| hex: silesia/webster | 524290 | 15657.4 ± 0.7% | 1458.7 ± 0.6% | 1082.2 ± 0.4% | 474.3 ± 0.6% | 985.9 ± 0.4% | 732.9 ± 0.3% | 10.734 | 14.468 | 33.008 | 15.882 | 21.362 |
| hex: silesia/x-ray | 524290 | 15528.2 ± 0.2% | 1469.7 ± 0.1% | 1088.3 ± 0.5% | 446.9 ± 1.1% | 995.4 ± 0.4% | 732.4 ± 0.7% | 10.566 | 14.268 | 34.747 | 15.600 | 21.201 |
| hex: silesia/xml | 524290 | 15604.9 ± 0.9% | 1463.0 ± 0.3% | 1084.2 ± 0.3% | 612.4 ± 0.7% | 986.3 ± 0.6% | 733.9 ± 0.8% | 10.666 | 14.393 | 25.482 | 15.822 | 21.263 |
| hex: canterbury/alice29.txt | 304180 | 15702.4 ± 0.1% | 1470.6 ± 0.6% | 1092.2 ± 0.4% | 503.3 ± 1.1% | 992.7 ± 0.8% | 731.1 ± 0.5% | 10.677 | 14.377 | 31.197 | 15.817 | 21.478 |
| hex: canterbury/asyoulik.txt | 250360 | 15717.1 ± 0.1% | 1469.1 ± 0.5% | 1093.0 ± 0.3% | 500.7 ± 1.7% | 995.1 ± 0.3% | 737.2 ± 0.5% | 10.698 | 14.380 | 31.390 | 15.795 | 21.320 |
| hex: canterbury/cp.html | 49208 | 15667.9 ± 0.0% | 1471.4 ± 0.3% | 1096.7 ± 0.5% | 531.5 ± 2.4% | 1008.0 ± 0.0% | 743.0 ± 0.2% | 10.648 | 14.287 | 29.479 | 15.544 | 21.087 |
| hex: canterbury/fields.c | 22302 | 15521.0 ± 0.2% | 1398.4 ± 0.9% | 1067.4 ± 0.8% | 633.8 ± 7.4% | 982.1 ± 0.2% | 736.8 ± 0.5% | 11.099 | 14.541 | 24.489 | 15.805 | 21.066 |
| hex: canterbury/grammar.lsp | 7444 | 15154.0 ± 0.0% | 1507.8 ± 0.2% | 1095.2 ± 0.5% | 671.4 ± 5.0% | 998.4 ± 0.2% | 726.4 ± 0.1% | 10.051 | 13.837 | 22.572 | 15.179 | 20.863 |
| hex: canterbury/kennedy.xls | 524290 | 15627.6 ± 0.5% | 1461.0 ± 0.4% | 1085.9 ± 0.6% | 653.4 ± 0.8% | 988.5 ± 0.6% | 730.9 ± 0.3% | 10.697 | 14.392 | 23.916 | 15.810 | 21.382 |
| hex: canterbury/lcet10.txt | 524290 | 15592.2 ± 0.3% | 1459.5 ± 0.2% | 1083.4 ± 0.3% | 498.7 ± 2.0% | 991.5 ± 1.0% | 732.3 ± 0.5% | 10.683 | 14.392 | 31.265 | 15.726 | 21.292 |
| hex: canterbury/plrabn12.txt | 524290 | 15623.9 ± 0.3% | 1451.6 ± 0.3% | 1080.5 ± 0.3% | 491.1 ± 0.4% | 983.1 ± 0.5% | 731.8 ± 0.4% | 10.763 | 14.460 | 31.812 | 15.892 | 21.350 |
| hex: canterbury/ptt5 | 524290 | 15610.9 ± 0.4% | 1476.0 ± 0.5% | 1091.4 ± 0.4% | 556.9 ± 1.0% | 992.6 ± 0.7% | 732.8 ± 0.3% | 10.576 | 14.304 | 28.033 | 15.727 | 21.304 |
| hex: canterbury/sum | 76482 | 15676.0 ± 0.1% | 1493.5 ± 0.1% | 1105.3 ± 0.2% | 594.9 ± 1.3% | 998.3 ± 0.0% | 744.4 ± 0.1% | 10.496 | 14.183 | 26.349 | 15.703 | 21.059 |
| hex: canterbury/xargs.1 | 8456 | 15209.5 ± 0.0% | 1493.2 ± 0.2% | 1095.8 ± 0.4% | 654.1 ± 2.5% | 997.9 ± 0.6% | 728.6 ± 0.2% | 10.186 | 13.880 | 23.252 | 15.242 | 20.875 |
| hex: canterbury-large/E.coli | 524290 | 15615.0 ± 0.3% | 1471.8 ± 0.4% | 1089.6 ± 0.8% | 671.8 ± 0.3% | 993.2 ± 0.5% | 730.6 ± 0.7% | 10.609 | 14.331 | 23.243 | 15.722 | 21.373 |
| hex: canterbury-large/bible.txt | 524290 | 15566.9 ± 0.7% | 1461.3 ± 0.4% | 1082.1 ± 0.5% | 513.6 ± 1.0% | 986.4 ± 0.2% | 731.4 ± 0.9% | 10.652 | 14.386 | 30.312 | 15.781 | 21.283 |
| hex: canterbury-large/world192.txt | 524290 | 15668.5 ± 0.1% | 1465.6 ± 0.6% | 1083.2 ± 0.5% | 502.7 ± 0.7% | 991.1 ± 0.3% | 731.4 ± 0.6% | 10.691 | 14.465 | 31.171 | 15.809 | 21.421 |
| hex: http/html-1kx1024 | 2099200 | 14130.4 ± 0.2% | 1454.9 ± 0.2% | 1061.7 ± 0.2% | 501.2 ± 0.2% | 983.6 ± 0.2% | 692.6 ± 0.1% | 9.712 | 13.310 | 28.194 | 14.367 | 20.402 |
| hex: http/html-16kx64 | 2097280 | 15300.4 ± 0.5% | 1441.3 ± 0.2% | 1072.9 ± 0.7% | 506.2 ± 0.2% | 994.7 ± 0.2% | 734.6 ± 0.2% | 10.615 | 14.261 | 30.228 | 15.381 | 20.827 |
| hex: http/html-1m | 524290 | 15608.9 ± 0.2% | 1463.9 ± 0.3% | 1084.7 ± 0.3% | 498.6 ± 0.6% | 989.7 ± 0.4% | 732.8 ± 0.7% | 10.663 | 14.390 | 31.303 | 15.771 | 21.300 |
| hex: http/json-1kx1024 | 2099200 | 14128.0 ± 0.4% | 1463.0 ± 0.1% | 1065.9 ± 0.6% | 608.9 ± 0.7% | 985.7 ± 0.1% | 692.8 ± 0.1% | 9.657 | 13.255 | 23.202 | 14.333 | 20.391 |
| hex: http/json-16kx64 | 2097280 | 15343.7 ± 1.2% | 1446.7 ± 0.3% | 1074.8 ± 0.1% | 615.6 ± 0.6% | 995.9 ± 0.4% | 734.8 ± 0.1% | 10.606 | 14.275 | 24.923 | 15.407 | 20.883 |
| hex: http/json-1m | 524290 | 15545.8 ± 0.8% | 1468.0 ± 0.2% | 1086.2 ± 0.3% | 628.3 ± 1.3% | 990.0 ± 0.5% | 732.6 ± 0.7% | 10.590 | 14.312 | 24.744 | 15.703 | 21.221 |
| hex: http/js-1kx1024 | 2099200 | 14139.3 ± 0.5% | 1453.5 ± 0.2% | 1063.1 ± 0.3% | 499.1 ± 0.2% | 982.9 ± 0.3% | 692.8 ± 0.2% | 9.728 | 13.300 | 28.327 | 14.385 | 20.409 |
| hex: http/js-16kx64 | 2097280 | 15378.6 ± 0.2% | 1444.3 ± 0.2% | 1073.9 ± 0.5% | 504.7 ± 0.1% | 994.1 ± 0.1% | 734.7 ± 0.1% | 10.648 | 14.321 | 30.472 | 15.470 | 20.932 |
| hex: http/js-1m | 524290 | 15656.7 ± 0.4% | 1458.3 ± 0.4% | 1084.1 ± 0.5% | 510.3 ± 0.4% | 990.1 ± 0.3% | 732.0 ± 0.7% | 10.736 | 14.442 | 30.679 | 15.814 | 21.389 |
| hex: http/css-1kx1024 | 2099200 | 14118.7 ± 0.5% | 1453.9 ± 0.1% | 1062.2 ± 0.1% | 530.6 ± 0.5% | 983.1 ± 0.1% | 692.7 ± 0.1% | 9.711 | 13.292 | 26.608 | 14.361 | 20.382 |
| hex: http/css-16kx64 | 2097280 | 15303.1 ± 0.2% | 1444.6 ± 0.5% | 1074.6 ± 0.7% | 538.8 ± 0.3% | 998.5 ± 0.4% | 734.9 ± 0.2% | 10.593 | 14.241 | 28.402 | 15.326 | 20.823 |
| hex: http/css-1m | 524290 | 15627.6 ± 0.1% | 1458.9 ± 0.3% | 1083.3 ± 0.5% | 524.6 ± 0.6% | 988.0 ± 0.4% | 731.1 ± 0.5% | 10.712 | 14.426 | 29.792 | 15.818 | 21.377 |
| hex: shuffled/dickens-1m | 524290 | 15636.7 ± 0.4% | 1455.9 ± 0.6% | 1083.0 ± 0.2% | 499.9 ± 1.0% | 986.7 ± 0.6% | 731.7 ± 0.3% | 10.740 | 14.439 | 31.280 | 15.848 | 21.371 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.924 of yyjson.
