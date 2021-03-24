
/*  This code analyzes the Forbes data to illustrate
    the use of PROC REG in SAS to obtain least squares
    estimates for a simple linear regression model. It
    is posted as forbes.sas on the course web page */

data set1;
  input x p;
  y = log(p);
  label x = Boiling Point (deg. F)
        p = Atm. Pressure (in. Hg)
        y = Log(Atm. pressure);
  datalines;
194.5 20.79
194.3 20.79
197.9 22.40
198.4 22.67
199.4 23.15
199.9 23.35
200.9 23.89
201.1 23.99
201.4 24.02
201.3 24.01
203.6 25.14
204.6 26.57
209.5 28.49
208.6 27.76
210.7 29.04
211.9 29.88
212.2 30.06
  run;

ods rtf  file="forbes.rtf";
  ods graphics on;

/*  Print the data using specified column headings */

proc sort data=set1; by x;

title h=2 "Forbes Data";
proc print data=set1 uniform split='*';
  var x p y;
  LABEL x = 'Boiling Point*of Water*(degrees F)'
        p = 'Atmospheric*Pressure*(inches Hg)'
        y = 'Natural Log of*Atmospheric*Pressure';
  TITLE 'Forbes Data';
  run;

/* Plot the data */

title h=2 "Forbes Data";
proc sgplot data=set1;
  scatter x=x y=y /
     markerattrs=(size=12 symbol=CircleFilled color=black);
  yaxis label="Boiling Point of Water (degrees F)"
           labelattrs=(size=17) valueattrs=(size=15);
  xaxis label="Natural Logarithm of Atmoshperic Pressure"
           labelattrs=(size=17) valueattrs=(size=15);
  run;



/*  Compute least squares estimates of regression coefficients
    and output the residuals and predicted values to a file
    that can be used used by other SAS procedures.  */

proc reg data=set1 ; *plots=diagnostics(unpack);
  model y = x /  p clm cli;
  output out=set2 p=yhat r=residual student=stdres stdp=stdp;
  run;




/* Plot the fitted line with the observed data  */

title h=2 'Regression Line for the Forbes Data';
proc sgplot data=set1;
  scatter x=x y=y /
     markerattrs=(size=12 symbol=CircleFilled color=black);
  reg x=x y=y;
  yaxis label="Boiling Point of Water (degrees F)"
           labelattrs=(size=14) valueattrs=(size=13);
  xaxis label="Natural Logarithm of Atmoshperic Pressure"
           labelattrs=(size=14) valueattrs=(size=13);
  run;


 /*  Add columns to the data file corresponding to
     Scheffe bounds for a 95% simultaneous confidence
     region for the true regression line.  */

 data set2; set set2;
   upper = yhat + sqrt(2*finv(.95,2,15))*stdp;
   lower = yhat - sqrt(2*finv(.95,2,15))*stdp;
   if(y = .) then delete;
   run;

title h=2 'Scheffe Confidence Bounds';
proc sgplot data=set2;
  reg x=x y=y / lineattrs=(color=black pattern=1 thickness=1.5) nomarkers nolegfit;
  loess x=x y=lower / lineattrs=(color=red pattern=4 thickness=1.5) nomarkers nolegfit ;
  loess x=x y=upper / lineattrs=(color=red pattern=4 thickness=1.5)  nomarkers nolegfit;
  yaxis label="Boiling Point of Water (degrees F)"
           labelattrs=(size=14) valueattrs=(size=13);
  xaxis label="Natural Logarithm of Atmoshperic Pressure"
           labelattrs=(size=14) valueattrs=(size=13);
  run;


/*  Plot residuals against the explantory variable to check
    for homogeneity of variance and patterns in the residuals
    that would suggest that the model is inadequate  */

title h=2 'Residuals vs Estimated Means';
proc sgplot data=set2;
  scatter x=x y=residual /
     markerattrs=(size=12 symbol=CircleFilled color=black);
  refline 0 / axis=y;
  yaxis label="Boiling Point of Water (degrees F)"
           labelattrs=(size=14) valueattrs=(size=13);
  xaxis label="Natural Logarithm of Atmoshperic Pressure"
           labelattrs=(size=14) valueattrs=(size=13);
  run;



/*  Compute normal probability plot for residuals */

title " ";
proc univariate data=set2 normal;
  var residual;
  qqplot;
  run;



ods graphics off;
   ods rtf close;
