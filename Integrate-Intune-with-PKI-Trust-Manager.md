[Integrate Intune with PKI Trust Manager to Issue Certificates to Users, Devices, and Servers](https://youtu.be/IwNKBagTcO0)
=======================================================================================================================================================

[Click here to watch](https://youtu.be/IwNKBagTcO0)

### [![Quick guidde](https://static.guidde.com/v0/qg%2FNF7l8sUngkQmFADnIfgiHyTW9Wk2%2FdrGVy3Ez5dwQLRv6CGkQeA%2FhmPdnBbwRzxzS1fitPDDJg_cover.png?alt=media&token=b911e354-c3bf-464c-ada0-396786f49fc1)](https://youtu.be/IwNKBagTcO0)

This tutorial guides you through fully integrating PKI Trust Manager and Intune to issue certificates to users or devices. The PKI Trust Manager's Intune Integration service should be used instead of Microsoft Network Device Enrollment Service. You will learn how to navigate the interface and configure necessary certificate templates for successful setup.

### 1\. Introduction

Let us begin at the ISSUING Certification Authority that has been previously integrated with PKI Trust Manager using the CA Proxy Gateway. We will Duplicate the "Enrollment Agent" and "CEP" Templates while granting the CA Proxy Gateway Service account Read and Enroll Permissions. In our demo the duplicated templates are named: SCEP-Sign and SCEP-ENC

![Introduction](https://static.guidde.com/v0/qg%2FNF7l8sUngkQmFADnIfgiHyTW9Wk2%2FdrGVy3Ez5dwQLRv6CGkQeA%2FfocKZmBG9VjBknayLkv6zs_doc.png?alt=media&token=4e0b70dd-7c2f-462d-b311-3aadd8608664)

### 2\. Manage Templates

Let us take a closer look. Right Click on Certificate Templates and then click on Manage.

![Manage Templates](https://static.guidde.com/v0/qg%2FNF7l8sUngkQmFADnIfgiHyTW9Wk2%2FdrGVy3Ez5dwQLRv6CGkQeA%2F5WjztR9bik2cGoXH2LEJCD_doc.png?alt=media&token=979ce0d6-ef98-4793-bb53-28c7dcac33fe)

### 3\. Duplicate Templates

Duplicate the CEP Encryption Template as well as the Enrollment Agent Template and name them SCEP-ENC and SCEP-Sign respectively

![Duplicate Templates](https://static.guidde.com/v0/qg%2FNF7l8sUngkQmFADnIfgiHyTW9Wk2%2FdrGVy3Ez5dwQLRv6CGkQeA%2F2THEbsUWJ41mdgsnNWwraM_doc.png?alt=media&token=2c15d022-903b-4888-9f36-91fbd26dea0f)

### 4\. Certificate Template Permissions

Ensure that the both duplicated templates grant the PKI Trust Manager CA Proxy Gateway service account Read and Enroll Permissions.

![Certificate Template Permissions](https://static.guidde.com/v0/qg%2FNF7l8sUngkQmFADnIfgiHyTW9Wk2%2FdrGVy3Ez5dwQLRv6CGkQeA%2F9AgRsZVkswbMqA7bnEsjdJ_doc.png?alt=media&token=99179837-5295-448b-9c86-a397a9176cd1)

### 5\. Add Enrollment and CEP Templates to PKI Trust Manager

Now, over on the PKI Trust Manager Web Admin, Click on Certification Authorities.

![Add Enrollment and CEP Templates to PKI Trust Manager](https://static.guidde.com/v0/qg%2FNF7l8sUngkQmFADnIfgiHyTW9Wk2%2FdrGVy3Ez5dwQLRv6CGkQeA%2FkrDLUhwn557bmEBfEZ8k2d_doc.png?alt=media&token=fe657f42-768d-4489-ae10-fa9568db7788)

### 6\. Certification Authorities Details

Click Details to access the Certification Authority which will be used for SCEP.

![Certification Authorities Details](https://static.guidde.com/v0/qg%2FNF7l8sUngkQmFADnIfgiHyTW9Wk2%2FdrGVy3Ez5dwQLRv6CGkQeA%2FmXbhooY1ssxq3Tue72MajB_doc.png?alt=media&token=ef500950-de94-4668-b6eb-06c2c422fe12)

### 7\. Access Certificate Templates

Click View Templates to see the available certificate templates for configuration.

![Access Certificate Templates](https://static.guidde.com/v0/qg%2FNF7l8sUngkQmFADnIfgiHyTW9Wk2%2FdrGVy3Ez5dwQLRv6CGkQeA%2Fxev6Di4zSSwVm6R6H2Vo5j_doc.png?alt=media&token=ef99b9f2-6cfe-43fc-8307-eb4878e739a0)

### 8\. SCEP Templates

As seen here, We have already published the SCEP-ENC and SCEP-Sign templates on the PKI Trust Manager as well. Proceed by clicking on the "NEW" button on the top-right while we proceed to show the details of how the new template should be configured.

![SCEP Templates](https://static.guidde.com/v0/qg%2FNF7l8sUngkQmFADnIfgiHyTW9Wk2%2FdrGVy3Ez5dwQLRv6CGkQeA%2F5n5KHWuyrwJbmkbNcnSh3w_doc.png?alt=media&token=e249e275-b166-413b-8e48-060b9c89bf75)

### 9\. SCEPEnc Template Configuration

There are three things that need to be configured for SCEP-ENC. 1st is the name of the template that will be displayed on PKI Trust Manager 2nd is the name of the template that we configured on the Certification Authority called SCEP-ENC and 3rd is enabling is Agent Certificate as shown in the screen capture here. Save the template after entering these details.

![SCEPEnc Template Configuration](https://static.guidde.com/v0/qg%2FNF7l8sUngkQmFADnIfgiHyTW9Wk2%2FdrGVy3Ez5dwQLRv6CGkQeA%2FmswXA6ueXs6tUxCHbqRi2i_doc.png?alt=media&token=ca3d6df7-c9d7-4c7f-a799-e9f59f5d0bb6)

### 10\. SCEPSign Template Configuration

For SCEP-Sign There are also three things that need to be configured. 1st is the name of the template that will be displayed on PKI Trust Manager 2nd is the name of the template that we configured on the Certification Authority called SCEP-Sign and 3rd is enabling is Agent Certificate as shown in the screen capture here.

![SCEPSign Template Configuration](https://static.guidde.com/v0/qg%2FNF7l8sUngkQmFADnIfgiHyTW9Wk2%2FdrGVy3Ez5dwQLRv6CGkQeA%2Ff7mCPcx99CvLzdQm8RxA3Z_doc.png?alt=media&token=9cc330a9-c229-4093-b310-2c918a40a1e9)

### 11\. New SCEP Listner

Once the corresponding Enrollment Agent and CEP templates have been provisioned, we are ready to integrate PKI Trust Manager with Intune. Head over to the Integrations page and click the "NEW" button

![New SCEP Listner](https://static.guidde.com/v0/qg%2FNF7l8sUngkQmFADnIfgiHyTW9Wk2%2FdrGVy3Ez5dwQLRv6CGkQeA%2FrdiF2Snr3cZ6vWhKjrCo5b_doc.png?alt=media&token=0733ce0e-03b1-4da9-a9c4-9ecf161fdf2d)

### 12\. New "SCEP4Intune" Integration

In the new integration form, select the appropriate Organization. By default, it is the System Organization. In the Type dropdown menu - select SCEP4Intune

![New 'SCEP4Intune' Integration](https://static.guidde.com/v0/qg%2FNF7l8sUngkQmFADnIfgiHyTW9Wk2%2FdrGVy3Ez5dwQLRv6CGkQeA%2Ft5gQJr8UMRDH2HuAVmF1p1_doc.png?alt=media&token=29f4581a-267d-4d05-b5ec-d8ba26ad903b)

### 13\. SCEP4Intune Integration Configuration

Once SCEP For Intu is selected from the dropdown, the Certificate Configuration should automatically populate. If it does not, ensure that the Certification Authority and its templates are attached to the Organization that was selected above.

![SCEP4Intune Integration Configuration](https://static.guidde.com/v0/qg%2FNF7l8sUngkQmFADnIfgiHyTW9Wk2%2FdrGVy3Ez5dwQLRv6CGkQeA%2FvKPwrEXXbSbPxH1rFYN6eU_doc.png?alt=media&token=6ba61e35-5cf6-4b17-926f-f510ae743726)

### 14\. SCEP4Intune Integration Azure App Registration

The next four fields require information from an Application Registered in Azure specifically for PKI Trust Manager and Intune.

![SCEP4Intune Integration Azure App Registration](https://static.guidde.com/v0/qg%2FNF7l8sUngkQmFADnIfgiHyTW9Wk2%2FdrGVy3Ez5dwQLRv6CGkQeA%2Fk397A19MEQv3E2J4ZGNemJ_doc.png?alt=media&token=8f66c232-169b-4c53-b72e-c00887628da0)

### 15\. Azure: App Registration

Head over to Azure and Go to "App Registration" to register an application. Provide a name for the Application. and then Select "Accounts on this organization directory only".

![Azure: App Registration](https://static.guidde.com/v0/qg%2FNF7l8sUngkQmFADnIfgiHyTW9Wk2%2FdrGVy3Ez5dwQLRv6CGkQeA%2Fd73tYiptHz59z9FKhsRte5_doc.png?alt=media&token=ca2e54e2-84b4-4bcd-944f-27c7cf19f83d)

### 16\. Azure: App ID and Tenant ID

Copy over the Application Client ID AND Directory tenant ID to PKI Trust Manager Scep4Intune configuration.

![Azure: App ID and Tenant ID](https://static.guidde.com/v0/qg%2FNF7l8sUngkQmFADnIfgiHyTW9Wk2%2FdrGVy3Ez5dwQLRv6CGkQeA%2FeGgkmBUZQJK2GogaPXsBbq_doc.png?alt=media&token=688c2d7e-7561-4abe-bf22-0cee3adf02ca)

### 17\. Azure: App Certificates & Secrets

Next, on the left navigation bar - click on Certificates and secret

![Azure: App Certificates & Secrets](https://static.guidde.com/v0/qg%2FNF7l8sUngkQmFADnIfgiHyTW9Wk2%2FdrGVy3Ez5dwQLRv6CGkQeA%2FiAKMUVonNPUWtoPu2mBmqW_doc.png?alt=media&token=57a64a25-fc71-4c7f-b889-f809cd641e14)

### 18\. Azure: App New Secret

Click on "New Client Secret" to provision a New Secret. Then subsequently, copy the Value of the newly created Secret to PKI Trust Manager under Azure Intune App Key field

![Azure: App New Secret](https://static.guidde.com/v0/qg%2FNF7l8sUngkQmFADnIfgiHyTW9Wk2%2FdrGVy3Ez5dwQLRv6CGkQeA%2FhYdwxFZXg5bEQnt68wb2sZ_doc.png?alt=media&token=27fa5b07-fd6e-406c-aa9e-e284d202f2ee)

### 19\. Azure: App API Permissions

Finally, we will need to provide the Registered App appropriate permissions. Navigate to API Permissions.

![Azure: App API Permissions](https://static.guidde.com/v0/qg%2FNF7l8sUngkQmFADnIfgiHyTW9Wk2%2FdrGVy3Ez5dwQLRv6CGkQeA%2FfT66Aq7nDuPUJpnPYexDuX_doc.png?alt=media&token=c1b3dd36-85b0-4118-8d2f-8eac4dc2e7ad)

### 20\. Azure: App Add a Permission

Then click on "Add a permission". This should open a window with further options.

![Azure: App Add a Permission](https://static.guidde.com/v0/qg%2FNF7l8sUngkQmFADnIfgiHyTW9Wk2%2FdrGVy3Ez5dwQLRv6CGkQeA%2F2pDMsTgbGwNRdd739yJN4s_doc.png?alt=media&token=59001809-77be-4d8a-9bb4-232f9bb72db8)

### 21\. Azure: App Request API Permission

Click on Intune box in this window

![Azure: App Request API Permission](https://static.guidde.com/v0/qg%2FNF7l8sUngkQmFADnIfgiHyTW9Wk2%2FdrGVy3Ez5dwQLRv6CGkQeA%2F1qSgJB25yjbgdfHjrkCv7X_doc.png?alt=media&token=54d5cfdb-abc0-4dd8-9032-71cab9d21a28)

### 22\. Azure: App - Intune App Permissions

Now, click on "Application permissions" to proceed

![Azure: App - Intune App Permissions](https://static.guidde.com/v0/qg%2FNF7l8sUngkQmFADnIfgiHyTW9Wk2%2FdrGVy3Ez5dwQLRv6CGkQeA%2FmaFAo8s1m2oE3wjM1G5QDQ_doc.png?alt=media&token=0b829d65-f7f3-4d57-b4d1-28f24b98d6ea)

### 23\. Azure: App - Intune App Permissions

inally, select SCEP Challenge Provider OR SCEP Challenge Validation as shown here. Save the permissions

![Azure: App - Intune App Permissions](https://static.guidde.com/v0/qg%2FNF7l8sUngkQmFADnIfgiHyTW9Wk2%2FdrGVy3Ez5dwQLRv6CGkQeA%2F3K6eeB8P6CvBTGG5VdzBKc_doc.png?alt=media&token=adb49f9e-1e42-4af8-b725-21b89ef4204b)

### 24\. Azure: App - New Microsoft Graph Permissions

Let's repeat and add the appropriate Microsoft Graph Permissions to this newly registered application. Click on "Add a permission" followed by "Microsoft Graph" as shown here

![Azure: App - New Microsoft Graph Permissions](https://static.guidde.com/v0/qg%2FNF7l8sUngkQmFADnIfgiHyTW9Wk2%2FdrGVy3Ez5dwQLRv6CGkQeA%2Fujex6ia88j8W92Vo8VzpoV_doc.png?alt=media&token=be21df13-1095-4d14-a594-44312d52ea78)

### 25\. Azure: App Microsoft Graph Read All

Then select "Application permission". This will provide list of permissions that can be granted. Expand the Application drawer and subsequently select "Application Read All"

![Azure: App Microsoft Graph Read All](https://static.guidde.com/v0/qg%2FNF7l8sUngkQmFADnIfgiHyTW9Wk2%2FdrGVy3Ez5dwQLRv6CGkQeA%2F9tMbh552wAJrGxywvgoQyk_doc.png?alt=media&token=7790527e-1c14-4b41-856d-f0bf303afa47)

### 26\. Azure: App - Grant Admin Consent

The last step here is to "Grant admin Consent". This is required for the permissions to work correctly.

![Azure: App - Grant Admin Consent](https://static.guidde.com/v0/qg%2FNF7l8sUngkQmFADnIfgiHyTW9Wk2%2FdrGVy3Ez5dwQLRv6CGkQeA%2Fvsn5ZhTQXcMSgGg4f4nPYu_doc.png?alt=media&token=456105ff-5b29-4f35-94b3-107d536bba8c)

### 27\. Azure: New Secret

Once "admin consent" has been granted, you should see the status turn gree

![Azure: New Secret](https://static.guidde.com/v0/qg%2FNF7l8sUngkQmFADnIfgiHyTW9Wk2%2FdrGVy3Ez5dwQLRv6CGkQeA%2FgXZ2GHxtEXq97RVt8StkZR_doc.png?alt=media&token=2c248e58-125b-4043-88cf-0f1ccc1b3a90)

### 28\. Azure: New Secret

This completes the Azure App registration. Next, we will complete the configuration on the PKI Trust Manager.

![Azure: New Secret](https://static.guidde.com/v0/qg%2FNF7l8sUngkQmFADnIfgiHyTW9Wk2%2FdrGVy3Ez5dwQLRv6CGkQeA%2Fh2agCEcmrLHQANiNxrxiXR_doc.png?alt=media&token=eadc8207-8baa-41c8-9134-da9be874ef79)

### 29\. SCEP4Intune Configuration

Populate the fields corresponding to the values from Azure Application for PKI Trust Manager and Intune integration. Let's validate them

![SCEP4Intune Configuration](https://static.guidde.com/v0/qg%2FNF7l8sUngkQmFADnIfgiHyTW9Wk2%2FdrGVy3Ez5dwQLRv6CGkQeA%2F5uNxhcrfrXkWeDzHbDPUtP_doc.png?alt=media&token=85fcd88d-759e-4af0-a374-9941e6cbbba6)

### 30\. SCEP4Intune App-Name

Provide a Name for the app.

![SCEP4Intune App-Name](https://static.guidde.com/v0/qg%2FNF7l8sUngkQmFADnIfgiHyTW9Wk2%2FdrGVy3Ez5dwQLRv6CGkQeA%2F5p9iQmc3pEWpEGAHCRTdnC_doc.png?alt=media&token=8c821028-e214-47df-ae2b-c69cf85ec280)

### 31\. SCEP4Intune Certificate Config

The Signing Certificate and Encryption Certificate should be auto-populate

![SCEP4Intune Certificate Config](https://static.guidde.com/v0/qg%2FNF7l8sUngkQmFADnIfgiHyTW9Wk2%2FdrGVy3Ez5dwQLRv6CGkQeA%2F6b9pPTDweBGHcbLeHVywu1_doc.png?alt=media&token=cbc4bd57-ce64-44ad-ab1c-a8629cdaf7f6)

### 32\. SCEP4Intune Azure App-ID

The Azure App ID corresponds to the Application-ID of the Registered Azure App

![SCEP4Intune Azure App-ID](https://static.guidde.com/v0/qg%2FNF7l8sUngkQmFADnIfgiHyTW9Wk2%2FdrGVy3Ez5dwQLRv6CGkQeA%2FqEuQ8GeiB6tvSsuLCddyqd_doc.png?alt=media&token=d46c7f87-d531-4690-afcd-2d492bb50bf9)

### 33\. SCEP4Intune Azure App Secret Value

The Azure Intune App Key corresponds to the Secret Value of the registered Azure App

![SCEP4Intune Azure App Secret Value](https://static.guidde.com/v0/qg%2FNF7l8sUngkQmFADnIfgiHyTW9Wk2%2FdrGVy3Ez5dwQLRv6CGkQeA%2F6fnc778ioHBjfeZ2KA5kVx_doc.png?alt=media&token=d091121a-76ae-48d3-899e-b1293e2107e7)

### 34\. SCEP4Intune Azure Tenant ID

The Azure Intune Tenant ID corresponds to the Azure Tenant ID

![SCEP4Intune Azure Tenant ID](https://static.guidde.com/v0/qg%2FNF7l8sUngkQmFADnIfgiHyTW9Wk2%2FdrGVy3Ez5dwQLRv6CGkQeA%2F9ecjJYfe3yYABa4x8soewP_doc.png?alt=media&token=2b7c84d6-e38d-48bf-b016-45a14de773a1)

### 35\. SCEP4Intune Version

The Azure Intune Provisioning Name and Version should be set to 2.0

![SCEP4Intune Version](https://static.guidde.com/v0/qg%2FNF7l8sUngkQmFADnIfgiHyTW9Wk2%2FdrGVy3Ez5dwQLRv6CGkQeA%2FeK3AQQXPAPdfYnHseLRNRG_doc.png?alt=media&token=c5c1ecbf-aff0-4d55-8327-783e514c35bd)

### 36\. SCEP4Intune Certificate Template

Select a Template that will be used to issue Certificates through Intune Integration

![SCEP4Intune Certificate Template](https://static.guidde.com/v0/qg%2FNF7l8sUngkQmFADnIfgiHyTW9Wk2%2FdrGVy3Ez5dwQLRv6CGkQeA%2FxufMxU89ZYPZVUwSHrFyKm_doc.png?alt=media&token=c869fae7-ba94-443e-a987-1666ff1bc426)

### 37\. SCEP4Intune URL

Enter the URL of the PKI Trust CERT API Container Service

![SCEP4Intune URL](https://static.guidde.com/v0/qg%2FNF7l8sUngkQmFADnIfgiHyTW9Wk2%2FdrGVy3Ez5dwQLRv6CGkQeA%2Fq7HgARapafyMZPATTNEo2j_doc.png?alt=media&token=e81f7d63-a0a4-4955-9668-7c7fa4f537e7)

### 38\. SCEP4Intune Save

Now, that we have validate the configuration - let's save to publish the SCEP4Intune Service and have it enabled. In the next video we will cover the steps on Intune Admin Console to integrate with PKI Trust Manager Platform.

![SCEP4Intune Save](https://static.guidde.com/v0/qg%2FNF7l8sUngkQmFADnIfgiHyTW9Wk2%2FdrGVy3Ez5dwQLRv6CGkQeA%2FqG44dkURHJ6GiNxNZdzmSM_doc.png?alt=media&token=97c8ef86-4fe4-4790-8458-ec46c6d764e0)

### 39\. Intune Admin - SCEP and Trusted Certificate Configuration

Let's complete the setup by setting up Intune side of the configuration. Head over to the Intune Admin center.

![Intune Admin - SCEP and Trusted Certificate Configuration](https://static.guidde.com/v0/qg%2FNF7l8sUngkQmFADnIfgiHyTW9Wk2%2FdrGVy3Ez5dwQLRv6CGkQeA%2FvJMv9WJgqRyVn1Ecncpoo9_doc.png?alt=media&token=0ee22f33-2169-40b6-836c-bdfd18ac476d)

### 40\. Intune: Device Configuration

Click on "Devices" from the left navigation bar and then access the Devices Configuration as shown here

![Intune: Device Configuration](https://static.guidde.com/v0/qg%2FNF7l8sUngkQmFADnIfgiHyTW9Wk2%2FdrGVy3Ez5dwQLRv6CGkQeA%2FhnuXDW92FJoDxy4s56jfQm_doc.png?alt=media&token=ad8780da-241e-4bb6-8f56-dd996b9bc26f)

### 41\. Intune: Device Configuration - New Policy

Create a new Policy

![Intune: Device Configuration - New Policy](https://static.guidde.com/v0/qg%2FNF7l8sUngkQmFADnIfgiHyTW9Wk2%2FdrGVy3Ez5dwQLRv6CGkQeA%2F5AqD9gQG2ephsZGUKHfvuC_doc.png?alt=media&token=3b3b81fa-a45e-446b-86a4-7a8bb560a92e)

### 42\. Intune: Device Configuration - Platform

Choose a platform where you want this configuration applied. You can enroll certificates to any platform support via intune including Windows, Android, and iOS

![Intune: Device Configuration - Platform](https://static.guidde.com/v0/qg%2FNF7l8sUngkQmFADnIfgiHyTW9Wk2%2FdrGVy3Ez5dwQLRv6CGkQeA%2FdWk9H9f4ev6d56Q3ZUPsVf_doc.png?alt=media&token=ee557a78-45fb-464c-9b38-a1458bc8c0ac)

### 43\. Intune: Device Configuration - Profile Type

Next, select Templates from the available Profile type

![Intune: Device Configuration - Profile Type](https://static.guidde.com/v0/qg%2FNF7l8sUngkQmFADnIfgiHyTW9Wk2%2FdrGVy3Ez5dwQLRv6CGkQeA%2FuxgeMmTMcHutEgsosiMFiB_doc.png?alt=media&token=ab888323-cd16-4eb5-b8c1-ed773ae3950e)

### 44\. Intune: Device Configuration - Trusted Certificate

Now select the Trusted Certificate from the list of templates available.

![Intune: Device Configuration - Trusted Certificate](https://static.guidde.com/v0/qg%2FNF7l8sUngkQmFADnIfgiHyTW9Wk2%2FdrGVy3Ez5dwQLRv6CGkQeA%2F2u4pzY4R37Ts99UtT1ZMF2_doc.png?alt=media&token=b3a5cbed-3921-4e50-8d86-f5748633ed1e)

### 45\. Intune: Trusted Certificate - Name of Config

Begin by giving the configuration profile a name

![Intune: Trusted Certificate - Name of Config](https://static.guidde.com/v0/qg%2FNF7l8sUngkQmFADnIfgiHyTW9Wk2%2FdrGVy3Ez5dwQLRv6CGkQeA%2FiP3xn3iSJW8DtJX5TBJTpK_doc.png?alt=media&token=189a0018-5abf-433a-b542-6120d0ba4080)

### 46\. Intune: Trusted Certificate - ROOT Certificate Upload

Next, Upload the Root certificate file. This will be required to build the Certification Authority Chain and ensure that any certificates issued to the devices is trusted.

![Intune: Trusted Certificate - ROOT Certificate Upload](https://static.guidde.com/v0/qg%2FNF7l8sUngkQmFADnIfgiHyTW9Wk2%2FdrGVy3Ez5dwQLRv6CGkQeA%2F3CGvc9W4CcQJdmXsJyZSyC_doc.png?alt=media&token=e6865909-e726-474a-96a5-db824a917cef)

### 47\. Intune: Trusted Certificate - Computer Certificate Root Store

Next, Ensure that the destination store is set as Computer Certificate Store - Root

![Intune: Trusted Certificate - Computer Certificate Root Store](https://static.guidde.com/v0/qg%2FNF7l8sUngkQmFADnIfgiHyTW9Wk2%2FdrGVy3Ez5dwQLRv6CGkQeA%2F6CFP9pM46NzWEQmJYNCJ8F_doc.png?alt=media&token=9a599d40-972c-4051-ae05-1390b30d2270)

### 48\. Intune: Trusted Certificate Assignment

Add a group containing the in-scope devices or apply this configuration to all the devices by selecting "Add all devices". Finish creating this configuration.

![Intune: Trusted Certificate Assignment](https://static.guidde.com/v0/qg%2FNF7l8sUngkQmFADnIfgiHyTW9Wk2%2FdrGVy3Ez5dwQLRv6CGkQeA%2F8GU2j41NraPDYTL37E5EKo_doc.png?alt=media&token=97614276-ede3-4dd7-9f51-3643042981c4)

### 49\. Intune: Intermediate / Issuing Certificate

Now that we have completed provisioning the configuration for Trusted ROOT Certificate, repeat the steps for Intermediate Certification Authority that will be issuing certificates. Ensure that for this profile to set Destination Store to Computer Certificate store - Intermediate.

![Intune: Intermediate / Issuing Certificate](https://static.guidde.com/v0/qg%2FNF7l8sUngkQmFADnIfgiHyTW9Wk2%2FdrGVy3Ez5dwQLRv6CGkQeA%2FhB6DqRVJr4xVMuXBtQpEc5_doc.png?alt=media&token=c0553d4c-22ff-4542-936a-d536e7d4b8d2)

### 50\. Intune: SCEP Certificate Template

As the final step, we will be provisioning the SCEP Certificate Profile. This profile will use the PKI Trust Cert API URL previously configured to request certificates and enroll devices

![Intune: SCEP Certificate Template](https://static.guidde.com/v0/qg%2FNF7l8sUngkQmFADnIfgiHyTW9Wk2%2FdrGVy3Ez5dwQLRv6CGkQeA%2FjSpouHvkRfuwMhTo2kEcey_doc.png?alt=media&token=34afe542-2fdd-42c8-8468-9b20c929ce57)

### 51\. Intune: SCEP Certificate Profile Name

Provide a name for the SCEP Profile used to provision user or device certificates to endpoints

![Intune: SCEP Certificate Profile Name](https://static.guidde.com/v0/qg%2FNF7l8sUngkQmFADnIfgiHyTW9Wk2%2FdrGVy3Ez5dwQLRv6CGkQeA%2F65qRWKKyvHAxPUXSAqKuE2_doc.png?alt=media&token=933df92d-3050-41f8-8e76-fd2568fc6921)

### 52\. Intune: SCEP Certificate Profile Certificate Type

Select the type of Certificate that will be issued. This should be the same that has been configured on PKI Trust Manager

![Intune: SCEP Certificate Profile Certificate Type](https://static.guidde.com/v0/qg%2FNF7l8sUngkQmFADnIfgiHyTW9Wk2%2FdrGVy3Ez5dwQLRv6CGkQeA%2FfWuqVajgZ6FdUkGYzc6qpG_doc.png?alt=media&token=c1d809e0-9b93-4dea-98f1-178fa568307c)

### 53\. Intune: SCEP Certificate Subject Name

Provide a Subject name that will be used for certificates that are issued. You may use the default settings here

![Intune: SCEP Certificate Subject Name](https://static.guidde.com/v0/qg%2FNF7l8sUngkQmFADnIfgiHyTW9Wk2%2FdrGVy3Ez5dwQLRv6CGkQeA%2F26jiX7MHQEQ63BgfJeJWXp_doc.png?alt=media&token=13e47030-ed3c-42bf-9a6e-3fa2e8024def)

### 54\. Intune: SCEP Certificate SAN

The Subject alternative name should be configured. In addition to email or hostname, you will need to set URI to On premises Security Identifier. This is required for Strong Certificate Mapping.

![Intune: SCEP Certificate SAN](https://static.guidde.com/v0/qg%2FNF7l8sUngkQmFADnIfgiHyTW9Wk2%2FdrGVy3Ez5dwQLRv6CGkQeA%2Fs2sZ7A9VLWBMWreyeYpxam_doc.png?alt=media&token=5ce9015e-9d4b-48ac-b0b8-8b10dbfd2e33)

### 55\. Intune: SCEP Server URL

At the bottom of the configuration, The SCEP Server URL should be as shown where it begins with https and ends with forward slash SCEP

![Intune: SCEP Server URL](https://static.guidde.com/v0/qg%2FNF7l8sUngkQmFADnIfgiHyTW9Wk2%2FdrGVy3Ez5dwQLRv6CGkQeA%2F73BKQxM59mP5hNJAviZm5p_doc.png?alt=media&token=3076bfd8-8ff4-4ac5-92f4-b341a09a1c85)

### 56\. Intune: SCEP Certificate Configuration

Complete rest of the configuration as shown or as required by your organization Certificate Policy including adding the previously provisioned ROOT Certificate Profile.

![Intune: SCEP Certificate Configuration](https://static.guidde.com/v0/qg%2FNF7l8sUngkQmFADnIfgiHyTW9Wk2%2FdrGVy3Ez5dwQLRv6CGkQeA%2Fajg8JyXufxx7QA1yn5vbbC_doc.png?alt=media&token=623900e2-7278-4606-a301-a5f94da991a9)

Congratulations!, You have successfully enabled the SCEP4Intune Service in the PKI Trust Manager by configuring the necessary certificate templates and settings as well as configuring Intune to fully integrate with PKI Trust Manager. This completes the setup of integrating Intune and successfully issuing Certificates to devices. If you require more information, please refer to the documentation or contact support

[Powered by **securetron**](https://securetron.net)
