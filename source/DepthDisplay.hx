package;

import flixel.*;
import flixel.util.*;

class DepthDisplay extends FlxSprite
{
    public function new(x:Int, y:Int, depth:Int) {
        super(x, y);
        loadGraphic('assets/images/depthdisplay.png', true, 256, 240);
        for (i in 1...11) {
            animation.add(Std.string(i), [i-1]); 
        }
        animation.play(Std.string(depth));
    }

	override public function update(elapsed:Float):Void {
        alpha = Math.max(alpha - 0.005, 0);
    }
}

