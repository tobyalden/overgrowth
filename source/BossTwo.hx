package;

import flixel.*;
import flixel.group.*;
import flixel.math.*;
import flixel.system.*;
import flixel.util.*;

class BossTwo extends Enemy
{
    public static inline var STARTING_HEALTH = 60;
    public static inline var SPEED = 50;
    public static inline var ACCELERATION = 3000;
    public static inline var SHOT_SPEED = 180;

    public function new(x:Int, y:Int, player:Player) {
        super(x, y, player);
        loadGraphic('assets/images/boss2.png', true, 64, 64);
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
        maxVelocity = new FlxPoint(SPEED, SPEED);
        if(!reelTimer.active) {
            FlxVelocity.moveTowardsObject(
                this, player, SPEED
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
