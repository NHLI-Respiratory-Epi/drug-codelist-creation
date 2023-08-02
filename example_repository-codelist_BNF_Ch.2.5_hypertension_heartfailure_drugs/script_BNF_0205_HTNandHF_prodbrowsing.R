###############################################################################
# CPRD Product Code Browser Searching
# 23/09/2020	ELA #    Updated by PWS on 2022-06-22  #  Updated by ELG for Product Browsing 2022-04-11
# 2 Dec 2022
# Emily Graul
# Codelist: BNF, 0205 HTN and Heart Failure RX
# 
###############################################################################/
  
# STEPS
# 1) Define drug class(es) of interest and collate list of terms
# 2) Searching CPRD Aurum Product Browser
# 3) Remove any irrelevant codes / exclusions
#    Nothing equivalent to merging and comparing with SNOMED concept IDs
# 4) Cleaning, resort, tag
# 5) Compare with previous list(s) if applicable / mapping to NHSBSA
#    Final order, export for clinician review, tag file
# 6) Send raw codelist for clinician review - for study-specific codelist
# 7) Keep 'master' codelist with all versions & tags
#
  
  # NB You shouldn't need to change any code within loops, apart from local-macro names, e.g., searchterm, exclude_route, exclude_term, etc.

###############################################################################
#1) Define drug class(es) of interest - collate list of terms for value sets
	 #(refer to Appendix __ spreadsheet)

###############################################################################/

###############################################################################
#2) Searching CPRD Aurum Product Browser
###############################################################################/


# read in appropraite libraries

library(tidyverse) # a package for tidy working in R
library(openxlsx2) # for writing excel files


# for the R equivalent of 'log', you can go to file -> compile -> pdf document. 
# for this to wowrk you need to have rmarkdown and LaTeX installed. 


# Set working directory for where the files you need are saved

setwd("Z:/Group_work/Alex/Emily's product browsing/Inputs/")




# Enter directory to save files in

savedir <- "Z:/Group_work/Alex/Emily's product browsing/Outputs/"



filename <- "publication_0205HTNandHF_prodbrowsing"

#capture log close
#log using `filename', text replace




# Import latest product browser 
# read in 'prodcode' and 'dmdcode' to be string variable, or will lose data

prodbro <- read.delim("Z:/Database guidelines and info/CPRD/CPRD_CodeBrowser_202202_Aurum/CPRDAurumProduct.txt", colClasses = "character")

# Can convert DrugIssues back to integer

prodbro$DrugIssues <- as.integer(prodbro$DrugIssues)

glimpse(prodbro)


# no lookupfile required (unlike medical code browsing)



######
  #  2a. Chemical + proprietary name searchterms
######
  #Insert your search terms into each local as shown below, change local names according to chemical name, then group chemical macros into bnfsubsection macro

# Organised like this to make it easily visible what is going on.
# however, if easier, all the drugs can simply be added into 'vasodil20501' in one go.

#2.5.1 Vasodilator antihypertensive drugs
ambrisentan_list <- c("ambrisentan", "volibris")
bosentan_list  <- c("bosentan", "stayveer", "tracleer")
diazoxide_list  <- c("diazoxide", "proglycem", "eudemine")
hydralazine_list  <- c("hydralazine", "apresoline")
iloprost_list  <- c("iloprost", "ilomedin", "ventavis")
macitentan_list  <- c("macitentan", "opsumit")
minoxidil_list  <- c("minoxidil", "loniten")
riociguat_list  <- c("riociguat", "adempas")
sildenafil_list  <- c("sildenafil", "granpidam", "revatio")
sitaxentan_list  <- c("sitaxentan")
tadalafil_list  <- c("tadalafil", "adcirca")
vericiguat_list  <- c("vericiguat", "verquvo")

vasodil20501 <- c(ambrisentan_list, bosentan_list, diazoxide_list, hydralazine_list, iloprost_list, macitentan_list, minoxidil_list, riociguat_list, sildenafil_list, sitaxentan_list, tadalafil_list, vericiguat_list)


# #2.5.2 Centrally-acting antihypertensive drugs
clonidine_list <- c("clonidine",  "catapres")
guanfacine_list <- c("guanfacine", "tenex")
methyldopa_list <- c("methyldopa", "aldomet")
moxonidine_list <- c("moxonidine", "physiotens")

centact20502 <- c(clonidine_list, guanfacine_list, methyldopa_list, moxonidine_list)
 
# #2.5.3 Adrenergic neurone blocking drugs
guanethidine_monosulfate_list <- c("guanethidine", "ismelin")

adrblocker20503 <- c(guanethidine_monosulfate_list)


# 2.5.4: Alpha-adrenoceptor blocking drugs
doxazosin_mesilate_list <- c("doxazosin", "cardura", "doxadura", "larbex", "raporsin", "slocinx")
indoramin_list <- c("indoramin", "baratol", "doralese")
phenoxybenzamine_list <- c("phenoxybenzamine", "dibenyline")
phentolamine_mesilate_list <- c("phentolamine", "rogitine")
prazosin_list <- c("prazosin", "hypovase", "minipress")
terazosin_list <- c("terazosin", "benph", "hytrin")

ablocker20504 <- c(doxazosin_mesilate_list, indoramin_list, phenoxybenzamine_list, phentolamine_mesilate_list, prazosin_list, terazosin_list)


# 2.5.5: RAAS - no overlap
aliskiren_list <- c("aliskiren", "rasilez")
azilsartan_medoxomil_list <- c("azilsartan", "edarbi")
candesartan_cilexetil_list <- c("candesartan", "amias")
cilazapril_list <- c("cilazapril", "vascace")
eprosartan_list <- c("eprosartan", "teveten")
fosinopril_list <- c("fosinopril")
imidapril_list <- c("imidapril", "tanatril")
moexipril_list <- c("moexipril", "perdix")

RAASnooverlap20505 <- c(aliskiren_list, azilsartan_medoxomil_list, candesartan_cilexetil_list, cilazapril_list, eprosartan_list, fosinopril_list, imidapril_list, moexipril_list)


# 2.5.5: RAAS - overlap - diuretics, CCB
captopril_list <- c("captopril", "kaplon", "ecopace", "noyada", "zidocapt", "capozide", "acezide", "capoten", "tensopril", "acepril") #  co-zidocapt - don't use dash
enalapril_list <- c("enalapril", "innovace", "pralenal", "innozide")
irbesartan_list <- c("irbesartan", "aprovel", "ifirmasta", "coaprovel")
lisinopril_list <- c("lisinopril", "lisicostad", "carace", "zestril", "lisopress", "zestoretic")
losartan_list <- c("losartan", "cozaar")
olmesartan_medoxomil_list <- c("olmesartan", "olmetec", "sevikar")
perindopril_list <- c("perindopril", "coversyl")
quinapril_list <- c("quinapril", "accupro", "quinil", "accuretic")
ramipril_list <- c("ramipril", "tritace", "lopace", "triapin")
telmisartan_list <- c("telmisartan", "micardis", "tolura", "tolucombi")
trandolapril_list <- c("trandolapril", "gopten", "odrik", "tarka")
valsartan_list <- c("valsartan", "diovan", "entresto")

RAAS1overlap20505 <- c(captopril_list, enalapril_list, irbesartan_list, lisinopril_list, losartan_list, olmesartan_medoxomil_list)
RAAS2overlap20505 <- c(perindopril_list, quinapril_list, ramipril_list, telmisartan_list, trandolapril_list, valsartan_list)


# #2.5.8 Other adrenergic neurone blocking drugs
ketanserin_list <- c("ketanserin", "ketensin")

othadrblocker20508 <- c(ketanserin_list)

                  

# add all search groups into a named list:
searchlist <- list(vasodil20501 = vasodil20501, centact20502 = centact20502, adrblocker20503 = adrblocker20503, ablocker20504 = ablocker20504,
                   RAASnooverlap20505 = RAASnooverlap20505, RAAS1overlap20505 = RAAS1overlap20505, RAAS2overlap20505 = RAAS2overlap20505,
                   othadrblocker20508 = othadrblocker20508)


# also, create your chapters that you want to search through as well, and put them in a vector:

chapterstarts <- c(205)



# This is the function to do the searching for all the elements named in the list:

searchProdBro <- function(prodbro, searchlist, chapterstarts = NULL, searchin = c("Term.from.EMIS", "ProductName", "DrugSubstanceName")) {

  # This will automatically search through Term.from.EMIS, ProductName, and DrugSubstanceName. If you are searching through different columns,
  # or you've renamed the column names from the original ones read into R, then you need to change the column names by providing a 
  # vector to 'searchin'
  
  # This part of the code names the list if it is an unnamed  vector. The output have a column named 'allterms' if an unnamed vector is provided
  if (typeof(searchlist) != "list") {
    searchlist <- list(allterms = searchlist) 
  }

  # then, for each of the search terms in 'searchlist', search through the 'searchin' columns for a match.
  # slightly different process required for if there is 1 or greater than 1 'searchin' element
  
for (i in names(searchlist)) {

  # first element in 'searchin'
  tempdat <- data.frame(V1 = grepl(paste0(searchlist[[i]], collapse = "|"), prodbro[[searchin[1]]], ignore.case = TRUE))
  colnames(tempdat) <- searchin[1]
  
  # for greater than 1 element in 'searchin'
  if (length(searchin) > 1) {
    
  for (j in searchin[2:length(searchin)]) {
  
#  tempdat[[j]] <- grepl(paste0(searchlist[[i]], collapse = "|"), prodbro[[searchin[j]]], ignore.case = TRUE)
    tempdat[[j]] <- grepl(paste0(searchlist[[i]], collapse = "|"), prodbro[[j]], ignore.case = TRUE)
    
      }
    }
  
  # greater than 1 element in 'searchin', use rowSums  
  if (length(searchin) > 1) {
    
  prodbro[[i]] <- rowSums(tempdat[ , 1:length(searchin)])
  prodbro[[i]][prodbro[[i]] > 1] <- 1
  
    } else {
    
    # 1 element in 'searchin', just convert colum to numeric (from logical) 
    prodbro[[i]] <- as.numeric(tempdat[ , 1])
    }
  
  tempdat <- NULL
  
  }


# then, if chapter starts is specified:

if (!is.null(chapterstarts)) {

tempdat <- data.frame(first = str_starts(string = prodbro$BNFChapter, pattern = paste0(chapterstarts, collapse = "|")))
tempdat$second = str_detect(string = prodbro$BNFChapter,  pattern = paste0("/ ", chapterstarts, collapse = "|"))
prodbro$chapterstarts <- pmax(tempdat$first, tempdat$second)
prodbro$chapterstarts

  }
  
  if (!is.null(chapterstarts)) {
  print("Newly added columns: ")
    print(c(names(searchlist), "chapterstarts"))
  } else {
    print("Newly added columns: ")
    print(names(searchlist))
  }
  return(prodbro)
}


prodbro <- searchProdBro(prodbro, searchlist, chapterstarts)


colnames(prodbro)
######
#  2b. Did BNF search pick up *additional* codes(proprietary or chemical names) not initially searched on?
######


prodbro %>% filter(chapterstarts == 1) %>% filter(if_all(vasodil20501:othadrblocker20508, ~ . == 0)) %>% 
  dplyr::select(-(vasodil20501:othadrblocker20508)) %>% select(DrugSubstanceName) %>% table()

prodbro %>% filter(chapterstarts == 1) %>% filter(if_all(vasodil20501:othadrblocker20508, ~ . == 0)) %>% 
  dplyr::select(-(vasodil20501:othadrblocker20508)) %>% select(Term.from.EMIS) %>% table()


# keep any terms that have been found by this search and add them on:

BNFaddtl <- list(BNFaddtl = c("selexipag", "sodium nitroprusside"))


prodbro <- searchProdBro(prodbro, BNFaddtl)

# Now just keep the terms we want.

prodbro <- prodbro %>% filter(if_any(vasodil20501:BNFaddtl) == 1)
nrow(prodbro)


#############################################################
# 3.) Remove any irrelevant codes
#############################################################




exclude_routes1 <- list(exclude_routes1 = c("ocular", "intracavernous", "cutaneous"))

# this time we're searching through the drug routes
prodbro <- searchProdBro(prodbro, exclude_routes1, searchin = "RouteOfAdministration")

# so now we get rid of these routes we don't want.
prodbro <- prodbro %>% filter(exclude_routes1 == 0) %>% dplyr::select(-exclude_routes1) 


# and we do it again for a different group of terms:
exclude_terms2 <- list(exclude_terms2 = c("eye", "gluten")) 

prodbro <- searchProdBro(prodbro, exclude_terms2, searchin = c("Term.from.EMIS", "DrugSubstanceName"))

prodbro %>% filter(exclude_terms2 == 1) %>% select(Term.from.EMIS, DrugSubstanceName) 

# so now we get rid of these routes we don't want.
prodbro <- prodbro %>% filter(exclude_terms2 == 0) %>% dplyr::select(-exclude_terms2) 


#exclude by FORMULATION - N/A

#exclude by BNFCHAPTER - not recommended since very incomplete data


#############################################################
# 4.) Cleaning / resorting
#############################################################

######
# 4a. flag the codes in multiple BNF subsections / mutually exclusive - that should NOT be + make not mutually exclusive
######
#this may be more important for chapters with subsections that may have overlap in resulting found terms, 
# if your search is specific/broad enough (e.g., in Ch. 2.2 Diuretics, searching just on "furosemide" would lead 
# to found terms in both 2.2.2 and 2.2.4 and 2.2.8, that should not be )
colnames(prodbro)
# all fine
prodbro <- prodbro %>% mutate(flag_me = rowSums(across(c(vasodil20501:othadrblocker20508, BNFaddtl)))) %>%
  mutate(flag_me = ifelse(flag_me > 1, 1, 0))

table(prodbro$flag_me)

prodbro <- prodbro %>% dplyr::select(-flag_me)
	

#make not mutually exclusive - resort based on missing & complete data on drug substance name
	#N/A

######
# 4b. Flag codes in multiple BNF subsections, that SHOULD be - for clinician & covariate analysis
######

	#flagging 0202 diuretics

also_0202_diuretic <- c("azide", "pamide")
		
	#flagging 0206 Ca2+ channel blockers


also_0206_CCB <- c("triapin", "dipine", "pamil")
		

		flagcodes <- list(also_0202_diuretic = also_0202_diuretic, also_0206_CCB = also_0206_CCB)
		
		prodbro <- searchProdBro(prodbro, searchlist = flagcodes, searchin = c("Term.from.EMIS", "DrugSubstanceName"))
		colnames(prodbro)
######		
# 4c. Combine your searchterms into one BNF sub-subsection, if applicable
######

prodbro$RAAS20505 <- 0
prodbro$RAAS20505[prodbro$RAASnooverlap20505 == 1] <- 1
prodbro$RAAS20505[prodbro$RAAS1overlap20505 == 1] <- 1
prodbro$RAAS20505[prodbro$RAAS2overlap20505 == 1] <- 1

prodbro <- prodbro %>% dplyr::select(-RAASnooverlap20505, -RAAS1overlap20505, -RAAS2overlap20505)

#############################################################
# 5.) Compare with previous list(s) if applicable
#############################################################
	#as necessary / if available
	#e.g., codelist from previous CPRD Aurum version


	
#############################################################
#Final order, export for clinician review, generate study-specific codelist, tag file

# 6) Send raw codelist for clinician review - for study-specific codelist
# 7) Keep 'master' codelist with all versions & tags
#############################################################

colnames(prodbro)

# arrange it
prodbro <- prodbro %>% arrange(vasodil20501, centact20502, adrblocker20503, ablocker20504, RAAS20505,
                               othadrblocker20508, BNFaddtl, also_0202_diuretic,  also_0206_CCB)

# how many rows?
nrow(prodbro)




# export (v0 no clinician, raw)

summary(prodbro)


# save what you're made. In R, this is commonly saved used an RDS file.

saveRDS(prodbro, paste0(savedir, filename, ".RDS"))

openxlsx2::write_xlsx(prodbro, file = paste0(savedir, filename, ".xlsx")) #, sheetName = "Sheet1", 
#           col.names = TRUE, row.names = FALSE, append = FALSE)

write.csv(prodbro, file = paste0(savedir, filename, ".csv"), row.names = FALSE)




# example versions:
# v0 = Raw codelist 
# v1 = Clinician1 1/2/0s
# v2 = Clinician2 1/2/0s, without Clinician1's 0s)
# v3 = Clinician1 & Clinician2's 1/2/0s merged (i.e., v0-v3 merged)
# v4 = Final, project-specific Codelist- discordancies resolved, final project-specific list
# 
# keep v0 raw, v3 merged, and v4 project-specific
# 
# 


# Generate tag file for codelist repository

tagfile <- file(paste0(savedir, filename, ".tag"))

writeLines(paste(

  # = Update details here, everything else is automated ==========================
 "0205 BNF HTNandHF RX", # description
 "ELG", # author
 "February 2023", # date
 "prod browsing", # code_type
 "CPRD Aurum", # database
 "February 2022", # database_version
 "BNF2.5 hypertension, heart failure, vasodilators, antihypertensives, alpha-blockers, renin-angiotensin system", # keywords
 "Codelist based on BNF Ch. 2.5 Hypertension & Heart Failure, value sets organised by BNF subsection (2.5.1...2.5.8). Use individual subsections to adapt codelist prn based on study context. https:# openprescribing.net/bnf/0205/. Clinician 1s are for [x study].", # notes
 "February 2023", # date clinician_approved
 # ==============================================================================
sep = "\n"), tagfile)

close(tagfile)


