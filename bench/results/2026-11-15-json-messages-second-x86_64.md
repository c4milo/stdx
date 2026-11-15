# bench-json

| Field | Value |
|---|---|
| Commit | cffc4ff |
| Runner label | ubuntu-24.04 |
| Image version | 20261111.127.1 |
| CPU model | Intel(R) Xeon(R) 6975P-C |
| Virtual CPUs | 4 |
| Kernel | 7.0.0-1014-aws |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/43657154259 |
| Date | 2026-11-15 |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1. The `TextReader.next_items` column is that helper's queued tokens a slice a call (decision 79), over many tokens a call.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | TextReader.next_items | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1368.1 ± 1.4% | 0.489 | 1.021 | 1.067 | 1.066 | 0.412 | 1.072 | 1.070 | 0.371 | 0.836 | 0.930 | 0.106 |
| qlog records, JSON text sequence | 1467503 | 1083.5 ± 0.4% | 0.788 | 1.060 | 1.068 | 1.064 | 0.385 | 1.067 | 1.063 | 0.367 | 0.931 | 1.050 | 0.126 |
| messages: 11 string members | 1025025 | 1051.9 ± 1.0% | 0.588 | 1.003 | 1.020 | 1.024 | 0.557 | 1.019 | 1.025 | 0.544 | 0.891 | 0.964 | 0.138 |
| messages: 50 nested objects | 1121600 | 1337.9 ± 0.8% | 0.802 | 1.082 | 1.083 | 1.085 | 0.398 | 1.094 | 1.088 | 0.350 | 0.922 | 0.967 | 0.114 |
| string: silesia/dickens | 172528 | 6663.6 ± 1.1% | 0.029 | 0.703 | 1.096 | 1.102 | 0.208 | 1.026 | 1.112 | 0.208 | 1.002 | 1.002 | 0.029 |
| string: silesia/nci | 1075110 | 5394.9 ± 0.7% | 0.036 | 0.710 | 1.032 | 1.032 | 0.304 | 1.036 | 1.033 | 0.304 | 1.003 | 1.005 | 0.036 |
| string: silesia/reymont | 1075159 | 3481.8 ± 2.3% | 0.055 | 0.631 | 0.873 | 0.877 | 0.357 | 0.825 | 0.875 | 0.357 | 0.989 | 0.994 | 0.055 |
| string: silesia/samba | 97582 | 3938.6 ± 0.8% | 0.041 | 0.909 | 1.069 | 1.069 | 0.075 | 0.861 | 1.070 | 0.075 | 1.009 | 1.012 | 0.042 |
| string: silesia/webster | 1098490 | 4376.5 ± 1.0% | 0.043 | 0.648 | 0.983 | 0.985 | 0.227 | 0.925 | 0.991 | 0.227 | 0.998 | 1.007 | 0.043 |
| string: silesia/xml | 1090118 | 6056.3 ± 0.5% | 0.032 | 0.771 | 0.958 | 0.961 | 0.249 | 0.952 | 0.963 | 0.254 | 1.000 | 1.005 | 0.032 |
| string: canterbury/alice29.txt | 159425 | 5755.2 ± 0.9% | 0.033 | 0.755 | 1.061 | 1.128 | 0.186 | 1.024 | 1.172 | 0.186 | 0.997 | 1.013 | 0.033 |
| string: canterbury/asyoulik.txt | 132198 | 4287.8 ± 0.9% | 0.042 | 0.805 | 1.125 | 1.121 | 0.202 | 1.041 | 1.132 | 0.203 | 0.999 | 1.002 | 0.043 |
| string: canterbury/lcet10.txt | 441884 | 6627.9 ± 1.1% | 0.029 | 0.605 | 1.103 | 1.105 | 0.200 | 1.037 | 1.115 | 0.200 | 0.999 | 1.002 | 0.029 |
| string: canterbury/plrabn12.txt | 503330 | 5444.2 ± 0.3% | 0.035 | 0.772 | 0.968 | 0.975 | 0.228 | 0.859 | 0.974 | 0.230 | 1.001 | 1.002 | 0.035 |
| string: canterbury-large/E.coli | 1048578 | 28439.3 ± 1.2% | 0.063 | 1.004 | 0.810 | 1.005 | 0.541 | 1.004 | 1.005 | 0.541 | 1.113 | 1.119 | 0.007 |
| string: canterbury-large/bible.txt | 1055886 | 8443.4 ± 0.5% | 0.024 | 0.633 | 0.878 | 0.881 | 0.399 | 0.890 | 0.896 | 0.401 | 1.007 | 1.010 | 0.024 |
| string: canterbury-large/world192.txt | 1103121 | 4118.5 ± 0.9% | 0.046 | 0.697 | 0.972 | 0.980 | 0.218 | 0.927 | 0.988 | 0.219 | 1.003 | 1.006 | 0.046 |
| string: http/html-1m | 1058582 | 9052.8 ± 2.8% | 0.022 | 0.564 | 0.785 | 0.787 | 0.320 | 0.753 | 0.795 | 0.319 | 0.941 | 1.033 | 0.022 |
| string: http/json-1m | 1190272 | 3242.7 ± 1.2% | 0.053 | 0.402 | 0.448 | 0.454 | 0.152 | 0.464 | 0.453 | 0.152 | 1.005 | 1.005 | 0.053 |
| string: http/js-1m | 1144362 | 2846.5 ± 0.2% | 0.062 | 0.698 | 0.909 | 0.915 | 0.194 | 0.843 | 0.917 | 0.194 | 1.003 | 1.006 | 0.062 |
| string: http/css-1m | 1097820 | 3281.5 ± 0.8% | 0.056 | 0.770 | 0.962 | 0.964 | 0.292 | 0.945 | 0.975 | 0.292 | 1.003 | 1.008 | 0.056 |
| string: dickens as Cyrillic and CJK | 1883069 | 5788.2 ± 0.9% | 0.025 | 0.063 | 0.451 | 0.452 | 0.200 | 0.452 | 0.451 | 0.200 | 0.997 | 1.000 | 0.025 |
| string: dickens as Cyrillic and CJK, as \u escapes | 5075485 | 1187.3 ± 3.6% | 0.113 | 1.007 | 1.008 | 1.014 | 0.107 | 0.723 | 1.012 | 0.107 | 1.012 | 1.017 | 0.113 |
| hex: silesia/dickens | 524290 | 45492.1 ± 1.3% | 0.040 | 0.992 | 0.628 | 0.991 | 0.395 | 0.993 | 1.002 | 0.398 | 0.742 | 0.745 | 0.005 |
| hex: silesia/mozilla | 524290 | 45802.5 ± 2.3% | 0.040 | 0.995 | 0.622 | 0.991 | 0.369 | 0.987 | 1.000 | 0.369 | 0.737 | 0.739 | 0.005 |
| hex: silesia/mr | 524290 | 45356.1 ± 1.5% | 0.040 | 1.002 | 0.622 | 0.995 | 0.391 | 0.995 | 0.993 | 0.391 | 0.744 | 0.745 | 0.005 |
| hex: silesia/nci | 524290 | 44938.2 ± 1.1% | 0.041 | 0.998 | 0.630 | 1.002 | 0.399 | 0.991 | 1.000 | 0.401 | 0.752 | 0.751 | 0.005 |
| hex: silesia/ooffice | 524290 | 45780.4 ± 2.4% | 0.040 | 1.001 | 0.619 | 1.006 | 0.378 | 1.001 | 1.001 | 0.378 | 0.739 | 0.737 | 0.005 |
| hex: silesia/osdb | 524290 | 45937.3 ± 0.5% | 0.040 | 1.004 | 0.621 | 1.004 | 0.393 | 1.001 | 1.004 | 0.393 | 0.738 | 0.738 | 0.005 |
| hex: silesia/reymont | 524290 | 45891.3 ± 1.1% | 0.040 | 1.004 | 0.620 | 1.003 | 0.392 | 0.997 | 1.002 | 0.392 | 0.738 | 0.736 | 0.005 |
| hex: silesia/samba | 524290 | 45594.9 ± 0.4% | 0.040 | 1.001 | 0.613 | 1.001 | 0.391 | 0.995 | 1.000 | 0.391 | 0.739 | 0.740 | 0.005 |
| hex: silesia/sao | 524290 | 35793.9 ± 1.3% | 0.051 | 1.000 | 0.720 | 1.003 | 0.462 | 0.998 | 1.004 | 0.463 | 0.945 | 0.947 | 0.006 |
| hex: silesia/webster | 524290 | 44708.2 ± 1.0% | 0.041 | 1.000 | 0.640 | 1.005 | 0.400 | 0.999 | 1.001 | 0.402 | 0.754 | 0.755 | 0.005 |
| hex: silesia/x-ray | 524290 | 44647.2 ± 0.7% | 0.041 | 1.000 | 0.644 | 0.999 | 0.400 | 0.994 | 1.002 | 0.402 | 0.760 | 0.761 | 0.005 |
| hex: silesia/xml | 524290 | 46015.8 ± 0.9% | 0.040 | 1.003 | 0.620 | 1.004 | 0.392 | 0.995 | 1.004 | 0.392 | 0.738 | 0.736 | 0.005 |
| hex: canterbury/alice29.txt | 304180 | 45537.3 ± 5.0% | 0.040 | 0.997 | 0.622 | 1.001 | 0.393 | 0.993 | 0.995 | 0.397 | 0.744 | 0.740 | 0.005 |
| hex: canterbury/asyoulik.txt | 250360 | 44713.4 ± 1.4% | 0.041 | 0.998 | 0.636 | 0.994 | 0.401 | 0.998 | 0.994 | 0.402 | 0.753 | 0.751 | 0.005 |
| hex: canterbury/cp.html | 49208 | 43737.7 ± 1.0% | 0.042 | 1.004 | 0.639 | 1.003 | 0.404 | 1.003 | 1.004 | 0.407 | 0.766 | 0.766 | 0.005 |
| hex: canterbury/fields.c | 22302 | 51147.2 ± 3.5% | 0.036 | 1.003 | 0.541 | 1.006 | 0.389 | 0.996 | 1.003 | 0.398 | 0.644 | 0.646 | 0.004 |
| hex: canterbury/grammar.lsp | 7444 | 43981.3 ± 3.1% | 0.042 | 1.006 | 0.578 | 1.016 | 0.408 | 1.004 | 1.015 | 0.431 | 0.673 | 0.673 | 0.005 |
| hex: canterbury/kennedy.xls | 524290 | 44668.1 ± 0.6% | 0.041 | 1.001 | 0.629 | 1.001 | 0.405 | 0.999 | 1.001 | 0.405 | 0.761 | 0.762 | 0.005 |
| hex: canterbury/lcet10.txt | 524290 | 47446.5 ± 0.3% | 0.039 | 0.999 | 0.592 | 0.998 | 0.381 | 0.993 | 0.999 | 0.382 | 0.717 | 0.717 | 0.004 |
| hex: canterbury/plrabn12.txt | 524290 | 44701.3 ± 0.7% | 0.041 | 0.999 | 0.626 | 1.002 | 0.401 | 0.996 | 0.999 | 0.403 | 0.759 | 0.756 | 0.005 |
| hex: canterbury/ptt5 | 524290 | 44827.6 ± 2.8% | 0.041 | 1.002 | 0.636 | 0.998 | 0.402 | 0.993 | 0.997 | 0.403 | 0.751 | 0.753 | 0.005 |
| hex: canterbury/sum | 76482 | 45398.1 ± 1.6% | 0.040 | 1.008 | 0.620 | 1.004 | 0.390 | 1.002 | 1.005 | 0.392 | 0.731 | 0.729 | 0.005 |
| hex: canterbury/xargs.1 | 8456 | 45991.1 ± 1.1% | 0.040 | 1.002 | 0.559 | 1.005 | 0.400 | 1.000 | 1.006 | 0.419 | 0.656 | 0.656 | 0.005 |
| hex: canterbury-large/E.coli | 524290 | 46719.6 ± 1.0% | 0.039 | 0.999 | 0.599 | 0.996 | 0.384 | 0.994 | 1.004 | 0.383 | 0.722 | 0.721 | 0.005 |
| hex: canterbury-large/bible.txt | 524290 | 45004.4 ± 1.3% | 0.040 | 1.002 | 0.631 | 1.002 | 0.397 | 0.998 | 1.005 | 0.397 | 0.748 | 0.750 | 0.005 |
| hex: canterbury-large/world192.txt | 524290 | 45217.2 ± 1.1% | 0.040 | 0.998 | 0.626 | 1.003 | 0.393 | 0.994 | 1.002 | 0.393 | 0.745 | 0.746 | 0.005 |
| hex: http/html-1kx1024 | 2099200 | 16557.7 ± 3.9% | 0.108 | 1.017 | 0.847 | 1.000 | 0.596 | 1.003 | 0.999 | 0.652 | 0.877 | 0.855 | 0.013 |
| hex: http/html-16kx64 | 2097280 | 33289.2 ± 0.8% | 0.054 | 1.008 | 0.698 | 1.005 | 0.478 | 1.006 | 1.008 | 0.483 | 0.816 | 0.816 | 0.006 |
| hex: http/html-1m | 524290 | 45836.5 ± 0.6% | 0.040 | 1.002 | 0.616 | 1.000 | 0.392 | 0.998 | 1.001 | 0.392 | 0.737 | 0.736 | 0.005 |
| hex: http/json-1kx1024 | 2099200 | 16852.3 ± 1.3% | 0.107 | 1.019 | 0.843 | 1.002 | 0.607 | 1.007 | 1.003 | 0.666 | 0.870 | 0.849 | 0.012 |
| hex: http/json-16kx64 | 2097280 | 33356.8 ± 1.3% | 0.054 | 1.006 | 0.696 | 1.005 | 0.477 | 1.006 | 1.008 | 0.481 | 0.805 | 0.805 | 0.006 |
| hex: http/json-1m | 524290 | 48302.6 ± 3.4% | 0.038 | 1.006 | 0.589 | 1.004 | 0.371 | 0.997 | 1.002 | 0.372 | 0.699 | 0.697 | 0.004 |
| hex: http/js-1kx1024 | 2099200 | 16907.0 ± 1.0% | 0.107 | 1.019 | 0.840 | 1.004 | 0.609 | 1.005 | 1.004 | 0.665 | 0.872 | 0.851 | 0.012 |
| hex: http/js-16kx64 | 2097280 | 33250.1 ± 1.2% | 0.054 | 1.009 | 0.697 | 1.007 | 0.475 | 1.006 | 1.005 | 0.481 | 0.818 | 0.818 | 0.006 |
| hex: http/js-1m | 524290 | 45944.0 ± 1.2% | 0.040 | 1.006 | 0.616 | 1.006 | 0.391 | 0.998 | 1.001 | 0.390 | 0.735 | 0.732 | 0.005 |
| hex: http/css-1kx1024 | 2099200 | 17007.7 ± 0.3% | 0.105 | 1.016 | 0.841 | 0.996 | 0.589 | 1.004 | 0.997 | 0.647 | 0.870 | 0.851 | 0.012 |
| hex: http/css-16kx64 | 2097280 | 34279.7 ± 0.3% | 0.053 | 1.007 | 0.686 | 1.007 | 0.469 | 1.005 | 1.008 | 0.474 | 0.800 | 0.800 | 0.006 |
| hex: http/css-1m | 524290 | 45025.6 ± 2.6% | 0.040 | 1.002 | 0.633 | 1.002 | 0.396 | 0.997 | 1.006 | 0.396 | 0.748 | 0.749 | 0.005 |
| hex: shuffled/dickens-1m | 524290 | 40664.9 ± 1.5% | 0.045 | 1.005 | 0.674 | 1.007 | 0.421 | 1.002 | 1.007 | 0.422 | 0.829 | 0.829 | 0.005 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1727.7 ± 4.1% | 0.429 | 1.005 | 0.978 | 1.011 | 1.015 | 0.274 | 1.015 | 0.510 | 0.907 | 0.096 | 1.036 |
| qlog records, JSON text sequence | 1467503 | 1639.9 ± 2.6% | 0.638 | 0.974 | 0.989 | 1.022 | 0.997 | 0.238 | 0.992 | 0.438 | 0.878 | 0.107 | 1.047 |
| messages: 11 string members | 1025025 | 1307.2 ± 0.2% | 0.500 | 0.962 | 0.982 | 0.993 | 0.974 | 0.386 | 0.974 | 0.666 | 0.949 | 0.123 | 0.995 |
| messages: 50 nested objects | 1121600 | 1952.6 ± 0.3% | 0.589 | 0.976 | 0.964 | 0.989 | 0.971 | 0.247 | 0.971 | 0.439 | 0.859 | 0.093 | 1.007 |
| string: silesia/dickens | 172528 | 13016.0 ± 0.9% | 0.017 | 0.529 | 0.358 | 0.522 | 0.542 | 0.120 | 0.550 | 1.001 | 1.003 | 0.017 | 1.028 |
| string: silesia/nci | 1075110 | 11138.0 ± 0.8% | 0.020 | 0.533 | 0.369 | 0.541 | 0.532 | 0.176 | 0.533 | 1.003 | 1.004 | 0.020 | 1.040 |
| string: silesia/reymont | 1075159 | 5304.3 ± 1.6% | 0.042 | 0.578 | 0.429 | 0.568 | 0.582 | 0.269 | 0.579 | 1.007 | 1.021 | 0.043 | 1.022 |
| string: silesia/samba | 97582 | 6300.8 ± 0.9% | 0.045 | 0.885 | 0.738 | 0.893 | 0.891 | 0.122 | 0.891 | 0.998 | 1.000 | 0.045 | 1.163 |
| string: silesia/webster | 1098490 | 6846.1 ± 1.4% | 0.033 | 0.589 | 0.407 | 0.564 | 0.593 | 0.160 | 0.589 | 0.992 | 1.005 | 0.032 | 1.018 |
| string: silesia/xml | 1090118 | 10330.0 ± 0.5% | 0.022 | 0.578 | 0.475 | 0.573 | 0.579 | 0.199 | 0.581 | 1.003 | 1.020 | 0.022 | 1.078 |
| string: canterbury/alice29.txt | 159425 | 12593.7 ± 1.0% | 0.018 | 0.443 | 0.360 | 0.423 | 0.464 | 0.093 | 0.477 | 1.000 | 1.005 | 0.018 | 1.057 |
| string: canterbury/asyoulik.txt | 132198 | 10536.5 ± 2.9% | 0.020 | 0.405 | 0.339 | 0.402 | 0.423 | 0.094 | 0.433 | 0.992 | 1.012 | 0.020 | 1.092 |
| string: canterbury/lcet10.txt | 441884 | 11910.8 ± 1.1% | 0.019 | 0.579 | 0.343 | 0.566 | 0.583 | 0.124 | 0.587 | 0.998 | 1.013 | 0.019 | 1.053 |
| string: canterbury/plrabn12.txt | 503330 | 8256.0 ± 2.3% | 0.027 | 0.656 | 0.528 | 0.660 | 0.658 | 0.170 | 0.661 | 1.003 | 1.012 | 0.027 | 1.091 |
| string: canterbury-large/E.coli | 1048578 | 28371.1 ± 1.8% | 0.063 | 1.003 | 1.005 | 0.820 | 1.003 | 0.548 | 1.005 | 1.003 | 1.006 | 0.008 | 1.003 |
| string: canterbury-large/bible.txt | 1055886 | 9299.8 ± 0.6% | 0.025 | 0.764 | 0.584 | 0.766 | 0.778 | 0.406 | 0.780 | 0.996 | 1.007 | 0.025 | 1.053 |
| string: canterbury-large/world192.txt | 1103121 | 6555.2 ± 0.9% | 0.034 | 0.592 | 0.417 | 0.564 | 0.600 | 0.153 | 0.601 | 0.994 | 1.008 | 0.034 | 0.989 |
| string: http/html-1m | 1058582 | 9922.5 ± 0.4% | 0.023 | 0.649 | 0.535 | 0.646 | 0.655 | 0.319 | 0.653 | 0.997 | 1.016 | 0.024 | 1.009 |
| string: http/json-1m | 1190272 | 8254.7 ± 1.3% | 0.025 | 0.188 | 0.163 | 0.188 | 0.188 | 0.075 | 0.188 | 0.997 | 0.995 | 0.025 | 1.015 |
| string: http/js-1m | 1144362 | 6466.0 ± 1.2% | 0.033 | 0.372 | 0.312 | 0.364 | 0.374 | 0.095 | 0.373 | 0.999 | 1.009 | 0.033 | 1.022 |
| string: http/css-1m | 1097820 | 8666.3 ± 1.3% | 0.025 | 0.371 | 0.301 | 0.358 | 0.374 | 0.132 | 0.371 | 1.002 | 1.006 | 0.025 | 1.042 |
| string: dickens as Cyrillic and CJK | 1883069 | 5402.3 ± 0.6% | 0.031 | 0.470 | 0.069 | 0.469 | 0.472 | 0.211 | 0.471 | 1.002 | 1.005 | 0.031 | 1.055 |
| hex: silesia/dickens | 524290 | 42566.3 ± 1.6% | 1.007 | 0.090 | 0.999 | 0.602 | 1.000 | 1.001 | 0.999 | 0.999 | 1.000 | 0.096 | 1.000 |
| hex: silesia/mozilla | 524290 | 43198.8 ± 0.6% | 1.005 | 0.089 | 0.988 | 0.597 | 0.990 | 0.985 | 0.994 | 0.993 | 0.992 | 0.092 | 0.994 |
| hex: silesia/mr | 524290 | 43018.5 ± 1.1% | 1.005 | 0.089 | 0.995 | 0.596 | 0.994 | 0.993 | 0.994 | 1.001 | 1.003 | 0.095 | 0.997 |
| hex: silesia/nci | 524290 | 43022.6 ± 1.2% | 1.003 | 0.089 | 0.998 | 0.596 | 0.999 | 0.998 | 0.999 | 0.998 | 0.998 | 0.095 | 0.996 |
| hex: silesia/ooffice | 524290 | 43376.7 ± 1.2% | 1.003 | 0.086 | 1.000 | 0.593 | 1.001 | 1.001 | 1.001 | 1.002 | 1.001 | 0.094 | 0.964 |
| hex: silesia/osdb | 524290 | 43395.3 ± 1.3% | 1.005 | 0.088 | 0.996 | 0.592 | 0.989 | 0.989 | 0.989 | 0.989 | 0.988 | 0.092 | 0.992 |
| hex: silesia/reymont | 524290 | 42892.3 ± 3.5% | 1.001 | 0.089 | 1.000 | 0.596 | 1.000 | 0.998 | 0.998 | 1.002 | 1.000 | 0.093 | 0.997 |
| hex: silesia/samba | 524290 | 43190.4 ± 1.6% | 0.999 | 0.089 | 0.997 | 0.593 | 0.998 | 0.994 | 0.996 | 0.995 | 0.992 | 0.092 | 0.993 |
| hex: silesia/sao | 524290 | 42890.3 ± 1.5% | 1.004 | 0.089 | 0.996 | 0.596 | 0.995 | 0.994 | 0.996 | 0.996 | 0.996 | 0.095 | 0.995 |
| hex: silesia/webster | 524290 | 44050.2 ± 0.7% | 0.997 | 0.087 | 0.994 | 0.584 | 0.993 | 0.995 | 0.995 | 0.994 | 0.995 | 0.090 | 0.995 |
| hex: silesia/x-ray | 524290 | 42964.2 ± 0.8% | 1.003 | 0.089 | 1.002 | 0.595 | 0.996 | 0.998 | 0.995 | 0.998 | 0.999 | 0.094 | 0.995 |
| hex: silesia/xml | 524290 | 42875.6 ± 2.4% | 1.000 | 0.089 | 1.004 | 0.596 | 1.000 | 0.999 | 1.006 | 1.003 | 1.005 | 0.094 | 1.004 |
| hex: canterbury/alice29.txt | 304180 | 42556.7 ± 0.4% | 1.000 | 0.090 | 1.004 | 0.604 | 1.003 | 1.008 | 1.004 | 1.010 | 1.003 | 0.095 | 1.006 |
| hex: canterbury/asyoulik.txt | 250360 | 42315.4 ± 1.0% | 1.003 | 0.090 | 0.998 | 0.605 | 0.997 | 0.996 | 0.997 | 0.998 | 0.999 | 0.096 | 0.999 |
| hex: canterbury/cp.html | 49208 | 41167.1 ± 1.0% | 1.000 | 0.093 | 0.999 | 0.603 | 1.005 | 0.996 | 1.004 | 0.997 | 0.997 | 0.099 | 1.006 |
| hex: canterbury/fields.c | 22302 | 41809.9 ± 1.1% | 0.998 | 0.091 | 0.998 | 0.599 | 1.001 | 0.987 | 1.003 | 0.997 | 1.008 | 0.099 | 1.004 |
| hex: canterbury/grammar.lsp | 7444 | 38924.6 ± 1.2% | 0.992 | 0.097 | 1.015 | 0.610 | 1.016 | 0.982 | 1.008 | 1.015 | 1.032 | 0.103 | 1.016 |
| hex: canterbury/kennedy.xls | 524290 | 43232.8 ± 1.2% | 0.998 | 0.088 | 0.995 | 0.590 | 0.996 | 0.992 | 0.999 | 0.992 | 0.990 | 0.093 | 0.997 |
| hex: canterbury/lcet10.txt | 524290 | 43379.5 ± 1.0% | 1.004 | 0.089 | 1.002 | 0.591 | 1.002 | 0.999 | 1.003 | 0.999 | 1.002 | 0.092 | 1.003 |
| hex: canterbury/plrabn12.txt | 524290 | 42145.6 ± 1.3% | 1.008 | 0.091 | 1.006 | 0.606 | 1.010 | 1.004 | 1.010 | 1.003 | 1.009 | 0.096 | 1.009 |
| hex: canterbury/ptt5 | 524290 | 43337.8 ± 0.8% | 1.003 | 0.088 | 1.000 | 0.588 | 0.998 | 0.992 | 0.990 | 0.997 | 0.996 | 0.094 | 0.991 |
| hex: canterbury/sum | 76482 | 42425.3 ± 1.3% | 1.002 | 0.090 | 1.007 | 0.596 | 1.004 | 1.002 | 1.001 | 1.007 | 1.007 | 0.097 | 1.001 |
| hex: canterbury/xargs.1 | 8456 | 40043.3 ± 1.4% | 1.002 | 0.094 | 1.001 | 0.601 | 1.002 | 0.949 | 0.999 | 0.986 | 1.024 | 0.102 | 1.004 |
| hex: canterbury-large/E.coli | 524290 | 43026.7 ± 3.5% | 1.003 | 0.089 | 1.004 | 0.595 | 1.002 | 1.007 | 0.997 | 1.007 | 1.003 | 0.094 | 1.006 |
| hex: canterbury-large/bible.txt | 524290 | 43194.5 ± 2.5% | 0.999 | 0.089 | 1.002 | 0.591 | 0.994 | 0.997 | 0.993 | 0.998 | 0.992 | 0.094 | 0.999 |
| hex: canterbury-large/world192.txt | 524290 | 42859.7 ± 0.7% | 1.004 | 0.089 | 0.999 | 0.595 | 1.002 | 1.001 | 1.003 | 1.001 | 0.999 | 0.094 | 1.003 |
| hex: http/html-1kx1024 | 2099200 | 20789.0 ± 0.9% | 1.005 | 0.175 | 1.004 | 0.954 | 1.003 | 1.000 | 1.003 | 1.007 | 1.007 | 0.183 | 1.005 |
| hex: http/html-16kx64 | 2097280 | 21345.2 ± 1.1% | 1.003 | 0.177 | 1.003 | 0.979 | 1.002 | 1.003 | 1.002 | 1.003 | 1.004 | 0.192 | 1.003 |
| hex: http/html-1m | 524290 | 43554.7 ± 1.0% | 1.000 | 0.088 | 0.996 | 0.590 | 0.995 | 0.998 | 0.999 | 0.999 | 0.999 | 0.091 | 0.997 |
| hex: http/json-1kx1024 | 2099200 | 20191.3 ± 5.5% | 1.004 | 0.182 | 1.006 | 0.977 | 1.006 | 1.009 | 1.007 | 1.007 | 1.011 | 0.190 | 1.009 |
| hex: http/json-16kx64 | 2097280 | 21556.0 ± 2.2% | 1.002 | 0.176 | 1.004 | 0.974 | 1.004 | 1.005 | 1.003 | 1.006 | 1.005 | 0.190 | 1.005 |
| hex: http/json-1m | 524290 | 43023.4 ± 1.8% | 1.000 | 0.089 | 0.998 | 0.595 | 1.002 | 0.998 | 0.996 | 1.001 | 1.001 | 0.093 | 1.001 |
| hex: http/js-1kx1024 | 2099200 | 20124.1 ± 0.3% | 0.999 | 0.181 | 1.001 | 0.975 | 1.001 | 1.003 | 1.004 | 1.002 | 1.005 | 0.189 | 1.004 |
| hex: http/js-16kx64 | 2097280 | 21171.1 ± 0.7% | 1.005 | 0.178 | 1.005 | 0.986 | 1.005 | 1.006 | 1.007 | 1.004 | 1.006 | 0.193 | 1.007 |
| hex: http/js-1m | 524290 | 42973.8 ± 1.0% | 1.005 | 0.089 | 0.997 | 0.596 | 1.002 | 1.002 | 1.000 | 0.997 | 0.999 | 0.094 | 1.001 |
| hex: http/css-1kx1024 | 2099200 | 20528.0 ± 1.0% | 1.006 | 0.178 | 1.006 | 0.959 | 1.005 | 1.004 | 1.004 | 1.007 | 1.011 | 0.185 | 1.008 |
| hex: http/css-16kx64 | 2097280 | 21695.8 ± 0.6% | 1.002 | 0.175 | 1.003 | 0.970 | 1.006 | 1.007 | 1.005 | 1.007 | 1.005 | 0.188 | 1.006 |
| hex: http/css-1m | 524290 | 42759.3 ± 4.0% | 1.009 | 0.089 | 1.008 | 0.598 | 1.011 | 1.004 | 1.006 | 1.008 | 1.007 | 0.095 | 1.007 |
| hex: shuffled/dickens-1m | 524290 | 43271.1 ± 0.6% | 1.004 | 0.088 | 0.992 | 0.592 | 0.995 | 0.991 | 0.990 | 0.992 | 0.988 | 0.093 | 0.987 |

## Losses

Each workload where a claim's path ran slower than the path it replaces by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding: J7 wide vectors off runs at 1.067 of all on.
- CLDR supplemental, 34 texts, decoding: J8 decoder fast path off runs at 1.066 of all on.
- CLDR supplemental, 34 texts, decoding: J12 decoder escape words off runs at 1.072 of all on.
- CLDR supplemental, 34 texts, decoding: J13 decoder escape blocks off runs at 1.070 of all on.
- qlog records, JSON text sequence, decoding: J5 UTF-8 vectors off runs at 1.060 of all on.
- qlog records, JSON text sequence, decoding: J7 wide vectors off runs at 1.068 of all on.
- qlog records, JSON text sequence, decoding: J8 decoder fast path off runs at 1.064 of all on.
- qlog records, JSON text sequence, decoding: J12 decoder escape words off runs at 1.067 of all on.
- qlog records, JSON text sequence, decoding: J13 decoder escape blocks off runs at 1.063 of all on.
- messages: 50 nested objects, decoding: J5 UTF-8 vectors off runs at 1.082 of all on.
- messages: 50 nested objects, decoding: J7 wide vectors off runs at 1.083 of all on.
- messages: 50 nested objects, decoding: J8 decoder fast path off runs at 1.085 of all on.
- messages: 50 nested objects, decoding: J12 decoder escape words off runs at 1.094 of all on.
- messages: 50 nested objects, decoding: J13 decoder escape blocks off runs at 1.088 of all on.
- string: silesia/dickens, decoding: J7 wide vectors off runs at 1.096 of all on.
- string: silesia/dickens, decoding: J8 decoder fast path off runs at 1.102 of all on.
- string: silesia/dickens, decoding: J13 decoder escape blocks off runs at 1.112 of all on.
- string: silesia/samba, decoding: J7 wide vectors off runs at 1.069 of all on.
- string: silesia/samba, decoding: J8 decoder fast path off runs at 1.069 of all on.
- string: silesia/samba, decoding: J13 decoder escape blocks off runs at 1.070 of all on.
- string: canterbury/alice29.txt, decoding: J7 wide vectors off runs at 1.061 of all on.
- string: canterbury/alice29.txt, decoding: J8 decoder fast path off runs at 1.128 of all on.
- string: canterbury/alice29.txt, decoding: J13 decoder escape blocks off runs at 1.172 of all on.
- string: canterbury/asyoulik.txt, decoding: J7 wide vectors off runs at 1.125 of all on.
- string: canterbury/asyoulik.txt, decoding: J8 decoder fast path off runs at 1.121 of all on.
- string: canterbury/asyoulik.txt, decoding: J13 decoder escape blocks off runs at 1.132 of all on.
- string: canterbury/lcet10.txt, decoding: J7 wide vectors off runs at 1.103 of all on.
- string: canterbury/lcet10.txt, decoding: J8 decoder fast path off runs at 1.105 of all on.
- string: canterbury/lcet10.txt, decoding: J13 decoder escape blocks off runs at 1.115 of all on.

## UTF-8 validation against simdutf

stdx's `is_utf8`, the check the loops apply to every string's octets, run alone over each string workload's octets at the width the host's features pick (16 lanes on aarch64, AVX2's 32 or AVX-512's 64 on x86-64, decision 39), beside simdutf 9.3.3's `validate_utf8` in the same run; on a host with AVX-512, again with AVX2 alone. Each ratio is stdx's throughput over the other's. simdutf picks its kernel at run time. Before timing, every copy of the check and simdutf judged 20000 seeded buffers and each workload, whole and changed, alike.

| Workload | Octets | stdx, MB/s | simdutf, MB/s | stdx / simdutf | stdx with AVX2 alone, MB/s | stdx / stdx with AVX2 alone |
|---|---|---|---|---|---|---|
| string: silesia/dickens | 166668 | 162785.6 ± 1.2% | 118987.1 ± 4.6% | 1.368 | 98693.9 ± 0.6% | 1.649 |
| string: silesia/nci | 1048576 | 165478.2 ± 7.6% | 121292.3 ± 2.9% | 1.364 | 99637.6 ± 0.9% | 1.661 |
| string: silesia/reymont | 1048576 | 165549.4 ± 1.2% | 120855.5 ± 1.3% | 1.370 | 100137.2 ± 0.9% | 1.653 |
| string: silesia/samba | 65546 | 160414.5 ± 1.1% | 118908.1 ± 0.8% | 1.349 | 98175.1 ± 0.6% | 1.634 |
| string: silesia/webster | 1048576 | 164953.3 ± 3.0% | 120711.7 ± 1.3% | 1.367 | 100683.3 ± 0.8% | 1.638 |
| string: silesia/xml | 1048576 | 165239.4 ± 1.8% | 121472.7 ± 1.0% | 1.360 | 100278.7 ± 1.0% | 1.648 |
| string: canterbury/alice29.txt | 152089 | 164755.2 ± 1.3% | 120470.1 ± 1.5% | 1.368 | 99706.2 ± 0.5% | 1.652 |
| string: canterbury/asyoulik.txt | 125179 | 163417.0 ± 1.9% | 120405.2 ± 0.7% | 1.357 | 100272.2 ± 0.4% | 1.630 |
| string: canterbury/lcet10.txt | 426754 | 164717.8 ± 1.3% | 120984.2 ± 0.8% | 1.361 | 99963.5 ± 1.4% | 1.648 |
| string: canterbury/plrabn12.txt | 481861 | 165966.3 ± 1.5% | 120884.2 ± 1.2% | 1.373 | 100727.3 ± 0.4% | 1.648 |
| string: canterbury-large/E.coli | 1048576 | 165882.0 ± 2.0% | 121597.8 ± 0.4% | 1.364 | 99931.6 ± 1.5% | 1.660 |
| string: canterbury-large/bible.txt | 1048576 | 165300.7 ± 2.8% | 121052.5 ± 1.3% | 1.366 | 100677.8 ± 1.2% | 1.642 |
| string: canterbury-large/world192.txt | 1048576 | 164566.5 ± 1.9% | 121219.6 ± 1.4% | 1.358 | 99941.4 ± 1.2% | 1.647 |
| string: http/html-1m | 1048576 | 146219.1 ± 1.4% | 110706.8 ± 1.4% | 1.321 | 93276.0 ± 1.5% | 1.568 |
| string: http/json-1m | 1048576 | 121594.1 ± 0.5% | 106150.3 ± 0.5% | 1.145 | 82522.0 ± 0.8% | 1.473 |
| string: http/js-1m | 1048576 | 163377.7 ± 2.2% | 120637.4 ± 1.4% | 1.354 | 98975.8 ± 0.4% | 1.651 |
| string: http/css-1m | 1048576 | 164847.4 ± 2.2% | 121418.6 ± 1.1% | 1.358 | 99867.5 ± 0.7% | 1.651 |
| string: dickens as Cyrillic and CJK | 1847045 | 23348.5 ± 0.9% | 20489.6 ± 1.1% | 1.140 | 14639.8 ± 0.6% | 1.595 |

## Losses to simdutf

None.

## UTF-8 validation by the buffer's offset from a 64-octet line

| Buffer | Octets | Offset | stdx, MB/s | simdutf, MB/s | stdx / simdutf | stdx with AVX2 alone, MB/s | stdx / stdx with AVX2 alone |
|---|---|---|---|---|---|---|---|
| string: canterbury-large/bible.txt | 1048576 | 0 | 165585.2 ± 2.3% | 121160.9 ± 3.3% | 1.367 | 100204.1 ± 1.0% | 1.652 |
| string: canterbury-large/bible.txt | 1048576 | 1 | 164718.5 ± 2.9% | 120914.1 ± 1.3% | 1.362 | 99798.2 ± 0.9% | 1.651 |
| string: canterbury-large/bible.txt | 1048576 | 8 | 166636.4 ± 2.1% | 120907.2 ± 1.0% | 1.378 | 99674.9 ± 0.8% | 1.672 |
| string: canterbury-large/bible.txt | 1048576 | 16 | 167642.1 ± 0.8% | 121561.6 ± 0.2% | 1.379 | 100358.9 ± 0.6% | 1.670 |
| string: canterbury-large/bible.txt | 1048576 | 32 | 168121.7 ± 0.9% | 121975.9 ± 1.2% | 1.378 | 100828.0 ± 0.4% | 1.667 |
| string: canterbury-large/bible.txt | 1048576 | 48 | 169022.3 ± 1.3% | 122167.5 ± 0.6% | 1.384 | 101546.2 ± 0.3% | 1.664 |
| string: dickens as Cyrillic and CJK | 1048576 | 0 | 24320.8 ± 0.1% | 21718.9 ± 0.2% | 1.120 | 15327.5 ± 0.3% | 1.587 |
| string: dickens as Cyrillic and CJK | 1048576 | 1 | 24304.5 ± 0.3% | 21683.3 ± 0.8% | 1.121 | 15308.5 ± 0.4% | 1.588 |
| string: dickens as Cyrillic and CJK | 1048576 | 8 | 24327.3 ± 1.6% | 21718.3 ± 0.2% | 1.120 | 15329.7 ± 0.1% | 1.587 |
| string: dickens as Cyrillic and CJK | 1048576 | 16 | 24322.2 ± 1.4% | 21714.7 ± 1.0% | 1.120 | 15238.7 ± 0.9% | 1.596 |
| string: dickens as Cyrillic and CJK | 1048576 | 32 | 24292.1 ± 2.6% | 21728.8 ± 0.6% | 1.118 | 15306.4 ± 0.6% | 1.587 |
| string: dickens as Cyrillic and CJK | 1048576 | 48 | 24339.9 ± 0.2% | 21743.4 ± 0.3% | 1.119 | 15351.6 ± 0.1% | 1.586 |

## Messages against serde_json's typed code

stdx's encoder a token a call through `TextWriter`'s methods, a member's name and its value in one `member_*` call, beside serde_json 1.0.154 writing the same messages from Rust types, as code of the form serde's derive generates writes them. Octets are the ones written.

| Workload | Octets | TextWriter's methods, MB/s | serde_json typed, MB/s | stdx / serde_json typed |
|---|---|---|---|---|
| messages: 11 string members | 1025025 | 1211.4 ± 2.8% | 778.0 ± 0.4% | 1.557 |
| messages: 50 nested objects | 1121600 | 1666.1 ± 0.6% | 974.0 ± 0.9% | 1.711 |

## Against the baselines

stdx with every claim on, timed beside simdjson 5.1.1, yyjson 0.13.0, Zig 0.16.0's std.json, serde_json 1.0.154 and Go's encoding/json/jsontext in the same run. Each ratio is stdx's throughput over the baseline's; below 1, the baseline is faster. stdx is built for the architecture's baseline CPU in ReleaseSafe. Each baseline is built for the same CPU, the C, C++ and Zig ones in ReleaseFast (decision 75), and simdjson picks its kernel at run time. Decoding visits every value; encoding writes each text from its tokens.

## Decoding against the baselines

Octets are the text's. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1368.1 ± 1.4% | 1496.1 ± 2.7% | 1099.2 ± 0.7% | 390.3 ± 0.9% | 652.6 ± 1.0% | 362.3 ± 1.8% | 0.914 | 1.245 | 3.505 | 2.096 | 3.777 |
| qlog records, JSON text sequence | 1467503 | 1083.5 ± 0.4% | 1224.7 ± 2.0% | 1094.3 ± 0.5% | 325.8 ± 0.9% | 725.7 ± 1.2% | 315.1 ± 0.9% | 0.885 | 0.990 | 3.326 | 1.493 | 3.438 |
| messages: 11 string members | 1025025 | 1051.9 ± 1.0% | 1967.1 ± 2.4% | 769.8 ± 1.2% | 335.0 ± 0.8% | 495.4 ± 0.8% | 303.5 ± 1.0% | 0.535 | 1.366 | 3.140 | 2.123 | 3.466 |
| messages: 50 nested objects | 1121600 | 1337.9 ± 0.8% | 1735.5 ± 0.9% | 1431.8 ± 0.9% | 426.6 ± 0.9% | 902.2 ± 0.9% | 419.5 ± 0.8% | 0.771 | 0.934 | 3.136 | 1.483 | 3.189 |
| string: silesia/dickens | 172528 | 6663.6 ± 1.1% | 3420.0 ± 3.5% | 2829.2 ± 1.7% | 315.5 ± 0.8% | 3338.8 ± 1.2% | 567.1 ± 1.8% | 1.948 | 2.355 | 21.120 | 1.996 | 11.751 |
| string: silesia/nci | 1075110 | 5394.9 ± 0.7% | 3889.1 ± 0.6% | 2979.8 ± 0.8% | 652.4 ± 0.9% | 3673.8 ± 0.7% | 574.3 ± 0.9% | 1.387 | 1.810 | 8.270 | 1.468 | 9.393 |
| string: silesia/reymont | 1075159 | 3481.8 ± 2.3% | 3374.6 ± 1.4% | 1985.8 ± 2.4% | 338.5 ± 0.4% | 2068.8 ± 0.4% | 490.6 ± 1.7% | 1.032 | 1.753 | 10.285 | 1.683 | 7.097 |
| string: silesia/samba | 97582 | 3938.6 ± 0.8% | 3766.0 ± 0.7% | 3101.7 ± 0.3% | 325.7 ± 1.1% | 2044.7 ± 0.7% | 416.5 ± 1.4% | 1.046 | 1.270 | 12.094 | 1.926 | 9.456 |
| string: silesia/webster | 1098490 | 4376.5 ± 1.0% | 2418.4 ± 0.6% | 1729.3 ± 0.8% | 306.6 ± 1.4% | 2100.2 ± 1.1% | 461.3 ± 2.5% | 1.810 | 2.531 | 14.274 | 2.084 | 9.488 |
| string: silesia/xml | 1090118 | 6056.3 ± 0.5% | 5008.0 ± 0.9% | 2471.6 ± 1.1% | 505.3 ± 1.3% | 3348.7 ± 0.7% | 538.2 ± 1.9% | 1.209 | 2.450 | 11.985 | 1.809 | 11.253 |
| string: canterbury/alice29.txt | 159425 | 5755.2 ± 0.9% | 2748.3 ± 1.2% | 2881.6 ± 1.8% | 298.6 ± 1.3% | 3021.7 ± 1.4% | 513.8 ± 2.1% | 2.094 | 1.997 | 19.271 | 1.905 | 11.202 |
| string: canterbury/asyoulik.txt | 132198 | 4287.8 ± 0.9% | 2624.6 ± 2.0% | 2685.4 ± 1.0% | 305.8 ± 1.3% | 2452.9 ± 1.0% | 451.8 ± 1.4% | 1.634 | 1.597 | 14.024 | 1.748 | 9.491 |
| string: canterbury/lcet10.txt | 441884 | 6627.9 ± 1.1% | 3251.5 ± 1.0% | 2350.5 ± 1.2% | 345.5 ± 2.0% | 3002.1 ± 1.6% | 556.7 ± 3.3% | 2.038 | 2.820 | 19.183 | 2.208 | 11.905 |
| string: canterbury/plrabn12.txt | 503330 | 5444.2 ± 0.3% | 3136.3 ± 1.1% | 1842.6 ± 2.3% | 320.4 ± 0.7% | 2859.7 ± 0.4% | 527.0 ± 1.2% | 1.736 | 2.955 | 16.991 | 1.904 | 10.331 |
| string: canterbury-large/E.coli | 1048578 | 28439.3 ± 1.2% | 12881.3 ± 0.4% | 3337.2 ± 0.9% | 1270.7 ± 0.6% | 8487.7 ± 0.6% | 936.6 ± 3.7% | 2.208 | 8.522 | 22.381 | 3.351 | 30.365 |
| string: canterbury-large/bible.txt | 1055886 | 8443.4 ± 0.5% | 5225.4 ± 0.9% | 2782.6 ± 0.5% | 356.8 ± 0.8% | 3844.7 ± 0.4% | 616.2 ± 2.4% | 1.616 | 3.034 | 23.661 | 2.196 | 13.702 |
| string: canterbury-large/world192.txt | 1103121 | 4118.5 ± 0.9% | 2287.3 ± 0.4% | 1784.4 ± 0.4% | 326.3 ± 0.8% | 2167.7 ± 0.6% | 461.8 ± 1.5% | 1.801 | 2.308 | 12.624 | 1.900 | 8.918 |
| string: http/html-1m | 1058582 | 9052.8 ± 2.8% | 4700.3 ± 2.1% | 2683.8 ± 2.3% | 426.1 ± 0.5% | 3534.9 ± 0.9% | 589.8 ± 3.6% | 1.926 | 3.373 | 21.246 | 2.561 | 15.350 |
| string: http/json-1m | 1190272 | 3242.7 ± 1.2% | 1241.9 ± 3.2% | 2119.1 ± 0.7% | 468.0 ± 1.3% | 1366.3 ± 1.0% | 432.6 ± 1.6% | 2.611 | 1.530 | 6.929 | 2.373 | 7.497 |
| string: http/js-1m | 1144362 | 2846.5 ± 0.2% | 1596.9 ± 0.8% | 1321.4 ± 0.6% | 326.5 ± 1.0% | 1403.4 ± 0.9% | 375.6 ± 2.3% | 1.782 | 2.154 | 8.717 | 2.028 | 7.578 |
| string: http/css-1m | 1097820 | 3281.5 ± 0.8% | 2879.2 ± 0.3% | 2284.5 ± 0.5% | 457.6 ± 2.6% | 2103.0 ± 0.8% | 436.6 ± 2.7% | 1.140 | 1.436 | 7.171 | 1.560 | 7.516 |
| string: dickens as Cyrillic and CJK | 1883069 | 5788.2 ± 0.9% | 3055.5 ± 1.9% | 683.4 ± 0.3% | 376.2 ± 1.1% | 494.2 ± 0.9% | 162.0 ± 3.3% | 1.894 | 8.469 | 15.388 | 11.711 | 35.739 |
| string: dickens as Cyrillic and CJK, as \u escapes | 5075485 | 1187.3 ± 3.6% | 1235.4 ± 2.1% | 1101.7 ± 0.4% | 262.3 ± 0.8% | 466.7 ± 0.7% | 222.4 ± 3.0% | 0.961 | 1.078 | 4.526 | 2.544 | 5.338 |
| hex: silesia/dickens | 524290 | 45492.1 ± 1.3% | 14992.3 ± 1.1% | 3544.6 ± 3.4% | 476.4 ± 0.9% | 8919.4 ± 0.6% | 1128.5 ± 4.9% | 3.034 | 12.834 | 95.483 | 5.100 | 40.313 |
| hex: silesia/mozilla | 524290 | 45802.5 ± 2.3% | 14986.6 ± 1.2% | 3479.3 ± 1.3% | 425.9 ± 1.3% | 8891.2 ± 1.2% | 1128.0 ± 1.3% | 3.056 | 13.164 | 107.536 | 5.151 | 40.604 |
| hex: silesia/mr | 524290 | 45356.1 ± 1.5% | 14946.5 ± 0.5% | 3468.2 ± 3.9% | 643.7 ± 0.5% | 8871.4 ± 0.4% | 1128.3 ± 1.5% | 3.035 | 13.078 | 70.463 | 5.113 | 40.200 |
| hex: silesia/nci | 524290 | 44938.2 ± 1.1% | 14919.5 ± 0.7% | 3531.4 ± 0.3% | 754.7 ± 1.7% | 8895.5 ± 4.6% | 1129.5 ± 0.6% | 3.012 | 12.725 | 59.543 | 5.052 | 39.784 |
| hex: silesia/ooffice | 524290 | 45780.4 ± 2.4% | 14942.6 ± 1.0% | 3485.3 ± 0.8% | 342.7 ± 0.6% | 8898.7 ± 0.8% | 1131.0 ± 1.6% | 3.064 | 13.135 | 133.598 | 5.145 | 40.479 |
| hex: silesia/osdb | 524290 | 45937.3 ± 0.5% | 15035.1 ± 0.8% | 3493.3 ± 0.6% | 454.3 ± 1.5% | 8911.4 ± 0.8% | 1134.5 ± 0.7% | 3.055 | 13.150 | 101.123 | 5.155 | 40.491 |
| hex: silesia/reymont | 524290 | 45891.3 ± 1.1% | 14993.0 ± 0.7% | 3524.8 ± 0.8% | 492.0 ± 0.8% | 8898.5 ± 0.6% | 1128.4 ± 1.8% | 3.061 | 13.019 | 93.282 | 5.157 | 40.670 |
| hex: silesia/samba | 524290 | 45594.9 ± 0.4% | 14918.9 ± 0.9% | 3478.6 ± 1.1% | 362.3 ± 1.4% | 8927.9 ± 0.9% | 1134.3 ± 1.3% | 3.056 | 13.107 | 125.850 | 5.107 | 40.196 |
| hex: silesia/sao | 524290 | 35793.9 ± 1.3% | 14960.3 ± 1.1% | 3474.9 ± 0.8% | 277.4 ± 0.9% | 8888.1 ± 1.0% | 1125.0 ± 1.2% | 2.393 | 10.301 | 129.012 | 4.027 | 31.816 |
| hex: silesia/webster | 524290 | 44708.2 ± 1.0% | 14953.8 ± 0.2% | 3538.0 ± 0.9% | 449.8 ± 1.1% | 8932.2 ± 1.2% | 1124.7 ± 0.8% | 2.990 | 12.636 | 99.397 | 5.005 | 39.752 |
| hex: silesia/x-ray | 524290 | 44647.2 ± 0.7% | 15040.0 ± 1.0% | 3494.8 ± 0.8% | 426.0 ± 0.8% | 8881.3 ± 1.0% | 1121.4 ± 0.9% | 2.969 | 12.775 | 104.797 | 5.027 | 39.815 |
| hex: silesia/xml | 524290 | 46015.8 ± 0.9% | 15008.9 ± 0.6% | 3561.5 ± 0.7% | 708.5 ± 1.6% | 8903.9 ± 5.7% | 1125.2 ± 0.7% | 3.066 | 12.920 | 64.952 | 5.168 | 40.894 |
| hex: canterbury/alice29.txt | 304180 | 45537.3 ± 5.0% | 14035.9 ± 0.7% | 3542.3 ± 1.2% | 481.5 ± 1.2% | 8895.2 ± 1.2% | 1117.1 ± 2.8% | 3.244 | 12.855 | 94.584 | 5.119 | 40.764 |
| hex: canterbury/asyoulik.txt | 250360 | 44713.4 ± 1.4% | 14906.4 ± 1.1% | 3491.5 ± 1.2% | 470.1 ± 1.2% | 8967.1 ± 1.1% | 1130.7 ± 1.1% | 3.000 | 12.806 | 95.105 | 4.986 | 39.546 |
| hex: canterbury/cp.html | 49208 | 43737.7 ± 1.0% | 14414.1 ± 1.5% | 3574.3 ± 2.4% | 499.9 ± 0.6% | 9337.3 ± 0.2% | 1115.8 ± 1.6% | 3.034 | 12.237 | 87.496 | 4.684 | 39.197 |
| hex: canterbury/fields.c | 22302 | 51147.2 ± 3.5% | 17271.3 ± 0.4% | 3660.8 ± 1.4% | 526.4 ± 1.4% | 9306.0 ± 1.0% | 1083.6 ± 1.0% | 2.961 | 13.972 | 97.156 | 5.496 | 47.200 |
| hex: canterbury/grammar.lsp | 7444 | 43981.3 ± 3.1% | 17201.5 ± 5.8% | 3596.5 ± 1.5% | 693.8 ± 1.4% | 8955.8 ± 1.6% | 1031.6 ± 1.5% | 2.557 | 12.229 | 63.394 | 4.911 | 42.634 |
| hex: canterbury/kennedy.xls | 524290 | 44668.1 ± 0.6% | 15009.1 ± 3.4% | 3565.9 ± 0.5% | 756.7 ± 0.5% | 8972.1 ± 0.9% | 1053.8 ± 4.0% | 2.976 | 12.526 | 59.034 | 4.979 | 42.389 |
| hex: canterbury/lcet10.txt | 524290 | 47446.5 ± 0.3% | 15076.2 ± 0.4% | 3574.6 ± 0.2% | 486.7 ± 0.5% | 8982.9 ± 0.2% | 1097.3 ± 1.6% | 3.147 | 13.273 | 97.486 | 5.282 | 43.240 |
| hex: canterbury/plrabn12.txt | 524290 | 44701.3 ± 0.7% | 15042.9 ± 0.7% | 3569.7 ± 1.0% | 466.9 ± 0.9% | 8932.9 ± 1.2% | 1080.7 ± 2.4% | 2.972 | 12.523 | 95.745 | 5.004 | 41.362 |
| hex: canterbury/ptt5 | 524290 | 44827.6 ± 2.8% | 14990.5 ± 1.1% | 3466.7 ± 0.5% | 659.7 ± 1.2% | 8891.7 ± 0.4% | 1089.0 ± 3.2% | 2.990 | 12.931 | 67.952 | 5.042 | 41.164 |
| hex: canterbury/sum | 76482 | 45398.1 ± 1.6% | 15239.2 ± 0.6% | 3551.9 ± 1.2% | 571.5 ± 1.1% | 8917.8 ± 1.0% | 1098.3 ± 3.5% | 2.979 | 12.781 | 79.432 | 5.091 | 41.335 |
| hex: canterbury/xargs.1 | 8456 | 45991.1 ± 1.1% | 17300.3 ± 0.4% | 3547.8 ± 0.4% | 680.9 ± 2.2% | 8974.6 ± 0.6% | 1091.0 ± 1.3% | 2.658 | 12.963 | 67.546 | 5.125 | 42.153 |
| hex: canterbury-large/E.coli | 524290 | 46719.6 ± 1.0% | 14970.7 ± 0.9% | 3472.2 ± 3.3% | 957.5 ± 0.6% | 8896.5 ± 0.2% | 1100.0 ± 6.6% | 3.121 | 13.456 | 48.794 | 5.251 | 42.474 |
| hex: canterbury-large/bible.txt | 524290 | 45004.4 ± 1.3% | 14964.4 ± 3.3% | 3468.5 ± 0.8% | 497.6 ± 1.1% | 8880.6 ± 0.7% | 1102.5 ± 1.8% | 3.007 | 12.975 | 90.435 | 5.068 | 40.820 |
| hex: canterbury-large/world192.txt | 524290 | 45217.2 ± 1.1% | 14971.4 ± 0.3% | 3537.7 ± 3.2% | 460.7 ± 0.3% | 8907.4 ± 0.4% | 1107.5 ± 5.4% | 3.020 | 12.782 | 98.141 | 5.076 | 40.827 |
| hex: http/html-1kx1024 | 2099200 | 16557.7 ± 3.9% | 11981.0 ± 0.4% | 3096.6 ± 0.4% | 490.4 ± 3.7% | 7645.0 ± 1.0% | 940.0 ± 1.3% | 1.382 | 5.347 | 33.765 | 2.166 | 17.615 |
| hex: http/html-16kx64 | 2097280 | 33289.2 ± 0.8% | 13896.0 ± 1.4% | 3357.6 ± 0.8% | 498.5 ± 1.3% | 8450.8 ± 0.7% | 1062.1 ± 4.0% | 2.396 | 9.915 | 66.782 | 3.939 | 31.342 |
| hex: http/html-1m | 524290 | 45836.5 ± 0.6% | 14978.0 ± 2.8% | 3466.4 ± 0.7% | 497.8 ± 1.4% | 8895.3 ± 0.6% | 1103.5 ± 1.8% | 3.060 | 13.223 | 92.077 | 5.153 | 41.536 |
| hex: http/json-1kx1024 | 2099200 | 16852.3 ± 1.3% | 11850.0 ± 12.2% | 3109.5 ± 0.7% | 654.8 ± 0.3% | 7661.4 ± 3.0% | 945.3 ± 3.1% | 1.422 | 5.420 | 25.738 | 2.200 | 17.828 |
| hex: http/json-16kx64 | 2097280 | 33356.8 ± 1.3% | 13765.4 ± 0.5% | 3364.1 ± 0.6% | 665.9 ± 0.7% | 8291.1 ± 1.2% | 1045.7 ± 3.3% | 2.423 | 9.916 | 50.096 | 4.023 | 31.898 |
| hex: http/json-1m | 524290 | 48302.6 ± 3.4% | 14963.7 ± 1.1% | 3545.5 ± 0.5% | 696.1 ± 0.5% | 8901.4 ± 4.6% | 1105.8 ± 3.1% | 3.228 | 13.624 | 69.394 | 5.426 | 43.682 |
| hex: http/js-1kx1024 | 2099200 | 16907.0 ± 1.0% | 12393.5 ± 3.5% | 3120.7 ± 1.2% | 477.2 ± 1.5% | 7632.5 ± 1.6% | 945.4 ± 2.6% | 1.364 | 5.418 | 35.431 | 2.215 | 17.883 |
| hex: http/js-16kx64 | 2097280 | 33250.1 ± 1.2% | 13748.1 ± 0.5% | 3350.8 ± 3.4% | 478.8 ± 1.2% | 8482.3 ± 1.0% | 1051.8 ± 3.2% | 2.419 | 9.923 | 69.450 | 3.920 | 31.613 |
| hex: http/js-1m | 524290 | 45944.0 ± 1.2% | 14933.4 ± 0.4% | 3534.0 ± 1.1% | 494.2 ± 1.5% | 8887.1 ± 1.1% | 1101.8 ± 1.6% | 3.077 | 13.001 | 92.960 | 5.170 | 41.698 |
| hex: http/css-1kx1024 | 2099200 | 17007.7 ± 0.3% | 11965.5 ± 6.5% | 3119.0 ± 0.4% | 550.7 ± 1.1% | 7685.7 ± 1.2% | 957.9 ± 2.6% | 1.421 | 5.453 | 30.883 | 2.213 | 17.755 |
| hex: http/css-16kx64 | 2097280 | 34279.7 ± 0.3% | 13798.3 ± 0.4% | 3351.3 ± 0.6% | 561.9 ± 0.9% | 8408.3 ± 2.1% | 1051.6 ± 4.3% | 2.484 | 10.229 | 61.009 | 4.077 | 32.598 |
| hex: http/css-1m | 524290 | 45025.6 ± 2.6% | 14954.3 ± 2.6% | 3545.1 ± 0.7% | 538.6 ± 4.7% | 8899.8 ± 0.6% | 1092.4 ± 2.6% | 3.011 | 12.701 | 83.599 | 5.059 | 41.216 |
| hex: shuffled/dickens-1m | 524290 | 40664.9 ± 1.5% | 14967.0 ± 0.6% | 3469.8 ± 0.8% | 474.3 ± 1.1% | 8902.4 ± 1.0% | 1096.4 ± 1.6% | 2.717 | 11.720 | 85.744 | 4.568 | 37.089 |

## Encoding against the baselines

Octets are the ones stdx writes. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1727.7 ± 4.1% | 1457.5 ± 1.5% | 1011.8 ± 1.0% | 464.5 ± 0.6% | 446.1 ± 3.1% | 499.2 ± 0.8% | 1.185 | 1.708 | 3.720 | 3.873 | 3.461 |
| qlog records, JSON text sequence | 1467503 | 1639.9 ± 2.6% | 1208.2 ± 2.7% | 918.0 ± 1.0% | 427.3 ± 1.4% | 532.8 ± 1.9% | 352.5 ± 1.5% | 1.357 | 1.786 | 3.838 | 3.078 | 4.652 |
| messages: 11 string members | 1025025 | 1307.2 ± 0.2% | 1089.7 ± 0.3% | 739.4 ± 1.1% | 408.7 ± 0.9% | 423.1 ± 0.6% | 430.4 ± 1.3% | 1.200 | 1.768 | 3.198 | 3.090 | 3.037 |
| messages: 50 nested objects | 1121600 | 1952.6 ± 0.3% | 1847.8 ± 0.5% | 1315.9 ± 1.1% | 590.7 ± 0.8% | 615.1 ± 1.3% | 507.4 ± 1.1% | 1.057 | 1.484 | 3.305 | 3.174 | 3.848 |
| string: silesia/dickens | 172528 | 13016.0 ± 0.9% | 3906.5 ± 0.9% | 3096.8 ± 0.9% | 330.7 ± 1.3% | 1712.9 ± 2.1% | 1180.4 ± 0.7% | 3.332 | 4.203 | 39.354 | 7.599 | 11.027 |
| string: silesia/nci | 1075110 | 11138.0 ± 0.8% | 4635.2 ± 0.5% | 3142.1 ± 1.2% | 908.9 ± 0.5% | 1905.4 ± 2.5% | 1197.1 ± 1.0% | 2.403 | 3.545 | 12.254 | 5.845 | 9.304 |
| string: silesia/reymont | 1075159 | 5304.3 ± 1.6% | 1841.7 ± 1.8% | 2006.9 ± 0.6% | 376.7 ± 1.2% | 1421.9 ± 1.2% | 1033.5 ± 1.4% | 2.880 | 2.643 | 14.081 | 3.730 | 5.132 |
| string: silesia/samba | 97582 | 6300.8 ± 0.9% | 2694.9 ± 1.7% | 4066.1 ± 1.0% | 347.8 ± 0.9% | 1327.1 ± 1.5% | 1173.5 ± 0.9% | 2.338 | 1.550 | 18.116 | 4.748 | 5.369 |
| string: silesia/webster | 1098490 | 6846.1 ± 1.4% | 1965.4 ± 1.7% | 1868.4 ± 0.8% | 348.9 ± 0.5% | 1404.4 ± 1.2% | 599.0 ± 0.7% | 3.483 | 3.664 | 19.619 | 4.875 | 11.429 |
| string: silesia/xml | 1090118 | 10330.0 ± 0.5% | 3153.2 ± 0.9% | 2624.0 ± 0.8% | 602.2 ± 0.7% | 1949.9 ± 0.3% | 952.2 ± 0.8% | 3.276 | 3.937 | 17.154 | 5.298 | 10.848 |
| string: canterbury/alice29.txt | 159425 | 12593.7 ± 1.0% | 2864.4 ± 1.6% | 3144.6 ± 2.1% | 316.7 ± 0.9% | 1546.2 ± 1.4% | 1090.4 ± 0.7% | 4.397 | 4.005 | 39.762 | 8.145 | 11.549 |
| string: canterbury/asyoulik.txt | 132198 | 10536.5 ± 2.9% | 2094.9 ± 1.1% | 3104.3 ± 0.5% | 316.4 ± 1.4% | 1369.0 ± 1.1% | 957.6 ± 0.6% | 5.029 | 3.394 | 33.303 | 7.697 | 11.003 |
| string: canterbury/lcet10.txt | 441884 | 11910.8 ± 1.1% | 3071.2 ± 1.0% | 2640.9 ± 0.4% | 366.6 ± 0.6% | 1672.6 ± 0.7% | 1191.9 ± 0.4% | 3.878 | 4.510 | 32.488 | 7.121 | 9.993 |
| string: canterbury/plrabn12.txt | 503330 | 8256.0 ± 2.3% | 2305.5 ± 0.7% | 2159.5 ± 0.7% | 347.5 ± 1.2% | 1648.2 ± 2.3% | 1114.7 ± 1.9% | 3.581 | 3.823 | 23.757 | 5.009 | 7.407 |
| string: canterbury-large/E.coli | 1048578 | 28371.1 ± 1.8% | 15944.3 ± 1.7% | 3454.9 ± 1.0% | 1688.3 ± 2.0% | 3143.0 ± 0.6% | 1390.9 ± 0.4% | 1.779 | 8.212 | 16.804 | 9.027 | 20.397 |
| string: canterbury-large/bible.txt | 1055886 | 9299.8 ± 0.6% | 4805.4 ± 1.9% | 3031.0 ± 0.9% | 401.3 ± 0.7% | 2132.8 ± 0.8% | 1473.2 ± 0.4% | 1.935 | 3.068 | 23.174 | 4.360 | 6.313 |
| string: canterbury-large/world192.txt | 1103121 | 6555.2 ± 0.9% | 1711.5 ± 0.5% | 2003.3 ± 0.7% | 346.8 ± 1.8% | 1385.7 ± 1.9% | 959.7 ± 4.7% | 3.830 | 3.272 | 18.901 | 4.731 | 6.830 |
| string: http/html-1m | 1058582 | 9922.5 ± 0.4% | 4303.6 ± 1.1% | 2913.4 ± 1.1% | 417.6 ± 1.6% | 2153.1 ± 3.8% | 845.5 ± 1.0% | 2.306 | 3.406 | 23.763 | 4.609 | 11.736 |
| string: http/json-1m | 1190272 | 8254.7 ± 1.3% | 1572.6 ± 1.2% | 1958.1 ± 1.2% | 556.1 ± 1.3% | 1191.3 ± 1.2% | 844.1 ± 1.3% | 5.249 | 4.216 | 14.845 | 6.929 | 9.779 |
| string: http/js-1m | 1144362 | 6466.0 ± 1.2% | 1110.7 ± 0.7% | 1528.5 ± 1.3% | 331.7 ± 1.0% | 1113.4 ± 1.9% | 755.4 ± 1.2% | 5.822 | 4.230 | 19.493 | 5.807 | 8.559 |
| string: http/css-1m | 1097820 | 8666.3 ± 1.3% | 1460.8 ± 1.3% | 2357.5 ± 1.6% | 509.1 ± 1.0% | 1268.3 ± 0.7% | 875.6 ± 1.8% | 5.933 | 3.676 | 17.023 | 6.833 | 9.897 |
| string: dickens as Cyrillic and CJK | 1883069 | 5402.3 ± 0.6% | 3601.4 ± 1.2% | 500.6 ± 1.1% | 245.7 ± 0.8% | 449.6 ± 0.4% | 354.0 ± 3.2% | 1.500 | 10.791 | 21.986 | 12.017 | 15.261 |
| hex: silesia/dickens | 524290 | 42566.3 ± 1.6% | 2553.6 ± 0.4% | 1506.4 ± 1.1% | 461.5 ± 1.1% | 1558.7 ± 1.4% | 1064.5 ± 6.2% | 16.669 | 28.258 | 92.227 | 27.310 | 39.986 |
| hex: silesia/mozilla | 524290 | 43198.8 ± 0.6% | 2558.2 ± 10.0% | 1499.7 ± 1.2% | 385.0 ± 2.0% | 1558.9 ± 0.6% | 1059.0 ± 1.3% | 16.887 | 28.805 | 112.210 | 27.711 | 40.790 |
| hex: silesia/mr | 524290 | 43018.5 ± 1.1% | 2534.8 ± 0.4% | 1497.0 ± 5.9% | 594.6 ± 0.9% | 1558.2 ± 1.0% | 1058.6 ± 1.1% | 16.971 | 28.737 | 72.355 | 27.607 | 40.637 |
| hex: silesia/nci | 524290 | 43022.6 ± 1.2% | 2542.2 ± 0.8% | 1501.3 ± 0.7% | 756.1 ± 0.9% | 1556.2 ± 0.9% | 1062.1 ± 0.8% | 16.924 | 28.657 | 56.904 | 27.645 | 40.505 |
| hex: silesia/ooffice | 524290 | 43376.7 ± 1.2% | 2572.8 ± 0.4% | 1514.7 ± 0.4% | 322.6 ± 1.8% | 1572.3 ± 0.2% | 1061.9 ± 0.3% | 16.860 | 28.637 | 134.450 | 27.588 | 40.849 |
| hex: silesia/osdb | 524290 | 43395.3 ± 1.3% | 2567.1 ± 0.4% | 1506.1 ± 0.9% | 429.3 ± 0.6% | 1560.4 ± 0.5% | 1062.5 ± 0.4% | 16.904 | 28.813 | 101.095 | 27.810 | 40.842 |
| hex: silesia/reymont | 524290 | 42892.3 ± 3.5% | 2563.5 ± 0.4% | 1503.6 ± 0.7% | 481.1 ± 0.5% | 1558.9 ± 0.4% | 1054.4 ± 0.5% | 16.732 | 28.526 | 89.160 | 27.515 | 40.678 |
| hex: silesia/samba | 524290 | 43190.4 ± 1.6% | 2565.7 ± 0.5% | 1502.7 ± 0.3% | 334.0 ± 1.3% | 1562.7 ± 1.3% | 1063.2 ± 0.7% | 16.834 | 28.741 | 129.330 | 27.639 | 40.624 |
| hex: silesia/sao | 524290 | 42890.3 ± 1.5% | 2568.5 ± 0.3% | 1509.5 ± 0.8% | 270.6 ± 2.9% | 1556.7 ± 5.9% | 1055.5 ± 1.0% | 16.698 | 28.414 | 158.480 | 27.551 | 40.634 |
| hex: silesia/webster | 524290 | 44050.2 ± 0.7% | 2573.4 ± 0.7% | 1500.2 ± 5.1% | 435.0 ± 1.1% | 1570.1 ± 1.2% | 1068.9 ± 1.0% | 17.117 | 29.363 | 101.267 | 28.055 | 41.209 |
| hex: silesia/x-ray | 524290 | 42964.2 ± 0.8% | 2558.6 ± 0.7% | 1504.9 ± 2.8% | 420.9 ± 0.4% | 1556.9 ± 0.6% | 1055.1 ± 0.7% | 16.792 | 28.549 | 102.084 | 27.595 | 40.722 |
| hex: silesia/xml | 524290 | 42875.6 ± 2.4% | 2572.2 ± 0.5% | 1504.3 ± 0.9% | 685.6 ± 0.5% | 1553.6 ± 0.9% | 1054.7 ± 0.8% | 16.669 | 28.501 | 62.541 | 27.598 | 40.652 |
| hex: canterbury/alice29.txt | 304180 | 42556.7 ± 0.4% | 2590.5 ± 0.4% | 1534.1 ± 0.3% | 469.9 ± 1.0% | 1587.5 ± 0.7% | 1087.5 ± 0.4% | 16.428 | 27.740 | 90.568 | 26.808 | 39.134 |
| hex: canterbury/asyoulik.txt | 250360 | 42315.4 ± 1.0% | 2578.0 ± 0.4% | 1534.4 ± 0.7% | 454.9 ± 0.2% | 1577.0 ± 0.9% | 1082.8 ± 1.1% | 16.414 | 27.578 | 93.023 | 26.832 | 39.081 |
| hex: canterbury/cp.html | 49208 | 41167.1 ± 1.0% | 2557.6 ± 6.4% | 1527.1 ± 0.9% | 479.1 ± 1.5% | 1581.2 ± 0.6% | 1084.7 ± 0.7% | 16.096 | 26.958 | 85.932 | 26.036 | 37.952 |
| hex: canterbury/fields.c | 22302 | 41809.9 ± 1.1% | 2597.2 ± 1.1% | 1537.2 ± 0.5% | 597.8 ± 0.5% | 1589.8 ± 0.6% | 1091.7 ± 4.9% | 16.098 | 27.199 | 69.942 | 26.298 | 38.299 |
| hex: canterbury/grammar.lsp | 7444 | 38924.6 ± 1.2% | 2650.3 ± 0.7% | 1550.7 ± 0.8% | 813.0 ± 0.4% | 1592.6 ± 0.3% | 1103.8 ± 0.8% | 14.687 | 25.101 | 47.876 | 24.441 | 35.264 |
| hex: canterbury/kennedy.xls | 524290 | 43232.8 ± 1.2% | 2535.3 ± 0.5% | 1499.3 ± 0.4% | 769.4 ± 0.4% | 1509.0 ± 0.3% | 1059.6 ± 0.7% | 17.053 | 28.836 | 56.189 | 28.650 | 40.801 |
| hex: canterbury/lcet10.txt | 524290 | 43379.5 ± 1.0% | 2570.9 ± 1.0% | 1507.5 ± 0.6% | 467.8 ± 0.5% | 1563.9 ± 0.7% | 1064.0 ± 0.9% | 16.873 | 28.776 | 92.737 | 27.738 | 40.769 |
| hex: canterbury/plrabn12.txt | 524290 | 42145.6 ± 1.3% | 2565.2 ± 1.0% | 1500.9 ± 1.1% | 446.7 ± 1.0% | 1509.1 ± 0.9% | 1062.8 ± 1.2% | 16.430 | 28.081 | 94.350 | 27.929 | 39.656 |
| hex: canterbury/ptt5 | 524290 | 43337.8 ± 0.8% | 2541.1 ± 0.5% | 1495.3 ± 0.3% | 588.9 ± 3.9% | 1546.2 ± 0.6% | 1061.9 ± 0.5% | 17.055 | 28.982 | 73.596 | 28.029 | 40.813 |
| hex: canterbury/sum | 76482 | 42425.3 ± 1.3% | 2561.2 ± 0.2% | 1520.2 ± 0.7% | 560.1 ± 0.9% | 1570.7 ± 1.1% | 1083.5 ± 5.0% | 16.564 | 27.909 | 75.747 | 27.011 | 39.157 |
| hex: canterbury/xargs.1 | 8456 | 40043.3 ± 1.4% | 2643.4 ± 0.6% | 1558.7 ± 5.0% | 836.6 ± 0.8% | 1592.5 ± 1.2% | 1103.7 ± 0.8% | 15.148 | 25.691 | 47.865 | 25.145 | 36.281 |
| hex: canterbury-large/E.coli | 524290 | 43026.7 ± 3.5% | 2552.4 ± 0.7% | 1504.2 ± 0.9% | 811.1 ± 0.7% | 1553.8 ± 0.5% | 1057.5 ± 0.7% | 16.857 | 28.604 | 53.049 | 27.691 | 40.686 |
| hex: canterbury-large/bible.txt | 524290 | 43194.5 ± 2.5% | 2556.7 ± 0.9% | 1503.1 ± 6.0% | 478.6 ± 0.1% | 1554.8 ± 5.9% | 1058.1 ± 0.9% | 16.894 | 28.737 | 90.243 | 27.781 | 40.821 |
| hex: canterbury-large/world192.txt | 524290 | 42859.7 ± 0.7% | 2562.1 ± 0.5% | 1500.4 ± 0.2% | 456.1 ± 0.9% | 1557.7 ± 2.5% | 1057.8 ± 0.6% | 16.728 | 28.566 | 93.968 | 27.514 | 40.517 |
| hex: http/html-1kx1024 | 2099200 | 20789.0 ± 0.9% | 2305.3 ± 1.6% | 1471.0 ± 0.8% | 496.2 ± 0.5% | 1479.1 ± 1.3% | 1067.1 ± 1.2% | 9.018 | 14.133 | 41.893 | 14.055 | 19.482 |
| hex: http/html-16kx64 | 2097280 | 21345.2 ± 1.1% | 2201.8 ± 1.0% | 1448.8 ± 0.7% | 500.8 ± 1.0% | 1436.9 ± 0.9% | 1084.6 ± 0.9% | 9.694 | 14.733 | 42.624 | 14.855 | 19.680 |
| hex: http/html-1m | 524290 | 43554.7 ± 1.0% | 2558.8 ± 1.6% | 1508.5 ± 0.6% | 488.5 ± 0.6% | 1559.3 ± 1.1% | 1061.3 ± 0.8% | 17.021 | 28.873 | 89.161 | 27.932 | 41.037 |
| hex: http/json-1kx1024 | 2099200 | 20191.3 ± 5.5% | 2317.9 ± 1.5% | 1476.2 ± 1.0% | 697.0 ± 0.4% | 1491.9 ± 1.2% | 1079.6 ± 0.5% | 8.711 | 13.678 | 28.968 | 13.534 | 18.703 |
| hex: http/json-16kx64 | 2097280 | 21556.0 ± 2.2% | 2197.0 ± 0.6% | 1450.4 ± 1.1% | 703.9 ± 0.9% | 1434.7 ± 0.9% | 1077.4 ± 0.8% | 9.812 | 14.862 | 30.626 | 15.024 | 20.008 |
| hex: http/json-1m | 524290 | 43023.4 ± 1.8% | 2548.4 ± 0.7% | 1498.8 ± 1.3% | 719.7 ± 4.9% | 1515.3 ± 6.5% | 1059.4 ± 0.6% | 16.882 | 28.706 | 59.780 | 28.393 | 40.610 |
| hex: http/js-1kx1024 | 2099200 | 20124.1 ± 0.3% | 2299.9 ± 1.5% | 1467.4 ± 0.6% | 487.6 ± 0.4% | 1483.1 ± 1.1% | 1071.2 ± 0.5% | 8.750 | 13.714 | 41.273 | 13.569 | 18.786 |
| hex: http/js-16kx64 | 2097280 | 21171.1 ± 0.7% | 2204.8 ± 6.7% | 1451.4 ± 0.5% | 489.5 ± 0.5% | 1435.6 ± 0.5% | 1078.3 ± 0.6% | 9.602 | 14.587 | 43.250 | 14.747 | 19.633 |
| hex: http/js-1m | 524290 | 42973.8 ± 1.0% | 2572.5 ± 0.7% | 1500.5 ± 5.3% | 503.8 ± 1.6% | 1561.2 ± 0.4% | 1058.5 ± 5.2% | 16.705 | 28.640 | 85.295 | 27.525 | 40.597 |
| hex: http/css-1kx1024 | 2099200 | 20528.0 ± 1.0% | 2294.2 ± 2.6% | 1468.0 ± 0.9% | 552.8 ± 0.5% | 1473.6 ± 1.5% | 1071.1 ± 0.5% | 8.948 | 13.983 | 37.133 | 13.931 | 19.165 |
| hex: http/css-16kx64 | 2097280 | 21695.8 ± 0.6% | 2210.3 ± 0.8% | 1457.8 ± 0.9% | 560.9 ± 0.6% | 1442.7 ± 1.1% | 1082.6 ± 0.8% | 9.816 | 14.883 | 38.679 | 15.038 | 20.041 |
| hex: http/css-1m | 524290 | 42759.3 ± 4.0% | 2558.3 ± 10.1% | 1504.7 ± 0.2% | 528.3 ± 0.5% | 1514.3 ± 0.2% | 1055.3 ± 4.1% | 16.714 | 28.418 | 80.942 | 28.238 | 40.517 |
| hex: shuffled/dickens-1m | 524290 | 43271.1 ± 0.6% | 2565.8 ± 1.0% | 1500.5 ± 1.4% | 460.8 ± 1.1% | 1562.1 ± 0.8% | 1063.0 ± 0.7% | 16.865 | 28.838 | 93.903 | 27.701 | 40.708 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1790.1 ± 0.9% | 1457.5 ± 1.5% | 1011.8 ± 1.0% | 464.5 ± 0.6% | 446.1 ± 3.1% | 499.2 ± 0.8% | 1.228 | 1.769 | 3.854 | 4.013 | 3.586 |
| qlog records, JSON text sequence | 1467503 | 1717.1 ± 1.1% | 1208.2 ± 2.7% | 918.0 ± 1.0% | 427.3 ± 1.4% | 532.8 ± 1.9% | 352.5 ± 1.5% | 1.421 | 1.870 | 4.018 | 3.223 | 4.871 |
| messages: 11 string members | 1025025 | 1300.4 ± 0.3% | 1089.7 ± 0.3% | 739.4 ± 1.1% | 408.7 ± 0.9% | 423.1 ± 0.6% | 430.4 ± 1.3% | 1.193 | 1.759 | 3.181 | 3.074 | 3.022 |
| messages: 50 nested objects | 1121600 | 1965.4 ± 0.5% | 1847.8 ± 0.5% | 1315.9 ± 1.1% | 590.7 ± 0.8% | 615.1 ± 1.3% | 507.4 ± 1.1% | 1.064 | 1.494 | 3.327 | 3.195 | 3.873 |
| string: silesia/dickens | 172528 | 13375.8 ± 1.8% | 3906.5 ± 0.9% | 3096.8 ± 0.9% | 330.7 ± 1.3% | 1712.9 ± 2.1% | 1180.4 ± 0.7% | 3.424 | 4.319 | 40.442 | 7.809 | 11.332 |
| string: silesia/nci | 1075110 | 11583.4 ± 0.4% | 4635.2 ± 0.5% | 3142.1 ± 1.2% | 908.9 ± 0.5% | 1905.4 ± 2.5% | 1197.1 ± 1.0% | 2.499 | 3.686 | 12.744 | 6.079 | 9.676 |
| string: silesia/reymont | 1075159 | 5419.5 ± 1.4% | 1841.7 ± 1.8% | 2006.9 ± 0.6% | 376.7 ± 1.2% | 1421.9 ± 1.2% | 1033.5 ± 1.4% | 2.943 | 2.700 | 14.387 | 3.811 | 5.244 |
| string: silesia/samba | 97582 | 7330.6 ± 0.6% | 2694.9 ± 1.7% | 4066.1 ± 1.0% | 347.8 ± 0.9% | 1327.1 ± 1.5% | 1173.5 ± 0.9% | 2.720 | 1.803 | 21.076 | 5.524 | 6.247 |
| string: silesia/webster | 1098490 | 6966.0 ± 0.5% | 1965.4 ± 1.7% | 1868.4 ± 0.8% | 348.9 ± 0.5% | 1404.4 ± 1.2% | 599.0 ± 0.7% | 3.544 | 3.728 | 19.963 | 4.960 | 11.629 |
| string: silesia/xml | 1090118 | 11139.5 ± 2.2% | 3153.2 ± 0.9% | 2624.0 ± 0.8% | 602.2 ± 0.7% | 1949.9 ± 0.3% | 952.2 ± 0.8% | 3.533 | 4.245 | 18.498 | 5.713 | 11.698 |
| string: canterbury/alice29.txt | 159425 | 13305.8 ± 0.7% | 2864.4 ± 1.6% | 3144.6 ± 2.1% | 316.7 ± 0.9% | 1546.2 ± 1.4% | 1090.4 ± 0.7% | 4.645 | 4.231 | 42.011 | 8.605 | 12.202 |
| string: canterbury/asyoulik.txt | 132198 | 11503.3 ± 0.5% | 2094.9 ± 1.1% | 3104.3 ± 0.5% | 316.4 ± 1.4% | 1369.0 ± 1.1% | 957.6 ± 0.6% | 5.491 | 3.706 | 36.359 | 8.403 | 12.012 |
| string: canterbury/lcet10.txt | 441884 | 12546.3 ± 2.5% | 3071.2 ± 1.0% | 2640.9 ± 0.4% | 366.6 ± 0.6% | 1672.6 ± 0.7% | 1191.9 ± 0.4% | 4.085 | 4.751 | 34.222 | 7.501 | 10.526 |
| string: canterbury/plrabn12.txt | 503330 | 9004.1 ± 3.0% | 2305.5 ± 0.7% | 2159.5 ± 0.7% | 347.5 ± 1.2% | 1648.2 ± 2.3% | 1114.7 ± 1.9% | 3.905 | 4.170 | 25.910 | 5.463 | 8.078 |
| string: canterbury-large/E.coli | 1048578 | 28450.7 ± 3.8% | 15944.3 ± 1.7% | 3454.9 ± 1.0% | 1688.3 ± 2.0% | 3143.0 ± 0.6% | 1390.9 ± 0.4% | 1.784 | 8.235 | 16.851 | 9.052 | 20.455 |
| string: canterbury-large/bible.txt | 1055886 | 9795.2 ± 0.8% | 4805.4 ± 1.9% | 3031.0 ± 0.9% | 401.3 ± 0.7% | 2132.8 ± 0.8% | 1473.2 ± 0.4% | 2.038 | 3.232 | 24.409 | 4.593 | 6.649 |
| string: canterbury-large/world192.txt | 1103121 | 6485.9 ± 0.8% | 1711.5 ± 0.5% | 2003.3 ± 0.7% | 346.8 ± 1.8% | 1385.7 ± 1.9% | 959.7 ± 4.7% | 3.790 | 3.238 | 18.702 | 4.681 | 6.758 |
| string: http/html-1m | 1058582 | 10009.3 ± 0.9% | 4303.6 ± 1.1% | 2913.4 ± 1.1% | 417.6 ± 1.6% | 2153.1 ± 3.8% | 845.5 ± 1.0% | 2.326 | 3.436 | 23.971 | 4.649 | 11.839 |
| string: http/json-1m | 1190272 | 8376.5 ± 0.8% | 1572.6 ± 1.2% | 1958.1 ± 1.2% | 556.1 ± 1.3% | 1191.3 ± 1.2% | 844.1 ± 1.3% | 5.327 | 4.278 | 15.064 | 7.031 | 9.924 |
| string: http/js-1m | 1144362 | 6607.7 ± 1.3% | 1110.7 ± 0.7% | 1528.5 ± 1.3% | 331.7 ± 1.0% | 1113.4 ± 1.9% | 755.4 ± 1.2% | 5.949 | 4.323 | 19.920 | 5.934 | 8.747 |
| string: http/css-1m | 1097820 | 9032.0 ± 1.4% | 1460.8 ± 1.3% | 2357.5 ± 1.6% | 509.1 ± 1.0% | 1268.3 ± 0.7% | 875.6 ± 1.8% | 6.183 | 3.831 | 17.742 | 7.121 | 10.315 |
| string: dickens as Cyrillic and CJK | 1883069 | 5702.0 ± 0.4% | 3601.4 ± 1.2% | 500.6 ± 1.1% | 245.7 ± 0.8% | 449.6 ± 0.4% | 354.0 ± 3.2% | 1.583 | 11.389 | 23.205 | 12.684 | 16.108 |
| hex: silesia/dickens | 524290 | 42549.5 ± 0.4% | 2553.6 ± 0.4% | 1506.4 ± 1.1% | 461.5 ± 1.1% | 1558.7 ± 1.4% | 1064.5 ± 6.2% | 16.663 | 28.247 | 92.191 | 27.299 | 39.971 |
| hex: silesia/mozilla | 524290 | 42951.0 ± 1.5% | 2558.2 ± 10.0% | 1499.7 ± 1.2% | 385.0 ± 2.0% | 1558.9 ± 0.6% | 1059.0 ± 1.3% | 16.790 | 28.640 | 111.566 | 27.552 | 40.556 |
| hex: silesia/mr | 524290 | 42885.1 ± 1.4% | 2534.8 ± 0.4% | 1497.0 ± 5.9% | 594.6 ± 0.9% | 1558.2 ± 1.0% | 1058.6 ± 1.1% | 16.918 | 28.648 | 72.130 | 27.522 | 40.511 |
| hex: silesia/nci | 524290 | 42871.3 ± 3.4% | 2542.2 ± 0.8% | 1501.3 ± 0.7% | 756.1 ± 0.9% | 1556.2 ± 0.9% | 1062.1 ± 0.8% | 16.864 | 28.556 | 56.704 | 27.548 | 40.363 |
| hex: silesia/ooffice | 524290 | 41817.0 ± 7.5% | 2572.8 ± 0.4% | 1514.7 ± 0.4% | 322.6 ± 1.8% | 1572.3 ± 0.2% | 1061.9 ± 0.3% | 16.253 | 27.607 | 129.616 | 26.596 | 39.380 |
| hex: silesia/osdb | 524290 | 43068.2 ± 2.5% | 2567.1 ± 0.4% | 1506.1 ± 0.9% | 429.3 ± 0.6% | 1560.4 ± 0.5% | 1062.5 ± 0.4% | 16.777 | 28.595 | 100.333 | 27.601 | 40.534 |
| hex: silesia/reymont | 524290 | 42785.0 ± 1.0% | 2563.5 ± 0.4% | 1503.6 ± 0.7% | 481.1 ± 0.5% | 1558.9 ± 0.4% | 1054.4 ± 0.5% | 16.690 | 28.454 | 88.937 | 27.446 | 40.576 |
| hex: silesia/samba | 524290 | 42873.3 ± 1.7% | 2565.7 ± 0.5% | 1502.7 ± 0.3% | 334.0 ± 1.3% | 1562.7 ± 1.3% | 1063.2 ± 0.7% | 16.710 | 28.530 | 128.381 | 27.436 | 40.325 |
| hex: silesia/sao | 524290 | 42691.3 ± 0.8% | 2568.5 ± 0.3% | 1509.5 ± 0.8% | 270.6 ± 2.9% | 1556.7 ± 5.9% | 1055.5 ± 1.0% | 16.621 | 28.282 | 157.745 | 27.424 | 40.445 |
| hex: silesia/webster | 524290 | 43850.2 ± 0.3% | 2573.4 ± 0.7% | 1500.2 ± 5.1% | 435.0 ± 1.1% | 1570.1 ± 1.2% | 1068.9 ± 1.0% | 17.040 | 29.230 | 100.808 | 27.928 | 41.022 |
| hex: silesia/x-ray | 524290 | 42757.7 ± 1.7% | 2558.6 ± 0.7% | 1504.9 ± 2.8% | 420.9 ± 0.4% | 1556.9 ± 0.6% | 1055.1 ± 0.7% | 16.711 | 28.412 | 101.593 | 27.463 | 40.526 |
| hex: silesia/xml | 524290 | 43063.8 ± 1.3% | 2572.2 ± 0.5% | 1504.3 ± 0.9% | 685.6 ± 0.5% | 1553.6 ± 0.9% | 1054.7 ± 0.8% | 16.742 | 28.626 | 62.815 | 27.719 | 40.830 |
| hex: canterbury/alice29.txt | 304180 | 42806.7 ± 0.5% | 2590.5 ± 0.4% | 1534.1 ± 0.3% | 469.9 ± 1.0% | 1587.5 ± 0.7% | 1087.5 ± 0.4% | 16.524 | 27.903 | 91.100 | 26.966 | 39.364 |
| hex: canterbury/asyoulik.txt | 250360 | 42266.8 ± 0.3% | 2578.0 ± 0.4% | 1534.4 ± 0.7% | 454.9 ± 0.2% | 1577.0 ± 0.9% | 1082.8 ± 1.1% | 16.395 | 27.546 | 92.916 | 26.802 | 39.036 |
| hex: canterbury/cp.html | 49208 | 41416.3 ± 1.3% | 2557.6 ± 6.4% | 1527.1 ± 0.9% | 479.1 ± 1.5% | 1581.2 ± 0.6% | 1084.7 ± 0.7% | 16.194 | 27.121 | 86.452 | 26.194 | 38.182 |
| hex: canterbury/fields.c | 22302 | 41987.8 ± 6.6% | 2597.2 ± 1.1% | 1537.2 ± 0.5% | 597.8 ± 0.5% | 1589.8 ± 0.6% | 1091.7 ± 4.9% | 16.167 | 27.314 | 70.240 | 26.410 | 38.462 |
| hex: canterbury/grammar.lsp | 7444 | 39542.8 ± 1.1% | 2650.3 ± 0.7% | 1550.7 ± 0.8% | 813.0 ± 0.4% | 1592.6 ± 0.3% | 1103.8 ± 0.8% | 14.920 | 25.500 | 48.636 | 24.830 | 35.824 |
| hex: canterbury/kennedy.xls | 524290 | 43116.8 ± 1.6% | 2535.3 ± 0.5% | 1499.3 ± 0.4% | 769.4 ± 0.4% | 1509.0 ± 0.3% | 1059.6 ± 0.7% | 17.007 | 28.759 | 56.038 | 28.573 | 40.691 |
| hex: canterbury/lcet10.txt | 524290 | 43506.9 ± 0.9% | 2570.9 ± 1.0% | 1507.5 ± 0.6% | 467.8 ± 0.5% | 1563.9 ± 0.7% | 1064.0 ± 0.9% | 16.923 | 28.861 | 93.010 | 27.819 | 40.889 |
| hex: canterbury/plrabn12.txt | 524290 | 42541.9 ± 1.9% | 2565.2 ± 1.0% | 1500.9 ± 1.1% | 446.7 ± 1.0% | 1509.1 ± 0.9% | 1062.8 ± 1.2% | 16.584 | 28.345 | 95.237 | 28.191 | 40.028 |
| hex: canterbury/ptt5 | 524290 | 42935.8 ± 1.7% | 2541.1 ± 0.5% | 1495.3 ± 0.3% | 588.9 ± 3.9% | 1546.2 ± 0.6% | 1061.9 ± 0.5% | 16.896 | 28.713 | 72.914 | 27.769 | 40.434 |
| hex: canterbury/sum | 76482 | 42478.0 ± 1.3% | 2561.2 ± 0.2% | 1520.2 ± 0.7% | 560.1 ± 0.9% | 1570.7 ± 1.1% | 1083.5 ± 5.0% | 16.585 | 27.943 | 75.841 | 27.044 | 39.206 |
| hex: canterbury/xargs.1 | 8456 | 40189.3 ± 1.1% | 2643.4 ± 0.6% | 1558.7 ± 5.0% | 836.6 ± 0.8% | 1592.5 ± 1.2% | 1103.7 ± 0.8% | 15.204 | 25.785 | 48.039 | 25.237 | 36.414 |
| hex: canterbury-large/E.coli | 524290 | 43284.9 ± 1.2% | 2552.4 ± 0.7% | 1504.2 ± 0.9% | 811.1 ± 0.7% | 1553.8 ± 0.5% | 1057.5 ± 0.7% | 16.959 | 28.776 | 53.367 | 27.857 | 40.931 |
| hex: canterbury-large/bible.txt | 524290 | 43152.5 ± 1.5% | 2556.7 ± 0.9% | 1503.1 ± 6.0% | 478.6 ± 0.1% | 1554.8 ± 5.9% | 1058.1 ± 0.9% | 16.878 | 28.709 | 90.155 | 27.754 | 40.781 |
| hex: canterbury-large/world192.txt | 524290 | 42974.1 ± 2.4% | 2562.1 ± 0.5% | 1500.4 ± 0.2% | 456.1 ± 0.9% | 1557.7 ± 2.5% | 1057.8 ± 0.6% | 16.773 | 28.642 | 94.218 | 27.587 | 40.625 |
| hex: http/html-1kx1024 | 2099200 | 20900.6 ± 0.3% | 2305.3 ± 1.6% | 1471.0 ± 0.8% | 496.2 ± 0.5% | 1479.1 ± 1.3% | 1067.1 ± 1.2% | 9.066 | 14.209 | 42.118 | 14.131 | 19.587 |
| hex: http/html-16kx64 | 2097280 | 21400.6 ± 0.4% | 2201.8 ± 1.0% | 1448.8 ± 0.7% | 500.8 ± 1.0% | 1436.9 ± 0.9% | 1084.6 ± 0.9% | 9.720 | 14.772 | 42.734 | 14.893 | 19.731 |
| hex: http/html-1m | 524290 | 43408.5 ± 2.8% | 2558.8 ± 1.6% | 1508.5 ± 0.6% | 488.5 ± 0.6% | 1559.3 ± 1.1% | 1061.3 ± 0.8% | 16.964 | 28.777 | 88.862 | 27.838 | 40.900 |
| hex: http/json-1kx1024 | 2099200 | 20370.5 ± 2.1% | 2317.9 ± 1.5% | 1476.2 ± 1.0% | 697.0 ± 0.4% | 1491.9 ± 1.2% | 1079.6 ± 0.5% | 8.788 | 13.799 | 29.226 | 13.654 | 18.869 |
| hex: http/json-16kx64 | 2097280 | 21660.1 ± 0.4% | 2197.0 ± 0.6% | 1450.4 ± 1.1% | 703.9 ± 0.9% | 1434.7 ± 0.9% | 1077.4 ± 0.8% | 9.859 | 14.934 | 30.774 | 15.097 | 20.105 |
| hex: http/json-1m | 524290 | 43069.6 ± 1.4% | 2548.4 ± 0.7% | 1498.8 ± 1.3% | 719.7 ± 4.9% | 1515.3 ± 6.5% | 1059.4 ± 0.6% | 16.900 | 28.737 | 59.845 | 28.424 | 40.654 |
| hex: http/js-1kx1024 | 2099200 | 20208.1 ± 0.7% | 2299.9 ± 1.5% | 1467.4 ± 0.6% | 487.6 ± 0.4% | 1483.1 ± 1.1% | 1071.2 ± 0.5% | 8.787 | 13.772 | 41.446 | 13.625 | 18.864 |
| hex: http/js-16kx64 | 2097280 | 21325.7 ± 0.2% | 2204.8 ± 6.7% | 1451.4 ± 0.5% | 489.5 ± 0.5% | 1435.6 ± 0.5% | 1078.3 ± 0.6% | 9.672 | 14.693 | 43.566 | 14.855 | 19.776 |
| hex: http/js-1m | 524290 | 43020.9 ± 0.9% | 2572.5 ± 0.7% | 1500.5 ± 5.3% | 503.8 ± 1.6% | 1561.2 ± 0.4% | 1058.5 ± 5.2% | 16.723 | 28.671 | 85.388 | 27.556 | 40.641 |
| hex: http/css-1kx1024 | 2099200 | 20690.1 ± 0.6% | 2294.2 ± 2.6% | 1468.0 ± 0.9% | 552.8 ± 0.5% | 1473.6 ± 1.5% | 1071.1 ± 0.5% | 9.018 | 14.094 | 37.427 | 14.041 | 19.317 |
| hex: http/css-16kx64 | 2097280 | 21825.8 ± 0.8% | 2210.3 ± 0.8% | 1457.8 ± 0.9% | 560.9 ± 0.6% | 1442.7 ± 1.1% | 1082.6 ± 0.8% | 9.875 | 14.972 | 38.910 | 15.128 | 20.161 |
| hex: http/css-1m | 524290 | 43078.7 ± 1.3% | 2558.3 ± 10.1% | 1504.7 ± 0.2% | 528.3 ± 0.5% | 1514.3 ± 0.2% | 1055.3 ± 4.1% | 16.839 | 28.630 | 81.546 | 28.448 | 40.820 |
| hex: shuffled/dickens-1m | 524290 | 42704.3 ± 8.4% | 2565.8 ± 1.0% | 1500.5 ± 1.4% | 460.8 ± 1.1% | 1562.1 ± 0.8% | 1063.0 ± 0.7% | 16.644 | 28.460 | 92.673 | 27.338 | 40.175 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1143.2 ± 1.1% | 1496.1 ± 2.7% | 1099.2 ± 0.7% | 390.3 ± 0.9% | 652.6 ± 1.0% | 362.3 ± 1.8% | 0.764 | 1.040 | 2.929 | 1.752 | 3.156 |
| qlog records, JSON text sequence | 1467503 | 1008.3 ± 0.6% | 1224.7 ± 2.0% | 1094.3 ± 0.5% | 325.8 ± 0.9% | 725.7 ± 1.2% | 315.1 ± 0.9% | 0.823 | 0.921 | 3.095 | 1.389 | 3.199 |
| messages: 11 string members | 1025025 | 937.0 ± 0.3% | 1967.1 ± 2.4% | 769.8 ± 1.2% | 335.0 ± 0.8% | 495.4 ± 0.8% | 303.5 ± 1.0% | 0.476 | 1.217 | 2.797 | 1.891 | 3.087 |
| messages: 50 nested objects | 1121600 | 1233.9 ± 0.6% | 1735.5 ± 0.9% | 1431.8 ± 0.9% | 426.6 ± 0.9% | 902.2 ± 0.9% | 419.5 ± 0.8% | 0.711 | 0.862 | 2.893 | 1.368 | 2.942 |
| string: silesia/dickens | 172528 | 6674.1 ± 0.4% | 3420.0 ± 3.5% | 2829.2 ± 1.7% | 315.5 ± 0.8% | 3338.8 ± 1.2% | 567.1 ± 1.8% | 1.952 | 2.359 | 21.153 | 1.999 | 11.769 |
| string: silesia/nci | 1075110 | 5413.4 ± 1.0% | 3889.1 ± 0.6% | 2979.8 ± 0.8% | 652.4 ± 0.9% | 3673.8 ± 0.7% | 574.3 ± 0.9% | 1.392 | 1.817 | 8.298 | 1.473 | 9.426 |
| string: silesia/reymont | 1075159 | 3445.1 ± 0.9% | 3374.6 ± 1.4% | 1985.8 ± 2.4% | 338.5 ± 0.4% | 2068.8 ± 0.4% | 490.6 ± 1.7% | 1.021 | 1.735 | 10.177 | 1.665 | 7.023 |
| string: silesia/samba | 97582 | 3976.0 ± 0.4% | 3766.0 ± 0.7% | 3101.7 ± 0.3% | 325.7 ± 1.1% | 2044.7 ± 0.7% | 416.5 ± 1.4% | 1.056 | 1.282 | 12.208 | 1.944 | 9.546 |
| string: silesia/webster | 1098490 | 4365.7 ± 0.6% | 2418.4 ± 0.6% | 1729.3 ± 0.8% | 306.6 ± 1.4% | 2100.2 ± 1.1% | 461.3 ± 2.5% | 1.805 | 2.525 | 14.239 | 2.079 | 9.465 |
| string: silesia/xml | 1090118 | 6058.1 ± 0.5% | 5008.0 ± 0.9% | 2471.6 ± 1.1% | 505.3 ± 1.3% | 3348.7 ± 0.7% | 538.2 ± 1.9% | 1.210 | 2.451 | 11.989 | 1.809 | 11.257 |
| string: canterbury/alice29.txt | 159425 | 5737.6 ± 1.1% | 2748.3 ± 1.2% | 2881.6 ± 1.8% | 298.6 ± 1.3% | 3021.7 ± 1.4% | 513.8 ± 2.1% | 2.088 | 1.991 | 19.212 | 1.899 | 11.167 |
| string: canterbury/asyoulik.txt | 132198 | 4282.6 ± 1.1% | 2624.6 ± 2.0% | 2685.4 ± 1.0% | 305.8 ± 1.3% | 2452.9 ± 1.0% | 451.8 ± 1.4% | 1.632 | 1.595 | 14.007 | 1.746 | 9.480 |
| string: canterbury/lcet10.txt | 441884 | 6620.8 ± 0.4% | 3251.5 ± 1.0% | 2350.5 ± 1.2% | 345.5 ± 2.0% | 3002.1 ± 1.6% | 556.7 ± 3.3% | 2.036 | 2.817 | 19.163 | 2.205 | 11.892 |
| string: canterbury/plrabn12.txt | 503330 | 5449.1 ± 0.6% | 3136.3 ± 1.1% | 1842.6 ± 2.3% | 320.4 ± 0.7% | 2859.7 ± 0.4% | 527.0 ± 1.2% | 1.737 | 2.957 | 17.007 | 1.906 | 10.340 |
| string: canterbury-large/E.coli | 1048578 | 31652.7 ± 0.8% | 12881.3 ± 0.4% | 3337.2 ± 0.9% | 1270.7 ± 0.6% | 8487.7 ± 0.6% | 936.6 ± 3.7% | 2.457 | 9.485 | 24.910 | 3.729 | 33.796 |
| string: canterbury-large/bible.txt | 1055886 | 8501.0 ± 0.5% | 5225.4 ± 0.9% | 2782.6 ± 0.5% | 356.8 ± 0.8% | 3844.7 ± 0.4% | 616.2 ± 2.4% | 1.627 | 3.055 | 23.823 | 2.211 | 13.795 |
| string: canterbury-large/world192.txt | 1103121 | 4132.2 ± 0.4% | 2287.3 ± 0.4% | 1784.4 ± 0.4% | 326.3 ± 0.8% | 2167.7 ± 0.6% | 461.8 ± 1.5% | 1.807 | 2.316 | 12.666 | 1.906 | 8.948 |
| string: http/html-1m | 1058582 | 8514.5 ± 3.5% | 4700.3 ± 2.1% | 2683.8 ± 2.3% | 426.1 ± 0.5% | 3534.9 ± 0.9% | 589.8 ± 3.6% | 1.811 | 3.173 | 19.983 | 2.409 | 14.438 |
| string: http/json-1m | 1190272 | 3257.7 ± 1.3% | 1241.9 ± 3.2% | 2119.1 ± 0.7% | 468.0 ± 1.3% | 1366.3 ± 1.0% | 432.6 ± 1.6% | 2.623 | 1.537 | 6.961 | 2.384 | 7.531 |
| string: http/js-1m | 1144362 | 2856.2 ± 0.8% | 1596.9 ± 0.8% | 1321.4 ± 0.6% | 326.5 ± 1.0% | 1403.4 ± 0.9% | 375.6 ± 2.3% | 1.789 | 2.162 | 8.747 | 2.035 | 7.604 |
| string: http/css-1m | 1097820 | 3292.0 ± 1.0% | 2879.2 ± 0.3% | 2284.5 ± 0.5% | 457.6 ± 2.6% | 2103.0 ± 0.8% | 436.6 ± 2.7% | 1.143 | 1.441 | 7.194 | 1.565 | 7.540 |
| string: dickens as Cyrillic and CJK | 1883069 | 5769.3 ± 1.1% | 3055.5 ± 1.9% | 683.4 ± 0.3% | 376.2 ± 1.1% | 494.2 ± 0.9% | 162.0 ± 3.3% | 1.888 | 8.442 | 15.338 | 11.673 | 35.622 |
| string: dickens as Cyrillic and CJK, as \u escapes | 5075485 | 1201.8 ± 1.1% | 1235.4 ± 2.1% | 1101.7 ± 0.4% | 262.3 ± 0.8% | 466.7 ± 0.7% | 222.4 ± 3.0% | 0.973 | 1.091 | 4.582 | 2.575 | 5.403 |
| hex: silesia/dickens | 524290 | 33759.4 ± 0.5% | 14992.3 ± 1.1% | 3544.6 ± 3.4% | 476.4 ± 0.9% | 8919.4 ± 0.6% | 1128.5 ± 4.9% | 2.252 | 9.524 | 70.858 | 3.785 | 29.916 |
| hex: silesia/mozilla | 524290 | 33753.5 ± 1.3% | 14986.6 ± 1.2% | 3479.3 ± 1.3% | 425.9 ± 1.3% | 8891.2 ± 1.2% | 1128.0 ± 1.3% | 2.252 | 9.701 | 79.247 | 3.796 | 29.923 |
| hex: silesia/mr | 524290 | 33764.9 ± 4.5% | 14946.5 ± 0.5% | 3468.2 ± 3.9% | 643.7 ± 0.5% | 8871.4 ± 0.4% | 1128.3 ± 1.5% | 2.259 | 9.736 | 52.456 | 3.806 | 29.927 |
| hex: silesia/nci | 524290 | 33780.5 ± 0.6% | 14919.5 ± 0.7% | 3531.4 ± 0.3% | 754.7 ± 1.7% | 8895.5 ± 4.6% | 1129.5 ± 0.6% | 2.264 | 9.566 | 44.759 | 3.797 | 29.906 |
| hex: silesia/ooffice | 524290 | 33816.4 ± 1.1% | 14942.6 ± 1.0% | 3485.3 ± 0.8% | 342.7 ± 0.6% | 8898.7 ± 0.8% | 1131.0 ± 1.6% | 2.263 | 9.703 | 98.684 | 3.800 | 29.901 |
| hex: silesia/osdb | 524290 | 33908.9 ± 0.9% | 15035.1 ± 0.8% | 3493.3 ± 0.6% | 454.3 ± 1.5% | 8911.4 ± 0.8% | 1134.5 ± 0.7% | 2.255 | 9.707 | 74.644 | 3.805 | 29.889 |
| hex: silesia/reymont | 524290 | 33855.6 ± 0.7% | 14993.0 ± 0.7% | 3524.8 ± 0.8% | 492.0 ± 0.8% | 8898.5 ± 0.6% | 1128.4 ± 1.8% | 2.258 | 9.605 | 68.817 | 3.805 | 30.004 |
| hex: silesia/samba | 524290 | 33716.8 ± 0.9% | 14918.9 ± 0.9% | 3478.6 ± 1.1% | 362.3 ± 1.4% | 8927.9 ± 0.9% | 1134.3 ± 1.3% | 2.260 | 9.693 | 93.065 | 3.777 | 29.725 |
| hex: silesia/sao | 524290 | 33831.5 ± 1.1% | 14960.3 ± 1.1% | 3474.9 ± 0.8% | 277.4 ± 0.9% | 8888.1 ± 1.0% | 1125.0 ± 1.2% | 2.261 | 9.736 | 121.939 | 3.806 | 30.071 |
| hex: silesia/webster | 524290 | 33729.5 ± 0.7% | 14953.8 ± 0.2% | 3538.0 ± 0.9% | 449.8 ± 1.1% | 8932.2 ± 1.2% | 1124.7 ± 0.8% | 2.256 | 9.533 | 74.988 | 3.776 | 29.990 |
| hex: silesia/x-ray | 524290 | 33937.7 ± 0.8% | 15040.0 ± 1.0% | 3494.8 ± 0.8% | 426.0 ± 0.8% | 8881.3 ± 1.0% | 1121.4 ± 0.9% | 2.257 | 9.711 | 79.659 | 3.821 | 30.265 |
| hex: silesia/xml | 524290 | 33940.6 ± 1.1% | 15008.9 ± 0.6% | 3561.5 ± 0.7% | 708.5 ± 1.6% | 8903.9 ± 5.7% | 1125.2 ± 0.7% | 2.261 | 9.530 | 47.907 | 3.812 | 30.163 |
| hex: canterbury/alice29.txt | 304180 | 33898.4 ± 1.3% | 14035.9 ± 0.7% | 3542.3 ± 1.2% | 481.5 ± 1.2% | 8895.2 ± 1.2% | 1117.1 ± 2.8% | 2.415 | 9.570 | 70.409 | 3.811 | 30.345 |
| hex: canterbury/asyoulik.txt | 250360 | 33676.3 ± 1.4% | 14906.4 ± 1.1% | 3491.5 ± 1.2% | 470.1 ± 1.2% | 8967.1 ± 1.1% | 1130.7 ± 1.1% | 2.259 | 9.645 | 71.629 | 3.756 | 29.784 |
| hex: canterbury/cp.html | 49208 | 33524.2 ± 0.1% | 14414.1 ± 1.5% | 3574.3 ± 2.4% | 499.9 ± 0.6% | 9337.3 ± 0.2% | 1115.8 ± 1.6% | 2.326 | 9.379 | 67.064 | 3.590 | 30.044 |
| hex: canterbury/fields.c | 22302 | 32920.1 ± 1.2% | 17271.3 ± 0.4% | 3660.8 ± 1.4% | 526.4 ± 1.4% | 9306.0 ± 1.0% | 1083.6 ± 1.0% | 1.906 | 8.993 | 62.533 | 3.538 | 30.379 |
| hex: canterbury/grammar.lsp | 7444 | 29578.5 ± 0.9% | 17201.5 ± 5.8% | 3596.5 ± 1.5% | 693.8 ± 1.4% | 8955.8 ± 1.6% | 1031.6 ± 1.5% | 1.720 | 8.224 | 42.634 | 3.303 | 28.673 |
| hex: canterbury/kennedy.xls | 524290 | 33978.8 ± 0.8% | 15009.1 ± 3.4% | 3565.9 ± 0.5% | 756.7 ± 0.5% | 8972.1 ± 0.9% | 1053.8 ± 4.0% | 2.264 | 9.529 | 44.907 | 3.787 | 32.245 |
| hex: canterbury/lcet10.txt | 524290 | 33997.7 ± 0.2% | 15076.2 ± 0.4% | 3574.6 ± 0.2% | 486.7 ± 0.5% | 8982.9 ± 0.2% | 1097.3 ± 1.6% | 2.255 | 9.511 | 69.853 | 3.785 | 30.984 |
| hex: canterbury/plrabn12.txt | 524290 | 33938.1 ± 1.1% | 15042.9 ± 0.7% | 3569.7 ± 1.0% | 466.9 ± 0.9% | 8932.9 ± 1.2% | 1080.7 ± 2.4% | 2.256 | 9.507 | 72.692 | 3.799 | 31.403 |
| hex: canterbury/ptt5 | 524290 | 33676.2 ± 5.0% | 14990.5 ± 1.1% | 3466.7 ± 0.5% | 659.7 ± 1.2% | 8891.7 ± 0.4% | 1089.0 ± 3.2% | 2.247 | 9.714 | 51.048 | 3.787 | 30.924 |
| hex: canterbury/sum | 76482 | 33167.1 ± 1.0% | 15239.2 ± 0.6% | 3551.9 ± 1.2% | 571.5 ± 1.1% | 8917.8 ± 1.0% | 1098.3 ± 3.5% | 2.176 | 9.338 | 58.031 | 3.719 | 30.199 |
| hex: canterbury/xargs.1 | 8456 | 30183.0 ± 4.1% | 17300.3 ± 0.4% | 3547.8 ± 0.4% | 680.9 ± 2.2% | 8974.6 ± 0.6% | 1091.0 ± 1.3% | 1.745 | 8.507 | 44.329 | 3.363 | 27.664 |
| hex: canterbury-large/E.coli | 524290 | 33733.6 ± 0.6% | 14970.7 ± 0.9% | 3472.2 ± 3.3% | 957.5 ± 0.6% | 8896.5 ± 0.2% | 1100.0 ± 6.6% | 2.253 | 9.715 | 35.231 | 3.792 | 30.668 |
| hex: canterbury-large/bible.txt | 524290 | 33663.4 ± 0.3% | 14964.4 ± 3.3% | 3468.5 ± 0.8% | 497.6 ± 1.1% | 8880.6 ± 0.7% | 1102.5 ± 1.8% | 2.250 | 9.706 | 67.646 | 3.791 | 30.533 |
| hex: canterbury-large/world192.txt | 524290 | 33701.3 ± 0.7% | 14971.4 ± 0.3% | 3537.7 ± 3.2% | 460.7 ± 0.3% | 8907.4 ± 0.4% | 1107.5 ± 5.4% | 2.251 | 9.526 | 73.147 | 3.784 | 30.429 |
| hex: http/html-1kx1024 | 2099200 | 14517.0 ± 0.5% | 11981.0 ± 0.4% | 3096.6 ± 0.4% | 490.4 ± 3.7% | 7645.0 ± 1.0% | 940.0 ± 1.3% | 1.212 | 4.688 | 29.603 | 1.899 | 15.444 |
| hex: http/html-16kx64 | 2097280 | 27155.3 ± 0.5% | 13896.0 ± 1.4% | 3357.6 ± 0.8% | 498.5 ± 1.3% | 8450.8 ± 0.7% | 1062.1 ± 4.0% | 1.954 | 8.088 | 54.477 | 3.213 | 25.567 |
| hex: http/html-1m | 524290 | 33782.1 ± 0.3% | 14978.0 ± 2.8% | 3466.4 ± 0.7% | 497.8 ± 1.4% | 8895.3 ± 0.6% | 1103.5 ± 1.8% | 2.255 | 9.746 | 67.862 | 3.798 | 30.612 |
| hex: http/json-1kx1024 | 2099200 | 14653.8 ± 0.3% | 11850.0 ± 12.2% | 3109.5 ± 0.7% | 654.8 ± 0.3% | 7661.4 ± 3.0% | 945.3 ± 3.1% | 1.237 | 4.713 | 22.381 | 1.913 | 15.503 |
| hex: http/json-16kx64 | 2097280 | 26838.9 ± 4.4% | 13765.4 ± 0.5% | 3364.1 ± 0.6% | 665.9 ± 0.7% | 8291.1 ± 1.2% | 1045.7 ± 3.3% | 1.950 | 7.978 | 40.307 | 3.237 | 25.665 |
| hex: http/json-1m | 524290 | 33748.1 ± 0.2% | 14963.7 ± 1.1% | 3545.5 ± 0.5% | 696.1 ± 0.5% | 8901.4 ± 4.6% | 1105.8 ± 3.1% | 2.255 | 9.519 | 48.484 | 3.791 | 30.520 |
| hex: http/js-1kx1024 | 2099200 | 14743.7 ± 3.2% | 12393.5 ± 3.5% | 3120.7 ± 1.2% | 477.2 ± 1.5% | 7632.5 ± 1.6% | 945.4 ± 2.6% | 1.190 | 4.725 | 30.898 | 1.932 | 15.595 |
| hex: http/js-16kx64 | 2097280 | 27182.1 ± 0.9% | 13748.1 ± 0.5% | 3350.8 ± 3.4% | 478.8 ± 1.2% | 8482.3 ± 1.0% | 1051.8 ± 3.2% | 1.977 | 8.112 | 56.775 | 3.205 | 25.844 |
| hex: http/js-1m | 524290 | 33787.2 ± 0.8% | 14933.4 ± 0.4% | 3534.0 ± 1.1% | 494.2 ± 1.5% | 8887.1 ± 1.1% | 1101.8 ± 1.6% | 2.263 | 9.561 | 68.363 | 3.802 | 30.664 |
| hex: http/css-1kx1024 | 2099200 | 14803.1 ± 1.3% | 11965.5 ± 6.5% | 3119.0 ± 0.4% | 550.7 ± 1.1% | 7685.7 ± 1.2% | 957.9 ± 2.6% | 1.237 | 4.746 | 26.880 | 1.926 | 15.454 |
| hex: http/css-16kx64 | 2097280 | 27422.0 ± 0.3% | 13798.3 ± 0.4% | 3351.3 ± 0.6% | 561.9 ± 0.9% | 8408.3 ± 2.1% | 1051.6 ± 4.3% | 1.987 | 8.182 | 48.804 | 3.261 | 26.076 |
| hex: http/css-1m | 524290 | 33668.9 ± 0.8% | 14954.3 ± 2.6% | 3545.1 ± 0.7% | 538.6 ± 4.7% | 8899.8 ± 0.6% | 1092.4 ± 2.6% | 2.251 | 9.497 | 62.513 | 3.783 | 30.820 |
| hex: shuffled/dickens-1m | 524290 | 33712.9 ± 0.5% | 14967.0 ± 0.6% | 3469.8 ± 0.8% | 474.3 ± 1.1% | 8902.4 ± 1.0% | 1096.4 ± 1.6% | 2.252 | 9.716 | 71.085 | 3.787 | 30.749 |

## TextReader.next_items against the baselines

stdx's decoder a slice of tokens a call through `TextReader.next_items`, as a caller that reads a text's values in a loop calls it (decision 79). Octets are the text's. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1272.6 ± 0.5% | 1496.1 ± 2.7% | 1099.2 ± 0.7% | 390.3 ± 0.9% | 652.6 ± 1.0% | 362.3 ± 1.8% | 0.851 | 1.158 | 3.261 | 1.950 | 3.513 |
| qlog records, JSON text sequence | 1467503 | 1137.9 ± 0.6% | 1224.7 ± 2.0% | 1094.3 ± 0.5% | 325.8 ± 0.9% | 725.7 ± 1.2% | 315.1 ± 0.9% | 0.929 | 1.040 | 3.493 | 1.568 | 3.611 |
| messages: 11 string members | 1025025 | 1014.0 ± 0.7% | 1967.1 ± 2.4% | 769.8 ± 1.2% | 335.0 ± 0.8% | 495.4 ± 0.8% | 303.5 ± 1.0% | 0.515 | 1.317 | 3.027 | 2.047 | 3.341 |
| messages: 50 nested objects | 1121600 | 1293.1 ± 0.7% | 1735.5 ± 0.9% | 1431.8 ± 0.9% | 426.6 ± 0.9% | 902.2 ± 0.9% | 419.5 ± 0.8% | 0.745 | 0.903 | 3.031 | 1.433 | 3.083 |
| string: silesia/dickens | 172528 | 6679.0 ± 0.6% | 3420.0 ± 3.5% | 2829.2 ± 1.7% | 315.5 ± 0.8% | 3338.8 ± 1.2% | 567.1 ± 1.8% | 1.953 | 2.361 | 21.169 | 2.000 | 11.778 |
| string: silesia/nci | 1075110 | 5421.1 ± 0.6% | 3889.1 ± 0.6% | 2979.8 ± 0.8% | 652.4 ± 0.9% | 3673.8 ± 0.7% | 574.3 ± 0.9% | 1.394 | 1.819 | 8.310 | 1.476 | 9.439 |
| string: silesia/reymont | 1075159 | 3461.4 ± 1.9% | 3374.6 ± 1.4% | 1985.8 ± 2.4% | 338.5 ± 0.4% | 2068.8 ± 0.4% | 490.6 ± 1.7% | 1.026 | 1.743 | 10.225 | 1.673 | 7.056 |
| string: silesia/samba | 97582 | 3984.0 ± 1.1% | 3766.0 ± 0.7% | 3101.7 ± 0.3% | 325.7 ± 1.1% | 2044.7 ± 0.7% | 416.5 ± 1.4% | 1.058 | 1.284 | 12.233 | 1.948 | 9.565 |
| string: silesia/webster | 1098490 | 4408.7 ± 0.9% | 2418.4 ± 0.6% | 1729.3 ± 0.8% | 306.6 ± 1.4% | 2100.2 ± 1.1% | 461.3 ± 2.5% | 1.823 | 2.549 | 14.379 | 2.099 | 9.558 |
| string: silesia/xml | 1090118 | 6088.0 ± 1.0% | 5008.0 ± 0.9% | 2471.6 ± 1.1% | 505.3 ± 1.3% | 3348.7 ± 0.7% | 538.2 ± 1.9% | 1.216 | 2.463 | 12.048 | 1.818 | 11.312 |
| string: canterbury/alice29.txt | 159425 | 5829.7 ± 1.4% | 2748.3 ± 1.2% | 2881.6 ± 1.8% | 298.6 ± 1.3% | 3021.7 ± 1.4% | 513.8 ± 2.1% | 2.121 | 2.023 | 19.521 | 1.929 | 11.347 |
| string: canterbury/asyoulik.txt | 132198 | 4294.4 ± 1.1% | 2624.6 ± 2.0% | 2685.4 ± 1.0% | 305.8 ± 1.3% | 2452.9 ± 1.0% | 451.8 ± 1.4% | 1.636 | 1.599 | 14.046 | 1.751 | 9.506 |
| string: canterbury/lcet10.txt | 441884 | 6639.2 ± 0.5% | 3251.5 ± 1.0% | 2350.5 ± 1.2% | 345.5 ± 2.0% | 3002.1 ± 1.6% | 556.7 ± 3.3% | 2.042 | 2.825 | 19.216 | 2.211 | 11.925 |
| string: canterbury/plrabn12.txt | 503330 | 5454.3 ± 0.2% | 3136.3 ± 1.1% | 1842.6 ± 2.3% | 320.4 ± 0.7% | 2859.7 ± 0.4% | 527.0 ± 1.2% | 1.739 | 2.960 | 17.023 | 1.907 | 10.350 |
| string: canterbury-large/E.coli | 1048578 | 31834.5 ± 0.6% | 12881.3 ± 0.4% | 3337.2 ± 0.9% | 1270.7 ± 0.6% | 8487.7 ± 0.6% | 936.6 ± 3.7% | 2.471 | 9.539 | 25.053 | 3.751 | 33.990 |
| string: canterbury-large/bible.txt | 1055886 | 8525.5 ± 1.4% | 5225.4 ± 0.9% | 2782.6 ± 0.5% | 356.8 ± 0.8% | 3844.7 ± 0.4% | 616.2 ± 2.4% | 1.632 | 3.064 | 23.891 | 2.218 | 13.835 |
| string: canterbury-large/world192.txt | 1103121 | 4142.6 ± 0.8% | 2287.3 ± 0.4% | 1784.4 ± 0.4% | 326.3 ± 0.8% | 2167.7 ± 0.6% | 461.8 ± 1.5% | 1.811 | 2.322 | 12.698 | 1.911 | 8.970 |
| string: http/html-1m | 1058582 | 9347.5 ± 4.3% | 4700.3 ± 2.1% | 2683.8 ± 2.3% | 426.1 ± 0.5% | 3534.9 ± 0.9% | 589.8 ± 3.6% | 1.989 | 3.483 | 21.938 | 2.644 | 15.850 |
| string: http/json-1m | 1190272 | 3258.2 ± 2.2% | 1241.9 ± 3.2% | 2119.1 ± 0.7% | 468.0 ± 1.3% | 1366.3 ± 1.0% | 432.6 ± 1.6% | 2.624 | 1.538 | 6.962 | 2.385 | 7.532 |
| string: http/js-1m | 1144362 | 2864.9 ± 0.7% | 1596.9 ± 0.8% | 1321.4 ± 0.6% | 326.5 ± 1.0% | 1403.4 ± 0.9% | 375.6 ± 2.3% | 1.794 | 2.168 | 8.774 | 2.041 | 7.627 |
| string: http/css-1m | 1097820 | 3308.4 ± 0.4% | 2879.2 ± 0.3% | 2284.5 ± 0.5% | 457.6 ± 2.6% | 2103.0 ± 0.8% | 436.6 ± 2.7% | 1.149 | 1.448 | 7.229 | 1.573 | 7.578 |
| string: dickens as Cyrillic and CJK | 1883069 | 5790.8 ± 2.0% | 3055.5 ± 1.9% | 683.4 ± 0.3% | 376.2 ± 1.1% | 494.2 ± 0.9% | 162.0 ± 3.3% | 1.895 | 8.473 | 15.395 | 11.716 | 35.755 |
| string: dickens as Cyrillic and CJK, as \u escapes | 5075485 | 1207.9 ± 2.3% | 1235.4 ± 2.1% | 1101.7 ± 0.4% | 262.3 ± 0.8% | 466.7 ± 0.7% | 222.4 ± 3.0% | 0.978 | 1.096 | 4.605 | 2.588 | 5.431 |
| hex: silesia/dickens | 524290 | 33887.9 ± 1.0% | 14992.3 ± 1.1% | 3544.6 ± 3.4% | 476.4 ± 0.9% | 8919.4 ± 0.6% | 1128.5 ± 4.9% | 2.260 | 9.561 | 71.127 | 3.799 | 30.030 |
| hex: silesia/mozilla | 524290 | 33838.2 ± 1.0% | 14986.6 ± 1.2% | 3479.3 ± 1.3% | 425.9 ± 1.3% | 8891.2 ± 1.2% | 1128.0 ± 1.3% | 2.258 | 9.726 | 79.446 | 3.806 | 29.998 |
| hex: silesia/mr | 524290 | 33776.9 ± 0.6% | 14946.5 ± 0.5% | 3468.2 ± 3.9% | 643.7 ± 0.5% | 8871.4 ± 0.4% | 1128.3 ± 1.5% | 2.260 | 9.739 | 52.474 | 3.807 | 29.937 |
| hex: silesia/nci | 524290 | 33738.0 ± 0.6% | 14919.5 ± 0.7% | 3531.4 ± 0.3% | 754.7 ± 1.7% | 8895.5 ± 4.6% | 1129.5 ± 0.6% | 2.261 | 9.554 | 44.703 | 3.793 | 29.869 |
| hex: silesia/ooffice | 524290 | 33738.8 ± 0.9% | 14942.6 ± 1.0% | 3485.3 ± 0.8% | 342.7 ± 0.6% | 8898.7 ± 0.8% | 1131.0 ± 1.6% | 2.258 | 9.680 | 98.457 | 3.791 | 29.832 |
| hex: silesia/osdb | 524290 | 33910.5 ± 0.5% | 15035.1 ± 0.8% | 3493.3 ± 0.6% | 454.3 ± 1.5% | 8911.4 ± 0.8% | 1134.5 ± 0.7% | 2.255 | 9.707 | 74.648 | 3.805 | 29.890 |
| hex: silesia/reymont | 524290 | 33784.2 ± 0.2% | 14993.0 ± 0.7% | 3524.8 ± 0.8% | 492.0 ± 0.8% | 8898.5 ± 0.6% | 1128.4 ± 1.8% | 2.253 | 9.585 | 68.672 | 3.797 | 29.940 |
| hex: silesia/samba | 524290 | 33741.6 ± 0.7% | 14918.9 ± 0.9% | 3478.6 ± 1.1% | 362.3 ± 1.4% | 8927.9 ± 0.9% | 1134.3 ± 1.3% | 2.262 | 9.700 | 93.133 | 3.779 | 29.746 |
| hex: silesia/sao | 524290 | 33897.5 ± 1.5% | 14960.3 ± 1.1% | 3474.9 ± 0.8% | 277.4 ± 0.9% | 8888.1 ± 1.0% | 1125.0 ± 1.2% | 2.266 | 9.755 | 122.177 | 3.814 | 30.130 |
| hex: silesia/webster | 524290 | 33749.0 ± 1.2% | 14953.8 ± 0.2% | 3538.0 ± 0.9% | 449.8 ± 1.1% | 8932.2 ± 1.2% | 1124.7 ± 0.8% | 2.257 | 9.539 | 75.032 | 3.778 | 30.007 |
| hex: silesia/x-ray | 524290 | 33985.1 ± 1.1% | 15040.0 ± 1.0% | 3494.8 ± 0.8% | 426.0 ± 0.8% | 8881.3 ± 1.0% | 1121.4 ± 0.9% | 2.260 | 9.724 | 79.770 | 3.827 | 30.307 |
| hex: silesia/xml | 524290 | 33882.5 ± 4.9% | 15008.9 ± 0.6% | 3561.5 ± 0.7% | 708.5 ± 1.6% | 8903.9 ± 5.7% | 1125.2 ± 0.7% | 2.257 | 9.514 | 47.825 | 3.805 | 30.111 |
| hex: canterbury/alice29.txt | 304180 | 33720.3 ± 1.3% | 14035.9 ± 0.7% | 3542.3 ± 1.2% | 481.5 ± 1.2% | 8895.2 ± 1.2% | 1117.1 ± 2.8% | 2.402 | 9.519 | 70.039 | 3.791 | 30.186 |
| hex: canterbury/asyoulik.txt | 250360 | 33591.9 ± 4.6% | 14906.4 ± 1.1% | 3491.5 ± 1.2% | 470.1 ± 1.2% | 8967.1 ± 1.1% | 1130.7 ± 1.1% | 2.254 | 9.621 | 71.450 | 3.746 | 29.710 |
| hex: canterbury/cp.html | 49208 | 33487.9 ± 0.2% | 14414.1 ± 1.5% | 3574.3 ± 2.4% | 499.9 ± 0.6% | 9337.3 ± 0.2% | 1115.8 ± 1.6% | 2.323 | 9.369 | 66.991 | 3.586 | 30.011 |
| hex: canterbury/fields.c | 22302 | 33031.6 ± 0.6% | 17271.3 ± 0.4% | 3660.8 ± 1.4% | 526.4 ± 1.4% | 9306.0 ± 1.0% | 1083.6 ± 1.0% | 1.913 | 9.023 | 62.745 | 3.550 | 30.482 |
| hex: canterbury/grammar.lsp | 7444 | 29604.1 ± 1.3% | 17201.5 ± 5.8% | 3596.5 ± 1.5% | 693.8 ± 1.4% | 8955.8 ± 1.6% | 1031.6 ± 1.5% | 1.721 | 8.231 | 42.671 | 3.306 | 28.697 |
| hex: canterbury/kennedy.xls | 524290 | 34025.5 ± 0.5% | 15009.1 ± 3.4% | 3565.9 ± 0.5% | 756.7 ± 0.5% | 8972.1 ± 0.9% | 1053.8 ± 4.0% | 2.267 | 9.542 | 44.968 | 3.792 | 32.290 |
| hex: canterbury/lcet10.txt | 524290 | 34036.0 ± 0.1% | 15076.2 ± 0.4% | 3574.6 ± 0.2% | 486.7 ± 0.5% | 8982.9 ± 0.2% | 1097.3 ± 1.6% | 2.258 | 9.522 | 69.932 | 3.789 | 31.019 |
| hex: canterbury/plrabn12.txt | 524290 | 33793.7 ± 1.2% | 15042.9 ± 0.7% | 3569.7 ± 1.0% | 466.9 ± 0.9% | 8932.9 ± 1.2% | 1080.7 ± 2.4% | 2.246 | 9.467 | 72.382 | 3.783 | 31.269 |
| hex: canterbury/ptt5 | 524290 | 33756.5 ± 0.9% | 14990.5 ± 1.1% | 3466.7 ± 0.5% | 659.7 ± 1.2% | 8891.7 ± 0.4% | 1089.0 ± 3.2% | 2.252 | 9.737 | 51.170 | 3.796 | 30.998 |
| hex: canterbury/sum | 76482 | 33116.4 ± 1.0% | 15239.2 ± 0.6% | 3551.9 ± 1.2% | 571.5 ± 1.1% | 8917.8 ± 1.0% | 1098.3 ± 3.5% | 2.173 | 9.324 | 57.943 | 3.713 | 30.153 |
| hex: canterbury/xargs.1 | 8456 | 30156.3 ± 0.6% | 17300.3 ± 0.4% | 3547.8 ± 0.4% | 680.9 ± 2.2% | 8974.6 ± 0.6% | 1091.0 ± 1.3% | 1.743 | 8.500 | 44.290 | 3.360 | 27.640 |
| hex: canterbury-large/E.coli | 524290 | 33685.1 ± 0.9% | 14970.7 ± 0.9% | 3472.2 ± 3.3% | 957.5 ± 0.6% | 8896.5 ± 0.2% | 1100.0 ± 6.6% | 2.250 | 9.701 | 35.180 | 3.786 | 30.624 |
| hex: canterbury-large/bible.txt | 524290 | 33757.1 ± 0.3% | 14964.4 ± 3.3% | 3468.5 ± 0.8% | 497.6 ± 1.1% | 8880.6 ± 0.7% | 1102.5 ± 1.8% | 2.256 | 9.733 | 67.834 | 3.801 | 30.618 |
| hex: canterbury-large/world192.txt | 524290 | 33739.8 ± 4.7% | 14971.4 ± 0.3% | 3537.7 ± 3.2% | 460.7 ± 0.3% | 8907.4 ± 0.4% | 1107.5 ± 5.4% | 2.254 | 9.537 | 73.230 | 3.788 | 30.464 |
| hex: http/html-1kx1024 | 2099200 | 14154.6 ± 0.7% | 11981.0 ± 0.4% | 3096.6 ± 0.4% | 490.4 ± 3.7% | 7645.0 ± 1.0% | 940.0 ± 1.3% | 1.181 | 4.571 | 28.864 | 1.851 | 15.058 |
| hex: http/html-16kx64 | 2097280 | 27155.2 ± 0.4% | 13896.0 ± 1.4% | 3357.6 ± 0.8% | 498.5 ± 1.3% | 8450.8 ± 0.7% | 1062.1 ± 4.0% | 1.954 | 8.088 | 54.477 | 3.213 | 25.567 |
| hex: http/html-1m | 524290 | 33742.3 ± 0.7% | 14978.0 ± 2.8% | 3466.4 ± 0.7% | 497.8 ± 1.4% | 8895.3 ± 0.6% | 1103.5 ± 1.8% | 2.253 | 9.734 | 67.782 | 3.793 | 30.576 |
| hex: http/json-1kx1024 | 2099200 | 14306.7 ± 2.1% | 11850.0 ± 12.2% | 3109.5 ± 0.7% | 654.8 ± 0.3% | 7661.4 ± 3.0% | 945.3 ± 3.1% | 1.207 | 4.601 | 21.850 | 1.867 | 15.135 |
| hex: http/json-16kx64 | 2097280 | 26857.1 ± 0.3% | 13765.4 ± 0.5% | 3364.1 ± 0.6% | 665.9 ± 0.7% | 8291.1 ± 1.2% | 1045.7 ± 3.3% | 1.951 | 7.984 | 40.335 | 3.239 | 25.683 |
| hex: http/json-1m | 524290 | 33690.5 ± 0.7% | 14963.7 ± 1.1% | 3545.5 ± 0.5% | 696.1 ± 0.5% | 8901.4 ± 4.6% | 1105.8 ± 3.1% | 2.251 | 9.502 | 48.401 | 3.785 | 30.468 |
| hex: http/js-1kx1024 | 2099200 | 14381.3 ± 1.0% | 12393.5 ± 3.5% | 3120.7 ± 1.2% | 477.2 ± 1.5% | 7632.5 ± 1.6% | 945.4 ± 2.6% | 1.160 | 4.608 | 30.138 | 1.884 | 15.212 |
| hex: http/js-16kx64 | 2097280 | 27203.8 ± 0.5% | 13748.1 ± 0.5% | 3350.8 ± 3.4% | 478.8 ± 1.2% | 8482.3 ± 1.0% | 1051.8 ± 3.2% | 1.979 | 8.119 | 56.821 | 3.207 | 25.864 |
| hex: http/js-1m | 524290 | 33634.1 ± 0.6% | 14933.4 ± 0.4% | 3534.0 ± 1.1% | 494.2 ± 1.5% | 8887.1 ± 1.1% | 1101.8 ± 1.6% | 2.252 | 9.517 | 68.053 | 3.785 | 30.525 |
| hex: http/css-1kx1024 | 2099200 | 14471.8 ± 0.8% | 11965.5 ± 6.5% | 3119.0 ± 0.4% | 550.7 ± 1.1% | 7685.7 ± 1.2% | 957.9 ± 2.6% | 1.209 | 4.640 | 26.278 | 1.883 | 15.108 |
| hex: http/css-16kx64 | 2097280 | 27437.0 ± 0.3% | 13798.3 ± 0.4% | 3351.3 ± 0.6% | 561.9 ± 0.9% | 8408.3 ± 2.1% | 1051.6 ± 4.3% | 1.988 | 8.187 | 48.831 | 3.263 | 26.091 |
| hex: http/css-1m | 524290 | 33741.4 ± 0.8% | 14954.3 ± 2.6% | 3545.1 ± 0.7% | 538.6 ± 4.7% | 8899.8 ± 0.6% | 1092.4 ± 2.6% | 2.256 | 9.518 | 62.648 | 3.791 | 30.887 |
| hex: shuffled/dickens-1m | 524290 | 33709.9 ± 0.5% | 14967.0 ± 0.6% | 3469.8 ± 0.8% | 474.3 ± 1.1% | 8902.4 ± 1.0% | 1096.4 ± 1.6% | 2.252 | 9.715 | 71.079 | 3.787 | 30.746 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1566.9 ± 1.3% | 1457.5 ± 1.5% | 1011.8 ± 1.0% | 464.5 ± 0.6% | 446.1 ± 3.1% | 499.2 ± 0.8% | 1.075 | 1.549 | 3.373 | 3.512 | 3.139 |
| qlog records, JSON text sequence | 1467503 | 1439.3 ± 0.8% | 1208.2 ± 2.7% | 918.0 ± 1.0% | 427.3 ± 1.4% | 532.8 ± 1.9% | 352.5 ± 1.5% | 1.191 | 1.568 | 3.368 | 2.701 | 4.083 |
| messages: 11 string members | 1025025 | 1240.8 ± 0.8% | 1089.7 ± 0.3% | 739.4 ± 1.1% | 408.7 ± 0.9% | 423.1 ± 0.6% | 430.4 ± 1.3% | 1.139 | 1.678 | 3.036 | 2.933 | 2.883 |
| messages: 50 nested objects | 1121600 | 1678.0 ± 0.6% | 1847.8 ± 0.5% | 1315.9 ± 1.1% | 590.7 ± 0.8% | 615.1 ± 1.3% | 507.4 ± 1.1% | 0.908 | 1.275 | 2.841 | 2.728 | 3.307 |
| string: silesia/dickens | 172528 | 13056.2 ± 0.9% | 3906.5 ± 0.9% | 3096.8 ± 0.9% | 330.7 ± 1.3% | 1712.9 ± 2.1% | 1180.4 ± 0.7% | 3.342 | 4.216 | 39.476 | 7.622 | 11.061 |
| string: silesia/nci | 1075110 | 11179.5 ± 0.3% | 4635.2 ± 0.5% | 3142.1 ± 1.2% | 908.9 ± 0.5% | 1905.4 ± 2.5% | 1197.1 ± 1.0% | 2.412 | 3.558 | 12.300 | 5.867 | 9.339 |
| string: silesia/reymont | 1075159 | 5414.5 ± 1.7% | 1841.7 ± 1.8% | 2006.9 ± 0.6% | 376.7 ± 1.2% | 1421.9 ± 1.2% | 1033.5 ± 1.4% | 2.940 | 2.698 | 14.374 | 3.808 | 5.239 |
| string: silesia/samba | 97582 | 6299.8 ± 0.4% | 2694.9 ± 1.7% | 4066.1 ± 1.0% | 347.8 ± 0.9% | 1327.1 ± 1.5% | 1173.5 ± 0.9% | 2.338 | 1.549 | 18.113 | 4.747 | 5.368 |
| string: silesia/webster | 1098490 | 6879.5 ± 0.9% | 1965.4 ± 1.7% | 1868.4 ± 0.8% | 348.9 ± 0.5% | 1404.4 ± 1.2% | 599.0 ± 0.7% | 3.500 | 3.682 | 19.715 | 4.899 | 11.485 |
| string: silesia/xml | 1090118 | 10535.8 ± 0.7% | 3153.2 ± 0.9% | 2624.0 ± 0.8% | 602.2 ± 0.7% | 1949.9 ± 0.3% | 952.2 ± 0.8% | 3.341 | 4.015 | 17.496 | 5.403 | 11.064 |
| string: canterbury/alice29.txt | 159425 | 12655.9 ± 0.5% | 2864.4 ± 1.6% | 3144.6 ± 2.1% | 316.7 ± 0.9% | 1546.2 ± 1.4% | 1090.4 ± 0.7% | 4.418 | 4.025 | 39.959 | 8.185 | 11.606 |
| string: canterbury/asyoulik.txt | 132198 | 10667.1 ± 2.6% | 2094.9 ± 1.1% | 3104.3 ± 0.5% | 316.4 ± 1.4% | 1369.0 ± 1.1% | 957.6 ± 0.6% | 5.092 | 3.436 | 33.716 | 7.792 | 11.139 |
| string: canterbury/lcet10.txt | 441884 | 12066.9 ± 1.2% | 3071.2 ± 1.0% | 2640.9 ± 0.4% | 366.6 ± 0.6% | 1672.6 ± 0.7% | 1191.9 ± 0.4% | 3.929 | 4.569 | 32.914 | 7.215 | 10.124 |
| string: canterbury/plrabn12.txt | 503330 | 8352.3 ± 8.0% | 2305.5 ± 0.7% | 2159.5 ± 0.7% | 347.5 ± 1.2% | 1648.2 ± 2.3% | 1114.7 ± 1.9% | 3.623 | 3.868 | 24.034 | 5.067 | 7.493 |
| string: canterbury-large/E.coli | 1048578 | 28533.8 ± 1.5% | 15944.3 ± 1.7% | 3454.9 ± 1.0% | 1688.3 ± 2.0% | 3143.0 ± 0.6% | 1390.9 ± 0.4% | 1.790 | 8.259 | 16.901 | 9.079 | 20.514 |
| string: canterbury-large/bible.txt | 1055886 | 9363.1 ± 3.5% | 4805.4 ± 1.9% | 3031.0 ± 0.9% | 401.3 ± 0.7% | 2132.8 ± 0.8% | 1473.2 ± 0.4% | 1.948 | 3.089 | 23.332 | 4.390 | 6.356 |
| string: canterbury-large/world192.txt | 1103121 | 6605.8 ± 1.2% | 1711.5 ± 0.5% | 2003.3 ± 0.7% | 346.8 ± 1.8% | 1385.7 ± 1.9% | 959.7 ± 4.7% | 3.860 | 3.298 | 19.047 | 4.767 | 6.883 |
| string: http/html-1m | 1058582 | 10082.0 ± 0.7% | 4303.6 ± 1.1% | 2913.4 ± 1.1% | 417.6 ± 1.6% | 2153.1 ± 3.8% | 845.5 ± 1.0% | 2.343 | 3.461 | 24.145 | 4.683 | 11.925 |
| string: http/json-1m | 1190272 | 8213.5 ± 1.0% | 1572.6 ± 1.2% | 1958.1 ± 1.2% | 556.1 ± 1.3% | 1191.3 ± 1.2% | 844.1 ± 1.3% | 5.223 | 4.195 | 14.771 | 6.895 | 9.731 |
| string: http/js-1m | 1144362 | 6524.5 ± 1.0% | 1110.7 ± 0.7% | 1528.5 ± 1.3% | 331.7 ± 1.0% | 1113.4 ± 1.9% | 755.4 ± 1.2% | 5.874 | 4.268 | 19.669 | 5.860 | 8.637 |
| string: http/css-1m | 1097820 | 8715.2 ± 0.4% | 1460.8 ± 1.3% | 2357.5 ± 1.6% | 509.1 ± 1.0% | 1268.3 ± 0.7% | 875.6 ± 1.8% | 5.966 | 3.697 | 17.119 | 6.872 | 9.953 |
| string: dickens as Cyrillic and CJK | 1883069 | 5429.0 ± 1.0% | 3601.4 ± 1.2% | 500.6 ± 1.1% | 245.7 ± 0.8% | 449.6 ± 0.4% | 354.0 ± 3.2% | 1.507 | 10.844 | 22.094 | 12.076 | 15.337 |
| hex: silesia/dickens | 524290 | 42553.7 ± 0.6% | 2553.6 ± 0.4% | 1506.4 ± 1.1% | 461.5 ± 1.1% | 1558.7 ± 1.4% | 1064.5 ± 6.2% | 16.664 | 28.249 | 92.200 | 27.302 | 39.975 |
| hex: silesia/mozilla | 524290 | 42836.0 ± 1.5% | 2558.2 ± 10.0% | 1499.7 ± 1.2% | 385.0 ± 2.0% | 1558.9 ± 0.6% | 1059.0 ± 1.3% | 16.745 | 28.563 | 111.267 | 27.478 | 40.448 |
| hex: silesia/mr | 524290 | 43157.0 ± 1.1% | 2534.8 ± 0.4% | 1497.0 ± 5.9% | 594.6 ± 0.9% | 1558.2 ± 1.0% | 1058.6 ± 1.1% | 17.025 | 28.830 | 72.588 | 27.696 | 40.768 |
| hex: silesia/nci | 524290 | 42918.2 ± 2.0% | 2542.2 ± 0.8% | 1501.3 ± 0.7% | 756.1 ± 0.9% | 1556.2 ± 0.9% | 1062.1 ± 0.8% | 16.883 | 28.588 | 56.766 | 27.578 | 40.407 |
| hex: silesia/ooffice | 524290 | 43429.3 ± 0.4% | 2572.8 ± 0.4% | 1514.7 ± 0.4% | 322.6 ± 1.8% | 1572.3 ± 0.2% | 1061.9 ± 0.3% | 16.880 | 28.672 | 134.613 | 27.622 | 40.899 |
| hex: silesia/osdb | 524290 | 42856.6 ± 2.7% | 2567.1 ± 0.4% | 1506.1 ± 0.9% | 429.3 ± 0.6% | 1560.4 ± 0.5% | 1062.5 ± 0.4% | 16.695 | 28.455 | 99.840 | 27.465 | 40.335 |
| hex: silesia/reymont | 524290 | 42893.1 ± 0.9% | 2563.5 ± 0.4% | 1503.6 ± 0.7% | 481.1 ± 0.5% | 1558.9 ± 0.4% | 1054.4 ± 0.5% | 16.732 | 28.526 | 89.162 | 27.515 | 40.679 |
| hex: silesia/samba | 524290 | 42837.2 ± 8.3% | 2565.7 ± 0.5% | 1502.7 ± 0.3% | 334.0 ± 1.3% | 1562.7 ± 1.3% | 1063.2 ± 0.7% | 16.696 | 28.506 | 128.273 | 27.412 | 40.291 |
| hex: silesia/sao | 524290 | 42701.1 ± 1.2% | 2568.5 ± 0.3% | 1509.5 ± 0.8% | 270.6 ± 2.9% | 1556.7 ± 5.9% | 1055.5 ± 1.0% | 16.625 | 28.289 | 157.781 | 27.430 | 40.455 |
| hex: silesia/webster | 524290 | 43828.5 ± 0.3% | 2573.4 ± 0.7% | 1500.2 ± 5.1% | 435.0 ± 1.1% | 1570.1 ± 1.2% | 1068.9 ± 1.0% | 17.031 | 29.215 | 100.758 | 27.914 | 41.002 |
| hex: silesia/x-ray | 524290 | 42928.4 ± 0.9% | 2558.6 ± 0.7% | 1504.9 ± 2.8% | 420.9 ± 0.4% | 1556.9 ± 0.6% | 1055.1 ± 0.7% | 16.778 | 28.526 | 101.999 | 27.572 | 40.688 |
| hex: silesia/xml | 524290 | 43084.0 ± 1.9% | 2572.2 ± 0.5% | 1504.3 ± 0.9% | 685.6 ± 0.5% | 1553.6 ± 0.9% | 1054.7 ± 0.8% | 16.750 | 28.640 | 62.845 | 27.732 | 40.850 |
| hex: canterbury/alice29.txt | 304180 | 42673.8 ± 0.7% | 2590.5 ± 0.4% | 1534.1 ± 0.3% | 469.9 ± 1.0% | 1587.5 ± 0.7% | 1087.5 ± 0.4% | 16.473 | 27.816 | 90.818 | 26.882 | 39.242 |
| hex: canterbury/asyoulik.txt | 250360 | 42277.9 ± 0.5% | 2578.0 ± 0.4% | 1534.4 ± 0.7% | 454.9 ± 0.2% | 1577.0 ± 0.9% | 1082.8 ± 1.1% | 16.400 | 27.554 | 92.940 | 26.809 | 39.046 |
| hex: canterbury/cp.html | 49208 | 41053.0 ± 5.2% | 2557.6 ± 6.4% | 1527.1 ± 0.9% | 479.1 ± 1.5% | 1581.2 ± 0.6% | 1084.7 ± 0.7% | 16.052 | 26.884 | 85.694 | 25.964 | 37.847 |
| hex: canterbury/fields.c | 22302 | 42123.9 ± 1.9% | 2597.2 ± 1.1% | 1537.2 ± 0.5% | 597.8 ± 0.5% | 1589.8 ± 0.6% | 1091.7 ± 4.9% | 16.219 | 27.403 | 70.467 | 26.496 | 38.587 |
| hex: canterbury/grammar.lsp | 7444 | 40163.5 ± 1.4% | 2650.3 ± 0.7% | 1550.7 ± 0.8% | 813.0 ± 0.4% | 1592.6 ± 0.3% | 1103.8 ± 0.8% | 15.154 | 25.900 | 49.400 | 25.219 | 36.386 |
| hex: canterbury/kennedy.xls | 524290 | 42805.5 ± 1.7% | 2535.3 ± 0.5% | 1499.3 ± 0.4% | 769.4 ± 0.4% | 1509.0 ± 0.3% | 1059.6 ± 0.7% | 16.884 | 28.551 | 55.634 | 28.367 | 40.397 |
| hex: canterbury/lcet10.txt | 524290 | 43456.5 ± 0.6% | 2570.9 ± 1.0% | 1507.5 ± 0.6% | 467.8 ± 0.5% | 1563.9 ± 0.7% | 1064.0 ± 0.9% | 16.903 | 28.827 | 92.902 | 27.787 | 40.842 |
| hex: canterbury/plrabn12.txt | 524290 | 42522.1 ± 2.4% | 2565.2 ± 1.0% | 1500.9 ± 1.1% | 446.7 ± 1.0% | 1509.1 ± 0.9% | 1062.8 ± 1.2% | 16.577 | 28.332 | 95.192 | 28.178 | 40.010 |
| hex: canterbury/ptt5 | 524290 | 43181.4 ± 1.6% | 2541.1 ± 0.5% | 1495.3 ± 0.3% | 588.9 ± 3.9% | 1546.2 ± 0.6% | 1061.9 ± 0.5% | 16.993 | 28.878 | 73.331 | 27.928 | 40.665 |
| hex: canterbury/sum | 76482 | 42705.5 ± 0.7% | 2561.2 ± 0.2% | 1520.2 ± 0.7% | 560.1 ± 0.9% | 1570.7 ± 1.1% | 1083.5 ± 5.0% | 16.674 | 28.093 | 76.247 | 27.189 | 39.416 |
| hex: canterbury/xargs.1 | 8456 | 40989.7 ± 2.0% | 2643.4 ± 0.6% | 1558.7 ± 5.0% | 836.6 ± 0.8% | 1592.5 ± 1.2% | 1103.7 ± 0.8% | 15.507 | 26.298 | 48.996 | 25.740 | 37.139 |
| hex: canterbury-large/E.coli | 524290 | 43152.6 ± 1.4% | 2552.4 ± 0.7% | 1504.2 ± 0.9% | 811.1 ± 0.7% | 1553.8 ± 0.5% | 1057.5 ± 0.7% | 16.907 | 28.688 | 53.204 | 27.772 | 40.806 |
| hex: canterbury-large/bible.txt | 524290 | 42843.4 ± 2.1% | 2556.7 ± 0.9% | 1503.1 ± 6.0% | 478.6 ± 0.1% | 1554.8 ± 5.9% | 1058.1 ± 0.9% | 16.757 | 28.504 | 89.510 | 27.555 | 40.489 |
| hex: canterbury-large/world192.txt | 524290 | 42817.6 ± 1.4% | 2562.1 ± 0.5% | 1500.4 ± 0.2% | 456.1 ± 0.9% | 1557.7 ± 2.5% | 1057.8 ± 0.6% | 16.712 | 28.538 | 93.875 | 27.487 | 40.477 |
| hex: http/html-1kx1024 | 2099200 | 20944.2 ± 0.8% | 2305.3 ± 1.6% | 1471.0 ± 0.8% | 496.2 ± 0.5% | 1479.1 ± 1.3% | 1067.1 ± 1.2% | 9.085 | 14.238 | 42.205 | 14.160 | 19.628 |
| hex: http/html-16kx64 | 2097280 | 21431.6 ± 0.4% | 2201.8 ± 1.0% | 1448.8 ± 0.7% | 500.8 ± 1.0% | 1436.9 ± 0.9% | 1084.6 ± 0.9% | 9.734 | 14.793 | 42.796 | 14.915 | 19.760 |
| hex: http/html-1m | 524290 | 43497.4 ± 0.3% | 2558.8 ± 1.6% | 1508.5 ± 0.6% | 488.5 ± 0.6% | 1559.3 ± 1.1% | 1061.3 ± 0.8% | 16.999 | 28.835 | 89.043 | 27.895 | 40.983 |
| hex: http/json-1kx1024 | 2099200 | 20409.9 ± 0.6% | 2317.9 ± 1.5% | 1476.2 ± 1.0% | 697.0 ± 0.4% | 1491.9 ± 1.2% | 1079.6 ± 0.5% | 8.805 | 13.826 | 29.282 | 13.681 | 18.905 |
| hex: http/json-16kx64 | 2097280 | 21667.7 ± 0.4% | 2197.0 ± 0.6% | 1450.4 ± 1.1% | 703.9 ± 0.9% | 1434.7 ± 0.9% | 1077.4 ± 0.8% | 9.862 | 14.939 | 30.784 | 15.102 | 20.112 |
| hex: http/json-1m | 524290 | 43086.8 ± 1.5% | 2548.4 ± 0.7% | 1498.8 ± 1.3% | 719.7 ± 4.9% | 1515.3 ± 6.5% | 1059.4 ± 0.6% | 16.907 | 28.748 | 59.869 | 28.435 | 40.670 |
| hex: http/js-1kx1024 | 2099200 | 20231.6 ± 0.5% | 2299.9 ± 1.5% | 1467.4 ± 0.6% | 487.6 ± 0.4% | 1483.1 ± 1.1% | 1071.2 ± 0.5% | 8.797 | 13.788 | 41.494 | 13.641 | 18.886 |
| hex: http/js-16kx64 | 2097280 | 21305.0 ± 0.3% | 2204.8 ± 6.7% | 1451.4 ± 0.5% | 489.5 ± 0.5% | 1435.6 ± 0.5% | 1078.3 ± 0.6% | 9.663 | 14.679 | 43.524 | 14.840 | 19.757 |
| hex: http/js-1m | 524290 | 42938.9 ± 1.7% | 2572.5 ± 0.7% | 1500.5 ± 5.3% | 503.8 ± 1.6% | 1561.2 ± 0.4% | 1058.5 ± 5.2% | 16.691 | 28.617 | 85.225 | 27.503 | 40.564 |
| hex: http/css-1kx1024 | 2099200 | 20748.9 ± 1.0% | 2294.2 ± 2.6% | 1468.0 ± 0.9% | 552.8 ± 0.5% | 1473.6 ± 1.5% | 1071.1 ± 0.5% | 9.044 | 14.134 | 37.533 | 14.081 | 19.371 |
| hex: http/css-16kx64 | 2097280 | 21813.0 ± 0.7% | 2210.3 ± 0.8% | 1457.8 ± 0.9% | 560.9 ± 0.6% | 1442.7 ± 1.1% | 1082.6 ± 0.8% | 9.869 | 14.963 | 38.888 | 15.119 | 20.149 |
| hex: http/css-1m | 524290 | 43059.1 ± 0.9% | 2558.3 ± 10.1% | 1504.7 ± 0.2% | 528.3 ± 0.5% | 1514.3 ± 0.2% | 1055.3 ± 4.1% | 16.831 | 28.617 | 81.509 | 28.436 | 40.801 |
| hex: shuffled/dickens-1m | 524290 | 42763.1 ± 1.6% | 2565.8 ± 1.0% | 1500.5 ± 1.4% | 460.8 ± 1.1% | 1562.1 ± 0.8% | 1063.0 ± 0.7% | 16.667 | 28.499 | 92.801 | 27.376 | 40.230 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding: stdx runs at 0.914 of simdjson.
- qlog records, JSON text sequence, decoding: stdx runs at 0.885 of simdjson.
- messages: 11 string members, decoding: stdx runs at 0.535 of simdjson.
- messages: 50 nested objects, decoding: stdx runs at 0.771 of simdjson.
- messages: 50 nested objects, decoding: stdx runs at 0.934 of yyjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.764 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.823 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.921 of yyjson.
- messages: 11 string members, decoding through TextReader.next: stdx runs at 0.476 of simdjson.
- messages: 50 nested objects, decoding through TextReader.next: stdx runs at 0.711 of simdjson.
- messages: 50 nested objects, decoding through TextReader.next: stdx runs at 0.862 of yyjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next_items: stdx runs at 0.851 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next_items: stdx runs at 0.929 of simdjson.
- messages: 11 string members, decoding through TextReader.next_items: stdx runs at 0.515 of simdjson.
- messages: 50 nested objects, decoding through TextReader.next_items: stdx runs at 0.745 of simdjson.
- messages: 50 nested objects, decoding through TextReader.next_items: stdx runs at 0.903 of yyjson.
- messages: 50 nested objects, encoding through TextWriter's methods: stdx runs at 0.908 of simdjson.
