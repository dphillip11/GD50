push = require 'push'
Class = require 'class'
require 'bird'
require 'bgClass'
require 'pipe'

WINDOW_WIDTH = 1920
WINDOW_HEIGHT = 1080

VIRTUAL_HEIGHT = 288
VIRTUAL_WIDTH = 512

BACKGROUND_SCROLL = 30
GROUND_SCROLL =60




function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')
    love.window.setTitle('Floppy Bird')

    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        resizable = true,
        vsync = true})    

    bird = Bird('bird.png')
    background = Background('ground.png', 'background.png')
    -- pipes iterates the creation of pipe objects with the interval representing the fraction of the screen they are spaced apart 
    pipes = Pipes(0.33)
end
            

function love.update(dt)
    background:update(dt)
    bird:update(dt)
    pipes:collide(bird)
    pipes:update(dt)
end

function love.resize(w, h)
    push:resize(w, h)
    end

function love.draw()
    push:start()
    background:render()
    bird:render()
    pipes:render()
    push:finish()
end


function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end
    if key == 'space' then
        bird:space()  
    end
end