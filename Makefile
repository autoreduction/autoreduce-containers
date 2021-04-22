VOLUME_MOUNTS= --bind ../autoreduce:/autoreduce --bind /instrument:/instrument --bind /isis:/isis --bind /isis:/archive


all: base qp webapp dbmanage devtest

qp: base
	docker build -t autoreduction/qp -f qp_mantid_python36.D ../autoreduce
	sudo singularity build -F qp_mantid_python36.sif qp_singularity_wrap.def

webapp:
	docker build -t autoreduction/webapp -f webapp.D ../autoreduce
	sudo singularity build -F webapp.sif webapp_singularity_wrap.def

dbmanage: base
	sudo singularity build -F dbmanage.sif dbmanage.def

base:
	docker build -t autoreduction/base -f autoreduce_base.D ../autoreduce

devtest:
	docker build -t autoreduction/devtest -f devtest.D ../autoreduce

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
