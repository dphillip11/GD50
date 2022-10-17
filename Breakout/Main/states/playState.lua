playState = Class{__includes = BaseState}

function playState:update(dt)
    paddle:update(dt)
    ball:update(dt)
    if keyLog['space'] == true then
        ball.inPlay = 1
    keyLog={}
    end
    for n, brick in pairs(bricks) do
        brick:update(dt)
        if brick.skin < 1 then
            table.remove(bricks, n)
        end
    end
    if table.getn(bricks) < 1 then
        sMachine:change('start')
    end
end

function playState:render()
    paddle:render()
    ball:render()
    for n, brick in pairs(bricks) do
        brick:render(dt)
    end
end

function playState:enter(skin)
    paddle = Paddle(skin)
    ball = Ball()
    bricks= createLvl()
end