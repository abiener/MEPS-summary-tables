# Install and load packages
  package_names <- c("survey","dplyr","foreign","devtools")
  lapply(package_names, function(x) if(!x %in% installed.packages()) install.packages(x))
  lapply(package_names, require, character.only=T)

  install_github("e-mitchell/meps_r_pkg/MEPS")
  library(MEPS)

  options(survey.lonely.psu="adjust")

# Load RX file and merge with therapeutic class names ('tc1_names')
  RX <- read.xport("C:/MEPS/h178a.ssp") %>%
    left_join(tc1_names, by = "TC1") %>%
    mutate(count = 1)

RXdsgn <- svydesign(
  id = ~VARPSU,
  strata = ~VARSTR,
  weights = ~PERWT15F,
  data = RX,
  nest = TRUE
)

svyby(~RXXP15X, by = ~TC1name, FUN = svytotal, design = RXdsgn)
