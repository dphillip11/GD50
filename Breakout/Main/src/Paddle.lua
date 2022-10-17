Paddle = Class{}

function Paddle:init(skin)
    self.skin = skin
    self.x = VIRTUAL_WIDTH / 2 - 32
    self.dx = 0
    self.width = 64
    self.height = 16
    self.size = 2
    self.y = VIRTUAL_HEIGHT - 32
end

function Paddle:update(dt)
    -- keyboard input
    if love.keyboard.isDown('left') then
        self.dx = -PADDLE_SPEED
    elseif love.keyboard.isDown('right') then
        self.dx = PADDLE_SPEED
    else
        self.dx = 0
    end
    if self.dx < 0 then
        self.x = math.max(0, self.x + self.dx * dt)
    else
        self.x = math.min(VIRTUAL_WIDTH - self.width, self.x + self.dx * dt)
    end
end

function Paddle:render()
    love.graphics.draw(textures['spritesheet'], quads['paddles'][(self.skin - 1) * 4 + (self.size)],
        self.x, self.y)
end