# fixing functions in package
# this function remove_duplicates is not really functional yet - modified
no_duplicates <- litsearchr::remove_duplicates(import_search, "title", "exact")
# reports error: 
# >Error in synthesisr::find_duplicates(data = df, match_variable = field,  : 
# > unused argument (match_variable = field)

# rewritten solution working
synthesisr::deduplicate(import_search, match_by = "title", match_function = "stringdist",
                        to_lower = TRUE, rm_punctuation = TRUE)

# or other possibility: rewritten function
remove_duplicates2 <- function (df, field, method = c("stringdist", "fuzzdist", "exact")) {
    # original function that was not working
    #dups <- synthesisr::find_duplicates(data = df, match_variable = field, 
    #   match_function = method, to_lower = TRUE, rm_punctuation = TRUE)
    dups <- synthesisr::find_duplicates(df[,field], match_function = method, 
                                        to_lower = TRUE, rm_punctuation = TRUE)
    
    df <- synthesisr::extract_unique_references(df, matches = dups)
    return(df)
}

remove_duplicates2(import_search, "title", "stringdist")
################################################################################

