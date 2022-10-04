
PIPE_SPACING = 0.3
PIPE_SPEED = 100
PIPE_GAP = 100
SPAWN_DX = 0

local PIPE_IMAGE = love.graphics.newImage('resources/pipe.png')
Pipe = Class{}

function Pipe:init()
    self.height = PIPE_IMAGE:getHeight() 
    self.width = PIPE_IMAGE:getWidth() 
    self.y = VIRTUAL_HEIGHT/2 + love.math.random(-10,PIPE_GAP-10)
    self.x = VIRTUAL_WIDTH
    self.scored = 0
end

function Pipe:update(dt)
    self.x = self.x - PIPE_SPEED * dt
end

function Pipe:render()
    love.graphics.draw(PIPE_IMAGE, self.x, self.y)
    love.graphics.draw(PIPE_IMAGE, self.x, self.y - PIPE_GAP, 0, 1, -1)
end

function Pipe:collide(bird)
    if bird.y + bird.height - 2 > self.y and bird.x + bird.width -2 > self.x and bird.x + 2 < self.x + self.width then
        return true
    end
    if bird.y + 2 < self.y - PIPE_GAP and bird.x + bird.width - 2> self.x and bird.x + 2< self.x + self.width then
        return true
    end
end

function Pipe:score(bird)
    if self.scored == 0 then
        if bird.x > self.x + self.width then
            self.scored = 1
            return true
        end
    end
    return false
    end


