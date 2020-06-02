install-dependencies:
	@echo Installing dependencies for Snapcraft and Python...
	sudo lxd init --auto
	sudo lxd.migrate -yes

lint:
	@echo Linting Python files...
	flake8 ./src/hooks/bin/

build:
	@echo Building Slurm Snap...
	sudo snapcraft --use-lxd
