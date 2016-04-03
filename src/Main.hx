class Main {

	static function main(){
		var args : Array<String>;
		#if neko
		if ( neko.Web.isModNeko )
			args = [neko.Web.getParams().get("test")];
		else
		#end
			args = Sys.args();
		switch( args.shift() ){
			case "http": new TestHttp();
			case "client": new TestClient();
			case "netClient": new TestNetClient();
			case "client2": new TestClient2();
			case "errors": new TestErrors();
			case "server": new TestServer();
			case "netServer": new TestNetServer();
			case "certificate": new TestCert();
			case "digest": new TestDigest();
			case "threads": new TestThreads();
			case "gc": new TestGC();
			default:
				Sys.println("Unknown test");
		}
	}

}
