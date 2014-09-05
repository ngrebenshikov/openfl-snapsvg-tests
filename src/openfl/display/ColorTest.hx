package openfl.display;

import massive.munit.Assert;
class ColorTest {
    @Test
    public function testColor() {
        Assert.isTrue(tools.Color.areColorsEqual("rgb(12, 34, 56)", "rgb(12,34,56)"));
        Assert.isFalse(tools.Color.areColorsEqual("rgb(12, 34, 56)", "rgb(12,34,55)"));

        Assert.isTrue(tools.Color.areColorsEqual("rgb(12, 34, 56)", "rgb(12,34,56, 1)"));
        Assert.isTrue(tools.Color.areColorsEqual("rgb(12, 34, 56)", "rgb(12,34,56, 1.0)"));
        Assert.isFalse(tools.Color.areColorsEqual("rgb(12, 34, 56, 0.09)", "rgb(12,34,56, 1.0)"));

        Assert.isTrue(tools.Color.areColorsEqual("#aa0110", "rgb(170, 1, 16)"));
        Assert.isFalse(tools.Color.areColorsEqual("#aa0111", "rgb(170, 1, 16)"));

        Assert.isTrue(tools.Color.areColorsEqual("rgb(0,0,0,0)", "transparent"));
        Assert.isFalse(tools.Color.areColorsEqual("rgb(0,0,0,0.01)", "transparent"));

        Assert.isTrue(tools.Color.areColorsEqual("rgb(0,0,255, 0.7)", "rgba(0, 0, 255, 0.7019607843137254)"));
    }
}
