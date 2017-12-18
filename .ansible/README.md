# Server setup with ansible

Ansible is used to automate provisioning of servers via SSH. The configuration in this repository is based on the config
for the [HTW IMI-Map](https://github.com/imimaps/imimaps), but updated and streamlined to use external roles instead of 
custom roles, since those are more universal and it reduces the code we have to maintain ourselves.

All commands in this file assume you're in the project's root directory.

## Prequisites
- [Ansible v2.4+](http://docs.ansible.com/ansible/latest/intro_installation.html)
- [Ansible Docker role](https://github.com/geerlingguy/ansible-role-docker)
- [Ansible Nginx role](https://github.com/jdauphant/ansible-role-nginx)
- Vault password, ask someone who knows!
- On the machine to be provisioned: Python 2.7 or 3

## Provisioning servers
The playbook by default provisions all hosts listed in the inventory. To run it, run  
`ansible-playbook .ansible/playbook.yml --vault-id @prompt -i .ansible/inventory`.  

If you only want to provision certain hosts, use the [`--limit`](https://ansible-tips-and-tricks.readthedocs.io/en/latest/ansible/commands/#limit-to-one-or-more-hosts)
parameter to provide the hosts you'd like to use.

## Adding a new host
- Add host to `inventory` (either in an existing group or a new group)
- Add `group_vars/group_name.yml` for `nginx_host_name` and `cicd_pubkey` variables

## Encrypting the `cicd_pubkey`
- Run `ansible-vault encrypt_string --stdin-name 'cicd_pubkey'`
- Enter vault password
- Paste public key to be encrypted
- Press `Ctrl+D` to end input
- Copy output to variable file

## Nginx configuration
To configure Nginx, edit the `templates/default.conf.j2` file, then run the playbook. Make sure to use the variables provided
and no hard-coded strings, and to add new variables should the need arise.

## Firewall configuration
The firewall configuration is (vault encrypted) in `templates/firewall.sh`). Use `ansible-vault edit .ansible/templates/firewall.sh` to edit it.
