-- love basics 
_G.love = require("love")

function love.load() -- loads in data when app starts up
    love.graphics.setBackgroundColor(20 /255, 50/256, 80/256) -- set background color
    _G.number = 0 
    _G.inputCooldown = 0 -- start with no cooldown
end

function love.update(dt) -- runs once every 60 frames , dt deltaTime
    if _G.inputCooldown > 0 then
        _G.inputCooldown = _G.inputCooldown - dt
        return
    end
    if love.keyboard.isDown("escape") then -- esc = quit
        love.event.quit() 
    elseif love.keyboard.isDown("a") then -- a = left
        _G.number = 0 -- reset number
        _G.inputCooldown = 0.2

    elseif love.keyboard.isDown("s") then -- s = down
        _G.number = _G.number + 1 -- increment number
        _G.inputCooldown = 0.2

    elseif love.keyboard.isDown("d") then -- d = right
        _G.number = _G.number - 1 -- decrement number
        _G.inputCooldown = 0.2

    elseif love.keyboard.isDown("w") then -- w = up
        _G.number = _G.number * 2 -- double number
        _G.inputCooldown = 0.2
    end
end

function love.draw() -- graphics draws to screen
    love.graphics.setColor(210 / 255, 180 / 255, 140 / 255) -- set text color to rgb (have /256 to get 0-1 value)
    love.graphics.setFont(love.graphics.newFont(20)) -- set font size
    love.graphics.print(_G.number) -- print number

    love.graphics.rectangle("fill", 100, 100, 200, 200) -- draw rectangle (fill/line..., x, y, dx, dy)

    -- love.graphics.clear() -- clear screen
end