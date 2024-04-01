#' Save Plot as Multiple File Types
#' 
#' This function saves the specified plots built using ggplot2 as png, pdf, and svg files. You can specify subfolders for each data subset or store plots however you want in the plot directory.
#' 
#' @param plot Name of the plot object to be saved
#' @param path Path to the designated plot folder. These is where subfolders will be built for each plot file type.
#' @param filename What you want the saved plot to be named
#' @param height Plot height
#' @param width Plot width
#' @export

save.ggplot <- function(plot, path, filename, height, width) {
  
  if (!dir.exists(path)) {
    dir.create(path)
  }
  
  # Set up different filetype paths
  pdf_dir <- file.path(path, "pdf")
  png_dir <- file.path(path, "png")
  svg_dir <- file.path(path, "svg")
  
  # Make directories if they aren't already made
  if (!dir.exists(pdf_dir)) {
    dir.create(pdf_dir, recursive = TRUE)
  }
  
  if (!dir.exists(png_dir)) {
    dir.create(png_dir, recursive = TRUE)
  }
  
  if (!dir.exists(svg_dir)) {
    dir.create(svg_dir, recursive = TRUE)
  }
  
  # Save plots
  pdf_file <- file.path(pdf_dir, paste0(filename, ".pdf")); ggsave(pdf_file, plot, height = height, width = width)
  png_file <- file.path(png_dir, paste0(filename, ".png")); ggsave(png_file, plot, height = height, width = width)
  svg_file <- file.path(svg_dir, paste0(filename, ".svg")); ggsave(svg_file, plot, height = height, width = width)
}
