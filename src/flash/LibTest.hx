package flash;

import flash.display.Graphics;
import haxe.unit.TestCase;

class LibTest extends TestCase {
    public function testCurrent() {
        var g = new Graphics();
        //trace(Lib.stageSnap.node);
        //trace(g.__snap.node);
        Lib.stageSnap.append(g.__snap);
        //g.__snap.parent().node.removeChild(g.__snap.node);
        //Lib.stageSnap.node.appendChild(g.__snap.node);

        //var g1 = Lib.stageSnap;//Lib.snap.group().attr({id:"stage"});
        //var g2 = Lib.freeSnap;//Lib.snap.group().attr({id:"free", visibility:"hidden"});
        //var g3 = Lib.snap.group();
        //Lib.freeSnap.append(g3);
        //Lib.stageSnap.append(g3);

        var cur = Lib.current;
        assertTrue(null != cur);
        assertTrue(null != cur.graphics.__snap.node);
        assertEquals("Root_MovieClip", cur.graphics.__snap.node.attributes.getNamedItem("id").nodeValue);
        assertEquals(Lib.SNAP_IDENTIFIER + "-stage", cur.graphics.__snap.parent().node.attributes.getNamedItem("id").nodeValue);
        assertEquals("haxe-openfl-svg", cur.graphics.__snap.parent().parent().node.attributes.getNamedItem("id").nodeValue);
    }
}
