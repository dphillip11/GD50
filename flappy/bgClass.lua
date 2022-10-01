Background = Class{}


function Background:init(ground, background)
    self.background = love.graphics.newImage(background )
    self.ground = love.graphics.newImage(ground)
    self.bgHeight = self.background:getHeight()
    self.gHeight = self.ground:getHeight()
    self.bgWidth = self.background:getWidth()
    self.gWidth = self.ground:getWidth()
    self.background_scroll = 30
    self.background_x = 0
    self.ground_scroll =60
    self.ground_x = 0
    self.loop_point_background= -413
    self.loop_point_ground = -VIRTUAL_WIDTH
end

function Background:update(dt)
    self.background_x = (self.background_x - (self.background_scroll * dt))% self.loop_point_background
    self.ground_x = (self.ground_x - (self.ground_scroll * dt))% self.loop_point_ground
end

function Background:render()
    love.graphics.draw(self.background, self.background_x, 0)
    love.graphics.draw(self.ground, self.ground_x, VIRTUAL_HEIGHT-self.gHeight, 0)
end
