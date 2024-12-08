# Exercise 2: Monitor Web Apps

## Skilling tasks:
- Enable Application Insights
- Disable logging for .NET core snapshot debugger
- Configure web app HTTP logs to be written to a Log Analytics workspace
- Configure SQL Insights data to be written to a Log Analytics workspace
- Enable file and configuration change tracking for web apps

## Exercise instructions:

### Enable Application Insights:
1. In the Azure Portal Search Bar, enter rg-alpha and select rg-alpha from the list of results.
2. From the list of items in the resource group, choose App Services for the Web App with an SQL Database.
3. Under Settings, choose Application Insights.
4. On the Application Insights page, choose Turn On Application Insights.
5. Ensure that Create a new resource is selected and that the Log Analytics Workspace is set to LogAnalytics1 and choose Apply.
6. On the Apply monitoring settings dialog, choose Yes.

### Disable logging for .NET core snapshot debugger:
1. In the Azure Portal Search Bar, enter rg-alpha and select rg-alpha from the list of results.
2. From the list of items in the resource group, choose App Services for the Web App with an SQL Database.
3. Under Settings, choose Application Insights.
4. Under Instrument your application, choose .NET Core and then set the Snapshot Debugger setting to Off. Choose Apply.
5. On the Apply Monitoring Settings dialog box, choose Yes.

### Configure web app HTTP logs to be written to a Log Analytics workspace:
1. In the Azure Portal Search Bar, enter rg-alpha and select rg-alpha from the list of results.
2. From the list of items in the resource group, choose App Services for the Web App with an SQL Database.
3. Under Monitoring, choose Diagnostic settings.
4. Select + Add diagnostic settings.
5. Choose the following and select Save:
   - **Diagnostic setting name:** httplogs
   - **Categories:** HTTP logs
   - **Destination details:** Send to Log Analytics workspace
   - **Subscription:** Your subscription
   - **Log Analytics workspace:** LogAnalytics1

### Configure SQL Insights data to be written to a Log Analytics workspace:
1. In the Azure Portal Search Bar, enter rg-alpha and select rg-alpha from the list of results.
2. From the list of items in the resource group, choose the sample SQL database.
3. Under Monitoring, choose Diagnostic settings.
4. Choose Add diagnostic setting.
5. Provide the following information and choose Save:
   - **Diagnostic setting name:** InsightLogAnalytics
   - **Categories:** SQL Insights
   - **Destination details:** Send to Log Analytics workspace
   - **Subscription:** Your subscription
   - **Log Analytics workspace:** LogAnalytics1

### Enable file and configuration change tracking for web apps:
1. In the Azure Portal Search Bar, enter rg-alpha and select rg-alpha from the list of results.
2. From the list of items in the resource group, choose the AzureLinuxAppWXYZ-webapp.
3. Choose Diagnose and Solve Problems.
4. In the search dialog box, type Application Changes.
5. On the Change Analysis page, choose Configure.
6. On the Enable file and configuration change tracking page, change the Status slider to On and then choose Save.
