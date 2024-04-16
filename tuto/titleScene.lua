import "scripts/game/gameScene"

local pd <const> = playdate
local gfx <const> = pd.graphics

class('TitleScene').extends(gfx.sprite)

function TitleScene:init()
    local wallsImage = gfx.image.new("images/title/walls")
    self.wallsSprite = gfx.sprite.new(wallsImage)
    self.wallsSprite:setCenter(0, 0)
    self.wallsSprite:add()
    local spikesImage = gfx.image.new("images/title/spikesImage")
    self.spikesSprite = gfx.sprite.new(spikesImage)
    self.spikesSprite:setCenter(0, 0)
    self.spikesSprite:add()
    local titleImage = gfx.image.new("images/title/title")
    self.titleSprite = gfx.sprite.new(titleImage) 
end