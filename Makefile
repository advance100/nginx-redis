IMAGES = imega/nginx-redis
CONTAINERS = redirector_nginx redirector_db

build:
	@docker build -f nginx.docker -t imega/nginx-redis .

start:
	@docker run -d --name redirector_db -v $(CURDIR)/build/schema:/schema leanlabs/redis:1.0.0
	@docker exec redirector_db /bin/sh -c "cat /schema/data.txt | redis-cli --pipe"
	@docker run -d --name redirector_nginx --link redirector_db:redirector_db -v $(CURDIR)/build/sites-enabled:/etc/nginx/sites-enabled -p 80:80 imega/nginx-redis

stop:
	-docker stop $(CONTAINERS)

clean: stop
	-docker rm -fv $(CONTAINERS)

destroy: clean
	@docker rmi -f $(IMAGES)

.PHONY: build start stop clean destroy
