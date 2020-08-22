library(haven) 
library(ggplot2)
library(dplyr)
library(tidyverse)

# getwd()
setwd("/WAVE/projects/minwage_cps/MULTIVARIABLE_FAMINC")
load("md_algorithms.RData") 
load("wage_to_arrange_algorithm.RData")
cepr_org_2019 <- read_dta("cepr_org_2019.dta")

########  TESTING  ######## 

# EXTRACT THE INFORMATION OF ALL 402 PEOPLE WHO WERE EARNING BELOW MIN WAGE AND WHOSE FAMILY INCOMES WERE >100K
indexed_CEPR <- cepr_org_2019 %>% mutate(index = 1:nrow(cepr_org_2019))
indexed_faminc_15 <- indexed_CEPR  %>% filter(!is.na(rw), rw < 7.5, faminc == 15) %>%  select(index) %>% .$index
df_faminc_15 <- indexed_CEPR[match(indexed_faminc_15, indexed_CEPR$index),]
print(df_faminc_15)


# EXECUTE MD_VAR PROTOCOLS ON THE DATAFRAME


# VARIABLES TO ANALYZE
# "state", "age", "ind_2d", "paidhre", "ownchild", "female", "wbhaom", "marstat", "citizen", "prcitshp", "cow1", "cow2", "multjobn", "educ92" , "docc03", "uhourse", "reltoref"

# DEBUG
print(generate_vector_combinations)
print(multivariable_bmw_analysis)


multivariable_vector <- c("state", "age", "ind_2d", "paidhre", "ownchild", "female", "wbhaom", "marstat", "citizen", "prcitshp", "cow1", "cow2", "multjobn", "educ92" , "docc03", "uhourse", "reltoref")
multivariable_vector_combinations <- generate_vector_combinations(multivariable_vector)


print(multivariable_vector_combinations)

# COMBINATIONS OF VARIABLES WHICH HAVE THE HIGHEST COUNT
highest_counts_df <- matrix(ncol=2,nrow=length(multivariable_vector_combinations))

for (index in seq_along(multivariable_vector_combinations)) {
  vec <- numeric(length(multivariable_vector_combinations))
  # Creating function for returning all the character combinations given a character list
  temp_multidimensional_table <- multivariable_bmw_analysis(df_faminc_15, multivariable_vector_combinations[[index]])
  table_file_name <- paste(multivariable_vector_combinations[[index]], collapse = "")
  
  highest_counts_df[index,1] <- paste(multivariable_vector_combinations[[index]], collapse = " ")
  highest_counts_df[index,2] <- temp_multidimensional_table$Count[1]
}

sorted_variable_comb <- data.frame(highest_counts_df) %>% mutate(X2 = as.numeric(X2))%>% group_by(X2) %>% arrange(desc(X2))
print(sorted_variable_comb)

save(sorted_variable_comb, file = "sorted_variable_comb.RData")

# BELOW IS CODE FOR SAVING THE TABLES
# for (index in seq_along(multivariable_vector_combinations)) {
#   temp_multidimensional_table <- multivariable_bmw_analysis(df_faminc_15, multivariable_vector_combinations[[index]])
#   table_file_name <- paste(multivariable_vector_combinations[[index]], collapse = "")
#   write.table(temp_multidimensional_table, file = paste(table_file_name, ".csv", sep ="", collapse = ""))
#   save(temp_multidimensional_table, file = paste(table_file_name, ".RData", sep = "", collapse = ""))
# 
# }

# FIST TEST LOAD OF VARIABLES OF THESE FOLKS
# PRIMARY HOUSEHOLDER (famrel94, famrel, reltoref), AGE
# variables_for_question <- c("age", "famrel94")

# FAMILY MEMBERS (ownchild), PRIMARY HOUSEHOLDER (famrel94, famrel, reltoref), AGE
# variables_for_question <- c("age", "educ")

# FAMILY MEMBERS (ownchild), PRIMARY HOUSEHOLDER (famrel94, famrel, reltoref), AGE, STATE
# variables_for_question <- c("age", "state")

# df_faminc_15$ownchild[is.na(df_faminc_15$ownchild)] <- 0
# characteristics_faminc_15 <- df_faminc_15 %>% select(variables_for_question) %>% 
#   group_by(df_faminc_15[,variables_for_question[seq_along(variables_for_question)]]) %>% 
#   summarize(Count = n()) %>% arrange(desc(Count))
# 
# characteristics_faminc_15


########  SAVE  ######## 

# save(test_outcome, file = paste(test_var, ".RData", sep = ""))
# test_ggplot <- ggplot(test_bmw_wage4, aes_string(x=test_var)) + geom_bar()
# ggsave_file_name <- paste(test_var, ".pdf", sep = "")
# ggsave(ggsave_file_name)

