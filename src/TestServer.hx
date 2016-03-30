import sys.ssl.*;

class TestServer {

	public function new(){
		var s = new sys.ssl.Socket();

		#if neko
		var keepalive = neko.Lib.load("std", "socket_set_keepalive",4);
		#end
		
		s.setCA( Certificate.loadFile("cert/root.crt") );
		s.setCertificate( Certificate.loadFile("cert/localhost.crt"), Key.readPEM(sys.io.File.getContent("cert/localhost.key"), false) );

		s.addSNICertificate( function(s){ Sys.println("Client SNI="+s); return s == "foo.bar"; }, Certificate.loadFile("cert/foo.bar.crt"), Key.readPEM(sys.io.File.getContent("cert/foo.bar.key"), false) );
		s.addSNICertificate( function(s) return s == "unknown.bar", Certificate.loadFile("cert/unknown.bar.crt"), Key.readPEM(sys.io.File.getContent("cert/unknown.bar.key"), false) );

		s.bind( new sys.net.Host("localhost"), 5566 );
		s.listen( 20 );
		while( true ){
			try {
				Sys.println("Accept...");
				var c = s.accept();
				Sys.println("New connection! Handshaking...");
				c.handshake();
				#if neko
				keepalive( @:privateAccess c.__s, true, 60, 5 );
				#end
				var peer = c.peer();
				Sys.print("Peer:"+peer.host.toString()+":"+peer.port+". ");
				var peerCert = c.peerCertificate();
				Sys.println("PeerCert: Name="+peerCert.subject("CN")+", Org="+peerCert.subject("O")+", Email="+peerCert.subject("emailAddress")+", Verified by "+peerCert.issuer("O"));
				var str = c.input.readString(4);
				c.output.writeString( str.toUpperCase() );
				c.output.flush();
				c.close();
			}catch( e : Dynamic ){
				Sys.println("Error: "+Std.string(e)+"\nStack: "+haxe.CallStack.toString(haxe.CallStack.exceptionStack()));
			}
			Sys.println("*************");
		}
	}

}
