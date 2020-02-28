REGISTRY_IP=172.25.0.4
REGISTRY_PORT=5000

.PHONY: all build push clone pzaexcp-frontend pzaexcp-api hrpy-api person-api
.PHONY: manifest

all:	build push

clone:
	git clone git@bitbucket.org:nd-oit/pzaforms.git \
		-b frontend-dockerfile    pzaexcp-frontend;
	git clone git@bitbucket.org:nd-oit/pzaforms.git \
		-b pzaforms-api-docker    pzaexcp-api;
	git clone git@bitbucket.org:nd-oit/nd_hrpy_api_internal.git \
		-b hrpy-dockerfile        hrpy-api;
	git clone git@bitbucket.org:nd-oit/nd-person-api-ws.git \
		-b person-api-dockerfile  person-api;

build: pzaexcp-frontend pzaexcp-api hrpy-api person-api

pzaexcp-frontend:
	docker build pzaexcp-frontend -t localhost:5000/pzaexcp-frontend:latest
pzaexcp-api:
	docker build pzaexcp-api -t localhost:5000/pzaexcp-api:latest
hrpy-api:
	docker build hrpy-api -t localhost:5000/hrpy-api:latest
person-api:
	docker build person-api -t localhost:5000/person-api:latest

push:
	docker push localhost:5000/pzaexcp-frontend:latest
	docker push localhost:5000/pzaexcp-api:latest
	docker push localhost:5000/hrpy-api:latest
	docker push localhost:5000/person-api:latest

manifest:
	echo "TODO"
