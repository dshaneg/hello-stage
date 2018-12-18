.PHONY: build play run \
		dbuild-build dbuild-release \
		ensure-logs clean deep-clean

mount-def = type=bind,source=${PWD}/build_logs,target=//app/build_logs

build: dbuild-build ensure-logs
	docker run \
	  --rm \
	  --mount $(mount-def) \
	  hello-stage:build

play: dbuild-build ensure-logs
	docker run \
	  --rm \
	  -it \
	  --entrypoint //bin/bash \
	  --mount $(mount-def) \
	  hello-stage:build

run:
	# why doesn't the container stop when I ctrl-c?
	docker run --rm --sig-proxy=true --publish 8124:8124 hello-stage # | node_modules/.bin/bunyan --time local

dbuild-build:
	docker build --target build -t hello-stage:build .

dbuild-release:
	docker build -t hello-stage .

ensure-logs:
	mkdir -p build_logs

clean:
	rm -rf build_logs

deep-clean: clean
	rm -rf node_modules

