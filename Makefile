setup: touch-vault-password-file install

install:
	ansible-galaxy role install -r ansible/requirements.yml
	ansible-galaxy collection install -r ansible/requirements.yml

infrastructure:
	ansible-playbook -v --vault-password-file ansible/vault-password ansible/playbook.yml --tags "infrastructure"
	
deploy:
	ansible-playbook -i ansible/hosts -v --vault-password-file ansible/vault-password ansible/playbook.yml --tags "deploy"
	
monitoring:
	ansible-playbook -i ansible/hosts -v --vault-password-file ansible/vault-password ansible/playbook.yml --tags "monitoring"

touch-vault-password-file:
	touch ansible/vault-password

encrypt-vault:
	ansible-vault encrypt $(FILE) --vault-password-file ansible/vault-password

decrypt-vault:
	ansible-vault decrypt $(FILE) --vault-password-file ansible/vault-password

view-vault:
	ansible-vault view $(FILE) --vault-password-file ansible/vault-password

edit-vault:
	ansible-vault edit $(FILE) --vault-password-file ansible/vault-password

create-vault:
	ansible-vault create $(FILE) --vault-password-file ansible/vault-password

terraform-init:
	terraform -chdir=terraform init

terraform-plan:
	terraform -chdir=terraform plan

terraform-show:
	terraform -chdir=terraform show

terraform-lint:
	terraform fmt -check -diff terraform

terraform-fmt:
	terraform -chdir=terraform fmt

terraform-validate:
	terraform -chdir=terraform validate

terraform-apply:
	terraform -chdir=terraform apply