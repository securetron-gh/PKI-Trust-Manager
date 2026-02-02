[Enable SCEP Service in PKI Trust Manager](https://youtu.be/2iZgG3RiGg8)
===================================================================================================

[Click here to watch](https://youtu.be/2iZgG3RiGg8)

### [![Quick guidde](https://static.guidde.com/v0/qg%2FNF7l8sUngkQmFADnIfgiHyTW9Wk2%2FviXvCCeuVqQjpR2Zh8BtyE%2FfbDd6tURC6Kx7pLC5Zsato_cover.png?alt=media&token=b4416cb7-cf01-43ce-a6ba-9f7568bc32fb)](https://youtu.be/2iZgG3RiGg8)

This tutorial guides you through enabling the SCEP Service within the PKI Trust Manager. The PKI Trust Manager SCEP service should be used instead of Microsoft Network Device Enrollment Service. You will learn how to navigate the interface and configure necessary certificate templates for successful setup.

#### Prerequisites:
* [How to Publish a Certificate Template in PKI Trust Manager](https://securetron.net/issue-certificate-using-pki-trust-manager-web-interface/)
* [How to Deploy Microsoft CA / AD CS Proxy Gateway](https://securetron.net/integrate-pki-trust-manager-with-microsoft-certificate-authority-proxy-gateway/)
* [How to Deploy CertAPI Container on Azure](https://securetron.net/deploy-securetron-pki-trust-manager-certapi-to-azure-cloud-scep-est-acme/)
* [How to Deploy PKI Trust Mananger](https://securetron.net/pki-trust-manager-deployment-on-azure-as-a-container-app/)

### 1\. Introduction

Let us begin at the ISSUING Certification Authority that has been previously integrated with PKI Trust Manager using the CA Proxy Gateway. We will Duplicate the "Enrollment Agent" and "CEP" Templates while granting the CA Proxy Gateway Service account Read and Enroll Permissions. In our demo the duplicated templates are named: SCEP-Sign and SCEP-ENC

![Introduction](https://static.guidde.com/v0/qg%2FNF7l8sUngkQmFADnIfgiHyTW9Wk2%2FviXvCCeuVqQjpR2Zh8BtyE%2FmdsD53gBebdGMfykWCcjNk_doc.png?alt=media&token=b68253f3-07f2-4ddc-afdc-bb82a8abf4ac)

  

### 2\. Manage Templates

Let us take a closer look. Right Click on Certificate Templates and then click on Manage.

![Manage Templates](https://static.guidde.com/v0/qg%2FNF7l8sUngkQmFADnIfgiHyTW9Wk2%2FviXvCCeuVqQjpR2Zh8BtyE%2FcKT8hrQ2zQCssEiwQDu2R4_doc.png?alt=media&token=7ac5953f-c4dd-4359-a311-6b636b000e7e)

### 3\. Duplicate Templates

Duplicate the CEP Encryption Template as well as the Enrollment Agent Template and name them SCEP-ENC and SCEP-Sign respectively

![Duplicate Templates](https://static.guidde.com/v0/qg%2FNF7l8sUngkQmFADnIfgiHyTW9Wk2%2FviXvCCeuVqQjpR2Zh8BtyE%2Fqrzz7zwaFkoK1XuELQQV1c_doc.png?alt=media&token=1b6c9740-404a-4a21-bc24-e0e8aff0fee7)

### 4\. Certificate Template Permissions

Ensure that the both duplicated templates grant the PKI Trust Manager CA Proxy Gateway service account Read and Enroll Permissions.

![Certificate Template Permissions](https://static.guidde.com/v0/qg%2FNF7l8sUngkQmFADnIfgiHyTW9Wk2%2FviXvCCeuVqQjpR2Zh8BtyE%2F2jSM9KTgzQZTxfm93CLMTm_doc.png?alt=media&token=a305b55b-f23f-4f1f-a8b3-e3a59f439601)

### 5\. Add Enrollment and CEP Templates to PKI Trust Manager

Now, over on the PKI Trust Manager Web Admin, Click on Certification Authorities.

![Add Enrollment and CEP Templates to PKI Trust Manager](https://static.guidde.com/v0/qg%2FNF7l8sUngkQmFADnIfgiHyTW9Wk2%2FviXvCCeuVqQjpR2Zh8BtyE%2FgQWDpq37vRjFQdaNfqLBUU_doc.png?alt=media&token=bc60f241-e045-42ac-b056-a8a3f71a980c)

### 6\. Certification Authorities Details

Click Details to access the Certification Authority which will be used for SCEP.

![Certification Authorities Details](https://static.guidde.com/v0/qg%2FNF7l8sUngkQmFADnIfgiHyTW9Wk2%2FviXvCCeuVqQjpR2Zh8BtyE%2F8cCgpim3WDzzCPX9tPQdBt_doc.png?alt=media&token=9cf61663-1ab2-4a0c-bd60-a27275065b70)

### 7\. Access Certificate Templates

Click View Templates to see the available certificate templates for configuration.

![Access Certificate Templates](https://static.guidde.com/v0/qg%2FNF7l8sUngkQmFADnIfgiHyTW9Wk2%2FviXvCCeuVqQjpR2Zh8BtyE%2FsPoYkhnxhj4N6YobVsVvTn_doc.png?alt=media&token=32d53525-5c4f-4003-861b-3d4583007d43)

### 8\. SCEP Templates

As seen here, We have already published the SCEP-ENC and SCEP-Sign templates on the PKI Trust Manager as well. Proceed by clicking on the "NEW" button on the top-right while we proceed to show the details of how the new template should be configured.

![SCEP Templates](https://static.guidde.com/v0/qg%2FNF7l8sUngkQmFADnIfgiHyTW9Wk2%2FviXvCCeuVqQjpR2Zh8BtyE%2FcSfg8T6nWnSxm3RpxBUtJN_doc.png?alt=media&token=0989fee4-d538-442a-9da9-cbfa3728c519)

### 9\. SCEPEnc Template Configuration

There are three things that need to be configured for SCEP-ENC. 1st is the name of the template that will be displayed on PKI Trust Manager 2nd is the name of the template that we configured on the Certification Authority called SCEP-ENC and 3rd is enabling is Agent Certificate as shown in the screen capture here. Save the template after entering these details.

![SCEPEnc Template Configuration](https://static.guidde.com/v0/qg%2FNF7l8sUngkQmFADnIfgiHyTW9Wk2%2FviXvCCeuVqQjpR2Zh8BtyE%2FbH6dBy3kugz9WoU65vRJNT_doc.png?alt=media&token=73e4a128-1649-4cb6-9e6f-61ef26e9cc0e)

### 10\. SCEPSign Template Configuration

For SCEP-Sign There are also three things that need to be configured. 1st is the name of the template that will be displayed on PKI Trust Manager 2nd is the name of the template that we configured on the Certification Authority called SCEP-Sign and 3rd is enabling is Agent Certificate as shown in the screen capture here.

![SCEPSign Template Configuration](https://static.guidde.com/v0/qg%2FNF7l8sUngkQmFADnIfgiHyTW9Wk2%2FviXvCCeuVqQjpR2Zh8BtyE%2Fnn8wFxaL3BnFM2YBbHWV41_doc.png?alt=media&token=e7a48671-521f-4523-a2c7-f72f88a08194)

### 11\. New SCEP Listner

Once the corresponding Enrollment Agent and CEP templates have been provisioned, we will need to create a SCEP Listener Endpoint. Head over to the Integrations page and click the "NEW" butto

![New SCEP Listner](https://static.guidde.com/v0/qg%2FNF7l8sUngkQmFADnIfgiHyTW9Wk2%2FviXvCCeuVqQjpR2Zh8BtyE%2F46RWYK7nBmLtwbgzp3N7Rd_doc.png?alt=media&token=2bcc71e2-5af9-4afa-8003-a414327cb710)

### 12\. New "SCEP" Integration

In the new integration form, select the appropriate Organization. By default, it is the System Organization. In the Type dropdown menu - select SCEP.

![New 'SCEP' Integration](https://static.guidde.com/v0/qg%2FNF7l8sUngkQmFADnIfgiHyTW9Wk2%2FviXvCCeuVqQjpR2Zh8BtyE%2Fab37V31v2eex55884NFx83_doc.png?alt=media&token=3fb2db45-9967-4399-8738-d9341d99d385)

### 13\. SCEP Integration Configuration

Once SCEP is selected from the dropdown, the Certificate Configuration should automatically populate. If it does not, ensure that the Certification Authority and its templates are attached to the Organization that was selected above.

![SCEP Integration Configuration](https://static.guidde.com/v0/qg%2FNF7l8sUngkQmFADnIfgiHyTW9Wk2%2FviXvCCeuVqQjpR2Zh8BtyE%2Fa6EUGi3oiTtq7VeR2BMxep_doc.png?alt=media&token=59dc4979-a7c2-48c9-8b52-23ee0df5602b)

### 14\. SCEP Interface Name

Proceed to provide it a Name and select the Certificate Template that will be used by theSCEP interface.

![SCEP Interface Name](https://static.guidde.com/v0/qg%2FNF7l8sUngkQmFADnIfgiHyTW9Wk2%2FviXvCCeuVqQjpR2Zh8BtyE%2FboFT6d782wh3AoJk4TWopq_doc.png?alt=media&token=7f1f2433-be06-491e-ac0d-36fecb1edc2c)

### 15\. SCEP Certificate Template

Select a template to fulfill the Certificate Requests. In our demo, we will utilize the previously provisioned user template.

![SCEP Certificate Template](https://static.guidde.com/v0/qg%2FNF7l8sUngkQmFADnIfgiHyTW9Wk2%2FviXvCCeuVqQjpR2Zh8BtyE%2FpNJf1rQArykeyWZ8iyDMcg_doc.png?alt=media&token=9567c767-ec4f-4f93-995d-d6181e893841)

### 16\. SCEP URL

Please provide a resolvable URL for the CERT API Container. This URL must be unique and can be a CNAME or an Alias that directs to the CERT API Container

![SCEP URL](https://static.guidde.com/v0/qg%2FNF7l8sUngkQmFADnIfgiHyTW9Wk2%2FviXvCCeuVqQjpR2Zh8BtyE%2F7Cobjzj7WjtRrZhDim87zn_doc.png?alt=media&token=da3346b1-feda-4fbc-a8c1-c17c56dffdc7)

### 17\. SCEP Challenge Password

Now that you have successfully configured the SCEP Interface, let us proceed to obtain the SCEP Challenge Password. The SCEP Challenge Password in PKI Trust Manager is associated with a user. You can utilize either an Organization Admin User or a Service User Account specifically designated for SCEP. In this demonstration, we will use the existing user to retrieve its SCEP Challenge Password.

![SCEP Challenge Password](https://static.guidde.com/v0/qg%2FNF7l8sUngkQmFADnIfgiHyTW9Wk2%2FviXvCCeuVqQjpR2Zh8BtyE%2F7pNtET7mvMoUQcpGSTnnEt_doc.png?alt=media&token=f96e2d72-47dd-4331-903f-546ff89434f5)

### 18\. Generate SCEP Challenge Password

In the User Profile, click on SCEP Password to generate and retrieve the password for the SCEP service.

![Generate SCEP Challenge Password](https://static.guidde.com/v0/qg%2FNF7l8sUngkQmFADnIfgiHyTW9Wk2%2FviXvCCeuVqQjpR2Zh8BtyE%2F8Bc2FuUboRe75bevsyfssq_doc.png?alt=media&token=92f3549a-37ba-4de7-8a5a-fb34d5178244)

### 19\. SCEP Challenge Password - One Time Code

This will display a window containing the Challenge Password along with its validity period, as specified in the Environment variable of the Container. Utilize this Challenge Password to enroll Network Devices, MDM, or any other service that employs the standard SCEP.

![SCEP Challenge Password - One Time Code](https://static.guidde.com/v0/qg%2FNF7l8sUngkQmFADnIfgiHyTW9Wk2%2FviXvCCeuVqQjpR2Zh8BtyE%2F5qVnXYFh3aB7QWfL6Ao8gx_doc.png?alt=media&token=7247c587-9853-4e8f-8b62-665b0ae5ab4f)

Congratulations!, You have successfully enabled the SCEP Service in the PKI Trust Manager by configuring the necessary certificate templates and settings. If you require more information, please refer to the documentation or contact support

[Powered by **Securetron**](https://securetron.net)
