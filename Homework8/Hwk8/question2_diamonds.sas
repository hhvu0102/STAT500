
data set1;
  	infile '\\tsclient\D\Coursework\Stat 500 Fall 2020\Homework8\Hwk8\diamonds.csv' dlm=',' firstobs=2; 
  	input weight price;
  run;


/*  Print the data using specified column headings */

proc sort data=set1; by weight;

title h=2 "Diamond Data";
proc print data=set1 uniform split='*';
  var weight price;
  run;

/* Plot the data */

title h=2 "Diamonds Data";
proc sgplot data=set1;
  scatter x=weight y=price /
     markerattrs=(size=12 symbol=CircleFilled color=black);
  yaxis label="Price ($)"
           labelattrs=(size=17) valueattrs=(size=15);
  xaxis label="Weight (g)"
           labelattrs=(size=17) valueattrs=(size=15);
  run;



/*  Compute least squares estimates of regression coefficients
    and output the residuals and predicted values to a file
    that can be used used by other SAS procedures.  */

proc reg data=set1 ; *plots=diagnostics(unpack);
  model price = weight /  p clm cli;
  output out=set2 p=yhat r=residual student=stdres stdp=stdp;
  run;




/* Plot the fitted line with the observed data  */

title h=2 'Regression Line for the Diamond Data';
proc sgplot data=set1;
  scatter x=weight y=price /
     markerattrs=(size=12 symbol=CircleFilled color=black);
  reg x=weight y=price;
  yaxis label="Price ($)"
           labelattrs=(size=14) valueattrs=(size=13);
  xaxis label="Weight (gram)"
           labelattrs=(size=14) valueattrs=(size=13);
  run;


 /*  Add columns to the data file corresponding to
     Scheffe bounds for a 95% simultaneous confidence
     region for the true regression line.  */

 data set2; set set2;
   upper = yhat + sqrt(2*finv(.95,2,44))*stdp;
   lower = yhat - sqrt(2*finv(.95,2,44))*stdp;
   *if(y = .) then delete;
   run;

title h=2 'Scheffe Confidence Bounds';
proc sgplot data=set2;
  reg x=weight y=price / lineattrs=(color=black pattern=1 thickness=1.5) nomarkers nolegfit;
  loess x=weight y=lower / lineattrs=(color=red pattern=4 thickness=1.5) nomarkers nolegfit ;
  loess x=weight y=upper / lineattrs=(color=red pattern=4 thickness=1.5)  nomarkers nolegfit;
  yaxis label="Price ($)"
           labelattrs=(size=14) valueattrs=(size=13);
  xaxis label="Weight (gram)"
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

proc means data=set1;
  var weight price; 
  output out=means mean=mean;  run;

ods graphics off;
   ods rtf close;
