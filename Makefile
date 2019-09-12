build:
	buildah bud \
		--build-arg GIT_BRANCH=development \
		--tag container-registry.dacodastrack.com/orihime-django \
		./container

push:
	buildah push container-registry.dacodastrack.com/orihime-django

run-local:
	PYTHONPATH=$(PWD) \
	DJANGO_SETTINGS_MODULE=orihime.settings \
	ORIHIME_DJANGO_ENVIRONMENT=local \
	SECRET_KEY=eEpacHhuTVc5c1hkQ0xIVThlZUZVUmVjR3RqS2RmV0UwYkFFcURWYVgzYU5RZHpQ \
	django-admin check

run-docker: 
	podman run \
	    --rm \
	    --name orihime-django \
	    --network orihime-django \
	    --publish 8000:80 \
	    --env SECRET_KEY=eEpacHhuTVc5c1hkQ0xIVThlZUZVUmVjR3RqS2RmV0UwYkFFcURWYVgzYU5RZHpQ \
		--env PYTHONPATH=/usr/local/src/orihime-django \
		--env DJANGO_SETTINGS_MODULE=orihime.settings \
		--env ORIHIME_DJANGO_ENVIRONMENT=local \
		--env SECRET_KEY=eEpacHhuTVc5c1hkQ0xIVThlZUZVUmVjR3RqS2RmV0UwYkFFcURWYVgzYU5RZHpQ \
	    --volume /tmp/orihime-django/logs:/var/log/orihime-django \
	    --volume /tmp/orihime-django/lib:/var/lib/orihime-django \
	    --volume /home/dacoda/orihime-django/orihime-django/srv:/srv/orihime-django \
	    orihime-django 

deploy: 
	kubectl patch -n orihime deployment orihime-django-deployment \
		-p "{\"spec\":{\"template\":{\"metadata\":{\"annotations\":{\"date\":\"`date +'%s'`\"}}}}}"
