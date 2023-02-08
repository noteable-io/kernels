ncc:
	cd iterative-docker-build-action && ncc build index.js --license licenses.txt
	cd iterative-docker-build-args-action && ncc build index.js --license licenses.txt

copy-common-files:
	cp requirements.txt noteable-python
	cp ipython_config.py noteable-python
	cp secrets_helper.py noteable-python
	cp git_credential_helper.py noteable-python
	cp git-wrapper.sh noteable-python
