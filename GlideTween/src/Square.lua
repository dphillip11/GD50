Square = Class{}

function Square:init(x, y, color)
    self.x = x
    self.y = y
    self.width = 98
    self.height = 98
    self.pathCursor = 1
    self.color = color
    self.alpha = 1
    self.inTransit = 0
    self.glideX = 0
    self.glideY = 0
end

function Square:update(dt)
    if self.glideX == 0 then
    else
        self.x = self.glideX:update(dt)
        if self.glideX.stopped == 1 then
            self.inTransit = 0
            self.glideX = 0
        end
    end
    if self.glideY == 0 then
    else
        self.y = self.glideY:update(dt)
        if self.glideY.stopped == 1 then
            self.inTransit = 0
            self.glideY = 0
        end
    end
end

function Square:render()
    love.graphics.setColor(self.color[1],self.color[2],self.color[3],self.alpha)
    love.graphics.rectangle( "fill", self.x, self.y, self.width, self.height, 10)
    love.graphics.setColor(1, 1, 1, 1)
end


 
