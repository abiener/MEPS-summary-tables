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

# Usual source of care
  FYC <- FYC %>%
    mutate(usc = ifelse(HAVEUS42 == 2, 0, LOCATN42)) %>%
    mutate(usc = recode_factor(usc, .default = "Missing",
      "0" = "No usual source of health care",
      "1" = "Office-based",
      "2" = "Hospital (not ER)",
      "3" = "Emergency room"))

# Perceived health status
  if(year == 1996)
    FYC <- FYC %>% mutate(RTHLTH53 = RTEHLTH2, RTHLTH42 = RTEHLTH2, RTHLTH31 = RTEHLTH1)

  FYC <- FYC %>%
    mutate_at(vars(starts_with("RTHLTH")), funs(replace(., .< 0, NA))) %>%
    mutate(
      health = coalesce(RTHLTH53, RTHLTH42, RTHLTH31),
      health = recode_factor(health, .default = "Missing",
        "1" = "Excellent",
        "2" = "Very good",
        "3" = "Good",
        "4" = "Fair",
        "5" = "Poor"))

FYCdsgn <- svydesign(
  id = ~VARPSU,
  strata = ~VARSTR,
  weights = ~PERWT02F,
  data = FYC,
  nest = TRUE)

svyby(~usc, FUN = svymean, by = ~health, design = subset(FYCdsgn, ACCELI42==1 & HAVEUS42 >= 0 & LOCATN42 >= -1))
