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

-- Tables are 1 indexed
local tileGrid = {}

local snakeX, snakeY = 1, 1
local snakeMoving = "r"
local snakeTimer = 0

function love.load()
	love.window.setTitle("Snake")
	love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT, {
		fullscreen = false
	})

	-- math.random don't work without this
	math.randomseed(os.time())
	-- Initialize grid
	initGrid()
end

function love.update(dt)
	snakeTimer = snakeTimer + dt

	-- When SNAKE_SPEED(seconds) are elapsed
	if snakeTimer >= SNAKE_SPEED then
		-- Move snake 1 tile in x direction
		if snakeMoving == "r" then
			snakeX = snakeX + 1
		elseif snakeMoving == "l" then
			snakeX = snakeX - 1
		elseif snakeMoving == "u" then
			snakeY = snakeY - 1
		elseif snakeMoving == "d" then
			snakeY = snakeY + 1
		end

		-- Reset timer
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
	drawSnake()
end

function drawGrid()

	-- Draw the grid
	for y = 1, MAX_TILES_Y do
		for x = 1, MAX_TILES_X do
			if tileGrid[y][x] == TILE_EMPTY then

				-- Set grid's color
				love.graphics.setColor(1, 1, 1)
				love.graphics.rectangle("line", (x - 1) * TILE_SIZE, (y - 1) * TILE_SIZE, 
					TILE_SIZE, TILE_SIZE)
			
			elseif tileGrid[y][x] == TILE_APPLE then
				
				-- Set apple's color
				love.graphics.setColor(1, 0, 0)
				love.graphics.rectangle("fill", (x - 1) * TILE_SIZE, (y - 1) * TILE_SIZE, 
					TILE_SIZE, TILE_SIZE)
			end
		end
	end
end

function drawSnake()
	-- Set snake's color
	love.graphics.setColor(0, 1, 0)

	-- Draw the snake
	love.graphics.rectangle("fill", (snakeX - 1) * TILE_SIZE, (snakeY - 1) * TILE_SIZE, 
		TILE_SIZE, TILE_SIZE)
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
	local randomX, randomY = math.random(MAX_TILES_X), math.random(MAX_TILES_Y)
	tileGrid[randomY][randomX] = TILE_APPLE
end