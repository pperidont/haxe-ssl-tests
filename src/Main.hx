class Main {

	static function main(){
		var args = Sys.args();
		switch( args.shift() ){
			case "http": new TestHttp();
			case "client": new TestClient();
			case "server": new TestServer();
			case "certificate": new TestCert();
			default:
				Sys.println("Unknown test");
		}
	}

}
