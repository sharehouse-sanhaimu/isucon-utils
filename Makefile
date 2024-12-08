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
	@echo "===== Copy /etc/mysql/conf.d ====="
	mkdir -p /home/isucon/$(REPO_NAME)/etc/mysql/conf.d
	cp /etc/mysql/conf.d/mysql.cnf /home/isucon/$(REPO_NAME)/etc/mysql/conf.d/
	cp /etc/mysql/conf.d/mysqldump.cnf /home/isucon/$(REPO_NAME)/etc/mysql/conf.d/
	mv /etc/mysql/conf.d /etc/mysql/conf.d.bak
	mkdir /etc/mysql/conf.d
	
	@echo "===== Copy /etc/mysql/mysql.conf.d ====="
	mkdir -p /home/isucon/$(REPO_NAME)/etc/mysql/mysql.conf.d
	cp /etc/mysql/mysql.conf.d/mysqld.cnf /home/isucon/$(REPO_NAME)/etc/mysql/mysql.conf.d
	cp /etc/mysql/mysql.conf.d/mysql.cnf /home/isucon/$(REPO_NAME)/etc/mysql/mysql.conf.d
	mv /etc/mysql/mysql.conf.d /etc/mysql/mysql.conf.d.bak
	mkdir /etc/mysql/mysql.conf.d
	
	@echo "===== Create Hard Links ====="
	ln /home/isucon/$(REPO_NAME)/etc/mysql/conf.d/mysql.cnf /etc/mysql/conf.d/mysql.cnf
	ln /home/isucon/$(REPO_NAME)/etc/mysql/conf.d/mysqldump.cnf /etc/mysql/conf.d/mysqldump.cnf
	ln /home/isucon/$(REPO_NAME)/etc/mysql/mysql.conf.d/mysqld.cnf /etc/mysql/mysql.conf.d/mysqld.cnf
	ln /home/isucon/$(REPO_NAME)/etc/mysql/mysql.conf.d/mysql.cnf /etc/mysql/mysql.conf.d/mysql.cnf 
	
	systemctl restart mysql
	systemctl daemon-reload

list-daemon:
	systemctl list-units --type=service --state=running

check-slow-query-log:
	cat /var/log/mysql/mysql-slow.log | wc -l

check-all-log: check-access-log check-slow-query-log

check-access-log:
	cat /var/log/nginx/access.log | wc -l

rotate-slow-query-log:
	mv /var/log/mysql/mysql-slow.log /var/log/mysql/mysql-slow-$(shell date "+%Y%m%d_%H%M%S").log
	systemctl restart mysql

rotate-all-log: rotate-access-log rotate-slow-query-log

rotate-access-log:
	mv /var/log/nginx/access.log /var/log/nginx/access_$(shell date "+%Y%m%d_%H%M%S").log
	systemctl reload nginx

restart-nginx:
	systemctl restart nginx

slow-query-log:
	sudo mysqldumpslow /var/log/mysql/mysql-slow.log -s t | less
