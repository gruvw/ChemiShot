import "./wheel/wheel"
import "./launch/launch"

local pd <const> = playdate
local gfx = pd.graphics

-- FSM
local INIT = 0
local WHEEL = 1
local LAUNCH = 2
local state = INIT
local next_state = state

SelectedAtom = 0

function LogicUpdate()
  if state == INIT then
    InitWheel()
    next_state = WHEEL
  elseif state == WHEEL then
    SelectedAtom = WheelUpdate()
    gfx.sprite.update()
    -- Confirm atom selected
    if pd.buttonJustPressed(pd.kButtonA) then
      next_state = LAUNCH
      gfx.sprite.removeAll()
      gfx.clear()
      LaunchInit()
    end
  elseif state == LAUNCH then
    LaunchUpdate()
    -- gfx.drawCircleAtPoint(100, 100, 30)
  end

  state = next_state
end
