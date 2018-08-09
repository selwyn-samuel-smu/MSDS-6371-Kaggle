*
* Import the data from the training data.
*
;
PROC IMPORT OUT=WORK.HousePrices 
	DATAFILE= "C:\SMU\Courses\StatisticalFoundationsForDataScience\MSDS-6371-Kaggle\data\train.csv" 
	DBMS=CSV REPLACE;
	GETNAMES=YES;
	Guessingrows=3000;
RUN;

* Question 1
*
* Limit the observations to the 3 neighborhoods in focus
*
;
data HousePrices1;
	set HousePrices;
	where Neighborhood = "NAmes" OR 
	Neighborhood = "Edwards" OR 
	Neighborhood = "BrkSide";

	logSalePrice = log(SalePrice);
	logGrLivArea = log(GrLivArea);
run;

*
* Get the parameter estimates and confidence intervals
*
;
proc glm data=HousePrices1 plots=all;
	model logGrLivArea = logSalePrice / solution clparm;
run;

*
* Get MSE, R-Square, Adj R-Square
*
;
proc reg data=HousePrices1;
	id logSalePrice;
	model logGrLivArea = logSalePrice / clm cli;
run;

*
* Get Cross Validation Details
*
;
proc glmselect data=HousePrices1
	seed=1 plots(stepAxis = number) = (criterionPanel ASEPlot Criterionpanel);
	model logGrLivArea = logSalePrice /
	selection=backwards(choose= CV stop= CV) cvmethod = Split(5) CVdetails;
run;

* Question 2
*
;



* 
* Trial Code
*
;
proc reg data=HousePrices1 plots=all;
	model logGrLivArea = logSalePrice;
run;
proc glm data=HousePrices1 plots=all;
	model logGrLivArea = logSalePrice / solution clparm;
run;

proc reg data=HousePrices1 plots=all;
	model logGrLivArea = logSalePrice / vif;
run;

proc reg data=HousePrices;
	id SalePrice;
	model GrLivArea = SalePrice / clm cli;
run;

proc reg data=HousePrices1;
	id logSalePrice;
	model logGrLivArea = logSalePrice / R clm cli;
run;

proc sgplot data=HousePrices;
	title "Prediction Ellipse";
	ellipse x=GrLivArea y=SalePrice;
	scatter x=GrLivArea y=SalePrice;
	keylegend / location=inside position=bottomright;
run;

proc sgscatter data=HousePrices;
	title "Scatter plot Matrix";
	matrix SalePrice GrLivArea / group=Neighborhood;
run;

proc sgplot data=HousePrices;
 reg x=GrLivArea y=SalePrice / group=Neighborhood;
run;

proc sgplot data=HousePrices1;
 reg x=GrLivArea y=logSalePrice / group=Neighborhood;
run;

proc sgplot data=HousePrices1;
 reg x=logSalePrice y=GrLivArea / group=Neighborhood;
run;

proc sgplot data=HousePrices1;
 reg x=logGrLivArea y=logSalePrice / group=Neighborhood;
run;

proc sgplot data=HousePrices1;
 reg x=logSalePrice y=logGrLivArea / group=Neighborhood;
run;

proc print data=HousePrices1;
run;

