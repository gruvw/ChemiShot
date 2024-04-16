import "./wheel/wheel"
import "./launch/launch"

local pd <const> = playdate
local gfx = pd.graphics

-- FSM
local INTRO = 0
local INIT = 1
local WHEEL = 2
local LAUNCH = 3
local state = INTRO
local next_state = state

SelectedAtom = 0

function LogicUpdate()
  if state == INTRO then
    if IntroUpdate() then
      gfx.sprite.removeAll()
      gfx.clear()
      next_state = INIT
    end
  elseif state == INIT then
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
