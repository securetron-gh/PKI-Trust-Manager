[Deploy Securetron PKI Trust Manager To Azure Cloud]()
=============================================================================================================

[Click here to watch](https://youtu.be/Ufh1Dlyb1y4)

### [![Quick guidde](https://static.guidde.com/v0/qg%2FNF7l8sUngkQmFADnIfgiHyTW9Wk2%2FvoFiuMytKLKXQiqgJ6Jb5W%2FqeVC7DLbTMhCZQVdGVdn8F_cover.png?alt=media&token=c941cc21-89ad-4d8a-b631-0d555c79a287)](https://youtu.be/Ufh1Dlyb1y4)

This tutorial guides you through deploying the Securetron PKI Trust Manager to Azure.

### 1\. Introduction

You will configure container settings, environment variables, and ingress to complete the deployment.

![Introduction](https://static.guidde.com/v0/qg%2FNF7l8sUngkQmFADnIfgiHyTW9Wk2%2FvoFiuMytKLKXQiqgJ6Jb5W%2FwXmKAsja5bDwVfydsgQAip_doc.png?alt=media&token=5af94143-c5a3-4599-a854-6d0efd25e391)

### 2\. Enter Container Keyword

Click the azure search bar and type in Container Apps to access the Container Apps Management Service

![Enter Container Keyword](https://static.guidde.com/v0/qg%2FNF7l8sUngkQmFADnIfgiHyTW9Wk2%2FvoFiuMytKLKXQiqgJ6Jb5W%2Foogx6G5DNJBhRynrFinvUk_doc.png?alt=media&token=76f67107-6a99-4e82-af77-fd33fa49b018)

### 3\. Navigate To Container Apps

Click Create and then select Container App from the drop-down to deploy new PKI Trust Manager App

![Navigate To Container Apps](https://static.guidde.com/v0/qg%2FNF7l8sUngkQmFADnIfgiHyTW9Wk2%2FvoFiuMytKLKXQiqgJ6Jb5W%2Ftg6D1wgJJs8FgdMk79hLBL_doc.png?alt=media&token=6dd51731-6f4a-458d-b01a-3138f5df9154)

### 4\. Select Container App

Click the container app name to access, its detailed settings and deployment options.

![Select Container App](https://static.guidde.com/v0/qg%2FNF7l8sUngkQmFADnIfgiHyTW9Wk2%2FvoFiuMytKLKXQiqgJ6Jb5W%2Fp6WMPUTRACSV9rVBHDEWRW_doc.png?alt=media&token=cede4f23-c2f9-4f97-b7f5-f478edb5f612)

### 5\. Enter Container App Name

Enter the container app name to identify your deployment, such as 'pki-trust-manager'.

![Enter Container App Name](https://static.guidde.com/v0/qg%2FNF7l8sUngkQmFADnIfgiHyTW9Wk2%2FvoFiuMytKLKXQiqgJ6Jb5W%2Fi5G92nvM22zzcW74JVmqVY_doc.png?alt=media&token=2bde29de-e210-44c3-b488-dcb28429cffd)

### 6\. Proceed To Container Settings

Click 'Next : Container' to move forward to configuring container-specific settings.

![Proceed To Container Settings](https://static.guidde.com/v0/qg%2FNF7l8sUngkQmFADnIfgiHyTW9Wk2%2FvoFiuMytKLKXQiqgJ6Jb5W%2F7jT2eSS3ynasAj8uQed8NT_doc.png?alt=media&token=f5a997ae-545d-44f6-a963-c6368d871f73)

### 7\. Open Image Source Settings

Click image source to specify the container image, that will be deployed.

![Open Image Source Settings](https://static.guidde.com/v0/qg%2FNF7l8sUngkQmFADnIfgiHyTW9Wk2%2FvoFiuMytKLKXQiqgJ6Jb5W%2FaZuQLEmNRyGwSrq2mqbZD8_doc.png?alt=media&token=754c621c-831b-4546-aaa4-5c66957c128a)

### 8\. Fill Image Tag

Enter the Registry URL and image tag or version to specify, which container image version to deploy.

* Container Registry URL: securetron.azurecr.io
* Image Name and Tag: pkimain:latest

![Fill Image Tag](https://static.guidde.com/v0/qg%2FNF7l8sUngkQmFADnIfgiHyTW9Wk2%2FvoFiuMytKLKXQiqgJ6Jb5W%2F8pftJTHi9eXS5z7E9FdyQ7_doc.png?alt=media&token=9caff889-a045-4683-be41-b56eebcce4a1)

### 9\. Development Stack

Select .NET Development stack to optimize the container app.

![Set Image Tag Status](https://static.guidde.com/v0/qg%2FNF7l8sUngkQmFADnIfgiHyTW9Wk2%2FvoFiuMytKLKXQiqgJ6Jb5W%2FovV81hvBADndrkeBjm7hmo_doc.png?alt=media&token=974495c4-d8c2-4cf1-9470-771b492e63b3)

### 10\. Select Environment Variable Name

Fill in the environment variable name, such as the initial Admin credentials and DB Connection String to define configuration.

#Required#
* ADMIN__USERNAME=superadmin
* ADMIN__PASSWORD=YourUniquePassword
* ADMIN__EMAIL=pkiadmin@domain.local
* ConnectionStrings__OurDBContext=Your MSSQL DB Connection String
* Environment__CanMigrateData=True

* Scep__OtpValidityMinutes=525600
  
* Licensing__ServerUrl=Check_your_email_or_submit_request_for_license
* Licensing__ApiKey=Check_your_email_or_submit_request_for_license
* Licensing__ClientId=CompanyName-PKI-Trust-Manager

* Licensing__OfflineMode=false
* Licensing__EnableOnlineValidation=true

* Smtp__Server=Your_SMTP_Server_FQDN
* Smtp__Auth=true
* Smtp__SenderName=PKI-Trust-Manager
* Smtp__SenderAddress=Email_address@yourdomain.local
* Smtp__ReceiverAddressOnError=Email_address@yourdomain.local
* Smtp__ReceiverAddressOnEvent=Email_address@yourdomain.local
* Smtp__Port=Your_SMTP_Server_Port
* Smtp__Username=Your_SMTP_Username
* Smtp__Password=Your_SMTP_Password
* Smtp__EnableSsl=true


![Select Environment Variable Name](https://static.guidde.com/v0/qg%2FNF7l8sUngkQmFADnIfgiHyTW9Wk2%2FvoFiuMytKLKXQiqgJ6Jb5W%2Fi2UKu6L3rHQUMRL7UkNuj4_doc.png?alt=media&token=54e576cc-7408-4832-8e95-0408450d37e1)

### 11\. Proceed To Ingress Settings

Click 'Next : Ingress' to configure network ingress settings for the container app.

![Proceed To Ingress Settings](https://static.guidde.com/v0/qg%2FNF7l8sUngkQmFADnIfgiHyTW9Wk2%2FvoFiuMytKLKXQiqgJ6Jb5W%2FrJGDumrQHwFBy9ehPGRyL8_doc.png?alt=media&token=eb13acd0-901c-40b3-a346-f199dc26d62d)

### 12\. Open Ingress Configuration

Click to access ingress traffic settings to control external access to the container.

![Open Ingress Configuration](https://static.guidde.com/v0/qg%2FNF7l8sUngkQmFADnIfgiHyTW9Wk2%2FvoFiuMytKLKXQiqgJ6Jb5W%2FdvGB28nqsuikP51zcFKWvq_doc.png?alt=media&token=1afdc49f-9038-4703-a3fd-f9b89abcc98f)

### 13\. Select Ingress Traffic Option

Click 'Ingress traffic' to specify how incoming network traffic is handled.

![Select Ingress Traffic Option](https://static.guidde.com/v0/qg%2FNF7l8sUngkQmFADnIfgiHyTW9Wk2%2FvoFiuMytKLKXQiqgJ6Jb5W%2Fmvv81EkUZibKRfprCpmhtV_doc.png?alt=media&token=c27928b3-9a9a-4941-a3a5-1288fd7783ca)

### 14\. Modify Ingress Settings

Enable Session Affinity to enable connection persistence.

![Modify Ingress Settings](https://static.guidde.com/v0/qg%2FNF7l8sUngkQmFADnIfgiHyTW9Wk2%2FvoFiuMytKLKXQiqgJ6Jb5W%2FwBtQGJoDTen1Qh6jKaejPp_doc.png?alt=media&token=63d5bfba-a600-430a-a817-71c98f051b57)

### 15\. Proceed To Tags Section

Click 'Next' to add metadata tags to your container app deployment.

![Proceed To Tags Section](https://static.guidde.com/v0/qg%2FNF7l8sUngkQmFADnIfgiHyTW9Wk2%2FvoFiuMytKLKXQiqgJ6Jb5W%2F83qM75J7fvEmXsJiUjjKvk_doc.png?alt=media&token=2605e1a7-b20c-4743-92a1-6da66a4fa3fb)

### 16\. Proceed To Review And Create

Click 'Next ' to review your configuration before deployment.

![Proceed To Review And Create](https://static.guidde.com/v0/qg%2FNF7l8sUngkQmFADnIfgiHyTW9Wk2%2FvoFiuMytKLKXQiqgJ6Jb5W%2Fi6R344BeoPZEtBm54iYKGH_doc.png?alt=media&token=db55aec1-ae93-49c0-90d4-d993c95c8949)

### 17\. Verify Validation Status

The container settings will be verified and "Passed" if no issues are found

![Verify Validation Status](https://static.guidde.com/v0/qg%2FNF7l8sUngkQmFADnIfgiHyTW9Wk2%2FvoFiuMytKLKXQiqgJ6Jb5W%2F5AZqTPs75BRhYtuuAEkgyV_doc.png?alt=media&token=e91e4af2-191e-4afa-b5b4-ccb3fe96044a)

### 18\. Create Container App

Click 'Create' to initiate the deployment of your PKI Trust Manager container app.

![Create Container App](https://static.guidde.com/v0/qg%2FNF7l8sUngkQmFADnIfgiHyTW9Wk2%2FvoFiuMytKLKXQiqgJ6Jb5W%2FswzyohtQv1QATkkvnkk7px_doc.png?alt=media&token=270a95fb-22e5-4fdf-be5c-c01fcfca0aef)

### 19\. Open Deployment Progress

You should see that the Deployment of the Container App is completed successfully

![Open Deployment Progress](https://static.guidde.com/v0/qg%2FNF7l8sUngkQmFADnIfgiHyTW9Wk2%2FvoFiuMytKLKXQiqgJ6Jb5W%2FgdqLsG1abpzaXYSX1vDbiH_doc.png?alt=media&token=cc1bde0e-db32-4806-ae56-867075499180)

### 20\. Go To Resource Page

Click 'Go to resource' to access the deployed container app's resource page.

![Go To Resource Page](https://static.guidde.com/v0/qg%2FNF7l8sUngkQmFADnIfgiHyTW9Wk2%2FvoFiuMytKLKXQiqgJ6Jb5W%2FhNSMY9dqEGJnTtG9HkExhP_doc.png?alt=media&token=a79be0e2-42d6-4fc1-b53d-0ba5ff1c4563)

### 21\. Access Application URL

Click the Application URL to open the pki trust manager, web application in your browser.

![Access Application URL](https://static.guidde.com/v0/qg%2FNF7l8sUngkQmFADnIfgiHyTW9Wk2%2FvoFiuMytKLKXQiqgJ6Jb5W%2F485xymwUR84wag2V4SHQxo_doc.png?alt=media&token=a8c6ba13-63d4-4344-afe4-c952941d4109)

### 22\. Enter Password

Enter your username and password as defined in the environment variable to log into the pki trust Manager application and click login

![Enter Password](https://static.guidde.com/v0/qg%2FNF7l8sUngkQmFADnIfgiHyTW9Wk2%2FvoFiuMytKLKXQiqgJ6Jb5W%2FqJzGBfMZ2GCojDoctT8z49_doc.png?alt=media&token=9cb66963-fd76-4b24-99f0-85ee30b3ce7a)

### 23\. PKI Trust Manager WebUI

You will see the PKI Trust Manager Main Dashboard. Congratulations!, You have successfully deployed the PKI Trust Manager to Azure.

![PKI Trust Manager WebUI](https://static.guidde.com/v0/qg%2FNF7l8sUngkQmFADnIfgiHyTW9Wk2%2FvoFiuMytKLKXQiqgJ6Jb5W%2F3H9AC4jcVZ25e4CNofDRC8_doc.png?alt=media&token=5d3cc2ea-7ae7-4b33-a789-75c7c66f144d)

Thank you for using the Next Generation of Certificate Management System by Securetron - PKI Trust Manager. For more information, support, and additional tools, please visit our website.

[**Securetron Web**](https://securetron.net)
