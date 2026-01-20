[Deploy PKI Trust Manager Microsoft CA Proxy Gateway](https://www.youtube.com/watch?v=k3lvyDKz-Ic)
==============================================================================================================

[Click here to watch](https://www.youtube.com/watch?v=k3lvyDKz-Ic)

### [![Quick guidde](https://static.guidde.com/v0/qg%2FNF7l8sUngkQmFADnIfgiHyTW9Wk2%2FeCDM3TxKogNcNkgvgYbkqr%2F8cvwAa6EQ2HYPaGoz17G1n_cover.png?alt=media&token=175e07b0-3d1d-4e39-9123-d47e79504692)](https://www.youtube.com/watch?v=k3lvyDKz-Ic)

This tutorial guides you through deploying the PKI Trust Manager Microsoft CA / ADCS Proxy Gateway. The Proxy Gateway for ADCS is used to integrate the PKI Trust Manager in order to provide backend access to the Certificate Authority without exposing it directly. The Proxy Gateway integrates with PKI Trust Manager so that automation and certificate lifecycle management can be performed using Microsoft Active Directory Certificate Authority

### 1\. Add a Service Account

We will begin by adding a service account user to the AD Domain. Provision the domain service account as per your organization standard. This service account will be used to run the CA Proxy Gateway service and will be the CA Manager

![Click Initial Interface Element](https://static.guidde.com/v0/qg%2FNF7l8sUngkQmFADnIfgiHyTW9Wk2%2FeCDM3TxKogNcNkgvgYbkqr%2FhEyH5a1HAgFCcTDHxMirRE_doc.png?alt=media&token=41533456-b8a7-47d7-9a39-6acdeebd3512)

### 2\. Group Membership of the Service Account

Ensure that the service account is the member of IIS\_IUsr Group as well as member of CA Admin Group if you have one

![Proceed to Next Step](https://static.guidde.com/v0/qg%2FNF7l8sUngkQmFADnIfgiHyTW9Wk2%2FeCDM3TxKogNcNkgvgYbkqr%2F5Lppf1Qkkp4r2pFJ1vRhw1_doc.png?alt=media&token=e719019a-4943-45fa-8a10-7b9de510e977)

### 3\. Confirm Adding the User

Click OK to confirm the current action and continue.

![Confirm Action with OK](https://static.guidde.com/v0/qg%2FNF7l8sUngkQmFADnIfgiHyTW9Wk2%2FeCDM3TxKogNcNkgvgYbkqr%2Ftd8QfAZs9VRHeB7RagurPR_doc.png?alt=media&token=56e15282-cfe1-4fa6-a126-2b38ac29c7ba)

### 4\. CA Proxy Memeber Server

On a member server that will run the CA Proxy Gateway application, ensure that IIS Web server is installed. If not then through the Add Roles and Features Wizard, add the necessary roles.

![Open Add Roles Wizard](https://static.guidde.com/v0/qg%2FNF7l8sUngkQmFADnIfgiHyTW9Wk2%2FeCDM3TxKogNcNkgvgYbkqr%2Fnj2jqogDRorG8UXQjhYVk1_doc.png?alt=media&token=7aa2dbe2-7a99-4750-8fc2-c3ac7d738133)

### 5\. Select Role Installation Option

Select the IIS Web Server role installation option to continue.

![Select Role Installation Option](https://static.guidde.com/v0/qg%2FNF7l8sUngkQmFADnIfgiHyTW9Wk2%2FeCDM3TxKogNcNkgvgYbkqr%2FvTf4fQLZ7HKDWt5GU6DAuu_doc.png?alt=media&token=9110bd47-2d05-4aeb-8794-3e142dd24ffa)

### 6\. Choose Server Selection

Choose the server selection to specify where roles will be installed.

![Choose Server Selection](https://static.guidde.com/v0/qg%2FNF7l8sUngkQmFADnIfgiHyTW9Wk2%2FeCDM3TxKogNcNkgvgYbkqr%2FbokVEMEPqfA5XPrgozFhgM_doc.png?alt=media&token=2513a404-3df1-4e92-b9ef-89b95e95432e)

### 7\. Enable WCF and MSMQ Services

Expand WCF Services and Enable HTTP Activation

![Enable WCF and MSMQ Services](https://static.guidde.com/v0/qg%2FNF7l8sUngkQmFADnIfgiHyTW9Wk2%2FeCDM3TxKogNcNkgvgYbkqr%2F35unPtGoJ737oweiUGH2mc_doc.png?alt=media&token=43db10e7-f440-4864-833e-4b42f660ec53)

### 8\. InetPub Directory

Download the PKI Trust Manager CA Proxy Gateway app from securetron website. Extract the downloaded zip file to the inetpub directory and call it caproxyapi

![Access Local Disk inetpub](https://static.guidde.com/v0/qg%2FNF7l8sUngkQmFADnIfgiHyTW9Wk2%2FeCDM3TxKogNcNkgvgYbkqr%2F7ZZg6X4RM6nysg3FvQq2xq_doc.png?alt=media&token=ef8e9ebe-746e-41a2-867b-2ae75cbcb3c8)

### 9\. Directory Permissions

Open the properties of the caproxyapi app folder to grant permissions to the previously created service account.

![Click Context Menu Option](https://static.guidde.com/v0/qg%2FNF7l8sUngkQmFADnIfgiHyTW9Wk2%2FeCDM3TxKogNcNkgvgYbkqr%2Fq7xpEvoWHUYRjuC1sGt2vg_doc.png?alt=media&token=f5dfdf0a-e473-4a8d-939d-10b9a4cb08d8)

### 10\. Grant Service Account Permissions

Under the Security tab; add the service account and assign fully manage permissions.

![Confirm with OK Button](https://static.guidde.com/v0/qg%2FNF7l8sUngkQmFADnIfgiHyTW9Wk2%2FeCDM3TxKogNcNkgvgYbkqr%2FjDP3zZydyj9n5iV5rzqv1p_doc.png?alt=media&token=79522d6e-4175-43a4-9e7d-46f45cf160e4)

### 11\. Edit Web.Config file

Within the caproxyapi folder, edit the Web.Config file using a text editor

![Select Next Interface Element](https://static.guidde.com/v0/qg%2FNF7l8sUngkQmFADnIfgiHyTW9Wk2%2FeCDM3TxKogNcNkgvgYbkqr%2FguwFT4DYEfGFWr6UoS5Vy6_doc.png?alt=media&token=b531513f-0a57-45cc-ab79-10d9fe59188f)

### 12\. AppSettings section in Web.Config

Go to the App Settings section. We will need to modify first 3 lines corresponding to CAStore, CAConfig, and LogPath

![Open ca Directory](https://static.guidde.com/v0/qg%2FNF7l8sUngkQmFADnIfgiHyTW9Wk2%2FeCDM3TxKogNcNkgvgYbkqr%2FvPQk4UNi52mroq4YshdYDM_doc.png?alt=media&token=3c480324-2c9a-4aa7-809d-92adfaf68e30)

### 13\. Web.Config - CA Certs

The CA folder is where the ISSUING CA and CA CHAIN in .PEM format needs to be copied. Manually copy these from the Certificate Trust Store or from the CA. The two files are: cacert.crt which is the Issuing CA whereas the second file is cachain.crt which corresponds to the ROOT plus Subordinate CA

![Open ca Directory](https://static.guidde.com/v0/qg%2FNF7l8sUngkQmFADnIfgiHyTW9Wk2%2FeCDM3TxKogNcNkgvgYbkqr%2F7j6GnCVqwnUE9a7xCkQfW2_doc.png?alt=media&token=f680729b-9fbd-4310-80fe-1d2e0fc83329)

### 14\. Web.Config - CA Config

The "CA Config" refers to the "Config" parameter in the output of certutil executed on the CA to which the CA Proxy App will connect. It typically consists of FQDN backslash CA Name

![Open ca Directory](https://static.guidde.com/v0/qg%2FNF7l8sUngkQmFADnIfgiHyTW9Wk2%2FeCDM3TxKogNcNkgvgYbkqr%2FoxX8ie7L2DGhrnGcofwr5i_doc.png?alt=media&token=2e68c5d6-073a-48ef-81e2-6c738e5de1c6)

### 15\. Web.Config - Log Path

Finally, the last parameter to configure is the Log Path. The default value is the logs subdirectory. If the path of the logs directory is different then enter it here. Also ensure that the service account has ful permissions to the logs director

![Open ca Directory](https://static.guidde.com/v0/qg%2FNF7l8sUngkQmFADnIfgiHyTW9Wk2%2FeCDM3TxKogNcNkgvgYbkqr%2FmzuaLrwNW1z9qbUuXGPKsN_doc.png?alt=media&token=b41647a1-629a-409e-83d9-23c0d1d327f8)

### 16\. Right Click Interface Element

In the IIS Server Manager, let us add the CA Proxy App. Right click on the Sites

![Right Click Interface Element](https://static.guidde.com/v0/qg%2FNF7l8sUngkQmFADnIfgiHyTW9Wk2%2FeCDM3TxKogNcNkgvgYbkqr%2Fc4CabaGyqanLrsTrJbZcpE_doc.png?alt=media&token=bfa2dcf1-b515-42b4-b1b1-a06e10dd59ea)

### 17\. IIS Web Server - Add New Website

Click Add Website to create a new website configuration using the IIS Server Manager

![Add New Website](https://static.guidde.com/v0/qg%2FNF7l8sUngkQmFADnIfgiHyTW9Wk2%2FeCDM3TxKogNcNkgvgYbkqr%2Fdit89WPophcjRBoXwbu6Hu_doc.png?alt=media&token=3f198b4b-2248-4e17-bc12-e7778a18b0e8)

### 18\. Configure Proxy App Website Path Settings

Add the path of the CA Proxy App which in our example is c:\inetpub\caproxyapi

![Configure Website Settings](https://static.guidde.com/v0/qg%2FNF7l8sUngkQmFADnIfgiHyTW9Wk2%2FeCDM3TxKogNcNkgvgYbkqr%2Fup1UNWjX4hiy5kJUAPPhiv_doc.png?alt=media&token=7a3f24fa-6829-42a5-89ef-3d272cd9c1cc)

### 19\. Add Proxy App Website DNS/URL Name

Add the DNS / URL for the site. You may need to add the DNS entry to your DNS server to point to the website

![Select Next Interface Element](https://static.guidde.com/v0/qg%2FNF7l8sUngkQmFADnIfgiHyTW9Wk2%2FeCDM3TxKogNcNkgvgYbkqr%2FoR1oar1fd3sXBwrUaeHf6V_doc.png?alt=media&token=2d3e3f47-4f44-4405-a95e-cf1f23c334cd)

### 20\. Save Settings

Click OK to confirm your settings and continue.

![Confirm with OK Button](https://static.guidde.com/v0/qg%2FNF7l8sUngkQmFADnIfgiHyTW9Wk2%2FeCDM3TxKogNcNkgvgYbkqr%2FfCtzdVycqaquvUU2sVNEFp_doc.png?alt=media&token=ba0b8bf9-affe-44dd-bd43-6849fcf11245)

### 21\. Application Pool

Under the Application Pools; Right Click on the newly created CA proxy api site

![Right Click Interface Element](https://static.guidde.com/v0/qg%2FNF7l8sUngkQmFADnIfgiHyTW9Wk2%2FeCDM3TxKogNcNkgvgYbkqr%2F7FaVNRt3fEVzJradQxSyAW_doc.png?alt=media&token=43b61009-61f0-4942-9a57-e62d60c5765a)

### 22\. Application Pool - Advanced Settings

and select Advanced Setting

![Open Settings Menu](https://static.guidde.com/v0/qg%2FNF7l8sUngkQmFADnIfgiHyTW9Wk2%2FeCDM3TxKogNcNkgvgYbkqr%2FcnZ8BqWrgGY3xvDNSUN5ym_doc.png?alt=media&token=5febf73a-536e-496c-9b0d-536f4f6e2456)

### 23\. Application Pool - Identity

Within the Advanced Settings. Replace the Identity with the service account provisioned earlier

![Click Interface Element](https://static.guidde.com/v0/qg%2FNF7l8sUngkQmFADnIfgiHyTW9Wk2%2FeCDM3TxKogNcNkgvgYbkqr%2FsAQdSRMqCiP9q3pePcULyk_doc.png?alt=media&token=3fc7c607-3cbe-49d5-8a81-51bb609ee12b)

### 24\. Confirm Application Health

Click Response to view the response details.

![Access Response Section](https://static.guidde.com/v0/qg%2FNF7l8sUngkQmFADnIfgiHyTW9Wk2%2FeCDM3TxKogNcNkgvgYbkqr%2F23w49EnRnr5NZ54n8RA3eT_doc.png?alt=media&token=814395f6-45de-4143-9364-587dc6aa0551)

You have successfully deployed the PKI Trust Manager Microsoft CA / ADCS Proxy Gateway by configuring required roles, features, and website settings. Verify the deployment by confirming all configurations and accessing the response section for validation. For more information please visit our website or contact support if you require further assistance

[Powered by **securetron**](https://www.securetron.net)
