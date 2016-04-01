class Main {

	static function main(){
		var args = Sys.args();
		switch( args.shift() ){
			case "http": new TestHttp();
			case "client": new TestClient();
			case "client2": new TestClient2();
			case "errors": new TestErrors();
			case "server": new TestServer();
			case "certificate": new TestCert();
			case "digest": new TestDigest();
			case "threads": new TestThreads();
			case "gc": new TestGC();
			default:
				Sys.println("Unknown test");
		}
	}

}
