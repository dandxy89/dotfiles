# bash
BASE := $(shell /bin/pwd)
PIPENV ?= pipenv

# Parameters
CONTACT ?= dan.dixey@gmail.com
LOGGING_LEVEL ?= info
TEST_DATA ?= /some/path/here

# AWS
REGION ?= us-east-1
ENVIRONMENT ?= dev
S3_BUCKET ?= bucket-name-$(AWS_ENVIRONMENT)-$(REGION)
STACK_NAME ?= blah-$(ENVIRONMENT)
DEPLOY_TEMPLATE_NAME ?= cloud_formation_template.yaml

build:
	sam build \
		--template $(TEMPLATE_NAME) \
		--region $(REGION) \
		--parameter-overrides "Environment=$(ENVIRONMENT)" \
		--debug

package:
	sam package \
		--region $(REGION) \
		--template-file .aws-sam/build/template.yaml \
		--output-template-file .aws-sam/build/packaged.yaml \
		--s3-bucket $(S3_BUCKET) \
		--s3-prefix my_prefix

deploy:
	sam deploy \
		--region $(REGION) \
		--template-file .aws-sam/build/packaged.yaml \
		--stack-name $(STACK_NAME) \
		--capabilities CAPABILITY_IAM \
		--no-fail-on-empty-changeset \
		--debug \
		--parameter-overrides \
			"Contact=$(CONTACT)" \
		--tags \
			"Contact=$(CONTACT)"

publish:
	$(MAKE) build TEMPLATE_NAME=template.yaml
	$(MAKE) package
	$(MAKE) deploy STACK_NAME=lens-markets-cbc-r-$(ENVIRONMENT)

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | \
		sort | \
		awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

all_packages:  ## Install both Prod and Dev Packages in Pipenv
	@$(PIPENV) install
	@$(PIPENV) install -d

update_pre_commit:  ## Run `pre-commit` auto update
	@export PYTHONPATH=. && @$(PIPENV) run pre-commit autoupdate

run_pre_commit:  ## Run `pre-commit` on the project files
	@$(PIPENV) run pre-commit run --all-files

remove-pipenv:
	@$(PIPENV) --rm

clean-build:
	rm -fr target/
	rm -fr build/
	rm -fr dist/
	rm -fr .eggs/
	rm -fr .cache/
	rm -fr .venv/
	find . -name '*.egg-info' -exec rm -fr {} +
	find . -name '*.egg' -exec rm -f {} +
	find . -name '*.so' -exec rm -f {} +

clean-pyc:
	find . -name '*.pyc' -exec rm -f {} +
	find . -name '*.pyo' -exec rm -f {} +
	find . -name '*~' -exec rm -f {} +
	find . -name '__pycache__' -exec rm -fr {} +

clean-test:
	rm -fr .tox/
	rm -f .coverage
	rm -fr htmlcov/
	rm -fr .pytest_cache

clean: remove-env clean-build clean-pyc clean-test

requirements_dev:
	@$(PIPENV) lock -r --dev > requirements_dev.txt

requirements_prod:
	@$(PIPENV) lock -r > requirements.txt

start_notebook:
	@$(PIPENV)  run jupyter notebook
