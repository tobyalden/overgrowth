package;

import flixel.*;
import flixel.group.*;
import flixel.math.*;
import flixel.util.*;

class Bullet extends FlxSprite
{
    
    public static inline var SPEED = 400;

    public static var all:FlxGroup = new FlxGroup();

    public function new(x:Int, y:Int, velocity:FlxPoint)
    {
        super(x - 2, y - 2);
        this.velocity = velocity;
        makeGraphic(4, 4, FlxColor.WHITE);
        all.add(this);
    }

    override public function update(elapsed:Float)
    {
        super.update(elapsed);
    }

    override public function destroy()
    {
        all.remove(this);
        super.destroy();
    }
}
