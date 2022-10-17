require 'src/Dependencies'

function love.load()

love.graphics.setDefaultFilter('nearest', 'nearest')
love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
love.window.setTitle('Breakout')
push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
    vsync = true,
    fullscreen = false,
    resizable = true
})

textures ={
['spritesheet'] = love.graphics.newImage('graphics/breakout.png'),
['background'] = love.graphics.newImage('graphics/background.png'),
['arrows'] = love.graphics.newImage('graphics/arrows.png')
}

quads = {
['bricks'] = generateQuadsBricks(),
['paddles'] = generateQuadsPaddles(),
['balls'] = generateQuadsBalls(),
['hearts'] = generateQuadsHearts(),
['arrows'] = generateQuadsArrows(),
}

sMachine = StateMachine{
    ['start'] = function() return StartState() end,
    ['play'] = function() return playState() end,
}

sMachine:change('start')

keyLog ={}

end


function love.resize(w, h)
    push:resize(w, h)
end

function love.update(dt)
    sMachine:update(dt)
end

function love.draw()
    push:apply('start')
    love.graphics.draw(textures['background'], 0, 0, 0, scaleX, scaleY)
    sMachine:render() 
    displayFPS()
    push:apply('end')
   
end

function displayFPS()
    -- simple FPS display across all states
    love.graphics.setColor(0, 1, 0, 1)
    love.graphics.print('FPS: ' .. tostring(love.timer.getFPS()), 5, 5)
end


function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    end
    keyLog[key] = true
end

function wasPressed(key)
    if keyLog[key] == true then
        return true
    else
        return false
    end
end