import "../atoms/atom_sprite"
import "../atoms/atoms"

local pd <const> = playdate
local gfx <const> = pd.graphics

-- List of wheel constants
local CTR <const> = { pd.display.getWidth() / 2, pd.display.getHeight() / 2 }
local wheelRadius <const> = 110
local lineWidth <const> = 8
local bubbleSize <const> = 20
local dstCenter <const> = 80

local accum = 0

local lockedImage <const> = gfx.image.new('images/lock.png')
local selectionImage <const> = gfx.image.new('images/selection.png')

local infoWindowIsDrawn = false
local infoWindowText = "No atom selected"
local infoWindowSprite = gfx.sprite.new()
infoWindowSprite:setSize(300, 200)
infoWindowSprite:moveTo(200, 120)
infoWindowSprite:setZIndex(899)

function infoWindowSprite:draw()
  gfx.pushContext()
  gfx.setColor(gfx.kColorWhite)
  gfx.fillRect(0, 0, 300, 200)

  gfx.setLineWidth(4)
  gfx.setColor(gfx.kColorBlack)
  gfx.drawRoundRect(0, 0, 300, 200, 40)

  gfx.drawTextInRect(infoWindowText, 20, 20, 260, 160)

  gfx.popContext()
end

local nbAtoms = #ATOMS
local nbAtomsAvail = 0

local pos = 0
local selectAngle = 0
local selectionSprite = gfx.sprite.new(selectionImage)

function InitWheel()
  selectionSprite:setScale(1.5)
  selectionSprite:add()

  selectAngle = 0

  -- Set background disk
  gfx.sprite.setBackgroundDrawingCallback(
    function(x, y, width, height)
      gfx.pushContext()
      gfx.setLineWidth(lineWidth)
      gfx.drawCircleAtPoint(CTR[1], CTR[2], wheelRadius)
      gfx.popContext()
    end
  )

  nbAtomsAvail = 0
  for _, atom in pairs(ATOMS) do
    if not atom.locked then
      nbAtomsAvail += 1
    end
  end

  -- Prepare and place images for all atoms in list
  for i, atom in pairs(ATOMS) do
    local bubbleImage = gfx.image.new(bubbleSize * 2, bubbleSize * 2)
    local bubbleSprite = gfx.sprite.new(bubbleImage)
    if not atom.locked then
      bubbleSprite = atom:copy()
      bubbleSprite:setScale(0.8)
    else
      ---@diagnostic disable-next-line: param-type-mismatch
      bubbleSprite:setImage(lockedImage)
    end

    bubbleSprite:moveTo(
      CTR[1] + dstCenter * math.sin(2 * math.pi / nbAtoms * (i - 1)),
      CTR[2] - dstCenter * math.cos(2 * math.pi / nbAtoms * (i - 1))
    )
    bubbleSprite:add()
  end
end

function WheelUpdate()
  -- Turn the selector and find which atom it is
  if not infoWindowIsDrawn then
    local change, _ = pd.getCrankChange()
    selectAngle += math.rad(change)
    if selectAngle < 0 then
      selectAngle = 0
      accum += math.rad(change)
      if accum < -math.pi / nbAtoms * pos then
        selectAngle = 2*math.pi / nbAtoms * nbAtomsAvail - math.pi / nbAtoms / 2
        accum = 0
      end
    end
    if accum == 0 then
        selectAngle = math.fmod(selectAngle, 2 * math.pi / nbAtoms * nbAtomsAvail)
    end
    pos = selectAngle // (2 * math.pi / nbAtoms)
    infoWindowText = ATOMS[pos + 1].description
    local pointX = CTR[1] + dstCenter * math.sin(2 * math.pi / nbAtoms * pos)
    local pointY = CTR[2] - dstCenter * math.cos(2 * math.pi / nbAtoms * pos)
    selectionSprite:moveTo(pointX, pointY)
  end
  if pd.buttonJustPressed(pd.kButtonB) then
    if not infoWindowIsDrawn then
      infoWindowSprite:add()
      infoWindowIsDrawn = true
    else
      infoWindowSprite:remove()
      infoWindowIsDrawn = false
    end
  end
  return pos
end
