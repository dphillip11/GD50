glidingSquare = Class{}

function glidingSquare:init()
    self.width = 100
    self.height = 100
    self.y = 0
    self.x = math.random(WINDOW_WIDTH - self.height)
    self.red = math.random()
    self.green = math.random()
    self.blue = math.random()
    self.glideX = Glide({0, math.random(WINDOW_WIDTH - self.width), math.random(WINDOW_WIDTH - self.width), math.random(WINDOW_WIDTH - self.width)}, 10 * math.random())
    self.glideY = Glide({0, math.random(WINDOW_HEIGHT - self.height), math.random(WINDOW_HEIGHT - self.height), math.random(WINDOW_HEIGHT - self.height)}, 10 * math.random())
    self.A = 1 
    self.glideA = Glide({0, 1}, 10 * math.random())
end

function glidingSquare:update(dt)
    self.A = self.glideA:update(dt)
    self.x = self.glideX:update(dt)
    self.y = self.glideY:update(dt)
end

function glidingSquare:render()
    love.graphics.setColor(self.red,self.green,self.blue, self.A)
    love.graphics.rectangle( "fill", self.x, self.y, self.width, self.height)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.print('square', self.x, self.y, 0 ,2,2)
end


 
