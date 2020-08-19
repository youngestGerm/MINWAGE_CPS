# Dimension Reduction (PCA) Test on CEPR ORG DATA
library(haven)
# For table creation and manipulation
library(dplyr)
library(tidyverse)
library(factoextra)


# Step 1 : Set working directory, and read the CEPR data as a tibble

getwd()
setwd("/Volumes/GoogleDrive/My\ Drive/MWage/R\ Studio")
cepr_org_2019 <- read_dta("./Data/cepr_org_2019.dta")
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

# Step 3 : Generate the PCA, and graph the Ps

# zap_formats(cepr_org_2019$age)
# zap_labels(cepr_org_2019$age)

pca <- select(chosenVariables, -female) %>%
  prcomp(center = TRUE, scale = TRUE)

#########
pcaDat <- get_pca(pca)
pcaDat$coord


fviz_pca_biplot(pca, label = "var")
fviz_pca_var(pca)
# Finding the contribtion of the specific pca dimension
fviz_screeplot(pca, addlabels = TRUE, choice = "eigenvalue")
# Higher the eigenvalue, higher the contribution of the specific dimension
fviz_screeplot(pca, addlabels = TRUE, choice = "variance")

#########
chosenVariablesPCA <- chosenVariables %>%
  mutate(PCA1 = pca$x[, 1], PCA2 = pca$x[, 2]) %>% 
  mutate_if(is.numeric, ~as.character(.))

str(chosenVariablesPCA)

existingVariablePCA <- ggplot(chosenVariablesPCA, aes(PCA1, PCA2, col = female)) + geom_point()
existingVariablePCA

pdf("existingVariablePCA.pdf")
myplot <- ggplot(mtcars, aes(wt, mpg)) + geom_point()
print(myplot)

# Step 4 : Summarize findings
# So since the plot still looks extremely noisy, PCA obviously does not work for these variables. 
# One of the reasons why is because we have 291,390 rows. So it is very hard to see anything besides noise.
# Let's proceed to tSNE.


######### TEST #########

newTestCase <- tibble(
  age = c(20, 25),
  education = c(5, 4),
  familyIncome = c(11, 8)
)

newPrediction <- predict(pca, newTestCase)
newPrediction

newPredictionDF <- data.frame(PCA1 = c(newPrediction[1,1], newPrediction[2,1]), PCA2 = c(newPrediction[1,2], newPrediction[2,2]))

newGraph <- existingVariablePCA + geom_point(data = newPredictionDF, color = c("green", "red"))
newGraph
  

