package;

import flixel.*;
import flixel.group.*;
import flixel.math.*;
import flixel.util.*;

class Boss extends Enemy
{
    public static inline var STARTING_HEALTH = 100;
    public static inline var SPEED = 40;
    public static inline var ACCELERATION = 5000;

    public function new(x:Int, y:Int, player:Player) {
        super(x, y, player);
        loadGraphic('assets/images/boss.png', true, 64, 64);
        animation.add('idle', [
            //0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15
            0, 1, 2, 3
        ], 10);
        health = STARTING_HEALTH;
        animation.play('idle');
        width = 32;
        height = 32;
        offset.x = 16;
        offset.y = 16;
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
