install plugin:
- `ansible-galaxy collection install cloud.terraform`

create vm:
- `terraform init`
- `terraform plan`
- `terraform apply`

update vm config:
- `ansible playbook -i inventory.yml main.yml`

comments:
- after initial run, comment or remove [`backup /var` task](roles/lvm/tasks/main.yml)