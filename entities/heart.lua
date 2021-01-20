local Class = require("libs.hump.class")
local Entity = require("entities.Entity")
local Entities = require("entities.Entities")

local heart = Class{
    __includes = Entity
}

function heart:init(world, x, y) 
    self.img = love.graphics.newImage("assets/heart.png")

    self.scale = 0.08

    Entity.init(self, world, x, y, self.img:getWidth() * self.scale, self.img:getHeight() * self.scale)

    self.collectSound = love.audio.newSource('assets/sound/collectSound.wav', 'stream')

    self.xRelativeVelocity = 0
    self.xVelocity = 0 -- current velocity on x, y axes
    self.yVelocity = 0
    self.acc = 1 -- the acceleration of our player
    self.brakeAccel = 500
    self.maxSpeed = 1 -- the top speed
    self.gravity = 15 -- we will accelerate towards the bottom

    self.defaultX = self.x
    self.moveSpan = 1 -- how far sideways heart moves
    self.initSideMove = true

    self.colisionMsg = "no"
    self.shouldDraw = true
    -- self.colectedHearts = 0
    colectedHearts = 0

    self.jumpSoundEffect = love.audio.newSource('assets/sound/jumpEffect.mp3', 'stream')
    self.jumpSoundEffect:setVolume(0.05)

    self.world:add(self, self:getRect())
end

function heart:collisionFilter(other)
    local x, y, w, h = self.world:getRect(other)
    local playerBottom = self.y + self.h
    local otherBottom = y + h
  
    --if playerBottom <= y then -- bottom of player collides with top of platform.
      return 'slide'
    --end
  end

  function heart:changeVelocityByCollisionNormal(col)
    local other, normal = col.other, col.normal
    local nx, ny        = normal.x, normal.y
    local vx, vy        = self.xVelocity, self.yVelocity
  
    if other.yVelocity and ((ny < 0 and vy > 0) or (ny > 0 and vy < 0)) then
        self.colisionMsg = "yes"
        --//TODO DESTROY
        self.shouldDraw = false
        self.yVelocity = -10000
        self.gravity = 0
        colectedHearts = colectedHearts + 1
        self.collectSound:play()
    end

  end

  function heart:setGround(other)
    self.ground = other
    self.y = self.ground.y - self.h
    self.world:update(self, self.x, self.y)
  end

  function heart:checkIfOnGround(ny, other)
    if ny < 0 then
        self.ground = other
      --//TODO DESTROY
        self.shouldDraw = false
        self.yVelocity = -10000
        self.gravity = 0
    end

  end

  function heart:move(dt)
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

  function heart:update(dt, index)
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

    -- if not self.shouldDraw then

    -- end

    self.ground = nil
    self:move(dt)
  end

  function heart:draw()
    if self.shouldDraw then
        love.graphics.draw(self.img, self.x, self.y, 0, self.scale, self.scale)
    end
    --//TODO zbierac serca do globalnej value
    -- love.graphics.print("colission: " .. tostring(self.colisionMsg), 1000, 10)
    -- love.graphics.print("Collected Hearts: " .. tostring(self.colectedHearts), 2950, 300)
  end
  
  return heart