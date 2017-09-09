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
        player = new Player(100, 100);
        add(player);
        map = new FlxTilemap();
        var rand = Math.floor(Math.random() * 12);
        var mapPath = 'assets/data/maps/' + rand + '.png';
        mapPath = 'assets/data/maps/big.png';
        map.loadMapFromGraphic(
            mapPath, false, 1, 'assets/images/tiles.png'
        );
        add(map);
        FlxG.worldBounds.set(0, 0, map.width, map.height);
		super.create();
	}

	override public function update(elapsed:Float):Void
	{
        FlxG.camera.follow(player, LOCKON, 3);
        FlxG.camera.setScrollBoundsRect(0, 0, map.width, map.height);
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
