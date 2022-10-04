push = require 'push'
Class = require 'class'
require 'bird'
require 'background'
require 'pipe'
require 'ground'
require '.states.PlayState'
require 'floppy.StateMachine'
require 'floppy.states.CountdownState'
require 'floppy.states.TitleScreenState'
require 'floppy.states.BaseState'
require 'floppy.states.ScoreState'

WINDOW_WIDTH = 900
WINDOW_HEIGHT = 600
VIRTUAL_HEIGHT = 288
VIRTUAL_WIDTH = 512



function love.load()
    
    love.graphics.setDefaultFilter('nearest', 'nearest')
    love.window.setTitle('Floppy Bird')

    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        resizable = true,
        vsync = true})    

    smallFont = love.graphics.newFont('resources/font.ttf', 8)
    mediumFont = love.graphics.newFont('resources/flappy.ttf', 14)
    flappyFont = love.graphics.newFont('resources/flappy.ttf', 28)
    hugeFont = love.graphics.newFont('resources/flappy.ttf', 56)
    love.graphics.setFont(flappyFont)

    
    background = Background()
    ground = Ground() 
    love.keyboard.keysPressed = {}

    gStateMachine = StateMachine {
        ['title'] = function() return TitleScreenState() end,
        ['countdown'] = function() return CountdownState() end,
        ['play'] = function() return PlayState() end,
        ['score'] = function() return ScoreState() end
    }
    gStateMachine:change('title')
    
end  

function love.update(dt)
   gStateMachine:update(dt)
   love.keyboard.keysPressed = {}
end

function love.resize(w, h)
    push:resize(w, h)
    end

function love.draw()
    push:start()
    background:render()
    gStateMachine:render()
    ground:render()
    
    
    push:finish()
end


function love.keypressed(key)
    love.keyboard.keysPressed[key] = true
    if key == 'escape' then
        love.event.quit()
    end
end

function love.mousepressed()
    love.keyboard.keysPressed['space'] = true
end


function love.keyboard.wasPressed(key)
    return love.keyboard.keysPressed[key]
end
