isPivot = false; initCols = [
      { title: "Year",   className: "sub", "visible": false},
      { title: "rowGrp", className: "sub", "visible": false},
      { title: "rowLevels" , className: "main"},
      { title: "rowLevNum" , className: "sub", "visible": false},
      { title: "selected",   className: "sub", "visible" : false},
    
      {title: "", className: "coef", searchable: false, render: coefDisplay},

      {title: "", className: "se", searchable: false, render: seDisplay},

      {title: "", className: "coef", searchable: false, render: coefDisplay},

      {title: "", className: "se", searchable: false, render: seDisplay},

      {title: "", className: "coef", searchable: false, render: coefDisplay},

      {title: "", className: "se", searchable: false, render: seDisplay},

      {title: "", className: "coef", searchable: false, render: coefDisplay},

      {title: "", className: "se", searchable: false, render: seDisplay},

      {title: "", className: "coef", searchable: false, render: coefDisplay},

      {title: "", className: "se", searchable: false, render: seDisplay},

      {title: "", className: "coef", searchable: false, render: coefDisplay},

      {title: "", className: "se", searchable: false, render: seDisplay},

      {title: "", className: "coef", searchable: false, render: coefDisplay},

      {title: "", className: "se", searchable: false, render: seDisplay},

      {title: "", className: "coef", searchable: false, render: coefDisplay},

      {title: "", className: "se", searchable: false, render: seDisplay},

      {title: "", className: "coef", searchable: false, render: coefDisplay},

      {title: "", className: "se", searchable: false, render: seDisplay},

      {title: "", className: "coef", searchable: false, render: coefDisplay},

      {title: "", className: "se", searchable: false, render: seDisplay},

      {title: "", className: "coef", searchable: false, render: coefDisplay},

      {title: "", className: "se", searchable: false, render: seDisplay},

      {title: "", className: "coef", searchable: false, render: coefDisplay},

      {title: "", className: "se", searchable: false, render: seDisplay},

      {title: "", className: "coef", searchable: false, render: coefDisplay},

      {title: "", className: "se", searchable: false, render: seDisplay},

      {title: "", className: "coef", searchable: false, render: coefDisplay},

      {title: "", className: "se", searchable: false, render: seDisplay},

      {title: "", className: "coef", searchable: false, render: coefDisplay},

      {title: "", className: "se", searchable: false, render: seDisplay},

      {title: "", className: "coef", searchable: false, render: coefDisplay},

      {title: "", className: "se", searchable: false, render: seDisplay},

      {title: "", className: "coef", searchable: false, render: coefDisplay},

      {title: "", className: "se", searchable: false, render: seDisplay},

      {title: "", className: "coef", searchable: false, render: coefDisplay},

      {title: "", className: "se", searchable: false, render: seDisplay},

      {title: "", className: "coef", searchable: false, render: coefDisplay},

      {title: "", className: "se", searchable: false, render: seDisplay},

      {title: "", className: "coef", searchable: false, render: coefDisplay},

      {title: "", className: "se", searchable: false, render: seDisplay},

      {title: "", className: "coef", searchable: false, render: coefDisplay},

      {title: "", className: "se", searchable: false, render: seDisplay},

      {title: "", className: "coef", searchable: false, render: coefDisplay},

      {title: "", className: "se", searchable: false, render: seDisplay},

      {title: "", className: "coef", searchable: false, render: coefDisplay},

      {title: "", className: "se", searchable: false, render: seDisplay},

      {title: "", className: "coef", searchable: false, render: coefDisplay},

      {title: "", className: "se", searchable: false, render: seDisplay},

      {title: "", className: "coef", searchable: false, render: coefDisplay},

      {title: "", className: "se", searchable: false, render: seDisplay},

      {title: "", className: "coef", searchable: false, render: coefDisplay},

      {title: "", className: "se", searchable: false, render: seDisplay},

      {title: "", className: "coef", searchable: false, render: coefDisplay},

      {title: "", className: "se", searchable: false, render: seDisplay},

      {title: "", className: "coef", searchable: false, render: coefDisplay},

      {title: "", className: "se", searchable: false, render: seDisplay},

      {title: "", className: "coef", searchable: false, render: coefDisplay},

      {title: "", className: "se", searchable: false, render: seDisplay},

      {title: "", className: "coef", searchable: false, render: coefDisplay},

      {title: "", className: "se", searchable: false, render: seDisplay},

      {title: "", className: "coef", searchable: false, render: coefDisplay},

      {title: "", className: "se", searchable: false, render: seDisplay}]; initLevels = {"education":{"educationB":"Less than high school","educationC":"High school","educationD":"Some college","educationE":"Inapplicable (age < 18)"},"employed":{"employedB":"Employed","employedC":"Not employed","employedD":"Inapplicable (age < 16)"},"married":{"marriedB":"Inapplicable (age < 16)","marriedC":"Married","marriedD":"Widowed","marriedE":"Divorced","marriedF":"Separated","marriedG":"Never married"},"event":{"eventB":"Dental visits","eventC":"Prescription medicines","eventD":"Office-based events","eventG":"Outpatient events","eventJ":"Emergency room visits","eventK":"Inpatient stays","eventL":"Home health events","eventM":"Other medical equipment and services"},"health":{"healthB":"Excellent","healthC":"Very good","healthD":"Good","healthE":"Fair","healthF":"Poor"},"mnhlth":{"mnhlthB":"Excellent","mnhlthC":"Very good","mnhlthD":"Good","mnhlthE":"Fair","mnhlthF":"Poor"},"insurance":{"insuranceB":"Any private, all ages","insuranceC":"Public only, all ages","insuranceD":"Uninsured, all ages"},"poverty":{"povertyB":"Negative or poor","povertyC":"Near-poor","povertyD":"Low income","povertyE":"Middle income","povertyF":"High income"},"race":{"raceB":"Hispanic","raceC":"Black","raceD":"White and other","raceE":"White","raceF":"Amer. Indian, AK Native, or mult. races","raceG":"Asian, Hawaiian, or Pacific Islander"},"region":{"regionB":"Northeast","regionC":"Midwest","regionD":"South","regionE":"West"},"sex":{"sexB":"Male","sexC":"Female"},"sop":{"sopB":"Out of pocket","sopC":"Private","sopD":"Medicare","sopE":"Medicaid","sopF":"Other"},"agegrps":{"agegrpsB":"Under 18","agegrpsE":"18-64","agegrpsH":"65+"}}; subLevels = ["Physician office visits","Non-physician office visits","Physician hosp. visits","Non-physician hosp. visits"]; adjustStat = {totPOP: 'in thousands', totEXP: 'in millions', totEVT: 'in millions', meanEVT: '', meanEXP: '', meanEXP0: '', medEXP: '', pctEXP: '', pctPOP: '', avgEVT: ''};
