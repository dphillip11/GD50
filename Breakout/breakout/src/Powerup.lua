Powerup = Class{}

function Powerup:init(x, y, skin)
    self.x = x
    self.width = 16
    self.y = y
    self.height = 16
    self.dy = 30
    self.dx = 0
    self.skin = skin
end

function Powerup:update(dt)
    self.x = self.x + (self.dx * dt)
    self.y = self.y + (self.dy * dt)
end

function Powerup:collide(object)
    if self.x + self.width > object.x and self.x < object.x + object.width and self. y < object.y + object.height and self.y + self.height > object.y then
        return true
    end
end

function Powerup:render()
    love.graphics.draw(gTextures['main'], gFrames['powerups'][self.skin],
        self.x, self.y)
end