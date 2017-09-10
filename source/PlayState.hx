package;

import flixel.*;
import flixel.addons.display.*;
import flixel.math.*;
import flixel.tile.*;
import flixel.util.*;

class PlayState extends FlxState
{
    public static inline var TOTAL_MAPS = 12;
    public static inline var TOTAL_BIG_MAPS = 3;
    public static inline var TOTAL_LAYOUTS = 10;
    public static inline var TOTAL_BACKGROUNDS = 6;

    private var player:Player;
    private var maps:Map<String, FlxTilemap>;
    private var bigMaps:Map<String, FlxTilemap>;
    private var currentMap:FlxTilemap;
    private var layout:FlxTilemap;

    private var worldWidth:Int;
    private var worldHeight:Int;

	override public function create():Void
	{
        var randBackground = Math.ceil(Math.random() * TOTAL_BACKGROUNDS);
        var backdrop = new FlxBackdrop(
            'assets/images/backgrounds/' + randBackground + '.png'
        );
        add(backdrop);
        var light = new FlxBackdrop(
            'assets/images/backgrounds/light.png', 0.75, 0.75
        );
        add(light);
        maps = new Map<String, FlxTilemap>();
        bigMaps = new Map<String, FlxTilemap>();
        layout = new FlxTilemap();
        var layoutRand = Math.ceil(Math.random() * TOTAL_LAYOUTS);
        var layoutPath = 'assets/data/layouts/' + layoutRand + '.png';
        layout.loadMapFromGraphic(
            layoutPath, false, 1, 'assets/images/tiles.png'
        );
        
        for (x in 0...layout.widthInTiles) {
            for (y in 0...layout.heightInTiles) {
                if(layout.getTile(x, y) == 1) {
                    var map = new FlxTilemap();
                    var rand = Math.ceil(Math.random() * TOTAL_MAPS);
                    var mapPath = 'assets/data/maps/' + rand + '.png';
                    map.loadMapFromGraphic(
                        mapPath, false, 1, 'assets/images/tiles.png', 16, 16, AUTO
                    );
                    map.x = x * map.width;
                    map.y = y * map.height;
                    sealMap(x, y, map);
                    maps.set([x, y].toString(), map);
                } 
            }
        }

        addBigMap();
        addStart();

        FlxG.worldBounds.set(
            0, 0,
            layout.widthInTiles * FlxG.width,
            layout.heightInTiles * FlxG.height
        );
        var iter = maps.iterator();
        while(iter.hasNext()) {
            var map = iter.next(); 
            add(map);
        }
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

    private function addStart()
    {
        var randX = Math.floor(Math.random() * layout.widthInTiles);
        var randY = Math.floor(Math.random() * layout.heightInTiles);
        while(
            layout.getTile(randX, randY) == 0
            || bigMaps.exists([randX, randY].toString())
        ) {
            randX = Math.floor(Math.random() * layout.widthInTiles);
            randY = Math.floor(Math.random() * layout.heightInTiles);
        }
        var map = new FlxTilemap();
        maps.remove([randX, randY].toString());
        var mapPath = 'assets/data/maps/start.png';
        map.loadMapFromGraphic(
            mapPath, false, 1, 'assets/images/tiles.png', 16, 16, AUTO
        );
        map.x = randX * map.width;
        map.y = randY * map.height;
        sealMap(randX, randY, map);
        maps.set([randX, randY].toString(), map);
        currentMap = map;
        player = new Player(
            Std.int(currentMap.x + currentMap.width/2),
            Std.int(currentMap.y + currentMap.height/2 - 30)
        );
        add(player);
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
                    var rand = Math.ceil(Math.random() * TOTAL_BIG_MAPS);
                    var mapPath = 'assets/data/maps/big/' + rand + '.png';
                    map.loadMapFromGraphic(
                        mapPath, false, 1, 'assets/images/tiles.png', 16, 16,
                        AUTO
                    );
                    map.x = x * map.width/2;
                    map.y = y * map.height/2;
                    sealBigMap(x, y, map);
                    maps.set([x, y].toString(), map);
                    bigMaps.set([x, y].toString(), map);
                    bigMaps.set([x + 1, y].toString(), map);
                    bigMaps.set([x, y + 1].toString(), map);
                    bigMaps.set([x + 1, y + 1].toString(), map);
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
            FlxG.collide(player, map);
        }
        FlxG.camera.follow(player, LOCKON, 3);
        FlxG.camera.setScrollBoundsRect(
            currentMap.x, currentMap.y, currentMap.width, currentMap.height
        );
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
