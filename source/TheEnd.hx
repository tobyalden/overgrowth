package;

import flixel.*;
import flixel.system.*;
import flixel.util.*;

class TheEnd extends FlxState
{
    private static var shockSfx:FlxSound;
    private static var startSfx:FlxSound;

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
        shockSfx = FlxG.sound.load('assets/sounds/shock.ogg');
        startSfx = FlxG.sound.load('assets/sounds/endstart.ogg');
        new FlxTimer().start(5, shock, 1);
        startSfx.play();
		super.create();
	}

    private function shock(_:FlxTimer) {
        title.animation.play('shock');
        shockSfx.play();
        new FlxTimer().start(10,
            function fadeToStart(_:FlxTimer) {
                new FlxTimer().start(10, function(_:FlxTimer) {
                    FlxG.switchState(new StartScreen(FlxColor.WHITE));
                }, 1);
            }
        , 1);
    }

	override public function update(elapsed:Float):Void {
        super.update(elapsed);
    }
}
