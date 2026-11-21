# bench-json

| Field | Value |
|---|---|
| Commit | 413a510 |
| Runner label | ubuntu-26.04 |
| Image version | 20261116.202.1 |
| CPU model | AMD EPYC 7763 64-Core Processor |
| Virtual CPUs | 4 |
| Kernel | 7.0.0-1020-azure |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/44935468830 |
| Date | 2026-11-21 |
| simdjson | 5.1.1 |
| yyjson | 0.13.0 |
| std.json | 0.16.0 |
| serde_json | 1.0.154, rustc 1.100.0 |
| Go jsontext | 1.27.3 |
| simdutf | 9.3.3 |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1. The `TextReader.next_items` column is that helper's queued tokens a slice a call (decision 79), over many tokens a call.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | TextReader.next_items | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1024.4 ± 1.0% | 0.453 | 0.997 | 1.039 | 1.051 | 0.412 | 1.045 | 1.055 | 0.366 | 0.817 | 0.929 | 0.095 |
| qlog records, JSON text sequence | 1467503 | 846.5 ± 0.9% | 0.733 | 1.009 | 1.022 | 1.015 | 0.392 | 1.031 | 1.015 | 0.348 | 0.907 | 0.976 | 0.110 |
| messages: 11 string members | 1025025 | 897.9 ± 1.6% | 0.582 | 0.990 | 1.020 | 1.016 | 0.511 | 1.022 | 1.014 | 0.481 | 0.880 | 1.021 | 0.110 |
| messages: 50 nested objects | 1121600 | 1019.9 ± 0.5% | 0.679 | 1.054 | 1.062 | 1.034 | 0.394 | 1.090 | 1.036 | 0.340 | 0.907 | 1.045 | 0.098 |
| messages: a tree of 341 objects | 612600 | 374.7 ± 2.9% | 0.919 | 1.128 | 1.063 | 1.071 | 0.350 | 1.070 | 1.080 | 0.281 | 0.830 | 1.061 | 0.151 |
| string: silesia/dickens | 172528 | 6202.2 ± 0.9% | 0.022 | 0.575 | 0.896 | 0.916 | 0.158 | 0.875 | 0.916 | 0.158 | 1.002 | 0.995 | 0.022 |
| string: silesia/nci | 1075110 | 5112.8 ± 0.4% | 0.027 | 0.703 | 1.035 | 1.034 | 0.233 | 1.007 | 1.036 | 0.233 | 1.001 | 1.001 | 0.027 |
| string: silesia/reymont | 1075159 | 3292.7 ± 0.9% | 0.041 | 0.579 | 0.823 | 0.826 | 0.291 | 0.818 | 0.827 | 0.290 | 1.001 | 1.002 | 0.040 |
| string: silesia/samba | 97582 | 3340.7 ± 1.6% | 0.035 | 0.886 | 1.018 | 1.023 | 0.066 | 0.824 | 1.021 | 0.066 | 1.000 | 1.000 | 0.036 |
| string: silesia/webster | 1098490 | 4096.3 ± 1.9% | 0.033 | 0.601 | 0.921 | 0.944 | 0.176 | 0.909 | 0.942 | 0.176 | 1.000 | 1.002 | 0.033 |
| string: silesia/xml | 1090118 | 5508.6 ± 0.3% | 0.025 | 0.794 | 0.931 | 0.934 | 0.203 | 0.923 | 0.932 | 0.203 | 1.001 | 1.002 | 0.025 |
| string: canterbury/alice29.txt | 159425 | 4878.7 ± 1.7% | 0.027 | 0.695 | 0.939 | 1.007 | 0.151 | 0.956 | 1.005 | 0.150 | 1.003 | 1.003 | 0.027 |
| string: canterbury/asyoulik.txt | 132198 | 3785.9 ± 3.8% | 0.034 | 0.790 | 1.096 | 1.135 | 0.163 | 1.037 | 1.133 | 0.164 | 0.994 | 0.955 | 0.034 |
| string: canterbury/lcet10.txt | 441884 | 6087.2 ± 1.0% | 0.022 | 0.538 | 0.978 | 0.997 | 0.155 | 0.957 | 0.997 | 0.155 | 1.000 | 1.002 | 0.023 |
| string: canterbury/plrabn12.txt | 503330 | 4738.4 ± 22.4% | 0.029 | 0.746 | 0.970 | 1.013 | 0.175 | 0.950 | 1.012 | 0.174 | 0.999 | 1.000 | 0.028 |
| string: canterbury-large/E.coli | 1048578 | 37337.5 ± 8.9% | 0.040 | 1.035 | 0.593 | 1.026 | 0.483 | 1.039 | 1.043 | 0.477 | 0.897 | 0.898 | 0.004 |
| string: canterbury-large/bible.txt | 1055886 | 9600.7 ± 0.5% | 0.015 | 0.473 | 0.624 | 0.618 | 0.275 | 0.679 | 0.621 | 0.276 | 0.999 | 1.008 | 0.014 |
| string: canterbury-large/world192.txt | 1103121 | 3784.2 ± 1.6% | 0.036 | 0.641 | 0.935 | 0.960 | 0.169 | 0.922 | 0.959 | 0.172 | 1.001 | 0.994 | 0.036 |
| string: http/html-1m | 1058582 | 7954.7 ± 1.0% | 0.018 | 0.542 | 0.746 | 0.744 | 0.288 | 0.771 | 0.745 | 0.288 | 1.007 | 1.011 | 0.018 |
| string: http/json-1m | 1190272 | 3313.3 ± 0.3% | 0.038 | 0.384 | 0.437 | 0.437 | 0.094 | 0.393 | 0.437 | 0.094 | 0.999 | 1.000 | 0.038 |
| string: http/js-1m | 1144362 | 2654.6 ± 0.6% | 0.048 | 0.661 | 0.873 | 0.901 | 0.149 | 0.865 | 0.896 | 0.150 | 1.002 | 1.002 | 0.049 |
| string: http/css-1m | 1097820 | 3034.0 ± 1.9% | 0.044 | 0.729 | 1.028 | 1.085 | 0.218 | 1.004 | 1.037 | 0.217 | 1.001 | 1.000 | 0.044 |
| string: dickens as Cyrillic and CJK | 1883069 | 5357.8 ± 0.5% | 0.020 | 0.055 | 0.480 | 0.482 | 0.175 | 0.478 | 0.482 | 0.175 | 1.002 | 1.005 | 0.020 |
| string: dickens as Cyrillic and CJK, as \u escapes | 5075485 | 1059.7 ± 8.1% | 0.093 | 0.975 | 0.976 | 0.975 | 0.089 | 0.707 | 0.975 | 0.089 | 1.002 | 1.000 | 0.093 |
| hex: silesia/dickens | 524290 | 37078.1 ± 3.0% | 0.040 | 1.030 | 0.593 | 1.036 | 0.487 | 1.040 | 1.038 | 0.485 | 0.905 | 0.908 | 0.004 |
| hex: silesia/mozilla | 524290 | 33857.6 ± 2.1% | 0.043 | 1.026 | 0.657 | 1.029 | 0.514 | 1.031 | 1.033 | 0.513 | 0.988 | 0.990 | 0.004 |
| hex: silesia/mr | 524290 | 37213.8 ± 1.0% | 0.039 | 1.027 | 0.592 | 1.035 | 0.479 | 1.031 | 1.036 | 0.475 | 0.903 | 0.900 | 0.004 |
| hex: silesia/nci | 524290 | 36639.7 ± 3.0% | 0.040 | 1.035 | 0.605 | 1.017 | 0.486 | 1.041 | 1.048 | 0.481 | 0.909 | 0.913 | 0.004 |
| hex: silesia/ooffice | 524290 | 35018.8 ± 5.0% | 0.042 | 1.042 | 0.631 | 1.033 | 0.507 | 1.051 | 1.052 | 0.504 | 0.955 | 0.956 | 0.004 |
| hex: silesia/osdb | 524290 | 36557.9 ± 1.7% | 0.041 | 1.030 | 0.608 | 1.036 | 0.491 | 1.038 | 1.042 | 0.490 | 0.922 | 0.917 | 0.004 |
| hex: silesia/reymont | 524290 | 37421.7 ± 3.9% | 0.041 | 1.027 | 0.595 | 1.030 | 0.482 | 1.033 | 1.035 | 0.482 | 0.896 | 0.898 | 0.004 |
| hex: silesia/samba | 524290 | 35181.9 ± 2.3% | 0.041 | 1.019 | 0.615 | 1.021 | 0.497 | 1.027 | 1.028 | 0.494 | 0.953 | 0.947 | 0.004 |
| hex: silesia/sao | 524290 | 37302.1 ± 2.4% | 0.039 | 1.019 | 0.596 | 1.020 | 0.484 | 1.028 | 1.029 | 0.484 | 0.899 | 0.896 | 0.004 |
| hex: silesia/webster | 524290 | 36579.2 ± 2.8% | 0.040 | 1.035 | 0.606 | 1.034 | 0.492 | 1.037 | 1.041 | 0.487 | 0.916 | 0.915 | 0.004 |
| hex: silesia/x-ray | 524290 | 35699.1 ± 4.7% | 0.041 | 1.013 | 0.626 | 1.015 | 0.498 | 1.023 | 1.023 | 0.497 | 0.940 | 0.945 | 0.004 |
| hex: silesia/xml | 524290 | 37296.4 ± 4.9% | 0.039 | 1.017 | 0.596 | 1.024 | 0.479 | 1.027 | 1.031 | 0.476 | 0.900 | 0.899 | 0.004 |
| hex: canterbury/alice29.txt | 304180 | 36975.3 ± 4.1% | 0.039 | 1.042 | 0.607 | 1.040 | 0.479 | 1.046 | 1.049 | 0.478 | 0.918 | 0.915 | 0.004 |
| hex: canterbury/asyoulik.txt | 250360 | 36691.0 ± 3.3% | 0.039 | 1.052 | 0.605 | 1.047 | 0.493 | 1.059 | 1.052 | 0.490 | 0.918 | 0.923 | 0.004 |
| hex: canterbury/cp.html | 49208 | 40464.5 ± 1.4% | 0.032 | 1.005 | 0.546 | 1.002 | 0.452 | 1.001 | 1.005 | 0.455 | 0.810 | 0.813 | 0.003 |
| hex: canterbury/fields.c | 22302 | 38075.8 ± 10.8% | 0.035 | 1.019 | 0.558 | 1.022 | 0.456 | 1.019 | 1.021 | 0.467 | 0.830 | 0.835 | 0.004 |
| hex: canterbury/grammar.lsp | 7444 | 35759.3 ± 2.9% | 0.038 | 1.034 | 0.541 | 1.044 | 0.443 | 1.036 | 1.041 | 0.475 | 0.768 | 0.778 | 0.004 |
| hex: canterbury/kennedy.xls | 524290 | 37323.4 ± 10.2% | 0.038 | 1.013 | 0.592 | 1.016 | 0.485 | 1.025 | 1.025 | 0.483 | 0.900 | 0.899 | 0.004 |
| hex: canterbury/lcet10.txt | 524290 | 36001.0 ± 4.2% | 0.040 | 1.052 | 0.614 | 1.056 | 0.496 | 1.065 | 1.066 | 0.494 | 0.935 | 0.934 | 0.004 |
| hex: canterbury/plrabn12.txt | 524290 | 36732.1 ± 2.2% | 0.039 | 1.024 | 0.607 | 1.013 | 0.486 | 1.026 | 1.031 | 0.482 | 0.905 | 0.907 | 0.004 |
| hex: canterbury/ptt5 | 524290 | 35780.3 ± 2.9% | 0.040 | 1.037 | 0.614 | 1.035 | 0.498 | 1.048 | 1.045 | 0.493 | 0.929 | 0.931 | 0.004 |
| hex: canterbury/sum | 76482 | 38339.2 ± 0.9% | 0.035 | 1.006 | 0.579 | 1.009 | 0.472 | 1.009 | 1.010 | 0.474 | 0.867 | 0.870 | 0.004 |
| hex: canterbury/xargs.1 | 8456 | 37571.7 ± 1.5% | 0.035 | 1.009 | 0.524 | 1.029 | 0.425 | 1.007 | 1.034 | 0.454 | 0.748 | 0.754 | 0.004 |
| hex: canterbury-large/E.coli | 524290 | 36262.1 ± 17.3% | 0.040 | 1.050 | 0.614 | 1.055 | 0.494 | 1.069 | 1.069 | 0.495 | 0.924 | 0.925 | 0.004 |
| hex: canterbury-large/bible.txt | 524290 | 37108.0 ± 2.7% | 0.039 | 1.029 | 0.600 | 1.030 | 0.484 | 1.025 | 1.038 | 0.485 | 0.905 | 0.904 | 0.004 |
| hex: canterbury-large/world192.txt | 524290 | 36088.4 ± 1.8% | 0.040 | 1.028 | 0.611 | 1.024 | 0.493 | 1.035 | 1.034 | 0.492 | 0.922 | 0.922 | 0.004 |
| hex: http/html-1kx1024 | 2099200 | 16392.8 ± 4.5% | 0.087 | 1.048 | 0.808 | 1.044 | 0.624 | 1.049 | 1.050 | 0.718 | 1.024 | 1.039 | 0.009 |
| hex: http/html-16kx64 | 2097280 | 33625.6 ± 3.4% | 0.044 | 1.035 | 0.620 | 1.043 | 0.507 | 1.033 | 1.048 | 0.514 | 0.901 | 0.910 | 0.004 |
| hex: http/html-1m | 524290 | 37227.7 ± 9.5% | 0.039 | 1.016 | 0.599 | 1.027 | 0.484 | 1.033 | 1.041 | 0.480 | 0.896 | 0.898 | 0.004 |
| hex: http/json-1kx1024 | 2099200 | 16537.5 ± 2.7% | 0.086 | 1.063 | 0.799 | 1.058 | 0.620 | 1.052 | 1.065 | 0.708 | 1.016 | 1.031 | 0.009 |
| hex: http/json-16kx64 | 2097280 | 34448.2 ± 2.1% | 0.043 | 1.007 | 0.601 | 1.024 | 0.497 | 1.022 | 1.028 | 0.503 | 0.885 | 0.884 | 0.004 |
| hex: http/json-1m | 524290 | 37016.3 ± 7.6% | 0.039 | 1.025 | 0.603 | 1.029 | 0.483 | 1.028 | 1.032 | 0.483 | 0.910 | 0.912 | 0.004 |
| hex: http/js-1kx1024 | 2099200 | 16645.0 ± 2.6% | 0.086 | 1.045 | 0.802 | 1.051 | 0.599 | 1.050 | 1.054 | 0.681 | 1.015 | 1.021 | 0.009 |
| hex: http/js-16kx64 | 2097280 | 34899.9 ± 2.9% | 0.042 | 1.003 | 0.598 | 1.010 | 0.495 | 1.008 | 1.010 | 0.499 | 0.870 | 0.883 | 0.004 |
| hex: http/js-1m | 524290 | 35280.8 ± 7.2% | 0.042 | 1.024 | 0.631 | 1.023 | 0.506 | 1.030 | 1.031 | 0.506 | 0.943 | 0.946 | 0.004 |
| hex: http/css-1kx1024 | 2099200 | 16380.2 ± 3.7% | 0.090 | 1.063 | 0.811 | 1.065 | 0.606 | 1.065 | 1.073 | 0.693 | 1.029 | 1.042 | 0.009 |
| hex: http/css-16kx64 | 2097280 | 34315.7 ± 4.2% | 0.044 | 1.030 | 0.612 | 1.031 | 0.507 | 1.038 | 1.042 | 0.506 | 0.893 | 0.895 | 0.004 |
| hex: http/css-1m | 524290 | 36604.0 ± 4.1% | 0.040 | 1.030 | 0.608 | 1.037 | 0.492 | 1.036 | 1.040 | 0.490 | 0.918 | 0.919 | 0.004 |
| hex: shuffled/dickens-1m | 524290 | 36154.5 ± 1.3% | 0.041 | 1.023 | 0.614 | 1.027 | 0.495 | 1.031 | 1.032 | 0.494 | 0.932 | 0.929 | 0.004 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1358.5 ± 0.7% | 0.437 | 0.955 | 0.966 | 0.984 | 0.981 | 0.231 | 0.981 | 0.438 | 0.832 | 0.085 | 0.995 |
| qlog records, JSON text sequence | 1467503 | 1169.1 ± 0.5% | 0.699 | 0.939 | 0.973 | 0.964 | 0.965 | 0.226 | 0.969 | 0.411 | 0.827 | 0.103 | 1.001 |
| messages: 11 string members | 1025025 | 1085.1 ± 3.0% | 0.559 | 1.011 | 1.003 | 1.002 | 0.995 | 0.317 | 1.010 | 0.583 | 1.029 | 0.104 | 1.014 |
| messages: 50 nested objects | 1121600 | 1382.1 ± 1.0% | 0.602 | 0.958 | 0.946 | 0.938 | 0.948 | 0.214 | 0.942 | 0.399 | 0.825 | 0.089 | 0.986 |
| messages: a tree of 341 objects | 612600 | 449.3 ± 3.2% | 0.902 | 1.003 | 0.998 | 1.053 | 1.049 | 0.187 | 1.053 | 0.364 | 1.004 | 0.153 | 1.084 |
| string: silesia/dickens | 172528 | 9197.7 ± 0.5% | 0.017 | 0.582 | 0.408 | 0.597 | 0.584 | 0.118 | 0.583 | 1.002 | 1.006 | 0.017 | 1.038 |
| string: silesia/nci | 1075110 | 8749.5 ± 4.2% | 0.018 | 0.592 | 0.396 | 0.588 | 0.590 | 0.166 | 0.591 | 1.000 | 1.001 | 0.018 | 1.020 |
| string: silesia/reymont | 1075159 | 3846.4 ± 0.6% | 0.040 | 0.674 | 0.512 | 0.667 | 0.675 | 0.279 | 0.675 | 1.002 | 1.003 | 0.040 | 1.005 |
| string: silesia/samba | 97582 | 4634.9 ± 1.0% | 0.042 | 0.933 | 0.794 | 0.933 | 0.934 | 0.111 | 0.933 | 0.991 | 1.002 | 0.041 | 1.118 |
| string: silesia/webster | 1098490 | 5098.9 ± 1.7% | 0.030 | 0.698 | 0.494 | 0.703 | 0.698 | 0.155 | 0.697 | 1.014 | 0.995 | 0.030 | 1.000 |
| string: silesia/xml | 1090118 | 7863.2 ± 3.9% | 0.020 | 0.635 | 0.569 | 0.643 | 0.635 | 0.201 | 0.635 | 1.001 | 1.009 | 0.020 | 1.056 |
| string: canterbury/alice29.txt | 159425 | 9879.3 ± 1.6% | 0.016 | 0.512 | 0.357 | 0.507 | 0.474 | 0.083 | 0.514 | 1.001 | 1.006 | 0.016 | 1.035 |
| string: canterbury/asyoulik.txt | 132198 | 7991.9 ± 0.8% | 0.019 | 0.510 | 0.392 | 0.505 | 0.511 | 0.087 | 0.513 | 1.002 | 1.008 | 0.019 | 1.046 |
| string: canterbury/lcet10.txt | 441884 | 8871.6 ± 3.2% | 0.017 | 0.606 | 0.388 | 0.616 | 0.607 | 0.119 | 0.597 | 1.005 | 1.016 | 0.017 | 1.034 |
| string: canterbury/plrabn12.txt | 503330 | 6043.4 ± 2.3% | 0.026 | 0.768 | 0.584 | 0.759 | 0.767 | 0.157 | 0.767 | 1.003 | 1.003 | 0.026 | 1.054 |
| string: canterbury-large/E.coli | 1048578 | 37365.3 ± 14.2% | 0.041 | 1.026 | 1.036 | 0.593 | 1.038 | 0.481 | 1.038 | 1.029 | 1.034 | 0.004 | 1.039 |
| string: canterbury-large/bible.txt | 1055886 | 7046.6 ± 0.7% | 0.023 | 0.794 | 0.656 | 0.822 | 0.794 | 0.411 | 0.796 | 1.000 | 1.000 | 0.023 | 1.052 |
| string: canterbury-large/world192.txt | 1103121 | 5149.7 ± 6.5% | 0.030 | 0.669 | 0.492 | 0.640 | 0.649 | 0.138 | 0.649 | 1.000 | 0.944 | 0.030 | 0.933 |
| string: http/html-1m | 1058582 | 8508.2 ± 0.7% | 0.019 | 0.623 | 0.518 | 0.648 | 0.622 | 0.291 | 0.622 | 1.000 | 1.009 | 0.019 | 1.020 |
| string: http/json-1m | 1190272 | 6643.7 ± 0.9% | 0.022 | 0.216 | 0.188 | 0.219 | 0.216 | 0.062 | 0.216 | 1.007 | 1.006 | 0.022 | 1.027 |
| string: http/js-1m | 1144362 | 5100.8 ± 11.3% | 0.029 | 0.441 | 0.353 | 0.435 | 0.442 | 0.085 | 0.442 | 1.000 | 1.013 | 0.029 | 1.001 |
| string: http/css-1m | 1097820 | 6896.7 ± 1.7% | 0.022 | 0.502 | 0.340 | 0.505 | 0.506 | 0.114 | 0.505 | 1.002 | 1.007 | 0.022 | 1.063 |
| string: dickens as Cyrillic and CJK | 1883069 | 5366.2 ± 0.1% | 0.024 | 0.464 | 0.056 | 0.465 | 0.464 | 0.176 | 0.465 | 0.995 | 0.997 | 0.024 | 0.973 |
| hex: silesia/dickens | 524290 | 30837.7 ± 1.6% | 1.011 | 0.082 | 1.012 | 0.618 | 1.013 | 1.009 | 1.012 | 1.010 | 1.012 | 0.083 | 1.013 |
| hex: silesia/mozilla | 524290 | 34839.9 ± 1.0% | 1.011 | 0.073 | 1.009 | 0.578 | 1.014 | 1.009 | 1.014 | 1.011 | 1.016 | 0.072 | 1.013 |
| hex: silesia/mr | 524290 | 34630.1 ± 1.5% | 1.007 | 0.073 | 1.010 | 0.582 | 1.013 | 1.013 | 1.018 | 1.012 | 1.019 | 0.072 | 1.013 |
| hex: silesia/nci | 524290 | 34960.8 ± 1.0% | 1.010 | 0.073 | 1.012 | 0.580 | 1.012 | 1.008 | 1.012 | 1.010 | 1.013 | 0.069 | 1.013 |
| hex: silesia/ooffice | 524290 | 33338.0 ± 1.6% | 1.015 | 0.076 | 1.015 | 0.604 | 1.016 | 1.014 | 1.015 | 1.012 | 1.015 | 0.073 | 1.017 |
| hex: silesia/osdb | 524290 | 31982.4 ± 2.6% | 1.012 | 0.079 | 1.009 | 0.628 | 1.010 | 1.010 | 1.013 | 0.995 | 1.013 | 0.078 | 1.011 |
| hex: silesia/reymont | 524290 | 33529.6 ± 0.2% | 1.014 | 0.076 | 1.012 | 0.600 | 1.012 | 1.013 | 1.015 | 1.015 | 1.018 | 0.075 | 1.017 |
| hex: silesia/samba | 524290 | 34961.9 ± 3.9% | 1.017 | 0.072 | 1.025 | 0.578 | 1.000 | 1.020 | 1.020 | 1.026 | 1.031 | 0.069 | 1.028 |
| hex: silesia/sao | 524290 | 33325.9 ± 1.9% | 1.017 | 0.076 | 1.019 | 0.602 | 1.020 | 1.022 | 1.022 | 1.022 | 1.037 | 0.074 | 1.026 |
| hex: silesia/webster | 524290 | 35459.5 ± 1.4% | 1.020 | 0.072 | 1.016 | 0.572 | 1.016 | 1.014 | 1.012 | 1.009 | 1.017 | 0.068 | 1.016 |
| hex: silesia/x-ray | 524290 | 33928.5 ± 0.9% | 1.018 | 0.075 | 1.016 | 0.594 | 1.015 | 1.017 | 1.019 | 1.014 | 1.025 | 0.071 | 1.018 |
| hex: silesia/xml | 524290 | 34649.9 ± 0.7% | 1.012 | 0.073 | 1.011 | 0.582 | 1.012 | 1.011 | 1.012 | 1.005 | 1.014 | 0.074 | 1.016 |
| hex: canterbury/alice29.txt | 304180 | 33119.5 ± 2.5% | 1.004 | 0.077 | 1.002 | 0.580 | 1.005 | 1.001 | 1.007 | 1.005 | 1.008 | 0.074 | 1.010 |
| hex: canterbury/asyoulik.txt | 250360 | 30981.7 ± 18.2% | 1.008 | 0.081 | 1.004 | 0.635 | 1.006 | 1.004 | 1.007 | 1.006 | 1.008 | 0.070 | 1.007 |
| hex: canterbury/cp.html | 49208 | 31510.5 ± 3.9% | 1.006 | 0.080 | 1.004 | 0.614 | 1.005 | 1.001 | 1.008 | 1.009 | 1.012 | 0.073 | 1.007 |
| hex: canterbury/fields.c | 22302 | 32758.7 ± 0.5% | 1.000 | 0.077 | 0.994 | 0.579 | 0.993 | 0.986 | 0.996 | 1.002 | 1.013 | 0.069 | 1.001 |
| hex: canterbury/grammar.lsp | 7444 | 32353.5 ± 0.8% | 0.996 | 0.077 | 0.992 | 0.569 | 0.992 | 0.962 | 0.993 | 0.998 | 1.025 | 0.068 | 1.006 |
| hex: canterbury/kennedy.xls | 524290 | 31147.3 ± 2.4% | 1.005 | 0.081 | 1.006 | 0.619 | 1.008 | 1.004 | 1.008 | 1.005 | 1.007 | 0.080 | 1.007 |
| hex: canterbury/lcet10.txt | 524290 | 35489.8 ± 0.9% | 1.015 | 0.072 | 1.014 | 0.569 | 1.016 | 1.016 | 1.019 | 1.011 | 1.021 | 0.069 | 1.019 |
| hex: canterbury/plrabn12.txt | 524290 | 33554.3 ± 3.1% | 1.025 | 0.076 | 1.012 | 0.596 | 1.025 | 1.019 | 1.026 | 1.020 | 1.029 | 0.074 | 1.030 |
| hex: canterbury/ptt5 | 524290 | 33969.1 ± 1.4% | 1.015 | 0.075 | 1.013 | 0.595 | 1.013 | 1.014 | 1.018 | 1.008 | 1.019 | 0.074 | 1.022 |
| hex: canterbury/sum | 76482 | 34888.9 ± 11.9% | 1.005 | 0.073 | 1.003 | 0.577 | 1.005 | 1.002 | 1.001 | 1.005 | 1.014 | 0.067 | 1.011 |
| hex: canterbury/xargs.1 | 8456 | 34632.1 ± 0.9% | 0.992 | 0.073 | 0.997 | 0.545 | 0.995 | 0.956 | 0.994 | 0.996 | 1.026 | 0.063 | 1.010 |
| hex: canterbury-large/E.coli | 524290 | 30171.3 ± 2.8% | 1.007 | 0.084 | 1.005 | 0.616 | 1.008 | 1.006 | 1.008 | 1.005 | 1.011 | 0.080 | 1.009 |
| hex: canterbury-large/bible.txt | 524290 | 35010.0 ± 1.7% | 1.004 | 0.073 | 1.008 | 0.578 | 1.006 | 1.006 | 1.009 | 1.007 | 1.010 | 0.073 | 1.009 |
| hex: canterbury-large/world192.txt | 524290 | 32959.7 ± 0.5% | 1.000 | 0.077 | 1.007 | 0.605 | 1.006 | 1.003 | 1.007 | 1.011 | 1.009 | 0.076 | 1.002 |
| hex: http/html-1kx1024 | 2099200 | 23102.0 ± 2.6% | 1.008 | 0.106 | 0.996 | 0.683 | 1.006 | 0.893 | 1.003 | 1.028 | 1.087 | 0.103 | 1.036 |
| hex: http/html-16kx64 | 2097280 | 29872.5 ± 2.3% | 1.004 | 0.084 | 1.004 | 0.645 | 1.003 | 0.990 | 1.005 | 1.012 | 1.020 | 0.085 | 1.004 |
| hex: http/html-1m | 524290 | 31488.0 ± 2.1% | 1.003 | 0.080 | 1.009 | 0.631 | 0.972 | 1.009 | 1.010 | 1.005 | 1.013 | 0.081 | 1.011 |
| hex: http/json-1kx1024 | 2099200 | 22954.3 ± 4.7% | 1.011 | 0.107 | 0.992 | 0.687 | 1.004 | 0.903 | 1.003 | 1.030 | 1.091 | 0.104 | 1.040 |
| hex: http/json-16kx64 | 2097280 | 29899.2 ± 2.0% | 1.018 | 0.084 | 1.009 | 0.646 | 1.003 | 0.996 | 1.015 | 1.017 | 1.023 | 0.084 | 1.014 |
| hex: http/json-1m | 524290 | 31034.0 ± 0.7% | 1.002 | 0.082 | 1.002 | 0.638 | 1.001 | 1.000 | 1.003 | 1.005 | 1.004 | 0.082 | 1.003 |
| hex: http/js-1kx1024 | 2099200 | 23166.0 ± 2.7% | 1.002 | 0.106 | 0.992 | 0.682 | 0.999 | 0.898 | 1.002 | 1.017 | 1.087 | 0.103 | 1.029 |
| hex: http/js-16kx64 | 2097280 | 29749.2 ± 5.1% | 1.005 | 0.085 | 1.005 | 0.645 | 1.006 | 0.992 | 1.007 | 1.015 | 1.020 | 0.085 | 1.004 |
| hex: http/js-1m | 524290 | 31050.4 ± 2.1% | 1.011 | 0.082 | 1.008 | 0.642 | 1.010 | 1.009 | 1.012 | 1.008 | 1.012 | 0.082 | 1.014 |
| hex: http/css-1kx1024 | 2099200 | 22987.9 ± 2.5% | 1.020 | 0.107 | 1.010 | 0.695 | 1.002 | 0.898 | 1.001 | 1.023 | 1.086 | 0.104 | 1.034 |
| hex: http/css-16kx64 | 2097280 | 29390.3 ± 1.9% | 1.017 | 0.086 | 1.015 | 0.655 | 1.023 | 1.012 | 1.024 | 1.031 | 1.038 | 0.086 | 1.021 |
| hex: http/css-1m | 524290 | 30941.6 ± 12.8% | 1.010 | 0.082 | 1.012 | 0.642 | 1.012 | 1.011 | 1.012 | 1.008 | 1.011 | 0.082 | 1.010 |
| hex: shuffled/dickens-1m | 524290 | 32503.3 ± 2.0% | 1.023 | 0.078 | 1.023 | 0.622 | 1.022 | 1.024 | 1.022 | 1.024 | 1.026 | 0.079 | 1.023 |

## Losses

Each workload where a claim's path ran slower than the path it replaces by more than the noise floor of decision 20.

- messages: 50 nested objects, decoding: J5 UTF-8 vectors off runs at 1.054 of all on.
- messages: 50 nested objects, decoding: J7 wide vectors off runs at 1.062 of all on.
- messages: 50 nested objects, decoding: J12 decoder escape words off runs at 1.090 of all on.
- messages: a tree of 341 objects, decoding: J5 UTF-8 vectors off runs at 1.128 of all on.
- messages: a tree of 341 objects, decoding: J12 decoder escape words off runs at 1.070 of all on.
- messages: a tree of 341 objects, decoding: J13 decoder escape blocks off runs at 1.080 of all on.
- string: canterbury/asyoulik.txt, decoding: J8 decoder fast path off runs at 1.135 of all on.
- string: canterbury/asyoulik.txt, decoding: J13 decoder escape blocks off runs at 1.133 of all on.
- string: http/css-1m, decoding: J8 decoder fast path off runs at 1.085 of all on.
- hex: silesia/ooffice, decoding: J12 decoder escape words off runs at 1.051 of all on.
- hex: silesia/ooffice, decoding: J13 decoder escape blocks off runs at 1.052 of all on.
- hex: canterbury/asyoulik.txt, decoding: J5 UTF-8 vectors off runs at 1.052 of all on.
- hex: canterbury/asyoulik.txt, decoding: J12 decoder escape words off runs at 1.059 of all on.
- hex: canterbury/asyoulik.txt, decoding: J13 decoder escape blocks off runs at 1.052 of all on.
- hex: canterbury/lcet10.txt, decoding: J5 UTF-8 vectors off runs at 1.052 of all on.
- hex: canterbury/lcet10.txt, decoding: J8 decoder fast path off runs at 1.056 of all on.
- hex: canterbury/lcet10.txt, decoding: J12 decoder escape words off runs at 1.065 of all on.
- hex: canterbury/lcet10.txt, decoding: J13 decoder escape blocks off runs at 1.066 of all on.
- hex: http/html-1kx1024, decoding: J13 decoder escape blocks off runs at 1.050 of all on.
- hex: http/json-1kx1024, decoding: J5 UTF-8 vectors off runs at 1.063 of all on.
- hex: http/json-1kx1024, decoding: J8 decoder fast path off runs at 1.058 of all on.
- hex: http/json-1kx1024, decoding: J12 decoder escape words off runs at 1.052 of all on.
- hex: http/js-1kx1024, decoding: J8 decoder fast path off runs at 1.051 of all on.
- hex: http/js-1kx1024, decoding: J13 decoder escape blocks off runs at 1.054 of all on.
- hex: http/css-1kx1024, decoding: J5 UTF-8 vectors off runs at 1.063 of all on.
- hex: http/css-1kx1024, decoding: J8 decoder fast path off runs at 1.065 of all on.
- hex: http/css-1kx1024, decoding: J12 decoder escape words off runs at 1.065 of all on.
- hex: http/css-1kx1024, decoding: J13 decoder escape blocks off runs at 1.073 of all on.

## UTF-8 validation against simdutf

stdx's `is_utf8`, the check the loops apply to every string's octets, run alone over each string workload's octets at the width the host's features pick (16 lanes on aarch64, AVX2's 32 or AVX-512's 64 on x86-64, decision 39), beside simdutf 9.3.3's `validate_utf8` in the same run; on a host with AVX-512, again with AVX2 alone. Each ratio is stdx's throughput over the other's. simdutf picks its kernel at run time. Before timing, every copy of the check and simdutf judged 20000 seeded buffers and each workload, whole and changed, alike.

| Workload | Octets | stdx, MB/s | simdutf, MB/s | stdx / simdutf | stdx with AVX2 alone, MB/s | stdx / stdx with AVX2 alone |
|---|---|---|---|---|---|---|
| string: silesia/dickens | 166668 | 100641.7 ± 0.3% | 91475.3 ± 1.5% | 1.100 | — | — |
| string: silesia/nci | 1048576 | 71324.0 ± 15.2% | 71200.3 ± 1.0% | 1.002 | — | — |
| string: silesia/reymont | 1048576 | 72074.4 ± 1.0% | 71912.8 ± 1.3% | 1.002 | — | — |
| string: silesia/samba | 65546 | 98488.6 ± 2.0% | 90511.5 ± 0.2% | 1.088 | — | — |
| string: silesia/webster | 1048576 | 73109.2 ± 11.6% | 74700.0 ± 1.1% | 0.979 | — | — |
| string: silesia/xml | 1048576 | 71837.5 ± 0.6% | 71874.4 ± 1.5% | 0.999 | — | — |
| string: canterbury/alice29.txt | 152089 | 100206.9 ± 1.3% | 91544.4 ± 0.2% | 1.095 | — | — |
| string: canterbury/asyoulik.txt | 125179 | 100095.3 ± 0.2% | 91645.6 ± 0.6% | 1.092 | — | — |
| string: canterbury/lcet10.txt | 426754 | 83656.7 ± 8.4% | 79656.4 ± 0.9% | 1.050 | — | — |
| string: canterbury/plrabn12.txt | 481861 | 83306.9 ± 1.7% | 80354.4 ± 0.3% | 1.037 | — | — |
| string: canterbury-large/E.coli | 1048576 | 71432.7 ± 1.3% | 70589.2 ± 1.2% | 1.012 | — | — |
| string: canterbury-large/bible.txt | 1048576 | 72352.0 ± 1.0% | 71853.5 ± 1.5% | 1.007 | — | — |
| string: canterbury-large/world192.txt | 1048576 | 71968.8 ± 1.6% | 71691.8 ± 0.5% | 1.004 | — | — |
| string: http/html-1m | 1048576 | 67272.8 ± 1.5% | 66832.5 ± 0.6% | 1.007 | — | — |
| string: http/json-1m | 1048576 | 60792.9 ± 0.5% | 64699.7 ± 6.6% | 0.940 | — | — |
| string: http/js-1m | 1048576 | 72248.3 ± 2.8% | 71735.8 ± 0.8% | 1.007 | — | — |
| string: http/css-1m | 1048576 | 72385.6 ± 1.4% | 71453.7 ± 0.9% | 1.013 | — | — |
| string: dickens as Cyrillic and CJK | 1847045 | 14604.0 ± 0.4% | 15361.7 ± 0.6% | 0.951 | — | — |

## Losses to simdutf

None.

## UTF-8 validation by the buffer's offset from a 64-octet line

| Buffer | Octets | Offset | stdx, MB/s | simdutf, MB/s | stdx / simdutf | stdx with AVX2 alone, MB/s | stdx / stdx with AVX2 alone |
|---|---|---|---|---|---|---|---|
| string: canterbury-large/bible.txt | 1048576 | 0 | 72571.1 ± 11.8% | 74283.7 ± 1.7% | 0.977 | — | — |
| string: canterbury-large/bible.txt | 1048576 | 1 | 71996.8 ± 0.5% | 71222.6 ± 1.2% | 1.011 | — | — |
| string: canterbury-large/bible.txt | 1048576 | 8 | 71056.2 ± 3.2% | 71048.8 ± 2.5% | 1.000 | — | — |
| string: canterbury-large/bible.txt | 1048576 | 16 | 72001.2 ± 0.8% | 71225.3 ± 20.6% | 1.011 | — | — |
| string: canterbury-large/bible.txt | 1048576 | 32 | 71907.7 ± 0.8% | 74836.7 ± 1.3% | 0.961 | — | — |
| string: canterbury-large/bible.txt | 1048576 | 48 | 72545.0 ± 2.5% | 71254.1 ± 1.3% | 1.018 | — | — |
| string: dickens as Cyrillic and CJK | 1048576 | 0 | 14603.8 ± 0.8% | 15331.1 ± 0.3% | 0.953 | — | — |
| string: dickens as Cyrillic and CJK | 1048576 | 1 | 14602.8 ± 1.9% | 15315.2 ± 3.8% | 0.953 | — | — |
| string: dickens as Cyrillic and CJK | 1048576 | 8 | 14593.6 ± 0.2% | 15289.6 ± 1.1% | 0.954 | — | — |
| string: dickens as Cyrillic and CJK | 1048576 | 16 | 14602.3 ± 0.8% | 15291.2 ± 0.4% | 0.955 | — | — |
| string: dickens as Cyrillic and CJK | 1048576 | 32 | 14593.1 ± 0.5% | 15282.6 ± 0.2% | 0.955 | — | — |
| string: dickens as Cyrillic and CJK | 1048576 | 48 | 14604.1 ± 0.3% | 15270.7 ± 0.3% | 0.956 | — | — |

## Messages against serde_json's typed code

stdx's encoder a token a call through `TextWriter`'s methods, a member's name and its value in one `member_*` call, beside serde_json 1.0.154 writing the same messages from Rust types, as code of the form serde's derive generates writes them. Octets are the ones written.

| Workload | Octets | TextWriter's methods, MB/s | serde_json typed, MB/s | stdx / serde_json typed |
|---|---|---|---|---|
| messages: 11 string members | 1025025 | 928.9 ± 21.6% | 536.4 ± 13.9% | 1.732 |
| messages: 50 nested objects | 1121600 | 1148.3 ± 2.8% | 628.8 ± 0.6% | 1.826 |
| messages: a tree of 341 objects | 612600 | 433.7 ± 11.0% | 352.8 ± 26.6% | 1.230 |

## Against the baselines

stdx with every claim on, timed beside simdjson 5.1.1, yyjson 0.13.0, Zig 0.16.0's std.json, serde_json 1.0.154 and Go's encoding/json/jsontext in the same run. Each ratio is stdx's throughput over the baseline's; below 1, the baseline is faster. stdx is built for the architecture's baseline CPU in ReleaseSafe. Each baseline is built for the same CPU, the C, C++ and Zig ones in ReleaseFast (decision 75), and simdjson picks its kernel at run time. Decoding visits every value; encoding writes each text from its tokens.

## Decoding against the baselines

Octets are the text's. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1024.4 ± 1.0% | 1004.7 ± 0.5% | 915.3 ± 3.9% | 261.8 ± 0.6% | 531.8 ± 9.3% | 255.4 ± 3.1% | 1.020 | 1.119 | 3.914 | 1.926 | 4.011 |
| qlog records, JSON text sequence | 1467503 | 846.5 ± 0.9% | 801.7 ± 2.3% | 805.8 ± 6.9% | 230.3 ± 2.3% | 592.6 ± 3.0% | 245.6 ± 3.3% | 1.056 | 1.051 | 3.676 | 1.428 | 3.446 |
| messages: 11 string members | 1025025 | 897.9 ± 1.6% | 1102.2 ± 1.2% | 675.6 ± 1.6% | 259.9 ± 3.2% | 456.7 ± 4.8% | 245.9 ± 12.2% | 0.815 | 1.329 | 3.455 | 1.966 | 3.652 |
| messages: 50 nested objects | 1121600 | 1019.9 ± 0.5% | 999.5 ± 1.7% | 1043.1 ± 5.3% | 280.9 ± 0.8% | 692.6 ± 0.5% | 322.7 ± 7.5% | 1.020 | 0.978 | 3.631 | 1.473 | 3.160 |
| messages: a tree of 341 objects | 612600 | 374.7 ± 2.9% | 433.2 ± 2.0% | 429.3 ± 9.3% | 123.7 ± 1.9% | 447.2 ± 4.2% | 145.3 ± 5.0% | 0.865 | 0.873 | 3.028 | 0.838 | 2.578 |
| string: silesia/dickens | 172528 | 6202.2 ± 0.9% | 2889.7 ± 0.1% | 2064.4 ± 2.8% | 285.1 ± 4.6% | 2163.5 ± 7.0% | 473.8 ± 2.8% | 2.146 | 3.004 | 21.752 | 2.867 | 13.090 |
| string: silesia/nci | 1075110 | 5112.8 ± 0.4% | 3467.9 ± 0.5% | 2855.2 ± 5.1% | 453.7 ± 1.4% | 2346.3 ± 0.7% | 515.0 ± 1.7% | 1.474 | 1.791 | 11.269 | 2.179 | 9.928 |
| string: silesia/reymont | 1075159 | 3292.7 ± 0.9% | 2193.7 ± 2.6% | 1782.9 ± 6.0% | 292.7 ± 3.5% | 1618.5 ± 0.5% | 470.8 ± 3.4% | 1.501 | 1.847 | 11.249 | 2.034 | 6.994 |
| string: silesia/samba | 97582 | 3340.7 ± 1.6% | 2741.9 ± 1.7% | 1609.7 ± 3.9% | 253.1 ± 4.3% | 1278.4 ± 0.5% | 347.2 ± 46.4% | 1.218 | 2.075 | 13.199 | 2.613 | 9.622 |
| string: silesia/webster | 1098490 | 4096.3 ± 1.9% | 2031.0 ± 0.3% | 1668.2 ± 0.9% | 286.1 ± 1.3% | 1668.3 ± 0.8% | 425.3 ± 4.8% | 2.017 | 2.455 | 14.317 | 2.455 | 9.633 |
| string: silesia/xml | 1090118 | 5508.6 ± 0.3% | 3714.3 ± 0.5% | 2177.3 ± 1.1% | 374.7 ± 1.1% | 2361.9 ± 2.6% | 507.5 ± 3.0% | 1.483 | 2.530 | 14.700 | 2.332 | 10.855 |
| string: canterbury/alice29.txt | 159425 | 4878.7 ± 1.7% | 2400.2 ± 0.5% | 1840.1 ± 2.1% | 269.4 ± 2.0% | 1942.5 ± 0.5% | 422.1 ± 6.8% | 2.033 | 2.651 | 18.109 | 2.512 | 11.559 |
| string: canterbury/asyoulik.txt | 132198 | 3785.9 ± 3.8% | 2111.7 ± 0.1% | 1477.7 ± 3.5% | 256.9 ± 7.5% | 1590.3 ± 1.4% | 399.2 ± 3.1% | 1.793 | 2.562 | 14.737 | 2.381 | 9.483 |
| string: canterbury/lcet10.txt | 441884 | 6087.2 ± 1.0% | 2790.6 ± 0.4% | 2006.4 ± 1.4% | 304.6 ± 2.1% | 2143.6 ± 0.9% | 473.6 ± 3.4% | 2.181 | 3.034 | 19.984 | 2.840 | 12.854 |
| string: canterbury/plrabn12.txt | 503330 | 4738.4 ± 22.4% | 2699.7 ± 0.2% | 1716.3 ± 11.6% | 277.8 ± 2.1% | 2005.5 ± 0.5% | 453.6 ± 2.5% | 1.755 | 2.761 | 17.057 | 2.363 | 10.446 |
| string: canterbury-large/E.coli | 1048578 | 37337.5 ± 8.9% | 7728.0 ± 0.7% | 3527.2 ± 0.6% | 868.3 ± 1.9% | 5514.9 ± 0.6% | 816.3 ± 2.3% | 4.831 | 10.586 | 42.999 | 6.770 | 45.740 |
| string: canterbury-large/bible.txt | 1055886 | 9600.7 ± 0.5% | 3909.3 ± 1.0% | 2619.9 ± 0.7% | 326.2 ± 3.8% | 2961.3 ± 11.5% | 604.7 ± 2.6% | 2.456 | 3.665 | 29.434 | 3.242 | 15.878 |
| string: canterbury-large/world192.txt | 1103121 | 3784.2 ± 1.6% | 1977.2 ± 0.4% | 1692.9 ± 0.2% | 281.8 ± 1.4% | 1687.4 ± 1.2% | 424.7 ± 3.3% | 1.914 | 2.235 | 13.430 | 2.243 | 8.909 |
| string: http/html-1m | 1058582 | 7954.7 ± 1.0% | 3400.3 ± 2.7% | 2422.9 ± 2.1% | 373.9 ± 1.4% | 2722.1 ± 1.0% | 424.3 ± 1.6% | 2.339 | 3.283 | 21.277 | 2.922 | 18.749 |
| string: http/json-1m | 1190272 | 3313.3 ± 0.3% | 1201.6 ± 0.2% | 1543.3 ± 10.5% | 340.1 ± 5.0% | 824.7 ± 1.0% | 300.8 ± 0.8% | 2.757 | 2.147 | 9.741 | 4.017 | 11.014 |
| string: http/js-1m | 1144362 | 2654.6 ± 0.6% | 1326.0 ± 0.3% | 1203.4 ± 1.8% | 262.3 ± 1.3% | 1152.4 ± 3.1% | 293.6 ± 24.3% | 2.002 | 2.206 | 10.119 | 2.304 | 9.042 |
| string: http/css-1m | 1097820 | 3034.0 ± 1.9% | 2510.9 ± 0.3% | 1571.4 ± 1.4% | 342.4 ± 2.4% | 1523.6 ± 1.3% | 328.8 ± 2.8% | 1.208 | 1.931 | 8.862 | 1.991 | 9.227 |
| string: dickens as Cyrillic and CJK | 1883069 | 5357.8 ± 0.5% | 3164.2 ± 0.8% | 678.8 ± 1.0% | 269.7 ± 6.0% | 488.4 ± 4.3% | 138.1 ± 1.9% | 1.693 | 7.893 | 19.866 | 10.971 | 38.809 |
| string: dickens as Cyrillic and CJK, as \u escapes | 5075485 | 1059.7 ± 8.1% | 1073.8 ± 8.4% | 844.8 ± 15.1% | 159.4 ± 2.0% | 380.6 ± 3.0% | 189.2 ± 13.9% | 0.987 | 1.254 | 6.650 | 2.784 | 5.600 |
| hex: silesia/dickens | 524290 | 37078.1 ± 3.0% | 7726.1 ± 0.9% | 3551.0 ± 1.6% | 431.5 ± 4.8% | 5499.1 ± 1.7% | 777.7 ± 3.8% | 4.799 | 10.442 | 85.936 | 6.743 | 47.677 |
| hex: silesia/mozilla | 524290 | 33857.6 ± 2.1% | 7750.7 ± 0.3% | 3540.8 ± 0.9% | 381.4 ± 2.9% | 5510.4 ± 0.8% | 791.5 ± 1.7% | 4.368 | 9.562 | 88.767 | 6.144 | 42.775 |
| hex: silesia/mr | 524290 | 37213.8 ± 1.0% | 7721.6 ± 0.5% | 3558.6 ± 0.7% | 553.4 ± 2.2% | 5510.0 ± 1.5% | 782.5 ± 0.2% | 4.819 | 10.458 | 67.247 | 6.754 | 47.559 |
| hex: silesia/nci | 524290 | 36639.7 ± 3.0% | 7763.2 ± 0.4% | 3548.9 ± 0.5% | 616.0 ± 2.9% | 5476.4 ± 7.7% | 785.6 ± 10.7% | 4.720 | 10.324 | 59.476 | 6.690 | 46.639 |
| hex: silesia/ooffice | 524290 | 35018.8 ± 5.0% | 7739.7 ± 2.4% | 3535.9 ± 0.4% | 330.6 ± 1.9% | 5487.0 ± 0.7% | 775.4 ± 3.5% | 4.525 | 9.904 | 105.914 | 6.382 | 45.161 |
| hex: silesia/osdb | 524290 | 36557.9 ± 1.7% | 7751.3 ± 0.8% | 3530.6 ± 0.6% | 424.4 ± 3.2% | 5476.7 ± 16.7% | 786.9 ± 3.7% | 4.716 | 10.355 | 86.148 | 6.675 | 46.459 |
| hex: silesia/reymont | 524290 | 37421.7 ± 3.9% | 7756.5 ± 0.8% | 3557.4 ± 0.9% | 466.6 ± 0.4% | 5523.3 ± 0.6% | 794.5 ± 4.5% | 4.825 | 10.519 | 80.207 | 6.775 | 47.101 |
| hex: silesia/samba | 524290 | 35181.9 ± 2.3% | 7731.9 ± 3.3% | 3525.2 ± 2.1% | 334.1 ± 1.7% | 5489.9 ± 3.4% | 801.3 ± 3.6% | 4.550 | 9.980 | 105.304 | 6.408 | 43.909 |
| hex: silesia/sao | 524290 | 37302.1 ± 2.4% | 7712.8 ± 1.1% | 3529.3 ± 5.6% | 272.5 ± 1.2% | 5477.0 ± 3.4% | 813.7 ± 3.4% | 4.836 | 10.569 | 136.872 | 6.811 | 45.843 |
| hex: silesia/webster | 524290 | 36579.2 ± 2.8% | 7766.3 ± 0.4% | 3538.3 ± 1.0% | 399.6 ± 2.5% | 5517.6 ± 2.0% | 809.0 ± 2.3% | 4.710 | 10.338 | 91.545 | 6.630 | 45.217 |
| hex: silesia/x-ray | 524290 | 35699.1 ± 4.7% | 7739.9 ± 0.8% | 3527.3 ± 0.8% | 404.4 ± 1.5% | 5506.9 ± 0.7% | 808.8 ± 3.6% | 4.612 | 10.121 | 88.273 | 6.483 | 44.139 |
| hex: silesia/xml | 524290 | 37296.4 ± 4.9% | 7697.9 ± 4.2% | 3526.7 ± 0.8% | 565.3 ± 2.4% | 5496.8 ± 0.5% | 816.4 ± 3.7% | 4.845 | 10.575 | 65.980 | 6.785 | 45.682 |
| hex: canterbury/alice29.txt | 304180 | 36975.3 ± 4.1% | 7734.9 ± 0.8% | 3582.0 ± 0.7% | 427.2 ± 1.2% | 5492.3 ± 3.3% | 811.6 ± 4.4% | 4.780 | 10.323 | 86.553 | 6.732 | 45.560 |
| hex: canterbury/asyoulik.txt | 250360 | 36691.0 ± 3.3% | 7778.8 ± 0.6% | 3541.8 ± 1.1% | 419.3 ± 2.0% | 5463.7 ± 1.1% | 805.4 ± 3.6% | 4.717 | 10.359 | 87.509 | 6.715 | 45.556 |
| hex: canterbury/cp.html | 49208 | 40464.5 ± 1.4% | 7765.6 ± 0.8% | 3521.1 ± 1.8% | 406.9 ± 3.2% | 5428.3 ± 0.7% | 799.3 ± 2.6% | 5.211 | 11.492 | 99.440 | 7.454 | 50.622 |
| hex: canterbury/fields.c | 22302 | 38075.8 ± 10.8% | 7697.7 ± 1.8% | 3552.0 ± 1.8% | 425.2 ± 2.3% | 5455.5 ± 3.0% | 763.7 ± 4.7% | 4.946 | 10.720 | 89.549 | 6.979 | 49.859 |
| hex: canterbury/grammar.lsp | 7444 | 35759.3 ± 2.9% | 7492.3 ± 0.6% | 3614.4 ± 0.5% | 477.0 ± 5.0% | 5311.0 ± 1.1% | 754.1 ± 3.7% | 4.773 | 9.894 | 74.965 | 6.733 | 47.422 |
| hex: canterbury/kennedy.xls | 524290 | 37323.4 ± 10.2% | 7727.7 ± 1.5% | 3499.4 ± 4.9% | 619.0 ± 5.7% | 5492.5 ± 0.4% | 793.7 ± 6.7% | 4.830 | 10.666 | 60.300 | 6.795 | 47.027 |
| hex: canterbury/lcet10.txt | 524290 | 36001.0 ± 4.2% | 7781.9 ± 0.3% | 3521.0 ± 2.5% | 429.2 ± 3.1% | 5510.2 ± 0.8% | 808.4 ± 3.3% | 4.626 | 10.225 | 83.880 | 6.533 | 44.534 |
| hex: canterbury/plrabn12.txt | 524290 | 36732.1 ± 2.2% | 7744.1 ± 0.6% | 3523.0 ± 2.1% | 414.9 ± 2.8% | 5508.9 ± 0.8% | 781.8 ± 2.3% | 4.743 | 10.426 | 88.530 | 6.668 | 46.983 |
| hex: canterbury/ptt5 | 524290 | 35780.3 ± 2.9% | 7766.4 ± 0.7% | 3521.5 ± 0.6% | 526.2 ± 5.9% | 5483.3 ± 0.8% | 792.2 ± 2.9% | 4.607 | 10.160 | 67.995 | 6.525 | 45.167 |
| hex: canterbury/sum | 76482 | 38339.2 ± 0.9% | 7795.6 ± 0.9% | 3557.9 ± 1.0% | 466.1 ± 1.5% | 5475.9 ± 16.5% | 793.9 ± 5.1% | 4.918 | 10.776 | 82.252 | 7.001 | 48.290 |
| hex: canterbury/xargs.1 | 8456 | 37571.7 ± 1.5% | 7536.1 ± 0.1% | 3596.9 ± 1.2% | 454.0 ± 2.8% | 5300.8 ± 1.4% | 778.8 ± 3.2% | 4.986 | 10.446 | 82.762 | 7.088 | 48.241 |
| hex: canterbury-large/E.coli | 524290 | 36262.1 ± 17.3% | 7733.1 ± 0.8% | 3540.8 ± 2.9% | 711.9 ± 3.1% | 5485.3 ± 3.1% | 787.5 ± 8.9% | 4.689 | 10.241 | 50.934 | 6.611 | 46.049 |
| hex: canterbury-large/bible.txt | 524290 | 37108.0 ± 2.7% | 7750.8 ± 5.1% | 3518.0 ± 0.3% | 450.7 ± 2.5% | 5506.1 ± 0.4% | 796.7 ± 2.6% | 4.788 | 10.548 | 82.342 | 6.739 | 46.579 |
| hex: canterbury-large/world192.txt | 524290 | 36088.4 ± 1.8% | 7682.3 ± 2.3% | 3523.0 ± 8.3% | 413.8 ± 5.8% | 5512.4 ± 0.6% | 788.3 ± 5.1% | 4.698 | 10.244 | 87.203 | 6.547 | 45.780 |
| hex: http/html-1kx1024 | 2099200 | 16392.8 ± 4.5% | 6653.5 ± 0.1% | 3199.7 ± 3.4% | 439.7 ± 1.5% | 4731.8 ± 0.7% | 696.2 ± 1.5% | 2.464 | 5.123 | 37.280 | 3.464 | 23.545 |
| hex: http/html-16kx64 | 2097280 | 33625.6 ± 3.4% | 7660.3 ± 0.3% | 3523.1 ± 0.6% | 448.5 ± 3.1% | 5419.6 ± 24.4% | 773.9 ± 5.8% | 4.390 | 9.544 | 74.972 | 6.204 | 43.451 |
| hex: http/html-1m | 524290 | 37227.7 ± 9.5% | 7770.0 ± 0.5% | 3540.6 ± 0.8% | 450.4 ± 0.7% | 5503.4 ± 0.2% | 782.4 ± 3.9% | 4.791 | 10.515 | 82.658 | 6.765 | 47.582 |
| hex: http/json-1kx1024 | 2099200 | 16537.5 ± 2.7% | 6648.7 ± 0.1% | 3226.3 ± 2.2% | 572.1 ± 4.8% | 4739.6 ± 0.7% | 700.5 ± 4.3% | 2.487 | 5.126 | 28.908 | 3.489 | 23.608 |
| hex: http/json-16kx64 | 2097280 | 34448.2 ± 2.1% | 7671.1 ± 2.0% | 3529.2 ± 0.5% | 582.6 ± 0.9% | 5425.4 ± 0.6% | 758.6 ± 8.2% | 4.491 | 9.761 | 59.126 | 6.349 | 45.410 |
| hex: http/json-1m | 524290 | 37016.3 ± 7.6% | 7756.8 ± 0.4% | 3517.1 ± 1.8% | 593.2 ± 4.0% | 5497.6 ± 3.0% | 795.0 ± 5.9% | 4.772 | 10.525 | 62.398 | 6.733 | 46.561 |
| hex: http/js-1kx1024 | 2099200 | 16645.0 ± 2.6% | 6659.9 ± 0.4% | 3231.1 ± 2.5% | 430.9 ± 2.5% | 4732.1 ± 1.3% | 702.5 ± 2.5% | 2.499 | 5.151 | 38.626 | 3.517 | 23.695 |
| hex: http/js-16kx64 | 2097280 | 34899.9 ± 2.9% | 7678.7 ± 0.2% | 3523.4 ± 0.6% | 436.8 ± 5.3% | 5422.0 ± 0.4% | 775.1 ± 4.0% | 4.545 | 9.905 | 79.895 | 6.437 | 45.025 |
| hex: http/js-1m | 524290 | 35280.8 ± 7.2% | 7772.9 ± 0.7% | 3525.9 ± 9.2% | 460.7 ± 2.9% | 5532.4 ± 0.8% | 797.5 ± 5.0% | 4.539 | 10.006 | 76.578 | 6.377 | 44.239 |
| hex: http/css-1kx1024 | 2099200 | 16380.2 ± 3.7% | 6653.5 ± 1.0% | 3224.5 ± 1.5% | 492.4 ± 1.9% | 4730.0 ± 0.2% | 699.2 ± 2.9% | 2.462 | 5.080 | 33.265 | 3.463 | 23.429 |
| hex: http/css-16kx64 | 2097280 | 34315.7 ± 4.2% | 7676.1 ± 0.5% | 3533.3 ± 1.3% | 508.4 ± 2.8% | 5433.6 ± 0.2% | 791.3 ± 4.5% | 4.470 | 9.712 | 67.498 | 6.315 | 43.366 |
| hex: http/css-1m | 524290 | 36604.0 ± 4.1% | 7735.1 ± 0.4% | 3518.4 ± 1.0% | 496.4 ± 1.8% | 5498.4 ± 0.3% | 794.7 ± 3.1% | 4.732 | 10.403 | 73.734 | 6.657 | 46.058 |
| hex: shuffled/dickens-1m | 524290 | 36154.5 ± 1.3% | 7727.0 ± 8.8% | 3508.6 ± 4.0% | 437.8 ± 2.3% | 5515.2 ± 5.5% | 785.9 ± 3.5% | 4.679 | 10.305 | 82.585 | 6.555 | 46.003 |

## Encoding against the baselines

Octets are the ones stdx writes. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1358.5 ± 0.7% | 1142.7 ± 1.0% | 865.2 ± 1.1% | 324.9 ± 2.1% | 352.8 ± 12.7% | 311.4 ± 1.0% | 1.189 | 1.570 | 4.181 | 3.850 | 4.362 |
| qlog records, JSON text sequence | 1467503 | 1169.1 ± 0.5% | 877.4 ± 0.4% | 703.8 ± 0.5% | 321.5 ± 2.0% | 396.6 ± 1.8% | 229.8 ± 1.6% | 1.332 | 1.661 | 3.637 | 2.947 | 5.087 |
| messages: 11 string members | 1025025 | 1085.1 ± 3.0% | 894.4 ± 2.1% | 667.2 ± 3.6% | 312.0 ± 1.4% | 319.6 ± 3.7% | 286.1 ± 4.8% | 1.213 | 1.626 | 3.478 | 3.395 | 3.793 |
| messages: 50 nested objects | 1121600 | 1382.1 ± 1.0% | 1194.7 ± 1.5% | 922.0 ± 2.8% | 394.8 ± 1.6% | 425.1 ± 3.1% | 320.3 ± 2.4% | 1.157 | 1.499 | 3.501 | 3.252 | 4.315 |
| messages: a tree of 341 objects | 612600 | 449.3 ± 3.2% | 598.3 ± 5.1% | 376.3 ± 1.9% | 198.3 ± 1.8% | 252.9 ± 6.0% | 124.4 ± 7.8% | 0.751 | 1.194 | 2.265 | 1.776 | 3.610 |
| string: silesia/dickens | 172528 | 9197.7 ± 0.5% | 2950.4 ± 2.4% | 2058.8 ± 2.0% | 354.6 ± 1.3% | 1040.4 ± 1.5% | 561.4 ± 1.2% | 3.117 | 4.468 | 25.937 | 8.840 | 16.385 |
| string: silesia/nci | 1075110 | 8749.5 ± 4.2% | 3165.8 ± 2.7% | 2790.5 ± 2.4% | 774.2 ± 5.6% | 1087.1 ± 2.6% | 565.3 ± 0.9% | 2.764 | 3.135 | 11.301 | 8.049 | 15.478 |
| string: silesia/reymont | 1075159 | 3846.4 ± 0.6% | 1657.5 ± 1.1% | 1748.0 ± 0.5% | 361.8 ± 1.0% | 953.8 ± 1.2% | 553.1 ± 1.0% | 2.321 | 2.200 | 10.631 | 4.033 | 6.955 |
| string: silesia/samba | 97582 | 4634.9 ± 1.0% | 1952.6 ± 1.9% | 2079.9 ± 6.5% | 276.3 ± 3.8% | 882.3 ± 2.7% | 618.2 ± 1.2% | 2.374 | 2.228 | 16.774 | 5.253 | 7.498 |
| string: silesia/webster | 1098490 | 5098.9 ± 1.7% | 1631.2 ± 1.0% | 1540.5 ± 1.4% | 358.4 ± 1.8% | 931.5 ± 1.0% | 456.4 ± 0.8% | 3.126 | 3.310 | 14.225 | 5.474 | 11.171 |
| string: silesia/xml | 1090118 | 7863.2 ± 3.9% | 2665.9 ± 0.2% | 2161.9 ± 0.5% | 522.4 ± 1.0% | 1121.8 ± 0.6% | 563.5 ± 0.7% | 2.950 | 3.637 | 15.053 | 7.010 | 13.955 |
| string: canterbury/alice29.txt | 159425 | 9879.3 ± 1.6% | 2434.7 ± 1.4% | 1810.2 ± 18.7% | 339.0 ± 3.3% | 1018.2 ± 1.3% | 560.3 ± 0.5% | 4.058 | 5.458 | 29.146 | 9.703 | 17.632 |
| string: canterbury/asyoulik.txt | 132198 | 7991.9 ± 0.8% | 2193.9 ± 1.4% | 1543.8 ± 2.2% | 341.4 ± 0.8% | 896.8 ± 1.3% | 546.5 ± 0.7% | 3.643 | 5.177 | 23.407 | 8.912 | 14.624 |
| string: canterbury/lcet10.txt | 441884 | 8871.6 ± 3.2% | 2449.3 ± 2.3% | 1971.7 ± 1.9% | 385.2 ± 3.2% | 1024.9 ± 4.2% | 559.4 ± 4.5% | 3.622 | 4.499 | 23.029 | 8.656 | 15.859 |
| string: canterbury/plrabn12.txt | 503330 | 6043.4 ± 2.3% | 1842.5 ± 1.2% | 1686.4 ± 0.8% | 361.6 ± 3.9% | 994.4 ± 1.3% | 564.8 ± 1.6% | 3.280 | 3.584 | 16.711 | 6.078 | 10.701 |
| string: canterbury-large/E.coli | 1048578 | 37365.3 ± 14.2% | 11633.6 ± 0.5% | 3393.2 ± 0.2% | 1422.3 ± 0.3% | 1399.2 ± 20.3% | 576.9 ± 0.9% | 3.212 | 11.012 | 26.270 | 26.705 | 64.765 |
| string: canterbury-large/bible.txt | 1055886 | 7046.6 ± 0.7% | 3969.4 ± 0.7% | 2675.3 ± 0.5% | 437.2 ± 3.4% | 1195.3 ± 1.3% | 574.3 ± 0.8% | 1.775 | 2.634 | 16.116 | 5.895 | 12.270 |
| string: canterbury-large/world192.txt | 1103121 | 5149.7 ± 6.5% | 1441.9 ± 3.3% | 1582.9 ± 18.2% | 353.4 ± 2.1% | 925.0 ± 0.7% | 542.6 ± 1.3% | 3.571 | 3.253 | 14.571 | 5.568 | 9.491 |
| string: http/html-1m | 1058582 | 8508.2 ± 0.7% | 3855.2 ± 0.8% | 2494.6 ± 0.3% | 425.4 ± 1.1% | 1184.9 ± 8.7% | 525.3 ± 0.7% | 2.207 | 3.411 | 19.999 | 7.180 | 16.197 |
| string: http/json-1m | 1190272 | 6643.7 ± 0.9% | 1229.3 ± 1.0% | 1289.2 ± 1.6% | 414.5 ± 1.8% | 777.0 ± 1.2% | 508.8 ± 1.0% | 5.404 | 5.153 | 16.026 | 8.551 | 13.059 |
| string: http/js-1m | 1144362 | 5100.8 ± 11.3% | 992.2 ± 2.6% | 1110.5 ± 1.9% | 295.1 ± 3.3% | 782.1 ± 2.5% | 475.3 ± 1.8% | 5.141 | 4.593 | 17.284 | 6.522 | 10.731 |
| string: http/css-1m | 1097820 | 6896.7 ± 1.7% | 1288.1 ± 1.4% | 1617.1 ± 0.3% | 427.0 ± 3.9% | 856.3 ± 1.4% | 533.0 ± 0.9% | 5.354 | 4.265 | 16.152 | 8.054 | 12.940 |
| string: dickens as Cyrillic and CJK | 1883069 | 5366.2 ± 0.1% | 3016.1 ± 0.2% | 334.9 ± 7.6% | 272.9 ± 5.0% | 409.3 ± 1.9% | 293.8 ± 0.3% | 1.779 | 16.025 | 19.665 | 13.112 | 18.265 |
| hex: silesia/dickens | 524290 | 30837.7 ± 1.6% | 1558.6 ± 1.9% | 1093.7 ± 0.7% | 426.0 ± 1.6% | 787.9 ± 0.6% | 444.8 ± 2.2% | 19.786 | 28.196 | 72.393 | 39.137 | 69.333 |
| hex: silesia/mozilla | 524290 | 34839.9 ± 1.0% | 1567.1 ± 0.8% | 1093.1 ± 1.6% | 370.8 ± 1.8% | 788.3 ± 0.3% | 438.4 ± 3.9% | 22.232 | 31.872 | 93.955 | 44.195 | 79.475 |
| hex: silesia/mr | 524290 | 34630.1 ± 1.5% | 1565.3 ± 0.6% | 1094.1 ± 0.7% | 507.3 ± 2.7% | 791.2 ± 0.3% | 440.0 ± 6.2% | 22.124 | 31.650 | 68.262 | 43.771 | 78.704 |
| hex: silesia/nci | 524290 | 34960.8 ± 1.0% | 1567.6 ± 1.4% | 1092.9 ± 0.9% | 569.8 ± 2.2% | 787.6 ± 1.6% | 436.4 ± 1.2% | 22.302 | 31.990 | 61.352 | 44.387 | 80.103 |
| hex: silesia/ooffice | 524290 | 33338.0 ± 1.6% | 1565.3 ± 0.7% | 1093.6 ± 0.4% | 324.0 ± 1.2% | 791.1 ± 1.7% | 431.8 ± 7.7% | 21.298 | 30.484 | 102.909 | 42.143 | 77.215 |
| hex: silesia/osdb | 524290 | 31982.4 ± 2.6% | 1558.4 ± 2.1% | 1090.4 ± 2.1% | 412.1 ± 3.1% | 786.9 ± 3.1% | 431.8 ± 3.0% | 20.522 | 29.331 | 77.612 | 40.644 | 74.072 |
| hex: silesia/reymont | 524290 | 33529.6 ± 0.2% | 1570.5 ± 1.4% | 1094.2 ± 0.4% | 443.5 ± 1.6% | 793.0 ± 0.3% | 441.4 ± 7.4% | 21.350 | 30.642 | 75.605 | 42.283 | 75.963 |
| hex: silesia/samba | 524290 | 34961.9 ± 3.9% | 1569.0 ± 1.5% | 1092.4 ± 2.1% | 323.4 ± 2.7% | 785.5 ± 3.4% | 422.6 ± 3.3% | 22.283 | 32.006 | 108.094 | 44.507 | 82.736 |
| hex: silesia/sao | 524290 | 33325.9 ± 1.9% | 1564.9 ± 1.2% | 1093.0 ± 0.6% | 263.4 ± 2.6% | 780.1 ± 3.0% | 426.8 ± 3.1% | 21.296 | 30.491 | 126.524 | 42.722 | 78.081 |
| hex: silesia/webster | 524290 | 35459.5 ± 1.4% | 1560.6 ± 1.7% | 1090.8 ± 0.8% | 393.7 ± 2.8% | 787.9 ± 0.4% | 434.4 ± 2.8% | 22.722 | 32.506 | 90.073 | 45.005 | 81.622 |
| hex: silesia/x-ray | 524290 | 33928.5 ± 0.9% | 1565.4 ± 0.8% | 1089.9 ± 0.8% | 397.6 ± 0.7% | 790.4 ± 0.4% | 438.2 ± 4.4% | 21.673 | 31.130 | 85.339 | 42.926 | 77.430 |
| hex: silesia/xml | 524290 | 34649.9 ± 0.7% | 1569.6 ± 1.2% | 1094.0 ± 2.7% | 581.5 ± 0.2% | 790.2 ± 0.8% | 441.5 ± 2.9% | 22.075 | 31.672 | 59.590 | 43.848 | 78.485 |
| hex: canterbury/alice29.txt | 304180 | 33119.5 ± 2.5% | 1583.9 ± 0.4% | 1096.5 ± 0.3% | 429.7 ± 17.8% | 804.3 ± 0.8% | 443.8 ± 4.0% | 20.909 | 30.204 | 77.081 | 41.178 | 74.632 |
| hex: canterbury/asyoulik.txt | 250360 | 30981.7 ± 18.2% | 1580.9 ± 2.4% | 1100.2 ± 2.4% | 405.0 ± 3.3% | 803.9 ± 3.8% | 432.8 ± 3.5% | 19.597 | 28.160 | 76.490 | 38.540 | 71.582 |
| hex: canterbury/cp.html | 49208 | 31510.5 ± 3.9% | 1604.4 ± 1.2% | 1101.6 ± 0.5% | 436.3 ± 3.0% | 804.5 ± 1.3% | 438.2 ± 3.8% | 19.640 | 28.604 | 72.223 | 39.170 | 71.902 |
| hex: canterbury/fields.c | 22302 | 32758.7 ± 0.5% | 1588.6 ± 7.6% | 1092.6 ± 0.6% | 522.6 ± 5.0% | 804.5 ± 2.0% | 429.9 ± 2.2% | 20.621 | 29.983 | 62.689 | 40.718 | 76.201 |
| hex: canterbury/grammar.lsp | 7444 | 32353.5 ± 0.8% | 1644.2 ± 0.4% | 1120.3 ± 0.4% | 537.7 ± 3.0% | 810.3 ± 12.5% | 431.0 ± 3.6% | 19.678 | 28.880 | 60.167 | 39.928 | 75.072 |
| hex: canterbury/kennedy.xls | 524290 | 31147.3 ± 2.4% | 1556.4 ± 6.2% | 1090.9 ± 0.6% | 577.2 ± 4.0% | 782.6 ± 0.4% | 438.5 ± 2.6% | 20.012 | 28.552 | 53.960 | 39.802 | 71.035 |
| hex: canterbury/lcet10.txt | 524290 | 35489.8 ± 0.9% | 1570.9 ± 0.7% | 1093.9 ± 3.1% | 427.2 ± 2.3% | 786.0 ± 1.2% | 440.3 ± 1.9% | 22.592 | 32.444 | 83.067 | 45.154 | 80.606 |
| hex: canterbury/plrabn12.txt | 524290 | 33554.3 ± 3.1% | 1558.7 ± 8.6% | 1091.2 ± 0.3% | 411.2 ± 4.8% | 783.4 ± 2.4% | 435.4 ± 3.6% | 21.527 | 30.751 | 81.606 | 42.831 | 77.061 |
| hex: canterbury/ptt5 | 524290 | 33969.1 ± 1.4% | 1561.3 ± 9.8% | 1094.6 ± 1.2% | 498.0 ± 0.3% | 785.7 ± 26.8% | 440.5 ± 2.1% | 21.757 | 31.033 | 68.211 | 43.237 | 77.118 |
| hex: canterbury/sum | 76482 | 34888.9 ± 11.9% | 1607.0 ± 5.8% | 1099.8 ± 3.5% | 510.9 ± 5.2% | 809.8 ± 1.5% | 437.3 ± 4.1% | 21.711 | 31.724 | 68.292 | 43.085 | 79.790 |
| hex: canterbury/xargs.1 | 8456 | 34632.1 ± 0.9% | 1631.6 ± 0.9% | 1114.5 ± 0.9% | 543.9 ± 4.5% | 813.4 ± 0.9% | 429.5 ± 2.7% | 21.226 | 31.074 | 63.671 | 42.579 | 80.634 |
| hex: canterbury-large/E.coli | 524290 | 30171.3 ± 2.8% | 1558.2 ± 0.8% | 1090.3 ± 2.2% | 592.0 ± 4.1% | 793.5 ± 0.5% | 437.3 ± 2.6% | 19.362 | 27.673 | 50.965 | 38.025 | 68.990 |
| hex: canterbury-large/bible.txt | 524290 | 35010.0 ± 1.7% | 1558.3 ± 2.1% | 1093.6 ± 0.2% | 442.1 ± 0.2% | 791.9 ± 0.2% | 447.8 ± 2.4% | 22.466 | 32.013 | 79.182 | 44.212 | 78.180 |
| hex: canterbury-large/world192.txt | 524290 | 32959.7 ± 0.5% | 1557.0 ± 0.2% | 1090.1 ± 0.7% | 422.0 ± 1.2% | 794.6 ± 0.4% | 438.7 ± 2.3% | 21.168 | 30.234 | 78.106 | 41.480 | 75.124 |
| hex: http/html-1kx1024 | 2099200 | 23102.0 ± 2.6% | 1611.4 ± 0.9% | 1089.4 ± 0.3% | 451.8 ± 14.0% | 799.5 ± 5.8% | 432.7 ± 3.0% | 14.337 | 21.207 | 51.131 | 28.897 | 53.387 |
| hex: http/html-16kx64 | 2097280 | 29872.5 ± 2.3% | 1607.6 ± 0.4% | 1101.1 ± 0.4% | 447.8 ± 3.3% | 804.1 ± 0.3% | 439.0 ± 3.8% | 18.582 | 27.130 | 66.717 | 37.150 | 68.040 |
| hex: http/html-1m | 524290 | 31488.0 ± 2.1% | 1557.8 ± 0.3% | 1092.2 ± 0.6% | 447.2 ± 0.2% | 784.8 ± 3.3% | 443.3 ± 4.5% | 20.213 | 28.830 | 70.416 | 40.123 | 71.034 |
| hex: http/json-1kx1024 | 2099200 | 22954.3 ± 4.7% | 1610.0 ± 7.4% | 1090.5 ± 0.3% | 566.9 ± 0.3% | 805.5 ± 1.4% | 443.3 ± 2.1% | 14.258 | 21.050 | 40.488 | 28.495 | 51.778 |
| hex: http/json-16kx64 | 2097280 | 29899.2 ± 2.0% | 1606.9 ± 0.5% | 1102.6 ± 0.5% | 574.5 ± 2.7% | 805.8 ± 1.2% | 436.9 ± 4.3% | 18.606 | 27.117 | 52.043 | 37.104 | 68.431 |
| hex: http/json-1m | 524290 | 31034.0 ± 0.7% | 1555.9 ± 0.8% | 1091.1 ± 0.8% | 586.7 ± 0.2% | 780.5 ± 0.3% | 443.3 ± 2.9% | 19.946 | 28.442 | 52.895 | 39.764 | 70.008 |
| hex: http/js-1kx1024 | 2099200 | 23166.0 ± 2.7% | 1609.9 ± 0.1% | 1087.6 ± 2.0% | 443.2 ± 1.3% | 805.7 ± 0.6% | 433.1 ± 2.9% | 14.390 | 21.301 | 52.273 | 28.754 | 53.492 |
| hex: http/js-16kx64 | 2097280 | 29749.2 ± 5.1% | 1607.6 ± 0.2% | 1103.3 ± 0.7% | 433.5 ± 3.3% | 803.8 ± 0.6% | 434.9 ± 2.1% | 18.506 | 26.964 | 68.626 | 37.011 | 68.411 |
| hex: http/js-1m | 524290 | 31050.4 ± 2.1% | 1556.2 ± 0.9% | 1091.8 ± 0.5% | 450.2 ± 1.7% | 776.8 ± 3.0% | 441.0 ± 1.9% | 19.953 | 28.440 | 68.973 | 39.972 | 70.413 |
| hex: http/css-1kx1024 | 2099200 | 22987.9 ± 2.5% | 1612.1 ± 2.8% | 1089.0 ± 2.8% | 496.7 ± 4.8% | 805.3 ± 7.3% | 437.7 ± 3.6% | 14.259 | 21.108 | 46.286 | 28.546 | 52.517 |
| hex: http/css-16kx64 | 2097280 | 29390.3 ± 1.9% | 1610.0 ± 0.4% | 1102.0 ± 1.4% | 502.8 ± 1.7% | 808.2 ± 0.3% | 439.3 ± 2.8% | 18.255 | 26.670 | 58.456 | 36.367 | 66.909 |
| hex: http/css-1m | 524290 | 30941.6 ± 12.8% | 1556.8 ± 1.6% | 1089.9 ± 0.7% | 482.4 ± 0.5% | 778.9 ± 0.4% | 446.0 ± 1.6% | 19.875 | 28.388 | 64.143 | 39.727 | 69.379 |
| hex: shuffled/dickens-1m | 524290 | 32503.3 ± 2.0% | 1558.2 ± 0.7% | 1087.7 ± 0.3% | 425.6 ± 0.2% | 780.1 ± 0.4% | 441.5 ± 7.1% | 20.859 | 29.882 | 76.372 | 41.664 | 73.626 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1352.3 ± 2.2% | 1142.7 ± 1.0% | 865.2 ± 1.1% | 324.9 ± 2.1% | 352.8 ± 12.7% | 311.4 ± 1.0% | 1.183 | 1.563 | 4.162 | 3.833 | 4.343 |
| qlog records, JSON text sequence | 1467503 | 1170.0 ± 1.8% | 877.4 ± 0.4% | 703.8 ± 0.5% | 321.5 ± 2.0% | 396.6 ± 1.8% | 229.8 ± 1.6% | 1.334 | 1.662 | 3.640 | 2.950 | 5.091 |
| messages: 11 string members | 1025025 | 1100.8 ± 6.5% | 894.4 ± 2.1% | 667.2 ± 3.6% | 312.0 ± 1.4% | 319.6 ± 3.7% | 286.1 ± 4.8% | 1.231 | 1.650 | 3.528 | 3.444 | 3.848 |
| messages: 50 nested objects | 1121600 | 1362.8 ± 2.3% | 1194.7 ± 1.5% | 922.0 ± 2.8% | 394.8 ± 1.6% | 425.1 ± 3.1% | 320.3 ± 2.4% | 1.141 | 1.478 | 3.452 | 3.206 | 4.255 |
| messages: a tree of 341 objects | 612600 | 487.0 ± 3.2% | 598.3 ± 5.1% | 376.3 ± 1.9% | 198.3 ± 1.8% | 252.9 ± 6.0% | 124.4 ± 7.8% | 0.814 | 1.294 | 2.455 | 1.925 | 3.913 |
| string: silesia/dickens | 172528 | 9543.4 ± 1.0% | 2950.4 ± 2.4% | 2058.8 ± 2.0% | 354.6 ± 1.3% | 1040.4 ± 1.5% | 561.4 ± 1.2% | 3.235 | 4.636 | 26.912 | 9.173 | 17.001 |
| string: silesia/nci | 1075110 | 8926.8 ± 4.1% | 3165.8 ± 2.7% | 2790.5 ± 2.4% | 774.2 ± 5.6% | 1087.1 ± 2.6% | 565.3 ± 0.9% | 2.820 | 3.199 | 11.530 | 8.212 | 15.791 |
| string: silesia/reymont | 1075159 | 3864.8 ± 0.3% | 1657.5 ± 1.1% | 1748.0 ± 0.5% | 361.8 ± 1.0% | 953.8 ± 1.2% | 553.1 ± 1.0% | 2.332 | 2.211 | 10.682 | 4.052 | 6.988 |
| string: silesia/samba | 97582 | 5181.0 ± 1.8% | 1952.6 ± 1.9% | 2079.9 ± 6.5% | 276.3 ± 3.8% | 882.3 ± 2.7% | 618.2 ± 1.2% | 2.653 | 2.491 | 18.750 | 5.872 | 8.381 |
| string: silesia/webster | 1098490 | 5100.0 ± 1.2% | 1631.2 ± 1.0% | 1540.5 ± 1.4% | 358.4 ± 1.8% | 931.5 ± 1.0% | 456.4 ± 0.8% | 3.127 | 3.311 | 14.228 | 5.475 | 11.173 |
| string: silesia/xml | 1090118 | 8301.9 ± 4.1% | 2665.9 ± 0.2% | 2161.9 ± 0.5% | 522.4 ± 1.0% | 1121.8 ± 0.6% | 563.5 ± 0.7% | 3.114 | 3.840 | 15.893 | 7.401 | 14.733 |
| string: canterbury/alice29.txt | 159425 | 10222.6 ± 0.5% | 2434.7 ± 1.4% | 1810.2 ± 18.7% | 339.0 ± 3.3% | 1018.2 ± 1.3% | 560.3 ± 0.5% | 4.199 | 5.647 | 30.158 | 10.040 | 18.244 |
| string: canterbury/asyoulik.txt | 132198 | 8356.3 ± 0.3% | 2193.9 ± 1.4% | 1543.8 ± 2.2% | 341.4 ± 0.8% | 896.8 ± 1.3% | 546.5 ± 0.7% | 3.809 | 5.413 | 24.474 | 9.318 | 15.291 |
| string: canterbury/lcet10.txt | 441884 | 9177.5 ± 2.8% | 2449.3 ± 2.3% | 1971.7 ± 1.9% | 385.2 ± 3.2% | 1024.9 ± 4.2% | 559.4 ± 4.5% | 3.747 | 4.655 | 23.824 | 8.955 | 16.406 |
| string: canterbury/plrabn12.txt | 503330 | 6371.0 ± 0.6% | 1842.5 ± 1.2% | 1686.4 ± 0.8% | 361.6 ± 3.9% | 994.4 ± 1.3% | 564.8 ± 1.6% | 3.458 | 3.778 | 17.617 | 6.407 | 11.281 |
| string: canterbury-large/E.coli | 1048578 | 38825.9 ± 0.7% | 11633.6 ± 0.5% | 3393.2 ± 0.2% | 1422.3 ± 0.3% | 1399.2 ± 20.3% | 576.9 ± 0.9% | 3.337 | 11.442 | 27.297 | 27.749 | 67.297 |
| string: canterbury-large/bible.txt | 1055886 | 7414.5 ± 1.0% | 3969.4 ± 0.7% | 2675.3 ± 0.5% | 437.2 ± 3.4% | 1195.3 ± 1.3% | 574.3 ± 0.8% | 1.868 | 2.771 | 16.957 | 6.203 | 12.911 |
| string: canterbury-large/world192.txt | 1103121 | 4804.6 ± 0.8% | 1441.9 ± 3.3% | 1582.9 ± 18.2% | 353.4 ± 2.1% | 925.0 ± 0.7% | 542.6 ± 1.3% | 3.332 | 3.035 | 13.595 | 5.194 | 8.855 |
| string: http/html-1m | 1058582 | 8682.2 ± 1.2% | 3855.2 ± 0.8% | 2494.6 ± 0.3% | 425.4 ± 1.1% | 1184.9 ± 8.7% | 525.3 ± 0.7% | 2.252 | 3.480 | 20.408 | 7.327 | 16.528 |
| string: http/json-1m | 1190272 | 6823.9 ± 0.2% | 1229.3 ± 1.0% | 1289.2 ± 1.6% | 414.5 ± 1.8% | 777.0 ± 1.2% | 508.8 ± 1.0% | 5.551 | 5.293 | 16.461 | 8.783 | 13.413 |
| string: http/js-1m | 1144362 | 5104.1 ± 1.7% | 992.2 ± 2.6% | 1110.5 ± 1.9% | 295.1 ± 3.3% | 782.1 ± 2.5% | 475.3 ± 1.8% | 5.144 | 4.596 | 17.295 | 6.526 | 10.738 |
| string: http/css-1m | 1097820 | 7329.3 ± 2.1% | 1288.1 ± 1.4% | 1617.1 ± 0.3% | 427.0 ± 3.9% | 856.3 ± 1.4% | 533.0 ± 0.9% | 5.690 | 4.532 | 17.165 | 8.559 | 13.752 |
| string: dickens as Cyrillic and CJK | 1883069 | 5223.4 ± 0.5% | 3016.1 ± 0.2% | 334.9 ± 7.6% | 272.9 ± 5.0% | 409.3 ± 1.9% | 293.8 ± 0.3% | 1.732 | 15.599 | 19.142 | 12.763 | 17.779 |
| hex: silesia/dickens | 524290 | 31244.9 ± 0.3% | 1558.6 ± 1.9% | 1093.7 ± 0.7% | 426.0 ± 1.6% | 787.9 ± 0.6% | 444.8 ± 2.2% | 20.047 | 28.568 | 73.349 | 39.654 | 70.248 |
| hex: silesia/mozilla | 524290 | 35293.1 ± 0.8% | 1567.1 ± 0.8% | 1093.1 ± 1.6% | 370.8 ± 1.8% | 788.3 ± 0.3% | 438.4 ± 3.9% | 22.521 | 32.287 | 95.177 | 44.770 | 80.509 |
| hex: silesia/mr | 524290 | 35084.2 ± 1.5% | 1565.3 ± 0.6% | 1094.1 ± 0.7% | 507.3 ± 2.7% | 791.2 ± 0.3% | 440.0 ± 6.2% | 22.414 | 32.066 | 69.158 | 44.345 | 79.736 |
| hex: silesia/nci | 524290 | 35416.0 ± 1.0% | 1567.6 ± 1.4% | 1092.9 ± 0.9% | 569.8 ± 2.2% | 787.6 ± 1.6% | 436.4 ± 1.2% | 22.592 | 32.406 | 62.151 | 44.965 | 81.146 |
| hex: silesia/ooffice | 524290 | 33920.4 ± 1.6% | 1565.3 ± 0.7% | 1093.6 ± 0.4% | 324.0 ± 1.2% | 791.1 ± 1.7% | 431.8 ± 7.7% | 21.670 | 31.017 | 104.707 | 42.879 | 78.564 |
| hex: silesia/osdb | 524290 | 32346.2 ± 1.9% | 1558.4 ± 2.1% | 1090.4 ± 2.1% | 412.1 ± 3.1% | 786.9 ± 3.1% | 431.8 ± 3.0% | 20.756 | 29.665 | 78.495 | 41.107 | 74.915 |
| hex: silesia/reymont | 524290 | 34083.0 ± 0.6% | 1570.5 ± 1.4% | 1094.2 ± 0.4% | 443.5 ± 1.6% | 793.0 ± 0.3% | 441.4 ± 7.4% | 21.702 | 31.148 | 76.853 | 42.981 | 77.217 |
| hex: silesia/samba | 524290 | 35934.3 ± 2.0% | 1569.0 ± 1.5% | 1092.4 ± 2.1% | 323.4 ± 2.7% | 785.5 ± 3.4% | 422.6 ± 3.3% | 22.903 | 32.896 | 111.100 | 45.745 | 85.037 |
| hex: silesia/sao | 524290 | 34177.2 ± 0.8% | 1564.9 ± 1.2% | 1093.0 ± 0.6% | 263.4 ± 2.6% | 780.1 ± 3.0% | 426.8 ± 3.1% | 21.840 | 31.270 | 129.756 | 43.813 | 80.076 |
| hex: silesia/webster | 524290 | 36040.4 ± 0.8% | 1560.6 ± 1.7% | 1090.8 ± 0.8% | 393.7 ± 2.8% | 787.9 ± 0.4% | 434.4 ± 2.8% | 23.094 | 33.039 | 91.548 | 45.742 | 82.959 |
| hex: silesia/x-ray | 524290 | 34534.8 ± 0.4% | 1565.4 ± 0.8% | 1089.9 ± 0.8% | 397.6 ± 0.7% | 790.4 ± 0.4% | 438.2 ± 4.4% | 22.061 | 31.686 | 86.864 | 43.693 | 78.814 |
| hex: silesia/xml | 524290 | 35212.3 ± 0.4% | 1569.6 ± 1.2% | 1094.0 ± 2.7% | 581.5 ± 0.2% | 790.2 ± 0.8% | 441.5 ± 2.9% | 22.433 | 32.186 | 60.558 | 44.559 | 79.758 |
| hex: canterbury/alice29.txt | 304180 | 33467.1 ± 0.4% | 1583.9 ± 0.4% | 1096.5 ± 0.3% | 429.7 ± 17.8% | 804.3 ± 0.8% | 443.8 ± 4.0% | 21.129 | 30.521 | 77.890 | 41.611 | 75.416 |
| hex: canterbury/asyoulik.txt | 250360 | 31200.1 ± 0.4% | 1580.9 ± 2.4% | 1100.2 ± 2.4% | 405.0 ± 3.3% | 803.9 ± 3.8% | 432.8 ± 3.5% | 19.735 | 28.358 | 77.029 | 38.811 | 72.087 |
| hex: canterbury/cp.html | 49208 | 31719.5 ± 0.9% | 1604.4 ± 1.2% | 1101.6 ± 0.5% | 436.3 ± 3.0% | 804.5 ± 1.3% | 438.2 ± 3.8% | 19.770 | 28.793 | 72.702 | 39.430 | 72.379 |
| hex: canterbury/fields.c | 22302 | 32783.1 ± 13.2% | 1588.6 ± 7.6% | 1092.6 ± 0.6% | 522.6 ± 5.0% | 804.5 ± 2.0% | 429.9 ± 2.2% | 20.636 | 30.005 | 62.736 | 40.749 | 76.258 |
| hex: canterbury/grammar.lsp | 7444 | 32555.0 ± 1.1% | 1644.2 ± 0.4% | 1120.3 ± 0.4% | 537.7 ± 3.0% | 810.3 ± 12.5% | 431.0 ± 3.6% | 19.800 | 29.060 | 60.541 | 40.177 | 75.540 |
| hex: canterbury/kennedy.xls | 524290 | 31353.0 ± 0.9% | 1556.4 ± 6.2% | 1090.9 ± 0.6% | 577.2 ± 4.0% | 782.6 ± 0.4% | 438.5 ± 2.6% | 20.145 | 28.741 | 54.316 | 40.065 | 71.504 |
| hex: canterbury/lcet10.txt | 524290 | 36174.6 ± 0.5% | 1570.9 ± 0.7% | 1093.9 ± 3.1% | 427.2 ± 2.3% | 786.0 ± 1.2% | 440.3 ± 1.9% | 23.028 | 33.070 | 84.669 | 46.026 | 82.161 |
| hex: canterbury/plrabn12.txt | 524290 | 34558.4 ± 0.8% | 1558.7 ± 8.6% | 1091.2 ± 0.3% | 411.2 ± 4.8% | 783.4 ± 2.4% | 435.4 ± 3.6% | 22.171 | 31.671 | 84.048 | 44.113 | 79.367 |
| hex: canterbury/ptt5 | 524290 | 34732.5 ± 0.2% | 1561.3 ± 9.8% | 1094.6 ± 1.2% | 498.0 ± 0.3% | 785.7 ± 26.8% | 440.5 ± 2.1% | 22.246 | 31.731 | 69.744 | 44.209 | 78.851 |
| hex: canterbury/sum | 76482 | 35281.9 ± 2.0% | 1607.0 ± 5.8% | 1099.8 ± 3.5% | 510.9 ± 5.2% | 809.8 ± 1.5% | 437.3 ± 4.1% | 21.956 | 32.082 | 69.062 | 43.571 | 80.689 |
| hex: canterbury/xargs.1 | 8456 | 34971.4 ± 0.2% | 1631.6 ± 0.9% | 1114.5 ± 0.9% | 543.9 ± 4.5% | 813.4 ± 0.9% | 429.5 ± 2.7% | 21.434 | 31.378 | 64.295 | 42.996 | 81.425 |
| hex: canterbury-large/E.coli | 524290 | 30445.3 ± 0.8% | 1558.2 ± 0.8% | 1090.3 ± 2.2% | 592.0 ± 4.1% | 793.5 ± 0.5% | 437.3 ± 2.6% | 19.538 | 27.924 | 51.428 | 38.370 | 69.617 |
| hex: canterbury-large/bible.txt | 524290 | 35325.1 ± 12.6% | 1558.3 ± 2.1% | 1093.6 ± 0.2% | 442.1 ± 0.2% | 791.9 ± 0.2% | 447.8 ± 2.4% | 22.668 | 32.301 | 79.895 | 44.610 | 78.883 |
| hex: canterbury-large/world192.txt | 524290 | 33026.1 ± 0.5% | 1557.0 ± 0.2% | 1090.1 ± 0.7% | 422.0 ± 1.2% | 794.6 ± 0.4% | 438.7 ± 2.3% | 21.211 | 30.295 | 78.263 | 41.564 | 75.275 |
| hex: http/html-1kx1024 | 2099200 | 23931.4 ± 1.1% | 1611.4 ± 0.9% | 1089.4 ± 0.3% | 451.8 ± 14.0% | 799.5 ± 5.8% | 432.7 ± 3.0% | 14.851 | 21.968 | 52.967 | 29.934 | 55.303 |
| hex: http/html-16kx64 | 2097280 | 29985.2 ± 0.6% | 1607.6 ± 0.4% | 1101.1 ± 0.4% | 447.8 ± 3.3% | 804.1 ± 0.3% | 439.0 ± 3.8% | 18.652 | 27.233 | 66.968 | 37.290 | 68.297 |
| hex: http/html-1m | 524290 | 31845.6 ± 2.1% | 1557.8 ± 0.3% | 1092.2 ± 0.6% | 447.2 ± 0.2% | 784.8 ± 3.3% | 443.3 ± 4.5% | 20.443 | 29.158 | 71.216 | 40.579 | 71.841 |
| hex: http/json-1kx1024 | 2099200 | 23865.0 ± 0.9% | 1610.0 ± 7.4% | 1090.5 ± 0.3% | 566.9 ± 0.3% | 805.5 ± 1.4% | 443.3 ± 2.1% | 14.823 | 21.885 | 42.094 | 29.626 | 53.833 |
| hex: http/json-16kx64 | 2097280 | 30323.8 ± 1.6% | 1606.9 ± 0.5% | 1102.6 ± 0.5% | 574.5 ± 2.7% | 805.8 ± 1.2% | 436.9 ± 4.3% | 18.871 | 27.502 | 52.782 | 37.631 | 69.403 |
| hex: http/json-1m | 524290 | 31121.9 ± 3.5% | 1555.9 ± 0.8% | 1091.1 ± 0.8% | 586.7 ± 0.2% | 780.5 ± 0.3% | 443.3 ± 2.9% | 20.003 | 28.522 | 53.045 | 39.876 | 70.206 |
| hex: http/js-1kx1024 | 2099200 | 23829.9 ± 1.1% | 1609.9 ± 0.1% | 1087.6 ± 2.0% | 443.2 ± 1.3% | 805.7 ± 0.6% | 433.1 ± 2.9% | 14.802 | 21.911 | 53.771 | 29.578 | 55.025 |
| hex: http/js-16kx64 | 2097280 | 29876.7 ± 0.8% | 1607.6 ± 0.2% | 1103.3 ± 0.7% | 433.5 ± 3.3% | 803.8 ± 0.6% | 434.9 ± 2.1% | 18.585 | 27.079 | 68.920 | 37.169 | 68.704 |
| hex: http/js-1m | 524290 | 31478.7 ± 2.5% | 1556.2 ± 0.9% | 1091.8 ± 0.5% | 450.2 ± 1.7% | 776.8 ± 3.0% | 441.0 ± 1.9% | 20.228 | 28.832 | 69.924 | 40.523 | 71.385 |
| hex: http/css-1kx1024 | 2099200 | 23765.2 ± 2.2% | 1612.1 ± 2.8% | 1089.0 ± 2.8% | 496.7 ± 4.8% | 805.3 ± 7.3% | 437.7 ± 3.6% | 14.741 | 21.822 | 47.851 | 29.512 | 54.292 |
| hex: http/css-16kx64 | 2097280 | 30002.6 ± 0.4% | 1610.0 ± 0.4% | 1102.0 ± 1.4% | 502.8 ± 1.7% | 808.2 ± 0.3% | 439.3 ± 2.8% | 18.636 | 27.226 | 59.674 | 37.124 | 68.303 |
| hex: http/css-1m | 524290 | 31237.7 ± 1.0% | 1556.8 ± 1.6% | 1089.9 ± 0.7% | 482.4 ± 0.5% | 778.9 ± 0.4% | 446.0 ± 1.6% | 20.065 | 28.660 | 64.757 | 40.107 | 70.043 |
| hex: shuffled/dickens-1m | 524290 | 33256.8 ± 0.4% | 1558.2 ± 0.7% | 1087.7 ± 0.3% | 425.6 ± 0.2% | 780.1 ± 0.4% | 441.5 ± 7.1% | 21.342 | 30.575 | 78.143 | 42.630 | 75.333 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 837.0 ± 0.8% | 1004.7 ± 0.5% | 915.3 ± 3.9% | 261.8 ± 0.6% | 531.8 ± 9.3% | 255.4 ± 3.1% | 0.833 | 0.914 | 3.197 | 1.574 | 3.277 |
| qlog records, JSON text sequence | 1467503 | 768.2 ± 2.6% | 801.7 ± 2.3% | 805.8 ± 6.9% | 230.3 ± 2.3% | 592.6 ± 3.0% | 245.6 ± 3.3% | 0.958 | 0.953 | 3.336 | 1.296 | 3.127 |
| messages: 11 string members | 1025025 | 789.7 ± 0.8% | 1102.2 ± 1.2% | 675.6 ± 1.6% | 259.9 ± 3.2% | 456.7 ± 4.8% | 245.9 ± 12.2% | 0.716 | 1.169 | 3.038 | 1.729 | 3.212 |
| messages: 50 nested objects | 1121600 | 925.5 ± 0.7% | 999.5 ± 1.7% | 1043.1 ± 5.3% | 280.9 ± 0.8% | 692.6 ± 0.5% | 322.7 ± 7.5% | 0.926 | 0.887 | 3.295 | 1.336 | 2.868 |
| messages: a tree of 341 objects | 612600 | 310.8 ± 5.5% | 433.2 ± 2.0% | 429.3 ± 9.3% | 123.7 ± 1.9% | 447.2 ± 4.2% | 145.3 ± 5.0% | 0.717 | 0.724 | 2.511 | 0.695 | 2.139 |
| string: silesia/dickens | 172528 | 6215.3 ± 0.6% | 2889.7 ± 0.1% | 2064.4 ± 2.8% | 285.1 ± 4.6% | 2163.5 ± 7.0% | 473.8 ± 2.8% | 2.151 | 3.011 | 21.798 | 2.873 | 13.118 |
| string: silesia/nci | 1075110 | 5117.6 ± 0.3% | 3467.9 ± 0.5% | 2855.2 ± 5.1% | 453.7 ± 1.4% | 2346.3 ± 0.7% | 515.0 ± 1.7% | 1.476 | 1.792 | 11.280 | 2.181 | 9.938 |
| string: silesia/reymont | 1075159 | 3297.1 ± 0.5% | 2193.7 ± 2.6% | 1782.9 ± 6.0% | 292.7 ± 3.5% | 1618.5 ± 0.5% | 470.8 ± 3.4% | 1.503 | 1.849 | 11.264 | 2.037 | 7.003 |
| string: silesia/samba | 97582 | 3341.9 ± 0.6% | 2741.9 ± 1.7% | 1609.7 ± 3.9% | 253.1 ± 4.3% | 1278.4 ± 0.5% | 347.2 ± 46.4% | 1.219 | 2.076 | 13.204 | 2.614 | 9.625 |
| string: silesia/webster | 1098490 | 4094.4 ± 0.4% | 2031.0 ± 0.3% | 1668.2 ± 0.9% | 286.1 ± 1.3% | 1668.3 ± 0.8% | 425.3 ± 4.8% | 2.016 | 2.454 | 14.311 | 2.454 | 9.628 |
| string: silesia/xml | 1090118 | 5516.2 ± 0.5% | 3714.3 ± 0.5% | 2177.3 ± 1.1% | 374.7 ± 1.1% | 2361.9 ± 2.6% | 507.5 ± 3.0% | 1.485 | 2.534 | 14.720 | 2.335 | 10.870 |
| string: canterbury/alice29.txt | 159425 | 4892.7 ± 0.8% | 2400.2 ± 0.5% | 1840.1 ± 2.1% | 269.4 ± 2.0% | 1942.5 ± 0.5% | 422.1 ± 6.8% | 2.038 | 2.659 | 18.160 | 2.519 | 11.592 |
| string: canterbury/asyoulik.txt | 132198 | 3762.8 ± 5.0% | 2111.7 ± 0.1% | 1477.7 ± 3.5% | 256.9 ± 7.5% | 1590.3 ± 1.4% | 399.2 ± 3.1% | 1.782 | 2.546 | 14.648 | 2.366 | 9.425 |
| string: canterbury/lcet10.txt | 441884 | 6087.4 ± 1.1% | 2790.6 ± 0.4% | 2006.4 ± 1.4% | 304.6 ± 2.1% | 2143.6 ± 0.9% | 473.6 ± 3.4% | 2.181 | 3.034 | 19.984 | 2.840 | 12.855 |
| string: canterbury/plrabn12.txt | 503330 | 4735.5 ± 0.2% | 2699.7 ± 0.2% | 1716.3 ± 11.6% | 277.8 ± 2.1% | 2005.5 ± 0.5% | 453.6 ± 2.5% | 1.754 | 2.759 | 17.046 | 2.361 | 10.440 |
| string: canterbury-large/E.coli | 1048578 | 33497.8 ± 0.5% | 7728.0 ± 0.7% | 3527.2 ± 0.6% | 868.3 ± 1.9% | 5514.9 ± 0.6% | 816.3 ± 2.3% | 4.335 | 9.497 | 38.577 | 6.074 | 41.036 |
| string: canterbury-large/bible.txt | 1055886 | 9586.4 ± 2.9% | 3909.3 ± 1.0% | 2619.9 ± 0.7% | 326.2 ± 3.8% | 2961.3 ± 11.5% | 604.7 ± 2.6% | 2.452 | 3.659 | 29.390 | 3.237 | 15.854 |
| string: canterbury-large/world192.txt | 1103121 | 3786.7 ± 1.6% | 1977.2 ± 0.4% | 1692.9 ± 0.2% | 281.8 ± 1.4% | 1687.4 ± 1.2% | 424.7 ± 3.3% | 1.915 | 2.237 | 13.439 | 2.244 | 8.915 |
| string: http/html-1m | 1058582 | 8007.0 ± 1.0% | 3400.3 ± 2.7% | 2422.9 ± 2.1% | 373.9 ± 1.4% | 2722.1 ± 1.0% | 424.3 ± 1.6% | 2.355 | 3.305 | 21.417 | 2.941 | 18.872 |
| string: http/json-1m | 1190272 | 3310.8 ± 1.7% | 1201.6 ± 0.2% | 1543.3 ± 10.5% | 340.1 ± 5.0% | 824.7 ± 1.0% | 300.8 ± 0.8% | 2.755 | 2.145 | 9.734 | 4.014 | 11.006 |
| string: http/js-1m | 1144362 | 2660.0 ± 0.6% | 1326.0 ± 0.3% | 1203.4 ± 1.8% | 262.3 ± 1.3% | 1152.4 ± 3.1% | 293.6 ± 24.3% | 2.006 | 2.210 | 10.140 | 2.308 | 9.060 |
| string: http/css-1m | 1097820 | 3038.4 ± 0.1% | 2510.9 ± 0.3% | 1571.4 ± 1.4% | 342.4 ± 2.4% | 1523.6 ± 1.3% | 328.8 ± 2.8% | 1.210 | 1.934 | 8.875 | 1.994 | 9.241 |
| string: dickens as Cyrillic and CJK | 1883069 | 5365.9 ± 0.8% | 3164.2 ± 0.8% | 678.8 ± 1.0% | 269.7 ± 6.0% | 488.4 ± 4.3% | 138.1 ± 1.9% | 1.696 | 7.905 | 19.896 | 10.988 | 38.867 |
| string: dickens as Cyrillic and CJK, as \u escapes | 5075485 | 1062.3 ± 3.1% | 1073.8 ± 8.4% | 844.8 ± 15.1% | 159.4 ± 2.0% | 380.6 ± 3.0% | 189.2 ± 13.9% | 0.989 | 1.258 | 6.667 | 2.791 | 5.614 |
| hex: silesia/dickens | 524290 | 33572.9 ± 0.4% | 7726.1 ± 0.9% | 3551.0 ± 1.6% | 431.5 ± 4.8% | 5499.1 ± 1.7% | 777.7 ± 3.8% | 4.345 | 9.455 | 77.812 | 6.105 | 43.170 |
| hex: silesia/mozilla | 524290 | 33451.5 ± 0.5% | 7750.7 ± 0.3% | 3540.8 ± 0.9% | 381.4 ± 2.9% | 5510.4 ± 0.8% | 791.5 ± 1.7% | 4.316 | 9.448 | 87.702 | 6.071 | 42.262 |
| hex: silesia/mr | 524290 | 33607.2 ± 1.1% | 7721.6 ± 0.5% | 3558.6 ± 0.7% | 553.4 ± 2.2% | 5510.0 ± 1.5% | 782.5 ± 0.2% | 4.352 | 9.444 | 60.729 | 6.099 | 42.950 |
| hex: silesia/nci | 524290 | 33306.6 ± 6.5% | 7763.2 ± 0.4% | 3548.9 ± 0.5% | 616.0 ± 2.9% | 5476.4 ± 7.7% | 785.6 ± 10.7% | 4.290 | 9.385 | 54.066 | 6.082 | 42.396 |
| hex: silesia/ooffice | 524290 | 33460.5 ± 1.1% | 7739.7 ± 2.4% | 3535.9 ± 0.4% | 330.6 ± 1.9% | 5487.0 ± 0.7% | 775.4 ± 3.5% | 4.323 | 9.463 | 101.201 | 6.098 | 43.151 |
| hex: silesia/osdb | 524290 | 33700.5 ± 0.7% | 7751.3 ± 0.8% | 3530.6 ± 0.6% | 424.4 ± 3.2% | 5476.7 ± 16.7% | 786.9 ± 3.7% | 4.348 | 9.545 | 79.415 | 6.153 | 42.828 |
| hex: silesia/reymont | 524290 | 33512.0 ± 8.4% | 7756.5 ± 0.8% | 3557.4 ± 0.9% | 466.6 ± 0.4% | 5523.3 ± 0.6% | 794.5 ± 4.5% | 4.320 | 9.420 | 71.828 | 6.067 | 42.180 |
| hex: silesia/samba | 524290 | 33525.9 ± 2.9% | 7731.9 ± 3.3% | 3525.2 ± 2.1% | 334.1 ± 1.7% | 5489.9 ± 3.4% | 801.3 ± 3.6% | 4.336 | 9.510 | 100.347 | 6.107 | 41.842 |
| hex: silesia/sao | 524290 | 33542.0 ± 2.3% | 7712.8 ± 1.1% | 3529.3 ± 5.6% | 272.5 ± 1.2% | 5477.0 ± 3.4% | 813.7 ± 3.4% | 4.349 | 9.504 | 123.075 | 6.124 | 41.222 |
| hex: silesia/webster | 524290 | 33507.3 ± 13.7% | 7766.3 ± 0.4% | 3538.3 ± 1.0% | 399.6 ± 2.5% | 5517.6 ± 2.0% | 809.0 ± 2.3% | 4.314 | 9.470 | 83.857 | 6.073 | 41.420 |
| hex: silesia/x-ray | 524290 | 33559.7 ± 1.6% | 7739.9 ± 0.8% | 3527.3 ± 0.8% | 404.4 ± 1.5% | 5506.9 ± 0.7% | 808.8 ± 3.6% | 4.336 | 9.514 | 82.983 | 6.094 | 41.494 |
| hex: silesia/xml | 524290 | 33574.4 ± 0.4% | 7697.9 ± 4.2% | 3526.7 ± 0.8% | 565.3 ± 2.4% | 5496.8 ± 0.5% | 816.4 ± 3.7% | 4.362 | 9.520 | 59.395 | 6.108 | 41.123 |
| hex: canterbury/alice29.txt | 304180 | 33925.7 ± 5.8% | 7734.9 ± 0.8% | 3582.0 ± 0.7% | 427.2 ± 1.2% | 5492.3 ± 3.3% | 811.6 ± 4.4% | 4.386 | 9.471 | 79.414 | 6.177 | 41.803 |
| hex: canterbury/asyoulik.txt | 250360 | 33683.0 ± 0.3% | 7778.8 ± 0.6% | 3541.8 ± 1.1% | 419.3 ± 2.0% | 5463.7 ± 1.1% | 805.4 ± 3.6% | 4.330 | 9.510 | 80.335 | 6.165 | 41.821 |
| hex: canterbury/cp.html | 49208 | 32782.3 ± 0.3% | 7765.6 ± 0.8% | 3521.1 ± 1.8% | 406.9 ± 3.2% | 5428.3 ± 0.7% | 799.3 ± 2.6% | 4.221 | 9.310 | 80.561 | 6.039 | 41.012 |
| hex: canterbury/fields.c | 22302 | 31594.1 ± 2.3% | 7697.7 ± 1.8% | 3552.0 ± 1.8% | 425.2 ± 2.3% | 5455.5 ± 3.0% | 763.7 ± 4.7% | 4.104 | 8.895 | 74.305 | 5.791 | 41.371 |
| hex: canterbury/grammar.lsp | 7444 | 27478.7 ± 0.3% | 7492.3 ± 0.6% | 3614.4 ± 0.5% | 477.0 ± 5.0% | 5311.0 ± 1.1% | 754.1 ± 3.7% | 3.668 | 7.603 | 57.606 | 5.174 | 36.441 |
| hex: canterbury/kennedy.xls | 524290 | 33601.5 ± 0.4% | 7727.7 ± 1.5% | 3499.4 ± 4.9% | 619.0 ± 5.7% | 5492.5 ± 0.4% | 793.7 ± 6.7% | 4.348 | 9.602 | 54.287 | 6.118 | 42.338 |
| hex: canterbury/lcet10.txt | 524290 | 33670.8 ± 0.9% | 7781.9 ± 0.3% | 3521.0 ± 2.5% | 429.2 ± 3.1% | 5510.2 ± 0.8% | 808.4 ± 3.3% | 4.327 | 9.563 | 78.451 | 6.111 | 41.651 |
| hex: canterbury/plrabn12.txt | 524290 | 33229.4 ± 0.8% | 7744.1 ± 0.6% | 3523.0 ± 2.1% | 414.9 ± 2.8% | 5508.9 ± 0.8% | 781.8 ± 2.3% | 4.291 | 9.432 | 80.088 | 6.032 | 42.503 |
| hex: canterbury/ptt5 | 524290 | 33223.4 ± 0.4% | 7766.4 ± 0.7% | 3521.5 ± 0.6% | 526.2 ± 5.9% | 5483.3 ± 0.8% | 792.2 ± 2.9% | 4.278 | 9.434 | 63.136 | 6.059 | 41.939 |
| hex: canterbury/sum | 76482 | 33248.8 ± 0.4% | 7795.6 ± 0.9% | 3557.9 ± 1.0% | 466.1 ± 1.5% | 5475.9 ± 16.5% | 793.9 ± 5.1% | 4.265 | 9.345 | 71.331 | 6.072 | 41.878 |
| hex: canterbury/xargs.1 | 8456 | 28105.2 ± 0.2% | 7536.1 ± 0.1% | 3596.9 ± 1.2% | 454.0 ± 2.8% | 5300.8 ± 1.4% | 778.8 ± 3.2% | 3.729 | 7.814 | 61.909 | 5.302 | 36.086 |
| hex: canterbury-large/E.coli | 524290 | 33499.1 ± 0.9% | 7733.1 ± 0.8% | 3540.8 ± 2.9% | 711.9 ± 3.1% | 5485.3 ± 3.1% | 787.5 ± 8.9% | 4.332 | 9.461 | 47.053 | 6.107 | 42.541 |
| hex: canterbury-large/bible.txt | 524290 | 33582.6 ± 0.5% | 7750.8 ± 5.1% | 3518.0 ± 0.3% | 450.7 ± 2.5% | 5506.1 ± 0.4% | 796.7 ± 2.6% | 4.333 | 9.546 | 74.519 | 6.099 | 42.154 |
| hex: canterbury-large/world192.txt | 524290 | 33267.0 ± 0.4% | 7682.3 ± 2.3% | 3523.0 ± 8.3% | 413.8 ± 5.8% | 5512.4 ± 0.6% | 788.3 ± 5.1% | 4.330 | 9.443 | 80.385 | 6.035 | 42.201 |
| hex: http/html-1kx1024 | 2099200 | 16793.6 ± 1.8% | 6653.5 ± 0.1% | 3199.7 ± 3.4% | 439.7 ± 1.5% | 4731.8 ± 0.7% | 696.2 ± 1.5% | 2.524 | 5.248 | 38.191 | 3.549 | 24.121 |
| hex: http/html-16kx64 | 2097280 | 30309.8 ± 0.7% | 7660.3 ± 0.3% | 3523.1 ± 0.6% | 448.5 ± 3.1% | 5419.6 ± 24.4% | 773.9 ± 5.8% | 3.957 | 8.603 | 67.579 | 5.593 | 39.166 |
| hex: http/html-1m | 524290 | 33337.8 ± 2.0% | 7770.0 ± 0.5% | 3540.6 ± 0.8% | 450.4 ± 0.7% | 5503.4 ± 0.2% | 782.4 ± 3.9% | 4.291 | 9.416 | 74.021 | 6.058 | 42.610 |
| hex: http/json-1kx1024 | 2099200 | 16809.7 ± 1.3% | 6648.7 ± 0.1% | 3226.3 ± 2.2% | 572.1 ± 4.8% | 4739.6 ± 0.7% | 700.5 ± 4.3% | 2.528 | 5.210 | 29.383 | 3.547 | 23.996 |
| hex: http/json-16kx64 | 2097280 | 30490.1 ± 1.8% | 7671.1 ± 2.0% | 3529.2 ± 0.5% | 582.6 ± 0.9% | 5425.4 ± 0.6% | 758.6 ± 8.2% | 3.975 | 8.639 | 52.333 | 5.620 | 40.192 |
| hex: http/json-1m | 524290 | 33678.7 ± 0.8% | 7756.8 ± 0.4% | 3517.1 ± 1.8% | 593.2 ± 4.0% | 5497.6 ± 3.0% | 795.0 ± 5.9% | 4.342 | 9.576 | 56.772 | 6.126 | 42.363 |
| hex: http/js-1kx1024 | 2099200 | 16900.4 ± 1.6% | 6659.9 ± 0.4% | 3231.1 ± 2.5% | 430.9 ± 2.5% | 4732.1 ± 1.3% | 702.5 ± 2.5% | 2.538 | 5.231 | 39.219 | 3.571 | 24.058 |
| hex: http/js-16kx64 | 2097280 | 30366.8 ± 0.6% | 7678.7 ± 0.2% | 3523.4 ± 0.6% | 436.8 ± 5.3% | 5422.0 ± 0.4% | 775.1 ± 4.0% | 3.955 | 8.619 | 69.518 | 5.601 | 39.177 |
| hex: http/js-1m | 524290 | 33286.5 ± 1.1% | 7772.9 ± 0.7% | 3525.9 ± 9.2% | 460.7 ± 2.9% | 5532.4 ± 0.8% | 797.5 ± 5.0% | 4.282 | 9.441 | 72.249 | 6.017 | 41.738 |
| hex: http/css-1kx1024 | 2099200 | 16850.6 ± 2.7% | 6653.5 ± 1.0% | 3224.5 ± 1.5% | 492.4 ± 1.9% | 4730.0 ± 0.2% | 699.2 ± 2.9% | 2.533 | 5.226 | 34.220 | 3.562 | 24.101 |
| hex: http/css-16kx64 | 2097280 | 30647.4 ± 1.8% | 7676.1 ± 0.5% | 3533.3 ± 1.3% | 508.4 ± 2.8% | 5433.6 ± 0.2% | 791.3 ± 4.5% | 3.993 | 8.674 | 60.282 | 5.640 | 38.730 |
| hex: http/css-1m | 524290 | 33594.8 ± 0.4% | 7735.1 ± 0.4% | 3518.4 ± 1.0% | 496.4 ± 1.8% | 5498.4 ± 0.3% | 794.7 ± 3.1% | 4.343 | 9.548 | 67.672 | 6.110 | 42.272 |
| hex: shuffled/dickens-1m | 524290 | 33703.1 ± 2.3% | 7727.0 ± 8.8% | 3508.6 ± 4.0% | 437.8 ± 2.3% | 5515.2 ± 5.5% | 785.9 ± 3.5% | 4.362 | 9.606 | 76.985 | 6.111 | 42.883 |

## TextReader.next_items against the baselines

stdx's decoder a slice of tokens a call through `TextReader.next_items`, as a caller that reads a text's values in a loop calls it (decision 79). Octets are the text's. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 952.1 ± 4.7% | 1004.7 ± 0.5% | 915.3 ± 3.9% | 261.8 ± 0.6% | 531.8 ± 9.3% | 255.4 ± 3.1% | 0.948 | 1.040 | 3.637 | 1.790 | 3.727 |
| qlog records, JSON text sequence | 1467503 | 825.8 ± 2.1% | 801.7 ± 2.3% | 805.8 ± 6.9% | 230.3 ± 2.3% | 592.6 ± 3.0% | 245.6 ± 3.3% | 1.030 | 1.025 | 3.586 | 1.393 | 3.362 |
| messages: 11 string members | 1025025 | 917.0 ± 0.5% | 1102.2 ± 1.2% | 675.6 ± 1.6% | 259.9 ± 3.2% | 456.7 ± 4.8% | 245.9 ± 12.2% | 0.832 | 1.357 | 3.528 | 2.008 | 3.729 |
| messages: 50 nested objects | 1121600 | 1065.5 ± 0.9% | 999.5 ± 1.7% | 1043.1 ± 5.3% | 280.9 ± 0.8% | 692.6 ± 0.5% | 322.7 ± 7.5% | 1.066 | 1.021 | 3.794 | 1.538 | 3.301 |
| messages: a tree of 341 objects | 612600 | 397.4 ± 22.7% | 433.2 ± 2.0% | 429.3 ± 9.3% | 123.7 ± 1.9% | 447.2 ± 4.2% | 145.3 ± 5.0% | 0.917 | 0.926 | 3.211 | 0.889 | 2.734 |
| string: silesia/dickens | 172528 | 6172.4 ± 0.4% | 2889.7 ± 0.1% | 2064.4 ± 2.8% | 285.1 ± 4.6% | 2163.5 ± 7.0% | 473.8 ± 2.8% | 2.136 | 2.990 | 21.647 | 2.853 | 13.027 |
| string: silesia/nci | 1075110 | 5117.8 ± 0.2% | 3467.9 ± 0.5% | 2855.2 ± 5.1% | 453.7 ± 1.4% | 2346.3 ± 0.7% | 515.0 ± 1.7% | 1.476 | 1.792 | 11.280 | 2.181 | 9.938 |
| string: silesia/reymont | 1075159 | 3300.7 ± 0.7% | 2193.7 ± 2.6% | 1782.9 ± 6.0% | 292.7 ± 3.5% | 1618.5 ± 0.5% | 470.8 ± 3.4% | 1.505 | 1.851 | 11.277 | 2.039 | 7.011 |
| string: silesia/samba | 97582 | 3341.4 ± 1.7% | 2741.9 ± 1.7% | 1609.7 ± 3.9% | 253.1 ± 4.3% | 1278.4 ± 0.5% | 347.2 ± 46.4% | 1.219 | 2.076 | 13.202 | 2.614 | 9.624 |
| string: silesia/webster | 1098490 | 4102.7 ± 0.4% | 2031.0 ± 0.3% | 1668.2 ± 0.9% | 286.1 ± 1.3% | 1668.3 ± 0.8% | 425.3 ± 4.8% | 2.020 | 2.459 | 14.340 | 2.459 | 9.648 |
| string: silesia/xml | 1090118 | 5519.5 ± 0.2% | 3714.3 ± 0.5% | 2177.3 ± 1.1% | 374.7 ± 1.1% | 2361.9 ± 2.6% | 507.5 ± 3.0% | 1.486 | 2.535 | 14.729 | 2.337 | 10.876 |
| string: canterbury/alice29.txt | 159425 | 4895.4 ± 1.8% | 2400.2 ± 0.5% | 1840.1 ± 2.1% | 269.4 ± 2.0% | 1942.5 ± 0.5% | 422.1 ± 6.8% | 2.040 | 2.660 | 18.170 | 2.520 | 11.599 |
| string: canterbury/asyoulik.txt | 132198 | 3616.7 ± 6.6% | 2111.7 ± 0.1% | 1477.7 ± 3.5% | 256.9 ± 7.5% | 1590.3 ± 1.4% | 399.2 ± 3.1% | 1.713 | 2.447 | 14.079 | 2.274 | 9.059 |
| string: canterbury/lcet10.txt | 441884 | 6098.1 ± 0.1% | 2790.6 ± 0.4% | 2006.4 ± 1.4% | 304.6 ± 2.1% | 2143.6 ± 0.9% | 473.6 ± 3.4% | 2.185 | 3.039 | 20.019 | 2.845 | 12.877 |
| string: canterbury/plrabn12.txt | 503330 | 4739.2 ± 0.4% | 2699.7 ± 0.2% | 1716.3 ± 11.6% | 277.8 ± 2.1% | 2005.5 ± 0.5% | 453.6 ± 2.5% | 1.755 | 2.761 | 17.060 | 2.363 | 10.448 |
| string: canterbury-large/E.coli | 1048578 | 33526.3 ± 12.4% | 7728.0 ± 0.7% | 3527.2 ± 0.6% | 868.3 ± 1.9% | 5514.9 ± 0.6% | 816.3 ± 2.3% | 4.338 | 9.505 | 38.610 | 6.079 | 41.071 |
| string: canterbury-large/bible.txt | 1055886 | 9682.1 ± 0.7% | 3909.3 ± 1.0% | 2619.9 ± 0.7% | 326.2 ± 3.8% | 2961.3 ± 11.5% | 604.7 ± 2.6% | 2.477 | 3.696 | 29.683 | 3.270 | 16.013 |
| string: canterbury-large/world192.txt | 1103121 | 3763.4 ± 1.3% | 1977.2 ± 0.4% | 1692.9 ± 0.2% | 281.8 ± 1.4% | 1687.4 ± 1.2% | 424.7 ± 3.3% | 1.903 | 2.223 | 13.356 | 2.230 | 8.860 |
| string: http/html-1m | 1058582 | 8044.6 ± 1.3% | 3400.3 ± 2.7% | 2422.9 ± 2.1% | 373.9 ± 1.4% | 2722.1 ± 1.0% | 424.3 ± 1.6% | 2.366 | 3.320 | 21.517 | 2.955 | 18.961 |
| string: http/json-1m | 1190272 | 3314.5 ± 0.4% | 1201.6 ± 0.2% | 1543.3 ± 10.5% | 340.1 ± 5.0% | 824.7 ± 1.0% | 300.8 ± 0.8% | 2.758 | 2.148 | 9.745 | 4.019 | 11.018 |
| string: http/js-1m | 1144362 | 2660.0 ± 1.1% | 1326.0 ± 0.3% | 1203.4 ± 1.8% | 262.3 ± 1.3% | 1152.4 ± 3.1% | 293.6 ± 24.3% | 2.006 | 2.210 | 10.140 | 2.308 | 9.060 |
| string: http/css-1m | 1097820 | 3033.1 ± 1.8% | 2510.9 ± 0.3% | 1571.4 ± 1.4% | 342.4 ± 2.4% | 1523.6 ± 1.3% | 328.8 ± 2.8% | 1.208 | 1.930 | 8.860 | 1.991 | 9.225 |
| string: dickens as Cyrillic and CJK | 1883069 | 5384.0 ± 1.0% | 3164.2 ± 0.8% | 678.8 ± 1.0% | 269.7 ± 6.0% | 488.4 ± 4.3% | 138.1 ± 1.9% | 1.702 | 7.932 | 19.963 | 11.025 | 38.998 |
| string: dickens as Cyrillic and CJK, as \u escapes | 5075485 | 1060.1 ± 2.2% | 1073.8 ± 8.4% | 844.8 ± 15.1% | 159.4 ± 2.0% | 380.6 ± 3.0% | 189.2 ± 13.9% | 0.987 | 1.255 | 6.653 | 2.785 | 5.602 |
| hex: silesia/dickens | 524290 | 33681.8 ± 0.2% | 7726.1 ± 0.9% | 3551.0 ± 1.6% | 431.5 ± 4.8% | 5499.1 ± 1.7% | 777.7 ± 3.8% | 4.359 | 9.485 | 78.065 | 6.125 | 43.310 |
| hex: silesia/mozilla | 524290 | 33512.1 ± 0.5% | 7750.7 ± 0.3% | 3540.8 ± 0.9% | 381.4 ± 2.9% | 5510.4 ± 0.8% | 791.5 ± 1.7% | 4.324 | 9.465 | 87.861 | 6.082 | 42.338 |
| hex: silesia/mr | 524290 | 33504.6 ± 1.1% | 7721.6 ± 0.5% | 3558.6 ± 0.7% | 553.4 ± 2.2% | 5510.0 ± 1.5% | 782.5 ± 0.2% | 4.339 | 9.415 | 60.544 | 6.081 | 42.819 |
| hex: silesia/nci | 524290 | 33460.8 ± 1.2% | 7763.2 ± 0.4% | 3548.9 ± 0.5% | 616.0 ± 2.9% | 5476.4 ± 7.7% | 785.6 ± 10.7% | 4.310 | 9.428 | 54.316 | 6.110 | 42.593 |
| hex: silesia/ooffice | 524290 | 33484.9 ± 1.3% | 7739.7 ± 2.4% | 3535.9 ± 0.4% | 330.6 ± 1.9% | 5487.0 ± 0.7% | 775.4 ± 3.5% | 4.326 | 9.470 | 101.275 | 6.103 | 43.183 |
| hex: silesia/osdb | 524290 | 33532.2 ± 2.1% | 7751.3 ± 0.8% | 3530.6 ± 0.6% | 424.4 ± 3.2% | 5476.7 ± 16.7% | 786.9 ± 3.7% | 4.326 | 9.498 | 79.019 | 6.123 | 42.614 |
| hex: silesia/reymont | 524290 | 33607.3 ± 12.6% | 7756.5 ± 0.8% | 3557.4 ± 0.9% | 466.6 ± 0.4% | 5523.3 ± 0.6% | 794.5 ± 4.5% | 4.333 | 9.447 | 72.032 | 6.085 | 42.300 |
| hex: silesia/samba | 524290 | 33312.7 ± 1.8% | 7731.9 ± 3.3% | 3525.2 ± 2.1% | 334.1 ± 1.7% | 5489.9 ± 3.4% | 801.3 ± 3.6% | 4.308 | 9.450 | 99.709 | 6.068 | 41.576 |
| hex: silesia/sao | 524290 | 33438.8 ± 0.4% | 7712.8 ± 1.1% | 3529.3 ± 5.6% | 272.5 ± 1.2% | 5477.0 ± 3.4% | 813.7 ± 3.4% | 4.335 | 9.475 | 122.696 | 6.105 | 41.095 |
| hex: silesia/webster | 524290 | 33464.4 ± 0.3% | 7766.3 ± 0.4% | 3538.3 ± 1.0% | 399.6 ± 2.5% | 5517.6 ± 2.0% | 809.0 ± 2.3% | 4.309 | 9.458 | 83.750 | 6.065 | 41.367 |
| hex: silesia/x-ray | 524290 | 33753.5 ± 1.7% | 7739.9 ± 0.8% | 3527.3 ± 0.8% | 404.4 ± 1.5% | 5506.9 ± 0.7% | 808.8 ± 3.6% | 4.361 | 9.569 | 83.462 | 6.129 | 41.734 |
| hex: silesia/xml | 524290 | 33513.9 ± 0.2% | 7697.9 ± 4.2% | 3526.7 ± 0.8% | 565.3 ± 2.4% | 5496.8 ± 0.5% | 816.4 ± 3.7% | 4.354 | 9.503 | 59.288 | 6.097 | 41.049 |
| hex: canterbury/alice29.txt | 304180 | 33817.3 ± 1.1% | 7734.9 ± 0.8% | 3582.0 ± 0.7% | 427.2 ± 1.2% | 5492.3 ± 3.3% | 811.6 ± 4.4% | 4.372 | 9.441 | 79.160 | 6.157 | 41.669 |
| hex: canterbury/asyoulik.txt | 250360 | 33864.3 ± 2.9% | 7778.8 ± 0.6% | 3541.8 ± 1.1% | 419.3 ± 2.0% | 5463.7 ± 1.1% | 805.4 ± 3.6% | 4.353 | 9.561 | 80.767 | 6.198 | 42.046 |
| hex: canterbury/cp.html | 49208 | 32896.3 ± 0.2% | 7765.6 ± 0.8% | 3521.1 ± 1.8% | 406.9 ± 3.2% | 5428.3 ± 0.7% | 799.3 ± 2.6% | 4.236 | 9.343 | 80.841 | 6.060 | 41.154 |
| hex: canterbury/fields.c | 22302 | 31778.8 ± 7.4% | 7697.7 ± 1.8% | 3552.0 ± 1.8% | 425.2 ± 2.3% | 5455.5 ± 3.0% | 763.7 ± 4.7% | 4.128 | 8.947 | 74.739 | 5.825 | 41.613 |
| hex: canterbury/grammar.lsp | 7444 | 27817.3 ± 0.3% | 7492.3 ± 0.6% | 3614.4 ± 0.5% | 477.0 ± 5.0% | 5311.0 ± 1.1% | 754.1 ± 3.7% | 3.713 | 7.696 | 58.315 | 5.238 | 36.890 |
| hex: canterbury/kennedy.xls | 524290 | 33565.8 ± 0.4% | 7727.7 ± 1.5% | 3499.4 ± 4.9% | 619.0 ± 5.7% | 5492.5 ± 0.4% | 793.7 ± 6.7% | 4.344 | 9.592 | 54.229 | 6.111 | 42.293 |
| hex: canterbury/lcet10.txt | 524290 | 33636.1 ± 4.2% | 7781.9 ± 0.3% | 3521.0 ± 2.5% | 429.2 ± 3.1% | 5510.2 ± 0.8% | 808.4 ± 3.3% | 4.322 | 9.553 | 78.370 | 6.104 | 41.608 |
| hex: canterbury/plrabn12.txt | 524290 | 33328.3 ± 3.2% | 7744.1 ± 0.6% | 3523.0 ± 2.1% | 414.9 ± 2.8% | 5508.9 ± 0.8% | 781.8 ± 2.3% | 4.304 | 9.460 | 80.327 | 6.050 | 42.630 |
| hex: canterbury/ptt5 | 524290 | 33308.0 ± 0.3% | 7766.4 ± 0.7% | 3521.5 ± 0.6% | 526.2 ± 5.9% | 5483.3 ± 0.8% | 792.2 ± 2.9% | 4.289 | 9.458 | 63.297 | 6.074 | 42.046 |
| hex: canterbury/sum | 76482 | 33339.8 ± 0.2% | 7795.6 ± 0.9% | 3557.9 ± 1.0% | 466.1 ± 1.5% | 5475.9 ± 16.5% | 793.9 ± 5.1% | 4.277 | 9.371 | 71.527 | 6.088 | 41.993 |
| hex: canterbury/xargs.1 | 8456 | 28325.4 ± 0.4% | 7536.1 ± 0.1% | 3596.9 ± 1.2% | 454.0 ± 2.8% | 5300.8 ± 1.4% | 778.8 ± 3.2% | 3.759 | 7.875 | 62.394 | 5.344 | 36.369 |
| hex: canterbury-large/E.coli | 524290 | 33558.8 ± 1.5% | 7733.1 ± 0.8% | 3540.8 ± 2.9% | 711.9 ± 3.1% | 5485.3 ± 3.1% | 787.5 ± 8.9% | 4.340 | 9.478 | 47.137 | 6.118 | 42.616 |
| hex: canterbury-large/bible.txt | 524290 | 33561.0 ± 0.5% | 7750.8 ± 5.1% | 3518.0 ± 0.3% | 450.7 ± 2.5% | 5506.1 ± 0.4% | 796.7 ± 2.6% | 4.330 | 9.540 | 74.471 | 6.095 | 42.127 |
| hex: canterbury-large/world192.txt | 524290 | 33276.4 ± 0.6% | 7682.3 ± 2.3% | 3523.0 ± 8.3% | 413.8 ± 5.8% | 5512.4 ± 0.6% | 788.3 ± 5.1% | 4.332 | 9.445 | 80.408 | 6.037 | 42.212 |
| hex: http/html-1kx1024 | 2099200 | 17026.1 ± 13.5% | 6653.5 ± 0.1% | 3199.7 ± 3.4% | 439.7 ± 1.5% | 4731.8 ± 0.7% | 696.2 ± 1.5% | 2.559 | 5.321 | 38.720 | 3.598 | 24.455 |
| hex: http/html-16kx64 | 2097280 | 30587.2 ± 0.7% | 7660.3 ± 0.3% | 3523.1 ± 0.6% | 448.5 ± 3.1% | 5419.6 ± 24.4% | 773.9 ± 5.8% | 3.993 | 8.682 | 68.198 | 5.644 | 39.525 |
| hex: http/html-1m | 524290 | 33436.3 ± 0.6% | 7770.0 ± 0.5% | 3540.6 ± 0.8% | 450.4 ± 0.7% | 5503.4 ± 0.2% | 782.4 ± 3.9% | 4.303 | 9.444 | 74.240 | 6.076 | 42.736 |
| hex: http/json-1kx1024 | 2099200 | 17056.8 ± 19.5% | 6648.7 ± 0.1% | 3226.3 ± 2.2% | 572.1 ± 4.8% | 4739.6 ± 0.7% | 700.5 ± 4.3% | 2.565 | 5.287 | 29.815 | 3.599 | 24.349 |
| hex: http/json-16kx64 | 2097280 | 30456.6 ± 0.5% | 7671.1 ± 2.0% | 3529.2 ± 0.5% | 582.6 ± 0.9% | 5425.4 ± 0.6% | 758.6 ± 8.2% | 3.970 | 8.630 | 52.275 | 5.614 | 40.148 |
| hex: http/json-1m | 524290 | 33773.7 ± 0.1% | 7756.8 ± 0.4% | 3517.1 ± 1.8% | 593.2 ± 4.0% | 5497.6 ± 3.0% | 795.0 ± 5.9% | 4.354 | 9.603 | 56.932 | 6.143 | 42.482 |
| hex: http/js-1kx1024 | 2099200 | 17002.8 ± 2.0% | 6659.9 ± 0.4% | 3231.1 ± 2.5% | 430.9 ± 2.5% | 4732.1 ± 1.3% | 702.5 ± 2.5% | 2.553 | 5.262 | 39.456 | 3.593 | 24.204 |
| hex: http/js-16kx64 | 2097280 | 30802.4 ± 0.8% | 7678.7 ± 0.2% | 3523.4 ± 0.6% | 436.8 ± 5.3% | 5422.0 ± 0.4% | 775.1 ± 4.0% | 4.011 | 8.742 | 70.515 | 5.681 | 39.739 |
| hex: http/js-1m | 524290 | 33391.2 ± 2.7% | 7772.9 ± 0.7% | 3525.9 ± 9.2% | 460.7 ± 2.9% | 5532.4 ± 0.8% | 797.5 ± 5.0% | 4.296 | 9.470 | 72.476 | 6.036 | 41.869 |
| hex: http/css-1kx1024 | 2099200 | 17069.1 ± 23.1% | 6653.5 ± 1.0% | 3224.5 ± 1.5% | 492.4 ± 1.9% | 4730.0 ± 0.2% | 699.2 ± 2.9% | 2.565 | 5.294 | 34.664 | 3.609 | 24.414 |
| hex: http/css-16kx64 | 2097280 | 30716.6 ± 4.5% | 7676.1 ± 0.5% | 3533.3 ± 1.3% | 508.4 ± 2.8% | 5433.6 ± 0.2% | 791.3 ± 4.5% | 4.002 | 8.693 | 60.418 | 5.653 | 38.818 |
| hex: http/css-1m | 524290 | 33621.5 ± 1.5% | 7735.1 ± 0.4% | 3518.4 ± 1.0% | 496.4 ± 1.8% | 5498.4 ± 0.3% | 794.7 ± 3.1% | 4.347 | 9.556 | 67.726 | 6.115 | 42.305 |
| hex: shuffled/dickens-1m | 524290 | 33598.2 ± 2.3% | 7727.0 ± 8.8% | 3508.6 ± 4.0% | 437.8 ± 2.3% | 5515.2 ± 5.5% | 785.9 ± 3.5% | 4.348 | 9.576 | 76.746 | 6.092 | 42.750 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1130.5 ± 0.4% | 1142.7 ± 1.0% | 865.2 ± 1.1% | 324.9 ± 2.1% | 352.8 ± 12.7% | 311.4 ± 1.0% | 0.989 | 1.307 | 3.480 | 3.204 | 3.630 |
| qlog records, JSON text sequence | 1467503 | 967.4 ± 0.7% | 877.4 ± 0.4% | 703.8 ± 0.5% | 321.5 ± 2.0% | 396.6 ± 1.8% | 229.8 ± 1.6% | 1.103 | 1.375 | 3.009 | 2.439 | 4.210 |
| messages: 11 string members | 1025025 | 1116.6 ± 7.4% | 894.4 ± 2.1% | 667.2 ± 3.6% | 312.0 ± 1.4% | 319.6 ± 3.7% | 286.1 ± 4.8% | 1.248 | 1.674 | 3.579 | 3.493 | 3.903 |
| messages: 50 nested objects | 1121600 | 1140.2 ± 2.1% | 1194.7 ± 1.5% | 922.0 ± 2.8% | 394.8 ± 1.6% | 425.1 ± 3.1% | 320.3 ± 2.4% | 0.954 | 1.237 | 2.888 | 2.683 | 3.560 |
| messages: a tree of 341 objects | 612600 | 450.8 ± 4.2% | 598.3 ± 5.1% | 376.3 ± 1.9% | 198.3 ± 1.8% | 252.9 ± 6.0% | 124.4 ± 7.8% | 0.754 | 1.198 | 2.273 | 1.782 | 3.623 |
| string: silesia/dickens | 172528 | 9253.4 ± 1.9% | 2950.4 ± 2.4% | 2058.8 ± 2.0% | 354.6 ± 1.3% | 1040.4 ± 1.5% | 561.4 ± 1.2% | 3.136 | 4.495 | 26.094 | 8.894 | 16.484 |
| string: silesia/nci | 1075110 | 8756.5 ± 2.0% | 3165.8 ± 2.7% | 2790.5 ± 2.4% | 774.2 ± 5.6% | 1087.1 ± 2.6% | 565.3 ± 0.9% | 2.766 | 3.138 | 11.311 | 8.055 | 15.490 |
| string: silesia/reymont | 1075159 | 3856.1 ± 3.4% | 1657.5 ± 1.1% | 1748.0 ± 0.5% | 361.8 ± 1.0% | 953.8 ± 1.2% | 553.1 ± 1.0% | 2.326 | 2.206 | 10.658 | 4.043 | 6.972 |
| string: silesia/samba | 97582 | 4644.9 ± 1.9% | 1952.6 ± 1.9% | 2079.9 ± 6.5% | 276.3 ± 3.8% | 882.3 ± 2.7% | 618.2 ± 1.2% | 2.379 | 2.233 | 16.810 | 5.265 | 7.514 |
| string: silesia/webster | 1098490 | 5071.0 ± 0.4% | 1631.2 ± 1.0% | 1540.5 ± 1.4% | 358.4 ± 1.8% | 931.5 ± 1.0% | 456.4 ± 0.8% | 3.109 | 3.292 | 14.147 | 5.444 | 11.110 |
| string: silesia/xml | 1090118 | 7930.1 ± 1.3% | 2665.9 ± 0.2% | 2161.9 ± 0.5% | 522.4 ± 1.0% | 1121.8 ± 0.6% | 563.5 ± 0.7% | 2.975 | 3.668 | 15.181 | 7.069 | 14.073 |
| string: canterbury/alice29.txt | 159425 | 9934.8 ± 0.3% | 2434.7 ± 1.4% | 1810.2 ± 18.7% | 339.0 ± 3.3% | 1018.2 ± 1.3% | 560.3 ± 0.5% | 4.081 | 5.488 | 29.310 | 9.757 | 17.731 |
| string: canterbury/asyoulik.txt | 132198 | 8052.5 ± 1.2% | 2193.9 ± 1.4% | 1543.8 ± 2.2% | 341.4 ± 0.8% | 896.8 ± 1.3% | 546.5 ± 0.7% | 3.670 | 5.216 | 23.585 | 8.979 | 14.735 |
| string: canterbury/lcet10.txt | 441884 | 9017.4 ± 1.9% | 2449.3 ± 2.3% | 1971.7 ± 1.9% | 385.2 ± 3.2% | 1024.9 ± 4.2% | 559.4 ± 4.5% | 3.682 | 4.573 | 23.408 | 8.799 | 16.120 |
| string: canterbury/plrabn12.txt | 503330 | 6063.0 ± 2.9% | 1842.5 ± 1.2% | 1686.4 ± 0.8% | 361.6 ± 3.9% | 994.4 ± 1.3% | 564.8 ± 1.6% | 3.291 | 3.595 | 16.765 | 6.097 | 10.735 |
| string: canterbury-large/E.coli | 1048578 | 38649.8 ± 0.9% | 11633.6 ± 0.5% | 3393.2 ± 0.2% | 1422.3 ± 0.3% | 1399.2 ± 20.3% | 576.9 ± 0.9% | 3.322 | 11.390 | 27.174 | 27.623 | 66.992 |
| string: canterbury-large/bible.txt | 1055886 | 7046.7 ± 0.3% | 3969.4 ± 0.7% | 2675.3 ± 0.5% | 437.2 ± 3.4% | 1195.3 ± 1.3% | 574.3 ± 0.8% | 1.775 | 2.634 | 16.116 | 5.895 | 12.270 |
| string: canterbury-large/world192.txt | 1103121 | 4860.3 ± 6.8% | 1441.9 ± 3.3% | 1582.9 ± 18.2% | 353.4 ± 2.1% | 925.0 ± 0.7% | 542.6 ± 1.3% | 3.371 | 3.071 | 13.752 | 5.255 | 8.958 |
| string: http/html-1m | 1058582 | 8588.0 ± 1.7% | 3855.2 ± 0.8% | 2494.6 ± 0.3% | 425.4 ± 1.1% | 1184.9 ± 8.7% | 525.3 ± 0.7% | 2.228 | 3.443 | 20.186 | 7.248 | 16.349 |
| string: http/json-1m | 1190272 | 6681.1 ± 0.2% | 1229.3 ± 1.0% | 1289.2 ± 1.6% | 414.5 ± 1.8% | 777.0 ± 1.2% | 508.8 ± 1.0% | 5.435 | 5.182 | 16.117 | 8.599 | 13.132 |
| string: http/js-1m | 1144362 | 5168.1 ± 10.3% | 992.2 ± 2.6% | 1110.5 ± 1.9% | 295.1 ± 3.3% | 782.1 ± 2.5% | 475.3 ± 1.8% | 5.209 | 4.654 | 17.512 | 6.608 | 10.873 |
| string: http/css-1m | 1097820 | 6944.2 ± 1.5% | 1288.1 ± 1.4% | 1617.1 ± 0.3% | 427.0 ± 3.9% | 856.3 ± 1.4% | 533.0 ± 0.9% | 5.391 | 4.294 | 16.263 | 8.110 | 13.029 |
| string: dickens as Cyrillic and CJK | 1883069 | 5349.5 ± 0.6% | 3016.1 ± 0.2% | 334.9 ± 7.6% | 272.9 ± 5.0% | 409.3 ± 1.9% | 293.8 ± 0.3% | 1.774 | 15.975 | 19.604 | 13.071 | 18.208 |
| hex: silesia/dickens | 524290 | 31219.2 ± 0.6% | 1558.6 ± 1.9% | 1093.7 ± 0.7% | 426.0 ± 1.6% | 787.9 ± 0.6% | 444.8 ± 2.2% | 20.031 | 28.545 | 73.289 | 39.622 | 70.190 |
| hex: silesia/mozilla | 524290 | 35384.0 ± 0.4% | 1567.1 ± 0.8% | 1093.1 ± 1.6% | 370.8 ± 1.8% | 788.3 ± 0.3% | 438.4 ± 3.9% | 22.579 | 32.370 | 95.423 | 44.885 | 80.716 |
| hex: silesia/mr | 524290 | 35286.8 ± 3.0% | 1565.3 ± 0.6% | 1094.1 ± 0.7% | 507.3 ± 2.7% | 791.2 ± 0.3% | 440.0 ± 6.2% | 22.544 | 32.251 | 69.557 | 44.601 | 80.197 |
| hex: silesia/nci | 524290 | 35400.6 ± 1.9% | 1567.6 ± 1.4% | 1092.9 ± 0.9% | 569.8 ± 2.2% | 787.6 ± 1.6% | 436.4 ± 1.2% | 22.582 | 32.392 | 62.124 | 44.946 | 81.110 |
| hex: silesia/ooffice | 524290 | 33851.6 ± 0.5% | 1565.3 ± 0.7% | 1093.6 ± 0.4% | 324.0 ± 1.2% | 791.1 ± 1.7% | 431.8 ± 7.7% | 21.627 | 30.954 | 104.495 | 42.792 | 78.405 |
| hex: silesia/osdb | 524290 | 32388.2 ± 2.2% | 1558.4 ± 2.1% | 1090.4 ± 2.1% | 412.1 ± 3.1% | 786.9 ± 3.1% | 431.8 ± 3.0% | 20.783 | 29.704 | 78.597 | 41.160 | 75.012 |
| hex: silesia/reymont | 524290 | 34128.5 ± 9.5% | 1570.5 ± 1.4% | 1094.2 ± 0.4% | 443.5 ± 1.6% | 793.0 ± 0.3% | 441.4 ± 7.4% | 21.731 | 31.189 | 76.956 | 43.038 | 77.320 |
| hex: silesia/samba | 524290 | 36043.4 ± 2.2% | 1569.0 ± 1.5% | 1092.4 ± 2.1% | 323.4 ± 2.7% | 785.5 ± 3.4% | 422.6 ± 3.3% | 22.973 | 32.996 | 111.437 | 45.884 | 85.295 |
| hex: silesia/sao | 524290 | 34575.1 ± 0.5% | 1564.9 ± 1.2% | 1093.0 ± 0.6% | 263.4 ± 2.6% | 780.1 ± 3.0% | 426.8 ± 3.1% | 22.094 | 31.634 | 131.267 | 44.323 | 81.008 |
| hex: silesia/webster | 524290 | 36058.4 ± 0.5% | 1560.6 ± 1.7% | 1090.8 ± 0.8% | 393.7 ± 2.8% | 787.9 ± 0.4% | 434.4 ± 2.8% | 23.105 | 33.055 | 91.594 | 45.765 | 83.001 |
| hex: silesia/x-ray | 524290 | 34774.8 ± 1.5% | 1565.4 ± 0.8% | 1089.9 ± 0.8% | 397.6 ± 0.7% | 790.4 ± 0.4% | 438.2 ± 4.4% | 22.214 | 31.906 | 87.467 | 43.997 | 79.362 |
| hex: silesia/xml | 524290 | 35142.6 ± 1.1% | 1569.6 ± 1.2% | 1094.0 ± 2.7% | 581.5 ± 0.2% | 790.2 ± 0.8% | 441.5 ± 2.9% | 22.389 | 32.122 | 60.438 | 44.471 | 79.601 |
| hex: canterbury/alice29.txt | 304180 | 33378.1 ± 0.5% | 1583.9 ± 0.4% | 1096.5 ± 0.3% | 429.7 ± 17.8% | 804.3 ± 0.8% | 443.8 ± 4.0% | 21.073 | 30.440 | 77.683 | 41.500 | 75.215 |
| hex: canterbury/asyoulik.txt | 250360 | 31240.9 ± 1.4% | 1580.9 ± 2.4% | 1100.2 ± 2.4% | 405.0 ± 3.3% | 803.9 ± 3.8% | 432.8 ± 3.5% | 19.761 | 28.395 | 77.130 | 38.862 | 72.181 |
| hex: canterbury/cp.html | 49208 | 31901.3 ± 0.3% | 1604.4 ± 1.2% | 1101.6 ± 0.5% | 436.3 ± 3.0% | 804.5 ± 1.3% | 438.2 ± 3.8% | 19.883 | 28.958 | 73.119 | 39.656 | 72.794 |
| hex: canterbury/fields.c | 22302 | 33189.6 ± 0.7% | 1588.6 ± 7.6% | 1092.6 ± 0.6% | 522.6 ± 5.0% | 804.5 ± 2.0% | 429.9 ± 2.2% | 20.892 | 30.377 | 63.514 | 41.254 | 77.204 |
| hex: canterbury/grammar.lsp | 7444 | 33173.3 ± 0.7% | 1644.2 ± 0.4% | 1120.3 ± 0.4% | 537.7 ± 3.0% | 810.3 ± 12.5% | 431.0 ± 3.6% | 20.176 | 29.612 | 61.691 | 40.939 | 76.974 |
| hex: canterbury/kennedy.xls | 524290 | 31375.7 ± 0.8% | 1556.4 ± 6.2% | 1090.9 ± 0.6% | 577.2 ± 4.0% | 782.6 ± 0.4% | 438.5 ± 2.6% | 20.159 | 28.762 | 54.356 | 40.094 | 71.556 |
| hex: canterbury/lcet10.txt | 524290 | 36244.0 ± 1.4% | 1570.9 ± 0.7% | 1093.9 ± 3.1% | 427.2 ± 2.3% | 786.0 ± 1.2% | 440.3 ± 1.9% | 23.072 | 33.134 | 84.832 | 46.114 | 82.319 |
| hex: canterbury/plrabn12.txt | 524290 | 34522.4 ± 0.5% | 1558.7 ± 8.6% | 1091.2 ± 0.3% | 411.2 ± 4.8% | 783.4 ± 2.4% | 435.4 ± 3.6% | 22.148 | 31.638 | 83.961 | 44.067 | 79.285 |
| hex: canterbury/ptt5 | 524290 | 34614.1 ± 1.0% | 1561.3 ± 9.8% | 1094.6 ± 1.2% | 498.0 ± 0.3% | 785.7 ± 26.8% | 440.5 ± 2.1% | 22.170 | 31.622 | 69.506 | 44.058 | 78.582 |
| hex: canterbury/sum | 76482 | 35381.9 ± 0.2% | 1607.0 ± 5.8% | 1099.8 ± 3.5% | 510.9 ± 5.2% | 809.8 ± 1.5% | 437.3 ± 4.1% | 22.018 | 32.173 | 69.257 | 43.694 | 80.917 |
| hex: canterbury/xargs.1 | 8456 | 35528.5 ± 0.3% | 1631.6 ± 0.9% | 1114.5 ± 0.9% | 543.9 ± 4.5% | 813.4 ± 0.9% | 429.5 ± 2.7% | 21.775 | 31.878 | 65.319 | 43.681 | 82.722 |
| hex: canterbury-large/E.coli | 524290 | 30492.2 ± 1.3% | 1558.2 ± 0.8% | 1090.3 ± 2.2% | 592.0 ± 4.1% | 793.5 ± 0.5% | 437.3 ± 2.6% | 19.568 | 27.968 | 51.507 | 38.429 | 69.724 |
| hex: canterbury-large/bible.txt | 524290 | 35352.3 ± 1.4% | 1558.3 ± 2.1% | 1093.6 ± 0.2% | 442.1 ± 0.2% | 791.9 ± 0.2% | 447.8 ± 2.4% | 22.686 | 32.326 | 79.956 | 44.644 | 78.944 |
| hex: canterbury-large/world192.txt | 524290 | 33266.2 ± 0.6% | 1557.0 ± 0.2% | 1090.1 ± 0.7% | 422.0 ± 1.2% | 794.6 ± 0.4% | 438.7 ± 2.3% | 21.365 | 30.515 | 78.832 | 41.866 | 75.822 |
| hex: http/html-1kx1024 | 2099200 | 25115.2 ± 0.7% | 1611.4 ± 0.9% | 1089.4 ± 0.3% | 451.8 ± 14.0% | 799.5 ± 5.8% | 432.7 ± 3.0% | 15.586 | 23.055 | 55.587 | 31.415 | 58.039 |
| hex: http/html-16kx64 | 2097280 | 30462.7 ± 0.8% | 1607.6 ± 0.4% | 1101.1 ± 0.4% | 447.8 ± 3.3% | 804.1 ± 0.3% | 439.0 ± 3.8% | 18.949 | 27.666 | 68.035 | 37.884 | 69.385 |
| hex: http/html-1m | 524290 | 31890.4 ± 0.5% | 1557.8 ± 0.3% | 1092.2 ± 0.6% | 447.2 ± 0.2% | 784.8 ± 3.3% | 443.3 ± 4.5% | 20.472 | 29.199 | 71.316 | 40.636 | 71.942 |
| hex: http/json-1kx1024 | 2099200 | 25051.2 ± 0.4% | 1610.0 ± 7.4% | 1090.5 ± 0.3% | 566.9 ± 0.3% | 805.5 ± 1.4% | 443.3 ± 2.1% | 15.560 | 22.972 | 44.187 | 31.098 | 56.508 |
| hex: http/json-16kx64 | 2097280 | 30601.4 ± 3.6% | 1606.9 ± 0.5% | 1102.6 ± 0.5% | 574.5 ± 2.7% | 805.8 ± 1.2% | 436.9 ± 4.3% | 19.043 | 27.754 | 53.265 | 37.976 | 70.038 |
| hex: http/json-1m | 524290 | 31164.6 ± 0.3% | 1555.9 ± 0.8% | 1091.1 ± 0.8% | 586.7 ± 0.2% | 780.5 ± 0.3% | 443.3 ± 2.9% | 20.030 | 28.561 | 53.117 | 39.931 | 70.302 |
| hex: http/js-1kx1024 | 2099200 | 25191.8 ± 0.5% | 1609.9 ± 0.1% | 1087.6 ± 2.0% | 443.2 ± 1.3% | 805.7 ± 0.6% | 433.1 ± 2.9% | 15.648 | 23.164 | 56.844 | 31.269 | 58.170 |
| hex: http/js-16kx64 | 2097280 | 30345.6 ± 1.0% | 1607.6 ± 0.2% | 1103.3 ± 0.7% | 433.5 ± 3.3% | 803.8 ± 0.6% | 434.9 ± 2.1% | 18.877 | 27.504 | 70.002 | 37.752 | 69.782 |
| hex: http/js-1m | 524290 | 31410.0 ± 0.9% | 1556.2 ± 0.9% | 1091.8 ± 0.5% | 450.2 ± 1.7% | 776.8 ± 3.0% | 441.0 ± 1.9% | 20.184 | 28.769 | 69.771 | 40.435 | 71.229 |
| hex: http/css-1kx1024 | 2099200 | 24972.6 ± 2.6% | 1612.1 ± 2.8% | 1089.0 ± 2.8% | 496.7 ± 4.8% | 805.3 ± 7.3% | 437.7 ± 3.6% | 15.490 | 22.931 | 50.282 | 31.011 | 57.051 |
| hex: http/css-16kx64 | 2097280 | 30494.6 ± 0.5% | 1610.0 ± 0.4% | 1102.0 ± 1.4% | 502.8 ± 1.7% | 808.2 ± 0.3% | 439.3 ± 2.8% | 18.941 | 27.672 | 60.653 | 37.733 | 69.423 |
| hex: http/css-1m | 524290 | 31274.1 ± 5.0% | 1556.8 ± 1.6% | 1089.9 ± 0.7% | 482.4 ± 0.5% | 778.9 ± 0.4% | 446.0 ± 1.6% | 20.088 | 28.693 | 64.832 | 40.154 | 70.125 |
| hex: shuffled/dickens-1m | 524290 | 33346.5 ± 0.8% | 1558.2 ± 0.7% | 1087.7 ± 0.3% | 425.6 ± 0.2% | 780.1 ± 0.4% | 441.5 ± 7.1% | 21.400 | 30.657 | 78.353 | 42.745 | 75.536 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- messages: 11 string members, decoding: stdx runs at 0.815 of simdjson.
- messages: a tree of 341 objects, decoding: stdx runs at 0.865 of simdjson.
- messages: a tree of 341 objects, decoding: stdx runs at 0.873 of yyjson.
- messages: a tree of 341 objects, decoding: stdx runs at 0.838 of serde_json.
- messages: a tree of 341 objects, encoding: stdx runs at 0.751 of simdjson.
- messages: a tree of 341 objects, encoding with J11's loop unchecked: stdx runs at 0.814 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.833 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.914 of yyjson.
- messages: 11 string members, decoding through TextReader.next: stdx runs at 0.716 of simdjson.
- messages: 50 nested objects, decoding through TextReader.next: stdx runs at 0.926 of simdjson.
- messages: 50 nested objects, decoding through TextReader.next: stdx runs at 0.887 of yyjson.
- messages: a tree of 341 objects, decoding through TextReader.next: stdx runs at 0.717 of simdjson.
- messages: a tree of 341 objects, decoding through TextReader.next: stdx runs at 0.724 of yyjson.
- messages: a tree of 341 objects, decoding through TextReader.next: stdx runs at 0.695 of serde_json.
- CLDR supplemental, 34 texts, decoding through TextReader.next_items: stdx runs at 0.948 of simdjson.
- messages: 11 string members, decoding through TextReader.next_items: stdx runs at 0.832 of simdjson.
- messages: a tree of 341 objects, encoding through TextWriter's methods: stdx runs at 0.754 of simdjson.
