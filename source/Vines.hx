package;

import flixel.*;
import flixel.util.*;

class Vines extends FlxSprite
{
    public function new(x:Int, y:Int) {
        super(x, y);
        loadGraphic('assets/images/vines.png', true, 16, 32);
        for (i in 1...20) {
            animation.add(Std.string(i), [i]); 
        }
        var randFrame = Std.string(Math.ceil(Math.random() * 20));
        animation.play(randFrame);
    }
}

