package flash.display;

import massive.munit.async.AsyncFactory;
import flash.events.Event;
import flash.geom.Point;
import flash.text.TextField;
import flash.text.TextFormat;
import massive.munit.Assert;
import snap.Snap;

class TextFieldTest {

    private var tf:TextField;
    private var testTextFieldHandler: Dynamic;

    @Before
    public function setup():Void {
//        Lib.current.removeChildren();
    }

    @After
    public function tearDown():Void {
//        Lib.current.removeChildren();
    }

    @AsyncTest
    public function testAddChild(asyncFactory: AsyncFactory) {
        trace("AddChild text field test");

        tf = new TextField();

        var format = new TextFormat();
        format.size = 18;
        format.font = "Tahoma";
        Lib.current.addChild(tf);

        tf.background = true;
        tf.backgroundColor = 0xFFE100;
        tf.x = 20;
        tf.y = 100;
        tf.width = 150;
        tf.wordWrap = true;
        tf.textColor = 0x45ad00;
        tf.defaultTextFormat = format;
        tf.text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit.\nCras quis arcu cursus, tincidunt ligula eget, semper\ndiam. Nulla sodales diam ut sapien dictum blandit.";

        testTextFieldHandler = asyncFactory.createHandler(this, function() {
            Assert.isTrue(tf.snap.parent() != null);
            Assert.isTrue(tf.snap.parent().node == Lib.current.snap.node);
            trace(tf.snap.attr("transform"));
            var text = tf.snap.select("text");
            trace( text );
            trace( text.attr("font-family") );
            trace( text.attr("font-size") );
            trace( text.attr("fill") );
            Assert.isTrue( text != null );
            Assert.areEqual( "m1,0,0,1,20,100", tf.snap.attr("transform") );
            Assert.areEqual( "Tahoma", text.attr("font-family") );
            Assert.areEqual( "18px", text.attr("font-size") );

        }, 300);
        Lib.__getStage().addEventListener(Event.STAGE_RENDERED, testTextFieldHandler);


    }

}
