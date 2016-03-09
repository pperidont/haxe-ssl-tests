class TestHttp {

	public function new() {
		sys.ssl.Socket.DEFAULT_CA = sys.ssl.Certificate.loadFile("cert/global.cer");
		
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
