class TestDigest {
	
	public function new(){
		var privKey = sys.ssl.Key.readDER( sys.io.File.getBytes("keys/private.der"), false );
		var privKey2 = sys.ssl.Key.readPEM( sys.io.File.getContent("keys/private.pem"), false, "testpassword" );
		var pubKey = sys.ssl.Key.readPEM( sys.io.File.getContent("keys/public.pem"), true );

		var data = haxe.io.Bytes.ofString("Hello World!");
		var sign = sys.ssl.Digest.sign( data, privKey, SHA256 );

		Sys.println( 'sign='+haxe.crypto.Base64.encode(sign) );
		Sys.println( 'verify='+sys.ssl.Digest.verify(data,sign,pubKey,SHA256) );
		var validSign = sys.io.File.getBytes("keys/hello_signature.bin");
		Sys.println( 'compare with valid sign='+sign.compare(validSign) );
	}

}
