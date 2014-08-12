import massive.munit.TestSuite;

import flash.display.ColorTest;
import flash.display.DisplayObjectTest;
import flash.display.GraphicsTest;
import flash.display.TextFieldTest;
import flash.FiltersTest;
import flash.LibTest;

/**
 * Auto generated Test Suite for MassiveUnit.
 * Refer to munit command line tool for more information (haxelib run munit)
 */

class TestSuite extends massive.munit.TestSuite
{		

	public function new()
	{
		super();

		add(flash.display.ColorTest);
		add(flash.display.DisplayObjectTest);
		add(flash.display.GraphicsTest);
		add(flash.display.TextFieldTest);
		add(flash.FiltersTest);
		add(flash.LibTest);
	}
}
