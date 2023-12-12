module security_policy {
  source = "GoogleCloudPlatform/cloud-armor/google"

  project_id                           = local.project
  name                                 = "my-test-ca-policy"
  description                          = "Test Cloud Armor security policy with preconfigured rules, security rules and custom rules"
  default_rule_action                  = "allow"
  type                                 = "CLOUD_ARMOR"
  layer_7_ddos_defense_enable          = true
  layer_7_ddos_defense_rule_visibility = "STANDARD"
  json_parsing                         = "STANDARD"
  log_level                            = "VERBOSE"

  pre_configured_rules                 = {}
  security_rules                       = {}
  custom_rules                         = {
      deny_specific_ip = {
      action      = "deny(502)"
      priority    = 22
      description = "Deny specific IP address "
      expression  = <<-EOT
        inIpRange(origin.ip, '217.97.99.178/32')
      EOT
    }
  }
  threat_intelligence_rules            = {}
}