install-dependencies:
	@echo Installing dependencies for Snapcraft and Python...
	pip install -r ./requirements/test-requirements.txt
	sudo lxd.migrate -yes
	sudo lxd init --auto

lint:
	@echo Linting Python files...
	flake8 ./src/hooks/bin/
	flake8 ./src/slurm-configurator/bin/

test:
	@echo Running Tests...

build:
	@echo Building Slurm Snap...
	sudo /snap/bin/snapcraft --use-lxd

install:
	snap install slurm_20.02.1_amd64.snap --dangerous --classic

mode-all:
	sudo snap set slurm snap.mode=all

mode-none:
	sudo snap set slurm snap.mode=none

snap-debug:
	sleep 1
	sudo journalctl -u  snap.slurm.mysql --no-pager

uninstall:
	sudo snap remove slurm
	sudo rm slurm_20.02.1_amd64.snap
