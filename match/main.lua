--[[
    GD50
    Match-3 Remake

    Author: Colton Ogden
    cogden@cs50.harvard.edu

    Match-3 has taken several forms over the years, with its roots in games
    like Tetris in the 80s. Bejeweled, in 2001, is probably the most recognized
    version of this game, as well as Candy Crush from 2012, though all these
    games owe Shariki, a DOS game from 1994, for their inspiration.

    The goal of the game is to match any three tiles of the same variety by
    swapping any two adjacent tiles; when three or more tiles match in a line,
    those tiles add to the player's score and are removed from play, with new
    tiles coming from the ceiling to replace them.

    As per previous projects, we'll be adopting a retro, NES-quality aesthetic.

    Credit for graphics (amazing work!):
    https://opengameart.org/users/buch

    Credit for music (awesome track):
    http://freemusicarchive.org/music/RoccoW/

    Cool texture generator, used for background:
    http://cpetry.github.io/TextureGenerator-Online/
]]

-- initialize our nearest-neighbor filter
love.graphics.setDefaultFilter('nearest', 'nearest')

-- this time, we're keeping all requires and assets in our Dependencies.lua file
require 'src/Dependencies'

-- physical screen dimensions
WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

-- virtual resolution dimensions
VIRTUAL_WIDTH = 512
VIRTUAL_HEIGHT = 288

BACKGROUNDSCALE =VIRTUAL_HEIGHT/gTextures['background']:getHeight()

-- speed at which our background texture will scroll
BACKGROUND_SCROLL_SPEED = 30

function love.load()
    PAUSE = 0
    -- window bar title
    love.window.setTitle('Match 3')

    -- seed the RNG
    math.randomseed(os.time())

    -- initialize our virtual resolution
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        vsync = true,
        fullscreen = false,
        resizable = true,
        canvas = true
    })

    -- set music to loop and start
    gSounds['music']:setLooping(true)
    gSounds['music']:play()

    -- initialize state machine with all state-returning functions
    gStateMachine = StateMachine {
        ['start'] = function() return StartState() end,
        ['begin-game'] = function() return BeginGameState() end,
        ['play'] = function() return PlayState() end,
        ['game-over'] = function() return GameOverState() end
    }
    gStateMachine:change('start')

    -- keep track of scrolling our background on the X axis
    backgroundX = 0

    -- initialize input table
    love.keyboard.keysPressed = {}
end

function love.resize(w, h)
    push:resize(w, h)
end

function love.keypressed(key)
    if key == 'p' then
        PAUSE = PAUSE == 0 and 1 or 0
        if PAUSE == 1 then
            gSounds['music']:pause()
        else
            gSounds['music']:play()
        end
    end
    if PAUSE == 0 then
        -- add to our table of keys pressed this frame
        love.keyboard.keysPressed[key] = true
    end
end

function love.mousepressed()
    love.keyboard.keysPressed['return'] = true
end

function love.keyboard.wasPressed(key)
    if love.keyboard.keysPressed[key] then
        return true
    else
        return false
    end
end

function love.update(dt)
    if PAUSE == 0 then
        -- scroll background, used across all states
        backgroundX = backgroundX - BACKGROUND_SCROLL_SPEED * dt
        
        -- if we've scrolled the entire image, reset it to 0
        if backgroundX <= -(gTextures['background']:getWidth()*BACKGROUNDSCALE) then
            backgroundX = 0
        end

        gStateMachine:update(dt)

        love.keyboard.keysPressed = {}
    end
end

function love.draw()
    push:start()

    -- scrolling background drawn behind every state
    love.graphics.draw(gTextures['background'], backgroundX, 0,0, BACKGROUNDSCALE, BACKGROUNDSCALE)
    love.graphics.draw(gTextures['background'], backgroundX + (gTextures['background']:getWidth()*BACKGROUNDSCALE), 0,0, BACKGROUNDSCALE, BACKGROUNDSCALE)
    gStateMachine:render()
    if PAUSE == 1 then
        love.graphics.setColor(0,0,0,1)
        love.graphics.print('PAUSED',1,1,0,5,5.2)
        love.graphics.setColor(1,1,1,1)
        love.graphics.print('PAUSED',5,5,0,5,5)
    end
    push:finish()
end