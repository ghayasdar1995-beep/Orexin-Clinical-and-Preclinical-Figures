# Usage: Rscript Fig4B-D_REML_heterogeneity_final.R [output_directory]
# Embedded data checked against master_data.xlsx (Effects and Pooled_Primary).
read_embedded <- function(x) read.delim(text=x, quote="", na.strings="", check.names=FALSE)
d <- read_embedded("contrast_id	panel	study	substance	antagonist	receptor	route_class	route	dose	n_T	n_C	g	ci_lo	ci_hi	label
C088	OP_COMBINED	Smith et al. (97)	Cocaine	SB-334867	OX1R	Systemic	i.p.	30 mg/kg	15	12	-1.17382689892445	-1.994946801603	-0.3527069962458987	Context reinstatement
C102	OP_STRESS	Richards et al. (46)	Alcohol	SB-334867	OX1R	Systemic	i.p.	5–10 mg/kg	16	8	-1.477613326	-2.423661523	-0.531565129	Yohimbine
C103	OP_STRESS	Boutrel et al. (106)	Cocaine	SB-334867	OX1R	Systemic	i.p.	15–30 mg/kg	13	14	-0.6846216098521078	-1.461300229057407	0.0920570093531909	Footshock
C104	OP_STRESS	Plaza-Zabala et al. (118)	Nicotine	SB-334867	OX1R	Systemic	i.p.	5–10 mg/kg	13	14	0.611900935	-0.16044775	1.38424962	Footshock
C105	OP_STRESS	Flores-Ramirez et al. (56)	Alcohol	TCS1102	DORA	Intracranial	IC: pPVT	15 µg/side	6	6	-1.704791761	-3.026031084	-0.383552437	Footshock (dependent)
C106	OP_STRESS	Flores-Ramirez et al. (56)	Alcohol	TCS1102	DORA	Intracranial	IC: pPVT	15 µg/side	6	6	-0.169413342	-1.303027112	0.964200428	Footshock (nondependent)
C107	OP_STRESS	Flores-Ramirez et al. (79)	Alcohol	TCS1102	DORA	Intracranial	IC: IL	15 µg/side	12	12	-0.946330931	-1.790080742	-0.10258112	Footshock (dependent)
C108	OP_STRESS	Flores-Ramirez et al. (79)	Alcohol	TCS1102	DORA	Intracranial	IC: IL	15 µg/side	12	12	-0.184664657	-0.986520172	0.617190857	Footshock (nondependent)
C109	OP_STRESS	Flores-Ramirez et al. (100)	Alcohol	TCS1102	DORA	Intracranial	IC: IL	15 µg/side	8	8	0.84722184	-0.175779443	1.870223124	Footshock
C110	OP_STRESS	Illenberger et al. (110)	Oxycodone	Suvorexant	DORA	Intracranial	IC: pPVT	15 µg	6	7	-1.044501754	-2.206488903	0.117485395	Footshock
C111	OP_COMBINED	Khoo et al. (58)	Nicotine	TCS1102	DORA	Intracranial	i.c.v.	10 µg	6	6	-0.531273708893771	-1.68264841358916	0.6201009958016176	Cue + prime (chronic)
C112	OP_COMBINED	Khoo et al. (58)	Nicotine	TCS1102	DORA	Intracranial	i.c.v.	10–30 µg		14				Cue + prime (short)
C186	OP_COMBINED	Dhaher et al. (70)	Alcohol	SB-334867	OX1R	Systemic	i.p.	10–20 mg/kg	16	8	-0.1222652757164523	-0.971674718862063	0.7271441674291584	Spontaneous recovery
C189	OP_PRIME	Mahler et al. (40)	Cocaine	SB-334867	OX1R	Systemic	i.p.	10–30 mg/kg	26	17	-0.08520755085325961	-0.6968076112263136	0.5263925095197944	Drug prime
C190	OP_COMBINED	Murray et al. (3)	Nicotine	C4X3256	OX1R	Systemic	p.o.	30 mg/kg	13	13	-0.7165322419113813	-1.509592870252964	0.07652838643020088	Cue + prime")
pool <- read_embedded("panel	substance	antagonist	receptor	route_class	g	ci_lo	ci_hi	df_t	k_pooled	k_studies_pooled	pooled_contrasts
OP_STRESS	Alcohol	TCS1102	DORA	Intracranial	-0.6648837088792393	-1.717835422728146	0.3880680049696673	3	4	2	C105, C106, C107, C108")
stopifnot(nrow(d)==15L, sum(is.finite(d$g))==14L, identical(d$contrast_id[is.na(d$g)],"C112"),
          nrow(pool)==1L, identical(pool$pooled_contrasts,"C105, C106, C107, C108"))
# Refit the workbook's cohort-level random-effects model using base R.
# Variances are from master_data.xlsx, Effects, matched by contrast ID.
sampling_variance <- c(C105=0.454429789, C106=0.334529203,
                       C107=0.185323796, C108=0.167377105)
members <- trimws(strsplit(pool$pooled_contrasts,",",fixed=TRUE)[[1]])
included <- d[match(members,d$contrast_id),]
yi <- included$g
vi <- unname(sampling_variance[members])
k <- length(yi)
stopifnot(k==4L, length(unique(included$study))==2L,
          all(is.finite(yi)), all(is.finite(vi) & vi>0), !"C109" %in% members)
reml_objective <- function(tau2) {
  w <- 1/(vi+tau2)
  mu <- sum(w*yi)/sum(w)
  sum(log(vi+tau2)) + log(sum(w)) + sum(w*(yi-mu)^2)
}
upper <- 10*max(stats::var(yi),max(vi))
opt <- optimize(reml_objective,c(0,upper),tol=1e-11)
stopifnot(opt$minimum < .999*upper)
tau2 <- if (reml_objective(0)<=opt$objective) 0 else opt$minimum
w <- 1/(vi+tau2)
mu <- sum(w*yi)/sum(w)
df_ci <- k-1L
df_pi <- k-2L
q_star <- max(1,sum(w*(yi-mu)^2)/df_ci)
se_hksj <- sqrt(q_star/sum(w))
ci <- mu + c(-1,1)*qt(.975,df_ci)*se_hksj
pi <- mu + c(-1,1)*qt(.975,df_pi)*sqrt(tau2+se_hksj^2)
# Use the embedded workbook estimates as regression checks, not plot inputs.
stopifnot(max(abs(c(mu,ci,tau2,pi)-c(pool$g,pool$ci_lo,pool$ci_hi,
                                     .1352844167478544,-2.793520087203399,1.46375266944492)))<1e-6)
pool$g <- mu
pool$ci_lo <- ci[1]
pool$ci_hi <- ci[2]
pool$df_t <- df_ci
# Cochran's Q uses inverse sampling-variance weights under the null.
w_fixed <- 1/vi
mu_fixed <- sum(w_fixed*yi)/sum(w_fixed)
Q <- sum(w_fixed*(yi-mu_fixed)^2)
Q_df <- k-1L
Q_p <- pchisq(Q,Q_df,lower.tail=FALSE)
# Match the workbook's Q-based I² convention; τ² is estimated by REML.
I2 <- if (Q>0) 100*max(0,1-Q_df/Q) else 0
stopifnot(max(abs(c(Q,Q_p,I2)-c(4.900948891982363,.1791955064965904,
                                38.78736411824643)))<1e-4)
pool$Q <- Q
pool$Q_df <- Q_df
pool$Q_p <- Q_p
pool$I2_percent <- I2
pool$tau2 <- tau2
pool$se_hksj <- se_hksj
pool$p <- 2*pt(-abs(mu/se_hksj),df_ci)
pool$pi_lo <- pi[1]
pool$pi_hi <- pi[2]
pool$df_pi <- df_pi
TEXT_SCALE <- 2.10
WIDTH <- 26.3
panels <- c(OP_PRIME="4B. Drug-prime reinstatement",
            OP_STRESS="4C. Stress-induced reinstatement",
            OP_COMBINED="4D. Other reinstatement paradigms")
key <- function(x) with(x,paste(panel,substance,antagonist,receptor,route_class,sep=" | "))
d$key <- key(d)
pool$key <- key(pool)
num <- function(x) sub("-", "−", sprintf("%.2f",x), fixed=TRUE)
fmt <- function(g,l,u) paste0(num(g)," [",num(l),", ",num(u),"]")
lims <- c(-3.2,2.1)
pos <- function(x) 13.90 + (x-lims[1])/diff(lims)*7.70
ci_values <- c(d$ci_lo,d$ci_hi,pool$ci_lo,pool$ci_hi,pool$pi_lo,pool$pi_hi)
stopifnot(all(ci_values[is.finite(ci_values)] >= lims[1]), all(ci_values[is.finite(ci_values)] <= lims[2]))
# Plan rows first, so headings and effects use the same spacing on both devices.
layout <- list()
y <- 1.48
add <- function(kind,label="",r=NULL) {
  layout[[length(layout)+1L]] <<- list(kind=kind,label=label,r=r,y=y)
  y <<- y + switch(kind, panel=.65, substance=.50, group=.46, study=.49, pooled=.94)
}
substance_order <- c("Alcohol", "Nicotine", "Cocaine", "Oxycodone")
stopifnot(setequal(substance_order, unique(d$substance)))
for (panel in names(panels)) {
  a <- d[d$panel==panel,]
  add("panel",panels[[panel]])
  for (substance in substance_order) {
    b <- a[a$substance==substance,]
    if (!nrow(b)) next
    add("substance",substance)
    for (k in unique(b$key)) {
      cset <- b[b$key==k,]
      add("group",with(cset[1,],paste0(antagonist," (",receptor,") · ",tolower(route_class))))
      for (i in seq_len(nrow(cset))) add("study",r=cset[i,])
      if (k %in% pool$key) add("pooled",r=pool[pool$key==k,])
      y <- y+.08
    }
  }
  y <- y+.13
}
kinds <- vapply(layout,function(x) x$kind,character(1))
headings <- vapply(layout[kinds=="panel"],function(x) x$label,character(1))
ids <- vapply(layout[kinds=="study"],function(x) x$r$contrast_id,character(1))
stopifnot(identical(headings,unname(panels)), length(ids)==nrow(d),
          !anyDuplicated(ids), setequal(ids,d$contrast_id), sum(kinds=="pooled")==1L)
axis_y <- y+.02
HEIGHT <- axis_y+2.30
draw <- function() {
  par(mar=rep(0,4), xaxs="i", yaxs="i", family="sans")
  plot.new()
  plot.window(xlim=c(0,WIDTH),ylim=c(HEIGHT,0))
  txt <- function(x,y,s,cex=1,font=1,adj=0)
    text(x,y,s,adj=c(adj,.5),cex=cex*TEXT_SCALE,font=font,col="black")
  txt(.35,.38,"Figure 4B–D. Operant reinstatement by trigger",1.45,2)
  x <- c(.41,4.88,9.02,11.28,13.17,22.06)
  for (i in seq_along(x)) txt(x[i],.97,c("Study","Experiment name","Dose","Route/site","n (T/C)","Hedges’ g [95% CI]")[i],.98,2)
  # Paint the heading bands first so the zero line stays continuous.
  for (line in layout[kinds %in% c("panel","substance")]) {
    yy <- line$y
    rect(.30,yy-.16,WIDTH-.30,yy+.16,border=NA,
         col=if (line$kind=="panel") "#D9E7F3" else "#EEF3F8")
  }
  segments(pos(0),axis_y,pos(0),1.22,lty=1,lwd=3.2,col="black")
  # Draw the subgroup's pooled-effect guide behind the study estimates.
  for (summary_row in layout[kinds=="pooled"]) {
    r <- summary_row$r
    members <- trimws(strsplit(r$pooled_contrasts,",",fixed=TRUE)[[1]])
    member_rows <- Filter(function(z) z$r$contrast_id %in% members, layout[kinds=="study"])
    stopifnot(length(member_rows)==r$k_pooled)
    start_y <- min(vapply(member_rows,function(z) z$y,numeric(1))) - .20
    segments(pos(r$g),start_y,pos(r$g),summary_row$y+.21,
             lty=3,lwd=1.6,col="black")
  }
  for (line in layout) {
    yy <- line$y
    r <- line$r
    if (line$kind %in% c("panel","substance")) {
      txt(if (line$kind=="panel") .38 else .53,yy,line$label,if (line$kind=="panel") 1.12 else .98,2)
    } else if (line$kind=="group") {
      txt(.55,yy,line$label,.89,2)
    } else if (line$kind=="study") {
      finite <- is.finite(r$g)
      n <- paste(ifelse(is.na(r$n_T),"—",r$n_T),ifelse(is.na(r$n_C),"—",r$n_C),sep="/")
      lab <- paste0(r$study,if (r$contrast_id=="C109") " " else "")
      vals <- c(lab,r$label,r$dose,r$route,n,
                if (finite) fmt(r$g,r$ci_lo,r$ci_hi) else "Not estimable ‡")
      for (i in seq_along(vals)) txt(x[i],yy,vals[i],.91)
      if (finite) {
        segments(pos(r$ci_lo),yy,pos(r$ci_hi),yy,lwd=2.2,col="black")
        points(pos(r$g),yy,pch=15,col="#2CA02c",cex=2.05)
      }
    } else {
      txt(x[1],yy,"Random effects (REML / HKSJ)",.86,2)
      txt(x[2],yy,sprintf("%d cohorts / %d studies; df = %d",r$k_pooled,r$k_studies_pooled,r$df_t),.87)
      polygon(pos(c(r$ci_lo,r$g,r$ci_hi,r$g)),yy+c(0,-.16,0,.16),
              col="black",border="black",lwd=1.2)
      segments(pos(r$g),yy-.13,pos(r$g),yy+.13,
               lty=3,lwd=1.55,col="white")
      txt(x[6],yy,fmt(r$g,r$ci_lo,r$ci_hi),.95,2)
      segments(pos(r$pi_lo),yy+.27,pos(r$pi_hi),yy+.27,lwd=2.7,col="#C52222")
      for (end in c(r$pi_lo,r$pi_hi))
        segments(pos(end),yy+.22,pos(end),yy+.32,lwd=1.8,col="#C52222")
      txt(x[6],yy+.32,paste0("95% PI [",num(r$pi_lo),", ",num(r$pi_hi),"]"),.82)
      txt(x[1],yy+.36,sprintf("Heterogeneity: τ² = %.3f; I² = %.1f%%; Q(%d) = %.2f, p = %.3f",
                              r$tau2,r$I2_percent,r$Q_df,r$Q,r$Q_p),.82)
      
      
    }
  }
  segments(pos(lims[1]),axis_y,pos(lims[2]),axis_y,lwd=1.8)
  for (tick in -3:2) {
    segments(pos(tick),axis_y,pos(tick),axis_y+.12,lwd=1.5)
    txt(pos(tick),axis_y+.27,tick,1.02,adj=.5)
  }
  txt(pos(mean(c(lims[1], 0))), axis_y+.61, "Favours antagonist", .78, adj=.5)
  txt(pos(mean(c(0, lims[2]))), axis_y+.61, "Favours vehicle", .78, adj=.5)
  txt(mean(pos(lims)), axis_y+.96,
      "Standardized mean difference (Hedges' g)", .95, adj=.5)
  txt(.35,axis_y+1.36,"† Possible cohort overlap; shown individually and excluded from the pooled estimate.",.84)
  txt(.35,axis_y+1.96,"Red bar: 95% prediction interval. Dotted line: pooled estimate. Solid black line: zero effect.",.84)
  txt(.35,axis_y+1.66,"‡ Within-subject contrast; paired estimate unavailable. T/C = treatment/control.",.84)
}
args <- commandArgs(trailingOnly=TRUE)
out <- if (length(args)) args[1] else "."
dir.create(out,recursive=TRUE,showWarnings=FALSE)
stem <- file.path(out,"Fig4B-D_REML_heterogeneity_final")
write.csv(pool[,setdiff(names(pool),"key")],paste0(stem,"_model.csv"),row.names=FALSE)
if (capabilities("cairo")) {
  cairo_pdf(paste0(stem,".pdf"),width=WIDTH,height=HEIGHT)
} else {
  pdf(paste0(stem,".pdf"),width=WIDTH,height=HEIGHT)
}
tryCatch(draw(),finally=dev.off())
png(paste0(stem,".png"),width=WIDTH,height=HEIGHT,units="in",res=300,
    type=if (capabilities("cairo")) "cairo" else getOption("bitmapType"))
tryCatch(draw(),finally=dev.off())
