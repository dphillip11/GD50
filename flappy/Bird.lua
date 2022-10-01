Bird = Class{}

function Bird:init(image)
    self.image = love.graphics.newImage(image)
    self.y = VIRTUAL_HEIGHT/2
    self.x = VIRTUAL_WIDTH/2
    self.height = self.image:getHeight() 
    self.width = self.image:getWidth()
    self.dy = 0
    self.dy2 = 15
    
    -- these variables are for keeping track of our velocity on both the
    -- X and Y axis, since the ball can move in two dimensions
    self.dy = 0
end

function Bird:reset()
    self.x = VIRTUAL_WIDTH / 2 - 0.5*self.width
    self.y = VIRTUAL_HEIGHT / 2 - 0.5*self.height
    self.dx = 0
    self.dy = 0
end

function Bird:update(dt)
    self.dy = self.dy + self.dy2 * dt
    if self.y < 1 and self.dy<0 then
        self.dy=0
    end
    if self.y > VIRTUAL_HEIGHT - self.height -8 and self.dy > 0 then
        self.dy=0
    end
    self.y = self.y + self.dy
end

function Bird:space()
    bird.dy=bird.dy - 6 
end

function Bird:render()
    love.graphics.draw(self.image, self.x, self.y)
end