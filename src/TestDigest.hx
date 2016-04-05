import sys.ssl.DigestAlgorithm;

class TestDigest {
	
	public function new(){
		var privKey = sys.ssl.Key.loadFile( "keys/private.der", false );
		var privKey2 = sys.ssl.Key.loadFile( "keys/private.pem", false, "testpassword" );
		var pubKey = sys.ssl.Key.loadFile( "keys/public.pem", true );
		
		var data = haxe.io.Bytes.ofString("Hello World!");
		var sign = sys.ssl.Digest.sign( data, privKey, SHA256 );

		Sys.println( 'sign='+haxe.crypto.Base64.encode(sign) );
		Sys.println( 'verify='+sys.ssl.Digest.verify(data,sign,pubKey,SHA256) );
		var validSign = sys.io.File.getBytes("keys/hello_signature.bin");
		Sys.println( 'compare with valid sign=' + (sign.compare(validSign) == 0) );
		
		Sys.println("****** Message Digest ******");
		var mds = [MD5, SHA1, SHA224, SHA256, SHA384, SHA512, RIPEMD160];
		for( md in mds ){
			Sys.println( StringTools.lpad(Std.string(md)," ",10)+": "+sys.ssl.Digest.make( data, md ).toHex() );
		}
	}
	

}
