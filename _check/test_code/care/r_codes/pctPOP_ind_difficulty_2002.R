# Install and load packages
  package_names <- c("survey","dplyr","foreign","devtools")
  lapply(package_names, function(x) if(!x %in% installed.packages()) install.packages(x))
  lapply(package_names, require, character.only=T)

  install_github("e-mitchell/meps_r_pkg/MEPS")
  library(MEPS)

  options(survey.lonely.psu="adjust")

# Load FYC file
  FYC <- read.xport('C:/MEPS/h70.ssp');
  year <- 2002
  
  FYC <- FYC %>%
    mutate_at(vars(starts_with("AGE")),funs(replace(., .< 0, NA))) %>%
    mutate(AGELAST = coalesce(AGE02X, AGE42X, AGE31X))

  FYC$ind = 1

# Difficulty receiving needed care
  FYC <- FYC %>%
    mutate(delay_MD = (MDUNAB42 == 1|MDDLAY42==1)*1,
           delay_DN = (DNUNAB42 == 1|DNDLAY42==1)*1,
           delay_PM = (PMUNAB42 == 1|PMDLAY42==1)*1,
           delay_ANY = (delay_MD|delay_DN|delay_PM)*1)

FYCdsgn <- svydesign(
  id = ~VARPSU,
  strata = ~VARSTR,
  weights = ~PERWT02F,
  data = FYC,
  nest = TRUE)

svyby(~delay_ANY + delay_MD + delay_DN + delay_PM, FUN = svymean, by = ~ind, design = subset(FYCdsgn, ACCELI42==1))
