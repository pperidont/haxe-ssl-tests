typedef Thread = #if neko neko.vm.Thread #elseif cpp cpp.vm.Thread #end ;

class TestThreads {

	public function new() {
		var privKey = sys.ssl.Key.loadFile( "keys/private.der", false );
		
		var threads = 15;
		for ( i in 0...threads )
			Thread.create(run.bind(i, privKey, Thread.current()));
		
		while ( threads > 0 ){
			var m = Thread.readMessage(true);
			Sys.println( m );
			threads--;
		}
	}
	
	function run( id : Int, privKey : sys.ssl.Key, mainThread : Thread ) {
		var data = haxe.io.Bytes.ofString("Hello World!");
		var sign = sys.ssl.Digest.sign( data, privKey, SHA256 );
		
		mainThread.sendMessage( "Thread#"+id+": "+sign.toHex().substr(0,5) );
	}
	
}