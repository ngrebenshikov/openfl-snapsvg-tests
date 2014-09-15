package openfl.display;

import openfl.events.KeyboardEvent;
import js.Browser;
import openfl.utils.Timer;
import openfl.ui.Keyboard;
import js.html.svg.TextElement;
import flash.text.TextFieldType;
import flash.text.TextFieldAutoSize;
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

//    @Before
//    public function setup():Void {
//        Lib.current.removeChildren();
//    }
//
//    @After
//    public function tearDown():Void {
//        Lib.current.removeChildren();
//    }
//
//    @AsyncTest
//    public function testSetText(asyncFactory: AsyncFactory) {
//        tf = new TextField();
//
//        var format = new TextFormat();
//        format.size = 18;
//        format.font = "Tahoma";
//        Lib.current.addChild(tf);
//
//        tf.background = true;
//        tf.backgroundColor = 0xFFE100;
//        tf.x = 20;
//        tf.y = 100;
//        tf.width = 400;
//        tf.height = 20;
//        tf.wordWrap = true;
//        tf.autoSize = Std.string(TextFieldAutoSize.LEFT);
//        tf.textColor = 0x45ad00;
//        tf.defaultTextFormat = format;
//        tf.text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit.\nCras quis arcu cursus, tincidunt ligula eget, semper\ndiam. Nulla sodales diam ut sapien dictum blandit.";
//
//        testTextFieldHandler = asyncFactory.createHandler(this, function() {
//            Assert.isTrue(tf.snap.parent() != null);
//            Assert.isTrue(tf.snap.parent().node == Lib.current.snap.node);
//            var text = tf.snap.select("text");
//            var textElement: TextElement = text.node;
//            Assert.isTrue( text != null );
//            Assert.areEqual( "t20,100", tf.snap.attr("transform") );
//            Assert.areEqual( "Tahoma", text.attr("font-family") );
//            Assert.areEqual( "18px", textElement.getAttribute("font-size") );
//        }, 300);
//        Lib.__getStage().addEventListener(Event.STAGE_RENDERED, testTextFieldHandler);
//    }
//
//    @AsyncTest
//    public function testSetTextFormat(asyncFactory: AsyncFactory) {
//        tf = new TextField();
//
//        var format = new TextFormat();
//        format.size = 18;
//        format.font = "Tahoma";
//        Lib.current.addChild(tf);
//
//        tf.background = true;
//        tf.backgroundColor = 0xFFE100;
//        tf.x = 20;
//        tf.y = 100;
//        tf.width = 400;
//        tf.height = 20;
//        tf.wordWrap = true;
//        tf.autoSize = TextFieldAutoSize.LEFT;
//        tf.textColor = 0x45ad00;
//        tf.defaultTextFormat = format;
//        tf.text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit.\nCras quis arcu cursus, tincidunt ligula eget, semper\ndiam. Nulla sodales diam ut sapien dictum blandit.";
//        tf.setTextFormat(new TextFormat('Arial', 30, 0xff00ff, true, true, true), 30, 40);
//        tf.setTextFormat(new TextFormat('Times', 40, 0x0000ff, false, true, true), 35, 50);
//
//        testTextFieldHandler = asyncFactory.createHandler(this, function() {
//            Assert.isTrue(tf.snap.parent() != null);
//            Assert.isTrue(tf.snap.parent().node == Lib.current.snap.node);
//            var text = tf.snap.select("text");
//            var textElement: TextElement = text.node;
//            Assert.isTrue( text != null );
//            Assert.areEqual( "t20,100", tf.snap.attr("transform") );
//            Assert.areEqual( "Tahoma", text.attr("font-family") );
//            Assert.areEqual( "18px", textElement.getAttribute("font-size") );
//
//        }, 300);
//        Lib.__getStage().addEventListener(Event.STAGE_RENDERED, testTextFieldHandler);
//    }
//
//    @AsyncTest
//    public function testInputMode(asyncFactory: AsyncFactory) {
//        tf = new TextField();
//        tf.background = true;
//        tf.backgroundColor = 0xcccccc;
//        tf.x = 20;
//        tf.y = 100;
//        tf.width = 400;
//        tf.height = 20;
//        tf.textColor = 0x45ad00;
//        tf.type = TextFieldType.INPUT;
//
//        Lib.current.addChild(tf);
//
//        tf.stage.focus = tf;
//
//        var dispatchEvent = function(type: String, char: String, code: Int) {
//            var charCode = if (null != char) char.charCodeAt(0) else 0;
//            var e = new KeyboardEvent (type, true, false, charCode, code, code, false, false, false);
//            untyped tf.__fireEvent (e);
//        };
//
//        testTextFieldHandler = function(e) {
//            Lib.__getStage().removeEventListener(Event.STAGE_RENDERED, testTextFieldHandler);
//
//            dispatchEvent(KeyboardEvent.KEY_PRESS, 'a', Keyboard.A);
//            dispatchEvent(KeyboardEvent.KEY_PRESS, 'b', Keyboard.B);
//            dispatchEvent(KeyboardEvent.KEY_PRESS, 'c', Keyboard.C);
//            dispatchEvent(KeyboardEvent.KEY_PRESS, 'd', Keyboard.D);
//            dispatchEvent(KeyboardEvent.KEY_PRESS, 'e', Keyboard.E);
//            dispatchEvent(KeyboardEvent.KEY_DOWN, null, Keyboard.LEFT);
//            dispatchEvent(KeyboardEvent.KEY_DOWN, null, Keyboard.LEFT);
//            dispatchEvent(KeyboardEvent.KEY_PRESS, 'f', Keyboard.F);
//            dispatchEvent(KeyboardEvent.KEY_DOWN, null, Keyboard.RIGHT);
//            dispatchEvent(KeyboardEvent.KEY_PRESS, 'g', Keyboard.G);
//            dispatchEvent(KeyboardEvent.KEY_DOWN, null, Keyboard.LEFT);
//            dispatchEvent(KeyboardEvent.KEY_DOWN, null, Keyboard.LEFT);
//            dispatchEvent(KeyboardEvent.KEY_DOWN, null, Keyboard.LEFT);
//            dispatchEvent(KeyboardEvent.KEY_DOWN, null, Keyboard.BACKSPACE);
//            dispatchEvent(KeyboardEvent.KEY_DOWN, null, Keyboard.LEFT);
//            dispatchEvent(KeyboardEvent.KEY_DOWN, null, Keyboard.DELETE);
//        };
//
//        Lib.__getStage().addEventListener(Event.STAGE_RENDERED, testTextFieldHandler);
//
//        haxe.Timer.delay(asyncFactory.createHandler(this, function() {
//            Assert.areEqual('afdge', tf.text);
//        }, 2000),
//        1000);
//
//    }


    @Test
    public function testSetSelection(asyncFactory: AsyncFactory) {
        tf = new TextField();
        tf.background = true;
        tf.backgroundColor = 0xcccccc;
        tf.x = 20;
        tf.y = 100;
        tf.width = 400;
        tf.height = 20;
        tf.wordWrap = true;
        tf.autoSize = Std.string(TextFieldAutoSize.LEFT);
        tf.textColor = 0x45ad00;
        tf.type = TextFieldType.INPUT;

        Lib.current.addChild(tf);

        tf.text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit.\nCras quis arcu cursus, tincidunt ligula eget, semper\ndiam. Nulla sodales diam ut sapien dictum blandit.";
        tf.setTextFormat(new TextFormat('Arial', 30, 0xff00ff, true, true, true), 30, 40);
        tf.setTextFormat(new TextFormat('Times', 40, 0x0000ff, false, true, true), 35, 50);
        tf.setSelection(10,25);

        Assert.areEqual(10, tf.selectionBeginIndex);
        Assert.areEqual(25, tf.selectionEndIndex);
    }

}
