PlayState = Class{__includes = BaseState}


TIMER = 0
PAUSE = -1

function PlayState:init()
    bird = Bird()
end

function PlayState:update(dt)
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
        bird:update(dt)

        for k, pipe in pairs(pipes) do
            pipe:update(dt)
                if pipe:score(bird) then 
                    self.score = self.score + 1
                end
                if pipe:collide(bird) then
                    gStateMachine:change('score', key_history)
                end
            if pipe.x < -pipe.width then
                table.remove(pipes, k)
            end
        end
        ground:update(dt)
    end
end

function PlayState:render()
    love.graphics.setFont(flappyFont)
    
    for k, pipe in pairs(pipes) do
        pipe:render()
    end
    bird:render()
    love.graphics.print('Score: ' .. tostring(self.score), 8, 8)
    
end



function PlayState:enter()
    SPAWN_DX = 0
    pipes={}
    bird.key_history = {}
    math.randomseed(1)
    bird:reset()
    self.score = 0
    PAUSE = -1
    TIMER = 0
    
      
end

function PlayState:exit()
    PAUSE = 1
    for k in pairs (pipes) do
        pipes [k] = nil
    end
    SPAWN_DX = 0
end