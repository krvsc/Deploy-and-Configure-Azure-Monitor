# Exercise 0: Prepare Your Azure Environment

This exercise focuses on preparing your Azure environment for subsequent tasks related to deploying and configuring Azure Monitor. Follow the instructions below to complete the tasks outlined.

## Tasks:

1. **Create App Log Examiners security group**
2. **Deploy and configure WS-VM1**
3. **Deploy and configure LX-VM2**
4. **Deploy a web app with an SQL Database**
5. **Deploy a Linux web app**

## Prepare Your Bring-Your-Own-Subscription (BYOS):

Before starting the tasks, ensure you have global administrator permissions to an Azure subscription. Follow the steps below to set up the environment:

1. In the Azure Portal, navigate to **Resource Groups** by entering "Resource Groups" in the search bar and selecting it from the results.
2. On the Resource Groups page, click on **Create**.
3. Provide the following details:
   - **Subscription:** Select your subscription.
   - **Resource group name:** Enter "rg-alpha".
   - **Region:** Choose "East US".
4. Click on **Review + Create**, then click **Create**.

## Create App Log Examiners Security Group:

1. In the Azure Portal, search for **Azure Active Directory** and select it.
2. On the Default Directory page, select **Groups**.
3. Click on **New Group**.
4. Fill in the details as follows:
   - **Group type:** Select "Security".
   - **Group name:** Enter "App Log Examiners".
   - **Group description:** Enter "App Log Examiners".
5. Click on **Create**.

## Deploy and Configure WS-VM1:

1. In the Azure Portal, search for **Virtual Machines** and select it.
2. Click on **Create** and select **Azure Virtual Machine**.
3. On the Basics page of the wizard, configure the VM settings as follows:
   - **Subscription:** Your subscription.
   - **Resource Group:** Select "rg-alpha".
   - **Virtual machine name:** Enter "WS-VM1".
   - **Region:** Choose "East US".
   - **Availability options:** Select "No infrastructure redundancy required".
   - **Security type:** Choose "Standard".
   - **Image:** Select "Windows Server 2022 Datacenter: Azure Edition – x64 Gen2".
   - **Size:** Choose "Standard_D4s_v3 – 4 vcpus, 16 GiB memory".
   - **Administrator account:** Enter "prime".
   - **Password:** Enter a secure password.
   - **Inbound ports:** Enable RDP (3389).

4. Review the settings and click on **Create**.
5. Wait for the deployment to complete, then navigate to the VM's properties page.
6. Under Networking, select the RDP rule and change the Source to "My IP address". Save the changes.
7. Add an inbound port rule for HTTP.
8. Connect to the VM using RDP and install the Web Server feature using PowerShell.

## Deploy and Configure LX-VM2:

1. In the Azure Portal, search for **Virtual Machines** and select it.
2. Click on **Create** and select **Azure Virtual Machine**.
3. Configure the VM settings similar to WS-VM1, but select "Ubuntu Server 20.04 LTS – x64 Gen2" as the Image.
4. After the VM deployment, open the VM properties page, choose **Extensions + Applications** under Settings, and add the **Network Watcher Agent for Linux**.

## Deploy a Web App with an SQL Database:

1. Navigate to [Azure Quickstart Templates for Web App with SQL Database](https://github.com/Azure/azure-quickstart-templates/tree/master/quickstarts/microsoft.web/web-app-sql-database).
2. Click on **Deploy to Azure**.
3. Sign in to Azure with an account having Global Administrator privileges.
4. On the Basics page, configure the template and click **Next**.
5. Review the information and click **Create**.

## Deploy a Linux Web App:

1. Open [Azure Quickstart Templates for Linux Web App](https://learn.microsoft.com/en-us/samples/azure/azure-quickstart-templates/webapp-basic-linux/) in a new tab.
2. Click on **Deploy to Azure**.
3. On the Basics page, configure the template and click **Next**.

Follow these steps meticulously to prepare your Azure environment for subsequent Azure Monitor configuration exercises.