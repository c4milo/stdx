# bench-json

| Field | Value |
|---|---|
| Commit | 06a7341 |
| Runner label | ubuntu-24.04 |
| Image version | 20261101.360.1 |
| CPU model | AMD EPYC 7763 64-Core Processor |
| Virtual CPUs | 4 |
| Kernel | 7.0.0-1017-azure |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/42920490921 |
| Date | 2026-11-10 |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1020.4 ± 0.4% | 0.467 | 1.002 | 1.051 | 1.079 | 0.389 | 1.065 | 1.079 | 0.350 | 0.635 | 0.091 |
| qlog records, JSON text sequence | 1467503 | 781.3 ± 24.7% | 0.746 | 1.075 | 1.056 | 1.076 | 0.397 | 1.067 | 1.036 | 0.326 | 0.552 | 0.114 |
| string: silesia/dickens | 172528 | 5459.2 ± 0.5% | 0.023 | 0.660 | 1.030 | 1.041 | 0.171 | 1.011 | 1.043 | 0.171 | 0.171 | 0.023 |
| string: silesia/nci | 1075110 | 5152.4 ± 0.9% | 0.024 | 0.698 | 1.020 | 1.021 | 0.223 | 0.992 | 1.024 | 0.223 | 0.223 | 0.025 |
| string: silesia/reymont | 1075159 | 2771.8 ± 0.2% | 0.046 | 0.689 | 0.971 | 0.977 | 0.325 | 0.970 | 0.969 | 0.325 | 0.324 | 0.046 |
| string: silesia/samba | 97582 | 3342.6 ± 1.2% | 0.034 | 0.890 | 1.020 | 1.021 | 0.063 | 0.834 | 1.014 | 0.063 | 0.063 | 0.034 |
| string: silesia/webster | 1098490 | 3654.6 ± 0.6% | 0.034 | 0.671 | 1.028 | 1.053 | 0.183 | 1.013 | 1.053 | 0.184 | 0.183 | 0.034 |
| string: silesia/xml | 1090118 | 5093.9 ± 1.0% | 0.025 | 0.851 | 1.001 | 1.000 | 0.208 | 0.990 | 0.999 | 0.208 | 0.207 | 0.025 |
| string: canterbury/alice29.txt | 159425 | 4384.7 ± 6.2% | 0.028 | 0.739 | 1.042 | 1.120 | 0.158 | 1.062 | 1.118 | 0.158 | 0.156 | 0.028 |
| string: canterbury/asyoulik.txt | 132198 | 3791.9 ± 4.0% | 0.032 | 0.769 | 1.061 | 1.121 | 0.156 | 1.034 | 1.119 | 0.153 | 0.152 | 0.032 |
| string: canterbury/lcet10.txt | 441884 | 5682.8 ± 0.9% | 0.022 | 0.579 | 1.049 | 1.073 | 0.158 | 1.014 | 1.071 | 0.157 | 0.157 | 0.022 |
| string: canterbury/plrabn12.txt | 503330 | 4411.2 ± 0.4% | 0.028 | 0.765 | 1.039 | 1.080 | 0.178 | 1.016 | 1.080 | 0.178 | 0.177 | 0.028 |
| string: canterbury-large/E.coli | 1048578 | 37059.5 ± 2.0% | 0.041 | 1.023 | 0.602 | 1.029 | 0.484 | 1.036 | 1.032 | 0.482 | 0.484 | 0.004 |
| string: canterbury-large/bible.txt | 1055886 | 6658.1 ± 0.8% | 0.020 | 0.687 | 0.900 | 0.893 | 0.386 | 0.976 | 0.893 | 0.383 | 0.381 | 0.020 |
| string: canterbury-large/world192.txt | 1103121 | 3442.3 ± 0.5% | 0.036 | 0.702 | 1.021 | 1.054 | 0.178 | 1.013 | 1.053 | 0.179 | 0.177 | 0.036 |
| string: http/html-1m | 1058582 | 6234.1 ± 0.8% | 0.021 | 0.687 | 0.945 | 0.951 | 0.349 | 0.980 | 0.950 | 0.347 | 0.346 | 0.021 |
| string: http/json-1m | 1190272 | 3331.3 ± 0.4% | 0.036 | 0.380 | 0.431 | 0.433 | 0.088 | 0.391 | 0.434 | 0.088 | 0.088 | 0.036 |
| string: http/js-1m | 1144362 | 2256.9 ± 7.5% | 0.052 | 0.774 | 1.023 | 1.077 | 0.166 | 1.010 | 1.078 | 0.163 | 0.161 | 0.052 |
| string: http/css-1m | 1097820 | 3017.4 ± 0.5% | 0.040 | 0.731 | 1.016 | 1.091 | 0.205 | 1.035 | 1.086 | 0.206 | 0.205 | 0.040 |
| string: dickens as Cyrillic and CJK | 1883069 | 5159.3 ± 2.0% | 0.020 | 0.059 | 0.499 | 0.500 | 0.179 | 0.498 | 0.500 | 0.179 | 0.179 | 0.020 |
| string: dickens as Cyrillic and CJK, as \u escapes | 5075485 | 1058.4 ± 9.9% | 0.086 | 0.977 | 0.976 | 0.977 | 0.085 | 0.708 | 0.976 | 0.085 | 0.085 | 0.086 |
| hex: silesia/dickens | 524290 | 38253.7 ± 2.0% | 0.040 | 1.013 | 0.580 | 1.018 | 0.471 | 1.018 | 1.016 | 0.470 | 0.473 | 0.003 |
| hex: silesia/mozilla | 524290 | 38178.9 ± 6.2% | 0.040 | 1.025 | 0.583 | 1.027 | 0.469 | 1.031 | 1.026 | 0.469 | 0.470 | 0.003 |
| hex: silesia/mr | 524290 | 38314.0 ± 9.4% | 0.040 | 1.015 | 0.581 | 1.023 | 0.465 | 1.021 | 1.025 | 0.463 | 0.466 | 0.003 |
| hex: silesia/nci | 524290 | 37700.2 ± 3.0% | 0.040 | 1.010 | 0.588 | 1.013 | 0.475 | 1.024 | 1.022 | 0.474 | 0.477 | 0.004 |
| hex: silesia/ooffice | 524290 | 37583.6 ± 1.8% | 0.040 | 1.011 | 0.591 | 1.019 | 0.477 | 1.022 | 1.022 | 0.473 | 0.477 | 0.004 |
| hex: silesia/osdb | 524290 | 38107.9 ± 1.0% | 0.040 | 1.016 | 0.581 | 1.018 | 0.469 | 1.019 | 1.015 | 0.469 | 0.472 | 0.003 |
| hex: silesia/reymont | 524290 | 38401.2 ± 3.3% | 0.040 | 1.003 | 0.578 | 1.005 | 0.468 | 1.007 | 1.011 | 0.467 | 0.470 | 0.003 |
| hex: silesia/samba | 524290 | 36548.2 ± 0.7% | 0.042 | 1.011 | 0.608 | 1.013 | 0.485 | 1.014 | 1.015 | 0.484 | 0.487 | 0.004 |
| hex: silesia/sao | 524290 | 38108.8 ± 1.0% | 0.040 | 1.002 | 0.583 | 1.007 | 0.473 | 1.009 | 1.007 | 0.472 | 0.474 | 0.003 |
| hex: silesia/webster | 524290 | 38514.9 ± 1.3% | 0.040 | 1.006 | 0.575 | 1.010 | 0.466 | 1.011 | 1.011 | 0.466 | 0.470 | 0.003 |
| hex: silesia/x-ray | 524290 | 36651.3 ± 1.4% | 0.042 | 1.006 | 0.603 | 1.009 | 0.483 | 1.011 | 1.011 | 0.482 | 0.486 | 0.004 |
| hex: silesia/xml | 524290 | 38003.3 ± 0.3% | 0.040 | 1.010 | 0.584 | 1.016 | 0.474 | 1.013 | 1.019 | 0.472 | 0.475 | 0.004 |
| hex: canterbury/alice29.txt | 304180 | 37306.7 ± 0.9% | 0.041 | 1.004 | 0.589 | 1.010 | 0.478 | 1.011 | 1.012 | 0.475 | 0.477 | 0.004 |
| hex: canterbury/asyoulik.txt | 250360 | 39871.8 ± 0.5% | 0.038 | 1.000 | 0.562 | 1.015 | 0.457 | 1.012 | 1.015 | 0.460 | 0.459 | 0.003 |
| hex: canterbury/cp.html | 49208 | 38898.2 ± 0.9% | 0.040 | 0.995 | 0.557 | 0.991 | 0.467 | 0.996 | 0.992 | 0.471 | 0.472 | 0.003 |
| hex: canterbury/fields.c | 22302 | 37850.4 ± 1.0% | 0.041 | 1.002 | 0.560 | 0.989 | 0.463 | 1.002 | 0.988 | 0.471 | 0.477 | 0.004 |
| hex: canterbury/grammar.lsp | 7444 | 36470.4 ± 0.8% | 0.042 | 0.983 | 0.535 | 0.986 | 0.431 | 0.983 | 0.987 | 0.453 | 0.459 | 0.004 |
| hex: canterbury/kennedy.xls | 524290 | 37341.2 ± 3.0% | 0.041 | 1.015 | 0.590 | 1.018 | 0.478 | 1.021 | 1.024 | 0.476 | 0.479 | 0.004 |
| hex: canterbury/lcet10.txt | 524290 | 37929.9 ± 1.7% | 0.040 | 1.014 | 0.586 | 1.012 | 0.476 | 1.019 | 1.017 | 0.473 | 0.474 | 0.003 |
| hex: canterbury/plrabn12.txt | 524290 | 36739.9 ± 1.0% | 0.041 | 1.014 | 0.602 | 1.018 | 0.486 | 1.020 | 1.022 | 0.482 | 0.487 | 0.004 |
| hex: canterbury/ptt5 | 524290 | 38006.0 ± 4.4% | 0.040 | 1.024 | 0.587 | 1.020 | 0.476 | 1.027 | 1.029 | 0.476 | 0.478 | 0.003 |
| hex: canterbury/sum | 76482 | 40859.9 ± 1.1% | 0.037 | 1.002 | 0.547 | 0.998 | 0.450 | 1.005 | 0.998 | 0.453 | 0.453 | 0.003 |
| hex: canterbury/xargs.1 | 8456 | 38060.8 ± 3.9% | 0.040 | 0.974 | 0.521 | 0.981 | 0.424 | 0.989 | 0.985 | 0.442 | 0.451 | 0.003 |
| hex: canterbury-large/E.coli | 524290 | 37515.5 ± 10.9% | 0.040 | 1.029 | 0.589 | 1.026 | 0.479 | 1.034 | 1.036 | 0.479 | 0.482 | 0.004 |
| hex: canterbury-large/bible.txt | 524290 | 34112.2 ± 0.6% | 0.044 | 1.016 | 0.649 | 1.021 | 0.508 | 1.021 | 1.022 | 0.507 | 0.510 | 0.004 |
| hex: canterbury-large/world192.txt | 524290 | 37620.6 ± 3.5% | 0.040 | 1.027 | 0.584 | 1.025 | 0.476 | 1.029 | 1.030 | 0.473 | 0.477 | 0.004 |
| hex: http/html-1kx1024 | 2099200 | 17149.1 ± 1.3% | 0.087 | 1.008 | 0.780 | 0.985 | 0.591 | 1.009 | 0.986 | 0.673 | 0.712 | 0.008 |
| hex: http/html-16kx64 | 2097280 | 35781.2 ± 3.3% | 0.043 | 1.003 | 0.584 | 1.002 | 0.487 | 1.008 | 1.003 | 0.488 | 0.496 | 0.004 |
| hex: http/html-1m | 524290 | 38460.3 ± 1.8% | 0.040 | 1.016 | 0.577 | 1.009 | 0.466 | 1.023 | 1.024 | 0.463 | 0.469 | 0.003 |
| hex: http/json-1kx1024 | 2099200 | 17092.9 ± 1.1% | 0.087 | 1.007 | 0.782 | 0.979 | 0.592 | 1.004 | 0.980 | 0.674 | 0.715 | 0.008 |
| hex: http/json-16kx64 | 2097280 | 35107.6 ± 2.0% | 0.044 | 0.984 | 0.586 | 0.985 | 0.486 | 0.997 | 0.993 | 0.488 | 0.497 | 0.004 |
| hex: http/json-1m | 524290 | 37616.7 ± 3.8% | 0.040 | 1.017 | 0.589 | 1.021 | 0.475 | 1.029 | 1.024 | 0.475 | 0.478 | 0.004 |
| hex: http/js-1kx1024 | 2099200 | 17350.1 ± 8.5% | 0.085 | 0.996 | 0.768 | 0.975 | 0.563 | 0.991 | 0.971 | 0.644 | 0.676 | 0.008 |
| hex: http/js-16kx64 | 2097280 | 34617.6 ± 2.0% | 0.044 | 1.015 | 0.594 | 1.011 | 0.494 | 1.020 | 1.009 | 0.499 | 0.504 | 0.004 |
| hex: http/js-1m | 524290 | 37998.1 ± 2.4% | 0.040 | 1.015 | 0.586 | 1.018 | 0.474 | 1.022 | 1.022 | 0.470 | 0.474 | 0.003 |
| hex: http/css-1kx1024 | 2099200 | 17126.8 ± 3.1% | 0.087 | 1.009 | 0.781 | 0.987 | 0.591 | 1.005 | 0.986 | 0.675 | 0.712 | 0.008 |
| hex: http/css-16kx64 | 2097280 | 35057.3 ± 2.4% | 0.044 | 0.999 | 0.598 | 1.004 | 0.490 | 1.008 | 1.002 | 0.493 | 0.498 | 0.004 |
| hex: http/css-1m | 524290 | 37958.9 ± 4.0% | 0.040 | 1.014 | 0.584 | 1.021 | 0.473 | 1.022 | 1.025 | 0.466 | 0.473 | 0.004 |
| hex: shuffled/dickens-1m | 524290 | 37233.2 ± 3.3% | 0.041 | 1.025 | 0.594 | 1.028 | 0.476 | 1.030 | 1.027 | 0.477 | 0.478 | 0.004 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1334.7 ± 1.9% | 0.420 | 0.968 | 0.960 | 0.975 | 0.987 | 0.236 | 0.990 | 0.419 | 0.723 | 0.078 | 0.999 |
| qlog records, JSON text sequence | 1467503 | 1148.8 ± 8.4% | 0.697 | 0.950 | 0.975 | 0.982 | 0.977 | 0.226 | 0.978 | 0.393 | 0.697 | 0.100 | 1.010 |
| string: silesia/dickens | 172528 | 9076.1 ± 0.6% | 0.015 | 0.588 | 0.422 | 0.599 | 0.590 | 0.118 | 0.588 | 1.001 | 1.004 | 0.015 | 1.041 |
| string: silesia/nci | 1075110 | 8707.2 ± 0.3% | 0.015 | 0.592 | 0.405 | 0.591 | 0.593 | 0.164 | 0.591 | 1.003 | 1.001 | 0.015 | 1.019 |
| string: silesia/reymont | 1075159 | 3812.5 ± 1.6% | 0.035 | 0.677 | 0.515 | 0.671 | 0.678 | 0.285 | 0.678 | 1.001 | 1.003 | 0.035 | 1.005 |
| string: silesia/samba | 97582 | 4581.6 ± 0.4% | 0.038 | 0.942 | 0.791 | 0.941 | 0.943 | 0.106 | 0.942 | 1.000 | 1.003 | 0.038 | 1.112 |
| string: silesia/webster | 1098490 | 5072.9 ± 1.5% | 0.026 | 0.701 | 0.497 | 0.706 | 0.702 | 0.154 | 0.701 | 1.005 | 1.001 | 0.026 | 1.004 |
| string: silesia/xml | 1090118 | 7960.9 ± 1.9% | 0.017 | 0.629 | 0.559 | 0.636 | 0.629 | 0.193 | 0.629 | 1.006 | 1.016 | 0.017 | 1.059 |
| string: canterbury/alice29.txt | 159425 | 9566.0 ± 0.4% | 0.014 | 0.529 | 0.391 | 0.521 | 0.533 | 0.084 | 0.534 | 1.001 | 1.001 | 0.014 | 1.033 |
| string: canterbury/asyoulik.txt | 132198 | 7937.1 ± 1.1% | 0.017 | 0.512 | 0.379 | 0.502 | 0.514 | 0.087 | 0.516 | 1.001 | 1.007 | 0.017 | 1.041 |
| string: canterbury/lcet10.txt | 441884 | 8999.3 ± 2.0% | 0.015 | 0.595 | 0.386 | 0.605 | 0.594 | 0.116 | 0.595 | 1.010 | 1.016 | 0.015 | 1.035 |
| string: canterbury/plrabn12.txt | 503330 | 6090.0 ± 0.6% | 0.022 | 0.762 | 0.585 | 0.753 | 0.761 | 0.155 | 0.764 | 1.001 | 1.003 | 0.022 | 1.048 |
| string: canterbury-large/E.coli | 1048578 | 38510.7 ± 1.4% | 0.040 | 1.007 | 1.009 | 0.578 | 1.007 | 0.466 | 1.008 | 1.001 | 1.009 | 0.004 | 1.005 |
| string: canterbury-large/bible.txt | 1055886 | 6947.1 ± 1.0% | 0.020 | 0.801 | 0.665 | 0.830 | 0.800 | 0.418 | 0.801 | 1.001 | 1.000 | 0.020 | 1.048 |
| string: canterbury-large/world192.txt | 1103121 | 5145.5 ± 4.7% | 0.026 | 0.666 | 0.495 | 0.636 | 0.668 | 0.138 | 0.656 | 0.995 | 0.942 | 0.026 | 0.930 |
| string: http/html-1m | 1058582 | 8491.4 ± 1.7% | 0.016 | 0.619 | 0.520 | 0.649 | 0.620 | 0.292 | 0.618 | 1.006 | 1.015 | 0.016 | 1.020 |
| string: http/json-1m | 1190272 | 6682.9 ± 0.3% | 0.020 | 0.214 | 0.187 | 0.217 | 0.214 | 0.058 | 0.213 | 1.003 | 1.002 | 0.019 | 1.020 |
| string: http/js-1m | 1144362 | 5057.8 ± 1.1% | 0.026 | 0.445 | 0.355 | 0.428 | 0.445 | 0.084 | 0.444 | 0.998 | 1.010 | 0.026 | 1.002 |
| string: http/css-1m | 1097820 | 6889.7 ± 0.9% | 0.019 | 0.501 | 0.339 | 0.495 | 0.503 | 0.113 | 0.506 | 1.005 | 1.007 | 0.019 | 1.051 |
| string: dickens as Cyrillic and CJK | 1883069 | 5315.1 ± 0.8% | 0.021 | 0.466 | 0.058 | 0.470 | 0.467 | 0.175 | 0.468 | 1.000 | 1.003 | 0.021 | 0.981 |
| hex: silesia/dickens | 524290 | 31554.1 ± 14.4% | 1.007 | 0.067 | 1.006 | 0.597 | 1.001 | 1.004 | 1.006 | 1.002 | 0.998 | 0.067 | 1.006 |
| hex: silesia/mozilla | 524290 | 35245.9 ± 0.5% | 0.999 | 0.060 | 1.002 | 0.573 | 1.002 | 0.999 | 1.001 | 0.999 | 0.990 | 0.061 | 1.002 |
| hex: silesia/mr | 524290 | 33857.3 ± 1.1% | 1.004 | 0.063 | 1.003 | 0.591 | 1.005 | 1.004 | 1.005 | 1.003 | 0.999 | 0.063 | 1.003 |
| hex: silesia/nci | 524290 | 33443.9 ± 7.1% | 1.002 | 0.064 | 1.003 | 0.603 | 1.001 | 0.998 | 1.002 | 1.001 | 1.001 | 0.064 | 1.003 |
| hex: silesia/ooffice | 524290 | 33991.8 ± 0.7% | 1.003 | 0.063 | 0.999 | 0.591 | 0.994 | 0.995 | 0.999 | 0.995 | 0.996 | 0.063 | 1.000 |
| hex: silesia/osdb | 524290 | 35764.5 ± 1.2% | 1.006 | 0.059 | 1.003 | 0.565 | 1.006 | 1.005 | 1.006 | 1.005 | 0.996 | 0.060 | 1.009 |
| hex: silesia/reymont | 524290 | 35416.8 ± 0.7% | 1.005 | 0.060 | 1.006 | 0.566 | 1.003 | 1.003 | 1.006 | 1.004 | 1.001 | 0.060 | 1.007 |
| hex: silesia/samba | 524290 | 34596.5 ± 2.3% | 1.007 | 0.061 | 1.007 | 0.584 | 1.004 | 1.001 | 1.004 | 1.005 | 1.003 | 0.062 | 1.006 |
| hex: silesia/sao | 524290 | 33946.2 ± 0.9% | 0.997 | 0.063 | 0.995 | 0.582 | 0.996 | 0.993 | 0.995 | 0.993 | 0.992 | 0.063 | 0.998 |
| hex: silesia/webster | 524290 | 37422.4 ± 0.5% | 1.007 | 0.057 | 1.007 | 0.541 | 1.004 | 1.002 | 1.004 | 1.004 | 0.999 | 0.057 | 1.005 |
| hex: silesia/x-ray | 524290 | 33735.6 ± 0.6% | 1.002 | 0.063 | 1.001 | 0.597 | 1.002 | 1.001 | 1.004 | 1.001 | 1.002 | 0.063 | 1.001 |
| hex: silesia/xml | 524290 | 33355.1 ± 0.3% | 1.001 | 0.064 | 0.995 | 0.603 | 0.996 | 0.996 | 0.999 | 0.996 | 0.994 | 0.064 | 0.996 |
| hex: canterbury/alice29.txt | 304180 | 33834.8 ± 8.3% | 1.000 | 0.063 | 1.000 | 0.594 | 1.005 | 0.994 | 1.005 | 0.998 | 0.998 | 0.063 | 1.001 |
| hex: canterbury/asyoulik.txt | 250360 | 32125.9 ± 2.3% | 0.999 | 0.066 | 0.997 | 0.608 | 0.998 | 0.993 | 1.000 | 0.998 | 1.004 | 0.066 | 1.002 |
| hex: canterbury/cp.html | 49208 | 30816.4 ± 0.6% | 1.005 | 0.069 | 1.004 | 0.616 | 1.004 | 1.006 | 1.004 | 1.004 | 1.008 | 0.069 | 1.007 |
| hex: canterbury/fields.c | 22302 | 31056.6 ± 1.0% | 1.001 | 0.068 | 0.995 | 0.596 | 0.996 | 0.984 | 0.997 | 0.996 | 1.009 | 0.068 | 1.002 |
| hex: canterbury/grammar.lsp | 7444 | 32350.6 ± 0.3% | 1.003 | 0.066 | 1.002 | 0.577 | 0.999 | 0.953 | 0.999 | 1.007 | 1.032 | 0.065 | 1.015 |
| hex: canterbury/kennedy.xls | 524290 | 31992.3 ± 1.4% | 1.006 | 0.066 | 1.000 | 0.597 | 1.003 | 1.000 | 1.004 | 1.002 | 1.003 | 0.067 | 1.006 |
| hex: canterbury/lcet10.txt | 524290 | 34888.2 ± 1.3% | 1.004 | 0.061 | 1.005 | 0.578 | 1.001 | 1.002 | 1.004 | 1.002 | 1.002 | 0.061 | 0.997 |
| hex: canterbury/plrabn12.txt | 524290 | 33295.2 ± 0.4% | 1.003 | 0.064 | 1.000 | 0.601 | 1.002 | 0.997 | 1.000 | 0.998 | 0.998 | 0.064 | 1.002 |
| hex: canterbury/ptt5 | 524290 | 33546.4 ± 1.1% | 1.002 | 0.063 | 1.004 | 0.600 | 1.002 | 0.999 | 1.002 | 1.002 | 1.002 | 0.063 | 1.003 |
| hex: canterbury/sum | 76482 | 35487.5 ± 0.2% | 0.997 | 0.060 | 0.996 | 0.569 | 0.997 | 0.991 | 0.996 | 1.002 | 0.995 | 0.060 | 1.001 |
| hex: canterbury/xargs.1 | 8456 | 34630.5 ± 0.1% | 0.999 | 0.061 | 0.997 | 0.544 | 0.995 | 0.950 | 0.995 | 0.997 | 1.038 | 0.061 | 1.011 |
| hex: canterbury-large/E.coli | 524290 | 30942.7 ± 2.3% | 0.999 | 0.069 | 0.998 | 0.620 | 0.998 | 0.995 | 0.996 | 0.995 | 0.996 | 0.069 | 0.995 |
| hex: canterbury-large/bible.txt | 524290 | 35400.3 ± 3.7% | 1.003 | 0.060 | 1.007 | 0.568 | 1.007 | 1.003 | 1.007 | 1.005 | 1.000 | 0.060 | 1.006 |
| hex: canterbury-large/world192.txt | 524290 | 35300.8 ± 0.5% | 1.010 | 0.060 | 1.008 | 0.568 | 1.008 | 1.005 | 1.012 | 1.009 | 1.010 | 0.060 | 1.008 |
| hex: http/html-1kx1024 | 2099200 | 23886.9 ± 1.6% | 0.992 | 0.087 | 0.982 | 0.670 | 0.971 | 0.863 | 0.973 | 0.975 | 1.038 | 0.084 | 1.020 |
| hex: http/html-16kx64 | 2097280 | 29973.8 ± 1.0% | 1.010 | 0.071 | 1.010 | 0.647 | 1.010 | 0.994 | 1.008 | 1.006 | 1.010 | 0.071 | 1.012 |
| hex: http/html-1m | 524290 | 29166.5 ± 0.6% | 1.003 | 0.073 | 0.999 | 0.667 | 0.995 | 0.995 | 0.997 | 0.999 | 0.996 | 0.073 | 0.996 |
| hex: http/json-1kx1024 | 2099200 | 23596.8 ± 0.8% | 0.999 | 0.088 | 0.977 | 0.677 | 0.980 | 0.869 | 0.982 | 0.978 | 1.044 | 0.085 | 1.019 |
| hex: http/json-16kx64 | 2097280 | 30112.5 ± 1.4% | 1.009 | 0.070 | 1.002 | 0.639 | 0.997 | 0.993 | 1.001 | 0.999 | 1.007 | 0.070 | 1.000 |
| hex: http/json-1m | 524290 | 31599.4 ± 1.8% | 1.005 | 0.067 | 1.005 | 0.632 | 1.004 | 1.004 | 1.005 | 1.002 | 0.995 | 0.067 | 1.004 |
| hex: http/js-1kx1024 | 2099200 | 23809.7 ± 1.5% | 0.985 | 0.087 | 0.980 | 0.673 | 0.972 | 0.864 | 0.976 | 0.979 | 1.045 | 0.084 | 1.014 |
| hex: http/js-16kx64 | 2097280 | 30168.3 ± 0.7% | 1.008 | 0.070 | 1.001 | 0.640 | 0.999 | 0.984 | 1.000 | 0.999 | 1.007 | 0.070 | 0.996 |
| hex: http/js-1m | 524290 | 30905.5 ± 0.8% | 1.003 | 0.069 | 0.999 | 0.638 | 1.000 | 0.999 | 1.001 | 1.000 | 0.995 | 0.069 | 1.004 |
| hex: http/css-1kx1024 | 2099200 | 23528.4 ± 3.5% | 1.005 | 0.088 | 0.999 | 0.683 | 0.982 | 0.874 | 0.981 | 0.985 | 1.058 | 0.085 | 1.022 |
| hex: http/css-16kx64 | 2097280 | 30392.9 ± 1.6% | 1.008 | 0.070 | 1.002 | 0.636 | 1.007 | 0.995 | 1.008 | 1.006 | 1.007 | 0.070 | 1.009 |
| hex: http/css-1m | 524290 | 31725.8 ± 2.0% | 1.004 | 0.067 | 1.004 | 0.630 | 1.003 | 1.000 | 1.002 | 0.998 | 0.999 | 0.067 | 1.004 |
| hex: shuffled/dickens-1m | 524290 | 35259.7 ± 0.2% | 1.000 | 0.060 | 1.002 | 0.574 | 1.003 | 1.003 | 1.005 | 1.000 | 1.000 | 0.060 | 1.005 |

## Losses

Each workload where a claim's path ran slower than the path it replaces by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding: J8 decoder fast path off runs at 1.079 of all on.
- CLDR supplemental, 34 texts, decoding: J12 decoder escape words off runs at 1.065 of all on.
- CLDR supplemental, 34 texts, decoding: J13 decoder escape blocks off runs at 1.079 of all on.
- string: silesia/webster, decoding: J8 decoder fast path off runs at 1.053 of all on.
- string: silesia/webster, decoding: J13 decoder escape blocks off runs at 1.053 of all on.
- string: canterbury/alice29.txt, decoding: J8 decoder fast path off runs at 1.120 of all on.
- string: canterbury/alice29.txt, decoding: J12 decoder escape words off runs at 1.062 of all on.
- string: canterbury/alice29.txt, decoding: J13 decoder escape blocks off runs at 1.118 of all on.
- string: canterbury/asyoulik.txt, decoding: J7 wide vectors off runs at 1.061 of all on.
- string: canterbury/asyoulik.txt, decoding: J8 decoder fast path off runs at 1.121 of all on.
- string: canterbury/asyoulik.txt, decoding: J13 decoder escape blocks off runs at 1.119 of all on.
- string: canterbury/lcet10.txt, decoding: J8 decoder fast path off runs at 1.073 of all on.
- string: canterbury/lcet10.txt, decoding: J13 decoder escape blocks off runs at 1.071 of all on.
- string: canterbury/plrabn12.txt, decoding: J8 decoder fast path off runs at 1.080 of all on.
- string: canterbury/plrabn12.txt, decoding: J13 decoder escape blocks off runs at 1.080 of all on.
- string: canterbury-large/world192.txt, decoding: J8 decoder fast path off runs at 1.054 of all on.
- string: canterbury-large/world192.txt, decoding: J13 decoder escape blocks off runs at 1.053 of all on.
- string: http/js-1m, decoding: J8 decoder fast path off runs at 1.077 of all on.
- string: http/js-1m, decoding: J13 decoder escape blocks off runs at 1.078 of all on.
- string: http/css-1m, decoding: J8 decoder fast path off runs at 1.091 of all on.
- string: http/css-1m, decoding: J13 decoder escape blocks off runs at 1.086 of all on.

## UTF-8 validation against simdutf

stdx's `is_utf8`, the check the loops apply to every string's octets, run alone over each string workload's octets at the width the host's features pick (16 lanes on aarch64, AVX2's 32 or AVX-512's 64 on x86-64, decision 39), beside simdutf 9.3.3's `validate_utf8` in the same run; on a host with AVX-512, again with AVX2 alone. Each ratio is stdx's throughput over the other's. simdutf picks its kernel at run time. Before timing, every copy of the check and simdutf judged 20000 seeded buffers and each workload, whole and changed, alike.

| Workload | Octets | stdx, MB/s | simdutf, MB/s | stdx / simdutf | stdx with AVX2 alone, MB/s | stdx / stdx with AVX2 alone |
|---|---|---|---|---|---|---|
| string: silesia/dickens | 166668 | 100783.3 ± 1.8% | 91444.1 ± 0.5% | 1.102 | — | — |
| string: silesia/nci | 1048576 | 73709.7 ± 4.7% | 72529.7 ± 0.7% | 1.016 | — | — |
| string: silesia/reymont | 1048576 | 73508.9 ± 0.5% | 72382.5 ± 0.8% | 1.016 | — | — |
| string: silesia/samba | 65546 | 98256.8 ± 0.2% | 90706.5 ± 0.4% | 1.083 | — | — |
| string: silesia/webster | 1048576 | 74570.9 ± 4.4% | 76335.1 ± 0.9% | 0.977 | — | — |
| string: silesia/xml | 1048576 | 73798.7 ± 2.9% | 72780.7 ± 4.3% | 1.014 | — | — |
| string: canterbury/alice29.txt | 152089 | 99431.8 ± 1.3% | 91473.6 ± 0.7% | 1.087 | — | — |
| string: canterbury/asyoulik.txt | 125179 | 99890.4 ± 1.5% | 92022.4 ± 0.7% | 1.086 | — | — |
| string: canterbury/lcet10.txt | 426754 | 87426.9 ± 1.4% | 83461.6 ± 0.5% | 1.048 | — | — |
| string: canterbury/plrabn12.txt | 481861 | 83325.3 ± 0.9% | 80139.5 ± 3.4% | 1.040 | — | — |
| string: canterbury-large/E.coli | 1048576 | 73503.1 ± 0.6% | 72076.5 ± 2.0% | 1.020 | — | — |
| string: canterbury-large/bible.txt | 1048576 | 74128.7 ± 0.9% | 72836.0 ± 0.8% | 1.018 | — | — |
| string: canterbury-large/world192.txt | 1048576 | 73424.0 ± 2.4% | 72593.5 ± 0.4% | 1.011 | — | — |
| string: http/html-1m | 1048576 | 69820.3 ± 0.5% | 68020.2 ± 0.8% | 1.026 | — | — |
| string: http/json-1m | 1048576 | 62088.1 ± 1.9% | 65874.8 ± 15.8% | 0.943 | — | — |
| string: http/js-1m | 1048576 | 72901.1 ± 0.5% | 72517.7 ± 22.2% | 1.005 | — | — |
| string: http/css-1m | 1048576 | 73242.1 ± 1.0% | 72104.7 ± 0.5% | 1.016 | — | — |
| string: dickens as Cyrillic and CJK | 1847045 | 14536.0 ± 0.6% | 15313.6 ± 0.2% | 0.949 | — | — |

## Losses to simdutf

- string: dickens as Cyrillic and CJK: stdx runs at 0.949 of simdutf.

## UTF-8 validation by the buffer's offset from a 64-octet line

| Buffer | Octets | Offset | stdx, MB/s | simdutf, MB/s | stdx / simdutf | stdx with AVX2 alone, MB/s | stdx / stdx with AVX2 alone |
|---|---|---|---|---|---|---|---|
| string: canterbury-large/bible.txt | 1048576 | 0 | 74167.7 ± 1.5% | 76554.2 ± 2.6% | 0.969 | — | — |
| string: canterbury-large/bible.txt | 1048576 | 1 | 73484.5 ± 0.7% | 71770.3 ± 1.9% | 1.024 | — | — |
| string: canterbury-large/bible.txt | 1048576 | 8 | 73290.6 ± 0.5% | 71809.9 ± 1.0% | 1.021 | — | — |
| string: canterbury-large/bible.txt | 1048576 | 16 | 73307.7 ± 1.1% | 71961.7 ± 0.4% | 1.019 | — | — |
| string: canterbury-large/bible.txt | 1048576 | 32 | 73552.0 ± 2.1% | 76317.1 ± 0.5% | 0.964 | — | — |
| string: canterbury-large/bible.txt | 1048576 | 48 | 73302.2 ± 2.2% | 72260.7 ± 0.8% | 1.014 | — | — |
| string: dickens as Cyrillic and CJK | 1048576 | 0 | 14553.7 ± 0.9% | 15253.4 ± 0.5% | 0.954 | — | — |
| string: dickens as Cyrillic and CJK | 1048576 | 1 | 14574.2 ± 0.3% | 15302.9 ± 0.4% | 0.952 | — | — |
| string: dickens as Cyrillic and CJK | 1048576 | 8 | 14553.9 ± 0.4% | 15257.3 ± 1.7% | 0.954 | — | — |
| string: dickens as Cyrillic and CJK | 1048576 | 16 | 14550.7 ± 4.3% | 15264.6 ± 0.3% | 0.953 | — | — |
| string: dickens as Cyrillic and CJK | 1048576 | 32 | 14562.4 ± 0.2% | 15271.0 ± 0.7% | 0.954 | — | — |
| string: dickens as Cyrillic and CJK | 1048576 | 48 | 14548.0 ± 0.2% | 15238.8 ± 1.2% | 0.955 | — | — |

## Against the baselines

stdx with every claim on, timed beside simdjson 5.1.1, yyjson 0.13.0, Zig 0.16.0's std.json, serde_json 1.0.154 and Go's encoding/json/jsontext in the same run. Each ratio is stdx's throughput over the baseline's; below 1, the baseline is faster. stdx is built for the architecture's baseline CPU in ReleaseSafe; the baselines for this host in ReleaseFast, and simdjson picks its kernel at run time. Decoding visits every value; encoding writes each text from its tokens.

## Decoding against the baselines

Octets are the text's. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1020.4 ± 0.4% | 1014.7 ± 1.2% | 936.7 ± 1.0% | 260.0 ± 4.0% | 527.4 ± 0.4% | 250.5 ± 5.0% | 1.006 | 1.089 | 3.924 | 1.935 | 4.073 |
| qlog records, JSON text sequence | 1467503 | 781.3 ± 24.7% | 804.4 ± 0.8% | 683.2 ± 26.5% | 204.4 ± 5.1% | 507.1 ± 19.4% | 220.1 ± 11.7% | 0.971 | 1.144 | 3.823 | 1.541 | 3.549 |
| string: silesia/dickens | 172528 | 5459.2 ± 0.5% | 2921.9 ± 1.3% | 2063.9 ± 0.5% | 285.0 ± 0.5% | 2189.2 ± 0.5% | 465.8 ± 6.6% | 1.868 | 2.645 | 19.157 | 2.494 | 11.720 |
| string: silesia/nci | 1075110 | 5152.4 ± 0.9% | 3536.8 ± 0.1% | 2726.9 ± 1.5% | 425.5 ± 1.9% | 2457.5 ± 0.8% | 515.7 ± 5.4% | 1.457 | 1.890 | 12.110 | 2.097 | 9.991 |
| string: silesia/reymont | 1075159 | 2771.8 ± 0.2% | 2190.0 ± 1.0% | 1727.5 ± 4.0% | 293.9 ± 0.8% | 1644.1 ± 1.1% | 466.5 ± 4.8% | 1.266 | 1.605 | 9.431 | 1.686 | 5.942 |
| string: silesia/samba | 97582 | 3342.6 ± 1.2% | 2887.3 ± 4.5% | 1646.8 ± 9.2% | 239.7 ± 0.2% | 1281.3 ± 0.3% | 341.5 ± 1.3% | 1.158 | 2.030 | 13.947 | 2.609 | 9.789 |
| string: silesia/webster | 1098490 | 3654.6 ± 0.6% | 2047.3 ± 0.2% | 1574.6 ± 6.9% | 285.5 ± 0.5% | 1667.4 ± 0.6% | 415.3 ± 2.6% | 1.785 | 2.321 | 12.801 | 2.192 | 8.800 |
| string: silesia/xml | 1090118 | 5093.9 ± 1.0% | 3691.5 ± 4.8% | 2128.0 ± 2.8% | 373.8 ± 0.8% | 2332.5 ± 1.1% | 483.5 ± 16.3% | 1.380 | 2.394 | 13.627 | 2.184 | 10.536 |
| string: canterbury/alice29.txt | 159425 | 4384.7 ± 6.2% | 2453.8 ± 3.4% | 1871.2 ± 3.0% | 268.6 ± 0.6% | 1923.1 ± 4.9% | 420.9 ± 1.8% | 1.787 | 2.343 | 16.324 | 2.280 | 10.416 |
| string: canterbury/asyoulik.txt | 132198 | 3791.9 ± 4.0% | 2143.5 ± 0.4% | 1479.3 ± 1.6% | 257.9 ± 1.0% | 1571.6 ± 0.5% | 371.0 ± 14.3% | 1.769 | 2.563 | 14.703 | 2.413 | 10.222 |
| string: canterbury/lcet10.txt | 441884 | 5682.8 ± 0.9% | 2823.7 ± 0.7% | 1985.6 ± 2.1% | 308.9 ± 0.3% | 2125.7 ± 0.4% | 461.7 ± 3.7% | 2.013 | 2.862 | 18.395 | 2.673 | 12.308 |
| string: canterbury/plrabn12.txt | 503330 | 4411.2 ± 0.4% | 2742.1 ± 0.3% | 1674.9 ± 0.9% | 281.4 ± 1.1% | 2011.2 ± 0.5% | 438.1 ± 1.2% | 1.609 | 2.634 | 15.677 | 2.193 | 10.068 |
| string: canterbury-large/E.coli | 1048578 | 37059.5 ± 2.0% | 7809.6 ± 0.6% | 3491.1 ± 6.2% | 799.1 ± 0.1% | 5500.1 ± 1.1% | 786.5 ± 2.0% | 4.745 | 10.615 | 46.376 | 6.738 | 47.120 |
| string: canterbury-large/bible.txt | 1055886 | 6658.1 ± 0.8% | 3937.7 ± 0.6% | 2580.9 ± 1.1% | 329.7 ± 0.2% | 2979.4 ± 1.1% | 595.8 ± 1.7% | 1.691 | 2.580 | 20.194 | 2.235 | 11.174 |
| string: canterbury-large/world192.txt | 1103121 | 3442.3 ± 0.5% | 2005.8 ± 0.5% | 1655.9 ± 0.8% | 277.5 ± 1.7% | 1694.1 ± 0.8% | 433.5 ± 0.5% | 1.716 | 2.079 | 12.407 | 2.032 | 7.940 |
| string: http/html-1m | 1058582 | 6234.1 ± 0.8% | 3405.6 ± 0.7% | 2379.5 ± 2.5% | 371.3 ± 0.3% | 2735.7 ± 2.4% | 422.2 ± 8.5% | 1.831 | 2.620 | 16.792 | 2.279 | 14.765 |
| string: http/json-1m | 1190272 | 3331.3 ± 0.4% | 1256.9 ± 0.2% | 1435.1 ± 6.4% | 307.9 ± 1.7% | 818.1 ± 0.7% | 295.0 ± 0.2% | 2.650 | 2.321 | 10.818 | 4.072 | 11.293 |
| string: http/js-1m | 1144362 | 2256.9 ± 7.5% | 1345.1 ± 1.1% | 1154.3 ± 0.9% | 255.5 ± 0.8% | 1162.4 ± 1.7% | 295.3 ± 1.5% | 1.678 | 1.955 | 8.832 | 1.942 | 7.642 |
| string: http/css-1m | 1097820 | 3017.4 ± 0.5% | 2560.6 ± 1.1% | 1525.1 ± 1.2% | 338.2 ± 0.9% | 1532.2 ± 2.1% | 334.1 ± 11.1% | 1.178 | 1.979 | 8.923 | 1.969 | 9.031 |
| string: dickens as Cyrillic and CJK | 1883069 | 5159.3 ± 2.0% | 3195.4 ± 3.2% | 650.7 ± 1.2% | 244.8 ± 0.6% | 498.6 ± 3.6% | 140.9 ± 8.2% | 1.615 | 7.929 | 21.079 | 10.348 | 36.622 |
| string: dickens as Cyrillic and CJK, as \u escapes | 5075485 | 1058.4 ± 9.9% | 1077.4 ± 7.7% | 815.0 ± 1.2% | 147.1 ± 4.6% | 383.2 ± 0.2% | 195.8 ± 4.4% | 0.982 | 1.299 | 7.194 | 2.762 | 5.405 |
| hex: silesia/dickens | 524290 | 38253.7 ± 2.0% | 7827.2 ± 0.6% | 3513.9 ± 1.1% | 422.8 ± 0.3% | 5504.5 ± 0.7% | 797.0 ± 3.7% | 4.887 | 10.886 | 90.477 | 6.950 | 47.996 |
| hex: silesia/mozilla | 524290 | 38178.9 ± 6.2% | 7823.5 ± 0.9% | 3512.6 ± 6.4% | 360.3 ± 2.1% | 5507.2 ± 0.4% | 795.2 ± 1.6% | 4.880 | 10.869 | 105.963 | 6.933 | 48.011 |
| hex: silesia/mr | 524290 | 38314.0 ± 9.4% | 7776.8 ± 3.5% | 3527.3 ± 0.5% | 514.5 ± 0.6% | 5504.3 ± 0.7% | 794.1 ± 3.4% | 4.927 | 10.862 | 74.462 | 6.961 | 48.248 |
| hex: silesia/nci | 524290 | 37700.2 ± 3.0% | 7831.8 ± 0.2% | 3528.2 ± 1.4% | 577.2 ± 4.4% | 5529.0 ± 0.3% | 796.1 ± 5.9% | 4.814 | 10.685 | 65.311 | 6.819 | 47.358 |
| hex: silesia/ooffice | 524290 | 37583.6 ± 1.8% | 7810.2 ± 0.3% | 3519.9 ± 0.7% | 319.1 ± 0.6% | 5497.5 ± 0.7% | 796.4 ± 1.1% | 4.812 | 10.677 | 117.793 | 6.837 | 47.190 |
| hex: silesia/osdb | 524290 | 38107.9 ± 1.0% | 7816.0 ± 0.6% | 3522.8 ± 1.4% | 406.9 ± 0.4% | 5493.1 ± 1.0% | 804.8 ± 6.2% | 4.876 | 10.817 | 93.648 | 6.937 | 47.354 |
| hex: silesia/reymont | 524290 | 38401.2 ± 3.3% | 7771.3 ± 0.7% | 3521.4 ± 1.0% | 435.0 ± 0.9% | 5442.0 ± 16.8% | 806.2 ± 3.3% | 4.941 | 10.905 | 88.287 | 7.056 | 47.634 |
| hex: silesia/samba | 524290 | 36548.2 ± 0.7% | 7818.1 ± 2.2% | 3533.7 ± 0.6% | 322.9 ± 2.0% | 5522.2 ± 0.3% | 808.8 ± 2.6% | 4.675 | 10.343 | 113.203 | 6.618 | 45.191 |
| hex: silesia/sao | 524290 | 38108.8 ± 1.0% | 7805.7 ± 0.9% | 3498.2 ± 0.5% | 263.0 ± 0.3% | 5492.2 ± 1.1% | 810.6 ± 1.6% | 4.882 | 10.894 | 144.908 | 6.939 | 47.013 |
| hex: silesia/webster | 524290 | 38514.9 ± 1.3% | 7817.6 ± 0.8% | 3529.0 ± 2.6% | 385.2 ± 3.7% | 5498.8 ± 4.7% | 811.2 ± 1.2% | 4.927 | 10.914 | 99.995 | 7.004 | 47.481 |
| hex: silesia/x-ray | 524290 | 36651.3 ± 1.4% | 7768.1 ± 0.7% | 3511.9 ± 0.9% | 385.6 ± 1.0% | 5515.7 ± 0.7% | 812.1 ± 0.8% | 4.718 | 10.436 | 95.044 | 6.645 | 45.133 |
| hex: silesia/xml | 524290 | 38003.3 ± 0.3% | 7814.1 ± 1.9% | 3534.6 ± 0.5% | 507.7 ± 0.4% | 5523.0 ± 0.9% | 812.5 ± 2.2% | 4.863 | 10.752 | 74.848 | 6.881 | 46.773 |
| hex: canterbury/alice29.txt | 304180 | 37306.7 ± 0.9% | 7814.4 ± 1.3% | 3565.9 ± 0.4% | 424.0 ± 0.5% | 5517.3 ± 0.2% | 809.8 ± 1.8% | 4.774 | 10.462 | 87.985 | 6.762 | 46.069 |
| hex: canterbury/asyoulik.txt | 250360 | 39871.8 ± 0.5% | 7792.3 ± 0.2% | 3542.6 ± 0.8% | 414.4 ± 7.4% | 5505.6 ± 0.3% | 808.0 ± 0.9% | 5.117 | 11.255 | 96.207 | 7.242 | 49.345 |
| hex: canterbury/cp.html | 49208 | 38898.2 ± 0.9% | 7793.5 ± 0.4% | 3572.1 ± 0.7% | 403.8 ± 0.4% | 5468.9 ± 0.4% | 788.4 ± 1.8% | 4.991 | 10.889 | 96.321 | 7.113 | 49.339 |
| hex: canterbury/fields.c | 22302 | 37850.4 ± 1.0% | 7710.6 ± 0.3% | 3581.7 ± 0.5% | 429.2 ± 0.3% | 5461.1 ± 0.5% | 776.4 ± 3.5% | 4.909 | 10.568 | 88.190 | 6.931 | 48.753 |
| hex: canterbury/grammar.lsp | 7444 | 36470.4 ± 0.8% | 7509.7 ± 0.5% | 3558.7 ± 0.5% | 482.8 ± 2.1% | 5358.4 ± 1.2% | 765.2 ± 1.1% | 4.856 | 10.248 | 75.531 | 6.806 | 47.660 |
| hex: canterbury/kennedy.xls | 524290 | 37341.2 ± 3.0% | 7781.9 ± 0.7% | 3541.8 ± 0.4% | 597.9 ± 0.3% | 5487.4 ± 0.8% | 799.3 ± 3.1% | 4.798 | 10.543 | 62.450 | 6.805 | 46.719 |
| hex: canterbury/lcet10.txt | 524290 | 37929.9 ± 1.7% | 7807.9 ± 0.5% | 3521.0 ± 2.5% | 425.1 ± 12.2% | 5511.5 ± 0.2% | 789.0 ± 4.5% | 4.858 | 10.772 | 89.218 | 6.882 | 48.074 |
| hex: canterbury/plrabn12.txt | 524290 | 36739.9 ± 1.0% | 7819.4 ± 0.6% | 3505.1 ± 1.9% | 414.6 ± 0.4% | 5513.6 ± 0.5% | 794.5 ± 2.2% | 4.699 | 10.482 | 88.606 | 6.663 | 46.243 |
| hex: canterbury/ptt5 | 524290 | 38006.0 ± 4.4% | 7776.0 ± 4.6% | 3512.8 ± 4.6% | 509.0 ± 2.5% | 5503.9 ± 0.9% | 792.4 ± 3.5% | 4.888 | 10.819 | 74.663 | 6.905 | 47.965 |
| hex: canterbury/sum | 76482 | 40859.9 ± 1.1% | 7809.8 ± 1.7% | 3556.4 ± 0.7% | 458.6 ± 1.2% | 5471.6 ± 0.6% | 801.3 ± 7.6% | 5.232 | 11.489 | 89.103 | 7.468 | 50.992 |
| hex: canterbury/xargs.1 | 8456 | 38060.8 ± 3.9% | 7541.4 ± 0.7% | 3549.2 ± 0.6% | 450.0 ± 0.3% | 5353.2 ± 1.2% | 783.2 ± 2.1% | 5.047 | 10.724 | 84.579 | 7.110 | 48.594 |
| hex: canterbury-large/E.coli | 524290 | 37515.5 ± 10.9% | 7791.4 ± 0.8% | 3489.8 ± 1.2% | 709.9 ± 12.9% | 5510.0 ± 0.2% | 784.6 ± 4.3% | 4.815 | 10.750 | 52.849 | 6.809 | 47.816 |
| hex: canterbury-large/bible.txt | 524290 | 34112.2 ± 0.6% | 7777.0 ± 0.7% | 3489.4 ± 1.2% | 438.6 ± 0.9% | 5498.7 ± 7.7% | 790.0 ± 4.0% | 4.386 | 9.776 | 77.781 | 6.204 | 43.179 |
| hex: canterbury-large/world192.txt | 524290 | 37620.6 ± 3.5% | 7791.7 ± 0.5% | 3488.0 ± 1.1% | 408.5 ± 11.8% | 5510.0 ± 0.6% | 772.5 ± 3.2% | 4.828 | 10.786 | 92.086 | 6.828 | 48.701 |
| hex: http/html-1kx1024 | 2099200 | 17149.1 ± 1.3% | 6653.0 ± 0.2% | 3209.0 ± 0.7% | 422.3 ± 0.6% | 4693.0 ± 1.7% | 680.9 ± 6.3% | 2.578 | 5.344 | 40.610 | 3.654 | 25.186 |
| hex: http/html-16kx64 | 2097280 | 35781.2 ± 3.3% | 7677.0 ± 0.5% | 3459.0 ± 1.1% | 430.5 ± 0.2% | 5416.2 ± 0.3% | 775.9 ± 8.6% | 4.661 | 10.344 | 83.122 | 6.606 | 46.117 |
| hex: http/html-1m | 524290 | 38460.3 ± 1.8% | 7803.0 ± 2.3% | 3500.9 ± 0.5% | 428.6 ± 0.6% | 5501.4 ± 4.6% | 800.7 ± 5.0% | 4.929 | 10.986 | 89.734 | 6.991 | 48.033 |
| hex: http/json-1kx1024 | 2099200 | 17092.9 ± 1.1% | 6621.9 ± 0.9% | 3214.3 ± 1.0% | 523.5 ± 3.3% | 4698.2 ± 1.0% | 695.7 ± 2.0% | 2.581 | 5.318 | 32.651 | 3.638 | 24.570 |
| hex: http/json-16kx64 | 2097280 | 35107.6 ± 2.0% | 7647.6 ± 0.1% | 3446.9 ± 0.5% | 543.0 ± 0.5% | 5411.9 ± 0.2% | 770.0 ± 14.6% | 4.591 | 10.185 | 64.651 | 6.487 | 45.595 |
| hex: http/json-1m | 524290 | 37616.7 ± 3.8% | 7818.7 ± 0.3% | 3520.0 ± 1.5% | 534.0 ± 1.7% | 5509.3 ± 0.4% | 772.7 ± 2.6% | 4.811 | 10.687 | 70.440 | 6.828 | 48.680 |
| hex: http/js-1kx1024 | 2099200 | 17350.1 ± 8.5% | 6647.7 ± 4.4% | 3186.7 ± 2.7% | 419.7 ± 0.5% | 4712.2 ± 0.6% | 705.2 ± 5.1% | 2.610 | 5.444 | 41.340 | 3.682 | 24.602 |
| hex: http/js-16kx64 | 2097280 | 34617.6 ± 2.0% | 7678.4 ± 0.4% | 3465.0 ± 0.5% | 425.3 ± 0.2% | 5410.9 ± 2.4% | 784.2 ± 3.0% | 4.508 | 9.991 | 81.392 | 6.398 | 44.143 |
| hex: http/js-1m | 524290 | 37998.1 ± 2.4% | 7820.4 ± 0.3% | 3518.3 ± 1.9% | 436.7 ± 13.1% | 5506.1 ± 0.8% | 799.2 ± 3.4% | 4.859 | 10.800 | 87.002 | 6.901 | 47.545 |
| hex: http/css-1kx1024 | 2099200 | 17126.8 ± 3.1% | 6643.9 ± 3.7% | 3205.3 ± 3.1% | 454.9 ± 0.7% | 4702.9 ± 1.0% | 692.4 ± 1.8% | 2.578 | 5.343 | 37.651 | 3.642 | 24.736 |
| hex: http/css-16kx64 | 2097280 | 35057.3 ± 2.4% | 7668.7 ± 0.6% | 3458.2 ± 0.8% | 466.1 ± 0.2% | 5418.2 ± 0.5% | 769.2 ± 2.3% | 4.571 | 10.137 | 75.211 | 6.470 | 45.574 |
| hex: http/css-1m | 524290 | 37958.9 ± 4.0% | 7806.8 ± 0.3% | 3518.3 ± 1.2% | 455.2 ± 0.6% | 5493.4 ± 1.4% | 786.3 ± 3.2% | 4.862 | 10.789 | 83.398 | 6.910 | 48.276 |
| hex: shuffled/dickens-1m | 524290 | 37233.2 ± 3.3% | 7782.0 ± 0.8% | 3493.6 ± 2.0% | 423.8 ± 0.3% | 5498.5 ± 1.0% | 797.5 ± 3.1% | 4.785 | 10.657 | 87.851 | 6.771 | 46.686 |

## Encoding against the baselines

Octets are the ones stdx writes. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1334.7 ± 1.9% | 1041.4 ± 2.4% | 866.2 ± 0.6% | 331.2 ± 1.4% | 365.0 ± 1.1% | 307.3 ± 3.3% | 1.282 | 1.541 | 4.030 | 3.657 | 4.343 |
| qlog records, JSON text sequence | 1467503 | 1148.8 ± 8.4% | 830.5 ± 1.6% | 699.7 ± 2.5% | 319.3 ± 1.9% | 378.7 ± 1.9% | 225.2 ± 7.1% | 1.383 | 1.642 | 3.598 | 3.033 | 5.102 |
| string: silesia/dickens | 172528 | 9076.1 ± 0.6% | 3174.6 ± 3.2% | 2046.5 ± 0.5% | 358.1 ± 0.5% | 1406.4 ± 2.6% | 558.6 ± 0.4% | 2.859 | 4.435 | 25.347 | 6.454 | 16.249 |
| string: silesia/nci | 1075110 | 8707.2 ± 0.3% | 3177.7 ± 3.1% | 2813.5 ± 1.7% | 775.1 ± 0.7% | 1533.8 ± 0.5% | 563.7 ± 1.2% | 2.740 | 3.095 | 11.234 | 5.677 | 15.446 |
| string: silesia/reymont | 1075159 | 3812.5 ± 1.6% | 1592.8 ± 1.4% | 1738.1 ± 0.2% | 361.3 ± 0.2% | 1243.7 ± 0.8% | 550.6 ± 7.4% | 2.394 | 2.193 | 10.552 | 3.065 | 6.924 |
| string: silesia/samba | 97582 | 4581.6 ± 0.4% | 2029.5 ± 0.4% | 2182.9 ± 0.4% | 303.1 ± 9.3% | 1005.3 ± 0.7% | 618.7 ± 0.9% | 2.258 | 2.099 | 15.116 | 4.558 | 7.405 |
| string: silesia/webster | 1098490 | 5072.9 ± 1.5% | 1619.8 ± 1.3% | 1528.1 ± 1.2% | 356.2 ± 1.0% | 1193.8 ± 0.7% | 455.2 ± 0.3% | 3.132 | 3.320 | 14.241 | 4.249 | 11.143 |
| string: silesia/xml | 1090118 | 7960.9 ± 1.9% | 2751.5 ± 1.4% | 2183.6 ± 2.1% | 548.8 ± 14.2% | 1573.3 ± 0.8% | 560.4 ± 1.1% | 2.893 | 3.646 | 14.505 | 5.060 | 14.207 |
| string: canterbury/alice29.txt | 159425 | 9566.0 ± 0.4% | 2549.5 ± 3.1% | 1800.5 ± 0.2% | 337.6 ± 2.0% | 1255.8 ± 15.1% | 553.4 ± 0.4% | 3.752 | 5.313 | 28.336 | 7.617 | 17.285 |
| string: canterbury/asyoulik.txt | 132198 | 7937.1 ± 1.1% | 2286.7 ± 0.9% | 1541.0 ± 3.2% | 344.7 ± 12.8% | 1115.0 ± 1.2% | 540.7 ± 0.6% | 3.471 | 5.151 | 23.028 | 7.118 | 14.678 |
| string: canterbury/lcet10.txt | 441884 | 8999.3 ± 2.0% | 2467.5 ± 1.8% | 1995.1 ± 0.2% | 390.5 ± 0.5% | 1370.4 ± 2.8% | 552.8 ± 0.3% | 3.647 | 4.511 | 23.046 | 6.567 | 16.279 |
| string: canterbury/plrabn12.txt | 503330 | 6090.0 ± 0.6% | 1818.6 ± 1.3% | 1682.6 ± 0.5% | 361.4 ± 3.5% | 1282.4 ± 1.3% | 557.2 ± 2.8% | 3.349 | 3.619 | 16.851 | 4.749 | 10.930 |
| string: canterbury-large/E.coli | 1048578 | 38510.7 ± 1.4% | 19392.8 ± 0.5% | 3385.9 ± 0.4% | 1431.0 ± 1.8% | 2564.7 ± 1.0% | 573.3 ± 0.5% | 1.986 | 11.374 | 26.912 | 15.016 | 67.171 |
| string: canterbury-large/bible.txt | 1055886 | 6947.1 ± 1.0% | 4032.1 ± 0.7% | 2667.4 ± 0.2% | 432.8 ± 0.7% | 1866.6 ± 0.6% | 568.2 ± 0.6% | 1.723 | 2.604 | 16.051 | 3.722 | 12.227 |
| string: canterbury-large/world192.txt | 1103121 | 5145.5 ± 4.7% | 1430.4 ± 4.9% | 1618.5 ± 0.7% | 366.0 ± 0.9% | 1171.7 ± 0.7% | 540.3 ± 1.4% | 3.597 | 3.179 | 14.060 | 4.391 | 9.523 |
| string: http/html-1m | 1058582 | 8491.4 ± 1.7% | 3864.7 ± 2.0% | 2484.7 ± 1.5% | 396.9 ± 0.9% | 1811.4 ± 0.7% | 521.5 ± 0.9% | 2.197 | 3.417 | 21.392 | 4.688 | 16.283 |
| string: http/json-1m | 1190272 | 6682.9 ± 0.3% | 1216.0 ± 0.9% | 1324.0 ± 0.4% | 370.6 ± 0.8% | 891.5 ± 13.5% | 504.9 ± 17.5% | 5.496 | 5.047 | 18.032 | 7.496 | 13.236 |
| string: http/js-1m | 1144362 | 5057.8 ± 1.1% | 995.7 ± 1.3% | 1066.3 ± 0.2% | 283.4 ± 0.8% | 929.8 ± 1.5% | 473.5 ± 0.5% | 5.080 | 4.743 | 17.848 | 5.440 | 10.681 |
| string: http/css-1m | 1097820 | 6889.7 ± 0.9% | 1260.4 ± 0.6% | 1628.9 ± 0.3% | 399.0 ± 28.3% | 1042.8 ± 0.9% | 526.8 ± 3.8% | 5.466 | 4.230 | 17.267 | 6.607 | 13.080 |
| string: dickens as Cyrillic and CJK | 1883069 | 5315.1 ± 0.8% | 3113.5 ± 5.3% | 352.7 ± 6.1% | 266.1 ± 0.8% | 449.1 ± 1.8% | 291.8 ± 0.2% | 1.707 | 15.068 | 19.972 | 11.835 | 18.216 |
| hex: silesia/dickens | 524290 | 31554.1 ± 14.4% | 1579.4 ± 0.4% | 1097.2 ± 0.5% | 417.8 ± 2.5% | 1028.8 ± 0.6% | 450.1 ± 0.8% | 19.979 | 28.759 | 75.519 | 30.672 | 70.111 |
| hex: silesia/mozilla | 524290 | 35245.9 ± 0.5% | 1583.2 ± 2.1% | 1097.5 ± 6.3% | 370.3 ± 0.8% | 1059.8 ± 0.4% | 452.2 ± 7.4% | 22.262 | 32.114 | 95.172 | 33.258 | 77.941 |
| hex: silesia/mr | 524290 | 33857.3 ± 1.1% | 1578.5 ± 0.4% | 1096.9 ± 1.6% | 512.3 ± 2.9% | 1060.8 ± 0.7% | 452.2 ± 2.1% | 21.449 | 30.866 | 66.090 | 31.918 | 74.873 |
| hex: silesia/nci | 524290 | 33443.9 ± 7.1% | 1579.9 ± 0.7% | 1098.3 ± 5.5% | 558.4 ± 6.6% | 1056.8 ± 0.5% | 451.5 ± 0.5% | 21.168 | 30.452 | 59.891 | 31.645 | 74.069 |
| hex: silesia/ooffice | 524290 | 33991.8 ± 0.7% | 1584.0 ± 0.4% | 1098.3 ± 0.7% | 328.8 ± 0.6% | 1057.7 ± 6.2% | 450.0 ± 5.8% | 21.459 | 30.948 | 103.385 | 32.136 | 75.538 |
| hex: silesia/osdb | 524290 | 35764.5 ± 1.2% | 1580.7 ± 1.3% | 1095.8 ± 0.5% | 414.8 ± 0.2% | 1051.4 ± 2.5% | 451.5 ± 0.8% | 22.626 | 32.638 | 86.223 | 34.017 | 79.217 |
| hex: silesia/reymont | 524290 | 35416.8 ± 0.7% | 1585.1 ± 0.7% | 1096.9 ± 0.3% | 438.7 ± 8.6% | 1056.9 ± 1.1% | 451.2 ± 1.6% | 22.344 | 32.288 | 80.733 | 33.510 | 78.502 |
| hex: silesia/samba | 524290 | 34596.5 ± 2.3% | 1583.6 ± 0.5% | 1098.5 ± 0.5% | 332.4 ± 0.7% | 1055.1 ± 0.4% | 449.7 ± 0.9% | 21.847 | 31.496 | 104.066 | 32.789 | 76.935 |
| hex: silesia/sao | 524290 | 33946.2 ± 0.9% | 1584.7 ± 0.4% | 1100.1 ± 0.6% | 266.8 ± 1.4% | 1059.1 ± 4.2% | 449.8 ± 1.4% | 21.421 | 30.858 | 127.252 | 32.051 | 75.465 |
| hex: silesia/webster | 524290 | 37422.4 ± 0.5% | 1585.9 ± 0.4% | 1097.5 ± 11.1% | 390.1 ± 0.9% | 1065.2 ± 0.4% | 451.7 ± 0.4% | 23.596 | 34.097 | 95.921 | 35.132 | 82.845 |
| hex: silesia/x-ray | 524290 | 33735.6 ± 0.6% | 1584.6 ± 1.3% | 1100.6 ± 0.8% | 394.2 ± 0.2% | 1061.9 ± 1.0% | 452.2 ± 1.3% | 21.290 | 30.653 | 85.576 | 31.770 | 74.606 |
| hex: silesia/xml | 524290 | 33355.1 ± 0.3% | 1582.0 ± 0.5% | 1099.0 ± 0.5% | 589.2 ± 0.9% | 1060.6 ± 1.8% | 452.1 ± 0.6% | 21.084 | 30.350 | 56.611 | 31.450 | 73.777 |
| hex: canterbury/alice29.txt | 304180 | 33834.8 ± 8.3% | 1595.7 ± 0.9% | 1102.5 ± 0.9% | 429.8 ± 8.8% | 1073.5 ± 0.7% | 453.7 ± 0.8% | 21.203 | 30.688 | 78.718 | 31.519 | 74.583 |
| hex: canterbury/asyoulik.txt | 250360 | 32125.9 ± 2.3% | 1597.1 ± 1.0% | 1101.1 ± 9.8% | 425.2 ± 1.0% | 1073.7 ± 0.7% | 452.8 ± 0.5% | 20.115 | 29.176 | 75.557 | 29.921 | 70.946 |
| hex: canterbury/cp.html | 49208 | 30816.4 ± 0.6% | 1619.9 ± 0.5% | 1109.8 ± 0.2% | 455.7 ± 0.3% | 1073.9 ± 0.7% | 452.8 ± 1.9% | 19.024 | 27.769 | 67.628 | 28.697 | 68.059 |
| hex: canterbury/fields.c | 22302 | 31056.6 ± 1.0% | 1600.3 ± 0.2% | 1101.1 ± 0.1% | 547.8 ± 1.6% | 1064.9 ± 1.2% | 454.8 ± 0.5% | 19.407 | 28.206 | 56.694 | 29.165 | 68.282 |
| hex: canterbury/grammar.lsp | 7444 | 32350.6 ± 0.3% | 1632.6 ± 1.1% | 1111.1 ± 0.4% | 583.4 ± 1.2% | 1081.9 ± 5.0% | 461.3 ± 1.5% | 19.815 | 29.116 | 55.450 | 29.901 | 70.124 |
| hex: canterbury/kennedy.xls | 524290 | 31992.3 ± 1.4% | 1579.6 ± 0.7% | 1093.8 ± 0.4% | 591.6 ± 0.2% | 1042.3 ± 2.1% | 450.3 ± 0.7% | 20.254 | 29.248 | 54.079 | 30.694 | 71.042 |
| hex: canterbury/lcet10.txt | 524290 | 34888.2 ± 1.3% | 1573.7 ± 1.4% | 1095.3 ± 0.5% | 421.6 ± 0.7% | 1049.5 ± 0.6% | 448.6 ± 0.3% | 22.169 | 31.854 | 82.754 | 33.244 | 77.776 |
| hex: canterbury/plrabn12.txt | 524290 | 33295.2 ± 0.4% | 1580.8 ± 0.9% | 1097.2 ± 0.6% | 420.8 ± 0.9% | 1050.8 ± 0.7% | 449.3 ± 0.4% | 21.062 | 30.344 | 79.131 | 31.687 | 74.109 |
| hex: canterbury/ptt5 | 524290 | 33546.4 ± 1.1% | 1580.6 ± 0.2% | 1097.2 ± 0.5% | 501.8 ± 10.3% | 1051.9 ± 1.0% | 452.7 ± 0.8% | 21.224 | 30.574 | 66.847 | 31.892 | 74.103 |
| hex: canterbury/sum | 76482 | 35487.5 ± 0.2% | 1613.7 ± 3.5% | 1106.1 ± 4.1% | 508.0 ± 0.3% | 1071.5 ± 1.5% | 457.7 ± 1.9% | 21.991 | 32.083 | 69.853 | 33.119 | 77.540 |
| hex: canterbury/xargs.1 | 8456 | 34630.5 ± 0.1% | 1624.4 ± 0.3% | 1105.2 ± 0.7% | 618.6 ± 1.1% | 1081.5 ± 0.9% | 460.2 ± 8.3% | 21.319 | 31.336 | 55.984 | 32.020 | 75.253 |
| hex: canterbury-large/E.coli | 524290 | 30942.7 ± 2.3% | 1573.4 ± 0.6% | 1095.2 ± 0.6% | 606.6 ± 0.3% | 1048.4 ± 0.1% | 450.2 ± 0.4% | 19.666 | 28.254 | 51.007 | 29.514 | 68.729 |
| hex: canterbury-large/bible.txt | 524290 | 35400.3 ± 3.7% | 1578.7 ± 0.5% | 1093.3 ± 1.6% | 434.9 ± 1.0% | 1057.7 ± 0.4% | 449.4 ± 0.7% | 22.423 | 32.380 | 81.395 | 33.470 | 78.776 |
| hex: canterbury-large/world192.txt | 524290 | 35300.8 ± 0.5% | 1579.5 ± 0.6% | 1096.4 ± 0.5% | 423.4 ± 0.3% | 1050.4 ± 1.0% | 449.8 ± 0.9% | 22.349 | 32.197 | 83.383 | 33.607 | 78.483 |
| hex: http/html-1kx1024 | 2099200 | 23886.9 ± 1.6% | 1597.1 ± 1.1% | 1085.7 ± 0.5% | 447.1 ± 0.2% | 1065.2 ± 0.7% | 448.8 ± 8.9% | 14.957 | 22.001 | 53.427 | 22.425 | 53.219 |
| hex: http/html-16kx64 | 2097280 | 29973.8 ± 1.0% | 1609.1 ± 0.3% | 1101.2 ± 0.3% | 442.2 ± 8.2% | 1012.7 ± 1.1% | 452.4 ± 0.8% | 18.628 | 27.218 | 67.785 | 29.597 | 66.248 |
| hex: http/html-1m | 524290 | 29166.5 ± 0.6% | 1571.8 ± 10.1% | 1092.9 ± 0.6% | 441.2 ± 0.5% | 1026.4 ± 0.6% | 449.0 ± 1.1% | 18.556 | 26.687 | 66.104 | 28.415 | 64.964 |
| hex: http/json-1kx1024 | 2099200 | 23596.8 ± 0.8% | 1601.7 ± 0.5% | 1086.3 ± 0.5% | 563.4 ± 0.3% | 1065.3 ± 13.6% | 451.4 ± 1.2% | 14.732 | 21.722 | 41.880 | 22.151 | 52.270 |
| hex: http/json-16kx64 | 2097280 | 30112.5 ± 1.4% | 1605.4 ± 0.1% | 1101.3 ± 0.4% | 549.5 ± 0.8% | 993.3 ± 0.8% | 456.6 ± 0.4% | 18.757 | 27.342 | 54.800 | 30.315 | 65.956 |
| hex: http/json-1m | 524290 | 31599.4 ± 1.8% | 1575.1 ± 1.2% | 1094.2 ± 0.6% | 581.5 ± 0.5% | 1036.5 ± 1.1% | 449.9 ± 0.5% | 20.062 | 28.880 | 54.345 | 30.486 | 70.236 |
| hex: http/js-1kx1024 | 2099200 | 23809.7 ± 1.5% | 1603.3 ± 0.2% | 1087.0 ± 0.2% | 436.7 ± 0.3% | 1062.9 ± 2.2% | 451.8 ± 0.4% | 14.850 | 21.903 | 54.517 | 22.401 | 52.697 |
| hex: http/js-16kx64 | 2097280 | 30168.3 ± 0.7% | 1594.4 ± 6.7% | 1101.9 ± 0.7% | 427.6 ± 0.1% | 994.0 ± 0.7% | 456.8 ± 0.3% | 18.922 | 27.380 | 70.552 | 30.351 | 66.047 |
| hex: http/js-1m | 524290 | 30905.5 ± 0.8% | 1575.0 ± 1.5% | 1096.2 ± 1.0% | 434.4 ± 2.4% | 1054.1 ± 0.7% | 450.6 ± 1.3% | 19.623 | 28.193 | 71.149 | 29.319 | 68.586 |
| hex: http/css-1kx1024 | 2099200 | 23528.4 ± 3.5% | 1600.8 ± 2.9% | 1087.2 ± 0.9% | 496.2 ± 0.4% | 1058.9 ± 0.7% | 452.2 ± 0.7% | 14.698 | 21.641 | 47.421 | 22.219 | 52.036 |
| hex: http/css-16kx64 | 2097280 | 30392.9 ± 1.6% | 1607.7 ± 0.4% | 1102.2 ± 0.3% | 501.2 ± 10.7% | 1059.7 ± 1.0% | 455.7 ± 0.4% | 18.904 | 27.574 | 60.646 | 28.680 | 66.702 |
| hex: http/css-1m | 524290 | 31725.8 ± 2.0% | 1571.2 ± 1.0% | 1092.9 ± 0.6% | 444.8 ± 0.3% | 1009.4 ± 1.4% | 450.3 ± 8.6% | 20.192 | 29.028 | 71.319 | 31.429 | 70.449 |
| hex: shuffled/dickens-1m | 524290 | 35259.7 ± 0.2% | 1575.5 ± 1.3% | 1096.8 ± 0.3% | 424.0 ± 0.3% | 1008.9 ± 0.5% | 451.3 ± 1.6% | 22.379 | 32.147 | 83.152 | 34.949 | 78.120 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1333.4 ± 0.5% | 1041.4 ± 2.4% | 866.2 ± 0.6% | 331.2 ± 1.4% | 365.0 ± 1.1% | 307.3 ± 3.3% | 1.280 | 1.539 | 4.026 | 3.653 | 4.339 |
| qlog records, JSON text sequence | 1467503 | 1160.0 ± 1.5% | 830.5 ± 1.6% | 699.7 ± 2.5% | 319.3 ± 1.9% | 378.7 ± 1.9% | 225.2 ± 7.1% | 1.397 | 1.658 | 3.633 | 3.063 | 5.152 |
| string: silesia/dickens | 172528 | 9445.3 ± 8.0% | 3174.6 ± 3.2% | 2046.5 ± 0.5% | 358.1 ± 0.5% | 1406.4 ± 2.6% | 558.6 ± 0.4% | 2.975 | 4.615 | 26.378 | 6.716 | 16.910 |
| string: silesia/nci | 1075110 | 8874.7 ± 2.7% | 3177.7 ± 3.1% | 2813.5 ± 1.7% | 775.1 ± 0.7% | 1533.8 ± 0.5% | 563.7 ± 1.2% | 2.793 | 3.154 | 11.450 | 5.786 | 15.743 |
| string: silesia/reymont | 1075159 | 3830.9 ± 0.4% | 1592.8 ± 1.4% | 1738.1 ± 0.2% | 361.3 ± 0.2% | 1243.7 ± 0.8% | 550.6 ± 7.4% | 2.405 | 2.204 | 10.603 | 3.080 | 6.957 |
| string: silesia/samba | 97582 | 5093.8 ± 9.2% | 2029.5 ± 0.4% | 2182.9 ± 0.4% | 303.1 ± 9.3% | 1005.3 ± 0.7% | 618.7 ± 0.9% | 2.510 | 2.334 | 16.806 | 5.067 | 8.233 |
| string: silesia/webster | 1098490 | 5092.3 ± 3.2% | 1619.8 ± 1.3% | 1528.1 ± 1.2% | 356.2 ± 1.0% | 1193.8 ± 0.7% | 455.2 ± 0.3% | 3.144 | 3.333 | 14.295 | 4.266 | 11.186 |
| string: silesia/xml | 1090118 | 8432.0 ± 1.4% | 2751.5 ± 1.4% | 2183.6 ± 2.1% | 548.8 ± 14.2% | 1573.3 ± 0.8% | 560.4 ± 1.1% | 3.064 | 3.862 | 15.363 | 5.360 | 15.047 |
| string: canterbury/alice29.txt | 159425 | 9878.9 ± 11.7% | 2549.5 ± 3.1% | 1800.5 ± 0.2% | 337.6 ± 2.0% | 1255.8 ± 15.1% | 553.4 ± 0.4% | 3.875 | 5.487 | 29.263 | 7.866 | 17.851 |
| string: canterbury/asyoulik.txt | 132198 | 8263.4 ± 0.6% | 2286.7 ± 0.9% | 1541.0 ± 3.2% | 344.7 ± 12.8% | 1115.0 ± 1.2% | 540.7 ± 0.6% | 3.614 | 5.362 | 23.975 | 7.411 | 15.282 |
| string: canterbury/lcet10.txt | 441884 | 9314.1 ± 1.4% | 2467.5 ± 1.8% | 1995.1 ± 0.2% | 390.5 ± 0.5% | 1370.4 ± 2.8% | 552.8 ± 0.3% | 3.775 | 4.668 | 23.852 | 6.797 | 16.849 |
| string: canterbury/plrabn12.txt | 503330 | 6382.0 ± 0.5% | 1818.6 ± 1.3% | 1682.6 ± 0.5% | 361.4 ± 3.5% | 1282.4 ± 1.3% | 557.2 ± 2.8% | 3.509 | 3.793 | 17.659 | 4.977 | 11.454 |
| string: canterbury-large/E.coli | 1048578 | 38711.8 ± 1.3% | 19392.8 ± 0.5% | 3385.9 ± 0.4% | 1431.0 ± 1.8% | 2564.7 ± 1.0% | 573.3 ± 0.5% | 1.996 | 11.433 | 27.053 | 15.094 | 67.522 |
| string: canterbury-large/bible.txt | 1055886 | 7283.5 ± 0.3% | 4032.1 ± 0.7% | 2667.4 ± 0.2% | 432.8 ± 0.7% | 1866.6 ± 0.6% | 568.2 ± 0.6% | 1.806 | 2.731 | 16.828 | 3.902 | 12.820 |
| string: canterbury-large/world192.txt | 1103121 | 4787.3 ± 1.5% | 1430.4 ± 4.9% | 1618.5 ± 0.7% | 366.0 ± 0.9% | 1171.7 ± 0.7% | 540.3 ± 1.4% | 3.347 | 2.958 | 13.081 | 4.086 | 8.860 |
| string: http/html-1m | 1058582 | 8663.9 ± 0.5% | 3864.7 ± 2.0% | 2484.7 ± 1.5% | 396.9 ± 0.9% | 1811.4 ± 0.7% | 521.5 ± 0.9% | 2.242 | 3.487 | 21.827 | 4.783 | 16.613 |
| string: http/json-1m | 1190272 | 6813.4 ± 17.6% | 1216.0 ± 0.9% | 1324.0 ± 0.4% | 370.6 ± 0.8% | 891.5 ± 13.5% | 504.9 ± 17.5% | 5.603 | 5.146 | 18.384 | 7.642 | 13.495 |
| string: http/js-1m | 1144362 | 5069.0 ± 0.5% | 995.7 ± 1.3% | 1066.3 ± 0.2% | 283.4 ± 0.8% | 929.8 ± 1.5% | 473.5 ± 0.5% | 5.091 | 4.754 | 17.888 | 5.452 | 10.705 |
| string: http/css-1m | 1097820 | 7240.7 ± 0.9% | 1260.4 ± 0.6% | 1628.9 ± 0.3% | 399.0 ± 28.3% | 1042.8 ± 0.9% | 526.8 ± 3.8% | 5.745 | 4.445 | 18.147 | 6.944 | 13.746 |
| string: dickens as Cyrillic and CJK | 1883069 | 5213.0 ± 1.5% | 3113.5 ± 5.3% | 352.7 ± 6.1% | 266.1 ± 0.8% | 449.1 ± 1.8% | 291.8 ± 0.2% | 1.674 | 14.779 | 19.588 | 11.608 | 17.866 |
| hex: silesia/dickens | 524290 | 31753.7 ± 0.7% | 1579.4 ± 0.4% | 1097.2 ± 0.5% | 417.8 ± 2.5% | 1028.8 ± 0.6% | 450.1 ± 0.8% | 20.105 | 28.941 | 75.997 | 30.866 | 70.555 |
| hex: silesia/mozilla | 524290 | 35314.2 ± 1.5% | 1583.2 ± 2.1% | 1097.5 ± 6.3% | 370.3 ± 0.8% | 1059.8 ± 0.4% | 452.2 ± 7.4% | 22.305 | 32.176 | 95.357 | 33.323 | 78.092 |
| hex: silesia/mr | 524290 | 33974.2 ± 0.3% | 1578.5 ± 0.4% | 1096.9 ± 1.6% | 512.3 ± 2.9% | 1060.8 ± 0.7% | 452.2 ± 2.1% | 21.523 | 30.973 | 66.318 | 32.028 | 75.131 |
| hex: silesia/nci | 524290 | 33546.5 ± 0.6% | 1579.9 ± 0.7% | 1098.3 ± 5.5% | 558.4 ± 6.6% | 1056.8 ± 0.5% | 451.5 ± 0.5% | 21.233 | 30.545 | 60.075 | 31.743 | 74.296 |
| hex: silesia/ooffice | 524290 | 33988.6 ± 1.3% | 1584.0 ± 0.4% | 1098.3 ± 0.7% | 328.8 ± 0.6% | 1057.7 ± 6.2% | 450.0 ± 5.8% | 21.457 | 30.945 | 103.375 | 32.133 | 75.531 |
| hex: silesia/osdb | 524290 | 36093.8 ± 0.8% | 1580.7 ± 1.3% | 1095.8 ± 0.5% | 414.8 ± 0.2% | 1051.4 ± 2.5% | 451.5 ± 0.8% | 22.835 | 32.938 | 87.017 | 34.330 | 79.946 |
| hex: silesia/reymont | 524290 | 35659.7 ± 1.2% | 1585.1 ± 0.7% | 1096.9 ± 0.3% | 438.7 ± 8.6% | 1056.9 ± 1.1% | 451.2 ± 1.6% | 22.497 | 32.509 | 81.286 | 33.740 | 79.041 |
| hex: silesia/samba | 524290 | 34793.3 ± 1.3% | 1583.6 ± 0.5% | 1098.5 ± 0.5% | 332.4 ± 0.7% | 1055.1 ± 0.4% | 449.7 ± 0.9% | 21.971 | 31.675 | 104.658 | 32.976 | 77.372 |
| hex: silesia/sao | 524290 | 33865.6 ± 2.3% | 1584.7 ± 0.4% | 1100.1 ± 0.6% | 266.8 ± 1.4% | 1059.1 ± 4.2% | 449.8 ± 1.4% | 21.370 | 30.784 | 126.950 | 31.975 | 75.286 |
| hex: silesia/webster | 524290 | 37618.9 ± 0.4% | 1585.9 ± 0.4% | 1097.5 ± 11.1% | 390.1 ± 0.9% | 1065.2 ± 0.4% | 451.7 ± 0.4% | 23.720 | 34.276 | 96.425 | 35.317 | 83.280 |
| hex: silesia/x-ray | 524290 | 33763.2 ± 0.6% | 1584.6 ± 1.3% | 1100.6 ± 0.8% | 394.2 ± 0.2% | 1061.9 ± 1.0% | 452.2 ± 1.3% | 21.308 | 30.678 | 85.646 | 31.796 | 74.667 |
| hex: silesia/xml | 524290 | 33208.6 ± 0.9% | 1582.0 ± 0.5% | 1099.0 ± 0.5% | 589.2 ± 0.9% | 1060.6 ± 1.8% | 452.1 ± 0.6% | 20.991 | 30.216 | 56.362 | 31.312 | 73.453 |
| hex: canterbury/alice29.txt | 304180 | 33868.6 ± 0.7% | 1595.7 ± 0.9% | 1102.5 ± 0.9% | 429.8 ± 8.8% | 1073.5 ± 0.7% | 453.7 ± 0.8% | 21.224 | 30.719 | 78.797 | 31.550 | 74.658 |
| hex: canterbury/asyoulik.txt | 250360 | 32179.7 ± 0.7% | 1597.1 ± 1.0% | 1101.1 ± 9.8% | 425.2 ± 1.0% | 1073.7 ± 0.7% | 452.8 ± 0.5% | 20.149 | 29.225 | 75.684 | 29.971 | 71.065 |
| hex: canterbury/cp.html | 49208 | 31036.7 ± 0.3% | 1619.9 ± 0.5% | 1109.8 ± 0.2% | 455.7 ± 0.3% | 1073.9 ± 0.7% | 452.8 ± 1.9% | 19.160 | 27.967 | 68.111 | 28.902 | 68.546 |
| hex: canterbury/fields.c | 22302 | 31117.1 ± 17.7% | 1600.3 ± 0.2% | 1101.1 ± 0.1% | 547.8 ± 1.6% | 1064.9 ± 1.2% | 454.8 ± 0.5% | 19.445 | 28.261 | 56.804 | 29.221 | 68.415 |
| hex: canterbury/grammar.lsp | 7444 | 32842.4 ± 0.5% | 1632.6 ± 1.1% | 1111.1 ± 0.4% | 583.4 ± 1.2% | 1081.9 ± 5.0% | 461.3 ± 1.5% | 20.116 | 29.559 | 56.293 | 30.355 | 71.190 |
| hex: canterbury/kennedy.xls | 524290 | 32171.7 ± 0.5% | 1579.6 ± 0.7% | 1093.8 ± 0.4% | 591.6 ± 0.2% | 1042.3 ± 2.1% | 450.3 ± 0.7% | 20.367 | 29.412 | 54.382 | 30.866 | 71.440 |
| hex: canterbury/lcet10.txt | 524290 | 34795.1 ± 1.1% | 1573.7 ± 1.4% | 1095.3 ± 0.5% | 421.6 ± 0.7% | 1049.5 ± 0.6% | 448.6 ± 0.3% | 22.110 | 31.769 | 82.533 | 33.156 | 77.568 |
| hex: canterbury/plrabn12.txt | 524290 | 33357.2 ± 0.5% | 1580.8 ± 0.9% | 1097.2 ± 0.6% | 420.8 ± 0.9% | 1050.8 ± 0.7% | 449.3 ± 0.4% | 21.101 | 30.401 | 79.278 | 31.746 | 74.247 |
| hex: canterbury/ptt5 | 524290 | 33642.6 ± 1.1% | 1580.6 ± 0.2% | 1097.2 ± 0.5% | 501.8 ± 10.3% | 1051.9 ± 1.0% | 452.7 ± 0.8% | 21.285 | 30.661 | 67.038 | 31.984 | 74.315 |
| hex: canterbury/sum | 76482 | 35511.9 ± 0.2% | 1613.7 ± 3.5% | 1106.1 ± 4.1% | 508.0 ± 0.3% | 1071.5 ± 1.5% | 457.7 ± 1.9% | 22.006 | 32.105 | 69.901 | 33.141 | 77.594 |
| hex: canterbury/xargs.1 | 8456 | 35001.8 ± 0.9% | 1624.4 ± 0.3% | 1105.2 ± 0.7% | 618.6 ± 1.1% | 1081.5 ± 0.9% | 460.2 ± 8.3% | 21.548 | 31.672 | 56.584 | 32.363 | 76.060 |
| hex: canterbury-large/E.coli | 524290 | 30781.7 ± 0.8% | 1573.4 ± 0.6% | 1095.2 ± 0.6% | 606.6 ± 0.3% | 1048.4 ± 0.1% | 450.2 ± 0.4% | 19.563 | 28.106 | 50.741 | 29.360 | 68.372 |
| hex: canterbury-large/bible.txt | 524290 | 35619.8 ± 1.6% | 1578.7 ± 0.5% | 1093.3 ± 1.6% | 434.9 ± 1.0% | 1057.7 ± 0.4% | 449.4 ± 0.7% | 22.562 | 32.581 | 81.900 | 33.678 | 79.265 |
| hex: canterbury-large/world192.txt | 524290 | 35591.3 ± 0.4% | 1579.5 ± 0.6% | 1096.4 ± 0.5% | 423.4 ± 0.3% | 1050.4 ± 1.0% | 449.8 ± 0.9% | 22.533 | 32.462 | 84.069 | 33.883 | 79.129 |
| hex: http/html-1kx1024 | 2099200 | 24361.6 ± 0.4% | 1597.1 ± 1.1% | 1085.7 ± 0.5% | 447.1 ± 0.2% | 1065.2 ± 0.7% | 448.8 ± 8.9% | 15.254 | 22.438 | 54.489 | 22.871 | 54.276 |
| hex: http/html-16kx64 | 2097280 | 30320.3 ± 0.5% | 1609.1 ± 0.3% | 1101.2 ± 0.3% | 442.2 ± 8.2% | 1012.7 ± 1.1% | 452.4 ± 0.8% | 18.843 | 27.533 | 68.568 | 29.940 | 67.014 |
| hex: http/html-1m | 524290 | 29059.4 ± 0.5% | 1571.8 ± 10.1% | 1092.9 ± 0.6% | 441.2 ± 0.5% | 1026.4 ± 0.6% | 449.0 ± 1.1% | 18.488 | 26.589 | 65.861 | 28.311 | 64.725 |
| hex: http/json-1kx1024 | 2099200 | 24050.8 ± 1.8% | 1601.7 ± 0.5% | 1086.3 ± 0.5% | 563.4 ± 0.3% | 1065.3 ± 13.6% | 451.4 ± 1.2% | 15.016 | 22.140 | 42.686 | 22.577 | 53.275 |
| hex: http/json-16kx64 | 2097280 | 30113.6 ± 1.4% | 1605.4 ± 0.1% | 1101.3 ± 0.4% | 549.5 ± 0.8% | 993.3 ± 0.8% | 456.6 ± 0.4% | 18.758 | 27.343 | 54.802 | 30.316 | 65.958 |
| hex: http/json-1m | 524290 | 31730.8 ± 1.1% | 1575.1 ± 1.2% | 1094.2 ± 0.6% | 581.5 ± 0.5% | 1036.5 ± 1.1% | 449.9 ± 0.5% | 20.146 | 29.000 | 54.571 | 30.613 | 70.528 |
| hex: http/js-1kx1024 | 2099200 | 24136.0 ± 1.6% | 1603.3 ± 0.2% | 1087.0 ± 0.2% | 436.7 ± 0.3% | 1062.9 ± 2.2% | 451.8 ± 0.4% | 15.054 | 22.204 | 55.265 | 22.708 | 53.419 |
| hex: http/js-16kx64 | 2097280 | 30058.3 ± 0.9% | 1594.4 ± 6.7% | 1101.9 ± 0.7% | 427.6 ± 0.1% | 994.0 ± 0.7% | 456.8 ± 0.3% | 18.853 | 27.280 | 70.295 | 30.241 | 65.806 |
| hex: http/js-1m | 524290 | 31019.4 ± 0.6% | 1575.0 ± 1.5% | 1096.2 ± 1.0% | 434.4 ± 2.4% | 1054.1 ± 0.7% | 450.6 ± 1.3% | 19.695 | 28.297 | 71.411 | 29.427 | 68.839 |
| hex: http/css-1kx1024 | 2099200 | 24053.0 ± 2.1% | 1600.8 ± 2.9% | 1087.2 ± 0.9% | 496.2 ± 0.4% | 1058.9 ± 0.7% | 452.2 ± 0.7% | 15.026 | 22.124 | 48.478 | 22.715 | 53.196 |
| hex: http/css-16kx64 | 2097280 | 30658.2 ± 1.1% | 1607.7 ± 0.4% | 1102.2 ± 0.3% | 501.2 ± 10.7% | 1059.7 ± 1.0% | 455.7 ± 0.4% | 19.069 | 27.815 | 61.175 | 28.930 | 67.284 |
| hex: http/css-1m | 524290 | 31860.2 ± 0.4% | 1571.2 ± 1.0% | 1092.9 ± 0.6% | 444.8 ± 0.3% | 1009.4 ± 1.4% | 450.3 ± 8.6% | 20.277 | 29.151 | 71.621 | 31.563 | 70.748 |
| hex: shuffled/dickens-1m | 524290 | 35451.5 ± 0.7% | 1575.5 ± 1.3% | 1096.8 ± 0.3% | 424.0 ± 0.3% | 1008.9 ± 0.5% | 451.3 ± 1.6% | 22.501 | 32.321 | 83.604 | 35.140 | 78.545 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 648.1 ± 0.4% | 1014.7 ± 1.2% | 936.7 ± 1.0% | 260.0 ± 4.0% | 527.4 ± 0.4% | 250.5 ± 5.0% | 0.639 | 0.692 | 2.492 | 1.229 | 2.587 |
| qlog records, JSON text sequence | 1467503 | 431.0 ± 15.9% | 804.4 ± 0.8% | 683.2 ± 26.5% | 204.4 ± 5.1% | 507.1 ± 19.4% | 220.1 ± 11.7% | 0.536 | 0.631 | 2.109 | 0.850 | 1.958 |
| string: silesia/dickens | 172528 | 934.1 ± 3.0% | 2921.9 ± 1.3% | 2063.9 ± 0.5% | 285.0 ± 0.5% | 2189.2 ± 0.5% | 465.8 ± 6.6% | 0.320 | 0.453 | 3.278 | 0.427 | 2.006 |
| string: silesia/nci | 1075110 | 1147.8 ± 2.9% | 3536.8 ± 0.1% | 2726.9 ± 1.5% | 425.5 ± 1.9% | 2457.5 ± 0.8% | 515.7 ± 5.4% | 0.325 | 0.421 | 2.698 | 0.467 | 2.226 |
| string: silesia/reymont | 1075159 | 898.6 ± 2.1% | 2190.0 ± 1.0% | 1727.5 ± 4.0% | 293.9 ± 0.8% | 1644.1 ± 1.1% | 466.5 ± 4.8% | 0.410 | 0.520 | 3.057 | 0.547 | 1.926 |
| string: silesia/samba | 97582 | 209.2 ± 7.6% | 2887.3 ± 4.5% | 1646.8 ± 9.2% | 239.7 ± 0.2% | 1281.3 ± 0.3% | 341.5 ± 1.3% | 0.072 | 0.127 | 0.873 | 0.163 | 0.613 |
| string: silesia/webster | 1098490 | 667.2 ± 1.8% | 2047.3 ± 0.2% | 1574.6 ± 6.9% | 285.5 ± 0.5% | 1667.4 ± 0.6% | 415.3 ± 2.6% | 0.326 | 0.424 | 2.337 | 0.400 | 1.607 |
| string: silesia/xml | 1090118 | 1056.6 ± 0.6% | 3691.5 ± 4.8% | 2128.0 ± 2.8% | 373.8 ± 0.8% | 2332.5 ± 1.1% | 483.5 ± 16.3% | 0.286 | 0.497 | 2.827 | 0.453 | 2.185 |
| string: canterbury/alice29.txt | 159425 | 682.5 ± 1.7% | 2453.8 ± 3.4% | 1871.2 ± 3.0% | 268.6 ± 0.6% | 1923.1 ± 4.9% | 420.9 ± 1.8% | 0.278 | 0.365 | 2.541 | 0.355 | 1.621 |
| string: canterbury/asyoulik.txt | 132198 | 576.9 ± 1.2% | 2143.5 ± 0.4% | 1479.3 ± 1.6% | 257.9 ± 1.0% | 1571.6 ± 0.5% | 371.0 ± 14.3% | 0.269 | 0.390 | 2.237 | 0.367 | 1.555 |
| string: canterbury/lcet10.txt | 441884 | 892.8 ± 2.4% | 2823.7 ± 0.7% | 1985.6 ± 2.1% | 308.9 ± 0.3% | 2125.7 ± 0.4% | 461.7 ± 3.7% | 0.316 | 0.450 | 2.890 | 0.420 | 1.934 |
| string: canterbury/plrabn12.txt | 503330 | 779.9 ± 3.6% | 2742.1 ± 0.3% | 1674.9 ± 0.9% | 281.4 ± 1.1% | 2011.2 ± 0.5% | 438.1 ± 1.2% | 0.284 | 0.466 | 2.772 | 0.388 | 1.780 |
| string: canterbury-large/E.coli | 1048578 | 17939.9 ± 1.0% | 7809.6 ± 0.6% | 3491.1 ± 6.2% | 799.1 ± 0.1% | 5500.1 ± 1.1% | 786.5 ± 2.0% | 2.297 | 5.139 | 22.450 | 3.262 | 22.810 |
| string: canterbury-large/bible.txt | 1055886 | 2533.5 ± 7.9% | 3937.7 ± 0.6% | 2580.9 ± 1.1% | 329.7 ± 0.2% | 2979.4 ± 1.1% | 595.8 ± 1.7% | 0.643 | 0.982 | 7.684 | 0.850 | 4.252 |
| string: canterbury-large/world192.txt | 1103121 | 609.3 ± 1.5% | 2005.8 ± 0.5% | 1655.9 ± 0.8% | 277.5 ± 1.7% | 1694.1 ± 0.8% | 433.5 ± 0.5% | 0.304 | 0.368 | 2.196 | 0.360 | 1.405 |
| string: http/html-1m | 1058582 | 2159.6 ± 1.3% | 3405.6 ± 0.7% | 2379.5 ± 2.5% | 371.3 ± 0.3% | 2735.7 ± 2.4% | 422.2 ± 8.5% | 0.634 | 0.908 | 5.817 | 0.789 | 5.115 |
| string: http/json-1m | 1190272 | 291.8 ± 0.4% | 1256.9 ± 0.2% | 1435.1 ± 6.4% | 307.9 ± 1.7% | 818.1 ± 0.7% | 295.0 ± 0.2% | 0.232 | 0.203 | 0.947 | 0.357 | 0.989 |
| string: http/js-1m | 1144362 | 363.6 ± 3.5% | 1345.1 ± 1.1% | 1154.3 ± 0.9% | 255.5 ± 0.8% | 1162.4 ± 1.7% | 295.3 ± 1.5% | 0.270 | 0.315 | 1.423 | 0.313 | 1.231 |
| string: http/css-1m | 1097820 | 618.3 ± 1.8% | 2560.6 ± 1.1% | 1525.1 ± 1.2% | 338.2 ± 0.9% | 1532.2 ± 2.1% | 334.1 ± 11.1% | 0.241 | 0.405 | 1.828 | 0.404 | 1.851 |
| string: dickens as Cyrillic and CJK | 1883069 | 925.0 ± 7.5% | 3195.4 ± 3.2% | 650.7 ± 1.2% | 244.8 ± 0.6% | 498.6 ± 3.6% | 140.9 ± 8.2% | 0.289 | 1.422 | 3.779 | 1.855 | 6.566 |
| string: dickens as Cyrillic and CJK, as \u escapes | 5075485 | 89.9 ± 0.9% | 1077.4 ± 7.7% | 815.0 ± 1.2% | 147.1 ± 4.6% | 383.2 ± 0.2% | 195.8 ± 4.4% | 0.083 | 0.110 | 0.611 | 0.234 | 0.459 |
| hex: silesia/dickens | 524290 | 18105.2 ± 1.3% | 7827.2 ± 0.6% | 3513.9 ± 1.1% | 422.8 ± 0.3% | 5504.5 ± 0.7% | 797.0 ± 3.7% | 2.313 | 5.152 | 42.822 | 3.289 | 22.716 |
| hex: silesia/mozilla | 524290 | 17955.8 ± 1.1% | 7823.5 ± 0.9% | 3512.6 ± 6.4% | 360.3 ± 2.1% | 5507.2 ± 0.4% | 795.2 ± 1.6% | 2.295 | 5.112 | 49.835 | 3.260 | 22.580 |
| hex: silesia/mr | 524290 | 17867.9 ± 6.9% | 7776.8 ± 3.5% | 3527.3 ± 0.5% | 514.5 ± 0.6% | 5504.3 ± 0.7% | 794.1 ± 3.4% | 2.298 | 5.066 | 34.726 | 3.246 | 22.501 |
| hex: silesia/nci | 524290 | 18001.5 ± 10.8% | 7831.8 ± 0.2% | 3528.2 ± 1.4% | 577.2 ± 4.4% | 5529.0 ± 0.3% | 796.1 ± 5.9% | 2.299 | 5.102 | 31.186 | 3.256 | 22.613 |
| hex: silesia/ooffice | 524290 | 17939.4 ± 1.8% | 7810.2 ± 0.3% | 3519.9 ± 0.7% | 319.1 ± 0.6% | 5497.5 ± 0.7% | 796.4 ± 1.1% | 2.297 | 5.097 | 56.225 | 3.263 | 22.525 |
| hex: silesia/osdb | 524290 | 17984.4 ± 0.8% | 7816.0 ± 0.6% | 3522.8 ± 1.4% | 406.9 ± 0.4% | 5493.1 ± 1.0% | 804.8 ± 6.2% | 2.301 | 5.105 | 44.196 | 3.274 | 22.348 |
| hex: silesia/reymont | 524290 | 18046.2 ± 1.0% | 7771.3 ± 0.7% | 3521.4 ± 1.0% | 435.0 ± 0.9% | 5442.0 ± 16.8% | 806.2 ± 3.3% | 2.322 | 5.125 | 41.489 | 3.316 | 22.385 |
| hex: silesia/samba | 524290 | 17784.0 ± 0.5% | 7818.1 ± 2.2% | 3533.7 ± 0.6% | 322.9 ± 2.0% | 5522.2 ± 0.3% | 808.8 ± 2.6% | 2.275 | 5.033 | 55.084 | 3.220 | 21.989 |
| hex: silesia/sao | 524290 | 18077.4 ± 1.1% | 7805.7 ± 0.9% | 3498.2 ± 0.5% | 263.0 ± 0.3% | 5492.2 ± 1.1% | 810.6 ± 1.6% | 2.316 | 5.168 | 68.739 | 3.291 | 22.301 |
| hex: silesia/webster | 524290 | 18094.7 ± 1.3% | 7817.6 ± 0.8% | 3529.0 ± 2.6% | 385.2 ± 3.7% | 5498.8 ± 4.7% | 811.2 ± 1.2% | 2.315 | 5.127 | 46.979 | 3.291 | 22.307 |
| hex: silesia/x-ray | 524290 | 17798.0 ± 1.8% | 7768.1 ± 0.7% | 3511.9 ± 0.9% | 385.6 ± 1.0% | 5515.7 ± 0.7% | 812.1 ± 0.8% | 2.291 | 5.068 | 46.154 | 3.227 | 21.917 |
| hex: silesia/xml | 524290 | 18042.2 ± 0.4% | 7814.1 ± 1.9% | 3534.6 ± 0.5% | 507.7 ± 0.4% | 5523.0 ± 0.9% | 812.5 ± 2.2% | 2.309 | 5.104 | 35.534 | 3.267 | 22.206 |
| hex: canterbury/alice29.txt | 304180 | 17813.2 ± 0.7% | 7814.4 ± 1.3% | 3565.9 ± 0.4% | 424.0 ± 0.5% | 5517.3 ± 0.2% | 809.8 ± 1.8% | 2.280 | 4.995 | 42.011 | 3.229 | 21.997 |
| hex: canterbury/asyoulik.txt | 250360 | 18300.4 ± 0.7% | 7792.3 ± 0.2% | 3542.6 ± 0.8% | 414.4 ± 7.4% | 5505.6 ± 0.3% | 808.0 ± 0.9% | 2.349 | 5.166 | 44.157 | 3.324 | 22.648 |
| hex: canterbury/cp.html | 49208 | 18355.2 ± 5.2% | 7793.5 ± 0.4% | 3572.1 ± 0.7% | 403.8 ± 0.4% | 5468.9 ± 0.4% | 788.4 ± 1.8% | 2.355 | 5.138 | 45.452 | 3.356 | 23.282 |
| hex: canterbury/fields.c | 22302 | 18039.2 ± 1.3% | 7710.6 ± 0.3% | 3581.7 ± 0.5% | 429.2 ± 0.3% | 5461.1 ± 0.5% | 776.4 ± 3.5% | 2.340 | 5.036 | 42.031 | 3.303 | 23.235 |
| hex: canterbury/grammar.lsp | 7444 | 16730.8 ± 1.7% | 7509.7 ± 0.5% | 3558.7 ± 0.5% | 482.8 ± 2.1% | 5358.4 ± 1.2% | 765.2 ± 1.1% | 2.228 | 4.701 | 34.650 | 3.122 | 21.864 |
| hex: canterbury/kennedy.xls | 524290 | 17903.4 ± 0.8% | 7781.9 ± 0.7% | 3541.8 ± 0.4% | 597.9 ± 0.3% | 5487.4 ± 0.8% | 799.3 ± 3.1% | 2.301 | 5.055 | 29.942 | 3.263 | 22.400 |
| hex: canterbury/lcet10.txt | 524290 | 17995.8 ± 8.6% | 7807.9 ± 0.5% | 3521.0 ± 2.5% | 425.1 ± 12.2% | 5511.5 ± 0.2% | 789.0 ± 4.5% | 2.305 | 5.111 | 42.329 | 3.265 | 22.809 |
| hex: canterbury/plrabn12.txt | 524290 | 17897.1 ± 1.0% | 7819.4 ± 0.6% | 3505.1 ± 1.9% | 414.6 ± 0.4% | 5513.6 ± 0.5% | 794.5 ± 2.2% | 2.289 | 5.106 | 43.162 | 3.246 | 22.526 |
| hex: canterbury/ptt5 | 524290 | 18157.2 ± 0.4% | 7776.0 ± 4.6% | 3512.8 ± 4.6% | 509.0 ± 2.5% | 5503.9 ± 0.9% | 792.4 ± 3.5% | 2.335 | 5.169 | 35.670 | 3.299 | 22.915 |
| hex: canterbury/sum | 76482 | 18526.6 ± 5.3% | 7809.8 ± 1.7% | 3556.4 ± 0.7% | 458.6 ± 1.2% | 5471.6 ± 0.6% | 801.3 ± 7.6% | 2.372 | 5.209 | 40.401 | 3.386 | 23.121 |
| hex: canterbury/xargs.1 | 8456 | 17178.5 ± 0.6% | 7541.4 ± 0.7% | 3549.2 ± 0.6% | 450.0 ± 0.3% | 5353.2 ± 1.2% | 783.2 ± 2.1% | 2.278 | 4.840 | 38.174 | 3.209 | 21.933 |
| hex: canterbury-large/E.coli | 524290 | 18077.7 ± 0.5% | 7791.4 ± 0.8% | 3489.8 ± 1.2% | 709.9 ± 12.9% | 5510.0 ± 0.2% | 784.6 ± 4.3% | 2.320 | 5.180 | 25.467 | 3.281 | 23.041 |
| hex: canterbury-large/bible.txt | 524290 | 17384.8 ± 0.5% | 7777.0 ± 0.7% | 3489.4 ± 1.2% | 438.6 ± 0.9% | 5498.7 ± 7.7% | 790.0 ± 4.0% | 2.235 | 4.982 | 39.640 | 3.162 | 22.006 |
| hex: canterbury-large/world192.txt | 524290 | 17957.2 ± 1.7% | 7791.7 ± 0.5% | 3488.0 ± 1.1% | 408.5 ± 11.8% | 5510.0 ± 0.6% | 772.5 ± 3.2% | 2.305 | 5.148 | 43.955 | 3.259 | 23.246 |
| hex: http/html-1kx1024 | 2099200 | 12218.0 ± 18.9% | 6653.0 ± 0.2% | 3209.0 ± 0.7% | 422.3 ± 0.6% | 4693.0 ± 1.7% | 680.9 ± 6.3% | 1.836 | 3.807 | 28.933 | 2.603 | 17.944 |
| hex: http/html-16kx64 | 2097280 | 17754.7 ± 1.0% | 7677.0 ± 0.5% | 3459.0 ± 1.1% | 430.5 ± 0.2% | 5416.2 ± 0.3% | 775.9 ± 8.6% | 2.313 | 5.133 | 41.245 | 3.278 | 22.883 |
| hex: http/html-1m | 524290 | 18020.6 ± 0.8% | 7803.0 ± 2.3% | 3500.9 ± 0.5% | 428.6 ± 0.6% | 5501.4 ± 4.6% | 800.7 ± 5.0% | 2.309 | 5.147 | 42.045 | 3.276 | 22.506 |
| hex: http/json-1kx1024 | 2099200 | 12225.7 ± 0.7% | 6621.9 ± 0.9% | 3214.3 ± 1.0% | 523.5 ± 3.3% | 4698.2 ± 1.0% | 695.7 ± 2.0% | 1.846 | 3.804 | 23.354 | 2.602 | 17.574 |
| hex: http/json-16kx64 | 2097280 | 17431.3 ± 0.4% | 7647.6 ± 0.1% | 3446.9 ± 0.5% | 543.0 ± 0.5% | 5411.9 ± 0.2% | 770.0 ± 14.6% | 2.279 | 5.057 | 32.100 | 3.221 | 22.638 |
| hex: http/json-1m | 524290 | 17974.2 ± 0.5% | 7818.7 ± 0.3% | 3520.0 ± 1.5% | 534.0 ± 1.7% | 5509.3 ± 0.4% | 772.7 ± 2.6% | 2.299 | 5.106 | 33.658 | 3.263 | 23.260 |
| hex: http/js-1kx1024 | 2099200 | 11731.9 ± 0.3% | 6647.7 ± 4.4% | 3186.7 ± 2.7% | 419.7 ± 0.5% | 4712.2 ± 0.6% | 705.2 ± 5.1% | 1.765 | 3.681 | 27.954 | 2.490 | 16.635 |
| hex: http/js-16kx64 | 2097280 | 17458.8 ± 0.5% | 7678.4 ± 0.4% | 3465.0 ± 0.5% | 425.3 ± 0.2% | 5410.9 ± 2.4% | 784.2 ± 3.0% | 2.274 | 5.039 | 41.049 | 3.227 | 22.263 |
| hex: http/js-1m | 524290 | 18028.2 ± 1.7% | 7820.4 ± 0.3% | 3518.3 ± 1.9% | 436.7 ± 13.1% | 5506.1 ± 0.8% | 799.2 ± 3.4% | 2.305 | 5.124 | 41.278 | 3.274 | 22.558 |
| hex: http/css-1kx1024 | 2099200 | 12199.7 ± 19.7% | 6643.9 ± 3.7% | 3205.3 ± 3.1% | 454.9 ± 0.7% | 4702.9 ± 1.0% | 692.4 ± 1.8% | 1.836 | 3.806 | 26.820 | 2.594 | 17.620 |
| hex: http/css-16kx64 | 2097280 | 17474.2 ± 0.4% | 7668.7 ± 0.6% | 3458.2 ± 0.8% | 466.1 ± 0.2% | 5418.2 ± 0.5% | 769.2 ± 2.3% | 2.279 | 5.053 | 37.488 | 3.225 | 22.716 |
| hex: http/css-1m | 524290 | 17962.9 ± 1.2% | 7806.8 ± 0.3% | 3518.3 ± 1.2% | 455.2 ± 0.6% | 5493.4 ± 1.4% | 786.3 ± 3.2% | 2.301 | 5.106 | 39.465 | 3.270 | 22.845 |
| hex: shuffled/dickens-1m | 524290 | 17805.2 ± 1.8% | 7782.0 ± 0.8% | 3493.6 ± 2.0% | 423.8 ± 0.3% | 5498.5 ± 1.0% | 797.5 ± 3.1% | 2.288 | 5.096 | 42.011 | 3.238 | 22.325 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 965.2 ± 0.4% | 1041.4 ± 2.4% | 866.2 ± 0.6% | 331.2 ± 1.4% | 365.0 ± 1.1% | 307.3 ± 3.3% | 0.927 | 1.114 | 2.915 | 2.644 | 3.141 |
| qlog records, JSON text sequence | 1467503 | 800.5 ± 3.7% | 830.5 ± 1.6% | 699.7 ± 2.5% | 319.3 ± 1.9% | 378.7 ± 1.9% | 225.2 ± 7.1% | 0.964 | 1.144 | 2.507 | 2.114 | 3.555 |
| string: silesia/dickens | 172528 | 9110.4 ± 0.5% | 3174.6 ± 3.2% | 2046.5 ± 0.5% | 358.1 ± 0.5% | 1406.4 ± 2.6% | 558.6 ± 0.4% | 2.870 | 4.452 | 25.443 | 6.478 | 16.310 |
| string: silesia/nci | 1075110 | 8711.6 ± 5.6% | 3177.7 ± 3.1% | 2813.5 ± 1.7% | 775.1 ± 0.7% | 1533.8 ± 0.5% | 563.7 ± 1.2% | 2.741 | 3.096 | 11.239 | 5.680 | 15.453 |
| string: silesia/reymont | 1075159 | 3824.1 ± 0.8% | 1592.8 ± 1.4% | 1738.1 ± 0.2% | 361.3 ± 0.2% | 1243.7 ± 0.8% | 550.6 ± 7.4% | 2.401 | 2.200 | 10.584 | 3.075 | 6.945 |
| string: silesia/samba | 97582 | 4594.7 ± 0.3% | 2029.5 ± 0.4% | 2182.9 ± 0.4% | 303.1 ± 9.3% | 1005.3 ± 0.7% | 618.7 ± 0.9% | 2.264 | 2.105 | 15.159 | 4.571 | 7.426 |
| string: silesia/webster | 1098490 | 5076.8 ± 0.4% | 1619.8 ± 1.3% | 1528.1 ± 1.2% | 356.2 ± 1.0% | 1193.8 ± 0.7% | 455.2 ± 0.3% | 3.134 | 3.322 | 14.252 | 4.252 | 11.152 |
| string: silesia/xml | 1090118 | 8090.1 ± 0.6% | 2751.5 ± 1.4% | 2183.6 ± 2.1% | 548.8 ± 14.2% | 1573.3 ± 0.8% | 560.4 ± 1.1% | 2.940 | 3.705 | 14.740 | 5.142 | 14.437 |
| string: canterbury/alice29.txt | 159425 | 9571.7 ± 0.9% | 2549.5 ± 3.1% | 1800.5 ± 0.2% | 337.6 ± 2.0% | 1255.8 ± 15.1% | 553.4 ± 0.4% | 3.754 | 5.316 | 28.353 | 7.622 | 17.296 |
| string: canterbury/asyoulik.txt | 132198 | 7991.1 ± 1.0% | 2286.7 ± 0.9% | 1541.0 ± 3.2% | 344.7 ± 12.8% | 1115.0 ± 1.2% | 540.7 ± 0.6% | 3.495 | 5.186 | 23.185 | 7.167 | 14.778 |
| string: canterbury/lcet10.txt | 441884 | 9138.9 ± 13.8% | 2467.5 ± 1.8% | 1995.1 ± 0.2% | 390.5 ± 0.5% | 1370.4 ± 2.8% | 552.8 ± 0.3% | 3.704 | 4.581 | 23.404 | 6.669 | 16.532 |
| string: canterbury/plrabn12.txt | 503330 | 6111.2 ± 0.5% | 1818.6 ± 1.3% | 1682.6 ± 0.5% | 361.4 ± 3.5% | 1282.4 ± 1.3% | 557.2 ± 2.8% | 3.360 | 3.632 | 16.909 | 4.766 | 10.968 |
| string: canterbury-large/E.coli | 1048578 | 38842.5 ± 0.5% | 19392.8 ± 0.5% | 3385.9 ± 0.4% | 1431.0 ± 1.8% | 2564.7 ± 1.0% | 573.3 ± 0.5% | 2.003 | 11.472 | 27.144 | 15.145 | 67.750 |
| string: canterbury-large/bible.txt | 1055886 | 6949.6 ± 0.3% | 4032.1 ± 0.7% | 2667.4 ± 0.2% | 432.8 ± 0.7% | 1866.6 ± 0.6% | 568.2 ± 0.6% | 1.724 | 2.605 | 16.057 | 3.723 | 12.232 |
| string: canterbury-large/world192.txt | 1103121 | 4846.3 ± 14.9% | 1430.4 ± 4.9% | 1618.5 ± 0.7% | 366.0 ± 0.9% | 1171.7 ± 0.7% | 540.3 ± 1.4% | 3.388 | 2.994 | 13.242 | 4.136 | 8.969 |
| string: http/html-1m | 1058582 | 8615.7 ± 0.4% | 3864.7 ± 2.0% | 2484.7 ± 1.5% | 396.9 ± 0.9% | 1811.4 ± 0.7% | 521.5 ± 0.9% | 2.229 | 3.467 | 21.706 | 4.756 | 16.521 |
| string: http/json-1m | 1190272 | 6697.1 ± 0.5% | 1216.0 ± 0.9% | 1324.0 ± 0.4% | 370.6 ± 0.8% | 891.5 ± 13.5% | 504.9 ± 17.5% | 5.507 | 5.058 | 18.070 | 7.512 | 13.264 |
| string: http/js-1m | 1144362 | 5107.3 ± 0.5% | 995.7 ± 1.3% | 1066.3 ± 0.2% | 283.4 ± 0.8% | 929.8 ± 1.5% | 473.5 ± 0.5% | 5.129 | 4.790 | 18.023 | 5.493 | 10.786 |
| string: http/css-1m | 1097820 | 6941.3 ± 0.9% | 1260.4 ± 0.6% | 1628.9 ± 0.3% | 399.0 ± 28.3% | 1042.8 ± 0.9% | 526.8 ± 3.8% | 5.507 | 4.261 | 17.396 | 6.657 | 13.177 |
| string: dickens as Cyrillic and CJK | 1883069 | 5331.7 ± 1.5% | 3113.5 ± 5.3% | 352.7 ± 6.1% | 266.1 ± 0.8% | 449.1 ± 1.8% | 291.8 ± 0.2% | 1.712 | 15.115 | 20.034 | 11.872 | 18.273 |
| hex: silesia/dickens | 524290 | 31476.2 ± 3.5% | 1579.4 ± 0.4% | 1097.2 ± 0.5% | 417.8 ± 2.5% | 1028.8 ± 0.6% | 450.1 ± 0.8% | 19.930 | 28.688 | 75.333 | 30.596 | 69.938 |
| hex: silesia/mozilla | 524290 | 34897.6 ± 13.0% | 1583.2 ± 2.1% | 1097.5 ± 6.3% | 370.3 ± 0.8% | 1059.8 ± 0.4% | 452.2 ± 7.4% | 22.042 | 31.797 | 94.232 | 32.930 | 77.171 |
| hex: silesia/mr | 524290 | 33835.5 ± 0.8% | 1578.5 ± 0.4% | 1096.9 ± 1.6% | 512.3 ± 2.9% | 1060.8 ± 0.7% | 452.2 ± 2.1% | 21.435 | 30.847 | 66.048 | 31.897 | 74.825 |
| hex: silesia/nci | 524290 | 33461.8 ± 8.7% | 1579.9 ± 0.7% | 1098.3 ± 5.5% | 558.4 ± 6.6% | 1056.8 ± 0.5% | 451.5 ± 0.5% | 21.179 | 30.468 | 59.923 | 31.662 | 74.108 |
| hex: silesia/ooffice | 524290 | 33858.5 ± 1.0% | 1584.0 ± 0.4% | 1098.3 ± 0.7% | 328.8 ± 0.6% | 1057.7 ± 6.2% | 450.0 ± 5.8% | 21.375 | 30.827 | 102.980 | 32.010 | 75.242 |
| hex: silesia/osdb | 524290 | 35631.3 ± 2.0% | 1580.7 ± 1.3% | 1095.8 ± 0.5% | 414.8 ± 0.2% | 1051.4 ± 2.5% | 451.5 ± 0.8% | 22.542 | 32.516 | 85.902 | 33.890 | 78.922 |
| hex: silesia/reymont | 524290 | 35454.7 ± 0.3% | 1585.1 ± 0.7% | 1096.9 ± 0.3% | 438.7 ± 8.6% | 1056.9 ± 1.1% | 451.2 ± 1.6% | 22.368 | 32.322 | 80.819 | 33.546 | 78.586 |
| hex: silesia/samba | 524290 | 34690.3 ± 1.0% | 1583.6 ± 0.5% | 1098.5 ± 0.5% | 332.4 ± 0.7% | 1055.1 ± 0.4% | 449.7 ± 0.9% | 21.906 | 31.581 | 104.348 | 32.878 | 77.143 |
| hex: silesia/sao | 524290 | 33675.7 ± 0.8% | 1584.7 ± 0.4% | 1100.1 ± 0.6% | 266.8 ± 1.4% | 1059.1 ± 4.2% | 449.8 ± 1.4% | 21.251 | 30.612 | 126.238 | 31.796 | 74.864 |
| hex: silesia/webster | 524290 | 37373.8 ± 0.5% | 1585.9 ± 0.4% | 1097.5 ± 11.1% | 390.1 ± 0.9% | 1065.2 ± 0.4% | 451.7 ± 0.4% | 23.566 | 34.053 | 95.797 | 35.087 | 82.738 |
| hex: silesia/x-ray | 524290 | 33797.4 ± 0.3% | 1584.6 ± 1.3% | 1100.6 ± 0.8% | 394.2 ± 0.2% | 1061.9 ± 1.0% | 452.2 ± 1.3% | 21.329 | 30.709 | 85.732 | 31.828 | 74.742 |
| hex: silesia/xml | 524290 | 33166.4 ± 0.8% | 1582.0 ± 0.5% | 1099.0 ± 0.5% | 589.2 ± 0.9% | 1060.6 ± 1.8% | 452.1 ± 0.6% | 20.965 | 30.178 | 56.291 | 31.272 | 73.360 |
| hex: canterbury/alice29.txt | 304180 | 33773.1 ± 0.6% | 1595.7 ± 0.9% | 1102.5 ± 0.9% | 429.8 ± 8.8% | 1073.5 ± 0.7% | 453.7 ± 0.8% | 21.164 | 30.632 | 78.575 | 31.461 | 74.447 |
| hex: canterbury/asyoulik.txt | 250360 | 32238.6 ± 2.4% | 1597.1 ± 1.0% | 1101.1 ± 9.8% | 425.2 ± 1.0% | 1073.7 ± 0.7% | 452.8 ± 0.5% | 20.185 | 29.278 | 75.822 | 30.026 | 71.195 |
| hex: canterbury/cp.html | 49208 | 31050.4 ± 1.7% | 1619.9 ± 0.5% | 1109.8 ± 0.2% | 455.7 ± 0.3% | 1073.9 ± 0.7% | 452.8 ± 1.9% | 19.169 | 27.980 | 68.141 | 28.915 | 68.576 |
| hex: canterbury/fields.c | 22302 | 31341.2 ± 0.4% | 1600.3 ± 0.2% | 1101.1 ± 0.1% | 547.8 ± 1.6% | 1064.9 ± 1.2% | 454.8 ± 0.5% | 19.585 | 28.464 | 57.213 | 29.432 | 68.908 |
| hex: canterbury/grammar.lsp | 7444 | 33386.1 ± 2.5% | 1632.6 ± 1.1% | 1111.1 ± 0.4% | 583.4 ± 1.2% | 1081.9 ± 5.0% | 461.3 ± 1.5% | 20.450 | 30.048 | 57.225 | 30.858 | 72.368 |
| hex: canterbury/kennedy.xls | 524290 | 32079.4 ± 0.8% | 1579.6 ± 0.7% | 1093.8 ± 0.4% | 591.6 ± 0.2% | 1042.3 ± 2.1% | 450.3 ± 0.7% | 20.309 | 29.328 | 54.226 | 30.778 | 71.235 |
| hex: canterbury/lcet10.txt | 524290 | 34971.0 ± 0.7% | 1573.7 ± 1.4% | 1095.3 ± 0.5% | 421.6 ± 0.7% | 1049.5 ± 0.6% | 448.6 ± 0.3% | 22.222 | 31.930 | 82.950 | 33.323 | 77.960 |
| hex: canterbury/plrabn12.txt | 524290 | 33219.5 ± 0.7% | 1580.8 ± 0.9% | 1097.2 ± 0.6% | 420.8 ± 0.9% | 1050.8 ± 0.7% | 449.3 ± 0.4% | 21.014 | 30.275 | 78.951 | 31.615 | 73.940 |
| hex: canterbury/ptt5 | 524290 | 33624.2 ± 10.8% | 1580.6 ± 0.2% | 1097.2 ± 0.5% | 501.8 ± 10.3% | 1051.9 ± 1.0% | 452.7 ± 0.8% | 21.273 | 30.644 | 67.002 | 31.966 | 74.274 |
| hex: canterbury/sum | 76482 | 35318.6 ± 8.3% | 1613.7 ± 3.5% | 1106.1 ± 4.1% | 508.0 ± 0.3% | 1071.5 ± 1.5% | 457.7 ± 1.9% | 21.886 | 31.931 | 69.521 | 32.961 | 77.171 |
| hex: canterbury/xargs.1 | 8456 | 35952.1 ± 0.5% | 1624.4 ± 0.3% | 1105.2 ± 0.7% | 618.6 ± 1.1% | 1081.5 ± 0.9% | 460.2 ± 8.3% | 22.133 | 32.531 | 58.120 | 33.242 | 78.125 |
| hex: canterbury-large/E.coli | 524290 | 30825.6 ± 0.4% | 1573.4 ± 0.6% | 1095.2 ± 0.6% | 606.6 ± 0.3% | 1048.4 ± 0.1% | 450.2 ± 0.4% | 19.591 | 28.147 | 50.814 | 29.402 | 68.469 |
| hex: canterbury-large/bible.txt | 524290 | 35399.1 ± 0.9% | 1578.7 ± 0.5% | 1093.3 ± 1.6% | 434.9 ± 1.0% | 1057.7 ± 0.4% | 449.4 ± 0.7% | 22.422 | 32.379 | 81.393 | 33.469 | 78.774 |
| hex: canterbury-large/world192.txt | 524290 | 35641.8 ± 2.0% | 1579.5 ± 0.6% | 1096.4 ± 0.5% | 423.4 ± 0.3% | 1050.4 ± 1.0% | 449.8 ± 0.9% | 22.565 | 32.508 | 84.188 | 33.931 | 79.241 |
| hex: http/html-1kx1024 | 2099200 | 24782.9 ± 0.3% | 1597.1 ± 1.1% | 1085.7 ± 0.5% | 447.1 ± 0.2% | 1065.2 ± 0.7% | 448.8 ± 8.9% | 15.518 | 22.826 | 55.431 | 23.267 | 55.215 |
| hex: http/html-16kx64 | 2097280 | 30283.0 ± 0.4% | 1609.1 ± 0.3% | 1101.2 ± 0.3% | 442.2 ± 8.2% | 1012.7 ± 1.1% | 452.4 ± 0.8% | 18.820 | 27.499 | 68.484 | 29.903 | 66.932 |
| hex: http/html-1m | 524290 | 29048.4 ± 1.7% | 1571.8 ± 10.1% | 1092.9 ± 0.6% | 441.2 ± 0.5% | 1026.4 ± 0.6% | 449.0 ± 1.1% | 18.481 | 26.579 | 65.836 | 28.300 | 64.701 |
| hex: http/json-1kx1024 | 2099200 | 24642.0 ± 1.0% | 1601.7 ± 0.5% | 1086.3 ± 0.5% | 563.4 ± 0.3% | 1065.3 ± 13.6% | 451.4 ± 1.2% | 15.385 | 22.684 | 43.735 | 23.132 | 54.585 |
| hex: http/json-16kx64 | 2097280 | 30317.0 ± 0.8% | 1605.4 ± 0.1% | 1101.3 ± 0.4% | 549.5 ± 0.8% | 993.3 ± 0.8% | 456.6 ± 0.4% | 18.885 | 27.528 | 55.172 | 30.521 | 66.404 |
| hex: http/json-1m | 524290 | 31442.7 ± 1.2% | 1575.1 ± 1.2% | 1094.2 ± 0.6% | 581.5 ± 0.5% | 1036.5 ± 1.1% | 449.9 ± 0.5% | 19.963 | 28.737 | 54.076 | 30.335 | 69.888 |
| hex: http/js-1kx1024 | 2099200 | 24879.6 ± 1.6% | 1603.3 ± 0.2% | 1087.0 ± 0.2% | 436.7 ± 0.3% | 1062.9 ± 2.2% | 451.8 ± 0.4% | 15.517 | 22.888 | 56.967 | 23.407 | 55.065 |
| hex: http/js-16kx64 | 2097280 | 30381.4 ± 0.3% | 1594.4 ± 6.7% | 1101.9 ± 0.7% | 427.6 ± 0.1% | 994.0 ± 0.7% | 456.8 ± 0.3% | 19.056 | 27.573 | 71.051 | 30.565 | 66.514 |
| hex: http/js-1m | 524290 | 30765.7 ± 0.6% | 1575.0 ± 1.5% | 1096.2 ± 1.0% | 434.4 ± 2.4% | 1054.1 ± 0.7% | 450.6 ± 1.3% | 19.534 | 28.066 | 70.827 | 29.186 | 68.276 |
| hex: http/css-1kx1024 | 2099200 | 24886.8 ± 0.5% | 1600.8 ± 2.9% | 1087.2 ± 0.9% | 496.2 ± 0.4% | 1058.9 ± 0.7% | 452.2 ± 0.7% | 15.547 | 22.890 | 50.159 | 23.502 | 55.040 |
| hex: http/css-16kx64 | 2097280 | 30605.5 ± 0.4% | 1607.7 ± 0.4% | 1102.2 ± 0.3% | 501.2 ± 10.7% | 1059.7 ± 1.0% | 455.7 ± 0.4% | 19.037 | 27.767 | 61.070 | 28.880 | 67.168 |
| hex: http/css-1m | 524290 | 31709.3 ± 0.3% | 1571.2 ± 1.0% | 1092.9 ± 0.6% | 444.8 ± 0.3% | 1009.4 ± 1.4% | 450.3 ± 8.6% | 20.181 | 29.013 | 71.282 | 31.413 | 70.413 |
| hex: shuffled/dickens-1m | 524290 | 35274.0 ± 1.9% | 1575.5 ± 1.3% | 1096.8 ± 0.3% | 424.0 ± 0.3% | 1008.9 ± 0.5% | 451.3 ± 1.6% | 22.388 | 32.160 | 83.186 | 34.964 | 78.152 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.639 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.692 of yyjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.536 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.631 of yyjson.
- string: silesia/dickens, decoding through TextReader.next: stdx runs at 0.320 of simdjson.
- string: silesia/dickens, decoding through TextReader.next: stdx runs at 0.453 of yyjson.
- string: silesia/dickens, decoding through TextReader.next: stdx runs at 0.427 of serde_json.
- string: silesia/nci, decoding through TextReader.next: stdx runs at 0.325 of simdjson.
- string: silesia/nci, decoding through TextReader.next: stdx runs at 0.421 of yyjson.
- string: silesia/nci, decoding through TextReader.next: stdx runs at 0.467 of serde_json.
- string: silesia/reymont, decoding through TextReader.next: stdx runs at 0.410 of simdjson.
- string: silesia/reymont, decoding through TextReader.next: stdx runs at 0.520 of yyjson.
- string: silesia/reymont, decoding through TextReader.next: stdx runs at 0.547 of serde_json.
- string: silesia/samba, decoding through TextReader.next: stdx runs at 0.072 of simdjson.
- string: silesia/samba, decoding through TextReader.next: stdx runs at 0.127 of yyjson.
- string: silesia/samba, decoding through TextReader.next: stdx runs at 0.873 of std.json.
- string: silesia/samba, decoding through TextReader.next: stdx runs at 0.163 of serde_json.
- string: silesia/samba, decoding through TextReader.next: stdx runs at 0.613 of Go jsontext.
- string: silesia/webster, decoding through TextReader.next: stdx runs at 0.326 of simdjson.
- string: silesia/webster, decoding through TextReader.next: stdx runs at 0.424 of yyjson.
- string: silesia/webster, decoding through TextReader.next: stdx runs at 0.400 of serde_json.
- string: silesia/xml, decoding through TextReader.next: stdx runs at 0.286 of simdjson.
- string: silesia/xml, decoding through TextReader.next: stdx runs at 0.497 of yyjson.
- string: silesia/xml, decoding through TextReader.next: stdx runs at 0.453 of serde_json.
- string: canterbury/alice29.txt, decoding through TextReader.next: stdx runs at 0.278 of simdjson.
- string: canterbury/alice29.txt, decoding through TextReader.next: stdx runs at 0.365 of yyjson.
- string: canterbury/alice29.txt, decoding through TextReader.next: stdx runs at 0.355 of serde_json.
- string: canterbury/asyoulik.txt, decoding through TextReader.next: stdx runs at 0.269 of simdjson.
- string: canterbury/asyoulik.txt, decoding through TextReader.next: stdx runs at 0.390 of yyjson.
- string: canterbury/asyoulik.txt, decoding through TextReader.next: stdx runs at 0.367 of serde_json.
- string: canterbury/lcet10.txt, decoding through TextReader.next: stdx runs at 0.316 of simdjson.
- string: canterbury/lcet10.txt, decoding through TextReader.next: stdx runs at 0.450 of yyjson.
- string: canterbury/lcet10.txt, decoding through TextReader.next: stdx runs at 0.420 of serde_json.
- string: canterbury/plrabn12.txt, decoding through TextReader.next: stdx runs at 0.284 of simdjson.
- string: canterbury/plrabn12.txt, decoding through TextReader.next: stdx runs at 0.466 of yyjson.
- string: canterbury/plrabn12.txt, decoding through TextReader.next: stdx runs at 0.388 of serde_json.
- string: canterbury-large/bible.txt, decoding through TextReader.next: stdx runs at 0.643 of simdjson.
- string: canterbury-large/bible.txt, decoding through TextReader.next: stdx runs at 0.850 of serde_json.
- string: canterbury-large/world192.txt, decoding through TextReader.next: stdx runs at 0.304 of simdjson.
- string: canterbury-large/world192.txt, decoding through TextReader.next: stdx runs at 0.368 of yyjson.
- string: canterbury-large/world192.txt, decoding through TextReader.next: stdx runs at 0.360 of serde_json.
- string: http/html-1m, decoding through TextReader.next: stdx runs at 0.634 of simdjson.
- string: http/html-1m, decoding through TextReader.next: stdx runs at 0.908 of yyjson.
- string: http/html-1m, decoding through TextReader.next: stdx runs at 0.789 of serde_json.
- string: http/json-1m, decoding through TextReader.next: stdx runs at 0.232 of simdjson.
- string: http/json-1m, decoding through TextReader.next: stdx runs at 0.203 of yyjson.
- string: http/json-1m, decoding through TextReader.next: stdx runs at 0.947 of std.json.
- string: http/json-1m, decoding through TextReader.next: stdx runs at 0.357 of serde_json.
- string: http/js-1m, decoding through TextReader.next: stdx runs at 0.270 of simdjson.
- string: http/js-1m, decoding through TextReader.next: stdx runs at 0.315 of yyjson.
- string: http/js-1m, decoding through TextReader.next: stdx runs at 0.313 of serde_json.
- string: http/css-1m, decoding through TextReader.next: stdx runs at 0.241 of simdjson.
- string: http/css-1m, decoding through TextReader.next: stdx runs at 0.405 of yyjson.
- string: http/css-1m, decoding through TextReader.next: stdx runs at 0.404 of serde_json.
- string: dickens as Cyrillic and CJK, decoding through TextReader.next: stdx runs at 0.289 of simdjson.
- string: dickens as Cyrillic and CJK, as \u escapes, decoding through TextReader.next: stdx runs at 0.083 of simdjson.
- string: dickens as Cyrillic and CJK, as \u escapes, decoding through TextReader.next: stdx runs at 0.110 of yyjson.
- string: dickens as Cyrillic and CJK, as \u escapes, decoding through TextReader.next: stdx runs at 0.611 of std.json.
- string: dickens as Cyrillic and CJK, as \u escapes, decoding through TextReader.next: stdx runs at 0.234 of serde_json.
- string: dickens as Cyrillic and CJK, as \u escapes, decoding through TextReader.next: stdx runs at 0.459 of Go jsontext.
- CLDR supplemental, 34 texts, encoding through TextWriter's methods: stdx runs at 0.927 of simdjson.
