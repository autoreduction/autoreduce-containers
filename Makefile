all:
	sudo singularity build python36.sif python36.img
	sudo singularity build mantid.sif mantid.img
	# This build expects the AR repo to be at ../autoreduce, relative to this folder
	sudo singularity build queue_processor.sif queue_processor.img

deps:
	sudo yum install -y squashfs-tools
	wget https://golang.org/dl/go1.16.2.linux-amd64.tar.gz
	tar -C /usr/local -xzf go1.16.2.linux-amd64.tar.gz
	sudo ln -s /usr/local/go/bin/go go
	sudo ln -s /usr/local/go/bin/gofmt gofmt

	export VERSION=3.7.0 && wget https://github.com/hpcng/singularity/releases/download/v${VERSION}/singularity-${VERSION}.tar.gz && tar -xzf singularity-${VERSION}.tar.gz && cd singularity
	./mconfig && make -C builddir && sudo make -C builddir install

run:
	# The bind expects the AR repo to be at ../autoreduce, relative to this folder
	singularity run --bind ../autoreduce:/autoreduce/ --bind /instrument:/instrument --bind /isis:/isis queue_processor.sif