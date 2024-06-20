variable "resource_group_name" {
  type    = string
  default = "rg"
}
variable "location" {
  type = string
}
variable "admin_username" {
  type    = string
  default = "Admin"
}
variable "admin_password" {
  type    = string
  default = "$Azure@Monitoring123#"
}


variable "searches" {
  type = map(object({
    category     = string
    display_name = string
    query        = string
  }))
  default = {
    search-1 = {
      category     = "General Exploration"
      display_name = "All Computers with their most recent data"
      query        = "search not(ObjectName == \"Advisor Metrics\" or ObjectName == \"ManagedSpace\") | summarize AggregatedValue = max(TimeGenerated) by Computer | limit 500000 | sort by Computer asc\n// Oql: NOT(ObjectName=\"Advisor Metrics\" OR ObjectName=ManagedSpace) | measure max(TimeGenerated) by Computer | top 500000 | Sort Computer // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PTT: True; SortI: True; SortF: True} // Version: 0.1.122"
    }
    search-2 = {
      category     = "General Exploration"
      display_name = "Stale Computers (data older than 24 hours)"
      query        = "search not(ObjectName == \"Advisor Metrics\" or ObjectName == \"ManagedSpace\") | summarize lastdata = max(TimeGenerated) by Computer | limit 500000 | where lastdata < ago(24h)\n// Oql: NOT(ObjectName=\"Advisor Metrics\" OR ObjectName=ManagedSpace) | measure max(TimeGenerated) as lastdata by Computer | top 500000 | where lastdata < NOW-24HOURS // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PTT: True; SortI: True; SortF: True} // Version: 0.1.122"
    }
    search-3 = {
      category     = "General Exploration"
      display_name = "Which Management Group is generating the most data points?"
      query        = "search * | summarize AggregatedValue = count() by ManagementGroupName\n// Oql: * | Measure count() by ManagementGroupName // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PTT: True; SortI: True; SortF: True} // Version: 0.1.122"
    }
    search-4 = {
      category     = "General Exploration"
      display_name = "Distribution of data Types"
      query        = "search * | extend Type = $table | summarize AggregatedValue = count() by Type\n// Oql: * | Measure count() by Type // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PTT: True; SortI: True; SortF: True} // Version: 0.1.122"
    }
    search-5 = {
      category     = "Log Management"
      display_name = "All Events"
      query        = "Event | sort by TimeGenerated desc\n// Oql: Type=Event // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PTT: True; SortI: True; SortF: True} // Version: 0.1.122"
    }
    search-6 = {
      category     = "Log Management"
      display_name = "All Syslogs"
      query        = "Syslog | sort by TimeGenerated desc\r\n// Oql: Type=Syslog // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PTT: True; SortI: True; SortF: True} // Version: 0.1.122"
    }
    search-7 = {
      category     = "Log Management"
      display_name = "All Syslog Records grouped by Facility"
      query        = "Syslog | summarize AggregatedValue = count() by Facility\r\n// Oql: Type=Syslog | Measure count() by Facility // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PTT: True; SortI: True; SortF: True} // Version: 0.1.122"
    }
    search-8 = {
      category     = "Log Management"
      display_name = "All Syslog Records grouped by ProcessName"
      query        = "Syslog | summarize AggregatedValue = count() by ProcessName\r\n// Oql: Type=Syslog | Measure count() by ProcessName // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PTT: True; SortI: True; SortF: True} // Version: 0.1.122"
    }
    search-9 = {
      category     = "Log Management"
      display_name = "All Syslog Records with Errors"
      query        = "Syslog | where SeverityLevel == \"error\" | sort by TimeGenerated desc\r\n// Oql: Type=Syslog SeverityLevel=error // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PTT: True; SortI: True; SortF: True} // Version: 0.1.122"
    }
    search-10 = {
      category     = "Log Management"
      display_name = "Average HTTP Request time by Client IP Address"
      query        = "search * | extend Type = $table | where Type == W3CIISLog | summarize AggregatedValue = avg(TimeTaken) by cIP\r\n// Oql: Type=W3CIISLog | Measure Avg(TimeTaken) by cIP // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PEF: True; SortI: True; SortF: True} // Version: 0.1.122"
    }
    search-11 = {
      category     = "Log Management"
      display_name = "Average HTTP Request time by HTTP Method"
      query        = "search * | extend Type = $table | where Type == W3CIISLog | summarize AggregatedValue = avg(TimeTaken) by csMethod\r\n// Oql: Type=W3CIISLog | Measure Avg(TimeTaken) by csMethod // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PEF: True; SortI: True; SortF: True} // Version: 0.1.122"
    }
    search-12 = {
      category     = "Log Management"
      display_name = "Count of IIS Log Entries by Client IP Address"
      query        = "search * | extend Type = $table | where Type == W3CIISLog | summarize AggregatedValue = count() by cIP\r\n// Oql: Type=W3CIISLog | Measure count() by cIP // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PEF: True; SortI: True; SortF: True} // Version: 0.1.122"
    }
    search-13 = {
      category     = "Log Management"
      display_name = "Count of IIS Log Entries by HTTP Request Method"
      query        = "search * | extend Type = $table | where Type == W3CIISLog | summarize AggregatedValue = count() by csMethod\r\n// Oql: Type=W3CIISLog | Measure count() by csMethod // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PEF: True; SortI: True; SortF: True} // Version: 0.1.122"
    }
    search-14 = {
      category     = "Log Management"
      display_name = "Count of IIS Log Entries by HTTP User Agent"
      query        = "search * | extend Type = $table | where Type == W3CIISLog | summarize AggregatedValue = count() by csUserAgent\r\n// Oql: Type=W3CIISLog | Measure count() by csUserAgent // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PEF: True; SortI: True; SortF: True} // Version: 0.1.122"
    }
  }
}
