player = {}

function player:load(screenWidth, screenHeight)
    player.x = screenWidth/2
    player.y = screenHeight/2
    player.img = love.graphics.newImage("LoveRunnerCharacter.png")
    player.speed = 320
    player.facingRight = true
    player.runningAnimationWidth = 618
    player.runningAnimationHeight = 472
    player.scale = 0.2
    player.inMove = false

    animation = newAnimation(love.graphics.newImage("mergedLoveRunner.png"), player.runningAnimationWidth, player.runningAnimationHeight, 0.4)
end


function player:update(dt)

    if love.keyboard.isDown('d') or love.keyboard.isDown('right') then
        player.facingRight = true
        player.inMove = true
        player.x = player.x + (player.speed * dt)
        animation.currentTime = animation.currentTime + dt
        if animation.currentTime >= animation.duration then
            animation.currentTime = animation.currentTime - animation.duration
        end

    elseif love.keyboard.isDown('a') or love.keyboard.isDown('left') then
        player.facingRight = false
        player.inMove = true
        player.x = player.x - (player.speed * dt)
        animation.currentTime = animation.currentTime + dt
        if animation.currentTime >= animation.duration then
            animation.currentTime = animation.currentTime - animation.duration
        end
    else
        player.inMove = false
        animation.currentTime = 0
    end
    
end

function player:draw()

    local spriteNum = math.floor(animation.currentTime / animation.duration * #animation.quads) + 1
    if player.inMove then
        if player.facingRight then
            love.graphics.draw(animation.spriteSheet, animation.quads[spriteNum], player.x, player.y - (player.runningAnimationHeight * player.scale), 0, player.scale, player.scale)
        else
            love.graphics.draw(animation.spriteSheet, animation.quads[spriteNum], player.x + (player.runningAnimationWidth * player.scale), player.y - (player.runningAnimationHeight * player.scale), math.rad(180), player.scale, -player.scale)
        end
    else
        if player.facingRight then
            love.graphics.draw(player.img, player.x, player.y - (player.runningAnimationHeight * player.scale), 0, player.scale, player.scale)
        else
            love.graphics.draw(player.img, player.x + (player.runningAnimationWidth * player.scale), player.y - (player.runningAnimationHeight * player.scale), math.rad(180), player.scale, -player.scale)
        end
    end

end