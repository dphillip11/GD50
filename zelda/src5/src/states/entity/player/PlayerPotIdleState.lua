-- [[
--     GD50
--     Legend of Zelda

--     Author: Colton Ogden
--     cogden@cs50.harvard.edu
-- ]]

PlayerPotIdleState = Class{__includes = EntityIdleState}

function PlayerPotIdleState:enter(params)
    
    -- render offset for spaced character sprite (negated in render function of state)
    self.entity.offsetY = 5
    self.entity.offsetX = 0
end

function PlayerPotIdleState:update(dt)
    if self.entity.pot == nil then
        self.entity:changeState('idle')
    else
        self.entity.pot.x = self.entity.x
        self.entity.pot.y = self.entity.y - (self.entity.pot.height/2)
    end
    self.entity:changeAnimation('pot-idle-' .. self.entity.direction)
    if love.keyboard.isDown('left') or love.keyboard.isDown('right') or
       love.keyboard.isDown('up') or love.keyboard.isDown('down') then
        self.entity:changeState('carrying')
    end

    if love.keyboard.wasPressed('space') then
        self.entity.pot = nil
        self.entity:changeState('walk')
    end
end