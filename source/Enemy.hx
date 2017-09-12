package;

import flixel.*;
import flixel.group.*;
import flixel.math.*;
import flixel.util.*;

class Enemy extends FlxSprite
{
    public static inline var ACTIVE_RADIUS = 140;
    public static inline var SPEED = 40;

    static public var all:FlxGroup = new FlxGroup();

    private var isActive:Bool;
    private var player:Player;

    public function new(x:Int, y:Int, player:Player) {
        super(x, y);
        this.player = player;
        loadGraphic('assets/images/parasite.png', true, 16, 16);
        animation.add('idle', [0, 1, 2, 3, 4], 10);
        animation.play('idle');
        isActive = false;
        all.add(this);
    }

    override public function update(elapsed:Float)
    {
        if(isActive) {
            FlxVelocity.moveTowardsObject(this, player, SPEED);
            //FlxMath.accelerateTowardsObject(
                //this, player, ACCELERATION, MAX_SPEED
            //);
        }
        else {
            isActive = FlxMath.distanceBetween(this, player) < ACTIVE_RADIUS;
            velocity.x = 0;
            velocity.y = 0;
        }
        super.update(elapsed);
    }

}
