class TestClient {

	public function new(){
		var sock = new sys.ssl.Socket();
		sock.setCertLocation( "cert/root.crt", "cert" );
		sock.useCertificate( "cert/client.crt", "cert/client.key" );
		sock.connect( new sys.net.Host("localhost"), 5566 );
		var cert = sock.peerCertificate();
		Sys.println( "Server CN=" + cert.commonName );
		
		sock.output.writeString("Ping");
		sock.output.flush();
		Sys.println( "Server response: " + sock.input.readString(4) );
		sock.close();
		
		// Second connection, with SNI on foo.bar		
		var sock2 = new sys.ssl.Socket();
		sock2.setCertLocation( "cert/root.crt", "cert" );
		sock2.useCertificate( "cert/client.crt", "cert/client.key" );
		sock2.setHostname( "foo.bar" );
		sock2.connect( new sys.net.Host("localhost"), 5566 );
		
		var cert2 = sock2.peerCertificate();
		Sys.println( "Server SNI CN=" + cert2.commonName );
		
		sock2.output.writeString("Gnip");
		sock2.output.flush();
		sock2.close();
		
		
		
	}

}
