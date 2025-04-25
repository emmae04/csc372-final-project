-- Constants
LEFT, RIGHT, UP, DOWN = 0, 1, 2, 3

-- Convert direction string to enum
function Dir(str)
    if str == "RIGHT" then return RIGHT
    elseif str == "LEFT" then return LEFT
    elseif str == "UP" then return UP
    elseif str == "DOWN" then return DOWN
    else return -1 end
end

-- Board class
board = {}
board.__index = board

function board:new(rows, cols)
    -- create a new board with the given number of rows and columns 
    local Tiles = setmetatable({}, board)
    Tiles.rows = rows
    Tiles.cols = cols
    for i = 1, rows do
        Tiles[i] = {}
        for j = 1, cols do
            Tiles[i][j] = nil
        end
    end
    return Tiles
end

function board:getTileAt(row, col)
    -- checks and returns the tile at the given row and col
    if row >= 1 and row <= self.rows and col >= 1 and col <= self.cols then
        return self[row][col]
    end
    return nil
end

function board:setTileAt(row, col, value)
    -- checks if the row and col are within bounds
    if row >= 1 and row <= self.rows and col >= 1 and col <= self.cols then
        self[row][col] = value
    end
end

function board:mergeTiles(fromRow, fromCol, toRow, toCol)
    -- adds the two tiles together and sets the tile at the toRow and toCol to the sum
    local sum = self:getTileAt(fromRow, fromCol) + self:getTileAt(toRow, toCol) 
    self:setTileAt(toRow, toCol, sum)
    self:setTileAt(fromRow, fromCol, nil)
end

function board:move(dir)
    local moved = false
    local merged = false
    -- Initialize or reset the merged tracker
    local mergedThisTurn = {}
    for r = 1, self.rows do
        mergedThisTurn[r] = {}
        for c = 1, self.cols do
            mergedThisTurn[r][c] = false
        end
    end

    if dir == LEFT then
        for row = 1, self.rows do
            for col = 2, self.cols do
                local curr = col
                while curr > 1 and self:getTileAt(row, curr) ~= nil and self:getTileAt(row, curr - 1) == nil do
                    self:setTileAt(row, curr - 1, self:getTileAt(row, curr))
                    self:setTileAt(row, curr, nil)
                    curr = curr - 1
                    moved = true
                end
                if curr > 1 and
                   self:getTileAt(row, curr) ~= nil and
                   self:getTileAt(row, curr) == self:getTileAt(row, curr - 1) and
                   not mergedThisTurn[row][curr - 1] then

                    self:mergeTiles(row, curr, row, curr - 1)
                    mergedThisTurn[row][curr - 1] = true
                    moved = true
                    merged = true
                end
            end
        end

    elseif dir == RIGHT then
        for row = 1, self.rows do
            for col = self.cols - 1, 1, -1 do
                local curr = col
                while curr < self.cols and self:getTileAt(row, curr) ~= nil and self:getTileAt(row, curr + 1) == nil do
                    self:setTileAt(row, curr + 1, self:getTileAt(row, curr))
                    self:setTileAt(row, curr, nil)
                    curr = curr + 1
                    moved = true
                end
                if curr < self.cols and
                   self:getTileAt(row, curr) ~= nil and
                   self:getTileAt(row, curr) == self:getTileAt(row, curr + 1) and
                   not mergedThisTurn[row][curr + 1] then

                    self:mergeTiles(row, curr, row, curr + 1)
                    mergedThisTurn[row][curr + 1] = true
                    moved = true
                    merged = true
                end
            end
        end

    elseif dir == UP then
        for col = 1, self.cols do
            for row = 2, self.rows do
                local curr = row
                while curr > 1 and self:getTileAt(curr, col) ~= nil and self:getTileAt(curr - 1, col) == nil do
                    self:setTileAt(curr - 1, col, self:getTileAt(curr, col))
                    self:setTileAt(curr, col, nil)
                    curr = curr - 1
                    moved = true
                end
                if curr > 1 and
                   self:getTileAt(curr, col) ~= nil and
                   self:getTileAt(curr, col) == self:getTileAt(curr - 1, col) and
                   not mergedThisTurn[curr - 1][col] then

                    self:mergeTiles(curr, col, curr - 1, col)
                    mergedThisTurn[curr - 1][col] = true
                    moved = true
                    merged = true
                end
            end
        end

    elseif dir == DOWN then
        for col = 1, self.cols do
            for row = self.rows - 1, 1, -1 do
                local curr = row
                while curr < self.rows and self:getTileAt(curr, col) ~= nil and self:getTileAt(curr + 1, col) == nil do
                    self:setTileAt(curr + 1, col, self:getTileAt(curr, col))
                    self:setTileAt(curr, col, nil)
                    curr = curr + 1
                    moved = true
                end
                if curr < self.rows and
                   self:getTileAt(curr, col) ~= nil and
                   self:getTileAt(curr, col) == self:getTileAt(curr + 1, col) and
                   not mergedThisTurn[curr + 1][col] then

                    self:mergeTiles(curr, col, curr + 1, col)
                    mergedThisTurn[curr + 1][col] = true
                    moved = true
                    merged = true
                end
            end
        end
    end

    return moved, merged
end


tileAnimations = {}

function newTile(b)
    local empty = {}
    for row = 1, 4 do
        for col = 1, 4 do
            if b:getTileAt(row, col) == nil then
                table.insert(empty, {row, col})
            end
        end
    end

    if #empty > 0 then
        local choice = empty[math.random(#empty)]
        local val = math.random(0, 1) == 0 and 2 or 4
        b:setTileAt(choice[1], choice[2], val)

        tileAnimations[choice[1] .. "_" .. choice[2]] = {scale = 0.1, time = 0}
    end
end

gameOver = false -- global variable to check if reset button should be drawn without having to check isGameOver every frame
function isGameOver(b)
    for row = 1, 4 do
        for col = 1, 4 do
            local val = b:getTileAt(row, col)
            if val == nil then return false end
            for d = 0, 3 do
                local dr, dc = 0, 0
                if d == LEFT then dc = -1
                elseif d == RIGHT then dc = 1
                elseif d == UP then dr = -1
                elseif d == DOWN then dr = 1 end
                local nr, nc = row + dr, col + dc
                if b:getTileAt(nr, nc) == val then
                    return false
                end
            end
        end
    end
    return true
end
-- Resets game if the user wants to play again
function resetGame()
    game = board:new(4, 4)
    tileAnimations = {}
    newTile(game)
    newTile(game)
end
-- Game setup
function love.load()
    love.graphics.setBackgroundColor(1.0, 0.992, 0.816) -- set background color
    game = board:new(4, 4)
    tiles = {} -- create tiles for tile images 
    local tileNums = {2, 4, 8, 16, 32, 64, 128, 256, 512, 1024, 2048}
    for _, val in ipairs(tileNums) do 
        tiles[val] = love.graphics.newImage("tiles/tile_" .. val .. ".png") -- get the tile images from folder
    end
    popSoundEffect = love.audio.newSource("sounds/pop.mp3", "static")
    slideSoundEffect = love.audio.newSource("sounds/slide.mp3", "static")
    newTile(game)
    newTile(game)
end

-- Input
function love.keypressed(key)
    local moved, merged = false, false
    if key == "left" then moved, merged = game:move(LEFT)
    elseif key == "right" then moved, merged = game:move(RIGHT)
    elseif key == "up" then moved, merged = game:move(UP)
    elseif key == "down" then moved, merged = game:move(DOWN)
    end

    if moved then
        if merged then
            love.audio.play(popSoundEffect)
        else
            love.audio.play(slideSoundEffect)
        end
        newTile(game)
        if isGameOver(game) then
            gameOver = true
            print("Game Over!")
        end
    end
end
-- Checks for mouse press on restart game button
function love.mousepressed(x, y, button)
    if gameOver and button == 1 then 
        local windowWidth, windowHeight = love.graphics.getDimensions()
        local gridSize = math.min(windowWidth, windowHeight) * 0.9
        local offsetY = (windowHeight - gridSize) / 2
        local buttonWidth = windowWidth * 0.3
        local buttonHeight = windowHeight * 0.08
        local buttonX = (windowWidth - buttonWidth) / 2
        local buttonY = offsetY + gridSize + 20 
        if x >= buttonX and x <= buttonX + buttonWidth and y >= buttonY and y <= buttonY + buttonHeight then
            resetGame()
            gameOver = false
        end
    end
end
-- Update for animations
function love.update(dt) 
    for key, anim in pairs(tileAnimations) do 
        anim.time = anim.time + dt
        anim.scale = math.min(1, anim.scale + dt * 5)
        if anim.scale >= 1 then 
            tileAnimations[key] = nil 
        end
    end
end
-- Drawing
function love.draw()
    local windowWidth, windowHeight = love.graphics.getDimensions() --get the dimensions to scale the board and tiles
    local gridSize = math.min(windowWidth, windowHeight) * 0.9
    local tileSize = gridSize / 4
    local offsetX = (windowWidth - gridSize) / 2
    local offsetY = (windowHeight - gridSize) / 2
    love.graphics.setFont(love.graphics.newFont(math.floor(tileSize/3)))
    if gameOver then --creates the reset button if the game is over
        local buttonWidth = windowWidth * 0.3
        local buttonHeight = windowHeight * 0.08
        local buttonX = (windowWidth - buttonWidth) / 2
        local buttonY = offsetY + gridSize + 20
        love.graphics.setColor(0, 0, 0)
        love.graphics.printf("Game Over!", 0, offsetY - 40, windowWidth, "center")
        love.graphics.rectangle("fill", buttonX, buttonY, buttonWidth, buttonHeight)
        love.graphics.setColor(1, 1, 1)
        love.graphics.printf("Restart", buttonX, buttonY + 15, buttonWidth, "center")
        --love.graphics.setColor(1, 1, 1)
    end
    for row = 1, 4 do
        for col = 1, 4 do
            local val = game:getTileAt(row, col)
            local x = offsetX + (col - 1) * tileSize
            local y = offsetY + (row - 1) * tileSize
            love.graphics.rectangle("line", x, y, tileSize, tileSize)
            if val then
                local tileImage = tiles[val] --get the tile image associated with the value
                if tileImage then
                    local sx = tileSize / tileImage:getWidth()
                    local sy = tileSize / tileImage:getHeight() 
                    local anim = tileAnimations[row .. "_" .. col]
                    local scale = anim and anim.scale or 1
                    local scaledSize = tileSize * scale
                    local offset = (tileSize - scaledSize) / 2 
                    love.graphics.draw(tileImage, x + offset, y + offset, 0, scale * sx, scale * sy)
                else
                    love.graphics.printf(val, x, y + tileSize / 3, tileSize, "center")
                end
            end
        end
    end
end
