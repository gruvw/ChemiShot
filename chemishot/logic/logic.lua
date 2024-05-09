import "./wheel/wheel"
import "./launch/launch"
import "./towers/towers"

local pd <const> = playdate
local gfx = pd.graphics

local colPadIn = 2

local LVL = 1
local TOWER = TOWERS[LVL]
-- FSM
local INTRO = 0
local INIT = 1
local SHOW = 2
local WHEEL = 3
local LAUNCH = 4
local WAIT = 5
local state = SHOW
local next_state = state

SelectedAtom = 0

function LogicUpdate()
  if state == INTRO then
    if IntroUpdate() then
      gfx.sprite.removeAll()
      gfx.clear()
      next_state = SHOW
    end
  elseif state == SHOW then
    gfx.sprite.removeAll()
    gfx.clear()
    drawTower()

    gfx.sprite.update()
    gfx.drawText('Destroy this tower!', 50, 50)
    if pd.buttonJustPressed(pd.kButtonA) then
      next_state = INIT
    end
  elseif state == INIT then
    gfx.sprite.removeAll()
    gfx.clear()
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

    drawTower()

    local launchEnded = LaunchUpdate()
    if launchEnded == true then
      TOWER[#TOWER + 1] = Atom_sprite:copy()
      handleCollisions()
      launchEnded = false
      next_state = WAIT
    end
  elseif state == WAIT then
    drawTower()
    gfx.sprite.update()
    pd.wait(500)
    next_state = INIT
  end

  state = next_state
end

function drawTower()
  for i, atom in pairs(TOWER) do
    atom:setScale(0.8) -- TODO fix this
    atom:setCollideRect(colPadIn, colPadIn, atom.width - 2*colPadIn, atom.height - 2*colPadIn)
    atom:add()
  end
end

function handleCollisions()
  -- local w = Atom_sprite.width
  -- local h = Atom_sprite.height
  -- local neighbors = gfx.sprite.querySpritesInRect(Atom_sprite.x - w / 2, Atom_sprite.y - h / 2, w, h)
  local neighbors = Atom_sprite:overlappingSprites()
  for i = 1, #neighbors do
    local atom = neighbors[i]
    print(atom.name)
  end

end