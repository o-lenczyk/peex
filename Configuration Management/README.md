## L1
- Ansible: 
  - LVM: [pv](https://github.com/o-lenczyk/peex/blob/main/Configuration%20Management/roles/lvm/tasks/lv.yml#L10), [vg](https://github.com/o-lenczyk/peex/blob/main/Configuration%20Management/roles/lvm/tasks/lv.yml#L25), [lv](https://github.com/o-lenczyk/peex/blob/main/Configuration%20Management/roles/lvm/tasks/lv.yml#L31)
  - [ext4](https://github.com/o-lenczyk/peex/blob/main/Configuration%20Management/roles/lvm/tasks/lv.yml#L39)
  - mount /var via /etc/fstab
  - [ansible run](screenshots/ansible.png)
  - [gif](gifs/lvm.gif)
- Terraform + Ansible:
  - Elasticsearch
  - git annotated tags
  - branch tagged using SemVer 
  - documentation

## L2
- use [Secret Manager](secrets.png):
  - [ansible-vault](ansible-vault/README.md)
  - [Secret Manager](https://github.com/o-lenczyk/peex/blob/main/CloudSecurity/secret_manager.tf)

## L3
- HA
- DR