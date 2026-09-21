# Welcome to shopper!
### A project spearheaded by the minds behind Generic Software Company (SOFT3888_W12_02)

## Product Description
**shopper** is an iOS application built to provide a means for purchasing and selling items. **shopper** achieves this through combining industry-standard and innovative practices, resulting in a product that is destined for success within the e-commerce industry. An array of features are available within the application, including, but not limited to:

- Browsing products based on Categories
- Product Search
- Account Management
- Dynamic Wishlist
- Dynamic Shopping Cart
- Order Placement
- Order Status Tracking

**shopper** is also available for Android devices, however, it is yet to be publically released for Android.

## Project Structure
**shopper** comprises of two major components:

1. The Seller & Administration Website
2. The Phone Application

Each component serves their own individual purpose.

The Website should be used by Sellers that want to place items for sale on the **shopper** application. Additionally, they are able to conduct further activities such as editing existing items and updating the status of orders. Administrators shoudl also use the website for certain functions, such as creating new users and creating new categories.

The Application should be used by end-users; people that intend to use the application to purchase goods from the available catalogue.

Therefore, the operating of the entire project should involve both the Website and Application working in collaboration, where sellers/admins can update the data in the application via the website, whilst consumers are able to browse and purchase items available in the application.

## Project Codebase
The codebase for both the Website and Application are stored within this repository.

The code for the Website is stored within the **Shopping_Website** folder.

The code for the Application is stored within the **shopper** folder.

Project Configuration and Environment Setup for each component are detailed within a README inside their respective folders. However, there are some configuration steps that need to be taken that relate to both the Website and Application. These are detailed in the next section.

## Environment Setup
There are 2 major external dependencies that the Website and Application rely upon:

1. **SendGrid** (Email Services - Forgot Password Emails)
2. **Database and Storage** 

### SendGrid
SendGrid is a online service that delivers transactional and marketing emails through their own cloud-based email delivery platform. In our Website and Application, we use SendGrid as part of our 'Forgot Password?' functionality. For this functionality to operate, there are a couple of pre-requisites. You will need:

1. A SendGrid Account, and
2. An Email Account (used to send the password reset emails from)

To configure the **shopper** Website and Application with your very own accounts, follow the below steps:

1. If you do not currently have a SendGrid account configured, you will need to create a new one. Otherwise, continue onto Step 5. The sign-up link can be found [here](https://signup.sendgrid.com/), and just the free tier is required.
2. Once your SendGrid account is created, you will then need to link an email address. This email will be used to send the password reset emails. This email can be any one of your choosing. It is recommended that you use an email account with your own domain, but, during the development phase, a simple Gmail account was used without issue. Navigate to **Marketing** and then click **Senders**.
3. At the top-right corner, select **Create New Sender**.
4. Fill in all fields and then click **Save**. [This guide](https://docs.sendgrid.com/ui/sending-email/senders) explains the meaning of each available field.
5. Click **Email API** and then **Integration Guide**.
6. Out of the two options (Web API and SMTP Relay), select the **Choose** button underneath the **SMTP Relay** option.
7. Once the next page loads, enter an **API Key Name**, this can anything you desire. 
8. Once you have entered a name, select **Create Key**.
9. You should now have an **API Key**. Copy this key and store it somewhere safe for the meantime.
10. Within this repository, open the **DB_Scripts** folder, and open the **schema** file.
11. At the bottom of the file, there should be a line that reads ```INSERT INTO ApiKey (apikey,api) VALUES('{INSERT API KEY HERE}', 'SendGrid');```. Replace the ```{INSERT API KEY HERE}``` block with your **API Key** from Step 9.
12. Save this file.

After completing these steps, the configuration of the SendGrid API Integration should be complete! The API Key will be inserted into the DB when you create it (see AWS Section below), and the code will take care of the rest.

### Database and Storage

Currently we use AWS to host our PostgresSQL database and storage for both mobile and web application.

AWS is a subsidiary of Amazon that provides on-demand cloud computing platforms and APIs to individuals, companies, and governments, on a metered pay-as-you-go basis. In this project we use two AWS services. One is AWS RDS PostgresSQL, which allow us to set up, operate, and scale a PostgresSQL relational database in the cloud. Second is AWS S3, which provides object storage through a web service interface, we use S3 for store images.

Please note that AWS service is not free, so we are unable to keep database running on AWS forever. Therefore you will have to setup your own database in the future. 

To setup your own database, follow the below steps:

1. Create new PostgresSQL database. Famouse provider are AWS, google cloud, Microsoft azure or you can host it on your local machine.
2. Run schema script on your database, script locate at /DB_Scripts/schema.sql
3. Run data  script on your database, script locate at /DB_Scripts/dummySQLData.sql
4. Set up variable for mobile application.
    1. Go to shopper/lib/models/DBService.dart
    2. On line 12 change db_path to your database path
    3. On line 13 change db_port to your database port
    4. On line 14 change db_name to your database name
    5. On line 15 change db_username to your database username
    6. On line 16 change db_password to your database password
5. Set up variable for web application.
    1. Go to Shopping_Website/model/sql_handler.py
    2. On line 10 change dbname to your database name
    3. On line 10 change host to your database path
    4. On line 10 change port to your port
    5. On line 10 change user to your user
    6. On line 10 change password to your password.

To setup your own Storage, with your own AWS S3 follow the below steps:

1. Create AWS account at https://aws.amazon.com/
2. Create S3 bucket with bucket name soft3888 at https://aws.amazon.com/s3/
3. Configure your bucket to allow public access. So anyone can have access to images
4. Set up variable for web application
    1. go to Shopping_Website/model/sql_handler.py
    2. On line 4 change s3_storage variable to your own s3 storage path
    

## Development Team
The following team were monumental during the development of both the Website and Application. The time and effort exerted by each and every team member has been exceptional, and deserve to be recognised. The Development Team is as follows:

- **Chelsea Iglesia** - cigl2422@uni.sydney.edu.au
- **Roman Kaard** - rkaa8480@uni.sydney.edu.au
- **Kittibhumi Jaggabatara** - kjag8350@uni.sydney.edu.au
- **Shimiao Sun** - ssun9121@uni.sydney.edu.au
- **Xiangwen Zheng** - 	xzhe8176@uni.sydney.edu.au
- **Harrison Chambers** - hcha3800@uni.sydney.edu.au
- **Taizeen Munir** - tmun0274@uni.sydney.edu.au