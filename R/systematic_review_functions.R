# configuration
# if on linux: might have to run:
# linux might be required: sudo R CMD javareconf - if need to use RAKE but need trouble shooting
#sudo apt install libudunits2-dev
if (!require("remotes")) install.packages("remotes")
if (!require("pacman")) install.packages("pacman")
p_load_gh("elizagrames/litsearchr", update = T, dependencies = T)
p_load("igraph", "stringr", "data.table")




################################################################################
## Functions
################################################################################

# extend groups of keywords when used wildcards 
extend_keywords_group <- function(tkeyword_l, keyword_ref){
    #`extend truncated (wildcard) keywords (per group): look into a list and extract patterns
    #' @param tkeyword_l : list of keywords, including truncated keywords we want to developp
    #' @param keyword_ref: list. ie reference/dictionary or previous complete list of keywords (assist development) 
    #'  
    # will look to all previously reporded keywords and extend truncated keywords
    
    keywords <- copy(keyword_ref)
    keywords <- str_c(as.character(keywords), collapse = " ")
    extend <- copy(tkeyword_l)
    #print(extend)
    
    for (i in seq_along(tkeyword_l)) {
        if (str_detect(tkeyword_l[i], "\\*")) {
            root <- str_remove(tkeyword_l[i], "\\*")
            pattern <- paste("(",root,")","\\w+", sep = "")
            all_with_root <- str_extract_all(keywords, pattern)
            # we could have condition if empty
            extend[i] <- all_with_root
        }
    }
    
    extend <- unique(unlist(extend))
    return(extend)
}

# Building the search string
# ! improve the writting to do a package
# Building the search string
build_search_string <- function(mandatory, essential, accessory, excluded=NULL, quote_option=F) {
    #' Builds search string for 3 keywords-lists grouped in the following 3 categories:
    #' Building rules: (mandatory) AND (essential) AND (accessory) 
    #' @param mandatory will be combined as: (keyword mandatory A) AND (keyword mandatory B)...
    #' @param essential will be combined as: (one of: group 1 essential keyword) AND (one of group2 essemtial keyword)..
    #' @param accessory will be combined as: (one of keyword belonging to either group: combined by OR)
    #' @param quote_option compliance to DB: if need quote use quote_option:T, otherwise use F
    #' @example To write  # test example
    #' build_search_string(my_mandatory, my_essential, my_accessory, my_excluded, quote_option = T)
    
    # Building internal structure (might improve)
    if (quote_option) { # need better writting
        mandatory <- lapply(mandatory, function(x) toString(dQuote(x)))
        essential <- lapply(essential, function(x) toString(dQuote(x)))
        accessory <- lapply(accessory, function(x) toString(dQuote(x)))
        if (!is.null(excluded)) excluded  <- lapply(excluded, function(x) toString(dQuote(x)))
    } 
    
    search_mandatory <- str_c(unlist(mandatory), collapse = " AND ") 
    search_essential <- lapply(essential, function(x) paste("(", str_c(x, collapse = " OR "),")", sep = ""))
    search_accessory <- paste("(", str_c(unlist(accessory), collapse = " OR "), ")", sep = "") 
    if (!is.null(excluded)) search_excluded <- str_c(unlist(excluded), collapse = " NOT ") 
    
    # building external structure
    search_string <- str_c(unlist(c(search_mandatory, search_essential, search_accessory)), collapse = " AND ") 
    ## case with excluded                   
    if (!is.null(excluded)) search_string <- str_c(list(search_string, search_excluded), collapse = " NOT ")
    
    return(search_string)
}

# function interactive screening

iscreen <- function(df){
    
    
}