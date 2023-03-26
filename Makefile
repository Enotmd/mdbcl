# ENVIRONMENT=dev
# ANSIBLE_LIMIT_HOST=postgres-group
VAULT_VARS_FILE=./env/$(ENVIRONMENT)/vault_secrets.yml
VAULT_GEN_PASS_FILE=./.vault_pass
PLAYBOOK_DIR=./playbooks

configure:	
	python3 -m venv python_virtual_env; 	
	. python_virtual_env/bin/activate; \
	pip install ansible==7.3.0; \
	ansible-galaxy collection install community.postgresql; \


deploy_postgresql: 
	ansible-playbook -i env/$(ENVIRONMENT)/hosts -l $(ANSIBLE_LIMIT_HOST) --extra-vars="@$(VAULT_VARS_FILE)" --vault-password-file="$(VAULT_GEN_PASS_FILE)" $(PLAYBOOK_DIR)/deploy_postgresql.yml -vvv --tags "deploy"

install_postgresql: 
	ansible-playbook -i env/$(ENVIRONMENT)/hosts  $(ANSIBLE_LIMIT_HOST) --extra-vars="@$(VAULT_VARS_FILE)" --vault-password-file="$(VAULT_GEN_PASS_FILE)" $(PLAYBOOK_DIR)/deploy_postgresql.yml -vvv --tags "install"

configure_postgresql: 
	ansible-playbook -i env/$(ENVIRONMENT)/hosts  $(ANSIBLE_LIMIT_HOST) --extra-vars="@$(VAULT_VARS_FILE)" --vault-password-file="$(VAULT_GEN_PASS_FILE)" $(PLAYBOOK_DIR)/deploy_postgresql.yml -vvv --tags "configure"
deploy:
	ansible-playbook --extra-vars="@./env/dev/postgresql-group.yml" --extra-vars="@./env/dev/vault_secrets.yml" --ask-vault-pass playbooks/deploy_postgresql.yml -vvv

#ruleaza asa : make deploy_postgresql ANSIBLE_LIMIT_HOST=postgresql-group ENVIRONMENT=dev       


