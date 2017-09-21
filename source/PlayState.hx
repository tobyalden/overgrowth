package;

import flixel.*;
import flixel.addons.display.*;
import flixel.math.*;
import flixel.tile.*;
import flixel.util.*;

class PlayState extends FlxState
{
    public static inline var TOTAL_MAPS = 41;
    public static inline var TOTAL_BIG_MAPS = 21;
    public static inline var TOTAL_LAYOUTS = 10;
    public static inline var TOTAL_BACKGROUNDS = 6;
    public static inline var BASE_ENEMY_COUNT = 2;

    public static var maps:Map<String, FlxTilemap>;
    public static var currentMap:FlxTilemap;

    private var player:Player;
    private var key:Key;
    private var door:Door;
    private var bigMaps:Map<String, FlxTilemap>;
    private var layout:FlxTilemap;
    private var startKey:Array<Int>;
    private var exitKey:Array<Int>;
    private var keyKey:Array<Int>;
    private var isFadingOut:Bool;

    private var worldWidth:Int;
    private var worldHeight:Int;
    private var tilesetPath:String;

    private var depth:Int;
    private var depthDisplay:DepthDisplay;
    private var enemyCount:Int;

    private var fade:Fade;

    public function new(depth:Int) {
        super();
        this.depth = depth;
        enemyCount = BASE_ENEMY_COUNT + Math.ceil(depth/3 * 2);
    }

	override public function create():Void
	{
        FlxG.mouse.visible = false;
        tilesetPath = 'assets/images/tiles.png';
        if(depth > 6) {
            tilesetPath = 'assets/images/tiles3.png';
        }
        else if(depth > 3) {
            tilesetPath = 'assets/images/tiles2.png';
        }
        depthDisplay = new DepthDisplay(0, 0, depth);
        isFadingOut = false;
        player = new Player(0, 0);
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
                        mapPath, false, 1, tilesetPath, 16, 16, AUTO
                    );
                    map.x = x * map.width;
                    map.y = y * map.height;
                    sealMap(x, y, map);
                    maps.set([x, y].toString(), map);
                } 
            }
        }

        addBigMap();
        if(depth < 10) {
            addExit();
            addStart();
            addKey();
        }
        else {
            exitKey = [-1, -1];
            startKey = [-1, -1];
            keyKey = [-1, -1];
        }
        add(player);

        FlxG.worldBounds.set(
            0, 0,
            layout.widthInTiles * FlxG.width,
            layout.heightInTiles * FlxG.height
        );
        var iter = maps.iterator();
        while(iter.hasNext()) {
            var map = iter.next(); 
            add(map);
            decorateMap(map);
        }
        if(depth < 10) {
            addEnemies();
        }
        add(depthDisplay);

        fade = new Fade();
        fade.alpha = 1;
        fade.fadeIn();
        add(fade);

        FlxG.sound.music.fadeOut();
        if(depth < 10) {
            FlxG.sound.playMusic('assets/music/' + depth + '.ogg', 0, true);
            FlxG.sound.music.fadeIn();
        }
		super.create();
	}

    private function decorateMap(map:FlxTilemap) {
        for (x in 0...map.widthInTiles) {
            for (y in 0...map.heightInTiles) {
                if(map.getTile(x, y) > 0 && inBounds(x, y - 1, map) && map.getTile(x, y - 1) == 0) {
                    add(new Grass(
                        Std.int(map.x + x * 16), Std.int(map.y + y * 16 - 32)
                    ));
                }
                else if(map.getTile(x, y) > 0 && inBounds(x, y + 1, map) && map.getTile(x, y + 1) == 0) {
                    if(Math.random() > 0.6) {
                        add(new Vines(
                            Std.int(map.x + x * 16), Std.int(map.y + y * 16 + 16)
                        ));
                    }
                }
            }
        }
    }

    private function inBounds(x:Int, y:Int, tilemap:FlxTilemap) {
        return (
            x >= 0
            && x < tilemap.widthInTiles
            && y >= 0
            && y < tilemap.heightInTiles
        );
    }

    private function addKey()
    {
        var randX = Math.floor(Math.random() * layout.widthInTiles);
        var randY = Math.floor(Math.random() * layout.heightInTiles);
        while(
            !maps.exists([randX, randY].toString())
            || bigMaps.exists([randX, randY].toString())
            || [randX, randY].toString() == exitKey.toString()
            || [randX, randY].toString() == startKey.toString()
        ) {
            randX = Math.floor(Math.random() * layout.widthInTiles);
            randY = Math.floor(Math.random() * layout.heightInTiles);
        }
        var map = new FlxTilemap();
        maps.remove([randX, randY].toString());
        var mapPath = 'assets/data/maps/start.png';
        map.loadMapFromGraphic(
            mapPath, false, 1, tilesetPath, 16, 16, AUTO
        );
        map.x = randX * map.width;
        map.y = randY * map.height;
        sealMap(randX, randY, map);
        keyKey = [randX, randY];
        maps.set(keyKey.toString(), map);
        key = new Key(
            Std.int(map.x + 8 * 16 - 8),
            Std.int(map.y + 9 * 16 - 24 - 16)
        );
        add(key);
    }

    private function getRandomEmptyMap()
    {
        var randX = Math.floor(Math.random() * layout.widthInTiles);
        var randY = Math.floor(Math.random() * layout.heightInTiles);
        while(
            !maps.exists([randX, randY].toString())
            || bigMaps.exists([randX, randY].toString())
            || [randX, randY].toString() == exitKey.toString()
            || [randX, randY].toString() == startKey.toString()
            || [randX, randY].toString() == keyKey.toString()
        ) {
            randX = Math.floor(Math.random() * layout.widthInTiles);
            randY = Math.floor(Math.random() * layout.heightInTiles);
        }
        return maps.get([randX, randY].toString());
    }

    private function addEnemies()
    {
        for(i in 0...enemyCount) {
            var map = getRandomEmptyMap();
            var randX = Math.floor(Math.random() * map.widthInTiles);
            var randY = Math.floor(Math.random() * map.heightInTiles);
            while(
                map.getTile(randX, randY) != 0
                || randX < 5 || randX > map.widthInTiles - 5
                || randY < 5 || randY > map.widthInTiles - 5
            ) {
                randX = Math.floor(Math.random() * map.widthInTiles);
                randY = Math.floor(Math.random() * map.heightInTiles);
            }
            var enemy = Enemy.getRandomEnemy(
                Std.int(map.x + randX * 16), 
                Std.int(map.y + randY * 16), player, depth, false
            );
            add(enemy);
        }
    }

    private function addStart()
    {
        var randX = Math.floor(Math.random() * layout.widthInTiles);
        var randY = Math.floor(Math.random() * layout.heightInTiles);
        while(
            !maps.exists([randX, randY].toString())
            || bigMaps.exists([randX, randY].toString())
            || [randX, randY].toString() == exitKey.toString()
        ) {
            randX = Math.floor(Math.random() * layout.widthInTiles);
            randY = Math.floor(Math.random() * layout.heightInTiles);
        }
        var map = new FlxTilemap();
        maps.remove([randX, randY].toString());
        var mapPath = 'assets/data/maps/start.png';
        map.loadMapFromGraphic(
            mapPath, false, 1, tilesetPath, 16, 16, AUTO
        );
        map.x = randX * map.width;
        map.y = randY * map.height;
        sealMap(randX, randY, map);
        startKey = [randX, randY];
        maps.set(startKey.toString(), map);
        currentMap = map;
        if(depth == 1) {
            add(new Tutorial(Std.int(currentMap.x), Std.int(currentMap.y)));
        }
        player.x = Std.int(currentMap.x + 8 * 16 - 8);
        player.y = Std.int(currentMap.y + 9 * 16 - 24 - 16);
    }

    private function addExit()
    {
        var randX = Math.floor(Math.random() * layout.widthInTiles);
        var randY = Math.floor(Math.random() * layout.heightInTiles);
        while(
            !maps.exists([randX, randY].toString())
            || bigMaps.exists([randX, randY].toString())
        ) {
            randX = Math.floor(Math.random() * layout.widthInTiles);
            randY = Math.floor(Math.random() * layout.heightInTiles);
        }
        var map = new FlxTilemap();
        maps.remove([randX, randY].toString());
        var mapPath = 'assets/data/maps/start.png';
        map.loadMapFromGraphic(
            mapPath, false, 1, tilesetPath, 16, 16, AUTO
        );
        map.x = randX * map.width;
        map.y = randY * map.height;
        sealMap(randX, randY, map);
        exitKey = [randX, randY];
        maps.set(exitKey.toString(), map);
        door = new Door(
            Std.int(map.x + 8 * 16 - 16),
            Std.int(map.y + 9 * 16 - 32)
        );
        add(door);
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
                    var mapPath = 'assets/data/maps/big/bossroom.png';
                    if(depth < 10) {
                        var rand = Math.ceil(Math.random() * TOTAL_BIG_MAPS);
                        mapPath = 'assets/data/maps/big/' + rand + '.png';
                    }
                    map.loadMapFromGraphic(
                        mapPath, false, 1, tilesetPath, 16, 16,
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

                    if(depth == 10) {
                        var boss = new Boss(
                            Std.int(map.x + map.width/2 - 32) + 50,
                            Std.int(map.y + map.height/2 - 32),
                            player
                        );
                        add(boss);
                        var boss2 = new BossTwo(
                            Std.int(map.x + map.width/2 - 32) - 50,
                            Std.int(map.y + map.height/2 - 32),
                            player
                        );
                        add(boss2);
                        player.x = Std.int(map.x + map.width/2);
                        player.y = Std.int(map.y + map.height - 32);
                        return;
                    }

                    for(i in 0...enemyCount) {
                        var randX = Math.floor(
                            Math.random() * map.widthInTiles
                        );
                        var randY = Math.floor(
                            Math.random() * map.heightInTiles
                        );
                        while(
                            map.getTile(randX, randY) != 0
                            || randX < 5 || randX > map.widthInTiles - 5
                            || randY < 5 || randY > map.widthInTiles - 5
                        ) {
                            randX = Math.floor(
                                Math.random() * map.widthInTiles
                            );
                            randY = Math.floor(
                                Math.random() * map.heightInTiles
                            );
                        }
                        var enemy = Enemy.getRandomEnemy(
                            Std.int(map.x + randX * 16),
                            Std.int(map.y + randY * 16), player, depth,
                            true
                        );
                        add(enemy);
                    }

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
        if(isFadingOut) {
            player.moves = false;
            super.update(elapsed);
            return;
        }
        if(depth == 10 && !Boss.theBoss.alive && !BossTwo.theBoss.alive) {
           enlightenPlayer(); 
           isFadingOut = true;
        }
        var iter = maps.iterator();
        while(iter.hasNext()) {
            var map = iter.next();
            if(FlxG.overlap(player, map)) {
                currentMap = map;
            }
            FlxG.collide(player, map);
            FlxG.collide(Enemy.all, map);
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
        for (bullet in EnemyBullet.all) {
            if(currentMap.overlaps(bullet)) {
                bullet.destroy();
            }
        }
        for (bullet in BossBullet.all) {
            if(currentMap.overlaps(bullet)) {
                bullet.destroy();
            }
        }
        FlxG.overlap(
            Enemy.all, Bullet.all,
            function(enemy:FlxObject, bullet:FlxObject) {
                cast(enemy, Enemy).takeHit(bullet);
                bullet.destroy();
            } 
        );
        FlxG.collide(Enemy.all, Enemy.all);
        if(FlxG.overlap(player, Enemy.all)) {
            killPlayer();
        }
        if(FlxG.overlap(player, EnemyBullet.all)) {
            killPlayer();
        }
        if(FlxG.overlap(player, BossBullet.all)) {
            killPlayer();
        }
        if(FlxG.overlap(player, Ghost.ghosts)) {
            killPlayer();
        }
        if(FlxG.overlap(player, key)) {
            door.animation.play('open');
            key.destroy();
        }
        if(FlxG.overlap(player, door) && door.animation.name == 'open') {
            door.leaveSfx.play();
            fade.fadeOut();
            new FlxTimer().start(2.5, function(_:FlxTimer) {
                FlxG.switchState(new PlayState(depth + 1));
            }, 1);
            isFadingOut = true;
        }
        depthDisplay.x = currentMap.x;
        depthDisplay.y = currentMap.y;
        depthDisplay.x = FlxG.camera.scroll.x;
        depthDisplay.y = FlxG.camera.scroll.y;
		super.update(elapsed);
	}

    private function killPlayer() {
        player.kill();
        new FlxTimer().start(2,
            function fadeToStart(_:FlxTimer) {
                fade.animation.play('white');
                fade.fadeOut();
                new FlxTimer().start(1.5, function(_:FlxTimer) {
                    FlxG.switchState(new StartScreen(FlxColor.WHITE));
                }, 1);
            }
        , 1);
    }

    private function enlightenPlayer() {
        new FlxTimer().start(2,
            function fadeToStart(_:FlxTimer) {
                fade.animation.play('red');
                fade.fadeOut();
                new FlxTimer().start(1.5, function(_:FlxTimer) {
                    FlxG.switchState(new TheEnd(FlxColor.RED));
                }, 1);
            }
        , 1);
    }

}
