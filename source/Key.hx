package;

import flixel.*;
import flixel.util.*;

class Key extends FlxSprite
{
    public function new(x:Int, y:Int) {
        super(x, y);
        loadGraphic('assets/images/key.png');
    }
}
