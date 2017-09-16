package;

import flixel.*;
import flixel.system.*;
import flixel.util.*;

class TheEnd extends FlxState
{
    private static var shockSfx:FlxSound;

    //private var isFadingOut:Bool;
    private var fadeInColor:FlxColor;
    private var title:FlxSprite;

    public function new(fadeInColor:FlxColor) {
        super();
        this.fadeInColor = fadeInColor;
    }

	override public function create():Void
	{
        title = new FlxSprite(0, 0);
        title.loadGraphic('assets/images/end.png', true, 256, 240);
        title.animation.add('idle', [0]);
        title.animation.add('shock', [1]);
        title.animation.play('idle');
        add(title);
        FlxG.camera.fade(fadeInColor, 1, true);
        //FlxG.sound.playMusic('assets/music/titleloop.ogg', 0, true);
        //FlxG.sound.music.fadeIn();
        shockSfx = FlxG.sound.load('assets/sounds/shock.wav');
        //isFadingOut = false;
        new FlxTimer().start(5, shock, 1);
		super.create();
	}

    private function shock(_:FlxTimer) {
        title.animation.play('shock');
        shockSfx.play();
        new FlxTimer().start(10,
            function fadeToStart(_:FlxTimer) {
                FlxG.camera.fade(FlxColor.WHITE, 10, false, function()
                {
                    FlxG.switchState(new StartScreen(FlxColor.WHITE));
                }, true);
            }
        , 1);
    }

	override public function update(elapsed:Float):Void {
        super.update(elapsed);
    }
}
