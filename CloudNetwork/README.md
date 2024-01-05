# Cloud Network
## L1
- Virtual Machine named [VM-nebo1](https://github.com/o-lenczyk/peex/blob/main/CloudNetwork/vm.tf#L91) is deployed to [snet-public](https://github.com/o-lenczyk/peex/blob/main/CloudNetwork/vm.tf#L110) 
- User can connect using RDP protocol from specified public IP to VM-nebo1, [all other inbound traffic is blocked](https://github.com/o-lenczyk/peex/blob/main/CloudNetwork/vm.tf#L102)
- From VM-nebo1 [outgoing traffic (TCP/UDP) is blocked](gifs/firewall.gif) despite a successful ping to 8.8.8.8
- When a new virtual machine is deployed ([VM-nebo2](https://github.com/o-lenczyk/peex/blob/main/CloudNetwork/vm.tf#L124)) all previous acceptance criteria are satisfied
- [VPC](https://github.com/o-lenczyk/peex/blob/main/CloudNetwork/network.tf#L1) name should be vnet-nebo  
- vnet-nebo should have two subnets: [snet-public](https://github.com/o-lenczyk/peex/blob/main/CloudNetwork/network.tf#L7) and [snet-private](https://github.com/o-lenczyk/peex/blob/main/CloudNetwork/network.tf#L14)
- snet-public address space should be [10.0.0.0/17](https://github.com/o-lenczyk/peex/blob/main/CloudNetwork/network.tf#L9)
- snet-private address space should be [10.0.128.0/17](https://github.com/o-lenczyk/peex/blob/main/CloudNetwork/network.tf#L16) 
  
## L2  
- The virtual Network name should be deployed and named [vnet-nebo](https://github.com/o-lenczyk/peex/blob/main/CloudNetwork/network.tf#L3)  
- Subnet should be deployed and have [10.0.0.0/24](https://github.com/o-lenczyk/peex/blob/main/CloudNetwork/network.tf#L16)address space with the name of snet-private
- VPN should be deployed
- Virtual Machine VM-nebo1 should be deployed in snet-private without public IP
- VPN gateway should be installed on a local workstation OR IPSec service should be used on any other infrastructure or GCP project
- Deploy GCP [Cloud DNS](screenshots/cloud-dns.png) Zone.
- Set Name Servers in the external DNS register service.
- Wait until the answer DNS query for your domain is sent from GCP Cloud DNS servers (use [nslookup](gifs/cloud-dns.gif) to do that).
- Add type A record to GCP Cloud DNS.
- [index.html](https://github.com/o-lenczyk/peex/blob/main/CloudNetwork/cdn.tf#L20) file with "Hello World" text and random image should be uploaded to GCP Cloud Storage bucket
- [CDN](https://github.com/o-lenczyk/peex/blob/main/CloudNetwork/cdn.tf#L47) should be enabled
- Web page should be [accessible](https://github.com/o-lenczyk/peex/blob/main/CloudNetwork/screenshots/cdn.png) via CDN URL.

## L3  
- Set up [Internal TCP/UDP Load Balancing](https://github.com/o-lenczyk/peex/blob/main/CloudNetwork/lb.tf#L38)—  [gif](gifs/load-balancer.gif)

  
## L4
Create a document that describes:
- Current Network configuration within regions, subnets, and others.
- Instances located in the network.
- Public and Private access to the instances.
- Ports and protocols configuration.