# bench-json

| Field | Value |
|---|---|
| Commit | ba2323e |
| Runner label | ubuntu-24.04-arm |
| Image version | 20261111.182.1 |
| CPU model | Neoverse-N2 |
| Virtual CPUs | 4 |
| Kernel | 7.0.0-1017-azure |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/43616673315 |
| Date | 2026-11-14 |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1. The `TextReader.next_items` column is that helper's queued tokens a slice a call (decision 79), over many tokens a call.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | TextReader.next_items | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1128.4 ± 0.8% | 0.523 | 0.965 | 0.996 | 0.996 | 0.457 | 1.001 | 1.006 | 0.383 | 0.830 | 0.897 | 0.101 |
| qlog records, JSON text sequence | 1467503 | 844.5 ± 17.1% | 0.824 | 1.010 | 1.005 | 1.005 | 0.448 | 1.001 | 1.031 | 0.398 | 0.930 | 0.998 | 0.126 |
| string: silesia/dickens | 172528 | 5051.0 ± 0.3% | 0.033 | 0.781 | 1.001 | 1.002 | 0.197 | 1.016 | 1.006 | 0.196 | 1.001 | 1.000 | 0.032 |
| string: silesia/nci | 1075110 | 4289.3 ± 0.4% | 0.039 | 0.806 | 1.006 | 1.005 | 0.277 | 1.008 | 1.000 | 0.280 | 1.004 | 1.005 | 0.038 |
| string: silesia/reymont | 1075159 | 2938.1 ± 1.7% | 0.057 | 0.816 | 0.994 | 1.001 | 0.359 | 1.001 | 1.004 | 0.359 | 1.027 | 1.029 | 0.056 |
| string: silesia/samba | 97582 | 3489.1 ± 0.7% | 0.041 | 0.863 | 1.005 | 1.006 | 0.069 | 0.779 | 1.012 | 0.067 | 1.003 | 1.006 | 0.041 |
| string: silesia/webster | 1098490 | 3636.7 ± 0.9% | 0.045 | 0.849 | 1.004 | 1.009 | 0.204 | 1.019 | 1.016 | 0.204 | 1.008 | 1.007 | 0.044 |
| string: silesia/xml | 1090118 | 4788.3 ± 0.5% | 0.035 | 0.805 | 1.003 | 1.004 | 0.221 | 0.978 | 1.008 | 0.219 | 1.002 | 1.002 | 0.034 |
| string: canterbury/alice29.txt | 159425 | 4303.7 ± 1.0% | 0.038 | 0.751 | 1.003 | 1.006 | 0.172 | 1.027 | 1.019 | 0.171 | 1.008 | 1.012 | 0.037 |
| string: canterbury/asyoulik.txt | 132198 | 3457.7 ± 1.5% | 0.046 | 0.748 | 1.005 | 1.010 | 0.176 | 1.003 | 0.970 | 0.176 | 1.012 | 1.012 | 0.045 |
| string: canterbury/lcet10.txt | 441884 | 5089.7 ± 0.3% | 0.033 | 0.819 | 1.005 | 1.006 | 0.197 | 1.021 | 1.012 | 0.196 | 1.004 | 1.007 | 0.032 |
| string: canterbury/plrabn12.txt | 503330 | 4124.9 ± 0.8% | 0.040 | 0.826 | 1.006 | 1.006 | 0.198 | 1.008 | 0.997 | 0.198 | 1.005 | 1.007 | 0.039 |
| string: canterbury-large/E.coli | 1048578 | 19216.2 ± 0.6% | 0.077 | 1.004 | 1.001 | 0.999 | 0.480 | 1.004 | 1.002 | 0.479 | 0.620 | 0.620 | 0.009 |
| string: canterbury-large/bible.txt | 1055886 | 6670.3 ± 0.8% | 0.026 | 0.806 | 1.009 | 1.015 | 0.434 | 1.032 | 1.042 | 0.433 | 1.033 | 1.035 | 0.025 |
| string: canterbury-large/world192.txt | 1103121 | 3386.2 ± 0.7% | 0.048 | 0.845 | 1.004 | 1.005 | 0.198 | 1.013 | 1.007 | 0.198 | 1.004 | 1.001 | 0.047 |
| string: http/html-1m | 1058582 | 6044.3 ± 0.7% | 0.028 | 0.783 | 1.016 | 1.043 | 0.389 | 1.043 | 1.055 | 0.389 | 1.034 | 1.037 | 0.028 |
| string: http/json-1m | 1190272 | 2546.5 ± 0.5% | 0.056 | 0.949 | 1.004 | 1.004 | 0.109 | 1.005 | 0.471 | 0.110 | 1.006 | 1.004 | 0.055 |
| string: http/js-1m | 1144362 | 2289.2 ± 0.6% | 0.066 | 0.887 | 1.000 | 1.000 | 0.174 | 1.051 | 1.041 | 0.174 | 0.999 | 0.998 | 0.065 |
| string: http/css-1m | 1097820 | 2635.6 ± 0.4% | 0.061 | 0.776 | 1.003 | 1.008 | 0.238 | 1.007 | 1.014 | 0.240 | 1.006 | 1.008 | 0.060 |
| string: dickens as Cyrillic and CJK | 1883069 | 3073.8 ± 0.4% | 0.044 | 0.125 | 1.000 | 1.000 | 0.336 | 0.998 | 1.006 | 0.336 | 1.000 | 1.002 | 0.044 |
| string: dickens as Cyrillic and CJK, as \u escapes | 5075485 | 1327.8 ± 1.9% | 0.085 | 1.004 | 1.001 | 1.000 | 0.078 | 0.638 | 1.005 | 0.075 | 1.002 | 1.002 | 0.085 |
| hex: silesia/dickens | 524290 | 18837.2 ± 0.5% | 0.079 | 1.004 | 0.993 | 0.982 | 0.511 | 0.981 | 0.983 | 0.509 | 0.637 | 0.637 | 0.009 |
| hex: silesia/mozilla | 524290 | 18665.5 ± 1.7% | 0.079 | 1.006 | 1.002 | 0.992 | 0.505 | 0.990 | 0.988 | 0.504 | 0.643 | 0.643 | 0.009 |
| hex: silesia/mr | 524290 | 18420.2 ± 0.5% | 0.081 | 1.010 | 1.009 | 1.007 | 0.517 | 0.998 | 1.008 | 0.518 | 0.650 | 0.651 | 0.009 |
| hex: silesia/nci | 524290 | 18848.8 ± 0.8% | 0.079 | 0.998 | 0.997 | 0.992 | 0.510 | 0.996 | 0.994 | 0.511 | 0.637 | 0.637 | 0.009 |
| hex: silesia/ooffice | 524290 | 18708.3 ± 0.6% | 0.079 | 1.006 | 1.012 | 1.009 | 0.508 | 1.010 | 1.008 | 0.506 | 0.641 | 0.641 | 0.009 |
| hex: silesia/osdb | 524290 | 18465.7 ± 0.7% | 0.081 | 1.012 | 1.004 | 1.004 | 0.525 | 1.007 | 0.999 | 0.523 | 0.651 | 0.651 | 0.009 |
| hex: silesia/reymont | 524290 | 18751.7 ± 0.3% | 0.079 | 0.998 | 1.000 | 0.989 | 0.502 | 0.991 | 0.988 | 0.503 | 0.638 | 0.638 | 0.009 |
| hex: silesia/samba | 524290 | 18050.4 ± 0.9% | 0.082 | 0.997 | 0.995 | 0.998 | 0.536 | 0.998 | 0.997 | 0.535 | 0.664 | 0.665 | 0.010 |
| hex: silesia/sao | 524290 | 18623.0 ± 0.8% | 0.080 | 1.005 | 0.995 | 0.992 | 0.507 | 0.996 | 0.986 | 0.508 | 0.644 | 0.644 | 0.009 |
| hex: silesia/webster | 524290 | 18849.1 ± 1.0% | 0.079 | 1.007 | 1.002 | 1.001 | 0.515 | 1.000 | 1.001 | 0.517 | 0.637 | 0.637 | 0.009 |
| hex: silesia/x-ray | 524290 | 18283.1 ± 1.5% | 0.082 | 1.003 | 0.999 | 0.996 | 0.532 | 1.005 | 1.001 | 0.532 | 0.657 | 0.657 | 0.009 |
| hex: silesia/xml | 524290 | 18703.3 ± 1.4% | 0.079 | 1.007 | 0.993 | 0.988 | 0.505 | 0.999 | 0.999 | 0.506 | 0.640 | 0.641 | 0.009 |
| hex: canterbury/alice29.txt | 304180 | 19327.7 ± 0.4% | 0.077 | 1.004 | 0.996 | 0.995 | 0.511 | 1.003 | 1.002 | 0.511 | 0.621 | 0.621 | 0.009 |
| hex: canterbury/asyoulik.txt | 250360 | 19544.5 ± 0.2% | 0.077 | 1.002 | 1.002 | 1.002 | 0.513 | 1.001 | 1.001 | 0.514 | 0.615 | 0.614 | 0.009 |
| hex: canterbury/cp.html | 49208 | 19309.9 ± 0.1% | 0.083 | 1.001 | 1.000 | 0.999 | 0.541 | 1.001 | 1.001 | 0.542 | 0.618 | 0.618 | 0.009 |
| hex: canterbury/fields.c | 22302 | 18879.2 ± 0.5% | 0.085 | 1.002 | 1.005 | 1.005 | 0.534 | 1.001 | 1.005 | 0.540 | 0.624 | 0.624 | 0.009 |
| hex: canterbury/grammar.lsp | 7444 | 17324.1 ± 2.2% | 0.088 | 1.016 | 1.017 | 1.017 | 0.531 | 1.015 | 1.016 | 0.549 | 0.650 | 0.654 | 0.010 |
| hex: canterbury/kennedy.xls | 524290 | 18737.7 ± 0.9% | 0.079 | 1.009 | 0.999 | 0.991 | 0.510 | 0.998 | 0.992 | 0.512 | 0.641 | 0.640 | 0.009 |
| hex: canterbury/lcet10.txt | 524290 | 18771.9 ± 0.9% | 0.079 | 1.002 | 0.997 | 0.997 | 0.503 | 1.004 | 0.998 | 0.503 | 0.637 | 0.638 | 0.009 |
| hex: canterbury/plrabn12.txt | 524290 | 18527.9 ± 1.8% | 0.080 | 0.998 | 0.998 | 0.998 | 0.515 | 0.997 | 0.992 | 0.515 | 0.649 | 0.649 | 0.009 |
| hex: canterbury/ptt5 | 524290 | 18421.2 ± 0.4% | 0.081 | 1.004 | 0.998 | 0.996 | 0.528 | 1.003 | 0.999 | 0.527 | 0.650 | 0.650 | 0.009 |
| hex: canterbury/sum | 76482 | 19290.4 ± 0.1% | 0.078 | 1.002 | 1.002 | 1.002 | 0.518 | 1.002 | 1.002 | 0.520 | 0.618 | 0.618 | 0.009 |
| hex: canterbury/xargs.1 | 8456 | 17837.8 ± 0.2% | 0.087 | 1.002 | 1.002 | 1.002 | 0.524 | 1.000 | 1.001 | 0.539 | 0.636 | 0.637 | 0.010 |
| hex: canterbury-large/E.coli | 524290 | 18581.4 ± 2.3% | 0.080 | 1.015 | 1.009 | 1.004 | 0.520 | 1.009 | 1.003 | 0.516 | 0.647 | 0.647 | 0.009 |
| hex: canterbury-large/bible.txt | 524290 | 18885.9 ± 0.7% | 0.079 | 1.001 | 1.002 | 1.003 | 0.512 | 0.999 | 0.998 | 0.514 | 0.636 | 0.635 | 0.009 |
| hex: canterbury-large/world192.txt | 524290 | 18401.5 ± 0.5% | 0.081 | 1.002 | 0.997 | 0.996 | 0.525 | 1.001 | 0.999 | 0.525 | 0.653 | 0.654 | 0.009 |
| hex: http/html-1kx1024 | 2099200 | 9384.8 ± 11.9% | 0.152 | 1.255 | 1.268 | 1.267 | 0.703 | 1.266 | 0.979 | 0.766 | 0.952 | 0.961 | 0.018 |
| hex: http/html-16kx64 | 2097280 | 17807.2 ± 1.3% | 0.084 | 1.024 | 1.023 | 1.023 | 0.574 | 1.025 | 0.994 | 0.580 | 0.660 | 0.661 | 0.010 |
| hex: http/html-1m | 524290 | 18213.7 ± 1.6% | 0.082 | 1.012 | 1.005 | 1.005 | 0.523 | 1.005 | 1.002 | 0.525 | 0.658 | 0.656 | 0.010 |
| hex: http/json-1kx1024 | 2099200 | 9248.4 ± 17.5% | 0.154 | 1.289 | 1.282 | 1.276 | 0.711 | 1.287 | 0.988 | 0.778 | 0.946 | 0.952 | 0.019 |
| hex: http/json-16kx64 | 2097280 | 18028.2 ± 1.1% | 0.083 | 1.018 | 1.014 | 1.015 | 0.567 | 1.016 | 0.986 | 0.573 | 0.652 | 0.653 | 0.010 |
| hex: http/json-1m | 524290 | 18418.2 ± 1.7% | 0.081 | 1.010 | 1.003 | 1.000 | 0.521 | 0.994 | 1.003 | 0.522 | 0.652 | 0.651 | 0.009 |
| hex: http/js-1kx1024 | 2099200 | 9277.4 ± 18.1% | 0.154 | 1.276 | 1.276 | 1.274 | 0.707 | 1.276 | 0.985 | 0.773 | 0.946 | 0.951 | 0.019 |
| hex: http/js-16kx64 | 2097280 | 17924.8 ± 1.2% | 0.084 | 1.023 | 1.020 | 1.021 | 0.569 | 1.021 | 0.992 | 0.573 | 0.657 | 0.657 | 0.010 |
| hex: http/js-1m | 524290 | 18871.6 ± 0.6% | 0.079 | 1.002 | 1.004 | 0.999 | 0.511 | 0.991 | 0.999 | 0.512 | 0.634 | 0.634 | 0.009 |
| hex: http/css-1kx1024 | 2099200 | 9304.3 ± 11.6% | 0.153 | 1.283 | 1.271 | 1.276 | 0.701 | 1.265 | 0.984 | 0.767 | 0.942 | 0.947 | 0.018 |
| hex: http/css-16kx64 | 2097280 | 17988.8 ± 1.2% | 0.083 | 1.018 | 1.017 | 1.016 | 0.569 | 1.016 | 0.983 | 0.574 | 0.654 | 0.654 | 0.010 |
| hex: http/css-1m | 524290 | 18764.7 ± 1.8% | 0.079 | 1.007 | 1.011 | 1.007 | 0.501 | 1.005 | 1.005 | 0.501 | 0.639 | 0.639 | 0.009 |
| hex: shuffled/dickens-1m | 524290 | 18097.3 ± 0.5% | 0.082 | 1.008 | 1.006 | 1.006 | 0.522 | 1.010 | 1.010 | 0.521 | 0.662 | 0.661 | 0.010 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1483.3 ± 0.8% | 0.445 | 1.002 | 0.970 | 1.005 | 1.004 | 0.267 | 1.002 | 0.549 | 0.917 | 0.088 | 1.030 |
| qlog records, JSON text sequence | 1467503 | 1271.9 ± 0.9% | 0.689 | 0.975 | 1.010 | 1.012 | 1.010 | 0.264 | 0.999 | 0.501 | 0.828 | 0.105 | 1.014 |
| string: silesia/dickens | 172528 | 6896.8 ± 0.4% | 0.025 | 1.000 | 1.001 | 1.001 | 1.001 | 0.165 | 0.717 | 1.003 | 1.002 | 0.025 | 1.033 |
| string: silesia/nci | 1075110 | 7298.1 ± 0.2% | 0.024 | 1.001 | 1.001 | 1.001 | 1.002 | 0.210 | 0.565 | 1.002 | 1.002 | 0.024 | 1.011 |
| string: silesia/reymont | 1075159 | 3339.4 ± 1.1% | 0.052 | 0.997 | 1.004 | 1.004 | 1.002 | 0.387 | 0.871 | 1.002 | 0.996 | 0.052 | 1.052 |
| string: silesia/samba | 97582 | 4197.3 ± 0.5% | 0.053 | 1.001 | 0.997 | 1.005 | 1.006 | 0.124 | 0.946 | 1.001 | 1.003 | 0.053 | 1.092 |
| string: silesia/webster | 1098490 | 4053.9 ± 0.4% | 0.042 | 1.009 | 1.007 | 1.008 | 1.008 | 0.211 | 0.888 | 1.000 | 1.005 | 0.042 | 1.011 |
| string: silesia/xml | 1090118 | 6115.7 ± 0.8% | 0.029 | 1.005 | 0.998 | 1.005 | 1.004 | 0.252 | 0.774 | 1.001 | 1.003 | 0.029 | 1.018 |
| string: canterbury/alice29.txt | 159425 | 6391.3 ± 0.7% | 0.027 | 1.012 | 1.013 | 1.013 | 1.016 | 0.131 | 0.656 | 1.004 | 1.008 | 0.027 | 1.055 |
| string: canterbury/asyoulik.txt | 132198 | 5598.8 ± 1.5% | 0.030 | 1.026 | 1.033 | 1.034 | 1.037 | 0.128 | 0.596 | 1.000 | 1.010 | 0.030 | 1.062 |
| string: canterbury/lcet10.txt | 441884 | 6228.9 ± 0.6% | 0.028 | 1.009 | 1.011 | 1.010 | 1.010 | 0.183 | 0.802 | 1.004 | 1.006 | 0.028 | 1.004 |
| string: canterbury/plrabn12.txt | 503330 | 5698.8 ± 0.3% | 0.030 | 1.001 | 1.002 | 1.003 | 1.003 | 0.167 | 0.699 | 1.001 | 1.002 | 0.030 | 1.011 |
| string: canterbury-large/E.coli | 1048578 | 19173.4 ± 0.7% | 0.078 | 0.999 | 1.001 | 1.003 | 1.002 | 0.482 | 1.003 | 1.004 | 1.004 | 0.009 | 1.001 |
| string: canterbury-large/bible.txt | 1055886 | 6792.6 ± 0.2% | 0.026 | 1.000 | 1.002 | 1.002 | 1.002 | 0.494 | 0.971 | 1.001 | 1.002 | 0.027 | 1.001 |
| string: canterbury-large/world192.txt | 1103121 | 4010.5 ± 0.4% | 0.043 | 1.021 | 1.023 | 1.020 | 1.021 | 0.192 | 0.833 | 1.005 | 1.013 | 0.042 | 1.007 |
| string: http/html-1m | 1058582 | 6732.8 ± 1.3% | 0.026 | 1.006 | 0.927 | 1.003 | 1.009 | 0.404 | 0.890 | 1.004 | 1.006 | 0.026 | 1.011 |
| string: http/json-1m | 1190272 | 3157.4 ± 0.3% | 0.051 | 1.002 | 0.969 | 1.005 | 1.004 | 0.132 | 0.371 | 1.003 | 1.004 | 0.050 | 1.045 |
| string: http/js-1m | 1144362 | 2752.1 ± 0.5% | 0.061 | 1.007 | 1.011 | 1.004 | 1.007 | 0.164 | 0.839 | 1.006 | 1.009 | 0.060 | 1.019 |
| string: http/css-1m | 1097820 | 3995.8 ± 0.9% | 0.043 | 1.001 | 1.006 | 1.006 | 1.006 | 0.205 | 0.643 | 0.996 | 1.002 | 0.042 | 1.008 |
| string: dickens as Cyrillic and CJK | 1883069 | 3067.4 ± 0.3% | 0.048 | 1.002 | 0.124 | 1.000 | 1.001 | 0.319 | 1.003 | 1.001 | 1.001 | 0.048 | 1.002 |
| hex: silesia/dickens | 524290 | 15645.4 ± 0.1% | 1.000 | 0.177 | 1.000 | 1.002 | 1.001 | 1.000 | 1.001 | 0.997 | 1.001 | 0.177 | 1.000 |
| hex: silesia/mozilla | 524290 | 15632.5 ± 0.2% | 1.001 | 0.178 | 1.001 | 1.001 | 1.002 | 1.001 | 1.001 | 1.001 | 1.002 | 0.178 | 1.002 |
| hex: silesia/mr | 524290 | 15618.7 ± 0.2% | 1.003 | 0.179 | 1.001 | 1.000 | 1.000 | 1.000 | 1.003 | 1.003 | 1.002 | 0.178 | 1.004 |
| hex: silesia/nci | 524290 | 15580.0 ± 0.1% | 1.001 | 0.179 | 0.999 | 1.000 | 1.000 | 1.000 | 1.000 | 1.001 | 1.000 | 0.179 | 1.000 |
| hex: silesia/ooffice | 524290 | 15642.6 ± 0.2% | 1.002 | 0.178 | 1.001 | 1.002 | 1.001 | 1.001 | 1.001 | 1.002 | 1.002 | 0.178 | 1.002 |
| hex: silesia/osdb | 524290 | 15607.1 ± 0.2% | 1.001 | 0.179 | 1.001 | 1.001 | 1.002 | 1.001 | 1.001 | 1.002 | 1.002 | 0.178 | 1.002 |
| hex: silesia/reymont | 524290 | 15613.4 ± 0.1% | 1.002 | 0.178 | 1.002 | 1.001 | 1.002 | 1.002 | 1.004 | 1.002 | 1.003 | 0.178 | 1.001 |
| hex: silesia/samba | 524290 | 15654.0 ± 0.2% | 1.001 | 0.178 | 1.001 | 1.001 | 1.001 | 1.001 | 1.001 | 1.001 | 1.000 | 0.177 | 1.001 |
| hex: silesia/sao | 524290 | 15627.1 ± 0.2% | 1.003 | 0.178 | 1.004 | 1.002 | 1.001 | 1.003 | 1.003 | 1.003 | 1.003 | 0.178 | 1.003 |
| hex: silesia/webster | 524290 | 15619.2 ± 0.2% | 1.001 | 0.178 | 0.999 | 1.000 | 1.000 | 1.000 | 1.002 | 1.001 | 1.000 | 0.177 | 0.999 |
| hex: silesia/x-ray | 524290 | 15622.0 ± 0.1% | 1.002 | 0.178 | 1.001 | 1.001 | 1.001 | 1.000 | 1.000 | 1.000 | 1.001 | 0.178 | 1.000 |
| hex: silesia/xml | 524290 | 15658.4 ± 0.2% | 1.001 | 0.178 | 0.999 | 1.001 | 1.001 | 1.001 | 1.000 | 1.001 | 1.000 | 0.178 | 1.000 |
| hex: canterbury/alice29.txt | 304180 | 15661.6 ± 0.1% | 1.001 | 0.178 | 1.001 | 1.000 | 1.001 | 1.000 | 1.001 | 1.000 | 1.001 | 0.177 | 0.999 |
| hex: canterbury/asyoulik.txt | 250360 | 15704.0 ± 0.0% | 1.001 | 0.178 | 1.001 | 1.001 | 1.001 | 1.000 | 1.001 | 1.001 | 1.001 | 0.177 | 1.001 |
| hex: canterbury/cp.html | 49208 | 15620.8 ± 0.2% | 1.001 | 0.179 | 1.000 | 1.000 | 1.001 | 0.998 | 1.001 | 1.001 | 1.003 | 0.178 | 1.001 |
| hex: canterbury/fields.c | 22302 | 15441.1 ± 0.0% | 1.002 | 0.181 | 1.000 | 1.000 | 1.000 | 0.994 | 1.000 | 1.002 | 1.005 | 0.180 | 1.001 |
| hex: canterbury/grammar.lsp | 7444 | 14936.6 ± 0.1% | 1.003 | 0.186 | 1.001 | 1.000 | 1.000 | 0.983 | 1.000 | 1.004 | 1.015 | 0.184 | 1.003 |
| hex: canterbury/kennedy.xls | 524290 | 15645.6 ± 0.8% | 1.001 | 0.178 | 1.000 | 1.001 | 1.000 | 1.000 | 1.001 | 1.000 | 1.000 | 0.178 | 1.001 |
| hex: canterbury/lcet10.txt | 524290 | 15622.3 ± 0.3% | 1.002 | 0.178 | 1.001 | 1.000 | 1.002 | 0.999 | 1.002 | 1.001 | 1.002 | 0.177 | 1.001 |
| hex: canterbury/plrabn12.txt | 524290 | 15666.7 ± 0.2% | 0.999 | 0.177 | 1.001 | 1.001 | 1.000 | 1.001 | 1.001 | 1.000 | 1.000 | 0.177 | 1.001 |
| hex: canterbury/ptt5 | 524290 | 15655.5 ± 0.5% | 1.001 | 0.179 | 1.000 | 1.000 | 1.001 | 1.001 | 1.001 | 1.000 | 1.001 | 0.178 | 1.000 |
| hex: canterbury/sum | 76482 | 15643.8 ± 0.0% | 1.001 | 0.179 | 1.000 | 1.000 | 1.000 | 0.999 | 1.000 | 1.001 | 1.002 | 0.178 | 1.001 |
| hex: canterbury/xargs.1 | 8456 | 15002.1 ± 0.1% | 1.002 | 0.185 | 1.001 | 1.000 | 1.001 | 0.985 | 1.001 | 1.002 | 1.014 | 0.183 | 1.002 |
| hex: canterbury-large/E.coli | 524290 | 15675.6 ± 0.2% | 1.001 | 0.177 | 1.000 | 1.000 | 1.001 | 1.000 | 1.001 | 1.002 | 1.000 | 0.178 | 1.001 |
| hex: canterbury-large/bible.txt | 524290 | 15632.5 ± 0.3% | 1.000 | 0.178 | 1.002 | 1.001 | 1.001 | 1.001 | 1.002 | 1.002 | 1.001 | 0.177 | 1.002 |
| hex: canterbury-large/world192.txt | 524290 | 15631.3 ± 0.2% | 1.000 | 0.178 | 0.999 | 1.001 | 1.000 | 1.000 | 0.998 | 0.999 | 0.999 | 0.178 | 1.000 |
| hex: http/html-1kx1024 | 2099200 | 13667.5 ± 0.4% | 1.006 | 0.196 | 1.003 | 1.001 | 0.999 | 0.942 | 1.003 | 1.015 | 1.040 | 0.187 | 1.007 |
| hex: http/html-16kx64 | 2097280 | 15217.2 ± 0.5% | 1.002 | 0.181 | 0.998 | 1.001 | 1.003 | 0.992 | 0.998 | 1.005 | 1.011 | 0.180 | 1.001 |
| hex: http/html-1m | 524290 | 15667.5 ± 0.2% | 1.000 | 0.177 | 1.000 | 1.000 | 1.000 | 1.001 | 1.000 | 0.998 | 1.000 | 0.177 | 1.000 |
| hex: http/json-1kx1024 | 2099200 | 13647.9 ± 0.3% | 1.005 | 0.196 | 0.999 | 1.001 | 0.997 | 0.944 | 0.998 | 1.016 | 1.037 | 0.188 | 1.004 |
| hex: http/json-16kx64 | 2097280 | 15170.2 ± 0.4% | 1.004 | 0.182 | 1.004 | 1.003 | 1.005 | 0.989 | 0.999 | 1.012 | 1.013 | 0.181 | 1.005 |
| hex: http/json-1m | 524290 | 15665.3 ± 0.2% | 1.001 | 0.178 | 1.002 | 1.001 | 1.000 | 1.002 | 1.002 | 1.002 | 1.002 | 0.178 | 1.003 |
| hex: http/js-1kx1024 | 2099200 | 13678.7 ± 0.5% | 1.004 | 0.195 | 1.006 | 1.001 | 1.002 | 0.945 | 1.004 | 1.011 | 1.037 | 0.187 | 1.015 |
| hex: http/js-16kx64 | 2097280 | 15198.5 ± 0.2% | 1.002 | 0.181 | 1.003 | 1.001 | 0.999 | 0.993 | 1.001 | 1.003 | 1.010 | 0.181 | 1.001 |
| hex: http/js-1m | 524290 | 15639.0 ± 0.3% | 1.003 | 0.177 | 1.002 | 1.002 | 1.002 | 1.001 | 1.002 | 1.001 | 1.003 | 0.177 | 1.002 |
| hex: http/css-1kx1024 | 2099200 | 13609.0 ± 0.6% | 1.007 | 0.196 | 1.009 | 1.001 | 1.000 | 0.942 | 1.003 | 1.014 | 1.037 | 0.188 | 1.014 |
| hex: http/css-16kx64 | 2097280 | 15246.0 ± 0.3% | 1.001 | 0.181 | 0.997 | 1.000 | 1.000 | 0.990 | 0.999 | 1.003 | 1.007 | 0.180 | 1.004 |
| hex: http/css-1m | 524290 | 15588.7 ± 0.7% | 1.000 | 0.178 | 1.001 | 1.001 | 1.001 | 1.000 | 1.000 | 1.001 | 1.001 | 0.178 | 1.002 |
| hex: shuffled/dickens-1m | 524290 | 15645.3 ± 0.3% | 1.001 | 0.178 | 1.000 | 1.000 | 1.000 | 1.001 | 1.000 | 1.001 | 1.002 | 0.177 | 0.999 |

## Losses

Each workload where a claim's path ran slower than the path it replaces by more than the noise floor of decision 20.

- string: http/html-1m, decoding: J13 decoder escape blocks off runs at 1.055 of all on.
- string: http/js-1m, decoding: J12 decoder escape words off runs at 1.051 of all on.
- hex: http/html-1kx1024, decoding: J5 UTF-8 vectors off runs at 1.255 of all on.
- hex: http/html-1kx1024, decoding: J7 wide vectors off runs at 1.268 of all on.
- hex: http/html-1kx1024, decoding: J8 decoder fast path off runs at 1.267 of all on.
- hex: http/html-1kx1024, decoding: J12 decoder escape words off runs at 1.266 of all on.
- hex: http/json-1kx1024, decoding: J5 UTF-8 vectors off runs at 1.289 of all on.
- hex: http/json-1kx1024, decoding: J7 wide vectors off runs at 1.282 of all on.
- hex: http/json-1kx1024, decoding: J8 decoder fast path off runs at 1.276 of all on.
- hex: http/json-1kx1024, decoding: J12 decoder escape words off runs at 1.287 of all on.
- hex: http/js-1kx1024, decoding: J5 UTF-8 vectors off runs at 1.276 of all on.
- hex: http/js-1kx1024, decoding: J7 wide vectors off runs at 1.276 of all on.
- hex: http/js-1kx1024, decoding: J8 decoder fast path off runs at 1.274 of all on.
- hex: http/js-1kx1024, decoding: J12 decoder escape words off runs at 1.276 of all on.
- hex: http/css-1kx1024, decoding: J5 UTF-8 vectors off runs at 1.283 of all on.
- hex: http/css-1kx1024, decoding: J7 wide vectors off runs at 1.271 of all on.
- hex: http/css-1kx1024, decoding: J8 decoder fast path off runs at 1.276 of all on.
- hex: http/css-1kx1024, decoding: J12 decoder escape words off runs at 1.265 of all on.

## UTF-8 validation against simdutf

stdx's `is_utf8`, the check the loops apply to every string's octets, run alone over each string workload's octets at the width the host's features pick (16 lanes on aarch64, AVX2's 32 or AVX-512's 64 on x86-64, decision 39), beside simdutf 9.3.3's `validate_utf8` in the same run; on a host with AVX-512, again with AVX2 alone. Each ratio is stdx's throughput over the other's. simdutf picks its kernel at run time. Before timing, every copy of the check and simdutf judged 20000 seeded buffers and each workload, whole and changed, alike.

| Workload | Octets | stdx, MB/s | simdutf, MB/s | stdx / simdutf | stdx with AVX2 alone, MB/s | stdx / stdx with AVX2 alone |
|---|---|---|---|---|---|---|
| string: silesia/dickens | 166668 | 43292.5 ± 0.1% | 47427.1 ± 0.1% | 0.913 | — | — |
| string: silesia/nci | 1048576 | 35058.8 ± 1.0% | 37391.1 ± 1.2% | 0.938 | — | — |
| string: silesia/reymont | 1048576 | 34539.6 ± 0.5% | 36866.4 ± 2.0% | 0.937 | — | — |
| string: silesia/samba | 65546 | 43426.9 ± 0.0% | 48517.8 ± 0.0% | 0.895 | — | — |
| string: silesia/webster | 1048576 | 35130.3 ± 3.0% | 38675.0 ± 4.7% | 0.908 | — | — |
| string: silesia/xml | 1048576 | 31127.7 ± 1.7% | 32504.0 ± 1.8% | 0.958 | — | — |
| string: canterbury/alice29.txt | 152089 | 35902.5 ± 0.3% | 36546.3 ± 0.1% | 0.982 | — | — |
| string: canterbury/asyoulik.txt | 125179 | 43283.5 ± 0.1% | 47683.6 ± 0.1% | 0.908 | — | — |
| string: canterbury/lcet10.txt | 426754 | 33688.4 ± 0.5% | 34365.0 ± 0.3% | 0.980 | — | — |
| string: canterbury/plrabn12.txt | 481861 | 41289.0 ± 0.5% | 44880.2 ± 0.3% | 0.920 | — | — |
| string: canterbury-large/E.coli | 1048576 | 35393.2 ± 1.2% | 38072.6 ± 2.8% | 0.930 | — | — |
| string: canterbury-large/bible.txt | 1048576 | 32641.1 ± 3.0% | 33563.0 ± 3.3% | 0.973 | — | — |
| string: canterbury-large/world192.txt | 1048576 | 31583.3 ± 1.2% | 32700.1 ± 1.6% | 0.966 | — | — |
| string: http/html-1m | 1048576 | 34387.8 ± 3.3% | 37052.9 ± 2.6% | 0.928 | — | — |
| string: http/json-1m | 1048576 | 29684.5 ± 1.5% | 31437.8 ± 2.8% | 0.944 | — | — |
| string: http/js-1m | 1048576 | 35491.6 ± 0.7% | 38423.4 ± 1.3% | 0.924 | — | — |
| string: http/css-1m | 1048576 | 36203.0 ± 1.6% | 39465.4 ± 3.0% | 0.917 | — | — |
| string: dickens as Cyrillic and CJK | 1847045 | 5767.7 ± 0.4% | 5653.4 ± 0.1% | 1.020 | — | — |

## Losses to simdutf

- string: silesia/dickens: stdx runs at 0.913 of simdutf.
- string: silesia/nci: stdx runs at 0.938 of simdutf.
- string: silesia/reymont: stdx runs at 0.937 of simdutf.
- string: silesia/samba: stdx runs at 0.895 of simdutf.
- string: silesia/webster: stdx runs at 0.908 of simdutf.
- string: canterbury/asyoulik.txt: stdx runs at 0.908 of simdutf.
- string: canterbury/plrabn12.txt: stdx runs at 0.920 of simdutf.
- string: canterbury-large/E.coli: stdx runs at 0.930 of simdutf.
- string: http/html-1m: stdx runs at 0.928 of simdutf.
- string: http/json-1m: stdx runs at 0.944 of simdutf.
- string: http/js-1m: stdx runs at 0.924 of simdutf.
- string: http/css-1m: stdx runs at 0.917 of simdutf.

## UTF-8 validation by the buffer's offset from a 64-octet line

| Buffer | Octets | Offset | stdx, MB/s | simdutf, MB/s | stdx / simdutf | stdx with AVX2 alone, MB/s | stdx / stdx with AVX2 alone |
|---|---|---|---|---|---|---|---|
| string: canterbury-large/bible.txt | 1048576 | 0 | 37248.6 ± 1.3% | 40297.0 ± 0.7% | 0.924 | — | — |
| string: canterbury-large/bible.txt | 1048576 | 1 | 31346.9 ± 3.0% | 32414.6 ± 1.0% | 0.967 | — | — |
| string: canterbury-large/bible.txt | 1048576 | 8 | 34892.1 ± 2.0% | 37575.7 ± 1.6% | 0.929 | — | — |
| string: canterbury-large/bible.txt | 1048576 | 16 | 35701.2 ± 1.5% | 38720.1 ± 1.4% | 0.922 | — | — |
| string: canterbury-large/bible.txt | 1048576 | 32 | 35656.4 ± 1.1% | 38573.1 ± 0.8% | 0.924 | — | — |
| string: canterbury-large/bible.txt | 1048576 | 48 | 35628.4 ± 1.1% | 38485.8 ± 1.4% | 0.926 | — | — |
| string: dickens as Cyrillic and CJK | 1048576 | 0 | 5753.2 ± 0.2% | 5639.5 ± 0.2% | 1.020 | — | — |
| string: dickens as Cyrillic and CJK | 1048576 | 1 | 5746.2 ± 0.1% | 5642.4 ± 0.1% | 1.018 | — | — |
| string: dickens as Cyrillic and CJK | 1048576 | 8 | 5755.0 ± 0.1% | 5639.8 ± 0.2% | 1.020 | — | — |
| string: dickens as Cyrillic and CJK | 1048576 | 16 | 5757.7 ± 0.1% | 5639.4 ± 0.1% | 1.021 | — | — |
| string: dickens as Cyrillic and CJK | 1048576 | 32 | 5753.3 ± 0.2% | 5641.5 ± 0.3% | 1.020 | — | — |
| string: dickens as Cyrillic and CJK | 1048576 | 48 | 5754.5 ± 0.2% | 5643.1 ± 0.2% | 1.020 | — | — |

## Against the baselines

stdx with every claim on, timed beside simdjson 5.1.1, yyjson 0.13.0, Zig 0.16.0's std.json, serde_json 1.0.154 and Go's encoding/json/jsontext in the same run. Each ratio is stdx's throughput over the baseline's; below 1, the baseline is faster. stdx is built for the architecture's baseline CPU in ReleaseSafe. Each baseline is built for the same CPU, the C, C++ and Zig ones in ReleaseFast (decision 75), and simdjson picks its kernel at run time. Decoding visits every value; encoding writes each text from its tokens.

## Decoding against the baselines

Octets are the text's. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1128.4 ± 0.8% | 927.6 ± 0.3% | 1016.2 ± 0.4% | 301.5 ± 1.1% | 665.8 ± 0.1% | 309.9 ± 1.9% | 1.217 | 1.110 | 3.742 | 1.695 | 3.641 |
| qlog records, JSON text sequence | 1467503 | 844.5 ± 17.1% | 813.2 ± 0.2% | 786.6 ± 1.5% | 243.7 ± 0.6% | 702.3 ± 0.8% | 250.5 ± 0.8% | 1.038 | 1.074 | 3.465 | 1.202 | 3.371 |
| string: silesia/dickens | 172528 | 5051.0 ± 0.3% | 1877.6 ± 0.1% | 2648.4 ± 0.3% | 361.4 ± 1.6% | 2868.4 ± 0.3% | 554.6 ± 1.6% | 2.690 | 1.907 | 13.978 | 1.761 | 9.108 |
| string: silesia/nci | 1075110 | 4289.3 ± 0.4% | 2241.0 ± 0.5% | 2999.7 ± 0.8% | 544.2 ± 1.7% | 2994.0 ± 1.4% | 587.8 ± 2.3% | 1.914 | 1.430 | 7.881 | 1.433 | 7.298 |
| string: silesia/reymont | 1075159 | 2938.1 ± 1.7% | 1822.5 ± 2.5% | 2064.4 ± 0.4% | 375.4 ± 1.3% | 2142.2 ± 0.4% | 538.7 ± 0.6% | 1.612 | 1.423 | 7.826 | 1.372 | 5.454 |
| string: silesia/samba | 97582 | 3489.1 ± 0.7% | 2025.3 ± 0.2% | 2611.9 ± 0.2% | 324.9 ± 0.6% | 1505.2 ± 0.2% | 429.0 ± 2.1% | 1.723 | 1.336 | 10.737 | 2.318 | 8.133 |
| string: silesia/webster | 1098490 | 3636.7 ± 0.9% | 1515.9 ± 0.3% | 2016.9 ± 0.5% | 359.5 ± 0.5% | 2172.7 ± 0.7% | 497.7 ± 2.4% | 2.399 | 1.803 | 10.117 | 1.674 | 7.306 |
| string: silesia/xml | 1090118 | 4788.3 ± 0.5% | 2355.2 ± 0.6% | 2528.2 ± 0.4% | 452.7 ± 1.1% | 2801.1 ± 1.4% | 565.4 ± 1.5% | 2.033 | 1.894 | 10.578 | 1.709 | 8.469 |
| string: canterbury/alice29.txt | 159425 | 4303.7 ± 1.0% | 1599.3 ± 0.3% | 2463.5 ± 0.4% | 341.8 ± 0.4% | 2512.8 ± 0.6% | 505.9 ± 1.4% | 2.691 | 1.747 | 12.592 | 1.713 | 8.507 |
| string: canterbury/asyoulik.txt | 132198 | 3457.7 ± 1.5% | 1460.4 ± 0.2% | 2246.7 ± 0.6% | 334.8 ± 0.9% | 2083.7 ± 0.2% | 462.3 ± 1.9% | 2.368 | 1.539 | 10.328 | 1.659 | 7.480 |
| string: canterbury/lcet10.txt | 441884 | 5089.7 ± 0.3% | 1854.3 ± 0.2% | 2334.7 ± 0.1% | 390.0 ± 0.5% | 2842.7 ± 0.6% | 537.5 ± 1.3% | 2.745 | 2.180 | 13.051 | 1.790 | 9.469 |
| string: canterbury/plrabn12.txt | 503330 | 4124.9 ± 0.8% | 1738.7 ± 0.2% | 2057.9 ± 0.4% | 360.3 ± 0.7% | 2486.2 ± 0.6% | 502.2 ± 1.8% | 2.372 | 2.004 | 11.448 | 1.659 | 8.214 |
| string: canterbury-large/E.coli | 1048578 | 19216.2 ± 0.6% | 3610.5 ± 0.4% | 3257.6 ± 0.3% | 927.3 ± 0.9% | 5938.8 ± 0.9% | 767.5 ± 0.6% | 5.322 | 5.899 | 20.723 | 3.236 | 25.038 |
| string: canterbury-large/bible.txt | 1055886 | 6670.3 ± 0.8% | 2942.5 ± 0.6% | 2842.7 ± 1.0% | 418.7 ± 1.0% | 3732.7 ± 2.5% | 619.0 ± 1.0% | 2.267 | 2.346 | 15.930 | 1.787 | 10.776 |
| string: canterbury-large/world192.txt | 1103121 | 3386.2 ± 0.7% | 1479.9 ± 1.1% | 2014.2 ± 0.6% | 352.9 ± 0.2% | 2125.3 ± 1.1% | 502.2 ± 1.5% | 2.288 | 1.681 | 9.596 | 1.593 | 6.743 |
| string: http/html-1m | 1058582 | 6044.3 ± 0.7% | 2743.0 ± 0.6% | 2703.6 ± 0.5% | 441.9 ± 0.4% | 3475.8 ± 0.3% | 597.7 ± 1.9% | 2.204 | 2.236 | 13.679 | 1.739 | 10.112 |
| string: http/json-1m | 1190272 | 2546.5 ± 0.5% | 877.2 ± 0.2% | 2250.2 ± 0.2% | 390.0 ± 0.9% | 1031.7 ± 3.3% | 442.5 ± 0.8% | 2.903 | 1.132 | 6.529 | 2.468 | 5.755 |
| string: http/js-1m | 1144362 | 2289.2 ± 0.6% | 1028.2 ± 0.2% | 1637.6 ± 0.6% | 321.0 ± 0.4% | 1514.5 ± 3.6% | 419.2 ± 0.5% | 2.226 | 1.398 | 7.131 | 1.512 | 5.461 |
| string: http/css-1m | 1097820 | 2635.6 ± 0.4% | 1679.0 ± 0.4% | 2230.0 ± 0.5% | 406.6 ± 1.1% | 1901.7 ± 0.5% | 489.9 ± 0.7% | 1.570 | 1.182 | 6.482 | 1.386 | 5.380 |
| string: dickens as Cyrillic and CJK | 1883069 | 3073.8 ± 0.4% | 1686.3 ± 0.6% | 894.3 ± 0.4% | 351.3 ± 0.1% | 666.9 ± 0.6% | 158.5 ± 3.0% | 1.823 | 3.437 | 8.751 | 4.609 | 19.397 |
| string: dickens as Cyrillic and CJK, as \u escapes | 5075485 | 1327.8 ± 1.9% | 981.6 ± 0.1% | 1208.8 ± 0.6% | 214.4 ± 0.2% | 471.8 ± 0.8% | 256.4 ± 3.1% | 1.353 | 1.098 | 6.194 | 2.815 | 5.178 |
| hex: silesia/dickens | 524290 | 18837.2 ± 0.5% | 3614.3 ± 0.7% | 3282.7 ± 0.2% | 510.4 ± 1.0% | 6034.0 ± 1.5% | 782.4 ± 2.0% | 5.212 | 5.738 | 36.904 | 3.122 | 24.077 |
| hex: silesia/mozilla | 524290 | 18665.5 ± 1.7% | 3613.0 ± 0.1% | 3294.4 ± 0.1% | 447.9 ± 2.8% | 6079.1 ± 0.7% | 783.5 ± 0.2% | 5.166 | 5.666 | 41.676 | 3.070 | 23.822 |
| hex: silesia/mr | 524290 | 18420.2 ± 0.5% | 3614.7 ± 0.2% | 3285.9 ± 0.3% | 567.1 ± 3.2% | 5971.0 ± 0.3% | 784.4 ± 0.4% | 5.096 | 5.606 | 32.482 | 3.085 | 23.483 |
| hex: silesia/nci | 524290 | 18848.8 ± 0.8% | 3614.5 ± 0.2% | 3292.2 ± 0.2% | 618.6 ± 2.4% | 6032.6 ± 1.2% | 783.0 ± 0.6% | 5.215 | 5.725 | 30.469 | 3.124 | 24.073 |
| hex: silesia/ooffice | 524290 | 18708.3 ± 0.6% | 3614.0 ± 0.2% | 3290.8 ± 0.6% | 399.3 ± 0.8% | 6066.0 ± 1.6% | 781.2 ± 0.6% | 5.177 | 5.685 | 46.849 | 3.084 | 23.947 |
| hex: silesia/osdb | 524290 | 18465.7 ± 0.7% | 3615.2 ± 0.4% | 3298.8 ± 0.7% | 481.1 ± 0.4% | 6056.3 ± 1.4% | 783.5 ± 0.4% | 5.108 | 5.598 | 38.380 | 3.049 | 23.567 |
| hex: silesia/reymont | 524290 | 18751.7 ± 0.3% | 3614.1 ± 0.1% | 3278.3 ± 0.2% | 516.6 ± 0.3% | 5994.1 ± 1.5% | 781.3 ± 0.7% | 5.188 | 5.720 | 36.296 | 3.128 | 23.999 |
| hex: silesia/samba | 524290 | 18050.4 ± 0.9% | 3613.3 ± 0.5% | 3289.1 ± 0.3% | 408.9 ± 1.3% | 6059.4 ± 0.4% | 782.3 ± 0.5% | 4.996 | 5.488 | 44.143 | 2.979 | 23.072 |
| hex: silesia/sao | 524290 | 18623.0 ± 0.8% | 3614.6 ± 0.1% | 3290.4 ± 0.3% | 342.0 ± 1.2% | 6092.2 ± 1.5% | 781.8 ± 0.7% | 5.152 | 5.660 | 54.446 | 3.057 | 23.821 |
| hex: silesia/webster | 524290 | 18849.1 ± 1.0% | 3617.0 ± 0.4% | 3294.7 ± 0.4% | 465.0 ± 0.4% | 6068.1 ± 0.6% | 783.5 ± 0.4% | 5.211 | 5.721 | 40.537 | 3.106 | 24.057 |
| hex: silesia/x-ray | 524290 | 18283.1 ± 1.5% | 3616.7 ± 0.2% | 3292.3 ± 0.2% | 478.9 ± 0.4% | 6035.4 ± 1.7% | 782.5 ± 0.4% | 5.055 | 5.553 | 38.177 | 3.029 | 23.364 |
| hex: silesia/xml | 524290 | 18703.3 ± 1.4% | 3613.9 ± 0.3% | 3291.6 ± 0.2% | 522.5 ± 0.8% | 5991.7 ± 3.5% | 782.6 ± 0.9% | 5.175 | 5.682 | 35.796 | 3.122 | 23.898 |
| hex: canterbury/alice29.txt | 304180 | 19327.7 ± 0.4% | 3629.1 ± 0.1% | 3358.8 ± 0.1% | 511.2 ± 0.3% | 6072.7 ± 2.1% | 783.1 ± 0.4% | 5.326 | 5.754 | 37.805 | 3.183 | 24.682 |
| hex: canterbury/asyoulik.txt | 250360 | 19544.5 ± 0.2% | 3635.3 ± 0.1% | 3366.4 ± 0.3% | 502.1 ± 0.3% | 6071.5 ± 1.3% | 783.1 ± 0.2% | 5.376 | 5.806 | 38.922 | 3.219 | 24.959 |
| hex: canterbury/cp.html | 49208 | 19309.9 ± 0.1% | 3640.2 ± 0.0% | 3280.6 ± 0.4% | 473.5 ± 0.7% | 6264.1 ± 0.5% | 769.4 ± 1.0% | 5.305 | 5.886 | 40.783 | 3.083 | 25.096 |
| hex: canterbury/fields.c | 22302 | 18879.2 ± 0.5% | 3630.1 ± 0.0% | 3355.9 ± 0.1% | 497.2 ± 0.5% | 6248.4 ± 0.2% | 751.6 ± 1.7% | 5.201 | 5.626 | 37.970 | 3.021 | 25.119 |
| hex: canterbury/grammar.lsp | 7444 | 17324.1 ± 2.2% | 3601.8 ± 0.0% | 3361.0 ± 0.5% | 532.0 ± 3.6% | 6173.8 ± 0.3% | 724.9 ± 1.0% | 4.810 | 5.154 | 32.561 | 2.806 | 23.897 |
| hex: canterbury/kennedy.xls | 524290 | 18737.7 ± 0.9% | 3610.4 ± 0.3% | 3301.1 ± 0.3% | 653.6 ± 2.7% | 6058.3 ± 0.9% | 776.3 ± 3.3% | 5.190 | 5.676 | 28.669 | 3.093 | 24.138 |
| hex: canterbury/lcet10.txt | 524290 | 18771.9 ± 0.9% | 3604.9 ± 0.2% | 3298.8 ± 0.1% | 507.1 ± 1.0% | 5953.4 ± 0.3% | 782.9 ± 0.7% | 5.207 | 5.690 | 37.015 | 3.153 | 23.976 |
| hex: canterbury/plrabn12.txt | 524290 | 18527.9 ± 1.8% | 3608.1 ± 0.8% | 3287.3 ± 0.4% | 505.6 ± 3.5% | 6078.3 ± 1.1% | 782.9 ± 0.5% | 5.135 | 5.636 | 36.643 | 3.048 | 23.665 |
| hex: canterbury/ptt5 | 524290 | 18421.2 ± 0.4% | 3608.3 ± 0.4% | 3286.9 ± 0.2% | 560.8 ± 0.7% | 6031.4 ± 1.0% | 784.4 ± 0.3% | 5.105 | 5.604 | 32.850 | 3.054 | 23.485 |
| hex: canterbury/sum | 76482 | 19290.4 ± 0.1% | 3634.3 ± 0.0% | 3356.3 ± 0.3% | 508.8 ± 1.1% | 6169.2 ± 0.3% | 773.3 ± 1.0% | 5.308 | 5.747 | 37.912 | 3.127 | 24.947 |
| hex: canterbury/xargs.1 | 8456 | 17837.8 ± 0.2% | 3602.9 ± 0.1% | 3360.6 ± 0.3% | 487.7 ± 2.0% | 6150.7 ± 0.4% | 752.3 ± 1.7% | 4.951 | 5.308 | 36.577 | 2.900 | 23.710 |
| hex: canterbury-large/E.coli | 524290 | 18581.4 ± 2.3% | 3613.1 ± 0.2% | 3288.2 ± 0.4% | 689.3 ± 0.3% | 6057.0 ± 1.6% | 766.2 ± 5.9% | 5.143 | 5.651 | 26.956 | 3.068 | 24.252 |
| hex: canterbury-large/bible.txt | 524290 | 18885.9 ± 0.7% | 3622.9 ± 0.2% | 3294.7 ± 0.3% | 519.5 ± 0.7% | 6049.8 ± 1.6% | 784.0 ± 0.3% | 5.213 | 5.732 | 36.351 | 3.122 | 24.090 |
| hex: canterbury-large/world192.txt | 524290 | 18401.5 ± 0.5% | 3624.1 ± 0.3% | 3292.9 ± 0.3% | 495.5 ± 2.0% | 6094.5 ± 0.8% | 784.6 ± 0.5% | 5.077 | 5.588 | 37.140 | 3.019 | 23.455 |
| hex: http/html-1kx1024 | 2099200 | 9384.8 ± 11.9% | 3466.4 ± 0.1% | 2857.1 ± 0.4% | 474.0 ± 0.4% | 5085.3 ± 0.7% | 647.1 ± 3.6% | 2.707 | 3.285 | 19.800 | 1.845 | 14.502 |
| hex: http/html-16kx64 | 2097280 | 17807.2 ± 1.3% | 3612.7 ± 0.2% | 3265.3 ± 0.2% | 478.7 ± 2.2% | 5988.0 ± 0.4% | 759.5 ± 1.1% | 4.929 | 5.453 | 37.201 | 2.974 | 23.447 |
| hex: http/html-1m | 524290 | 18213.7 ± 1.6% | 3613.1 ± 0.1% | 3293.9 ± 0.4% | 493.8 ± 0.9% | 6066.4 ± 2.4% | 781.4 ± 1.2% | 5.041 | 5.530 | 36.882 | 3.002 | 23.310 |
| hex: http/json-1kx1024 | 2099200 | 9248.4 ± 17.5% | 3461.9 ± 0.3% | 2855.8 ± 0.3% | 575.0 ± 1.2% | 5087.8 ± 1.5% | 641.8 ± 2.4% | 2.671 | 3.238 | 16.083 | 1.818 | 14.411 |
| hex: http/json-16kx64 | 2097280 | 18028.2 ± 1.1% | 3611.3 ± 0.2% | 3279.0 ± 0.2% | 572.9 ± 0.7% | 5991.8 ± 0.6% | 758.4 ± 1.4% | 4.992 | 5.498 | 31.469 | 3.009 | 23.770 |
| hex: http/json-1m | 524290 | 18418.2 ± 1.7% | 3615.3 ± 0.3% | 3282.1 ± 0.4% | 584.3 ± 2.5% | 6077.2 ± 2.1% | 779.5 ± 1.5% | 5.095 | 5.612 | 31.520 | 3.031 | 23.627 |
| hex: http/js-1kx1024 | 2099200 | 9277.4 ± 18.1% | 3461.8 ± 0.2% | 2857.3 ± 0.5% | 479.4 ± 1.1% | 5072.1 ± 0.8% | 642.4 ± 1.2% | 2.680 | 3.247 | 19.352 | 1.829 | 14.441 |
| hex: http/js-16kx64 | 2097280 | 17924.8 ± 1.2% | 3612.3 ± 0.1% | 3264.4 ± 0.2% | 479.4 ± 0.6% | 6008.4 ± 0.6% | 756.3 ± 1.5% | 4.962 | 5.491 | 37.394 | 2.983 | 23.700 |
| hex: http/js-1m | 524290 | 18871.6 ± 0.6% | 3610.0 ± 0.4% | 3299.9 ± 0.2% | 498.2 ± 1.9% | 6014.7 ± 1.4% | 776.8 ± 2.1% | 5.228 | 5.719 | 37.883 | 3.138 | 24.295 |
| hex: http/css-1kx1024 | 2099200 | 9304.3 ± 11.6% | 3461.2 ± 0.6% | 2855.2 ± 2.7% | 488.6 ± 0.4% | 5063.7 ± 0.7% | 648.1 ± 3.7% | 2.688 | 3.259 | 19.043 | 1.837 | 14.356 |
| hex: http/css-16kx64 | 2097280 | 17988.8 ± 1.2% | 3614.2 ± 0.1% | 3261.3 ± 0.4% | 497.7 ± 1.0% | 5997.6 ± 0.7% | 758.2 ± 2.2% | 4.977 | 5.516 | 36.144 | 2.999 | 23.725 |
| hex: http/css-1m | 524290 | 18764.7 ± 1.8% | 3612.0 ± 0.1% | 3294.9 ± 0.2% | 496.0 ± 1.0% | 6070.6 ± 1.3% | 781.1 ± 0.8% | 5.195 | 5.695 | 37.834 | 3.091 | 24.025 |
| hex: shuffled/dickens-1m | 524290 | 18097.3 ± 0.5% | 3605.9 ± 0.3% | 3292.2 ± 0.3% | 511.2 ± 1.2% | 6021.0 ± 1.1% | 783.4 ± 0.4% | 5.019 | 5.497 | 35.403 | 3.006 | 23.101 |

## Encoding against the baselines

Octets are the ones stdx writes. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1483.3 ± 0.8% | 1255.8 ± 0.1% | 1041.3 ± 0.2% | 409.6 ± 0.4% | 448.8 ± 0.2% | 415.5 ± 0.2% | 1.181 | 1.425 | 3.621 | 3.305 | 3.570 |
| qlog records, JSON text sequence | 1467503 | 1271.9 ± 0.9% | 1065.3 ± 0.4% | 786.7 ± 0.6% | 379.2 ± 0.6% | 479.2 ± 0.7% | 279.6 ± 0.8% | 1.194 | 1.617 | 3.354 | 2.654 | 4.549 |
| string: silesia/dickens | 172528 | 6896.8 ± 0.4% | 2810.8 ± 0.7% | 2932.5 ± 1.2% | 430.6 ± 0.6% | 1597.8 ± 0.3% | 1008.4 ± 0.4% | 2.454 | 2.352 | 16.017 | 4.316 | 6.839 |
| string: silesia/nci | 1075110 | 7298.1 ± 0.2% | 3396.7 ± 0.8% | 3100.7 ± 0.4% | 812.2 ± 0.9% | 1861.5 ± 0.2% | 1108.1 ± 0.1% | 2.149 | 2.354 | 8.985 | 3.921 | 6.586 |
| string: silesia/reymont | 1075159 | 3339.4 ± 1.1% | 1990.9 ± 0.5% | 2060.3 ± 0.9% | 447.8 ± 0.9% | 1506.4 ± 1.2% | 950.2 ± 0.6% | 1.677 | 1.621 | 7.457 | 2.217 | 3.514 |
| string: silesia/samba | 97582 | 4197.3 ± 0.5% | 2116.3 ± 0.2% | 3446.5 ± 0.3% | 354.2 ± 0.7% | 1486.3 ± 0.3% | 1051.9 ± 0.4% | 1.983 | 1.218 | 11.850 | 2.824 | 3.990 |
| string: silesia/webster | 1098490 | 4053.9 ± 0.4% | 1872.3 ± 0.4% | 2061.1 ± 0.6% | 442.1 ± 0.5% | 1399.5 ± 0.2% | 646.0 ± 0.9% | 2.165 | 1.967 | 9.169 | 2.897 | 6.275 |
| string: silesia/xml | 1090118 | 6115.7 ± 0.8% | 2860.8 ± 1.0% | 2648.1 ± 0.4% | 610.6 ± 0.7% | 1763.4 ± 0.3% | 922.7 ± 0.1% | 2.138 | 2.309 | 10.015 | 3.468 | 6.628 |
| string: canterbury/alice29.txt | 159425 | 6391.3 ± 0.7% | 2197.4 ± 0.5% | 2756.0 ± 0.5% | 407.6 ± 1.0% | 1471.6 ± 0.3% | 953.4 ± 0.1% | 2.909 | 2.319 | 15.680 | 4.343 | 6.703 |
| string: canterbury/asyoulik.txt | 132198 | 5598.8 ± 1.5% | 1713.8 ± 0.7% | 2365.1 ± 1.5% | 402.1 ± 0.6% | 1334.9 ± 0.6% | 885.0 ± 0.3% | 3.267 | 2.367 | 13.923 | 4.194 | 6.326 |
| string: canterbury/lcet10.txt | 441884 | 6228.9 ± 0.6% | 2561.4 ± 0.6% | 2479.0 ± 2.8% | 469.2 ± 0.4% | 1553.6 ± 0.3% | 986.8 ± 0.6% | 2.432 | 2.513 | 13.276 | 4.009 | 6.312 |
| string: canterbury/plrabn12.txt | 503330 | 5698.8 ± 0.3% | 2056.3 ± 0.3% | 2072.2 ± 0.5% | 423.2 ± 0.5% | 1391.0 ± 0.3% | 931.0 ± 0.6% | 2.771 | 2.750 | 13.465 | 4.097 | 6.121 |
| string: canterbury-large/E.coli | 1048578 | 19173.4 ± 0.7% | 9631.3 ± 1.6% | 3788.6 ± 0.5% | 1474.3 ± 0.7% | 2366.9 ± 0.2% | 1192.5 ± 0.3% | 1.991 | 5.061 | 13.005 | 8.101 | 16.078 |
| string: canterbury-large/bible.txt | 1055886 | 6792.6 ± 0.2% | 4147.7 ± 1.3% | 3015.5 ± 1.6% | 503.1 ± 1.1% | 1988.7 ± 0.1% | 1121.5 ± 0.3% | 1.638 | 2.253 | 13.503 | 3.416 | 6.057 |
| string: canterbury-large/world192.txt | 1103121 | 4010.5 ± 0.4% | 1651.6 ± 0.4% | 2002.7 ± 0.8% | 449.0 ± 0.5% | 1371.7 ± 0.1% | 908.9 ± 0.3% | 2.428 | 2.003 | 8.933 | 2.924 | 4.413 |
| string: http/html-1m | 1058582 | 6732.8 ± 1.3% | 3951.6 ± 1.6% | 3044.1 ± 0.7% | 500.0 ± 0.4% | 1930.9 ± 0.4% | 804.5 ± 1.0% | 1.704 | 2.212 | 13.467 | 3.487 | 8.369 |
| string: http/json-1m | 1190272 | 3157.4 ± 0.3% | 1353.3 ± 0.2% | 1555.2 ± 0.7% | 443.3 ± 0.5% | 1071.7 ± 0.2% | 765.5 ± 0.3% | 2.333 | 2.030 | 7.123 | 2.946 | 4.125 |
| string: http/js-1m | 1144362 | 2752.1 ± 0.5% | 1174.5 ± 0.3% | 1625.5 ± 0.4% | 369.0 ± 0.4% | 1110.1 ± 0.2% | 757.7 ± 0.2% | 2.343 | 1.693 | 7.459 | 2.479 | 3.632 |
| string: http/css-1m | 1097820 | 3995.8 ± 0.9% | 1488.8 ± 1.4% | 2155.7 ± 0.5% | 493.4 ± 0.6% | 1378.5 ± 0.3% | 895.1 ± 0.2% | 2.684 | 1.854 | 8.098 | 2.899 | 4.464 |
| string: dickens as Cyrillic and CJK | 1883069 | 3067.4 ± 0.3% | 2336.1 ± 0.6% | 521.0 ± 0.5% | 307.1 ± 0.8% | 565.1 ± 0.6% | 336.2 ± 0.3% | 1.313 | 5.887 | 9.990 | 5.428 | 9.123 |
| hex: silesia/dickens | 524290 | 15645.4 ± 0.1% | 1462.9 ± 0.2% | 1083.2 ± 0.3% | 500.2 ± 1.0% | 989.8 ± 0.3% | 733.4 ± 0.3% | 10.695 | 14.444 | 31.278 | 15.806 | 21.333 |
| hex: silesia/mozilla | 524290 | 15632.5 ± 0.2% | 1470.5 ± 0.4% | 1088.3 ± 0.1% | 442.7 ± 0.4% | 993.4 ± 0.5% | 734.3 ± 0.5% | 10.631 | 14.364 | 35.311 | 15.736 | 21.288 |
| hex: silesia/mr | 524290 | 15618.7 ± 0.2% | 1481.6 ± 0.2% | 1091.4 ± 0.2% | 553.3 ± 3.0% | 996.5 ± 0.4% | 734.7 ± 0.4% | 10.542 | 14.311 | 28.227 | 15.673 | 21.258 |
| hex: silesia/nci | 524290 | 15580.0 ± 0.1% | 1474.1 ± 0.5% | 1092.1 ± 0.2% | 633.3 ± 1.4% | 993.4 ± 0.5% | 733.7 ± 0.2% | 10.569 | 14.266 | 24.601 | 15.683 | 21.234 |
| hex: silesia/ooffice | 524290 | 15642.6 ± 0.2% | 1466.8 ± 0.2% | 1085.4 ± 0.6% | 388.5 ± 0.3% | 991.9 ± 0.5% | 735.1 ± 0.7% | 10.664 | 14.411 | 40.260 | 15.770 | 21.279 |
| hex: silesia/osdb | 524290 | 15607.1 ± 0.2% | 1466.0 ± 0.1% | 1087.5 ± 0.1% | 468.0 ± 3.8% | 990.7 ± 0.3% | 735.1 ± 0.3% | 10.646 | 14.351 | 33.350 | 15.754 | 21.232 |
| hex: silesia/reymont | 524290 | 15613.4 ± 0.1% | 1464.2 ± 0.5% | 1084.8 ± 0.4% | 514.3 ± 1.2% | 990.5 ± 0.4% | 734.4 ± 0.7% | 10.664 | 14.393 | 30.356 | 15.762 | 21.260 |
| hex: silesia/samba | 524290 | 15654.0 ± 0.2% | 1466.8 ± 0.4% | 1087.7 ± 0.2% | 402.9 ± 0.4% | 990.8 ± 0.4% | 735.1 ± 0.2% | 10.672 | 14.391 | 38.857 | 15.800 | 21.296 |
| hex: silesia/sao | 524290 | 15627.1 ± 0.2% | 1465.6 ± 0.1% | 1084.6 ± 0.5% | 332.3 ± 0.3% | 992.1 ± 0.4% | 734.8 ± 0.3% | 10.663 | 14.409 | 47.031 | 15.751 | 21.269 |
| hex: silesia/webster | 524290 | 15619.2 ± 0.2% | 1463.6 ± 0.2% | 1085.5 ± 0.3% | 475.1 ± 1.1% | 992.5 ± 0.3% | 734.8 ± 0.7% | 10.672 | 14.389 | 32.879 | 15.737 | 21.255 |
| hex: silesia/x-ray | 524290 | 15622.0 ± 0.1% | 1475.8 ± 0.2% | 1089.8 ± 0.6% | 445.0 ± 0.8% | 995.3 ± 0.4% | 734.2 ± 0.5% | 10.586 | 14.335 | 35.103 | 15.696 | 21.279 |
| hex: silesia/xml | 524290 | 15658.4 ± 0.2% | 1469.9 ± 0.2% | 1088.7 ± 0.3% | 607.1 ± 0.6% | 992.6 ± 0.5% | 734.6 ± 0.2% | 10.653 | 14.383 | 25.792 | 15.775 | 21.317 |
| hex: canterbury/alice29.txt | 304180 | 15661.6 ± 0.1% | 1469.7 ± 0.6% | 1089.4 ± 0.5% | 502.5 ± 1.8% | 993.4 ± 0.6% | 734.8 ± 0.2% | 10.656 | 14.376 | 31.170 | 15.766 | 21.314 |
| hex: canterbury/asyoulik.txt | 250360 | 15704.0 ± 0.0% | 1477.8 ± 0.5% | 1090.8 ± 0.4% | 498.4 ± 1.2% | 992.9 ± 0.1% | 741.0 ± 0.2% | 10.627 | 14.397 | 31.508 | 15.816 | 21.194 |
| hex: canterbury/cp.html | 49208 | 15620.8 ± 0.2% | 1473.1 ± 0.6% | 1098.9 ± 0.3% | 518.8 ± 2.3% | 1003.1 ± 0.5% | 743.7 ± 0.2% | 10.604 | 14.215 | 30.112 | 15.573 | 21.004 |
| hex: canterbury/fields.c | 22302 | 15441.1 ± 0.0% | 1426.7 ± 1.0% | 1078.8 ± 0.4% | 631.0 ± 5.8% | 991.7 ± 0.3% | 737.0 ± 0.3% | 10.823 | 14.313 | 24.469 | 15.570 | 20.952 |
| hex: canterbury/grammar.lsp | 7444 | 14936.6 ± 0.1% | 1505.7 ± 0.3% | 1095.2 ± 0.3% | 663.5 ± 4.7% | 998.1 ± 0.4% | 726.7 ± 0.2% | 9.920 | 13.638 | 22.513 | 14.964 | 20.554 |
| hex: canterbury/kennedy.xls | 524290 | 15645.6 ± 0.8% | 1476.0 ± 0.3% | 1089.4 ± 0.2% | 662.8 ± 2.1% | 991.9 ± 0.5% | 735.2 ± 0.4% | 10.600 | 14.361 | 23.604 | 15.773 | 21.279 |
| hex: canterbury/lcet10.txt | 524290 | 15622.3 ± 0.3% | 1465.6 ± 0.1% | 1084.2 ± 0.2% | 503.0 ± 1.0% | 991.6 ± 0.3% | 734.3 ± 0.4% | 10.659 | 14.408 | 31.057 | 15.754 | 21.274 |
| hex: canterbury/plrabn12.txt | 524290 | 15666.7 ± 0.2% | 1464.8 ± 0.6% | 1082.3 ± 0.2% | 495.6 ± 1.1% | 992.1 ± 0.8% | 734.2 ± 0.5% | 10.696 | 14.476 | 31.612 | 15.791 | 21.337 |
| hex: canterbury/ptt5 | 524290 | 15655.5 ± 0.5% | 1481.7 ± 0.9% | 1088.1 ± 0.5% | 553.3 ± 0.2% | 998.4 ± 0.5% | 734.8 ± 0.6% | 10.566 | 14.387 | 28.292 | 15.681 | 21.306 |
| hex: canterbury/sum | 76482 | 15643.8 ± 0.0% | 1495.1 ± 0.1% | 1105.0 ± 0.2% | 591.4 ± 2.8% | 999.1 ± 0.1% | 744.4 ± 0.1% | 10.463 | 14.158 | 26.453 | 15.658 | 21.015 |
| hex: canterbury/xargs.1 | 8456 | 15002.1 ± 0.1% | 1492.8 ± 0.5% | 1095.4 ± 0.7% | 637.0 ± 6.8% | 1004.8 ± 0.1% | 729.1 ± 0.1% | 10.049 | 13.696 | 23.552 | 14.931 | 20.575 |
| hex: canterbury-large/E.coli | 524290 | 15675.6 ± 0.2% | 1473.5 ± 1.0% | 1089.1 ± 0.7% | 673.6 ± 0.2% | 994.2 ± 0.6% | 733.6 ± 0.3% | 10.639 | 14.393 | 23.272 | 15.767 | 21.368 |
| hex: canterbury-large/bible.txt | 524290 | 15632.5 ± 0.3% | 1467.7 ± 0.4% | 1083.2 ± 0.2% | 515.6 ± 0.7% | 991.6 ± 0.8% | 734.5 ± 0.5% | 10.651 | 14.432 | 30.317 | 15.765 | 21.284 |
| hex: canterbury-large/world192.txt | 524290 | 15631.3 ± 0.2% | 1465.2 ± 0.2% | 1086.8 ± 0.6% | 502.4 ± 0.3% | 988.0 ± 0.7% | 733.3 ± 0.6% | 10.668 | 14.383 | 31.114 | 15.821 | 21.315 |
| hex: http/html-1kx1024 | 2099200 | 13667.5 ± 0.4% | 1456.8 ± 0.4% | 1062.7 ± 0.2% | 500.7 ± 0.3% | 983.1 ± 0.3% | 693.0 ± 0.1% | 9.382 | 12.860 | 27.294 | 13.902 | 19.723 |
| hex: http/html-16kx64 | 2097280 | 15217.2 ± 0.5% | 1444.7 ± 0.5% | 1075.8 ± 0.5% | 508.0 ± 0.3% | 997.4 ± 0.2% | 734.5 ± 0.1% | 10.533 | 14.145 | 29.954 | 15.257 | 20.718 |
| hex: http/html-1m | 524290 | 15667.5 ± 0.2% | 1468.2 ± 0.4% | 1085.2 ± 0.4% | 500.6 ± 0.5% | 992.3 ± 0.6% | 735.6 ± 0.9% | 10.671 | 14.437 | 31.297 | 15.789 | 21.298 |
| hex: http/json-1kx1024 | 2099200 | 13647.9 ± 0.3% | 1461.7 ± 0.2% | 1066.0 ± 0.2% | 608.7 ± 0.8% | 986.2 ± 0.1% | 693.0 ± 0.1% | 9.337 | 12.802 | 22.423 | 13.838 | 19.694 |
| hex: http/json-16kx64 | 2097280 | 15170.2 ± 0.4% | 1445.7 ± 0.2% | 1076.1 ± 0.1% | 615.3 ± 0.4% | 995.2 ± 0.4% | 734.0 ± 0.1% | 10.493 | 14.097 | 24.656 | 15.243 | 20.667 |
| hex: http/json-1m | 524290 | 15665.3 ± 0.2% | 1476.2 ± 0.2% | 1087.1 ± 0.5% | 631.6 ± 1.2% | 993.8 ± 0.5% | 733.8 ± 0.5% | 10.612 | 14.411 | 24.803 | 15.764 | 21.349 |
| hex: http/js-1kx1024 | 2099200 | 13678.7 ± 0.5% | 1455.4 ± 0.1% | 1062.7 ± 0.2% | 499.8 ± 0.2% | 982.9 ± 0.1% | 693.0 ± 0.0% | 9.399 | 12.871 | 27.367 | 13.916 | 19.739 |
| hex: http/js-16kx64 | 2097280 | 15198.5 ± 0.2% | 1445.7 ± 0.1% | 1075.1 ± 0.1% | 506.1 ± 0.4% | 996.3 ± 0.4% | 734.7 ± 0.2% | 10.513 | 14.137 | 30.033 | 15.255 | 20.686 |
| hex: http/js-1m | 524290 | 15639.0 ± 0.3% | 1467.0 ± 0.3% | 1083.1 ± 0.3% | 511.9 ± 0.6% | 988.9 ± 0.3% | 733.9 ± 1.2% | 10.660 | 14.439 | 30.551 | 15.814 | 21.311 |
| hex: http/css-1kx1024 | 2099200 | 13609.0 ± 0.6% | 1456.0 ± 0.2% | 1063.2 ± 0.5% | 530.8 ± 0.4% | 982.7 ± 0.1% | 693.0 ± 0.3% | 9.347 | 12.799 | 25.637 | 13.848 | 19.637 |
| hex: http/css-16kx64 | 2097280 | 15246.0 ± 0.3% | 1440.8 ± 0.2% | 1073.3 ± 0.3% | 540.6 ± 0.4% | 995.0 ± 0.4% | 733.9 ± 0.1% | 10.581 | 14.205 | 28.203 | 15.322 | 20.773 |
| hex: http/css-1m | 524290 | 15588.7 ± 0.7% | 1466.9 ± 0.3% | 1084.8 ± 0.4% | 526.5 ± 0.5% | 989.5 ± 1.0% | 733.8 ± 2.0% | 10.627 | 14.370 | 29.609 | 15.754 | 21.244 |
| hex: shuffled/dickens-1m | 524290 | 15645.3 ± 0.3% | 1464.4 ± 0.3% | 1082.5 ± 0.5% | 495.1 ± 2.5% | 989.8 ± 0.7% | 734.3 ± 0.4% | 10.684 | 14.453 | 31.600 | 15.806 | 21.307 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1527.7 ± 0.5% | 1255.8 ± 0.1% | 1041.3 ± 0.2% | 409.6 ± 0.4% | 448.8 ± 0.2% | 415.5 ± 0.2% | 1.217 | 1.467 | 3.730 | 3.404 | 3.677 |
| qlog records, JSON text sequence | 1467503 | 1289.5 ± 0.4% | 1065.3 ± 0.4% | 786.7 ± 0.6% | 379.2 ± 0.6% | 479.2 ± 0.7% | 279.6 ± 0.8% | 1.210 | 1.639 | 3.401 | 2.691 | 4.611 |
| string: silesia/dickens | 172528 | 7125.5 ± 0.3% | 2810.8 ± 0.7% | 2932.5 ± 1.2% | 430.6 ± 0.6% | 1597.8 ± 0.3% | 1008.4 ± 0.4% | 2.535 | 2.430 | 16.548 | 4.460 | 7.066 |
| string: silesia/nci | 1075110 | 7376.7 ± 5.2% | 3396.7 ± 0.8% | 3100.7 ± 0.4% | 812.2 ± 0.9% | 1861.5 ± 0.2% | 1108.1 ± 0.1% | 2.172 | 2.379 | 9.082 | 3.963 | 6.657 |
| string: silesia/reymont | 1075159 | 3512.2 ± 1.1% | 1990.9 ± 0.5% | 2060.3 ± 0.9% | 447.8 ± 0.9% | 1506.4 ± 1.2% | 950.2 ± 0.6% | 1.764 | 1.705 | 7.842 | 2.332 | 3.696 |
| string: silesia/samba | 97582 | 4585.2 ± 1.1% | 2116.3 ± 0.2% | 3446.5 ± 0.3% | 354.2 ± 0.7% | 1486.3 ± 0.3% | 1051.9 ± 0.4% | 2.167 | 1.330 | 12.945 | 3.085 | 4.359 |
| string: silesia/webster | 1098490 | 4099.7 ± 0.6% | 1872.3 ± 0.4% | 2061.1 ± 0.6% | 442.1 ± 0.5% | 1399.5 ± 0.2% | 646.0 ± 0.9% | 2.190 | 1.989 | 9.272 | 2.929 | 6.346 |
| string: silesia/xml | 1090118 | 6226.3 ± 0.9% | 2860.8 ± 1.0% | 2648.1 ± 0.4% | 610.6 ± 0.7% | 1763.4 ± 0.3% | 922.7 ± 0.1% | 2.176 | 2.351 | 10.196 | 3.531 | 6.748 |
| string: canterbury/alice29.txt | 159425 | 6744.6 ± 2.0% | 2197.4 ± 0.5% | 2756.0 ± 0.5% | 407.6 ± 1.0% | 1471.6 ± 0.3% | 953.4 ± 0.1% | 3.069 | 2.447 | 16.547 | 4.583 | 7.074 |
| string: canterbury/asyoulik.txt | 132198 | 5945.8 ± 2.5% | 1713.8 ± 0.7% | 2365.1 ± 1.5% | 402.1 ± 0.6% | 1334.9 ± 0.6% | 885.0 ± 0.3% | 3.469 | 2.514 | 14.785 | 4.454 | 6.718 |
| string: canterbury/lcet10.txt | 441884 | 6255.3 ± 0.3% | 2561.4 ± 0.6% | 2479.0 ± 2.8% | 469.2 ± 0.4% | 1553.6 ± 0.3% | 986.8 ± 0.6% | 2.442 | 2.523 | 13.332 | 4.026 | 6.339 |
| string: canterbury/plrabn12.txt | 503330 | 5760.9 ± 0.3% | 2056.3 ± 0.3% | 2072.2 ± 0.5% | 423.2 ± 0.5% | 1391.0 ± 0.3% | 931.0 ± 0.6% | 2.802 | 2.780 | 13.612 | 4.142 | 6.188 |
| string: canterbury-large/E.coli | 1048578 | 19185.8 ± 0.2% | 9631.3 ± 1.6% | 3788.6 ± 0.5% | 1474.3 ± 0.7% | 2366.9 ± 0.2% | 1192.5 ± 0.3% | 1.992 | 5.064 | 13.013 | 8.106 | 16.088 |
| string: canterbury-large/bible.txt | 1055886 | 6800.4 ± 0.3% | 4147.7 ± 1.3% | 3015.5 ± 1.6% | 503.1 ± 1.1% | 1988.7 ± 0.1% | 1121.5 ± 0.3% | 1.640 | 2.255 | 13.518 | 3.420 | 6.064 |
| string: canterbury-large/world192.txt | 1103121 | 4040.2 ± 0.7% | 1651.6 ± 0.4% | 2002.7 ± 0.8% | 449.0 ± 0.5% | 1371.7 ± 0.1% | 908.9 ± 0.3% | 2.446 | 2.017 | 8.999 | 2.945 | 4.445 |
| string: http/html-1m | 1058582 | 6806.0 ± 0.4% | 3951.6 ± 1.6% | 3044.1 ± 0.7% | 500.0 ± 0.4% | 1930.9 ± 0.4% | 804.5 ± 1.0% | 1.722 | 2.236 | 13.613 | 3.525 | 8.460 |
| string: http/json-1m | 1190272 | 3300.3 ± 0.2% | 1353.3 ± 0.2% | 1555.2 ± 0.7% | 443.3 ± 0.5% | 1071.7 ± 0.2% | 765.5 ± 0.3% | 2.439 | 2.122 | 7.445 | 3.079 | 4.311 |
| string: http/js-1m | 1144362 | 2804.2 ± 0.3% | 1174.5 ± 0.3% | 1625.5 ± 0.4% | 369.0 ± 0.4% | 1110.1 ± 0.2% | 757.7 ± 0.2% | 2.388 | 1.725 | 7.600 | 2.526 | 3.701 |
| string: http/css-1m | 1097820 | 4026.6 ± 0.4% | 1488.8 ± 1.4% | 2155.7 ± 0.5% | 493.4 ± 0.6% | 1378.5 ± 0.3% | 895.1 ± 0.2% | 2.705 | 1.868 | 8.160 | 2.921 | 4.498 |
| string: dickens as Cyrillic and CJK | 1883069 | 3072.0 ± 0.5% | 2336.1 ± 0.6% | 521.0 ± 0.5% | 307.1 ± 0.8% | 565.1 ± 0.6% | 336.2 ± 0.3% | 1.315 | 5.896 | 10.005 | 5.437 | 9.136 |
| hex: silesia/dickens | 524290 | 15645.1 ± 0.3% | 1462.9 ± 0.2% | 1083.2 ± 0.3% | 500.2 ± 1.0% | 989.8 ± 0.3% | 733.4 ± 0.3% | 10.695 | 14.443 | 31.277 | 15.806 | 21.333 |
| hex: silesia/mozilla | 524290 | 15659.0 ± 0.2% | 1470.5 ± 0.4% | 1088.3 ± 0.1% | 442.7 ± 0.4% | 993.4 ± 0.5% | 734.3 ± 0.5% | 10.649 | 14.388 | 35.371 | 15.763 | 21.324 |
| hex: silesia/mr | 524290 | 15674.3 ± 0.3% | 1481.6 ± 0.2% | 1091.4 ± 0.2% | 553.3 ± 3.0% | 996.5 ± 0.4% | 734.7 ± 0.4% | 10.579 | 14.362 | 28.327 | 15.729 | 21.334 |
| hex: silesia/nci | 524290 | 15583.7 ± 0.3% | 1474.1 ± 0.5% | 1092.1 ± 0.2% | 633.3 ± 1.4% | 993.4 ± 0.5% | 733.7 ± 0.2% | 10.571 | 14.270 | 24.607 | 15.687 | 21.239 |
| hex: silesia/ooffice | 524290 | 15670.4 ± 0.1% | 1466.8 ± 0.2% | 1085.4 ± 0.6% | 388.5 ± 0.3% | 991.9 ± 0.5% | 735.1 ± 0.7% | 10.683 | 14.437 | 40.332 | 15.798 | 21.317 |
| hex: silesia/osdb | 524290 | 15637.0 ± 0.2% | 1466.0 ± 0.1% | 1087.5 ± 0.1% | 468.0 ± 3.8% | 990.7 ± 0.3% | 735.1 ± 0.3% | 10.666 | 14.379 | 33.414 | 15.784 | 21.272 |
| hex: silesia/reymont | 524290 | 15635.7 ± 0.4% | 1464.2 ± 0.5% | 1084.8 ± 0.4% | 514.3 ± 1.2% | 990.5 ± 0.4% | 734.4 ± 0.7% | 10.679 | 14.413 | 30.399 | 15.785 | 21.290 |
| hex: silesia/samba | 524290 | 15665.4 ± 0.2% | 1466.8 ± 0.4% | 1087.7 ± 0.2% | 402.9 ± 0.4% | 990.8 ± 0.4% | 735.1 ± 0.2% | 10.680 | 14.402 | 38.885 | 15.812 | 21.312 |
| hex: silesia/sao | 524290 | 15672.5 ± 0.2% | 1465.6 ± 0.1% | 1084.6 ± 0.5% | 332.3 ± 0.3% | 992.1 ± 0.4% | 734.8 ± 0.3% | 10.694 | 14.450 | 47.168 | 15.797 | 21.330 |
| hex: silesia/webster | 524290 | 15599.2 ± 0.7% | 1463.6 ± 0.2% | 1085.5 ± 0.3% | 475.1 ± 1.1% | 992.5 ± 0.3% | 734.8 ± 0.7% | 10.658 | 14.370 | 32.837 | 15.717 | 21.228 |
| hex: silesia/x-ray | 524290 | 15621.2 ± 0.2% | 1475.8 ± 0.2% | 1089.8 ± 0.6% | 445.0 ± 0.8% | 995.3 ± 0.4% | 734.2 ± 0.5% | 10.585 | 14.334 | 35.101 | 15.695 | 21.278 |
| hex: silesia/xml | 524290 | 15659.9 ± 0.1% | 1469.9 ± 0.2% | 1088.7 ± 0.3% | 607.1 ± 0.6% | 992.6 ± 0.5% | 734.6 ± 0.2% | 10.654 | 14.384 | 25.795 | 15.777 | 21.319 |
| hex: canterbury/alice29.txt | 304180 | 15646.5 ± 0.1% | 1469.7 ± 0.6% | 1089.4 ± 0.5% | 502.5 ± 1.8% | 993.4 ± 0.6% | 734.8 ± 0.2% | 10.646 | 14.363 | 31.140 | 15.751 | 21.294 |
| hex: canterbury/asyoulik.txt | 250360 | 15719.6 ± 0.1% | 1477.8 ± 0.5% | 1090.8 ± 0.4% | 498.4 ± 1.2% | 992.9 ± 0.1% | 741.0 ± 0.2% | 10.637 | 14.412 | 31.540 | 15.832 | 21.215 |
| hex: canterbury/cp.html | 49208 | 15638.8 ± 0.0% | 1473.1 ± 0.6% | 1098.9 ± 0.3% | 518.8 ± 2.3% | 1003.1 ± 0.5% | 743.7 ± 0.2% | 10.616 | 14.231 | 30.147 | 15.591 | 21.028 |
| hex: canterbury/fields.c | 22302 | 15460.4 ± 0.0% | 1426.7 ± 1.0% | 1078.8 ± 0.4% | 631.0 ± 5.8% | 991.7 ± 0.3% | 737.0 ± 0.3% | 10.836 | 14.331 | 24.500 | 15.589 | 20.978 |
| hex: canterbury/grammar.lsp | 7444 | 14981.9 ± 0.0% | 1505.7 ± 0.3% | 1095.2 ± 0.3% | 663.5 ± 4.7% | 998.1 ± 0.4% | 726.7 ± 0.2% | 9.950 | 13.679 | 22.581 | 15.010 | 20.617 |
| hex: canterbury/kennedy.xls | 524290 | 15654.0 ± 0.1% | 1476.0 ± 0.3% | 1089.4 ± 0.2% | 662.8 ± 2.1% | 991.9 ± 0.5% | 735.2 ± 0.4% | 10.605 | 14.369 | 23.617 | 15.782 | 21.291 |
| hex: canterbury/lcet10.txt | 524290 | 15638.2 ± 0.4% | 1465.6 ± 0.1% | 1084.2 ± 0.2% | 503.0 ± 1.0% | 991.6 ± 0.3% | 734.3 ± 0.4% | 10.670 | 14.423 | 31.089 | 15.770 | 21.296 |
| hex: canterbury/plrabn12.txt | 524290 | 15687.2 ± 0.1% | 1464.8 ± 0.6% | 1082.3 ± 0.2% | 495.6 ± 1.1% | 992.1 ± 0.8% | 734.2 ± 0.5% | 10.710 | 14.494 | 31.653 | 15.812 | 21.365 |
| hex: canterbury/ptt5 | 524290 | 15660.8 ± 0.1% | 1481.7 ± 0.9% | 1088.1 ± 0.5% | 553.3 ± 0.2% | 998.4 ± 0.5% | 734.8 ± 0.6% | 10.570 | 14.392 | 28.302 | 15.686 | 21.313 |
| hex: canterbury/sum | 76482 | 15655.7 ± 0.0% | 1495.1 ± 0.1% | 1105.0 ± 0.2% | 591.4 ± 2.8% | 999.1 ± 0.1% | 744.4 ± 0.1% | 10.471 | 14.169 | 26.473 | 15.670 | 21.031 |
| hex: canterbury/xargs.1 | 8456 | 15037.3 ± 0.0% | 1492.8 ± 0.5% | 1095.4 ± 0.7% | 637.0 ± 6.8% | 1004.8 ± 0.1% | 729.1 ± 0.1% | 10.073 | 13.728 | 23.607 | 14.966 | 20.624 |
| hex: canterbury-large/E.coli | 524290 | 15694.9 ± 0.4% | 1473.5 ± 1.0% | 1089.1 ± 0.7% | 673.6 ± 0.2% | 994.2 ± 0.6% | 733.6 ± 0.3% | 10.652 | 14.411 | 23.300 | 15.786 | 21.395 |
| hex: canterbury-large/bible.txt | 524290 | 15666.0 ± 0.1% | 1467.7 ± 0.4% | 1083.2 ± 0.2% | 515.6 ± 0.7% | 991.6 ± 0.8% | 734.5 ± 0.5% | 10.674 | 14.463 | 30.382 | 15.799 | 21.329 |
| hex: canterbury-large/world192.txt | 524290 | 15627.4 ± 0.2% | 1465.2 ± 0.2% | 1086.8 ± 0.6% | 502.4 ± 0.3% | 988.0 ± 0.7% | 733.3 ± 0.6% | 10.665 | 14.379 | 31.106 | 15.817 | 21.310 |
| hex: http/html-1kx1024 | 2099200 | 13766.6 ± 0.7% | 1456.8 ± 0.4% | 1062.7 ± 0.2% | 500.7 ± 0.3% | 983.1 ± 0.3% | 693.0 ± 0.1% | 9.450 | 12.954 | 27.492 | 14.003 | 19.866 |
| hex: http/html-16kx64 | 2097280 | 15229.6 ± 0.6% | 1444.7 ± 0.5% | 1075.8 ± 0.5% | 508.0 ± 0.3% | 997.4 ± 0.2% | 734.5 ± 0.1% | 10.541 | 14.156 | 29.979 | 15.269 | 20.735 |
| hex: http/html-1m | 524290 | 15661.1 ± 0.4% | 1468.2 ± 0.4% | 1085.2 ± 0.4% | 500.6 ± 0.5% | 992.3 ± 0.6% | 735.6 ± 0.9% | 10.667 | 14.431 | 31.284 | 15.782 | 21.289 |
| hex: http/json-1kx1024 | 2099200 | 13708.0 ± 0.3% | 1461.7 ± 0.2% | 1066.0 ± 0.2% | 608.7 ± 0.8% | 986.2 ± 0.1% | 693.0 ± 0.1% | 9.378 | 12.859 | 22.522 | 13.899 | 19.781 |
| hex: http/json-16kx64 | 2097280 | 15244.2 ± 0.7% | 1445.7 ± 0.2% | 1076.1 ± 0.1% | 615.3 ± 0.4% | 995.2 ± 0.4% | 734.0 ± 0.1% | 10.544 | 14.166 | 24.776 | 15.318 | 20.768 |
| hex: http/json-1m | 524290 | 15708.3 ± 0.1% | 1476.2 ± 0.2% | 1087.1 ± 0.5% | 631.6 ± 1.2% | 993.8 ± 0.5% | 733.8 ± 0.5% | 10.641 | 14.450 | 24.871 | 15.807 | 21.407 |
| hex: http/js-1kx1024 | 2099200 | 13881.0 ± 0.5% | 1455.4 ± 0.1% | 1062.7 ± 0.2% | 499.8 ± 0.2% | 982.9 ± 0.1% | 693.0 ± 0.0% | 9.538 | 13.062 | 27.772 | 14.122 | 20.031 |
| hex: http/js-16kx64 | 2097280 | 15212.6 ± 0.3% | 1445.7 ± 0.1% | 1075.1 ± 0.1% | 506.1 ± 0.4% | 996.3 ± 0.4% | 734.7 ± 0.2% | 10.523 | 14.150 | 30.061 | 15.269 | 20.705 |
| hex: http/js-1m | 524290 | 15665.1 ± 0.5% | 1467.0 ± 0.3% | 1083.1 ± 0.3% | 511.9 ± 0.6% | 988.9 ± 0.3% | 733.9 ± 1.2% | 10.678 | 14.463 | 30.602 | 15.841 | 21.346 |
| hex: http/css-1kx1024 | 2099200 | 13801.9 ± 0.3% | 1456.0 ± 0.2% | 1063.2 ± 0.5% | 530.8 ± 0.4% | 982.7 ± 0.1% | 693.0 ± 0.3% | 9.479 | 12.981 | 26.000 | 14.045 | 19.915 |
| hex: http/css-16kx64 | 2097280 | 15308.8 ± 0.4% | 1440.8 ± 0.2% | 1073.3 ± 0.3% | 540.6 ± 0.4% | 995.0 ± 0.4% | 733.9 ± 0.1% | 10.625 | 14.263 | 28.319 | 15.385 | 20.858 |
| hex: http/css-1m | 524290 | 15614.5 ± 0.2% | 1466.9 ± 0.3% | 1084.8 ± 0.4% | 526.5 ± 0.5% | 989.5 ± 1.0% | 733.8 ± 2.0% | 10.644 | 14.394 | 29.658 | 15.780 | 21.279 |
| hex: shuffled/dickens-1m | 524290 | 15634.7 ± 0.3% | 1464.4 ± 0.3% | 1082.5 ± 0.5% | 495.1 ± 2.5% | 989.8 ± 0.7% | 734.3 ± 0.4% | 10.676 | 14.443 | 31.578 | 15.795 | 21.293 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 937.0 ± 0.1% | 927.6 ± 0.3% | 1016.2 ± 0.4% | 301.5 ± 1.1% | 665.8 ± 0.1% | 309.9 ± 1.9% | 1.010 | 0.922 | 3.107 | 1.407 | 3.024 |
| qlog records, JSON text sequence | 1467503 | 785.6 ± 0.4% | 813.2 ± 0.2% | 786.6 ± 1.5% | 243.7 ± 0.6% | 702.3 ± 0.8% | 250.5 ± 0.8% | 0.966 | 0.999 | 3.224 | 1.119 | 3.136 |
| string: silesia/dickens | 172528 | 5055.0 ± 0.3% | 1877.6 ± 0.1% | 2648.4 ± 0.3% | 361.4 ± 1.6% | 2868.4 ± 0.3% | 554.6 ± 1.6% | 2.692 | 1.909 | 13.989 | 1.762 | 9.115 |
| string: silesia/nci | 1075110 | 4308.3 ± 0.6% | 2241.0 ± 0.5% | 2999.7 ± 0.8% | 544.2 ± 1.7% | 2994.0 ± 1.4% | 587.8 ± 2.3% | 1.922 | 1.436 | 7.916 | 1.439 | 7.330 |
| string: silesia/reymont | 1075159 | 3018.6 ± 2.4% | 1822.5 ± 2.5% | 2064.4 ± 0.4% | 375.4 ± 1.3% | 2142.2 ± 0.4% | 538.7 ± 0.6% | 1.656 | 1.462 | 8.040 | 1.409 | 5.603 |
| string: silesia/samba | 97582 | 3500.6 ± 0.6% | 2025.3 ± 0.2% | 2611.9 ± 0.2% | 324.9 ± 0.6% | 1505.2 ± 0.2% | 429.0 ± 2.1% | 1.728 | 1.340 | 10.773 | 2.326 | 8.160 |
| string: silesia/webster | 1098490 | 3667.3 ± 0.9% | 1515.9 ± 0.3% | 2016.9 ± 0.5% | 359.5 ± 0.5% | 2172.7 ± 0.7% | 497.7 ± 2.4% | 2.419 | 1.818 | 10.202 | 1.688 | 7.368 |
| string: silesia/xml | 1090118 | 4798.1 ± 0.7% | 2355.2 ± 0.6% | 2528.2 ± 0.4% | 452.7 ± 1.1% | 2801.1 ± 1.4% | 565.4 ± 1.5% | 2.037 | 1.898 | 10.599 | 1.713 | 8.486 |
| string: canterbury/alice29.txt | 159425 | 4336.1 ± 1.7% | 1599.3 ± 0.3% | 2463.5 ± 0.4% | 341.8 ± 0.4% | 2512.8 ± 0.6% | 505.9 ± 1.4% | 2.711 | 1.760 | 12.687 | 1.726 | 8.571 |
| string: canterbury/asyoulik.txt | 132198 | 3497.9 ± 0.5% | 1460.4 ± 0.2% | 2246.7 ± 0.6% | 334.8 ± 0.9% | 2083.7 ± 0.2% | 462.3 ± 1.9% | 2.395 | 1.557 | 10.448 | 1.679 | 7.567 |
| string: canterbury/lcet10.txt | 441884 | 5112.0 ± 0.4% | 1854.3 ± 0.2% | 2334.7 ± 0.1% | 390.0 ± 0.5% | 2842.7 ± 0.6% | 537.5 ± 1.3% | 2.757 | 2.190 | 13.108 | 1.798 | 9.511 |
| string: canterbury/plrabn12.txt | 503330 | 4145.8 ± 0.3% | 1738.7 ± 0.2% | 2057.9 ± 0.4% | 360.3 ± 0.7% | 2486.2 ± 0.6% | 502.2 ± 1.8% | 2.384 | 2.015 | 11.506 | 1.668 | 8.255 |
| string: canterbury-large/E.coli | 1048578 | 11913.8 ± 0.7% | 3610.5 ± 0.4% | 3257.6 ± 0.3% | 927.3 ± 0.9% | 5938.8 ± 0.9% | 767.5 ± 0.6% | 3.300 | 3.657 | 12.848 | 2.006 | 15.523 |
| string: canterbury-large/bible.txt | 1055886 | 6890.6 ± 0.8% | 2942.5 ± 0.6% | 2842.7 ± 1.0% | 418.7 ± 1.0% | 3732.7 ± 2.5% | 619.0 ± 1.0% | 2.342 | 2.424 | 16.456 | 1.846 | 11.132 |
| string: canterbury-large/world192.txt | 1103121 | 3398.7 ± 0.6% | 1479.9 ± 1.1% | 2014.2 ± 0.6% | 352.9 ± 0.2% | 2125.3 ± 1.1% | 502.2 ± 1.5% | 2.297 | 1.687 | 9.631 | 1.599 | 6.768 |
| string: http/html-1m | 1058582 | 6252.0 ± 1.3% | 2743.0 ± 0.6% | 2703.6 ± 0.5% | 441.9 ± 0.4% | 3475.8 ± 0.3% | 597.7 ± 1.9% | 2.279 | 2.312 | 14.149 | 1.799 | 10.459 |
| string: http/json-1m | 1190272 | 2561.0 ± 0.6% | 877.2 ± 0.2% | 2250.2 ± 0.2% | 390.0 ± 0.9% | 1031.7 ± 3.3% | 442.5 ± 0.8% | 2.919 | 1.138 | 6.567 | 2.482 | 5.788 |
| string: http/js-1m | 1144362 | 2287.5 ± 0.7% | 1028.2 ± 0.2% | 1637.6 ± 0.6% | 321.0 ± 0.4% | 1514.5 ± 3.6% | 419.2 ± 0.5% | 2.225 | 1.397 | 7.125 | 1.510 | 5.456 |
| string: http/css-1m | 1097820 | 2650.6 ± 0.3% | 1679.0 ± 0.4% | 2230.0 ± 0.5% | 406.6 ± 1.1% | 1901.7 ± 0.5% | 489.9 ± 0.7% | 1.579 | 1.189 | 6.519 | 1.394 | 5.411 |
| string: dickens as Cyrillic and CJK | 1883069 | 3072.4 ± 0.3% | 1686.3 ± 0.6% | 894.3 ± 0.4% | 351.3 ± 0.1% | 666.9 ± 0.6% | 158.5 ± 3.0% | 1.822 | 3.436 | 8.747 | 4.607 | 19.388 |
| string: dickens as Cyrillic and CJK, as \u escapes | 5075485 | 1330.9 ± 0.4% | 981.6 ± 0.1% | 1208.8 ± 0.6% | 214.4 ± 0.2% | 471.8 ± 0.8% | 256.4 ± 3.1% | 1.356 | 1.101 | 6.208 | 2.821 | 5.190 |
| hex: silesia/dickens | 524290 | 11997.7 ± 0.1% | 3614.3 ± 0.7% | 3282.7 ± 0.2% | 510.4 ± 1.0% | 6034.0 ± 1.5% | 782.4 ± 2.0% | 3.319 | 3.655 | 23.505 | 1.988 | 15.335 |
| hex: silesia/mozilla | 524290 | 12000.8 ± 0.1% | 3613.0 ± 0.1% | 3294.4 ± 0.1% | 447.9 ± 2.8% | 6079.1 ± 0.7% | 783.5 ± 0.2% | 3.322 | 3.643 | 26.795 | 1.974 | 15.316 |
| hex: silesia/mr | 524290 | 11976.6 ± 0.1% | 3614.7 ± 0.2% | 3285.9 ± 0.3% | 567.1 ± 3.2% | 5971.0 ± 0.3% | 784.4 ± 0.4% | 3.313 | 3.645 | 21.119 | 2.006 | 15.269 |
| hex: silesia/nci | 524290 | 12009.0 ± 0.1% | 3614.5 ± 0.2% | 3292.2 ± 0.2% | 618.6 ± 2.4% | 6032.6 ± 1.2% | 783.0 ± 0.6% | 3.322 | 3.648 | 19.412 | 1.991 | 15.338 |
| hex: silesia/ooffice | 524290 | 11993.0 ± 0.1% | 3614.0 ± 0.2% | 3290.8 ± 0.6% | 399.3 ± 0.8% | 6066.0 ± 1.6% | 781.2 ± 0.6% | 3.318 | 3.644 | 30.033 | 1.977 | 15.351 |
| hex: silesia/osdb | 524290 | 12021.7 ± 0.0% | 3615.2 ± 0.4% | 3298.8 ± 0.7% | 481.1 ± 0.4% | 6056.3 ± 1.4% | 783.5 ± 0.4% | 3.325 | 3.644 | 24.986 | 1.985 | 15.343 |
| hex: silesia/reymont | 524290 | 11957.1 ± 0.2% | 3614.1 ± 0.1% | 3278.3 ± 0.2% | 516.6 ± 0.3% | 5994.1 ± 1.5% | 781.3 ± 0.7% | 3.308 | 3.647 | 23.145 | 1.995 | 15.303 |
| hex: silesia/samba | 524290 | 11993.7 ± 0.2% | 3613.3 ± 0.5% | 3289.1 ± 0.3% | 408.9 ± 1.3% | 6059.4 ± 0.4% | 782.3 ± 0.5% | 3.319 | 3.646 | 29.331 | 1.979 | 15.331 |
| hex: silesia/sao | 524290 | 11999.4 ± 0.2% | 3614.6 ± 0.1% | 3290.4 ± 0.3% | 342.0 ± 1.2% | 6092.2 ± 1.5% | 781.8 ± 0.7% | 3.320 | 3.647 | 35.081 | 1.970 | 15.349 |
| hex: silesia/webster | 524290 | 12008.4 ± 0.1% | 3617.0 ± 0.4% | 3294.7 ± 0.4% | 465.0 ± 0.4% | 6068.1 ± 0.6% | 783.5 ± 0.4% | 3.320 | 3.645 | 25.825 | 1.979 | 15.326 |
| hex: silesia/x-ray | 524290 | 12009.0 ± 0.0% | 3616.7 ± 0.2% | 3292.3 ± 0.2% | 478.9 ± 0.4% | 6035.4 ± 1.7% | 782.5 ± 0.4% | 3.320 | 3.648 | 25.076 | 1.990 | 15.347 |
| hex: silesia/xml | 524290 | 11969.3 ± 0.1% | 3613.9 ± 0.3% | 3291.6 ± 0.2% | 522.5 ± 0.8% | 5991.7 ± 3.5% | 782.6 ± 0.9% | 3.312 | 3.636 | 22.908 | 1.998 | 15.293 |
| hex: canterbury/alice29.txt | 304180 | 12010.3 ± 0.1% | 3629.1 ± 0.1% | 3358.8 ± 0.1% | 511.2 ± 0.3% | 6072.7 ± 2.1% | 783.1 ± 0.4% | 3.309 | 3.576 | 23.492 | 1.978 | 15.338 |
| hex: canterbury/asyoulik.txt | 250360 | 12010.1 ± 0.1% | 3635.3 ± 0.1% | 3366.4 ± 0.3% | 502.1 ± 0.3% | 6071.5 ± 1.3% | 783.1 ± 0.2% | 3.304 | 3.568 | 23.917 | 1.978 | 15.337 |
| hex: canterbury/cp.html | 49208 | 11927.0 ± 0.0% | 3640.2 ± 0.0% | 3280.6 ± 0.4% | 473.5 ± 0.7% | 6264.1 ± 0.5% | 769.4 ± 1.0% | 3.276 | 3.636 | 25.190 | 1.904 | 15.501 |
| hex: canterbury/fields.c | 22302 | 11782.8 ± 0.0% | 3630.1 ± 0.0% | 3355.9 ± 0.1% | 497.2 ± 0.5% | 6248.4 ± 0.2% | 751.6 ± 1.7% | 3.246 | 3.511 | 23.698 | 1.886 | 15.677 |
| hex: canterbury/grammar.lsp | 7444 | 11253.7 ± 0.1% | 3601.8 ± 0.0% | 3361.0 ± 0.5% | 532.0 ± 3.6% | 6173.8 ± 0.3% | 724.9 ± 1.0% | 3.124 | 3.348 | 21.152 | 1.823 | 15.523 |
| hex: canterbury/kennedy.xls | 524290 | 12010.6 ± 0.2% | 3610.4 ± 0.3% | 3301.1 ± 0.3% | 653.6 ± 2.7% | 6058.3 ± 0.9% | 776.3 ± 3.3% | 3.327 | 3.638 | 18.376 | 1.983 | 15.472 |
| hex: canterbury/lcet10.txt | 524290 | 11960.9 ± 0.1% | 3604.9 ± 0.2% | 3298.8 ± 0.1% | 507.1 ± 1.0% | 5953.4 ± 0.3% | 782.9 ± 0.7% | 3.318 | 3.626 | 23.585 | 2.009 | 15.277 |
| hex: canterbury/plrabn12.txt | 524290 | 12021.7 ± 0.1% | 3608.1 ± 0.8% | 3287.3 ± 0.4% | 505.6 ± 3.5% | 6078.3 ± 1.1% | 782.9 ± 0.5% | 3.332 | 3.657 | 23.776 | 1.978 | 15.355 |
| hex: canterbury/ptt5 | 524290 | 11979.7 ± 0.1% | 3608.3 ± 0.4% | 3286.9 ± 0.2% | 560.8 ± 0.7% | 6031.4 ± 1.0% | 784.4 ± 0.3% | 3.320 | 3.645 | 21.363 | 1.986 | 15.273 |
| hex: canterbury/sum | 76482 | 11916.1 ± 0.0% | 3634.3 ± 0.0% | 3356.3 ± 0.3% | 508.8 ± 1.1% | 6169.2 ± 0.3% | 773.3 ± 1.0% | 3.279 | 3.550 | 23.419 | 1.932 | 15.410 |
| hex: canterbury/xargs.1 | 8456 | 11352.7 ± 0.1% | 3602.9 ± 0.1% | 3360.6 ± 0.3% | 487.7 ± 2.0% | 6150.7 ± 0.4% | 752.3 ± 1.7% | 3.151 | 3.378 | 23.279 | 1.846 | 15.090 |
| hex: canterbury-large/E.coli | 524290 | 12022.5 ± 0.1% | 3613.1 ± 0.2% | 3288.2 ± 0.4% | 689.3 ± 0.3% | 6057.0 ± 1.6% | 766.2 ± 5.9% | 3.328 | 3.656 | 17.441 | 1.985 | 15.691 |
| hex: canterbury-large/bible.txt | 524290 | 12004.8 ± 0.1% | 3622.9 ± 0.2% | 3294.7 ± 0.3% | 519.5 ± 0.7% | 6049.8 ± 1.6% | 784.0 ± 0.3% | 3.314 | 3.644 | 23.106 | 1.984 | 15.313 |
| hex: canterbury-large/world192.txt | 524290 | 12022.3 ± 0.1% | 3624.1 ± 0.3% | 3292.9 ± 0.3% | 495.5 ± 2.0% | 6094.5 ± 0.8% | 784.6 ± 0.5% | 3.317 | 3.651 | 24.265 | 1.973 | 15.324 |
| hex: http/html-1kx1024 | 2099200 | 8932.4 ± 3.8% | 3466.4 ± 0.1% | 2857.1 ± 0.4% | 474.0 ± 0.4% | 5085.3 ± 0.7% | 647.1 ± 3.6% | 2.577 | 3.126 | 18.846 | 1.757 | 13.803 |
| hex: http/html-16kx64 | 2097280 | 11759.5 ± 0.2% | 3612.7 ± 0.2% | 3265.3 ± 0.2% | 478.7 ± 2.2% | 5988.0 ± 0.4% | 759.5 ± 1.1% | 3.255 | 3.601 | 24.567 | 1.964 | 15.484 |
| hex: http/html-1m | 524290 | 11988.9 ± 0.3% | 3613.1 ± 0.1% | 3293.9 ± 0.4% | 493.8 ± 0.9% | 6066.4 ± 2.4% | 781.4 ± 1.2% | 3.318 | 3.640 | 24.277 | 1.976 | 15.343 |
| hex: http/json-1kx1024 | 2099200 | 8751.4 ± 3.4% | 3461.9 ± 0.3% | 2855.8 ± 0.3% | 575.0 ± 1.2% | 5087.8 ± 1.5% | 641.8 ± 2.4% | 2.528 | 3.064 | 15.219 | 1.720 | 13.636 |
| hex: http/json-16kx64 | 2097280 | 11760.8 ± 0.2% | 3611.3 ± 0.2% | 3279.0 ± 0.2% | 572.9 ± 0.7% | 5991.8 ± 0.6% | 758.4 ± 1.4% | 3.257 | 3.587 | 20.529 | 1.963 | 15.507 |
| hex: http/json-1m | 524290 | 12006.5 ± 0.2% | 3615.3 ± 0.3% | 3282.1 ± 0.4% | 584.3 ± 2.5% | 6077.2 ± 2.1% | 779.5 ± 1.5% | 3.321 | 3.658 | 20.548 | 1.976 | 15.402 |
| hex: http/js-1kx1024 | 2099200 | 8775.1 ± 3.8% | 3461.8 ± 0.2% | 2857.3 ± 0.5% | 479.4 ± 1.1% | 5072.1 ± 0.8% | 642.4 ± 1.2% | 2.535 | 3.071 | 18.304 | 1.730 | 13.659 |
| hex: http/js-16kx64 | 2097280 | 11767.7 ± 0.1% | 3612.3 ± 0.1% | 3264.4 ± 0.2% | 479.4 ± 0.6% | 6008.4 ± 0.6% | 756.3 ± 1.5% | 3.258 | 3.605 | 24.549 | 1.959 | 15.559 |
| hex: http/js-1m | 524290 | 11973.3 ± 0.2% | 3610.0 ± 0.4% | 3299.9 ± 0.2% | 498.2 ± 1.9% | 6014.7 ± 1.4% | 776.8 ± 2.1% | 3.317 | 3.628 | 24.035 | 1.991 | 15.414 |
| hex: http/css-1kx1024 | 2099200 | 8762.7 ± 5.1% | 3461.2 ± 0.6% | 2855.2 ± 2.7% | 488.6 ± 0.4% | 5063.7 ± 0.7% | 648.1 ± 3.7% | 2.532 | 3.069 | 17.935 | 1.730 | 13.520 |
| hex: http/css-16kx64 | 2097280 | 11769.8 ± 0.2% | 3614.2 ± 0.1% | 3261.3 ± 0.4% | 497.7 ± 1.0% | 5997.6 ± 0.7% | 758.2 ± 2.2% | 3.257 | 3.609 | 23.648 | 1.962 | 15.523 |
| hex: http/css-1m | 524290 | 11981.9 ± 0.3% | 3612.0 ± 0.1% | 3294.9 ± 0.2% | 496.0 ± 1.0% | 6070.6 ± 1.3% | 781.1 ± 0.8% | 3.317 | 3.636 | 24.158 | 1.974 | 15.341 |
| hex: shuffled/dickens-1m | 524290 | 11971.5 ± 0.1% | 3605.9 ± 0.3% | 3292.2 ± 0.3% | 511.2 ± 1.2% | 6021.0 ± 1.1% | 783.4 ± 0.4% | 3.320 | 3.636 | 23.419 | 1.988 | 15.281 |

## TextReader.next_items against the baselines

stdx's decoder a slice of tokens a call through `TextReader.next_items`, as a caller that reads a text's values in a loop calls it (decision 79). Octets are the text's. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1011.9 ± 0.2% | 927.6 ± 0.3% | 1016.2 ± 0.4% | 301.5 ± 1.1% | 665.8 ± 0.1% | 309.9 ± 1.9% | 1.091 | 0.996 | 3.356 | 1.520 | 3.265 |
| qlog records, JSON text sequence | 1467503 | 842.8 ± 0.6% | 813.2 ± 0.2% | 786.6 ± 1.5% | 243.7 ± 0.6% | 702.3 ± 0.8% | 250.5 ± 0.8% | 1.036 | 1.072 | 3.459 | 1.200 | 3.364 |
| string: silesia/dickens | 172528 | 5050.7 ± 0.4% | 1877.6 ± 0.1% | 2648.4 ± 0.3% | 361.4 ± 1.6% | 2868.4 ± 0.3% | 554.6 ± 1.6% | 2.690 | 1.907 | 13.977 | 1.761 | 9.108 |
| string: silesia/nci | 1075110 | 4310.5 ± 0.4% | 2241.0 ± 0.5% | 2999.7 ± 0.8% | 544.2 ± 1.7% | 2994.0 ± 1.4% | 587.8 ± 2.3% | 1.923 | 1.437 | 7.920 | 1.440 | 7.334 |
| string: silesia/reymont | 1075159 | 3022.7 ± 1.2% | 1822.5 ± 2.5% | 2064.4 ± 0.4% | 375.4 ± 1.3% | 2142.2 ± 0.4% | 538.7 ± 0.6% | 1.659 | 1.464 | 8.051 | 1.411 | 5.611 |
| string: silesia/samba | 97582 | 3511.8 ± 0.4% | 2025.3 ± 0.2% | 2611.9 ± 0.2% | 324.9 ± 0.6% | 1505.2 ± 0.2% | 429.0 ± 2.1% | 1.734 | 1.345 | 10.807 | 2.333 | 8.186 |
| string: silesia/webster | 1098490 | 3662.3 ± 0.2% | 1515.9 ± 0.3% | 2016.9 ± 0.5% | 359.5 ± 0.5% | 2172.7 ± 0.7% | 497.7 ± 2.4% | 2.416 | 1.816 | 10.188 | 1.686 | 7.358 |
| string: silesia/xml | 1090118 | 4798.8 ± 0.9% | 2355.2 ± 0.6% | 2528.2 ± 0.4% | 452.7 ± 1.1% | 2801.1 ± 1.4% | 565.4 ± 1.5% | 2.038 | 1.898 | 10.601 | 1.713 | 8.487 |
| string: canterbury/alice29.txt | 159425 | 4354.6 ± 1.4% | 1599.3 ± 0.3% | 2463.5 ± 0.4% | 341.8 ± 0.4% | 2512.8 ± 0.6% | 505.9 ± 1.4% | 2.723 | 1.768 | 12.741 | 1.733 | 8.607 |
| string: canterbury/asyoulik.txt | 132198 | 3499.2 ± 0.6% | 1460.4 ± 0.2% | 2246.7 ± 0.6% | 334.8 ± 0.9% | 2083.7 ± 0.2% | 462.3 ± 1.9% | 2.396 | 1.557 | 10.452 | 1.679 | 7.570 |
| string: canterbury/lcet10.txt | 441884 | 5124.6 ± 0.4% | 1854.3 ± 0.2% | 2334.7 ± 0.1% | 390.0 ± 0.5% | 2842.7 ± 0.6% | 537.5 ± 1.3% | 2.764 | 2.195 | 13.140 | 1.803 | 9.534 |
| string: canterbury/plrabn12.txt | 503330 | 4152.0 ± 0.4% | 1738.7 ± 0.2% | 2057.9 ± 0.4% | 360.3 ± 0.7% | 2486.2 ± 0.6% | 502.2 ± 1.8% | 2.388 | 2.018 | 11.523 | 1.670 | 8.268 |
| string: canterbury-large/E.coli | 1048578 | 11909.1 ± 0.6% | 3610.5 ± 0.4% | 3257.6 ± 0.3% | 927.3 ± 0.9% | 5938.8 ± 0.9% | 767.5 ± 0.6% | 3.298 | 3.656 | 12.843 | 2.005 | 15.517 |
| string: canterbury-large/bible.txt | 1055886 | 6905.4 ± 0.5% | 2942.5 ± 0.6% | 2842.7 ± 1.0% | 418.7 ± 1.0% | 3732.7 ± 2.5% | 619.0 ± 1.0% | 2.347 | 2.429 | 16.491 | 1.850 | 11.155 |
| string: canterbury-large/world192.txt | 1103121 | 3390.9 ± 0.6% | 1479.9 ± 1.1% | 2014.2 ± 0.6% | 352.9 ± 0.2% | 2125.3 ± 1.1% | 502.2 ± 1.5% | 2.291 | 1.683 | 9.609 | 1.595 | 6.753 |
| string: http/html-1m | 1058582 | 6267.0 ± 2.0% | 2743.0 ± 0.6% | 2703.6 ± 0.5% | 441.9 ± 0.4% | 3475.8 ± 0.3% | 597.7 ± 1.9% | 2.285 | 2.318 | 14.183 | 1.803 | 10.484 |
| string: http/json-1m | 1190272 | 2556.2 ± 0.4% | 877.2 ± 0.2% | 2250.2 ± 0.2% | 390.0 ± 0.9% | 1031.7 ± 3.3% | 442.5 ± 0.8% | 2.914 | 1.136 | 6.554 | 2.478 | 5.777 |
| string: http/js-1m | 1144362 | 2284.4 ± 0.4% | 1028.2 ± 0.2% | 1637.6 ± 0.6% | 321.0 ± 0.4% | 1514.5 ± 3.6% | 419.2 ± 0.5% | 2.222 | 1.395 | 7.116 | 1.508 | 5.449 |
| string: http/css-1m | 1097820 | 2656.8 ± 0.5% | 1679.0 ± 0.4% | 2230.0 ± 0.5% | 406.6 ± 1.1% | 1901.7 ± 0.5% | 489.9 ± 0.7% | 1.582 | 1.191 | 6.534 | 1.397 | 5.423 |
| string: dickens as Cyrillic and CJK | 1883069 | 3080.1 ± 0.7% | 1686.3 ± 0.6% | 894.3 ± 0.4% | 351.3 ± 0.1% | 666.9 ± 0.6% | 158.5 ± 3.0% | 1.827 | 3.444 | 8.769 | 4.618 | 19.437 |
| string: dickens as Cyrillic and CJK, as \u escapes | 5075485 | 1330.2 ± 0.3% | 981.6 ± 0.1% | 1208.8 ± 0.6% | 214.4 ± 0.2% | 471.8 ± 0.8% | 256.4 ± 3.1% | 1.355 | 1.100 | 6.205 | 2.820 | 5.187 |
| hex: silesia/dickens | 524290 | 11991.8 ± 0.1% | 3614.3 ± 0.7% | 3282.7 ± 0.2% | 510.4 ± 1.0% | 6034.0 ± 1.5% | 782.4 ± 2.0% | 3.318 | 3.653 | 23.493 | 1.987 | 15.327 |
| hex: silesia/mozilla | 524290 | 12005.0 ± 0.1% | 3613.0 ± 0.1% | 3294.4 ± 0.1% | 447.9 ± 2.8% | 6079.1 ± 0.7% | 783.5 ± 0.2% | 3.323 | 3.644 | 26.805 | 1.975 | 15.321 |
| hex: silesia/mr | 524290 | 11989.2 ± 0.1% | 3614.7 ± 0.2% | 3285.9 ± 0.3% | 567.1 ± 3.2% | 5971.0 ± 0.3% | 784.4 ± 0.4% | 3.317 | 3.649 | 21.141 | 2.008 | 15.285 |
| hex: silesia/nci | 524290 | 12013.0 ± 0.1% | 3614.5 ± 0.2% | 3292.2 ± 0.2% | 618.6 ± 2.4% | 6032.6 ± 1.2% | 783.0 ± 0.6% | 3.324 | 3.649 | 19.419 | 1.991 | 15.343 |
| hex: silesia/ooffice | 524290 | 11982.8 ± 0.1% | 3614.0 ± 0.2% | 3290.8 ± 0.6% | 399.3 ± 0.8% | 6066.0 ± 1.6% | 781.2 ± 0.6% | 3.316 | 3.641 | 30.007 | 1.975 | 15.338 |
| hex: silesia/osdb | 524290 | 12021.8 ± 0.1% | 3615.2 ± 0.4% | 3298.8 ± 0.7% | 481.1 ± 0.4% | 6056.3 ± 1.4% | 783.5 ± 0.4% | 3.325 | 3.644 | 24.986 | 1.985 | 15.343 |
| hex: silesia/reymont | 524290 | 11961.7 ± 0.1% | 3614.1 ± 0.1% | 3278.3 ± 0.2% | 516.6 ± 0.3% | 5994.1 ± 1.5% | 781.3 ± 0.7% | 3.310 | 3.649 | 23.153 | 1.996 | 15.309 |
| hex: silesia/samba | 524290 | 11996.9 ± 0.2% | 3613.3 ± 0.5% | 3289.1 ± 0.3% | 408.9 ± 1.3% | 6059.4 ± 0.4% | 782.3 ± 0.5% | 3.320 | 3.647 | 29.339 | 1.980 | 15.335 |
| hex: silesia/sao | 524290 | 11997.7 ± 0.2% | 3614.6 ± 0.1% | 3290.4 ± 0.3% | 342.0 ± 1.2% | 6092.2 ± 1.5% | 781.8 ± 0.7% | 3.319 | 3.646 | 35.076 | 1.969 | 15.347 |
| hex: silesia/webster | 524290 | 12011.5 ± 0.1% | 3617.0 ± 0.4% | 3294.7 ± 0.4% | 465.0 ± 0.4% | 6068.1 ± 0.6% | 783.5 ± 0.4% | 3.321 | 3.646 | 25.832 | 1.979 | 15.330 |
| hex: silesia/x-ray | 524290 | 12010.7 ± 0.1% | 3616.7 ± 0.2% | 3292.3 ± 0.2% | 478.9 ± 0.4% | 6035.4 ± 1.7% | 782.5 ± 0.4% | 3.321 | 3.648 | 25.080 | 1.990 | 15.349 |
| hex: silesia/xml | 524290 | 11995.2 ± 0.1% | 3613.9 ± 0.3% | 3291.6 ± 0.2% | 522.5 ± 0.8% | 5991.7 ± 3.5% | 782.6 ± 0.9% | 3.319 | 3.644 | 22.957 | 2.002 | 15.327 |
| hex: canterbury/alice29.txt | 304180 | 12011.8 ± 0.1% | 3629.1 ± 0.1% | 3358.8 ± 0.1% | 511.2 ± 0.3% | 6072.7 ± 2.1% | 783.1 ± 0.4% | 3.310 | 3.576 | 23.495 | 1.978 | 15.340 |
| hex: canterbury/asyoulik.txt | 250360 | 12009.3 ± 0.1% | 3635.3 ± 0.1% | 3366.4 ± 0.3% | 502.1 ± 0.3% | 6071.5 ± 1.3% | 783.1 ± 0.2% | 3.304 | 3.567 | 23.916 | 1.978 | 15.336 |
| hex: canterbury/cp.html | 49208 | 11927.6 ± 0.0% | 3640.2 ± 0.0% | 3280.6 ± 0.4% | 473.5 ± 0.7% | 6264.1 ± 0.5% | 769.4 ± 1.0% | 3.277 | 3.636 | 25.191 | 1.904 | 15.502 |
| hex: canterbury/fields.c | 22302 | 11789.8 ± 0.0% | 3630.1 ± 0.0% | 3355.9 ± 0.1% | 497.2 ± 0.5% | 6248.4 ± 0.2% | 751.6 ± 1.7% | 3.248 | 3.513 | 23.712 | 1.887 | 15.686 |
| hex: canterbury/grammar.lsp | 7444 | 11336.4 ± 0.1% | 3601.8 ± 0.0% | 3361.0 ± 0.5% | 532.0 ± 3.6% | 6173.8 ± 0.3% | 724.9 ± 1.0% | 3.147 | 3.373 | 21.307 | 1.836 | 15.638 |
| hex: canterbury/kennedy.xls | 524290 | 11985.3 ± 0.1% | 3610.4 ± 0.3% | 3301.1 ± 0.3% | 653.6 ± 2.7% | 6058.3 ± 0.9% | 776.3 ± 3.3% | 3.320 | 3.631 | 18.338 | 1.978 | 15.440 |
| hex: canterbury/lcet10.txt | 524290 | 11979.1 ± 0.1% | 3604.9 ± 0.2% | 3298.8 ± 0.1% | 507.1 ± 1.0% | 5953.4 ± 0.3% | 782.9 ± 0.7% | 3.323 | 3.631 | 23.621 | 2.012 | 15.300 |
| hex: canterbury/plrabn12.txt | 524290 | 12019.3 ± 0.1% | 3608.1 ± 0.8% | 3287.3 ± 0.4% | 505.6 ± 3.5% | 6078.3 ± 1.1% | 782.9 ± 0.5% | 3.331 | 3.656 | 23.771 | 1.977 | 15.352 |
| hex: canterbury/ptt5 | 524290 | 11983.0 ± 0.2% | 3608.3 ± 0.4% | 3286.9 ± 0.2% | 560.8 ± 0.7% | 6031.4 ± 1.0% | 784.4 ± 0.3% | 3.321 | 3.646 | 21.369 | 1.987 | 15.277 |
| hex: canterbury/sum | 76482 | 11920.2 ± 0.1% | 3634.3 ± 0.0% | 3356.3 ± 0.3% | 508.8 ± 1.1% | 6169.2 ± 0.3% | 773.3 ± 1.0% | 3.280 | 3.552 | 23.427 | 1.932 | 15.415 |
| hex: canterbury/xargs.1 | 8456 | 11358.6 ± 0.0% | 3602.9 ± 0.1% | 3360.6 ± 0.3% | 487.7 ± 2.0% | 6150.7 ± 0.4% | 752.3 ± 1.7% | 3.153 | 3.380 | 23.291 | 1.847 | 15.098 |
| hex: canterbury-large/E.coli | 524290 | 12021.7 ± 0.1% | 3613.1 ± 0.2% | 3288.2 ± 0.4% | 689.3 ± 0.3% | 6057.0 ± 1.6% | 766.2 ± 5.9% | 3.327 | 3.656 | 17.440 | 1.985 | 15.690 |
| hex: canterbury-large/bible.txt | 524290 | 11997.7 ± 0.2% | 3622.9 ± 0.2% | 3294.7 ± 0.3% | 519.5 ± 0.7% | 6049.8 ± 1.6% | 784.0 ± 0.3% | 3.312 | 3.641 | 23.093 | 1.983 | 15.303 |
| hex: canterbury-large/world192.txt | 524290 | 12027.2 ± 0.0% | 3624.1 ± 0.3% | 3292.9 ± 0.3% | 495.5 ± 2.0% | 6094.5 ± 0.8% | 784.6 ± 0.5% | 3.319 | 3.652 | 24.274 | 1.973 | 15.330 |
| hex: http/html-1kx1024 | 2099200 | 9022.6 ± 3.9% | 3466.4 ± 0.1% | 2857.1 ± 0.4% | 474.0 ± 0.4% | 5085.3 ± 0.7% | 647.1 ± 3.6% | 2.603 | 3.158 | 19.036 | 1.774 | 13.942 |
| hex: http/html-16kx64 | 2097280 | 11762.4 ± 0.2% | 3612.7 ± 0.2% | 3265.3 ± 0.2% | 478.7 ± 2.2% | 5988.0 ± 0.4% | 759.5 ± 1.1% | 3.256 | 3.602 | 24.573 | 1.964 | 15.488 |
| hex: http/html-1m | 524290 | 11940.6 ± 0.2% | 3613.1 ± 0.1% | 3293.9 ± 0.4% | 493.8 ± 0.9% | 6066.4 ± 2.4% | 781.4 ± 1.2% | 3.305 | 3.625 | 24.179 | 1.968 | 15.281 |
| hex: http/json-1kx1024 | 2099200 | 8803.2 ± 3.6% | 3461.9 ± 0.3% | 2855.8 ± 0.3% | 575.0 ± 1.2% | 5087.8 ± 1.5% | 641.8 ± 2.4% | 2.543 | 3.083 | 15.309 | 1.730 | 13.717 |
| hex: http/json-16kx64 | 2097280 | 11773.1 ± 0.2% | 3611.3 ± 0.2% | 3279.0 ± 0.2% | 572.9 ± 0.7% | 5991.8 ± 0.6% | 758.4 ± 1.4% | 3.260 | 3.590 | 20.550 | 1.965 | 15.523 |
| hex: http/json-1m | 524290 | 11994.6 ± 0.1% | 3615.3 ± 0.3% | 3282.1 ± 0.4% | 584.3 ± 2.5% | 6077.2 ± 2.1% | 779.5 ± 1.5% | 3.318 | 3.655 | 20.527 | 1.974 | 15.387 |
| hex: http/js-1kx1024 | 2099200 | 8826.8 ± 4.7% | 3461.8 ± 0.2% | 2857.3 ± 0.5% | 479.4 ± 1.1% | 5072.1 ± 0.8% | 642.4 ± 1.2% | 2.550 | 3.089 | 18.412 | 1.740 | 13.739 |
| hex: http/js-16kx64 | 2097280 | 11778.1 ± 0.2% | 3612.3 ± 0.1% | 3264.4 ± 0.2% | 479.4 ± 0.6% | 6008.4 ± 0.6% | 756.3 ± 1.5% | 3.261 | 3.608 | 24.571 | 1.960 | 15.573 |
| hex: http/js-1m | 524290 | 11972.5 ± 0.1% | 3610.0 ± 0.4% | 3299.9 ± 0.2% | 498.2 ± 1.9% | 6014.7 ± 1.4% | 776.8 ± 2.1% | 3.316 | 3.628 | 24.034 | 1.991 | 15.413 |
| hex: http/css-1kx1024 | 2099200 | 8812.8 ± 6.1% | 3461.2 ± 0.6% | 2855.2 ± 2.7% | 488.6 ± 0.4% | 5063.7 ± 0.7% | 648.1 ± 3.7% | 2.546 | 3.087 | 18.037 | 1.740 | 13.597 |
| hex: http/css-16kx64 | 2097280 | 11768.7 ± 0.1% | 3614.2 ± 0.1% | 3261.3 ± 0.4% | 497.7 ± 1.0% | 5997.6 ± 0.7% | 758.2 ± 2.2% | 3.256 | 3.609 | 23.646 | 1.962 | 15.522 |
| hex: http/css-1m | 524290 | 11987.0 ± 0.2% | 3612.0 ± 0.1% | 3294.9 ± 0.2% | 496.0 ± 1.0% | 6070.6 ± 1.3% | 781.1 ± 0.8% | 3.319 | 3.638 | 24.169 | 1.975 | 15.347 |
| hex: shuffled/dickens-1m | 524290 | 11961.7 ± 0.2% | 3605.9 ± 0.3% | 3292.2 ± 0.3% | 511.2 ± 1.2% | 6021.0 ± 1.1% | 783.4 ± 0.4% | 3.317 | 3.633 | 23.400 | 1.987 | 15.269 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1360.1 ± 0.1% | 1255.8 ± 0.1% | 1041.3 ± 0.2% | 409.6 ± 0.4% | 448.8 ± 0.2% | 415.5 ± 0.2% | 1.083 | 1.306 | 3.321 | 3.031 | 3.273 |
| qlog records, JSON text sequence | 1467503 | 1052.9 ± 0.5% | 1065.3 ± 0.4% | 786.7 ± 0.6% | 379.2 ± 0.6% | 479.2 ± 0.7% | 279.6 ± 0.8% | 0.988 | 1.338 | 2.777 | 2.197 | 3.765 |
| string: silesia/dickens | 172528 | 6912.0 ± 0.4% | 2810.8 ± 0.7% | 2932.5 ± 1.2% | 430.6 ± 0.6% | 1597.8 ± 0.3% | 1008.4 ± 0.4% | 2.459 | 2.357 | 16.052 | 4.326 | 6.854 |
| string: silesia/nci | 1075110 | 7310.7 ± 0.3% | 3396.7 ± 0.8% | 3100.7 ± 0.4% | 812.2 ± 0.9% | 1861.5 ± 0.2% | 1108.1 ± 0.1% | 2.152 | 2.358 | 9.001 | 3.927 | 6.598 |
| string: silesia/reymont | 1075159 | 3326.4 ± 0.9% | 1990.9 ± 0.5% | 2060.3 ± 0.9% | 447.8 ± 0.9% | 1506.4 ± 1.2% | 950.2 ± 0.6% | 1.671 | 1.615 | 7.428 | 2.208 | 3.501 |
| string: silesia/samba | 97582 | 4208.2 ± 0.4% | 2116.3 ± 0.2% | 3446.5 ± 0.3% | 354.2 ± 0.7% | 1486.3 ± 0.3% | 1051.9 ± 0.4% | 1.988 | 1.221 | 11.880 | 2.831 | 4.000 |
| string: silesia/webster | 1098490 | 4075.1 ± 0.7% | 1872.3 ± 0.4% | 2061.1 ± 0.6% | 442.1 ± 0.5% | 1399.5 ± 0.2% | 646.0 ± 0.9% | 2.177 | 1.977 | 9.217 | 2.912 | 6.308 |
| string: silesia/xml | 1090118 | 6133.8 ± 0.5% | 2860.8 ± 1.0% | 2648.1 ± 0.4% | 610.6 ± 0.7% | 1763.4 ± 0.3% | 922.7 ± 0.1% | 2.144 | 2.316 | 10.045 | 3.478 | 6.647 |
| string: canterbury/alice29.txt | 159425 | 6442.9 ± 0.8% | 2197.4 ± 0.5% | 2756.0 ± 0.5% | 407.6 ± 1.0% | 1471.6 ± 0.3% | 953.4 ± 0.1% | 2.932 | 2.338 | 15.807 | 4.378 | 6.758 |
| string: canterbury/asyoulik.txt | 132198 | 5652.7 ± 0.6% | 1713.8 ± 0.7% | 2365.1 ± 1.5% | 402.1 ± 0.6% | 1334.9 ± 0.6% | 885.0 ± 0.3% | 3.298 | 2.390 | 14.057 | 4.235 | 6.387 |
| string: canterbury/lcet10.txt | 441884 | 6269.1 ± 0.3% | 2561.4 ± 0.6% | 2479.0 ± 2.8% | 469.2 ± 0.4% | 1553.6 ± 0.3% | 986.8 ± 0.6% | 2.448 | 2.529 | 13.362 | 4.035 | 6.353 |
| string: canterbury/plrabn12.txt | 503330 | 5711.6 ± 0.4% | 2056.3 ± 0.3% | 2072.2 ± 0.5% | 423.2 ± 0.5% | 1391.0 ± 0.3% | 931.0 ± 0.6% | 2.778 | 2.756 | 13.496 | 4.106 | 6.135 |
| string: canterbury-large/E.coli | 1048578 | 19241.2 ± 0.9% | 9631.3 ± 1.6% | 3788.6 ± 0.5% | 1474.3 ± 0.7% | 2366.9 ± 0.2% | 1192.5 ± 0.3% | 1.998 | 5.079 | 13.051 | 8.129 | 16.135 |
| string: canterbury-large/bible.txt | 1055886 | 6806.4 ± 0.3% | 4147.7 ± 1.3% | 3015.5 ± 1.6% | 503.1 ± 1.1% | 1988.7 ± 0.1% | 1121.5 ± 0.3% | 1.641 | 2.257 | 13.530 | 3.423 | 6.069 |
| string: canterbury-large/world192.txt | 1103121 | 4062.7 ± 0.5% | 1651.6 ± 0.4% | 2002.7 ± 0.8% | 449.0 ± 0.5% | 1371.7 ± 0.1% | 908.9 ± 0.3% | 2.460 | 2.029 | 9.049 | 2.962 | 4.470 |
| string: http/html-1m | 1058582 | 6773.9 ± 0.4% | 3951.6 ± 1.6% | 3044.1 ± 0.7% | 500.0 ± 0.4% | 1930.9 ± 0.4% | 804.5 ± 1.0% | 1.714 | 2.225 | 13.549 | 3.508 | 8.420 |
| string: http/json-1m | 1190272 | 3171.3 ± 0.2% | 1353.3 ± 0.2% | 1555.2 ± 0.7% | 443.3 ± 0.5% | 1071.7 ± 0.2% | 765.5 ± 0.3% | 2.343 | 2.039 | 7.154 | 2.959 | 4.143 |
| string: http/js-1m | 1144362 | 2777.8 ± 0.7% | 1174.5 ± 0.3% | 1625.5 ± 0.4% | 369.0 ± 0.4% | 1110.1 ± 0.2% | 757.7 ± 0.2% | 2.365 | 1.709 | 7.529 | 2.502 | 3.666 |
| string: http/css-1m | 1097820 | 4005.0 ± 1.5% | 1488.8 ± 1.4% | 2155.7 ± 0.5% | 493.4 ± 0.6% | 1378.5 ± 0.3% | 895.1 ± 0.2% | 2.690 | 1.858 | 8.117 | 2.905 | 4.474 |
| string: dickens as Cyrillic and CJK | 1883069 | 3071.7 ± 0.5% | 2336.1 ± 0.6% | 521.0 ± 0.5% | 307.1 ± 0.8% | 565.1 ± 0.6% | 336.2 ± 0.3% | 1.315 | 5.896 | 10.004 | 5.436 | 9.135 |
| hex: silesia/dickens | 524290 | 15661.4 ± 0.3% | 1462.9 ± 0.2% | 1083.2 ± 0.3% | 500.2 ± 1.0% | 989.8 ± 0.3% | 733.4 ± 0.3% | 10.706 | 14.459 | 31.310 | 15.823 | 21.355 |
| hex: silesia/mozilla | 524290 | 15670.1 ± 0.2% | 1470.5 ± 0.4% | 1088.3 ± 0.1% | 442.7 ± 0.4% | 993.4 ± 0.5% | 734.3 ± 0.5% | 10.656 | 14.399 | 35.396 | 15.774 | 21.339 |
| hex: silesia/mr | 524290 | 15646.8 ± 0.3% | 1481.6 ± 0.2% | 1091.4 ± 0.2% | 553.3 ± 3.0% | 996.5 ± 0.4% | 734.7 ± 0.4% | 10.561 | 14.337 | 28.278 | 15.701 | 21.297 |
| hex: silesia/nci | 524290 | 15578.6 ± 0.3% | 1474.1 ± 0.5% | 1092.1 ± 0.2% | 633.3 ± 1.4% | 993.4 ± 0.5% | 733.7 ± 0.2% | 10.568 | 14.265 | 24.599 | 15.682 | 21.232 |
| hex: silesia/ooffice | 524290 | 15669.8 ± 0.1% | 1466.8 ± 0.2% | 1085.4 ± 0.6% | 388.5 ± 0.3% | 991.9 ± 0.5% | 735.1 ± 0.7% | 10.683 | 14.436 | 40.331 | 15.798 | 21.316 |
| hex: silesia/osdb | 524290 | 15640.4 ± 0.1% | 1466.0 ± 0.1% | 1087.5 ± 0.1% | 468.0 ± 3.8% | 990.7 ± 0.3% | 735.1 ± 0.3% | 10.669 | 14.382 | 33.421 | 15.787 | 21.277 |
| hex: silesia/reymont | 524290 | 15655.1 ± 0.4% | 1464.2 ± 0.5% | 1084.8 ± 0.4% | 514.3 ± 1.2% | 990.5 ± 0.4% | 734.4 ± 0.7% | 10.692 | 14.431 | 30.437 | 15.805 | 21.317 |
| hex: silesia/samba | 524290 | 15661.0 ± 0.2% | 1466.8 ± 0.4% | 1087.7 ± 0.2% | 402.9 ± 0.4% | 990.8 ± 0.4% | 735.1 ± 0.2% | 10.677 | 14.398 | 38.874 | 15.807 | 21.306 |
| hex: silesia/sao | 524290 | 15681.7 ± 0.1% | 1465.6 ± 0.1% | 1084.6 ± 0.5% | 332.3 ± 0.3% | 992.1 ± 0.4% | 734.8 ± 0.3% | 10.700 | 14.459 | 47.196 | 15.806 | 21.343 |
| hex: silesia/webster | 524290 | 15617.8 ± 0.5% | 1463.6 ± 0.2% | 1085.5 ± 0.3% | 475.1 ± 1.1% | 992.5 ± 0.3% | 734.8 ± 0.7% | 10.671 | 14.387 | 32.876 | 15.736 | 21.254 |
| hex: silesia/x-ray | 524290 | 15636.9 ± 0.1% | 1475.8 ± 0.2% | 1089.8 ± 0.6% | 445.0 ± 0.8% | 995.3 ± 0.4% | 734.2 ± 0.5% | 10.596 | 14.348 | 35.137 | 15.711 | 21.299 |
| hex: silesia/xml | 524290 | 15663.7 ± 0.2% | 1469.9 ± 0.2% | 1088.7 ± 0.3% | 607.1 ± 0.6% | 992.6 ± 0.5% | 734.6 ± 0.2% | 10.656 | 14.388 | 25.801 | 15.781 | 21.324 |
| hex: canterbury/alice29.txt | 304180 | 15675.0 ± 0.1% | 1469.7 ± 0.6% | 1089.4 ± 0.5% | 502.5 ± 1.8% | 993.4 ± 0.6% | 734.8 ± 0.2% | 10.666 | 14.389 | 31.197 | 15.779 | 21.332 |
| hex: canterbury/asyoulik.txt | 250360 | 15721.2 ± 0.0% | 1477.8 ± 0.5% | 1090.8 ± 0.4% | 498.4 ± 1.2% | 992.9 ± 0.1% | 741.0 ± 0.2% | 10.638 | 14.413 | 31.543 | 15.833 | 21.217 |
| hex: canterbury/cp.html | 49208 | 15668.9 ± 0.1% | 1473.1 ± 0.6% | 1098.9 ± 0.3% | 518.8 ± 2.3% | 1003.1 ± 0.5% | 743.7 ± 0.2% | 10.636 | 14.258 | 30.205 | 15.621 | 21.069 |
| hex: canterbury/fields.c | 22302 | 15524.8 ± 0.0% | 1426.7 ± 1.0% | 1078.8 ± 0.4% | 631.0 ± 5.8% | 991.7 ± 0.3% | 737.0 ± 0.3% | 10.882 | 14.391 | 24.602 | 15.654 | 21.066 |
| hex: canterbury/grammar.lsp | 7444 | 15157.5 ± 0.0% | 1505.7 ± 0.3% | 1095.2 ± 0.3% | 663.5 ± 4.7% | 998.1 ± 0.4% | 726.7 ± 0.2% | 10.067 | 13.839 | 22.846 | 15.186 | 20.858 |
| hex: canterbury/kennedy.xls | 524290 | 15640.7 ± 0.2% | 1476.0 ± 0.3% | 1089.4 ± 0.2% | 662.8 ± 2.1% | 991.9 ± 0.5% | 735.2 ± 0.4% | 10.596 | 14.357 | 23.597 | 15.768 | 21.273 |
| hex: canterbury/lcet10.txt | 524290 | 15655.1 ± 0.2% | 1465.6 ± 0.1% | 1084.2 ± 0.2% | 503.0 ± 1.0% | 991.6 ± 0.3% | 734.3 ± 0.4% | 10.682 | 14.439 | 31.122 | 15.787 | 21.319 |
| hex: canterbury/plrabn12.txt | 524290 | 15672.3 ± 0.5% | 1464.8 ± 0.6% | 1082.3 ± 0.2% | 495.6 ± 1.1% | 992.1 ± 0.8% | 734.2 ± 0.5% | 10.699 | 14.481 | 31.623 | 15.797 | 21.345 |
| hex: canterbury/ptt5 | 524290 | 15667.2 ± 0.3% | 1481.7 ± 0.9% | 1088.1 ± 0.5% | 553.3 ± 0.2% | 998.4 ± 0.5% | 734.8 ± 0.6% | 10.574 | 14.398 | 28.313 | 15.692 | 21.322 |
| hex: canterbury/sum | 76482 | 15680.9 ± 0.0% | 1495.1 ± 0.1% | 1105.0 ± 0.2% | 591.4 ± 2.8% | 999.1 ± 0.1% | 744.4 ± 0.1% | 10.488 | 14.191 | 26.515 | 15.695 | 21.065 |
| hex: canterbury/xargs.1 | 8456 | 15208.3 ± 0.1% | 1492.8 ± 0.5% | 1095.4 ± 0.7% | 637.0 ± 6.8% | 1004.8 ± 0.1% | 729.1 ± 0.1% | 10.188 | 13.884 | 23.875 | 15.136 | 20.858 |
| hex: canterbury-large/E.coli | 524290 | 15675.1 ± 0.1% | 1473.5 ± 1.0% | 1089.1 ± 0.7% | 673.6 ± 0.2% | 994.2 ± 0.6% | 733.6 ± 0.3% | 10.638 | 14.392 | 23.271 | 15.766 | 21.368 |
| hex: canterbury-large/bible.txt | 524290 | 15647.5 ± 0.4% | 1467.7 ± 0.4% | 1083.2 ± 0.2% | 515.6 ± 0.7% | 991.6 ± 0.8% | 734.5 ± 0.5% | 10.661 | 14.446 | 30.346 | 15.780 | 21.304 |
| hex: canterbury-large/world192.txt | 524290 | 15618.6 ± 0.2% | 1465.2 ± 0.2% | 1086.8 ± 0.6% | 502.4 ± 0.3% | 988.0 ± 0.7% | 733.3 ± 0.6% | 10.659 | 14.371 | 31.088 | 15.808 | 21.298 |
| hex: http/html-1kx1024 | 2099200 | 14207.4 ± 2.5% | 1456.8 ± 0.4% | 1062.7 ± 0.2% | 500.7 ± 0.3% | 983.1 ± 0.3% | 693.0 ± 0.1% | 9.752 | 13.369 | 28.372 | 14.451 | 20.502 |
| hex: http/html-16kx64 | 2097280 | 15386.0 ± 0.6% | 1444.7 ± 0.5% | 1075.8 ± 0.5% | 508.0 ± 0.3% | 997.4 ± 0.2% | 734.5 ± 0.1% | 10.650 | 14.301 | 30.286 | 15.426 | 20.948 |
| hex: http/html-1m | 524290 | 15671.2 ± 0.2% | 1468.2 ± 0.4% | 1085.2 ± 0.4% | 500.6 ± 0.5% | 992.3 ± 0.6% | 735.6 ± 0.9% | 10.673 | 14.440 | 31.304 | 15.792 | 21.303 |
| hex: http/json-1kx1024 | 2099200 | 14152.7 ± 0.5% | 1461.7 ± 0.2% | 1066.0 ± 0.2% | 608.7 ± 0.8% | 986.2 ± 0.1% | 693.0 ± 0.1% | 9.683 | 13.276 | 23.253 | 14.350 | 20.423 |
| hex: http/json-16kx64 | 2097280 | 15364.5 ± 0.3% | 1445.7 ± 0.2% | 1076.1 ± 0.1% | 615.3 ± 0.4% | 995.2 ± 0.4% | 734.0 ± 0.1% | 10.628 | 14.278 | 24.972 | 15.439 | 20.932 |
| hex: http/json-1m | 524290 | 15702.7 ± 0.2% | 1476.2 ± 0.2% | 1087.1 ± 0.5% | 631.6 ± 1.2% | 993.8 ± 0.5% | 733.8 ± 0.5% | 10.637 | 14.445 | 24.862 | 15.801 | 21.400 |
| hex: http/js-1kx1024 | 2099200 | 14179.6 ± 0.5% | 1455.4 ± 0.1% | 1062.7 ± 0.2% | 499.8 ± 0.2% | 982.9 ± 0.1% | 693.0 ± 0.0% | 9.743 | 13.342 | 28.369 | 14.426 | 20.462 |
| hex: http/js-16kx64 | 2097280 | 15353.4 ± 0.4% | 1445.7 ± 0.1% | 1075.1 ± 0.1% | 506.1 ± 0.4% | 996.3 ± 0.4% | 734.7 ± 0.2% | 10.620 | 14.281 | 30.339 | 15.410 | 20.897 |
| hex: http/js-1m | 524290 | 15678.3 ± 0.4% | 1467.0 ± 0.3% | 1083.1 ± 0.3% | 511.9 ± 0.6% | 988.9 ± 0.3% | 733.9 ± 1.2% | 10.687 | 14.475 | 30.628 | 15.854 | 21.364 |
| hex: http/css-1kx1024 | 2099200 | 14112.4 ± 0.4% | 1456.0 ± 0.2% | 1063.2 ± 0.5% | 530.8 ± 0.4% | 982.7 ± 0.1% | 693.0 ± 0.3% | 9.692 | 13.273 | 26.585 | 14.361 | 20.363 |
| hex: http/css-16kx64 | 2097280 | 15346.9 ± 0.4% | 1440.8 ± 0.2% | 1073.3 ± 0.3% | 540.6 ± 0.4% | 995.0 ± 0.4% | 733.9 ± 0.1% | 10.651 | 14.299 | 28.389 | 15.424 | 20.910 |
| hex: http/css-1m | 524290 | 15597.8 ± 0.4% | 1466.9 ± 0.3% | 1084.8 ± 0.4% | 526.5 ± 0.5% | 989.5 ± 1.0% | 733.8 ± 2.0% | 10.633 | 14.378 | 29.627 | 15.763 | 21.256 |
| hex: shuffled/dickens-1m | 524290 | 15670.1 ± 0.3% | 1464.4 ± 0.3% | 1082.5 ± 0.5% | 495.1 ± 2.5% | 989.8 ± 0.7% | 734.3 ± 0.4% | 10.700 | 14.476 | 31.650 | 15.831 | 21.341 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.922 of yyjson.
