ScoreState = Class{__includes = BaseState}

function ScoreState:init()
    PAUSE = -1
    self.score = 0
    TIMER = 0
end

function ScoreState:update(dt)
    if love.keyboard.wasPressed('return') then
        PAUSE = PAUSE * -1
    end
    if PAUSE == -1 then
        TIMER = TIMER + dt
        SPAWN_DX = SPAWN_DX + (PIPE_SPEED * dt)
        background:update(dt)
        if SPAWN_DX > (PIPE_SPACING * VIRTUAL_WIDTH) then
            SPAWN_DX = 0
            table.insert(pipes, Pipe())
        end
        bird:replay(dt, key_history)

        for k, pipe in pairs(pipes) do
            pipe:update(dt)
                if pipe:score(bird) then 
                    self.score = self.score + 1
                end
                if pipe:collide(bird) then
                    gStateMachine:change('countdown')
                end
            if pipe.x < -pipe.width then
                table.remove(pipes, k)
            end
        end
        ground:update(dt)
    end
end

function ScoreState:render()
    love.graphics.setFont(flappyFont)
    
    for k, pipe in pairs(pipes) do
        pipe:render()
    end
    bird:render()
    love.graphics.print('Score: ' .. tostring(self.score), 8, 8)
    -- love.graphics.print(key_history[1], 20, 20)
    
end

function ScoreState:enter()
    SPAWN_DX = 0
    pipes={}
    self.score = 0
    math.randomseed(1)
    bird:reset()
    PAUSE = -1
    TIMER = 0
    
end

function ScoreState:exit()
    for k in pairs (pipes) do
        pipes [k] = nil
    end
    PAUSE = 1
    for k in pairs (bird.key_history) do
        bird.key_history [k] = nil
    end
    SPAWN_DX = 0
end