CountdownState = Class{__includes = BaseState}

function CountdownState:init()
    self.timer = 3
end

function CountdownState:render()
    love.graphics.setFont(hugeFont)
    love.graphics.printf(self.timer + 1 - (self.timer % 1), 0, 120, VIRTUAL_WIDTH, 'center')
end

function CountdownState:update(dt)
    self.timer = self.timer - dt
    if self.timer < 0 then
        gStateMachine:change('play')
    end
end


function CountdownState:enter()
    self.timer = 3
end

function CountdownState:exit()
    -- having trouble with replays so this is experimental, probably unnecessary
    SPAWN_DX = 0
end