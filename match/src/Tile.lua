--[[
    GD50
    Match-3 Remake

    -- Tile Class --

    Author: Colton Ogden
    cogden@cs50.harvard.edu

    The individual tiles that make up our game board. Each Tile can have a
    color and a variety, with the varietes adding extra points to the matches.
]]

Tile = Class{}

function Tile:init(x, y, color, variety)
    
    -- board positions
    self.gridX = x
    self.gridY = y

    -- coordinate positions
    self.x = (self.gridX - 1) * 32
    self.y = (self.gridY - 1) * 32

    -- tile appearance/points
    self.color = color
    self.variety = variety
    self.shiny=0
    if math.random(1,10) == 1 then
        self.shiny=1
    end
    self.interval=0
end

function Tile:updatePosition()
    self.x = (self.gridX - 1) * 32
    self.y = (self.gridY - 1) * 32
end


function Tile:render(x, y)
    
    -- draw shadow
    
    -- love.graphics.setColor(34, 32, 52, 255)
    -- love.graphics.draw(gTextures['main'], gFrames['tiles'][self.color][self.variety],self.x + x + 2, self.y + y + 2)

    -- draw tile itself
    love.graphics.setColor(255, 255, 255, 255) 
    love.graphics.draw(gTextures['main'], gFrames['tiles'][self.color][self.variety],
        self.x + x, self.y + y)
    -- show bomb image
    self.interval = (self.interval + 1)% 60 
    if self.shiny == 1 and self.interval< 20 then
        love.graphics.draw(gTextures['bomb'], self.x + x, self.y + y)
    end
    
    
end