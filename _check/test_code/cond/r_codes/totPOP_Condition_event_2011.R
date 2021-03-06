# Install and load packages
  package_names <- c("survey","dplyr","foreign","devtools")
  lapply(package_names, function(x) if(!x %in% installed.packages()) install.packages(x))
  lapply(package_names, require, character.only=T)

  install_github("e-mitchell/meps_r_pkg/MEPS")
  library(MEPS)

  options(survey.lonely.psu="adjust")

# Load FYC file
  FYC <- read.xport('C:/MEPS/h147.ssp');
  year <- 2011

  if(year <= 2001) FYC <- FYC %>% mutate(VARPSU = VARPSU11, VARSTR=VARSTR11)
  if(year <= 1998) FYC <- FYC %>% rename(PERWT11F = WTDPER11)
  if(year == 1996) FYC <- FYC %>% mutate(AGE42X = AGE2X, AGE31X = AGE1X)

  FYC <- FYC %>%
    mutate_at(vars(starts_with("AGE")),funs(replace(., .< 0, NA))) %>%
    mutate(AGELAST = coalesce(AGE11X, AGE42X, AGE31X))

  FYC$ind = 1  

# Add aggregate event variables
  FYC <- FYC %>% mutate(
    HHTEXP11 = HHAEXP11 + HHNEXP11, # Home Health Agency + Independent providers
    ERTEXP11 = ERFEXP11 + ERDEXP11, # Doctor + Facility Expenses for OP, ER, IP events
    IPTEXP11 = IPFEXP11 + IPDEXP11,
    OPTEXP11 = OPFEXP11 + OPDEXP11, # All Outpatient
    OPYEXP11 = OPVEXP11 + OPSEXP11, # Physician only
    OPZEXP11 = OPOEXP11 + OPPEXP11, # Non-physician only
    OMAEXP11 = VISEXP11 + OTHEXP11) # Other medical equipment and services

  FYC <- FYC %>% mutate(
    TOTUSE11 = ((DVTOT11 > 0) + (RXTOT11 > 0) + (OBTOTV11 > 0) +
                  (OPTOTV11 > 0) + (ERTOT11 > 0) + (IPDIS11 > 0) +
                  (HHTOTD11 > 0) + (OMAEXP11 > 0))
  )

# Keep only needed variables from FYC
  FYCsub <- FYC %>% select(ind, DUPERSID, PERWT11F, VARSTR, VARPSU)

# Load event files
  RX <- read.xport('C:/MEPS/h144a.ssp')
  DVT <- read.xport('C:/MEPS/h144b.ssp')
  IPT <- read.xport('C:/MEPS/h144d.ssp')
  ERT <- read.xport('C:/MEPS/h144e.ssp')
  OPT <- read.xport('C:/MEPS/h144f.ssp')
  OBV <- read.xport('C:/MEPS/h144g.ssp')
  HHT <- read.xport('C:/MEPS/h144h.ssp')

# Define sub-levels for office-based and outpatient
  OBV <- OBV %>%
    mutate(event_v2X = recode_factor(
      SEEDOC, .default = 'Missing', '1' = 'OBD', '2' = 'OBO'))

  OPT <- OPT %>%
    mutate(event_v2X = recode_factor(
      SEEDOC, .default = 'Missing', '1' = 'OPY', '2' = 'OPZ'))

# Sum RX purchases for each event
  RX <- RX %>%
    rename(EVNTIDX = LINKIDX) %>%
    group_by(DUPERSID,EVNTIDX) %>%
    summarise_at(vars(RXSF11X:RXXP11X),sum) %>%
    ungroup

# Stack events (dental visits and other medical not collected for events)
  stacked_events <- stack_events(RX, IPT, ERT, OPT, OBV, HHT, keep.vars = c('SEEDOC','event_v2X'))

  stacked_events <- stacked_events %>%
    mutate(event = data,
           PR11X = PV11X + TR11X,
           OZ11X = OF11X + SL11X + OT11X + OR11X + OU11X + WC11X + VA11X)

# Read in event-condition linking file
  clink1 = read.xport('C:/MEPS/h144if1.ssp') %>%
    select(DUPERSID,CONDIDX,EVNTIDX)

# Read in conditions file and merge with condition_codes, link file
  cond <- read.xport('C:/MEPS/h146.ssp') %>%
    select(DUPERSID, CONDIDX, CCCODEX) %>%
    mutate(CCS_Codes = as.numeric(as.character(CCCODEX))) %>%
    left_join(condition_codes, by = "CCS_Codes") %>%
    full_join(clink1, by = c("DUPERSID", "CONDIDX")) %>%
    distinct(DUPERSID, EVNTIDX, Condition, .keep_all=T)

# Merge events with conditions-link file and FYCsub
  all_events <- full_join(stacked_events, cond, by=c("DUPERSID","EVNTIDX")) %>%
    filter(!is.na(Condition),XP11X >= 0) %>%
    mutate(count = 1) %>%
    full_join(FYCsub, by = "DUPERSID")

# Sum by person, condition, event;
all_persev <- all_events %>%
  group_by(ind, DUPERSID, VARSTR, VARPSU, PERWT11F, Condition, event, count) %>%
  summarize_at(vars(SF11X, PR11X, MR11X, MD11X, OZ11X, XP11X),sum) %>% ungroup

PERSevnt <- svydesign(
  id = ~VARPSU,
  strata = ~VARSTR,
  weights = ~PERWT11F,
  data = all_persev,
  nest = TRUE)

svyby(~count, by = ~Condition + event, FUN = svytotal, design = PERSevnt)
