package flash.display;

import haxe.unit.TestCase;

class DisplayObjectTest extends TestCase {
    public function testAddChild() {
        var s = new Sprite();
        Lib.current.addChild(s);

        assertTrue(s.snap.parent() != null);
        assertTrue(s.snap.parent().node == Lib.current.snap.node);
    }
}
