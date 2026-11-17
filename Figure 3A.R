# Figure 3A: publication layout. Base R and grid; Cairo graphics required.
# Rscript Fig3A_CPP_acquisition_annotations.R [output_directory]
# TRUE suppresses strata with one study in the plotted panel.
# All source rows remain embedded; pooled results are imported, not refit.
hide_single_study <- TRUE
library(grid)
effects <- read.delim(text = "contrast_id	study	label	substance	group	antagonist	receptor	route_class	experiment	dose	route	n	g	var	ci_lo	ci_hi
C011	Narita et al. (128)	Narita et al. (128)	Morphine	Morphine · SB-334867 (OX1R) · Intracranial	SB-334867	OX1R	Intracranial	VTA OX1R	0.1–10 nmol	IC: VTA	24/8	-0.674589701	0.173777155	-1.491631803	0.1424524
C010	Riahi et al. (63)	Riahi et al. (63)	Morphine	Morphine · SB-334867 (OX1R) · Intracranial	SB-334867	OX1R	Intracranial	dHPC OX1R	10–40 nmol/side	IC: dorsal HPC	21/7	-1.111046487	0.212519481	-2.014586663	-0.207506311
C009	Zarepour et al. (73)	Zarepour et al. (73)	Morphine	Morphine · SB-334867 (OX1R) · Intracranial	SB-334867	OX1R	Intracranial	VTA OX1R 	0.1–10 nmol	IC: VTA	21/7	-0.908261335	0.205207238	-1.796121214	-0.020401455
C002	Guo et al. (62)	Guo et al. (62)	Morphine	Morphine · SB-334867 (OX1R) · Intracranial	SB-334867	OX1R	Intracranial	DG OX1R	0.25–2 pmol/side	IC: DG	36/12	-0.922862814	0.119982734	-1.601765412	-0.243960215
C007	Alizamini et al. (94)	Alizamini et al. (94)	Morphine	Morphine · SB-334867 (OX1R) · Intracranial	SB-334867	OX1R	Intracranial	NAc OX1R	1–30 nM/side	IC: NAc	24/6	-1.536521628	0.247681645	-2.511949153	-0.561094103
C005	Farahimanesh et al. (90)	Farahimanesh et al. (90)	Morphine	Morphine · SB-334867 (OX1R) · Intracranial	SB-334867	OX1R	Intracranial	VTA OX1R	0.1–10 nM/rat	IC: VTA	17/6	-1.15425816	0.254453498	-2.142930325	-0.165585994
C001	Jamali et al. (4)	Jamali et al. (4)	Morphine	Morphine · SB-334867 (OX1R) · Intracranial	SB-334867	OX1R	Intracranial	mPFC OX1R	3–30 nM/side	IC: mPFC	24/9	-0.773416107	0.161840997	-1.561899167	0.015066953
C012	Tabaeizadeh et al. (103)	Tabaeizadeh et al. (103)	Morphine	Morphine · SB-334867 (OX1R) · Systemic	SB-334867	OX1R	Systemic	OX1R	10–30 mg/kg	i.p.	24/8	-0.466268496	0.17006364	-1.274533602	0.34199661
C003	Guo et al. (62)	Guo et al. (62)	Morphine	Morphine · SB-408124 (OX1R) · Intracranial	SB-408124	OX1R	Intracranial	DG OX1R	100 pmol/side	IC: DG	12/12	-0.08911325	0.166832108	-0.889662237	0.711435738
C004	Guo et al. (62)	Guo et al. (62)	Morphine	Morphine · TCS-OX2-29 (OX2R) · Intracranial	TCS-OX2-29	OX2R	Intracranial	DG OX2R	0.25–2 pmol/side	IC: DG	24/12	-0.14183705	0.125279413	-0.835563014	0.551888915
C016	Sadeghi et al. (126)	Sadeghi et al. (126)	Morphine	Morphine · TCS-OX2-29 (OX2R) · Intracranial	TCS-OX2-29	OX2R	Intracranial	CA1 OX2R	1–30 nM/side	IC: CA1	24/7	-1.316570987	0.212481215	-2.220029813	-0.41311216
C008	Alizamini et al. (94)	Alizamini et al. (94)	Morphine	Morphine · TCS-OX2-29 (OX2R) · Intracranial	TCS-OX2-29	OX2R	Intracranial	NAc OX2R	3–100 nM/side	IC: NAc	24/6	-1.159238316	0.230730558	-2.100695671	-0.217780962
C006	Farahimanesh et al. (90)	Farahimanesh et al. (90)	Morphine	Morphine · TCS-OX2-29 (OX2R) · Intracranial	TCS-OX2-29	OX2R	Intracranial	VTA OX2R	1–25 nM/rat	IC: VTA	17/6	-1.420985316	0.269385832	-2.43825352	-0.403717112
C014	Shirazy et al. (42)	Shirazy et al. (42)	Morphine	Morphine · TCS-OX2-29 (OX2R) · Intracranial	TCS-OX2-29	OX2R	Intracranial	DG OX2R	0.5–12.5 nM/side	IC: DG	18/7	-0.914106598	0.215124516	-1.823167642	-0.005045554
C015	Jamali et al. (65)	Jamali et al. (65)	Morphine	Morphine · TCS-OX2-29 (OX2R) · Intracranial	TCS-OX2-29	OX2R	Intracranial	mPFC OX2R	3–30 nmol/side	IC: mPFC	21/8	-1.0456433030196024	0.1914702530871466	-1.9032708985540248	-0.1880157074851792
C013	Tabaeizadeh et al. (103)	Tabaeizadeh et al. (103) †	Morphine	Morphine · TCS-OX2-29 (OX2R) · Systemic	TCS-OX2-29	OX2R	Systemic	OX2R	5–10 mg/kg	i.p.	16/8	-2.754371974	0.345553437	-3.906513162	-1.602230785
C017	Majidinezhad et al. (1)	Majidinezhad et al. (1)	Methamphetamine	Methamphetamine · SB-334867 (OX1R) · Intracranial	SB-334867	OX1R	Intracranial	VTA OX1R	1–30 nmol/side	IC: VTA	32/8	-0.952120792	0.167581675	-1.754466175	-0.149775409
C018	Modaberi et al. (92)	Modaberi et al. (92)	Methamphetamine	Methamphetamine · SB-334867 (OX1R) · Intracranial	SB-334867	OX1R	Intracranial	DG OX1R	1–30 nmol/side	IC: DG	28/7	-1.049341349	0.194301675	-1.913286889	-0.185395809
C019	Modaberi et al. (92)	Modaberi et al. (92)	Methamphetamine	Methamphetamine · TCS-OX2-29 (OX2R) · Intracranial	TCS-OX2-29	OX2R	Intracranial	DG OX2R	1–30 nmol/side	IC: DG	28/7	-1.165525034	0.197977837	-2.037605146	-0.293444923
C021	Azizi et al. (130)	Azizi et al. (130)	Nicotine	Nicotine · TCS-OX2-29 (OX2R) · Intracranial	TCS-OX2-29	OX2R	Intracranial	VTA OX2R	0.4–4 µg/rat	IC: VTA	24/8	-0.998220437	0.182236105	-1.83491184	-0.161529034
C020	Fartootzadeh et al. (120)	Fartootzadeh et al. (120)	Nicotine	Nicotine · TCS-OX2-29 (OX2R) · Intracranial	TCS-OX2-29	OX2R	Intracranial	NAc core OX2R	2–20 ng/rat	IC: NAc core	21/7	-0.695076352	0.199103532	-1.569632258	0.179479554
C022	Shoblock et al. (98)	Shoblock et al. (98)	Alcohol	Alcohol · JNJ-10397049 (OX2R) · Systemic	JNJ-10397049	OX2R	Systemic	OX2R	10 mg/kg	s.c.	10/11	-0.457952864	0.195902444	-1.325449944	0.409544215", stringsAsFactors = FALSE)
pools <- read.delim(text = "group	k_pooled	k_studies_pooled	g	ci_lo	ci_hi	tau2	I2	Q	df_Q	p_Q	df_t	pi_lo	pi_hi	t	p
Morphine · SB-334867 (OX1R) · Intracranial	7.0	7.0	-0.9717660383928616	-1.3696829231403111	-0.5738491536454118	0.0	0.0	2.3007812900376967	6.0	0.8900633143943293	6.0	-1.389794140037042	-0.553737936748681	-5.975684689512133	0.0009852966672115
Morphine · TCS-OX2-29 (OX2R) · Intracranial	6.0	6.0	-0.9342735739718432	-1.50525373967411	-0.3632934082695759	0.0957527877199306	26.622375129473813	6.81406628903897	5.0	0.2348397550480885	5.0	-1.9918423215155776	0.1232951735718916	-4.206147293773684	0.0084394582380264", stringsAsFactors = FALSE)

strata <- split(effects, factor(effects$group, levels = unique(effects$group)))
omitted <- Filter(function(d) length(unique(d$study)) == 1L, strata)
shown <- if (hide_single_study) strata[!names(strata) %in% names(omitted)] else strata
stopifnot(sum(vapply(shown, nrow, integer(1))) == if (hide_single_study) 17L else 22L)

# Use physical coordinates (inches) for consistent text and spacing.
W <- 17.28
X <- function(x) x * 1.08
left <- 9.06; right <- 12.53
xg <- function(x) left + (x + 4) / 6 * (right - left)
num <- function(x) gsub("-", "−", sprintf("%.2f", x), fixed = TRUE)
ci <- function(g, l, u) sprintf("%s [%s; %s]", num(g), num(l), num(u))
N <- sum(vapply(shown, nrow, integer(1)))
n_bands <- length(unique(vapply(shown, function(d) d$substance[1], character(1))))
axis_y <- 1.05 + .34*n_bands + .35*length(shown) + .32*N +
  .64*sum(names(shown) %in% pools$group) + .32*sum(!names(shown) %in% pools$group) + .15
H <- axis_y + 2.48

draw <- function() {
  grid.newpage()
  pushViewport(viewport(xscale = c(0,W), yscale = c(0,H)))
  on.exit(popViewport())
  tx <- function(x,y,s,fs=10,face="plain",adj=0,room=Inf) {
    fs <- fs + 5
    room <- X(room)
    z <- textGrob(s, just=c(adj,.5), gp=gpar(fontfamily="sans",fontsize=fs,fontface=face,col="black"))
    ww <- convertWidth(grobWidth(z),"in",valueOnly=TRUE)
    if (ww > room) z$gp$fontsize <- fs * room/ww
    z$x <- unit(X(x),"native"); z$y <- unit(H-y,"native")
    grid.draw(z)
  }
  ln <- function(x1,x2,y1,y2=y1,col="black",lwd=1.2,lty="solid")
    grid.segments(X(x1),H-y1,X(x2),H-y2,default.units="native",gp=gpar(col=col,lwd=lwd,lty=lty,lineend="butt"))
  rect <- function(x,y,w,h,fill)
    grid.rect(X(x),H-y,X(w),h,default.units="native",gp=gpar(fill=fill,col=NA))
  tx(.2,.26,"Fig 3A. CPP acquisition",16,"bold")
  tx(.2,.54,"Conditioning score or change in preference when antagonist is given during conditioning",11)
  xx <- c(.29,2.89,5.10,6.90,8.45,12.73,15.82)
  for (j in seq_along(xx))
    tx(xx[j],.87,c("Study","Experiment","Dose(s)","Route/site","n (T/C)","Hedges’ g [95% CI]","Weight")[j],
       11,"bold",adj=c(0,0,0,0,.5,0,1)[j])
  y <- 1.05
  last <- ""
  for (d in shown) {
    s <- d$substance[1]
    if (s != last) {
      rect(8,y+.16,15.70,.29,"#E7EDF4")
      tx(.2,y+.16,s,12,"bold")
      last <- s
      y <- y + .34
    }
    heading <- sprintf("%s (%s) · %s", d$antagonist[1],d$receptor[1],tolower(d$route_class[1]))
    tx(.29,y+.14,heading,11,"bold")
    y <- y + .35
    q <- pools[pools$group == d$group[1],,drop=FALSE]
    w <- if (nrow(q)) { v <- 1/(d$var + q$tau2); 100*v/sum(v) } else rep(NA_real_,nrow(d))
    # Draw behind the study markers. The diamond is drawn over the guide.
    if (nrow(q) == 1L) {
      pooled_x <- xg(q$g)
      ln(pooled_x, pooled_x, y + .02, y + .14 + nrow(d) * .32,
         lwd=1.1, lty="dotted")
    }
    for (j in seq_len(nrow(d))) {
      r <- d[j,]; yy <- y+.14
      values <- c(r$label,r$experiment,r$dose,r$route,r$n,ci(r$g,r$ci_lo,r$ci_hi),
                  if (is.na(w[j])) "" else sprintf("%.1f%%",w[j]))
      for (i in seq_along(xx)) tx(xx[i],yy,values[i],adj=c(0,0,0,0,.5,0,1)[i],
                                  room=c(2.50,2.10,1.70,1.16,.92,2.31,.69)[i])
      ln(xg(r$ci_lo),xg(r$ci_hi),yy)
      side <- .025*sqrt(if (is.na(w[j])) 18 else 8+.9*w[j])
      rect(xg(r$g),yy,side,side,"#2CA02C")
      y <- y+.32
    }
    if (nrow(q)) {
      yy <- y+.14
      tx(xx[1],yy,"Random-effects model",11,"bold",room=2.35)
      tx(xx[2],yy,sprintf("k = %d cohorts / %d studies",q$k_pooled,q$k_studies_pooled))
      tx(xx[3],yy,sprintf("REML; HKSJ* t(df = %d)",q$df_t),room=2.65)
      tx(xx[6],yy,ci(q$g,q$ci_lo,q$ci_hi),11,"bold",room=2.35)
      tx(xx[7],yy,"100%",adj=1)
      grid.polygon(X(xg(c(q$ci_lo,q$g,q$ci_hi,q$g))),H-(yy+c(0,-.105,0,.105)),
                   default.units="native",gp=gpar(fill="black",col=NA))
      ln(xg(q$pi_lo),xg(q$pi_hi),yy+.138,col="#C0392B",lwd=1.8)
      tx(.29,y+.46,sprintf("Heterogeneity: τ² = %.2f; I² = %.0f%%; Q = %.2f (df = %d), p = %.3f; 95%% PI [%s; %s]",
                           q$tau2,q$I2,q$Q,q$df_Q,q$p_Q,num(q$pi_lo),num(q$pi_hi)),10,"italic")
      tx(xx[6],y+.46,sprintf("t(%d) = %s, %s",q$df_t,num(q$t),if(q$p<.001) "p < 0.001" else sprintf("p = %.3f",q$p)),
         10,"italic",room=2.42)
      y <- y+.64
    } else {
      k_studies <- length(unique(d$study))
      annotation <- if (k_studies == 2L && nrow(d) == 2L) {
        "Two independent studies; no pooled estimate"
      } else {
        sprintf("%d cohorts from %d studies; no pooled estimate", nrow(d), k_studies)
      }
      tx(.29,y+.14,annotation,
         10,"italic")
      y <- y+.32
    }
  }
  ln(xg(0),xg(0),.75,axis_y,lwd=.8)
  ln(left,right,axis_y)
  for (j in -4:2) {
    ln(xg(j),xg(j),axis_y,axis_y+.06)
    tx(xg(j),axis_y+.16,if(j<0) paste0("−",abs(j)) else as.character(j),10,adj=.5)
  }
  tx(left,axis_y+.33,"Favours antagonist",10)
  tx(right,axis_y+.33,"Favours vehicle",10,adj=1)
  tx((left+right)/2,axis_y+.55,"Standardized mean difference (Hedges’ g)",11,adj=.5)
  notes <- c(
    if (hide_single_study) "Five strata with one study each are omitted from this panel; their estimates remain in the effect table.",
    "Squares show cohort estimates; horizontal lines show 95% CIs. In pooled strata, larger squares indicate greater random-effects weights.",
    "Diamonds show REML estimates with modified HKSJ 95% CIs (q* ≥ 1); red bars show 95% prediction intervals. T/C = treatment/control.",
    "† Unresolved data quality flag (excluded in S2). * Jamali treatment/control sample sizes are conditional on an unverified allocation.",
    "Dose arms sharing a vehicle group were combined into one treatment arm for the cohort estimate.",
    "LH = lateral hypothalamus. Doses are transcribed as reported. For entries in nM, the administered amount could not be established from the reported concentration alone.")
  notes <- c(notes, "Vertical dotted lines mark subgroup pooled estimates; the solid vertical line marks zero.")
  for (i in seq_along(notes)) tx(.2,axis_y+.83+(i-1)*.23,notes[i],9.5,room=15.6)
}

args <- commandArgs(trailingOnly=TRUE)
out <- if(length(args)) args[1] else "."
dir.create(out,recursive=TRUE,showWarnings=FALSE)
stem <- file.path(out,"Fig3A_CPP_acquisition_annotations")
if (!capabilities("cairo")) stop("An R build with Cairo support is required.")
cairo_pdf(paste0(stem,".pdf"),width=W,height=H,bg="white")
draw()
invisible(dev.off())
png(paste0(stem,".png"),width=W,height=H,units="in",res=600,type="cairo",bg="white")
draw()
invisible(dev.off())
