import sys.ssl.*;

class TestClient {

	public function new(){
		try {
			Sys.println("Try to connect...");
			var sock = new sys.ssl.Socket();
			sock.setCA( Certificate.loadFile("cert/root.crt") );
			sock.setCertificate( Certificate.loadFile("cert/client.crt"), Key.readPEM(sys.io.File.getContent("cert/client.key"), false) );
			sock.connect( new sys.net.Host("localhost"), 5566 );
			var cert = sock.peerCertificate();
			Sys.println( "Server CN=" + cert.commonName );
			
			sock.output.writeString("ping");
			sock.output.flush();
			Sys.println( "Server response: " + sock.input.readString(4) );
			sock.close();
		}catch( e : Dynamic ){
			Sys.println("Error: "+Std.string(e)+"\nStack: "+haxe.CallStack.toString(haxe.CallStack.exceptionStack()));
		}

		Sys.println("**********************");
		
		// Second connection, with SNI on foo.bar		
		try {
			Sys.println("Try to connect...");
			var sock = new sys.ssl.Socket();
			sock.setCA( Certificate.loadFile("cert/root.crt") );
			sock.setCertificate( Certificate.loadFile("cert/client.crt"), Key.readPEM(sys.io.File.getContent("cert/client.key"), false) );
			sock.setHostname( "foo.bar" );
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
