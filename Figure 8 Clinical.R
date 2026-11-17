# Compact, double-column version of the Clinical v8 forest plot.
# Input values are transcribed from the supplied Python script and figure.
# These historical pooled values are drawn directly, without refitting a model.
# Run: Rscript Figure_Forest_Clinical_v8_Nature.R [output_stem]

library(grid)

clinical <- data.frame(
  study = c("NCT04229095", "NCT05458609", "Huhn 2022", "Suchting 2020", "NCT04234997"),
  disorder = c("AUD", "AUD", "OUD", "CUD", "NicTUD"),
  drug = c("Suvorexant", "Lemborexant", "Suvorexant", "Suvorexant", "Suvorexant"),
  dose = c("20 mg", "10 mg + NAL", "20/40 mg", "10/20 mg", "20 mg"),
  route = "Oral",
  n = c("14/12", "3/3", "26/12", "10/10", "5/6"),
  effect = c(0.32, 0.04, -0.55, 0.34, 0.51),
  lower = c(-0.46, -1.56, -1.26, -0.55, -0.95),
  upper = c(1.09, 1.64, 0.15, 1.22, 1.96)
)

subgroups <- list(
  list(
    title = "1.1.1 Pooled clinical OXR-ANTs vs Placebo",
    subtitle = "(all substance-use conditions)",
    rows = 1:5, weights = c(28.5, 6.7, 34.5, 22.1, 8.2),
    pooled = c(0.02, -0.40, 0.43),
    heterogeneity = "Heterogeneity: Tau² = 0.00; I² = 0%; Q = 4.02 (df = 4), p = 0.400",
    test = "Test for overall effect: Z = 0.09 (P = 0.930)"
  ),
  list(
    title = "1.1.2 Alcohol use disorder: OXR-ANTs vs Placebo",
    subtitle = "",
    rows = c(1, 2), weights = c(81.0, 19.0),
    pooled = c(0.26, -0.43, 0.96),
    heterogeneity = "Heterogeneity: Tau² = 0.00; I² = 0%; Q = 0.09 (df = 1), p = 0.760",
    test = "Test for overall effect: Z = 0.74 (P = 0.458)"
  ),
  list(
    title = "1.1.3 Suvorexant 20 mg: alcohol and nicotine trials vs Placebo",
    subtitle = "(exploratory dose subgroup)",
    rows = c(1, 5), weights = c(77.8, 22.2),
    pooled = c(0.36, -0.33, 1.04),
    heterogeneity = "Heterogeneity: Tau² = 0.00; I² = 0%; Q = 0.05 (df = 1), p = 0.820",
    test = "Test for overall effect: Z = 1.03 (P = 0.304)"
  )
)

draw_clinical_forest <- function() {
  reference_width <- 183
  reference_height <- 116
  ink  <- "#1A1A1A"
  grey <- "#5A5A5A"
  rule <- "#888888"
  green <- "#1F6F5F"
  band  <- "#F2F4F3"
  columns <- c(study = 3, disorder = 28, drug = 42,
               dose = 62, route = 82, n = 93, estimate = 145, weight = 172)
  left  <- columns[["study"]]
  right <- 180
  forest_left  <- 103
  forest_right <- 142
  limits  <- c(-2.5, 2.5)
  axis_y  <- 102.5
  row_top <- 15.6
  study_height      <- 3.65
  pooled_height     <- 4.5
  diagnostic_height <- 2.9
  group_gap         <- 1.3
  header_height <- function(group) if (nzchar(group$subtitle)) 6.4 else 4.4

  npc_x    <- function(x) unit(x / reference_width, "npc")
  npc_y    <- function(y) unit(1 - y / reference_height, "npc")
  effect_x <- function(g) {
    forest_left + (g - limits[1]) / diff(limits) * (forest_right - forest_left)
  }

  label <- function(value, x, y, size = 6.5, face = "plain", color = ink,
                    align = "left", valign = "centre") {
    grid.text(value, npc_x(x), npc_y(y), just = c(align, valign),
              gp = gpar(fontfamily = "Arial", fontsize = size,
                        fontface = face, col = color))
  }

  line <- function(x1, y1, x2, y2, color = rule, width = 0.7, type = "solid") {
    grid.segments(npc_x(x1), npc_y(y1), npc_x(x2), npc_y(y2),
                  gp = gpar(col = color, lwd = width / 0.75, lty = type, lineend = "butt"))
  }

  interval <- function(effect, lower, upper) {
    sprintf("%.2f [%.2f; %.2f]", effect, lower, upper)
  }

  grid.newpage()
  grid.rect(gp = gpar(fill = "white", col = NA))

  # Paint all header bands before drawing the continuous zero line.
  cursor <- row_top
  for (group in subgroups) {
    grid.rect(npc_x(left), npc_y(cursor), npc_x(right - left),
              unit(header_height(group) / reference_height, "npc"),
              just = c("left", "top"), gp = gpar(fill = band, col = NA))
    cursor <- cursor + header_height(group) + study_height * length(group$rows) +
      pooled_height + 2 * diagnostic_height + group_gap
  }
  line(effect_x(0), row_top, effect_x(0), axis_y, width = 0.55, type = "dotted")

  label("Clinical OXR-ANTs vs Placebo — Substance-Use Outcomes",
        left, 2.5, 7, "bold", valign = "top")
  label("Standardised mean difference (SMD), IV, Random, 95% CI",
        left, 6.3, 6, color = ink, valign = "top")            # ← was grey
  label(c("Study", "Disorder", "Drug", "Dose(s)", "Route", "n (T/C)",
          "SMD [95% CI]", "Weight"), columns, 12.2, 7, "bold")
  line(left, 14.2, right, 14.2, width = 0.5)

  cursor <- row_top
  for (group_index in seq_along(subgroups)) {
    group <- subgroups[[group_index]]
    has_subtitle <- nzchar(group$subtitle)
    label(group$title, left + 0.6, cursor + 2.2, 7, "bold")
    if (has_subtitle) label(group$subtitle, left + 0.6, cursor + 4.7, 6)
    cursor <- cursor + header_height(group)

    for (index in seq_along(group$rows)) {
      study  <- clinical[group$rows[index], ]
      weight <- group$weights[index]
      y <- cursor + study_height / 2
      label(study$study, left + 0.6, y)
      label(c(study$disorder, study$drug, study$dose, study$route, study$n),
            columns[c("disorder", "drug", "dose", "route", "n")], y)
      line(effect_x(max(study$lower, limits[1])), y,
           effect_x(min(study$upper, limits[2])), y, ink, 0.8)
      for (end in c("lower", "upper")) {
        bound <- study[[end]]
        if (bound >= limits[1] && bound <= limits[2]) next
        edge   <- if (end == "lower") limits[1] else limits[2]
        inward <- if (end == "lower") 0.12 else -0.12
        grid.segments(npc_x(effect_x(edge + inward)), npc_y(y),
                      npc_x(effect_x(edge)), npc_y(y),
                      gp = gpar(col = ink, lwd = 0.8 / 0.75),
                      arrow = arrow(length = unit(4, "pt"), type = "open"))
      }
      side <- unit(sqrt(1.1 + 2.7 * weight / max(group$weights)), "mm")
      grid.rect(npc_x(effect_x(study$effect)), npc_y(y), side, side,
                gp = gpar(fill = green, col = NA))
      label(interval(study$effect, study$lower, study$upper), columns[["estimate"]], y)
      label(sprintf("%.1f%%", weight), columns[["weight"]], y)
      cursor <- cursor + study_height
    }

    pooled_y    <- cursor + pooled_height / 2
    half_height <- 1.2
    pooled      <- group$pooled
    line(left, cursor, right, cursor, width = 0.45)
    label(sprintf("Random-effects model    k = %d studies    REML; DerSimonian-Laird",
                  length(group$rows)), left + 0.6, pooled_y, 6.5, "bold")
    label(interval(pooled[1], pooled[2], pooled[3]), columns[["estimate"]], pooled_y, 7, "bold")
    label("100%", columns[["weight"]], pooled_y, 7, "bold")
    if (group_index == 1L) {
      grid.polygon(
        npc_x(effect_x(c(pooled[2], pooled[1], pooled[3], pooled[1]))),
        npc_y(c(pooled_y, pooled_y - half_height, pooled_y, pooled_y + half_height)),
        gp = gpar(fill = "black", col = NA)
      )
    }
    cursor <- cursor + pooled_height
    line(left, cursor, right, cursor, width = 0.35)
    label(group$heterogeneity, left + 0.6, cursor + diagnostic_height * 0.55, 6, "plain", ink)  # ← was grey
    label(group$test,          left + 0.6, cursor + diagnostic_height * 1.55, 6, "plain", ink)  # ← was grey
    cursor <- cursor + 2 * diagnostic_height + group_gap
  }

  line(left, cursor, right, cursor, width = 0.55)
  line(forest_left, axis_y, forest_right, axis_y, grey, 0.8)
  ticks <- -2:2
  line(effect_x(ticks), axis_y, effect_x(ticks), axis_y + 1.0, grey, 0.55)
  label(ticks, effect_x(ticks), axis_y + 2.8, 6.5, color = ink, align = "centre")             # ← was grey
  label("Standardised mean difference (Hedges' g)", effect_x(0), axis_y + 5.8,
        6.5, color = ink, align = "centre")                                                     # ← was grey
  label("Favours OXR-ANTs", effect_x(-0.15), axis_y + 10.0, 6, "italic", ink, "right")        # ← was grey
  label("Favours Placebo",  effect_x(0.15),  axis_y + 10.0, 6, "italic", ink)                 # ← was grey
}

main <- function(args = commandArgs(trailingOnly = TRUE)) {
  if (length(args) > 1L) stop("Usage: Rscript Figure_Forest_Clinical_v8_Nature.R [output_stem]")
  output_stem <- if (length(args)) args[[1]] else "Figure_Forest_Clinical_v8_Nature"
  dir.create(dirname(output_stem), recursive = TRUE, showWarnings = FALSE)
  dpi    <- 600
  width  <- 183 / 25.4
  height <- 116 / 25.4

  devices <- list(
    png = function(file) png(file, width, height, units = "in", res = dpi,
                             bg = "white", type = "cairo"),
    pdf = function(file) cairo_pdf(file, width, height, bg = "white", family = "Arial")
  )
  for (extension in names(devices)) {
    file <- paste0(output_stem, ".", extension)
    devices[[extension]](file)
    tryCatch(draw_clinical_forest(), finally = dev.off())
    message("Saved ", file)
  }
}

if (sys.nframe() == 0L) main()
