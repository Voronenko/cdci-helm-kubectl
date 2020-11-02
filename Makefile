DOCKER_TAG ?= `git rev-parse --abbrev-ref HEAD`

build:
	@docker build \
	  --build-arg VCS_REF=`git rev-parse --short HEAD` \
	  --build-arg BUILD_DATE=`date -u +"%Y-%m-%dT%H:%M:%SZ"` \
	  -t voronenko/cdci-helm-kubectl:$(DOCKER_TAG) .
push:
	docker push voronenko/cdci-helm-kubectl:$(DOCKER_TAG)

tag-latest:
	docker tag voronenko/cdci-helm-kubectl:$(DOCKER_TAG) voronenko/cdci-helm-kubectl:latest
push-latest:
	docker push voronenko/cdci-helm-kubectl:latest
