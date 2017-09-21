package;

import flixel.*;
import flixel.system.*;
import flixel.util.*;

class Key extends FlxSprite
{
    private var unlockSfx:FlxSound;

    public function new(x:Int, y:Int) {
        super(x, y);
        loadGraphic('assets/images/key.png');
        unlockSfx = FlxG.sound.load('assets/sounds/open.ogg');
    }

    override public function destroy()
    {
        unlockSfx.play(true);
        super.destroy();
    }
}
