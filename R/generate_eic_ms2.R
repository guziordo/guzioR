#' EIC and MS2 Plotting from Mass List
#'
#' This function will search for a given list of m/z values in all mzML files
#' within a specified directory. For those found, it will generate an extracted
#' ion chromatograph and individual MS2 spectra for each peak within that
#' chromatograph. Tables of retention times and intensities will be generated
#' for EIC plots, tables of fragment m/z and intensities will be generated for
#' corresponding MS2 spectra. Lastly,
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
#' @param keep_log Whether or not to preserve the generated log file. Default is
#' TRUE.
#' @returns An object containing a matrix with file-mz pairs and the number of
#' detected peaks.
#' @export

generate_eic_ms2 <- function(path_to_files, mass_list, out.dir = NA, ppm_tolerance = 0, da_tolerance = 0, pct_int_filt = 0.01, min_filt = 1e4, window = 10, keep_log = TRUE) {
  # check mass window
  if(ppm_tolerance + da_tolerance == 0){
    stop("Mass tolerance not specified.")
  }

  # Generate output directories for plots and tables----
  if(is.na(out.dir) == TRUE) {
    out.dir = file.path(getwd(),"results")
  }

  ifelse(!dir.exists(out.dir), dir.create(out.dir), FALSE)

  for(standard in str_replace(file_list, ".mzML", "")) {
    ifelse(!dir.exists(file.path(out.dir, standard)), dir.create(file.path(out.dir, standard)), FALSE)

    for(i in c("plots","tables")) {
      ifelse(!dir.exists(file.path(out.dir, standard, i)), dir.create(file.path(out.dir, standard, i)), FALSE)

      for(j in c("eic", "ms2")){
        ifelse(!dir.exists(file.path(out.dir, standard, i, j)), dir.create(file.path(out.dir, standard, i, j)), FALSE)

      }
    }
  }
  rm(i, j)

  # Provide log file info----
  if(keep_log == TRUE){
    log_appender(appender_file(file.path(out.dir,"standard-plotting-progress.log")))
  }else{
    log_appender(appender_file("temp.log"))
  }

  log_info("#################### Begin Analysis ####################")

  # Analysis
  mz.matrix = matrix(nrow = length(mass_list), ncol = length(file_list), dimnames = list(mass_list, str_replace(file_list, ".mzML", "")))

  for(mzml.file in file_list) {

    # reset number of completed masses checked to 0
    n.complete = 0

    # create in-plot label
    standard = str_replace(mzml.file, ".mzML", "")

    # specify plot and table paths as generated above
    plot_path = file.path(getwd(), "results", standard, "plots")
    table_path = file.path(getwd(), "results", standard, "tables")

    # open data file
    ms_data <- openMSfile(file.path(getwd(),"mzML",mzml.file))

    # EIC generation ----

    log_info(paste0("Starting EIC generation for ", standard))

    for(target_mass in mass_list){
      ## Data extraction ----
      # generate name for files
      short.name = round(target_mass, 4) %>% as.character() %>% gsub('\\.', '_', .)

      # calculate tolerance in Da
      mz_tolerance <- max((ppm_tolerance/1000000) * target_mass, da_tolerance)

      # initialize lists for rt-int pairs
      retention_times <- numeric()
      intensities <- numeric()

      # iterate through MS1 scans and extract data
      for (i in 1:length(ms_data)) {
        spectrum <- peaks(ms_data, i)
        header <- header(ms_data, i)

        # only pull data from MS1
        if (header$msLevel == 1) {
          retention_time <- header$retentionTime

          # find peaks within the target m/z range
          matching_peaks <- spectrum[abs(spectrum[, 1] - target_mass) <= mz_tolerance, , drop = FALSE]

          # if multiple peaks within ppm tolerance were found, sum their intensities for this retention time
          if (nrow(matching_peaks) > 0) {
            total_intensity <- sum(matching_peaks[, 2])
            retention_times <- c(retention_times, retention_time)
            intensities <- c(intensities, total_intensity)
          } else {
            # if no peaks are found, set intensity to 0
            retention_times <- c(retention_times, retention_time)
            intensities <- c(intensities, 0)
          }
        }
      }

      # create data frame for EIC plotting/output
      eic_data <- data.frame(
        RetentionTime = retention_times/60,
        Intensity = intensities
      )

      ## EIC Plotting ----

      # establish intensity threshold for plotting local maxima
      threshold = max(max(eic_data$Intensity)*pct_int_filt, min_filt)

      # identify local maxima
      is_max <- eic_data$Intensity == rollapply(eic_data$Intensity, window, max, fill = NA)

      # subset eic data to only include those points, filtering against intensity cutoff
      local_maxima <- eic_data[is_max & !is.na(is_max), ] %>% filter(Intensity > threshold)

      # add number of peaks that passed thresholds to standard matrix
      if(nrow(local_maxima) > 0){
        mz.matrix[as.character(target_mass), standard] <- nrow(local_maxima)
      } else {
        mz.matrix[as.character(target_mass), standard] <- NA
      }

      if(nrow(local_maxima) > 0){
        plot <- ggplot(eic_data, aes(x = RetentionTime, y = Intensity)) + theme_pubr() +
          annotate(geom = "text", x = max(eic_data$RetentionTime), y = max(eic_data$Intensity), label = paste0("m/z ", target_mass), vjust = -1, hjust = 1) +
          annotate(geom = "text", x = 0.1, y = max(eic_data$Intensity), label = standard, vjust = -1, hjust = 0) +
          geom_line(linewidth = 0.3) +
          geom_point(data = local_maxima, color = "red") +
          geom_text(data = local_maxima, aes(label = round(RetentionTime, 2)),
                    vjust = -1, hjust = 0.5, color = "red") +
          scale_x_continuous(expand = expansion(mult = c(0,NA))) +
          scale_y_continuous(expand = expansion(mult = c(0,0.1)),
                             labels = scales::label_scientific())

        # save EIC plot
        ggsave(plot = plot, filename = file.path(plot_path, "eic", paste0(short.name, ".png")), width = 12, height = 5)

        # write EIC data to csv
        write_csv(eic_data, file = file.path(table_path, "eic", paste0(short.name, ".csv")))
      }

      # MS2 Generation ----

      if(nrow(local_maxima) > 0){
        metadata <- data.frame(
          spectrum_index = integer(),
          precursor_mass = numeric(),
          retention_time = numeric()
        )

        ## Data extraction ----
        # Initialize a list to store filtered spectra (with metadata)
        filtered_spectra <- list()

        # Iterate through spectra, filtering and collecting metadata
        for (i in 1:length(ms_data)) {
          spectrum <- peaks(ms_data, i)
          header <- header(ms_data, i)

          if (header$msLevel == 2) {
            precursor_mz <- header$precursorMZ
            retention_time <- header$retentionTime/60

            if (abs(precursor_mz - target_mass)/target_mass <= mz_tolerance) {

              if(any(abs(retention_time - local_maxima$RetentionTime) <= 0.09)){
                # Store both spectrum and metadata together
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
        }

        # Extract metadata
        metadata <- bind_rows(lapply(filtered_spectra, `[[`, "metadata"))

        ## MS2 plotting ----
        # Extract spectra for processing (if any were found)
        if (length(filtered_spectra) > 0) {
          for (i in 1:length(filtered_spectra)) {
            spec_info = filtered_spectra[[i]]$metadata
            spectrum = filtered_spectra[[i]]$spectrum %>% as.data.frame()

            plot = ggplot(spectrum, aes(mz, intensity)) + theme_pubr() +
              geom_segment(aes(xend = mz, yend = 0)) +
              geom_text(data = spectrum %>% filter(intensity > 0.01 * max(spectrum$intensity)),
                        aes(label = abs(round(mz,3)), y = intensity),
                        size = 3, angle = -60, hjust = 1.1) +
              labs(x = "m/z",
                   y = "Intensity",
                   title = paste0(round(spec_info$precursor_mass, 4), " m/z, ", round(spec_info$retention_time, 2), "min"),
                   subtitle = paste0(standard, ", scan ", spec_info$spectrum_index)) +
              scale_x_continuous(expand = expansion(mult = c(0.1,0.1))) +
              scale_y_continuous(expand = expansion(mult = c(0,0.1)),
                                 labels = scales::label_scientific())

            name_for_file = paste0(round(spec_info$precursor_mass, 4), "_mz-", round(spec_info$retention_time, 2),"_min") %>% gsub('\\.', '_', .)

            ggsave(plot = plot, filename = file.path(plot_path, "ms2", paste0(name_for_file, ".png")), height = 6, width = 12)

            write_csv(spectrum, file = file.path(table_path, "ms2", paste0(name_for_file, ".csv")))
          }
        }
      }

      # update progress log to track progression
      n.complete = n.complete + 1

      for(i in c(20,40,60,80,100)){
        benchmark = round(length(mass_list)*(i/100), 0)
        if(n.complete == benchmark){
          log_info(paste0(i,"% Complete for ", length(mass_list), " masses."))
          print(paste0(i,"% Complete for ", length(mass_list), " masses."))
        }
      }

      ## Log file ----
      if(n.complete == length(mass_list)){
        detected_mz = sum(mz.matrix[, standard] > 0, na.rm = TRUE)
        log_info(paste0(detected_mz," of the ",length(mass_list)," masses were detected in ", standard,"."))
        rm(detected_mz)
      }
    }
  }

  write_csv(mz.matrix, file = "detected_masses_per_file.csv")

  if (file.exists("temp.log")) {
    file.remove("temp.log")
  }
}
