library(caret)
library(tidyverse)
library(dplyr)
library(rvest)
library(haven)
library(ggplot2)
library(caret)

# getwd()
# setwd("/Volumes/GoogleDrive/My Drive/MWage/R Studio/ML_DIMENSION_REDUCTION/FEMALE_AGE_EDUC/ALGORITHM")
# Variables
# age, female, 

# STEP 1: LOCATE EVERYONE THAT IS MAKING BELOW MIN WAGE (JUST USE RW)
cepr_org_2019 <- read_dta("cepr_org_2019.dta")


cepr_org_2019$ID <- seq.int(nrow(cepr_org_2019))

# Min wage and children 
# Ages 0-2

bmin_children02_rw  <- cepr_org_2019 %>%
  select(rw, ch02, ID) %>% 
  filter(!is.na(rw), !is.na(ch02), rw <= 7.5, ch02 == 1)
bmin_children02_rw
nrow(bmin_children02_rw)
#207

amin_children_rw <- cepr_org_2019 %>%
  select(rw, ch02, ch35, ch613, ch1417, ownchild, ID) %>% 
  filter(!is.na(rw), !is.na(ch02), rw > 7.5, ch02 == 1)
amin_children_rw
nrow(amin_children_rw)
# 10768

# Test:
amin_children02_rw <- cepr_org_2019 %>%
  select(rw, ch02, ch35, ch613, ch1417, ownchild, ID) %>% 
  filter(!is.na(rw), !is.na(ch02), rw > 7.5, ch02 == 1)

amin_children_rw

ggplot(amin_children_rw, aes(x = ownchild, y = rw)) + geom_dotplot(binaxis = "y", binwidth = .4)
ggplot(amin_children_rw, aes(x = ownchild, y = rw)) + geom_count() + geom_quantile()

# A closer inspection
par(mfrow = c(2,2))

ggplot(amin_children_rw, aes(x = ch02, y = rw)) + geom_dotplot(binaxis = "y", binwidth = .4)
ggplot(amin_children_rw, aes(x = ch35, y = rw)) + geom_dotplot(binaxis = "y", binwidth = .4)
ggplot(amin_children_rw, aes(x = ch613, y = rw)) + geom_dotplot(binaxis = "y", binwidth = .4)
ggplot(amin_children_rw, aes(x = ch1417, y = rw)) + geom_dotplot(binaxis = "y", binwidth = .4)
# Ages 14-17




# Min wage and school

