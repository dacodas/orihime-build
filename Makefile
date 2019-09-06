build:
	docker build -t orihime-django:development . 

build-local:
	docker build \
		--tag orihime-django:development \
		container

push:
	docker tag orihime-django:development container-registry.dacodastrack.com/orihime-django

run-local:
	PYTHONPATH=$(PWD) \
	DJANGO_SETTINGS_MODULE=orihime.settings \
	ORIHIME_DJANGO_ENVIRONMENT=local \
	SECRET_KEY=eEpacHhuTVc5c1hkQ0xIVThlZUZVUmVjR3RqS2RmV0UwYkFFcURWYVgzYU5RZHpQ \
	django-admin check

run-docker: 
	docker run \
	    --rm \
	    --name orihime-django \
	    --network orihime-django \
	    --publish 8000:80 \
	    --env SECRET_KEY=eEpacHhuTVc5c1hkQ0xIVThlZUZVUmVjR3RqS2RmV0UwYkFFcURWYVgzYU5RZHpQ \
	    --volume /tmp/orihime-django/logs:/var/log/orihime-django \
	    --volume /tmp/orihime-django/lib:/var/lib/orihime-django \
	    --volume /home/dacoda/orihime-django/orihime-django/srv:/srv/orihime-django \
	    orihime-django 

deploy: 
	kubectl patch -n orihime deployment orihime-django-deployment \
		-p "{\"spec\":{\"template\":{\"metadata\":{\"annotations\":{\"date\":\"`date +'%s'`\"}}}}}"
