player = {}

function love.load()
    love.window.setFullscreen(true, "desktop")
    print(success)
    player.x = love.graphics.getWidth()/2
    player.y = love.graphics.getHeight()/2
    player.img = love.graphics.newImage("LoveRunnerCharacter.png")
    player.speed = 320
    player.facingRight = true
    player.runningAnimationWidth = 618
    player.runningAnimationHeight = 472
    player.scale = 0.2
    player.inMove = false
    animation = newAnimation(love.graphics.newImage("mergedLoveRunner.png"), player.runningAnimationWidth, player.runningAnimationHeight, 0.4)
end


function love.update(dt)
    if love.keyboard.isDown('d') then
        player.facingRight = true
        player.inMove = true
        player.x = player.x + (player.speed * dt)
        animation.currentTime = animation.currentTime + dt
        if animation.currentTime >= animation.duration then
            animation.currentTime = animation.currentTime - animation.duration
        end
    elseif love.keyboard.isDown('a') then
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

function love.draw()
    love.graphics.setBackgroundColor(80/255, 100/255, 180/255)


    love.graphics.setColor(1, 1, 1)
    local spriteNum = math.floor(animation.currentTime / animation.duration * #animation.quads) + 1
    if player.inMove then
        if player.facingRight then
            love.graphics.draw(animation.spriteSheet, animation.quads[spriteNum], player.x, player.y, 0, player.scale, player.scale, 0, player.runningAnimationHeight)
        else
            love.graphics.draw(animation.spriteSheet, animation.quads[spriteNum], player.x, player.y, math.rad(180), player.scale, -player.scale, player.runningAnimationWidth, player.runningAnimationHeight)
        end
    else
        if player.facingRight then
            love.graphics.draw(player.img, player.x, player.y, 0, player.scale, player.scale, 0, player.runningAnimationHeight)
        else
            love.graphics.draw(player.img, player.x, player.y, math.rad(180), player.scale, -player.scale, player.runningAnimationWidth, player.runningAnimationHeight)
        end
    end


    love.graphics.setColor(60/255, 80/255, 100/255)
    love.graphics.rectangle("fill", 0, love.graphics.getHeight()/2, love.graphics.getWidth(), love.graphics.getHeight())
end


 
function newAnimation(image, width, height, duration)
    local animation = {}
    animation.spriteSheet = image;
    animation.quads = {};
 
    for y = 0, image:getHeight() - height, height do
        for x = 0, image:getWidth() - width, width do
            table.insert(animation.quads, love.graphics.newQuad(x, y, width, height, image:getDimensions()))
        end
    end
 
    animation.duration = duration or 1
    animation.currentTime = 0
 
    return animation
end