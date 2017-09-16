package;

import flixel.*;
import flixel.group.*;
import flixel.math.*;
import flixel.system.*;
import flixel.util.*;

class EnemyBullet extends FlxSprite
{
    
    public static inline var SPEED = 600;
    public static inline var GRAVITY = 3;
    private var hitSfx:FlxSound;
    private var player:Player;

    public static var all:FlxGroup = new FlxGroup();

    public function new(x:Int, y:Int, velocity:FlxPoint, player:Player)
    {
        super(x - 2, y - 2);
        this.velocity = velocity;
        this.player = player;
        makeGraphic(4, 4, FlxColor.WHITE);
        all.add(this);
        hitSfx = FlxG.sound.load('assets/sounds/hit.wav');
        hitSfx.volume = 0.33;
    }

    override public function update(elapsed:Float)
    {
        velocity.y += GRAVITY;
        super.update(elapsed);
    }

    override public function destroy()
    {
        FlxG.state.add(new Explosion(this));
        if (
            Math.floor(x/FlxG.width) == Math.floor(player.x/FlxG.width)
            && Math.floor(y/FlxG.height) == Math.floor(player.y/FlxG.height)
        ) {
            hitSfx.play(true);
        }
        all.remove(this);
        super.destroy();
    }
}
