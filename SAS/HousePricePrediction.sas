
PROC IMPORT OUT=WORK.HousePrices 
	DATAFILE= "C:\SMU\Courses\StatisticalFoundationsForDataScience\MSDS-6371-Kaggle\data\train.csv" 
	DBMS=CSV REPLACE;
	GETNAMES=YES;
	Guessingrows=3000;
RUN;

proc print data=HousePrices;
run;
