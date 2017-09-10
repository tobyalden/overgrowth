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
                    sealMap(x, y, map);
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

    private function sealMap(x:Int, y:Int, map:FlxTilemap) {
        if(x == 0 || layout.getTile(x - 1, y) == 0) {
            map.setTile(0, 6, 1);
            map.setTile(0, 7, 1);
            map.setTile(0, 8, 1);
        }
        if(x == layout.widthInTiles - 1 || layout.getTile(x + 1, y) == 0) {
            map.setTile(map.widthInTiles - 1, 6, 1);
            map.setTile(map.widthInTiles - 1, 7, 1);
            map.setTile(map.widthInTiles - 1, 8, 1);
        }
        if(y == 0 || layout.getTile(x, y - 1) == 0) {
            map.setTile(6, 0, 1);
            map.setTile(7, 0, 1);
            map.setTile(8, 0, 1);
            map.setTile(9, 0, 1);
        }
        if(y == layout.heightInTiles - 1 || layout.getTile(x, y + 1) == 0) {
            map.setTile(6, map.heightInTiles - 1, 1);
            map.setTile(7, map.heightInTiles - 1, 1);
            map.setTile(8, map.heightInTiles - 1, 1);
            map.setTile(9, map.heightInTiles - 1, 1);
        }
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
