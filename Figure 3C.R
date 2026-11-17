# Figure 3C: publication layout. Base R and grid; Cairo graphics required.
# Rscript Fig3C_CPP_extinction.R [output_directory]
# TRUE suppresses strata with one study in the plotted panel.
# All source rows remain embedded; pooled results are imported, not refit.
hide_single_study <- TRUE
library(grid)
effects <- read.delim(text = "contrast_id	study	label	substance	group	antagonist	receptor	route_class	experiment	dose	route	n	g	var	ci_lo	ci_hi	experiment_name	cohort_description	data_status	verify
C047	Sadeghzadeh et al. (74)	Sadeghzadeh et al. (74)	Morphine	Morphine · SB-334867 (OX1R) · Intracranial	SB-334867	OX1R	Intracranial	NAc OX1R	3–300 µg/side	IC: NAc	21/7	-1.329151649	0.222023407	-2.252674137	-0.40562916	NAc OX1R · MOR CPP ext.	Male albino Wistar rats	unflagged	
C046	Farahimanesh et al. (41)	Farahimanesh et al. (41)	Morphine	Morphine · SB-334867 (OX1R) · Intracranial	SB-334867	OX1R	Intracranial	CA1 OX1R	3–300 nM/side	IC: CA1	15/5	-1.012114706	0.292276071	-2.071721477	0.047492065	CA1 OX1R · MOR CPP ext.	Male albino Wistar rats	unflagged	
C049	Sadeghi et al. (126)	Sadeghi et al. (126)	Morphine	Morphine · TCS-OX2-29 (OX2R) · Intracranial	TCS-OX2-29	OX2R	Intracranial	CA1 OX2R	10–30 nM/side	IC: CA1	14/7	-1.768127027	0.28872079	-2.821269488	-0.714984566	CA1 OX2R · MOR CPP ext.	Male albino Wistar rats	unflagged	
C048	Sadeghzadeh et al. (74)	Sadeghzadeh et al. (74)	Morphine	Morphine · TCS-OX2-29 (OX2R) · Intracranial	TCS-OX2-29	OX2R	Intracranial	NAc OX2R	3–300 µg/side	IC: NAc	21/7	-0.288705163	0.191964595	-1.147439173	0.570028847	NAc OX2R · MOR CPP ext.	Male albino Wistar rats	unflagged	
C051	Amirteymori et al. (109)	Amirteymori et al. (109) 	Methamphetamine	Methamphetamine · SB-334867 (OX1R) · Intracranial	SB-334867	OX1R	Intracranial	NAc OX1R	3–30 nmol/side	IC: NAc	19/8	-1.283882691	0.208156667	-2.178100382	-0.389665001	NAc OX1R · METH CPP ext.	Male albino Wistar rats	unresolved flag	SB 3 nmol arm has no treatment label
C050	Veisi et al. (77)	Veisi et al. (77)	Methamphetamine	Methamphetamine · SB-334867 (OX1R) · Intracranial	SB-334867	OX1R	Intracranial	CA1 OX1R	1–30 nmol/side	IC: CA1	33/8	-1.149359608	0.171413122	-1.960825233	-0.337893984	CA1 OX1R · METH CPP ext.	Male Wistar rats	unflagged	
C052	Amirteymori et al. (109)	Amirteymori et al. (109) 	Methamphetamine	Methamphetamine · TCS-OX2-29 (OX2R) · Intracranial	TCS-OX2-29	OX2R	Intracranial	NAc OX2R	3–30 nmol/side	IC: NAc	19/7	-0.659776564	0.203859974	-1.544717075	0.225163947	NAc OX2R · METH CPP ext.	Male albino Wistar rats	unresolved flag	Vehicle row has no treatment label or control flag
C053	Amirteymori et al. (71)	Amirteymori et al. (71)	Methamphetamine	Methamphetamine · TCS-OX2-29 (OX2R) · Intracranial	TCS-OX2-29	OX2R	Intracranial	CA1 OX2R blockade	1–30 nmol/side	IC: CA1	36/9	-1.0450964035	0.1510247388	-1.8067756826	-0.2834171244	CA1 OX2R blockade during METH CPP extinction	Male Wistar rats	source-checked	Corrected; source checked
C054	Zamanirad et al. (89)	Zamanirad et al. (89)	Methamphetamine	Methamphetamine · TCS-OX2-29 (OX2R) · Intracranial	TCS-OX2-29	OX2R	Intracranial	VTA OX2R	1–30 nmol	IC: VTA	31/8	-1.316491344	0.179477929	-2.14682687	-0.486155818	VTA OX2R · METH CPP ext.	Male Wistar rats	unflagged	", stringsAsFactors = FALSE)
pools <- read.delim(text = "group	k_pooled	k_studies_pooled	g	ci_lo	ci_hi	tau2	I2	Q	df_Q	p_Q	df_t	pi_lo	pi_hi	t	p
Methamphetamine · TCS-OX2-29 (OX2R) · Intracranial	3.0	3.0	-1.0229900659727968	-2.063527245827941	0.0175471138823468	0.0	0.0	1.1303308393718607	2.0	0.5682661365763502	2.0	-4.095810317402	2.049830185456406	-4.230094882796204	0.0515983584389509", stringsAsFactors = FALSE)

strata <- split(effects, factor(effects$group, levels = unique(effects$group)))
omitted <- Filter(function(d) length(unique(d$study)) == 1L, strata)
shown <- if (hide_single_study) strata[!names(strata) %in% names(omitted)] else strata
stopifnot(sum(vapply(shown, nrow, integer(1))) == if (hide_single_study) 9L else 9L)

# Use physical coordinates (inches) for consistent text and spacing.
W <- 19.52
X <- function(x) x * 1.22
left <- 9.06; right <- 12.53
xg <- function(x) left + (x + 5) / 8 * (right - left)
num <- function(x) gsub("-", "−", sprintf("%.2f", x), fixed = TRUE)
ci <- function(g, l, u) sprintf("%s [%s; %s]", num(g), num(l), num(u))
N <- sum(vapply(shown, nrow, integer(1)))
n_bands <- length(unique(vapply(shown, function(d) d$substance[1], character(1))))
axis_y <- 1.32 + .34*n_bands + .35*length(shown) + .38*N +
  .76*sum(names(shown) %in% pools$group) + .38*sum(!names(shown) %in% pools$group) + .15
H <- axis_y + 3.22

draw <- function() {
  grid.newpage()
  pushViewport(viewport(xscale = c(0,W), yscale = c(0,H)))
  on.exit(popViewport())
  tx <- function(x,y,s,fs=10,face="plain",adj=0,room=Inf) {
    fs <- fs + 9
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
  tx(.2,.28,"Fig 3C. CPP extinction",16,"bold")
  tx(.2,.69,"Extinction latency, preference reduction or extinction-test score",11)
  xx <- c(.29,2.89,5.10,6.90,8.55,12.73,15.82)
  for (j in seq_along(xx))
    tx(xx[j],1.12,c("Study","Experiment","Dose(s)","Route/site","n T/C","Hedges’ g [95% CI]","Weight")[j],
       11,"bold",adj=c(0,0,0,0,.5,0,1)[j])
  y <- 1.32
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
    if (nrow(q) == 1L) {
      pooled_x <- xg(q$g)
      ln(pooled_x, pooled_x, y + .02, y + .14 + nrow(d) * .38,
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
      y <- y+.38
    }
    if (nrow(q)) {
      yy <- y+.14
      tx(xx[1],yy,"Random-effects model",11,"bold",room=2.35)
      tx(xx[2],yy,sprintf("k = %d cohorts / %d studies",q$k_pooled,q$k_studies_pooled),room=2.70)
      tx(5.78,yy,sprintf("REML; HKSJ* t(df = %d)",q$df_t),room=3.05)
      tx(xx[6],yy,ci(q$g,q$ci_lo,q$ci_hi),11,"bold",room=2.35)
      tx(xx[7],yy,"100%",adj=1)
      grid.polygon(X(xg(c(q$ci_lo,q$g,q$ci_hi,q$g))),H-(yy+c(0,-.145,0,.145)),
                   default.units="native",gp=gpar(fill="black",col=NA))
      ln(xg(q$pi_lo),xg(q$pi_hi),yy+.185,col="#C0392B",lwd=1.8)
      tx(.29,y+.54,sprintf("Heterogeneity: τ² = %.2f; I² = %.0f%%; Q = %.2f (df = %d), p = %.3f; 95%% PI [%s; %s]",
                           q$tau2,q$I2,q$Q,q$df_Q,q$p_Q,num(q$pi_lo),num(q$pi_hi)),10,"italic")
      tx(xx[6],y+.54,sprintf("t(%d) = %s, %s",q$df_t,num(q$t),if(q$p<.001) "p < 0.001" else sprintf("p = %.3f",q$p)),
         10,"italic",room=2.42)
      y <- y+.76
    } else {
      k_studies <- length(unique(d$study))
      annotation <- if (k_studies == 2L && nrow(d) == 2L) {
        "Two independent studies; no pooled estimate"
      } else {
        sprintf("%d cohort%s from %d %s; no pooled estimate", nrow(d),
                if (nrow(d)==1L) "" else "s", k_studies,
                if (k_studies==1L) "study" else "studies")
      }
      tx(.29,y+.14,annotation,
         10,"italic")
      y <- y+.38
    }
  }
  ln(xg(0),xg(0),1.25,axis_y,lwd=.8)
  ln(left,right,axis_y)
  for (j in -5:3) {
    ln(xg(j),xg(j),axis_y,axis_y+.06)
    tx(xg(j),axis_y+.23,if(j<0) paste0("−",abs(j)) else as.character(j),10,adj=.5)
  }
  tx(xg(-3),axis_y+.58,"Favours antagonist",9,adj=.5,room=1.62)
  tx(xg(1.5),axis_y+.58,"Favours vehicle",9,adj=.5,room=1.62)
  tx((left+right)/2,axis_y+.92,"Standardized mean difference (Hedges’ g)",11,adj=.5)
  notes <- c(
    "All nine cohort rows are shown; no subgroup was represented by only one study.",
    "Squares show cohort estimates; horizontal lines show 95% CIs. In pooled strata, larger squares indicate greater random-effects weights.",
    "Diamonds show REML estimates with modified HKSJ 95% CIs (q* ≥ 1); red bars show 95% prediction intervals. T/C = treatment/control.",
    "† Unresolved data quality flag (excluded in S2).",
    "Dose arms sharing a vehicle group were combined into one treatment arm for the cohort estimate.",
    "Doses are transcribed as reported. For entries in nM, the administered amount could not be established from the reported concentration alone.")
  notes <- c(notes, "Vertical dotted lines mark subgroup pooled estimates; the solid vertical line marks zero.")
  for (i in seq_along(notes)) tx(.2,axis_y+1.32+(i-1)*.26,notes[i],9.5,room=15.6)
}

args <- commandArgs(trailingOnly=TRUE)
out <- if(length(args)) args[1] else "."
dir.create(out,recursive=TRUE,showWarnings=FALSE)
stem <- file.path(out,"Fig3C_CPP_extinction")
if (!capabilities("cairo")) stop("An R build with Cairo support is required.")
cairo_pdf(paste0(stem,".pdf"),width=W,height=H,bg="white")
draw()
invisible(dev.off())
png(paste0(stem,".png"),width=W,height=H,units="in",res=300,type="cairo",bg="white")
draw()
invisible(dev.off())
