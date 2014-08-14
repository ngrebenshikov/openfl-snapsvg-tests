package flash.display;


import tools.Helper;

import haxe.Timer;
import snap.Snap;
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

    @AsyncTest
    public function testScaling(asyncFactory: AsyncFactory) {
        var child = new Sprite();

        child.x = 150;
        child.y = 150;
        child.graphics.beginFill(0x0000ff);
        child.graphics.drawRect(0,0,100,100);
        Lib.current.addChild(child);

        Assert.areEqual(100, child.width);
        Assert.areEqual(100, child.height);
        child.scaleX = 2.1;
        child.scaleY = 3.5;
        Assert.areEqual(210, child.width);
        Assert.areEqual(350, child.height);

        asyncHandler = asyncFactory.createHandler(this, function() {
            Lib.__getStage().removeEventListener(Event.STAGE_RENDERED, asyncHandler);
            Assert.areEqual("m2.1,0,0,3.5,150,150", child.snap.attr("transform"));
            Assert.areEqual(210, child.width);
            Assert.areEqual(350, child.height);
            var box = child.snap.getBBox();
            Assert.areEqual(210, box.width);
            Assert.areEqual(350, box.height);
        }, 300);
        Lib.__getStage().addEventListener(Event.STAGE_RENDERED, asyncHandler);
    }

    @AsyncTest
    public function testSize(asyncFactory: AsyncFactory) {

        var child = new Sprite();


        child.x = 150;
        child.y = 150;
        child.graphics.beginFill(0xff00ff);
        child.graphics.drawRect(0,0,100,100);
        Lib.current.addChild(child);

        Assert.areEqual(100, child.width);
        Assert.areEqual(100, child.height);
        child.width = 205;
        child.height = 301;
        Assert.isTrue(Math.abs(205 - child.width) < 0.01);
        Assert.isTrue(Math.abs(301 - child.height) < 0.01);
        Assert.areEqual(2.05, child.scaleX);
        Assert.areEqual(3.01, child.scaleY);

        asyncHandler = asyncFactory.createHandler(this, function() {
            Lib.__getStage().removeEventListener(Event.STAGE_RENDERED, asyncHandler);
            Assert.areEqual("m2.05,0,0,3.01,150,150", child.snap.attr("transform"));
            var box = child.snap.getBBox();
            Assert.isTrue(Math.abs(205 - box.width) < 0.01);
            Assert.isTrue(Math.abs(301 - box.height) < 0.01);
        }, 300);
        Lib.__getStage().addEventListener(Event.STAGE_RENDERED, asyncHandler);
    }

    @AsyncTest
    public function testMask(asyncFactory: AsyncFactory) {

        var child = new Sprite();
        child.x = 150;
        child.y = 150;
        child.graphics.beginFill(0xffff00);
        child.graphics.drawRect(0,0,100,100);
        Lib.current.addChild(child);

        var maskedChild = new Sprite();
        maskedChild.x = 150;
        maskedChild.y = 150;
        maskedChild.graphics.beginFill(0xff0000);
        maskedChild.graphics.drawRect(0,0,100,100);

        Lib.current.addChild(maskedChild);

        var mask = new Shape();
        mask.graphics.beginFill(0xffffff);
        mask.graphics.drawRect(25,25,50,50);

        maskedChild.mask = mask;

        var maskId: String;

        asyncHandler = asyncFactory.createHandler(this, function() {
            Lib.__getStage().removeEventListener(Event.STAGE_RENDERED, asyncHandler);

            Assert.isNotNull(maskedChild.snap.attr('mask'));

            maskId = Helper.getAnchorIdFromUrl(maskedChild.snap.attr('mask'));
            Assert.isNotNull(maskId);

            var mask = Snap.select('#' + maskId);
            Assert.isNotNull(mask);

            Assert.areEqual('mask', mask.type);

            var rect = mask.select('rect');
            Assert.areEqual('25', rect.attr('x'));
            Assert.areEqual('25', rect.attr('y'));
            Assert.areEqual('50', rect.attr('width'));
            Assert.areEqual('50', rect.attr('height'));
            Assert.areEqual('0', rect.attr('rx'));
            Assert.areEqual('0', rect.attr('ry'));
            Assert.isTrue(tools.Color.areColorsEqual('rgb(255, 255, 255)', rect.attr('fill')));

            //Test canceling a mask
            maskedChild.mask = null;
        }, 500);
        Lib.__getStage().addEventListener(Event.STAGE_RENDERED, asyncHandler);

        Timer.delay(asyncFactory.createHandler(this, function() {
                    Assert.isTrue(null == maskedChild.snap.attr('mask') || 'none' == maskedChild.snap.attr('mask'));
                    Assert.isNull(Snap.select('#' + maskId));
                }, 3000),
            2000);
    }

//    @AsyncTest
//    public function testBlendMode(asyncFactory: AsyncFactory) {
//
//        var child1 = new Sprite();
//        child1.x = 150;
//        child1.y = 150;
//        child1.graphics.beginFill(0xff00ff);
//        child1.graphics.drawRect(0,0,100,100);
//        Lib.current.addChild(child1);
//
//        var child2 = new Sprite();
//        child2.x = 190;
//        child2.y = 190;
//        child2.graphics.beginFill(0xff0000);
//        child2.graphics.drawRect(0,0,100,100);
//        child2.blendMode = BlendMode.SCREEN;
//        Lib.current.addChild(child2);
//
//        asyncHandler = asyncFactory.createHandler(this, function() {
//            Lib.__getStage().removeEventListener(Event.STAGE_RENDERED, asyncHandler);
//        }, 500);
//        Lib.__getStage().addEventListener(Event.STAGE_RENDERED, asyncHandler);
//    }

}
