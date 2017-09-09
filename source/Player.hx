package;

import flixel.*;
import flixel.math.*;
import flixel.util.*;


class Player extends FlxSprite
{
    public static inline var SPEED = 200;
    public static inline var SHOT_COOOLDOWN = 0.25;

    private var shotCooldown:FlxTimer;

    public function new(x:Int, y:Int)
    {
        super(x, y);
        makeGraphic(16, 16, FlxColor.BLUE);
        shotCooldown = new FlxTimer();
        shotCooldown.loops = 1;
    }

    override public function update(elapsed:Float)
    {
        movement();
        shooting();
        super.update(elapsed);
    }

    private function shooting()
    {
        if(FlxG.keys.pressed.X && !shotCooldown.active)
        {
            shotCooldown.reset(SHOT_COOOLDOWN);
            var bulletVelocity = new FlxPoint(Bullet.SPEED, 0);
            var bullet = new Bullet(
                Std.int(x + 8), Std.int(y + 8), bulletVelocity
            );
            FlxG.state.add(bullet);
        }
    }

    private function movement()
    {
        if(FlxG.keys.pressed.UP) {
            velocity.y = -SPEED;
        }
        else if(FlxG.keys.pressed.DOWN) {
            velocity.y = SPEED;
        }
        else {
            velocity.y = 0;
        }

        if(FlxG.keys.pressed.LEFT) {
            velocity.x = -SPEED;
        }
        else if(FlxG.keys.pressed.RIGHT) {
            velocity.x = SPEED;
        }
        else {
            velocity.x = 0;
        }

        if(velocity.x != 0 && velocity.y != 0) {
            velocity.scale(0.707106781);
        }
    }

}
