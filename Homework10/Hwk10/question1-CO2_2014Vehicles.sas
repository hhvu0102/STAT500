/*  SAS code to analyze CO2 data from random sample of 2014 
	Vehicles.  */

data set1;
 infile '\\tsclient\D\Coursework\Stat 500 Fall 2020\Homework10\Hwk10\CO2_2014Vehicles.csv' dlm=',' firstobs=1;
 input engine cylinder cityMPG gears intake exhaust cityCO2;
 ccylinderxcintake=(cylinder-5.825)*(intake-0.93);
 run;

  ods rtf file="CO2_2014.rtf";
ods graphics on;

/* Calculate mean of the original data file  */

proc means data=set1;
run;
title 'CO2 Analysis';

data set1;
 infile '\\tsclient\D\Coursework\Stat 500 Fall 2020\Homework10\Hwk10\CO2_2014Vehicles.csv' dlm=',' firstobs=1;
 input engine cylinder cityMPG gears intake exhaust cityCO2;
 *ccylinderxcintake=(cylinder-5.825)*(intake-0.93);
 cylinderxintake=cylinder*intake;
 run;


/* Compute correlations  */

proc corr data=set1;
  var engine cylinder cityMPG gears cityCO2; run;

/* constuct a matrix of scatter plots */

proc sgscatter data=set1;
  matrix engine cylinder cityMPG gears intake exhaust cityCO2/ diagonal=(histogram)
      markerattrs=(size=10 symbol=CircleFilled color=black);
  run;


/*  Compute least squares estimates of regression coefficients
    and output the residuals and predicted values to a file
    that can be used used by other SAS procedures.  */

proc reg data=set1 plots=diagnostics corr; 
  model cityCO2 = engine cylinder cityMPG gears intake cylinderxintake /  p clm cli clb;
  output out=set2 p=yhat r=residual student=stdres stdp=stdp;
  run;


  /* without interaction; */
*proc reg data=set1 plots=(diagnostics partial);
*model cityCO2 = engine cylinder cityMPG gears intake;
*output out=set4 p=yhat r=residual;


proc univariate data=set2 normal;
  var residual;
  qqplot;
run;

proc univariate data=set3 normal;
  var residual;
  qqplot;
run;

proc univariate data=set4 normal;
  var residual;
  qqplot;
run;


ods graphics off;
ods rtf close;
