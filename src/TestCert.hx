class TestCert {

	public function new(){
		var cert = sys.ssl.Certificate.loadFile("cert/localhost.crt");
		Sys.println( "Server CN=" + cert.commonName );
		Sys.println( "Server altNames=" + cert.altNames );
		Sys.println( "Now notBefore=" + cert.notBefore );
		Sys.println( "Now notAfter=" + cert.notAfter );
	}

}
