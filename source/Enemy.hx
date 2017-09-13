package;

import flixel.*;
import flixel.group.*;
import flixel.math.*;
import flixel.util.*;

class Enemy extends FlxSprite
{
    public static inline var ACTIVE_RADIUS = 140;
    public static inline var STARTING_HEALTH = 4;

    static public var all:FlxGroup = new FlxGroup();

    private var isActive:Bool;
    private var reelTimer:FlxTimer;
    private var player:Player;

    private var startX:Int;
    private var startY:Int;

    static public function getRandomEnemy(x:Int, y:Int, player:Player):Enemy {
        var rand = Math.floor(Math.random() * 2);
        if(rand == 1) {
            return new Jumper(x, y, player);
        }
        return new Parasite(x, y, player);
    }

    public function new(x:Int, y:Int, player:Player) {
        super(x, y);
        startX = x;
        startY = x;
        this.player = player;
        isActive = false;
        all.add(this);
        health = STARTING_HEALTH;
        reelTimer = new FlxTimer();
        reelTimer.loops = 1;
    }

    override public function update(elapsed:Float)
    {
        if(health <= 0) {
            kill();
        }
        if(isActive && !FlxG.overlap(this, PlayState.currentMap)) {
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
        health -= 1;
        reelTimer.start(0.2);
    }


    override public function kill() {
        FlxG.state.add(new Explosion(this));
        super.kill();
    }

}
