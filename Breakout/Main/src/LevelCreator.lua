function createLvl()
    math.randomseed(os.time())
    bricks = {}
    offsetY = 0
    n = 1
    while offsetY < 25 do
        offsetX = -16
        if math.random(0,10) < 6 then
            offsetY = offsetY + 8
        else
            while offsetX < VIRTUAL_WIDTH / 2 - 32 do
                if math.random(0,10) < 5 then
                offsetX = offsetX + math.random(1,2) * 16
                else
                    skin = math.random(1,5) * 4 -3
                    bricks[n] = Brick(VIRTUAL_WIDTH/2 + offsetX, offsetY, skin)
                    bricks[n+1] = Brick(VIRTUAL_WIDTH/2 - offsetX - 32, offsetY, skin)
                    bricks[n+2] = Brick(VIRTUAL_WIDTH/2 + offsetX, 64 - offsetY, skin)
                    bricks[n+3] = Brick(VIRTUAL_WIDTH/2 - offsetX - 32, 64 - offsetY, skin)
                    n = n + 4
                    offsetX = offsetX + 32
                end
            end
            offsetY = offsetY + 16
        end
    end
    return bricks
end

            
        
