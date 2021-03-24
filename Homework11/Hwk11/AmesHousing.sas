
data set1;
infile '\\tsclient\D\Coursework\Stat 500 Fall 2020\Homework11\Hwk11\TrainingSet.csv' dlm=',' firstobs=2;
input YearBuilt BasementArea LivingArea TotalRoom GarageCars YrSold SalePrice GarageSize $ Age;
if GarageSize="L" then GarageSize2=1; else GarageSize2=0;
run;


proc print data=set1; run;

 proc reg data=set1; *plots=diagnostics;
  model SalePrice = LivingArea Age BasementArea TotalRoom GarageSize2 / p clm cli clb;
  output out=set2 p=yhat r=residual student=stdres stdp=stdp;
 run;

 proc reg data=set1 plots=(none);
  model SalePrice = LivingArea Age BasementArea TotalRoom GarageSize2 / selection= stepwise
          cp aic sbc sle=.05 sls=.05; 
 run;

 proc reg data=set1 plots=(none);
  model SalePrice = LivingArea Age BasementArea TotalRoom GarageSize2 / selection=rsquare aic sbc cp;
 run;

 proc reg data=set1; *plots=diagnostics;
  model SalePrice = LivingArea Age BasementArea TotalRoom / p clm cli clb;
  output out=set2 p=yhat r=residual student=stdres stdp=stdp;
 run;

data set3;
infile '\\tsclient\D\Coursework\Stat 500 Fall 2020\Homework11\Hwk11\EvaluationSet.csv' dlm=',' firstobs=2;
input YearBuilt BasementArea LivingArea TotalRoom GarageCars YrSold SalePrice GarageSize $ Age;
if GarageSize="L" then GarageSize2=1; else GarageSize2=0;
run;

proc reg data=set3; *plots=diagnostics;
  model SalePrice = LivingArea Age BasementArea TotalRoom / p clm cli clb;
  output out=set4 p=yhat r=residual student=stdres stdp=stdp;
 run;
