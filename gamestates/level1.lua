local Gamestate = require("libs.hump.gamestate")
local Class = require 'libs.hump.class'

local LevelBase = require 'gamestates.LevelBase'

local Entities = require("entities.entities")
local Entity = require("entities.entity")

local level1 = {}

local Background = require("entities.background")
local FpsDisplay = require("entities.fpsDisplay")
local Player = require("entities.player")

background = nil
fpsDisplay = nil
player = nil
world = nil

pause = false

local level1 = Class{
    __includes = LevelBase
}


function level1:init()
    LevelBase.init(self, "assets/levels/map1.lua")
end

function level1:enter()
    player = Player(self.world, love.graphics.getWidth()/2, love.graphics.getHeight()/2)

    LevelBase.Entities:addMany({player})
end

function level1:update(dt)
    if not pause then
        self.map:update(dt)
        LevelBase.Entities:update(dt)

        LevelBase.positionCamera(self, player, camera)
    end
end
  
function level1:draw()
    camera:set()
    self.map:draw(-camera.x, -camera.y)

    LevelBase.Entities:draw()

    camera:unset()

    if pause then
        local w, h = love.graphics.getWidth(), love.graphics.getHeight()

        love.graphics.setColor(0, 0, 0, .5)
        love.graphics.rectangle('fill', 0, 0, w, h)
        love.graphics.setColor(1, 1, 1)
        love.graphics.printf('PAUSE', 0, h/2, w, 'center')
    end
end


function level1:keypressed(key)
    if key == 'escape' then
        if pause then
            pause = false
        else
            pause = true
        end
    end
end


return level1