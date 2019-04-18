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

![alt text](https://gitbucket.sis.nyp.org/pmi-hpo-admin/salesforce_api_hpo/raw/master/Salesforce%20Uploading%20Process.png)

## How to START?

Build up database and create three tabels to maintain information consistency:
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

please run the below sript in your shell to install all the packages 
```python
$ pip install -r requirements.txt
```

## Others...
