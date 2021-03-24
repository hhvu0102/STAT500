
/*  This is a program for analyzing the penicillin 
    production data from Box, Hunter, and Hunter.  
    It is posted in the SAS code folder as
              penicillin.sas          */

/*  First enter the data  */

data set1;
  infile 'penicillin.dat';
  input batch process $ yield;
  run;

* ods pdf  file="penicillin.pdf"; 
/* Print the data  */
  
  title "Analysis of Penicillin Production Data";
  proc print data=set1;
  run;

/* Construct a scatter plot of the process yields  */

title h=2 "Analysis of Penicillin Production Data";
proc sgplot data=set1;
  scatter x=process y=yield /  
     markerattrs=(size=12 symbol=CircleFilled color=black);
  yaxis label="Yield" values=(75 to 100 by 5) 
           labelattrs=(size=20) valueattrs=(size=15);
  xaxis label="Production Process" 
           labelattrs=(size=20) valueattrs=(size=15);
  run;

title h=2 "Analysis of Penicillin Production Data";
proc sgplot data=set1;
  scatter x=batch y=yield /   
     markerattrs=(size=12 symbol=CircleFilled color=black);
  yaxis label="Yield" values=(75 to 100 by 5) 
           labelattrs=(size=20) valueattrs=(size=15);
  xaxis label="Batch" 
           labelattrs=(size=20) valueattrs=(size=15);
  run;


 /* Using PROC GLM
   Compute the ANOVA table, formulas for
   expectations of mean squares, process
   means and their standard errors */
  
proc glm data=set1;* plots=(diagnostics) plots=meanplot(cl);
  class batch process;
  model yield = batch process;
  random batch ; *if batch is treated as fixed effect, don't include this random statement;

  lsmeans process / stderr pdiff adjust=tukey;
  * means process / tukey;

  estimate 'A-B' process 1 -1 0 0 ;
  estimate 'C-(A+B)/2' process -0.5 -0.5 1 0;
  estimate 'D-(A+B+C)/3' process -1 -1 -1 3 / divisor=3;

  contrast 'A-B' process 1 -1 0 0 ;
  contrast 'C-(A+B)/2' process -0.5 -0.5 1 0;
  contrast 'D-(A+B+C)/3' process -1 -1 -1 3;

  output out=set2 r=residual p=yhat;

  title 'Results using PROC GLM';
  run;

/* Compute Shapiro-Wilk test for normality  */

proc univariate data=set2 normal;
  var residual;
  qqplot / normal;
  run;


/* Plot residuals verses treatments */

proc sgplot data=set2;
  scatter x=process y=residual /   
     markerattrs=(size=12 symbol=CircleFilled color=black);
  yaxis label="Residuals" 
           labelattrs=(size=20) valueattrs=(size=15);
  xaxis label="Production Process" 
           labelattrs=(size=20) valueattrs=(size=15);
  run;



 /* Using PROC MIXED
   Compute the ANOVA table, formulas for
   expectations of mean squares, process
   means and their standard errors */

proc mixed data=set1 method = type3;
  class batch process;
  model yield =  process /outp = resids2;
  random batch;
 
  lsmeans process / adjust=tukey;

  estimate 'A-B' process 1 -1 0 0 ;
  estimate 'C-(A+B)/2' process -0.5 -0.5 1 0;
  estimate 'D-(A+B+C)/3' process -1 -1 -1 3 / divisor=3;

  contrast 'A-B' process 1 -1 0 0 ;
  contrast 'C-(A+B)/2' process -0.5 -0.5 1 0;
  contrast 'D-(A+B+C)/3' process -1 -1 -1 3;

  title 'Random blocks using PROC MIXED';
run;

*   ods pdf close;
