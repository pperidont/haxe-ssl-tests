import sys.ssl.*;

class TestServer {

	public function new(){
		var s = new sys.ssl.Socket();
		
		s.setCA( Certificate.loadFile("cert/root.crt") );
		s.setCertificate( Certificate.loadFile("cert/localhost.crt"), Key.readPEM(sys.io.File.getContent("cert/localhost.key"), false) );

		s.addSNICertificate( function(s){ Sys.println("Client SNI="+s); return s == "foo.bar"; }, Certificate.loadFile("cert/foo.bar.crt"), Key.readPEM(sys.io.File.getContent("cert/foo.bar.key"), false) );
		s.addSNICertificate( function(s) return s == "unknown.bar", Certificate.loadFile("cert/unknown.bar.crt"), Key.readPEM(sys.io.File.getContent("cert/unknown.bar.key"), false) );

		s.bind( new sys.net.Host("localhost"), 5566 );
		s.listen( 20 );
		while( true ){
			try {
				Sys.println("Accept...");
				var s = s.accept();
				var peer = s.peer();
				Sys.print("New connection. From:"+peer.host.toString()+":"+peer.port);
				var peerCert = s.peerCertificate();
				Sys.println("Name="+peerCert.subject("CN")+", Org="+peerCert.subject("O")+", Email="+peerCert.subject("emailAddress")+", Verified by "+peerCert.issuer("O"));
				var str = s.input.readString(4);
				s.output.writeString( str.toUpperCase() );
				s.output.flush();
				s.close();
			}catch( e : Dynamic ){
				Sys.println("Error: "+Std.string(e)+"\nStack: "+haxe.CallStack.toString(haxe.CallStack.exceptionStack()));
			}
			Sys.println("*************");
		}
	}

}
