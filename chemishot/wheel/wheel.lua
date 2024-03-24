local pd <const> = playdate
local gfx <const> = pd.graphics

-- List of wheel constants
local CTR <const> = {pd.display.getWidth() / 2, pd.display.getHeight() / 2}
local wheelRadius <const> = 110
local lineWidth <const> = 8
local bubbleSize <const> = 10
local dstCenter <const> = 80

local lockedImage <const> = gfx.image.new('images/lock.png')
local selectionImage <const> = gfx.image.new('images/selection.png')

local listAtoms = {
    {'H', false},
    {'O', false},
    {'C', true},
    {'Na', true},
    {'Cl', true}
}

local selectAngle = 0
local selectionSprite = gfx.sprite.new(selectionImage)
selectionSprite:add()

function initWheel()
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
        bubbleSprite:setZIndex(-1)
        if not atom[2] then
            gfx.pushContext(bubbleImage)
                gfx.drawText(atom[1], bubbleSize / 2, bubbleSize / 2)
            gfx.popContext()
        else
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
    change, _ = pd.getCrankChange()
    selectAngle += math.rad(change)
    selectAngle = math.fmod(selectAngle, 2 * math.pi)
    nbAtoms = #listAtoms
    if selectAngle < 0 then
        selectAngle = 2 * math.pi - selectAngle
    end
    pos = selectAngle // (2*math.pi / nbAtoms)
    pointX = CTR[1] + dstCenter * math.sin(2*math.pi / nbAtoms * pos)
    pointY = CTR[2] - dstCenter * math.cos(2*math.pi / nbAtoms * pos)
    selectionSprite:moveTo(pointX, pointY)
end
