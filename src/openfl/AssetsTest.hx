package openfl;

import flash.display.BitmapData;
import massive.munit.Assert;
import flash.display.Bitmap;

@:bitmap("assets/openfl.png") class OpenFlImage extends BitmapData {}

class AssetsTest {
    @Test
    public function testGetBitmapData() {
        var bitmapData:BitmapData = Assets.getBitmapData("assets/openfl.png");
        Assert.isNotNull(bitmapData);
        Assert.areEqual(400, bitmapData.width);
        Assert.areEqual(400, bitmapData.height);
    }

    @Test
    public function testEmbedBitmap() {
        var bitmapData:BitmapData = new OpenFlImage(0,0, null, null, function(bd) {
            Assert.isNotNull(bd);
            Assert.areEqual(400, bd.width);
            Assert.areEqual(400, bd.height);
        });
    }
}
