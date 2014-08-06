package flash.display;

import massive.munit.Assert;
import massive.munit.async.AsyncFactory;
import flash.events.Event;

class GraphicsTest {
    private var g: Graphics;
    private var sprite: Sprite;

    @BeforeClass
    public function beforeClass():Void {}

    @AfterClass
    public function afterClass():Void {}

    @Before
    public function setup():Void {
        sprite = new Sprite();
        g = sprite.graphics;
        Lib.current.addChild(sprite);
    }

    @After
    public function tearDown():Void {
        g.clear();
        Lib.current.removeChild(sprite);
        sprite = null;
        g = null;
    }

    @AsyncTest
    public function testLineTo1(asyncFactory: AsyncFactory) {
        g.lineStyle(10, 0x123456, 0.4, true, LineScaleMode.NORMAL, CapsStyle.ROUND, JointStyle.BEVEL, 5);
        g.beginFill(0x654321, 0.4);
        g.moveTo(100,100);
        g.lineTo(200, 200);

        testLineToHandler = asyncFactory.createHandler(this, function() {
            var path = g.__snap.select("path");
            Assert.isNotNull(path);
            Assert.areEqual("M100 100 L200 200 Z", path.attr("d"));
            Assert.areEqual("rgba(18, 52, 86, 0.4)", path.attr("stroke"));
            Assert.areEqual("rgba(101, 67, 33, 0.4)", path.attr("fill"));
            Assert.areEqual("stroke-width: 10px; stroke-linecap: round; stroke-linejoin: bevel; stroke-miterlimit: 5;", path.attr("style"));
            Assert.areEqual("none", path.attr("vector-effect"));
            testLineToHandler = null;
        }, 300);
        Lib.__getStage().addEventListener(Event.STAGE_RENDERED, testLineToHandler);
    }
    private var testLineToHandler: Dynamic;

    @AsyncTest
    public function testLineTo2(asyncFactory: AsyncFactory) {
        g.lineStyle(10, 0x123456, 0.4, true, LineScaleMode.NONE, CapsStyle.SQUARE, JointStyle.ROUND, 5);
        g.beginFill(0x654321, 0.4);
        g.moveTo(23, 567);
        g.lineTo(987, 456);

        testLineToHandler = asyncFactory.createHandler(this, function() {
            var path = g.__snap.select("path");
            Assert.isNotNull(path);
            Assert.areEqual("M23 567 L987 456 Z", path.attr("d"));
            Assert.areEqual("rgba(18, 52, 86, 0.4)", path.attr("stroke"));
            Assert.areEqual("rgba(101, 67, 33, 0.4)", path.attr("fill"));
            Assert.areEqual("stroke-width: 10px; stroke-linecap: square; stroke-linejoin: round; stroke-miterlimit: 5;", path.attr("style"));
            Assert.areEqual("non-scaling-stroke", path.attr("vector-effect"));
            testLineToHandler = null;
        }, 300);
        Lib.__getStage().addEventListener(Event.STAGE_RENDERED, testLineToHandler);
    }

    @AsyncTest
    public function testCurveTo1(asyncFactory: AsyncFactory) {
        g.lineStyle(5, 0x0000FF, 0.7, true, LineScaleMode.NONE, CapsStyle.ROUND, JointStyle.ROUND, 7);
        g.moveTo(250, 200);
        g.curveTo(300, 0, 350, 200);
        testCurveHandler = asyncFactory.createHandler(this, function() {
            var path = g.__snap.select("path");
            Assert.isNotNull(path);
            Assert.areEqual("M250 200 Q300 0 350 200 Z", path.attr("d"));
            Assert.areEqual("rgba(0, 0, 255, 0.7)", path.attr("stroke"));
            Assert.areEqual("transparent", path.attr("fill"));
            Assert.areEqual("stroke-width: 5; stroke-linecap: round; stroke-linejoin: round; stroke-miterlimit: 7;", path.attr("style"));
            Assert.areEqual("non-scaling-stroke", path.attr("vector-effect"));
            testCurveHandler = null;
        }, 300);
        Lib.__getStage().addEventListener(Event.STAGE_RENDERED, testCurveHandler);
    }

    private var testCurveHandler: Dynamic;

    @AsyncTest
    public function testCurveTo2(asyncFactory: AsyncFactory) {
        g.lineStyle(30, 0xFFEEAA, 0.3, true, LineScaleMode.NONE, CapsStyle.SQUARE, JointStyle.BEVEL, 4);
        g.beginFill(0x642A15, 0.85);
        g.moveTo(200, 250);
        g.curveTo(400, 450 , 500, 200);
        testCurveHandler = asyncFactory.createHandler(this, function() {
            var path = g.__snap.select("path");
            Assert.isNotNull(path);
            Assert.areEqual("M200 250 Q400 450 500 200 Z", path.attr("d"));
            Assert.areEqual("rgba(255, 238, 170, 0.3)", path.attr("stroke"));
            Assert.areEqual("rgba(100, 42, 21, 0.85)", path.attr("fill"));
            Assert.areEqual("stroke-width: 30; stroke-linecap: square; stroke-linejoin: bevel; stroke-miterlimit: 4;", path.attr("style"));
            Assert.areEqual("non-scaling-stroke", path.attr("vector-effect"));
            testCurveHandler = null;
        }, 300);
        Lib.__getStage().addEventListener(Event.STAGE_RENDERED, testCurveHandler);
    }
}