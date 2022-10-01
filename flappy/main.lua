push = require 'push'
Class = require 'class'
require 'bird'

WINDOW_WIDTH = 1920
WINDOW_HEIGHT = 1080

VIRTUAL_HEIGHT = 800
VIRTUAL_WIDTH = 600



function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')
    
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        resizable = true,
        vsync = true})
        background = love.graphics.newImage('background.png' )
        ground = love.graphics.newImage('ground.png' )
        background_scroll = 200
        background_x = 0
        ground_scroll =500
        ground_x = 0
        loop_point_background= -1550
        loop_point_ground = -2000
        birdI = love.graphics.newImage('bird.png' )
        bird = Bird(birdI)
    
end

function love.update(dt)
    background_x = (background_x - (background_scroll * dt))% loop_point_background
    ground_x = (ground_x - (ground_scroll * dt))% loop_point_ground
    bird:update(dt)
end

function love.resize(w, h)
    push:resize(w, h)
    end

function love.draw()
    love.graphics.draw(background, background_x, 0, 0, WINDOW_HEIGHT/background:getHeight(),WINDOW_HEIGHT/background:getHeight())
    love.graphics.draw(ground, ground_x, WINDOW_HEIGHT-(3.5*ground:getHeight()), 0, WINDOW_HEIGHT/background:getHeight(),WINDOW_HEIGHT/background:getHeight())
    bird:render()
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end
    if key == 'space' then
        bird.dy=math.min(bird.dy + 800,1200)    
    end
end