
/*  This code analyzes the multiple linear regression model for predicting the price at auction of a grandfather clock
    from the age of the clock and the number of bidders at auction. */

data set1;
  infile 'clocks.csv' dlm = ',' firstobs = 2;
  input age numbid price;
  agexnumbid=age*numbid;
  cagexcnumbid=(age-144.9375)*(numbid-9.53125);
run;
  
/* Make a scatterplot of price by age and price by number of bidders */

title h=2 "Scatterplot of Age by Price";
proc sgplot data=set1;
  scatter x=age y=price /
     markerattrs=(size=12 symbol=CircleFilled color=black);
  xaxis label="Age (in years)"
           labelattrs=(size=17) valueattrs=(size=15);
  yaxis label="Price"
           labelattrs=(size=17) valueattrs=(size=15);
  run;

title h=2 "Scatterplot of Number of Bidders by Price";
proc sgplot data=set1;
  scatter x=numbid y=price /
     markerattrs=(size=12 symbol=CircleFilled color=black);
  xaxis label="Number of Bidders"
           labelattrs=(size=17) valueattrs=(size=15);
  yaxis label="Price"
           labelattrs=(size=17) valueattrs=(size=15);
  run;
  
/* compute the SLR with price and age */

proc reg data=set1 plots=diagnostics corr;
	model price = age / p clm cli clb;
	output out=set2 p=yhat r=residual student=stdres stdp=stdp;
run;

/* compute the SLR with price and number of bidders */

proc reg data=set1 plots=diagnostics corr;
	model price = numbid / p clm cli clb;
	output out=set3 p=yhat r=residual student=stdres stdp=stdp;
run;

/* compute the MLR with price and age and number of bidders */

proc reg data=set1 corr ; * plots=diagnostics ;
  model price = age numbid; */  p clm cli clb;
  output out=set4 p=yhat r=residual student=stdres stdp=stdp;
  run;

/* compute the MLR with price and age, number of bidders, and their interaction */

proc reg data=set1 plots=diagnostics corr; 
  model price = age numbid agexnumbid /  p clm cli clb;
  output out=set5 p=yhat r=residual student=stdres stdp=stdp;
  run;

/* compute the MLR with price and age, number of bidders, and their (centered) interaction */
proc reg data=set1 plots=diagnostics corr; 
  model price = age numbid cagexcnumbid /  p clm cli clb;
  output out=set5 p=yhat r=residual student=stdres stdp=stdp;
  run;

