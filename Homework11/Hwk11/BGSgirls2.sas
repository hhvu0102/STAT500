
/* Program to analyze the Berkeley Guidance Study 
   growth data for girls, Question 2 of homework 10  */

data set1;
infile '\\tsclient\D\Coursework\Stat 500 Fall 2020\Homework11\Hwk11\BGSgirls2.txt';
input id wt2 ht2 wt9 ht9 lg9 st9 wt18 ht18 lg18 st18 bmi soma;
run;

ods rtf  file="BGSgirls.rtf"; 
ods graphics on;

proc print data=set1; run;

*part (a);

proc reg data=set1 plots=diagnostics; 
  model bmi = ht2 ht9 wt2 wt9 st9 /  p clm cli clb;
  output out=set3 p=yhat r=residual student=stdres stdp=stdp;
  run;

proc univariate data=set3 normal;
  var residual;
  qqplot;
  run;

proc reg data=set1;
  model bmi = ht2 ht9 wt2 wt9 st9 / ss1 ss2 vif partial;
  output out=set1 r=resid p=yhat;
  run;


*part (b);
  proc sort data=set3; by residual;  run; *sort by residual to get the largest residual point, which is an outlier;


  proc reg data=set1 plots=diagnostics; 
  where id NE 134;
  model bmi = ht2 ht9 wt2 wt9 st9 /  p clm cli clb;
  output out=set2 p=yhat r=residual student=stdres stdp=stdp;
  run;


  proc reg data=set1;
  where id NE 134;
  model bmi = ht2 ht9 wt2 wt9 st9 / ss1 ss2 vif partial;
  output out=set1 r=resid p=yhat;
  run;

  proc univariate data=set2 normal;
  var residual;
  qqplot;
  run;


*part (c);
  proc reg data=set1 plots=(none);
  where id NE 134;
  model bmi = ht2 ht9 wt2 wt9 st9 / selection= backward
          cp aic sbc sls=.05; 
  run;

 *part (d);
  proc reg data=set1;
  where id NE 134;
  model bmi = ht2 ht9 wt2 wt9 st9 / selection=rsquare aic sbc cp;
  run;

 *part (e);
  proc reg data=set1 plots=diagnostics;
  where id NE 134;
  model bmi = ht2 wt2 wt9 st9 / p clm cli clb;
  output out=set4 p=yhat r=residual student=stdres stdp=stdp;
  run;

  proc univariate data=set4 normal;
  var residual;
  qqplot;
  run;

proc reg data=set1 plots=diagnostics;
  where id NE 134;
  model bmi = ht2 wt2 wt9 st9 / ss1 ss2 vif partial;
  output out=set1 r=resid p=yhat;
  run;

*the codes from this point down were of Homework 10, not HW11;
  * parts (a) and (b);
proc corr data=set1; 
  var bmi ht2 ht9 wt2 wt9 st9;  run;

/* Part (c): Regress bmi on st9 */

proc reg data=set1;
  model bmi = st9 ;
 run;

/* part (d) */
/* Regress bmi on wt9 */

proc reg data=set1;
  model bmi = wt9 ;
  output out=set1 r=rbmiwt9 p=pbmiwt9;
  run;

/* Regress  st9 on wt9 */ 

proc reg data=set1;
  model st9 = wt9 ;
  output out=set1 r=rst9wt9 p=pst9wt9;
  run;

/*  Plot the residuals from the regression of 
    bmi on wt9  on the residuals from the regression
    of st9 on wt9.  This is a partial residual plot
    thatt displays the relationship between BMI at 
    age 18  and strength at age 9 conditioning on 
    (partialling out or adjusting for) weight at age 9. */

  title h=2 "Partial Residual Plot";
  title2 h=1.8 "Adjusting for Weight at Age 9";
proc sgplot data=set1;
  scatter x=rst9wt9 y=rbmiwt9 /
     markerattrs=(size=12 symbol=CircleFilled color=black);
  yaxis label="Residuals from BMI on WT9"
           labelattrs=(size=17) valueattrs=(size=15);
  xaxis label="Residuals from ST9 on WT9"
           labelattrs=(size=17) valueattrs=(size=15);
  run;


/*  Regress the residual from the regression of 
    bmi on wt9  on the residuals from the regression
    of st9 on wt9  */

 title h=2 " ";
  title2 h=1 " ";
proc reg data=set1;
  model rbmiwt9 = rst9wt9 ;
  run;

proc reg data=set1;
  model bmi = wt9 st9;
  output out=set1 r=resid p=yhat;
  run;

ods graphics off;
ods rtf close;
