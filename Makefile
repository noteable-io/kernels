ncc:
	cd iterative-docker-build-action && ncc build index.js --license licenses.txt
	cd iterative-docker-build-args-action && ncc build index.js --license licenses.txt

copy-common-files:
	cp requirements.txt kernels/python/
	cp ipython_config.py kernels/python/
	cp secrets_helper.py kernels/python/
	cp git_credential_helper.py kernels/python/
	cp git-wrapper.sh kernels/python/
