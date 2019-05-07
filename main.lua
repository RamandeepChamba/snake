TILE_SIZE = 32
WINDOW_WIDTH = 640
WINDOW_HEIGHT = 480

MAX_TILES_X = math.floor(WINDOW_WIDTH / TILE_SIZE)
MAX_TILES_Y = math.floor(WINDOW_HEIGHT / TILE_SIZE)

TILE_EMPTY = 0
TILE_SNAKE_HEAD = 1
TILE_SNAKE_BODY = 2
TILE_APPLE = 3

-- Time in seconds in which snake is going to move 1 tile
SNAKE_SPEED = 0.1

local smallFont = love.graphics.newFont(16)
local largeFont = love.graphics.newFont(32)
local veryLargeFont = love.graphics.newFont(64)

-- Game variables
local score,
	-- Game status
	gameOver,
	-- Tables are 1 indexed
	tileGrid,
	snakeX, snakeY, snakeMoving, snakeTimer,
	-- Snake data structure
	snakeTiles

function love.load()
	love.window.setTitle("Snake")
	love.graphics.setFont(largeFont)
	love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT, {
		fullscreen = false
	})

	-- Initialize game
	initGame()
end

function love.update(dt)

	-- Check game status
	if gameOver then
		return
	end

	snakeTimer = snakeTimer + dt

	-- Snake head's position before updating
	local priorHeadX, priorHeadY = snakeX, snakeY

	-- When SNAKE_SPEED(seconds) are elapsed
	if snakeTimer >= SNAKE_SPEED then
		-- Move snake 1 tile in x direction
		if snakeMoving == "r" then
			-- Loop around boundaries
			if snakeX == MAX_TILES_X then
				snakeX = 0
			end
			snakeX = snakeX + 1
		elseif snakeMoving == "l" then
			if snakeX == 1 then
				snakeX = MAX_TILES_X + 1
			end
			snakeX = snakeX - 1
		elseif snakeMoving == "u" then
			if snakeY == 1 then
				snakeY = MAX_TILES_Y + 1
			end
			snakeY = snakeY - 1
		elseif snakeMoving == "d" then
			if snakeY == MAX_TILES_Y then
				snakeY = 0
			end
			snakeY = snakeY + 1
		end

		-- Push a new head element
		-- onto the snake data structure
		table.insert(snakeTiles, 1, {snakeX, snakeY})

		-- If snake is eating an apple
		if tileGrid[snakeY][snakeX] == TILE_APPLE then
			-- increase score
			score = score + 1
			-- insert new apple
			insertApple()

		else
			-- Remove tail
			local tail = snakeTiles[#snakeTiles]
			-- from view
			tileGrid[tail[2]][tail[1]] = TILE_EMPTY
			-- from model
			table.remove(snakeTiles)
		end

		-- If snake is greater than one tile long
		if #snakeTiles > 1 then
			-- set the prior head value to a body value
			tileGrid[priorHeadY][priorHeadX] = TILE_SNAKE_BODY
		end

		-- Check if snake bit it's tail
		if tileGrid[snakeY][snakeX] == TILE_SNAKE_BODY then
			gameOver = true
		end
		-- Draw snake head
		tileGrid[snakeY][snakeX] = TILE_SNAKE_HEAD

		snakeTimer = 0
	end
end

function love.keypressed(key)
	-- Quit game
	if key == "escape" then
		love.event.quit()
	end

	-- Restart game
	if key == "return" and gameOver then
		initGame()
	end

	-- Snake movement
	if (key == "right" and not(snakeMoving == "l")) then
		snakeMoving = "r"
	elseif (key == "left" and not(snakeMoving == "r")) then
		snakeMoving = "l"
	elseif (key == "up" and not(snakeMoving == "d")) then
		snakeMoving = "u"
	elseif (key == "down" and not(snakeMoving == "u")) then
		snakeMoving = "d"
	end
end

function love.draw()
	-- Grid
	drawGrid()
	-- Score
	love.graphics.setColor(1, 1, 1)
	love.graphics.print("Score: " .. tostring(score), 10, 10)
	-- Game over screen
	if gameOver then
		drawGameOver()
	end
	-- Reset font
	love.graphics.setFont(largeFont)
end

function drawGrid()

	-- Draw the grid
	for y = 1, MAX_TILES_Y do
		for x = 1, MAX_TILES_X do
			if tileGrid[y][x] == TILE_EMPTY then

				-- Set grid's color
				--[[ love.graphics.setColor(1, 1, 1)
				love.graphics.rectangle("line", (x - 1) * TILE_SIZE, (y - 1) * TILE_SIZE,
					TILE_SIZE, TILE_SIZE)
					]]

			elseif tileGrid[y][x] == TILE_APPLE then

				-- Set apple's color
				love.graphics.setColor(1, 0, 0)
				love.graphics.rectangle("fill", (x - 1) * TILE_SIZE, (y - 1) * TILE_SIZE,
					TILE_SIZE, TILE_SIZE)

			elseif tileGrid[y][x] == TILE_SNAKE_HEAD then

				-- Set snake's head color
				love.graphics.setColor(0, 1, 0.5, 1)
				love.graphics.rectangle("fill", (x - 1) * TILE_SIZE, (y - 1) * TILE_SIZE,
					TILE_SIZE, TILE_SIZE)

			elseif tileGrid[y][x] == TILE_SNAKE_BODY then

				-- Set snake's head color
				love.graphics.setColor(0, 0.5, 0, 1)
				love.graphics.rectangle("fill", (x - 1) * TILE_SIZE, (y - 1) * TILE_SIZE,
					TILE_SIZE, TILE_SIZE)
			end
		end
	end
end

function drawGameOver()
	love.graphics.setFont(veryLargeFont)
	love.graphics.setColor(1, 1, 1)
	love.graphics.print("Game Over",
		WINDOW_WIDTH / 2 - (veryLargeFont:getWidth("Game Over") / 2),
		WINDOW_HEIGHT / 2 - (veryLargeFont:getHeight() / 2)
	)

	love.graphics.setFont(smallFont)
	love.graphics.setColor(.8, .8, .8)
	love.graphics.print("Press [Enter] to play again",
		WINDOW_WIDTH / 2 - (smallFont:getWidth("Press [Enter] to play again") / 2),
		WINDOW_HEIGHT / 2 + (veryLargeFont:getHeight() / 2)
	)
end

function initGame()
	-- Game variables
	score = 0
	gameOver = false
	tileGrid = {}
	snakeX, snakeY = 1, 1
	snakeMoving = "r"
	snakeTimer = 0
	snakeTiles = {
		-- Head
		{snakeX, snakeY}
		-- Body goes here
		-- Tail at the very end
	}
	-- math.random don't work without this
	math.randomseed(os.time())
	-- Initialize grid
	initGrid()
	-- Init snake
	tileGrid[snakeTiles[1][2]][snakeTiles[1][1]] = TILE_SNAKE_HEAD
end

function initGrid()
	for y = 1, MAX_TILES_Y do
		-- Insert row(table) in grid(table)
		table.insert(tileGrid, {})
		for x = 1, MAX_TILES_X do
			-- Insert col(value) in a row
			table.insert(tileGrid[y], TILE_EMPTY)
		end
	end

	-- Insert apple in random tile
	insertApple()
end

function insertApple()
	-- Choose random tile to insert apple
	local randomX, randomY = math.random(MAX_TILES_X), math.random(MAX_TILES_Y)
	-- Keep finding until we reach an empty tile
	while (not(tileGrid[randomY][randomX] == TILE_EMPTY)) do
		randomX, randomY = math.random(MAX_TILES_X), math.random(MAX_TILES_Y)
	end
	-- Insert apple
	tileGrid[randomY][randomX] = TILE_APPLE
end
