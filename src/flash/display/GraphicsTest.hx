package flash.display;

import massive.munit.Assert;
import massive.munit.async.AsyncFactory;
import flash.events.Event;

class GraphicsTest {
    @Test
    public function testLineTo() {
        var g:Graphics = Lib.current.graphics;
        g.lineStyle();
        g.beginFill(0xff0000, 1);
        g.drawRoundRect(50, 50, 500, 500, 20);
        g.endFill();

        g.lineStyle(10, 0);
        g.moveTo(100,100);
        g.lineTo(200, 200);
        g.lineTo(200, 300);

        //g.clear();
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