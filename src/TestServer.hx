class TestServer {

	public function new(){
		var s = new sys.ssl.Socket();
		s.useCertificate( "cert/localhost.crt", "cert/localhost.key" );
		s.setCipherList("EECDH+ECDSA+AESGCM EECDH+aRSA+AESGCM EECDH+ECDSA+SHA384 EECDH+ECDSA+SHA256 EECDH+aRSA+SHA384 EECDH+aRSA+SHA256 ECDHE-RSA-AES128-SHA AES128-SHA DES-CBC3-SHA EECDH EDH+aRSA !RC4 !aNULL !eNULL !LOW !MD5 !EXP !PSK !SRP !DSS", true);
		s.addSNICertificate( function(s) return s == "foo.bar", "cert/foo.bar.crt", "cert/foo.bar.key" );
		s.setCertLocation( "cert/root.crt", "cert" );
		s.bind( new sys.net.Host("localhost"), 5566 );
		s.listen( 20 );
		while( true ){
			var s = s.accept();
			var peer = s.peer();
			Sys.println("New connection from: " + peer.host.toString() + ":" + peer.port);
			var peerCert = s.peerCertificate();
			Sys.println("Client name="+peerCert.subject("CN")+" ("+peerCert.subject("O")+") email="+peerCert.subject("emailAddress")+" verified by "+peerCert.issuer("O"));
			var str = s.input.readString(4);
			Sys.println("Receive: "+str);
			if( str == "Ping" ){
				s.output.writeString( "Pong" );
				s.output.flush();
			}
			s.close();
		}
	}

}
