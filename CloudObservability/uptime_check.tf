resource "google_monitoring_uptime_check_config" "example" {
    display_name = "example"
    timeout      = "60s"

    http_check {
        port = "80"
        request_method = "GET"
    }

    monitored_resource {
        type = "uptime_url"
        labels = {
            project_id = local.project
            host="35.238.128.231"
        }
    }

    checker_type = "STATIC_IP_CHECKERS"
}
