package flash.display;


import flash.display.Graphics;
import flash.display.InteractiveObject;
import flash.geom.Matrix;
import flash.geom.Point;
import flash.Lib;


class Shape extends DisplayObject {
	
	
	public var graphics (get_graphics, never):Graphics;
	
	private var __graphics:Graphics;
	
	
	public function new () {
		
		super ();
		
		__graphics = new Graphics ();
		
	}
	
	
	override public function toString ():String {
		
		return "[Shape name=" + this.name + " id=" + ___id + "]";
		
	}
	
	
	public override function __getGraphics ():Graphics {
		
		return __graphics;
		
	}
	
	
	override public function __getObjectUnderPoint (point:Point):DisplayObject {
		
		if (parent == null) return null;
		
		if (parent.mouseEnabled && super.__getObjectUnderPoint (point) == this) {
			
			return parent;
			
		} else {
			
			return null;
			
		}
		
	}
	
	
	
	
	// Getters & Setters
	
	
	
	
	private function get_graphics ():Graphics {
		
		return __graphics;
		
	}
	
	
}