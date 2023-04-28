# Bring up a container
[no-cd]
dup:
    sudo docker compose up --detach --force-recreate

# Follow the log output
[no-cd]
[no-exit-message]
dlogs:
    sudo docker compose logs --follow --tail 100

# Clean up
dclean:
    sudo docker system prune --all --volumes
