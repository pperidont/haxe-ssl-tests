import sys.ssl.*;

class TestErrors {

	public function new(){
		var sock = null;
		var cert = null;

		try {
			sock = new sys.ssl.Socket();
			sock.output.writeString("ping");
		}catch( e : Dynamic ){
			Sys.println("OK: "+Std.string(e)+"\nStack: "+haxe.CallStack.toString(haxe.CallStack.exceptionStack()));
		}
		sock.close();

		try {
			sock = new sys.ssl.Socket();
			sock.setCA( Certificate.loadFile("cert/root.crt") );
			sock.setCertificate( Certificate.loadFile("cert/client.crt"), Key.readPEM(sys.io.File.getContent("cert/client.key"), false) );
			sock.connect( new sys.net.Host("localhost"), 5566 );
			
			cert = sock.peerCertificate();
			
			sock.output.writeString("pong");
			sock.output.flush();
			sock.close();
		}catch( e : Dynamic ){
			Sys.println("Error: "+Std.string(e)+"\nStack: "+haxe.CallStack.toString(haxe.CallStack.exceptionStack()));
		}

		try {
			sock.close();
		}catch( e : Dynamic ){
			Sys.println("OK: "+Std.string(e)+"\nStack: "+haxe.CallStack.toString(haxe.CallStack.exceptionStack()));
		}

		try {
			cert.subject("CN");
		}catch( e : Dynamic ){
			Sys.println("OK: "+Std.string(e)+"\nStack: "+haxe.CallStack.toString(haxe.CallStack.exceptionStack()));
		}

		
	}

}
