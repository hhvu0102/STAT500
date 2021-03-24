
/*  This code analyzes the multiple linear regression model for predicting the ideal height of a romantic
	partner from a person's height and gender. */

data set1;
  infile 'heights.csv' dlm = ',' firstobs = 2;
  input ideal height Gender $;
  if Gender="Female" then Gender10=1; *define indicator variable;
  else Gender10=0;
  Interaction=height*Gender10;
  run;


/* Make a scatterplot of height by ideal. */

title h=2 "Scatterplot of Height by Ideal Height of Romantic Partner";
proc sgplot data=set1;
  scatter x=height y=ideal /
     markerattrs=(size=12 symbol=CircleFilled color=black);
  xaxis label="Height (in)"
           labelattrs=(size=17) valueattrs=(size=15);
  yaxis label="Height of Ideal Romantic Partner (in)"
           labelattrs=(size=17) valueattrs=(size=15);
  run;

/*  SLR for height and ideal */

proc reg data=set1 plots=diagnostics; 
  model ideal = height ;*/  p clm cli clb;
  *output out=set2 p=yhat r=residual student=stdres stdp=stdp;
  run;

title h=2 "Regression Line for Predicting Height of Ideal Romantic Partner from Height";
proc sgplot data=set1;
  scatter x=height y=ideal /
     markerattrs=(size=12 symbol=CircleFilled color=black);
  reg x=height y=ideal;
  xaxis label="Height (in)"
           labelattrs=(size=17) valueattrs=(size=15);
  yaxis label="Height of Ideal Romantic Partner (in)"
           labelattrs=(size=17) valueattrs=(size=15);
  run;

/* MLR model with Height and Gender */

  proc reg data=set1 plots=diagnostics; 
  model ideal = height Gender10 /  p clm cli clb;
  output out=set3 p=yhat r=residual student=stdres stdp=stdp;
  run;

  title h=2 "Regression Lines for Predicting Height of Ideal Romantic Partner from Height and Gender";
proc sgplot data=set1;
  scatter x=height y=ideal /
     markerattrs=(size=12 symbol=CircleFilled color=black);
  lineparm x=0 y=27.664 slope=0.547 / clip curvelabel="Male" curvelabelloc=outside lineattrs=(color="green");
  lineparm x=0 y=36.651 slope=0.547 / clip curvelabel="Female" curvelabelloc=outside lineattrs=(color="red");
  xaxis label="Height (in)"
           labelattrs=(size=17) valueattrs=(size=15);
  yaxis label="Height of Ideal Romantic Partner (in)"
           labelattrs=(size=17) valueattrs=(size=15);
  run;

/* MLR model with Height, Gender, and their Interaction */

  proc reg data=set1 plots=diagnostics alpha = 0.05; 
  model ideal = height Gender10 Interaction/  p clm cli clb;
  output out=set4 p=yhat r=residual student=stdres stdp=stdp;
  run;

  title h=2 "Regression Lines for Predicting Height of Ideal Romantic Partner from Height, Gender, and their Interaction";
proc sgplot data=set1;
  scatter x=height y=ideal /
     markerattrs=(size=12 symbol=CircleFilled color=black);
  lineparm x=0 y=42.724 slope=0.455 / clip curvelabel="Female" curvelabelloc=outside lineattrs=(color="red");
  lineparm x=0 y=15.452 slope=0.717 / clip curvelabel="Male" curvelabelloc=outside lineattrs=(color="green");
  xaxis label="Height (in)"
           labelattrs=(size=17) valueattrs=(size=15);
  yaxis label="Height of Ideal Romantic Partner (in)"
           labelattrs=(size=17) valueattrs=(size=15);
  run;

