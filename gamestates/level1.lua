bump = require 'libs.bump.bump'
Gamestate = require("libs.hump.gamestate")

local Entities = require("entities.entities")
local Entity = require("entities.entity")

local level1 = {}

local Background = require("entities.background")
local FpsDisplay = require("entities.fpsDisplay")
local Player = require("entities.player")
local Ground = require("entities.ground")

background = nil
fpsDisplay = nil
player = nil
world = nil


function level1:enter()
    world = bump.newWorld()

    Entities:enter()
    background = Background(world)
    fpsDisplay = FpsDisplay(world)
    player = Player(world, love.graphics.getWidth()/2, love.graphics.getHeight()/2)
    ground = Ground(world, 0, love.graphics.getHeight()/2, love.graphics.getWidth(), 16)

    Entities:addMany({background, fpsDisplay, player, ground})
end

function level1:update(dt)
    Entities:update(dt)
end
  
function level1:draw()
    Entities:draw()
end
  

return level1