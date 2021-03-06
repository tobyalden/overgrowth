package;

import flixel.*;
import flixel.group.*;
import flixel.math.*;
import flixel.util.*;

class Ghost extends Enemy
{
    public static inline var STARTING_HEALTH = 4;
    public static inline var ACCELERATION = 5;
    public static inline var SPEED = 25;

    static public var ghosts:FlxGroup = new FlxGroup();

    public function new(x:Int, y:Int, player:Player) {
        super(x, y, player);
        loadGraphic('assets/images/ghost.png', true, 16, 16);
        animation.add('idle', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9], 10);
        health = STARTING_HEALTH;
        animation.play('idle');
        Enemy.all.remove(this);
        ghosts.add(this);
    }

    override public function movement()
    {
        maxVelocity = new FlxPoint(SPEED, SPEED);
        if(!reelTimer.active) {
            if(x > player.x) {
                acceleration.x = -ACCELERATION;
            }
            else if(x < player.x) {
                acceleration.x = ACCELERATION;
            }
            if(y > player.y) {
                acceleration.y = -ACCELERATION;
            }
            else if(y < player.y) {
                acceleration.y = ACCELERATION;
            }
        }
    }
}
