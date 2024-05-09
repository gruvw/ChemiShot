import "./launch/line_2d"
import "../atoms/atom_sprite"
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
local FSM_DONE = 3
local state = FSM_ANGLE
local next_state = FSM_ANGLE

-- Arc line params
local arc = Arc2D:new()
local acc = 3;

-- Launch annimation
local atom_pos = Point2D:new()
local launch_t = 0

local x, y = start:unpack()

local canvas = gfx.image.new(pd.display.getWidth(), pd.display.getHeight())
local canvas_sprite = gfx.sprite.new(canvas)

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

function LaunchInit()
  Atom_sprite = ATOMS[SelectedAtom + 1]:copy()
  Atom_sprite:moveTo(x, y)
  Atom_sprite:setScale(0.8)
  Atom_sprite:add()
  Atom_sprite:setZIndex(1)
  Atom_sprite.collisionResponse = 'freeze'

  canvas_sprite:add()
  canvas_sprite:moveTo(pd.display.getWidth() / 2, pd.display.getHeight() / 2)
  canvas_sprite:setZIndex(0)

  launch_t = 0
end

function LaunchUpdate()
  gfx.clear()
  gfx.setLineWidth(4)

  gfx.lockFocus(canvas)
  gfx.clear()
  if state == FSM_ANGLE then
    -- Select launch angle (dashed line)

    -- Update angle with crank
    local new_angle = angle + pd.getCrankChange() / CRANK_FACTOR
    angle = math.min(MAX_ANGLE, math.max(MIN_ANGLE, new_angle))

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
  elseif state == FSM_LAUNCH then
    gfx.setLineWidth(2)

    -- Launch animation
    local padding = Atom_sprite:getSize() / 2
    if atom_pos.x + padding >= pd.display.getWidth() or atom_pos.y + padding >= pd.display.getHeight() then
      launch_t = 0
      Atom_sprite:remove()
      LaunchInit()
      next_state = FSM_ANGLE
    else
      atom_pos = arc:reverseDist(launch_t)
      launch_t += 10

      local _, _, collisions, collisionsLen = Atom_sprite:moveWithCollisions(atom_pos.x, atom_pos.y)
      if collisionsLen > 0 then
        next_state = FSM_DONE
      end

    end
  elseif state == FSM_DONE then
    next_state = FSM_ANGLE
    state = next_state -- Force changing the state
    return true
  end
  gfx.unlockFocus()

  gfx.sprite.update()

  state = next_state
  return false
end
