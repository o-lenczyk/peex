# Cloud Security  
## L1  
- Provision virtual machine with predefined [types](https://github.com/o-lenczyk/peex/blob/main/CloudSecurity/vm.tf#L8) and [images](https://github.com/o-lenczyk/peex/blob/main/CloudSecurity/vm.tf#L13)
  
## L2  
- Create an autoscaling rule to automatically scale out  
- CPU load is greater than 70% over 10 minutes  
- Create a rule to automatically scale in  
- CPU load then drops below 30% over 10 minutes.  
- Define autoscale instance limits  
- Minimum instance 2, maximum 10, Default is 2.  
- Autoscale based on a schedule  
- Add a scale condition  
- Repeat specific days for the Schedule type.  
- Select all the work days, Monday through Friday.  
- specify a Start time of 09:00  
- Repeat the process with scale-out - scales to 3 instances, repeats every   weekday and starts at 18:00.  
- Create a Custom VM by using Google Cloud CLI or Compute Engine API
- Enable Compute Engine API
- Create an Instance select Region and Zone to your VM
- Select Machine family, Series, and type
- Specify numbers of vCPU, amount of memory
- Configure boot disc for instance image
- Customize the VM by creating some text files in specific locations
- Prepare VM for image creation
- Create a custom image
- Create a new VM from a prepared custom image
  
## L3


## L4
- Implement best practices, techniques, and patterns while creating the computational infrastructure design document to assure the non-functional requirements are satisfied, and assure this document has a proper reflection in infrastructure implementation by regular computational infrastructure audit  