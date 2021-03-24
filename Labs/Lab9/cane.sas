
/* Analysis of completely randomized factorial
   experiments with an application to the sugar 
   cane data from Snedecor and Cochran.*/

data set1;
  input variety nitrogen yield;
  datalines;
 1 150 70.5
 1 150 67.5
 1 150 63.9
 1 150 64.2
 1 210 67.3
 1 210 75.9
 1 210 72.2
 1 210 60.5
 1 270 79.9
 1 270 72.8
 1 270 64.8
 1 270 86.3
 2 150 58.6
 2 150 65.2
 2 150 70.2
 2 150 51.8
 2 210 64.3
 2 210 48.3
 2 210 74.0
 2 210 63.6 
 2 270 64.4
 2 270 67.3
 2 270 78.0
 2 270 72.0
 3 150 65.8
 3 150 68.3
 3 150 72.7
 3 150 67.6
 3 210 64.1
 3 210 64.8
 3 210 70.9
 3 210 58.3
 3 270 56.3
 3 270 54.7
 3 270 66.2
 3 270 54.4
  run;
  
/* Print the data */

proc print data=set1;
   var variety nitrogen yield;
   run;

/* Compute an ANOVA table */

proc glm data=set1 plots=(diagnostics);
  class variety nitrogen;
  model yield = variety nitrogen variety*nitrogen /
             solution p clm clparm alpha=.05;
  output out=setr r=resid p=yhat;
  lsmeans variety*nitrogen / stderr pdiff;
  means variety nitrogen / tukey;
  contrast 'v1-v2' variety 1 -1 0;
  contrast '(v1+v2)-v3' variety .5 .5 -1;
  estimate 'v1-v2' variety 1 -1 0;
  estimate '(v1+v2)-v3' variety .5 .5 -1;
  contrast 'linear' nitrogen -1 0 1;
  contrast 'quadratic' nitrogen -1 2 -1;
  estimate 'linear' nitrogen -1 0 1;
  estimate 'quadratic' nitrogen -1 2 -1;
  run;

/* Make some residual plots */

proc sgplot data=setr;
  scatter x=yhat y=resid /   
     markerattrs=(size=12 symbol=CircleFilled color=black);
  yaxis label="Residuals"  
           labelattrs=(size=17) valueattrs=(size=15);
  xaxis label="Estimated Means" 
           labelattrs=(size=17) valueattrs=(size=15);
  run;

proc sgplot data=setr;
  scatter x=nitrogen y=resid /   
     markerattrs=(size=12 symbol=CircleFilled color=black);
  yaxis label="Residuals"  
           labelattrs=(size=17) valueattrs=(size=15);
  xaxis label="Nitrogen Level" 
           labelattrs=(size=17) valueattrs=(size=15);
  run;

proc sgplot data=setr;
  scatter x=variety y=resid /   
     markerattrs=(size=12 symbol=CircleFilled color=black);
  yaxis label="Residuals"  
           labelattrs=(size=17) valueattrs=(size=15);
  xaxis label="Varieties" 
           labelattrs=(size=17) valueattrs=(size=15);
  run;

/* Check the normality assumption */

proc univariate data=setr normal;
  var resid;  qqplot;  
  run;
