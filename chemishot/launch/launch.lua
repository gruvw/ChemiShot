import "./launch/line_2d"
import "./launch/arc_2d"

local gfx = playdate.graphics
local geom = playdate.geometry

local BASE_ANGLE = 90
local MIN_ANGLE = BASE_ANGLE + 25
local MAX_ANGLE = BASE_ANGLE + 80

local MIN_FORCE = 10
local MAX_FORCE = 100

local CRANK_FACTOR = 20

local DASH_LEN = 10

local start = geom.vector2D.new(30, 240 - 30)
local angle = BASE_ANGLE + 45
local force = MIN_FORCE

local is_angle = true

local arc = Arc2D:new()

-- Dashed line from an object that implementents a total arc distance function `dist` and a function that gets the destination point from a distance on curve to origin, spaced by 'length'
local function linePoints(object, dist, reverseDist, length)
  local n_seg = dist(object) // length
  local lines = {}

  for seg = 1, n_seg, 2 do
    lines[seg // 2] = Line2D:new({
      start = reverseDist(object, (seg - 1) * length),
      finish = reverseDist(object, seg * length),
    })
  end

  return lines
end

function LaunchUpdate()
  gfx.clear()
  gfx.setLineWidth(2)

  if is_angle then
    -- Select launch angle (dashed line)

    -- Update angle with crank
    local new_angle = angle + playdate.getCrankChange() / CRANK_FACTOR
    angle = math.min(MAX_ANGLE, math.max(MIN_ANGLE, new_angle))

    local x, y = start:unpack()
    local adj = -y / math.tan(math.rad(angle))

    local line = Line2D:new({
      start = Point2D:new({ x = x, y = y }),
      finish = Point2D:new({ x = x + adj, y = 0 })
    })

    for _, l in ipairs(linePoints(line, line.dist, line.reverseDist, DASH_LEN)) do
      gfx.drawLine(l.start.x, l.start.y, l.finish.x, l.finish.y)
    end

    -- Confirm angle
    if playdate.buttonJustPressed(playdate.kButtonA) then
      is_angle = false
      arc = Arc2D:new({ direction = line:fromForce(force) })
    end
  else
    -- Select launch force (dashed arc)

    -- Update force with crank
    local new_force = force + playdate.getCrankChange() / CRANK_FACTOR
    force = math.min(MAX_FORCE, math.max(MIN_FORCE, new_force))

    print(force)

    arc = arc:fromForce(force)

    gfx.drawLine(arc.direction.start.x, arc.direction.start.y, arc.direction.finish.x, arc.direction.finish.y)
  end
end
