import "./launch/line_2d"

local LINE_FACTOR = 40;

Arc2D = { direction = Line2D, acc = 1, v0x = 1, v0y = 1 }

function Arc2D:new(o)
  o = o or { direction = Line2D:new(), acc = 1, v0x = 1, v0y = 1 }

  o.v0x = (o.direction.finish.x - o.direction.start.x)
  o.v0y = (o.direction.start.y - o.direction.finish.y)

  setmetatable(o, self)
  self.__index = self

  return o
end

function Arc2D:withForce(force)
  return Arc2D:new({ direction = self.direction:fromForce(force), acc = self.acc })
end

function Arc2D:dist()
  return (self.v0y + math.sqrt(self.v0y ^ 2 - 4 * self.acc * (self.direction.start.y - 240))) / (2 * self.acc) * LINE_FACTOR
end

function Arc2D:reverseDist(dist)
  local x = self.v0x * dist / LINE_FACTOR;

  return Point2D:new({
    x = self.direction.start.x + x,
    y = self.direction.start.y - (self.v0y / self.v0x * x - self.acc * x ^ 2 / (self.v0x ^ 2)),
  })
end
