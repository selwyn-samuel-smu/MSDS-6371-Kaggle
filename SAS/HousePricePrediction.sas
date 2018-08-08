
PROC IMPORT OUT=WORK.HousePrices 
	DATAFILE= "C:\SMU\Courses\StatisticalFoundationsForDataScience\MSDS-6371-Kaggle\data\train-msds6371.csv" 
	DBMS=CSV REPLACE;
	GETNAMES=YES;
	Guessingrows=3000;
RUN;

proc print data=HousePrices;
run;

data HousePrices1;
	set HousePrices;
	
	logSalePrice = log(SalePrice);
	logGrLivArea = log(GrLivArea);
run;

proc reg data=HousePrices;
	id SalePrice;
	model GrLivArea = SalePrice / R clm cli;
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
