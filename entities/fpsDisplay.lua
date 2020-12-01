local Class = require("libs.hump.class")
local Entity = require("entities.Entity")


-- Background class inherits Entity class
local FpsDisplay = Class{
    __includes = Entity
}

function FpsDisplay:init(world)
    Entity.init(self, world, 0, 0, 0, 0)

    self.world:add(self, 0, 0, .1, .1)
end

function FpsDisplay:draw() 
    love.graphics.setColor(1, 1, 1)
    love.graphics.print("FPS: " .. tostring(love.timer.getFPS()), 10, 10)
end

return FpsDisplay