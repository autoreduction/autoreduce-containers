all:
	sudo singularity build python36.sif python36.img
	sudo singularity build mantid.sif mantid.img
	# This builds expects the AR repo to be at ../autoreduce, relative to this folder
	sudo singularity build queue_processor.sif queue_processor.img

run:
	# The bind expects the AR repo to be at ../autoreduce, relative to this folder
	singularity run --bind ../autoreduce:/autoreduce/ qp.sif