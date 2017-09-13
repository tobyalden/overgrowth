package;

import flixel.*;
import flixel.group.*;
import flixel.math.*;
import flixel.util.*;

class Parasite extends Enemy
{
    public static inline var ACCELERATION = 5000;
    public static inline var SPEED = 40;

    public function new(x:Int, y:Int, player:Player) {
        super(x, y, player);
    }

    override public function movement()
    {
        if(!reelTimer.active) {
            FlxVelocity.accelerateTowardsObject(
                this, player, ACCELERATION, SPEED
            );
        }
    }
}
