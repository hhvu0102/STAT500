data set1;
 input velocity trial ;
 datalines;
850	 1
740	 1
900	 1
1070 1
930	 1
850	 1
950	 1
980	 1
980	 1
880	 1
1000 1
980	 1
930	 1
650	 1
760	 1
810	 1
1000 1
1000 1
960	 1
960	 1
960	 2
940	 2
960	 2
940	 2
880	 2
800	 2
850	 2
880	 2
900	 2
840	 2
830	 2
790	 2
810	 2
880	 2
880	 2
830	 2
800	 2
790	 2
760	 2
800	 2
880	 3
880	 3
880	 3
860	 3
720	 3
720	 3
620	 3
860	 3
970	 3
950	 3
880	 3
910	 3
850	 3
870	 3
840	 3
840	 3
850	 3
840	 3
840	 3
840	 3
890	 4
810	 4
810	 4
820	 4
800	 4
770	 4
760	 4
740	 4 
750	 4
760	 4
910	 4
920	 4
890	 4
860	 4
880	 4
720	 4
840	 4
850	 4
850	 4
780	 4
890	 5
840	 5
780	 5
810	 5
760	 5
810	 5
790	 5
810	 5
820	 5
850	 5
870	 5
870	 5
810	 5
740	 5
810	 5
940	 5
950	 5
800	 5
810	 5
870	 5
run;


proc sort data=set1; by trial;  run;

proc means data=set1; by trial; var velocity;
run;


/* Note that the CLPARM option produces confidence 
   intervals for parameter estimates and any contrast
   specified by an ESTIMATE statement  */

proc glm data=set1;
  class trial; 
   model velocity = trial / p solution clparm;

  contrast "1 vs 2345" trial -4 1 1 1 1;
  estimate "1 vs 2345" trial -4 1 1 1 1 / divisor=-4;
  contrast "2 vs 345" trial 0 -3 1 1 1;
  estimate "2 vs 345" trial 0 -3 1 1 1 / divisor=-3;
  contrast "3 vs 45" trial 0 0 -2 1 1;
  estimate "3 vs 45" trial 0 0 -2 1 1 / divisor=-2;
  contrast "4 vs 5" trial 0 0 0 1 -1;
  estimate "4 vs 5" trial 0 0 0 1 -1;

  means trial /alpha=.05 bon lsd scheffe tukey snk  hovtest=bf;
  output out=set1 residual=resid predicted=ymean;
  run;

 proc print data=set1; run;

 proc univariate data=set1 normal;
   qqplot resid / normal(mu=est sigma=est)  square;
   var resid;  run;

 proc npar1way data=set1 wilcoxon;
 * You could use the option dscf to request pairwise multiple comparison analysis;
     class trial; var velocity;
     exact wilcoxon / mc n=50000;
     run;


