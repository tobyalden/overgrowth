package;

import flixel.*;
import flixel.group.*;
import flixel.math.*;
import flixel.util.*;

class Parasite extends Enemy
{
    public static inline var STARTING_HEALTH = 2;
    public static inline var ACCELERATION = 5000;
    public static inline var SPEED = 40;

    public function new(x:Int, y:Int, player:Player) {
        super(x, y, player);
        loadGraphic('assets/images/parasite.png', true, 16, 16);
        animation.add('idle', [0, 1, 2, 3, 4], 10);
        health = STARTING_HEALTH;
        animation.play('idle');
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
