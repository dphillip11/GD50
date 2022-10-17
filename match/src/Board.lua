--[[
    GD50
    Match-3 Remake

    -- Board Class --

    Author: Colton Ogden
    cogden@cs50.harvard.edu

    The Board is our arrangement of Tiles with which we must try to find matching
    sets of three horizontally or vertically.
]]

Board = Class{}

function Board:init(x, y, level)
    self.x = x
    self.y = y
    self.level = level
    self.matches = {}
    self.explosions = {}
    -- tile rank avoids similar colors in early levels
    self:initializeTiles()
    
end

function Board:checkDuplicates(a)
    for _, color in pairs(self.tileColors) do
            if a == color then
                return True
            end
    end
    return False
end

function Board:initializeTiles()
    self.tileColors={}
    for i = 1, math.min(8, 3 + math.floor(self.level/2)) do
        r = math.random(18)
        while self:checkDuplicates(r) do
            r = math.random(math.min(18,self.level))
        end
        table.insert(self.tileColors, r)
    end
    -- spoof list for debugging
    -- self.tileColors={1,2,3,4,5,6,7,8,9,10}
    self.tiles = {}
    
    for tileY = 1, 8 do
        
        -- empty table that will serve as a new row
        table.insert(self.tiles, {})

        for tileX = 1, 8 do
            
            -- create a new tile at X,Y with a random color and variety
            -- add a new color for each round
            -- add a new type every two rounds
            table.insert(self.tiles[tileY], Tile(tileX, tileY, self.tileColors[math.random(#self.tileColors)], math.random(math.min(6, math.floor((self.level+1)/2)))))
        end
    end

    while self:calculateMatches(1) do
        
        -- recursively initialize if matches were returned so we always have
        -- a matchless board on start
        self:initializeTiles()
    end

end

--[[
    Goes left to right, top to bottom in the board, calculating matches by counting consecutive
    tiles of the same color. Doesn't need to check the last tile in every row or column if the 
    last two haven't been a match.
]]
function Board:calculateMatches(checkFlag)
    local matches = {}
    shinyFlag=0

    -- how many of the same color blocks in a row we've found
    local matchNum = 1

    -- horizontal matches first
    for y = 1, 8 do
        local colorToMatch = self.tiles[y][1].color

        matchNum = 1
        
        -- every horizontal tile
        for x = 2, 8 do
            
            -- if this is the same color as the one we're trying to match...
            if self.tiles[y][x].color == colorToMatch then
                matchNum = matchNum + 1
            else
                
                -- set this as the new color we want to watch for
                colorToMatch = self.tiles[y][x].color

                -- if we have a match of 3 or more up to now, add it to our matches table
                if matchNum >= 3 then
                    local match = {}

                    -- go backwards from here by matchNum
                    for x2 = x - 1, x - matchNum, -1 do
                        
                        -- add each tile to the match that's in that match
                        table.insert(match, self.tiles[y][x2])
                        if self.tiles[y][x2].shiny==1 then
                            shinyFlag = 1
                        end
                    end
                    -- remove row for shiny flag
                    if shinyFlag == 1 then
                        if not checkFlag then
                            for i = 0, 8 do
                                if i < x - matchNum or i > x -1 then
                                    table.insert(match, self.tiles[y][i])
                                end
                            end
                            table.insert(self.explosions, Explosion('horizontal',x,y))
                        end
                        shinyFlag = 0
                    end

                    -- add this match to our total matches table
                    table.insert(matches, match)
                end

                matchNum = 1

                -- don't need to check last two if they won't be in a match
                if x >= 7 then
                    break
                end
            end
        end

        -- account for the last row ending with a match
        if matchNum >= 3 then
            local match = {}
            
            -- go backwards from end of last row by matchNum
            for x = 8, 8 - matchNum + 1, -1 do
                table.insert(match, self.tiles[y][x])
                -- check for bombs!
                if self.tiles[y][x].shiny==1 then
                    shinyFlag = 1
                end
            end
            -- remove row for shiny flag
            if shinyFlag == 1 then
                if not checkFlag then
                    for i = 0, 5 do
                        if i < 8 - matchNum then
                            table.insert(match, self.tiles[y][i])
                        end
                    end
                    table.insert(self.explosions, Explosion('horizontal',x,y))
                end
                shinyFlag = 0
            end

            table.insert(matches, match)
        end
    end

    -- vertical matches
    for x = 1, 8 do
        local colorToMatch = self.tiles[1][x].color

        matchNum = 1

        -- every vertical tile
        for y = 2, 8 do
            if self.tiles[y][x].color == colorToMatch then
                matchNum = matchNum + 1
            else
                colorToMatch = self.tiles[y][x].color

                if matchNum >= 3 then
                    local match = {}

                    for y2 = y - 1, y - matchNum, -1 do
                        table.insert(match, self.tiles[y2][x])
                        if self.tiles[y2][x].shiny==1 then
                            shinyFlag = 1
                        end
                    end
                    if shinyFlag == 1 then
                        if not checkFlag then
                            for i = 1, 8 do
                                if i < y - matchNum or i > y - 1 then
                                    table.insert(match, self.tiles[i][x])
                                end
                            end
                            table.insert(self.explosions, Explosion('vertical',x,y))
                        end
                        shinyFlag = 0
                    end

                    table.insert(matches, match)
                end

                matchNum = 1

                -- don't need to check last two if they won't be in a match
                if y >= 7 then
                    break
                end
            end
        end

        -- account for the last column ending with a match
        if matchNum >= 3 then
            local match = {}
            
            -- go backwards from end of last row by matchNum
            for y = 8, 8 - matchNum + 1, -1 do
                table.insert(match, self.tiles[y][x])
                if self.tiles[y][x].shiny==1 then
                    shinyFlag = 1
                end
            end
            if shinyFlag == 1 then
                if not checkFlag then
                    for i = 1, 8 do
                        if i < 7 - matchNum then
                            table.insert(match,self.tiles[i][x])
                        end
                    end
                    table.insert(self.explosions, Explosion('vertical',x,y))
                end
                shinyFlag = 0
            end

            table.insert(matches, match)
        end
    end

    -- store matches for later reference
    self.matches = matches

    -- return matches table if > 0, else just return false
    return #self.matches > 0 and self.matches or false
end

--[[
    Remove the matches from the Board by just setting the Tile slots within
    them to nil, then setting self.matches to nil.
]]
function Board:removeMatches()
    for k, match in pairs(self.matches) do
        for k, tile in pairs(match) do
            self.tiles[tile.gridY][tile.gridX] = nil
        end
    end

    self.matches = nil
end

--[[
    Shifts down all of the tiles that now have spaces below them, then returns a table that
    contains tweening information for these new tiles.
]]
function Board:getFallingTiles()
    -- tween table, with tiles as keys and their x and y as the to values
    local tweens = {}

    -- for each column, go up tile by tile till we hit a space
    for x = 1, 8 do
        local space = false
        local spaceY = 0

        local y = 8
        while y >= 1 do
            
            -- if our last tile was a space...
            local tile = self.tiles[y][x]
            
            if space then
                
                -- if the current tile is *not* a space, bring this down to the lowest space
                if tile then
                    
                    -- put the tile in the correct spot in the board and fix its grid positions
                    self.tiles[spaceY][x] = tile
                    tile.gridY = spaceY

                    -- set its prior position to nil
                    self.tiles[y][x] = nil

                    -- tween the Y position to 32 x its grid position
                    tweens[tile] = {
                        y = (tile.gridY - 1) * 32
                    }

                    -- set Y to spaceY so we start back from here again
                    space = false
                    y = spaceY

                    -- set this back to 0 so we know we don't have an active space
                    spaceY = 0
                end
            elseif tile == nil then
                space = true
                
                -- if we haven't assigned a space yet, set this to it
                if spaceY == 0 then
                    spaceY = y
                end
            end

            y = y - 1
        end
    end

    -- create replacement tiles at the top of the screen
    for x = 1, 8 do
        for y = 8, 1, -1 do
            local tile = self.tiles[y][x]

            -- if the tile is nil, we need to add a new one
            if not tile then

                -- new tile with random color and variety
                local tile = Tile(x, y, self.tileColors[math.random(#self.tileColors)], math.random(math.min(6,math.floor((self.level+1)/2))))
                tile.y = -32
                self.tiles[y][x] = tile

                -- create a new tween to return for this tile to fall down
                tweens[tile] = {
                    y = (tile.gridY - 1) * 32
                }
            end
        end
    end

    return tweens
end

function Board:update(dt)
    if self.explosions then
        for i, explosion in pairs(self.explosions) do
            explosion:update(dt)
        end
    end
end

function Board:render()
    for y = 1, #self.tiles do
        for x = 1, #self.tiles[1] do
            self.tiles[y][x]:render(self.x, self.y)
        end
    end
    if self.explosions then
        for i, explosion in pairs(self.explosions) do
            explosion:render()
        end
    end
end

function Board:mousePos()
    
    push:start()
    Mx, My = push:toGame(love.mouse.getPosition())
    push:finish()
    -- position relative to board
    if Mx then
        Mx = Mx - self.x 
        My = My - self.y
        -- if within board area, calculate x and y tile index values
        if Mx > 0 and Mx < 256 and My > 0 and My < 256 then
            Mx = math.ceil(Mx/32)
            My = math.ceil(My/32)
            return Mx,My
        else
            return 0
        end
    end
end

function Board:swapTiles(x1,y1,x2,y2)
    -- create temp pointer
    local tempTile = self.tiles[y1][x1]
    -- swap first tile
    self.tiles[y1][x1] = self.tiles[y2][x2]
    -- change tile index variable
    self.tiles[y1][x1].gridX = x1
    self.tiles[y1][x1].gridY = y1
    -- swap tile two
    self.tiles[y2][x2] = tempTile
    -- change its contained index
    self.tiles[y2][x2].gridX = x2
    self.tiles[y2][x2].gridY = y2
    
end
     

function Board:checkPossibleMatches()
    possibilities = 0
    color = 0

    -- horizontal matches
    for y = 1,8 do
        for x = 1,7 do
            -- check for two matching colors horizontally
            if self.tiles[y][x].color == self.tiles[y][x+1].color then
                color = self.tiles[y][x].color
                -- check for match left and down
                if y>1 and x>1 and self.tiles[y-1][x-1].color == color then
                    return true 
                end
                -- check for match left and up
                if x>1 and y<8  and self.tiles[y+1][x-1].color == color then
                    return true 
                end
                -- check for match left, left
                if x>2 and self.tiles[y][x-2].color == color then
                    return true 
                end
                -- check for match right and down
                if y>1 and x<7 and self.tiles[y-1][x+2].color == color then
                    return true 
                end
                -- check for match right and up
                if y<8 and x<7 and self.tiles[y+1][x+2].color == color then
                    return true 
                end
                -- check for match right,right
                if x<6 and self.tiles[y][x+3].color == color then
                    return true 
                end
            end
        end
    end

    -- vertical matches
    for x = 1,8 do
        for y = 1,7 do
            -- check for two matching colors horizontally
            if self.tiles[y][x].color == self.tiles[y+1][x].color then
                color = self.tiles[y][x].color
                -- check for match down and left
                if y<7 and x>1 and self.tiles[y+2][x-1].color == color then
                    return true 
                end
                -- check for match down and right
                if y<7 and x<8 and self.tiles[y+2][x+1].color == color then
                    return true 
                end
                -- check for match down,down
                if y<6 and self.tiles[y+3][x].color == color then
                    return true 
                end
                -- check for match right and up
                if y>1 and x<8 and self.tiles[y-1][x+1].color == color then
                    return true 
                end
                -- check for match left and up
                if y>1 and x>1 and self.tiles[y-1][x-1].color == color then
                    return true 
                end
                -- check for match up,up
                if y>2 and self.tiles[y-2][x].color == color then
                    return true 
                end
            end
        end
    end

    for y = 1,8 do
        for x = 2,7 do
            -- check for color/gap/color horizontal
            if self.tiles[y][x-1].color == self.tiles[y][x+1].color then
                color = self.tiles[y][x-1].color
                -- possible match in between?
                if y > 1 and self.tiles[y-1][x].color == color then
                    return true
                end
                if y < 8 and self.tiles[y+1][x].color == color then
                    return true
                end
            end
        end
    end

    for x = 1,8 do
        for y = 2,7 do
            -- check for color/gap/color vertical
            if self.tiles[y-1][x].color == self.tiles[y+1][x].color then
                color = self.tiles[y-1][x].color
                -- possible match in between?
                if x > 1 and self.tiles[y][x-1].color == color then
                    return true
                end
                if x < 8 and self.tiles[y][x+1].color == color then
                    return true
                end
            end
        end
    end

    return false
end

