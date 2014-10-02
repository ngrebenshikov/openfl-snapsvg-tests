package openfl.display;

import snap.Snap;
import tools.Helper;
import tools.Color;
import openfl.geom.Matrix;
import massive.munit.Assert;
import massive.munit.async.AsyncFactory;
import openfl.events.Event;

class GraphicsTest {
    private var g: Graphics;
    private var sprite: Sprite;
    private var strokeWidthPostfix: String;
    private var transparentValue: String;
    private var transformPostfix: String;

    private var asyncHandler: Dynamic;

    @BeforeClass
    public function beforeClass():Void {
    }

    @AfterClass
    public function afterClass():Void {}

    @Before
    public function setup():Void {
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

        asyncHandler = asyncFactory.createHandler(this, function() {
            Lib.__getStage().removeEventListener(Event.STAGE_RENDERED, asyncHandler);
            var path = g.__snap.select("path");
            Assert.isNotNull(path);
            Assert.areEqual("M100 100 L200 200 Z", path.attr("d"));

            Assert.isTrue(tools.Color.areColorsEqual('rgba(18,52,86,0.4)', path.attr('stroke')));
            Assert.isTrue(tools.Color.areColorsEqual('rgba(101,67,33,0.4)', path.attr('fill')));

            Assert.areEqual("stroke-width: 10" + strokeWidthPostfix + "; stroke-linecap: round; stroke-linejoin: bevel; stroke-miterlimit: 5; fill-rule: evenodd;" + transformPostfix, path.attr("style"));
            Assert.areEqual("none", path.attr("vector-effect"));
        }, 300);
        Lib.__getStage().addEventListener(Event.STAGE_RENDERED, asyncHandler);
    }

    @AsyncTest
    public function testLineTo2(asyncFactory: AsyncFactory) {
        g.lineStyle(10, 0x123456, 0.4, true, LineScaleMode.NONE, CapsStyle.SQUARE, JointStyle.ROUND, 5);
        g.beginFill(0x654321, 0.4);
        g.moveTo(23, 567);
        g.lineTo(987, 456);

        asyncHandler = asyncFactory.createHandler(this, function() {
            Lib.__getStage().removeEventListener(Event.STAGE_RENDERED, asyncHandler);
            var path = g.__snap.select("path");
            Assert.isNotNull(path);
            Assert.areEqual("M23 567 L987 456 Z", path.attr("d"));

            Assert.isTrue(tools.Color.areColorsEqual('rgba(18,52,86,0.4)', path.attr('stroke')));
            Assert.isTrue(tools.Color.areColorsEqual('rgba(101,67,33,0.4)', path.attr('fill')));

            Assert.areEqual("stroke-width: 10" + strokeWidthPostfix + "; stroke-linecap: square; stroke-linejoin: round; stroke-miterlimit: 5; fill-rule: evenodd;" + transformPostfix, path.attr("style"));
            Assert.areEqual("non-scaling-stroke", path.attr("vector-effect"));
        }, 300);
        Lib.__getStage().addEventListener(Event.STAGE_RENDERED, asyncHandler);
    }

    @AsyncTest
    public function testCurveTo1(asyncFactory: AsyncFactory) {
        g.lineStyle(5, 0x0000FF, 0.7, true, LineScaleMode.NONE, CapsStyle.ROUND, JointStyle.ROUND, 7);
        g.moveTo(250, 200);
        g.curveTo(300, 0, 350, 200);
        asyncHandler = asyncFactory.createHandler(this, function() {
            Lib.__getStage().removeEventListener(Event.STAGE_RENDERED, asyncHandler);
            var path = g.__snap.select("path");
            Assert.isNotNull(path);
            Assert.areEqual("M250 200 Q300 0 350 200 Z", path.attr("d"));

            Assert.isTrue(tools.Color.areColorsEqual('rgba(0,0,255,0.7)', path.attr('stroke')));
            Assert.isTrue(tools.Color.areColorsEqual('transparent', path.attr('fill')));

            Assert.areEqual("stroke-width: 5" + strokeWidthPostfix + "; stroke-linecap: round; stroke-linejoin: round; stroke-miterlimit: 7; fill-rule: evenodd;" + transformPostfix, path.attr("style"));
            Assert.areEqual("non-scaling-stroke", path.attr("vector-effect"));
        }, 300);
        Lib.__getStage().addEventListener(Event.STAGE_RENDERED, asyncHandler);
    }

    @AsyncTest
    public function testCurveTo2(asyncFactory: AsyncFactory) {
        g.lineStyle(30, 0xFFEEAA, 0.3, true, LineScaleMode.NONE, CapsStyle.SQUARE, JointStyle.BEVEL, 4);
        g.beginFill(0x642A15, 0.85);
        g.moveTo(200, 250);
        g.curveTo(400, 450 , 500, 200);
        asyncHandler = asyncFactory.createHandler(this, function() {
            Lib.__getStage().removeEventListener(Event.STAGE_RENDERED, asyncHandler);
            var path = g.__snap.select("path");
            Assert.isNotNull(path);
            Assert.areEqual("M200 250 Q400 450 500 200 Z", path.attr("d"));

            Assert.isTrue(tools.Color.areColorsEqual('rgb(255,238,170,0.3)', path.attr('stroke')));
            Assert.isTrue(tools.Color.areColorsEqual('rgb(100,42, 21, 0.85)', path.attr('fill')));

            Assert.areEqual("stroke-width: 30" + strokeWidthPostfix + "; stroke-linecap: square; stroke-linejoin: bevel; stroke-miterlimit: 4; fill-rule: evenodd;" + transformPostfix, path.attr("style"));
            Assert.areEqual("non-scaling-stroke", path.attr("vector-effect"));
        }, 300);
        Lib.__getStage().addEventListener(Event.STAGE_RENDERED, asyncHandler);
    }

    @AsyncTest
    public function testColorFilling1(asyncFactory: AsyncFactory) {
        g.lineStyle(7, 0xAABBCC, 1, true, LineScaleMode.NONE, CapsStyle.SQUARE, JointStyle.BEVEL, 4);
        g.beginFill(0xFFEEDD, 0.9);
        g.moveTo(300, 30);
        g.lineTo(400, 30);
        g.lineTo(300, 100);
        g.lineTo(400, 100);
        g.endFill();
        asyncHandler = asyncFactory.createHandler(this, function() {
            Lib.__getStage().removeEventListener(Event.STAGE_RENDERED, asyncHandler);
            var path = g.__snap.select("path");
            Assert.isNotNull(path);
            Assert.areEqual("M300 30 L400 30 L300 100 L400 100 L300 30 Z", path.attr("d"));

            Assert.isTrue(tools.Color.areColorsEqual('#aabbcc', path.attr("stroke")));
            Assert.isTrue(tools.Color.areColorsEqual('rgba(255,238,221,0.9)', path.attr("fill")));

            Assert.areEqual("stroke-width: 7" + strokeWidthPostfix + "; stroke-linecap: square; stroke-linejoin: bevel; stroke-miterlimit: 4; fill-rule: evenodd;" + transformPostfix, path.attr("style"));
            Assert.areEqual("non-scaling-stroke", path.attr("vector-effect"));
        }, 300);
        Lib.__getStage().addEventListener(Event.STAGE_RENDERED, asyncHandler);
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
        asyncHandler = asyncFactory.createHandler(this, function() {
            Lib.__getStage().removeEventListener(Event.STAGE_RENDERED, asyncHandler);
            var path = g.__snap.select("path");
            Assert.isNotNull(path);
            Assert.areEqual("M50 200 L200 200 L190 30 L150 60 L140 50 L50 200 Z", path.attr("d"));

            Assert.isTrue(tools.Color.areColorsEqual('rgba(170,1,16,0.11)', path.attr("stroke")));
            Assert.isTrue(tools.Color.areColorsEqual('#ff2070', path.attr("fill")));

            Assert.areEqual("stroke-width: 7" + strokeWidthPostfix + "; stroke-linecap: square; stroke-linejoin: bevel; stroke-miterlimit: 4; fill-rule: evenodd;" + transformPostfix, path.attr("style"));
            Assert.areEqual("non-scaling-stroke", path.attr("vector-effect"));
        }, 300);
        Lib.__getStage().addEventListener(Event.STAGE_RENDERED, asyncHandler);
    }

    @AsyncTest
    public function testDrawEllipse1(asyncFactory: AsyncFactory) {
        g.lineStyle(8, 0xAA0110, 1, true, LineScaleMode.NONE, CapsStyle.SQUARE, JointStyle.BEVEL, 4);
        g.beginFill(0xFF2070, 0.4);
        g.drawEllipse(100, 200, 200, 40);
        asyncHandler = asyncFactory.createHandler(this, function() {
            Lib.__getStage().removeEventListener(Event.STAGE_RENDERED, asyncHandler);
            var ellipse = g.__snap.select("ellipse");
            Assert.isNotNull(ellipse);
            Assert.areEqual("200", ellipse.attr("cx"));
            Assert.areEqual("220", ellipse.attr("cy"));
            Assert.areEqual("100", ellipse.attr("rx"));
            Assert.areEqual("20", ellipse.attr("ry"));

            Assert.isTrue(tools.Color.areColorsEqual('#aa0110', ellipse.attr("stroke")));
            Assert.isTrue(tools.Color.areColorsEqual('rgba(255,32,112,0.4)', ellipse.attr("fill")));

            Assert.areEqual("stroke-width: 8" + strokeWidthPostfix + "; stroke-linecap: square; stroke-linejoin: bevel; stroke-miterlimit: 4; fill-rule: evenodd;" + transformPostfix, ellipse.attr("style"));
            Assert.areEqual("non-scaling-stroke", ellipse.attr("vector-effect"));
        }, 300);
        Lib.__getStage().addEventListener(Event.STAGE_RENDERED, asyncHandler);
    }

    @AsyncTest
    public function testDrawEllipse2(asyncFactory: AsyncFactory) {
        g.lineStyle(0);
        g.beginFill(0xFF2070, 0.4);
        g.drawEllipse(300, 200, 200, 40);
        asyncHandler = asyncFactory.createHandler(this, function() {
            Lib.__getStage().removeEventListener(Event.STAGE_RENDERED, asyncHandler);
            var ellipse = g.__snap.select("ellipse");
            Assert.isNotNull(ellipse);
            Assert.areEqual("400", ellipse.attr("cx"));
            Assert.areEqual("220", ellipse.attr("cy"));
            Assert.areEqual("100", ellipse.attr("rx"));
            Assert.areEqual("20", ellipse.attr("ry"));

            Assert.areEqual('none', ellipse.attr("stroke"));
            Assert.areEqual("fill-rule: evenodd;"+transformPostfix, ellipse.attr("style"));

            Assert.isTrue(tools.Color.areColorsEqual('rgba(255,32,112,0.4)', ellipse.attr("fill")));
        }, 300);
        Lib.__getStage().addEventListener(Event.STAGE_RENDERED, asyncHandler);
    }

    @AsyncTest
    public function testDrawCircle1(asyncFactory: AsyncFactory) {
        g.lineStyle(8, 0xAA0110, 1, true, LineScaleMode.NONE, CapsStyle.SQUARE, JointStyle.BEVEL, 4);
        g.beginFill(0xFF2070, 0.4);
        g.drawCircle(15, 17, 42.7);
        asyncHandler = asyncFactory.createHandler(this, function() {
            Lib.__getStage().removeEventListener(Event.STAGE_RENDERED, asyncHandler);
            var circle = g.__snap.select("circle");
            Assert.isNotNull(circle);
            Assert.areEqual("15", circle.attr("cx"));
            Assert.areEqual("17", circle.attr("cy"));
            var rad = Std.parseFloat(circle.attr("r"));
            Assert.isTrue(Math.abs(42.7-rad) < 0.01);

            Assert.isTrue(tools.Color.areColorsEqual('#aa0110', circle.attr("stroke")));
            Assert.isTrue(tools.Color.areColorsEqual('rgba(255,32,112,0.4)', circle.attr("fill")));

            Assert.areEqual("stroke-width: 8" + strokeWidthPostfix + "; stroke-linecap: square; stroke-linejoin: bevel; stroke-miterlimit: 4; fill-rule: evenodd;" + transformPostfix, circle.attr("style"));
            Assert.areEqual("non-scaling-stroke", circle.attr("vector-effect"));
        }, 300);
        Lib.__getStage().addEventListener(Event.STAGE_RENDERED, asyncHandler);
    }

    @AsyncTest
    public function testDrawCircle2(asyncFactory: AsyncFactory) {
        g.lineStyle(4, 0x1001AA, 1, true, LineScaleMode.NONE, CapsStyle.SQUARE, JointStyle.BEVEL, 4);
        g.beginFill(0x7020FF, 0.6);
        g.drawCircle(15.23, 17.78, 42.7);
        asyncHandler = asyncFactory.createHandler(this, function() {
            Lib.__getStage().removeEventListener(Event.STAGE_RENDERED, asyncHandler);
            var circle = g.__snap.select("circle");
            Assert.isNotNull(circle);
            var cx = Std.parseFloat(circle.attr("cx"));
            Assert.isTrue(Math.abs(15.23 - cx) < 0.01);
            var cy = Std.parseFloat(circle.attr("cy"));
            Assert.isTrue(Math.abs(17.78 - cy) < 0.01);
            Assert.areEqual("42.7", circle.attr("r"));


            Assert.isTrue(tools.Color.areColorsEqual('#1001aa', circle.attr("stroke")));
            Assert.isTrue(tools.Color.areColorsEqual('rgba(112,32,255,0.6)', circle.attr("fill")));

            Assert.areEqual("stroke-width: 4" + strokeWidthPostfix + "; stroke-linecap: square; stroke-linejoin: bevel; stroke-miterlimit: 4; fill-rule: evenodd;" + transformPostfix, circle.attr("style"));
            Assert.areEqual("non-scaling-stroke", circle.attr("vector-effect"));
        }, 300);
        Lib.__getStage().addEventListener(Event.STAGE_RENDERED, asyncHandler);
    }

    @AsyncTest
    public function testDrawRect1(asyncFactory: AsyncFactory) {
        g.lineStyle(4, 0x1001AA, 1, true, LineScaleMode.NONE, CapsStyle.SQUARE, JointStyle.BEVEL, 4);
        g.beginFill(0x7020FF, 0.6);
        g.drawRect(10, 15, 70, 42);
        asyncHandler = asyncFactory.createHandler(this, function() {
            Lib.__getStage().removeEventListener(Event.STAGE_RENDERED, asyncHandler);
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

            Assert.areEqual("stroke-width: 4" + strokeWidthPostfix + "; stroke-linecap: square; stroke-linejoin: bevel; stroke-miterlimit: 4; fill-rule: evenodd;" + transformPostfix, rect.attr("style"));
            Assert.areEqual("non-scaling-stroke", rect.attr("vector-effect"));
        }, 300);
        Lib.__getStage().addEventListener(Event.STAGE_RENDERED, asyncHandler);
    }

    @AsyncTest
    public function testDrawRect2(asyncFactory: AsyncFactory) {
        g.lineStyle(8, 0xAA0110, 1, true, LineScaleMode.NONE, CapsStyle.SQUARE, JointStyle.BEVEL, 4);
        g.beginFill(0xFF2070, 0.4);
        g.drawRect(20.9, 3.22, 37.6, 88.3);
        asyncHandler = asyncFactory.createHandler(this, function() {
            Lib.__getStage().removeEventListener(Event.STAGE_RENDERED, asyncHandler);
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

            Assert.areEqual("stroke-width: 8" + strokeWidthPostfix + "; stroke-linecap: square; stroke-linejoin: bevel; stroke-miterlimit: 4; fill-rule: evenodd;" + transformPostfix, rect.attr("style"));
            Assert.areEqual("non-scaling-stroke", rect.attr("vector-effect"));
        }, 300);
        Lib.__getStage().addEventListener(Event.STAGE_RENDERED, asyncHandler);
    }

    @AsyncTest
    public function testDrawRoundRect1(asyncFactory: AsyncFactory) {
        g.lineStyle(4, 0x1001AA, 1, true, LineScaleMode.NONE, CapsStyle.SQUARE, JointStyle.BEVEL, 4);
        g.beginFill(0x7020FF, 0.6);
        g.drawRoundRect(10, 15, 70, 42, 7);
        asyncHandler = asyncFactory.createHandler(this, function() {
            Lib.__getStage().removeEventListener(Event.STAGE_RENDERED, asyncHandler);
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

            Assert.areEqual("stroke-width: 4" + strokeWidthPostfix + "; stroke-linecap: square; stroke-linejoin: bevel; stroke-miterlimit: 4; fill-rule: evenodd;" + transformPostfix, rect.attr("style"));
            Assert.areEqual("non-scaling-stroke", rect.attr("vector-effect"));
        }, 300);
        Lib.__getStage().addEventListener(Event.STAGE_RENDERED, asyncHandler);
    }

    @AsyncTest
    public function testDrawRoundRect2(asyncFactory: AsyncFactory) {
        g.lineStyle(8, 0xAA0110, 1, true, LineScaleMode.NONE, CapsStyle.SQUARE, JointStyle.BEVEL, 4);
        g.beginFill(0xFF2070, 0.4);
        g.drawRoundRect(20.9, 3.22, 37.6, 7.3, 2.5);
        asyncHandler = asyncFactory.createHandler(this, function() {
            Lib.__getStage().removeEventListener(Event.STAGE_RENDERED, asyncHandler);
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

            Assert.areEqual("stroke-width: 8" + strokeWidthPostfix + "; stroke-linecap: square; stroke-linejoin: bevel; stroke-miterlimit: 4; fill-rule: evenodd;" + transformPostfix, rect.attr("style"));
            Assert.areEqual("non-scaling-stroke", rect.attr("vector-effect"));
        }, 300);
        Lib.__getStage().addEventListener(Event.STAGE_RENDERED, asyncHandler);
    }

    @AsyncTest
    public function testLinearGradientFilling1(asyncFactory: AsyncFactory) {
        g.lineStyle(4, 0x1001AA, 1, true, LineScaleMode.NONE, CapsStyle.SQUARE, JointStyle.BEVEL, 4);

        var matrix:Matrix = new Matrix();
        matrix.createGradientBox(70, 42, Math.PI/2, 10, 15);
        g.beginGradientFill(
            GradientType.LINEAR,
            [0xff0000,0x00ff00,0x0000ff],
            [1.0, 0.3, 0.7],
            [0, 128, 255],
            matrix,
            SpreadMethod.PAD,
            InterpolationMethod.LINEAR_RGB,
            0);
        g.drawRoundRect(10, 15, 70, 42, 7);

        asyncHandler = asyncFactory.createHandler(this, function() {
            Lib.__getStage().removeEventListener(Event.STAGE_RENDERED, asyncHandler);
            var rect = g.__snap.select("rect");
            Assert.isNotNull(rect);

            Assert.isNotNull(rect.attr('fill'));

            var gradientId = Helper.getAnchorIdFromUrl(rect.attr('fill'));
            Assert.isNotNull(gradientId);

            var gradient = Snap.select('#' + gradientId);
            Assert.isNotNull(gradient);

            Assert.areEqual('linearGradient', gradient.type);

            Assert.areEqual('-819.2', gradient.attr('x1'));
            Assert.areEqual('819.2', gradient.attr('x2'));
            Assert.areEqual('0', gradient.attr('y1'));
            Assert.areEqual('0', gradient.attr('y2'));
            Assert.areEqual('pad', gradient.attr('spreadMethod'));

            // Check matrix
            var matrixString: String = gradient.attr('gradientTransform');
            Assert.isNotNull(matrixString);
            var coefficients = cast StringTools.replace(StringTools.replace(matrixString, 'matrix(', ''), ')', '').split(',');
            Assert.isTrue(Math.abs(matrix.a - Std.parseFloat(coefficients[0])) < 0.01);
            Assert.isTrue(Math.abs(matrix.b - Std.parseFloat(coefficients[1])) < 0.01);
            Assert.isTrue(Math.abs(matrix.c - Std.parseFloat(coefficients[2])) < 0.01);
            Assert.isTrue(Math.abs(matrix.d - Std.parseFloat(coefficients[3])) < 0.01);
            Assert.isTrue(Math.abs(matrix.tx - Std.parseFloat(coefficients[4])) < 0.01);
            Assert.isTrue(Math.abs(matrix.ty - Std.parseFloat(coefficients[5])) < 0.01);

            // Check stops
            var stops = gradient.node.childNodes;

            Assert.areEqual('0%', stops.item(0).attributes.getNamedItem('offset').nodeValue);
            Assert.isTrue(tools.Color.areColorsEqual('#ff0000', stops.item(0).attributes.getNamedItem('stop-color').nodeValue));
            Assert.isNull(stops.item(0).attributes.getNamedItem('stop-opacity'));

            Assert.areEqual('50%', stops.item(1).attributes.getNamedItem('offset').nodeValue);
            Assert.isTrue(tools.Color.areColorsEqual('#00ff00', stops.item(1).attributes.getNamedItem('stop-color').nodeValue));
            Assert.isTrue(Math.abs(0.3 - Std.parseFloat(stops.item(1).attributes.getNamedItem('stop-opacity').nodeValue)) < 0.01);

            Assert.areEqual('100%', stops.item(2).attributes.getNamedItem('offset').nodeValue);
            Assert.isTrue(tools.Color.areColorsEqual('#0000ff', stops.item(2).attributes.getNamedItem('stop-color').nodeValue));
            Assert.isTrue(Math.abs(0.7 - Std.parseFloat(stops.item(2).attributes.getNamedItem('stop-opacity').nodeValue)) < 0.01);

        }, 300);
        Lib.__getStage().addEventListener(Event.STAGE_RENDERED, asyncHandler);
    }

    @AsyncTest
    public function testLinearGradientFilling2(asyncFactory: AsyncFactory) {
        g.lineStyle(2, 0x1001AA, 1, true, LineScaleMode.NONE, CapsStyle.SQUARE, JointStyle.BEVEL, 4);

        var matrix:Matrix = new Matrix();
        matrix.createGradientBox(50, 100, Math.PI/4, 100, 100);
        g.beginGradientFill(
            GradientType.LINEAR,
            [0xff0000,0x00ff00,0x0000ff, 0xffff00],
            [1.0, 0.5, 0, 1.0],
            [0, 75, 150, 255],
            matrix,
            SpreadMethod.REFLECT,
            InterpolationMethod.LINEAR_RGB,
            0);
        g.drawRoundRect(100, 100, 50, 100, 15);

        asyncHandler = asyncFactory.createHandler(this, function() {
            Lib.__getStage().removeEventListener(Event.STAGE_RENDERED, asyncHandler);
            var rect = g.__snap.select("rect");
            Assert.isNotNull(rect);

            Assert.isNotNull(rect.attr('fill'));

            var gradientId = Helper.getAnchorIdFromUrl(rect.attr('fill'));
            Assert.isNotNull(gradientId);

            var gradient = Snap.select('#' + gradientId);
            Assert.isNotNull(gradient);

            Assert.areEqual('linearGradient', gradient.type);

            Assert.areEqual('-819.2', gradient.attr('x1'));
            Assert.areEqual('819.2', gradient.attr('x2'));
            Assert.areEqual('0', gradient.attr('y1'));
            Assert.areEqual('0', gradient.attr('y2'));
            Assert.areEqual('reflect', gradient.attr('spreadMethod'));

            // Check matrix
            var matrixString: String = gradient.attr('gradientTransform');
            Assert.isNotNull(matrixString);
            var coefficients = cast StringTools.replace(StringTools.replace(matrixString, 'matrix(', ''), ')', '').split(',');
            Assert.isTrue(Math.abs(matrix.a - Std.parseFloat(coefficients[0])) < 0.01);
            Assert.isTrue(Math.abs(matrix.b - Std.parseFloat(coefficients[1])) < 0.01);
            Assert.isTrue(Math.abs(matrix.c - Std.parseFloat(coefficients[2])) < 0.01);
            Assert.isTrue(Math.abs(matrix.d - Std.parseFloat(coefficients[3])) < 0.01);
            Assert.isTrue(Math.abs(matrix.tx - Std.parseFloat(coefficients[4])) < 0.01);
            Assert.isTrue(Math.abs(matrix.ty - Std.parseFloat(coefficients[5])) < 0.01);

            // Check stops
            var stops = gradient.node.childNodes;

            Assert.areEqual('0%', stops.item(0).attributes.getNamedItem('offset').nodeValue);
            Assert.isTrue(tools.Color.areColorsEqual('#ff0000', stops.item(0).attributes.getNamedItem('stop-color').nodeValue));
            Assert.isNull(stops.item(0).attributes.getNamedItem('stop-opacity'));

            Assert.areEqual('29%', stops.item(1).attributes.getNamedItem('offset').nodeValue);
            Assert.isTrue(tools.Color.areColorsEqual('#00ff00', stops.item(1).attributes.getNamedItem('stop-color').nodeValue));
            Assert.isTrue(Math.abs(0.5 - Std.parseFloat(stops.item(1).attributes.getNamedItem('stop-opacity').nodeValue)) < 0.01);

            Assert.areEqual('58%', stops.item(2).attributes.getNamedItem('offset').nodeValue);
            Assert.isTrue(tools.Color.areColorsEqual('#0000ff', stops.item(2).attributes.getNamedItem('stop-color').nodeValue));
            Assert.isTrue(Math.abs(0 - Std.parseFloat(stops.item(2).attributes.getNamedItem('stop-opacity').nodeValue)) < 0.01);

            Assert.areEqual('100%', stops.item(3).attributes.getNamedItem('offset').nodeValue);
            Assert.isTrue(tools.Color.areColorsEqual('#ffff00', stops.item(3).attributes.getNamedItem('stop-color').nodeValue));
            Assert.isNull(stops.item(3).attributes.getNamedItem('stop-opacity'));
        }, 300);
        Lib.__getStage().addEventListener(Event.STAGE_RENDERED, asyncHandler);
    }

    @AsyncTest
    public function testRadialGradientFilling(asyncFactory: AsyncFactory) {
        g.lineStyle(2, 0x1001AA, 1, true, LineScaleMode.NONE, CapsStyle.SQUARE, JointStyle.BEVEL, 4);

        var matrix:Matrix = new Matrix();
        matrix.createGradientBox(50, 100, Math.PI, 200, 200);
        g.beginGradientFill(
            GradientType.RADIAL,
            [0xff0000,0x00ff00,0x0000ff, 0xffff00],
            [1.0, 0.5, 0, 1.0],
            [0, 75, 150, 255],
            matrix,
            SpreadMethod.PAD,
            InterpolationMethod.LINEAR_RGB,
            0.5);
        g.drawRoundRect(200, 200, 50, 100, 15);

        asyncHandler = asyncFactory.createHandler(this, function() {
            Lib.__getStage().removeEventListener(Event.STAGE_RENDERED, asyncHandler);
            var rect = g.__snap.select("rect");
            Assert.isNotNull(rect);

            Assert.isNotNull(rect.attr('fill'));

            var gradientId = Helper.getAnchorIdFromUrl(rect.attr('fill'));
            Assert.isNotNull(gradientId);

            var gradient = Snap.select('#' + gradientId);
            Assert.isNotNull(gradient);

            Assert.areEqual('radialGradient', gradient.type);

            Assert.areEqual('0', gradient.attr('cx'));
            Assert.areEqual('0', gradient.attr('cy'));
            Assert.areEqual('819.2', gradient.attr('r'));
            Assert.areEqual('409.6', gradient.attr('fx'));
            Assert.areEqual('0', gradient.attr('fy'));
            Assert.areEqual('pad', gradient.attr('spreadMethod'));

            // Check matrix
            var matrixString: String = gradient.attr('gradientTransform');
            Assert.isNotNull(matrixString);
            var coefficients = cast StringTools.replace(StringTools.replace(matrixString, 'matrix(', ''), ')', '').split(',');
            Assert.isTrue(Math.abs(matrix.a - Std.parseFloat(coefficients[0])) < 0.01);
            Assert.isTrue(Math.abs(matrix.b - Std.parseFloat(coefficients[1])) < 0.01);
            Assert.isTrue(Math.abs(matrix.c - Std.parseFloat(coefficients[2])) < 0.01);
            Assert.isTrue(Math.abs(matrix.d - Std.parseFloat(coefficients[3])) < 0.01);
            Assert.isTrue(Math.abs(matrix.tx - Std.parseFloat(coefficients[4])) < 0.01);
            Assert.isTrue(Math.abs(matrix.ty - Std.parseFloat(coefficients[5])) < 0.01);

            // Check stops
            var stops = gradient.node.childNodes;

            Assert.areEqual('0%', stops.item(0).attributes.getNamedItem('offset').nodeValue);
            Assert.isTrue(tools.Color.areColorsEqual('#ff0000', stops.item(0).attributes.getNamedItem('stop-color').nodeValue));
            Assert.isNull(stops.item(0).attributes.getNamedItem('stop-opacity'));

            Assert.areEqual('29%', stops.item(1).attributes.getNamedItem('offset').nodeValue);
            Assert.isTrue(tools.Color.areColorsEqual('#00ff00', stops.item(1).attributes.getNamedItem('stop-color').nodeValue));
            Assert.isTrue(Math.abs(0.5 - Std.parseFloat(stops.item(1).attributes.getNamedItem('stop-opacity').nodeValue)) < 0.01);

            Assert.areEqual('58%', stops.item(2).attributes.getNamedItem('offset').nodeValue);
            Assert.isTrue(tools.Color.areColorsEqual('#0000ff', stops.item(2).attributes.getNamedItem('stop-color').nodeValue));
            Assert.isTrue(Math.abs(0 - Std.parseFloat(stops.item(2).attributes.getNamedItem('stop-opacity').nodeValue)) < 0.01);

            Assert.areEqual('100%', stops.item(3).attributes.getNamedItem('offset').nodeValue);
            Assert.isTrue(tools.Color.areColorsEqual('#ffff00', stops.item(3).attributes.getNamedItem('stop-color').nodeValue));
            Assert.isNull(stops.item(3).attributes.getNamedItem('stop-opacity'));
        }, 300);
        Lib.__getStage().addEventListener(Event.STAGE_RENDERED, asyncHandler);
    }

    @AsyncTest
    public function testBitmapFill1(asyncFactory: AsyncFactory) {
        var bitmap = new Bitmap(Assets.getBitmapData("assets/openfl.png"));

        g.beginBitmapFill(bitmap.bitmapData, null, true, false);
        g.drawRect(10, 15, 450, 500);
        g.endFill();
        asyncHandler = asyncFactory.createHandler(this, function() {
            Lib.__getStage().removeEventListener(Event.STAGE_RENDERED, asyncHandler);
            var rect = g.__snap.select("rect");
            Assert.isNotNull(rect);

            Assert.areEqual("10", rect.attr("x"));
            Assert.areEqual("15", rect.attr("y"));
            Assert.areEqual("450", rect.attr("width"));
            Assert.areEqual("500", rect.attr("height"));
            Assert.areEqual("0", rect.attr("rx"));
            Assert.areEqual("0", rect.attr("ry"));

            Assert.areEqual("fill-rule: evenodd;", rect.attr("style"));
            Assert.areEqual("none", rect.attr("stroke"));
            var fill = rect.attr("fill");
            Assert.isNotNull(fill);
            var fillId = Helper.getAnchorIdFromUrl(fill);
            Assert.isNotNull(fillId);
        }, 300);
        Lib.__getStage().addEventListener(Event.STAGE_RENDERED, asyncHandler);
    }

    @AsyncTest
    public function testBitmapFill2(asyncFactory: AsyncFactory) {
        g.lineStyle(8, 0xAA0110, 1, true, LineScaleMode.NONE, CapsStyle.SQUARE, JointStyle.BEVEL, 4);

        var bitmap = new Bitmap(Assets.getBitmapData("assets/openfl.png"));
        g.beginBitmapFill(bitmap.bitmapData, null, false, false);
        g.drawRect(10, 15, 450, 500);
        g.endFill();
        asyncHandler = asyncFactory.createHandler(this, function() {
            Lib.__getStage().removeEventListener(Event.STAGE_RENDERED, asyncHandler);
            var rect = g.__snap.select("rect");
            Assert.isNotNull(rect);

            Assert.areEqual("10", rect.attr("x"));
            Assert.areEqual("15", rect.attr("y"));
            Assert.areEqual("450", rect.attr("width"));
            Assert.areEqual("500", rect.attr("height"));
            Assert.areEqual("0", rect.attr("rx"));
            Assert.areEqual("0", rect.attr("ry"));

            Assert.isTrue(tools.Color.areColorsEqual('#aa0110', rect.attr("stroke")));

            Assert.areEqual("stroke-width: 8" + strokeWidthPostfix + "; stroke-linecap: square; stroke-linejoin: bevel; stroke-miterlimit: 4; fill-rule: evenodd;" + transformPostfix, rect.attr("style"));
            Assert.areEqual("non-scaling-stroke", rect.attr("vector-effect"));

            var fill = rect.attr("fill");
            Assert.isNotNull(fill);
            var fillId = Helper.getAnchorIdFromUrl(fill);
            Assert.isNotNull(fillId);
        }, 300);
        Lib.__getStage().addEventListener(Event.STAGE_RENDERED, asyncHandler);
    }

    @AsyncTest
    public function testBitmapFill3(asyncFactory: AsyncFactory) {
        g.lineStyle(8, 0xAA0110, 1, true, LineScaleMode.NONE, CapsStyle.SQUARE, JointStyle.BEVEL, 4);

        var bitmap = new Bitmap(Assets.getBitmapData("assets/openfl.png"));
        g.beginBitmapFill(bitmap.bitmapData, null, true, false);
        g.drawRect(10, 15, 900, 500);
        g.endFill();
        asyncHandler = asyncFactory.createHandler(this, function() {
            Lib.__getStage().removeEventListener(Event.STAGE_RENDERED, asyncHandler);
            var rect = g.__snap.select("rect");
            Assert.isNotNull(rect);

            Assert.areEqual("10", rect.attr("x"));
            Assert.areEqual("15", rect.attr("y"));
            Assert.areEqual("900", rect.attr("width"));
            Assert.areEqual("500", rect.attr("height"));
            Assert.areEqual("0", rect.attr("rx"));
            Assert.areEqual("0", rect.attr("ry"));

            Assert.isTrue(tools.Color.areColorsEqual('#aa0110', rect.attr("stroke")));

            Assert.areEqual("stroke-width: 8" + strokeWidthPostfix + "; stroke-linecap: square; stroke-linejoin: bevel; stroke-miterlimit: 4; fill-rule: evenodd;" + transformPostfix, rect.attr("style"));
            Assert.areEqual("non-scaling-stroke", rect.attr("vector-effect"));

            var fill = rect.attr("fill");
            Assert.isNotNull(fill);
            var fillId = Helper.getAnchorIdFromUrl(fill);
            Assert.isNotNull(fillId);

            Assert.areEqual(900, g.__snap.getBBox().width);
            Assert.areEqual(500, g.__snap.getBBox().height);
        }, 300);
        Lib.__getStage().addEventListener(Event.STAGE_RENDERED, asyncHandler);
    }

    @AsyncTest
    public function testBitmapFill4(asyncFactory: AsyncFactory) {
        g.lineStyle(8, 0xAA0110, 1, true, LineScaleMode.NONE, CapsStyle.SQUARE, JointStyle.BEVEL, 4);

        var bitmap = new Bitmap(Assets.getBitmapData("assets/openfl.png"));
        g.beginBitmapFill(bitmap.bitmapData, null, true, false);
        g.drawCircle(10, 15, 120);
        g.endFill();
        asyncHandler = asyncFactory.createHandler(this, function() {
            Lib.__getStage().removeEventListener(Event.STAGE_RENDERED, asyncHandler);
            var circle = g.__snap.select("circle");
            Assert.isNotNull(circle);

            var cx = Std.parseFloat(circle.attr("cx"));
            Assert.isTrue(Math.abs(10 - cx) < 0.01);
            var cy = Std.parseFloat(circle.attr("cy"));
            Assert.isTrue(Math.abs(15 - cy) < 0.01);
            var r = Std.parseFloat(circle.attr("r"));
            Assert.isTrue(Math.abs(120 - r) < 0.01);

            Assert.isTrue(tools.Color.areColorsEqual('#aa0110', circle.attr("stroke")));

            Assert.areEqual("stroke-width: 8" + strokeWidthPostfix + "; stroke-linecap: square; stroke-linejoin: bevel; stroke-miterlimit: 4; fill-rule: evenodd;" + transformPostfix, circle.attr("style"));
            Assert.areEqual("non-scaling-stroke", circle.attr("vector-effect"));

            var fill = circle.attr("fill");
            Assert.isNotNull(fill);
            var fillId = Helper.getAnchorIdFromUrl(fill);
            Assert.isNotNull(fillId);
        }, 300);
        Lib.__getStage().addEventListener(Event.STAGE_RENDERED, asyncHandler);
    }

    @AsyncTest
    public function complexPolygon1(asyncFactory: AsyncFactory) {
        var myFill: GraphicsGradientFill = new GraphicsGradientFill();
        myFill.type = GradientType.LINEAR;
        myFill.colors = [0xff0000,0x00ff00,0x0000ff];
        myFill.alphas = [1.0, 0.3, 0.7];
        myFill.ratios = [0, 128, 255];
        myFill.matrix = new Matrix();
        myFill.matrix.createGradientBox(250, 200, 0);
        myFill.spreadMethod = SpreadMethod.REFLECT;
        myFill.interpolationMethod = InterpolationMethod.LINEAR_RGB;
        myFill.focalPointRatio = 4;

        // establish the stroke properties
        var myStroke:GraphicsStroke = new GraphicsStroke(2);
        myStroke.fill = new GraphicsSolidFill(0xDD00FF);
        myStroke.thickness = 7;
        myStroke.pixelHinting = true;
        myStroke.scaleMode = LineScaleMode.NORMAL;
        myStroke.caps = CapsStyle.SQUARE;
        myStroke.joints = JointStyle.ROUND;
        myStroke.miterLimit = 7;


        // establish the path properties
        var pathCommands: Array<Int> = new Array<Int>();
        pathCommands.push(GraphicsPathCommand.MOVE_TO);
        pathCommands.push(GraphicsPathCommand.LINE_TO);
        pathCommands.push(GraphicsPathCommand.LINE_TO);
        pathCommands.push(GraphicsPathCommand.LINE_TO);
        pathCommands.push(GraphicsPathCommand.LINE_TO);

        var pathCoordinates: Array<Int> = [300, 20, 500, 400, 50, 70, 550, 70, 100, 400];

        var myPath:GraphicsPath = new GraphicsPath(pathCommands, pathCoordinates);

        // populate the IGraphicsData Vector array
        var myDrawing: Array<IGraphicsData> =[myFill, myStroke, myPath];

        // render the drawing
        g.drawGraphicsData(myDrawing);

        asyncHandler = asyncFactory.createHandler(this, function() {
            Lib.__getStage().removeEventListener(Event.STAGE_RENDERED, asyncHandler);
            var path = g.__snap.select("path");

            Assert.isNotNull(path);
            Assert.areEqual("M300 20 L500 400 L50 70 L550 70 L100 400 L300 20 Z", path.attr("d"));

            Assert.isTrue(tools.Color.areColorsEqual('rgba(221,0,255,1)', path.attr('stroke')));

            Assert.isNotNull(path.attr('fill'));
            var gradientId = Helper.getAnchorIdFromUrl(path.attr('fill'));
            Assert.isNotNull(gradientId);

            var gradient = Snap.select('#' + gradientId);
            Assert.isNotNull(gradient);
            Assert.areEqual('linearGradient', gradient.type);

            Assert.areEqual('-819.2', gradient.attr('x1'));
            Assert.areEqual('0', gradient.attr('y1'));
            Assert.areEqual('819.2', gradient.attr('x2'));
            Assert.areEqual('0', gradient.attr('y2'));
            Assert.areEqual('reflect', gradient.attr('spreadMethod'));
            Assert.areEqual('userSpaceOnUse', gradient.attr('gradientUnits'));

            // Check matrix
            var matrixString: String = gradient.attr('gradientTransform');
            Assert.isNotNull(matrixString);
            var coefficients = cast StringTools.replace(StringTools.replace(matrixString, 'matrix(', ''), ')', '').split(',');
            Assert.isTrue(Math.abs(myFill.matrix.a - Std.parseFloat(coefficients[0])) < 0.01);
            Assert.isTrue(Math.abs(myFill.matrix.b - Std.parseFloat(coefficients[1])) < 0.01);
            Assert.isTrue(Math.abs(myFill.matrix.c - Std.parseFloat(coefficients[2])) < 0.01);
            Assert.isTrue(Math.abs(myFill.matrix.d - Std.parseFloat(coefficients[3])) < 0.01);
            Assert.isTrue(Math.abs(myFill.matrix.tx - Std.parseFloat(coefficients[4])) < 0.01);
            Assert.isTrue(Math.abs(myFill.matrix.ty - Std.parseFloat(coefficients[5])) < 0.01);

            // Check stops
            var stops = gradient.node.childNodes;
            Assert.areEqual('0%', stops.item(0).attributes.getNamedItem('offset').nodeValue);
            Assert.isTrue(tools.Color.areColorsEqual('#ff0000', stops.item(0).attributes.getNamedItem('stop-color').nodeValue));
            Assert.isNull(stops.item(0).attributes.getNamedItem('stop-opacity'));

            Assert.areEqual('50%', stops.item(1).attributes.getNamedItem('offset').nodeValue);
            Assert.isTrue(tools.Color.areColorsEqual('#00ff00', stops.item(1).attributes.getNamedItem('stop-color').nodeValue));
            Assert.isTrue(Math.abs(0.3 - Std.parseFloat(stops.item(1).attributes.getNamedItem('stop-opacity').nodeValue)) < 0.01);

            Assert.areEqual('100%', stops.item(2).attributes.getNamedItem('offset').nodeValue);
            Assert.isTrue(tools.Color.areColorsEqual('#0000ff', stops.item(2).attributes.getNamedItem('stop-color').nodeValue));
            Assert.isTrue(Math.abs(0.7 - Std.parseFloat(stops.item(2).attributes.getNamedItem('stop-opacity').nodeValue)) < 0.01);

            Assert.areEqual("stroke-width: 7" + strokeWidthPostfix + "; stroke-linecap: square; stroke-linejoin: round; stroke-miterlimit: 7; fill-rule: evenodd;" + transformPostfix, path.attr("style"));
            Assert.areEqual("none", path.attr("vector-effect"));
        }, 300);
        Lib.__getStage().addEventListener(Event.STAGE_RENDERED, asyncHandler);
    }

    @AsyncTest
    public function complexPolygon2(asyncFactory: AsyncFactory) {
        var myFill: GraphicsSolidFill = new GraphicsSolidFill();
        myFill.alpha = 0.5;
        myFill.color = 0x4E9AF4;

        // establish the stroke properties
        var myStroke:GraphicsStroke = new GraphicsStroke(2);
        myStroke.fill = new GraphicsSolidFill(0xDD00FF);
        myStroke.thickness = 7;
        myStroke.pixelHinting = true;
        myStroke.scaleMode = LineScaleMode.NORMAL;
        myStroke.caps = CapsStyle.SQUARE;
        myStroke.joints = JointStyle.ROUND;
        myStroke.miterLimit = 7;


        // establish the path properties
        var pathCommands: Array<Int> = new Array<Int>();
        pathCommands.push(GraphicsPathCommand.MOVE_TO);
        pathCommands.push(GraphicsPathCommand.LINE_TO);
        pathCommands.push(GraphicsPathCommand.LINE_TO);
        pathCommands.push(GraphicsPathCommand.LINE_TO);
        pathCommands.push(GraphicsPathCommand.LINE_TO);

        var pathCoordinates: Array<Int> = [300, 20, 500, 400, 50, 70, 550, 70, 100, 400];

        var myPath:GraphicsPath = new GraphicsPath(pathCommands, pathCoordinates);

        // populate the IGraphicsData Vector array
        var myDrawing: Array<IGraphicsData> =[myFill, myStroke, myPath];

        // render the drawing
        g.drawGraphicsData(myDrawing);

        asyncHandler = asyncFactory.createHandler(this, function() {
            Lib.__getStage().removeEventListener(Event.STAGE_RENDERED, asyncHandler);
            var path = g.__snap.select("path");

            Assert.isNotNull(path);
            Assert.areEqual("M300 20 L500 400 L50 70 L550 70 L100 400 L300 20 Z", path.attr("d"));

            Assert.isNotNull(path.attr('stroke'));
            Assert.isTrue(tools.Color.areColorsEqual('rgba(221,0,255,1)', path.attr('stroke')));

            Assert.isNotNull(path.attr('fill'));
            Assert.isTrue(tools.Color.areColorsEqual('rgba(78,154,244,0.5)', path.attr("fill")));

            Assert.areEqual("stroke-width: 7" + strokeWidthPostfix + "; stroke-linecap: square; stroke-linejoin: round; stroke-miterlimit: 7; fill-rule: evenodd;" + transformPostfix, path.attr("style"));
            Assert.areEqual("none", path.attr("vector-effect"));
        }, 300);
        Lib.__getStage().addEventListener(Event.STAGE_RENDERED, asyncHandler);
    }

    @AsyncTest
    public function complexPolygon3(asyncFactory: AsyncFactory) {
        g.lineStyle(3, 0x123456, 0.4, true, LineScaleMode.NORMAL, CapsStyle.ROUND, JointStyle.BEVEL, 5);
        g.beginFill(0x654321, 0.4);
        g.moveTo(40, 30);
        g.lineTo(120, 30);
        g.lineTo(160, 70);
        g.lineTo(190, 40);
        g.lineTo(150, 100);
        g.lineTo(130, 70);
        g.lineTo(170, 30);
        g.lineTo(170, 130);
        g.lineTo(110, 80);
        g.lineTo(100, 170);
        g.lineTo(90, 180);
        g.lineTo(90, 140);
        g.lineTo(60, 120);
        g.lineTo(70, 160);
        g.lineTo(120, 160);
        g.lineTo(60, 80);
        g.lineTo(70, 50);

        asyncHandler = asyncFactory.createHandler(this, function() {
            Lib.__getStage().removeEventListener(Event.STAGE_RENDERED, asyncHandler);
            var path = g.__snap.select("path");

            Assert.isNotNull(path);
            Assert.areEqual("M40 30 L120 30 L160 70 L190 40 L150 100 L130 70 L170 30 L170 130 L110 80 L100 170 L90 180 L90 140 L60 120 L70 160 L120 160 L60 80 L70 50 L40 30 Z", path.attr("d"));

            Assert.isNotNull(path.attr('stroke'));
            Assert.isTrue(tools.Color.areColorsEqual('rgba(18,52,86,0.4)', path.attr('stroke')));

            Assert.isNotNull(path.attr('fill'));
            Assert.isTrue(tools.Color.areColorsEqual('rgba(101,67,33,0.4)', path.attr('fill')));

            Assert.areEqual("stroke-width: 3" + strokeWidthPostfix + "; stroke-linecap: round; stroke-linejoin: bevel; stroke-miterlimit: 5; fill-rule: evenodd;" + transformPostfix, path.attr("style"));
            Assert.areEqual("none", path.attr("vector-effect"));
        }, 300);
        Lib.__getStage().addEventListener(Event.STAGE_RENDERED, asyncHandler);
    }

    @AsyncTest
    public function complexPolygon4(asyncFactory: AsyncFactory) {
        g.lineStyle(3, 0x123456, 0.4, true, LineScaleMode.NORMAL, CapsStyle.ROUND, JointStyle.BEVEL, 5);
        var bitmap = new Bitmap(Assets.getBitmapData("assets/openfl.png"));
        g.beginBitmapFill(bitmap.bitmapData, null, true, false);
        g.moveTo(40, 30);
        g.lineTo(120, 30);
        g.lineTo(160, 70);
        g.lineTo(190, 40);
        g.lineTo(150, 100);
        g.lineTo(130, 70);
        g.lineTo(170, 30);
        g.lineTo(170, 130);
        g.lineTo(110, 80);
        g.lineTo(100, 170);
        g.lineTo(90, 180);
        g.lineTo(90, 140);
        g.lineTo(60, 120);
        g.lineTo(70, 160);
        g.lineTo(120, 160);
        g.lineTo(60, 80);
        g.lineTo(70, 50);

        asyncHandler = asyncFactory.createHandler(this, function() {
            Lib.__getStage().removeEventListener(Event.STAGE_RENDERED, asyncHandler);
            var path = g.__snap.select("path");

            Assert.isNotNull(path);
            Assert.areEqual("M40 30 L120 30 L160 70 L190 40 L150 100 L130 70 L170 30 L170 130 L110 80 L100 170 L90 180 L90 140 L60 120 L70 160 L120 160 L60 80 L70 50 L40 30 Z", path.attr("d"));

            Assert.isNotNull(path.attr('stroke'));
            Assert.isTrue(tools.Color.areColorsEqual('rgba(18,52,86,0.4)', path.attr('stroke')));

            var fill = path.attr("fill");
            Assert.isNotNull(fill);
            var fillId = Helper.getAnchorIdFromUrl(fill);
            Assert.isNotNull(fillId);

            Assert.areEqual("stroke-width: 3" + strokeWidthPostfix + "; stroke-linecap: round; stroke-linejoin: bevel; stroke-miterlimit: 5; fill-rule: evenodd;" + transformPostfix, path.attr("style"));
            Assert.areEqual("none", path.attr("vector-effect"));
        }, 300);
        Lib.__getStage().addEventListener(Event.STAGE_RENDERED, asyncHandler);
    }

    @AsyncTest
    public function complexPolygon5(asyncFactory: AsyncFactory) {
        var myFill: GraphicsSolidFill = new GraphicsSolidFill();
        myFill.alpha = 0.5;
        myFill.color = 0x4E9AF4;

        var strokeGradFill: GraphicsGradientFill = new GraphicsGradientFill();
        strokeGradFill.type = GradientType.LINEAR;
        strokeGradFill.colors = [0xff0000,0x00ff00,0x0000ff];
        strokeGradFill.alphas = [1.0, 0.3, 0.7];
        strokeGradFill.ratios = [0, 128, 255];
        strokeGradFill.matrix = new Matrix();
        strokeGradFill.matrix.createGradientBox(250, 200, 0);
        strokeGradFill.spreadMethod = SpreadMethod.REFLECT;
        strokeGradFill.interpolationMethod = InterpolationMethod.LINEAR_RGB;
        strokeGradFill.focalPointRatio = 4;

        // establish the stroke properties
        var myStroke:GraphicsStroke = new GraphicsStroke(2);
        myStroke.fill = strokeGradFill;
        myStroke.thickness = 7;
        myStroke.pixelHinting = true;
        myStroke.scaleMode = LineScaleMode.NORMAL;
        myStroke.caps = CapsStyle.SQUARE;
        myStroke.joints = JointStyle.ROUND;
        myStroke.miterLimit = 7;


        // establish the path properties
        var pathCommands: Array<Int> = new Array<Int>();
        pathCommands.push(GraphicsPathCommand.MOVE_TO);
        pathCommands.push(GraphicsPathCommand.LINE_TO);
        pathCommands.push(GraphicsPathCommand.LINE_TO);
        pathCommands.push(GraphicsPathCommand.LINE_TO);
        pathCommands.push(GraphicsPathCommand.LINE_TO);

        var pathCoordinates: Array<Int> = [300, 20, 500, 400, 50, 70, 550, 70, 100, 400];

        var myPath:GraphicsPath = new GraphicsPath(pathCommands, pathCoordinates);

        // populate the IGraphicsData Vector array
        var myDrawing: Array<IGraphicsData> =[myFill, myStroke, myPath];

        // render the drawing
        g.drawGraphicsData(myDrawing);

        asyncHandler = asyncFactory.createHandler(this, function() {
            Lib.__getStage().removeEventListener(Event.STAGE_RENDERED, asyncHandler);
            var path = g.__snap.select("path");

            Assert.isNotNull(path);
            Assert.areEqual("M300 20 L500 400 L50 70 L550 70 L100 400 L300 20 Z", path.attr("d"));

            Assert.isNotNull(path.attr('stroke'));
            var gradientId = Helper.getAnchorIdFromUrl(path.attr('stroke'));
            Assert.isNotNull(gradientId);

            var gradient = Snap.select('#' + gradientId);
            Assert.isNotNull(gradient);
            Assert.areEqual('linearGradient', gradient.type);

            Assert.areEqual('-819.2', gradient.attr('x1'));
            Assert.areEqual('0', gradient.attr('y1'));
            Assert.areEqual('819.2', gradient.attr('x2'));
            Assert.areEqual('0', gradient.attr('y2'));
            Assert.areEqual('reflect', gradient.attr('spreadMethod'));
            Assert.areEqual('userSpaceOnUse', gradient.attr('gradientUnits'));

            // Check matrix
            var matrixString: String = gradient.attr('gradientTransform');
            Assert.isNotNull(matrixString);
            var coefficients = cast StringTools.replace(StringTools.replace(matrixString, 'matrix(', ''), ')', '').split(',');
            Assert.isTrue(Math.abs(strokeGradFill.matrix.a - Std.parseFloat(coefficients[0])) < 0.01);
            Assert.isTrue(Math.abs(strokeGradFill.matrix.b - Std.parseFloat(coefficients[1])) < 0.01);
            Assert.isTrue(Math.abs(strokeGradFill.matrix.c - Std.parseFloat(coefficients[2])) < 0.01);
            Assert.isTrue(Math.abs(strokeGradFill.matrix.d - Std.parseFloat(coefficients[3])) < 0.01);
            Assert.isTrue(Math.abs(strokeGradFill.matrix.tx - Std.parseFloat(coefficients[4])) < 0.01);
            Assert.isTrue(Math.abs(strokeGradFill.matrix.ty - Std.parseFloat(coefficients[5])) < 0.01);

            // Check stops
            var stops = gradient.node.childNodes;
            Assert.areEqual('0%', stops.item(0).attributes.getNamedItem('offset').nodeValue);
            Assert.isTrue(tools.Color.areColorsEqual('#ff0000', stops.item(0).attributes.getNamedItem('stop-color').nodeValue));
            Assert.isNull(stops.item(0).attributes.getNamedItem('stop-opacity'));

            Assert.areEqual('50%', stops.item(1).attributes.getNamedItem('offset').nodeValue);
            Assert.isTrue(tools.Color.areColorsEqual('#00ff00', stops.item(1).attributes.getNamedItem('stop-color').nodeValue));
            Assert.isTrue(Math.abs(0.3 - Std.parseFloat(stops.item(1).attributes.getNamedItem('stop-opacity').nodeValue)) < 0.01);

            Assert.areEqual('100%', stops.item(2).attributes.getNamedItem('offset').nodeValue);
            Assert.isTrue(tools.Color.areColorsEqual('#0000ff', stops.item(2).attributes.getNamedItem('stop-color').nodeValue));
            Assert.isTrue(Math.abs(0.7 - Std.parseFloat(stops.item(2).attributes.getNamedItem('stop-opacity').nodeValue)) < 0.01);

            Assert.isNotNull(path.attr('fill'));
            Assert.isTrue(tools.Color.areColorsEqual('rgba(78,154,244,0.5)', path.attr("fill")));

            Assert.areEqual("stroke-width: 7" + strokeWidthPostfix + "; stroke-linecap: square; stroke-linejoin: round; stroke-miterlimit: 7; fill-rule: evenodd;" + transformPostfix, path.attr("style"));
            Assert.areEqual("none", path.attr("vector-effect"));
        }, 300);
        Lib.__getStage().addEventListener(Event.STAGE_RENDERED, asyncHandler);
    }

    @AsyncTest
    public function complexPolygon6(asyncFactory: AsyncFactory) {
        var bitmap = new Bitmap(Assets.getBitmapData("assets/openfl.png"));

        var myFill: GraphicsBitmapFill = new GraphicsBitmapFill();
        myFill.bitmapData = bitmap.bitmapData;
        myFill.matrix = null;
        myFill.repeat = true;
        myFill.smooth = false;

        // establish the stroke properties
        var myStroke:GraphicsStroke = new GraphicsStroke(2);
        myStroke.fill = new GraphicsSolidFill(0xDD00FF);
        myStroke.thickness = 7;
        myStroke.pixelHinting = true;
        myStroke.scaleMode = LineScaleMode.NORMAL;
        myStroke.caps = CapsStyle.SQUARE;
        myStroke.joints = JointStyle.ROUND;
        myStroke.miterLimit = 7;


        // establish the path properties
        var pathCommands: Array<Int> = new Array<Int>();
        pathCommands.push(GraphicsPathCommand.MOVE_TO);
        pathCommands.push(GraphicsPathCommand.LINE_TO);
        pathCommands.push(GraphicsPathCommand.LINE_TO);
        pathCommands.push(GraphicsPathCommand.LINE_TO);
        pathCommands.push(GraphicsPathCommand.LINE_TO);

        var pathCoordinates: Array<Int> = [300, 20, 500, 400, 50, 70, 550, 70, 100, 400];

        var myPath:GraphicsPath = new GraphicsPath(pathCommands, pathCoordinates);

        // populate the IGraphicsData Vector array
        var myDrawing: Array<IGraphicsData> =[myFill, myStroke, myPath];

        // render the drawing
        g.drawGraphicsData(myDrawing);

        asyncHandler = asyncFactory.createHandler(this, function() {
            Lib.__getStage().removeEventListener(Event.STAGE_RENDERED, asyncHandler);
            var path = g.__snap.select("path");

            Assert.isNotNull(path);
            Assert.areEqual("M300 20 L500 400 L50 70 L550 70 L100 400 L300 20 Z", path.attr("d"));

            Assert.isNotNull(path.attr('stroke'));
            Assert.isTrue(tools.Color.areColorsEqual('rgba(221,0,255,1)', path.attr('stroke')));

            var fill = path.attr("fill");
            Assert.isNotNull(fill);
            var fillId = Helper.getAnchorIdFromUrl(fill);
            Assert.isNotNull(fillId);

            Assert.areEqual("stroke-width: 7" + strokeWidthPostfix + "; stroke-linecap: square; stroke-linejoin: round; stroke-miterlimit: 7; fill-rule: evenodd;" + transformPostfix, path.attr("style"));
            Assert.areEqual("none", path.attr("vector-effect"));
        }, 300);
        Lib.__getStage().addEventListener(Event.STAGE_RENDERED, asyncHandler);
    }
}