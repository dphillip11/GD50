--[[
    GD50
    Legend of Zelda

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

Player = Class{__includes = Entity}

function Player:init(def)
    Entity.init(self, def)
end

function Player:update(dt)
    Entity.update(self, dt)
end

function Player:collides(target)
     local selfY, selfHeight = self.y + math.floor(self.height / 2), self.height - math.floor(self.height / 2)
    
     return not (self.x + self.width < target.x or self.x > target.x + target.width or
                 selfY + selfHeight < target.y or selfY > target.y + target.height)
end

function Player:render()
    Entity.render(self)
    
    -- love.graphics.setColor(255, 0, 255, 255)
    -- love.graphics.rectangle('line', self.x, self.y, self.width, self.height)
    -- love.graphics.setColor(255, 255, 255, 255)
end

function Player:tryLiftPot(obj)
    if obj.type ~= 'pot' then
        return false
    end
    if self.direction == 'up' then
        if obj.x > self.x - 3 and obj.x < self.x + 3 and obj.y > self.y - obj.height - 3 and obj.y < self.y + self.height - 10 then
            self.pot = obj
            return true
        else
            return false
        end
    end
    if self.direction == 'down' then
        if obj.x > self.x - 3 and obj.x < self.x + 3 and obj.y < self.y + self.height + 3 and obj.y > self.y + self.height - 3 then
            self.pot = obj
            return true
        else
            return false
        end
    end
    if self.direction == 'left' then
        if obj.x > self.x - obj.width - 3 and obj.x < self.x + 3 and obj.y > self.y and obj.y < self.y + self.height - obj.height + 3 then
            self.pot = obj
            return true
        else
            return false
        end
    end
    if self.direction == 'right' then
        if obj.x > self.x + 3 and obj.x < self.x + obj.width + 3 and obj.y > self.y and obj.y < self.y + self.height - obj.height + 3 then
            self.pot = obj
            return true
        else
            return false
        end
    end
end