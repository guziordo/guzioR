# Planned Work
-   None

# guzioR 0.2.1

-   Fixing R-CMD and pkgdown errors.
-   Renamed functions to use "_" instead of periods in their names.

# guzioR 0.2.0

-   Added `generate_eic_ms2()` for simultaneous extracted ion chromatograph and single MS^2^ spectrum plotting. Retention time is appended to the filename to control for when multiple peaks are detected for a given mass, with multiple MS^2^ spectra collected.
-   Added `save_pheatmap()` code from Matt Whitaker, modified to default to saving a png file if pdf is not specified in the filename.

# guzioR 0.1.3

-   Removed `cb.pal.rda` from `/data` to resolve error with R-CMD-check.
-   Changed title for clarity.

# guzioR 0.1.2

-   `qr.gen()` renamed to `generate.qr()` to avoid S3 method warning and no longer defaults to displaying the generated svg.
-   `cp.cols`, `three.col` moved to `guzior.pal` since they're not designed purposely to be colorblind friendly.
-   `paired6.col` added to the palette group `guzior.pal`, includes light/dark pairs of colors for differentiating within a set grouping variable.
-   `cb.pal` removed so as not to reinvent the wheel. There are several packages available that include colorblind-friendly palettes, such as the [`viridis`](https://cran.r-project.org/web/packages/viridis/vignettes/intro-to-viridis.html) package.

# guzioR 0.1.1

-   Created guzioR hex.
-   Added `quick.boxplot()` function.
-   `cb.pal` used for colorblind friendly palettes instead of `guzior.pal`.

# guzioR 0.1.0

-   Initial commit.
