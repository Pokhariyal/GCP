# GCP_LiveData<-CloudFunction->GCS->Bigquery->LookerDashboards
Repo that contains code to automate data ingestion(upstream gdrive,Website,SqlDB) to Downstream(Bigquery) Visualization in Looker
 
I've written a code using Google APIs to automate the ingestion of data from APIs,Google Drive to GCS. 
Dataflow to loaddata from GS to BQ.


If you're working on cloud function, use requirements_cloud.txt. The code has a couple of changes similarly. Highly recommend working locally since it takes about 6 mins for every run of a cloud function.If you're working on your local machine, use requirements_local.txt. To install this file, use `pip install -r requirements_local.txt`.

##Figma Design of the Dashboard 
<img width="1440" alt="Dashboard" src="https://user-images.githubusercontent.com/101560010/207287068-9b30ec89-8ed3-4261-b182-cc830fe0f383.png">
<img width="1440" alt="DrillDown" src="https://user-images.githubusercontent.com/101560010/207287137-75a521d7-7376-4e8b-b6f0-9f9cec9faea6.png">

##Actual Dashboard in Looker
[Admin_Dashboard 2022-12-13T1526.pdf](https://github.com/Pokhariyal/GCP/files/10216663/Admin_Dashboard.2022-12-13T1526.pdf)
