REPO_NAME = ""

check-env:
	@if [ -z "$(REPO_NAME)" ]; then \
		echo "Error: REPO_NAME is not set. Please set this variable and try again."; \
		exit 1; \
	fi

echo: check-env
	@echo $(REPO_NAME)

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



api-log:
	sudo cat /var/log/nginx/access.log | alp ltsv --sort sum -r -m "/api/app/rides/[A-Z0-9]+/evaluation,/api/chair/rides/[A-Z0-9]+/status" -o count,method,uri,min,avg,max,sum,4xx,5xx


