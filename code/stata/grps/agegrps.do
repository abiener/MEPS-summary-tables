/* Age groups */
/* To compute for all age groups, replace 'agegrps' in the SVY procedure with 'agegrps_v2X'  */

use MEPS.dta

egen agegrps = cut(agelast), at(0,5,18,45,65,90)
label define agegrps 0 "Under 5" 5 "5-17" 18 "18-44" 45 "45-64" 65 "65+", replace
label values agegrps agegrps

egen agegrps_v2X = cut(agelast), at(0,18,65,90)
label define agegrps_v2X 0 "Under 18" 18 "18-64" 65 "65+", replace
label values agegrps_v2X agegrps_v2X

egen agegrps_v3X = cut(agelast), at(0,5,7,13,18,19,25,30,35,45,55,65,90)
label define agegrps_v3X 0 "Under 5" 5 "5-6" 7 "7-12" 13 "13-17" 18 "18" 19 "19-24" 25 "25-29" 30 "30-34" 35 "35-44" 45 "45-54" 55 "55-64" 65 "65+", replace
label values agegrps_v3X agegrps_v3X
