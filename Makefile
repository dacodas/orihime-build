build:

	( cd container ; ./build-image )

deploy:

	: $${ORIHIME_ENVIRONMENT:?Please define this} && \
	( cd helm ; helm template --namespace orihime --name $$ORIHIME_ENVIRONMENT . | kubectl apply -f - )

	kubectl patch -n orihime deployment orihime-django-$$ORIHIME_ENVIRONMENT \
		-p "{\"spec\":{\"template\":{\"metadata\":{\"annotations\":{\"date\":\"`date +'%s'`\"}}}}}"

teardown:

	: $${ORIHIME_ENVIRONMENT:?Please define this} && \
	( cd helm ; helm template --namespace orihime --name $$ORIHIME_ENVIRONMENT . | kubectl delete -f - )
