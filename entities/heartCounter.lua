local Class = require("libs.hump.class")
local Entity = require("entities.Entity")
collectedHearts1 = 0


-- Background class inherits Entity class
local HeartCounter = Class{
    __includes = Entity
}

function HeartCounter:init(world)
    Entity.init(self, world, 0, 0, 0, 0)

    self.world:add(self, 0, 0, .1, .1)
end

function HeartCounter:draw() 
    love.graphics.setColor(1, 1, 1)
    love.graphics.print("Collected hearts: " .. tostring(collectedHearts1), 25, 30)
end

function HeartCounter:addHeart()
    collectedHearts1 = collectedHearts1 + 1
end

return HeartCounter