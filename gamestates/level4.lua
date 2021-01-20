local Gamestate = require("libs.hump.gamestate")
local Class = require 'libs.hump.class'

local LevelBase = require 'gamestates.LevelBase'

local Entities = require("entities.entities")
local Entity = require("entities.entity")

local level4 = {}

local Background = require("entities.background")
local FpsDisplay = require("entities.fpsDisplay")
local Player = require("entities.player1")
local Enemy = require 'entities.enemy'

background = nil
fpsDisplay = nil
player = nil


local level4 = Class{
    __includes = LevelBase
}

function level4:init()
    LevelBase.init(self, "assets/levels/level4.lua")
    background = love.graphics.newImage("assets/caveBackgroundImage.jpg")
end

function level4:enter()
    player = Player(self.world, love.graphics.getWidth()/3, love.graphics.getHeight()/2, 4)
    enemy = Enemy(self.world, 1700, 250)
    enemy1 = Enemy(self.world, 1850, 250)
    enemy2 = Enemy(self.world, 2000, 250)
    LevelBase.Entities:addMany({player, enemy, enemy1, enemy2})
end

function level4:update(dt)
    if not pause then
        self.map:update(dt)
        LevelBase.Entities:update(dt)

        LevelBase.positionCamera(self, player, camera)
    end
end
  
function level4:draw()
    love.graphics.draw(background)
    camera:set()
    self.map:draw(-camera.x, -camera.y)

    LevelBase.Entities:draw()

    love.graphics.printf('THE END! CONGRATULATIONS!', love.graphics.newFont(40), 2400, 300, 500)
    love.graphics.printf('Go right to quit the game.', love.graphics.newFont(28), 2400, 400, 500)

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

return level4