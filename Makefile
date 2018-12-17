build:
	docker build -t hello-stage .

run:
	# why doesn't the container stop when I ctrl-c?
	docker run --rm --sig-proxy=true --publish 8124:8124 hello-stage | node_modules/.bin/bunyan --time local

