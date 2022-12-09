--[[
    GD50
    Legend of Zelda

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

PlayerPickingUpState = Class{__includes = BaseState}

function PlayerPickingUpState:init(player, dungeon)
    self.entity = player
    self.dungeon = dungeon
    self.room = self.entity.room
    -- render offset for spaced character sprite; negated in render function of state
    self.entity.offsetY = 5
    self.entity.offsetX = 0
    
end

function PlayerPickingUpState:enter(params)
    self.timer = 0
    self.entity:changeAnimation('pot-lift-' .. self.entity.direction)
    for k, object in pairs(self.room.objects) do
        if self.entity:tryLiftPot(object) then
            self.pot = object
            return
        end
    end
    if not self.entity.pot then 
        self.entity:changeState('idle')
    end
end


function PlayerPickingUpState:update(dt)
    if self.entity.pot == nil then
        self.entity:changeState('idle')
    else
        self.entity.pot.x = self.entity.x
        self.entity.pot.y = self.entity.y - (self.entity.pot.height/2)
    end
    self.timer = self.timer + dt
    if self.timer > 0.45 then
         self.entity:changeState('carrying', self.pot)
    end
end

function PlayerPickingUpState:render()
    local anim = self.entity.currentAnimation
    love.graphics.draw(gTextures[anim.texture], gFrames[anim.texture][anim:getCurrentFrame()],
        math.floor(self.entity.x - self.entity.offsetX), math.floor(self.entity.y - self.entity.offsetY))
    
    -- debug code
    -- love.graphics.setColor(255, 0, 255, 255)
    -- love.graphics.rectangle('line', self.entity.x, self.entity.y, self.entity.width, self.entity.height)
    -- love.graphics.setColor(255, 255, 255, 255)
end