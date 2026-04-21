# EIC and MS2 Plotting from Mass List

This function will search for a given list of m/z values in all mzML
files within a specified directory. For those found, it will generate an
extracted ion chromatograph and individual MS2 spectra for each peak
within that chromatograph. Tables of retention times and intensities
will be generated for EIC plots, tables of fragment m/z and intensities
will be generated for corresponding MS2 spectra.

## Usage

``` r
generate_eic_ms2(
  path_to_files,
  mass_list,
  out.dir = NA,
  ppm_tolerance = 0,
  da_tolerance = 0,
  pct_int_filt = 0.01,
  min_filt = 10000,
  window = 10,
  keep_log = TRUE
)
```

## Arguments

- path_to_files:

  Path to the directory containing mzML files to be analyzed.

- mass_list:

  A vector containing unique m/z values for use in search.

- out.dir:

  Directory to be used for results, if none is specified then a new
  directory 'results' will be generated. Default is NA.

- ppm_tolerance:

  Mass tolerance in parts-per-million. Either this value or da_tolerance
  must be specified. The broadest resulting mass window will be used.
  Default is 0.

- da_tolerance:

  Mass tolerance in Dalton. Either this value or ppm_tolerance must be
  specified. The broadest resulting mass window will be used. Default is
  0.

- pct_int_filt:

  Threshold where intensities below this fraction of the maximum
  intensity will not be considered when calculating local maxima within
  EICs. Default is 0.01 (1%).

- min_filt:

  Baseline intensity below which will not be considered when calculating
  local maxima within EICs. Default is 1e4.

- window:

  Window size for rolling maximum used in peak detection. Default is 10.

- keep_log:

  Whether or not to preserve the generated log file. Default is TRUE.

## Value

A matrix with file-mz pairs and the number of detected peaks.
