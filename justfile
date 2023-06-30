default:
    just --list

run HOST *TAGS:
    ansible-playbook main.yaml --limit {{HOST}} {{TAGS}}
