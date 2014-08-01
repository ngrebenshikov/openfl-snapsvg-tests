import ::APP_MAIN_PACKAGE::::APP_MAIN_CLASS::;

class ApplicationMain {

	public static function main() {
		if (Reflect.field(::APP_MAIN::, "main") == null) {
			Type.createInstance(::APP_MAIN::, []);
		} else {
			Reflect.callMethod(::APP_MAIN::, Reflect.field(::APP_MAIN::, "main"), []);
		}
	}
}