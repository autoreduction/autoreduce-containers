VOLUME_MOUNTS= --bind ../autoreduce:/autoreduce --bind /instrument:/instrument --bind /isis:/isis --bind /isis:/archive

DATE_LABEL := $(shell date +%Y-%m-%dT%H%M)

all: base qp webapp dbmanage devtest

dev:
	docker build . -f development.D -t autoreduction/dev

qp: base
	docker build -t autoreduction/qp:$(DATE_LABEL) -f ../autoreduce/container/qp_mantid_python36.D ../autoreduce
	docker tag autoreduction/qp:$(DATE_LABEL) autoreduction/qp:latest
	sudo singularity build -F qp_mantid_python36.sif ../autoreduce/container/qp_singularity_wrap.def

webapp:
	docker build -t autoreduction/webapp:$(DATE_LABEL) -f ../autoreduce-frontend/container/webapp.D ../autoreduce-frontend
	docker tag autoreduction/webapp:$(DATE_LABEL) autoreduction/webapp:latest
	sudo docker push autoreduction/webapp:$(DATE_LABEL)
	sudo docker push autoreduction/webapp:latest

rest-api:
	docker build -t autoreduction/rest-api:$(DATE_LABEL) -f ../autoreduce-rest-api/container/rest-api.D ../autoreduce-rest-api
	docker tag autoreduction/rest-api:$(DATE_LABEL) autoreduction/rest-api:latest
	sudo singularity build -F rest-api.sif ../autoreduce-rest-api/container/rest-api-singularity-wrap.def

dbmanage: base
	sudo singularity build -F dbmanage.sif dbmanage.def

monitoring-checks:
	sudo singularity build -F monitoring-checks.sif monitoring-checks.def

base:
	docker build -t autoreduction/base -f autoreduce_base.D ../autoreduce

system:
	sudo yum install -y squashfs-tools
	wget https://golang.org/dl/go1.16.2.linux-amd64.tar.gz
	sudo tar -C /usr/local -xzf go1.16.2.linux-amd64.tar.gz
	sudo ln -s /usr/local/go/bin/go /usr/bin/go
	sudo ln -s /usr/local/go/bin/gofmt /usr/bin/gofmt
	sudo yum groupinstall -y 'Development Tools'

singularity:
	export VERSION=3.7.0 && wget https://github.com/hpcng/singularity/releases/download/v$${VERSION}/singularity-$${VERSION}.tar.gz && tar -xzf singularity-$${VERSION}.tar.gz
	cd singularity && ./mconfig && make -C builddir && sudo make -C builddir install
	sudo ln -s /usr/local/bin/singularity /usr/bin/singularity

deps: system singularity
