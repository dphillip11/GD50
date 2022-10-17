require 'src/dependencies'

function love.load()
    WINDOW_WIDTH = 800
    WINDOW_HEIGHT = 600
    math.randomseed(2)
    colors = {
        [1] = {1,1,1},
        [2] = {1,0,0},
        [3] = {0,1,0},
        [4] = {0,0,1}
    }
    blocks = {}
    for i = 1, 25 do
        blocks[i] = Square((i - 1)%5 * 100, math.floor((i - 1)/5) * 100, colors[math.random(1,4)])
    end
    mouseclicks = {}
    blockSelected=0
    blockSelectedIndex=0
    glides = {}
   
end


function love.update(dt)
    fall()
    reGenerate()
    matches = checkMatch()
    for i, match in pairs(matches) do
        blocks[match].color = {0,0,0}
        blocks[match].alpha = 0
    end
    for i, index in pairs(mouseclicks) do
        if blocks[index].inTransit==0 then
            if blockSelected == 0 then 
                blocks[index].alpha = 0.5
                blockSelected = 1
                blockSelectedIndex=index
            else
                blocks[blockSelectedIndex].alpha = 1
                swapBlocks(blockSelectedIndex, index)
                matches = checkMatch()
                for i, match in pairs(matches) do
                    table.remove(blocks[match],i)
                end
                blockSelected = 0                
            end
        end
    end
    mouseclicks = {}
    for i, block in pairs(blocks) do
        block:update(dt)
    end
end

function love.mousepressed( x, y)
    if x < 500 and y < 500 then
        index = math.floor(y / 100) * 5 + math.ceil((x / 100))
        table.insert(mouseclicks, index)
    end
end



function love.draw()
    for i, block in pairs(blocks) do
        block:render()
    end
end

function swapBlocks(index1, index2)
    blocks[index1].glideX = Glide({blocks[index1].x, blocks[index2].x},0.5)
    blocks[index1].glideY = Glide({blocks[index1].y, blocks[index2].y},0.5)
    blocks[index2].glideX = Glide({blocks[index2].x, blocks[index1].x},0.5)
    blocks[index2].glideY = Glide({blocks[index2].y, blocks[index1].y},0.5)
    tempCursor = blocks[index1]
    blocks[index1]= blocks[index2]
    blocks[index2]=tempCursor
    blocks[index1].inTransit = 1
    blocks[index2].inTransit = 1
end

function fall()
    for i, block in pairs(blocks) do
        if block.alpha == 0 and block.inTransit == 0 then
            if i - (5) > 0 then
                if blocks[i-5].alpha ~= 0 and blocks[i-5].inTransit == 0 then
                swapBlocks(i, i-5)
                end
            end
        end
    end
end


function checkMatch()
    matchCount = 1
    matches={}
    -- horizontal matches
    for i = 1, #blocks do
        if (i - 1) % 5 == 0 then
            if matchCount > 2 then
                for n = 0, matchCount - 1 do
                        table.insert(matches, (i - n))
                end
            end
            matchCount = 1
        end
        if i ~= #blocks and blocks[i].color == blocks[i + 1].color then
            matchCount = matchCount + 1
        end
        if i == #blocks or blocks[i].color ~= blocks[i + 1].color then
            if matchCount > 2 then
                for n = 0, matchCount - 1 do
                    table.insert(matches, i - n)
                end
            end
            matchCount = 1
        end
    end
    -- vertical matches
    for column =1, 5 do
        if matchCount > 2 then
            for n = 0, matchCount - 1 do
                if checkDuplicate((column + 19 - n), matches) == 'false' then
                    table.insert(matches, (column + 19 - n ))
                end
            end
        end
        matchCount = 1
        for row = 0,3 do
            if blocks[column + (row * 5)].color == blocks[column + ((row + 1) * 5)].color then
                matchCount = matchCount + 1
            end
            if blocks[column + (row * 5)].color ~= blocks[column + ((row + 1) * 5)].color or (row == 3 and column == 5) then
                if matchCount > 2 then
                    for n = -1, matchCount do
                        if checkDuplicate((column +(row * 5)-n), matches) == 'false' then
                            table.insert(matches, (column + (row * 5) - n ))
                        end
                    end
                end
                matchCount = 1
            end
        end 
    end
    return matches
end

function checkDuplicate(item, array)
    duplicate = 'false'
    for i, listItem in pairs(array) do
        if item == listItem then
            duplicate = 'true'
        end
    end
    return duplicate
end

function reGenerate()
    for i = 1,5 do
        if blocks[i].alpha == 0 then
            blocks[i] = Square((i - 1)%5 * 100, 0, colors[math.random(1,4)])
        end
    end
end


