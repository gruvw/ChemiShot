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
    local wallImage = gfx.image.new("images/towers/tower1")
    local wallImage2 = gfx.image.new("images/towers/tower2")
    wallSprite = gfx.sprite.new(wallImage)
    wallSprite:setCollideRect(0, 0, wallSprite:getSize())
    wallSprite:moveTo(300, 200)
    wallSprite:add()
    wallSprite2 = gfx.sprite.new(wallImage2)
    wallSprite2:setCollideRect(0, 0, wallSprite:getSize())
    wallSprite2:moveTo(200, 200)
    wallSprite2:add()
    LaunchUpdate()
    -- gfx.drawCircleAtPoint(100, 100, 30)
  end

  state = next_state
  
end
