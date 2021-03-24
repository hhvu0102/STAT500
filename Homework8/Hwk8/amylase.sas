
/* Problem 3 (optional) of homework 8 */


data set1;
  input species protein moisture germination kilntemp yield;
  s=(species-1.5)*2;
  p=(protein-1.5)*2;
  m=(moisture-1.5)*2;
  g=(germination-1.5)*2;
  k=(kilntemp-1.5)*2;
  sp=s*p; sm=s*m; sg=s*g; sk=s*k;
  pm=p*m; pg=p*g; pk=p*k; mg=m*g;
  mk=m*k; gk=g*k;  spm=sp*m; spg=sp*g;
  spk=sp*k; smg=sm*g; smk=sm*k; sgk=sg*k;
  pmg=pm*g; pmk=pm*k; pkg=pk*g; mgk=mg*k;
  spmg=sp*mg; spmk=sp*mk; spgk=sp*gk; 
  smgk=sm*gk; pmgk=pm*gk;  spmgk=spm*gk;  
  datalines;
 1 1 1 1 1 732
 2 1 1 1 1 801
 1 2 1 1 1 717
 2 2 1 1 1 791
 1 1 2 1 1 616
 2 1 2 1 1 787
 1 2 2 1 1 540
 2 2 2 1 1 669
 1 1 1 2 1 200
 2 1 1 2 1  50
 1 2 1 2 1 292
 2 2 1 2 1  74
 1 1 2 2 1  62
 2 1 2 2 1  83
 1 2 2 2 1  97
 2 2 2 2 1  -9
 1 1 1 1 2 744
 2 1 1 1 2 732
 1 2 1 1 2 713
 2 2 1 1 2 746
 1 1 2 1 2 569
 2 1 2 1 2 785
 1 2 2 1 2 486
 2 2 2 1 2 544
 1 1 1 2 2 253
 2 1 1 2 2  91
 1 2 1 2 2 265
 2 2 1 2 2 147
 1 1 2 2 2  80
 2 1 2 2 2  80
 1 2 2 2 2 102
 2 2 2 2 2 -40
 run;


/* Print the data */

proc print data=set1; run;

/* Compute an ANOVA table */

proc glm data=set1 plots=(diagnostics);
  class species protein moisture germination kilntemp;
  model yield = species|protein|moisture|germination|kilntemp /
             solution p clm alpha=.05;
  run;

/*  Compute estimates of uncorrelated contrasts thta have
    the same variance   */

proc glm data=set1; 
  model yield = s p m g k sp sm sg sk pm pg pk mg
  mk gk  spm spg spk smg smk sgk
  pmg pmk pkg mgk spmg spmk spgk 
  smgk pmgk  spmgk;  
    ods output ParameterEstimates=Parms;
	run;



/*  Print the file containing the estimated
    coefficients         */

proc print data=parms; run;

data parms; set parms;
  if(Parameter="Intercept") then delete;
  run;


/* Create a normal probablity plot  */

proc univariate data=parms normal;
  var estimate;  id Parameter;
  qqplot;   run;


proc rank data=parms out=parms normal=blom;
  var estimate; ranks q; run;
  
proc sgplot data=parms;
  scatter x=q y=estimate /
     markerattrs=(size=10 symbol=CircleFilled color=black)
	 datalabel=Parameter  datalabelattrs=(family=Ariel size=8)
	 datalabelpos=bottomright;
  yaxis label="Ordered Contrast Estimates"
           labelattrs=(size=14) valueattrs=(size=12);
  xaxis label="Standard Normal Quantiles"
           labelattrs=(size=14) valueattrs=(size=12);
  title h=1.5 "Normal q-q Plot of Contrast Estimates";
  run;

/*  Fit a model containing only the main effects
    and the significant interactions identified
    in the normal probability plot.            */


proc glm data=set1;
  class species protein moisture germination kilntemp;
  model yield = species protein moisture germination kilntemp
                species*germination protein*germination 
                germination*kilntemp species*protein 
                species*moisture protein*moisture 
                species*protein*moisture  ;
  lsmeans species*germination / pdiff plots=meanplot;
  lsmeans protein*germination / pdiff plots=meanplot;
  lsmeans germination*kilntemp / pdiff plots=meanplot;
  lsmeans protein*moisture / pdiff plots=meanplot;
  lsmeans species*protein*moisture / pdiff plots=meanplot;
  lsmeans species*protein / pdiff plots=meanplot;
  lsmeans species*moisture / pdiff plots=meanplot;
  output out=set2 residual=r p=yhat;
  ods output LSMeans=lsmeans;
  run;

proc print data=lsmeans;  run;

data lsm; set lsmeans;
  if(effect = "species_germination"); 
  if(germination='1') then germ=3; else germ=5; run;

  proc print data=lsm;  run;
 
proc sgplot data=lsm;
  scatter x=germ y=LSMean /
     markerattrs=(size=10 symbol=CircleFilled color=black)
	 datalabel=species  datalabelattrs=(family=Ariel size=10)
	 datalabelpos=bottomright;
  reg x=germ y=LSMean / group=species;
  yaxis label="Mean Yield"
           labelattrs=(size=14) valueattrs=(size=12);
  title h=1.5 "Profile Plot";
  run;

  
data lsm; set lsmeans;
  if(effect = "protein_germination"); 
  if(germination='1') then germ=3; else germ=5; run;

  proc print data=lsm;  run;
 
proc sgplot data=lsm;
  scatter x=germ y=LSMean /
     markerattrs=(size=10 symbol=CircleFilled color=black)
	 datalabel=protein  datalabelattrs=(family=Ariel size=10)
	 datalabelpos=bottomright;
  reg x=germ y=LSMean / group=protein;
  yaxis label="Mean Yield"
           labelattrs=(size=14) valueattrs=(size=12);
  title h=1.5 "Profile Plot";
  run;

 
data lsm; set lsmeans;
  if(effect = "germination_kilntemp"); 
  if(germination='1') then germ=3; else germ=5; 
  if(kilntemp='1') then ktemp=100; else ktemp=130;
  run;

  proc print data=lsm;  run;
 
proc sgplot data=lsm;
  scatter x=germ y=LSMean /
     markerattrs=(size=10 symbol=CircleFilled color=black)
	 datalabel=kilntemp  datalabelattrs=(family=Ariel size=10)
	 datalabelpos=bottomright;
  reg x=germ y=LSMean / group=kilntemp;
  yaxis label="Mean Yield"
           labelattrs=(size=14) valueattrs=(size=12);
  title h=1.5 "Profile Plot";
  run;


data lsm; set lsmeans;
  if(effect = "specie_protei_moistu"); 
  if(moisture='1') then moist=40; else moist=44;
  run;

  proc sort data=lsm; by species; run;

  proc print data=lsm;  run;
 
proc sgplot data=lsm;  by species;
  scatter x=moist y=LSMean /
     markerattrs=(size=10 symbol=CircleFilled color=black)
	 datalabel=protein  datalabelattrs=(family=Ariel size=10)
	 datalabelpos=bottomright;
  reg x=moist y=LSMean / group=protein;
  yaxis label="Mean Yield"
           labelattrs=(size=14) valueattrs=(size=12);
  title h=1.5 "Profile Plot";
  run;



proc univariate data=set2 normal;
  qqplot;
  var r;
  run;


/* Make some residual plots */

proc sgplot data=set2;
  scatter x=yhat y=r /   
     markerattrs=(size=12 symbol=CircleFilled color=black);
  yaxis label="Residuals"  
           labelattrs=(size=17) valueattrs=(size=15);
  xaxis label="Estimated Means" 
           labelattrs=(size=17) valueattrs=(size=15);
  run;

