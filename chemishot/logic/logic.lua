import "./wheel/wheel"
import "./launch/launch"
import "./towers/towers"

local molecules <const> = { 'HHO', 'HOH', 'OHH', 'COO', 'OCO', 'OOC' }

local pd <const> = playdate
local gfx = pd.graphics

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
    DrawTower()

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
    DrawTower()
    LaunchUpdate()
    local launchEnded = DetectCollision()
    if launchEnded then
      Collided = true
      TOWER[#TOWER + 1] = Atom_sprite:copy()
      HandleCollisions()
      launchEnded = false
      next_state = WAIT
    end
  elseif state == WAIT then
    gfx.sprite.removeAll()
    DrawTower()
    gfx.sprite.update()
    -- Level is done
    if #TOWER == 0 then
      gfx.drawText('LEVEL DONE!', 50, 50)
      ATOMS[3]['locked'] = false
      LVL += 1
      TOWER = TOWERS[LVL]
      pd.wait(2000)
      next_state = SHOW
    else
      pd.wait(500)
      next_state = INIT
    end
  end

  state = next_state
end

function DrawTower()
  for _, atom in pairs(TOWER) do
    atom:setScale(0.8)
    atom:add()
  end
end

function DetectCollision()
  return #GetNeighbors(Atom_sprite, true) > 0
end

function HandleCollisions()
  local moleculeToTest = Atom_sprite.name
  local spritesToRemove = { Atom_sprite }
  local neighbors = GetNeighbors(Atom_sprite)
  for i = 1, #neighbors do
    local firstAtom = neighbors[i]
    spritesToRemove[2] = firstAtom
    moleculeToTest = Atom_sprite.name .. firstAtom.name
    if CheckAndRemoveMolecule(moleculeToTest, spritesToRemove) then
      return
    end
    -- Take the neighbors of the neighbor (we don't go deeper => molecule of 3 symbols max)
    local neighborsOfNeighbor = GetNeighbors(neighbors[i])
    -- Loop over the neighbors of the neighbor, do the same
    for j=1, #neighborsOfNeighbor do
      if not SameAtom(Atom_sprite, neighborsOfNeighbor[j]) then
        local secondAtom = neighborsOfNeighbor[j]
        spritesToRemove[3] = secondAtom
        moleculeToTest = Atom_sprite.name .. firstAtom.name .. secondAtom.name
        if CheckAndRemoveMolecule(moleculeToTest, spritesToRemove) then
          return
        end
      end
    end
  end
end

function table.contains(table, element)
  for _, value in pairs(table) do
    if value == element then
      return true
    end
  end
  return false
end

function SameAtom(a1, a2)
  return a1.x == a2.x and a1.y == a2.y
end

function GetNeighbors(sprite, retFirst)
  local neighbors = {}
  for _, atom in pairs(TOWER) do
    if Distance(sprite, atom) <= sprite.width / 2 + atom.width / 2 then
      neighbors[#neighbors+1] = atom
      if retFirst then return neighbors end
    end
  end
  return neighbors
end

function Distance(sprite1, sprite2)
  return math.sqrt((sprite1.x - sprite2.x)^2 + (sprite1.y - sprite2.y)^2)
end

function CheckAndRemoveMolecule(moleculeToTest, spritesToRemove)
  if table.contains(molecules, moleculeToTest) then
    print(moleculeToTest)
    -- Remove all sprites forming the molecule
    for _, sprite in pairs(spritesToRemove) do
      for i, atom in pairs(TOWER) do
        if SameAtom(sprite, atom) then
          table.remove(TOWER, i)
        end
      end
    end
    return true
  end
  return false
end