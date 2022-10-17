
-- generate a quad for a brick given it's index
function  getBrickQuad(n)
    x = ((n % 6) - 1) * 32
    y = 16 * math.floor(n / 6)
    quad = love.graphics.newQuad(x, y, 32, 16, textures['spritesheet'])
    return quad
end

-- create a list of brick quads
function  generateQuadsBricks()
    bricks = {}
    for n = 1, 21 do
        bricks[n] = getBrickQuad(n)
    end
    bricks[22] = love.graphics.newQuad(160, 48, 32, 16, textures['spritesheet'])
    return bricks
end

-- create a list of paddle quads
function  generateQuadsPaddles()
    local x = 0
    local y = 64

    local counter = 1
    local quads = {}

    for i = 1, 4 do
        -- smallest
        quads[counter] = love.graphics.newQuad(x, y, 32, 16,
        textures['spritesheet'])
        counter = counter + 1
        -- medium
        quads[counter] = love.graphics.newQuad(x + 32, y, 64, 16,
        textures['spritesheet'])
        counter = counter + 1
        -- large
        quads[counter] = love.graphics.newQuad(x + 96, y, 96, 16,
        textures['spritesheet'])
        counter = counter + 1
        -- huge
        quads[counter] = love.graphics.newQuad(x, y + 16, 128, 16,
        textures['spritesheet'])
        counter = counter + 1

        -- prepare X and Y for the next set of paddles
        x = 0
        y = y + 32
    end

    return quads
end

-- return quad for indexed ball
function getBallQuad(n)
    x = 96 + (8 * (n % 4)) 
    y = 48 + (8 * math.floor(n/5))
    quad = love.graphics.newQuad(x, y, 8, 8, textures['spritesheet'])
    return quad
end

-- return list of ball quads
function  generateQuadsBalls()
    balls = {}
    for n = 1, 7 do
        balls[n] = getBallQuad(n)
    end
    return balls
end

-- return hearts quads
function  generateQuadsHearts()
    hearts = {}
    hearts['full'] = love.graphics.newQuad(128, 48, 10, 10,textures['spritesheet'])
    hearts['empty'] = love.graphics.newQuad(138, 48, 10, 10,textures['spritesheet'])
    return hearts
end

function  generateQuadsArrows()
    arrows = {}
    arrows['left'] = love.graphics.newQuad(0, 0, 24, 24,textures['arrows'])
    arrows['right'] = love.graphics.newQuad(24, 0, 24, 24,textures['arrows'])
    return arrows
end


