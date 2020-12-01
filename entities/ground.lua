local Class = require("libs.hump.class")
local Entity = require("entities.Entity")


-- Ground class inherits Entity class
local Ground = Class{
    __includes = Entity
}

function Ground:init(world, x, y, w, h)
    Entity.init(self, world, x, y, w, h)

    self.world:add(self, self:getRect())
end

function Ground:draw() 
    love.graphics.setColor(60/255, 80/255, 100/255)
    love.graphics.rectangle("fill", 0, love.graphics.getHeight()/2, love.graphics.getWidth(), love.graphics.getHeight())
end

return Ground