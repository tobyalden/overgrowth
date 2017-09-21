package;

import flixel.*;
import flixel.input.gamepad.*;
import flixel.system.*;
import flixel.tweens.*;
import flixel.util.*;

class StartScreen extends FlxState
{

    private static var startSfx:FlxSound;

    private var isFadingOut:Bool;
    private var fadeInColor:FlxColor;
    private var fade:Fade;
    private var controller:FlxGamepad;

    public function new(fadeInColor:FlxColor) {
        super();
        this.fadeInColor = fadeInColor;
    }

	override public function create():Void
	{
        var title = new FlxSprite(0, 0);
        fade = new Fade();
        fade.alpha = 1;
        if(fadeInColor == FlxColor.WHITE) {
            fade.animation.play('white');
        }
        fade.fadeIn();
        title.loadGraphic('assets/images/title.png', true, 256, 240);
        title.animation.add('idle', [0, 1, 2, 3, 4, 5, 6, 5, 4, 3, 2, 1], 10);
        title.animation.play('idle');
        add(title);
        FlxG.sound.playMusic('assets/music/titleloop.ogg', 0, true);
        FlxG.sound.music.fadeIn();
        startSfx = FlxG.sound.load('assets/sounds/start.ogg');
        isFadingOut = false;
        add(fade);
		super.create();
	}

	override public function update(elapsed:Float):Void {
        controller = FlxG.gamepads.getByID(0);
        if(isFadingOut) {
            super.update(elapsed);
            return;
        }
        var pressedStart = false;
        if(
            controller != null
            && (controller.justPressed.X || controller.justPressed.A)
        ) {
           pressedStart = true; 
        }
        if(
            FlxG.keys.justPressed.Z
            || FlxG.keys.justPressed.X
            || pressedStart
        ) {
            isFadingOut = true;
            startSfx.play();
            fade.animation.play('black');
            fade.fadeOut();
            new FlxTimer().start(2, function(_:FlxTimer) {
                FlxG.switchState(new PlayState(1));
            }, 1);
        }
        super.update(elapsed);
    }
}
