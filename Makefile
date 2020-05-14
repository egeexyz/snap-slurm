.PHONY: install-dependencies
install-dependencies:
	@echo Installing dependencies for Snapcraft and Python...
	pip install -r ./requirements/test-requirements.txt
	sudo lxd.migrate -yes
	sudo lxd init --auto

.PHONY: lint
lint:
	@echo Linting Python files...
	flake8 ./src/hooks/bin/configure --exit-zero
	flake8 ./src/slurm-configurator/bin/slurm-configurator --exit-zero

.PHONY: test
test:
	@echo Running Tests...

.PHONY: build
build:
	@echo Building Slurm Snap...
	sudo snapcraft --use-lxd