package;

import flixel.*;
import flixel.math.*;
import flixel.util.*;

class Bullet extends FlxSprite
{
    
    public static inline var SPEED = 400;

    public function new(x:Int, y:Int, velocity:FlxPoint)
    {
        super(x - 2, y - 2);
        this.velocity = velocity;
        makeGraphic(4, 4, FlxColor.WHITE);
    }

    override public function update(elapsed:Float)
    {
        super.update(elapsed);
    }
}
