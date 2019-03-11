SNAKE_SPEED = 100

local snakeX, snakeY = 0, 0
local snakeW, snakeH = 15, 15
local snakeMoving = "r"

function love.load()
	love.window.setTitle("Snake")
end

function love.update(dt)
	-- Snake movement
	if snakeMoving == "r" then
		snakeX = snakeX + SNAKE_SPEED * dt
	elseif snakeMoving == "l" then
		snakeX = snakeX - SNAKE_SPEED * dt
	elseif snakeMoving == "u" then
		snakeY = snakeY - SNAKE_SPEED * dt
	elseif snakeMoving == "d" then
		snakeY = snakeY + SNAKE_SPEED * dt
	end
end

function love.keypressed(key)
	-- Quit game
	if key == "escape" then
		love.event.quit()
	end
	
	-- Snake movement
	if key == "right" then
		snakeMoving = "r"
	elseif key == "left" then
		snakeMoving = "l"
	elseif key == "up" then
		snakeMoving = "u"
	elseif key == "down" then
		snakeMoving = "d"
	end
end

function love.draw()
	-- Set rectangle color
	love.graphics.setColor(0, 1, 0)
	-- Draw the rectangle
	love.graphics.rectangle("fill", snakeX, snakeY, snakeW, snakeH)
end
