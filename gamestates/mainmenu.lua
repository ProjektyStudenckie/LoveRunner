local Gamestate = require("libs.hump.gamestate")
local Class = require 'libs.hump.class'

local level1 = require("gamestates.level1")

local mainMenu = {}

function mainMenu:update()

end

function mainMenu:draw()
    local w, h = love.graphics.getWidth(), love.graphics.getHeight()

    love.graphics.setBackgroundColor(80/255, 80/255, 140/255)
    love.graphics.setColor(1, 1, 1)
    love.graphics.printf('MAIN MENU', 0, h/2 - 10, w, 'center')
    love.graphics.printf('PRESS "Enter" TO START THE GAME', 0, h/2 + 10, w, 'center')
end


function mainMenu:keypressed(key)
    if key == 'return' then
        Gamestate.switch(level1)
    end
end


return mainMenu
