package;

import flixel.*;
import flixel.util.*;

class Bullet extends FlxSprite
{
    
    public static inline var SPEED = 400;

    public function new(x:Int, y:Int)
    {
        super(x - 2, y - 2);
        makeGraphic(4, 4, FlxColor.WHITE);
    }

    override public function update(elapsed:Float)
    {
        movement();
        super.update(elapsed);
    }

    private function movement()
    {
       velocity.y = -SPEED;
    }
}
