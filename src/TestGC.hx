#if neko
typedef Gc = neko.vm.Gc;
#elseif cpp
typedef Gc = cpp.vm.Gc;
#end

class TestGC {

	public function new(){
		var def = sys.ssl.Certificate.loadDefaults();
		def.add( sys.io.File.getContent("cert/localhost.crt") );
		def.addDER( sys.io.File.getBytes("cert/foo.bar.der") );
		while( def != null ){
			trace( def.commonName );
			def = def.next();
			Gc.run( true );
		}
	}

}
