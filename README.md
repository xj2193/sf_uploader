# Salesforce API for CUMC AOU Project

The project is for data transfering between AOU database in CUMC and Salesforce Platform.   
It's based on [simple-salesforce API](https://pypi.org/project/simple-salesforce/).   

## Motivation 

Salesforce is a CRM platform which is used for participants recruiting and engagement tracking purposes.   
Participants' data need to be extracted and uploaded into Salesforce platform on a daily basis.   
The project is established to automate the data transfering and minimize manual work.   


## Requirements

Salesforce Account (Production and Sandbox)  
AOU SQL Database Settings (Driver, Server and Windows Authentication)  
[simple-salesforce API](https://pypi.org/project/simple-salesforce/)  

## Workflow

#### Data Flow Diagram
![](Salesforce%20Uploading%20Process.png)

#### Steps for Data Extraction and Uploading
1. Build up database and create three tables to maintain information consistency.  
2. Extract contact information from local database and create a participant contact data set.  
3. Compare the data set with existing Contact Table to see if it's already exist in the Salesforce. If the record exists, use an update function.   
If not, use the insert function.   
4. Once the contact data is upserted, a related journey record is created automatically in Salesforce.   
5. Pull out journey and PMI ID table and save the data into local database.  
6. Extract the journey data from database and update in Salesforce.  

#### Tables Built in Local Database 
* Contact_PMI table (extract Contact_Id and PMI_ID from Salesforce and insert in this table )

|Contact_Id   |PMI_Id       |
|:------------|:------------|
|AIEXZ0004    |P000000012   |

* Contact_Journey table (after the journeys are created, pull out contact and journey information and insert in this table)

|Contact_Id   |Journey_Id   |
|:------------|:------------|
|AIEXZ0004    |EXES000347   |

* Relationship table (map PMI_ID and Journey through two tables above )

|Contact_Id   |PMI_Id       |Journey_Id   |
|:------------|:------------|:------------|
|AIEXZ0004    |P000000012   |EXES000347   |

## Instruction to Run the Scripts
* Run the below script in your shell to install all the packages 
```python
$ pip install -r requirements.txt
```
* Update the _setting.py file and rename it to setting.py

* Run the following:
```python
$ python salesforce_api.py
```
