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

/* Poverty status */
data MEPS; set MEPS;
 ARRAY OLDPOV(1) POVCAT;
 if year = 1996 then POVCAT96 = POVCAT;
 poverty = POVCAT13;
run;

proc format;
 value poverty
 1 = "Negative or poor"
 2 = "Near-poor"
 3 = "Low income"
 4 = "Middle income"
 5 = "High income";
run;

/* Load event files */
%macro load_events(evnt,file) / minoperator;

 FILENAME &file. "C:\MEPS\&file..ssp";
 proc xcopy in = &file. out = WORK IMPORT;
 run;

 data &evnt;
  SET &syslast; /* Most recent dataset loaded */
  ARRAY OLDVARS(2) LINKIDX EVNTIDX;
  event = "&evnt.";
  year = 2013;

  %if &evnt in (IP OP ER) %then %do;
  ARRAY OLDVARS2(3) &evnt.DCH13X &evnt.FCH13X SEEDOC ;
   SF13X = &evnt.DSF13X + &evnt.FSF13X;
   MR13X = &evnt.DMR13X + &evnt.FMR13X;
   MD13X = &evnt.DMD13X + &evnt.FMD13X;
   PV13X = &evnt.DPV13X + &evnt.FPV13X;
   VA13X = &evnt.DVA13X + &evnt.FVA13X;
   OF13X = &evnt.DOF13X + &evnt.FOF13X;
   SL13X = &evnt.DSL13X + &evnt.FSL13X;
   WC13X = &evnt.DWC13X + &evnt.FWC13X;
   OR13X = &evnt.DOR13X + &evnt.FOR13X;
   OU13X = &evnt.DOU13X + &evnt.FOU13X;
   OT13X = &evnt.DOT13X + &evnt.FOT13X;
   XP13X = &evnt.DXP13X + &evnt.FXP13X;

   if year <= 1999 then TR13X = &evnt.DCH13X + &evnt.FCH13X;
   else TR13X = &evnt.DTR13X + &evnt.FTR13X;
  %end;

  %else %do;
  ARRAY OLDVARS2(2) &evnt.CH13X SEEDOC ;
   SF13X = &evnt.SF13X;
   MR13X = &evnt.MR13X;
   MD13X = &evnt.MD13X;
   PV13X = &evnt.PV13X;
   VA13X = &evnt.VA13X;
   OF13X = &evnt.OF13X;
   SL13X = &evnt.SL13X;
   WC13X = &evnt.WC13X;
   OR13X = &evnt.OR13X;
   OU13X = &evnt.OU13X;
   OT13X = &evnt.OT13X;
   XP13X = &evnt.XP13X;

   if year <= 1999 then TR13X = &evnt.CH13X;
   else TR13X = &evnt.TR13X;
  %end;

  PR13X = PV13X + TR13X;
  OZ13X = OF13X + SL13X + OT13X + OR13X + OU13X + WC13X + VA13X;

  keep DUPERSID LINKIDX EVNTIDX event SEEDOC XP13X SF13X PR13X MR13X MD13X OZ13X;
 run;
%mend;

%load_events(RX,h160a);
%load_events(DV,h160b);
%load_events(IP,h160d);
%load_events(ER,h160e);
%load_events(OP,h160f);
%load_events(OB,h160g);
%load_events(HH,h160h);

/* Define sub-levels for office-based, outpatient, and home health */
data OB; set OB;
 if SEEDOC = 1 then event_v2X = 'OBD';
 else if SEEDOC = 2 then event_v2X = 'OBO';
 else event_v2X = '';
run;

data OP; set OP;
 if SEEDOC = 1 then event_v2X = 'OPY';
 else if SEEDOC = 2 then event_v2X = 'OPZ';
 else event_v2X = '';
run;

/* Merge with FYC file */
data FYCsub; set MEPS;
 keep poverty DUPERSID PERWT13F VARSTR VARPSU;
run;

proc format;
 value CCCFMT
  -9 - -1                = [2.]
  1-9                    = 'Infectious diseases                                         '
  11-45                  = 'Cancer                                                      '
  46, 47                 = 'Non-malignant neoplasm                                      '
  48                     = 'Thyroid disease                                             '
  49,50                  = 'Diabetes mellitus                                           '
  51, 52, 54 - 58        = 'Other endocrine, nutritional & immune disorder              '
  53                     = 'Hyperlipidemia                                              '
  59                     = 'Anemia and other deficiencies                               '
  60-64                  = 'Hemorrhagic, coagulation, and disorders of White Blood cells'
  65-75, 650-670         = 'Mental disorders                                            '
  76-78                  = 'CNS infection                                               '
  79-81                  = 'Hereditary, degenerative and other nervous system disorders '
  82                     = 'Paralysis                                                   '
  84                     = 'Headache                                                    '
  83                     = 'Epilepsy and convulsions                                    '
  85                     = 'Coma, brain damage                                          '
  86                     = 'Cataract                                                    '
  88                     = 'Glaucoma                                                    '
  87, 89-91              = 'Other eye disorders                                         '
  92                     = 'Otitis media                                                '
  93-95                  = 'Other CNS disorders                                         '
  98,99                  = 'Hypertension                                                '
  96, 97, 100-108        = 'Heart disease                                               '
  109-113                = 'Cerebrovascular disease                                     '
  114 -121               = 'Other circulatory conditions arteries, veins, and lymphatics'
  122                    = 'Pneumonia                                                   '
  123                    = 'Influenza                                                   '
  124                    = 'Tonsillitis                                                 '
  125 , 126              = 'Acute Bronchitis and URI                                    '
  127-134                = 'COPD, asthma                                                '
  135                    = 'Intestinal infection                                        '
  136                    = 'Disorders of teeth and jaws                                 '
  137                    = 'Disorders of mouth and esophagus                            '
  138-141                = 'Disorders of the upper GI                                   '
  142                    = 'Appendicitis                                                '
  143                    = 'Hernias                                                     '
  144- 148               = 'Other stomach and intestinal disorders                      '
  153-155                = 'Other GI                                                    '
  149-152                = 'Gallbladder, pancreatic, and liver disease                  '
  156-158, 160, 161      = 'Kidney Disease                                              '
  159                    = 'Urinary tract infections                                    '
  162,163                = 'Other urinary                                               '
  164-166                = 'Male genital disorders                                      '
  167                    = 'Non-malignant breast disease                                '
  168-176                = 'Female genital disorders, and contraception                 '
  177-195                = 'Complications of pregnancy and birth                        '
  196, 218               = 'Normal birth/live born                                      '
  197-200                = 'Skin disorders                                              '
  201-204                = 'Osteoarthritis and other non-traumatic joint disorders      '
  205                    = 'Back problems                                               '
  206-209, 212           = 'Other bone and musculoskeletal disease                     '
  210-211                = 'Systemic lupus and connective tissues disorders             '
  213-217                = 'Congenital anomalies                                        '
  219-224                = 'Perinatal Conditions                                        '
  225-236, 239, 240, 244 = 'Trauma-related disorders                                    '
  237, 238               = 'Complications of surgery or device                          '
  241 - 243              = 'Poisoning by medical and non-medical substances             '
  259                    = 'Residual Codes                                              '
  10, 254-258            = 'Other care and screening                                    '
  245-252                = 'Symptoms                                                    '
  253                    = 'Allergic reactions                                          '
  OTHER                  = 'Other                                                       '
  ;
run;


data RX;
 set RX;
 EVNTIDX = LINKIDX;
run;

/* Sum RX purchases for each event */
proc sort data = RX; by event DUPERSID EVNTIDX; run;
proc means data = RX noprint;
 by event DUPERSID EVNTIDX;
 var SF13X MR13X MD13X XP13X PR13X OZ13X;
 output out = RXpers sum = ;
run;

data stacked_events;
 set RXpers IP ER OP OB HH;
 where XP13X >= 0;
 count = 1;
 ind = 1;
run;

/* Read in event-condition linking file */
FILENAME h160if1 "C:\MEPS\h160if1.ssp";
proc xcopy in = h160if1 out = WORK IMPORT; run;
data clink1;
 set &syslast;
 keep DUPERSID CONDIDX EVNTIDX;
run;

FILENAME h162 "C:\MEPS\h162.ssp";
proc xcopy in = h162 out = WORK IMPORT; run;
data Conditions;
 set &syslast;
 keep DUPERSID CONDIDX CCCODEX condition;
 CCS_code = CCCODEX*1;
 condition = PUT(CCS_code, CCCFMT.);
run;

proc sort data = clink1; by DUPERSID CONDIDX; run;
proc sort data = conditions; by DUPERSID CONDIDX; run;
data cond;
 merge clink1 conditions;
 by DUPERSID CONDIDX;
run;

proc sort data = cond nodupkey; by DUPERSID EVNTIDX condition; run;
proc sort data = stacked_events; by DUPERSID EVNTIDX; run;
data event_cond;
 merge stacked_events cond;
 by DUPERSID EVNTIDX;
 if condition in ("-1","-9","") or XP13X < 0 then delete;
run;

proc sort data = FYCsub; by DUPERSID; run;
data all_events;
 merge event_cond FYCsub;
 by DUPERSID;
 count = 1;
 ind = 1;
run;

proc sort data = all_events;
 by poverty DUPERSID VARSTR VARPSU PERWT13F Condition ind count;
run;

proc means data = all_events noprint;
 by poverty DUPERSID VARSTR VARPSU PERWT13F Condition ind count;
 var SF13X MR13X MD13X XP13X PR13X OZ13X;
 output out = all_pers sum = ;
run;

ods output Domain = out;
proc surveymeans data = all_pers mean ;
 FORMAT poverty poverty.;
 stratum VARSTR;
 cluster VARPSU;
 weight PERWT13F;
 var XP13X;
 domain Condition*poverty ;
run;
