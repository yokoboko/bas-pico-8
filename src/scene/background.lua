background={}

function background:new(o)
    o=setmetatable(o or {},self)
    self.__index=self
    return o
end

function background:update()
end

function background:draw()
end