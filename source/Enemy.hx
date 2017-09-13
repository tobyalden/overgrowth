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

    public function new(x:Int, y:Int, player:Player) {
        super(x, y);
        this.player = player;
        loadGraphic('assets/images/parasite.png', true, 16, 16);
        animation.add('idle', [0, 1, 2, 3, 4], 10);
        animation.play('idle');
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
        if(isActive) {
            movement();
        }
        else {
            isActive = FlxMath.distanceBetween(this, player) < ACTIVE_RADIUS;
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
