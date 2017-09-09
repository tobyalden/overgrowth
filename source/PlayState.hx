package;

import flixel.*;
import flixel.tile.*;
import flixel.util.*;

class PlayState extends FlxState
{
    private var player:Player;
    private var map:FlxTilemap;

	override public function create():Void
	{
        FlxG.state.bgColor = FlxColor.GRAY;
        player = new Player(20, 20);
        add(player);
        map = new FlxTilemap();
        var rand = Math.floor(Math.random() * 12);
        var mapPath = 'assets/data/maps/' + rand + '.png';
        map.loadMapFromGraphic(
            mapPath, false, 1, 'assets/images/tiles.png'
        );
        add(map);
		super.create();
	}

	override public function update(elapsed:Float):Void
	{
        FlxG.collide(player, map);
        for (bullet in Bullet.all) {
            if(map.overlaps(bullet)) {
                bullet.destroy();
            }
        }
		super.update(elapsed);
	}

    private function destroyBullet(bullet:FlxObject, _:FlxObject) {
        cast(bullet, Bullet).destroy();
        return true;
    }

}
