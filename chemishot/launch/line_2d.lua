Point2D = { x = 0, y = 0 }

function Point2D:new(o)
  o = o or { x = 0, y = 0 }
  setmetatable(o, self)
  self.__index = self
  return o
end

Line2D = { start = Point2D, finish = Point2D }

function Line2D:new(o)
  o = o or { start = Point2D:new(), finish = Point2D:new() }
  setmetatable(o, self)
  self.__index = self
  return o
end

function Line2D:fromForce(force)
  return Line2D:new({
    start = self:reverseDist(0),
    finish = self:reverseDist(force),
  })
end

function Line2D:dist()
  return math.sqrt((self.start.x - self.finish.x) ^ 2 + (self.start.y - self.finish.y) ^ 2)
end

function Line2D:reverseDist(dist)
  local ratio = dist / self:dist()
  return Point2D:new({
    x = self.start.x + (self.finish.x - self.start.x) * ratio,
    y = self.start.y + (self.finish.y - self.start.y) * ratio,
  })
end
