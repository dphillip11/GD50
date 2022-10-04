TitleScreenState = Class{__includes = BaseState}

function TitleScreenState:init()
end

function TitleScreenState:render()
    background:render()
    ground:render()
    love.graphics.setFont(flappyFont)
    love.graphics.printf('Floppy Bird', 0, 64, VIRTUAL_WIDTH, 'center')
    love.graphics.setFont(mediumFont)
    love.graphics.printf('Press Enter', 0, 100, VIRTUAL_WIDTH, 'center')
end

function TitleScreenState:update(dt)
    background:update(dt)
    ground:update(dt)
    if love.keyboard.wasPressed('return') then
        love.keyboard.keysPressed ={}
        gStateMachine:change('play')
    end
end


function TitleScreenState:enter()
end

function TitleScreenState:exit()
end