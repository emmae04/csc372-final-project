_G.Gameboard = {} -- create class gameboard
Gameboard.__index = Gameboard 


function Gameboard:spawnTile()
    local emptySpaces = {} -- table to store empty spaces
    for x = 1, self.length do
        for y = 1, self.length do
            if self.spaces[x][y]:isEmpty() then
                table.insert(emptySpaces, self.spaces[x][y])
            end
        end
    end

    if #emptySpaces > 0 then -- picks out random empty space to add tile
        local space = emptySpaces[math.random(#emptySpaces)]
        
        -- 75% chance for 2, 25% chance for 4
        local value = math.random() < 0.75 and 2 or 4

        space.tile = Tile:new(space.x, space.y, value)
    end
end



function Gameboard:printBoard() -- debuggin 
    for y = 1, self.length do
        local row = {}
        for x = 1, self.length do
            local space = self.spaces[x][y]
            if space.tile then
                table.insert(row, string.format("%4d", space.tile.value))
            else
                table.insert(row, "   .")
            end
        end
        print(table.concat(row, " "))
    end
    print("") -- newline after board
end


function Gameboard:create()
    local b = setmetatable({}, Gameboard)
    b.length = 4
    b.spaces = {}
    for x = 1, b.length do
        b.spaces[x] = {}
        for y = 1, b.length do
            b.spaces[x][y] = Space:new(x, y) -- create new space 
        end
    end

    -- spawn starting tiles
    b:spawnTile() 
    b:spawnTile() 

    return b
end



Space = {} -- is a grid space for the gameboard
Space.__index = Space

function Space:new(x, y)
    local s = setmetatable({}, Space)
    s.x = x
    s.y = y
    s.tile = nil
    return s
end

function Space:isEmpty()
    return self.tile == nil
end





Tile = setmetatable({}, { __index = Space }) -- Tile is a subclass of Space and are the movable tiles
Tile.__index = Tile

function Tile:new(x, y, value)
    local t = Space.new(self, x, y)  -- super constructor
    setmetatable(t, Tile)
    t.value = value or 2
    t.merged = false
    return t
end



-- testing out
local board = Gameboard:create()
board:printBoard()
