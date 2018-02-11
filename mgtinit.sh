# Run this file from the mgmt vm after all other related nodes are up and running
ssh-keyscan lb web1 web2 >> .ssh/known_hosts
echo Just type vagrant when prompted for a password
ansible all -m ping --ask-pass