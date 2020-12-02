local bump = require("libs.bump.bump")
local sti = require("libs.sti.sti")
local Gamestate = require("libs.hump.gamestate")
local Class = require("libs.hump.class")
local Entities = require("entities.entities")
local camera = require("libs.camera")

local Background = require("entities.background")
local FpsDisplay = require("entities.fpsDisplay")

background = nil
fpsDisplay = nil

local LevelBase = Class{
    __includes = Gamestate,
    init = function(self, mapFile)
        self.map = sti(mapFile, { 'bump' })
        self.world = bump.newWorld(32)
        self.map:resize(love.graphics.getWidth(), love.graphics.getHeight())

        self.map:bump_init(self.world)

        Entities:enter()

        background = Background(self.world)
        fpsDisplay = FpsDisplay(self.world)

        Entities:addMany({background, fpsDisplay})
    end;
    Entities = Entities;
    camera = camera
}

function LevelBase:positionCamera(player, camera)
    local mapWidth = self.map.width * self.map.tilewidth
    local halfScreen =  love.graphics.getWidth() / 2
  
    if player.x < (mapWidth - halfScreen) then
      boundX = math.max(0, player.x - halfScreen)
    else
      boundX = math.min(player.x - halfScreen, mapWidth - love.graphics.getWidth())
    end
  
    camera:setPosition(boundX, 0)
end

function LevelBase:keypressed(key)
    if Gamestate.current() ~= pause and key == 'p' then
        Gamestate.push(pause)
    end
end

return LevelBase