# covid-19-analysis
My first attempt at a complete data analysis project, the steps taken to reach the final outcome (which is the Power BI file) are as follows:
- Raw data was obtained from World Health Organization's website
- Data was imported into DBeaver in CSV format
- Transformations were performed on the data to change the original format (string) into more suitable formats (date and numeric)
- Data was then exported to a local PostgreSQL database
- Some basic data cleaning (to deal with missing values) was performed
- 4 different views were built in DBeaver
- Views were imported into Power BI, and a dashboard made up of 5 different visuals was built using them
- Analysis was performed till the end of Feb-2022. Data from start of March onwards was incomplete
- In order to view the dashboard, please download the file "COVID-19 Dashboard - Global Numbers.pbix" and launch it in Power BI
- In order to view the PostgreSQL script, please check the file "covid_19.sql"
