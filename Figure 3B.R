# Figure 3B: publication layout. Base R and grid; Cairo graphics required.
# Rscript Fig3B_CPP_expression_spaced.R [output_directory]
# TRUE suppresses strata with one study in the plotted panel.
# All source rows remain embedded; pooled results are imported, not refit.
hide_single_study <- TRUE
library(grid)
effects <- read.delim(text = "contrast_id	study	label	substance	group	antagonist	receptor	route_class	experiment	dose	route	n	g	var	ci_lo	ci_hi	experiment_name	cohort_description	data_status	verify
C028	Zarepour et al. (73)	Zarepour et al. (73)	Morphine	Morphine · SB-334867 (OX1R) · Intracranial	SB-334867	OX1R	Intracranial	VTA OX1R 	0.1–10 nmol	IC: VTA	21/7	-0.133913638	0.19079642	-0.990030804	0.722203529	VTA OX1R · LH-stim MOR CPP expr.	Male Wistar rats	unflagged	
C026	Guo et al. (62)	Guo et al. (62)	Morphine	Morphine · SB-334867 (OX1R) · Intracranial	SB-334867	OX1R	Intracranial	DG OX1R	1 pmol/side	IC: DG	12/12	-0.630324456	0.174943936	-1.450104875	0.189455963	DG OX1R · MOR CPP expr.	Male Sprague-Dawley rats	unflagged	
C030	Sadeghzadeh et al. (74)	Sadeghzadeh et al. (74)	Morphine	Morphine · SB-334867 (OX1R) · Intracranial	SB-334867	OX1R	Intracranial	NAc OX1R	3–300 µg/side	IC: NAc	18/6	-1.075678119	0.246328127	-2.048436759	-0.10291948	NAc OX1R · MOR CPP expr.	Male albino Wistar rats	unflagged	
C027	Farahimanesh et al. (90)	Farahimanesh et al. (90)	Morphine	Morphine · SB-334867 (OX1R) · Intracranial	SB-334867	OX1R	Intracranial	VTA OX1R	0.1–10 nM/rat	IC: VTA	15/7	-1.465363425	0.258325854	-2.461530152	-0.469196699	VTA OX1R · MOR CPP expr.	Male albino Wistar rats	unflagged	
C024	Farahimanesh et al. (41)	Farahimanesh et al. (41)	Morphine	Morphine · SB-334867 (OX1R) · Intracranial	SB-334867	OX1R	Intracranial	CA1 OX1R	3–300 nM/side	IC: CA1	21/8	-1.273626062	0.200586691	-2.151433288	-0.395818835	CA1 OX1R · MOR CPP expr.	Male albino Wistar rats	unflagged	
C025	Shirazy et al. (42)	Shirazy et al. (42)	Morphine	Morphine · SB-334867 (OX1R) · Intracranial	SB-334867	OX1R	Intracranial	DG OX1R	0.5–12.5 nM/side	IC: DG	18/6	-1.446340109	0.265803466	-2.45682172	-0.435858498	DG OX1R · MOR CPP expr.	Male Wistar rats	unflagged	
C023	Jamali et al. (4)	Jamali et al. (4)	Morphine	Morphine · SB-334867 (OX1R) · Intracranial	SB-334867	OX1R	Intracranial	mPFC OX1R	3–30 nM/side	IC: mPFC	24/9	-0.854882436	0.163850868	-1.648246396	-0.061518476	mPFC OX1R · MOR CPP expr.	Male Wistar rats	unresolved flag	Morphine + DMSO vehicle row not flagged as treatment control
C029	Tabaeizadeh et al. (103)	Tabaeizadeh et al. (103)	Morphine	Morphine · SB-334867 (OX1R) · Systemic	SB-334867	OX1R	Systemic	OX1R	10–30 mg/kg	i.p.	24/8	-0.51020976	0.170734073	-1.320066489	0.299646968	OX1R · MOR CPP expr.	Male NMRI mice (morphine-dependent)	unflagged	
C035	Sadeghi et al. (126)	Sadeghi et al. (126)	Morphine	Morphine · TCS-OX2-29 (OX2R) · Intracranial	TCS-OX2-29	OX2R	Intracranial	CA1 OX2R	1–30 nM/side	IC: CA1	24/7	-1.353000494	0.214049783	-2.259787922	-0.446213066	CA1 OX2R · MOR CPP expr.	Male albino Wistar rats	unflagged	
C031	Sadeghzadeh et al. (74)	Sadeghzadeh et al. (74)	Morphine	Morphine · TCS-OX2-29 (OX2R) · Intracranial	TCS-OX2-29	OX2R	Intracranial	NAc OX2R	3–300 µg/side	IC: NAc	18/6	-0.647559402	0.23095833	-1.589481336	0.294362531	NAc OX2R · MOR CPP expr.	Male albino Wistar rats	unflagged	
C033	Farahimanesh et al. (90)	Farahimanesh et al. (90)	Morphine	Morphine · TCS-OX2-29 (OX2R) · Intracranial	TCS-OX2-29	OX2R	Intracranial	VTA OX2R	1–25 nM/rat	IC: VTA	13/5	-1.431635392	0.333855852	-2.564107699	-0.299163085	VTA OX2R · MOR CPP expr.	Male albino Wistar rats	unflagged	
C032	Shirazy et al. (42)	Shirazy et al. (42)	Morphine	Morphine · TCS-OX2-29 (OX2R) · Intracranial	TCS-OX2-29	OX2R	Intracranial	DG OX2R	0.5–12.5 nM/side	IC: DG	18/7	-1.513550777	0.244229417	-2.482156612	-0.544944941	DG OX2R · MOR CPP expr.	Male Wistar rats	unflagged	
C034	Jamali et al. (65)	Jamali et al. (65)	Morphine	Morphine · TCS-OX2-29 (OX2R) · Intracranial	TCS-OX2-29	OX2R	Intracranial	mPFC OX2R	3–30 nmol/side	IC: mPFC	21/8	-1.1743522819	0.1963966904	-2.0429429857	-0.3057615782	mPFC OX2R · MOR CPP expr.	Male Wistar rats	source-checked	Source checked; retained
C036	Tabaeizadeh et al. (103)	Tabaeizadeh et al. (103) †	Morphine	Morphine · TCS-OX2-29 (OX2R) · Systemic	TCS-OX2-29	OX2R	Systemic	OX2R	5 mg/kg	i.p.	8/8	-1.719494627	0.34239568	-2.866359452	-0.572629802	OX2R · MOR CPP expr.	Male NMRI mice (morphine-naïve)	unresolved flag	Vehicle row not flagged as control
C037	Tabaeizadeh et al. (103)	Tabaeizadeh et al. (103) †	Morphine	Morphine · TCS-OX2-29 (OX2R) · Systemic	TCS-OX2-29	OX2R	Systemic	OX2R	5–10 mg/kg	i.p.	18/8	-3.508445753	0.417270779	-4.774513894	-2.242377612	OX2R · MOR CPP expr.	Male NMRI mice (morphine-dependent)	unresolved flag	Vehicle row not flagged as control
C038	Majidinezhad et al. (1)	Majidinezhad et al. (1)	Methamphetamine	Methamphetamine · SB-334867 (OX1R) · Intracranial	SB-334867	OX1R	Intracranial	VTA OX1R	1–30 nmol/side	IC: VTA	32/8	-1.1375674523	0.1724257464	-1.9514413659	-0.3236935387	VTA OX1R · METH CPP expr.	Male Wistar rats	unresolved flag	Restored from master sheet rows 278-282; SB 1,3,10,30 nmol combined (Cochrane)
C039	Modaberi et al. (92)	Modaberi et al. (92)	Methamphetamine	Methamphetamine · SB-334867 (OX1R) · Intracranial	SB-334867	OX1R	Intracranial	DG OX1R	1–30 nmol/side	IC: DG	28/7	-0.840526197	0.188664061	-1.691845898	0.010793504	DG OX1R · METH CPP expr.	Male Wistar rats	unflagged	
C040	Modaberi et al. (92)	Modaberi et al. (92)	Methamphetamine	Methamphetamine · TCS-OX2-29 (OX2R) · Intracranial	TCS-OX2-29	OX2R	Intracranial	DG OX2R	1–10 nmol/side	IC: DG	21/7	-0.823971542	0.202599924	-1.706172924	0.05822984	DG OX2R · METH CPP expr.	Male Wistar rats	unflagged	
C041	Fartootzadeh et al. (120)	Fartootzadeh et al. (120)	Nicotine	Nicotine · TCS-OX2-29 (OX2R) · Intracranial	TCS-OX2-29	OX2R	Intracranial	NAc core OX2R	2–20 ng/rat	IC: NAc core	18/6	-0.818144658	0.236167236	-1.77062916	0.134339845	NAc core OX2R · NIC CPP expr.	Male Wistar rats	unflagged	
C042	Cui et al. (96)	Cui et al. (96)	Nicotine	Nicotine · Suvorexant (DORA) · Systemic	Suvorexant	DORA	Systemic	DORA · CPP retrieval	10 mg/kg	i.p.	7/6	0.069712336	0.309710725	-1.021040164	1.160464836	DORA · NIC CPP retr.	Wild-type male Sprague-Dawley rats	unflagged	
C043	Cui et al. (96)	Cui et al. (96)	Nicotine	Nicotine · Suvorexant (DORA) · Systemic	Suvorexant	DORA	Systemic	DORA · CPP retrieval	30 mg/kg	i.p.	12/12	-0.660577727	0.175757561	-1.482262244	0.161106789	DORA · NIC CPP retr.	Wild-type male Sprague-Dawley rats	unflagged	
C044	Shoblock et al. (98)	Shoblock et al. (98)	Alcohol	Alcohol · JNJ-10397049 (OX2R) · Systemic	JNJ-10397049	OX2R	Systemic	OX2R	10 mg/kg	s.c.	14/16	-0.408516642	0.136710002	-1.133199919	0.316166636	OX2R · EtOH CPP expr.	Male DBA/2 mice	unflagged	
C045	Shoblock et al. (98)	Shoblock et al. (98)	Alcohol	Alcohol · SB-408124 (OX1R) · Systemic	SB-408124	OX1R	Systemic	OX1R	30 mg/kg	s.c.	11/11	0.189461691	0.182633994	-0.648142618	1.027066	OX1R · EtOH CPP expr.	Male DBA/2 mice	unflagged	", stringsAsFactors = FALSE)
pools <- read.delim(text = "group	k_pooled	k_studies_pooled	g	ci_lo	ci_hi	tau2	I2	Q	df_Q	p_Q	df_t	pi_lo	pi_hi	t	p
Morphine · SB-334867 (OX1R) · Intracranial	7.0	7.0	-0.9342550367318148	-1.3788592086731035	-0.489650864790526	0.0229588069974885	9.8656608951719	6.65673045322036	6.0	0.3537617580621403	6.0	-1.5424230812427808	-0.3260869922208489	-5.141741498711898	0.002132384714038
Morphine · TCS-OX2-29 (OX2R) · Intracranial	5.0	5.0	-1.208020730679297	-1.8112659003490763	-0.6047755610095173	0.0	0.0	1.9960206354024532	4.0	0.7364908450716317	4.0	-1.8994787961752717	-0.5165626651833225	-5.559933859906412	0.0051235532057994", stringsAsFactors = FALSE)

strata <- split(effects, factor(effects$group, levels = unique(effects$group)))
omitted <- Filter(function(d) length(unique(d$study)) == 1L, strata)
shown <- if (hide_single_study) strata[!names(strata) %in% names(omitted)] else strata
stopifnot(sum(vapply(shown, nrow, integer(1))) == if (hide_single_study) 14L else 23L)

# Use physical coordinates (inches) for consistent text and spacing.
W <- 19.52
X <- function(x) x * 1.22
left <- 9.06; right <- 12.53
xg <- function(x) left + (x + 4) / 6 * (right - left)
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
  tx(.2,.28,"Fig 3B. CPP expression",16,"bold")
  tx(.2,.69,"Preference during the drug-free test after conditioning; antagonist given before the test",11)
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
  for (j in -4:2) {
    ln(xg(j),xg(j),axis_y,axis_y+.06)
    tx(xg(j),axis_y+.23,if(j<0) paste0("−",abs(j)) else as.character(j),10,adj=.5)
  }
  tx(xg(-2),axis_y+.58,"Favours antagonist",9,adj=.5,room=1.62)
  tx(xg(1),axis_y+.58,"Favours vehicle",9,adj=.5,room=1.62)
  tx((left+right)/2,axis_y+.92,"Standardized mean difference (Hedges’ g)",11,adj=.5)
  notes <- c(
    if (hide_single_study) "Seven strata represented by one study each (nine cohort rows) are omitted from this panel; their estimates remain embedded.",
    "Squares show cohort estimates; horizontal lines show 95% CIs. In pooled strata, larger squares indicate greater random-effects weights.",
    "Diamonds show REML estimates with modified HKSJ 95% CIs (q* ≥ 1); red bars show 95% prediction intervals. T/C = treatment/control.",
    "† Unresolved data quality flag (excluded in S2).",
    "Dose arms sharing a vehicle group were combined into one treatment arm for the cohort estimate.",
    "LH = lateral hypothalamus. Doses are transcribed as reported. For entries in nM, the administered amount could not be established from the reported concentration alone.")
  notes <- c(notes, "Vertical dotted lines mark subgroup pooled estimates; the solid vertical line marks zero.")
  for (i in seq_along(notes)) tx(.2,axis_y+1.32+(i-1)*.26,notes[i],9.5,room=15.6)
}

args <- commandArgs(trailingOnly=TRUE)
out <- if(length(args)) args[1] else "."
dir.create(out,recursive=TRUE,showWarnings=FALSE)
stem <- file.path(out,"Fig3B_CPP_expression_spaced")
if (!capabilities("cairo")) stop("An R build with Cairo support is required.")
cairo_pdf(paste0(stem,".pdf"),width=W,height=H,bg="white")
draw()
invisible(dev.off())
png(paste0(stem,".png"),width=W,height=H,units="in",res=300,type="cairo",bg="white")
draw()
invisible(dev.off())
