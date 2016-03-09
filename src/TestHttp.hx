class TestHttp {

	public function new() {
		var ca = sys.ssl.Certificate.loadFile("cert/global.cer");
		trace( ca.subject("CN") );
		sys.ssl.Socket.setDefaultCA( ca );
		var h = new haxe.Http("https://google.com");
		h.onData = function(d){
			Sys.print( d );
		}
		h.onError = function(e){
			throw e;
		}
		h.request( false );
	}

}
