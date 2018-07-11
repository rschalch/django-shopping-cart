.PHONY: help

admin:
	gunicorn -b 0.0.0.0 --pythonpath src django_shopping_cart.django_wsgi

clean: ## Clean local environment
	@find . -name "*.pyc" | xargs rm -rf
	@find . -name "*.pyo" | xargs rm -rf
	@find . -name "__pycache__" -type d | xargs rm -rf
	@rm -f .coverage
	@rm -rf htmlcov/
	@rm -f coverage.xml
	@rm -f *.log

dependencies: ## Install development dependencies
	pip install -U -r requirements/dev.txt

detect-migrations:  ## Detect missing migrations
	@django-admin makemigrations --dry-run --noinput | grep 'No changes detected' -q || (echo 'Missing migration detected!' && exit 1)

doc: ## Start server of MkDocs
	mkdocs serve

doc-build:
	mkdocs build --clean

flake8:
	@flake8 --show-source .

fix-python-import:
	isort -rc .

help:
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST) | sort

lint: clean ## Run code lint
	flake8 --show-source .
	isort --check

list-apps: ## List Apps
	@django-admin list_apps --app=$(app) --is-active=$(isactive) --limit=30 --page=1 --output=text

migrate: ## Apply migrations
	@django-admin migrate --settings=$(DJANGO_SETTINGS_MODULE)

migration: ## Generate migrations
	@django-admin makemigrations

outdated: ## Show outdated dependencies
	@pip list --outdated --format=columns

release-draft: ## Show new release changelog
	towncrier --draft

release-major: ## Create minor release
	bumpversion major
	towncrier --yes
	git commit -am 'Update CHANGELOG' && git push && git push --tags

release-minor: ## Create minor release
	bumpversion minor
	towncrier --yes
	git commit -am 'Update CHANGELOG' && git push && git push --tags

release-patch: ## Create patch release
	bumpversion patch
	towncrier --yes
	git commit -am 'Update CHANGELOG' && git push && git push --tags

runserver:
	@django/manage.py runserver --settings=$(DJANGO_SETTINGS_MODULE)

shell: ## Run repl
	@echo 'Loading shell with settings = $(DJANGO_SETTINGS_MODULE)'
	@PYTHONSTARTUP=.startup.py ipython

superuser:
	@django/manage.py createsuperuser --settings=$(DJANGO_SETTINGS_MODULE)

test: clean ## Run tests
	pytest -x

test-coverage: clean ## Run tests with coverage
	pytest -x --cov=src/$/ --cov-report=term-missing

test-coverage-html: clean ## Run tests with coverage with html report
	pytest -x --cov=src/django_shopping_cart/ --cov-report=html:htmlcov

test-debug: clean ## Run tests with pdb
	pytest -x --pdb

test-matching: clean ## Run matching tests
	pytest -x -k $(q) --pdb
