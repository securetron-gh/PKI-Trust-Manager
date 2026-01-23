[Deploy PKI Trust Manager Using Docker](https://youtu.be/ng-aNGAxiY0)
============================================================================================================

[Click here to watch](https://youtu.be/ng-aNGAxiY0)

### [![Quick guidde](https://static.guidde.com/v0/qg%2FNF7l8sUngkQmFADnIfgiHyTW9Wk2%2F6f66kxnwj6X9wAGaU49GBw%2FdT93xftiJ4GBuL8HBnPV38_cover.png?alt=media&token=14b5fb2b-a2e1-48dc-bbea-93a857908c29)](https://youtu.be/ng-aNGAxiY0)

This tutorial guides you through deploying the PKI Trust Manager on Docker. You will complete all necessary steps to set up and verify the deployment successfully.

### 1\. Introduction

Let us begin by accessing a linux server terminal to begin the deployment process. In our demo we are using Ubuntu.

![Introduction](https://static.guidde.com/v0/qg%2FNF7l8sUngkQmFADnIfgiHyTW9Wk2%2F6f66kxnwj6X9wAGaU49GBw%2FqpZWk4nCehZ3zbSnyCNCsL_doc.png?alt=media&token=04c237a9-7061-44d1-a3a5-c2e3bc0f8581)

### 2\. Create Directory

First, create a new directory called securetron. This directory will be used to download the necessary files required to run the PKI Trust Manager application

![Create Directory](https://static.guidde.com/v0/qg%2FNF7l8sUngkQmFADnIfgiHyTW9Wk2%2F6f66kxnwj6X9wAGaU49GBw%2FpJsHUSdQEa1NVsdZur3JQC_doc.png?alt=media&token=912bd5d7-2aff-442c-a75d-f65b925ec3ec)

### 3\. Enter Deployment Directory

Navigate to the securetron directory where deployment files will be managed.

![Enter Deployment Directory](https://static.guidde.com/v0/qg%2FNF7l8sUngkQmFADnIfgiHyTW9Wk2%2F6f66kxnwj6X9wAGaU49GBw%2F8dXXibxH7FSSfFCxXf9D5G_doc.png?alt=media&token=a9eff040-63bb-4c28-8f6c-301ace900736)

### 4\. Navigate to Securetron Folder

Next - download the PKI Trust Manager files using the wget command. Or alternatively, from the securetron website

![Navigate to Securetron Folder](https://static.guidde.com/v0/qg%2FNF7l8sUngkQmFADnIfgiHyTW9Wk2%2F6f66kxnwj6X9wAGaU49GBw%2FmiEKFdg6iEQYSwmpZeAhhu_doc.png?alt=media&token=5a83a323-e77d-4d47-9f28-ae0fd34029f6)

### 5\. Unzip the Content

Once the zip file has been downloaded, then unzip it

![Unzip the Content](https://static.guidde.com/v0/qg%2FNF7l8sUngkQmFADnIfgiHyTW9Wk2%2F6f66kxnwj6X9wAGaU49GBw%2FgLM1ccGHMHJdBFDx7w883q_doc.png?alt=media&token=82466b3d-8c80-491e-9fe2-49b23054db70)

### 6\. Verify The Files

Once the content have been extracted. CD to the PTM directory that contains the required PKI Trust Manager files

![Verify The Files](https://static.guidde.com/v0/qg%2FNF7l8sUngkQmFADnIfgiHyTW9Wk2%2F6f66kxnwj6X9wAGaU49GBw%2Fm1nLR181uQbd2PcFRsxZV1_doc.png?alt=media&token=98ee1c20-eea3-4cbc-820f-0ff538863ff6)

### 7\. Certs Directory

The Certs directory contains the certificates used by nginx. These are temporary self-signed certificates.

![Certs Directory](https://static.guidde.com/v0/qg%2FNF7l8sUngkQmFADnIfgiHyTW9Wk2%2F6f66kxnwj6X9wAGaU49GBw%2F5f5oZjo1JRdYGyQ2ZMHsc4_doc.png?alt=media&token=ab64d1ba-48fa-49b9-873b-240420c80bf2)

### 8\. Docker-Compose File

This is the default docker compose file that includes the required PKI Trust Manager containers and configuration

![Docker-Compose File](https://static.guidde.com/v0/qg%2FNF7l8sUngkQmFADnIfgiHyTW9Wk2%2F6f66kxnwj6X9wAGaU49GBw%2FpT8ZhGEzv2rawHVGHw6eMz_doc.png?alt=media&token=ab0028bc-75a2-4c8d-a79e-ca92e43232bc)

### 9\. Docker-Compose-EJBCA

The docker-compose-ejbca.yml includes the containers and steps required to integrate EJBCA with PKI Trust Manager

![Docker-Compose-EJBCA](https://static.guidde.com/v0/qg%2FNF7l8sUngkQmFADnIfgiHyTW9Wk2%2F6f66kxnwj6X9wAGaU49GBw%2FwD5FsJKPaQ6ZQNy1LFNfgd_doc.png?alt=media&token=ed2199aa-6b18-485b-8e8a-daf895f86a04)

### 10\. License Directory

The license directory is used for activating the offline license typically used on OT or Highly Sensitive environments where internet connection is not possible

![License Directory](https://static.guidde.com/v0/qg%2FNF7l8sUngkQmFADnIfgiHyTW9Wk2%2F6f66kxnwj6X9wAGaU49GBw%2Fi7gZKyuAYWcebABojywZFa_doc.png?alt=media&token=23a5a940-641c-48a6-9d10-c77b5f459ff2)

### 11\. NGINX.CONF

The nginx.conf file contains the initial configuration required to proxy the PKI Trust Manager Web Application. You may customize this to your organization requirements.

![NGINX.CONF](https://static.guidde.com/v0/qg%2FNF7l8sUngkQmFADnIfgiHyTW9Wk2%2F6f66kxnwj6X9wAGaU49GBw%2FkNhtpE4gYCeJ65axodHxss_doc.png?alt=media&token=ecd0d915-87aa-4cac-b27a-08d223980691)

### 12\. Run PKI Trust Manager Containers

Run the application by executing: "docker compose up -d". This should initialize the containers and run the application.

![Configure Trust Manager Settings](https://static.guidde.com/v0/qg%2FNF7l8sUngkQmFADnIfgiHyTW9Wk2%2F6f66kxnwj6X9wAGaU49GBw%2F9jwkB3nN8XG6KwYd2jQF4W_doc.png?alt=media&token=bd7215e7-a058-4dfa-aa55-35f4a7ea34a4)

### 13\. Verify Docker Process

Confirm that all of the containers are running correctly by running "docker ps".

![Verify Docker Process](https://static.guidde.com/v0/qg%2FNF7l8sUngkQmFADnIfgiHyTW9Wk2%2F6f66kxnwj6X9wAGaU49GBw%2FsjJND5YBpTXQCY9dT7zhFE_doc.png?alt=media&token=79000e57-9e83-4f0d-9b4a-b34d2913308e)

### 14\. Access PKI Trust Manager

Access the PKI Trust Manager application by pointing to the IP-Address over port 443 or to DNS FQDN that you may have configured that resolves to the application. Enter the default credentials

Default Credentials:
Username: superadmin
Password: happy

![Access PKI Trust Manager](https://static.guidde.com/v0/qg%2FNF7l8sUngkQmFADnIfgiHyTW9Wk2%2F6f66kxnwj6X9wAGaU49GBw%2F7oX8cFLdZijExmWWCtK3yF_doc.png?alt=media&token=fb6f9b5c-f05a-4603-a597-891f197393f8)

### 15\. Success!

You should see the Next Generation PKI Trust Manager Platform, ready to integrate with your Certificate Authorities and to begin automating the management of the certificates across your organization!

![Success!](https://static.guidde.com/v0/qg%2FNF7l8sUngkQmFADnIfgiHyTW9Wk2%2F6f66kxnwj6X9wAGaU49GBw%2FjMWLth4ZoDCdCqQeVdF6bH_doc.png?alt=media&token=5fbebee1-0f15-40f9-9345-dcbf01b18e8f)

Congratulations! You have successfully deployed the PKI Trust Manager on Docker and verified its configuration. Next, you can explore advanced certificate management or integrate with your existing security infrastructure. For more information visit our website or contact support.

[Powered by **securetron**](https://www.securetron.net)
