package;

import flixel.*;
import flixel.util.*;

class Fade extends FlxSprite
{

    public static inline var FADE_SPEED = 0.006;

    private var isFadingIn:Bool;
    private var isFadingOut:Bool;

    public function new() {
        super(0, 0);
        loadGraphic('assets/images/fades.png', true, 256, 240);
        animation.add('white', [0]); 
        animation.add('black', [1]); 
        animation.add('red', [2]); 
        animation.play('black');
        isFadingIn = false;
        isFadingOut = false;
    }

    public function fadeIn() {
        isFadingIn = true;
        isFadingOut = false;
    }

    public function fadeOut() {
        isFadingIn = false;
        isFadingOut = true;
    }

    override public function update(elapsed:Float) {
        x = FlxG.camera.scroll.x;
        y = FlxG.camera.scroll.y;
        if(isFadingIn) {
            alpha = Math.max(alpha - FADE_SPEED, 0);
        }
        if(isFadingOut) {
            alpha = Math.min(alpha + FADE_SPEED, 1);
        }
    }
}

