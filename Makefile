install-dependencies:
	@echo Installing dependencies for Snapcraft and Python...
	pip install -r ./requirements/test-requirements.txt
	sudo lxd init --auto
	sudo lxd.migrate -yes
	sudo lxd init --auto

lint:
	@echo Linting Python files...
	flake8 ./src/hooks/bin/

test:
	@echo Running Tests...

build:
	@echo Building Slurm Snap...
	snapcraft --use-lxd
