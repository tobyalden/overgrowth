package;

import flixel.*;
import flixel.group.*;
import flixel.math.*;
import flixel.util.*;

class Swinger extends Enemy
{
    public static inline var STARTING_HEALTH = 2;
    public static inline var ACCELERATION = 5000;
    public static inline var SPEED = 40;

    public function new(x:Int, y:Int, player:Player) {
        super(x, y, player);
        loadGraphic('assets/images/swinger.png', true, 16, 16);
        animation.add('idle', [0, 1, 2, 3, 4], 10);
        health = STARTING_HEALTH;
        animation.play('idle');
    }

    override public function movement()
    {
        if(acceleration.x == 0 || acceleration.y == 0) {
            var flip = [1, -1];
            acceleration.x = SPEED * flip[Math.floor(Math.random() * 2)];
            acceleration.y = SPEED * flip[Math.floor(Math.random() * 2)];
        }
        if(!reelTimer.active) {
            if(isTouching(FlxObject.UP) || isTouching(FlxObject.DOWN)) {
                acceleration.y = -acceleration.y;
            }
            if(isTouching(FlxObject.LEFT) || isTouching(FlxObject.RIGHT)) {
                acceleration.x = -acceleration.x;
            }
        }
    }
}
