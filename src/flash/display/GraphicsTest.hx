package flash.display;

import haxe.unit.TestCase;

class GraphicsTest extends TestCase {

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

    public function testCurveTo() {
        var g: Graphics = Lib.current.graphics;

        g.lineStyle(5, 0x0000FF);
        g.moveTo(250, 200);
        g.curveTo(300, 0, 350, 200);
        g.curveTo(400, 450 , 500, 200);
        Lib.__getStage().addEventListener("STAGE_RENDERED", assertsTestCurveTo);
    }

    private function assertsTestCurveTo(args: Dynamic) {
        Lib.__getStage().removeEventListener("STAGE_RENDERED", assertsTestCurveTo);
        var g: Graphics = Lib.current.graphics;
        trace(g.__snap);
        assertTrue(true);
    }
}