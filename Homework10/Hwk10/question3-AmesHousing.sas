
/* Program to analyze the Berkeley Guidance Study 
   growth data for girls, Question 2 of homework 10  */

data set1;
infile '\\tsclient\D\Coursework\Stat 500 Fall 2020\Homework10\Hwk10\AmesHousing.csv' dlm=',' firstobs=2;
input YearBuilt BasementArea LivingArea TotalRoom GarageCars YrSold SalePrice GarageSize Age;
run;

*ods rtf  file="BGSgirls.rtf"; 
*ods graphics on;

proc print data=set1; run;

* crrelation;
*proc corr data=set1; 
*  var bmi ht2 ht9 wt2 wt9 st9;  *run;

/* Part (a): Regress SalePrice on LivingArea and Age */

proc reg data=set1; *plots=diagnostics;
  model SalePrice = LivingArea Age / p clm cli clb;
  *output out=set2 p=yhat r=residual student=stdres stdp=stdp;
 run;

 proc reg data=set1; *plots=diagnostics;
  model SalePrice = LivingArea Age BasementArea TotalRoom / p clm cli clb;
  *output out=set2 p=yhat r=residual student=stdres stdp=stdp;
 run;


ods graphics off;
ods rtf close;
