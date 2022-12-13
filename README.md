# GCP_Drive_GCS_Bigquery_LookerDashboards
Repo that contains code to automate data ingestion(upstream gdrive,Website,SqlDB) to Downstream(Bigquery) Visualization in Looker
 
I've written a code using Google APIs to automate the ingestion of data from Google Drive to GCS. 
Dataflow to loaddata from GS to BQ.


If you're working on cloud function, use requirements_cloud.txt. The code has a couple of changes similarly. Highly recommend working locally since it takes about 6 mins for every run of a cloud function.If you're working on your local machine, use requirements_local.txt. To install this file, use `pip install -r requirements_local.txt`.

##Figma Design of the Dashboard 
<img width="1440" alt="Dashboard" src="https://user-images.githubusercontent.com/101560010/207263805-19576932-e864-40e1-a0e8-c955ea3309f3.png">

##Actual Dashboard in Looker

