package;

import flixel.*;
import flixel.util.*;

class Tutorial extends FlxSprite
{
    public function new(x:Int, y:Int) {
        super(x, y);
        loadGraphic('assets/images/tutorial.png', true, 256, 240);
        animation.add('idle', [
            0, 1, 2, 3, 4, 3, 2, 1, 0, 0, 0, 0,
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
        ], 10);
        animation.play('idle');
    }
}
