package;

import flixel.*;
import flixel.math.*;
import flixel.tile.*;
import flixel.util.*;

class PlayState extends FlxState
{
    public static inline var TOTAL_MAPS = 12;
    public static inline var TOTAL_BIG_MAPS = 3;
    public static inline var TOTAL_LAYOUTS = 10;

    private var player:Player;
    private var maps:Map<String, FlxTilemap>;
    private var currentMap:FlxTilemap;
    private var layout:FlxTilemap;

    private var worldWidth:Int;
    private var worldHeight:Int;

	override public function create():Void
	{
        FlxG.state.bgColor = FlxColor.GRAY;
        maps = new Map<String, FlxTilemap>();
        currentMap = null;
        layout = new FlxTilemap();
        var layoutRand = Math.floor(Math.random() * TOTAL_LAYOUTS);
        var layoutPath = 'assets/data/layouts/' + layoutRand + '.png';
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
                    maps.set([x, y].toString(), map);
                } 
            }
        }

        addBigMap();

        FlxG.worldBounds.set(
            0, 0,
            layout.widthInTiles * FlxG.width,
            layout.heightInTiles * FlxG.height
        );
        var iter = maps.iterator();
        while(iter.hasNext()) {
            var map = iter.next(); 
            add(map);
            if (currentMap == null) {
                currentMap = map;
            }
        }
        player = new Player(
            Std.int(currentMap.x + 50),
            Std.int(currentMap.y + 50)
        );
        add(player);
		super.create();
	}

    private function inBounds(x:Int, y:Int, tilemap:FlxTilemap) {
        return (
            x >= 0
            && x < tilemap.widthInTiles
            && y >= 0
            && y < tilemap.heightInTiles
        );
    }

    private function addBigMap()
    {
        for (x in 0...layout.widthInTiles) {
            for (y in 0...layout.heightInTiles) {
                if(
                    layout.getTile(x, y) == 1
                    && inBounds(x + 1, y + 1, layout)
                    && layout.getTile(x + 1, y) == 1
                    && layout.getTile(x, y + 1) == 1
                    && layout.getTile(x + 1, y + 1) == 1
                ) {
                    maps.remove([x, y].toString());
                    maps.remove([x + 1, y].toString());
                    maps.remove([x, y + 1].toString());
                    maps.remove([x + 1, y + 1].toString());
                    var map = new FlxTilemap();
                    var rand = Math.floor(Math.random() * TOTAL_BIG_MAPS);
                    var mapPath = 'assets/data/maps/big/' + rand + '.png';
                    map.loadMapFromGraphic(
                        mapPath, false, 1, 'assets/images/tiles.png'
                    );
                    map.x = x * map.width/2;
                    map.y = y * map.height/2;
                    sealBigMap(x, y, map);
                    maps.set([x, y].toString(), map);
                    return;
                }
            }
        }
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

    private function sealBigMap(x:Int, y:Int, map:FlxTilemap) {
        // left-top
        if(x == 0 || layout.getTile(x - 1, y) == 0) {
            map.setTile(0, 6, 1);
            map.setTile(0, 7, 1);
            map.setTile(0, 8, 1);
        }
        // left-bottom
        if(
            x == 0
            || !inBounds(x - 1, y + 1, layout)
            || layout.getTile(x - 1, y + 1) == 0
        ) {
            map.setTile(0, 21, 1);
            map.setTile(0, 22, 1);
            map.setTile(0, 23, 1);
        }
        // right-top
        if(
            x == layout.heightInTiles - 2
            || !inBounds(x + 2, y, layout)
            || layout.getTile(x + 2, y) == 0
        ) {
            map.setTile(map.widthInTiles - 1, 6, 1);
            map.setTile(map.widthInTiles - 1, 7, 1);
            map.setTile(map.widthInTiles - 1, 8, 1);
        }
        // right-bottom
        if(
            x == layout.heightInTiles - 2
            || !inBounds(x + 2, y + 1, layout)
            || layout.getTile(x + 2, y + 1) == 0
        ) {
            map.setTile(map.widthInTiles - 1, 21, 1);
            map.setTile(map.widthInTiles - 1, 22, 1);
            map.setTile(map.widthInTiles - 1, 23, 1);
        }
        // up-left
        if(y == 0 || layout.getTile(x, y - 1) == 0) {
            map.setTile(6, 0, 1);
            map.setTile(7, 0, 1);
            map.setTile(8, 0, 1);
            map.setTile(9, 0, 1);
        }
        // up-right
        if(
            y == 0
            || !inBounds(x + 1, y - 1, layout)
            || layout.getTile(x + 1, y - 1) == 0
        ) {
            map.setTile(22, 0, 1);
            map.setTile(23, 0, 1);
            map.setTile(24, 0, 1);
            map.setTile(25, 0, 1);
        }
        // bottom-left
        if(
            y == layout.heightInTiles - 2
            || !inBounds(x, y + 2, layout)
            || layout.getTile(x, y + 2) == 0
        ) {
            map.setTile(6, map.heightInTiles - 1, 1);
            map.setTile(7, map.heightInTiles - 1, 1);
            map.setTile(8, map.heightInTiles - 1, 1);
            map.setTile(9, map.heightInTiles - 1, 1);
        }
        // bottom-right
        if(
            y == layout.heightInTiles - 2
            || !inBounds(x + 1, y + 2, layout)
            || layout.getTile(x + 1, y + 2) == 0
        ) {
            map.setTile(22, map.heightInTiles - 1, 1);
            map.setTile(23, map.heightInTiles - 1, 1);
            map.setTile(24, map.heightInTiles - 1, 1);
            map.setTile(25, map.heightInTiles - 1, 1);
        }
    }

	override public function update(elapsed:Float):Void
	{
        var iter = maps.iterator();
        while(iter.hasNext()) {
            var map = iter.next();
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
