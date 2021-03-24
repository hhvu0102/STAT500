
/* This code is posted as donuts.sas */

/*  Input the data for the doughnut experiment on pages 218-219
    in Snedecor and Cochran.  The outcome for each
    each batch of donuts is on a separate line.   */

data donut;
	input oil y;
	label y = (oil absorbed -150) grams;
	datalines;
	1 14
	1 22
	1 18
	1 27
	1 6
	1 45
	2 28
	2 41
	2 47
	2 32
	2 35
	2 27
	3 25
	3 43
	3 28
	3 21
	3 13
	3 26
	4 5
	4 16
	4 -1
	4 14
	4 20
	4 18
run;


proc print data=donut;
  title " ";  run;

/* Make dot plot of the responses */

ods pdf  file="donuts.pdf";

title "Donut Oil Absorption";
proc sgplot data=donut;
  scatter x=oil y=y / markerattrs=(size=15 symbol=heart color=black);
  yaxis label="Oil Absorbed - 150 grams" values=(-5 to 50 by 5)
           labelattrs=(size=15) valueattrs=(size=15);
  xaxis label="Type of Oil"  labelattrs=(size=20)
               values=(1 to 4 by 1)  valueattrs=(size=15)
               offsetmin=0.10 offsetmax=0.10;
run;


/*  Run the MEANS procedure in SAS to compute sample
    means and variances for each type  */

proc sort data=donut; by oil;

proc means data=donut n mean std var stderr min max;
  by oil;
  var y;
run;


/*  Run the GLM procedure in SAS to compute the ANOVA table
     compute overall ANOVA table and nothing more */
proc glm data=donut;
  class oil;
  model y = oil;
run;


proc glm data=donut plots=(diagnostics residuals)
plots=boxplot;
/* To obtain individual residual plots, replace
plots=(diagnostics residuals)
with plots(unpack)=residuals */
	class oil;
	model y = oil / p solution xpx inverse ;
	means oil /hovtest=bf;
	lsmeans oil / stderr cl pdiff plots=none;
	output out=set2 residual=r predicted=yhat;
run;

/* Use the GLM procedure to investigate contrasts
and multiple comparison procedures */
proc glm data=donut;
	class oil;
	model y = oil;

	estimate 'o4-(o1+o2+o3)/3' oil -1 -1 -1 3/divisor=3;
	estimate 'o2-(o1+o3)/2' oil -0.5 1 -0.5 0;
	estimate 'o1-o3' oil 1 0 -1 0 ;

	contrast 'o4-(o1+o2+o3)/3' oil -1 -1 -1 3 ;
	contrast 'o2-(o1+o3)/2' oil -0.5 1 -0.5 0;
	contrast 'o1-o3' oil 1 0 -1 0 ;
	means oil /alpha=.05 bon lsd scheffe tukey;
run;

title "Plot Residuals vs. Oils";
proc sgplot data=set2;
	scatter x=oil y=r / markerattrs=(size=15 symbol=diamond color=black);
	yaxis label="Residuals" values=(-20 to 25 by 5)
	labelattrs=(size=17) valueattrs=(size=15);
	xaxis label="Type of Oil" labelattrs=(size=17)
	values=(1 to 4 by 1) valueattrs=(size=15)
	offsetmin=0.10 offsetmax=0.10;
run;

/* Compute diagnostic checks of the model using residuals */
proc univariate data=set2 normal;
	var r;
	qqplot r / normal(mu=est sigma=est) square;
run;

title 'Kruskal-Wallis test';
proc npar1way data=donut wilcoxon;
	class oil;
	var y;
	exact wilcoxon / mc n=50000;
run;

ods pdf close;
