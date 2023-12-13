# Cloud Security  
## L1  
- GCP Cloud Monitoring is [enabled](https://github.com/o-lenczyk/peex/blob/main/CloudObservability/dashboard.tf#L1)  
- add a [dashboard](https://github.com/o-lenczyk/peex/blob/main/CloudObservability/dashboard.tf#L6)  
- add a chart for basic components ([CPU](https://github.com/o-lenczyk/peex/blob/main/CloudObservability/dashboard/dashboard.json#L11), RAM, [Disk](https://github.com/o-lenczyk/peex/blob/main/CloudObservability/dashboard/dashboard.json#L49), etc.)  
- configure a Metrics explorer  
- Create resource groups  
- Create [Uptime Checks](https://github.com/o-lenczyk/peex/blob/main/CloudObservability/uptime_check.tf#L1)  
  
## L2  
- Enabling the Monitoring API  
- Create an Alert Policy  
- Data Time Aligned - Align raw data in the target time window  
- Data Aggregate - Reduce across time series
- Data Group by - Aggregate across time series by a label called zone
- Evaluation of an Alert Policy
- Conditions (when app and service are considered unhealthy)
- Policy triggers (chosen conditions to trigger an alert)
- Select or define custom service
- Choose the SLI (Service Level Indicator) (define values of service health/metric of service health)
- Define the SLO (Service Level Object) (threshold of service health/time period of compliance)
- Enabling the Monitoring API

## L3
- Demonstrated monitoring dashboard that represents the real state of project infrastructure and you can explain what and why is monitored
- Automated tasks are called when Monitors fail. It can be anything from starting or restarting servers to running a custom script or executing a command
- Runbook is integrated with the tools you use today: Heroku, Salt, Rackspace, DigitalOcean, Logentries, and others
- Documents that describe steps to do when a monitoring alert appears

## L4
- Schema of an existing monitoring and logging system with identified critical services and suggestions for improvement
- Design the document of improvements within the existing monitoring system