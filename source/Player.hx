package;

import flixel.*;
import flixel.math.*;
import flixel.util.*;


class Player extends FlxSprite
{
    public static inline var SPEED = 200;
    public static inline var JUMP_POWER = 400;
    public static inline var JUMP_CANCEL_POWER = 100;
    public static inline var GRAVITY = 10;
    public static inline var AIR_ACCEL = 2500;
    public static inline var TERMINAL_VELOCITY = 300;
    public static inline var SHOT_COOOLDOWN = 0.25;

    private var shotCooldown:FlxTimer;
    private var isOnGround:Bool;
    private var isLookingUp:Bool;
    private var isLookingDown:Bool;

    public function new(x:Int, y:Int)
    {
        super(x, y);
        loadGraphic('assets/images/player.png', true, 16, 24);
        setFacingFlip(FlxObject.LEFT, false, false);
        setFacingFlip(FlxObject.RIGHT, true, false);
        animation.add('idle', [0]);
        animation.add('run', [1, 2, 3]);
        animation.add('jump', [4]);
        animation.add('up', [5]);
        animation.add('run_up', [6, 7, 8]);
        animation.add('jump_up', [9]);
        animation.add('jump_down', [10]);
        animation.play('idle');
        shotCooldown = new FlxTimer();
        shotCooldown.loops = 1;
        isOnGround = false;
        isLookingUp = false;
        isLookingDown = false;
    }

    override public function update(elapsed:Float)
    {
        isOnGround = isTouching(FlxObject.DOWN);
        isLookingUp = FlxG.keys.pressed.UP;
        isLookingDown = FlxG.keys.pressed.DOWN;
        move();
        shoot();
        animate();
        super.update(elapsed);
    }

    private function shoot()
    {
        if(FlxG.keys.pressed.X && !shotCooldown.active)
        {
            shotCooldown.reset(SHOT_COOOLDOWN);
            var bulletVelocity = new FlxPoint(0, 0);
            if(!isOnGround && isLookingDown) {
                bulletVelocity.y = Bullet.SPEED;
            }
            else if(isLookingUp) {
                bulletVelocity.y = -Bullet.SPEED;
            }
            else if(facing == FlxObject.LEFT) {
                bulletVelocity.x = -Bullet.SPEED;
            }
            else if(facing == FlxObject.RIGHT) {
                bulletVelocity.x = Bullet.SPEED;
            }
            var bullet = new Bullet(
                Std.int(x + 8), Std.int(y + 8), bulletVelocity
            );
            FlxG.state.add(bullet);
        }
    }

    private function move()
    {
        if(FlxG.keys.pressed.LEFT) {
            if(isOnGround) {
                velocity.x = -SPEED;
            }
            else {
                acceleration.x = -AIR_ACCEL;
            }
            facing = FlxObject.LEFT;
        }
        else if(FlxG.keys.pressed.RIGHT) {
            if(isOnGround) {
                velocity.x = SPEED;
            }
            else {
                acceleration.x = AIR_ACCEL;
            }
            facing = FlxObject.RIGHT;
        }
        else {
            if(isOnGround) {
                velocity.x = 0;
            }
            else {
                acceleration.x = 0;
                drag.x = AIR_ACCEL;
            }
        }

        if(isOnGround) {
            acceleration.x = 0;
        }

        if(FlxG.keys.justPressed.Z && isOnGround) {
            velocity.y = -JUMP_POWER;
        }
        else if(FlxG.keys.justReleased.Z && !isOnGround) {
            velocity.y = Math.max(velocity.y, -JUMP_CANCEL_POWER);
        }

        velocity.x = Math.min(velocity.x, SPEED);
        velocity.x = Math.max(velocity.x, -SPEED);
        velocity.y = Math.min(velocity.y + GRAVITY, TERMINAL_VELOCITY);
    }

    private function animate()
    {
        if(!isOnGround) {
            if (isLookingDown) {
                animation.play('jump_down');
            }
            else if(isLookingUp) {
                animation.play('jump_up');
            }
            else {
                animation.play('jump');
            }
        }
        else if(velocity.x != 0) {
            if(isLookingUp) {
                animation.play('run_up');
            }
            else {
                animation.play('run');
            }
        }
        else {
            if(isLookingUp) {
                animation.play('up');
            }
            else {
                animation.play('idle');
            }
        }
    }

}
