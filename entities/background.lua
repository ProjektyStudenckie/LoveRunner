local Class = require("libs.hump.class")
local Entity = require("entities.Entity")


-- Background class inherits Entity class
local Background = Class{
    __includes = Entity
}

function Background:init(world)
    Entity.init(self, world, 0, 0, 0, 0)

    self.world:add(self, 0, 0, .1, .1)
end

function Background:draw() 
    love.graphics.setBackgroundColor(80/255, 100/255, 180/255)
end

return Background