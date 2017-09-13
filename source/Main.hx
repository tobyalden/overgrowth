package;

import flixel.*;
import openfl.display.Sprite;

class Main extends Sprite
{
	public function new()
	{
		super();
		addChild(new FlxGame(0, 0, StartScreen, 1, 60, 60, true));
        FlxG.mouse.visible = false;
        FlxG.debugger.visible = true;
        FlxG.debugger.drawDebug = true;
	}
}
