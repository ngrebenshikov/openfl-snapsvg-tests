package flash.display;

import haxe.unit.TestCase;

class DisplayObjectTest extends TestCase {
    public function testAddChild() {
        var s = new Sprite();
        Lib.current.addChild(s);

        assertTrue(s.graphics.__snap.parent() != null);
        assertTrue(s.graphics.__snap.parent().node == Lib.current.graphics.__snap.node);
    }
}
