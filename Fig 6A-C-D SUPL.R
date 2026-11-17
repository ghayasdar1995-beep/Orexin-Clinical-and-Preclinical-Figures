# Fig6ACD_withdrawal_combined.R
# Run: Rscript Fig6ACD_withdrawal_combined.R [output_directory]
# Base R only. Exports one combined forest plot as PDF and 300 dpi PNG.
# All effect estimates and confidence limits are copied from the supplied scripts.

WIDTH <- 20.5       # Figure width in inches
FONT_PT <- 17       # Main text size in points
DPI <- 300
POINT_SIZE <- 1.55
ZERO_LINE_WIDTH <- 3

d <- read.delim(
  text = "panel|id|study|substance|experiment|antagonist|receptor|dose|route|n_T|n_C|g|lo|hi
A|C125|Plaza-Zabala et al. (95)|Nicotine|Mecamylamine challenge|SB-334867|OX1R|5–10 mg/kg|i.p.|48|24|-0.7781176|-1.284322204|-0.271912997
A|C126|Plaza-Zabala et al. (95)|Nicotine|Mecamylamine challenge|SB-334867|OX1R|10 nmol/side|IC: PVN|13|13|-0.836404043|-1.63807354|-0.034734546
A|C127|Plaza-Zabala et al. (95)|Nicotine|Mecamylamine challenge|TCS-OX2-29|OX2R|5–10 mg/kg|i.p.|24|12|-0.060520643|-0.753613552|0.632572267
A|C128|Shoblock et al. (98)|Alcohol|Withdrawal score|JNJ-10397049|OX2R|1–10 mg/kg|s.c.|24|8|-0.062633708|-0.862932787|0.73766537
A|C187|Sharf et al. (50)|Morphine|Naloxone challenge|SB-334867|OX1R|20 mg/kg|i.p.|9|9|-1.3018006117|-2.3189193808|-0.2846818427
C|C191|Li et al. (35)|Morphine|During conditioning|SB-334867|OX1R|5–15 µg|intra-PVT|16|8|-0.0162508577|-0.8649682052|0.8324664899
C|C192|Li et al. (35)|Morphine|During conditioning|TCS-OX2-29|OX2R|5–15 µg|intra-PVT|16|8|-0.3457673963|-1.2000907499|0.5085559573
D|C193|Li et al. (35)|Morphine|Expression test|SB-334867|OX1R|15 µg|intra-PVT|8|8|0.2563271249|-0.7276889912|1.2403432409
D|C194|Li et al. (35)|Morphine|Expression test|TCS-OX2-29|OX2R|15 µg|intra-PVT|8|8|-0.3224334097|-1.3087806075|0.6639137881",
  sep = "|", quote = "", stringsAsFactors = FALSE
)

panels <- c(
  A = "A. Global somatic withdrawal score",
  C = "C. Withdrawal-related conditioned place aversion: acquisition",
  D = "D. Withdrawal-related conditioned place aversion: expression"
)

limits <- c(-2.5, 1.5)
ticks <- seq(-2.5, 1.5, by = 0.5)

stopifnot(
  nrow(d) == 9L,
  !anyDuplicated(d$id),
  identical(as.integer(table(factor(d$panel, levels = names(panels)))),
            c(5L, 2L, 2L)),
  all(is.finite(d$g) & is.finite(d$lo) & is.finite(d$hi)),
  all(d$lo <= d$g & d$g <= d$hi),
  all(d$lo >= limits[1] & d$hi <= limits[2]),
  all(d$n_T > 0 & d$n_C > 0)
)

# Horizontal positions scale with WIDTH; vertical spacing scales with FONT_PT.
cols <- WIDTH * c(0.35, 2.95, 6.20, 9.00, 10.80, 12.05, 17.85) / 20.5
forest_left <- WIDTH * 13.20 / 20.5
forest_right <- cols[7] - 0.30
left_margin <- cols[1]
spacing <- FONT_PT / 17

map_x <- function(g) {
  forest_left + (g - limits[1]) / diff(limits) *
    (forest_right - forest_left)
}

fmt <- function(x, digits = 2L) {
  sub("-", "\u2212", formatC(x, digits = digits, format = "f"),
      fixed = TRUE)
}

rows <- list()
y <- 1.50 * spacing

add_row <- function(type, label = "", index = NA_integer_) {
  rows[[length(rows) + 1L]] <<- list(
    type = type, label = label, index = index, y = y
  )
  y <<- y + spacing * switch(type, panel = 0.48,
                             substance = 0.37, study = 0.42)
}

for (panel in names(panels)) {
  add_row("panel", panels[[panel]])
  idx <- which(d$panel == panel)
  
  for (substance in unique(d$substance[idx])) {
    add_row("substance", substance)
    for (i in idx[d$substance[idx] == substance]) {
      add_row("study", index = i)
    }
  }
  
  y <- y + 0.13 * spacing
}

axis_y <- y + 0.12 * spacing
HEIGHT <- axis_y + 1.90 * spacing

draw <- function() {
  old_par <- par(
    mar = rep(0, 4), xaxs = "i", yaxs = "i",
    family = "sans", col = "black", bg = "white"
  )
  on.exit(par(old_par), add = TRUE)
  
  plot.new()
  plot.window(xlim = c(0, WIDTH), ylim = c(HEIGHT, 0))
  
  txt <- function(x, y, label, scale = 1, bold = FALSE, align = 0,
                  room = Inf) {
    face <- if (bold) 2 else 1
    cex <- FONT_PT / par("ps") * scale
    if (is.finite(room)) {
      w <- strwidth(label, units = "user", cex = cex, font = face)
      if (is.finite(w) && w > room) cex <- cex * 0.98 * room / w
    }
    text(x, y, label, adj = c(align, 0.5),
         cex = cex, font = face, col = "black")
  }
  
  headings <- c("Study", "Experiment", "Antagonist (receptor)", "Dose",
                "Route/site", "n (T/C)", "Hedges' g [95% CI]")
  room <- c(
    diff(cols[1:6]) - 0.14,
    forest_left - cols[6] - 0.14,
    WIDTH - cols[7] - 0.24
  )
  stopifnot(all(room > 0), forest_right > forest_left)
  
  for (r in rows) {
    if (r$type == "study") next
    half_h <- spacing * if (r$type == "panel") 0.17 else 0.14
    rect(0.24, r$y - half_h, WIDTH - 0.24, r$y + half_h,
         col = if (r$type == "panel") "#DCE7F0" else "#EFF3F7",
         border = NA)
  }
  
  segments(map_x(0), 1.23 * spacing, map_x(0), axis_y,
           col = "black", lwd = ZERO_LINE_WIDTH, lty = 1)
  
  txt(left_margin, 0.39 * spacing,
      "Figure 6A, C and D. Withdrawal outcomes",
      scale = 1.50, bold = TRUE, room = WIDTH - 2 * left_margin)
  
  for (j in seq_along(cols)) {
    txt(cols[j], 1.02 * spacing, headings[j],
        scale = 0.95, bold = TRUE, room = room[j])
  }
  
  for (r in rows) {
    if (r$type != "study") {
      txt(
        if (r$type == "panel") left_margin else left_margin + 0.12,
        r$y, r$label, scale = if (r$type == "panel") 1.10 else 1.02,
        bold = TRUE, room = WIDTH - 2 * left_margin - 0.12
      )
      next
    }
    
    z <- d[r$index, ]
    values <- c(
      z$study,
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
             col = "black", lwd = 1.8)
    points(map_x(z$g), r$y, pch = 15, cex = POINT_SIZE, col = "#25843D")
  }
  
  segments(forest_left, axis_y, forest_right, axis_y,
           col = "black", lwd = 1.7)
  
  tick_room <- (forest_right - forest_left) / (length(ticks) - 1L) - 0.06
  for (tick in ticks) {
    x <- map_x(tick)
    segments(x, axis_y, x, axis_y + 0.09 * spacing,
             col = "black", lwd = 1.3)
    txt(x, axis_y + 0.25 * spacing, fmt(tick, 1L),
        scale = 0.88, align = 0.5, room = tick_room)
  }
  
  txt(map_x(mean(c(limits[1], 0))), axis_y + 0.52 * spacing,
      "Favours antagonist", scale = 0.78, align = 0.5,
      room = map_x(0) - forest_left - 0.10)
  
  txt(map_x(mean(c(0, limits[2]))), axis_y + 0.52 * spacing,
      "Favours vehicle", scale = 0.78, align = 0.5,
      room = forest_right - map_x(0) - 0.10)
  
  txt(mean(c(forest_left, forest_right)), axis_y + 0.86 * spacing,
      "Standardized mean difference (Hedges' g)",
      scale = 1.05, bold = TRUE, align = 0.5,
      room = forest_right - forest_left + 1.25)
  
  notes <- c(
    "Squares show individual estimates; horizontal lines show 95% confidence intervals. T/C = treatment/control.",
    "The two Li contrasts within each conditioned place aversion panel share a control group. No estimates were pooled."
  )
  
  for (i in seq_along(notes)) {
    txt(left_margin, axis_y + (1.29 + 0.29 * (i - 1L)) * spacing,
        notes[i], scale = 0.86, room = WIDTH - 2 * left_margin)
  }
  
  invisible(NULL)
}

args <- commandArgs(trailingOnly = TRUE)
out <- if (length(args)) args[1L] else "."
dir.create(out, recursive = TRUE, showWarnings = FALSE)
stem <- file.path(out, "Fig6ACD_withdrawal_combined")

if (capabilities("cairo")) {
  cairo_pdf(paste0(stem, ".pdf"), width = WIDTH, height = HEIGHT)
} else {
  pdf(paste0(stem, ".pdf"), width = WIDTH, height = HEIGHT,
      useDingbats = FALSE)
}
tryCatch(draw(), finally = dev.off())

png_args <- list(
  filename = paste0(stem, ".png"), width = WIDTH, height = HEIGHT,
  units = "in", res = DPI, bg = "white"
)
if (capabilities("cairo")) png_args$type <- "cairo"
do.call(png, png_args)
tryCatch(draw(), finally = dev.off())