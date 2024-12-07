REPO_NAME = ""

create-nginx-link:
	mkdir -p /home/isucon/$(REPO_NAME)/etc/nginx
	cp -r /etc/nginx /home/isucon/$(REPO_NAME)/etc/
	mv /etc/nginx /etc/nginx.bak
	ln -s /home/isucon/$(REPO_NAME)/etc/nginx/ /etc/
	systemctl restart nginx.service
	systemctl daemon-reload

list-daemon:
	systemctl list-units --type=service --state=running
