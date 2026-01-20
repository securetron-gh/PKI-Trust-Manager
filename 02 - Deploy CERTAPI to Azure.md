[Deploy Securetron PKI Trust Manager CertAPI To Azure Cloud](https://www.youtube.com/watch?v=uCbIZeZQxsY)
=====================================================================================================================

[Click here to watch](https://www.youtube.com/watch?v=uCbIZeZQxsY)

### [![Quick guidde](https://static.guidde.com/v0/qg%2FNF7l8sUngkQmFADnIfgiHyTW9Wk2%2F8CJdpoxk8kUtwBGnaRqeSY%2F769Q4QQ365EFLbUADNwW7i_cover.png?alt=media&token=b5913cf8-71ad-4220-b8c5-ad645ca1a401)](https://app.guidde.com/share/playbooks/8CJdpoxk8kUtwBGnaRqeSY)

This tutorial guides you through deploying the Securetron PKI Trust Manager CertAPI to the Azure Cloud environment. You will configure container app settings, registry details, ingress rules, and complete the deployment process. The Cert API provides SCEP, EST, ACME, and RESTful API interface for automation

### Azure Portal

### 1\. Select Container App Option

Click the Container App option to initiate creating a new container application.

![Select Container App Option](https://static.guidde.com/v0/qg%2FNF7l8sUngkQmFADnIfgiHyTW9Wk2%2F8CJdpoxk8kUtwBGnaRqeSY%2FpMzQWc91GyJ4awuGDPqyB3_doc.png?alt=media&token=676fec55-bc47-4829-a74b-02ec796656fa)

### 2\. Access Container App Name Field

Click the container app name field to specify the name for your new container app. Enter your container app name to identify the deployment such as pki-trust-manager-cert-api

![Access Container App Name Field](https://static.guidde.com/v0/qg%2FNF7l8sUngkQmFADnIfgiHyTW9Wk2%2F8CJdpoxk8kUtwBGnaRqeSY%2FfEYrj2atNHohifMuiVWDuy_doc.png?alt=media&token=aaea226a-f02c-454e-b7ed-64587f463c90)

### 3\. Proceed To Container Settings

Click Next to move forward to configuring container-specific settings.

![Proceed To Container Settings](https://static.guidde.com/v0/qg%2FNF7l8sUngkQmFADnIfgiHyTW9Wk2%2F8CJdpoxk8kUtwBGnaRqeSY%2FqUx1mLMv994Lc3PTKuEeP5_doc.png?alt=media&token=3d46d1dd-d3c8-4449-9344-fae54fcd0926)

### 4\. Registry Login Server

Enter the registry login server address, such as securetron.azurecr.io to connect to the securetron container registry.

![Registry Login Server](https://static.guidde.com/v0/qg%2FNF7l8sUngkQmFADnIfgiHyTW9Wk2%2F8CJdpoxk8kUtwBGnaRqeSY%2F19vfpFLMaXa6DXfCQ6cNTs_doc.png?alt=media&token=539212fd-9d95-4da0-b0bd-55496c8f54bd)

### 5\. Image & Tag

Enter the Image and Tag such as Cert APIEE:Latest

![Image & Tag](https://static.guidde.com/v0/qg%2FNF7l8sUngkQmFADnIfgiHyTW9Wk2%2F8CJdpoxk8kUtwBGnaRqeSY%2FjLCuwV6XNHZYPk3B9AdSmx_doc.png?alt=media&token=2e7226ff-83ae-45df-b2b5-ac2cf9c22425)

### 6\. Choose .NET Stack

Select the .NET development stack to optimize the container.

![Choose .NET Stack](https://static.guidde.com/v0/qg%2FNF7l8sUngkQmFADnIfgiHyTW9Wk2%2F8CJdpoxk8kUtwBGnaRqeSY%2FdMz7oW9qVmjzLjz2C6cxYV_doc.png?alt=media&token=7cb81913-ec3a-496e-bf87-0bcf1c468bdf)

### 7\. Environment Variables

Enter the Environment variables such as ConnectionStrings\_\_OurDBContext, to link your app to the database. Additional variables are listed in the document.

![Environment Variables](https://static.guidde.com/v0/qg%2FNF7l8sUngkQmFADnIfgiHyTW9Wk2%2F8CJdpoxk8kUtwBGnaRqeSY%2Fvymn1NpQkjGcisSForBoNG_doc.png?alt=media&token=b148b6a9-b0c7-481c-a222-f8e426386621)

### 8\. Proceed To Ingress Settings

Click Next to configure network traffic and access rules for your container app.

![Proceed To Ingress Settings](https://static.guidde.com/v0/qg%2FNF7l8sUngkQmFADnIfgiHyTW9Wk2%2F8CJdpoxk8kUtwBGnaRqeSY%2FeFjXz9t1rwWwHxrxWWefzX_doc.png?alt=media&token=366cf8aa-2f22-48a0-996c-c8165f4da866)

### 9\. Enable Ingress

Turn on ingress to allow your container app to receive network traffic.

![Enable Ingress](https://static.guidde.com/v0/qg%2FNF7l8sUngkQmFADnIfgiHyTW9Wk2%2F8CJdpoxk8kUtwBGnaRqeSY%2FnJEAX8ECbUSyw1zuf4pZfX_doc.png?alt=media&token=4a2fcd8e-c2c6-4907-bc0a-c0fa666327e4)

### 10\. Enable Traffic Acceptance

Turn on the setting to accept traffic from all sources for your container app.

![Enable Traffic Acceptance](https://static.guidde.com/v0/qg%2FNF7l8sUngkQmFADnIfgiHyTW9Wk2%2F8CJdpoxk8kUtwBGnaRqeSY%2Fqb26SBUDAYiZTK46bZBKSN_doc.png?alt=media&token=c24e6cd7-19e2-4915-b8f5-8f09863ba865)

### 11\. Enable Session affinity

Enable Session affinity to ensure connection persistence

![Enable Session affinity](https://static.guidde.com/v0/qg%2FNF7l8sUngkQmFADnIfgiHyTW9Wk2%2F8CJdpoxk8kUtwBGnaRqeSY%2FnrfEfko7PA2nq8Edj1zc8d_doc.png?alt=media&token=266bc825-3659-4ab5-bd18-a2a02037bc0d)

### 12\. Proceed To Tags Section

Click Next to add metadata tags for organizing your container app.

![Proceed To Tags Section](https://static.guidde.com/v0/qg%2FNF7l8sUngkQmFADnIfgiHyTW9Wk2%2F8CJdpoxk8kUtwBGnaRqeSY%2FhD4ga2dRHrQB9pbRQ6JbTp_doc.png?alt=media&token=3507560c-60b3-4a6c-969f-9615513b0542)

### 13\. Go To Review And Create

Click Next to review your configuration before deployment.

![Go To Review And Create](https://static.guidde.com/v0/qg%2FNF7l8sUngkQmFADnIfgiHyTW9Wk2%2F8CJdpoxk8kUtwBGnaRqeSY%2FpTWn5rFZHMck4LPPMsu8f6_doc.png?alt=media&token=b3a07275-b4ef-4fbd-b708-581e1c581051)

### 14\. Confirm Validation Passed

Passed should be displayed that confirms your container app configuration has no errors.

![Confirm Validation Passed](https://static.guidde.com/v0/qg%2FNF7l8sUngkQmFADnIfgiHyTW9Wk2%2F8CJdpoxk8kUtwBGnaRqeSY%2FbZnEyBFyVxRuiS1MXncFBE_doc.png?alt=media&token=07bfa80b-1441-4a50-a6f7-9d8f4efd47dd)

### 15\. Initiate Container App Creation

Click Create to start deploying your configured container app to Azure.

![Initiate Container App Creation](https://static.guidde.com/v0/qg%2FNF7l8sUngkQmFADnIfgiHyTW9Wk2%2F8CJdpoxk8kUtwBGnaRqeSY%2FndmnaTciAi98WPfidTDDBj_doc.png?alt=media&token=d2f01657-4a98-49eb-b196-74cd69354f6c)

### 16\. Confirm Deployment Completion

Your deployment should complete and your container has been successfully deployed

![Confirm Deployment Completion](https://static.guidde.com/v0/qg%2FNF7l8sUngkQmFADnIfgiHyTW9Wk2%2F8CJdpoxk8kUtwBGnaRqeSY%2FkGtuXqRDcdifzDWk5mf6T9_doc.png?alt=media&token=cc5303d3-9dcc-4f71-baad-41e8283552b5)

### 17\. Access Deployed Resource

Click Go to resource to open the deployed container app's resource page.

![Access Deployed Resource](https://static.guidde.com/v0/qg%2FNF7l8sUngkQmFADnIfgiHyTW9Wk2%2F8CJdpoxk8kUtwBGnaRqeSY%2Fd5d3WZ5F6divuw61TiDtBa_doc.png?alt=media&token=4f1f2a18-fc18-458f-81a4-9adf0cc76e95)

### 18\. Open Application URL

Click Application Url to view the public endpoint of your deployed container app.

![Open Application URL](https://static.guidde.com/v0/qg%2FNF7l8sUngkQmFADnIfgiHyTW9Wk2%2F8CJdpoxk8kUtwBGnaRqeSY%2FqtAi61hHGdSK6ikcn4p5bj_doc.png?alt=media&token=df7208b8-7909-4ecb-8f12-bc63de16cd7c)

### 19\. Switch To Application Tab

Switch to the browser tab displaying your container app's URL. You should see the on-screen message

![Switch To Application Tab](https://static.guidde.com/v0/qg%2FNF7l8sUngkQmFADnIfgiHyTW9Wk2%2F8CJdpoxk8kUtwBGnaRqeSY%2F5dLAd9ofqiJaSeHNKZ1f3B_doc.png?alt=media&token=48f79b37-1464-4402-b643-a96562f2df79)

### 20\. View Health Status Response

add forward slash health to the URL and hit enter. This should provide the health of the container

![View Health Status Response](https://static.guidde.com/v0/qg%2FNF7l8sUngkQmFADnIfgiHyTW9Wk2%2F8CJdpoxk8kUtwBGnaRqeSY%2FnZN9YhQc8pjVgaW5uVapwV_doc.png?alt=media&token=122ce103-128f-43c1-9d70-a323d9bc760e)

You have successfully deployed the Securetron PKI Trust Manager Cert API to Azure Cloud by configuring container settings, registry access, ingress rules, and completing the deployment. The Cert API is used for applications, networks, servers, and devops to automate Certificate Lifecycle Management via SCEP, EST, ACME, and RESTful API. For more information please visit our website at https://securetron.net or contact support.

[Powered by **securetron**](https://www.securetron.net)
