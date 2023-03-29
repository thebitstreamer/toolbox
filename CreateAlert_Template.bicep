param alertName string
param resourceGroup string
param resourceName string
param description string
param severity int
param enabled bool
param query string

targetScope = 'resourceGroup'
targetResource = resourceGroup

resource alert 'Microsoft.Insights/scheduledQueryRules@2018-04-16' = {
  name: alertName
  location: resourceGroup().location
  properties: {
    description: description
    enabled: enabled
    severity: severity
    action: {
      actionGroupId: null // Add action group ID if you want to take specific action
    }
    schedule: {
      frequencyInMinutes: 15 // how frequently to evaluate the alert
      timeWindowInMinutes: 15 // the time range to evaluate the alert query over
    }
    condition: {
      dataSourceId: '/subscriptions/${subscription().subscriptionId}/resourceGroups/${resourceGroup}/providers/microsoft.operationalinsights/workspaces/${resourceName}' // the data source to evaluate the query against
      query: query // the KQL query to evaluate
      windowSize: '15m' // the time range to evaluate the query over
      metricTrigger: {
        threshold: 0 // the threshold that will trigger the alert
        metricName: 'queryResultCount' // the name of the metric to evaluate
        metricNamespace: 'microsoft.insights/scheduledqueryrules' // the namespace of the metric to evaluate
        metricResourceId: null // the resource ID of the metric to evaluate
        timeAggregation: 'Count' // the aggregation method to use
        operator: 'GreaterThan' // the comparison operator to use
      }
    }
  }
}
