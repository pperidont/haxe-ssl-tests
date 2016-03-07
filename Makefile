all: compile

compile:
	haxe project.hxml

http:
	neko testssl http

client:
	neko testssl client

client2:
	neko testssl client2

errors:
	neko testssl errors

certificate:
	neko testssl certificate

digest:
	neko testssl digest

prepare:
	rm -rf keys
	rm -rf cert
	mkdir keys
	mkdir cert
	@make mkcacert NAME=root SUBJECT="/O=Test Dev CA"
	@make mkcacert NAME=root2 SUBJECT="/O=Test Dev2 CA"
	@make mkcert CA=root NAME=localhost SUBJECT="/CN=localhost"
	@make mkcert CA=root NAME=foo.bar SUBJECT="/CN=foo.bar"
	@make mkcert CA=root NAME=client SUBJECT="/C=FR/O=TestOrganization/CN=Test User/emailAddress=test@test.org"
	@make mkcert CA=root2 NAME=unknown.bar SUBJECT="/CN=unknown.bar"
	@make mkcert CA=root2 NAME=client2 SUBJECT="/C=FR/O=TestOrganization/CN=Test Unknown User/emailAddress=test2@test.org"
	@make prepare-keys

prepare-keys:
	openssl genrsa -out keys/private.pem -des3 -passout pass:testpassword
	openssl pkey -in keys/private.pem -passin pass:testpassword -outform DER -out keys/private.der
	openssl pkey -in keys/private.der -inform DER -pubout -out keys/public.pem
	echo -n 'Hello World!' | openssl dgst -sign keys/private.der -keyform DER > keys/hello_signature.bin -sha256

mkcsr:
	openssl req -batch -nodes -newkey rsa:2048 -sha256 -subj "$(SUBJECT)" -keyout cert/$(NAME).key -out cert/$(NAME).csr

mkcacert: mkcsr
	openssl x509 -req -in cert/$(NAME).csr -sha256 -signkey cert/$(NAME).key -out cert/$(NAME).crt -days 3650
	rm cert/$(NAME).csr

mkcert: mkcsr
	openssl x509 -req -in cert/$(NAME).csr -CA cert/$(CA).crt -CAkey cert/$(CA).key -CAcreateserial -sha256 -out cert/$(NAME).crt -days 365
	rm cert/$(NAME).csr

test_app_server:
	openssl s_server -accept 5566 -cert cert/localhost.crt -key cert/localhost.key -CAfile cert/root.crt -verify_return_error -verify 0 -servername foo.bar -cert2 cert/foo.bar.crt -key2 cert/foo.bar.key

test_app_client:
	openssl s_client -connect localhost:5566 -CAfile cert/root.crt -cert cert/client.crt -key cert/client.key
