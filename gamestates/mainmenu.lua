local Gamestate = require("libs.hump.gamestate")
local Class = require 'libs.hump.class'

local level1 = require("gamestates.level4")


local
function createButton(title, fn)
    return {
        title = title,
        fn = fn,
    }
end

local buttons = {}
local font = nil

local mainMenu = {}


function mainMenu:init()

    font = love.graphics.newFont(28)
    
    table.insert(buttons, 
        createButton("Play", 
        function()
            Gamestate.switch(level1)
        end))

    table.insert(buttons, 
        createButton("Quit", 
        function()
            love.event.push("quit")
        end))

end

function mainMenu:update()

end

function mainMenu:draw()
    local w, h = love.graphics.getWidth(), love.graphics.getHeight()

    local btn_width = w * .2
    local btn_height = 50
    local btn_margin = 12

    local total_height = (btn_height + btn_margin) * #buttons

    love.graphics.setBackgroundColor(80/255, 80/255, 140/255)
    love.graphics.setColor(.8, .4, .4)
    love.graphics.printf('LOVE RUNNER', love.graphics.newFont(44), 0, h/2 - total_height - 80, w, 'center')
    love.graphics.setColor(1, 1, 1)
    love.graphics.printf('MAIN MENU', font, 0, h/2 - total_height, w, 'center')

    for i, btn in ipairs(buttons) do
        local posX = (w * .5) - (btn_width * .5)
        local posY = (h * .5) - (total_height * .5) + ((btn_height + btn_margin) * (i-1))

        local color = {.8, .4, .4}

        local mX, mY = love.mouse.getPosition()

        local hover = mX > posX and mX < posX + btn_width and
                      mY > posY + 2 and mY < posY + 2 + btn_height

        if hover then
            color = {1, .6, .6}
        end

        love.graphics.setColor(unpack(color))
        love.graphics.rectangle(
            "fill", 
            posX, 
            posY,
            btn_width,
            btn_height
        )

        love.graphics.setColor(1, 1, 1)
        love.graphics.printf(
            btn.title, 
            font, 
            0, 
            posY + (font:getHeight(btn.title)/4), 
            w, 
            'center'
        )
        
        if hover and love.mouse.isDown(1) then
            btn.fn()
        end

    end
end


function mainMenu:keypressed(key)
    if key == 'return' then
        Gamestate.switch(level1)
    end
end


return mainMenu
