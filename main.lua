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

local largeFont = love.graphics.newFont(32)

-- Score
local score = 0

-- Tables are 1 indexed
local tileGrid = {}

local snakeX, snakeY = 1, 1
local snakeMoving = "r"
local snakeTimer = 0

-- Snake data structure
local snakeTiles = {
	-- Head
	{snakeX, snakeY}
}

function love.load()
	love.window.setTitle("Snake")
	love.graphics.setFont(largeFont)
	love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT, {
		fullscreen = false
	})

	-- math.random don't work without this
	math.randomseed(os.time())
	-- Initialize grid
	initGrid()
	-- Init snake
	tileGrid[snakeTiles[1][2]][snakeTiles[1][1]] = TILE_SNAKE_HEAD
end

function love.update(dt)
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
	drawGrid()
	
	love.graphics.setColor(1, 1, 1)
	love.graphics.print('Score: ' .. tostring(score), 10, 10)
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
	-- Insert apple in random tile
	local randomX, randomY = math.random(MAX_TILES_X), math.random(MAX_TILES_Y)
	tileGrid[randomY][randomX] = TILE_APPLE
end
