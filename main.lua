
require "player"
require "animation"

function love.load()
    love.window.setTitle("Love Runner")

    -- TODO: think about resolution (main menu? but default 1280x800?)
    screenWidth = 1280
    screenHeight = 800

    success = love.window.setMode( screenWidth, screenHeight)
    if(not success) then
        print("Problem with setting window dimensions.")
    end

    player:load(screenWidth, screenHeight)
end


function love.update(dt)
    player:physics(dt)
    player:update(dt)
end

function love.draw()
    love.graphics.setBackgroundColor(80/255, 100/255, 180/255)

    love.graphics.setColor(1, 1, 1)
    love.graphics.print("FPS: " .. tostring(love.timer.getFPS()), 10, 10)

    player:draw()

    love.graphics.setColor(60/255, 80/255, 100/255)
    love.graphics.rectangle("fill", 0, love.graphics.getHeight()/2, love.graphics.getWidth(), love.graphics.getHeight())
end

function love.keypressed(key)
    if key == "escape" then
        love.event.push("quit")
    end
end
