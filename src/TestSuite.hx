import massive.munit.TestSuite;

import openfl.display.ColorTest;
import openfl.display.DisplayObjectTest;
import openfl.display.GraphicsTest;
import openfl.display.TextFieldTest;
import openfl.FiltersTest;
import openfl.LibTest;
import StringTest;

/**
 * Auto generated Test Suite for MassiveUnit.
 * Refer to munit command line tool for more information (haxelib run munit)
 */

class TestSuite extends massive.munit.TestSuite
{		

	public function new()
	{
		super();

		add(openfl.display.ColorTest);
		add(openfl.display.DisplayObjectTest);
		add(openfl.display.GraphicsTest);
		add(openfl.display.TextFieldTest);
		add(openfl.FiltersTest);
		add(openfl.LibTest);
		add(StringTest);
	}
}
