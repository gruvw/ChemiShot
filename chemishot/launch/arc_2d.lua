import "./launch/line_2d"

Arc2D = { direction = Line2D }

function Arc2D:new(o)
  o = o or { direction = Line2D:new() }
  setmetatable(o, self)
  self.__index = self
  return o
end

function Arc2D:fromForce(force)
  return Arc2D:new({ direction = self.direction:fromForce(force) })
end

function Arc2D:dist()
  return 0
end

function Arc2D:reverseDist(dist)
  local ratio = dist / self:dist()
  return Point2D:new({
    x = 0,
    y = 0,
  })
end
