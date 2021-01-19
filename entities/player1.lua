local Class = require 'libs.hump.class'
local Entity = require 'entities.Entity'

require("utils.animation")

local player = Class{
  __includes = Entity -- Player class inherits our Entity class
}

-- Enumeration isn't technically supported in lua, but this approach
-- has a similar outcome.
local PlayerStates = {
  Idle = 0,
  Walking = 1,
  Running = 2,
  Jumping = 3,
  Dead = 4
}

function player:init(world, x, y)
  self.state = PlayerStates.Idle
  self.img = love.graphics.newImage('/assets/LoveRunnerCharacter.png')
  self.jumpImg = love.graphics.newImage('assets/LoveRunnerCharacterJump.png')

  self.scale = 0.15
  Entity.init(self, world, x, y, self.img:getWidth() * self.scale, self.img:getHeight() * self.scale)

  self.defaultWidth = self.img:getWidth()
  self.runningAnimationWidth = 618
  self.height = self.img:getHeight()

  -- //TODO set better values to improve movement fluidity

  -- Add our unique player values
  self.xRelativeVelocity = 0
  self.xVelocity = 0 -- current velocity on x, y axes
  self.yVelocity = 0
  self.acc = 1000 -- the acceleration of our player
  self.brakeAccel = 2000
  self.maxSpeed = 400 -- the top speed
  self.gravity = 1000 -- we will accelerate towards the bottom

  self.jumpForce = 500
  -- These are values applying specifically to jumping
  self.jumpStartY = y
  self.jumpImpulse = 750
  self.jumpMaxHeight = 5 -- pixels
  self.jumpCurrentImpulse = 0

  -- for animations
  self.facingRight = true
  self.inMove = false
  self.readyToJump = true
  self.isGrounded = false
  self.hasReachedMax = false

  self.world:add(self, self:getRect())
  
  self.animation = newAnimation(love.graphics.newImage("assets/mergedLoveRunner.png"), self.runningAnimationWidth, self.height, 0.4)
end

function player:collisionFilter(other)
  local x, y, w, h = self.world:getRect(other)
  local playerBottom = self.y + self.h
  local otherBottom = y + h

  self.ulica = other

  --if playerBottom <= y then -- bottom of player collides with top of platform.
    return 'slide'
  --end
end

function player:changeVelocityByCollisionNormal(col)
  local other, normal = col.other, col.normal
  local nx, ny = normal.x, normal.y
  local vx, vy = self.xVelocity, self.yVelocity

  if other.xVelocity and ((nx < 0 and vx > 0) or (nx > 0 and vx < 0)) then
    self.xVelocity = other.xVelocity
    self.xRelativeVelocity  = other.xVelocity
  end

  if other.yVelocity and ((ny < 0 and vy > 0) or (ny > 0 and vy < 0)) then
    self.yVelocity = math.max(0, other.yVelocity)
  end
end

-- function player:setGround(other)
--   self.state = PlayerStates.Idle
--   self.ground = other
--   self.y = self.ground.y - self.h
--   self.world:update(self, self.x, self.y)
-- end

function player:checkIfOnGround(ny, other)
  if ny < 0 then
    self.ground = other
    self.ulica = other
  end
end

function player:playerInput(dt)
  -- Do xVelocity logic
  local vx = self.xRelativeVelocity

  -- dodałem moje skakanie - musisz ogarnąć zeby dobrze zmienialo state - jak wyladujesz na ziemi
  if love.keyboard.isDown('w', "space", "up") and self.state ~= PlayerStates.Jumping then
    self.yVelocity = self.yVelocity * dt - self.jumpForce
    self.state = PlayerStates.Jumping
  end

  if love.keyboard.isDown("left", "a") and self.xVelocity > -self.maxSpeed then
    vx = self.xVelocity - self.acc * dt
    self.state = PlayerStates.Running
    self.facingRight = false
    self.inMove = true

    -- handle movement animations
    self.animation.currentTime = self.animation.currentTime + dt
    if self.animation.currentTime >= self.animation.duration then
        self.animation.currentTime = self.animation.currentTime - self.animation.duration
    end
	elseif love.keyboard.isDown("right", "d") and self.xVelocity < self.maxSpeed then
    vx = self.xVelocity + self.acc * dt
    self.state = PlayerStates.Running
    self.facingRight = true
    self.inMove = true

    -- handle movement animations
    self.animation.currentTime = self.animation.currentTime + dt
    if self.animation.currentTime >= self.animation.duration then
        self.animation.currentTime = self.animation.currentTime - self.animation.duration
    end
  else

    local brake = dt * (vx < 0 and self.brakeAccel or -self.brakeAccel)
    if math.abs(brake) > math.abs(vx) then
      vx = 0

      self.inMove = false
      -- reset walking animation
      self.animation.currentTime = 0

      self.state = PlayerStates.Idle
    else
      vx = vx + brake

      -- handle movement animations
      self.animation.currentTime = self.animation.currentTime + dt
      if self.animation.currentTime >= self.animation.duration then
          self.animation.currentTime = self.animation.currentTime - self.animation.duration
      end
    end
	end

  self.xRelativeVelocity = vx

  -- if we're grounded on a moving platform we need to move with that platform.
  if self.ground then
    groundAdjust = 0
    if self.ground.xVelocity then
      groundAdjust = self.ground.xVelocity
    end

    self.xVelocity = self.xRelativeVelocity + groundAdjust
  else
    self.xVelocity = self.xRelativeVelocity
  end

  -- Do yVelocity logic
  if love.keyboard.isDown("up", "space", "w") then


  elseif not self.ground and self.state == PlayerStates.Jumping then
    self.yVelocity = 0
  end
end

function player:keypressed(key)
  if key ~= "up" and key ~= "space" then
    return
  end

  if self.ground then
    self.state = PlayerStates.Jumping
    self.jumpStartY = self.y
  end

  -- //TODO nwm czemu maxHeight nie dziala - ograniczyc wysokosc skoku
  -- if (self.jumpStartY - self.y) < self.jumpMaxHeight then
  --   self.yVelocity = -self.jumpImpulse -- no need to multiply by dt because this is instantaneous
  -- else
  --   self.yVelocity = 0
  -- end
end

function player:keyreleased(key)
  if key ~= "up" and key ~= "space" then
    return
  end


end

function player:move(dt)
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



function player:update(dt, index)
  local prevX, prevY = self.x, self.y

  -- Process inputs from the player.
  self:playerInput(dt)

  if not self.ground and self.state ~= PlayerStates.Jumping then
    self.yVelocity = self.yVelocity + self.gravity * dt -- Apply gravity
  end

  -- //TODO
  if self.y > love.graphics.getHeight() - 100 then
    self.yVelocity = 0
    self.xVelocity = 0
    self.xRelativeVelocity = 0
    self.y = 300
    self.x = 100

    self.facingRight = true
    self.inMove = false
    self.readyToJump = true
    self.isGrounded = false
    self.hasReachedMax = false
    
    local world = self.world
    world:update(self, 300, 100)
  end

  self:move(dt)
  self.ground = nil
end



function player:draw()

  -- Draw player on the ground ...
  if self.state ~= PlayerStates.Jumping then
    local spriteNum = math.floor(self.animation.currentTime / self.animation.duration * #self.animation.quads) + 1
    -- ... moving and ...
    if self.state ~= PlayerStates.Idle then
        -- ... facing right.
        if self.facingRight then
            love.graphics.draw(self.animation.spriteSheet, self.animation.quads[spriteNum], self.x, self.y, 0, self.scale, self.scale)
        else
        -- ... facing left.
            love.graphics.draw(self.animation.spriteSheet, self.animation.quads[spriteNum], self.x + (self.runningAnimationWidth * self.scale), self.y, math.rad(180), self.scale, -self.scale)
        end
    -- ... standing still and ...
    else
        -- ... facing right.
        if self.facingRight then
            love.graphics.draw(self.img, self.x, self.y, 0, self.scale, self.scale)
        -- ... facing left.
        else
            love.graphics.draw(self.img, self.x + (self.defaultWidth * self.scale), self.y, math.rad(180), self.scale, -self.scale)
        end
    end
-- Draw player in the air ...
else
    -- ... facing right.
    if self.facingRight then
        love.graphics.draw(self.jumpImg, self.x, self.y, 0, self.scale, self.scale)
    -- ... facing left.
    else
        love.graphics.draw(self.jumpImg, self.x + (self.defaultWidth * self.scale), self.y, math.rad(180), self.scale, -self.scale)
    end
end
end

return player