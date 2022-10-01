Pipe = Class{}
PIPE_SPEED = 2


function Pipe:init(image, offset)
    self.image = love.graphics.newImage(image)
    self.height = self.image:getHeight() 
    self.width = self.image:getWidth()
    self.offset = offset
    self.y = VIRTUAL_HEIGHT/2 + 50 + love.math.random(-50,50)
    self.x = VIRTUAL_WIDTH * (1 + self.offset)
   
end

function Pipe:update(dt)
    self.x = self.x - PIPE_SPEED 
    if self.x < 0 - self.width then
        self.x =  VIRTUAL_WIDTH
        self.y = VIRTUAL_HEIGHT/2 + 50 + love.math.random(-50,50)
    end
end

function Pipe:render()
    love.graphics.draw(self.image, self.x, self.y)
    love.graphics.draw(self.image, self.x + self.width, self.y - 100, 3.1459)
end

function Pipe:collide(bird)
    if bird.y + bird.height > self.y and bird.x + bird.width > self.x and bird.x < self.x + self.width then
        PIPE_SPEED = 0
        BACKGROUND_SCROLL = 0
        GROUND_SCROLL = 0
        return true
    end
    if bird.y < self.y - 100 and bird.x + bird.width > self.x and bird.x < self.x + self.width then
        PIPE_SPEED = 0
        BACKGROUND_SCROLL = 0
        GROUND_SCROLL = 0
        return true
    end
end



Pipes = Class{}

function Pipes:init(spacing)
    self.pipeCount = 0
    self.spacing = spacing
    self.pipes={}
    local value = spacing
    while true do
        self.pipes[self.pipeCount] = Pipe('pipe.png', value)
        self.pipeCount = self.pipeCount + 1
        value = value + self.spacing
        if value > 1.1 then
            break 
        end
    end  
end

function Pipes:update(dt)
    local i =0
    while true do
        self.pipes[i]:update()
        i = i + 1
        if i == self.pipeCount then
            break 
        end
    end
end

function Pipes:render()
local i =0
    while true do
        self.pipes[i]:render()
        i = i + 1
        if i == self.pipeCount then
            break 
        end
    end
end

function Pipes:collide(bird)
    local i =0
    while true do
        if self.pipes[i]:collide(bird) then
            return true
        end
        i = i + 1
        if i == self.pipeCount then
            break 
        end
    end
end