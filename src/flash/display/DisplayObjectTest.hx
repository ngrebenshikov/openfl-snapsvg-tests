package flash.display;


import massive.munit.async.AsyncFactory;
import flash.events.Event;
import flash.geom.Point;
import massive.munit.Assert;

class DisplayObjectTest {

    private var asyncHandler: Dynamic;

    @Before
    public function setup():Void {
       Lib.current.removeChildren();
    }

    @After
    public function tearDown():Void {
       Lib.current.removeChildren();
    }

    @Test
    public function testAddChild() {
        var s = new Sprite();
        Lib.current.addChild(s);

        Assert.isTrue(s.snap.parent() != null);
        Assert.isTrue(s.snap.parent().node == Lib.current.snap.node);
    }

    @AsyncTest
    public function testPositioning(asyncFactory: AsyncFactory) {
        var child = new Sprite();

            child.x = 123;
            child.y = 345;
            child.name = "child";
            child.graphics.beginFill(0xff0000);
            child.graphics.drawRect(0,0,100,100);

            var grandchild = new Sprite();

                grandchild.x = 12;
                grandchild.y = 35;
                grandchild.name = "grandchild";
                grandchild.graphics.beginFill(0x00ff00);
                grandchild.graphics.drawRect(0,0,100,100);

            child.addChild(grandchild);

        Lib.current.addChild(child);

        var childPoint = child.localToGlobal(new Point(0,0));
        Assert.areEqual(123, childPoint.x);
        Assert.areEqual(345, childPoint.y);

        var grandchildPoint = grandchild.localToGlobal(new Point(0,0));
        Assert.areEqual(123+12, grandchildPoint.x);
        Assert.areEqual(345+35, grandchildPoint.y);

        asyncHandler = asyncFactory.createHandler(this, function() {
            Assert.areEqual("m1,0,0,1,123,345", child.snap.attr("transform"));
            Assert.areEqual("m1,0,0,1,12,35", grandchild.snap.attr("transform"));
            Assert.isTrue(child.snap.node == grandchild.snap.parent().node);

            Lib.__getStage().removeEventListener(Event.STAGE_RENDERED, asyncHandler);
        }, 300);
        Lib.__getStage().addEventListener(Event.STAGE_RENDERED, asyncHandler);

    }

    @AsyncTest
    public function testRotation1(asyncFactory: AsyncFactory) {
        var child = new Sprite();

        child.x = 150;
        child.y = 150;
        child.rotation = 15;
        child.graphics.beginFill(0xff0000);
        child.graphics.drawRect(-50,-50,100,100);

        Lib.current.addChild(child);

        asyncHandler = asyncFactory.createHandler(this, function() {
            Assert.areEqual("m0.966,0.259,-0.259,0.966,150,150", child.snap.attr("transform"));
            Lib.__getStage().removeEventListener(Event.STAGE_RENDERED, asyncHandler);
        }, 300);
        Lib.__getStage().addEventListener(Event.STAGE_RENDERED, asyncHandler);
    }

    @AsyncTest
    public function testRotation2(asyncFactory: AsyncFactory) {
        var child = new Sprite();

        child.x = 150;
        child.y = 150;
        child.rotation = -15;
        child.graphics.beginFill(0x00ff00);
        child.graphics.drawRect(-50,-50,100,100);

        Lib.current.addChild(child);

        asyncHandler = asyncFactory.createHandler(this, function() {
            Assert.areEqual("m0.966,-0.259,0.259,0.966,150,150", child.snap.attr("transform"));
            Lib.__getStage().removeEventListener(Event.STAGE_RENDERED, asyncHandler);
        }, 300);
        Lib.__getStage().addEventListener(Event.STAGE_RENDERED, asyncHandler);
    }
}
