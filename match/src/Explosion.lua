Explosion = Class{}

function Explosion:init(orientation, indexX, indexY)
    self.cImg = gTextures['explosion']
    self.cTmp = love.graphics.newParticleSystem(self.cImg, 200)

    if orientation == 'horizontal' then
        self.x = VIRTUAL_WIDTH - 272 + 128
        self.y = 32 + ((indexY - 1) * 32)
        self.cTmp:setEmissionArea( 'uniform', 128, 16, 0, true)
    end	
    if orientation == 'vertical' then
        self.x = VIRTUAL_WIDTH - 272 + ((indexX - 1)*32) + 16
        self.y = 16 + 128
        self.cTmp:setEmissionArea( 'uniform', 16, 128, 0, true)
    end
    self.cTmp:setEmissionRate(2000) 	
    self.cTmp:setEmitterLifetime(0.1)
    self.cTmp:setLinearAcceleration(1,1,1,1) 	
    self.cTmp:setParticleLifetime(0.1) 	 	
    self.cTmp:setSpeed(10, 10) 		
    self.cTmp:setSizes(0.01, 0.1) 	
    self.cTmp:setSizeVariation(0.5)
end

function Explosion:update(dt)
    self.cTmp:update(dt)
end

function Explosion:render()
    love.graphics.draw(self.cTmp, self.x, self.y)
end