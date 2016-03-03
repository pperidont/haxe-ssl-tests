all: compile certificate

compile:
	haxe project.hxml

http:
	neko testssl http

client:
	neko testssl client

certificate:
	neko testssl certificate

prepare:
	@make mkrootca
	@make mkcert NAME=localhost
	@make mkcert NAME=foo.bar
	@make mkcert NAME=client

mkrootca:
	openssl req -batch -nodes -newkey rsa:2048 -sha256 -subj "/O=Test Dev CA" -keyout cert/root.key -out cert/root.csr
	openssl x509 -req -in cert/root.csr -sha256 -signkey cert/root.key -out cert/root.crt -days 3650
	rm cert/root.csr

mkcert:
	openssl req -batch -nodes -newkey rsa:2048 -sha256 -subj "/CN=$(NAME)" -keyout cert/$(NAME).key -out cert/$(NAME).csr
	openssl x509 -req -in cert/$(NAME).csr -CA cert/root.crt -CAkey cert/root.key -CAcreateserial -sha256 -out cert/$(NAME).crt -days 365
	rm cert/$(NAME).csr
