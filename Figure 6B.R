# Figure 6B: publication layout. Base R and grid; Cairo graphics required.
# Rscript Fig6B_main_and_supplement_combined.R [output_directory]
FONT_INCREASE <- 3
# TRUE suppresses strata with one study in the plotted panel.
# All source rows remain embedded; pooled results are imported, not refit.
hide_single_study <- TRUE
library(grid)
effects <- read.delim(text = "contrast_id	study	label	substance	group	antagonist	receptor	route_class	experiment	dose	route	n	g	var	ci_lo	ci_hi	experiment_name	cohort_description	data_status	verify	sign
C133	Azizi et al. (37)	Azizi et al. (37)	Morphine	Wet-dog shakes · SB-334867 (OX1R) · Intracranial	SB-334867	OX1R	Intracranial	LC OX1R · Naloxone	100 µM, 0.2 µL	IC: LC	9/9	-0.922751161	0.245874158	-1.894613018	0.049110696	LC OX1R · MOR withdrawal (nalox.)	Male Wistar rats	unflagged		Wet-dog shakes
C136	Ahmadi-Soleimani et al. (88)	Ahmadi-Soleimani et al. (88)	Morphine	Wet-dog shakes · SB-334867 (OX1R) · Intracranial	SB-334867	OX1R	Intracranial	LPGi OX1R · Naloxone	100 µM, 0.2 µL	IC: LPGi	8/13	-0.494436689	0.207743735	-1.387766984	0.398893606	LPGi OX1R · MOR withdrawal (nalox.)	Male Wistar rats	unflagged		Wet-dog shakes
C132	Mousavi et al. (23)	Mousavi et al. (23)	Morphine	Wet-dog shakes · SB-334867 (OX1R) · Intracranial	SB-334867	OX1R	Intracranial	LC OX1R · Dependence induction	3 mM, 0.2 µL	IC: LC	9/9	-1.632042221	0.29621005	-2.698756208	-0.565328235	LC OX1R · MOR dependence induction	Male Wistar rats	unflagged		Wet-dog shakes
C134	Davoudi et al. (93)	Davoudi et al. (93)	Morphine	Wet-dog shakes · SB-334867 (OX1R) · Intracranial	SB-334867	OX1R	Intracranial	LC OX1R · Naloxone	3 mM, 0.2 µL	IC: LC	7/7	-1.435408289	0.359299891	-2.610242642	-0.260573935	LC OX1R · MOR withdrawal (nalox.)	Male Wistar rats	unflagged		Wet-dog shakes
C135	Hooshmand et al. (83)	Hooshmand et al. (83)	Morphine	Wet-dog shakes · SB-334867 (OX1R) · Intracranial	SB-334867	OX1R	Intracranial	LC OX1R · Glutamate	3 mM, 200 nL	IC: LC	7/7	-0.877552589	0.313217805	-1.974463396	0.219358219	LC OX1R · MOR withdrawal (glutamate)	Male Wistar rats	unflagged		Wet-dog shakes
C137	Rezaei et al. (48)	Rezaei et al. (48) 	Morphine	Wet-dog shakes · SB-334867 (OX1R) · Intracranial	SB-334867	OX1R	Intracranial	LPGi OX1R · Naloxone	3 mM, 0.2 µL	IC: LPGi	10/10	-2.860639683	0.404581485	-4.107308499	-1.613970866	LPGi OX1R · MOR withdrawal (nalox.)	Male Wistar rats	unresolved flag	Control arm filed under a separately labelled 'validation' experiment (same protocol)	Wet-dog shakes
C139	Azizi et al. (37)	Azizi et al. (37)	Morphine	Teeth chattering · SB-334867 (OX1R) · Intracranial	SB-334867	OX1R	Intracranial	LC OX1R · Naloxone	100 µM, 0.2 µL	IC: LC	9/9	-3.228409745	0.511739708	-4.630489289	-1.826330202	LC OX1R · MOR withdrawal (nalox.)	Male Wistar rats	unflagged		Teeth chattering
C142	Ahmadi-Soleimani et al. (88)	Ahmadi-Soleimani et al. (88)	Morphine	Teeth chattering · SB-334867 (OX1R) · Intracranial	SB-334867	OX1R	Intracranial	LPGi OX1R · Naloxone	100 µM, 0.2 µL	IC: LPGi	8/13	-0.431112145	0.20634826	-1.321437004	0.459212714	LPGi OX1R · MOR withdrawal (nalox.)	Male Wistar rats	unflagged		Teeth chattering
C138	Mousavi et al. (23)	Mousavi et al. (23)	Morphine	Teeth chattering · SB-334867 (OX1R) · Intracranial	SB-334867	OX1R	Intracranial	LC OX1R · Dependence induction	3 mM, 0.2 µL	IC: LC	9/9	-1.775721309	0.309810727	-2.86664989	-0.684792728	LC OX1R · MOR dependence induction	Male Wistar rats	unflagged		Teeth chattering
C140	Davoudi et al. (93)	Davoudi et al. (93)	Morphine	Teeth chattering · SB-334867 (OX1R) · Intracranial	SB-334867	OX1R	Intracranial	LC OX1R · Naloxone	3 mM, 0.2 µL	IC: LC	7/7	-1.425803552	0.35831842	-2.599032207	-0.252574896	LC OX1R · MOR withdrawal (nalox.)	Male Wistar rats	unflagged		Teeth chattering
C141	Hooshmand et al. (83)	Hooshmand et al. (83)	Morphine	Teeth chattering · SB-334867 (OX1R) · Intracranial	SB-334867	OX1R	Intracranial	LC OX1R · Glutamate	3 mM, 200 nL	IC: LC	7/7	-1.566130221	0.373312995	-2.763655386	-0.368605056	LC OX1R · MOR withdrawal (glutamate)	Male Wistar rats	unflagged		Teeth chattering
C143	Rezaei et al. (48)	Rezaei et al. (48) 	Morphine	Teeth chattering · SB-334867 (OX1R) · Intracranial	SB-334867	OX1R	Intracranial	LPGi OX1R · Naloxone	3 mM, 0.2 µL	IC: LPGi	10/10	-1.303284508	0.242463763	-2.268382728	-0.338186288	LPGi OX1R · MOR withdrawal (nalox.)	Male Wistar rats	unresolved flag	Control arm filed under a separately labelled 'validation' experiment (same protocol)	Teeth chattering
C145	Azizi et al. (37)	Azizi et al. (37)	Morphine	Sniffing · SB-334867 (OX1R) · Intracranial	SB-334867	OX1R	Intracranial	LC OX1R · Naloxone	100 µM, 0.2 µL	IC: LC	9/9	-0.561060288	0.230966351	-1.502998578	0.380878001	LC OX1R · MOR withdrawal (nalox.)	Male Wistar rats	unflagged		Sniffing
C148	Ahmadi-Soleimani et al. (88)	Ahmadi-Soleimani et al. (88)	Morphine	Sniffing · SB-334867 (OX1R) · Intracranial	SB-334867	OX1R	Intracranial	LPGi OX1R · Naloxone	100 µM, 0.2 µL	IC: LPGi	8/13	-0.800021866	0.217162005	-1.713377719	0.113333987	LPGi OX1R · MOR withdrawal (nalox.)	Male Wistar rats	unflagged		Sniffing
C144	Mousavi et al. (23)	Mousavi et al. (23)	Morphine	Sniffing · SB-334867 (OX1R) · Intracranial	SB-334867	OX1R	Intracranial	LC OX1R · Dependence induction	3 mM, 0.2 µL	IC: LC	9/9	-0.126967178	0.222670018	-1.051833503	0.797899147	LC OX1R · MOR dependence induction	Male Wistar rats	unflagged		Sniffing
C146	Davoudi et al. (93)	Davoudi et al. (93)	Morphine	Sniffing · SB-334867 (OX1R) · Intracranial	SB-334867	OX1R	Intracranial	LC OX1R · Naloxone	3 mM, 0.2 µL	IC: LC	7/7	-1.196790311	0.336868109	-2.334360084	-0.059220538	LC OX1R · MOR withdrawal (nalox.)	Male Wistar rats	unflagged		Sniffing
C147	Hooshmand et al. (83)	Hooshmand et al. (83)	Morphine	Sniffing · SB-334867 (OX1R) · Intracranial	SB-334867	OX1R	Intracranial	LC OX1R · Glutamate	3 mM, 200 nL	IC: LC	7/7	-1.901071402	0.414788303	-3.163367805	-0.638774999	LC OX1R · MOR withdrawal (glutamate)	Male Wistar rats	unflagged		Sniffing
C149	Rezaei et al. (48)	Rezaei et al. (48) 	Morphine	Sniffing · SB-334867 (OX1R) · Intracranial	SB-334867	OX1R	Intracranial	LPGi OX1R · Naloxone	3 mM, 0.2 µL	IC: LPGi	10/10	-1.635257438	0.266851672	-2.647729524	-0.622785351	LPGi OX1R · MOR withdrawal (nalox.)	Male Wistar rats	unresolved flag	Control arm filed under a separately labelled 'validation' experiment (same protocol)	Sniffing
C151	Azizi et al. (37)	Azizi et al. (37)	Morphine	Rearing · SB-334867 (OX1R) · Intracranial	SB-334867	OX1R	Intracranial	LC OX1R · Naloxone	100 µM, 0.2 µL	IC: LC	9/9	-0.310987666	0.224908704	-1.240491586	0.618516253	LC OX1R · MOR withdrawal (nalox.)	Male Wistar rats	unflagged		Rearing
C154	Ahmadi-Soleimani et al. (88)	Ahmadi-Soleimani et al. (88)	Morphine	Rearing · SB-334867 (OX1R) · Intracranial	SB-334867	OX1R	Intracranial	LPGi OX1R · Naloxone	100 µM, 0.2 µL	IC: LPGi	8/13	-1.0496115168	0.2281536564	-1.9857967953	-0.1134262383	LPGi OX1R · MOR withdrawal (nalox.)	Male Wistar rats	source-checked	Corrected; source checked and effect recalculated	Rearing
C150	Mousavi et al. (23)	Mousavi et al. (23)	Morphine	Rearing · SB-334867 (OX1R) · Intracranial	SB-334867	OX1R	Intracranial	LC OX1R · Dependence induction	3 mM, 0.2 µL	IC: LC	9/9	-0.702634573	0.235935982	-1.654652626	0.249383479	LC OX1R · MOR dependence induction	Male Wistar rats	unflagged		Rearing
C152	Davoudi et al. (93)	Davoudi et al. (93)	Morphine	Rearing · SB-334867 (OX1R) · Intracranial	SB-334867	OX1R	Intracranial	LC OX1R · Naloxone	3 mM, 0.2 µL	IC: LC	7/7	-0.826693249	0.310122205	-1.918170091	0.264783593	LC OX1R · MOR withdrawal (nalox.)	Male Wistar rats	unflagged		Rearing
C153	Hooshmand et al. (83)	Hooshmand et al. (83)	Morphine	Rearing · SB-334867 (OX1R) · Intracranial	SB-334867	OX1R	Intracranial	LC OX1R · Glutamate	3 mM, 200 nL	IC: LC	7/7	-0.834161498	0.310565193	-1.926417612	0.258094616	LC OX1R · MOR withdrawal (glutamate)	Male Wistar rats	unflagged		Rearing
C155	Rezaei et al. (48)	Rezaei et al. (48) 	Morphine	Rearing · SB-334867 (OX1R) · Intracranial	SB-334867	OX1R	Intracranial	LPGi OX1R · Naloxone	3 mM, 0.2 µL	IC: LPGi	10/10	-1.454182014	0.252866133	-2.439765523	-0.468598505	LPGi OX1R · MOR withdrawal (nalox.)	Male Wistar rats	unresolved flag	Control arm filed under a separately labelled 'validation' experiment (same protocol)	Rearing
C157	Azizi et al. (37)	Azizi et al. (37)	Morphine	Scratching · SB-334867 (OX1R) · Intracranial	SB-334867	OX1R	Intracranial	LC OX1R · Naloxone	100 µM, 0.2 µL	IC: LC	9/9	-1.035027568	0.251980057	-2.018882755	-0.05117238	LC OX1R · MOR withdrawal (nalox.)	Male Wistar rats	unflagged		Scratching
C156	Mousavi et al. (23)	Mousavi et al. (23)	Morphine	Scratching · SB-334867 (OX1R) · Intracranial	SB-334867	OX1R	Intracranial	LC OX1R · Dependence induction	3 mM, 0.2 µL	IC: LC	9/9	-1.604517115	0.293735421	-2.666765929	-0.5422683	LC OX1R · MOR dependence induction	Male Wistar rats	unflagged		Scratching
C158	Davoudi et al. (93)	Davoudi et al. (93)	Morphine	Scratching · SB-334867 (OX1R) · Intracranial	SB-334867	OX1R	Intracranial	LC OX1R · Naloxone	3 mM, 0.2 µL	IC: LC	7/7	-1.491597409	0.365173673	-2.675995842	-0.307198976	LC OX1R · MOR withdrawal (nalox.)	Male Wistar rats	unflagged		Scratching
C159	Hooshmand et al. (83)	Hooshmand et al. (83)	Morphine	Scratching · SB-334867 (OX1R) · Intracranial	SB-334867	OX1R	Intracranial	LC OX1R · Glutamate	3 mM, 200 nL	IC: LC	7/7	-1.383315691	0.354055796	-2.549544993	-0.21708639	LC OX1R · MOR withdrawal (glutamate)	Male Wistar rats	unflagged		Scratching
C161	Azizi et al. (37)	Azizi et al. (37)	Morphine	Head tremor · SB-334867 (OX1R) · Intracranial	SB-334867	OX1R	Intracranial	LC OX1R · Naloxone	100 µM, 0.2 µL	IC: LC	9/9	-1.092127644	0.255353966	-2.082547637	-0.101707651	LC OX1R · MOR withdrawal (nalox.)	Male Wistar rats	unflagged		Head tremor
C160	Mousavi et al. (23)	Mousavi et al. (23)	Morphine	Head tremor · SB-334867 (OX1R) · Intracranial	SB-334867	OX1R	Intracranial	LC OX1R · Dependence induction	3 mM, 0.2 µL	IC: LC	9/9	-0.666161463	0.234549197	-1.615377506	0.28305458	LC OX1R · MOR dependence induction	Male Wistar rats	unflagged		Head tremor
C162	Davoudi et al. (93)	Davoudi et al. (93)	Morphine	Head tremor · SB-334867 (OX1R) · Intracranial	SB-334867	OX1R	Intracranial	LC OX1R · Naloxone	3 mM, 0.2 µL	IC: LC	7/7	-1.977233774	0.425337621	-3.255481397	-0.698986152	LC OX1R · MOR withdrawal (nalox.)	Male Wistar rats	unflagged		Head tremor
C163	Hooshmand et al. (83)	Hooshmand et al. (83)	Morphine	Head tremor · SB-334867 (OX1R) · Intracranial	SB-334867	OX1R	Intracranial	LC OX1R · Glutamate	3 mM, 200 nL	IC: LC	7/7	-0.878390615	0.31327036	-1.975393443	0.218612214	LC OX1R · MOR withdrawal (glutamate)	Male Wistar rats	unflagged		Head tremor
C164	Azizi et al. (37)	Azizi et al. (37)	Morphine	Chewing · SB-334867 (OX1R) · Intracranial	SB-334867	OX1R	Intracranial	LC OX1R · Naloxone	100 µM, 0.2 µL	IC: LC	9/9	-1.333945298	0.271650279	-2.355480113	-0.312410483	LC OX1R · MOR withdrawal (nalox.)	Male Wistar rats	unflagged		Chewing
C166	Ahmadi-Soleimani et al. (88)	Ahmadi-Soleimani et al. (88)	Morphine	Chewing · SB-334867 (OX1R) · Intracranial	SB-334867	OX1R	Intracranial	LPGi OX1R · Naloxone	100 µM, 0.2 µL	IC: LPGi	8/13	-0.958054798	0.223777101	-1.885217422	-0.030892175	LPGi OX1R · MOR withdrawal (nalox.)	Male Wistar rats	unflagged		Chewing
C165	Hooshmand et al. (83)	Hooshmand et al. (83)	Morphine	Chewing · SB-334867 (OX1R) · Intracranial	SB-334867	OX1R	Intracranial	LC OX1R · Glutamate	3 mM, 200 nL	IC: LC	7/7	-2.209950616	0.460138633	-3.539463172	-0.880438059	LC OX1R · MOR withdrawal (glutamate)	Male Wistar rats	unflagged		Chewing
C167	Rezaei et al. (48)	Rezaei et al. (48) 	Morphine	Chewing · SB-334867 (OX1R) · Intracranial	SB-334867	OX1R	Intracranial	LPGi OX1R · Naloxone	3 mM, 0.2 µL	IC: LPGi	10/10	-1.214404457	0.236869455	-2.168303964	-0.260504949	LPGi OX1R · MOR withdrawal (nalox.)	Male Wistar rats	unresolved flag	Control arm filed under a separately labelled 'validation' experiment (same protocol)	Chewing
C168	Davoudi et al. (93)	Davoudi et al. (93) 	Morphine	Writhing · SB-334867 (OX1R) · Intracranial	SB-334867	OX1R	Intracranial	LC OX1R · Naloxone	3 mM, 0.2 µL	IC: LC	7/7	-1.5201889845	0.368249091	-2.7095861882	-0.3307917809	LC OX1R · MOR withdrawal (nalox.)	Male Wistar rats	unresolved flag	Restored from master sheet rows 301,310; single dose arm	Writhing
C169	Hooshmand et al. (83)	Hooshmand et al. (83)	Morphine	Writhing · SB-334867 (OX1R) · Intracranial	SB-334867	OX1R	Intracranial	LC OX1R · Glutamate	3 mM, 200 nL	IC: LC	7/7	-2.047727175	0.435470949	-3.341111783	-0.754342566	LC OX1R · MOR withdrawal (glutamate)	Male Wistar rats	unflagged		Writhing
C170	Rezaei et al. (48)	Rezaei et al. (48) 	Morphine	Writhing · SB-334867 (OX1R) · Intracranial	SB-334867	OX1R	Intracranial	LPGi OX1R · Naloxone	3 mM, 0.2 µL	IC: LPGi	10/10	-1.953528003	0.295406791	-3.018794656	-0.88826135	LPGi OX1R · MOR withdrawal (nalox.)	Male Wistar rats	unresolved flag	Control arm filed under a separately labelled 'validation' experiment (same protocol)	Writhing
C173	Ahmadi-Soleimani et al. (88)	Ahmadi-Soleimani et al. (88)	Morphine	Defecation · SB-334867 (OX1R) · Intracranial	SB-334867	OX1R	Intracranial	LPGi OX1R · Naloxone	100 µM, 0.2 µL	IC: LPGi	8/13	-0.556241275	0.209289847	-1.452889669	0.340407119	LPGi OX1R · MOR withdrawal (nalox.)	Male Wistar rats	unflagged		Defecation
C171	Mousavi et al. (23)	Mousavi et al. (23)	Morphine	Defecation · SB-334867 (OX1R) · Intracranial	SB-334867	OX1R	Intracranial	LC OX1R · Dependence induction	3 mM, 0.2 µL	IC: LC	9/9	-1.003763676	0.250209487	-1.984156176	-0.023371176	LC OX1R · MOR dependence induction	Male Wistar rats	unflagged		Defecation
C172	Davoudi et al. (93)	Davoudi et al. (93)	Morphine	Defecation · SB-334867 (OX1R) · Intracranial	SB-334867	OX1R	Intracranial	LC OX1R · Naloxone	3 mM, 0.2 µL	IC: LC	7/7	-0.643482347	0.300502483	-1.717897505	0.430932812	LC OX1R · MOR withdrawal (nalox.)	Male Wistar rats	unflagged		Defecation
C175	Azizi et al. (37)	Azizi et al. (37)	Morphine	Jumping · SB-334867 (OX1R) · Intracranial	SB-334867	OX1R	Intracranial	LC OX1R · Naloxone	100 µM, 0.2 µL	IC: LC	9/9	-0.723985184	0.236782071	-1.677708723	0.229738355	LC OX1R · MOR withdrawal (nalox.)	Male Wistar rats	unflagged		Jumping
C174	Mousavi et al. (23)	Mousavi et al. (23)	Morphine	Jumping · SB-334867 (OX1R) · Intracranial	SB-334867	OX1R	Intracranial	LC OX1R · Dependence induction	3 mM, 0.2 µL	IC: LC	9/9	-1.232502574	0.264418405	-2.240348015	-0.224657134	LC OX1R · MOR dependence induction	Male Wistar rats	unflagged		Jumping
C177	Azizi et al. (37)	Azizi et al. (37)	Morphine	Diarrhoea · SB-334867 (OX1R) · Intracranial	SB-334867	OX1R	Intracranial	LC OX1R · Naloxone	100 µM, 0.2 µL	IC: LC	9/9	-1.113575816	0.256668086	-2.106541022	-0.120610611	LC OX1R · MOR withdrawal (nalox.)	Male Wistar rats	unflagged		Diarrhoea
C176	Mousavi et al. (23)	Mousavi et al. (23)	Morphine	Diarrhoea · SB-334867 (OX1R) · Intracranial	SB-334867	OX1R	Intracranial	LC OX1R · Dependence induction	3 mM, 0.2 µL	IC: LC	9/9	-2.129304306	0.348164912	-3.285790879	-0.972817734	LC OX1R · MOR dependence induction	Male Wistar rats	unflagged		Diarrhoea
C178	Ahmadi-Soleimani et al. (88)	Ahmadi-Soleimani et al. (88)	Morphine	Grooming · SB-334867 (OX1R) · Intracranial	SB-334867	OX1R	Intracranial	LPGi OX1R · Naloxone	100 µM, 0.2 µL	IC: LPGi	8/13	-1.305647313	0.242511527	-2.270840589	-0.340454038	LPGi OX1R · MOR withdrawal (nalox.)	Male Wistar rats	unflagged		Grooming
C179	Rezaei et al. (48)	Rezaei et al. (48) 	Morphine	Grooming · SB-334867 (OX1R) · Intracranial	SB-334867	OX1R	Intracranial	LPGi OX1R · Naloxone	3 mM, 0.2 µL	IC: LPGi	10/10	-2.095875511	0.309817354	-3.18681576	-1.004935263	LPGi OX1R · MOR withdrawal (nalox.)	Male Wistar rats	unresolved flag	Control arm filed under a separately labelled 'validation' experiment (same protocol)	Grooming
C181	Ahmadi-Soleimani et al. (88)	Ahmadi-Soleimani et al. (88)	Morphine	Genital licking · SB-334867 (OX1R) · Intracranial	SB-334867	OX1R	Intracranial	LPGi OX1R · Naloxone	100 µM, 0.2 µL	IC: LPGi	8/13	-0.313725644	0.2042665	-1.199548065	0.572096777	LPGi OX1R · MOR withdrawal (nalox.)	Male Wistar rats	unflagged		Genital licking
C180	Davoudi et al. (93)	Davoudi et al. (93)	Morphine	Genital licking · SB-334867 (OX1R) · Intracranial	SB-334867	OX1R	Intracranial	LC OX1R · Naloxone	3 mM, 0.2 µL	IC: LC	7/7	-1.290747182	0.345215296	-2.44232452	-0.139169844	LC OX1R · MOR withdrawal (nalox.)	Male Wistar rats	unflagged		Genital licking
C182	Ahmadi-Soleimani et al. (88)	Ahmadi-Soleimani et al. (88)	Morphine	Digging · SB-334867 (OX1R) · Intracranial	SB-334867	OX1R	Intracranial	LPGi OX1R · Naloxone	100 µM, 0.2 µL	IC: LPGi	8/13	-0.488656469	0.207608438	-1.381695816	0.404382879	LPGi OX1R · MOR withdrawal (nalox.)	Male Wistar rats	unflagged		Digging
C183	Rezaei et al. (48)	Rezaei et al. (48) 	Morphine	Digging · SB-334867 (OX1R) · Intracranial	SB-334867	OX1R	Intracranial	LPGi OX1R · Naloxone	3 mM, 0.2 µL	IC: LPGi	10/10	-2.18935703	0.319832105	-3.297789203	-1.080924858	LPGi OX1R · MOR withdrawal (nalox.)	Male Wistar rats	unresolved flag	Control arm filed under a separately labelled 'validation' experiment (same protocol)	Digging", stringsAsFactors = FALSE)
pools <- read.delim(text = "group	k_pooled	k_studies_pooled	g	ci_lo	ci_hi	tau2	I2	Q	df_Q	p_Q	df_t	pi_lo	pi_hi	t	p
Wet-dog shakes · SB-334867 (OX1R) · Intracranial	6.0	6.0	-1.3042965112397975	-2.156169767159913	-0.4524232553196819	0.3297615686115933	52.91979078775092	10.62017370708524	5.0	0.0594531543706179	5.0	-3.1451089293234578	0.5365159068438627	-3.93579783938099	0.0110061336802547
Teeth chattering · SB-334867 (OX1R) · Intracranial	6.0	6.0	-1.5257083095516424	-2.4466633013868417	-0.6047533177164429	0.4106496786248724	57.08118882360142	11.64990330102513	5.0	0.0399129145531649	5.0	-3.564089935367837	0.5126733162645527	-4.258577348277901	0.0080257606788037
Sniffing · SB-334867 (OX1R) · Intracranial	6.0	6.0	-0.9644275736833936	-1.6539535958151022	-0.2749015515516847	0.1539934351591806	36.80281283334558	7.911744531943689	5.0	0.1611671016804533	5.0	-2.2841730243421017	0.3553178769753148	-3.5954263118786045	0.0156183874929878
Rearing · SB-334867 (OX1R) · Intracranial	6.0	6.0	-0.8549815211440479	-1.385626694097669	-0.324336348190427	0.0	0.0	3.0040425243405693	5.0	0.6993625584253017	5.0	-1.4281230460001195	-0.2818399962879762	-4.141750608649532	0.0089817434961461
Scratching · SB-334867 (OX1R) · Intracranial	4.0	4.0	-1.3576025756632426	-2.242440957491056	-0.4727641938354291	0.0	0.0	0.671539453999871	3.0	0.8798768492417948	3.0	-2.5538999877005337	-0.1613051636259515	-4.882809549963539	0.0164242168738553
Head tremor · SB-334867 (OX1R) · Intracranial	4.0	4.0	-1.061708788479644	-1.9207997817532745	-0.2026177952060135	0.0	0.0	2.7485908327611552	3.0	0.4320328468997068	3.0	-2.223195849918828	0.0997782729595402	-3.933030654074251	0.029271190608681
Chewing · SB-334867 (OX1R) · Intracranial	4.0	4.0	-1.3146507263436478	-2.1491102646674305	-0.4801911880198651	0.0	0.0	2.354043790332254	3.0	0.5022466805346055	3.0	-2.442836174271959	-0.1864652784153366	-5.013790549024208	0.0152766345415011
Writhing · SB-334867 (OX1R) · Intracranial	3.0	3.0	-1.8391502058274047	-3.3239645192052327	-0.3543358924495778	0.0	0.0	0.4204577215668044	2.0	0.8103987562511118	2.0	-6.223969489646271	2.545669077991461	-5.329437211256842	0.0334510856526666
Defecation · SB-334867 (OX1R) · Intracranial	3.0	3.0	-0.7280167571266198	-1.9648160570646085	0.5087825428113686	0.0	0.0	0.4686566157760317	2.0	0.7911020482133736	2.0	-4.380420543728445	2.9243870294752057	-2.532669033295262	0.1268948643831944", stringsAsFactors = FALSE)

# Guard the original rows and display order for Writhing and Jumping.
reference_ids <- c("C168", "C169", "C170", "C175", "C174")
check <- effects[effects$sign %in% c("Writhing", "Jumping"), ]
stopifnot(identical(check$contrast_id, reference_ids),
          identical(check$n, c("7/7","7/7","10/10","9/9","9/9")),
          identical(check$g, c(-1.5201889845,-2.047727175,-1.953528003,
                               -0.723985184,-1.232502574)),
          identical(check$ci_lo,c(-2.7095861882,-3.341111783,-3.018794656,
                                  -1.677708723,-2.240348015)),
          identical(check$ci_hi,c(-0.3307917809,-0.754342566,-0.88826135,
                                  0.229738355,-0.224657134)))

strata <- split(effects, factor(effects$group, levels = unique(effects$group)))
omitted <- Filter(function(d) length(unique(d$study)) == 1L, strata)
shown <- if (hide_single_study) strata[!names(strata) %in% names(omitted)] else strata
stopifnot(sum(vapply(shown, nrow, integer(1))) == 52L)

# Use physical coordinates (inches) for consistent text and spacing.
W <- 23.20
X <- function(x) x * 1.45
left <- 9.06; right <- 12.53
xg <- function(x) left + (x + 8) / 11 * (right - left)
num <- function(x) gsub("-", "−", sprintf("%.2f", x), fixed = TRUE)
ci <- function(g, l, u) sprintf("%s [%s; %s]", num(g), num(l), num(u))
wrap_experiment <- function(d) grepl(" · ", d$experiment, fixed=TRUE)
row_height <- function(d) ifelse(wrap_experiment(d), .62, .38)
layout <- function(shown) {
  body_height <- sum(vapply(shown, function(d) sum(row_height(d)), numeric(1)))
  n_bands <- length(unique(vapply(shown, function(d) d$substance[1], character(1))))
  axis_y <- 1.45 + .34*n_bands + .35*length(shown) + body_height +
    .76*sum(names(shown) %in% pools$group) + .38*sum(!names(shown) %in% pools$group) + .15
  list(axis_y=axis_y, H=axis_y + 3.85)
}

draw <- function(shown, title, pooled_panel, page_height=layout(shown)$H) {
  axis_y <- layout(shown)$axis_y
  H <- page_height
  grid.newpage()
  pushViewport(viewport(xscale = c(0,W), yscale = c(0,H)))
  on.exit(popViewport())
  tx <- function(x,y,s,fs=10,face="plain",adj=0,room=Inf) {
    fs <- fs + 9 + FONT_INCREASE
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
  tx(.2,.28,title,16,"bold")
  tx(.2,.69,"Morphine withdrawal paradigms; each sign analysed separately.",11)
  xx <- c(.29,2.89,5.10,6.90,8.55,12.73,15.82)
  visible_cols <- if (pooled_panel) seq_along(xx) else seq_len(6L)
  for (j in visible_cols)
    tx(xx[j],1.12,c("Study","Experiment","Dose(s)","Route/site","n T/C","Hedges’ g [95% CI]","Weight")[j],
       11,"bold",adj=c(0,0,0,0,.5,0,1)[j])
  y <- 1.45
  last <- ""
  for (d in shown) {
    s <- d$substance[1]
    if (s != last) {
      rect(8,y+.16,15.70,.29,"#E7EDF4")
      tx(.2,y+.16,s,12,"bold")
      last <- s
      y <- y + .34
    }
    heading <- sprintf("%s · %s (%s) · %s", d$sign[1],d$antagonist[1],d$receptor[1],tolower(d$route_class[1]))
    tx(.29,y+.14,heading,11,"bold")
    y <- y + .35
    q <- pools[pools$group == d$group[1],,drop=FALSE]
    w <- if (nrow(q)) { v <- 1/(d$var + q$tau2); 100*v/sum(v) } else rep(NA_real_,nrow(d))
    if (nrow(q) == 1L) {
      pooled_x <- xg(q$g)
      ln(pooled_x, pooled_x, y + .02, y + .14 + sum(row_height(d)),
         lwd=1.1, lty="dotted")
    }
    for (j in seq_len(nrow(d))) {
      r <- d[j,]
      wrapped <- wrap_experiment(r)
      yy <- y + if (wrapped) .27 else .14
      values <- c(r$label,r$experiment,r$dose,r$route,r$n,ci(r$g,r$ci_lo,r$ci_hi),
                  if (is.na(w[j])) "" else sprintf("%.1f%%",w[j]))
      for (i in visible_cols) {
        if (i == 2L && wrapped) {
          parts <- strsplit(r$experiment, " · ", fixed=TRUE)[[1L]]
          tx(xx[i], yy-.125, parts[1L], room=2.10)
          tx(xx[i], yy+.125, parts[2L], room=2.10)
        } else {
          tx(xx[i], yy, values[i], adj=c(0,0,0,0,.5,0,1)[i],
             room=c(2.50,2.10,1.70,1.16,.92,2.31,.69)[i])
        }
      }
      ln(xg(r$ci_lo),xg(r$ci_hi),yy)
      side <- .025*sqrt(if (is.na(w[j])) 18 else 8+.9*w[j])
      rect(xg(r$g),yy,side,side,"#2CA02C")
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
  for (j in c(-8, -6, -4, -2, 0, 2, 3)) {
    ln(xg(j),xg(j),axis_y,axis_y+.06)
    tx(xg(j),axis_y+.23,if(j<0) paste0("−",abs(j)) else as.character(j),10,adj=.5)
  }
  tx(xg(-4),axis_y+.58,"Favours antagonist",9,adj=.5,room=1.62)
  tx(xg(1.5),axis_y+.58,"Favours vehicle",9,adj=.5,room=1.62)
  tx((left+right)/2,axis_y+.92,"Standardized mean difference (Hedges’ g)",11,adj=.5)
  notes <- c(
    if (pooled_panel) "See the supplementary forest plot for Jumping through Digging." else
      "Jumping through Digging: two studies per sign; individual estimates only.",
    "The same animals contribute to several signs. Do not pool or count sign-level results as independent evidence.",
    if (pooled_panel) "Squares show cohort estimates; horizontal lines show 95% CIs. Larger squares indicate greater random-effects weights." else
      "Squares show individual estimates; horizontal lines show 95% confidence intervals.",
    if (pooled_panel) "Diamonds: REML estimates with modified HKSJ 95% CIs (q* ≥ 1). Red bars: 95% prediction intervals. T/C = treatment/control." else
      "T/C = treatment/control.",
    "† Unresolved data quality flag (excluded in S2).",
    "Dose arms sharing a vehicle group were combined into one treatment arm for the cohort estimate.",
    "Doses are transcribed as reported. For entries in nM, the administered amount could not be established from the reported concentration alone.")
  notes <- c(notes, if (pooled_panel) "Vertical dotted lines mark subgroup pooled estimates; the solid vertical line marks zero." else "The solid vertical line marks zero.")
  for (i in seq_along(notes)) tx(.2,axis_y+1.32+(i-1)*.30,notes[i],9.5,room=15.6)
}



# Jumping starts the supplement. Preserve the order in the input data.
signs <- vapply(shown, function(d) d$sign[1], character(1))
split_at <- match("Jumping", signs)
stopifnot(!is.na(split_at), split_at == 10L, tail(signs, 1L) == "Digging")
main_groups <- shown[seq_len(split_at - 1L)]
supp_groups <- shown[seq.int(split_at, length(shown))]
expected_supp_signs <- c("Jumping", "Diarrhoea", "Grooming", "Genital licking", "Digging")
stopifnot(identical(unname(signs[seq.int(split_at, length(shown))]), expected_supp_signs),
          all(vapply(supp_groups, nrow, integer(1)) == 2L),
          length(main_groups) == 9L, length(supp_groups) == 5L,
          setequal(names(main_groups), pools$group),
          !any(names(supp_groups) %in% pools$group),
          sum(vapply(main_groups, nrow, integer(1))) == 42L,
          sum(vapply(supp_groups, nrow, integer(1))) == 10L)

args <- commandArgs(trailingOnly=TRUE)
out <- if(length(args)) args[1] else "."
dir.create(out,recursive=TRUE,showWarnings=FALSE)
if (!capabilities("cairo")) stop("An R build with Cairo support is required.")

export_figure <- function(groups, title, pooled_panel, stem) {
  path <- file.path(out, stem)
  height <- layout(groups)$H
  cairo_pdf(paste0(path, ".pdf"),width=W,height=height,bg="white")
  tryCatch(draw(groups,title,pooled_panel),finally=dev.off())
  png(paste0(path, ".png"),width=W,height=height,units="in",res=300,
      type="cairo",bg="white")
  tryCatch(draw(groups,title,pooled_panel),finally=dev.off())
}
# Export the smaller supplement first.
export_figure(supp_groups,"Figure 6B supplement. Individual somatic signs",
              FALSE,"Fig6B_supplement_unpooled")
export_figure(main_groups,"Figure 6B. Withdrawal: individual somatic signs",
              TRUE,"Fig6B_withdrawal_main_forest")
