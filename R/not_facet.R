#' Plot Facets as Single Plot
#' 
#' Add to the end of ggplot code to shrink space between facets, move the strip label, and plot as if objects are grouped by the facets themselves.
#' 
#' @param x GGplot object
#' @export


not_facet <- function(x) {
  theme(strip.placement = "outside",
        strip.background = element_blank(),
        strip.text = element_text(vjust = 2.5, size = 12),
        panel.spacing = unit(0, "line"),
        axis.text.x = element_blank(),
        axis.ticks.x = element_blank(),
        axis.title.x = element_blank()
  )
}
