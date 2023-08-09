/********************************************************************************
	CPRD Product Browser Searching
	23/09/2020	ELA //   Updated by PWS on 2022-06-22  // Updated by ELG for Product Browsing 2022-12-02
	2 Dec 2022
	Emily Graul
	Codelist: BNF 0301-01,02,04; 0302 COPD Rx inhalers
	
*******************************************************************************/

/*STEPS
*1) Define drug class(es) of interest - collate list of terms - for value sets
*2) Searching CPRD Aurum Product Browser
*3) Use drug class/ontology to find additional drugs
*4) Remove any irrelevant codes / exclusions
*5) Cleaning
*6) Tagging for utility
*7) Compare with previous list(s) if applicable / mapping to other ontologies
Final order, export for clinician review, tag file:
*8) Explort raw codelist for clinician review - for study-specific codelist
*9) Keep 'master' codelist with all versions & tags
*/

*NB You shouldn't need to change any code within loops, apart from local-macro names, e.g., searchterm, exclude_route, exclude_term, etc.

*******************************************************************************
*1) Define drug class(es) of interest - collate list of terms for value sets
*******************************************************************************/

*******************************************************************************
*2) Searching CPRD Aurum Product Browser
*******************************************************************************/

clear all
macro drop _all
set more off 

//Enter directory to save files in
cd "Z:\Group_work\Emily\Product_browsing_study_data\Codelists\Do-files_working_publication\COPDrx_inhalers_checked\"

pwd 

local filename "publication_COPDrx_inhalers_subdiv_prodbrowsing"

capture log close
log using `filename', text replace

//Directory of product dictionary
local browser_dir "Z:\Database guidelines and info\CPRD\CPRD_CodeBrowser_202202_Aurum"

//Import latest product browser 
import delimited "`browser_dir'/CPRDAurumProduct.txt", stringcols(1 2) 
	*FORCE 'prodcode' and 'dmdcode' to be string variable, or will lose data

//no EMIS lookupfile required (unlike medical code browsing)


******
// Chemical + proprietary name searchterms
******
	*Insert your search terms into each local as shown below, change local names according to chemical name, then group chemical macros into bnfsubsection macro

	*"trimbow" (Beclometasone dipropionate/ Formoterol fumarate dihydrate/ Glycopyrronium bromide) is a combo, listed in 3.1.1 single in Open Prescribing, but moved to triple macro for purposes of repository
	
	*macros for compound drugs include proprietary terms only to reduce search redundancy

***
*Singles
*3.1.1, 3.1.2 Single = broken into laba, saba, lama, sama, ics 
*laba
local formoterol_list " "formoterol" "atimos" "foradil" "oxis" " 
local indacaterol_list " "indacaterol" "onbrez" " 
local olodaterol_list " "olodaterol" "striverdi" "
local salmeterol_list " "salmeterol" "neovent" "serevent" "soltel" "vertine" " 

local laba_030101 " "formoterol_list" "indacaterol_list" "olodaterol_list"  "salmeterol_list" "

*saba
local salbutamol_list " "salbutamol" "aerolin" "airomir" "airsalb" "asmasal" "asmavent" "maxivent" "pulvinal salbutamol" "salamol" "salapin" "salbulin" "ventmax" "ventodisks" "ventolin" "volmax" "aerocrom" " // saba, aka albuterol
local fenoterol_list " "fenoterol" "berotec" " 
local terbutaline_list " "terbutaline" "bricanyl" "monovent" " 

local saba_030101 " "salbutamol_list" "terbutaline_list" "fenoterol_list" "

*lama
local aclidinium_list " "aclidinium" "eklira" " 
local glycopyrronium_list " "glycopyrronium" "seebri" " 
local tiotropium_list " "tiotropium" "acopair" "braltus" "spiriva" "tiogiva" " 
local umeclidinium_list " "umeclidinium" "incruse" " 

local lama_030102 " "aclidinium_list" "glycopyrronium_list" "tiotropium_list" "umeclidinium_list" "

*sama
local ipratropium_list " "ipratropium" "atrovent" "inhalvent" "respontin" "tropiovent" " // sama 

local sama_030102 " "ipratropium_list" "

*ics
local beclometasone_list " "beclometasone" "aerobec" "asmabec" "beclazone" "becloforte" "becodisks" "becotide" "clenil" "filair" "kelhale" "pulvinal beclometasone" "qvar" "soprobec" "
local budesonide_list " "budesonide" "budelin" "pulmicort" "
local ciclesonide_list " "ciclesonide" "alvesco" "
local fluticasone_list " "fluticasone" "campona"  "flixotide" "seffalair" "
local mometasone_list " "mometasone" "asmanex"  "

local ics_0302 " "beclometasone_list" "budesonide_list" "ciclesonide_list" "fluticasone_list" "mometasone_list" "

***
*Combos
*3.1.4 Compound bronchodilators x type
*brand names only since chemical names mutually exclusive with above 

*laba-lama
local aclidinium_formoterol_list " "duaklir" "
local glycopyrronium_formoterol_list " "bevespi" " 
local glycopyrronium_indacaterol_list " "ultibro" " 
local tiotropium_olodaterol_list " "spiolto" " 
local umeclidinium_vilanterol_list " "anoro" "

local labalama_30104 " "aclidinium_formoterol_list" "glycopyrronium_formoterol_list" "glycopyrronium_indacaterol_list" "tiotropium_olodaterol_list" "umeclidinium_vilanterol_list" "

*saba-sama
local salbutamol_ipratropium_list " "ipramol" "combiprasal" "
local fenoterol_ipratropium_list " "duovent" "

local sabasama_30104 " "salbutamol_ipratropium_list" "fenoterol_ipratropium_list" "

*laba-ics 
local beclometasone_formoterol_list " "fostair" "luforbec" "
local budesonide_formoterol_list " "duoresp" "fobumix" "symbicort" "wockair" "
local mometasone_indacaterol_list " "atectura" "
local fluticasone_salmetrol_list " "aerivio" "airflusal" "aloflute" "avenor" "combisal" "fusacomb" "fixkoh" "sereflo" "seretide" "sirdupla" "stalpex" "
local fluticasone_vilanterol_list " "relvar" "
local fluticasone_formoterol_list " "flutiform" "

local icslaba_0302 " "beclometasone_formoterol_list" "budesonide_formoterol_list" "mometasone_indacaterol_list" "fluticasone_salmetrol_list" "fluticasone_vilanterol_list" "fluticasone_formoterol_list" "

*triple 
local beclometasone_triple " "trimbow" " // "beclometasone" "formoterol" "glycopyrronium"
local budesonide_triple " "trixeo" " // "budesonide" "formoterol" "glycopyrronium"
local fluticasone_triple " "trelegy" " // "budesonide" "formoterol" "glycopyrronium"
local mometasone_triple " "enerzair" " // "mometasone" "indacaterol" "glycopyrronium"

local triple_0302 " "beclometasone_triple" "budesonide_triple" "fluticasone_triple" "mometasone_triple" "


*check macro data successfully stored
	display `laba_030101'
	display `saba_030101'
	display `lama_030102'
	display `sama_030102'
	display `sabasama_30104'
	display `labalama_30104'
	display `ics_0302'
	display `icslaba_0302'
	display `triple_0302'
	
*Search all search terms in descriptions

foreach searchterm in ///
"laba_030101" "saba_030101" "lama_030102" "sama_030102" "sabasama_30104" "labalama_30104" "ics_0302" "icslaba_0302" "triple_0302" { 
	
    display "Making a column called `searchterm'"
	generate byte `searchterm' = 0
	
	foreach chemterm in ``searchterm'' {
	
		display "Checking individual search terms in: `chemterm'"
		
		foreach indiv in ``chemterm'' {
		
			display "Searching all columns for *`indiv'*"
		
			foreach codeterm in lower(term) lower(productname) lower(drugsubstancename) {
			
				display "`searchterm': Checking `codeterm' column for *`indiv'*"

				replace `searchterm' = 1 if strmatch(`codeterm', lower("*`indiv'*"))
			}
		}		
	}
}


*******************************************************************************
// *3) Use drug class/ontology to find additional drugs 
*******************************************************************************/
*helps pick up outstanding brand or chem names
*can't include in above - nested macros don't like astricks (***)

generate byte step3_bnfsearch301_302=.
replace step3_bnfsearch301_302=1 if 	strmatch(bnfchapter,"301*") | ///
								strmatch(bnfchapter,"*/ 301*") | ///  
								strmatch(bnfchapter,"302*") | /// 
								strmatch(bnfchapter,"*/ 302*")  
		
*3.1.3not part of value set, set to missing:
replace step3_bnfsearch301_302=. if 	strmatch(bnfchapter,"30103*") | /// 
								strmatch(bnfchapter,"*/ 30103*") | ///  
								strmatch(bnfchapter,"30105*") | /// 
								strmatch(bnfchapter,"*/ 30105*")   

*keep found terms for (Step 2) and (Step 3)
generate byte step2_chem_brand_term = .
replace step2_chem_brand_term=1 if laba_030101==1 | saba_030101==1 | lama_030102==1 | sama_030102==1 | sabasama_30104==1 | labalama_30104==1 | ics_0302==1 | icslaba_0302==1 | triple_0302==1

count if step2_chem_brand_term == 1 	    	// 675 from (Step 2)
count if step3_bnfsearch301_302	 == 1		// 242 from (Step 3)

keep if step2_chem_brand_term == 1 | step3_bnfsearch301_302==1 // 692 from (from Step 2 and 3 together)

compress
count // 692 total  (Step 2 and 3 together)
browse

******
// Did BNF search pick up *outstanding / additional* codes(proprietary or chemical names) not initially searched on ?
******

generate byte step3_BNFoutstanding=.
replace step3_BNFoutstanding=1 if step2_chem_brand_term!=1 & step3_bnfsearch301_302==1
label define lab1 1 "outstanding from BNFsearch"
label values step3_BNFoutstanding lab1 

codebook step3_BNFoutstanding
count if step3_BNFoutstanding==1
list if step3_BNFoutstanding==1
browse if step3_BNFoutstanding==1 // final iteration once value sets/macros complete - all 17 additional are undoubtably not part of value set, exclude in step 3, before clinician review

compress
count // 692
*if pick up new brand names, return to start of step 1 and add in outstanding brand names for the iteration/rerun of code
*then run up to here again
*may not have any/very few step3_BNFoutstanding=1 if your search is sensitive/broad enough and you went thru iterations of adding outstanding search terms

*of the step3_BNFoutstanding=1, few drug issues...new drug? if all clearly not part of value set, exclude. Otherwise wait for clinician.
*here, of the step3_BNFoutstanding=1, all clearly not part of value set, exclude in step 3. (if all clearly not part of value set, exclude. Otherwise wait for clinician.)


*change 0 in chem_brand_term to . - easier to visualise which codes picked up
replace laba_030101=. 	if laba_030101==0
replace saba_030101=. 	if saba_030101==0
replace lama_030102=. 	if lama_030102==0
replace sama_030102=. 	if sama_030102==0
replace sabasama_30104=. if sabasama_30104==0
replace labalama_30104=. if labalama_30104==0
replace ics_0302=. 		if ics_0302==0
replace icslaba_0302=. 	if icslaba_0302==0
replace triple_0302=. 	if triple_0302==0

sort laba_030101 saba_030101 lama_030102 sama_030102 sabasama_30104 labalama_30104 ics_0302 icslaba_0302 triple_0302 termfromemis 



*************************************************************
//4.) Exclusions - Remove any irrelevant codes
*************************************************************

*exclude by step3_BNFoutstanding codes - here, all step3_BNFoutstanding not part of chemical value set. 

list term prodcodeid drugsubstancename route if step3_BNFoutstanding == 1
		count if step3_BNFoutstanding == 1 // 17 all not part of chemical value set
		
		drop if step3_BNFoutstanding == 1 // 17 deleted based on outstanding.
		*drop BNFaddtl later - since part of future step  
		
		count // 675 new total
		compress
		browse
		
*exclude ROUTE_FORMULATION - for repository (other formulations not part of value set)
preserve
keep route
duplicates drop
list route
restore

preserve
keep formulation
duplicates drop
list formulation
restore

*browse if strmatch(formulation, "*nebulis*") 
*browse if strmatch(route, "*not*applicable*") // save for clinician review

local exclude_route_formulation " "*nasal*" "*oral*" "*rectal*" "*intra*" "*cutaneous*" "*cream*" "*ointment*" "*nebulis*" "*tablet*" "  

//search for route-codes to exclude
foreach excludeterm in exclude_route_formulation {

	generate byte `excludeterm' = .

	foreach codeterm in lower(routeofadministration) lower(formulation) {
		
		foreach searchterm in ``excludeterm'' {		
			
			replace `excludeterm' = 1 if strmatch(`codeterm', "`searchterm'")
		}
	}
}

list term prodcodeid drugsubstancename route if exclude_route_formulation == 1
		count if exclude_route_formulation == 1 
		*br if exclude_route_formulation == 1
		
		drop if exclude_route_formulation == 1 // 172 deleted based on route and/or formulation
		drop exclude_route_formulation 
		
		count // 503 new total
		compress
		browse
		
sort laba_030101 saba_030101 lama_030102 sama_030102 sabasama_30104 labalama_30104 ics_0302 icslaba_0302 triple_0302 termfromemis 
		
preserve
keep route
duplicates drop
list route
restore

preserve
keep formulation
duplicates drop
list formulation
restore

/*exclude PRODCODEID / template
local exclude_prodcodeid "XXXXXXXX"

//search for prodcodeid-codes to exclude
foreach excludeterm in exclude_prodcodeid {

	generate byte `excludeterm' = .

	foreach codeterm in lower(prodcodeid) {
		
		foreach searchterm in ``excludeterm'' {		
			
			replace `excludeterm' = 1 if strmatch(`codeterm', "`searchterm'")
		}
	}
}

list term prodcodeid if exclude_prodcodeid == 1
		count if exclude_prodcodeid == 1

		drop if exclude_prodcodeid == 1

		drop exclude_prodcodeid
		
		count 
		compress

		browse
sort _____ termfromemis
*/

*exclude TERM, DRUGSUBSTANCENAME 
local exclude_term_drugsub " "*nebulis*" "*nebules*" "*tablets*" "*nasal*" "*injection*" "*ileostomy*" "*ointment*" "*cream*" "*ventide*" "*beclometasone*salbutamol*" "  

//search for route-codes to exclude
foreach excludeterm in exclude_term_drugsub {

	generate byte `excludeterm' = .

	foreach codeterm in lower(termfromemis) lower(drugsubstancename) {
		
		foreach searchterm in ``excludeterm'' {		
			
			replace `excludeterm' = 1 if strmatch(`codeterm', "`searchterm'")
		}
	}
}

list term prodcodeid drugsubstancename route if exclude_term_drugsub == 1
		count if exclude_term_drugsub == 1 
		
		drop if exclude_term_drugsub == 1 // 44 deleted based on drugsubstancename
		drop exclude_term_drugsub 
		
		count // 459 new total
		compress

		browse

sort laba_030101 saba_030101 lama_030102 sama_030102 sabasama_30104 labalama_30104 ics_0302 icslaba_0302 triple_0302 termfromemis 

*exclude by FORMULATION - N/A

*exclude by BNFCHAPTER - not recommended since very incomplete data



*************************************************************
//5.) Cleaning
*************************************************************


******
//Flag the codes overlapping in multiple BNF subsections -that should NOT be + make separate/mutually exclusive
******
*this may be more common for chapters with subsections that may have overlap in resulting found terms, if your search is specific/broad enough (e.g., in Ch. 2.2 Diuretics, searching just on "furosemide" would lead to found terms in the 2.2.2 and 2.2.4 and 2.2.8 value sets )


/*
gen flag_vilanterol=1 if strmatch(lower(drugsubstancename), "*vilanterol*") | strmatch(lower(term), "*vilanterol*")
sort flag_v drugsubstancename
sort flag_v drugsubstancename term
br
*/

*vilanterol is a laba only in compounds, not singles - picked up in single search but move to compound macros
*deal with vilanterol dual + triple first - & how it is coded differently for the same drug (e.g., chem vs. brand name in termfromemis)
replace labalama_30104=1 if lama_030102==1 & strmatch(lower(drugsubstancename), "*vilanterol*") & ics_0302==. & triple_0302==.
replace lama_030102=. if lama_030102==1 & strmatch(lower(drugsubstancename), "*vilanterol*") & ics_0302==. & triple_0302==.
replace icslaba_0302=1 if ics_0302==1 & strmatch(lower(drugsubstancename), "*vilanterol*") & triple_0302==. & lama_030102 == .

*combinations
replace labalama_30104=1 if laba_030101 == 1 & lama_030102 == 1 & ics_0302 == . & icslaba_0302 == . & triple_0302 == . 
replace icslaba_0302=1 if laba_030101 == 1 & lama_030102 == . & ics_0302 == 1 & labalama_30104 == . & triple_0302 == . 
replace triple_0302 = 1 if laba_030101 == 1 & lama_030102 == 1 & ics_0302 == 1  
replace sabasama_30104=1 if saba_030101==1 & sama_030102==1
codebook
*then deal with mutually exclusive individual drugs

replace laba_030101 = . if labalama_30104 == 1 | icslaba_0302 == 1 | triple_0302 == 1
replace lama_030102 = . if labalama_30104 == 1 | triple_0302 == 1
replace saba_030101 = . if sabasama_30104 == 1
replace sama_030102 = . if sabasama_30104 == 1
replace ics_0302=. 		if icslaba_0302 == 1 | triple_0302 == 1
*sort flag_v drugsubstancename

codebook
 
count // 459

*gen category for clinician check
generate category=""
replace category="laba" if laba_030101==1
replace category="saba" if saba_030101==1
replace category="lama" if lama_030102==1
replace category="sama" if sama_030102==1
replace category="saba-sama" if sabasama_30104==1
replace category="laba-lama" if labalama_30104==1
replace category="ics" if ics_0302==1
replace category="laba-ics" if icslaba_0302==1
replace category="triple" if triple_0302==1

// Other cleaning / Modify value sets, as necessary:


******
// 6) Tagging for utility / codelist adaptability 
******
* Flag codes in multiple BNF subsections, that SHOULD be - for clinician & covariate analysis or future adaptability of codelist

	*flagging 0303 Cromoglycate, leukotriene and phosphodesterase type-4 inhib
	*Aerocrom = salbutamol/cromoglicate
	generate step6_also_0303cromo=.
	replace step6_also_0303cromo=1 if strmatch(lower(term),"*cromoglicate*") 
	replace step6_also_0303cromo=1 if strmatch(lower(drugsubstancename),"*cromoglicate*") 
	count if step6_also_0303cromo==1 // 2 codes with ingredients also in Ch. 3.3 

	
count // 459 total pre-step 7, pre-clinician review
 
 
*************************************************************
// 7.) Compare to previous lists or taxonomic mapping 
*************************************************************
	*as necessary / if available

*merge with previous codelist - CPRD Aurum 2022, pre-algorithm, TRUD ATC-BNF mapping
merge m:1 prodcodeid using "Z:\Group_work\Emily\Product_browsing_study_data\Codelists\SH\copd_rx_inh_mapped_aurum2022.dta"

count if _m==3 // 382 matched
count if _m==2 // 13 picked up from NHS TRUD bnf/atc/prodcodeid mapping
count if _m==1 // 77 extra using gold standard

sort category 
order category category_prev 

tab category_prev if _m==2 
/*
category_pre |
           v |      Freq.     Percent        Cum.
-------------+-----------------------------------
        laba |          6       46.15       46.15
    laba-ics |          3       23.08       69.23
        saba |          4       30.77      100.00
-------------+-----------------------------------
       Total |         13      100.00 */

tab category if _m==1 
/*
   category |      Freq.     Percent        Cum.
------------+-----------------------------------
        ics |         54       70.13       70.13
   laba-ics |          2        2.60       72.73
       lama |          2        2.60       75.32
       saba |         18       23.38       98.70
     triple |          1        1.30      100.00
------------+-----------------------------------
      Total |         77      100.00
	  */

replace category=category_prev if category==""
replace termfromemis=termfromemis_prev if category==""
replace routeofadministration=route_prev if category==""
replace formulation=form_prev if category==""
replace drugsubstancename=drugsubstance_prev if category=="" 

generate byte compare_previous_tmp=.
replace compare_previous_tmp=1 if _m==2 // prev
replace compare_previous_tmp=2 if _m==1 // new
replace compare_previous_tmp=3 if _m==3
recode compare_previous_tmp (1=1 "previous") (2=2 "new") (3=3 "matched"), generate(compare_previous)
drop compare_previous_tmp

*************************************************************
*Final order, export for clinician review, generate study-specific codelist, tag file

// 8) Send raw codelist for clinician review - for study-specific codelist
// 9) Keep 'master' codelist with all versions & tags
*************************************************************

//order
order prodcodeid termfromemis productname dmdid formulation routeofadministration drugsubstancename substancestrength bnfchapter drugissues category ///
laba_030101 saba_030101 lama_030102 sama_030102 sabasama_30104 labalama_30104 ics_0302 icslaba_0302  triple_0302 ///
step2_chem_brand_term step3_bnfsearch301_302 step3_BNFoutstanding step6_also_0303cromo

sort laba_030101 saba_030101 lama_030102 sama_030102 sabasama_30104 labalama_30104 ics_0302 icslaba_0302 triple_0302 termfromemis 

drop category_prev bnfcode_prev termfromemis_prev atc_prev form_prev route_prev drugsubstance_prev _m

preserve
keep if compare_previous!=.
tabulate category compare_previous, missing row
restore

preserve
keep if compare_previous==2 //new
tabulate category compare_previous, missing col
restore
rename compare_previous step5_compare_previous_mapped
count // 472 mapped pre-clinician review; 459 unmapped pre-clinician review

//export (v0 no clinician, raw)
compress
save `filename', replace
export excel using `filename'.xlsx, firstrow(variables) replace
//export delimited `filename'.csv, quote replace




/*example versions:
v0 = Raw codelist 
v1 = Clinician1 1/2/0s
v2 = Clinician2 1/2/0s, without Clinician1's 0s)
v3 = Clinician1 & Clinician2's 1/2/0s merged (i.e., v0-v3 merged)
v4 = Final, project-specific Codelist- discordancies resolved, final project-specific list

keep v0 raw, v3 merged, and v4 project-specific

*/




//Generate tag file for codelist repository

//= Update details here, everything else is automated ==========================
local description "0301 0302 BNF Rx COPD inhalers"
local author "ELG"
local date "February 2023"
local code_type "prod browsing"
local database "CPRD Aurum"
local database_version "February 2022"
local keywords "BNF3.1 BNF3.2 COPD sama saba lama laba ics single dual triple "
local notes "Adapted codelist from previous. Value sets organised by how Rx prescribed and roughly by BNF subsection. Combines searches for all RX into a single file. Picks up extra codes primarly for ics, saba, and new codes for sama-saba and triple. Flag for overlap with BNF 0303. **NB Flag for new paeds code. If update this codelist, should only need to add new brands or additional chemicals to the nested macros prn. Clinician 1s are for [x study]."
local date_clinician_approved "February 2023"

//==============================================================================

clear
generate v1 = ""
set obs 9

replace v1 = "`description'" in 1
replace v1 = "`author'" in 2
replace v1 = "`date'" in 3
replace v1 = "`code_type'" in 4
replace v1 = "`database'" in 5
replace v1 = "`database_version'" in 6
replace v1 = "`keywords'" in 7
replace v1 = "`notes'" in 8
replace v1 = "`date_clinician_approved'" in 9

export delimited "`filename'.tag", replace novarnames delimiter(tab)

use "`filename'", clear  //so that you can see results of search after do file run

log close

