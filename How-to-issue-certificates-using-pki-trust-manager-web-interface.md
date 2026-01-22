[Issue Certificates Efficiently Using PKI Trust Manager](https://www.youtube.com/watch?v=ySVSUn7IBKU)
=================================================================================================================

[Click here to watch](https://www.youtube.com/watch?v=ySVSUn7IBKU)

### [![Quick guidde](https://static.guidde.com/v0/qg%2FNF7l8sUngkQmFADnIfgiHyTW9Wk2%2FcYPKWrVyjPXkjRsNG977Jq%2F5NUXHvYcQQn1uvw1krabq5_cover.png?alt=media&token=5d69ea5c-4fa0-4668-8e0e-1c13835d14dc)](https://www.youtube.com/watch?v=ySVSUn7IBKU)

This tutorial guides you through issuing a certificate using the PKI Trust Manager. You will learn how to navigate the interface and complete all necessary steps to successfully issue a certificate.

### 1\. Select Certificate Admin

The certificates can be issued and managed via various channels in PKI Trust Manager including automation, API interfaces and integrations with services. In this video we will walkthrough on how to issue a certificate manually

![Select Certificate Admin](https://static.guidde.com/v0/qg%2FNF7l8sUngkQmFADnIfgiHyTW9Wk2%2FcYPKWrVyjPXkjRsNG977Jq%2F8Lhz3hLysoK13nZ6h8BjLB_doc.png?alt=media&token=46b7e75a-c456-4d5b-aa02-a862d8ad730a)

### 2\. Select Certificate Admin

The Certificates are tied to the identity of the PKI Admin. To Issue a Certificate - Click on your Identity

![Select Certificate Admin](https://static.guidde.com/v0/qg%2FNF7l8sUngkQmFADnIfgiHyTW9Wk2%2FcYPKWrVyjPXkjRsNG977Jq%2FvPcHnenmkdEw3LqDMpZTEr_doc.png?alt=media&token=2ef8a405-adf4-4088-ba3b-f33688200a83)

### 3\. Open Certificates Section

Click the Certificates tab to access certificate management options.

![Open Certificates Section](https://static.guidde.com/v0/qg%2FNF7l8sUngkQmFADnIfgiHyTW9Wk2%2FcYPKWrVyjPXkjRsNG977Jq%2FrL2JHJoBPCVZDnn6ZAZzM9_doc.png?alt=media&token=6479ee95-1382-4e7c-8e6d-5cb4588c75b9)

### 4\. Initiate New Certificate

Click the New button to start creating a new certificate.

![Initiate New Certificate](https://static.guidde.com/v0/qg%2FNF7l8sUngkQmFADnIfgiHyTW9Wk2%2FcYPKWrVyjPXkjRsNG977Jq%2F3zXTniqjHNgryhAbqQmbkt_doc.png?alt=media&token=bf5b72bd-d9ea-420d-bb02-986fd4f92483)

### 5\. Certificate Template

Select the Template that will be used to issue a new certificate. These are the templates that the PKI Admin has published and made available through the integrations of the Certification Authorities

![Certificate Template](https://static.guidde.com/v0/qg%2FNF7l8sUngkQmFADnIfgiHyTW9Wk2%2FcYPKWrVyjPXkjRsNG977Jq%2FbDN1rddUFtHnSh78n8fSwb_doc.png?alt=media&token=e0e97608-ab66-494a-96ed-ed869ad06841)

### 6\. Select Template

For this demonstration, we will be using the TLS Web Server template to issue a TLS Certificate that can be tied to a internal web-application

![Select Template](https://static.guidde.com/v0/qg%2FNF7l8sUngkQmFADnIfgiHyTW9Wk2%2FcYPKWrVyjPXkjRsNG977Jq%2Fa1NA9SZjnmaTpj43suzhNS_doc.png?alt=media&token=939fe10b-b66b-4f4f-b203-74497792364b)

### 7\. Certificate Signing Request

Next we will select the CSR Option. There are three choices. First, if you already have the CSR; second, that you would like to generate the CSR in your browser; and finally, the third option is to generate the CSR on the Server side.

![Certificate Signing Request](https://static.guidde.com/v0/qg%2FNF7l8sUngkQmFADnIfgiHyTW9Wk2%2FcYPKWrVyjPXkjRsNG977Jq%2Fe99vbsfjjQevYdPGfpUb4G_doc.png?alt=media&token=dca564c1-e36d-442e-9a5a-19dfdd1123a6)

### 8\. Select CSR Option

We will select the "Server Side" option to generate the CSR

![Select CSR Option](https://static.guidde.com/v0/qg%2FNF7l8sUngkQmFADnIfgiHyTW9Wk2%2FcYPKWrVyjPXkjRsNG977Jq%2FgknaSyMaJsFJwz9pppUdMX_doc.png?alt=media&token=eb8a2fc3-4b28-4013-8fbf-3bc0e6534516)

### 9\. Certificate Details

Next, we want to fill out the details required to generate a CSR. These fields have been either made mandatory or optional by the PKI Admin when through the Template.

![Certificate Details](https://static.guidde.com/v0/qg%2FNF7l8sUngkQmFADnIfgiHyTW9Wk2%2FcYPKWrVyjPXkjRsNG977Jq%2FgNwZTyM4ViLqvNGoRUMNxp_doc.png?alt=media&token=84105925-eea6-4e72-9e04-db413cabd905)

### 10\. Common Name

Enter your application name or DNS Name to identify the certificate's purpose.

![Common Name](https://static.guidde.com/v0/qg%2FNF7l8sUngkQmFADnIfgiHyTW9Wk2%2FcYPKWrVyjPXkjRsNG977Jq%2F3oiCn8fjnExwPXFQvwVRBW_doc.png?alt=media&token=a5d2d400-4ce4-415f-97fb-252b38c74827)

### 11\. Email Address

Enter your email address associated with the certificate requestor. This typically should be a distribution list.

![Email Address](https://static.guidde.com/v0/qg%2FNF7l8sUngkQmFADnIfgiHyTW9Wk2%2FcYPKWrVyjPXkjRsNG977Jq%2FpGwEdSrppgUAp1Kxfa87ky_doc.png?alt=media&token=331124b4-debf-4d4a-8d23-de6a09a3fcf1)

### 12\. Organization Name

Enter your organization or department name to which the certificate belongs to

![Organization Name](https://static.guidde.com/v0/qg%2FNF7l8sUngkQmFADnIfgiHyTW9Wk2%2FcYPKWrVyjPXkjRsNG977Jq%2Fbp9TRB7Z5FPCzBYhMqrmsF_doc.png?alt=media&token=a03f9df7-2d32-4644-bcbe-8efaafb6f7e5)

### 13\. Country

Select the appropriate country from the list.

![Country](https://static.guidde.com/v0/qg%2FNF7l8sUngkQmFADnIfgiHyTW9Wk2%2FcYPKWrVyjPXkjRsNG977Jq%2FxkJM7xXpGfciWGNiccpWt4_doc.png?alt=media&token=35189ac2-cd41-4202-82b3-e21473388461)

### 14\. Subject Alternative Names

Select the domain name associated with the certificate. These might be aliases used to access the application. They are commonly known as DNS Alias or Subject Alternative Names. If you do not have one - then re-enter the common name here.

![Subject Alternative Names](https://static.guidde.com/v0/qg%2FNF7l8sUngkQmFADnIfgiHyTW9Wk2%2FcYPKWrVyjPXkjRsNG977Jq%2Fch9TLGteHykUCzXRzYTm3k_doc.png?alt=media&token=867d3cc6-29b5-4f9d-9adc-1a5a611a804c)

### 15\. Key Algorithm and Size

Select the Key algorithm and size

![Key Algorithm and Size](https://static.guidde.com/v0/qg%2FNF7l8sUngkQmFADnIfgiHyTW9Wk2%2FcYPKWrVyjPXkjRsNG977Jq%2FvgWvmw8EaPAWS2rFzt62mh_doc.png?alt=media&token=f5a86ad1-31a5-46cd-aa6e-6028d36f0658)

### 16\. Passphrase

To protect the Private key, provide a pass phrase. This passphrase will be used to download as well as import it on the application server.

![Passphrase](https://static.guidde.com/v0/qg%2FNF7l8sUngkQmFADnIfgiHyTW9Wk2%2FcYPKWrVyjPXkjRsNG977Jq%2FazRjBd7nBCtHSXdZ1mQDkx_doc.png?alt=media&token=5cd250d3-d5ce-4b8f-9dea-ba60cc731e2e)

### 17\. Submit Certificate Request

Click Submit Request to send your certificate signing request.

![Submit Certificate Request](https://static.guidde.com/v0/qg%2FNF7l8sUngkQmFADnIfgiHyTW9Wk2%2FcYPKWrVyjPXkjRsNG977Jq%2FfzCGBzPPAQaQPALNTWJaKZ_doc.png?alt=media&token=78a39438-f29a-4602-8d8a-b9f3cef18cbc)

### 18\. Certificate Details

The Certificate details will show the status as "ISSUED" if successful.

![Certificate Details](https://static.guidde.com/v0/qg%2FNF7l8sUngkQmFADnIfgiHyTW9Wk2%2FcYPKWrVyjPXkjRsNG977Jq%2F32XPV9fvpWUaHR9GFTs3jf_doc.png?alt=media&token=ed56dff2-2899-45d9-a9d8-28dec2b942dc)

### 19\. Certificate Tag

It is best practice to add further metadata to the certificates. You can do this by adding tags to the certificates. You can add multiple tags to the certificates. Let us add a tag to this newly issued certificate. Click on Add Tag, which is located at the bottom of the screen in the tags section

![Certificate Tag](https://static.guidde.com/v0/qg%2FNF7l8sUngkQmFADnIfgiHyTW9Wk2%2FcYPKWrVyjPXkjRsNG977Jq%2F9ehYL1GdDwpcSPVosYzQzW_doc.png?alt=media&token=37c21a6a-ad06-4ea3-8674-6b4e5ebce3de)

### 20\. Select Tag

hoose a tag for the certificate.

![Select Tag](https://static.guidde.com/v0/qg%2FNF7l8sUngkQmFADnIfgiHyTW9Wk2%2FcYPKWrVyjPXkjRsNG977Jq%2FgeKdnq8DbJpNsP3Nb7qhN1_doc.png?alt=media&token=b5109d85-9e0b-49c7-a821-ee4cceb886c8)

### 21\. Add Selected Tags

Click Add Selected to apply the chosen tags to the certificate.

![Add Selected Tags](https://static.guidde.com/v0/qg%2FNF7l8sUngkQmFADnIfgiHyTW9Wk2%2FcYPKWrVyjPXkjRsNG977Jq%2Ffi7GjJRRQU6RYdAEJKRpxA_doc.png?alt=media&token=6627fe61-3068-4936-b4c2-7999db132e2b)

### 22\. Assigned Tags

The tag has been successfully assigned to the certificate.

![Assigned Tags](https://static.guidde.com/v0/qg%2FNF7l8sUngkQmFADnIfgiHyTW9Wk2%2FcYPKWrVyjPXkjRsNG977Jq%2FuZCgaN8S1mtHnmzLgo1gyk_doc.png?alt=media&token=a2b1389d-47d4-4d6b-a00a-85e49d4054f6)

### 23\. Download PKCS12 File

Next, let us download the certificate including the private key. Click Download PKCS12 to obtain the certificate in PKCS12 format.

![Download PKCS12 File](https://static.guidde.com/v0/qg%2FNF7l8sUngkQmFADnIfgiHyTW9Wk2%2FcYPKWrVyjPXkjRsNG977Jq%2F5VjxqQC4sgPUr6NjsfyrN4_doc.png?alt=media&token=b8925680-a322-4d9d-b43d-08a028b13004)

### 24\. Fill Passphrase

Enter your passphrase to secure the PKCS12 certificate file.

![Fill Passphrase](https://static.guidde.com/v0/qg%2FNF7l8sUngkQmFADnIfgiHyTW9Wk2%2FcYPKWrVyjPXkjRsNG977Jq%2F695dv8zeJPG7izuwJ7oji4_doc.png?alt=media&token=5ee57ff3-5b64-468c-a1f7-86ef53e6a575)

### 25\. Confirm PKCS12 Download

Click Download PKCS12 to finalize saving the certificate file.

![Confirm PKCS12 Download](https://static.guidde.com/v0/qg%2FNF7l8sUngkQmFADnIfgiHyTW9Wk2%2FcYPKWrVyjPXkjRsNG977Jq%2FnDwg9rCgc6jr4yERr9DiEs_doc.png?alt=media&token=54daff40-2d20-4d08-80c0-bc023de1cc74)

Congratulations!You have successfully issued a certificate using the PKI Trust Manager by completing all necessary configuration and download steps. For further management, consider exploring certificate renewal and revocation processes. Additionally, visit our website or contact support if you require further assistance.

[Powered by **securetron**](https://www.securetron.net)
