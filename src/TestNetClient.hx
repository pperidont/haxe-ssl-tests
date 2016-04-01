import sys.net.*;

class TestNetClient {

	public function new(){
		var len = 1024;
		var b = haxe.io.Bytes.alloc(len);

		try {
			Sys.println("Try to connect...");
			var sock = new sys.net.Socket();
			sock.connect( new sys.net.Host("localhost"), 5566 );
			
			sock.output.writeString("ping");
			sock.output.flush();
			var l = sock.input.readBytes(b,0,len);
			var resp = b.sub(0,l).toString();
			Sys.println( "Server response: " + resp );
			sock.close();
		}catch( e : Dynamic ){
			Sys.println("Error: "+Std.string(e)+"\nStack: "+haxe.CallStack.toString(haxe.CallStack.exceptionStack()));
		}

		Sys.println("**********************");
		
		try {
			Sys.println("Try to connect...");
			var sock = new sys.net.Socket();
			sock.connect( new sys.net.Host("localhost"), 5566 );
			
			sock.output.writeString("Hello");
			sock.output.flush();
			sock.output.writeString(" World!");
			sock.output.flush();
			var l = sock.input.readBytes(b,0,len);
			var resp = b.sub(0,l).toString();
			Sys.println( "Server response: " + resp );
			sock.close();
		}catch( e : Dynamic ){
			Sys.println("Error: "+Std.string(e)+"\nStack: "+haxe.CallStack.toString(haxe.CallStack.exceptionStack()));
		}

		
	}

}
