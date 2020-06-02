install-python-dependencies:
	@echo Installing dependencies for Python...
	sudo apt install -y flake8

install-snapcraft-dependencies:
	@echo Installing dependencies for Snapcraft...
	sudo apt update
	sudo apt upgrade -y
	sudo snap refresh
	sudo lxd init --auto
	sudo snap install lxd
	sudo lxd.migrate -yes
	sudo snap install snapcraft --classic
	sudo lxd init --auto

lint:
	@echo Linting Python files...
	flake8 ./src/hooks/bin/

build:
	@echo Building Slurm Snap...
	sudo snapcraft --use-lxd
