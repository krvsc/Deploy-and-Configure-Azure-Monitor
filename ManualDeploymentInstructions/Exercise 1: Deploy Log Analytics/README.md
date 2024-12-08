# Exercise 1: Deploy Log Analytics

## Skilling tasks:
- Create a Log Analytics workspace
- Configure Log Analytics data retention and archive policies
- Enable access to a Log Analytics workspace

## Exercise instructions:

### Create a Log Analytics workspace:
1. In the Azure Portal Search Bar, enter Log Analytics and select Log Analytics workspaces from the list of results.
2. On the Log Analytics workspaces page, choose Create.
3. On the Basics page of the Create Log Analytics workspace wizard, provide the following information and choose Review + Create:
   - **Subscription:** Your subscription
   - **Resource Group:** rg-alpha
   - **Name:** LogAnalytics1
   - **Region:** East US
4. Review the information and choose Create.

### Configure Log Analytics data retention and archive policies:
1. In the Azure Portal Search Bar, enter Log Analytics and select Log Analytics workspaces from the list of results.
2. On the Log Analytics workspaces page, choose LogAnalytics1.
3. On the Log Analytics workspace page for LogAnalytics1, choose Usage and estimated costs.
4. Select Data Retention and set the slider to 60 days. Choose OK.
5. On the Log Analytics workspace page for LogAnalytics1, choose Usage and estimated costs.
6. Select Daily cap. Choose On. Set the daily cap to 10 GB and choose OK.

### Enable access to a Log Analytics workspace:
1. In the Azure Portal Search Bar, enter Log Analytics and select Log Analytics workspaces from the list of results.
2. On the Log Analytics workspaces page, choose LogAnalytics1.
3. Select Access control (IAM).
4. Choose Add and then choose Add role assignment.
5. On the list of roles, select Log Analytics Reader and choose Next.
6. On the Members page, choose Select Members and choose the App Log Examiners security group. Choose Select.
7. On the Members space, choose Review + Assign.
