package;

import flixel.*;
import flixel.group.*;
import flixel.math.*;
import flixel.util.*;

class Flopper extends Enemy
{
    public static inline var JUMP_POWER_X = 60;
    public static inline var JUMP_POWER_Y = 160;
    public static inline var STARTING_HEALTH = 4;
    private var jumpTimer:FlxTimer;
    private var isOnGround:Bool;

    public function new(x:Int, y:Int, player:Player) {
        super(x, y, player);
        loadGraphic('assets/images/flopper.png', true, 16, 16);
        animation.add('idle', [0]);
        animation.add('jump', [1, 2], 1, false);
        animation.play('idle');
        jumpTimer = new FlxTimer();
        jumpTimer.start(2, jump, 0);
        isOnGround = false;
        health = STARTING_HEALTH;
    }

    override public function update(elapsed:Float)
    {
        isOnGround = isTouching(FlxObject.UP);
        if(isOnGround) {
            velocity.x = 0;
            velocity.y = 0;
        }
        else {
            velocity.y -= Player.GRAVITY/3;
        }
        super.update(elapsed);
    }

    private function jump(_:FlxTimer) {
        y += 1;
        velocity.y = JUMP_POWER_Y;
        if (x < player.x) {
            velocity.x = JUMP_POWER_X;
        }
        else {
            velocity.x = -JUMP_POWER_X;
        }
        animation.play('jump');
    }
}

