ods graphics off;

/* Read in dataset and initialize year */
FILENAME h163 "C:\MEPS\h163.ssp";
proc xcopy in = h163 out = WORK IMPORT;
run;

data MEPS;
 SET h163;
 ARRAY OLDVAR(5) VARPSU13 VARSTR13 WTDPER13 AGE2X AGE1X;
 year = 2013;
 ind = 1;
 count = 1;

 if year <= 2001 then do;
  VARPSU = VARPSU13;
  VARSTR = VARSTR13;
 end;

 if year <= 1998 then do;
  PERWT13F = WTDPER13;
 end;

 /* Create AGELAST variable */
 if year = 1996 then do;
   AGE42X = AGE2X;
   AGE31X = AGE1X;
 end;

 if AGE13X >= 0 then AGELAST = AGE13x;
 else if AGE42X >= 0 then AGELAST = AGE42X;
 else if AGE31X >= 0 then AGELAST = AGE31X;
run;

proc format;
 value ind 1 = "Total";
run;

/* Insurance coverage */
/* To compute for insurance categories, replace 'insurance' in the SURVEY procedure with 'insurance_v2X' */
data MEPS; set MEPS;
 ARRAY OLDINS(4) MCDEVER MCREVER OPAEVER OPBEVER;
 if year = 1996 then do;
  MCDEV96 = MCDEVER;
  MCREV96 = MCREVER;
  OPAEV96 = OPAEVER;
  OPBEV96 = OPBEVER;
 end;

 if year < 2011 then do;
  public   = (MCDEV13 = 1) or (OPAEV13=1) or (OPBEV13=1);
  medicare = (MCREV13=1);
  private  = (INSCOV13=1);

  mcr_priv = (medicare and  private);
  mcr_pub  = (medicare and ~private and public);
  mcr_only = (medicare and ~private and ~public);
  no_mcr   = (~medicare);

  ins_gt65 = 4*mcr_only + 5*mcr_priv + 6*mcr_pub + 7*no_mcr;

  if AGELAST < 65 then INSURC13 = INSCOV13;
  else INSURC13 = ins_gt65;
 end;

 insurance = INSCOV13;
 insurance_v2X = INSURC13;
run;

proc format;
 value insurance
 1 = "Any private, all ages"
 2 = "Public only, all ages"
 3 = "Uninsured, all ages";

 value insurance_v2X
 1 = "<65, Any private"
 2 = "<65, Public only"
 3 = "<65, Uninsured"
 4 = "65+, Medicare only"
 5 = "65+, Medicare and private"
 6 = "65+, Medicare and other public"
 7 = "65+, No medicare"
 8 = "65+, No medicare";
run;

/* Perceived health status */
data MEPS; set MEPS;
 ARRAY OLDHLT(2) RTEHLTH1 RTEHLTH2;
 if year = 1996 then do;
  RTHLTH53 = RTEHLTH2;
  RTHLTH42 = RTEHLTH2;
  RTHLTH31 = RTEHLTH1;
 end;

 if RTHLTH53 >= 0 then health = RTHLTH53;
 else if RTHLTH42 >= 0 then health = RTHLTH42;
 else if RTHLTH31 >= 0 then health = RTHLTH31;
 else health = .;
run;

proc format;
 value health
 1 = "Excellent"
 2 = "Very good"
 3 = "Good"
 4 = "Fair"
 5 = "Poor"
 . = "Missing";
run;

data MEPS;
 set MEPS;
 domain = (AGELAST >= 65);
run;

ods output CrossTabs = out;
proc surveyfreq data = MEPS missing;
 FORMAT health health. insurance_v2X insurance_v2X.;
 STRATA VARSTR;
 CLUSTER VARPSU;
 WEIGHT PERWT13F;
 TABLES domain*health*insurance_v2X / row;
run;

proc print data = out;
 where insurance_v2X ne . ;
 var domain health insurance_v2X Frequency WgtFreq StdDev RowPercent RowStdErr;
run;
