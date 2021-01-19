local Class = require("libs.hump.class")
local Entity = require("entities.Entity")

local enemy = Class{
    __includes = Entity
}

function enemy:init(world, x, y) 
    self.img = love.graphics.newImage("assets/character_block.png")

    Entity.init(self, world, x, y, self.img:getWidth(), self.img:getHeight())

    self.xRelativeVelocity = 0
    self.xVelocity = 0 -- current velocity on x, y axes
    self.yVelocity = 0
    self.acc = 100000 -- the acceleration of our player
    self.brakeAccel = 500
    self.maxSpeed = 5000 -- the top speed
    self.gravity = 1000 -- we will accelerate towards the bottom

    self.defaultX = self.x
    self.moveSpan = 50 -- how far sideways enemy moves
    self.initSideMove = true

    self.colisionMsg = "no"

    self.world:add(self, self:getRect())
end

function enemy:collisionFilter(other)
    local x, y, w, h = self.world:getRect(other)
    local playerBottom = self.y + self.h
    local otherBottom = y + h
  
    --if playerBottom <= y then -- bottom of player collides with top of platform.
      return 'slide'
    --end
  end

  function enemy:changeVelocityByCollisionNormal(col)
    local other, normal = col.other, col.normal
    local nx, ny        = normal.x, normal.y
    local vx, vy        = self.xVelocity, self.yVelocity
  
    if other.xVelocity and ((nx < 0 and vx > 0) or (nx > 0 and vx < 0)) then
      self.xVelocity = other.xVelocity
      self.xRelativeVelocity  = other.xVelocity
      self.colisionMsg = "yes"
      other.y = 200
      other.x = 100
     

    else 
      self.colisionMsg = "no"
    end 
  
    if other.yVelocity and ((ny < 0 and vy > 0) or (ny > 0 and vy < 0)) then
      self.yVelocity = math.max(0, other.yVelocity)
    end
  end

  function enemy:setGround(other)
    self.ground = other
    self.y = self.ground.y - self.h
    self.world:update(self, self.x, self.y)
  end

  function enemy:checkIfOnGround(ny, other)
    if ny < 0 then
      self.ground = other
    end
  end

  function enemy:move(dt)
    local world = self.world
  
    local goalX = self.x + self.xVelocity * dt
    local goalY = self.y + self.yVelocity * dt
  
    local actualX, actualY, collisions, len = world:check(self, goalX, goalY, self.filter)
  
    for i, col in ipairs(collisions) do
      self:changeVelocityByCollisionNormal(col)
      self:checkIfOnGround(col.normal.y, col.other)
    end
  
    self.x, self.y = actualX, actualY
    world:update(self, actualX, actualY)
  end

  function enemy:update(dt, index)
    if not self.ground then
        self.yVelocity = self.yVelocity + self.gravity * dt
    else
        if self.initSideMove then
            self.xVelocity = self.xVelocity + self.acc * dt
            self.initSideMove = false
        end

        if self.x < self.defaultX - self.moveSpan then
           self.xVelocity = self.xVelocity + self.acc * dt
        elseif self.x > self.defaultX + self.moveSpan then
            self.xVelocity = self.xVelocity - self.acc * dt
        end

    end

    self.ground = nil
    self:move(dt)
  end

  function enemy:draw()
    love.graphics.draw(self.img, self.x, self.y)
    love.graphics.print("colission: " .. tostring(self.colisionMsg), 1000, 10)

  end
  
  return enemy