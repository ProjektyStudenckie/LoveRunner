player = {}

function player:load(screenWidth, screenHeight)
    player.x = screenWidth/2
    player.y = screenHeight/2

    player.runningAnimationWidth = 618
    player.defaultWidth = 394
    player.height = 472
    player.scale = 0.2

    player.img = love.graphics.newImage("LoveRunnerCharacter.png")
    player.jumpImg = love.graphics.newImage("LoveRunnerCharacterJump.png")

    player.velocityX = 0
    player.acceleration = 10000
    player.maxSpeed = 320
    player.friction = 10

    player.velocityY = 0
    player.jumpForce = 500
    player.gravity = 9.8 * 100

    player.facingRight = true
    player.inMove = false
    player.readyToJump = true

    animation = newAnimation(love.graphics.newImage("mergedLoveRunner.png"), player.runningAnimationWidth, player.height, 0.4)
end


function player:physics(dt)
    -- handle current position
    player.x = player.x + player.velocityX * dt
    player.y = player.y + player.velocityY * dt

    -- set friction ([IDEA] change this if walking on ice!)
    player.velocityX = player.velocityX * (1 - math.min(dt * player.friction, 1))

    -- gravity affect on velocityY
    player.velocityY = player.velocityY + (player.gravity * dt)
end


function player:update(dt)
    -- temporary ground for player
    if player.y > screenHeight/2 then 
        player.y = screenHeight/2 
        player.readyToJump = true
    end

    
    if love.keyboard.isDown('w', "space") and player.readyToJump then
        player.velocityY = player.velocityY * dt - player.jumpForce
        player.readyToJump = false
    end

    if love.keyboard.isDown('d', "right") then
        player.facingRight = true
        player.inMove = true

        -- increase velocity if not max speed
        if player.velocityX < player.maxSpeed then
            player.velocityX = player.velocityX + (player.acceleration * dt)
        end

        -- handle movement animations
        animation.currentTime = animation.currentTime + dt
        if animation.currentTime >= animation.duration then
            animation.currentTime = animation.currentTime - animation.duration
        end

    elseif love.keyboard.isDown('a', "left") then
        player.facingRight = false
        player.inMove = true

        -- "decrease" velocity if not max speed
        if player.velocityX > -player.maxSpeed then
            player.velocityX = player.velocityX - (player.acceleration * dt)
        end

        -- handle movement animations
        animation.currentTime = animation.currentTime + dt
        if animation.currentTime >= animation.duration then
            animation.currentTime = animation.currentTime - animation.duration
        end
    -- if player is not pressing any movement button set animation to standing
    else
        player.inMove = false
        -- reset walking animation
        animation.currentTime = 0
    end
    
end


function player:draw()
    -- Draw player on the ground ...
    if player.readyToJump then
        local spriteNum = math.floor(animation.currentTime / animation.duration * #animation.quads) + 1
        -- ... moving and ...
        if player.inMove then
            -- ... facing right.
            if player.facingRight then
                love.graphics.draw(animation.spriteSheet, animation.quads[spriteNum], player.x, player.y - (player.height * player.scale), 0, player.scale, player.scale)
            else
            -- ... facing left.
                love.graphics.draw(animation.spriteSheet, animation.quads[spriteNum], player.x + (player.runningAnimationWidth * player.scale), player.y - (player.height * player.scale), math.rad(180), player.scale, -player.scale)
            end
        -- ... standing still and ...
        else
            -- ... facing right.
            if player.facingRight then
                love.graphics.draw(player.img, player.x, player.y - (player.height * player.scale), 0, player.scale, player.scale)
            -- ... facing left.
            else
                love.graphics.draw(player.img, player.x + (player.defaultWidth * player.scale), player.y - (player.height * player.scale), math.rad(180), player.scale, -player.scale)
            end
        end
    -- Draw player in the air ...
    else
        -- ... facing right.
        if player.facingRight then
            love.graphics.draw(player.jumpImg, player.x, player.y - (player.height * player.scale), 0, player.scale, player.scale)
        -- ... facing left.
        else
            love.graphics.draw(player.jumpImg, player.x + (player.defaultWidth * player.scale), player.y - (player.height * player.scale), math.rad(180), player.scale, -player.scale)
        end
    end

end