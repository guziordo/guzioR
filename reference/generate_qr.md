# QR Code Generation

Generates a QR code for a given website URL and saves it as an SVG file.

## Usage

``` r
generate_qr(site, filename, path = paste0(getwd(), "/plots/svg"), show = FALSE)
```

## Arguments

- site:

  URL of the website to generate the QR code for.

- filename:

  Name of the saved SVG file containing the QR code. Do not include
  ".svg" in the name.

- path:

  Path where the QR SVG should be saved. Defaults to a "svg"
  sub-directory within the "plots" directory.

- show:

  Determines if the generated SVG is immediately opened. Defaults to
  FALSE.
