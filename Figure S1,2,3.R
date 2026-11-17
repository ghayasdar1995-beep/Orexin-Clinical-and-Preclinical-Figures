# Save as FigS1_S2_S3_combined.R, then run the entire script.
# RStudio: click Source. The Console prints the full output paths.
# Terminal: Rscript FigS1_S2_S3_combined.R "C:/path/to/output"
# Default output folder: figure_outputs inside R's working directory.
# Base R only. Exports one combined figure as PDF and 300 dpi PNG.

WIDTH <- 21
FONT_PT <- 17
DPI <- 300
SQUARE_SIZE <- 1.65
ZERO_LINE_WIDTH <- 3

d <- read.delim(
  text = "panel|id|substance|study|experiment|antagonist|receptor|dose|route|n_T|n_C|g|lo|hi
S1|C079|Morphine|Mahmoudi et al. (44)|CPP after sensitisation|SB-334867|OX1R|0.1–10 nM|IC: VTA|24|8|-1.094764744|-1.938672949|-0.250856540
S1|C080|Morphine|Assar et al. (121)|CPP conditioning|SB-334867|OX1R|0.1–10 nM/side|IC: NAc|20|8|-1.099757380|-1.968792272|-0.230722487
S1|C081|Morphine|Mahmoudi et al. (44)|CPP after sensitisation|TCS-OX2-29|OX2R|1–20 nM|IC: VTA|21|7|-0.997484473|-1.891888884|-0.103080063
S1|C082|Morphine|Assar et al. (121)|CPP conditioning|TCS-OX2-29|OX2R|2–20 nM/side|IC: NAc|18|6|-0.864810315|-1.820588538|0.090967907
S2|C129|Amphetamine|Quarta et al. (28)|Drug challenge|SB-334867|OX1R|30 mg/kg|s.c.|6|6|-2.802980210|-4.396101538|-1.209858882
S2|C130|Cocaine|Yang et al. (99)|Drug challenge|SB-334867|OX1R|10 nmol/side|IC: NAc core|9|9|-1.135628963|-2.131255798|-0.140002129
S2|C131|Cocaine|Yang et al. (99)|Drug challenge|SB-334867|OX1R|10 nmol/side|IC: NAc shell|9|9|-0.373504684|-1.305461654|0.558452287
S3|C184|Morphine|Esmaili-Shahzade-Ali-Akbari et al. (119)|Jumping after naloxone|Suvorexant|DORA|30–90 mg/kg|i.p.|21|7|-2.569632817|-3.658052080|-1.481213553",
  sep = "|", quote = "", stringsAsFactors = FALSE
)

panels <- c(
  S1 = "S1. Conditioned place preference after morphine sensitisation",
  S2 = "S2. Expression of locomotor sensitisation",
  S3 = "S3. Individual somatic withdrawal sign: jumping"
)

limits <- c(-4.5, 1)
ticks <- -4:1

stopifnot(
  nrow(d) == 8L,
  !anyDuplicated(d$id),
  identical(as.integer(table(factor(d$panel, levels = names(panels)))),
            c(4L, 3L, 1L)),
  all(is.finite(d$g) & is.finite(d$lo) & is.finite(d$hi)),
  all(d$lo <= d$g & d$g <= d$hi),
  all(d$lo >= limits[1] & d$hi <= limits[2]),
  all(d$n_T > 0 & d$n_C > 0)
)

d$study_print <- d$study
d$study_print[d$id == "C184"] <-
  "Esmaili-Shahzade-Ali-Akbari\net al. (119)"

fmt <- function(x) sub("-", "\u2212", sprintf("%.2f", x), fixed = TRUE)

# Lay out the rows once so both files use the same spacing.
s <- FONT_PT / 17
rows <- list()
y <- 1.50 * s

add_row <- function(kind, height, label = "", index = NA_integer_) {
  rows[[length(rows) + 1L]] <<- list(
    kind = kind, label = label, index = index,
    y = y + height * s / 2
  )
  y <<- y + height * s
}

for (panel in names(panels)) {
  add_row("panel", 0.48, label = panels[[panel]])
  idx <- which(d$panel == panel)
  
  for (substance in unique(d$substance[idx])) {
    add_row("substance", 0.36, label = substance)
    for (i in idx[d$substance[idx] == substance]) {
      height <- if (grepl("\n", d$study_print[i], fixed = TRUE)) 0.66 else 0.43
      add_row("study", height, index = i)
    }
  }
  
  y <- y + 0.12 * s
}

axis_y <- y + 0.12 * s
HEIGHT <- axis_y + 1.80 * s

cols <- WIDTH * c(0.35, 4.05, 7.10, 9.67, 11.55, 13.05, 18.22) / 21
forest_left <- WIDTH * 14.16 / 21
forest_right <- cols[7] - 0.30

map_x <- function(g) {
  forest_left + (g - limits[1]) / diff(limits) * (forest_right - forest_left)
}

draw <- function() {
  old <- par(mar = rep(0, 4), xaxs = "i", yaxs = "i",
             family = "sans", col = "black", bg = "white")
  on.exit(par(old), add = TRUE)
  
  plot.new()
  plot.window(xlim = c(0, WIDTH), ylim = c(HEIGHT, 0))
  
  txt <- function(x, y, label, scale = 1, bold = FALSE,
                  align = 0, room = Inf) {
    face <- if (bold) 2L else 1L
    cex <- FONT_PT / par("ps") * scale
    lines <- strsplit(label, "\n", fixed = TRUE)[[1L]]
    w <- max(strwidth(lines, units = "user", cex = cex, font = face))
    if (is.finite(w) && w > room) cex <- cex * 0.98 * room / w
    
    offsets <- (seq_along(lines) - (length(lines) + 1) / 2) * 0.25 * s
    text(rep(x, length(lines)), y + offsets, lines,
         adj = c(align, 0.5), cex = cex, font = face, col = "black")
  }
  
  headings <- c("Study", "Experiment", "Antagonist (receptor)", "Dose",
                "Route/site", "n (T/C)", "Hedges' g [95% CI]")
  room <- c(diff(cols[1:6]) - 0.14,
            forest_left - cols[6] - 0.14,
            WIDTH - cols[7] - 0.24)
  stopifnot(all(room > 0), forest_right > forest_left)
  
  for (r in rows) {
    if (r$kind == "study") next
    half_h <- s * (if (r$kind == "panel") 0.19 else 0.14)
    rect(0.24, r$y - half_h, WIDTH - 0.24, r$y + half_h,
         col = if (r$kind == "panel") "#DCE7F0" else "#EFF3F7",
         border = NA)
  }
  
  segments(map_x(0), 1.25 * s, map_x(0), axis_y,
           lty = 1, lwd = ZERO_LINE_WIDTH, col = "black")
  
  txt(cols[1], 0.40 * s, "Supplementary preclinical outcomes",
      scale = 1.50, bold = TRUE, room = WIDTH - 0.70)
  
  for (j in seq_along(headings)) {
    txt(cols[j], 1.04 * s, headings[j], scale = 0.96,
        bold = TRUE, room = room[j])
  }
  
  for (r in rows) {
    if (r$kind != "study") {
      is_panel <- r$kind == "panel"
      txt(cols[1] + ifelse(is_panel, 0, 0.13), r$y, r$label,
          scale = ifelse(is_panel, 1.10, 1), bold = TRUE,
          room = forest_left - cols[1] - 0.28)
      next
    }
    
    z <- d[r$index, ]
    values <- c(
      z$study_print,
      z$experiment,
      paste0(z$antagonist, " (", z$receptor, ")"),
      z$dose,
      z$route,
      paste(z$n_T, z$n_C, sep = "/"),
      paste0(fmt(z$g), " [", fmt(z$lo), ", ", fmt(z$hi), "]")
    )
    
    for (j in seq_along(values)) {
      txt(cols[j], r$y, values[j], room = room[j])
    }
    
    segments(map_x(z$lo), r$y, map_x(z$hi), r$y,
             lwd = 1.8, col = "black")
    points(map_x(z$g), r$y, pch = 15, cex = SQUARE_SIZE, col = "#25843D")
  }
  
  segments(forest_left, axis_y, forest_right, axis_y,
           lwd = 1.8, col = "black")
  
  tick_room <- (forest_right - forest_left) / diff(limits) - 0.06
  for (tick in ticks) {
    x <- map_x(tick)
    label <- sub("-", "\u2212", as.character(tick), fixed = TRUE)
    segments(x, axis_y, x, axis_y + 0.08 * s, lwd = 1.3, col = "black")
    txt(x, axis_y + 0.25 * s, label,
        scale = 0.92, align = 0.5, room = tick_room)
  }
  
  txt(mean(c(forest_left, forest_right)), axis_y + 0.59 * s,
      "Standardized mean difference (Hedges' g)",
      scale = 1.05, bold = TRUE, align = 0.5,
      room = forest_right - forest_left + 1.25)
  
  notes <- c(
    "Squares show individual contrasts; horizontal lines show 95% confidence intervals. T/C = treatment/control.",
    "S1: antagonist given during sensitisation. S3: activity measured at drug challenge, distinct from basal locomotion.",
    "S3: jumping during naloxone-precipitated morphine withdrawal. No estimates were pooled."
  )
  for (i in seq_along(notes)) {
    txt(cols[1], axis_y + (0.94 + 0.27 * (i - 1L)) * s,
        notes[i], scale = 0.86, room = WIDTH - 0.70)
  }
  
  invisible(NULL)
}

export_figure <- function(output_dir = file.path(getwd(), "figure_outputs")) {
  if (!dir.exists(output_dir)) {
    dir.create(output_dir, recursive = TRUE, showWarnings = FALSE)
  }
  if (!dir.exists(output_dir)) {
    stop("Cannot create output folder: ", output_dir, call. = FALSE)
  }
  
  output_dir <- normalizePath(output_dir, winslash = "/", mustWork = TRUE)
  message("Exporting to: ", output_dir)
  stem <- file.path(output_dir, "FigS1_S2_S3_combined")
  
  save_plot <- function(path, open_device) {
    tryCatch({
      open_device(path)
      device <- grDevices::dev.cur()
      tryCatch(draw(), finally = grDevices::dev.off(which = device))
      
      size <- file.info(path)$size
      if (is.na(size) || size <= 0) stop("Output file is missing or empty.")
      message("Saved: ", path)
    }, error = function(e) {
      stop("Export failed for: ", path, "\n", conditionMessage(e),
           call. = FALSE)
    })
  }
  
  save_plot(paste0(stem, ".pdf"), function(path) {
    if (capabilities("cairo")) {
      grDevices::cairo_pdf(path, width = WIDTH, height = HEIGHT)
    } else {
      grDevices::pdf(path, width = WIDTH, height = HEIGHT,
                     useDingbats = FALSE)
    }
  })
  
  save_plot(paste0(stem, ".png"), function(path) {
    png_args <- list(
      filename = path, width = WIDTH, height = HEIGHT,
      units = "in", res = DPI, bg = "white"
    )
    if (capabilities("cairo")) png_args$type <- "cairo"
    do.call(grDevices::png, png_args)
  })
  
  invisible(c(pdf = paste0(stem, ".pdf"), png = paste0(stem, ".png")))
}

args <- if (interactive()) character(0) else commandArgs(trailingOnly = TRUE)
if (length(args)) {
  export_figure(args[1L])
} else {
  export_figure()
}