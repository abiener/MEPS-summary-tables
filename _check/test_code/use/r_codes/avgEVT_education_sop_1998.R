# Install and load packages
  package_names <- c("survey","dplyr","foreign","devtools")
  lapply(package_names, function(x) if(!x %in% installed.packages()) install.packages(x))
  lapply(package_names, require, character.only=T)

  install_github("e-mitchell/meps_r_pkg/MEPS")
  library(MEPS)

  options(survey.lonely.psu="adjust")

# Load FYC file
  FYC <- read.xport('C:/MEPS/h28.ssp');
  year <- 1998

  if(year <= 2001) FYC <- FYC %>% mutate(VARPSU = VARPSU98, VARSTR=VARSTR98)
  if(year <= 1998) FYC <- FYC %>% rename(PERWT98F = WTDPER98)
  if(year == 1996) FYC <- FYC %>% mutate(AGE42X = AGE2X, AGE31X = AGE1X)

  FYC <- FYC %>%
    mutate_at(vars(starts_with("AGE")),funs(replace(., .< 0, NA))) %>%
    mutate(AGELAST = coalesce(AGE98X, AGE42X, AGE31X))

  FYC$ind = 1  

# Education
  if(year <= 1998){
    FYC <- FYC %>% mutate(EDUCYR = EDUCYR98)
  }else if(year <= 2004){
    FYC <- FYC %>% mutate(EDUCYR = EDUCYEAR)
  }

  if(year >= 2012){
    FYC <- FYC %>%
      mutate(
        less_than_hs = (0 <= EDRECODE & EDRECODE < 13),
        high_school  = (EDRECODE == 13),
        some_college = (EDRECODE > 13))

  }else{
    FYC <- FYC %>%
      mutate(
        less_than_hs = (0 <= EDUCYR & EDUCYR < 12),
        high_school  = (EDUCYR == 12),
        some_college = (EDUCYR > 12))
  }

  FYC <- FYC %>% mutate(
    education = 1*less_than_hs + 2*high_school + 3*some_college,
    education = replace(education, AGELAST < 18, 9),
    education = recode_factor(education, .default = "Missing",
      "1" = "Less than high school",
      "2" = "High school",
      "3" = "Some college",
      "9" = "Inapplicable (age < 18)",
      "0" = "Missing"))

# Keep only needed variables from FYC
  FYCsub <- FYC %>% select(education,ind, DUPERSID, PERWT98F, VARSTR, VARPSU)

# Load event files
  RX <- read.xport('C:/MEPS/h26a.ssp')
  DVT <- read.xport('C:/MEPS/hc26bf1.ssp')
  IPT <- read.xport('C:/MEPS/h26df1.ssp')
  ERT <- read.xport('C:/MEPS/h26ef1.ssp')
  OPT <- read.xport('C:/MEPS/h26ff1.ssp')
  OBV <- read.xport('C:/MEPS/h26gf1.ssp')
  HHT <- read.xport('C:/MEPS/h26hf1.ssp')

# Define sub-levels for office-based and outpatient
  OBV <- OBV %>%
    mutate(event_v2X = recode_factor(
      SEEDOC, .default = 'Missing', '1' = 'OBD', '2' = 'OBO'))

  OPT <- OPT %>%
    mutate(event_v2X = recode_factor(
      SEEDOC, .default = 'Missing', '1' = 'OPY', '2' = 'OPZ'))

# Stack events
  stacked_events <- stack_events(RX, DVT, IPT, ERT, OPT, OBV, HHT,
    keep.vars = c('SEEDOC','event_v2X'))

  stacked_events <- stacked_events %>%
    mutate(event = data,
           PR98X = PV98X + TR98X,
           OZ98X = OF98X + SL98X + OT98X + OR98X + OU98X + WC98X + VA98X) %>%
    select(DUPERSID, event, event_v2X, SEEDOC,
      XP98X, SF98X, MR98X, MD98X, PR98X, OZ98X)

pers_events <- stacked_events %>%
  group_by(DUPERSID) %>%
  summarise(ANY = sum(XP98X >= 0),
            EXP = sum(XP98X > 0),
            SLF = sum(SF98X > 0),
            MCR = sum(MR98X > 0),
            MCD = sum(MD98X > 0),
            PTR = sum(PR98X > 0),
            OTZ = sum(OZ98X > 0)) %>%
  ungroup

n_events <- full_join(pers_events,FYCsub,by='DUPERSID') %>%
  mutate_at(vars(ANY,EXP,SLF,MCR,MCD,PTR,OTZ),
            function(x) ifelse(is.na(x),0,x))

nEVTdsgn <- svydesign(
  id = ~VARPSU,
  strata = ~VARSTR,
  weights = ~PERWT98F,
  data = n_events,
  nest = TRUE)

svyby(~EXP + SLF + MCR + MCD + PTR + OTZ, FUN=svymean, by = ~education, design = nEVTdsgn)
