
# guzioR

A compilation of various commands and tools I’ve used that may be
helpful. This package will not be routinely updated or maintained, but
I’ll add things as they come up.

## Installation

Install the development version from [GitHub](github.com) using the
following:

    # install.packages("devtools")
    devtools::install_github("guziordo/guzioR")

## Usage

``` r
library(guzioR)
```

## Included Functions

<b>quick.boxplot</b> <br> Just as is sounds, it’s a quick and easy way
to generate a box plot with points and statistics (if wanted).

## Included Palettes

These are compilations of palettes provided by friends or otherwise
generated for fun.

<img src="man/figures/README-unnamed-chunk-3-1.png" width="100%" />

<i>Thank you Lydia-Ann Ghuneim, Ph.D. for providing the CPCOLS
palette.</i>

### Big 10 Palettes

I don’t own any of the rights to things from the Big 10. These are some
palettes generated based on their brand identities. First two colors in
each are the primary colors of that school.

<img src="man/figures/README-unnamed-chunk-4-1.png" width="100%" />

Each can be subset based on what groups are wanted. Thanks to [Michael
McCarthy](https://github.com/mccarthy-m-g) for the easy explanation of
how to do this, which has been modified below.

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
