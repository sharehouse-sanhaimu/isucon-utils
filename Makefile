REPO_NAME = ""

check-env:
	@if [ -z "$(REPO_NAME)" ]; then \
		echo "Error: REPO_NAME is not set. Please set this variable and try again."; \
		exit 1; \
	fi

echo: check-env
	@echo $(REPO_NAME)

create-nginx-link:
	mkdir -p /home/isucon/$(REPO_NAME)/etc/nginx
	cp -r /etc/nginx /home/isucon/$(REPO_NAME)/etc/
	mv /etc/nginx /etc/nginx.bak
	ln -s /home/isucon/$(REPO_NAME)/etc/nginx/ /etc/
	systemctl restart nginx.service
	systemctl daemon-reload

create-mysql-link:
	mkdir -p /home/isucon/$(REPO_NAME)/etc/mysql
	cp /etc/mysql/mysql.cnf /home/isucon/$(REPO_NAME)/etc/mysql/
	mv /etc/mysql/mysql.cnf /etc/mysql/mysql.cnf.bak
	ln /home/isucon/$(REPO_NAME)/etc/mysql/mysql.cnf /etc/mysql/mysql.cnf
	systemctl restart mysql
	systemctl daemon-reload

list-daemon:
	systemctl list-units --type=service --state=running
