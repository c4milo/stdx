# bench-json

| Field | Value |
|---|---|
| Commit | f607235 |
| Runner label | ubuntu-24.04-arm |
| Image version | 20261111.182.1 |
| CPU model | Neoverse-N2 |
| Virtual CPUs | 4 |
| Kernel | 7.0.0-1017-azure |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/43487612295 |
| Date | 2026-11-13 |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1. The `TextReader.next_items` column is that helper's queued tokens a slice a call (decision 79), over many tokens a call.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | TextReader.next_items | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1126.3 ± 0.7% | 0.524 | 0.966 | 0.997 | 0.998 | 0.458 | 1.005 | 1.006 | 0.383 | 0.832 | 0.900 | 0.101 |
| qlog records, JSON text sequence | 1467503 | 822.2 ± 2.5% | 0.839 | 1.029 | 1.028 | 1.028 | 0.450 | 1.023 | 1.056 | 0.395 | 0.942 | 1.016 | 0.128 |
| string: silesia/dickens | 172528 | 5040.7 ± 0.2% | 0.033 | 0.781 | 1.003 | 1.003 | 0.197 | 1.017 | 1.007 | 0.196 | 1.003 | 1.002 | 0.032 |
| string: silesia/nci | 1075110 | 4299.3 ± 0.3% | 0.039 | 0.801 | 1.002 | 1.003 | 0.276 | 1.001 | 0.996 | 0.279 | 1.002 | 1.000 | 0.038 |
| string: silesia/reymont | 1075159 | 2926.7 ± 1.0% | 0.057 | 0.820 | 1.006 | 1.007 | 0.360 | 1.013 | 1.010 | 0.360 | 1.020 | 1.023 | 0.056 |
| string: silesia/samba | 97582 | 3489.0 ± 0.5% | 0.041 | 0.863 | 1.005 | 1.006 | 0.069 | 0.779 | 1.011 | 0.067 | 1.003 | 1.007 | 0.041 |
| string: silesia/webster | 1098490 | 3643.8 ± 0.4% | 0.044 | 0.847 | 1.002 | 1.003 | 0.204 | 1.019 | 1.013 | 0.203 | 1.006 | 1.006 | 0.044 |
| string: silesia/xml | 1090118 | 4760.9 ± 0.4% | 0.035 | 0.805 | 1.006 | 1.008 | 0.222 | 0.980 | 1.008 | 0.220 | 1.005 | 1.008 | 0.034 |
| string: canterbury/alice29.txt | 159425 | 4304.0 ± 1.0% | 0.038 | 0.751 | 1.004 | 1.010 | 0.172 | 1.037 | 1.019 | 0.172 | 1.016 | 1.017 | 0.037 |
| string: canterbury/asyoulik.txt | 132198 | 3448.4 ± 1.3% | 0.046 | 0.749 | 1.007 | 1.011 | 0.176 | 1.005 | 0.975 | 0.176 | 1.014 | 1.017 | 0.045 |
| string: canterbury/lcet10.txt | 441884 | 5122.5 ± 0.2% | 0.032 | 0.812 | 1.002 | 1.003 | 0.195 | 1.021 | 1.004 | 0.195 | 1.004 | 1.002 | 0.032 |
| string: canterbury/plrabn12.txt | 503330 | 4110.9 ± 0.6% | 0.040 | 0.826 | 1.005 | 1.008 | 0.198 | 1.014 | 1.000 | 0.198 | 1.005 | 1.006 | 0.039 |
| string: canterbury-large/E.coli | 1048578 | 19058.1 ± 1.0% | 0.077 | 1.011 | 1.006 | 1.004 | 0.479 | 1.009 | 1.002 | 0.479 | 0.622 | 0.622 | 0.009 |
| string: canterbury-large/bible.txt | 1055886 | 6620.2 ± 1.4% | 0.026 | 0.807 | 1.003 | 1.008 | 0.437 | 1.036 | 1.050 | 0.436 | 1.038 | 1.042 | 0.025 |
| string: canterbury-large/world192.txt | 1103121 | 3379.4 ± 0.3% | 0.048 | 0.845 | 1.003 | 1.006 | 0.198 | 1.015 | 1.006 | 0.198 | 1.006 | 1.006 | 0.047 |
| string: http/html-1m | 1058582 | 6019.8 ± 1.5% | 0.029 | 0.785 | 1.011 | 1.045 | 0.390 | 1.042 | 1.059 | 0.391 | 1.034 | 1.037 | 0.028 |
| string: http/json-1m | 1190272 | 2543.8 ± 0.4% | 0.055 | 0.951 | 1.005 | 1.005 | 0.109 | 1.005 | 0.471 | 0.110 | 1.005 | 1.004 | 0.054 |
| string: http/js-1m | 1144362 | 2282.9 ± 0.6% | 0.066 | 0.890 | 1.001 | 1.000 | 0.175 | 1.053 | 1.043 | 0.174 | 0.997 | 1.000 | 0.065 |
| string: http/css-1m | 1097820 | 2631.5 ± 0.4% | 0.061 | 0.778 | 1.005 | 1.010 | 0.238 | 1.008 | 1.014 | 0.240 | 1.008 | 1.009 | 0.059 |
| string: dickens as Cyrillic and CJK | 1883069 | 3052.4 ± 0.9% | 0.044 | 0.125 | 1.005 | 1.006 | 0.338 | 1.004 | 1.012 | 0.338 | 1.006 | 1.007 | 0.044 |
| string: dickens as Cyrillic and CJK, as \u escapes | 5075485 | 1325.8 ± 1.8% | 0.085 | 1.004 | 1.003 | 1.002 | 0.078 | 0.638 | 1.004 | 0.075 | 1.003 | 1.002 | 0.085 |
| hex: silesia/dickens | 524290 | 18258.5 ± 2.0% | 0.081 | 1.015 | 0.996 | 0.994 | 0.529 | 0.994 | 1.006 | 0.527 | 0.657 | 0.657 | 0.009 |
| hex: silesia/mozilla | 524290 | 18640.7 ± 0.5% | 0.080 | 1.004 | 0.999 | 0.990 | 0.512 | 0.994 | 0.986 | 0.515 | 0.643 | 0.643 | 0.009 |
| hex: silesia/mr | 524290 | 18214.9 ± 1.3% | 0.082 | 1.003 | 1.002 | 1.001 | 0.524 | 1.002 | 1.004 | 0.526 | 0.659 | 0.659 | 0.009 |
| hex: silesia/nci | 524290 | 18568.2 ± 1.6% | 0.080 | 1.011 | 1.002 | 0.998 | 0.504 | 1.001 | 1.001 | 0.506 | 0.645 | 0.645 | 0.009 |
| hex: silesia/ooffice | 524290 | 18543.2 ± 1.7% | 0.080 | 0.996 | 0.987 | 0.988 | 0.515 | 0.984 | 0.980 | 0.514 | 0.646 | 0.646 | 0.009 |
| hex: silesia/osdb | 524290 | 18067.9 ± 0.8% | 0.082 | 1.007 | 0.998 | 0.996 | 0.522 | 1.005 | 1.006 | 0.523 | 0.663 | 0.664 | 0.010 |
| hex: silesia/reymont | 524290 | 18361.8 ± 0.2% | 0.081 | 1.001 | 1.000 | 1.000 | 0.514 | 0.994 | 0.994 | 0.515 | 0.653 | 0.653 | 0.009 |
| hex: silesia/samba | 524290 | 18217.0 ± 0.5% | 0.081 | 0.998 | 0.997 | 0.998 | 0.514 | 0.993 | 1.003 | 0.516 | 0.657 | 0.656 | 0.009 |
| hex: silesia/sao | 524290 | 18537.1 ± 2.1% | 0.080 | 1.005 | 0.991 | 0.994 | 0.515 | 0.995 | 0.994 | 0.518 | 0.648 | 0.647 | 0.009 |
| hex: silesia/webster | 524290 | 18362.2 ± 0.9% | 0.081 | 1.006 | 1.003 | 1.006 | 0.517 | 1.007 | 1.006 | 0.516 | 0.649 | 0.652 | 0.009 |
| hex: silesia/x-ray | 524290 | 18339.6 ± 0.3% | 0.081 | 1.006 | 1.001 | 1.000 | 0.528 | 1.000 | 1.003 | 0.526 | 0.654 | 0.655 | 0.009 |
| hex: silesia/xml | 524290 | 18244.7 ± 0.4% | 0.081 | 1.006 | 0.997 | 0.997 | 0.522 | 1.001 | 0.995 | 0.523 | 0.658 | 0.658 | 0.009 |
| hex: canterbury/alice29.txt | 304180 | 18984.6 ± 0.5% | 0.079 | 1.002 | 0.990 | 0.989 | 0.521 | 0.999 | 0.995 | 0.523 | 0.633 | 0.633 | 0.009 |
| hex: canterbury/asyoulik.txt | 250360 | 19515.8 ± 0.3% | 0.077 | 1.003 | 1.003 | 1.003 | 0.510 | 1.002 | 1.002 | 0.510 | 0.615 | 0.615 | 0.009 |
| hex: canterbury/cp.html | 49208 | 19232.7 ± 0.3% | 0.080 | 1.005 | 1.005 | 1.006 | 0.544 | 1.005 | 1.005 | 0.544 | 0.619 | 0.619 | 0.009 |
| hex: canterbury/fields.c | 22302 | 18933.5 ± 0.6% | 0.084 | 1.002 | 1.002 | 1.002 | 0.534 | 1.002 | 0.999 | 0.540 | 0.622 | 0.623 | 0.009 |
| hex: canterbury/grammar.lsp | 7444 | 17584.5 ± 1.0% | 0.089 | 1.001 | 1.002 | 1.002 | 0.525 | 1.000 | 1.001 | 0.542 | 0.640 | 0.645 | 0.010 |
| hex: canterbury/kennedy.xls | 524290 | 18494.3 ± 1.7% | 0.080 | 1.006 | 0.996 | 0.987 | 0.510 | 0.996 | 0.987 | 0.511 | 0.647 | 0.648 | 0.009 |
| hex: canterbury/lcet10.txt | 524290 | 18527.5 ± 1.8% | 0.080 | 1.004 | 0.993 | 0.990 | 0.537 | 0.993 | 0.987 | 0.534 | 0.649 | 0.649 | 0.009 |
| hex: canterbury/plrabn12.txt | 524290 | 18189.4 ± 0.8% | 0.082 | 0.994 | 0.995 | 0.991 | 0.526 | 0.998 | 0.996 | 0.526 | 0.658 | 0.659 | 0.010 |
| hex: canterbury/ptt5 | 524290 | 18192.4 ± 0.3% | 0.082 | 1.005 | 1.000 | 1.000 | 0.532 | 0.998 | 1.002 | 0.532 | 0.658 | 0.659 | 0.010 |
| hex: canterbury/sum | 76482 | 19291.1 ± 0.1% | 0.078 | 1.002 | 1.003 | 1.002 | 0.518 | 1.002 | 1.002 | 0.519 | 0.618 | 0.618 | 0.009 |
| hex: canterbury/xargs.1 | 8456 | 17838.0 ± 0.7% | 0.087 | 1.002 | 1.002 | 1.003 | 0.525 | 1.000 | 1.001 | 0.540 | 0.636 | 0.637 | 0.010 |
| hex: canterbury-large/E.coli | 524290 | 18291.1 ± 1.8% | 0.081 | 1.007 | 1.000 | 1.000 | 0.516 | 0.996 | 1.001 | 0.518 | 0.654 | 0.654 | 0.009 |
| hex: canterbury-large/bible.txt | 524290 | 18254.8 ± 0.5% | 0.081 | 1.011 | 0.995 | 0.996 | 0.521 | 1.001 | 0.996 | 0.522 | 0.657 | 0.657 | 0.009 |
| hex: canterbury-large/world192.txt | 524290 | 18031.5 ± 0.5% | 0.082 | 1.007 | 1.001 | 1.000 | 0.527 | 1.000 | 1.001 | 0.527 | 0.664 | 0.664 | 0.010 |
| hex: http/html-1kx1024 | 2099200 | 9043.7 ± 17.5% | 0.158 | 1.288 | 1.286 | 1.289 | 0.723 | 1.298 | 0.981 | 0.785 | 0.959 | 0.964 | 0.019 |
| hex: http/html-16kx64 | 2097280 | 17697.5 ± 1.4% | 0.085 | 1.025 | 1.022 | 1.020 | 0.577 | 1.021 | 0.986 | 0.583 | 0.664 | 0.665 | 0.010 |
| hex: http/html-1m | 524290 | 18185.1 ± 1.2% | 0.082 | 0.998 | 1.000 | 1.002 | 0.529 | 0.994 | 0.990 | 0.527 | 0.658 | 0.659 | 0.010 |
| hex: http/json-1kx1024 | 2099200 | 9092.1 ± 17.8% | 0.157 | 1.302 | 1.285 | 1.289 | 0.718 | 1.290 | 0.986 | 0.787 | 0.962 | 0.971 | 0.019 |
| hex: http/json-16kx64 | 2097280 | 17958.3 ± 0.9% | 0.084 | 1.016 | 1.011 | 1.013 | 0.570 | 1.013 | 0.975 | 0.575 | 0.655 | 0.654 | 0.010 |
| hex: http/json-1m | 524290 | 18192.3 ± 1.7% | 0.082 | 1.020 | 1.005 | 1.007 | 0.535 | 1.011 | 1.009 | 0.536 | 0.657 | 0.658 | 0.010 |
| hex: http/js-1kx1024 | 2099200 | 9221.3 ± 16.9% | 0.155 | 1.281 | 1.271 | 1.267 | 0.711 | 1.274 | 0.967 | 0.774 | 0.947 | 0.954 | 0.019 |
| hex: http/js-16kx64 | 2097280 | 17627.0 ± 0.6% | 0.085 | 1.030 | 1.026 | 1.024 | 0.580 | 1.026 | 0.991 | 0.586 | 0.667 | 0.667 | 0.010 |
| hex: http/js-1m | 524290 | 18396.2 ± 1.3% | 0.081 | 1.007 | 0.996 | 0.996 | 0.516 | 0.992 | 0.991 | 0.517 | 0.653 | 0.653 | 0.009 |
| hex: http/css-1kx1024 | 2099200 | 9476.7 ± 17.1% | 0.151 | 1.255 | 1.248 | 1.252 | 0.688 | 1.236 | 0.987 | 0.751 | 0.917 | 0.923 | 0.018 |
| hex: http/css-16kx64 | 2097280 | 17903.8 ± 0.8% | 0.084 | 1.018 | 1.013 | 1.013 | 0.570 | 1.013 | 0.979 | 0.575 | 0.657 | 0.657 | 0.010 |
| hex: http/css-1m | 524290 | 18516.8 ± 1.4% | 0.080 | 1.012 | 1.002 | 1.003 | 0.519 | 1.003 | 1.008 | 0.519 | 0.648 | 0.648 | 0.009 |
| hex: shuffled/dickens-1m | 524290 | 17878.5 ± 0.8% | 0.083 | 1.001 | 1.004 | 1.005 | 0.534 | 1.003 | 0.998 | 0.534 | 0.669 | 0.670 | 0.010 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1466.2 ± 0.4% | 0.447 | 1.002 | 0.970 | 1.003 | 1.004 | 0.269 | 1.001 | 0.551 | 0.917 | 0.089 | 1.029 |
| qlog records, JSON text sequence | 1467503 | 1271.4 ± 1.0% | 0.689 | 0.976 | 1.007 | 1.011 | 1.010 | 0.264 | 0.999 | 0.501 | 0.827 | 0.105 | 1.015 |
| string: silesia/dickens | 172528 | 6894.1 ± 0.5% | 0.025 | 1.002 | 1.002 | 1.002 | 1.001 | 0.165 | 0.717 | 1.003 | 1.004 | 0.025 | 1.034 |
| string: silesia/nci | 1075110 | 7283.0 ± 0.6% | 0.024 | 1.003 | 1.001 | 1.003 | 1.001 | 0.210 | 0.567 | 1.003 | 1.002 | 0.024 | 1.012 |
| string: silesia/reymont | 1075159 | 3341.0 ± 1.4% | 0.052 | 0.997 | 0.991 | 0.999 | 1.003 | 0.388 | 0.867 | 0.999 | 1.004 | 0.052 | 1.044 |
| string: silesia/samba | 97582 | 4186.5 ± 1.0% | 0.054 | 1.002 | 1.001 | 1.007 | 1.009 | 0.125 | 0.943 | 1.004 | 1.006 | 0.053 | 1.094 |
| string: silesia/webster | 1098490 | 4041.1 ± 0.5% | 0.043 | 1.008 | 1.006 | 1.008 | 1.010 | 0.211 | 0.887 | 1.003 | 1.005 | 0.042 | 1.013 |
| string: silesia/xml | 1090118 | 6121.4 ± 0.6% | 0.029 | 1.004 | 0.992 | 1.001 | 1.000 | 0.252 | 0.774 | 0.997 | 1.000 | 0.029 | 1.017 |
| string: canterbury/alice29.txt | 159425 | 6436.4 ± 1.1% | 0.027 | 1.009 | 1.011 | 1.010 | 1.013 | 0.131 | 0.651 | 0.999 | 1.003 | 0.026 | 1.063 |
| string: canterbury/asyoulik.txt | 132198 | 5585.0 ± 1.4% | 0.030 | 1.028 | 1.034 | 1.033 | 1.036 | 0.129 | 0.596 | 0.998 | 1.007 | 0.030 | 1.042 |
| string: canterbury/lcet10.txt | 441884 | 6212.8 ± 0.7% | 0.028 | 1.007 | 1.007 | 1.009 | 1.010 | 0.184 | 0.804 | 1.002 | 1.003 | 0.028 | 1.004 |
| string: canterbury/plrabn12.txt | 503330 | 5715.7 ± 0.4% | 0.030 | 1.003 | 1.003 | 1.002 | 1.003 | 0.167 | 0.697 | 1.001 | 1.002 | 0.030 | 1.007 |
| string: canterbury-large/E.coli | 1048578 | 19202.5 ± 1.4% | 0.078 | 1.001 | 1.000 | 0.998 | 1.000 | 0.481 | 1.002 | 1.002 | 1.001 | 0.009 | 1.002 |
| string: canterbury-large/bible.txt | 1055886 | 6773.0 ± 0.2% | 0.026 | 1.001 | 1.003 | 0.996 | 1.002 | 0.496 | 0.972 | 1.001 | 1.002 | 0.026 | 1.000 |
| string: canterbury-large/world192.txt | 1103121 | 4010.7 ± 0.6% | 0.043 | 1.021 | 1.020 | 1.020 | 1.017 | 0.192 | 0.833 | 1.005 | 1.011 | 0.042 | 1.005 |
| string: http/html-1m | 1058582 | 6735.8 ± 0.6% | 0.026 | 1.006 | 0.925 | 1.006 | 1.008 | 0.402 | 0.899 | 1.002 | 1.002 | 0.026 | 1.012 |
| string: http/json-1m | 1190272 | 3158.7 ± 0.4% | 0.051 | 1.000 | 0.966 | 1.001 | 1.000 | 0.132 | 0.371 | 1.000 | 1.000 | 0.051 | 1.040 |
| string: http/js-1m | 1144362 | 2754.6 ± 0.8% | 0.060 | 1.003 | 1.008 | 1.002 | 1.006 | 0.163 | 0.841 | 0.997 | 1.002 | 0.060 | 1.017 |
| string: http/css-1m | 1097820 | 3959.5 ± 0.7% | 0.043 | 1.007 | 1.008 | 1.009 | 1.012 | 0.208 | 0.649 | 1.003 | 1.008 | 0.043 | 1.014 |
| string: dickens as Cyrillic and CJK | 1883069 | 3061.7 ± 0.4% | 0.048 | 1.000 | 0.125 | 1.001 | 1.000 | 0.320 | 1.001 | 1.000 | 1.001 | 0.048 | 1.003 |
| hex: silesia/dickens | 524290 | 15643.0 ± 0.3% | 1.000 | 0.177 | 1.002 | 1.001 | 1.001 | 0.999 | 1.000 | 1.000 | 1.001 | 0.177 | 1.002 |
| hex: silesia/mozilla | 524290 | 15656.0 ± 0.3% | 1.001 | 0.178 | 1.000 | 0.999 | 0.998 | 0.998 | 0.997 | 0.999 | 0.996 | 0.178 | 1.000 |
| hex: silesia/mr | 524290 | 15610.8 ± 0.5% | 1.001 | 0.179 | 1.002 | 1.001 | 1.001 | 1.002 | 1.001 | 1.002 | 1.003 | 0.178 | 1.001 |
| hex: silesia/nci | 524290 | 15617.1 ± 0.5% | 0.999 | 0.178 | 1.001 | 1.001 | 1.000 | 0.998 | 1.000 | 0.998 | 1.000 | 0.178 | 1.001 |
| hex: silesia/ooffice | 524290 | 15605.0 ± 0.3% | 1.000 | 0.178 | 1.000 | 0.999 | 1.000 | 1.000 | 1.000 | 1.000 | 1.001 | 0.178 | 1.002 |
| hex: silesia/osdb | 524290 | 15631.7 ± 0.3% | 1.001 | 0.178 | 1.001 | 1.000 | 1.000 | 1.000 | 0.999 | 1.001 | 1.000 | 0.178 | 1.000 |
| hex: silesia/reymont | 524290 | 15592.7 ± 0.3% | 1.003 | 0.177 | 1.003 | 1.001 | 1.001 | 1.002 | 0.999 | 1.001 | 0.997 | 0.178 | 1.000 |
| hex: silesia/samba | 524290 | 15623.5 ± 0.5% | 1.002 | 0.178 | 1.002 | 1.002 | 1.002 | 1.002 | 1.003 | 1.002 | 0.999 | 0.178 | 1.001 |
| hex: silesia/sao | 524290 | 15649.0 ± 0.3% | 1.002 | 0.177 | 1.001 | 1.000 | 1.001 | 1.000 | 1.003 | 1.002 | 1.002 | 0.177 | 1.001 |
| hex: silesia/webster | 524290 | 15642.5 ± 0.8% | 1.001 | 0.177 | 1.001 | 1.000 | 1.001 | 1.001 | 1.000 | 1.002 | 1.000 | 0.177 | 1.001 |
| hex: silesia/x-ray | 524290 | 15617.4 ± 0.2% | 1.000 | 0.178 | 1.000 | 0.999 | 0.999 | 1.000 | 1.000 | 0.999 | 0.997 | 0.178 | 1.002 |
| hex: silesia/xml | 524290 | 15605.3 ± 0.1% | 1.002 | 0.178 | 1.001 | 1.001 | 1.000 | 1.001 | 0.999 | 1.001 | 1.001 | 0.178 | 1.000 |
| hex: canterbury/alice29.txt | 304180 | 15670.2 ± 0.1% | 1.001 | 0.178 | 1.000 | 1.000 | 1.000 | 1.000 | 1.001 | 1.001 | 0.999 | 0.177 | 1.001 |
| hex: canterbury/asyoulik.txt | 250360 | 15702.0 ± 0.3% | 1.001 | 0.178 | 1.001 | 1.001 | 1.001 | 1.000 | 1.001 | 1.001 | 1.001 | 0.177 | 1.001 |
| hex: canterbury/cp.html | 49208 | 15619.1 ± 0.1% | 1.001 | 0.179 | 1.001 | 1.000 | 1.000 | 0.998 | 1.001 | 1.001 | 1.003 | 0.179 | 1.001 |
| hex: canterbury/fields.c | 22302 | 15439.9 ± 0.1% | 1.002 | 0.181 | 1.000 | 1.000 | 1.000 | 0.994 | 1.000 | 1.001 | 1.005 | 0.180 | 1.001 |
| hex: canterbury/grammar.lsp | 7444 | 14932.9 ± 0.1% | 1.003 | 0.186 | 1.000 | 1.001 | 1.000 | 0.983 | 1.001 | 1.004 | 1.015 | 0.184 | 1.003 |
| hex: canterbury/kennedy.xls | 524290 | 15594.6 ± 0.4% | 1.003 | 0.178 | 1.003 | 1.002 | 1.001 | 1.002 | 1.003 | 1.004 | 1.004 | 0.179 | 1.002 |
| hex: canterbury/lcet10.txt | 524290 | 15616.9 ± 0.3% | 1.002 | 0.178 | 0.999 | 1.000 | 1.001 | 1.001 | 1.002 | 1.002 | 1.000 | 0.178 | 1.002 |
| hex: canterbury/plrabn12.txt | 524290 | 15621.8 ± 0.2% | 1.002 | 0.178 | 1.001 | 1.001 | 1.001 | 1.000 | 1.002 | 1.002 | 0.999 | 0.177 | 1.001 |
| hex: canterbury/ptt5 | 524290 | 15623.9 ± 0.2% | 1.002 | 0.179 | 1.002 | 1.001 | 1.001 | 1.001 | 1.002 | 1.001 | 1.000 | 0.178 | 1.001 |
| hex: canterbury/sum | 76482 | 15636.9 ± 0.2% | 1.002 | 0.179 | 1.001 | 1.000 | 1.001 | 0.999 | 1.000 | 1.001 | 1.003 | 0.178 | 1.001 |
| hex: canterbury/xargs.1 | 8456 | 15005.4 ± 0.2% | 1.002 | 0.185 | 1.000 | 1.000 | 1.000 | 0.985 | 1.000 | 1.002 | 1.014 | 0.183 | 1.002 |
| hex: canterbury-large/E.coli | 524290 | 15663.2 ± 0.2% | 1.001 | 0.177 | 1.000 | 0.999 | 1.000 | 0.999 | 1.000 | 0.999 | 0.999 | 0.178 | 0.999 |
| hex: canterbury-large/bible.txt | 524290 | 15614.0 ± 0.3% | 1.000 | 0.177 | 1.001 | 1.000 | 1.000 | 1.000 | 1.000 | 0.999 | 1.000 | 0.177 | 1.001 |
| hex: canterbury-large/world192.txt | 524290 | 15620.7 ± 0.1% | 1.001 | 0.178 | 1.001 | 1.001 | 0.999 | 1.000 | 0.999 | 0.999 | 1.000 | 0.178 | 1.000 |
| hex: http/html-1kx1024 | 2099200 | 13669.3 ± 0.5% | 1.005 | 0.195 | 1.001 | 1.001 | 1.000 | 0.936 | 0.996 | 1.009 | 1.037 | 0.187 | 1.014 |
| hex: http/html-16kx64 | 2097280 | 15198.1 ± 0.3% | 1.001 | 0.181 | 1.004 | 1.000 | 1.000 | 0.989 | 0.998 | 1.004 | 1.009 | 0.180 | 1.004 |
| hex: http/html-1m | 524290 | 15601.8 ± 0.3% | 1.002 | 0.178 | 1.002 | 1.001 | 1.002 | 1.001 | 1.003 | 1.001 | 1.000 | 0.177 | 1.002 |
| hex: http/json-1kx1024 | 2099200 | 13639.5 ± 0.4% | 1.003 | 0.195 | 1.001 | 0.999 | 0.999 | 0.934 | 0.999 | 1.003 | 1.038 | 0.187 | 1.011 |
| hex: http/json-16kx64 | 2097280 | 15172.9 ± 8.3% | 1.002 | 0.181 | 1.004 | 1.004 | 1.004 | 0.989 | 0.999 | 1.005 | 1.007 | 0.180 | 1.008 |
| hex: http/json-1m | 524290 | 15654.3 ± 0.3% | 1.001 | 0.177 | 0.999 | 1.001 | 1.000 | 0.999 | 1.002 | 1.001 | 0.999 | 0.178 | 1.001 |
| hex: http/js-1kx1024 | 2099200 | 13683.1 ± 0.4% | 1.010 | 0.196 | 1.000 | 1.002 | 0.999 | 0.940 | 0.999 | 1.014 | 1.031 | 0.187 | 1.008 |
| hex: http/js-16kx64 | 2097280 | 15303.1 ± 0.6% | 0.998 | 0.180 | 0.995 | 0.999 | 0.999 | 0.983 | 0.993 | 0.998 | 1.004 | 0.180 | 1.002 |
| hex: http/js-1m | 524290 | 15613.3 ± 0.3% | 1.002 | 0.177 | 1.003 | 1.000 | 1.000 | 1.002 | 1.001 | 1.002 | 1.000 | 0.177 | 1.002 |
| hex: http/css-1kx1024 | 2099200 | 13691.6 ± 0.5% | 0.998 | 0.195 | 0.995 | 1.005 | 1.000 | 0.941 | 1.002 | 0.999 | 1.027 | 0.187 | 1.009 |
| hex: http/css-16kx64 | 2097280 | 15212.9 ± 0.6% | 0.998 | 0.181 | 0.994 | 1.000 | 0.999 | 0.988 | 0.996 | 0.998 | 1.005 | 0.180 | 1.000 |
| hex: http/css-1m | 524290 | 15655.1 ± 0.3% | 1.002 | 0.177 | 1.001 | 0.999 | 0.999 | 1.001 | 0.999 | 1.000 | 1.000 | 0.177 | 1.001 |
| hex: shuffled/dickens-1m | 524290 | 15673.5 ± 0.1% | 1.001 | 0.177 | 1.002 | 1.001 | 1.001 | 1.000 | 1.000 | 1.001 | 1.001 | 0.177 | 1.001 |

## Losses

Each workload where a claim's path ran slower than the path it replaces by more than the noise floor of decision 20.

- qlog records, JSON text sequence, decoding: J13 decoder escape blocks off runs at 1.056 of all on.
- string: canterbury-large/bible.txt, decoding: J13 decoder escape blocks off runs at 1.050 of all on.
- string: http/html-1m, decoding: J13 decoder escape blocks off runs at 1.059 of all on.
- string: http/js-1m, decoding: J12 decoder escape words off runs at 1.053 of all on.
- hex: http/html-1kx1024, decoding: J5 UTF-8 vectors off runs at 1.288 of all on.
- hex: http/html-1kx1024, decoding: J7 wide vectors off runs at 1.286 of all on.
- hex: http/html-1kx1024, decoding: J8 decoder fast path off runs at 1.289 of all on.
- hex: http/html-1kx1024, decoding: J12 decoder escape words off runs at 1.298 of all on.
- hex: http/json-1kx1024, decoding: J5 UTF-8 vectors off runs at 1.302 of all on.
- hex: http/json-1kx1024, decoding: J7 wide vectors off runs at 1.285 of all on.
- hex: http/json-1kx1024, decoding: J8 decoder fast path off runs at 1.289 of all on.
- hex: http/json-1kx1024, decoding: J12 decoder escape words off runs at 1.290 of all on.
- hex: http/js-1kx1024, decoding: J5 UTF-8 vectors off runs at 1.281 of all on.
- hex: http/js-1kx1024, decoding: J7 wide vectors off runs at 1.271 of all on.
- hex: http/js-1kx1024, decoding: J8 decoder fast path off runs at 1.267 of all on.
- hex: http/js-1kx1024, decoding: J12 decoder escape words off runs at 1.274 of all on.
- hex: http/css-1kx1024, decoding: J5 UTF-8 vectors off runs at 1.255 of all on.
- hex: http/css-1kx1024, decoding: J7 wide vectors off runs at 1.248 of all on.
- hex: http/css-1kx1024, decoding: J8 decoder fast path off runs at 1.252 of all on.
- hex: http/css-1kx1024, decoding: J12 decoder escape words off runs at 1.236 of all on.

## UTF-8 validation against simdutf

stdx's `is_utf8`, the check the loops apply to every string's octets, run alone over each string workload's octets at the width the host's features pick (16 lanes on aarch64, AVX2's 32 or AVX-512's 64 on x86-64, decision 39), beside simdutf 9.3.3's `validate_utf8` in the same run; on a host with AVX-512, again with AVX2 alone. Each ratio is stdx's throughput over the other's. simdutf picks its kernel at run time. Before timing, every copy of the check and simdutf judged 20000 seeded buffers and each workload, whole and changed, alike.

| Workload | Octets | stdx, MB/s | simdutf, MB/s | stdx / simdutf | stdx with AVX2 alone, MB/s | stdx / stdx with AVX2 alone |
|---|---|---|---|---|---|---|
| string: silesia/dickens | 166668 | 43356.0 ± 0.0% | 47402.5 ± 0.3% | 0.915 | — | — |
| string: silesia/nci | 1048576 | 32742.7 ± 4.7% | 34870.9 ± 6.3% | 0.939 | — | — |
| string: silesia/reymont | 1048576 | 34874.0 ± 4.7% | 37102.3 ± 11.9% | 0.940 | — | — |
| string: silesia/samba | 65546 | 43592.7 ± 0.0% | 48515.1 ± 0.0% | 0.899 | — | — |
| string: silesia/webster | 1048576 | 34615.1 ± 1.9% | 38113.9 ± 3.0% | 0.908 | — | — |
| string: silesia/xml | 1048576 | 29904.5 ± 17.0% | 31267.7 ± 13.8% | 0.956 | — | — |
| string: canterbury/alice29.txt | 152089 | 35904.4 ± 0.1% | 36533.8 ± 0.2% | 0.983 | — | — |
| string: canterbury/asyoulik.txt | 125179 | 43354.3 ± 0.0% | 47641.9 ± 0.0% | 0.910 | — | — |
| string: canterbury/lcet10.txt | 426754 | 36078.2 ± 0.1% | 36711.2 ± 0.1% | 0.983 | — | — |
| string: canterbury/plrabn12.txt | 481861 | 41004.4 ± 0.8% | 44583.3 ± 0.7% | 0.920 | — | — |
| string: canterbury-large/E.coli | 1048576 | 36004.1 ± 3.1% | 38132.2 ± 1.5% | 0.944 | — | — |
| string: canterbury-large/bible.txt | 1048576 | 32433.5 ± 5.3% | 33255.2 ± 5.3% | 0.975 | — | — |
| string: canterbury-large/world192.txt | 1048576 | 30939.9 ± 2.8% | 32198.4 ± 0.2% | 0.961 | — | — |
| string: http/html-1m | 1048576 | 34201.0 ± 5.3% | 36765.3 ± 3.1% | 0.930 | — | — |
| string: http/json-1m | 1048576 | 30865.8 ± 2.5% | 32274.1 ± 4.9% | 0.956 | — | — |
| string: http/js-1m | 1048576 | 36300.5 ± 4.8% | 39473.6 ± 4.9% | 0.920 | — | — |
| string: http/css-1m | 1048576 | 35142.3 ± 2.7% | 37774.6 ± 4.1% | 0.930 | — | — |
| string: dickens as Cyrillic and CJK | 1847045 | 5763.9 ± 0.2% | 5651.3 ± 0.1% | 1.020 | — | — |

## Losses to simdutf

- string: silesia/dickens: stdx runs at 0.915 of simdutf.
- string: silesia/samba: stdx runs at 0.899 of simdutf.
- string: silesia/webster: stdx runs at 0.908 of simdutf.
- string: canterbury/asyoulik.txt: stdx runs at 0.910 of simdutf.
- string: canterbury/plrabn12.txt: stdx runs at 0.920 of simdutf.
- string: canterbury-large/E.coli: stdx runs at 0.944 of simdutf.
- string: http/html-1m: stdx runs at 0.930 of simdutf.
- string: http/js-1m: stdx runs at 0.920 of simdutf.
- string: http/css-1m: stdx runs at 0.930 of simdutf.

## UTF-8 validation by the buffer's offset from a 64-octet line

| Buffer | Octets | Offset | stdx, MB/s | simdutf, MB/s | stdx / simdutf | stdx with AVX2 alone, MB/s | stdx / stdx with AVX2 alone |
|---|---|---|---|---|---|---|---|
| string: canterbury-large/bible.txt | 1048576 | 0 | 39075.1 ± 3.9% | 43721.2 ± 3.7% | 0.894 | — | — |
| string: canterbury-large/bible.txt | 1048576 | 1 | 32862.6 ± 2.9% | 34242.1 ± 1.6% | 0.960 | — | — |
| string: canterbury-large/bible.txt | 1048576 | 8 | 35640.1 ± 5.1% | 38190.3 ± 6.1% | 0.933 | — | — |
| string: canterbury-large/bible.txt | 1048576 | 16 | 36623.3 ± 3.7% | 40265.6 ± 3.3% | 0.910 | — | — |
| string: canterbury-large/bible.txt | 1048576 | 32 | 36307.9 ± 6.9% | 40245.9 ± 6.9% | 0.902 | — | — |
| string: canterbury-large/bible.txt | 1048576 | 48 | 36636.1 ± 1.1% | 40062.2 ± 0.9% | 0.914 | — | — |
| string: dickens as Cyrillic and CJK | 1048576 | 0 | 5751.9 ± 0.3% | 5628.0 ± 0.2% | 1.022 | — | — |
| string: dickens as Cyrillic and CJK | 1048576 | 1 | 5735.6 ± 0.4% | 5633.8 ± 0.2% | 1.018 | — | — |
| string: dickens as Cyrillic and CJK | 1048576 | 8 | 5745.5 ± 0.2% | 5631.5 ± 0.2% | 1.020 | — | — |
| string: dickens as Cyrillic and CJK | 1048576 | 16 | 5747.6 ± 0.3% | 5635.0 ± 0.1% | 1.020 | — | — |
| string: dickens as Cyrillic and CJK | 1048576 | 32 | 5749.2 ± 0.2% | 5634.1 ± 0.3% | 1.020 | — | — |
| string: dickens as Cyrillic and CJK | 1048576 | 48 | 5743.8 ± 0.2% | 5630.2 ± 0.3% | 1.020 | — | — |

## Against the baselines

stdx with every claim on, timed beside simdjson 5.1.1, yyjson 0.13.0, Zig 0.16.0's std.json, serde_json 1.0.154 and Go's encoding/json/jsontext in the same run. Each ratio is stdx's throughput over the baseline's; below 1, the baseline is faster. stdx is built for the architecture's baseline CPU in ReleaseSafe. Each baseline is built for the same CPU, the C, C++ and Zig ones in ReleaseFast (decision 75), and simdjson picks its kernel at run time. Decoding visits every value; encoding writes each text from its tokens.

## Decoding against the baselines

Octets are the text's. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1126.3 ± 0.7% | 926.4 ± 0.9% | 1013.2 ± 0.1% | 300.8 ± 0.5% | 666.2 ± 0.3% | 307.3 ± 1.7% | 1.216 | 1.112 | 3.744 | 1.691 | 3.665 |
| qlog records, JSON text sequence | 1467503 | 822.2 ± 2.5% | 814.9 ± 0.1% | 752.2 ± 1.9% | 241.4 ± 0.7% | 674.9 ± 2.0% | 230.8 ± 1.9% | 1.009 | 1.093 | 3.406 | 1.218 | 3.562 |
| string: silesia/dickens | 172528 | 5040.7 ± 0.2% | 1878.2 ± 0.2% | 2646.6 ± 0.3% | 361.1 ± 1.3% | 2863.5 ± 0.6% | 542.7 ± 1.6% | 2.684 | 1.905 | 13.961 | 1.760 | 9.287 |
| string: silesia/nci | 1075110 | 4299.3 ± 0.3% | 2231.9 ± 0.2% | 2991.0 ± 0.2% | 542.7 ± 1.4% | 2989.3 ± 1.5% | 598.4 ± 1.9% | 1.926 | 1.437 | 7.921 | 1.438 | 7.184 |
| string: silesia/reymont | 1075159 | 2926.7 ± 1.0% | 1811.3 ± 1.0% | 2062.3 ± 0.4% | 374.6 ± 0.8% | 2138.5 ± 0.6% | 531.9 ± 1.0% | 1.616 | 1.419 | 7.812 | 1.369 | 5.502 |
| string: silesia/samba | 97582 | 3489.0 ± 0.5% | 2024.4 ± 0.3% | 2618.5 ± 0.4% | 324.1 ± 0.4% | 1508.9 ± 0.5% | 422.7 ± 1.7% | 1.723 | 1.332 | 10.764 | 2.312 | 8.253 |
| string: silesia/webster | 1098490 | 3643.8 ± 0.4% | 1516.2 ± 0.3% | 2006.8 ± 0.4% | 359.8 ± 0.3% | 2170.8 ± 1.0% | 495.0 ± 1.5% | 2.403 | 1.816 | 10.127 | 1.679 | 7.362 |
| string: silesia/xml | 1090118 | 4760.9 ± 0.4% | 2355.4 ± 0.6% | 2518.7 ± 0.3% | 453.6 ± 1.1% | 2800.0 ± 1.4% | 559.9 ± 1.0% | 2.021 | 1.890 | 10.496 | 1.700 | 8.503 |
| string: canterbury/alice29.txt | 159425 | 4304.0 ± 1.0% | 1597.7 ± 0.4% | 2453.8 ± 0.4% | 341.5 ± 0.8% | 2502.2 ± 0.5% | 499.8 ± 0.6% | 2.694 | 1.754 | 12.604 | 1.720 | 8.612 |
| string: canterbury/asyoulik.txt | 132198 | 3448.4 ± 1.3% | 1458.5 ± 0.2% | 2243.7 ± 0.6% | 335.5 ± 1.4% | 2085.3 ± 0.4% | 452.7 ± 1.4% | 2.364 | 1.537 | 10.277 | 1.654 | 7.617 |
| string: canterbury/lcet10.txt | 441884 | 5122.5 ± 0.2% | 1849.3 ± 0.2% | 2332.5 ± 0.8% | 391.2 ± 0.6% | 2853.1 ± 0.9% | 529.0 ± 3.1% | 2.770 | 2.196 | 13.094 | 1.795 | 9.683 |
| string: canterbury/plrabn12.txt | 503330 | 4110.9 ± 0.6% | 1732.9 ± 0.2% | 2053.2 ± 0.6% | 362.1 ± 1.3% | 2469.6 ± 1.5% | 496.6 ± 0.6% | 2.372 | 2.002 | 11.353 | 1.665 | 8.277 |
| string: canterbury-large/E.coli | 1048578 | 19058.1 ± 1.0% | 3588.1 ± 0.4% | 3240.7 ± 0.4% | 931.1 ± 0.7% | 6000.6 ± 0.7% | 743.8 ± 1.5% | 5.312 | 5.881 | 20.469 | 3.176 | 25.624 |
| string: canterbury-large/bible.txt | 1055886 | 6620.2 ± 1.4% | 2931.9 ± 0.3% | 2825.9 ± 0.9% | 419.6 ± 1.5% | 3745.0 ± 2.1% | 609.1 ± 0.7% | 2.258 | 2.343 | 15.778 | 1.768 | 10.869 |
| string: canterbury-large/world192.txt | 1103121 | 3379.4 ± 0.3% | 1479.9 ± 0.3% | 2004.6 ± 0.2% | 352.5 ± 0.5% | 2119.1 ± 1.3% | 495.6 ± 1.5% | 2.284 | 1.686 | 9.586 | 1.595 | 6.819 |
| string: http/html-1m | 1058582 | 6019.8 ± 1.5% | 2731.9 ± 0.6% | 2685.7 ± 1.0% | 441.7 ± 0.4% | 3471.2 ± 0.5% | 594.9 ± 0.8% | 2.204 | 2.241 | 13.630 | 1.734 | 10.120 |
| string: http/json-1m | 1190272 | 2543.8 ± 0.4% | 874.9 ± 2.3% | 2248.4 ± 0.3% | 389.8 ± 0.8% | 1034.4 ± 3.4% | 435.0 ± 1.6% | 2.907 | 1.131 | 6.526 | 2.459 | 5.847 |
| string: http/js-1m | 1144362 | 2282.9 ± 0.6% | 1027.6 ± 0.3% | 1634.6 ± 0.4% | 320.6 ± 0.5% | 1520.2 ± 0.5% | 415.2 ± 1.1% | 2.222 | 1.397 | 7.120 | 1.502 | 5.498 |
| string: http/css-1m | 1097820 | 2631.5 ± 0.4% | 1675.7 ± 0.3% | 2225.3 ± 0.9% | 403.8 ± 1.6% | 1911.3 ± 0.8% | 484.6 ± 0.6% | 1.570 | 1.183 | 6.516 | 1.377 | 5.431 |
| string: dickens as Cyrillic and CJK | 1883069 | 3052.4 ± 0.9% | 1684.5 ± 0.2% | 887.8 ± 0.5% | 351.1 ± 0.2% | 664.3 ± 1.0% | 155.6 ± 3.0% | 1.812 | 3.438 | 8.693 | 4.595 | 19.622 |
| string: dickens as Cyrillic and CJK, as \u escapes | 5075485 | 1325.8 ± 1.8% | 975.7 ± 0.5% | 1186.4 ± 0.4% | 214.1 ± 0.1% | 470.5 ± 0.7% | 254.0 ± 3.2% | 1.359 | 1.118 | 6.191 | 2.818 | 5.220 |
| hex: silesia/dickens | 524290 | 18258.5 ± 2.0% | 3607.2 ± 0.3% | 3277.6 ± 0.1% | 509.9 ± 1.5% | 6053.1 ± 1.3% | 774.6 ± 1.6% | 5.062 | 5.571 | 35.808 | 3.016 | 23.572 |
| hex: silesia/mozilla | 524290 | 18640.7 ± 0.5% | 3609.4 ± 0.2% | 3289.2 ± 0.1% | 458.7 ± 2.4% | 6079.2 ± 1.0% | 776.1 ± 0.3% | 5.164 | 5.667 | 40.636 | 3.066 | 24.020 |
| hex: silesia/mr | 524290 | 18214.9 ± 1.3% | 3606.1 ± 0.4% | 3288.0 ± 0.2% | 577.6 ± 2.4% | 6079.5 ± 1.6% | 776.8 ± 0.4% | 5.051 | 5.540 | 31.534 | 2.996 | 23.449 |
| hex: silesia/nci | 524290 | 18568.2 ± 1.6% | 3604.7 ± 0.3% | 3283.9 ± 0.2% | 649.2 ± 5.3% | 6101.2 ± 1.1% | 775.9 ± 0.3% | 5.151 | 5.654 | 28.602 | 3.043 | 23.930 |
| hex: silesia/ooffice | 524290 | 18543.2 ± 1.7% | 3603.9 ± 0.3% | 3281.8 ± 0.2% | 401.1 ± 0.3% | 6078.7 ± 0.8% | 776.0 ± 0.8% | 5.145 | 5.650 | 46.236 | 3.051 | 23.896 |
| hex: silesia/osdb | 524290 | 18067.9 ± 0.8% | 3607.1 ± 0.2% | 3289.7 ± 0.3% | 485.2 ± 2.2% | 6001.3 ± 1.0% | 775.9 ± 0.4% | 5.009 | 5.492 | 37.236 | 3.011 | 23.287 |
| hex: silesia/reymont | 524290 | 18361.8 ± 0.2% | 3608.5 ± 0.2% | 3284.2 ± 0.6% | 524.3 ± 3.2% | 6086.3 ± 1.5% | 776.3 ± 0.4% | 5.088 | 5.591 | 35.022 | 3.017 | 23.652 |
| hex: silesia/samba | 524290 | 18217.0 ± 0.5% | 3607.5 ± 0.3% | 3293.4 ± 0.2% | 411.7 ± 2.5% | 6087.1 ± 1.1% | 775.7 ± 0.1% | 5.050 | 5.531 | 44.249 | 2.993 | 23.483 |
| hex: silesia/sao | 524290 | 18537.1 ± 2.1% | 3608.6 ± 0.2% | 3297.7 ± 0.3% | 346.3 ± 1.6% | 6120.9 ± 2.1% | 775.5 ± 0.8% | 5.137 | 5.621 | 53.536 | 3.029 | 23.904 |
| hex: silesia/webster | 524290 | 18362.2 ± 0.9% | 3607.7 ± 0.2% | 3293.3 ± 0.3% | 480.2 ± 1.5% | 6068.5 ± 1.0% | 774.8 ± 0.7% | 5.090 | 5.576 | 38.240 | 3.026 | 23.701 |
| hex: silesia/x-ray | 524290 | 18339.6 ± 0.3% | 3607.7 ± 0.3% | 3287.9 ± 0.2% | 487.1 ± 0.4% | 6086.5 ± 1.2% | 776.6 ± 0.5% | 5.083 | 5.578 | 37.653 | 3.013 | 23.615 |
| hex: silesia/xml | 524290 | 18244.7 ± 0.4% | 3607.1 ± 0.5% | 3283.8 ± 0.1% | 533.3 ± 0.4% | 6082.6 ± 1.2% | 777.7 ± 0.2% | 5.058 | 5.556 | 34.213 | 3.000 | 23.461 |
| hex: canterbury/alice29.txt | 304180 | 18984.6 ± 0.5% | 3610.6 ± 0.2% | 3373.2 ± 0.1% | 521.8 ± 0.2% | 6088.2 ± 1.2% | 774.6 ± 0.8% | 5.258 | 5.628 | 36.382 | 3.118 | 24.509 |
| hex: canterbury/asyoulik.txt | 250360 | 19515.8 ± 0.3% | 3639.8 ± 0.3% | 3365.9 ± 0.0% | 516.3 ± 0.4% | 6129.3 ± 1.9% | 774.5 ± 0.3% | 5.362 | 5.798 | 37.800 | 3.184 | 25.197 |
| hex: canterbury/cp.html | 49208 | 19232.7 ± 0.3% | 3637.1 ± 0.0% | 3278.2 ± 0.2% | 483.6 ± 1.1% | 6287.0 ± 0.7% | 760.0 ± 2.1% | 5.288 | 5.867 | 39.768 | 3.059 | 25.306 |
| hex: canterbury/fields.c | 22302 | 18933.5 ± 0.6% | 3628.6 ± 0.1% | 3349.8 ± 0.1% | 511.6 ± 0.5% | 6259.1 ± 0.5% | 745.0 ± 1.9% | 5.218 | 5.652 | 37.009 | 3.025 | 25.414 |
| hex: canterbury/grammar.lsp | 7444 | 17584.5 ± 1.0% | 3601.1 ± 0.1% | 3370.6 ± 0.5% | 554.6 ± 2.1% | 6174.1 ± 0.8% | 715.3 ± 1.9% | 4.883 | 5.217 | 31.708 | 2.848 | 24.584 |
| hex: canterbury/kennedy.xls | 524290 | 18494.3 ± 1.7% | 3613.4 ± 0.2% | 3285.4 ± 0.4% | 669.4 ± 3.0% | 6015.2 ± 1.0% | 770.5 ± 7.3% | 5.118 | 5.629 | 27.628 | 3.075 | 24.001 |
| hex: canterbury/lcet10.txt | 524290 | 18527.5 ± 1.8% | 3608.9 ± 0.4% | 3298.6 ± 0.5% | 527.7 ± 0.4% | 6085.6 ± 0.6% | 778.0 ± 1.1% | 5.134 | 5.617 | 35.108 | 3.044 | 23.814 |
| hex: canterbury/plrabn12.txt | 524290 | 18189.4 ± 0.8% | 3610.4 ± 0.4% | 3282.1 ± 0.4% | 516.5 ± 0.4% | 6075.3 ± 1.2% | 779.3 ± 1.0% | 5.038 | 5.542 | 35.216 | 2.994 | 23.341 |
| hex: canterbury/ptt5 | 524290 | 18192.4 ± 0.3% | 3609.2 ± 0.3% | 3275.6 ± 0.1% | 559.7 ± 1.1% | 5995.0 ± 0.9% | 780.7 ± 1.1% | 5.041 | 5.554 | 32.504 | 3.035 | 23.303 |
| hex: canterbury/sum | 76482 | 19291.1 ± 0.1% | 3633.0 ± 0.1% | 3355.1 ± 0.3% | 510.6 ± 0.8% | 6165.1 ± 0.4% | 768.4 ± 0.8% | 5.310 | 5.750 | 37.783 | 3.129 | 25.104 |
| hex: canterbury/xargs.1 | 8456 | 17838.0 ± 0.7% | 3602.1 ± 0.0% | 3378.7 ± 0.3% | 497.2 ± 2.8% | 6152.6 ± 0.4% | 751.1 ± 1.7% | 4.952 | 5.280 | 35.878 | 2.899 | 23.750 |
| hex: canterbury-large/E.coli | 524290 | 18291.1 ± 1.8% | 3608.7 ± 0.5% | 3280.5 ± 0.9% | 688.7 ± 0.2% | 6041.6 ± 0.9% | 747.5 ± 6.1% | 5.069 | 5.576 | 26.558 | 3.028 | 24.471 |
| hex: canterbury-large/bible.txt | 524290 | 18254.8 ± 0.5% | 3607.9 ± 0.2% | 3289.0 ± 0.4% | 519.7 ± 0.6% | 6083.1 ± 1.0% | 762.1 ± 1.7% | 5.060 | 5.550 | 35.128 | 3.001 | 23.953 |
| hex: canterbury-large/world192.txt | 524290 | 18031.5 ± 0.5% | 3609.9 ± 0.3% | 3286.3 ± 0.3% | 494.4 ± 0.9% | 6080.9 ± 0.3% | 755.0 ± 3.1% | 4.995 | 5.487 | 36.470 | 2.965 | 23.884 |
| hex: http/html-1kx1024 | 2099200 | 9043.7 ± 17.5% | 3456.4 ± 0.4% | 2830.2 ± 0.7% | 475.3 ± 0.5% | 5046.4 ± 0.8% | 626.3 ± 2.0% | 2.616 | 3.195 | 19.026 | 1.792 | 14.441 |
| hex: http/html-16kx64 | 2097280 | 17697.5 ± 1.4% | 3607.5 ± 0.2% | 3262.6 ± 0.8% | 477.7 ± 0.4% | 6017.1 ± 0.6% | 743.0 ± 5.0% | 4.906 | 5.424 | 37.050 | 2.941 | 23.818 |
| hex: http/html-1m | 524290 | 18185.1 ± 1.2% | 3611.6 ± 0.1% | 3278.4 ± 0.4% | 509.5 ± 2.1% | 6075.0 ± 0.2% | 751.5 ± 2.1% | 5.035 | 5.547 | 35.690 | 2.993 | 24.199 |
| hex: http/json-1kx1024 | 2099200 | 9092.1 ± 17.8% | 3458.6 ± 0.5% | 2817.9 ± 0.5% | 575.2 ± 0.6% | 5021.6 ± 7.1% | 619.8 ± 18.1% | 2.629 | 3.226 | 15.806 | 1.811 | 14.669 |
| hex: http/json-16kx64 | 2097280 | 17958.3 ± 0.9% | 3606.8 ± 0.2% | 3257.4 ± 0.3% | 572.5 ± 0.4% | 6033.9 ± 0.5% | 744.2 ± 2.5% | 4.979 | 5.513 | 31.367 | 2.976 | 24.132 |
| hex: http/json-1m | 524290 | 18192.3 ± 1.7% | 3608.1 ± 0.4% | 3291.6 ± 0.4% | 595.9 ± 1.3% | 6062.3 ± 1.4% | 750.2 ± 3.3% | 5.042 | 5.527 | 30.531 | 3.001 | 24.251 |
| hex: http/js-1kx1024 | 2099200 | 9221.3 ± 16.9% | 3463.4 ± 0.1% | 2826.8 ± 0.6% | 482.5 ± 0.8% | 5035.6 ± 0.9% | 631.4 ± 4.9% | 2.663 | 3.262 | 19.110 | 1.831 | 14.605 |
| hex: http/js-16kx64 | 2097280 | 17627.0 ± 0.6% | 3608.5 ± 0.2% | 3254.3 ± 0.2% | 480.2 ± 0.9% | 6008.3 ± 0.7% | 732.8 ± 5.1% | 4.885 | 5.416 | 36.709 | 2.934 | 24.054 |
| hex: http/js-1m | 524290 | 18396.2 ± 1.3% | 3604.5 ± 0.2% | 3288.4 ± 0.2% | 509.4 ± 0.3% | 6112.4 ± 0.6% | 758.3 ± 2.4% | 5.104 | 5.594 | 36.116 | 3.010 | 24.260 |
| hex: http/css-1kx1024 | 2099200 | 9476.7 ± 17.1% | 3460.2 ± 0.2% | 2817.7 ± 0.3% | 488.9 ± 0.7% | 5029.2 ± 1.3% | 623.2 ± 1.8% | 2.739 | 3.363 | 19.383 | 1.884 | 15.206 |
| hex: http/css-16kx64 | 2097280 | 17903.8 ± 0.8% | 3606.6 ± 0.2% | 3250.2 ± 0.2% | 494.2 ± 1.2% | 6012.7 ± 0.5% | 742.6 ± 3.8% | 4.964 | 5.508 | 36.224 | 2.978 | 24.111 |
| hex: http/css-1m | 524290 | 18516.8 ± 1.4% | 3607.5 ± 0.1% | 3286.0 ± 0.2% | 503.0 ± 0.4% | 6076.6 ± 1.4% | 752.2 ± 3.2% | 5.133 | 5.635 | 36.814 | 3.047 | 24.617 |
| hex: shuffled/dickens-1m | 524290 | 17878.5 ± 0.8% | 3604.5 ± 0.2% | 3275.9 ± 0.2% | 514.1 ± 2.7% | 6032.9 ± 1.2% | 760.6 ± 0.6% | 4.960 | 5.458 | 34.778 | 2.963 | 23.506 |

## Encoding against the baselines

Octets are the ones stdx writes. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1466.2 ± 0.4% | 1243.0 ± 0.3% | 1030.0 ± 0.9% | 408.3 ± 0.5% | 446.9 ± 0.4% | 414.9 ± 0.4% | 1.180 | 1.424 | 3.591 | 3.281 | 3.534 |
| qlog records, JSON text sequence | 1467503 | 1271.4 ± 1.0% | 1065.6 ± 0.3% | 782.4 ± 0.9% | 377.0 ± 0.8% | 472.5 ± 1.3% | 278.9 ± 0.3% | 1.193 | 1.625 | 3.373 | 2.691 | 4.558 |
| string: silesia/dickens | 172528 | 6894.1 ± 0.5% | 2808.1 ± 0.4% | 2929.3 ± 1.1% | 429.9 ± 0.4% | 1594.1 ± 0.1% | 1011.6 ± 0.2% | 2.455 | 2.353 | 16.036 | 4.325 | 6.815 |
| string: silesia/nci | 1075110 | 7283.0 ± 0.6% | 3413.0 ± 0.7% | 3093.3 ± 0.4% | 814.8 ± 2.1% | 1858.9 ± 0.5% | 1107.7 ± 0.2% | 2.134 | 2.354 | 8.938 | 3.918 | 6.575 |
| string: silesia/reymont | 1075159 | 3341.0 ± 1.4% | 1973.6 ± 1.2% | 2057.9 ± 1.0% | 448.6 ± 1.2% | 1504.3 ± 0.4% | 948.5 ± 0.5% | 1.693 | 1.623 | 7.447 | 2.221 | 3.522 |
| string: silesia/samba | 97582 | 4186.5 ± 1.0% | 2113.2 ± 0.4% | 3450.0 ± 0.2% | 353.5 ± 0.6% | 1485.8 ± 0.3% | 1055.0 ± 0.3% | 1.981 | 1.213 | 11.842 | 2.818 | 3.968 |
| string: silesia/webster | 1098490 | 4041.1 ± 0.5% | 1866.2 ± 0.6% | 2049.3 ± 0.7% | 442.2 ± 0.7% | 1397.6 ± 0.5% | 647.3 ± 1.2% | 2.165 | 1.972 | 9.138 | 2.892 | 6.243 |
| string: silesia/xml | 1090118 | 6121.4 ± 0.6% | 2849.7 ± 0.6% | 2644.0 ± 0.4% | 609.4 ± 0.7% | 1756.7 ± 0.4% | 920.8 ± 0.3% | 2.148 | 2.315 | 10.044 | 3.485 | 6.648 |
| string: canterbury/alice29.txt | 159425 | 6436.4 ± 1.1% | 2194.6 ± 0.6% | 2752.0 ± 0.5% | 407.6 ± 0.9% | 1470.3 ± 0.3% | 954.9 ± 0.2% | 2.933 | 2.339 | 15.789 | 4.378 | 6.740 |
| string: canterbury/asyoulik.txt | 132198 | 5585.0 ± 1.4% | 1711.0 ± 0.5% | 2366.1 ± 1.2% | 401.9 ± 0.5% | 1328.7 ± 1.0% | 882.7 ± 0.2% | 3.264 | 2.360 | 13.895 | 4.203 | 6.327 |
| string: canterbury/lcet10.txt | 441884 | 6212.8 ± 0.7% | 2565.9 ± 1.1% | 2501.9 ± 1.0% | 467.5 ± 1.1% | 1551.7 ± 0.2% | 980.5 ± 0.6% | 2.421 | 2.483 | 13.290 | 4.004 | 6.336 |
| string: canterbury/plrabn12.txt | 503330 | 5715.7 ± 0.4% | 2060.9 ± 0.4% | 2070.5 ± 0.4% | 424.6 ± 0.5% | 1389.5 ± 0.2% | 926.6 ± 0.7% | 2.773 | 2.761 | 13.462 | 4.113 | 6.168 |
| string: canterbury-large/E.coli | 1048578 | 19202.5 ± 1.4% | 9715.3 ± 0.2% | 3787.2 ± 0.4% | 1471.4 ± 0.5% | 2356.4 ± 0.6% | 1191.0 ± 0.2% | 1.977 | 5.070 | 13.050 | 8.149 | 16.123 |
| string: canterbury-large/bible.txt | 1055886 | 6773.0 ± 0.2% | 4118.4 ± 1.3% | 3047.9 ± 1.9% | 504.3 ± 0.6% | 1982.4 ± 0.6% | 1119.8 ± 0.2% | 1.645 | 2.222 | 13.430 | 3.417 | 6.048 |
| string: canterbury-large/world192.txt | 1103121 | 4010.7 ± 0.6% | 1647.8 ± 0.4% | 1996.8 ± 0.6% | 448.3 ± 2.7% | 1371.0 ± 0.3% | 908.7 ± 0.3% | 2.434 | 2.009 | 8.947 | 2.925 | 4.414 |
| string: http/html-1m | 1058582 | 6735.8 ± 0.6% | 3943.1 ± 0.4% | 3033.6 ± 1.7% | 499.6 ± 0.6% | 1922.4 ± 0.5% | 803.7 ± 0.3% | 1.708 | 2.220 | 13.482 | 3.504 | 8.381 |
| string: http/json-1m | 1190272 | 3158.7 ± 0.4% | 1356.4 ± 0.3% | 1551.4 ± 0.7% | 443.6 ± 0.4% | 1072.3 ± 0.4% | 765.0 ± 1.5% | 2.329 | 2.036 | 7.120 | 2.946 | 4.129 |
| string: http/js-1m | 1144362 | 2754.6 ± 0.8% | 1174.8 ± 1.1% | 1626.4 ± 0.7% | 368.4 ± 0.6% | 1109.7 ± 0.8% | 756.4 ± 0.8% | 2.345 | 1.694 | 7.478 | 2.482 | 3.642 |
| string: http/css-1m | 1097820 | 3959.5 ± 0.7% | 1489.4 ± 0.3% | 2146.6 ± 1.0% | 493.0 ± 0.5% | 1378.9 ± 0.5% | 893.6 ± 0.2% | 2.658 | 1.844 | 8.031 | 2.871 | 4.431 |
| string: dickens as Cyrillic and CJK | 1883069 | 3061.7 ± 0.4% | 2336.4 ± 0.5% | 520.7 ± 0.3% | 306.7 ± 0.6% | 562.7 ± 0.9% | 336.0 ± 0.3% | 1.310 | 5.879 | 9.984 | 5.441 | 9.111 |
| hex: silesia/dickens | 524290 | 15643.0 ± 0.3% | 1463.5 ± 0.3% | 1081.0 ± 0.4% | 498.7 ± 1.2% | 986.4 ± 0.5% | 733.7 ± 0.5% | 10.689 | 14.471 | 31.370 | 15.858 | 21.320 |
| hex: silesia/mozilla | 524290 | 15656.0 ± 0.3% | 1473.1 ± 0.2% | 1088.4 ± 0.4% | 440.5 ± 3.0% | 988.9 ± 0.6% | 733.5 ± 0.3% | 10.628 | 14.385 | 35.544 | 15.832 | 21.346 |
| hex: silesia/mr | 524290 | 15610.8 ± 0.5% | 1479.6 ± 0.4% | 1091.4 ± 0.3% | 552.6 ± 3.2% | 994.9 ± 0.6% | 732.8 ± 0.4% | 10.551 | 14.303 | 28.251 | 15.691 | 21.302 |
| hex: silesia/nci | 524290 | 15617.1 ± 0.5% | 1468.6 ± 0.2% | 1087.7 ± 0.7% | 638.2 ± 2.2% | 988.2 ± 0.5% | 732.5 ± 0.5% | 10.634 | 14.358 | 24.471 | 15.804 | 21.320 |
| hex: silesia/ooffice | 524290 | 15605.0 ± 0.3% | 1462.8 ± 0.3% | 1081.5 ± 0.3% | 388.9 ± 0.4% | 989.3 ± 0.3% | 733.8 ± 0.4% | 10.668 | 14.430 | 40.127 | 15.775 | 21.268 |
| hex: silesia/osdb | 524290 | 15631.7 ± 0.3% | 1468.0 ± 0.2% | 1085.0 ± 0.2% | 468.6 ± 0.9% | 990.5 ± 0.6% | 732.9 ± 0.7% | 10.648 | 14.407 | 33.358 | 15.782 | 21.330 |
| hex: silesia/reymont | 524290 | 15592.7 ± 0.3% | 1461.6 ± 0.5% | 1083.4 ± 0.5% | 513.9 ± 1.5% | 986.4 ± 0.5% | 732.6 ± 0.5% | 10.668 | 14.393 | 30.340 | 15.807 | 21.284 |
| hex: silesia/samba | 524290 | 15623.5 ± 0.5% | 1463.6 ± 1.2% | 1081.5 ± 0.5% | 402.1 ± 0.4% | 986.9 ± 0.5% | 733.6 ± 0.8% | 10.674 | 14.447 | 38.852 | 15.831 | 21.298 |
| hex: silesia/sao | 524290 | 15649.0 ± 0.3% | 1464.6 ± 0.4% | 1084.3 ± 0.5% | 332.6 ± 0.5% | 987.6 ± 0.7% | 734.0 ± 0.3% | 10.685 | 14.433 | 47.044 | 15.845 | 21.322 |
| hex: silesia/webster | 524290 | 15642.5 ± 0.8% | 1461.8 ± 0.3% | 1081.5 ± 0.4% | 475.4 ± 0.1% | 986.2 ± 0.4% | 732.6 ± 0.3% | 10.701 | 14.464 | 32.901 | 15.862 | 21.353 |
| hex: silesia/x-ray | 524290 | 15617.4 ± 0.2% | 1474.3 ± 0.3% | 1087.6 ± 0.2% | 443.8 ± 0.3% | 990.6 ± 0.6% | 732.8 ± 0.4% | 10.593 | 14.360 | 35.187 | 15.765 | 21.311 |
| hex: silesia/xml | 524290 | 15605.3 ± 0.1% | 1466.0 ± 0.4% | 1084.5 ± 0.4% | 614.7 ± 1.1% | 986.4 ± 0.2% | 733.3 ± 0.8% | 10.645 | 14.389 | 25.386 | 15.821 | 21.280 |
| hex: canterbury/alice29.txt | 304180 | 15670.2 ± 0.1% | 1470.6 ± 0.4% | 1086.2 ± 0.3% | 503.2 ± 0.9% | 989.4 ± 0.3% | 733.9 ± 0.3% | 10.656 | 14.427 | 31.144 | 15.838 | 21.353 |
| hex: canterbury/asyoulik.txt | 250360 | 15702.0 ± 0.3% | 1468.5 ± 0.3% | 1091.1 ± 0.4% | 497.4 ± 1.2% | 992.4 ± 0.1% | 740.2 ± 0.2% | 10.692 | 14.391 | 31.571 | 15.823 | 21.212 |
| hex: canterbury/cp.html | 49208 | 15619.1 ± 0.1% | 1472.0 ± 0.3% | 1096.9 ± 0.1% | 526.2 ± 2.5% | 1000.7 ± 0.1% | 742.6 ± 0.1% | 10.611 | 14.239 | 29.680 | 15.608 | 21.034 |
| hex: canterbury/fields.c | 22302 | 15439.9 ± 0.1% | 1411.4 ± 0.4% | 1060.5 ± 0.3% | 632.7 ± 7.8% | 988.4 ± 0.1% | 736.4 ± 0.1% | 10.940 | 14.559 | 24.403 | 15.622 | 20.968 |
| hex: canterbury/grammar.lsp | 7444 | 14932.9 ± 0.1% | 1504.1 ± 0.1% | 1091.1 ± 0.3% | 670.5 ± 4.1% | 1001.7 ± 0.2% | 725.8 ± 0.1% | 9.928 | 13.686 | 22.272 | 14.908 | 20.575 |
| hex: canterbury/kennedy.xls | 524290 | 15594.6 ± 0.4% | 1469.1 ± 0.5% | 1088.3 ± 0.5% | 655.6 ± 3.3% | 986.2 ± 0.5% | 731.9 ± 0.9% | 10.615 | 14.329 | 23.785 | 15.813 | 21.306 |
| hex: canterbury/lcet10.txt | 524290 | 15616.9 ± 0.3% | 1464.1 ± 0.4% | 1083.3 ± 0.2% | 503.9 ± 1.2% | 988.7 ± 0.3% | 731.8 ± 0.7% | 10.667 | 14.416 | 30.990 | 15.795 | 21.341 |
| hex: canterbury/plrabn12.txt | 524290 | 15621.8 ± 0.2% | 1459.6 ± 0.3% | 1082.1 ± 0.5% | 493.5 ± 0.7% | 988.0 ± 0.3% | 733.0 ± 0.8% | 10.702 | 14.437 | 31.656 | 15.812 | 21.311 |
| hex: canterbury/ptt5 | 524290 | 15623.9 ± 0.2% | 1480.0 ± 0.2% | 1089.7 ± 0.6% | 553.4 ± 0.6% | 993.7 ± 0.3% | 733.1 ± 0.3% | 10.557 | 14.338 | 28.232 | 15.723 | 21.313 |
| hex: canterbury/sum | 76482 | 15636.9 ± 0.2% | 1494.5 ± 0.3% | 1103.9 ± 0.2% | 598.5 ± 1.6% | 998.2 ± 0.4% | 743.9 ± 0.1% | 10.463 | 14.165 | 26.127 | 15.666 | 21.020 |
| hex: canterbury/xargs.1 | 8456 | 15005.4 ± 0.2% | 1491.4 ± 1.2% | 1090.8 ± 0.6% | 650.5 ± 7.0% | 1001.7 ± 0.6% | 728.3 ± 0.1% | 10.061 | 13.756 | 23.069 | 14.980 | 20.604 |
| hex: canterbury-large/E.coli | 524290 | 15663.2 ± 0.2% | 1472.9 ± 0.1% | 1089.2 ± 0.4% | 671.9 ± 0.2% | 993.2 ± 0.4% | 732.7 ± 0.5% | 10.635 | 14.381 | 23.312 | 15.770 | 21.377 |
| hex: canterbury-large/bible.txt | 524290 | 15614.0 ± 0.3% | 1466.7 ± 0.4% | 1084.0 ± 0.4% | 513.2 ± 1.0% | 989.1 ± 0.4% | 730.7 ± 0.8% | 10.646 | 14.405 | 30.425 | 15.786 | 21.367 |
| hex: canterbury-large/world192.txt | 524290 | 15620.7 ± 0.1% | 1466.3 ± 0.2% | 1082.3 ± 0.6% | 504.1 ± 0.5% | 989.0 ± 0.3% | 732.5 ± 0.4% | 10.653 | 14.433 | 30.985 | 15.794 | 21.324 |
| hex: http/html-1kx1024 | 2099200 | 13669.3 ± 0.5% | 1453.8 ± 0.5% | 1061.4 ± 0.4% | 502.4 ± 0.3% | 985.2 ± 0.5% | 692.0 ± 0.2% | 9.402 | 12.879 | 27.207 | 13.875 | 19.754 |
| hex: http/html-16kx64 | 2097280 | 15198.1 ± 0.3% | 1450.4 ± 0.5% | 1074.5 ± 0.3% | 507.7 ± 0.4% | 995.7 ± 0.6% | 733.6 ± 0.1% | 10.479 | 14.145 | 29.937 | 15.264 | 20.717 |
| hex: http/html-1m | 524290 | 15601.8 ± 0.3% | 1464.2 ± 0.2% | 1083.3 ± 0.9% | 502.7 ± 1.0% | 988.1 ± 0.5% | 732.7 ± 0.4% | 10.656 | 14.402 | 31.035 | 15.790 | 21.294 |
| hex: http/json-1kx1024 | 2099200 | 13639.5 ± 0.4% | 1461.9 ± 0.2% | 1066.0 ± 0.1% | 609.2 ± 0.3% | 986.0 ± 0.2% | 692.4 ± 0.1% | 9.330 | 12.795 | 22.388 | 13.833 | 19.700 |
| hex: http/json-16kx64 | 2097280 | 15172.9 ± 8.3% | 1446.2 ± 0.6% | 1073.9 ± 0.1% | 619.2 ± 0.8% | 991.5 ± 2.9% | 734.5 ± 0.7% | 10.492 | 14.128 | 24.504 | 15.303 | 20.656 |
| hex: http/json-1m | 524290 | 15654.3 ± 0.3% | 1475.6 ± 0.4% | 1085.7 ± 0.5% | 636.7 ± 0.3% | 990.8 ± 0.3% | 731.9 ± 0.5% | 10.609 | 14.418 | 24.588 | 15.800 | 21.388 |
| hex: http/js-1kx1024 | 2099200 | 13683.1 ± 0.4% | 1455.6 ± 0.4% | 1063.7 ± 0.2% | 499.3 ± 0.3% | 984.6 ± 0.3% | 692.6 ± 0.1% | 9.400 | 12.864 | 27.403 | 13.897 | 19.756 |
| hex: http/js-16kx64 | 2097280 | 15303.1 ± 0.6% | 1441.4 ± 0.3% | 1073.3 ± 0.1% | 504.8 ± 0.5% | 995.4 ± 0.3% | 733.7 ± 0.2% | 10.617 | 14.258 | 30.317 | 15.374 | 20.856 |
| hex: http/js-1m | 524290 | 15613.3 ± 0.3% | 1463.5 ± 0.5% | 1080.1 ± 0.5% | 511.7 ± 0.6% | 985.2 ± 0.8% | 732.6 ± 0.6% | 10.668 | 14.455 | 30.515 | 15.847 | 21.313 |
| hex: http/css-1kx1024 | 2099200 | 13691.6 ± 0.5% | 1454.1 ± 0.2% | 1061.8 ± 0.1% | 531.6 ± 0.3% | 982.5 ± 0.1% | 692.6 ± 0.1% | 9.416 | 12.894 | 25.756 | 13.935 | 19.770 |
| hex: http/css-16kx64 | 2097280 | 15212.9 ± 0.6% | 1438.7 ± 0.3% | 1073.7 ± 0.1% | 541.2 ± 0.7% | 994.1 ± 0.7% | 734.3 ± 0.2% | 10.574 | 14.169 | 28.107 | 15.303 | 20.716 |
| hex: http/css-1m | 524290 | 15655.1 ± 0.3% | 1465.1 ± 0.3% | 1081.7 ± 0.6% | 527.7 ± 0.8% | 985.3 ± 0.3% | 732.6 ± 0.5% | 10.685 | 14.473 | 29.666 | 15.889 | 21.368 |
| hex: shuffled/dickens-1m | 524290 | 15673.5 ± 0.1% | 1463.8 ± 0.2% | 1085.1 ± 0.5% | 499.3 ± 1.6% | 985.9 ± 0.8% | 734.4 ± 0.7% | 10.708 | 14.445 | 31.392 | 15.898 | 21.341 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1508.6 ± 0.5% | 1243.0 ± 0.3% | 1030.0 ± 0.9% | 408.3 ± 0.5% | 446.9 ± 0.4% | 414.9 ± 0.4% | 1.214 | 1.465 | 3.694 | 3.376 | 3.636 |
| qlog records, JSON text sequence | 1467503 | 1290.9 ± 0.3% | 1065.6 ± 0.3% | 782.4 ± 0.9% | 377.0 ± 0.8% | 472.5 ± 1.3% | 278.9 ± 0.3% | 1.211 | 1.650 | 3.424 | 2.732 | 4.628 |
| string: silesia/dickens | 172528 | 7129.0 ± 0.6% | 2808.1 ± 0.4% | 2929.3 ± 1.1% | 429.9 ± 0.4% | 1594.1 ± 0.1% | 1011.6 ± 0.2% | 2.539 | 2.434 | 16.582 | 4.472 | 7.047 |
| string: silesia/nci | 1075110 | 7373.0 ± 1.0% | 3413.0 ± 0.7% | 3093.3 ± 0.4% | 814.8 ± 2.1% | 1858.9 ± 0.5% | 1107.7 ± 0.2% | 2.160 | 2.384 | 9.049 | 3.966 | 6.656 |
| string: silesia/reymont | 1075159 | 3487.5 ± 0.9% | 1973.6 ± 1.2% | 2057.9 ± 1.0% | 448.6 ± 1.2% | 1504.3 ± 0.4% | 948.5 ± 0.5% | 1.767 | 1.695 | 7.773 | 2.318 | 3.677 |
| string: silesia/samba | 97582 | 4582.0 ± 0.7% | 2113.2 ± 0.4% | 3450.0 ± 0.2% | 353.5 ± 0.6% | 1485.8 ± 0.3% | 1055.0 ± 0.3% | 2.168 | 1.328 | 12.961 | 3.084 | 4.343 |
| string: silesia/webster | 1098490 | 4092.7 ± 0.3% | 1866.2 ± 0.6% | 2049.3 ± 0.7% | 442.2 ± 0.7% | 1397.6 ± 0.5% | 647.3 ± 1.2% | 2.193 | 1.997 | 9.254 | 2.928 | 6.323 |
| string: silesia/xml | 1090118 | 6223.0 ± 0.3% | 2849.7 ± 0.6% | 2644.0 ± 0.4% | 609.4 ± 0.7% | 1756.7 ± 0.4% | 920.8 ± 0.3% | 2.184 | 2.354 | 10.211 | 3.542 | 6.758 |
| string: canterbury/alice29.txt | 159425 | 6845.0 ± 1.2% | 2194.6 ± 0.6% | 2752.0 ± 0.5% | 407.6 ± 0.9% | 1470.3 ± 0.3% | 954.9 ± 0.2% | 3.119 | 2.487 | 16.792 | 4.656 | 7.168 |
| string: canterbury/asyoulik.txt | 132198 | 5820.7 ± 2.6% | 1711.0 ± 0.5% | 2366.1 ± 1.2% | 401.9 ± 0.5% | 1328.7 ± 1.0% | 882.7 ± 0.2% | 3.402 | 2.460 | 14.481 | 4.381 | 6.594 |
| string: canterbury/lcet10.txt | 441884 | 6240.4 ± 0.7% | 2565.9 ± 1.1% | 2501.9 ± 1.0% | 467.5 ± 1.1% | 1551.7 ± 0.2% | 980.5 ± 0.6% | 2.432 | 2.494 | 13.349 | 4.022 | 6.364 |
| string: canterbury/plrabn12.txt | 503330 | 5756.4 ± 0.3% | 2060.9 ± 0.4% | 2070.5 ± 0.4% | 424.6 ± 0.5% | 1389.5 ± 0.2% | 926.6 ± 0.7% | 2.793 | 2.780 | 13.558 | 4.143 | 6.212 |
| string: canterbury-large/E.coli | 1048578 | 19237.4 ± 0.4% | 9715.3 ± 0.2% | 3787.2 ± 0.4% | 1471.4 ± 0.5% | 2356.4 ± 0.6% | 1191.0 ± 0.2% | 1.980 | 5.080 | 13.074 | 8.164 | 16.152 |
| string: canterbury-large/bible.txt | 1055886 | 6770.7 ± 0.3% | 4118.4 ± 1.3% | 3047.9 ± 1.9% | 504.3 ± 0.6% | 1982.4 ± 0.6% | 1119.8 ± 0.2% | 1.644 | 2.221 | 13.426 | 3.415 | 6.046 |
| string: canterbury-large/world192.txt | 1103121 | 4031.4 ± 0.8% | 1647.8 ± 0.4% | 1996.8 ± 0.6% | 448.3 ± 2.7% | 1371.0 ± 0.3% | 908.7 ± 0.3% | 2.446 | 2.019 | 8.994 | 2.940 | 4.436 |
| string: http/html-1m | 1058582 | 6814.7 ± 0.4% | 3943.1 ± 0.4% | 3033.6 ± 1.7% | 499.6 ± 0.6% | 1922.4 ± 0.5% | 803.7 ± 0.3% | 1.728 | 2.246 | 13.640 | 3.545 | 8.479 |
| string: http/json-1m | 1190272 | 3286.2 ± 3.5% | 1356.4 ± 0.3% | 1551.4 ± 0.7% | 443.6 ± 0.4% | 1072.3 ± 0.4% | 765.0 ± 1.5% | 2.423 | 2.118 | 7.407 | 3.065 | 4.296 |
| string: http/js-1m | 1144362 | 2800.4 ± 1.0% | 1174.8 ± 1.1% | 1626.4 ± 0.7% | 368.4 ± 0.6% | 1109.7 ± 0.8% | 756.4 ± 0.8% | 2.384 | 1.722 | 7.602 | 2.524 | 3.702 |
| string: http/css-1m | 1097820 | 4016.2 ± 1.1% | 1489.4 ± 0.3% | 2146.6 ± 1.0% | 493.0 ± 0.5% | 1378.9 ± 0.5% | 893.6 ± 0.2% | 2.697 | 1.871 | 8.146 | 2.913 | 4.495 |
| string: dickens as Cyrillic and CJK | 1883069 | 3070.0 ± 0.5% | 2336.4 ± 0.5% | 520.7 ± 0.3% | 306.7 ± 0.6% | 562.7 ± 0.9% | 336.0 ± 0.3% | 1.314 | 5.896 | 10.011 | 5.456 | 9.136 |
| hex: silesia/dickens | 524290 | 15671.3 ± 0.3% | 1463.5 ± 0.3% | 1081.0 ± 0.4% | 498.7 ± 1.2% | 986.4 ± 0.5% | 733.7 ± 0.5% | 10.708 | 14.497 | 31.427 | 15.887 | 21.358 |
| hex: silesia/mozilla | 524290 | 15658.6 ± 0.7% | 1473.1 ± 0.2% | 1088.4 ± 0.4% | 440.5 ± 3.0% | 988.9 ± 0.6% | 733.5 ± 0.3% | 10.630 | 14.387 | 35.549 | 15.835 | 21.349 |
| hex: silesia/mr | 524290 | 15619.2 ± 0.3% | 1479.6 ± 0.4% | 1091.4 ± 0.3% | 552.6 ± 3.2% | 994.9 ± 0.6% | 732.8 ± 0.4% | 10.556 | 14.311 | 28.266 | 15.700 | 21.314 |
| hex: silesia/nci | 524290 | 15640.3 ± 0.4% | 1468.6 ± 0.2% | 1087.7 ± 0.7% | 638.2 ± 2.2% | 988.2 ± 0.5% | 732.5 ± 0.5% | 10.650 | 14.379 | 24.507 | 15.827 | 21.352 |
| hex: silesia/ooffice | 524290 | 15637.1 ± 0.5% | 1462.8 ± 0.3% | 1081.5 ± 0.3% | 388.9 ± 0.4% | 989.3 ± 0.3% | 733.8 ± 0.4% | 10.690 | 14.459 | 40.209 | 15.807 | 21.311 |
| hex: silesia/osdb | 524290 | 15634.9 ± 0.2% | 1468.0 ± 0.2% | 1085.0 ± 0.2% | 468.6 ± 0.9% | 990.5 ± 0.6% | 732.9 ± 0.7% | 10.651 | 14.410 | 33.365 | 15.785 | 21.334 |
| hex: silesia/reymont | 524290 | 15600.5 ± 0.8% | 1461.6 ± 0.5% | 1083.4 ± 0.5% | 513.9 ± 1.5% | 986.4 ± 0.5% | 732.6 ± 0.5% | 10.674 | 14.400 | 30.355 | 15.815 | 21.295 |
| hex: silesia/samba | 524290 | 15636.5 ± 0.3% | 1463.6 ± 1.2% | 1081.5 ± 0.5% | 402.1 ± 0.4% | 986.9 ± 0.5% | 733.6 ± 0.8% | 10.683 | 14.459 | 38.884 | 15.844 | 21.316 |
| hex: silesia/sao | 524290 | 15660.5 ± 0.5% | 1464.6 ± 0.4% | 1084.3 ± 0.5% | 332.6 ± 0.5% | 987.6 ± 0.7% | 734.0 ± 0.3% | 10.693 | 14.444 | 47.079 | 15.857 | 21.337 |
| hex: silesia/webster | 524290 | 15659.6 ± 0.5% | 1461.8 ± 0.3% | 1081.5 ± 0.4% | 475.4 ± 0.1% | 986.2 ± 0.4% | 732.6 ± 0.3% | 10.712 | 14.480 | 32.937 | 15.879 | 21.376 |
| hex: silesia/x-ray | 524290 | 15641.3 ± 0.3% | 1474.3 ± 0.3% | 1087.6 ± 0.2% | 443.8 ± 0.3% | 990.6 ± 0.6% | 732.8 ± 0.4% | 10.609 | 14.382 | 35.241 | 15.790 | 21.344 |
| hex: silesia/xml | 524290 | 15608.9 ± 0.3% | 1466.0 ± 0.4% | 1084.5 ± 0.4% | 614.7 ± 1.1% | 986.4 ± 0.2% | 733.3 ± 0.8% | 10.647 | 14.393 | 25.392 | 15.825 | 21.285 |
| hex: canterbury/alice29.txt | 304180 | 15684.2 ± 0.1% | 1470.6 ± 0.4% | 1086.2 ± 0.3% | 503.2 ± 0.9% | 989.4 ± 0.3% | 733.9 ± 0.3% | 10.665 | 14.439 | 31.172 | 15.852 | 21.372 |
| hex: canterbury/asyoulik.txt | 250360 | 15717.1 ± 0.1% | 1468.5 ± 0.3% | 1091.1 ± 0.4% | 497.4 ± 1.2% | 992.4 ± 0.1% | 740.2 ± 0.2% | 10.703 | 14.405 | 31.602 | 15.838 | 21.233 |
| hex: canterbury/cp.html | 49208 | 15638.6 ± 0.0% | 1472.0 ± 0.3% | 1096.9 ± 0.1% | 526.2 ± 2.5% | 1000.7 ± 0.1% | 742.6 ± 0.1% | 10.624 | 14.257 | 29.717 | 15.627 | 21.060 |
| hex: canterbury/fields.c | 22302 | 15459.0 ± 0.0% | 1411.4 ± 0.4% | 1060.5 ± 0.3% | 632.7 ± 7.8% | 988.4 ± 0.1% | 736.4 ± 0.1% | 10.953 | 14.577 | 24.433 | 15.641 | 20.994 |
| hex: canterbury/grammar.lsp | 7444 | 14978.9 ± 0.1% | 1504.1 ± 0.1% | 1091.1 ± 0.3% | 670.5 ± 4.1% | 1001.7 ± 0.2% | 725.8 ± 0.1% | 9.959 | 13.728 | 22.341 | 14.954 | 20.639 |
| hex: canterbury/kennedy.xls | 524290 | 15625.6 ± 0.2% | 1469.1 ± 0.5% | 1088.3 ± 0.5% | 655.6 ± 3.3% | 986.2 ± 0.5% | 731.9 ± 0.9% | 10.636 | 14.357 | 23.833 | 15.845 | 21.348 |
| hex: canterbury/lcet10.txt | 524290 | 15642.4 ± 0.4% | 1464.1 ± 0.4% | 1083.3 ± 0.2% | 503.9 ± 1.2% | 988.7 ± 0.3% | 731.8 ± 0.7% | 10.684 | 14.440 | 31.041 | 15.821 | 21.376 |
| hex: canterbury/plrabn12.txt | 524290 | 15631.6 ± 0.4% | 1459.6 ± 0.3% | 1082.1 ± 0.5% | 493.5 ± 0.7% | 988.0 ± 0.3% | 733.0 ± 0.8% | 10.709 | 14.446 | 31.676 | 15.822 | 21.325 |
| hex: canterbury/ptt5 | 524290 | 15631.7 ± 0.4% | 1480.0 ± 0.2% | 1089.7 ± 0.6% | 553.4 ± 0.6% | 993.7 ± 0.3% | 733.1 ± 0.3% | 10.562 | 14.345 | 28.246 | 15.731 | 21.324 |
| hex: canterbury/sum | 76482 | 15652.3 ± 0.1% | 1494.5 ± 0.3% | 1103.9 ± 0.2% | 598.5 ± 1.6% | 998.2 ± 0.4% | 743.9 ± 0.1% | 10.473 | 14.179 | 26.153 | 15.681 | 21.041 |
| hex: canterbury/xargs.1 | 8456 | 15038.8 ± 0.1% | 1491.4 ± 1.2% | 1090.8 ± 0.6% | 650.5 ± 7.0% | 1001.7 ± 0.6% | 728.3 ± 0.1% | 10.084 | 13.787 | 23.120 | 15.013 | 20.649 |
| hex: canterbury-large/E.coli | 524290 | 15650.2 ± 0.8% | 1472.9 ± 0.1% | 1089.2 ± 0.4% | 671.9 ± 0.2% | 993.2 ± 0.4% | 732.7 ± 0.5% | 10.626 | 14.369 | 23.293 | 15.757 | 21.359 |
| hex: canterbury-large/bible.txt | 524290 | 15629.4 ± 0.6% | 1466.7 ± 0.4% | 1084.0 ± 0.4% | 513.2 ± 1.0% | 989.1 ± 0.4% | 730.7 ± 0.8% | 10.656 | 14.419 | 30.455 | 15.802 | 21.388 |
| hex: canterbury-large/world192.txt | 524290 | 15617.2 ± 0.4% | 1466.3 ± 0.2% | 1082.3 ± 0.6% | 504.1 ± 0.5% | 989.0 ± 0.3% | 732.5 ± 0.4% | 10.651 | 14.430 | 30.979 | 15.790 | 21.319 |
| hex: http/html-1kx1024 | 2099200 | 13855.7 ± 0.8% | 1453.8 ± 0.5% | 1061.4 ± 0.4% | 502.4 ± 0.3% | 985.2 ± 0.5% | 692.0 ± 0.2% | 9.531 | 13.055 | 27.578 | 14.064 | 20.023 |
| hex: http/html-16kx64 | 2097280 | 15264.6 ± 0.4% | 1450.4 ± 0.5% | 1074.5 ± 0.3% | 507.7 ± 0.4% | 995.7 ± 0.6% | 733.6 ± 0.1% | 10.525 | 14.207 | 30.068 | 15.331 | 20.808 |
| hex: http/html-1m | 524290 | 15634.9 ± 0.2% | 1464.2 ± 0.2% | 1083.3 ± 0.9% | 502.7 ± 1.0% | 988.1 ± 0.5% | 732.7 ± 0.4% | 10.678 | 14.432 | 31.100 | 15.823 | 21.339 |
| hex: http/json-1kx1024 | 2099200 | 13785.9 ± 0.6% | 1461.9 ± 0.2% | 1066.0 ± 0.1% | 609.2 ± 0.3% | 986.0 ± 0.2% | 692.4 ± 0.1% | 9.430 | 12.932 | 22.628 | 13.982 | 19.912 |
| hex: http/json-16kx64 | 2097280 | 15294.0 ± 0.9% | 1446.2 ± 0.6% | 1073.9 ± 0.1% | 619.2 ± 0.8% | 991.5 ± 2.9% | 734.5 ± 0.7% | 10.575 | 14.241 | 24.699 | 15.425 | 20.821 |
| hex: http/json-1m | 524290 | 15667.2 ± 0.4% | 1475.6 ± 0.4% | 1085.7 ± 0.5% | 636.7 ± 0.3% | 990.8 ± 0.3% | 731.9 ± 0.5% | 10.618 | 14.430 | 24.608 | 15.813 | 21.406 |
| hex: http/js-1kx1024 | 2099200 | 13794.4 ± 0.5% | 1455.6 ± 0.4% | 1063.7 ± 0.2% | 499.3 ± 0.3% | 984.6 ± 0.3% | 692.6 ± 0.1% | 9.477 | 12.969 | 27.625 | 14.010 | 19.916 |
| hex: http/js-16kx64 | 2097280 | 15328.7 ± 0.5% | 1441.4 ± 0.3% | 1073.3 ± 0.1% | 504.8 ± 0.5% | 995.4 ± 0.3% | 733.7 ± 0.2% | 10.634 | 14.282 | 30.368 | 15.399 | 20.891 |
| hex: http/js-1m | 524290 | 15643.1 ± 0.3% | 1463.5 ± 0.5% | 1080.1 ± 0.5% | 511.7 ± 0.6% | 985.2 ± 0.8% | 732.6 ± 0.6% | 10.689 | 14.483 | 30.574 | 15.878 | 21.354 |
| hex: http/css-1kx1024 | 2099200 | 13814.9 ± 0.5% | 1454.1 ± 0.2% | 1061.8 ± 0.1% | 531.6 ± 0.3% | 982.5 ± 0.1% | 692.6 ± 0.1% | 9.501 | 13.010 | 25.988 | 14.061 | 19.948 |
| hex: http/css-16kx64 | 2097280 | 15211.6 ± 1.0% | 1438.7 ± 0.3% | 1073.7 ± 0.1% | 541.2 ± 0.7% | 994.1 ± 0.7% | 734.3 ± 0.2% | 10.573 | 14.168 | 28.105 | 15.302 | 20.715 |
| hex: http/css-1m | 524290 | 15676.0 ± 0.6% | 1465.1 ± 0.3% | 1081.7 ± 0.6% | 527.7 ± 0.8% | 985.3 ± 0.3% | 732.6 ± 0.5% | 10.699 | 14.492 | 29.706 | 15.910 | 21.397 |
| hex: shuffled/dickens-1m | 524290 | 15692.3 ± 0.2% | 1463.8 ± 0.2% | 1085.1 ± 0.5% | 499.3 ± 1.6% | 985.9 ± 0.8% | 734.4 ± 0.7% | 10.720 | 14.462 | 31.430 | 15.917 | 21.367 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 937.4 ± 0.2% | 926.4 ± 0.9% | 1013.2 ± 0.1% | 300.8 ± 0.5% | 666.2 ± 0.3% | 307.3 ± 1.7% | 1.012 | 0.925 | 3.116 | 1.407 | 3.050 |
| qlog records, JSON text sequence | 1467503 | 774.5 ± 1.3% | 814.9 ± 0.1% | 752.2 ± 1.9% | 241.4 ± 0.7% | 674.9 ± 2.0% | 230.8 ± 1.9% | 0.950 | 1.030 | 3.208 | 1.148 | 3.356 |
| string: silesia/dickens | 172528 | 5055.6 ± 0.2% | 1878.2 ± 0.2% | 2646.6 ± 0.3% | 361.1 ± 1.3% | 2863.5 ± 0.6% | 542.7 ± 1.6% | 2.692 | 1.910 | 14.002 | 1.766 | 9.315 |
| string: silesia/nci | 1075110 | 4305.9 ± 0.6% | 2231.9 ± 0.2% | 2991.0 ± 0.2% | 542.7 ± 1.4% | 2989.3 ± 1.5% | 598.4 ± 1.9% | 1.929 | 1.440 | 7.933 | 1.440 | 7.196 |
| string: silesia/reymont | 1075159 | 2985.9 ± 1.4% | 1811.3 ± 1.0% | 2062.3 ± 0.4% | 374.6 ± 0.8% | 2138.5 ± 0.6% | 531.9 ± 1.0% | 1.648 | 1.448 | 7.970 | 1.396 | 5.613 |
| string: silesia/samba | 97582 | 3500.8 ± 0.3% | 2024.4 ± 0.3% | 2618.5 ± 0.4% | 324.1 ± 0.4% | 1508.9 ± 0.5% | 422.7 ± 1.7% | 1.729 | 1.337 | 10.800 | 2.320 | 8.281 |
| string: silesia/webster | 1098490 | 3664.9 ± 0.5% | 1516.2 ± 0.3% | 2006.8 ± 0.4% | 359.8 ± 0.3% | 2170.8 ± 1.0% | 495.0 ± 1.5% | 2.417 | 1.826 | 10.185 | 1.688 | 7.404 |
| string: silesia/xml | 1090118 | 4784.3 ± 0.3% | 2355.4 ± 0.6% | 2518.7 ± 0.3% | 453.6 ± 1.1% | 2800.0 ± 1.4% | 559.9 ± 1.0% | 2.031 | 1.900 | 10.548 | 1.709 | 8.545 |
| string: canterbury/alice29.txt | 159425 | 4372.3 ± 1.2% | 1597.7 ± 0.4% | 2453.8 ± 0.4% | 341.5 ± 0.8% | 2502.2 ± 0.5% | 499.8 ± 0.6% | 2.737 | 1.782 | 12.804 | 1.747 | 8.749 |
| string: canterbury/asyoulik.txt | 132198 | 3498.0 ± 1.5% | 1458.5 ± 0.2% | 2243.7 ± 0.6% | 335.5 ± 1.4% | 2085.3 ± 0.4% | 452.7 ± 1.4% | 2.398 | 1.559 | 10.425 | 1.677 | 7.727 |
| string: canterbury/lcet10.txt | 441884 | 5141.3 ± 0.3% | 1849.3 ± 0.2% | 2332.5 ± 0.8% | 391.2 ± 0.6% | 2853.1 ± 0.9% | 529.0 ± 3.1% | 2.780 | 2.204 | 13.143 | 1.802 | 9.719 |
| string: canterbury/plrabn12.txt | 503330 | 4130.9 ± 0.2% | 1732.9 ± 0.2% | 2053.2 ± 0.6% | 362.1 ± 1.3% | 2469.6 ± 1.5% | 496.6 ± 0.6% | 2.384 | 2.012 | 11.408 | 1.673 | 8.318 |
| string: canterbury-large/E.coli | 1048578 | 11858.1 ± 0.9% | 3588.1 ± 0.4% | 3240.7 ± 0.4% | 931.1 ± 0.7% | 6000.6 ± 0.7% | 743.8 ± 1.5% | 3.305 | 3.659 | 12.736 | 1.976 | 15.943 |
| string: canterbury-large/bible.txt | 1055886 | 6871.4 ± 0.9% | 2931.9 ± 0.3% | 2825.9 ± 0.9% | 419.6 ± 1.5% | 3745.0 ± 2.1% | 609.1 ± 0.7% | 2.344 | 2.432 | 16.376 | 1.835 | 11.281 |
| string: canterbury-large/world192.txt | 1103121 | 3400.3 ± 0.4% | 1479.9 ± 0.3% | 2004.6 ± 0.2% | 352.5 ± 0.5% | 2119.1 ± 1.3% | 495.6 ± 1.5% | 2.298 | 1.696 | 9.645 | 1.605 | 6.862 |
| string: http/html-1m | 1058582 | 6224.7 ± 1.6% | 2731.9 ± 0.6% | 2685.7 ± 1.0% | 441.7 ± 0.4% | 3471.2 ± 0.5% | 594.9 ± 0.8% | 2.279 | 2.318 | 14.094 | 1.793 | 10.464 |
| string: http/json-1m | 1190272 | 2556.3 ± 0.2% | 874.9 ± 2.3% | 2248.4 ± 0.3% | 389.8 ± 0.8% | 1034.4 ± 3.4% | 435.0 ± 1.6% | 2.922 | 1.137 | 6.559 | 2.471 | 5.876 |
| string: http/js-1m | 1144362 | 2276.6 ± 0.8% | 1027.6 ± 0.3% | 1634.6 ± 0.4% | 320.6 ± 0.5% | 1520.2 ± 0.5% | 415.2 ± 1.1% | 2.215 | 1.393 | 7.100 | 1.498 | 5.482 |
| string: http/css-1m | 1097820 | 2651.9 ± 0.4% | 1675.7 ± 0.3% | 2225.3 ± 0.9% | 403.8 ± 1.6% | 1911.3 ± 0.8% | 484.6 ± 0.6% | 1.583 | 1.192 | 6.567 | 1.387 | 5.473 |
| string: dickens as Cyrillic and CJK | 1883069 | 3070.4 ± 0.4% | 1684.5 ± 0.2% | 887.8 ± 0.5% | 351.1 ± 0.2% | 664.3 ± 1.0% | 155.6 ± 3.0% | 1.823 | 3.459 | 8.744 | 4.622 | 19.737 |
| string: dickens as Cyrillic and CJK, as \u escapes | 5075485 | 1329.2 ± 0.2% | 975.7 ± 0.5% | 1186.4 ± 0.4% | 214.1 ± 0.1% | 470.5 ± 0.7% | 254.0 ± 3.2% | 1.362 | 1.120 | 6.207 | 2.825 | 5.234 |
| hex: silesia/dickens | 524290 | 11994.2 ± 0.2% | 3607.2 ± 0.3% | 3277.6 ± 0.1% | 509.9 ± 1.5% | 6053.1 ± 1.3% | 774.6 ± 1.6% | 3.325 | 3.659 | 23.523 | 1.982 | 15.485 |
| hex: silesia/mozilla | 524290 | 11990.0 ± 0.2% | 3609.4 ± 0.2% | 3289.2 ± 0.1% | 458.7 ± 2.4% | 6079.2 ± 1.0% | 776.1 ± 0.3% | 3.322 | 3.645 | 26.138 | 1.972 | 15.450 |
| hex: silesia/mr | 524290 | 12006.3 ± 0.2% | 3606.1 ± 0.4% | 3288.0 ± 0.2% | 577.6 ± 2.4% | 6079.5 ± 1.6% | 776.8 ± 0.4% | 3.329 | 3.652 | 20.786 | 1.975 | 15.456 |
| hex: silesia/nci | 524290 | 11970.5 ± 0.2% | 3604.7 ± 0.3% | 3283.9 ± 0.2% | 649.2 ± 5.3% | 6101.2 ± 1.1% | 775.9 ± 0.3% | 3.321 | 3.645 | 18.439 | 1.962 | 15.427 |
| hex: silesia/ooffice | 524290 | 11979.5 ± 0.2% | 3603.9 ± 0.3% | 3281.8 ± 0.2% | 401.1 ± 0.3% | 6078.7 ± 0.8% | 776.0 ± 0.8% | 3.324 | 3.650 | 29.870 | 1.971 | 15.438 |
| hex: silesia/osdb | 524290 | 11972.1 ± 0.1% | 3607.1 ± 0.2% | 3289.7 ± 0.3% | 485.2 ± 2.2% | 6001.3 ± 1.0% | 775.9 ± 0.4% | 3.319 | 3.639 | 24.673 | 1.995 | 15.430 |
| hex: silesia/reymont | 524290 | 11984.5 ± 0.4% | 3608.5 ± 0.2% | 3284.2 ± 0.6% | 524.3 ± 3.2% | 6086.3 ± 1.5% | 776.3 ± 0.4% | 3.321 | 3.649 | 22.858 | 1.969 | 15.437 |
| hex: silesia/samba | 524290 | 11973.1 ± 0.1% | 3607.5 ± 0.3% | 3293.4 ± 0.2% | 411.7 ± 2.5% | 6087.1 ± 1.1% | 775.7 ± 0.1% | 3.319 | 3.635 | 29.083 | 1.967 | 15.434 |
| hex: silesia/sao | 524290 | 12004.8 ± 0.2% | 3608.6 ± 0.2% | 3297.7 ± 0.3% | 346.3 ± 1.6% | 6120.9 ± 2.1% | 775.5 ± 0.8% | 3.327 | 3.640 | 34.671 | 1.961 | 15.481 |
| hex: silesia/webster | 524290 | 11911.7 ± 0.1% | 3607.7 ± 0.2% | 3293.3 ± 0.3% | 480.2 ± 1.5% | 6068.5 ± 1.0% | 774.8 ± 0.7% | 3.302 | 3.617 | 24.806 | 1.963 | 15.375 |
| hex: silesia/x-ray | 524290 | 12001.8 ± 0.1% | 3607.7 ± 0.3% | 3287.9 ± 0.2% | 487.1 ± 0.4% | 6086.5 ± 1.2% | 776.6 ± 0.5% | 3.327 | 3.650 | 24.641 | 1.972 | 15.454 |
| hex: silesia/xml | 524290 | 11999.6 ± 0.1% | 3607.1 ± 0.5% | 3283.8 ± 0.1% | 533.3 ± 0.4% | 6082.6 ± 1.2% | 777.7 ± 0.2% | 3.327 | 3.654 | 22.502 | 1.973 | 15.430 |
| hex: canterbury/alice29.txt | 304180 | 12012.5 ± 0.1% | 3610.6 ± 0.2% | 3373.2 ± 0.1% | 521.8 ± 0.2% | 6088.2 ± 1.2% | 774.6 ± 0.8% | 3.327 | 3.561 | 23.020 | 1.973 | 15.508 |
| hex: canterbury/asyoulik.txt | 250360 | 12002.9 ± 0.2% | 3639.8 ± 0.3% | 3365.9 ± 0.0% | 516.3 ± 0.4% | 6129.3 ± 1.9% | 774.5 ± 0.3% | 3.298 | 3.566 | 23.248 | 1.958 | 15.497 |
| hex: canterbury/cp.html | 49208 | 11903.3 ± 0.1% | 3637.1 ± 0.0% | 3278.2 ± 0.2% | 483.6 ± 1.1% | 6287.0 ± 0.7% | 760.0 ± 2.1% | 3.273 | 3.631 | 24.613 | 1.893 | 15.662 |
| hex: canterbury/fields.c | 22302 | 11783.3 ± 0.0% | 3628.6 ± 0.1% | 3349.8 ± 0.1% | 511.6 ± 0.5% | 6259.1 ± 0.5% | 745.0 ± 1.9% | 3.247 | 3.518 | 23.033 | 1.883 | 15.816 |
| hex: canterbury/grammar.lsp | 7444 | 11253.3 ± 0.1% | 3601.1 ± 0.1% | 3370.6 ± 0.5% | 554.6 ± 2.1% | 6174.1 ± 0.8% | 715.3 ± 1.9% | 3.125 | 3.339 | 20.292 | 1.823 | 15.733 |
| hex: canterbury/kennedy.xls | 524290 | 11974.2 ± 0.1% | 3613.4 ± 0.2% | 3285.4 ± 0.4% | 669.4 ± 3.0% | 6015.2 ± 1.0% | 770.5 ± 7.3% | 3.314 | 3.645 | 17.888 | 1.991 | 15.540 |
| hex: canterbury/lcet10.txt | 524290 | 12016.1 ± 0.1% | 3608.9 ± 0.4% | 3298.6 ± 0.5% | 527.7 ± 0.4% | 6085.6 ± 0.6% | 778.0 ± 1.1% | 3.330 | 3.643 | 22.769 | 1.975 | 15.445 |
| hex: canterbury/plrabn12.txt | 524290 | 11969.9 ± 0.3% | 3610.4 ± 0.4% | 3282.1 ± 0.4% | 516.5 ± 0.4% | 6075.3 ± 1.2% | 779.3 ± 1.0% | 3.315 | 3.647 | 23.175 | 1.970 | 15.360 |
| hex: canterbury/ptt5 | 524290 | 11971.6 ± 0.2% | 3609.2 ± 0.3% | 3275.6 ± 0.1% | 559.7 ± 1.1% | 5995.0 ± 0.9% | 780.7 ± 1.1% | 3.317 | 3.655 | 21.389 | 1.997 | 15.335 |
| hex: canterbury/sum | 76482 | 11919.8 ± 0.1% | 3633.0 ± 0.1% | 3355.1 ± 0.3% | 510.6 ± 0.8% | 6165.1 ± 0.4% | 768.4 ± 0.8% | 3.281 | 3.553 | 23.346 | 1.933 | 15.512 |
| hex: canterbury/xargs.1 | 8456 | 11353.2 ± 0.1% | 3602.1 ± 0.0% | 3378.7 ± 0.3% | 497.2 ± 2.8% | 6152.6 ± 0.4% | 751.1 ± 1.7% | 3.152 | 3.360 | 22.835 | 1.845 | 15.116 |
| hex: canterbury-large/E.coli | 524290 | 11960.0 ± 0.1% | 3608.7 ± 0.5% | 3280.5 ± 0.9% | 688.7 ± 0.2% | 6041.6 ± 0.9% | 747.5 ± 6.1% | 3.314 | 3.646 | 17.365 | 1.980 | 16.001 |
| hex: canterbury-large/bible.txt | 524290 | 11992.4 ± 0.2% | 3607.9 ± 0.2% | 3289.0 ± 0.4% | 519.7 ± 0.6% | 6083.1 ± 1.0% | 762.1 ± 1.7% | 3.324 | 3.646 | 23.077 | 1.971 | 15.735 |
| hex: canterbury-large/world192.txt | 524290 | 11967.3 ± 0.1% | 3609.9 ± 0.3% | 3286.3 ± 0.3% | 494.4 ± 0.9% | 6080.9 ± 0.3% | 755.0 ± 3.1% | 3.315 | 3.642 | 24.205 | 1.968 | 15.852 |
| hex: http/html-1kx1024 | 2099200 | 8676.3 ± 3.2% | 3456.4 ± 0.4% | 2830.2 ± 0.7% | 475.3 ± 0.5% | 5046.4 ± 0.8% | 626.3 ± 2.0% | 2.510 | 3.066 | 18.253 | 1.719 | 13.854 |
| hex: http/html-16kx64 | 2097280 | 11756.5 ± 0.2% | 3607.5 ± 0.2% | 3262.6 ± 0.8% | 477.7 ± 0.4% | 6017.1 ± 0.6% | 743.0 ± 5.0% | 3.259 | 3.603 | 24.613 | 1.954 | 15.822 |
| hex: http/html-1m | 524290 | 11972.4 ± 0.3% | 3611.6 ± 0.1% | 3278.4 ± 0.4% | 509.5 ± 2.1% | 6075.0 ± 0.2% | 751.5 ± 2.1% | 3.315 | 3.652 | 23.497 | 1.971 | 15.931 |
| hex: http/json-1kx1024 | 2099200 | 8750.4 ± 4.3% | 3458.6 ± 0.5% | 2817.9 ± 0.5% | 575.2 ± 0.6% | 5021.6 ± 7.1% | 619.8 ± 18.1% | 2.530 | 3.105 | 15.212 | 1.743 | 14.118 |
| hex: http/json-16kx64 | 2097280 | 11757.1 ± 0.3% | 3606.8 ± 0.2% | 3257.4 ± 0.3% | 572.5 ± 0.4% | 6033.9 ± 0.5% | 744.2 ± 2.5% | 3.260 | 3.609 | 20.536 | 1.949 | 15.799 |
| hex: http/json-1m | 524290 | 11950.3 ± 0.2% | 3608.1 ± 0.4% | 3291.6 ± 0.4% | 595.9 ± 1.3% | 6062.3 ± 1.4% | 750.2 ± 3.3% | 3.312 | 3.631 | 20.055 | 1.971 | 15.930 |
| hex: http/js-1kx1024 | 2099200 | 8731.4 ± 3.5% | 3463.4 ± 0.1% | 2826.8 ± 0.6% | 482.5 ± 0.8% | 5035.6 ± 0.9% | 631.4 ± 4.9% | 2.521 | 3.089 | 18.095 | 1.734 | 13.829 |
| hex: http/js-16kx64 | 2097280 | 11755.2 ± 2.0% | 3608.5 ± 0.2% | 3254.3 ± 0.2% | 480.2 ± 0.9% | 6008.3 ± 0.7% | 732.8 ± 5.1% | 3.258 | 3.612 | 24.481 | 1.956 | 16.041 |
| hex: http/js-1m | 524290 | 12006.4 ± 0.2% | 3604.5 ± 0.2% | 3288.4 ± 0.2% | 509.4 ± 0.3% | 6112.4 ± 0.6% | 758.3 ± 2.4% | 3.331 | 3.651 | 23.571 | 1.964 | 15.833 |
| hex: http/css-1kx1024 | 2099200 | 8692.2 ± 4.3% | 3460.2 ± 0.2% | 2817.7 ± 0.3% | 488.9 ± 0.7% | 5029.2 ± 1.3% | 623.2 ± 1.8% | 2.512 | 3.085 | 17.778 | 1.728 | 13.947 |
| hex: http/css-16kx64 | 2097280 | 11757.5 ± 0.2% | 3606.6 ± 0.2% | 3250.2 ± 0.2% | 494.2 ± 1.2% | 6012.7 ± 0.5% | 742.6 ± 3.8% | 3.260 | 3.617 | 23.789 | 1.955 | 15.834 |
| hex: http/css-1m | 524290 | 11994.4 ± 0.2% | 3607.5 ± 0.1% | 3286.0 ± 0.2% | 503.0 ± 0.4% | 6076.6 ± 1.4% | 752.2 ± 3.2% | 3.325 | 3.650 | 23.847 | 1.974 | 15.946 |
| hex: shuffled/dickens-1m | 524290 | 11955.0 ± 0.4% | 3604.5 ± 0.2% | 3275.9 ± 0.2% | 514.1 ± 2.7% | 6032.9 ± 1.2% | 760.6 ± 0.6% | 3.317 | 3.649 | 23.256 | 1.982 | 15.718 |

## TextReader.next_items against the baselines

stdx's decoder a slice of tokens a call through `TextReader.next_items`, as a caller that reads a text's values in a loop calls it (decision 79). Octets are the text's. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1013.4 ± 0.4% | 926.4 ± 0.9% | 1013.2 ± 0.1% | 300.8 ± 0.5% | 666.2 ± 0.3% | 307.3 ± 1.7% | 1.094 | 1.000 | 3.369 | 1.521 | 3.298 |
| qlog records, JSON text sequence | 1467503 | 835.1 ± 0.6% | 814.9 ± 0.1% | 752.2 ± 1.9% | 241.4 ± 0.7% | 674.9 ± 2.0% | 230.8 ± 1.9% | 1.025 | 1.110 | 3.459 | 1.237 | 3.618 |
| string: silesia/dickens | 172528 | 5052.1 ± 0.2% | 1878.2 ± 0.2% | 2646.6 ± 0.3% | 361.1 ± 1.3% | 2863.5 ± 0.6% | 542.7 ± 1.6% | 2.690 | 1.909 | 13.993 | 1.764 | 9.308 |
| string: silesia/nci | 1075110 | 4300.6 ± 0.5% | 2231.9 ± 0.2% | 2991.0 ± 0.2% | 542.7 ± 1.4% | 2989.3 ± 1.5% | 598.4 ± 1.9% | 1.927 | 1.438 | 7.924 | 1.439 | 7.187 |
| string: silesia/reymont | 1075159 | 2994.0 ± 1.4% | 1811.3 ± 1.0% | 2062.3 ± 0.4% | 374.6 ± 0.8% | 2138.5 ± 0.6% | 531.9 ± 1.0% | 1.653 | 1.452 | 7.992 | 1.400 | 5.629 |
| string: silesia/samba | 97582 | 3513.4 ± 0.3% | 2024.4 ± 0.3% | 2618.5 ± 0.4% | 324.1 ± 0.4% | 1508.9 ± 0.5% | 422.7 ± 1.7% | 1.736 | 1.342 | 10.839 | 2.328 | 8.311 |
| string: silesia/webster | 1098490 | 3667.2 ± 0.6% | 1516.2 ± 0.3% | 2006.8 ± 0.4% | 359.8 ± 0.3% | 2170.8 ± 1.0% | 495.0 ± 1.5% | 2.419 | 1.827 | 10.192 | 1.689 | 7.409 |
| string: silesia/xml | 1090118 | 4799.0 ± 0.7% | 2355.4 ± 0.6% | 2518.7 ± 0.3% | 453.6 ± 1.1% | 2800.0 ± 1.4% | 559.9 ± 1.0% | 2.037 | 1.905 | 10.580 | 1.714 | 8.572 |
| string: canterbury/alice29.txt | 159425 | 4377.9 ± 1.2% | 1597.7 ± 0.4% | 2453.8 ± 0.4% | 341.5 ± 0.8% | 2502.2 ± 0.5% | 499.8 ± 0.6% | 2.740 | 1.784 | 12.820 | 1.750 | 8.760 |
| string: canterbury/asyoulik.txt | 132198 | 3506.4 ± 1.1% | 1458.5 ± 0.2% | 2243.7 ± 0.6% | 335.5 ± 1.4% | 2085.3 ± 0.4% | 452.7 ± 1.4% | 2.404 | 1.563 | 10.450 | 1.681 | 7.745 |
| string: canterbury/lcet10.txt | 441884 | 5131.8 ± 0.4% | 1849.3 ± 0.2% | 2332.5 ± 0.8% | 391.2 ± 0.6% | 2853.1 ± 0.9% | 529.0 ± 3.1% | 2.775 | 2.200 | 13.118 | 1.799 | 9.701 |
| string: canterbury/plrabn12.txt | 503330 | 4136.1 ± 0.4% | 1732.9 ± 0.2% | 2053.2 ± 0.6% | 362.1 ± 1.3% | 2469.6 ± 1.5% | 496.6 ± 0.6% | 2.387 | 2.015 | 11.423 | 1.675 | 8.328 |
| string: canterbury-large/E.coli | 1048578 | 11859.0 ± 0.7% | 3588.1 ± 0.4% | 3240.7 ± 0.4% | 931.1 ± 0.7% | 6000.6 ± 0.7% | 743.8 ± 1.5% | 3.305 | 3.659 | 12.737 | 1.976 | 15.945 |
| string: canterbury-large/bible.txt | 1055886 | 6898.5 ± 0.8% | 2931.9 ± 0.3% | 2825.9 ± 0.9% | 419.6 ± 1.5% | 3745.0 ± 2.1% | 609.1 ± 0.7% | 2.353 | 2.441 | 16.441 | 1.842 | 11.326 |
| string: canterbury-large/world192.txt | 1103121 | 3400.3 ± 0.4% | 1479.9 ± 0.3% | 2004.6 ± 0.2% | 352.5 ± 0.5% | 2119.1 ± 1.3% | 495.6 ± 1.5% | 2.298 | 1.696 | 9.645 | 1.605 | 6.862 |
| string: http/html-1m | 1058582 | 6243.8 ± 1.8% | 2731.9 ± 0.6% | 2685.7 ± 1.0% | 441.7 ± 0.4% | 3471.2 ± 0.5% | 594.9 ± 0.8% | 2.286 | 2.325 | 14.137 | 1.799 | 10.496 |
| string: http/json-1m | 1190272 | 2554.7 ± 0.5% | 874.9 ± 2.3% | 2248.4 ± 0.3% | 389.8 ± 0.8% | 1034.4 ± 3.4% | 435.0 ± 1.6% | 2.920 | 1.136 | 6.555 | 2.470 | 5.872 |
| string: http/js-1m | 1144362 | 2282.6 ± 0.5% | 1027.6 ± 0.3% | 1634.6 ± 0.4% | 320.6 ± 0.5% | 1520.2 ± 0.5% | 415.2 ± 1.1% | 2.221 | 1.396 | 7.119 | 1.501 | 5.497 |
| string: http/css-1m | 1097820 | 2656.5 ± 0.6% | 1675.7 ± 0.3% | 2225.3 ± 0.9% | 403.8 ± 1.6% | 1911.3 ± 0.8% | 484.6 ± 0.6% | 1.585 | 1.194 | 6.578 | 1.390 | 5.482 |
| string: dickens as Cyrillic and CJK | 1883069 | 3074.2 ± 0.4% | 1684.5 ± 0.2% | 887.8 ± 0.5% | 351.1 ± 0.2% | 664.3 ± 1.0% | 155.6 ± 3.0% | 1.825 | 3.463 | 8.755 | 4.627 | 19.762 |
| string: dickens as Cyrillic and CJK, as \u escapes | 5075485 | 1328.9 ± 0.1% | 975.7 ± 0.5% | 1186.4 ± 0.4% | 214.1 ± 0.1% | 470.5 ± 0.7% | 254.0 ± 3.2% | 1.362 | 1.120 | 6.206 | 2.824 | 5.233 |
| hex: silesia/dickens | 524290 | 11987.7 ± 0.1% | 3607.2 ± 0.3% | 3277.6 ± 0.1% | 509.9 ± 1.5% | 6053.1 ± 1.3% | 774.6 ± 1.6% | 3.323 | 3.658 | 23.510 | 1.980 | 15.476 |
| hex: silesia/mozilla | 524290 | 11994.2 ± 0.2% | 3609.4 ± 0.2% | 3289.2 ± 0.1% | 458.7 ± 2.4% | 6079.2 ± 1.0% | 776.1 ± 0.3% | 3.323 | 3.647 | 26.147 | 1.973 | 15.455 |
| hex: silesia/mr | 524290 | 12004.8 ± 0.2% | 3606.1 ± 0.4% | 3288.0 ± 0.2% | 577.6 ± 2.4% | 6079.5 ± 1.6% | 776.8 ± 0.4% | 3.329 | 3.651 | 20.783 | 1.975 | 15.454 |
| hex: silesia/nci | 524290 | 11972.7 ± 0.1% | 3604.7 ± 0.3% | 3283.9 ± 0.2% | 649.2 ± 5.3% | 6101.2 ± 1.1% | 775.9 ± 0.3% | 3.321 | 3.646 | 18.443 | 1.962 | 15.430 |
| hex: silesia/ooffice | 524290 | 11977.9 ± 0.0% | 3603.9 ± 0.3% | 3281.8 ± 0.2% | 401.1 ± 0.3% | 6078.7 ± 0.8% | 776.0 ± 0.8% | 3.324 | 3.650 | 29.866 | 1.970 | 15.436 |
| hex: silesia/osdb | 524290 | 12005.9 ± 0.1% | 3607.1 ± 0.2% | 3289.7 ± 0.3% | 485.2 ± 2.2% | 6001.3 ± 1.0% | 775.9 ± 0.4% | 3.328 | 3.650 | 24.743 | 2.001 | 15.474 |
| hex: silesia/reymont | 524290 | 11991.6 ± 0.1% | 3608.5 ± 0.2% | 3284.2 ± 0.6% | 524.3 ± 3.2% | 6086.3 ± 1.5% | 776.3 ± 0.4% | 3.323 | 3.651 | 22.872 | 1.970 | 15.447 |
| hex: silesia/samba | 524290 | 11959.4 ± 0.2% | 3607.5 ± 0.3% | 3293.4 ± 0.2% | 411.7 ± 2.5% | 6087.1 ± 1.1% | 775.7 ± 0.1% | 3.315 | 3.631 | 29.049 | 1.965 | 15.417 |
| hex: silesia/sao | 524290 | 11998.6 ± 0.1% | 3608.6 ± 0.2% | 3297.7 ± 0.3% | 346.3 ± 1.6% | 6120.9 ± 2.1% | 775.5 ± 0.8% | 3.325 | 3.638 | 34.653 | 1.960 | 15.473 |
| hex: silesia/webster | 524290 | 11980.8 ± 0.1% | 3607.7 ± 0.2% | 3293.3 ± 0.3% | 480.2 ± 1.5% | 6068.5 ± 1.0% | 774.8 ± 0.7% | 3.321 | 3.638 | 24.950 | 1.974 | 15.464 |
| hex: silesia/x-ray | 524290 | 12012.4 ± 0.1% | 3607.7 ± 0.3% | 3287.9 ± 0.2% | 487.1 ± 0.4% | 6086.5 ± 1.2% | 776.6 ± 0.5% | 3.330 | 3.653 | 24.663 | 1.974 | 15.468 |
| hex: silesia/xml | 524290 | 12010.1 ± 0.1% | 3607.1 ± 0.5% | 3283.8 ± 0.1% | 533.3 ± 0.4% | 6082.6 ± 1.2% | 777.7 ± 0.2% | 3.330 | 3.657 | 22.522 | 1.975 | 15.444 |
| hex: canterbury/alice29.txt | 304180 | 12011.5 ± 0.1% | 3610.6 ± 0.2% | 3373.2 ± 0.1% | 521.8 ± 0.2% | 6088.2 ± 1.2% | 774.6 ± 0.8% | 3.327 | 3.561 | 23.019 | 1.973 | 15.507 |
| hex: canterbury/asyoulik.txt | 250360 | 12007.9 ± 0.2% | 3639.8 ± 0.3% | 3365.9 ± 0.0% | 516.3 ± 0.4% | 6129.3 ± 1.9% | 774.5 ± 0.3% | 3.299 | 3.568 | 23.258 | 1.959 | 15.503 |
| hex: canterbury/cp.html | 49208 | 11906.1 ± 0.1% | 3637.1 ± 0.0% | 3278.2 ± 0.2% | 483.6 ± 1.1% | 6287.0 ± 0.7% | 760.0 ± 2.1% | 3.274 | 3.632 | 24.619 | 1.894 | 15.666 |
| hex: canterbury/fields.c | 22302 | 11787.2 ± 0.2% | 3628.6 ± 0.1% | 3349.8 ± 0.1% | 511.6 ± 0.5% | 6259.1 ± 0.5% | 745.0 ± 1.9% | 3.248 | 3.519 | 23.041 | 1.883 | 15.822 |
| hex: canterbury/grammar.lsp | 7444 | 11333.6 ± 0.0% | 3601.1 ± 0.1% | 3370.6 ± 0.5% | 554.6 ± 2.1% | 6174.1 ± 0.8% | 715.3 ± 1.9% | 3.147 | 3.363 | 20.437 | 1.836 | 15.845 |
| hex: canterbury/kennedy.xls | 524290 | 11980.8 ± 0.1% | 3613.4 ± 0.2% | 3285.4 ± 0.4% | 669.4 ± 3.0% | 6015.2 ± 1.0% | 770.5 ± 7.3% | 3.316 | 3.647 | 17.898 | 1.992 | 15.548 |
| hex: canterbury/lcet10.txt | 524290 | 12018.3 ± 0.1% | 3608.9 ± 0.4% | 3298.6 ± 0.5% | 527.7 ± 0.4% | 6085.6 ± 0.6% | 778.0 ± 1.1% | 3.330 | 3.643 | 22.773 | 1.975 | 15.448 |
| hex: canterbury/plrabn12.txt | 524290 | 11981.9 ± 0.1% | 3610.4 ± 0.4% | 3282.1 ± 0.4% | 516.5 ± 0.4% | 6075.3 ± 1.2% | 779.3 ± 1.0% | 3.319 | 3.651 | 23.198 | 1.972 | 15.376 |
| hex: canterbury/ptt5 | 524290 | 11997.7 ± 0.1% | 3609.2 ± 0.3% | 3275.6 ± 0.1% | 559.7 ± 1.1% | 5995.0 ± 0.9% | 780.7 ± 1.1% | 3.324 | 3.663 | 21.436 | 2.001 | 15.368 |
| hex: canterbury/sum | 76482 | 11917.6 ± 0.1% | 3633.0 ± 0.1% | 3355.1 ± 0.3% | 510.6 ± 0.8% | 6165.1 ± 0.4% | 768.4 ± 0.8% | 3.280 | 3.552 | 23.341 | 1.933 | 15.509 |
| hex: canterbury/xargs.1 | 8456 | 11356.0 ± 0.0% | 3602.1 ± 0.0% | 3378.7 ± 0.3% | 497.2 ± 2.8% | 6152.6 ± 0.4% | 751.1 ± 1.7% | 3.153 | 3.361 | 22.840 | 1.846 | 15.120 |
| hex: canterbury-large/E.coli | 524290 | 11953.2 ± 0.4% | 3608.7 ± 0.5% | 3280.5 ± 0.9% | 688.7 ± 0.2% | 6041.6 ± 0.9% | 747.5 ± 6.1% | 3.312 | 3.644 | 17.355 | 1.978 | 15.992 |
| hex: canterbury-large/bible.txt | 524290 | 11992.6 ± 0.1% | 3607.9 ± 0.2% | 3289.0 ± 0.4% | 519.7 ± 0.6% | 6083.1 ± 1.0% | 762.1 ± 1.7% | 3.324 | 3.646 | 23.078 | 1.971 | 15.736 |
| hex: canterbury-large/world192.txt | 524290 | 11976.9 ± 0.2% | 3609.9 ± 0.3% | 3286.3 ± 0.3% | 494.4 ± 0.9% | 6080.9 ± 0.3% | 755.0 ± 3.1% | 3.318 | 3.644 | 24.224 | 1.970 | 15.864 |
| hex: http/html-1kx1024 | 2099200 | 8718.5 ± 3.9% | 3456.4 ± 0.4% | 2830.2 ± 0.7% | 475.3 ± 0.5% | 5046.4 ± 0.8% | 626.3 ± 2.0% | 2.522 | 3.081 | 18.342 | 1.728 | 13.921 |
| hex: http/html-16kx64 | 2097280 | 11760.2 ± 0.1% | 3607.5 ± 0.2% | 3262.6 ± 0.8% | 477.7 ± 0.4% | 6017.1 ± 0.6% | 743.0 ± 5.0% | 3.260 | 3.605 | 24.620 | 1.954 | 15.827 |
| hex: http/html-1m | 524290 | 11978.7 ± 0.3% | 3611.6 ± 0.1% | 3278.4 ± 0.4% | 509.5 ± 2.1% | 6075.0 ± 0.2% | 751.5 ± 2.1% | 3.317 | 3.654 | 23.509 | 1.972 | 15.940 |
| hex: http/json-1kx1024 | 2099200 | 8830.4 ± 3.8% | 3458.6 ± 0.5% | 2817.9 ± 0.5% | 575.2 ± 0.6% | 5021.6 ± 7.1% | 619.8 ± 18.1% | 2.553 | 3.134 | 15.351 | 1.758 | 14.247 |
| hex: http/json-16kx64 | 2097280 | 11753.6 ± 0.2% | 3606.8 ± 0.2% | 3257.4 ± 0.3% | 572.5 ± 0.4% | 6033.9 ± 0.5% | 744.2 ± 2.5% | 3.259 | 3.608 | 20.530 | 1.948 | 15.794 |
| hex: http/json-1m | 524290 | 11967.2 ± 0.3% | 3608.1 ± 0.4% | 3291.6 ± 0.4% | 595.9 ± 1.3% | 6062.3 ± 1.4% | 750.2 ± 3.3% | 3.317 | 3.636 | 20.084 | 1.974 | 15.953 |
| hex: http/js-1kx1024 | 2099200 | 8801.5 ± 3.1% | 3463.4 ± 0.1% | 2826.8 ± 0.6% | 482.5 ± 0.8% | 5035.6 ± 0.9% | 631.4 ± 4.9% | 2.541 | 3.114 | 18.240 | 1.748 | 13.940 |
| hex: http/js-16kx64 | 2097280 | 11759.2 ± 0.2% | 3608.5 ± 0.2% | 3254.3 ± 0.2% | 480.2 ± 0.9% | 6008.3 ± 0.7% | 732.8 ± 5.1% | 3.259 | 3.613 | 24.489 | 1.957 | 16.047 |
| hex: http/js-1m | 524290 | 12009.5 ± 0.1% | 3604.5 ± 0.2% | 3288.4 ± 0.2% | 509.4 ± 0.3% | 6112.4 ± 0.6% | 758.3 ± 2.4% | 3.332 | 3.652 | 23.578 | 1.965 | 15.837 |
| hex: http/css-1kx1024 | 2099200 | 8743.1 ± 4.3% | 3460.2 ± 0.2% | 2817.7 ± 0.3% | 488.9 ± 0.7% | 5029.2 ± 1.3% | 623.2 ± 1.8% | 2.527 | 3.103 | 17.882 | 1.738 | 14.029 |
| hex: http/css-16kx64 | 2097280 | 11758.5 ± 0.1% | 3606.6 ± 0.2% | 3250.2 ± 0.2% | 494.2 ± 1.2% | 6012.7 ± 0.5% | 742.6 ± 3.8% | 3.260 | 3.618 | 23.791 | 1.956 | 15.835 |
| hex: http/css-1m | 524290 | 11991.9 ± 0.2% | 3607.5 ± 0.1% | 3286.0 ± 0.2% | 503.0 ± 0.4% | 6076.6 ± 1.4% | 752.2 ± 3.2% | 3.324 | 3.649 | 23.842 | 1.973 | 15.943 |
| hex: shuffled/dickens-1m | 524290 | 11976.2 ± 0.2% | 3604.5 ± 0.2% | 3275.9 ± 0.2% | 514.1 ± 2.7% | 6032.9 ± 1.2% | 760.6 ± 0.6% | 3.323 | 3.656 | 23.297 | 1.985 | 15.746 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1344.3 ± 0.3% | 1243.0 ± 0.3% | 1030.0 ± 0.9% | 408.3 ± 0.5% | 446.9 ± 0.4% | 414.9 ± 0.4% | 1.082 | 1.305 | 3.292 | 3.008 | 3.240 |
| qlog records, JSON text sequence | 1467503 | 1051.9 ± 0.3% | 1065.6 ± 0.3% | 782.4 ± 0.9% | 377.0 ± 0.8% | 472.5 ± 1.3% | 278.9 ± 0.3% | 0.987 | 1.345 | 2.790 | 2.227 | 3.771 |
| string: silesia/dickens | 172528 | 6919.2 ± 0.6% | 2808.1 ± 0.4% | 2929.3 ± 1.1% | 429.9 ± 0.4% | 1594.1 ± 0.1% | 1011.6 ± 0.2% | 2.464 | 2.362 | 16.094 | 4.340 | 6.840 |
| string: silesia/nci | 1075110 | 7298.7 ± 0.3% | 3413.0 ± 0.7% | 3093.3 ± 0.4% | 814.8 ± 2.1% | 1858.9 ± 0.5% | 1107.7 ± 0.2% | 2.139 | 2.360 | 8.958 | 3.926 | 6.589 |
| string: silesia/reymont | 1075159 | 3355.2 ± 1.0% | 1973.6 ± 1.2% | 2057.9 ± 1.0% | 448.6 ± 1.2% | 1504.3 ± 0.4% | 948.5 ± 0.5% | 1.700 | 1.630 | 7.479 | 2.230 | 3.537 |
| string: silesia/samba | 97582 | 4209.6 ± 0.2% | 2113.2 ± 0.4% | 3450.0 ± 0.2% | 353.5 ± 0.6% | 1485.8 ± 0.3% | 1055.0 ± 0.3% | 1.992 | 1.220 | 11.908 | 2.833 | 3.990 |
| string: silesia/webster | 1098490 | 4062.6 ± 0.3% | 1866.2 ± 0.6% | 2049.3 ± 0.7% | 442.2 ± 0.7% | 1397.6 ± 0.5% | 647.3 ± 1.2% | 2.177 | 1.982 | 9.186 | 2.907 | 6.276 |
| string: silesia/xml | 1090118 | 6122.8 ± 0.5% | 2849.7 ± 0.6% | 2644.0 ± 0.4% | 609.4 ± 0.7% | 1756.7 ± 0.4% | 920.8 ± 0.3% | 2.149 | 2.316 | 10.047 | 3.485 | 6.649 |
| string: canterbury/alice29.txt | 159425 | 6456.4 ± 0.6% | 2194.6 ± 0.6% | 2752.0 ± 0.5% | 407.6 ± 0.9% | 1470.3 ± 0.3% | 954.9 ± 0.2% | 2.942 | 2.346 | 15.838 | 4.391 | 6.761 |
| string: canterbury/asyoulik.txt | 132198 | 5622.5 ± 1.5% | 1711.0 ± 0.5% | 2366.1 ± 1.2% | 401.9 ± 0.5% | 1328.7 ± 1.0% | 882.7 ± 0.2% | 3.286 | 2.376 | 13.988 | 4.232 | 6.370 |
| string: canterbury/lcet10.txt | 441884 | 6232.6 ± 0.3% | 2565.9 ± 1.1% | 2501.9 ± 1.0% | 467.5 ± 1.1% | 1551.7 ± 0.2% | 980.5 ± 0.6% | 2.429 | 2.491 | 13.332 | 4.017 | 6.357 |
| string: canterbury/plrabn12.txt | 503330 | 5728.9 ± 0.3% | 2060.9 ± 0.4% | 2070.5 ± 0.4% | 424.6 ± 0.5% | 1389.5 ± 0.2% | 926.6 ± 0.7% | 2.780 | 2.767 | 13.493 | 4.123 | 6.182 |
| string: canterbury-large/E.coli | 1048578 | 19221.4 ± 0.3% | 9715.3 ± 0.2% | 3787.2 ± 0.4% | 1471.4 ± 0.5% | 2356.4 ± 0.6% | 1191.0 ± 0.2% | 1.978 | 5.075 | 13.063 | 8.157 | 16.139 |
| string: canterbury-large/bible.txt | 1055886 | 6783.2 ± 0.2% | 4118.4 ± 1.3% | 3047.9 ± 1.9% | 504.3 ± 0.6% | 1982.4 ± 0.6% | 1119.8 ± 0.2% | 1.647 | 2.226 | 13.450 | 3.422 | 6.057 |
| string: canterbury-large/world192.txt | 1103121 | 4053.3 ± 0.4% | 1647.8 ± 0.4% | 1996.8 ± 0.6% | 448.3 ± 2.7% | 1371.0 ± 0.3% | 908.7 ± 0.3% | 2.460 | 2.030 | 9.042 | 2.956 | 4.460 |
| string: http/html-1m | 1058582 | 6752.0 ± 0.6% | 3943.1 ± 0.4% | 3033.6 ± 1.7% | 499.6 ± 0.6% | 1922.4 ± 0.5% | 803.7 ± 0.3% | 1.712 | 2.226 | 13.514 | 3.512 | 8.401 |
| string: http/json-1m | 1190272 | 3158.4 ± 0.6% | 1356.4 ± 0.3% | 1551.4 ± 0.7% | 443.6 ± 0.4% | 1072.3 ± 0.4% | 765.0 ± 1.5% | 2.328 | 2.036 | 7.119 | 2.945 | 4.128 |
| string: http/js-1m | 1144362 | 2759.3 ± 1.5% | 1174.8 ± 1.1% | 1626.4 ± 0.7% | 368.4 ± 0.6% | 1109.7 ± 0.8% | 756.4 ± 0.8% | 2.349 | 1.697 | 7.491 | 2.487 | 3.648 |
| string: http/css-1m | 1097820 | 3993.0 ± 0.7% | 1489.4 ± 0.3% | 2146.6 ± 1.0% | 493.0 ± 0.5% | 1378.9 ± 0.5% | 893.6 ± 0.2% | 2.681 | 1.860 | 8.099 | 2.896 | 4.469 |
| string: dickens as Cyrillic and CJK | 1883069 | 3065.8 ± 0.6% | 2336.4 ± 0.5% | 520.7 ± 0.3% | 306.7 ± 0.6% | 562.7 ± 0.9% | 336.0 ± 0.3% | 1.312 | 5.888 | 9.997 | 5.448 | 9.123 |
| hex: silesia/dickens | 524290 | 15653.2 ± 0.1% | 1463.5 ± 0.3% | 1081.0 ± 0.4% | 498.7 ± 1.2% | 986.4 ± 0.5% | 733.7 ± 0.5% | 10.696 | 14.480 | 31.390 | 15.869 | 21.334 |
| hex: silesia/mozilla | 524290 | 15591.0 ± 0.7% | 1473.1 ± 0.2% | 1088.4 ± 0.4% | 440.5 ± 3.0% | 988.9 ± 0.6% | 733.5 ± 0.3% | 10.584 | 14.325 | 35.396 | 15.767 | 21.257 |
| hex: silesia/mr | 524290 | 15652.3 ± 0.2% | 1479.6 ± 0.4% | 1091.4 ± 0.3% | 552.6 ± 3.2% | 994.9 ± 0.6% | 732.8 ± 0.4% | 10.579 | 14.341 | 28.326 | 15.733 | 21.359 |
| hex: silesia/nci | 524290 | 15615.9 ± 0.3% | 1468.6 ± 0.2% | 1087.7 ± 0.7% | 638.2 ± 2.2% | 988.2 ± 0.5% | 732.5 ± 0.5% | 10.633 | 14.356 | 24.469 | 15.803 | 21.318 |
| hex: silesia/ooffice | 524290 | 15615.2 ± 0.6% | 1462.8 ± 0.3% | 1081.5 ± 0.3% | 388.9 ± 0.4% | 989.3 ± 0.3% | 733.8 ± 0.4% | 10.675 | 14.439 | 40.153 | 15.785 | 21.281 |
| hex: silesia/osdb | 524290 | 15638.7 ± 0.3% | 1468.0 ± 0.2% | 1085.0 ± 0.2% | 468.6 ± 0.9% | 990.5 ± 0.6% | 732.9 ± 0.7% | 10.653 | 14.413 | 33.373 | 15.789 | 21.339 |
| hex: silesia/reymont | 524290 | 15544.0 ± 0.6% | 1461.6 ± 0.5% | 1083.4 ± 0.5% | 513.9 ± 1.5% | 986.4 ± 0.5% | 732.6 ± 0.5% | 10.635 | 14.348 | 30.245 | 15.758 | 21.217 |
| hex: silesia/samba | 524290 | 15615.5 ± 0.2% | 1463.6 ± 1.2% | 1081.5 ± 0.5% | 402.1 ± 0.4% | 986.9 ± 0.5% | 733.6 ± 0.8% | 10.669 | 14.439 | 38.832 | 15.823 | 21.287 |
| hex: silesia/sao | 524290 | 15678.9 ± 0.2% | 1464.6 ± 0.4% | 1084.3 ± 0.5% | 332.6 ± 0.5% | 987.6 ± 0.7% | 734.0 ± 0.3% | 10.706 | 14.461 | 47.134 | 15.875 | 21.362 |
| hex: silesia/webster | 524290 | 15637.0 ± 0.3% | 1461.8 ± 0.3% | 1081.5 ± 0.4% | 475.4 ± 0.1% | 986.2 ± 0.4% | 732.6 ± 0.3% | 10.697 | 14.459 | 32.890 | 15.856 | 21.346 |
| hex: silesia/x-ray | 524290 | 15565.8 ± 0.8% | 1474.3 ± 0.3% | 1087.6 ± 0.2% | 443.8 ± 0.3% | 990.6 ± 0.6% | 732.8 ± 0.4% | 10.558 | 14.312 | 35.071 | 15.713 | 21.240 |
| hex: silesia/xml | 524290 | 15618.2 ± 0.3% | 1466.0 ± 0.4% | 1084.5 ± 0.4% | 614.7 ± 1.1% | 986.4 ± 0.2% | 733.3 ± 0.8% | 10.654 | 14.401 | 25.407 | 15.834 | 21.298 |
| hex: canterbury/alice29.txt | 304180 | 15652.5 ± 0.2% | 1470.6 ± 0.4% | 1086.2 ± 0.3% | 503.2 ± 0.9% | 989.4 ± 0.3% | 733.9 ± 0.3% | 10.644 | 14.410 | 31.109 | 15.820 | 21.329 |
| hex: canterbury/asyoulik.txt | 250360 | 15719.9 ± 0.0% | 1468.5 ± 0.3% | 1091.1 ± 0.4% | 497.4 ± 1.2% | 992.4 ± 0.1% | 740.2 ± 0.2% | 10.705 | 14.408 | 31.607 | 15.841 | 21.237 |
| hex: canterbury/cp.html | 49208 | 15667.5 ± 0.0% | 1472.0 ± 0.3% | 1096.9 ± 0.1% | 526.2 ± 2.5% | 1000.7 ± 0.1% | 742.6 ± 0.1% | 10.644 | 14.283 | 29.772 | 15.656 | 21.099 |
| hex: canterbury/fields.c | 22302 | 15524.4 ± 0.1% | 1411.4 ± 0.4% | 1060.5 ± 0.3% | 632.7 ± 7.8% | 988.4 ± 0.1% | 736.4 ± 0.1% | 11.000 | 14.639 | 24.536 | 15.707 | 21.083 |
| hex: canterbury/grammar.lsp | 7444 | 15153.7 ± 0.1% | 1504.1 ± 0.1% | 1091.1 ± 0.3% | 670.5 ± 4.1% | 1001.7 ± 0.2% | 725.8 ± 0.1% | 10.075 | 13.889 | 22.602 | 15.128 | 20.880 |
| hex: canterbury/kennedy.xls | 524290 | 15660.0 ± 0.3% | 1469.1 ± 0.5% | 1088.3 ± 0.5% | 655.6 ± 3.3% | 986.2 ± 0.5% | 731.9 ± 0.9% | 10.659 | 14.389 | 23.885 | 15.879 | 21.395 |
| hex: canterbury/lcet10.txt | 524290 | 15614.2 ± 0.1% | 1464.1 ± 0.4% | 1083.3 ± 0.2% | 503.9 ± 1.2% | 988.7 ± 0.3% | 731.8 ± 0.7% | 10.665 | 14.414 | 30.985 | 15.793 | 21.337 |
| hex: canterbury/plrabn12.txt | 524290 | 15600.4 ± 0.8% | 1459.6 ± 0.3% | 1082.1 ± 0.5% | 493.5 ± 0.7% | 988.0 ± 0.3% | 733.0 ± 0.8% | 10.688 | 14.417 | 31.613 | 15.790 | 21.282 |
| hex: canterbury/ptt5 | 524290 | 15631.2 ± 0.2% | 1480.0 ± 0.2% | 1089.7 ± 0.6% | 553.4 ± 0.6% | 993.7 ± 0.3% | 733.1 ± 0.3% | 10.562 | 14.345 | 28.245 | 15.731 | 21.323 |
| hex: canterbury/sum | 76482 | 15678.6 ± 0.0% | 1494.5 ± 0.3% | 1103.9 ± 0.2% | 598.5 ± 1.6% | 998.2 ± 0.4% | 743.9 ± 0.1% | 10.491 | 14.203 | 26.197 | 15.707 | 21.076 |
| hex: canterbury/xargs.1 | 8456 | 15208.7 ± 0.1% | 1491.4 ± 1.2% | 1090.8 ± 0.6% | 650.5 ± 7.0% | 1001.7 ± 0.6% | 728.3 ± 0.1% | 10.198 | 13.943 | 23.382 | 15.182 | 20.883 |
| hex: canterbury-large/E.coli | 524290 | 15648.2 ± 0.5% | 1472.9 ± 0.1% | 1089.2 ± 0.4% | 671.9 ± 0.2% | 993.2 ± 0.4% | 732.7 ± 0.5% | 10.624 | 14.367 | 23.290 | 15.755 | 21.356 |
| hex: canterbury-large/bible.txt | 524290 | 15621.5 ± 0.7% | 1466.7 ± 0.4% | 1084.0 ± 0.4% | 513.2 ± 1.0% | 989.1 ± 0.4% | 730.7 ± 0.8% | 10.651 | 14.412 | 30.440 | 15.794 | 21.378 |
| hex: canterbury-large/world192.txt | 524290 | 15617.3 ± 0.4% | 1466.3 ± 0.2% | 1082.3 ± 0.6% | 504.1 ± 0.5% | 989.0 ± 0.3% | 732.5 ± 0.4% | 10.651 | 14.430 | 30.979 | 15.790 | 21.320 |
| hex: http/html-1kx1024 | 2099200 | 14174.7 ± 0.7% | 1453.8 ± 0.5% | 1061.4 ± 0.4% | 502.4 ± 0.3% | 985.2 ± 0.5% | 692.0 ± 0.2% | 9.750 | 13.355 | 28.213 | 14.388 | 20.484 |
| hex: http/html-16kx64 | 2097280 | 15335.7 ± 0.6% | 1450.4 ± 0.5% | 1074.5 ± 0.3% | 507.7 ± 0.4% | 995.7 ± 0.6% | 733.6 ± 0.1% | 10.574 | 14.273 | 30.208 | 15.402 | 20.905 |
| hex: http/html-1m | 524290 | 15606.2 ± 0.4% | 1464.2 ± 0.2% | 1083.3 ± 0.9% | 502.7 ± 1.0% | 988.1 ± 0.5% | 732.7 ± 0.4% | 10.659 | 14.406 | 31.043 | 15.794 | 21.300 |
| hex: http/json-1kx1024 | 2099200 | 14153.1 ± 1.0% | 1461.9 ± 0.2% | 1066.0 ± 0.1% | 609.2 ± 0.3% | 986.0 ± 0.2% | 692.4 ± 0.1% | 9.681 | 13.277 | 23.231 | 14.354 | 20.442 |
| hex: http/json-16kx64 | 2097280 | 15276.2 ± 1.1% | 1446.2 ± 0.6% | 1073.9 ± 0.1% | 619.2 ± 0.8% | 991.5 ± 2.9% | 734.5 ± 0.7% | 10.563 | 14.225 | 24.671 | 15.407 | 20.797 |
| hex: http/json-1m | 524290 | 15638.6 ± 0.2% | 1475.6 ± 0.4% | 1085.7 ± 0.5% | 636.7 ± 0.3% | 990.8 ± 0.3% | 731.9 ± 0.5% | 10.598 | 14.404 | 24.563 | 15.784 | 21.367 |
| hex: http/js-1kx1024 | 2099200 | 14109.9 ± 1.1% | 1455.6 ± 0.4% | 1063.7 ± 0.2% | 499.3 ± 0.3% | 984.6 ± 0.3% | 692.6 ± 0.1% | 9.693 | 13.265 | 28.257 | 14.330 | 20.372 |
| hex: http/js-16kx64 | 2097280 | 15364.2 ± 0.2% | 1441.4 ± 0.3% | 1073.3 ± 0.1% | 504.8 ± 0.5% | 995.4 ± 0.3% | 733.7 ± 0.2% | 10.659 | 14.315 | 30.438 | 15.435 | 20.939 |
| hex: http/js-1m | 524290 | 15617.8 ± 0.2% | 1463.5 ± 0.5% | 1080.1 ± 0.5% | 511.7 ± 0.6% | 985.2 ± 0.8% | 732.6 ± 0.6% | 10.671 | 14.460 | 30.524 | 15.852 | 21.319 |
| hex: http/css-1kx1024 | 2099200 | 14061.1 ± 0.9% | 1454.1 ± 0.2% | 1061.8 ± 0.1% | 531.6 ± 0.3% | 982.5 ± 0.1% | 692.6 ± 0.1% | 9.670 | 13.242 | 26.451 | 14.312 | 20.303 |
| hex: http/css-16kx64 | 2097280 | 15292.0 ± 0.4% | 1438.7 ± 0.3% | 1073.7 ± 0.1% | 541.2 ± 0.7% | 994.1 ± 0.7% | 734.3 ± 0.2% | 10.629 | 14.243 | 28.254 | 15.383 | 20.824 |
| hex: http/css-1m | 524290 | 15658.4 ± 3.3% | 1465.1 ± 0.3% | 1081.7 ± 0.6% | 527.7 ± 0.8% | 985.3 ± 0.3% | 732.6 ± 0.5% | 10.687 | 14.476 | 29.672 | 15.892 | 21.373 |
| hex: shuffled/dickens-1m | 524290 | 15688.3 ± 0.2% | 1463.8 ± 0.2% | 1085.1 ± 0.5% | 499.3 ± 1.6% | 985.9 ± 0.8% | 734.4 ± 0.7% | 10.718 | 14.459 | 31.422 | 15.913 | 21.362 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.925 of yyjson.
