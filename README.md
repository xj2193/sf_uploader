# Salesforce API for CUMC AOU Project

The project is for data transfering between AOU database in CUMC and Salesforce Platform.   
It's based on [simple-salesforce API](https://pypi.org/project/simple-salesforce/).   

## Motivation 

Salesforce is a CRM platform which is used for participants recruiting and engagement tracking purposes.   
Participants' data need to be extracted and uploaded into Salesforce platform on a daily basis.   
The project is established to automate the data transferring and updating to minimize manual work.   


## Requirements

Salesforce Account and [Salesforce security token](https://onlinehelp.coveo.com/en/ces/7.0/administrator/getting_the_security_token_for_your_salesforce_account.htm) (Production and Sandbox)  
AOU SQL Database Settings (Driver, Server and Windows Authentication)  

Please refer to the [settings.py](https://github.com/xj2193/sf_uploader/blob/master/_settings.py)  

## Workflow

#### Data Flow Diagram
![](Salesforce%20Uploading%20Process.png)

#### Steps for Data Extraction and Uploading
1. Build up database using view_create_scripts.sql to track the relationship and maintain information consistency.  
2. Extract contacts and journeys from Salesforce and save them in local database.
3. Using hash function in views to check if there's any changes in contacts and journeys.
4. Update and insert records from contact_update view.
4. Once the contacts are upserted, related journey records are created automatically in Salesforce.   
5. Pull out journey and PMI ID table and save the data into local database.  
6. Extract the journey data from database and compare with journey from Salesforce.
7. Update any changes in journey_update view.  

#### Tables in Local Database 
* sf_contact (Salesforce originated contacts)

|Id                 |LastName     |FirstName    |HP_PMI_ID__c|
|:------------------|:------------|-------------|------------|
|0030a00002WIXUXXX2 |Holmes       |Sherlock     |P123456789  |


* pardot_contact (Pardot originated contacts)

|Id                 |LastName     |FirstName    |Email           |Phone       |...|
|:------------------|:------------|-------------|----------------|------------|---|
|0030a00002WIXUXYY3 |Watson       |John         |jw2222@xxxxx.com|xxxxxxxxxx  |   |


* sf_journey_export (Salesforce journeys)

|Id                 |Contact__c         |HP_Participant_Status__c|...|
|:------------------|:------------------|------------------------|---|
|0060a00000k5ZgaBBC |0030a00002WIXUXXX2 |Core Participant        |   |  


* contact_log (Log the update or insert action and the error message for contact records)

|PMI_Id      |LastName     |FirstName    |Action  |Success |Error               |Last_Modified_Time |
|:-----------|:------------|-------------|--------|--------|--------------------|-------------------|
|P123456789  |Holmes       |Sherlock     |Create  |1       |                    |2019-07-23 11:56:30|
|P123456789  |Holmes       |Sherlock     |Create  |0       |Error message:You're creating a duplicate record.|2019-07-23 11:56:31|


* journey_log (Log the update or insert action and the error message for contact records)

|Journey_Id          |Action  |Success |Error               |Last_Modified_Time |
|:-------------------|--------|--------|--------------------|-------------------|
|0060a00000k5ZgaBBC  |Create  |1       |                    |2019-07-23 11:56:30|


* contact_journey_relation (map PMI_ID and journey_Id)

|Contact_Id          |PMI_Id       |Journey_Id          |
|:-------------------|:------------|:-------------------|
|0030a00002WIXUXXX2  |P123456789   |0060a00000k5ZgaBBC  |


#### Views in Local Database 
* sf_contact_view (contacts extracted from HealthPro and REDCap)
* sf_contact_export_view (built upon sf_contact table and store all the existing contacts in Salesforce)
* sf_contact_export_update (difference between contact_view and contact_export_view, need to be inserted and updated)
* pardot_contact_export_update (Pardot contacts which match HealthPro and REDCap contacts)
* sf_journey_view (journeys extracted from HealthPro and REDCap)
* sf_journey_export_view (built upon sf_journey table and store all the existing journeys in Salesforce)
* sf_journey_export_update (difference between journey_view and journey_export_view, need to be updated)


## Instruction to Run the Scripts
* Run the below script in your shell to install all the packages 
```python
$ pip install -r requirements.txt
```
* Modify and run view_create_script.sql in your local database to build up 7 views
* Update the _setting.py file and rename it to settings.py
* Run the following:
```python
$ python daily_update.py
```
