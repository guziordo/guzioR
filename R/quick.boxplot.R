#' Create a Boxplot with Points
#'
#' Generate a boxplot with points. Data must be structured to have x, y, and grouping variables in separate columns.
#'
#' @param data Data frame or table to be used in plotting.
#' @param x.var Variable to be used on the x axis.
#' @param y.var Continuous variable used for y axis.
#' @param group.var Variable used for grouping and color. Default is none.
#' @param facet.var Variable used for creating facets that will then be plotted together. Does not need to be included if there isn't one.
#' @param post.hoc Statistical test used for determining significance between groups. Default is Dunn's test. Allowable methods are those from the rstatix R package: "wilcox_test", "t_test", "sign_test", "dunn_test", "emmeans_test", "tukey_hsd", "games_howell_test".
#' @param ns.comp TRUE if only significant comparisons should be shown, FALSE if all comparisons should be shown. If adj.method is set to "none", only significant unadjusted p.values will be shown.
#' @param adj.method Method used for p value adjustment across all p.values present in a plot. Default is Benjamini-Hochburg. Allowable methods are those from 'p.adjust'.
#' @param x.lab X axis label.
#' @param y.lab Y axis label
#' @param color.lab Color label.
#' @returns A ggplot object.
#' @export

quick.boxplot <- function(data, x.var, y.var, group.var = NULL, facet.var = NULL,
                          post.hoc = "dunn_test", ns.comp = TRUE, adj.method = "BH",
                          x.lab = deparse(substitute(x.var)),
                          y.lab = deparse(substitute(y.var)),
                          color.lab = deparse(substitute(group.var))) {

  # Check if required packages are available
  if (!all(c("ggplot2", "ggbeeswarm", "ggpubr", "dplyr") %in% installed.packages())) {
    stop("Required packages (ggplot2, ggbeeswarm, ggpubr, dplyr) are not installed.")
  }

  # Create plot
  p <- ggplot(data, aes_string(x = x.var, y = y.var)) +

    ggpubr::theme_pubr() +

    geom_boxplot(aes_string(fill = group.var),
                 outlier.shape = NA) +

    ggbeeswarm::geom_quasirandom(alpha = 0.75) +

    ggpubr::stat_pwc(method = post.hoc,
                     tip.length = 0,
                     p.adjust.method = "none") +

    scale_y_continuous(expand = expansion(mult = c(0, 0.1))) +

    labs(x = aes_string(x.lab),
         y = aes_string(y.lab),
         fill = aes_string(color.lab)) +

    theme(legend.position = "right")

  # Add facet if provided
  if (!is.null(facet.var)) {
    p <- p + facet_wrap(as.formula(paste("~", facet.var)), nrow = 1)
  }

  p <- ggpubr::ggadjust_pvalue(p = p,
                               p.adjust.method = adj.method,
                               hide.ns = ns.comp,
                               label = "p.adj.format")

  return(p)
}
