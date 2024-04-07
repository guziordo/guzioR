# guzior 0.1.3
-   Removed `cb.pal.rda` from `/data` to resolve error with R-CMD-check.
-   Changed title for clarity.
-   Added index for other packages I've found helpful.

# guzioR 0.1.2

-   `qr.gen()` renamed to `generate.qr()` to avoid S3 method warning and no longer defaults to displaying the generated svg.
-   `cp.cols`, `three.col` moved to `guzior.pal` since they're not designed purposely to be colorblind friendly.
-   `paired6.col` added to the palette group `guzior.pal`, includes light/dark pairs of colors for differentiating within a set grouping variable. 
-   `cb.pal` removed so as not to reinvent the wheel. There are several packages available that include colorblind-friendly palettes, such as the [`viridis`](<https://cran.r-project.org/web/packages/viridis/vignettes/intro-to-viridis.html>) package.

# guzioR 0.1.1

-   Created guzioR hex.
-   Added `quick.boxplot()` function.
-   `cb.pal` used for colorblind friendly palettes instead of `guzior.pal`.

# guzioR 0.1.0

-   Initial commit.
