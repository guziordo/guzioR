# Generate MS2 Mirror Plot

This function is used to generate an MS2 mirror plot between two
spectra, with the option to highlight reference peaks from a third
spectrum.

## Usage

``` r
plot_ms2_mirror(
  ms2.top,
  ms2.top.id,
  ms2.bot,
  ms2.bot.id,
  ms2.metadata,
  ppm.tolerance = -1,
  da.tolerance = -1,
  add.ref = FALSE,
  ms2.ref = NULL,
  ms2.ref.id = NULL
)
```

## Arguments

- ms2.top:

  Dataframe or matrix containing two columns, `mz` and `intensity`, for
  the top spectrum to be plotted.

- ms2.top.id:

  Numeric MS2 scan identifier for MS2 peaks on the top of the plot.

- ms2.bot:

  Dataframe or matrix containing two columns, `mz` and `intensity`, for
  the bottom spectrum to be plotted.

- ms2.bot.id:

  Numeric MS2 scan identifier for MS2 peaks on the bottom of the plot.

- ms2.metadata:

  Dataframe containing metabolite information including scan.id, name,
  rt.

- ppm.tolerance:

  Numeric, determines what m/z tolerance will be used in spectral
  cleaning. Default is -1.

- da.tolerance:

  Numeric, determines what m/z tolerance will be used in spectral
  cleaning. Default is -1.

- add.ref:

  Boolean, indicates if a third MS2 spectrum is provided for identifying
  matched peaks present in ms2.top or ms2.bot m/z values. Default is
  FALSE.

- ms2.ref:

  Dataframe or matrix containing two columns, `mz` and `intensity`, for
  the MS2 spectrum to be used as a third reference. Default is NULL.

- ms2.ref.id:

  Numeric MS2 scan identifier for reference MS2 peaks. Default is NULL.

## Value

A ggplot object containing the MS2 mirror plot.

## Details

Note: MS2 spectral cleaning is done by msentropy::clean_spectrum().
Therefore, either provide ppm.tolerance or da.tolerance, not both.
