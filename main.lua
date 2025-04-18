_G.love = require("love")

local board = {}
-- __index is a metamethod used for single inheritance
board.__index = board

-- create a enum-like way to reference directions
LEFT = 0
RIGHT = 1
UP = 2
DOWN = 3

function board:new(rows, cols)
    -- metatable allows change in behavior of tables 
    -- allows comparison / operations across different tables
    local Tiles = setmetatable(
        {
            {nil, nil, nil, nil},
            {nil, nil, nil, nil},
            {nil, nil, nil, nil},
            {nil, nil, nil, nil}
        }, board)
        self.rows = rows
        self.cols = cols
        self.tiles = Tiles
end

function board:getTileAt(x, y)
    -- takes an x/y position and returns
    -- the tile at that position in the board
    return self.tiles[x][y]
end

function board:setTileAt(x, y, val)
    -- will set a tile on the board to val at the
    -- given x/y position
    self.tiles[x][y] = val
end

function board:toString()
    -- will print a string representation of the board
    local Result = ""
    for row = 1,self.rows do
        for col = 1,self.cols do
            -- have to explicitly pass self for class methods.. interesting
            Result = Result .. self.getTileAt(self, row, col)
        end
    end
    print(Result)
end

function board:mergeTiles(t1x, t1y, t2x, t2y)
    -- will merge t1 into t2
    Sum = self.getTileAt(self, t1x, t1y) + self.getTileAt(self, t2x, t2y)
    self.setTileAt(self, t2x, t2y, Sum)
    self.setTileAt(self, t1x, t1y, Sum)
end

-- defining a higher order function, Dir, that will return a 
-- integer value associated with a given direction from the 
-- keyboard
Dir = function (str) if str == "RIGHT" then return 1
                     elseif str == "LEFT" then return 2
                     elseif str == "UP" then return 3
                     elseif str == "DOWN" then return 4
                     else return -1
                     end
end

function board:move(key, Dir)
    -- will move all the tiles on the board in a
    -- direction using a higher order function Dir
    -- note: indexing starts at 1, upper bound is inclusive
    if (Dir(key) == 0) then self.moveLeft(self) end
    if (Dir(key) == 1) then self.moveRight(self) end
    if (Dir(key) == 2) then self.moveUp(self) end
    if (Dir(key) == 3) then self.moveDown(self) end
end

function board:moveLeft()
    -- slides numbers over in the left direction
    -- todo: merge common numbers
    for row = 1, self.rows do
        for col = 2, self.cols do
            if self.getTileAt(self, row, col) ~= nil then
                Curr = col
                -- move current tile left until it reaches the
                -- end of the board, or until it hits another tile
                while Curr >=1 or self.getTileAt(self, row, Curr-1) ~= nil do
                    Curr = Curr - 1
                end
                -- if the tile we are moving to and the current tile have the same
                -- number, then merge the tiles. Otherwise, just move the tile to
                -- the new location 
                CurrTile = self.getTileAt(self, row, Curr-1)
                OldTile = board.getTileAt(self, row, col)
                if CurrTile ~= nil and
                    CurrTile == OldTile then
                    self.mergeTiles(self, row, Curr, row, col)
                else
                    self.setTileAt(self, row, Curr, OldTile)
                    self.setTileAt(self, row, col, nil)
                end
            end
        end
    end
end

function board:moveRight()
    -- slides numbers over in the right direction
    -- todo: merge common numbers
    for row = 1, self.rows do
        for col = self.cols-1, 1, -1 do
            if board.getTileAt(self, row, col) ~= nil then
                Curr = col
                -- move current tile right until it reaches the
                -- end of the board, or until it hits another tile
                while Curr <= 4 or board.getTileAt(self, row, Curr+1) ~= nil do
                    Curr = Curr + 1
                end
                -- if the tile we are moving to and the current tile have the same
                -- number, then merge the tiles. Otherwise, just move the tile to
                -- the new location 
                CurrTile = board.getTileAt(self, row, Curr+1)
                OldTile = board.getTileAt(self, row, col)
                if CurrTile ~= nil and CurrTile == OldTile then
                    self.mergeTiles(self, row, Curr, row, col)
                else
                    self.setTileAt(self, row, Curr, OldTile)
                end
            end
        end
    end

end

function board:moveUp()
    -- slides all numbers on the board up
    -- todo: merge common numbers
    for col = 1, self.cols do
        for row = 2, self.rows do
            if self.getTileAt(self, row, col) ~= nil then
                Curr = row
                -- move current tile up until it reaches the
                -- end of the board, or until it hits another tile
                while Curr >= 1 or self.getTileAt(self, Curr-1, col) ~= nil do
                    Curr = Curr - 1
                end
                -- if the tile we are moving to and the current tile have the same
                -- number, then merge the tiles. Otherwise, just move the tile to
                -- the new location 
                CurrTile = self.getTileAt(self, Curr-1, col)
                OldTile = self.getTileAt(self, row, col)
                if CurrTile ~= nil and CurrTile == OldTile then
                    self.mergeTiles(self, Curr, col, row, col)
                else
                    self.setTileAt(self, row, Curr, OldTile)
                    self.setTileAt(self, row, col, nil)
                end
            end
        end
    end
end

function board:moveDown() 
    -- slides all numbers on the board down
    -- todo: merge common numbers
    for col = 1, self.cols do
        for row = self.rows, 2, -1 do
            if self.getTileAt(self, row, col) ~= nil then
                Curr = row
                -- move current tile down until it reaches the
                -- end of the board, or until it hits another tile
                while Curr <= 4 or self.getTileAt(self, Curr+1, col)  ~= nil do
                    Curr = Curr + 1
                end
                -- if the tile we are moving to and the current tile have the same
                -- number, then merge the tiles. Otherwise, just move the tile to
                -- the new location 
                CurrTile = self.getTileAt(self, Curr+1, col)
                OldTile = self.getTileAt(self, row, col)
                if CurrTile ~= nil and CurrTile == OldTile then
                    self.mergeTiles(self, Curr, col, row, col)
                else
                    self.setTileAt(self, row, Curr, OldTile)
                    self.setTileAt(self, row, col, nil)
                end
            end
        end
    end
end

function love.load()
    -- for initializing the game

end

function love.update(dt)
    -- will update UI every tick (millisecond? idk)

end

function love.draw()
    -- create / load initial UI elements
    love.graphics.print("Hello World!")
end


function newTile()
    -- will create a new tile in a random empty spot on the board
    local emptySpots = {}
    local i = 1
    for row = 1, 4 do
        for col = 1, 4 do
            if board[row][col] == nil then
                table.insert(emptySpots, i, {row, col})
                i = i + 1
            end
        end
    end
    -- generate a random number, either 2 or 4
    local newNum = math.random(0, 1)
    -- ternary op I think?? (stack overflow said)
    newNum = newNum == 0 and 2 or 4
    -- generate a random spot out of the empty spots in the table
    local newSpot = math.random(1, #emptySpots)
    -- insert that new num in the new spot
    local newX = emptySpots[newSpot][1]
    local newY = emptySpots[newSpot][2]
    board[newX][newY] = newNum
end

function gameOver()
    -- will return true if the game is over, false otherwise
    -- the game is over if there are no more possible moves on
    -- the board left (ie. no two tiles can be merged together 
    -- in their current position)
    
    -- iterate through each tile on the board, checking each
    -- neighbor to see if it has a neighbor that can merge
    for row = 1, 4 do
        for col = 1, 4 do
            
        end
    end
end



