Mod = {
    sum = function(a, b)
        return a + b
    end,

    sub = function(a, b)
        return a - b
    end
}

function Mod.sayHello(name) 
    print("Hello, " .. name)
end

return Mod