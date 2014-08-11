package flash.display;

import massive.munit.Assert;
import massive.munit.async.AsyncFactory;
import flash.events.Event;

class GraphicsTest {
    private var g: Graphics;
    private var sprite: Sprite;
    private var strokeWidthPostfix: String;
    private var transparentValue: String;
    private var transformPostfix: String;

    @BeforeClass
    public function beforeClass():Void {
    }

    @AfterClass
    public function afterClass():Void {}

    @Before
    public function setup():Void {
        trace(js.Browser.navigator.userAgent);
        strokeWidthPostfix = if (js.Browser.navigator.userAgent.indexOf("Firefox") != -1) "" else "px";
        transparentValue =
                if (js.Browser.navigator.userAgent.indexOf("Firefox") != -1) "transparent"
                else if (js.Browser.navigator.userAgent.indexOf("PhantomJS") != -1) "rgba(0, 0, 0, 0.0)"
                else "rgba(0, 0, 0, 0)";
        transformPostfix = if (js.Browser.navigator.userAgent.indexOf("PhantomJS") != -1) " " else "";
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

            var strokeParts = cast(path.attr("stroke"), String).split(",");
            Assert.areEqual("rgba(18", strokeParts[0]);
            Assert.areEqual(" 52", strokeParts[1]);
            Assert.areEqual(" 86", strokeParts[2]);
            var alpha = Std.parseFloat(strokeParts[3].substr(0, strokeParts[3].length-1));
            Assert.isTrue(Math.abs(0.4-alpha) < 0.01);

            var fillParts = cast(path.attr("fill"), String).split(",");
            Assert.areEqual("rgba(101", fillParts[0]);
            Assert.areEqual(" 67", fillParts[1]);
            Assert.areEqual(" 33", fillParts[2]);
            var alpha = Std.parseFloat(fillParts[3].substr(0, fillParts[3].length-1));
            Assert.isTrue(Math.abs(0.4-alpha) < 0.01);

            Assert.areEqual("stroke-width: 10" + strokeWidthPostfix + "; stroke-linecap: round; stroke-linejoin: bevel; stroke-miterlimit: 5;" + transformPostfix, path.attr("style"));
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

            var strokeParts = cast(path.attr("stroke"), String).split(",");
            Assert.areEqual("rgba(18", strokeParts[0]);
            Assert.areEqual(" 52", strokeParts[1]);
            Assert.areEqual(" 86", strokeParts[2]);
            var alpha = Std.parseFloat(strokeParts[3].substr(0, strokeParts[3].length-1));
            Assert.isTrue(Math.abs(0.4-alpha) < 0.01);

            var fillParts = cast(path.attr("fill"), String).split(",");
            Assert.areEqual("rgba(101", fillParts[0]);
            Assert.areEqual(" 67", fillParts[1]);
            Assert.areEqual(" 33", fillParts[2]);
            var alpha = Std.parseFloat(fillParts[3].substr(0, fillParts[3].length-1));
            Assert.isTrue(Math.abs(0.4-alpha) < 0.01);

            Assert.areEqual("stroke-width: 10" + strokeWidthPostfix + "; stroke-linecap: square; stroke-linejoin: round; stroke-miterlimit: 5;" + transformPostfix, path.attr("style"));
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

            var strokeParts = cast(path.attr("stroke"), String).split(",");
            Assert.areEqual("rgba(0", strokeParts[0]);
            Assert.areEqual(" 0", strokeParts[1]);
            Assert.areEqual(" 255", strokeParts[2]);
            var alpha = Std.parseFloat(strokeParts[3].substr(0, strokeParts[3].length-1));
            Assert.isTrue(Math.abs(0.7-alpha) < 0.01);

            Assert.areEqual(transparentValue, path.attr("fill"));
            Assert.areEqual("stroke-width: 5" + strokeWidthPostfix + "; stroke-linecap: round; stroke-linejoin: round; stroke-miterlimit: 7;" + transformPostfix, path.attr("style"));
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

            var strokeParts = cast(path.attr("stroke"), String).split(",");
            Assert.areEqual("rgba(255", strokeParts[0]);
            Assert.areEqual(" 238", strokeParts[1]);
            Assert.areEqual(" 170", strokeParts[2]);
            var alpha = Std.parseFloat(strokeParts[3].substr(0, strokeParts[3].length-1));
            Assert.isTrue(Math.abs(0.3-alpha) < 0.01);

            var strokeParts = cast(path.attr("fill"), String).split(",");
            Assert.areEqual("rgba(100", strokeParts[0]);
            Assert.areEqual(" 42", strokeParts[1]);
            Assert.areEqual(" 21", strokeParts[2]);
            var alpha = Std.parseFloat(strokeParts[3].substr(0, strokeParts[3].length-1));
            Assert.isTrue(Math.abs(0.85-alpha) < 0.01);

            Assert.areEqual("stroke-width: 30" + strokeWidthPostfix + "; stroke-linecap: square; stroke-linejoin: bevel; stroke-miterlimit: 4;" + transformPostfix, path.attr("style"));
            Assert.areEqual("non-scaling-stroke", path.attr("vector-effect"));
            testCurveHandler = null;
        }, 300);
        Lib.__getStage().addEventListener(Event.STAGE_RENDERED, testCurveHandler);
    }

    private var testColorFillingHandler: Dynamic;

    @AsyncTest
    public function testColorFilling1(asyncFactory: AsyncFactory) {
        g.lineStyle(7, 0xAABBCC, 1, true, LineScaleMode.NONE, CapsStyle.SQUARE, JointStyle.BEVEL, 4);
        g.beginFill(0xFFEEDD, 0.9);
        g.moveTo(300, 30);
        g.lineTo(400, 30);
        g.lineTo(300, 100);
        g.lineTo(400, 100);
        g.endFill();
        testColorFillingHandler = asyncFactory.createHandler(this, function() {
            var path = g.__snap.select("path");
            Assert.isNotNull(path);
            Assert.areEqual("M300 30 L400 30 L300 100 L400 100 L300 30 Z", path.attr("d"));
            var strokeParts = cast(path.attr("stroke"), String).split(",");
            //if alpha = 1, rgb scheme used
            Assert.areEqual("rgb(170", strokeParts[0]);
            Assert.areEqual(" 187", strokeParts[1]);
            Assert.areEqual(" 204)", strokeParts[2]);

            var strokeParts = cast(path.attr("fill"), String).split(",");
            Assert.areEqual("rgba(255", strokeParts[0]);
            Assert.areEqual(" 238", strokeParts[1]);
            Assert.areEqual(" 221", strokeParts[2]);
            var alpha = Std.parseFloat(strokeParts[3].substr(0, strokeParts[3].length-1));
            Assert.isTrue(Math.abs(0.9-alpha) < 0.01);

            Assert.areEqual("stroke-width: 7" + strokeWidthPostfix + "; stroke-linecap: square; stroke-linejoin: bevel; stroke-miterlimit: 4;" + transformPostfix, path.attr("style"));
            Assert.areEqual("non-scaling-stroke", path.attr("vector-effect"));
            testColorFillingHandler = null;
        }, 300);
        Lib.__getStage().addEventListener(Event.STAGE_RENDERED, testColorFillingHandler);
    }

    @AsyncTest
    public function testColorFilling2(asyncFactory: AsyncFactory) {
        g.lineStyle(7, 0xAA0110, 0.11, true, LineScaleMode.NONE, CapsStyle.SQUARE, JointStyle.BEVEL, 4);
        g.beginFill(0xFF2070, 1);
        g.moveTo(50, 200);
        g.lineTo(200, 200);
        g.lineTo(190, 30);
        g.lineTo(150, 60);
        g.lineTo(140, 50);
        g.endFill();
        testColorFillingHandler = asyncFactory.createHandler(this, function() {
            var path = g.__snap.select("path");
            Assert.isNotNull(path);
            Assert.areEqual("M50 200 L200 200 L190 30 L150 60 L140 50 L50 200 Z", path.attr("d"));
            var strokeParts = cast(path.attr("stroke"), String).split(",");
            Assert.areEqual("rgba(170", strokeParts[0]);
            Assert.areEqual(" 1", strokeParts[1]);
            Assert.areEqual(" 16", strokeParts[2]);
            var alpha = Std.parseFloat(strokeParts[3].substr(0, strokeParts[3].length-1));
            Assert.isTrue(Math.abs(0.11-alpha) < 0.01);

            //if alpha = 1, rgb scheme used
            var strokeParts = cast(path.attr("fill"), String).split(",");
            Assert.areEqual("rgb(255", strokeParts[0]);
            Assert.areEqual(" 32", strokeParts[1]);
            Assert.areEqual(" 112)", strokeParts[2]);

            Assert.areEqual("stroke-width: 7" + strokeWidthPostfix + "; stroke-linecap: square; stroke-linejoin: bevel; stroke-miterlimit: 4;" + transformPostfix, path.attr("style"));
            Assert.areEqual("non-scaling-stroke", path.attr("vector-effect"));
            testColorFillingHandler = null;
        }, 300);
        Lib.__getStage().addEventListener(Event.STAGE_RENDERED, testColorFillingHandler);
    }

    private var testDrawEllipseHandler: Dynamic;

    @AsyncTest
    public function testDrawEllipse(asyncFactory: AsyncFactory) {
        g.lineStyle(8, 0xAA0110, 1, true, LineScaleMode.NONE, CapsStyle.SQUARE, JointStyle.BEVEL, 4);
        g.beginFill(0xFF2070, 0.4);
        g.drawEllipse(100, 200, 200, 40);
        testDrawEllipseHandler = asyncFactory.createHandler(this, function() {
            var ellipse = g.__snap.select("ellipse");
            Assert.isNotNull(ellipse);
            Assert.areEqual("200", ellipse.attr("cx"));
            Assert.areEqual("220", ellipse.attr("cy"));
            Assert.areEqual("100", ellipse.attr("rx"));
            Assert.areEqual("20", ellipse.attr("ry"));

            var strokeParts = cast(ellipse.attr("stroke"), String).split(",");
            //if alpha = 1, rgb scheme used
            Assert.areEqual("rgb(170", strokeParts[0]);
            Assert.areEqual(" 1", strokeParts[1]);
            Assert.areEqual(" 16)", strokeParts[2]);

            var fillParts = cast(ellipse.attr("fill"), String).split(",");
            Assert.areEqual("rgba(255", fillParts[0]);
            Assert.areEqual(" 32", fillParts[1]);
            Assert.areEqual(" 112", fillParts[2]);
            var alpha = Std.parseFloat(fillParts[3].substr(0, fillParts[3].length-1));
            Assert.isTrue(Math.abs(0.4-alpha) < 0.01);

            Assert.areEqual("stroke-width: 8" + strokeWidthPostfix + "; stroke-linecap: square; stroke-linejoin: bevel; stroke-miterlimit: 4;" + transformPostfix, ellipse.attr("style"));
            Assert.areEqual("non-scaling-stroke", ellipse.attr("vector-effect"));
            testDrawEllipseHandler = null;
        }, 300);
        Lib.__getStage().addEventListener(Event.STAGE_RENDERED, testDrawEllipseHandler);
    }
}