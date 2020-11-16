player = {}

function love.load()
    love.window.setFullscreen(true, "desktop")
    print(success)
    player.x = love.graphics.getWidth()/2
    player.y = love.graphics.getHeight()/2
    player.img = love.graphics.newImage("LoveRunnerCharacter.png")
    player.speed = 200
end


function love.update(dt)
    if love.keyboard.isDown('d') then
		player.x = player.x + (player.speed * dt)
	elseif love.keyboard.isDown('a') then
		player.x = player.x - (player.speed * dt)
	end
end

function love.draw()
    love.graphics.draw(player.img, player.x, player.y, 0, 0.15, 0.15, 0, 0)
end