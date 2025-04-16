function love.draw()
    love.graphics.print("Hello World!")
end

-- initializing a 4x4 board
-- represent objects (tiles on the board
-- as functions)
board = {
    {nil, nil, nil, nil},
    {nil, nil, nil, nil},
    {nil, nil, nil, nil},
    {nil, nil, nil, nil}
}

-- create a enum-like way to reference 
-- directions
LEFT = 0
RIGHT = 1
UP = 2
DOWN = 3

function getTileAt(x, y)
    -- takes an x/y position and returns
    -- the tile at that position in the board
    if (x >= 0 and x <= 4 and y >= 0 and y <= 4) then
        return board[x][y] 
    else
        return nil
    end
end

function mergeTiles(t1x, t1y, t2x, t2y)
    -- will merge t1 into t2
    Sum = board[t1x][t1y] + board[t2x][t2y]
    board[t2x][t2y] = Sum
    board[t1x][t1y] = nil;
end

function move(dir)
    -- will move all the tiles on the board in a
    -- direction dir
    -- note: indexing starts at 1, upper bound is inclusive
    if (dir == 0) then moveLeft() end
    if (dir == 1) then moveRight() end
    if (dir == 2) then moveUp() end
    if (dir == 3) then moveDown() end
end

function moveLeft()
    -- slides numbers over in the left direction
    -- todo: merge common numbers
    for row = 1, 4 do
        for col = 2, 4 do
            if board[row][col] ~= nil then
                Curr = col
                -- move current tile left until it reaches the
                -- end of the board, or until it hits another tile
                while Curr >=1 or board[row][Curr-1] ~= nil do
                    Curr = Curr - 1
                end

                -- if the tile we are moving to and the current tile have the same
                -- number, then merge the tiles. Otherwise, just move the tile to
                -- the new location 
                if board[row][Curr-1] ~= nil and board[row][Curr-1] == board[row][col] then
                    mergeTiles(row, Curr, row, col)
                else
                    board[row][Curr] = board[row][col];
                    board[row][col] = nil
                end
            end
        end
    end
end

function moveRight()
    -- slides numbers over in the right direction
    -- todo: merge common numbers
    for row = 1, 4 do
        for col = 3, 1, -1 do
            if board[row][col] ~= nil then
                Curr = col
                -- move current tile right until it reaches the
                -- end of the board, or until it hits another tile
                while Curr <= 4 or board[row][Curr+1] ~= nil do
                    Curr = Curr + 1
                end
                -- if the tile we are moving to and the current tile have the same
                -- number, then merge the tiles. Otherwise, just move the tile to
                -- the new location 
                if board[row][Curr+1] ~= nil and board[row][Curr+1] == board[row][col] then
                    mergeTiles(row, Curr, row, col)
                else
                    board[row][Curr] = board[row][col];
                    board[row][col] = nil
                end
            end
        end
    end

end

function moveUp()
    -- slides all numbers on the board up
    -- todo: merge common numbers
    for col = 1, 4 do
        for row = 2, 4 do
            if board[col][row] ~= nil then
                Curr = row
                -- move current tile up until it reaches the
                -- end of the board, or until it hits another tile
                while Curr >= 1 or board[Curr-1][col] ~= nil do
                    Curr = Curr - 1
                end
                -- if the tile we are moving to and the current tile have the same
                -- number, then merge the tiles. Otherwise, just move the tile to
                -- the new location 
                if board[Curr-1][col] ~= nil and board[Curr-1][col] == board[row][col] then
                    mergeTiles(Curr, col, row, col)
                else
                    board[row][Curr] = board[row][col];
                    board[row][col] = nil
                end
            end
        end
    end
end

function moveDown() 
    -- slides all numbers on the board down
    -- todo: merge common numbers
    for col = 1, 4 do
        for row = 4, 2, -1 do
            if board[row][col] ~= nil then
                Curr = row
                -- move current tile down until it reaches the
                -- end of the board, or until it hits another tile
                while Curr <= 4 or board[Curr+1][col] ~= nil do
                    Curr = Curr + 1
                end
                -- if the tile we are moving to and the current tile have the same
                -- number, then merge the tiles. Otherwise, just move the tile to
                -- the new location 
                if board[Curr+1][col] ~= nil and board[Curr+1][col] == board[row][col] then
                    mergeTiles(Curr, col, row, col)
                else
                    board[row][Curr] = board[row][col];
                    board[row][col] = nil
                end
            end
        end
    end
end



function initUI() 

end



