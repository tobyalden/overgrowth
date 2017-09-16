package;

import flixel.*;
import flixel.group.*;
import flixel.math.*;
import flixel.system.*;
import flixel.util.*;

class Fleer extends Enemy
{
    public static inline var STARTING_HEALTH = 2;
    public static inline var SHOT_SPEED = 60;

    public static inline var ACCELERATION = 60;
    public static inline var SPEED = 40;

    private var myFacing:String;
    private var shootTimer:FlxTimer;
    private var shootSfx:FlxSound;

    public function new(x:Int, y:Int, player:Player) {
        super(x, y, player);
        loadGraphic('assets/images/fleer.png', true, 16, 16);
        animation.add('right', [0]);
        animation.add('down', [1]);
        animation.add('left', [2]);
        animation.add('up', [3]);
        myFacing = 'right';
        animation.play(myFacing);
        health = STARTING_HEALTH;
        shootTimer = new FlxTimer();
        shootTimer.start(0.6, shoot, 0);
        shootSfx = FlxG.sound.load('assets/sounds/enemyshoot.wav');
        shootSfx.volume = 0.24;
    }

    override public function movement() {
        maxVelocity = new FlxPoint(SPEED, SPEED);
        if(!reelTimer.active) {
            if(x > player.x) {
                acceleration.x = ACCELERATION;
            }
            else if(x < player.x) {
                acceleration.x = -ACCELERATION;
            }
            if(y > player.y) {
                acceleration.y = ACCELERATION;
            }
            else if(y < player.y) {
                acceleration.y = -ACCELERATION;
            }
        }
        animation.play(myFacing);
    }

    override public function takeHit(bullet:FlxObject) {
        hurtSfx.play();
        health -= 1;
        if(health == 0) {
            shootTimer.cancel();
        }
    }

    public function shoot(_:FlxTimer) {
        if(!isActive) {
            return;
        }
        var bulletVelocity = new FlxPoint(0, 0);
        if(!reelTimer.active) {
            if(
                FlxAngle.angleBetween(this, player, true) < -120
                || FlxAngle.angleBetween(this, player, true) > 120
            ) {
                myFacing = 'left';
                bulletVelocity.x = -SHOT_SPEED;
            }
            else if(FlxAngle.angleBetween(this, player, true) < -60) {
                myFacing = 'up';
                bulletVelocity.y = -SHOT_SPEED;
            }
            else if(FlxAngle.angleBetween(this, player, true) < 60) {
                myFacing = 'right';
                bulletVelocity.x = SHOT_SPEED;
            }
            else if(FlxAngle.angleBetween(this, player, true) < 120) {
                myFacing = 'down';
                bulletVelocity.y = SHOT_SPEED;
            }
        }
        var bullet = new EnemyBullet(
            Std.int(x + 8), Std.int(y + 8), bulletVelocity, player
        );
        FlxG.state.add(bullet);
        if (
            Math.floor(x/FlxG.width) == Math.floor(player.x/FlxG.width)
            && Math.floor(y/FlxG.height) == Math.floor(player.y/FlxG.height)
        ) {
            shootSfx.play();
        }
    }

}
