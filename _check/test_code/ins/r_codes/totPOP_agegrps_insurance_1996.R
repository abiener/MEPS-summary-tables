# Install and load packages
  package_names <- c("survey","dplyr","foreign","devtools")
  lapply(package_names, function(x) if(!x %in% installed.packages()) install.packages(x))
  lapply(package_names, require, character.only=T)

  install_github("e-mitchell/meps_r_pkg/MEPS")
  library(MEPS)

  options(survey.lonely.psu="adjust")

# Load FYC file
  FYC <- read.xport('C:/MEPS/h12.ssp');
  year <- 1996

  if(year <= 2001) FYC <- FYC %>% mutate(VARPSU = VARPSU96, VARSTR=VARSTR96)
  if(year <= 1998) FYC <- FYC %>% rename(PERWT96F = WTDPER96)
  if(year == 1996) FYC <- FYC %>% mutate(AGE42X = AGE2X, AGE31X = AGE1X)

  FYC <- FYC %>%
    mutate_at(vars(starts_with("AGE")),funs(replace(., .< 0, NA))) %>%
    mutate(AGELAST = coalesce(AGE96X, AGE42X, AGE31X))

  FYC$ind = 1  

# Insurance coverage
# To compute for all insurance categories, replace 'insurance' in the 'svyby' function with 'insurance_v2X'
  if(year == 1996){
    FYC <- FYC %>%
      mutate(MCDEV96 = MCDEVER, MCREV96 = MCREVER,
             OPAEV96 = OPAEVER, OPBEV96 = OPBEVER)
  }

  if(year < 2011){
    FYC <- FYC %>%
      mutate(
        public   = (MCDEV96==1|OPAEV96==1|OPBEV96==1),
        medicare = (MCREV96==1),
        private  = (INSCOV96==1),

        mcr_priv = (medicare &  private),
        mcr_pub  = (medicare & !private & public),
        mcr_only = (medicare & !private & !public),
        no_mcr   = (!medicare),

        ins_gt65 = 4*mcr_only + 5*mcr_priv + 6*mcr_pub + 7*no_mcr,
        INSURC96 = ifelse(AGELAST < 65, INSCOV96, ins_gt65)
      )
  }

  FYC <- FYC %>%
    mutate(insurance = recode_factor(INSCOV96, .default = "Missing",
      "1" = "Any private, all ages",
      "2" = "Public only, all ages",
      "3" = "Uninsured, all ages")) %>%
    mutate(insurance_v2X = recode_factor(INSURC96, .default = "Missing",
      "1" = "<65, Any private",
      "2" = "<65, Public only",
      "3" = "<65, Uninsured",
      "4" = "65+, Medicare only",
      "5" = "65+, Medicare and private",
      "6" = "65+, Medicare and other public",
      "7" = "65+, No medicare",
      "8" = "65+, No medicare"))

# Age groups
# To compute for all age groups, replace 'agegrps' in the 'svyby' function with 'agegrps_v2X' or 'agegrps_v3X'
  FYC <- FYC %>%
    mutate(agegrps = cut(AGELAST,
      breaks = c(-1, 4.5, 17.5, 44.5, 64.5, Inf),
      labels = c("Under 5","5-17","18-44","45-64","65+"))) %>%
    mutate(agegrps_v2X = cut(AGELAST,
      breaks = c(-1, 17.5 ,64.5, Inf),
      labels = c("Under 18","18-64","65+"))) %>%
    mutate(agegrps_v3X = cut(AGELAST,
      breaks = c(-1, 4.5, 6.5, 12.5, 17.5, 18.5, 24.5, 29.5, 34.5, 44.5, 54.5, 64.5, Inf),
      labels = c("Under 5", "5-6", "7-12", "13-17", "18", "19-24", "25-29",
                 "30-34", "35-44", "45-54", "55-64", "65+")))

FYCdsgn <- svydesign(
  id = ~VARPSU,
  strata = ~VARSTR,
  weights = ~PERWT96F,
  data = FYC,
  nest = TRUE)

svyby(~insurance, FUN = svytotal, by = ~agegrps, design = FYCdsgn)
