library(Rtsne)
library(tidyverse)
library(haven)
# For table creation and manipulation
library(dplyr)

# Step 1 : Set working directory, read the CEPR data as a tibble

cepr_org_2019 <- read_dta("cepr_org_2019.dta")
# write.csv(cepr_org_2019, file = "cepr_org_2019.csv")

cepr_2019_tibble <- as_tibble(cepr_org_2019)

# Step 2 : Chose our variables for further analysis

# Here are our variables that we will use in the PCA
# Note that this analysis may be flawed. I am only using these variables for testing purposes

# Categorical variable:
cepr_2019_tibble$female

# Infinite...
cepr_2019_tibble$age
cepr_2019_tibble$educ
cepr_2019_tibble$faminc

chosenVariables <- tibble(age = cepr_2019_tibble$age, education = cepr_2019_tibble$educ, familyIncome = cepr_2019_tibble$faminc, female = cepr_2019_tibble$female)

# Step 3 : Run t-SNE

CEPRTsne <- select(chosenVariables, -female) %>%
  Rtsne(perplexity = 50, eta = 10, theta = 0.3, max_iter = 10000, verbose = TRUE, check_duplicates = FALSE)

save(CEPRTsne, file="CPSTsne.RData")
#load("CPSTsne.RData")


###### tSNE 1 ########  

CEPRTsne$Y[,1]

###### tSNE 2 ######## 

CEPRTsne$Y[,2]

#####################

CPSTibTsne <- chosenVariables %>%
  mutate(tSNE1 = CEPRTsne$Y[,1], tSNE2 = CEPRTsne$Y[,2]) %>%
  gather(key = "Variable", value = "Value", c(-tSNE1, -tSNE2, -female))


existingCPSTsnePlot <- ggplot(CPSTibTsne, aes(tSNE1, tSNE2, col = female)) +
  facet_wrap(~ Variable) +
  geom_point(size = 3) +
  theme_bw()

ggsave("existingCPSTsnePlot.pdf", device = "pdf")



