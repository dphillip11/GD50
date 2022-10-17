Brick = Class{}

function Brick:init(x, y, skin)
    self.x = x
    self.y = y
    self.width = 32
    self.height = 16
    self.skin = skin
end

function Brick:update(dt)
    if ball:collide(self) == 'y' then
        ball:reboundY(dt)
        self.skin = self.skin - 4
    else
        if ball:collide(self) == 'x'  then
            ball:reboundX(dt)
            self.skin = self.skin - 4
        end
    end
end

function Brick:render()
    if self.skin > -1 then
        love.graphics.draw(textures['spritesheet'], quads['bricks'][self.skin], self.x, self.y)
    end
end

