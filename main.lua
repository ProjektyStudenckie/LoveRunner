Gamestate = require("libs.hump.gamestate")

local mainMenu = require("gamestates.mainmenu")
local level1 = require("gamestates.level1")


function love.load()
    love.window.setTitle("Love Runner")

    -- TODO: think about resolution (main menu? but default 1280x800?)
    screenWidth = 1280
    screenHeight = 800

    success = love.window.setMode( screenWidth, screenHeight)
    if(not success) then
        print("Problem with setting window dimensions.")
    end

    Gamestate.registerEvents()
    Gamestate.switch(mainMenu)
end

function love.keypressed(key) 
    -- if key == "escape" then
    --     love.event.push("quit")
    -- end
end
