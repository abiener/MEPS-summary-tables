ods graphics off;

/* Read in dataset and initialize year */

FILENAME h178a "C:\MEPS\h178a.ssp";
proc xcopy in = h178a out = WORK IMPORT;
run;

data RX;
 set &syslast; 
 ARRAY OLDVAR(3) VARPSU15 VARSTR15 WTDPER15;
 year = 2015;
 count = 1;

 if year <= 2001 then do;
  VARPSU = VARPSU15;
  VARSTR = VARSTR15;
 end;

 if year <= 1998 then do;
  PERWT15F = WTDPER15;
 end;

 domain = (RXNDC ne "-9");
run;

proc format;

value TC1name
-9 ='not ascertained                                        '
-1 ='inapplicable                                           '
 1 ='anti-infectives                                        '
 2 ='amebicides                                             '
 3 ='anthelmintics                                          '
 4 ='antifungals                                            '
 5 ='antimalarial agents                                    '
 6 ='antituberculosis agents                                '
 7 ='antiviral agents                                       '
 8 ='carbapenems                                            '
 9 ='cephalosporins                                         '
10 ='leprostatics                                           '
11 ='macrolide derivatives                                  '
12 ='miscellaneous antibiotics                              '
13 ='penicillins                                            '
14 ='quinolones                                             '
15 ='sulfonamides                                           '
16 ='tetracyclines                                          '
17 ='urinary anti-infectives                                '
18 ='aminoglycosides                                        '
19 ='antihyperlipidemic agents                              '
20 ='antineoplastics                                        '
21 ='alkylating agents                                      '
22 ='antineoplastic antibiotics                             '
23 ='antimetabolites                                        '
24 ='antineoplastic hormones                                '
25 ='miscellaneous antineoplastics                          '
26 ='mitotic inhibitors                                     '
27 ='radiopharmaceuticals                                   '
28 ='biologicals                                            '
30 ='antitoxins and antivenins                              '
31 ='bacterial vaccines                                     '
32 ='colony stimulating factors                             '
33 ='immune globulins                                       '
34 ='in vivo diagnostic biologicals                         '
36 ='recombinant human erythropoietins                      '
37 ='toxoids                                                '
38 ='viral vaccines                                         '
39 ='miscellaneous biologicals                              '
40 ='cardiovascular agents                                  '
41 ='agents for hypertensive emergencies                    '
42 ='angiotensin converting enzyme inhibitors               '
43 ='antiadrenergic agents, peripherally acting             '
44 ='antiadrenergic agents, centrally acting                '
45 ='antianginal agents                                     '
46 ='antiarrhythmic agents                                  '
47 ='beta-adrenergic blocking agents                        '
48 ='calcium channel blocking agents                        '
49 ='diuretics                                              '
50 ='inotropic agents                                       '
51 ='miscellaneous cardiovascular agents                    '
52 ='peripheral vasodilators                                '
53 ='vasodilators                                           '
54 ='vasopressors                                           '
55 ='antihypertensive combinations                          '
56 ='angiotensin II inhibitors                              '
57 ='central nervous system agents                          '
58 ='analgesics                                             '
59 ='miscellaneous analgesics                               '
60 ='narcotic analgesics                                    '
61 ='nonsteroidal anti-inflammatory agents                  '
62 ='salicylates                                            '
63 ='analgesic combinations                                 '
64 ='anticonvulsants                                        '
65 ='antiemetic/antivertigo agents                          '
66 ='antiparkinson agents                                   '
67 ='anxiolytics, sedatives, and hypnotics                  '
68 ='barbiturates                                           '
69 ='benzodiazepines                                        '
70 ='miscellaneous anxiolytics, sedatives and hypnotics     '
71 ='CNS stimulants                                         '
72 ='general anesthetics                                    '
73 ='muscle relaxants                                       '
74 ='neuromuscular blocking agents                          '
76 ='miscellaneous antidepressants                          '
77 ='miscellaneous antipsychotic agents                     '
79 ='psychotherapeutic combinations                         '
80 ='miscellaneous central nervous system agents            '
81 ='coagulation modifiers                                  '
82 ='anticoagulants                                         '
83 ='antiplatelet agents                                    '
84 ='heparin antagonists                                    '
85 ='miscellaneous coagulation modifiers                    '
86 ='thrombolytics                                          '
87 ='gastrointestinal agents                                '
88 ='antacids                                               '
89 ='anticholinergics/antispasmodics                        '
90 ='antidiarrheals                                         '
91 ='digestive enzymes                                      '
92 ='gallstone solubilizing agents                          '
93 ='GI stimulants                                          '
94 ='H2 antagonists                                         '
95 ='laxatives                                              '
96 ='miscellaneous GI agents                                '
97 ='hormones/hormone modifiers                             '
98 ='adrenal cortical steroids                              '
99 ='antidiabetic agents                                    '
100 ='miscellaneous hormones                                 '
101 ='sex hormones                                           '
102 ='contraceptives                                         '
103 ='thyroid hormones                                       '
104 ='immunosuppressive agents                               '
105 ='miscellaneous agents                                   '
106 ='antidotes                                              '
107 ='chelating agents                                       '
108 ='cholinergic muscle stimulants                          '
109 ='local injectable anesthetics                           '
110 ='miscellaneous uncategorized agents                     '
111 ='psoralens                                              '
112 ='radiocontrast agents                                   '
113 ='genitourinary tract agents                             '
114 ='illicit (street) drugs                                 '
115 ='nutritional products                                   '
116 ='iron products                                          '
117 ='minerals and electrolytes                              '
118 ='oral nutritional supplements                           '
119 ='vitamins                                               '
120 ='vitamin and mineral combinations                       '
121 ='intravenous nutritional products                       '
122 ='respiratory agents                                     '
123 ='antihistamines                                         '
124 ='antitussives                                           '
125 ='bronchodilators                                        '
126 ='methylxanthines                                        '
127 ='decongestants                                          '
128 ='expectorants                                           '
129 ='miscellaneous respiratory agents                       '
130 ='respiratory inhalant products                          '
131 ='antiasthmatic combinations                             '
132 ='upper respiratory combinations                         '
133 ='topical agents                                         '
134 ='anorectal preparations                                 '
135 ='antiseptic and germicides                              '
136 ='dermatological agents                                  '
137 ='topical anti-infectives                                '
138 ='topical steroids                                       '
139 ='topical anesthetics                                    '
140 ='miscellaneous topical agents                           '
141 ='topical steroids with anti-infectives                  '
143 ='topical acne agents                                    '
144 ='topical antipsoriatics                                 '
146 ='mouth and throat products                              '
147 ='ophthalmic preparations                                '
148 ='otic preparations                                      '
149 ='spermicides                                            '
150 ='sterile irrigating solutions                           '
151 ='vaginal preparations                                   '
153 ='plasma expanders                                       '
154 ='loop diuretics                                         '
155 ='potassium-sparing diuretics                            '
156 ='thiazide diuretics                                     '
157 ='carbonic anhydrase inhibitors                          '
158 ='miscellaneous diuretics                                '
159 ='first generation cephalosporins                        '
160 ='second generation cephalosporins                       '
161 ='third generation cephalosporins                        '
162 ='fourth generation cephalosporins                       '
163 ='ophthalmic anti-infectives                             '
164 ='ophthalmic glaucoma agents                             '
165 ='ophthalmic steroids                                    '
166 ='ophthalmic steroids with anti-infectives               '
167 ='ophthalmic anti-inflammatory agents                    '
168 ='ophthalmic lubricants and irrigations                  '
169 ='miscellaneous ophthalmic agents                        '
170 ='otic anti-infectives                                   '
171 ='otic steroids with anti-infectives                     '
172 ='miscellaneous otic agents                              '
173 ='HMG-CoA reductase inhibitors                           '
174 ='miscellaneous antihyperlipidemic agents                '
175 ='protease inhibitors                                    '
176 ='NRTIs                                                  '
177 ='miscellaneous antivirals                               '
178 ='skeletal muscle relaxants                              '
179 ='skeletal muscle relaxant combinations                  '
180 ='adrenergic bronchodilators                             '
181 ='bronchodilator combinations                            '
182 ='androgens and anabolic steroids                        '
183 ='estrogens                                              '
184 ='gonadotropins                                          '
185 ='progestins                                             '
186 ='sex hormone combinations                               '
187 ='miscellaneous sex hormones                             '
191 ='narcotic analgesic combinations                        '
192 ='antirheumatics                                         '
193 ='antimigraine agents                                    '
194 ='antigout agents                                        '
195 ='5HT3 receptor antagonists                              '
196 ='phenothiazine antiemetics                              '
197 ='anticholinergic antiemetics                            '
198 ='miscellaneous antiemetics                              '
199 ='hydantoin anticonvulsants                              '
200 ='succinimide anticonvulsants                            '
201 ='barbiturate anticonvulsants                            '
202 ='oxazolidinedione anticonvulsants                       '
203 ='benzodiazepine anticonvulsants                         '
204 ='miscellaneous anticonvulsants                          '
205 ='anticholinergic antiparkinson agents                   '
206 ='miscellaneous antiparkinson agents                     '
208 ='SSRI antidepressants                                   '
209 ='tricyclic antidepressants                              '
210 ='phenothiazine antipsychotics                           '
211 ='platelet aggregation inhibitors                        '
212 ='glycoprotein platelet inhibitors                       '
213 ='sulfonylureas                                          '
214 ='biguanides                                             '
215 ='insulin                                                '
216 ='alpha-glucosidase inhibitors                           '
217 ='bisphosphonates                                        '
218 ='alternative medicines                                  '
219 ='nutraceutical products                                 '
220 ='herbal products                                        '
222 ='penicillinase resistant penicillins                    '
223 ='antipseudomonal penicillins                            '
224 ='aminopenicillins                                       '
225 ='beta-lactamase inhibitors                              '
226 ='natural penicillins                                    '
227 ='NNRTIs                                                 '
228 ='adamantane antivirals                                  '
229 ='purine nucleosides                                     '
230 ='aminosalicylates                                       '
231 ='nicotinic acid derivatives                             '
232 ='rifamycin derivatives                                  '
233 ='streptomyces derivatives                               '
234 ='miscellaneous antituberculosis agents                  '
235 ='polyenes                                               '
236 ='azole antifungals                                      '
237 ='miscellaneous antifungals                              '
238 ='antimalarial quinolines                                '
239 ='miscellaneous antimalarials                            '
240 ='lincomycin derivatives                                 '
241 ='fibric acid derivatives                                '
242 ='psychotherapeutic agents                               '
243 ='leukotriene modifiers                                  '
244 ='nasal lubricants and irrigations                       '
245 ='nasal steroids                                         '
246 ='nasal antihistamines and decongestants                 '
247 ='nasal preparations                                     '
248 ='topical emollients                                     '
249 ='antidepressants                                        '
250 ='monoamine oxidase inhibitors                           '
251 ='antipsychotics                                         '
252 ='bile acid sequestrants                                 '
253 ='anorexiants                                            '
254 ='immunologic agents                                     '
256 ='interferons                                            '
257 ='immunosuppressive monoclonal antibodies                '
261 ='heparins                                               '
262 ='coumarins and indandiones                              '
263 ='impotence agents                                       '
264 ='urinary antispasmodics                                 '
265 ='urinary pH modifiers                                   '
266 ='miscellaneous genitourinary tract agents               '
267 ='ophthalmic antihistamines and decongestants            '
268 ='vaginal anti-infectives                                '
269 ='miscellaneous vaginal agents                           '
270 ='antipsoriatics                                         '
271 ='thiazolidinediones                                     '
272 ='proton pump inhibitors                                 '
273 ='lung surfactants                                       '
274 ='cardioselective beta blockers                          '
275 ='non-cardioselective beta blockers                      '
276 ='dopaminergic antiparkinsonism agents                   '
277 ='5-aminosalicylates                                     '
278 ='cox-2 inhibitors                                       '
279 ='gonadotropin-releasing hormone and analogs             '
280 ='thioxanthenes                                          '
281 ='neuraminidase inhibitors                               '
282 ='meglitinides                                           '
283 ='thrombin inhibitors                                    '
284 ='viscosupplementation agents                            '
285 ='factor Xa inhibitors                                   '
286 ='mydriatics                                             '
287 ='ophthalmic anesthetics                                 '
288 ='5-alpha-reductase inhibitors                           '
289 ='antihyperuricemic agents                               '
290 ='topical antibiotics                                    '
291 ='topical antivirals                                     '
292 ='topical antifungals                                    '
293 ='glucose elevating agents                               '
295 ='growth hormones                                        '
296 ='inhaled corticosteroids                                '
297 ='mucolytics                                             '
298 ='mast cell stabilizers                                  '
299 ='anticholinergic bronchodilators                        '
300 ='corticotropin                                          '
301 ='glucocorticoids                                        '
302 ='mineralocorticoids                                     '
303 ='agents for pulmonary hypertension                      '
304 ='macrolides                                             '
305 ='ketolides                                              '
306 ='phenylpiperazine antidepressants                       '
307 ='tetracyclic antidepressants                            '
308 ='SSNRI antidepressants                                  '
309 ='miscellaneous antidiabetic agents                      '
310 ='echinocandins                                          '
311 ='dibenzazepine anticonvulsants                          '
312 ='cholinergic agonists                                   '
313 ='cholinesterase inhibitors                              '
314 ='antidiabetic combinations                              '
315 ='glycylcyclines                                         '
316 ='cholesterol absorption inhibitors                      '
317 ='antihyperlipidemic combinations                        '
318 ='insulin-like growth factor                             '
319 ='vasopressin antagonists                                '
320 ='smoking cessation agents                               '
321 ='ophthalmic diagnostic agents                           '
322 ='ophthalmic surgical agents                             '
323 ='antineoplastic monoclonal antibodies                   '
324 ='antineoplastic interferons                             '
325 ='sclerosing agents                                      '
327 ='antiviral combinations                                 '
328 ='antimalarial combinations                              '
329 ='antituberculosis combinations                          '
330 ='antiviral interferons                                  '
331 ='radiologic agents                                      '
332 ='radiologic adjuncts                                    '
333 ='miscellaneous iodinated contrast media                 '
334 ='lymphatic staining agents                              '
335 ='magnetic resonance imaging contrast media              '
336 ='non-iodinated contrast media                           '
337 ='ultrasound contrast media                              '
338 ='diagnostic radiopharmaceuticals                        '
339 ='therapeutic radiopharmaceuticals                       '
340 ='aldosterone receptor antagonists                       '
341 ='atypical antipsychotics                                '
342 ='renin inhibitors                                       '
343 ='tyrosine kinase inhibitors                             '
344 ='nasal anti-infectives                                  '
345 ='fatty acid derivative anticonvulsants                  '
346 ='gamma-aminobutyric acid reuptake inhibitors            '
347 ='gamma-aminobutyric acid analogs                        '
348 ='triazine anticonvulsants                               '
349 ='carbamate anticonvulsants                              '
350 ='pyrrolidine anticonvulsants                            '
351 ='carbonic anhydrase inhibitor anticonvulsants           '
352 ='urea anticonvulsants                                   '
353 ='anti-angiogenic ophthalmic agents                      '
354 ='H. pylori eradication agents                           '
355 ='functional bowel disorder agents                       '
356 ='serotoninergic neuroenteric modulators                 '
357 ='growth hormone receptor blockers                       '
358 ='metabolic agents                                       '
359 ='peripherally acting antiobesity agents                 '
360 ='lysosomal enzymes                                      '
361 ='miscellaneous metabolic agents                         '
362 ='chloride channel activators                            '
363 ='probiotics                                             '
364 ='antiviral chemokine receptor antagonist                '
365 ='medical gas                                            '
366 ='integrase strand transfer inhibitor                    '
368 ='non-ionic iodinated contrast media                     '
369 ='ionic iodinated contrast media                         '
370 ='otic steroids                                          '
371 ='dipeptidyl peptidase 4 inhibitors                      '
372 ='amylin analogs                                         '
373 ='incretin mimetics                                      '
374 ='cardiac stressing agents                               '
375 ='peripheral opioid receptor antagonists                 '
376 ='radiologic conjugating agents                          '
377 ='prolactin inhibitors                                   '
378 ='drugs used in alcohol dependence                       '
379 ='next generation cephalosporins                         '
380 ='topical debriding agents                               '
381 ='topical depigmenting agents                            '
382 ='topical antihistamines                                 '
383 ='antineoplastic detoxifying agents                      '
384 ='platelet-stimulating agents                            '
385 ='group I antiarrhythmics                                '
386 ='group II antiarrhythmics                               '
387 ='group III antiarrhythmics                              '
388 ='group IV antiarrhythmics                               '
389 ='group V antiarrhythmics                                '
390 ='hematopoietic stem cell mobilizer                      '
391 ='mTOR kinase inhibitors                                 '
392 ='otic anesthetics                                       '
393 ='cerumenolytics                                         '
394 ='topical astringents                                    '
395 ='topical keratolytics                                   '
396 ='prostaglandin D2 antagonists                           '
397 ='multikinase inhibitors                                 '
398 ='BCR-ABL tyrosine kinase inhibitors                     '
399 ='CD52 monoclonal antibodies                             '
400 ='CD33 monoclonal antibodies                             '
401 ='CD20 monoclonal antibodies                             '
402 ='VEGF/VEGFR inhibitors                                  '
403 ='mTOR inhibitors                                        '
404 ='EGFR inhibitors                                        '
405 ='HER2 inhibitors                                        '
406 ='glycopeptide antibiotics                               '
407 ='inhaled anti-infectives                                '
408 ='histone deacetylase inhibitors                         '
409 ='bone resorption inhibitors                             '
410 ='adrenal corticosteroid inhibitors                      '
411 ='calcitonin                                             '
412 ='uterotonic agents                                      '
413 ='antigonadotropic agents                                '
414 ='antidiuretic hormones                                  '
415 ='miscellaneous bone resorption inhibitors               '
416 ='somatostatin and somatostatin analogs                  '
417 ='selective estrogen receptor modulators                 '
418 ='parathyroid hormone and analogs                        '
419 ='gonadotropin-releasing hormone antagonists             '
420 ='antiandrogens                                          '
422 ='antithyroid agents                                     '
423 ='aromatase inhibitors                                   '
424 ='estrogen receptor antagonists                          '
426 ='synthetic ovulation stimulants                         '
427 ='tocolytic agents                                       '
428 ='progesterone receptor modulators                       '
429 ='trifunctional monoclonal antibodies                    '
430 ='anticholinergic chronotropic agents                    '
431 ='anti-CTLA-4 monoclonal antibodies                      '
432 ='vaccine combinations                                   '
433 ='Catecholamines                                         '
435 ='selective phosphodiesterase-4 inhibitors               '
437 ='Immunostimulants                                       '
438 ='Interleukins                                           '
439 ='other immunostimulants                                 '
440 ='therapeutic vaccines                                   '
441 ='calcineurin inhibitors                                 '
442 ='TNF alfa inhibitors                                    '
443 ='interleukin inhibitors                                 '
444 ='selective immunosuppressants                           '
445 ='other immunosuppressants                               '
446 ='neuronal potassium channel openers                     '
447 ='CD30 monoclonal antibodies                             '
448 ='topical non-steroidal anti-inflammatories              '
449 ='hedgehog pathway inhibitors                            '
450 ='topical antineoplastics                                '
451 ='topical photochemotherapeutics                         '
452 ='CFTR potentiators                                      '
453 ='topical rubefacient                                    '
454 ='proteasome inhibitors                                  '
455 ='guanylate cyclase-c agonists                           '
456 ='ampa receptor antagonists                              '
457 ='hydrazide derivatives                                  '
458 ='sglt-2 inhibitors                                      '
459 ='urea cycle disorder agents                             '
460 ='phosphate binders                                      '
461 ='topical anti-rosacea agents                            '
462 ='allergenics                                            '
463 ='protease-activated receptor-1 antagonists              '
464 ='miscellaneous diagnostic dyes                          '
465 ='diarylquinolines                                       '
466 ='bone morphogenetic proteins                            '
467 ='ace inhibitors with thiazides                          '
468 ='antiadrenergic agents (central) with thiazides         '
469 ='antiadrenergic agents (peripheral) with thiazides      '
470 ='miscellaneous antihypertensive combinations            '
472 ='beta blockers with thiazides                           '
473 ='angiotensin II inhibitors with thiazides               '
474 ='beta blockers with calcium channel blockers            '
475 ='potassium sparing diuretics with thiazides             '
476 ='ace inhibitors with calcium channel blocking agents    '
479 ='angiotensin II inhibitors with calcium channel blockers'
480 ='antiviral boosters                                     '
481 ='NK1 receptor antagonists                               '
482 ='angiotensin receptor blockers and neprilysin inhibitors'
483 ='neprilysin inhibitors                                  '
484 ='PCSK9 inhibitors                                       '
485 ='NS5A inhibitors                                        '
486 ='oxazolidinone antibiotics                              '
487 ='cftr combinations                                      '
488 ='anticoagulant reversal agents                          '
489 ='CD38 monoclonal antibodies                             '
490 ='peripheral opioid receptor mixed agonists/antagonists  '
491 ='local injectable anesthetics with corticosteroids      '
;

run;
;

ods output Domain = out;
proc surveymeans data = RX sum ;
 format TC1 TC1name.;
 stratum VARSTR;
 cluster VARPSU;
 weight PERWT15F;
 var count;
 domain TC1;
run;

proc print data = out;
run;
