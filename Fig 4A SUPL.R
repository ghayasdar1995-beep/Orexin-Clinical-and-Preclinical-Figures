# Run: Rscript Fig4A_SUPL_solid_zero_large_text.R [output_directory]
# Values from master_data.xlsx, Effects (OP_CUE); no external files required.
# C085/C086: counterbalanced within-subject, despite the workbook design field.
# C088: context-induced, assigned to Fig 3D. C188: SB10 during both phases.
d <- read.delim(text = "id	study	experiment	substance	antagonist	receptor	route	dose	n_T	n_C	g	lo	hi	design
C083	Jupp et al. (64)	Immediate cue test	Alcohol	SB-334867	OX1R	i.p.	20 mg/kg	6	11	-1.329876018	-2.420420364	-0.239331673	parallel
C084	Jupp et al. (64)	Delayed cue test	Alcohol	SB-334867	OX1R	i.p.	20 mg/kg	11	11	-2.976348193	-4.189550241	-1.763146144	parallel
C085	Moorman et al. (55)	High responders	Alcohol	SB-334867	OX1R	i.p.	20 mg/kg	8	8				Within-subject
C086	Moorman et al. (55)	Low responders	Alcohol	SB-334867	OX1R	i.p.	20 mg/kg	8	8				Within-subject
C087	Brown et al. (68)	Cue reinstatement	Alcohol	SB-334867	OX1R	IC: PrL	3 μg/side	7	10	-1.907654440420425	-3.06700393380944	-0.7483049470314114	parallel
C089	Plaza-Zabala et al. (69)	Cue reinstatement	Nicotine	SB-334867	OX1R	i.p.	5–10 mg/kg	20	10	-1.175531848	-1.990818571	-0.360245125	parallel
C090	Plaza-Zabala et al. (69)	Cue reinstatement	Nicotine	TCS-OX2-29	OX2R	i.p.	5 and 10 mg/kg	18	9	0.1879664695633512	-0.6137545205127775	0.98968745963948	parallel
C091	Murray et al. (3)	Cue reinstatement	Nicotine	C4X3256	OX1R	p.o.	30 mg/kg	12	12	-1.433907897	-2.331010447	-0.536805346	parallel
C092	Murray et al. (3)	Cue reinstatement	Cocaine	C4X3256	OX1R	p.o.	30 mg/kg	11	11	-0.642024688	-1.499016041	0.214966665	parallel
C093	Khoo et al. (58)	Chronic treatment	Nicotine	TCS1102	DORA	i.c.v.	10 µg	7	6	-0.117835355156366	-1.209198951357336	0.9735282410446036	parallel
C094	Illenberger et al. (110)	Cue reinstatement	Oxycodone	Suvorexant	DORA	IC: pPVT	15 µg	5	8	-0.176898329	-1.296316763	0.942520105	parallel
C188	Zhou et al. (14)	Extinction + reinstatement	Cocaine	SB-334867	OX1R	i.p.	10 mg/kg	8	8	-1.077153213240839	-2.125813834379846	-0.02849259210183219	parallel", na.strings = "", quote = "", check.names = FALSE)
stopifnot(nrow(d)==12L, !anyDuplicated(d$id),
          identical(d$id[is.na(d$g)],c("C085","C086")),
          sum(is.finite(d$g))==10L, "C188" %in% d$id, !"C088" %in% d$id)

# Increase TEXT_SCALE or WIDTH if larger print is needed.
TEXT_SCALE <- 1.75
WIDTH <- 19.5
HEIGHT <- 14.6
d$route_class <- ifelse(grepl("^IC:|^i[.]c[.]v[.]$",d$route), "intracranial", "systemic")
d$group <- paste(d$substance, d$antagonist, d$receptor, d$route_class, sep=" | ")
substances <- split(d, factor(d$substance, levels=unique(d$substance)))
stopifnot(length(substances) == 4L, sum(vapply(substances,nrow,integer(1))) == 12L)

num <- function(x) sub("-", "−", sprintf("%.2f",x), fixed=TRUE)
pos <- function(x) 12.10 + (x+4.5)/6 * 4.05

draw <- function() {
  par(mar=rep(0,4), xaxs="i", yaxs="i", family="sans")
  plot.new()
  plot.window(xlim=c(0,WIDTH), ylim=c(HEIGHT,0))
  txt <- function(x,y,s,cex=1,font=1,adj=0)
    text(x,y,s,adj=c(adj,.5),cex=cex*TEXT_SCALE,font=font,col="black")
  txt(.32,.36,"Supplementary Figure 4A. Cue-induced operant reinstatement",1.46,2)
  x <- c(.34,4.0,7.55,9.36,11.02,16.48)
  for (i in seq_along(x))
    txt(x[i],.92,c("Study","Experiment","Dose","Route/site","n (T/C)","Hedges’ g [95% CI]")[i],1,2)
  axis_y <- 12.9
  # Draw the heading bands first; the zero line then stays visible over them.
  band_y <- 1.27
  for (a in substances) {
    rect(.31,band_y-.17,WIDTH-.33,band_y+.17,col="#E5EDF4",border=NA)
    band_y <- band_y + .41 + .45*length(unique(a$group)) + .44*nrow(a) + .06
  }
  stopifnot(band_y < axis_y)
  segments(pos(0),1.12,pos(0),axis_y,col="black",lty=1,lwd=3.2)
  y <- 1.27
  for (a in substances) {
    txt(.34,y,a$substance[1],1.10,2)
    y <- y+.41
    groups <- split(a, factor(a$group, levels=unique(a$group)))
    for (b in groups) {
      txt(.48,y,paste0(b$antagonist[1]," (",b$receptor[1],") · ",b$route_class[1]),.93,2)
      y <- y+.32
      for (i in seq_len(nrow(b))) {
        r <- b[i,]
        ok <- is.finite(r$g)
        effect <- if (ok) paste0(num(r$g)," [",num(r$lo),", ",num(r$hi),"]") else "Not estimable"
        vals <- c(r$study,r$experiment,r$dose,r$route,paste(r$n_T,r$n_C,sep="/"),effect)
        for (j in seq_along(vals)) txt(x[j],y,vals[j],.96)
        if (ok) {
          segments(pos(r$lo),y,pos(r$hi),y,lwd=1.25,col="black")
          points(pos(r$g),y,pch=15,col="#2CA02c",cex=1.05)
        }
        y <- y+.44
      }
      y <- y+.13
    }
    y <- y+.06
  }
  segments(pos(-4.5),axis_y,pos(1.5),axis_y)
  for (t in -4:1) {
    segments(pos(t),axis_y,pos(t),axis_y+.08)
    txt(pos(t),axis_y+.20,as.character(t),.90,adj=.5)
  }
  
  txt(pos(-2.25), axis_y + .49, "Favours antagonist", .78, adj = .5)
  txt(pos(0.75),  axis_y + .49, "Favours vehicle",    .78, adj = .5)
  
  txt(mean(pos(c(-4.5,1.5))), axis_y + .82,
      "Standardized mean difference (Hedges' g)", .95, adj = .5)
  
  txt(.34, axis_y + 1.24,
      "Moorman: paired estimates unavailable. n (T/C) = treatment/control.",
      .89)
}
args <- commandArgs(trailingOnly=TRUE)
out <- if (length(args)) args[1] else "."
dir.create(out, recursive=TRUE, showWarnings=FALSE)
stem <- file.path(out,"Fig4A_SUPL_solid_zero_large_text")
if (capabilities("cairo")) {
  cairo_pdf(paste0(stem,".pdf"),width=WIDTH,height=HEIGHT)
} else {
  pdf(paste0(stem,".pdf"),width=WIDTH,height=HEIGHT)
}
tryCatch(draw(),finally=dev.off())
png(paste0(stem,".png"),width=WIDTH,height=HEIGHT,units="in",res=300,
    type=if (capabilities("cairo")) "cairo" else getOption("bitmapType"))
tryCatch(draw(),finally=dev.off())