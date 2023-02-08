ncc:
	cd iterative-docker-build-action && ncc build index.js --license licenses.txt
	cd iterative-docker-build-args-action && ncc build index.js --license licenses.txt

copy-common-files:
	cp requirements.txt python/
	cp ipython_config.py python/
	cp secrets_helper.py python/
	cp git_credential_helper.py python/
	cp git-wrapper.sh python/
