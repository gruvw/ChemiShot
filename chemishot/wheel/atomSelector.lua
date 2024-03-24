local pd <const> = playdate
local gfx <const> = pd.graphics

class("AtomSelector").extends(gfx.sprite)

---@diagnostic disable: undefined-global
function AtomSelector:init(symbol, locked)
    local bubbleSize = 5
    local bubbleImage = gfx.image.new(bubbleSize * 2, bubbleSize * 2)
    gfx.pushContext(bubbleImage)
        if not locked then
            gfx.drawCircleAtPoint(bubbleSize, bubbleSize, bubbleSize)
            gfx.drawText(symbol, bubbleSize, bubbleSize)
        else
            local lockedImage = gfx.image.new('images/lock.png')
            self:setImage(lockedImage)
            self:moveTo(bubbleSize, bubbleSize)
            self:add()
        end
    gfx.popContext()
end