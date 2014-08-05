package flash.display;

import massive.munit.Assert;
import massive.munit.async.AsyncFactory;
import flash.events.Event;

class GraphicsTest {
    private var g: Graphics;

    @BeforeClass
    public function beforeClass():Void {}

    @AfterClass
    public function afterClass():Void {}

    @Before
    public function setup():Void {
        g = Lib.current.graphics;
        g.clear();
    }

    @After
    public function tearDown():Void {
        g.clear();
    }

    @AsyncTest
    public function testLineTo1(asyncFactory: AsyncFactory) {
        var g:Graphics = Lib.current.graphics;
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
        var g:Graphics = Lib.current.graphics;
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
    public function testCurveTo(asyncFactory: AsyncFactory) {
        var g: Graphics = Lib.current.graphics;

        g.lineStyle(5, 0x0000FF);
        g.moveTo(250, 200);
        g.curveTo(300, 0, 350, 200);
        g.curveTo(400, 450 , 500, 200);
        testCurveHandler = asyncFactory.createHandler(this, assertsTestCurveTo, 300);
        Lib.__getStage().addEventListener(Event.STAGE_RENDERED, testCurveHandler);
    }

    private var testCurveHandler: Dynamic;

    private function assertsTestCurveTo() {
        Lib.__getStage().removeEventListener(Event.STAGE_RENDERED, testCurveHandler);
        testCurveHandler = null;
        var g: Graphics = Lib.current.graphics;
        trace(g.__snap);
        Assert.isTrue(true);
    }
}