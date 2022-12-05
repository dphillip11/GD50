--[[
    GD50
    Super Mario Bros. Remake

    -- LevelMaker Class --

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

LevelMaker = Class{}

function LevelMaker.generate(width, height)
    local tiles = {}
    local entities = {}
    local objects = {}
    local keyPlaced = 0
    local lockPlaced = 0
    local tileID = TILE_ID_GROUND
    
    -- whether we should draw our tiles with toppers
    local topper = true
    local tileset = math.random(20)
    local topperset = math.random(20)
    
    -- repeat level generation until key and lock are placed
    while keyPlaced == 0 or lockPlaced == 0 do
        keyPlaced = 0
        lockPlaced = 0
        tiles = {}
        entities = {}
        objects = {}
        -- insert blank tables into tiles for later access
        for x = 1, height do
            table.insert(tiles, {})
        end

        -- column by column generation instead of row; sometimes better for platformers
        for x = 1, width do
            local tileID = TILE_ID_EMPTY
            
            -- lay out the empty space
            for y = 1, 6 do
                table.insert(tiles[y],
                    Tile(x, y, tileID, nil, tileset, topperset))
            end

            -- chance to just be emptiness
            -- leave space for flag
            if math.random(7) == 1 and x < width - 4 then
                for y = 7, height do
                    table.insert(tiles[y],
                        Tile(x, y, tileID, nil, tileset, topperset))
                end
            else
                tileID = TILE_ID_GROUND

                -- height at which we would spawn a potential jump block
                local blockHeight = 4

                for y = 7, height do
                    table.insert(tiles[y],
                        Tile(x, y, tileID, y == 7 and topper or nil, tileset, topperset))
                end

                -- chance to generate a pillar
                -- leave space for flag
                if math.random(8) == 1 and x < width - 4 then
                    blockHeight = 2
                    
                    -- chance to generate bush on pillar
                    if math.random(8) == 1 then
                        table.insert(objects,
                            GameObject {
                                texture = 'bushes',
                                x = (x - 1) * TILE_SIZE,
                                y = (4 - 1) * TILE_SIZE,
                                width = 16,
                                height = 16,
                                
                                -- select random frame from bush_ids whitelist, then random row for variance
                                frame = BUSH_IDS[math.random(#BUSH_IDS)] + (math.random(4) - 1) * 7,
                                collidable = false
                            }
                        )
                    end
                    
                    -- pillar tiles
                    tiles[5][x] = Tile(x, 5, tileID, topper, tileset, topperset)
                    tiles[6][x] = Tile(x, 6, tileID, nil, tileset, topperset)
                    tiles[7][x].topper = nil
                
                -- chance to generate bushes
                elseif math.random(8) == 1 then
                    table.insert(objects,
                        GameObject {
                            texture = 'bushes',
                            x = (x - 1) * TILE_SIZE,
                            y = (6 - 1) * TILE_SIZE,
                            width = 16,
                            height = 16,
                            frame = BUSH_IDS[math.random(#BUSH_IDS)] + (math.random(4) - 1) * 7,
                            collidable = false
                        }
                    )
                end

                -- chance to spawn a block
                -- leave space for flag
                if math.random(10) == 1 and x < width - 4 then
                    if keyPlaced == 0 and math.random(3) == 1 then
                        local key = GameObject {
                            texture = 'keys-locks',
                            x = (x - 1) * TILE_SIZE,
                            y = (blockHeight - 1) * TILE_SIZE,
                            width = 16,
                            height = 16,
                            frame = math.random(#KEYS),
                            collidable = true,
                            consumable = true,
                            solid = false,

                            onConsume = function(player, object)
                                gSounds['pickup']:play()
                                keyFound = 1
                            end
                        }
                        table.insert(objects,key)
                        keyPlaced = 1

                    elseif lockPlaced == 0 and math.random(3) == 1 then
                        local lock = GameObject {
                            texture = 'keys-locks',
                            x = (x - 1) * TILE_SIZE,
                            y = (blockHeight - 1) * TILE_SIZE,
                            width = 16,
                            height = 16,
                            frame = 4 + math.random(#LOCKS),
                            collidable = true,
                            consumable = false,
                            solid = true,
                            onCollide = function(player, object)
                                if keyFound == 1 and lockOpen == 0 then
                                    gSounds['pickup']:play()
                                    lockOpen = 1
                                    local pole = GameObject {
                                        texture = 'flags',
                                        x = (width - 3 ) * TILE_SIZE,
                                        y = (3) * TILE_SIZE,
                                        width = 16,
                                        height = 48,
                                        frame = math.random(6),
                                        collidable = false,
                                        consumable = true,
                                        solid = false,
                                        onConsume = function(player, object)
                                            gSounds['pickup']:play()
                                            gStateMachine:change('play', width + 10)
                                        end
                                        }
                                    --here I am using global variables for simplicity but it
                                    -- is probably more appropriate to hold the animation properties
                                    -- in it own class 
                                    frame = 7+((math.random(4)-1) * 3 )
                                    flag = GameObject {
                                        texture = 'flags',
                                        x = (width - 3 ) * TILE_SIZE + 8,
                                        y = (3)  * TILE_SIZE,
                                        width = 16,
                                        height = 16,
                                        frame = f,
                                        collidable = false,
                                        consumable = true,
                                        solid = false,    
                                        onConsume = function(player, object)
                                            gSounds['pickup']:play()
                                            gStateMachine:change('play', {length = width + 10})
                                        end,
                                        onUpdate = function()
                                            flag.frame = frame + (math.floor(os.clock()) %3)
                                        end
                                    }
                                    
                                    table.insert(objects, pole)
                                    table.insert(objects, flag)
                                    
                                else
                                    gSounds['empty-block']:play()
                                end  
                            end
                        }
                        table.insert(objects,lock)
                        lockPlaced = 1

                    else
                        

                        table.insert(objects,

                            -- jump block
                            GameObject {
                                texture = 'jump-blocks',
                                x = (x - 1) * TILE_SIZE,
                                y = (blockHeight - 1) * TILE_SIZE,
                                width = 16,
                                height = 16,

                                -- make it a random variant
                                frame = math.random(#JUMP_BLOCKS),
                                collidable = true,
                                hit = false,
                                solid = true,

                                -- collision function takes itself
                                onCollide = function(obj)

                                    -- spawn a gem if we haven't already hit the block
                                    if not obj.hit then

                                        -- chance to spawn gem, not guaranteed
                                        if math.random(5) == 1 then

                                            -- maintain reference so we can set it to nil
                                            local gem = GameObject {
                                                texture = 'gems',
                                                x = (x - 1) * TILE_SIZE,
                                                y = (blockHeight - 1) * TILE_SIZE - 4,
                                                width = 16,
                                                height = 16,
                                                frame = math.random(#GEMS),
                                                collidable = true,
                                                consumable = true,
                                                solid = false,

                                                -- gem has its own function to add to the player's score
                                                onConsume = function(player, object)
                                                    gSounds['pickup']:play()
                                                    player.score = player.score + 100
                                                end
                                            }
                                            
                                            -- make the gem move up from the block and play a sound
                                            Timer.tween(0.1, {
                                                [gem] = {y = (blockHeight - 2) * TILE_SIZE}
                                            })
                                            gSounds['powerup-reveal']:play()

                                            table.insert(objects, gem)
                                        end

                                        obj.hit = true
                                    end

                                    gSounds['empty-block']:play()
                                end
                            }
                        )
                    end
                    
                end
            end
        end
    end

    local map = TileMap(width, height)
    map.tiles = tiles
    
    return GameLevel(entities, objects, map)
end