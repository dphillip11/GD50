Bird = Class{}

function Bird:init(image)
    self.y = WINDOW_HEIGHT/2
    self.x = WINDOW_WIDTH/2
    self.height = image:getHeight() 
    self.width = image:getWidth()
    self.dy=0
    self.dy2=1500
    
    -- these variables are for keeping track of our velocity on both the
    -- X and Y axis, since the ball can move in two dimensions
    self.dy = 0
end

function Bird:reset()
    self.x = VIRTUAL_WIDTH / 2 - 2
    self.y = VIRTUAL_HEIGHT / 2 - 2
    self.dx = 0
    self.dy = 0
end

function Bird:update(dt)
    self.dy = math.min(self.dy - self.dy2 * dt, 1000)
    self.y = math.max(0,math.min(self.y - self.dy * dt, WINDOW_HEIGHT -50))
    if self.y > WINDOW_HEIGHT -60 then
        self.dy=0
    end
    if self.y < 10 then
            self.dy=0
    end
end

function Bird:render()
    love.graphics.draw(birdI, WINDOW_WIDTH/2 - self.width/2, self.y, 0, 2, 2)
end