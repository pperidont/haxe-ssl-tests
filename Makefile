all: compile client

compile:
	haxe project.hxml

http:
	neko testssl http

client:
	neko testssl client

certificate:
	neko testssl certificate

digest:
	neko testssl digest

prepare:
	mkdir keys
	mkdir cert
	@make mkrootca
	@make mkcert NAME=localhost SUBJECT="/CN=localhost"
	@make mkcert NAME=foo.bar SUBJECT="/CN=foo.bar"
	@make mkcert NAME=client SUBJECT="/C=FR/O=TestOrganization/CN=Test User/emailAddress=test@test.org"
	@make prepare-keys

prepare-keys:
	openssl genrsa -out keys/private.pem -des3 -passout pass:testpassword
	openssl pkey -in keys/private.pem -passin pass:testpassword -outform DER -out keys/private.der
	openssl pkey -in keys/private.der -inform DER -pubout -out keys/public.pem
	echo -n 'Hello World!' | openssl dgst -sign keys/private.der -keyform DER > keys/hello_signature.bin -sha256

mkrootca:
	openssl req -batch -nodes -newkey rsa:2048 -sha256 -subj "/O=Test Dev CA" -keyout cert/root.key -out cert/root.csr
	openssl x509 -req -in cert/root.csr -sha256 -signkey cert/root.key -out cert/root.crt -days 3650
	rm cert/root.csr

mkcert:
	openssl req -batch -nodes -newkey rsa:2048 -sha256 -subj "$(SUBJECT)" -keyout cert/$(NAME).key -out cert/$(NAME).csr
	openssl x509 -req -in cert/$(NAME).csr -CA cert/root.crt -CAkey cert/root.key -CAcreateserial -sha256 -out cert/$(NAME).crt -days 365
	rm cert/$(NAME).csr

test_app_server:
	openssl s_server -accept 5566 -cert cert/localhost.crt -key cert/localhost.key -CAfile cert/root.crt -verify_return_error -verify 0

test_app_client:
	openssl s_client -connect localhost:5566 -CAfile cert/root.crt -cert cert/client.crt -key cert/client.key
