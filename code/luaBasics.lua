-- this is a comment
--[[ 
    multiline comment 
    ...
]]

print("Hello World") -- prints whole line no need for ln 
print("Hello " .. "world") -- concatenates

--[[
    Lua quick reference:

    nil -- null value
    number -- number
    string -- string
    boolean -- boolean
    table -- array
    function -- function
]]

-- creating a variable with scope  
local a = 10 -- local variable

local multLineStr = [[
    this is a 
    multiline string
]]

local one, two, three = "hello", 2, 3.2 -- multiple assignment

print("one.length = " .. #one) -- length of string (also cound do print(string.len(one)) )
print("one.upper = " .. string.upper(one)) -- convert to upper case can do lower as well

local twoString = tostring(two) -- convert to string

_G.GlobalVar = 10 -- global variable, can go across files

-- if elseif else 
if a == 10 then
    print("a is 10")
elseif a == 20 then
    print("a is 20")
else
    print("a is not 10 or 20")
end

-- for loop for i in range increment
for i = 1, 10, 2 do
    print("i = " .. i)
end

-- while loop
local i = 1
while i <= 10 do
    print("i = " .. i)
    i = i + 1
end

-- repeat until loop
local i = 1
repeat
    print("i = " .. i)
    i = i + 1
until i > 10


-- user input
io.write("Enter a number: ")
local input = io.read("*n") -- read number
print("You entered: " .. input)

-- table
local myTable = {1, 2.1, "na" } -- array
for i = 1, #myTable do
    print(myTable[i])
end

-- add to table also can remove 
table.insert(myTable, 6) -- add to end
table.insert(myTable, 1, 0) -- add to start 

-- easy print a table
print("myTable = " .. table.concat(myTable, ", ")) -- print table with comma separator


-- function
function add(a, b) -- no need for return type
    return a + b
end
print("add(1, 2) = " .. add(1, 2)) -- call function


-- file outputs
-- io.output("test.txt") -- set output file 
-- io.write("Hello World") -- write to file
-- io.flush() -- flush output
-- io.close() -- close file

-- miscellaneous 
-- != is ~=
print(math.random(1, 10)) -- random number between 1 and 10
-- using other files
local Mod = require("otherClass") -- load module
print(Mod.sum(1, 2)) 
print(Mod.sub(1, 2)) 
Mod.sayHello("John")

--OOP
local Person = { -- create class
    name = "",
    age = 0,

    new = function(self, name, age)
        local obj = {}
        setmetatable(obj, self)
        self.__index = self
        obj.name = name
        obj.age = age
        return obj
    end,

    sayHello = function(self) -- method for class
        print("Hello, my name is " .. self.name .. " and I am " .. self.age .. " years old.")
    end
}
local john = Person:new("John", 30) -- create object
john:sayHello() -- call method


