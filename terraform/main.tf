locals {
  vm1 = "WS"
  vm2 = "Linux"
}

# Create Resource group, VNET, Subnet
resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
  tags = {
    project = "Az Monitoring"
  }
}

resource "azurerm_virtual_network" "vnet" {
  name                = "vnet"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  address_space       = ["10.0.0.0/16"]
  depends_on = [
    azurerm_resource_group.rg,
  ]
}
resource "azurerm_subnet" "subnet" {
  name                 = "subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.0.0/24"]
  depends_on = [
    azurerm_virtual_network.vnet,
  ]
}

# Create Window Virtual Machine
resource "azurerm_network_interface" "nic_ws" {
  name                = "nic-${local.vm1}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  ip_configuration {
    name                          = "ipconfig1"
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.pip_ws.id
    subnet_id                     = azurerm_subnet.subnet.id
  }
  depends_on = [
    azurerm_public_ip.pip_ws,
    azurerm_subnet.subnet,
  ]
}

resource "azurerm_network_security_group" "nsg_ws" {
  name                = "nsg-${local.vm1}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  depends_on = [
    azurerm_resource_group.rg,
  ]
}

resource "azurerm_network_security_rule" "Allow_http" {
  name                        = "AllowAnyHTTPInbound"
  priority                    = 310
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "80"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.rg.name
  network_security_group_name = azurerm_network_security_group.nsg_ws.name
  depends_on = [
    azurerm_network_security_group.nsg_ws,
  ]
}
resource "azurerm_network_security_rule" "Allow_RDP-self" {
  name                        = "RDP"
  resource_group_name         = azurerm_resource_group.rg.name
  access                      = "Allow"
  destination_address_prefix  = "*"
  source_address_prefix       = "202.160.135.154" //put your own ip
  source_port_range           = "*"
  destination_port_range      = "3389"
  direction                   = "Inbound"
  network_security_group_name = azurerm_network_security_group.nsg_ws.name
  priority                    = 300
  protocol                    = "Tcp"
  depends_on = [
    azurerm_network_security_group.nsg_ws,
  ]
}

resource "azurerm_network_interface_security_group_association" "nsg_nic_ws" {
  network_interface_id      = azurerm_network_interface.nic_ws.id
  network_security_group_id = azurerm_network_security_group.nsg_ws.id
  depends_on = [
    azurerm_network_interface.nic_ws,
    azurerm_network_security_group.nsg_ws,
  ]
}

resource "azurerm_public_ip" "pip_ws" {
  name                = "pip-${local.vm1}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku                 = "Standard"
  allocation_method   = "Static"
  depends_on = [
    azurerm_resource_group.rg,
  ]
}

resource "azurerm_windows_virtual_machine" "WindowsServer_VM" {
  name                  = "WindowsServer"
  resource_group_name   = azurerm_resource_group.rg.name
  location              = azurerm_resource_group.rg.location
  size                  = "Standard_B2ms"
  admin_username        = var.admin_username
  admin_password        = var.admin_password
  network_interface_ids = [azurerm_network_interface.nic_ws.id]
  secure_boot_enabled   = true
  vtpm_enabled          = true
  identity {
    type = "SystemAssigned"
  }
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }
  source_image_reference {
    offer     = "WindowsServer"
    publisher = "MicrosoftWindowsServer"
    sku       = "2022-datacenter-azure-edition"
    version   = "latest"
  }
  depends_on = [
    azurerm_network_interface.nic_ws,
  ]
}

# Create linux virtual machine
resource "azurerm_network_interface" "nic_LinuxVM" {
  name                = local.vm2
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  ip_configuration {
    name                          = "ipconfig1"
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.pip_LinuxVM.id
    subnet_id                     = azurerm_subnet.subnet.id
  }
  depends_on = [
    azurerm_public_ip.pip_LinuxVM,
    azurerm_subnet.subnet,
  ]
}

resource "azurerm_network_security_group" "nsg_LinuxVM" {
  name                = "nsg-${local.vm2}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  depends_on = [
    azurerm_resource_group.rg,
  ]
}

resource "azurerm_network_interface_security_group_association" "nsg_nic_LinuxVM" {
  network_interface_id      = azurerm_network_interface.nic_LinuxVM.id
  network_security_group_id = azurerm_network_security_group.nsg_LinuxVM.id
  depends_on = [
    azurerm_network_interface.nic_LinuxVM,
    azurerm_network_security_group.nsg_LinuxVM,
  ]
}

resource "azurerm_public_ip" "pip_LinuxVM" {
  name                = "pip--${local.vm2}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku                 = "Standard"
  allocation_method   = "Static"
  depends_on = [
    azurerm_resource_group.rg,
  ]
}

resource "azurerm_linux_virtual_machine" "linux_VM" {
  name                  = "Linux"
  resource_group_name   = azurerm_resource_group.rg.name
  location              = azurerm_resource_group.rg.location
  admin_username        = var.admin_username
  network_interface_ids = [azurerm_network_interface.nic_LinuxVM.id,]
  admin_ssh_key {
    username   = "adminuser"
    public_key = file("~/.ssh/id_rsa.pub")
  }
  size                  = "Standard_B2ms"
  os_disk {
    storage_account_type = "Premium_LRS"
    caching              = "ReadWrite"
  }
  source_image_reference {
    publisher = "canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts-gen2"
    version   = "latest"
  }
  depends_on = [
    azurerm_network_interface.nic_LinuxVM,
  ]
}


# Create Log Analytics Workspace
resource "azurerm_log_analytics_workspace" "Log_Workspace" {
  name                = "LogAnalytics"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  retention_in_days   = 60
  daily_quota_gb      = 10
  depends_on = [
    azurerm_resource_group.rg,
  ]
}

resource "azurerm_log_analytics_saved_search" "search" {
  for_each                   = var.searches
  name                       = "LogManagement(LogAnalytics)_${each.value.category}|${each.value.display_name}"
  category                   = each.value.category
  display_name               = each.value.display_name
  log_analytics_workspace_id = azurerm_log_analytics_workspace.Log_Workspace.id
  query                      = each.value.query
  depends_on                 = [azurerm_log_analytics_workspace.Log_Workspace]
}


# Enable Application Insights for Monitoring
resource "azurerm_application_insights" "AppInsight" {
  name                = "website3wncc2c23v2sm"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  application_type    = "web"
  sampling_percentage = 0
  workspace_id        = azurerm_log_analytics_workspace.Log_Workspace.id
}

# Deploying a windows web app with an SQL Database

# Create mssql server
resource "azurerm_mssql_server" "SqlServer" {
  name                         = "sqlserver-53abc5434236789"
  resource_group_name          = azurerm_resource_group.rg.name
  location                     = azurerm_resource_group.rg.location
  administrator_login          = var.admin_username
  administrator_login_password = var.admin_password
  minimum_tls_version          = "Disabled"
  version                      = "12.0"
  tags = {
    displayName = "SQL Server"
  }
  depends_on = [
    azurerm_resource_group.rg,
  ]
}

# Create mysql database
resource "azurerm_mssql_database" "SqlDB" {
  name      = "sampledb"
  server_id = azurerm_mssql_server.SqlServer.id
  tags = {
    displayName = "Database"
  }
  depends_on = [
    azurerm_mssql_server.SqlServer,
  ]
}

# Create Azure SQL Firewall Rule
resource "azurerm_mssql_firewall_rule" "mysql_firewall" {
  name             = "AllowAllWindowsAzureIps"
  server_id        = azurerm_mssql_server.SqlServer.id
  start_ip_address = "0.0.0.0"
  end_ip_address   = "0.0.0.0"
  depends_on = [
    azurerm_mssql_server.SqlServer,
  ]
}

resource "azurerm_service_plan" "AppServicePlan_WS" {
  location            = azurerm_resource_group.rg.location
  name                = "hostingplan3wncc2c23v2sm"
  resource_group_name = azurerm_resource_group.rg.name
  sku_name            = "F1"
  os_type             = "Windows"
  tags = {
    displayName               = "HostingPlan"
    changeAnalysisScanEnabled = "true"
  }
  depends_on = [
    azurerm_resource_group.rg,
  ]
}
resource "azurerm_windows_web_app" "Web_App_WS" {
  name                    = "website3wncc2c23v2sm"
  resource_group_name     = azurerm_resource_group.rg.name
  location                = azurerm_resource_group.rg.location
  client_affinity_enabled = true
  service_plan_id         = azurerm_service_plan.AppServicePlan_WS.id
  app_settings = {
    APPINSIGHTS_INSTRUMENTATIONKEY                  = "3dd25c3a-cb9b-4855-b76d-dd7f6d691c2a"
    APPINSIGHTS_PROFILERFEATURE_VERSION             = "1.0.0"
    APPINSIGHTS_SNAPSHOTFEATURE_VERSION             = "disabled"
    APPLICATIONINSIGHTS_CONNECTION_STRING           = "InstrumentationKey=3dd25c3a-cb9b-4855-b76d-dd7f6d691c2a;IngestionEndpoint=https://eastus-8.in.applicationinsights.azure.com/;LiveEndpoint=https://eastus.livediagnostics.monitor.azure.com/;ApplicationId=93cf08e9-52e1-42f6-afdf-b9b0b9dab3c2"
    ApplicationInsightsAgent_EXTENSION_VERSION      = "~2"
    DiagnosticServices_EXTENSION_VERSION            = "~3"
    InstrumentationEngine_EXTENSION_VERSION         = "disabled"
    SnapshotDebugger_EXTENSION_VERSION              = "disabled"
    XDT_MicrosoftApplicationInsights_BaseExtensions = "disabled"
    XDT_MicrosoftApplicationInsights_Java           = "1"
    XDT_MicrosoftApplicationInsights_Mode           = "recommended"
    XDT_MicrosoftApplicationInsights_NodeJS         = "1"
    XDT_MicrosoftApplicationInsights_PreemptSdk     = "disabled"
  }
  tags = {
    displayName                                            = "Website"
    "hidden-related:diagnostics/changeAnalysisScanEnabled" = "true"
  }
  # Defines a connection string for an Azure SQL Database
  connection_string {
    name  = "DefaultConnection"
    type  = "SQLAzure"
    value = "Data Source=tcp:sqlserver3wncc2c23v2sm.database.windows.net,1433;Initial Catalog=sampledb;User Id=prime@sqlserver3wncc2c23v2sm.database.windows.net;Password=P@ssw0rdP@ssw0rd;"
  }
  site_config {
    always_on                         = false
    ftps_state                        = "FtpsOnly"
    ip_restriction_default_action     = "Allow"
    scm_ip_restriction_default_action = "Allow"
    virtual_application {
      physical_path = "site\\wwwroot"
      preload       = false
      virtual_path  = "/"
    }
  }
  sticky_settings {
    app_setting_names = ["APPINSIGHTS_INSTRUMENTATIONKEY", "APPLICATIONINSIGHTS_CONNECTION_STRING ", "APPINSIGHTS_PROFILERFEATURE_VERSION", "APPINSIGHTS_SNAPSHOTFEATURE_VERSION", "ApplicationInsightsAgent_EXTENSION_VERSION", "XDT_MicrosoftApplicationInsights_BaseExtensions", "DiagnosticServices_EXTENSION_VERSION", "InstrumentationEngine_EXTENSION_VERSION", "SnapshotDebugger_EXTENSION_VERSION", "XDT_MicrosoftApplicationInsights_Mode", "XDT_MicrosoftApplicationInsights_PreemptSdk", "APPLICATIONINSIGHTS_CONFIGURATION_CONTENT", "XDT_MicrosoftApplicationInsightsJava", "XDT_MicrosoftApplicationInsights_NodeJS"]
  }
  depends_on = [
    azurerm_service_plan.AppServicePlan_WS,
  ]
}

# Create AzureMonitorWindowsAgent
resource "azurerm_virtual_machine_extension" "AzureMonitorWindowsAgent" {
  name                       = "AzureMonitorWindowsAgent"
  virtual_machine_id         = azurerm_windows_virtual_machine.WindowsServer_VM.id
  type                       = "AzureMonitorWindowsAgent"
  auto_upgrade_minor_version = true
  type_handler_version       = "1.0"
  publisher                  = "Microsoft.Azure.Monitor"
  depends_on = [
    azurerm_windows_virtual_machine.WindowsServer_VM,
  ]
}

# Configure SQL Insights Data to be Written to a Log Analytics Workspace
resource "azurerm_monitor_diagnostic_setting" "sql_insights_diagnostic" {
  name               = "sql-insights-diagnostic"
  target_resource_id = azurerm_mssql_server.SqlServer.id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.Log_Workspace.id

  log {
    category = "SQLInsights"
    enabled  = true
    retention_policy {
      enabled = true
      days    = 30
    }
  }
}

# Enable File and Configuration Change Tracking for Web Apps
resource "azurerm_monitor_diagnostic_setting" "file_change_diagnostic" {
  name               = "file-change-diagnostic"
  target_resource_id = azurerm_windows_web_app.Web_App_WS.id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.Log_Workspace.id

  log {
    category = "AppServiceFileAuditLogs"
    enabled  = true
    retention_policy {
      enabled = true
      days    = 30
    }
  }
}


# Create NetworkWatcherExtension for WS
resource "azurerm_virtual_machine_extension" "NetworkWatcherExtension_WS" {
  name                       = "AzureNetworkWatcherExtension"
  publisher                  = "Microsoft.Azure.NetworkWatcher"
  type                       = "NetworkWatcherAgentWindows"
  type_handler_version       = "1.4"
  virtual_machine_id         = azurerm_windows_virtual_machine.WindowsServer_VM.id
  auto_upgrade_minor_version = true
  depends_on = [
    azurerm_windows_virtual_machine.WindowsServer_VM,
  ]
}
# Create DataCollectionEndpoint_WS
resource "azurerm_monitor_data_collection_endpoint" "DataCollectionEndpoint_WS" {
  name                = "IaaSVMCollectionEndpoint"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  depends_on = [
    azurerm_resource_group.rg,
  ]
}

# Create DataCollectionRule_WS
resource "azurerm_monitor_data_collection_rule" "DataCollectionRule_WS" {
  name                        = "WinVMDCR"
  resource_group_name         = azurerm_resource_group.rg.name
  location                    = azurerm_resource_group.rg.location
  data_collection_endpoint_id = azurerm_monitor_data_collection_endpoint.DataCollectionEndpoint_WS.id
  //kind                        = "Windows"
  destinations {
    log_analytics {
      name                  = azurerm_log_analytics_workspace.Log_Workspace.name
      workspace_resource_id = azurerm_log_analytics_workspace.Log_Workspace.id
    }
  }
  data_flow {
    streams       = ["Microsoft-Event"]
    destinations  = ["la-255518032"]
  }
  # data_flow {
  #   streams       = ["Microsoft-W3CIISLog"]
  #   destinations  = ["la-255518032"]
  # }
  data_sources {
    iis_log {
      name    = "iisLogsDataSource"
      streams = ["Microsoft-W3CIISLog"]
    }
    windows_event_log {
      name           = "eventLogsDataSource"
      streams        = ["Microsoft-Event"]
      x_path_queries = ["Application!*[System[(Level=1 or Level=2)]]", "Security!*[System[(band(Keywords,4503599627370496))]]", "System!*[System[(Level=1 or Level=2)]]"]
    }
  }
  depends_on = [
    azurerm_monitor_data_collection_endpoint.DataCollectionEndpoint_WS,
    azurerm_log_analytics_workspace.Log_Workspace,
  ]
}


# Deploying Linux Web App
resource "azurerm_service_plan" "AppServicePlan_Linux" {
  location            = azurerm_resource_group.rg.location
  name                = "AppServicePlan-AzureLinuxApp5555"
  os_type             = "Linux"
  resource_group_name = azurerm_resource_group.rg.name
  sku_name            = "S1"
  depends_on = [
    azurerm_resource_group.rg,
  ]
}

resource "azurerm_linux_web_app" "Web_App_Linux" {
  name                = "webapp-${local.vm2}1232434545"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  service_plan_id     = azurerm_service_plan.AppServicePlan_Linux.id

  site_config {}
}

# Create NetworkWatcherExtension for Linux
resource "azurerm_network_watcher" "NetworkWatcher" {
  name                = "nwwatcher-${local.vm2}"
  location            = "westus"
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_virtual_machine_extension" "NetworkWatcherExtension_Linux" {
  name                       = "AzureNetworkWatcherExtension-${local.vm2}"
  type                       = "NetworkWatcherAgentLinux"
  type_handler_version       = "1.4"
  publisher                  = "Microsoft.Azure.NetworkWatcher"
  virtual_machine_id         = azurerm_linux_virtual_machine.linux_VM.id
  auto_upgrade_minor_version = true
  automatic_upgrade_enabled  = true
  depends_on = [
    azurerm_linux_virtual_machine.linux_VM,
  ]
}

# Monitoring and Action Setup

# Create an Action Group to Send an Email
resource "azurerm_monitor_action_group" "action_group" {
  name                = "NotifyCPU"
  resource_group_name = azurerm_resource_group.rg.name
  short_name          = "NotifyCPU"
  email_receiver {
    email_address = "abc@outlook.com"
    name          = "NotificationEmail_-EmailAction-"
  }
  depends_on = [
    azurerm_resource_group.rg,
  ]
}

# Create an Alert for Virtual Machine CPU Utilization
resource "azurerm_monitor_metric_alert" "MonitorAlert" {
  name                = "HighCPU"
  resource_group_name = azurerm_resource_group.rg.name
  scopes              = [azurerm_linux_virtual_machine.linux_VM.id]
  description = "Alert will be triggered when HighCPU usages."
  action {
    action_group_id = azurerm_monitor_action_group.action_group.id
  }
  criteria {
    aggregation      = "Average"
    metric_name      = "Percentage CPU"
    metric_namespace = "Microsoft.Compute/virtualMachines"
    operator         = "GreaterThan"
    threshold        = 80
  }
  depends_on = [
    azurerm_linux_virtual_machine.linux_VM
  ]
}

resource "azurerm_monitor_smart_detector_alert_rule" "MonitorAlert" {
  resource_group_name = azurerm_resource_group.rg.name
  name                = "Failure Anomalies - website3wncc2c23v2sm"
  description         = "Failure Anomalies notifies you of an unusual rise in the rate of failed HTTP requests or dependency calls."
  detector_type       = "FailureAnomaliesDetector"
  scope_resource_ids = [ azurerm_monitor_action_group.AppInsight.id ]
  frequency           = "PT1M"
  severity            = "Sev3"
  action_group {
    ids = [azurerm_monitor_action_group.AppInsight.id]
  }
  depends_on = [
    azurerm_resource_group.rg,
  ]
}


resource "azurerm_monitor_action_group" "AppInsight" {
  name                = "Application Insights Smart Detection"
  resource_group_name = azurerm_resource_group.rg.name
  short_name          = "SmartDetect"
  arm_role_receiver {
    name                    = "Monitoring Contributor"
    role_id                 = "749f88d5-cbae-40b8-bcfc-e573ddc772fa"
    use_common_alert_schema = true
  }
  arm_role_receiver {
    name                    = "Monitoring Reader"
    role_id                 = "43d0d8ad-25c7-4714-9337-8ba259a9fe05"
    use_common_alert_schema = true
  }
  depends_on = [
    azurerm_resource_group.rg,
  ]
}

