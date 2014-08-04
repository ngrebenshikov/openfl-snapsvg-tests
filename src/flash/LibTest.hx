package flash;

import flash.display.Graphics;
import haxe.unit.TestCase;

class LibTest extends TestCase {
    public function testCurrent() {
        var cur = Lib.current;
        assertTrue(null != cur);
        assertTrue(null != cur.graphics.__snap.node);
        assertEquals("Root_MovieClip", cur.graphics.__snap.parent().node.attributes.getNamedItem("id").nodeValue);
        assertEquals(Lib.SNAP_IDENTIFIER + "-stage", cur.snap.parent().node.attributes.getNamedItem("id").nodeValue);
        assertEquals("haxe-openfl-svg", cur.snap.parent().parent().node.attributes.getNamedItem("id").nodeValue);
    }
}
