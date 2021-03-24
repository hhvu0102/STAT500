
/*  This code analyzes the BGD girls data  */

data set1;
  infile '\\tsclient\D\Coursework\Stat 500 Fall 2020\Homework9\Hwk9\BGSgirls.dat';
  input id weight height;
  if weight > 90 then remove = 1; else remove = 0;
  * if(weight > 90) then weight=.;  
  run;

ods rtf  file="BGSgirls.rtf";
  ods graphics on;

/*  Print the data using specified column headings */

proc sort data=set1; by height;  run;

proc print data=set1 uniform split='*';
  var weight height;
  TITLE 'BGS Girls Data at Age 18';
  run;

/* Plot the data */

proc sgplot data=set1;
  scatter x=height y=weight /
     markerattrs=(size=12 symbol=CircleFilled color=black);
  yaxis label="Weight(kg)"
           labelattrs=(size=17) valueattrs=(size=15);
  xaxis label="height (cm)"
           labelattrs=(size=17) valueattrs=(size=15);
  run;


/*  Compute least squares estimates of regression coefficients
    and output the residuals and predicted values to a file
    that can be used used by other SAS procedures.  */

proc reg data=set1 ;
  model weight= height /  p clm cli;
  output out=set2 p=yhat r=residual student=stdres rstudent=rstud stdp=stdp;
  run;


/* Plot the fitted line with the observed data  */

title h=2 'Regression Line for BGS Girls Data';
proc sgplot data=set1;
  scatter x=height y=weight /
     markerattrs=(size=12 symbol=CircleFilled color=black);
  reg x=height y=weight;
  yaxis label="Weight (kg)"
           labelattrs=(size=14) valueattrs=(size=13);
  xaxis label="Height (cm)"
           labelattrs=(size=14) valueattrs=(size=13);
  run;


/*  Plot residuals against the explantory variable to check
    for homogeneity of variance and patterns in the residuals
    that would suggest that the model is inadequate  */

title h=2 'Internally Studentized Residuals vs Estimated Means';
proc sgplot data=set2;
  scatter x=height y=stdres /
     markerattrs=(size=12 symbol=CircleFilled color=black);
  refline 0 / axis=y;
  yaxis label="Residuals"
           labelattrs=(size=14) valueattrs=(size=13);
  xaxis label="Height (cm)"
           labelattrs=(size=14) valueattrs=(size=13);
  run;

title h=2 'Externally Studentized Residuals vs Estimated Means';
proc sgplot data=set2;
  scatter x=height y=rstud /
     markerattrs=(size=12 symbol=CircleFilled color=black);
  refline 0 / axis=y;
  yaxis label="Residuals"
           labelattrs=(size=14) valueattrs=(size=13);
  xaxis label="Height (cm)"
           labelattrs=(size=14) valueattrs=(size=13);
  run;

proc reg data = set1;
	where weight le 90; *only use the observations <= 90kg;
	model weight = height /  clm cli clb;
	output out = set2 p = yhat r = residual student = stdres stdp = stdp;
run;
* plot both fitted lines;
proc format;
	value removeF 0 = '> 90 kg Removed';
run;
title h = 2 'Regression Line for BGS Girls Data: Both Models';
proc sgplot data = set1;
	scatter x = height y = weight / markerattrs=(size=8 symbol=CircleFilled color=black);
	reg x = height y = weight / lineattrs=(color=red pattern=dash) legendlabel='All' name="all";
	reg x = height y = weight / group = remove name="subset";
	yaxis label = 'Weight (kg)' labelattrs=(size=14) valueattrs=(size=13);
	xaxis label = 'Height (cm)' labelattrs=(size=14) valueattrs=(size=13);
	keylegend "all" / position=bottom;
	keylegend "subset" / position=bottom across=1;
	format remove removeF.;
run;
data set1; set set1;
  height2=height*height; run;

proc reg data=set1 ;
  where weight le 90; *only use the observations <= 90kg;
  model weight= height height2/  p clm cli;
  output out=set2 p=yhat r=residual student=stdres stdp=stdp;
  run;

ods graphics off;
   ods rtf close;
