options nodate formdlim = '-';

/* compute sample size for desired power, 2 sample t-test  */

proc power;         
  twosamplemeans   /* NOTE: this is all one command.  No ; until the end */
	meandiff=4     /*  specify difference in population means (delta) */
    alpha = 0.05   /*  default is 0.05, if so can omit */ 
    power=0.80     /*  specify power (between 0 and 1, not as percent) */
	stddev=5       /*  specify Sp  */
	npergroup=. ;  /*  solve for # per group (because this is missing) */
  run;

  /* compute sample sizes for a range of powers */
proc power;
  twosamplemeans   /* NOTE: this is all one command.  No ; until the end */
 	meandiff=4     /*  specify diff in population means (my delta) */
    power= 0.80 to 0.95 by 0.05       /*  solve for power */
	stddev=5       /*  specify sigma  */
	npergroup=. ; 
    run;   

/* compute and plot power for a range of sample sizes */
proc power;
  twosamplemeans   /* NOTE: this is all one command.  No ; until the end */
 	meandiff=4     /*  specify diff in population means (my delta) */
    power= .       /*  solve for power */
	stddev=5       /*  specify sigma  */
	npergroup= 10 to 100 by 5 ; 
          		   /* specify sample sizes, note ; to end command */
 plot x = n;       /* plot y = power vs x = sample size   */
    run;   

proc power; 
twosamplemeans
     		alpha = 0.05
     		meandiff = 4.0
	   		stddev= 5
	   		npergroup = .
	   		power = 0.975;
run;

/* sample size for desired power, one sample t-test  (or paired) */
proc power;
  onesamplemeans    /* one sample */
    power=0.8       /* specify power */
    stddev=9        /* specify sigma */
    mean=6          /* specify mean under Ha */
    ntotal=.;       /* and solve for # obs */
run;

proc power;
twosamplemeans
	alpha = 0.05
	meandiff = 12.0
	stddev= 9.18
	npergroup = 18
	power = .;
run;

proc power;
twosamplemeans
	alpha = 0.01
	meandiff = 10.0
	stddev= 9.18
	npergroup = 18
	power = .;
run;

proc power;
twosamplemeans
	alpha = 0.05
	meandiff = 5.0
	stddev= 4
	npergroup = .
	power = 0.9;
run;

proc power;
twosamplemeans
	alpha = 0.005
	meandiff = 5.0
	stddev= 4
	npergroup = .
	power = 0.9;
run;


proc power;
twosamplemeans
	alpha = 0.05
	meandiff = 25
	stddev= 60
	npergroup = .
	power = 0.85;


run;

/* change width of CI */
proc power;
twosamplemeans
	CI=DIFF
	PROBWIDTH=0.95
	HALFWIDTH=3
	alpha = 0.05
	stddev= 4
	npergroup = .;
run;
