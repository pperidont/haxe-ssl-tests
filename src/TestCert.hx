class TestCert {

	public function new(){
		var cert = sys.ssl.Certificate.loadFile("cert/localhost.crt");
		Sys.println( "Server CN=" + cert.commonName );
		Sys.println( "Server altNames=" + cert.altNames );
		Sys.println( "IsValidDate=" + cert.isValidDate() );
		Sys.println( "Now cmpNotBefore=" + cert.cmpNotBefore(Date.now()) );
		Sys.println( "Now cmpNotAfter=" + cert.cmpNotAfter(Date.now()) );
		Sys.println( "Yesterday cmpNotBefore=" + cert.cmpNotBefore(DateTools.delta(Date.now(), DateTools.days(-1))) );
		Sys.println( "NextYear cmpNotAfter=" + cert.cmpNotAfter(DateTools.delta(Date.now(), DateTools.days(365))) );
		Sys.println( "IsValidName localhost=" + cert.isValidHostname("localhost") );
		Sys.println( "IsValidName hello=" + cert.isValidHostname("hello") );
	}

}
