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

            Assert.isTrue(tools.Color.areColorsEqual('rgba(18,52,86,0.4)', path.attr('stroke')));
            Assert.isTrue(tools.Color.areColorsEqual('rgba(101,67,33,0.4)', path.attr('fill')));

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

            Assert.isTrue(tools.Color.areColorsEqual('rgba(18,52,86,0.4)', path.attr('stroke')));
            Assert.isTrue(tools.Color.areColorsEqual('rgba(101,67,33,0.4)', path.attr('fill')));

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

            Assert.isTrue(tools.Color.areColorsEqual('rgba(0,0,255,0.7)', path.attr('stroke')));
            Assert.isTrue(tools.Color.areColorsEqual('transparent', path.attr('fill')));

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

            Assert.isTrue(tools.Color.areColorsEqual('rgb(255,238,170,0.3)', path.attr('stroke')));
            Assert.isTrue(tools.Color.areColorsEqual('rgb(100,42, 21, 0.85)', path.attr('fill')));

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

            Assert.isTrue(tools.Color.areColorsEqual('#aabbcc', path.attr("stroke")));
            Assert.isTrue(tools.Color.areColorsEqual('rgba(255,238,221,0.9)', path.attr("fill")));

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

            Assert.isTrue(tools.Color.areColorsEqual('rgba(170,1,16,0.11)', path.attr("stroke")));
            Assert.isTrue(tools.Color.areColorsEqual('#ff2070', path.attr("fill")));

            Assert.areEqual("stroke-width: 7" + strokeWidthPostfix + "; stroke-linecap: square; stroke-linejoin: bevel; stroke-miterlimit: 4;" + transformPostfix, path.attr("style"));
            Assert.areEqual("non-scaling-stroke", path.attr("vector-effect"));
            testColorFillingHandler = null;
        }, 300);
        Lib.__getStage().addEventListener(Event.STAGE_RENDERED, testColorFillingHandler);
    }

    private var testDrawEllipseHandler: Dynamic;

    @AsyncTest
    public function testDrawEllipse1(asyncFactory: AsyncFactory) {
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

            Assert.isTrue(tools.Color.areColorsEqual('#aa0110', ellipse.attr("stroke")));
            Assert.isTrue(tools.Color.areColorsEqual('rgba(255,32,112,0.4)', ellipse.attr("fill")));

            Assert.areEqual("stroke-width: 8" + strokeWidthPostfix + "; stroke-linecap: square; stroke-linejoin: bevel; stroke-miterlimit: 4;" + transformPostfix, ellipse.attr("style"));
            Assert.areEqual("non-scaling-stroke", ellipse.attr("vector-effect"));
            testDrawEllipseHandler = null;
        }, 300);
        Lib.__getStage().addEventListener(Event.STAGE_RENDERED, testDrawEllipseHandler);
    }

    @AsyncTest
    public function testDrawEllipse2(asyncFactory: AsyncFactory) {
        g.lineStyle(0);
        g.beginFill(0xFF2070, 0.4);
        g.drawEllipse(300, 200, 200, 40);
        testDrawEllipseHandler = asyncFactory.createHandler(this, function() {
            var ellipse = g.__snap.select("ellipse");
            Assert.isNotNull(ellipse);
            Assert.areEqual("400", ellipse.attr("cx"));
            Assert.areEqual("220", ellipse.attr("cy"));
            Assert.areEqual("100", ellipse.attr("rx"));
            Assert.areEqual("20", ellipse.attr("ry"));

            Assert.areEqual('none', ellipse.attr("stroke"));
            Assert.areEqual("", ellipse.attr("style"));

            Assert.isTrue(tools.Color.areColorsEqual('rgba(255,32,112,0.4)', ellipse.attr("fill")));
            testDrawEllipseHandler = null;
        }, 300);
        Lib.__getStage().addEventListener(Event.STAGE_RENDERED, testDrawEllipseHandler);
    }

    private var testDrawCircleHandler: Dynamic;

    @AsyncTest
    public function testDrawCircle1(asyncFactory: AsyncFactory) {
        g.lineStyle(8, 0xAA0110, 1, true, LineScaleMode.NONE, CapsStyle.SQUARE, JointStyle.BEVEL, 4);
        g.beginFill(0xFF2070, 0.4);
        g.drawCircle(15, 17, 42.7);
        testDrawCircleHandler = asyncFactory.createHandler(this, function() {
            var circle = g.__snap.select("circle");
            Assert.isNotNull(circle);
            Assert.areEqual("15", circle.attr("cx"));
            Assert.areEqual("17", circle.attr("cy"));
            var rad = Std.parseFloat(circle.attr("r"));
            Assert.isTrue(Math.abs(42.7-rad) < 0.01);

            Assert.isTrue(tools.Color.areColorsEqual('#aa0110', circle.attr("stroke")));
            Assert.isTrue(tools.Color.areColorsEqual('rgba(255,32,112,0.4)', circle.attr("fill")));

            Assert.areEqual("stroke-width: 8" + strokeWidthPostfix + "; stroke-linecap: square; stroke-linejoin: bevel; stroke-miterlimit: 4;" + transformPostfix, circle.attr("style"));
            Assert.areEqual("non-scaling-stroke", circle.attr("vector-effect"));
            testDrawCircleHandler = null;
        }, 300);
        Lib.__getStage().addEventListener(Event.STAGE_RENDERED, testDrawCircleHandler);
    }

    @AsyncTest
    public function testDrawCircle2(asyncFactory: AsyncFactory) {
        g.lineStyle(4, 0x1001AA, 1, true, LineScaleMode.NONE, CapsStyle.SQUARE, JointStyle.BEVEL, 4);
        g.beginFill(0x7020FF, 0.6);
        g.drawCircle(15.23, 17.78, 42.7);
        testDrawCircleHandler = asyncFactory.createHandler(this, function() {
            var circle = g.__snap.select("circle");
            Assert.isNotNull(circle);
            var cx = Std.parseFloat(circle.attr("cx"));
            Assert.isTrue(Math.abs(15.23 - cx) < 0.01);
            var cy = Std.parseFloat(circle.attr("cy"));
            Assert.isTrue(Math.abs(17.78 - cy) < 0.01);
            Assert.areEqual("42.7", circle.attr("r"));


            Assert.isTrue(tools.Color.areColorsEqual('#1001aa', circle.attr("stroke")));
            Assert.isTrue(tools.Color.areColorsEqual('rgba(112,32,255,0.6)', circle.attr("fill")));

            Assert.areEqual("stroke-width: 4" + strokeWidthPostfix + "; stroke-linecap: square; stroke-linejoin: bevel; stroke-miterlimit: 4;" + transformPostfix, circle.attr("style"));
            Assert.areEqual("non-scaling-stroke", circle.attr("vector-effect"));
            testDrawCircleHandler = null;
        }, 300);
        Lib.__getStage().addEventListener(Event.STAGE_RENDERED, testDrawCircleHandler);
    }

    private var testDrawRectHandler: Dynamic;

    @AsyncTest
    public function testDrawRect1(asyncFactory: AsyncFactory) {
        g.lineStyle(4, 0x1001AA, 1, true, LineScaleMode.NONE, CapsStyle.SQUARE, JointStyle.BEVEL, 4);
        g.beginFill(0x7020FF, 0.6);
        g.drawRect(10, 15, 70, 42);
        testDrawRectHandler = asyncFactory.createHandler(this, function() {
            var rect = g.__snap.select("rect");
            Assert.isNotNull(rect);
            Assert.areEqual("10", rect.attr("x"));
            Assert.areEqual("15", rect.attr("y"));
            Assert.areEqual("70", rect.attr("width"));
            Assert.areEqual("42", rect.attr("height"));
            Assert.areEqual("0", rect.attr("rx"));
            Assert.areEqual("0", rect.attr("ry"));


            Assert.isTrue(tools.Color.areColorsEqual('#1001aa', rect.attr("stroke")));
            Assert.isTrue(tools.Color.areColorsEqual('rgba(112,32,255,0.6)', rect.attr("fill")));

            Assert.areEqual("stroke-width: 4" + strokeWidthPostfix + "; stroke-linecap: square; stroke-linejoin: bevel; stroke-miterlimit: 4;" + transformPostfix, rect.attr("style"));
            Assert.areEqual("non-scaling-stroke", rect.attr("vector-effect"));
            testDrawRectHandler = null;
        }, 300);
        Lib.__getStage().addEventListener(Event.STAGE_RENDERED, testDrawRectHandler);
    }

    @AsyncTest
    public function testDrawRect2(asyncFactory: AsyncFactory) {
        g.lineStyle(8, 0xAA0110, 1, true, LineScaleMode.NONE, CapsStyle.SQUARE, JointStyle.BEVEL, 4);
        g.beginFill(0xFF2070, 0.4);
        g.drawRect(20.9, 3.22, 37.6, 88.3);
        testDrawRectHandler = asyncFactory.createHandler(this, function() {
            var rect = g.__snap.select("rect");
            Assert.isNotNull(rect);
            var val = Std.parseFloat(rect.attr("x"));
            Assert.isTrue(Math.abs(20.9-val) < 0.01);
            var val = Std.parseFloat(rect.attr("y"));
            Assert.isTrue(Math.abs(3.22-val) < 0.01);
            var val = Std.parseFloat(rect.attr("width"));
            Assert.isTrue(Math.abs(37.6-val) < 0.01);
            var val = Std.parseFloat(rect.attr("height"));
            Assert.isTrue(Math.abs(88.3-val) < 0.01);
            Assert.areEqual("0", rect.attr("rx"));
            Assert.areEqual("0", rect.attr("ry"));


            Assert.isTrue(tools.Color.areColorsEqual('#aa0110', rect.attr("stroke")));
            Assert.isTrue(tools.Color.areColorsEqual('rgba(255,32,112,0.4)', rect.attr("fill")));

            Assert.areEqual("stroke-width: 8" + strokeWidthPostfix + "; stroke-linecap: square; stroke-linejoin: bevel; stroke-miterlimit: 4;" + transformPostfix, rect.attr("style"));
            Assert.areEqual("non-scaling-stroke", rect.attr("vector-effect"));
            testDrawRectHandler = null;
        }, 300);
        Lib.__getStage().addEventListener(Event.STAGE_RENDERED, testDrawRectHandler);
    }

    private var testDrawRoundRectHandler: Dynamic;

    @AsyncTest
    public function testDrawRoundRect1(asyncFactory: AsyncFactory) {
        g.lineStyle(4, 0x1001AA, 1, true, LineScaleMode.NONE, CapsStyle.SQUARE, JointStyle.BEVEL, 4);
        g.beginFill(0x7020FF, 0.6);
        g.drawRoundRect(10, 15, 70, 42, 7);
        testDrawRoundRectHandler = asyncFactory.createHandler(this, function() {
            var rect = g.__snap.select("rect");
            Assert.isNotNull(rect);
            Assert.areEqual("10", rect.attr("x"));
            Assert.areEqual("15", rect.attr("y"));
            Assert.areEqual("70", rect.attr("width"));
            Assert.areEqual("42", rect.attr("height"));
            Assert.areEqual("7", rect.attr("rx"));
            Assert.areEqual("7", rect.attr("ry"));


            Assert.isTrue(tools.Color.areColorsEqual('#1001aa', rect.attr("stroke")));
            Assert.isTrue(tools.Color.areColorsEqual('rgba(112,32,255,0.6)', rect.attr("fill")));

            Assert.areEqual("stroke-width: 4" + strokeWidthPostfix + "; stroke-linecap: square; stroke-linejoin: bevel; stroke-miterlimit: 4;" + transformPostfix, rect.attr("style"));
            Assert.areEqual("non-scaling-stroke", rect.attr("vector-effect"));
            testDrawRoundRectHandler = null;
        }, 300);
        Lib.__getStage().addEventListener(Event.STAGE_RENDERED, testDrawRoundRectHandler);
    }

    @AsyncTest
    public function testDrawRoundRect2(asyncFactory: AsyncFactory) {
        g.lineStyle(8, 0xAA0110, 1, true, LineScaleMode.NONE, CapsStyle.SQUARE, JointStyle.BEVEL, 4);
        g.beginFill(0xFF2070, 0.4);
        g.drawRoundRect(20.9, 3.22, 37.6, 7.3, 2.5);
        testDrawRoundRectHandler = asyncFactory.createHandler(this, function() {
            var rect = g.__snap.select("rect");
            Assert.isNotNull(rect);
            var val = Std.parseFloat(rect.attr("x"));
            Assert.isTrue(Math.abs(20.9-val) < 0.01);
            var val = Std.parseFloat(rect.attr("y"));
            Assert.isTrue(Math.abs(3.22-val) < 0.01);
            var val = Std.parseFloat(rect.attr("width"));
            Assert.isTrue(Math.abs(37.6-val) < 0.01);
            var val = Std.parseFloat(rect.attr("height"));
            Assert.isTrue(Math.abs(7.3-val) < 0.01);
            var val = Std.parseFloat(rect.attr("rx"));
            Assert.isTrue(Math.abs(2.5-val) < 0.01);
            var val = Std.parseFloat(rect.attr("ry"));
            Assert.isTrue(Math.abs(2.5-val) < 0.01);


            Assert.isTrue(tools.Color.areColorsEqual('#aa0110', rect.attr("stroke")));
            Assert.isTrue(tools.Color.areColorsEqual('rgba(255,32,112,0.4)', rect.attr("fill")));

            Assert.areEqual("stroke-width: 8" + strokeWidthPostfix + "; stroke-linecap: square; stroke-linejoin: bevel; stroke-miterlimit: 4;" + transformPostfix, rect.attr("style"));
            Assert.areEqual("non-scaling-stroke", rect.attr("vector-effect"));
            testDrawRoundRectHandler = null;
        }, 300);
        Lib.__getStage().addEventListener(Event.STAGE_RENDERED, testDrawRoundRectHandler);
    }
}