#' Simultaneous GGPlot Save as PDF, PNG, SVG
#'
#' This function saves the specified plots built using ggplot2 as png, pdf, and svg files. You can specify subfolders for each data subset or store plots however you want in the plot directory.
#'
#' @param plot Name of the plot object to be saved
#' @param path Path to the designated plot folder. These is where subfolders will be built for each plot file type.
#' @param filename What you want the saved plot to be named
#' @param height Plot height
#' @param width Plot width
#' @param pdf Boolean. Whether to save plot as a pdf.
#' @param svg Boolean. Whether to save plot as a svg.
#' @param png Boolean. Whether to save plot as a png.
#' @export

save_ggplot <- function(filename, plot = last_plot(),
                        path = paste0(getwd(),"/plots"),
                        pdf = TRUE, svg = TRUE, png = TRUE,
                        height = NA, width = NA) {

  if (!dir.exists(path)) {
    dir.create(path)
  }

  if (pdf){
    if (!dir.exists(file.path(path, "pdf"))) { dir.create(file.path(path, "pdf"), recursive = TRUE) }
    pdf_file <- file.path(path, "pdf", paste0(filename, ".pdf")); ggsave(pdf_file, plot, height = height, width = width)
  }

  if (png){
    if (!dir.exists(file.path(path, "png"))) { dir.create(file.path(path, "png"), recursive = TRUE) }
    png_file <- file.path(path, "png", paste0(filename, ".png")); ggsave(png_file, plot, height = height, width = width)
  }

  if (svg){
    if (!dir.exists(file.path(path, "svg"))) { dir.create(file.path(path, "svg"), recursive = TRUE) }
    svg_file <- file.path(path, "svg", paste0(filename, ".svg")); ggsave(svg_file, plot, height = height, width = width)
  }
}
