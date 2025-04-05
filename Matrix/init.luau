local Types = require("Types.luau")

local matrix = {}
matrix.__index = matrix
matrix.Types = Types

local function Operate(v0, v1, operator)
    local operators = {
        ["+"] = function(a, b) return a + b end,
        ["-"] = function(a, b) return a - b end,
        ["*"] = function(a, b) return a * b end,
        ["/"] = function(a, b) return a / b end,
        ["//"] = function(a, b) return a // b end,
    }
    
    local data, type, size, scale = v0.data, v0.type, v0.size, v0.scale
    local read, write, round = type.read, type.write, math.round

    local isfloat = type.name == "f32" or type.name == "f64"
    local ismatrix = typeof(v1) ~= "number"

    local result = matrix.new(type, scale)
    for steps = 0, size-1, type.usage do
        local new = operators[operator](
            read(data, steps),
            if ismatrix then
                read(v1.data, steps)
            else
                v1
        )
        new = if isfloat then new else round(new)

        write(result.data, steps, new)
    end

    return result
end


function matrix.__add(self, value)
    return Operate(self, value, "+")
end
function matrix.__sub(self, value)
    return Operate(self, value, "-")
end
function matrix.__mul(self, value)
    return Operate(self, value, "*")
end
function matrix.__div(self, value)
    return Operate(self, value, "/")
end
function matrix.__idiv(self, value)
    return Operate(self, value, "//")
end

function matrix:toarray()
    error("not implemented")
end

function matrix:getoffset(position: {number})
    local numtype = self.type
    local scale = self.scale

    local cursor = 0
    for index, size in next, scale do
        assert(position[index]<size, `position[{index}] exceed size of matrix`)

        local length = 1
        for steps = index+1, #scale do
            length*=scale[steps]
        end
        cursor+=length*position[index]
    end
    cursor*=numtype.usage

    return cursor
end

function matrix:fill(value: number)
    local numtype = self.type
    for steps = 0, self.size-1, numtype.usage do
        numtype.write(self.data, steps, value)
    end

    return self
end

function matrix:set(position: {number}, value: number)
    self.type.write(
        self.data,
        self:getoffset(position),
        value
    )

    return self
end

function matrix:get(position: {number})
    return self.type.read(
        self.data,
        self:getoffset(position)
    )
end

function matrix.new(numtype, scale : { number })
    local self = setmetatable({}, matrix)
    
    local size = numtype.usage
    for _, length in next, scale do
        size*=length
    end
    assert(size<=2^30, `buffer's maximum size is 2^30, but got 2^{math.log(size, 2)}`)

    self.scale = scale
    self.size = size
    self.type = numtype
    self.data = buffer.create(size)
    
    
    return self
end

function matrix.vector(...)
    return {...}
end


return matrix