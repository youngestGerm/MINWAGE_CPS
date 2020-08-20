# Testing UMAP on some variables contributing to people earning below min wage
# sessionInfo()
library(umap, lib.loc="/WAVE/projects/minwage_cps/R_Packages")

library(tidyverse)
library(haven)
# For table creation and manipulation
library(dplyr)


# Step 1 : Set working directory, read the CEPR data as a tibble

cepr_org_2019 <- read_dta("cepr_org_2019.dta")
cepr_2019_tibble <- as_tibble(cepr_org_2019)

# Step 2 : Chose our variables for further analysis

# Here are our variables that we will use in the PCA
# Note that this analysis may be flawed. I am only using these variables for testing purposes

# Categorical variable:
# cepr_2019_tibble$female

# Infinite...
# cepr_2019_tibble$age
# cepr_2019_tibble$educ
# cepr_2019_tibble$faminc

chosenVariables <- tibble(age = cepr_2019_tibble$age, education = cepr_2019_tibble$educ, familyIncome = cepr_2019_tibble$faminc)
CEPRUmap <- select(chosenVariables, -familyIncome) %>%
  as.matrix()

# Step 3 : Run UMAP

# Set a working directory so that the ML folder doesn't get clustered
dir.create("DATA")
setwd(dir = capture.output(cat(getwd(), '/DATA', sep ="")))
print(getwd())

# Start fine tuning the UMAP parameters
n_neighbors <- c(2,13,30,60)
min_dist <- c(0.1,0.5,0.7)
for (n_n in n_neighbors) {
  print("n_n")
  print(n_n)
  for (m_d in min_dist) {
    print("m_d")
    print(m_d)
    temp_save_umap <- CEPRUmap %>% umap(n_neighbors = n_n, min_dist = m_d, metric = "manhattan", n_epochs = 1000, verbose = "TRUE")
    
    # Save the data so that if all else goes wrong, we can still graph by ourselves
    save(temp_save_umap, file=capture.output(cat('CPSUMAP',n_n,m_d,'.RData', sep ="")))
  }
}

# Plotting the data that we obtained above
print("PLOTTING NOW------------------------------------------------------
      ------------------------------------------------------
      ---------------------------------------------------------------
      ------------------------------------------------------")


for (n_n in n_neighbors) {
  print("n_n")
  print(n_n)
  for (m_d in min_dist) {
    print("m_d")
    print(m_d)
    load(capture.output(cat('CPSUMAP',n_n,m_d,'.RData', sep = "")))
    print(temp_save_umap)
    
    cpsTibUmap <- chosenVariables %>% 
      mutate(UMAP1 = temp_save_umap$layout[,1], UMAP2 = temp_save_umap$layout[,2]) %>%
      gather(key = "Variable", value = "Value", c(-UMAP1, -UMAP2, -familyIncome))
    
    existingCPSTibUmapPlot <- ggplot(cpsTibUmap, aes(UMAP1, UMAP2, col = familyIncome)) +
      facet_wrap(~Variable) +
      geom_point(size = 3) + 
      theme_bw()
    
    ggsave(capture.output(cat(n_n,m_d,".pdf", sep ="")), device = "pdf")
  }
}

# Reseting the WD
setwd('..')

# END OF DATA DIRECTORY






