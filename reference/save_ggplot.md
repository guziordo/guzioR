# Simultaneous GGPlot Save as PDF, PNG, SVG

This function saves the specified plots built using ggplot2 as png, pdf,
and svg files. You can specify subfolders for each data subset or store
plots however you want in the plot directory.

## Usage

``` r
save_ggplot(
  filename,
  plot = last_plot(),
  path = paste0(getwd(), "/plots"),
  pdf = TRUE,
  svg = TRUE,
  png = TRUE,
  height = NA,
  width = NA
)
```

## Arguments

- filename:

  What you want the saved plot to be named

- plot:

  Name of the plot object to be saved

- path:

  Path to the designated plot folder. These is where subfolders will be
  built for each plot file type.

- pdf:

  Boolean. Whether to save plot as a pdf.

- svg:

  Boolean. Whether to save plot as a svg.

- png:

  Boolean. Whether to save plot as a png.

- height:

  Plot height

- width:

  Plot width
