import "./wheel/wheel"
import "./launch/launch"
import "./towers/towers"

local pd <const> = playdate
local gfx = pd.graphics

local colPadIn = 3

local LVL = 1
-- FSM
local INTRO = 0
local INIT = 1
local WHEEL = 2
local LAUNCH = 3
local state = INIT
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
    Atom_sprite:setCollideRect(colPadIn, colPadIn, Atom_sprite.width - 2*colPadIn, Atom_sprite.height - 2*colPadIn)

    for y_index, floor in pairs(TOWERS[LVL]) do
        for x_index, atom in pairs(floor) do
            atom:setScale(0.8) -- TODO fix this
            atom:moveTo(350 -  x_index * atom.width, pd.display.getHeight() - y_index * atom.height / 2)
            atom:setCollideRect(colPadIn, colPadIn, atom.width - 2*colPadIn, atom.height - 2*colPadIn)
            atom:add()
        end
    end

    LaunchUpdate()
    -- gfx.drawCircleAtPoint(100, 100, 30)
  end
  state = next_state
end
