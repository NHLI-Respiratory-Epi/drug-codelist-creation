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
