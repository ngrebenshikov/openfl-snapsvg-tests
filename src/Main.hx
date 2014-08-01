package ;

import flash.LibTest;
import flash.display.DisplayObjectTest;
import flash.display.GraphicsTest;

class Main {
    public function new() {}
    public static function main() {
        var r = new haxe.unit.TestRunner();
        r.add(new LibTest());
        r.add(new DisplayObjectTest());
        r.add(new GraphicsTest());
        r.run();
    }
}
