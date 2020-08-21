library(haven) 
library(ggplot2)
library(dplyr)
library(tidyverse)


setwd("[FOR DATA]")
cepr_org_2019 <- read_dta("[where data is on WAVE]")
setwd("[OUTPUT/OUTCOMES]")

# GOALS:

# 1) ADD DATA TOGETHER, E.G. COMBINE STATE AND INDUSTRY VARIABLES TOGETHER.
# E.G. ARE MOST PEOPLE WHO MAKE LESS THAN MINIMUM WAGE IN THE FOOD SERVICES INDUSTRY LIVING IN TEXAS?
# E.G. ARE BMW PEOPLE WHO HAVE FAMILY INCOMES >$100K OLDER THAN 18?

# _________________________________________________________________________________________________________
########  GOAL 1: ######## 

########  PROTOCOLS ######## 

multivariable_bmw_analysis <- function(obj, ...) {
  temp_mv_obj <- obj %>% select(rw, ...) %>% drop_na() %>% filter(rw < 7.5) %>%
    group_by(.dots=lapply(..., as.symbol)) %>% summarize(Count = n()) %>% arrange(desc(Count))
  return (temp_mv_obj)
}

generate_vector_combinations <- function(temp_character_vector) {
  modlist <- vector()
  newlist <- vector()
  for (index in 1:length(temp_character_vector)) {
    modlist <- c(modlist, combn(temp_character_vector, index, paste, collapse = " "))
  }
  for (iterative in 1:length(modlist)) {
    modlist[iterative] <- c(modlist[iterative])
    newlist <- append(newlist, strsplit(modlist[iterative], " "))
  }  
  return (newlist)
}

######## EXECUTING COMBINATIONS ON ALL DESIRED VARIABLES ########

multivariable_vector <- c("state", "age", "ind_2d", "educ", "ch02", "ch35", "ch613", "paidhre", "faminc", "minsamp", "female", "wbhaom", "marstat", "citizen", "prcitshp", "cow1", "cow2", "schenrl", "multjobn", "educ92" , "docc03", "uhourse", "reltoref")
multivariable_vector_combinations <- generate_vector_combinations(multivariable_vector)

for (index in seq_along(multivariable_vector_combinations)) {
  # Creating function for returning all the character combinations given a character list
  temp_multidimensional_table <- multivariable_bmw_analysis(cepr_org_2019, multivariable_vector_combinations[[index]])
  table_file_name <- paste(multivariable_vector_combinations[[index]], collapse = "")
  print(paste(table_file_name, ".csv", sep ="", collapse = ""))
  write.table(temp_multidimensional_table, file = paste(table_file_name, ".csv", sep ="", collapse = ""))
  save(temp_multidimensional_table, file = paste(table_file_name, ".RData", sep = "", collapse = ""))
  print(temp_multidimensional_table)
}

######## EXECUTING COMBINATIONS ON ONLY SELECTED VARIABLES ######## 

# multivariable_vector <- c("state", "age")
# multivariable_vector_combinations <- generate_vector_combinations(multivariable_vector)
# 
# for (index in 1:length(multivariable_vector_combinations)) {
#   # Creating function for returning all the character combinations given a character list
#   temp_multidimensional_table <- multivariable_bmw_analysis(cepr_org_2019, multivariable_vector_combinations[[index]])
#   table_file_name <- paste(multivariable_vector_combinations[[index]], collapse = "")
#   print(paste(table_file_name, ".csv", sep ="", collapse = ""))
#   write.table(temp_multidimensional_table, file = paste(table_file_name, ".csv", sep ="", collapse = ""))
#   print(paste(table_file_name, ".RData", sep ="", collapse = ""))
#   save(temp_multidimensional_table, file = paste(table_file_name, ".RData", sep = "", collapse = ""))
# }



######## READING FILES IN CSV SAVED ######## 

# multidimensional_table_container <- list()
# for (i in seq_along(my_files)) {
#   load(my_files[i])
#   print(temp_multidimensional_table)
#   multidimensional_table_container[[i]] <- temp_multidimensional_table
# }



########  TESTING ######## 

# FOR SPECIFICALLY OWNCHILD (CONVERT NA TO 0)

# temp_mv_obj <- cepr_org_2019 %>% select(rw, ownchild, famrel, age) %>% replace_na(list(ownchild = 0)) %>% 
#   drop_na() %>% filter(rw < 7.5) %>% group_by(ownchild, famrel, age) %>% 
#   summarize(Count = n()) %>% arrange(desc(Count))
# 
# temp_mv_obj





