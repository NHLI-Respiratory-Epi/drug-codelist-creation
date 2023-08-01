# How to: create drug codelists for recorded prescriptions

This is an extension of [our work to create SNOMED-CT codelists](https://github.com/NHLI-Respiratory-Epi/SNOMED-CT-codelists/tree/main) which adds additional steps to adapt for considerations specific to generating codelists for drugs, instead of for symptoms and conditions.

## Creating drug codelists can be broken down in to 8 steps:
<p align="center">
	<img src="Flowchart for github.png" height="675"/>
</p>

## Glossary 
<p align="center">
	<img src="Definitions.PNG"/>
</p>

## STEPS 

At all stages, request clinical input. We put **✱** where we believe this to be essential.

**Step 1 : Define purpose and value sets**  
- Establish a clinical definition (e.g., drugs for hypertension and heart failure) **✱**  
    - Choose organ system knowing what the drug targets (e.g., circulatory system)    
    - Use this information to select the relevant database’s underlying ontology (e.g., BNF, Ch. 2 circulatory system) and the relevant chapter (e.g., Ch. 2.5 hypertension and heart failure drugs)  
    - A user-friendly BNF resource is the [OpenPrescribing](https://openprescribing.net/bnf/)      
- Define value sets (i.e., subgroups of codes within this clinical definition)  
- For each value set, collate search terms   
    - chemical names  <br />
    - proprietary names (OPTIONAL)  <br />
- Establish route (e.g., oral, parenteral/injected) **✱**  
- Consider purpose:  
    - repository  <br />
    - disease-specific (e.g., COPD inhalers)  <br />
- Consider chemistry: **✱**  
    - for search efficiency  <br />
    - don't search on common compounds, active or blocking groups, or side chains such as  *-nitrate -arginine -hydrochloride -mesilate*   <br />
    - although these suffixes may be listed as part of the drug name, they are not chemical-of-interest  <br />

Put all information of Step 1 into a spreadsheet, so you can refer back to this later:   

<p align="center">
	<img src="inline_Step1.png"/>
</p>

**Step 2: Conducting search**
- 2a) Search database drug dictionary
    - (i) chemical and proprietary term search (OPTIONAL - proprietary terms optional if complete data on chemical name, for each drug, even if also listed by its proprietary name)
    - (ii) search on underlying ontology (OPTIONAL - again, optional if have complete data on chemical name, for each drug)
        - consider syntax with slashes (eg, "*/ 302*" and "302*" for Ch. 3.2 BNF)
        - *why slashes?* medicines may be indicated for multiple conditions and hence recorded in multiple ontology sections (e.g., for betamethasone use slashes because may be recorded as both “3020000” and “10010201/ 8020200/ 3020000” within the ontology variable - corresponding to Ch. 10, Ch. 8, and Ch. 3 for neuromuscular, immunosuppression, and respiratory purposes) (in CPRD Aurum database the ontology variable is called *bnfchapter*

**Step 3: Exclusions**

**Step 4: Cleaning**
- 4a)
- 4a)
- 4b)

**Step 5: Compare to previous codelists or mapping ontologies**

**Step 6: Send "raw" codelist for clinician to review, to decide study-specific codelist**

**Step 7: Keep "master" codelist spreadsheet - with all versions and tags**
- Have columns that tags codes for certain codelist versions:
    - (i) Raw codes (before clinician review)
    - (ii) Codes marked by clinician(s) for study codelist (0 no, 1 yes, 2 sensitivity analysis)
    - (iii) Codes finalized for study (i.e., containing 1s only)
    - (iv) Tags for overlapping, fixed combination drugs falling into multiple underlying ontology sections (e.g., Ch. 2.5 codelist, but drug also corresponds to Ch. 2.2 and Ch. 2.6)



## Example *Stata* code (Steps 2 to 7) 

This code is an example to create a codelist for Chapter 2.5 of the British National Formulary.

*NB You shouldn't need to change any code within loops, apart from local-macro names, e.g., searchterm, exclude_route, exclude_term, etc.

```stata
//*******************************************************************************
//*1) Define purpose and value sets: drug class(es) of interest, collate list of terms for value sets
//*******************************************************************************/

//(spreadsheet as above)

//*******************************************************************************
//*2) Searching CPRD Aurum Product Browser
//*******************************************************************************/

clear all
macro drop _all
set more off 

//Enter directory to save files in
cd "Z:\Group_work\Emily\Product_browsing_study_data\Codelists\Do-files_publication\"
pwd 

local filename "publication_0205HTNandHF_prodbrowsing"

capture log close
log using `filename', text replace

//Directory of product dictionary
local browser_dir "Z:\Database guidelines and info\CPRD\CPRD_CodeBrowser_202202_Aurum"

//Import latest product browser 
import delimited "`browser_dir'/CPRDAurumProduct.txt", stringcols(1 2) 
	*FORCE 'prodcode' and 'dmdcode' to be string variable, or will lose data

//no EMIS lookupfile required (unlike medical code browsing)


	
//******
// 2a. (i)Chemical + proprietary name searchterms
//******
	*Insert your search terms into each local as shown below, change local names according to chemical name, then group chemical macros into bnfsubsection macro


*2.5.1 Vasodilator antihypertensive drugs
local ambrisentan_list " "ambrisentan" "volibris" "
local bosentan_list " "bosentan" "stayveer" "tracleer" "
local diazoxide_list " "diazoxide" "proglycem" "eudemine" "
local hydralazine_list " "hydralazine" "apresoline" "
local iloprost_list " "iloprost" "ilomedin" "ventavis" "
local macitentan_list " "macitentan" "opsumit" "
local minoxidil_list " "minoxidil" "loniten" "
local riociguat_list " "riociguat" "adempas" "
local sildenafil_list " "sildenafil" "granpidam" "revatio" "
local sitaxentan_list " "sitaxentan" "
local tadalafil_list " "tadalafil" "adcirca" "
local vericiguat_list " "vericiguat" "verquvo" "

local vasodil20501 " "ambrisentan_list" "bosentan_list" "diazoxide_list" "hydralazine_list" "iloprost_list" "macitentan_list" "minoxidil_list" "riociguat_list" "sildenafil_list" "sitaxentan_list" "tadalafil_list" "vericiguat_list" "

	
*2.5.2 Centrally-acting antihypertensive drugs
local clonidine_list " "clonidine"  "catapres" "
local guanfacine_list " "guanfacine" "tenex" "
local methyldopa_list " "methyldopa" "aldomet" "
local moxonidine_list " "moxonidine" "physiotens" "

local centact20502 " "clonidine_list" "guanfacine_list" "methyldopa_list" "moxonidine_list" "
	
*2.5.3 Adrenergic neurone blocking drugs	
local guanethidine_monosulfate_list " "guanethidine"  "ismelin" "

local adrblocker20503 " "guanethidine_monosulfate_list" "


*2.5.4: Alpha-adrenoceptor blocking drugs
local doxazosin_mesilate_list " "doxazosin"  "cardura" "doxadura" "larbex" "raporsin" "slocinx" "
local indoramin_list " "indoramin" "baratol" "doralese" "
local phenoxybenzamine_list " "phenoxybenzamine" "dibenyline" "
local phentolamine_mesilate_list " "phentolamine" "rogitine" "
local prazosin_list " "prazosin" "hypovase" "minipress"  "
local terazosin_list " "terazosin" "benph" "hytrin" "

local ablocker20504 " "doxazosin_mesilate_list" "indoramin_list" "phenoxybenzamine_list" "phentolamine_mesilate_list" "prazosin_list" "terazosin_list" "

*2.5.5: RAAS - no overlap 
local aliskiren_list " "aliskiren"  "rasilez" "
local azilsartan_medoxomil_list " "azilsartan" "edarbi" "
local candesartan_cilexetil_list " "candesartan" "amias" "
local cilazapril_list " "cilazapril" "vascace" "
local eprosartan_list " "eprosartan" "teveten" "
local fosinopril_list " "fosinopril" "
local imidapril_list " "imidapril" "tanatril" "
local moexipril_list " "moexipril" "perdix" "
*2.5.5: RAAS - overlap - diuretics, CCB
local captopril_list " "captopril" "kaplon" "ecopace" "noyada" "zidocapt" "capozide" "acezide" "capoten" "tensopril" "acepril" " // co-zidocapt - don't use dash
local enalapril_list " "enalapril" "innovace" "pralenal" "innozide" "
local irbesartan_list " "irbesartan" "aprovel" "ifirmasta" "coaprovel" "
local lisinopril_list " "lisinopril" "lisicostad" "carace" "zestril" "lisopress" "zestoretic" "
local losartan_list " "losartan" "cozaar" "
local olmesartan_medoxomil_list " "olmesartan" "olmetec" "sevikar" "

local perindopril_list " "perindopril" "coversyl" "
local quinapril_list " "quinapril" "accupro" "quinil" "accuretic" "
local ramipril_list " "ramipril"  "tritace" "lopace" "triapin" "
local telmisartan_list " "telmisartan"  "micardis" "tolura" "tolucombi" "
local trandolapril_list " "trandolapril" "gopten" "odrik" "tarka" "
local valsartan_list " "valsartan" "diovan" "entresto" "

local RAASnooverlap20505 " "aliskiren_list" "azilsartan_medoxomil_list" "candesartan_cilexetil_list" "cilazapril_list" "eprosartan_list" "fosinopril_list" "imidapril_list" "moexipril_list" "

local RAAS1overlap20505 " "captopril_list" "enalapril_list" "irbesartan_list" "lisinopril_list" "losartan_list" "olmesartan_medoxomil_list" "

local RAAS2overlap20505 " "perindopril_list" "quinapril_list" "ramipril_list" "telmisartan_list" "trandolapril_list" "valsartan_list" "

	*need to break up into multiple macros
	*if Stata is used, for primary subsections that exceed the programming software's character limit for information contained within nested macros, subsections may need to be temporarily split (e.g., 2.5.5 drugs for Renin-angiotensin system).  

*2.5.8 Other adrenergic neurone blocking drugs 
local ketanserin_list " "ketanserin" "ketensin" "

local othadrblocker20508 " "ketanserin_list" "


*check macro data successfully stored
	display `vasodil20501'
	display `centact20502'
	display `adrblocker20503'
	display `ablocker20504'
	display `RAASnooverlap20505'
	display `RAAS1overlap20505'
	display `RAAS2overlap20505'
	display `othadrblocker20508'

	
*Search all search terms in descriptions

foreach searchterm in ///
"vasodil20501" "centact20502" "adrblocker20503" "ablocker20504" "RAASnooverlap20505" "RAAS1overlap20505" "RAAS2overlap20505" "othadrblocker20508" { 
	
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



******
// 2a(ii)separate BNF search 
******
*helps pick up outstanding brand or chem names
*can't include in above - nested macros don't like astricks (***)

generate byte 	step2aii_bnfsearch205=.
replace 		step2aii_bnfsearch205=1 if 	strmatch(bnfchapter,"205*")  | ///
							strmatch(bnfchapter,"*/ 205*")  

*keep found terms for (2ai) (2aii)
generate byte step2ai_chem_brand_term = .
replace step2ai_chem_brand_term=1 if vasodil20501==1 | centact20502==1 | adrblocker20503==1 | ablocker20504==1 | RAASnooverlap20505==1 | RAAS1overlap20505==1 | RAAS2overlap20505==1 | othadrblocker20508==1

count if step2ai_chem_brand_term == 1 	// 617 from (2a,i)
count if step2aii_bnfsearch205	 == 1		// 281 from (2a,ii)

keep if step2ai_chem_brand_term == 1 | step2aii_bnfsearch205==1  // 627 from (2a i and ii together)

compress
count // 627 total  (2a i and ii together)
browse


******
//2b. Did BNF search pick up *outstanding / additional* codes(proprietary or chemical names) not initially searched on in (2ai)?
******

generate byte 	step2b_BNFoutstanding=.
replace 		step2b_BNFoutstanding=1 if step2ai_chem_brand_term!=1 & step2aii_bnfsearch205==1
label define lab1 1 "outstanding from 2aii BNFsearch"
label values 	step2b_BNFoutstanding lab1 

codebook 	step2b_BNFoutstanding
list 	if step2b_BNFoutstanding==1
browse 	if step2b_BNFoutstanding==1  
count 	if step2b_BNFoutstanding==1   // 10 outstanding codes 
	*10 not part of initial value sets = 9 Selexipag & 1 Na-Nitroprusside. Rare? Not commonly prescribed? wait for clinician review.

compress
count // 627 
*if pick up new brand names, return to step 2ai and add in outstanding brand names for the iteration/rerun of code
*then run this step again
*may not have any/very few step2b_BNFoutstanding=1 if your search is sensitive/broad enough and you went thru iterations of adding outstanding search terms

*here, of the step2b_BNFoutstanding=1, few drug issues...new drug? (if all clearly not part of value set, exclude. Otherwise wait for clinician.)


*change 0 in chem_brand_term to . - easier to visualise which codes picked up
replace vasodil20501=. if vasodil20501==0
replace centact20502=. if centact20502==0
replace adrblocker20503=. if adrblocker20503==0
replace ablocker20504=. if ablocker20504==0
replace RAASnooverlap20505=. if RAASnooverlap20505==0
replace RAAS1overlap20505=. if RAAS1overlap20505==0
replace RAAS2overlap20505=. if RAAS2overlap20505==0
replace othadrblocker20508=. if othadrblocker20508==0

sort vasodil20501 centact20502 adrblocker20503 ablocker20504 RAASnooverlap20505 RAAS1overlap20505 RAAS2overlap20505 othadrblocker20508 termfromemis 

*************************************************************
//3.) Remove any irrelevant codes
*************************************************************

*exclude by BNFaddtl codes - N/A
	*only if all not part of chemical value set. (step may not be indicated in all codelists)
	*here N/A keep for clinician review
	
*exclude ROUTE 
preserve
keep route
duplicates drop
list route
restore

local exclude_route " "*ocular*" "*intracavernous*" "*cutaneous*" " 

//search for route-codes to exclude
foreach excludeterm in exclude_route {

	generate byte `excludeterm' = .

	foreach codeterm in lower(route) {
		
		foreach searchterm in ``excludeterm'' {		
			
			replace `excludeterm' = 1 if strmatch(`codeterm', "`searchterm'")
		}
	}
}

list term prodcodeid drugsubstancename route if exclude_route == 1	
		count if exclude_route == 1 

		drop if exclude_route == 1 // 20 deleted based on route
		drop exclude_route 

		count // 607 new total
		compress

		browse
		sort termfromemis 
		
*exclude TERM, DRUGSUBSTANCENAME 
		*although previously excluded on 'ocular' route, route has missing data for what we want to exclude, so also exclude based on term 'eye'
local exclude_term_drugsub " "*eye*" "*gluten*" " 

//search for route-codes to exclude
foreach excludeterm in exclude_term_drugsub {

	generate byte `excludeterm' = .

	foreach codeterm in lower(term) lower(drugsubstancename) {
		
		foreach searchterm in ``excludeterm'' {		
			
			replace `excludeterm' = 1 if strmatch(`codeterm', "`searchterm'")
		}
	}
}

list term prodcodeid drugsubstancename route if exclude_term_drugsub == 1
count if exclude_term_drugsub == 1 

drop if exclude_term_drugsub == 1 // 6 deleted based on term & drugsubstancename
drop exclude_term_drugsub 

count // 601 new total
compress

browse
sort termfromemis 

/*exclude PRODCODEID / template - but not a transparent method
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
sort termfromemis
*/

*exclude by FORMULATION - N/A

*exclude by BNFCHAPTER - not recommended since very incomplete data


*************************************************************
//4.) Cleaning / resorting
*************************************************************

******
//4a. flag the codes in multiple BNF subsections / overlap/not mutually exclusive - that should NOT be + make mutually exclusive
******
*this may be more important for chapters with subsections that may have overlap in resulting found terms, if your search is specific/broad enough (e.g., in Ch. 2.2 Diuretics, searching just on "furosemide" would lead to found terms in both 2.2.2 and 2.2.4 and 2.2.8, that should not be )

generate flag_overlap=.
egen rowtotal = rowtotal(vasodil20501 centact20502 adrblocker20503 ablocker20504 RAASnooverlap20505 RAAS1overlap20505 RAAS2overlap20505 othadrblocker20508)
replace flag_overlap=1 if rowtotal>1
drop rowtotal

sort flag_overlap drugsubstancename termfromemis
count if flag_overlap==1 // none (0)
*count if flag_overlap==1 & drugsubstancename!=""
*br if flag_overlap==1 

compress
count // 601
browse

*make not mutually exclusive - resort based on missing & complete data on drug substance name
	*N/A for this codelist

******
//4b. Flag codes in multiple BNF subsections, that SHOULD be - for clinician & covariate analysis
******

	*flagging 0202 diuretics
	generate byte step4b_also_0202_diuretic=.
	replace step4b_also_0202_diuretic=1 if strmatch(lower(term),"*azide*") 
	replace step4b_also_0202_diuretic=1 if strmatch(lower(drugsubstancename),"*azide*") 
	replace step4b_also_0202_diuretic=1 if strmatch(lower(term),"*pamide*") 
	replace step4b_also_0202_diuretic=1 if strmatch(lower(drugsubstancename),"*pamide*")
	count if step4b_also_0202_diuretic==1 	// 66 codes with ingredients also Ch. 2.2 diuretic

	*flagging 0206 Ca2+ channel blockers
	generate byte step4b_also_0206_CCB=.
	replace step4b_also_0206_CCB=1 if strmatch(lower(term),"*triapin*")  
	replace step4b_also_0206_CCB=1 if strmatch(lower(drugsubstancename),"*dipine*") 
	replace step4b_also_0206_CCB=1 if strmatch(lower(term),"*dipine*")  
	replace step4b_also_0206_CCB=1 if strmatch(lower(drugsubstancename),"*pamil*") 
	replace step4b_also_0206_CCB=1 if strmatch(lower(term),"*pamil*") 
	count if step4b_also_0206_CCB==1 		// 28 codes with ingredients also Ch. 2.6 CCB

******		
//4c. Modify value sets, as necessary
******

generate byte RAAS20505=.
replace RAAS20505=1 if RAASnooverlap20505==1
replace RAAS20505=1 if RAAS1overlap20505==1
replace RAAS20505=1 if RAAS2overlap20505==1

replace RAAS20505=0 if RAASnooverlap20505==0
replace RAAS20505=0 if RAAS1overlap20505==0
replace RAAS20505=0 if RAAS2overlap20505==0
drop RAASnooverlap20505 RAAS1overlap20505 RAAS2overlap20505


	
	
*************************************************************
//5.) Compare to previous lists or taxonomic mapping 
*************************************************************
	*as necessary / if available
	*e.g., codelist from previous CPRD Aurum version


	
*************************************************************
*Final order, export for clinician review, generate study-specific codelist, tag file

//6) Send raw codelist for clinician review - for study-specific codelist
//7) Keep 'master' codelist with all versions & tags
*************************************************************

//order
order prodcodeid termfromemis productname dmdid formulation routeofadministration drugsubstancename substancestrength bnfchapter drugissues ///
vasodil20501 centact20502 adrblocker20503 ablocker20504 RAAS20505 othadrblocker20508  step2ai_chem_brand_term step2aii_bnfsearch205 step2b_BNFoutstanding ///
step4b_also_0202_diuretic step4b_also_0206_CCB  

sort vasodil20501 centact20502 adrblocker20503 ablocker20504 RAAS20505 othadrblocker20508 termfromemis 

drop flag_overlap 

count // 601 total  - pre-clinician review

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
local description "0205 BNF HTNandHF RX"
local author "ELG"
local date "February 2023"
local code_type "prod browsing"
local database "CPRD Aurum"
local database_version "February 2022"
local keywords "BNF2.5 hypertension, heart failure, vasodilators, antihypertensives, alpha-blockers, renin-angiotensin system"
local notes "Codelist based on BNF Ch. 2.5 Hypertension & Heart Failure, value sets organised by BNF subsection (2.5.1...2.5.8). Use individual subsections to adapt codelist prn based on study context. https://openprescribing.net/bnf/0205/. Clinician 1s are for [x study]. "
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

## Pre-print
Graul EL, Stone PW, Massen GM, Hatam S, Adamson A, Denaxas S, Peters NS, Quint, JK. Determining prescriptions in electronic healthcare record (EHR) data: methods for development of standardized, reproducible drug codelists. medRxiv [Internet] 2023; Available from: https://doi.org/10.1101/2023.04.14.23287661
