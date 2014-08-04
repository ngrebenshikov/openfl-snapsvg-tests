package flash.filters;


import flash.geom.Point;
import flash.geom.Rectangle;
import js.html.CanvasElement;


class BitmapFilter {
	
	
	private var _mType:String;
	private var ___cached:Bool;
	

	public function new (inType:String) {
		
		_mType = inType;
		
	}
	
	
	public function clone ():BitmapFilter {
		
		return new BitmapFilter (_mType);
		
		//throw "Implement in subclass. BitmapFilter::clone";
		//return null;
		
	}
	
	
	public function __preFilter (surface:CanvasElement) {
		
		
		
	}
	
	
	public function __applyFilter (surface:CanvasElement, rect:Rectangle = null, refreshCache:Bool = false) {
		
		
		
	}
	
	
}