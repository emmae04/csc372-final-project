function love.conf(t) -- t = var passed in that includes information to be passed in 

    t.identity = "data/saves" -- set identity for save data         TODO: implement when time comes
    --t.version = "1.0.0" -- set version of game

    t.console = true -- enable console for debugging
    t.gammaCorrect = true -- gamma correction

    t.modules.audio = true -- enable audio module
    t.modules.event = true -- enable event module
    t.modules.graphics = true -- enable graphics module
    t.modules.image = true -- enable image module

    t.window.title = "2048" -- set window title
    t.window.width = 800 -- set window width
    t.window.height = 750 -- set window height
    t.window.resizable = true -- make window resizable
    t.window.fullscreen = false -- set fullscreen mode
    
end
