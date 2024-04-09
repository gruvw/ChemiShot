import "./launch/line_2d"
import "./launch/arc_2d"

local pd<const> = playdate
local gfx<const> = pd.graphics
local geom<const> = pd.geometry

local BASE_ANGLE = 90
local MIN_ANGLE = BASE_ANGLE + 25
local MAX_ANGLE = BASE_ANGLE + 80

local MIN_FORCE = 20
local MAX_FORCE = 60

local CRANK_FACTOR = 20

local DASH_LEN = 10

local start = geom.vector2D.new(30, 240 - 30)
local angle = (MAX_ANGLE + MIN_ANGLE) / 2
local force = (MAX_FORCE + MIN_FORCE) / 2

-- FSM
local FSM_ANGLE = 0
local FSM_FORCE = 1
local FSM_LAUNCH = 2
local state = FSM_ANGLE
local next_state = FSM_ANGLE

-- Arc line params
local arc = Arc2D:new()
local acc = 3;

-- Launch annimation
local atom_pos = Point2D:new()
local launch_t = 0

-- Dashed line from an object that implementents a total arc distance function `dist` and a function that gets the destination point from a distance on curve to origin, spaced by 'length'
local function linePoints(object, dist, reverseDist, length)
  local n_seg = dist(object) // length
  local lines = {}

  for seg = 1, n_seg + 2, 2 do
    lines[1 + seg // 2] = Line2D:new({
      start = reverseDist(object, (seg - 1) * length),
      finish = reverseDist(object, seg * length),
    })
  end

  return lines
end

function LaunchUpdate()
  gfx.clear()
  gfx.setLineWidth(4)

  if state == FSM_ANGLE then
    -- Select launch angle (dashed line)

    -- Update angle with crank
    local new_angle = angle + pd.getCrankChange() / CRANK_FACTOR
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
    if pd.buttonJustPressed(pd.kButtonA) then
      next_state = FSM_FORCE
      arc = Arc2D:new({ direction = line:fromForce(force), acc = acc })
    end
  elseif state == FSM_FORCE then
    -- Select launch force (dashed arc)

    -- Update force with crank
    local new_force = force + pd.getCrankChange() / CRANK_FACTOR
    force = math.min(MAX_FORCE, math.max(MIN_FORCE, new_force))

    arc = arc:withForce(force)

    for _, l in ipairs(linePoints(arc, arc.dist, arc.reverseDist, DASH_LEN)) do
      gfx.drawLine(l.start.x, l.start.y, l.finish.x, l.finish.y)
    end

    if pd.buttonJustPressed(pd.kButtonA) then
      next_state = FSM_LAUNCH
      atom_pos = arc.direction.start
    end
  else
    gfx.setLineWidth(2)

    -- Launch annimation
    if not (atom_pos.x < pd.display.getWidth() and atom_pos.y < pd.display.getHeight() and atom_pos.x > 0 and atom_pos.y > 0) then
      launch_t = 0
      next_state = FSM_ANGLE
    else
      atom_pos = arc:reverseDist(launch_t)
      launch_t += 10

      gfx.drawCircleAtPoint(atom_pos.x, atom_pos.y, 3)
    end
  end

  state = next_state
end
