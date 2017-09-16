package;

import flixel.*;
import flixel.group.*;
import flixel.math.*;
import flixel.system.*;
import flixel.util.*;

class Boss extends Enemy
{
    //public static inline var STARTING_HEALTH = 30;
    public static inline var STARTING_HEALTH = 1;
    public static inline var SPEED = 40;
    public static inline var ACCELERATION = 5000;
    public static inline var SHOT_SPEED = 180;

    public static var theBoss:Boss;

    private var shootTimer:FlxTimer;
    private var shootSfx:FlxSound;
    private var humSfx:FlxSound;

    public function new(x:Int, y:Int, player:Player) {
        super(x, y, player);
        theBoss = this;
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
        shootTimer = new FlxTimer();
        shootTimer.start(0.8, shoot, 0);
        shootSfx = FlxG.sound.load('assets/sounds/enemyshoot.wav');
        shootSfx.volume = 0.24;
        humSfx = FlxG.sound.load('assets/sounds/bossone.wav');
        humSfx.looped = true;
        humSfx.play();
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
        BossTwo.theBoss.isActive = true;
        if(health == 0) {
            shootTimer.cancel();
        }
        super.takeHit(bullet);
    }

    override public function kill() {
        humSfx.stop();
        super.kill();
    }

    public function shoot(_:FlxTimer) {
        if(!isActive) {
            return;
        }
        var angle = FlxAngle.angleBetween(this, player, true);
        var bulletVelocity = FlxVelocity.velocityFromAngle(angle, SHOT_SPEED);
        bulletVelocity.x += velocity.x;
        bulletVelocity.y += velocity.y;
        var bullet = new BossBullet(
            Std.int(x + 16), Std.int(y + 16), bulletVelocity, player
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
