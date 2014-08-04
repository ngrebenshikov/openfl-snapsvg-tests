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
}