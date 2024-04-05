
# guzioR <a href='https://guziordo.github.io/guzioR/'><img src='man/figures/logo.png' align="right" height="139"/></a>

<!-- badges: start -->

[![License:
CC0-1.0](https://img.shields.io/badge/License-CC0%201.0-blue.svg)](https://creativecommons.org/publicdomain/zero/1.0/?ref=chooser-v1)
[![test-coverage](https://github.com/guziordo/guzioR/actions/workflows/test-coverage.yaml/badge.svg)](https://github.com/guziordo/guzioR/actions/workflows/test-coverage.yaml)
[![R-CMD-check](https://github.com/guziordo/guzioR/actions/workflows/R-CMD-check.yml/badge.svg)](https://github.com/guziordo/guzioR/actions/workflows/R-CMD-check.yml)
<!-- badges: end -->

A compilation of various commands and tools I’ve used that may be
helpful. This package will not be routinely updated, but I’ll add things
as they come up.

## Installation

Install the development version from [GitHub](github.com) using the
following:

``` r
# install.packages("devtools")
devtools::install_github("guziordo/guzioR")
```

## Usage

``` r
library(guzioR)
```

## Included Palettes

These are compilations of palettes provided by friends or otherwise
generated for fun.

<img src="man/figures/README-unnamed-chunk-3-1.png" width="100%" />

<i>Thank you to [Dr. Lydia-Ann
Ghuneim](https://www.linkedin.com/in/lydia-ann-ghuneim/) for providing
the CPCOLS palette.</i>

### Big 10 Palettes

I don’t own any of the rights to things from the Big 10. These are some
palettes generated based on their brand identities. First two colors in
each are the primary colors of that school.

<img src="man/figures/README-unnamed-chunk-4-1.png" width="100%" />

### Selecting Palettes

Each can be subset based on what groups are wanted. Thanks to [Michael
McCarthy](https://github.com/mccarthy-m-g) for the original text
description, which has been modified below.

- For a single palette:

``` r
b10.pal$buckeye
#> <palettes_colour[4]>
#> • #BA0C2F
#> • #A7B1B7
#> • #FFFFFF
#> • #000000
```

- For a multiple palettes:

``` r
b10.pal[c("buckeye","spartan")]
#> <palettes_palette[2]>
#> $buckeye
#> <palettes_colour[4]>
#> • #BA0C2F
#> • #A7B1B7
#> • #FFFFFF
#> • #000000
#> 
#> $spartan
#> <palettes_colour[8]>
#> • #18453B
#> • #FFFFFF
#> • #000000
#> • #4D4D4D
#> • #008208
#> • #7BBD00
#> • #0B9A6D
#> • #008934
```
