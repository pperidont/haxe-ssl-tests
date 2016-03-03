class TestClient {

	public function new(){
		var sock = new sys.ssl.Socket();
		sock.setCertLocation( "cert/root.crt", "cert" );
		sock.useCertificate( "cert/client.crt", "cert/client.key" );
		sock.connect( new sys.net.Host("localhost"), 5566 );
		sock.output.writeString("Ping");
		sock.output.flush();
		Sys.println( "Server response: " + sock.input.readString(4) );

		var cert = sock.peerCertificate();
		Sys.println( "Server CN=" + cert.commonName );
		Sys.println( "Server altNames=" + cert.altNames );
		Sys.println( "IsValidDate=" + cert.isValidDate() );
		Sys.println( "Now cmpNotBefore=" + cert.cmpNotBefore(Date.now()) );
		Sys.println( "Now cmpNotAfter=" + cert.cmpNotAfter(Date.now()) );
		Sys.println( "Yesterday cmpNotBefore=" + cert.cmpNotBefore(DateTools.delta(Date.now(), DateTools.days(-1))) );
		Sys.println( "NextYear cmpNotAfter=" + cert.cmpNotAfter(DateTools.delta(Date.now(), DateTools.days(365))) );
		Sys.println( "IsValidName localhost=" + cert.isValidHostname("localhost") );
		Sys.println( "IsValidName hello=" + cert.isValidHostname("hello") );

		sock.close();
	}

}
