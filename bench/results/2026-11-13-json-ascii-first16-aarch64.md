# bench-json

| Field | Value |
|---|---|
| Commit | eb9746f |
| Runner label | ubuntu-24.04-arm |
| Image version | 20261111.182.1 |
| CPU model | Neoverse-N2 |
| Virtual CPUs | 4 |
| Kernel | 7.0.0-1017-azure |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/43483791171 |
| Date | 2026-11-13 |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1. The `TextReader.next_items` column is that helper's queued tokens a slice a call (decision 79), over many tokens a call.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | TextReader.next_items | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1127.4 ± 0.3% | 0.524 | 0.965 | 0.996 | 0.997 | 0.460 | 1.003 | 1.006 | 0.388 | 0.831 | 0.900 | 0.100 |
| qlog records, JSON text sequence | 1467503 | 838.1 ± 1.7% | 0.827 | 1.008 | 1.011 | 1.010 | 0.450 | 1.001 | 1.036 | 0.396 | 0.921 | 0.997 | 0.123 |
| string: silesia/dickens | 172528 | 5032.6 ± 0.3% | 0.033 | 0.784 | 1.004 | 1.005 | 0.197 | 1.019 | 1.008 | 0.197 | 1.002 | 1.003 | 0.032 |
| string: silesia/nci | 1075110 | 4270.6 ± 0.6% | 0.039 | 0.807 | 1.008 | 1.009 | 0.281 | 1.011 | 1.002 | 0.281 | 1.007 | 1.008 | 0.038 |
| string: silesia/reymont | 1075159 | 2911.9 ± 2.2% | 0.057 | 0.826 | 1.012 | 1.022 | 0.362 | 1.011 | 1.015 | 0.362 | 1.032 | 1.034 | 0.057 |
| string: silesia/samba | 97582 | 3491.4 ± 0.4% | 0.040 | 0.862 | 1.005 | 1.007 | 0.069 | 0.779 | 1.012 | 0.073 | 1.004 | 1.006 | 0.039 |
| string: silesia/webster | 1098490 | 3637.7 ± 0.3% | 0.044 | 0.848 | 1.008 | 1.008 | 0.204 | 1.021 | 1.015 | 0.204 | 1.010 | 1.009 | 0.044 |
| string: silesia/xml | 1090118 | 4740.0 ± 1.9% | 0.035 | 0.813 | 1.012 | 1.014 | 0.224 | 0.984 | 1.012 | 0.226 | 1.013 | 1.014 | 0.035 |
| string: canterbury/alice29.txt | 159425 | 4311.5 ± 0.4% | 0.038 | 0.750 | 1.004 | 1.008 | 0.172 | 1.031 | 1.023 | 0.172 | 1.014 | 1.014 | 0.037 |
| string: canterbury/asyoulik.txt | 132198 | 3449.1 ± 0.4% | 0.046 | 0.749 | 1.004 | 1.007 | 0.177 | 1.009 | 0.973 | 0.176 | 1.017 | 1.017 | 0.045 |
| string: canterbury/lcet10.txt | 441884 | 5103.7 ± 0.4% | 0.032 | 0.816 | 1.004 | 1.006 | 0.196 | 1.020 | 1.006 | 0.196 | 1.001 | 1.001 | 0.032 |
| string: canterbury/plrabn12.txt | 503330 | 4116.6 ± 0.6% | 0.040 | 0.822 | 1.005 | 1.006 | 0.199 | 1.009 | 0.998 | 0.198 | 1.007 | 1.007 | 0.039 |
| string: canterbury-large/E.coli | 1048578 | 19030.6 ± 0.6% | 0.077 | 1.013 | 1.008 | 1.009 | 0.481 | 1.013 | 1.011 | 0.481 | 0.626 | 0.627 | 0.009 |
| string: canterbury-large/bible.txt | 1055886 | 6639.4 ± 1.3% | 0.026 | 0.806 | 1.003 | 1.007 | 0.436 | 1.028 | 1.047 | 0.436 | 1.040 | 1.044 | 0.026 |
| string: canterbury-large/world192.txt | 1103121 | 3387.9 ± 0.3% | 0.047 | 0.845 | 1.004 | 1.005 | 0.198 | 1.013 | 1.005 | 0.198 | 1.005 | 1.006 | 0.047 |
| string: http/html-1m | 1058582 | 6053.6 ± 7.0% | 0.028 | 0.782 | 0.997 | 1.036 | 0.390 | 1.044 | 1.052 | 0.389 | 1.028 | 1.031 | 0.028 |
| string: http/json-1m | 1190272 | 2550.3 ± 0.3% | 0.055 | 0.950 | 1.002 | 1.001 | 0.111 | 1.003 | 0.470 | 0.111 | 1.002 | 1.003 | 0.055 |
| string: http/js-1m | 1144362 | 2282.9 ± 0.2% | 0.066 | 0.889 | 1.000 | 1.000 | 0.175 | 1.054 | 1.044 | 0.174 | 0.999 | 1.000 | 0.065 |
| string: http/css-1m | 1097820 | 2635.7 ± 0.7% | 0.061 | 0.778 | 1.005 | 1.007 | 0.241 | 1.008 | 1.013 | 0.239 | 1.008 | 1.008 | 0.060 |
| string: dickens as Cyrillic and CJK | 1883069 | 3070.7 ± 0.8% | 0.044 | 0.125 | 1.002 | 1.002 | 0.337 | 1.001 | 1.009 | 0.337 | 1.005 | 1.003 | 0.044 |
| string: dickens as Cyrillic and CJK, as \u escapes | 5075485 | 1327.6 ± 2.2% | 0.082 | 1.004 | 1.001 | 1.002 | 0.077 | 0.637 | 1.005 | 0.081 | 1.001 | 1.002 | 0.081 |
| hex: silesia/dickens | 524290 | 18497.6 ± 1.1% | 0.080 | 1.002 | 0.984 | 0.982 | 0.510 | 0.982 | 0.998 | 0.511 | 0.648 | 0.649 | 0.009 |
| hex: silesia/mozilla | 524290 | 18165.6 ± 0.8% | 0.082 | 1.010 | 1.009 | 1.009 | 0.537 | 1.007 | 1.003 | 0.541 | 0.662 | 0.662 | 0.010 |
| hex: silesia/mr | 524290 | 18184.1 ± 1.7% | 0.082 | 1.012 | 1.001 | 1.001 | 0.533 | 1.000 | 1.003 | 0.533 | 0.659 | 0.660 | 0.010 |
| hex: silesia/nci | 524290 | 18436.3 ± 0.6% | 0.081 | 1.008 | 0.995 | 0.996 | 0.529 | 0.996 | 0.995 | 0.531 | 0.651 | 0.651 | 0.009 |
| hex: silesia/ooffice | 524290 | 18530.2 ± 1.4% | 0.080 | 1.008 | 0.992 | 0.982 | 0.514 | 0.992 | 0.982 | 0.509 | 0.646 | 0.646 | 0.009 |
| hex: silesia/osdb | 524290 | 18077.2 ± 2.9% | 0.082 | 1.004 | 1.000 | 0.999 | 0.522 | 0.994 | 1.001 | 0.522 | 0.665 | 0.665 | 0.010 |
| hex: silesia/reymont | 524290 | 18652.3 ± 1.5% | 0.079 | 0.999 | 0.987 | 0.983 | 0.498 | 0.994 | 0.987 | 0.499 | 0.641 | 0.641 | 0.009 |
| hex: silesia/samba | 524290 | 17906.3 ± 1.0% | 0.083 | 1.003 | 1.004 | 1.004 | 0.532 | 0.997 | 0.997 | 0.533 | 0.668 | 0.665 | 0.010 |
| hex: silesia/sao | 524290 | 18545.8 ± 1.3% | 0.080 | 1.002 | 0.995 | 0.989 | 0.512 | 0.998 | 0.990 | 0.509 | 0.646 | 0.646 | 0.009 |
| hex: silesia/webster | 524290 | 18420.6 ± 1.3% | 0.081 | 1.011 | 0.991 | 0.991 | 0.525 | 0.992 | 0.992 | 0.525 | 0.652 | 0.653 | 0.009 |
| hex: silesia/x-ray | 524290 | 18345.2 ± 4.5% | 0.081 | 1.003 | 0.997 | 0.998 | 0.520 | 1.001 | 0.999 | 0.519 | 0.651 | 0.650 | 0.009 |
| hex: silesia/xml | 524290 | 18550.5 ± 1.0% | 0.080 | 0.994 | 0.994 | 0.995 | 0.508 | 0.992 | 0.993 | 0.508 | 0.648 | 0.648 | 0.009 |
| hex: canterbury/alice29.txt | 304180 | 19139.1 ± 1.6% | 0.078 | 1.007 | 1.003 | 1.003 | 0.513 | 1.006 | 1.006 | 0.515 | 0.628 | 0.628 | 0.009 |
| hex: canterbury/asyoulik.txt | 250360 | 19528.8 ± 0.1% | 0.077 | 0.993 | 1.001 | 1.001 | 0.513 | 1.001 | 1.002 | 0.514 | 0.615 | 0.615 | 0.009 |
| hex: canterbury/cp.html | 49208 | 19295.0 ± 0.3% | 0.082 | 1.002 | 1.001 | 1.000 | 0.541 | 1.002 | 1.002 | 0.542 | 0.618 | 0.618 | 0.009 |
| hex: canterbury/fields.c | 22302 | 18890.5 ± 0.8% | 0.084 | 1.004 | 1.005 | 1.005 | 0.534 | 1.004 | 1.004 | 0.539 | 0.624 | 0.624 | 0.009 |
| hex: canterbury/grammar.lsp | 7444 | 17449.9 ± 0.5% | 0.089 | 1.009 | 1.009 | 1.009 | 0.528 | 1.008 | 1.008 | 0.547 | 0.645 | 0.648 | 0.010 |
| hex: canterbury/kennedy.xls | 524290 | 18458.4 ± 2.8% | 0.080 | 1.006 | 0.997 | 0.993 | 0.515 | 0.989 | 0.992 | 0.516 | 0.650 | 0.651 | 0.009 |
| hex: canterbury/lcet10.txt | 524290 | 18030.2 ± 1.5% | 0.082 | 1.017 | 1.008 | 1.007 | 0.523 | 1.004 | 1.008 | 0.524 | 0.664 | 0.663 | 0.010 |
| hex: canterbury/plrabn12.txt | 524290 | 18013.9 ± 1.2% | 0.083 | 1.013 | 1.009 | 1.010 | 0.536 | 1.004 | 1.007 | 0.537 | 0.662 | 0.665 | 0.010 |
| hex: canterbury/ptt5 | 524290 | 18247.8 ± 0.5% | 0.081 | 1.006 | 0.999 | 1.002 | 0.525 | 1.003 | 1.000 | 0.526 | 0.658 | 0.659 | 0.010 |
| hex: canterbury/sum | 76482 | 19266.6 ± 0.3% | 0.078 | 1.003 | 1.004 | 1.004 | 0.519 | 1.003 | 1.003 | 0.521 | 0.618 | 0.618 | 0.009 |
| hex: canterbury/xargs.1 | 8456 | 17809.3 ± 1.1% | 0.088 | 1.003 | 1.003 | 1.003 | 0.524 | 1.002 | 1.002 | 0.541 | 0.637 | 0.637 | 0.010 |
| hex: canterbury-large/E.coli | 524290 | 18194.5 ± 1.0% | 0.081 | 1.003 | 1.005 | 1.006 | 0.512 | 1.007 | 1.001 | 0.516 | 0.655 | 0.655 | 0.010 |
| hex: canterbury-large/bible.txt | 524290 | 18264.0 ± 0.9% | 0.081 | 0.997 | 0.998 | 0.996 | 0.514 | 0.997 | 0.992 | 0.514 | 0.654 | 0.655 | 0.009 |
| hex: canterbury-large/world192.txt | 524290 | 17888.1 ± 4.2% | 0.083 | 1.004 | 1.000 | 0.999 | 0.527 | 0.996 | 1.002 | 0.527 | 0.669 | 0.669 | 0.010 |
| hex: http/html-1kx1024 | 2099200 | 9088.6 ± 18.5% | 0.157 | 1.293 | 1.282 | 1.277 | 0.722 | 1.279 | 0.981 | 0.788 | 0.965 | 0.969 | 0.019 |
| hex: http/html-16kx64 | 2097280 | 17774.5 ± 1.6% | 0.085 | 1.019 | 1.014 | 1.017 | 0.576 | 1.015 | 0.980 | 0.581 | 0.662 | 0.662 | 0.010 |
| hex: http/html-1m | 524290 | 18056.7 ± 0.8% | 0.082 | 1.002 | 0.998 | 0.997 | 0.530 | 1.006 | 0.993 | 0.531 | 0.664 | 0.663 | 0.010 |
| hex: http/json-1kx1024 | 2099200 | 10407.9 ± 10.8% | 0.137 | 1.119 | 1.119 | 1.118 | 0.628 | 1.119 | 0.858 | 0.690 | 0.834 | 0.844 | 0.017 |
| hex: http/json-16kx64 | 2097280 | 17912.6 ± 0.5% | 0.082 | 1.013 | 1.010 | 1.009 | 0.572 | 1.013 | 0.979 | 0.577 | 0.657 | 0.657 | 0.010 |
| hex: http/json-1m | 524290 | 18114.7 ± 0.9% | 0.082 | 1.001 | 1.003 | 0.997 | 0.531 | 1.001 | 0.997 | 0.528 | 0.662 | 0.662 | 0.010 |
| hex: http/js-1kx1024 | 2099200 | 9192.8 ± 17.7% | 0.156 | 1.268 | 1.266 | 1.270 | 0.716 | 1.275 | 0.978 | 0.783 | 0.946 | 0.955 | 0.019 |
| hex: http/js-16kx64 | 2097280 | 17704.2 ± 0.3% | 0.085 | 1.021 | 1.019 | 1.020 | 0.578 | 1.020 | 0.988 | 0.582 | 0.665 | 0.665 | 0.010 |
| hex: http/js-1m | 524290 | 18312.2 ± 1.2% | 0.081 | 1.016 | 0.998 | 0.999 | 0.525 | 0.992 | 0.992 | 0.526 | 0.654 | 0.651 | 0.009 |
| hex: http/css-1kx1024 | 2099200 | 9455.9 ± 12.9% | 0.151 | 1.257 | 1.265 | 1.264 | 0.694 | 1.266 | 1.020 | 0.761 | 0.937 | 0.941 | 0.018 |
| hex: http/css-16kx64 | 2097280 | 17911.5 ± 2.0% | 0.084 | 1.017 | 1.015 | 1.014 | 0.572 | 1.012 | 0.978 | 0.577 | 0.657 | 0.657 | 0.010 |
| hex: http/css-1m | 524290 | 18390.0 ± 1.7% | 0.081 | 1.012 | 1.004 | 1.000 | 0.529 | 1.004 | 1.009 | 0.528 | 0.654 | 0.654 | 0.009 |
| hex: shuffled/dickens-1m | 524290 | 17980.8 ± 0.6% | 0.083 | 0.999 | 0.996 | 0.999 | 0.538 | 0.996 | 0.996 | 0.539 | 0.668 | 0.668 | 0.010 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1484.6 ± 0.5% | 0.443 | 0.999 | 0.967 | 1.004 | 1.007 | 0.268 | 1.000 | 0.547 | 0.912 | 0.089 | 1.027 |
| qlog records, JSON text sequence | 1467503 | 1267.6 ± 1.6% | 0.691 | 0.979 | 1.012 | 1.015 | 1.013 | 0.265 | 1.004 | 0.502 | 0.830 | 0.106 | 1.021 |
| string: silesia/dickens | 172528 | 6898.5 ± 0.3% | 0.025 | 1.001 | 1.001 | 1.002 | 1.003 | 0.167 | 0.717 | 1.003 | 1.003 | 0.025 | 1.034 |
| string: silesia/nci | 1075110 | 7290.9 ± 0.8% | 0.024 | 1.003 | 1.002 | 1.001 | 1.001 | 0.212 | 0.565 | 1.002 | 1.003 | 0.024 | 1.010 |
| string: silesia/reymont | 1075159 | 3311.2 ± 1.3% | 0.052 | 1.010 | 0.999 | 1.009 | 1.009 | 0.393 | 0.883 | 1.008 | 1.009 | 0.053 | 1.059 |
| string: silesia/samba | 97582 | 4187.4 ± 1.2% | 0.053 | 1.002 | 1.003 | 1.006 | 1.008 | 0.125 | 0.943 | 1.005 | 1.005 | 0.054 | 1.095 |
| string: silesia/webster | 1098490 | 4050.2 ± 0.3% | 0.042 | 1.007 | 1.008 | 1.009 | 1.006 | 0.213 | 0.888 | 1.001 | 1.007 | 0.043 | 1.008 |
| string: silesia/xml | 1090118 | 6107.0 ± 0.5% | 0.029 | 1.006 | 1.000 | 1.005 | 1.006 | 0.254 | 0.778 | 1.004 | 1.004 | 0.029 | 1.019 |
| string: canterbury/alice29.txt | 159425 | 6428.0 ± 2.9% | 0.027 | 1.008 | 1.008 | 1.008 | 1.011 | 0.132 | 0.652 | 1.004 | 1.006 | 0.027 | 1.058 |
| string: canterbury/asyoulik.txt | 132198 | 5570.7 ± 4.6% | 0.030 | 1.031 | 1.036 | 1.037 | 1.039 | 0.130 | 0.599 | 1.005 | 1.014 | 0.030 | 1.054 |
| string: canterbury/lcet10.txt | 441884 | 6241.2 ± 0.9% | 0.029 | 1.008 | 1.010 | 1.009 | 1.008 | 0.185 | 0.800 | 1.003 | 1.005 | 0.028 | 1.000 |
| string: canterbury/plrabn12.txt | 503330 | 5713.5 ± 0.3% | 0.030 | 1.000 | 1.001 | 1.002 | 1.001 | 0.169 | 0.698 | 1.002 | 1.001 | 0.031 | 1.004 |
| string: canterbury-large/E.coli | 1048578 | 19198.3 ± 0.6% | 0.078 | 1.000 | 0.999 | 0.997 | 1.001 | 0.481 | 1.001 | 1.003 | 1.002 | 0.009 | 1.003 |
| string: canterbury-large/bible.txt | 1055886 | 6796.3 ± 0.6% | 0.026 | 0.999 | 0.999 | 1.000 | 1.000 | 0.494 | 0.970 | 1.001 | 1.000 | 0.026 | 0.997 |
| string: canterbury-large/world192.txt | 1103121 | 4018.7 ± 0.7% | 0.042 | 1.018 | 1.019 | 1.018 | 1.018 | 0.194 | 0.831 | 1.000 | 1.007 | 0.043 | 1.001 |
| string: http/html-1m | 1058582 | 6744.6 ± 0.7% | 0.026 | 1.007 | 0.925 | 1.003 | 1.006 | 0.404 | 0.883 | 1.002 | 1.005 | 0.026 | 1.012 |
| string: http/json-1m | 1190272 | 3165.0 ± 0.6% | 0.051 | 1.000 | 0.965 | 1.000 | 1.000 | 0.133 | 0.371 | 1.001 | 1.002 | 0.051 | 1.040 |
| string: http/js-1m | 1144362 | 2758.5 ± 0.6% | 0.060 | 1.006 | 1.008 | 1.004 | 1.008 | 0.165 | 0.836 | 1.003 | 1.006 | 0.062 | 1.012 |
| string: http/css-1m | 1097820 | 3979.3 ± 0.7% | 0.043 | 1.006 | 1.009 | 1.010 | 1.012 | 0.209 | 0.647 | 0.998 | 1.006 | 0.043 | 1.015 |
| string: dickens as Cyrillic and CJK | 1883069 | 3060.4 ± 0.3% | 0.048 | 1.004 | 0.125 | 1.003 | 1.004 | 0.322 | 1.006 | 1.003 | 1.003 | 0.048 | 1.004 |
| hex: silesia/dickens | 524290 | 15650.9 ± 0.2% | 0.999 | 0.178 | 0.999 | 0.999 | 0.996 | 0.996 | 0.996 | 0.995 | 0.996 | 0.177 | 0.994 |
| hex: silesia/mozilla | 524290 | 15638.0 ± 0.2% | 1.003 | 0.178 | 1.002 | 0.999 | 1.001 | 1.001 | 1.002 | 1.002 | 1.001 | 0.178 | 1.001 |
| hex: silesia/mr | 524290 | 15616.2 ± 0.2% | 1.003 | 0.179 | 1.002 | 1.001 | 1.000 | 1.000 | 1.002 | 1.001 | 1.000 | 0.178 | 1.003 |
| hex: silesia/nci | 524290 | 15629.4 ± 0.1% | 1.002 | 0.179 | 1.000 | 1.000 | 0.999 | 1.000 | 1.002 | 1.001 | 1.001 | 0.178 | 1.002 |
| hex: silesia/ooffice | 524290 | 15605.4 ± 0.2% | 1.001 | 0.178 | 1.000 | 0.999 | 0.999 | 0.997 | 0.996 | 0.996 | 0.992 | 0.178 | 0.997 |
| hex: silesia/osdb | 524290 | 15628.9 ± 0.6% | 1.002 | 0.178 | 1.001 | 1.001 | 1.001 | 1.002 | 1.002 | 1.002 | 1.001 | 0.178 | 1.001 |
| hex: silesia/reymont | 524290 | 15632.3 ± 0.1% | 1.000 | 0.177 | 0.997 | 0.998 | 0.998 | 0.997 | 0.997 | 0.995 | 0.994 | 0.178 | 0.998 |
| hex: silesia/samba | 524290 | 15630.6 ± 0.1% | 1.000 | 0.178 | 1.000 | 1.000 | 1.001 | 0.999 | 1.001 | 1.001 | 1.000 | 0.178 | 1.000 |
| hex: silesia/sao | 524290 | 15649.8 ± 0.2% | 1.002 | 0.178 | 1.000 | 1.001 | 1.000 | 1.001 | 0.999 | 1.000 | 1.000 | 0.178 | 0.998 |
| hex: silesia/webster | 524290 | 15663.5 ± 0.3% | 1.000 | 0.177 | 1.000 | 1.001 | 1.001 | 0.999 | 1.000 | 1.000 | 1.000 | 0.177 | 0.999 |
| hex: silesia/x-ray | 524290 | 15620.6 ± 0.3% | 1.001 | 0.178 | 1.001 | 1.000 | 1.001 | 1.000 | 1.001 | 1.002 | 1.002 | 0.179 | 1.000 |
| hex: silesia/xml | 524290 | 15628.6 ± 0.2% | 1.002 | 0.178 | 1.001 | 1.001 | 1.002 | 1.001 | 1.001 | 1.001 | 1.001 | 0.178 | 1.002 |
| hex: canterbury/alice29.txt | 304180 | 15679.8 ± 0.0% | 1.001 | 0.178 | 1.001 | 1.001 | 1.001 | 0.999 | 1.001 | 1.001 | 1.002 | 0.178 | 1.001 |
| hex: canterbury/asyoulik.txt | 250360 | 15700.6 ± 0.1% | 1.001 | 0.178 | 1.001 | 1.001 | 1.001 | 1.000 | 1.001 | 1.001 | 1.001 | 0.177 | 1.001 |
| hex: canterbury/cp.html | 49208 | 15621.1 ± 0.1% | 1.001 | 0.179 | 1.000 | 1.000 | 1.000 | 0.998 | 1.001 | 1.002 | 1.003 | 0.179 | 1.001 |
| hex: canterbury/fields.c | 22302 | 15426.9 ± 0.2% | 1.002 | 0.181 | 1.001 | 1.001 | 1.001 | 0.995 | 1.001 | 1.003 | 1.006 | 0.180 | 1.002 |
| hex: canterbury/grammar.lsp | 7444 | 14936.7 ± 0.1% | 1.004 | 0.186 | 1.000 | 1.000 | 1.001 | 0.983 | 1.000 | 1.004 | 1.014 | 0.184 | 1.004 |
| hex: canterbury/kennedy.xls | 524290 | 15614.7 ± 0.8% | 1.004 | 0.178 | 1.002 | 1.002 | 1.002 | 1.001 | 1.003 | 1.002 | 1.001 | 0.179 | 1.003 |
| hex: canterbury/lcet10.txt | 524290 | 15594.5 ± 0.2% | 1.004 | 0.179 | 1.002 | 1.002 | 1.003 | 1.000 | 1.001 | 1.000 | 1.002 | 0.178 | 1.001 |
| hex: canterbury/plrabn12.txt | 524290 | 15593.8 ± 0.2% | 1.003 | 0.178 | 1.003 | 0.999 | 0.993 | 0.999 | 0.999 | 1.001 | 0.998 | 0.178 | 0.998 |
| hex: canterbury/ptt5 | 524290 | 15598.9 ± 0.5% | 1.002 | 0.179 | 1.001 | 1.002 | 1.000 | 0.997 | 1.000 | 0.997 | 0.999 | 0.179 | 0.999 |
| hex: canterbury/sum | 76482 | 15641.1 ± 0.1% | 1.001 | 0.179 | 1.000 | 1.000 | 1.000 | 0.999 | 1.000 | 1.001 | 1.002 | 0.178 | 1.001 |
| hex: canterbury/xargs.1 | 8456 | 14987.6 ± 0.1% | 1.004 | 0.185 | 1.001 | 1.000 | 1.000 | 0.986 | 1.000 | 1.005 | 1.015 | 0.184 | 1.003 |
| hex: canterbury-large/E.coli | 524290 | 15654.1 ± 0.2% | 1.001 | 0.178 | 0.998 | 1.000 | 0.999 | 0.993 | 0.996 | 0.996 | 0.994 | 0.178 | 0.995 |
| hex: canterbury-large/bible.txt | 524290 | 15616.7 ± 0.4% | 1.002 | 0.178 | 0.999 | 1.002 | 1.001 | 0.999 | 1.000 | 1.002 | 1.001 | 0.178 | 1.002 |
| hex: canterbury-large/world192.txt | 524290 | 15596.7 ± 0.3% | 0.997 | 0.179 | 1.000 | 1.000 | 0.999 | 1.000 | 0.999 | 0.998 | 1.001 | 0.178 | 1.000 |
| hex: http/html-1kx1024 | 2099200 | 13655.8 ± 1.6% | 1.003 | 0.196 | 1.000 | 0.999 | 1.003 | 0.944 | 1.002 | 1.006 | 1.034 | 0.188 | 1.014 |
| hex: http/html-16kx64 | 2097280 | 15216.6 ± 0.2% | 1.002 | 0.181 | 0.998 | 1.000 | 1.001 | 0.993 | 1.001 | 1.007 | 1.010 | 0.180 | 0.999 |
| hex: http/html-1m | 524290 | 15634.7 ± 0.2% | 1.000 | 0.178 | 1.001 | 1.000 | 1.001 | 1.000 | 1.001 | 0.999 | 1.001 | 0.178 | 1.002 |
| hex: http/json-1kx1024 | 2099200 | 13620.3 ± 8.7% | 1.010 | 0.196 | 0.998 | 1.000 | 1.001 | 0.942 | 0.996 | 1.008 | 1.038 | 0.188 | 1.013 |
| hex: http/json-16kx64 | 2097280 | 15226.0 ± 0.3% | 1.000 | 0.181 | 0.997 | 1.001 | 1.002 | 0.994 | 0.995 | 1.005 | 1.010 | 0.180 | 1.000 |
| hex: http/json-1m | 524290 | 15613.6 ± 0.2% | 1.000 | 0.178 | 1.001 | 1.001 | 1.001 | 0.998 | 0.999 | 0.999 | 1.000 | 0.178 | 0.999 |
| hex: http/js-1kx1024 | 2099200 | 13601.7 ± 0.5% | 1.011 | 0.196 | 1.003 | 1.004 | 1.004 | 0.942 | 1.001 | 1.008 | 1.040 | 0.188 | 1.009 |
| hex: http/js-16kx64 | 2097280 | 15210.4 ± 0.6% | 1.005 | 0.181 | 1.004 | 1.004 | 1.002 | 0.989 | 1.000 | 1.010 | 1.012 | 0.181 | 0.999 |
| hex: http/js-1m | 524290 | 15630.0 ± 0.2% | 1.002 | 0.177 | 0.999 | 0.994 | 0.996 | 0.992 | 0.993 | 0.993 | 0.993 | 0.177 | 0.994 |
| hex: http/css-1kx1024 | 2099200 | 13596.9 ± 0.6% | 1.008 | 0.196 | 0.996 | 1.002 | 1.002 | 0.942 | 0.998 | 1.008 | 1.037 | 0.188 | 1.010 |
| hex: http/css-16kx64 | 2097280 | 15209.2 ± 0.3% | 0.999 | 0.181 | 1.002 | 1.001 | 1.001 | 0.989 | 0.998 | 1.003 | 1.010 | 0.180 | 0.999 |
| hex: http/css-1m | 524290 | 15663.4 ± 0.3% | 1.001 | 0.177 | 1.001 | 1.000 | 1.000 | 1.000 | 1.001 | 1.000 | 1.000 | 0.177 | 1.001 |
| hex: shuffled/dickens-1m | 524290 | 15642.5 ± 0.2% | 1.002 | 0.178 | 1.002 | 1.000 | 0.998 | 0.996 | 0.998 | 0.997 | 0.998 | 0.177 | 0.998 |

## Losses

Each workload where a claim's path ran slower than the path it replaces by more than the noise floor of decision 20.

- string: http/js-1m, decoding: J12 decoder escape words off runs at 1.054 of all on.
- hex: http/html-1kx1024, decoding: J5 UTF-8 vectors off runs at 1.293 of all on.
- hex: http/html-1kx1024, decoding: J7 wide vectors off runs at 1.282 of all on.
- hex: http/html-1kx1024, decoding: J8 decoder fast path off runs at 1.277 of all on.
- hex: http/html-1kx1024, decoding: J12 decoder escape words off runs at 1.279 of all on.
- hex: http/json-1kx1024, decoding: J5 UTF-8 vectors off runs at 1.119 of all on.
- hex: http/json-1kx1024, decoding: J7 wide vectors off runs at 1.119 of all on.
- hex: http/json-1kx1024, decoding: J8 decoder fast path off runs at 1.118 of all on.
- hex: http/json-1kx1024, decoding: J12 decoder escape words off runs at 1.119 of all on.
- hex: http/js-1kx1024, decoding: J5 UTF-8 vectors off runs at 1.268 of all on.
- hex: http/js-1kx1024, decoding: J7 wide vectors off runs at 1.266 of all on.
- hex: http/js-1kx1024, decoding: J8 decoder fast path off runs at 1.270 of all on.
- hex: http/js-1kx1024, decoding: J12 decoder escape words off runs at 1.275 of all on.
- hex: http/css-1kx1024, decoding: J5 UTF-8 vectors off runs at 1.257 of all on.
- hex: http/css-1kx1024, decoding: J7 wide vectors off runs at 1.265 of all on.
- hex: http/css-1kx1024, decoding: J8 decoder fast path off runs at 1.264 of all on.
- hex: http/css-1kx1024, decoding: J12 decoder escape words off runs at 1.266 of all on.

## UTF-8 validation against simdutf

stdx's `is_utf8`, the check the loops apply to every string's octets, run alone over each string workload's octets at the width the host's features pick (16 lanes on aarch64, AVX2's 32 or AVX-512's 64 on x86-64, decision 39), beside simdutf 9.3.3's `validate_utf8` in the same run; on a host with AVX-512, again with AVX2 alone. Each ratio is stdx's throughput over the other's. simdutf picks its kernel at run time. Before timing, every copy of the check and simdutf judged 20000 seeded buffers and each workload, whole and changed, alike.

| Workload | Octets | stdx, MB/s | simdutf, MB/s | stdx / simdutf | stdx with AVX2 alone, MB/s | stdx / stdx with AVX2 alone |
|---|---|---|---|---|---|---|
| string: silesia/dickens | 166668 | 43321.0 ± 0.2% | 47402.5 ± 0.1% | 0.914 | — | — |
| string: silesia/nci | 1048576 | 35740.6 ± 2.4% | 38438.1 ± 1.7% | 0.930 | — | — |
| string: silesia/reymont | 1048576 | 35444.8 ± 2.3% | 38104.0 ± 5.3% | 0.930 | — | — |
| string: silesia/samba | 65546 | 43573.9 ± 0.0% | 48522.8 ± 0.0% | 0.898 | — | — |
| string: silesia/webster | 1048576 | 34035.2 ± 2.4% | 36664.5 ± 2.2% | 0.928 | — | — |
| string: silesia/xml | 1048576 | 30308.0 ± 1.8% | 31531.9 ± 3.4% | 0.961 | — | — |
| string: canterbury/alice29.txt | 152089 | 35881.6 ± 0.1% | 36544.8 ± 0.1% | 0.982 | — | — |
| string: canterbury/asyoulik.txt | 125179 | 43320.1 ± 0.4% | 47582.7 ± 0.1% | 0.910 | — | — |
| string: canterbury/lcet10.txt | 426754 | 36039.0 ± 0.6% | 36702.6 ± 0.4% | 0.982 | — | — |
| string: canterbury/plrabn12.txt | 481861 | 43487.5 ± 0.1% | 47534.6 ± 0.2% | 0.915 | — | — |
| string: canterbury-large/E.coli | 1048576 | 36123.9 ± 5.0% | 38038.2 ± 6.7% | 0.950 | — | — |
| string: canterbury-large/bible.txt | 1048576 | 31086.6 ± 3.7% | 32201.8 ± 2.4% | 0.965 | — | — |
| string: canterbury-large/world192.txt | 1048576 | 31026.2 ± 1.6% | 32072.1 ± 1.9% | 0.967 | — | — |
| string: http/html-1m | 1048576 | 34636.2 ± 2.7% | 37096.1 ± 2.1% | 0.934 | — | — |
| string: http/json-1m | 1048576 | 29760.4 ± 5.2% | 31449.6 ± 3.1% | 0.946 | — | — |
| string: http/js-1m | 1048576 | 34819.1 ± 1.6% | 37692.6 ± 1.0% | 0.924 | — | — |
| string: http/css-1m | 1048576 | 34131.8 ± 1.3% | 36512.4 ± 1.5% | 0.935 | — | — |
| string: dickens as Cyrillic and CJK | 1847045 | 5768.4 ± 0.1% | 5651.7 ± 0.1% | 1.021 | — | — |

## Losses to simdutf

- string: silesia/dickens: stdx runs at 0.914 of simdutf.
- string: silesia/nci: stdx runs at 0.930 of simdutf.
- string: silesia/reymont: stdx runs at 0.930 of simdutf.
- string: silesia/samba: stdx runs at 0.898 of simdutf.
- string: silesia/webster: stdx runs at 0.928 of simdutf.
- string: canterbury/asyoulik.txt: stdx runs at 0.910 of simdutf.
- string: canterbury/plrabn12.txt: stdx runs at 0.915 of simdutf.
- string: http/html-1m: stdx runs at 0.934 of simdutf.
- string: http/json-1m: stdx runs at 0.946 of simdutf.
- string: http/js-1m: stdx runs at 0.924 of simdutf.
- string: http/css-1m: stdx runs at 0.935 of simdutf.

## UTF-8 validation by the buffer's offset from a 64-octet line

| Buffer | Octets | Offset | stdx, MB/s | simdutf, MB/s | stdx / simdutf | stdx with AVX2 alone, MB/s | stdx / stdx with AVX2 alone |
|---|---|---|---|---|---|---|---|
| string: canterbury-large/bible.txt | 1048576 | 0 | 36509.3 ± 2.2% | 39632.2 ± 4.3% | 0.921 | — | — |
| string: canterbury-large/bible.txt | 1048576 | 1 | 30808.3 ± 0.9% | 31803.7 ± 0.7% | 0.969 | — | — |
| string: canterbury-large/bible.txt | 1048576 | 8 | 34098.0 ± 2.4% | 36576.8 ± 2.6% | 0.932 | — | — |
| string: canterbury-large/bible.txt | 1048576 | 16 | 34590.6 ± 1.2% | 37316.1 ± 1.6% | 0.927 | — | — |
| string: canterbury-large/bible.txt | 1048576 | 32 | 34392.5 ± 1.4% | 37227.6 ± 1.7% | 0.924 | — | — |
| string: canterbury-large/bible.txt | 1048576 | 48 | 34293.7 ± 2.9% | 37049.0 ± 2.9% | 0.926 | — | — |
| string: dickens as Cyrillic and CJK | 1048576 | 0 | 5761.9 ± 0.2% | 5644.3 ± 0.2% | 1.021 | — | — |
| string: dickens as Cyrillic and CJK | 1048576 | 1 | 5756.5 ± 0.1% | 5647.3 ± 0.1% | 1.019 | — | — |
| string: dickens as Cyrillic and CJK | 1048576 | 8 | 5760.3 ± 0.3% | 5640.0 ± 0.8% | 1.021 | — | — |
| string: dickens as Cyrillic and CJK | 1048576 | 16 | 5757.5 ± 0.2% | 5640.8 ± 0.3% | 1.021 | — | — |
| string: dickens as Cyrillic and CJK | 1048576 | 32 | 5759.1 ± 0.2% | 5644.0 ± 0.2% | 1.020 | — | — |
| string: dickens as Cyrillic and CJK | 1048576 | 48 | 5755.6 ± 0.3% | 5638.5 ± 0.3% | 1.021 | — | — |

## Against the baselines

stdx with every claim on, timed beside simdjson 5.1.1, yyjson 0.13.0, Zig 0.16.0's std.json, serde_json 1.0.154 and Go's encoding/json/jsontext in the same run. Each ratio is stdx's throughput over the baseline's; below 1, the baseline is faster. stdx is built for the architecture's baseline CPU in ReleaseSafe. Each baseline is built for the same CPU, the C, C++ and Zig ones in ReleaseFast (decision 75), and simdjson picks its kernel at run time. Decoding visits every value; encoding writes each text from its tokens.

## Decoding against the baselines

Octets are the text's. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1127.4 ± 0.3% | 932.7 ± 0.7% | 1020.9 ± 0.4% | 301.0 ± 1.0% | 659.8 ± 0.2% | 308.2 ± 2.0% | 1.209 | 1.104 | 3.745 | 1.709 | 3.658 |
| qlog records, JSON text sequence | 1467503 | 838.1 ± 1.7% | 816.8 ± 0.1% | 757.6 ± 3.3% | 243.1 ± 0.5% | 677.4 ± 2.0% | 239.4 ± 3.2% | 1.026 | 1.106 | 3.447 | 1.237 | 3.501 |
| string: silesia/dickens | 172528 | 5032.6 ± 0.3% | 1877.7 ± 0.2% | 2645.6 ± 0.2% | 361.5 ± 0.9% | 2838.3 ± 0.3% | 545.0 ± 4.7% | 2.680 | 1.902 | 13.922 | 1.773 | 9.234 |
| string: silesia/nci | 1075110 | 4270.6 ± 0.6% | 2236.6 ± 0.2% | 2992.3 ± 0.5% | 544.0 ± 1.2% | 2985.8 ± 0.5% | 584.6 ± 6.0% | 1.909 | 1.427 | 7.850 | 1.430 | 7.306 |
| string: silesia/reymont | 1075159 | 2911.9 ± 2.2% | 1804.3 ± 2.1% | 2059.8 ± 0.2% | 376.6 ± 0.8% | 2139.4 ± 0.3% | 530.0 ± 1.0% | 1.614 | 1.414 | 7.731 | 1.361 | 5.494 |
| string: silesia/samba | 97582 | 3491.4 ± 0.4% | 2025.6 ± 0.1% | 2618.7 ± 0.2% | 328.1 ± 0.2% | 1496.0 ± 1.0% | 423.0 ± 1.1% | 1.724 | 1.333 | 10.641 | 2.334 | 8.255 |
| string: silesia/webster | 1098490 | 3637.7 ± 0.3% | 1518.1 ± 0.3% | 2011.4 ± 0.8% | 359.1 ± 0.3% | 2168.1 ± 0.7% | 480.3 ± 2.1% | 2.396 | 1.809 | 10.130 | 1.678 | 7.574 |
| string: silesia/xml | 1090118 | 4740.0 ± 1.9% | 2356.0 ± 0.4% | 2524.2 ± 0.5% | 453.3 ± 1.7% | 2857.7 ± 2.9% | 547.2 ± 6.1% | 2.012 | 1.878 | 10.457 | 1.659 | 8.662 |
| string: canterbury/alice29.txt | 159425 | 4311.5 ± 0.4% | 1599.6 ± 0.4% | 2458.5 ± 0.5% | 341.9 ± 0.9% | 2493.7 ± 0.6% | 503.4 ± 1.4% | 2.695 | 1.754 | 12.610 | 1.729 | 8.565 |
| string: canterbury/asyoulik.txt | 132198 | 3449.1 ± 0.4% | 1458.4 ± 0.2% | 2246.4 ± 0.9% | 334.9 ± 0.5% | 2072.0 ± 0.4% | 457.2 ± 0.6% | 2.365 | 1.535 | 10.299 | 1.665 | 7.544 |
| string: canterbury/lcet10.txt | 441884 | 5103.7 ± 0.4% | 1853.4 ± 0.2% | 2334.3 ± 1.2% | 390.7 ± 0.3% | 2809.8 ± 0.4% | 523.7 ± 1.4% | 2.754 | 2.186 | 13.064 | 1.816 | 9.745 |
| string: canterbury/plrabn12.txt | 503330 | 4116.6 ± 0.6% | 1736.1 ± 0.1% | 2054.5 ± 0.3% | 360.2 ± 1.3% | 2486.4 ± 0.6% | 493.2 ± 0.5% | 2.371 | 2.004 | 11.430 | 1.656 | 8.347 |
| string: canterbury-large/E.coli | 1048578 | 19030.6 ± 0.6% | 3610.6 ± 0.2% | 3248.1 ± 0.3% | 927.7 ± 1.8% | 6048.3 ± 1.8% | 739.5 ± 1.4% | 5.271 | 5.859 | 20.513 | 3.146 | 25.735 |
| string: canterbury-large/bible.txt | 1055886 | 6639.4 ± 1.3% | 2935.6 ± 0.5% | 2828.0 ± 0.8% | 419.0 ± 2.5% | 3733.7 ± 4.6% | 600.7 ± 2.8% | 2.262 | 2.348 | 15.846 | 1.778 | 11.053 |
| string: canterbury-large/world192.txt | 1103121 | 3387.9 ± 0.3% | 1483.2 ± 0.1% | 2007.4 ± 0.3% | 352.4 ± 0.2% | 2117.3 ± 0.5% | 488.7 ± 2.6% | 2.284 | 1.688 | 9.615 | 1.600 | 6.933 |
| string: http/html-1m | 1058582 | 6053.6 ± 7.0% | 2733.8 ± 0.3% | 2701.9 ± 0.2% | 440.9 ± 0.5% | 3470.5 ± 1.1% | 593.5 ± 5.0% | 2.214 | 2.240 | 13.730 | 1.744 | 10.199 |
| string: http/json-1m | 1190272 | 2550.3 ± 0.3% | 877.9 ± 0.3% | 2246.3 ± 0.2% | 390.4 ± 0.6% | 1063.6 ± 0.3% | 441.1 ± 0.4% | 2.905 | 1.135 | 6.533 | 2.398 | 5.782 |
| string: http/js-1m | 1144362 | 2282.9 ± 0.2% | 1028.5 ± 0.2% | 1638.0 ± 0.4% | 320.7 ± 0.6% | 1524.9 ± 0.7% | 417.3 ± 0.6% | 2.220 | 1.394 | 7.119 | 1.497 | 5.471 |
| string: http/css-1m | 1097820 | 2635.7 ± 0.7% | 1679.1 ± 0.3% | 2219.7 ± 0.9% | 405.2 ± 1.0% | 1962.3 ± 0.7% | 488.8 ± 0.1% | 1.570 | 1.187 | 6.504 | 1.343 | 5.393 |
| string: dickens as Cyrillic and CJK | 1883069 | 3070.7 ± 0.8% | 1683.7 ± 0.4% | 894.2 ± 0.6% | 351.4 ± 0.1% | 669.9 ± 1.5% | 157.0 ± 3.1% | 1.824 | 3.434 | 8.739 | 4.584 | 19.557 |
| string: dickens as Cyrillic and CJK, as \u escapes | 5075485 | 1327.6 ± 2.2% | 980.4 ± 0.2% | 1201.8 ± 0.5% | 216.0 ± 0.3% | 469.4 ± 0.2% | 255.7 ± 3.9% | 1.354 | 1.105 | 6.147 | 2.828 | 5.193 |
| hex: silesia/dickens | 524290 | 18497.6 ± 1.1% | 3615.8 ± 0.2% | 3288.5 ± 0.2% | 505.5 ± 0.9% | 6021.4 ± 2.3% | 779.3 ± 2.5% | 5.116 | 5.625 | 36.591 | 3.072 | 23.736 |
| hex: silesia/mozilla | 524290 | 18165.6 ± 0.8% | 3621.4 ± 0.2% | 3292.5 ± 0.3% | 447.9 ± 0.4% | 6100.0 ± 2.1% | 780.7 ± 0.4% | 5.016 | 5.517 | 40.556 | 2.978 | 23.268 |
| hex: silesia/mr | 524290 | 18184.1 ± 1.7% | 3618.2 ± 0.1% | 3297.6 ± 0.2% | 569.2 ± 2.3% | 6065.8 ± 1.1% | 779.9 ± 0.6% | 5.026 | 5.514 | 31.945 | 2.998 | 23.315 |
| hex: silesia/nci | 524290 | 18436.3 ± 0.6% | 3617.7 ± 0.2% | 3291.4 ± 0.4% | 615.1 ± 1.0% | 6108.3 ± 1.1% | 778.8 ± 0.3% | 5.096 | 5.601 | 29.975 | 3.018 | 23.674 |
| hex: silesia/ooffice | 524290 | 18530.2 ± 1.4% | 3618.0 ± 0.4% | 3294.2 ± 0.2% | 397.8 ± 0.9% | 6080.1 ± 1.7% | 779.0 ± 0.3% | 5.122 | 5.625 | 46.583 | 3.048 | 23.788 |
| hex: silesia/osdb | 524290 | 18077.2 ± 2.9% | 3617.8 ± 0.3% | 3294.8 ± 0.4% | 482.1 ± 1.9% | 6077.6 ± 1.5% | 778.3 ± 2.5% | 4.997 | 5.487 | 37.494 | 2.974 | 23.225 |
| hex: silesia/reymont | 524290 | 18652.3 ± 1.5% | 3617.8 ± 0.1% | 3284.9 ± 0.3% | 512.2 ± 0.7% | 6004.4 ± 1.4% | 778.8 ± 0.5% | 5.156 | 5.678 | 36.415 | 3.106 | 23.949 |
| hex: silesia/samba | 524290 | 17906.3 ± 1.0% | 3617.9 ± 0.3% | 3291.2 ± 0.5% | 407.8 ± 0.8% | 6126.0 ± 0.8% | 778.3 ± 0.5% | 4.949 | 5.441 | 43.908 | 2.923 | 23.007 |
| hex: silesia/sao | 524290 | 18545.8 ± 1.3% | 3618.3 ± 0.2% | 3285.3 ± 0.4% | 344.6 ± 0.7% | 6040.2 ± 1.1% | 779.9 ± 1.1% | 5.126 | 5.645 | 53.815 | 3.070 | 23.780 |
| hex: silesia/webster | 524290 | 18420.6 ± 1.3% | 3620.6 ± 0.2% | 3294.6 ± 0.2% | 455.6 ± 2.5% | 6129.4 ± 1.9% | 780.2 ± 0.4% | 5.088 | 5.591 | 40.432 | 3.005 | 23.611 |
| hex: silesia/x-ray | 524290 | 18345.2 ± 4.5% | 3615.9 ± 0.8% | 3294.7 ± 0.3% | 470.0 ± 1.2% | 6036.5 ± 2.2% | 779.5 ± 2.6% | 5.074 | 5.568 | 39.032 | 3.039 | 23.534 |
| hex: silesia/xml | 524290 | 18550.5 ± 1.0% | 3618.1 ± 0.2% | 3288.8 ± 0.3% | 519.2 ± 0.6% | 6122.6 ± 1.6% | 780.0 ± 0.8% | 5.127 | 5.641 | 35.728 | 3.030 | 23.784 |
| hex: canterbury/alice29.txt | 304180 | 19139.1 ± 1.6% | 3628.2 ± 0.1% | 3370.9 ± 0.1% | 506.8 ± 0.7% | 6097.6 ± 1.5% | 779.0 ± 1.3% | 5.275 | 5.678 | 37.765 | 3.139 | 24.569 |
| hex: canterbury/asyoulik.txt | 250360 | 19528.8 ± 0.1% | 3639.6 ± 0.1% | 3363.2 ± 0.2% | 498.5 ± 0.9% | 6107.6 ± 1.3% | 778.6 ± 0.2% | 5.366 | 5.807 | 39.179 | 3.197 | 25.081 |
| hex: canterbury/cp.html | 49208 | 19295.0 ± 0.3% | 3640.3 ± 0.0% | 3287.3 ± 0.4% | 461.2 ± 1.2% | 6270.7 ± 0.3% | 765.5 ± 1.2% | 5.300 | 5.870 | 41.839 | 3.077 | 25.207 |
| hex: canterbury/fields.c | 22302 | 18890.5 ± 0.8% | 3629.3 ± 0.0% | 3356.7 ± 0.1% | 498.0 ± 1.3% | 6257.9 ± 0.7% | 754.5 ± 1.9% | 5.205 | 5.628 | 37.935 | 3.019 | 25.036 |
| hex: canterbury/grammar.lsp | 7444 | 17449.9 ± 0.5% | 3601.2 ± 0.0% | 3354.9 ± 0.4% | 529.8 ± 3.0% | 6179.5 ± 0.7% | 716.3 ± 0.5% | 4.846 | 5.201 | 32.935 | 2.824 | 24.361 |
| hex: canterbury/kennedy.xls | 524290 | 18458.4 ± 2.8% | 3608.2 ± 0.5% | 3289.0 ± 0.3% | 656.2 ± 7.8% | 6159.1 ± 1.5% | 766.8 ± 5.9% | 5.116 | 5.612 | 28.131 | 2.997 | 24.071 |
| hex: canterbury/lcet10.txt | 524290 | 18030.2 ± 1.5% | 3610.8 ± 0.3% | 3283.7 ± 0.2% | 513.9 ± 0.5% | 6066.6 ± 0.9% | 766.6 ± 0.6% | 4.993 | 5.491 | 35.085 | 2.972 | 23.519 |
| hex: canterbury/plrabn12.txt | 524290 | 18013.9 ± 1.2% | 3612.8 ± 0.6% | 3281.0 ± 1.1% | 502.6 ± 1.6% | 6072.2 ± 1.2% | 764.6 ± 1.1% | 4.986 | 5.490 | 35.841 | 2.967 | 23.559 |
| hex: canterbury/ptt5 | 524290 | 18247.8 ± 0.5% | 3611.8 ± 0.4% | 3291.2 ± 0.1% | 562.0 ± 1.5% | 6149.2 ± 1.1% | 766.1 ± 0.7% | 5.052 | 5.544 | 32.471 | 2.967 | 23.820 |
| hex: canterbury/sum | 76482 | 19266.6 ± 0.3% | 3634.1 ± 0.0% | 3362.7 ± 0.3% | 508.9 ± 1.0% | 6196.0 ± 0.8% | 768.6 ± 1.4% | 5.302 | 5.729 | 37.863 | 3.110 | 25.067 |
| hex: canterbury/xargs.1 | 8456 | 17809.3 ± 1.1% | 3602.9 ± 0.1% | 3368.0 ± 0.1% | 492.6 ± 0.8% | 6146.9 ± 0.5% | 747.0 ± 0.9% | 4.943 | 5.288 | 36.153 | 2.897 | 23.841 |
| hex: canterbury-large/E.coli | 524290 | 18194.5 ± 1.0% | 3612.8 ± 0.2% | 3277.2 ± 0.3% | 687.9 ± 0.2% | 6043.0 ± 1.2% | 779.1 ± 4.7% | 5.036 | 5.552 | 26.449 | 3.011 | 23.352 |
| hex: canterbury-large/bible.txt | 524290 | 18264.0 ± 0.9% | 3617.3 ± 0.1% | 3299.3 ± 0.3% | 523.6 ± 1.4% | 6092.9 ± 1.2% | 780.6 ± 0.4% | 5.049 | 5.536 | 34.879 | 2.998 | 23.397 |
| hex: canterbury-large/world192.txt | 524290 | 17888.1 ± 4.2% | 3615.8 ± 0.1% | 3289.3 ± 0.7% | 494.6 ± 0.6% | 6122.0 ± 1.0% | 779.7 ± 0.6% | 4.947 | 5.438 | 36.164 | 2.922 | 22.943 |
| hex: http/html-1kx1024 | 2099200 | 9088.6 ± 18.5% | 3460.6 ± 0.1% | 2845.5 ± 0.7% | 475.2 ± 0.5% | 5052.8 ± 1.3% | 638.8 ± 3.7% | 2.626 | 3.194 | 19.127 | 1.799 | 14.229 |
| hex: http/html-16kx64 | 2097280 | 17774.5 ± 1.6% | 3609.9 ± 0.1% | 3260.0 ± 0.5% | 476.4 ± 2.3% | 6024.7 ± 0.8% | 753.0 ± 2.7% | 4.924 | 5.452 | 37.310 | 2.950 | 23.604 |
| hex: http/html-1m | 524290 | 18056.7 ± 0.8% | 3611.6 ± 0.3% | 3280.5 ± 0.2% | 496.6 ± 2.5% | 6083.7 ± 0.4% | 781.7 ± 1.5% | 5.000 | 5.504 | 36.363 | 2.968 | 23.101 |
| hex: http/json-1kx1024 | 2099200 | 10407.9 ± 10.8% | 3460.3 ± 0.2% | 2841.9 ± 0.4% | 576.5 ± 0.5% | 5193.0 ± 1.1% | 645.0 ± 0.9% | 3.008 | 3.662 | 18.054 | 2.004 | 16.136 |
| hex: http/json-16kx64 | 2097280 | 17912.6 ± 0.5% | 3609.5 ± 0.1% | 3258.5 ± 0.3% | 574.5 ± 1.3% | 6021.4 ± 0.5% | 755.0 ± 1.9% | 4.963 | 5.497 | 31.179 | 2.975 | 23.726 |
| hex: http/json-1m | 524290 | 18114.7 ± 0.9% | 3613.4 ± 0.2% | 3281.9 ± 0.3% | 591.7 ± 1.6% | 5991.3 ± 1.1% | 778.8 ± 1.0% | 5.013 | 5.520 | 30.613 | 3.024 | 23.260 |
| hex: http/js-1kx1024 | 2099200 | 9192.8 ± 17.7% | 3463.9 ± 0.1% | 2844.3 ± 0.8% | 481.3 ± 1.2% | 5107.4 ± 0.8% | 648.2 ± 1.9% | 2.654 | 3.232 | 19.102 | 1.800 | 14.182 |
| hex: http/js-16kx64 | 2097280 | 17704.2 ± 0.3% | 3611.1 ± 0.2% | 3262.4 ± 0.2% | 479.9 ± 1.2% | 6012.9 ± 0.9% | 753.3 ± 2.1% | 4.903 | 5.427 | 36.888 | 2.944 | 23.502 |
| hex: http/js-1m | 524290 | 18312.2 ± 1.2% | 3607.9 ± 0.1% | 3295.0 ± 0.2% | 498.9 ± 0.8% | 6050.4 ± 1.2% | 781.1 ± 1.3% | 5.076 | 5.558 | 36.703 | 3.027 | 23.444 |
| hex: http/css-1kx1024 | 2099200 | 9455.9 ± 12.9% | 3464.0 ± 0.2% | 2854.1 ± 0.9% | 487.0 ± 0.9% | 5111.2 ± 2.1% | 640.0 ± 2.3% | 2.730 | 3.313 | 19.417 | 1.850 | 14.775 |
| hex: http/css-16kx64 | 2097280 | 17911.5 ± 2.0% | 3608.1 ± 0.1% | 3268.0 ± 0.4% | 494.5 ± 0.9% | 6019.9 ± 0.6% | 751.1 ± 2.4% | 4.964 | 5.481 | 36.223 | 2.975 | 23.847 |
| hex: http/css-1m | 524290 | 18390.0 ± 1.7% | 3610.8 ± 0.2% | 3298.6 ± 0.2% | 492.4 ± 1.9% | 6117.3 ± 2.2% | 757.0 ± 2.4% | 5.093 | 5.575 | 37.346 | 3.006 | 24.292 |
| hex: shuffled/dickens-1m | 524290 | 17980.8 ± 0.6% | 3609.5 ± 1.4% | 3288.1 ± 1.4% | 512.5 ± 1.6% | 6116.6 ± 0.7% | 780.6 ± 1.1% | 4.981 | 5.469 | 35.082 | 2.940 | 23.034 |

## Encoding against the baselines

Octets are the ones stdx writes. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1484.6 ± 0.5% | 1251.7 ± 0.2% | 1038.0 ± 0.8% | 409.2 ± 0.4% | 448.2 ± 0.3% | 414.6 ± 0.5% | 1.186 | 1.430 | 3.628 | 3.312 | 3.581 |
| qlog records, JSON text sequence | 1467503 | 1267.6 ± 1.6% | 1064.3 ± 0.2% | 781.0 ± 2.6% | 377.5 ± 0.9% | 468.2 ± 0.5% | 278.8 ± 0.2% | 1.191 | 1.623 | 3.358 | 2.708 | 4.547 |
| string: silesia/dickens | 172528 | 6898.5 ± 0.3% | 2814.3 ± 0.5% | 2936.2 ± 0.5% | 429.4 ± 0.5% | 1592.6 ± 0.2% | 1011.1 ± 0.2% | 2.451 | 2.349 | 16.064 | 4.331 | 6.823 |
| string: silesia/nci | 1075110 | 7290.9 ± 0.8% | 3382.6 ± 1.1% | 3100.4 ± 0.3% | 803.9 ± 1.5% | 1862.1 ± 0.3% | 1106.5 ± 0.9% | 2.155 | 2.352 | 9.070 | 3.915 | 6.589 |
| string: silesia/reymont | 1075159 | 3311.2 ± 1.3% | 1984.9 ± 0.9% | 2058.4 ± 0.6% | 449.0 ± 0.5% | 1508.6 ± 0.2% | 947.7 ± 0.6% | 1.668 | 1.609 | 7.375 | 2.195 | 3.494 |
| string: silesia/samba | 97582 | 4187.4 ± 1.2% | 2114.2 ± 0.6% | 3449.9 ± 0.5% | 355.0 ± 1.5% | 1436.8 ± 0.3% | 1054.4 ± 0.2% | 1.981 | 1.214 | 11.794 | 2.914 | 3.971 |
| string: silesia/webster | 1098490 | 4050.2 ± 0.3% | 1877.2 ± 0.4% | 2059.9 ± 1.0% | 441.2 ± 0.5% | 1393.9 ± 0.5% | 646.6 ± 0.5% | 2.158 | 1.966 | 9.180 | 2.906 | 6.264 |
| string: silesia/xml | 1090118 | 6107.0 ± 0.5% | 2863.1 ± 0.7% | 2647.2 ± 0.6% | 610.5 ± 0.7% | 1752.8 ± 0.3% | 922.3 ± 0.6% | 2.133 | 2.307 | 10.003 | 3.484 | 6.622 |
| string: canterbury/alice29.txt | 159425 | 6428.0 ± 2.9% | 2192.0 ± 0.6% | 2743.5 ± 0.6% | 406.7 ± 0.7% | 1476.7 ± 0.5% | 953.0 ± 0.7% | 2.933 | 2.343 | 15.805 | 4.353 | 6.745 |
| string: canterbury/asyoulik.txt | 132198 | 5570.7 ± 4.6% | 1714.4 ± 0.7% | 2377.9 ± 1.4% | 403.0 ± 0.5% | 1347.7 ± 0.4% | 884.2 ± 0.2% | 3.249 | 2.343 | 13.822 | 4.133 | 6.300 |
| string: canterbury/lcet10.txt | 441884 | 6241.2 ± 0.9% | 2541.1 ± 0.4% | 2461.2 ± 2.4% | 467.6 ± 0.9% | 1539.8 ± 0.3% | 986.1 ± 0.5% | 2.456 | 2.536 | 13.347 | 4.053 | 6.329 |
| string: canterbury/plrabn12.txt | 503330 | 5713.5 ± 0.3% | 2048.5 ± 0.3% | 2067.1 ± 0.4% | 422.8 ± 0.4% | 1425.9 ± 0.3% | 930.8 ± 0.3% | 2.789 | 2.764 | 13.515 | 4.007 | 6.138 |
| string: canterbury-large/E.coli | 1048578 | 19198.3 ± 0.6% | 9718.3 ± 1.4% | 3789.0 ± 0.8% | 1477.8 ± 0.3% | 2362.6 ± 0.6% | 1195.2 ± 0.3% | 1.975 | 5.067 | 12.991 | 8.126 | 16.063 |
| string: canterbury-large/bible.txt | 1055886 | 6796.3 ± 0.6% | 4143.9 ± 1.4% | 3020.4 ± 1.7% | 500.1 ± 1.1% | 1970.5 ± 0.5% | 1119.8 ± 1.5% | 1.640 | 2.250 | 13.591 | 3.449 | 6.069 |
| string: canterbury-large/world192.txt | 1103121 | 4018.7 ± 0.7% | 1652.7 ± 0.4% | 1998.4 ± 0.4% | 448.0 ± 0.3% | 1359.6 ± 0.2% | 907.9 ± 0.3% | 2.432 | 2.011 | 8.970 | 2.956 | 4.426 |
| string: http/html-1m | 1058582 | 6744.6 ± 0.7% | 3974.3 ± 0.5% | 3046.2 ± 0.5% | 500.1 ± 0.4% | 1918.3 ± 0.5% | 804.9 ± 0.4% | 1.697 | 2.214 | 13.487 | 3.516 | 8.379 |
| string: http/json-1m | 1190272 | 3165.0 ± 0.6% | 1344.6 ± 0.3% | 1555.7 ± 0.3% | 444.1 ± 0.6% | 961.3 ± 0.2% | 764.4 ± 0.6% | 2.354 | 2.035 | 7.126 | 3.293 | 4.140 |
| string: http/js-1m | 1144362 | 2758.5 ± 0.6% | 1177.8 ± 0.3% | 1628.0 ± 0.4% | 368.7 ± 0.1% | 1095.1 ± 0.2% | 757.4 ± 0.4% | 2.342 | 1.694 | 7.482 | 2.519 | 3.642 |
| string: http/css-1m | 1097820 | 3979.3 ± 0.7% | 1482.1 ± 0.6% | 2152.0 ± 0.5% | 493.8 ± 0.7% | 1371.5 ± 0.4% | 895.3 ± 0.5% | 2.685 | 1.849 | 8.059 | 2.901 | 4.445 |
| string: dickens as Cyrillic and CJK | 1883069 | 3060.4 ± 0.3% | 2343.7 ± 0.4% | 521.4 ± 0.3% | 306.9 ± 0.7% | 559.5 ± 1.6% | 335.9 ± 0.6% | 1.306 | 5.869 | 9.972 | 5.469 | 9.111 |
| hex: silesia/dickens | 524290 | 15650.9 ± 0.2% | 1461.8 ± 0.2% | 1084.4 ± 0.3% | 497.5 ± 0.6% | 988.5 ± 0.3% | 733.1 ± 0.6% | 10.706 | 14.432 | 31.458 | 15.833 | 21.349 |
| hex: silesia/mozilla | 524290 | 15638.0 ± 0.2% | 1473.6 ± 0.2% | 1087.5 ± 0.4% | 442.1 ± 0.7% | 991.4 ± 0.2% | 734.6 ± 0.4% | 10.612 | 14.380 | 35.374 | 15.774 | 21.287 |
| hex: silesia/mr | 524290 | 15616.2 ± 0.2% | 1481.2 ± 0.7% | 1090.5 ± 0.7% | 558.5 ± 1.0% | 995.4 ± 0.6% | 734.3 ± 0.3% | 10.543 | 14.321 | 27.963 | 15.688 | 21.266 |
| hex: silesia/nci | 524290 | 15629.4 ± 0.1% | 1469.4 ± 0.8% | 1087.6 ± 0.7% | 639.6 ± 4.2% | 992.5 ± 0.6% | 732.6 ± 0.2% | 10.637 | 14.370 | 24.435 | 15.748 | 21.334 |
| hex: silesia/ooffice | 524290 | 15605.4 ± 0.2% | 1460.6 ± 2.5% | 1083.9 ± 0.8% | 389.2 ± 0.5% | 990.6 ± 1.2% | 733.8 ± 1.3% | 10.684 | 14.398 | 40.098 | 15.753 | 21.267 |
| hex: silesia/osdb | 524290 | 15628.9 ± 0.6% | 1467.1 ± 1.2% | 1085.9 ± 1.1% | 467.1 ± 0.7% | 989.6 ± 0.7% | 734.3 ± 0.3% | 10.653 | 14.393 | 33.460 | 15.793 | 21.285 |
| hex: silesia/reymont | 524290 | 15632.3 ± 0.1% | 1460.9 ± 0.5% | 1085.8 ± 0.3% | 515.2 ± 1.3% | 990.1 ± 0.7% | 734.8 ± 0.4% | 10.700 | 14.396 | 30.344 | 15.789 | 21.275 |
| hex: silesia/samba | 524290 | 15630.6 ± 0.1% | 1464.1 ± 0.7% | 1082.8 ± 0.6% | 402.4 ± 0.6% | 990.0 ± 0.6% | 733.2 ± 0.4% | 10.676 | 14.436 | 38.848 | 15.788 | 21.319 |
| hex: silesia/sao | 524290 | 15649.8 ± 0.2% | 1464.1 ± 0.4% | 1084.6 ± 0.5% | 332.3 ± 0.3% | 991.3 ± 0.5% | 733.8 ± 0.4% | 10.689 | 14.429 | 47.093 | 15.788 | 21.327 |
| hex: silesia/webster | 524290 | 15663.5 ± 0.3% | 1462.9 ± 0.3% | 1084.8 ± 0.4% | 472.8 ± 0.4% | 989.2 ± 0.6% | 732.8 ± 0.7% | 10.707 | 14.440 | 33.131 | 15.834 | 21.375 |
| hex: silesia/x-ray | 524290 | 15620.6 ± 0.3% | 1474.6 ± 0.3% | 1088.3 ± 0.2% | 444.1 ± 0.9% | 996.8 ± 0.5% | 734.3 ± 0.5% | 10.593 | 14.353 | 35.174 | 15.671 | 21.272 |
| hex: silesia/xml | 524290 | 15628.6 ± 0.2% | 1467.4 ± 0.4% | 1085.5 ± 0.2% | 609.3 ± 1.4% | 991.4 ± 0.8% | 734.8 ± 0.4% | 10.650 | 14.398 | 25.650 | 15.765 | 21.269 |
| hex: canterbury/alice29.txt | 304180 | 15679.8 ± 0.0% | 1470.7 ± 0.5% | 1090.4 ± 0.3% | 501.6 ± 0.3% | 993.8 ± 0.5% | 735.4 ± 0.4% | 10.662 | 14.380 | 31.261 | 15.777 | 21.321 |
| hex: canterbury/asyoulik.txt | 250360 | 15700.6 ± 0.1% | 1475.1 ± 0.4% | 1093.1 ± 0.4% | 497.3 ± 1.3% | 994.2 ± 0.3% | 739.0 ± 0.8% | 10.644 | 14.363 | 31.571 | 15.793 | 21.246 |
| hex: canterbury/cp.html | 49208 | 15621.1 ± 0.1% | 1474.7 ± 0.3% | 1098.2 ± 0.2% | 528.4 ± 2.1% | 1000.9 ± 0.5% | 743.9 ± 0.2% | 10.593 | 14.224 | 29.560 | 15.607 | 20.999 |
| hex: canterbury/fields.c | 22302 | 15426.9 ± 0.2% | 1423.2 ± 0.2% | 1068.0 ± 0.4% | 630.4 ± 5.4% | 987.9 ± 0.2% | 736.5 ± 0.3% | 10.840 | 14.444 | 24.471 | 15.616 | 20.945 |
| hex: canterbury/grammar.lsp | 7444 | 14936.7 ± 0.1% | 1491.0 ± 0.4% | 1094.0 ± 0.4% | 659.3 ± 5.0% | 988.1 ± 1.0% | 726.2 ± 0.4% | 10.018 | 13.653 | 22.657 | 15.116 | 20.569 |
| hex: canterbury/kennedy.xls | 524290 | 15614.7 ± 0.8% | 1471.1 ± 0.6% | 1088.5 ± 0.5% | 658.0 ± 2.0% | 989.8 ± 0.4% | 733.4 ± 0.4% | 10.614 | 14.345 | 23.731 | 15.776 | 21.290 |
| hex: canterbury/lcet10.txt | 524290 | 15594.5 ± 0.2% | 1460.1 ± 1.4% | 1085.6 ± 2.0% | 497.1 ± 2.6% | 988.4 ± 0.4% | 733.8 ± 0.1% | 10.680 | 14.365 | 31.371 | 15.778 | 21.251 |
| hex: canterbury/plrabn12.txt | 524290 | 15593.8 ± 0.2% | 1458.3 ± 0.6% | 1085.1 ± 0.4% | 484.9 ± 2.7% | 988.9 ± 0.5% | 731.7 ± 0.6% | 10.693 | 14.370 | 32.157 | 15.768 | 21.311 |
| hex: canterbury/ptt5 | 524290 | 15598.9 ± 0.5% | 1478.2 ± 0.3% | 1092.3 ± 0.3% | 553.5 ± 0.7% | 990.8 ± 0.3% | 733.0 ± 0.8% | 10.552 | 14.281 | 28.182 | 15.743 | 21.281 |
| hex: canterbury/sum | 76482 | 15641.1 ± 0.1% | 1494.9 ± 0.2% | 1105.0 ± 0.1% | 594.2 ± 2.0% | 998.4 ± 0.1% | 743.9 ± 0.9% | 10.463 | 14.155 | 26.324 | 15.667 | 21.025 |
| hex: canterbury/xargs.1 | 8456 | 14987.6 ± 0.1% | 1431.7 ± 1.4% | 1092.8 ± 0.6% | 640.7 ± 5.4% | 1000.9 ± 0.2% | 726.9 ± 0.5% | 10.468 | 13.715 | 23.391 | 14.974 | 20.618 |
| hex: canterbury-large/E.coli | 524290 | 15654.1 ± 0.2% | 1471.0 ± 0.0% | 1089.1 ± 0.7% | 671.8 ± 0.2% | 993.2 ± 0.5% | 733.0 ± 0.9% | 10.642 | 14.373 | 23.301 | 15.761 | 21.355 |
| hex: canterbury-large/bible.txt | 524290 | 15616.7 ± 0.4% | 1461.9 ± 0.4% | 1085.3 ± 0.5% | 512.6 ± 1.2% | 986.8 ± 0.3% | 733.1 ± 0.3% | 10.683 | 14.389 | 30.463 | 15.825 | 21.302 |
| hex: canterbury-large/world192.txt | 524290 | 15596.7 ± 0.3% | 1462.0 ± 0.6% | 1083.2 ± 1.5% | 501.2 ± 1.0% | 989.5 ± 1.0% | 731.4 ± 1.5% | 10.668 | 14.398 | 31.116 | 15.763 | 21.324 |
| hex: http/html-1kx1024 | 2099200 | 13655.8 ± 1.6% | 1454.7 ± 0.2% | 1062.4 ± 0.2% | 501.6 ± 0.5% | 982.7 ± 0.2% | 692.0 ± 0.2% | 9.387 | 12.854 | 27.225 | 13.897 | 19.733 |
| hex: http/html-16kx64 | 2097280 | 15216.6 ± 0.2% | 1442.9 ± 0.3% | 1075.0 ± 0.2% | 506.0 ± 0.4% | 995.1 ± 0.1% | 733.6 ± 0.3% | 10.546 | 14.155 | 30.070 | 15.291 | 20.743 |
| hex: http/html-1m | 524290 | 15634.7 ± 0.2% | 1468.5 ± 1.1% | 1084.8 ± 0.6% | 499.9 ± 1.0% | 989.2 ± 0.4% | 733.5 ± 0.6% | 10.647 | 14.412 | 31.278 | 15.805 | 21.314 |
| hex: http/json-1kx1024 | 2099200 | 13620.3 ± 8.7% | 1461.8 ± 0.2% | 1066.1 ± 0.3% | 607.3 ± 0.8% | 986.4 ± 0.4% | 692.1 ± 0.4% | 9.318 | 12.776 | 22.429 | 13.808 | 19.681 |
| hex: http/json-16kx64 | 2097280 | 15226.0 ± 0.3% | 1445.6 ± 0.2% | 1074.6 ± 0.2% | 616.7 ± 0.4% | 994.5 ± 0.3% | 734.6 ± 0.1% | 10.533 | 14.169 | 24.690 | 15.310 | 20.727 |
| hex: http/json-1m | 524290 | 15613.6 ± 0.2% | 1470.3 ± 0.4% | 1089.0 ± 0.3% | 637.2 ± 1.0% | 994.2 ± 0.3% | 733.7 ± 0.3% | 10.619 | 14.337 | 24.503 | 15.704 | 21.281 |
| hex: http/js-1kx1024 | 2099200 | 13601.7 ± 0.5% | 1454.3 ± 0.2% | 1063.9 ± 0.4% | 499.3 ± 0.3% | 983.2 ± 0.3% | 692.5 ± 0.1% | 9.352 | 12.784 | 27.242 | 13.834 | 19.643 |
| hex: http/js-16kx64 | 2097280 | 15210.4 ± 0.6% | 1445.0 ± 0.3% | 1074.6 ± 0.3% | 503.5 ± 0.5% | 993.8 ± 0.6% | 735.0 ± 0.2% | 10.526 | 14.154 | 30.208 | 15.305 | 20.696 |
| hex: http/js-1m | 524290 | 15630.0 ± 0.2% | 1463.1 ± 0.7% | 1085.6 ± 0.4% | 508.7 ± 0.3% | 992.3 ± 0.4% | 733.6 ± 0.4% | 10.683 | 14.398 | 30.725 | 15.751 | 21.306 |
| hex: http/css-1kx1024 | 2099200 | 13596.9 ± 0.6% | 1455.2 ± 0.2% | 1063.0 ± 0.1% | 530.7 ± 0.3% | 983.1 ± 0.4% | 692.0 ± 0.9% | 9.344 | 12.791 | 25.623 | 13.831 | 19.649 |
| hex: http/css-16kx64 | 2097280 | 15209.2 ± 0.3% | 1442.2 ± 0.1% | 1073.6 ± 0.2% | 540.4 ± 0.2% | 998.9 ± 0.6% | 734.3 ± 0.2% | 10.546 | 14.166 | 28.145 | 15.227 | 20.712 |
| hex: http/css-1m | 524290 | 15663.4 ± 0.3% | 1462.8 ± 0.3% | 1085.2 ± 0.9% | 525.4 ± 0.6% | 986.8 ± 0.7% | 733.2 ± 0.4% | 10.707 | 14.434 | 29.812 | 15.872 | 21.363 |
| hex: shuffled/dickens-1m | 524290 | 15642.5 ± 0.2% | 1464.8 ± 0.4% | 1084.7 ± 0.2% | 501.2 ± 0.4% | 989.2 ± 0.6% | 732.6 ± 0.2% | 10.679 | 14.422 | 31.212 | 15.813 | 21.351 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1524.1 ± 0.6% | 1251.7 ± 0.2% | 1038.0 ± 0.8% | 409.2 ± 0.4% | 448.2 ± 0.3% | 414.6 ± 0.5% | 1.218 | 1.468 | 3.724 | 3.401 | 3.676 |
| qlog records, JSON text sequence | 1467503 | 1294.1 ± 0.3% | 1064.3 ± 0.2% | 781.0 ± 2.6% | 377.5 ± 0.9% | 468.2 ± 0.5% | 278.8 ± 0.2% | 1.216 | 1.657 | 3.428 | 2.764 | 4.642 |
| string: silesia/dickens | 172528 | 7131.2 ± 0.4% | 2814.3 ± 0.5% | 2936.2 ± 0.5% | 429.4 ± 0.5% | 1592.6 ± 0.2% | 1011.1 ± 0.2% | 2.534 | 2.429 | 16.606 | 4.478 | 7.053 |
| string: silesia/nci | 1075110 | 7365.7 ± 7.1% | 3382.6 ± 1.1% | 3100.4 ± 0.3% | 803.9 ± 1.5% | 1862.1 ± 0.3% | 1106.5 ± 0.9% | 2.178 | 2.376 | 9.163 | 3.956 | 6.657 |
| string: silesia/reymont | 1075159 | 3508.1 ± 1.6% | 1984.9 ± 0.9% | 2058.4 ± 0.6% | 449.0 ± 0.5% | 1508.6 ± 0.2% | 947.7 ± 0.6% | 1.767 | 1.704 | 7.814 | 2.325 | 3.702 |
| string: silesia/samba | 97582 | 4583.8 ± 0.7% | 2114.2 ± 0.6% | 3449.9 ± 0.5% | 355.0 ± 1.5% | 1436.8 ± 0.3% | 1054.4 ± 0.2% | 2.168 | 1.329 | 12.911 | 3.190 | 4.347 |
| string: silesia/webster | 1098490 | 4082.0 ± 0.6% | 1877.2 ± 0.4% | 2059.9 ± 1.0% | 441.2 ± 0.5% | 1393.9 ± 0.5% | 646.6 ± 0.5% | 2.174 | 1.982 | 9.252 | 2.929 | 6.313 |
| string: silesia/xml | 1090118 | 6223.8 ± 1.1% | 2863.1 ± 0.7% | 2647.2 ± 0.6% | 610.5 ± 0.7% | 1752.8 ± 0.3% | 922.3 ± 0.6% | 2.174 | 2.351 | 10.195 | 3.551 | 6.748 |
| string: canterbury/alice29.txt | 159425 | 6800.5 ± 2.0% | 2192.0 ± 0.6% | 2743.5 ± 0.6% | 406.7 ± 0.7% | 1476.7 ± 0.5% | 953.0 ± 0.7% | 3.102 | 2.479 | 16.720 | 4.605 | 7.136 |
| string: canterbury/asyoulik.txt | 132198 | 5872.9 ± 2.6% | 1714.4 ± 0.7% | 2377.9 ± 1.4% | 403.0 ± 0.5% | 1347.7 ± 0.4% | 884.2 ± 0.2% | 3.426 | 2.470 | 14.572 | 4.358 | 6.642 |
| string: canterbury/lcet10.txt | 441884 | 6242.3 ± 0.2% | 2541.1 ± 0.4% | 2461.2 ± 2.4% | 467.6 ± 0.9% | 1539.8 ± 0.3% | 986.1 ± 0.5% | 2.457 | 2.536 | 13.349 | 4.054 | 6.330 |
| string: canterbury/plrabn12.txt | 503330 | 5739.1 ± 0.4% | 2048.5 ± 0.3% | 2067.1 ± 0.4% | 422.8 ± 0.4% | 1425.9 ± 0.3% | 930.8 ± 0.3% | 2.802 | 2.776 | 13.575 | 4.025 | 6.166 |
| string: canterbury-large/E.coli | 1048578 | 19264.9 ± 0.6% | 9718.3 ± 1.4% | 3789.0 ± 0.8% | 1477.8 ± 0.3% | 2362.6 ± 0.6% | 1195.2 ± 0.3% | 1.982 | 5.084 | 13.037 | 8.154 | 16.119 |
| string: canterbury-large/bible.txt | 1055886 | 6775.9 ± 1.8% | 4143.9 ± 1.4% | 3020.4 ± 1.7% | 500.1 ± 1.1% | 1970.5 ± 0.5% | 1119.8 ± 1.5% | 1.635 | 2.243 | 13.550 | 3.439 | 6.051 |
| string: canterbury-large/world192.txt | 1103121 | 4022.5 ± 0.9% | 1652.7 ± 0.4% | 1998.4 ± 0.4% | 448.0 ± 0.3% | 1359.6 ± 0.2% | 907.9 ± 0.3% | 2.434 | 2.013 | 8.978 | 2.959 | 4.430 |
| string: http/html-1m | 1058582 | 6827.1 ± 0.4% | 3974.3 ± 0.5% | 3046.2 ± 0.5% | 500.1 ± 0.4% | 1918.3 ± 0.5% | 804.9 ± 0.4% | 1.718 | 2.241 | 13.652 | 3.559 | 8.481 |
| string: http/json-1m | 1190272 | 3290.8 ± 0.3% | 1344.6 ± 0.3% | 1555.7 ± 0.3% | 444.1 ± 0.6% | 961.3 ± 0.2% | 764.4 ± 0.6% | 2.447 | 2.115 | 7.409 | 3.423 | 4.305 |
| string: http/js-1m | 1144362 | 2792.4 ± 0.4% | 1177.8 ± 0.3% | 1628.0 ± 0.4% | 368.7 ± 0.1% | 1095.1 ± 0.2% | 757.4 ± 0.4% | 2.371 | 1.715 | 7.574 | 2.550 | 3.687 |
| string: http/css-1m | 1097820 | 4040.2 ± 0.5% | 1482.1 ± 0.6% | 2152.0 ± 0.5% | 493.8 ± 0.7% | 1371.5 ± 0.4% | 895.3 ± 0.5% | 2.726 | 1.877 | 8.183 | 2.946 | 4.513 |
| string: dickens as Cyrillic and CJK | 1883069 | 3072.9 ± 0.5% | 2343.7 ± 0.4% | 521.4 ± 0.3% | 306.9 ± 0.7% | 559.5 ± 1.6% | 335.9 ± 0.6% | 1.311 | 5.893 | 10.013 | 5.492 | 9.148 |
| hex: silesia/dickens | 524290 | 15557.2 ± 0.4% | 1461.8 ± 0.2% | 1084.4 ± 0.3% | 497.5 ± 0.6% | 988.5 ± 0.3% | 733.1 ± 0.6% | 10.642 | 14.346 | 31.269 | 15.738 | 21.221 |
| hex: silesia/mozilla | 524290 | 15646.3 ± 0.3% | 1473.6 ± 0.2% | 1087.5 ± 0.4% | 442.1 ± 0.7% | 991.4 ± 0.2% | 734.6 ± 0.4% | 10.617 | 14.387 | 35.393 | 15.782 | 21.299 |
| hex: silesia/mr | 524290 | 15658.8 ± 0.4% | 1481.2 ± 0.7% | 1090.5 ± 0.7% | 558.5 ± 1.0% | 995.4 ± 0.6% | 734.3 ± 0.3% | 10.571 | 14.360 | 28.039 | 15.731 | 21.323 |
| hex: silesia/nci | 524290 | 15658.8 ± 0.1% | 1469.4 ± 0.8% | 1087.6 ± 0.7% | 639.6 ± 4.2% | 992.5 ± 0.6% | 732.6 ± 0.2% | 10.657 | 14.397 | 24.481 | 15.777 | 21.374 |
| hex: silesia/ooffice | 524290 | 15558.6 ± 1.1% | 1460.6 ± 2.5% | 1083.9 ± 0.8% | 389.2 ± 0.5% | 990.6 ± 1.2% | 733.8 ± 1.3% | 10.652 | 14.355 | 39.978 | 15.706 | 21.203 |
| hex: silesia/osdb | 524290 | 15650.8 ± 0.2% | 1467.1 ± 1.2% | 1085.9 ± 1.1% | 467.1 ± 0.7% | 989.6 ± 0.7% | 734.3 ± 0.3% | 10.668 | 14.413 | 33.507 | 15.815 | 21.315 |
| hex: silesia/reymont | 524290 | 15598.7 ± 1.0% | 1460.9 ± 0.5% | 1085.8 ± 0.3% | 515.2 ± 1.3% | 990.1 ± 0.7% | 734.8 ± 0.4% | 10.677 | 14.365 | 30.279 | 15.755 | 21.230 |
| hex: silesia/samba | 524290 | 15632.6 ± 0.3% | 1464.1 ± 0.7% | 1082.8 ± 0.6% | 402.4 ± 0.6% | 990.0 ± 0.6% | 733.2 ± 0.4% | 10.677 | 14.438 | 38.853 | 15.790 | 21.321 |
| hex: silesia/sao | 524290 | 15622.1 ± 0.5% | 1464.1 ± 0.4% | 1084.6 ± 0.5% | 332.3 ± 0.3% | 991.3 ± 0.5% | 733.8 ± 0.4% | 10.670 | 14.404 | 47.009 | 15.760 | 21.289 |
| hex: silesia/webster | 524290 | 15642.8 ± 0.3% | 1462.9 ± 0.3% | 1084.8 ± 0.4% | 472.8 ± 0.4% | 989.2 ± 0.6% | 732.8 ± 0.7% | 10.693 | 14.421 | 33.087 | 15.813 | 21.347 |
| hex: silesia/x-ray | 524290 | 15624.1 ± 0.4% | 1474.6 ± 0.3% | 1088.3 ± 0.2% | 444.1 ± 0.9% | 996.8 ± 0.5% | 734.3 ± 0.5% | 10.596 | 14.356 | 35.182 | 15.674 | 21.277 |
| hex: silesia/xml | 524290 | 15659.0 ± 0.1% | 1467.4 ± 0.4% | 1085.5 ± 0.2% | 609.3 ± 1.4% | 991.4 ± 0.8% | 734.8 ± 0.4% | 10.671 | 14.426 | 25.700 | 15.796 | 21.311 |
| hex: canterbury/alice29.txt | 304180 | 15696.6 ± 0.0% | 1470.7 ± 0.5% | 1090.4 ± 0.3% | 501.6 ± 0.3% | 993.8 ± 0.5% | 735.4 ± 0.4% | 10.673 | 14.395 | 31.294 | 15.794 | 21.344 |
| hex: canterbury/asyoulik.txt | 250360 | 15716.1 ± 0.1% | 1475.1 ± 0.4% | 1093.1 ± 0.4% | 497.3 ± 1.3% | 994.2 ± 0.3% | 739.0 ± 0.8% | 10.654 | 14.377 | 31.602 | 15.808 | 21.267 |
| hex: canterbury/cp.html | 49208 | 15638.4 ± 0.0% | 1474.7 ± 0.3% | 1098.2 ± 0.2% | 528.4 ± 2.1% | 1000.9 ± 0.5% | 743.9 ± 0.2% | 10.605 | 14.240 | 29.593 | 15.624 | 21.022 |
| hex: canterbury/fields.c | 22302 | 15459.7 ± 0.0% | 1423.2 ± 0.2% | 1068.0 ± 0.4% | 630.4 ± 5.4% | 987.9 ± 0.2% | 736.5 ± 0.3% | 10.863 | 14.475 | 24.523 | 15.649 | 20.989 |
| hex: canterbury/grammar.lsp | 7444 | 14995.4 ± 0.0% | 1491.0 ± 0.4% | 1094.0 ± 0.4% | 659.3 ± 5.0% | 988.1 ± 1.0% | 726.2 ± 0.4% | 10.057 | 13.707 | 22.746 | 15.175 | 20.650 |
| hex: canterbury/kennedy.xls | 524290 | 15662.7 ± 0.2% | 1471.1 ± 0.6% | 1088.5 ± 0.5% | 658.0 ± 2.0% | 989.8 ± 0.4% | 733.4 ± 0.4% | 10.647 | 14.389 | 23.804 | 15.825 | 21.356 |
| hex: canterbury/lcet10.txt | 524290 | 15615.2 ± 0.3% | 1460.1 ± 1.4% | 1085.6 ± 2.0% | 497.1 ± 2.6% | 988.4 ± 0.4% | 733.8 ± 0.1% | 10.694 | 14.384 | 31.413 | 15.798 | 21.279 |
| hex: canterbury/plrabn12.txt | 524290 | 15566.9 ± 0.5% | 1458.3 ± 0.6% | 1085.1 ± 0.4% | 484.9 ± 2.7% | 988.9 ± 0.5% | 731.7 ± 0.6% | 10.674 | 14.346 | 32.101 | 15.741 | 21.274 |
| hex: canterbury/ptt5 | 524290 | 15584.7 ± 0.9% | 1478.2 ± 0.3% | 1092.3 ± 0.3% | 553.5 ± 0.7% | 990.8 ± 0.3% | 733.0 ± 0.8% | 10.543 | 14.268 | 28.157 | 15.729 | 21.262 |
| hex: canterbury/sum | 76482 | 15654.7 ± 0.2% | 1494.9 ± 0.2% | 1105.0 ± 0.1% | 594.2 ± 2.0% | 998.4 ± 0.1% | 743.9 ± 0.9% | 10.472 | 14.168 | 26.347 | 15.680 | 21.043 |
| hex: canterbury/xargs.1 | 8456 | 15038.4 ± 0.0% | 1431.7 ± 1.4% | 1092.8 ± 0.6% | 640.7 ± 5.4% | 1000.9 ± 0.2% | 726.9 ± 0.5% | 10.504 | 13.762 | 23.471 | 15.024 | 20.688 |
| hex: canterbury-large/E.coli | 524290 | 15575.6 ± 1.2% | 1471.0 ± 0.0% | 1089.1 ± 0.7% | 671.8 ± 0.2% | 993.2 ± 0.5% | 733.0 ± 0.9% | 10.589 | 14.301 | 23.184 | 15.682 | 21.248 |
| hex: canterbury-large/bible.txt | 524290 | 15641.5 ± 0.1% | 1461.9 ± 0.4% | 1085.3 ± 0.5% | 512.6 ± 1.2% | 986.8 ± 0.3% | 733.1 ± 0.3% | 10.700 | 14.412 | 30.512 | 15.851 | 21.336 |
| hex: canterbury-large/world192.txt | 524290 | 15598.4 ± 0.3% | 1462.0 ± 0.6% | 1083.2 ± 1.5% | 501.2 ± 1.0% | 989.5 ± 1.0% | 731.4 ± 1.5% | 10.669 | 14.400 | 31.120 | 15.765 | 21.327 |
| hex: http/html-1kx1024 | 2099200 | 13853.6 ± 0.4% | 1454.7 ± 0.2% | 1062.4 ± 0.2% | 501.6 ± 0.5% | 982.7 ± 0.2% | 692.0 ± 0.2% | 9.523 | 13.040 | 27.619 | 14.098 | 20.019 |
| hex: http/html-16kx64 | 2097280 | 15203.0 ± 1.1% | 1442.9 ± 0.3% | 1075.0 ± 0.2% | 506.0 ± 0.4% | 995.1 ± 0.1% | 733.6 ± 0.3% | 10.536 | 14.142 | 30.043 | 15.278 | 20.724 |
| hex: http/html-1m | 524290 | 15661.6 ± 0.3% | 1468.5 ± 1.1% | 1084.8 ± 0.6% | 499.9 ± 1.0% | 989.2 ± 0.4% | 733.5 ± 0.6% | 10.665 | 14.437 | 31.332 | 15.832 | 21.351 |
| hex: http/json-1kx1024 | 2099200 | 13794.1 ± 9.0% | 1461.8 ± 0.2% | 1066.1 ± 0.3% | 607.3 ± 0.8% | 986.4 ± 0.4% | 692.1 ± 0.4% | 9.437 | 12.939 | 22.715 | 13.984 | 19.932 |
| hex: http/json-16kx64 | 2097280 | 15222.5 ± 0.7% | 1445.6 ± 0.2% | 1074.6 ± 0.2% | 616.7 ± 0.4% | 994.5 ± 0.3% | 734.6 ± 0.1% | 10.531 | 14.165 | 24.684 | 15.307 | 20.723 |
| hex: http/json-1m | 524290 | 15604.2 ± 0.4% | 1470.3 ± 0.4% | 1089.0 ± 0.3% | 637.2 ± 1.0% | 994.2 ± 0.3% | 733.7 ± 0.3% | 10.613 | 14.329 | 24.488 | 15.695 | 21.268 |
| hex: http/js-1kx1024 | 2099200 | 13724.5 ± 0.5% | 1454.3 ± 0.2% | 1063.9 ± 0.4% | 499.3 ± 0.3% | 983.2 ± 0.3% | 692.5 ± 0.1% | 9.437 | 12.900 | 27.488 | 13.958 | 19.820 |
| hex: http/js-16kx64 | 2097280 | 15190.0 ± 0.7% | 1445.0 ± 0.3% | 1074.6 ± 0.3% | 503.5 ± 0.5% | 993.8 ± 0.6% | 735.0 ± 0.2% | 10.512 | 14.135 | 30.167 | 15.285 | 20.668 |
| hex: http/js-1m | 524290 | 15534.8 ± 0.8% | 1463.1 ± 0.7% | 1085.6 ± 0.4% | 508.7 ± 0.3% | 992.3 ± 0.4% | 733.6 ± 0.4% | 10.618 | 14.310 | 30.537 | 15.655 | 21.177 |
| hex: http/css-1kx1024 | 2099200 | 13727.3 ± 0.6% | 1455.2 ± 0.2% | 1063.0 ± 0.1% | 530.7 ± 0.3% | 983.1 ± 0.4% | 692.0 ± 0.9% | 9.433 | 12.913 | 25.868 | 13.964 | 19.837 |
| hex: http/css-16kx64 | 2097280 | 15198.1 ± 0.4% | 1442.2 ± 0.1% | 1073.6 ± 0.2% | 540.4 ± 0.2% | 998.9 ± 0.6% | 734.3 ± 0.2% | 10.538 | 14.156 | 28.124 | 15.216 | 20.697 |
| hex: http/css-1m | 524290 | 15686.1 ± 0.1% | 1462.8 ± 0.3% | 1085.2 ± 0.9% | 525.4 ± 0.6% | 986.8 ± 0.7% | 733.2 ± 0.4% | 10.723 | 14.455 | 29.855 | 15.895 | 21.394 |
| hex: shuffled/dickens-1m | 524290 | 15618.0 ± 0.3% | 1464.8 ± 0.4% | 1084.7 ± 0.2% | 501.2 ± 0.4% | 989.2 ± 0.6% | 732.6 ± 0.2% | 10.662 | 14.399 | 31.163 | 15.788 | 21.318 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 936.6 ± 0.1% | 932.7 ± 0.7% | 1020.9 ± 0.4% | 301.0 ± 1.0% | 659.8 ± 0.2% | 308.2 ± 2.0% | 1.004 | 0.917 | 3.111 | 1.420 | 3.039 |
| qlog records, JSON text sequence | 1467503 | 772.3 ± 1.0% | 816.8 ± 0.1% | 757.6 ± 3.3% | 243.1 ± 0.5% | 677.4 ± 2.0% | 239.4 ± 3.2% | 0.946 | 1.019 | 3.176 | 1.140 | 3.226 |
| string: silesia/dickens | 172528 | 5041.9 ± 0.4% | 1877.7 ± 0.2% | 2645.6 ± 0.2% | 361.5 ± 0.9% | 2838.3 ± 0.3% | 545.0 ± 4.7% | 2.685 | 1.906 | 13.948 | 1.776 | 9.251 |
| string: silesia/nci | 1075110 | 4301.6 ± 0.2% | 2236.6 ± 0.2% | 2992.3 ± 0.5% | 544.0 ± 1.2% | 2985.8 ± 0.5% | 584.6 ± 6.0% | 1.923 | 1.438 | 7.907 | 1.441 | 7.359 |
| string: silesia/reymont | 1075159 | 3006.1 ± 2.4% | 1804.3 ± 2.1% | 2059.8 ± 0.2% | 376.6 ± 0.8% | 2139.4 ± 0.3% | 530.0 ± 1.0% | 1.666 | 1.459 | 7.981 | 1.405 | 5.672 |
| string: silesia/samba | 97582 | 3503.6 ± 0.3% | 2025.6 ± 0.1% | 2618.7 ± 0.2% | 328.1 ± 0.2% | 1496.0 ± 1.0% | 423.0 ± 1.1% | 1.730 | 1.338 | 10.678 | 2.342 | 8.284 |
| string: silesia/webster | 1098490 | 3675.0 ± 0.5% | 1518.1 ± 0.3% | 2011.4 ± 0.8% | 359.1 ± 0.3% | 2168.1 ± 0.7% | 480.3 ± 2.1% | 2.421 | 1.827 | 10.234 | 1.695 | 7.651 |
| string: silesia/xml | 1090118 | 4803.0 ± 0.4% | 2356.0 ± 0.4% | 2524.2 ± 0.5% | 453.3 ± 1.7% | 2857.7 ± 2.9% | 547.2 ± 6.1% | 2.039 | 1.903 | 10.596 | 1.681 | 8.777 |
| string: canterbury/alice29.txt | 159425 | 4369.7 ± 0.7% | 1599.6 ± 0.4% | 2458.5 ± 0.5% | 341.9 ± 0.9% | 2493.7 ± 0.6% | 503.4 ± 1.4% | 2.732 | 1.777 | 12.781 | 1.752 | 8.680 |
| string: canterbury/asyoulik.txt | 132198 | 3507.9 ± 0.7% | 1458.4 ± 0.2% | 2246.4 ± 0.9% | 334.9 ± 0.5% | 2072.0 ± 0.4% | 457.2 ± 0.6% | 2.405 | 1.562 | 10.474 | 1.693 | 7.672 |
| string: canterbury/lcet10.txt | 441884 | 5109.0 ± 0.3% | 1853.4 ± 0.2% | 2334.3 ± 1.2% | 390.7 ± 0.3% | 2809.8 ± 0.4% | 523.7 ± 1.4% | 2.757 | 2.189 | 13.078 | 1.818 | 9.755 |
| string: canterbury/plrabn12.txt | 503330 | 4144.0 ± 0.4% | 1736.1 ± 0.1% | 2054.5 ± 0.3% | 360.2 ± 1.3% | 2486.4 ± 0.6% | 493.2 ± 0.5% | 2.387 | 2.017 | 11.506 | 1.667 | 8.403 |
| string: canterbury-large/E.coli | 1048578 | 11916.6 ± 0.2% | 3610.6 ± 0.2% | 3248.1 ± 0.3% | 927.7 ± 1.8% | 6048.3 ± 1.8% | 739.5 ± 1.4% | 3.300 | 3.669 | 12.845 | 1.970 | 16.115 |
| string: canterbury-large/bible.txt | 1055886 | 6905.3 ± 0.9% | 2935.6 ± 0.5% | 2828.0 ± 0.8% | 419.0 ± 2.5% | 3733.7 ± 4.6% | 600.7 ± 2.8% | 2.352 | 2.442 | 16.480 | 1.849 | 11.495 |
| string: canterbury-large/world192.txt | 1103121 | 3406.0 ± 0.3% | 1483.2 ± 0.1% | 2007.4 ± 0.3% | 352.4 ± 0.2% | 2117.3 ± 0.5% | 488.7 ± 2.6% | 2.296 | 1.697 | 9.666 | 1.609 | 6.970 |
| string: http/html-1m | 1058582 | 6221.3 ± 1.1% | 2733.8 ± 0.3% | 2701.9 ± 0.2% | 440.9 ± 0.5% | 3470.5 ± 1.1% | 593.5 ± 5.0% | 2.276 | 2.303 | 14.110 | 1.793 | 10.482 |
| string: http/json-1m | 1190272 | 2555.3 ± 0.3% | 877.9 ± 0.3% | 2246.3 ± 0.2% | 390.4 ± 0.6% | 1063.6 ± 0.3% | 441.1 ± 0.4% | 2.911 | 1.138 | 6.546 | 2.402 | 5.793 |
| string: http/js-1m | 1144362 | 2280.0 ± 1.1% | 1028.5 ± 0.2% | 1638.0 ± 0.4% | 320.7 ± 0.6% | 1524.9 ± 0.7% | 417.3 ± 0.6% | 2.217 | 1.392 | 7.110 | 1.495 | 5.464 |
| string: http/css-1m | 1097820 | 2657.3 ± 0.5% | 1679.1 ± 0.3% | 2219.7 ± 0.9% | 405.2 ± 1.0% | 1962.3 ± 0.7% | 488.8 ± 0.1% | 1.583 | 1.197 | 6.558 | 1.354 | 5.437 |
| string: dickens as Cyrillic and CJK | 1883069 | 3084.5 ± 0.2% | 1683.7 ± 0.4% | 894.2 ± 0.6% | 351.4 ± 0.1% | 669.9 ± 1.5% | 157.0 ± 3.1% | 1.832 | 3.449 | 8.779 | 4.605 | 19.645 |
| string: dickens as Cyrillic and CJK, as \u escapes | 5075485 | 1328.6 ± 0.2% | 980.4 ± 0.2% | 1201.8 ± 0.5% | 216.0 ± 0.3% | 469.4 ± 0.2% | 255.7 ± 3.9% | 1.355 | 1.106 | 6.151 | 2.830 | 5.197 |
| hex: silesia/dickens | 524290 | 11989.7 ± 0.2% | 3615.8 ± 0.2% | 3288.5 ± 0.2% | 505.5 ± 0.9% | 6021.4 ± 2.3% | 779.3 ± 2.5% | 3.316 | 3.646 | 23.717 | 1.991 | 15.385 |
| hex: silesia/mozilla | 524290 | 12024.6 ± 0.0% | 3621.4 ± 0.2% | 3292.5 ± 0.3% | 447.9 ± 0.4% | 6100.0 ± 2.1% | 780.7 ± 0.4% | 3.320 | 3.652 | 26.846 | 1.971 | 15.402 |
| hex: silesia/mr | 524290 | 11987.4 ± 0.1% | 3618.2 ± 0.1% | 3297.6 ± 0.2% | 569.2 ± 2.3% | 6065.8 ± 1.1% | 779.9 ± 0.6% | 3.313 | 3.635 | 21.059 | 1.976 | 15.370 |
| hex: silesia/nci | 524290 | 12002.3 ± 0.0% | 3617.7 ± 0.2% | 3291.4 ± 0.4% | 615.1 ± 1.0% | 6108.3 ± 1.1% | 778.8 ± 0.3% | 3.318 | 3.647 | 19.514 | 1.965 | 15.412 |
| hex: silesia/ooffice | 524290 | 11970.5 ± 0.1% | 3618.0 ± 0.4% | 3294.2 ± 0.2% | 397.8 ± 0.9% | 6080.1 ± 1.7% | 779.0 ± 0.3% | 3.309 | 3.634 | 30.092 | 1.969 | 15.367 |
| hex: silesia/osdb | 524290 | 12019.9 ± 0.1% | 3617.8 ± 0.3% | 3294.8 ± 0.4% | 482.1 ± 1.9% | 6077.6 ± 1.5% | 778.3 ± 2.5% | 3.322 | 3.648 | 24.931 | 1.978 | 15.443 |
| hex: silesia/reymont | 524290 | 11957.8 ± 0.1% | 3617.8 ± 0.1% | 3284.9 ± 0.3% | 512.2 ± 0.7% | 6004.4 ± 1.4% | 778.8 ± 0.5% | 3.305 | 3.640 | 23.345 | 1.992 | 15.353 |
| hex: silesia/samba | 524290 | 11954.9 ± 0.2% | 3617.9 ± 0.3% | 3291.2 ± 0.5% | 407.8 ± 0.8% | 6126.0 ± 0.8% | 778.3 ± 0.5% | 3.304 | 3.632 | 29.314 | 1.951 | 15.361 |
| hex: silesia/sao | 524290 | 11980.2 ± 0.1% | 3618.3 ± 0.2% | 3285.3 ± 0.4% | 344.6 ± 0.7% | 6040.2 ± 1.1% | 779.9 ± 1.1% | 3.311 | 3.647 | 34.764 | 1.983 | 15.362 |
| hex: silesia/webster | 524290 | 12017.6 ± 0.1% | 3620.6 ± 0.2% | 3294.6 ± 0.2% | 455.6 ± 2.5% | 6129.4 ± 1.9% | 780.2 ± 0.4% | 3.319 | 3.648 | 26.378 | 1.961 | 15.404 |
| hex: silesia/x-ray | 524290 | 11941.4 ± 0.1% | 3615.9 ± 0.8% | 3294.7 ± 0.3% | 470.0 ± 1.2% | 6036.5 ± 2.2% | 779.5 ± 2.6% | 3.302 | 3.624 | 25.407 | 1.978 | 15.319 |
| hex: silesia/xml | 524290 | 12016.1 ± 0.3% | 3618.1 ± 0.2% | 3288.8 ± 0.3% | 519.2 ± 0.6% | 6122.6 ± 1.6% | 780.0 ± 0.8% | 3.321 | 3.654 | 23.143 | 1.963 | 15.406 |
| hex: canterbury/alice29.txt | 304180 | 12013.6 ± 0.0% | 3628.2 ± 0.1% | 3370.9 ± 0.1% | 506.8 ± 0.7% | 6097.6 ± 1.5% | 779.0 ± 1.3% | 3.311 | 3.564 | 23.705 | 1.970 | 15.422 |
| hex: canterbury/asyoulik.txt | 250360 | 12009.3 ± 0.1% | 3639.6 ± 0.1% | 3363.2 ± 0.2% | 498.5 ± 0.9% | 6107.6 ± 1.3% | 778.6 ± 0.2% | 3.300 | 3.571 | 24.093 | 1.966 | 15.423 |
| hex: canterbury/cp.html | 49208 | 11916.0 ± 0.0% | 3640.3 ± 0.0% | 3287.3 ± 0.4% | 461.2 ± 1.2% | 6270.7 ± 0.3% | 765.5 ± 1.2% | 3.273 | 3.625 | 25.839 | 1.900 | 15.567 |
| hex: canterbury/fields.c | 22302 | 11779.3 ± 0.0% | 3629.3 ± 0.0% | 3356.7 ± 0.1% | 498.0 ± 1.3% | 6257.9 ± 0.7% | 754.5 ± 1.9% | 3.246 | 3.509 | 23.654 | 1.882 | 15.611 |
| hex: canterbury/grammar.lsp | 7444 | 11260.2 ± 0.1% | 3601.2 ± 0.0% | 3354.9 ± 0.4% | 529.8 ± 3.0% | 6179.5 ± 0.7% | 716.3 ± 0.5% | 3.127 | 3.356 | 21.252 | 1.822 | 15.720 |
| hex: canterbury/kennedy.xls | 524290 | 12006.3 ± 0.2% | 3608.2 ± 0.5% | 3289.0 ± 0.3% | 656.2 ± 7.8% | 6159.1 ± 1.5% | 766.8 ± 5.9% | 3.327 | 3.650 | 18.298 | 1.949 | 15.657 |
| hex: canterbury/lcet10.txt | 524290 | 11965.3 ± 0.2% | 3610.8 ± 0.3% | 3283.7 ± 0.2% | 513.9 ± 0.5% | 6066.6 ± 0.9% | 766.6 ± 0.6% | 3.314 | 3.644 | 23.283 | 1.972 | 15.608 |
| hex: canterbury/plrabn12.txt | 524290 | 11931.3 ± 0.2% | 3612.8 ± 0.6% | 3281.0 ± 1.1% | 502.6 ± 1.6% | 6072.2 ± 1.2% | 764.6 ± 1.1% | 3.302 | 3.636 | 23.739 | 1.965 | 15.604 |
| hex: canterbury/ptt5 | 524290 | 12013.9 ± 0.2% | 3611.8 ± 0.4% | 3291.2 ± 0.1% | 562.0 ± 1.5% | 6149.2 ± 1.1% | 766.1 ± 0.7% | 3.326 | 3.650 | 21.378 | 1.954 | 15.682 |
| hex: canterbury/sum | 76482 | 11912.6 ± 0.1% | 3634.1 ± 0.0% | 3362.7 ± 0.3% | 508.9 ± 1.0% | 6196.0 ± 0.8% | 768.6 ± 1.4% | 3.278 | 3.543 | 23.411 | 1.923 | 15.499 |
| hex: canterbury/xargs.1 | 8456 | 11351.3 ± 0.1% | 3602.9 ± 0.1% | 3368.0 ± 0.1% | 492.6 ± 0.8% | 6146.9 ± 0.5% | 747.0 ± 0.9% | 3.151 | 3.370 | 23.043 | 1.847 | 15.195 |
| hex: canterbury-large/E.coli | 524290 | 11925.2 ± 0.2% | 3612.8 ± 0.2% | 3277.2 ± 0.3% | 687.9 ± 0.2% | 6043.0 ± 1.2% | 779.1 ± 4.7% | 3.301 | 3.639 | 17.335 | 1.973 | 15.306 |
| hex: canterbury-large/bible.txt | 524290 | 11938.5 ± 0.4% | 3617.3 ± 0.1% | 3299.3 ± 0.3% | 523.6 ± 1.4% | 6092.9 ± 1.2% | 780.6 ± 0.4% | 3.300 | 3.618 | 22.799 | 1.959 | 15.294 |
| hex: canterbury-large/world192.txt | 524290 | 11968.1 ± 0.1% | 3615.8 ± 0.1% | 3289.3 ± 0.7% | 494.6 ± 0.6% | 6122.0 ± 1.0% | 779.7 ± 0.6% | 3.310 | 3.638 | 24.195 | 1.955 | 15.350 |
| hex: http/html-1kx1024 | 2099200 | 8769.6 ± 4.1% | 3460.6 ± 0.1% | 2845.5 ± 0.7% | 475.2 ± 0.5% | 5052.8 ± 1.3% | 638.8 ± 3.7% | 2.534 | 3.082 | 18.455 | 1.736 | 13.729 |
| hex: http/html-16kx64 | 2097280 | 11767.7 ± 0.2% | 3609.9 ± 0.1% | 3260.0 ± 0.5% | 476.4 ± 2.3% | 6024.7 ± 0.8% | 753.0 ± 2.7% | 3.260 | 3.610 | 24.702 | 1.953 | 15.627 |
| hex: http/html-1m | 524290 | 11991.6 ± 0.1% | 3611.6 ± 0.3% | 3280.5 ± 0.2% | 496.6 ± 2.5% | 6083.7 ± 0.4% | 781.7 ± 1.5% | 3.320 | 3.655 | 24.149 | 1.971 | 15.341 |
| hex: http/json-1kx1024 | 2099200 | 8677.6 ± 2.4% | 3460.3 ± 0.2% | 2841.9 ± 0.4% | 576.5 ± 0.5% | 5193.0 ± 1.1% | 645.0 ± 0.9% | 2.508 | 3.053 | 15.053 | 1.671 | 13.453 |
| hex: http/json-16kx64 | 2097280 | 11762.8 ± 0.4% | 3609.5 ± 0.1% | 3258.5 ± 0.3% | 574.5 ± 1.3% | 6021.4 ± 0.5% | 755.0 ± 1.9% | 3.259 | 3.610 | 20.475 | 1.954 | 15.580 |
| hex: http/json-1m | 524290 | 11999.1 ± 0.3% | 3613.4 ± 0.2% | 3281.9 ± 0.3% | 591.7 ± 1.6% | 5991.3 ± 1.1% | 778.8 ± 1.0% | 3.321 | 3.656 | 20.278 | 2.003 | 15.408 |
| hex: http/js-1kx1024 | 2099200 | 8697.4 ± 4.0% | 3463.9 ± 0.1% | 2844.3 ± 0.8% | 481.3 ± 1.2% | 5107.4 ± 0.8% | 648.2 ± 1.9% | 2.511 | 3.058 | 18.072 | 1.703 | 13.418 |
| hex: http/js-16kx64 | 2097280 | 11778.1 ± 0.2% | 3611.1 ± 0.2% | 3262.4 ± 0.2% | 479.9 ± 1.2% | 6012.9 ± 0.9% | 753.3 ± 2.1% | 3.262 | 3.610 | 24.540 | 1.959 | 15.635 |
| hex: http/js-1m | 524290 | 11978.6 ± 0.1% | 3607.9 ± 0.1% | 3295.0 ± 0.2% | 498.9 ± 0.8% | 6050.4 ± 1.2% | 781.1 ± 1.3% | 3.320 | 3.635 | 24.009 | 1.980 | 15.336 |
| hex: http/css-1kx1024 | 2099200 | 8864.6 ± 3.1% | 3464.0 ± 0.2% | 2854.1 ± 0.9% | 487.0 ± 0.9% | 5111.2 ± 2.1% | 640.0 ± 2.3% | 2.559 | 3.106 | 18.203 | 1.734 | 13.851 |
| hex: http/css-16kx64 | 2097280 | 11768.1 ± 0.3% | 3608.1 ± 0.1% | 3268.0 ± 0.4% | 494.5 ± 0.9% | 6019.9 ± 0.6% | 751.1 ± 2.4% | 3.262 | 3.601 | 23.799 | 1.955 | 15.668 |
| hex: http/css-1m | 524290 | 12017.9 ± 0.2% | 3610.8 ± 0.2% | 3298.6 ± 0.2% | 492.4 ± 1.9% | 6117.3 ± 2.2% | 757.0 ± 2.4% | 3.328 | 3.643 | 24.406 | 1.965 | 15.875 |
| hex: shuffled/dickens-1m | 524290 | 12015.4 ± 0.1% | 3609.5 ± 1.4% | 3288.1 ± 1.4% | 512.5 ± 1.6% | 6116.6 ± 0.7% | 780.6 ± 1.1% | 3.329 | 3.654 | 23.443 | 1.964 | 15.392 |

## TextReader.next_items against the baselines

stdx's decoder a slice of tokens a call through `TextReader.next_items`, as a caller that reads a text's values in a loop calls it (decision 79). Octets are the text's. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1014.2 ± 0.1% | 932.7 ± 0.7% | 1020.9 ± 0.4% | 301.0 ± 1.0% | 659.8 ± 0.2% | 308.2 ± 2.0% | 1.087 | 0.993 | 3.369 | 1.537 | 3.291 |
| qlog records, JSON text sequence | 1467503 | 835.8 ± 0.4% | 816.8 ± 0.1% | 757.6 ± 3.3% | 243.1 ± 0.5% | 677.4 ± 2.0% | 239.4 ± 3.2% | 1.023 | 1.103 | 3.438 | 1.234 | 3.491 |
| string: silesia/dickens | 172528 | 5048.6 ± 0.5% | 1877.7 ± 0.2% | 2645.6 ± 0.2% | 361.5 ± 0.9% | 2838.3 ± 0.3% | 545.0 ± 4.7% | 2.689 | 1.908 | 13.966 | 1.779 | 9.263 |
| string: silesia/nci | 1075110 | 4305.4 ± 0.1% | 2236.6 ± 0.2% | 2992.3 ± 0.5% | 544.0 ± 1.2% | 2985.8 ± 0.5% | 584.6 ± 6.0% | 1.925 | 1.439 | 7.914 | 1.442 | 7.365 |
| string: silesia/reymont | 1075159 | 3011.9 ± 2.6% | 1804.3 ± 2.1% | 2059.8 ± 0.2% | 376.6 ± 0.8% | 2139.4 ± 0.3% | 530.0 ± 1.0% | 1.669 | 1.462 | 7.997 | 1.408 | 5.683 |
| string: silesia/samba | 97582 | 3513.1 ± 0.4% | 2025.6 ± 0.1% | 2618.7 ± 0.2% | 328.1 ± 0.2% | 1496.0 ± 1.0% | 423.0 ± 1.1% | 1.734 | 1.342 | 10.707 | 2.348 | 8.306 |
| string: silesia/webster | 1098490 | 3671.1 ± 0.8% | 1518.1 ± 0.3% | 2011.4 ± 0.8% | 359.1 ± 0.3% | 2168.1 ± 0.7% | 480.3 ± 2.1% | 2.418 | 1.825 | 10.223 | 1.693 | 7.643 |
| string: silesia/xml | 1090118 | 4804.8 ± 0.4% | 2356.0 ± 0.4% | 2524.2 ± 0.5% | 453.3 ± 1.7% | 2857.7 ± 2.9% | 547.2 ± 6.1% | 2.039 | 1.904 | 10.600 | 1.681 | 8.780 |
| string: canterbury/alice29.txt | 159425 | 4370.3 ± 0.7% | 1599.6 ± 0.4% | 2458.5 ± 0.5% | 341.9 ± 0.9% | 2493.7 ± 0.6% | 503.4 ± 1.4% | 2.732 | 1.778 | 12.782 | 1.753 | 8.682 |
| string: canterbury/asyoulik.txt | 132198 | 3507.0 ± 0.7% | 1458.4 ± 0.2% | 2246.4 ± 0.9% | 334.9 ± 0.5% | 2072.0 ± 0.4% | 457.2 ± 0.6% | 2.405 | 1.561 | 10.472 | 1.693 | 7.670 |
| string: canterbury/lcet10.txt | 441884 | 5109.5 ± 0.2% | 1853.4 ± 0.2% | 2334.3 ± 1.2% | 390.7 ± 0.3% | 2809.8 ± 0.4% | 523.7 ± 1.4% | 2.757 | 2.189 | 13.079 | 1.818 | 9.756 |
| string: canterbury/plrabn12.txt | 503330 | 4143.5 ± 0.2% | 1736.1 ± 0.1% | 2054.5 ± 0.3% | 360.2 ± 1.3% | 2486.4 ± 0.6% | 493.2 ± 0.5% | 2.387 | 2.017 | 11.504 | 1.666 | 8.402 |
| string: canterbury-large/E.coli | 1048578 | 11934.9 ± 0.2% | 3610.6 ± 0.2% | 3248.1 ± 0.3% | 927.7 ± 1.8% | 6048.3 ± 1.8% | 739.5 ± 1.4% | 3.306 | 3.674 | 12.864 | 1.973 | 16.140 |
| string: canterbury-large/bible.txt | 1055886 | 6932.9 ± 0.8% | 2935.6 ± 0.5% | 2828.0 ± 0.8% | 419.0 ± 2.5% | 3733.7 ± 4.6% | 600.7 ± 2.8% | 2.362 | 2.452 | 16.546 | 1.857 | 11.541 |
| string: canterbury-large/world192.txt | 1103121 | 3407.3 ± 0.3% | 1483.2 ± 0.1% | 2007.4 ± 0.3% | 352.4 ± 0.2% | 2117.3 ± 0.5% | 488.7 ± 2.6% | 2.297 | 1.697 | 9.670 | 1.609 | 6.972 |
| string: http/html-1m | 1058582 | 6243.9 ± 1.5% | 2733.8 ± 0.3% | 2701.9 ± 0.2% | 440.9 ± 0.5% | 3470.5 ± 1.1% | 593.5 ± 5.0% | 2.284 | 2.311 | 14.161 | 1.799 | 10.520 |
| string: http/json-1m | 1190272 | 2557.0 ± 0.1% | 877.9 ± 0.3% | 2246.3 ± 0.2% | 390.4 ± 0.6% | 1063.6 ± 0.3% | 441.1 ± 0.4% | 2.913 | 1.138 | 6.550 | 2.404 | 5.797 |
| string: http/js-1m | 1144362 | 2283.0 ± 0.4% | 1028.5 ± 0.2% | 1638.0 ± 0.4% | 320.7 ± 0.6% | 1524.9 ± 0.7% | 417.3 ± 0.6% | 2.220 | 1.394 | 7.119 | 1.497 | 5.471 |
| string: http/css-1m | 1097820 | 2657.4 ± 0.4% | 1679.1 ± 0.3% | 2219.7 ± 0.9% | 405.2 ± 1.0% | 1962.3 ± 0.7% | 488.8 ± 0.1% | 1.583 | 1.197 | 6.558 | 1.354 | 5.437 |
| string: dickens as Cyrillic and CJK | 1883069 | 3079.9 ± 0.4% | 1683.7 ± 0.4% | 894.2 ± 0.6% | 351.4 ± 0.1% | 669.9 ± 1.5% | 157.0 ± 3.1% | 1.829 | 3.444 | 8.765 | 4.598 | 19.616 |
| string: dickens as Cyrillic and CJK, as \u escapes | 5075485 | 1329.8 ± 0.2% | 980.4 ± 0.2% | 1201.8 ± 0.5% | 216.0 ± 0.3% | 469.4 ± 0.2% | 255.7 ± 3.9% | 1.356 | 1.107 | 6.157 | 2.833 | 5.201 |
| hex: silesia/dickens | 524290 | 11997.7 ± 0.2% | 3615.8 ± 0.2% | 3288.5 ± 0.2% | 505.5 ± 0.9% | 6021.4 ± 2.3% | 779.3 ± 2.5% | 3.318 | 3.648 | 23.733 | 1.993 | 15.395 |
| hex: silesia/mozilla | 524290 | 12028.3 ± 0.1% | 3621.4 ± 0.2% | 3292.5 ± 0.3% | 447.9 ± 0.4% | 6100.0 ± 2.1% | 780.7 ± 0.4% | 3.321 | 3.653 | 26.854 | 1.972 | 15.407 |
| hex: silesia/mr | 524290 | 11997.8 ± 0.2% | 3618.2 ± 0.1% | 3297.6 ± 0.2% | 569.2 ± 2.3% | 6065.8 ± 1.1% | 779.9 ± 0.6% | 3.316 | 3.638 | 21.077 | 1.978 | 15.383 |
| hex: silesia/nci | 524290 | 12002.5 ± 0.1% | 3617.7 ± 0.2% | 3291.4 ± 0.4% | 615.1 ± 1.0% | 6108.3 ± 1.1% | 778.8 ± 0.3% | 3.318 | 3.647 | 19.515 | 1.965 | 15.412 |
| hex: silesia/ooffice | 524290 | 11967.6 ± 0.3% | 3618.0 ± 0.4% | 3294.2 ± 0.2% | 397.8 ± 0.9% | 6080.1 ± 1.7% | 779.0 ± 0.3% | 3.308 | 3.633 | 30.085 | 1.968 | 15.363 |
| hex: silesia/osdb | 524290 | 12020.3 ± 0.1% | 3617.8 ± 0.3% | 3294.8 ± 0.4% | 482.1 ± 1.9% | 6077.6 ± 1.5% | 778.3 ± 2.5% | 3.323 | 3.648 | 24.932 | 1.978 | 15.443 |
| hex: silesia/reymont | 524290 | 11956.8 ± 0.1% | 3617.8 ± 0.1% | 3284.9 ± 0.3% | 512.2 ± 0.7% | 6004.4 ± 1.4% | 778.8 ± 0.5% | 3.305 | 3.640 | 23.343 | 1.991 | 15.352 |
| hex: silesia/samba | 524290 | 11911.0 ± 0.1% | 3617.9 ± 0.3% | 3291.2 ± 0.5% | 407.8 ± 0.8% | 6126.0 ± 0.8% | 778.3 ± 0.5% | 3.292 | 3.619 | 29.207 | 1.944 | 15.304 |
| hex: silesia/sao | 524290 | 11982.2 ± 0.2% | 3618.3 ± 0.2% | 3285.3 ± 0.4% | 344.6 ± 0.7% | 6040.2 ± 1.1% | 779.9 ± 1.1% | 3.312 | 3.647 | 34.769 | 1.984 | 15.364 |
| hex: silesia/webster | 524290 | 12021.0 ± 0.0% | 3620.6 ± 0.2% | 3294.6 ± 0.2% | 455.6 ± 2.5% | 6129.4 ± 1.9% | 780.2 ± 0.4% | 3.320 | 3.649 | 26.385 | 1.961 | 15.408 |
| hex: silesia/x-ray | 524290 | 11932.7 ± 0.1% | 3615.9 ± 0.8% | 3294.7 ± 0.3% | 470.0 ± 1.2% | 6036.5 ± 2.2% | 779.5 ± 2.6% | 3.300 | 3.622 | 25.389 | 1.977 | 15.308 |
| hex: silesia/xml | 524290 | 12018.8 ± 0.0% | 3618.1 ± 0.2% | 3288.8 ± 0.3% | 519.2 ± 0.6% | 6122.6 ± 1.6% | 780.0 ± 0.8% | 3.322 | 3.655 | 23.148 | 1.963 | 15.410 |
| hex: canterbury/alice29.txt | 304180 | 12010.9 ± 0.1% | 3628.2 ± 0.1% | 3370.9 ± 0.1% | 506.8 ± 0.7% | 6097.6 ± 1.5% | 779.0 ± 1.3% | 3.310 | 3.563 | 23.700 | 1.970 | 15.419 |
| hex: canterbury/asyoulik.txt | 250360 | 12011.8 ± 0.2% | 3639.6 ± 0.1% | 3363.2 ± 0.2% | 498.5 ± 0.9% | 6107.6 ± 1.3% | 778.6 ± 0.2% | 3.300 | 3.572 | 24.098 | 1.967 | 15.427 |
| hex: canterbury/cp.html | 49208 | 11928.4 ± 0.0% | 3640.3 ± 0.0% | 3287.3 ± 0.4% | 461.2 ± 1.2% | 6270.7 ± 0.3% | 765.5 ± 1.2% | 3.277 | 3.629 | 25.866 | 1.902 | 15.583 |
| hex: canterbury/fields.c | 22302 | 11785.1 ± 0.0% | 3629.3 ± 0.0% | 3356.7 ± 0.1% | 498.0 ± 1.3% | 6257.9 ± 0.7% | 754.5 ± 1.9% | 3.247 | 3.511 | 23.666 | 1.883 | 15.619 |
| hex: canterbury/grammar.lsp | 7444 | 11309.2 ± 0.6% | 3601.2 ± 0.0% | 3354.9 ± 0.4% | 529.8 ± 3.0% | 6179.5 ± 0.7% | 716.3 ± 0.5% | 3.140 | 3.371 | 21.345 | 1.830 | 15.789 |
| hex: canterbury/kennedy.xls | 524290 | 12008.9 ± 0.1% | 3608.2 ± 0.5% | 3289.0 ± 0.3% | 656.2 ± 7.8% | 6159.1 ± 1.5% | 766.8 ± 5.9% | 3.328 | 3.651 | 18.302 | 1.950 | 15.660 |
| hex: canterbury/lcet10.txt | 524290 | 11959.7 ± 0.1% | 3610.8 ± 0.3% | 3283.7 ± 0.2% | 513.9 ± 0.5% | 6066.6 ± 0.9% | 766.6 ± 0.6% | 3.312 | 3.642 | 23.272 | 1.971 | 15.601 |
| hex: canterbury/plrabn12.txt | 524290 | 11984.2 ± 0.4% | 3612.8 ± 0.6% | 3281.0 ± 1.1% | 502.6 ± 1.6% | 6072.2 ± 1.2% | 764.6 ± 1.1% | 3.317 | 3.653 | 23.844 | 1.974 | 15.673 |
| hex: canterbury/ptt5 | 524290 | 12017.9 ± 0.1% | 3611.8 ± 0.4% | 3291.2 ± 0.1% | 562.0 ± 1.5% | 6149.2 ± 1.1% | 766.1 ± 0.7% | 3.327 | 3.652 | 21.385 | 1.954 | 15.688 |
| hex: canterbury/sum | 76482 | 11911.9 ± 0.2% | 3634.1 ± 0.0% | 3362.7 ± 0.3% | 508.9 ± 1.0% | 6196.0 ± 0.8% | 768.6 ± 1.4% | 3.278 | 3.542 | 23.409 | 1.923 | 15.498 |
| hex: canterbury/xargs.1 | 8456 | 11352.6 ± 0.0% | 3602.9 ± 0.1% | 3368.0 ± 0.1% | 492.6 ± 0.8% | 6146.9 ± 0.5% | 747.0 ± 0.9% | 3.151 | 3.371 | 23.046 | 1.847 | 15.197 |
| hex: canterbury-large/E.coli | 524290 | 11925.6 ± 0.2% | 3612.8 ± 0.2% | 3277.2 ± 0.3% | 687.9 ± 0.2% | 6043.0 ± 1.2% | 779.1 ± 4.7% | 3.301 | 3.639 | 17.336 | 1.973 | 15.306 |
| hex: canterbury-large/bible.txt | 524290 | 11961.5 ± 0.2% | 3617.3 ± 0.1% | 3299.3 ± 0.3% | 523.6 ± 1.4% | 6092.9 ± 1.2% | 780.6 ± 0.4% | 3.307 | 3.625 | 22.843 | 1.963 | 15.323 |
| hex: canterbury-large/world192.txt | 524290 | 11969.6 ± 0.1% | 3615.8 ± 0.1% | 3289.3 ± 0.7% | 494.6 ± 0.6% | 6122.0 ± 1.0% | 779.7 ± 0.6% | 3.310 | 3.639 | 24.198 | 1.955 | 15.352 |
| hex: http/html-1kx1024 | 2099200 | 8811.3 ± 4.6% | 3460.6 ± 0.1% | 2845.5 ± 0.7% | 475.2 ± 0.5% | 5052.8 ± 1.3% | 638.8 ± 3.7% | 2.546 | 3.097 | 18.543 | 1.744 | 13.794 |
| hex: http/html-16kx64 | 2097280 | 11767.0 ± 0.1% | 3609.9 ± 0.1% | 3260.0 ± 0.5% | 476.4 ± 2.3% | 6024.7 ± 0.8% | 753.0 ± 2.7% | 3.260 | 3.610 | 24.700 | 1.953 | 15.626 |
| hex: http/html-1m | 524290 | 11965.3 ± 0.1% | 3611.6 ± 0.3% | 3280.5 ± 0.2% | 496.6 ± 2.5% | 6083.7 ± 0.4% | 781.7 ± 1.5% | 3.313 | 3.647 | 24.096 | 1.967 | 15.308 |
| hex: http/json-1kx1024 | 2099200 | 8780.3 ± 3.0% | 3460.3 ± 0.2% | 2841.9 ± 0.4% | 576.5 ± 0.5% | 5193.0 ± 1.1% | 645.0 ± 0.9% | 2.537 | 3.090 | 15.231 | 1.691 | 13.612 |
| hex: http/json-16kx64 | 2097280 | 11760.3 ± 0.3% | 3609.5 ± 0.1% | 3258.5 ± 0.3% | 574.5 ± 1.3% | 6021.4 ± 0.5% | 755.0 ± 1.9% | 3.258 | 3.609 | 20.470 | 1.953 | 15.577 |
| hex: http/json-1m | 524290 | 11995.4 ± 0.1% | 3613.4 ± 0.2% | 3281.9 ± 0.3% | 591.7 ± 1.6% | 5991.3 ± 1.1% | 778.8 ± 1.0% | 3.320 | 3.655 | 20.272 | 2.002 | 15.403 |
| hex: http/js-1kx1024 | 2099200 | 8783.5 ± 4.4% | 3463.9 ± 0.1% | 2844.3 ± 0.8% | 481.3 ± 1.2% | 5107.4 ± 0.8% | 648.2 ± 1.9% | 2.536 | 3.088 | 18.251 | 1.720 | 13.550 |
| hex: http/js-16kx64 | 2097280 | 11775.5 ± 0.1% | 3611.1 ± 0.2% | 3262.4 ± 0.2% | 479.9 ± 1.2% | 6012.9 ± 0.9% | 753.3 ± 2.1% | 3.261 | 3.609 | 24.535 | 1.958 | 15.632 |
| hex: http/js-1m | 524290 | 11930.1 ± 0.1% | 3607.9 ± 0.1% | 3295.0 ± 0.2% | 498.9 ± 0.8% | 6050.4 ± 1.2% | 781.1 ± 1.3% | 3.307 | 3.621 | 23.911 | 1.972 | 15.274 |
| hex: http/css-1kx1024 | 2099200 | 8902.5 ± 3.6% | 3464.0 ± 0.2% | 2854.1 ± 0.9% | 487.0 ± 0.9% | 5111.2 ± 2.1% | 640.0 ± 2.3% | 2.570 | 3.119 | 18.281 | 1.742 | 13.910 |
| hex: http/css-16kx64 | 2097280 | 11764.9 ± 0.3% | 3608.1 ± 0.1% | 3268.0 ± 0.4% | 494.5 ± 0.9% | 6019.9 ± 0.6% | 751.1 ± 2.4% | 3.261 | 3.600 | 23.792 | 1.954 | 15.664 |
| hex: http/css-1m | 524290 | 12019.8 ± 0.1% | 3610.8 ± 0.2% | 3298.6 ± 0.2% | 492.4 ± 1.9% | 6117.3 ± 2.2% | 757.0 ± 2.4% | 3.329 | 3.644 | 24.410 | 1.965 | 15.878 |
| hex: shuffled/dickens-1m | 524290 | 12019.6 ± 0.1% | 3609.5 ± 1.4% | 3288.1 ± 1.4% | 512.5 ± 1.6% | 6116.6 ± 0.7% | 780.6 ± 1.1% | 3.330 | 3.656 | 23.451 | 1.965 | 15.398 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1354.6 ± 0.4% | 1251.7 ± 0.2% | 1038.0 ± 0.8% | 409.2 ± 0.4% | 448.2 ± 0.3% | 414.6 ± 0.5% | 1.082 | 1.305 | 3.310 | 3.022 | 3.268 |
| qlog records, JSON text sequence | 1467503 | 1052.3 ± 0.2% | 1064.3 ± 0.2% | 781.0 ± 2.6% | 377.5 ± 0.9% | 468.2 ± 0.5% | 278.8 ± 0.2% | 0.989 | 1.347 | 2.788 | 2.248 | 3.775 |
| string: silesia/dickens | 172528 | 6917.0 ± 0.1% | 2814.3 ± 0.5% | 2936.2 ± 0.5% | 429.4 ± 0.5% | 1592.6 ± 0.2% | 1011.1 ± 0.2% | 2.458 | 2.356 | 16.107 | 4.343 | 6.841 |
| string: silesia/nci | 1075110 | 7312.4 ± 0.5% | 3382.6 ± 1.1% | 3100.4 ± 0.3% | 803.9 ± 1.5% | 1862.1 ± 0.3% | 1106.5 ± 0.9% | 2.162 | 2.358 | 9.096 | 3.927 | 6.608 |
| string: silesia/reymont | 1075159 | 3340.0 ± 1.6% | 1984.9 ± 0.9% | 2058.4 ± 0.6% | 449.0 ± 0.5% | 1508.6 ± 0.2% | 947.7 ± 0.6% | 1.683 | 1.623 | 7.439 | 2.214 | 3.524 |
| string: silesia/samba | 97582 | 4209.9 ± 0.5% | 2114.2 ± 0.6% | 3449.9 ± 0.5% | 355.0 ± 1.5% | 1436.8 ± 0.3% | 1054.4 ± 0.2% | 1.991 | 1.220 | 11.857 | 2.930 | 3.993 |
| string: silesia/webster | 1098490 | 4079.5 ± 0.6% | 1877.2 ± 0.4% | 2059.9 ± 1.0% | 441.2 ± 0.5% | 1393.9 ± 0.5% | 646.6 ± 0.5% | 2.173 | 1.980 | 9.246 | 2.927 | 6.309 |
| string: silesia/xml | 1090118 | 6128.5 ± 0.5% | 2863.1 ± 0.7% | 2647.2 ± 0.6% | 610.5 ± 0.7% | 1752.8 ± 0.3% | 922.3 ± 0.6% | 2.141 | 2.315 | 10.039 | 3.496 | 6.645 |
| string: canterbury/alice29.txt | 159425 | 6466.3 ± 0.8% | 2192.0 ± 0.6% | 2743.5 ± 0.6% | 406.7 ± 0.7% | 1476.7 ± 0.5% | 953.0 ± 0.7% | 2.950 | 2.357 | 15.899 | 4.379 | 6.785 |
| string: canterbury/asyoulik.txt | 132198 | 5646.1 ± 0.9% | 1714.4 ± 0.7% | 2377.9 ± 1.4% | 403.0 ± 0.5% | 1347.7 ± 0.4% | 884.2 ± 0.2% | 3.293 | 2.374 | 14.010 | 4.189 | 6.386 |
| string: canterbury/lcet10.txt | 441884 | 6273.0 ± 0.4% | 2541.1 ± 0.4% | 2461.2 ± 2.4% | 467.6 ± 0.9% | 1539.8 ± 0.3% | 986.1 ± 0.5% | 2.469 | 2.549 | 13.415 | 4.074 | 6.361 |
| string: canterbury/plrabn12.txt | 503330 | 5721.3 ± 0.4% | 2048.5 ± 0.3% | 2067.1 ± 0.4% | 422.8 ± 0.4% | 1425.9 ± 0.3% | 930.8 ± 0.3% | 2.793 | 2.768 | 13.533 | 4.012 | 6.146 |
| string: canterbury-large/E.coli | 1048578 | 19236.9 ± 1.0% | 9718.3 ± 1.4% | 3789.0 ± 0.8% | 1477.8 ± 0.3% | 2362.6 ± 0.6% | 1195.2 ± 0.3% | 1.979 | 5.077 | 13.018 | 8.142 | 16.096 |
| string: canterbury-large/bible.txt | 1055886 | 6797.5 ± 0.3% | 4143.9 ± 1.4% | 3020.4 ± 1.7% | 500.1 ± 1.1% | 1970.5 ± 0.5% | 1119.8 ± 1.5% | 1.640 | 2.251 | 13.593 | 3.450 | 6.070 |
| string: canterbury-large/world192.txt | 1103121 | 4047.2 ± 0.6% | 1652.7 ± 0.4% | 1998.4 ± 0.4% | 448.0 ± 0.3% | 1359.6 ± 0.2% | 907.9 ± 0.3% | 2.449 | 2.025 | 9.033 | 2.977 | 4.458 |
| string: http/html-1m | 1058582 | 6777.2 ± 0.4% | 3974.3 ± 0.5% | 3046.2 ± 0.5% | 500.1 ± 0.4% | 1918.3 ± 0.5% | 804.9 ± 0.4% | 1.705 | 2.225 | 13.552 | 3.533 | 8.419 |
| string: http/json-1m | 1190272 | 3169.8 ± 0.5% | 1344.6 ± 0.3% | 1555.7 ± 0.3% | 444.1 ± 0.6% | 961.3 ± 0.2% | 764.4 ± 0.6% | 2.357 | 2.038 | 7.137 | 3.298 | 4.147 |
| string: http/js-1m | 1144362 | 2776.2 ± 0.7% | 1177.8 ± 0.3% | 1628.0 ± 0.4% | 368.7 ± 0.1% | 1095.1 ± 0.2% | 757.4 ± 0.4% | 2.357 | 1.705 | 7.530 | 2.535 | 3.666 |
| string: http/css-1m | 1097820 | 4002.6 ± 0.8% | 1482.1 ± 0.6% | 2152.0 ± 0.5% | 493.8 ± 0.7% | 1371.5 ± 0.4% | 895.3 ± 0.5% | 2.701 | 1.860 | 8.106 | 2.918 | 4.471 |
| string: dickens as Cyrillic and CJK | 1883069 | 3069.3 ± 0.5% | 2343.7 ± 0.4% | 521.4 ± 0.3% | 306.9 ± 0.7% | 559.5 ± 1.6% | 335.9 ± 0.6% | 1.310 | 5.886 | 10.001 | 5.485 | 9.138 |
| hex: silesia/dickens | 524290 | 15586.3 ± 0.8% | 1461.8 ± 0.2% | 1084.4 ± 0.3% | 497.5 ± 0.6% | 988.5 ± 0.3% | 733.1 ± 0.6% | 10.662 | 14.373 | 31.328 | 15.767 | 21.260 |
| hex: silesia/mozilla | 524290 | 15657.7 ± 0.4% | 1473.6 ± 0.2% | 1087.5 ± 0.4% | 442.1 ± 0.7% | 991.4 ± 0.2% | 734.6 ± 0.4% | 10.625 | 14.398 | 35.419 | 15.794 | 21.314 |
| hex: silesia/mr | 524290 | 15614.8 ± 0.3% | 1481.2 ± 0.7% | 1090.5 ± 0.7% | 558.5 ± 1.0% | 995.4 ± 0.6% | 734.3 ± 0.3% | 10.542 | 14.319 | 27.961 | 15.687 | 21.264 |
| hex: silesia/nci | 524290 | 15642.6 ± 0.4% | 1469.4 ± 0.8% | 1087.6 ± 0.7% | 639.6 ± 4.2% | 992.5 ± 0.6% | 732.6 ± 0.2% | 10.646 | 14.382 | 24.456 | 15.761 | 21.352 |
| hex: silesia/ooffice | 524290 | 15482.2 ± 0.9% | 1460.6 ± 2.5% | 1083.9 ± 0.8% | 389.2 ± 0.5% | 990.6 ± 1.2% | 733.8 ± 1.3% | 10.600 | 14.284 | 39.782 | 15.629 | 21.099 |
| hex: silesia/osdb | 524290 | 15643.2 ± 0.3% | 1467.1 ± 1.2% | 1085.9 ± 1.1% | 467.1 ± 0.7% | 989.6 ± 0.7% | 734.3 ± 0.3% | 10.663 | 14.406 | 33.491 | 15.808 | 21.305 |
| hex: silesia/reymont | 524290 | 15541.5 ± 0.6% | 1460.9 ± 0.5% | 1085.8 ± 0.3% | 515.2 ± 1.3% | 990.1 ± 0.7% | 734.8 ± 0.4% | 10.638 | 14.313 | 30.168 | 15.697 | 21.152 |
| hex: silesia/samba | 524290 | 15629.2 ± 0.4% | 1464.1 ± 0.7% | 1082.8 ± 0.6% | 402.4 ± 0.6% | 990.0 ± 0.6% | 733.2 ± 0.4% | 10.675 | 14.435 | 38.845 | 15.787 | 21.317 |
| hex: silesia/sao | 524290 | 15652.9 ± 0.4% | 1464.1 ± 0.4% | 1084.6 ± 0.5% | 332.3 ± 0.3% | 991.3 ± 0.5% | 733.8 ± 0.4% | 10.691 | 14.432 | 47.102 | 15.791 | 21.331 |
| hex: silesia/webster | 524290 | 15663.2 ± 0.5% | 1462.9 ± 0.3% | 1084.8 ± 0.4% | 472.8 ± 0.4% | 989.2 ± 0.6% | 732.8 ± 0.7% | 10.707 | 14.439 | 33.130 | 15.833 | 21.375 |
| hex: silesia/x-ray | 524290 | 15645.9 ± 0.3% | 1474.6 ± 0.3% | 1088.3 ± 0.2% | 444.1 ± 0.9% | 996.8 ± 0.5% | 734.3 ± 0.5% | 10.610 | 14.376 | 35.231 | 15.696 | 21.307 |
| hex: silesia/xml | 524290 | 15646.1 ± 0.2% | 1467.4 ± 0.4% | 1085.5 ± 0.2% | 609.3 ± 1.4% | 991.4 ± 0.8% | 734.8 ± 0.4% | 10.662 | 14.414 | 25.679 | 15.783 | 21.293 |
| hex: canterbury/alice29.txt | 304180 | 15703.7 ± 0.4% | 1470.7 ± 0.5% | 1090.4 ± 0.3% | 501.6 ± 0.3% | 993.8 ± 0.5% | 735.4 ± 0.4% | 10.678 | 14.402 | 31.308 | 15.801 | 21.354 |
| hex: canterbury/asyoulik.txt | 250360 | 15712.6 ± 0.0% | 1475.1 ± 0.4% | 1093.1 ± 0.4% | 497.3 ± 1.3% | 994.2 ± 0.3% | 739.0 ± 0.8% | 10.652 | 14.374 | 31.595 | 15.805 | 21.263 |
| hex: canterbury/cp.html | 49208 | 15668.8 ± 0.0% | 1474.7 ± 0.3% | 1098.2 ± 0.2% | 528.4 ± 2.1% | 1000.9 ± 0.5% | 743.9 ± 0.2% | 10.625 | 14.267 | 29.651 | 15.654 | 21.063 |
| hex: canterbury/fields.c | 22302 | 15521.0 ± 0.0% | 1423.2 ± 0.2% | 1068.0 ± 0.4% | 630.4 ± 5.4% | 987.9 ± 0.2% | 736.5 ± 0.3% | 10.906 | 14.532 | 24.621 | 15.711 | 21.073 |
| hex: canterbury/grammar.lsp | 7444 | 15153.2 ± 0.1% | 1491.0 ± 0.4% | 1094.0 ± 0.4% | 659.3 ± 5.0% | 988.1 ± 1.0% | 726.2 ± 0.4% | 10.163 | 13.851 | 22.985 | 15.335 | 20.867 |
| hex: canterbury/kennedy.xls | 524290 | 15629.0 ± 0.1% | 1471.1 ± 0.6% | 1088.5 ± 0.5% | 658.0 ± 2.0% | 989.8 ± 0.4% | 733.4 ± 0.4% | 10.624 | 14.358 | 23.753 | 15.791 | 21.310 |
| hex: canterbury/lcet10.txt | 524290 | 15629.9 ± 0.2% | 1460.1 ± 1.4% | 1085.6 ± 2.0% | 497.1 ± 2.6% | 988.4 ± 0.4% | 733.8 ± 0.1% | 10.704 | 14.398 | 31.442 | 15.813 | 21.299 |
| hex: canterbury/plrabn12.txt | 524290 | 15564.0 ± 0.6% | 1458.3 ± 0.6% | 1085.1 ± 0.4% | 484.9 ± 2.7% | 988.9 ± 0.5% | 731.7 ± 0.6% | 10.672 | 14.343 | 32.095 | 15.738 | 21.270 |
| hex: canterbury/ptt5 | 524290 | 15584.9 ± 0.5% | 1478.2 ± 0.3% | 1092.3 ± 0.3% | 553.5 ± 0.7% | 990.8 ± 0.3% | 733.0 ± 0.8% | 10.543 | 14.268 | 28.157 | 15.729 | 21.262 |
| hex: canterbury/sum | 76482 | 15678.2 ± 0.1% | 1494.9 ± 0.2% | 1105.0 ± 0.1% | 594.2 ± 2.0% | 998.4 ± 0.1% | 743.9 ± 0.9% | 10.488 | 14.189 | 26.386 | 15.704 | 21.075 |
| hex: canterbury/xargs.1 | 8456 | 15205.0 ± 0.0% | 1431.7 ± 1.4% | 1092.8 ± 0.6% | 640.7 ± 5.4% | 1000.9 ± 0.2% | 726.9 ± 0.5% | 10.620 | 13.914 | 23.730 | 15.191 | 20.917 |
| hex: canterbury-large/E.coli | 524290 | 15565.4 ± 1.2% | 1471.0 ± 0.0% | 1089.1 ± 0.7% | 671.8 ± 0.2% | 993.2 ± 0.5% | 733.0 ± 0.9% | 10.582 | 14.292 | 23.169 | 15.672 | 21.234 |
| hex: canterbury-large/bible.txt | 524290 | 15624.6 ± 0.4% | 1461.9 ± 0.4% | 1085.3 ± 0.5% | 512.6 ± 1.2% | 986.8 ± 0.3% | 733.1 ± 0.3% | 10.688 | 14.396 | 30.479 | 15.833 | 21.313 |
| hex: canterbury-large/world192.txt | 524290 | 15605.4 ± 0.1% | 1462.0 ± 0.6% | 1083.2 ± 1.5% | 501.2 ± 1.0% | 989.5 ± 1.0% | 731.4 ± 1.5% | 10.674 | 14.406 | 31.134 | 15.772 | 21.336 |
| hex: http/html-1kx1024 | 2099200 | 14126.4 ± 0.7% | 1454.7 ± 0.2% | 1062.4 ± 0.2% | 501.6 ± 0.5% | 982.7 ± 0.2% | 692.0 ± 0.2% | 9.711 | 13.297 | 28.163 | 14.376 | 20.413 |
| hex: http/html-16kx64 | 2097280 | 15370.6 ± 0.6% | 1442.9 ± 0.3% | 1075.0 ± 0.2% | 506.0 ± 0.4% | 995.1 ± 0.1% | 733.6 ± 0.3% | 10.652 | 14.298 | 30.374 | 15.446 | 20.953 |
| hex: http/html-1m | 524290 | 15644.5 ± 0.7% | 1468.5 ± 1.1% | 1084.8 ± 0.6% | 499.9 ± 1.0% | 989.2 ± 0.4% | 733.5 ± 0.6% | 10.654 | 14.421 | 31.298 | 15.815 | 21.328 |
| hex: http/json-1kx1024 | 2099200 | 14138.5 ± 36.3% | 1461.8 ± 0.2% | 1066.1 ± 0.3% | 607.3 ± 0.8% | 986.4 ± 0.4% | 692.1 ± 0.4% | 9.672 | 13.262 | 23.283 | 14.333 | 20.430 |
| hex: http/json-16kx64 | 2097280 | 15379.5 ± 0.4% | 1445.6 ± 0.2% | 1074.6 ± 0.2% | 616.7 ± 0.4% | 994.5 ± 0.3% | 734.6 ± 0.1% | 10.639 | 14.312 | 24.939 | 15.465 | 20.936 |
| hex: http/json-1m | 524290 | 15610.2 ± 0.4% | 1470.3 ± 0.4% | 1089.0 ± 0.3% | 637.2 ± 1.0% | 994.2 ± 0.3% | 733.7 ± 0.3% | 10.617 | 14.334 | 24.497 | 15.701 | 21.277 |
| hex: http/js-1kx1024 | 2099200 | 14147.9 ± 0.6% | 1454.3 ± 0.2% | 1063.9 ± 0.4% | 499.3 ± 0.3% | 983.2 ± 0.3% | 692.5 ± 0.1% | 9.728 | 13.298 | 28.336 | 14.389 | 20.431 |
| hex: http/js-16kx64 | 2097280 | 15385.7 ± 0.5% | 1445.0 ± 0.3% | 1074.6 ± 0.3% | 503.5 ± 0.5% | 993.8 ± 0.6% | 735.0 ± 0.2% | 10.648 | 14.318 | 30.556 | 15.482 | 20.934 |
| hex: http/js-1m | 524290 | 15519.2 ± 0.3% | 1463.1 ± 0.7% | 1085.6 ± 0.4% | 508.7 ± 0.3% | 992.3 ± 0.4% | 733.6 ± 0.4% | 10.607 | 14.296 | 30.507 | 15.640 | 21.155 |
| hex: http/css-1kx1024 | 2099200 | 14099.6 ± 0.5% | 1455.2 ± 0.2% | 1063.0 ± 0.1% | 530.7 ± 0.3% | 983.1 ± 0.4% | 692.0 ± 0.9% | 9.689 | 13.264 | 26.570 | 14.343 | 20.375 |
| hex: http/css-16kx64 | 2097280 | 15358.1 ± 0.5% | 1442.2 ± 0.1% | 1073.6 ± 0.2% | 540.4 ± 0.2% | 998.9 ± 0.6% | 734.3 ± 0.2% | 10.649 | 14.305 | 28.420 | 15.376 | 20.915 |
| hex: http/css-1m | 524290 | 15671.1 ± 0.3% | 1462.8 ± 0.3% | 1085.2 ± 0.9% | 525.4 ± 0.6% | 986.8 ± 0.7% | 733.2 ± 0.4% | 10.713 | 14.441 | 29.827 | 15.880 | 21.374 |
| hex: shuffled/dickens-1m | 524290 | 15616.9 ± 0.2% | 1464.8 ± 0.4% | 1084.7 ± 0.2% | 501.2 ± 0.4% | 989.2 ± 0.6% | 732.6 ± 0.2% | 10.661 | 14.398 | 31.161 | 15.787 | 21.317 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.917 of yyjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.946 of simdjson.
