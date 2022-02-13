library(pacman)
p_load(stringr)
my_string <-  "epidemiology is the study of epidemics"
my_pattern <- "epidem*"
str_extract_all(my_string, "(epidemi)\\w+")

data <- read.csv(file = "src/naive_keywords.csv")

my_string <- as.character(data$keyword)

my_string2 <-str_c(my_string, collapse = " ")
str_extract_all(my_string2, "(epidemi)\\w+")



# building the function of it
tkeyword_l <- list("epidem*", "laborator*", "not truncated")


pubmed <- new("searched_database", db_name = "PubMed" , src = "https://www.ncbi.nlm.nih.gov/pubmed/", 
              date = Sys.Date(),  search = my_search_string2, tsearch = tsearch_pubmed, nb = 178)

# class definition
# db_name: name database (if try several seach can give several numbers)
# src:  database url
# date - extracted from system
# search - extracted from our parameter
# tsearch - ie pubmed re-transform our search - so we can glue here the transformation
# nb : number of hits from this search
setClass("searched_database", slots = c(db_name = "character", src = "character", date = "Date", 
                                        search = "character", tsearch = "character", nb = "numeric"))