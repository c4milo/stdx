# bench-json

| Field | Value |
|---|---|
| Commit | 3f9f670 |
| Runner label | ubuntu-24.04 |
| Image version | 20261101.360.1 |
| CPU model | AMD EPYC 7763 64-Core Processor |
| Virtual CPUs | 4 |
| Kernel | 7.0.0-1017-azure |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/42951736432 |
| Date | 2026-11-11 |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1041.6 ± 1.6% | 0.464 | 1.008 | 1.025 | 1.043 | 0.392 | 1.046 | 1.041 | 0.358 | 0.706 | 0.095 |
| qlog records, JSON text sequence | 1467503 | 854.6 ± 3.3% | 0.731 | 0.997 | 0.996 | 0.983 | 0.376 | 0.997 | 0.981 | 0.344 | 0.645 | 0.109 |
| string: silesia/dickens | 172528 | 5422.0 ± 0.7% | 0.025 | 0.657 | 1.037 | 1.048 | 0.179 | 1.013 | 1.049 | 0.180 | 0.177 | 0.025 |
| string: silesia/nci | 1075110 | 5286.0 ± 0.9% | 0.026 | 0.679 | 0.995 | 0.996 | 0.225 | 0.969 | 0.996 | 0.227 | 0.224 | 0.026 |
| string: silesia/reymont | 1075159 | 2782.3 ± 0.4% | 0.050 | 0.688 | 0.974 | 0.971 | 0.339 | 0.968 | 0.972 | 0.341 | 0.334 | 0.050 |
| string: silesia/samba | 97582 | 3361.5 ± 0.8% | 0.036 | 0.888 | 1.014 | 1.016 | 0.066 | 0.831 | 1.017 | 0.065 | 0.065 | 0.036 |
| string: silesia/webster | 1098490 | 3657.1 ± 0.5% | 0.037 | 0.671 | 1.029 | 1.052 | 0.194 | 1.018 | 1.050 | 0.194 | 0.194 | 0.037 |
| string: silesia/xml | 1090118 | 5147.4 ± 0.3% | 0.027 | 0.850 | 0.996 | 0.999 | 0.215 | 0.990 | 0.999 | 0.215 | 0.215 | 0.027 |
| string: canterbury/alice29.txt | 159425 | 4511.8 ± 0.5% | 0.030 | 0.742 | 1.014 | 1.089 | 0.160 | 1.033 | 1.091 | 0.160 | 0.159 | 0.030 |
| string: canterbury/asyoulik.txt | 132198 | 3930.3 ± 1.8% | 0.034 | 0.749 | 1.009 | 1.085 | 0.154 | 0.996 | 1.083 | 0.155 | 0.154 | 0.034 |
| string: canterbury/lcet10.txt | 441884 | 5583.6 ± 1.8% | 0.025 | 0.591 | 1.066 | 1.085 | 0.166 | 1.040 | 1.087 | 0.168 | 0.162 | 0.025 |
| string: canterbury/plrabn12.txt | 503330 | 4370.5 ± 0.3% | 0.031 | 0.777 | 1.051 | 1.097 | 0.185 | 1.026 | 1.096 | 0.187 | 0.180 | 0.031 |
| string: canterbury-large/E.coli | 1048578 | 37643.1 ± 2.7% | 0.040 | 1.019 | 0.592 | 1.010 | 0.478 | 1.023 | 1.020 | 0.470 | 0.480 | 0.004 |
| string: canterbury-large/bible.txt | 1055886 | 6649.2 ± 0.3% | 0.022 | 0.693 | 0.902 | 0.898 | 0.399 | 0.985 | 0.899 | 0.398 | 0.394 | 0.022 |
| string: canterbury-large/world192.txt | 1103121 | 3461.0 ± 0.7% | 0.039 | 0.701 | 1.027 | 1.060 | 0.185 | 1.008 | 1.054 | 0.186 | 0.185 | 0.039 |
| string: http/html-1m | 1058582 | 6226.5 ± 4.6% | 0.023 | 0.688 | 0.949 | 0.953 | 0.363 | 0.984 | 0.953 | 0.364 | 0.361 | 0.023 |
| string: http/json-1m | 1190272 | 3343.5 ± 0.9% | 0.038 | 0.380 | 0.433 | 0.434 | 0.093 | 0.389 | 0.433 | 0.093 | 0.093 | 0.038 |
| string: http/js-1m | 1144362 | 2265.6 ± 0.4% | 0.056 | 0.773 | 1.021 | 1.075 | 0.173 | 1.010 | 1.075 | 0.173 | 0.173 | 0.056 |
| string: http/css-1m | 1097820 | 3020.8 ± 0.3% | 0.044 | 0.737 | 0.982 | 1.092 | 0.216 | 0.991 | 1.020 | 0.218 | 0.215 | 0.044 |
| string: dickens as Cyrillic and CJK | 1883069 | 5193.8 ± 2.4% | 0.021 | 0.058 | 0.497 | 0.496 | 0.182 | 0.493 | 0.497 | 0.182 | 0.181 | 0.021 |
| string: dickens as Cyrillic and CJK, as \u escapes | 5075485 | 1061.6 ± 1.1% | 0.093 | 0.975 | 0.974 | 0.975 | 0.089 | 0.707 | 0.975 | 0.089 | 0.089 | 0.093 |
| hex: silesia/dickens | 524290 | 37490.1 ± 1.5% | 0.040 | 1.019 | 0.590 | 1.013 | 0.477 | 1.030 | 1.024 | 0.472 | 0.483 | 0.004 |
| hex: silesia/mozilla | 524290 | 38204.8 ± 1.8% | 0.040 | 1.014 | 0.580 | 1.015 | 0.464 | 1.020 | 1.016 | 0.459 | 0.471 | 0.004 |
| hex: silesia/mr | 524290 | 37930.0 ± 1.4% | 0.040 | 1.007 | 0.585 | 1.011 | 0.465 | 1.020 | 1.017 | 0.461 | 0.471 | 0.004 |
| hex: silesia/nci | 524290 | 38022.2 ± 1.0% | 0.040 | 1.015 | 0.585 | 1.016 | 0.469 | 1.020 | 1.024 | 0.464 | 0.474 | 0.004 |
| hex: silesia/ooffice | 524290 | 37730.5 ± 4.0% | 0.040 | 1.012 | 0.587 | 1.014 | 0.469 | 1.018 | 1.017 | 0.462 | 0.473 | 0.004 |
| hex: silesia/osdb | 524290 | 37853.6 ± 1.6% | 0.040 | 1.016 | 0.588 | 1.020 | 0.469 | 1.030 | 1.027 | 0.465 | 0.474 | 0.004 |
| hex: silesia/reymont | 524290 | 38313.5 ± 1.8% | 0.040 | 1.011 | 0.580 | 1.010 | 0.466 | 1.019 | 1.022 | 0.457 | 0.471 | 0.004 |
| hex: silesia/samba | 524290 | 36480.9 ± 1.4% | 0.042 | 1.015 | 0.611 | 1.017 | 0.489 | 1.024 | 1.022 | 0.484 | 0.491 | 0.004 |
| hex: silesia/sao | 524290 | 37974.2 ± 2.5% | 0.040 | 1.005 | 0.580 | 1.005 | 0.471 | 1.013 | 1.011 | 0.463 | 0.475 | 0.004 |
| hex: silesia/webster | 524290 | 37486.1 ± 0.9% | 0.040 | 1.024 | 0.589 | 1.017 | 0.478 | 1.026 | 1.026 | 0.473 | 0.483 | 0.004 |
| hex: silesia/x-ray | 524290 | 35729.7 ± 0.7% | 0.042 | 1.015 | 0.620 | 1.015 | 0.489 | 1.022 | 1.020 | 0.486 | 0.493 | 0.004 |
| hex: silesia/xml | 524290 | 38123.2 ± 1.8% | 0.040 | 1.004 | 0.580 | 1.004 | 0.469 | 1.017 | 1.016 | 0.463 | 0.474 | 0.004 |
| hex: canterbury/alice29.txt | 304180 | 37341.7 ± 1.0% | 0.041 | 1.011 | 0.589 | 1.009 | 0.471 | 1.018 | 1.016 | 0.473 | 0.476 | 0.004 |
| hex: canterbury/asyoulik.txt | 250360 | 39086.1 ± 0.4% | 0.039 | 1.019 | 0.562 | 1.007 | 0.464 | 1.021 | 1.014 | 0.464 | 0.465 | 0.004 |
| hex: canterbury/cp.html | 49208 | 38743.7 ± 0.9% | 0.040 | 1.010 | 0.562 | 1.010 | 0.469 | 1.007 | 1.006 | 0.474 | 0.475 | 0.004 |
| hex: canterbury/fields.c | 22302 | 37024.2 ± 0.8% | 0.042 | 1.030 | 0.574 | 1.029 | 0.475 | 1.033 | 1.031 | 0.484 | 0.488 | 0.004 |
| hex: canterbury/grammar.lsp | 7444 | 34200.2 ± 5.4% | 0.045 | 1.058 | 0.570 | 1.090 | 0.455 | 1.094 | 1.089 | 0.482 | 0.496 | 0.004 |
| hex: canterbury/kennedy.xls | 524290 | 37366.6 ± 2.5% | 0.040 | 1.013 | 0.590 | 1.011 | 0.475 | 1.016 | 1.022 | 0.470 | 0.480 | 0.004 |
| hex: canterbury/lcet10.txt | 524290 | 37717.9 ± 1.3% | 0.040 | 1.015 | 0.590 | 1.014 | 0.472 | 1.026 | 1.024 | 0.466 | 0.478 | 0.004 |
| hex: canterbury/plrabn12.txt | 524290 | 36784.1 ± 1.3% | 0.041 | 1.011 | 0.590 | 1.010 | 0.482 | 1.017 | 1.014 | 0.479 | 0.486 | 0.004 |
| hex: canterbury/ptt5 | 524290 | 38449.0 ± 1.7% | 0.039 | 1.006 | 0.578 | 1.006 | 0.463 | 1.018 | 1.017 | 0.462 | 0.467 | 0.004 |
| hex: canterbury/sum | 76482 | 40768.3 ± 3.0% | 0.038 | 1.010 | 0.548 | 1.011 | 0.451 | 1.010 | 1.010 | 0.454 | 0.456 | 0.004 |
| hex: canterbury/xargs.1 | 8456 | 36384.3 ± 2.7% | 0.042 | 1.009 | 0.545 | 1.064 | 0.441 | 1.063 | 1.060 | 0.465 | 0.477 | 0.004 |
| hex: canterbury-large/E.coli | 524290 | 37344.4 ± 0.9% | 0.041 | 1.022 | 0.587 | 1.012 | 0.481 | 1.023 | 1.020 | 0.476 | 0.486 | 0.004 |
| hex: canterbury-large/bible.txt | 524290 | 33537.9 ± 1.6% | 0.045 | 1.008 | 0.665 | 1.012 | 0.511 | 1.016 | 1.008 | 0.506 | 0.514 | 0.004 |
| hex: canterbury-large/world192.txt | 524290 | 38272.0 ± 2.4% | 0.040 | 1.013 | 0.582 | 1.019 | 0.467 | 1.018 | 1.018 | 0.462 | 0.471 | 0.004 |
| hex: http/html-1kx1024 | 2099200 | 16513.2 ± 1.0% | 0.090 | 1.045 | 0.819 | 1.055 | 0.617 | 1.068 | 1.057 | 0.714 | 0.744 | 0.009 |
| hex: http/html-16kx64 | 2097280 | 35630.1 ± 1.2% | 0.043 | 1.007 | 0.587 | 1.013 | 0.489 | 1.009 | 1.015 | 0.493 | 0.498 | 0.004 |
| hex: http/html-1m | 524290 | 37920.8 ± 2.1% | 0.040 | 1.028 | 0.586 | 1.031 | 0.472 | 1.037 | 1.035 | 0.467 | 0.476 | 0.004 |
| hex: http/json-1kx1024 | 2099200 | 16348.7 ± 3.6% | 0.091 | 1.044 | 0.820 | 1.076 | 0.623 | 1.078 | 1.073 | 0.709 | 0.748 | 0.009 |
| hex: http/json-16kx64 | 2097280 | 35145.5 ± 1.5% | 0.044 | 1.012 | 0.596 | 1.017 | 0.492 | 1.022 | 1.020 | 0.502 | 0.502 | 0.004 |
| hex: http/json-1m | 524290 | 37304.4 ± 1.6% | 0.041 | 1.019 | 0.598 | 1.029 | 0.481 | 1.033 | 1.034 | 0.478 | 0.483 | 0.004 |
| hex: http/js-1kx1024 | 2099200 | 16497.6 ± 3.1% | 0.090 | 1.035 | 0.806 | 1.055 | 0.615 | 1.060 | 1.058 | 0.713 | 0.739 | 0.009 |
| hex: http/js-16kx64 | 2097280 | 34765.2 ± 9.2% | 0.044 | 1.027 | 0.604 | 1.030 | 0.499 | 1.035 | 1.033 | 0.507 | 0.506 | 0.004 |
| hex: http/js-1m | 524290 | 37399.5 ± 4.2% | 0.040 | 1.018 | 0.585 | 1.027 | 0.472 | 1.034 | 1.033 | 0.469 | 0.477 | 0.004 |
| hex: http/css-1kx1024 | 2099200 | 16670.6 ± 3.2% | 0.089 | 1.037 | 0.814 | 1.060 | 0.595 | 1.054 | 1.040 | 0.682 | 0.712 | 0.009 |
| hex: http/css-16kx64 | 2097280 | 34630.5 ± 1.7% | 0.044 | 1.002 | 0.600 | 1.009 | 0.498 | 1.013 | 1.003 | 0.503 | 0.504 | 0.004 |
| hex: http/css-1m | 524290 | 36045.0 ± 3.2% | 0.042 | 1.010 | 0.617 | 1.016 | 0.490 | 1.020 | 1.017 | 0.488 | 0.494 | 0.004 |
| hex: shuffled/dickens-1m | 524290 | 37320.8 ± 1.4% | 0.041 | 1.015 | 0.594 | 1.020 | 0.476 | 1.014 | 1.022 | 0.474 | 0.477 | 0.004 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1342.7 ± 1.6% | 0.439 | 0.974 | 0.958 | 1.013 | 1.012 | 0.227 | 1.012 | 0.440 | 0.723 | 0.086 | 1.022 |
| qlog records, JSON text sequence | 1467503 | 1147.6 ± 1.3% | 0.694 | 0.940 | 0.982 | 0.993 | 0.991 | 0.223 | 0.991 | 0.412 | 0.700 | 0.105 | 1.015 |
| string: silesia/dickens | 172528 | 8922.6 ± 0.3% | 0.017 | 0.599 | 0.427 | 0.610 | 0.599 | 0.121 | 0.600 | 1.000 | 1.002 | 0.017 | 1.049 |
| string: silesia/nci | 1075110 | 8644.9 ± 0.5% | 0.018 | 0.597 | 0.409 | 0.594 | 0.598 | 0.166 | 0.598 | 1.003 | 1.004 | 0.018 | 1.027 |
| string: silesia/reymont | 1075159 | 3817.7 ± 0.3% | 0.041 | 0.679 | 0.518 | 0.672 | 0.679 | 0.280 | 0.680 | 1.001 | 1.003 | 0.041 | 1.004 |
| string: silesia/samba | 97582 | 4648.0 ± 0.4% | 0.042 | 0.927 | 0.782 | 0.932 | 0.933 | 0.111 | 0.930 | 0.999 | 1.001 | 0.042 | 1.118 |
| string: silesia/webster | 1098490 | 5102.5 ± 1.4% | 0.030 | 0.698 | 0.496 | 0.702 | 0.699 | 0.154 | 0.699 | 0.999 | 1.001 | 0.030 | 1.003 |
| string: silesia/xml | 1090118 | 7996.1 ± 0.6% | 0.020 | 0.627 | 0.559 | 0.634 | 0.626 | 0.195 | 0.628 | 1.000 | 1.011 | 0.020 | 1.062 |
| string: canterbury/alice29.txt | 159425 | 9643.9 ± 11.1% | 0.016 | 0.523 | 0.395 | 0.518 | 0.528 | 0.084 | 0.530 | 1.001 | 1.000 | 0.016 | 1.034 |
| string: canterbury/asyoulik.txt | 132198 | 8082.0 ± 1.2% | 0.019 | 0.491 | 0.389 | 0.498 | 0.501 | 0.085 | 0.506 | 1.001 | 1.005 | 0.019 | 1.039 |
| string: canterbury/lcet10.txt | 441884 | 8888.8 ± 1.3% | 0.017 | 0.604 | 0.392 | 0.614 | 0.603 | 0.117 | 0.603 | 1.002 | 1.008 | 0.017 | 1.034 |
| string: canterbury/plrabn12.txt | 503330 | 6028.7 ± 0.4% | 0.025 | 0.770 | 0.593 | 0.759 | 0.766 | 0.157 | 0.769 | 1.002 | 1.005 | 0.025 | 1.057 |
| string: canterbury-large/E.coli | 1048578 | 38160.0 ± 1.1% | 0.040 | 0.993 | 1.021 | 0.584 | 1.018 | 0.469 | 1.018 | 1.005 | 1.021 | 0.004 | 1.018 |
| string: canterbury-large/bible.txt | 1055886 | 7013.8 ± 3.5% | 0.023 | 0.795 | 0.664 | 0.827 | 0.798 | 0.409 | 0.798 | 1.001 | 1.004 | 0.023 | 1.053 |
| string: canterbury-large/world192.txt | 1103121 | 5133.5 ± 3.6% | 0.030 | 0.666 | 0.501 | 0.641 | 0.665 | 0.137 | 0.643 | 1.001 | 0.949 | 0.030 | 0.932 |
| string: http/html-1m | 1058582 | 8438.7 ± 0.6% | 0.019 | 0.625 | 0.519 | 0.657 | 0.622 | 0.289 | 0.625 | 0.999 | 1.012 | 0.019 | 1.018 |
| string: http/json-1m | 1190272 | 6682.3 ± 0.4% | 0.022 | 0.214 | 0.187 | 0.217 | 0.214 | 0.061 | 0.214 | 1.000 | 1.000 | 0.022 | 1.018 |
| string: http/js-1m | 1144362 | 5050.5 ± 1.3% | 0.029 | 0.445 | 0.357 | 0.436 | 0.445 | 0.085 | 0.445 | 0.996 | 1.009 | 0.029 | 0.998 |
| string: http/css-1m | 1097820 | 6847.0 ± 1.1% | 0.022 | 0.504 | 0.346 | 0.498 | 0.504 | 0.113 | 0.509 | 1.005 | 1.006 | 0.022 | 1.053 |
| string: dickens as Cyrillic and CJK | 1883069 | 5323.8 ± 18.9% | 0.024 | 0.467 | 0.058 | 0.471 | 0.468 | 0.178 | 0.466 | 1.006 | 1.004 | 0.024 | 0.985 |
| hex: silesia/dickens | 524290 | 31625.8 ± 0.9% | 1.004 | 0.080 | 1.004 | 0.611 | 1.006 | 1.000 | 1.004 | 1.003 | 1.004 | 0.081 | 1.007 |
| hex: silesia/mozilla | 524290 | 35916.4 ± 1.0% | 1.009 | 0.071 | 1.008 | 0.561 | 1.014 | 1.011 | 1.012 | 1.012 | 1.015 | 0.071 | 1.012 |
| hex: silesia/mr | 524290 | 34496.1 ± 0.8% | 1.008 | 0.073 | 1.007 | 0.580 | 1.007 | 1.006 | 1.009 | 1.004 | 1.010 | 0.074 | 1.011 |
| hex: silesia/nci | 524290 | 33770.0 ± 0.6% | 1.009 | 0.075 | 1.015 | 0.596 | 1.017 | 1.016 | 1.015 | 1.014 | 1.018 | 0.075 | 1.014 |
| hex: silesia/ooffice | 524290 | 34386.4 ± 0.9% | 1.012 | 0.074 | 1.009 | 0.585 | 1.011 | 1.010 | 1.011 | 1.008 | 1.014 | 0.074 | 1.013 |
| hex: silesia/osdb | 524290 | 34771.7 ± 0.7% | 1.009 | 0.073 | 1.008 | 0.578 | 1.008 | 1.007 | 1.005 | 1.008 | 1.011 | 0.073 | 1.009 |
| hex: silesia/reymont | 524290 | 33360.3 ± 13.0% | 1.008 | 0.076 | 1.007 | 0.600 | 1.006 | 1.007 | 1.008 | 1.010 | 1.012 | 0.076 | 1.009 |
| hex: silesia/samba | 524290 | 33194.9 ± 3.5% | 1.005 | 0.076 | 1.005 | 0.606 | 1.009 | 1.008 | 1.007 | 1.012 | 1.015 | 0.077 | 1.006 |
| hex: silesia/sao | 524290 | 33928.1 ± 0.6% | 1.006 | 0.075 | 1.007 | 0.592 | 1.005 | 1.006 | 1.006 | 1.003 | 1.007 | 0.075 | 1.009 |
| hex: silesia/webster | 524290 | 36865.6 ± 0.7% | 1.011 | 0.069 | 1.009 | 0.549 | 1.010 | 1.006 | 1.011 | 1.005 | 1.010 | 0.069 | 1.011 |
| hex: silesia/x-ray | 524290 | 34073.8 ± 0.5% | 1.009 | 0.074 | 1.005 | 0.588 | 1.007 | 1.006 | 1.008 | 1.010 | 1.014 | 0.075 | 1.006 |
| hex: silesia/xml | 524290 | 34099.7 ± 1.7% | 1.014 | 0.074 | 1.008 | 0.589 | 1.011 | 1.008 | 1.012 | 1.007 | 1.011 | 0.075 | 1.011 |
| hex: canterbury/alice29.txt | 304180 | 35052.0 ± 1.9% | 1.009 | 0.072 | 0.999 | 0.573 | 1.000 | 1.000 | 1.005 | 1.001 | 1.019 | 0.073 | 1.003 |
| hex: canterbury/asyoulik.txt | 250360 | 30816.7 ± 1.4% | 1.012 | 0.082 | 1.010 | 0.605 | 1.011 | 1.013 | 1.012 | 1.024 | 1.018 | 0.083 | 1.011 |
| hex: canterbury/cp.html | 49208 | 31702.4 ± 0.1% | 1.000 | 0.080 | 0.999 | 0.619 | 1.000 | 0.996 | 0.999 | 1.001 | 1.003 | 0.080 | 1.001 |
| hex: canterbury/fields.c | 22302 | 32803.8 ± 0.1% | 0.997 | 0.077 | 0.995 | 0.585 | 0.994 | 0.982 | 0.997 | 1.000 | 1.019 | 0.077 | 1.004 |
| hex: canterbury/grammar.lsp | 7444 | 31072.8 ± 0.4% | 0.988 | 0.081 | 0.992 | 0.589 | 0.991 | 0.958 | 0.993 | 0.997 | 1.032 | 0.080 | 1.001 |
| hex: canterbury/kennedy.xls | 524290 | 30841.1 ± 0.3% | 1.003 | 0.082 | 1.002 | 0.634 | 1.005 | 1.001 | 1.003 | 1.006 | 1.008 | 0.083 | 1.007 |
| hex: canterbury/lcet10.txt | 524290 | 33552.4 ± 0.7% | 1.004 | 0.076 | 1.007 | 0.598 | 1.007 | 1.005 | 1.007 | 1.008 | 1.006 | 0.076 | 1.007 |
| hex: canterbury/plrabn12.txt | 524290 | 33169.2 ± 2.3% | 1.003 | 0.076 | 1.002 | 0.603 | 1.001 | 1.000 | 1.002 | 1.001 | 1.005 | 0.077 | 1.001 |
| hex: canterbury/ptt5 | 524290 | 33265.0 ± 0.6% | 1.007 | 0.076 | 1.007 | 0.606 | 1.007 | 1.007 | 1.009 | 1.005 | 1.007 | 0.077 | 1.006 |
| hex: canterbury/sum | 76482 | 35187.0 ± 0.2% | 0.994 | 0.072 | 0.993 | 0.573 | 0.994 | 0.988 | 0.994 | 0.997 | 1.002 | 0.073 | 0.994 |
| hex: canterbury/xargs.1 | 8456 | 34866.4 ± 0.6% | 0.991 | 0.072 | 0.992 | 0.540 | 0.995 | 0.953 | 0.995 | 0.998 | 1.026 | 0.072 | 1.004 |
| hex: canterbury-large/E.coli | 524290 | 30717.5 ± 0.5% | 1.005 | 0.082 | 0.999 | 0.622 | 1.004 | 1.002 | 1.002 | 1.000 | 1.005 | 0.083 | 1.003 |
| hex: canterbury-large/bible.txt | 524290 | 35461.5 ± 0.8% | 1.006 | 0.071 | 0.997 | 0.568 | 0.996 | 1.002 | 0.997 | 1.005 | 1.005 | 0.072 | 0.999 |
| hex: canterbury-large/world192.txt | 524290 | 35093.2 ± 0.5% | 1.011 | 0.072 | 1.008 | 0.571 | 1.009 | 1.007 | 1.014 | 1.003 | 1.012 | 0.072 | 1.009 |
| hex: http/html-1kx1024 | 2099200 | 23982.4 ± 2.7% | 0.973 | 0.102 | 0.969 | 0.661 | 0.966 | 0.869 | 0.968 | 0.984 | 1.055 | 0.098 | 1.002 |
| hex: http/html-16kx64 | 2097280 | 29623.1 ± 2.2% | 1.013 | 0.085 | 1.012 | 0.650 | 1.009 | 0.998 | 1.013 | 1.017 | 1.030 | 0.085 | 1.013 |
| hex: http/html-1m | 524290 | 29153.4 ± 2.3% | 1.005 | 0.087 | 1.006 | 0.670 | 1.004 | 1.005 | 1.004 | 1.005 | 1.006 | 0.087 | 1.006 |
| hex: http/json-1kx1024 | 2099200 | 23914.7 ± 1.6% | 0.992 | 0.102 | 0.988 | 0.659 | 0.989 | 0.887 | 0.989 | 0.988 | 1.055 | 0.100 | 1.025 |
| hex: http/json-16kx64 | 2097280 | 29927.1 ± 0.5% | 1.009 | 0.084 | 1.008 | 0.644 | 1.002 | 0.994 | 1.000 | 1.013 | 1.027 | 0.084 | 1.008 |
| hex: http/json-1m | 524290 | 31503.5 ± 1.6% | 1.009 | 0.080 | 1.006 | 0.632 | 1.003 | 1.005 | 1.007 | 1.004 | 1.008 | 0.081 | 1.006 |
| hex: http/js-1kx1024 | 2099200 | 23565.7 ± 2.7% | 0.987 | 0.104 | 0.986 | 0.661 | 0.973 | 0.871 | 0.976 | 1.001 | 1.069 | 0.101 | 1.012 |
| hex: http/js-16kx64 | 2097280 | 30006.7 ± 1.4% | 1.008 | 0.083 | 0.999 | 0.642 | 0.999 | 0.988 | 0.997 | 1.005 | 1.015 | 0.084 | 1.002 |
| hex: http/js-1m | 524290 | 30682.3 ± 0.6% | 1.003 | 0.082 | 1.007 | 0.643 | 1.008 | 1.007 | 1.007 | 1.004 | 1.009 | 0.083 | 1.005 |
| hex: http/css-1kx1024 | 2099200 | 23799.1 ± 2.4% | 0.967 | 0.103 | 0.967 | 0.661 | 0.963 | 0.860 | 0.961 | 0.983 | 1.052 | 0.100 | 1.003 |
| hex: http/css-16kx64 | 2097280 | 30132.2 ± 0.6% | 1.011 | 0.084 | 1.009 | 0.643 | 1.012 | 1.000 | 1.011 | 1.007 | 1.019 | 0.084 | 1.017 |
| hex: http/css-1m | 524290 | 31220.6 ± 0.5% | 1.005 | 0.081 | 1.001 | 0.644 | 1.003 | 1.000 | 1.001 | 1.010 | 1.005 | 0.081 | 1.004 |
| hex: shuffled/dickens-1m | 524290 | 34957.4 ± 1.6% | 1.007 | 0.073 | 1.009 | 0.579 | 1.006 | 1.006 | 1.007 | 1.005 | 1.010 | 0.073 | 1.012 |

## Losses

Each workload where a claim's path ran slower than the path it replaces by more than the noise floor of decision 20.

- string: silesia/webster, decoding: J8 decoder fast path off runs at 1.052 of all on.
- string: silesia/webster, decoding: J13 decoder escape blocks off runs at 1.050 of all on.
- string: canterbury/alice29.txt, decoding: J8 decoder fast path off runs at 1.089 of all on.
- string: canterbury/alice29.txt, decoding: J13 decoder escape blocks off runs at 1.091 of all on.
- string: canterbury/asyoulik.txt, decoding: J8 decoder fast path off runs at 1.085 of all on.
- string: canterbury/asyoulik.txt, decoding: J13 decoder escape blocks off runs at 1.083 of all on.
- string: canterbury/lcet10.txt, decoding: J7 wide vectors off runs at 1.066 of all on.
- string: canterbury/lcet10.txt, decoding: J8 decoder fast path off runs at 1.085 of all on.
- string: canterbury/lcet10.txt, decoding: J13 decoder escape blocks off runs at 1.087 of all on.
- string: canterbury/plrabn12.txt, decoding: J7 wide vectors off runs at 1.051 of all on.
- string: canterbury/plrabn12.txt, decoding: J13 decoder escape blocks off runs at 1.096 of all on.
- string: canterbury-large/world192.txt, decoding: J8 decoder fast path off runs at 1.060 of all on.
- string: canterbury-large/world192.txt, decoding: J13 decoder escape blocks off runs at 1.054 of all on.
- string: http/js-1m, decoding: J8 decoder fast path off runs at 1.075 of all on.
- string: http/js-1m, decoding: J13 decoder escape blocks off runs at 1.075 of all on.
- string: http/css-1m, decoding: J8 decoder fast path off runs at 1.092 of all on.
- hex: canterbury/grammar.lsp, decoding: J5 UTF-8 vectors off runs at 1.058 of all on.
- hex: canterbury/grammar.lsp, decoding: J12 decoder escape words off runs at 1.094 of all on.
- hex: canterbury/grammar.lsp, decoding: J13 decoder escape blocks off runs at 1.089 of all on.
- hex: canterbury/xargs.1, decoding: J8 decoder fast path off runs at 1.064 of all on.
- hex: canterbury/xargs.1, decoding: J12 decoder escape words off runs at 1.063 of all on.
- hex: canterbury/xargs.1, decoding: J13 decoder escape blocks off runs at 1.060 of all on.
- hex: http/html-1kx1024, decoding: J8 decoder fast path off runs at 1.055 of all on.
- hex: http/html-1kx1024, decoding: J12 decoder escape words off runs at 1.068 of all on.
- hex: http/html-1kx1024, decoding: J13 decoder escape blocks off runs at 1.057 of all on.
- hex: http/json-1kx1024, decoding: J8 decoder fast path off runs at 1.076 of all on.
- hex: http/json-1kx1024, decoding: J12 decoder escape words off runs at 1.078 of all on.
- hex: http/json-1kx1024, decoding: J13 decoder escape blocks off runs at 1.073 of all on.
- hex: http/js-1kx1024, decoding: J8 decoder fast path off runs at 1.055 of all on.
- hex: http/js-1kx1024, decoding: J13 decoder escape blocks off runs at 1.058 of all on.
- hex: http/css-1kx1024, decoding: J8 decoder fast path off runs at 1.060 of all on.
- hex: http/css-1kx1024, decoding: J12 decoder escape words off runs at 1.054 of all on.

## UTF-8 validation against simdutf

stdx's `is_utf8`, the check the loops apply to every string's octets, run alone over each string workload's octets at the width the host's features pick (16 lanes on aarch64, AVX2's 32 or AVX-512's 64 on x86-64, decision 39), beside simdutf 9.3.3's `validate_utf8` in the same run; on a host with AVX-512, again with AVX2 alone. Each ratio is stdx's throughput over the other's. simdutf picks its kernel at run time. Before timing, every copy of the check and simdutf judged 20000 seeded buffers and each workload, whole and changed, alike.

| Workload | Octets | stdx, MB/s | simdutf, MB/s | stdx / simdutf | stdx with AVX2 alone, MB/s | stdx / stdx with AVX2 alone |
|---|---|---|---|---|---|---|
| string: silesia/dickens | 166668 | 100788.0 ± 0.4% | 91808.3 ± 0.2% | 1.098 | — | — |
| string: silesia/nci | 1048576 | 72226.6 ± 5.7% | 72049.6 ± 0.5% | 1.002 | — | — |
| string: silesia/reymont | 1048576 | 73069.7 ± 0.7% | 72126.5 ± 0.8% | 1.013 | — | — |
| string: silesia/samba | 65546 | 98390.9 ± 1.6% | 90969.3 ± 0.3% | 1.082 | — | — |
| string: silesia/webster | 1048576 | 73884.0 ± 4.8% | 76697.6 ± 0.8% | 0.963 | — | — |
| string: silesia/xml | 1048576 | 72553.1 ± 0.5% | 71619.0 ± 0.6% | 1.013 | — | — |
| string: canterbury/alice29.txt | 152089 | 100324.7 ± 1.0% | 91757.0 ± 0.3% | 1.093 | — | — |
| string: canterbury/asyoulik.txt | 125179 | 99988.4 ± 12.2% | 92045.2 ± 3.6% | 1.086 | — | — |
| string: canterbury/lcet10.txt | 426754 | 88133.2 ± 1.8% | 83130.9 ± 1.8% | 1.060 | — | — |
| string: canterbury/plrabn12.txt | 481861 | 86385.9 ± 1.3% | 81612.4 ± 0.9% | 1.058 | — | — |
| string: canterbury-large/E.coli | 1048576 | 72282.3 ± 0.6% | 71713.9 ± 2.0% | 1.008 | — | — |
| string: canterbury-large/bible.txt | 1048576 | 72849.5 ± 1.2% | 72144.6 ± 0.4% | 1.010 | — | — |
| string: canterbury-large/world192.txt | 1048576 | 72492.8 ± 0.7% | 71747.7 ± 0.5% | 1.010 | — | — |
| string: http/html-1m | 1048576 | 67957.4 ± 0.7% | 66920.0 ± 1.3% | 1.016 | — | — |
| string: http/json-1m | 1048576 | 61473.2 ± 1.3% | 64935.0 ± 1.5% | 0.947 | — | — |
| string: http/js-1m | 1048576 | 72211.6 ± 10.3% | 71784.3 ± 1.2% | 1.006 | — | — |
| string: http/css-1m | 1048576 | 72050.2 ± 0.9% | 71687.1 ± 1.1% | 1.005 | — | — |
| string: dickens as Cyrillic and CJK | 1847045 | 14608.8 ± 0.2% | 15294.9 ± 0.4% | 0.955 | — | — |

## Losses to simdutf

- string: http/json-1m: stdx runs at 0.947 of simdutf.

## UTF-8 validation by the buffer's offset from a 64-octet line

| Buffer | Octets | Offset | stdx, MB/s | simdutf, MB/s | stdx / simdutf | stdx with AVX2 alone, MB/s | stdx / stdx with AVX2 alone |
|---|---|---|---|---|---|---|---|
| string: canterbury-large/bible.txt | 1048576 | 0 | 72845.1 ± 13.2% | 76239.3 ± 0.7% | 0.955 | — | — |
| string: canterbury-large/bible.txt | 1048576 | 1 | 73119.9 ± 0.6% | 71842.8 ± 1.0% | 1.018 | — | — |
| string: canterbury-large/bible.txt | 1048576 | 8 | 73342.6 ± 0.9% | 71922.7 ± 0.6% | 1.020 | — | — |
| string: canterbury-large/bible.txt | 1048576 | 16 | 73382.4 ± 0.5% | 71767.9 ± 1.9% | 1.022 | — | — |
| string: canterbury-large/bible.txt | 1048576 | 32 | 73206.2 ± 1.4% | 76097.2 ± 0.7% | 0.962 | — | — |
| string: canterbury-large/bible.txt | 1048576 | 48 | 73516.3 ± 2.7% | 72316.6 ± 0.6% | 1.017 | — | — |
| string: dickens as Cyrillic and CJK | 1048576 | 0 | 14587.3 ± 0.4% | 15317.7 ± 0.3% | 0.952 | — | — |
| string: dickens as Cyrillic and CJK | 1048576 | 1 | 14582.0 ± 0.1% | 15296.7 ± 1.4% | 0.953 | — | — |
| string: dickens as Cyrillic and CJK | 1048576 | 8 | 14572.2 ± 0.4% | 15317.0 ± 1.4% | 0.951 | — | — |
| string: dickens as Cyrillic and CJK | 1048576 | 16 | 14587.9 ± 5.6% | 15321.0 ± 0.1% | 0.952 | — | — |
| string: dickens as Cyrillic and CJK | 1048576 | 32 | 14590.3 ± 0.4% | 15311.2 ± 0.6% | 0.953 | — | — |
| string: dickens as Cyrillic and CJK | 1048576 | 48 | 14576.3 ± 0.3% | 15296.0 ± 0.8% | 0.953 | — | — |

## Against the baselines

stdx with every claim on, timed beside simdjson 5.1.1, yyjson 0.13.0, Zig 0.16.0's std.json, serde_json 1.0.154 and Go's encoding/json/jsontext in the same run. Each ratio is stdx's throughput over the baseline's; below 1, the baseline is faster. stdx is built for the architecture's baseline CPU in ReleaseSafe; the baselines for this host in ReleaseFast, and simdjson picks its kernel at run time. Decoding visits every value; encoding writes each text from its tokens.

## Decoding against the baselines

Octets are the text's. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1041.6 ± 1.6% | 1021.1 ± 0.3% | 949.1 ± 0.6% | 260.6 ± 1.2% | 530.1 ± 0.3% | 258.9 ± 4.2% | 1.020 | 1.097 | 3.997 | 1.965 | 4.023 |
| qlog records, JSON text sequence | 1467503 | 854.6 ± 3.3% | 805.4 ± 1.8% | 802.2 ± 0.4% | 220.0 ± 2.2% | 588.5 ± 0.8% | 245.8 ± 2.1% | 1.061 | 1.065 | 3.885 | 1.452 | 3.477 |
| string: silesia/dickens | 172528 | 5422.0 ± 0.7% | 2935.5 ± 1.7% | 2067.5 ± 0.7% | 286.4 ± 0.4% | 2177.5 ± 8.1% | 497.8 ± 2.1% | 1.847 | 2.622 | 18.929 | 2.490 | 10.891 |
| string: silesia/nci | 1075110 | 5286.0 ± 0.9% | 3542.7 ± 0.2% | 2825.9 ± 4.1% | 427.9 ± 2.4% | 2406.1 ± 2.4% | 526.0 ± 1.4% | 1.492 | 1.871 | 12.354 | 2.197 | 10.049 |
| string: silesia/reymont | 1075159 | 2782.3 ± 0.4% | 2200.7 ± 0.7% | 1836.8 ± 4.2% | 295.1 ± 1.6% | 1643.0 ± 0.7% | 477.8 ± 4.3% | 1.264 | 1.515 | 9.428 | 1.693 | 5.823 |
| string: silesia/samba | 97582 | 3361.5 ± 0.8% | 2904.6 ± 7.5% | 1698.1 ± 4.1% | 241.6 ± 0.7% | 1280.4 ± 1.2% | 356.8 ± 3.1% | 1.157 | 1.980 | 13.912 | 2.625 | 9.422 |
| string: silesia/webster | 1098490 | 3657.1 ± 0.5% | 2049.5 ± 0.5% | 1681.1 ± 7.4% | 286.2 ± 0.7% | 1678.8 ± 2.0% | 443.3 ± 1.1% | 1.784 | 2.175 | 12.779 | 2.178 | 8.251 |
| string: silesia/xml | 1090118 | 5147.4 ± 0.3% | 3755.6 ± 1.5% | 2167.9 ± 0.7% | 374.9 ± 0.2% | 2366.0 ± 1.3% | 481.5 ± 8.8% | 1.371 | 2.374 | 13.728 | 2.176 | 10.690 |
| string: canterbury/alice29.txt | 159425 | 4511.8 ± 0.5% | 2396.3 ± 3.1% | 1892.2 ± 3.5% | 269.6 ± 0.8% | 1946.8 ± 2.0% | 455.7 ± 7.1% | 1.883 | 2.384 | 16.733 | 2.318 | 9.902 |
| string: canterbury/asyoulik.txt | 132198 | 3930.3 ± 1.8% | 2145.8 ± 0.5% | 1488.1 ± 0.4% | 260.4 ± 0.4% | 1580.9 ± 1.1% | 408.0 ± 1.4% | 1.832 | 2.641 | 15.096 | 2.486 | 9.633 |
| string: canterbury/lcet10.txt | 441884 | 5583.6 ± 1.8% | 2825.2 ± 1.0% | 2019.9 ± 1.8% | 311.5 ± 0.3% | 2125.6 ± 1.2% | 492.8 ± 2.1% | 1.976 | 2.764 | 17.926 | 2.627 | 11.331 |
| string: canterbury/plrabn12.txt | 503330 | 4370.5 ± 0.3% | 2724.7 ± 1.6% | 1721.3 ± 0.4% | 282.2 ± 5.4% | 2010.8 ± 0.7% | 463.1 ± 0.7% | 1.604 | 2.539 | 15.487 | 2.174 | 9.437 |
| string: canterbury-large/E.coli | 1048578 | 37643.1 ± 2.7% | 7735.9 ± 1.1% | 3472.6 ± 1.2% | 800.4 ± 0.7% | 5527.4 ± 0.2% | 813.8 ± 1.1% | 4.866 | 10.840 | 47.031 | 6.810 | 46.255 |
| string: canterbury-large/bible.txt | 1055886 | 6649.2 ± 0.3% | 3921.2 ± 0.5% | 2637.9 ± 0.4% | 330.0 ± 7.2% | 2991.2 ± 1.0% | 606.6 ± 1.6% | 1.696 | 2.521 | 20.150 | 2.223 | 10.962 |
| string: canterbury-large/world192.txt | 1103121 | 3461.0 ± 0.7% | 2010.9 ± 2.6% | 1667.3 ± 1.3% | 279.0 ± 4.1% | 1697.2 ± 3.3% | 436.8 ± 0.7% | 1.721 | 2.076 | 12.403 | 2.039 | 7.924 |
| string: http/html-1m | 1058582 | 6226.5 ± 4.6% | 3411.4 ± 0.6% | 2450.7 ± 1.2% | 372.5 ± 1.7% | 2736.6 ± 0.4% | 429.1 ± 1.0% | 1.825 | 2.541 | 16.717 | 2.275 | 14.510 |
| string: http/json-1m | 1190272 | 3343.5 ± 0.9% | 1259.8 ± 0.3% | 1560.5 ± 7.0% | 310.0 ± 1.4% | 823.4 ± 0.9% | 294.6 ± 0.7% | 2.654 | 2.143 | 10.784 | 4.061 | 11.349 |
| string: http/js-1m | 1144362 | 2265.6 ± 0.4% | 1349.0 ± 0.2% | 1181.5 ± 1.9% | 255.6 ± 1.1% | 1167.0 ± 0.6% | 297.8 ± 1.5% | 1.679 | 1.918 | 8.865 | 1.941 | 7.609 |
| string: http/css-1m | 1097820 | 3020.8 ± 0.3% | 2559.0 ± 1.5% | 1556.2 ± 0.8% | 338.9 ± 0.4% | 1549.2 ± 1.8% | 339.1 ± 6.7% | 1.180 | 1.941 | 8.914 | 1.950 | 8.907 |
| string: dickens as Cyrillic and CJK | 1883069 | 5193.8 ± 2.4% | 3218.9 ± 5.1% | 655.0 ± 2.9% | 243.1 ± 0.9% | 497.4 ± 0.6% | 138.5 ± 1.3% | 1.614 | 7.929 | 21.367 | 10.442 | 37.507 |
| string: dickens as Cyrillic and CJK, as \u escapes | 5075485 | 1061.6 ± 1.1% | 1081.8 ± 1.5% | 821.7 ± 1.3% | 148.8 ± 0.8% | 384.2 ± 1.1% | 202.8 ± 5.3% | 0.981 | 1.292 | 7.136 | 2.763 | 5.234 |
| hex: silesia/dickens | 524290 | 37490.1 ± 1.5% | 7831.0 ± 0.3% | 3515.1 ± 6.7% | 424.0 ± 0.2% | 5534.9 ± 8.0% | 822.4 ± 2.4% | 4.787 | 10.665 | 88.424 | 6.773 | 45.585 |
| hex: silesia/mozilla | 524290 | 38204.8 ± 1.8% | 7831.8 ± 0.6% | 3493.8 ± 1.2% | 369.1 ± 14.7% | 5524.8 ± 0.3% | 825.4 ± 1.2% | 4.878 | 10.935 | 103.521 | 6.915 | 46.287 |
| hex: silesia/mr | 524290 | 37930.0 ± 1.4% | 7831.7 ± 0.5% | 3476.5 ± 2.8% | 518.2 ± 0.0% | 5527.3 ± 0.2% | 827.0 ± 2.3% | 4.843 | 10.910 | 73.202 | 6.862 | 45.865 |
| hex: silesia/nci | 524290 | 38022.2 ± 1.0% | 7817.7 ± 0.7% | 3505.9 ± 0.9% | 577.5 ± 0.3% | 5506.2 ± 0.2% | 826.3 ± 1.3% | 4.864 | 10.845 | 65.837 | 6.905 | 46.016 |
| hex: silesia/ooffice | 524290 | 37730.5 ± 4.0% | 7837.3 ± 0.5% | 3492.4 ± 0.5% | 320.2 ± 2.2% | 5516.9 ± 1.1% | 825.3 ± 2.4% | 4.814 | 10.804 | 117.828 | 6.839 | 45.716 |
| hex: silesia/osdb | 524290 | 37853.6 ± 1.6% | 7848.8 ± 0.2% | 3484.4 ± 0.7% | 406.7 ± 0.2% | 5508.2 ± 0.4% | 818.8 ± 1.1% | 4.823 | 10.864 | 93.069 | 6.872 | 46.228 |
| hex: silesia/reymont | 524290 | 38313.5 ± 1.8% | 7832.7 ± 1.3% | 3474.2 ± 0.4% | 435.4 ± 0.7% | 5541.0 ± 1.4% | 825.2 ± 0.5% | 4.891 | 11.028 | 87.998 | 6.914 | 46.428 |
| hex: silesia/samba | 524290 | 36480.9 ± 1.4% | 7832.8 ± 0.3% | 3488.3 ± 0.2% | 325.1 ± 12.3% | 5530.9 ± 1.3% | 824.4 ± 5.9% | 4.657 | 10.458 | 112.199 | 6.596 | 44.253 |
| hex: silesia/sao | 524290 | 37974.2 ± 2.5% | 7838.1 ± 0.4% | 3458.4 ± 2.1% | 263.3 ± 0.2% | 5520.1 ± 0.2% | 822.6 ± 1.2% | 4.845 | 10.980 | 144.238 | 6.879 | 46.164 |
| hex: silesia/webster | 524290 | 37486.1 ± 0.9% | 7822.4 ± 1.1% | 3493.0 ± 0.7% | 386.2 ± 0.2% | 5515.1 ± 0.2% | 822.4 ± 1.6% | 4.792 | 10.732 | 97.068 | 6.797 | 45.581 |
| hex: silesia/x-ray | 524290 | 35729.7 ± 0.7% | 7833.3 ± 1.0% | 3492.1 ± 0.3% | 386.2 ± 0.3% | 5535.4 ± 16.7% | 819.2 ± 0.6% | 4.561 | 10.231 | 92.521 | 6.455 | 43.615 |
| hex: silesia/xml | 524290 | 38123.2 ± 1.8% | 7824.1 ± 0.8% | 3500.7 ± 0.5% | 509.1 ± 0.5% | 5546.9 ± 1.2% | 826.0 ± 0.6% | 4.873 | 10.890 | 74.882 | 6.873 | 46.152 |
| hex: canterbury/alice29.txt | 304180 | 37341.7 ± 1.0% | 7814.2 ± 0.2% | 3592.1 ± 0.3% | 424.1 ± 0.2% | 5523.0 ± 0.6% | 826.3 ± 8.2% | 4.779 | 10.395 | 88.044 | 6.761 | 45.190 |
| hex: canterbury/asyoulik.txt | 250360 | 39086.1 ± 0.4% | 7801.8 ± 7.7% | 3570.4 ± 0.3% | 415.2 ± 0.6% | 5529.9 ± 0.2% | 831.8 ± 9.3% | 5.010 | 10.947 | 94.131 | 7.068 | 46.988 |
| hex: canterbury/cp.html | 49208 | 38743.7 ± 0.9% | 7806.0 ± 0.1% | 3612.8 ± 0.2% | 404.2 ± 0.2% | 5482.2 ± 1.1% | 807.3 ± 1.5% | 4.963 | 10.724 | 95.857 | 7.067 | 47.993 |
| hex: canterbury/fields.c | 22302 | 37024.2 ± 0.8% | 7713.8 ± 1.3% | 3602.3 ± 0.2% | 429.3 ± 0.2% | 5471.3 ± 1.6% | 794.4 ± 3.4% | 4.800 | 10.278 | 86.253 | 6.767 | 46.608 |
| hex: canterbury/grammar.lsp | 7444 | 34200.2 ± 5.4% | 7480.8 ± 0.4% | 3565.4 ± 8.3% | 482.8 ± 0.5% | 5367.7 ± 38.7% | 779.4 ± 1.2% | 4.572 | 9.592 | 70.835 | 6.371 | 43.879 |
| hex: canterbury/kennedy.xls | 524290 | 37366.6 ± 2.5% | 7796.3 ± 0.4% | 3490.0 ± 0.9% | 600.2 ± 1.0% | 5527.7 ± 0.2% | 817.8 ± 3.1% | 4.793 | 10.707 | 62.261 | 6.760 | 45.692 |
| hex: canterbury/lcet10.txt | 524290 | 37717.9 ± 1.3% | 7799.5 ± 3.2% | 3494.1 ± 0.8% | 426.8 ± 0.2% | 5521.6 ± 0.4% | 825.6 ± 7.8% | 4.836 | 10.795 | 88.380 | 6.831 | 45.688 |
| hex: canterbury/plrabn12.txt | 524290 | 36784.1 ± 1.3% | 7761.7 ± 1.0% | 3492.3 ± 0.9% | 414.7 ± 1.9% | 5499.1 ± 0.8% | 824.3 ± 6.7% | 4.739 | 10.533 | 88.692 | 6.689 | 44.624 |
| hex: canterbury/ptt5 | 524290 | 38449.0 ± 1.7% | 7797.3 ± 1.2% | 3494.9 ± 0.2% | 513.4 ± 1.5% | 5534.2 ± 10.4% | 825.7 ± 1.1% | 4.931 | 11.001 | 74.885 | 6.948 | 46.564 |
| hex: canterbury/sum | 76482 | 40768.3 ± 3.0% | 7819.4 ± 0.2% | 3624.7 ± 0.8% | 465.4 ± 0.7% | 5503.9 ± 0.6% | 826.8 ± 3.9% | 5.214 | 11.247 | 87.604 | 7.407 | 49.307 |
| hex: canterbury/xargs.1 | 8456 | 36384.3 ± 2.7% | 7525.3 ± 0.2% | 3551.1 ± 0.3% | 450.6 ± 0.7% | 5373.6 ± 1.1% | 814.5 ± 1.8% | 4.835 | 10.246 | 80.744 | 6.771 | 44.673 |
| hex: canterbury-large/E.coli | 524290 | 37344.4 ± 0.9% | 7794.3 ± 3.5% | 3477.8 ± 0.9% | 711.5 ± 2.8% | 5508.2 ± 0.3% | 812.2 ± 6.1% | 4.791 | 10.738 | 52.488 | 6.780 | 45.979 |
| hex: canterbury-large/bible.txt | 524290 | 33537.9 ± 1.6% | 7810.5 ± 2.4% | 3469.7 ± 1.2% | 438.5 ± 1.3% | 5522.9 ± 0.2% | 806.2 ± 3.5% | 4.294 | 9.666 | 76.477 | 6.073 | 41.600 |
| hex: canterbury-large/world192.txt | 524290 | 38272.0 ± 2.4% | 7797.8 ± 0.1% | 3481.9 ± 2.4% | 408.9 ± 2.2% | 5514.7 ± 17.0% | 813.5 ± 1.4% | 4.908 | 10.992 | 93.594 | 6.940 | 47.044 |
| hex: http/html-1kx1024 | 2099200 | 16513.2 ± 1.0% | 6668.6 ± 1.5% | 3213.1 ± 1.8% | 425.5 ± 0.2% | 4744.9 ± 0.7% | 718.0 ± 3.4% | 2.476 | 5.139 | 38.810 | 3.480 | 22.999 |
| hex: http/html-16kx64 | 2097280 | 35630.1 ± 1.2% | 7667.9 ± 0.3% | 3519.6 ± 1.0% | 431.3 ± 0.3% | 5434.4 ± 0.5% | 798.5 ± 3.9% | 4.647 | 10.123 | 82.619 | 6.556 | 44.623 |
| hex: http/html-1m | 524290 | 37920.8 ± 2.1% | 7759.8 ± 2.7% | 3482.6 ± 0.6% | 428.7 ± 1.2% | 5508.1 ± 0.2% | 814.2 ± 3.3% | 4.887 | 10.889 | 88.454 | 6.885 | 46.572 |
| hex: http/json-1kx1024 | 2099200 | 16348.7 ± 3.6% | 6663.7 ± 0.3% | 3201.8 ± 5.6% | 534.7 ± 6.3% | 4725.4 ± 1.1% | 708.6 ± 3.6% | 2.453 | 5.106 | 30.577 | 3.460 | 23.070 |
| hex: http/json-16kx64 | 2097280 | 35145.5 ± 1.5% | 7655.9 ± 0.1% | 3498.5 ± 1.3% | 544.7 ± 18.4% | 5420.8 ± 2.4% | 794.9 ± 7.5% | 4.591 | 10.046 | 64.525 | 6.483 | 44.214 |
| hex: http/json-1m | 524290 | 37304.4 ± 1.6% | 7784.7 ± 1.3% | 3488.8 ± 0.8% | 554.3 ± 0.2% | 5507.0 ± 0.9% | 793.6 ± 3.7% | 4.792 | 10.693 | 67.300 | 6.774 | 47.005 |
| hex: http/js-1kx1024 | 2099200 | 16497.6 ± 3.1% | 6658.8 ± 1.0% | 3215.6 ± 1.9% | 420.9 ± 0.3% | 4743.6 ± 0.8% | 718.6 ± 3.5% | 2.478 | 5.131 | 39.198 | 3.478 | 22.959 |
| hex: http/js-16kx64 | 2097280 | 34765.2 ± 9.2% | 7604.0 ± 12.6% | 3474.6 ± 7.3% | 423.0 ± 7.4% | 5399.8 ± 1.7% | 790.1 ± 11.6% | 4.572 | 10.006 | 82.190 | 6.438 | 43.999 |
| hex: http/js-1m | 524290 | 37399.5 ± 4.2% | 7699.7 ± 3.1% | 3459.6 ± 2.2% | 430.4 ± 1.9% | 5479.2 ± 2.2% | 790.2 ± 3.7% | 4.857 | 10.811 | 86.896 | 6.826 | 47.328 |
| hex: http/css-1kx1024 | 2099200 | 16670.6 ± 3.2% | 6649.6 ± 0.4% | 3228.6 ± 2.1% | 459.5 ± 14.1% | 4738.0 ± 1.1% | 734.0 ± 2.8% | 2.507 | 5.163 | 36.278 | 3.519 | 22.713 |
| hex: http/css-16kx64 | 2097280 | 34630.5 ± 1.7% | 7655.9 ± 1.0% | 3494.1 ± 6.6% | 466.5 ± 0.1% | 5432.4 ± 0.3% | 797.4 ± 1.4% | 4.523 | 9.911 | 74.242 | 6.375 | 43.430 |
| hex: http/css-1m | 524290 | 36045.0 ± 3.2% | 7818.5 ± 0.3% | 3488.0 ± 1.5% | 455.1 ± 0.7% | 5514.9 ± 2.5% | 805.9 ± 6.5% | 4.610 | 10.334 | 79.197 | 6.536 | 44.728 |
| hex: shuffled/dickens-1m | 524290 | 37320.8 ± 1.4% | 7776.4 ± 0.5% | 3480.0 ± 1.1% | 423.7 ± 1.1% | 5538.9 ± 0.1% | 818.6 ± 0.9% | 4.799 | 10.724 | 88.079 | 6.738 | 45.592 |

## Encoding against the baselines

Octets are the ones stdx writes. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1342.7 ± 1.6% | 1089.7 ± 2.7% | 872.4 ± 0.8% | 330.5 ± 1.0% | 365.2 ± 1.2% | 314.0 ± 1.1% | 1.232 | 1.539 | 4.063 | 3.676 | 4.276 |
| qlog records, JSON text sequence | 1467503 | 1147.6 ± 1.3% | 851.2 ± 1.2% | 701.6 ± 1.4% | 319.7 ± 4.6% | 382.8 ± 2.1% | 231.1 ± 2.0% | 1.348 | 1.636 | 3.590 | 2.998 | 4.966 |
| string: silesia/dickens | 172528 | 8922.6 ± 0.3% | 3119.8 ± 0.5% | 2026.4 ± 0.8% | 363.1 ± 0.6% | 1405.9 ± 1.5% | 560.6 ± 0.3% | 2.860 | 4.403 | 24.573 | 6.347 | 15.916 |
| string: silesia/nci | 1075110 | 8644.9 ± 0.5% | 3167.0 ± 0.3% | 2831.0 ± 1.5% | 776.6 ± 1.1% | 1534.7 ± 0.9% | 565.1 ± 0.9% | 2.730 | 3.054 | 11.132 | 5.633 | 15.298 |
| string: silesia/reymont | 1075159 | 3817.7 ± 0.3% | 1594.9 ± 0.2% | 1736.2 ± 0.3% | 373.8 ± 0.3% | 1237.6 ± 1.7% | 553.0 ± 0.5% | 2.394 | 2.199 | 10.213 | 3.085 | 6.903 |
| string: silesia/samba | 97582 | 4648.0 ± 0.4% | 2027.6 ± 0.2% | 2175.6 ± 0.5% | 300.5 ± 1.8% | 1065.5 ± 1.4% | 620.3 ± 0.4% | 2.292 | 2.136 | 15.466 | 4.362 | 7.494 |
| string: silesia/webster | 1098490 | 5102.5 ± 1.4% | 1631.1 ± 0.5% | 1535.0 ± 0.5% | 361.1 ± 12.6% | 1196.5 ± 1.7% | 456.1 ± 9.7% | 3.128 | 3.324 | 14.132 | 4.265 | 11.188 |
| string: silesia/xml | 1090118 | 7996.1 ± 0.6% | 2757.6 ± 0.9% | 2177.1 ± 0.3% | 532.3 ± 2.2% | 1578.3 ± 0.3% | 563.1 ± 8.5% | 2.900 | 3.673 | 15.022 | 5.066 | 14.200 |
| string: canterbury/alice29.txt | 159425 | 9643.9 ± 11.1% | 2591.9 ± 2.9% | 1759.5 ± 0.9% | 340.7 ± 0.3% | 1255.6 ± 1.3% | 555.7 ± 0.4% | 3.721 | 5.481 | 28.302 | 7.681 | 17.353 |
| string: canterbury/asyoulik.txt | 132198 | 8082.0 ± 1.2% | 2232.5 ± 1.0% | 1508.2 ± 1.3% | 346.5 ± 2.0% | 1116.1 ± 1.2% | 541.7 ± 0.6% | 3.620 | 5.359 | 23.327 | 7.241 | 14.918 |
| string: canterbury/lcet10.txt | 441884 | 8888.8 ± 1.3% | 2462.6 ± 7.0% | 1992.9 ± 0.7% | 396.9 ± 0.5% | 1382.1 ± 1.0% | 554.0 ± 0.8% | 3.610 | 4.460 | 22.397 | 6.431 | 16.045 |
| string: canterbury/plrabn12.txt | 503330 | 6028.7 ± 0.4% | 1801.1 ± 0.4% | 1682.2 ± 0.2% | 368.2 ± 1.5% | 1282.0 ± 2.0% | 558.0 ± 0.4% | 3.347 | 3.584 | 16.374 | 4.702 | 10.805 |
| string: canterbury-large/E.coli | 1048578 | 38160.0 ± 1.1% | 19239.4 ± 0.5% | 3389.8 ± 0.3% | 1422.1 ± 0.6% | 2526.7 ± 2.8% | 578.2 ± 1.3% | 1.983 | 11.257 | 26.833 | 15.103 | 66.002 |
| string: canterbury-large/bible.txt | 1055886 | 7013.8 ± 3.5% | 3962.2 ± 0.6% | 2667.6 ± 1.1% | 441.9 ± 0.8% | 1866.6 ± 0.4% | 567.5 ± 0.5% | 1.770 | 2.629 | 15.872 | 3.758 | 12.360 |
| string: canterbury-large/world192.txt | 1103121 | 5133.5 ± 3.6% | 1429.7 ± 1.0% | 1631.1 ± 0.3% | 366.5 ± 1.6% | 1169.9 ± 0.5% | 540.2 ± 1.0% | 3.591 | 3.147 | 14.007 | 4.388 | 9.502 |
| string: http/html-1m | 1058582 | 8438.7 ± 0.6% | 3892.1 ± 1.7% | 2486.1 ± 0.9% | 444.3 ± 0.9% | 1814.8 ± 15.9% | 523.3 ± 0.6% | 2.168 | 3.394 | 18.993 | 4.650 | 16.126 |
| string: http/json-1m | 1190272 | 6682.3 ± 0.4% | 1205.4 ± 1.6% | 1327.3 ± 1.6% | 416.2 ± 1.6% | 890.8 ± 1.9% | 511.4 ± 0.7% | 5.544 | 5.034 | 16.055 | 7.502 | 13.068 |
| string: http/js-1m | 1144362 | 5050.5 ± 1.3% | 989.9 ± 1.7% | 1065.9 ± 0.3% | 306.8 ± 2.0% | 908.1 ± 2.9% | 474.4 ± 0.7% | 5.102 | 4.738 | 16.461 | 5.562 | 10.647 |
| string: http/css-1m | 1097820 | 6847.0 ± 1.1% | 1254.9 ± 0.5% | 1630.4 ± 0.5% | 439.1 ± 1.3% | 1039.3 ± 11.8% | 531.0 ± 0.6% | 5.456 | 4.200 | 15.595 | 6.588 | 12.894 |
| string: dickens as Cyrillic and CJK | 1883069 | 5323.8 ± 18.9% | 3105.3 ± 0.4% | 361.4 ± 28.6% | 275.4 ± 0.2% | 462.0 ± 2.0% | 293.1 ± 0.9% | 1.714 | 14.731 | 19.329 | 11.522 | 18.165 |
| hex: silesia/dickens | 524290 | 31625.8 ± 0.9% | 1543.4 ± 2.0% | 1086.6 ± 0.5% | 427.7 ± 1.2% | 1045.9 ± 13.1% | 449.4 ± 0.5% | 20.490 | 29.106 | 73.935 | 30.239 | 70.377 |
| hex: silesia/mozilla | 524290 | 35916.4 ± 1.0% | 1552.4 ± 0.5% | 1088.8 ± 0.5% | 371.7 ± 0.6% | 1053.3 ± 0.6% | 449.7 ± 0.8% | 23.136 | 32.987 | 96.632 | 34.100 | 79.869 |
| hex: silesia/mr | 524290 | 34496.1 ± 0.8% | 1546.2 ± 1.2% | 1089.7 ± 0.8% | 509.5 ± 10.1% | 1047.0 ± 16.3% | 450.2 ± 0.7% | 22.310 | 31.658 | 67.709 | 32.948 | 76.629 |
| hex: silesia/nci | 524290 | 33770.0 ± 0.6% | 1551.8 ± 4.3% | 1088.2 ± 0.4% | 584.0 ± 1.1% | 1057.0 ± 0.5% | 450.8 ± 0.4% | 21.762 | 31.033 | 57.823 | 31.949 | 74.913 |
| hex: silesia/ooffice | 524290 | 34386.4 ± 0.9% | 1549.4 ± 1.4% | 1085.6 ± 4.8% | 328.3 ± 0.2% | 1049.0 ± 0.5% | 449.3 ± 0.8% | 22.193 | 31.674 | 104.746 | 32.780 | 76.529 |
| hex: silesia/osdb | 524290 | 34771.7 ± 0.7% | 1552.6 ± 0.6% | 1088.4 ± 1.0% | 417.1 ± 0.2% | 1052.8 ± 17.4% | 448.8 ± 6.5% | 22.395 | 31.949 | 83.370 | 33.028 | 77.484 |
| hex: silesia/reymont | 524290 | 33360.3 ± 13.0% | 1553.5 ± 1.1% | 1090.7 ± 2.0% | 445.4 ± 0.2% | 1047.4 ± 10.1% | 449.6 ± 0.2% | 21.475 | 30.587 | 74.894 | 31.849 | 74.203 |
| hex: silesia/samba | 524290 | 33194.9 ± 3.5% | 1550.4 ± 0.6% | 1086.0 ± 0.6% | 334.1 ± 7.0% | 1054.7 ± 0.5% | 449.5 ± 0.5% | 21.411 | 30.566 | 99.361 | 31.474 | 73.845 |
| hex: silesia/sao | 524290 | 33928.1 ± 0.6% | 1547.9 ± 2.8% | 1088.2 ± 0.6% | 268.3 ± 0.2% | 1048.8 ± 0.5% | 449.2 ± 0.9% | 21.919 | 31.177 | 126.438 | 32.349 | 75.526 |
| hex: silesia/webster | 524290 | 36865.6 ± 0.7% | 1549.5 ± 4.8% | 1088.6 ± 0.7% | 408.6 ± 0.7% | 1056.7 ± 0.4% | 450.4 ± 1.4% | 23.792 | 33.866 | 90.223 | 34.888 | 81.857 |
| hex: silesia/x-ray | 524290 | 34073.8 ± 0.5% | 1550.0 ± 0.6% | 1087.8 ± 0.1% | 397.7 ± 0.9% | 1048.4 ± 0.1% | 449.3 ± 1.1% | 21.983 | 31.325 | 85.674 | 32.502 | 75.829 |
| hex: silesia/xml | 524290 | 34099.7 ± 1.7% | 1548.0 ± 0.6% | 1087.6 ± 0.7% | 585.2 ± 0.4% | 1056.5 ± 0.7% | 448.3 ± 0.7% | 22.029 | 31.354 | 58.275 | 32.276 | 76.061 |
| hex: canterbury/alice29.txt | 304180 | 35052.0 ± 1.9% | 1588.8 ± 0.7% | 1099.5 ± 0.3% | 430.9 ± 1.1% | 1073.0 ± 0.7% | 451.5 ± 1.6% | 22.062 | 31.881 | 81.347 | 32.668 | 77.628 |
| hex: canterbury/asyoulik.txt | 250360 | 30816.7 ± 1.4% | 1595.7 ± 0.7% | 1097.3 ± 0.7% | 423.7 ± 0.7% | 1075.1 ± 0.8% | 454.0 ± 1.5% | 19.313 | 28.083 | 72.731 | 28.665 | 67.878 |
| hex: canterbury/cp.html | 49208 | 31702.4 ± 0.1% | 1620.9 ± 1.7% | 1112.5 ± 0.1% | 465.9 ± 0.6% | 1073.6 ± 0.5% | 455.5 ± 1.1% | 19.559 | 28.497 | 68.044 | 29.530 | 69.597 |
| hex: canterbury/fields.c | 22302 | 32803.8 ± 0.1% | 1594.9 ± 0.6% | 1100.1 ± 0.2% | 541.5 ± 0.8% | 1059.9 ± 1.4% | 455.5 ± 0.8% | 20.568 | 29.819 | 60.578 | 30.949 | 72.024 |
| hex: canterbury/grammar.lsp | 7444 | 31072.8 ± 0.4% | 1631.7 ± 1.8% | 1113.8 ± 2.4% | 564.4 ± 0.5% | 1081.3 ± 1.5% | 461.9 ± 0.6% | 19.044 | 27.897 | 55.053 | 28.736 | 67.265 |
| hex: canterbury/kennedy.xls | 524290 | 30841.1 ± 0.3% | 1546.5 ± 1.4% | 1086.8 ± 1.9% | 594.1 ± 0.8% | 1049.0 ± 0.5% | 450.7 ± 3.6% | 19.943 | 28.377 | 51.914 | 29.401 | 68.433 |
| hex: canterbury/lcet10.txt | 524290 | 33552.4 ± 0.7% | 1567.3 ± 1.2% | 1091.3 ± 0.7% | 431.6 ± 0.7% | 1054.0 ± 0.8% | 450.4 ± 0.4% | 21.408 | 30.745 | 77.731 | 31.834 | 74.502 |
| hex: canterbury/plrabn12.txt | 524290 | 33169.2 ± 2.3% | 1555.9 ± 2.3% | 1090.8 ± 0.4% | 419.8 ± 0.3% | 1052.1 ± 0.7% | 449.8 ± 1.0% | 21.318 | 30.408 | 79.006 | 31.526 | 73.750 |
| hex: canterbury/ptt5 | 524290 | 33265.0 ± 0.6% | 1557.7 ± 0.8% | 1091.2 ± 0.5% | 501.5 ± 1.3% | 1051.6 ± 0.8% | 450.4 ± 0.5% | 21.355 | 30.484 | 66.332 | 31.633 | 73.850 |
| hex: canterbury/sum | 76482 | 35187.0 ± 0.2% | 1616.0 ± 0.2% | 1109.6 ± 0.2% | 522.5 ± 0.4% | 1065.7 ± 2.7% | 458.9 ± 1.0% | 21.774 | 31.712 | 67.349 | 33.016 | 76.678 |
| hex: canterbury/xargs.1 | 8456 | 34866.4 ± 0.6% | 1628.1 ± 0.9% | 1111.7 ± 10.6% | 598.7 ± 0.4% | 1077.9 ± 1.2% | 462.1 ± 0.3% | 21.415 | 31.362 | 58.234 | 32.348 | 75.459 |
| hex: canterbury-large/E.coli | 524290 | 30717.5 ± 0.5% | 1538.6 ± 0.5% | 1083.6 ± 1.6% | 605.8 ± 0.4% | 1044.4 ± 1.3% | 449.7 ± 1.1% | 19.965 | 28.349 | 50.705 | 29.413 | 68.301 |
| hex: canterbury-large/bible.txt | 524290 | 35461.5 ± 0.8% | 1558.0 ± 1.7% | 1091.7 ± 0.5% | 442.7 ± 2.4% | 1055.0 ± 0.7% | 450.2 ± 1.3% | 22.761 | 32.482 | 80.101 | 33.613 | 78.766 |
| hex: canterbury-large/world192.txt | 524290 | 35093.2 ± 0.5% | 1556.6 ± 1.5% | 1089.8 ± 0.5% | 422.6 ± 0.3% | 1057.9 ± 2.6% | 450.7 ± 0.8% | 22.545 | 32.203 | 83.044 | 33.173 | 77.867 |
| hex: http/html-1kx1024 | 2099200 | 23982.4 ± 2.7% | 1600.1 ± 0.5% | 1088.4 ± 0.3% | 458.5 ± 1.6% | 1065.5 ± 1.4% | 452.6 ± 0.6% | 14.988 | 22.034 | 52.302 | 22.509 | 52.984 |
| hex: http/html-16kx64 | 2097280 | 29623.1 ± 2.2% | 1608.7 ± 0.1% | 1103.7 ± 0.2% | 463.1 ± 1.1% | 1059.1 ± 1.1% | 456.8 ± 0.6% | 18.415 | 26.841 | 63.966 | 27.971 | 64.849 |
| hex: http/html-1m | 524290 | 29153.4 ± 2.3% | 1552.6 ± 3.1% | 1088.6 ± 0.4% | 447.0 ± 0.4% | 1036.8 ± 2.8% | 448.5 ± 0.3% | 18.777 | 26.780 | 65.219 | 28.119 | 65.001 |
| hex: http/json-1kx1024 | 2099200 | 23914.7 ± 1.6% | 1604.7 ± 0.2% | 1088.7 ± 0.4% | 565.6 ± 15.4% | 1052.9 ± 1.9% | 452.4 ± 5.2% | 14.903 | 21.967 | 42.281 | 22.713 | 52.866 |
| hex: http/json-16kx64 | 2097280 | 29927.1 ± 0.5% | 1611.4 ± 7.7% | 1105.4 ± 0.1% | 571.5 ± 0.8% | 1025.5 ± 1.0% | 457.2 ± 0.1% | 18.572 | 27.074 | 52.369 | 29.184 | 65.453 |
| hex: http/json-1m | 524290 | 31503.5 ± 1.6% | 1544.8 ± 1.7% | 1088.9 ± 0.9% | 587.1 ± 0.7% | 1028.2 ± 1.6% | 450.2 ± 0.6% | 20.394 | 28.931 | 53.659 | 30.641 | 69.977 |
| hex: http/js-1kx1024 | 2099200 | 23565.7 ± 2.7% | 1605.7 ± 0.2% | 1089.6 ± 0.2% | 445.0 ± 0.6% | 1066.9 ± 2.2% | 452.2 ± 0.6% | 14.676 | 21.627 | 52.955 | 22.089 | 52.110 |
| hex: http/js-16kx64 | 2097280 | 30006.7 ± 1.4% | 1605.1 ± 0.9% | 1101.9 ± 0.6% | 440.3 ± 0.1% | 1010.7 ± 1.0% | 456.7 ± 0.1% | 18.694 | 27.232 | 68.146 | 29.688 | 65.710 |
| hex: http/js-1m | 524290 | 30682.3 ± 0.6% | 1541.5 ± 37.0% | 1087.6 ± 1.2% | 451.1 ± 11.1% | 1032.1 ± 0.5% | 449.5 ± 0.5% | 19.904 | 28.210 | 68.022 | 29.729 | 68.264 |
| hex: http/css-1kx1024 | 2099200 | 23799.1 ± 2.4% | 1603.5 ± 0.9% | 1086.0 ± 0.4% | 500.6 ± 0.7% | 1060.3 ± 2.2% | 452.8 ± 0.7% | 14.842 | 21.915 | 47.540 | 22.446 | 52.564 |
| hex: http/css-16kx64 | 2097280 | 30132.2 ± 0.6% | 1608.7 ± 0.2% | 1104.2 ± 0.2% | 507.5 ± 0.8% | 1059.8 ± 4.3% | 456.1 ± 1.5% | 18.730 | 27.288 | 59.370 | 28.432 | 66.063 |
| hex: http/css-1m | 524290 | 31220.6 ± 0.5% | 1552.1 ± 0.4% | 1085.6 ± 0.8% | 485.5 ± 0.3% | 1041.1 ± 0.7% | 448.6 ± 0.4% | 20.115 | 28.758 | 64.310 | 29.987 | 69.594 |
| hex: shuffled/dickens-1m | 524290 | 34957.4 ± 1.6% | 1550.1 ± 0.9% | 1087.7 ± 0.8% | 425.7 ± 0.2% | 1029.7 ± 1.1% | 451.8 ± 1.0% | 22.552 | 32.139 | 82.111 | 33.950 | 77.381 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1372.7 ± 3.8% | 1089.7 ± 2.7% | 872.4 ± 0.8% | 330.5 ± 1.0% | 365.2 ± 1.2% | 314.0 ± 1.1% | 1.260 | 1.573 | 4.153 | 3.758 | 4.371 |
| qlog records, JSON text sequence | 1467503 | 1165.1 ± 0.6% | 851.2 ± 1.2% | 701.6 ± 1.4% | 319.7 ± 4.6% | 382.8 ± 2.1% | 231.1 ± 2.0% | 1.369 | 1.661 | 3.645 | 3.044 | 5.041 |
| string: silesia/dickens | 172528 | 9360.6 ± 0.6% | 3119.8 ± 0.5% | 2026.4 ± 0.8% | 363.1 ± 0.6% | 1405.9 ± 1.5% | 560.6 ± 0.3% | 3.000 | 4.619 | 25.779 | 6.658 | 16.697 |
| string: silesia/nci | 1075110 | 8880.8 ± 0.4% | 3167.0 ± 0.3% | 2831.0 ± 1.5% | 776.6 ± 1.1% | 1534.7 ± 0.9% | 565.1 ± 0.9% | 2.804 | 3.137 | 11.436 | 5.787 | 15.715 |
| string: silesia/reymont | 1075159 | 3832.0 ± 0.3% | 1594.9 ± 0.2% | 1736.2 ± 0.3% | 373.8 ± 0.3% | 1237.6 ± 1.7% | 553.0 ± 0.5% | 2.403 | 2.207 | 10.251 | 3.096 | 6.929 |
| string: silesia/samba | 97582 | 5196.2 ± 1.8% | 2027.6 ± 0.2% | 2175.6 ± 0.5% | 300.5 ± 1.8% | 1065.5 ± 1.4% | 620.3 ± 0.4% | 2.563 | 2.388 | 17.291 | 4.877 | 8.377 |
| string: silesia/webster | 1098490 | 5117.1 ± 9.2% | 1631.1 ± 0.5% | 1535.0 ± 0.5% | 361.1 ± 12.6% | 1196.5 ± 1.7% | 456.1 ± 9.7% | 3.137 | 3.334 | 14.173 | 4.277 | 11.220 |
| string: silesia/xml | 1090118 | 8493.5 ± 0.8% | 2757.6 ± 0.9% | 2177.1 ± 0.3% | 532.3 ± 2.2% | 1578.3 ± 0.3% | 563.1 ± 8.5% | 3.080 | 3.901 | 15.956 | 5.381 | 15.083 |
| string: canterbury/alice29.txt | 159425 | 9974.9 ± 0.3% | 2591.9 ± 2.9% | 1759.5 ± 0.9% | 340.7 ± 0.3% | 1255.6 ± 1.3% | 555.7 ± 0.4% | 3.848 | 5.669 | 29.274 | 7.944 | 17.949 |
| string: canterbury/asyoulik.txt | 132198 | 8393.7 ± 0.6% | 2232.5 ± 1.0% | 1508.2 ± 1.3% | 346.5 ± 2.0% | 1116.1 ± 1.2% | 541.7 ± 0.6% | 3.760 | 5.565 | 24.227 | 7.521 | 15.494 |
| string: canterbury/lcet10.txt | 441884 | 9189.1 ± 0.4% | 2462.6 ± 7.0% | 1992.9 ± 0.7% | 396.9 ± 0.5% | 1382.1 ± 1.0% | 554.0 ± 0.8% | 3.731 | 4.611 | 23.154 | 6.649 | 16.587 |
| string: canterbury/plrabn12.txt | 503330 | 6372.8 ± 0.4% | 1801.1 ± 0.4% | 1682.2 ± 0.2% | 368.2 ± 1.5% | 1282.0 ± 2.0% | 558.0 ± 0.4% | 3.538 | 3.788 | 17.308 | 4.971 | 11.422 |
| string: canterbury-large/E.coli | 1048578 | 38861.5 ± 0.4% | 19239.4 ± 0.5% | 3389.8 ± 0.3% | 1422.1 ± 0.6% | 2526.7 ± 2.8% | 578.2 ± 1.3% | 2.020 | 11.464 | 27.327 | 15.380 | 67.216 |
| string: canterbury-large/bible.txt | 1055886 | 7386.6 ± 0.6% | 3962.2 ± 0.6% | 2667.6 ± 1.1% | 441.9 ± 0.8% | 1866.6 ± 0.4% | 567.5 ± 0.5% | 1.864 | 2.769 | 16.715 | 3.957 | 13.016 |
| string: canterbury-large/world192.txt | 1103121 | 4782.7 ± 5.4% | 1429.7 ± 1.0% | 1631.1 ± 0.3% | 366.5 ± 1.6% | 1169.9 ± 0.5% | 540.2 ± 1.0% | 3.345 | 2.932 | 13.050 | 4.088 | 8.853 |
| string: http/html-1m | 1058582 | 8594.0 ± 0.7% | 3892.1 ± 1.7% | 2486.1 ± 0.9% | 444.3 ± 0.9% | 1814.8 ± 15.9% | 523.3 ± 0.6% | 2.208 | 3.457 | 19.342 | 4.735 | 16.423 |
| string: http/json-1m | 1190272 | 6805.0 ± 1.0% | 1205.4 ± 1.6% | 1327.3 ± 1.6% | 416.2 ± 1.6% | 890.8 ± 1.9% | 511.4 ± 0.7% | 5.646 | 5.127 | 16.349 | 7.639 | 13.307 |
| string: http/js-1m | 1144362 | 5041.5 ± 0.3% | 989.9 ± 1.7% | 1065.9 ± 0.3% | 306.8 ± 2.0% | 908.1 ± 2.9% | 474.4 ± 0.7% | 5.093 | 4.730 | 16.431 | 5.552 | 10.628 |
| string: http/css-1m | 1097820 | 7213.2 ± 1.5% | 1254.9 ± 0.5% | 1630.4 ± 0.5% | 439.1 ± 1.3% | 1039.3 ± 11.8% | 531.0 ± 0.6% | 5.748 | 4.424 | 16.429 | 6.941 | 13.584 |
| string: dickens as Cyrillic and CJK | 1883069 | 5246.1 ± 1.6% | 3105.3 ± 0.4% | 361.4 ± 28.6% | 275.4 ± 0.2% | 462.0 ± 2.0% | 293.1 ± 0.9% | 1.689 | 14.516 | 19.047 | 11.354 | 17.899 |
| hex: silesia/dickens | 524290 | 31851.1 ± 0.6% | 1543.4 ± 2.0% | 1086.6 ± 0.5% | 427.7 ± 1.2% | 1045.9 ± 13.1% | 449.4 ± 0.5% | 20.636 | 29.313 | 74.462 | 30.454 | 70.878 |
| hex: silesia/mozilla | 524290 | 36354.6 ± 1.0% | 1552.4 ± 0.5% | 1088.8 ± 0.5% | 371.7 ± 0.6% | 1053.3 ± 0.6% | 449.7 ± 0.8% | 23.419 | 33.390 | 97.811 | 34.516 | 80.843 |
| hex: silesia/mr | 524290 | 34861.2 ± 0.6% | 1546.2 ± 1.2% | 1089.7 ± 0.8% | 509.5 ± 10.1% | 1047.0 ± 16.3% | 450.2 ± 0.7% | 22.546 | 31.993 | 68.425 | 33.296 | 77.440 |
| hex: silesia/nci | 524290 | 34228.7 ± 0.9% | 1551.8 ± 4.3% | 1088.2 ± 0.4% | 584.0 ± 1.1% | 1057.0 ± 0.5% | 450.8 ± 0.4% | 22.057 | 31.454 | 58.608 | 32.383 | 75.930 |
| hex: silesia/ooffice | 524290 | 34817.7 ± 0.5% | 1549.4 ± 1.4% | 1085.6 ± 4.8% | 328.3 ± 0.2% | 1049.0 ± 0.5% | 449.3 ± 0.8% | 22.472 | 32.072 | 106.060 | 33.191 | 77.489 |
| hex: silesia/osdb | 524290 | 35086.6 ± 0.2% | 1552.6 ± 0.6% | 1088.4 ± 1.0% | 417.1 ± 0.2% | 1052.8 ± 17.4% | 448.8 ± 6.5% | 22.598 | 32.238 | 84.125 | 33.327 | 78.185 |
| hex: silesia/reymont | 524290 | 33658.5 ± 0.4% | 1553.5 ± 1.1% | 1090.7 ± 2.0% | 445.4 ± 0.2% | 1047.4 ± 10.1% | 449.6 ± 0.2% | 21.667 | 30.861 | 75.564 | 32.134 | 74.867 |
| hex: silesia/samba | 524290 | 33402.9 ± 0.4% | 1550.4 ± 0.6% | 1086.0 ± 0.6% | 334.1 ± 7.0% | 1054.7 ± 0.5% | 449.5 ± 0.5% | 21.545 | 30.758 | 99.983 | 31.672 | 74.307 |
| hex: silesia/sao | 524290 | 34250.1 ± 0.4% | 1547.9 ± 2.8% | 1088.2 ± 0.6% | 268.3 ± 0.2% | 1048.8 ± 0.5% | 449.2 ± 0.9% | 22.127 | 31.473 | 127.638 | 32.656 | 76.243 |
| hex: silesia/webster | 524290 | 37287.4 ± 0.4% | 1549.5 ± 4.8% | 1088.6 ± 0.7% | 408.6 ± 0.7% | 1056.7 ± 0.4% | 450.4 ± 1.4% | 24.064 | 34.253 | 91.255 | 35.287 | 82.794 |
| hex: silesia/x-ray | 524290 | 34285.4 ± 2.0% | 1550.0 ± 0.6% | 1087.8 ± 0.1% | 397.7 ± 0.9% | 1048.4 ± 0.1% | 449.3 ± 1.1% | 22.120 | 31.519 | 86.206 | 32.704 | 76.300 |
| hex: silesia/xml | 524290 | 34487.1 ± 0.7% | 1548.0 ± 0.6% | 1087.6 ± 0.7% | 585.2 ± 0.4% | 1056.5 ± 0.7% | 448.3 ± 0.7% | 22.279 | 31.711 | 58.937 | 32.642 | 76.925 |
| hex: canterbury/alice29.txt | 304180 | 35166.3 ± 1.1% | 1588.8 ± 0.7% | 1099.5 ± 0.3% | 430.9 ± 1.1% | 1073.0 ± 0.7% | 451.5 ± 1.6% | 22.134 | 31.985 | 81.612 | 32.774 | 77.881 |
| hex: canterbury/asyoulik.txt | 250360 | 31150.1 ± 1.4% | 1595.7 ± 0.7% | 1097.3 ± 0.7% | 423.7 ± 0.7% | 1075.1 ± 0.8% | 454.0 ± 1.5% | 19.522 | 28.387 | 73.517 | 28.975 | 68.612 |
| hex: canterbury/cp.html | 49208 | 31719.9 ± 0.1% | 1620.9 ± 1.7% | 1112.5 ± 0.1% | 465.9 ± 0.6% | 1073.6 ± 0.5% | 455.5 ± 1.1% | 19.570 | 28.513 | 68.081 | 29.546 | 69.635 |
| hex: canterbury/fields.c | 22302 | 32951.3 ± 5.9% | 1594.9 ± 0.6% | 1100.1 ± 0.2% | 541.5 ± 0.8% | 1059.9 ± 1.4% | 455.5 ± 0.8% | 20.661 | 29.953 | 60.851 | 31.088 | 72.348 |
| hex: canterbury/grammar.lsp | 7444 | 31105.4 ± 0.5% | 1631.7 ± 1.8% | 1113.8 ± 2.4% | 564.4 ± 0.5% | 1081.3 ± 1.5% | 461.9 ± 0.6% | 19.064 | 27.926 | 55.110 | 28.766 | 67.335 |
| hex: canterbury/kennedy.xls | 524290 | 31048.1 ± 0.7% | 1546.5 ± 1.4% | 1086.8 ± 1.9% | 594.1 ± 0.8% | 1049.0 ± 0.5% | 450.7 ± 3.6% | 20.077 | 28.567 | 52.262 | 29.598 | 68.893 |
| hex: canterbury/lcet10.txt | 524290 | 33772.8 ± 0.5% | 1567.3 ± 1.2% | 1091.3 ± 0.7% | 431.6 ± 0.7% | 1054.0 ± 0.8% | 450.4 ± 0.4% | 21.548 | 30.947 | 78.242 | 32.044 | 74.992 |
| hex: canterbury/plrabn12.txt | 524290 | 33197.7 ± 1.2% | 1555.9 ± 2.3% | 1090.8 ± 0.4% | 419.8 ± 0.3% | 1052.1 ± 0.7% | 449.8 ± 1.0% | 21.337 | 30.434 | 79.074 | 31.553 | 73.813 |
| hex: canterbury/ptt5 | 524290 | 33469.8 ± 1.9% | 1557.7 ± 0.8% | 1091.2 ± 0.5% | 501.5 ± 1.3% | 1051.6 ± 0.8% | 450.4 ± 0.5% | 21.487 | 30.671 | 66.741 | 31.828 | 74.305 |
| hex: canterbury/sum | 76482 | 34967.4 ± 6.4% | 1616.0 ± 0.2% | 1109.6 ± 0.2% | 522.5 ± 0.4% | 1065.7 ± 2.7% | 458.9 ± 1.0% | 21.638 | 31.514 | 66.929 | 32.810 | 76.199 |
| hex: canterbury/xargs.1 | 8456 | 34998.4 ± 0.1% | 1628.1 ± 0.9% | 1111.7 ± 10.6% | 598.7 ± 0.4% | 1077.9 ± 1.2% | 462.1 ± 0.3% | 21.496 | 31.481 | 58.454 | 32.470 | 75.745 |
| hex: canterbury-large/E.coli | 524290 | 30816.9 ± 4.5% | 1538.6 ± 0.5% | 1083.6 ± 1.6% | 605.8 ± 0.4% | 1044.4 ± 1.3% | 449.7 ± 1.1% | 20.029 | 28.441 | 50.870 | 29.508 | 68.522 |
| hex: canterbury-large/bible.txt | 524290 | 35424.0 ± 0.4% | 1558.0 ± 1.7% | 1091.7 ± 0.5% | 442.7 ± 2.4% | 1055.0 ± 0.7% | 450.2 ± 1.3% | 22.737 | 32.447 | 80.016 | 33.577 | 78.683 |
| hex: canterbury-large/world192.txt | 524290 | 35419.8 ± 0.4% | 1556.6 ± 1.5% | 1089.8 ± 0.5% | 422.6 ± 0.3% | 1057.9 ± 2.6% | 450.7 ± 0.8% | 22.755 | 32.503 | 83.817 | 33.482 | 78.592 |
| hex: http/html-1kx1024 | 2099200 | 24018.6 ± 2.6% | 1600.1 ± 0.5% | 1088.4 ± 0.3% | 458.5 ± 1.6% | 1065.5 ± 1.4% | 452.6 ± 0.6% | 15.011 | 22.068 | 52.381 | 22.542 | 53.064 |
| hex: http/html-16kx64 | 2097280 | 30000.2 ± 0.4% | 1608.7 ± 0.1% | 1103.7 ± 0.2% | 463.1 ± 1.1% | 1059.1 ± 1.1% | 456.8 ± 0.6% | 18.649 | 27.182 | 64.780 | 28.327 | 65.674 |
| hex: http/html-1m | 524290 | 29319.9 ± 0.5% | 1552.6 ± 3.1% | 1088.6 ± 0.4% | 447.0 ± 0.4% | 1036.8 ± 2.8% | 448.5 ± 0.3% | 18.884 | 26.933 | 65.592 | 28.280 | 65.373 |
| hex: http/json-1kx1024 | 2099200 | 24513.5 ± 0.7% | 1604.7 ± 0.2% | 1088.7 ± 0.4% | 565.6 ± 15.4% | 1052.9 ± 1.9% | 452.4 ± 5.2% | 15.276 | 22.517 | 43.339 | 23.282 | 54.190 |
| hex: http/json-16kx64 | 2097280 | 30170.4 ± 0.2% | 1611.4 ± 7.7% | 1105.4 ± 0.1% | 571.5 ± 0.8% | 1025.5 ± 1.0% | 457.2 ± 0.1% | 18.723 | 27.294 | 52.794 | 29.422 | 65.985 |
| hex: http/json-1m | 524290 | 31706.9 ± 7.1% | 1544.8 ± 1.7% | 1088.9 ± 0.9% | 587.1 ± 0.7% | 1028.2 ± 1.6% | 450.2 ± 0.6% | 20.525 | 29.117 | 54.005 | 30.838 | 70.429 |
| hex: http/js-1kx1024 | 2099200 | 23856.2 ± 2.3% | 1605.7 ± 0.2% | 1089.6 ± 0.2% | 445.0 ± 0.6% | 1066.9 ± 2.2% | 452.2 ± 0.6% | 14.857 | 21.894 | 53.608 | 22.361 | 52.752 |
| hex: http/js-16kx64 | 2097280 | 30076.6 ± 0.5% | 1605.1 ± 0.9% | 1101.9 ± 0.6% | 440.3 ± 0.1% | 1010.7 ± 1.0% | 456.7 ± 0.1% | 18.738 | 27.295 | 68.305 | 29.757 | 65.863 |
| hex: http/js-1m | 524290 | 30842.4 ± 0.8% | 1541.5 ± 37.0% | 1087.6 ± 1.2% | 451.1 ± 11.1% | 1032.1 ± 0.5% | 449.5 ± 0.5% | 20.008 | 28.357 | 68.376 | 29.884 | 68.621 |
| hex: http/css-1kx1024 | 2099200 | 23868.1 ± 1.1% | 1603.5 ± 0.9% | 1086.0 ± 0.4% | 500.6 ± 0.7% | 1060.3 ± 2.2% | 452.8 ± 0.7% | 14.885 | 21.979 | 47.678 | 22.511 | 52.716 |
| hex: http/css-16kx64 | 2097280 | 30635.8 ± 0.4% | 1608.7 ± 0.2% | 1104.2 ± 0.2% | 507.5 ± 0.8% | 1059.8 ± 4.3% | 456.1 ± 1.5% | 19.043 | 27.744 | 60.362 | 28.908 | 67.167 |
| hex: http/css-1m | 524290 | 31340.0 ± 0.5% | 1552.1 ± 0.4% | 1085.6 ± 0.8% | 485.5 ± 0.3% | 1041.1 ± 0.7% | 448.6 ± 0.4% | 20.192 | 28.868 | 64.556 | 30.102 | 69.860 |
| hex: shuffled/dickens-1m | 524290 | 35370.8 ± 15.0% | 1550.1 ± 0.9% | 1087.7 ± 0.8% | 425.7 ± 0.2% | 1029.7 ± 1.1% | 451.8 ± 1.0% | 22.819 | 32.519 | 83.081 | 34.351 | 78.296 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 735.6 ± 0.6% | 1021.1 ± 0.3% | 949.1 ± 0.6% | 260.6 ± 1.2% | 530.1 ± 0.3% | 258.9 ± 4.2% | 0.720 | 0.775 | 2.823 | 1.388 | 2.841 |
| qlog records, JSON text sequence | 1467503 | 551.4 ± 12.6% | 805.4 ± 1.8% | 802.2 ± 0.4% | 220.0 ± 2.2% | 588.5 ± 0.8% | 245.8 ± 2.1% | 0.685 | 0.687 | 2.507 | 0.937 | 2.243 |
| string: silesia/dickens | 172528 | 960.0 ± 2.3% | 2935.5 ± 1.7% | 2067.5 ± 0.7% | 286.4 ± 0.4% | 2177.5 ± 8.1% | 497.8 ± 2.1% | 0.327 | 0.464 | 3.352 | 0.441 | 1.928 |
| string: silesia/nci | 1075110 | 1185.5 ± 3.0% | 3542.7 ± 0.2% | 2825.9 ± 4.1% | 427.9 ± 2.4% | 2406.1 ± 2.4% | 526.0 ± 1.4% | 0.335 | 0.420 | 2.771 | 0.493 | 2.254 |
| string: silesia/reymont | 1075159 | 930.0 ± 3.8% | 2200.7 ± 0.7% | 1836.8 ± 4.2% | 295.1 ± 1.6% | 1643.0 ± 0.7% | 477.8 ± 4.3% | 0.423 | 0.506 | 3.151 | 0.566 | 1.947 |
| string: silesia/samba | 97582 | 220.0 ± 0.5% | 2904.6 ± 7.5% | 1698.1 ± 4.1% | 241.6 ± 0.7% | 1280.4 ± 1.2% | 356.8 ± 3.1% | 0.076 | 0.130 | 0.911 | 0.172 | 0.617 |
| string: silesia/webster | 1098490 | 710.3 ± 1.0% | 2049.5 ± 0.5% | 1681.1 ± 7.4% | 286.2 ± 0.7% | 1678.8 ± 2.0% | 443.3 ± 1.1% | 0.347 | 0.422 | 2.482 | 0.423 | 1.602 |
| string: silesia/xml | 1090118 | 1107.1 ± 3.1% | 3755.6 ± 1.5% | 2167.9 ± 0.7% | 374.9 ± 0.2% | 2366.0 ± 1.3% | 481.5 ± 8.8% | 0.295 | 0.511 | 2.953 | 0.468 | 2.299 |
| string: canterbury/alice29.txt | 159425 | 718.2 ± 16.1% | 2396.3 ± 3.1% | 1892.2 ± 3.5% | 269.6 ± 0.8% | 1946.8 ± 2.0% | 455.7 ± 7.1% | 0.300 | 0.380 | 2.664 | 0.369 | 1.576 |
| string: canterbury/asyoulik.txt | 132198 | 606.9 ± 2.1% | 2145.8 ± 0.5% | 1488.1 ± 0.4% | 260.4 ± 0.4% | 1580.9 ± 1.1% | 408.0 ± 1.4% | 0.283 | 0.408 | 2.331 | 0.384 | 1.487 |
| string: canterbury/lcet10.txt | 441884 | 905.6 ± 4.3% | 2825.2 ± 1.0% | 2019.9 ± 1.8% | 311.5 ± 0.3% | 2125.6 ± 1.2% | 492.8 ± 2.1% | 0.321 | 0.448 | 2.907 | 0.426 | 1.838 |
| string: canterbury/plrabn12.txt | 503330 | 786.8 ± 4.3% | 2724.7 ± 1.6% | 1721.3 ± 0.4% | 282.2 ± 5.4% | 2010.8 ± 0.7% | 463.1 ± 0.7% | 0.289 | 0.457 | 2.788 | 0.391 | 1.699 |
| string: canterbury-large/E.coli | 1048578 | 18057.3 ± 0.7% | 7735.9 ± 1.1% | 3472.6 ± 1.2% | 800.4 ± 0.7% | 5527.4 ± 0.2% | 813.8 ± 1.1% | 2.334 | 5.200 | 22.561 | 3.267 | 22.188 |
| string: canterbury-large/bible.txt | 1055886 | 2621.1 ± 2.4% | 3921.2 ± 0.5% | 2637.9 ± 0.4% | 330.0 ± 7.2% | 2991.2 ± 1.0% | 606.6 ± 1.6% | 0.668 | 0.994 | 7.943 | 0.876 | 4.321 |
| string: canterbury-large/world192.txt | 1103121 | 640.7 ± 1.0% | 2010.9 ± 2.6% | 1667.3 ± 1.3% | 279.0 ± 4.1% | 1697.2 ± 3.3% | 436.8 ± 0.7% | 0.319 | 0.384 | 2.296 | 0.377 | 1.467 |
| string: http/html-1m | 1058582 | 2246.0 ± 1.8% | 3411.4 ± 0.6% | 2450.7 ± 1.2% | 372.5 ± 1.7% | 2736.6 ± 0.4% | 429.1 ± 1.0% | 0.658 | 0.916 | 6.030 | 0.821 | 5.234 |
| string: http/json-1m | 1190272 | 309.8 ± 1.5% | 1259.8 ± 0.3% | 1560.5 ± 7.0% | 310.0 ± 1.4% | 823.4 ± 0.9% | 294.6 ± 0.7% | 0.246 | 0.199 | 0.999 | 0.376 | 1.052 |
| string: http/js-1m | 1144362 | 391.8 ± 2.6% | 1349.0 ± 0.2% | 1181.5 ± 1.9% | 255.6 ± 1.1% | 1167.0 ± 0.6% | 297.8 ± 1.5% | 0.290 | 0.332 | 1.533 | 0.336 | 1.316 |
| string: http/css-1m | 1097820 | 649.2 ± 12.8% | 2559.0 ± 1.5% | 1556.2 ± 0.8% | 338.9 ± 0.4% | 1549.2 ± 1.8% | 339.1 ± 6.7% | 0.254 | 0.417 | 1.916 | 0.419 | 1.914 |
| string: dickens as Cyrillic and CJK | 1883069 | 942.5 ± 0.5% | 3218.9 ± 5.1% | 655.0 ± 2.9% | 243.1 ± 0.9% | 497.4 ± 0.6% | 138.5 ± 1.3% | 0.293 | 1.439 | 3.877 | 1.895 | 6.806 |
| string: dickens as Cyrillic and CJK, as \u escapes | 5075485 | 94.9 ± 0.3% | 1081.8 ± 1.5% | 821.7 ± 1.3% | 148.8 ± 0.8% | 384.2 ± 1.1% | 202.8 ± 5.3% | 0.088 | 0.116 | 0.638 | 0.247 | 0.468 |
| hex: silesia/dickens | 524290 | 18103.3 ± 0.8% | 7831.0 ± 0.3% | 3515.1 ± 6.7% | 424.0 ± 0.2% | 5534.9 ± 8.0% | 822.4 ± 2.4% | 2.312 | 5.150 | 42.698 | 3.271 | 22.012 |
| hex: silesia/mozilla | 524290 | 17988.3 ± 0.5% | 7831.8 ± 0.6% | 3493.8 ± 1.2% | 369.1 ± 14.7% | 5524.8 ± 0.3% | 825.4 ± 1.2% | 2.297 | 5.149 | 48.742 | 3.256 | 21.794 |
| hex: silesia/mr | 524290 | 17864.3 ± 0.8% | 7831.7 ± 0.5% | 3476.5 ± 2.8% | 518.2 ± 0.0% | 5527.3 ± 0.2% | 827.0 ± 2.3% | 2.281 | 5.139 | 34.477 | 3.232 | 21.602 |
| hex: silesia/nci | 524290 | 18018.8 ± 0.3% | 7817.7 ± 0.7% | 3505.9 ± 0.9% | 577.5 ± 0.3% | 5506.2 ± 0.2% | 826.3 ± 1.3% | 2.305 | 5.140 | 31.200 | 3.272 | 21.807 |
| hex: silesia/ooffice | 524290 | 17828.5 ± 11.3% | 7837.3 ± 0.5% | 3492.4 ± 0.5% | 320.2 ± 2.2% | 5516.9 ± 1.1% | 825.3 ± 2.4% | 2.275 | 5.105 | 55.676 | 3.232 | 21.602 |
| hex: silesia/osdb | 524290 | 17925.3 ± 11.8% | 7848.8 ± 0.2% | 3484.4 ± 0.7% | 406.7 ± 0.2% | 5508.2 ± 0.4% | 818.8 ± 1.1% | 2.284 | 5.144 | 44.072 | 3.254 | 21.891 |
| hex: silesia/reymont | 524290 | 18034.4 ± 11.1% | 7832.7 ± 1.3% | 3474.2 ± 0.4% | 435.4 ± 0.7% | 5541.0 ± 1.4% | 825.2 ± 0.5% | 2.302 | 5.191 | 41.421 | 3.255 | 21.854 |
| hex: silesia/samba | 524290 | 17922.5 ± 3.1% | 7832.8 ± 0.3% | 3488.3 ± 0.2% | 325.1 ± 12.3% | 5530.9 ± 1.3% | 824.4 ± 5.9% | 2.288 | 5.138 | 55.122 | 3.240 | 21.741 |
| hex: silesia/sao | 524290 | 18056.6 ± 0.7% | 7838.1 ± 0.4% | 3458.4 ± 2.1% | 263.3 ± 0.2% | 5520.1 ± 0.2% | 822.6 ± 1.2% | 2.304 | 5.221 | 68.584 | 3.271 | 21.951 |
| hex: silesia/webster | 524290 | 18113.8 ± 0.4% | 7822.4 ± 1.1% | 3493.0 ± 0.7% | 386.2 ± 0.2% | 5515.1 ± 0.2% | 822.4 ± 1.6% | 2.316 | 5.186 | 46.904 | 3.284 | 22.025 |
| hex: silesia/x-ray | 524290 | 17618.3 ± 1.1% | 7833.3 ± 1.0% | 3492.1 ± 0.3% | 386.2 ± 0.3% | 5535.4 ± 16.7% | 819.2 ± 0.6% | 2.249 | 5.045 | 45.622 | 3.183 | 21.507 |
| hex: silesia/xml | 524290 | 18068.0 ± 0.4% | 7824.1 ± 0.8% | 3500.7 ± 0.5% | 509.1 ± 0.5% | 5546.9 ± 1.2% | 826.0 ± 0.6% | 2.309 | 5.161 | 35.489 | 3.257 | 21.873 |
| hex: canterbury/alice29.txt | 304180 | 17763.2 ± 0.4% | 7814.2 ± 0.2% | 3592.1 ± 0.3% | 424.1 ± 0.2% | 5523.0 ± 0.6% | 826.3 ± 8.2% | 2.273 | 4.945 | 41.882 | 3.216 | 21.497 |
| hex: canterbury/asyoulik.txt | 250360 | 18178.3 ± 0.2% | 7801.8 ± 7.7% | 3570.4 ± 0.3% | 415.2 ± 0.6% | 5529.9 ± 0.2% | 831.8 ± 9.3% | 2.330 | 5.091 | 43.779 | 3.287 | 21.853 |
| hex: canterbury/cp.html | 49208 | 18402.6 ± 0.3% | 7806.0 ± 0.1% | 3612.8 ± 0.2% | 404.2 ± 0.2% | 5482.2 ± 1.1% | 807.3 ± 1.5% | 2.357 | 5.094 | 45.531 | 3.357 | 22.796 |
| hex: canterbury/fields.c | 22302 | 18072.4 ± 0.1% | 7713.8 ± 1.3% | 3602.3 ± 0.2% | 429.3 ± 0.2% | 5471.3 ± 1.6% | 794.4 ± 3.4% | 2.343 | 5.017 | 42.102 | 3.303 | 22.750 |
| hex: canterbury/grammar.lsp | 7444 | 16951.5 ± 0.6% | 7480.8 ± 0.4% | 3565.4 ± 8.3% | 482.8 ± 0.5% | 5367.7 ± 38.7% | 779.4 ± 1.2% | 2.266 | 4.754 | 35.110 | 3.158 | 21.749 |
| hex: canterbury/kennedy.xls | 524290 | 17953.3 ± 11.9% | 7796.3 ± 0.4% | 3490.0 ± 0.9% | 600.2 ± 1.0% | 5527.7 ± 0.2% | 817.8 ± 3.1% | 2.303 | 5.144 | 29.914 | 3.248 | 21.953 |
| hex: canterbury/lcet10.txt | 524290 | 18020.4 ± 2.5% | 7799.5 ± 3.2% | 3494.1 ± 0.8% | 426.8 ± 0.2% | 5521.6 ± 0.4% | 825.6 ± 7.8% | 2.310 | 5.157 | 42.225 | 3.264 | 21.828 |
| hex: canterbury/plrabn12.txt | 524290 | 17873.0 ± 0.7% | 7761.7 ± 1.0% | 3492.3 ± 0.9% | 414.7 ± 1.9% | 5499.1 ± 0.8% | 824.3 ± 6.7% | 2.303 | 5.118 | 43.094 | 3.250 | 21.682 |
| hex: canterbury/ptt5 | 524290 | 17956.2 ± 0.9% | 7797.3 ± 1.2% | 3494.9 ± 0.2% | 513.4 ± 1.5% | 5534.2 ± 10.4% | 825.7 ± 1.1% | 2.303 | 5.138 | 34.972 | 3.245 | 21.746 |
| hex: canterbury/sum | 76482 | 18575.4 ± 0.2% | 7819.4 ± 0.2% | 3624.7 ± 0.8% | 465.4 ± 0.7% | 5503.9 ± 0.6% | 826.8 ± 3.9% | 2.376 | 5.125 | 39.915 | 3.375 | 22.466 |
| hex: canterbury/xargs.1 | 8456 | 17351.2 ± 0.6% | 7525.3 ± 0.2% | 3551.1 ± 0.3% | 450.6 ± 0.7% | 5373.6 ± 1.1% | 814.5 ± 1.8% | 2.306 | 4.886 | 38.506 | 3.229 | 21.304 |
| hex: canterbury-large/E.coli | 524290 | 18145.3 ± 7.4% | 7794.3 ± 3.5% | 3477.8 ± 0.9% | 711.5 ± 2.8% | 5508.2 ± 0.3% | 812.2 ± 6.1% | 2.328 | 5.217 | 25.503 | 3.294 | 22.341 |
| hex: canterbury-large/bible.txt | 524290 | 17224.3 ± 0.6% | 7810.5 ± 2.4% | 3469.7 ± 1.2% | 438.5 ± 1.3% | 5522.9 ± 0.2% | 806.2 ± 3.5% | 2.205 | 4.964 | 39.277 | 3.119 | 21.365 |
| hex: canterbury-large/world192.txt | 524290 | 18037.3 ± 0.3% | 7797.8 ± 0.1% | 3481.9 ± 2.4% | 408.9 ± 2.2% | 5514.7 ± 17.0% | 813.5 ± 1.4% | 2.313 | 5.180 | 44.110 | 3.271 | 22.171 |
| hex: http/html-1kx1024 | 2099200 | 12282.8 ± 5.3% | 6668.6 ± 1.5% | 3213.1 ± 1.8% | 425.5 ± 0.2% | 4744.9 ± 0.7% | 718.0 ± 3.4% | 1.842 | 3.823 | 28.868 | 2.589 | 17.107 |
| hex: http/html-16kx64 | 2097280 | 17729.5 ± 1.1% | 7667.9 ± 0.3% | 3519.6 ± 1.0% | 431.3 ± 0.3% | 5434.4 ± 0.5% | 798.5 ± 3.9% | 2.312 | 5.037 | 41.111 | 3.262 | 22.204 |
| hex: http/html-1m | 524290 | 18041.0 ± 0.9% | 7759.8 ± 2.7% | 3482.6 ± 0.6% | 428.7 ± 1.2% | 5508.1 ± 0.2% | 814.2 ± 3.3% | 2.325 | 5.180 | 42.082 | 3.275 | 22.157 |
| hex: http/json-1kx1024 | 2099200 | 12223.5 ± 2.1% | 6663.7 ± 0.3% | 3201.8 ± 5.6% | 534.7 ± 6.3% | 4725.4 ± 1.1% | 708.6 ± 3.6% | 1.834 | 3.818 | 22.862 | 2.587 | 17.249 |
| hex: http/json-16kx64 | 2097280 | 17634.8 ± 0.8% | 7655.9 ± 0.1% | 3498.5 ± 1.3% | 544.7 ± 18.4% | 5420.8 ± 2.4% | 794.9 ± 7.5% | 2.303 | 5.041 | 32.377 | 3.253 | 22.185 |
| hex: http/json-1m | 524290 | 18026.7 ± 1.0% | 7784.7 ± 1.3% | 3488.8 ± 0.8% | 554.3 ± 0.2% | 5507.0 ± 0.9% | 793.6 ± 3.7% | 2.316 | 5.167 | 32.522 | 3.273 | 22.715 |
| hex: http/js-1kx1024 | 2099200 | 12192.8 ± 5.7% | 6658.8 ± 1.0% | 3215.6 ± 1.9% | 420.9 ± 0.3% | 4743.6 ± 0.8% | 718.6 ± 3.5% | 1.831 | 3.792 | 28.970 | 2.570 | 16.968 |
| hex: http/js-16kx64 | 2097280 | 17596.8 ± 3.8% | 7604.0 ± 12.6% | 3474.6 ± 7.3% | 423.0 ± 7.4% | 5399.8 ± 1.7% | 790.1 ± 11.6% | 2.314 | 5.064 | 41.601 | 3.259 | 22.271 |
| hex: http/js-1m | 524290 | 17838.4 ± 1.7% | 7699.7 ± 3.1% | 3459.6 ± 2.2% | 430.4 ± 1.9% | 5479.2 ± 2.2% | 790.2 ± 3.7% | 2.317 | 5.156 | 41.447 | 3.256 | 22.574 |
| hex: http/css-1kx1024 | 2099200 | 11873.4 ± 1.6% | 6649.6 ± 0.4% | 3228.6 ± 2.1% | 459.5 ± 14.1% | 4738.0 ± 1.1% | 734.0 ± 2.8% | 1.786 | 3.678 | 25.838 | 2.506 | 16.177 |
| hex: http/css-16kx64 | 2097280 | 17454.4 ± 0.9% | 7655.9 ± 1.0% | 3494.1 ± 6.6% | 466.5 ± 0.1% | 5432.4 ± 0.3% | 797.4 ± 1.4% | 2.280 | 4.995 | 37.419 | 3.213 | 21.890 |
| hex: http/css-1m | 524290 | 17805.3 ± 0.8% | 7818.5 ± 0.3% | 3488.0 ± 1.5% | 455.1 ± 0.7% | 5514.9 ± 2.5% | 805.9 ± 6.5% | 2.277 | 5.105 | 39.121 | 3.229 | 22.094 |
| hex: shuffled/dickens-1m | 524290 | 17819.5 ± 3.7% | 7776.4 ± 0.5% | 3480.0 ± 1.1% | 423.7 ± 1.1% | 5538.9 ± 0.1% | 818.6 ± 0.9% | 2.291 | 5.121 | 42.055 | 3.217 | 21.769 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 971.4 ± 1.4% | 1089.7 ± 2.7% | 872.4 ± 0.8% | 330.5 ± 1.0% | 365.2 ± 1.2% | 314.0 ± 1.1% | 0.891 | 1.113 | 2.939 | 2.659 | 3.093 |
| qlog records, JSON text sequence | 1467503 | 803.3 ± 1.0% | 851.2 ± 1.2% | 701.6 ± 1.4% | 319.7 ± 4.6% | 382.8 ± 2.1% | 231.1 ± 2.0% | 0.944 | 1.145 | 2.513 | 2.098 | 3.476 |
| string: silesia/dickens | 172528 | 8942.9 ± 1.8% | 3119.8 ± 0.5% | 2026.4 ± 0.8% | 363.1 ± 0.6% | 1405.9 ± 1.5% | 560.6 ± 0.3% | 2.867 | 4.413 | 24.629 | 6.361 | 15.952 |
| string: silesia/nci | 1075110 | 8678.1 ± 0.6% | 3167.0 ± 0.3% | 2831.0 ± 1.5% | 776.6 ± 1.1% | 1534.7 ± 0.9% | 565.1 ± 0.9% | 2.740 | 3.065 | 11.175 | 5.655 | 15.356 |
| string: silesia/reymont | 1075159 | 3827.9 ± 0.4% | 1594.9 ± 0.2% | 1736.2 ± 0.3% | 373.8 ± 0.3% | 1237.6 ± 1.7% | 553.0 ± 0.5% | 2.400 | 2.205 | 10.240 | 3.093 | 6.922 |
| string: silesia/samba | 97582 | 4653.1 ± 2.0% | 2027.6 ± 0.2% | 2175.6 ± 0.5% | 300.5 ± 1.8% | 1065.5 ± 1.4% | 620.3 ± 0.4% | 2.295 | 2.139 | 15.483 | 4.367 | 7.502 |
| string: silesia/webster | 1098490 | 5106.9 ± 0.4% | 1631.1 ± 0.5% | 1535.0 ± 0.5% | 361.1 ± 12.6% | 1196.5 ± 1.7% | 456.1 ± 9.7% | 3.131 | 3.327 | 14.144 | 4.268 | 11.197 |
| string: silesia/xml | 1090118 | 8084.3 ± 0.3% | 2757.6 ± 0.9% | 2177.1 ± 0.3% | 532.3 ± 2.2% | 1578.3 ± 0.3% | 563.1 ± 8.5% | 2.932 | 3.713 | 15.188 | 5.122 | 14.356 |
| string: canterbury/alice29.txt | 159425 | 9645.0 ± 0.5% | 2591.9 ± 2.9% | 1759.5 ± 0.9% | 340.7 ± 0.3% | 1255.6 ± 1.3% | 555.7 ± 0.4% | 3.721 | 5.482 | 28.305 | 7.682 | 17.355 |
| string: canterbury/asyoulik.txt | 132198 | 8118.4 ± 1.3% | 2232.5 ± 1.0% | 1508.2 ± 1.3% | 346.5 ± 2.0% | 1116.1 ± 1.2% | 541.7 ± 0.6% | 3.636 | 5.383 | 23.432 | 7.274 | 14.986 |
| string: canterbury/lcet10.txt | 441884 | 8962.1 ± 0.6% | 2462.6 ± 7.0% | 1992.9 ± 0.7% | 396.9 ± 0.5% | 1382.1 ± 1.0% | 554.0 ± 0.8% | 3.639 | 4.497 | 22.582 | 6.484 | 16.177 |
| string: canterbury/plrabn12.txt | 503330 | 6060.5 ± 0.5% | 1801.1 ± 0.4% | 1682.2 ± 0.2% | 368.2 ± 1.5% | 1282.0 ± 2.0% | 558.0 ± 0.4% | 3.365 | 3.603 | 16.460 | 4.727 | 10.862 |
| string: canterbury-large/E.coli | 1048578 | 38968.8 ± 0.8% | 19239.4 ± 0.5% | 3389.8 ± 0.3% | 1422.1 ± 0.6% | 2526.7 ± 2.8% | 578.2 ± 1.3% | 2.025 | 11.496 | 27.402 | 15.423 | 67.401 |
| string: canterbury-large/bible.txt | 1055886 | 7038.6 ± 0.9% | 3962.2 ± 0.6% | 2667.6 ± 1.1% | 441.9 ± 0.8% | 1866.6 ± 0.4% | 567.5 ± 0.5% | 1.776 | 2.639 | 15.928 | 3.771 | 12.403 |
| string: canterbury-large/world192.txt | 1103121 | 4873.6 ± 3.7% | 1429.7 ± 1.0% | 1631.1 ± 0.3% | 366.5 ± 1.6% | 1169.9 ± 0.5% | 540.2 ± 1.0% | 3.409 | 2.988 | 13.298 | 4.166 | 9.021 |
| string: http/html-1m | 1058582 | 8538.6 ± 0.6% | 3892.1 ± 1.7% | 2486.1 ± 0.9% | 444.3 ± 0.9% | 1814.8 ± 15.9% | 523.3 ± 0.6% | 2.194 | 3.435 | 19.218 | 4.705 | 16.317 |
| string: http/json-1m | 1190272 | 6681.4 ± 0.5% | 1205.4 ± 1.6% | 1327.3 ± 1.6% | 416.2 ± 1.6% | 890.8 ± 1.9% | 511.4 ± 0.7% | 5.543 | 5.034 | 16.053 | 7.501 | 13.066 |
| string: http/js-1m | 1144362 | 5098.4 ± 0.6% | 989.9 ± 1.7% | 1065.9 ± 0.3% | 306.8 ± 2.0% | 908.1 ± 2.9% | 474.4 ± 0.7% | 5.150 | 4.783 | 16.617 | 5.614 | 10.748 |
| string: http/css-1m | 1097820 | 6889.0 ± 1.8% | 1254.9 ± 0.5% | 1630.4 ± 0.5% | 439.1 ± 1.3% | 1039.3 ± 11.8% | 531.0 ± 0.6% | 5.490 | 4.225 | 15.690 | 6.629 | 12.974 |
| string: dickens as Cyrillic and CJK | 1883069 | 5345.6 ± 0.6% | 3105.3 ± 0.4% | 361.4 ± 28.6% | 275.4 ± 0.2% | 462.0 ± 2.0% | 293.1 ± 0.9% | 1.721 | 14.791 | 19.408 | 11.569 | 18.239 |
| hex: silesia/dickens | 524290 | 31753.1 ± 1.0% | 1543.4 ± 2.0% | 1086.6 ± 0.5% | 427.7 ± 1.2% | 1045.9 ± 13.1% | 449.4 ± 0.5% | 20.573 | 29.223 | 74.233 | 30.361 | 70.660 |
| hex: silesia/mozilla | 524290 | 36457.9 ± 2.1% | 1552.4 ± 0.5% | 1088.8 ± 0.5% | 371.7 ± 0.6% | 1053.3 ± 0.6% | 449.7 ± 0.8% | 23.485 | 33.485 | 98.089 | 34.614 | 81.073 |
| hex: silesia/mr | 524290 | 34851.9 ± 0.6% | 1546.2 ± 1.2% | 1089.7 ± 0.8% | 509.5 ± 10.1% | 1047.0 ± 16.3% | 450.2 ± 0.7% | 22.540 | 31.984 | 68.407 | 33.287 | 77.419 |
| hex: silesia/nci | 524290 | 34363.4 ± 1.1% | 1551.8 ± 4.3% | 1088.2 ± 0.4% | 584.0 ± 1.1% | 1057.0 ± 0.5% | 450.8 ± 0.4% | 22.144 | 31.578 | 58.839 | 32.510 | 76.229 |
| hex: silesia/ooffice | 524290 | 34865.5 ± 0.9% | 1549.4 ± 1.4% | 1085.6 ± 4.8% | 328.3 ± 0.2% | 1049.0 ± 0.5% | 449.3 ± 0.8% | 22.503 | 32.116 | 106.205 | 33.237 | 77.595 |
| hex: silesia/osdb | 524290 | 35157.7 ± 3.1% | 1552.6 ± 0.6% | 1088.4 ± 1.0% | 417.1 ± 0.2% | 1052.8 ± 17.4% | 448.8 ± 6.5% | 22.644 | 32.303 | 84.296 | 33.395 | 78.344 |
| hex: silesia/reymont | 524290 | 33760.7 ± 0.5% | 1553.5 ± 1.1% | 1090.7 ± 2.0% | 445.4 ± 0.2% | 1047.4 ± 10.1% | 449.6 ± 0.2% | 21.732 | 30.955 | 75.793 | 32.232 | 75.094 |
| hex: silesia/samba | 524290 | 33687.7 ± 0.8% | 1550.4 ± 0.6% | 1086.0 ± 0.6% | 334.1 ± 7.0% | 1054.7 ± 0.5% | 449.5 ± 0.5% | 21.729 | 31.020 | 100.836 | 31.942 | 74.941 |
| hex: silesia/sao | 524290 | 34159.7 ± 1.1% | 1547.9 ± 2.8% | 1088.2 ± 0.6% | 268.3 ± 0.2% | 1048.8 ± 0.5% | 449.2 ± 0.9% | 22.068 | 31.390 | 127.301 | 32.570 | 76.041 |
| hex: silesia/webster | 524290 | 37224.7 ± 2.7% | 1549.5 ± 4.8% | 1088.6 ± 0.7% | 408.6 ± 0.7% | 1056.7 ± 0.4% | 450.4 ± 1.4% | 24.024 | 34.196 | 91.101 | 35.227 | 82.654 |
| hex: silesia/x-ray | 524290 | 34544.8 ± 1.1% | 1550.0 ± 0.6% | 1087.8 ± 0.1% | 397.7 ± 0.9% | 1048.4 ± 0.1% | 449.3 ± 1.1% | 22.287 | 31.758 | 86.859 | 32.951 | 76.878 |
| hex: silesia/xml | 524290 | 34474.8 ± 1.0% | 1548.0 ± 0.6% | 1087.6 ± 0.7% | 585.2 ± 0.4% | 1056.5 ± 0.7% | 448.3 ± 0.7% | 22.271 | 31.699 | 58.916 | 32.631 | 76.897 |
| hex: canterbury/alice29.txt | 304180 | 35719.3 ± 1.1% | 1588.8 ± 0.7% | 1099.5 ± 0.3% | 430.9 ± 1.1% | 1073.0 ± 0.7% | 451.5 ± 1.6% | 22.483 | 32.488 | 82.896 | 33.290 | 79.106 |
| hex: canterbury/asyoulik.txt | 250360 | 31368.7 ± 1.7% | 1595.7 ± 0.7% | 1097.3 ± 0.7% | 423.7 ± 0.7% | 1075.1 ± 0.8% | 454.0 ± 1.5% | 19.658 | 28.586 | 74.033 | 29.178 | 69.094 |
| hex: canterbury/cp.html | 49208 | 31807.8 ± 0.4% | 1620.9 ± 1.7% | 1112.5 ± 0.1% | 465.9 ± 0.6% | 1073.6 ± 0.5% | 455.5 ± 1.1% | 19.624 | 28.592 | 68.270 | 29.628 | 69.828 |
| hex: canterbury/fields.c | 22302 | 33425.6 ± 0.5% | 1594.9 ± 0.6% | 1100.1 ± 0.2% | 541.5 ± 0.8% | 1059.9 ± 1.4% | 455.5 ± 0.8% | 20.958 | 30.384 | 61.726 | 31.535 | 73.389 |
| hex: canterbury/grammar.lsp | 7444 | 32074.9 ± 1.4% | 1631.7 ± 1.8% | 1113.8 ± 2.4% | 564.4 ± 0.5% | 1081.3 ± 1.5% | 461.9 ± 0.6% | 19.658 | 28.796 | 56.828 | 29.663 | 69.434 |
| hex: canterbury/kennedy.xls | 524290 | 31084.0 ± 0.9% | 1546.5 ± 1.4% | 1086.8 ± 1.9% | 594.1 ± 0.8% | 1049.0 ± 0.5% | 450.7 ± 3.6% | 20.100 | 28.600 | 52.322 | 29.632 | 68.972 |
| hex: canterbury/lcet10.txt | 524290 | 33747.2 ± 1.2% | 1567.3 ± 1.2% | 1091.3 ± 0.7% | 431.6 ± 0.7% | 1054.0 ± 0.8% | 450.4 ± 0.4% | 21.532 | 30.924 | 78.182 | 32.019 | 74.935 |
| hex: canterbury/plrabn12.txt | 524290 | 33345.0 ± 2.5% | 1555.9 ± 2.3% | 1090.8 ± 0.4% | 419.8 ± 0.3% | 1052.1 ± 0.7% | 449.8 ± 1.0% | 21.431 | 30.569 | 79.424 | 31.693 | 74.141 |
| hex: canterbury/ptt5 | 524290 | 33509.0 ± 2.2% | 1557.7 ± 0.8% | 1091.2 ± 0.5% | 501.5 ± 1.3% | 1051.6 ± 0.8% | 450.4 ± 0.5% | 21.512 | 30.707 | 66.819 | 31.865 | 74.392 |
| hex: canterbury/sum | 76482 | 35273.3 ± 0.6% | 1616.0 ± 0.2% | 1109.6 ± 0.2% | 522.5 ± 0.4% | 1065.7 ± 2.7% | 458.9 ± 1.0% | 21.827 | 31.790 | 67.514 | 33.097 | 76.866 |
| hex: canterbury/xargs.1 | 8456 | 35756.5 ± 0.4% | 1628.1 ± 0.9% | 1111.7 ± 10.6% | 598.7 ± 0.4% | 1077.9 ± 1.2% | 462.1 ± 0.3% | 21.962 | 32.163 | 59.721 | 33.173 | 77.386 |
| hex: canterbury-large/E.coli | 524290 | 30877.5 ± 0.2% | 1538.6 ± 0.5% | 1083.6 ± 1.6% | 605.8 ± 0.4% | 1044.4 ± 1.3% | 449.7 ± 1.1% | 20.069 | 28.497 | 50.970 | 29.566 | 68.657 |
| hex: canterbury-large/bible.txt | 524290 | 35647.0 ± 1.9% | 1558.0 ± 1.7% | 1091.7 ± 0.5% | 442.7 ± 2.4% | 1055.0 ± 0.7% | 450.2 ± 1.3% | 22.880 | 32.652 | 80.520 | 33.789 | 79.178 |
| hex: canterbury-large/world192.txt | 524290 | 35500.5 ± 0.4% | 1556.6 ± 1.5% | 1089.8 ± 0.5% | 422.6 ± 0.3% | 1057.9 ± 2.6% | 450.7 ± 0.8% | 22.807 | 32.577 | 84.008 | 33.558 | 78.771 |
| hex: http/html-1kx1024 | 2099200 | 25294.2 ± 0.5% | 1600.1 ± 0.5% | 1088.4 ± 0.3% | 458.5 ± 1.6% | 1065.5 ± 1.4% | 452.6 ± 0.6% | 15.808 | 23.240 | 55.163 | 23.740 | 55.882 |
| hex: http/html-16kx64 | 2097280 | 30519.7 ± 1.7% | 1608.7 ± 0.1% | 1103.7 ± 0.2% | 463.1 ± 1.1% | 1059.1 ± 1.1% | 456.8 ± 0.6% | 18.972 | 27.653 | 65.902 | 28.818 | 66.811 |
| hex: http/html-1m | 524290 | 29335.8 ± 0.2% | 1552.6 ± 3.1% | 1088.6 ± 0.4% | 447.0 ± 0.4% | 1036.8 ± 2.8% | 448.5 ± 0.3% | 18.894 | 26.947 | 65.627 | 28.295 | 65.408 |
| hex: http/json-1kx1024 | 2099200 | 25228.6 ± 0.4% | 1604.7 ± 0.2% | 1088.7 ± 0.4% | 565.6 ± 15.4% | 1052.9 ± 1.9% | 452.4 ± 5.2% | 15.722 | 23.174 | 44.604 | 23.961 | 55.771 |
| hex: http/json-16kx64 | 2097280 | 30734.5 ± 0.5% | 1611.4 ± 7.7% | 1105.4 ± 0.1% | 571.5 ± 0.8% | 1025.5 ± 1.0% | 457.2 ± 0.1% | 19.073 | 27.805 | 53.781 | 29.972 | 67.218 |
| hex: http/json-1m | 524290 | 31753.7 ± 2.0% | 1544.8 ± 1.7% | 1088.9 ± 0.9% | 587.1 ± 0.7% | 1028.2 ± 1.6% | 450.2 ± 0.6% | 20.556 | 29.160 | 54.085 | 30.884 | 70.533 |
| hex: http/js-1kx1024 | 2099200 | 25200.5 ± 0.4% | 1605.7 ± 0.2% | 1089.6 ± 0.2% | 445.0 ± 0.6% | 1066.9 ± 2.2% | 452.2 ± 0.6% | 15.694 | 23.128 | 56.629 | 23.621 | 55.725 |
| hex: http/js-16kx64 | 2097280 | 30451.1 ± 4.2% | 1605.1 ± 0.9% | 1101.9 ± 0.6% | 440.3 ± 0.1% | 1010.7 ± 1.0% | 456.7 ± 0.1% | 18.971 | 27.635 | 69.155 | 30.128 | 66.683 |
| hex: http/js-1m | 524290 | 30955.8 ± 0.8% | 1541.5 ± 37.0% | 1087.6 ± 1.2% | 451.1 ± 11.1% | 1032.1 ± 0.5% | 449.5 ± 0.5% | 20.082 | 28.461 | 68.628 | 29.994 | 68.873 |
| hex: http/css-1kx1024 | 2099200 | 25035.8 ± 1.4% | 1603.5 ± 0.9% | 1086.0 ± 0.4% | 500.6 ± 0.7% | 1060.3 ± 2.2% | 452.8 ± 0.7% | 15.613 | 23.054 | 50.010 | 23.612 | 55.295 |
| hex: http/css-16kx64 | 2097280 | 30714.3 ± 0.4% | 1608.7 ± 0.2% | 1104.2 ± 0.2% | 507.5 ± 0.8% | 1059.8 ± 4.3% | 456.1 ± 1.5% | 19.092 | 27.815 | 60.517 | 28.982 | 67.340 |
| hex: http/css-1m | 524290 | 31392.0 ± 0.8% | 1552.1 ± 0.4% | 1085.6 ± 0.8% | 485.5 ± 0.3% | 1041.1 ± 0.7% | 448.6 ± 0.4% | 20.226 | 28.916 | 64.663 | 30.152 | 69.976 |
| hex: shuffled/dickens-1m | 524290 | 35303.4 ± 0.8% | 1550.1 ± 0.9% | 1087.7 ± 0.8% | 425.7 ± 0.2% | 1029.7 ± 1.1% | 451.8 ± 1.0% | 22.775 | 32.457 | 82.923 | 34.286 | 78.147 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.720 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.775 of yyjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.685 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.687 of yyjson.
- string: silesia/dickens, decoding through TextReader.next: stdx runs at 0.327 of simdjson.
- string: silesia/dickens, decoding through TextReader.next: stdx runs at 0.464 of yyjson.
- string: silesia/dickens, decoding through TextReader.next: stdx runs at 0.441 of serde_json.
- string: silesia/nci, decoding through TextReader.next: stdx runs at 0.335 of simdjson.
- string: silesia/nci, decoding through TextReader.next: stdx runs at 0.420 of yyjson.
- string: silesia/nci, decoding through TextReader.next: stdx runs at 0.493 of serde_json.
- string: silesia/reymont, decoding through TextReader.next: stdx runs at 0.423 of simdjson.
- string: silesia/reymont, decoding through TextReader.next: stdx runs at 0.506 of yyjson.
- string: silesia/reymont, decoding through TextReader.next: stdx runs at 0.566 of serde_json.
- string: silesia/samba, decoding through TextReader.next: stdx runs at 0.076 of simdjson.
- string: silesia/samba, decoding through TextReader.next: stdx runs at 0.130 of yyjson.
- string: silesia/samba, decoding through TextReader.next: stdx runs at 0.911 of std.json.
- string: silesia/samba, decoding through TextReader.next: stdx runs at 0.172 of serde_json.
- string: silesia/samba, decoding through TextReader.next: stdx runs at 0.617 of Go jsontext.
- string: silesia/webster, decoding through TextReader.next: stdx runs at 0.347 of simdjson.
- string: silesia/webster, decoding through TextReader.next: stdx runs at 0.422 of yyjson.
- string: silesia/webster, decoding through TextReader.next: stdx runs at 0.423 of serde_json.
- string: silesia/xml, decoding through TextReader.next: stdx runs at 0.295 of simdjson.
- string: silesia/xml, decoding through TextReader.next: stdx runs at 0.511 of yyjson.
- string: silesia/xml, decoding through TextReader.next: stdx runs at 0.468 of serde_json.
- string: canterbury/alice29.txt, decoding through TextReader.next: stdx runs at 0.300 of simdjson.
- string: canterbury/alice29.txt, decoding through TextReader.next: stdx runs at 0.380 of yyjson.
- string: canterbury/alice29.txt, decoding through TextReader.next: stdx runs at 0.369 of serde_json.
- string: canterbury/asyoulik.txt, decoding through TextReader.next: stdx runs at 0.283 of simdjson.
- string: canterbury/asyoulik.txt, decoding through TextReader.next: stdx runs at 0.408 of yyjson.
- string: canterbury/asyoulik.txt, decoding through TextReader.next: stdx runs at 0.384 of serde_json.
- string: canterbury/lcet10.txt, decoding through TextReader.next: stdx runs at 0.321 of simdjson.
- string: canterbury/lcet10.txt, decoding through TextReader.next: stdx runs at 0.448 of yyjson.
- string: canterbury/lcet10.txt, decoding through TextReader.next: stdx runs at 0.426 of serde_json.
- string: canterbury/plrabn12.txt, decoding through TextReader.next: stdx runs at 0.289 of simdjson.
- string: canterbury/plrabn12.txt, decoding through TextReader.next: stdx runs at 0.457 of yyjson.
- string: canterbury/plrabn12.txt, decoding through TextReader.next: stdx runs at 0.391 of serde_json.
- string: canterbury-large/bible.txt, decoding through TextReader.next: stdx runs at 0.668 of simdjson.
- string: canterbury-large/bible.txt, decoding through TextReader.next: stdx runs at 0.876 of serde_json.
- string: canterbury-large/world192.txt, decoding through TextReader.next: stdx runs at 0.319 of simdjson.
- string: canterbury-large/world192.txt, decoding through TextReader.next: stdx runs at 0.384 of yyjson.
- string: canterbury-large/world192.txt, decoding through TextReader.next: stdx runs at 0.377 of serde_json.
- string: http/html-1m, decoding through TextReader.next: stdx runs at 0.658 of simdjson.
- string: http/html-1m, decoding through TextReader.next: stdx runs at 0.916 of yyjson.
- string: http/html-1m, decoding through TextReader.next: stdx runs at 0.821 of serde_json.
- string: http/json-1m, decoding through TextReader.next: stdx runs at 0.246 of simdjson.
- string: http/json-1m, decoding through TextReader.next: stdx runs at 0.199 of yyjson.
- string: http/json-1m, decoding through TextReader.next: stdx runs at 0.376 of serde_json.
- string: http/js-1m, decoding through TextReader.next: stdx runs at 0.290 of simdjson.
- string: http/js-1m, decoding through TextReader.next: stdx runs at 0.332 of yyjson.
- string: http/js-1m, decoding through TextReader.next: stdx runs at 0.336 of serde_json.
- string: http/css-1m, decoding through TextReader.next: stdx runs at 0.254 of simdjson.
- string: http/css-1m, decoding through TextReader.next: stdx runs at 0.417 of yyjson.
- string: http/css-1m, decoding through TextReader.next: stdx runs at 0.419 of serde_json.
- string: dickens as Cyrillic and CJK, decoding through TextReader.next: stdx runs at 0.293 of simdjson.
- string: dickens as Cyrillic and CJK, as \u escapes, decoding through TextReader.next: stdx runs at 0.088 of simdjson.
- string: dickens as Cyrillic and CJK, as \u escapes, decoding through TextReader.next: stdx runs at 0.116 of yyjson.
- string: dickens as Cyrillic and CJK, as \u escapes, decoding through TextReader.next: stdx runs at 0.638 of std.json.
- string: dickens as Cyrillic and CJK, as \u escapes, decoding through TextReader.next: stdx runs at 0.247 of serde_json.
- string: dickens as Cyrillic and CJK, as \u escapes, decoding through TextReader.next: stdx runs at 0.468 of Go jsontext.
- CLDR supplemental, 34 texts, encoding through TextWriter's methods: stdx runs at 0.891 of simdjson.
- qlog records, JSON text sequence, encoding through TextWriter's methods: stdx runs at 0.944 of simdjson.
