package;

import flixel.*;
import flixel.group.*;
import flixel.math.*;
import flixel.system.*;
import flixel.util.*;

class Enemy extends FlxSprite
{
    public static inline var ACTIVE_RADIUS = 140;
    public static inline var STARTING_HEALTH = 4;

    static public var all:FlxGroup = new FlxGroup();

    public var isActive:Bool;
    private var reelTimer:FlxTimer;
    private var player:Player;
    private var hurtSfx:FlxSound;
    private var deathSfx:FlxSound;

    private var startX:Int;
    private var startY:Int;

    static public function getRandomEnemy(
        x:Int, y:Int, player:Player, depth:Int, isForBigMap:Bool
    ):Enemy {
        var rand = Math.ceil(Math.random() * (depth + 2));
        if(rand == 1) {
            return new Parasite(x, y, player);
        }
        if(rand == 2) {
            return new Jumper(x, y, player);
        }
        if(rand == 3) {
            return new Seer(x, y, player);
        }
        if(rand == 4) {
            return new Swinger(x, y, player);
        }
        if(rand == 5) {
            return new Bouncer(x, y, player);
        }
        if(rand == 6) {
            return new Seeker(x, y, player);
        }
        if(rand == 7) {
            return new Flopper(x, y, player);
        }
        if(rand == 8) {
            return new Fleer(x, y, player);
        }
        if(rand == 9) {
            return new Leaper(x, y, player);
        }
        if(!isForBigMap && rand == 10) {
            return new Ghost(x, y, player);
        }
        if(rand == 11) {
            return new Predator(x, y, player);
        }
        return new Parasite(x, y, player);
    }

    public function new(x:Int, y:Int, player:Player) {
        super(x, y);
        startX = x;
        startY = y;
        this.player = player;
        isActive = false;
        all.add(this);
        health = STARTING_HEALTH;
        reelTimer = new FlxTimer();
        reelTimer.loops = 1;
        hurtSfx = FlxG.sound.load('assets/sounds/enemyhit.wav');
        deathSfx = FlxG.sound.load('assets/sounds/enemydeath.wav');
    }

    override public function update(elapsed:Float)
    {
        if(health <= 0) {
            kill();
        }
        if(
            isActive 
            && !FlxG.overlap(this, PlayState.currentMap)
            && !(
                Math.floor(startX/FlxG.width) == Math.floor(player.x/FlxG.width)
                && Math.floor(startY/FlxG.height) == Math.floor(player.y/FlxG.height)
            )
        ) {
            isActive = false;
            x = startX;
            y = startY;
        }
        if(isActive) {
            movement();
        }
        else {
            isActive = (
                FlxG.overlap(this, PlayState.currentMap)
                && FlxMath.distanceBetween(this, player) < ACTIVE_RADIUS
            );
            velocity.x = 0;
            velocity.y = 0;
        }
        super.update(elapsed);
    }

    public function movement() { }

    public function takeHit(bullet:FlxObject) {
        isActive = true;
        hurtSfx.play();
        health -= 1;
        reelTimer.start(0.2);
        velocity.x = bullet.velocity.x * 3;
        velocity.y = bullet.velocity.y * 3;
        acceleration.x = bullet.acceleration.x * 3;
        acceleration.y = bullet.acceleration.y * 3;
    }


    override public function kill() {
        FlxG.state.add(new Explosion(this));
        deathSfx.play();
        super.kill();
    }

}
