# Step 3 : Run SOM
library(tidyverse)
library(haven)
# For table creation and manipulation
library(dplyr)
library(GGally)
library(kohonen)


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

somGrid <- somgrid(xdim = 75, ydim = 75, topo = "hexagonal", neighbourhood.fct = "bubble", toroidal = FALSE)
CEPRScaled <- chosenVariables %>% select(-female) %>% scale()
CEPRSom <- som(CEPRScaled, grid = somGrid, rlen = 1000, alpha = c(0.05, 0.01))

save(CEPRSom, file="CPSSOM.RData")
#load("CPSSOM.RData")

pdf("existingCPSTibSOMPlot1.pdf")
par(mfrow = c(2, 3))
plotTypes <- c("codes", "changes", "counts", "quality", "dist.neighbours", "mapping")
walk(plotTypes, ~plot(CEPRSom, type = ., shape = "straight"))

dev.off()

getCodes(CEPRSom) %>% as_tibble() %>%
  iwalk(~plot(CEPRSom, type = "property", property = ., 
              main = .y, shape = "straight"))

pdf("existingCPSTibSOMPlot2.pdf")
par(mfrow = c(1, 1))
nodeCols <- c("cyan3", "purple")
plot(CEPRSom, type = "mapping", pch = 21, 
     bg = nodeCols[as.numeric(chosenVariables$female)+1],
     bgcol = "lightgrey")

dev.off()
