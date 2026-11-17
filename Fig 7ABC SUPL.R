# Fig7A_B_C_combined.R
# RStudio: save this script and click Source.
# Terminal: Rscript Fig7A_B_C_combined.R [output_directory]
# Default output folder: figure_outputs inside your working directory.
# Base R only. Exports a vector PDF and a 300 dpi PNG.

WIDTH <- 21
FONT_PT <- 17
DPI <- 300
SQUARE_SIZE <- 1.6
ZERO_LINE_WIDTH <- 3

# Panel assignments are defined separately by contrast ID.
# Effect estimates, confidence limits, and sample sizes are unchanged.
d <- read.delim(
  text = "id|substance|study|experiment|antagonist|receptor|dose|route|n_T|n_C|g|lo|hi
C197|Alcohol|Anderson et al. (081)|Drinking in the dark|SB-334867|OX1R|3\u201330 mg/kg|i.p.|30|10|-1.1010146896|-1.8562793973|-0.345749982
C198|Alcohol|Anderson et al. (081)|Drinking in the dark|LSN2424100|OX2R|15\u201360 mg/kg|i.p.|29|10|-0.5374382619|-1.2660360248|0.1911595011
C199|Alcohol|Anderson et al. (081)|Drinking in the dark|Almorexant|DORA|25\u2013100 mg/kg|p.o.|30|10|-0.8947070641|-1.6367672897|-0.1526468385
C202|Alcohol|Carvajal et al. (082)|Drinking in the dark|SB-334867|OX1R|1\u20133 \u00b5g|i.c.v.|25|13|-0.7447949034|-1.4355997243|-0.0539900825
C200|Alcohol|Carvajal et al. (082)|Locomotor activity|SB-334867|OX1R|10 \u00b5g|i.c.v.|8|8|0.0387591707|-0.9413328392|1.0188511806
C201|Alcohol|Olney et al. (019)|Open-field activity|SB-334867|OX1R|10 mg/kg|i.p.|10|10|0.698084178|-0.2047570919|1.600925448
C203|Alcohol|Brown et al. (027)|Locomotor activity|TCS-OX2-29|OX2R|100\u2013300 \u00b5g|i.c.v.|12|5|0.0691712015|-0.9743775243|1.1127199272
C204|Alcohol|Brown et al. (027)|Locomotor activity|TCS-OX2-29|OX2R|100 \u00b5g/side|intra-NAc core|5|4|-0.6920306379|-2.0451489878|0.661087712
C205|Alcohol|Brown et al. (027)|Locomotor activity|TCS-OX2-29|OX2R|100 \u00b5g/side|intra-NAc shell|7|9|-0.6159063989|-1.6264430358|0.394630238
C206|Methamphetamine|Zamanirad et al. (089)|Locomotor activity|TCS-OX2-29|OX2R|1\u201330 nmol|intra-VTA|35|9|-0.0196292946|-0.752173672|0.7129150829
C207|Morphine|Alizamini et al. (094)|Locomotor activity|SB-334867|OX1R|1\u201330 nM/0.5 \u00b5L|intra-NAc|23|6|-0.0440664967|-0.9426327834|0.8544997899
C196|Cocaine|Hutcheson et al. (16)|Conditioned reinforcement (E2)|SB-334867|OX1R|10\u201330 mg/kg|i.p.|12|5|-0.4248138727|-1.4778304735|0.6282027281
C208|Cocaine|Zhou et al. (014)|Cue reinstatement (Exp 2)|SB-334867|OX1R|20 mg/kg|i.p.|21|22|-0.2989164072|-0.900200703|0.3023678886
C209|Cocaine|Smith & Aston-Jones (097)|Seeking after 2 weeks (Exp 2)|SB-334867|OX1R|10\u201330 mg/kg|i.p.|37|12|-0.6054444642|-1.2675091362|0.0566202079
C210|Cocaine|Smith & Aston-Jones (097)|Context reinstatement (Exp 3)|SB-334867|OX1R|10\u201330 mg/kg|i.p.|55|18|-0.5183554562|-1.0571869856|0.0204760733
C211|Alcohol|Jupp et al. (064)|Immediate and delayed cue tests|SB-334867|OX1R|15 mg/kg|i.p.|19|20|-0.6233480648|-1.2663151637|0.019619034
C212|Alcohol|Flores-Ramirez et al. (079)|Stress reinstatement|TCS1102|DORA|15 \u00b5g/0.5 \u00b5L/side|intra-IL|24|24|-0.0883601166|-0.6544394078|0.4777191745",
  sep = "|", quote = "", stringsAsFactors = FALSE, check.names = FALSE
)

panel_titles <- c(
  "7A" = "7A. Binge-like ethanol intake (g/kg)",
  "7B" = "7B. Locomotor activity controls",
  "7C" = "7C. Inactive responding controls"
)

panel_by_id <- c(
  C197 = "7A", C198 = "7A", C199 = "7A", C202 = "7A",
  C200 = "7B", C201 = "7B", C203 = "7B", C204 = "7B",
  C205 = "7B", C206 = "7B", C207 = "7B",
  C196 = "7C", C208 = "7C", C209 = "7C", C210 = "7C",
  C211 = "7C", C212 = "7C"
)

d$id <- trimws(d$id)
if (anyDuplicated(d$id) || !setequal(d$id, names(panel_by_id))) {
  stop("The embedded contrast IDs do not match the Figure 7 panel map.")
}
d$panel <- unname(panel_by_id[d$id])

limits <- c(-2.5, 2)
ticks <- seq(limits[1], limits[2], by = 0.5)
counts <- table(factor(d$panel, levels = names(panel_titles)))

stopifnot(
  identical(as.integer(counts), c(4L, 7L, 6L)),
  all(is.finite(d$g) & is.finite(d$lo) & is.finite(d$hi)),
  all(d$lo <= d$g & d$g <= d$hi),
  all(d$lo >= limits[1] & d$hi <= limits[2]),
  all(d$n_T > 0 & d$n_C > 0)
)
message("Verified panel counts: 7A = 4, 7B = 7, 7C = 6.")

s <- FONT_PT / 17
rows <- list()
y <- 1.45 * s

add_row <- function(kind, label = "", index = NA_integer_) {
  rows[[length(rows) + 1L]] <<- list(
    kind = kind, label = label, index = index, y = y
  )
  y <<- y + s * switch(kind, panel = 0.44, substance = 0.35, study = 0.37)
}

for (panel in names(panel_titles)) {
  add_row("panel", panel_titles[[panel]])
  idx <- which(d$panel == panel)
  
  for (substance in unique(d$substance[idx])) {
    add_row("substance", substance)
    for (i in idx[d$substance[idx] == substance]) {
      add_row("study", index = i)
    }
  }
  y <- y + 0.12 * s
}

axis_y <- y + 0.05 * s
HEIGHT <- axis_y + 2.15 * s

cols <- WIDTH * c(0.32, 3.44, 7.02, 9.50, 11.47, 13.03, 18.25) / 21
forest_left <- WIDTH * 14.05 / 21
forest_right <- cols[7] - 0.30
forest_width <- forest_right - forest_left

map_x <- function(g) {
  forest_left + (g - limits[1]) / diff(limits) * forest_width
}

fmt <- function(x, digits = 2L) {
  formatC(x, digits = digits, format = "f")
}

draw <- function() {
  op <- par(mar = rep(0, 4), xaxs = "i", yaxs = "i",
            family = "sans", col = "black", bg = "white")
  on.exit(par(op), add = TRUE)
  plot.new()
  plot.window(xlim = c(0, WIDTH), ylim = c(HEIGHT, 0))
  
  txt <- function(x, y, label, scale = 1, bold = FALSE,
                  align = 0, room = Inf) {
    cex <- FONT_PT / par("ps") * scale
    face <- if (bold) 2L else 1L
    if (is.finite(room)) {
      w <- strwidth(label, units = "user", cex = cex, font = face)
      if (is.finite(w) && w > room) cex <- cex * 0.98 * room / w
    }
    text(x, y, label, adj = c(align, 0.5),
         cex = cex, font = face, col = "black")
  }
  
  headings <- c("Study", "Experiment", "Antagonist (receptor)",
                "Dose", "Route/site", "n (T/C)", "Hedges' g [95% CI]")
  room <- c(diff(cols[1:6]) - 0.15,
            forest_left - cols[6] - 0.14,
            WIDTH - cols[7] - 0.24)
  
  for (r in rows) {
    if (r$kind == "study") next
    h <- s * (if (r$kind == "panel") 0.17 else 0.13)
    rect(0.22, r$y - h, WIDTH - 0.22, r$y + h, border = NA,
         col = if (r$kind == "panel") "#DCE7F0" else "#EFF3F7")
  }
  
  segments(map_x(0), 1.22 * s, map_x(0), axis_y,
           lty = 1, lwd = ZERO_LINE_WIDTH, col = "black")
  
  txt(cols[1], 0.39 * s,
      "Figure 7. Binge-like ethanol intake and behavioural specificity controls",
      scale = 1.45, bold = TRUE, room = WIDTH - 0.65)
  
  for (j in seq_along(headings)) {
    txt(cols[j], 0.99 * s, headings[j], scale = 0.96,
        bold = TRUE, room = room[j])
  }
  
  for (r in rows) {
    if (r$kind != "study") {
      is_panel <- r$kind == "panel"
      txt(cols[1] + if (is_panel) 0 else 0.14, r$y, r$label,
          scale = if (is_panel) 1.10 else 1,
          bold = TRUE, room = forest_left - cols[1] - 0.25)
      next
    }
    
    z <- d[r$index, ]
    vals <- c(
      paste0(z$study),
      z$experiment,
      paste0(z$antagonist, " (", z$receptor, ")"),
      z$dose,
      z$route,
      paste(z$n_T, z$n_C, sep = "/"),
      paste0(fmt(z$g), " [", fmt(z$lo), ", ", fmt(z$hi), "]")
    )
    
    for (j in seq_along(vals)) {
      txt(cols[j], r$y, vals[j], room = room[j])
    }
    
    segments(map_x(z$lo), r$y, map_x(z$hi), r$y,
             lwd = 1.8, col = "black")
    points(map_x(z$g), r$y, pch = 15, cex = SQUARE_SIZE, col = "#25843D")
  }
  
  segments(forest_left, axis_y, forest_right, axis_y,
           lwd = 1.8, col = "black")
  
  tick_room <- forest_width / (length(ticks) - 1L) - 0.06
  for (tick in ticks) {
    x <- map_x(tick)
    segments(x, axis_y, x, axis_y + 0.08 * s, lwd = 1.3, col = "black")
    txt(x, axis_y + 0.24 * s, fmt(tick, 1L),
        scale = 0.90, align = 0.5, room = tick_room)
  }
  
  # These direction labels apply only to the ethanol intake outcome.
  txt(map_x(mean(c(limits[1], 0))), axis_y + 0.52 * s,
      " Favours antagonist", scale = 0.78, align = 0.5,
      room = map_x(0) - forest_left - 0.10)
  
  txt(map_x(mean(c(0, limits[2]))), axis_y + 0.52 * s,
      " Favours vehicle", scale = 0.78, align = 0.5,
      room = forest_right - map_x(0) - 0.10)
  
  txt(mean(c(forest_left, forest_right)), axis_y + 0.86 * s,
      "Standardized mean difference (Hedges' g)",
      scale = 0.98, bold = TRUE, align = 0.5,
      room = forest_width + 1.25)
  
  notes <- c(
    "Squares show individual contrasts; lines show 95% confidence intervals. T/C = treatment/control. No estimates were pooled.",
    "Locomotor effect signs are reproduced as supplied; verify their direction against the original reports before interpretation.",
    "Control results with confidence intervals crossing zero do not establish behavioural specificity."
  )
  
  for (i in seq_along(notes)) {
    txt(cols[1], axis_y + (1.16 + 0.25 * (i - 1L)) * s,
        notes[i], scale = 0.84, room = WIDTH - 0.65)
  }
  
  invisible(NULL)
}

args <- if (interactive()) character(0) else commandArgs(trailingOnly = TRUE)
out <- if (length(args)) args[1L] else file.path(getwd(), "figure_outputs")

if (!dir.exists(out)) dir.create(out, recursive = TRUE, showWarnings = FALSE)
if (!dir.exists(out)) stop("Cannot create output folder: ", out)
out <- normalizePath(out, winslash = "/", mustWork = TRUE)

stem <- file.path(out, "Fig7A_B_C_combined")

save_plot <- function(path, open_device) {
  tryCatch({
    open_device(path)
    device <- grDevices::dev.cur()
    tryCatch(draw(), finally = grDevices::dev.off(which = device))
    size <- file.info(path)$size
    if (is.na(size) || size <= 0) stop("Output file is missing or empty.")
    message("Saved: ", path)
  }, error = function(e) {
    stop("Could not export ", path, "\n", conditionMessage(e), call. = FALSE)
  })
}

save_plot(paste0(stem, ".pdf"), function(path) {
  if (capabilities("cairo")) {
    grDevices::cairo_pdf(path, width = WIDTH, height = HEIGHT)
  } else {
    grDevices::pdf(path, width = WIDTH, height = HEIGHT, useDingbats = FALSE)
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