# Usage: Rscript Fig5AB_self_administration_combined.R [output_directory]
# Embedded estimates copied from the two supplied Figure 4 Python scripts.
d <- read.delim(text="panel_label	contrast_id	substance	study	label	antagonist	receptor	dose	route	n_T	n_C	g	ci_lo	ci_hi
A	C113	Alcohol	Richards et al. (46)	Self-administration	SB-334867	OX1R	5–20 mg/kg	i.p.	32.0	8.0	-1.3201153092	-2.1471187352	-0.4931118831
A	C114	Nicotine	LeSage et al. (7)	FR5 responding	SB-334867	OX1R	10–30 mg/kg	i.p.	27.0	9.0	-0.79313849	-1.569455497	-0.016821484
A	C115	Nicotine	LeSage et al. (7)	FR5 responding	Almorexant	DORA	100–300 mg/kg	p.o.	14.0	7.0	-0.752488376	-1.68788125	0.182904499
A	C116	Nicotine	Khoo et al. (58)	Self-administration	TCS1102	DORA	1–10 µg	i.c.v.\t13.0\t13.0\t\t\t
A	C117	Alcohol	Shoblock et al. (98)	Self-administration	JNJ-10397049	OX2R	1–10 mg/kg	s.c.	18.0	6.0	-0.506954081	-1.441954367	0.428046205
A	C185	Alcohol	Dhaher et al. (70)	After deprivation	SB-334867	OX1R	10–20 mg/kg	i.p.	16.0	8.0	-1.9993144233	-3.0192231913	-0.9794056553
A	C195	Nicotine	Murray et al. (3)	Self-administration	C4X3256	OX1R	3–30 mg/kg	p.o.	27.0	9.0	-0.2459182469	-1.0024581632	0.5106216694
B	C118	Cocaine	Prince et al. (52)	Breakpoint	SB-334867	OX1R	7.5–30 mg/kg	i.p.	21.0	9.0	-1.299853186	-2.147161885	-0.452544486
B	C119	Cocaine	Prince et al. (52)	Breakpoint	Almorexant	DORA	25–100 mg/kg	i.p.	21.0	7.0	-1.17682235	-2.086057109	-0.267587591",quote="",na.strings="",check.names=FALSE)
# C116: 13/13 indicates the same 13 rats under both conditions.
# The paired effect and confidence limits remain unavailable.
stopifnot(identical(as.integer(table(d$panel_label)),c(7L,2L)),
          !anyDuplicated(d$contrast_id), sum(is.finite(d$g))==8L,
          identical(d$contrast_id[is.na(d$g)],"C116"))
WIDTH <- 19.4
HEIGHT <- 9.25
TEXT_SCALE <- 1.35
limits <- c(-3.5,1)
pos <- function(x) 12.65+(x-limits[1])/diff(limits)*3.45
panels <- c(A="A. Fixed-ratio responding",B="B. Progressive-ratio breakpoint")
num <- function(x) sub("-","−",sprintf("%.2f",x),fixed=TRUE)
cols <- c(.35,2.95,5.68,8.68,10.57,11.45,16.42)
layout <- list()
y <- 1.57
add <- function(kind,label="",r=NULL) {
  layout[[length(layout)+1L]] <<- list(kind=kind,label=label,r=r,y=y)
  y <<- y+switch(kind,panel=.53,substance=.42,study=.40)
}
for (panel in names(panels)) {
  add("panel",panels[[panel]])
  a <- d[d$panel_label==panel,]
  for (substance in unique(a$substance)) {
    add("substance",substance)
    b <- a[a$substance==substance,]
    for (i in seq_len(nrow(b))) add("study",r=b[i,])
  }
  y <- y+.14
}
axis_y <- y+.04
stopifnot(axis_y+1.08 < HEIGHT,
          all(d$ci_lo[is.finite(d$g)]>=limits[1]),
          all(d$ci_hi[is.finite(d$g)]<=limits[2]))
draw <- function() {
  par(mar=rep(0,4),xaxs="i",yaxs="i",family="sans")
  plot.new()
  plot.window(xlim=c(0,WIDTH),ylim=c(HEIGHT,0))
  txt <- function(x,y,label,size=1,bold=FALSE,align=0)
    text(x,y,label,col="black",cex=size*TEXT_SCALE,font=if (bold) 2 else 1,adj=c(align,.5))
  txt(.35,.43,"Figure 5A–B. Operant self-administration",1.5,TRUE)
  headers <- c("Study","Experiment","Antagonist (receptor)","Dose","Route","n (T/C)","Hedges’ g [95% CI]")
  for (i in seq_along(cols)) txt(cols[i],1.06,headers[i],.95,TRUE)
  for (row in layout) if (row$kind!="study")
    rect(.28,row$y-.16,WIDTH-.28,row$y+.16,border=NA,
         col=if (row$kind=="panel") "#D9E7F3" else "#EEF3F8")
  segments(pos(0),1.35,pos(0),axis_y,lwd=2.8,col="black")
  for (row in layout) {
    yy <- row$y
    if (row$kind!="study") {
      txt(if (row$kind=="panel") .35 else .50,yy,row$label,
          if (row$kind=="panel") 1.12 else 1.02,TRUE)
      next
    }
    r <- row$r
    ok <- is.finite(r$g)
    marker <- if (r$contrast_id=="C113") " " else if (r$contrast_id=="C116") " " else ""
    effect <- if (ok) paste0(num(r$g)," [",num(r$ci_lo),", ",num(r$ci_hi),"]") else "Not estimable"
    values <- c(paste0(r$study,marker),r$label,paste0(r$antagonist," (",r$receptor,")"),
                r$dose,r$route,paste0(ifelse(is.na(r$n_T),"—",r$n_T),"/",r$n_C),effect)
    for (i in seq_along(cols)) txt(cols[i],yy,values[i],.93)
    if (ok) {
      segments(pos(r$ci_lo),yy,pos(r$ci_hi),yy,lwd=1.8,col="black")
      points(pos(r$g),yy,pch=15,cex=1.4,col="#2CA02C")
    }
  }
  segments(pos(limits[1]),axis_y,pos(limits[2]),axis_y,lwd=1.6)
  for (tick in -3:1) {
    segments(pos(tick),axis_y,pos(tick),axis_y+.08,lwd=1.3)
    txt(pos(tick),axis_y+.22,tick,.91,align=.5)
  }
  
  txt(pos(mean(c(limits[1], 0))), axis_y + .49,
      "Favours antagonist", size = .78, align = .5)
  txt(pos(mean(c(0, limits[2]))), axis_y + .49,
      "Favours vehicle", size = .78, align = .5)
  
  txt(mean(pos(limits)), axis_y + .82,
      "Standardized mean difference (Hedges' g)",
      size = 1, bold = TRUE, align = 0.5)
}  # End draw()

args <- if (interactive()) character(0) else commandArgs(trailingOnly = TRUE)
out <- if (length(args)) args[1L] else file.path(getwd(), "figure_outputs")

if (!dir.exists(out)) dir.create(out, recursive = TRUE)
if (!dir.exists(out)) stop("Cannot create output folder: ", out)

out <- normalizePath(out, winslash = "/", mustWork = TRUE)
stem <- file.path(out, "Fig5AB_self_administration_combined")

pdf_path <- paste0(stem, ".pdf")
if (capabilities("cairo")) {
  cairo_pdf(pdf_path, width = WIDTH, height = HEIGHT)
} else {
  pdf(pdf_path, width = WIDTH, height = HEIGHT, useDingbats = FALSE)
}
tryCatch(draw(), finally = dev.off())
message("Saved PDF: ", pdf_path)

png_path <- paste0(stem, ".png")
png_args <- list(
  filename = png_path, width = WIDTH, height = HEIGHT,
  units = "in", res = 300, bg = "white"
)
if (capabilities("cairo")) png_args$type <- "cairo"
do.call(png, png_args)
tryCatch(draw(), finally = dev.off())
message("Saved PNG: ", png_path)