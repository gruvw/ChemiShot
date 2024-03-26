local gfx = playdate.graphics
local geom = playdate.geometry

local BASE_ANGLE = 90
local DASH_LEN = 10
local MIN_ANGLE = BASE_ANGLE + 80
local MAX_ANGLE =  BASE_ANGLE + 25
local CRANK_FACTOR = 20

local start = geom.vector2D.new(30, 240 - 30)
local angle = BASE_ANGLE + 45

Point2D = { x = 0, y = 0 }

function Point2D:new(o)
  o = o or { x = 0, y = 0 }
  setmetatable(o, self)
  self.__index = self
  return o
end

Line2D = { start = Point2D:new({ x = 0, y = 0 }), finish = Point2D:new({ x = 0, y = 0}) }

function Line2D:new(o)
  o = o or { start = Point2D:new(), finish = Point2D:new() }
  setmetatable(o, self)
  self.__index = self
  return o
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

function Line2D:straightLinePoints(length)
  local n_seg = self:dist() // length
  local lines = {}

  for seg = 1, n_seg, 2 do
    lines[seg // 2] = Line2D:new({
      start = self:reverseDist((seg - 1) * length),
      finish = self:reverseDist(seg * length),
    })
  end

  return lines
end

function LaunchUpdate()
  gfx.clear()

  local new_angle = angle + playdate.getCrankChange() / CRANK_FACTOR
  angle = math.max(MAX_ANGLE, math.min(MIN_ANGLE, new_angle))

  local x, y = start:unpack()
  local adj = - y / math.tan(math.rad(angle))

  local line = Line2D:new({
    start = Point2D:new({ x = x, y = y }),
    finish = Point2D:new({ x = x + adj, y = 0 })
  })

  gfx.setLineWidth(2)
  for _, l in ipairs(line:straightLinePoints(DASH_LEN)) do
    gfx.drawLine(l.start.x, l.start.y, l.finish.x, l.finish.y)
  end
end
