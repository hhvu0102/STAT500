data protein;
  infile 'protein.txt' firstobs=2;
  input trt copper zinc  protein;
  run;

/* compute two-way ANOVA table and nothing more 
The resulting ANOVA table including both one-way and two-way
as on slides 18 and 28 of lecture notes 10_FactorialExperiments_part1*/
proc glm data=protein; *plots=(diagnostics);
  class copper zinc;
  model protein =  copper zinc copper*zinc;
run;

/* the following proc has almost everything you might need */
/*   in a data analysis */

ods rtf  file="protein.rtf"; 
 
proc glm data=protein ; */plots=(diagnostics);
  class copper zinc;
  model protein =  copper zinc copper*zinc/
             solution p clm clparm alpha=.05;
    /* compute overall ANOVA table and estimate&CI for parameters and cell means */

  lsmeans copper zinc /stderr pdiff adjust = tukey;
  lsmeans  copper*zinc / stderr pdiff adjust = tukey;
  means copper zinc /tukey;
    /* marginal means for each gender and type, and cell means */
    /*   with all pairwise differences with Tukey adj. for mcp */

  estimate 'copper diff.' copper 1 -1;
  contrast 'copper diff.' copper 1 -1;
    /* estimates and contrasts between marginal means for gender */
  
  estimate 'Zinc L1-L2' zinc 1 -1 0;
  estimate 'Zinc L1/2-L3' zinc 0.5 0.5 -1;
    /* or for type of product */

  contrast 'Zinc L1-L2 and L1/2-L3' zinc 1 -1 0,
                           zinc 0.5 0.5 -1;
                           
  contrast 'Zinc L1-L2 and L2-L3'   zinc 1 -1 0,
                           zinc 0 1 -1;
                           
  contrast 'ZInc L1-L2, L2-L3, and L1-L3' zinc 1 -1 0,
										zinc 0 1 -1,
                               			zinc 1 0 -1;
                                                                 
  lsmeans copper*zinc /slice = copper ;
    /* tests of equality between zinc in each copper levels */

   output out = setr r = resid p = yhat;
run;


ods rtf close;

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
  scatter x=trt y=resid /   
     markerattrs=(size=12 symbol=CircleFilled color=black);
  yaxis label="Residuals"  
           labelattrs=(size=17) valueattrs=(size=15);
  xaxis label="treatment" 
           labelattrs=(size=17) valueattrs=(size=15);
  run;
                     
/* the following illustrates how to use 1-way ANOVA and contrasts */
/*   to get almost everything done in the first proc glm */
   
proc glm data = protein;
 class trt;
 model protein = trt;
 estimate 'copper effect' trt 1 1 1 -1 -1 -1 /divisor = 3;
 estimate 'zinc L1-L2' trt 1 -1 0 1 -1 0 /divisor = 2;
 estimate 'Zinc L12-L3' trt 0.5 -0.25 -0.25 0.5 -0.25 -0.25;
 
 contrast 'copper SS' trt 1 1 1 -1 -1 -1;
 contrast 'zinc SS' trt 1 -1 0 1 -1 0 , 
                    trt 1 1 -2 1 1 -2;
                    
 contrast 'copper*zinc SS' trt 1 -1   0 -1 1 0,
                        trt 1 1 -2 -1 -1 2;
  
  estimate 'Zinc L2-L3 in Copper L2' trt 0 0 0 0 1 -1;
    /* estimate of simple effect: L-S in males */
  estimate 'Copper L2-L1 in Zinc L1' trt -1 0 0 1 0 0;
    /* simple effect of gender in control type */

  contrast 'Copper L2-L1 in Zinc L1' trt -1 0 0 1 0 0;
  
  contrast 'Zinc effect in Copper L1' trt 1 -1 0 0 0 0,
									trt 1 1 -2 0 0 0;

  contrast 'Zinc effect in Copper L2' trt 0 0 0 1 -1 0,
                       trt 0 0 0 1 1 -2;
                       
run;
                              

/* another way to get the 1-way ANOVA without creating a trt number */
proc glm data=protein;
  class copper zinc;
  model protein = copper*zinc;
  lsmeans copper*zinc;           /* so you get the order */
  
  estimate 'Zinc L2-L3 in Copper L2' copper*zinc 0 0 0 0 1 -1;
run;
     
/* comparison of long and short approaches to estimates */
proc glm;
  class copper zinc;
  model protein =  copper zinc copper*zinc;
  
  estimate 'short form, copper L1-L2' copper 1 -1;
  estimate 'long form, copper L1-L2' 
     copper 3 -3 copper*zinc 1 1 1 -1 -1 -1 /divisor = 3;
  estimate 'Zinc L2-L3 in Copper L1' zinc 0 1 -1 copper*zinc 0 1 -1 0 0 0;
run;
          

  










