local pd <const> = playdate
local gfx <const> = pd.graphics

class('AtomSprite').extends(gfx.sprite)

function AtomSprite:init(x, y, name, locked, description)
    local atomImage = gfx.image.new('images/atoms/' .. name)
    self:setImage(atomImage)
    self:moveTo(x, y)
    self.x = x
    self.y = y

    self:setCollideRect(0, 0, self:getSize())

    self.vx = 0
    self.vy = 0
    self.ax = 0
    self.ay = 0

    self.locked = locked
    self.description = description
end

function AtomSprite:update()
    self:moveBy(self.vx, self.vy)
end

function AtomSprite:collisionResponse()
    return "overlap"
end
