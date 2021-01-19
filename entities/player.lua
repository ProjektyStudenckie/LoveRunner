local Class = require("libs.hump.class")
local Entity = require("entities.Entity")

require("utils.animation")

-- Class Player inherits from class Entity
local player = Class{
    __includes = Entity
}


function player:init(world, x, y)
    x = x - 500
    y = y - 200
    self.img = love.graphics.newImage("assets/LoveRunnerCharacter.png")
    self.jumpImg = love.graphics.newImage("assets/LoveRunnerCharacterJump.png")

    Entity.init(self, world, x, y, self.img:getWidth(), self.img:getHeight())

    self.defaultWidth = self.img:getWidth()
    self.height = self.img:getHeight()
    self.runningAnimationWidth = 618
    self.scale = 0.15

    self.velocityX = 0
    self.acceleration = 100
    self.maxSpeed = 320
    self.friction = 15

    self.velocityY = 0
    self.jumpForce = 500
    self.gravity = 9.8 * 100

    self.facingRight = true
    self.inMove = false
    self.readyToJump = true
    self.isGrounded = false
    self.hasReachedMax = false

    self.animation = newAnimation(love.graphics.newImage("assets/mergedLoveRunner.png"), self.runningAnimationWidth, self.height, 0.4)
    self.world:add(self, x, y, self.defaultWidth, self.height)
end


function player:physics(dt)
    -- handle current position
    self.x = self.x + self.velocityX * dt
    self.y = self.y + self.velocityY * dt

    -- set friction ([IDEA] change this if walking on ice!)
    self.velocityX = self.velocityX * (1 - math.min(dt * self.friction, 1))

    -- gravity affect on velocityY
    self.velocityY = self.velocityY + (self.gravity * dt)
end


function player:update(dt)
    --self:physics(dt)

    --temporary ground for player
    -- if self.y > 448 then 
    --     self.y = 448
    --     self.readyToJump = true
    -- end

    local prevX, prevY = self.x, self.y

    -- Apply Friction
    self.velocityX = self.velocityX * (1 - math.min(dt * self.friction, 1))
    self.velocityY = self.velocityY * (1 - math.min(dt * self.friction, 1))
  
    -- Apply gravity
    self.velocityY = self.velocityY + self.gravity * dt

    
    if love.keyboard.isDown('w', "space", "up") and self.readyToJump then
        self.velocityY = self.velocityY * dt - self.jumpForce
        self.readyToJump = false
        self.isGrounded = false
    end

    if love.keyboard.isDown('d', "right") then
        self.facingRight = true
        self.inMove = true

        -- increase velocity if not max speed
        if self.velocityX < self.maxSpeed then
            self.velocityX = self.velocityX + self.acceleration * dt
        end

        -- handle movement animations
        self.animation.currentTime = self.animation.currentTime + dt
        if self.animation.currentTime >= self.animation.duration then
            self.animation.currentTime = self.animation.currentTime - self.animation.duration
        end

    elseif love.keyboard.isDown('a', "left") then
        self.facingRight = false
        self.inMove = true

        -- "decrease" velocity if not max speed
        if self.velocityX > -self.maxSpeed then
            self.velocityX = self.velocityX - self.acceleration * dt
        end

        -- handle movement animations
        self.animation.currentTime = self.animation.currentTime + dt
        if self.animation.currentTime >= self.animation.duration then
            self.animation.currentTime = self.animation.currentTime - self.animation.duration
        end
    -- if player is not pressing any movement button set animation to standing
    else
        self.inMove = false
        -- reset walking animation
        self.animation.currentTime = 0
    end

    -- these store the location the player will arrive at should
    local goalX = self.x + self.velocityX
    local goalY = self.y + self.velocityY

    -- Move the player while testing for collisions
    self.x, self.y, collisions, len = self.world:move(self, goalX, goalY, self.collisionFilter)

    -- Loop through those collisions to see if anything important is happening
    for i, coll in ipairs(collisions) do
        if coll.touch.y > goalY then  -- We touched below (remember that higher locations have lower y values) our intended target.
            self.hasReachedMax = true -- this scenario does not occur in this demo
            self.isGrounded = false
        elseif coll.normal.y < 0 then
            self.hasReachedMax = false
            self.isGrounded = true
        end
    end

end

function player:draw()

    -- Draw player on the ground ...
    if self.readyToJump then
        local spriteNum = math.floor(self.animation.currentTime / self.animation.duration * #self.animation.quads) + 1
        -- ... moving and ...
        if self.inMove then
            -- ... facing right.
            if self.facingRight then
                love.graphics.draw(self.animation.spriteSheet, self.animation.quads[spriteNum], self.x, self.y - (self.height * self.scale), 0, self.scale, self.scale)
            else
            -- ... facing left.
                love.graphics.draw(self.animation.spriteSheet, self.animation.quads[spriteNum], self.x + (self.runningAnimationWidth * self.scale), self.y - (self.height * self.scale), math.rad(180), self.scale, -self.scale)
            end
        -- ... standing still and ...
        else
            -- ... facing right.
            if self.facingRight then
                love.graphics.draw(self.img, self.x, self.y - (self.height * self.scale), 0, self.scale, self.scale)
            -- ... facing left.
            else
                love.graphics.draw(self.img, self.x + (self.defaultWidth * self.scale), self.y - (self.height * self.scale), math.rad(180), self.scale, -self.scale)
            end
        end
    -- Draw player in the air ...
    else
        -- ... facing right.
        if self.facingRight then
            love.graphics.draw(self.jumpImg, self.x, self.y - (self.height * self.scale), 0, self.scale, self.scale)
        -- ... facing left.
        else
            love.graphics.draw(self.jumpImg, self.x + (self.defaultWidth * self.scale), self.y - (self.height * self.scale), math.rad(180), self.scale, -self.scale)
        end
    end

end


return player