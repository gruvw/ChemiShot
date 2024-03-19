local gfx = playdate.graphics
local geom = playdate.geometry

local BASE_ANGLE = 90
local MIN_ANGLE = BASE_ANGLE + 80
local MAX_ANGLE =  BASE_ANGLE + 25
local CRANK_FACTOR = 20

local start = geom.vector2D.new(30, 240 - 30)
local angle = BASE_ANGLE + 45

function LaunchUpdate()
  gfx.clear()
  local new_angle = angle + playdate.getCrankChange() / CRANK_FACTOR
  angle = math.max(MAX_ANGLE, math.min(MIN_ANGLE, new_angle))
  local x, y = start:unpack()
  local adj = - y / math.tan(math.rad(angle))
  gfx.setLineWidth(2)
  gfx.drawLine(x, y, x + adj, 0)
end
