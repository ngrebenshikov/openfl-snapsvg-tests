package flash;

import snap.Snap;
import tools.Helper;
import massive.munit.Assert;
import flash.display.DisplayObject;
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
    public function testDropShadowFilter(asyncFactory: AsyncFactory) {

        var child = new Sprite();

        child.x = 150;
        child.y = 150;
        child.graphics.beginFill(0xcccccc);
        child.graphics.drawRect(0,0,100,100);
        child.filters = cast [
            new DropShadowFilter(40, -145, 0xffff00, 0.7, 10, 10, 3, BitmapFilterQuality.HIGH, false, false, false),
            //new BlurFilter(10, 10),
            //new BevelFilter(20000, 45, 0xff00ff, 0.5),
            //new ColorMatrixFilter([0,0,0,0,0, 1,1,1,1,0, 0,0,0,0,0, 0,0,0,1,0]),
            //new ConvolutionFilter(3,3, [0,0,0, 0,1,0, 0,0,0], 2, 0.5, true),
            //new GlowFilter()
        ];
        Lib.current.addChild(child);

        asyncHandler = asyncFactory.createHandler(this, function() {
            Lib.__getStage().removeEventListener(Event.STAGE_RENDERED, asyncHandler);
            var filter = getFilterSnapWithCommonTesting(child);
            Assert.areEqual(10, filter.node.childNodes.item(0).attributes.getNamedItem('stdDeviation').nodeValue);
            var offset = filter.node.childNodes.item(1);
            Assert.isTrue(Math.abs(Std.parseFloat(offset.attributes.getNamedItem('dx').nodeValue) - 40 * Math.sin(2*Math.PI*-145/360.0)) < 0.01);
            Assert.isTrue(Math.abs(Std.parseFloat(offset.attributes.getNamedItem('dy').nodeValue) - 40 * Math.cos(2*Math.PI*-145/360.0)) < 0.01);
            trace(filter.node.childNodes.item(2).attributes.getNamedItem('flood-color').nodeValue);
            Assert.isTrue(tools.Color.areColorsEqual("rgba(255,255,0,0.7)", filter.node.childNodes.item(2).attributes.getNamedItem('flood-color').nodeValue));
        }, 500);
        Lib.__getStage().addEventListener(Event.STAGE_RENDERED, asyncHandler);
    }

    private function getFilterSnapWithCommonTesting(obj: DisplayObject): SnapElement {
        Assert.isNotNull(obj);
        Assert.isNotNull(obj.snap);
        Assert.isNotNull(obj.snap.node.attributes.getNamedItem('filter').nodeValue);

        var filterId = Helper.getAnchorIdFromUrl(obj.snap.node.attributes.getNamedItem('filter').nodeValue);
        Assert.isNotNull(filterId);

        var filter = Snap.select('#' + filterId);
        Assert.isNotNull(filter);

        Assert.areEqual('filter', filter.type);

        return filter;
    }

}
