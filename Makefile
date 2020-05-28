install-dependencies:
	@echo Installing dependencies for Snapcraft and Python...

	# sudo add-apt-repository ppa:deadsnakes/ppa
	# sudo apt update
	sudo apt install snapd python3-jinja2 -y
	# sudo apt upgrade
	# sudo update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.6 1

	pip install -r ./requirements/test-requirements.txt
	pip install -r ./requirements/classic-requirements.txt
	
	sudo lxd init --auto
	sudo lxd.migrate -yes

lint:
	@echo Linting Python files...
	flake8 ./src/hooks/bin/

test:
	@echo Running Tests...

build:
	@echo Building Slurm Snap...
	sudo /snap/bin/snapcraft

install:
	sudo snap install slurm_20.02.1_amd64.snap --dangerous --classic

mode-all:
	sudo snap set slurm snap.mode=all

mode-none:
	sudo snap set slurm snap.mode=none

snap-debug:
	sleep 1
	sudo systemctl status snap.slurm.* --no-pager
	sudo journalctl -u  snap.slurm.mysql --no-pager
	slurm.sinfo

uninstall:
	sudo snap remove slurm
	sudo rm slurm_20.02.1_amd64.snap
