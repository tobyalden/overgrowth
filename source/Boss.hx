package;

import flixel.*;
import flixel.group.*;
import flixel.math.*;
import flixel.util.*;

class Boss extends Enemy
{
    public static inline var STARTING_HEALTH = 60;
    public static inline var SPEED = 40;
    public static inline var ACCELERATION = 5000;

    public function new(x:Int, y:Int, player:Player) {
        super(x, y, player);
        loadGraphic('assets/images/boss.png', true, 64, 64);
        animation.add('idle', [
            //0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15
            0, 1, 2, 3
        ], 10);
        animation.add('hurt', [
            15, 14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0
        ], 60, false);
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
        if(animation.name == 'hurt' && animation.finished) {
            animation.play('idle');
        }
    }

    override public function takeHit(bullet:FlxObject) {
        animation.play('hurt');
        super.takeHit(bullet);
    }
}
