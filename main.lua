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
    if row >= 1 and row <= self.rows and col >= 1 and col <= self.cols then
        return self[row][col]
    end
    return nil
end

function board:setTileAt(row, col, value)
    if row >= 1 and row <= self.rows and col >= 1 and col <= self.cols then
        self[row][col] = value
    end
end

function board:mergeTiles(fromRow, fromCol, toRow, toCol)
    local sum = self:getTileAt(fromRow, fromCol) + self:getTileAt(toRow, toCol)
    self:setTileAt(toRow, toCol, sum)
    self:setTileAt(fromRow, fromCol, nil)
end

function board:move(dir)
    local moved = false

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
                if curr > 1 and self:getTileAt(row, curr) ~= nil and self:getTileAt(row, curr) == self:getTileAt(row, curr - 1) then
                    self:mergeTiles(row, curr, row, curr - 1)
                    moved = true
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
                if curr < self.cols and self:getTileAt(row, curr) ~= nil and self:getTileAt(row, curr) == self:getTileAt(row, curr + 1) then
                    self:mergeTiles(row, curr, row, curr + 1)
                    moved = true
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
                if curr > 1 and self:getTileAt(curr, col) ~= nil and self:getTileAt(curr, col) == self:getTileAt(curr - 1, col) then
                    self:mergeTiles(curr, col, curr - 1, col)
                    moved = true
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
                if curr < self.rows and self:getTileAt(curr, col) ~= nil and self:getTileAt(curr, col) == self:getTileAt(curr + 1, col) then
                    self:mergeTiles(curr, col, curr + 1, col)
                    moved = true
                end
            end
        end
    end

    return moved
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

-- Game setup
function love.load()
    game = board:new(4, 4)
    tiles = {} -- create tiles for tile images 
    local tileNums = {2, 4, 8, 16, 32, 64, 128, 256, 512, 1024, 2048}
    for _, val in ipairs(tileNums) do 
        tiles[val] = love.graphics.newImage("tiles/tile_" .. val .. ".png") -- get the tile images from folder
    end
    newTile(game)
    newTile(game)
end

-- Input
function love.keypressed(key)
    local moved = false
    if key == "left" then moved = game:move(LEFT)
    elseif key == "right" then moved = game:move(RIGHT)
    elseif key == "up" then moved = game:move(UP)
    elseif key == "down" then moved = game:move(DOWN)
    end

    if moved then
        newTile(game)
        if isGameOver(game) then
            print("Game Over!")
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
