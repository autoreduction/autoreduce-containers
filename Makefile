VOLUME_MOUNTS= --bind ../autoreduce:/autoreduce --bind /instrument:/instrument --bind /isis:/isis --bind /isis:/archive

DATE_LABEL := $(shell date +%Y-%m-%dT%H%M)

GHCR=ghcr.io/autoreduction

all: base qp webapp dbmanage devtest

dev:
	docker build . -f development.D -t autoreduction/dev

qp: base
	sudo docker build -t $(GHCR)/autoreduce:$(DATE_LABEL) -f ../autoreduce/container/qp_mantid_python36.D ../autoreduce
	sudo docker tag $(GHCR)/autoreduce:$(DATE_LABEL) $(GHCR)/autoreduce:latest
	sudo docker push $(GHCR)/autoreduce:$(DATE_LABEL)
	sudo docker push $(GHCR)/autoreduce:latest

mantid_6.2: base
	sudo docker build -t $(GHCR)/runner-mantid:$(DATE_LABEL) -f ./Dockerfile ../autoreduce
	sudo docker tag $(GHCR)/runner-mantid:$(DATE_LABEL) $(GHCR)/runner-mantid:6.2.0
	sudo docker push $(GHCR)/runner-mantid:$(DATE_LABEL)
	sudo docker push $(GHCR)/runner-mantid:6.2.0

webapp:
	sudo docker build -t $(GHCR)/autoreduce-frontend:$(DATE_LABEL) -f ../autoreduce-frontend/container/webapp.D ../autoreduce-frontend
	sudo docker tag $(GHCR)/autoreduce-frontend:$(DATE_LABEL) $(GHCR)/autoreduce-frontend:latest
	sudo docker push $(GHCR)/autoreduce-frontend:$(DATE_LABEL)
	sudo docker push $(GHCR)/autoreduce-frontend:latest

rest-api:
	sudo docker build -t $(GHCR)/autoreduce-rest-api:$(DATE_LABEL) -f ../autoreduce-rest-api/container/rest-api.D ../autoreduce-rest-api
	sudo docker tag $(GHCR)/autoreduce-rest-api:$(DATE_LABEL) $(GHCR)/autoreduce-rest-api:latest
	sudo docker push $(GHCR)/autoreduce-rest-api:$(DATE_LABEL)
	sudo docker push $(GHCR)/autoreduce-rest-api:latest

run-detection:
	sudo docker build -t $(GHCR)/autoreduce-run-detection:$(DATE_LABEL) -f ../autoreduce-run-detection/container/run-detection.D ../autoreduce-run-detection
	sudo docker tag $(GHCR)/autoreduce-run-detection:$(DATE_LABEL) $(GHCR)/autoreduce-run-detection:latest
	sudo docker push $(GHCR)/autoreduce-run-detection:$(DATE_LABEL)
	sudo docker push $(GHCR)/autoreduce-run-detection:latest

dbmanage: base
	sudo singularity build -F dbmanage.sif dbmanage.def

monitoring-checks:
	sudo singularity build -F monitoring-checks.sif monitoring-checks.def

base:
	sudo docker build -t $(GHCR)/base -f autoreduce_base.D ../autoreduce
	sudo docker push $(GHCR)/base
