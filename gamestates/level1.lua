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
    self.map:update(dt)
    LevelBase.Entities:update(dt)

    LevelBase.positionCamera(self, player, camera)
end
  
function level1:draw()
    camera:set()
    self.map:draw(-camera.x, -camera.y)

    LevelBase.Entities:draw()

    camera:unset()
end


function level1:keypressed(key)
    LevelBase:keypressed(key)
end


return level1