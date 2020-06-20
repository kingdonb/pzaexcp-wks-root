REGISTRY_IP=172.25.0.4
REGISTRY_PORT=5000

.PHONY: all build push clone pzaexcp-frontend pzaexcp-api hrpy-api person-api
.PHONY: manifest pull-all pzaexcp-frontend-dev push-dev

PERSON_API_IMAGE_TAG := $(shell ./script/person-api-tag)
HRPY_API_IMAGE_TAG := $(shell ./script/hrpy-api-tag)
PZAEXCP_API_IMAGE_TAG := $(shell ./script/pzaexcp-api-tag)
PZAEXCP_IMAGE_TAG := $(shell ./script/pzaexcp-tag)
FINANCE_API_IMAGE_TAG := $(shell ./script/finance-api-tag)

all:	build push

pull-all:
	for i in hrpy-api person-api pzaexcp-api pzaexcp-frontend finance-api; do \
    pushd $$i; git pull --ff-only; popd; done

clone:
	git clone git@bitbucket.org:nd-oit/pzaforms.git \
    -b frontend-dev    pzaexcp-frontend;
	git clone git@bitbucket.org:nd-oit/pzaforms.git \
    -b api-dev         pzaexcp-api;
	git clone git@bitbucket.org:nd-oit/nd_hrpy_api_internal.git \
    -b okteto-dev      hrpy-api;
	git clone git@bitbucket.org:nd-oit/nd-person-api-ws.git \
    -b okteto-dev      person-api;
	git clone git@bitbucket.org:nd-oit/nd_finance_api_internal.git \
    -b api-dev         finance-api;

build: pzaexcp-frontend pzaexcp-api hrpy-api person-api finance-api

pzaexcp-frontend-dev:
	docker build pzaexcp-frontend -t kingdonb/pzaexcp-frontend:dev --target dev
pzaexcp-frontend: pzaexcp-frontend-dev
	docker build pzaexcp-frontend -t kingdonb/pzaexcp-frontend:${PZAEXCP_IMAGE_TAG}
	docker tag kingdonb/pzaexcp-frontend:${PZAEXCP_IMAGE_TAG} kingdonb/pzaexcp-frontend:latest
pzaexcp-api:
	docker build pzaexcp-api -t kingdonb/pzaexcp-api:${PZAEXCP_API_IMAGE_TAG}
hrpy-api:
	docker build hrpy-api -t kingdonb/hrpy-api:${HRPY_API_IMAGE_TAG}
person-api:
	docker build person-api -t kingdonb/person-api:${PERSON_API_IMAGE_TAG}
finance-api:
	docker build finance-api -t kingdonb/finance-api:${FINANCE_API_IMAGE_TAG}

push-dev:
	docker push kingdonb/pzaexcp-frontend:dev
push: push-dev
	docker push kingdonb/pzaexcp-frontend:latest
	docker push kingdonb/pzaexcp-frontend:${PZAEXCP_IMAGE_TAG}
	docker push kingdonb/pzaexcp-api:${PZAEXCP_API_IMAGE_TAG}
	docker push kingdonb/hrpy-api:${HRPY_API_IMAGE_TAG}
	docker push kingdonb/person-api:${PERSON_API_IMAGE_TAG}
	docker push kingdonb/finance-api:${FINANCE_API_IMAGE_TAG}

manifest:
	echo "TODO"
