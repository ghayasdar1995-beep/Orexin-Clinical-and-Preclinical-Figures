# Figure 2D: publication layout. Base R and grid; Cairo graphics required.
# Rscript Fig2D_CPP_reinstatement_final.R [output_directory]
# TRUE suppresses strata with one study in the plotted panel.
# All source rows remain embedded; pooled results are imported, not refit.
hide_single_study <- TRUE
library(grid)
effects <- read.delim(text = "contrast_id	study	label	substance	group	antagonist	receptor	route_class	experiment	dose	route	n	g	var	ci_lo	ci_hi	experiment_name	cohort_description	data_status	verify	trigger
C055	Ebrahimian et al. (127)	Ebrahimian et al. (127)	Morphine	Morphine · SB-334867 (OX1R) · Intracranial · drug-prime	SB-334867	OX1R	Intracranial	DG OX1R	SB-334867 1, 3, 10, and 30 μg/0.5 μL/side	IC: DG	18/6	-1.1861809154	0.2515352465	-2.169185393	-0.2031764379	DG OX1R · MOR CPP prime-reinst.	Male albino Wistar rats	unresolved flag	Restored from master sheet rows 24-27; SB 3 dose arms combined (Cochrane)	drug-prime
C058	Alizamini et al. (67)	Alizamini et al. (67) 	Morphine	Morphine · SB-334867 (OX1R) · Intracranial · drug-prime	SB-334867	OX1R	Intracranial	CA1 OX1R	0.3–30 nM/side	IC: CA1	—					CA1 OX1R · MOR CPP prime-reinst.	Male Wistar rats	not estimable	Effect withheld; source PDF lacks the SB data plot (Fig. 3 caption and atlas only). The 0.3 and 3 nM values cannot be verified against the publication.	drug-prime
C057	Sahafzadeh et al. (10)	Sahafzadeh et al. (10) 	Morphine	Morphine · SB-334867 (OX1R) · Intracranial · drug-prime	SB-334867	OX1R	Intracranial	NAc OX1R	0.1–10 nM	IC: NAc	24/8	-0.8486449864	0.1779197653	-1.6753835003	-0.0219064725	NAc OX1R · MOR CPP prime-reinst.	Male albino Wistar rats	unresolved flag	Restored from master sheet rows 241-244; SB 0.1,1,10 nM combined (Cochrane)	drug-prime
C056	Azizbeigi et al. (26)	Azizbeigi et al. (26)	Morphine	Morphine · SB-334867 (OX1R) · Intracranial · drug-prime	SB-334867	OX1R	Intracranial	VTA OX1R	0.3–3 nM/side	IC: VTA	18/6	-1.390117776	0.262481127	-2.394264407	-0.385971145	VTA OX1R · MOR CPP prime-reinst.	Male albino Wistar rats	unflagged		drug-prime
C059	Ebrahimian et al. (127)	Ebrahimian et al. (127)	Morphine	Morphine · TCS-OX2-29 (OX2R) · Intracranial · drug-prime	TCS-OX2-29	OX2R	Intracranial	DG OX2R	1–30 µg/side	IC: DG	20/5	-1.248252742	0.281162698	-2.287519283	-0.208986201	DG OX2R · MOR CPP prime-reinst.	Male albino Wistar rats	unflagged		drug-prime
C062	Alizamini et al. (67)	Alizamini et al. (67)	Morphine	Morphine · TCS-OX2-29 (OX2R) · Intracranial · drug-prime	TCS-OX2-29	OX2R	Intracranial	CA1 OX2R	0.3–30 nM/side	IC: CA1	21/7	-0.782226161	0.201402579	-1.66181682	0.097364497	CA1 OX2R · MOR CPP prime-reinst.	Male Wistar rats	unflagged		drug-prime
C061	Sahafzadeh et al. (10)	Sahafzadeh et al. (10)	Morphine	Morphine · TCS-OX2-29 (OX2R) · Intracranial · drug-prime	TCS-OX2-29	OX2R	Intracranial	NAc OX2R	1–25 nM	IC: NAc	24/8	-1.256736904	0.191344599	-2.114083047	-0.399390762	NAc OX2R · MOR CPP prime-reinst.	Male albino Wistar rats	unflagged		drug-prime
C060	Azizbeigi et al. (60)	Azizbeigi et al. (60) 	Morphine	Morphine · TCS-OX2-29 (OX2R) · Intracranial · drug-prime	TCS-OX2-29	OX2R	Intracranial	VTA OX2R	0.3–10 nM/side	IC: VTA	28/7	-1.14242648	0.197216261	-2.012827627	-0.272025333	VTA OX2R · MOR CPP prime-reinst.	Male Wistar rats	unresolved flag	No arm flagged as treatment control; vehicle identified from cohort label	drug-prime
C069	Ebrahimian et al. (127)	Ebrahimian et al. (127)	Morphine	Morphine · SB-334867 (OX1R) · Intracranial · stress	SB-334867	OX1R	Intracranial	DG OX1R · FSS	SB-334867 1, 3, 10, and 30 μg/0.5 μL/side	IC: DG	15/5	-0.2291234195	0.2679791052	-1.243750706	0.785503867	DG OX1R · MOR CPP FSS-reinst.	Male albino Wistar rats	unresolved flag	Restored from master sheet rows 28-31; SB 3 dose arms combined (Cochrane)	stress
C070	Azizbeigi et al. (26)	Azizbeigi et al. (26)	Morphine	Morphine · SB-334867 (OX1R) · Intracranial · stress	SB-334867	OX1R	Intracranial	VTA OX1R · FSS	0.3–3 nM/side	IC: VTA	18/6	-1.362220168	0.260881468	-2.363302298	-0.361138038	VTA OX1R · MOR CPP FSS-reinst.	Male albino Wistar rats	unflagged		stress
C073	Ebrahimian et al. (127)	Ebrahimian et al. (127)	Morphine	Morphine · TCS-OX2-29 (OX2R) · Intracranial · stress	TCS-OX2-29	OX2R	Intracranial	DG OX2R · FSS	1–30 µg/side	IC: DG	24/6	-0.340179937	0.21026204	-1.238908472	0.558548598	DG OX2R · MOR CPP FSS-reinst.	Male albino Wistar rats	unflagged		stress
C074	Azizbeigi et al. (60)	Azizbeigi et al. (60) 	Morphine	Morphine · TCS-OX2-29 (OX2R) · Intracranial · stress	TCS-OX2-29	OX2R	Intracranial	VTA OX2R · FSS	0.3–10 nM/side	IC: VTA	28/7	-1.2901555636	0.2023500197	-2.1718288793	-0.4084822479	VTA OX2R · MOR CPP FSS-reinst.	Male Wistar rats	unresolved flag	Restored from master sheet rows 1316-1320; TCS-OX2-29 4 dose arms combined (Cochrane)	stress
C071	Sahafzadeh et al. (10)	Sahafzadeh et al. (10) 	Morphine	Morphine · SB-334867 (OX1R) · Intracranial · food-deprivation	SB-334867	OX1R	Intracranial	NAc OX1R	0.1–10 nM	IC: NAc	24/8	-1.5250885414	0.203008777	-2.4081958495	-0.6419812333	NAc OX1R · MOR CPP food-depr.-reinst.	Male albino Wistar rats	unresolved flag	Restored from master sheet rows 245-248; SB 0.1,1,10 nM combined (Cochrane)	food-deprivation
C075	Sahafzadeh et al. (10)	Sahafzadeh et al. (10) 	Morphine	Morphine · TCS-OX2-29 (OX2R) · Intracranial · food-deprivation	TCS-OX2-29	OX2R	Intracranial	NAc OX2R	5–25 nM	IC: NAc	16/8	-1.349812424	0.2254582	-2.280451131	-0.419173717	NAc OX2R · MOR CPP food-depr.-reinst.	Male albino Wistar rats	unresolved flag	1 nM arm (row 254) carries vehicle treatment text and control flag, so it was dropped	food-deprivation
C072	Pourhamzeh et al. (47)	Pourhamzeh et al. (47)	Morphine	Morphine · SB-334867 (OX1R) · Intracranial · unspecified	SB-334867	OX1R	Intracranial	DG OX1R	3–30 nM/side	IC: DG	18/6	-0.550948352	0.228546057	-1.487938364	0.386041659	DG OX1R · MOR CPP reinst.	Male Wistar rats	unflagged		unspecified
C076	Pourhamzeh et al. (47)	Pourhamzeh et al. (47)	Morphine	Morphine · TCS-OX2-29 (OX2R) · Intracranial · unspecified	TCS-OX2-29	OX2R	Intracranial	DG OX2R	3–30 nM/side	IC: DG	18/6	-0.8509540414	0.2373081135	-1.8057364041	0.1038283213	DG OX2R · MOR CPP reinst.	Male Wistar rats	source-checked	Corrected; source checked	unspecified
C064	Amirteymori et al. (109)	Amirteymori et al. (109)	Methamphetamine	Methamphetamine · SB-334867 (OX1R) · Intracranial · drug-prime	SB-334867	OX1R	Intracranial	NAc OX1R	1–30 nmol/side	IC: NAc	27/8	-1.276140826	0.185301829	-2.119840627	-0.432441024	NAc OX1R · METH CPP prime-reinst.	Male albino Wistar rats	unflagged		drug-prime
C063	Veisi et al. (77)	Veisi et al. (77)	Methamphetamine	Methamphetamine · SB-334867 (OX1R) · Intracranial · drug-prime	SB-334867	OX1R	Intracranial	CA1 OX1R	1–30 nmol/side	IC: CA1	32/9	-0.8690519642	0.151571493	-1.6321087498	-0.1059951787	CA1 OX1R · METH CPP prime-reinst.	Male Wistar rats	source-checked	Source checked; retained	drug-prime
C065	Amirteymori et al. (109)	Amirteymori et al. (109)	Methamphetamine	Methamphetamine · TCS-OX2-29 (OX2R) · Intracranial · drug-prime	TCS-OX2-29	OX2R	Intracranial	NAc OX2R	1–30 nmol/side	IC: NAc	27/7	-1.062759082	0.19650384	-1.931586694	-0.193931469	NAc OX2R · METH CPP prime-reinst.	Male albino Wistar rats	unflagged		drug-prime
C066	Amirteymori et al. (71)	Amirteymori et al. (71)	Methamphetamine	Methamphetamine · TCS-OX2-29 (OX2R) · Intracranial · drug-prime	TCS-OX2-29	OX2R	Intracranial	CA1 OX2R	1–30 nmol/side	IC: CA1	36/9	-1.415401374	0.161148456	-2.202195609	-0.628607139	CA1 OX2R · METH CPP prime-reinst.	Male Wistar rats	unflagged		drug-prime
C067	Zamanirad et al. (89)	Zamanirad et al. (89)	Methamphetamine	Methamphetamine · TCS-OX2-29 (OX2R) · Intracranial · drug-prime	TCS-OX2-29	OX2R	Intracranial	VTA OX2R	1–30 nmol	IC: VTA	32/8	-1.173049743	0.173450571	-1.98932374	-0.356775747	VTA OX2R · METH CPP prime-reinst.	Male Wistar rats	unflagged		drug-prime
C068	Shoblock et al. (98)	Shoblock et al. (98)	Alcohol	Alcohol · JNJ-10397049 (OX2R) · Systemic · drug-prime	JNJ-10397049	OX2R	Systemic	OX2R	10 mg/kg	s.c.	11/10	-0.901274671	0.210249473	-1.799976347	-0.002572994	OX2R · EtOH CPP prime-reinst.	Male DBA/2 mice	unflagged		drug-prime
C078	Tung et al. (45)	Tung et al. (45)	Cocaine	Cocaine · SB-334867 (OX1R) · Intracranial · stress	SB-334867	OX1R	Intracranial	VTA OX1R · Restraint	15 nmol	IC: VTA	6/6	-4.7716513489	1.2820273582	-6.9908528677	-2.5524498301	VTA OX1R · COC CPP restraint-reinst.	WT/Cnr1-deficient C57BL/6 mice	source-checked	Corrected; source checked	stress
C077	Tung et al. (45)	Tung et al. (45)	Cocaine	Cocaine · SB-334867 (OX1R) · Systemic · stress	SB-334867	OX1R	Systemic	OX1R · Restraint	15 mg/kg	i.p.	9/7	-1.53487568	0.327588359	-2.656667644	-0.413083716	OX1R · COC CPP restraint-reinst.	WT/Cnr1-deficient C57BL/6 mice	unflagged		stress", stringsAsFactors = FALSE)
pools <- read.delim(text = "group	k_pooled	k_studies_pooled	g	ci_lo	ci_hi	tau2	I2	Q	df_Q	p_Q	df_t	pi_lo	pi_hi	t	p
Morphine · SB-334867 (OX1R) · Intracranial · drug-prime	3.0	3.0	-1.102623178903298	-2.277759888182376	0.0725135303757802	0.0	0.0	0.7051995084865094	2.0	0.7028584532004474	2.0	-4.572930582021098	2.367684224214502	-4.037151246431383	0.0562299208474011
Morphine · TCS-OX2-29 (OX2R) · Intracranial · drug-prime	4.0	4.0	-1.0991360239743089	-1.8327499476284848	-0.3655221003201329	0.0	0.0	0.7170578602619919	3.0	0.8691846225482748	3.0	-2.0909786658917064	-0.1072933820569113	-4.768095677734419	0.017523092616653
Methamphetamine · TCS-OX2-29 (OX2R) · Intracranial · drug-prime	3.0	3.0	-1.2283048509152854	-2.2700224064481023	-0.1865872953824685	0.0	0.0	0.3742899941992949	2.0	0.8293234781680644	2.0	-4.304610880995044	1.848001179164473	-5.073322602355498	0.0367252138857423", stringsAsFactors = FALSE)

strata <- split(effects, factor(effects$group, levels = unique(effects$group)))
omitted <- Filter(function(d) length(unique(d$study)) == 1L, strata)
shown <- if (hide_single_study) strata[!names(strata) %in% names(omitted)] else strata
stopifnot(sum(vapply(shown, nrow, integer(1))) == if (hide_single_study) 17L else 24L)

# Use physical coordinates (inches) for consistent text and spacing.
W <- 19.52
X <- function(x) x * 1.22
left <- 9.06; right <- 12.53
xg <- function(x) left + (x + 8) / 12 * (right - left)
num <- function(x) gsub("-", "−", sprintf("%.2f", x), fixed = TRUE)
ci <- function(g, l, u) sprintf("%s [%s; %s]", num(g), num(l), num(u))
# Dose display only: the antagonist is already named in the subgroup heading.
# The original dose strings are retained in effects$dose.
wrap_ids <- c("C055", "C069")
row_height <- function(d) ifelse(d$contrast_id %in% wrap_ids, .66, .38)
body_height <- sum(vapply(shown, function(d) sum(row_height(d)), numeric(1)))
n_bands <- length(unique(vapply(shown, function(d) d$substance[1], character(1))))
axis_y <- 1.32 + .34*n_bands + .35*length(shown) + body_height +
  .76*sum(names(shown) %in% pools$group) + .38*sum(!names(shown) %in% pools$group) + .15
H <- axis_y + 3.51

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
  tx(.2,.28,"Fig 2D. CPP reinstatement",16,"bold")
  tx(.2,.69,"Return of extinguished preference; analyses are stratified by reinstatement trigger.",11)
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
    heading <- sprintf("%s (%s) · %s · %s", d$antagonist[1],d$receptor[1],tolower(d$route_class[1]),d$trigger[1])
    tx(.29,y+.14,heading,11,"bold")
    y <- y + .35
    q <- pools[pools$group == d$group[1],,drop=FALSE]
    w <- if (nrow(q)) { v <- 1/(d$var + q$tau2); 100*v/sum(v, na.rm=TRUE) } else rep(NA_real_,nrow(d))
    if (nrow(q) == 1L) {
      pooled_x <- xg(q$g)
      ln(pooled_x, pooled_x, y + .02, y + .14 + sum(row_height(d)),
         lwd=1.1, lty="dotted")
    }
    for (j in seq_len(nrow(d))) {
      r <- d[j,]
      wrapped <- r$contrast_id %in% wrap_ids
      yy <- y + if (wrapped) .28 else .14
      values <- c(r$label,r$experiment,r$dose,r$route,r$n,if (is.na(r$g)) "Not estimable" else ci(r$g,r$ci_lo,r$ci_hi),
                  if (is.na(w[j])) "" else sprintf("%.1f%%",w[j]))
      for (i in seq_along(xx)) {
        if (i == 3L && wrapped) {
          tx(xx[i], yy - .135, "1, 3, 10, and 30", room=1.70)
          tx(xx[i], yy + .135, "μg/0.5 μL/side", room=1.70)
        } else {
          tx(xx[i], yy, values[i], adj=c(0,0,0,0,.5,0,1)[i],
             room=c(2.50,2.10,1.70,1.16,.92,2.31,.69)[i])
        }
      }
      if (!is.na(r$g)) {
        ln(xg(r$ci_lo),xg(r$ci_hi),yy)
        side <- .025*sqrt(if (is.na(w[j])) 18 else 8+.9*w[j])
        rect(xg(r$g),yy,side,side,"#2CA02C")
      }
      y <- y + row_height(r)
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
  for (j in seq(-8, 4, by=2)) {
    ln(xg(j),xg(j),axis_y,axis_y+.06)
    tx(xg(j),axis_y+.23,if(j<0) paste0("−",abs(j)) else as.character(j),10,adj=.5)
  }
  tx(xg(-4),axis_y+.58,"Favours antagonist",9,adj=.5,room=1.62)
  tx(xg(2),axis_y+.58,"Favours vehicle",9,adj=.5,room=1.62)
  tx((left+right)/2,axis_y+.92,"Standardized mean difference (Hedges’ g)",11,adj=.5)
  notes <- c(
    if (hide_single_study) "Seven subgroups represented by one study each are omitted from the main panel; their rows remain embedded.",
    "‡ Not estimable: effect withheld because source data could not be verified; excluded from pooling.",
    "Squares show cohort estimates; horizontal lines show 95% CIs. In pooled strata, larger squares indicate greater random-effects weights.",
    "Diamonds show REML estimates with modified HKSJ 95% CIs (q* ≥ 1); red bars show 95% prediction intervals. T/C = treatment/control.",
    "† Unresolved data quality flag (excluded in S2).",
    "Dose arms sharing a vehicle group were combined into one treatment arm for the cohort estimate.",
    "FSS = forced swim stress. Doses are transcribed as reported. For entries in nM, the administered amount could not be established from the reported concentration alone.")
  notes <- c(notes, "Vertical dotted lines mark subgroup pooled estimates; the solid vertical line marks zero.")
  for (i in seq_along(notes)) tx(.2,axis_y+1.32+(i-1)*.26,notes[i],9.5,room=15.6)
}

args <- commandArgs(trailingOnly=TRUE)
out <- if(length(args)) args[1] else "."
dir.create(out,recursive=TRUE,showWarnings=FALSE)
stem <- file.path(out,"Fig2D_CPP_reinstatement_final")
if (!capabilities("cairo")) stop("An R build with Cairo support is required.")
cairo_pdf(paste0(stem,".pdf"),width=W,height=H,bg="white")
draw()
invisible(dev.off())
png(paste0(stem,".png"),width=W,height=H,units="in",res=300,type="cairo",bg="white")
draw()
invisible(dev.off())
