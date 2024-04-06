
up:
	terraform apply -auto-approve

down:
	terraform destroy -auto-approve

recycle: down up

ansible:
	ansible-playbook -i hosts k8s-containerd.yaml

ansible-dry-run:
	ansible-playbook -i hosts k8s-containerd.yaml --check


