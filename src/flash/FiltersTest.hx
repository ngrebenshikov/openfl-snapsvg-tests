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

    @AsyncTest
    public function testDropShadowFilter(asyncFactory: AsyncFactory) {

        var child = new Sprite();

        child.x = 50;
        child.y = 50;
        child.graphics.beginFill(0xcccccc);
        child.graphics.drawRect(0,0,50,50);
        child.filters = cast [
            new DropShadowFilter(30, -145, 0xffff00, 0.7, 10, 10, 3, BitmapFilterQuality.HIGH, false, false, false),
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
            Assert.isTrue(Math.abs(Std.parseFloat(offset.attributes.getNamedItem('dx').nodeValue) - 30 * Math.sin(2*Math.PI*-145/360.0)) < 0.01);
            Assert.isTrue(Math.abs(Std.parseFloat(offset.attributes.getNamedItem('dy').nodeValue) - 30 * Math.cos(2*Math.PI*-145/360.0)) < 0.01);
            Assert.isTrue(tools.Color.areColorsEqual("rgba(255,255,0,0.7)", filter.node.childNodes.item(2).attributes.getNamedItem('flood-color').nodeValue));
        }, 500);
        Lib.__getStage().addEventListener(Event.STAGE_RENDERED, asyncHandler);
    }


    @AsyncTest
    public function testBlurFilter(asyncFactory: AsyncFactory) {

        var child = new Sprite();

        child.x = 100;
        child.y = 100;
        child.graphics.beginFill(0x123456);
        child.graphics.drawRect(0,0,50,50);
        child.filters = cast [ new BlurFilter(3, 6) ];
        Lib.current.addChild(child);

        asyncHandler = asyncFactory.createHandler(this, function() {
            Lib.__getStage().removeEventListener(Event.STAGE_RENDERED, asyncHandler);
            var filter = getFilterSnapWithCommonTesting(child);
            Assert.areEqual("3,6", filter.node.childNodes.item(0).attributes.getNamedItem('stdDeviation').nodeValue);
        }, 500);
        Lib.__getStage().addEventListener(Event.STAGE_RENDERED, asyncHandler);
    }

    @AsyncTest
    public function testBevelFilter(asyncFactory: AsyncFactory) {

        var child = new Sprite();

        child.x = 150;
        child.y = 150;
        child.graphics.beginFill(0x123456);
        child.graphics.drawRect(0,0,50,50);
        child.filters = cast [ new BevelFilter(20000, 45, 0xff00ff, 0.3) ];
        Lib.current.addChild(child);

        asyncHandler = asyncFactory.createHandler(this, function() {
            Lib.__getStage().removeEventListener(Event.STAGE_RENDERED, asyncHandler);
            var filter = getFilterSnapWithCommonTesting(child);
            var lightPoint = filter.node.childNodes.item(2).childNodes.item(1);
            Assert.isTrue(Math.abs(Std.parseFloat(lightPoint.attributes.getNamedItem('x').nodeValue) + 20000 * Math.sin(2*Math.PI*45/360.0)) < 0.01);
            Assert.isTrue(Math.abs(Std.parseFloat(lightPoint.attributes.getNamedItem('y').nodeValue) + 20000 * Math.cos(2*Math.PI*45/360.0)) < 0.01);
            Assert.isTrue(tools.Color.areColorsEqual("rgba(255,0,255,0.3)", filter.node.childNodes.item(2).attributes.getNamedItem('lighting-color').nodeValue));
        }, 500);
        Lib.__getStage().addEventListener(Event.STAGE_RENDERED, asyncHandler);
    }

    @AsyncTest
    public function testColorMatrixFilter(asyncFactory: AsyncFactory) {

        var child = new Sprite();

        child.x = 200;
        child.y = 200;
        child.graphics.beginFill(0x123456);
        child.graphics.drawRect(0,0,50,50);
        child.filters = cast [ new ColorMatrixFilter([0,0,0,0,0, 1,1,1,1,0, 0,0,0,0,0, 0,0,0,1,0]) ];
        Lib.current.addChild(child);
        asyncHandler = asyncFactory.createHandler(this, function() {
            Lib.__getStage().removeEventListener(Event.STAGE_RENDERED, asyncHandler);
            var filter = getFilterSnapWithCommonTesting(child);
            Assert.areEqual([0,0,0,0,0, 1,1,1,1,0, 0,0,0,0,0, 0,0,0,1,0].join(','), filter.node.childNodes.item(0).attributes.getNamedItem('values').nodeValue);
        }, 500);
        Lib.__getStage().addEventListener(Event.STAGE_RENDERED, asyncHandler);
    }

    @AsyncTest
    public function testConvolutionFilter(asyncFactory: AsyncFactory) {

        var child = new Sprite();

        child.x = 250;
        child.y = 250;
        child.graphics.beginFill(0x123456);
        child.graphics.drawRect(0,0,50,50);
        child.filters = cast [ new ConvolutionFilter(3,3, [0,0,0, 0,1,0, 0,0,0], 2, 0.5, true) ];
        Lib.current.addChild(child);
        asyncHandler = asyncFactory.createHandler(this, function() {
            Lib.__getStage().removeEventListener(Event.STAGE_RENDERED, asyncHandler);
            var filter = getFilterSnapWithCommonTesting(child);
            var attrs = filter.node.childNodes.item(0).attributes;
            Assert.areEqual('3,3', attrs.getNamedItem('order').nodeValue);
            Assert.areEqual([0,0,0, 0,1,0, 0,0,0].join(','), attrs.getNamedItem('kernelMatrix').nodeValue);
            Assert.areEqual('2', attrs.getNamedItem('divisor').nodeValue);
            Assert.isTrue(Math.abs(0.5 - Std.parseFloat(attrs.getNamedItem('bias').nodeValue)) < 0.01);
            Assert.areEqual('true', attrs.getNamedItem('preserveAlpha').nodeValue);
        }, 500);
        Lib.__getStage().addEventListener(Event.STAGE_RENDERED, asyncHandler);
    }

    @AsyncTest
    public function testGlowFilter(asyncFactory: AsyncFactory) {

        var child = new Sprite();

        child.x = 300;
        child.y = 300;
        child.graphics.beginFill(0x123456);
        child.graphics.drawRect(0,0,50,50);
        child.filters = cast [ new GlowFilter() ];
        Lib.current.addChild(child);
        asyncHandler = asyncFactory.createHandler(this, function() {
            Lib.__getStage().removeEventListener(Event.STAGE_RENDERED, asyncHandler);
            var filter = getFilterSnapWithCommonTesting(child);
            trace(filter.innerSVG());
            Assert.areEqual(6, filter.node.childNodes.item(0).attributes.getNamedItem('stdDeviation').nodeValue);
            var offset = filter.node.childNodes.item(1);
            Assert.areEqual('0', offset.attributes.getNamedItem('dx').nodeValue);
            Assert.areEqual('0', offset.attributes.getNamedItem('dy').nodeValue);
            Assert.isTrue(tools.Color.areColorsEqual("#000000", filter.node.childNodes.item(2).attributes.getNamedItem('flood-color').nodeValue));
        }, 500);
        Lib.__getStage().addEventListener(Event.STAGE_RENDERED, asyncHandler);
    }
}
