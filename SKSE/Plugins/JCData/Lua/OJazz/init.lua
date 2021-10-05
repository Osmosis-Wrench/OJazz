local jc = jrequire 'jc'

local ojazz = {}

function ojazz.getValidRandom(collection, last)
    local array =  JArray.object()
    array = jc.filter(collection, function(x)
        return x.Enabled == 1 and x.Title ~= last
    end)
    local random = math.random(#array)
    return array[random]
end

function ojazz.returnPoop()
    return "poop"
end

return ojazz