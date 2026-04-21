# Calculate Alpha Diversity Metrics

This function is used to calculate multiple alpha diversity metrics all
in one go. This calculates Shannon Index, Simpson Index, Pielou Index,
and sample richness

## Usage

``` r
alpha_div(data, sample_col = 1)
```

## Arguments

- data:

  Data table with sample IDs in the first column

- sample_col:

  Column name containing sample identifiers

## Value

A data frame containing associated alpha diversity metrics for samples
in the provided table.
