local Gamestate = require("libs.hump.gamestate")
local Class = require 'libs.hump.class'

local LevelBase = require 'gamestates.LevelBase'

local Entities = require("entities.entities")
local Entity = require("entities.entity")

local level1 = {}

local Background = require("entities.background")
local FpsDisplay = require("entities.fpsDisplay")
local Player = require("entities.player1")
local Enemy = require 'entities.enemy'
local Heart = require 'entities.heart'

background = nil
fpsDisplay = nil
player = nil


local level1 = Class{
    __includes = LevelBase
}

function level1:init()
    LevelBase.init(self, "assets/levels/tutorialMap.lua")
    background = love.graphics.newImage("assets/backgroundImage.png")

    -- Music downloaded from this link
    -- https://freesound.org/people/ShadyDave/sounds/325647/
    -- Created by ShadyDave
    music = love.audio.newSource('assets/sound/backgroundMusic.mp3', 'stream')
    music:setVolume(0.15)
    music:setLooping( true )
    music:play()
end

function level1:enter()
    player = Player(self.world, love.graphics.getWidth()/3, love.graphics.getHeight()/2, 1)
    enemy = Enemy(self.world, 2100, 200)
    enemy1 = Enemy(self.world, 2400, 200)
    enemy2 = Enemy(self.world, 1500, 200)
    heart1 = Heart(self.world, 950, 0)
    heart2 = Heart(self.world, 1600, -500)
    LevelBase.Entities:addMany({player, enemy, enemy1, enemy2, heart1, heart2})
end

function level1:update(dt)
    if not pause then
        self.map:update(dt)
        LevelBase.Entities:update(dt)

        LevelBase.positionCamera(self, player, camera)
    end
end
  
function level1:draw()
    love.graphics.draw(background)
    camera:set()
    
    self.map:draw(-camera.x, -camera.y)

    LevelBase.Entities:draw()

    love.graphics.print('WELCOME IN LOVE RUNNER', 300, 100)
    love.graphics.print('Use arrows or WASD to move your character.', 300, 120)

    love.graphics.print('Use platforms to get to the finish line.', 300, 135)

    love.graphics.print('Jump over your enemies!', 1700, 100)

    love.graphics.print('Colected hearts: ' .. tostring(Heart.colectedHearts), 3000, 200)

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

return level1