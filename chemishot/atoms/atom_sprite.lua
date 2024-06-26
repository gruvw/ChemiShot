local pd <const> = playdate
local gfx <const> = pd.graphics

class('AtomSprite').extends(gfx.sprite)

function AtomSprite:init(x, y, name, locked, description)
    local atomImage = gfx.image.new('images/atoms/' .. name)
    self:setImage(atomImage)
    self:moveTo(x, y)
    self.x = x
    self.y = y
    self.name = name

    self.vx = 0
    self.vy = 0
    self.ax = 0
    self.ay = 0

    self.locked = locked
    self.description = description
end