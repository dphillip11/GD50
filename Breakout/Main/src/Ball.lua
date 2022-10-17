Ball = Class{}

function Ball:init()
    self.x = VIRTUAL_WIDTH / 2
    self.y = VIRTUAL_HEIGHT
    self.dx = -1
    self.dy = -1
    self.speed = 150 
    self.width = 8
    self.height = 8
    self.inPlay = 0
    self.skin = 1
end

function Ball:update(dt)
    if self.inPlay == 0 then
        self.x = paddle.x + paddle.width/2 - 4
        self.y = paddle.y - self.height
    else 
        self.x = self.x + self.dx * dt * self.speed
        self.y = self.y + self.dy * dt * self.speed
    end
    self:collision(dt)
    
end

function Ball:collision(dt)
    -- x boundary hit
    if self.x < 0 or ball.x > VIRTUAL_WIDTH - self.width then
        self:reboundX(dt)
    end
    -- above upper boundary
    if self.y < 0 then
        self:reboundY(dt)
        
    end
    -- below lower bound
    if self.y > VIRTUAL_HEIGHT then
        self.inPlay = 0
        self.dy = self.dy * -1
        self.skin = (self.skin) % 7 + 1
    end
    if self.y + self.height / 2 > paddle.y and self.y + self.height / 2 < paddle.y + paddle.height and self.x + self.width > paddle.x and self.x < paddle.x + paddle.width then
        self:reboundY(dt)
        self.dx = (1 + math.abs((paddle.x + paddle.width/2)-(self.x + self.width/2))/(0.5 * paddle.width)) * self.dx/(math.abs(self.dx))
        if self.x > paddle.x + paddle.width - 8 or self.x < paddle.x then
            self:reboundX(dt)
        end
    end
end

function Ball:collide(object)
    if ball.x + ball.width > object.x  and ball.x < object.x + object.width and ball.y + ball.height > object.y and ball.y < object.y + object.height then
        if ball.x < object.x or ball.x > object.x + object.width - 8 then
            return 'x'
        else
            return 'y'
        end
    end
end

function Ball:reboundX(dt)
    self.x = self.x - (self.dx * dt * self.speed)
    self.dx = self.dx * - 1
end

function Ball:reboundY(dt)
    self.y = self.y - (self.dy * dt * self.speed)
    self.dy = self.dy * - 1
end


function Ball:render()
    love.graphics.draw(textures['spritesheet'], quads['balls'][self.skin], self.x, self.y)
end

