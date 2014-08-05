package flash.display;


import massive.munit.Assert;
class DisplayObjectTest {
    @Test
    public function testAddChild() {
        var s = new Sprite();
        Lib.current.addChild(s);

        Assert.isTrue(s.snap.parent() != null);
        Assert.isTrue(s.snap.parent().node == Lib.current.snap.node);
    }
}
