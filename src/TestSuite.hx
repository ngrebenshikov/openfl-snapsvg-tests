import massive.munit.TestSuite;

import flash.display.DisplayObjectTest;
import flash.display.GraphicsTest;
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

		add(flash.display.DisplayObjectTest);
		add(flash.display.GraphicsTest);
		add(flash.LibTest);
	}
}