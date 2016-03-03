class TestHttp {

	public function new(){
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
