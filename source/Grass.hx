package;

import flixel.*;
import flixel.util.*;

class Grass extends FlxSprite
{
    public function new(x:Int, y:Int) {
        super(x, y);
        loadGraphic('assets/images/grass.png', true, 16, 32);
        for (i in 1...10) {
            animation.add(Std.string(i), [i]); 
        }
        var randFrame = Std.string(Math.ceil(Math.random() * 10));
        animation.play(randFrame);
    }
}
