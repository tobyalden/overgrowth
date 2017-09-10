package;

import flixel.*;
import flixel.util.*;

class StartScreen extends FlxState
{
	override public function create():Void
	{
        var title = new FlxSprite(0, 0);
        title.loadGraphic('assets/images/title.png', true, 256, 240);
        title.animation.add('idle', [0, 1, 2, 3, 4, 5, 6, 5, 4, 3, 2, 1], 10);
        title.animation.play('idle');
        add(title);
        FlxG.camera.fade(FlxColor.BLACK, 2, true);
        FlxG.sound.playMusic('assets/music/titleloop.ogg', 0, true);
        FlxG.sound.music.fadeIn();
		super.create();
	}

	override public function update(elapsed:Float):Void {
        if(FlxG.keys.justPressed.Z || FlxG.keys.justPressed.X) {
            FlxG.camera.fade(FlxColor.BLACK, 0.33, false, function()
            {
                FlxG.switchState(new PlayState());
            });
        }
        super.update(elapsed);
    }
}
