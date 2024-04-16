import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"

import "./intro/intro"
import "./logic/logic"

local pd <const> = playdate
local gfx <const> = pd.graphics

---@diagnostic disable-next-line: duplicate-set-field
function playdate.update()
    IntroUpdate()
    -- LogicUpdate()
end
