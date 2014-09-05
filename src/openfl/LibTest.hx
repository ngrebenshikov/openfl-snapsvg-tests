package openfl;

import massive.munit.Assert;
import flash.display.Graphics;

class LibTest  {
    @Test
    public function testCurrent() {
        var cur = Lib.current;
        Assert.isTrue(null != cur);
        Assert.isTrue(null != cur.graphics.__snap.node);
        Assert.areEqual("Root_MovieClip", cur.graphics.__snap.parent().node.attributes.getNamedItem("id").nodeValue);
        Assert.areEqual(Lib.SNAP_IDENTIFIER + "-stage", cur.snap.parent().node.attributes.getNamedItem("id").nodeValue);
        Assert.areEqual("haxe-openfl-svg", cur.snap.parent().parent().node.attributes.getNamedItem("id").nodeValue);
    }
}
