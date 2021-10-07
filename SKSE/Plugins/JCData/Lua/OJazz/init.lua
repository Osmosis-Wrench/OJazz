local jc = jrequire 'jc'

local ojazz = {}

function ojazz.getValidRandom(collection, last)
    local array = jc.filter(collection, function(x)
        return x.Enabled == 1 and x.Title ~= last
    end)
    local random = math.random(#array)
    return array[random]
end

return ojazz