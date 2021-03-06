/*  SAS code to analyze the Linthurst data.S */


data set1;
  input loc $ type $ y x1-x5;
  label x1 = sal
        x2 = ph
        x3 = K
        x4 = Na
        x5 = Zn
        y = biomass;
  datalines;
 OI DVEG  676 33 5.00 1441.67 35184.5 16.4524
 OI DVEG  516 35 4.75 1299.19 28170.4 13.9852
 OI DVEG 1052 32 4.20 1154.27 26455.0 15.3276
 OI DVEG  868 30 4.40 1045.15 25072.9 17.3128
 OI DVEG 1008 33 5.55  521.61 31664.2 22.3312
 OI SHRT  436 33 5.05 1273.02 25491.7 12.2778
 OI SHRT  544 36 4.25 1346.35 20877.3 17.8225
 OI SHRT  680 30 4.45 1253.88 25621.3 14.3516
 OI SHRT  640 38 4.75 1242.65 27587.3 13.6826
 OI SHRT  492 30 4.60 1282.95 26511.7 11.7566
 OI TALL  984 30 4.10  553.69  7886.5  9.8820
 OI TALL 1400 37 3.45  494.74 14596.0 16.6752
 OI TALL 1276 33 3.45  526.97  9826.8 12.3730
 OI TALL 1736 36 4.10  571.14 11978.4  9.4058
 OI TALL 1004 30 3.50  408.64 10368.6 14.9302
 SI DVEG  396 30 3.25  646.65 17307.4 31.2865
 SI DVEG  352 27 3.35  514.03 12822.0 30.1652
 SI DVEG  328 29 3.20  350.73  8582.6 28.5901
 SI DVEG  392 34 3.35  496.29 12379.5 19.8795
 SI DVEG  236 36 3.30  580.92 14731.9 18.5056
 SI SHRT  392 30 3.25  535.82 15060.6 22.1344
 SI SHRT  268 28 3.25  490.34 11056.3 28.6101
 SI SHRT  252 31 3.20  552.39  8118.9 23.1908
 SI SHRT  236 31 3.20  661.32 13009.5 24.6917
 SI SHRT  340 35 3.35  672.15 15003.7 22.6758
 SI TALL 2436 29 7.10  525.65 10225.0  0.3729
 SI TALL 2216 35 7.35  563.13  8024.2  0.2703
 SI TALL 2096 35 7.45  497.96 10393.0  0.3205
 SI TALL 1660 30 7.45  458.38  8711.6  0.2648
 SI TALL 2272 30 7.40  498.25 10239.6  0.2105
 SM DVEG  824 26 4.85  936.26 20436.0 18.9875
 SM DVEG 1196 29 4.60  894.79 12519.9 20.9687
 SM DVEG 1960 25 5.20  941.36 18979.0 23.9841
 SM DVEG 2080 26 4.75 1038.79 22986.1 19.9727
 SM DVEG 1764 26 5.20  898.05 11704.5 21.3864
 SM SHRT  412 25 4.55  989.87 17721.0 23.7063
 SM SHRT  416 26 3.95  951.28 16485.2 30.5589
 SM SHRT  504 26 3.70  939.83 17101.3 26.8415
 SM SHRT  492 27 3.75  925.42 17849.0 27.7292
 SM SHRT  636 27 4.15  954.11 16949.6 21.5699
 SM TALL 1756 24 5.60  720.72 11344.6 19.6531
 SM TALL 1232 27 5.35  782.09 14752.4 20.3295
 SM TALL 1400 26 5.50  773.30 13649.8 19.5880
 SM TALL 1620 28 5.50  829.26 14533.0 20.1328
 SM TALL 1560 28 5.40  856.96 16892.2 19.2420
  run;



/* Compute correlations  */

proc corr data=set1;
  var y x1-x5; run;
 /* constuct a matrix of scatter plots */

proc sgscatter data=set1;
  matrix y x1 x2 x3 x4 x5/ diagonal=(histogram)
      markerattrs=(size=10 symbol=CircleFilled color=black);
  run;

/* Find all possible models */
  proc reg data=set1;
  model y = x1 x2 x3 x4 x5 / selection=rsquare aic sbc cp;
  run;

proc reg data=set1 plots=(none);
  model y = x1-x5 / selection=rsquare aic sbc cp  best=5 stop=5; 
  * BEST= specifies maximum number of subset models displayed or output to the OUTEST= data set;
  * STOP= specifies the largest number of regressors to be reported in a subset model for RSQUARE, ADJRSQ, and CP methods;
  *https://support.sas.com/documentation/cdl/en/statug/63347/HTML/default/viewer.htm#statug_reg_sect013.htm;
run;


/* Use stepwise selection */
proc reg data=set1 plots=(none);
  model y = x1-x5 / selection= stepwise
          cp aic sbc sle=.10 sls=.15; 
run;

/* Use forward selection */
proc reg data=set1 plots=(none);
  model y = x1-x5 / selection= forward
          cp aic sbc sle=.05; 
run;

/* Use backward selection */
proc reg data=set1 plots=(none);
  model y = x1-x5 / selection= backward
          cp aic sbc sls=.05; 
run;


/* Get the final selected model*/
 proc reg data=set1 plots=(none);
  model y = x2 x4/ ss1 ss2 vif;
  * SS1 displays the sequential sums of squares;
  * SS2 displays the partial sums of squares;
  run;
ods pdf file="biomass.pdf";

/* case diagnostics*/
 proc reg data=set1 plots=(diagnostics);
  model y = x1-x5/ vif influence partial;
  run;

ods pdf close;
