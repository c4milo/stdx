# bench-json

| Field | Value |
|---|---|
| Commit | 4dbe46c |
| Runner label | ubuntu-24.04-arm |
| Image version | 20261111.182.1 |
| CPU model | Neoverse-N2 |
| Virtual CPUs | 4 |
| Kernel | 7.0.0-1017-azure |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/43464704827 |
| Date | 2026-11-13 |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1. The `TextReader.next_items` column is that helper's queued tokens a slice a call (decision 79), over many tokens a call.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | TextReader.next_items | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1128.5 ± 0.1% | 0.523 | 0.965 | 0.996 | 0.998 | 0.457 | 1.003 | 1.006 | 0.383 | 0.831 | 0.899 | 0.101 |
| qlog records, JSON text sequence | 1467503 | 857.4 ± 1.3% | 0.815 | 0.999 | 0.999 | 0.999 | 0.442 | 0.993 | 1.027 | 0.393 | 0.919 | 0.987 | 0.124 |
| string: silesia/dickens | 172528 | 5049.2 ± 0.3% | 0.033 | 0.781 | 1.002 | 1.002 | 0.197 | 1.016 | 1.006 | 0.196 | 1.002 | 1.002 | 0.032 |
| string: silesia/nci | 1075110 | 4309.7 ± 0.4% | 0.039 | 0.802 | 1.001 | 1.002 | 0.276 | 1.003 | 0.996 | 0.279 | 1.002 | 1.002 | 0.038 |
| string: silesia/reymont | 1075159 | 2939.1 ± 2.7% | 0.057 | 0.817 | 1.001 | 1.008 | 0.358 | 1.006 | 1.007 | 0.359 | 1.020 | 1.013 | 0.056 |
| string: silesia/samba | 97582 | 3503.6 ± 0.6% | 0.041 | 0.860 | 1.001 | 1.003 | 0.069 | 0.776 | 1.008 | 0.066 | 0.999 | 1.002 | 0.040 |
| string: silesia/webster | 1098490 | 3646.7 ± 0.7% | 0.044 | 0.846 | 1.003 | 1.004 | 0.204 | 1.021 | 1.015 | 0.203 | 1.008 | 1.007 | 0.044 |
| string: silesia/xml | 1090118 | 4791.5 ± 0.5% | 0.035 | 0.808 | 1.007 | 1.007 | 0.221 | 0.981 | 1.006 | 0.218 | 1.004 | 1.005 | 0.034 |
| string: canterbury/alice29.txt | 159425 | 4303.2 ± 0.8% | 0.038 | 0.753 | 1.004 | 1.007 | 0.172 | 1.032 | 1.018 | 0.172 | 1.018 | 1.020 | 0.037 |
| string: canterbury/asyoulik.txt | 132198 | 3457.4 ± 1.0% | 0.046 | 0.748 | 1.007 | 1.010 | 0.175 | 1.003 | 0.969 | 0.175 | 1.009 | 1.011 | 0.045 |
| string: canterbury/lcet10.txt | 441884 | 5121.0 ± 0.4% | 0.032 | 0.814 | 1.002 | 1.004 | 0.196 | 1.016 | 1.005 | 0.195 | 1.005 | 1.006 | 0.032 |
| string: canterbury/plrabn12.txt | 503330 | 4135.9 ± 0.5% | 0.039 | 0.821 | 1.003 | 1.002 | 0.197 | 1.007 | 0.995 | 0.197 | 1.006 | 1.004 | 0.039 |
| string: canterbury-large/E.coli | 1048578 | 19248.5 ± 0.6% | 0.077 | 1.007 | 1.006 | 1.007 | 0.482 | 1.007 | 1.007 | 0.483 | 0.620 | 0.622 | 0.009 |
| string: canterbury-large/bible.txt | 1055886 | 6701.0 ± 1.1% | 0.026 | 0.800 | 1.003 | 1.007 | 0.432 | 1.031 | 1.039 | 0.432 | 1.035 | 1.037 | 0.025 |
| string: canterbury-large/world192.txt | 1103121 | 3387.3 ± 0.9% | 0.048 | 0.845 | 1.002 | 1.002 | 0.198 | 1.014 | 1.007 | 0.198 | 1.004 | 1.005 | 0.047 |
| string: http/html-1m | 1058582 | 6067.4 ± 1.5% | 0.028 | 0.782 | 1.000 | 1.006 | 0.388 | 1.038 | 1.052 | 0.389 | 1.027 | 1.028 | 0.028 |
| string: http/json-1m | 1190272 | 2552.4 ± 0.7% | 0.056 | 0.950 | 1.003 | 1.001 | 0.109 | 1.005 | 0.470 | 0.110 | 1.003 | 1.003 | 0.055 |
| string: http/js-1m | 1144362 | 2287.6 ± 0.8% | 0.067 | 0.888 | 0.999 | 1.001 | 0.174 | 1.054 | 1.044 | 0.174 | 1.000 | 1.000 | 0.065 |
| string: http/css-1m | 1097820 | 2639.5 ± 0.4% | 0.061 | 0.776 | 1.003 | 1.007 | 0.238 | 1.006 | 1.013 | 0.239 | 1.007 | 1.010 | 0.060 |
| string: dickens as Cyrillic and CJK | 1883069 | 3077.1 ± 0.8% | 0.044 | 0.124 | 1.001 | 1.002 | 0.336 | 0.999 | 1.007 | 0.336 | 1.002 | 1.001 | 0.044 |
| string: dickens as Cyrillic and CJK, as \u escapes | 5075485 | 1328.5 ± 1.5% | 0.085 | 1.002 | 1.002 | 1.002 | 0.078 | 0.637 | 1.004 | 0.074 | 1.002 | 1.002 | 0.085 |
| hex: silesia/dickens | 524290 | 19155.2 ± 1.0% | 0.078 | 1.006 | 1.000 | 0.999 | 0.497 | 0.994 | 0.989 | 0.499 | 0.626 | 0.625 | 0.009 |
| hex: silesia/mozilla | 524290 | 18993.0 ± 0.3% | 0.078 | 1.004 | 0.999 | 0.999 | 0.507 | 1.001 | 0.997 | 0.507 | 0.632 | 0.632 | 0.009 |
| hex: silesia/mr | 524290 | 18888.1 ± 0.3% | 0.079 | 1.000 | 1.000 | 0.999 | 0.520 | 1.002 | 1.003 | 0.521 | 0.636 | 0.636 | 0.009 |
| hex: silesia/nci | 524290 | 19085.7 ± 0.6% | 0.078 | 1.007 | 1.004 | 1.003 | 0.504 | 1.005 | 1.003 | 0.502 | 0.629 | 0.629 | 0.009 |
| hex: silesia/ooffice | 524290 | 18900.3 ± 1.2% | 0.079 | 1.009 | 1.003 | 0.999 | 0.508 | 1.001 | 1.003 | 0.506 | 0.636 | 0.636 | 0.009 |
| hex: silesia/osdb | 524290 | 18694.2 ± 0.4% | 0.080 | 1.008 | 1.003 | 1.003 | 0.514 | 1.002 | 1.005 | 0.515 | 0.639 | 0.642 | 0.009 |
| hex: silesia/reymont | 524290 | 18944.5 ± 0.5% | 0.079 | 1.003 | 0.996 | 0.997 | 0.512 | 0.995 | 0.999 | 0.510 | 0.634 | 0.634 | 0.009 |
| hex: silesia/samba | 524290 | 18706.4 ± 0.9% | 0.079 | 1.004 | 1.003 | 1.002 | 0.507 | 1.005 | 1.004 | 0.508 | 0.640 | 0.638 | 0.009 |
| hex: silesia/sao | 524290 | 18754.6 ± 0.4% | 0.079 | 1.001 | 1.000 | 1.000 | 0.508 | 1.002 | 1.003 | 0.508 | 0.638 | 0.639 | 0.009 |
| hex: silesia/webster | 524290 | 18862.4 ± 0.5% | 0.079 | 1.002 | 0.999 | 0.999 | 0.510 | 1.003 | 1.002 | 0.511 | 0.636 | 0.636 | 0.009 |
| hex: silesia/x-ray | 524290 | 18820.1 ± 0.4% | 0.079 | 1.003 | 0.998 | 0.997 | 0.523 | 1.000 | 1.000 | 0.524 | 0.635 | 0.638 | 0.009 |
| hex: silesia/xml | 524290 | 19101.9 ± 1.3% | 0.078 | 1.005 | 0.999 | 0.996 | 0.509 | 1.000 | 0.999 | 0.510 | 0.628 | 0.628 | 0.009 |
| hex: canterbury/alice29.txt | 304180 | 19367.5 ± 0.4% | 0.077 | 1.001 | 1.002 | 0.999 | 0.503 | 1.003 | 1.002 | 0.503 | 0.619 | 0.619 | 0.009 |
| hex: canterbury/asyoulik.txt | 250360 | 19534.6 ± 0.2% | 0.077 | 1.003 | 1.002 | 1.002 | 0.514 | 1.001 | 1.002 | 0.514 | 0.615 | 0.614 | 0.009 |
| hex: canterbury/cp.html | 49208 | 19252.9 ± 0.1% | 0.081 | 1.002 | 1.002 | 1.002 | 0.540 | 1.001 | 1.002 | 0.542 | 0.618 | 0.618 | 0.009 |
| hex: canterbury/fields.c | 22302 | 18835.1 ± 0.8% | 0.084 | 1.007 | 1.008 | 1.008 | 0.537 | 1.003 | 1.007 | 0.542 | 0.626 | 0.626 | 0.009 |
| hex: canterbury/grammar.lsp | 7444 | 17579.1 ± 0.4% | 0.089 | 1.001 | 1.002 | 1.003 | 0.526 | 1.001 | 1.002 | 0.543 | 0.640 | 0.645 | 0.010 |
| hex: canterbury/kennedy.xls | 524290 | 18949.0 ± 0.8% | 0.079 | 0.996 | 0.997 | 0.999 | 0.510 | 1.001 | 0.996 | 0.507 | 0.633 | 0.633 | 0.009 |
| hex: canterbury/lcet10.txt | 524290 | 18768.7 ± 0.8% | 0.079 | 1.004 | 1.005 | 1.005 | 0.514 | 1.004 | 1.008 | 0.515 | 0.640 | 0.640 | 0.009 |
| hex: canterbury/plrabn12.txt | 524290 | 18762.5 ± 0.8% | 0.079 | 1.008 | 1.000 | 1.001 | 0.512 | 0.997 | 1.002 | 0.512 | 0.639 | 0.638 | 0.009 |
| hex: canterbury/ptt5 | 524290 | 18835.1 ± 0.3% | 0.079 | 1.004 | 1.004 | 1.002 | 0.509 | 1.003 | 1.005 | 0.507 | 0.637 | 0.638 | 0.009 |
| hex: canterbury/sum | 76482 | 19306.8 ± 0.1% | 0.078 | 1.001 | 1.002 | 1.002 | 0.517 | 1.002 | 1.001 | 0.519 | 0.616 | 0.616 | 0.009 |
| hex: canterbury/xargs.1 | 8456 | 17847.2 ± 0.1% | 0.088 | 1.001 | 1.002 | 1.002 | 0.524 | 1.000 | 1.001 | 0.539 | 0.636 | 0.636 | 0.010 |
| hex: canterbury-large/E.coli | 524290 | 19079.1 ± 0.9% | 0.078 | 1.001 | 0.999 | 0.993 | 0.511 | 1.001 | 0.995 | 0.511 | 0.630 | 0.630 | 0.009 |
| hex: canterbury-large/bible.txt | 524290 | 18936.7 ± 0.8% | 0.079 | 1.007 | 1.001 | 0.999 | 0.506 | 0.998 | 1.002 | 0.507 | 0.634 | 0.634 | 0.009 |
| hex: canterbury-large/world192.txt | 524290 | 18842.4 ± 0.6% | 0.079 | 1.001 | 1.001 | 0.999 | 0.516 | 0.999 | 0.999 | 0.514 | 0.638 | 0.637 | 0.009 |
| hex: http/html-1kx1024 | 2099200 | 9796.6 ± 11.6% | 0.145 | 1.235 | 1.232 | 1.235 | 0.684 | 1.242 | 0.990 | 0.747 | 0.907 | 0.914 | 0.018 |
| hex: http/html-16kx64 | 2097280 | 18616.1 ± 0.4% | 0.081 | 1.008 | 1.004 | 1.005 | 0.552 | 1.006 | 0.996 | 0.556 | 0.633 | 0.633 | 0.009 |
| hex: http/html-1m | 524290 | 18878.4 ± 1.4% | 0.079 | 1.005 | 1.002 | 1.003 | 0.517 | 1.003 | 1.003 | 0.518 | 0.637 | 0.637 | 0.009 |
| hex: http/json-1kx1024 | 2099200 | 9847.0 ± 18.3% | 0.144 | 1.250 | 1.241 | 1.243 | 0.679 | 1.247 | 0.987 | 0.749 | 0.907 | 0.911 | 0.017 |
| hex: http/json-16kx64 | 2097280 | 18611.1 ± 0.4% | 0.081 | 1.007 | 1.005 | 1.006 | 0.551 | 1.008 | 0.997 | 0.556 | 0.633 | 0.633 | 0.009 |
| hex: http/json-1m | 524290 | 18853.6 ± 1.6% | 0.079 | 1.009 | 1.004 | 1.002 | 0.523 | 1.010 | 1.007 | 0.524 | 0.638 | 0.638 | 0.009 |
| hex: http/js-1kx1024 | 2099200 | 9940.6 ± 11.3% | 0.143 | 1.232 | 1.227 | 1.227 | 0.674 | 1.234 | 0.978 | 0.737 | 0.897 | 0.904 | 0.017 |
| hex: http/js-16kx64 | 2097280 | 18525.2 ± 1.4% | 0.081 | 1.013 | 1.010 | 1.011 | 0.552 | 1.011 | 1.001 | 0.558 | 0.636 | 0.636 | 0.009 |
| hex: http/js-1m | 524290 | 19172.9 ± 1.6% | 0.077 | 0.998 | 0.991 | 0.989 | 0.497 | 1.000 | 0.988 | 0.496 | 0.626 | 0.626 | 0.009 |
| hex: http/css-1kx1024 | 2099200 | 9818.8 ± 16.7% | 0.145 | 1.246 | 1.241 | 1.243 | 0.682 | 1.246 | 0.990 | 0.748 | 0.907 | 0.919 | 0.017 |
| hex: http/css-16kx64 | 2097280 | 18610.7 ± 1.1% | 0.081 | 1.010 | 1.006 | 1.006 | 0.551 | 1.009 | 0.999 | 0.556 | 0.633 | 0.633 | 0.009 |
| hex: http/css-1m | 524290 | 18993.3 ± 1.2% | 0.079 | 1.004 | 0.995 | 0.996 | 0.522 | 0.999 | 0.997 | 0.524 | 0.632 | 0.633 | 0.009 |
| hex: shuffled/dickens-1m | 524290 | 18779.8 ± 1.2% | 0.079 | 0.997 | 0.997 | 0.998 | 0.516 | 1.004 | 0.999 | 0.515 | 0.640 | 0.640 | 0.009 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1491.7 ± 1.0% | 0.443 | 1.002 | 0.967 | 1.005 | 1.007 | 0.266 | 1.001 | 0.547 | 0.914 | 0.088 | 1.027 |
| qlog records, JSON text sequence | 1467503 | 1273.7 ± 0.8% | 0.688 | 0.975 | 1.009 | 1.011 | 1.011 | 0.264 | 1.001 | 0.502 | 0.828 | 0.105 | 1.016 |
| string: silesia/dickens | 172528 | 6885.6 ± 0.4% | 0.025 | 1.001 | 1.003 | 1.002 | 1.003 | 0.165 | 0.717 | 1.004 | 1.004 | 0.025 | 1.035 |
| string: silesia/nci | 1075110 | 7331.4 ± 0.3% | 0.024 | 0.999 | 1.000 | 0.997 | 1.001 | 0.209 | 0.563 | 0.998 | 0.999 | 0.023 | 1.008 |
| string: silesia/reymont | 1075159 | 3332.1 ± 1.2% | 0.052 | 1.004 | 1.001 | 1.004 | 1.007 | 0.389 | 0.877 | 1.001 | 0.992 | 0.052 | 1.053 |
| string: silesia/samba | 97582 | 4180.5 ± 0.8% | 0.054 | 1.003 | 1.003 | 1.006 | 1.007 | 0.125 | 0.945 | 1.006 | 1.007 | 0.053 | 1.090 |
| string: silesia/webster | 1098490 | 4058.2 ± 0.3% | 0.042 | 1.008 | 1.008 | 1.007 | 1.008 | 0.210 | 0.886 | 0.999 | 1.006 | 0.042 | 1.010 |
| string: silesia/xml | 1090118 | 6108.6 ± 0.3% | 0.029 | 1.003 | 0.999 | 1.006 | 1.004 | 0.252 | 0.776 | 1.003 | 1.008 | 0.029 | 1.021 |
| string: canterbury/alice29.txt | 159425 | 6405.9 ± 1.4% | 0.027 | 1.011 | 1.011 | 1.011 | 1.014 | 0.131 | 0.653 | 1.002 | 1.004 | 0.027 | 1.065 |
| string: canterbury/asyoulik.txt | 132198 | 5577.6 ± 0.6% | 0.030 | 1.027 | 1.034 | 1.035 | 1.038 | 0.129 | 0.597 | 1.009 | 1.018 | 0.030 | 1.061 |
| string: canterbury/lcet10.txt | 441884 | 6241.5 ± 0.5% | 0.028 | 1.007 | 1.008 | 1.008 | 1.008 | 0.183 | 0.800 | 1.005 | 1.005 | 0.027 | 1.003 |
| string: canterbury/plrabn12.txt | 503330 | 5719.5 ± 0.4% | 0.030 | 1.002 | 1.001 | 1.000 | 1.002 | 0.167 | 0.697 | 1.003 | 1.002 | 0.030 | 1.009 |
| string: canterbury-large/E.coli | 1048578 | 19372.4 ± 1.0% | 0.077 | 1.002 | 1.002 | 1.001 | 1.003 | 0.481 | 1.001 | 1.001 | 1.001 | 0.009 | 1.000 |
| string: canterbury-large/bible.txt | 1055886 | 6804.4 ± 0.7% | 0.026 | 0.999 | 1.001 | 0.999 | 1.001 | 0.493 | 0.969 | 1.000 | 1.001 | 0.026 | 0.999 |
| string: canterbury-large/world192.txt | 1103121 | 4012.9 ± 0.7% | 0.043 | 1.024 | 1.019 | 1.017 | 1.020 | 0.192 | 0.835 | 1.004 | 1.013 | 0.043 | 1.003 |
| string: http/html-1m | 1058582 | 6763.3 ± 3.1% | 0.026 | 1.003 | 0.925 | 1.003 | 1.006 | 0.402 | 0.881 | 1.000 | 1.003 | 0.026 | 1.011 |
| string: http/json-1m | 1190272 | 3161.1 ± 0.2% | 0.051 | 1.004 | 0.966 | 1.004 | 1.003 | 0.132 | 0.371 | 0.999 | 1.001 | 0.051 | 1.046 |
| string: http/js-1m | 1144362 | 2769.3 ± 0.8% | 0.061 | 1.000 | 1.006 | 0.997 | 1.005 | 0.163 | 0.837 | 0.998 | 1.003 | 0.060 | 1.009 |
| string: http/css-1m | 1097820 | 3986.1 ± 0.8% | 0.043 | 1.003 | 1.006 | 1.008 | 1.010 | 0.207 | 0.645 | 1.000 | 1.006 | 0.043 | 1.014 |
| string: dickens as Cyrillic and CJK | 1883069 | 3072.7 ± 0.4% | 0.048 | 1.000 | 0.124 | 1.000 | 0.999 | 0.319 | 1.002 | 0.999 | 0.999 | 0.048 | 1.001 |
| hex: silesia/dickens | 524290 | 15647.8 ± 0.1% | 1.001 | 0.178 | 1.001 | 1.000 | 1.001 | 1.001 | 1.000 | 1.001 | 0.999 | 0.178 | 0.998 |
| hex: silesia/mozilla | 524290 | 15656.5 ± 0.3% | 1.001 | 0.178 | 1.003 | 1.002 | 1.000 | 1.001 | 1.001 | 1.001 | 1.000 | 0.178 | 1.000 |
| hex: silesia/mr | 524290 | 15659.9 ± 0.3% | 1.001 | 0.178 | 1.000 | 0.999 | 0.997 | 0.994 | 0.998 | 0.996 | 0.995 | 0.178 | 0.997 |
| hex: silesia/nci | 524290 | 15661.9 ± 0.2% | 1.000 | 0.178 | 1.000 | 1.000 | 0.999 | 0.998 | 1.000 | 1.001 | 1.001 | 0.178 | 1.001 |
| hex: silesia/ooffice | 524290 | 15622.6 ± 0.3% | 1.001 | 0.178 | 1.001 | 1.002 | 1.000 | 1.002 | 1.003 | 1.000 | 1.000 | 0.178 | 1.000 |
| hex: silesia/osdb | 524290 | 15647.3 ± 0.1% | 1.000 | 0.178 | 1.002 | 1.001 | 1.000 | 1.001 | 1.001 | 1.001 | 1.002 | 0.178 | 1.001 |
| hex: silesia/reymont | 524290 | 15581.1 ± 0.4% | 1.004 | 0.178 | 0.997 | 0.998 | 1.000 | 0.999 | 0.997 | 1.000 | 0.999 | 0.178 | 0.999 |
| hex: silesia/samba | 524290 | 15652.1 ± 0.3% | 1.001 | 0.178 | 0.999 | 1.001 | 1.000 | 0.997 | 1.001 | 0.999 | 1.002 | 0.178 | 0.998 |
| hex: silesia/sao | 524290 | 15652.9 ± 0.3% | 1.001 | 0.178 | 1.002 | 1.001 | 1.001 | 1.002 | 1.001 | 1.001 | 1.001 | 0.178 | 1.001 |
| hex: silesia/webster | 524290 | 15699.9 ± 0.2% | 1.001 | 0.177 | 1.000 | 1.000 | 1.001 | 0.998 | 1.000 | 1.001 | 1.000 | 0.177 | 1.002 |
| hex: silesia/x-ray | 524290 | 15643.3 ± 0.2% | 1.001 | 0.178 | 1.001 | 1.000 | 1.000 | 1.001 | 1.001 | 1.001 | 1.001 | 0.178 | 0.999 |
| hex: silesia/xml | 524290 | 15658.5 ± 0.3% | 1.000 | 0.178 | 1.000 | 1.000 | 1.000 | 0.999 | 1.000 | 0.999 | 1.001 | 0.178 | 1.000 |
| hex: canterbury/alice29.txt | 304180 | 15687.0 ± 0.2% | 1.001 | 0.178 | 1.001 | 1.000 | 1.000 | 1.000 | 1.001 | 1.001 | 1.001 | 0.178 | 1.001 |
| hex: canterbury/asyoulik.txt | 250360 | 15692.8 ± 0.2% | 1.001 | 0.178 | 1.001 | 1.001 | 1.001 | 1.000 | 1.000 | 1.001 | 1.001 | 0.177 | 1.001 |
| hex: canterbury/cp.html | 49208 | 15621.9 ± 0.2% | 1.001 | 0.179 | 1.000 | 1.000 | 1.000 | 0.998 | 1.001 | 1.001 | 1.003 | 0.179 | 1.001 |
| hex: canterbury/fields.c | 22302 | 15442.0 ± 0.1% | 1.002 | 0.181 | 1.000 | 1.000 | 1.000 | 0.994 | 1.000 | 1.001 | 1.005 | 0.180 | 1.001 |
| hex: canterbury/grammar.lsp | 7444 | 14938.4 ± 0.1% | 1.003 | 0.185 | 1.000 | 1.000 | 1.000 | 0.983 | 1.001 | 1.004 | 1.015 | 0.184 | 1.003 |
| hex: canterbury/kennedy.xls | 524290 | 15558.2 ± 0.7% | 1.002 | 0.179 | 0.999 | 1.002 | 1.000 | 1.000 | 1.000 | 0.999 | 1.003 | 0.179 | 1.001 |
| hex: canterbury/lcet10.txt | 524290 | 15639.9 ± 0.4% | 1.000 | 0.178 | 1.002 | 1.001 | 0.999 | 0.998 | 1.001 | 1.001 | 1.001 | 0.177 | 1.002 |
| hex: canterbury/plrabn12.txt | 524290 | 15677.1 ± 0.2% | 0.999 | 0.178 | 0.996 | 0.996 | 0.997 | 0.997 | 0.996 | 0.997 | 0.994 | 0.177 | 0.996 |
| hex: canterbury/ptt5 | 524290 | 15618.5 ± 0.4% | 1.003 | 0.179 | 1.004 | 1.002 | 1.001 | 1.002 | 1.000 | 1.003 | 1.003 | 0.179 | 1.004 |
| hex: canterbury/sum | 76482 | 15640.4 ± 0.1% | 1.001 | 0.179 | 1.000 | 1.000 | 1.000 | 0.999 | 1.001 | 1.001 | 1.002 | 0.178 | 1.001 |
| hex: canterbury/xargs.1 | 8456 | 14971.0 ± 0.1% | 1.002 | 0.184 | 1.001 | 1.001 | 1.000 | 0.986 | 1.001 | 1.004 | 1.015 | 0.183 | 1.003 |
| hex: canterbury-large/E.coli | 524290 | 15670.0 ± 0.5% | 1.001 | 0.178 | 1.000 | 1.000 | 1.000 | 1.000 | 1.000 | 1.000 | 1.000 | 0.178 | 1.001 |
| hex: canterbury-large/bible.txt | 524290 | 15612.3 ± 0.3% | 1.004 | 0.179 | 1.003 | 1.002 | 1.001 | 1.003 | 1.003 | 1.003 | 1.003 | 0.178 | 1.003 |
| hex: canterbury-large/world192.txt | 524290 | 15631.4 ± 0.2% | 1.002 | 0.178 | 1.001 | 1.002 | 1.002 | 1.002 | 1.002 | 1.001 | 1.001 | 0.178 | 1.001 |
| hex: http/html-1kx1024 | 2099200 | 13744.2 ± 0.5% | 1.007 | 0.195 | 1.001 | 1.003 | 1.003 | 0.940 | 1.001 | 1.011 | 1.033 | 0.187 | 1.013 |
| hex: http/html-16kx64 | 2097280 | 15300.0 ± 0.6% | 0.997 | 0.181 | 1.002 | 0.999 | 1.003 | 0.996 | 1.000 | 1.003 | 1.009 | 0.179 | 1.001 |
| hex: http/html-1m | 524290 | 15646.7 ± 0.1% | 1.002 | 0.177 | 1.003 | 1.001 | 1.003 | 1.001 | 1.001 | 1.002 | 1.002 | 0.177 | 1.002 |
| hex: http/json-1kx1024 | 2099200 | 13732.4 ± 0.5% | 1.007 | 0.195 | 1.003 | 1.003 | 0.998 | 0.940 | 1.000 | 1.011 | 1.036 | 0.187 | 1.013 |
| hex: http/json-16kx64 | 2097280 | 15263.5 ± 0.4% | 1.002 | 0.181 | 1.001 | 1.001 | 1.002 | 0.993 | 0.999 | 1.005 | 1.007 | 0.180 | 1.006 |
| hex: http/json-1m | 524290 | 15632.8 ± 0.3% | 1.001 | 0.178 | 0.998 | 0.998 | 0.998 | 0.997 | 0.996 | 0.997 | 0.998 | 0.178 | 0.998 |
| hex: http/js-1kx1024 | 2099200 | 13746.5 ± 0.8% | 1.007 | 0.195 | 1.003 | 1.000 | 1.002 | 0.939 | 1.000 | 1.011 | 1.038 | 0.187 | 1.011 |
| hex: http/js-16kx64 | 2097280 | 15320.6 ± 0.5% | 0.994 | 0.180 | 0.996 | 0.996 | 1.000 | 0.994 | 0.999 | 1.000 | 1.004 | 0.180 | 0.998 |
| hex: http/js-1m | 524290 | 15671.7 ± 0.3% | 1.001 | 0.177 | 1.001 | 1.002 | 1.001 | 0.999 | 1.000 | 0.999 | 0.998 | 0.177 | 1.000 |
| hex: http/css-1kx1024 | 2099200 | 13731.7 ± 0.4% | 1.006 | 0.195 | 0.999 | 1.002 | 1.001 | 0.940 | 0.998 | 1.005 | 1.032 | 0.187 | 1.006 |
| hex: http/css-16kx64 | 2097280 | 15218.3 ± 0.5% | 1.000 | 0.181 | 1.000 | 1.002 | 1.001 | 0.994 | 1.004 | 1.007 | 1.012 | 0.181 | 1.008 |
| hex: http/css-1m | 524290 | 15694.3 ± 0.2% | 1.000 | 0.177 | 1.001 | 1.001 | 1.001 | 1.001 | 1.001 | 1.001 | 0.999 | 0.177 | 1.001 |
| hex: shuffled/dickens-1m | 524290 | 15676.0 ± 0.3% | 0.999 | 0.178 | 1.001 | 1.001 | 1.002 | 1.001 | 1.002 | 1.001 | 1.001 | 0.177 | 1.002 |

## Losses

Each workload where a claim's path ran slower than the path it replaces by more than the noise floor of decision 20.

- string: http/html-1m, decoding: J13 decoder escape blocks off runs at 1.052 of all on.
- string: http/js-1m, decoding: J12 decoder escape words off runs at 1.054 of all on.
- hex: http/html-1kx1024, decoding: J5 UTF-8 vectors off runs at 1.235 of all on.
- hex: http/html-1kx1024, decoding: J7 wide vectors off runs at 1.232 of all on.
- hex: http/html-1kx1024, decoding: J8 decoder fast path off runs at 1.235 of all on.
- hex: http/html-1kx1024, decoding: J12 decoder escape words off runs at 1.242 of all on.
- hex: http/json-1kx1024, decoding: J5 UTF-8 vectors off runs at 1.250 of all on.
- hex: http/json-1kx1024, decoding: J7 wide vectors off runs at 1.241 of all on.
- hex: http/json-1kx1024, decoding: J8 decoder fast path off runs at 1.243 of all on.
- hex: http/json-1kx1024, decoding: J12 decoder escape words off runs at 1.247 of all on.
- hex: http/js-1kx1024, decoding: J5 UTF-8 vectors off runs at 1.232 of all on.
- hex: http/js-1kx1024, decoding: J7 wide vectors off runs at 1.227 of all on.
- hex: http/js-1kx1024, decoding: J8 decoder fast path off runs at 1.227 of all on.
- hex: http/js-1kx1024, decoding: J12 decoder escape words off runs at 1.234 of all on.
- hex: http/css-1kx1024, decoding: J5 UTF-8 vectors off runs at 1.246 of all on.
- hex: http/css-1kx1024, decoding: J7 wide vectors off runs at 1.241 of all on.
- hex: http/css-1kx1024, decoding: J8 decoder fast path off runs at 1.243 of all on.
- hex: http/css-1kx1024, decoding: J12 decoder escape words off runs at 1.246 of all on.

## UTF-8 validation against simdutf

stdx's `is_utf8`, the check the loops apply to every string's octets, run alone over each string workload's octets at the width the host's features pick (16 lanes on aarch64, AVX2's 32 or AVX-512's 64 on x86-64, decision 39), beside simdutf 9.3.3's `validate_utf8` in the same run; on a host with AVX-512, again with AVX2 alone. Each ratio is stdx's throughput over the other's. simdutf picks its kernel at run time. Before timing, every copy of the check and simdutf judged 20000 seeded buffers and each workload, whole and changed, alike.

| Workload | Octets | stdx, MB/s | simdutf, MB/s | stdx / simdutf | stdx with AVX2 alone, MB/s | stdx / stdx with AVX2 alone |
|---|---|---|---|---|---|---|
| string: silesia/dickens | 166668 | 43343.4 ± 0.2% | 47420.9 ± 0.2% | 0.914 | — | — |
| string: silesia/nci | 1048576 | 37202.1 ± 5.3% | 39845.2 ± 3.2% | 0.934 | — | — |
| string: silesia/reymont | 1048576 | 39120.2 ± 2.8% | 42301.3 ± 4.1% | 0.925 | — | — |
| string: silesia/samba | 65546 | 43572.4 ± 0.1% | 48514.0 ± 0.0% | 0.898 | — | — |
| string: silesia/webster | 1048576 | 38726.5 ± 6.6% | 42880.1 ± 4.2% | 0.903 | — | — |
| string: silesia/xml | 1048576 | 34019.4 ± 2.8% | 35015.9 ± 1.4% | 0.972 | — | — |
| string: canterbury/alice29.txt | 152089 | 35900.8 ± 0.1% | 36556.4 ± 0.1% | 0.982 | — | — |
| string: canterbury/asyoulik.txt | 125179 | 43327.6 ± 0.1% | 47665.0 ± 0.1% | 0.909 | — | — |
| string: canterbury/lcet10.txt | 426754 | 36094.9 ± 0.2% | 36723.6 ± 0.1% | 0.983 | — | — |
| string: canterbury/plrabn12.txt | 481861 | 41913.4 ± 0.4% | 45636.3 ± 1.0% | 0.918 | — | — |
| string: canterbury-large/E.coli | 1048576 | 38138.7 ± 3.0% | 41256.7 ± 2.1% | 0.924 | — | — |
| string: canterbury-large/bible.txt | 1048576 | 33298.7 ± 1.4% | 34187.2 ± 2.3% | 0.974 | — | — |
| string: canterbury-large/world192.txt | 1048576 | 33149.1 ± 1.7% | 33980.0 ± 1.4% | 0.976 | — | — |
| string: http/html-1m | 1048576 | 36601.7 ± 2.8% | 39824.9 ± 3.0% | 0.919 | — | — |
| string: http/json-1m | 1048576 | 33928.9 ± 2.8% | 36425.9 ± 3.8% | 0.931 | — | — |
| string: http/js-1m | 1048576 | 36959.8 ± 1.6% | 39836.7 ± 1.0% | 0.928 | — | — |
| string: http/css-1m | 1048576 | 40333.3 ± 4.3% | 43303.2 ± 3.2% | 0.931 | — | — |
| string: dickens as Cyrillic and CJK | 1847045 | 5772.3 ± 0.3% | 5657.2 ± 0.1% | 1.020 | — | — |

## Losses to simdutf

- string: silesia/dickens: stdx runs at 0.914 of simdutf.
- string: silesia/nci: stdx runs at 0.934 of simdutf.
- string: silesia/reymont: stdx runs at 0.925 of simdutf.
- string: silesia/samba: stdx runs at 0.898 of simdutf.
- string: silesia/webster: stdx runs at 0.903 of simdutf.
- string: canterbury/asyoulik.txt: stdx runs at 0.909 of simdutf.
- string: canterbury/plrabn12.txt: stdx runs at 0.918 of simdutf.
- string: canterbury-large/E.coli: stdx runs at 0.924 of simdutf.
- string: http/html-1m: stdx runs at 0.919 of simdutf.
- string: http/json-1m: stdx runs at 0.931 of simdutf.
- string: http/js-1m: stdx runs at 0.928 of simdutf.
- string: http/css-1m: stdx runs at 0.931 of simdutf.

## UTF-8 validation by the buffer's offset from a 64-octet line

| Buffer | Octets | Offset | stdx, MB/s | simdutf, MB/s | stdx / simdutf | stdx with AVX2 alone, MB/s | stdx / stdx with AVX2 alone |
|---|---|---|---|---|---|---|---|
| string: canterbury-large/bible.txt | 1048576 | 0 | 42068.3 ± 3.8% | 47080.8 ± 3.5% | 0.894 | — | — |
| string: canterbury-large/bible.txt | 1048576 | 1 | 35236.6 ± 2.8% | 35970.6 ± 1.1% | 0.980 | — | — |
| string: canterbury-large/bible.txt | 1048576 | 8 | 40597.4 ± 3.2% | 44472.8 ± 2.6% | 0.913 | — | — |
| string: canterbury-large/bible.txt | 1048576 | 16 | 41999.4 ± 3.5% | 46064.8 ± 3.2% | 0.912 | — | — |
| string: canterbury-large/bible.txt | 1048576 | 32 | 41113.4 ± 2.5% | 45264.0 ± 4.1% | 0.908 | — | — |
| string: canterbury-large/bible.txt | 1048576 | 48 | 41344.2 ± 1.6% | 45615.7 ± 0.7% | 0.906 | — | — |
| string: dickens as Cyrillic and CJK | 1048576 | 0 | 5768.2 ± 0.4% | 5651.2 ± 0.1% | 1.021 | — | — |
| string: dickens as Cyrillic and CJK | 1048576 | 1 | 5765.0 ± 0.2% | 5648.2 ± 0.2% | 1.021 | — | — |
| string: dickens as Cyrillic and CJK | 1048576 | 8 | 5766.9 ± 0.3% | 5647.3 ± 0.3% | 1.021 | — | — |
| string: dickens as Cyrillic and CJK | 1048576 | 16 | 5764.1 ± 0.1% | 5648.9 ± 0.2% | 1.020 | — | — |
| string: dickens as Cyrillic and CJK | 1048576 | 32 | 5768.4 ± 0.2% | 5651.4 ± 0.1% | 1.021 | — | — |
| string: dickens as Cyrillic and CJK | 1048576 | 48 | 5773.7 ± 0.2% | 5651.3 ± 0.2% | 1.022 | — | — |

## Against the baselines

stdx with every claim on, timed beside simdjson 5.1.1, yyjson 0.13.0, Zig 0.16.0's std.json, serde_json 1.0.154 and Go's encoding/json/jsontext in the same run. Each ratio is stdx's throughput over the baseline's; below 1, the baseline is faster. stdx is built for the architecture's baseline CPU in ReleaseSafe. Each baseline is built for the same CPU, the C, C++ and Zig ones in ReleaseFast (decision 75), and simdjson picks its kernel at run time. Decoding visits every value; encoding writes each text from its tokens.

## Decoding against the baselines

Octets are the text's. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1128.5 ± 0.1% | 922.7 ± 0.7% | 1018.8 ± 2.1% | 301.1 ± 1.0% | 666.1 ± 0.3% | 311.1 ± 4.1% | 1.223 | 1.108 | 3.748 | 1.694 | 3.628 |
| qlog records, JSON text sequence | 1467503 | 857.4 ± 1.3% | 814.9 ± 0.2% | 813.6 ± 1.6% | 244.5 ± 0.6% | 704.8 ± 0.2% | 252.9 ± 0.6% | 1.052 | 1.054 | 3.506 | 1.216 | 3.390 |
| string: silesia/dickens | 172528 | 5049.2 ± 0.3% | 1879.5 ± 0.2% | 2649.6 ± 0.3% | 361.4 ± 0.9% | 2864.5 ± 0.3% | 556.1 ± 1.8% | 2.686 | 1.906 | 13.970 | 1.763 | 9.079 |
| string: silesia/nci | 1075110 | 4309.7 ± 0.4% | 2240.4 ± 0.3% | 3005.0 ± 0.2% | 543.2 ± 1.5% | 3010.8 ± 1.3% | 603.0 ± 1.3% | 1.924 | 1.434 | 7.934 | 1.431 | 7.147 |
| string: silesia/reymont | 1075159 | 2939.1 ± 2.7% | 1812.6 ± 1.1% | 2063.5 ± 0.2% | 375.2 ± 1.5% | 2147.0 ± 0.4% | 538.8 ± 0.7% | 1.622 | 1.424 | 7.834 | 1.369 | 5.455 |
| string: silesia/samba | 97582 | 3503.6 ± 0.6% | 2027.4 ± 0.2% | 2619.5 ± 0.2% | 324.3 ± 0.4% | 1509.3 ± 0.7% | 432.2 ± 1.1% | 1.728 | 1.338 | 10.805 | 2.321 | 8.106 |
| string: silesia/webster | 1098490 | 3646.7 ± 0.7% | 1519.4 ± 0.4% | 2015.4 ± 0.5% | 359.3 ± 0.3% | 2184.3 ± 1.6% | 502.2 ± 1.7% | 2.400 | 1.809 | 10.151 | 1.670 | 7.261 |
| string: silesia/xml | 1090118 | 4791.5 ± 0.5% | 2362.8 ± 0.4% | 2536.8 ± 0.6% | 454.0 ± 1.4% | 2837.8 ± 0.6% | 569.4 ± 1.0% | 2.028 | 1.889 | 10.554 | 1.688 | 8.415 |
| string: canterbury/alice29.txt | 159425 | 4303.2 ± 0.8% | 1601.3 ± 0.2% | 2457.5 ± 0.6% | 342.4 ± 1.7% | 2507.6 ± 0.5% | 509.0 ± 0.9% | 2.687 | 1.751 | 12.569 | 1.716 | 8.454 |
| string: canterbury/asyoulik.txt | 132198 | 3457.4 ± 1.0% | 1459.2 ± 0.3% | 2247.5 ± 0.5% | 335.0 ± 0.5% | 2082.9 ± 0.3% | 465.3 ± 1.5% | 2.369 | 1.538 | 10.320 | 1.660 | 7.430 |
| string: canterbury/lcet10.txt | 441884 | 5121.0 ± 0.4% | 1852.9 ± 0.4% | 2336.2 ± 1.0% | 389.7 ± 0.8% | 2844.3 ± 0.9% | 537.1 ± 1.9% | 2.764 | 2.192 | 13.140 | 1.800 | 9.534 |
| string: canterbury/plrabn12.txt | 503330 | 4135.9 ± 0.5% | 1736.9 ± 0.2% | 2062.5 ± 0.3% | 362.1 ± 1.4% | 2527.8 ± 0.3% | 503.9 ± 1.1% | 2.381 | 2.005 | 11.423 | 1.636 | 8.208 |
| string: canterbury-large/E.coli | 1048578 | 19248.5 ± 0.6% | 3611.3 ± 0.3% | 3265.4 ± 0.6% | 928.9 ± 1.1% | 6091.0 ± 0.4% | 773.6 ± 0.3% | 5.330 | 5.895 | 20.721 | 3.160 | 24.881 |
| string: canterbury-large/bible.txt | 1055886 | 6701.0 ± 1.1% | 2940.1 ± 0.5% | 2840.6 ± 0.6% | 419.6 ± 1.9% | 3784.3 ± 1.5% | 621.5 ± 0.8% | 2.279 | 2.359 | 15.970 | 1.771 | 10.783 |
| string: canterbury-large/world192.txt | 1103121 | 3387.3 ± 0.9% | 1484.1 ± 0.4% | 2012.7 ± 0.3% | 352.1 ± 0.4% | 2121.3 ± 0.9% | 503.7 ± 1.2% | 2.282 | 1.683 | 9.619 | 1.597 | 6.724 |
| string: http/html-1m | 1058582 | 6067.4 ± 1.5% | 2738.0 ± 0.6% | 2706.7 ± 0.3% | 443.3 ± 0.8% | 3487.8 ± 0.9% | 600.4 ± 0.8% | 2.216 | 2.242 | 13.688 | 1.740 | 10.106 |
| string: http/json-1m | 1190272 | 2552.4 ± 0.7% | 877.7 ± 0.2% | 2256.8 ± 0.4% | 389.7 ± 0.3% | 1043.2 ± 2.6% | 444.0 ± 0.7% | 2.908 | 1.131 | 6.549 | 2.447 | 5.749 |
| string: http/js-1m | 1144362 | 2287.6 ± 0.8% | 1028.5 ± 0.4% | 1639.7 ± 0.3% | 320.8 ± 0.9% | 1522.3 ± 0.6% | 420.7 ± 0.5% | 2.224 | 1.395 | 7.131 | 1.503 | 5.437 |
| string: http/css-1m | 1097820 | 2639.5 ± 0.4% | 1678.5 ± 0.2% | 2231.3 ± 0.7% | 406.1 ± 0.8% | 1930.3 ± 1.4% | 491.2 ± 0.7% | 1.573 | 1.183 | 6.500 | 1.367 | 5.374 |
| string: dickens as Cyrillic and CJK | 1883069 | 3077.1 ± 0.8% | 1689.4 ± 0.4% | 895.8 ± 0.5% | 351.3 ± 0.1% | 666.7 ± 0.7% | 158.6 ± 2.1% | 1.821 | 3.435 | 8.760 | 4.615 | 19.400 |
| string: dickens as Cyrillic and CJK, as \u escapes | 5075485 | 1328.5 ± 1.5% | 981.0 ± 0.4% | 1213.1 ± 0.7% | 214.2 ± 0.1% | 471.3 ± 0.7% | 251.8 ± 3.3% | 1.354 | 1.095 | 6.203 | 2.819 | 5.277 |
| hex: silesia/dickens | 524290 | 19155.2 ± 1.0% | 3621.8 ± 0.1% | 3293.2 ± 0.2% | 505.6 ± 3.5% | 6081.2 ± 0.9% | 784.9 ± 2.1% | 5.289 | 5.817 | 37.885 | 3.150 | 24.406 |
| hex: silesia/mozilla | 524290 | 18993.0 ± 0.3% | 3617.2 ± 0.3% | 3300.1 ± 0.5% | 453.6 ± 1.9% | 6092.3 ± 1.1% | 787.2 ± 0.5% | 5.251 | 5.755 | 41.876 | 3.118 | 24.126 |
| hex: silesia/mr | 524290 | 18888.1 ± 0.3% | 3619.6 ± 0.2% | 3295.0 ± 0.1% | 563.1 ± 0.9% | 6099.1 ± 0.6% | 786.1 ± 0.3% | 5.218 | 5.732 | 33.541 | 3.097 | 24.027 |
| hex: silesia/nci | 524290 | 19085.7 ± 0.6% | 3617.3 ± 0.2% | 3292.1 ± 0.1% | 625.5 ± 0.7% | 6144.8 ± 0.8% | 786.0 ± 0.5% | 5.276 | 5.797 | 30.513 | 3.106 | 24.281 |
| hex: silesia/ooffice | 524290 | 18900.3 ± 1.2% | 3614.4 ± 0.3% | 3304.9 ± 0.2% | 395.5 ± 1.0% | 6109.8 ± 1.5% | 786.3 ± 0.5% | 5.229 | 5.719 | 47.787 | 3.093 | 24.037 |
| hex: silesia/osdb | 524290 | 18694.2 ± 0.4% | 3615.6 ± 0.4% | 3310.5 ± 0.1% | 480.9 ± 0.2% | 6042.8 ± 3.3% | 786.5 ± 0.3% | 5.170 | 5.647 | 38.872 | 3.094 | 23.769 |
| hex: silesia/reymont | 524290 | 18944.5 ± 0.5% | 3618.8 ± 0.2% | 3312.1 ± 0.2% | 512.3 ± 3.3% | 6098.0 ± 1.7% | 787.0 ± 0.6% | 5.235 | 5.720 | 36.979 | 3.107 | 24.072 |
| hex: silesia/samba | 524290 | 18706.4 ± 0.9% | 3618.3 ± 0.2% | 3298.2 ± 0.3% | 405.9 ± 1.3% | 6095.5 ± 0.6% | 786.7 ± 0.4% | 5.170 | 5.672 | 46.088 | 3.069 | 23.777 |
| hex: silesia/sao | 524290 | 18754.6 ± 0.4% | 3619.2 ± 0.2% | 3297.6 ± 0.3% | 344.3 ± 1.2% | 6082.5 ± 1.4% | 787.6 ± 0.8% | 5.182 | 5.687 | 54.479 | 3.083 | 23.812 |
| hex: silesia/webster | 524290 | 18862.4 ± 0.5% | 3614.1 ± 0.7% | 3299.6 ± 0.4% | 470.1 ± 1.6% | 6092.9 ± 1.6% | 785.4 ± 0.3% | 5.219 | 5.717 | 40.125 | 3.096 | 24.016 |
| hex: silesia/x-ray | 524290 | 18820.1 ± 0.4% | 3623.2 ± 0.2% | 3306.1 ± 0.3% | 472.0 ± 1.1% | 6144.3 ± 1.6% | 786.4 ± 0.7% | 5.194 | 5.692 | 39.873 | 3.063 | 23.931 |
| hex: silesia/xml | 524290 | 19101.9 ± 1.3% | 3617.1 ± 0.1% | 3306.5 ± 0.3% | 520.4 ± 0.5% | 6136.2 ± 1.2% | 785.4 ± 0.2% | 5.281 | 5.777 | 36.705 | 3.113 | 24.321 |
| hex: canterbury/alice29.txt | 304180 | 19367.5 ± 0.4% | 3634.6 ± 0.2% | 3343.4 ± 0.2% | 510.5 ± 0.2% | 6077.3 ± 1.1% | 784.3 ± 0.4% | 5.329 | 5.793 | 37.937 | 3.187 | 24.692 |
| hex: canterbury/asyoulik.txt | 250360 | 19534.6 ± 0.2% | 3635.4 ± 0.1% | 3359.5 ± 0.1% | 503.7 ± 0.3% | 6158.6 ± 1.3% | 783.9 ± 0.6% | 5.373 | 5.815 | 38.779 | 3.172 | 24.921 |
| hex: canterbury/cp.html | 49208 | 19252.9 ± 0.1% | 3638.7 ± 0.0% | 3279.4 ± 0.4% | 473.4 ± 0.4% | 6282.5 ± 0.4% | 773.3 ± 2.2% | 5.291 | 5.871 | 40.669 | 3.065 | 24.897 |
| hex: canterbury/fields.c | 22302 | 18835.1 ± 0.8% | 3629.6 ± 0.2% | 3353.6 ± 0.1% | 498.6 ± 0.5% | 6250.7 ± 0.4% | 752.8 ± 2.5% | 5.189 | 5.616 | 37.777 | 3.013 | 25.022 |
| hex: canterbury/grammar.lsp | 7444 | 17579.1 ± 0.4% | 3602.1 ± 0.2% | 3366.3 ± 0.4% | 553.3 ± 1.9% | 6181.7 ± 0.5% | 729.0 ± 1.8% | 4.880 | 5.222 | 31.769 | 2.844 | 24.112 |
| hex: canterbury/kennedy.xls | 524290 | 18949.0 ± 0.8% | 3623.8 ± 0.2% | 3300.4 ± 0.3% | 663.8 ± 3.1% | 6077.4 ± 1.2% | 777.1 ± 5.3% | 5.229 | 5.741 | 28.547 | 3.118 | 24.385 |
| hex: canterbury/lcet10.txt | 524290 | 18768.7 ± 0.8% | 3616.4 ± 0.4% | 3312.5 ± 0.3% | 526.1 ± 1.6% | 6121.5 ± 0.3% | 784.5 ± 0.3% | 5.190 | 5.666 | 35.673 | 3.066 | 23.926 |
| hex: canterbury/plrabn12.txt | 524290 | 18762.5 ± 0.8% | 3618.2 ± 0.1% | 3296.5 ± 0.4% | 517.0 ± 0.3% | 6062.4 ± 1.2% | 787.6 ± 0.5% | 5.186 | 5.692 | 36.292 | 3.095 | 23.823 |
| hex: canterbury/ptt5 | 524290 | 18835.1 ± 0.3% | 3620.0 ± 0.3% | 3303.8 ± 0.3% | 561.3 ± 0.9% | 6116.8 ± 1.0% | 787.3 ± 0.7% | 5.203 | 5.701 | 33.558 | 3.079 | 23.923 |
| hex: canterbury/sum | 76482 | 19306.8 ± 0.1% | 3634.5 ± 0.0% | 3355.7 ± 0.6% | 522.8 ± 2.7% | 6170.9 ± 0.8% | 777.8 ± 1.1% | 5.312 | 5.753 | 36.933 | 3.129 | 24.824 |
| hex: canterbury/xargs.1 | 8456 | 17847.2 ± 0.1% | 3602.8 ± 0.0% | 3380.2 ± 0.3% | 504.3 ± 2.3% | 6155.0 ± 0.3% | 762.3 ± 1.5% | 4.954 | 5.280 | 35.388 | 2.900 | 23.413 |
| hex: canterbury-large/E.coli | 524290 | 19079.1 ± 0.9% | 3615.3 ± 0.4% | 3299.8 ± 0.4% | 689.4 ± 0.1% | 6088.0 ± 1.7% | 788.9 ± 1.2% | 5.277 | 5.782 | 27.676 | 3.134 | 24.186 |
| hex: canterbury-large/bible.txt | 524290 | 18936.7 ± 0.8% | 3614.6 ± 0.6% | 3296.2 ± 0.5% | 526.0 ± 2.8% | 6119.5 ± 0.7% | 788.9 ± 0.4% | 5.239 | 5.745 | 35.999 | 3.094 | 24.003 |
| hex: canterbury-large/world192.txt | 524290 | 18842.4 ± 0.6% | 3618.8 ± 0.3% | 3302.2 ± 0.2% | 506.2 ± 1.2% | 6112.8 ± 1.0% | 786.2 ± 0.3% | 5.207 | 5.706 | 37.221 | 3.082 | 23.968 |
| hex: http/html-1kx1024 | 2099200 | 9796.6 ± 11.6% | 3461.9 ± 0.1% | 2905.8 ± 0.4% | 474.6 ± 0.4% | 5157.7 ± 1.9% | 659.4 ± 1.7% | 2.830 | 3.371 | 20.643 | 1.899 | 14.856 |
| hex: http/html-16kx64 | 2097280 | 18616.1 ± 0.4% | 3609.2 ± 0.2% | 3273.4 ± 0.3% | 479.0 ± 1.1% | 6018.2 ± 0.5% | 758.9 ± 1.6% | 5.158 | 5.687 | 38.866 | 3.093 | 24.530 |
| hex: http/html-1m | 524290 | 18878.4 ± 1.4% | 3616.5 ± 0.2% | 3301.0 ± 0.2% | 494.3 ± 1.1% | 6123.1 ± 1.2% | 781.2 ± 3.0% | 5.220 | 5.719 | 38.193 | 3.083 | 24.167 |
| hex: http/json-1kx1024 | 2099200 | 9847.0 ± 18.3% | 3462.1 ± 0.2% | 2903.5 ± 0.3% | 575.1 ± 0.6% | 5149.0 ± 1.3% | 658.1 ± 2.0% | 2.844 | 3.391 | 17.122 | 1.912 | 14.964 |
| hex: http/json-16kx64 | 2097280 | 18611.1 ± 0.4% | 3612.0 ± 0.3% | 3267.6 ± 0.3% | 574.5 ± 0.6% | 6023.6 ± 0.8% | 754.5 ± 0.9% | 5.153 | 5.696 | 32.394 | 3.090 | 24.666 |
| hex: http/json-1m | 524290 | 18853.6 ± 1.6% | 3624.2 ± 0.4% | 3301.1 ± 0.3% | 592.4 ± 1.5% | 6123.5 ± 0.9% | 782.2 ± 3.2% | 5.202 | 5.711 | 31.823 | 3.079 | 24.103 |
| hex: http/js-1kx1024 | 2099200 | 9940.6 ± 11.3% | 3464.9 ± 0.1% | 2904.8 ± 0.6% | 481.0 ± 0.3% | 5129.5 ± 1.6% | 658.0 ± 2.3% | 2.869 | 3.422 | 20.666 | 1.938 | 15.108 |
| hex: http/js-16kx64 | 2097280 | 18525.2 ± 1.4% | 3613.9 ± 0.4% | 3275.4 ± 0.5% | 479.6 ± 0.8% | 6040.0 ± 0.6% | 751.9 ± 2.1% | 5.126 | 5.656 | 38.624 | 3.067 | 24.638 |
| hex: http/js-1m | 524290 | 19172.9 ± 1.6% | 3622.4 ± 0.2% | 3298.2 ± 0.3% | 500.8 ± 1.8% | 6001.9 ± 0.4% | 774.2 ± 4.8% | 5.293 | 5.813 | 38.283 | 3.194 | 24.765 |
| hex: http/css-1kx1024 | 2099200 | 9818.8 ± 16.7% | 3464.0 ± 0.1% | 2898.6 ± 0.4% | 489.2 ± 1.2% | 5134.9 ± 1.3% | 653.9 ± 2.1% | 2.835 | 3.387 | 20.071 | 1.912 | 15.016 |
| hex: http/css-16kx64 | 2097280 | 18610.7 ± 1.1% | 3610.7 ± 0.1% | 3276.3 ± 0.2% | 494.8 ± 0.9% | 6021.7 ± 0.2% | 756.9 ± 3.1% | 5.154 | 5.680 | 37.612 | 3.091 | 24.587 |
| hex: http/css-1m | 524290 | 18993.3 ± 1.2% | 3626.3 ± 0.3% | 3309.0 ± 0.3% | 495.5 ± 0.8% | 6129.2 ± 0.4% | 772.0 ± 4.0% | 5.238 | 5.740 | 38.331 | 3.099 | 24.604 |
| hex: shuffled/dickens-1m | 524290 | 18779.8 ± 1.2% | 3623.3 ± 0.3% | 3296.2 ± 0.4% | 525.0 ± 3.2% | 6134.0 ± 1.1% | 784.8 ± 1.0% | 5.183 | 5.697 | 35.774 | 3.062 | 23.929 |

## Encoding against the baselines

Octets are the ones stdx writes. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1491.7 ± 1.0% | 1260.0 ± 0.2% | 1047.8 ± 0.8% | 410.1 ± 0.2% | 449.6 ± 0.2% | 416.5 ± 0.7% | 1.184 | 1.424 | 3.638 | 3.318 | 3.582 |
| qlog records, JSON text sequence | 1467503 | 1273.7 ± 0.8% | 1066.9 ± 0.1% | 786.0 ± 0.8% | 377.9 ± 1.4% | 472.9 ± 0.6% | 278.8 ± 0.5% | 1.194 | 1.620 | 3.370 | 2.693 | 4.568 |
| string: silesia/dickens | 172528 | 6885.6 ± 0.4% | 2817.1 ± 0.5% | 2927.5 ± 0.5% | 430.8 ± 1.2% | 1597.8 ± 0.5% | 1006.6 ± 0.2% | 2.444 | 2.352 | 15.982 | 4.309 | 6.840 |
| string: silesia/nci | 1075110 | 7331.4 ± 0.3% | 3423.0 ± 1.2% | 3101.1 ± 0.4% | 812.9 ± 1.8% | 1864.1 ± 0.4% | 1111.4 ± 0.1% | 2.142 | 2.364 | 9.019 | 3.933 | 6.596 |
| string: silesia/reymont | 1075159 | 3332.1 ± 1.2% | 1993.4 ± 0.9% | 2064.2 ± 0.7% | 450.4 ± 0.9% | 1509.0 ± 1.4% | 953.9 ± 0.7% | 1.672 | 1.614 | 7.398 | 2.208 | 3.493 |
| string: silesia/samba | 97582 | 4180.5 ± 0.8% | 2113.0 ± 0.5% | 3454.1 ± 0.8% | 354.3 ± 0.7% | 1484.7 ± 0.4% | 1055.8 ± 0.4% | 1.978 | 1.210 | 11.800 | 2.816 | 3.960 |
| string: silesia/webster | 1098490 | 4058.2 ± 0.3% | 1880.4 ± 0.4% | 2055.2 ± 0.3% | 441.0 ± 0.4% | 1401.1 ± 0.2% | 645.7 ± 0.3% | 2.158 | 1.975 | 9.203 | 2.896 | 6.285 |
| string: silesia/xml | 1090118 | 6108.6 ± 0.3% | 2876.6 ± 0.8% | 2647.8 ± 0.6% | 607.7 ± 0.3% | 1760.0 ± 0.8% | 925.8 ± 0.5% | 2.124 | 2.307 | 10.052 | 3.471 | 6.598 |
| string: canterbury/alice29.txt | 159425 | 6405.9 ± 1.4% | 2191.6 ± 0.5% | 2754.2 ± 0.8% | 408.8 ± 1.2% | 1472.1 ± 0.4% | 957.2 ± 0.1% | 2.923 | 2.326 | 15.672 | 4.351 | 6.693 |
| string: canterbury/asyoulik.txt | 132198 | 5577.6 ± 0.6% | 1712.6 ± 0.5% | 2381.6 ± 0.8% | 402.1 ± 0.3% | 1334.3 ± 0.1% | 885.8 ± 0.2% | 3.257 | 2.342 | 13.872 | 4.180 | 6.297 |
| string: canterbury/lcet10.txt | 441884 | 6241.5 ± 0.5% | 2577.9 ± 0.3% | 2508.4 ± 2.5% | 467.6 ± 0.7% | 1554.6 ± 0.5% | 987.7 ± 0.3% | 2.421 | 2.488 | 13.348 | 4.015 | 6.319 |
| string: canterbury/plrabn12.txt | 503330 | 5719.5 ± 0.4% | 2065.0 ± 0.5% | 2071.1 ± 0.4% | 423.2 ± 0.1% | 1395.4 ± 0.2% | 935.3 ± 0.3% | 2.770 | 2.762 | 13.514 | 4.099 | 6.115 |
| string: canterbury-large/E.coli | 1048578 | 19372.4 ± 1.0% | 9903.5 ± 0.5% | 3783.6 ± 0.7% | 1475.3 ± 0.4% | 2373.6 ± 0.6% | 1195.5 ± 0.4% | 1.956 | 5.120 | 13.131 | 8.162 | 16.204 |
| string: canterbury-large/bible.txt | 1055886 | 6804.4 ± 0.7% | 4161.2 ± 1.0% | 3057.6 ± 1.9% | 506.6 ± 0.5% | 1990.9 ± 0.3% | 1124.0 ± 0.5% | 1.635 | 2.225 | 13.431 | 3.418 | 6.054 |
| string: canterbury-large/world192.txt | 1103121 | 4012.9 ± 0.7% | 1658.7 ± 0.6% | 1998.5 ± 0.4% | 449.5 ± 0.8% | 1371.4 ± 0.2% | 911.0 ± 0.4% | 2.419 | 2.008 | 8.927 | 2.926 | 4.405 |
| string: http/html-1m | 1058582 | 6763.3 ± 3.1% | 3976.3 ± 0.5% | 3038.4 ± 0.8% | 499.5 ± 0.8% | 1928.7 ± 0.3% | 807.0 ± 0.4% | 1.701 | 2.226 | 13.539 | 3.507 | 8.380 |
| string: http/json-1m | 1190272 | 3161.1 ± 0.2% | 1357.4 ± 0.3% | 1558.3 ± 0.4% | 444.0 ± 0.9% | 1073.0 ± 0.2% | 764.4 ± 1.6% | 2.329 | 2.029 | 7.120 | 2.946 | 4.135 |
| string: http/js-1m | 1144362 | 2769.3 ± 0.8% | 1181.4 ± 0.3% | 1626.1 ± 0.2% | 369.2 ± 0.1% | 1109.7 ± 0.5% | 760.1 ± 0.4% | 2.344 | 1.703 | 7.502 | 2.495 | 3.643 |
| string: http/css-1m | 1097820 | 3986.1 ± 0.8% | 1491.3 ± 0.6% | 2156.4 ± 0.9% | 493.3 ± 0.4% | 1382.6 ± 0.3% | 898.2 ± 0.7% | 2.673 | 1.848 | 8.080 | 2.883 | 4.438 |
| string: dickens as Cyrillic and CJK | 1883069 | 3072.7 ± 0.4% | 2335.8 ± 0.7% | 521.4 ± 0.2% | 307.4 ± 0.5% | 562.7 ± 1.1% | 336.9 ± 0.6% | 1.315 | 5.893 | 9.996 | 5.461 | 9.121 |
| hex: silesia/dickens | 524290 | 15647.8 ± 0.1% | 1469.1 ± 0.2% | 1084.2 ± 0.4% | 502.5 ± 0.3% | 991.4 ± 0.5% | 735.8 ± 0.4% | 10.651 | 14.432 | 31.141 | 15.784 | 21.267 |
| hex: silesia/mozilla | 524290 | 15656.5 ± 0.3% | 1478.5 ± 0.1% | 1091.2 ± 0.3% | 441.8 ± 0.6% | 991.7 ± 0.4% | 736.6 ± 0.7% | 10.589 | 14.348 | 35.436 | 15.787 | 21.255 |
| hex: silesia/mr | 524290 | 15659.9 ± 0.3% | 1487.6 ± 0.2% | 1093.3 ± 0.4% | 556.2 ± 3.3% | 996.7 ± 0.7% | 738.6 ± 0.3% | 10.527 | 14.324 | 28.154 | 15.712 | 21.201 |
| hex: silesia/nci | 524290 | 15661.9 ± 0.2% | 1477.2 ± 0.4% | 1090.6 ± 0.3% | 651.0 ± 2.2% | 991.9 ± 1.1% | 736.3 ± 0.6% | 10.603 | 14.361 | 24.059 | 15.790 | 21.270 |
| hex: silesia/ooffice | 524290 | 15622.6 ± 0.3% | 1471.6 ± 0.2% | 1086.6 ± 0.3% | 389.8 ± 0.3% | 991.5 ± 0.5% | 737.3 ± 0.4% | 10.616 | 14.377 | 40.082 | 15.757 | 21.188 |
| hex: silesia/osdb | 524290 | 15647.3 ± 0.1% | 1475.8 ± 0.3% | 1090.6 ± 0.6% | 467.4 ± 1.4% | 992.0 ± 0.7% | 736.9 ± 0.4% | 10.603 | 14.347 | 33.476 | 15.773 | 21.234 |
| hex: silesia/reymont | 524290 | 15581.1 ± 0.4% | 1471.0 ± 0.8% | 1086.5 ± 0.6% | 515.2 ± 1.7% | 988.7 ± 1.0% | 736.9 ± 0.5% | 10.592 | 14.341 | 30.245 | 15.759 | 21.143 |
| hex: silesia/samba | 524290 | 15652.1 ± 0.3% | 1470.1 ± 0.3% | 1087.9 ± 0.3% | 403.1 ± 0.2% | 990.6 ± 0.7% | 736.1 ± 0.5% | 10.647 | 14.388 | 38.827 | 15.801 | 21.264 |
| hex: silesia/sao | 524290 | 15652.9 ± 0.3% | 1471.5 ± 0.3% | 1084.6 ± 0.2% | 332.9 ± 0.4% | 992.1 ± 0.5% | 734.9 ± 0.8% | 10.637 | 14.432 | 47.015 | 15.778 | 21.300 |
| hex: silesia/webster | 524290 | 15699.9 ± 0.2% | 1470.8 ± 0.4% | 1087.6 ± 0.3% | 475.2 ± 0.8% | 990.1 ± 0.4% | 737.5 ± 0.2% | 10.675 | 14.435 | 33.036 | 15.857 | 21.288 |
| hex: silesia/x-ray | 524290 | 15643.3 ± 0.2% | 1484.3 ± 0.3% | 1092.0 ± 0.3% | 445.8 ± 1.2% | 996.6 ± 0.5% | 735.0 ± 0.6% | 10.540 | 14.325 | 35.087 | 15.697 | 21.284 |
| hex: silesia/xml | 524290 | 15658.5 ± 0.3% | 1475.6 ± 0.2% | 1089.5 ± 0.3% | 614.0 ± 1.0% | 990.5 ± 0.4% | 737.0 ± 0.5% | 10.611 | 14.372 | 25.503 | 15.809 | 21.245 |
| hex: canterbury/alice29.txt | 304180 | 15687.0 ± 0.2% | 1474.6 ± 0.8% | 1093.5 ± 0.2% | 503.7 ± 1.6% | 995.9 ± 0.7% | 737.3 ± 0.3% | 10.638 | 14.345 | 31.143 | 15.752 | 21.277 |
| hex: canterbury/asyoulik.txt | 250360 | 15692.8 ± 0.2% | 1474.1 ± 0.7% | 1092.2 ± 0.6% | 495.3 ± 1.1% | 996.1 ± 0.2% | 740.9 ± 0.3% | 10.645 | 14.368 | 31.681 | 15.755 | 21.180 |
| hex: canterbury/cp.html | 49208 | 15621.9 ± 0.2% | 1471.2 ± 0.4% | 1096.9 ± 0.2% | 527.5 ± 4.5% | 1000.8 ± 0.5% | 743.5 ± 0.2% | 10.619 | 14.242 | 29.615 | 15.610 | 21.013 |
| hex: canterbury/fields.c | 22302 | 15442.0 ± 0.1% | 1411.9 ± 0.5% | 1061.0 ± 0.7% | 626.1 ± 7.0% | 988.4 ± 0.0% | 736.9 ± 0.1% | 10.937 | 14.555 | 24.664 | 15.623 | 20.955 |
| hex: canterbury/grammar.lsp | 7444 | 14938.4 ± 0.1% | 1507.1 ± 0.2% | 1093.7 ± 0.6% | 671.7 ± 3.9% | 1002.6 ± 0.2% | 725.8 ± 0.2% | 9.912 | 13.659 | 22.241 | 14.899 | 20.582 |
| hex: canterbury/kennedy.xls | 524290 | 15558.2 ± 0.7% | 1476.0 ± 0.2% | 1088.1 ± 0.3% | 656.2 ± 1.9% | 994.5 ± 0.5% | 736.5 ± 0.7% | 10.541 | 14.299 | 23.711 | 15.644 | 21.125 |
| hex: canterbury/lcet10.txt | 524290 | 15639.9 ± 0.4% | 1468.3 ± 0.3% | 1085.7 ± 0.3% | 504.8 ± 1.0% | 989.9 ± 0.4% | 736.5 ± 0.5% | 10.651 | 14.405 | 30.982 | 15.800 | 21.234 |
| hex: canterbury/plrabn12.txt | 524290 | 15677.1 ± 0.2% | 1467.7 ± 0.4% | 1086.5 ± 0.5% | 496.3 ± 0.6% | 987.3 ± 0.4% | 736.1 ± 0.7% | 10.681 | 14.429 | 31.588 | 15.879 | 21.297 |
| hex: canterbury/ptt5 | 524290 | 15618.5 ± 0.4% | 1484.2 ± 0.4% | 1095.1 ± 0.3% | 557.5 ± 1.0% | 996.7 ± 0.4% | 735.7 ± 0.7% | 10.523 | 14.262 | 28.014 | 15.670 | 21.230 |
| hex: canterbury/sum | 76482 | 15640.4 ± 0.1% | 1494.4 ± 0.1% | 1103.7 ± 0.4% | 601.6 ± 0.8% | 997.8 ± 0.1% | 743.5 ± 0.3% | 10.466 | 14.170 | 26.000 | 15.674 | 21.037 |
| hex: canterbury/xargs.1 | 8456 | 14971.0 ± 0.1% | 1480.6 ± 0.2% | 1098.0 ± 0.4% | 671.6 ± 4.6% | 1001.0 ± 0.3% | 726.9 ± 0.2% | 10.112 | 13.635 | 22.290 | 14.957 | 20.596 |
| hex: canterbury-large/E.coli | 524290 | 15670.0 ± 0.5% | 1481.1 ± 0.4% | 1090.0 ± 0.8% | 672.8 ± 0.1% | 994.1 ± 0.6% | 736.3 ± 0.4% | 10.580 | 14.376 | 23.291 | 15.762 | 21.281 |
| hex: canterbury-large/bible.txt | 524290 | 15612.3 ± 0.3% | 1468.3 ± 0.4% | 1085.8 ± 1.3% | 512.3 ± 0.6% | 987.5 ± 0.4% | 736.6 ± 0.6% | 10.633 | 14.379 | 30.476 | 15.811 | 21.196 |
| hex: canterbury-large/world192.txt | 524290 | 15631.4 ± 0.2% | 1469.8 ± 0.3% | 1087.2 ± 0.4% | 503.3 ± 0.5% | 991.1 ± 0.4% | 736.8 ± 0.3% | 10.635 | 14.378 | 31.058 | 15.771 | 21.215 |
| hex: http/html-1kx1024 | 2099200 | 13744.2 ± 0.5% | 1460.3 ± 0.6% | 1061.3 ± 0.3% | 502.1 ± 0.1% | 984.7 ± 0.5% | 693.1 ± 0.1% | 9.412 | 12.951 | 27.373 | 13.957 | 19.830 |
| hex: http/html-16kx64 | 2097280 | 15300.0 ± 0.6% | 1454.8 ± 2.9% | 1075.8 ± 0.4% | 508.0 ± 0.5% | 998.3 ± 0.3% | 735.6 ± 0.2% | 10.517 | 14.222 | 30.119 | 15.326 | 20.799 |
| hex: http/html-1m | 524290 | 15646.7 ± 0.1% | 1469.5 ± 0.3% | 1085.8 ± 0.3% | 500.5 ± 1.1% | 989.7 ± 0.4% | 736.4 ± 0.6% | 10.648 | 14.410 | 31.263 | 15.809 | 21.248 |
| hex: http/json-1kx1024 | 2099200 | 13732.4 ± 0.5% | 1463.5 ± 0.2% | 1067.3 ± 0.2% | 608.8 ± 0.6% | 988.6 ± 0.2% | 693.0 ± 0.2% | 9.384 | 12.866 | 22.558 | 13.891 | 19.816 |
| hex: http/json-16kx64 | 2097280 | 15263.5 ± 0.4% | 1450.6 ± 0.2% | 1074.4 ± 0.2% | 616.2 ± 0.6% | 996.2 ± 0.2% | 734.8 ± 0.2% | 10.522 | 14.207 | 24.772 | 15.322 | 20.771 |
| hex: http/json-1m | 524290 | 15632.8 ± 0.3% | 1480.7 ± 0.3% | 1091.7 ± 0.2% | 635.2 ± 0.5% | 993.5 ± 0.8% | 734.3 ± 0.5% | 10.557 | 14.320 | 24.611 | 15.736 | 21.290 |
| hex: http/js-1kx1024 | 2099200 | 13746.5 ± 0.8% | 1454.3 ± 0.0% | 1065.5 ± 0.4% | 500.0 ± 0.4% | 983.6 ± 0.2% | 693.2 ± 0.3% | 9.452 | 12.901 | 27.494 | 13.975 | 19.830 |
| hex: http/js-16kx64 | 2097280 | 15320.6 ± 0.5% | 1444.0 ± 0.2% | 1075.0 ± 0.3% | 505.8 ± 0.2% | 997.0 ± 0.3% | 735.9 ± 0.2% | 10.610 | 14.252 | 30.291 | 15.367 | 20.819 |
| hex: http/js-1m | 524290 | 15671.7 ± 0.3% | 1468.5 ± 0.2% | 1088.8 ± 0.9% | 511.2 ± 0.5% | 991.9 ± 0.7% | 735.9 ± 0.6% | 10.672 | 14.394 | 30.658 | 15.800 | 21.295 |
| hex: http/css-1kx1024 | 2099200 | 13731.7 ± 0.4% | 1456.7 ± 0.2% | 1062.7 ± 0.3% | 531.4 ± 0.4% | 983.6 ± 0.1% | 693.2 ± 0.1% | 9.426 | 12.922 | 25.842 | 13.961 | 19.810 |
| hex: http/css-16kx64 | 2097280 | 15218.3 ± 0.5% | 1444.3 ± 0.3% | 1075.3 ± 0.2% | 542.5 ± 1.0% | 997.9 ± 0.5% | 734.6 ± 0.1% | 10.537 | 14.153 | 28.052 | 15.251 | 20.718 |
| hex: http/css-1m | 524290 | 15694.3 ± 0.2% | 1468.3 ± 0.3% | 1086.9 ± 0.5% | 527.5 ± 0.2% | 984.8 ± 0.5% | 735.6 ± 0.4% | 10.688 | 14.439 | 29.750 | 15.937 | 21.335 |
| hex: shuffled/dickens-1m | 524290 | 15676.0 ± 0.3% | 1469.1 ± 0.2% | 1084.8 ± 0.4% | 500.7 ± 0.2% | 990.0 ± 0.9% | 736.6 ± 0.8% | 10.670 | 14.451 | 31.307 | 15.835 | 21.281 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1532.0 ± 0.5% | 1260.0 ± 0.2% | 1047.8 ± 0.8% | 410.1 ± 0.2% | 449.6 ± 0.2% | 416.5 ± 0.7% | 1.216 | 1.462 | 3.736 | 3.408 | 3.679 |
| qlog records, JSON text sequence | 1467503 | 1294.1 ± 0.3% | 1066.9 ± 0.1% | 786.0 ± 0.8% | 377.9 ± 1.4% | 472.9 ± 0.6% | 278.8 ± 0.5% | 1.213 | 1.647 | 3.424 | 2.737 | 4.641 |
| string: silesia/dickens | 172528 | 7126.3 ± 0.2% | 2817.1 ± 0.5% | 2927.5 ± 0.5% | 430.8 ± 1.2% | 1597.8 ± 0.5% | 1006.6 ± 0.2% | 2.530 | 2.434 | 16.540 | 4.460 | 7.079 |
| string: silesia/nci | 1075110 | 7392.3 ± 6.3% | 3423.0 ± 1.2% | 3101.1 ± 0.4% | 812.9 ± 1.8% | 1864.1 ± 0.4% | 1111.4 ± 0.1% | 2.160 | 2.384 | 9.094 | 3.966 | 6.651 |
| string: silesia/reymont | 1075159 | 3510.0 ± 0.9% | 1993.4 ± 0.9% | 2064.2 ± 0.7% | 450.4 ± 0.9% | 1509.0 ± 1.4% | 953.9 ± 0.7% | 1.761 | 1.700 | 7.793 | 2.326 | 3.679 |
| string: silesia/samba | 97582 | 4554.9 ± 0.8% | 2113.0 ± 0.5% | 3454.1 ± 0.8% | 354.3 ± 0.7% | 1484.7 ± 0.4% | 1055.8 ± 0.4% | 2.156 | 1.319 | 12.857 | 3.068 | 4.314 |
| string: silesia/webster | 1098490 | 4098.0 ± 0.2% | 1880.4 ± 0.4% | 2055.2 ± 0.3% | 441.0 ± 0.4% | 1401.1 ± 0.2% | 645.7 ± 0.3% | 2.179 | 1.994 | 9.293 | 2.925 | 6.347 |
| string: silesia/xml | 1090118 | 6238.9 ± 1.0% | 2876.6 ± 0.8% | 2647.8 ± 0.6% | 607.7 ± 0.3% | 1760.0 ± 0.8% | 925.8 ± 0.5% | 2.169 | 2.356 | 10.267 | 3.545 | 6.739 |
| string: canterbury/alice29.txt | 159425 | 6819.3 ± 4.4% | 2191.6 ± 0.5% | 2754.2 ± 0.8% | 408.8 ± 1.2% | 1472.1 ± 0.4% | 957.2 ± 0.1% | 3.112 | 2.476 | 16.683 | 4.632 | 7.124 |
| string: canterbury/asyoulik.txt | 132198 | 5920.3 ± 1.8% | 1712.6 ± 0.5% | 2381.6 ± 0.8% | 402.1 ± 0.3% | 1334.3 ± 0.1% | 885.8 ± 0.2% | 3.457 | 2.486 | 14.724 | 4.437 | 6.684 |
| string: canterbury/lcet10.txt | 441884 | 6257.3 ± 0.3% | 2577.9 ± 0.3% | 2508.4 ± 2.5% | 467.6 ± 0.7% | 1554.6 ± 0.5% | 987.7 ± 0.3% | 2.427 | 2.495 | 13.382 | 4.025 | 6.335 |
| string: canterbury/plrabn12.txt | 503330 | 5771.0 ± 0.4% | 2065.0 ± 0.5% | 2071.1 ± 0.4% | 423.2 ± 0.1% | 1395.4 ± 0.2% | 935.3 ± 0.3% | 2.795 | 2.787 | 13.636 | 4.136 | 6.170 |
| string: canterbury-large/E.coli | 1048578 | 19372.9 ± 0.3% | 9903.5 ± 0.5% | 3783.6 ± 0.7% | 1475.3 ± 0.4% | 2373.6 ± 0.6% | 1195.5 ± 0.4% | 1.956 | 5.120 | 13.131 | 8.162 | 16.204 |
| string: canterbury-large/bible.txt | 1055886 | 6799.2 ± 0.1% | 4161.2 ± 1.0% | 3057.6 ± 1.9% | 506.6 ± 0.5% | 1990.9 ± 0.3% | 1124.0 ± 0.5% | 1.634 | 2.224 | 13.421 | 3.415 | 6.049 |
| string: canterbury-large/world192.txt | 1103121 | 4022.9 ± 0.8% | 1658.7 ± 0.6% | 1998.5 ± 0.4% | 449.5 ± 0.8% | 1371.4 ± 0.2% | 911.0 ± 0.4% | 2.425 | 2.013 | 8.949 | 2.934 | 4.416 |
| string: http/html-1m | 1058582 | 6839.8 ± 0.5% | 3976.3 ± 0.5% | 3038.4 ± 0.8% | 499.5 ± 0.8% | 1928.7 ± 0.3% | 807.0 ± 0.4% | 1.720 | 2.251 | 13.692 | 3.546 | 8.475 |
| string: http/json-1m | 1190272 | 3305.6 ± 0.5% | 1357.4 ± 0.3% | 1558.3 ± 0.4% | 444.0 ± 0.9% | 1073.0 ± 0.2% | 764.4 ± 1.6% | 2.435 | 2.121 | 7.445 | 3.081 | 4.324 |
| string: http/js-1m | 1144362 | 2795.2 ± 0.9% | 1181.4 ± 0.3% | 1626.1 ± 0.2% | 369.2 ± 0.1% | 1109.7 ± 0.5% | 760.1 ± 0.4% | 2.366 | 1.719 | 7.572 | 2.519 | 3.677 |
| string: http/css-1m | 1097820 | 4040.7 ± 0.6% | 1491.3 ± 0.6% | 2156.4 ± 0.9% | 493.3 ± 0.4% | 1382.6 ± 0.3% | 898.2 ± 0.7% | 2.709 | 1.874 | 8.191 | 2.922 | 4.499 |
| string: dickens as Cyrillic and CJK | 1883069 | 3076.8 ± 0.5% | 2335.8 ± 0.7% | 521.4 ± 0.2% | 307.4 ± 0.5% | 562.7 ± 1.1% | 336.9 ± 0.6% | 1.317 | 5.901 | 10.009 | 5.468 | 9.134 |
| hex: silesia/dickens | 524290 | 15616.6 ± 0.3% | 1469.1 ± 0.2% | 1084.2 ± 0.4% | 502.5 ± 0.3% | 991.4 ± 0.5% | 735.8 ± 0.4% | 10.630 | 14.403 | 31.079 | 15.753 | 21.224 |
| hex: silesia/mozilla | 524290 | 15661.5 ± 0.3% | 1478.5 ± 0.1% | 1091.2 ± 0.3% | 441.8 ± 0.6% | 991.7 ± 0.4% | 736.6 ± 0.7% | 10.593 | 14.352 | 35.447 | 15.792 | 21.262 |
| hex: silesia/mr | 524290 | 15608.4 ± 0.4% | 1487.6 ± 0.2% | 1093.3 ± 0.4% | 556.2 ± 3.3% | 996.7 ± 0.7% | 738.6 ± 0.3% | 10.492 | 14.277 | 28.061 | 15.661 | 21.131 |
| hex: silesia/nci | 524290 | 15685.4 ± 0.3% | 1477.2 ± 0.4% | 1090.6 ± 0.3% | 651.0 ± 2.2% | 991.9 ± 1.1% | 736.3 ± 0.6% | 10.619 | 14.382 | 24.095 | 15.814 | 21.302 |
| hex: silesia/ooffice | 524290 | 15627.3 ± 0.3% | 1471.6 ± 0.2% | 1086.6 ± 0.3% | 389.8 ± 0.3% | 991.5 ± 0.5% | 737.3 ± 0.4% | 10.619 | 14.382 | 40.094 | 15.762 | 21.194 |
| hex: silesia/osdb | 524290 | 15670.3 ± 0.3% | 1475.8 ± 0.3% | 1090.6 ± 0.6% | 467.4 ± 1.4% | 992.0 ± 0.7% | 736.9 ± 0.4% | 10.618 | 14.368 | 33.525 | 15.796 | 21.265 |
| hex: silesia/reymont | 524290 | 15570.3 ± 0.3% | 1471.0 ± 0.8% | 1086.5 ± 0.6% | 515.2 ± 1.7% | 988.7 ± 1.0% | 736.9 ± 0.5% | 10.585 | 14.331 | 30.224 | 15.748 | 21.128 |
| hex: silesia/samba | 524290 | 15619.3 ± 0.5% | 1470.1 ± 0.3% | 1087.9 ± 0.3% | 403.1 ± 0.2% | 990.6 ± 0.7% | 736.1 ± 0.5% | 10.625 | 14.358 | 38.745 | 15.768 | 21.219 |
| hex: silesia/sao | 524290 | 15674.9 ± 0.3% | 1471.5 ± 0.3% | 1084.6 ± 0.2% | 332.9 ± 0.4% | 992.1 ± 0.5% | 734.9 ± 0.8% | 10.652 | 14.452 | 47.081 | 15.800 | 21.330 |
| hex: silesia/webster | 524290 | 15727.1 ± 0.2% | 1470.8 ± 0.4% | 1087.6 ± 0.3% | 475.2 ± 0.8% | 990.1 ± 0.4% | 737.5 ± 0.2% | 10.693 | 14.460 | 33.093 | 15.884 | 21.325 |
| hex: silesia/x-ray | 524290 | 15634.9 ± 0.3% | 1484.3 ± 0.3% | 1092.0 ± 0.3% | 445.8 ± 1.2% | 996.6 ± 0.5% | 735.0 ± 0.6% | 10.534 | 14.318 | 35.068 | 15.688 | 21.273 |
| hex: silesia/xml | 524290 | 15651.1 ± 0.2% | 1475.6 ± 0.2% | 1089.5 ± 0.3% | 614.0 ± 1.0% | 990.5 ± 0.4% | 737.0 ± 0.5% | 10.606 | 14.365 | 25.491 | 15.801 | 21.235 |
| hex: canterbury/alice29.txt | 304180 | 15696.0 ± 0.0% | 1474.6 ± 0.8% | 1093.5 ± 0.2% | 503.7 ± 1.6% | 995.9 ± 0.7% | 737.3 ± 0.3% | 10.644 | 14.353 | 31.161 | 15.761 | 21.289 |
| hex: canterbury/asyoulik.txt | 250360 | 15707.4 ± 0.1% | 1474.1 ± 0.7% | 1092.2 ± 0.6% | 495.3 ± 1.1% | 996.1 ± 0.2% | 740.9 ± 0.3% | 10.655 | 14.382 | 31.710 | 15.769 | 21.200 |
| hex: canterbury/cp.html | 49208 | 15633.3 ± 0.0% | 1471.2 ± 0.4% | 1096.9 ± 0.2% | 527.5 ± 4.5% | 1000.8 ± 0.5% | 743.5 ± 0.2% | 10.626 | 14.253 | 29.637 | 15.621 | 21.028 |
| hex: canterbury/fields.c | 22302 | 15461.6 ± 0.0% | 1411.9 ± 0.5% | 1061.0 ± 0.7% | 626.1 ± 7.0% | 988.4 ± 0.0% | 736.9 ± 0.1% | 10.951 | 14.573 | 24.695 | 15.643 | 20.982 |
| hex: canterbury/grammar.lsp | 7444 | 14980.6 ± 0.1% | 1507.1 ± 0.2% | 1093.7 ± 0.6% | 671.7 ± 3.9% | 1002.6 ± 0.2% | 725.8 ± 0.2% | 9.940 | 13.697 | 22.304 | 14.941 | 20.640 |
| hex: canterbury/kennedy.xls | 524290 | 15576.9 ± 0.4% | 1476.0 ± 0.2% | 1088.1 ± 0.3% | 656.2 ± 1.9% | 994.5 ± 0.5% | 736.5 ± 0.7% | 10.554 | 14.316 | 23.740 | 15.662 | 21.151 |
| hex: canterbury/lcet10.txt | 524290 | 15663.5 ± 0.1% | 1468.3 ± 0.3% | 1085.7 ± 0.3% | 504.8 ± 1.0% | 989.9 ± 0.4% | 736.5 ± 0.5% | 10.668 | 14.427 | 31.029 | 15.824 | 21.266 |
| hex: canterbury/plrabn12.txt | 524290 | 15619.7 ± 0.5% | 1467.7 ± 0.4% | 1086.5 ± 0.5% | 496.3 ± 0.6% | 987.3 ± 0.4% | 736.1 ± 0.7% | 10.642 | 14.376 | 31.472 | 15.821 | 21.219 |
| hex: canterbury/ptt5 | 524290 | 15678.3 ± 0.2% | 1484.2 ± 0.4% | 1095.1 ± 0.3% | 557.5 ± 1.0% | 996.7 ± 0.4% | 735.7 ± 0.7% | 10.564 | 14.317 | 28.121 | 15.730 | 21.312 |
| hex: canterbury/sum | 76482 | 15657.2 ± 0.0% | 1494.4 ± 0.1% | 1103.7 ± 0.4% | 601.6 ± 0.8% | 997.8 ± 0.1% | 743.5 ± 0.3% | 10.477 | 14.186 | 26.028 | 15.691 | 21.059 |
| hex: canterbury/xargs.1 | 8456 | 15015.4 ± 0.1% | 1480.6 ± 0.2% | 1098.0 ± 0.4% | 671.6 ± 4.6% | 1001.0 ± 0.3% | 726.9 ± 0.2% | 10.142 | 13.675 | 22.356 | 15.001 | 20.657 |
| hex: canterbury-large/E.coli | 524290 | 15687.7 ± 0.2% | 1481.1 ± 0.4% | 1090.0 ± 0.8% | 672.8 ± 0.1% | 994.1 ± 0.6% | 736.3 ± 0.4% | 10.592 | 14.392 | 23.318 | 15.780 | 21.305 |
| hex: canterbury-large/bible.txt | 524290 | 15666.0 ± 0.2% | 1468.3 ± 0.4% | 1085.8 ± 1.3% | 512.3 ± 0.6% | 987.5 ± 0.4% | 736.6 ± 0.6% | 10.669 | 14.428 | 30.581 | 15.865 | 21.269 |
| hex: canterbury-large/world192.txt | 524290 | 15646.0 ± 0.2% | 1469.8 ± 0.3% | 1087.2 ± 0.4% | 503.3 ± 0.5% | 991.1 ± 0.4% | 736.8 ± 0.3% | 10.645 | 14.391 | 31.087 | 15.786 | 21.235 |
| hex: http/html-1kx1024 | 2099200 | 13920.3 ± 0.4% | 1460.3 ± 0.6% | 1061.3 ± 0.3% | 502.1 ± 0.1% | 984.7 ± 0.5% | 693.1 ± 0.1% | 9.533 | 13.117 | 27.724 | 14.136 | 20.084 |
| hex: http/html-16kx64 | 2097280 | 15317.1 ± 0.4% | 1454.8 ± 2.9% | 1075.8 ± 0.4% | 508.0 ± 0.5% | 998.3 ± 0.3% | 735.6 ± 0.2% | 10.529 | 14.238 | 30.153 | 15.343 | 20.822 |
| hex: http/html-1m | 524290 | 15672.5 ± 0.2% | 1469.5 ± 0.3% | 1085.8 ± 0.3% | 500.5 ± 1.1% | 989.7 ± 0.4% | 736.4 ± 0.6% | 10.665 | 14.434 | 31.315 | 15.835 | 21.283 |
| hex: http/json-1kx1024 | 2099200 | 13912.2 ± 0.2% | 1463.5 ± 0.2% | 1067.3 ± 0.2% | 608.8 ± 0.6% | 988.6 ± 0.2% | 693.0 ± 0.2% | 9.506 | 13.035 | 22.854 | 14.073 | 20.075 |
| hex: http/json-16kx64 | 2097280 | 15349.5 ± 0.5% | 1450.6 ± 0.2% | 1074.4 ± 0.2% | 616.2 ± 0.6% | 996.2 ± 0.2% | 734.8 ± 0.2% | 10.582 | 14.287 | 24.912 | 15.408 | 20.888 |
| hex: http/json-1m | 524290 | 15603.0 ± 0.3% | 1480.7 ± 0.3% | 1091.7 ± 0.2% | 635.2 ± 0.5% | 993.5 ± 0.8% | 734.3 ± 0.5% | 10.537 | 14.293 | 24.564 | 15.706 | 21.249 |
| hex: http/js-1kx1024 | 2099200 | 13898.6 ± 0.4% | 1454.3 ± 0.0% | 1065.5 ± 0.4% | 500.0 ± 0.4% | 983.6 ± 0.2% | 693.2 ± 0.3% | 9.557 | 13.044 | 27.798 | 14.130 | 20.050 |
| hex: http/js-16kx64 | 2097280 | 15284.6 ± 0.5% | 1444.0 ± 0.2% | 1075.0 ± 0.3% | 505.8 ± 0.2% | 997.0 ± 0.3% | 735.9 ± 0.2% | 10.585 | 14.218 | 30.220 | 15.331 | 20.770 |
| hex: http/js-1m | 524290 | 15665.1 ± 0.6% | 1468.5 ± 0.2% | 1088.8 ± 0.9% | 511.2 ± 0.5% | 991.9 ± 0.7% | 735.9 ± 0.6% | 10.668 | 14.387 | 30.645 | 15.793 | 21.286 |
| hex: http/css-1kx1024 | 2099200 | 13817.4 ± 0.5% | 1456.7 ± 0.2% | 1062.7 ± 0.3% | 531.4 ± 0.4% | 983.6 ± 0.1% | 693.2 ± 0.1% | 9.485 | 13.002 | 26.003 | 14.048 | 19.934 |
| hex: http/css-16kx64 | 2097280 | 15347.4 ± 0.7% | 1444.3 ± 0.3% | 1075.3 ± 0.2% | 542.5 ± 1.0% | 997.9 ± 0.5% | 734.6 ± 0.1% | 10.626 | 14.273 | 28.290 | 15.380 | 20.893 |
| hex: http/css-1m | 524290 | 15705.9 ± 0.1% | 1468.3 ± 0.3% | 1086.9 ± 0.5% | 527.5 ± 0.2% | 984.8 ± 0.5% | 735.6 ± 0.4% | 10.696 | 14.450 | 29.772 | 15.949 | 21.350 |
| hex: shuffled/dickens-1m | 524290 | 15703.8 ± 0.2% | 1469.1 ± 0.2% | 1084.8 ± 0.4% | 500.7 ± 0.2% | 990.0 ± 0.9% | 736.6 ± 0.8% | 10.689 | 14.476 | 31.363 | 15.863 | 21.319 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 937.7 ± 0.6% | 922.7 ± 0.7% | 1018.8 ± 2.1% | 301.1 ± 1.0% | 666.1 ± 0.3% | 311.1 ± 4.1% | 1.016 | 0.920 | 3.114 | 1.408 | 3.015 |
| qlog records, JSON text sequence | 1467503 | 787.8 ± 0.6% | 814.9 ± 0.2% | 813.6 ± 1.6% | 244.5 ± 0.6% | 704.8 ± 0.2% | 252.9 ± 0.6% | 0.967 | 0.968 | 3.222 | 1.118 | 3.115 |
| string: silesia/dickens | 172528 | 5060.8 ± 0.3% | 1879.5 ± 0.2% | 2649.6 ± 0.3% | 361.4 ± 0.9% | 2864.5 ± 0.3% | 556.1 ± 1.8% | 2.693 | 1.910 | 14.002 | 1.767 | 9.100 |
| string: silesia/nci | 1075110 | 4318.0 ± 0.4% | 2240.4 ± 0.3% | 3005.0 ± 0.2% | 543.2 ± 1.5% | 3010.8 ± 1.3% | 603.0 ± 1.3% | 1.927 | 1.437 | 7.949 | 1.434 | 7.161 |
| string: silesia/reymont | 1075159 | 2997.4 ± 2.2% | 1812.6 ± 1.1% | 2063.5 ± 0.2% | 375.2 ± 1.5% | 2147.0 ± 0.4% | 538.8 ± 0.7% | 1.654 | 1.453 | 7.989 | 1.396 | 5.563 |
| string: silesia/samba | 97582 | 3500.2 ± 0.5% | 2027.4 ± 0.2% | 2619.5 ± 0.2% | 324.3 ± 0.4% | 1509.3 ± 0.7% | 432.2 ± 1.1% | 1.726 | 1.336 | 10.794 | 2.319 | 8.098 |
| string: silesia/webster | 1098490 | 3676.4 ± 0.7% | 1519.4 ± 0.4% | 2015.4 ± 0.5% | 359.3 ± 0.3% | 2184.3 ± 1.6% | 502.2 ± 1.7% | 2.420 | 1.824 | 10.233 | 1.683 | 7.320 |
| string: silesia/xml | 1090118 | 4812.7 ± 0.8% | 2362.8 ± 0.4% | 2536.8 ± 0.6% | 454.0 ± 1.4% | 2837.8 ± 0.6% | 569.4 ± 1.0% | 2.037 | 1.897 | 10.600 | 1.696 | 8.452 |
| string: canterbury/alice29.txt | 159425 | 4382.6 ± 1.2% | 1601.3 ± 0.2% | 2457.5 ± 0.6% | 342.4 ± 1.7% | 2507.6 ± 0.5% | 509.0 ± 0.9% | 2.737 | 1.783 | 12.801 | 1.748 | 8.610 |
| string: canterbury/asyoulik.txt | 132198 | 3487.0 ± 0.9% | 1459.2 ± 0.3% | 2247.5 ± 0.5% | 335.0 ± 0.5% | 2082.9 ± 0.3% | 465.3 ± 1.5% | 2.390 | 1.552 | 10.408 | 1.674 | 7.494 |
| string: canterbury/lcet10.txt | 441884 | 5145.4 ± 0.3% | 1852.9 ± 0.4% | 2336.2 ± 1.0% | 389.7 ± 0.8% | 2844.3 ± 0.9% | 537.1 ± 1.9% | 2.777 | 2.202 | 13.203 | 1.809 | 9.580 |
| string: canterbury/plrabn12.txt | 503330 | 4159.4 ± 0.6% | 1736.9 ± 0.2% | 2062.5 ± 0.3% | 362.1 ± 1.4% | 2527.8 ± 0.3% | 503.9 ± 1.1% | 2.395 | 2.017 | 11.488 | 1.645 | 8.255 |
| string: canterbury-large/E.coli | 1048578 | 11938.6 ± 0.4% | 3611.3 ± 0.3% | 3265.4 ± 0.6% | 928.9 ± 1.1% | 6091.0 ± 0.4% | 773.6 ± 0.3% | 3.306 | 3.656 | 12.852 | 1.960 | 15.432 |
| string: canterbury-large/bible.txt | 1055886 | 6937.3 ± 1.1% | 2940.1 ± 0.5% | 2840.6 ± 0.6% | 419.6 ± 1.9% | 3784.3 ± 1.5% | 621.5 ± 0.8% | 2.360 | 2.442 | 16.533 | 1.833 | 11.163 |
| string: canterbury-large/world192.txt | 1103121 | 3399.8 ± 0.3% | 1484.1 ± 0.4% | 2012.7 ± 0.3% | 352.1 ± 0.4% | 2121.3 ± 0.9% | 503.7 ± 1.2% | 2.291 | 1.689 | 9.655 | 1.603 | 6.749 |
| string: http/html-1m | 1058582 | 6233.9 ± 1.9% | 2738.0 ± 0.6% | 2706.7 ± 0.3% | 443.3 ± 0.8% | 3487.8 ± 0.9% | 600.4 ± 0.8% | 2.277 | 2.303 | 14.064 | 1.787 | 10.384 |
| string: http/json-1m | 1190272 | 2559.6 ± 0.3% | 877.7 ± 0.2% | 2256.8 ± 0.4% | 389.7 ± 0.3% | 1043.2 ± 2.6% | 444.0 ± 0.7% | 2.916 | 1.134 | 6.567 | 2.454 | 5.765 |
| string: http/js-1m | 1144362 | 2287.1 ± 0.6% | 1028.5 ± 0.4% | 1639.7 ± 0.3% | 320.8 ± 0.9% | 1522.3 ± 0.6% | 420.7 ± 0.5% | 2.224 | 1.395 | 7.129 | 1.502 | 5.436 |
| string: http/css-1m | 1097820 | 2657.5 ± 0.7% | 1678.5 ± 0.2% | 2231.3 ± 0.7% | 406.1 ± 0.8% | 1930.3 ± 1.4% | 491.2 ± 0.7% | 1.583 | 1.191 | 6.544 | 1.377 | 5.410 |
| string: dickens as Cyrillic and CJK | 1883069 | 3082.1 ± 0.7% | 1689.4 ± 0.4% | 895.8 ± 0.5% | 351.3 ± 0.1% | 666.7 ± 0.7% | 158.6 ± 2.1% | 1.824 | 3.440 | 8.774 | 4.623 | 19.431 |
| string: dickens as Cyrillic and CJK, as \u escapes | 5075485 | 1331.3 ± 0.4% | 981.0 ± 0.4% | 1213.1 ± 0.7% | 214.2 ± 0.1% | 471.3 ± 0.7% | 251.8 ± 3.3% | 1.357 | 1.097 | 6.216 | 2.825 | 5.288 |
| hex: silesia/dickens | 524290 | 11983.0 ± 0.1% | 3621.8 ± 0.1% | 3293.2 ± 0.2% | 505.6 ± 3.5% | 6081.2 ± 0.9% | 784.9 ± 2.1% | 3.309 | 3.639 | 23.700 | 1.970 | 15.268 |
| hex: silesia/mozilla | 524290 | 12005.2 ± 0.1% | 3617.2 ± 0.3% | 3300.1 ± 0.5% | 453.6 ± 1.9% | 6092.3 ± 1.1% | 787.2 ± 0.5% | 3.319 | 3.638 | 26.469 | 1.971 | 15.250 |
| hex: silesia/mr | 524290 | 12018.5 ± 0.1% | 3619.6 ± 0.2% | 3295.0 ± 0.1% | 563.1 ± 0.9% | 6099.1 ± 0.6% | 786.1 ± 0.3% | 3.320 | 3.647 | 21.342 | 1.971 | 15.289 |
| hex: silesia/nci | 524290 | 12000.1 ± 0.1% | 3617.3 ± 0.2% | 3292.1 ± 0.1% | 625.5 ± 0.7% | 6144.8 ± 0.8% | 786.0 ± 0.5% | 3.317 | 3.645 | 19.185 | 1.953 | 15.267 |
| hex: silesia/ooffice | 524290 | 12014.4 ± 0.0% | 3614.4 ± 0.3% | 3304.9 ± 0.2% | 395.5 ± 1.0% | 6109.8 ± 1.5% | 786.3 ± 0.5% | 3.324 | 3.635 | 30.377 | 1.966 | 15.280 |
| hex: silesia/osdb | 524290 | 11954.2 ± 0.2% | 3615.6 ± 0.4% | 3310.5 ± 0.1% | 480.9 ± 0.2% | 6042.8 ± 3.3% | 786.5 ± 0.3% | 3.306 | 3.611 | 24.857 | 1.978 | 15.199 |
| hex: silesia/reymont | 524290 | 12014.2 ± 0.1% | 3618.8 ± 0.2% | 3312.1 ± 0.2% | 512.3 ± 3.3% | 6098.0 ± 1.7% | 787.0 ± 0.6% | 3.320 | 3.627 | 23.451 | 1.970 | 15.266 |
| hex: silesia/samba | 524290 | 11969.9 ± 0.1% | 3618.3 ± 0.2% | 3298.2 ± 0.3% | 405.9 ± 1.3% | 6095.5 ± 0.6% | 786.7 ± 0.4% | 3.308 | 3.629 | 29.491 | 1.964 | 15.214 |
| hex: silesia/sao | 524290 | 11959.1 ± 0.3% | 3619.2 ± 0.2% | 3297.6 ± 0.3% | 344.3 ± 1.2% | 6082.5 ± 1.4% | 787.6 ± 0.8% | 3.304 | 3.627 | 34.739 | 1.966 | 15.184 |
| hex: silesia/webster | 524290 | 11995.3 ± 0.2% | 3614.1 ± 0.7% | 3299.6 ± 0.4% | 470.1 ± 1.6% | 6092.9 ± 1.6% | 785.4 ± 0.3% | 3.319 | 3.635 | 25.517 | 1.969 | 15.273 |
| hex: silesia/x-ray | 524290 | 11950.1 ± 0.1% | 3623.2 ± 0.2% | 3306.1 ± 0.3% | 472.0 ± 1.1% | 6144.3 ± 1.6% | 786.4 ± 0.7% | 3.298 | 3.615 | 25.318 | 1.945 | 15.195 |
| hex: silesia/xml | 524290 | 11999.7 ± 0.1% | 3617.1 ± 0.1% | 3306.5 ± 0.3% | 520.4 ± 0.5% | 6136.2 ± 1.2% | 785.4 ± 0.2% | 3.318 | 3.629 | 23.058 | 1.956 | 15.278 |
| hex: canterbury/alice29.txt | 304180 | 11997.6 ± 0.1% | 3634.6 ± 0.2% | 3343.4 ± 0.2% | 510.5 ± 0.2% | 6077.3 ± 1.1% | 784.3 ± 0.4% | 3.301 | 3.588 | 23.501 | 1.974 | 15.296 |
| hex: canterbury/asyoulik.txt | 250360 | 12005.5 ± 0.2% | 3635.4 ± 0.1% | 3359.5 ± 0.1% | 503.7 ± 0.3% | 6158.6 ± 1.3% | 783.9 ± 0.6% | 3.302 | 3.574 | 23.833 | 1.949 | 15.316 |
| hex: canterbury/cp.html | 49208 | 11893.5 ± 0.1% | 3638.7 ± 0.0% | 3279.4 ± 0.4% | 473.4 ± 0.4% | 6282.5 ± 0.4% | 773.3 ± 2.2% | 3.269 | 3.627 | 25.124 | 1.893 | 15.380 |
| hex: canterbury/fields.c | 22302 | 11782.4 ± 0.2% | 3629.6 ± 0.2% | 3353.6 ± 0.1% | 498.6 ± 0.5% | 6250.7 ± 0.4% | 752.8 ± 2.5% | 3.246 | 3.513 | 23.632 | 1.885 | 15.652 |
| hex: canterbury/grammar.lsp | 7444 | 11256.2 ± 0.1% | 3602.1 ± 0.2% | 3366.3 ± 0.4% | 553.3 ± 1.9% | 6181.7 ± 0.5% | 729.0 ± 1.8% | 3.125 | 3.344 | 20.342 | 1.821 | 15.440 |
| hex: canterbury/kennedy.xls | 524290 | 11998.5 ± 0.1% | 3623.8 ± 0.2% | 3300.4 ± 0.3% | 663.8 ± 3.1% | 6077.4 ± 1.2% | 777.1 ± 5.3% | 3.311 | 3.635 | 18.076 | 1.974 | 15.441 |
| hex: canterbury/lcet10.txt | 524290 | 12010.8 ± 0.2% | 3616.4 ± 0.4% | 3312.5 ± 0.3% | 526.1 ± 1.6% | 6121.5 ± 0.3% | 784.5 ± 0.3% | 3.321 | 3.626 | 22.828 | 1.962 | 15.311 |
| hex: canterbury/plrabn12.txt | 524290 | 11983.5 ± 0.1% | 3618.2 ± 0.1% | 3296.5 ± 0.4% | 517.0 ± 0.3% | 6062.4 ± 1.2% | 787.6 ± 0.5% | 3.312 | 3.635 | 23.180 | 1.977 | 15.216 |
| hex: canterbury/ptt5 | 524290 | 11996.9 ± 0.2% | 3620.0 ± 0.3% | 3303.8 ± 0.3% | 561.3 ± 0.9% | 6116.8 ± 1.0% | 787.3 ± 0.7% | 3.314 | 3.631 | 21.375 | 1.961 | 15.238 |
| hex: canterbury/sum | 76482 | 11901.8 ± 0.3% | 3634.5 ± 0.0% | 3355.7 ± 0.6% | 522.8 ± 2.7% | 6170.9 ± 0.8% | 777.8 ± 1.1% | 3.275 | 3.547 | 22.767 | 1.929 | 15.303 |
| hex: canterbury/xargs.1 | 8456 | 11353.8 ± 0.1% | 3602.8 ± 0.0% | 3380.2 ± 0.3% | 504.3 ± 2.3% | 6155.0 ± 0.3% | 762.3 ± 1.5% | 3.151 | 3.359 | 22.513 | 1.845 | 14.894 |
| hex: canterbury-large/E.coli | 524290 | 12013.5 ± 0.3% | 3615.3 ± 0.4% | 3299.8 ± 0.4% | 689.4 ± 0.1% | 6088.0 ± 1.7% | 788.9 ± 1.2% | 3.323 | 3.641 | 17.427 | 1.973 | 15.229 |
| hex: canterbury-large/bible.txt | 524290 | 12006.8 ± 0.2% | 3614.6 ± 0.6% | 3296.2 ± 0.5% | 526.0 ± 2.8% | 6119.5 ± 0.7% | 788.9 ± 0.4% | 3.322 | 3.643 | 22.825 | 1.962 | 15.219 |
| hex: canterbury-large/world192.txt | 524290 | 12012.9 ± 0.0% | 3618.8 ± 0.3% | 3302.2 ± 0.2% | 506.2 ± 1.2% | 6112.8 ± 1.0% | 786.2 ± 0.3% | 3.320 | 3.638 | 23.730 | 1.965 | 15.281 |
| hex: http/html-1kx1024 | 2099200 | 8883.8 ± 2.0% | 3461.9 ± 0.1% | 2905.8 ± 0.4% | 474.6 ± 0.4% | 5157.7 ± 1.9% | 659.4 ± 1.7% | 2.566 | 3.057 | 18.720 | 1.722 | 13.472 |
| hex: http/html-16kx64 | 2097280 | 11779.1 ± 0.2% | 3609.2 ± 0.2% | 3273.4 ± 0.3% | 479.0 ± 1.1% | 6018.2 ± 0.5% | 758.9 ± 1.6% | 3.264 | 3.598 | 24.592 | 1.957 | 15.521 |
| hex: http/html-1m | 524290 | 12017.7 ± 0.2% | 3616.5 ± 0.2% | 3301.0 ± 0.2% | 494.3 ± 1.1% | 6123.1 ± 1.2% | 781.2 ± 3.0% | 3.323 | 3.641 | 24.313 | 1.963 | 15.384 |
| hex: http/json-1kx1024 | 2099200 | 8926.3 ± 3.0% | 3462.1 ± 0.2% | 2903.5 ± 0.3% | 575.1 ± 0.6% | 5149.0 ± 1.3% | 658.1 ± 2.0% | 2.578 | 3.074 | 15.521 | 1.734 | 13.565 |
| hex: http/json-16kx64 | 2097280 | 11776.7 ± 0.3% | 3612.0 ± 0.3% | 3267.6 ± 0.3% | 574.5 ± 0.6% | 6023.6 ± 0.8% | 754.5 ± 0.9% | 3.260 | 3.604 | 20.498 | 1.955 | 15.608 |
| hex: http/json-1m | 524290 | 12019.4 ± 0.1% | 3624.2 ± 0.4% | 3301.1 ± 0.3% | 592.4 ± 1.5% | 6123.5 ± 0.9% | 782.2 ± 3.2% | 3.316 | 3.641 | 20.288 | 1.963 | 15.366 |
| hex: http/js-1kx1024 | 2099200 | 8919.4 ± 2.0% | 3464.9 ± 0.1% | 2904.8 ± 0.6% | 481.0 ± 0.3% | 5129.5 ± 1.6% | 658.0 ± 2.3% | 2.574 | 3.071 | 18.543 | 1.739 | 13.556 |
| hex: http/js-16kx64 | 2097280 | 11774.3 ± 0.1% | 3613.9 ± 0.4% | 3275.4 ± 0.5% | 479.6 ± 0.8% | 6040.0 ± 0.6% | 751.9 ± 2.1% | 3.258 | 3.595 | 24.549 | 1.949 | 15.660 |
| hex: http/js-1m | 524290 | 11996.7 ± 0.4% | 3622.4 ± 0.2% | 3298.2 ± 0.3% | 500.8 ± 1.8% | 6001.9 ± 0.4% | 774.2 ± 4.8% | 3.312 | 3.637 | 23.954 | 1.999 | 15.496 |
| hex: http/css-1kx1024 | 2099200 | 8905.7 ± 2.8% | 3464.0 ± 0.1% | 2898.6 ± 0.4% | 489.2 ± 1.2% | 5134.9 ± 1.3% | 653.9 ± 2.1% | 2.571 | 3.072 | 18.204 | 1.734 | 13.619 |
| hex: http/css-16kx64 | 2097280 | 11779.8 ± 0.2% | 3610.7 ± 0.1% | 3276.3 ± 0.2% | 494.8 ± 0.9% | 6021.7 ± 0.2% | 756.9 ± 3.1% | 3.262 | 3.595 | 23.806 | 1.956 | 15.563 |
| hex: http/css-1m | 524290 | 12013.2 ± 0.1% | 3626.3 ± 0.3% | 3309.0 ± 0.3% | 495.5 ± 0.8% | 6129.2 ± 0.4% | 772.0 ± 4.0% | 3.313 | 3.630 | 24.244 | 1.960 | 15.562 |
| hex: shuffled/dickens-1m | 524290 | 12009.9 ± 0.2% | 3623.3 ± 0.3% | 3296.2 ± 0.4% | 525.0 ± 3.2% | 6134.0 ± 1.1% | 784.8 ± 1.0% | 3.315 | 3.644 | 22.878 | 1.958 | 15.303 |

## TextReader.next_items against the baselines

stdx's decoder a slice of tokens a call through `TextReader.next_items`, as a caller that reads a text's values in a loop calls it (decision 79). Octets are the text's. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1014.2 ± 0.1% | 922.7 ± 0.7% | 1018.8 ± 2.1% | 301.1 ± 1.0% | 666.1 ± 0.3% | 311.1 ± 4.1% | 1.099 | 0.995 | 3.368 | 1.523 | 3.261 |
| qlog records, JSON text sequence | 1467503 | 846.5 ± 0.4% | 814.9 ± 0.2% | 813.6 ± 1.6% | 244.5 ± 0.6% | 704.8 ± 0.2% | 252.9 ± 0.6% | 1.039 | 1.040 | 3.462 | 1.201 | 3.347 |
| string: silesia/dickens | 172528 | 5059.0 ± 0.3% | 1879.5 ± 0.2% | 2649.6 ± 0.3% | 361.4 ± 0.9% | 2864.5 ± 0.3% | 556.1 ± 1.8% | 2.692 | 1.909 | 13.998 | 1.766 | 9.097 |
| string: silesia/nci | 1075110 | 4320.0 ± 0.4% | 2240.4 ± 0.3% | 3005.0 ± 0.2% | 543.2 ± 1.5% | 3010.8 ± 1.3% | 603.0 ± 1.3% | 1.928 | 1.438 | 7.953 | 1.435 | 7.164 |
| string: silesia/reymont | 1075159 | 2978.5 ± 1.9% | 1812.6 ± 1.1% | 2063.5 ± 0.2% | 375.2 ± 1.5% | 2147.0 ± 0.4% | 538.8 ± 0.7% | 1.643 | 1.443 | 7.939 | 1.387 | 5.528 |
| string: silesia/samba | 97582 | 3508.9 ± 0.2% | 2027.4 ± 0.2% | 2619.5 ± 0.2% | 324.3 ± 0.4% | 1509.3 ± 0.7% | 432.2 ± 1.1% | 1.731 | 1.340 | 10.821 | 2.325 | 8.118 |
| string: silesia/webster | 1098490 | 3671.6 ± 0.3% | 1519.4 ± 0.4% | 2015.4 ± 0.5% | 359.3 ± 0.3% | 2184.3 ± 1.6% | 502.2 ± 1.7% | 2.417 | 1.822 | 10.220 | 1.681 | 7.311 |
| string: silesia/xml | 1090118 | 4814.0 ± 0.4% | 2362.8 ± 0.4% | 2536.8 ± 0.6% | 454.0 ± 1.4% | 2837.8 ± 0.6% | 569.4 ± 1.0% | 2.037 | 1.898 | 10.603 | 1.696 | 8.454 |
| string: canterbury/alice29.txt | 159425 | 4388.6 ± 0.9% | 1601.3 ± 0.2% | 2457.5 ± 0.6% | 342.4 ± 1.7% | 2507.6 ± 0.5% | 509.0 ± 0.9% | 2.741 | 1.786 | 12.818 | 1.750 | 8.622 |
| string: canterbury/asyoulik.txt | 132198 | 3494.6 ± 0.7% | 1459.2 ± 0.3% | 2247.5 ± 0.5% | 335.0 ± 0.5% | 2082.9 ± 0.3% | 465.3 ± 1.5% | 2.395 | 1.555 | 10.431 | 1.678 | 7.510 |
| string: canterbury/lcet10.txt | 441884 | 5150.5 ± 0.4% | 1852.9 ± 0.4% | 2336.2 ± 1.0% | 389.7 ± 0.8% | 2844.3 ± 0.9% | 537.1 ± 1.9% | 2.780 | 2.205 | 13.216 | 1.811 | 9.589 |
| string: canterbury/plrabn12.txt | 503330 | 4151.9 ± 0.5% | 1736.9 ± 0.2% | 2062.5 ± 0.3% | 362.1 ± 1.4% | 2527.8 ± 0.3% | 503.9 ± 1.1% | 2.390 | 2.013 | 11.468 | 1.642 | 8.240 |
| string: canterbury-large/E.coli | 1048578 | 11968.8 ± 0.7% | 3611.3 ± 0.3% | 3265.4 ± 0.6% | 928.9 ± 1.1% | 6091.0 ± 0.4% | 773.6 ± 0.3% | 3.314 | 3.665 | 12.885 | 1.965 | 15.471 |
| string: canterbury-large/bible.txt | 1055886 | 6949.3 ± 1.3% | 2940.1 ± 0.5% | 2840.6 ± 0.6% | 419.6 ± 1.9% | 3784.3 ± 1.5% | 621.5 ± 0.8% | 2.364 | 2.446 | 16.562 | 1.836 | 11.182 |
| string: canterbury-large/world192.txt | 1103121 | 3404.0 ± 0.5% | 1484.1 ± 0.4% | 2012.7 ± 0.3% | 352.1 ± 0.4% | 2121.3 ± 0.9% | 503.7 ± 1.2% | 2.294 | 1.691 | 9.667 | 1.605 | 6.758 |
| string: http/html-1m | 1058582 | 6234.5 ± 1.8% | 2738.0 ± 0.6% | 2706.7 ± 0.3% | 443.3 ± 0.8% | 3487.8 ± 0.9% | 600.4 ± 0.8% | 2.277 | 2.303 | 14.065 | 1.788 | 10.385 |
| string: http/json-1m | 1190272 | 2559.7 ± 0.6% | 877.7 ± 0.2% | 2256.8 ± 0.4% | 389.7 ± 0.3% | 1043.2 ± 2.6% | 444.0 ± 0.7% | 2.916 | 1.134 | 6.568 | 2.454 | 5.765 |
| string: http/js-1m | 1144362 | 2286.8 ± 0.3% | 1028.5 ± 0.4% | 1639.7 ± 0.3% | 320.8 ± 0.9% | 1522.3 ± 0.6% | 420.7 ± 0.5% | 2.223 | 1.395 | 7.128 | 1.502 | 5.435 |
| string: http/css-1m | 1097820 | 2665.1 ± 0.6% | 1678.5 ± 0.2% | 2231.3 ± 0.7% | 406.1 ± 0.8% | 1930.3 ± 1.4% | 491.2 ± 0.7% | 1.588 | 1.194 | 6.563 | 1.381 | 5.426 |
| string: dickens as Cyrillic and CJK | 1883069 | 3079.5 ± 0.4% | 1689.4 ± 0.4% | 895.8 ± 0.5% | 351.3 ± 0.1% | 666.7 ± 0.7% | 158.6 ± 2.1% | 1.823 | 3.437 | 8.766 | 4.619 | 19.415 |
| string: dickens as Cyrillic and CJK, as \u escapes | 5075485 | 1330.6 ± 0.3% | 981.0 ± 0.4% | 1213.1 ± 0.7% | 214.2 ± 0.1% | 471.3 ± 0.7% | 251.8 ± 3.3% | 1.356 | 1.097 | 6.213 | 2.823 | 5.285 |
| hex: silesia/dickens | 524290 | 11980.3 ± 0.4% | 3621.8 ± 0.1% | 3293.2 ± 0.2% | 505.6 ± 3.5% | 6081.2 ± 0.9% | 784.9 ± 2.1% | 3.308 | 3.638 | 23.694 | 1.970 | 15.264 |
| hex: silesia/mozilla | 524290 | 12000.3 ± 0.1% | 3617.2 ± 0.3% | 3300.1 ± 0.5% | 453.6 ± 1.9% | 6092.3 ± 1.1% | 787.2 ± 0.5% | 3.318 | 3.636 | 26.458 | 1.970 | 15.243 |
| hex: silesia/mr | 524290 | 12010.4 ± 0.1% | 3619.6 ± 0.2% | 3295.0 ± 0.1% | 563.1 ± 0.9% | 6099.1 ± 0.6% | 786.1 ± 0.3% | 3.318 | 3.645 | 21.328 | 1.969 | 15.278 |
| hex: silesia/nci | 524290 | 12002.1 ± 0.1% | 3617.3 ± 0.2% | 3292.1 ± 0.1% | 625.5 ± 0.7% | 6144.8 ± 0.8% | 786.0 ± 0.5% | 3.318 | 3.646 | 19.188 | 1.953 | 15.269 |
| hex: silesia/ooffice | 524290 | 12019.4 ± 0.2% | 3614.4 ± 0.3% | 3304.9 ± 0.2% | 395.5 ± 1.0% | 6109.8 ± 1.5% | 786.3 ± 0.5% | 3.325 | 3.637 | 30.390 | 1.967 | 15.286 |
| hex: silesia/osdb | 524290 | 11994.9 ± 0.1% | 3615.6 ± 0.4% | 3310.5 ± 0.1% | 480.9 ± 0.2% | 6042.8 ± 3.3% | 786.5 ± 0.3% | 3.318 | 3.623 | 24.942 | 1.985 | 15.251 |
| hex: silesia/reymont | 524290 | 12013.2 ± 0.1% | 3618.8 ± 0.2% | 3312.1 ± 0.2% | 512.3 ± 3.3% | 6098.0 ± 1.7% | 787.0 ± 0.6% | 3.320 | 3.627 | 23.449 | 1.970 | 15.265 |
| hex: silesia/samba | 524290 | 11936.8 ± 0.2% | 3618.3 ± 0.2% | 3298.2 ± 0.3% | 405.9 ± 1.3% | 6095.5 ± 0.6% | 786.7 ± 0.4% | 3.299 | 3.619 | 29.410 | 1.958 | 15.172 |
| hex: silesia/sao | 524290 | 11977.3 ± 0.2% | 3619.2 ± 0.2% | 3297.6 ± 0.3% | 344.3 ± 1.2% | 6082.5 ± 1.4% | 787.6 ± 0.8% | 3.309 | 3.632 | 34.792 | 1.969 | 15.207 |
| hex: silesia/webster | 524290 | 11991.5 ± 0.2% | 3614.1 ± 0.7% | 3299.6 ± 0.4% | 470.1 ± 1.6% | 6092.9 ± 1.6% | 785.4 ± 0.3% | 3.318 | 3.634 | 25.509 | 1.968 | 15.268 |
| hex: silesia/x-ray | 524290 | 12013.1 ± 0.1% | 3623.2 ± 0.2% | 3306.1 ± 0.3% | 472.0 ± 1.1% | 6144.3 ± 1.6% | 786.4 ± 0.7% | 3.316 | 3.634 | 25.452 | 1.955 | 15.275 |
| hex: silesia/xml | 524290 | 11996.4 ± 0.1% | 3617.1 ± 0.1% | 3306.5 ± 0.3% | 520.4 ± 0.5% | 6136.2 ± 1.2% | 785.4 ± 0.2% | 3.317 | 3.628 | 23.052 | 1.955 | 15.274 |
| hex: canterbury/alice29.txt | 304180 | 11997.2 ± 0.1% | 3634.6 ± 0.2% | 3343.4 ± 0.2% | 510.5 ± 0.2% | 6077.3 ± 1.1% | 784.3 ± 0.4% | 3.301 | 3.588 | 23.500 | 1.974 | 15.296 |
| hex: canterbury/asyoulik.txt | 250360 | 12002.5 ± 0.2% | 3635.4 ± 0.1% | 3359.5 ± 0.1% | 503.7 ± 0.3% | 6158.6 ± 1.3% | 783.9 ± 0.6% | 3.302 | 3.573 | 23.827 | 1.949 | 15.312 |
| hex: canterbury/cp.html | 49208 | 11903.3 ± 0.1% | 3638.7 ± 0.0% | 3279.4 ± 0.4% | 473.4 ± 0.4% | 6282.5 ± 0.4% | 773.3 ± 2.2% | 3.271 | 3.630 | 25.144 | 1.895 | 15.393 |
| hex: canterbury/fields.c | 22302 | 11787.3 ± 0.1% | 3629.6 ± 0.2% | 3353.6 ± 0.1% | 498.6 ± 0.5% | 6250.7 ± 0.4% | 752.8 ± 2.5% | 3.248 | 3.515 | 23.642 | 1.886 | 15.659 |
| hex: canterbury/grammar.lsp | 7444 | 11337.2 ± 0.0% | 3602.1 ± 0.2% | 3366.3 ± 0.4% | 553.3 ± 1.9% | 6181.7 ± 0.5% | 729.0 ± 1.8% | 3.147 | 3.368 | 20.489 | 1.834 | 15.551 |
| hex: canterbury/kennedy.xls | 524290 | 12002.7 ± 0.1% | 3623.8 ± 0.2% | 3300.4 ± 0.3% | 663.8 ± 3.1% | 6077.4 ± 1.2% | 777.1 ± 5.3% | 3.312 | 3.637 | 18.082 | 1.975 | 15.446 |
| hex: canterbury/lcet10.txt | 524290 | 12012.9 ± 0.2% | 3616.4 ± 0.4% | 3312.5 ± 0.3% | 526.1 ± 1.6% | 6121.5 ± 0.3% | 784.5 ± 0.3% | 3.322 | 3.627 | 22.832 | 1.962 | 15.314 |
| hex: canterbury/plrabn12.txt | 524290 | 11977.3 ± 0.1% | 3618.2 ± 0.1% | 3296.5 ± 0.4% | 517.0 ± 0.3% | 6062.4 ± 1.2% | 787.6 ± 0.5% | 3.310 | 3.633 | 23.168 | 1.976 | 15.208 |
| hex: canterbury/ptt5 | 524290 | 12007.4 ± 0.1% | 3620.0 ± 0.3% | 3303.8 ± 0.3% | 561.3 ± 0.9% | 6116.8 ± 1.0% | 787.3 ± 0.7% | 3.317 | 3.634 | 21.393 | 1.963 | 15.251 |
| hex: canterbury/sum | 76482 | 11900.1 ± 0.2% | 3634.5 ± 0.0% | 3355.7 ± 0.6% | 522.8 ± 2.7% | 6170.9 ± 0.8% | 777.8 ± 1.1% | 3.274 | 3.546 | 22.764 | 1.928 | 15.301 |
| hex: canterbury/xargs.1 | 8456 | 11357.8 ± 0.1% | 3602.8 ± 0.0% | 3380.2 ± 0.3% | 504.3 ± 2.3% | 6155.0 ± 0.3% | 762.3 ± 1.5% | 3.152 | 3.360 | 22.521 | 1.845 | 14.899 |
| hex: canterbury-large/E.coli | 524290 | 12015.7 ± 0.1% | 3615.3 ± 0.4% | 3299.8 ± 0.4% | 689.4 ± 0.1% | 6088.0 ± 1.7% | 788.9 ± 1.2% | 3.324 | 3.641 | 17.430 | 1.974 | 15.232 |
| hex: canterbury-large/bible.txt | 524290 | 11998.6 ± 0.2% | 3614.6 ± 0.6% | 3296.2 ± 0.5% | 526.0 ± 2.8% | 6119.5 ± 0.7% | 788.9 ± 0.4% | 3.320 | 3.640 | 22.810 | 1.961 | 15.209 |
| hex: canterbury-large/world192.txt | 524290 | 11997.7 ± 0.1% | 3618.8 ± 0.3% | 3302.2 ± 0.2% | 506.2 ± 1.2% | 6112.8 ± 1.0% | 786.2 ± 0.3% | 3.315 | 3.633 | 23.700 | 1.963 | 15.261 |
| hex: http/html-1kx1024 | 2099200 | 8954.4 ± 2.5% | 3461.9 ± 0.1% | 2905.8 ± 0.4% | 474.6 ± 0.4% | 5157.7 ± 1.9% | 659.4 ± 1.7% | 2.587 | 3.082 | 18.868 | 1.736 | 13.579 |
| hex: http/html-16kx64 | 2097280 | 11788.3 ± 0.1% | 3609.2 ± 0.2% | 3273.4 ± 0.3% | 479.0 ± 1.1% | 6018.2 ± 0.5% | 758.9 ± 1.6% | 3.266 | 3.601 | 24.611 | 1.959 | 15.533 |
| hex: http/html-1m | 524290 | 12025.2 ± 0.1% | 3616.5 ± 0.2% | 3301.0 ± 0.2% | 494.3 ± 1.1% | 6123.1 ± 1.2% | 781.2 ± 3.0% | 3.325 | 3.643 | 24.329 | 1.964 | 15.394 |
| hex: http/json-1kx1024 | 2099200 | 8973.2 ± 3.7% | 3462.1 ± 0.2% | 2903.5 ± 0.3% | 575.1 ± 0.6% | 5149.0 ± 1.3% | 658.1 ± 2.0% | 2.592 | 3.090 | 15.602 | 1.743 | 13.636 |
| hex: http/json-16kx64 | 2097280 | 11781.6 ± 0.2% | 3612.0 ± 0.3% | 3267.6 ± 0.3% | 574.5 ± 0.6% | 6023.6 ± 0.8% | 754.5 ± 0.9% | 3.262 | 3.606 | 20.507 | 1.956 | 15.615 |
| hex: http/json-1m | 524290 | 12019.7 ± 0.2% | 3624.2 ± 0.4% | 3301.1 ± 0.3% | 592.4 ± 1.5% | 6123.5 ± 0.9% | 782.2 ± 3.2% | 3.317 | 3.641 | 20.288 | 1.963 | 15.367 |
| hex: http/js-1kx1024 | 2099200 | 8985.7 ± 1.7% | 3464.9 ± 0.1% | 2904.8 ± 0.6% | 481.0 ± 0.3% | 5129.5 ± 1.6% | 658.0 ± 2.3% | 2.593 | 3.093 | 18.681 | 1.752 | 13.656 |
| hex: http/js-16kx64 | 2097280 | 11787.3 ± 0.1% | 3613.9 ± 0.4% | 3275.4 ± 0.5% | 479.6 ± 0.8% | 6040.0 ± 0.6% | 751.9 ± 2.1% | 3.262 | 3.599 | 24.576 | 1.952 | 15.677 |
| hex: http/js-1m | 524290 | 11993.4 ± 0.1% | 3622.4 ± 0.2% | 3298.2 ± 0.3% | 500.8 ± 1.8% | 6001.9 ± 0.4% | 774.2 ± 4.8% | 3.311 | 3.636 | 23.948 | 1.998 | 15.492 |
| hex: http/css-1kx1024 | 2099200 | 9022.0 ± 3.4% | 3464.0 ± 0.1% | 2898.6 ± 0.4% | 489.2 ± 1.2% | 5134.9 ± 1.3% | 653.9 ± 2.1% | 2.604 | 3.113 | 18.442 | 1.757 | 13.797 |
| hex: http/css-16kx64 | 2097280 | 11785.4 ± 0.2% | 3610.7 ± 0.1% | 3276.3 ± 0.2% | 494.8 ± 0.9% | 6021.7 ± 0.2% | 756.9 ± 3.1% | 3.264 | 3.597 | 23.818 | 1.957 | 15.570 |
| hex: http/css-1m | 524290 | 12019.5 ± 0.1% | 3626.3 ± 0.3% | 3309.0 ± 0.3% | 495.5 ± 0.8% | 6129.2 ± 0.4% | 772.0 ± 4.0% | 3.315 | 3.632 | 24.257 | 1.961 | 15.570 |
| hex: shuffled/dickens-1m | 524290 | 12010.1 ± 0.2% | 3623.3 ± 0.3% | 3296.2 ± 0.4% | 525.0 ± 3.2% | 6134.0 ± 1.1% | 784.8 ± 1.0% | 3.315 | 3.644 | 22.878 | 1.958 | 15.303 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1362.9 ± 0.4% | 1260.0 ± 0.2% | 1047.8 ± 0.8% | 410.1 ± 0.2% | 449.6 ± 0.2% | 416.5 ± 0.7% | 1.082 | 1.301 | 3.324 | 3.031 | 3.272 |
| qlog records, JSON text sequence | 1467503 | 1054.5 ± 0.1% | 1066.9 ± 0.1% | 786.0 ± 0.8% | 377.9 ± 1.4% | 472.9 ± 0.6% | 278.8 ± 0.5% | 0.988 | 1.342 | 2.790 | 2.230 | 3.782 |
| string: silesia/dickens | 172528 | 6911.1 ± 0.2% | 2817.1 ± 0.5% | 2927.5 ± 0.5% | 430.8 ± 1.2% | 1597.8 ± 0.5% | 1006.6 ± 0.2% | 2.453 | 2.361 | 16.041 | 4.325 | 6.866 |
| string: silesia/nci | 1075110 | 7321.0 ± 0.7% | 3423.0 ± 1.2% | 3101.1 ± 0.4% | 812.9 ± 1.8% | 1864.1 ± 0.4% | 1111.4 ± 0.1% | 2.139 | 2.361 | 9.006 | 3.927 | 6.587 |
| string: silesia/reymont | 1075159 | 3304.3 ± 1.8% | 1993.4 ± 0.9% | 2064.2 ± 0.7% | 450.4 ± 0.9% | 1509.0 ± 1.4% | 953.9 ± 0.7% | 1.658 | 1.601 | 7.337 | 2.190 | 3.464 |
| string: silesia/samba | 97582 | 4207.8 ± 0.4% | 2113.0 ± 0.5% | 3454.1 ± 0.8% | 354.3 ± 0.7% | 1484.7 ± 0.4% | 1055.8 ± 0.4% | 1.991 | 1.218 | 11.877 | 2.834 | 3.985 |
| string: silesia/webster | 1098490 | 4084.0 ± 0.6% | 1880.4 ± 0.4% | 2055.2 ± 0.3% | 441.0 ± 0.4% | 1401.1 ± 0.2% | 645.7 ± 0.3% | 2.172 | 1.987 | 9.261 | 2.915 | 6.325 |
| string: silesia/xml | 1090118 | 6157.2 ± 0.8% | 2876.6 ± 0.8% | 2647.8 ± 0.6% | 607.7 ± 0.3% | 1760.0 ± 0.8% | 925.8 ± 0.5% | 2.140 | 2.325 | 10.132 | 3.498 | 6.650 |
| string: canterbury/alice29.txt | 159425 | 6434.6 ± 1.9% | 2191.6 ± 0.5% | 2754.2 ± 0.8% | 408.8 ± 1.2% | 1472.1 ± 0.4% | 957.2 ± 0.1% | 2.936 | 2.336 | 15.742 | 4.371 | 6.723 |
| string: canterbury/asyoulik.txt | 132198 | 5678.0 ± 1.4% | 1712.6 ± 0.5% | 2381.6 ± 0.8% | 402.1 ± 0.3% | 1334.3 ± 0.1% | 885.8 ± 0.2% | 3.315 | 2.384 | 14.121 | 4.255 | 6.410 |
| string: canterbury/lcet10.txt | 441884 | 6273.3 ± 0.5% | 2577.9 ± 0.3% | 2508.4 ± 2.5% | 467.6 ± 0.7% | 1554.6 ± 0.5% | 987.7 ± 0.3% | 2.433 | 2.501 | 13.416 | 4.035 | 6.351 |
| string: canterbury/plrabn12.txt | 503330 | 5731.3 ± 0.7% | 2065.0 ± 0.5% | 2071.1 ± 0.4% | 423.2 ± 0.1% | 1395.4 ± 0.2% | 935.3 ± 0.3% | 2.775 | 2.767 | 13.542 | 4.107 | 6.128 |
| string: canterbury-large/E.coli | 1048578 | 19387.0 ± 0.8% | 9903.5 ± 0.5% | 3783.6 ± 0.7% | 1475.3 ± 0.4% | 2373.6 ± 0.6% | 1195.5 ± 0.4% | 1.958 | 5.124 | 13.141 | 8.168 | 16.216 |
| string: canterbury-large/bible.txt | 1055886 | 6813.3 ± 0.4% | 4161.2 ± 1.0% | 3057.6 ± 1.9% | 506.6 ± 0.5% | 1990.9 ± 0.3% | 1124.0 ± 0.5% | 1.637 | 2.228 | 13.449 | 3.422 | 6.062 |
| string: canterbury-large/world192.txt | 1103121 | 4065.8 ± 0.2% | 1658.7 ± 0.6% | 1998.5 ± 0.4% | 449.5 ± 0.8% | 1371.4 ± 0.2% | 911.0 ± 0.4% | 2.451 | 2.034 | 9.045 | 2.965 | 4.463 |
| string: http/html-1m | 1058582 | 6784.2 ± 0.4% | 3976.3 ± 0.5% | 3038.4 ± 0.8% | 499.5 ± 0.8% | 1928.7 ± 0.3% | 807.0 ± 0.4% | 1.706 | 2.233 | 13.581 | 3.518 | 8.406 |
| string: http/json-1m | 1190272 | 3164.3 ± 0.6% | 1357.4 ± 0.3% | 1558.3 ± 0.4% | 444.0 ± 0.9% | 1073.0 ± 0.2% | 764.4 ± 1.6% | 2.331 | 2.031 | 7.127 | 2.949 | 4.140 |
| string: http/js-1m | 1144362 | 2778.7 ± 0.1% | 1181.4 ± 0.3% | 1626.1 ± 0.2% | 369.2 ± 0.1% | 1109.7 ± 0.5% | 760.1 ± 0.4% | 2.352 | 1.709 | 7.527 | 2.504 | 3.656 |
| string: http/css-1m | 1097820 | 4008.2 ± 0.9% | 1491.3 ± 0.6% | 2156.4 ± 0.9% | 493.3 ± 0.4% | 1382.6 ± 0.3% | 898.2 ± 0.7% | 2.688 | 1.859 | 8.125 | 2.899 | 4.462 |
| string: dickens as Cyrillic and CJK | 1883069 | 3068.9 ± 0.5% | 2335.8 ± 0.7% | 521.4 ± 0.2% | 307.4 ± 0.5% | 562.7 ± 1.1% | 336.9 ± 0.6% | 1.314 | 5.885 | 9.984 | 5.454 | 9.110 |
| hex: silesia/dickens | 524290 | 15628.1 ± 0.4% | 1469.1 ± 0.2% | 1084.2 ± 0.4% | 502.5 ± 0.3% | 991.4 ± 0.5% | 735.8 ± 0.4% | 10.638 | 14.414 | 31.102 | 15.764 | 21.240 |
| hex: silesia/mozilla | 524290 | 15650.5 ± 0.3% | 1478.5 ± 0.1% | 1091.2 ± 0.3% | 441.8 ± 0.6% | 991.7 ± 0.4% | 736.6 ± 0.7% | 10.585 | 14.342 | 35.422 | 15.781 | 21.247 |
| hex: silesia/mr | 524290 | 15575.1 ± 0.3% | 1487.6 ± 0.2% | 1093.3 ± 0.4% | 556.2 ± 3.3% | 996.7 ± 0.7% | 738.6 ± 0.3% | 10.470 | 14.246 | 28.001 | 15.627 | 21.086 |
| hex: silesia/nci | 524290 | 15675.1 ± 0.3% | 1477.2 ± 0.4% | 1090.6 ± 0.3% | 651.0 ± 2.2% | 991.9 ± 1.1% | 736.3 ± 0.6% | 10.612 | 14.373 | 24.079 | 15.803 | 21.288 |
| hex: silesia/ooffice | 524290 | 15626.1 ± 0.5% | 1471.6 ± 0.2% | 1086.6 ± 0.3% | 389.8 ± 0.3% | 991.5 ± 0.5% | 737.3 ± 0.4% | 10.618 | 14.380 | 40.091 | 15.761 | 21.192 |
| hex: silesia/osdb | 524290 | 15680.3 ± 0.2% | 1475.8 ± 0.3% | 1090.6 ± 0.6% | 467.4 ± 1.4% | 992.0 ± 0.7% | 736.9 ± 0.4% | 10.625 | 14.377 | 33.547 | 15.806 | 21.279 |
| hex: silesia/reymont | 524290 | 15559.5 ± 0.7% | 1471.0 ± 0.8% | 1086.5 ± 0.6% | 515.2 ± 1.7% | 988.7 ± 1.0% | 736.9 ± 0.5% | 10.578 | 14.321 | 30.203 | 15.737 | 21.113 |
| hex: silesia/samba | 524290 | 15685.3 ± 0.2% | 1470.1 ± 0.3% | 1087.9 ± 0.3% | 403.1 ± 0.2% | 990.6 ± 0.7% | 736.1 ± 0.5% | 10.670 | 14.419 | 38.909 | 15.835 | 21.309 |
| hex: silesia/sao | 524290 | 15670.9 ± 0.2% | 1471.5 ± 0.3% | 1084.6 ± 0.2% | 332.9 ± 0.4% | 992.1 ± 0.5% | 734.9 ± 0.8% | 10.649 | 14.449 | 47.069 | 15.796 | 21.324 |
| hex: silesia/webster | 524290 | 15693.3 ± 0.3% | 1470.8 ± 0.4% | 1087.6 ± 0.3% | 475.2 ± 0.8% | 990.1 ± 0.4% | 737.5 ± 0.2% | 10.670 | 14.429 | 33.022 | 15.850 | 21.280 |
| hex: silesia/x-ray | 524290 | 15652.5 ± 0.1% | 1484.3 ± 0.3% | 1092.0 ± 0.3% | 445.8 ± 1.2% | 996.6 ± 0.5% | 735.0 ± 0.6% | 10.546 | 14.334 | 35.107 | 15.706 | 21.297 |
| hex: silesia/xml | 524290 | 15666.6 ± 0.3% | 1475.6 ± 0.2% | 1089.5 ± 0.3% | 614.0 ± 1.0% | 990.5 ± 0.4% | 737.0 ± 0.5% | 10.617 | 14.379 | 25.516 | 15.817 | 21.256 |
| hex: canterbury/alice29.txt | 304180 | 15705.2 ± 0.0% | 1474.6 ± 0.8% | 1093.5 ± 0.2% | 503.7 ± 1.6% | 995.9 ± 0.7% | 737.3 ± 0.3% | 10.650 | 14.362 | 31.179 | 15.771 | 21.301 |
| hex: canterbury/asyoulik.txt | 250360 | 15710.1 ± 0.1% | 1474.1 ± 0.7% | 1092.2 ± 0.6% | 495.3 ± 1.1% | 996.1 ± 0.2% | 740.9 ± 0.3% | 10.657 | 14.384 | 31.716 | 15.772 | 21.204 |
| hex: canterbury/cp.html | 49208 | 15670.1 ± 0.1% | 1471.2 ± 0.4% | 1096.9 ± 0.2% | 527.5 ± 4.5% | 1000.8 ± 0.5% | 743.5 ± 0.2% | 10.651 | 14.286 | 29.706 | 15.658 | 21.077 |
| hex: canterbury/fields.c | 22302 | 15526.2 ± 0.0% | 1411.9 ± 0.5% | 1061.0 ± 0.7% | 626.1 ± 7.0% | 988.4 ± 0.0% | 736.9 ± 0.1% | 10.997 | 14.634 | 24.799 | 15.709 | 21.070 |
| hex: canterbury/grammar.lsp | 7444 | 15156.2 ± 0.1% | 1507.1 ± 0.2% | 1093.7 ± 0.6% | 671.7 ± 3.9% | 1002.6 ± 0.2% | 725.8 ± 0.2% | 10.056 | 13.858 | 22.565 | 15.116 | 20.882 |
| hex: canterbury/kennedy.xls | 524290 | 15603.3 ± 0.4% | 1476.0 ± 0.2% | 1088.1 ± 0.3% | 656.2 ± 1.9% | 994.5 ± 0.5% | 736.5 ± 0.7% | 10.572 | 14.340 | 23.780 | 15.689 | 21.187 |
| hex: canterbury/lcet10.txt | 524290 | 15650.5 ± 0.2% | 1468.3 ± 0.3% | 1085.7 ± 0.3% | 504.8 ± 1.0% | 989.9 ± 0.4% | 736.5 ± 0.5% | 10.659 | 14.415 | 31.003 | 15.811 | 21.249 |
| hex: canterbury/plrabn12.txt | 524290 | 15589.6 ± 0.8% | 1467.7 ± 0.4% | 1086.5 ± 0.5% | 496.3 ± 0.6% | 987.3 ± 0.4% | 736.1 ± 0.7% | 10.622 | 14.348 | 31.411 | 15.790 | 21.178 |
| hex: canterbury/ptt5 | 524290 | 15671.0 ± 0.2% | 1484.2 ± 0.4% | 1095.1 ± 0.3% | 557.5 ± 1.0% | 996.7 ± 0.4% | 735.7 ± 0.7% | 10.559 | 14.310 | 28.108 | 15.722 | 21.302 |
| hex: canterbury/sum | 76482 | 15679.1 ± 0.1% | 1494.4 ± 0.1% | 1103.7 ± 0.4% | 601.6 ± 0.8% | 997.8 ± 0.1% | 743.5 ± 0.3% | 10.492 | 14.206 | 26.064 | 15.713 | 21.089 |
| hex: canterbury/xargs.1 | 8456 | 15198.3 ± 0.1% | 1480.6 ± 0.2% | 1098.0 ± 0.4% | 671.6 ± 4.6% | 1001.0 ± 0.3% | 726.9 ± 0.2% | 10.265 | 13.842 | 22.629 | 15.184 | 20.908 |
| hex: canterbury-large/E.coli | 524290 | 15673.3 ± 0.6% | 1481.1 ± 0.4% | 1090.0 ± 0.8% | 672.8 ± 0.1% | 994.1 ± 0.6% | 736.3 ± 0.4% | 10.582 | 14.379 | 23.296 | 15.766 | 21.285 |
| hex: canterbury-large/bible.txt | 524290 | 15662.1 ± 0.2% | 1468.3 ± 0.4% | 1085.8 ± 1.3% | 512.3 ± 0.6% | 987.5 ± 0.4% | 736.6 ± 0.6% | 10.667 | 14.425 | 30.573 | 15.861 | 21.263 |
| hex: canterbury-large/world192.txt | 524290 | 15646.6 ± 0.2% | 1469.8 ± 0.3% | 1087.2 ± 0.4% | 503.3 ± 0.5% | 991.1 ± 0.4% | 736.8 ± 0.3% | 10.646 | 14.391 | 31.088 | 15.787 | 21.236 |
| hex: http/html-1kx1024 | 2099200 | 14203.8 ± 0.6% | 1460.3 ± 0.6% | 1061.3 ± 0.3% | 502.1 ± 0.1% | 984.7 ± 0.5% | 693.1 ± 0.1% | 9.727 | 13.384 | 28.288 | 14.424 | 20.493 |
| hex: http/html-16kx64 | 2097280 | 15431.7 ± 0.4% | 1454.8 ± 2.9% | 1075.8 ± 0.4% | 508.0 ± 0.5% | 998.3 ± 0.3% | 735.6 ± 0.2% | 10.607 | 14.344 | 30.378 | 15.458 | 20.978 |
| hex: http/html-1m | 524290 | 15674.0 ± 0.4% | 1469.5 ± 0.3% | 1085.8 ± 0.3% | 500.5 ± 1.1% | 989.7 ± 0.4% | 736.4 ± 0.6% | 10.666 | 14.435 | 31.318 | 15.837 | 21.285 |
| hex: http/json-1kx1024 | 2099200 | 14223.0 ± 0.5% | 1463.5 ± 0.2% | 1067.3 ± 0.2% | 608.8 ± 0.6% | 988.6 ± 0.2% | 693.0 ± 0.2% | 9.719 | 13.326 | 23.364 | 14.387 | 20.524 |
| hex: http/json-16kx64 | 2097280 | 15372.1 ± 0.9% | 1450.6 ± 0.2% | 1074.4 ± 0.2% | 616.2 ± 0.6% | 996.2 ± 0.2% | 734.8 ± 0.2% | 10.597 | 14.308 | 24.948 | 15.431 | 20.919 |
| hex: http/json-1m | 524290 | 15597.7 ± 0.1% | 1480.7 ± 0.3% | 1091.7 ± 0.2% | 635.2 ± 0.5% | 993.5 ± 0.8% | 734.3 ± 0.5% | 10.534 | 14.288 | 24.555 | 15.700 | 21.242 |
| hex: http/js-1kx1024 | 2099200 | 14265.6 ± 0.4% | 1454.3 ± 0.0% | 1065.5 ± 0.4% | 500.0 ± 0.4% | 983.6 ± 0.2% | 693.2 ± 0.3% | 9.809 | 13.388 | 28.532 | 14.503 | 20.579 |
| hex: http/js-16kx64 | 2097280 | 15381.8 ± 0.5% | 1444.0 ± 0.2% | 1075.0 ± 0.3% | 505.8 ± 0.2% | 997.0 ± 0.3% | 735.9 ± 0.2% | 10.652 | 14.308 | 30.412 | 15.428 | 20.902 |
| hex: http/js-1m | 524290 | 15643.2 ± 0.4% | 1468.5 ± 0.2% | 1088.8 ± 0.9% | 511.2 ± 0.5% | 991.9 ± 0.7% | 735.9 ± 0.6% | 10.653 | 14.367 | 30.603 | 15.771 | 21.257 |
| hex: http/css-1kx1024 | 2099200 | 14171.1 ± 0.6% | 1456.7 ± 0.2% | 1062.7 ± 0.3% | 531.4 ± 0.4% | 983.6 ± 0.1% | 693.2 ± 0.1% | 9.728 | 13.335 | 26.669 | 14.408 | 20.444 |
| hex: http/css-16kx64 | 2097280 | 15400.7 ± 0.5% | 1444.3 ± 0.3% | 1075.3 ± 0.2% | 542.5 ± 1.0% | 997.9 ± 0.5% | 734.6 ± 0.1% | 10.663 | 14.323 | 28.388 | 15.433 | 20.966 |
| hex: http/css-1m | 524290 | 15686.1 ± 0.3% | 1468.3 ± 0.3% | 1086.9 ± 0.5% | 527.5 ± 0.2% | 984.8 ± 0.5% | 735.6 ± 0.4% | 10.683 | 14.432 | 29.734 | 15.929 | 21.324 |
| hex: shuffled/dickens-1m | 524290 | 15692.4 ± 0.6% | 1469.1 ± 0.2% | 1084.8 ± 0.4% | 500.7 ± 0.2% | 990.0 ± 0.9% | 736.6 ± 0.8% | 10.681 | 14.466 | 31.340 | 15.851 | 21.303 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.920 of yyjson.
