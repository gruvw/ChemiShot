local pd <const> = playdate
local gfx <const> = pd.graphics

-- List of wheel constants
local CTR <const> = {pd.display.getWidth() / 2, pd.display.getHeight() / 2}
local wheelRadius <const> = 110
local lineWidth <const> = 8
local bubbleSize <const> = 20
local bubbleDrawingRadius <const> = 18
local dstCenter <const> = 80

local lockedImage <const> = gfx.image.new('images/lock.png')
local selectionImage <const> = gfx.image.new('images/selection.png')

local listAtoms = {
    {'H', false},
    {'O', false},
    {'C', true},
    {'Na', true},
    {'Cl', false},
    {'U', false}
}
local function compare(a, b)
    if a[2] then
        return false
    elseif b[2] then
        return true
    else
        return #a[1] > #b[1]
    end
end
table.sort(listAtoms, compare)

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
    for i, atom in pairs(listAtoms) do
        local bubbleImage = gfx.image.new(bubbleSize * 2, bubbleSize * 2)
        local bubbleSprite = gfx.sprite.new(bubbleImage)
        if not atom[2] then
            gfx.pushContext(bubbleImage)
            w, h = gfx.getTextSize(atom[1])
                gfx.drawText(atom[1], bubbleSize / 2 + w / 2, bubbleSize / 2 + 3)
                gfx.drawCircleAtPoint(bubbleSize, bubbleSize, bubbleDrawingRadius)
            gfx.popContext()
        else
            ---@diagnostic disable-next-line: param-type-mismatch
            bubbleSprite:setImage(lockedImage)
        end
        local nbAtoms = #listAtoms
            
        bubbleSprite:moveTo(
            CTR[1] + dstCenter * math.sin(2*math.pi / nbAtoms * (i-1)),
            CTR[2] - dstCenter * math.cos(2*math.pi / nbAtoms * (i-1))
        )
        bubbleSprite:add()
    end
end

function WheelUpdate()
    -- Turn the selector and find which atom it is
    local nbAtoms = #listAtoms
    local nbAtomsAvailable = 0
    for _, atom in pairs(listAtoms) do
        if not atom[2] then
            nbAtomsAvailable += 1
        end
    end
    local change, _ = pd.getCrankChange()
    selectAngle += math.rad(change)
    if selectAngle < 0 then
        selectAngle = 2 * math.pi - 2 * math.pi / nbAtoms * (nbAtomsAvailable - 1.5)
    end
    selectAngle = math.fmod(selectAngle, 2 * math.pi / nbAtoms * nbAtomsAvailable)
    local pos = selectAngle // (2*math.pi / nbAtoms)
    local pointX = CTR[1] + dstCenter * math.sin(2*math.pi / nbAtoms * pos)
    local pointY = CTR[2] - dstCenter * math.cos(2*math.pi / nbAtoms * pos)
    selectionSprite:moveTo(pointX, pointY)
end
