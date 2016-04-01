
class TestNetServer {

	public function new(){
		var s = new sys.net.Socket();

		#if neko
		var keepalive = neko.Lib.load("std", "socket_set_keepalive",4);
		#end
		
		s.bind( new sys.net.Host("localhost"), 5566 );
		s.listen( 20 );

		var bufsize = 1024;
		var b = haxe.io.Bytes.alloc( bufsize );
		while( true ){
			try {
				Sys.println("Accept...");
				var c = s.accept();
				#if neko
				keepalive( @:privateAccess c.__s, true, 60, 5 );
				#end
				var peer = c.peer();
				Sys.print("Peer:"+peer.host.toString()+":"+peer.port+". ");
				
				var l = c.input.readBytes( b, 0, bufsize );
				var msg = b.sub(0,l).toString();
				Sys.println("Client message: "+msg);
				c.output.writeString( msg.toUpperCase() );
				c.output.flush();
				c.close();
			}catch( e : Dynamic ){
				Sys.println("Error: "+Std.string(e)+"\nStack: "+haxe.CallStack.toString(haxe.CallStack.exceptionStack()));
			}
			Sys.println("*************");
		}
	}

}
