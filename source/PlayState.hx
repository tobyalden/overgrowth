package;

import flixel.*;

class PlayState extends FlxState
{
    private var player:Player;

	override public function create():Void
	{
        player = new Player(20, 20);
        add(player);
        FlxG.sound.playMusic('assets/music/whitenoise.ogg', 0.1);
		super.create();
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}
}
