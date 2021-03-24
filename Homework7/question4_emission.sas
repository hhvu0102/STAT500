data emissions;
  infile '\\tsclient\D\Coursework\Stat 500 Fall 2020\Homework7\emissions.txt' firstobs=2;
  input ethanol airFuel CO;
  run;

/* compute two-way ANOVA table and nothing more 
The resulting ANOVA table including both one-way and two-way
as on slides 18 and 28 of lecture notes 10_FactorialExperiments_part1*/
proc glm data=emissions; *plots=(diagnostics);
  class ethanol airFuel;
  model CO =  ethanol airFuel ethanol*airFuel;
run;

/* the following proc has almost everything you might need */
/*   in a data analysis */

* ods rtf  file="protein.rtf"; 
 
proc glm data=emissions ; */plots=(diagnostics);
  class ethanol airFuel;
  model CO =  ethanol airFuel ethanol*airFuel /
             solution p clm clparm alpha=.05;
    /* compute overall ANOVA table and estimate&CI for parameters and cell means */

  lsmeans ethanol airFuel /stderr pdiff adjust = tukey;
 * lsmeans  copper*zinc / stderr pdiff adjust = tukey;
 * means copper zinc /tukey;
    /* marginal means for each gender and type, and cell means */
    /*   with all pairwise differences with Tukey adj. for mcp */

 * estimate 'copper diff.' copper 1 -1;
 * contrast 'copper diff.' copper 1 -1;
    /* estimates and contrasts between marginal means for gender */
  
  contrast 'Ethanol L3-L1' ethanol -1 0 1;
  contrast 'Ethanol L2-L1/2-L3/2' ethanol -0.5 1 -0.5;
    /* or for type of product */

  contrast 'Air/Fuel L3-L1' airFuel -1 0 1;
  contrast 'Air/Fuel L2-L1/2-L3/2' airFuel -0.5 1 -0.5;
            
  * lsmeans copper*zinc /slice = copper ;
    /* tests of equality between zinc in each copper levels */

   output out = setr r = resid p = yhat;
run;


*ods rtf close;

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
  scatter x=ethanol y=resid /   
     markerattrs=(size=12 symbol=CircleFilled color=black);
  yaxis label="Residuals"  
           labelattrs=(size=17) valueattrs=(size=15);
  xaxis label="Ethanol" 
           labelattrs=(size=17) valueattrs=(size=15);
  run;

proc sgplot data=setr;
  scatter x=airFuel y=resid /   
     markerattrs=(size=12 symbol=CircleFilled color=black);
  yaxis label="Residuals"  
           labelattrs=(size=17) valueattrs=(size=15);
  xaxis label="Air/Fuel" 
           labelattrs=(size=17) valueattrs=(size=15);
  run; 

proc univariate data=setr normal;
  var resid;
  qqplot / normal;
  run;


  










