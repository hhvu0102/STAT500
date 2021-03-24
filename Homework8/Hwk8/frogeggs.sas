/* problem 1 on Homework 8 */

data set1;
  input filter species block y1-y4 ;
  array y(i) y1-y4;
  do over y;
    hatchrate = y; output;
  end;
  keep filter species block hatchrate;
  datalines;
 1 1 1  6.0  4.7  0.7  5.2
 1 2 1 38.7 44.0 30.0 38.7
 1 3 1 42.0 50.7 32.7 44.0
 2 1 1  0.9  6.7  2.7  0.7
 2 2 1 28.7 32.7 36.0 40.7
 2 3 1 47.3 22.0 37.3 43.3
 3 1 1  4.7  0.7  4.7  0.7
 3 2 1 25.3 18.7 21.3 16.7
 3 3 1 18.7 17.3 16.0  4.7
 1 1 2  1.5  0.8  2.9  3.9
 1 2 2 36.7 69.6 39.3 34.0
 1 3 2 54.0 54.7 48.0 36.7
 2 1 2  0.7  2.1  0.0  1.4
 2 2 2 70.0 54.0 48.7 51.3
 2 3 2 46.0 46.7 36.0 35.3
 3 1 2  4.5  0.0  0.0  0.0
 3 2 2 24.7 25.3 39.3 32.7
 3 3 2 12.7 17.3 31.3 17.3
 run;


/* Print the data */

proc print data=set1;
   var filter species block hatchrate;
   run;

/* Compute an ANOVA table */
/* notice that although we treat blocks as random,
   the code is for fixed blocks that provide
   diagnostic plots etc. easier */

proc glm data = set1 plots = diagnostics;
	class filter species block;
	model hatchrate = filter species filter*species block / solution p clm clparm;
	random block;
  lsmeans species;
  output out=setr r=resid p=yhat;

run;

  *** (c);
/* Profile plot of the treatment means*/
proc sort data=set1; 
  by filter species block; run;
proc means data=set1;
  by filter species;
  var hatchrate; 
  output out=means mean=mean;  run;
proc sgplot data=means;
  series x=species y=mean / group=filter
     markerattrs=(size=12 symbol=CircleFilled color=black);
  yaxis label="hatchrate" 
           labelattrs=(size=17) valueattrs=(size=15);
  xaxis label="species"
           labelattrs=(size=17) valueattrs=(size=15); run;

proc sgplot data=setr;
  scatter x=yhat y=resid /   
     markerattrs=(size=12 symbol=CircleFilled color=black);
  yaxis label="Residuals"  
           labelattrs=(size=17) valueattrs=(size=15);
  xaxis label="Estimated Means" 
           labelattrs=(size=17) valueattrs=(size=15);
  run;

proc univariate data=setr normal;
   var resid;
   qqplot / normal;
  run;


data set2;
	set set1;
	sqrt_hatched = hatchrate**(1/2); * square root transformation to stabilize variance;
	log_hatched = log(hatchrate);
run;

title'square root transformation';
proc glm data = set2 plots = diagnostics;
	class filter species block;
	model sqrt_hatched = filter species filter*species block / solution p clm clparm;
run;

title'log transformation';
proc glm data = set2 plots = diagnostics;
	class filter species block;
	model log_hatched = filter species filter*species block / solution p clm clparm;
run;
