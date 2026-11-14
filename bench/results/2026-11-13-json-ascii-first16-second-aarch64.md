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
| Run URL | https://github.com/c4milo/stdx/actions/runs/43483803369 |
| Date | 2026-11-13 |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1. The `TextReader.next_items` column is that helper's queued tokens a slice a call (decision 79), over many tokens a call.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | TextReader.next_items | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1128.2 ± 0.4% | 0.523 | 0.966 | 0.996 | 0.996 | 0.457 | 1.002 | 1.005 | 0.383 | 0.830 | 0.898 | 0.101 |
| qlog records, JSON text sequence | 1467503 | 833.9 ± 2.9% | 0.833 | 1.017 | 1.016 | 1.016 | 0.453 | 1.007 | 1.046 | 0.396 | 0.932 | 1.003 | 0.127 |
| string: silesia/dickens | 172528 | 5047.3 ± 0.3% | 0.033 | 0.781 | 1.003 | 1.003 | 0.196 | 1.018 | 1.005 | 0.196 | 1.001 | 1.001 | 0.032 |
| string: silesia/nci | 1075110 | 4298.5 ± 0.3% | 0.038 | 0.800 | 1.003 | 1.003 | 0.277 | 1.005 | 0.997 | 0.280 | 1.000 | 1.001 | 0.038 |
| string: silesia/reymont | 1075159 | 2935.2 ± 1.8% | 0.057 | 0.817 | 0.998 | 1.003 | 0.359 | 1.004 | 1.012 | 0.359 | 1.020 | 1.020 | 0.056 |
| string: silesia/samba | 97582 | 3495.2 ± 0.5% | 0.041 | 0.862 | 1.004 | 1.005 | 0.070 | 0.778 | 1.010 | 0.067 | 1.001 | 1.004 | 0.040 |
| string: silesia/webster | 1098490 | 3641.1 ± 0.8% | 0.044 | 0.848 | 1.004 | 1.006 | 0.204 | 1.018 | 1.014 | 0.203 | 1.008 | 1.009 | 0.044 |
| string: silesia/xml | 1090118 | 4774.7 ± 0.6% | 0.035 | 0.807 | 1.006 | 1.007 | 0.222 | 0.982 | 1.009 | 0.220 | 1.008 | 1.009 | 0.034 |
| string: canterbury/alice29.txt | 159425 | 4312.9 ± 0.1% | 0.038 | 0.750 | 1.002 | 1.006 | 0.171 | 1.027 | 1.020 | 0.171 | 1.008 | 1.009 | 0.037 |
| string: canterbury/asyoulik.txt | 132198 | 3464.1 ± 0.8% | 0.045 | 0.747 | 1.005 | 1.007 | 0.175 | 1.004 | 0.969 | 0.175 | 1.013 | 1.013 | 0.045 |
| string: canterbury/lcet10.txt | 441884 | 5074.4 ± 0.5% | 0.033 | 0.817 | 1.007 | 1.007 | 0.197 | 1.027 | 1.015 | 0.196 | 1.008 | 1.008 | 0.032 |
| string: canterbury/plrabn12.txt | 503330 | 4107.1 ± 0.4% | 0.040 | 0.825 | 1.004 | 1.003 | 0.198 | 1.013 | 0.999 | 0.198 | 1.005 | 1.004 | 0.039 |
| string: canterbury-large/E.coli | 1048578 | 19156.6 ± 2.5% | 0.077 | 1.007 | 1.002 | 1.003 | 0.481 | 1.007 | 1.008 | 0.481 | 0.621 | 0.622 | 0.009 |
| string: canterbury-large/bible.txt | 1055886 | 6689.6 ± 1.3% | 0.026 | 0.803 | 1.002 | 1.004 | 0.432 | 1.027 | 1.040 | 0.432 | 1.032 | 1.035 | 0.025 |
| string: canterbury-large/world192.txt | 1103121 | 3374.9 ± 0.5% | 0.048 | 0.848 | 1.003 | 1.005 | 0.198 | 1.018 | 1.009 | 0.198 | 1.007 | 1.006 | 0.047 |
| string: http/html-1m | 1058582 | 6043.6 ± 0.6% | 0.028 | 0.783 | 1.023 | 1.043 | 0.389 | 1.043 | 1.055 | 0.390 | 1.027 | 1.030 | 0.028 |
| string: http/json-1m | 1190272 | 2552.4 ± 0.5% | 0.055 | 0.947 | 1.000 | 1.002 | 0.109 | 1.003 | 0.470 | 0.110 | 1.003 | 1.002 | 0.055 |
| string: http/js-1m | 1144362 | 2285.7 ± 0.8% | 0.066 | 0.889 | 0.999 | 0.998 | 0.174 | 1.055 | 1.044 | 0.174 | 0.999 | 1.001 | 0.065 |
| string: http/css-1m | 1097820 | 2636.0 ± 0.6% | 0.060 | 0.775 | 1.006 | 1.008 | 0.238 | 1.007 | 1.015 | 0.240 | 1.008 | 1.010 | 0.060 |
| string: dickens as Cyrillic and CJK | 1883069 | 3066.8 ± 0.4% | 0.044 | 0.125 | 1.001 | 1.005 | 0.335 | 1.001 | 1.008 | 0.335 | 1.003 | 1.003 | 0.044 |
| string: dickens as Cyrillic and CJK, as \u escapes | 5075485 | 1327.2 ± 2.0% | 0.086 | 1.003 | 1.001 | 1.002 | 0.078 | 0.637 | 1.005 | 0.075 | 1.003 | 1.002 | 0.084 |
| hex: silesia/dickens | 524290 | 18414.6 ± 1.0% | 0.081 | 0.996 | 0.994 | 0.992 | 0.516 | 0.986 | 0.989 | 0.518 | 0.650 | 0.651 | 0.009 |
| hex: silesia/mozilla | 524290 | 18361.5 ± 1.1% | 0.081 | 0.998 | 0.995 | 0.994 | 0.518 | 0.997 | 0.997 | 0.520 | 0.651 | 0.651 | 0.009 |
| hex: silesia/mr | 524290 | 18035.5 ± 0.7% | 0.082 | 1.010 | 1.007 | 1.007 | 0.533 | 1.008 | 1.003 | 0.534 | 0.664 | 0.663 | 0.010 |
| hex: silesia/nci | 524290 | 18397.5 ± 1.4% | 0.081 | 0.999 | 0.999 | 0.999 | 0.526 | 0.998 | 0.998 | 0.526 | 0.653 | 0.653 | 0.009 |
| hex: silesia/ooffice | 524290 | 18718.3 ± 0.8% | 0.080 | 0.999 | 0.993 | 0.996 | 0.518 | 0.984 | 0.986 | 0.517 | 0.642 | 0.642 | 0.009 |
| hex: silesia/osdb | 524290 | 18463.6 ± 0.9% | 0.080 | 0.992 | 0.987 | 0.988 | 0.518 | 0.995 | 0.988 | 0.518 | 0.650 | 0.650 | 0.009 |
| hex: silesia/reymont | 524290 | 18576.4 ± 2.3% | 0.080 | 1.007 | 0.995 | 0.984 | 0.509 | 0.991 | 0.986 | 0.508 | 0.645 | 0.646 | 0.009 |
| hex: silesia/samba | 524290 | 18075.2 ± 0.2% | 0.082 | 1.000 | 1.006 | 1.005 | 0.522 | 1.006 | 1.007 | 0.522 | 0.662 | 0.661 | 0.010 |
| hex: silesia/sao | 524290 | 18382.7 ± 0.5% | 0.081 | 1.004 | 0.994 | 0.997 | 0.516 | 0.996 | 0.993 | 0.513 | 0.651 | 0.651 | 0.009 |
| hex: silesia/webster | 524290 | 18609.3 ± 0.6% | 0.080 | 1.003 | 0.994 | 0.988 | 0.524 | 0.989 | 0.994 | 0.523 | 0.644 | 0.644 | 0.009 |
| hex: silesia/x-ray | 524290 | 18253.6 ± 2.0% | 0.082 | 1.010 | 1.003 | 1.003 | 0.534 | 1.004 | 1.001 | 0.535 | 0.658 | 0.658 | 0.009 |
| hex: silesia/xml | 524290 | 18321.3 ± 0.8% | 0.081 | 1.009 | 0.998 | 0.995 | 0.522 | 0.998 | 0.994 | 0.519 | 0.654 | 0.654 | 0.009 |
| hex: canterbury/alice29.txt | 304180 | 19515.9 ± 0.4% | 0.077 | 1.002 | 1.002 | 1.002 | 0.515 | 1.002 | 1.001 | 0.515 | 0.615 | 0.615 | 0.009 |
| hex: canterbury/asyoulik.txt | 250360 | 19505.7 ± 0.2% | 0.077 | 1.002 | 1.002 | 1.003 | 0.514 | 1.003 | 1.002 | 0.514 | 0.615 | 0.616 | 0.009 |
| hex: canterbury/cp.html | 49208 | 19309.6 ± 0.1% | 0.082 | 1.001 | 1.000 | 0.999 | 0.541 | 1.001 | 1.001 | 0.542 | 0.618 | 0.618 | 0.009 |
| hex: canterbury/fields.c | 22302 | 18862.6 ± 1.4% | 0.084 | 1.006 | 1.006 | 1.006 | 0.534 | 1.005 | 1.006 | 0.540 | 0.625 | 0.625 | 0.009 |
| hex: canterbury/grammar.lsp | 7444 | 17478.6 ± 1.0% | 0.089 | 1.009 | 1.009 | 1.009 | 0.528 | 1.007 | 1.008 | 0.546 | 0.646 | 0.648 | 0.010 |
| hex: canterbury/kennedy.xls | 524290 | 18241.6 ± 1.3% | 0.081 | 1.013 | 1.007 | 1.005 | 0.517 | 1.004 | 1.004 | 0.520 | 0.658 | 0.658 | 0.009 |
| hex: canterbury/lcet10.txt | 524290 | 18591.3 ± 0.6% | 0.080 | 0.992 | 1.001 | 1.002 | 0.527 | 0.999 | 0.999 | 0.530 | 0.646 | 0.646 | 0.009 |
| hex: canterbury/plrabn12.txt | 524290 | 18481.4 ± 0.8% | 0.081 | 1.002 | 0.995 | 0.992 | 0.533 | 0.998 | 0.989 | 0.536 | 0.649 | 0.650 | 0.009 |
| hex: canterbury/ptt5 | 524290 | 18210.1 ± 0.4% | 0.082 | 1.003 | 0.998 | 0.998 | 0.525 | 1.002 | 0.998 | 0.526 | 0.657 | 0.657 | 0.009 |
| hex: canterbury/sum | 76482 | 19285.5 ± 0.1% | 0.078 | 1.001 | 1.002 | 1.002 | 0.519 | 1.001 | 1.001 | 0.520 | 0.618 | 0.618 | 0.009 |
| hex: canterbury/xargs.1 | 8456 | 17831.8 ± 1.1% | 0.087 | 1.002 | 1.002 | 1.003 | 0.524 | 1.001 | 1.002 | 0.541 | 0.637 | 0.637 | 0.010 |
| hex: canterbury-large/E.coli | 524290 | 18305.6 ± 0.9% | 0.081 | 1.028 | 1.009 | 1.006 | 0.519 | 1.006 | 1.010 | 0.522 | 0.655 | 0.655 | 0.009 |
| hex: canterbury-large/bible.txt | 524290 | 18671.8 ± 0.9% | 0.080 | 1.002 | 0.995 | 0.982 | 0.517 | 0.985 | 0.976 | 0.516 | 0.643 | 0.643 | 0.009 |
| hex: canterbury-large/world192.txt | 524290 | 18324.8 ± 1.0% | 0.081 | 1.000 | 0.999 | 0.998 | 0.524 | 0.990 | 0.999 | 0.525 | 0.656 | 0.656 | 0.009 |
| hex: http/html-1kx1024 | 2099200 | 9064.2 ± 14.6% | 0.157 | 1.279 | 1.294 | 1.294 | 0.724 | 1.297 | 0.991 | 0.794 | 0.961 | 0.969 | 0.019 |
| hex: http/html-16kx64 | 2097280 | 17751.4 ± 1.4% | 0.084 | 1.023 | 1.020 | 1.020 | 0.577 | 1.022 | 0.986 | 0.582 | 0.663 | 0.663 | 0.010 |
| hex: http/html-1m | 524290 | 18404.8 ± 2.1% | 0.081 | 1.007 | 0.994 | 0.993 | 0.532 | 0.990 | 0.990 | 0.532 | 0.652 | 0.652 | 0.009 |
| hex: http/json-1kx1024 | 2099200 | 9244.4 ± 17.1% | 0.154 | 1.274 | 1.273 | 1.273 | 0.711 | 1.266 | 0.970 | 0.773 | 0.940 | 0.951 | 0.019 |
| hex: http/json-16kx64 | 2097280 | 17981.5 ± 1.0% | 0.084 | 1.013 | 1.013 | 1.013 | 0.570 | 1.011 | 0.977 | 0.575 | 0.655 | 0.655 | 0.010 |
| hex: http/json-1m | 524290 | 18338.5 ± 0.6% | 0.081 | 1.004 | 0.999 | 0.999 | 0.533 | 1.000 | 0.999 | 0.533 | 0.656 | 0.656 | 0.009 |
| hex: http/js-1kx1024 | 2099200 | 9312.8 ± 16.2% | 0.153 | 1.278 | 1.269 | 1.262 | 0.709 | 1.271 | 0.973 | 0.776 | 0.938 | 0.952 | 0.018 |
| hex: http/js-16kx64 | 2097280 | 17748.7 ± 0.6% | 0.084 | 1.022 | 1.020 | 1.018 | 0.575 | 1.017 | 0.987 | 0.578 | 0.662 | 0.663 | 0.010 |
| hex: http/js-1m | 524290 | 18348.6 ± 0.8% | 0.081 | 1.015 | 1.015 | 1.005 | 0.514 | 1.010 | 1.006 | 0.514 | 0.650 | 0.650 | 0.009 |
| hex: http/css-1kx1024 | 2099200 | 9359.3 ± 17.0% | 0.152 | 1.260 | 1.262 | 1.267 | 0.700 | 1.263 | 0.965 | 0.771 | 0.930 | 0.941 | 0.018 |
| hex: http/css-16kx64 | 2097280 | 17857.8 ± 0.7% | 0.084 | 1.020 | 1.017 | 1.016 | 0.573 | 1.017 | 0.983 | 0.577 | 0.659 | 0.659 | 0.010 |
| hex: http/css-1m | 524290 | 18585.3 ± 2.2% | 0.080 | 1.014 | 1.007 | 1.001 | 0.510 | 1.001 | 1.010 | 0.508 | 0.644 | 0.644 | 0.009 |
| hex: shuffled/dickens-1m | 524290 | 18027.7 ± 1.4% | 0.082 | 1.010 | 1.009 | 1.009 | 0.529 | 1.004 | 1.005 | 0.527 | 0.664 | 0.665 | 0.010 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1481.4 ± 0.9% | 0.445 | 1.002 | 0.969 | 1.006 | 1.009 | 0.267 | 1.000 | 0.548 | 0.916 | 0.089 | 1.031 |
| qlog records, JSON text sequence | 1467503 | 1272.5 ± 1.1% | 0.684 | 0.973 | 1.007 | 1.009 | 1.009 | 0.264 | 0.998 | 0.502 | 0.828 | 0.105 | 1.015 |
| string: silesia/dickens | 172528 | 6909.2 ± 0.9% | 0.025 | 1.000 | 0.999 | 0.999 | 1.000 | 0.165 | 0.715 | 1.002 | 1.002 | 0.025 | 1.033 |
| string: silesia/nci | 1075110 | 7302.7 ± 0.2% | 0.024 | 0.999 | 1.001 | 1.000 | 0.998 | 0.209 | 0.565 | 0.998 | 1.001 | 0.023 | 1.009 |
| string: silesia/reymont | 1075159 | 3339.6 ± 1.5% | 0.052 | 0.999 | 0.999 | 0.999 | 1.005 | 0.386 | 0.869 | 0.995 | 0.993 | 0.051 | 1.043 |
| string: silesia/samba | 97582 | 4184.3 ± 1.0% | 0.053 | 1.004 | 1.001 | 1.006 | 1.007 | 0.125 | 0.949 | 1.004 | 1.006 | 0.053 | 1.093 |
| string: silesia/webster | 1098490 | 4046.3 ± 0.5% | 0.044 | 1.010 | 1.009 | 1.009 | 1.009 | 0.211 | 0.890 | 1.003 | 1.008 | 0.042 | 1.013 |
| string: silesia/xml | 1090118 | 6103.8 ± 0.7% | 0.029 | 1.006 | 0.998 | 1.004 | 1.006 | 0.253 | 0.777 | 1.003 | 1.005 | 0.029 | 1.021 |
| string: canterbury/alice29.txt | 159425 | 6382.9 ± 1.4% | 0.027 | 1.011 | 1.011 | 1.015 | 1.017 | 0.132 | 0.658 | 1.008 | 1.011 | 0.027 | 1.070 |
| string: canterbury/asyoulik.txt | 132198 | 5582.6 ± 0.7% | 0.030 | 1.023 | 1.029 | 1.032 | 1.034 | 0.129 | 0.597 | 1.006 | 1.013 | 0.030 | 1.061 |
| string: canterbury/lcet10.txt | 441884 | 6252.4 ± 0.6% | 0.028 | 1.004 | 1.005 | 1.006 | 1.006 | 0.183 | 0.799 | 1.002 | 1.004 | 0.028 | 1.001 |
| string: canterbury/plrabn12.txt | 503330 | 5707.4 ± 0.4% | 0.030 | 1.003 | 1.000 | 1.004 | 1.002 | 0.167 | 0.699 | 1.002 | 1.003 | 0.030 | 1.006 |
| string: canterbury-large/E.coli | 1048578 | 19180.2 ± 0.7% | 0.078 | 1.001 | 0.998 | 0.999 | 1.001 | 0.482 | 0.997 | 0.998 | 0.999 | 0.009 | 0.999 |
| string: canterbury-large/bible.txt | 1055886 | 6786.2 ± 0.7% | 0.026 | 1.001 | 1.001 | 1.001 | 1.003 | 0.493 | 0.970 | 1.001 | 1.002 | 0.026 | 1.002 |
| string: canterbury-large/world192.txt | 1103121 | 4018.3 ± 0.7% | 0.043 | 1.016 | 1.016 | 1.020 | 1.017 | 0.192 | 0.831 | 1.001 | 1.010 | 0.042 | 1.005 |
| string: http/html-1m | 1058582 | 6752.0 ± 0.6% | 0.026 | 1.005 | 0.923 | 1.004 | 1.005 | 0.401 | 0.889 | 1.000 | 1.003 | 0.026 | 1.008 |
| string: http/json-1m | 1190272 | 3160.4 ± 0.3% | 0.051 | 1.000 | 0.967 | 0.999 | 1.001 | 0.132 | 0.371 | 1.002 | 1.002 | 0.050 | 1.042 |
| string: http/js-1m | 1144362 | 2765.3 ± 1.1% | 0.060 | 1.002 | 1.007 | 1.000 | 1.004 | 0.163 | 0.837 | 0.998 | 1.002 | 0.060 | 1.012 |
| string: http/css-1m | 1097820 | 3979.8 ± 0.9% | 0.043 | 1.009 | 1.005 | 1.008 | 1.010 | 0.206 | 0.644 | 1.000 | 1.009 | 0.043 | 1.012 |
| string: dickens as Cyrillic and CJK | 1883069 | 3069.9 ± 0.3% | 0.048 | 1.001 | 0.124 | 1.000 | 1.000 | 0.319 | 1.002 | 0.999 | 1.001 | 0.048 | 1.002 |
| hex: silesia/dickens | 524290 | 15635.9 ± 0.4% | 1.001 | 0.179 | 1.001 | 1.002 | 1.002 | 1.002 | 1.002 | 1.003 | 1.002 | 0.178 | 1.002 |
| hex: silesia/mozilla | 524290 | 15689.9 ± 0.2% | 1.000 | 0.178 | 0.998 | 0.999 | 0.999 | 0.998 | 0.999 | 0.998 | 0.998 | 0.178 | 0.998 |
| hex: silesia/mr | 524290 | 15642.2 ± 0.5% | 1.000 | 0.179 | 0.996 | 0.999 | 0.998 | 0.998 | 1.000 | 0.999 | 0.994 | 0.178 | 0.998 |
| hex: silesia/nci | 524290 | 15680.9 ± 0.2% | 1.000 | 0.178 | 1.000 | 1.001 | 1.000 | 1.000 | 1.000 | 1.001 | 1.001 | 0.177 | 0.999 |
| hex: silesia/ooffice | 524290 | 15631.2 ± 0.2% | 1.001 | 0.178 | 1.001 | 1.000 | 0.999 | 0.998 | 0.997 | 0.995 | 0.996 | 0.178 | 0.998 |
| hex: silesia/osdb | 524290 | 15616.9 ± 0.6% | 1.001 | 0.179 | 1.001 | 1.001 | 1.001 | 0.999 | 0.999 | 1.000 | 0.999 | 0.178 | 0.999 |
| hex: silesia/reymont | 524290 | 15640.7 ± 0.2% | 1.000 | 0.178 | 1.001 | 0.999 | 1.001 | 0.999 | 1.000 | 0.999 | 0.999 | 0.177 | 1.002 |
| hex: silesia/samba | 524290 | 15658.2 ± 0.2% | 1.001 | 0.177 | 1.001 | 1.001 | 1.000 | 1.000 | 0.999 | 0.999 | 0.998 | 0.178 | 0.999 |
| hex: silesia/sao | 524290 | 15620.6 ± 0.2% | 0.999 | 0.177 | 0.999 | 0.999 | 0.997 | 0.996 | 0.998 | 0.997 | 0.996 | 0.178 | 0.997 |
| hex: silesia/webster | 524290 | 15675.4 ± 0.3% | 1.001 | 0.177 | 1.000 | 0.998 | 0.998 | 0.995 | 0.997 | 0.997 | 0.997 | 0.178 | 0.998 |
| hex: silesia/x-ray | 524290 | 15606.6 ± 0.4% | 1.002 | 0.179 | 1.002 | 1.002 | 1.002 | 0.999 | 1.000 | 0.997 | 1.000 | 0.179 | 1.000 |
| hex: silesia/xml | 524290 | 15661.7 ± 0.1% | 1.001 | 0.178 | 1.000 | 1.001 | 1.000 | 0.999 | 0.999 | 0.999 | 0.998 | 0.178 | 1.000 |
| hex: canterbury/alice29.txt | 304180 | 15690.9 ± 0.4% | 1.000 | 0.178 | 1.000 | 1.000 | 1.000 | 1.000 | 1.001 | 1.001 | 1.001 | 0.177 | 1.001 |
| hex: canterbury/asyoulik.txt | 250360 | 15709.8 ± 0.1% | 1.001 | 0.178 | 1.000 | 1.000 | 1.001 | 1.000 | 1.001 | 1.000 | 1.001 | 0.178 | 1.001 |
| hex: canterbury/cp.html | 49208 | 15623.3 ± 0.2% | 1.001 | 0.179 | 1.000 | 1.000 | 1.000 | 0.998 | 1.000 | 1.001 | 1.003 | 0.179 | 1.001 |
| hex: canterbury/fields.c | 22302 | 15436.0 ± 0.1% | 1.002 | 0.181 | 1.000 | 1.000 | 1.000 | 0.994 | 1.001 | 1.002 | 1.006 | 0.180 | 1.001 |
| hex: canterbury/grammar.lsp | 7444 | 14938.4 ± 0.1% | 1.003 | 0.186 | 1.001 | 1.000 | 1.000 | 0.983 | 1.000 | 1.004 | 1.015 | 0.184 | 1.003 |
| hex: canterbury/kennedy.xls | 524290 | 15577.1 ± 0.3% | 1.002 | 0.179 | 1.001 | 1.002 | 1.001 | 0.999 | 0.998 | 1.001 | 0.999 | 0.179 | 1.000 |
| hex: canterbury/lcet10.txt | 524290 | 15638.5 ± 0.3% | 1.002 | 0.178 | 1.000 | 1.001 | 1.001 | 1.000 | 1.000 | 1.001 | 1.000 | 0.178 | 1.001 |
| hex: canterbury/plrabn12.txt | 524290 | 15636.2 ± 0.3% | 1.002 | 0.178 | 1.003 | 1.001 | 1.001 | 1.000 | 1.002 | 1.003 | 1.002 | 0.177 | 1.002 |
| hex: canterbury/ptt5 | 524290 | 15595.2 ± 0.4% | 0.999 | 0.179 | 1.002 | 1.000 | 1.001 | 1.003 | 1.003 | 0.999 | 1.001 | 0.179 | 0.999 |
| hex: canterbury/sum | 76482 | 15637.3 ± 0.1% | 1.002 | 0.179 | 1.001 | 1.001 | 1.001 | 0.999 | 1.001 | 1.001 | 1.003 | 0.178 | 1.001 |
| hex: canterbury/xargs.1 | 8456 | 14994.4 ± 0.2% | 1.002 | 0.185 | 1.000 | 1.000 | 1.000 | 0.986 | 1.001 | 1.004 | 1.014 | 0.183 | 1.002 |
| hex: canterbury-large/E.coli | 524290 | 15683.1 ± 0.1% | 1.001 | 0.178 | 1.002 | 1.001 | 1.002 | 1.000 | 1.000 | 1.001 | 1.002 | 0.178 | 1.002 |
| hex: canterbury-large/bible.txt | 524290 | 15641.6 ± 0.1% | 1.000 | 0.178 | 0.999 | 1.001 | 1.000 | 0.997 | 0.999 | 0.999 | 0.999 | 0.177 | 0.997 |
| hex: canterbury-large/world192.txt | 524290 | 15643.7 ± 0.3% | 1.001 | 0.178 | 1.000 | 0.998 | 0.999 | 0.999 | 0.997 | 0.998 | 0.998 | 0.178 | 0.999 |
| hex: http/html-1kx1024 | 2099200 | 13626.9 ± 0.5% | 1.008 | 0.196 | 1.005 | 1.002 | 1.002 | 0.940 | 1.000 | 1.012 | 1.038 | 0.189 | 1.011 |
| hex: http/html-16kx64 | 2097280 | 15154.0 ± 0.7% | 1.001 | 0.182 | 1.002 | 1.002 | 1.001 | 0.993 | 1.001 | 1.004 | 1.012 | 0.181 | 1.000 |
| hex: http/html-1m | 524290 | 15653.8 ± 0.2% | 1.001 | 0.178 | 1.001 | 1.000 | 1.002 | 0.994 | 0.997 | 0.999 | 0.999 | 0.178 | 1.001 |
| hex: http/json-1kx1024 | 2099200 | 13705.1 ± 0.4% | 1.006 | 0.195 | 0.991 | 1.000 | 1.000 | 0.932 | 0.996 | 1.007 | 1.030 | 0.187 | 1.007 |
| hex: http/json-16kx64 | 2097280 | 15294.2 ± 0.3% | 1.000 | 0.180 | 0.998 | 0.999 | 1.000 | 0.992 | 1.001 | 1.003 | 1.003 | 0.180 | 1.001 |
| hex: http/json-1m | 524290 | 15671.9 ± 0.3% | 0.998 | 0.178 | 1.001 | 1.000 | 1.000 | 0.996 | 0.999 | 0.995 | 0.994 | 0.178 | 0.998 |
| hex: http/js-1kx1024 | 2099200 | 13621.8 ± 0.3% | 1.006 | 0.197 | 1.002 | 1.002 | 1.001 | 0.942 | 1.000 | 1.011 | 1.038 | 0.188 | 1.010 |
| hex: http/js-16kx64 | 2097280 | 15161.4 ± 0.7% | 1.003 | 0.182 | 1.003 | 0.998 | 0.998 | 0.996 | 1.001 | 1.007 | 1.013 | 0.182 | 1.004 |
| hex: http/js-1m | 524290 | 15654.0 ± 0.3% | 1.001 | 0.177 | 1.001 | 1.000 | 1.001 | 0.999 | 1.000 | 1.000 | 1.002 | 0.177 | 1.001 |
| hex: http/css-1kx1024 | 2099200 | 13639.9 ± 0.3% | 1.007 | 0.196 | 1.003 | 0.999 | 1.000 | 0.941 | 0.999 | 1.014 | 1.038 | 0.187 | 1.009 |
| hex: http/css-16kx64 | 2097280 | 15191.3 ± 0.5% | 1.001 | 0.181 | 1.000 | 1.001 | 1.002 | 0.996 | 1.000 | 1.000 | 1.009 | 0.180 | 1.005 |
| hex: http/css-1m | 524290 | 15688.3 ± 0.2% | 1.000 | 0.177 | 1.002 | 1.001 | 1.000 | 1.000 | 1.000 | 0.999 | 1.000 | 0.177 | 1.001 |
| hex: shuffled/dickens-1m | 524290 | 15689.9 ± 0.3% | 1.001 | 0.178 | 1.001 | 1.000 | 1.000 | 0.999 | 1.000 | 1.000 | 1.001 | 0.177 | 1.001 |

## Losses

Each workload where a claim's path ran slower than the path it replaces by more than the noise floor of decision 20.

- string: http/html-1m, decoding: J13 decoder escape blocks off runs at 1.055 of all on.
- string: http/js-1m, decoding: J12 decoder escape words off runs at 1.055 of all on.
- hex: http/html-1kx1024, decoding: J5 UTF-8 vectors off runs at 1.279 of all on.
- hex: http/html-1kx1024, decoding: J7 wide vectors off runs at 1.294 of all on.
- hex: http/html-1kx1024, decoding: J8 decoder fast path off runs at 1.294 of all on.
- hex: http/html-1kx1024, decoding: J12 decoder escape words off runs at 1.297 of all on.
- hex: http/json-1kx1024, decoding: J5 UTF-8 vectors off runs at 1.274 of all on.
- hex: http/json-1kx1024, decoding: J7 wide vectors off runs at 1.273 of all on.
- hex: http/json-1kx1024, decoding: J8 decoder fast path off runs at 1.273 of all on.
- hex: http/json-1kx1024, decoding: J12 decoder escape words off runs at 1.266 of all on.
- hex: http/js-1kx1024, decoding: J5 UTF-8 vectors off runs at 1.278 of all on.
- hex: http/js-1kx1024, decoding: J7 wide vectors off runs at 1.269 of all on.
- hex: http/js-1kx1024, decoding: J8 decoder fast path off runs at 1.262 of all on.
- hex: http/js-1kx1024, decoding: J12 decoder escape words off runs at 1.271 of all on.
- hex: http/css-1kx1024, decoding: J5 UTF-8 vectors off runs at 1.260 of all on.
- hex: http/css-1kx1024, decoding: J7 wide vectors off runs at 1.262 of all on.
- hex: http/css-1kx1024, decoding: J8 decoder fast path off runs at 1.267 of all on.
- hex: http/css-1kx1024, decoding: J12 decoder escape words off runs at 1.263 of all on.

## UTF-8 validation against simdutf

stdx's `is_utf8`, the check the loops apply to every string's octets, run alone over each string workload's octets at the width the host's features pick (16 lanes on aarch64, AVX2's 32 or AVX-512's 64 on x86-64, decision 39), beside simdutf 9.3.3's `validate_utf8` in the same run; on a host with AVX-512, again with AVX2 alone. Each ratio is stdx's throughput over the other's. simdutf picks its kernel at run time. Before timing, every copy of the check and simdutf judged 20000 seeded buffers and each workload, whole and changed, alike.

| Workload | Octets | stdx, MB/s | simdutf, MB/s | stdx / simdutf | stdx with AVX2 alone, MB/s | stdx / stdx with AVX2 alone |
|---|---|---|---|---|---|---|
| string: silesia/dickens | 166668 | 43259.6 ± 0.3% | 47379.6 ± 0.2% | 0.913 | — | — |
| string: silesia/nci | 1048576 | 35232.4 ± 7.7% | 37985.0 ± 5.4% | 0.928 | — | — |
| string: silesia/reymont | 1048576 | 35082.4 ± 6.4% | 37447.7 ± 9.1% | 0.937 | — | — |
| string: silesia/samba | 65546 | 43436.3 ± 0.1% | 48419.7 ± 0.0% | 0.897 | — | — |
| string: silesia/webster | 1048576 | 33573.5 ± 1.8% | 36284.2 ± 2.6% | 0.925 | — | — |
| string: silesia/xml | 1048576 | 30178.6 ± 2.2% | 31270.4 ± 3.0% | 0.965 | — | — |
| string: canterbury/alice29.txt | 152089 | 35877.3 ± 0.1% | 36529.6 ± 0.1% | 0.982 | — | — |
| string: canterbury/asyoulik.txt | 125179 | 43272.5 ± 0.1% | 47665.8 ± 0.5% | 0.908 | — | — |
| string: canterbury/lcet10.txt | 426754 | 36095.4 ± 0.1% | 36721.4 ± 0.1% | 0.983 | — | — |
| string: canterbury/plrabn12.txt | 481861 | 43447.5 ± 0.4% | 47588.1 ± 0.2% | 0.913 | — | — |
| string: canterbury-large/E.coli | 1048576 | 35793.7 ± 2.7% | 38952.1 ± 3.9% | 0.919 | — | — |
| string: canterbury-large/bible.txt | 1048576 | 31739.6 ± 1.4% | 33013.4 ± 1.6% | 0.961 | — | — |
| string: canterbury-large/world192.txt | 1048576 | 31618.8 ± 2.1% | 32945.2 ± 2.8% | 0.960 | — | — |
| string: http/html-1m | 1048576 | 33378.9 ± 1.0% | 35675.4 ± 3.3% | 0.936 | — | — |
| string: http/json-1m | 1048576 | 29957.3 ± 4.5% | 32322.7 ± 3.6% | 0.927 | — | — |
| string: http/js-1m | 1048576 | 36225.1 ± 4.2% | 39232.1 ± 1.4% | 0.923 | — | — |
| string: http/css-1m | 1048576 | 33429.5 ± 1.5% | 35837.4 ± 2.2% | 0.933 | — | — |
| string: dickens as Cyrillic and CJK | 1847045 | 5767.9 ± 0.4% | 5653.6 ± 0.1% | 1.020 | — | — |

## Losses to simdutf

- string: silesia/dickens: stdx runs at 0.913 of simdutf.
- string: silesia/samba: stdx runs at 0.897 of simdutf.
- string: silesia/webster: stdx runs at 0.925 of simdutf.
- string: canterbury/asyoulik.txt: stdx runs at 0.908 of simdutf.
- string: canterbury/plrabn12.txt: stdx runs at 0.913 of simdutf.
- string: canterbury-large/E.coli: stdx runs at 0.919 of simdutf.
- string: http/html-1m: stdx runs at 0.936 of simdutf.
- string: http/json-1m: stdx runs at 0.927 of simdutf.
- string: http/js-1m: stdx runs at 0.923 of simdutf.
- string: http/css-1m: stdx runs at 0.933 of simdutf.

## UTF-8 validation by the buffer's offset from a 64-octet line

| Buffer | Octets | Offset | stdx, MB/s | simdutf, MB/s | stdx / simdutf | stdx with AVX2 alone, MB/s | stdx / stdx with AVX2 alone |
|---|---|---|---|---|---|---|---|
| string: canterbury-large/bible.txt | 1048576 | 0 | 36612.2 ± 1.2% | 40034.1 ± 1.2% | 0.915 | — | — |
| string: canterbury-large/bible.txt | 1048576 | 1 | 31272.0 ± 1.4% | 32515.3 ± 1.6% | 0.962 | — | — |
| string: canterbury-large/bible.txt | 1048576 | 8 | 34274.5 ± 7.3% | 37126.4 ± 2.5% | 0.923 | — | — |
| string: canterbury-large/bible.txt | 1048576 | 16 | 35283.2 ± 6.5% | 38346.6 ± 5.0% | 0.920 | — | — |
| string: canterbury-large/bible.txt | 1048576 | 32 | 35609.2 ± 3.3% | 38538.0 ± 1.6% | 0.924 | — | — |
| string: canterbury-large/bible.txt | 1048576 | 48 | 35077.9 ± 5.3% | 38401.0 ± 3.1% | 0.913 | — | — |
| string: dickens as Cyrillic and CJK | 1048576 | 0 | 5763.2 ± 0.1% | 5648.2 ± 0.2% | 1.020 | — | — |
| string: dickens as Cyrillic and CJK | 1048576 | 1 | 5751.0 ± 0.2% | 5644.3 ± 0.2% | 1.019 | — | — |
| string: dickens as Cyrillic and CJK | 1048576 | 8 | 5763.4 ± 0.0% | 5645.5 ± 0.1% | 1.021 | — | — |
| string: dickens as Cyrillic and CJK | 1048576 | 16 | 5764.0 ± 0.2% | 5645.2 ± 0.1% | 1.021 | — | — |
| string: dickens as Cyrillic and CJK | 1048576 | 32 | 5758.3 ± 0.2% | 5644.8 ± 0.2% | 1.020 | — | — |
| string: dickens as Cyrillic and CJK | 1048576 | 48 | 5757.0 ± 0.2% | 5644.9 ± 0.2% | 1.020 | — | — |

## Against the baselines

stdx with every claim on, timed beside simdjson 5.1.1, yyjson 0.13.0, Zig 0.16.0's std.json, serde_json 1.0.154 and Go's encoding/json/jsontext in the same run. Each ratio is stdx's throughput over the baseline's; below 1, the baseline is faster. stdx is built for the architecture's baseline CPU in ReleaseSafe. Each baseline is built for the same CPU, the C, C++ and Zig ones in ReleaseFast (decision 75), and simdjson picks its kernel at run time. Decoding visits every value; encoding writes each text from its tokens.

## Decoding against the baselines

Octets are the text's. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1128.2 ± 0.4% | 928.8 ± 0.6% | 1020.3 ± 0.2% | 300.9 ± 0.7% | 665.6 ± 0.3% | 309.6 ± 2.1% | 1.215 | 1.106 | 3.750 | 1.695 | 3.645 |
| qlog records, JSON text sequence | 1467503 | 833.9 ± 2.9% | 817.2 ± 0.2% | 767.1 ± 1.4% | 243.1 ± 1.1% | 697.5 ± 1.1% | 245.3 ± 3.2% | 1.020 | 1.087 | 3.431 | 1.196 | 3.399 |
| string: silesia/dickens | 172528 | 5047.3 ± 0.3% | 1876.3 ± 0.2% | 2647.0 ± 0.2% | 362.2 ± 0.4% | 2864.8 ± 0.4% | 550.3 ± 0.9% | 2.690 | 1.907 | 13.935 | 1.762 | 9.172 |
| string: silesia/nci | 1075110 | 4298.5 ± 0.3% | 2235.1 ± 0.5% | 2990.3 ± 0.4% | 543.0 ± 2.3% | 2959.8 ± 1.0% | 603.2 ± 0.7% | 1.923 | 1.437 | 7.916 | 1.452 | 7.126 |
| string: silesia/reymont | 1075159 | 2935.2 ± 1.8% | 1806.8 ± 1.8% | 2063.2 ± 0.2% | 375.0 ± 1.2% | 2146.1 ± 0.3% | 533.2 ± 0.6% | 1.625 | 1.423 | 7.828 | 1.368 | 5.505 |
| string: silesia/samba | 97582 | 3495.2 ± 0.5% | 2025.4 ± 0.2% | 2614.4 ± 0.4% | 323.0 ± 0.7% | 1498.4 ± 0.3% | 427.1 ± 0.9% | 1.726 | 1.337 | 10.821 | 2.333 | 8.183 |
| string: silesia/webster | 1098490 | 3641.1 ± 0.8% | 1517.0 ± 0.4% | 2006.9 ± 0.7% | 358.8 ± 0.3% | 2164.3 ± 0.8% | 491.1 ± 1.2% | 2.400 | 1.814 | 10.147 | 1.682 | 7.414 |
| string: silesia/xml | 1090118 | 4774.7 ± 0.6% | 2355.2 ± 0.3% | 2524.1 ± 0.6% | 454.7 ± 0.6% | 2795.4 ± 1.3% | 564.3 ± 0.8% | 2.027 | 1.892 | 10.500 | 1.708 | 8.462 |
| string: canterbury/alice29.txt | 159425 | 4312.9 ± 0.1% | 1599.6 ± 0.3% | 2460.7 ± 0.9% | 342.8 ± 0.6% | 2507.4 ± 0.6% | 502.7 ± 1.0% | 2.696 | 1.753 | 12.581 | 1.720 | 8.580 |
| string: canterbury/asyoulik.txt | 132198 | 3464.1 ± 0.8% | 1458.8 ± 0.2% | 2242.0 ± 0.6% | 335.2 ± 1.1% | 2089.3 ± 0.4% | 456.7 ± 2.1% | 2.375 | 1.545 | 10.336 | 1.658 | 7.585 |
| string: canterbury/lcet10.txt | 441884 | 5074.4 ± 0.5% | 1852.3 ± 0.3% | 2329.9 ± 1.1% | 389.5 ± 0.7% | 2839.4 ± 0.3% | 536.3 ± 2.4% | 2.739 | 2.178 | 13.027 | 1.787 | 9.461 |
| string: canterbury/plrabn12.txt | 503330 | 4107.1 ± 0.4% | 1734.6 ± 0.2% | 2057.6 ± 0.7% | 363.1 ± 0.5% | 2466.8 ± 0.5% | 497.9 ± 0.8% | 2.368 | 1.996 | 11.310 | 1.665 | 8.249 |
| string: canterbury-large/E.coli | 1048578 | 19156.6 ± 2.5% | 3607.7 ± 0.5% | 3253.6 ± 0.2% | 928.4 ± 0.9% | 5960.7 ± 1.3% | 751.1 ± 1.0% | 5.310 | 5.888 | 20.634 | 3.214 | 25.505 |
| string: canterbury-large/bible.txt | 1055886 | 6689.6 ± 1.3% | 2937.8 ± 0.7% | 2841.3 ± 0.6% | 424.4 ± 3.5% | 3745.5 ± 1.5% | 613.1 ± 0.7% | 2.277 | 2.354 | 15.761 | 1.786 | 10.911 |
| string: canterbury-large/world192.txt | 1103121 | 3374.9 ± 0.5% | 1482.6 ± 0.6% | 2009.6 ± 0.4% | 353.1 ± 0.8% | 2124.4 ± 1.5% | 500.1 ± 1.0% | 2.276 | 1.679 | 9.557 | 1.589 | 6.748 |
| string: http/html-1m | 1058582 | 6043.6 ± 0.6% | 2733.2 ± 0.5% | 2698.7 ± 0.6% | 441.9 ± 0.4% | 3479.4 ± 0.5% | 599.4 ± 0.4% | 2.211 | 2.239 | 13.676 | 1.737 | 10.083 |
| string: http/json-1m | 1190272 | 2552.4 ± 0.5% | 877.9 ± 0.2% | 2252.4 ± 0.3% | 389.7 ± 0.4% | 1045.2 ± 2.8% | 442.9 ± 0.9% | 2.907 | 1.133 | 6.550 | 2.442 | 5.763 |
| string: http/js-1m | 1144362 | 2285.7 ± 0.8% | 1029.1 ± 0.2% | 1640.4 ± 0.5% | 321.2 ± 0.5% | 1515.0 ± 1.1% | 418.5 ± 0.7% | 2.221 | 1.393 | 7.116 | 1.509 | 5.462 |
| string: http/css-1m | 1097820 | 2636.0 ± 0.6% | 1674.2 ± 0.4% | 2224.1 ± 0.4% | 404.8 ± 1.5% | 1925.1 ± 1.4% | 488.4 ± 0.4% | 1.575 | 1.185 | 6.512 | 1.369 | 5.397 |
| string: dickens as Cyrillic and CJK | 1883069 | 3066.8 ± 0.4% | 1684.1 ± 0.3% | 893.0 ± 0.5% | 351.2 ± 0.2% | 666.5 ± 1.3% | 157.6 ± 0.6% | 1.821 | 3.434 | 8.732 | 4.601 | 19.463 |
| string: dickens as Cyrillic and CJK, as \u escapes | 5075485 | 1327.2 ± 2.0% | 980.0 ± 0.3% | 1193.3 ± 0.5% | 213.4 ± 0.2% | 469.7 ± 0.3% | 254.9 ± 3.7% | 1.354 | 1.112 | 6.220 | 2.825 | 5.207 |
| hex: silesia/dickens | 524290 | 18414.6 ± 1.0% | 3609.2 ± 0.3% | 3282.5 ± 0.3% | 509.3 ± 2.4% | 6133.0 ± 1.5% | 778.2 ± 2.1% | 5.102 | 5.610 | 36.159 | 3.003 | 23.664 |
| hex: silesia/mozilla | 524290 | 18361.5 ± 1.1% | 3600.0 ± 0.9% | 3292.5 ± 0.4% | 451.0 ± 3.4% | 6032.2 ± 0.9% | 779.7 ± 1.0% | 5.100 | 5.577 | 40.708 | 3.044 | 23.551 |
| hex: silesia/mr | 524290 | 18035.5 ± 0.7% | 3603.6 ± 0.3% | 3293.3 ± 0.3% | 570.1 ± 1.8% | 6062.6 ± 1.2% | 780.5 ± 0.3% | 5.005 | 5.476 | 31.637 | 2.975 | 23.109 |
| hex: silesia/nci | 524290 | 18397.5 ± 1.4% | 3601.7 ± 0.3% | 3281.1 ± 0.2% | 626.5 ± 2.1% | 6126.2 ± 1.4% | 780.6 ± 0.6% | 5.108 | 5.607 | 29.363 | 3.003 | 23.568 |
| hex: silesia/ooffice | 524290 | 18718.3 ± 0.8% | 3607.3 ± 0.4% | 3297.9 ± 0.4% | 401.9 ± 1.2% | 6106.5 ± 1.3% | 780.4 ± 1.0% | 5.189 | 5.676 | 46.571 | 3.065 | 23.985 |
| hex: silesia/osdb | 524290 | 18463.6 ± 0.9% | 3605.2 ± 0.3% | 3293.8 ± 0.4% | 481.6 ± 2.5% | 6138.0 ± 1.6% | 779.1 ± 0.3% | 5.121 | 5.606 | 38.336 | 3.008 | 23.699 |
| hex: silesia/reymont | 524290 | 18576.4 ± 2.3% | 3606.4 ± 0.4% | 3282.4 ± 0.3% | 520.9 ± 2.4% | 6083.7 ± 1.6% | 779.3 ± 0.9% | 5.151 | 5.659 | 35.663 | 3.053 | 23.838 |
| hex: silesia/samba | 524290 | 18075.2 ± 0.2% | 3601.9 ± 0.4% | 3281.8 ± 0.2% | 399.7 ± 1.3% | 6010.1 ± 1.3% | 780.5 ± 0.6% | 5.018 | 5.508 | 45.221 | 3.007 | 23.160 |
| hex: silesia/sao | 524290 | 18382.7 ± 0.5% | 3607.0 ± 0.4% | 3284.7 ± 0.2% | 343.4 ± 2.4% | 6109.5 ± 1.3% | 783.0 ± 0.7% | 5.096 | 5.597 | 53.527 | 3.009 | 23.476 |
| hex: silesia/webster | 524290 | 18609.3 ± 0.6% | 3603.2 ± 0.2% | 3291.4 ± 0.3% | 467.6 ± 1.0% | 6110.8 ± 1.9% | 781.5 ± 0.9% | 5.165 | 5.654 | 39.799 | 3.045 | 23.813 |
| hex: silesia/x-ray | 524290 | 18253.6 ± 2.0% | 3605.2 ± 0.4% | 3294.8 ± 0.3% | 476.2 ± 0.9% | 6132.8 ± 1.0% | 781.3 ± 0.7% | 5.063 | 5.540 | 38.334 | 2.976 | 23.363 |
| hex: silesia/xml | 524290 | 18321.3 ± 0.8% | 3604.0 ± 0.2% | 3291.5 ± 0.3% | 521.7 ± 0.4% | 5977.0 ± 0.7% | 782.2 ± 0.4% | 5.084 | 5.566 | 35.117 | 3.065 | 23.424 |
| hex: canterbury/alice29.txt | 304180 | 19515.9 ± 0.4% | 3637.6 ± 0.0% | 3342.0 ± 0.1% | 511.5 ± 0.5% | 6131.0 ± 1.3% | 781.9 ± 0.6% | 5.365 | 5.840 | 38.157 | 3.183 | 24.958 |
| hex: canterbury/asyoulik.txt | 250360 | 19505.7 ± 0.2% | 3640.2 ± 0.2% | 3370.0 ± 0.1% | 504.6 ± 0.2% | 6114.3 ± 1.1% | 779.6 ± 0.6% | 5.358 | 5.788 | 38.654 | 3.190 | 25.022 |
| hex: canterbury/cp.html | 49208 | 19309.6 ± 0.1% | 3638.6 ± 0.1% | 3289.0 ± 0.4% | 472.3 ± 2.9% | 6279.1 ± 0.2% | 761.1 ± 1.5% | 5.307 | 5.871 | 40.881 | 3.075 | 25.371 |
| hex: canterbury/fields.c | 22302 | 18862.6 ± 1.4% | 3628.0 ± 0.0% | 3353.6 ± 0.1% | 511.4 ± 0.4% | 6260.6 ± 0.3% | 753.5 ± 2.6% | 5.199 | 5.625 | 36.881 | 3.013 | 25.032 |
| hex: canterbury/grammar.lsp | 7444 | 17478.6 ± 1.0% | 3600.3 ± 0.0% | 3344.6 ± 0.5% | 537.6 ± 1.9% | 6162.3 ± 0.6% | 704.6 ± 3.7% | 4.855 | 5.226 | 32.515 | 2.836 | 24.806 |
| hex: canterbury/kennedy.xls | 524290 | 18241.6 ± 1.3% | 3609.6 ± 0.3% | 3295.2 ± 0.5% | 658.2 ± 2.5% | 6109.7 ± 1.0% | 778.8 ± 1.6% | 5.054 | 5.536 | 27.715 | 2.986 | 23.423 |
| hex: canterbury/lcet10.txt | 524290 | 18591.3 ± 0.6% | 3609.2 ± 0.2% | 3288.7 ± 0.5% | 510.8 ± 0.5% | 6085.4 ± 1.2% | 781.5 ± 1.0% | 5.151 | 5.653 | 36.398 | 3.055 | 23.789 |
| hex: canterbury/plrabn12.txt | 524290 | 18481.4 ± 0.8% | 3609.6 ± 0.1% | 3296.7 ± 0.4% | 500.8 ± 1.1% | 6142.3 ± 1.4% | 780.7 ± 0.3% | 5.120 | 5.606 | 36.901 | 3.009 | 23.673 |
| hex: canterbury/ptt5 | 524290 | 18210.1 ± 0.4% | 3609.0 ± 0.3% | 3285.3 ± 0.2% | 559.8 ± 0.3% | 6058.7 ± 1.5% | 781.1 ± 1.4% | 5.046 | 5.543 | 32.527 | 3.006 | 23.312 |
| hex: canterbury/sum | 76482 | 19285.5 ± 0.1% | 3632.8 ± 0.1% | 3362.0 ± 0.1% | 509.6 ± 0.2% | 6175.1 ± 0.3% | 768.7 ± 0.6% | 5.309 | 5.736 | 37.843 | 3.123 | 25.089 |
| hex: canterbury/xargs.1 | 8456 | 17831.8 ± 1.1% | 3601.7 ± 0.1% | 3375.0 ± 0.2% | 495.4 ± 1.2% | 6151.3 ± 0.3% | 746.3 ± 1.6% | 4.951 | 5.284 | 35.994 | 2.899 | 23.894 |
| hex: canterbury-large/E.coli | 524290 | 18305.6 ± 0.9% | 3606.7 ± 0.1% | 3286.1 ± 0.4% | 688.1 ± 0.2% | 6119.5 ± 1.2% | 760.2 ± 4.8% | 5.075 | 5.571 | 26.602 | 2.991 | 24.081 |
| hex: canterbury-large/bible.txt | 524290 | 18671.8 ± 0.9% | 3605.2 ± 0.2% | 3292.3 ± 0.1% | 526.6 ± 1.1% | 6095.3 ± 1.2% | 778.6 ± 0.8% | 5.179 | 5.671 | 35.457 | 3.063 | 23.982 |
| hex: canterbury-large/world192.txt | 524290 | 18324.8 ± 1.0% | 3605.7 ± 0.2% | 3287.5 ± 0.5% | 507.0 ± 1.8% | 6155.0 ± 1.0% | 781.4 ± 0.5% | 5.082 | 5.574 | 36.142 | 2.977 | 23.450 |
| hex: http/html-1kx1024 | 2099200 | 9064.2 ± 14.6% | 3456.0 ± 0.1% | 2845.9 ± 0.4% | 474.1 ± 0.6% | 5098.8 ± 1.6% | 643.0 ± 4.0% | 2.623 | 3.185 | 19.118 | 1.778 | 14.097 |
| hex: http/html-16kx64 | 2097280 | 17751.4 ± 1.4% | 3611.4 ± 0.1% | 3255.0 ± 0.3% | 477.8 ± 0.5% | 6033.6 ± 0.6% | 748.2 ± 1.7% | 4.915 | 5.454 | 37.151 | 2.942 | 23.727 |
| hex: http/html-1m | 524290 | 18404.8 ± 2.1% | 3601.7 ± 0.5% | 3286.0 ± 0.4% | 500.3 ± 3.4% | 6108.9 ± 1.1% | 775.7 ± 1.5% | 5.110 | 5.601 | 36.787 | 3.013 | 23.726 |
| hex: http/json-1kx1024 | 2099200 | 9244.4 ± 17.1% | 3457.4 ± 0.3% | 2848.4 ± 0.5% | 574.3 ± 0.9% | 5080.6 ± 1.8% | 644.9 ± 2.2% | 2.674 | 3.246 | 16.096 | 1.820 | 14.335 |
| hex: http/json-16kx64 | 2097280 | 17981.5 ± 1.0% | 3607.6 ± 0.2% | 3258.9 ± 0.3% | 575.2 ± 3.5% | 6025.9 ± 0.5% | 755.2 ± 1.5% | 4.984 | 5.518 | 31.260 | 2.984 | 23.809 |
| hex: http/json-1m | 524290 | 18338.5 ± 0.6% | 3612.4 ± 0.6% | 3289.8 ± 0.3% | 592.1 ± 2.0% | 6157.4 ± 1.3% | 775.5 ± 3.5% | 5.077 | 5.574 | 30.974 | 2.978 | 23.647 |
| hex: http/js-1kx1024 | 2099200 | 9312.8 ± 16.2% | 3463.4 ± 0.1% | 2853.6 ± 0.3% | 480.7 ± 0.6% | 5067.9 ± 0.6% | 653.3 ± 1.0% | 2.689 | 3.264 | 19.375 | 1.838 | 14.256 |
| hex: http/js-16kx64 | 2097280 | 17748.7 ± 0.6% | 3609.7 ± 0.2% | 3261.2 ± 0.2% | 478.7 ± 0.9% | 6041.1 ± 0.3% | 760.0 ± 1.9% | 4.917 | 5.442 | 37.073 | 2.938 | 23.352 |
| hex: http/js-1m | 524290 | 18348.6 ± 0.8% | 3604.9 ± 0.6% | 3275.7 ± 0.4% | 502.9 ± 2.1% | 6030.1 ± 0.5% | 762.5 ± 1.1% | 5.090 | 5.601 | 36.486 | 3.043 | 24.064 |
| hex: http/css-1kx1024 | 2099200 | 9359.3 ± 17.0% | 3456.2 ± 0.4% | 2853.2 ± 0.6% | 487.7 ± 0.5% | 5168.2 ± 1.0% | 641.9 ± 3.0% | 2.708 | 3.280 | 19.189 | 1.811 | 14.581 |
| hex: http/css-16kx64 | 2097280 | 17857.8 ± 0.7% | 3610.9 ± 0.2% | 3261.9 ± 0.3% | 496.4 ± 0.7% | 6025.8 ± 0.2% | 757.2 ± 1.4% | 4.946 | 5.475 | 35.975 | 2.964 | 23.584 |
| hex: http/css-1m | 524290 | 18585.3 ± 2.2% | 3609.6 ± 0.2% | 3292.7 ± 0.2% | 495.0 ± 2.4% | 6069.3 ± 1.5% | 766.6 ± 3.0% | 5.149 | 5.644 | 37.547 | 3.062 | 24.244 |
| hex: shuffled/dickens-1m | 524290 | 18027.7 ± 1.4% | 3606.5 ± 0.3% | 3275.7 ± 0.4% | 524.3 ± 2.8% | 5970.1 ± 0.4% | 765.4 ± 0.6% | 4.999 | 5.503 | 34.386 | 3.020 | 23.554 |

## Encoding against the baselines

Octets are the ones stdx writes. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1481.4 ± 0.9% | 1251.2 ± 0.6% | 1041.0 ± 0.5% | 408.9 ± 0.3% | 448.5 ± 0.8% | 416.1 ± 0.6% | 1.184 | 1.423 | 3.623 | 3.303 | 3.560 |
| qlog records, JSON text sequence | 1467503 | 1272.5 ± 1.1% | 1064.1 ± 0.4% | 781.7 ± 0.4% | 377.4 ± 0.7% | 458.5 ± 0.4% | 278.8 ± 0.9% | 1.196 | 1.628 | 3.372 | 2.775 | 4.565 |
| string: silesia/dickens | 172528 | 6909.2 ± 0.9% | 2807.5 ± 0.5% | 2940.6 ± 0.5% | 431.7 ± 0.3% | 1564.8 ± 0.3% | 1010.7 ± 0.1% | 2.461 | 2.350 | 16.006 | 4.416 | 6.836 |
| string: silesia/nci | 1075110 | 7302.7 ± 0.2% | 3413.2 ± 6.8% | 3093.3 ± 2.7% | 809.0 ± 1.7% | 1830.1 ± 0.4% | 1107.3 ± 0.4% | 2.140 | 2.361 | 9.027 | 3.990 | 6.595 |
| string: silesia/reymont | 1075159 | 3339.6 ± 1.5% | 1977.8 ± 1.2% | 2058.9 ± 0.5% | 451.3 ± 0.4% | 1489.0 ± 1.1% | 949.5 ± 0.9% | 1.689 | 1.622 | 7.400 | 2.243 | 3.517 |
| string: silesia/samba | 97582 | 4184.3 ± 1.0% | 2103.1 ± 0.9% | 3464.9 ± 0.3% | 353.9 ± 0.5% | 1408.5 ± 0.5% | 1055.6 ± 0.3% | 1.990 | 1.208 | 11.824 | 2.971 | 3.964 |
| string: silesia/webster | 1098490 | 4046.3 ± 0.5% | 1879.5 ± 0.3% | 2054.5 ± 0.6% | 440.1 ± 0.5% | 1373.4 ± 0.4% | 647.3 ± 0.8% | 2.153 | 1.969 | 9.194 | 2.946 | 6.251 |
| string: silesia/xml | 1090118 | 6103.8 ± 0.7% | 2866.4 ± 0.4% | 2648.9 ± 0.9% | 606.2 ± 0.9% | 1731.8 ± 0.5% | 919.9 ± 0.6% | 2.129 | 2.304 | 10.070 | 3.525 | 6.635 |
| string: canterbury/alice29.txt | 159425 | 6382.9 ± 1.4% | 2192.0 ± 0.4% | 2762.4 ± 0.8% | 407.9 ± 0.4% | 1438.1 ± 0.2% | 955.1 ± 0.2% | 2.912 | 2.311 | 15.648 | 4.438 | 6.683 |
| string: canterbury/asyoulik.txt | 132198 | 5582.6 ± 0.7% | 1711.3 ± 0.6% | 2376.2 ± 0.6% | 402.5 ± 0.6% | 1310.8 ± 0.2% | 886.0 ± 0.2% | 3.262 | 2.349 | 13.870 | 4.259 | 6.301 |
| string: canterbury/lcet10.txt | 441884 | 6252.4 ± 0.6% | 2566.9 ± 0.4% | 2511.1 ± 2.0% | 468.7 ± 0.2% | 1522.8 ± 1.1% | 982.2 ± 0.3% | 2.436 | 2.490 | 13.341 | 4.106 | 6.366 |
| string: canterbury/plrabn12.txt | 503330 | 5707.4 ± 0.4% | 2052.0 ± 0.2% | 2070.5 ± 0.3% | 424.0 ± 0.6% | 1364.4 ± 0.2% | 935.9 ± 0.5% | 2.781 | 2.756 | 13.460 | 4.183 | 6.098 |
| string: canterbury-large/E.coli | 1048578 | 19180.2 ± 0.7% | 9753.9 ± 4.3% | 3785.3 ± 0.4% | 1473.7 ± 0.4% | 2356.0 ± 0.5% | 1193.5 ± 0.4% | 1.966 | 5.067 | 13.015 | 8.141 | 16.071 |
| string: canterbury-large/bible.txt | 1055886 | 6786.2 ± 0.7% | 4144.8 ± 0.8% | 3053.5 ± 0.8% | 504.5 ± 0.9% | 1981.2 ± 0.4% | 1120.5 ± 1.0% | 1.637 | 2.222 | 13.453 | 3.425 | 6.056 |
| string: canterbury-large/world192.txt | 1103121 | 4018.3 ± 0.7% | 1657.0 ± 0.6% | 1996.4 ± 0.3% | 449.1 ± 0.5% | 1341.7 ± 0.5% | 908.4 ± 0.4% | 2.425 | 2.013 | 8.947 | 2.995 | 4.424 |
| string: http/html-1m | 1058582 | 6752.0 ± 0.6% | 3938.9 ± 0.6% | 3022.5 ± 0.7% | 498.5 ± 0.7% | 1923.1 ± 0.4% | 803.6 ± 0.6% | 1.714 | 2.234 | 13.544 | 3.511 | 8.402 |
| string: http/json-1m | 1190272 | 3160.4 ± 0.3% | 1354.8 ± 0.1% | 1556.2 ± 0.6% | 443.3 ± 0.4% | 1036.1 ± 0.1% | 764.8 ± 0.3% | 2.333 | 2.031 | 7.130 | 3.050 | 4.132 |
| string: http/js-1m | 1144362 | 2765.3 ± 1.1% | 1179.9 ± 0.3% | 1624.6 ± 0.4% | 367.9 ± 0.3% | 1084.8 ± 0.3% | 758.5 ± 0.2% | 2.344 | 1.702 | 7.516 | 2.549 | 3.646 |
| string: http/css-1m | 1097820 | 3979.8 ± 0.9% | 1491.6 ± 0.4% | 2146.0 ± 1.0% | 493.1 ± 0.4% | 1355.9 ± 0.2% | 896.5 ± 0.2% | 2.668 | 1.855 | 8.071 | 2.935 | 4.439 |
| string: dickens as Cyrillic and CJK | 1883069 | 3069.9 ± 0.3% | 2333.0 ± 0.3% | 521.9 ± 0.2% | 308.2 ± 0.5% | 561.9 ± 1.1% | 336.2 ± 0.2% | 1.316 | 5.882 | 9.962 | 5.463 | 9.131 |
| hex: silesia/dickens | 524290 | 15635.9 ± 0.4% | 1463.5 ± 0.8% | 1084.1 ± 0.4% | 504.2 ± 0.8% | 986.2 ± 0.3% | 733.8 ± 0.6% | 10.684 | 14.423 | 31.014 | 15.854 | 21.309 |
| hex: silesia/mozilla | 524290 | 15689.9 ± 0.2% | 1469.9 ± 0.4% | 1086.6 ± 0.3% | 441.7 ± 0.9% | 995.9 ± 0.4% | 733.0 ± 0.6% | 10.674 | 14.439 | 35.520 | 15.754 | 21.406 |
| hex: silesia/mr | 524290 | 15642.2 ± 0.5% | 1479.0 ± 0.3% | 1094.8 ± 0.3% | 560.0 ± 1.2% | 992.9 ± 0.4% | 732.8 ± 0.3% | 10.576 | 14.287 | 27.933 | 15.754 | 21.345 |
| hex: silesia/nci | 524290 | 15680.9 ± 0.2% | 1468.9 ± 0.2% | 1089.1 ± 0.3% | 630.5 ± 2.4% | 994.0 ± 1.1% | 733.8 ± 0.5% | 10.675 | 14.398 | 24.871 | 15.775 | 21.369 |
| hex: silesia/ooffice | 524290 | 15631.2 ± 0.2% | 1463.2 ± 0.6% | 1084.1 ± 0.6% | 389.6 ± 0.4% | 988.6 ± 0.4% | 732.4 ± 0.6% | 10.683 | 14.418 | 40.121 | 15.812 | 21.343 |
| hex: silesia/osdb | 524290 | 15616.9 ± 0.6% | 1468.2 ± 0.2% | 1086.5 ± 0.6% | 469.7 ± 1.2% | 989.4 ± 0.5% | 733.6 ± 0.4% | 10.637 | 14.373 | 33.251 | 15.784 | 21.288 |
| hex: silesia/reymont | 524290 | 15640.7 ± 0.2% | 1464.1 ± 0.6% | 1085.2 ± 0.6% | 513.9 ± 0.8% | 987.0 ± 0.5% | 734.8 ± 0.5% | 10.683 | 14.413 | 30.432 | 15.847 | 21.287 |
| hex: silesia/samba | 524290 | 15658.2 ± 0.2% | 1464.7 ± 0.3% | 1085.3 ± 0.3% | 402.8 ± 0.6% | 991.0 ± 0.5% | 732.8 ± 1.6% | 10.690 | 14.428 | 38.876 | 15.800 | 21.369 |
| hex: silesia/sao | 524290 | 15620.6 ± 0.2% | 1465.6 ± 0.5% | 1081.4 ± 0.6% | 332.5 ± 0.3% | 988.2 ± 0.5% | 734.5 ± 0.4% | 10.658 | 14.444 | 46.974 | 15.807 | 21.268 |
| hex: silesia/webster | 524290 | 15675.4 ± 0.3% | 1463.7 ± 0.2% | 1086.0 ± 0.5% | 475.4 ± 0.4% | 996.0 ± 0.6% | 735.1 ± 0.5% | 10.710 | 14.434 | 32.973 | 15.739 | 21.324 |
| hex: silesia/x-ray | 524290 | 15606.6 ± 0.4% | 1473.2 ± 0.4% | 1087.8 ± 0.2% | 446.9 ± 0.8% | 994.7 ± 0.5% | 734.8 ± 0.6% | 10.594 | 14.347 | 34.925 | 15.691 | 21.238 |
| hex: silesia/xml | 524290 | 15661.7 ± 0.1% | 1466.7 ± 0.4% | 1086.6 ± 0.6% | 610.3 ± 0.5% | 996.2 ± 0.3% | 734.8 ± 0.7% | 10.678 | 14.413 | 25.660 | 15.721 | 21.315 |
| hex: canterbury/alice29.txt | 304180 | 15690.9 ± 0.4% | 1470.5 ± 0.6% | 1094.4 ± 0.4% | 502.0 ± 3.3% | 994.5 ± 0.5% | 736.8 ± 0.7% | 10.671 | 14.337 | 31.257 | 15.778 | 21.295 |
| hex: canterbury/asyoulik.txt | 250360 | 15709.8 ± 0.1% | 1479.8 ± 0.4% | 1095.5 ± 0.3% | 499.7 ± 1.2% | 995.8 ± 0.4% | 739.7 ± 0.5% | 10.616 | 14.341 | 31.440 | 15.776 | 21.239 |
| hex: canterbury/cp.html | 49208 | 15623.3 ± 0.2% | 1480.7 ± 0.7% | 1097.8 ± 0.3% | 525.0 ± 2.1% | 1002.6 ± 0.4% | 743.1 ± 0.1% | 10.551 | 14.232 | 29.761 | 15.583 | 21.025 |
| hex: canterbury/fields.c | 22302 | 15436.0 ± 0.1% | 1410.4 ± 0.8% | 1069.3 ± 1.0% | 624.4 ± 3.6% | 991.4 ± 0.1% | 736.7 ± 0.1% | 10.944 | 14.436 | 24.720 | 15.571 | 20.953 |
| hex: canterbury/grammar.lsp | 7444 | 14938.4 ± 0.1% | 1507.4 ± 0.2% | 1095.7 ± 0.4% | 671.9 ± 1.0% | 989.6 ± 0.5% | 726.2 ± 0.1% | 9.910 | 13.634 | 22.234 | 15.095 | 20.570 |
| hex: canterbury/kennedy.xls | 524290 | 15577.1 ± 0.3% | 1470.8 ± 0.2% | 1087.3 ± 0.6% | 657.7 ± 0.5% | 990.6 ± 0.4% | 733.4 ± 0.7% | 10.591 | 14.327 | 23.685 | 15.725 | 21.238 |
| hex: canterbury/lcet10.txt | 524290 | 15638.5 ± 0.3% | 1459.4 ± 0.5% | 1086.1 ± 0.2% | 499.0 ± 1.8% | 986.8 ± 0.2% | 732.5 ± 0.8% | 10.715 | 14.399 | 31.337 | 15.847 | 21.350 |
| hex: canterbury/plrabn12.txt | 524290 | 15636.2 ± 0.3% | 1463.7 ± 0.4% | 1084.1 ± 0.7% | 489.7 ± 0.5% | 990.4 ± 0.5% | 732.9 ± 0.4% | 10.682 | 14.424 | 31.927 | 15.788 | 21.336 |
| hex: canterbury/ptt5 | 524290 | 15595.2 ± 0.4% | 1479.2 ± 0.4% | 1090.2 ± 0.3% | 553.3 ± 1.2% | 993.5 ± 0.4% | 734.0 ± 0.5% | 10.543 | 14.305 | 28.185 | 15.697 | 21.247 |
| hex: canterbury/sum | 76482 | 15637.3 ± 0.1% | 1494.7 ± 0.1% | 1104.2 ± 0.1% | 598.1 ± 2.6% | 998.3 ± 0.1% | 744.1 ± 0.8% | 10.462 | 14.162 | 26.145 | 15.664 | 21.014 |
| hex: canterbury/xargs.1 | 8456 | 14994.4 ± 0.2% | 1494.6 ± 0.4% | 1091.5 ± 0.7% | 656.3 ± 5.2% | 1000.2 ± 0.2% | 728.7 ± 0.1% | 10.033 | 13.738 | 22.845 | 14.991 | 20.576 |
| hex: canterbury-large/E.coli | 524290 | 15683.1 ± 0.1% | 1471.9 ± 0.4% | 1091.5 ± 0.4% | 671.9 ± 0.4% | 991.6 ± 0.5% | 732.3 ± 0.3% | 10.655 | 14.368 | 23.343 | 15.816 | 21.417 |
| hex: canterbury-large/bible.txt | 524290 | 15641.6 ± 0.1% | 1459.5 ± 0.4% | 1085.4 ± 0.3% | 515.8 ± 0.4% | 988.3 ± 0.4% | 734.4 ± 0.4% | 10.717 | 14.411 | 30.325 | 15.827 | 21.298 |
| hex: canterbury-large/world192.txt | 524290 | 15643.7 ± 0.3% | 1467.1 ± 0.3% | 1087.0 ± 0.2% | 500.9 ± 0.9% | 993.3 ± 0.4% | 732.6 ± 0.8% | 10.663 | 14.392 | 31.232 | 15.749 | 21.354 |
| hex: http/html-1kx1024 | 2099200 | 13626.9 ± 0.5% | 1462.1 ± 0.5% | 1064.6 ± 0.3% | 501.7 ± 0.1% | 974.6 ± 0.0% | 692.9 ± 0.2% | 9.320 | 12.800 | 27.164 | 13.982 | 19.666 |
| hex: http/html-16kx64 | 2097280 | 15154.0 ± 0.7% | 1446.4 ± 0.7% | 1076.0 ± 0.6% | 507.5 ± 0.3% | 999.5 ± 0.5% | 734.7 ± 0.3% | 10.477 | 14.084 | 29.862 | 15.161 | 20.626 |
| hex: http/html-1m | 524290 | 15653.8 ± 0.2% | 1471.9 ± 0.3% | 1087.2 ± 0.2% | 501.3 ± 0.6% | 991.7 ± 0.5% | 735.9 ± 0.6% | 10.635 | 14.399 | 31.229 | 15.784 | 21.273 |
| hex: http/json-1kx1024 | 2099200 | 13705.1 ± 0.4% | 1464.2 ± 0.1% | 1067.1 ± 0.1% | 608.9 ± 0.6% | 986.3 ± 0.1% | 692.7 ± 0.1% | 9.360 | 12.843 | 22.507 | 13.895 | 19.784 |
| hex: http/json-16kx64 | 2097280 | 15294.2 ± 0.3% | 1446.2 ± 0.1% | 1073.7 ± 0.3% | 616.3 ± 0.4% | 994.8 ± 0.3% | 735.0 ± 0.3% | 10.575 | 14.245 | 24.816 | 15.375 | 20.807 |
| hex: http/json-1m | 524290 | 15671.9 ± 0.3% | 1472.0 ± 0.5% | 1091.1 ± 0.4% | 635.5 ± 0.9% | 990.9 ± 0.4% | 732.7 ± 1.1% | 10.647 | 14.363 | 24.663 | 15.817 | 21.388 |
| hex: http/js-1kx1024 | 2099200 | 13621.8 ± 0.3% | 1455.1 ± 0.5% | 1063.3 ± 0.3% | 498.9 ± 0.4% | 983.7 ± 0.7% | 692.8 ± 0.1% | 9.361 | 12.811 | 27.301 | 13.848 | 19.661 |
| hex: http/js-16kx64 | 2097280 | 15161.4 ± 0.7% | 1442.3 ± 0.4% | 1075.5 ± 0.4% | 505.4 ± 0.6% | 994.4 ± 0.5% | 734.6 ± 0.2% | 10.512 | 14.097 | 29.996 | 15.247 | 20.638 |
| hex: http/js-1m | 524290 | 15654.0 ± 0.3% | 1464.2 ± 0.5% | 1085.4 ± 0.4% | 510.7 ± 0.5% | 990.1 ± 0.3% | 733.6 ± 0.5% | 10.691 | 14.422 | 30.651 | 15.810 | 21.339 |
| hex: http/css-1kx1024 | 2099200 | 13639.9 ± 0.3% | 1455.5 ± 0.6% | 1063.2 ± 0.3% | 531.7 ± 0.3% | 983.0 ± 0.2% | 692.6 ± 1.2% | 9.372 | 12.830 | 25.652 | 13.876 | 19.694 |
| hex: http/css-16kx64 | 2097280 | 15191.3 ± 0.5% | 1444.5 ± 0.2% | 1072.8 ± 0.2% | 542.6 ± 0.6% | 998.6 ± 0.1% | 735.3 ± 0.3% | 10.516 | 14.160 | 27.995 | 15.212 | 20.661 |
| hex: http/css-1m | 524290 | 15688.3 ± 0.2% | 1465.4 ± 0.3% | 1085.5 ± 0.4% | 526.6 ± 1.0% | 988.1 ± 0.2% | 734.9 ± 0.6% | 10.706 | 14.453 | 29.794 | 15.877 | 21.347 |
| hex: shuffled/dickens-1m | 524290 | 15689.9 ± 0.3% | 1468.2 ± 0.6% | 1084.0 ± 0.9% | 503.2 ± 0.6% | 985.8 ± 0.1% | 733.1 ± 0.7% | 10.686 | 14.475 | 31.178 | 15.915 | 21.403 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1526.7 ± 0.5% | 1251.2 ± 0.6% | 1041.0 ± 0.5% | 408.9 ± 0.3% | 448.5 ± 0.8% | 416.1 ± 0.6% | 1.220 | 1.467 | 3.734 | 3.404 | 3.669 |
| qlog records, JSON text sequence | 1467503 | 1292.0 ± 0.1% | 1064.1 ± 0.4% | 781.7 ± 0.4% | 377.4 ± 0.7% | 458.5 ± 0.4% | 278.8 ± 0.9% | 1.214 | 1.653 | 3.424 | 2.818 | 4.635 |
| string: silesia/dickens | 172528 | 7134.9 ± 0.5% | 2807.5 ± 0.5% | 2940.6 ± 0.5% | 431.7 ± 0.3% | 1564.8 ± 0.3% | 1010.7 ± 0.1% | 2.541 | 2.426 | 16.529 | 4.560 | 7.060 |
| string: silesia/nci | 1075110 | 7371.2 ± 2.5% | 3413.2 ± 6.8% | 3093.3 ± 2.7% | 809.0 ± 1.7% | 1830.1 ± 0.4% | 1107.3 ± 0.4% | 2.160 | 2.383 | 9.111 | 4.028 | 6.657 |
| string: silesia/reymont | 1075159 | 3484.0 ± 1.3% | 1977.8 ± 1.2% | 2058.9 ± 0.5% | 451.3 ± 0.4% | 1489.0 ± 1.1% | 949.5 ± 0.9% | 1.762 | 1.692 | 7.720 | 2.340 | 3.669 |
| string: silesia/samba | 97582 | 4573.9 ± 1.4% | 2103.1 ± 0.9% | 3464.9 ± 0.3% | 353.9 ± 0.5% | 1408.5 ± 0.5% | 1055.6 ± 0.3% | 2.175 | 1.320 | 12.925 | 3.247 | 4.333 |
| string: silesia/webster | 1098490 | 4097.8 ± 0.8% | 1879.5 ± 0.3% | 2054.5 ± 0.6% | 440.1 ± 0.5% | 1373.4 ± 0.4% | 647.3 ± 0.8% | 2.180 | 1.995 | 9.311 | 2.984 | 6.330 |
| string: silesia/xml | 1090118 | 6230.6 ± 0.9% | 2866.4 ± 0.4% | 2648.9 ± 0.9% | 606.2 ± 0.9% | 1731.8 ± 0.5% | 919.9 ± 0.6% | 2.174 | 2.352 | 10.279 | 3.598 | 6.773 |
| string: canterbury/alice29.txt | 159425 | 6831.5 ± 1.4% | 2192.0 ± 0.4% | 2762.4 ± 0.8% | 407.9 ± 0.4% | 1438.1 ± 0.2% | 955.1 ± 0.2% | 3.117 | 2.473 | 16.748 | 4.750 | 7.153 |
| string: canterbury/asyoulik.txt | 132198 | 5921.8 ± 1.6% | 1711.3 ± 0.6% | 2376.2 ± 0.6% | 402.5 ± 0.6% | 1310.8 ± 0.2% | 886.0 ± 0.2% | 3.460 | 2.492 | 14.713 | 4.518 | 6.683 |
| string: canterbury/lcet10.txt | 441884 | 6257.5 ± 0.4% | 2566.9 ± 0.4% | 2511.1 ± 2.0% | 468.7 ± 0.2% | 1522.8 ± 1.1% | 982.2 ± 0.3% | 2.438 | 2.492 | 13.352 | 4.109 | 6.371 |
| string: canterbury/plrabn12.txt | 503330 | 5741.3 ± 0.3% | 2052.0 ± 0.2% | 2070.5 ± 0.3% | 424.0 ± 0.6% | 1364.4 ± 0.2% | 935.9 ± 0.5% | 2.798 | 2.773 | 13.540 | 4.208 | 6.134 |
| string: canterbury-large/E.coli | 1048578 | 19151.6 ± 0.4% | 9753.9 ± 4.3% | 3785.3 ± 0.4% | 1473.7 ± 0.4% | 2356.0 ± 0.5% | 1193.5 ± 0.4% | 1.963 | 5.059 | 12.996 | 8.129 | 16.047 |
| string: canterbury-large/bible.txt | 1055886 | 6798.6 ± 0.3% | 4144.8 ± 0.8% | 3053.5 ± 0.8% | 504.5 ± 0.9% | 1981.2 ± 0.4% | 1120.5 ± 1.0% | 1.640 | 2.226 | 13.477 | 3.432 | 6.067 |
| string: canterbury-large/world192.txt | 1103121 | 4040.0 ± 0.8% | 1657.0 ± 0.6% | 1996.4 ± 0.3% | 449.1 ± 0.5% | 1341.7 ± 0.5% | 908.4 ± 0.4% | 2.438 | 2.024 | 8.995 | 3.011 | 4.447 |
| string: http/html-1m | 1058582 | 6806.6 ± 0.1% | 3938.9 ± 0.6% | 3022.5 ± 0.7% | 498.5 ± 0.7% | 1923.1 ± 0.4% | 803.6 ± 0.6% | 1.728 | 2.252 | 13.653 | 3.539 | 8.470 |
| string: http/json-1m | 1190272 | 3291.8 ± 0.3% | 1354.8 ± 0.1% | 1556.2 ± 0.6% | 443.3 ± 0.4% | 1036.1 ± 0.1% | 764.8 ± 0.3% | 2.430 | 2.115 | 7.426 | 3.177 | 4.304 |
| string: http/js-1m | 1144362 | 2797.8 ± 0.8% | 1179.9 ± 0.3% | 1624.6 ± 0.4% | 367.9 ± 0.3% | 1084.8 ± 0.3% | 758.5 ± 0.2% | 2.371 | 1.722 | 7.604 | 2.579 | 3.688 |
| string: http/css-1m | 1097820 | 4027.9 ± 1.0% | 1491.6 ± 0.4% | 2146.0 ± 1.0% | 493.1 ± 0.4% | 1355.9 ± 0.2% | 896.5 ± 0.2% | 2.700 | 1.877 | 8.169 | 2.971 | 4.493 |
| string: dickens as Cyrillic and CJK | 1883069 | 3074.8 ± 0.3% | 2333.0 ± 0.3% | 521.9 ± 0.2% | 308.2 ± 0.5% | 561.9 ± 1.1% | 336.2 ± 0.2% | 1.318 | 5.891 | 9.978 | 5.472 | 9.145 |
| hex: silesia/dickens | 524290 | 15671.6 ± 0.3% | 1463.5 ± 0.8% | 1084.1 ± 0.4% | 504.2 ± 0.8% | 986.2 ± 0.3% | 733.8 ± 0.6% | 10.708 | 14.456 | 31.084 | 15.890 | 21.358 |
| hex: silesia/mozilla | 524290 | 15666.0 ± 0.3% | 1469.9 ± 0.4% | 1086.6 ± 0.3% | 441.7 ± 0.9% | 995.9 ± 0.4% | 733.0 ± 0.6% | 10.658 | 14.417 | 35.466 | 15.730 | 21.373 |
| hex: silesia/mr | 524290 | 15607.5 ± 0.9% | 1479.0 ± 0.3% | 1094.8 ± 0.3% | 560.0 ± 1.2% | 992.9 ± 0.4% | 732.8 ± 0.3% | 10.553 | 14.255 | 27.871 | 15.719 | 21.297 |
| hex: silesia/nci | 524290 | 15665.2 ± 0.2% | 1468.9 ± 0.2% | 1089.1 ± 0.3% | 630.5 ± 2.4% | 994.0 ± 1.1% | 733.8 ± 0.5% | 10.665 | 14.384 | 24.846 | 15.759 | 21.348 |
| hex: silesia/ooffice | 524290 | 15593.3 ± 0.7% | 1463.2 ± 0.6% | 1084.1 ± 0.6% | 389.6 ± 0.4% | 988.6 ± 0.4% | 732.4 ± 0.6% | 10.657 | 14.383 | 40.024 | 15.774 | 21.291 |
| hex: silesia/osdb | 524290 | 15598.4 ± 0.4% | 1468.2 ± 0.2% | 1086.5 ± 0.6% | 469.7 ± 1.2% | 989.4 ± 0.5% | 733.6 ± 0.4% | 10.624 | 14.356 | 33.211 | 15.765 | 21.263 |
| hex: silesia/reymont | 524290 | 15670.2 ± 0.6% | 1464.1 ± 0.6% | 1085.2 ± 0.6% | 513.9 ± 0.8% | 987.0 ± 0.5% | 734.8 ± 0.5% | 10.703 | 14.441 | 30.490 | 15.877 | 21.327 |
| hex: silesia/samba | 524290 | 15644.6 ± 0.6% | 1464.7 ± 0.3% | 1085.3 ± 0.3% | 402.8 ± 0.6% | 991.0 ± 0.5% | 732.8 ± 1.6% | 10.681 | 14.415 | 38.842 | 15.786 | 21.350 |
| hex: silesia/sao | 524290 | 15577.8 ± 0.3% | 1465.6 ± 0.5% | 1081.4 ± 0.6% | 332.5 ± 0.3% | 988.2 ± 0.5% | 734.5 ± 0.4% | 10.629 | 14.405 | 46.846 | 15.764 | 21.209 |
| hex: silesia/webster | 524290 | 15648.1 ± 0.2% | 1463.7 ± 0.2% | 1086.0 ± 0.5% | 475.4 ± 0.4% | 996.0 ± 0.6% | 735.1 ± 0.5% | 10.691 | 14.409 | 32.916 | 15.711 | 21.287 |
| hex: silesia/x-ray | 524290 | 15601.8 ± 0.4% | 1473.2 ± 0.4% | 1087.8 ± 0.2% | 446.9 ± 0.8% | 994.7 ± 0.5% | 734.8 ± 0.6% | 10.590 | 14.343 | 34.914 | 15.686 | 21.232 |
| hex: silesia/xml | 524290 | 15660.1 ± 0.3% | 1466.7 ± 0.4% | 1086.6 ± 0.6% | 610.3 ± 0.5% | 996.2 ± 0.3% | 734.8 ± 0.7% | 10.677 | 14.412 | 25.658 | 15.720 | 21.313 |
| hex: canterbury/alice29.txt | 304180 | 15701.9 ± 0.0% | 1470.5 ± 0.6% | 1094.4 ± 0.4% | 502.0 ± 3.3% | 994.5 ± 0.5% | 736.8 ± 0.7% | 10.678 | 14.347 | 31.279 | 15.789 | 21.310 |
| hex: canterbury/asyoulik.txt | 250360 | 15719.9 ± 0.0% | 1479.8 ± 0.4% | 1095.5 ± 0.3% | 499.7 ± 1.2% | 995.8 ± 0.4% | 739.7 ± 0.5% | 10.623 | 14.350 | 31.460 | 15.786 | 21.252 |
| hex: canterbury/cp.html | 49208 | 15636.0 ± 0.0% | 1480.7 ± 0.7% | 1097.8 ± 0.3% | 525.0 ± 2.1% | 1002.6 ± 0.4% | 743.1 ± 0.1% | 10.560 | 14.243 | 29.785 | 15.595 | 21.042 |
| hex: canterbury/fields.c | 22302 | 15454.0 ± 0.1% | 1410.4 ± 0.8% | 1069.3 ± 1.0% | 624.4 ± 3.6% | 991.4 ± 0.1% | 736.7 ± 0.1% | 10.957 | 14.453 | 24.749 | 15.589 | 20.977 |
| hex: canterbury/grammar.lsp | 7444 | 14985.0 ± 0.0% | 1507.4 ± 0.2% | 1095.7 ± 0.4% | 671.9 ± 1.0% | 989.6 ± 0.5% | 726.2 ± 0.1% | 9.941 | 13.677 | 22.303 | 15.142 | 20.634 |
| hex: canterbury/kennedy.xls | 524290 | 15583.3 ± 0.8% | 1470.8 ± 0.2% | 1087.3 ± 0.6% | 657.7 ± 0.5% | 990.6 ± 0.4% | 733.4 ± 0.7% | 10.595 | 14.333 | 23.695 | 15.732 | 21.247 |
| hex: canterbury/lcet10.txt | 524290 | 15649.0 ± 0.3% | 1459.4 ± 0.5% | 1086.1 ± 0.2% | 499.0 ± 1.8% | 986.8 ± 0.2% | 732.5 ± 0.8% | 10.723 | 14.409 | 31.358 | 15.858 | 21.365 |
| hex: canterbury/plrabn12.txt | 524290 | 15667.4 ± 0.4% | 1463.7 ± 0.4% | 1084.1 ± 0.7% | 489.7 ± 0.5% | 990.4 ± 0.5% | 732.9 ± 0.4% | 10.704 | 14.452 | 31.991 | 15.820 | 21.379 |
| hex: canterbury/ptt5 | 524290 | 15582.7 ± 0.2% | 1479.2 ± 0.4% | 1090.2 ± 0.3% | 553.3 ± 1.2% | 993.5 ± 0.4% | 734.0 ± 0.5% | 10.535 | 14.293 | 28.162 | 15.684 | 21.230 |
| hex: canterbury/sum | 76482 | 15652.7 ± 0.1% | 1494.7 ± 0.1% | 1104.2 ± 0.1% | 598.1 ± 2.6% | 998.3 ± 0.1% | 744.1 ± 0.8% | 10.472 | 14.176 | 26.171 | 15.680 | 21.035 |
| hex: canterbury/xargs.1 | 8456 | 15022.0 ± 0.0% | 1494.6 ± 0.4% | 1091.5 ± 0.7% | 656.3 ± 5.2% | 1000.2 ± 0.2% | 728.7 ± 0.1% | 10.051 | 13.763 | 22.887 | 15.019 | 20.614 |
| hex: canterbury-large/E.coli | 524290 | 15707.1 ± 0.4% | 1471.9 ± 0.4% | 1091.5 ± 0.4% | 671.9 ± 0.4% | 991.6 ± 0.5% | 732.3 ± 0.3% | 10.671 | 14.390 | 23.379 | 15.840 | 21.450 |
| hex: canterbury-large/bible.txt | 524290 | 15590.2 ± 0.5% | 1459.5 ± 0.4% | 1085.4 ± 0.3% | 515.8 ± 0.4% | 988.3 ± 0.4% | 734.4 ± 0.4% | 10.682 | 14.363 | 30.225 | 15.775 | 21.228 |
| hex: canterbury-large/world192.txt | 524290 | 15621.2 ± 0.6% | 1467.1 ± 0.3% | 1087.0 ± 0.2% | 500.9 ± 0.9% | 993.3 ± 0.4% | 732.6 ± 0.8% | 10.648 | 14.371 | 31.187 | 15.726 | 21.324 |
| hex: http/html-1kx1024 | 2099200 | 13771.0 ± 0.5% | 1462.1 ± 0.5% | 1064.6 ± 0.3% | 501.7 ± 0.1% | 974.6 ± 0.0% | 692.9 ± 0.2% | 9.418 | 12.935 | 27.451 | 14.130 | 19.874 |
| hex: http/html-16kx64 | 2097280 | 15161.2 ± 0.6% | 1446.4 ± 0.7% | 1076.0 ± 0.6% | 507.5 ± 0.3% | 999.5 ± 0.5% | 734.7 ± 0.3% | 10.482 | 14.090 | 29.877 | 15.169 | 20.635 |
| hex: http/html-1m | 524290 | 15664.0 ± 0.5% | 1471.9 ± 0.3% | 1087.2 ± 0.2% | 501.3 ± 0.6% | 991.7 ± 0.5% | 735.9 ± 0.6% | 10.642 | 14.408 | 31.249 | 15.794 | 21.287 |
| hex: http/json-1kx1024 | 2099200 | 13804.5 ± 0.3% | 1464.2 ± 0.1% | 1067.1 ± 0.1% | 608.9 ± 0.6% | 986.3 ± 0.1% | 692.7 ± 0.1% | 9.428 | 12.936 | 22.670 | 13.996 | 19.928 |
| hex: http/json-16kx64 | 2097280 | 15315.2 ± 0.8% | 1446.2 ± 0.1% | 1073.7 ± 0.3% | 616.3 ± 0.4% | 994.8 ± 0.3% | 735.0 ± 0.3% | 10.590 | 14.264 | 24.850 | 15.396 | 20.836 |
| hex: http/json-1m | 524290 | 15644.9 ± 0.7% | 1472.0 ± 0.5% | 1091.1 ± 0.4% | 635.5 ± 0.9% | 990.9 ± 0.4% | 732.7 ± 1.1% | 10.629 | 14.338 | 24.620 | 15.789 | 21.351 |
| hex: http/js-1kx1024 | 2099200 | 13753.2 ± 0.5% | 1455.1 ± 0.5% | 1063.3 ± 0.3% | 498.9 ± 0.4% | 983.7 ± 0.7% | 692.8 ± 0.1% | 9.452 | 12.934 | 27.564 | 13.982 | 19.851 |
| hex: http/js-16kx64 | 2097280 | 15215.3 ± 0.4% | 1442.3 ± 0.4% | 1075.5 ± 0.4% | 505.4 ± 0.6% | 994.4 ± 0.5% | 734.6 ± 0.2% | 10.549 | 14.147 | 30.103 | 15.301 | 20.711 |
| hex: http/js-1m | 524290 | 15669.6 ± 0.5% | 1464.2 ± 0.5% | 1085.4 ± 0.4% | 510.7 ± 0.5% | 990.1 ± 0.3% | 733.6 ± 0.5% | 10.702 | 14.436 | 30.681 | 15.826 | 21.360 |
| hex: http/css-1kx1024 | 2099200 | 13759.5 ± 0.5% | 1455.5 ± 0.6% | 1063.2 ± 0.3% | 531.7 ± 0.3% | 983.0 ± 0.2% | 692.6 ± 1.2% | 9.454 | 12.942 | 25.877 | 13.997 | 19.867 |
| hex: http/css-16kx64 | 2097280 | 15260.2 ± 1.0% | 1444.5 ± 0.2% | 1072.8 ± 0.2% | 542.6 ± 0.6% | 998.6 ± 0.1% | 735.3 ± 0.3% | 10.564 | 14.225 | 28.122 | 15.281 | 20.755 |
| hex: http/css-1m | 524290 | 15697.8 ± 0.2% | 1465.4 ± 0.3% | 1085.5 ± 0.4% | 526.6 ± 1.0% | 988.1 ± 0.2% | 734.9 ± 0.6% | 10.713 | 14.462 | 29.812 | 15.887 | 21.360 |
| hex: shuffled/dickens-1m | 524290 | 15699.4 ± 0.2% | 1468.2 ± 0.6% | 1084.0 ± 0.9% | 503.2 ± 0.6% | 985.8 ± 0.1% | 733.1 ± 0.7% | 10.693 | 14.483 | 31.197 | 15.925 | 21.416 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 936.7 ± 0.1% | 928.8 ± 0.6% | 1020.3 ± 0.2% | 300.9 ± 0.7% | 665.6 ± 0.3% | 309.6 ± 2.1% | 1.008 | 0.918 | 3.113 | 1.407 | 3.026 |
| qlog records, JSON text sequence | 1467503 | 776.9 ± 0.7% | 817.2 ± 0.2% | 767.1 ± 1.4% | 243.1 ± 1.1% | 697.5 ± 1.1% | 245.3 ± 3.2% | 0.951 | 1.013 | 3.196 | 1.114 | 3.166 |
| string: silesia/dickens | 172528 | 5053.1 ± 0.3% | 1876.3 ± 0.2% | 2647.0 ± 0.2% | 362.2 ± 0.4% | 2864.8 ± 0.4% | 550.3 ± 0.9% | 2.693 | 1.909 | 13.951 | 1.764 | 9.182 |
| string: silesia/nci | 1075110 | 4300.5 ± 0.3% | 2235.1 ± 0.5% | 2990.3 ± 0.4% | 543.0 ± 2.3% | 2959.8 ± 1.0% | 603.2 ± 0.7% | 1.924 | 1.438 | 7.920 | 1.453 | 7.130 |
| string: silesia/reymont | 1075159 | 2993.1 ± 2.8% | 1806.8 ± 1.8% | 2063.2 ± 0.2% | 375.0 ± 1.2% | 2146.1 ± 0.3% | 533.2 ± 0.6% | 1.657 | 1.451 | 7.983 | 1.395 | 5.613 |
| string: silesia/samba | 97582 | 3500.1 ± 0.6% | 2025.4 ± 0.2% | 2614.4 ± 0.4% | 323.0 ± 0.7% | 1498.4 ± 0.3% | 427.1 ± 0.9% | 1.728 | 1.339 | 10.836 | 2.336 | 8.194 |
| string: silesia/webster | 1098490 | 3670.5 ± 0.7% | 1517.0 ± 0.4% | 2006.9 ± 0.7% | 358.8 ± 0.3% | 2164.3 ± 0.8% | 491.1 ± 1.2% | 2.420 | 1.829 | 10.230 | 1.696 | 7.474 |
| string: silesia/xml | 1090118 | 4813.3 ± 0.3% | 2355.2 ± 0.3% | 2524.1 ± 0.6% | 454.7 ± 0.6% | 2795.4 ± 1.3% | 564.3 ± 0.8% | 2.044 | 1.907 | 10.585 | 1.722 | 8.530 |
| string: canterbury/alice29.txt | 159425 | 4345.4 ± 1.8% | 1599.6 ± 0.3% | 2460.7 ± 0.9% | 342.8 ± 0.6% | 2507.4 ± 0.6% | 502.7 ± 1.0% | 2.716 | 1.766 | 12.676 | 1.733 | 8.645 |
| string: canterbury/asyoulik.txt | 132198 | 3507.8 ± 0.4% | 1458.8 ± 0.2% | 2242.0 ± 0.6% | 335.2 ± 1.1% | 2089.3 ± 0.4% | 456.7 ± 2.1% | 2.405 | 1.565 | 10.466 | 1.679 | 7.681 |
| string: canterbury/lcet10.txt | 441884 | 5117.3 ± 0.4% | 1852.3 ± 0.3% | 2329.9 ± 1.1% | 389.5 ± 0.7% | 2839.4 ± 0.3% | 536.3 ± 2.4% | 2.763 | 2.196 | 13.137 | 1.802 | 9.541 |
| string: canterbury/plrabn12.txt | 503330 | 4127.4 ± 0.4% | 1734.6 ± 0.2% | 2057.6 ± 0.7% | 363.1 ± 0.5% | 2466.8 ± 0.5% | 497.9 ± 0.8% | 2.379 | 2.006 | 11.366 | 1.673 | 8.290 |
| string: canterbury-large/E.coli | 1048578 | 11890.3 ± 0.5% | 3607.7 ± 0.5% | 3253.6 ± 0.2% | 928.4 ± 0.9% | 5960.7 ± 1.3% | 751.1 ± 1.0% | 3.296 | 3.654 | 12.808 | 1.995 | 15.831 |
| string: canterbury-large/bible.txt | 1055886 | 6905.6 ± 1.3% | 2937.8 ± 0.7% | 2841.3 ± 0.6% | 424.4 ± 3.5% | 3745.5 ± 1.5% | 613.1 ± 0.7% | 2.351 | 2.430 | 16.270 | 1.844 | 11.264 |
| string: canterbury-large/world192.txt | 1103121 | 3400.0 ± 0.3% | 1482.6 ± 0.6% | 2009.6 ± 0.4% | 353.1 ± 0.8% | 2124.4 ± 1.5% | 500.1 ± 1.0% | 2.293 | 1.692 | 9.628 | 1.600 | 6.798 |
| string: http/html-1m | 1058582 | 6204.2 ± 0.6% | 2733.2 ± 0.5% | 2698.7 ± 0.6% | 441.9 ± 0.4% | 3479.4 ± 0.5% | 599.4 ± 0.4% | 2.270 | 2.299 | 14.040 | 1.783 | 10.351 |
| string: http/json-1m | 1190272 | 2559.3 ± 0.5% | 877.9 ± 0.2% | 2252.4 ± 0.3% | 389.7 ± 0.4% | 1045.2 ± 2.8% | 442.9 ± 0.9% | 2.915 | 1.136 | 6.568 | 2.449 | 5.779 |
| string: http/js-1m | 1144362 | 2284.5 ± 0.7% | 1029.1 ± 0.2% | 1640.4 ± 0.5% | 321.2 ± 0.5% | 1515.0 ± 1.1% | 418.5 ± 0.7% | 2.220 | 1.393 | 7.112 | 1.508 | 5.459 |
| string: http/css-1m | 1097820 | 2656.6 ± 0.4% | 1674.2 ± 0.4% | 2224.1 ± 0.4% | 404.8 ± 1.5% | 1925.1 ± 1.4% | 488.4 ± 0.4% | 1.587 | 1.194 | 6.563 | 1.380 | 5.439 |
| string: dickens as Cyrillic and CJK | 1883069 | 3075.9 ± 0.4% | 1684.1 ± 0.3% | 893.0 ± 0.5% | 351.2 ± 0.2% | 666.5 ± 1.3% | 157.6 ± 0.6% | 1.826 | 3.444 | 8.758 | 4.615 | 19.520 |
| string: dickens as Cyrillic and CJK, as \u escapes | 5075485 | 1330.6 ± 0.2% | 980.0 ± 0.3% | 1193.3 ± 0.5% | 213.4 ± 0.2% | 469.7 ± 0.3% | 254.9 ± 3.7% | 1.358 | 1.115 | 6.236 | 2.833 | 5.220 |
| hex: silesia/dickens | 524290 | 11973.1 ± 0.1% | 3609.2 ± 0.3% | 3282.5 ± 0.3% | 509.3 ± 2.4% | 6133.0 ± 1.5% | 778.2 ± 2.1% | 3.317 | 3.648 | 23.510 | 1.952 | 15.386 |
| hex: silesia/mozilla | 524290 | 11962.5 ± 0.1% | 3600.0 ± 0.9% | 3292.5 ± 0.4% | 451.0 ± 3.4% | 6032.2 ± 0.9% | 779.7 ± 1.0% | 3.323 | 3.633 | 26.522 | 1.983 | 15.343 |
| hex: silesia/mr | 524290 | 11968.4 ± 0.3% | 3603.6 ± 0.3% | 3293.3 ± 0.3% | 570.1 ± 1.8% | 6062.6 ± 1.2% | 780.5 ± 0.3% | 3.321 | 3.634 | 20.994 | 1.974 | 15.335 |
| hex: silesia/nci | 524290 | 12006.5 ± 0.1% | 3601.7 ± 0.3% | 3281.1 ± 0.2% | 626.5 ± 2.1% | 6126.2 ± 1.4% | 780.6 ± 0.6% | 3.334 | 3.659 | 19.163 | 1.960 | 15.381 |
| hex: silesia/ooffice | 524290 | 12021.9 ± 0.1% | 3607.3 ± 0.4% | 3297.9 ± 0.4% | 401.9 ± 1.2% | 6106.5 ± 1.3% | 780.4 ± 1.0% | 3.333 | 3.645 | 29.910 | 1.969 | 15.404 |
| hex: silesia/osdb | 524290 | 11995.5 ± 0.1% | 3605.2 ± 0.3% | 3293.8 ± 0.4% | 481.6 ± 2.5% | 6138.0 ± 1.6% | 779.1 ± 0.3% | 3.327 | 3.642 | 24.907 | 1.954 | 15.397 |
| hex: silesia/reymont | 524290 | 11982.0 ± 0.4% | 3606.4 ± 0.4% | 3282.4 ± 0.3% | 520.9 ± 2.4% | 6083.7 ± 1.6% | 779.3 ± 0.9% | 3.322 | 3.650 | 23.003 | 1.970 | 15.376 |
| hex: silesia/samba | 524290 | 11960.3 ± 0.1% | 3601.9 ± 0.4% | 3281.8 ± 0.2% | 399.7 ± 1.3% | 6010.1 ± 1.3% | 780.5 ± 0.6% | 3.321 | 3.644 | 29.923 | 1.990 | 15.325 |
| hex: silesia/sao | 524290 | 11962.5 ± 0.2% | 3607.0 ± 0.4% | 3284.7 ± 0.2% | 343.4 ± 2.4% | 6109.5 ± 1.3% | 783.0 ± 0.7% | 3.316 | 3.642 | 34.833 | 1.958 | 15.277 |
| hex: silesia/webster | 524290 | 11991.6 ± 0.2% | 3603.2 ± 0.2% | 3291.4 ± 0.3% | 467.6 ± 1.0% | 6110.8 ± 1.9% | 781.5 ± 0.9% | 3.328 | 3.643 | 25.646 | 1.962 | 15.345 |
| hex: silesia/x-ray | 524290 | 12013.4 ± 0.1% | 3605.2 ± 0.4% | 3294.8 ± 0.3% | 476.2 ± 0.9% | 6132.8 ± 1.0% | 781.3 ± 0.7% | 3.332 | 3.646 | 25.229 | 1.959 | 15.376 |
| hex: silesia/xml | 524290 | 11982.8 ± 0.2% | 3604.0 ± 0.2% | 3291.5 ± 0.3% | 521.7 ± 0.4% | 5977.0 ± 0.7% | 782.2 ± 0.4% | 3.325 | 3.641 | 22.968 | 2.005 | 15.320 |
| hex: canterbury/alice29.txt | 304180 | 12010.4 ± 0.1% | 3637.6 ± 0.0% | 3342.0 ± 0.1% | 511.5 ± 0.5% | 6131.0 ± 1.3% | 781.9 ± 0.6% | 3.302 | 3.594 | 23.482 | 1.959 | 15.360 |
| hex: canterbury/asyoulik.txt | 250360 | 12005.6 ± 0.1% | 3640.2 ± 0.2% | 3370.0 ± 0.1% | 504.6 ± 0.2% | 6114.3 ± 1.1% | 779.6 ± 0.6% | 3.298 | 3.563 | 23.791 | 1.964 | 15.401 |
| hex: canterbury/cp.html | 49208 | 11929.5 ± 0.0% | 3638.6 ± 0.1% | 3289.0 ± 0.4% | 472.3 ± 2.9% | 6279.1 ± 0.2% | 761.1 ± 1.5% | 3.279 | 3.627 | 25.256 | 1.900 | 15.674 |
| hex: canterbury/fields.c | 22302 | 11786.7 ± 0.0% | 3628.0 ± 0.0% | 3353.6 ± 0.1% | 511.4 ± 0.4% | 6260.6 ± 0.3% | 753.5 ± 2.6% | 3.249 | 3.515 | 23.046 | 1.883 | 15.642 |
| hex: canterbury/grammar.lsp | 7444 | 11282.6 ± 0.1% | 3600.3 ± 0.0% | 3344.6 ± 0.5% | 537.6 ± 1.9% | 6162.3 ± 0.6% | 704.6 ± 3.7% | 3.134 | 3.373 | 20.989 | 1.831 | 16.012 |
| hex: canterbury/kennedy.xls | 524290 | 12004.2 ± 0.0% | 3609.6 ± 0.3% | 3295.2 ± 0.5% | 658.2 ± 2.5% | 6109.7 ± 1.0% | 778.8 ± 1.6% | 3.326 | 3.643 | 18.239 | 1.965 | 15.414 |
| hex: canterbury/lcet10.txt | 524290 | 12017.6 ± 0.1% | 3609.2 ± 0.2% | 3288.7 ± 0.5% | 510.8 ± 0.5% | 6085.4 ± 1.2% | 781.5 ± 1.0% | 3.330 | 3.654 | 23.528 | 1.975 | 15.378 |
| hex: canterbury/plrabn12.txt | 524290 | 12000.4 ± 0.5% | 3609.6 ± 0.1% | 3296.7 ± 0.4% | 500.8 ± 1.1% | 6142.3 ± 1.4% | 780.7 ± 0.3% | 3.325 | 3.640 | 23.961 | 1.954 | 15.371 |
| hex: canterbury/ptt5 | 524290 | 11964.1 ± 0.2% | 3609.0 ± 0.3% | 3285.3 ± 0.2% | 559.8 ± 0.3% | 6058.7 ± 1.5% | 781.1 ± 1.4% | 3.315 | 3.642 | 21.370 | 1.975 | 15.316 |
| hex: canterbury/sum | 76482 | 11919.9 ± 0.0% | 3632.8 ± 0.1% | 3362.0 ± 0.1% | 509.6 ± 0.2% | 6175.1 ± 0.3% | 768.7 ± 0.6% | 3.281 | 3.545 | 23.390 | 1.930 | 15.507 |
| hex: canterbury/xargs.1 | 8456 | 11359.7 ± 0.1% | 3601.7 ± 0.1% | 3375.0 ± 0.2% | 495.4 ± 1.2% | 6151.3 ± 0.3% | 746.3 ± 1.6% | 3.154 | 3.366 | 22.930 | 1.847 | 15.221 |
| hex: canterbury-large/E.coli | 524290 | 11988.6 ± 0.4% | 3606.7 ± 0.1% | 3286.1 ± 0.4% | 688.1 ± 0.2% | 6119.5 ± 1.2% | 760.2 ± 4.8% | 3.324 | 3.648 | 17.422 | 1.959 | 15.771 |
| hex: canterbury-large/bible.txt | 524290 | 12002.6 ± 0.1% | 3605.2 ± 0.2% | 3292.3 ± 0.1% | 526.6 ± 1.1% | 6095.3 ± 1.2% | 778.6 ± 0.8% | 3.329 | 3.646 | 22.793 | 1.969 | 15.416 |
| hex: canterbury-large/world192.txt | 524290 | 12018.2 ± 0.1% | 3605.7 ± 0.2% | 3287.5 ± 0.5% | 507.0 ± 1.8% | 6155.0 ± 1.0% | 781.4 ± 0.5% | 3.333 | 3.656 | 23.704 | 1.953 | 15.380 |
| hex: http/html-1kx1024 | 2099200 | 8711.2 ± 2.6% | 3456.0 ± 0.1% | 2845.9 ± 0.4% | 474.1 ± 0.6% | 5098.8 ± 1.6% | 643.0 ± 4.0% | 2.521 | 3.061 | 18.373 | 1.708 | 13.548 |
| hex: http/html-16kx64 | 2097280 | 11763.0 ± 0.4% | 3611.4 ± 0.1% | 3255.0 ± 0.3% | 477.8 ± 0.5% | 6033.6 ± 0.6% | 748.2 ± 1.7% | 3.257 | 3.614 | 24.618 | 1.950 | 15.722 |
| hex: http/html-1m | 524290 | 12001.1 ± 0.3% | 3601.7 ± 0.5% | 3286.0 ± 0.4% | 500.3 ± 3.4% | 6108.9 ± 1.1% | 775.7 ± 1.5% | 3.332 | 3.652 | 23.987 | 1.965 | 15.471 |
| hex: http/json-1kx1024 | 2099200 | 8693.0 ± 3.5% | 3457.4 ± 0.3% | 2848.4 ± 0.5% | 574.3 ± 0.9% | 5080.6 ± 1.8% | 644.9 ± 2.2% | 2.514 | 3.052 | 15.136 | 1.711 | 13.480 |
| hex: http/json-16kx64 | 2097280 | 11775.9 ± 0.2% | 3607.6 ± 0.2% | 3258.9 ± 0.3% | 575.2 ± 3.5% | 6025.9 ± 0.5% | 755.2 ± 1.5% | 3.264 | 3.613 | 20.472 | 1.954 | 15.592 |
| hex: http/json-1m | 524290 | 12021.6 ± 0.3% | 3612.4 ± 0.6% | 3289.8 ± 0.3% | 592.1 ± 2.0% | 6157.4 ± 1.3% | 775.5 ± 3.5% | 3.328 | 3.654 | 20.304 | 1.952 | 15.502 |
| hex: http/js-1kx1024 | 2099200 | 8732.1 ± 2.6% | 3463.4 ± 0.1% | 2853.6 ± 0.3% | 480.7 ± 0.6% | 5067.9 ± 0.6% | 653.3 ± 1.0% | 2.521 | 3.060 | 18.167 | 1.723 | 13.367 |
| hex: http/js-16kx64 | 2097280 | 11754.0 ± 0.1% | 3609.7 ± 0.2% | 3261.2 ± 0.2% | 478.7 ± 0.9% | 6041.1 ± 0.3% | 760.0 ± 1.9% | 3.256 | 3.604 | 24.551 | 1.946 | 15.465 |
| hex: http/js-1m | 524290 | 11930.6 ± 0.2% | 3604.9 ± 0.6% | 3275.7 ± 0.4% | 502.9 ± 2.1% | 6030.1 ± 0.5% | 762.5 ± 1.1% | 3.310 | 3.642 | 23.724 | 1.979 | 15.647 |
| hex: http/css-1kx1024 | 2099200 | 8702.1 ± 3.6% | 3456.2 ± 0.4% | 2853.2 ± 0.6% | 487.7 ± 0.5% | 5168.2 ± 1.0% | 641.9 ± 3.0% | 2.518 | 3.050 | 17.841 | 1.684 | 13.558 |
| hex: http/css-16kx64 | 2097280 | 11759.9 ± 0.3% | 3610.9 ± 0.2% | 3261.9 ± 0.3% | 496.4 ± 0.7% | 6025.8 ± 0.2% | 757.2 ± 1.4% | 3.257 | 3.605 | 23.690 | 1.952 | 15.531 |
| hex: http/css-1m | 524290 | 11965.6 ± 0.2% | 3609.6 ± 0.2% | 3292.7 ± 0.2% | 495.0 ± 2.4% | 6069.3 ± 1.5% | 766.6 ± 3.0% | 3.315 | 3.634 | 24.173 | 1.971 | 15.609 |
| hex: shuffled/dickens-1m | 524290 | 11974.0 ± 0.1% | 3606.5 ± 0.3% | 3275.7 ± 0.4% | 524.3 ± 2.8% | 5970.1 ± 0.4% | 765.4 ± 0.6% | 3.320 | 3.655 | 22.840 | 2.006 | 15.645 |

## TextReader.next_items against the baselines

stdx's decoder a slice of tokens a call through `TextReader.next_items`, as a caller that reads a text's values in a loop calls it (decision 79). Octets are the text's. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1013.5 ± 0.3% | 928.8 ± 0.6% | 1020.3 ± 0.2% | 300.9 ± 0.7% | 665.6 ± 0.3% | 309.6 ± 2.1% | 1.091 | 0.993 | 3.368 | 1.523 | 3.274 |
| qlog records, JSON text sequence | 1467503 | 836.3 ± 0.9% | 817.2 ± 0.2% | 767.1 ± 1.4% | 243.1 ± 1.1% | 697.5 ± 1.1% | 245.3 ± 3.2% | 1.023 | 1.090 | 3.441 | 1.199 | 3.409 |
| string: silesia/dickens | 172528 | 5054.2 ± 0.1% | 1876.3 ± 0.2% | 2647.0 ± 0.2% | 362.2 ± 0.4% | 2864.8 ± 0.4% | 550.3 ± 0.9% | 2.694 | 1.909 | 13.954 | 1.764 | 9.184 |
| string: silesia/nci | 1075110 | 4300.7 ± 0.9% | 2235.1 ± 0.5% | 2990.3 ± 0.4% | 543.0 ± 2.3% | 2959.8 ± 1.0% | 603.2 ± 0.7% | 1.924 | 1.438 | 7.920 | 1.453 | 7.130 |
| string: silesia/reymont | 1075159 | 2994.1 ± 2.7% | 1806.8 ± 1.8% | 2063.2 ± 0.2% | 375.0 ± 1.2% | 2146.1 ± 0.3% | 533.2 ± 0.6% | 1.657 | 1.451 | 7.985 | 1.395 | 5.615 |
| string: silesia/samba | 97582 | 3509.1 ± 0.6% | 2025.4 ± 0.2% | 2614.4 ± 0.4% | 323.0 ± 0.7% | 1498.4 ± 0.3% | 427.1 ± 0.9% | 1.733 | 1.342 | 10.864 | 2.342 | 8.216 |
| string: silesia/webster | 1098490 | 3672.9 ± 0.7% | 1517.0 ± 0.4% | 2006.9 ± 0.7% | 358.8 ± 0.3% | 2164.3 ± 0.8% | 491.1 ± 1.2% | 2.421 | 1.830 | 10.236 | 1.697 | 7.479 |
| string: silesia/xml | 1090118 | 4820.1 ± 0.4% | 2355.2 ± 0.3% | 2524.1 ± 0.6% | 454.7 ± 0.6% | 2795.4 ± 1.3% | 564.3 ± 0.8% | 2.047 | 1.910 | 10.600 | 1.724 | 8.542 |
| string: canterbury/alice29.txt | 159425 | 4353.6 ± 1.7% | 1599.6 ± 0.3% | 2460.7 ± 0.9% | 342.8 ± 0.6% | 2507.4 ± 0.6% | 502.7 ± 1.0% | 2.722 | 1.769 | 12.700 | 1.736 | 8.661 |
| string: canterbury/asyoulik.txt | 132198 | 3510.9 ± 0.5% | 1458.8 ± 0.2% | 2242.0 ± 0.6% | 335.2 ± 1.1% | 2089.3 ± 0.4% | 456.7 ± 2.1% | 2.407 | 1.566 | 10.475 | 1.680 | 7.687 |
| string: canterbury/lcet10.txt | 441884 | 5117.0 ± 0.5% | 1852.3 ± 0.3% | 2329.9 ± 1.1% | 389.5 ± 0.7% | 2839.4 ± 0.3% | 536.3 ± 2.4% | 2.762 | 2.196 | 13.136 | 1.802 | 9.541 |
| string: canterbury/plrabn12.txt | 503330 | 4125.3 ± 0.4% | 1734.6 ± 0.2% | 2057.6 ± 0.7% | 363.1 ± 0.5% | 2466.8 ± 0.5% | 497.9 ± 0.8% | 2.378 | 2.005 | 11.360 | 1.672 | 8.286 |
| string: canterbury-large/E.coli | 1048578 | 11920.8 ± 0.7% | 3607.7 ± 0.5% | 3253.6 ± 0.2% | 928.4 ± 0.9% | 5960.7 ± 1.3% | 751.1 ± 1.0% | 3.304 | 3.664 | 12.840 | 2.000 | 15.871 |
| string: canterbury-large/bible.txt | 1055886 | 6923.0 ± 0.9% | 2937.8 ± 0.7% | 2841.3 ± 0.6% | 424.4 ± 3.5% | 3745.5 ± 1.5% | 613.1 ± 0.7% | 2.356 | 2.437 | 16.311 | 1.848 | 11.292 |
| string: canterbury-large/world192.txt | 1103121 | 3395.8 ± 0.5% | 1482.6 ± 0.6% | 2009.6 ± 0.4% | 353.1 ± 0.8% | 2124.4 ± 1.5% | 500.1 ± 1.0% | 2.290 | 1.690 | 9.616 | 1.598 | 6.790 |
| string: http/html-1m | 1058582 | 6227.6 ± 1.7% | 2733.2 ± 0.5% | 2698.7 ± 0.6% | 441.9 ± 0.4% | 3479.4 ± 0.5% | 599.4 ± 0.4% | 2.278 | 2.308 | 14.093 | 1.790 | 10.390 |
| string: http/json-1m | 1190272 | 2557.2 ± 0.6% | 877.9 ± 0.2% | 2252.4 ± 0.3% | 389.7 ± 0.4% | 1045.2 ± 2.8% | 442.9 ± 0.9% | 2.913 | 1.135 | 6.563 | 2.446 | 5.774 |
| string: http/js-1m | 1144362 | 2288.7 ± 0.4% | 1029.1 ± 0.2% | 1640.4 ± 0.5% | 321.2 ± 0.5% | 1515.0 ± 1.1% | 418.5 ± 0.7% | 2.224 | 1.395 | 7.125 | 1.511 | 5.469 |
| string: http/css-1m | 1097820 | 2663.5 ± 0.3% | 1674.2 ± 0.4% | 2224.1 ± 0.4% | 404.8 ± 1.5% | 1925.1 ± 1.4% | 488.4 ± 0.4% | 1.591 | 1.198 | 6.580 | 1.384 | 5.453 |
| string: dickens as Cyrillic and CJK | 1883069 | 3077.2 ± 0.3% | 1684.1 ± 0.3% | 893.0 ± 0.5% | 351.2 ± 0.2% | 666.5 ± 1.3% | 157.6 ± 0.6% | 1.827 | 3.446 | 8.762 | 4.617 | 19.529 |
| string: dickens as Cyrillic and CJK, as \u escapes | 5075485 | 1329.8 ± 0.3% | 980.0 ± 0.3% | 1193.3 ± 0.5% | 213.4 ± 0.2% | 469.7 ± 0.3% | 254.9 ± 3.7% | 1.357 | 1.114 | 6.232 | 2.831 | 5.217 |
| hex: silesia/dickens | 524290 | 11982.7 ± 0.1% | 3609.2 ± 0.3% | 3282.5 ± 0.3% | 509.3 ± 2.4% | 6133.0 ± 1.5% | 778.2 ± 2.1% | 3.320 | 3.650 | 23.529 | 1.954 | 15.399 |
| hex: silesia/mozilla | 524290 | 11948.4 ± 0.2% | 3600.0 ± 0.9% | 3292.5 ± 0.4% | 451.0 ± 3.4% | 6032.2 ± 0.9% | 779.7 ± 1.0% | 3.319 | 3.629 | 26.490 | 1.981 | 15.325 |
| hex: silesia/mr | 524290 | 11948.8 ± 0.4% | 3603.6 ± 0.3% | 3293.3 ± 0.3% | 570.1 ± 1.8% | 6062.6 ± 1.2% | 780.5 ± 0.3% | 3.316 | 3.628 | 20.960 | 1.971 | 15.310 |
| hex: silesia/nci | 524290 | 12008.9 ± 0.1% | 3601.7 ± 0.3% | 3281.1 ± 0.2% | 626.5 ± 2.1% | 6126.2 ± 1.4% | 780.6 ± 0.6% | 3.334 | 3.660 | 19.167 | 1.960 | 15.384 |
| hex: silesia/ooffice | 524290 | 12022.2 ± 0.1% | 3607.3 ± 0.4% | 3297.9 ± 0.4% | 401.9 ± 1.2% | 6106.5 ± 1.3% | 780.4 ± 1.0% | 3.333 | 3.645 | 29.911 | 1.969 | 15.405 |
| hex: silesia/osdb | 524290 | 12005.7 ± 0.1% | 3605.2 ± 0.3% | 3293.8 ± 0.4% | 481.6 ± 2.5% | 6138.0 ± 1.6% | 779.1 ± 0.3% | 3.330 | 3.645 | 24.928 | 1.956 | 15.410 |
| hex: silesia/reymont | 524290 | 11992.6 ± 0.2% | 3606.4 ± 0.4% | 3282.4 ± 0.3% | 520.9 ± 2.4% | 6083.7 ± 1.6% | 779.3 ± 0.9% | 3.325 | 3.654 | 23.023 | 1.971 | 15.389 |
| hex: silesia/samba | 524290 | 11952.8 ± 0.2% | 3601.9 ± 0.4% | 3281.8 ± 0.2% | 399.7 ± 1.3% | 6010.1 ± 1.3% | 780.5 ± 0.6% | 3.319 | 3.642 | 29.904 | 1.989 | 15.315 |
| hex: silesia/sao | 524290 | 11962.1 ± 0.3% | 3607.0 ± 0.4% | 3284.7 ± 0.2% | 343.4 ± 2.4% | 6109.5 ± 1.3% | 783.0 ± 0.7% | 3.316 | 3.642 | 34.831 | 1.958 | 15.277 |
| hex: silesia/webster | 524290 | 11986.3 ± 0.2% | 3603.2 ± 0.2% | 3291.4 ± 0.3% | 467.6 ± 1.0% | 6110.8 ± 1.9% | 781.5 ± 0.9% | 3.327 | 3.642 | 25.635 | 1.961 | 15.338 |
| hex: silesia/x-ray | 524290 | 12012.3 ± 0.1% | 3605.2 ± 0.4% | 3294.8 ± 0.3% | 476.2 ± 0.9% | 6132.8 ± 1.0% | 781.3 ± 0.7% | 3.332 | 3.646 | 25.227 | 1.959 | 15.375 |
| hex: silesia/xml | 524290 | 11978.4 ± 0.2% | 3604.0 ± 0.2% | 3291.5 ± 0.3% | 521.7 ± 0.4% | 5977.0 ± 0.7% | 782.2 ± 0.4% | 3.324 | 3.639 | 22.960 | 2.004 | 15.315 |
| hex: canterbury/alice29.txt | 304180 | 11999.4 ± 0.2% | 3637.6 ± 0.0% | 3342.0 ± 0.1% | 511.5 ± 0.5% | 6131.0 ± 1.3% | 781.9 ± 0.6% | 3.299 | 3.590 | 23.461 | 1.957 | 15.346 |
| hex: canterbury/asyoulik.txt | 250360 | 12011.0 ± 0.1% | 3640.2 ± 0.2% | 3370.0 ± 0.1% | 504.6 ± 0.2% | 6114.3 ± 1.1% | 779.6 ± 0.6% | 3.300 | 3.564 | 23.802 | 1.964 | 15.407 |
| hex: canterbury/cp.html | 49208 | 11926.1 ± 0.1% | 3638.6 ± 0.1% | 3289.0 ± 0.4% | 472.3 ± 2.9% | 6279.1 ± 0.2% | 761.1 ± 1.5% | 3.278 | 3.626 | 25.249 | 1.899 | 15.670 |
| hex: canterbury/fields.c | 22302 | 11783.1 ± 0.0% | 3628.0 ± 0.0% | 3353.6 ± 0.1% | 511.4 ± 0.4% | 6260.6 ± 0.3% | 753.5 ± 2.6% | 3.248 | 3.514 | 23.039 | 1.882 | 15.637 |
| hex: canterbury/grammar.lsp | 7444 | 11327.7 ± 0.3% | 3600.3 ± 0.0% | 3344.6 ± 0.5% | 537.6 ± 1.9% | 6162.3 ± 0.6% | 704.6 ± 3.7% | 3.146 | 3.387 | 21.073 | 1.838 | 16.076 |
| hex: canterbury/kennedy.xls | 524290 | 12003.7 ± 0.2% | 3609.6 ± 0.3% | 3295.2 ± 0.5% | 658.2 ± 2.5% | 6109.7 ± 1.0% | 778.8 ± 1.6% | 3.325 | 3.643 | 18.238 | 1.965 | 15.413 |
| hex: canterbury/lcet10.txt | 524290 | 12018.0 ± 0.2% | 3609.2 ± 0.2% | 3288.7 ± 0.5% | 510.8 ± 0.5% | 6085.4 ± 1.2% | 781.5 ± 1.0% | 3.330 | 3.654 | 23.529 | 1.975 | 15.378 |
| hex: canterbury/plrabn12.txt | 524290 | 12008.0 ± 0.1% | 3609.6 ± 0.1% | 3296.7 ± 0.4% | 500.8 ± 1.1% | 6142.3 ± 1.4% | 780.7 ± 0.3% | 3.327 | 3.642 | 23.976 | 1.955 | 15.381 |
| hex: canterbury/ptt5 | 524290 | 11956.0 ± 0.2% | 3609.0 ± 0.3% | 3285.3 ± 0.2% | 559.8 ± 0.3% | 6058.7 ± 1.5% | 781.1 ± 1.4% | 3.313 | 3.639 | 21.356 | 1.973 | 15.306 |
| hex: canterbury/sum | 76482 | 11917.7 ± 0.1% | 3632.8 ± 0.1% | 3362.0 ± 0.1% | 509.6 ± 0.2% | 6175.1 ± 0.3% | 768.7 ± 0.6% | 3.281 | 3.545 | 23.385 | 1.930 | 15.504 |
| hex: canterbury/xargs.1 | 8456 | 11350.4 ± 0.0% | 3601.7 ± 0.1% | 3375.0 ± 0.2% | 495.4 ± 1.2% | 6151.3 ± 0.3% | 746.3 ± 1.6% | 3.151 | 3.363 | 22.911 | 1.845 | 15.209 |
| hex: canterbury-large/E.coli | 524290 | 11984.9 ± 0.1% | 3606.7 ± 0.1% | 3286.1 ± 0.4% | 688.1 ± 0.2% | 6119.5 ± 1.2% | 760.2 ± 4.8% | 3.323 | 3.647 | 17.417 | 1.958 | 15.766 |
| hex: canterbury-large/bible.txt | 524290 | 12006.1 ± 0.2% | 3605.2 ± 0.2% | 3292.3 ± 0.1% | 526.6 ± 1.1% | 6095.3 ± 1.2% | 778.6 ± 0.8% | 3.330 | 3.647 | 22.799 | 1.970 | 15.421 |
| hex: canterbury-large/world192.txt | 524290 | 12022.0 ± 0.2% | 3605.7 ± 0.2% | 3287.5 ± 0.5% | 507.0 ± 1.8% | 6155.0 ± 1.0% | 781.4 ± 0.5% | 3.334 | 3.657 | 23.711 | 1.953 | 15.385 |
| hex: http/html-1kx1024 | 2099200 | 8783.9 ± 3.7% | 3456.0 ± 0.1% | 2845.9 ± 0.4% | 474.1 ± 0.6% | 5098.8 ± 1.6% | 643.0 ± 4.0% | 2.542 | 3.086 | 18.527 | 1.723 | 13.661 |
| hex: http/html-16kx64 | 2097280 | 11767.3 ± 0.1% | 3611.4 ± 0.1% | 3255.0 ± 0.3% | 477.8 ± 0.5% | 6033.6 ± 0.6% | 748.2 ± 1.7% | 3.258 | 3.615 | 24.627 | 1.950 | 15.728 |
| hex: http/html-1m | 524290 | 11997.7 ± 0.2% | 3601.7 ± 0.5% | 3286.0 ± 0.4% | 500.3 ± 3.4% | 6108.9 ± 1.1% | 775.7 ± 1.5% | 3.331 | 3.651 | 23.981 | 1.964 | 15.467 |
| hex: http/json-1kx1024 | 2099200 | 8791.7 ± 4.6% | 3457.4 ± 0.3% | 2848.4 ± 0.5% | 574.3 ± 0.9% | 5080.6 ± 1.8% | 644.9 ± 2.2% | 2.543 | 3.087 | 15.308 | 1.730 | 13.633 |
| hex: http/json-16kx64 | 2097280 | 11783.1 ± 0.1% | 3607.6 ± 0.2% | 3258.9 ± 0.3% | 575.2 ± 3.5% | 6025.9 ± 0.5% | 755.2 ± 1.5% | 3.266 | 3.616 | 20.485 | 1.955 | 15.602 |
| hex: http/json-1m | 524290 | 12021.1 ± 0.1% | 3612.4 ± 0.6% | 3289.8 ± 0.3% | 592.1 ± 2.0% | 6157.4 ± 1.3% | 775.5 ± 3.5% | 3.328 | 3.654 | 20.303 | 1.952 | 15.501 |
| hex: http/js-1kx1024 | 2099200 | 8864.2 ± 3.1% | 3463.4 ± 0.1% | 2853.6 ± 0.3% | 480.7 ± 0.6% | 5067.9 ± 0.6% | 653.3 ± 1.0% | 2.559 | 3.106 | 18.442 | 1.749 | 13.569 |
| hex: http/js-16kx64 | 2097280 | 11770.1 ± 0.1% | 3609.7 ± 0.2% | 3261.2 ± 0.2% | 478.7 ± 0.9% | 6041.1 ± 0.3% | 760.0 ± 1.9% | 3.261 | 3.609 | 24.585 | 1.948 | 15.486 |
| hex: http/js-1m | 524290 | 11930.7 ± 0.6% | 3604.9 ± 0.6% | 3275.7 ± 0.4% | 502.9 ± 2.1% | 6030.1 ± 0.5% | 762.5 ± 1.1% | 3.310 | 3.642 | 23.724 | 1.979 | 15.647 |
| hex: http/css-1kx1024 | 2099200 | 8806.6 ± 3.7% | 3456.2 ± 0.4% | 2853.2 ± 0.6% | 487.7 ± 0.5% | 5168.2 ± 1.0% | 641.9 ± 3.0% | 2.548 | 3.087 | 18.056 | 1.704 | 13.720 |
| hex: http/css-16kx64 | 2097280 | 11772.3 ± 0.2% | 3610.9 ± 0.2% | 3261.9 ± 0.3% | 496.4 ± 0.7% | 6025.8 ± 0.2% | 757.2 ± 1.4% | 3.260 | 3.609 | 23.715 | 1.954 | 15.547 |
| hex: http/css-1m | 524290 | 11977.3 ± 0.3% | 3609.6 ± 0.2% | 3292.7 ± 0.2% | 495.0 ± 2.4% | 6069.3 ± 1.5% | 766.6 ± 3.0% | 3.318 | 3.638 | 24.197 | 1.973 | 15.624 |
| hex: shuffled/dickens-1m | 524290 | 11981.4 ± 0.2% | 3606.5 ± 0.3% | 3275.7 ± 0.4% | 524.3 ± 2.8% | 5970.1 ± 0.4% | 765.4 ± 0.6% | 3.322 | 3.658 | 22.854 | 2.007 | 15.654 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1357.1 ± 0.4% | 1251.2 ± 0.6% | 1041.0 ± 0.5% | 408.9 ± 0.3% | 448.5 ± 0.8% | 416.1 ± 0.6% | 1.085 | 1.304 | 3.319 | 3.026 | 3.261 |
| qlog records, JSON text sequence | 1467503 | 1053.9 ± 0.1% | 1064.1 ± 0.4% | 781.7 ± 0.4% | 377.4 ± 0.7% | 458.5 ± 0.4% | 278.8 ± 0.9% | 0.990 | 1.348 | 2.793 | 2.298 | 3.781 |
| string: silesia/dickens | 172528 | 6921.7 ± 0.3% | 2807.5 ± 0.5% | 2940.6 ± 0.5% | 431.7 ± 0.3% | 1564.8 ± 0.3% | 1010.7 ± 0.1% | 2.465 | 2.354 | 16.035 | 4.423 | 6.849 |
| string: silesia/nci | 1075110 | 7308.0 ± 1.4% | 3413.2 ± 6.8% | 3093.3 ± 2.7% | 809.0 ± 1.7% | 1830.1 ± 0.4% | 1107.3 ± 0.4% | 2.141 | 2.363 | 9.033 | 3.993 | 6.600 |
| string: silesia/reymont | 1075159 | 3316.4 ± 1.8% | 1977.8 ± 1.2% | 2058.9 ± 0.5% | 451.3 ± 0.4% | 1489.0 ± 1.1% | 949.5 ± 0.9% | 1.677 | 1.611 | 7.348 | 2.227 | 3.493 |
| string: silesia/samba | 97582 | 4209.0 ± 0.4% | 2103.1 ± 0.9% | 3464.9 ± 0.3% | 353.9 ± 0.5% | 1408.5 ± 0.5% | 1055.6 ± 0.3% | 2.001 | 1.215 | 11.894 | 2.988 | 3.987 |
| string: silesia/webster | 1098490 | 4080.0 ± 0.5% | 1879.5 ± 0.3% | 2054.5 ± 0.6% | 440.1 ± 0.5% | 1373.4 ± 0.4% | 647.3 ± 0.8% | 2.171 | 1.986 | 9.270 | 2.971 | 6.303 |
| string: silesia/xml | 1090118 | 6131.4 ± 0.4% | 2866.4 ± 0.4% | 2648.9 ± 0.9% | 606.2 ± 0.9% | 1731.8 ± 0.5% | 919.9 ± 0.6% | 2.139 | 2.315 | 10.115 | 3.540 | 6.665 |
| string: canterbury/alice29.txt | 159425 | 6450.1 ± 0.5% | 2192.0 ± 0.4% | 2762.4 ± 0.8% | 407.9 ± 0.4% | 1438.1 ± 0.2% | 955.1 ± 0.2% | 2.943 | 2.335 | 15.813 | 4.485 | 6.753 |
| string: canterbury/asyoulik.txt | 132198 | 5652.8 ± 0.8% | 1711.3 ± 0.6% | 2376.2 ± 0.6% | 402.5 ± 0.6% | 1310.8 ± 0.2% | 886.0 ± 0.2% | 3.303 | 2.379 | 14.044 | 4.313 | 6.380 |
| string: canterbury/lcet10.txt | 441884 | 6277.7 ± 0.4% | 2566.9 ± 0.4% | 2511.1 ± 2.0% | 468.7 ± 0.2% | 1522.8 ± 1.1% | 982.2 ± 0.3% | 2.446 | 2.500 | 13.395 | 4.122 | 6.391 |
| string: canterbury/plrabn12.txt | 503330 | 5725.7 ± 0.3% | 2052.0 ± 0.2% | 2070.5 ± 0.3% | 424.0 ± 0.6% | 1364.4 ± 0.2% | 935.9 ± 0.5% | 2.790 | 2.765 | 13.503 | 4.197 | 6.118 |
| string: canterbury-large/E.coli | 1048578 | 19167.5 ± 3.1% | 9753.9 ± 4.3% | 3785.3 ± 0.4% | 1473.7 ± 0.4% | 2356.0 ± 0.5% | 1193.5 ± 0.4% | 1.965 | 5.064 | 13.007 | 8.136 | 16.060 |
| string: canterbury-large/bible.txt | 1055886 | 6800.9 ± 0.6% | 4144.8 ± 0.8% | 3053.5 ± 0.8% | 504.5 ± 0.9% | 1981.2 ± 0.4% | 1120.5 ± 1.0% | 1.641 | 2.227 | 13.482 | 3.433 | 6.069 |
| string: canterbury-large/world192.txt | 1103121 | 4058.7 ± 0.7% | 1657.0 ± 0.6% | 1996.4 ± 0.3% | 449.1 ± 0.5% | 1341.7 ± 0.5% | 908.4 ± 0.4% | 2.449 | 2.033 | 9.037 | 3.025 | 4.468 |
| string: http/html-1m | 1058582 | 6773.7 ± 0.6% | 3938.9 ± 0.6% | 3022.5 ± 0.7% | 498.5 ± 0.7% | 1923.1 ± 0.4% | 803.6 ± 0.6% | 1.720 | 2.241 | 13.587 | 3.522 | 8.429 |
| string: http/json-1m | 1190272 | 3165.5 ± 0.3% | 1354.8 ± 0.1% | 1556.2 ± 0.6% | 443.3 ± 0.4% | 1036.1 ± 0.1% | 764.8 ± 0.3% | 2.336 | 2.034 | 7.141 | 3.055 | 4.139 |
| string: http/js-1m | 1144362 | 2770.6 ± 0.9% | 1179.9 ± 0.3% | 1624.6 ± 0.4% | 367.9 ± 0.3% | 1084.8 ± 0.3% | 758.5 ± 0.2% | 2.348 | 1.705 | 7.530 | 2.554 | 3.653 |
| string: http/css-1m | 1097820 | 4013.8 ± 0.7% | 1491.6 ± 0.4% | 2146.0 ± 1.0% | 493.1 ± 0.4% | 1355.9 ± 0.2% | 896.5 ± 0.2% | 2.691 | 1.870 | 8.140 | 2.960 | 4.477 |
| string: dickens as Cyrillic and CJK | 1883069 | 3074.4 ± 0.6% | 2333.0 ± 0.3% | 521.9 ± 0.2% | 308.2 ± 0.5% | 561.9 ± 1.1% | 336.2 ± 0.2% | 1.318 | 5.890 | 9.976 | 5.471 | 9.144 |
| hex: silesia/dickens | 524290 | 15667.6 ± 0.2% | 1463.5 ± 0.8% | 1084.1 ± 0.4% | 504.2 ± 0.8% | 986.2 ± 0.3% | 733.8 ± 0.6% | 10.705 | 14.452 | 31.076 | 15.886 | 21.352 |
| hex: silesia/mozilla | 524290 | 15665.5 ± 0.3% | 1469.9 ± 0.4% | 1086.6 ± 0.3% | 441.7 ± 0.9% | 995.9 ± 0.4% | 733.0 ± 0.6% | 10.657 | 14.416 | 35.465 | 15.730 | 21.372 |
| hex: silesia/mr | 524290 | 15551.7 ± 0.8% | 1479.0 ± 0.3% | 1094.8 ± 0.3% | 560.0 ± 1.2% | 992.9 ± 0.4% | 732.8 ± 0.3% | 10.515 | 14.205 | 27.772 | 15.663 | 21.221 |
| hex: silesia/nci | 524290 | 15700.0 ± 0.3% | 1468.9 ± 0.2% | 1089.1 ± 0.3% | 630.5 ± 2.4% | 994.0 ± 1.1% | 733.8 ± 0.5% | 10.688 | 14.416 | 24.901 | 15.794 | 21.395 |
| hex: silesia/ooffice | 524290 | 15573.3 ± 0.9% | 1463.2 ± 0.6% | 1084.1 ± 0.6% | 389.6 ± 0.4% | 988.6 ± 0.4% | 732.4 ± 0.6% | 10.644 | 14.365 | 39.972 | 15.753 | 21.264 |
| hex: silesia/osdb | 524290 | 15601.7 ± 0.3% | 1468.2 ± 0.2% | 1086.5 ± 0.6% | 469.7 ± 1.2% | 989.4 ± 0.5% | 733.6 ± 0.4% | 10.627 | 14.359 | 33.218 | 15.769 | 21.267 |
| hex: silesia/reymont | 524290 | 15631.4 ± 0.8% | 1464.1 ± 0.6% | 1085.2 ± 0.6% | 513.9 ± 0.8% | 987.0 ± 0.5% | 734.8 ± 0.5% | 10.677 | 14.405 | 30.414 | 15.838 | 21.274 |
| hex: silesia/samba | 524290 | 15631.7 ± 0.3% | 1464.7 ± 0.3% | 1085.3 ± 0.3% | 402.8 ± 0.6% | 991.0 ± 0.5% | 732.8 ± 1.6% | 10.672 | 14.404 | 38.811 | 15.773 | 21.333 |
| hex: silesia/sao | 524290 | 15558.3 ± 0.4% | 1465.6 ± 0.5% | 1081.4 ± 0.6% | 332.5 ± 0.3% | 988.2 ± 0.5% | 734.5 ± 0.4% | 10.616 | 14.387 | 46.787 | 15.744 | 21.183 |
| hex: silesia/webster | 524290 | 15623.6 ± 0.2% | 1463.7 ± 0.2% | 1086.0 ± 0.5% | 475.4 ± 0.4% | 996.0 ± 0.6% | 735.1 ± 0.5% | 10.674 | 14.387 | 32.864 | 15.687 | 21.253 |
| hex: silesia/x-ray | 524290 | 15609.5 ± 0.6% | 1473.2 ± 0.4% | 1087.8 ± 0.2% | 446.9 ± 0.8% | 994.7 ± 0.5% | 734.8 ± 0.6% | 10.596 | 14.350 | 34.931 | 15.694 | 21.242 |
| hex: silesia/xml | 524290 | 15635.9 ± 0.6% | 1466.7 ± 0.4% | 1086.6 ± 0.6% | 610.3 ± 0.5% | 996.2 ± 0.3% | 734.8 ± 0.7% | 10.661 | 14.390 | 25.618 | 15.696 | 21.279 |
| hex: canterbury/alice29.txt | 304180 | 15706.4 ± 0.1% | 1470.5 ± 0.6% | 1094.4 ± 0.4% | 502.0 ± 3.3% | 994.5 ± 0.5% | 736.8 ± 0.7% | 10.681 | 14.351 | 31.288 | 15.793 | 21.316 |
| hex: canterbury/asyoulik.txt | 250360 | 15721.4 ± 0.0% | 1479.8 ± 0.4% | 1095.5 ± 0.3% | 499.7 ± 1.2% | 995.8 ± 0.4% | 739.7 ± 0.5% | 10.624 | 14.351 | 31.463 | 15.788 | 21.254 |
| hex: canterbury/cp.html | 49208 | 15666.5 ± 0.0% | 1480.7 ± 0.7% | 1097.8 ± 0.3% | 525.0 ± 2.1% | 1002.6 ± 0.4% | 743.1 ± 0.1% | 10.580 | 14.271 | 29.843 | 15.626 | 21.083 |
| hex: canterbury/fields.c | 22302 | 15522.2 ± 0.1% | 1410.4 ± 0.8% | 1069.3 ± 1.0% | 624.4 ± 3.6% | 991.4 ± 0.1% | 736.7 ± 0.1% | 11.005 | 14.517 | 24.858 | 15.658 | 21.069 |
| hex: canterbury/grammar.lsp | 7444 | 15161.9 ± 0.1% | 1507.4 ± 0.2% | 1095.7 ± 0.4% | 671.9 ± 1.0% | 989.6 ± 0.5% | 726.2 ± 0.1% | 10.058 | 13.838 | 22.566 | 15.321 | 20.878 |
| hex: canterbury/kennedy.xls | 524290 | 15557.2 ± 0.3% | 1470.8 ± 0.2% | 1087.3 ± 0.6% | 657.7 ± 0.5% | 990.6 ± 0.4% | 733.4 ± 0.7% | 10.577 | 14.309 | 23.655 | 15.705 | 21.211 |
| hex: canterbury/lcet10.txt | 524290 | 15639.3 ± 0.2% | 1459.4 ± 0.5% | 1086.1 ± 0.2% | 499.0 ± 1.8% | 986.8 ± 0.2% | 732.5 ± 0.8% | 10.716 | 14.400 | 31.338 | 15.848 | 21.352 |
| hex: canterbury/plrabn12.txt | 524290 | 15670.4 ± 0.3% | 1463.7 ± 0.4% | 1084.1 ± 0.7% | 489.7 ± 0.5% | 990.4 ± 0.5% | 732.9 ± 0.4% | 10.706 | 14.455 | 31.997 | 15.823 | 21.383 |
| hex: canterbury/ptt5 | 524290 | 15608.0 ± 0.5% | 1479.2 ± 0.4% | 1090.2 ± 0.3% | 553.3 ± 1.2% | 993.5 ± 0.4% | 734.0 ± 0.5% | 10.552 | 14.317 | 28.208 | 15.709 | 21.264 |
| hex: canterbury/sum | 76482 | 15678.7 ± 0.0% | 1494.7 ± 0.1% | 1104.2 ± 0.1% | 598.1 ± 2.6% | 998.3 ± 0.1% | 744.1 ± 0.8% | 10.490 | 14.199 | 26.215 | 15.706 | 21.070 |
| hex: canterbury/xargs.1 | 8456 | 15204.4 ± 0.1% | 1494.6 ± 0.4% | 1091.5 ± 0.7% | 656.3 ± 5.2% | 1000.2 ± 0.2% | 728.7 ± 0.1% | 10.173 | 13.930 | 23.165 | 15.201 | 20.864 |
| hex: canterbury-large/E.coli | 524290 | 15706.9 ± 0.2% | 1471.9 ± 0.4% | 1091.5 ± 0.4% | 671.9 ± 0.4% | 991.6 ± 0.5% | 732.3 ± 0.3% | 10.671 | 14.390 | 23.378 | 15.840 | 21.449 |
| hex: canterbury-large/bible.txt | 524290 | 15624.8 ± 0.4% | 1459.5 ± 0.4% | 1085.4 ± 0.3% | 515.8 ± 0.4% | 988.3 ± 0.4% | 734.4 ± 0.4% | 10.705 | 14.395 | 30.292 | 15.810 | 21.275 |
| hex: canterbury-large/world192.txt | 524290 | 15605.5 ± 0.9% | 1467.1 ± 0.3% | 1087.0 ± 0.2% | 500.9 ± 0.9% | 993.3 ± 0.4% | 732.6 ± 0.8% | 10.637 | 14.357 | 31.156 | 15.710 | 21.302 |
| hex: http/html-1kx1024 | 2099200 | 14147.6 ± 0.8% | 1462.1 ± 0.5% | 1064.6 ± 0.3% | 501.7 ± 0.1% | 974.6 ± 0.0% | 692.9 ± 0.2% | 9.676 | 13.289 | 28.202 | 14.516 | 20.417 |
| hex: http/html-16kx64 | 2097280 | 15343.1 ± 0.5% | 1446.4 ± 0.7% | 1076.0 ± 0.6% | 507.5 ± 0.3% | 999.5 ± 0.5% | 734.7 ± 0.3% | 10.608 | 14.260 | 30.235 | 15.351 | 20.883 |
| hex: http/html-1m | 524290 | 15642.1 ± 0.5% | 1471.9 ± 0.3% | 1087.2 ± 0.2% | 501.3 ± 0.6% | 991.7 ± 0.5% | 735.9 ± 0.6% | 10.627 | 14.388 | 31.206 | 15.772 | 21.257 |
| hex: http/json-1kx1024 | 2099200 | 14110.8 ± 0.7% | 1464.2 ± 0.1% | 1067.1 ± 0.1% | 608.9 ± 0.6% | 986.3 ± 0.1% | 692.7 ± 0.1% | 9.637 | 13.223 | 23.173 | 14.307 | 20.370 |
| hex: http/json-16kx64 | 2097280 | 15344.5 ± 0.7% | 1446.2 ± 0.1% | 1073.7 ± 0.3% | 616.3 ± 0.4% | 994.8 ± 0.3% | 735.0 ± 0.3% | 10.610 | 14.291 | 24.898 | 15.425 | 20.876 |
| hex: http/json-1m | 524290 | 15580.5 ± 0.5% | 1472.0 ± 0.5% | 1091.1 ± 0.4% | 635.5 ± 0.9% | 990.9 ± 0.4% | 732.7 ± 1.1% | 10.585 | 14.279 | 24.519 | 15.724 | 21.263 |
| hex: http/js-1kx1024 | 2099200 | 14145.7 ± 0.4% | 1455.1 ± 0.5% | 1063.3 ± 0.3% | 498.9 ± 0.4% | 983.7 ± 0.7% | 692.8 ± 0.1% | 9.721 | 13.304 | 28.351 | 14.381 | 20.418 |
| hex: http/js-16kx64 | 2097280 | 15361.0 ± 0.4% | 1442.3 ± 0.4% | 1075.5 ± 0.4% | 505.4 ± 0.6% | 994.4 ± 0.5% | 734.6 ± 0.2% | 10.650 | 14.282 | 30.391 | 15.447 | 20.909 |
| hex: http/js-1m | 524290 | 15679.1 ± 0.5% | 1464.2 ± 0.5% | 1085.4 ± 0.4% | 510.7 ± 0.5% | 990.1 ± 0.3% | 733.6 ± 0.5% | 10.709 | 14.445 | 30.700 | 15.835 | 21.373 |
| hex: http/css-1kx1024 | 2099200 | 14162.1 ± 0.7% | 1455.5 ± 0.6% | 1063.2 ± 0.3% | 531.7 ± 0.3% | 983.0 ± 0.2% | 692.6 ± 1.2% | 9.730 | 13.321 | 26.634 | 14.407 | 20.448 |
| hex: http/css-16kx64 | 2097280 | 15334.3 ± 0.4% | 1444.5 ± 0.2% | 1072.8 ± 0.2% | 542.6 ± 0.6% | 998.6 ± 0.1% | 735.3 ± 0.3% | 10.615 | 14.294 | 28.259 | 15.355 | 20.856 |
| hex: http/css-1m | 524290 | 15694.7 ± 0.2% | 1465.4 ± 0.3% | 1085.5 ± 0.4% | 526.6 ± 1.0% | 988.1 ± 0.2% | 734.9 ± 0.6% | 10.710 | 14.459 | 29.806 | 15.884 | 21.356 |
| hex: shuffled/dickens-1m | 524290 | 15700.1 ± 0.3% | 1468.2 ± 0.6% | 1084.0 ± 0.9% | 503.2 ± 0.6% | 985.8 ± 0.1% | 733.1 ± 0.7% | 10.693 | 14.484 | 31.199 | 15.926 | 21.417 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.918 of yyjson.
