#' Generate MS2 Mirror Plot
#'
#' This function is used to generate an MS2 mirror plot between two spectra, with the option to highlight reference peaks from a third spectrum.
#'
#' Note: MS2 spectral cleaning is done by msentropy::clean_spectrum(). Therefor, either provide ppm.tolerance or da.tolerance, not both.
#'
#' @param ms2.top.id Numeric MS2 scan identifier for MS2 peaks on the top of the plot.
#' @param ms2.bot.id Numeric MS2 scan identifier for MS2 peaks on the bottom of the plot.
#' @param ms2.top Dataframe or matrix containing two columns, `mz` and `intensity`, for the top spectrum to be plotted.
#' @param ms2.bot Dataframe or matrix containing two columns, `mz` and `intensity`, for the bottom spectrum to be plotted.
#' @param ms2.metadata Dataframe containing metabolite information including scan.id, name, rt.
#' @param ppm.tolerance Numeric, determines what m/z tolerance will be used in spectral cleaning. Default is -1.
#' @param da.tolerance Numeric, determines what m/z tolerance will be used in spectral cleaning. Default is -1.
#' @param add.ref Boolean, indicates if a third MS2 spectrum is provided for identifying matched peaks present in ms2.top or ms2.bot m/z values. Default is FALSE.
#' @param ms2.ref Dataframe or matrix containing two columns, `mz` and `intensity`, for the MS2 spectrum to be used as a third reference. Default is -1.
#' @param ms2.ref.id Numeric MS2 scan identifier for reference MS2 peaks. Default is -1.
#' @returns A ggplot object containing the MS2 mirror plot.
#' @export

plot_ms2_mirror <- function(ms2.top, ms2.top.id, ms2.bot, ms2.bot.id, ms2.metadata, ppm.tolerance = -1, da.tolerance = -1, add.ref = FALSE, ms2.ref, ms2.ref.id) {
    for(i in c(ms2.top, ms2.top.id, ms2.bot, ms2.bot.id, ms2.metadata,)){
        if(is.na()) {
            stop(print(paste0(i, " must be provided.")))
        }
    }

    if(ms2.top.id %ni% ms2.metadata$scan.id || ms2.bot.id %ni% ms2.metadata$scan.id){
        metadata.present = FALSE
        print("WARNING: MS2 metadata not found for both scans. Proceeding without displaying metabolite information.")
    } else {
        metadata.present = TRUE
    }

    if(ppm.tolerance < 0 & da.tolerance < 0) {
        stop("Either ppm.tolerance or da.tolerance must be provided and must be greater than 0.")
    }

    # Clean MS2 spectra prior to plotting and analysis
    info.top <- ms2.metadata %>% filter(scan.id %in% ms2.top.id)
    data.top <- ms2.top %>%
        as.matrix() %>%
        clean_spectrum(., min_mz = -1, max_mz = -1, noise_threshold = 0.01,
                    min_ms2_difference_in_da = da.tolerance, min_ms2_difference_in_ppm = ppm.tolerance,
                    max_peak_num = 100, normalize_intensity = TRUE) %>%
        as.data.frame() %>%
        mutate(plot.int = intensity,
            id = ms2.bot.id,
            name = info.top$name)

    info.bot <- ms2.metadata %>% filter(scan.id %in% ms2.bot.id)
    data.bot <- ms2.bot %>%
        as.matrix() %>%
        clean_spectrum(., min_mz = -1, max_mz = -1, noise_threshold = 0.01,
                    min_ms2_difference_in_da = da.tolerance, min_ms2_difference_in_ppm = ppm.tolerance,
                    max_peak_num = 100, normalize_intensity = TRUE) %>%
        as.data.frame() %>%
        mutate(plot.int = intensity * -1,
            id = ms2.bot.id,
            name = info.bot$name)

    plot.data <- rbind(data.top, data.bot) %>%
        mutate(mz.round = abs(round(mz,2)),
            id = factor(id, levels = c(ms2.top.id, ms2.bot.id)))

    # Calculate MS2 Entropy Similarity
    ms2.sim = calculate_entropy_similarity(
        peaks_a = as.matrix(data.top[,c("mz", "intensity")]),
        peaks_b = as.matrix(data.bot[,c("mz", "intensity")]),
        ms2_tolerance_in_da = da.tolerance, ms2_tolerance_in_ppm = ppm.tolerance, clean_spectra = F,
        min_mz = -1, max_mz = -1, noise_threshold = -1, max_peak_num = -1
    )

    # Generate Plot
    if(add.ref) {
        data.ref <- ms2.ref %>%
            as.matrix() %>%
            clean_spectrum(., min_mz = -1, max_mz = -1, noise_threshold = 0.01,
                min_ms2_difference_in_da = da.tolerance, min_ms2_difference_in_ppm = ppm.tolerance,
                max_peak_num = 100, normalize_intensity = TRUE) %>%
            as.data.frame() %>%
            mutate(plot.int = intensity * -1,
                id = ms2.ref.id,
                name = info2$name)

        ft3.match <- data.ref %>%
            mutate(mz.round = round(mz,2)) %>%
            filter(mz.round %in% data.ref$mz.round)

        plot.data <- plot.data %>% filter(mz.round %ni% ft3.match$mz.round)
    }

    plot.max.y.val = max(plot.data$mz.round)

    mirror.plot <- joined.df %>% #filter(mz.round %ni% peak.match$mz.round) %>%
        ggplot(aes(x = mz, y = plot.int, color = id)) +
            theme_pubr() +
            geom_segment(aes(xend = mz, yend = 0)) +
            geom_hline(yintercept = 0, color = "black") +
            annotate("text_npc", npcx = 0.98, npcy = 0.98,
                label = paste0("Entropy Similarity = ", round(ms2.sim, 3)),
                hjust = "right", vjust = "top") +
            geom_text(data = data.top %>% filter(plot.int > 0.011),
                aes(label = abs(round(mz,3)), y = plot.int),
                size = 3, angle = -45, hjust = 1.1) +
            geom_text(data = data.bot %>% filter(plot.int < -0.011),
                aes(label = abs(round(mz,3)), y = plot.int),
                size = 3, angle = 45, hjust = 1.1) +
            scale_y_continuous(limits = ,
                expand = expansion(mult = c(0.2,0.2))) +
            labs(x = "m/z",
                y = "Intensity",
                color = "Scan ID") +
            scale_color_manual(values = c("#1e98e1", "#063c7f")) +
            theme(legend.position = "",
                axis.title.x = element_text(face = "italic"),
                axis.ticks.y = element_blank(),
                axis.text.y = element_blank()
                )
    if(metadata.present) {
        mirror.plot <- mirror.plot +
            annotate("text_npc", npcx = 0.02, npcy = 0.98,
                label = paste0("Scan #", ms2.top.id, ", ", info.top$name, ", ", info.top$rt, " min"),
                hjust = "left", vjust = "top", color = "#1e98e1") +
            annotate("text_npc", npcx = 0.02, npcy = 0.02,
                label = paste0("Scan #", scan.bot, ", ", info.bot$name, ", ", info.bot$rt, " min"),
                hjust = "left", vjust = "bottom", color = "#063c7f")
    } else {
        mirror.plot <- mirror.plot +
            annotate("text_npc", npcx = 0.02, npcy = 0.98,
                label = paste0("Scan #", ms2.top.id),
                hjust = "left", vjust = "top", color = "#1e98e1") +
            annotate("text_npc", npcx = 0.02, npcy = 0.02,
                label = paste0("Scan #", scan.bot),
                hjust = "left", vjust = "bottom", color = "#063c7f")
    }

    if (add.ref) {
        mirror.plot <- mirror.plot + geom_segment(data = ft3.match, aes(xend = mz, yend = 0), color = "orange") +
            annotate("text_npc", npcx = 0.98, npcy = 0.92,
                label = paste0(re),
                hjust = "right", vjust = "top", color = "orange")

        print(mirror.plot)

        ggsave(filename = paste0("ms2-mirror-plot_", ms2.top.id, "_", ms2.bot.id, "_highlight-",ms2.ref.id,".png"), height = 4, width = 6)
    } else {
        print(mirror.plot)

        ggsave(mirror.plot, filename = paste0("ms2-mirror-plot_", ms2.top.id, "_", ms2.bot.id, ".png"), height = 4, width = 6)
    }

    rm(data.top, data.bot, plot.data, ms2.sim)
}
