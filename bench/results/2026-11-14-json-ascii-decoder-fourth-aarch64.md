# bench-json

| Field | Value |
|---|---|
| Commit | 862cb69 |
| Runner label | ubuntu-24.04-arm |
| Image version | 20261111.182.1 |
| CPU model | Neoverse-N2 |
| Virtual CPUs | 4 |
| Kernel | 7.0.0-1017-azure |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/43625768273 |
| Date | 2026-11-14 |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1. The `TextReader.next_items` column is that helper's queued tokens a slice a call (decision 79), over many tokens a call.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | TextReader.next_items | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1129.9 ± 0.1% | 0.522 | 0.963 | 0.994 | 0.997 | 0.459 | 1.003 | 1.006 | 0.387 | 0.830 | 0.898 | 0.100 |
| qlog records, JSON text sequence | 1467503 | 850.2 ± 1.1% | 0.821 | 1.003 | 1.003 | 1.004 | 0.446 | 0.997 | 1.027 | 0.400 | 0.926 | 0.990 | 0.125 |
| string: silesia/dickens | 172528 | 5043.0 ± 0.5% | 0.033 | 0.783 | 1.004 | 1.005 | 0.196 | 1.019 | 1.007 | 0.196 | 1.002 | 1.003 | 0.033 |
| string: silesia/nci | 1075110 | 4292.3 ± 0.7% | 0.039 | 0.803 | 1.004 | 1.006 | 0.280 | 1.008 | 1.000 | 0.279 | 1.004 | 1.004 | 0.038 |
| string: silesia/reymont | 1075159 | 2936.8 ± 1.5% | 0.057 | 0.821 | 1.000 | 1.003 | 0.359 | 1.005 | 1.010 | 0.359 | 1.017 | 1.011 | 0.056 |
| string: silesia/samba | 97582 | 3495.3 ± 0.3% | 0.040 | 0.862 | 1.003 | 1.005 | 0.068 | 0.778 | 1.009 | 0.072 | 1.003 | 1.006 | 0.039 |
| string: silesia/webster | 1098490 | 3638.7 ± 0.6% | 0.045 | 0.850 | 1.005 | 1.008 | 0.204 | 1.020 | 1.017 | 0.204 | 1.011 | 1.008 | 0.044 |
| string: silesia/xml | 1090118 | 4763.7 ± 0.3% | 0.035 | 0.813 | 1.011 | 1.012 | 0.223 | 0.982 | 1.008 | 0.225 | 1.012 | 1.013 | 0.035 |
| string: canterbury/alice29.txt | 159425 | 4300.4 ± 0.5% | 0.038 | 0.753 | 1.006 | 1.009 | 0.172 | 1.038 | 1.021 | 0.172 | 1.013 | 1.015 | 0.037 |
| string: canterbury/asyoulik.txt | 132198 | 3457.1 ± 0.8% | 0.046 | 0.748 | 1.005 | 1.009 | 0.176 | 1.003 | 0.972 | 0.176 | 1.012 | 1.014 | 0.045 |
| string: canterbury/lcet10.txt | 441884 | 5104.7 ± 0.6% | 0.032 | 0.817 | 1.003 | 1.004 | 0.196 | 1.022 | 1.007 | 0.195 | 1.004 | 1.005 | 0.032 |
| string: canterbury/plrabn12.txt | 503330 | 4116.4 ± 0.4% | 0.040 | 0.827 | 1.005 | 1.002 | 0.199 | 1.010 | 0.999 | 0.198 | 1.004 | 1.003 | 0.039 |
| string: canterbury-large/E.coli | 1048578 | 19114.8 ± 1.4% | 0.077 | 1.010 | 1.012 | 1.012 | 0.482 | 1.012 | 1.011 | 0.484 | 0.623 | 0.624 | 0.009 |
| string: canterbury-large/bible.txt | 1055886 | 6676.9 ± 1.1% | 0.026 | 0.802 | 1.007 | 1.010 | 0.433 | 1.032 | 1.044 | 0.434 | 1.037 | 1.042 | 0.026 |
| string: canterbury-large/world192.txt | 1103121 | 3400.5 ± 0.6% | 0.047 | 0.843 | 1.000 | 1.001 | 0.196 | 1.011 | 1.003 | 0.196 | 1.000 | 0.999 | 0.047 |
| string: http/html-1m | 1058582 | 6099.3 ± 2.1% | 0.028 | 0.780 | 1.004 | 1.038 | 0.386 | 1.037 | 1.047 | 0.386 | 1.023 | 1.024 | 0.028 |
| string: http/json-1m | 1190272 | 2551.7 ± 0.9% | 0.055 | 0.951 | 1.004 | 1.005 | 0.111 | 1.005 | 0.471 | 0.111 | 1.000 | 1.004 | 0.055 |
| string: http/js-1m | 1144362 | 2284.9 ± 0.7% | 0.066 | 0.889 | 1.000 | 1.002 | 0.174 | 1.055 | 1.044 | 0.174 | 1.002 | 1.004 | 0.066 |
| string: http/css-1m | 1097820 | 2639.8 ± 0.7% | 0.060 | 0.777 | 1.006 | 1.007 | 0.240 | 1.007 | 1.014 | 0.239 | 1.007 | 1.010 | 0.060 |
| string: dickens as Cyrillic and CJK | 1883069 | 3075.3 ± 0.6% | 0.044 | 0.124 | 1.005 | 1.003 | 0.336 | 0.998 | 1.008 | 0.336 | 1.004 | 1.003 | 0.044 |
| string: dickens as Cyrillic and CJK, as \u escapes | 5075485 | 1328.4 ± 2.0% | 0.081 | 1.003 | 1.002 | 1.003 | 0.076 | 0.637 | 1.005 | 0.081 | 1.002 | 1.002 | 0.081 |
| hex: silesia/dickens | 524290 | 18129.4 ± 1.0% | 0.082 | 1.008 | 1.001 | 1.001 | 0.537 | 1.003 | 1.002 | 0.533 | 0.662 | 0.662 | 0.010 |
| hex: silesia/mozilla | 524290 | 18745.1 ± 1.6% | 0.079 | 1.001 | 1.000 | 0.997 | 0.513 | 0.992 | 0.995 | 0.516 | 0.639 | 0.639 | 0.009 |
| hex: silesia/mr | 524290 | 18525.4 ± 0.6% | 0.080 | 0.999 | 0.999 | 0.995 | 0.524 | 0.993 | 0.997 | 0.525 | 0.648 | 0.648 | 0.009 |
| hex: silesia/nci | 524290 | 18587.2 ± 0.6% | 0.080 | 1.000 | 1.006 | 1.006 | 0.508 | 0.998 | 1.000 | 0.508 | 0.646 | 0.646 | 0.009 |
| hex: silesia/ooffice | 524290 | 18570.4 ± 0.6% | 0.080 | 1.000 | 1.000 | 0.999 | 0.530 | 0.998 | 0.998 | 0.531 | 0.646 | 0.647 | 0.009 |
| hex: silesia/osdb | 524290 | 18665.7 ± 1.0% | 0.080 | 0.995 | 0.998 | 0.998 | 0.507 | 1.000 | 0.998 | 0.510 | 0.644 | 0.644 | 0.009 |
| hex: silesia/reymont | 524290 | 18676.5 ± 1.2% | 0.079 | 1.009 | 1.004 | 0.998 | 0.504 | 1.000 | 0.997 | 0.505 | 0.642 | 0.642 | 0.009 |
| hex: silesia/samba | 524290 | 18377.1 ± 0.6% | 0.081 | 1.004 | 0.997 | 0.997 | 0.517 | 1.000 | 0.999 | 0.518 | 0.653 | 0.653 | 0.009 |
| hex: silesia/sao | 524290 | 18591.0 ± 0.8% | 0.080 | 1.010 | 1.007 | 1.007 | 0.521 | 1.006 | 1.001 | 0.521 | 0.647 | 0.647 | 0.009 |
| hex: silesia/webster | 524290 | 18826.6 ± 0.6% | 0.079 | 1.010 | 1.001 | 0.996 | 0.516 | 0.992 | 0.995 | 0.518 | 0.639 | 0.639 | 0.009 |
| hex: silesia/x-ray | 524290 | 18517.2 ± 0.4% | 0.080 | 1.008 | 1.002 | 1.003 | 0.517 | 1.003 | 1.001 | 0.519 | 0.645 | 0.645 | 0.009 |
| hex: silesia/xml | 524290 | 18666.7 ± 0.6% | 0.080 | 1.006 | 1.005 | 1.005 | 0.513 | 1.005 | 1.000 | 0.513 | 0.643 | 0.643 | 0.009 |
| hex: canterbury/alice29.txt | 304180 | 19540.0 ± 0.2% | 0.077 | 1.002 | 1.002 | 1.002 | 0.514 | 1.003 | 1.002 | 0.514 | 0.614 | 0.615 | 0.009 |
| hex: canterbury/asyoulik.txt | 250360 | 19524.2 ± 0.1% | 0.077 | 1.002 | 0.992 | 0.992 | 0.513 | 0.976 | 1.002 | 0.514 | 0.615 | 0.615 | 0.009 |
| hex: canterbury/cp.html | 49208 | 19286.3 ± 0.1% | 0.082 | 1.002 | 1.001 | 1.001 | 0.543 | 1.001 | 1.002 | 0.545 | 0.618 | 0.618 | 0.009 |
| hex: canterbury/fields.c | 22302 | 18822.1 ± 0.7% | 0.081 | 1.007 | 1.008 | 1.008 | 0.537 | 1.004 | 1.008 | 0.542 | 0.626 | 0.626 | 0.009 |
| hex: canterbury/grammar.lsp | 7444 | 17452.0 ± 2.0% | 0.087 | 1.008 | 1.008 | 1.009 | 0.531 | 1.007 | 1.007 | 0.547 | 0.645 | 0.648 | 0.010 |
| hex: canterbury/kennedy.xls | 524290 | 18406.6 ± 1.8% | 0.081 | 1.003 | 1.004 | 1.003 | 0.529 | 0.997 | 1.005 | 0.527 | 0.653 | 0.653 | 0.009 |
| hex: canterbury/lcet10.txt | 524290 | 18565.0 ± 0.2% | 0.080 | 1.009 | 1.000 | 1.000 | 0.515 | 0.999 | 0.999 | 0.517 | 0.645 | 0.646 | 0.009 |
| hex: canterbury/plrabn12.txt | 524290 | 18596.5 ± 0.3% | 0.080 | 1.000 | 0.995 | 0.994 | 0.522 | 0.997 | 1.001 | 0.522 | 0.646 | 0.646 | 0.009 |
| hex: canterbury/ptt5 | 524290 | 18466.4 ± 1.2% | 0.081 | 1.006 | 0.997 | 1.000 | 0.525 | 0.998 | 0.996 | 0.525 | 0.649 | 0.649 | 0.009 |
| hex: canterbury/sum | 76482 | 19292.8 ± 0.1% | 0.078 | 1.002 | 1.002 | 1.002 | 0.518 | 1.002 | 1.002 | 0.520 | 0.617 | 0.617 | 0.009 |
| hex: canterbury/xargs.1 | 8456 | 17810.5 ± 0.1% | 0.088 | 1.001 | 1.001 | 1.002 | 0.525 | 1.000 | 1.001 | 0.540 | 0.637 | 0.637 | 0.010 |
| hex: canterbury-large/E.coli | 524290 | 18623.6 ± 0.8% | 0.080 | 1.008 | 1.003 | 1.002 | 0.530 | 0.999 | 0.999 | 0.529 | 0.645 | 0.645 | 0.009 |
| hex: canterbury-large/bible.txt | 524290 | 18606.2 ± 0.5% | 0.080 | 1.007 | 1.002 | 1.002 | 0.528 | 1.005 | 1.000 | 0.527 | 0.646 | 0.646 | 0.009 |
| hex: canterbury-large/world192.txt | 524290 | 18493.6 ± 0.6% | 0.080 | 1.005 | 1.002 | 1.001 | 0.510 | 0.997 | 0.999 | 0.510 | 0.646 | 0.647 | 0.009 |
| hex: http/html-1kx1024 | 2099200 | 9384.9 ± 18.7% | 0.151 | 1.265 | 1.264 | 1.263 | 0.706 | 1.268 | 0.988 | 0.771 | 0.941 | 0.945 | 0.018 |
| hex: http/html-16kx64 | 2097280 | 18230.0 ± 0.4% | 0.082 | 1.016 | 1.012 | 1.013 | 0.562 | 1.016 | 0.990 | 0.568 | 0.646 | 0.646 | 0.010 |
| hex: http/html-1m | 524290 | 18386.9 ± 0.8% | 0.081 | 1.014 | 1.008 | 1.004 | 0.520 | 1.005 | 1.008 | 0.519 | 0.653 | 0.654 | 0.009 |
| hex: http/json-1kx1024 | 2099200 | 9514.8 ± 18.6% | 0.149 | 1.262 | 1.259 | 1.261 | 0.695 | 1.256 | 0.990 | 0.765 | 0.926 | 0.938 | 0.018 |
| hex: http/json-16kx64 | 2097280 | 18345.0 ± 0.4% | 0.082 | 1.014 | 1.011 | 1.010 | 0.558 | 1.009 | 0.988 | 0.564 | 0.641 | 0.642 | 0.009 |
| hex: http/json-1m | 524290 | 18611.1 ± 1.1% | 0.080 | 1.009 | 0.993 | 0.989 | 0.511 | 1.002 | 0.997 | 0.509 | 0.645 | 0.645 | 0.009 |
| hex: http/js-1kx1024 | 2099200 | 9602.1 ± 16.5% | 0.148 | 1.247 | 1.240 | 1.245 | 0.686 | 1.241 | 0.968 | 0.754 | 0.917 | 0.924 | 0.018 |
| hex: http/js-16kx64 | 2097280 | 18279.2 ± 0.4% | 0.082 | 1.013 | 1.010 | 1.009 | 0.560 | 1.013 | 0.987 | 0.565 | 0.644 | 0.645 | 0.010 |
| hex: http/js-1m | 524290 | 18581.3 ± 1.1% | 0.080 | 1.008 | 1.000 | 1.002 | 0.512 | 1.000 | 0.996 | 0.511 | 0.644 | 0.644 | 0.009 |
| hex: http/css-1kx1024 | 2099200 | 9567.6 ± 16.5% | 0.147 | 1.250 | 1.249 | 1.248 | 0.685 | 1.247 | 0.969 | 0.759 | 0.919 | 0.925 | 0.018 |
| hex: http/css-16kx64 | 2097280 | 18369.7 ± 0.4% | 0.082 | 1.008 | 1.007 | 1.006 | 0.558 | 1.009 | 0.990 | 0.563 | 0.642 | 0.641 | 0.009 |
| hex: http/css-1m | 524290 | 18535.6 ± 0.7% | 0.080 | 1.009 | 1.008 | 1.006 | 0.521 | 1.002 | 1.007 | 0.522 | 0.648 | 0.649 | 0.009 |
| hex: shuffled/dickens-1m | 524290 | 18343.5 ± 0.6% | 0.081 | 0.999 | 1.001 | 1.002 | 0.512 | 0.997 | 1.001 | 0.514 | 0.651 | 0.651 | 0.009 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1481.9 ± 1.1% | 0.443 | 1.000 | 0.969 | 1.006 | 1.011 | 0.269 | 1.001 | 0.548 | 0.917 | 0.089 | 1.029 |
| qlog records, JSON text sequence | 1467503 | 1271.7 ± 1.5% | 0.690 | 0.978 | 1.011 | 1.013 | 1.013 | 0.263 | 1.002 | 0.501 | 0.828 | 0.106 | 1.020 |
| string: silesia/dickens | 172528 | 6889.5 ± 0.2% | 0.025 | 1.002 | 1.002 | 1.002 | 1.002 | 0.167 | 0.717 | 1.002 | 1.002 | 0.025 | 1.034 |
| string: silesia/nci | 1075110 | 7297.9 ± 0.4% | 0.023 | 1.000 | 1.002 | 1.002 | 1.003 | 0.212 | 0.566 | 1.001 | 1.002 | 0.024 | 0.949 |
| string: silesia/reymont | 1075159 | 3338.5 ± 1.7% | 0.051 | 1.001 | 0.994 | 0.993 | 1.001 | 0.391 | 0.877 | 0.993 | 0.997 | 0.052 | 1.037 |
| string: silesia/samba | 97582 | 4180.0 ± 1.1% | 0.053 | 1.003 | 1.000 | 1.007 | 1.009 | 0.125 | 0.945 | 1.006 | 1.008 | 0.054 | 1.097 |
| string: silesia/webster | 1098490 | 4040.0 ± 0.5% | 0.042 | 1.013 | 1.011 | 1.011 | 1.013 | 0.213 | 0.891 | 1.006 | 1.009 | 0.043 | 1.015 |
| string: silesia/xml | 1090118 | 6107.6 ± 0.6% | 0.029 | 1.005 | 0.998 | 1.004 | 1.007 | 0.254 | 0.778 | 1.001 | 1.005 | 0.029 | 1.023 |
| string: canterbury/alice29.txt | 159425 | 6428.4 ± 2.0% | 0.027 | 1.010 | 1.010 | 1.010 | 1.012 | 0.132 | 0.653 | 1.002 | 1.004 | 0.027 | 1.061 |
| string: canterbury/asyoulik.txt | 132198 | 5564.6 ± 1.5% | 0.030 | 1.029 | 1.036 | 1.038 | 1.038 | 0.130 | 0.598 | 1.008 | 1.018 | 0.030 | 1.059 |
| string: canterbury/lcet10.txt | 441884 | 6253.1 ± 0.4% | 0.027 | 1.006 | 1.007 | 1.008 | 1.007 | 0.184 | 0.799 | 0.999 | 1.000 | 0.028 | 1.001 |
| string: canterbury/plrabn12.txt | 503330 | 5717.5 ± 0.4% | 0.030 | 1.002 | 1.002 | 1.003 | 1.003 | 0.168 | 0.697 | 1.001 | 1.002 | 0.030 | 1.008 |
| string: canterbury-large/E.coli | 1048578 | 19338.0 ± 0.6% | 0.077 | 1.001 | 1.001 | 1.000 | 1.000 | 0.477 | 1.003 | 1.000 | 1.004 | 0.009 | 1.000 |
| string: canterbury-large/bible.txt | 1055886 | 6795.7 ± 0.9% | 0.026 | 0.998 | 1.001 | 1.002 | 1.001 | 0.496 | 0.974 | 1.000 | 1.000 | 0.026 | 0.999 |
| string: canterbury-large/world192.txt | 1103121 | 4019.4 ± 0.2% | 0.042 | 1.019 | 1.015 | 1.017 | 1.016 | 0.193 | 0.834 | 1.002 | 1.011 | 0.043 | 1.004 |
| string: http/html-1m | 1058582 | 6752.9 ± 1.0% | 0.026 | 1.005 | 0.923 | 1.002 | 1.008 | 0.405 | 0.882 | 1.001 | 1.003 | 0.026 | 1.011 |
| string: http/json-1m | 1190272 | 3154.4 ± 0.2% | 0.051 | 1.005 | 0.971 | 1.004 | 1.006 | 0.133 | 0.372 | 1.004 | 1.005 | 0.051 | 1.046 |
| string: http/js-1m | 1144362 | 2764.0 ± 0.5% | 0.060 | 1.002 | 1.008 | 0.999 | 1.004 | 0.165 | 0.840 | 1.001 | 1.005 | 0.061 | 1.016 |
| string: http/css-1m | 1097820 | 3982.3 ± 0.6% | 0.044 | 1.007 | 1.004 | 1.008 | 1.009 | 0.208 | 0.647 | 0.999 | 1.006 | 0.043 | 1.013 |
| string: dickens as Cyrillic and CJK | 1883069 | 3075.4 ± 0.5% | 0.048 | 0.999 | 0.124 | 0.998 | 1.000 | 0.320 | 1.000 | 1.000 | 1.001 | 0.048 | 1.000 |
| hex: silesia/dickens | 524290 | 15657.4 ± 0.1% | 1.002 | 0.178 | 1.001 | 1.000 | 1.001 | 1.000 | 1.001 | 1.000 | 1.000 | 0.177 | 1.002 |
| hex: silesia/mozilla | 524290 | 15663.7 ± 0.2% | 1.001 | 0.178 | 0.998 | 0.999 | 1.001 | 0.996 | 0.998 | 1.000 | 0.997 | 0.178 | 1.000 |
| hex: silesia/mr | 524290 | 15665.9 ± 0.4% | 1.000 | 0.178 | 1.001 | 1.001 | 1.002 | 0.999 | 1.001 | 0.998 | 1.001 | 0.178 | 0.999 |
| hex: silesia/nci | 524290 | 15647.0 ± 0.3% | 1.000 | 0.178 | 1.003 | 1.001 | 0.998 | 0.998 | 1.000 | 0.999 | 1.002 | 0.178 | 1.000 |
| hex: silesia/ooffice | 524290 | 15621.1 ± 0.2% | 1.003 | 0.178 | 1.003 | 1.000 | 1.000 | 1.002 | 1.004 | 1.002 | 1.003 | 0.178 | 1.003 |
| hex: silesia/osdb | 524290 | 15660.5 ± 0.2% | 1.000 | 0.178 | 0.999 | 1.001 | 0.999 | 0.997 | 0.997 | 0.999 | 1.000 | 0.178 | 1.000 |
| hex: silesia/reymont | 524290 | 15672.3 ± 0.2% | 1.002 | 0.177 | 1.001 | 1.002 | 1.001 | 0.999 | 1.000 | 0.999 | 1.001 | 0.177 | 1.002 |
| hex: silesia/samba | 524290 | 15616.5 ± 0.3% | 1.003 | 0.178 | 1.004 | 1.000 | 1.001 | 1.003 | 1.005 | 1.002 | 1.004 | 0.178 | 1.003 |
| hex: silesia/sao | 524290 | 15637.5 ± 0.5% | 1.002 | 0.178 | 1.000 | 0.999 | 0.999 | 0.994 | 0.999 | 0.996 | 0.995 | 0.178 | 0.999 |
| hex: silesia/webster | 524290 | 15676.9 ± 0.3% | 1.000 | 0.178 | 1.003 | 1.002 | 1.003 | 1.002 | 1.002 | 1.000 | 1.002 | 0.177 | 1.002 |
| hex: silesia/x-ray | 524290 | 15630.9 ± 0.3% | 1.001 | 0.178 | 0.999 | 1.001 | 1.001 | 1.001 | 1.001 | 1.002 | 1.002 | 0.178 | 1.002 |
| hex: silesia/xml | 524290 | 15642.7 ± 0.2% | 1.000 | 0.178 | 1.000 | 1.000 | 0.999 | 1.001 | 1.000 | 0.999 | 0.999 | 0.178 | 0.999 |
| hex: canterbury/alice29.txt | 304180 | 15679.0 ± 0.0% | 1.001 | 0.178 | 1.001 | 1.000 | 1.001 | 1.000 | 1.001 | 1.001 | 1.001 | 0.177 | 1.001 |
| hex: canterbury/asyoulik.txt | 250360 | 15693.6 ± 0.1% | 1.001 | 0.178 | 1.001 | 1.001 | 1.001 | 1.000 | 1.001 | 1.000 | 1.000 | 0.177 | 1.000 |
| hex: canterbury/cp.html | 49208 | 15622.0 ± 0.1% | 1.001 | 0.179 | 1.000 | 1.000 | 1.000 | 0.998 | 1.001 | 1.001 | 1.003 | 0.179 | 1.001 |
| hex: canterbury/fields.c | 22302 | 15442.4 ± 0.1% | 1.002 | 0.181 | 1.000 | 1.000 | 1.000 | 0.994 | 1.001 | 1.002 | 1.005 | 0.180 | 1.001 |
| hex: canterbury/grammar.lsp | 7444 | 14948.3 ± 0.3% | 1.003 | 0.185 | 1.000 | 1.001 | 1.000 | 0.983 | 1.000 | 1.004 | 1.014 | 0.184 | 1.003 |
| hex: canterbury/kennedy.xls | 524290 | 15673.6 ± 0.1% | 1.000 | 0.178 | 1.000 | 1.000 | 0.999 | 0.999 | 0.999 | 1.000 | 0.996 | 0.178 | 0.999 |
| hex: canterbury/lcet10.txt | 524290 | 15635.1 ± 0.3% | 1.001 | 0.178 | 0.997 | 1.000 | 0.998 | 0.992 | 0.991 | 0.996 | 0.994 | 0.178 | 0.994 |
| hex: canterbury/plrabn12.txt | 524290 | 15685.9 ± 0.1% | 1.000 | 0.178 | 1.001 | 1.000 | 1.001 | 0.999 | 0.999 | 0.998 | 0.997 | 0.177 | 1.000 |
| hex: canterbury/ptt5 | 524290 | 15631.8 ± 0.3% | 1.002 | 0.179 | 1.002 | 1.001 | 1.001 | 1.001 | 1.000 | 1.000 | 1.000 | 0.179 | 1.000 |
| hex: canterbury/sum | 76482 | 15644.9 ± 0.0% | 1.001 | 0.179 | 1.000 | 1.000 | 1.000 | 0.999 | 1.000 | 1.000 | 1.002 | 0.178 | 1.001 |
| hex: canterbury/xargs.1 | 8456 | 15018.3 ± 0.1% | 1.001 | 0.183 | 1.000 | 1.000 | 1.000 | 0.984 | 1.001 | 1.002 | 1.012 | 0.183 | 1.002 |
| hex: canterbury-large/E.coli | 524290 | 15687.6 ± 0.2% | 1.000 | 0.177 | 0.997 | 0.999 | 0.998 | 0.998 | 0.996 | 1.000 | 1.000 | 0.178 | 0.997 |
| hex: canterbury-large/bible.txt | 524290 | 15652.1 ± 0.3% | 0.999 | 0.178 | 0.999 | 0.999 | 0.999 | 1.000 | 0.998 | 0.998 | 0.999 | 0.178 | 0.998 |
| hex: canterbury-large/world192.txt | 524290 | 15599.9 ± 0.3% | 1.001 | 0.178 | 0.999 | 1.000 | 0.999 | 0.998 | 0.995 | 0.998 | 0.997 | 0.178 | 0.999 |
| hex: http/html-1kx1024 | 2099200 | 13682.6 ± 0.4% | 1.009 | 0.196 | 0.999 | 1.002 | 1.003 | 0.940 | 0.998 | 1.013 | 1.042 | 0.187 | 1.011 |
| hex: http/html-16kx64 | 2097280 | 15262.2 ± 0.5% | 0.999 | 0.181 | 1.001 | 1.000 | 0.998 | 0.994 | 0.998 | 1.000 | 1.006 | 0.180 | 1.000 |
| hex: http/html-1m | 524290 | 15610.8 ± 0.2% | 1.004 | 0.178 | 1.003 | 0.999 | 0.997 | 1.000 | 1.005 | 1.000 | 1.002 | 0.178 | 1.004 |
| hex: http/json-1kx1024 | 2099200 | 13716.4 ± 0.7% | 1.003 | 0.196 | 1.000 | 1.003 | 1.000 | 0.939 | 0.995 | 1.011 | 1.035 | 0.187 | 1.009 |
| hex: http/json-16kx64 | 2097280 | 15249.8 ± 0.1% | 0.998 | 0.181 | 1.004 | 1.001 | 1.001 | 0.995 | 0.997 | 1.003 | 1.007 | 0.180 | 1.003 |
| hex: http/json-1m | 524290 | 15660.9 ± 0.3% | 1.001 | 0.178 | 1.002 | 1.000 | 1.000 | 1.000 | 0.998 | 0.998 | 0.999 | 0.178 | 1.000 |
| hex: http/js-1kx1024 | 2099200 | 13682.4 ± 0.8% | 1.005 | 0.196 | 1.003 | 1.003 | 1.002 | 0.939 | 0.997 | 1.013 | 1.037 | 0.187 | 1.012 |
| hex: http/js-16kx64 | 2097280 | 15192.6 ± 0.6% | 1.004 | 0.182 | 1.004 | 0.999 | 1.001 | 0.999 | 1.003 | 1.004 | 1.009 | 0.181 | 1.008 |
| hex: http/js-1m | 524290 | 15705.4 ± 0.1% | 1.001 | 0.177 | 1.001 | 1.000 | 0.998 | 0.998 | 0.999 | 1.000 | 1.000 | 0.177 | 1.000 |
| hex: http/css-1kx1024 | 2099200 | 13690.0 ± 0.4% | 1.002 | 0.195 | 0.999 | 1.001 | 1.002 | 0.937 | 0.995 | 1.009 | 1.034 | 0.187 | 1.009 |
| hex: http/css-16kx64 | 2097280 | 15223.9 ± 0.8% | 1.000 | 0.182 | 1.003 | 1.003 | 1.003 | 0.998 | 1.004 | 1.008 | 1.007 | 0.180 | 1.003 |
| hex: http/css-1m | 524290 | 15703.4 ± 0.3% | 1.001 | 0.177 | 0.997 | 1.001 | 1.000 | 0.997 | 0.997 | 0.997 | 0.998 | 0.177 | 0.998 |
| hex: shuffled/dickens-1m | 524290 | 15675.0 ± 0.4% | 1.001 | 0.178 | 0.999 | 0.999 | 1.000 | 0.999 | 0.999 | 0.998 | 0.999 | 0.177 | 1.000 |

## Losses

Each workload where a claim's path ran slower than the path it replaces by more than the noise floor of decision 20.

- string: http/js-1m, decoding: J12 decoder escape words off runs at 1.055 of all on.
- hex: http/html-1kx1024, decoding: J5 UTF-8 vectors off runs at 1.265 of all on.
- hex: http/html-1kx1024, decoding: J7 wide vectors off runs at 1.264 of all on.
- hex: http/html-1kx1024, decoding: J8 decoder fast path off runs at 1.263 of all on.
- hex: http/html-1kx1024, decoding: J12 decoder escape words off runs at 1.268 of all on.
- hex: http/json-1kx1024, decoding: J5 UTF-8 vectors off runs at 1.262 of all on.
- hex: http/json-1kx1024, decoding: J7 wide vectors off runs at 1.259 of all on.
- hex: http/json-1kx1024, decoding: J8 decoder fast path off runs at 1.261 of all on.
- hex: http/json-1kx1024, decoding: J12 decoder escape words off runs at 1.256 of all on.
- hex: http/js-1kx1024, decoding: J5 UTF-8 vectors off runs at 1.247 of all on.
- hex: http/js-1kx1024, decoding: J7 wide vectors off runs at 1.240 of all on.
- hex: http/js-1kx1024, decoding: J8 decoder fast path off runs at 1.245 of all on.
- hex: http/js-1kx1024, decoding: J12 decoder escape words off runs at 1.241 of all on.
- hex: http/css-1kx1024, decoding: J5 UTF-8 vectors off runs at 1.250 of all on.
- hex: http/css-1kx1024, decoding: J7 wide vectors off runs at 1.249 of all on.
- hex: http/css-1kx1024, decoding: J8 decoder fast path off runs at 1.248 of all on.
- hex: http/css-1kx1024, decoding: J12 decoder escape words off runs at 1.247 of all on.

## UTF-8 validation against simdutf

stdx's `is_utf8`, the check the loops apply to every string's octets, run alone over each string workload's octets at the width the host's features pick (16 lanes on aarch64, AVX2's 32 or AVX-512's 64 on x86-64, decision 39), beside simdutf 9.3.3's `validate_utf8` in the same run; on a host with AVX-512, again with AVX2 alone. Each ratio is stdx's throughput over the other's. simdutf picks its kernel at run time. Before timing, every copy of the check and simdutf judged 20000 seeded buffers and each workload, whole and changed, alike.

| Workload | Octets | stdx, MB/s | simdutf, MB/s | stdx / simdutf | stdx with AVX2 alone, MB/s | stdx / stdx with AVX2 alone |
|---|---|---|---|---|---|---|
| string: silesia/dickens | 166668 | 43336.1 ± 0.1% | 47392.9 ± 0.1% | 0.914 | — | — |
| string: silesia/nci | 1048576 | 37097.8 ± 4.1% | 39880.2 ± 3.8% | 0.930 | — | — |
| string: silesia/reymont | 1048576 | 35972.7 ± 1.8% | 38674.2 ± 1.6% | 0.930 | — | — |
| string: silesia/samba | 65546 | 43541.5 ± 0.1% | 48516.5 ± 0.0% | 0.897 | — | — |
| string: silesia/webster | 1048576 | 36145.6 ± 3.5% | 39392.5 ± 3.4% | 0.918 | — | — |
| string: silesia/xml | 1048576 | 32017.3 ± 1.8% | 32955.2 ± 1.7% | 0.972 | — | — |
| string: canterbury/alice29.txt | 152089 | 35889.0 ± 0.1% | 36545.6 ± 0.2% | 0.982 | — | — |
| string: canterbury/asyoulik.txt | 125179 | 43339.8 ± 0.2% | 47644.6 ± 0.1% | 0.910 | — | — |
| string: canterbury/lcet10.txt | 426754 | 36070.0 ± 0.0% | 36696.6 ± 0.1% | 0.983 | — | — |
| string: canterbury/plrabn12.txt | 481861 | 41836.9 ± 0.6% | 45505.0 ± 0.9% | 0.919 | — | — |
| string: canterbury-large/E.coli | 1048576 | 36379.2 ± 4.1% | 39011.4 ± 2.7% | 0.933 | — | — |
| string: canterbury-large/bible.txt | 1048576 | 32645.5 ± 1.9% | 33484.3 ± 1.9% | 0.975 | — | — |
| string: canterbury-large/world192.txt | 1048576 | 32237.7 ± 2.4% | 33106.6 ± 1.5% | 0.974 | — | — |
| string: http/html-1m | 1048576 | 35790.4 ± 1.8% | 38693.9 ± 1.4% | 0.925 | — | — |
| string: http/json-1m | 1048576 | 31523.8 ± 3.0% | 33644.8 ± 3.1% | 0.937 | — | — |
| string: http/js-1m | 1048576 | 35482.6 ± 2.9% | 37915.8 ± 3.1% | 0.936 | — | — |
| string: http/css-1m | 1048576 | 35965.2 ± 0.8% | 39052.5 ± 1.8% | 0.921 | — | — |
| string: dickens as Cyrillic and CJK | 1847045 | 5770.9 ± 0.2% | 5655.4 ± 0.1% | 1.020 | — | — |

## Losses to simdutf

- string: silesia/dickens: stdx runs at 0.914 of simdutf.
- string: silesia/nci: stdx runs at 0.930 of simdutf.
- string: silesia/reymont: stdx runs at 0.930 of simdutf.
- string: silesia/samba: stdx runs at 0.897 of simdutf.
- string: silesia/webster: stdx runs at 0.918 of simdutf.
- string: canterbury/asyoulik.txt: stdx runs at 0.910 of simdutf.
- string: canterbury/plrabn12.txt: stdx runs at 0.919 of simdutf.
- string: canterbury-large/E.coli: stdx runs at 0.933 of simdutf.
- string: http/html-1m: stdx runs at 0.925 of simdutf.
- string: http/json-1m: stdx runs at 0.937 of simdutf.
- string: http/js-1m: stdx runs at 0.936 of simdutf.
- string: http/css-1m: stdx runs at 0.921 of simdutf.

## UTF-8 validation by the buffer's offset from a 64-octet line

| Buffer | Octets | Offset | stdx, MB/s | simdutf, MB/s | stdx / simdutf | stdx with AVX2 alone, MB/s | stdx / stdx with AVX2 alone |
|---|---|---|---|---|---|---|---|
| string: canterbury-large/bible.txt | 1048576 | 0 | 39451.5 ± 4.2% | 43739.6 ± 5.2% | 0.902 | — | — |
| string: canterbury-large/bible.txt | 1048576 | 1 | 33856.2 ± 0.8% | 34562.5 ± 1.2% | 0.980 | — | — |
| string: canterbury-large/bible.txt | 1048576 | 8 | 38910.3 ± 1.4% | 42087.9 ± 1.8% | 0.925 | — | — |
| string: canterbury-large/bible.txt | 1048576 | 16 | 40511.3 ± 3.3% | 44493.2 ± 4.3% | 0.911 | — | — |
| string: canterbury-large/bible.txt | 1048576 | 32 | 40250.6 ± 3.6% | 44788.8 ± 2.1% | 0.899 | — | — |
| string: canterbury-large/bible.txt | 1048576 | 48 | 40242.5 ± 3.0% | 44155.7 ± 4.0% | 0.911 | — | — |
| string: dickens as Cyrillic and CJK | 1048576 | 0 | 5760.9 ± 0.5% | 5637.7 ± 0.2% | 1.022 | — | — |
| string: dickens as Cyrillic and CJK | 1048576 | 1 | 5754.3 ± 0.3% | 5637.0 ± 0.1% | 1.021 | — | — |
| string: dickens as Cyrillic and CJK | 1048576 | 8 | 5758.2 ± 0.2% | 5640.9 ± 0.2% | 1.021 | — | — |
| string: dickens as Cyrillic and CJK | 1048576 | 16 | 5759.3 ± 0.2% | 5640.9 ± 0.2% | 1.021 | — | — |
| string: dickens as Cyrillic and CJK | 1048576 | 32 | 5755.3 ± 0.1% | 5641.6 ± 0.3% | 1.020 | — | — |
| string: dickens as Cyrillic and CJK | 1048576 | 48 | 5759.7 ± 0.1% | 5638.7 ± 0.2% | 1.021 | — | — |

## Against the baselines

stdx with every claim on, timed beside simdjson 5.1.1, yyjson 0.13.0, Zig 0.16.0's std.json, serde_json 1.0.154 and Go's encoding/json/jsontext in the same run. Each ratio is stdx's throughput over the baseline's; below 1, the baseline is faster. stdx is built for the architecture's baseline CPU in ReleaseSafe. Each baseline is built for the same CPU, the C, C++ and Zig ones in ReleaseFast (decision 75), and simdjson picks its kernel at run time. Decoding visits every value; encoding writes each text from its tokens.

## Decoding against the baselines

Octets are the text's. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1129.9 ± 0.1% | 931.8 ± 0.4% | 1024.3 ± 0.2% | 301.5 ± 0.9% | 664.5 ± 0.2% | 310.9 ± 1.8% | 1.213 | 1.103 | 3.748 | 1.701 | 3.634 |
| qlog records, JSON text sequence | 1467503 | 850.2 ± 1.1% | 818.3 ± 0.1% | 807.0 ± 0.3% | 244.0 ± 0.6% | 700.6 ± 0.8% | 251.5 ± 0.5% | 1.039 | 1.054 | 3.484 | 1.214 | 3.381 |
| string: silesia/dickens | 172528 | 5043.0 ± 0.5% | 1877.2 ± 0.2% | 2646.7 ± 0.0% | 361.7 ± 0.7% | 2856.1 ± 0.3% | 552.7 ± 1.7% | 2.686 | 1.905 | 13.941 | 1.766 | 9.124 |
| string: silesia/nci | 1075110 | 4292.3 ± 0.7% | 2239.9 ± 0.3% | 2997.9 ± 0.4% | 543.2 ± 1.2% | 3017.9 ± 0.8% | 596.9 ± 1.4% | 1.916 | 1.432 | 7.903 | 1.422 | 7.191 |
| string: silesia/reymont | 1075159 | 2936.8 ± 1.5% | 1830.8 ± 2.1% | 2064.4 ± 0.3% | 374.9 ± 1.2% | 2145.2 ± 0.6% | 532.0 ± 0.8% | 1.604 | 1.423 | 7.834 | 1.369 | 5.520 |
| string: silesia/samba | 97582 | 3495.3 ± 0.3% | 2022.6 ± 0.6% | 2618.4 ± 0.4% | 329.3 ± 0.5% | 1500.5 ± 0.5% | 427.9 ± 1.6% | 1.728 | 1.335 | 10.614 | 2.330 | 8.168 |
| string: silesia/webster | 1098490 | 3638.7 ± 0.6% | 1518.9 ± 0.4% | 2017.2 ± 0.8% | 359.0 ± 0.6% | 2179.5 ± 0.6% | 494.2 ± 1.5% | 2.396 | 1.804 | 10.136 | 1.670 | 7.363 |
| string: silesia/xml | 1090118 | 4763.7 ± 0.3% | 2362.6 ± 0.3% | 2532.3 ± 0.2% | 456.1 ± 1.9% | 2863.7 ± 0.3% | 563.5 ± 1.5% | 2.016 | 1.881 | 10.444 | 1.663 | 8.454 |
| string: canterbury/alice29.txt | 159425 | 4300.4 ± 0.5% | 1599.3 ± 0.5% | 2459.7 ± 0.3% | 342.5 ± 0.6% | 2503.8 ± 0.4% | 507.4 ± 0.8% | 2.689 | 1.748 | 12.557 | 1.718 | 8.475 |
| string: canterbury/asyoulik.txt | 132198 | 3457.1 ± 0.8% | 1460.2 ± 0.1% | 2240.5 ± 0.6% | 336.3 ± 0.8% | 2082.6 ± 0.6% | 464.0 ± 1.5% | 2.368 | 1.543 | 10.280 | 1.660 | 7.450 |
| string: canterbury/lcet10.txt | 441884 | 5104.7 ± 0.6% | 1851.7 ± 0.2% | 2334.7 ± 1.2% | 391.3 ± 0.7% | 2842.5 ± 0.4% | 536.6 ± 2.1% | 2.757 | 2.186 | 13.044 | 1.796 | 9.513 |
| string: canterbury/plrabn12.txt | 503330 | 4116.4 ± 0.4% | 1737.9 ± 0.1% | 2055.6 ± 0.6% | 361.7 ± 0.9% | 2507.4 ± 1.0% | 501.1 ± 2.0% | 2.369 | 2.003 | 11.382 | 1.642 | 8.214 |
| string: canterbury-large/E.coli | 1048578 | 19114.8 ± 1.4% | 3611.1 ± 0.7% | 3258.6 ± 0.4% | 929.8 ± 0.9% | 6023.7 ± 0.9% | 754.3 ± 2.3% | 5.293 | 5.866 | 20.557 | 3.173 | 25.340 |
| string: canterbury-large/bible.txt | 1055886 | 6676.9 ± 1.1% | 2941.8 ± 0.5% | 2838.8 ± 1.1% | 421.3 ± 2.2% | 3774.9 ± 1.6% | 619.2 ± 0.9% | 2.270 | 2.352 | 15.846 | 1.769 | 10.783 |
| string: canterbury-large/world192.txt | 1103121 | 3400.5 ± 0.6% | 1482.1 ± 0.3% | 2019.7 ± 0.3% | 353.2 ± 0.7% | 2113.8 ± 0.7% | 503.3 ± 1.0% | 2.294 | 1.684 | 9.629 | 1.609 | 6.756 |
| string: http/html-1m | 1058582 | 6099.3 ± 2.1% | 2734.1 ± 0.7% | 2704.2 ± 0.5% | 441.4 ± 0.5% | 3468.6 ± 0.4% | 599.2 ± 0.6% | 2.231 | 2.256 | 13.819 | 1.758 | 10.179 |
| string: http/json-1m | 1190272 | 2551.7 ± 0.9% | 876.7 ± 0.4% | 2252.1 ± 0.6% | 391.1 ± 0.5% | 1063.1 ± 0.5% | 443.7 ± 0.6% | 2.911 | 1.133 | 6.525 | 2.400 | 5.752 |
| string: http/js-1m | 1144362 | 2284.9 ± 0.7% | 1029.3 ± 0.2% | 1637.7 ± 0.6% | 322.0 ± 1.0% | 1522.9 ± 0.8% | 418.7 ± 0.9% | 2.220 | 1.395 | 7.097 | 1.500 | 5.457 |
| string: http/css-1m | 1097820 | 2639.8 ± 0.7% | 1679.5 ± 0.4% | 2227.9 ± 0.9% | 404.8 ± 1.1% | 1944.3 ± 1.3% | 490.1 ± 1.0% | 1.572 | 1.185 | 6.520 | 1.358 | 5.386 |
| string: dickens as Cyrillic and CJK | 1883069 | 3075.3 ± 0.6% | 1688.1 ± 0.2% | 895.6 ± 0.5% | 350.4 ± 0.1% | 667.6 ± 1.1% | 157.6 ± 1.2% | 1.822 | 3.434 | 8.777 | 4.606 | 19.514 |
| string: dickens as Cyrillic and CJK, as \u escapes | 5075485 | 1328.4 ± 2.0% | 980.8 ± 0.3% | 1211.7 ± 0.5% | 216.1 ± 0.6% | 471.4 ± 0.9% | 257.0 ± 4.2% | 1.354 | 1.096 | 6.147 | 2.818 | 5.169 |
| hex: silesia/dickens | 524290 | 18129.4 ± 1.0% | 3615.8 ± 0.3% | 3296.9 ± 0.3% | 503.0 ± 0.8% | 6164.3 ± 2.3% | 783.1 ± 2.5% | 5.014 | 5.499 | 36.046 | 2.941 | 23.152 |
| hex: silesia/mozilla | 524290 | 18745.1 ± 1.6% | 3615.0 ± 0.2% | 3290.4 ± 0.3% | 445.4 ± 0.9% | 6081.0 ± 1.2% | 785.7 ± 0.3% | 5.185 | 5.697 | 42.085 | 3.083 | 23.858 |
| hex: silesia/mr | 524290 | 18525.4 ± 0.6% | 3622.9 ± 0.3% | 3297.9 ± 0.2% | 566.3 ± 1.1% | 6126.3 ± 0.6% | 782.5 ± 0.8% | 5.113 | 5.617 | 32.712 | 3.024 | 23.675 |
| hex: silesia/nci | 524290 | 18587.2 ± 0.6% | 3618.4 ± 0.2% | 3286.9 ± 0.5% | 625.2 ± 0.8% | 6130.4 ± 0.9% | 782.7 ± 0.8% | 5.137 | 5.655 | 29.731 | 3.032 | 23.747 |
| hex: silesia/ooffice | 524290 | 18570.4 ± 0.6% | 3619.9 ± 0.6% | 3306.1 ± 0.3% | 395.1 ± 1.3% | 6135.3 ± 1.1% | 783.7 ± 0.6% | 5.130 | 5.617 | 47.000 | 3.027 | 23.696 |
| hex: silesia/osdb | 524290 | 18665.7 ± 1.0% | 3618.9 ± 0.2% | 3297.0 ± 0.4% | 480.5 ± 0.5% | 6144.0 ± 1.0% | 783.5 ± 0.2% | 5.158 | 5.661 | 38.850 | 3.038 | 23.823 |
| hex: silesia/reymont | 524290 | 18676.5 ± 1.2% | 3615.9 ± 0.2% | 3295.3 ± 0.2% | 516.8 ± 1.2% | 6067.5 ± 1.3% | 785.2 ± 0.5% | 5.165 | 5.668 | 36.141 | 3.078 | 23.786 |
| hex: silesia/samba | 524290 | 18377.1 ± 0.6% | 3619.2 ± 0.2% | 3300.0 ± 0.5% | 402.2 ± 1.0% | 6103.1 ± 1.0% | 783.6 ± 0.6% | 5.078 | 5.569 | 45.695 | 3.011 | 23.453 |
| hex: silesia/sao | 524290 | 18591.0 ± 0.8% | 3615.8 ± 0.2% | 3304.1 ± 0.4% | 336.2 ± 1.9% | 6110.5 ± 1.4% | 784.5 ± 0.6% | 5.142 | 5.627 | 55.297 | 3.042 | 23.697 |
| hex: silesia/webster | 524290 | 18826.6 ± 0.6% | 3620.5 ± 0.4% | 3300.2 ± 0.2% | 458.2 ± 3.3% | 6141.2 ± 0.7% | 785.4 ± 0.7% | 5.200 | 5.705 | 41.088 | 3.066 | 23.970 |
| hex: silesia/x-ray | 524290 | 18517.2 ± 0.4% | 3614.0 ± 0.3% | 3309.1 ± 0.2% | 468.8 ± 0.8% | 6100.6 ± 1.1% | 784.1 ± 0.7% | 5.124 | 5.596 | 39.502 | 3.035 | 23.615 |
| hex: silesia/xml | 524290 | 18666.7 ± 0.6% | 3619.3 ± 0.1% | 3303.4 ± 0.3% | 530.2 ± 0.3% | 6093.6 ± 1.1% | 784.9 ± 0.6% | 5.158 | 5.651 | 35.205 | 3.063 | 23.784 |
| hex: canterbury/alice29.txt | 304180 | 19540.0 ± 0.2% | 3635.3 ± 0.1% | 3338.5 ± 0.1% | 522.0 ± 0.2% | 6162.3 ± 1.4% | 785.6 ± 0.4% | 5.375 | 5.853 | 37.430 | 3.171 | 24.872 |
| hex: canterbury/asyoulik.txt | 250360 | 19524.2 ± 0.1% | 3630.2 ± 0.1% | 3372.5 ± 0.1% | 514.4 ± 0.2% | 6116.7 ± 1.1% | 782.4 ± 0.5% | 5.378 | 5.789 | 37.958 | 3.192 | 24.955 |
| hex: canterbury/cp.html | 49208 | 19286.3 ± 0.1% | 3638.4 ± 0.1% | 3280.4 ± 0.4% | 477.5 ± 1.5% | 6209.7 ± 2.3% | 764.9 ± 1.1% | 5.301 | 5.879 | 40.394 | 3.106 | 25.213 |
| hex: canterbury/fields.c | 22302 | 18822.1 ± 0.7% | 3629.1 ± 0.0% | 3356.2 ± 0.1% | 510.6 ± 1.2% | 6249.0 ± 0.2% | 758.5 ± 1.3% | 5.186 | 5.608 | 36.863 | 3.012 | 24.814 |
| hex: canterbury/grammar.lsp | 7444 | 17452.0 ± 2.0% | 3601.7 ± 0.0% | 3361.9 ± 0.3% | 540.6 ± 2.4% | 6173.4 ± 0.6% | 721.7 ± 1.4% | 4.845 | 5.191 | 32.282 | 2.827 | 24.183 |
| hex: canterbury/kennedy.xls | 524290 | 18406.6 ± 1.8% | 3612.2 ± 0.3% | 3289.8 ± 0.3% | 657.2 ± 3.1% | 6118.7 ± 0.7% | 763.5 ± 1.1% | 5.096 | 5.595 | 28.006 | 3.008 | 24.107 |
| hex: canterbury/lcet10.txt | 524290 | 18565.0 ± 0.2% | 3612.9 ± 0.3% | 3291.0 ± 0.4% | 510.0 ± 1.3% | 6096.1 ± 0.8% | 783.3 ± 0.3% | 5.139 | 5.641 | 36.405 | 3.045 | 23.701 |
| hex: canterbury/plrabn12.txt | 524290 | 18596.5 ± 0.3% | 3608.2 ± 0.3% | 3298.3 ± 0.3% | 501.5 ± 1.5% | 6119.1 ± 1.2% | 784.4 ± 0.4% | 5.154 | 5.638 | 37.084 | 3.039 | 23.707 |
| hex: canterbury/ptt5 | 524290 | 18466.4 ± 1.2% | 3609.4 ± 0.5% | 3283.3 ± 0.4% | 557.1 ± 0.4% | 6125.2 ± 0.6% | 786.1 ± 0.2% | 5.116 | 5.624 | 33.146 | 3.015 | 23.492 |
| hex: canterbury/sum | 76482 | 19292.8 ± 0.1% | 3634.2 ± 0.0% | 3358.7 ± 0.3% | 500.3 ± 3.1% | 6166.7 ± 0.1% | 776.6 ± 1.1% | 5.309 | 5.744 | 38.561 | 3.129 | 24.841 |
| hex: canterbury/xargs.1 | 8456 | 17810.5 ± 0.1% | 3601.3 ± 0.1% | 3366.8 ± 0.2% | 485.8 ± 3.1% | 6147.8 ± 0.6% | 759.6 ± 2.0% | 4.946 | 5.290 | 36.659 | 2.897 | 23.446 |
| hex: canterbury-large/E.coli | 524290 | 18623.6 ± 0.8% | 3616.5 ± 0.2% | 3297.5 ± 0.5% | 688.8 ± 0.2% | 6136.6 ± 1.2% | 781.1 ± 3.8% | 5.150 | 5.648 | 27.037 | 3.035 | 23.843 |
| hex: canterbury-large/bible.txt | 524290 | 18606.2 ± 0.5% | 3616.1 ± 0.4% | 3296.6 ± 0.2% | 512.1 ± 1.0% | 6146.2 ± 1.5% | 784.4 ± 0.7% | 5.145 | 5.644 | 36.336 | 3.027 | 23.722 |
| hex: canterbury-large/world192.txt | 524290 | 18493.6 ± 0.6% | 3619.2 ± 0.2% | 3288.8 ± 0.5% | 485.7 ± 1.8% | 6050.4 ± 1.3% | 784.7 ± 0.4% | 5.110 | 5.623 | 38.079 | 3.057 | 23.568 |
| hex: http/html-1kx1024 | 2099200 | 9384.9 ± 18.7% | 3465.5 ± 0.1% | 2862.8 ± 0.3% | 474.6 ± 0.4% | 5115.2 ± 1.2% | 641.6 ± 1.7% | 2.708 | 3.278 | 19.772 | 1.835 | 14.627 |
| hex: http/html-16kx64 | 2097280 | 18230.0 ± 0.4% | 3611.9 ± 0.1% | 3260.7 ± 0.1% | 479.4 ± 0.5% | 6013.3 ± 0.3% | 756.2 ± 2.0% | 5.047 | 5.591 | 38.028 | 3.032 | 24.107 |
| hex: http/html-1m | 524290 | 18386.9 ± 0.8% | 3617.4 ± 0.3% | 3299.6 ± 0.4% | 499.6 ± 1.1% | 6146.3 ± 1.3% | 785.1 ± 0.8% | 5.083 | 5.572 | 36.802 | 2.992 | 23.420 |
| hex: http/json-1kx1024 | 2099200 | 9514.8 ± 18.6% | 3465.7 ± 0.1% | 2867.8 ± 0.6% | 574.8 ± 1.0% | 5146.4 ± 1.8% | 645.9 ± 1.6% | 2.745 | 3.318 | 16.554 | 1.849 | 14.731 |
| hex: http/json-16kx64 | 2097280 | 18345.0 ± 0.4% | 3611.3 ± 0.1% | 3257.1 ± 0.4% | 573.7 ± 0.6% | 6020.9 ± 0.6% | 752.8 ± 0.8% | 5.080 | 5.632 | 31.977 | 3.047 | 24.368 |
| hex: http/json-1m | 524290 | 18611.1 ± 1.1% | 3616.3 ± 0.3% | 3292.0 ± 0.8% | 586.8 ± 2.0% | 6118.7 ± 1.3% | 781.8 ± 1.6% | 5.146 | 5.653 | 31.717 | 3.042 | 23.806 |
| hex: http/js-1kx1024 | 2099200 | 9602.1 ± 16.5% | 3459.6 ± 0.3% | 2870.2 ± 0.3% | 479.2 ± 0.5% | 5123.7 ± 0.1% | 647.0 ± 0.9% | 2.775 | 3.345 | 20.038 | 1.874 | 14.840 |
| hex: http/js-16kx64 | 2097280 | 18279.2 ± 0.4% | 3611.4 ± 0.3% | 3262.5 ± 0.4% | 479.5 ± 0.6% | 6016.0 ± 0.7% | 752.3 ± 2.3% | 5.062 | 5.603 | 38.118 | 3.038 | 24.296 |
| hex: http/js-1m | 524290 | 18581.3 ± 1.1% | 3613.2 ± 0.2% | 3285.9 ± 0.1% | 497.9 ± 1.0% | 6049.3 ± 1.0% | 782.0 ± 1.2% | 5.143 | 5.655 | 37.322 | 3.072 | 23.762 |
| hex: http/css-1kx1024 | 2099200 | 9567.6 ± 16.5% | 3464.5 ± 0.2% | 2865.3 ± 0.4% | 488.6 ± 1.1% | 5129.5 ± 0.8% | 648.0 ± 3.7% | 2.762 | 3.339 | 19.580 | 1.865 | 14.765 |
| hex: http/css-16kx64 | 2097280 | 18369.7 ± 0.4% | 3612.7 ± 0.2% | 3267.7 ± 0.1% | 493.0 ± 0.6% | 6009.2 ± 0.5% | 762.6 ± 0.9% | 5.085 | 5.622 | 37.259 | 3.057 | 24.088 |
| hex: http/css-1m | 524290 | 18535.6 ± 0.7% | 3617.7 ± 0.3% | 3301.9 ± 0.3% | 498.3 ± 1.2% | 6131.6 ± 0.9% | 783.6 ± 2.1% | 5.124 | 5.614 | 37.196 | 3.023 | 23.656 |
| hex: shuffled/dickens-1m | 524290 | 18343.5 ± 0.6% | 3612.0 ± 0.4% | 3292.7 ± 0.2% | 503.8 ± 1.9% | 6088.0 ± 1.1% | 785.5 ± 0.4% | 5.078 | 5.571 | 36.411 | 3.013 | 23.353 |

## Encoding against the baselines

Octets are the ones stdx writes. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1481.9 ± 1.1% | 1251.4 ± 0.2% | 1040.7 ± 0.5% | 409.8 ± 0.6% | 448.4 ± 0.1% | 415.1 ± 0.3% | 1.184 | 1.424 | 3.616 | 3.305 | 3.570 |
| qlog records, JSON text sequence | 1467503 | 1271.7 ± 1.5% | 1062.6 ± 0.3% | 786.2 ± 0.5% | 379.4 ± 0.9% | 468.7 ± 0.9% | 278.9 ± 0.3% | 1.197 | 1.618 | 3.352 | 2.713 | 4.559 |
| string: silesia/dickens | 172528 | 6889.5 ± 0.2% | 2823.2 ± 0.3% | 2925.1 ± 1.0% | 431.4 ± 0.7% | 1572.0 ± 0.3% | 1010.8 ± 0.1% | 2.440 | 2.355 | 15.968 | 4.383 | 6.816 |
| string: silesia/nci | 1075110 | 7297.9 ± 0.4% | 3420.8 ± 1.4% | 3100.4 ± 0.3% | 812.8 ± 2.2% | 1855.4 ± 0.1% | 1108.6 ± 0.4% | 2.133 | 2.354 | 8.978 | 3.933 | 6.583 |
| string: silesia/reymont | 1075159 | 3338.5 ± 1.7% | 2003.1 ± 1.3% | 2062.8 ± 0.5% | 450.7 ± 0.5% | 1509.3 ± 1.3% | 950.6 ± 0.3% | 1.667 | 1.618 | 7.407 | 2.212 | 3.512 |
| string: silesia/samba | 97582 | 4180.0 ± 1.1% | 2110.6 ± 1.2% | 3446.4 ± 0.7% | 353.3 ± 0.6% | 1437.1 ± 0.3% | 1055.1 ± 0.4% | 1.980 | 1.213 | 11.833 | 2.909 | 3.962 |
| string: silesia/webster | 1098490 | 4040.0 ± 0.5% | 1880.2 ± 0.5% | 2056.6 ± 0.6% | 442.5 ± 0.1% | 1388.3 ± 0.1% | 645.6 ± 0.5% | 2.149 | 1.964 | 9.130 | 2.910 | 6.258 |
| string: silesia/xml | 1090118 | 6107.6 ± 0.6% | 2875.8 ± 0.4% | 2649.6 ± 0.7% | 610.0 ± 0.5% | 1754.4 ± 0.6% | 923.4 ± 0.8% | 2.124 | 2.305 | 10.013 | 3.481 | 6.615 |
| string: canterbury/alice29.txt | 159425 | 6428.4 ± 2.0% | 2196.1 ± 0.3% | 2769.2 ± 0.8% | 408.0 ± 1.0% | 1464.7 ± 0.4% | 955.5 ± 0.2% | 2.927 | 2.321 | 15.756 | 4.389 | 6.728 |
| string: canterbury/asyoulik.txt | 132198 | 5564.6 ± 1.5% | 1711.8 ± 0.6% | 2374.3 ± 0.7% | 401.7 ± 0.4% | 1333.1 ± 0.3% | 885.1 ± 0.2% | 3.251 | 2.344 | 13.853 | 4.174 | 6.287 |
| string: canterbury/lcet10.txt | 441884 | 6253.1 ± 0.4% | 2569.7 ± 0.3% | 2483.0 ± 2.2% | 468.4 ± 0.5% | 1525.7 ± 0.3% | 988.2 ± 0.3% | 2.433 | 2.518 | 13.351 | 4.098 | 6.328 |
| string: canterbury/plrabn12.txt | 503330 | 5717.5 ± 0.4% | 2051.2 ± 0.8% | 2072.2 ± 0.3% | 423.6 ± 0.4% | 1408.4 ± 0.4% | 931.0 ± 0.5% | 2.787 | 2.759 | 13.498 | 4.060 | 6.141 |
| string: canterbury-large/E.coli | 1048578 | 19338.0 ± 0.6% | 9759.4 ± 0.9% | 3788.1 ± 0.6% | 1479.2 ± 0.7% | 2367.6 ± 0.8% | 1193.0 ± 0.6% | 1.981 | 5.105 | 13.074 | 8.168 | 16.209 |
| string: canterbury-large/bible.txt | 1055886 | 6795.7 ± 0.9% | 4136.6 ± 1.2% | 3050.9 ± 1.5% | 504.0 ± 0.5% | 1984.3 ± 0.7% | 1122.9 ± 0.7% | 1.643 | 2.227 | 13.484 | 3.425 | 6.052 |
| string: canterbury-large/world192.txt | 1103121 | 4019.4 ± 0.2% | 1658.9 ± 0.2% | 2001.5 ± 1.2% | 449.0 ± 0.5% | 1357.2 ± 0.3% | 909.0 ± 0.3% | 2.423 | 2.008 | 8.952 | 2.961 | 4.422 |
| string: http/html-1m | 1058582 | 6752.9 ± 1.0% | 3989.0 ± 0.3% | 3047.2 ± 0.7% | 499.7 ± 1.0% | 1929.6 ± 0.5% | 805.8 ± 0.4% | 1.693 | 2.216 | 13.514 | 3.500 | 8.381 |
| string: http/json-1m | 1190272 | 3154.4 ± 0.2% | 1349.2 ± 0.5% | 1557.0 ± 0.7% | 443.8 ± 0.6% | 963.5 ± 0.1% | 766.0 ± 1.0% | 2.338 | 2.026 | 7.107 | 3.274 | 4.118 |
| string: http/js-1m | 1144362 | 2764.0 ± 0.5% | 1178.5 ± 0.1% | 1625.1 ± 0.4% | 369.3 ± 0.5% | 1094.4 ± 0.4% | 758.1 ± 0.3% | 2.345 | 1.701 | 7.484 | 2.526 | 3.646 |
| string: http/css-1m | 1097820 | 3982.3 ± 0.6% | 1488.4 ± 0.3% | 2157.3 ± 0.5% | 493.8 ± 0.6% | 1368.9 ± 0.3% | 894.8 ± 0.6% | 2.676 | 1.846 | 8.065 | 2.909 | 4.450 |
| string: dickens as Cyrillic and CJK | 1883069 | 3075.4 ± 0.5% | 2342.2 ± 0.4% | 521.8 ± 0.5% | 306.9 ± 1.2% | 561.3 ± 0.6% | 336.1 ± 0.2% | 1.313 | 5.894 | 10.020 | 5.479 | 9.150 |
| hex: silesia/dickens | 524290 | 15657.4 ± 0.1% | 1463.6 ± 0.2% | 1080.8 ± 0.3% | 499.5 ± 0.6% | 987.3 ± 0.3% | 734.7 ± 0.7% | 10.698 | 14.487 | 31.349 | 15.858 | 21.310 |
| hex: silesia/mozilla | 524290 | 15663.7 ± 0.2% | 1475.2 ± 0.5% | 1087.6 ± 0.2% | 442.0 ± 0.6% | 991.5 ± 0.9% | 736.3 ± 0.6% | 10.618 | 14.402 | 35.442 | 15.798 | 21.272 |
| hex: silesia/mr | 524290 | 15665.9 ± 0.4% | 1480.7 ± 0.1% | 1093.2 ± 0.4% | 554.0 ± 1.9% | 996.6 ± 0.2% | 736.0 ± 0.4% | 10.580 | 14.331 | 28.279 | 15.720 | 21.286 |
| hex: silesia/nci | 524290 | 15647.0 ± 0.3% | 1472.8 ± 0.6% | 1091.3 ± 0.5% | 631.7 ± 3.8% | 990.4 ± 0.8% | 736.8 ± 0.6% | 10.624 | 14.338 | 24.771 | 15.798 | 21.238 |
| hex: silesia/ooffice | 524290 | 15621.1 ± 0.2% | 1466.8 ± 0.3% | 1085.3 ± 0.3% | 388.7 ± 0.6% | 989.2 ± 0.8% | 734.3 ± 0.7% | 10.650 | 14.393 | 40.187 | 15.792 | 21.273 |
| hex: silesia/osdb | 524290 | 15660.5 ± 0.2% | 1469.7 ± 0.4% | 1089.0 ± 0.5% | 470.4 ± 1.8% | 990.0 ± 0.6% | 735.9 ± 0.5% | 10.656 | 14.381 | 33.289 | 15.819 | 21.280 |
| hex: silesia/reymont | 524290 | 15672.3 ± 0.2% | 1462.1 ± 0.6% | 1087.6 ± 0.6% | 511.3 ± 1.8% | 989.6 ± 0.3% | 736.8 ± 0.7% | 10.719 | 14.410 | 30.650 | 15.837 | 21.271 |
| hex: silesia/samba | 524290 | 15616.5 ± 0.3% | 1468.6 ± 0.5% | 1082.7 ± 0.5% | 403.7 ± 0.8% | 990.4 ± 0.3% | 735.8 ± 0.4% | 10.634 | 14.424 | 38.682 | 15.768 | 21.223 |
| hex: silesia/sao | 524290 | 15637.5 ± 0.5% | 1465.0 ± 0.3% | 1082.2 ± 1.3% | 333.4 ± 0.4% | 993.3 ± 0.3% | 736.6 ± 0.5% | 10.674 | 14.450 | 46.898 | 15.742 | 21.229 |
| hex: silesia/webster | 524290 | 15676.9 ± 0.3% | 1468.2 ± 0.3% | 1083.9 ± 0.6% | 471.6 ± 0.6% | 989.0 ± 0.5% | 736.9 ± 0.3% | 10.678 | 14.463 | 33.242 | 15.851 | 21.274 |
| hex: silesia/x-ray | 524290 | 15630.9 ± 0.3% | 1472.6 ± 0.4% | 1089.7 ± 0.6% | 447.0 ± 1.0% | 995.9 ± 0.4% | 734.3 ± 0.6% | 10.614 | 14.345 | 34.968 | 15.695 | 21.286 |
| hex: silesia/xml | 524290 | 15642.7 ± 0.2% | 1470.9 ± 0.3% | 1089.2 ± 0.7% | 615.2 ± 0.6% | 995.4 ± 0.5% | 735.3 ± 0.4% | 10.635 | 14.361 | 25.425 | 15.714 | 21.274 |
| hex: canterbury/alice29.txt | 304180 | 15679.0 ± 0.0% | 1471.8 ± 0.6% | 1087.6 ± 0.3% | 502.3 ± 0.5% | 997.2 ± 0.6% | 736.8 ± 0.4% | 10.653 | 14.416 | 31.217 | 15.722 | 21.280 |
| hex: canterbury/asyoulik.txt | 250360 | 15693.6 ± 0.1% | 1475.8 ± 0.2% | 1090.4 ± 0.2% | 497.3 ± 1.9% | 998.5 ± 0.4% | 740.8 ± 0.5% | 10.634 | 14.392 | 31.559 | 15.718 | 21.186 |
| hex: canterbury/cp.html | 49208 | 15622.0 ± 0.1% | 1478.5 ± 0.7% | 1098.0 ± 0.2% | 523.9 ± 5.1% | 1000.8 ± 0.3% | 742.4 ± 0.2% | 10.566 | 14.228 | 29.816 | 15.610 | 21.042 |
| hex: canterbury/fields.c | 22302 | 15442.4 ± 0.1% | 1413.1 ± 0.3% | 1066.2 ± 0.5% | 622.4 ± 6.6% | 994.7 ± 0.0% | 737.0 ± 0.2% | 10.928 | 14.483 | 24.809 | 15.525 | 20.954 |
| hex: canterbury/grammar.lsp | 7444 | 14948.3 ± 0.3% | 1508.8 ± 0.2% | 1096.3 ± 0.2% | 663.2 ± 3.1% | 993.3 ± 0.5% | 726.0 ± 0.1% | 9.908 | 13.635 | 22.539 | 15.050 | 20.590 |
| hex: canterbury/kennedy.xls | 524290 | 15673.6 ± 0.1% | 1475.1 ± 0.1% | 1091.0 ± 0.2% | 649.6 ± 2.3% | 991.1 ± 0.6% | 736.0 ± 0.3% | 10.625 | 14.367 | 24.128 | 15.814 | 21.297 |
| hex: canterbury/lcet10.txt | 524290 | 15635.1 ± 0.3% | 1463.0 ± 0.1% | 1085.7 ± 0.4% | 498.9 ± 3.9% | 991.2 ± 0.4% | 736.8 ± 0.5% | 10.687 | 14.401 | 31.341 | 15.774 | 21.221 |
| hex: canterbury/plrabn12.txt | 524290 | 15685.9 ± 0.1% | 1463.1 ± 0.2% | 1085.9 ± 0.2% | 492.7 ± 0.8% | 988.0 ± 0.8% | 737.5 ± 0.7% | 10.721 | 14.445 | 31.837 | 15.877 | 21.269 |
| hex: canterbury/ptt5 | 524290 | 15631.8 ± 0.3% | 1483.9 ± 0.3% | 1092.9 ± 0.3% | 557.7 ± 0.9% | 995.6 ± 0.5% | 736.7 ± 0.3% | 10.534 | 14.303 | 28.027 | 15.700 | 21.219 |
| hex: canterbury/sum | 76482 | 15644.9 ± 0.0% | 1494.4 ± 0.1% | 1105.7 ± 0.1% | 597.8 ± 1.1% | 998.0 ± 0.0% | 744.9 ± 0.1% | 10.469 | 14.150 | 26.171 | 15.676 | 21.003 |
| hex: canterbury/xargs.1 | 8456 | 15018.3 ± 0.1% | 1492.4 ± 0.6% | 1095.1 ± 0.3% | 651.0 ± 6.1% | 983.3 ± 0.3% | 728.7 ± 0.1% | 10.063 | 13.714 | 23.071 | 15.274 | 20.610 |
| hex: canterbury-large/E.coli | 524290 | 15687.6 ± 0.2% | 1473.7 ± 0.5% | 1089.6 ± 0.4% | 673.2 ± 0.3% | 996.4 ± 1.6% | 736.7 ± 0.5% | 10.645 | 14.397 | 23.304 | 15.745 | 21.293 |
| hex: canterbury-large/bible.txt | 524290 | 15652.1 ± 0.3% | 1464.7 ± 0.2% | 1084.5 ± 0.5% | 513.9 ± 1.3% | 988.5 ± 0.4% | 734.4 ± 0.5% | 10.686 | 14.433 | 30.458 | 15.834 | 21.313 |
| hex: canterbury-large/world192.txt | 524290 | 15599.9 ± 0.3% | 1465.0 ± 0.3% | 1080.4 ± 0.6% | 503.5 ± 0.9% | 990.3 ± 0.5% | 735.9 ± 0.6% | 10.648 | 14.439 | 30.983 | 15.753 | 21.199 |
| hex: http/html-1kx1024 | 2099200 | 13682.6 ± 0.4% | 1457.9 ± 0.3% | 1064.5 ± 0.4% | 502.2 ± 0.3% | 985.4 ± 0.3% | 692.4 ± 0.1% | 9.385 | 12.854 | 27.246 | 13.886 | 19.761 |
| hex: http/html-16kx64 | 2097280 | 15262.2 ± 0.5% | 1445.1 ± 0.2% | 1076.1 ± 0.2% | 507.3 ± 0.3% | 995.8 ± 0.7% | 735.3 ± 0.2% | 10.561 | 14.182 | 30.083 | 15.327 | 20.756 |
| hex: http/html-1m | 524290 | 15610.8 ± 0.2% | 1470.8 ± 0.2% | 1082.3 ± 0.4% | 499.8 ± 0.7% | 990.8 ± 0.1% | 736.6 ± 0.4% | 10.614 | 14.424 | 31.236 | 15.756 | 21.194 |
| hex: http/json-1kx1024 | 2099200 | 13716.4 ± 0.7% | 1463.7 ± 0.1% | 1066.4 ± 0.1% | 608.3 ± 0.5% | 986.4 ± 0.1% | 692.4 ± 0.4% | 9.371 | 12.862 | 22.550 | 13.905 | 19.810 |
| hex: http/json-16kx64 | 2097280 | 15249.8 ± 0.1% | 1446.7 ± 0.2% | 1074.7 ± 0.2% | 615.8 ± 0.5% | 997.0 ± 0.3% | 735.3 ± 0.1% | 10.541 | 14.190 | 24.765 | 15.296 | 20.738 |
| hex: http/json-1m | 524290 | 15660.9 ± 0.3% | 1475.4 ± 0.3% | 1088.6 ± 0.3% | 634.3 ± 1.1% | 994.3 ± 0.6% | 734.6 ± 0.6% | 10.615 | 14.386 | 24.690 | 15.751 | 21.320 |
| hex: http/js-1kx1024 | 2099200 | 13682.4 ± 0.8% | 1456.5 ± 0.1% | 1065.1 ± 0.2% | 498.9 ± 0.3% | 983.6 ± 0.6% | 692.6 ± 0.1% | 9.394 | 12.846 | 27.425 | 13.911 | 19.756 |
| hex: http/js-16kx64 | 2097280 | 15192.6 ± 0.6% | 1444.2 ± 0.2% | 1074.8 ± 0.1% | 504.4 ± 0.2% | 995.0 ± 0.5% | 735.0 ± 0.2% | 10.520 | 14.135 | 30.122 | 15.269 | 20.670 |
| hex: http/js-1m | 524290 | 15705.4 ± 0.1% | 1469.1 ± 0.3% | 1086.2 ± 0.2% | 512.3 ± 0.2% | 992.0 ± 1.0% | 733.6 ± 0.8% | 10.691 | 14.459 | 30.655 | 15.831 | 21.409 |
| hex: http/css-1kx1024 | 2099200 | 13690.0 ± 0.4% | 1457.6 ± 0.1% | 1064.2 ± 0.3% | 531.4 ± 0.3% | 983.2 ± 0.2% | 692.4 ± 0.1% | 9.392 | 12.865 | 25.764 | 13.924 | 19.772 |
| hex: http/css-16kx64 | 2097280 | 15223.9 ± 0.8% | 1441.9 ± 0.2% | 1074.7 ± 0.2% | 538.8 ± 0.3% | 997.2 ± 0.4% | 735.2 ± 0.3% | 10.558 | 14.165 | 28.254 | 15.266 | 20.707 |
| hex: http/css-1m | 524290 | 15703.4 ± 0.3% | 1463.9 ± 0.2% | 1087.3 ± 0.3% | 525.2 ± 0.4% | 991.7 ± 0.5% | 735.3 ± 0.5% | 10.727 | 14.443 | 29.901 | 15.834 | 21.356 |
| hex: shuffled/dickens-1m | 524290 | 15675.0 ± 0.4% | 1468.3 ± 0.6% | 1089.1 ± 0.5% | 501.0 ± 0.5% | 992.4 ± 0.6% | 735.3 ± 0.8% | 10.675 | 14.393 | 31.286 | 15.796 | 21.317 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1525.2 ± 0.2% | 1251.4 ± 0.2% | 1040.7 ± 0.5% | 409.8 ± 0.6% | 448.4 ± 0.1% | 415.1 ± 0.3% | 1.219 | 1.466 | 3.722 | 3.402 | 3.675 |
| qlog records, JSON text sequence | 1467503 | 1297.3 ± 0.3% | 1062.6 ± 0.3% | 786.2 ± 0.5% | 379.4 ± 0.9% | 468.7 ± 0.9% | 278.9 ± 0.3% | 1.221 | 1.650 | 3.420 | 2.768 | 4.651 |
| string: silesia/dickens | 172528 | 7126.8 ± 0.5% | 2823.2 ± 0.3% | 2925.1 ± 1.0% | 431.4 ± 0.7% | 1572.0 ± 0.3% | 1010.8 ± 0.1% | 2.524 | 2.436 | 16.519 | 4.534 | 7.050 |
| string: silesia/nci | 1075110 | 6926.2 ± 6.5% | 3420.8 ± 1.4% | 3100.4 ± 0.3% | 812.8 ± 2.2% | 1855.4 ± 0.1% | 1108.6 ± 0.4% | 2.025 | 2.234 | 8.521 | 3.733 | 6.248 |
| string: silesia/reymont | 1075159 | 3463.5 ± 1.7% | 2003.1 ± 1.3% | 2062.8 ± 0.5% | 450.7 ± 0.5% | 1509.3 ± 1.3% | 950.6 ± 0.3% | 1.729 | 1.679 | 7.684 | 2.295 | 3.644 |
| string: silesia/samba | 97582 | 4585.1 ± 0.5% | 2110.6 ± 1.2% | 3446.4 ± 0.7% | 353.3 ± 0.6% | 1437.1 ± 0.3% | 1055.1 ± 0.4% | 2.172 | 1.330 | 12.980 | 3.191 | 4.345 |
| string: silesia/webster | 1098490 | 4099.9 ± 0.6% | 1880.2 ± 0.5% | 2056.6 ± 0.6% | 442.5 ± 0.1% | 1388.3 ± 0.1% | 645.6 ± 0.5% | 2.181 | 1.994 | 9.265 | 2.953 | 6.351 |
| string: silesia/xml | 1090118 | 6248.4 ± 0.2% | 2875.8 ± 0.4% | 2649.6 ± 0.7% | 610.0 ± 0.5% | 1754.4 ± 0.6% | 923.4 ± 0.8% | 2.173 | 2.358 | 10.244 | 3.561 | 6.767 |
| string: canterbury/alice29.txt | 159425 | 6820.8 ± 1.0% | 2196.1 ± 0.3% | 2769.2 ± 0.8% | 408.0 ± 1.0% | 1464.7 ± 0.4% | 955.5 ± 0.2% | 3.106 | 2.463 | 16.717 | 4.657 | 7.138 |
| string: canterbury/asyoulik.txt | 132198 | 5894.0 ± 3.7% | 1711.8 ± 0.6% | 2374.3 ± 0.7% | 401.7 ± 0.4% | 1333.1 ± 0.3% | 885.1 ± 0.2% | 3.443 | 2.482 | 14.673 | 4.421 | 6.659 |
| string: canterbury/lcet10.txt | 441884 | 6258.1 ± 0.5% | 2569.7 ± 0.3% | 2483.0 ± 2.2% | 468.4 ± 0.5% | 1525.7 ± 0.3% | 988.2 ± 0.3% | 2.435 | 2.520 | 13.362 | 4.102 | 6.333 |
| string: canterbury/plrabn12.txt | 503330 | 5762.4 ± 0.2% | 2051.2 ± 0.8% | 2072.2 ± 0.3% | 423.6 ± 0.4% | 1408.4 ± 0.4% | 931.0 ± 0.5% | 2.809 | 2.781 | 13.604 | 4.091 | 6.190 |
| string: canterbury-large/E.coli | 1048578 | 19333.3 ± 0.7% | 9759.4 ± 0.9% | 3788.1 ± 0.6% | 1479.2 ± 0.7% | 2367.6 ± 0.8% | 1193.0 ± 0.6% | 1.981 | 5.104 | 13.071 | 8.166 | 16.205 |
| string: canterbury-large/bible.txt | 1055886 | 6791.9 ± 0.3% | 4136.6 ± 1.2% | 3050.9 ± 1.5% | 504.0 ± 0.5% | 1984.3 ± 0.7% | 1122.9 ± 0.7% | 1.642 | 2.226 | 13.476 | 3.423 | 6.048 |
| string: canterbury-large/world192.txt | 1103121 | 4034.3 ± 0.9% | 1658.9 ± 0.2% | 2001.5 ± 1.2% | 449.0 ± 0.5% | 1357.2 ± 0.3% | 909.0 ± 0.3% | 2.432 | 2.016 | 8.985 | 2.972 | 4.438 |
| string: http/html-1m | 1058582 | 6827.3 ± 0.2% | 3989.0 ± 0.3% | 3047.2 ± 0.7% | 499.7 ± 1.0% | 1929.6 ± 0.5% | 805.8 ± 0.4% | 1.712 | 2.241 | 13.663 | 3.538 | 8.473 |
| string: http/json-1m | 1190272 | 3298.1 ± 0.4% | 1349.2 ± 0.5% | 1557.0 ± 0.7% | 443.8 ± 0.6% | 963.5 ± 0.1% | 766.0 ± 1.0% | 2.444 | 2.118 | 7.431 | 3.423 | 4.305 |
| string: http/js-1m | 1144362 | 2808.1 ± 0.5% | 1178.5 ± 0.1% | 1625.1 ± 0.4% | 369.3 ± 0.5% | 1094.4 ± 0.4% | 758.1 ± 0.3% | 2.383 | 1.728 | 7.603 | 2.566 | 3.704 |
| string: http/css-1m | 1097820 | 4035.9 ± 0.6% | 1488.4 ± 0.3% | 2157.3 ± 0.5% | 493.8 ± 0.6% | 1368.9 ± 0.3% | 894.8 ± 0.6% | 2.712 | 1.871 | 8.173 | 2.948 | 4.510 |
| string: dickens as Cyrillic and CJK | 1883069 | 3075.7 ± 0.5% | 2342.2 ± 0.4% | 521.8 ± 0.5% | 306.9 ± 1.2% | 561.3 ± 0.6% | 336.1 ± 0.2% | 1.313 | 5.895 | 10.021 | 5.480 | 9.151 |
| hex: silesia/dickens | 524290 | 15682.0 ± 0.2% | 1463.6 ± 0.2% | 1080.8 ± 0.3% | 499.5 ± 0.6% | 987.3 ± 0.3% | 734.7 ± 0.7% | 10.714 | 14.510 | 31.399 | 15.883 | 21.344 |
| hex: silesia/mozilla | 524290 | 15668.2 ± 0.4% | 1475.2 ± 0.5% | 1087.6 ± 0.2% | 442.0 ± 0.6% | 991.5 ± 0.9% | 736.3 ± 0.6% | 10.621 | 14.407 | 35.452 | 15.803 | 21.278 |
| hex: silesia/mr | 524290 | 15644.5 ± 0.5% | 1480.7 ± 0.1% | 1093.2 ± 0.4% | 554.0 ± 1.9% | 996.6 ± 0.2% | 736.0 ± 0.4% | 10.566 | 14.311 | 28.240 | 15.698 | 21.256 |
| hex: silesia/nci | 524290 | 15651.2 ± 0.5% | 1472.8 ± 0.6% | 1091.3 ± 0.5% | 631.7 ± 3.8% | 990.4 ± 0.8% | 736.8 ± 0.6% | 10.627 | 14.342 | 24.778 | 15.803 | 21.243 |
| hex: silesia/ooffice | 524290 | 15668.0 ± 0.4% | 1466.8 ± 0.3% | 1085.3 ± 0.3% | 388.7 ± 0.6% | 989.2 ± 0.8% | 734.3 ± 0.7% | 10.682 | 14.436 | 40.308 | 15.839 | 21.337 |
| hex: silesia/osdb | 524290 | 15665.6 ± 0.4% | 1469.7 ± 0.4% | 1089.0 ± 0.5% | 470.4 ± 1.8% | 990.0 ± 0.6% | 735.9 ± 0.5% | 10.659 | 14.386 | 33.300 | 15.824 | 21.286 |
| hex: silesia/reymont | 524290 | 15699.0 ± 0.3% | 1462.1 ± 0.6% | 1087.6 ± 0.6% | 511.3 ± 1.8% | 989.6 ± 0.3% | 736.8 ± 0.7% | 10.737 | 14.435 | 30.703 | 15.864 | 21.307 |
| hex: silesia/samba | 524290 | 15667.9 ± 0.2% | 1468.6 ± 0.5% | 1082.7 ± 0.5% | 403.7 ± 0.8% | 990.4 ± 0.3% | 735.8 ± 0.4% | 10.669 | 14.471 | 38.810 | 15.820 | 21.293 |
| hex: silesia/sao | 524290 | 15618.0 ± 0.8% | 1465.0 ± 0.3% | 1082.2 ± 1.3% | 333.4 ± 0.4% | 993.3 ± 0.3% | 736.6 ± 0.5% | 10.660 | 14.432 | 46.839 | 15.723 | 21.203 |
| hex: silesia/webster | 524290 | 15706.9 ± 0.4% | 1468.2 ± 0.3% | 1083.9 ± 0.6% | 471.6 ± 0.6% | 989.0 ± 0.5% | 736.9 ± 0.3% | 10.698 | 14.490 | 33.306 | 15.881 | 21.315 |
| hex: silesia/x-ray | 524290 | 15661.2 ± 0.2% | 1472.6 ± 0.4% | 1089.7 ± 0.6% | 447.0 ± 1.0% | 995.9 ± 0.4% | 734.3 ± 0.6% | 10.635 | 14.372 | 35.036 | 15.726 | 21.327 |
| hex: silesia/xml | 524290 | 15634.2 ± 0.3% | 1470.9 ± 0.3% | 1089.2 ± 0.7% | 615.2 ± 0.6% | 995.4 ± 0.5% | 735.3 ± 0.4% | 10.629 | 14.353 | 25.412 | 15.706 | 21.263 |
| hex: canterbury/alice29.txt | 304180 | 15690.5 ± 0.1% | 1471.8 ± 0.6% | 1087.6 ± 0.3% | 502.3 ± 0.5% | 997.2 ± 0.6% | 736.8 ± 0.4% | 10.661 | 14.427 | 31.240 | 15.734 | 21.296 |
| hex: canterbury/asyoulik.txt | 250360 | 15700.1 ± 0.1% | 1475.8 ± 0.2% | 1090.4 ± 0.2% | 497.3 ± 1.9% | 998.5 ± 0.4% | 740.8 ± 0.5% | 10.638 | 14.398 | 31.572 | 15.724 | 21.194 |
| hex: canterbury/cp.html | 49208 | 15639.1 ± 0.0% | 1478.5 ± 0.7% | 1098.0 ± 0.2% | 523.9 ± 5.1% | 1000.8 ± 0.3% | 742.4 ± 0.2% | 10.578 | 14.243 | 29.849 | 15.627 | 21.065 |
| hex: canterbury/fields.c | 22302 | 15456.1 ± 0.0% | 1413.1 ± 0.3% | 1066.2 ± 0.5% | 622.4 ± 6.6% | 994.7 ± 0.0% | 737.0 ± 0.2% | 10.938 | 14.496 | 24.831 | 15.539 | 20.972 |
| hex: canterbury/grammar.lsp | 7444 | 14995.9 ± 0.1% | 1508.8 ± 0.2% | 1096.3 ± 0.2% | 663.2 ± 3.1% | 993.3 ± 0.5% | 726.0 ± 0.1% | 9.939 | 13.679 | 22.611 | 15.098 | 20.656 |
| hex: canterbury/kennedy.xls | 524290 | 15660.3 ± 0.4% | 1475.1 ± 0.1% | 1091.0 ± 0.2% | 649.6 ± 2.3% | 991.1 ± 0.6% | 736.0 ± 0.3% | 10.616 | 14.355 | 24.108 | 15.800 | 21.279 |
| hex: canterbury/lcet10.txt | 524290 | 15546.5 ± 0.9% | 1463.0 ± 0.1% | 1085.7 ± 0.4% | 498.9 ± 3.9% | 991.2 ± 0.4% | 736.8 ± 0.5% | 10.626 | 14.319 | 31.164 | 15.685 | 21.100 |
| hex: canterbury/plrabn12.txt | 524290 | 15679.1 ± 0.4% | 1463.1 ± 0.2% | 1085.9 ± 0.2% | 492.7 ± 0.8% | 988.0 ± 0.8% | 737.5 ± 0.7% | 10.717 | 14.439 | 31.823 | 15.870 | 21.260 |
| hex: canterbury/ptt5 | 524290 | 15639.3 ± 0.3% | 1483.9 ± 0.3% | 1092.9 ± 0.3% | 557.7 ± 0.9% | 995.6 ± 0.5% | 736.7 ± 0.3% | 10.539 | 14.310 | 28.041 | 15.708 | 21.229 |
| hex: canterbury/sum | 76482 | 15653.7 ± 0.0% | 1494.4 ± 0.1% | 1105.7 ± 0.1% | 597.8 ± 1.1% | 998.0 ± 0.0% | 744.9 ± 0.1% | 10.475 | 14.158 | 26.186 | 15.684 | 21.015 |
| hex: canterbury/xargs.1 | 8456 | 15052.2 ± 0.0% | 1492.4 ± 0.6% | 1095.1 ± 0.3% | 651.0 ± 6.1% | 983.3 ± 0.3% | 728.7 ± 0.1% | 10.086 | 13.745 | 23.123 | 15.309 | 20.657 |
| hex: canterbury-large/E.coli | 524290 | 15643.9 ± 0.3% | 1473.7 ± 0.5% | 1089.6 ± 0.4% | 673.2 ± 0.3% | 996.4 ± 1.6% | 736.7 ± 0.5% | 10.615 | 14.357 | 23.239 | 15.701 | 21.234 |
| hex: canterbury-large/bible.txt | 524290 | 15625.4 ± 0.2% | 1464.7 ± 0.2% | 1084.5 ± 0.5% | 513.9 ± 1.3% | 988.5 ± 0.4% | 734.4 ± 0.5% | 10.668 | 14.408 | 30.406 | 15.807 | 21.277 |
| hex: canterbury-large/world192.txt | 524290 | 15580.2 ± 0.9% | 1465.0 ± 0.3% | 1080.4 ± 0.6% | 503.5 ± 0.9% | 990.3 ± 0.5% | 735.9 ± 0.6% | 10.635 | 14.421 | 30.944 | 15.733 | 21.172 |
| hex: http/html-1kx1024 | 2099200 | 13838.5 ± 0.4% | 1457.9 ± 0.3% | 1064.5 ± 0.4% | 502.2 ± 0.3% | 985.4 ± 0.3% | 692.4 ± 0.1% | 9.492 | 13.000 | 27.557 | 14.044 | 19.986 |
| hex: http/html-16kx64 | 2097280 | 15269.0 ± 0.3% | 1445.1 ± 0.2% | 1076.1 ± 0.2% | 507.3 ± 0.3% | 995.8 ± 0.7% | 735.3 ± 0.2% | 10.566 | 14.189 | 30.097 | 15.333 | 20.765 |
| hex: http/html-1m | 524290 | 15667.6 ± 1.0% | 1470.8 ± 0.2% | 1082.3 ± 0.4% | 499.8 ± 0.7% | 990.8 ± 0.1% | 736.6 ± 0.4% | 10.653 | 14.476 | 31.350 | 15.813 | 21.271 |
| hex: http/json-1kx1024 | 2099200 | 13838.1 ± 0.3% | 1463.7 ± 0.1% | 1066.4 ± 0.1% | 608.3 ± 0.5% | 986.4 ± 0.1% | 692.4 ± 0.4% | 9.454 | 12.976 | 22.750 | 14.029 | 19.986 |
| hex: http/json-16kx64 | 2097280 | 15290.2 ± 0.3% | 1446.7 ± 0.2% | 1074.7 ± 0.2% | 615.8 ± 0.5% | 997.0 ± 0.3% | 735.3 ± 0.1% | 10.569 | 14.227 | 24.831 | 15.337 | 20.793 |
| hex: http/json-1m | 524290 | 15662.9 ± 0.4% | 1475.4 ± 0.3% | 1088.6 ± 0.3% | 634.3 ± 1.1% | 994.3 ± 0.6% | 734.6 ± 0.6% | 10.616 | 14.388 | 24.693 | 15.753 | 21.322 |
| hex: http/js-1kx1024 | 2099200 | 13841.9 ± 0.4% | 1456.5 ± 0.1% | 1065.1 ± 0.2% | 498.9 ± 0.3% | 983.6 ± 0.6% | 692.6 ± 0.1% | 9.503 | 12.996 | 27.745 | 14.073 | 19.987 |
| hex: http/js-16kx64 | 2097280 | 15306.9 ± 0.5% | 1444.2 ± 0.2% | 1074.8 ± 0.1% | 504.4 ± 0.2% | 995.0 ± 0.5% | 735.0 ± 0.2% | 10.599 | 14.241 | 30.349 | 15.384 | 20.825 |
| hex: http/js-1m | 524290 | 15697.9 ± 0.1% | 1469.1 ± 0.3% | 1086.2 ± 0.2% | 512.3 ± 0.2% | 992.0 ± 1.0% | 733.6 ± 0.8% | 10.686 | 14.452 | 30.640 | 15.824 | 21.399 |
| hex: http/css-1kx1024 | 2099200 | 13816.1 ± 0.4% | 1457.6 ± 0.1% | 1064.2 ± 0.3% | 531.4 ± 0.3% | 983.2 ± 0.2% | 692.4 ± 0.1% | 9.479 | 12.983 | 26.001 | 14.052 | 19.954 |
| hex: http/css-16kx64 | 2097280 | 15263.7 ± 0.5% | 1441.9 ± 0.2% | 1074.7 ± 0.2% | 538.8 ± 0.3% | 997.2 ± 0.4% | 735.2 ± 0.3% | 10.586 | 14.202 | 28.328 | 15.306 | 20.761 |
| hex: http/css-1m | 524290 | 15677.5 ± 0.7% | 1463.9 ± 0.2% | 1087.3 ± 0.3% | 525.2 ± 0.4% | 991.7 ± 0.5% | 735.3 ± 0.5% | 10.710 | 14.419 | 29.851 | 15.808 | 21.321 |
| hex: shuffled/dickens-1m | 524290 | 15669.9 ± 0.8% | 1468.3 ± 0.6% | 1089.1 ± 0.5% | 501.0 ± 0.5% | 992.4 ± 0.6% | 735.3 ± 0.8% | 10.672 | 14.388 | 31.276 | 15.791 | 21.310 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 937.5 ± 0.2% | 931.8 ± 0.4% | 1024.3 ± 0.2% | 301.5 ± 0.9% | 664.5 ± 0.2% | 310.9 ± 1.8% | 1.006 | 0.915 | 3.110 | 1.411 | 3.015 |
| qlog records, JSON text sequence | 1467503 | 787.5 ± 0.9% | 818.3 ± 0.1% | 807.0 ± 0.3% | 244.0 ± 0.6% | 700.6 ± 0.8% | 251.5 ± 0.5% | 0.962 | 0.976 | 3.227 | 1.124 | 3.132 |
| string: silesia/dickens | 172528 | 5051.7 ± 0.7% | 1877.2 ± 0.2% | 2646.7 ± 0.0% | 361.7 ± 0.7% | 2856.1 ± 0.3% | 552.7 ± 1.7% | 2.691 | 1.909 | 13.965 | 1.769 | 9.139 |
| string: silesia/nci | 1075110 | 4307.9 ± 0.4% | 2239.9 ± 0.3% | 2997.9 ± 0.4% | 543.2 ± 1.2% | 3017.9 ± 0.8% | 596.9 ± 1.4% | 1.923 | 1.437 | 7.931 | 1.427 | 7.217 |
| string: silesia/reymont | 1075159 | 2986.7 ± 2.0% | 1830.8 ± 2.1% | 2064.4 ± 0.3% | 374.9 ± 1.2% | 2145.2 ± 0.6% | 532.0 ± 0.8% | 1.631 | 1.447 | 7.967 | 1.392 | 5.614 |
| string: silesia/samba | 97582 | 3505.8 ± 0.2% | 2022.6 ± 0.6% | 2618.4 ± 0.4% | 329.3 ± 0.5% | 1500.5 ± 0.5% | 427.9 ± 1.6% | 1.733 | 1.339 | 10.646 | 2.337 | 8.193 |
| string: silesia/webster | 1098490 | 3677.2 ± 1.1% | 1518.9 ± 0.4% | 2017.2 ± 0.8% | 359.0 ± 0.6% | 2179.5 ± 0.6% | 494.2 ± 1.5% | 2.421 | 1.823 | 10.243 | 1.687 | 7.441 |
| string: silesia/xml | 1090118 | 4820.4 ± 0.8% | 2362.6 ± 0.3% | 2532.3 ± 0.2% | 456.1 ± 1.9% | 2863.7 ± 0.3% | 563.5 ± 1.5% | 2.040 | 1.904 | 10.569 | 1.683 | 8.555 |
| string: canterbury/alice29.txt | 159425 | 4356.7 ± 0.9% | 1599.3 ± 0.5% | 2459.7 ± 0.3% | 342.5 ± 0.6% | 2503.8 ± 0.4% | 507.4 ± 0.8% | 2.724 | 1.771 | 12.722 | 1.740 | 8.586 |
| string: canterbury/asyoulik.txt | 132198 | 3499.6 ± 0.7% | 1460.2 ± 0.1% | 2240.5 ± 0.6% | 336.3 ± 0.8% | 2082.6 ± 0.6% | 464.0 ± 1.5% | 2.397 | 1.562 | 10.406 | 1.680 | 7.542 |
| string: canterbury/lcet10.txt | 441884 | 5126.9 ± 0.2% | 1851.7 ± 0.2% | 2334.7 ± 1.2% | 391.3 ± 0.7% | 2842.5 ± 0.4% | 536.6 ± 2.1% | 2.769 | 2.196 | 13.101 | 1.804 | 9.554 |
| string: canterbury/plrabn12.txt | 503330 | 4131.0 ± 0.2% | 1737.9 ± 0.1% | 2055.6 ± 0.6% | 361.7 ± 0.9% | 2507.4 ± 1.0% | 501.1 ± 2.0% | 2.377 | 2.010 | 11.422 | 1.648 | 8.243 |
| string: canterbury-large/E.coli | 1048578 | 11901.0 ± 0.4% | 3611.1 ± 0.7% | 3258.6 ± 0.4% | 929.8 ± 0.9% | 6023.7 ± 0.9% | 754.3 ± 2.3% | 3.296 | 3.652 | 12.799 | 1.976 | 15.777 |
| string: canterbury-large/bible.txt | 1055886 | 6926.0 ± 1.3% | 2941.8 ± 0.5% | 2838.8 ± 1.1% | 421.3 ± 2.2% | 3774.9 ± 1.6% | 619.2 ± 0.9% | 2.354 | 2.440 | 16.438 | 1.835 | 11.185 |
| string: canterbury-large/world192.txt | 1103121 | 3401.1 ± 0.4% | 1482.1 ± 0.3% | 2019.7 ± 0.3% | 353.2 ± 0.7% | 2113.8 ± 0.7% | 503.3 ± 1.0% | 2.295 | 1.684 | 9.630 | 1.609 | 6.757 |
| string: http/html-1m | 1058582 | 6237.6 ± 1.4% | 2734.1 ± 0.7% | 2704.2 ± 0.5% | 441.4 ± 0.5% | 3468.6 ± 0.4% | 599.2 ± 0.6% | 2.281 | 2.307 | 14.132 | 1.798 | 10.410 |
| string: http/json-1m | 1190272 | 2551.0 ± 0.4% | 876.7 ± 0.4% | 2252.1 ± 0.6% | 391.1 ± 0.5% | 1063.1 ± 0.5% | 443.7 ± 0.6% | 2.910 | 1.133 | 6.523 | 2.400 | 5.750 |
| string: http/js-1m | 1144362 | 2289.1 ± 0.5% | 1029.3 ± 0.2% | 1637.7 ± 0.6% | 322.0 ± 1.0% | 1522.9 ± 0.8% | 418.7 ± 0.9% | 2.224 | 1.398 | 7.110 | 1.503 | 5.467 |
| string: http/css-1m | 1097820 | 2658.7 ± 0.4% | 1679.5 ± 0.4% | 2227.9 ± 0.9% | 404.8 ± 1.1% | 1944.3 ± 1.3% | 490.1 ± 1.0% | 1.583 | 1.193 | 6.567 | 1.367 | 5.425 |
| string: dickens as Cyrillic and CJK | 1883069 | 3087.9 ± 0.3% | 1688.1 ± 0.2% | 895.6 ± 0.5% | 350.4 ± 0.1% | 667.6 ± 1.1% | 157.6 ± 1.2% | 1.829 | 3.448 | 8.813 | 4.625 | 19.593 |
| string: dickens as Cyrillic and CJK, as \u escapes | 5075485 | 1331.2 ± 0.3% | 980.8 ± 0.3% | 1211.7 ± 0.5% | 216.1 ± 0.6% | 471.4 ± 0.9% | 257.0 ± 4.2% | 1.357 | 1.099 | 6.160 | 2.824 | 5.180 |
| hex: silesia/dickens | 524290 | 12002.4 ± 0.1% | 3615.8 ± 0.3% | 3296.9 ± 0.3% | 503.0 ± 0.8% | 6164.3 ± 2.3% | 783.1 ± 2.5% | 3.319 | 3.641 | 23.864 | 1.947 | 15.327 |
| hex: silesia/mozilla | 524290 | 11985.7 ± 0.1% | 3615.0 ± 0.2% | 3290.4 ± 0.3% | 445.4 ± 0.9% | 6081.0 ± 1.2% | 785.7 ± 0.3% | 3.316 | 3.643 | 26.909 | 1.971 | 15.255 |
| hex: silesia/mr | 524290 | 12008.6 ± 0.1% | 3622.9 ± 0.3% | 3297.9 ± 0.2% | 566.3 ± 1.1% | 6126.3 ± 0.6% | 782.5 ± 0.8% | 3.315 | 3.641 | 21.205 | 1.960 | 15.346 |
| hex: silesia/nci | 524290 | 12005.4 ± 0.1% | 3618.4 ± 0.2% | 3286.9 ± 0.5% | 625.2 ± 0.8% | 6130.4 ± 0.9% | 782.7 ± 0.8% | 3.318 | 3.652 | 19.203 | 1.958 | 15.338 |
| hex: silesia/ooffice | 524290 | 12005.4 ± 0.1% | 3619.9 ± 0.6% | 3306.1 ± 0.3% | 395.1 ± 1.3% | 6135.3 ± 1.1% | 783.7 ± 0.6% | 3.317 | 3.631 | 30.385 | 1.957 | 15.319 |
| hex: silesia/osdb | 524290 | 12015.0 ± 0.1% | 3618.9 ± 0.2% | 3297.0 ± 0.4% | 480.5 ± 0.5% | 6144.0 ± 1.0% | 783.5 ± 0.2% | 3.320 | 3.644 | 25.008 | 1.956 | 15.335 |
| hex: silesia/reymont | 524290 | 11982.1 ± 0.2% | 3615.9 ± 0.2% | 3295.3 ± 0.2% | 516.8 ± 1.2% | 6067.5 ± 1.3% | 785.2 ± 0.5% | 3.314 | 3.636 | 23.187 | 1.975 | 15.260 |
| hex: silesia/samba | 524290 | 11993.4 ± 0.1% | 3619.2 ± 0.2% | 3300.0 ± 0.5% | 402.2 ± 1.0% | 6103.1 ± 1.0% | 783.6 ± 0.6% | 3.314 | 3.634 | 29.822 | 1.965 | 15.306 |
| hex: silesia/sao | 524290 | 12020.6 ± 0.1% | 3615.8 ± 0.2% | 3304.1 ± 0.4% | 336.2 ± 1.9% | 6110.5 ± 1.4% | 784.5 ± 0.6% | 3.324 | 3.638 | 35.754 | 1.967 | 15.322 |
| hex: silesia/webster | 524290 | 12023.9 ± 0.0% | 3620.5 ± 0.4% | 3300.2 ± 0.2% | 458.2 ± 3.3% | 6141.2 ± 0.7% | 785.4 ± 0.7% | 3.321 | 3.643 | 26.241 | 1.958 | 15.309 |
| hex: silesia/x-ray | 524290 | 11937.6 ± 0.4% | 3614.0 ± 0.3% | 3309.1 ± 0.2% | 468.8 ± 0.8% | 6100.6 ± 1.1% | 784.1 ± 0.7% | 3.303 | 3.607 | 25.466 | 1.957 | 15.224 |
| hex: silesia/xml | 524290 | 12004.1 ± 0.1% | 3619.3 ± 0.1% | 3303.4 ± 0.3% | 530.2 ± 0.3% | 6093.6 ± 1.1% | 784.9 ± 0.6% | 3.317 | 3.634 | 22.639 | 1.970 | 15.295 |
| hex: canterbury/alice29.txt | 304180 | 12006.8 ± 0.1% | 3635.3 ± 0.1% | 3338.5 ± 0.1% | 522.0 ± 0.2% | 6162.3 ± 1.4% | 785.6 ± 0.4% | 3.303 | 3.596 | 23.000 | 1.948 | 15.283 |
| hex: canterbury/asyoulik.txt | 250360 | 12006.0 ± 0.1% | 3630.2 ± 0.1% | 3372.5 ± 0.1% | 514.4 ± 0.2% | 6116.7 ± 1.1% | 782.4 ± 0.5% | 3.307 | 3.560 | 23.342 | 1.963 | 15.345 |
| hex: canterbury/cp.html | 49208 | 11909.8 ± 0.0% | 3638.4 ± 0.1% | 3280.4 ± 0.4% | 477.5 ± 1.5% | 6209.7 ± 2.3% | 764.9 ± 1.1% | 3.273 | 3.631 | 24.944 | 1.918 | 15.570 |
| hex: canterbury/fields.c | 22302 | 11777.8 ± 0.1% | 3629.1 ± 0.0% | 3356.2 ± 0.1% | 510.6 ± 1.2% | 6249.0 ± 0.2% | 758.5 ± 1.3% | 3.245 | 3.509 | 23.067 | 1.885 | 15.527 |
| hex: canterbury/grammar.lsp | 7444 | 11253.1 ± 0.1% | 3601.7 ± 0.0% | 3361.9 ± 0.3% | 540.6 ± 2.4% | 6173.4 ± 0.6% | 721.7 ± 1.4% | 3.124 | 3.347 | 20.816 | 1.823 | 15.593 |
| hex: canterbury/kennedy.xls | 524290 | 12014.9 ± 0.1% | 3612.2 ± 0.3% | 3289.8 ± 0.3% | 657.2 ± 3.1% | 6118.7 ± 0.7% | 763.5 ± 1.1% | 3.326 | 3.652 | 18.281 | 1.964 | 15.736 |
| hex: canterbury/lcet10.txt | 524290 | 11975.4 ± 0.2% | 3612.9 ± 0.3% | 3291.0 ± 0.4% | 510.0 ± 1.3% | 6096.1 ± 0.8% | 783.3 ± 0.3% | 3.315 | 3.639 | 23.483 | 1.964 | 15.288 |
| hex: canterbury/plrabn12.txt | 524290 | 12018.3 ± 0.1% | 3608.2 ± 0.3% | 3298.3 ± 0.3% | 501.5 ± 1.5% | 6119.1 ± 1.2% | 784.4 ± 0.4% | 3.331 | 3.644 | 23.966 | 1.964 | 15.321 |
| hex: canterbury/ptt5 | 524290 | 11993.9 ± 0.2% | 3609.4 ± 0.5% | 3283.3 ± 0.4% | 557.1 ± 0.4% | 6125.2 ± 0.6% | 786.1 ± 0.2% | 3.323 | 3.653 | 21.529 | 1.958 | 15.258 |
| hex: canterbury/sum | 76482 | 11909.0 ± 0.2% | 3634.2 ± 0.0% | 3358.7 ± 0.3% | 500.3 ± 3.1% | 6166.7 ± 0.1% | 776.6 ± 1.1% | 3.277 | 3.546 | 23.803 | 1.931 | 15.334 |
| hex: canterbury/xargs.1 | 8456 | 11338.0 ± 0.1% | 3601.3 ± 0.1% | 3366.8 ± 0.2% | 485.8 ± 3.1% | 6147.8 ± 0.6% | 759.6 ± 2.0% | 3.148 | 3.368 | 23.337 | 1.844 | 14.926 |
| hex: canterbury-large/E.coli | 524290 | 12019.4 ± 0.0% | 3616.5 ± 0.2% | 3297.5 ± 0.5% | 688.8 ± 0.2% | 6136.6 ± 1.2% | 781.1 ± 3.8% | 3.324 | 3.645 | 17.449 | 1.959 | 15.388 |
| hex: canterbury-large/bible.txt | 524290 | 12015.3 ± 0.1% | 3616.1 ± 0.4% | 3296.6 ± 0.2% | 512.1 ± 1.0% | 6146.2 ± 1.5% | 784.4 ± 0.7% | 3.323 | 3.645 | 23.465 | 1.955 | 15.319 |
| hex: canterbury-large/world192.txt | 524290 | 11950.4 ± 0.3% | 3619.2 ± 0.2% | 3288.8 ± 0.5% | 485.7 ± 1.8% | 6050.4 ± 1.3% | 784.7 ± 0.4% | 3.302 | 3.634 | 24.607 | 1.975 | 15.230 |
| hex: http/html-1kx1024 | 2099200 | 8830.4 ± 3.4% | 3465.5 ± 0.1% | 2862.8 ± 0.3% | 474.6 ± 0.4% | 5115.2 ± 1.2% | 641.6 ± 1.7% | 2.548 | 3.085 | 18.604 | 1.726 | 13.763 |
| hex: http/html-16kx64 | 2097280 | 11784.6 ± 0.1% | 3611.9 ± 0.1% | 3260.7 ± 0.1% | 479.4 ± 0.5% | 6013.3 ± 0.3% | 756.2 ± 2.0% | 3.263 | 3.614 | 24.583 | 1.960 | 15.583 |
| hex: http/html-1m | 524290 | 12012.9 ± 0.1% | 3617.4 ± 0.3% | 3299.6 ± 0.4% | 499.6 ± 1.1% | 6146.3 ± 1.3% | 785.1 ± 0.8% | 3.321 | 3.641 | 24.044 | 1.955 | 15.301 |
| hex: http/json-1kx1024 | 2099200 | 8806.5 ± 3.4% | 3465.7 ± 0.1% | 2867.8 ± 0.6% | 574.8 ± 1.0% | 5146.4 ± 1.8% | 645.9 ± 1.6% | 2.541 | 3.071 | 15.321 | 1.711 | 13.635 |
| hex: http/json-16kx64 | 2097280 | 11766.3 ± 0.3% | 3611.3 ± 0.1% | 3257.1 ± 0.4% | 573.7 ± 0.6% | 6020.9 ± 0.6% | 752.8 ± 0.8% | 3.258 | 3.613 | 20.509 | 1.954 | 15.629 |
| hex: http/json-1m | 524290 | 12003.8 ± 0.1% | 3616.3 ± 0.3% | 3292.0 ± 0.8% | 586.8 ± 2.0% | 6118.7 ± 1.3% | 781.8 ± 1.6% | 3.319 | 3.646 | 20.457 | 1.962 | 15.354 |
| hex: http/js-1kx1024 | 2099200 | 8809.7 ± 3.4% | 3459.6 ± 0.3% | 2870.2 ± 0.3% | 479.2 ± 0.5% | 5123.7 ± 0.1% | 647.0 ± 0.9% | 2.546 | 3.069 | 18.384 | 1.719 | 13.616 |
| hex: http/js-16kx64 | 2097280 | 11777.5 ± 0.2% | 3611.4 ± 0.3% | 3262.5 ± 0.4% | 479.5 ± 0.6% | 6016.0 ± 0.7% | 752.3 ± 2.3% | 3.261 | 3.610 | 24.560 | 1.958 | 15.654 |
| hex: http/js-1m | 524290 | 11968.9 ± 0.3% | 3613.2 ± 0.2% | 3285.9 ± 0.1% | 497.9 ± 1.0% | 6049.3 ± 1.0% | 782.0 ± 1.2% | 3.313 | 3.642 | 24.040 | 1.979 | 15.306 |
| hex: http/css-1kx1024 | 2099200 | 8795.7 ± 4.0% | 3464.5 ± 0.2% | 2865.3 ± 0.4% | 488.6 ± 1.1% | 5129.5 ± 0.8% | 648.0 ± 3.7% | 2.539 | 3.070 | 18.000 | 1.715 | 13.574 |
| hex: http/css-16kx64 | 2097280 | 11788.6 ± 0.3% | 3612.7 ± 0.2% | 3267.7 ± 0.1% | 493.0 ± 0.6% | 6009.2 ± 0.5% | 762.6 ± 0.9% | 3.263 | 3.608 | 23.910 | 1.962 | 15.458 |
| hex: http/css-1m | 524290 | 12016.1 ± 0.1% | 3617.7 ± 0.3% | 3301.9 ± 0.3% | 498.3 ± 1.2% | 6131.6 ± 0.9% | 783.6 ± 2.1% | 3.321 | 3.639 | 24.113 | 1.960 | 15.335 |
| hex: shuffled/dickens-1m | 524290 | 11940.6 ± 0.1% | 3612.0 ± 0.4% | 3292.7 ± 0.2% | 503.8 ± 1.9% | 6088.0 ± 1.1% | 785.5 ± 0.4% | 3.306 | 3.626 | 23.702 | 1.961 | 15.201 |

## TextReader.next_items against the baselines

stdx's decoder a slice of tokens a call through `TextReader.next_items`, as a caller that reads a text's values in a loop calls it (decision 79). Octets are the text's. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1014.5 ± 0.2% | 931.8 ± 0.4% | 1024.3 ± 0.2% | 301.5 ± 0.9% | 664.5 ± 0.2% | 310.9 ± 1.8% | 1.089 | 0.990 | 3.365 | 1.527 | 3.263 |
| qlog records, JSON text sequence | 1467503 | 841.5 ± 0.8% | 818.3 ± 0.1% | 807.0 ± 0.3% | 244.0 ± 0.6% | 700.6 ± 0.8% | 251.5 ± 0.5% | 1.028 | 1.043 | 3.449 | 1.201 | 3.346 |
| string: silesia/dickens | 172528 | 5057.7 ± 0.3% | 1877.2 ± 0.2% | 2646.7 ± 0.0% | 361.7 ± 0.7% | 2856.1 ± 0.3% | 552.7 ± 1.7% | 2.694 | 1.911 | 13.981 | 1.771 | 9.150 |
| string: silesia/nci | 1075110 | 4308.7 ± 0.4% | 2239.9 ± 0.3% | 2997.9 ± 0.4% | 543.2 ± 1.2% | 3017.9 ± 0.8% | 596.9 ± 1.4% | 1.924 | 1.437 | 7.933 | 1.428 | 7.218 |
| string: silesia/reymont | 1075159 | 2970.2 ± 1.4% | 1830.8 ± 2.1% | 2064.4 ± 0.3% | 374.9 ± 1.2% | 2145.2 ± 0.6% | 532.0 ± 0.8% | 1.622 | 1.439 | 7.923 | 1.385 | 5.583 |
| string: silesia/samba | 97582 | 3514.7 ± 0.2% | 2022.6 ± 0.6% | 2618.4 ± 0.4% | 329.3 ± 0.5% | 1500.5 ± 0.5% | 427.9 ± 1.6% | 1.738 | 1.342 | 10.673 | 2.342 | 8.214 |
| string: silesia/webster | 1098490 | 3669.2 ± 1.0% | 1518.9 ± 0.4% | 2017.2 ± 0.8% | 359.0 ± 0.6% | 2179.5 ± 0.6% | 494.2 ± 1.5% | 2.416 | 1.819 | 10.221 | 1.684 | 7.425 |
| string: silesia/xml | 1090118 | 4825.4 ± 0.7% | 2362.6 ± 0.3% | 2532.3 ± 0.2% | 456.1 ± 1.9% | 2863.7 ± 0.3% | 563.5 ± 1.5% | 2.042 | 1.906 | 10.580 | 1.685 | 8.564 |
| string: canterbury/alice29.txt | 159425 | 4362.8 ± 0.6% | 1599.3 ± 0.5% | 2459.7 ± 0.3% | 342.5 ± 0.6% | 2503.8 ± 0.4% | 507.4 ± 0.8% | 2.728 | 1.774 | 12.740 | 1.742 | 8.598 |
| string: canterbury/asyoulik.txt | 132198 | 3506.6 ± 0.6% | 1460.2 ± 0.1% | 2240.5 ± 0.6% | 336.3 ± 0.8% | 2082.6 ± 0.6% | 464.0 ± 1.5% | 2.401 | 1.565 | 10.427 | 1.684 | 7.557 |
| string: canterbury/lcet10.txt | 441884 | 5128.7 ± 0.6% | 1851.7 ± 0.2% | 2334.7 ± 1.2% | 391.3 ± 0.7% | 2842.5 ± 0.4% | 536.6 ± 2.1% | 2.770 | 2.197 | 13.106 | 1.804 | 9.558 |
| string: canterbury/plrabn12.txt | 503330 | 4130.7 ± 0.4% | 1737.9 ± 0.1% | 2055.6 ± 0.6% | 361.7 ± 0.9% | 2507.4 ± 1.0% | 501.1 ± 2.0% | 2.377 | 2.009 | 11.421 | 1.647 | 8.243 |
| string: canterbury-large/E.coli | 1048578 | 11928.5 ± 0.1% | 3611.1 ± 0.7% | 3258.6 ± 0.4% | 929.8 ± 0.9% | 6023.7 ± 0.9% | 754.3 ± 2.3% | 3.303 | 3.661 | 12.828 | 1.980 | 15.814 |
| string: canterbury-large/bible.txt | 1055886 | 6958.7 ± 0.8% | 2941.8 ± 0.5% | 2838.8 ± 1.1% | 421.3 ± 2.2% | 3774.9 ± 1.6% | 619.2 ± 0.9% | 2.365 | 2.451 | 16.515 | 1.843 | 11.238 |
| string: canterbury-large/world192.txt | 1103121 | 3397.8 ± 0.5% | 1482.1 ± 0.3% | 2019.7 ± 0.3% | 353.2 ± 0.7% | 2113.8 ± 0.7% | 503.3 ± 1.0% | 2.293 | 1.682 | 9.621 | 1.607 | 6.751 |
| string: http/html-1m | 1058582 | 6247.8 ± 1.4% | 2734.1 ± 0.7% | 2704.2 ± 0.5% | 441.4 ± 0.5% | 3468.6 ± 0.4% | 599.2 ± 0.6% | 2.285 | 2.310 | 14.155 | 1.801 | 10.427 |
| string: http/json-1m | 1190272 | 2561.9 ± 0.7% | 876.7 ± 0.4% | 2252.1 ± 0.6% | 391.1 ± 0.5% | 1063.1 ± 0.5% | 443.7 ± 0.6% | 2.922 | 1.138 | 6.551 | 2.410 | 5.775 |
| string: http/js-1m | 1144362 | 2294.2 ± 0.5% | 1029.3 ± 0.2% | 1637.7 ± 0.6% | 322.0 ± 1.0% | 1522.9 ± 0.8% | 418.7 ± 0.9% | 2.229 | 1.401 | 7.126 | 1.506 | 5.479 |
| string: http/css-1m | 1097820 | 2666.0 ± 0.4% | 1679.5 ± 0.4% | 2227.9 ± 0.9% | 404.8 ± 1.1% | 1944.3 ± 1.3% | 490.1 ± 1.0% | 1.587 | 1.197 | 6.585 | 1.371 | 5.440 |
| string: dickens as Cyrillic and CJK | 1883069 | 3084.6 ± 0.3% | 1688.1 ± 0.2% | 895.6 ± 0.5% | 350.4 ± 0.1% | 667.6 ± 1.1% | 157.6 ± 1.2% | 1.827 | 3.444 | 8.804 | 4.620 | 19.573 |
| string: dickens as Cyrillic and CJK, as \u escapes | 5075485 | 1331.2 ± 0.2% | 980.8 ± 0.3% | 1211.7 ± 0.5% | 216.1 ± 0.6% | 471.4 ± 0.9% | 257.0 ± 4.2% | 1.357 | 1.099 | 6.161 | 2.824 | 5.181 |
| hex: silesia/dickens | 524290 | 12009.5 ± 0.1% | 3615.8 ± 0.3% | 3296.9 ± 0.3% | 503.0 ± 0.8% | 6164.3 ± 2.3% | 783.1 ± 2.5% | 3.321 | 3.643 | 23.878 | 1.948 | 15.337 |
| hex: silesia/mozilla | 524290 | 11979.0 ± 0.4% | 3615.0 ± 0.2% | 3290.4 ± 0.3% | 445.4 ± 0.9% | 6081.0 ± 1.2% | 785.7 ± 0.3% | 3.314 | 3.641 | 26.894 | 1.970 | 15.247 |
| hex: silesia/mr | 524290 | 12000.1 ± 0.1% | 3622.9 ± 0.3% | 3297.9 ± 0.2% | 566.3 ± 1.1% | 6126.3 ± 0.6% | 782.5 ± 0.8% | 3.312 | 3.639 | 21.190 | 1.959 | 15.336 |
| hex: silesia/nci | 524290 | 12003.5 ± 0.1% | 3618.4 ± 0.2% | 3286.9 ± 0.5% | 625.2 ± 0.8% | 6130.4 ± 0.9% | 782.7 ± 0.8% | 3.317 | 3.652 | 19.200 | 1.958 | 15.336 |
| hex: silesia/ooffice | 524290 | 12006.0 ± 0.4% | 3619.9 ± 0.6% | 3306.1 ± 0.3% | 395.1 ± 1.3% | 6135.3 ± 1.1% | 783.7 ± 0.6% | 3.317 | 3.631 | 30.386 | 1.957 | 15.320 |
| hex: silesia/osdb | 524290 | 12020.4 ± 0.0% | 3618.9 ± 0.2% | 3297.0 ± 0.4% | 480.5 ± 0.5% | 6144.0 ± 1.0% | 783.5 ± 0.2% | 3.322 | 3.646 | 25.019 | 1.956 | 15.342 |
| hex: silesia/reymont | 524290 | 11994.7 ± 0.4% | 3615.9 ± 0.2% | 3295.3 ± 0.2% | 516.8 ± 1.2% | 6067.5 ± 1.3% | 785.2 ± 0.5% | 3.317 | 3.640 | 23.211 | 1.977 | 15.276 |
| hex: silesia/samba | 524290 | 11994.9 ± 0.1% | 3619.2 ± 0.2% | 3300.0 ± 0.5% | 402.2 ± 1.0% | 6103.1 ± 1.0% | 783.6 ± 0.6% | 3.314 | 3.635 | 29.826 | 1.965 | 15.308 |
| hex: silesia/sao | 524290 | 12024.4 ± 0.1% | 3615.8 ± 0.2% | 3304.1 ± 0.4% | 336.2 ± 1.9% | 6110.5 ± 1.4% | 784.5 ± 0.6% | 3.325 | 3.639 | 35.765 | 1.968 | 15.327 |
| hex: silesia/webster | 524290 | 12021.3 ± 0.1% | 3620.5 ± 0.4% | 3300.2 ± 0.2% | 458.2 ± 3.3% | 6141.2 ± 0.7% | 785.4 ± 0.7% | 3.320 | 3.643 | 26.236 | 1.957 | 15.305 |
| hex: silesia/x-ray | 524290 | 11936.7 ± 0.4% | 3614.0 ± 0.3% | 3309.1 ± 0.2% | 468.8 ± 0.8% | 6100.6 ± 1.1% | 784.1 ± 0.7% | 3.303 | 3.607 | 25.464 | 1.957 | 15.223 |
| hex: silesia/xml | 524290 | 12001.7 ± 0.1% | 3619.3 ± 0.1% | 3303.4 ± 0.3% | 530.2 ± 0.3% | 6093.6 ± 1.1% | 784.9 ± 0.6% | 3.316 | 3.633 | 22.635 | 1.970 | 15.292 |
| hex: canterbury/alice29.txt | 304180 | 12010.0 ± 0.2% | 3635.3 ± 0.1% | 3338.5 ± 0.1% | 522.0 ± 0.2% | 6162.3 ± 1.4% | 785.6 ± 0.4% | 3.304 | 3.597 | 23.006 | 1.949 | 15.287 |
| hex: canterbury/asyoulik.txt | 250360 | 12002.6 ± 0.1% | 3630.2 ± 0.1% | 3372.5 ± 0.1% | 514.4 ± 0.2% | 6116.7 ± 1.1% | 782.4 ± 0.5% | 3.306 | 3.559 | 23.335 | 1.962 | 15.341 |
| hex: canterbury/cp.html | 49208 | 11920.5 ± 0.0% | 3638.4 ± 0.1% | 3280.4 ± 0.4% | 477.5 ± 1.5% | 6209.7 ± 2.3% | 764.9 ± 1.1% | 3.276 | 3.634 | 24.967 | 1.920 | 15.584 |
| hex: canterbury/fields.c | 22302 | 11780.7 ± 0.1% | 3629.1 ± 0.0% | 3356.2 ± 0.1% | 510.6 ± 1.2% | 6249.0 ± 0.2% | 758.5 ± 1.3% | 3.246 | 3.510 | 23.073 | 1.885 | 15.531 |
| hex: canterbury/grammar.lsp | 7444 | 11313.5 ± 0.6% | 3601.7 ± 0.0% | 3361.9 ± 0.3% | 540.6 ± 2.4% | 6173.4 ± 0.6% | 721.7 ± 1.4% | 3.141 | 3.365 | 20.928 | 1.833 | 15.677 |
| hex: canterbury/kennedy.xls | 524290 | 12015.1 ± 0.5% | 3612.2 ± 0.3% | 3289.8 ± 0.3% | 657.2 ± 3.1% | 6118.7 ± 0.7% | 763.5 ± 1.1% | 3.326 | 3.652 | 18.281 | 1.964 | 15.736 |
| hex: canterbury/lcet10.txt | 524290 | 11989.3 ± 0.1% | 3612.9 ± 0.3% | 3291.0 ± 0.4% | 510.0 ± 1.3% | 6096.1 ± 0.8% | 783.3 ± 0.3% | 3.318 | 3.643 | 23.511 | 1.967 | 15.306 |
| hex: canterbury/plrabn12.txt | 524290 | 12015.7 ± 0.1% | 3608.2 ± 0.3% | 3298.3 ± 0.3% | 501.5 ± 1.5% | 6119.1 ± 1.2% | 784.4 ± 0.4% | 3.330 | 3.643 | 23.961 | 1.964 | 15.318 |
| hex: canterbury/ptt5 | 524290 | 11986.1 ± 0.2% | 3609.4 ± 0.5% | 3283.3 ± 0.4% | 557.1 ± 0.4% | 6125.2 ± 0.6% | 786.1 ± 0.2% | 3.321 | 3.651 | 21.514 | 1.957 | 15.248 |
| hex: canterbury/sum | 76482 | 11910.4 ± 0.1% | 3634.2 ± 0.0% | 3358.7 ± 0.3% | 500.3 ± 3.1% | 6166.7 ± 0.1% | 776.6 ± 1.1% | 3.277 | 3.546 | 23.806 | 1.931 | 15.336 |
| hex: canterbury/xargs.1 | 8456 | 11337.0 ± 0.1% | 3601.3 ± 0.1% | 3366.8 ± 0.2% | 485.8 ± 3.1% | 6147.8 ± 0.6% | 759.6 ± 2.0% | 3.148 | 3.367 | 23.335 | 1.844 | 14.924 |
| hex: canterbury-large/E.coli | 524290 | 12006.6 ± 0.1% | 3616.5 ± 0.2% | 3297.5 ± 0.5% | 688.8 ± 0.2% | 6136.6 ± 1.2% | 781.1 ± 3.8% | 3.320 | 3.641 | 17.431 | 1.957 | 15.372 |
| hex: canterbury-large/bible.txt | 524290 | 12019.0 ± 0.1% | 3616.1 ± 0.4% | 3296.6 ± 0.2% | 512.1 ± 1.0% | 6146.2 ± 1.5% | 784.4 ± 0.7% | 3.324 | 3.646 | 23.472 | 1.956 | 15.323 |
| hex: canterbury-large/world192.txt | 524290 | 11969.7 ± 0.2% | 3619.2 ± 0.2% | 3288.8 ± 0.5% | 485.7 ± 1.8% | 6050.4 ± 1.3% | 784.7 ± 0.4% | 3.307 | 3.640 | 24.646 | 1.978 | 15.254 |
| hex: http/html-1kx1024 | 2099200 | 8865.7 ± 3.6% | 3465.5 ± 0.1% | 2862.8 ± 0.3% | 474.6 ± 0.4% | 5115.2 ± 1.2% | 641.6 ± 1.7% | 2.558 | 3.097 | 18.679 | 1.733 | 13.818 |
| hex: http/html-16kx64 | 2097280 | 11785.4 ± 0.2% | 3611.9 ± 0.1% | 3260.7 ± 0.1% | 479.4 ± 0.5% | 6013.3 ± 0.3% | 756.2 ± 2.0% | 3.263 | 3.614 | 24.584 | 1.960 | 15.584 |
| hex: http/html-1m | 524290 | 12017.5 ± 0.1% | 3617.4 ± 0.3% | 3299.6 ± 0.4% | 499.6 ± 1.1% | 6146.3 ± 1.3% | 785.1 ± 0.8% | 3.322 | 3.642 | 24.053 | 1.955 | 15.307 |
| hex: http/json-1kx1024 | 2099200 | 8923.7 ± 3.7% | 3465.7 ± 0.1% | 2867.8 ± 0.6% | 574.8 ± 1.0% | 5146.4 ± 1.8% | 645.9 ± 1.6% | 2.575 | 3.112 | 15.525 | 1.734 | 13.816 |
| hex: http/json-16kx64 | 2097280 | 11780.6 ± 0.1% | 3611.3 ± 0.1% | 3257.1 ± 0.4% | 573.7 ± 0.6% | 6020.9 ± 0.6% | 752.8 ± 0.8% | 3.262 | 3.617 | 20.534 | 1.957 | 15.648 |
| hex: http/json-1m | 524290 | 12009.4 ± 0.1% | 3616.3 ± 0.3% | 3292.0 ± 0.8% | 586.8 ± 2.0% | 6118.7 ± 1.3% | 781.8 ± 1.6% | 3.321 | 3.648 | 20.467 | 1.963 | 15.362 |
| hex: http/js-1kx1024 | 2099200 | 8875.1 ± 4.3% | 3459.6 ± 0.3% | 2870.2 ± 0.3% | 479.2 ± 0.5% | 5123.7 ± 0.1% | 647.0 ± 0.9% | 2.565 | 3.092 | 18.521 | 1.732 | 13.717 |
| hex: http/js-16kx64 | 2097280 | 11787.2 ± 0.1% | 3611.4 ± 0.3% | 3262.5 ± 0.4% | 479.5 ± 0.6% | 6016.0 ± 0.7% | 752.3 ± 2.3% | 3.264 | 3.613 | 24.580 | 1.959 | 15.667 |
| hex: http/js-1m | 524290 | 11973.8 ± 0.2% | 3613.2 ± 0.2% | 3285.9 ± 0.1% | 497.9 ± 1.0% | 6049.3 ± 1.0% | 782.0 ± 1.2% | 3.314 | 3.644 | 24.050 | 1.979 | 15.312 |
| hex: http/css-1kx1024 | 2099200 | 8854.3 ± 4.4% | 3464.5 ± 0.2% | 2865.3 ± 0.4% | 488.6 ± 1.1% | 5129.5 ± 0.8% | 648.0 ± 3.7% | 2.556 | 3.090 | 18.120 | 1.726 | 13.665 |
| hex: http/css-16kx64 | 2097280 | 11774.6 ± 0.4% | 3612.7 ± 0.2% | 3267.7 ± 0.1% | 493.0 ± 0.6% | 6009.2 ± 0.5% | 762.6 ± 0.9% | 3.259 | 3.603 | 23.882 | 1.959 | 15.440 |
| hex: http/css-1m | 524290 | 12020.4 ± 0.0% | 3617.7 ± 0.3% | 3301.9 ± 0.3% | 498.3 ± 1.2% | 6131.6 ± 0.9% | 783.6 ± 2.1% | 3.323 | 3.640 | 24.122 | 1.960 | 15.341 |
| hex: shuffled/dickens-1m | 524290 | 11939.1 ± 0.2% | 3612.0 ± 0.4% | 3292.7 ± 0.2% | 503.8 ± 1.9% | 6088.0 ± 1.1% | 785.5 ± 0.4% | 3.305 | 3.626 | 23.699 | 1.961 | 15.200 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1359.2 ± 0.5% | 1251.4 ± 0.2% | 1040.7 ± 0.5% | 409.8 ± 0.6% | 448.4 ± 0.1% | 415.1 ± 0.3% | 1.086 | 1.306 | 3.317 | 3.031 | 3.275 |
| qlog records, JSON text sequence | 1467503 | 1053.0 ± 0.1% | 1062.6 ± 0.3% | 786.2 ± 0.5% | 379.4 ± 0.9% | 468.7 ± 0.9% | 278.9 ± 0.3% | 0.991 | 1.339 | 2.776 | 2.247 | 3.775 |
| string: silesia/dickens | 172528 | 6903.5 ± 0.1% | 2823.2 ± 0.3% | 2925.1 ± 1.0% | 431.4 ± 0.7% | 1572.0 ± 0.3% | 1010.8 ± 0.1% | 2.445 | 2.360 | 16.001 | 4.392 | 6.830 |
| string: silesia/nci | 1075110 | 7309.0 ± 0.4% | 3420.8 ± 1.4% | 3100.4 ± 0.3% | 812.8 ± 2.2% | 1855.4 ± 0.1% | 1108.6 ± 0.4% | 2.137 | 2.357 | 8.992 | 3.939 | 6.593 |
| string: silesia/reymont | 1075159 | 3328.8 ± 2.3% | 2003.1 ± 1.3% | 2062.8 ± 0.5% | 450.7 ± 0.5% | 1509.3 ± 1.3% | 950.6 ± 0.3% | 1.662 | 1.614 | 7.385 | 2.205 | 3.502 |
| string: silesia/samba | 97582 | 4214.7 ± 0.6% | 2110.6 ± 1.2% | 3446.4 ± 0.7% | 353.3 ± 0.6% | 1437.1 ± 0.3% | 1055.1 ± 0.4% | 1.997 | 1.223 | 11.931 | 2.933 | 3.994 |
| string: silesia/webster | 1098490 | 4075.7 ± 0.7% | 1880.2 ± 0.5% | 2056.6 ± 0.6% | 442.5 ± 0.1% | 1388.3 ± 0.1% | 645.6 ± 0.5% | 2.168 | 1.982 | 9.210 | 2.936 | 6.313 |
| string: silesia/xml | 1090118 | 6139.3 ± 0.4% | 2875.8 ± 0.4% | 2649.6 ± 0.7% | 610.0 ± 0.5% | 1754.4 ± 0.6% | 923.4 ± 0.8% | 2.135 | 2.317 | 10.065 | 3.499 | 6.649 |
| string: canterbury/alice29.txt | 159425 | 6451.0 ± 1.3% | 2196.1 ± 0.3% | 2769.2 ± 0.8% | 408.0 ± 1.0% | 1464.7 ± 0.4% | 955.5 ± 0.2% | 2.938 | 2.330 | 15.811 | 4.404 | 6.751 |
| string: canterbury/asyoulik.txt | 132198 | 5665.6 ± 0.9% | 1711.8 ± 0.6% | 2374.3 ± 0.7% | 401.7 ± 0.4% | 1333.1 ± 0.3% | 885.1 ± 0.2% | 3.310 | 2.386 | 14.105 | 4.250 | 6.401 |
| string: canterbury/lcet10.txt | 441884 | 6254.6 ± 1.0% | 2569.7 ± 0.3% | 2483.0 ± 2.2% | 468.4 ± 0.5% | 1525.7 ± 0.3% | 988.2 ± 0.3% | 2.434 | 2.519 | 13.354 | 4.099 | 6.329 |
| string: canterbury/plrabn12.txt | 503330 | 5727.7 ± 0.3% | 2051.2 ± 0.8% | 2072.2 ± 0.3% | 423.6 ± 0.4% | 1408.4 ± 0.4% | 931.0 ± 0.5% | 2.792 | 2.764 | 13.522 | 4.067 | 6.152 |
| string: canterbury-large/E.coli | 1048578 | 19414.9 ± 0.6% | 9759.4 ± 0.9% | 3788.1 ± 0.6% | 1479.2 ± 0.7% | 2367.6 ± 0.8% | 1193.0 ± 0.6% | 1.989 | 5.125 | 13.126 | 8.200 | 16.274 |
| string: canterbury-large/bible.txt | 1055886 | 6797.7 ± 0.5% | 4136.6 ± 1.2% | 3050.9 ± 1.5% | 504.0 ± 0.5% | 1984.3 ± 0.7% | 1122.9 ± 0.7% | 1.643 | 2.228 | 13.488 | 3.426 | 6.053 |
| string: canterbury-large/world192.txt | 1103121 | 4062.3 ± 0.6% | 1658.9 ± 0.2% | 2001.5 ± 1.2% | 449.0 ± 0.5% | 1357.2 ± 0.3% | 909.0 ± 0.3% | 2.449 | 2.030 | 9.048 | 2.993 | 4.469 |
| string: http/html-1m | 1058582 | 6771.0 ± 0.5% | 3989.0 ± 0.3% | 3047.2 ± 0.7% | 499.7 ± 1.0% | 1929.6 ± 0.5% | 805.8 ± 0.4% | 1.697 | 2.222 | 13.550 | 3.509 | 8.403 |
| string: http/json-1m | 1190272 | 3171.6 ± 0.5% | 1349.2 ± 0.5% | 1557.0 ± 0.7% | 443.8 ± 0.6% | 963.5 ± 0.1% | 766.0 ± 1.0% | 2.351 | 2.037 | 7.146 | 3.292 | 4.140 |
| string: http/js-1m | 1144362 | 2777.4 ± 0.7% | 1178.5 ± 0.1% | 1625.1 ± 0.4% | 369.3 ± 0.5% | 1094.4 ± 0.4% | 758.1 ± 0.3% | 2.357 | 1.709 | 7.520 | 2.538 | 3.664 |
| string: http/css-1m | 1097820 | 4004.7 ± 0.5% | 1488.4 ± 0.3% | 2157.3 ± 0.5% | 493.8 ± 0.6% | 1368.9 ± 0.3% | 894.8 ± 0.6% | 2.691 | 1.856 | 8.110 | 2.926 | 4.476 |
| string: dickens as Cyrillic and CJK | 1883069 | 3079.0 ± 0.5% | 2342.2 ± 0.4% | 521.8 ± 0.5% | 306.9 ± 1.2% | 561.3 ± 0.6% | 336.1 ± 0.2% | 1.315 | 5.901 | 10.032 | 5.485 | 9.161 |
| hex: silesia/dickens | 524290 | 15663.2 ± 0.5% | 1463.6 ± 0.2% | 1080.8 ± 0.3% | 499.5 ± 0.6% | 987.3 ± 0.3% | 734.7 ± 0.7% | 10.701 | 14.493 | 31.361 | 15.864 | 21.318 |
| hex: silesia/mozilla | 524290 | 15619.1 ± 0.5% | 1475.2 ± 0.5% | 1087.6 ± 0.2% | 442.0 ± 0.6% | 991.5 ± 0.9% | 736.3 ± 0.6% | 10.587 | 14.361 | 35.341 | 15.753 | 21.212 |
| hex: silesia/mr | 524290 | 15677.3 ± 0.5% | 1480.7 ± 0.1% | 1093.2 ± 0.4% | 554.0 ± 1.9% | 996.6 ± 0.2% | 736.0 ± 0.4% | 10.588 | 14.341 | 28.299 | 15.731 | 21.301 |
| hex: silesia/nci | 524290 | 15674.2 ± 0.4% | 1472.8 ± 0.6% | 1091.3 ± 0.5% | 631.7 ± 3.8% | 990.4 ± 0.8% | 736.8 ± 0.6% | 10.642 | 14.363 | 24.814 | 15.826 | 21.275 |
| hex: silesia/ooffice | 524290 | 15666.9 ± 0.2% | 1466.8 ± 0.3% | 1085.3 ± 0.3% | 388.7 ± 0.6% | 989.2 ± 0.8% | 734.3 ± 0.7% | 10.681 | 14.435 | 40.305 | 15.838 | 21.335 |
| hex: silesia/osdb | 524290 | 15655.2 ± 0.5% | 1469.7 ± 0.4% | 1089.0 ± 0.5% | 470.4 ± 1.8% | 990.0 ± 0.6% | 735.9 ± 0.5% | 10.652 | 14.376 | 33.278 | 15.813 | 21.272 |
| hex: silesia/reymont | 524290 | 15693.2 ± 0.4% | 1462.1 ± 0.6% | 1087.6 ± 0.6% | 511.3 ± 1.8% | 989.6 ± 0.3% | 736.8 ± 0.7% | 10.733 | 14.429 | 30.691 | 15.858 | 21.299 |
| hex: silesia/samba | 524290 | 15682.8 ± 0.2% | 1468.6 ± 0.5% | 1082.7 ± 0.5% | 403.7 ± 0.8% | 990.4 ± 0.3% | 735.8 ± 0.4% | 10.679 | 14.485 | 38.847 | 15.835 | 21.314 |
| hex: silesia/sao | 524290 | 15554.1 ± 0.9% | 1465.0 ± 0.3% | 1082.2 ± 1.3% | 333.4 ± 0.4% | 993.3 ± 0.3% | 736.6 ± 0.5% | 10.617 | 14.373 | 46.648 | 15.658 | 21.116 |
| hex: silesia/webster | 524290 | 15702.7 ± 0.4% | 1468.2 ± 0.3% | 1083.9 ± 0.6% | 471.6 ± 0.6% | 989.0 ± 0.5% | 736.9 ± 0.3% | 10.695 | 14.487 | 33.297 | 15.877 | 21.309 |
| hex: silesia/x-ray | 524290 | 15662.7 ± 0.1% | 1472.6 ± 0.4% | 1089.7 ± 0.6% | 447.0 ± 1.0% | 995.9 ± 0.4% | 734.3 ± 0.6% | 10.636 | 14.374 | 35.039 | 15.727 | 21.329 |
| hex: silesia/xml | 524290 | 15634.5 ± 0.2% | 1470.9 ± 0.3% | 1089.2 ± 0.7% | 615.2 ± 0.6% | 995.4 ± 0.5% | 735.3 ± 0.4% | 10.630 | 14.354 | 25.412 | 15.706 | 21.263 |
| hex: canterbury/alice29.txt | 304180 | 15687.7 ± 0.4% | 1471.8 ± 0.6% | 1087.6 ± 0.3% | 502.3 ± 0.5% | 997.2 ± 0.6% | 736.8 ± 0.4% | 10.659 | 14.424 | 31.234 | 15.731 | 21.292 |
| hex: canterbury/asyoulik.txt | 250360 | 15695.9 ± 0.1% | 1475.8 ± 0.2% | 1090.4 ± 0.2% | 497.3 ± 1.9% | 998.5 ± 0.4% | 740.8 ± 0.5% | 10.635 | 14.394 | 31.564 | 15.720 | 21.189 |
| hex: canterbury/cp.html | 49208 | 15667.7 ± 0.0% | 1478.5 ± 0.7% | 1098.0 ± 0.2% | 523.9 ± 5.1% | 1000.8 ± 0.3% | 742.4 ± 0.2% | 10.597 | 14.269 | 29.904 | 15.656 | 21.104 |
| hex: canterbury/fields.c | 22302 | 15522.6 ± 0.0% | 1413.1 ± 0.3% | 1066.2 ± 0.5% | 622.4 ± 6.6% | 994.7 ± 0.0% | 737.0 ± 0.2% | 10.985 | 14.559 | 24.938 | 15.606 | 21.062 |
| hex: canterbury/grammar.lsp | 7444 | 15151.3 ± 0.1% | 1508.8 ± 0.2% | 1096.3 ± 0.2% | 663.2 ± 3.1% | 993.3 ± 0.5% | 726.0 ± 0.1% | 10.042 | 13.820 | 22.845 | 15.254 | 20.870 |
| hex: canterbury/kennedy.xls | 524290 | 15616.9 ± 0.4% | 1475.1 ± 0.1% | 1091.0 ± 0.2% | 649.6 ± 2.3% | 991.1 ± 0.6% | 736.0 ± 0.3% | 10.587 | 14.315 | 24.041 | 15.756 | 21.220 |
| hex: canterbury/lcet10.txt | 524290 | 15547.5 ± 0.6% | 1463.0 ± 0.1% | 1085.7 ± 0.4% | 498.9 ± 3.9% | 991.2 ± 0.4% | 736.8 ± 0.5% | 10.627 | 14.320 | 31.166 | 15.686 | 21.102 |
| hex: canterbury/plrabn12.txt | 524290 | 15644.0 ± 0.4% | 1463.1 ± 0.2% | 1085.9 ± 0.2% | 492.7 ± 0.8% | 988.0 ± 0.8% | 737.5 ± 0.7% | 10.693 | 14.406 | 31.752 | 15.835 | 21.213 |
| hex: canterbury/ptt5 | 524290 | 15628.9 ± 0.7% | 1483.9 ± 0.3% | 1092.9 ± 0.3% | 557.7 ± 0.9% | 995.6 ± 0.5% | 736.7 ± 0.3% | 10.532 | 14.300 | 28.022 | 15.697 | 21.215 |
| hex: canterbury/sum | 76482 | 15679.8 ± 0.0% | 1494.4 ± 0.1% | 1105.7 ± 0.1% | 597.8 ± 1.1% | 998.0 ± 0.0% | 744.9 ± 0.1% | 10.493 | 14.182 | 26.230 | 15.711 | 21.050 |
| hex: canterbury/xargs.1 | 8456 | 15201.4 ± 0.0% | 1492.4 ± 0.6% | 1095.1 ± 0.3% | 651.0 ± 6.1% | 983.3 ± 0.3% | 728.7 ± 0.1% | 10.186 | 13.882 | 23.352 | 15.460 | 20.861 |
| hex: canterbury-large/E.coli | 524290 | 15688.0 ± 0.2% | 1473.7 ± 0.5% | 1089.6 ± 0.4% | 673.2 ± 0.3% | 996.4 ± 1.6% | 736.7 ± 0.5% | 10.645 | 14.397 | 23.304 | 15.745 | 21.294 |
| hex: canterbury-large/bible.txt | 524290 | 15640.3 ± 0.7% | 1464.7 ± 0.2% | 1084.5 ± 0.5% | 513.9 ± 1.3% | 988.5 ± 0.4% | 734.4 ± 0.5% | 10.678 | 14.422 | 30.435 | 15.822 | 21.297 |
| hex: canterbury-large/world192.txt | 524290 | 15557.3 ± 0.9% | 1465.0 ± 0.3% | 1080.4 ± 0.6% | 503.5 ± 0.9% | 990.3 ± 0.5% | 735.9 ± 0.6% | 10.619 | 14.399 | 30.898 | 15.710 | 21.141 |
| hex: http/html-1kx1024 | 2099200 | 14261.8 ± 0.5% | 1457.9 ± 0.3% | 1064.5 ± 0.4% | 502.2 ± 0.3% | 985.4 ± 0.3% | 692.4 ± 0.1% | 9.783 | 13.398 | 28.400 | 14.473 | 20.598 |
| hex: http/html-16kx64 | 2097280 | 15354.9 ± 0.7% | 1445.1 ± 0.2% | 1076.1 ± 0.2% | 507.3 ± 0.3% | 995.8 ± 0.7% | 735.3 ± 0.2% | 10.625 | 14.268 | 30.266 | 15.420 | 20.882 |
| hex: http/html-1m | 524290 | 15648.3 ± 0.9% | 1470.8 ± 0.2% | 1082.3 ± 0.4% | 499.8 ± 0.7% | 990.8 ± 0.1% | 736.6 ± 0.4% | 10.640 | 14.458 | 31.311 | 15.794 | 21.245 |
| hex: http/json-1kx1024 | 2099200 | 14200.9 ± 0.6% | 1463.7 ± 0.1% | 1066.4 ± 0.1% | 608.3 ± 0.5% | 986.4 ± 0.1% | 692.4 ± 0.4% | 9.702 | 13.316 | 23.346 | 14.396 | 20.510 |
| hex: http/json-16kx64 | 2097280 | 15354.1 ± 0.5% | 1446.7 ± 0.2% | 1074.7 ± 0.2% | 615.8 ± 0.5% | 997.0 ± 0.3% | 735.3 ± 0.1% | 10.613 | 14.287 | 24.934 | 15.401 | 20.880 |
| hex: http/json-1m | 524290 | 15641.2 ± 0.3% | 1475.4 ± 0.3% | 1088.6 ± 0.3% | 634.3 ± 1.1% | 994.3 ± 0.6% | 734.6 ± 0.6% | 10.601 | 14.368 | 24.659 | 15.731 | 21.293 |
| hex: http/js-1kx1024 | 2099200 | 14183.9 ± 0.5% | 1456.5 ± 0.1% | 1065.1 ± 0.2% | 498.9 ± 0.3% | 983.6 ± 0.6% | 692.6 ± 0.1% | 9.738 | 13.317 | 28.430 | 14.421 | 20.480 |
| hex: http/js-16kx64 | 2097280 | 15336.0 ± 0.8% | 1444.2 ± 0.2% | 1074.8 ± 0.1% | 504.4 ± 0.2% | 995.0 ± 0.5% | 735.0 ± 0.2% | 10.619 | 14.268 | 30.406 | 15.413 | 20.865 |
| hex: http/js-1m | 524290 | 15700.2 ± 0.1% | 1469.1 ± 0.3% | 1086.2 ± 0.2% | 512.3 ± 0.2% | 992.0 ± 1.0% | 733.6 ± 0.8% | 10.687 | 14.454 | 30.645 | 15.826 | 21.402 |
| hex: http/css-1kx1024 | 2099200 | 14159.8 ± 0.2% | 1457.6 ± 0.1% | 1064.2 ± 0.3% | 531.4 ± 0.3% | 983.2 ± 0.2% | 692.4 ± 0.1% | 9.714 | 13.306 | 26.648 | 14.402 | 20.450 |
| hex: http/css-16kx64 | 2097280 | 15328.1 ± 0.4% | 1441.9 ± 0.2% | 1074.7 ± 0.2% | 538.8 ± 0.3% | 997.2 ± 0.4% | 735.2 ± 0.3% | 10.631 | 14.262 | 28.448 | 15.371 | 20.848 |
| hex: http/css-1m | 524290 | 15665.7 ± 0.9% | 1463.9 ± 0.2% | 1087.3 ± 0.3% | 525.2 ± 0.4% | 991.7 ± 0.5% | 735.3 ± 0.5% | 10.701 | 14.408 | 29.829 | 15.796 | 21.305 |
| hex: shuffled/dickens-1m | 524290 | 15656.6 ± 0.4% | 1468.3 ± 0.6% | 1089.1 ± 0.5% | 501.0 ± 0.5% | 992.4 ± 0.6% | 735.3 ± 0.8% | 10.663 | 14.376 | 31.249 | 15.777 | 21.292 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.915 of yyjson.
