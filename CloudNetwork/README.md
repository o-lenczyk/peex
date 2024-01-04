# Cloud Network
## L1
- Virtual Machine named VM-nebo1 is deployed to snet-public 
- User can connect using RDP protocol from specified public IP to VM-nebo1, all other inbound traffic is blocked
- From VM-nebo1 outgoing traffic (TCP/UDP) is blocked despite a successful ping to 8.8.8.8
- When a new virtual machine is deployed (VM-nebo2) all previous acceptance criteria are satisfied
- VPC name should be vnet-nebo  
- vnet-nebo should have two subnets: snet-public and snet-private
- snet-public address space should be 10.0.0.0/17 
- snet-private address space should be 10.0.128.0/17 
  
## L2  
- The virtual Network name should be deployed and named vnet-nebo  
- Subnet should be deployed and have 10.0.0.0/24 address space with the name of snet-private
- VPN should be deployed
- Virtual Machine VM-nebo1 should be deployed in snet-private without public IP
- VPN gateway should be installed on a local workstation OR IPSec service should be used on any other infrastructure or GCP project
- Deploy GCP Cloud DNS Zone.
- Set Name Servers in the external DNS register service.
- Wait until the answer DNS query for your domain is sent from GCP Cloud DNS servers (use nslookup to do that).
- Add type A record to GCP Cloud DNS.
- index.html file with "Hello World" text and random image should be uploaded to GCP Cloud Storage bucket
- CDN should be enabled
- Web page should be accessible via CDN URL.

## L3  
- Set up Internal TCP/UDP Load Balancing— https://cloud.google.com/load-balancing/docs/internal/setting-up-internal 
- External TCP/UDP Network Load Balancing— https://cloud.google.com/load-balancing/docs/network/setting-up-network-backend-service 
- Set up a global external HTTP(S) load balancer with a Compute Engine backend— https://cloud.google.com/load-balancing/docs/https/setup-global-ext-https-compute 
  
## L4
Create a document that describes:
- Current Network configuration within regions, subnets, and others.
- Instances located in the network.
- Public and Private access to the instances.
- Ports and protocols configuration.