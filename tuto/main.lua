import "CoreLibs/graphics"

local gfx <const> = playdate.graphics

local posX = 0
local posY = 0

---@diagnostic disable-next-line: duplicate-set-field
function playdate.update()
  gfx.clear()
  posX = posX + 1
  posY = posY + 1
  gfx.fillRect(posX, posY, 10, 10)
end
