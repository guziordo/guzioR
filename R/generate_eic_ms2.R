#' EIC and MS2 Plotting from Mass List
#'
#' This function will search for a given list of m/z values in all mzML files
#' within a specified directory. For those found, it will generate an extracted
#' ion chromatograph and individual MS2 spectra for each peak within that
#' chromatograph. Tables of retention times and intensities will be generated
#' for EIC plots, tables of fragment m/z and intensities will be generated for
#' corresponding MS2 spectra.
#'
#' @param path_to_files Path to the directory containing mzML files to be
#' analyzed.
#' @param mass_list A vector containing unique m/z values for use in search.
#' @param out.dir Directory to be used for results, if none is specified then a
#' new directory 'results' will be generated. Default is NA.
#' @param ppm_tolerance Mass tolerance in parts-per-million. Either this value
#' or da_tolerance must be specified. The broadest resulting mass window will be
#' used. Default is 0.
#' @param da_tolerance Mass tolerance in Dalton. Either this value or
#' ppm_tolerance must be specified. The broadest resulting mass window will be
#' used. Default is 0.
#' @param pct_int_filt Threshold where intensities below this fraction of the
#' maximum intensity will not be considered when calculating local maxima within
#' EICs. Default is 0.01 (1%).
#' @param min_filt Baseline intensity below which will not be considered when
#' calculating local maxima within EICs. Default is 1e4.
#' @param window Window size for rolling maximum used in peak detection. Default is 10.
#' @param keep_log Whether or not to preserve the generated log file. Default is
#' TRUE.
#' @returns A matrix with file-mz pairs and the number of detected peaks.
#' @export

generate_eic_ms2 <- function(path_to_files, mass_list, out.dir = NA, ppm_tolerance = 0,
                              da_tolerance = 0, pct_int_filt = 0.01, min_filt = 1e4,
                              window = 10, keep_log = TRUE) {
  if (ppm_tolerance + da_tolerance == 0) {
    stop("Mass tolerance not specified.")
  }

  file_list <- list.files(path_to_files, pattern = "\\.mzML$")
  if (length(file_list) == 0) {
    stop("No mzML files found in path_to_files.")
  }

  if (is.na(out.dir)) {
    out.dir <- file.path(getwd(), "results")
  }

  dir.create(out.dir, showWarnings = FALSE, recursive = TRUE)

  for (standard in stringr::str_replace(file_list, "\\.mzML$", "")) {
    dir.create(file.path(out.dir, standard), showWarnings = FALSE)
    for (i in c("plots", "tables")) {
      dir.create(file.path(out.dir, standard, i), showWarnings = FALSE)
      for (j in c("eic", "ms2")) {
        dir.create(file.path(out.dir, standard, i, j), showWarnings = FALSE)
      }
    }
  }

  log_file <- if (keep_log) file.path(out.dir, "standard-plotting-progress.log") else NULL
  log_msg <- function(msg) {
    message(msg)
    if (!is.null(log_file)) {
      cat(paste0("[", format(Sys.time()), "] ", msg, "\n"), file = log_file, append = TRUE)
    }
  }

  log_msg("#################### Begin Analysis ####################")

  mz.matrix <- matrix(nrow = length(mass_list), ncol = length(file_list),
                      dimnames = list(mass_list,
                                      stringr::str_replace(file_list, "\\.mzML$", "")))

  for (mzml.file in file_list) {
    n.complete <- 0
    standard <- stringr::str_replace(mzml.file, "\\.mzML$", "")
    plot_path <- file.path(out.dir, standard, "plots")
    table_path <- file.path(out.dir, standard, "tables")

    ms_data <- mzR::openMSfile(file.path(path_to_files, mzml.file))
    n_spectra <- length(ms_data)

    log_msg(paste0("Starting EIC generation for ", standard))

    for (target_mass in mass_list) {
      short.name <- gsub('\\.', '_', as.character(round(target_mass, 4)))
      mz_tolerance <- max((ppm_tolerance / 1e6) * target_mass, da_tolerance)

      retention_times <- numeric()
      intensities <- numeric()

      for (i in seq_len(n_spectra)) {
        spectrum <- mzR::peaks(ms_data, i)
        hdr <- mzR::header(ms_data, i)

        if (hdr$msLevel == 1) {
          matching_peaks <- spectrum[abs(spectrum[, 1] - target_mass) <= mz_tolerance, , drop = FALSE]
          retention_times <- c(retention_times, hdr$retentionTime)
          intensities <- c(intensities,
                           if (nrow(matching_peaks) > 0) sum(matching_peaks[, 2]) else 0)
        }
      }

      eic_data <- data.frame(RetentionTime = retention_times / 60, Intensity = intensities)

      threshold <- max(max(eic_data$Intensity) * pct_int_filt, min_filt)

      half_w <- floor(window / 2)
      roll_max <- vapply(seq_len(nrow(eic_data)), function(idx) {
        max(eic_data$Intensity[max(1L, idx - half_w):min(nrow(eic_data), idx + half_w)])
      }, numeric(1))
      is_max <- eic_data$Intensity == roll_max

      local_maxima <- eic_data[is_max & !is.na(is_max), ] %>%
        filter(Intensity > threshold)

      mz.matrix[as.character(target_mass), standard] <- if (nrow(local_maxima) > 0) nrow(local_maxima) else NA

      if (nrow(local_maxima) > 0) {
        eic_plot <- ggplot(eic_data, aes(x = RetentionTime, y = Intensity)) +
          ggpubr::theme_pubr() +
          annotate(geom = "text", x = max(eic_data$RetentionTime), y = max(eic_data$Intensity),
                   label = paste0("m/z ", target_mass), vjust = -1, hjust = 1) +
          annotate(geom = "text", x = 0.1, y = max(eic_data$Intensity),
                   label = standard, vjust = -1, hjust = 0) +
          geom_line(linewidth = 0.3) +
          geom_point(data = local_maxima, color = "red") +
          geom_text(data = local_maxima, aes(label = round(RetentionTime, 2)),
                    vjust = -1, hjust = 0.5, color = "red") +
          scale_x_continuous(expand = expansion(mult = c(0, NA))) +
          scale_y_continuous(expand = expansion(mult = c(0, 0.1)),
                             labels = scales::label_scientific())

        ggsave(plot = eic_plot,
               filename = file.path(plot_path, "eic", paste0(short.name, ".png")),
               width = 12, height = 5)
        write.csv(eic_data,
                  file = file.path(table_path, "eic", paste0(short.name, ".csv")),
                  row.names = FALSE)

        filtered_spectra <- list()

        for (i in seq_len(n_spectra)) {
          spectrum <- mzR::peaks(ms_data, i)
          hdr <- mzR::header(ms_data, i)

          if (hdr$msLevel == 2) {
            precursor_mz <- hdr$precursorMZ
            retention_time <- hdr$retentionTime / 60

            if (abs(precursor_mz - target_mass) <= mz_tolerance &&
                any(abs(retention_time - local_maxima$RetentionTime) <= 0.09)) {
              filtered_spectra[[length(filtered_spectra) + 1]] <- list(
                spectrum = spectrum,
                metadata = data.frame(
                  spectrum_index = i,
                  precursor_mass = precursor_mz,
                  retention_time = retention_time
                )
              )
            }
          }
        }

        for (i in seq_along(filtered_spectra)) {
          spec_info <- filtered_spectra[[i]]$metadata
          spectrum <- as.data.frame(filtered_spectra[[i]]$spectrum)

          ms2_plot <- ggplot(spectrum, aes(mz, intensity)) +
            ggpubr::theme_pubr() +
            geom_segment(aes(xend = mz, yend = 0)) +
            geom_text(data = spectrum %>% filter(intensity > 0.01 * max(spectrum$intensity)),
                      aes(label = abs(round(mz, 3)), y = intensity),
                      size = 3, angle = -60, hjust = 1.1) +
            labs(x = "m/z", y = "Intensity",
                 title = paste0(round(spec_info$precursor_mass, 4), " m/z, ",
                                round(spec_info$retention_time, 2), " min"),
                 subtitle = paste0(standard, ", scan ", spec_info$spectrum_index)) +
            scale_x_continuous(expand = expansion(mult = c(0.1, 0.1))) +
            scale_y_continuous(expand = expansion(mult = c(0, 0.1)),
                               labels = scales::label_scientific())

          name_for_file <- gsub('\\.', '_',
                                paste0(round(spec_info$precursor_mass, 4), "_mz-",
                                       round(spec_info$retention_time, 2), "_min"))

          ggsave(plot = ms2_plot,
                 filename = file.path(plot_path, "ms2", paste0(name_for_file, ".png")),
                 height = 6, width = 12)
          write.csv(spectrum,
                    file = file.path(table_path, "ms2", paste0(name_for_file, ".csv")),
                    row.names = FALSE)
        }
      }

      n.complete <- n.complete + 1

      for (pct in c(20, 40, 60, 80, 100)) {
        if (n.complete == round(length(mass_list) * (pct / 100))) {
          log_msg(paste0(pct, "% complete for ", length(mass_list), " masses."))
        }
      }

      if (n.complete == length(mass_list)) {
        detected_mz <- sum(mz.matrix[, standard] > 0, na.rm = TRUE)
        log_msg(paste0(detected_mz, " of the ", length(mass_list),
                       " masses were detected in ", standard, "."))
      }
    }
  }

  write.csv(as.data.frame(mz.matrix),
            file = file.path(out.dir, "detected_masses_per_file.csv"))

  return(invisible(mz.matrix))
}
