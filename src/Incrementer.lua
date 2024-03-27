local Incrementer = {}
Incrementer.__index = Incrementer

Incrementer.connections = {}

function Incrementer:Increment()
    self.count += 1
    return self.count
end

function Incrementer.new()
    local self = {}
    self.count = 0
    setmetatable(self, Incrementer)
    return self
end

return Incrementer
