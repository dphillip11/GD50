StartState = Class{__includes = BaseState}

function StartState:update(dt)
    paddle:update(dt)
    if wasPressed('left') then
        if paddle.skin > 1 then
            paddle.skin = paddle.skin - 1
        end
    end
    if wasPressed('right') then
        if paddle.skin < 4 then
            paddle.skin = paddle.skin + 1
        end
    end
    if wasPressed('return') then
        sMachine:change('play', paddle.skin)
    end
    
    keyLog = {} 

end

function StartState:render()
    love.graphics.draw(textures['spritesheet'], quads['paddles'][(paddle.skin - 1) * 4 + (paddle.size)],VIRTUAL_WIDTH/2 - 64, VIRTUAL_HEIGHT/2 - 8)
    if paddle.skin == 1 then
        love.graphics.setColor(1, 1, 1, 0.3)
    end
    love.graphics.draw(textures['arrows'], quads['arrows']['left'],VIRTUAL_WIDTH/2 - 150, VIRTUAL_HEIGHT/2 - 12)
    love.graphics.setColor(1, 1, 1, 1)
    if paddle.skin == 4 then
        love.graphics.setColor(1, 1, 1, 0.3)
    end
    love.graphics.draw(textures['arrows'], quads['arrows']['right'],VIRTUAL_WIDTH/2 + 126, VIRTUAL_HEIGHT/2 - 12)
end

function StartState:enter()
    paddle = Paddle(1)
    paddle.size = 4
end

