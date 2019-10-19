deploy: build

	: $${ORIHIME_ENVIRONMENT:?Please define this} && \
	: $${STATIC_RSYNC_SSH_KEY:?Please define this} && \
	( cd helm ; helm template --namespace orihime --name $$ORIHIME_ENVIRONMENT . | kubectl apply -f - )

	kubectl patch -n orihime deployment orihime-django-$$ORIHIME_ENVIRONMENT \
		-p "{\"spec\":{\"template\":{\"metadata\":{\"annotations\":{\"date\":\"`date +'%s'`\"}}}}}"

	sudo rsync -e "ssh -i $$STATIC_RSYNC_SSH_KEY" -av srv/ dacodastrack.com:/srv/orihime-django-$$ORIHIME_ENVIRONMENT

build:

	( cd container ; buildah unshare ./build-image )

teardown:

	: $${ORIHIME_ENVIRONMENT:?Please define this} && \
	( cd helm ; helm template --namespace orihime --name $$ORIHIME_ENVIRONMENT . | kubectl delete -f - )


.PHONY: build deploy teardown
