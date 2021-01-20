local Gamestate = require("libs.hump.gamestate")
local Class = require 'libs.hump.class'

local LevelBase = require 'gamestates.LevelBase'

local Entities = require("entities.entities")
local Entity = require("entities.entity")

local level2 = {}

local Background = require("entities.background")
local FpsDisplay = require("entities.fpsDisplay")
local Player = require("entities.player1")
local Enemy = require 'entities.enemy'

background = nil
fpsDisplay = nil
player = nil


local level2 = Class{
    __includes = LevelBase
}

function level2:init()
    LevelBase.init(self, "assets/levels/level2.lua")
end

function level2:enter()
    player = Player(self.world, love.graphics.getWidth()/3, love.graphics.getHeight()/2, 2)
    enemy = Enemy(self.world, 850, 300)
    enemy1 = Enemy(self.world, 1250, 300)
    enemy2 = Enemy(self.world, 2550, 300)
    LevelBase.Entities:addMany({player, enemy, enemy1, enemy2})
end

function level2:update(dt)
    if not pause then
        self.map:update(dt)
        LevelBase.Entities:update(dt)

        LevelBase.positionCamera(self, player, camera)
    end
end
  
function level2:draw()
    camera:set()
    self.map:draw(-camera.x, -camera.y)

    LevelBase.Entities:draw()

    camera:unset()

    

    if pause then
        local w, h = love.graphics.getWidth(), love.graphics.getHeight()

        love.graphics.setColor(0, 0, 0, .5)
        love.graphics.rectangle('fill', 0, 0, w, h)
        love.graphics.setColor(1, 1, 1)
        love.graphics.printf('PAUSE', 0, h/2 - 40, w, 'center')
        love.graphics.printf('Press [esc] again to resume.', 0, h/2, w, 'center')
        love.graphics.printf('Press [enter] to quit.', 0, h/2 + 20, w, 'center')
    end
end

return level2