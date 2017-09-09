package;

import flixel.*;
import flixel.math.*;
import flixel.tile.*;
import flixel.util.*;

class PlayState extends FlxState
{
    public static inline var TOTAL_MAPS = 12;
    public static inline var TOTAL_LAYOUTS = 1;

    private var player:Player;
    private var maps:Array<FlxTilemap>;
    private var currentMap:FlxTilemap;
    private var layout:FlxTilemap;

    private var worldWidth:Int;
    private var worldHeight:Int;

	override public function create():Void
	{
        FlxG.state.bgColor = FlxColor.GRAY;
        player = new Player(100, 100);
        add(player);

        maps = new Array<FlxTilemap>();
        layout = new FlxTilemap();
        var layoutPath = 'assets/data/layouts/1.png';
        layout.loadMapFromGraphic(
            layoutPath, false, 1, 'assets/images/tiles.png'
        );
        
        for (x in 0...layout.widthInTiles) {
            for (y in 0...layout.heightInTiles) {
                if(layout.getTile(x, y) == 1) {
                    var map = new FlxTilemap();
                    var rand = Math.floor(Math.random() * TOTAL_MAPS);
                    var mapPath = 'assets/data/maps/' + rand + '.png';
                    map.loadMapFromGraphic(
                        mapPath, false, 1, 'assets/images/tiles.png'
                    );
                    map.x = x * map.width;
                    map.y = y * map.height;
                    maps.push(map);
                    add(map);
                } 
            }
        }
        FlxG.worldBounds.set(
            0, 0,
            layout.widthInTiles * FlxG.width,
            layout.heightInTiles * FlxG.height
        );
        currentMap = maps[0];
		super.create();
	}

	override public function update(elapsed:Float):Void
	{
        for (map in maps) {
            if(FlxG.overlap(player, map)) {
                currentMap = map;
            }
        }
        FlxG.camera.follow(player, LOCKON, 3);
        FlxG.camera.setScrollBoundsRect(
            currentMap.x, currentMap.y, currentMap.width, currentMap.height
        );
        FlxG.collide(player, currentMap);
        for (bullet in Bullet.all) {
            if(currentMap.overlaps(bullet)) {
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
