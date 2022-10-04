GRAVITY = 15
JUMP = 4

Bird = Class{}
BIRD_IMAGE = love.graphics.newImage('resources/bird.png')

function Bird:init()
    self.image = BIRD_IMAGE
    self.y = VIRTUAL_HEIGHT/2
    self.x = VIRTUAL_WIDTH/2
    self.height = BIRD_IMAGE:getHeight() 
    self.width = BIRD_IMAGE:getWidth()
    self.dy = 0
    self.key_history = {}
end


function Bird:update(dt)
    self.dy = self.dy + GRAVITY * dt
    if love.keyboard.wasPressed('space') then
        self:space()     
        table.insert(self.key_history, TIMER)   
    end
    if self.y < 1 and self.dy<0 then
        self.dy=0
    end
    if self.y > VIRTUAL_HEIGHT - self.height -8 and self.dy > 0 then
        self.dy=0
    end   
    self.y = self.y + self.dy
end

function Bird:space()
    self.dy = - JUMP
end

function Bird:reset()
    self.y = VIRTUAL_HEIGHT/2
    self.dy = 0
end


function Bird:render()
    love.graphics.draw(self.image, self.x, self.y)
end

function Bird:replay(dt)
    self.dy = self.dy + GRAVITY * dt
    if self.key_history[1] and self.key_history[1] < TIMER then
            table.remove(self.key_history, 1)
            self:space()        
    end
    if self.y < 1 and self.dy<0 then
        self.dy=0
    end
    if self.y > VIRTUAL_HEIGHT - self.height -8 and self.dy > 0 then
        self.dy=0
    end   
    self.y = self.y + self.dy
end