/********* Problem 3: Insecticide Granule Preference by Birds *********/

* Read in data;
data granules;
	infile "\\tsclient\D\Coursework\Stat 500 Fall 2020\FinalExam\granules.txt";
	input bird rep color size y;
	run;

* Assign labels to factors;
proc format;
	value colorF 1 = "Blue" 2 = "Yellow" 3 = "Natural";
	value sizeF 1 = "Small" 2 = "Medium" 3 = "Large";
run;


proc glm data=granules plots=(diagnostics);
  class color size rep;
  model y =  color size rep color*size color*rep size*rep color*size*rep;
  output out = setr r = resid student=stdres p = yhat;
run; quit;

proc sort data=setr; by stdres;  run;

proc glm data=granules plots=(diagnostics);
  where bird NE 70 and bird NE 106 and bird NE 133 and bird NE 134 and bird NE 187;
  class color size rep;
  model y =  color size rep color*size color*rep size*rep color*size*rep;
  output out = setr2 r = resid student=stdres p = yhat;
run; quit;

proc glm data=granules ; */plots=(diagnostics);
  where bird NE 70 and bird NE 106 and bird NE 133 and bird NE 134 and bird NE 187;
  class color size rep;
  model y =  color size rep color*size color*rep size*rep color*size*rep;
    /* compute overall ANOVA table and estimate&CI for parameters and cell means */

  lsmeans color*size /stderr pdiff adjust = tukey;

  contrast 'color' color 1 0 -1;
run;
