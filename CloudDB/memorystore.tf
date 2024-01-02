# resource "google_redis_instance" "cache" {
#   name           = "ha-memory-cache"
#   tier           = "STANDARD_HA"
#   memory_size_gb = 1

#   location_id             = local.zone

#   authorized_network = data.google_compute_network.redis-network.id

#   redis_version     = "REDIS_4_0"
#   display_name      = "Terraform Test Instance"
#   reserved_ip_range = "192.168.0.0/29"

#   maintenance_policy {
#     weekly_maintenance_window {
#       day = "TUESDAY"
#       start_time {
#         hours = 0
#         minutes = 30
#         seconds = 0
#         nanos = 0
#       }
#     }
#   }

#   lifecycle {
#     prevent_destroy = true
#   }
# }

# // This example assumes this network already exists.
# // The API creates a tenant network per network authorized for a
# // Redis instance and that network is not deleted when the user-created
# // network (authorized_network) is deleted, so this prevents issues
# // with tenant network quota.
# // If this network hasn't been created and you are using this example in your
# // config, add an additional network resource or change
# // this from "data"to "resource"
