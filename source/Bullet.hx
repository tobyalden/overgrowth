package;

import flixel.*;
import flixel.group.*;
import flixel.math.*;
import flixel.system.*;
import flixel.util.*;

class Bullet extends FlxSprite
{
    
    public static inline var SPEED = 600;
    public static inline var GRAVITY = 3;
    private var hitSfx:FlxSound;

    public static var all:FlxGroup = new FlxGroup();

    public function new(x:Int, y:Int, velocity:FlxPoint)
    {
        super(x - 2, y - 2);
        this.velocity = velocity;
        makeGraphic(4, 4, FlxColor.WHITE);
        all.add(this);
        hitSfx = FlxG.sound.load('assets/sounds/hit.mp3');
        hitSfx.volume = 0.33;
        new FlxTimer().start(10, function(_:FlxTimer) {
            hitSfx.volume = 0;
            destroy(); 
        }, 1);
    }

    override public function update(elapsed:Float)
    {
        velocity.y += GRAVITY;
        super.update(elapsed);
    }

    override public function destroy()
    {
        FlxG.state.add(new Explosion(this));
        hitSfx.play(true);
        all.remove(this);
        super.destroy();
    }
}
