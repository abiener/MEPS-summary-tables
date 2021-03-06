# Install and load packages
  package_names <- c("survey","dplyr","foreign","devtools")
  lapply(package_names, function(x) if(!x %in% installed.packages()) install.packages(x))
  lapply(package_names, require, character.only=T)

  install_github("e-mitchell/meps_r_pkg/MEPS")
  library(MEPS)

  options(survey.lonely.psu="adjust")

# Load FYC file
  FYC <- read.xport('C:/MEPS/h138.ssp');
  year <- 2010
  
  FYC <- FYC %>%
    mutate_at(vars(starts_with("AGE")),funs(replace(., .< 0, NA))) %>%
    mutate(AGELAST = coalesce(AGE10X, AGE42X, AGE31X))

  FYC$ind = 1

# How often doctor spent enough time (adults)
  FYC <- FYC %>%
    mutate(adult_time = recode_factor(
      ADPRTM42, .default = "Missing",
      "4" = "Always",
      "3" = "Usually",
      "2" = "Sometimes/Never",
      "1" = "Sometimes/Never",
      "-7" = "Don't know/Non-response",
      "-8" = "Don't know/Non-response",
      "-9" = "Don't know/Non-response",
      "-1" = "Inapplicable"))

# Sex
  FYC <- FYC %>%
    mutate(sex = recode_factor(SEX, .default = "Missing",
      "1" = "Male",
      "2" = "Female"))

SAQdsgn <- svydesign(
  id = ~VARPSU,
  strata = ~VARSTR,
  weights = ~SAQWT10F,
  data = FYC,
  nest = TRUE)

svyby(~adult_time, FUN=svymean, by = ~sex, design = subset(SAQdsgn, ADAPPT42 >= 1 & AGELAST >= 18))
