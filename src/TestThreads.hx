typedef Thread = #if neko neko.vm.Thread #elseif cpp cpp.vm.Thread #end ;

class TestThreads {

	public function new() {
		var privKey = sys.ssl.Key.loadFile( "keys/private.der", false );
		for ( i in 0...15 )
			Thread.create(run.bind(i,privKey));
			
		Sys.sleep( 1 );
	}
	
	function run( id : Int, privKey : sys.ssl.Key ) {
		var data = haxe.io.Bytes.ofString("Hello World!");
		var sign = sys.ssl.Digest.sign( data, privKey, SHA256 );
		
		Sys.println( "Thread#"+id+": "+sign.toHex().substr(0,5) );
	}
	
}