import "../atoms/atom_sprite"
import "../atoms/atoms"

local pd <const> = playdate
local gfx <const> = pd.graphics

-- List of wheel constants
local CTR <const> = {pd.display.getWidth() / 2, pd.display.getHeight() / 2}
local wheelRadius <const> = 110
local lineWidth <const> = 8
local bubbleSize <const> = 20
local dstCenter <const> = 80

local lockedImage <const> = gfx.image.new('images/lock.png')
local selectionImage <const> = gfx.image.new('images/selection.png')

local nbAtoms = #ATOMS
local nbAtomsAvail = 0
for _, atom in pairs(ATOMS) do
    if not atom.locked then
        nbAtomsAvail += 1
    end
end

-- local function compare(a, b)
--     if a.locked then
--         return false
--     elseif b.locked then
--         return true
--     else
--         return #a[1] > #b[1]
--     end
-- end
-- table.sort(ATOMS, compare)

local selectAngle = 0
local selectionSprite = gfx.sprite.new(selectionImage)
selectionSprite:setScale(1.5)
selectionSprite:add()

function InitWheel()
    selectAngle = 0

    -- Set background disk
    gfx.sprite.setBackgroundDrawingCallback(
        function (x, y, width, height)
            gfx.pushContext()
                gfx.setLineWidth(lineWidth)
                gfx.drawCircleAtPoint(CTR[1], CTR[2], wheelRadius)
            gfx.popContext()
        end
    )

    -- Prepare and place images for all atoms in list
    for i, atom in pairs(ATOMS) do
        local bubbleImage = gfx.image.new(bubbleSize * 2, bubbleSize * 2)
        local bubbleSprite = gfx.sprite.new(bubbleImage)
        if not atom.locked then
            bubbleSprite = atom
            bubbleSprite:setScale(0.8)
        else
            ---@diagnostic disable-next-line: param-type-mismatch
            bubbleSprite:setImage(lockedImage)
        end

        bubbleSprite:moveTo(
            CTR[1] + dstCenter * math.sin(2*math.pi / nbAtoms * (i-1)),
            CTR[2] - dstCenter * math.cos(2*math.pi / nbAtoms * (i-1))
        )
        bubbleSprite:add()
    end
end

function WheelUpdate()
    -- Turn the selector and find which atom it is
    local change, _ = pd.getCrankChange()
    selectAngle += math.rad(change)
    if selectAngle < 0 then
        selectAngle = 2 * math.pi - 2 * math.pi / nbAtoms * (nbAtomsAvail - nbAtomsAvail / nbAtoms)
    end
    selectAngle = math.fmod(selectAngle, 2 * math.pi / nbAtoms * nbAtomsAvail)
    local pos = selectAngle // (2*math.pi / nbAtoms)
    local pointX = CTR[1] + dstCenter * math.sin(2*math.pi / nbAtoms * pos)
    local pointY = CTR[2] - dstCenter * math.cos(2*math.pi / nbAtoms * pos)
    selectionSprite:moveTo(pointX, pointY)
    return pos
end
