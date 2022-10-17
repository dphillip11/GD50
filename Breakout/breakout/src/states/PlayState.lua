--[[
    GD50
    Breakout Remake

    -- PlayState Class --

    Author: Colton Ogden
    cogden@cs50.harvard.edu

    Represents the state of the game in which we are actively playing;
    player should control the paddle, with the ball actively bouncing between
    the bricks, walls, and the paddle. If the ball goes below the paddle, then
    the player should lose one point of health and be taken either to the Game
    Over screen if at 0 health or the Serve screen otherwise.
]]

PlayState = Class{__includes = BaseState}

--[[
    We initialize what's in our PlayState via a state table that we pass between
    states as we go from playing to serving.
]]
function PlayState:enter(params)
    self.paddle = params.paddle
    self.bricks = params.bricks
    self.health = params.health
    self.score = params.score
    self.highScores = params.highScores
    self.ball = params.ball
    self.level = params.level
    self.powerups = {}
    self.recoverPoints = 4000
    self.extraBalls ={}
    -- give ball random starting velocity
    self.ball.dx = math.random(-200, 200)
    self.ball.dy = math.random(-50, -60)
end

function PlayState:update(dt)
    if self.paused then
        if love.keyboard.wasPressed('space') then
            self.paused = false
            gSounds['pause']:play()
        else
            return
        end
    elseif love.keyboard.wasPressed('space') then
        self.paused = true
        gSounds['pause']:play()
        return
    end

    -- update positions based on velocity
    self.paddle:update(dt)
    self.ball:update(dt)
    for k, ball in pairs(self.extraBalls) do
        ball:update(dt)
    end
    for k, powerup in pairs(self.powerups) do
        powerup:update(dt)
        if powerup:collide(self.paddle) then
            gSounds['confirm']:play()
            if powerup.skin == 9 then
                table.remove(self.powerups, k)
                for n = 1,2 do
                    extraBall = Ball(6)
                    extraBall.x = self.paddle.x + self.paddle.width/2
                    extraBall.y = self.paddle.y 
                    extraBall.dx = math.random(-200, 200)
                    extraBall.dy = math.random(-50, -60)
                    table.insert(self.extraBalls, extraBall)
                end
            end
            if powerup.skin == 10 then
                table.remove(self.powerups, k)
                self.paddle.haveKey = 1
            end
        end
    end


    if self.ball:collides(self.paddle) then

        self.ball:reboundP(self.paddle)     
        gSounds['paddle-hit']:play()
        
    end
    for k, ball in pairs(self.extraBalls) do
        if ball:collides(self.paddle) then
            
            ball:reboundP(self.paddle)           
            gSounds['paddle-hit']:play()
        end
    end
    
    -- detect collision across all bricks with the ball
    for k, brick in pairs(self.bricks) do
        for k, extraBall in pairs(self.extraBalls) do
            if brick.inPlay and extraBall:collides(brick) then
                self.score = self.score + (brick.tier * 200 + brick.color * 25)
                brick:hit(self)
                if self:checkVictory() then
                    self.paddle.haveKey = 0
                    self.paddle.keyTimer = 30

                    gSounds['victory']:play()
    
                    gStateMachine:change('victory', {
                        level = self.level,
                        paddle = self.paddle,
                        health = self.health,
                        score = self.score,
                        highScores = self.highScores,
                        ball = self.ball,
                        recoverPoints = self.recoverPoints
                    })
                end
                extraBall:reboundB(brick)

            end
        end
        -- only check collision if we're in play
        if brick.inPlay and self.ball:collides(brick) then

            -- add to score
            self.score = self.score + (brick.tier * 200 + brick.color * 25)

            -- trigger the brick's hit function, which removes it from play
            brick:hit(self)


            -- if we have enough points, recover a point of health
            if self.score > self.recoverPoints then
                -- can't go above 3 health
                self.health = math.min(3, self.health + 1)

                self.paddle.size = math.min(4, self.paddle.size + 1)
                self.paddle.width = self.paddle.size * 32

                -- multiply recover points by 2
                self.recoverPoints = self.recoverPoints + math.min(100000, self.recoverPoints * 2)

                -- play recover sound effect
                gSounds['recover']:play()
            end

            -- go to our victory screen if there are no more bricks left
            if self:checkVictory() then
                self.paddle.haveKey = 0
                gSounds['victory']:play()

                gStateMachine:change('victory', {
                    level = self.level,
                    paddle = self.paddle,
                    health = self.health,
                    score = self.score,
                    highScores = self.highScores,
                    ball = self.ball,
                    recoverPoints = self.recoverPoints
                })
            end

            if math.random(0,10) > 9 then
                table.insert(self.powerups, Powerup(brick.x + 16, brick.y + 8, 9))
            end
            if self.paddle.haveKey == 0 and math.random(0,10) > 9 then
                table.insert(self.powerups, Powerup(brick.x + 16, brick.y + 8, 10))
            end

            self.ball:reboundB(brick)
            
            break
        end
    end

    -- if ball goes below bounds, revert to serve state and decrease health
    if self.ball.y >= VIRTUAL_HEIGHT then
        self.health = self.health - 1
        self.paddle.size = math.max(1, self.paddle.size - 1)
        self.paddle.width = self.paddle.size * 32
        gSounds['hurt']:play()

        if self.health == 0 then
            gStateMachine:change('game-over', {
                score = self.score,
                highScores = self.highScores
            })
        else
            gStateMachine:change('serve', {
                paddle = self.paddle,
                bricks = self.bricks,
                health = self.health,
                score = self.score,
                highScores = self.highScores,
                level = self.level,
                recoverPoints = self.recoverPoints
            })
        end
    end

    -- for rendering particle systems
    for k, brick in pairs(self.bricks) do
        brick:update(dt)
    end

    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end
end

function PlayState:render()
    
    -- render bricks
    for k, brick in pairs(self.bricks) do
        brick:render()
    end
    for k, ball in pairs(self.extraBalls) do
        ball:render()
    end

    -- render all particle systems
    for k, brick in pairs(self.bricks) do
        brick:renderParticles()
    end

    self.paddle:render()
    
    for k, powerup in pairs(self.powerups) do
        powerup:render()
    end
    self.ball:render()

    renderScore(self.score)
    renderHealth(self.health)

    -- pause text, if paused
    if self.paused then
        love.graphics.setFont(gFonts['large'])
        love.graphics.printf("PAUSED", 0, VIRTUAL_HEIGHT / 2 - 16, VIRTUAL_WIDTH, 'center')
    end
end

function PlayState:checkVictory()
    for k, brick in pairs(self.bricks) do
        if brick.inPlay then
            return false
        end 
    end

    return true
end