BACKGROUND_SCROLL = 30

local BACKGROUND_IMAGE = love.graphics.newImage('resources/background.png')

Background = Class{}

function Background:init()
    self.background_x = 0
    self.loop_point_background= -413
end

function Background:update(dt)
    self.background_x = (self.background_x - (BACKGROUND_SCROLL * dt))% self.loop_point_background
end

function Background:render()
    love.graphics.draw(BACKGROUND_IMAGE, self.background_x, 0)
end

