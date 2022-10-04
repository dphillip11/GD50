GROUND_SCROLL =200

local GROUND_IMAGE = love.graphics.newImage('resources/ground.png')

Ground = Class{}

function Ground:init(ground)
    self.gHeight = GROUND_IMAGE:getHeight()
    self.ground_x = 0
    self.loop_point_ground = -VIRTUAL_WIDTH
end

function Ground:update(dt)
    self.ground_x = (self.ground_x - (GROUND_SCROLL * dt))% self.loop_point_ground
end

function Ground:render()
    love.graphics.draw(GROUND_IMAGE, self.ground_x, VIRTUAL_HEIGHT-self.gHeight, 0)
end