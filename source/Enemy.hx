package;

import flixel.*;
import flixel.util.*;

class Enemy extends FlxSprite
{
    public function new(x:Int, y:Int) {
        super(x, y);
        loadGraphic('assets/images/parasite.png', true, 16, 16);
        animation.add('idle', [0, 1, 2, 3, 4], 10);
        animation.play('idle');
    }
}
