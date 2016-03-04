class TestClient2 {

	public function new(){

		// ...with SNI on unknown.bar
		try {
			Sys.println("Try to connect...");
			var sock = new sys.ssl.Socket();
			sock.setCertLocation( "cert/root.crt", "cert" );
			sock.useCertificate( "cert/client.crt", "cert/client.key" );
			sock.setHostname( "unknown.bar" );
			sock.connect( new sys.net.Host("localhost"), 5566 );
			
			var cert = sock.peerCertificate();
			Sys.println( "Server CN=" + cert.commonName );
			
			sock.output.writeString("pong");
			sock.output.flush();
			Sys.println( "Server response: " + sock.input.readString(4) );
			sock.close();
		}catch( e : Dynamic ){
			Sys.println("Error: "+Std.string(e)+"\nStack: "+haxe.CallStack.toString(haxe.CallStack.exceptionStack()));
		}

		Sys.println("**********************");

		// ...with client2
		try {
			Sys.println("Try to connect...");
			var sock = new sys.ssl.Socket();
			sock.setCertLocation( "cert/root.crt", "cert" );
			sock.useCertificate( "cert/client2.crt", "cert/client2.key" );
			sock.connect( new sys.net.Host("localhost"), 5566 );
			
			var cert = sock.peerCertificate();
			Sys.println( "Server CN=" + cert.commonName );
			
			sock.output.writeString("pong");
			sock.output.flush();
			Sys.println( "Server response: " + sock.input.readString(4) );
			sock.close();
		}catch( e : Dynamic ){
			Sys.println("Error: "+Std.string(e)+"\nStack: "+haxe.CallStack.toString(haxe.CallStack.exceptionStack()));
		}
		
		
	}

}
