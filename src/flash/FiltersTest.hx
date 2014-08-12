package flash;

import flash.filters.GlowFilter;
import flash.filters.BitmapFilterQuality;
import flash.filters.ConvolutionFilter;
import flash.filters.ColorMatrixFilter;
import flash.filters.BevelFilter;
import flash.filters.BlurFilter;
import flash.filters.DropShadowFilter;
import flash.events.Event;
import flash.display.Sprite;
import massive.munit.async.AsyncFactory;

class FiltersTest {
    private var asyncHandler: Dynamic;

    @Before
    public function setup():Void {
//        Lib.current.removeChildren();
    }

    @After
    public function tearDown():Void {
//        Lib.current.removeChildren();
    }

    @AsyncTest
    public function testFiltering(asyncFactory: AsyncFactory) {

        var child = new Sprite();

        child.x = 150;
        child.y = 150;
        child.graphics.beginFill(0xcccccc);
        child.graphics.drawRect(0,0,100,100);
        child.filters = cast [
            //new DropShadowFilter(40, -145, 0xffff00, 0.5, 10, 10, 3, BitmapFilterQuality.HIGH, false, false, false),
            //new BlurFilter(10, 10),
            //new BevelFilter(20000, 45, 0xff00ff, 0.5),
            //new ColorMatrixFilter([0,0,0,0,0, 1,1,1,1,0, 0,0,0,0,0, 0,0,0,1,0]),
            //new ConvolutionFilter(3,3, [0,0,0, 0,1,0, 0,0,0], 2, 0.5, true),
            new GlowFilter()
        ];
        Lib.current.addChild(child);

        asyncHandler = asyncFactory.createHandler(this, function() {
        }, 500);
        Lib.__getStage().addEventListener(Event.STAGE_RENDERED, asyncHandler);
    }

}
